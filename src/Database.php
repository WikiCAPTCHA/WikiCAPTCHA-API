<?php

namespace Wikicaptcha\Backend;


class Database {
	private $pdo;

	public function __construct() {
		$options = [
			\PDO::ATTR_ERRMODE            => \PDO::ERRMODE_EXCEPTION,
			\PDO::ATTR_DEFAULT_FETCH_MODE => \PDO::FETCH_ASSOC,
			\PDO::ATTR_EMULATE_PREPARES   => false,
		];
		$this->pdo = new \PDO('mysql:host=192.168.69.1;dbname=wikicaptcha', 'wikicaptcha', 'ahvahl8MefoaPh2vui8aewaNgiehei', $options);
	}

	public function getPdo() {
		return $this->pdo;
	}
}
