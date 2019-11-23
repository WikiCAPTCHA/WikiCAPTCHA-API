<?php


namespace Wikicaptcha\Backend;


use Psr\Http\Message\ResponseInterface;
use Psr\Http\Message\ServerRequestInterface;
use Psr\Http\Server\MiddlewareInterface;
use Psr\Http\Server\RequestHandlerInterface;
use Zend\Diactoros\Response\TextResponse;

class ErrorHandler implements MiddlewareInterface {
	public function process(ServerRequestInterface $request, RequestHandlerInterface $handler): ResponseInterface {
		try {
			return $handler->handle($request);
		} catch(\Throwable $exception) {
			$short = "⚠️ Error ⚠️\n\n" . get_class($exception);
			$full = $short . ': ' . $exception->getMessage() . ' in ' .
				$exception->getFile() . ' on line ' . $exception->getLine() . "\n\nStack trace:\n" .
				$exception->getTraceAsString();

			return new TextResponse($full, 500);
		}
	}
}
