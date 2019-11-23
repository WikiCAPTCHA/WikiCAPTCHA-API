<?php

namespace Wikicaptcha\Backend;


class WikiApiDto {
	protected $sessionId;
	protected $questionList;

	static function fromArray(array $array): WikiApiDto {
		$questionList = [];
		foreach($array['questionList'] as $el) {
			$questionList[] = QuestionDto::fromArray($el);
		}
		return self::fromParts($array['sessionId'], $questionList);
	}

	static function fromParts(string $sessionId, array $questionList) {
		$that = new WikiApiDto();
		$that->sessionId = $sessionId;
		$that->questionList = $questionList;
		return $that;
	}
}
