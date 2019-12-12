<?php

$Module = array( 
	'name' => 'Greencycle reservation',	
);

$ViewList = array();
$ViewList['add'] = array(
    'script' => 'add.php',
    'params' => array('ID'),
    'functions' => array('add')
);

$FunctionList = array();
$FunctionList['add'] = array();