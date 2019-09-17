<?php

class RequestFactory extends OCEditorialStuffPostDefaultFactory
{
    public function instancePost($data)
    {
        return new Request($data, $this);
    }
}
