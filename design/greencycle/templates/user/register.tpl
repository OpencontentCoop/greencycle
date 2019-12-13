<div class='Grid u-padding-bottom-xxl'>
    <div class='Grid-cell u-md-size1of2 u-lg-size1of2 u-md-before1of4 u-lg-before1of4'>

        <form class="Form Form--spaced form-signin" enctype="multipart/form-data"
              action={"/user/register/"|ezurl} method="post" name="Register">

            <h1 class="u-textCenter u-text-h2 u-padding-bottom-m">{"Register user"|i18n("design/ocbootstrap/user/register")}</h1>


            {if and( and( is_set( $checkErrNodeId ), $checkErrNodeId ), eq( $checkErrNodeId, true() ) )}
                <div class="alert alert-danger">
                    <h2><span class="time">[{currentdate()|l10n( shortdatetime )}]</span> {$errMsg}</h2>
                </div>
            {/if}

            {if $validation.processed}

                {if $validation.attributes|count|gt(0)}
                    <div class="alert alert-danger">
                        <p><strong>{"Input did not validate"|i18n("design/ocbootstrap/user/register")}</strong></p>
                        <ul>
                            {foreach $validation.attributes as $attribute}
                                <li>{$attribute.name}: {$attribute.description}</li>
                            {/foreach}
                        </ul>
                    </div>
                {else}
                    <div class="alert alert-success">
                        <p><strong>{"Input was stored successfully"|i18n("design/ocbootstrap/user/register")}</strong>
                        </p>
                    </div>
                {/if}

            {/if}

            {if count($content_attributes)|gt(0)}

                        {foreach $content_attributes as $attribute}
                            <input type="hidden" name="ContentObjectAttribute_id[]" value="{$attribute.id}"/>
                            <p>{attribute_edit_gui attribute=$attribute html_class="form-control input-lg" placeholder=$attribute.contentclass_attribute.name contentclass_attribute=$attribute.contentclass_attribute}</p>
                        {/foreach}

                <div class="buttonblock u-padding-top-l">
                    <input type="hidden" name="UserID" value="{$content_attributes[0].contentobject_id}"/>
                    {if and( is_set( $checkErrNodeId ), $checkErrNodeId )|not()}
                        <input class="Button Button--default pull-right" type="submit" id="PublishButton"
                               name="PublishButton" value="{'Register'|i18n('design/ocbootstrap/user/register')}"
                               onclick="window.setTimeout( disableButtons, 1 ); return true;"/>
                    {else}
                        <input class="Button Button--default pull-right" type="submit" id="PublishButton"
                               name="PublishButton" disabled="disabled"
                               value="{'Register'|i18n('design/ocbootstrap/user/register')}"
                               onclick="window.setTimeout( disableButtons, 1 ); return true;"/>
                    {/if}
                    <input class="Button Button--info pull-left" type="submit" id="CancelButton" name="CancelButton"
                           value="{'Discard'|i18n('design/ocbootstrap/user/register')}"
                           onclick="window.setTimeout( disableButtons, 1 ); return true;"/>
                </div>
            {else}
                <div class="alert alert-danger">
                    <p>{"Unable to register new user"|i18n("design/ocbootstrap/user/register")}</p>
                </div>
                <input class="btn btn-primary" type="submit" id="CancelButton" name="CancelButton"
                       value="{'Back'|i18n('design/ocbootstrap/user/register')}"
                       onclick="window.setTimeout( disableButtons, 1 ); return true;"/>
            {/if}
        </form>
    </div>
</div>

{literal}
    <script>
        function disableButtons() {
            document.getElementById('PublishButton').disabled = true;
            document.getElementById('CancelButton').disabled = true;
        }
    </script>
{/literal}
