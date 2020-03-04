{ezscript_require(array('cookiechoices.js'))}
{literal}
<script>
document.addEventListener('DOMContentLoaded', function(event) {
cookieChoices.cookieSecure = {/literal}{cond(ezini('Session','CookieSecure')|eq('true'), 'true', 'false')}{literal};
cookieChoices.showCookieConsentBar(
{/literal}{"This site uses technical, analytics and third-party cookies. By continuing to browse, you accept the use of cookies."|i18n('greencycle')}{literal},
  "{/literal}{'Accept'|i18n('openpa_designitalia')}{literal}",
  "{/literal}{'Informations'|i18n('openpa_designitalia')}{literal}",
'{/literal}{'openpa/cookie'|ezurl(no,full)}{literal}'
);});
</script>
{/literal}

<!--[if (lt IE 9) | IE 9]>
<div class="alert alert-danger text-center">
    <h4><i class="fa fa-exclamation-triangle"></i> <strong>Attenzione! Questa pagina potrebbe non essere visualizzata correttamente.</strong></h4>
    <p>Stai utilizzando una versione obsoleta di Internet Explorer. Per un'esperienza di navigazione più sicura e performante è consigliabile eseguire un aggiornamento del browser</p>
</div>
<![endif]-->
