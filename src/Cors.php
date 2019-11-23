<?php

namespace Wikicaptcha\Backend;


use Psr\Http\Message\ResponseInterface;
use Psr\Http\Message\ServerRequestInterface;
use Psr\Http\Server\RequestHandlerInterface;
use Zend\Diactoros\Response\EmptyResponse;

class Cors implements RequestHandlerInterface {

	public function handle(ServerRequestInterface $request): ResponseInterface {
		return new EmptyResponse(204, [
			'Access-Control-Allow-Origin' => '*',
			'Access-Control-Allow-Headers' => '*',
			'Access-Control-Allow-Methods' => '*',
			'Access-Control-Max-Age' => 86400,
		]);
	}
}
