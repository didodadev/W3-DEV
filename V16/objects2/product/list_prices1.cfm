<cfif isdefined("session.ww")>
	<cfset session.ww.list_type = 2>
<cfelseif  isdefined("session.pp")>
	<cfset session.pp.list_type = 2>
</cfif>
<table border="0" cellpadding="1" cellspacing="1" style="width:100%;">
	<cfif attributes.product_compare eq 1>
		<tr style="background-color:##CCCCCC; height:1px;">
			<td></td>
		</tr>
		<tr style="background-color:##F5F5F5; height:20px;">
			<td>&nbsp;&nbsp;<a href="##" onclick="karsilastir();" class="prod_karsila"></a></td>
		</tr>
	</cfif>
	<cfif get_homepage_products.recordcount>
		<cfif attributes.is_brand eq 1 and listlen(brand_list)>
			<cfset brand_list=listsort(brand_list,"numeric","ASC",",")>
			<cfif listlen(brand_list)>
				<cfquery name="GET_BRANDS" datasource="#DSN1#">
					SELECT PB.BRAND_NAME,PBI.BRAND_ID,PBI.PATH FROM PRODUCT_BRANDS_IMAGES PBI, PRODUCT_BRANDS PB WHERE PBI.BRAND_ID = PB.BRAND_ID AND PBI.BRAND_ID IN (#brand_list#) ORDER BY PBI.BRAND_ID
				</cfquery>
			</cfif>
			<cfset main_brand_list = listsort(listdeleteduplicates(valuelist(get_brands.brand_id,',')),'numeric','ASC',',')>
		</cfif>
		<cfif attributes.is_image eq 1>
			<cfif listlen(product_id_list)>
				<cfquery name="GET_PRODUCT_IMAGES" datasource="#DSN3#">
					SELECT 
                    	PATH,
                        PRODUCT_ID,
                        PATH_SERVER_ID,
                        DETAIL 
                    FROM 
                    	PRODUCT_IMAGES 
                    WHERE 
						<cfif isdefined('attributes.is_product_image_dimension') and attributes.is_product_image_dimension eq 0>
                            IMAGE_SIZE = 0 AND 
                        <cfelseif isdefined('attributes.is_product_image_dimension') and attributes.is_product_image_dimension eq 1>
                            IMAGE_SIZE = 1 AND 
                        <cfelse>
                            IMAGE_SIZE = 2 AND 
                        </cfif> 
                        PRODUCT_ID IN (#product_id_list#) 
                    ORDER BY 
                    	PRODUCT_ID
				</cfquery>
				<cfset product_id_list = listdeleteduplicates(valuelist(get_product_images.product_id,','),'numeric','ASC',',')>
				<cfset product_id_list = listsort(product_id_list,"numeric","ASC",",")>
			</cfif>
		</cfif>
		<cfif isdefined("attributes.is_show_point") and attributes.is_show_point eq 1>
			<cfif listlen(segment_list)>
				<cfquery name="GET_SEGMENTS" datasource="#DSN1#">
					SELECT PRODUCT_SEGMENT_ID, PRODUCT_SEGMENT FROM PRODUCT_SEGMENT WHERE PRODUCT_SEGMENT_ID IN (#segment_list#) ORDER BY PRODUCT_SEGMENT_ID
				</cfquery>
				<cfset main_segment_list = listsort(listdeleteduplicates(valuelist(get_segments.product_segment_id,',')),'numeric','ASC',',')>
			</cfif>
		</cfif>
		<cfoutput query="get_homepage_products" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
			<cfif isDefined("money")>
				<cfset attributes.money = money>
			</cfif>			
			<cfif attributes.is_price><!--- fiyat istenmemis ise buraya girmesi gerekmez --->
				<cfloop query="moneys">
					<cfif moneys.money is attributes.money>
						<cfset row_money = money>
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
						if(get_p.recordcount and len(get_p.price))
						{
							musteri_pro_price = get_p.price; 
							musteri_pro_price_kdv = get_p.price_kdv; 
							musteri_row_money=get_p.money;
						}
						else
						{
							musteri_pro_price = pro_price;
							musteri_pro_price_kdv = pro_price_kdv;
							musteri_row_money=attributes.money;
						} //musteriye ozel fiyat yoksa son kullanici gecerli
						//{musteri_pro_price = 0;musteri_row_money=default_money.money;}
					</cfscript>
					<cfloop query="moneys">
						<cfif moneys.money is musteri_row_money>
							<cfset musteri_row_money_rate1 = moneys.rate1>
							<cfset musteri_row_money_rate2 = moneys.rate2>
						</cfif>
					</cfloop>				
					<cfscript>
						if(musteri_row_money is default_money.money)
						{
							musteri_str_other_money = musteri_row_money; 
							musteri_flt_other_money_value = musteri_pro_price;
							musteri_flt_other_money_value_kdv = musteri_pro_price_kdv;	
							musteri_flag_prc_other = 0;
						}
						else
						{
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
			<tr style="background-color:##CCCCCC; height:1px;">
				<td></td>
			</tr>
			<cfif bir_2_bir neq 1>
				<cfif len(user_friendly_url)>
					<cfset product_link_ = "&urun=#user_friendly_url#&product_id=#product_id#&stock_id=#stock_id#">
				<cfelse>
					<cfset product_link_ = "&product_id=#product_id#&stock_id=#stock_id#">
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
				<tr>
			  		<td>
						<table cellpadding="2" cellspacing="2" style="width:99%;"><!--- dis tablo basliyor --->
							<tr>
								<cfif attributes.product_compare eq 1>
									<td style="width:15px;"><input type="checkbox" name="product_id" id="product_id" value="#product_id#"></td>
								</cfif>
								<cfif attributes.is_image eq 1>
									<td align="center" id="product_image_#currentrow#" style="width:125px;">				  
										<cfif listfindnocase(product_id_list,product_id)>
											<a #fuseact_# title="#product_detail#"><cf_get_server_file output_file="product/#get_product_images.path[listfind(product_id_list,product_id)]#" output_server="#get_product_images.path_server_id[listfind(product_id_list,product_id)]#" title="#get_product_images.detail[listfind(product_id_list,product_id)]#" alt="#get_product_images.detail[listfind(product_id_list,product_id)]#" output_type="0" image_width="#image_width_normal_#" image_link="0"></a>
									  	</cfif>
									</td>
								</cfif>
								<td>
									<cfif attributes.is_brand eq 1 and listlen(brand_list)>
										<cfif len(brand_id)>
											<cfif len(get_brands.path[listfind(main_brand_list,brand_id,',')])>
												<img src="/documents/product/#get_brands.path[listfind(main_brand_list,brand_id,',')]#">
											<cfelse>
												#get_brands.brand_name[listfind(main_brand_list,brand_id,',')]#
											</cfif>
										</cfif>
										<br/>
									</cfif>
									<cfif attributes.is_price>
										<a #fuseact_# class="product_name_detail_list" title="#product_detail#"><cfif not isdefined("attributes.is_detail2") or attributes.is_detail2 eq 0 or not len (product_detail2)>#product_name#<cfif property is '-'><cfelseif len(property) gt 1>&nbsp;#property#</cfif><cfelse>#product_detail2#</cfif></a>
									<cfelse>
										<a #fuseact_# class="product_name_detail_list" title="#product_detail#"><cfif not isdefined("attributes.is_detail2") or attributes.is_detail2 eq 0 or not len (product_detail2)>#product_name#<cfif property is '-'><cfelseif len(property) gt 1>&nbsp;#property#</cfif><cfelse>#product_detail2#</cfif></a>
									</cfif>
									<cfif isdefined("attributes.is_product_code") and attributes.is_product_code eq 1>
										<table>
											<tr>
												<td nowrap="nowrap" class="prodprice" style="width:30%;"><cf_get_lang_main no='1388.Ürün Kodu'></td>
												<td class="product_name" align="center"><cfif len(product_code_2)>#product_code_2#<cfelse>&nbsp;</cfif></td>
											</tr>
										</table>
									</cfif>
								</td>
								<td style="width:40%;">				
									<table cellpadding="1" cellspacing="1" style="width:100%;">
										<tr>
											<td colspan="2">
												<!---<cfif isdefined('attributes.is_bundle') and attributes.is_bundle eq 1>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<a #fuseact_# class="product_name" title=" #PRODUCT_DETAIL#">Bundle <cf_get_lang_main no='643.Detayını Görmek İçin Tıklayınız'>!</a></cfif>--->
												<cfif attributes.is_price><!--- fiyat istenmemis ise buraya girmesi gerekmez --->
													<input type="hidden" name="diff_rate_values_#currentrow#" id="diff_rate_values_#currentrow#" value="">
													<input type="hidden" name="pid_#currentrow#" id="pid_#currentrow#" value="#product_id#">
													<input type="hidden" name="sid_#currentrow#" id="sid_#currentrow#" value="#stock_id#">
													<input type="hidden" name="catalog_id_#currentrow#" id="catalog_id_#currentrow#" value="#stock_id#">
													<input type="hidden" name="prom_id_#currentrow#" id="prom_id_#currentrow#" value="#prom_id#">
													<input type="hidden" name="prom_discount_#currentrow#" id="prom_discount_#currentrow#" value="#prom_discount#">
													<input type="hidden" name="prom_amount_discount_#currentrow#" id="prom_amount_discount_#currentrow#" value="#prom_amount_discount#">
													<input type="hidden" name="prom_cost_#currentrow#" id="prom_cost_#currentrow#" value="#prom_cost#">
													<input type="hidden" name="prom_free_stock_id_#currentrow#" id="prom_free_stock_id_#currentrow#" value="#prom_free_stock_id#">				
													<input type="hidden" name="prom_stock_amount_#currentrow#" id="prom_stock_amount_#currentrow#" value="#prom_stock_amount#">
													<input type="hidden" name="prom_free_stock_amount_#currentrow#" id="prom_free_stock_amount_#currentrow#" value="#prom_free_stock_amount#">
													<input type="hidden" name="prom_free_stock_price_#currentrow#" id="prom_free_stock_price_#currentrow#" value="#prom_free_stock_price#">
													<input type="hidden" name="prom_free_stock_money_#currentrow#" id="prom_free_stock_money_#currentrow#" value="#prom_free_stock_money#">
													<cfset price_form = musteri_flt_other_money_value>
													<input type="hidden" name="price_old_#currentrow#" id="price_old_#currentrow#" value="">
													<input type="hidden" name="price_#currentrow#" id="price_#currentrow#" value="#price_form#">
													<!---<input type="hidden" name="price_kdv_#currentrow#" id="price_kdv_#currentrow#" value="#price_form*(1+(tax/100))#">--->
                                                    <input type="hidden" name="price_kdv_#currentrow#" id="price_kdv_#currentrow#" value="#musteri_flt_other_money_value_kdv#">
													<input type="hidden" name="price_money_#currentrow#" id="price_money_#currentrow#" value="#musteri_row_money#">
													<input type="hidden" name="price_standard_#currentrow#" id="price_standard_#currentrow#" value="#price#">
                                    				<!---<input type="hidden" name="price_standard_kdv_#currentrow#" id="price_standard_kdv_#currentrow#" value="#price*(1+(tax/100))#">--->
  				                            		<input type="hidden" name="price_standard_kdv_#currentrow#" id="price_standard_kdv_#currentrow#" value="#price_kdv#">
													<input type="hidden" name="price_standard_money_#currentrow#" id="price_standard_money_#currentrow#" value="#money#">
												</cfif><!--- fiyat istenmemis ise buraya girmesi gerekmez --->
												<cfif attributes.is_detail><br/>#product_detail#</cfif>
												<cfif isdefined('attributes.is_product_comment') and attributes.is_product_comment eq 1>
													<cfinclude template="product_comment_stars_noadd.cfm">
												</cfif>
											</td>
										</tr>
                                        <tr>
                                        	<td nowrap="nowrap" style="width:50%;"><cf_get_lang_main no='106.Stok Kodu'></td>
											<td>#stock_code#</td>
                                        </tr>
                                        <tr>
                                            <td nowrap="nowrap" style="width:30%;"><cf_get_lang_main no='224.Birim'></td>
                                        	<td>#add_unit#</td>
                                        </tr>
                                        <tr>
                                            <td nowrap="nowrap" style="width:30%;">KDV</td>
                                        	<td>#tax#</td>
                                        </tr>
                                        
										<cfif attributes.is_stock_count eq 1>
											<tr>
												<td nowrap="nowrap" style="width:30%;"><cf_get_lang_main no='40.Stok'></td>
											  	<td>
													<cfif isdefined("attributes.is_stock_count_limit") and len(attributes.is_stock_count_limit)>
														<cfset stock_limit = attributes.is_stock_count_limit>
													<cfelse>
														<cfset stock_limit = 0>
													</cfif>
													<cfif isdefined("attributes.is_show_spect_stock") and attributes.is_show_spect_stock eq 1 and is_production eq 1 and is_prototype eq 1>
														<div style="margin-left:0;height:200px;position:absolute;overflow:auto;height:200;" id="show_stock_spect_detail_row#currentrow#"></div>
														<a style="cursor:pointer;"  class="tableyazi" onclick="show_stock_spect_detail(#currentrow#,#stock_id#);">
													</cfif>
													<cfif stock_limit neq 0>
														<cfif usable_stock_amount lte 0>
															<font color="FF0000">Stokta Yok</font>
														<cfelseif usable_stock_amount lte stock_limit>
															<font color="FF0000">Kritik Stok</font>
														<cfelseif usable_stock_amount lt 0>0
														<cfelseif usable_stock_amount lt 5>
															<cfif isnumeric(usable_stock_amount)>
																#amountformat(usable_stock_amount,0)#
															<cfelse>
																#usable_stock_amount#
															</cfif>
														<cfelseif usable_stock_amount lt 10>5+
														<cfelseif usable_stock_amount lt 20>10+
														<cfelseif usable_stock_amount lt 50>20+
														<cfelseif usable_stock_amount lt 100>50+
														<cfelse>100+
														</cfif>
													<cfelse>
														<cfif usable_stock_amount lt 0>0
														<cfelseif usable_stock_amount lt 5>
															<cfif isnumeric(usable_stock_amount)>
																#amountformat(usable_stock_amount,0)#
															<cfelse>
																#usable_stock_amount#
															</cfif>
														<cfelseif usable_stock_amount lt 10>5+
														<cfelseif usable_stock_amount lt 20>10+
														<cfelseif usable_stock_amount lt 50>20+
														<cfelseif usable_stock_amount lt 100>50+
														<cfelse>100+
														</cfif>
													</cfif>
													<cfif isdefined("attributes.is_show_spect_stock") and attributes.is_show_spect_stock eq 1 and is_production eq 1>
														</a>
													</cfif>
											  	</td>
										  	</tr>
										</cfif>
										<cfif attributes.is_stock_way>
											<tr>
												<td nowrap="nowrap" style="width:30%;"><cf_get_lang_main no='635.Yoldaki Stok'></td>
												<td>#purchase_order_stock#</td>
											</tr>
										</cfif>
										<cfif attributes.is_price_kdvsiz eq 1 and attributes.is_price_view eq 1>
											<tr>
												<td><cf_get_lang_main no='2227.Kdvsiz'></td>
												<td>:
													<cfquery name="GET_MONEY_INFO" datasource="#DSN2#">
														SELECT
															(RATE2/RATE1) RATE
														FROM 
															SETUP_MONEY
														WHERE
															MONEY = <cfqueryparam cfsqltype="cf_sql_varchar" value="#money#">
													</cfquery>
													<cfset fiyat_ = price*get_money_info.rate>										
													#TLFormat(fiyat_)#										
													<cfif isdefined("session.ww")>#session.ww.money#<cfelse>#session.pp.money#</cfif>
													<cfif money is not '#session_base.money#'>
														(#TLFormat(price)# #money#)
													</cfif>
													<cfif isdefined("attributes.is_kdv_alert") and attributes.is_kdv_alert eq 1>+ <cf_get_lang_main no='227.KDV'></cfif>
												</td>
											</tr>
										</cfif>
										<cfif attributes.is_price_view eq 1>
											<cfif attributes.is_price><!--- fiyat istenmemis ise buraya girmesi gerekmez --->
												<cfquery name="GET_MONEY_INFO" datasource="#DSN2#">
													SELECT
														(RATE2/RATE1) RATE
													FROM 
														SETUP_MONEY
													WHERE
														MONEY = <cfqueryparam cfsqltype="cf_sql_varchar" value="#money#">
												</cfquery>
												<cfif isdefined("attributes.is_price_sk") and attributes.is_price_sk eq 1>
													<tr>
														<td><cf_get_lang_main no='1304.Kdvli'></td>
														<td nowrap>:
															#TLFormat(price_kdv * get_money_info.rate)#
															<cfif isdefined("session.ww.money")>#session.ww.money#<cfelseif isdefined('session.pp')>#session.pp.money#<cfelse>#money#</cfif>
															<cfif money is not '#session_base.money#'>
																(#TLFormat(price_kdv)# #money#)
															</cfif>
														</td>
													</tr>
                                				</cfif>
											  	<cfif (isdefined('session.ww.userid') or isdefined('session.pp.userid')) and attributes.is_price_member neq 0>
													<cfif attributes.price_catid neq -2 and get_p.recordcount and len(get_p.catalog_id)>
														<cfquery name="GET_CATALOG" dbtype="query">
															SELECT * FROM GET_CATALOGS WHERE CATALOG_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_p.catalog_id#">
														</cfquery>
													</cfif>
                                                	<cfif isDefined('attributes.is_price_member') and (attributes.is_price_member eq 1 or attributes.is_price_member eq 3)> 
                                                        <tr>
                                                            <td><cf_get_lang no='412.Size Özel'></td>
                                                            <td class="prodFiyat"<cfif attributes.price_catid neq -2 and get_p.recordcount and len(get_p.catalog_id)>title="Bu Fiyat #get_catalog.catalog_head# Katalog Fiyatıdır!"</cfif>>
                                                                <b>#TLFormat(musteri_flt_other_money_value)# #musteri_row_money# <cfif isdefined("attributes.is_kdv_alert") and attributes.is_kdv_alert eq 1>+ <cf_get_lang_main no='227.KDV'></cfif></b>
                                                            </td>
                                                        </tr>
                                                    </cfif>
                                                	<cfif isDefined('attributes.is_price_member') and (attributes.is_price_member eq 2 or attributes.is_price_member eq 3)> 
                                                        <tr>
                                                            <td><cf_get_lang_main no='1304.KDV li'> <cf_get_lang no='412.Size Özel Fiyat'></td>
                                                            <td class="prodFiyat"<cfif attributes.price_catid neq -2 and get_p.recordcount and len(get_p.catalog_id)>title="Bu Fiyat #get_catalog.catalog_head# Katalog Fiyatıdır!"</cfif>>
                                                                <b>#TLFormat(musteri_flt_other_money_value_kdv)# #musteri_row_money# </b>
                                                            </td>
                                                        </tr>
                                                    </cfif>
											  	</cfif>
                          					</cfif>
                      					</cfif>
										<cfif attributes.is_price_view eq 1 and isdefined("attributes.list_price_discount_rate") and len(attributes.list_price_discount_rate)>
											<cfquery name="GET_MONEY_INFO" datasource="#DSN2#">
												SELECT
													(RATE2/RATE1) RATE
												FROM 
													SETUP_MONEY
												WHERE
													MONEY = <cfqueryparam cfsqltype="cf_sql_varchar" value="#musteri_row_money#">
											</cfquery>
											<tr>
												<td><cf_get_lang no='384.Havale'></td>
												<td class="prodFiyat">
													<font color="red">:
														<cfif attributes.is_price_member eq 0>
															<cfset indirimli_ozel_fiyat = musteri_flt_other_money_value_kdv *get_money_info.rate>
														<cfelse>
															<cfset indirimli_ozel_fiyat = musteri_flt_other_money_value * get_money_info.rate>
														</cfif>
														#tlformat(indirimli_ozel_fiyat - (indirimli_ozel_fiyat * attributes.list_price_discount_rate/100))# 
														<cfif isdefined("session.ww")>#session.ww.money#<cfelse>#session.pp.money#</cfif> (% #attributes.list_price_discount_rate# <cf_get_lang no='1197.indirimli'>)
													</font>
												</td>
											</tr>
										</cfif>
									 	<cfif isdefined("attributes.is_show_point") and attributes.is_show_point eq 1>
											<tr>
												<td><cf_get_lang_main no='1572.Puan'></td>
												<td>
													<cfif len(segment_id)>
														#get_segments.product_segment[listfind(main_segment_list,segment_id)]#
													</cfif>
												</td>
											</tr>
									  	</cfif>
									</table>
								</td>
								<td style="width:110px;">
									<cfif (attributes.is_basket eq 1) or (attributes.is_basket eq 2 and isdefined('session_base.userid'))>
										<cfif not isdefined('attributes.is_basket_standart') or attributes.is_basket_standart eq 1>
											<cfif (is_zero_stock eq 1 or (is_zero_stock neq 1 and usable_stock_amount gt 0) or is_production eq 1 or (isdefined("attributes.is_stock_kontrol") and attributes.is_stock_kontrol eq 0))<!---  and musteri_flt_other_money_value gt 0 --->>												
												<table cellpadding="1" cellspacing="1" align="center" style="width:100px;">
													<tr>
														<td style="border:1px solid cccccc; text-align:center; background-color:##FBFBFB;">
															<br/><span class="txtbold"><cf_get_lang_main no='223.Miktar'></span><br/>
																<input type="text" name="miktar_#currentrow#" id="miktar_#currentrow#" value="1" maxlength="8" style="width:40px;" class="moneybox" onkeyup="return FormatCurrency(isNumber(this,event),#fusebox.Format_Currency#);">
															<br/>
														</td>
													</tr>
													<tr>
														<td align="center">
															<cfif isdefined('attributes.is_prices_prototype') and attributes.is_prices_prototype eq 1 and is_prototype eq 1 and is_production eq 1>
																<input type="hidden" name="spec_var_id_#currentrow#" id="spec_var_id_#currentrow#" value="" />
																<input type="hidden" name="spec_var_name_#currentrow#" id="spec_var_name_#currentrow#" value="" />
																<a href="javascript://" onclick="windowopen('#request.self#?fuseaction=objects.popup_add_spect_list&stock_id=#stock_id#&is_partner=1&row_id=#currentrow#','list')" class="prod_sepet" title="<cf_get_lang_main no='1376.Sepete At'>"></a>
															<cfelse>
																<a href="javascript://" onclick="urun_gonder('#currentrow#','0','0');" class="prod_sepet" title="<cf_get_lang_main no='1376.Sepete At'>"></a>
															</cfif>
														</td>
													</tr>
												</table>
											<cfelse>
												<span class="table_warning"><cf_get_lang no='409.STOKTA YOK'></span>
											</cfif>
										<cfelse>
											<input type="text" name="miktar_#currentrow#" id="miktar_#currentrow#" value="1" maxlength="8" style="width:40px;" class="moneybox" onkeyup="return FormatCurrency(isNumber(this,event),#fusebox.Format_Currency#);">&nbsp;&nbsp;
											<cfif get_pro.recordcount and len(get_pro.prom_point)>
												<br/><br/>
												<input type="hidden" name="puan_product_id_#currentrow#_#i#" id="puan_product_id_#currentrow#_#i#" value="#product_id#">
												<input type="hidden" name="puan_stock_id_#currentrow#_#i#" id="puan_stock_id_#currentrow#_#i#" value="#stock_id#">
												<input type="hidden" name="puan_prom_point_#currentrow#_#i#" id="puan_prom_point_#currentrow#_#i#" value="#get_pro.prom_point#">
												<input type="hidden" name="puan_prom_id_#currentrow#_#i#" id="puan_prom_id_#currentrow#_#i#" value="#get_pro.prom_id#">
												<input type="hidden" name="puan_price_catid_#currentrow#_#i#" id="puan_price_catid_#currentrow#_#i#" value="#attributes.price_catid#">
												<input type="hidden" name="puan_product_name_#currentrow#_#i#" id="puan_product_name_#currentrow#_#i#" value="#product_name#<cfif property is '-'><cfelseif len(property) gt 1> #property#</cfif>">
												<a href="##" onclick="puan_urun_gonder('#currentrow#','#i#');<!---return PROCTest()--->" class="headersepet" title="<cf_get_lang_main no='1376.Sepete At'>"></a>
											</cfif>
										</cfif>
						  			</cfif>
									<cfif (isdefined("session.ww.userid") or isdefined("session.pp.userid")) and attributes.is_demand eq 1>
										<br/><br/>
										<cfif attributes.is_price eq 1><a href="javascript://" onclick="windowopen('#request.self#?fuseaction=objects2.popup_add_order_demand&stock_id=#stock_id#&price=#musteri_flt_other_money_value#&price_money=#musteri_row_money#&unit_id=#PRODUCT_UNIT_ID#&demand_type=1','small');"><img src="/images/uyar.gif" title="<cf_get_lang no ='1144.Fiyat Düşünce Haber Ver'>" border="0"></a></cfif>
										<cfif ((attributes.is_stock_count eq 1) or (attributes.is_basket eq 1) or (attributes.is_basket eq 2 and isdefined('session_base.userid'))) and is_zero_stock neq 1 and isdefined("usable_stock_amount") and usable_stock_amount lte 0 and attributes.is_price eq 1>
											<a href="javascript://" onclick="windowopen('#request.self#?fuseaction=objects2.popup_add_order_demand&stock_id=#stock_id#&price=#price_form#&price_money=#musteri_row_money#&unit_id=#PRODUCT_UNIT_ID#&demand_type=2','small');"><img src="/images/ship.gif" title="<cf_get_lang no ='1145.Stoklara Gelince Haber Ver'>" border="0"></a>
											<a href="javascript://" onclick="windowopen('#request.self#?fuseaction=objects2.popup_add_order_demand&stock_id=#stock_id#&price=#price_form#&price_money=#musteri_row_money#&unit_id=#PRODUCT_UNIT_ID#&demand_type=3','small');"><img src="/images/target_customer.gif" title="<cf_get_lang no ='1146.Ön Sipariş/ Rezerve'> " border="0"></a>
										</cfif>
									</cfif>
								</td>
							</tr>
						</table><!--- dis tablo bitiyor --->
					</td> 
				</tr>
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
                        <cfif len(user_friendly_url)>
                            <cfset product_link_ = "&urun=#user_friendly_url#&product_id=#product_id#&stock_id=#stock_id#">
                        <cfelse>
                            <cfset product_link_ = "&product_id=#product_id#&stock_id=#stock_id#">
                        </cfif>
                        <cfif attributes.is_popup>
                            <cfset fuseact_ = 'href="javascript://" onclick=windowopen("#request.self#?fuseaction=objects2.popup_detail_product#product_link_#","list");'>
                        <cfelse>
                            <cfset fuseact_ = 'href="#request.self#?fuseaction=objects2.detail_product#product_link_#"'>
                        </cfif>
                        <tr style="background-color:##F5F5F5;">
                            <td>
                                <table cellpadding="2" cellspacing="2" style="width:99%;"><!--- dis tablo basliyor --->
                                    <tr>
                                        <cfif attributes.product_compare eq 1>
                                            <td style="width:15px;"><input type="checkbox" name="prom_product_id" id="prom_product_id" value="#product_id#"></td>
                                        </cfif>
                                        <cfif attributes.is_image eq 1>
                                            <td align="center" style="width:125px;">
                                                <cfif listfindnocase(product_id_list,product_id)>
                                                    <a #fuseact_# title="#product_detail#"><cf_get_server_file output_file="product/#get_product_images.path[listfind(product_id_list,product_id)]#" output_server="#get_product_images.path_server_id[listfind(product_id_list,product_id)]#" title="#get_product_images.detail[listfind(product_id_list,product_id)]#" alt="#get_product_images.detail[listfind(product_id_list,product_id)]#" output_type="0" image_width="#image_width_normal_#" image_height="#image_height_normal_#" image_link="0"></a>
                                                </cfif>
                                            </td>
                                        </cfif>
                                        <td>
                                            <cfif (attributes.is_brand eq 1 and listlen(brand_list)) or (len(get_pro.icon_id[i]) AND (get_pro.icon_id[i] gt 0))>
                                                <cfif len(brand_id)>
                                                    <cfif len(get_brands.brand_logo[listfind(main_brand_list,brand_id,',')])>
                                                        <img src="/documents/product/#get_brands.brand_logo[listfind(main_brand_list,brand_id,',')]#">
                                                    <cfelse>
                                                        #get_brands.brand_name[listfind(main_brand_list,brand_id,',')]#
                                                    </cfif>
                                                </cfif>
                                              <cfif len(get_pro.icon_id[i]) AND (get_pro.icon_id[i] gt 0)>
                                                <cfquery name="GET_ICON" datasource="#DSN3#">
                                                        SELECT ICON, ICON_SERVER_ID FROM SETUP_PROMO_ICON WHERE ICON_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_pro.icon_id[i]#">
                                                    </cfquery>
                                                  &nbsp;&nbsp;<cf_get_server_file output_file="sales/#get_icon.icon#" output_server="#get_icon.icon_server_id#" output_type="0" image_link="1" alt="#getLang('main',668)#" title="#getLang('main',668)#">
                                                </cfif>
                                                <br/>
                                            </cfif>
                                            <cfif attributes.is_price>
                                                <a #fuseact_# class="product_name_detail_list" title="#product_detail#">#product_name#<cfif property is '-'><cfelseif len(property) gt 1>&nbsp;#property#</cfif></a>
                                            <cfelse>
                                                <a #fuseact_# class="product_name_detail_list" title="#product_detail#">#product_name#<cfif property is '-'><cfelseif len(property) gt 1>&nbsp;#property#</cfif></a>
                                            </cfif>
                                            <cfif isdefined("attributes.is_product_code") and attributes.is_product_code eq 1>
                                                <table>
                                                    <tr>
                                                        <td nowrap="nowrap" class="prodprice" style="width:100px;"><cf_get_lang_main no='377.Özel Kod'></td>
                                                        <td class="product_name" align="center"><cfif len(product_code_2)>#product_code_2#<cfelse>&nbsp;</cfif></td>
                                                    </tr>
                                                </table>
                                            </cfif>
                                            <br/>
                                            <font color="FF0000">
                                                <cfif len(prom_free_stock_id)>
                                                    <strong>#get_pro.prom_head[i]#:</strong> #get_product_name(stock_id:prom_free_stock_id,with_property:1)#
                                                <cfelseif len(prom_discount)>
                                                    <strong><cf_get_lang no='132.Yüzde İndirim'>:</strong> % #prom_discount#
                                                <cfelseif len(prom_amount_discount)>
                                                    <strong><cf_get_lang no='133.Tutar Indirimi'>:</strong> #prom_amount_discount# #get_pro.amount_1_money[i]#
                                                </cfif>
                                            </font>
                                            <cfif not (len(prom_free_stock_price) and prom_free_stock_price eq 0)>
                                                &nbsp;&nbsp;&nbsp;<input type="checkbox" name="is_no_prom_#currentrow#_#i#" id="is_no_prom_#currentrow#_#i#" value="1"> <font color="red"><cf_get_lang no ='1374.Promosyon İstemiyorum'></font>
                                            </cfif>
                                        </td>
                                        <td style="width:275px;">
                                            <table cellpadding="1" cellspacing="1" border="0">
                                                <tr>
                                                    <td colspan="2">
                                                        <input type="hidden" name="pid_#currentrow#_#i#" id="pid_#currentrow#_#i#" value="#product_id#">
                                                        <input type="hidden" name="sid_#currentrow#_#i#" id="sid_#currentrow#_#i#" value="#stock_id#">
                                                        <input type="hidden" name="prom_id_#currentrow#_#i#" id="prom_id_#currentrow#_#i#" value="#prom_id#">
                                                        <input type="hidden" name="prom_discount_#currentrow#_#i#" id="prom_discount_#currentrow#_#i#" value="#prom_discount#">
                                                        <input type="hidden" name="prom_amount_discount_#currentrow#_#i#" id="prom_amount_discount_#currentrow#_#i#" value="#prom_amount_discount#">
                                                        <input type="hidden" name="prom_cost_#currentrow#_#i#" id="prom_cost_#currentrow#_#i#" value="#prom_cost#">
                                                        <input type="hidden" name="prom_free_stock_id_#currentrow#_#i#" id="prom_free_stock_id_#currentrow#_#i#" value="#prom_free_stock_id#">				
                                                        <input type="hidden" name="prom_stock_amount_#currentrow#_#i#" id="prom_stock_amount_#currentrow#_#i#" value="#prom_stock_amount#">
                                                        <input type="hidden" name="prom_free_stock_amount_#currentrow#_#i#" id="prom_free_stock_amount_#currentrow#_#i#" value="#prom_free_stock_amount#">
                                                        <input type="hidden" name="prom_free_stock_price_#currentrow#_#i#" id="prom_free_stock_price_#currentrow#_#i#" value="#prom_free_stock_price#">
                                                        <input type="hidden" name="prom_free_stock_money_#currentrow#_#i#" id="prom_free_stock_money_#currentrow#_#i#" value="#prom_free_stock_money#">
                                                        <input type="hidden" name="catalog_id_#currentrow#_#i#" id="catalog_id_#currentrow#_#i#" value="#catalog_id_#">
                                                        <cfif isdefined('attributes.is_product_comment') and attributes.is_product_comment eq 1>
                                                            <cfinclude template="product_comment_stars_noadd.cfm">
                                                        </cfif>
                                                    </td>
                                                </tr>					 
                                                <cfif attributes.is_stock_count eq 1>
                                                    <tr>
                                                        <td nowrap="nowrap" style="width:100px;"><cf_get_lang_main no='40.Stok'></td>
                                                        <td>
                                                            <cfif usable_stock_amount2 lt 0>0
                                                            <cfelseif usable_stock_amount2 lt 5>
                                                                <cfif isnumeric(usable_stock_amount2)>
                                                                    #amountformat(usable_stock_amount2,0)#
                                                                <cfelse>
                                                                    #usable_stock_amount2#
                                                                </cfif>
                                                            <cfelseif usable_stock_amount2 lt 10>5+
                                                            <cfelseif usable_stock_amount2 lt 20>10+
                                                            <cfelseif usable_stock_amount2 lt 50>20+
                                                            <cfelseif usable_stock_amount2 lt 100>50+
                                                            <cfelse>100+
                                                            </cfif>
                                                        </td>
                                                    </tr>
                                                </cfif>
                                                <cfif attributes.is_stock_way>
                                                    <tr>
                                                        <td nowrap="nowrap" style="width:100px;"><cf_get_lang_main no='635.Yoldaki Stok'></td>
                                                        <td>
                                                            #get_last_stocks_promotions.purchase_order_stock[listfind(promotion_stock_list,prom_stok_id)]#
                                                        </td>
                                                    </tr>
                                                </cfif>
                                                <cfif attributes.is_price eq 1><!--- fiyat yoksa buraya girmez --->
                                                    <input type="hidden" name="price_old_#currentrow#_#i#" id="price_old_#currentrow#_#i#" value="<cfif get_pro.recordcount>#musteri_flt_other_money_value#</cfif>">
                                                    <input type="hidden" name="price_#currentrow#_#i#" id="price_#currentrow#_#i#" value="#price_form#">
                                                    <input type="hidden" name="price_kdv_#currentrow#_#i#" id="price_kdv_#currentrow#_#i#" value="#price_form*(1+(tax/100))#">
                                                    <input type="hidden" name="price_money_#currentrow#_#i#" id="price_money_#currentrow#_#i#" value="#musteri_row_money#">
                                                    <input type="hidden" name="price_standard_#currentrow#_#i#" id="price_standard_#currentrow#_#i#" value="#price#">
                                                    <input type="hidden" name="price_standard_kdv_#currentrow#_#i#" id="price_standard_kdv_#currentrow#_#i#" value="#price*(1+(tax/100))#">
                                                    <input type="hidden" name="price_standard_money_#currentrow#_#i#" id="price_standard_money_#currentrow#_#i#" value="#money#">
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
                                                            <tr>
                                                                <td><cf_get_lang_main no='2227.Kdvsiz'></td>
                                                                <td>:
                                                                    #TLFormat(price*get_money_info.rate)#
                                                                    <cfif isdefined("session.ww")>#session.ww.money#<cfelse>#session.pp.money#</cfif>
                                                                    <cfif money is not '#session_base.money#'>
                                                                    (#TLFormat(price)# #money#)
                                                                    </cfif>
                                                                    <cfif isdefined("attributes.is_kdv_alert") and attributes.is_kdv_alert eq 1>+ <cf_get_lang_main no='227.KDV'></cfif>
                                                                </td>
                                                            </tr>
                                                        </cfif>
                                                        <cfif isdefined("attributes.is_price_sk") and attributes.is_price_sk eq 1>
                                                            <tr>
                                                                <td><cf_get_lang_main no='1304.Kdvli'></td>
                                                                <td nowrap>:
                                                                    #TLFormat(price_kdv * get_money_info.rate)#
                                                                    <cfif isdefined("session.ww")>#session.ww.money#<cfelse>#session.pp.money#</cfif>
                                                                    <cfif money is not '#session_base.money#'>
                                                                        (#TLFormat(price_kdv)# #money#)
                                                                    </cfif>
                                                                </td>
                                                            </tr>
                                                        </cfif>
                                                        <tr>
                                                            <td><cf_get_lang no='1197.indirimli'></td>
                                                            <td class="prodfiyat" nowrap>:
                                                                <cfif len(prom_discount)>
                                                                    <cfquery name="GET_MONEY_INFO" datasource="#DSN2#">
                                                                        SELECT 
                                                                            (RATE2/RATE1) RATE
                                                                        FROM 
                                                                            SETUP_MONEY
                                                                        WHERE
                                                                            MONEY = <cfqueryparam cfsqltype="cf_sql_varchar" value="#money#">
                                                                    </cfquery>
                                                                    <cfset kur_price = (price_kdv*get_money_info.rate)>
                                                                    <cfset indirim_tutar_ = (kur_price*prom_discount/100)>									
                                                                    #TLFormat(kur_price-indirim_tutar_)# #session_base.money# -<cf_get_lang no ='1198.Avantajınız'>  : #tlformat(indirim_tutar_)# #session_base.money# (%#prom_discount#)
                                                                </cfif>
                                                            </td>
                                                        </tr>
                                                        <cfif (isdefined('session.ww.userid') or isdefined('session.pp.userid')) and attributes.is_price_member neq 2>
                                                            <tr>
                                                                <td nowrap class="prodprice"><cf_get_lang no='1199.Size Özel'></td>
                                                                <td class="prodFiyat">:
                                                                    <b>
                                                                    <cfif GET_PRO.recordcount>									
                                                                        #TLFormat((musteri_flt_other_money_value_with_prom + (musteri_flt_other_money_value_with_prom * tax/100))*get_money_info.rate)# #session_base.money#
                                                                        <cfif isdefined("attributes.is_kdv_alert") and attributes.is_kdv_alert eq 1>+ <cf_get_lang_main no='227.KDV'></cfif>
                                                                    <cfelse>
                                                                        #TLFormat((musteri_flt_other_money_value + (musteri_flt_other_money_value * tax/100))*get_money_info.RATE)# #session_base.money# <cfif isdefined("attributes.is_kdv_alert") and attributes.is_kdv_alert eq 1>+ <cf_get_lang_main no='227.KDV'></cfif>
                                                                    </cfif>
                                                                    </b>
                                                                </td>
                                                            </tr>
                                                        </cfif>
                                                    </cfif><!--- fiyat yoksa buraya girmez --->
                                                </cfif>
                                                <cfif attributes.is_price_view eq 1 and isdefined("attributes.list_price_discount_rate") and len(attributes.list_price_discount_rate)>
                                                    <cfquery name="GET_MONEY_INFO" datasource="#DSN2#">
                                                        SELECT
                                                            (RATE2/RATE1) RATE
                                                        FROM 
                                                            SETUP_MONEY
                                                        WHERE
                                                            MONEY = <cfqueryparam cfsqltype="cf_sql_varchar" value="#musteri_row_money#">
                                                    </cfquery>
                                                    <tr>
                                                        <td><cf_get_lang no='384.Havale'></td>
                                                        <td class="prodFiyat">:
                                                            <font color="red">
                                                            <cfif not isdefined("indirim_tutar_")>
                                                                <cfset indirim_tutar_ = 0>
                                                            </cfif>
                                                            <cfif attributes.is_price_member eq 0>
                                                                <cfset indirimli_ozel_fiyat = musteri_flt_other_money_value_kdv *get_money_info.rate>
                                                            <cfelse>
                                                                <cfset indirimli_ozel_fiyat = musteri_flt_other_money_value *get_money_info.rate>
                                                            </cfif>
                                                            <cfset indirimli_ozel_fiyat = indirimli_ozel_fiyat - indirim_tutar_>
                                                            #tlformat(indirimli_ozel_fiyat - (indirimli_ozel_fiyat * attributes.list_price_discount_rate/100))# <cfif isdefined("session.ww")>#session.ww.money#<cfelse>#session.pp.money#</cfif> (% #attributes.list_price_discount_rate# İndirimli)
                                                            </font>
                                                        </td>
                                                    </tr>
                                                </cfif>
                                                <cfif isdefined("attributes.is_show_point") and attributes.is_show_point eq 1>
                                                    <tr>
                                                        <td><cf_get_lang_main no='1572.Puan'></td>
                                                        <td>
                                                            <cfif len(segment_id)>
                                                                #get_segments.PRODUCT_SEGMENT[listfind(main_segment_list,segment_id)]#
                                                            </cfif>
                                                        </td>
                                                    </tr>
                                                </cfif>					  
                                            </table>
                                        </td>
                                        <td style="width:110px;">
                                            <cfif (attributes.is_basket eq 1) or (attributes.is_basket eq 2 and isdefined('session_base.userid'))>
                                                <cfif not isdefined('attributes.is_basket_standart') or attributes.is_basket_standart eq 1>
                                                    <cfif not get_pro.recordcount and (is_zero_stock eq 1 or (is_zero_stock neq 1 and usable_stock_amount2 gt 0) or (isdefined("attributes.is_stock_kontrol") and attributes.is_stock_kontrol eq 0)) and musteri_flt_other_money_value gt 0>
                                                        <table cellpadding="1" cellspacing="1" align="center" style="width:100px;">
                                                            <tr>
                                                                <td align="center" style="border:1px solid cccccc; background-color:##FBFBFB;">
                                                                    <br/><span class="txtbold"><cf_get_lang_main no='223.Miktar'></span><br/>
                                                                    <input type="text" name="miktar_#currentrow#_#i#" id="miktar_#currentrow#_#i#" value="1" maxlength="8" style="width:40px;" class="moneybox" onkeyup="return FormatCurrency(isNumber(this,event),#fusebox.Format_Currency#);">
                                                                    <br/><br/>
                                                                </td>
                                                            </tr>
                                                            <tr>
                                                                <td>
                                                                   <a href="javascript://" onclick="urun_gonder('#currentrow#','#i#','0');<!---return PROCTest()--->" class="prod_sepet" title="<cf_get_lang_main no='1376.Sepete At'>"></a>
                                                                </td>
                                                            </tr>
                                                        </table>
                                                    <cfelseif get_pro.recordcount and (is_zero_stock eq 1 or (is_zero_stock neq 1 and usable_stock_amount2 gt 0)) and musteri_flt_other_money_value_with_prom gt 0>
                                                        <table cellpadding="1" cellspacing="1" align="center" style="width:100px;">
                                                            <tr>
                                                                <td align="center" style="border:1px solid cccccc; background-color:##FBFBFB;">
                                                                    <br/><span class="txtbold"><cf_get_lang_main no='223.Miktar'></span><br/>
                                                                    <input type="text" name="miktar_#currentrow#_#i#" id="miktar_#currentrow#_#i#" value="1" maxlength="8" style="width:40px;" class="moneybox" onkeyup="return FormatCurrency(isNumber(this,event),#fusebox.Format_Currency#);">
                                                                    <br/><br/>
                                                                </td>
                                                            </tr>
                                                            <tr>
                                                                <td><a href="javascript://" onclick="urun_gonder('#currentrow#','#i#','0');<!---return PROCTest()--->" class="prod_sepet" title="<cf_get_lang_main no='1376.Sepete At'>"></a></td>
                                                            </tr>
                                                        </table>
                                                    <cfelse>
                                                        <span class="table_warning"><cf_get_lang no ='409.STOKTA YOK'></span>
                                                    </cfif>
                                                <cfelse>
                                                    <input type="text" name="miktar_#currentrow#_#i#" id="miktar_#currentrow#_#i#" maxlength="8" value="1" style="width:40px;" class="moneybox" onkeyup="return FormatCurrency(this,event,#fusebox.Format_Currency #);">
                                                    <cfif get_pro.recordcount and len(get_pro.prom_point)>
                                                        <br/><br/>
                                                        <input type="hidden" name="puan_product_id_#currentrow#_#i#" id="puan_product_id_#currentrow#_#i#" value="#product_id#">
                                                        <input type="hidden" name="puan_stock_id_#currentrow#_#i#" id="puan_stock_id_#currentrow#_#i#" value="#stock_id#">
                                                        <input type="hidden" name="puan_prom_point_#currentrow#_#i#" id="puan_prom_point_#currentrow#_#i#" value="#get_pro.prom_point#">
                                                        <input type="hidden" name="puan_prom_id_#currentrow#_#i#" id="puan_prom_id_#currentrow#_#i#" value="#get_pro.prom_id#">
                                                        <input type="hidden" name="puan_price_catid_#currentrow#_#i#" id="puan_price_catid_#currentrow#_#i#" value="#attributes.price_catid#">
                                                        <input type="hidden" name="puan_product_name_#currentrow#_#i#" id="puan_product_name_#currentrow#_#i#" value="#product_name#<cfif property is '-'><cfelseif len(property) gt 1> #property#</cfif>">
                                                        <a href="##" onclick="puan_urun_gonder('#currentrow#','#i#');<!---return PROCTest()--->" class="headersepet" title="<cf_get_lang_main no='1376.Sepete At'>"></a>
                                                    </cfif>
                                                </cfif>
                                                <cfif (isdefined("session.ww.userid") or isdefined("session.pp.userid")) and attributes.is_demand eq 1>
                                                    <br/><br/>
                                                    <cfif attributes.is_price eq 1><a href="javascript://" onclick="windowopen('#request.self#?fuseaction=objects2.popup_add_order_demand&stock_id=#stock_id#&price=#musteri_flt_other_money_value#&price_money=#musteri_row_money#&unit_id=#PRODUCT_UNIT_ID#&demand_type=1','small');"><img src="/images/uyar.gif" title="<cf_get_lang no ='1144.Fiyat Düşünce Haber Ver'>" border="0"></a></cfif>
                                                    <cfif ((attributes.is_stock_count eq 1) or (attributes.is_basket eq 1) or (attributes.is_basket eq 2 and isdefined('session_base.userid'))) and is_zero_stock neq 1 and isdefined("usable_stock_amount2") and usable_stock_amount2 lte 0 and attributes.is_price eq 1>
                                                        <a href="javascript://" onclick="windowopen('#request.self#?fuseaction=objects2.popup_add_order_demand&stock_id=#stock_id#&price=#musteri_flt_other_money_value#&price_money=#musteri_row_money#&unit_id=#PRODUCT_UNIT_ID#&demand_type=2','small');"><img src="/images/ship.gif" title="<cf_get_lang no ='1145.Stoklara Gelince Haber Ver'>" border="0"></a>
                                                        <a href="javascript://" onclick="windowopen('#request.self#?fuseaction=objects2.popup_add_order_demand&stock_id=#stock_id#&price=#musteri_flt_other_money_value#&price_money=#musteri_row_money#&unit_id=#PRODUCT_UNIT_ID#&demand_type=3','small');"><img src="/images/target_customer.gif" title="<cf_get_lang no ='1146.Ön Sipariş/ Rezerve'>" border="0"></a>
                                                    </cfif>
                                                </cfif>
                                            </cfif>
                                        </td>
                                    </tr>
                             	</table><!--- dis tablo bitiyor --->
                     		</td>
                 		</tr>
                    </cfloop>
                </cfif>
			</cfif>
	  	</cfoutput>
	<cfelse>
		<tr class="color-row" style="height:20px;">
			<td colspan="10"><cf_get_lang no='273.Bu Kategoriye Ait Ürün Bulunamadı'>!</td>
		</tr>
	</cfif>
</table>
