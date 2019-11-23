<?php
namespace Wikicaptcha\Backend;


class UserAnswerDto extends AnswerDto {
	private function __consruct() {

	}

	public static function fromArray(array $array): AnswerDto {
		$userAnswerDto = parent::fromArray($array);
		foreach($array as $k => $v) {
			$userAnswerDto->$k = $v;
		}
		return $userAnswerDto;
	}

	public function jsonSerialize() {
		$result = parent::jsonSerialize();
		foreach($this as $k => $v) {
			$result[$k] = $v;
		}
		return $result;
	}
}
