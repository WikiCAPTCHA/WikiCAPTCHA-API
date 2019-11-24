<?php

namespace Wikicaptcha\Backend;


class Database {
	private $pdo;

	public function __construct() {
		$this->pdo = new \PDO('mysql:host=192.168.1.22;dbname=wikicaptcha', 'wikicaptcha', 'wikicaptcha');
	}

	public function getPdo() {
		return $this->pdo;
	}
}
