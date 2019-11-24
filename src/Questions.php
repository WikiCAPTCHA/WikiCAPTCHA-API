<?php

namespace Wikicaptcha\Backend;


use Psr\Http\Message\ResponseInterface;
use Psr\Http\Message\ServerRequestInterface;
use Psr\Http\Server\RequestHandlerInterface;
use Zend\Diactoros\Response\JsonResponse;

class Questions implements RequestHandlerInterface {

	public function handle(ServerRequestInterface $request): ResponseInterface {
		$payload = $request->getAttribute('ParsedBody', []);

		if(!isset($payload['language'])) {
			return new JsonResponse(['error' => 'Add language to request'], 400);
		}
		if(!isset($payload['appid'])) {
			return new JsonResponse(['error' => 'Add appid to request'], 400);
		}

		$pdo = (new Database())->getPdo();
		$pdo->beginTransaction();

		$ip = inet_pton($_SERVER['REMOTE_ADDR']);
		$s = $pdo->prepare('INSERT INTO wcaptcha_session(session_ip, app_id) VALUES (?, ?)');
		$s->execute([$ip, (int) $payload['appid']]);
		$id = $pdo->lastInsertId();

		$pdo->commit();

		$questions = [];
		$challengeRows = $pdo->query('SELECT challenge_ID, challenge_type, challenge_text FROM wcaptcha_challenge ORDER BY RAND() LIMIT 2');
		$total = 9;
		$actual = mt_rand(2, 8);
		foreach($challengeRows as $challenge) {
			switch($challenge['challenge_type']) {
				case 'img':
					$type = QuestionDto::QUESTION_TYPES['IMG'];
					break;
				case 'text':
				default:
					$type = QuestionDto::QUESTION_TYPES['INPUT'];
					break;
				case 'option':
					$type = QuestionDto::QUESTION_TYPES['OPTIONS'];
					break;
			}

			$answers = [];
			$already = [];

			if($type === QuestionDto::QUESTION_TYPES['IMG']) {

				// Actual images

				$imageRows = $pdo->prepare('
SELECT image_ID, image_src
FROM         wcaptcha_challenge_connotation
NATURAL JOIN wcaptcha_image_connotation
NATURAL JOIN wcaptcha_image
WHERE wcaptcha_challenge_connotation.challenge_ID = ?
GROUP BY image_ID, image_src
ORDER BY COUNT(*) DESC
LIMIT ?
');
				$imageRows->execute([$challenge['challenge_ID'], $actual]);
				foreach($imageRows->fetchAll() as $image) {
					// $filename = array_reverse(explode('/', $image['image_src']))[0];
					// $answers[] = AnswerDto::fromParts($image['image_src'] . '/' . "/200px-$filename", (string) $image['image_ID']);
					$answers[] = AnswerDto::fromParts($image['image_src'], (string) $image['image_ID']);
					$already[] = $image['image_ID'];
				}

				$actual = count($already);
				$random = $total - $actual;

				if($actual <= 0) {
					throw new \LogicException('No answers for challenge ' . $challenge['challenge_ID']);
				}

				// Random images

				$questionMarks = [];
				foreach($already as $ignored) {
					$questionMarks[] = '?';
				}
				unset($ignored);

				$stmt = '
SELECT image_ID, image_src
FROM wcaptcha_image
WHERE image_ID NOT IN (' . implode(', ', $questionMarks) .')
ORDER BY RAND()
LIMIT ?';
				$params = array_merge($already, [$random]);

				$imageRows2 = $pdo->prepare($stmt);
				$imageRows2->execute($params);
				foreach($imageRows2->fetchAll() as $image) {
					$answers[] = AnswerDto::fromParts($image['image_src'], 'No text for you');
				}
			} else {
				throw new \LogicException('Not implemented');
			}

			shuffle($answers);
			$questions[] = QuestionDto::fromParts($challenge['challenge_ID'], $challenge['challenge_text'], $type, $answers);
		}

		return new JsonResponse(WikiApiDto::fromParts($id, $questions), 200);
	}
}
