<section class="u-layout-medium u-layoutCenter">

    {if $success}
        <div class="Prose Alert Alert--warning" role="alert">
            <i class="fa fa-check fa-5x"></i>
            <h3>{"The data has been saved and sent for validation"|i18n('greencycle/register')}</h3>
            <h4>{"When they are validated you will be sent an email notification to the address you specified"|i18n('greencycle/register')}</h4>
        </div>
    
    {else}

        <div class="title">
            <h1 class="u-padding-all-s">{'Register your organization'|i18n('greencycle/register')}</h1>
        </div>

        {if and(is_set($view_parameters.error), $view_parameters.error|eq('invalid_recaptcha'))}
        <div class="Prose Alert Alert--warning" role="alert">
            <p>{'Security code'|i18n( 'greencycle/register' )} {'Input required.'|i18n( 'kernel/classes/datatypes' )}</p>
        </div>
        {/if}

        <form enctype="multipart/form-data" action="{"/register/organization"|ezurl(no)}" method="post"
              name="RegisterAssociazione"
              class="Form Form--spaced  u-text-r-xs">

            {if $validation.processed}
                {if $validation.attributes|count|gt(0)}
                    <div class="Prose Alert Alert--warning" role="alert">
                        <ul>
                            {foreach $validation.attributes as $attribute}
                                <li>{$attribute.name}: {$attribute.description}</li>
                            {/foreach}
                        </ul>
                    </div>
                {/if}
            {/if}

            {def $exclude = array()}

            {if count($content_attributes)|gt(0)}


                <div class="u-background-grey-10 u-color-grey-90">
                    {foreach $content_attributes as $attribute}
                        {def $class_attribute = $attribute.contentclass_attribute}

                        {if $exclude|contains($class_attribute.identifier)}
                            {undef $class_attribute}
                            {skip}
                        {/if}
                    
                        {if or($class_attribute.category|eq('content'), $class_attribute.category|eq(''))}
                            <div class="ezcca-edit-datatype-{$attribute.data_type_string} u-padding-all-s">
                                {attribute_edit_gui attribute_base=$attribute_base attribute=$attribute view_parameters=$view_parameters html_class='Form-input' contentclass_attribute=$class_attribute}
                                <input type="hidden" name="ContentObjectAttribute_id[]" value="{$attribute.id}"/>
                            </div>
                        {/if}

                        {undef $class_attribute}
                    {/foreach}

                    {def $bypass_captcha = false()}
                    {if $bypass_captcha|not}
                    <div class="ezcca-edit-datatype-recaptcha u-padding-all-s">
                        <div class="Form-field">
                            <label class="Form-label is-required">{'Security code'|i18n( 'greencycle/register' )}</label>
                            {if $recaptcha_public_key|not()}
                                <div class="message-warning">
                                    {'ReCAPTCHA API key not found'|i18n( 'greencycle/register' )}
                                </div>
                            {else}
                                <div class="g-recaptcha" data-sitekey="{$recaptcha_public_key}"></div>
                                <script type="text/javascript" src="https://www.google.com/recaptcha/api.js?hl={fetch( 'content', 'locale' ).country_code|downcase}"></script>
                            {/if}
                        </div>
                    </div>                    
                    {/if}
                    {undef $bypass_captcha}

                </div>
                
                <div class="Grid Grid--withGutter u-padding-top-xxl u-margin-bottom-xxl">
                    <input type="hidden" name="UserID" value="{$content_attributes[0].contentobject_id}"/>                    
                    <div class="Grid-cell u-size1of2">
                        <input class="Button Button--danger" type="submit" id="CancelButton"
                               name="CancelButton"
                               value="{'Cancel'|i18n('greencycle/register')}"
                               onclick="window.setTimeout( disableButtons, 1 ); return true;"/>
                   </div>
                   <div class="Grid-cell u-size1of2">
                        <input class="Button Button--default pull-right" type="submit" id="PublishButton"
                               name="PublishButton" value="{'Register'|i18n('greencycle/register')}"
                               onclick="window.setTimeout( disableButtons, 1 ); return true;"/>
                   </div>
                </div>
            {else}
                <div class="alert alert-danger">
                    <p>{"Unable to register new user"|i18n("design/ocbootstrap/user/register")}</p>
                </div>
                <input class="Button Button--danger" type="submit" id="CancelButton" name="CancelButton"
                       value="{'Cancel'|i18n('greencycle/register')}"
                       onclick="window.setTimeout( disableButtons, 1 ); return true;"/>
            {/if}
        </form>

    {/if}

    {literal}
    <script type="text/javascript">
        function disableButtons() {
            document.getElementById('PublishButton').disabled = true;
            document.getElementById('CancelButton').disabled = true;
        }
    </script>
    {/literal}

</section>