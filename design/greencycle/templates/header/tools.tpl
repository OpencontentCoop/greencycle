{def $area_tematica_links = array()}
{if is_area_tematica()}
  {set $area_tematica_links = fetch( 'content', 'related_objects', hash( 'object_id', is_area_tematica().contentobject_id, 'attribute_identifier', 'area_tematica/link' ))}
{/if}

<div class="Header-searchTrigger Grid-cell">
  <button aria-controls="header-search" class="js-Header-search-trigger Icon Icon-search Icon--rotated"
          title="{'Enable search form'|i18n('openpa_designitalia')}" aria-label="{'Enable search form'|i18n('openpa_designitalia')}" aria-hidden="false">
  </button>
  <button aria-controls="header-search" class="js-Header-search-trigger Icon Icon-close u-hidden "
          title="{'Disable search form'|i18n('openpa_designitalia')}" aria-label="{'Disable search form'|i18n('openpa_designitalia')}" aria-hidden="true">
  </button>
</div>

<div class="Header-utils Grid-cell">
  <div class="Header-social Headroom-hideme">
    {if or(is_set($pagedata.contacts.facebook), is_set($pagedata.contacts.twitter), is_set($pagedata.contacts.linkedin), is_set($pagedata.contacts.instagram))}
      
      <p class="u-color-95">{'Follow us'|i18n('openpa/footer')}</p>

      <ul class="Header-socialIcons">
        {if is_set($pagedata.contacts.facebook)}
          <li>
            <a href="{$pagedata.contacts.facebook}">
                            <span class="openpa-icon fa-stack">
                                <i class="fa fa-circle fa-stack-2x u-color-90"></i>
                                <i class="fa fa-facebook fa-stack-1x u-color-white" aria-hidden="true"></i>
                            </span>
              <span class="u-hiddenVisually">Facebook</span>
            </a>
          </li>
        {/if}
        {if is_set($pagedata.contacts.twitter)}
          <li>
            <a href="{$pagedata.contacts.twitter}">
                            <span class="openpa-icon fa-stack">
                                <i class="fa fa-circle fa-stack-2x u-color-90"></i>
                                <i class="fa fa-twitter fa-stack-1x u-color-white" aria-hidden="true"></i>
                            </span>
              <span class="u-hiddenVisually">Twitter</span>
            </a>
          </li>
        {/if}
        {if is_set($pagedata.contacts.linkedin)}
          <li>
            <a href="{$pagedata.contacts.linkedin}">
                            <span class="openpa-icon fa-stack">
                                <i class="fa fa-circle fa-stack-2x u-color-90"></i>
                                <i class="fa fa-linkedin fa-stack-1x u-color-white" aria-hidden="true"></i>
                            </span>
              <span class="u-hiddenVisually">Linkedin</span>
            </a>
          </li>
        {/if}
        {if is_set($pagedata.contacts.instagram)}
          <li>
            <a href="{$pagedata.contacts.instagram}">
                            <span class="openpa-icon fa-stack">
                                <i class="fa fa-circle fa-stack-2x u-color-90"></i>
                                <i class="fa fa-instagram fa-stack-1x u-color-white" aria-hidden="true"></i>
                            </span>
              <span class="u-hiddenVisually">Instagram</span>
            </a>
          </li>
        {/if}
        {if is_set($pagedata.contacts.newsletter)}
          <li>
              <a href="{$pagedata.contacts.newsletter}">
                        <span class="openpa-icon fa-stack">
                            <i class="fa fa-circle fa-stack-2x u-color-90"></i>
                            <i class="fa fa-envelope-square fa-stack-1x u-color-white" aria-hidden="true"></i>
                        </span>
                  <span class="u-hiddenVisually">Newsletter</span>
              </a>
          </li>
        {/if}
        {if is_set($pagedata.contacts.youtube)}
          <li>
              <a href="{$pagedata.contacts.youtube}">
                    <span class="openpa-icon fa-stack">
                        <i class="fa fa-circle fa-stack-2x u-color-90"></i>
                        <i class="fa fa-youtube fa-stack-1x u-color-white" aria-hidden="true"></i>
                    </span>
                  <span class="u-hiddenVisually">YouTube</span>
              </a>
          </li>
        {/if}

        {def $forms = fetch( 'content', 'class', hash( 'class_id', 'feedback_form' ) ).object_list
             $form = cond(is_set($forms[0]), $forms[0], false())}
        {if is_set($form.main_node)}
          <li>
            <a href="{$form.main_node.url_alias|ezurl(no)}">
                            <span class="openpa-icon fa-stack">
                                <i class="fa fa-circle fa-stack-2x u-color-90"></i>
                                <i class="fa fa-envelope fa-stack-1x u-color-white" aria-hidden="true"></i>
                            </span>
              <span class="u-hiddenVisually">{'Info'|i18n('openpa/tools')}</span>
            </a>
          </li>
        {/if}
        {undef $forms $form}
      </ul>
    {/if}  
    {include uri='design:header/languages.tpl'}
  </div>

  <div class="Header-search" id="header-search">
    <form class="Form" action="{"/content/search"|ezurl(no)}">
      <div class="Form-field Form-field--withPlaceholder Grid u-background-white u-color-grey-30 u-borderRadius-s"
           role="search">

        {if is_area_tematica()}
          <input type="hidden" value="{is_area_tematica().node_id}" name="SubTreeArray[]"/>
          <input type="text" id="cerca" class="Form-input Grid-cell u-sizeFill u-text-r-s u-color-black u-text-r-xs"
                 required name="SearchText" {if $pagedata.is_edit}disabled="disabled"{/if}>
          <label class="Form-label u-color-grey-50 u-text-r-xxs" for="cerca">{'Search'|i18n('openpa/search')} {'in'|i18n('openpa/search')} {is_area_tematica().name|wash()}</label>
        {else}
          <input type="text" id="cerca" class="Form-input Grid-cell u-sizeFill u-text-r-s u-color-black u-text-r-xs"
                 required name="SearchText" {if $pagedata.is_edit}disabled="disabled"{/if}>
          <label class="Form-label u-color-grey-50 u-text-r-xxs" for="cerca">{'Search'|i18n('openpa/search')} {'all website'|i18n('openpa/search')}</label>
        {/if}

        <button type="submit" value="cerca" name="SearchButton" {if $pagedata.is_edit}disabled="disabled"{/if}
                class="Grid-cell u-sizeFit Icon-search Icon--rotated u-color-white u-padding-all-s u-textWeight-700"
                title="{'Search'|i18n('openpa/search')}" aria-label="{'Search'|i18n('openpa/search')}">
        </button>
      </div>
      {if eq( $ui_context, 'browse' )}
        <input name="Mode" type="hidden" value="browse"/>
      {/if}
    </form>
  </div>
</div>

