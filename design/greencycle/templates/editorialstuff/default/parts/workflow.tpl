{def $index = 0}
<div class="Grid-cell u-sizeFull u-margin-top-m u-margin-bottom-xl">
{foreach $post.states as $key => $state}
  {set $index = $index|inc()}
  {if $state.id|eq( $post.current_state.id )}
    <span title="Lo stato corrente è {$state.current_translation.name|wash}" data-toggle="tooltip" data-placement="top" class="Button Button--default u-text-r-xs">
      {$state.current_translation.name|wash}
    </span>
  {else}
    {if $post.object.allowed_assign_state_id_list|contains($state.id)}
    <a title="Clicca per impostare lo stato a {$state.current_translation.name|wash}" class="Button Button--info u-text-r-xs" href="{concat('editorialstuff/state_assign/', $factory_identifier, '/', $key, "/", $post.object.id )|ezurl(no)}">
      {$state.current_translation.name|wash}
    </a>    
    {/if}
  {/if}
{/foreach}
</div>
{undef $index}
