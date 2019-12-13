<div class="panel-body u-background-grey-20">
    <div class="Grid Grid--withGutter u-padding-all-s u-padding-top-s">

        {if $post.object.can_edit}
            <div class="Grid-cell u-sizeFull u-md-size3of12 u-lg-size2of12">
                <form method="post" action="{"content/action"|ezurl(no)}" style="display: inline;">
                    <input type="hidden" name="ContentObjectLanguageCode"
                           value="{if is_set($current_language)}{$current_language}{else}{ezini( 'RegionalSettings', 'ContentObjectLocale', 'site.ini')}{/if}"/>
                    <button class="btn btn-info btn-lg" type="submit" name="EditButton">Modifica
                    </button>
                    <input type="hidden" name="HasMainAssignment" value="1"/>
                    <input type="hidden" name="ContentObjectID" value="{$post.object.id}"/>
                    <input type="hidden" name="NodeID" value="{$post.node.node_id}"/>
                    <input type="hidden" name="ContentNodeID" value="{$post.node.node_id}"/>                    
                    <input type="hidden" name="RedirectIfDiscarded"
                           value="{concat('editorialstuff/edit/', $factory_identifier, '/',$post.object.id)}"/>
                    <input type="hidden" name="RedirectURIAfterPublish"
                           value="{concat('editorialstuff/edit/', $factory_identifier, '/',$post.object.id)}"/>
                </form>
            </div>
        {/if}
        <div class="Grid-cell u-sizeFull u-md-size3of12 u-lg-size2of12">
            <a class="btn btn-info btn-lg js-fr-dialogmodal-open" 
               aria-controls="preview" 
               data-toggle="modal"
               data-load-remote="{concat( 'layout/set/modal/content/view/full/', $post.object.main_node_id )|ezurl('no')}"
               data-remote-target="#preview .modal-content" href="#{*$post.url*}"
               data-target="#preview">Anteprima</a>
        </div>
        <div class="Grid-cell u-sizeFull u-md-size6of12 u-lg-size8of12 text-right">
            {def $post_languages = $post.object.languages}
            {foreach fetch('content', 'prioritized_languages') as $language}                
                {def $exists = false()}
                {def $current = false()}
                {foreach $post_languages as $post_language}
                    {if $post_language.locale|eq($language.locale)}
                        {set $exists = true()}
                    {/if}
                    {if $post.object.current_language|eq($language.locale)}
                        {set $current = true()}
                    {/if}
                {/foreach}
                {if $exists}
                    <a href="{if $current}{*
                        *}{concat('editorialstuff/edit/', $factory_identifier, '/',$post.object.id)|ezurl(no)}{*
                        *}{elseif $exists}{concat( 'editorialstuff/edit/', $factory_identifier, '/',$post.object.id, '/(language)/', $language.locale )|ezurl(no)}{*
                        *}{else}{concat('content/edit/',$post.object.id,'/f/', $language.locale, '/', $post.object.current_language)|ezurl(no)}{/if}" 
                       class="Button Button--{if $current}default is-pressed{elseif $exists}default{else}info{/if}">
                        {if $exists|not}<i class="fa fa-plus"></i>{/if} {$language.name|explode('(')[0]|wash()}
                    </a>
                {else}
                    <form method="post" action="{concat("content/edit/",$post.object.id)|ezurl(no)}" style="display: inline;">
                        <input type="hidden" name="FromLanguage" value="{if is_set($current_language)}{$current_language}{else}{ezini( 'RegionalSettings', 'ContentObjectLocale', 'site.ini')}{/if}"/>
                        <input type="hidden" name="EditLanguage" value="{$language.locale}" />
                        <button class="btn btn-info btn-lg" type="submit" name="LanguageSelection">
                            <i class="fa fa-plus"></i> {$language.name|explode('(')[0]|wash()}
                        </button>
                        <input type="hidden" name="HasMainAssignment" value="1"/>
                        <input type="hidden" name="ContentObjectID" value="{$post.object.id}"/>
                        <input type="hidden" name="NodeID" value="{$post.node.node_id}"/>
                        <input type="hidden" name="ContentNodeID" value="{$post.node.node_id}"/>                    
                        <input type="hidden" name="RedirectIfDiscarded" value="{concat('editorialstuff/edit/', $factory_identifier, '/',$post.object.id)}"/>
                        <input type="hidden" name="RedirectURIAfterPublish" value="{concat('editorialstuff/edit/', $factory_identifier, '/',$post.object.id)}"/>
                    </form>
                {/if}    
                {undef $exists $current}
            {/foreach}
        </div>
    </div>

    <hr/>


    <div class="Grid Grid--withGutter u-padding-all-s">
        <div class="Grid-cell u-size2of12"><strong><em>{'Author'|i18n('editorialstuff/dashboard')}</em></strong></div>
        <div class="Grid-cell u-size10of12">
            {if $post.object.owner}{$post.object.owner.name|wash()}{else}?{/if}
        </div>
    </div>

    <div class="Grid Grid--withGutter u-padding-all-s">
        <div class="Grid-cell u-size2of12"><strong><em>{'Publication date'|i18n('editorialstuff/dashboard')}</em></strong></div>
        <div class="Grid-cell u-size10of12">
            <p>{$post.object.published|l10n(shortdatetime)}</p>
            {if $post.object.current_version|gt(1)}
                <small>Ultima modifica di <a
                            href={$post.object.main_node.creator.main_node.url_alias|ezurl}>{$post.object.main_node.creator.name}</a>
                    il {$post.object.modified|l10n(shortdatetime)}</small>
            {/if}
        </div>
    </div>

	{def $attribute_categories = ezini( 'ClassAttributeSettings', 'CategoryList', 'content.ini' )}
    {foreach $post.content_attributes_grouped_data_map as $category => $attributes}
        {if $category|eq('hidden')}{skip}{/if}
		{foreach $attributes as $attribute}        
		<div class="Grid Grid--withGutter u-padding-all-s">
		  <div class="Grid-cell u-size2of12"><strong>{$attribute.contentclass_attribute_name}</strong></div>
		  <div class="Grid-cell u-size10of12">{attribute_view_gui attribute=$attribute image_class=medium}</div>
		</div>
		{/foreach}
    {/foreach}


</div>
