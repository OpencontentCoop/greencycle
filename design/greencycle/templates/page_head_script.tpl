<link rel="stylesheet" type="text/css" href={'fonts/titiliumwebfont.css'|ezdesign()} />

{ezscript_load( array(
    'ezjsc::jquery',
    'ezjsc::jqueryUI',
    'ezjsc::jqueryio',
    'menu.js',
    'vendor/owl.carousel.min.js',
    'plugins/init_carousel.js',
    'plugins/blueimp/jquery.blueimp-gallery.min.js',
    'password-score/password.js'
))}
<!-- include html5shim per Explorer 8 -->
<script src="{'javascript/vendor/modernizr.js'|ezdesign(no)}"></script>
<!-- youtube embed fix -->
{literal}<script>$(document).ready(function(){$("iframe[src*='youtube']").each(function(){var width = $(this).attr('width');var height = $(this).attr('height');var parent = $(this).parent();if (parent.css('overflow') == 'hidden' && width > 0 && height > 0){parent.css('padding-bottom', parseFloat(height / width * 100) + '%');}})});</script>{/literal}
