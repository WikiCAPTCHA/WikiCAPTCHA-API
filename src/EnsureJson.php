<?php

namespace Wikicaptcha\Backend;


use Psr\Http\Message\ResponseInterface;
use Psr\Http\Message\ServerRequestInterface;
use Psr\Http\Server\MiddlewareInterface;
use Psr\Http\Server\RequestHandlerInterface;
use Zend\Diactoros\Response\JsonResponse;
use Zend\Diactoros\Response\TextResponse;

class EnsureJson implements MiddlewareInterface {

	public function process(ServerRequestInterface $request, RequestHandlerInterface $handler): ResponseInterface {
		$method = $request->getMethod();
		if($method === 'POST' || $method === 'PUT' || $method === 'PATCH') {
			/** @noinspection PhpUndefinedMethodInspection it exists. */
			if(explode(';', $request->getHeaderLine('content-type') ?? '', 2)[0] !== 'application/json') {
				return new TextResponse('Request body must contain JSON, check your Content-Type', 415);
			}
			$json = $request->getBody()->getContents();
			$json = json_decode($json, true);
			if($json === null) {
				return new JsonResponse(['error' => 'Cannot decode request body: ' . json_last_error_msg()], 400);
			}
			$request = $request->withAttribute('ParsedBody', $json);
		}

		return $handler->handle($request);
	}
}
