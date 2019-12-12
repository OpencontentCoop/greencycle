<?php

use Opencontent\Opendata\Api\ContentRepository;
use Opencontent\Opendata\Api\ContentSearch;
use Opencontent\Opendata\Api\Values\Content;


class GreencycleDataHandlerOCMapMarkers extends DataHandlerOCMapMarkers
{

  public $contentType = 'geojson';

  private $query = '';
  private $attributes = '';
  private $maps = array();


  public function __construct(array $Params)
  {
    $this->contentType = eZHTTPTool::instance()->getVariable('contentType', $this->contentType);
  }

  protected static function find($query, $attributes)
  {
    
    $user = eZUser::fetch(eZUser::anonymousId());
    $userCache = $user->getUserCache();
    $limitations = [];
    if (isset($userCache['access_array']['content']['read'])){
      $limitations = $userCache['access_array']['content']['read'];
    }
    $limitations['custom1'] = ['Class' => [519], 'StateGroup_offer' => [10]];
    $limitations['custom2'] = ['Class' => [520], 'StateGroup_offer' => [14]];

    $featureData = new OCMapMarkersGeoJsonFeatureCollection();
    $language = eZLocale::currentLocaleCode();
    try {
      $limitation = [
        'accessWord' => 'limited',
        'policies' => $limitations
      ];      
      
      $data = self::findAll($query, $language, $limitation);
      $result['facets'] = $data->facets;

      foreach ($data->searchHits as $hit) {
        
        $content = self::getTranslation($hit);
        if (!$content){
          continue;
        }
        try {
          foreach ($attributes as $attribute) {

            if (isset($content['data'][$attribute]['content'])) {
              $properties = array(
                'id' => $hit['metadata']['id'],
                'type' => $hit['metadata']['classIdentifier'],
                'class' => $hit['metadata']['classIdentifier'],
                'name' => $content['metadata']['name'],
                'url' => '/content/view/full/' . $hit['metadata']['mainNodeId'],
                'popupContent' => '<em>Loading...</em>'
              );

              $feature = new OCMapMarkersGeoJsonFeature($hit['metadata']['id'],
                array(
                  $content['data'][$attribute]['content']['longitude'],
                  $content['data'][$attribute]['content']['latitude']
                ),
                $properties
              );
              $featureData->add($feature);
            }
          }

        } catch (Exception $e) {
          eZDebug::writeError($e->getMessage(), __METHOD__);
        }
      }
      $result['content'] = $featureData;
      
      return $result;

    } catch (Exception $e) {
      eZDebug::writeError($e->getMessage() . " in query $query", __METHOD__);
    }
  }

  private static function getTranslation($hit)
  {
    $allLanguages = eZContentLanguage::prioritizedLanguageCodes();
    
    foreach ($allLanguages as $locale) {
      if (isset($hit['data'][$locale])){
        return array(
          'metadata' => array('name' => $hit['metadata']['name'][$locale]),
          'data' => $hit['data'][$locale]
        );
      }
    }

    return false;
  }

  public function getData()
  {
    if ($this->contentType == 'geojson') {

      if (eZHTTPTool::instance()->hasGetVariable('query') && eZHTTPTool::instance()->hasGetVariable('attribute')) {
        $this->query = eZHTTPTool::instance()->getVariable('query');
        $this->attributes = explode(',', eZHTTPTool::instance()->getVariable('attribute'));

        return self::find($this->query, $this->attributes);

      }
    } elseif ($this->contentType == 'marker') {
      $view = eZHTTPTool::instance()->getVariable('view', 'panel');
      $id = eZHTTPTool::instance()->getVariable('id', 0);
      $object = eZContentObject::fetch($id);
      if ($object instanceof eZContentObject) {
        $tpl = eZTemplate::factory();
        $tpl->setVariable('object', $object);
        $tpl->setVariable('node', $object->attribute('main_node'));
        $result = $tpl->fetch('design:node/view/' . $view . '.tpl');
        $data = array('content' => $result);
      } else {
        $data = array('content' => '<em>Private</em>');
      }

      return $data;
    }
  } 
}
