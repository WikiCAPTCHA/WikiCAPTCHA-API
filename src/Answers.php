<?php

namespace Wikicaptcha\Backend;


use Psr\Http\Message\ResponseInterface;
use Psr\Http\Message\ServerRequestInterface;
use Psr\Http\Server\RequestHandlerInterface;
use Zend\Diactoros\Response\JsonResponse;

class Answers implements RequestHandlerInterface {
	public function handle(ServerRequestInterface $request): ResponseInterface {
		$payload = $request->getAttribute('ParsedBody', []);

		$questions = WikiApiDto::fromArray($payload);

		// TODO: check that user is a human or a bot

		return new JsonResponse($questions);
	}
}