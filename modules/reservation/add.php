<?php
/** @var eZModule $module */
$module = $Params['Module'];

$objectId = $Params['ID'];
$object = eZContentObject::fetch((int)$objectId);

if ($object instanceof eZContentObject){
	if (in_array($object->attribute('class_identifier'), array('offer', 'request'))){
		
		$editorialStuffObject = false;
		if ($object->attribute('class_identifier') == 'offer'){
			$editorialStuffObject = Offer::fromId($objectId);
		}elseif ($object->attribute('class_identifier') == 'request'){
			$editorialStuffObject = Request::fromId($objectId);
		}

		if ($editorialStuffObject instanceof OCEditorialStuffPostDefault && $editorialStuffObject->addReservation()){
			$mainNode = $object->attribute('main_node');
			$module->redirectTo($mainNode->attribute('url_alias'));
			return;
		}
	}
}

return $module->handleError( eZError::KERNEL_ACCESS_DENIED, 'kernel' );