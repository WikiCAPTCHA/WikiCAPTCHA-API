<?php

namespace Wikicaptcha\Backend;


class AnswerDto implements \JsonSerializable {
	private $imgUrl;
	private $text;
	private $userAnswer;

	private function __consruct() {

	}

	public static function fromParts(string $imgUrl, string $text, ?array $userAnswer = null): AnswerDto {
		$that = new AnswerDto();
		$that->imgUrl = $imgUrl;
		$that->text = $text;
		if($userAnswer !== null) {
			$that->userAnswer = UserAnswerDto::fromArray($userAnswer);
		}
		return $that;
	}

	public static function fromArray(array $array): AnswerDto {
		if(isset($array['userAnswer'])) {
			return self::fromParts($array['imgUrl'], $array['text'], $array['userAnswer']);
		} else {
			return self::fromParts($array['imgUrl'], $array['text']);
		}
	}

	public function jsonSerialize() {
		$result = [];
		if($this->userAnswer !== null) {
			$result['userAnswer'] = $this->userAnswer;
		}
		$result['imgUrl'] = $this->imgUrl;
		$result['text'] = $this->text;
		return $result;
	}
}
