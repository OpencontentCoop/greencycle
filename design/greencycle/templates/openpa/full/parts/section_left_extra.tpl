<div class="content-related">

    {if count($openpa.content_related.info)|gt(0)}
        <div class="openpa-widget nav-section">
            <h2 class="openpa-widget-title"><span>{'Related information'|i18n('openpa/sidebar')}</span></h2>
            <div class="openpa-widget-content">
                {foreach $openpa.content_related.info as $class_name => $infos}
                    <ul class="Linklist Linklist--padded Treeview Treeview--default js-Treeview u-text-r-xs u-layout-prose">
                        {foreach $infos as $info}
                            <li>
                                {node_view_gui content_node=$info view=text_linked}
                            </li>
                        {/foreach}
                    </ul>
                {/foreach}
            </div>
        </div>
    {/if}


    {if $openpa.content_facets.has_data}
        <div class="openpa-widget nav-section">
            <h2 class="openpa-widget-title"><span>{'Referable to'|i18n('openpa/sidebar')} {$node.name|wash()}</span></h2>
            <div class="openpa-widget-content">
                {foreach $openpa.content_facets.items as $item}
                    <ul class="Linklist Linklist--padded Treeview Treeview--default js-Treeview u-text-r-xs u-layout-prose">
                        {foreach $item as $data}
                            <li>
                                <a href="{concat( "content/advancedsearch?Data[",$data.attribute_identifier,"][]=", $node.contentobject_id|urlencode, '&ClassArray[]=', $data.class_id)|ezurl(no)}"
                                   title="Link a {$data.class_name|wash}">{$data.class_name|wash} {if count($item)|gt(1)}
                                    <small>{$data.attribute_name}</small>{/if} <span class="badge">{$data.value}</span>
                                </a>
                            </li>
                        {/foreach}
                    </ul>
                {/foreach}
            </div>
        </div>
    {/if}

    {* TODO inserire blocco di ricerca nela caso di view filters *}
    {* {if $openpa.control_children.current_view|eq('filters')}{/if} *}

    {* BLOCCO DI RICERCA
        compare solo nei folder e negli oggetti con padre folder
        qualora il campo 'engine' sia valorizzato la ricerca viene estesa a tutto il database *}

    {def $virtualFolder = $openpa.content_virtual.folder}
    {if and( $virtualFolder|not(), $node.parent, $node.parent.node_id|ne(1) )}
        {def $parentOpenpa = object_handler( $node.parent )}
        {set $virtualFolder = $parentOpenpa.content_virtual.folder}
    {/if}
    {if $virtualFolder}
        {include name=searchbox
                 node=cond(is_set($parentOpenpa), $node.parent, $node )
                 subtree=$virtualFolder.subtree
                 class_filters=$virtualFolder.classes
                 open_advanced = cond(is_set($parentOpenpa), false(), true() )
                 uri='design:parts/search_class_and_attributes.tpl' }
    {elseif $openpa.control_children.current_view|eq('filters')}
        <div class="openpa-widget nav-section">
            {include uri='design:parts/children_class_filters.tpl'}
        </div>
    {elseif $openpa.control_children.current_view|eq('offers_filters')}
        <div class="openpa-widget nav-section">
            {include uri='design:parts/children_class_offers_filters.tpl'}
        </div>
    {elseif $openpa.control_children.current_view|eq('requests_filters')}
        <div class="openpa-widget nav-section">
            {include uri='design:parts/children_class_requests_filters.tpl'}
        </div>    
    {/if}


    {def $classification = $openpa.content_related.classification}
    {if count($classification)|gt(0)}
        <div class="openpa-widget nav-section">
            <h2 class="openpa-widget-title"><span>{'Classification'|i18n('openpa/sidebar')}</span></h2>
            <div class="openpa-widget-content">
                <ul class="Linklist Linklist--padded Treeview Treeview--default js-Treeview u-text-r-xs">
                    {foreach $classification as $className => $objects}
                        <li>
                          <a href="#">{$className}</a>
                          {if $objects|count()|gt(0)}
                            <ul>
                              {foreach $objects as $object}
                                <li>{node_view_gui content_node=$object.main_node view='text_linked'}</li>
                              {/foreach}
                            </ul>
                          {/if}
                        </li>
                    {/foreach}
                </ul>
            </div>
        </div>
    {/if}
    {undef $classification}

    {* COLONNA DEFINITA NEL EZFLOW DEL FOLDER *}
    {if and( $node|has_attribute('layout'), $node|attribute('layout').content.zone_layout|eq('1ZonesLayoutFolder'), $node.depth|gt(2))}
        <div class="data_map_layout nav-section">
            {attribute_view_gui attribute=$node.data_map.layout}
        </div>
    {elseif $openpa.content_globalinfo.has_content}
        <div class="data_map_layout nav-section">
            {attribute_view_gui attribute=$openpa.content_globalinfo.object.data_map.page}
        </div>
    {/if}

    {*if $openpa.content_reverse_related.has_data}
        {include name = reverse_related_objects
        node = $node
        title = 'References'|i18n('openpa/sidebar')
        uri = 'design:parts/reverse_related_objects.tpl'}
    {/if*}


</div>
