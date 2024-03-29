<?php

use Zend\Diactoros\ServerRequestFactory;
use Zend\HttpHandlerRunner\Emitter\SapiEmitter;


// in case something goes wrong (should get changed when sending a response)
http_response_code(500);
require __DIR__ . DIRECTORY_SEPARATOR .  '..' . DIRECTORY_SEPARATOR . 'vendor' . DIRECTORY_SEPARATOR . 'autoload.php';
//require __DIR__ . DIRECTORY_SEPARATOR . '..' . DIRECTORY_SEPARATOR . 'config' . DIRECTORY_SEPARATOR . 'config.php';

$request = ServerRequestFactory::fromGlobals();

header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Methods: *");
header("Access-Control-Allow-Headers: *");

$response = (new Wikicaptcha\Backend\Controller())->handle($request);

(new SapiEmitter())->emit($response);