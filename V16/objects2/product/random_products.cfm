<cfif isdefined("attributes.random_visited_max_count") and len(attributes.random_visited_max_count)>
	<cfset max_ = attributes.random_visited_max_count>
<cfelse>
	<cfset max_ = 10>
</cfif>
<cfset product_action = createObject("component", "cfc.data")>
<cfparam name="attributes.price_catid" default="-2">
<cfif isdefined('attributes.show_product_price') and attributes.show_product_price neq 0><!--- fiyat istenmemis ise buraya girmesi gerekmez --->
	<cfinclude template="../query/get_price_cats_moneys.cfm">
</cfif>

<cfif isdefined("cookie.last_visited_5_products") and listlen(cookie.last_visited_5_products)>
	<cfset get_last_visited_5_products = product_action.GET_LAST_VISITED_5_PRODUCTS(
		is_random_cat_brand : '#IIf(IsDefined("attributes.is_random_cat_brand"),"attributes.is_random_cat_brand",DE(''))#'
	)>

	<cfif get_last_visited_5_products.recordcount>
		<cfset GET_RANDOM_PRODUCTS = product_action.GET_RANDOM_PRODUCTS(
			is_random_cat_brand : '#IIf(IsDefined("attributes.is_random_cat_brand"),"attributes.is_random_cat_brand",DE(''))#',
			random_cat : '#IIf(IsDefined("attributes.random_cat"),"attributes.random_cat",DE(''))#',
			max : #max_#,
			visited_list : '#valuelist(get_last_visited_5_products.TYPE)#'
		)>
	<cfelse>
		<cfset get_random_products.recordcount = 0>
	</cfif>
	<cfif get_last_visited_5_products.recordcount and get_random_products.recordcount>
	<cfset product_id_list = ''>
	<cfoutput query="get_random_products">
		<cfif not listfindnocase(product_id_list,get_random_products.product_id)>
			<cfset product_id_list = listappend(product_id_list,get_random_products.product_id,',')>
		</cfif>
	</cfoutput>
	<cfif listlen(product_id_list)>
		<cfquery name="GET_PRODUCT_IMAGES" datasource="#DSN3#">
			SELECT PATH,PRODUCT_ID,PATH_SERVER_ID,DETAIL FROM PRODUCT_IMAGES WHERE IMAGE_SIZE = 0 AND PRODUCT_ID IN (#product_id_list#) ORDER BY PRODUCT_ID
		</cfquery>
		<cfset product_id_list = listdeleteduplicates(valuelist(get_product_images.PRODUCT_ID,','),'numeric','ASC',',')>
		<cfset product_id_list=listsort(product_id_list,"numeric","ASC",",")>
	</cfif>

	<section>    
		<div class="container"> 
			<div class="row">
				<div class="col-md-12 col-12 product_list_title">
					Tavsiye Edilen Ürünler
				</div>
			</div>          
			<div class="d-flex flex-wrap product_list">       
				<cfoutput query="get_random_products">       
					<cfif isdefined('attributes.show_product_price') and attributes.show_product_price eq 1><!--- fiyat istenmemis ise buraya girmesi gerekmez --->
						<cfif isDefined("money")>
							<cfset attributes.money = money>
						</cfif>
						<cfloop query="moneys">
							<cfif moneys.money is attributes.money>
								<cfset row_money = money >
								<cfset row_money_rate1 = moneys.rate1>
								<cfset row_money_rate2 = moneys.rate2>
							</cfif>
						</cfloop>
						<cfset pro_price = price>
						<cfset pro_price_kdv = price_kdv>
						<cfif attributes.price_catid neq -2>
							<cfquery name="GET_P" dbtype="query">
								SELECT * FROM GET_PRICE_ALL WHERE UNIT = <cfqueryparam cfsqltype="cf_sql_integer" value="#product_unit_id[currentrow]#"> AND PRODUCT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#product_id#">
							</cfquery>
							<cfscript>
								catalog_id_ = get_p.catalog_id;
								if(get_p.recordcount and len(get_p.price)){
									musteri_pro_price = get_p.price; 
									musteri_pro_price_kdv = get_p.price_kdv; 
									musteri_row_money=get_p.money;
								}
								else{
									musteri_pro_price = pro_price;
									musteri_pro_price_kdv = pro_price_kdv;
									musteri_row_money=attributes.money;
								} //musteriye ozel fiyat yoksa son kullanici gecerli
							</cfscript>
							<cfloop query="moneys">
								<cfif moneys.money is musteri_row_money>
									<cfset musteri_row_money_rate1 = moneys.rate1>
									<cfset musteri_row_money_rate2 = moneys.rate2>
								</cfif>
							</cfloop>				
							<cfscript>
								if(musteri_row_money is default_money.money){
									musteri_str_other_money = musteri_row_money; 
									musteri_flt_other_money_value = musteri_pro_price;
									musteri_flt_other_money_value_kdv = musteri_pro_price_kdv;	
									musteri_flag_prc_other = 0;
								}
								else{
									musteri_flag_prc_other = 1 ;{
										musteri_str_other_money = musteri_row_money; 
										musteri_flt_other_money_value = musteri_pro_price;
										musteri_flt_other_money_value_kdv = musteri_pro_price_kdv;
									}
									musteri_pro_price = musteri_pro_price*(musteri_row_money_rate2/musteri_row_money_rate1);
								}
							</cfscript>
						<cfelse>
							<cfscript>
								catalog_id_ = '';
								musteri_flt_other_money_value = pro_price;
								musteri_flt_other_money_value_kdv = pro_price_kdv;	
								musteri_str_other_money = row_money;
								musteri_row_money = row_money;
								{
									musteri_flag_prc_other = 1;
									musteri_pro_price = pro_price*(row_money_rate2/row_money_rate1);
									musteri_str_other_money = default_money.money;
								}
							</cfscript>
						</cfif>
					</cfif>
					<div class="col-md-12 col-12">                                               
						<div class="product_card_item">
							<cfif attributes.random_visited_images>
								<div class="product_card_item_img">
									<cfif listfindnocase(product_id_list,product_id) and len(get_product_images.path)>
										<a href="/ProductDetail/#product_id#/#stock_id#">
											<img src="documents/product/#get_product_images.path[listfind(product_id_list,product_id)]#" height="150px" width="150px">
										</a>
									<cfelse>
										<image href="/images/no-image.png" height="150px" width="150px" />
									</cfif>
								</div>
							</cfif>
							<div class="product_card_item_title">
								<a href="/ProductDetail/#product_id#/#stock_id#" title="#product_name# #property#">#product_name# #property#</a>
							</div>
							<div class="product_card_item_content"> 
								#product_detail#
							</div>
							<cfif attributes.show_product_price>
								<div class="product_card_item_new_price">      
									<div class="product_card_item_new_price">      
										<cfif isdefined('session_base.userid') and isdefined("musteri_flt_other_money_value_kdv") and len(musteri_flt_other_money_value_kdv)>
											<span>#TLFormat(musteri_flt_other_money_value_kdv)#</span> #musteri_row_money#</td>
										<cfelse>
											<span>#TLFormat(price_kdv)#</span> <cfif isdefined("session.ww")>#session.ww.money#<cfelseif isdefined("session.pp")>#session.pp.money#<cfelse>#session.ep.money#</cfif></td>
										</cfif>
									</div>    
								</div>
							</cfif>
							<cfif attributes.product_add_basket eq 1>
								<div class="col pl-1 d-flex justify-content-center">
									<div class="product-button">
										<button class="btn btn-circle-sm mt-2 ml-1 mr-2"><i class="fa fa-minus"></i></button>
										<label class="pb-0 basket-amount">1</label>
										<button class="btn btn-circle-sm mt-2 ml-2"><i class="fa fa-plus"></i></button>                
										<button type="button" class="btn btn-sm btn-basket float-right pr-1 pl-0 pb-2" onclick="add_product(#stock_id#,1,#widget.id#);"><cf_get_lang dictionary_id='52116.?'><i class="fas fa-shopping-cart"></i></button> 
									</div>    
								</div>
							</cfif>
						</div>     
					</div>  
				</cfoutput>
			</div>
		</div>
	</section>
	<script>
		$(function(){
			$('.product_list').slick({
				slidesToShow: 3,
				slidesToScroll: 1,
				dots:false,
				speed: 700,
				responsive: 
				[
					{
					breakpoint: 1315,
					settings: {
						slidesToShow: 3
					}
					},
					{
					breakpoint: 1020,
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
	</cfif>	
</cfif>
