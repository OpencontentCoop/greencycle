<?php

class OrganizationFactory extends OCEditorialStuffPostDefaultFactory
{
    public function instancePost($data)
    {
        return new Organization($data, $this);
    }
}
