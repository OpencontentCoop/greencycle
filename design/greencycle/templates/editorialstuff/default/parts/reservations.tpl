<div class="panel-body">
    <div class="u-padding-all-l">  
        {if $post.object|has_attribute('current_reservation')}   
            {def $reservation = $post.object|attribute('current_reservation').content}
            {def $is_approved = cond($reservation.data_map.approved.data_int|eq(1), true(), false())}

            <div class="u-padding-bottom-l">
                            
                {if $is_approved}
                    <h1>{'Approved reservation'|i18n('greencycle')} #{$reservation.id}</h1>
                {else}
                    <h1>{'Current reservation'|i18n('greencycle')} #{$reservation.id}</h1>
                {/if}

                <div class="Grid Grid--withGutter u-padding-top-s">
                    <div class="Grid-cell u-size2of12"><strong>Author</strong></div>
                    <div class="Grid-cell u-size10of12">
                        {$reservation.owner.name}<br />
                        Phone: {$reservation.owner.data_map.phone.content}<br />
                        Email: {$reservation.owner.data_map.user_account.content.email}
                    </div>
                </div>

                {foreach $reservation.data_map as $identifier => $attribute}
                    {if array('subject', 'approved', 'rejected')|contains($identifier)|not()}
                    <div class="Grid Grid--withGutter u-padding-top-s">
                      <div class="Grid-cell u-size2of12"><strong>{$attribute.contentclass_attribute_name}</strong></div>
                      <div class="Grid-cell u-size10of12">{attribute_view_gui attribute=$attribute image_class=medium}</div>
                    </div>
                    {/if}
                {/foreach}

                {if $is_approved|not()}
                <div class="u-padding-top-m">
                    <form method="post" action="{"content/action"|ezurl(no)}" style="display: inline;">
                        <input type="hidden" name="ContentObjectLanguageCode" value="{ezini( 'RegionalSettings', 'ContentObjectLocale', 'site.ini')}"/>
                        <button class="Button" type="submit" name="EditButton">{'Edit Reservation'|i18n('editorialstuff/dashboard')}</button>
                        <input type="hidden" name="HasMainAssignment" value="1"/>
                        <input type="hidden" name="ContentObjectID" value="{$reservation.id}"/>
                        <input type="hidden" name="NodeID" value="{$reservation.main_node.node_id}"/>
                        <input type="hidden" name="ContentNodeID" value="{$reservation.main_node.node_id}"/>
                        
                        {def $avail_languages = $post.object.available_languages
                             $content_object_language_code = ''
                             $default_language = $post.object.default_language}
                        {if and( $avail_languages|count|ge( 1 ), $avail_languages|contains( $default_language ) )}
                            {set $content_object_language_code = $default_language}
                        {else}
                            {set $content_object_language_code = ''}
                        {/if}
                        <input type="hidden" name="ContentObjectLanguageCode" value="{$content_object_language_code}"/>
                        <input type="hidden" name="RedirectIfDiscarded" value="{concat('editorialstuff/edit/', $factory_identifier, '/',$post.object.id)}"/>
                        <input type="hidden" name="RedirectURIAfterPublish" value="{concat('editorialstuff/edit/', $factory_identifier, '/',$post.object.id)}"/>
                    </form>

                    <form action="{concat('editorialstuff/action/', $factory_identifier, '/', $post.object_id, '#tab_reservations')|ezurl(no)}" style="display: inline;" method="post">                    
                        <input type="hidden" name="ActionIdentifier" value="ActionApproveReservation" />
                        <button class="Button Button--info" type="submit" name="ActionApproveReservation">{'Approve Reservation'|i18n('editorialstuff/dashboard')}</button>                                            
                    </form>
                    <form action="{concat('editorialstuff/action/', $factory_identifier, '/', $post.object_id, '#tab_reservations')|ezurl(no)}" style="display: inline;" method="post">                    
                        <input type="hidden" name="ActionIdentifier" value="ActionRejectReservation" />
                        <button class="Button Button--danger" type="submit" name="ActionRejectReservation">{'Reject Reservation'|i18n('editorialstuff/dashboard')}</button>                                            
                    </form>
                </div>
                {/if}
            </div>

        {/if}

        {if $post.object.main_node.children_count}
        <h2>{'Reservation history'}</h2>

        <div class="table-responsive">
            <table class="Table Table--striped Table--hover Table--withBorder">
                <thead>
                    <tr class="u-border-bottom-xs">
                        <th>{'Id'|i18n('editorialstuff/dashboard')}</th>
                        <th>{'Date'|i18n('editorialstuff/dashboard')}</th>
                        <th>{'Author'|i18n('editorialstuff/dashboard')}</th>   
                        <th>{'Notes'|i18n('editorialstuff/dashboard')}</th>                    
                    </tr>
                </thead>
                <tbody>
                    {foreach $post.object.main_node.children as $child}
                    {if and(is_set($reservation), $reservation.id|eq($child.contentobject_id))}{skip}{/if}
                        <tr>
                            <td class="u-textLeft">{$child.object.id}</td>
                            <td class="u-textLeft">{$child.object.published|l10n( shortdatetime )}</td>
                            <td class="u-textLeft">{$child.object.owner.name|wash()}</td> 
                            <td class="u-textLeft">{attribute_view_gui attribute=$child.object.data_map.acceptance_rejection}</td>                            
                        </tr>
                    {/foreach}
                </tbody>
            </table>
        </div>
        
        {/if}
    </div>
</div>