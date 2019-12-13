{default attribute_base='ContentObjectAttribute' html_class='full' placeholder=false()}
<div class="Form-field{if $attribute.has_validation_error} has-error{/if}">      
      <label class="Form-label {if $attribute.is_required}is-required{/if}"
             for="ezcoa-{$attribute.contentclassattribute_id}_{$attribute.contentclass_attribute_identifier}">
          {first_set( $contentclass_attribute.nameList[$content_language], $contentclass_attribute.name )|wash}
          {if $attribute.is_information_collector} <em class="collector">{'information collector'|i18n( 'design/admin/content/edit_attribute' )}</em>{/if}
          {if $attribute.is_required} ({'required'|i18n('design/ocbootstrap/designitalia')}){/if}
      </label>

      {if $contentclass_attribute.description}
          <em class="attribute-description">{first_set( $contentclass_attribute.descriptionList[$content_language], $contentclass_attribute.description)|wash}</em>
      {/if}

      <select id="ezcoa-{if ne( $attribute_base, 'ContentObjectAttribute' )}{$attribute_base}-{/if}{$attribute.contentclassattribute_id}_{$attribute.contentclass_attribute_identifier}"
              class="main-language-selector Form-input ezcc-{$attribute.object.content_class.identifier} ezcca-{$attribute.object.content_class.identifier}_{$attribute.contentclass_attribute_identifier}"
              name="{$attribute_base}_ezstring_data_text_{$attribute.id}">
          {foreach fetch('content', 'prioritized_languages') as $language}
            <option value="{$language.locale}" {if $language.locale|eq($attribute.data_text)}selected="selected"{/if}>{$language.name|wash()}</option>
          {/foreach}
      </select>
  </div>
{/default}
<script>{literal}
$(document).ready(function(){
    var mainLanguageSelector = $('.main-language-selector');
    mainLanguageSelector.on('change', function(){
      $('.other-language').show();
      $('.other-language-'+$(this).val()).hide().find('input[type="checkbox"]').prop('checked', false);
    });    
});
{/literal}</script>