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

		// TODO: query database
		$id = 123;
		$questions = [];
		for($i = 0; $i < 3; $i++) {
			$answers = [];
			$answers[0] = AnswerDto::fromParts('https://upload.wikimedia.org/wikipedia/commons/thumb/d/d4/George-W-Bush.jpeg/440px-George-W-Bush.jpeg', 'This is some text');
			$answers[1] = AnswerDto::fromParts('https://upload.wikimedia.org/wikipedia/commons/thumb/d/d4/George-W-Bush.jpeg/440px-George-W-Bush.jpeg', 'This is some text');
			$answers[2] = AnswerDto::fromParts('https://upload.wikimedia.org/wikipedia/commons/thumb/d/d4/George-W-Bush.jpeg/440px-George-W-Bush.jpeg', 'This is some text');
			$answers[3] = AnswerDto::fromParts('https://upload.wikimedia.org/wikipedia/commons/thumb/8/8d/President_Barack_Obama.jpg/440px-President_Barack_Obama.jpg', 'This is some text');
			$answers[4] = AnswerDto::fromParts('https://upload.wikimedia.org/wikipedia/commons/thumb/5/56/Donald_Trump_official_portrait.jpg/440px-Donald_Trump_official_portrait.jpg', 'This is some text');
			$answers[5] = AnswerDto::fromParts('https://upload.wikimedia.org/wikipedia/commons/thumb/5/56/Donald_Trump_official_portrait.jpg/440px-Donald_Trump_official_portrait.jpg', 'This is some text');
			$answers[6] = AnswerDto::fromParts('https://upload.wikimedia.org/wikipedia/commons/thumb/5/56/Donald_Trump_official_portrait.jpg/440px-Donald_Trump_official_portrait.jpg', 'This is some text');
			$answers[7] = AnswerDto::fromParts('https://upload.wikimedia.org/wikipedia/commons/thumb/5/56/Donald_Trump_official_portrait.jpg/440px-Donald_Trump_official_portrait.jpg', 'This is some text');
			$answers[8] = AnswerDto::fromParts('https://upload.wikimedia.org/wikipedia/commons/thumb/5/56/Donald_Trump_official_portrait.jpg/440px-Donald_Trump_official_portrait.jpg', 'This is some text');
			$questions[$i] = QuestionDto::fromParts('q' . mt_rand(100, 999), 'Which one of these persons is Barack Obama?', QuestionDto::QUESTION_TYPES['IMG'], $answers);
		}

		return new JsonResponse(WikiApiDto::fromParts($id, $questions), 200);
	}
}
