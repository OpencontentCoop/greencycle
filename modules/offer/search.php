<?php

use Opencontent\Opendata\Api\ContentBrowser;
use Opencontent\Opendata\Api\ContentRepository;
use Opencontent\Opendata\Api\ContentSearch;

$Module = $Params['Module'];
$Param = urldecode($_GET['q']);
$Debug = isset($_GET['debug']);
$Languages = $_GET['languages'];

if (!function_exists('array_key_first')) {
    function array_key_first(array $arr)
    {
        foreach ($arr as $key => $unused) {
            return $key;
        }
        return NULL;
    }
}

if (!function_exists('array_key_first')) {
    function array_key_first(array $arr) {
        foreach($arr as $key => $unused) {
            return $key;
        }
        return NULL;
    }
}

try {
    $contentRepository = new ContentRepository();
    $contentSearch = new ContentSearch();
    $currentEnvironment = new DefaultEnvironmentSettings();
    $contentRepository->setEnvironment($currentEnvironment);
    $contentSearch->setEnvironment($currentEnvironment);
    $parser = new ezpRestHttpRequestParser();
    $request = $parser->createRequest();
    $currentEnvironment->__set('request', $request);
    if ($Debug)
        $currentEnvironment->__set('debug', true);

    $user = eZUser::fetch(eZUser::anonymousId());
    $userCache = $user->getUserCache();
    $limitations = [];
    if (isset($userCache['access_array']['content']['read'])) {
        $limitations = $userCache['access_array']['content']['read'];
    }
    $limitations['custom1'] = ['Class' => [519], 'StateGroup_offer' => [10]];
    $limitations['custom2'] = ['Class' => [520], 'StateGroup_offer' => [14]];

    //eZINI::instance( 'ezfind.ini' )->setVariable( 'LanguageSearch', 'SearchMainLanguageOnly', 'enabled' );
    $data = (array)$contentSearch->search($Param, [
        'accessWord' => 'limited',
        'policies' => $limitations
    ]);
    $data['languages'] = $Languages;

    function fixTranslationsInRelations($data, $language)
    {
        $fixedData = [];
        foreach ($data as $key => $value) {
            if(is_array($value) && isset($value[0]['name'])){                
                foreach ($value as $index => $item) {
                    if (!isset($item['name'][$language])){
                        $value[$index]['name'][$language] = $item['name'][array_key_first($item['name'])];
                    }
                }
            }
            $fixedData[$key] = $value;
        }
        return $fixedData;
    }

    $searchHits = [];
    $avoidDuplicates = [];
    foreach ($data['searchHits'] as $hit) {
        $hitData = [];
        foreach ($Languages as $language) {
            if (isset($hit['data'][$language])){
                $hitData[$language] = $hit['data'][$language];
            }            
        }
        $hit['data'] = $hitData;
        foreach ($hit['data'] as $locale => $value) {
            if (!isset($duplicates[$hit['metadata']['id']][$locale])) {
                $hit['data'] = [$locale => fixTranslationsInRelations($value, $locale)];
                $duplicates[$hit['metadata']['id']][$locale] = $locale;
                break;
            }
        }
        $searchHits[] = $hit;
    }
    $data['searchHits'] = $searchHits;

} catch (Exception $e) {
    $data = array(
        'error_code' => $e->getCode(),
        'error_message' => $e->getMessage()
    );
    if ($Debug) {
        $data['file'] = $e->getFile();
        $data['line'] = $e->getLine();
        $data['trace'] = $e->getTraceAsString();
    }
}

header('Content-Type: application/json');
echo json_encode($data);

eZExecution::cleanExit();
