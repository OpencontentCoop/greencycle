<?php

class GreencycleDataHandlerUserLanguages implements OpenPADataHandlerInterface
{
	public function __construct(array $Params)
	{		
	}

	public function getData()
	{				
		$user = eZUser::currentUser();
		$userObject = $user->contentObject();
		$otherLanguages = eZContentLanguage::prioritizedLanguageCodes();
		$mainLanguage = array_shift($otherLanguages);
		if ($userObject instanceof eZContentObject){
			$dataMap = $userObject->dataMap();
			if (isset($dataMap['priority_language']) && $dataMap['priority_language']->hasContent()){
				$mainLanguage = $dataMap['priority_language']->toString();
			}
			if (isset($dataMap['other_languages']) && $dataMap['other_languages']->hasContent()){
				$otherLanguages = (array)explode('|', $dataMap['other_languages']->toString());
			}
		}

		return [
			'main' => $mainLanguage,
			'others' => $otherLanguages
		];
	}
}