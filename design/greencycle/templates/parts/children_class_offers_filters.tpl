{def $currentClass = false()
	 $classes = array(fetch(content, class, hash(class_id, 'offer')))}

{if and( is_set($data), $data.is_search_request)}
  {set $currentClass = cond( is_set( $data.fetch_parameters.class_id ), $data.fetch_parameters.class_id, $classes[0].id )}
{elseif count( $classes )|eq(1)}
  {set $currentClass = $classes[0].id}
{/if}

{foreach $classes as $class}
  <div class="openpa-widget nav-section">
    <h2 class="openpa-widget-title">Cerca {$class.name|wash()|downcase()}</h2>

    {class_search_form( $class.identifier, hash( 'RedirectNodeID', $node.node_id ) )}
  </div>
{/foreach}
