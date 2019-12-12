{if is_set($factories)|not()}
    {def $factories = ezini( 'AvailableFactories', 'Identifiers', 'editorialstuff.ini' )}
{/if}
{if is_set($items_per_page)|not()}
    {def $items_per_page = 10}
{/if}
{def $sections = fetch( 'content', 'section_list' )}
{def $current_user = fetch(user, current_user)}
{def $current_user_class_identifier = $current_user.contentobject.class_identifier}
{def $intervals = array(
    hash( 'value', '1-days', 'name', 'Last day'|i18n('editorialstuff/dashboard') ),
    hash( 'value', '1-weeks', 'name', 'Last 7 days'|i18n('editorialstuff/dashboard') ),
    hash( 'value', '1-months', 'name', 'Last 30 days'|i18n('editorialstuff/dashboard') ),
    hash( 'value', '2-months', 'name', 'Last two months'|i18n('editorialstuff/dashboard') )
)}
<div class="Grid Grid--withGutter">
    {foreach $factories as $factory}
    
        {if and($current_user_class_identifier|eq('private_organization'), $factory|eq('private_organization'))}
            {skip}
        {/if}

        {def $parent = fetch(content, node, hash('node_id', ezini($factory, 'CreationRepositoryNode', 'editorialstuff.ini')))}

        {def $name = $factory}
        {if ezini_hasvariable( $factory, 'Name', 'editorialstuff.ini' )}
          {set $name = ezini( $factory, 'Name', 'editorialstuff.ini' )}
        {/if}
        
        {def $states = fetch('editorialstuff', 'post_states', hash('factory_identifier', $factory))}        
        
        <div class="factory-dashboard Grid-cell u-margin-bottom-xxl" style="position:relative" 
             data-user_id="{$current_user.contentobject_id}"
             data-user_type="{cond($current_user_class_identifier|eq('private_organization'), 'limited', 'full')}">
            
            <h2 class="u-margin-bottom-l">{$name|wash()}</h2>        
            <div class="Grid Grid--withGutter">

                {if and( $parent, $parent.can_create )}
                    <div class="Grid-cell u-sizeFull u-sm-size1of5 u-md-size1of5 u-lg-size1of5 u-margin-bottom-l">
                        <a style="font-size: .8em !important;"
                           href="{concat('editorialstuff/add/',$factory)|ezurl(no)}" class="Button Button--default u-text-r-xs">{ezini($factory, 'CreationButtonText', 'editorialstuff.ini')}</a>
                    </div>
                {/if}

                <div class="Grid-cell u-sizeFull u-sm-size1of5 u-md-size1of5 u-lg-size1of5 u-margin-bottom-l">
                    <input class="Form-input query" name="query" placeholder="{'Search'|i18n('editorialstuff/dashboard')}" style="font-size: .8em;" />
                </div>

                <div class="Grid-cell u-sizeFull u-sm-size1of5 u-md-size1of5 u-lg-size1of5 u-margin-bottom-l">
                    <select class="Form-input dateSelect" name="filter-date" style="font-size: .8em;">>
                        <option value=""> - {'Period'|i18n('editorialstuff/dashboard')}</option>
                        {foreach $intervals as $interval}
                            <option value="{$interval.value}">{$interval.name|wash()}</option>
                        {/foreach}
                    </select>
                </div>

                <div class="Grid-cell u-sizeFull u-sm-size1of5 u-md-size1of5 u-lg-size1of5 u-margin-bottom-l">
                    <select class="Form-input stateSelect" name="filter-state" data-state_group="{ezini($factory, 'StateGroup', 'editorialstuff.ini')}" style="font-size: .8em;">
                        <option value=""> - {'State'|i18n('editorialstuff/dashboard')}</option>
                        {foreach fetch('editorialstuff', 'post_states', hash('factory_identifier', $factory)) as $state}
                            <option value="{$state.id}" data-identifier="{$state.identifier}">{$state.current_translation.name|wash()}</option>
                        {/foreach}
                    </select>
                </div>

                {if $current_user_class_identifier|ne('private_organization')}
                <div class="Grid-cell u-sizeFull u-sm-size1of5 u-md-size1of5 u-lg-size1of5 u-margin-bottom-l">
                    <select class="Form-input sectionSelect" name="section-state" style="font-size: .8em;">
                        <option value=""> - {'Municipality'|i18n('editorialstuff/dashboard')}</option>
                        {foreach $sections as $section}{if $section.identifier|begins_with('municipality_')}
                            <option value="{$section.id}" data-identifier="{$section.identifier}">{$section.name|wash()}</option>
                        {/if}{/foreach}
                    </select>
                </div>
                {/if}

            </div>

            <div class="table-responsive u-margin-bottom-xxl">
                <table class="table table-striped" cellpadding="0" cellspacing="0" border="0"
                       data-limit="{$items_per_page}"
                       data-factory="{$factory}"
                       data-class="{ezini($factory, 'ClassIdentifier', 'editorialstuff.ini')}" 
                       data-parent="{$parent.node_id}">
                    <thead>
                        <tr>
                            <th></th>
                            <th>{'Municipality'|i18n('editorialstuff/dashboard')}</th>
                            <th>{'Author'|i18n('editorialstuff/dashboard')}</th>
                            <th>{'Date'|i18n('editorialstuff/dashboard')}</th>
                            <th>{'State'|i18n('editorialstuff/dashboard')}</th>
                            <th>{'Title'|i18n('editorialstuff/dashboard')}</th>                
                        </tr>
                    </thead>
                    <tbody>
                    </tbody>
                </table>
            </div>   
        </div>
        {undef $name $states $parent} 
    {/foreach}
</div>

{ezscript_require(array(
    'ezjsc::jquery',
    'ezjsc::jqueryUI',
    'jquery.opendataTools.js',
    'jsrender.js',
    'moment-with-locales.min.js'
))}

{literal}
<script id="tpl-spinner" type="text/x-jsrender">
<tr>
    <td colspan="6" class="spinner u-textCenter">
        <i class="fa fa-circle-o-notch fa-spin fa-3x fa-fw"></i>
        <span class="sr-only">{'Loading...'|i18n('agenda')}</span>
    </td>
</tr>
</script>
<script id="tpl-results" type="text/x-jsrender">        
    {{if totalCount > 0}}
        {{for searchHits}}        
            <tr>
                <td class="text-center">
                    <a href="/editorialstuff/edit/{{:factory}}/{{:metadata.id}}" class="btn btn-info">{/literal}{'Detail'|i18n('editorialstuff/dashboard')}{literal}</a>
                </td>
                <td>{{if section}}{{:section.name}}{{/if}}</td>
                <td>{{if metadata.ownerName}}{{:~i18n(metadata.ownerName)}}{{else}}?{{/if}}</td>
                <td>{{:~formatDate(metadata.published, 'D/MM/YYYY')}}</td>
                <td>{{:stateName}}</td>
                <td>{{:~i18n(metadata.name)}}</td>
            </tr>
        {{/for}}
    {{else}}
    <tr>
        <td colspan="6" class="spinner u-textCenter">
            <em>{/literal}{"No content"|i18n( "extension/eztags/tags/view" )}{literal}</em>
        </td>
    </tr>
    {{/if}}
    {{if totalCount > 0}}
    <tr>
        <td colspan="6" class="text-center" style="padding-top:20px;">
            <a href="/exportas/custom/csv_search/{{:baseQuery}}/1">Export data in CSV format</a>
        </td>
    </tr>
    {{/if}}
    {{if pageCount > 1}}
    <tr>
        <td colspan="6" class="text-center" style="padding-top:20px;">
            {{if prevPageQuery}}
                <a style="margin-right:5px" class="prevPage" data-page="{{>prevPage}}" href="#"><i class="fa fa-arrow-left"></i></a>
            {{/if}}  
            {{for pages ~current=currentPage}}                  
                {{if ~current == query}}
                    <span style="color:#fff; border: 1px solid #ccc;background:#ccc; padding: 3px 11px;text-decoration: none;margin: 0 5px;" class="page-link page" data-page="{{:query}}">{{:page}}</span>
                {{else}}
                    <a style="border: 1px solid #ccc;padding: 3px 11px;text-decoration: none;margin: 0 5px;" href="#" class="page-link page" data-page="{{:query}}">{{:page}}</a>
                {{/if}}
            {{/for}}
            {{if nextPageQuery }}    
                <a style="margin-left:5px" class="nextPage" data-page="{{>nextPage}}" href="#"><i class="fa fa-arrow-right"></i></a>
            {{/if}}
        </td>
    </tr>
    {{/if}}    
</script>
<script>
{/literal}
var sectionsMap = [];
{foreach $sections as $section}{if $section.identifier|begins_with('municipality_')}
sectionsMap.push({ldelim}name: "{$section.name|wash(javascript)}", identifier: "{$section.identifier}"{rdelim});
{/if}{/foreach} 

{literal}
$.opendataTools.settings('language', '{/literal}{ezini('RegionalSettings','Locale')}{literal}');
$.views.helpers($.opendataTools.helpers);
$(document).ready(function () {
    $('[data-factory]').each(function(){
        var self = $(this);
        var container = $(this).parents('.factory-dashboard');
        var userType = container.data('user_type');
        var userId = container.data('user_id');
        var resultsContainer = self.find('tbody');        
        var limitPagination = self.data('limit');
        var factory = self.data('factory');
        var selectStateFilter = container.find('select.stateSelect');
        var selectSectionFilter = container.find('select.sectionSelect');
        var selectDateFilter = container.find('select.dateSelect');
        var queryFilter = container.find('input.query');
        var stateGroup = selectStateFilter.data('state_group');
        var currentPage = 0;
        var queryPerPage = [];
        var template = $.templates('#tpl-results');
        var spinner = $.templates('#tpl-spinner');
        
        selectStateFilter.on('change', function(e){            
            currentPage = 0;
            loadContents();
            e.preventDefault();
        });
        selectSectionFilter.on('change', function(e){            
            currentPage = 0;
            loadContents();
            e.preventDefault();
        });
        selectDateFilter.on('change', function(e){            
            currentPage = 0;
            loadContents();
            e.preventDefault();
        });
        queryFilter.on('keydown', function(e){            
            if(e.keyCode === 13){        
                currentPage = 0;
                loadContents();
                e.preventDefault();
            }
        });

        var buildQuery = function(){            
            var stateFilter = selectStateFilter.val();
            var sectionFilter = selectSectionFilter.val();
            var dateFilter = selectDateFilter.val();
            var searchText = queryFilter.val();

            var classIdentifier = self.data('class');
            var parentNodeId = self.data('parent');
            var query = 'classes [' + classIdentifier + '] and subtree [' + parentNodeId + ']';
            if (searchText.length > 0){
                searchText = searchText.replace(/"/g, '').replace(/'/g, "").replace(/\(/g, "").replace(/\)/g, "").replace(/\[/g, "").replace(/\]/g, "");
                query += " and q = '\"" + searchText + "\"'";
            }
            if (stateFilter){
                query += ' and state in [' + stateFilter + ']';
            }
            if (sectionFilter){
                query += ' and section in [' + sectionFilter + ']';
            }
            if (dateFilter){
                var momentModifiers = dateFilter.split('-');                
                query += ' and published range [' + moment().subtract(momentModifiers[0],momentModifiers[1]).format('YYYY-MM-DD HH:mm') + ',*]';
            }
            if (userType == 'limited'){
                query += ' and owner_id in [' + userId + ']';
            }
            query += ' sort [modified=>desc]';
            
            return query;
        };
        
        var loadContents = function(){                      
            resultsContainer.html($(spinner.render({})));
            var baseQuery = buildQuery();
            var paginatedQuery = baseQuery + ' and limit ' + limitPagination + ' offset ' + currentPage*limitPagination;            
            $.opendataTools.find(paginatedQuery, function (response) {              
                queryPerPage[currentPage] = paginatedQuery;
                response.currentPage = currentPage;
                response.prevPage = currentPage - 1;
                response.nextPage = currentPage + 1;
                var pagination = response.totalCount > 0 ? Math.ceil(response.totalCount/limitPagination) : 0;
                var pages = [];
                var i;
                for (i = 0; i < pagination; i++) {                  
                    queryPerPage[i] = baseQuery + ' and limit ' + limitPagination + ' offset ' + (limitPagination*i);                   
                    pages.push({'query': i, 'page': (i+1)});
                } 
                response.pages = pages;
                response.pageCount = pagination;
                response.prevPageQuery = jQuery.type(queryPerPage[response.prevPage]) === "undefined" ? null : queryPerPage[response.prevPage];             
                $.each(response.searchHits, function(){
                    var self = this;
                    this.factory = factory;
                    var stateName = '?';
                    this.section = $.grep(sectionsMap, function(obj){return obj.identifier === self.metadata.sectionIdentifier;})[0];
                    $.each(this.metadata.stateIdentifiers, function(){
                        var groupAndState = this.split('.');
                        if (groupAndState[0] == stateGroup){
                            stateName = selectStateFilter.find('[data-identifier="'+groupAndState[1]+'"]').text();
                        }
                    });
                    this.stateName = stateName;                    
                });
                response.baseQuery = encodeURIComponent(baseQuery);
                var renderData = $(template.render(response));
                resultsContainer.html(renderData);

                resultsContainer.find('.page, .nextPage, .prevPage').on('click', function (e) {
                    currentPage = $(this).data('page');
                    loadContents();
                    e.preventDefault();
                });
                container.removeClass('hide');
            });
        };
        
        loadContents();     
    });
}); 
</script>
{/literal}
{undef $sections}