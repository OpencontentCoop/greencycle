<?php

class Request extends OCEditorialStuffPostDefault implements OCEditorialStuffPostInputActionInterface
{
    public function tabs()
    {
        $currentUser = eZUser::currentUser();
        $templatePath = $this->getFactory()->getTemplateDirectory();
        $tabs = array(
            array(
                'identifier' => 'content',
                'name' => ezpI18n::tr('editorialstuff/dashboard', 'Content'),
                'template_uri' => "design:{$templatePath}/parts/content.tpl"
            )
        );
        
        $tabs[] = array(
            'identifier' => 'reservations',
            'name' => ezpI18n::tr('editorialstuff/dashboard', 'Reservations'),
            'template_uri' => "design:{$templatePath}/parts/reservations.tpl"
        );

        $tabs[] = array(
            'identifier' => 'history',
            'name' => ezpI18n::tr('editorialstuff/dashboard', 'History'),
            'template_uri' => "design:{$templatePath}/parts/history.tpl"
        );

        return $tabs;
    }

    public static function fromId($id)
    {
        $factory = OCEditorialStuffHandler::instance('request', array())->getFactory();

        return $factory->instancePost(
            array('object_id' => $id),
            $factory
        );
    }

    public function addReservation()
    {        
        if (isset($this->dataMap['current_reservation']) && !$this->dataMap['current_reservation']->hasContent()){
            if ($this->is('published')){
                
                $now = time();
                $expiration = $now + (60*60*24*15); //15 giorni

                $reservation = eZContentFunctions::createAndPublishObject([
                    'creator_id' => eZUser::currentUserID(),
                    'class_identifier' => 'reservation',
                    'parent_node_id' => $this->object->attribute('main_node_id'),
                    'attributes' => [
                        'subject' => $this->object->attribute('id'),
                        'expiration' => $expiration
                    ]
                ]);

                if ($reservation instanceof eZContentObject){
                    $this->dataMap['current_reservation']->fromString($reservation->attribute('id'));
                    $this->dataMap['current_reservation']->store();
                    
                    OCEditorialStuffHistory::addHistoryToObjectId( 
                        $this->object->attribute( 'id' ), 
                        'addreservation', 
                        array('object_id' => $reservation->attribute('id'), 'reservation' => $reservation->attribute('id')) 
                    );

                    $owner = eZUser::fetch((int)$this->object->attribute('owner_id'));
                    if ($owner){
                        OCEditorialStuffActionHandler::sendMail(
                            $this,
                            array($owner),
                            'design:editorialstuff/mail/add_reservation_notify_owner.tpl',
                            array(
                                'post' => $post,
                                'reservation' => $reservation
                            )
                        );
                    }

                    eZContentCacheManager::clearContentCache($this->object->attribute('id'));
                    $this->object->setAttribute('modified', time());
                    $this->object->store();
                    eZSearch::addObject($this->object, true);     

                    return true;               
                }
            }
        }

        return false;
    }

    public function approveReservation()
    {
        if (isset($this->dataMap['current_reservation']) && $this->dataMap['current_reservation']->hasContent()){
            
            $reservation = $this->dataMap['current_reservation']->content();
            $reservationDataMap = $reservation->dataMap();
            $reservationOwner = eZUser::fetch((int)$reservation->attribute('owner_id'));
            $reservationDataMap['approved']->setAttribute('data_int', 1);
            $reservationDataMap['approved']->store();
            
            OCEditorialStuffHistory::addHistoryToObjectId( 
                $this->object->attribute( 'id' ), 
                'approvereservation', 
                array('object_id' => $reservation->attribute('id'), 'reservation' => $reservation->attribute('id')) 
            );

            if ($reservationOwner){
                OCEditorialStuffActionHandler::sendMail(
                    $this,
                    array($reservationOwner),
                    'design:editorialstuff/mail/approve_reservation_notify_reservation_owner.tpl',
                    array(
                        'post' => $this,
                        'reservation' => $reservation
                    )
                );
            }

            eZContentCacheManager::clearContentCache($this->object->attribute('id'));
            $this->object->setAttribute('modified', time());
            $this->object->store();
            eZSearch::addObject($this->object, true); 
        }
    }

    public function rejectReservation()
    {
        if (isset($this->dataMap['current_reservation']) && $this->dataMap['current_reservation']->hasContent()){
            
            $reservation = $this->dataMap['current_reservation']->content();
            $reservationDataMap = $reservation->dataMap();
            $reservationOwner = eZUser::fetch((int)$reservation->attribute('owner_id'));
            $reservationDataMap['rejected']->setAttribute('data_int', 1);
            $reservationDataMap['rejected']->store();

            $this->dataMap['current_reservation']->dataType()->removeContentObjectRelation($this->dataMap['current_reservation']);
            $this->dataMap['current_reservation']->setAttribute( 'data_int', 0 );
            $this->dataMap['current_reservation']->store();

            OCEditorialStuffHistory::addHistoryToObjectId( 
                $this->object->attribute( 'id' ), 
                'rejectreservation', 
                array('object_id' => $reservation->attribute('id'), 'reservation' => $reservation->attribute('id')) 
            );
            
            if ($reservationOwner){
                OCEditorialStuffActionHandler::sendMail(
                    $this,
                    array($reservationOwner),
                    'design:editorialstuff/mail/reject_reservation_notify_reservation_owner.tpl',
                    array(
                        'post' => $this,
                        'reservation' => $reservation
                    )
                );
            }

            eZContentCacheManager::clearContentCache($this->object->attribute('id'));
            $this->object->setAttribute('modified', time());
            $this->object->store();
            eZSearch::addObject($this->object, true); 
        }
    }

    public function executeAction($actionIdentifier, $actionParameters, eZModule $module = null)
    {
        if ($actionIdentifier == 'ActionApproveReservation') {
            $this->approveReservation();
        }

        if ($actionIdentifier == 'ActionRejectReservation') {
            $this->rejectReservation();
        }

        if ($module) {
            $module->redirectTo("editorialstuff/edit/{$this->getFactory()->identifier()}/{$this->id()}#tab_reservations");
        }
    }

    public function onBeforeCreate()
    {
        $this->assignSection();
        $this->fixOwner();
    }

    public function onUpdate()
    {        
        $this->assignSection();     
        $this->fixOwner();
        $this->setObjectLastModified();
        $this->flushObject();
        eZContentCacheManager::clearObjectViewCache($this->id());        
    }

    protected function assignSection()
    {
        $owner = $this->getObject()->owner();
        if ($owner instanceof eZContentObject){
			$sectionIdentifier = $owner->sectionIdentifier();
        	
            if (strpos($sectionIdentifier, 'municipality_') !== false){
                $this->getObject()->setAttribute('section_id', $owner->attribute('section_id'));
                $this->getObject()->store();
            
            }elseif (isset($this->dataMap['municipality'])){
                $municipalityIdList = explode('-', $this->dataMap['municipality']->toString());
                foreach ($municipalityIdList as $municipalityId) {
                    $section = $this->getSectionByMunicipalityId($municipalityId);
                    if ($section instanceof eZSection){
                        $this->getObject()->setAttribute('section_id', $section->attribute('id'));
                        $this->getObject()->store();
                    }
                    break;
                }
            }
        }        
    }

    protected function fixOwner()
    {
        $owner = $this->getObject()->attribute('owner_id');

        $organizationId = 0;
        if (isset($this->dataMap['organization'])){
            $organizationIdList = explode('-', $this->dataMap['organization']->toString());
            $organizationId = array_shift($organizationIdList);
        }

        if ($organizationId > 0 && $ownerId != $organizationId){
            $this->getObject()->setAttribute('owner_id', $organizationId);
            $this->getObject()->store();
        }
    }

    protected function getSectionByMunicipalityId($municipalityId)
    {
        $municipality = eZContentObject::fetch((int)$municipalityId);
        if ($municipality instanceof eZContentObject){
            $section = OpenPABase::initSection(
                $municipality->attribute('name'),
                'municipality_' . $municipalityId
            );

            return $section;
        }

        return false;
    }

    public static function expireReservations($cli = null)
    {
        $reservations = eZContentObjectTreeNode::subTreeByNodeID([
            'ClassFilterType' => 'include',
            'ClassFilterArray' => array('reservation'),
            'Limitation' => array(),
            'AttributeFilter' => array( 'and',
                ["reservation/expiration", '<=', time()],
                ["reservation/approved", '=', 0],
                ["reservation/rejected", '=', 0] 
            )
        ], 1);

        foreach ($reservations as $reservation) {
            $parent = $reservation->fetchParent();            
            $request = self::fromId($parent->attribute('contentobject_id'));
            $request->rejectReservation();

            $reservationDataMap = $reservation->attribute('data_map');
            $reservationDataMap['rejected']->setAttribute('data_int', 1);
            $reservationDataMap['rejected']->store();

            if ($cli){
                $cli->output($parent->attribute('name'));
            }
        }
    }

}