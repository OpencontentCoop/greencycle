<div class="openpa-widget nav-section">
  <h2 class="openpa-widget-title"><i class="fa fa-share-alt" aria-hidden="true"></i> Share</h2>
  <div class="openpa-widget-content">
    <div class="Grid">
	    <a style="text-decoration:none !important" class="Grid-cell u-size1of4" href="https://facebook.com/sharer/sharer.php?u={$node.url_alias|ezurl(no,full)|urlencode}" target="_blank" rel="noopener" aria-label="Share on Facebook">
	        <span class="u-text-r-l Icon Icon-facebook"></span>
	    </a>
	    <a style="text-decoration:none !important" class="Grid-cell u-size1of4" href="https://twitter.com/intent/tweet/?text={concat($node.name, ' ', $node.url_alias|ezurl(no,full))|urlencode}" target="_blank" rel="noopener" aria-label="Share on Twitter">
	        <span class="u-text-r-l Icon Icon-twitter"></span>
	    </a>
	    <a style="text-decoration:none !important" class="Grid-cell u-size1of4" href="http://www.linkedin.com/shareArticle?mini=true&amp;url={$node.url_alias|ezurl(no,full)|urlencode}&title={$node.name|wash()}&ro=false&source={ezini('SiteSettings','SiteURL')}">
	        <span class="u-text-r-l Icon Icon-linkedin"></span>
	    </a>
	    <a style="text-decoration:none !important" class="Grid-cell u-size1of4" href="whatsapp://send?text=={$node.url_alias|ezurl(no,full)|urlencode}" target="_blank" rel="noopener" aria-label="Share on Whatsapp">
	        <span class="u-text-r-l Icon Icon-whatsapp"></span>
	    </a>
    </div>
  </div>
</div>


