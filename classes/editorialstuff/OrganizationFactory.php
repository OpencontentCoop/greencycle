<?php

class OrganizationFactory extends OCEditorialStuffPostDefaultFactory
{
    public function instancePost($data)
    {
        return new Organization($data, $this);
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
}
