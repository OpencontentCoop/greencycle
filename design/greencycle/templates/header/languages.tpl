{def $lang_selector = array()
     $avail_translation = array()}
{if and( is_set( $DesignKeys:used.url_alias ), $DesignKeys:used.url_alias|count|ge( 1 ) )}
    {set $avail_translation = language_switcher( $DesignKeys:used.url_alias )}
{else}
    {set $avail_translation = language_switcher( $site.uri.original_uri )}
{/if}

{if $avail_translation|count|gt( 1 )}

  {def $current_language = false()
       $available_languages = array()}
  {foreach $avail_translation as $siteaccess => $lang}
    {if is_set($lang.locale)}      
        {if $siteaccess|eq( $access_type.name )}
          {set $current_language = $lang}          
        {else}
          {set $available_languages = $available_languages|append($lang)}
        {/if}        
    {/if}
  {/foreach}

  {if $current_language|not}
    {set $current_language = hash('text', '?','locale', '?','url', '/')}
  {/if}

  <div class="Header-languages" style="padding: 10px;margin-left: 20px;">
      <a href="#languages" data-menu-trigger="languages" class="Header-language u-border-none u-zindex-max u-inlineBlock" aria-controls="languages" aria-haspopup="true" role="button">
        <span class="u-hiddenVisually">Lingua attiva:</span>
        <span class="">{$current_language.text|wash|upcase}</span>          
        <span class="Icon Icon-expand u-padding-left-xs"></span>
      </a>
      <div id="languages" data-menu="" class="Dropdown-menu Header-language-other u-jsVisibilityHidden u-nojsDisplayNone" style="position: absolute; transform: translate3d(1366px, 36px, 0px); top: 0px; left: 0px; will-change: transform;" role="menu" aria-hidden="true">
        <span class="Icon-drop-down Dropdown-arrow u-color-white" style="left: 59px;"></span>
        <ul style="text-align:left">
          <li role="menuitem" class="is-selected"><a href="{$current_language.url|ezurl(no)}" class="u-padding-r-all"><span lang="{fetch(content, locale, hash(locale_code, $current_language.locale)).http_locale_code|explode('-')[0]}">{$current_language.text|wash|upcase}</span></a></li>                        
          {foreach $available_languages as $lang}
          <li role="menuitem"><a href="{$lang.url|ezurl(no)}" title="{$lang.text|wash|upcase}" class="u-padding-r-all"><span lang="{fetch(content, locale, hash(locale_code, $lang.locale)).http_locale_code|explode('-')[0]}">{$lang.text|wash|upcase}</span></a></li>
          {/foreach}            
        </ul>
      </div>
  </div>
  {undef $current_language $available_languages}
{/if}
{undef $lang_selector}
