<?php

$Module = array( 
	'name' => 'Greencycle offer',	
);

$ViewList = array();
$ViewList['image'] = array(
    'script' => 'image.php',
    'params' => array('ObjectId'),
    'functions' => array('read')
);
$ViewList['search'] = array(
    'script' => 'search.php',
    'params' => array('Param'),
    'functions' => array('read')
);

$FunctionList = array();
$FunctionList['read'] = array();