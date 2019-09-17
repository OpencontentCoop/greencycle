<?php

class Organization extends OCEditorialStuffPostDefault
{
    public static function fromId($id)
    {
        $factory = OCEditorialStuffHandler::instance('private_organization', array())->getFactory();

        return $factory->instancePost(
            array('object_id' => $id),
            $factory
        );
    }

    public function attributes()
    {
        $attributes = parent::attributes();
        $attributes[] = 'is_published';

        return $attributes;
    }

    public function attribute($property)
    {
        if ($property == 'is_published') {
            return $this->is('published');
        }

        return parent::attribute($property);
    }

    public function onBeforeCreate()
    {
        $this->assignSection();
        $this->deactivateUser();
    }

    public function onUpdate()
    {
        $this->assignSection();        
        $this->setObjectLastModified();
        $this->flushObject();
        eZContentCacheManager::clearObjectViewCache($this->id());        
    }

    public function onChangeState(
        eZContentObjectState $beforeState,
        eZContentObjectState $afterState
    ){
        if ($afterState->attribute('identifier') == 'published'){
            $this->activateUser();
        }else{
            $this->deactivateUser();
        }

        $this->actionHandler->handleChangeState( $this, $beforeState, $afterState );
    }

    private function assignSection()
    {
        if (isset($this->dataMap['municipality'])){
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

    private function getSectionByMunicipalityId($municipalityId)
    {
        $municipality = eZContentObject::fetch((int)$municipalityId);
        if ($municipality instanceof eZContentObject){
            $group = $this->createGroupIfNeeded($municipality);
            $section = OpenPABase::initSection(
                $municipality->attribute('name'),
                'municipality_' . $municipalityId
            );
            if ($section && $group){
                $this->assignRoleBySectionToGroup($section, $group);
            }

            return $section;
        }

        return false;
    }

    private function deactivateUser()
    {
        $userSetting = eZUserSetting::fetch((int)$this->id());
        if ($userSetting instanceof eZUserSetting){
            $userSetting->setAttribute('is_enabled', 0);
            $userSetting->store();
            eZUser::removeSessionData($this->id());
            eZContentCacheManager::clearContentCacheIfNeeded($this->id());
        }
    }

    private function activateUser()
    {
        $userSetting = eZUserSetting::fetch((int)$this->id());
        if ($userSetting instanceof eZUserSetting){
            $userSetting->setAttribute('is_enabled', 1);
            $userSetting->store();
            eZUser::removeSessionData($this->id());
            eZContentCacheManager::clearContentCacheIfNeeded($this->id());
        }
    }

    private function createGroupIfNeeded(eZContentObject $municipality, $mainGroupNodeId = 8328)
    {
        $remoteId = 'municipality_group_' . $municipality->attribute('id');
        $group = eZContentObject::fetchByRemoteID($remoteId);
        if (!$group instanceof eZContentObject){
            $name = 'CEManagers ' . $municipality->attribute('name');
            $params = array();            
            $params['remote_id'] = $remoteId;
            $params['class_identifier'] = 'user_group';
            $params['parent_node_id'] = $mainGroupNodeId;
            $params['attributes'] = array(
                'name' => $name
            );
            $group = eZContentFunctions::createAndPublishObject($params);
        }

        return $group;
    }

    private function assignRoleBySectionToGroup(eZSection $section, eZContentObject $group)
    {
        $role = eZRole::fetchByName('CEManagers');
        if ($role instanceof eZRole){
            $role->assignToUser($group->attribute('id'), 'section', $section->attribute('id'));  
        }
    }
}
