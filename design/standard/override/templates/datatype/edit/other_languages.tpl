{def $languages = fetch('content', 'prioritized_languages')}
{default attribute_base=ContentObjectAttribute}
{let selected_id_array=$attribute.content}
<div class="Form-field{if $attribute.has_validation_error} has-error{/if}">
    {* Always set the .._selected_array_.. variable, this circumvents the problem when nothing is selected. *}
    <input type="hidden" name="{$attribute_base}_ezselect_selected_array_{$attribute.id}" value=""/>
    <label class="Form-label {if $attribute.is_required}is-required{/if}"
           for="ezcoa-{$attribute.contentclassattribute_id}_{$attribute.contentclass_attribute_identifier}">
        {first_set( $contentclass_attribute.nameList[$content_language], $contentclass_attribute.name )|wash}
        {if $attribute.is_information_collector} <em class="collector">{'information collector'|i18n( 'design/admin/content/edit_attribute' )}</em>{/if}
        {if $attribute.is_required} ({'required'|i18n('design/ocbootstrap/designitalia')}){/if}
    </label>
	<fieldset class="Form-field Form-field--choose">
	{foreach $attribute.class_content.options as $index => $option}
		<label class="Form-label Form-label--block other-language other-language-{$option.name}"
	           {if $index|eq(0)}{if $selected_id_array|contains( $option.id )|not()}style="display:none"{/if}{/if}
	           for="ezcoa-{if ne( $attribute_base, 'ContentObjectAttribute' )}{$attribute_base}-{/if}{$attribute.contentclassattribute_id}_{$attribute.contentclass_attribute_identifier}-{$option.id}">
	        <input class="Form-input"
	               id="ezcoa-{if ne( $attribute_base, 'ContentObjectAttribute' )}{$attribute_base}-{/if}{$attribute.contentclassattribute_id}_{$attribute.contentclass_attribute_identifier}-{$option.id}"
	               name="{$attribute_base}_ezselect_selected_array_{$attribute.id}[]"               
	               {if $selected_id_array|contains( $option.id )}checked="checked"{/if}
	               value="{$option.id|wash()}"
	               type="checkbox">
	        <span class="Form-fieldIcon" role="presentation"></span>

	        {foreach $languages as $language}
	        	{if $language.locale|eq($option.name)}{$language.name|wash()}{/if}
        	{/foreach}
	    </label>
	{/foreach}
	</fieldset>
</div>
{/let}
{/default}
{undef $languages}