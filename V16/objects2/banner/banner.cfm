
<cfparam name="attributes.content_chap_id" default="">
<cfparam name="attributes.slide_count" default="">
<cfparam name="attributes.product_id" default="">
<cfparam name="attributes.banner_type" default="">
<cfset METHODS = createObject('component','V16.objects2.cfc.widget.banner')>
<cfset GET_BANNER = METHODS.GET_BANNER(
	banner_id :"#attributes.banner_id#",
	camp_id : 1,
	content_cat_id :"#attributes.content_cat_id#",
	content_chap_id : "#attributes.content_chap_id#",
	product_id : attributes.product_id,
	site :  GET_PAGE.PROTEIN_SITE,
	banner_type : attributes.banner_type,
	slide_sort : iif(isdefined('attributes.slide_sort') and len(attributes.slide_sort),'attributes.slide_sort', 0)
)>
<cfif get_banner.recordCount>
	<cfswitch expression="#attributes.banner_theme#">
		<!--- Full Slider --->
		<cfcase value="1">			
			<div class="banner protein-full-slider-slick">
				<cfoutput query="GET_BANNER">
				<cfset attributes.slide_count = GET_BANNER.recordcount>
				<div class="banner_item">		
					<cfif attributes.no_image_banner neq 2>	
						<cfif len(get_banner.MOBILE_BANNER_FILE)>
							<div class="d-none d-sm-block banner-img" style="background-image:url('/documents/content/banner/#BANNER_FILE#');cursor:pointer" <cfif len(url)>onclick="<cfif banner_target eq 'popup'>windowopen('#url#','medium')<cfelseif banner_target eq '_blank'>window.open('#url#','_blank')<cfelse>javascript:location.href='#url#'</cfif>"</cfif>></div>
								<cfif isDefined("attributes.text_inside_banner") and attributes.text_inside_banner eq 1>
									<div class="banner-text-type2">							
										<h2>#BANNER_NAME#</h2>
										<p>#DETAIL#</p>							
									</div>
								</cfif> 
							<div class="d-sm-none banner-img" style="background-image:url('/documents/content/banner/#MOBILE_BANNER_FILE#');cursor:pointer" <cfif len(url)>onclick="<cfif banner_target eq 'popup'>windowopen('#url#','medium')<cfelseif banner_target eq '_blank'>window.open('#url#','_blank')<cfelse>javascript:location.href='#url#'</cfif>"</cfif>></div>
								<cfif isDefined("attributes.text_inside_banner") and attributes.text_inside_banner eq 1>
									<div class="banner-text-type2">							
										<h2>#BANNER_NAME#</h2>
										<p>#DETAIL#</p>							
									</div>
								</cfif> 	
						<cfelse>
							<div class="banner-img" style="background-image:url('/documents/content/banner/#BANNER_FILE#');cursor:pointer" <cfif len(url)>onclick="<cfif banner_target eq 'popup'>windowopen('#url#','medium')<cfelseif banner_target eq '_blank'>window.open('#url#','_blank')<cfelse>javascript:location.href='#url#'</cfif>"</cfif>></div>
								<cfif isDefined("attributes.text_inside_banner") and attributes.text_inside_banner eq 1>
									<div class="banner-text-type2">							
										<h2>#BANNER_NAME#</h2>
										<p>#DETAIL#</p>							
									</div>
								</cfif> 
						</cfif>							
					<cfelse>
						<div class="banner-text">
							<p>#BANNER_NAME#</p>
							<span>#DETAIL#</span>						
							<a href="#USER_FRIENDLY_URL#">								
								<br><span class="text-uppercase"><cf_get_lang dictionary_id='62026.DEVAMINI OKU'></span>
							</a>						
						</div>
					</cfif>	
				</div>
				</cfoutput>	
			</div>
		</cfcase>
		<!--- Box Slider --->
		<cfcase value="2">	
			<cfset GET_LAST_3_SPOT = METHODS.GET_LAST_3_SPOT(
				banner_id :"#attributes.banner_id#",
				content_cat_id :"#attributes.content_cat_id#",
				content_chap_id : "#attributes.content_chap_id#",
				product_id : attributes.product_id,
				site :  GET_PAGE.PROTEIN_SITE,
				banner_type : attributes.banner_type
			)>			
			<div class="banner banner-type2">
				<cfoutput query="GET_LAST_3_SPOT">
				<cfset attributes.slide_count = GET_BANNER.recordcount>	
				<div class="banner_item">						
					<cfif attributes.no_image_banner neq 2>	
						<div class="banner-img" style="background-image:url('/documents/content/banner/#BANNER_FILE#')"></div>
						<div class="banner-text">
							<cfif isdefined('attributes.category_header') and attributes.category_header eq 1>
								<p>#cont_head#</p>
							<cfelse>						
								<p>#BANNER_NAME#</p>	
							</cfif>
							<span>#CONT_SUMMARY#</span>	
							<cfif isDefined("attributes.is_banner_button") and attributes.is_banner_button eq 1>				
								<a href="#USER_FRIENDLY_URL#" class="text-uppercase"><cf_get_lang dictionary_id='62026.DEVAMINI OKU'></a>	
							</cfif>											
						</div>			
					<cfelse>
						<div class="banner-text banner-text-type2">
							<p>#BANNER_NAME#</p>
							<span>#DETAIL#</span>
							<cfif len(url)>
								<a href="#url#">									
									<span>#attributes.banner_button_text#</span>
								</a>
							<cfelseif len(CONTENT_ID)>
								<a href="#USER_FRIENDLY_URL#">								
									#cont_head#
								</a>
							</cfif>
						</div>																								
					</cfif>						
				</div>
				</cfoutput>	
			</div>
			<cfif attributes.slide_count gt 1>
				<script>
					$(function(){
						$('.banner').slick({
							dots: true,
							slidesToShow: 1,
							arrows:false,
							fade: true,
							cssEase: 'linear',
							accessibility: true,
							autoplay: true,
  							autoplaySpeed: 2000,
						});
					});
				</script>
			</cfif>
		</cfcase>
		<!--- İçerik Slider --->
		<cfcase value="3">
			<cfoutput query="GET_BANNER">
				<cfset attributes.slide_count = GET_BANNER.recordcount>
				#content#
			</cfoutput>
		</cfcase>	
		<!--- Ürün Slider --->
		<cfcase value="4">			
			<div class="banner">
				<cfoutput query="GET_BANNER">	
					<cfset attributes.slide_count = GET_BANNER.recordcount>
					<div class="banner_item">						
						<cfif attributes.no_image_banner neq 2>
							<cfif isdefined('attributes.text_inside_banner') and attributes.text_inside_banner eq 1>	
								<div class="banner-img" style="background-image:url('/documents/content/banner/#BANNER_FILE#')"></div>
								<div class="banner-text">							
									<span>#PRODUCT_CODE_2#</span>
									<h2>#PRODUCT_NAME#</h2>
									<p>#PRODUCT_DETAIL#</p>							
								</div>
							<cfelse>	
								<div class="banner-img" style="background-image:url('/documents/content/banner/#BANNER_FILE#')"></div>										
							</cfif>																						
						</cfif>						
					</div>			
				</cfoutput>	
			</div>
			<cfoutput query="GET_BANNER">
				<div class="description description-type2">
					<p>#PRODUCT_DETAIL2#</p>
				</div>
			</cfoutput>	
		</cfcase>
		<!--- Card Slider --->
		<cfcase value="5">
			<cfoutput>
				<cfif isDefined("attributes.banner_block_title") and len(attributes.banner_block_title)>
					<div class="list_chapter_head">
						#attributes.banner_block_title#
					</div>
				</cfif>	
			</cfoutput>
			<div class="list_chapter">										
				<cfoutput query="GET_BANNER">
					<div class="col-md-12 col-12">
						<div class="list_chapter_item">
							<div style="background-image: url('/documents/content/banner/#BANNER_FILE#');" class="list_chapter_item_img"></div>
							<div style="background-color:##e7f5ec" class="list_chapter_item_text">
								<div class="list_chapter_item_title">
									#BANNER_NAME#
								</div>							
								<div class="list_chapter_item_btn">
									<a href="#URL#"><cf_get_lang dictionary_id='62207.HEMEN OKU '></a>
								</div>
							</div>						
						</div>
					</div>
				</cfoutput>
			</div>
			<script>
				$(function(){
					$('.list_chapter').slick({
						slidesToShow: 4,
						slidesToScroll: 1,
						dots:false,
						speed: 700,
						responsive: 
						[
							{
							breakpoint: 821, //820px breakpoint for iPad Air tablet
							settings: {
								slidesToShow: 2
							}
							},
							{
							breakpoint: 480,
							settings: {
								slidesToShow: 1,
							}
							}
						]
					});
				})
			</script>
		</cfcase>	
	</cfswitch>
</cfif>

<cfif attributes.slide_count gt 1>
	<script>
        $(function(){
            $('.banner').slick({
                dots: true,
                slidesToShow: 1,
                arrows:false,
                fade: true,
                cssEase: 'linear',
				autoplay: true,
  				autoplaySpeed: 8000,
            });
        });
    </script>
</cfif>