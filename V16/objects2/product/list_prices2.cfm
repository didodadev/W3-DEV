<cfif isdefined("session.ww")>
	<cfset session.ww.list_type = 3>
<cfelseif isdefined("session.pp")>
	<cfset session.pp.list_type = 3>
</cfif>

<cfif get_homepage_products.recordcount>
	<cfif attributes.is_brand eq 1 and listlen(brand_list)>
		<cfset brand_list=listsort(brand_list,"numeric","ASC",",")>
		<cfif listlen(brand_list)>
			<cfquery name="GET_BRANDS" datasource="#DSN3#">
				SELECT BRAND_NAME,BRAND_ID FROM PRODUCT_BRANDS WHERE BRAND_ID IN (#brand_list#) ORDER BY BRAND_ID ASC
			</cfquery>
		</cfif>
		<cfset main_brand_list = listsort(listdeleteduplicates(valuelist(get_brands.brand_id,',')),'numeric','ASC',',')>
	</cfif>
	<cfoutput query="get_homepage_products" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
		<cfif attributes.is_price><!--- fiyat istenmemis ise buraya girmesi gerekmez --->
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
			<cfif (not isdefined('attributes.is_basket_standart') or attributes.is_basket_standart eq 1) and attributes.price_catid neq -2>
				<cfquery name="GET_P" dbtype="query">
					SELECT * FROM GET_PRICE_ALL WHERE UNIT = <cfqueryparam cfsqltype="cf_sql_integer" value="#product_unit_id[currentrow]#"> AND PRODUCT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#product_id#">
				</cfquery>
				<cfscript>
					catalog_id_ = get_p.catalog_id;
					if(get_p.recordcount and len(get_p.price)){
							musteri_pro_price = get_p.price; 
							musteri_pro_price_kdv = get_p.price_kdv; 
							musteri_row_money=get_p.money;
					}else{
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
					}else{
						musteri_flag_prc_other = 1 ;
						{
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
		</cfif><!--- fiyat istenmemis ise buraya girmesi gerekmez --->
		<cfscript>
			prom_id = '';
			prom_discount = '';
			prom_amount_discount = '';
			prom_cost = '';
			prom_free_stock_id = '';
			prom_stock_amount = 1;
			prom_free_stock_amount = 1;
			prom_free_stock_price = 0;
			prom_free_stock_money = '';
		</cfscript>
		<cfquery name="GET_PRO" dbtype="query"><!--- maxrows="1" --->
			SELECT * FROM GET_PROM_ALL WHERE STOCK_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#stock_id#"> 				
				<cfif (not isdefined('attributes.is_basket_standart') or attributes.is_basket_standart eq 1) and attributes.price_catid neq -2>
					<cfif len(get_p.price_catid)>
						AND PRICE_CATID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_p.price_catid#">
					</cfif>
				<cfelseif isdefined('attributes.is_basket_standart') and attributes.is_basket_standart eq 0>
						AND PRICE_CATID = <cfqueryparam cfsqltype="cf_sql_integer" value="#price_catid#">
				<cfelse>
					AND PRICE_CATID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.price_catid#">
				</cfif>
			ORDER BY
				PROM_ID DESC
		</cfquery>
		<cfset bir_2_bir=0><!--- promosyonlardan herhangi biri bir alana bir bedava ise ürün gelmiyor promosyonlu hali geliyor sadece--->
		<cfloop from="1" to="#get_pro.recordcount#" index="z">
			<cfif get_pro.limit_value[z] eq 1>
				<cfset bir_2_bir=1>
			</cfif>
		</cfloop>
		<cfif (attributes.is_stock_count eq 1) or (attributes.is_basket eq 1) or (attributes.is_basket eq 2 and isdefined('session_base.userid'))>
			<cfset saleable_stock = get_last_stocks.saleable_stock[listfindnocase(stock_count_stock_list,stock_id)]>
			<cfset product_stock = get_last_stocks.product_stock[listfindnocase(stock_count_stock_list,stock_id)]>
			<cfset purchase_order_stock = get_last_stocks.purchase_order_stock[listfindnocase(stock_count_stock_list,stock_id)]>
		</cfif>
		<cfif attributes.is_image eq 1>
			<cfquery name="get_product_images" datasource="#DSN3#">
				SELECT 
					PATH,
					PRODUCT_ID,
					PATH_SERVER_ID,
					DETAIL 
				FROM 
					PRODUCT_IMAGES 
				WHERE 
					PRODUCT_ID IN (#product_id#) 
				ORDER BY 
					PRODUCT_IMAGEID DESC
			</cfquery>
		</cfif>
		<cfif bir_2_bir neq 1>

			<cfinclude template="list_prices2_ic.cfm">

		</cfif>
		<cfif attributes.is_promotion is 0 or get_pro.recordcount><!--- attributes.is_promotion 1 ise sadece promosyonlular gelir --->
			<cfif get_pro.recordcount>
				<cfloop from="1" to="#get_pro.recordcount#" index="i">
					<cfset product_all_list = listappend(product_all_list,product_id)>
					<cfscript>
						catalog_id_ = get_pro.catalog_id;
						prom_id = get_pro.prom_id[i];
						prom_discount = get_pro.discount[i];
						prom_amount_discount = get_pro.amount_discount[i];
						if(len(get_pro.amount_discount_money_1[i]))
							prom_amount_discount_money = trim(get_pro.amount_discount_money_1[i]);
						else
							prom_amount_discount_money = row_money;
						prom_cost = get_pro.total_promotion_cost[i];
						prom_free_stock_id =  get_pro.free_stock_id[i];
						prom_stok_id = get_pro.stock_id[i]; //Promosyonu olan urunun stok_id si
						if(len(get_pro.limit_value[i])) prom_stock_amount = get_pro.limit_value[i];
						if(len(get_pro.free_stock_amount[i])) prom_free_stock_amount = get_pro.free_stock_amount[i];
						if(len(get_pro.free_stock_price[i])) prom_free_stock_price = get_pro.free_stock_price[i];
						if(len(get_pro.amount_1_money[i])) 
							prom_free_stock_money = get_pro.amount_1_money[i];
						else
							prom_free_stock_money = row_money;
					</cfscript>
					<cfif attributes.is_price><!--- fiyat istenmemis ise bu bloga girmez --->
						<!--- price blogu --->
						<cfif get_pro.recordcount>
							<cfif len(get_pro.discount[i]) and get_pro.discount[i]>
								<cfset musteri_flt_other_money_value_with_prom = musteri_flt_other_money_value * ((100-get_pro.discount[i])/100)>
							<cfelseif len(get_pro.amount_discount[i]) and get_pro.amount_discount[i]>
								<cfset musteri_flt_other_money_value_with_prom = musteri_flt_other_money_value - get_pro.amount_discount[i]>
							<cfelse>
								<cfset musteri_flt_other_money_value_with_prom = musteri_flt_other_money_value>
							</cfif>
							<cfset price_form = musteri_flt_other_money_value_with_prom>
						<cfelse>
							<cfset price_form = musteri_flt_other_money_value>
						</cfif>
						<!--- price blogu --->
					</cfif><!--- fiyat istenmemis ise bu bloga girmez --->
					<cfif (attributes.is_stock_count eq 1) or (attributes.is_basket eq 1) or (attributes.is_basket eq 2 and isdefined('session_base.userid'))>
						<cfif isdefined('get_pro.saleable_stock')>
							<!--- stok durum blogu --->
							<cfset usable_stock_amount2 = evaluate('get_pro.saleable_stock[#i#]')>
							<!--- stok durum blogu --->
						<cfelse>
							<cfset usable_stock_amount2 = 0>
						</cfif>
					</cfif>
					<cfif isDefined("attributes.view_mode") and attributes.view_mode eq 'product_table'>
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
									<cfif attributes.is_brand eq 1 and len(brand_list) and len(brand_id)>
										<div class="product_item_brand">
											#get_brands.brand_name[listfind(main_brand_list,brand_id,',')]#
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
										<cfif attributes.is_price eq 1><!--- fiyat yoksa buraya girmez --->
											<cfquery name="GET_MONEY_INFO" datasource="#DSN2#">
												SELECT
													(RATE2/RATE1) RATE
												FROM 
													SETUP_MONEY
												WHERE
													MONEY = <cfqueryparam cfsqltype="cf_sql_varchar" value="#money#">
											</cfquery>
											<cfif attributes.is_price_view eq 1>
												<cfif attributes.is_price_kdvsiz eq 1>
													<!--- <cf_get_lang_main no='2227.Kdvsiz'></td>:  --->#TLFormat(price*get_money_info.rate)#
													#money#
													<cfif money is not '#session_base.money#'>
														(#TLFormat(price)# #money#)
													</cfif>
												</cfif>
												<cfif isdefined("attributes.is_price_sk") and attributes.is_price_sk eq 1>
													<!--- <cf_get_lang_main no='1304.Kdvli'>:  --->#TLFormat(price_kdv * get_money_info.rate)#
													#money#
													<cfif money is not '#session_base.money#'>
														(#TLFormat(price_kdv)# #money#)
													</cfif>
												</cfif>
												(#add_unit#)
												<!--- <cf_get_lang no='1197.İndirimli'>:
												<cfif len(prom_discount) or len(prom_amount_discount)>
													<cfquery name="GET_MONEY_INFO" datasource="#DSN2#">
														SELECT 
															(RATE2/RATE1) RATE
														FROM 
															SETUP_MONEY
														WHERE
															MONEY = <cfqueryparam cfsqltype="cf_sql_varchar" value="#money#">
													</cfquery>
													<strike id="sss">#TLFormat(price*get_money_info.rate)# <cfif isdefined("session.ww")>#session.ww.money#<cfelse>#session.pp.money#</cfif></strike><br />
													<cfset fiyat_ = price_form*get_money_info.rate>												
												<cfelse>
													<cfset fiyat_ = price*get_money_info.rate>	
												</cfif> --->
												<!--- #TLFormat(fiyat_)# <cfif isdefined("session.ww")>#session.ww.money#<cfelse>#session.pp.money#</cfif> --->
												<!--- <cfif (isdefined('session.ww.userid') or isdefined('session.pp.userid')) and attributes.is_price_member neq 0>
													<cf_get_lang no='1199.Size Özel'>:
													<cfif get_pro.recordcount>
														#TLFormat((musteri_flt_other_money_value_with_prom*(1+(tax/100)))*get_money_info.rate)# #session_base.money#
													<cfelse>
														#TLFormat(musteri_flt_other_money_value)# #musteri_row_money# <cfif isdefined("attributes.is_kdv_alert") and attributes.is_kdv_alert eq 1>+ <cf_get_lang_main no='227.KDV'></cfif>
													</cfif>
												</cfif> --->
											</cfif><!--- fiyat yoksa buraya girmez --->
										</cfif>
									</div>
									<div class="product_item_basket">
										<cfif (attributes.is_basket eq 1) or (attributes.is_basket eq 2 and isdefined('session_base.userid'))>
											<cfif not isdefined('attributes.is_basket_standart') or attributes.is_basket_standart eq 1>
												<cfif not get_pro.recordcount and (is_zero_stock eq 1 or (is_zero_stock neq 1 and usable_stock_amount2 gt 0) or (isdefined("attributes.is_stock_kontrol") and attributes.is_stock_kontrol eq 0)) and musteri_flt_other_money_value gt 0>
													<div class="product_item_basket_top">
														<i name="miktar_#currentrow#" id="miktar_#currentrow#">1</i>
														<div class="product_item_basket_bottom">
															<a href="" onclick="add_product(#stock_id#,1,#widget.id#);"><cf_get_lang dictionary_id='52116.Sepete Ekle'><i class="fa fa-shopping-cart"></i></a>
														</div>
													</div>
												<cfelseif not get_pro.recordcount and (is_zero_stock eq 1 or (is_zero_stock neq 1 and usable_stock_amount2 gt 0) or (isdefined("attributes.is_stock_kontrol") and attributes.is_stock_kontrol eq 0)) and musteri_flt_other_money_value gt 0>
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
				</cfloop>
			</cfif>
		</cfif>
	</cfoutput>
<cfelse>
	<cfif isDefined("attributes.view_mode") and attributes.view_mode eq 'product_table'>
		<tr>
			<td colspan="9"><cfoutput>#getLang('', 'Aradığınız kriterlerde ürün bulunamadı', 64185)#</cfoutput>!</td>
		</tr>
	<cfelse>
		<div class="col-md-12"><cfoutput>#getLang('', 'Aradığınız kriterlerde ürün bulunamadı', 64185)#</cfoutput>!</div>
	</cfif>
</cfif>
<!--- <cfif attributes.product_compare eq 1>
	<tr class="color-list" style="height:35px;">
		<td colspan="<cfoutput>#attributes.prod_coloum#</cfoutput>"><a href="javascript://" onclick="karsilastir();" class="prod_karsila"></a></td>
	</tr>
</cfif> --->