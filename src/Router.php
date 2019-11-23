<?php

namespace Wikicaptcha\Backend;


use Psr\Http\Message\ResponseInterface;
use Psr\Http\Message\ServerRequestInterface;
use Psr\Http\Server\MiddlewareInterface;
use Psr\Http\Server\RequestHandlerInterface;
use Zend\Diactoros\Response\JsonResponse;

class Router implements MiddlewareInterface {
	public function process(ServerRequestInterface $request, RequestHandlerInterface $handler): ResponseInterface {
		$dispatcher = \FastRoute\simpleDispatcher(
			function(\FastRoute\RouteCollector $r) {
				$r->get('/', Index::class);
				$r->get('/test', Test::class);
				$r->post('/questions', Questions::class);
				$r->put('/answers', Answers::class);
				$r->addRoute(['OPTIONS'], '/{any}', Cors::class);
			});

		$route = $dispatcher->dispatch($request->getMethod(), $request->getUri()->getPath());


		switch($route[0]) {
			case \FastRoute\Dispatcher::FOUND:
				/** @var MiddlewareInterface $method */
				$method = $route[1];
				$request = $request->withAttribute('Method', $method);
				return $handler->handle($request);
			default:
			case \FastRoute\Dispatcher::NOT_FOUND:
				return new JsonResponse(['error' => 'Not found'], 404);
			case \FastRoute\Dispatcher::METHOD_NOT_ALLOWED:
				return new JsonResponse(['error' => 'Method not allowed'], 405, ['Allow' => implode(', ', $route[1])]);
		}
	}
}
