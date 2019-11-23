<?php

namespace Wikicaptcha\Backend;


class AnswerDto implements \JsonSerializable {
	private $imgUrl;
	private $text;

	public static function fromParts(string $imgUrl, string $text): AnswerDto {
		$that = new AnswerDto();
		$that->imgUrl = $imgUrl;
		$that->text = $text;
		return $that;
	}

	public static function fromArray(array $array): AnswerDto {
		return self::fromParts($array['imgUrl'], $array['text']);
	}

	public function jsonSerialize() {
		$result = [];
		$result['imgUrl'] = $this->imgUrl;
		$result['text'] = $this->text;
		return $result;
	}
}