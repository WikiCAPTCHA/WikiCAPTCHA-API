<?php
namespace Wikicaptcha\Backend;


class UserAnswerDto {
	private function __consruct() {

	}

	public static function fromArray(array $array): UserAnswerDto {
		$that = new UserAnswerDto();
		foreach($array as $k => $v) {
			$that->$k = $v;
		}
		return $that;
	}

	public static function fromParts(): UserAnswerDto {
		return new UserAnswerDto();
	}

	public function jsonSerialize() {
		$result = [];
		foreach($this as $k => $v) {
			$result[$k] = $v;
		}
		return $result;
	}
}
