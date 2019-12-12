{if is_unset( $load_css_file_list )}
    {def $load_css_file_list = true()}
{/if}
{if is_unset( $theme )}
        {def $css_theme = concat('build_', openpaini('GeneralSettings','theme', 'pac') ,'.css')}
    {else}
        {def $css_theme = concat('build_', $theme ,'.css')}
{/if}

{if $load_css_file_list}
{ezcss_load( array(

        $css_theme,
        'ez.css',
        'debug.css',
        'font-awesome.min.css',
        'websitetoolbar.css',
        ezini( 'StylesheetSettings', 'CSSFileList', 'design.ini' ),
        ezini( 'StylesheetSettings', 'FrontendCSSFileList', 'design.ini' )
    ),
    'all', 'text/css', 'stylesheet' )}
{else}
{ezcss_load( array(

        $css_theme,
        'ez.css',
        'debug.css',
        'font-awesome.min.css',
        'websitetoolbar.css'
    ),
    'all', 'text/css', 'stylesheet' )}
{/if}

{ezcss_load( array('print.css'),'print', 'text/css', 'stylesheet' )}

