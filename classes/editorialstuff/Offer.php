<?php

class Offer extends Request
{
	public static function fromId($id)
    {
        $factory = OCEditorialStuffHandler::instance('offer', array())->getFactory();

        return $factory->instancePost(
            array('object_id' => $id),
            $factory
        );
    }
}