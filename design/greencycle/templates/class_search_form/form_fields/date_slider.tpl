<div class="form-group">
  <label for="{$id}">{$label}</label>
  <div id="{$id}" style="padding: 10px 20px">
    <div id="{$id}-slider"></div>
    <p style="margin-top: 10px;">
      <small class="event-start"><strong>From </strong><span></span></small><br />
      <small class="event-end"><strong>to </strong><span></span></small>
    </p>
  </div>
  <input id="data-{$id}" type="hidden" name="{$input_name|wash()}" value="{$value|wash()}" />
  {ezscript_require( array( 'ezjsc::jquery', 'ezjsc::jqueryUI', 'plugins/noUiSlider/jquery.nouislider.all.js', 'moment.min.js' ) )}
  {ezcss_require(array('plugins/noUiSlider/jquery.nouislider.min.css'))}
  <script type="text/javascript">
  $(function() {ldelim}
    {literal}    
    function formatDate ( date ) {return moment(date).format('dddd, MMMM Do YYYY');}
    function setDate( value ){ $(this).html(formatDate(new Date(+value))); }
    {/literal}
    $( "#{$id}-slider" ).noUiSlider({ldelim}
      range: {ldelim}
        min: {$bounds.start_js},
        max: {$bounds.end_js}
      {rdelim},
      step: 7 * 24 * 60 * 60 * 1000,
      start: [ {$current_bounds.start_js}, {$current_bounds.end_js} ],
      format: wNumb({ldelim}
        decimals: 0
      {rdelim})
    {rdelim});
    
    $("#{$id}-slider").Link('lower').to($("#{$id} .event-start span"), setDate);
    $("#{$id}-slider").Link('upper').to($("#{$id} .event-end span"), setDate);
    $("#{$id}-slider").on({ldelim}
      change: function(){ldelim}
        var range = $(this).val();
        $("#data-{$id}").val( Math.floor(range[0]/1000) + '-' + Math.floor(range[1]/1000) );
      {rdelim}
    {rdelim});
    
  {rdelim});
  </script>
</div>
