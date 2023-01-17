<cf_get_lang_set module_name="objects">
<cf_xml_page_edit fuseact="objects.popup_add_product_return">
<cfparam name="attributes.company_id" default="">
<cfparam name="attributes.stock_id" default="">
<cfparam name="attributes.product_id" default="">
<cfparam name="attributes.product_name" default="">
<cfparam name="attributes.consumer_id" default="">
<cfparam name="attributes.comp_name" default="">
<cfparam name="attributes.invoice_no" default="">
<cfquery name="GET_PERIOD" datasource="#DSN#">
	SELECT PERIOD_YEAR, PERIOD_ID FROM SETUP_PERIOD WHERE OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#"> ORDER BY PERIOD_YEAR
</cfquery>	
<cfif ((len(attributes.company_id) or len(attributes.consumer_id)) and len(attributes.comp_name)) or (len(attributes.stock_id) and len(attributes.product_name)) or (len(attributes.invoice_no))>
	<cfset my_source = '#dsn#_#invoice_year#_#session.ep.company_id#'>
	<cfquery name="GET_HIERARCHIES" datasource="#DSN#">
		SELECT
			DISTINCT
			SZ_HIERARCHY
		FROM
			SALES_ZONES_ALL_1
		WHERE
			POSITION_CODE = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.position_code#">
	</cfquery>
	<cfset row_block = 500>
	<!---XML de en Fazla Kac Kampanya oncesine Iade Girilebilsin? secenegi varsa kampanya kontrolleri yapiliyor --->
	<cfif len(camp_count)>
		<cfquery name="GET_CAMP_DATE" datasource="#DSN3#" maxrows="1"><!--- icinde bulunulan kampanya --->
			SELECT 
				CAMP_ID,
				CAMP_STARTDATE
			FROM 
				CAMPAIGNS 
			WHERE 
				CAMP_STARTDATE < #now()# AND
				CAMP_FINISHDATE > #now()#
		</cfquery>
		<cfif get_camp_date.recordcount>
			<!--- BK 20100809 kampanya baslangic tarihi bir gün geriye cekildi. --->
			<cfquery name="GET_FIRST_CAMP_" datasource="#DSN3#" maxrows="#camp_count#">
				SELECT DATEADD(DAY,-1,CAMP_STARTDATE) CAMP_STARTDATE,CAMP_FINISHDATE,CAMP_ID FROM CAMPAIGNS WHERE CAMP_STARTDATE <= #createodbcdatetime(get_camp_date.camp_startdate)# ORDER BY CAMP_FINISHDATE DESC
			</cfquery>
			<cfquery name="GET_MIN_CAMP_" dbtype="query" maxrows="1">
				SELECT CAMP_ID,CAMP_STARTDATE,CAMP_FINISHDATE FROM GET_FIRST_CAMP_ ORDER BY CAMP_FINISHDATE
			</cfquery>
		</cfif>
	</cfif>
	<cfquery name="GET_SEARCH_RESULTS_" datasource="#my_source#">
		<cfif not(isdefined('attributes.company_id') and len(attributes.company_id))>
			SELECT
				INVOICE_ROW.STOCK_ID,
				INVOICE_ROW.PRODUCT_ID,
				INVOICE.INVOICE_NUMBER,
				INVOICE_ROW.INVOICE_ROW_ID,
				INVOICE_ROW.PRICE,
				INVOICE_ROW.TAX,
				INVOICE_ROW.AMOUNT,
				INVOICE.INVOICE_DATE,
				INVOICE.INVOICE_ID
			FROM
				INVOICE,
				INVOICE_ROW,
				#dsn_alias#.CONSUMER C
			WHERE
				INVOICE.INVOICE_ID = INVOICE_ROW.INVOICE_ID AND
				INVOICE.PURCHASE_SALES = 1 AND
				INVOICE.CONSUMER_ID = C.CONSUMER_ID AND
				INVOICE.IS_IPTAL = 0 AND
				INVOICE.INVOICE_CAT NOT IN (55,56)	<!--- Demirbaslar haric --->
				<cfif isdefined('attributes.invoice_no') and len(attributes.invoice_no)>AND INVOICE.INVOICE_NUMBER = '#attributes.invoice_no#'</cfif>	
				<cfif isdefined('attributes.consumer_id') and len(attributes.consumer_id)>AND C.CONSUMER_ID = #attributes.consumer_id#</cfif>	
				<cfif isdefined('attributes.stock_id') and len(attributes.stock_id) and isdefined('attributes.stock_id') and len(attributes.stock_id)>
					AND INVOICE_ROW.STOCK_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.stock_id#">
				</cfif>	
				<cfif isdefined("is_inventory") and is_inventory eq 1>
					AND INVOICE_ROW.PRODUCT_ID IN(SELECT P.PRODUCT_ID FROM #dsn3_alias#.PRODUCT P WHERE P.PRODUCT_ID = INVOICE_ROW.PRODUCT_ID AND (P.IS_INVENTORY = 1 OR P.IS_KARMA = 1))
				</cfif>
				<cfif session.ep.our_company_info.sales_zone_followup eq 1>
					<!--- Satis Takimda Ekip Lideri veya Satıs Takiminda Ekipde ise ilgili IMS ler--->
					AND 
					(
						C.IMS_CODE_ID IN (
											SELECT
												IMS_ID
											FROM
												#dsn_alias#.SALES_ZONES_ALL_2
											WHERE
												POSITION_CODE = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.position_code#">
										 )
					<!--- Satis bolgeleri ekibinde veya Satis bolgesinde yonetici ise kendisi ve altindaki IMS ler--->			
					<cfif get_hierarchies.recordcount>
						OR C.IMS_CODE_ID IN (
											SELECT
												IMS_ID
											FROM
												#dsn_alias#.SALES_ZONES_ALL_1
											WHERE											
												<cfloop index="page_stock" from="0" to="#(ceiling(get_hierarchies.recordcount/row_block))-1#">
													<cfset start_row=(page_stock*row_block)+1>	
													<cfset end_row=start_row+(row_block-1)>
													<cfif (end_row) gte get_hierarchies.recordcount>
														<cfset end_row=get_hierarchies.recordcount>
													</cfif>
														(
														<cfloop index="add_stock" from="#start_row#" to="#end_row#">
															<cfif (add_stock mod row_block) neq 1> OR</cfif> SZ_HIERARCHY+'.' LIKE '#get_hierarchies.sz_hierarchy[add_stock]#%'
														</cfloop>
														
														)<cfif (ceiling(get_hierarchies.recordcount/row_block))-1 neq page_stock> OR</cfif>													
												</cfloop>											
										)
					  </cfif>
					 )
				</cfif>
				<cfif len(camp_count) and get_camp_date.recordcount and get_min_camp_.recordcount>
					AND INVOICE.INVOICE_DATE > #createodbcdatetime(get_min_camp_.camp_startdate)#
				</cfif>
		</cfif>
		<cfif not(isdefined('attributes.consumer_id') and len(attributes.consumer_id)) and not(isdefined('attributes.company_id') and len(attributes.company_id))>
			UNION ALL
		</cfif>
		<cfif not(isdefined('attributes.consumer_id') and len(attributes.consumer_id))>
			SELECT
				INVOICE_ROW.STOCK_ID,
				INVOICE_ROW.PRODUCT_ID,
				INVOICE.INVOICE_NUMBER,
				INVOICE_ROW.INVOICE_ROW_ID,
				INVOICE_ROW.PRICE,		
				INVOICE_ROW.TAX,
				INVOICE_ROW.AMOUNT,				
				INVOICE.INVOICE_DATE,
				INVOICE.INVOICE_ID
			FROM
				INVOICE,
				INVOICE_ROW,
				#dsn_alias#.COMPANY C
			WHERE
				INVOICE.INVOICE_ID = INVOICE_ROW.INVOICE_ID AND
				INVOICE.PURCHASE_SALES = 1 AND
				INVOICE.COMPANY_ID = C.COMPANY_ID AND
				INVOICE.IS_IPTAL = 0 AND
				INVOICE.INVOICE_CAT NOT IN (55,56)	<!--- Demirbaslar haric --->
				<cfif isdefined('attributes.invoice_no') and len(attributes.invoice_no)> AND INVOICE.INVOICE_NUMBER = '#attributes.invoice_no#'</cfif>	
				<cfif isdefined('attributes.company_id') and len(attributes.company_id)>AND C.COMPANY_ID = #attributes.company_id#</cfif>	
				<cfif isdefined('attributes.stock_id') and len(attributes.stock_id) and isdefined('attributes.stock_id') and len(attributes.stock_id)>
					AND INVOICE_ROW.STOCK_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.stock_id#">
				</cfif>	
				<cfif isdefined("is_inventory") and is_inventory eq 1>
					AND INVOICE_ROW.PRODUCT_ID IN(SELECT P.PRODUCT_ID FROM #dsn3_alias#.PRODUCT P WHERE P.PRODUCT_ID = INVOICE_ROW.PRODUCT_ID AND P.IS_INVENTORY=1)
				</cfif>
				<cfif session.ep.our_company_info.sales_zone_followup eq 1>
					<!--- Satis Takimda Ekip Lideri veya Satıs Takiminda Ekipde ise ilgili IMS ler--->
					AND 
					(
						C.IMS_CODE_ID IN (
											SELECT
												IMS_ID
											FROM
												#dsn_alias#.SALES_ZONES_ALL_2
											WHERE
												POSITION_CODE = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.position_code#">
										 )
					<!--- Satis bolgeleri ekibinde veya Satis bolgesinde yonetici ise kendisi ve altindaki IMS ler--->			
					<cfif get_hierarchies.recordcount>
						OR C.IMS_CODE_ID IN (
											SELECT
												IMS_ID
											FROM
												#dsn_alias#.SALES_ZONES_ALL_1
											WHERE											
												<cfloop index="page_stock" from="0" to="#(ceiling(get_hierarchies.recordcount/row_block))-1#">
													<cfset start_row=(page_stock*row_block)+1>	
													<cfset end_row=start_row+(row_block-1)>
													<cfif (end_row) gte get_hierarchies.recordcount>
														<cfset end_row=get_hierarchies.recordcount>
													</cfif>
														(
														<cfloop index="add_stock" from="#start_row#" to="#end_row#">
															<cfif (add_stock mod row_block) neq 1> OR</cfif> SZ_HIERARCHY+'.' LIKE '#get_hierarchies.sz_hierarchy[add_stock]#%'
														</cfloop>
														
														)<cfif (ceiling(get_hierarchies.recordcount/row_block))-1 neq page_stock> OR</cfif>													
												</cfloop>											
										)
					  </cfif>
					 )
				</cfif>
				<cfif len(camp_count) and get_camp_date.recordcount and get_min_camp_.recordcount>
					AND INVOICE.INVOICE_DATE > #createodbcdatetime(get_min_camp_.camp_startdate)#
				</cfif>
			</cfif>
		ORDER BY
			INVOICE.INVOICE_DATE DESC
	</cfquery>

	<cfif get_search_results_.recordcount>
		<cfquery name="GET_PERIOD_ID" dbtype="query">
			SELECT PERIOD_ID FROM GET_PERIOD WHERE PERIOD_YEAR = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.invoice_year#">
		</cfquery>
		<cfquery name="GET_INVOICE_" datasource="#my_source#">
			SELECT COMPANY_ID, PARTNER_ID, CONSUMER_ID FROM INVOICE WHERE INVOICE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_search_results_.invoice_id#">
		</cfquery>
		<cfquery name="GET_KABUL_ALL" datasource="#DSN3#">
			SELECT 
				SPRR.STOCK_ID,
				SPRR.INVOICE_ROW_ID,
				SPRR.AMOUNT
			FROM
				SERVICE_PROD_RETURN SPR,
				SERVICE_PROD_RETURN_ROWS SPRR
			WHERE 
				SPR.RETURN_ID = SPRR.RETURN_ID AND
				SPRR.INVOICE_ROW_ID IN(#valuelist(get_search_results_.invoice_row_id)#) AND
				SPR.PERIOD_ID = #get_period_id.period_id#				
			<cfif is_return_control eq 1>
				AND SPRR.RETURN_ACT_TYPE = 1
			</cfif>				
		</cfquery>
		<cfquery name="GET_PRODUCT_NAME2" datasource="#DSN3#">
			SELECT 
                PRODUCT_NAME,
                PRODUCT_ID,
                STOCK_ID,
                BARCOD,
                STOCK_CODE_2,
                STOCK_CODE 
			FROM 
            	STOCKS
            WHERE
            	STOCK_ID IN (#listdeleteduplicates(ValueList(get_search_results_.stock_id,','))#)
		</cfquery>
	</cfif>
</cfif>
<cfparam name="attributes.invoice_year" default="#session.ep.period_year#">
<cfquery name="GET_RETURN_CAT" datasource="#DSN3#">
	SELECT RETURN_CAT_ID, RETURN_CAT FROM SETUP_PROD_RETURN_CATS ORDER BY RETURN_CAT
</cfquery>
<cf_catalystHeader>
<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
<cf_box closable="0">
<cfform name="search_product_return" method="post" action="#request.self#?fuseaction=service.product_return&event=add">
	<cfoutput>
		<cf_box_search more="0">
			<div class="form-group">
				<cfsavecontent variable="message"><cf_get_lang dictionary_id='58133.Fatura No'></cfsavecontent>
				<cfinput type="text" name="invoice_no" value="#attributes.invoice_no#" placeholder="#message#" style="width:150px;">
			</div>
			<div class="form-group">
				<div class="input-group">
					<input type="hidden" name="company_id" id="company_id" value="#attributes.company_id#">
					<input type="hidden" name="consumer_id" id="consumer_id" value="#attributes.consumer_id#">
					<input type="text" placeholder="<cfoutput><cf_get_lang dictionary_id='57519.Cari Hesap'></cfoutput>" name="comp_name" id="comp_name" value="<cfif len(attributes.company_id) and len(attributes.comp_name)>#attributes.comp_name#<cfelseif len(attributes.consumer_id) and len(attributes.comp_name)>#attributes.comp_name#</cfif>" style="width:150px;">
					<span class="input-group-addon icon-ellipsis btnPointer" onclick="windowopen('#request.self#?fuseaction=objects.popup_list_pars&is_period_kontrol=0&select_list=2,3&field_comp_name=search_product_return.comp_name&field_comp_id=search_product_return.company_id&field_consumer=search_product_return.consumer_id&field_member_name=search_product_return.comp_name','list')"></span>
				</div>
			</div>
			<div class="form-group">
				<div class="input-group">
					<!---  <cf_wrk_products form_name = 'search_product_return' product_name='product_name' stock_id='stock_id' product_id='product_id'> --->
					<input type="hidden" name="stock_id" id="stock_id" value="#attributes.stock_id#">
					<input type="hidden" name="product_id" id="product_id" value="#attributes.product_id#">
					<input type="text" name="product_name" placeholder="<cfoutput><cf_get_lang dictionary_id='57657.Ürün'></cfoutput>" id="product_name" onfocus="AutoComplete_Create('product_name','PRODUCT_NAME','PRODUCT_NAME','get_product','0','PRODUCT_ID,STOCK_ID','product_id,stock_id','','3','200');" style="width:125px;" value="#attributes.product_name#" readonly="yes">
					<span class="input-group-addon icon-ellipsis btnPointer" onclick="windowopen('#request.self#?fuseaction=objects.popup_product_names&field_id=search_product_return.stock_id&product_id=search_product_return.product_id&field_name=search_product_return.product_name&keyword='+encodeURIComponent(document.search_product_return.product_name.value),'list');"></span>
				</div>
			</div>
			<div class="form-group">
				<select name="invoice_year" id="invoice_year" style="width:50px">
					<cfloop query="get_period">
						<option value="#period_year#" <cfif len(attributes.invoice_year) and (attributes.invoice_year eq period_year)>selected</cfif>>#period_year#</option>
					</cfloop>
				</select>
			</div>
			<div class="form-group">
				<cf_wrk_search_button button_type="4" search_function='page_control()'>
			</div>
			<div class="form-group">
				<cfset kontrol_camp = 1>
				<cfif isdefined("attributes.invoice_no") and len(attributes.invoice_no) and isdefined('get_search_results_') and get_search_results_.recordcount eq 0>
					<font color="FF0000"><cf_get_lang dictionary_id='33264.Kayıtlı Bir Fatura Yok'> !</font>			   
				<cfelseif isdefined("attributes.invoice_no") and len(attributes.invoice_no) and isdefined('get_search_results_') and len(camp_count) and get_camp_date.recordcount and get_min_camp_.recordcount>
					<cfif get_search_results_.invoice_date lt get_min_camp_.camp_startdate>
						<font color="FF0000"><cf_get_lang dictionary_id='58909.En Fazla'> #camp_count# <cf_get_lang dictionary_id='60208.Kampanya Öncesine Serviş İşlemi Girebilirsiniz'> !</font>
						<cfset kontrol_camp= 0>
					</cfif>
				</cfif>
			</div>
			
		</cf_box_search>
	</cfoutput>
</cfform>
<cfif ((len(attributes.company_id) or len(attributes.consumer_id)) and len(attributes.comp_name)) or (len(attributes.stock_id) and len(attributes.product_name)) or (len(attributes.invoice_no)) and (isdefined('get_search_results_') and get_search_results_.recordcount and kontrol_camp eq 1)>
		<cf_grid_list>
			<cfform name="add_return" method="post" action="#request.self#?fuseaction=objects.emptypopup_add_return" onsubmit="Unformatfields();">
				<thead>
					<tr>
						<cfset colspan_info = 6>
						<cfif (isdefined("is_accessories_info") and is_accessories_info eq 1) or not isdefined("is_accessories_info")>
							<cfset colspan_info = colspan_info + 1>
						</cfif>
						<cfif isdefined("is_return_type") and is_return_type eq 1>
							<cfset colspan_info = colspan_info + 1>
						</cfif>
						<cfif is_unit_price eq 1>
							<cfset colspan_info = colspan_info + 1>
						</cfif>	
						<th  colspan="<cfoutput>#colspan_info#</cfoutput>" height="22">
							<cfif len(attributes.comp_name) or len(attributes.invoice_no)>
								<b><cf_get_lang_main no='107.Cari Hesap'> :</b> 
								<cfoutput>
									<cfif isdefined('get_invoice_') and len(get_invoice_.partner_id)>
										#get_par_info(get_invoice_.partner_id,0,0,1)#
									<cfelseif isdefined('get_invoice_') and len(get_invoice_.consumer_id)>
										#get_cons_info(get_invoice_.consumer_id,0,1)#
								  </cfif>
								</cfoutput>
							</cfif>
						</th>
						<cfset colspan_info = 7>
						<cfif (isdefined("is_accessories_info") and is_accessories_info eq 1) or not isdefined("is_accessories_info")>
							<cfset colspan_info = colspan_info + 1>
						</cfif>
						<cfif isdefined("is_return_type") and is_return_type eq 1>
							<cfset colspan_info = colspan_info + 1>
						</cfif>
						<cfif is_unit_price eq 1>
							<cfset colspan_info = colspan_info + 1>
						</cfif>
						<th colspan="<cfoutput>#colspan_info#</cfoutput>">
							<cfif get_search_results_.recordcount>
								<select name="returncat" id="returncat" style="width:150px" onchange="change_all_returncat()">
									<option value="" selected><cf_get_lang dictionary_id='57734.Seçiniz'></option>
									<cfoutput query="get_return_cat">
										<option value="#return_cat_id#">#return_cat#</option>
									</cfoutput>	
								</select>
							</cfif>
						</th>
					</tr>
					<tr>
						<th width="30"><cf_get_lang dictionary_id='58577.Sıra'></th>
						<th>
							<cfif get_search_results_.recordcount>
							<input type="checkbox" name="hepsi" id="hepsi" value="1" onclick="check_all(this.checked);"></cfif>
						</th>
						<th><cf_get_lang dictionary_id='58221.urun adi'></th>
						<cfif is_product_code eq 1>
							<th><cf_get_lang dictionary_id='57633.Barkod'></th>
						</cfif>	
						<cfif is_stock_code eq 1>
							<th><cf_get_lang dictionary_id='57518.Stok Kodu'></th>
						</cfif>	
						<cfif is_special_code eq 1>
							<th><cf_get_lang dictionary_id='57789.Ozel kod'></th>
						</cfif>	            			
						<cfif is_unit_price eq 1>
							<th><cf_get_lang dictionary_id='57638.Birim Fiyat'></th>
						</cfif>
						<th><cf_get_lang dictionary_id='41860.Satılan'></th>
						<th><cf_get_lang dictionary_id='33266.Dönen'></th>
						<th><cf_get_lang dictionary_id='33267.İslem Miktarı'></th>
						<th><cf_get_lang dictionary_id='33268.Islem Nedeni'></th>
						<th><cf_get_lang dictionary_id='57629.Açıklama'></th>
						<th><cf_get_lang dictionary_id='33269.Ambalaj'></th>
						<cfif (isdefined("is_accessories_info") and is_accessories_info eq 1) or not isdefined("is_accessories_info")>
							<th><cf_get_lang dictionary_id='33270.Aksesuar'></th>
						</cfif>
						<cfif isdefined("is_return_type") and is_return_type eq 1>
							<th><cf_get_lang dictionary_id='57800.İşlem Tipi'></th>
						</cfif>
					</tr>
				</thead>
					<cfoutput>
						<input name="service_company_id" id="service_company_id" type="hidden" value="<cfif isdefined('get_invoice_')>#get_invoice_.company_id#</cfif>">
						<input name="service_partner_id" id="service_partner_id" type="hidden" value="<cfif isdefined('get_invoice_')>#get_invoice_.partner_id#</cfif>">
						<input name="service_employee_id" id="service_employee_id" type="hidden" value="">
						<input name="service_consumer_id" id="service_consumer_id" type="hidden" value="<cfif isdefined('get_invoice_')>#get_invoice_.consumer_id#</cfif>">
						<input name="period_id" id="period_id" type="hidden" value="<cfif isdefined('get_period_id')>#get_period_id.period_id#</cfif>">
						<input name="paper_no" id="paper_no" type="hidden" value="#attributes.invoice_no#">
						<input name="invoice_year" id="invoice_year" type="hidden" value="#attributes.invoice_year#">
						<input name="invoice_id" id="invoice_id" type="hidden" value="#get_search_results_.invoice_id#">
						<input name="invoice_row_list" id="invoice_row_list" type="hidden" value="#valuelist(get_search_results_.invoice_row_id)#">
						<input name="is_order_demand" id="is_order_demand" type="hidden" value="#is_order_demand#">	
						<input name="is_return_control" id="is_return_control" type="hidden" value="#is_return_control#">						
					</cfoutput>
					<tbody>
						<cfoutput query="get_search_results_">
							<cfif len(get_search_results_.stock_id)>
								<cfquery name="GET_KABUL" dbtype="query">
									SELECT SUM(AMOUNT) AS TOTAL_ FROM GET_KABUL_ALL WHERE STOCK_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_search_results_.stock_id#"> AND INVOICE_ROW_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_search_results_.invoice_row_id#">
								</cfquery>
							<cfelse>
								<cfset get_kabul.recordcount=0>
							</cfif>
							<cfif len(get_search_results_.product_id)>
								<cfquery name="GET_PRODUCT_NAME" dbtype="query">
									SELECT * FROM GET_PRODUCT_NAME2 WHERE STOCK_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_search_results_.stock_id#">
								</cfquery>
							</cfif>
							<tr>
								<input name="price#invoice_row_id#" id="price#invoice_row_id#" type="hidden" value="#price#">
								<input name="price_kdv#invoice_row_id#" id="price_kdv#invoice_row_id#" type="hidden" value="#price+(price*tax/100)#">
								<input name="stock_id#invoice_row_id#" id="stock_id#invoice_row_id#" type="hidden" value="#stock_id#">
								<input name="invoice_row_id#invoice_row_id#" id="invoice_row_id#invoice_row_id#" type="hidden" value="#get_search_results_.invoice_row_id#">
								<td>#currentrow#</td>
								<td><input type="checkbox" name="is_check#invoice_row_id#" id="is_check#invoice_row_id#" value="#invoice_row_id#"<cfif not len(stock_id)>disabled</cfif> onclick="check_row(this.checked,#invoice_row_id#);"></td>
								<td width="340"><cfif len(get_search_results_.product_id)>#get_product_name.product_name#<cfelse>---</cfif> (#invoice_number#)</td>
								<cfif is_product_code eq 1>
									<td style="text-align:right;"><cfif len(get_search_results_.product_id)>#get_product_name.barcod#</cfif></td>
								</cfif>	
								<cfif is_stock_code eq 1>
									<td style="text-align:right;"><cfif len(get_search_results_.product_id)>#get_product_name.stock_code#</cfif></td>
								</cfif>	
								<cfif is_special_code eq 1>
									<td style="text-align:right;"><cfif len(get_search_results_.product_id)>#get_product_name.stock_code_2#</cfif></td>	
								</cfif>	            			
								<cfif is_unit_price eq 1><td style="text-align:right;">#tlformat(price)#</td></cfif>
								<td style="text-align:right;">#amount#<input type="hidden" name="invoice_amount#invoice_row_id#" id="invoice_amount#invoice_row_id#" value="#amount#"></td>
								<td style="text-align:right;"><cfif get_kabul.recordcount and len(get_kabul.total_)>#get_kabul.total_#<cfelse>0</cfif> 
								<input type="hidden" name="old_kabul#invoice_row_id#" id="old_kabul#invoice_row_id#" value="<cfif get_kabul.recordcount and len(get_kabul.total_)>#get_kabul.total_#<cfelse>0</cfif>" style="width:50px" readonly></td>
								<td><input type="text" class="moneybox" name="amount#invoice_row_id#" id="amount#invoice_row_id#" value="0" onkeyup="return(FormatCurrency(this,event,0));" style="width:70px"></td>
								<td nowrap>
									<select name="returncat#invoice_row_id#" id="returncat#invoice_row_id#" style="width:150px"><!---  BK kaldirildi. 20130702  onChange="open_return_cat(#invoice_row_id#);" --->
									<option value="" selected><cf_get_lang dictionary_id='57734.Seçiniz'></option>
										<cfloop query="get_return_cat">
											<option value="#return_cat_id#">#return_cat#</option>
										</cfloop>					
									</select>
								</td>
								<td><input type="text" style="width:120px;" name="detail#invoice_row_id#" id="detail#invoice_row_id#" value=""></td>
								<td>
									<select name="package#invoice_row_id#" id="package#invoice_row_id#" style="width:100px">
										<option value="0"><cf_get_lang dictionary_id='57734.Seçiniz'></option>
										<option value="1"><cf_get_lang dictionary_id='33271.Sağlam'></option>
										<option value="2"><cf_get_lang dictionary_id='33272.Hasarlı'></option>
									</select>
								</td>
								<cfif (isdefined("is_accessories_info") and is_accessories_info eq 1) or not isdefined("is_accessories_info")>
									<td>
										<select name="accessories#invoice_row_id#" id="accessories#invoice_row_id#" style="width:100px">
											<option value="0"><cf_get_lang dictionary_id='57734.Seçiniz'></option>
											<option value="1"><cf_get_lang dictionary_id='33273.Tam'></option>
											<option value="2"><cf_get_lang dictionary_id='33274.Eksik'>/<cf_get_lang dictionary_id='33272.Hasarlı'></option>
										</select>
									</td>
								</cfif>
								<cfif isdefined("is_return_type") and is_return_type eq 1>
									<td>
										<select name="return_act_type#invoice_row_id#" id="return_act_type#invoice_row_id#" style="width:70px;">
											<option value="1"><cf_get_lang dictionary_id='50335.İade'></option>
											<option value="2"><cf_get_lang dictionary_id='58016.Değişim'></option>
											<option value="3"><cf_get_lang dictionary_id='41700.Fazla Ürün'></option>
										</select>
									</td>
								</cfif>
							</tr>
						</cfoutput>
					</tbody>
					<cfif get_search_results_.recordcount>
						<tfoot>
							<tr>
								<cfset colspan_info = 12>
								<cfif (isdefined("is_accessories_info") and is_accessories_info eq 1) or not isdefined("is_accessories_info")>
									<cfset colspan_info = colspan_info + 1>
								</cfif>
								<cfif isdefined("is_return_type") and is_return_type eq 1>
									<cfset colspan_info = colspan_info + 1>
								</cfif>
								<cfif is_unit_price eq 1>
									<cfset colspan_info = colspan_info + 1>
								</cfif>
								<td style="text-align:right;" colspan="<cfoutput>#colspan_info#</cfoutput>">
									<cf_workcube_buttons add_function='kontrol()' type_format="1">
								</td>
							</tr>
						</tfoot>
					<cfelse>
						<tbody>
							<cfset colspan_info = 12>
							<cfif (isdefined("is_accessories_info") and is_accessories_info eq 1) or not isdefined("is_accessories_info")>
								<cfset colspan_info = colspan_info + 1>
							</cfif>
							<cfif isdefined("is_return_type") and is_return_type eq 1>
								<cfset colspan_info = colspan_info + 1>
							</cfif>
							<cfif is_unit_price eq 1>
								<cfset colspan_info = colspan_info + 1>
							</cfif>	
							<tr>
								<td colspan="<cfoutput>#colspan_info#</cfoutput>"><cf_get_lang dictionary_id='57484.Kayıt Yok'> !</td>
							</tr>
						</tbody>
					</cfif>
				</table>
			</cfform>
		</cf_grid_list>

<div id="check_proms" style="display:none;"></div><!--- silinmesin, ajax için kullanılıyor --->
</cfif>
</cf_box>
</div>
<script type="text/javascript">
if(document.getElementById('invoice_row_list')!= undefined)
	invoice_row_list = document.getElementById('invoice_row_list').value;
else
	invoice_row_list = '';
	
function page_control()
{
	if(document.search_product_return.comp_name.value == '' && document.search_product_return.product_name.value == '' && document.search_product_return.invoice_no.value == '')
	{
		alert("<cf_get_lang dictionary_id='34067.En az Bir Adet Arama Kriteri Girmelisiniz'> !");
		return false;
	}
	return true;
}
	
<cfif ((len(attributes.company_id) or len(attributes.consumer_id)) and len(attributes.comp_name)) or (len(attributes.stock_id) and len(attributes.product_name)) or (len(attributes.invoice_no)) and (isdefined('get_search_results_') and get_search_results_.recordcount)>
	function check_all(deger)
	{
		<cfif get_search_results_.recordcount>
			if(document.getElementById('hepsi').checked)
			{
				for(i=1;i<=<cfoutput>#listlen(valuelist(get_search_results_.invoice_row_id))#</cfoutput>;++i)
				{
					selected_row_id = list_getat(invoice_row_list,i,',');
					document.getElementById('is_check'+selected_row_id).checked = true;
					document.getElementById('amount'+selected_row_id).value = parseFloat(document.getElementById('invoice_amount'+selected_row_id).value)-parseFloat(document.getElementById('old_kabul' + selected_row_id).value);
				}
			}
			else
			{
				for(i=1;i<=<cfoutput>#listlen(valuelist(get_search_results_.invoice_row_id))#</cfoutput>;++i)
				{
					selected_row_id = list_getat(invoice_row_list,i,',');
					document.getElementById('is_check' + selected_row_id).checked = false;
					document.getElementById('amount'+selected_row_id).value = 0;
				}
			}
		</cfif>
	}
	function check_row(deger,row_id)
	{
		if(deger)
		{
			eval("document.add_return.is_check" + row_id).checked = true;
			eval("document.add_return.amount" + row_id).value = parseFloat(eval("document.add_return.invoice_amount" + row_id).value-eval("document.add_return.old_kabul" + row_id).value);
		}
		else
		{
			eval("document.add_return.is_check" + row_id).checked = false;
			eval("document.add_return.amount" + row_id).value = 0;
		}
	}
	function kontrol()
	{
		var send_prom_url='';
		kontrol_ = 0;
		for(i=1;i<=<cfoutput>#listlen(valuelist(get_search_results_.invoice_row_id))#</cfoutput>;++i)
		{
			selected_row_id = list_getat(invoice_row_list,i,',');
			if(document.getElementById('is_check'+selected_row_id).checked == true)
			{
				kontrol_ = 1;
				if(document.getElementById('amount'+selected_row_id).value <= 0)
				{
					alert(i+". <cf_get_lang dictionary_id='33276.Satır İçin İşlem Miktarı Girmelisiniz'>!");
					return false;
				}
				
				if(document.getElementById('returncat'+selected_row_id).value == '')
				{
					alert(i+"<cf_get_lang dictionary_id='60209.Satır İçin İşlem Nedeni Seçmelisiniz'>!");
					return false;
				}	


				cikan_ = parseInt(document.getElementById('invoice_amount'+selected_row_id).value);
				kabul_ = parseInt(document.getElementById('old_kabul'+selected_row_id).value);
				kont_ = cikan_ - kabul_;
				
				if(kont_ < document.getElementById('amount'+selected_row_id).value)
				{
					alert(i+". <cf_get_lang dictionary_id='33277.Satır İçin Çıkan Üründen Fazla İade Alamazsınız'>!");
					return false;
				}	
										
				<cfif isdefined('is_check_promotions') and is_check_promotions eq 1><!--- detayli promosyon kontrolu icin iade edilen stocklar aliniyor --->
					if(send_prom_url=='')
						send_prom_url= document.getElementById('stock_id'+selected_row_id).value;
					else
						send_prom_url=send_prom_url+','+document.getElementById('stock_id'+selected_row_id).value;
				</cfif>				
			}
		}
		if(kontrol_ == 0)
		{
			alert("<cf_get_lang dictionary_id='33275.Ürün Servis İşlemi Yapmadınız'>!");
			return false;
		}
		
		<cfif isdefined('is_check_promotions') and is_check_promotions eq 1><!--- detaylı promosyon kontrolu yapılıyor --->
			AjaxPageLoad('<cfoutput>#request.self#?fuseaction=objects2.emptypopup_ajax_check_paper_promotion_products</cfoutput>&stock_list='+send_prom_url+'&invoice_id='+add_return.invoice_id.value+'','check_proms',1);
		</cfif>
	}
	function Unformatfields()
	{
		<cfoutput query="get_search_results_">
			document.add_return.amount#invoice_row_id#.value = filterNum(document.add_return.amount#invoice_row_id#.value);
		</cfoutput>
		return true;
	}
	
	function change_all_returncat()
	{
		for(i=1;i<=<cfoutput>#listlen(valuelist(get_search_results_.invoice_row_id))#</cfoutput>;++i)
		{
			selected_row_id = list_getat(invoice_row_list,i,',');
			document.getElementById('returncat'+selected_row_id).value = document.getElementById('returncat').value;
		}
	}
</cfif>
</script>
<cf_get_lang_set module_name="#lcase(listgetat(attributes.fuseaction,1,'.'))#">