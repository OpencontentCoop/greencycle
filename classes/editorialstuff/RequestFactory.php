<?php

class RequestFactory extends OCEditorialStuffPostDefaultFactory
{
    public function instancePost($data)
    {
        return new Request($data, $this);
    }

    public function dashboardModuleResult($parameters, OCEditorialStuffHandlerInterface $handler, eZModule $module)
    {
        $Result = parent::dashboardModuleResult($parameters, $handler, $module);
		$Result['path'] = array(
			array('url' => 'content/dashboard', 'text' => 'Dashboard'),
			array('url' => false, 'text' => isset($this->configuration['Name']) ? $this->configuration['Name'] : $this->classIdentifier())
		);
        
        return $Result;
    }

    public function editModuleResult($parameters, OCEditorialStuffHandlerInterface $handler, eZModule $module)
    {
		$Result = parent::editModuleResult($parameters, $handler, $module);
		$path = $Result['path'];
		array_unshift($path, array('url' => 'content/dashboard', 'text' => 'Dashboard'));
        $Result['path'] = $path;
        
        return $Result;
    }    

    protected function editModuleResultTemplate( $currentPost, $parameters, OCEditorialStuffHandlerInterface $handler, eZModule $module )
    {
        if ( isset( $this->configuration['UiContext'] ) && is_string( $this->configuration['UiContext'] ) )
            $module->setUIContextName( $this->configuration['UiContext'] );
        $tpl = eZTemplate::factory();
        $tpl->setVariable( 'persistent_variable', false );
        $tpl->setVariable( 'factory_identifier', $this->configuration['identifier'] );
        $tpl->setVariable( 'factory_configuration', $this->getConfiguration() );
        $tpl->setVariable( 'template_directory', $this->getTemplateDirectory() );
        $tpl->setVariable( 'post', $currentPost );
        $tpl->setVariable( 'site_title', false );
        if (isset($module->UserParameters['language'])){
            $currentLanguage = $module->UserParameters['language'];
            $tpl->setVariable( 'current_language', $currentLanguage );
        } 
        return $tpl;
    }

    protected function getModuleCurrentPost($parameters, OCEditorialStuffHandlerInterface $handler, eZModule $module, $version = false)
    {
        $object = eZContentObject::fetch($parameters);
        if (!$object instanceof eZContentObject) {
            return $module->handleError(eZError::KERNEL_NOT_AVAILABLE, 'kernel');
        }
        if (!$object->attribute('can_read')) {
            return $module->handleError(eZError::KERNEL_ACCESS_DENIED, 'kernel');
        }
        try {
            $post = $handler->fetchByObjectId($object->attribute('id'));
            if (isset($module->UserParameters['language'])){
                $currentLanguage = $module->UserParameters['language'];
                $languages = $object->languages();
                if (isset($languages[$currentLanguage])){                    
                    $post->setCurrentLanguage($currentLanguage);
                }
            }            
            return $post;
        } catch (Exception $e) {
            return null;
        }
    }
}
