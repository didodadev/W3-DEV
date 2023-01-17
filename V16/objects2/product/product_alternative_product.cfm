<cfset product_other = createObject("component", "cfc.productOther")>
<cfset GET_ALTERNATE_PRODUCT = product_other.GET_ALTERNATE_PRODUCT(
	pid : attributes.pid,
	maxrows: len(attributes.product_alternative_maxrows) ? attributes.product_alternative_maxrows : 4
) />

<cfif get_alternate_product.recordcount>
	<cfset product_id_list = ''>
	<cfset all_product_id_list = ''>


	<cfoutput query="get_alternate_product">
		<cfif not listfindnocase(product_id_list,get_alternate_product.product_id)>
			<cfset product_id_list = listappend(product_id_list,GET_ALTERNATE_PRODUCT.product_id,',')>
		</cfif>
		<cfif not listfindnocase(all_product_id_list,get_alternate_product.product_id)>
			<cfset all_product_id_list = listappend(all_product_id_list,get_alternate_product.product_id,',')>
		</cfif>
	</cfoutput>

	<cfif listlen(product_id_list)>
		<cfquery name="GET_PRODUCT_IMAGES" datasource="#DSN3#">
			SELECT PATH,PRODUCT_ID,PATH_SERVER_ID,DETAIL FROM PRODUCT_IMAGES WHERE IMAGE_SIZE = 0 AND PRODUCT_ID IN (#product_id_list#) ORDER BY PRODUCT_ID
		</cfquery>
		<cfset product_id_list = listdeleteduplicates(valuelist(get_product_images.product_id,','),'numeric','ASC',',')>
		<cfset product_id_list = listsort(product_id_list,"numeric","ASC",",")>
	</cfif>
	<cfif isdefined("attributes.is_random_sorting") and attributes.is_random_sorting eq 1>
		<cfloop query="get_alternate_product">
		   <cfset querySetCell(get_alternate_product,"sorter",rand(),currentRow)>
		</cfloop>
		<cfquery name="GET_ALTERNATE_PRODUCT" dbtype="query">
			SELECT * FROM GET_ALTERNATE_PRODUCT ORDER BY SORTER
		</cfquery>
	</cfif>
	<div id="product_alternative_new" class="product_slider" style="display:flex;height:auto;margin-top:-30px;">
		<cfoutput query="get_alternate_product">
			<div class="pr-md-2">
				<div class="product_slider_item" style="padding:0px;">
					<cfif attributes.product_alternative_image eq 1>
						<div class="product_slider_item_img">
							<cfif len(IMAGE_PATH)><img src="/documents/product/#IMAGE_PATH#" style="object-fit: contain;object-position: center;"/></cfif>
						</div>
					</cfif>
					<div class="product_slider_item_text" style="padding:0px 4px;">
						<cfif attributes.product_alternative_name eq 1>
							<div class="product_item_name">
								<a href="#site_language_path#/ProductDetail/#product_id#/#stock_id#">
									#attributes.product_alternative_detail2 eq 0 ? PRODUCT_NAME : PRODUCT_DETAIL2#
								</a>
							</div>
						</cfif>
						<cfif attributes.product_alternative_detail eq 1>
							<div class="product_item_desc" style="-webkit-line-clamp:2!important;">
								<a href="#site_language_path#/ProductDetail/#product_id#/#stock_id#">
									#product_detail#
								</a>
							</div>
						</cfif>
						<cfif attributes.product_alternative_price eq 1>
							<div class="product_item_price">
								<cfif attributes.is_price_kdvsiz eq 1>
									#TLFormat(price)# #money# + <cf_get_lang_main no='227.KDV'>
								<cfelse>
									#tlformat(PRICE_KDV)# #money# / <cf_get_lang dictionary_id='34463.Including VAT'>
								</cfif>
							</div>
							<div class="amount_detail font-weight-bold"><cfif isdefined("attributes.add_unit")>#add_unit#</cfif></div>
						</cfif>
					</div>
					<cfif attributes.product_alternative_price eq 1>
						<cfif attributes.product_alternative_sepet neq 0>
							<div class="product_item_basket">
								<div class="product_item_basket_top">
									<span><i class="fa fa-minus"  onClick="document.getElementById('quantity_#currentrow#').value != 1 ? document.getElementById('quantity_#currentrow#').value-- : 1;"></i></span>
									<input type="text" id="quantity_#currentrow#"  min="1" max="999" value="1" readonly/> 
									<span><i class="fa fa-plus"  onClick="document.getElementById('quantity_#currentrow#').value++;"></i></span>
									<div class="product_item_basket_bottom">
										<a href="javascript://" onclick="add_product(#stock_id#,document.getElementById('quantity_#currentrow#').value,#widget.id#);">
											<cfif attributes.product_alternative_sepet eq 1><cf_get_lang dictionary_id='52116.Sepete Ekle'></cfif>
											<i class="fa fa-shopping-cart" title="<cf_get_lang dictionary_id='52116.Sepete Ekle'>"></i>
										</a>
									</div>
								</div>
							</div>
						</cfif>
					</cfif>
				</div>
			</div>
		</cfoutput>
	</div>
    <script>
        $(function(){
            $('#product_alternative_new').slick({
				infinite: false,
                slidesToShow: <cfif isDefined('attributes.max_show_product_count') and isNumeric(attributes.max_show_product_count)><cfoutput>#attributes.max_show_product_count#</cfoutput><cfelse>2</cfif>,
                slidesToScroll: 1,
                dots:false,
                speed: 700,
				<cfif attributes.product_alternative_position eq 1>
					vertical: true,
					arrows:false,
				</cfif>
				
                responsive: 
                [
                    {
                    breakpoint: 768,
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
<cfelse>
	<cfset widget_live = "die">
</cfif>