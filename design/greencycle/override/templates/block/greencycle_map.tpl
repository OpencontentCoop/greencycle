{ezscript_require( array(
	'ezjsc::jquery',
	'leaflet/leaflet.0.7.2.js',	
	'leaflet-osm-data.js',
	'leaflet/leaflet.markercluster.js',
	'leaflet/Leaflet.MakiMarkers.js',
	'jquery.opendataTools.js'
) )}
{ezcss_require( array(
	'plugins/chosen.css',
	'plugins/leaflet/leaflet.css',
	'plugins/leaflet/map.css',
	'MarkerCluster.css',
	'MarkerCluster.Default.css' 
) )}

{set_defaults(hash( 'height', 800, 'show_title', true()))}

{if $block.view|eq('default_wide')}<div class="u-layout-wide u-layoutCenter u-layout-r-withGutter Grid">{/if}
  {if and( $show_title, $block.name|ne('') )}
    <h3 class="openpa-widget-title">{$block.name|wash()}</h3>
  {/if}
{if $block.view|eq('default_wide')}</div>{/if}

{def $tag_roots = array(257,292,372,452)}
{def $classes = fetch(class, list, hash('class_filter', array('private_organization','offer','request','location','event','municipality','ce_manager','user')))}
{def $icons = hash(
	'private_organization', 'building',
	'offer', 'shop',
	'request', 'heart',
	'location', 'marker',
	'event', 'music',
	'municipality', 'town',
	'ce_manager', 'telephone',
	'user', 'circle'
)}
<div class="Grid u-margin-bottom-m">
    <div class="Grid-cell u-sizeFull u-sm-size2of3 u-md-size2of3 u-lg-size2of3">
        <div id="map-{$block.id}" style="height: {$height}px; width: 100%"></div>
    </div>
    <div class="Grid-cell u-sizeFull u-sm-size1of3 u-md-size1of3 u-lg-size1of3" style="height: {$height}px; overflow-y: auto">
		<div class="Accordion Accordion--default fr-accordion js-fr-accordion u-padding-left-m">
			<h2 class="Accordion-header js-fr-accordion__header fr-accordion__header" id="accordion-header-class">
	      		<span class="Accordion-link">{'What to show'|i18n('greencycle')}</span>
	    	</h2>
	        <div id="accordion-panel-class" class="Accordion-panel fr-accordion__panel js-fr-accordion__panel">
	    		<div class="u-padding-left-m u-padding-bottom-m">
	    		{foreach $classes as $class}
	    			<fieldset class="Form-field Form-field--choose">
	                    <label class="Form-label"
	                           for="class-{$class.id|wash()}">
	                        <input class="Form-input"
	                               id="class-{$class.id|wash()}"
	                               data-class_id="{$class.identifier|wash()}"
	                               data-icon="{$icons[$class.identifier]}"
	                               value=""
	                               type="checkbox"
	                               checked="checked">
	                        <span class="Form-fieldIcon u-margin-right-xxs" role="presentation"></span> {$class.name|wash()} <span class="count"></span> <i class="fa fa-spinner fa-spin hide"></i>
	                </fieldset>
	    		{/foreach}
	    		</div>
	    	</div>
	    	
	        {foreach $tag_roots as $tag_root}                    
	            {def $tag_tree = api_tagtree($tag_root)}
	            {if is_set($tag_tree.children)}                                                             
				<h2 class="Accordion-header js-fr-accordion__header fr-accordion__header" id="accordion-header-{$tag_tree.id}">
					<span class="Accordion-link">{$tag_tree.keyword|wash()}</span>
				</h2>
				<div id="accordion-panel-{$tag_tree.id}" class="Accordion-panel fr-accordion__panel js-fr-accordion__panel">                
	                <div class="u-padding-left-m u-padding-bottom-m">
	                {foreach $tag_tree.children as $index => $tag}
	                    <fieldset class="Form-field Form-field--choose hide">                                            
	                        <label class="Form-label tag-filter"
	                               for="tag-{$tag.id|wash()}">
	                            <input class="Form-input"
	                                   id="tag-{$tag.id|wash()}"
	                                   data-tag_id="{$tag.id|wash()}"
	                                   value="{$tag.id|wash()}"
	                                   type="checkbox">
	                            <span class="Form-fieldIcon u-margin-right-xxs" role="presentation"></span> {$tag.keyword|wash()} 
	                    </fieldset>
	                        {if $tag.hasChildren}  
	                        <div class="u-margin-left-l" style="font-size:.8em">                                              
	                            {foreach $tag.children as $childTag}
	                                <fieldset class="Form-field Form-field--choose hide">                                            
	                                    <label class="Form-label tag-filter"
	                                           for="tag-{$childTag.id|wash()}">
	                                        <input class="Form-input"
	                                               id="tag-{$childTag.id|wash()}"                                               
	                                               data-tag_id="{$childTag.id|wash()}"
	                                               value="{$childTag.id|wash()}"
	                                               type="checkbox">
	                                        <span class="Form-fieldIcon u-margin-right-xxs" role="presentation"></span> {$childTag.keyword|wash()}
	                                </fieldset>
	                            {/foreach}     
	                        </div>                                           
	                        {/if}                                                                            
	                {/foreach}
	                </div>
	            </div>
	            {/if}
	        {undef $tag_tree}
	        {/foreach}
        </div>
    </div>
</div>


<script>
{literal}
$(document).ready(function() {	
	$('#accordion-header-class').trigger('click');
	var map = new L.Map('{/literal}map-{$block.id}{literal}', {
        loadingControl: true
    }).setView(new L.LatLng(0, 0), 1);    
    map.scrollWheelZoom.disable();
    L.tileLayer('//{s}.tile.openstreetmap.org/{z}/{x}/{y}.png', {
        attribution: '&copy; <a href="http://osm.org/copyright">OpenStreetMap</a> contributors'
    }).addTo(map);

    var geoFind = function (query, cb, context) {
        var data = {q: query};
        $.ajax({
            type: "GET",
            url: $.opendataTools.settings('endpoint').geo,
            data: data,
            contentType: "application/json; charset=utf-8",
            dataType: "json",
            success: function (response,textStatus,jqXHR) {
                if(response.error_message || response.error_code){
                    console.log(response);
                }else {
                    cb.call(context, response);
                }
            },
            error: function (jqXHR) {
                var error = {
                    error_code: jqXHR.status,
                    error_message: jqXHR.statusText
                };
                console.log(jqXHR);
            }
        });
    };

    var geoRecursiveFind = function (query, cb, lastCb, context) {        
        var features = [];
        var getSubRequest = function (query) {
            geoFind(query, function (data) {
                cb.call(context, data);
                parseSubResponse(data);
            })
        };
        var parseSubResponse = function (response) {
            if (response.nextPageQuery) {
                getSubRequest(response.nextPageQuery);
            } else {                
                lastCb.call(context, response.facets, response.totalCount);                
            }
        };
        getSubRequest(query);
    };

    var globalLayer = L.featureGroup();
    var layers = [];
    $('[data-class_id]').each(function(){
		var identifier = $(this).data('class_id');
		$(this).prop('checked', true);
		layers[identifier] = new L.markerClusterGroup();
        layers[identifier].on('click', function (a) {
            $.getJSON("{/literal}{'/openpa/data/map_markers'|ezurl(no)}{literal}?contentType=marker&view=panel&id="+a.layer.feature.id, function(data) {
                var popup = new L.Popup({maxHeight:360});
                popup.setLatLng(a.layer.getLatLng());
                popup.setContent(data.content);
                map.openPopup(popup);
            });
        });
	});	
	$('[data-tag_id]').each(function(){
		$(this).prop('checked', false);
	});	

	var addResponseToLayer = function(response, layer, iconName){
		var geoLayer = L.geoJson(response, {
            pointToLayer: function (feature, latlng) {
                var customIcon = L.MakiMarkers.icon({icon: iconName, size: "m", color: "#4db748"});
                return L.marker(latlng, {icon: customIcon});
            },
            onEachFeature: function (feature, layer) {                        
                var popup = new L.Popup({maxHeight: 360});
                popup.setContent(feature.properties.name + ' <i class="fa fa-circle-o-notch fa-spin"></i>');
                layer.bindPopup(popup);
            }
        });
        layer.addLayer(geoLayer);
	}

    var loadData = function(){
    	$('[data-class_id]').each(function(){
    		var self = $(this);
    		var identifier = self.data('class_id');
    		var iconName = self.data('icon');
    		var count = self.parent().find('span.count');
    		var spinner = self.parent().find('i').addClass('show').removeClass('hide');
    		layers[identifier].clearLayers();
    		globalLayer.removeLayer(layers[identifier]);
    		map.removeLayer(layers[identifier]);

    		var filter = '';
    		var tags = [];
    		$('[data-tag_id]:checked').each(function(){
    			tags.push($(this).data('tag_id'));
    		});
    		if (tags.length > 0){
    			filter = ' and raw[ezf_df_tag_ids] in [' + tags.join(',') + ']';
    		}

    		geoRecursiveFind('classes ['+identifier+']' + filter + ' facets [raw[ezf_df_tag_ids]|1000]', function(response){
    			addResponseToLayer(response, layers[identifier], iconName);
    		}, function(facets, totalCount){    			
    			$.each(facets[0].data, function(id,count){
    				$('[data-tag_id="'+id+'"]').parents('fieldset').removeClass('hide');
    			});
    			spinner.addClass('hide').removeClass('show');
    			count.html(totalCount);
                if (totalCount > 0) {                	
                	if (self.is(':checked')){
                		layers[identifier].addTo(map);
            		}
                	//map.fitBounds(layers[identifier].getBounds());
                	globalLayer.addLayer(layers[identifier]);                	
            	}
            	if (globalLayer.getLayers().length){                	
                	map.fitBounds(globalLayer.getBounds()); 
                }
    		});    		
    	});    	    
    }

    $('[data-class_id]').on('change', function(e){
    	var identifier = $(this).data('class_id');
    	if ($(this).is(':checked')){
    		map.addLayer(layers[identifier]);    		
    	}else{
    		map.removeLayer(layers[identifier]);
    	}
    	map.fitBounds(globalLayer.getBounds());  
    });
    
    $('.tag-filter').on('mouseover', function(){  
    	if ($('i.show').length > 0){
    		$(this).css('cursor', 'not-allowed');
    	}else{
    		$(this).css('cursor', 'default');
    	}
	});
    $('[data-tag_id]').on('click', function(e){    	
    	if ($('i.show').length > 0){
    		e.preventDefault();
    		return false;
    	}
    });
    $('[data-tag_id]').on('change', function(){    	    	
    	loadData();    	
    });
    loadData();
})
{/literal}
</script>



{*
    var municipalities = [
    	{name: 'Freiburg', osm: 'https://www.openstreetmap.org/api/0.6/relation/1683318/full'},
    	{name: 'Maribor', osm: 'https://www.openstreetmap.org/api/0.6/relation/8154489/full'},
    	{name: 'Trento', osm: 'https://www.openstreetmap.org/api/0.6/relation/46663/full'},
    	{name: 'Vienne Condrieu Agglomération', osm: 'https://www.openstreetmap.org/api/0.6/relation/8188263/full'},
    	{name: 'Vorau', osm: 'https://www.openstreetmap.org/api/0.6/relation/3931168/full'}
    ];

    var municipalityLayer = L.featureGroup();
    $.each(municipalities, function(){
    	var municipality = this;
    	$.ajax({
            url: municipality.osm,
            dataType: "xml",
            success: function (xml) {                
                var xmlLayer = new L.OSMData.DataLayer(xml);
                var geoJSON = xmlLayer.toGeoJSON();
                var geoJSONLayer = L.geoJson(geoJSON, {
		            filter: function (feature, layer) {
		                var geometry = feature.type === 'Feature' ? feature.geometry : feature;
		                return (geometry.type !== 'Point');
		            },
		            onEachFeature: function (feature, layer) {					    				    
				        layer.bindPopup('<h3>'+municipality.name+'</h3>');
					}
		        });
		        geoJSONLayer.eachLayer(function (l) {
		            if (l.options) {
		                l.options = $.extend({}, l.options, {color: 'red'});
		            } else if (typeof l.getLayers === 'function') {
		                $.each(l.getLayers(), function () {
		                    this.options = $.extend({}, this.options, {color: 'red'});		                    
		                });
		            }		            
		        });
                municipalityLayer.addLayer(geoJSONLayer);
				if (municipalityLayer.getLayers().length === municipalities.length) {
                	municipalityLayer.addTo(map);
                	map.fitBounds(municipalityLayer.getBounds());  
            	}
            }
        });
    });
classes [private_organization,offer,request,location,event,municipality,ce_manager,user] 
{field: 'raw[attr_municipality_s]', 'limit': 100, 'sort': 'alpha', name: 'Municipality'},
{field: 'raw[meta_class_identifier_ms]', 'limit': 100, 'sort': 'alpha', name: 'What to show'},
{field: 'raw[attr_application_domain_lk]', 'limit': 100, 'sort': 'alpha', name: 'Application Domain'},
{field: 'raw[attr_material_category_lk]', 'limit': 100, 'sort': 'alpha', name: 'Material'},
{field: 'raw[attr_type_of_event_lk]', 'limit': 100, 'sort': 'alpha', name: 'Events'},
{field: 'raw[attr_type_signature_lk]', 'limit': 100, 'sort': 'alpha', name: 'Manifesto Signatures'}
*}
