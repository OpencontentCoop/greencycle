{if $openpa.control_cache.no_cache}
    {set-block scope=root variable=cache_ttl}0{/set-block}
{/if}

{if $openpa.content_tools.editor_tools}
    {include uri=$openpa.content_tools.template}
{/if}

{def $show_left = false()}
{def $class = fetch(content, class, hash(class_id, 'offer'))}

{*def $line_attribute_groups = class_extra_parameters($class.identifier, 'line_view').show*}

<div class="openpa-full class-{$node.class_identifier}">
    <div class="title">
        {include uri='design:openpa/full/parts/node_languages.tpl'}
        <h2>{$node.name|wash()}</h2>
    </div>
    <div class="content-container">
        <div class="content">

            <div class="Grid Grid--withGutter">
                <div class="Grid-cell u-sizeFull u-sm-size2of3 u-md-size2of3 u-lg-size2of3">
                    <div class="Grid Grid--withGutter data-offers"></div>
                </div>
                <div class="Grid-cell u-sizeFull u-sm-size1of3 u-md-size1of3 u-lg-size1of3">
                    <div class="u-padding-left-m">
                        {include uri='design:openpa/full/parts/social_buttons.tpl'}
                        
                        <h2 class="openpa-widget-title"><i class="fa fa-search" aria-hidden="true"></i> Search</h2>
                        
                        <form class="filter-offers">
                            <div class="form-group">
                                <legend><strong>{'Languages'|i18n('extension/greencycle')}</strong></legend>
                                {foreach fetch('content', 'prioritized_languages') as $language}
                                    <fieldset class="Form-field Form-field--choose">                                            
                                        <label class="Form-label"
                                               for="language-{$language.locale|wash()}">
                                            <input class="Form-input"
                                                   id="language-{$language.locale|wash()}"
                                                   data-language_id="{$language.locale|wash()}"
                                                   value="{$language.locale|wash()}"
                                                   type="checkbox">
                                            <span class="Form-fieldIcon u-margin-right-xxs" role="presentation"></span> {$language.name|wash()}
                                    </fieldset>
                                {/foreach}
                            </div>                         

                            <div class="form-group">
                              <label for="search-for-query">{'Search text'|i18n('extension/ocsearchtools')}</label>  
                              <input type="text" class="form-control" data-search="q" name="query" id="search-for-query" value="">
                            </div> 
                            
                            <div class="form-group">
                                {def $attribute_municipality = $class.data_map.municipality}
                                <legend><strong>{$attribute_municipality.name|wash()}</strong></legend>
                                {foreach fetch(content, list, hash('parent_node_id', $attribute_municipality.content.default_placement.node_id, 
                                                                   'sort_by', array('name', true()), 
                                                                   'class_filter_type', 'include', 
                                                                   'class_filter_array', $attribute_municipality.content.class_constraint_list)) as $municipality}
                                    <fieldset class="Form-field Form-field--choose">                                            
                                        <label class="Form-label"
                                               for="municipality-{$municipality.contentobject_id|wash()}">
                                            <input class="Form-input"
                                                   id="municipality-{$municipality.contentobject_id|wash()}"
                                                   data-municipality_id="{$municipality.contentobject_id|wash()}"
                                                   value=""
                                                   type="checkbox">
                                            <span class="Form-fieldIcon u-margin-right-xxs" role="presentation"></span> {$municipality.name|wash()}
                                    </fieldset>
                                {/foreach}
                            </div>
                            
                            {def $attribute_tags = array('material_category', 'format', 'unit', 'waste_management_hierarchy')}
                            {foreach $attribute_tags as $attribute_tag}                    
                                {def $tag_tree = api_tagtree($class.data_map[$attribute_tag].data_int1)}
                                {if is_set($tag_tree.children)}                                                 
                                <div class="form-group tag-container">
                                    <legend><strong>{$class.data_map[$attribute_tag].name|wash()}</strong></legend>
                                    {foreach $tag_tree.children as $index => $tag}
                                        <fieldset class="Form-field Form-field--choose">                                            
                                            <label class="Form-label"
                                                   for="tag-{$tag.id|wash()}">
                                                <input class="Form-input"
                                                       id="tag-{$tag.id|wash()}"
                                                       data-tag_id="{$tag.id|wash()}"
                                                       value=""
                                                       type="checkbox">
                                                <span class="Form-fieldIcon u-margin-right-xxs" role="presentation"></span> {$tag.keyword|wash()}
                                        </fieldset>
                                            {if $tag.hasChildren}  
                                            <div class="u-margin-left-l" style="font-size:.8em">                                              
                                                {foreach $tag.children as $childTag}
                                                    <fieldset class="Form-field Form-field--choose">                                            
                                                        <label class="Form-label"
                                                               for="tag-{$childTag.id|wash()}">
                                                            <input class="Form-input"
                                                                   id="tag-{$childTag.id|wash()}"
                                                                   data-tag_id="{$childTag.id|wash()}"
                                                                   value=""
                                                                   type="checkbox">
                                                            <span class="Form-fieldIcon u-margin-right-xxs" role="presentation"></span> {$childTag.keyword|wash()}
                                                    </fieldset>
                                                {/foreach}     
                                            </div>                                           
                                            {/if}                                                                            
                                    {/foreach}
                                </div>
                                {/if}
                            {undef $tag_tree}
                            {/foreach}  

                            <div class="form-group">
                              <label for="search-for-quantity">{$class.data_map.quantity.name|wash()}</label>  
                              <input type="number" class="form-control" data-search="quantity" name="query" id="search-for-quantity" value="">
                            </div>

                            {*<div class="form-group">
                              <label for="search-for-availability">{'Availability'|i18n('extension/greencycle')}</label>  
                              <input type="text" class="form-control" data-search="availability" name="query" id="search-for-availability" value="">
                            </div>*}   
                        </form>
                    </div>
                </div>

            </div>
        
        </div>    
    </div>
</div>

{literal}
<script id="tpl-data-spinner" type="text/x-jsrender">
<div class="Grid-cell u-sizeFull spinner u-margin-all-lg text-center">
    <i class="fa fa-circle-o-notch fa-spin fa-3x fa-fw"></i>
    <span class="sr-only">{/literal}{'Loading...'|i18n('agenda')}{literal}</span>
</div>
</script>
<script id="tpl-data-results" type="text/x-jsrender">
{{if totalCount == 0}}
        <div class="Grid-cell u-sizeFull text-center">
            <i class="fa fa-times"></i> {/literal}{'No contents'|i18n('extension/greencycle')}{literal}
        </div>
{{else}}
    {{for searchHits}}
    <div class="Grid-cell u-sizeFull u-sm-size1of2 u-md-size1of2 u-lg-size1of2 u-margin-bottom-m">
        <div class="u-nbfc u-border-all-xxs u-color-grey-30 u-background-white">
            {{if ~imageUrl(~i18nWithFallback(data, 'image'))}}
                <img src="{{:~imageUrl(~i18nWithFallback(data, 'image'))}}" class="u-sizeFull" alt="{{:~i18nWithFallback(data, 'title')}}" style="height:200px;object-fit: cover;"/>
            {{/if}}            
            <div class="u-text-r-l u-padding-r-all u-layout-prose">
                {{if ~i18nWithFallback(data, 'municipality')}}
                <p class="u-text-h6 u-margin-bottom-xxs">
                    {{for ~i18nWithFallback(data, 'municipality')}}<a class="u-color-50 u-textClean" href="{{:~objectUrl(id)}}">{{:~i18nWithFallback(name)}}</a>{{/for}}                
                    {{if ~i18nWithFallback(data, 'organization')}}
                        - {{for ~i18nWithFallback(data, 'organization')}}<a class="u-color-50 u-textClean" href="{{:~objectUrl(id)}}">{{:~i18nWithFallback(name)}}</a>{{/for}}                    
                    {{/if}}
                </p>
                {{/if}}
                <h3 class="u-text-h4 u-margin-r-bottom">
                    <a class="u-text-r-m u-textWeight-600 u-textClean" href="{{:~objectUrl(metadata.id)}}">{{:~i18nWithFallback(data, 'title')}}</a>
                </h3>  
                {{if ~i18nWithFallback(data, 'expiring_date')}}
                    <p class="u-text-p u-textSecondary">
                        <strong>{/literal}{$class.data_map.expiring_date.name|wash()}{literal}:</strong>
                        {{:~i18nWithFallback(data, 'expiring_date')}}
                    </p>
                {{/if}}     
                {{if ~i18nWithFallback(data, 'address')}}
                    <p class="u-text-p u-textSecondary">
                        <strong>{/literal}{$class.data_map.address.name|wash()}{literal}:</strong>
                        {{:~i18nWithFallback(data, 'address')}}
                    </p>
                {{/if}}                         
                {{if ~i18nWithFallback(data, 'material_category')}}
                    <p class="u-text-p u-textSecondary">
                        <strong>{/literal}{$class.data_map.material_category.name|wash()}{literal}:</strong>
                        {{:~i18nWithFallback(data, 'material_category')}}
                    </p>
                {{/if}} 
                {{if ~i18nWithFallback(data, 'format')}}
                    <p class="u-text-p u-textSecondary">
                        <strong>{/literal}{$class.data_map.format.name|wash()}{literal}:</strong>
                        {{:~i18nWithFallback(data, 'format')}}
                    </p>
                {{/if}}
                {{if ~i18nWithFallback(data, 'unit')}}
                    <p class="u-text-p u-textSecondary">
                        <strong>{/literal}{$class.data_map.unit.name|wash()}{literal}:</strong>
                        {{:~i18nWithFallback(data, 'unit')}}
                    </p>
                {{/if}}
                {{if ~i18nWithFallback(data, 'waste_management_hierarchy')}}
                    <p class="u-text-p u-textSecondary">
                        <strong>{/literal}{$class.data_map.waste_management_hierarchy.name|wash()}{literal}:</strong>
                        {{:~i18nWithFallback(data, 'waste_management_hierarchy')}}
                    </p>
                {{/if}}                
            </div>
        </div>        
    </div>
    {{/for}}
{{/if}}

{{if pageCount > 1}}
<div class="Grid-cell u-sizeFull">
    <div class="u-flex u-flexWrap u-sm-flexJustifyCenter u-md-flexJustifyCenter u-lg-flexJustifyCenter u-padding-top-l">
        <div class="FlexItem page-item {{if !prevPageQuery}}disabled{{/if}}">
            <a class="page-link prevPage Button Button--info {{if !prevPageQuery}}is-disabled{{/if}}" {{if prevPageQuery}}data-page="{{>prevPage}}"{{/if}} href="#">
                <i class="fa fa-arrow-left"></i>
                <span class="sr-only">Pagina precedente</span>
            </a>
        </div>
        <!--{{for pages ~current=currentPage}}
            <div class="FlexItem page-item{{if ~current == query}} active{{/if}}">
                <a href="#" class="page-link page Button Button--info {{if ~current == query}}is-disabled{{/if}}" data-page_number="{{:page}}" data-page="{{:query}}"{{if ~current == query}} data-current aria-current="page"{{/if}}>{{:page}}</a>
            </div>
        {{/for}}-->
        <div class="FlexItem page-item {{if !nextPageQuery}}disabled{{/if}}">
            <a class="page-link nextPage Button Button--info {{if !nextPageQuery}}is-disabled{{/if}}" {{if nextPageQuery}}data-page="{{>nextPage}}"{{/if}} href="#">
                <span class="sr-only">Pagina successiva</span>
                <i class="fa fa-arrow-right"></i>
            </a>
        </div>
    </div>
</div>
{{/if}}
</script>
{/literal}

{ezscript_require( array(
    'ezjsc::jquery',
    'jquery.opendataTools.js',
    'moment-with-locales.min.js',        
    'jsrender.js'
))}

{def $current_language=ezini('RegionalSettings', 'Locale')}
{def $moment_language = $current_language|explode('-')[1]|downcase()}
<script>
    moment.locale('{$moment_language}');        
    $.opendataTools.settings('endpoint',{ldelim}
        'search': '{'/offer/search/'|ezurl(no,full)}/'
    {rdelim});    
    $.opendataTools.settings('accessPath', "{''|ezurl(no,full)}");
    $.opendataTools.settings('language', "{$current_language}");    
    $.opendataTools.settings('locale', "{$moment_language}");    
    $.opendataTools.settings('languages', ['{ezini('RegionalSettings','SiteLanguageList')|implode("','")}']);

    {literal}
    $(document).ready(function () {
        $.views.helpers($.extend({}, $.opendataTools.helpers, {
            'objectUrl': function (id) {
                return $.opendataTools.settings('accessPath') + '/openpa/object/' + id;
            },
            'i18nWithFallback': function (data, key) {
                var currentLanguage = $.opendataTools.settings('mainLanguage');
                var fallbackLanguages = $.opendataTools.settings('fallbackLanguages');
                var getData = function(data, key, currentLanguage){
                    var returnData = false;
                    if (data && key) {
                        if (typeof data[currentLanguage] != 'undefined' && data[currentLanguage][key]) {
                            returnData = data[currentLanguage][key];
                        }                    
                    } else if (data) {
                        if (typeof data[currentLanguage] != 'undefined' && data[currentLanguage]) {
                            returnData = data[currentLanguage];
                        }                    
                    }
                    return returnData != 0 ? returnData : false;
                }
                var returnData = getData(data, key, currentLanguage);                
                if (returnData === false){
                    $.each(fallbackLanguages, function(){                        
                        returnData = getData(data, key, ''+this);                        
                        return returnData === false;
                    });
                }

                return returnData;
            },
            'imageUrl': function (images) {                
                if (images.length > 0) {
                    return $.opendataTools.settings('accessPath') + '/offer/image/' + images[0].id;
                }
                return null;
            }
        }));

        var resultsContainer = $('.data-offers');
        var form = $('.filter-offers');
        form[0].reset();
        var limitPagination = 20;
        var currentPage = 0;
        var queryPerPage = [];
        var template = $.templates('#tpl-data-results');
        var spinner = $($.templates("#tpl-data-spinner").render({}));
        var isBuildedTagFilters = false;
        var isBuildedTagMunicipality = false;
        var isBuildedTagLanguage = false;

        var buildQuery = function () {
            var query = 'classes [offer]';            
            var searchText = form.find('[data-search="q"]').val().replace(/"/g, '').replace(/'/g, "").replace(/\(/g, "").replace(/\)/g, "").replace(/\[/g, "").replace(/\]/g, "");
            if (searchText.length > 0) {
                query += " and q = '\"" + searchText + "\"'";
            }
            var quantity = parseInt(form.find('[data-search="quantity"]').val())
            if (quantity > 0) {
                query += " and quantity = '" + quantity + "'";
            }
            form.find('.tag-container').each(function(){
                var tags = [];
                $(this).find('[data-tag_id]:checked').each(function(){
                    tags.push($(this).data('tag_id'));
                });
                if(tags.length > 0){
                    query += " and raw[ezf_df_tag_ids] in [" + tags.join(',') + "]";
                }                
            });

            var languages = [];
            $('[data-language_id][type="hidden"]').each(function(){
                languages.push($(this).val());
            });
            $('[data-language_id]:checked').each(function(){
                languages.push($(this).data('language_id'));
            });
            if(languages.length > 0){
                query += " and raw[meta_language_code_ms] in [" + languages.join(',') + "]";
            }

            var municipalities = [];
            form.find('[data-municipality_id]:checked').each(function(){
                municipalities.push($(this).data('municipality_id'));
            });
            if(municipalities.length > 0){
                query += " and municipality.id in [" + municipalities.join(',') + "]";
            }

            console.log(query);
            query += ' facets [raw[ezf_df_tag_ids]|count|1000,municipality.id,raw[meta_language_code_ms]] sort [score=>desc]';
            return {
                'query': query,
                'languages': languages
            };
        };
        
        var buildTagFilters = function(data){
            if (!isBuildedTagFilters){
                $('[data-tag_id]').parents('fieldset').hide();
                $.each(data, function(index,value){
                    $('[data-tag_id="'+index+'"]').parents('fieldset').show();
                });
                isBuildedTagFilters = true;
            }
        };

        $('[data-tag_id]').on('change', function(){
            currentPage = 0;
            loadContents();
        });
        $('[data-search="q"]').keyup(function(e) {
            var code = e.which;
            if($(this).val().length > 3 || code === 13 || $(this).val() === ''){
                currentPage = 0;
                loadContents();
            }
        });
        $('[data-search="quantity"]').keyup(function(e) {            
            currentPage = 0;
            loadContents();
        });
        $('[data-language_id]').on('change', function(e){            
            if ($(this).prop('readonly')){
                e.preventDefault();
                e.stopPropagation();
                return false;
            }
            if (isBuildedTagLanguage){
                currentPage = 0;
                loadContents();
            }
        });
        $('[data-municipality_id]').on('change', function(){
            currentPage = 0;
            loadContents();
        });

        var buildMunicipalityFilters = function(data){
            if (!isBuildedTagMunicipality){
                $('[data-municipality_id]').parents('fieldset').hide();
                $.each(data, function(index,value){
                    $('[data-municipality_id="'+index+'"]').parents('fieldset').show();
                });
                isBuildedTagMunicipality = true;
            }
        };
        var buildLanguageFilters = function(userLanguages){
            if (!isBuildedTagLanguage){
                $.opendataTools.settings('mainLanguage', userLanguages.main);                
                $('[data-language_id="'+userLanguages.main+'"]').prop('type', 'hidden')
                    .parent().addClass('Form-label-preselected').find('.Form-fieldIcon').addClass('Form-fieldIcon-preselected');
                $.each(userLanguages.others, function(index,value){                    
                    $('[data-language_id="'+value+'"]').prop('checked', 'checked').trigger('change');
                });
                isBuildedTagLanguage = true;
            }
        };

        var find = function (data, cb, context) {
            $.ajax({
                type: "GET",
                url: $.opendataTools.settings('endpoint').search,
                data: data,
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                success: function (data,textStatus,jqXHR) {
                    if(data.error_message || data.error_code){
                        console.log(data.error_message + ' (error: '+data.error_code+')');
                    }else{
                        cb.call(context, data);                    
                    }
                },
                error: function (jqXHR) {
                    var errorCode = jqXHR.status,
                        errorMessage = jqXHR.statusText;
                    console.log(errorMessage + ' (error: '+errorCode+')');
                }
            });
        };

        var loadContents = function () {
            var buildedQuery = buildQuery();
            var baseQuery = buildedQuery.query;
            var paginatedQuery = baseQuery + ' and limit ' + limitPagination + ' offset ' + currentPage * limitPagination;
            resultsContainer.html(spinner);
            $.opendataTools.settings('fallbackLanguages', buildedQuery.languages);
            find({q: paginatedQuery, languages: buildedQuery.languages}, function (response) {
                buildTagFilters(response.facets[0].data);
                buildMunicipalityFilters(response.facets[1].data);                
                queryPerPage[currentPage] = paginatedQuery;
                response.currentPage = currentPage;
                response.prevPage = currentPage - 1;
                response.nextPage = currentPage + 1;
                var pagination = response.totalCount > 0 ? Math.ceil(response.totalCount / limitPagination) : 0;
                var pages = [];
                var i;
                for (i = 0; i < pagination; i++) {
                    queryPerPage[i] = baseQuery + ' and limit ' + limitPagination + ' offset ' + (limitPagination * i);
                    pages.push({'query': i, 'page': (i + 1)});
                }
                response.pages = pages;
                response.pageCount = pagination;

                response.prevPageQuery = jQuery.type(queryPerPage[response.prevPage]) === "undefined" ? null : queryPerPage[response.prevPage];
                
                $.each(response.searchHits, function () {                    
                    this.baseUrl = $.opendataTools.settings('accessPath');
                    var self = this;
                    this.languages = $.opendataTools.settings('languages');
                    var currentTranslations = $(this.languages).filter($.map(this.data, function (value, key) {
                        return key;
                    }));
                    var translations = [];
                    $.each($.opendataTools.settings('languages'), function () {
                        translations.push({
                            'id': self.metadata.id,
                            'language': '' + this,
                            'active': $.inArray('' + this, currentTranslations) >= 0
                        });
                    });
                    this.translations = translations;
                    this.locale = $.opendataTools.settings('language');                    
                });
                var renderData = $(template.render(response));

                resultsContainer.html(renderData);

                resultsContainer.find('.page, .nextPage, .prevPage').on('click', function (e) {
                    if (!$(this).hasClass('is-disabled')){
                        currentPage = $(this).data('page');
                        if (currentPage >= 0) loadContents();
                        $('html, body').stop().animate({
                            scrollTop: resultsContainer.offset().top
                        }, 1000);
                    }
                    e.preventDefault();
                });
                var more = $('<li class="page-item"><span class="page-link">...</span></li');
                var displayPages = resultsContainer.find('.page[data-page_number]');

                var currentPageNumber = resultsContainer.find('.page[data-current]').data('page_number');
                var length = 7;
                if (displayPages.length > (length + 2)) {
                    if (currentPageNumber <= (length - 1)) {
                        resultsContainer.find('.page[data-page_number="' + length + '"]').parent().after(more.clone());
                        for (i = length; i < pagination; i++) {
                            resultsContainer.find('.page[data-page_number="' + i + '"]').parent().hide();
                        }
                    } else if (currentPageNumber >= length) {
                        resultsContainer.find('.page[data-page_number="1"]').parent().after(more.clone());
                        var itemToRemove = (currentPageNumber + 1 - length);
                        for (i = 2; i < pagination; i++) {
                            if (itemToRemove > 0) {
                                resultsContainer.find('.page[data-page_number="' + i + '"]').parent().hide();
                                itemToRemove--;
                            }
                        }
                        if (currentPageNumber < (pagination - 1)) {
                            resultsContainer.find('.page[data-current]').parent().after(more.clone());
                        }
                        for (i = (currentPageNumber + 1); i < pagination; i++) {
                            resultsContainer.find('.page[data-page_number="' + i + '"]').parent().hide();
                        }
                    }
                }
            });
        };        

        $.get('{/literal}{'openpa/data/user_languages'|ezurl(no)}{literal}', function(userLanguages){
            buildLanguageFilters(userLanguages);
            loadContents();
        })        
    });
    {/literal}
</script>
<style>
.Form-label-preselected {ldelim}background: #eee;{rdelim}
.Form-fieldIcon-preselected {ldelim}
    background-image: url("data:image/svg+xml;charset=utf-8,%3Csvg xmlns='http://www.w3.org/2000/svg' width='32' height='32' viewBox='0 0 32 32' stroke='%2365dcdf'%3E%3Ctitle%3Echeckbox-checked%3C/title%3E%3Cpath d='M28.444 0H3.555A3.566 3.566 0 0 0-.001 3.556v24.889c0 1.956 1.6 3.556 3.556 3.556h24.889c1.956 0 3.556-1.6 3.556-3.556V3.556C32 1.6 30.4 0 28.444 0zm-16 24.889L3.555 16l2.489-2.489 6.4 6.4L25.955 6.4l2.489 2.489-16 16z'/%3E%3C/svg%3E");
{rdelim}
</style>