<?php

class Request extends OCEditorialStuffPostDefault
{
    public function onBeforeCreate()
    {
        $this->assignSection();
    }

    public function onUpdate()
    {
        $this->assignSection();        
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
}