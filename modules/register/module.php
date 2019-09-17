<?php

$Module = array( 
	'name' => 'Greencycle register',	
);

$ViewList = array();
$ViewList['organization'] = array(
    'script' => 'register.php',
    'params' => array('Action'),
    'functions' => array('register'),
    'ui_context' => 'edit',
    'single_post_actions' => array(
        'PublishButton' => 'Publish',
        'CancelButton' => 'Cancel',
        'CustomActionButton' => 'CustomAction'
    )
);

$FunctionList = array();
$FunctionList['register'] = array();