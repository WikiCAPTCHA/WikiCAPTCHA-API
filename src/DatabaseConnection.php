<?php

namespace Wikicaptcha\Backend;

use Psr\Http\Message\ResponseInterface;
use Psr\Http\Message\ServerRequestInterface;
use Psr\Http\Server\MiddlewareInterface;
use Psr\Http\Server\RequestHandlerInterface;

class DatabaseConnection implements MiddlewareInterface {
	public function process(ServerRequestInterface $request, RequestHandlerInterface $handler): ResponseInterface {
		$db = null; //new Database('', '', '');

		$request = $request->withAttribute('Database', $db);
		return $handler->handle($request);
	}
}
