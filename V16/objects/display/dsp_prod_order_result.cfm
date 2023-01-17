<cfquery name="GET_DETAIL" datasource="#DSN3#">
	SELECT 
		PRODUCTION_ORDERS.P_ORDER_NO,
		PRODUCTION_ORDERS.ORDER_ID,
		PRODUCTION_ORDERS.IS_DEMONTAJ,
		PRODUCTION_ORDERS.QUANTITY AS AMOUNT,
		PRODUCTION_ORDER_RESULTS.*
	FROM
		PRODUCTION_ORDERS,
		PRODUCTION_ORDER_RESULTS
	WHERE
		<!--- PRODUCTION_ORDERS.P_ORDER_ID = #attributes.p_order_id# AND  --->
		PRODUCTION_ORDER_RESULTS.PR_ORDER_ID = #attributes.pr_order_id# AND
		PRODUCTION_ORDERS.P_ORDER_ID = PRODUCTION_ORDER_RESULTS.P_ORDER_ID
</cfquery>

<!--- <cfdump var="#GET_DETAIL#">
<cfabort> --->
<cfset new_dsn2 = '#dsn#_#year(GET_DETAIL.FINISH_DATE)#_#session.ep.company_id#'>
<cfquery name="GET_ROW_ENTER" datasource="#DSN3#">
	SELECT * FROM PRODUCTION_ORDER_RESULTS_ROW WHERE PR_ORDER_ID = #get_detail.pr_order_id# AND TYPE = 1
</cfquery>
<cfquery name="GET_ROW_EXIT" datasource="#DSN3#">
	SELECT * FROM PRODUCTION_ORDER_RESULTS_ROW WHERE PR_ORDER_ID = #get_detail.pr_order_id# AND TYPE = 2
</cfquery>
<cfquery name="GET_ROW_OUTAGE" datasource="#DSN3#">
	SELECT * FROM PRODUCTION_ORDER_RESULTS_ROW WHERE PR_ORDER_ID = #get_detail.pr_order_id# AND TYPE = 3
</cfquery>
<cfquery name="GET_STOK_FIS" datasource="#new_dsn2#">
	SELECT SHIP_NUMBER,SHIP_ID,SHIP_TYPE FROM SHIP WHERE PROD_ORDER_RESULT_NUMBER = #attributes.pr_order_id#
</cfquery>
<cfquery name="GET_CAT" datasource="#DSN3#">
	SELECT PROCESS_CAT_ID FROM SETUP_PROCESS_CAT WHERE PROCESS_TYPE =<cfif GET_DETAIL.IS_DEMONTAJ eq 1>119<cfelse>110</cfif><!--- uretimden giris fisi demontej veya uretimden giris fisi --->
</cfquery>
<cfquery name="GET_FIS" datasource="#new_dsn2#">
	SELECT FIS_NUMBER,FIS_TYPE,FIS_ID,FIS_DATE FROM STOCK_FIS WHERE PROD_ORDER_RESULT_NUMBER = #attributes.pr_order_id# AND PROCESS_CAT = #get_cat.PROCESS_CAT_ID#
</cfquery>
<cfquery name="GET_CAT_SARF" datasource="#DSN3#">
	SELECT PROCESS_CAT_ID FROM SETUP_PROCESS_CAT WHERE PROCESS_TYPE = 111
</cfquery>
<cfquery name="GET_FIS_SARF" datasource="#new_dsn2#">
	SELECT FIS_NUMBER,FIS_TYPE,FIS_ID,FIS_DATE FROM STOCK_FIS WHERE PROD_ORDER_RESULT_NUMBER = #attributes.pr_order_id# AND PROCESS_CAT = #GET_CAT_SARF.PROCESS_CAT_ID#
</cfquery>
<cfquery name="GET_CAT_AMBAR" datasource="#DSN3#">
	SELECT PROCESS_CAT_ID FROM SETUP_PROCESS_CAT WHERE PROCESS_TYPE = 113
</cfquery>
<cfquery name="GET_FIS_AMBAR" datasource="#new_dsn2#">
	SELECT FIS_NUMBER,FIS_TYPE,FIS_ID,FIS_DATE FROM STOCK_FIS WHERE PROD_ORDER_RESULT_NUMBER = #attributes.pr_order_id# AND PROCESS_CAT = #GET_CAT_AMBAR.PROCESS_CAT_ID#
</cfquery>
<cfquery name="GET_CAT_FIRE" datasource="#DSN3#">
	SELECT PROCESS_CAT_ID FROM SETUP_PROCESS_CAT WHERE PROCESS_TYPE = 112
</cfquery>
<cfquery name="GET_FIS_FIRE" datasource="#new_dsn2#">
	SELECT FIS_NUMBER,FIS_TYPE,FIS_ID,FIS_DATE FROM STOCK_FIS WHERE PROD_ORDER_RESULT_NUMBER = #attributes.pr_order_id# AND PROCESS_CAT = #GET_CAT_FIRE.PROCESS_CAT_ID#
</cfquery>

<table width="100%" border="0" cellspacing="0" cellpadding="0" height="100%" class="color-row">
	<tr class="color-list">
		<td class="headbold" height="35">&nbsp;&nbsp;<cf_get_lang dictionary_id='29651.Üretim Sonucu'>:<cfoutput>#get_detail.p_order_no#</cfoutput></td>
	</tr>
	<tr>
	<td valign="top">
		<table width="100%" border="0" cellspacing="1" cellpadding="2" height="100%" class="color-border">
		<cfform name="form_basket" method="post" action="#request.self#?fuseaction=prod.emptypopup_upd_prod_order_result_act">
			<tr class="color-row" valign="top">
				<td>
				<table>
					<tr>
						<td class="txtbold"><cf_get_lang dictionary_id="34057.Üretim Emir No"></td>
						<td width="100"><cfoutput>#get_detail.production_order_no#</cfoutput></td>
						<td class="txtbold"><cf_get_lang dictionary_id="58467.Başlama"></td>
						<td><cfoutput>#dateformat(get_detail.start_date,dateformat_style)#</cfoutput></td>
						<td class="txtbold"><cf_get_lang dictionary_id="36761.Sarf Depo"></td>
						<td>	
							<cfif len(get_detail.exit_dep_id)>
								<cfquery name="GET_EXIT_DEP" datasource="#DSN#">
									SELECT
										DEPARTMENT_HEAD
									FROM 
										DEPARTMENT
									WHERE
										DEPARTMENT_ID = #get_detail.exit_dep_id#
								</cfquery>
								<cfquery name="GET_EXIT_LOC" datasource="#DSN#">
									SELECT
										COMMENT
									FROM
										STOCKS_LOCATION
									WHERE
										LOCATION_ID = #get_detail.exit_loc_id# AND
										DEPARTMENT_ID = #get_detail.exit_dep_id#
								</cfquery>
								<cfoutput>#get_exit_dep.department_head# - #get_exit_loc.comment#</cfoutput>
							</cfif>
					</tr>
					<tr>
						<td class="txtbold"><cf_get_lang dictionary_id="58211.Sipariş No"></td>
						<td><cfoutput>#get_detail.order_no#</cfoutput></td>
						<td class="txtbold"><cf_get_lang dictionary_id="57502.Bitiş"></td>
						<td width="100"><cfoutput>#dateformat(get_detail.finish_date,dateformat_style)#</cfoutput>
						<td class="txtbold"><cf_get_lang dictionary_id="58834.İstasyon"></td>
						<td width="120">
							<cfif len(get_detail.station_id)>
								<cfquery name="GET_STATION" datasource="#dsn3#">
									SELECT 
										STATION_NAME 
									FROM 
										WORKSTATIONS 
									WHERE 
										STATION_ID = #get_detail.station_id#
								</cfquery>
								<cfoutput>#get_station.station_name#</cfoutput>
							</cfif>
						</td>
						<td class="txtbold"><cf_get_lang dictionary_id="33068.Üretim Depo"></td>
						<td>
							<cfif len(get_detail.production_dep_id)>
								<cfquery name="GET_PRODUCTION_DEP" datasource="#DSN#">
									SELECT
										DEPARTMENT_HEAD
									FROM 
										DEPARTMENT
									WHERE
										DEPARTMENT_ID = #get_detail.production_dep_id#
								</cfquery>
								<cfquery name="GET_PRODUCTION_LOC" datasource="#DSN#">
									SELECT
										COMMENT
									FROM
										STOCKS_LOCATION
									WHERE
										LOCATION_ID = #get_detail.production_loc_id# AND
										DEPARTMENT_ID = #get_detail.production_dep_id#
								</cfquery>
								<cfoutput>#get_production_dep.department_head# - #get_production_loc.comment#</cfoutput>
							</cfif>
						</td>
					</tr>
					<tr>
						<td class="txtbold"><cf_get_lang dictionary_id="34314.Sonuç No"></td>
						<td><cfoutput>#get_detail.result_no#</cfoutput></td>
						<td class="txtbold"><cf_get_lang dictionary_id="58794.Referans No"></td>
						<td><cfoutput>#get_detail.reference_no#</cfoutput></td>
						<td class="txtbold"><cf_get_lang dictionary_id="33054.Sevkiyat Depo"></td>
						<td>
							<cfif len(get_detail.enter_dep_id)>
								<cfquery name="GET_ENTER_DEP" datasource="#DSN#">
									SELECT
										DEPARTMENT_HEAD
									FROM 
										DEPARTMENT
									WHERE
										DEPARTMENT_ID = #get_detail.enter_dep_id#
								</cfquery>
								<cfquery name="GET_ENTER_LOC" datasource="#DSN#">
									SELECT
										COMMENT
									FROM
										STOCKS_LOCATION
									WHERE
										LOCATION_ID = #get_detail.enter_loc_id# AND
										DEPARTMENT_ID = #get_detail.enter_dep_id#							
								</cfquery>
								<cfoutput>#get_enter_dep.department_head# - #get_enter_loc.comment#</cfoutput>
							</cfif>
						</td>
					</tr>
					<tr>
						<td class="txtbold"><cf_get_lang dictionary_id="32916.Lot No"></td>
						<td><cfoutput>#get_detail.lot_no#</cfoutput></td>
					</tr>
					<tr></tr>
					<tr>						
						<td colspan="4" class="txtbold">
							<cf_get_lang dictionary_id='57483.Kayıt'> : <cfoutput>#get_emp_info(get_detail.record_emp,0,0)# - #dateformat(get_detail.record_date,dateformat_style)#</cfoutput><br/>
							<cfif len(get_detail.update_date)><cf_get_lang dictionary_id='57703.Güncelleme'> : <cfoutput>#get_emp_info(get_detail.update_emp,0,0)# - #dateformat(get_detail.update_date,dateformat_style)#</cfoutput></cfif>
						</td>
						<td colspan="6" align="center"><input type="Button" style="width:65px;" value="<cf_get_lang dictionary_id='57553.Kapat'>" onclick="window.close();"></td>
						</td>
					</tr> 
						<cfif get_fis.recordcount or get_fis_sarf.recordcount>
					<tr>
						<td colspan="8">
							<cfif get_fis.recordcount><cf_get_lang dictionary_id="29627.Üretimden Çıkış Fişi">: <cfoutput>#get_fis.fis_number#</cfoutput></cfif>
							<cf_get_lang dictionary_id='29628.Sarf Fişi'>: <cfoutput>#get_fis_sarf.fis_number#</cfoutput>
							<cfif get_fis_ambar.recordcount or GET_STOK_FIS.recordcount><cf_get_lang dictionary_id="33059.Depo Arası İrsaliye Ambar Fişi"> :<cfoutput>#get_fis_ambar.fis_number# #GET_STOK_FIS.ship_number# </cfoutput></cfif>
							<cfif GET_FIS_FIRE.RECORDCOUNT><cf_get_lang dictionary_id="29629.Fire Fişi">:<cfoutput>#GET_FIS_FIRE.fis_number#</cfoutput></cfif>
						</td>
					</tr>
						</cfif>
				</table>	
				</td>
			</tr>
			<tr class="color-row">
				<td valign="top" height="20" class="formbold"><cf_get_lang dictionary_id="29651.Üretim Sonucu"></td>
			</tr>
			<tr class="color-row">
				<td valign="top">
					<table>
						<tr class="txtboldblue">
							<td></td>
							<td class="color-list" width="110"><cf_get_lang dictionary_id='57633.Barkod'></td>
							<td class="color-list" width="150"><cf_get_lang dictionary_id='57452.Stok'></td>
							<td class="color-list" width="60"><cf_get_lang dictionary_id='57635.Miktar'></td>
							<cfif get_module_user(5)>
							<td  class="color-list" style="text-align:right;"><cf_get_lang dictionary_id="33064.Birim Maliyet"></td>
							<td width="50" class="color-list"><cf_get_lang dictionary_id='57489.Para Br'></td>
							</cfif>
							<td class="color-list" width="60"><cf_get_lang dictionary_id='57636.Birim'></td>
							<td class="color-list" width="20"><cf_get_lang dictionary_id='57647.spect'></td>
							<td class="color-list">&nbsp;</td>
							<td class="color-list">&nbsp;</td>
						</tr>
						<cfoutput query="get_row_enter">
							<cfquery name="GET_PRODUCT" datasource="#dsn1#">
							SELECT 
								PRODUCT.PRODUCT_NAME,
								PRODUCT.BARCOD,
								STOCKS.PRODUCT_UNIT_ID,
								PRODUCT_UNIT.ADD_UNIT,
								PRODUCT_UNIT.MAIN_UNIT,
								STOCKS.PROPERTY
							FROM 
								PRODUCT,
								STOCKS,
								PRODUCT_UNIT
							WHERE 
								PRODUCT.PRODUCT_ID = #product_id# AND
								STOCKS.PRODUCT_ID = PRODUCT.PRODUCT_ID AND
								STOCKS.STOCK_ID = #stock_id# AND
								PRODUCT_UNIT.PRODUCT_ID = PRODUCT.PRODUCT_ID AND
								PRODUCT_UNIT.PRODUCT_UNIT_STATUS = 1 AND
								PRODUCT_UNIT.PRODUCT_UNIT_ID = STOCKS.PRODUCT_UNIT_ID
							</cfquery>
						<tr>
							<td>
							</td>
							<td>#get_product.barcod#</td>
							<td>#get_product.product_name# #get_product.property#</td>
							<td>#TlFormat(amount,3)#</td>
							<cfif get_module_user(5)>
							<td>#TLFormat(PURCHASE_NET_SYSTEM)#</td>
							<td>#PURCHASE_NET_SYSTEM_MONEY#</td>
							<cfelse>
							<td></td>
							<td></td>
							</cfif>
							<td>#get_product.main_unit#</td>
							<td>
								<cfif len(spect_id)>
									<cfquery name="GET_SPECT" datasource="#dsn3#">
										SELECT SPECT_VAR_NAME,SPECT_MAIN_ID FROM SPECTS WHERE SPECT_VAR_ID = #spect_id#
									</cfquery>
									#spect_id# - #get_spect.spect_var_name# (main spec:#GET_SPECT.SPECT_MAIN_ID#)
								</cfif>
							</td>
							<td>
							</td>
							<td>
							</td>
						</tr>
						</cfoutput>
					</table>
				</td>
			</tr>
			<tr class="color-row">
				<td valign="top" height="20" class="formbold"><cf_get_lang dictionary_id="33066.Sarf"></td>
			</tr>
			<tr class="color-row">
				<td valign="top">	
					<table>
						<tr class="txtboldblue">
							<td><!--- <cfoutput>#get_row_exit.recordcount#</cfoutput> ---></td>
							<td width="110" class="color-list"><cf_get_lang dictionary_id='57633.Barkod'></td>
							<td width="150" class="color-list"><cf_get_lang dictionary_id='57452.Stok'></td>
							<td width="60" class="color-list"><cf_get_lang dictionary_id='57635.Miktar'></td>
							<cfif get_module_user(5)>
							<td width="120" class="color-list"><cf_get_lang dictionary_id="33064.Birim Maliyet"></td>
							<td width="50"  class="color-list" style="text-align:right;"><cf_get_lang dictionary_id='57489.Para Br'></td>
							</cfif>
							<td width="60" class="color-list"><cf_get_lang dictionary_id='57636.Birim'></td>
							<td class="color-list"><cf_get_lang dictionary_id='57647.spect'></td>
							<cfif GET_DETAIL.is_demontaj neq 1>
							<td width="20" class="color-list">SB</td>
							</cfif>
							<td></td>
						</tr>
					<cfoutput query="get_row_exit">
						<cfquery name="GET_PRODUCT" datasource="#DSN1#">
							SELECT 
								PRODUCT.PRODUCT_NAME,
								PRODUCT.BARCOD,
								STOCKS.PRODUCT_UNIT_ID,
								PRODUCT_UNIT.ADD_UNIT,
								PRODUCT_UNIT.MAIN_UNIT,
								STOCKS.PROPERTY
							FROM 
								PRODUCT,
								STOCKS,
								PRODUCT_UNIT
							WHERE 
								PRODUCT.PRODUCT_ID = #product_id# AND
								STOCKS.PRODUCT_ID = PRODUCT.PRODUCT_ID AND
								STOCKS.STOCK_ID = #stock_id# AND
								PRODUCT_UNIT.PRODUCT_ID = PRODUCT.PRODUCT_ID AND
								PRODUCT_UNIT.PRODUCT_UNIT_STATUS = 1 AND
								PRODUCT_UNIT.PRODUCT_UNIT_ID = STOCKS.PRODUCT_UNIT_ID
						</cfquery>
						<tr>
							<td>
							</td>
							<td>#get_product.barcod#</td>
							<td>#get_product.product_name# #get_product.property#</td>
							<td>#TlFormat(amount,3)#</td>
							<cfif get_module_user(5)>
							<td>#TLFormat(PURCHASE_NET)#</td>
							<td>#PURCHASE_NET_MONEY#</td>
							</cfif>
							<td>
							  #get_product.main_unit#
							</td>
							<td>
							<cfif len(get_row_exit.spect_id)>
								<cfquery name="GET_SPECT" datasource="#DSN3#">
									SELECT SPECT_VAR_NAME,SPECT_MAIN_ID FROM SPECTS WHERE SPECT_VAR_ID = #get_row_exit.spect_id#
								</cfquery>
								#get_row_exit.spect_id# - #get_spect.spect_var_name# (main spec:#GET_SPECT.SPECT_MAIN_ID#)
							</cfif>
							</td>
							<cfif GET_DETAIL.is_demontaj neq 1>
							<td><cfif get_row_exit.is_sevkiyat eq 1>SB</cfif></td>
							</cfif>
							<td><cfif GET_DETAIL.is_demontaj eq 1><cf_get_lang dictionary_id="33067.Demontaj"></cfif></td>
						</tr>
					</cfoutput>
					</table>
				</td>
			</tr>
		<tr class="color-list" height="25">
			<td valign="top" height="20" class="formbold"><cf_get_lang dictionary_id="29471.Fire"></td>
		</tr>
		<tr>
			<td class="color-row" valign="top">
				<table>
					<tr class="txtboldblue">
						<td></td>
						<td width="110" class="color-list"><cf_get_lang dictionary_id='57633.Barkod'></td>
						<td width="150" class="color-list"><cf_get_lang dictionary_id='57452.Stok'></td>
						<td width="60" class="color-list"><cf_get_lang dictionary_id='57635.Miktar'></td>
						<cfif get_module_user(5)>
						<td width="120"  class="color-list" style="text-align:right;"><cf_get_lang dictionary_id="33064.Birim Maliyet"></td>
						<td width="50" class="color-list"><cf_get_lang dictionary_id='57489.Para Br'></td>
						</cfif>
						<td width="60" class="color-list"><cf_get_lang dictionary_id='57636.Birim'></td>
						<td class="color-list"><cf_get_lang dictionary_id='57647.spect'></td>
					</tr>
				<cfoutput query="get_row_outage">
					<cfquery name="GET_PRODUCT" datasource="#DSN1#">
						SELECT 
							PRODUCT.PRODUCT_NAME,
							PRODUCT.BARCOD,
							STOCKS.PRODUCT_UNIT_ID,
							PRODUCT_UNIT.ADD_UNIT,
							PRODUCT_UNIT.MAIN_UNIT,
							STOCKS.PROPERTY
						FROM 
							PRODUCT,
							STOCKS,
							PRODUCT_UNIT
						WHERE 
							PRODUCT.PRODUCT_ID = #product_id# AND
							STOCKS.PRODUCT_ID = PRODUCT.PRODUCT_ID AND
							STOCKS.STOCK_ID = #stock_id# AND
							PRODUCT_UNIT.PRODUCT_ID = PRODUCT.PRODUCT_ID AND
							PRODUCT_UNIT.PRODUCT_UNIT_STATUS = 1 AND
							PRODUCT_UNIT.PRODUCT_UNIT_ID = STOCKS.PRODUCT_UNIT_ID
					</cfquery>
					<tr>
						<td></td>
						<td>#get_product.barcod#</td>
						<td>#get_product.product_name# #get_product.property#</td>
						<td>#TlFormat(amount,3)#</td>
						<cfif get_module_user(5)>
						<td>#TLFormat(PURCHASE_NET)#</td>
						<td>#PURCHASE_NET_MONEY#</td>
						</cfif>
						<td>#get_product.main_unit#</td>
						<td>
						<cfif len(get_row_outage.spect_id)>
							<cfquery name="GET_SPECT" datasource="#DSN3#">
								SELECT SPECT_VAR_NAME FROM SPECTS WHERE SPECT_VAR_ID = #get_row_outage.spect_id#
							</cfquery>
							#get_spect.spect_var_name#
						</cfif>
						</td>
					</tr>
				</cfoutput>
				</table>
			</td>
		</tr>
		</cfform>
	</table>
	</td>
	</tr>
</table>

