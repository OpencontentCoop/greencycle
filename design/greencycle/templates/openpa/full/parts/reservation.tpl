{if fetch(user, current_user).is_logged_in}
{def $reservation = cond($node|has_attribute('current_reservation'), $node|attribute('current_reservation').content, false())}
{if $reservation|not()}	
	<h2 class="openpa-widget-title">{'Reservation'|i18n('greencycle')}</h2>
	<div class="u-margin-top-s nav-section">    
		<a style="display:block;font-size: 1.1em;" href="{concat('reservation/add/', $node.contentobject_id)|ezurl(no)}" class="Button Button--danger">{'Add a reservation for this item'|i18n('greencycle')}</a>
	</div>	
{elseif $reservation.data_map.approved.data_int|eq(0)}
	<h2 class="openpa-widget-title">{'Reservation'|i18n('greencycle')}</h2>
	<div class="u-margin-top-s nav-section">    		
		<a style="display:block;font-size: 1.1em;;margin-bottom:5px;text-decoration:none!important;cursor:not-allowed" href="#" class="Button Button--default is-disabled">{'Add a reservation for this item'|i18n('greencycle')}</a>
        {if $reservation.owner_id|ne(fetch(user, current_user).contentobject_id)}
		<p class="Prose">{'A reservation already exists for this item valid until'|i18n('greencycle')} {$node|attribute('current_reservation').content.data_map.expiration.content.timestamp|l10n(shortdate)}</p>
		{/if}
		{if and($reservation.can_read, $reservation.owner_id|eq(fetch(user, current_user).contentobject_id))}
			<p class="Prose"><a style="display:block;font-size: 1.1em;text-decoration:none !important" class="u-margin-top-s Button" href="{$node|attribute('current_reservation').content.main_node.url_alias|ezurl(no)}">{'View reservation detail'|i18n('greencycle')}</a></p>
		{/if}
		{if and($reservation.can_edit, $reservation.owner_id|eq(fetch(user, current_user).contentobject_id))}
		<form method="post" action="{"content/action"|ezurl(no)}">
            <input type="hidden" name="ContentObjectLanguageCode" value="{ezini( 'RegionalSettings', 'ContentObjectLocale', 'site.ini')}"/>
            <button style="display:block;font-size: 1.1em;width:100%; margin-top:10px;white-space:normal" class="Button" type="submit" name="EditButton">{'Edit the reservation if you want to add some details'|i18n('editorialstuff/dashboard')}</button>
            <input type="hidden" name="HasMainAssignment" value="1"/>
            <input type="hidden" name="ContentObjectID" value="{$reservation.id}"/>
            <input type="hidden" name="NodeID" value="{$reservation.main_node.node_id}"/>
            <input type="hidden" name="ContentNodeID" value="{$reservation.main_node.node_id}"/>
            
            {def $avail_languages = $post.object.available_languages
                 $content_object_language_code = ''
                 $default_language = $post.object.default_language}
            {if and( $avail_languages|count|ge( 1 ), $avail_languages|contains( $default_language ) )}
                {set $content_object_language_code = $default_language}
            {else}
                {set $content_object_language_code = ''}
            {/if}
            <input type="hidden" name="ContentObjectLanguageCode" value="{$content_object_language_code}"/>
            <input type="hidden" name="RedirectIfDiscarded" value="{$node.url_alias}"/>
            <input type="hidden" name="RedirectURIAfterPublish" value="{$node.url_alias}"/>
        </form>
		{/if}
	</div>
{elseif $reservation.data_map.approved.data_int|eq(1)}   
    <h2 class="openpa-widget-title">{'Reservation'|i18n('greencycle')}</h2>
    <div class="u-margin-top-s nav-section">  
        <p><a style="display:block;font-size: 1.1em;margin-bottom:5px;text-decoration:none!important;cursor:not-allowed" href="#" class="Button Button--default is-disabled">{'Add a reservation for this item'|i18n('greencycle')}</a></p>
        <p class="Prose">{'Already reserved'|i18n('greencycle')}</p>
    </div> 
{/if}

{/if}