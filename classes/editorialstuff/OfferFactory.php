<?php

class OfferFactory extends OCEditorialStuffPostDefaultFactory
{
    public function instancePost($data)
    {
        return new Offer($data, $this);
    }
}
