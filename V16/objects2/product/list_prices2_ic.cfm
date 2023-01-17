<cfoutput>
	<cfquery name="GET_MONEY_INFO" datasource="#DSN2#">
		SELECT
			(RATE2/RATE1) RATE
		FROM 
			SETUP_MONEY
		WHERE
			MONEY = <cfqueryparam cfsqltype="cf_sql_varchar" value="#money#">
	</cfquery>
	<cfif len(user_friendly_url)>
		<cfset product_link_ = "#site_language_path#/ProductDetail/#product_id#/#stock_id#">
	<cfelse>
		<cfset product_link_ = "#site_language_path#/ProductDetail/#product_id#/#stock_id#">
	</cfif>
	<cfif attributes.is_popup>
		<cfset fuseact_ = 'href="javascript://" onclick=windowopen("#request.self#?fuseaction=objects2.popup_detail_product#product_link_#","list");'>
	<cfelse>
		<cfset fuseact_ = 'href="#request.self#?fuseaction=objects2.detail_product#product_link_#"'>
	</cfif>

	<cfif (attributes.is_stock_count eq 1) or (attributes.is_basket eq 1) or (attributes.is_basket eq 2 and isdefined('session_base.userid'))>
		<!--- stok durum blogu --->
		<cfset usable_stock_amount = saleable_stock>
		<!--- stok durum blogu --->
	</cfif>
	<cfset product_all_list = listappend(product_all_list,product_id)>
	<cfif isDefined("attributes.view_mode") and attributes.view_mode eq 'product_table'>
		<tr>
			<td>#currentRow#</td>
			<td>#STOCK_CODE#</td>
			<td>
				<div class="product_item_name" style="font-family:'PoppinsR'!important;font-size:14px!important;">
					<a href="#site_language_path#/ProductDetail/#product_id#/#stock_id#">
						<label style="margin:auto;font-weight:bold;">
							<cfif attributes.is_brand eq 1 and len(brand_list) and len(brand_id)>
								#get_brands.brand_name[listfind(main_brand_list,brand_id,',')]#, 
							</cfif>
							#product_name#
						</label>
						<br><label style="font-size:12px;"><cfif len(property)>#property#,</cfif> #product_detail# <cfif attributes.is_detail eq 1> #product_detail2#</cfif></label>
					</a>
				</div>
			</td>
			<td></td>
			<td>#BARCOD#</td>
			<td>#ADD_UNIT#</td>
			<td class="text-right" width="100">
				<cfif attributes.is_price_kdvsiz eq 1 and attributes.is_price_view eq 1>														
					#TLFormat(price*get_money_info.rate)#
					#session_base.money#<cfif isdefined("attributes.is_kdv_alert") and attributes.is_kdv_alert eq 1> + <cf_get_lang_main no='227.KDV'></cfif>			
				</cfif>
				<cfif attributes.is_price_view eq 1>
					<cfif attributes.is_price><!--- fiyat istenmemis ise buraya girmesi gerekmez --->
						<cfif isdefined("attributes.is_price_sk") and attributes.is_price_sk eq 1>
							#TLFormat(PRICE_KDV * get_money_info.rate)#
							#session_base.money#
						</cfif>
					</cfif>
				</cfif>
			</td>
			<td>
				<div class="product_item_basket">
					<div class="product_item_basket_top">
						<span><i class="fa fa-minus"  onClick="document.getElementById('quantity_#currentrow#').value != 1 ? document.getElementById('quantity_#currentrow#').value-- : 1;"></i></span>
						<input type="text" id="quantity_#currentrow#"  min="1" max="999" value="1" readonly style="width:35px;"/> 
						<span><i class="fa fa-plus"  onClick="document.getElementById('quantity_#currentrow#').value++;"></i></span>
					</div>
				</div>
			</td>
			<td>
				<div class="product_item_basket">
					<div class="product_item_basket_bottom">
						<a href="javascript://" onclick="add_product(#stock_id#,document.getElementById('quantity_#currentrow#').value,#widget.id#);"><i class="fa fa-shopping-basket"></i></a>
					</div>
				</div>
			</td>
		</tr>
	<cfelse>
		<div class="#attributes.view_mode_col?:'col-md-4 col-sm-4 col-12'#" data-bar = "product_bar_col">
			<div class="product_item">
				<cfif attributes.is_image eq 1>
					<div class="product_item_img">
						<cfif get_product_images.recordcount and len(get_product_images.path)>
							<img src="/documents/product/#get_product_images.path#"/>
						</cfif>
					</div>
				</cfif>
				<div class="product_item_text">
					<cfif attributes.is_brand eq 1>
						<div class="product_item_brand">
							<cfif len(brand_list) and len(brand_id)>
								#get_brands.brand_name[listfind(main_brand_list,brand_id,',')]#
							</cfif>
						</div>
					</cfif>
					<div class="product_item_name">
						<a href="#site_language_path#/ProductDetail/#product_id#/#stock_id#">
							#product_name# <cfif len(property)>#property#</cfif>
						</a>
					</div>
					<div class="product_item_desc">
						<a href="#site_language_path#/ProductDetail/#product_id#/#stock_id#">
							#product_detail#
							<cfif attributes.is_detail eq 1><br>#product_detail2#</cfif>
						</a>
					</div>
					<div class="product_item_price">
						<cfif attributes.is_price_kdvsiz eq 1 and attributes.is_price_view eq 1>
							#TLFormat(price* iif(attributes.is_product_money neq 1,'get_money_info.rate',1))# <cfif attributes.is_product_money eq 1>#money#<cfelse>#session_base.money#</cfif>
							/#add_unit#<br><cfif attributes.is_price_tax_rate eq 1>%#tax# + <cf_get_lang_main no='227.KDV'></cfif>
						</cfif>
						<cfif attributes.is_price_view eq 1>
							<cfif attributes.is_price><!--- fiyat istenmemis ise buraya girmesi gerekmez --->
								<cfif isdefined("attributes.is_price_sk") and attributes.is_price_sk eq 1>
									#TLFormat(PRICE_KDV*iif(attributes.is_product_money neq 1,'get_money_info.rate',1))#
									<cfif attributes.is_product_money eq 1>#money#<cfelse>#session_base.money#</cfif>
									<br><cf_get_lang dictionary_id='34463.Including VAT'>
								</cfif>
							</cfif>
						</cfif>
					</div>
					<div class="product_item_basket">
						<cfif (attributes.is_basket eq 1) or (attributes.is_basket eq 2 and isdefined('session_base.userid'))>
							<cfif not isdefined('attributes.is_basket_standart') or attributes.is_basket_standart eq 1>
								<cfif (is_zero_stock eq 1 or (is_zero_stock neq 1 and usable_stock_amount gt 0) or is_production eq 1) or (isdefined("attributes.is_stock_kontrol") and attributes.is_stock_kontrol eq 0)<!---  and musteri_flt_other_money_value gt 0 --->>
									<div class="product_item_basket_top">
										<span><i class="fa fa-minus"  onClick="document.getElementById('quantity_#currentrow#').value != 1 ? document.getElementById('quantity_#currentrow#').value-- : 1;"></i></span>
										<input type="text" id="quantity_#currentrow#"  min="1" max="999" value="1" readonly/> 
										<span><i class="fa fa-plus"  onClick="document.getElementById('quantity_#currentrow#').value++;"></i></span>
										<div class="product_item_basket_bottom">
											<a href="javascript://" onclick="add_product(#stock_id#,document.getElementById('quantity_#currentrow#').value,#widget.id#);"><cf_get_lang dictionary_id='52116.Sepete Ekle'><i class="fa fa-shopping-cart"></i></a>
										</div>
									</div>
								<cfelse>
									<div class="product_item_basket_top">
										<div class="product_item_basket_bottom">
											<div class="product_item_basket_bottom_message">
												<cf_get_lang dictionary_id='34730.STOKTA YOK'>
											</div>
										</div>
									</div>
								</cfif>
							</cfif>
						</cfif>
					</div>
				</div>
			</div>
		</div>
	</cfif>
</cfoutput>