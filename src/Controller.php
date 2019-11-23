<?php

namespace Wikicaptcha\Backend;

use Psr\Http\Message\ResponseInterface;
use Psr\Http\Message\ServerRequestInterface;
use Psr\Http\Server\RequestHandlerInterface;
use Relay\RelayBuilder;

class Controller implements RequestHandlerInterface {

	public function handle(ServerRequestInterface $request): ResponseInterface {
		$queue = [
			new ErrorHandler(),
			new Router(),
			new EnsureJson(),
			new DatabaseConnection(),
			new DoWork(),
		];

		$relayBuilder = new RelayBuilder();
		$relay = $relayBuilder->newInstance($queue);

		return $relay->handle($request);
	}
}