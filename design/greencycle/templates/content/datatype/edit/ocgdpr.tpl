{default attribute_base=ContentObjectAttribute}
<fieldset class="Form-field Form-field--choose">
    <label class="Form-label" for="ezcoa-{if ne( $attribute_base, 'ContentObjectAttribute' )}{$attribute_base}-{/if}{$attribute.contentclassattribute_id}_{$attribute.contentclass_attribute_identifier}">
        <input id="ezcoa-{if ne( $attribute_base, 'ContentObjectAttribute' )}{$attribute_base}-{/if}{$attribute.contentclassattribute_id}_{$attribute.contentclass_attribute_identifier}"
               class="Form-input ezcc-{$attribute.object.content_class.identifier} ezcca-{$attribute.object.content_class.identifier}_{$attribute.contentclass_attribute_identifier}"
               type="checkbox" name="{$attribute_base}_ocgdpr_data_int_{$attribute.id}"
                {$attribute.data_int|choose( '', 'checked="checked"' )}
                {if $attribute.content.is_current_user|not()}disabled="disabled" {/if}
               value="" />
        <span class="Form-fieldIcon" role="presentation"></span>
        <span style="display: inline-block;width: 80%;vertical-align: middle;">{$attribute.contentclass_attribute.content.text} <a target="_blank" href="{$attribute.contentclass_attribute.content.link|wash()}">{$attribute.contentclass_attribute.content.link_text|wash()}</a></span>
    </label>
    {if $attribute.content.is_current_user|not()}
        <input class="btn btn-xs btn-info mt-2" type="submit" name="CustomActionButton[{$attribute.id}_force_reaccept]" value="{'Reset'|i18n('design/admin/user/setting')}" />
    {/if}
</fieldset>
{/default}
