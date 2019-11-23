<?php

namespace Wikicaptcha\Backend;


use Psr\Http\Message\ResponseInterface;
use Psr\Http\Message\ServerRequestInterface;
use Psr\Http\Server\RequestHandlerInterface;
use Zend\Diactoros\Response\TextResponse;

class Index implements RequestHandlerInterface {
	public function handle(ServerRequestInterface $request): ResponseInterface {
		return new TextResponse('Wikicaptcha is alive!');
	}
}