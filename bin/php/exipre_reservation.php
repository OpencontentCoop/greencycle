<?php
require 'autoload.php';

$script = eZScript::instance(array(
    'description' => ( "Expire reservation\n\n" ),
    'use-session' => false,
    'use-modules' => true,
    'use-extensions' => true
));

$script->startup();

$options = $script->getOptions();
$script->initialize();
$script->setUseDebugAccumulators(true);

$cli = eZCLI::instance();

/** @var eZUser $user */
$user = eZUser::fetchByName('admin');
if ($user) {
    eZUser::setCurrentlyLoggedInUser($user, $user->attribute('contentobject_id'));
} else {
    throw new InvalidArgumentException("Non esiste un utente admin");
}

try {
    
    Request::expireReservations($cli);

} catch (Exception $e) {
    $cli->error($e->getMessage());
}
$script->shutdown();
