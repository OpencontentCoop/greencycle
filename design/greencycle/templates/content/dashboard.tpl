{def $factories = ezini( 'AvailableFactories', 'Identifiers', 'editorialstuff.ini' )}
{def $sections = fetch( 'content', 'section_list' )}

<div class="Grid Grid--withGutter">
    {foreach $factories as $factory}
    
        {def $parent = fetch(content, node, hash('node_id', ezini($factory, 'CreationRepositoryNode', 'editorialstuff.ini')))}

        {def $name = $factory}
        {if ezini_hasvariable( $factory, 'Name', 'editorialstuff.ini' )}
          {set $name = ezini( $factory, 'Name', 'editorialstuff.ini' )}
        {/if}
        
        {def $states = fetch('editorialstuff', 'post_states', hash('factory_identifier', $factory))}        
        
        <div class="factory-dashboard Grid-cell u-margin-bottom-xxl" style="position:relative">      
            <h2 class="u-margin-bottom-s">{$name|wash()}</h2>        
            
            {if and( $parent, $parent.can_create )}
                <a style="position: absolute;top: 3px;right: 424px;font-size: .8em;"
                   href="{concat('editorialstuff/add/',$factory)|ezurl(no)}" class="btn btn-primary">{ezini($factory, 'CreationButtonText', 'editorialstuff.ini')}</a>
            {/if}

            <select class="Form-input stateSelect" name="filter-state" data-state_group="{ezini($factory, 'StateGroup', 'editorialstuff.ini')}" style="width: 200px;position: absolute;top: 3px;right: 8px;font-size: .8em;">
            <option value="">{'All'|i18n('editorialstuff/dashboard')}</option>
            {foreach fetch('editorialstuff', 'post_states', hash('factory_identifier', $factory)) as $state}
                <option value="{$state.id}" data-identifier="{$state.identifier}">{$state.current_translation.name|wash()}</option>
            {/foreach}
            </select>

            <select class="Form-input sectionSelect" name="section-state" style="width: 200px;position: absolute;top: 3px;right: 216px;font-size: .8em;">
            <option value="">{'All'|i18n('editorialstuff/dashboard')}</option>
            {foreach $sections as $section}{if $section.identifier|begins_with('municipality_')}
                <option value="{$section.id}" data-identifier="{$section.identifier}">{$section.name|wash()}</option>
            {/if}{/foreach}
            </select>

            <div class="table-responsive u-margin-bottom-xxl">
                <table class="table table-striped" cellpadding="0" cellspacing="0" border="0"
                       data-limit="10"
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
<script id="tpl-results" type="text/x-jsrender">        
    {{for searchHits}}        
        <tr>
            <td class="text-center">
                <a href="/editorialstuff/edit/{{:factory}}/{{:metadata.id}}" class="btn btn-info">{/literal}{'Detail'|i18n('editorialstuff/dashboard')}{literal}</a>
            </td>
            <td>{{if section}}{{:section.name}}{{/if}}</td>
            <td>{{:~i18n(metadata.ownerName)}}</td>
            <td>{{:~formatDate(metadata.published, 'D/MM/YYYY')}}</td>
            <td>{{:stateName}}</td>
            <td>{{:~i18n(metadata.name)}}</td>
        </tr>
    {{/for}}
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
        var resultsContainer = self.find('tbody');        
        var limitPagination = self.data('limit');
        var factory = self.data('factory');
        var selectStateFilter = container.find('select.stateSelect');
        var selectSectionFilter = container.find('select.sectionSelect');
        var stateGroup = selectStateFilter.data('state_group');
        var currentPage = 0;
        var queryPerPage = [];
        var template = $.templates('#tpl-results');
        
        selectStateFilter.on('click', function(e){            
            currentPage = 0;
            loadContents();
            e.preventDefault();
        });
        selectSectionFilter.on('click', function(e){            
            currentPage = 0;
            loadContents();
            e.preventDefault();
        });

        var buildQuery = function(){            
            var stateFilter = selectStateFilter.val();
            var sectionFilter = selectSectionFilter.val();
            var classIdentifier = self.data('class');
            var parentNodeId = self.data('parent');
            var query = 'classes [' + classIdentifier + '] and subtree [' + parentNodeId + ']';
            if (stateFilter){
                query += ' and state in [' + stateFilter + ']';
            }
            if (sectionFilter){
                query += ' and section in [' + sectionFilter + ']';
            }
            query += ' sort [modified=>desc]';
            
            return query;
        };

        var loadContents = function(){                      
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