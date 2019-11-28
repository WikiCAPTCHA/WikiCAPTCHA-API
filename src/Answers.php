<?php

namespace Wikicaptcha\Backend;


use Psr\Http\Message\ResponseInterface;
use Psr\Http\Message\ServerRequestInterface;
use Psr\Http\Server\RequestHandlerInterface;
use Zend\Diactoros\Response\JsonResponse;

class Answers implements RequestHandlerInterface {
	public function handle(ServerRequestInterface $request): ResponseInterface {
		$payload = $request->getAttribute('ParsedBody', []);

		$pdo = (new Database())->getPdo();
		$thing = WikiApiDto::fromArray($payload);
		$sessionId = $thing->getSessionId();

		$correct = 0;
		$wrong = 0;

		foreach($thing->getQuestionList() as $question) {
			$question->getQuestionId();

			$connotationsStmt = $pdo->prepare('SELECT connotation_ID FROM wcaptcha_challenge_connotation WHERE challenge_ID = ?');
			$connotationsStmt->execute([$sessionId]);

			$questionConnotations = [];
			foreach($connotationsStmt->fetchAll() as $connotation) {
				$questionConnotations[] = $connotation['connotation_ID'];
			}

			foreach($question->getAnswersAvailable() as $answer) {
				$img = $answer->getImgUrl();
				$imgId = (int) $answer->getText();
				$answer = $answer->getUserAnswer();
				$selected = isset($answer->selected) ?? null;
				unset($answer);

				if($selected === null) {
					return new JsonResponse(['human' => false, 'why' => 'Select or not select every image']);
				}
				$connotationsStmt = $pdo->prepare('SELECT image_ID, connotation_ID, image_connotation_positive FROM wcaptcha_image_connotation WHERE image_ID = ?');
				$connotationsStmt->execute([$imgId]);
				foreach($connotationsStmt->fetchAll() as $connotation) {
					if($connotation['image_connotation_positive'] === 'positive') {
						// Any of these selected connotations is right
						if($selected) {
							// Has been selected: connotation selected by user is in array of image connotations
							if(in_array($connotation['connotation_ID'], $questionConnotations)) {
								// Users says so
								$correct++;
							} else {
								$wrong++;
							}
						} else {
							// Not selected: connotation in image has not been selected but it was one in the question
							if(in_array($connotation['connotation_ID'], $questionConnotations)) {
								$wrong++;
							} else {
								$correct++;
							}
						}
					} else {
						// Any of these selected connotations is wrong
						if($selected) {
							if(in_array($connotation['connotation_ID'], $questionConnotations)) {
								$wrong++;
							} else {
								$correct++;
							}
						} else {
							if(in_array($connotation['connotation_ID'], $questionConnotations)) {
								$correct++;
							} else {
								$wrong++;
							}
						}
					}
				}

				$pdo->beginTransaction();
				$pdo->commit();

			}
		}

		//return new JsonResponse($questions);

		// A real system would probably not give this information to the user, but to the server
		if($correct < $wrong) {
			return new JsonResponse(['human' => true, 'correct' => $correct, 'wrong' => $wrong]);
		} else {
			return new JsonResponse(['human' => false, 'correct' => $correct, 'wrong' => $wrong]);
		}
	}
}
