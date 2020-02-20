<!DOCTYPE html>
<!--[if lt IE 9 ]>
<html xmlns="http://www.w3.org/1999/xhtml" class="unsupported-ie ie no-js"
      lang="{$site.http_equiv.Content-language|wash}"><![endif]-->
<!--[if IE 9 ]>
<html xmlns="http://www.w3.org/1999/xhtml" class="ie ie9 no-js"
      lang="{$site.http_equiv.Content-language|wash}"><![endif]-->
<!--[if (gt IE 9)|!(IE)]><!-->
<html xmlns="http://www.w3.org/1999/xhtml" class="no-js" lang="{$site.http_equiv.Content-language|wash}">
<!--<![endif]-->
<head>

{if is_set( $extra_cache_key )|not}
        {def $extra_cache_key = ''}
    {/if}

    {if openpacontext().is_homepage}
        {set $extra_cache_key = concat($extra_cache_key, 'homepage')}
    {/if}

    {if openpacontext().is_login_page}
        {set $extra_cache_key = concat($extra_cache_key, 'login')}
    {/if}

    {if openpacontext().is_edit}
        {set $extra_cache_key = concat($extra_cache_key, 'edit')}
    {/if}

    {if openpacontext().is_area_tematica}
        {set $extra_cache_key = concat($extra_cache_key, 'areatematica_', openpacontext().is_area_tematica)}
    {/if}

    {debug-accumulator id=page_head name=page_head}
    {include uri='design:page_head.tpl' canonical_url=openpacontext().canonical_url}
    {/debug-accumulator}

    {debug-accumulator id=page_head_style name=page_head_style}
    {include uri='design:page_head_style.tpl'}
    {/debug-accumulator}

    {debug-accumulator id=page_head_script name=page_head_script}
    {include uri='design:page_head_script.tpl'}
    {include uri='design:page_head_google_tag_manager.tpl'}
    {include uri='design:page_head_google-site-verification.tpl'}
    {/debug-accumulator}

    {no_index_if_needed()}

    {def $theme = openpaini('GeneralSettings','theme', 'pac')
         $main_content_class = ''
         $has_container = cond(is_set($module_result.content_info.persistent_variable.has_container), true(), false())
         $has_sidemenu = cond(and(is_set($module_result.content_info.persistent_variable.has_sidemenu), $module_result.content_info.persistent_variable.has_sidemenu), true(), false())
         $avail_translation = language_switcher( $site.uri.original_uri )}

    {if $has_container|not()}
        {set $main_content_class = cond(openpacontext().is_homepage, 'u-layout-wide u-layoutCenter', 'u-layout-medium u-layoutCenter')}
    {/if}

</head>
<body class="{$theme}">
<script type="text/javascript">
//<![CDATA[
var CurrentUserIsLoggedIn = {cond(fetch('user','current_user').is_logged_in, 'true', 'false')};
var UiContext = "{$ui_context}";
var UriPrefix = {'/'|ezurl()};
var PathArray = [{if is_set( openpacontext().path_array[0].node_id )}{foreach openpacontext().path_array|reverse as $path}{$path.node_id}{delimiter},{/delimiter}{/foreach}{/if}];
(function(){ldelim}var c = document.body.className;c = c.replace(/no-js/, 'js');document.body.className = c;{rdelim})();
var ModuleResultUri = "{$module_result.uri|wash()}";
var LanguageUrlAliasList = [{foreach $avail_translation as $siteaccess => $lang}{ldelim}locale:"{$lang.locale}",uri:"{$site.uri.original_uri|ngurl($siteaccess)}"{rdelim}{delimiter},{/delimiter}{/foreach}];
//]]>
</script>
{include uri='design:page_body_google_tag_manager.tpl'}

    <ul class="Skiplinks js-fr-bypasslinks">
        <li><a accesskey="2" href="#main">Vai al Contenuto</a></li>
        <li><a accesskey="3" href="#menu">Vai alla navigazione del sito</a></li>
    </ul>

    {include uri='design:page_browser_alert.tpl'}

    {debug-accumulator id=page_toolbar name=page_toolbar}
    {include uri='design:page_toolbar.tpl'}
    {/debug-accumulator}

    {cache-block expiry=86400 ignore_content_expiry keys=array( $access_type.name, $extra_cache_key )}
    {debug-accumulator id=page_header_and_offcanvas_menu name=page_header_and_offcanvas_menu}
        {def $pagedata = openpapagedata()}
        {include uri='design:page_header.tpl'}
        {include uri='design:menu/offcanvas_menu.tpl'}
        {undef $pagedata}
    {/debug-accumulator}
    {/cache-block}

    <div id="main">

        {if and(is_set($module_result.content_info.persistent_variable.has_sidemenu), $module_result.content_info.persistent_variable.has_sidemenu)}
        <p class="u-md-hidden u-lg-hidden u-padding-r-all u-text-m u-background-grey-20">
            <span class="Icon-list u-text-r-xl u-alignMiddle u-padding-r-right" aria-hidden="true"></span>
            <a accesskey="3" class="js-scrollTo u-text-r-s u-textClean u-color-grey-50 u-alignMiddle" href="#subnav">Vai menu di sezione</a>
        </p>
        {/if}

        <section class="{$main_content_class}">

            {if openpacontext().show_breadcrumb}
            {debug-accumulator id=breadcrumb name=breadcrumb}
                {include uri='design:breadcrumb.tpl' path_array=openpacontext().path_array}
            {/debug-accumulator}
            {/if}

            {include uri='design:page_mainarea.tpl'}

        </section>

        {if is_set($module_result.content_info.persistent_variable.valuation)}
            <div class="u-background-95 u-padding-all-xl u-layoutCenter u-hiddenPrint">
                <p class="u-textCenter u-margin-top-m u-margin-bottom-m">
                    <a href="#" id="toggle-validation" class="u-color-white u-textClean u-text-h3">
                        <span class="u-padding-r-right Icon Icon-comment"></span> Valuta questo sito
                    </a>
                </p>
                <div style="display: none" id="openpa-valuation" data-loaded="0">
                    {include name=valuation uri='design:openpa/load_valuation.tpl' parameters=$module_result.content_info.persistent_variable.valuation}
                </div>
            </div>
        {/if}

        {if and(openpacontext().is_login_page|not(), openpacontext().is_edit|not())}
        {debug-accumulator id=page_footer name=page_footer}
        {cache-block expiry=86400 ignore_content_expiry keys=array( $access_type.name )}
            {def $pagedata = openpapagedata()}
            {include uri='design:page_footer.tpl'}
            {undef $pagedata}
        {/cache-block}
        {/debug-accumulator}
        {/if}

    </div>

    {include uri='design:page_extra.tpl'}
    <script>{literal}$(document).ready(function(){$('[data-locale]').each(function(){var self = $(this); var locale = self.data('locale');$.each(LanguageUrlAliasList, function(){if(this.locale == locale){self.attr('href', this.uri);}})});});{/literal}</script>
    {include uri='design:page_footer_script.tpl'}

<!--DEBUG_REPORT-->
</body>
</html>
