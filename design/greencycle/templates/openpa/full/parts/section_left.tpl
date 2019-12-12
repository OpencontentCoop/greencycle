{if or($openpa.control_menu.show_extra_menu, $openpa.control_children.current_view|eq('offers_filters'), $openpa.control_children.current_view|eq('requests_filters'), $show_left, is_set($extra_template))}
  <div class="extra">

    {if ezini('GeneralSettings','SocialButtons', 'openpa.ini')|eq('enabled')}
      {include uri='design:openpa/full/parts/social_buttons.tpl'}
    {/if}

    {if or(is_set($extra_template), $openpa.control_menu.show_extra_menu, $openpa.control_children.current_view|eq('offers_filters'), $openpa.control_children.current_view|eq('requests_filters'))}
      {if and(is_set($extra_template), $extra_template|ne(false()))}
        {include uri=$extra_template}
      {else}
        {include uri='design:openpa/full/parts/section_left_extra.tpl'}
      {/if}
    {/if}

    {if $show_left}
      <div class="nav-section" id="subnav">
        {if count($tree_menu.children)|gt(0)}
          {if and($openpa.control_menu.side_menu.root_node, $openpa.control_menu.side_menu.root_node.node_id|ne($node.node_id))}
            <h2 class="openpa-widget-title"><a href="{$openpa.control_menu.side_menu.root_node.url_alias|ezurl(no)}">{$openpa.control_menu.side_menu.root_node.name|wash()}</a></h2>
          {/if}
          <ul class="Linklist Linklist--padded Treeview Treeview--default js-Treeview u-text-r-xs">
            {foreach $tree_menu.children as $menu_item}
              {include name=side_menu uri='design:menu/side_menu_item.tpl' menu_item=$menu_item current_node=$node recursion=1}
            {/foreach}
          </ul>
        {/if}
      </div>
    {/if}

    {if array('offer', 'request')|contains($node.class_identifier)}
      {include uri='design:openpa/full/parts/reservation.tpl'}
    {/if}

    {include uri='design:openpa/full/parts/back_to_main_content.tpl'}
  </div>
  {ezpagedata_set('has_sidemenu', true())}
{/if}

