{set_defaults(hash(
    'page_limit', 10
))}

{def $root_nodes = array( $node.node_id )
     $self = object_handler( $node )}

{def $limitation = hash(
    'accessWord', 'limited', 
    'policies', array(
        hash('Class', array(519), 'StateGroup_offer', array(10))
    )
)}

{def $data = class_search_result(  hash( 
    'subtree_array', $root_nodes, 
    'limitation', $limitation,
    'sort_by', hash( 'name', 'asc' ), 
    'limit', $page_limit ), $view_parameters )}

{if and( $data.is_search_request, is_set( $view_parameters.class_id ) )}
    {include name=class_search_form_result
             uri='design:parts/children_class_search_form_result.tpl'
             data=$data
             page_url=$node.url_alias
             view_parameters=$view_parameters
             page_limit=$page_limit}
{else}

    {def $children_count = fetch( openpa, concat( 'list_count' ), hash( 'parent_node_id', $node.node_id, 'limitation', $limitation['policies'], 'class_filter_type', 'include', 'class_filter_array', array('offer') ) )}
    {if $children_count}
      <div class="content-view-children">
        {foreach fetch( openpa, 'list', hash( 'parent_node_id', $node.node_id,
                                                'offset', $view_parameters.offset,
                                                'sort_by', $node.sort_array,
                                                'limitation', $limitation['policies'],
                                                'class_filter_type', 'include', 'class_filter_array', array('offer'),
                                                'limit', $page_limit ) ) as $child }
          {node_view_gui view='line' content_node=$child}          
        {/foreach}
      </div>

      {include name=navigator
               uri='design:navigator/google.tpl'
               page_uri=$node.url_alias
               item_count=$children_count
               view_parameters=$view_parameters
               item_limit=$page_limit}

    {/if}


{/if}
