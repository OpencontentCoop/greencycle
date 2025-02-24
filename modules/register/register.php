<?php

/** @var eZModule $Module */
$Module = $Params['Module'];
$tpl = eZTemplate::factory();
$http = eZHTTPTool::instance();
$Action = $Params['Action'];

if (isset($Params['UserParameters'])) {
$viewParameters = $Params['UserParameters'];
} else {
$viewParameters = array();
}
$tpl->setVariable('view_parameters', $viewParameters);

$recaptcha = new OpenPARecaptcha();
$tpl->setVariable('recaptcha_public_key', $recaptcha->getPublicKey());


if ($Action == 'activate') {

    $tpl->setVariable('success', true);

    $Result = array();
    $Result['content'] = $tpl->fetch('design:register_organization.tpl');
    $Result['node_id'] = 0;

    $contentInfoArray = array('url_alias' => 'register/organization');
    $Result['content_info'] = $contentInfoArray;
    $Result['path'] = array();


} else {

    $Module->setUIContextName('edit');
    if (isset($Params['UserParameters'])) {
        $UserParameters = $Params['UserParameters'];
    } else {
        $UserParameters = array();
    }
    $viewParameters = array();
    $viewParameters = array_merge($viewParameters, $UserParameters);

    $Params['TemplateName'] = "design:register_organization.tpl";
    $EditVersion = 1;


    $tpl = eZTemplate::factory();
    $tpl->setVariable('view_parameters', $viewParameters);
    $tpl->setVariable('success', false);
    $Params['TemplateObject'] = $tpl;

    $db = eZDB::instance();
    $db->begin();

    // Fix issue EZP-22524
    if ($http->hasSessionVariable("RegisterOrganizationID")) {
        if ($http->hasSessionVariable('StartedRegistrationOrganization')) {
            eZDebug::writeWarning('Cancel module run to protect against multiple form submits', 'user/register');
            $http->removeSessionVariable("RegisterOrganizationID");
            $http->removeSessionVariable('StartedRegistrationOrganization');
            $db->commit();

            return eZModule::HOOK_STATUS_CANCEL_RUN;
        }

        $objectId = $http->sessionVariable("RegisterOrganizationID");

        $object = eZContentObject::fetch($objectId);
        if ($object === null) {
            $http->removeSessionVariable("RegisterOrganizationID");
            $http->removeSessionVariable('StartedRegistrationOrganization');
        }
    } else {
        if ($http->hasSessionVariable('StartedRegistrationOrganization')) {
            eZDebug::writeWarning('Cancel module run to protect against multiple form submits', 'user/register');
            $http->removeSessionVariable("RegisterOrganizationID");
            $http->removeSessionVariable('StartedRegistrationOrganization');
            $db->commit();

            return eZModule::HOOK_STATUS_CANCEL_RUN;
        } else if ($http->hasPostVariable('PublishButton') or $http->hasPostVariable('CancelButton')) {
            $http->setSessionVariable('StartedRegistrationOrganization', 1);
        }

        $handler = OCEditorialStuffHandler::instance('private_organization');

        $class = eZContentClass::fetchByIdentifier($handler->getFactory()->classIdentifier());
        if (!$class instanceof eZContentClass) {
            return $Module->handleError(eZError::KERNEL_NOT_AVAILABLE, 'kernel');
        }

        $parent = $handler->getFactory()->creationRepositoryNode();
        $node = eZContentObjectTreeNode::fetch(intval($parent));

        if ($node instanceof eZContentObjectTreeNode && $class->attribute('id')) {
            $languageCode = eZINI::instance()->variable('RegionalSettings', 'Locale');

            $sectionID = $node->attribute('object')->attribute('section_id');

            $object = eZContentObject::createWithNodeAssignment($node,
                $class->attribute('id'),
                $languageCode,
                false);


            $object = $class->instantiateIn($languageCode, false, $sectionID, false,
                eZContentObjectVersion::STATUS_INTERNAL_DRAFT);
            $nodeAssignment = $object->createNodeAssignment(
                $node->attribute('node_id'),
                true,
                'greencycle_' . eZRemoteIdUtility::generate('eznode_assignment'),
                $class->attribute('sort_field'),
                $class->attribute('sort_order'));

            if ($object) {
                $http->setSessionVariable('RedirectURIAfterPublish', '/register/organization/activate');
                $http->setSessionVariable('RedirectIfDiscarded', '/');

                $http->setSessionVariable("RegisterOrganizationID", $object->attribute('id'));
                $objectId = $object->attribute('id');

            } else {
                $http->removeSessionVariable("RegisterOrganizationID");
                $http->removeSessionVariable('StartedRegistrationOrganization');

                return $Module->handleError(eZError::KERNEL_ACCESS_DENIED, 'kernel');
            }
        } else {
            $http->removeSessionVariable("RegisterOrganizationID");
            $http->removeSessionVariable('StartedRegistrationOrganization');

            return $Module->handleError(eZError::KERNEL_NOT_AVAILABLE, 'kernel');
        }
    }

    $Params['ObjectID'] = $objectId;

    if (!function_exists('checkContentActions')) {
        /**
         * @param eZModule $Module
         * @param eZContentClass $class
         * @param eZContentObject $object
         * @param eZContentObjectVersion $version
         *
         * @return int
         */
        function checkContentActions(
            $Module,
            $class,
            $object,
            $version
        )
        {
            if ($Module->isCurrentAction('Cancel')) {
                $Module->redirectTo('/');

                $version->removeThis();

                $http = eZHTTPTool::instance();
                $http->removeSessionVariable("RegisterOrganizationID");
                $http->removeSessionVariable('StartedRegistrationOrganization');

                return eZModule::HOOK_STATUS_CANCEL_RUN;
            }

            if ($Module->isCurrentAction('Publish')) {

                $recaptcha = new OpenPARecaptcha();
                if (!$recaptcha->validate()) {
                    $Module->redirectTo('register/organization/(error)/invalid_recaptcha');

                    return eZModule::HOOK_STATUS_CANCEL_RUN;
                }

                $operationResult = eZOperationHandler::execute('content', 'publish', array(
                    'object_id' => $object->attribute('id'),
                    'version' => $version->attribute('version')
                ));

                if ($operationResult['status'] !== eZModuleOperationInfo::STATUS_CONTINUE) {
                    eZDebug::writeError('Unexpected operation status: ' . $operationResult['status'], __FILE__);
                }

                $http = eZHTTPTool::instance();
                $http->removeSessionVariable("GeneratedPassword");
                $http->removeSessionVariable("RegisterOrganizationID");
                $http->removeSessionVariable('StartedRegistrationOrganization');
                $Module->redirectTo('register/organization/activate');

                return eZModule::HOOK_STATUS_OK;
            }
        }
    }
    $Module->addHook('action_check', 'checkContentActions');

    $OmitSectionSetting = true;

    $includeResult = include('kernel/content/attribute_edit.php');

    $db->commit();

    if ($includeResult != 1) {
        return $includeResult;
    }

}
