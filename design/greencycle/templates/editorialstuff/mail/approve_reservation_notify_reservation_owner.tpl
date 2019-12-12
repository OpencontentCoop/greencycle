{set-block scope=root variable=reply_to}{fetch(user,current_user).email}{/set-block}
{set-block scope=root variable=subject}{'Your reservation on'|i18n('editorialstuff/mail')} {$post.object.name|wash()}{/set-block}
{set-block scope=root variable=content_type}text/html{/set-block}

<p>{'We inform you that the entered reservation has been approved'|i18n('editorialstuff/mail')} <a href="{$post.object.main_node.url_alias|ezurl(no,full)}">{$post.object.name|wash()}</a></p>

<p>- Best regards</p>
