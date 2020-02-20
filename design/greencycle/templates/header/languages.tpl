{def $lang_selector = array()
     $global_avail_translation = language_switcher('/')
     $uri = '/'
     $current_language = false()}

{if $global_avail_translation|count|gt( 1 )}
    {foreach $global_avail_translation as $siteaccess => $lang}

        {if is_set($valid_translations)}

            {if $valid_translations|count()|eq(1)}
                {* c'è solo una lingua 'valida' (ad esempio per un sottosito - vedi parts/subsite/page_header.tpl), non mostra language_switcher *}
                {break}
            {elseif and($valid_translations|count|gt( 1), $valid_translations|contains($lang.locale)|not )}
                {continue}
            {/if}

        {/if}

        {if $siteaccess|eq( $access_type.name )}
          {set $current_language = $lang}          
        {/if}

        {append-block variable=$lang_selector}
        {if $siteaccess|eq( $access_type.name )}
            <li role="menuitem" class="is-selected"><a href="#">{$lang.text|wash}</a></li>
        {else}
            <li role="menuitem"><a data-locale="{$lang.locale}" href="{$uri|ngurl( $siteaccess )}">{$lang.text|wash}</a></li>
        {/if}
        {/append-block}
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
        {$lang_selector|implode( '' )}
        </ul>
      </div>
  </div>
{/if}
{undef $lang_selector}