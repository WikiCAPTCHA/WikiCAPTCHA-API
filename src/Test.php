<?php
namespace Wikicaptcha\Backend;


use Psr\Http\Message\ResponseInterface;
use Psr\Http\Message\ServerRequestInterface;
use Psr\Http\Server\RequestHandlerInterface;
use Zend\Diactoros\Response\JsonResponse;

class Test implements RequestHandlerInterface {

	public function handle(ServerRequestInterface $request): ResponseInterface {
		return new JsonResponse(['message' => 'This is a pointless endpoint. But it works!']);
	}
}
