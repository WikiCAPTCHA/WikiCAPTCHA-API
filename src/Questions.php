<?php

namespace Wikicaptcha\Backend;


use Psr\Http\Message\ResponseInterface;
use Psr\Http\Message\ServerRequestInterface;
use Psr\Http\Server\MiddlewareInterface;
use Psr\Http\Server\RequestHandlerInterface;
use Zend\Diactoros\Response\JsonResponse;

class Questions implements MiddlewareInterface {

	public function process(ServerRequestInterface $request, RequestHandlerInterface $handler): ResponseInterface {
		$payload = $request->getAttribute('ParsedBody', []);

		if(!isset($payload['language'])) {
			return new JsonResponse(['error' => 'Add language to request', 400]);
		}

		// TODO: query database
		$id = 123;

		$response = [
			'sessionId' => $id,

		];
	}
}
