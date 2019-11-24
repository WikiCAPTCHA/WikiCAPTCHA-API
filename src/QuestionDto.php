<?php

namespace Wikicaptcha\Backend;


use \InvalidArgumentException;

class QuestionDto implements \JsonSerializable {
	const QUESTION_TYPES = [
		'IMG' => 'IMG',
		'INPUT' => 'INPUT',  // free text
		'OPTIONS' => 'OPTIONS'
	];

	private function __consruct() {

	}

	protected $questionText;
	protected $questionId;
	protected $questionType;
	protected $answersAvailable;

	public static function fromParts(string $id, string $text, string $type, array $answersAvailable): QuestionDto {
		$that = new QuestionDto();
		$that->questionId = $id;
		$that->questionText = $text;
		$that->setQuestionType($type);
		$that->setAnswersAvailable($answersAvailable);
		return $that;
	}

	protected function setQuestionType(string $questionType) {
		if(!isset(self::QUESTION_TYPES[$questionType])) {
			throw new InvalidArgumentException("$questionType is not a valid question type");
		}
		$this->questionType = $questionType;
	}

	protected function setAnswersAvailable(array $answersAvailable) {
		foreach($answersAvailable as $item) {
			if(!($item instanceof AnswerDto)) {
				throw new InvalidArgumentException("answersAvailable must be instanceof AnswerDto");
			}
		}
		$this->answersAvailable = $answersAvailable;
	}

	public static function fromArray(array $array): QuestionDto {
		$a = [];
		foreach($array['answersAvailable'] as $el) {
			$a[] = AnswerDto::fromArray($el);
		}
		return self::fromParts($array['questionId'], $array['questionText'], $array['questionType'], $a);
	}


	public function jsonSerialize() {
		$result = [];
		$result['questionText'] = $this->questionText;
		$result['questionId'] = $this->questionId;
		$result['questionType'] = $this->questionType;
		$result['answersAvailable'] = $this->answersAvailable;
		return $result;
	}
}
