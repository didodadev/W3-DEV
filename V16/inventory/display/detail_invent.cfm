
<cf_xml_page_edit fuseact="invent.detail_invent">
<cfset toplam=0>
<cfparam name="attributes.old_value" default="0">
<cfquery name="GET_AMORTIZATION" datasource="#DSN3#">
	SELECT
		INVENTORY_AMORTIZATON.*,
		INVENTORY_AMORTIZATION_MAIN.*,
		INVENTORY.AMOUNT,
		INVENTORY.LAST_INVENTORY_VALUE
	FROM
		INVENTORY_AMORTIZATON,
		INVENTORY_AMORTIZATION_MAIN,
		INVENTORY
	WHERE
		INVENTORY_AMORTIZATON.INVENTORY_ID = INVENTORY.INVENTORY_ID AND
		INVENTORY_AMORTIZATON.INVENTORY_ID = #attributes.inventory_id# AND
		INVENTORY_AMORTIZATION_MAIN.INV_AMORT_MAIN_ID=INVENTORY_AMORTIZATON.INV_AMORT_MAIN_ID
	UNION 
	SELECT
		INVENTORY_AMORTIZATON.*,
		INVENTORY_AMORTIZATION_MAIN.*,
		INVENTORY.AMOUNT,
		INVENTORY.LAST_INVENTORY_VALUE
	FROM
		INVENTORY_AMORTIZATON_IFRS INVENTORY_AMORTIZATON,
		INVENTORY_AMORTIZATION_MAIN,
		INVENTORY
	WHERE
		INVENTORY_AMORTIZATON.INVENTORY_ID = INVENTORY.INVENTORY_ID AND
		INVENTORY_AMORTIZATON.INVENTORY_ID = #attributes.inventory_id# AND
		INVENTORY_AMORTIZATION_MAIN.INV_AMORT_MAIN_ID=INVENTORY_AMORTIZATON.INV_AMORT_MAIN_ID
	ORDER BY 
		INVENTORY_AMORTIZATION_MAIN.ACTION_DATE
</cfquery>
<cfquery name="get_inventory_history" datasource="#dsn3#">
	SELECT
		INVENTORY_HISTORY_ID,
		INVENTORY_ID,
		ACTION_TYPE,
		ACTION_ID,
		ACTION_DATE,
		EXPENSE_CENTER_ID,
		EXPENSE_ITEM_ID,
		CLAIM_ACCOUNT_CODE,
		DEBT_ACCOUNT_CODE,
		ACCOUNT_CODE,
		INVENTORY_DURATION,
		AMORTIZATION_RATE,
		PROJECT_ID,
		RECORD_EMP,
		RECORD_DATE
	FROM
		INVENTORY_HISTORY
	WHERE
		INVENTORY_ID = #attributes.inventory_id#
	ORDER BY 
		ACTION_DATE DESC,
		INVENTORY_HISTORY_ID DESC
</cfquery>
<cfquery name="get_invoice" datasource="#dsn2#">
	SELECT * FROM INVOICE_ROW WHERE INVENTORY_ID = #attributes.inventory_id#
</cfquery>
<cfquery name="get_periods" datasource="#dsn#">
	SELECT * FROM SETUP_PERIOD WHERE OUR_COMPANY_ID = #session.ep.company_id# ORDER BY PERIOD_YEAR DESC
</cfquery>
<cfset count_ = 0>
<cfquery name="get_inventory" datasource="#dsn2#">
	<cfloop query="get_periods">
		<cfset count_ = count_ + 1>
		SELECT
			'#get_periods.PERIOD_ID#' AS RELATED_PERIOD_ID,
			'#get_periods.PERIOD_YEAR#' AS RELATED_PERIOD_YEAR,
			IR.ACTION_DATE,
			I.INVENTORY_ID,
			I.ENTRY_DATE,
			IR.PAPER_NO,
			I.INVENTORY_NUMBER,
			SFR.AMOUNT QUANTITY,
			I.INVENTORY_NAME,
			PTR.PROCESS_CAT,
			SFR.PRICE AMOUNT,
			SF.FIS_TYPE,
			SF.FIS_ID,
			SF.FIS_NUMBER,
			SF.RELATED_INVOICE_ID,
			SF.RELATED_SHIP_ID,
			(SELECT INVOICE.INVOICE_NUMBER FROM #dsn#_#get_periods.period_year#_#session.ep.company_id#.INVOICE WHERE INVOICE.INVOICE_ID = SF.RELATED_INVOICE_ID) AS RELATED_INVOICE_NUMBER,
			(SELECT SHIP.SHIP_NUMBER FROM #dsn#_#get_periods.period_year#_#session.ep.company_id#.SHIP WHERE SHIP.SHIP_ID = SF.RELATED_SHIP_ID) AS RELATED_SHIP_NUMBER,
			(SELECT PTR2.PROCESS_CAT FROM #dsn#_#get_periods.period_year#_#session.ep.company_id#.SHIP,#dsn3_alias#.SETUP_PROCESS_CAT PTR2 WHERE SHIP.SHIP_ID = SF.RELATED_SHIP_ID AND SHIP.PROCESS_CAT = PTR2.PROCESS_CAT_ID) AS RELATED_PROCESS_CAT
		FROM
			#dsn3_alias#.INVENTORY I,
			#dsn3_alias#.INVENTORY_ROW IR,
			#dsn3_alias#.STOCKS S,
			#dsn3_alias#.SETUP_PROCESS_CAT PTR,
			#dsn#_#get_periods.period_year#_#session.ep.company_id#.STOCK_FIS SF,
			#dsn#_#get_periods.period_year#_#session.ep.company_id#.STOCK_FIS_ROW SFR
		WHERE
			PTR.PROCESS_CAT_ID = SF.PROCESS_CAT AND
			I.INVENTORY_ID = IR.INVENTORY_ID AND
			IR.ACTION_ID =  SF.FIS_ID AND
			SFR.FIS_ID =  SF.FIS_ID AND
			SFR.STOCK_ID = S.STOCK_ID AND
			SFR.INVENTORY_ID = I.INVENTORY_ID AND
			IR.PERIOD_ID = #get_periods.period_id# AND
			I.INVENTORY_ID = #attributes.inventory_id# AND
			SF.FIS_TYPE <> 1181
		UNION ALL
		SELECT
			'#get_periods.PERIOD_ID#' AS RELATED_PERIOD_ID,
			'#get_periods.PERIOD_YEAR#' AS RELATED_PERIOD_YEAR,
			IR.ACTION_DATE,
			I.INVENTORY_ID,
			I.ENTRY_DATE,
			IR.PAPER_NO,
			I.INVENTORY_NUMBER,
			SFR.AMOUNT QUANTITY,
			I.INVENTORY_NAME,
			PTR.PROCESS_CAT,
			SFR.PRICE AMOUNT,
			SF.INVOICE_CAT FIS_TYPE,
			SF.INVOICE_ID FIS_ID,
			SF.INVOICE_NUMBER FIS_NUMBER,
			'' RELATED_INVOICE_ID,
			'' RELATED_SHIP_ID,
			'' AS RELATED_SHIP_NUMBER,
			'' AS RELATED_INVOICE_NUMBER,
			'' AS RELATED_PROCESS_CAT
		FROM
			#dsn3_alias#.INVENTORY I,
			#dsn3_alias#.INVENTORY_ROW IR,
			#dsn3_alias#.SETUP_PROCESS_CAT PTR,
			#dsn#_#get_periods.period_year#_#session.ep.company_id#.INVOICE SF,
			#dsn#_#get_periods.period_year#_#session.ep.company_id#.INVOICE_ROW SFR
		WHERE
			PTR.PROCESS_CAT_ID = SF.PROCESS_CAT AND
			I.INVENTORY_ID = IR.INVENTORY_ID AND
			IR.ACTION_ID =  SF.INVOICE_ID AND
			SFR.INVOICE_ID =  SF.INVOICE_ID AND
			SFR.INVENTORY_ID = I.INVENTORY_ID AND
			IR.PERIOD_ID = #get_periods.period_id# AND
			I.INVENTORY_ID = #attributes.inventory_id# 
		<cfif get_periods.recordcount neq count_>UNION ALL</cfif>
	</cfloop>
</cfquery>
<cfquery name="get_asset_type" datasource="#dsn#">
	SELECT 
		ASSET_P_CAT.IT_ASSET,
		ASSET_P_CAT.MOTORIZED_VEHICLE,		
		ASSET_P.INVENTORY_NUMBER
	FROM 
		ASSET_P,
		ASSET_P_CAT
	WHERE
		ASSET_P.INVENTORY_NUMBER ='#get_inventory.inventory_number#' AND	
		ASSET_P.ASSETP_CATID = ASSET_P_CAT.ASSETP_CATID
	ORDER BY 
		ASSET_P.ASSETP_ID 
</cfquery>
<cfquery name="GET_INVENT" datasource="#DSN3#">
	SELECT * FROM INVENTORY WHERE INVENTORY_ID = #attributes.inventory_id#
</cfquery>
<cfif not GET_INVENT.recordcount>
	<cfset hata  = 11>
	<cfsavecontent variable="message"><cf_get_lang dictionary_id='58943.Boyle Bir Kayit Bulunmamaktadir'>!</cfsavecontent>
	<cfset hata_mesaj  = message>
	<cfinclude template="../../dsp_hata.cfm">
<cfelse>
	<cfif len(get_invent.subscription_id)>
	<cfquery name="GET_SYSTEM_NO" datasource="#DSN3#">
		SELECT SUBSCRIPTION_NO FROM SUBSCRIPTION_CONTRACT WHERE SUBSCRIPTION_ID= #get_invent.subscription_id#
	</cfquery></cfif>
	<cfquery name="GET_SETUP_INVENTORY_CATS" datasource="#DSN3#">
		SELECT * FROM SETUP_INVENTORY_CAT
	</cfquery>
	<cfquery name="get_invent_actions" datasource="#dsn3#">
		SELECT 
			SUM(TO_AMOUNT) AS TOTAL
		FROM 
			RELATION_ROW 
		WHERE 
			TO_TABLE = 'INVENTORY_ROW' AND 
			FROM_TABLE = 'SHIP_ROW' AND
			TO_WRK_ROW_ID LIKE '#attributes.inventory_id#-%'
	</cfquery>
	<cfif get_invent_actions.recordcount and len(get_invent_actions.TOTAL)>
		<cfset iade_miktari_ = get_invent_actions.TOTAL>
	<cfelse>
		<cfset iade_miktari_ = 0>
	</cfif>
	<cfif isdefined("is_total_value") and is_total_value eq 1>
		<cfset quantity_info = get_invent.quantity>
	<cfelse>
		<cfset quantity_info = 1>
	</cfif>
	<cfset list_inventory_cat_=valuelist(GET_SETUP_INVENTORY_CATS.INVENTORY_CAT_ID)>
    <cfif len(get_inventory.FIS_ID)>
        <cfquery name="get_comp" datasource="#dsn2#">
            SELECT COMPANY_ID,PARTNER_ID,CONSUMER_ID FROM #dsn#_#get_inventory.related_period_year#_#session.ep.company_id#.INVOICE WHERE INVOICE_ID = #get_inventory.FIS_ID#
        </cfquery>
        <cfset company_id = get_comp.COMPANY_ID>
        <cfset consumer_id = get_comp.CONSUMER_ID>
        <cfset partner_id = get_comp.PARTNER_ID>
    <cfelse>
        <cfset company_id = "">
        <cfset consumer_id = "">
        <cfset partner_id = "">
    </cfif>
	<cf_catalystHeader>
		<div class="col col-12">
			<cf_box>
				<cf_box_elements>
						<cfoutput>
							<div class="col col-4 col-md-4 col-sm-6 col-xs-12" type="column" index="1" sort="true">
								<div class="form-group" id="item-cat">
									<div class="col col-4 col-md-4 col-sm-4 col-xs-12">
										<label class="bold"><cf_get_lang dictionary_id='57486.Kategori'>: </label>
									</div>
									<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
										<label><cfif len(get_invent.inventory_catid)>#GET_SETUP_INVENTORY_CATS.INVENTORY_CAT[listfind(list_inventory_cat_,get_invent.inventory_catid)]#</cfif></label>
									</div>
								</div>
								<div class="form-group" id="item-inventory_number">
									<div class="col col-4 col-md-4 col-sm-4 col-xs-12">
										<label class="bold"><cf_get_lang dictionary_id='58878.Demirbaş No'>: </label>
									</div>
									<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
										<label>#get_invent.inventory_number#</label>
									</div>
								</div>
								<div class="form-group" id="item-inventory_name">
									<div class="col col-4 col-md-4 col-sm-4 col-xs-12">
										<label class="bold"><cf_get_lang dictionary_id='57631.Adı'>: </label>
									</div>
									<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
										<label>#get_invent.inventory_name#</label>
									</div>
								</div>
								<div class="form-group" id="item-entry_date">
									<div class="col col-4 col-md-4 col-sm-4 col-xs-12">
										<label class="bold"><cf_get_lang dictionary_id='57628.Giriş Tarihi'>: </label>
									</div>
									<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
										<label>#dateformat(get_invent.entry_date,dateformat_style)#</label>
									</div>
								</div>
								<div class="form-group" id="item-account_period">
									<div class="col col-4 col-md-4 col-sm-4 col-xs-12">
										<label class="bold"><cf_get_lang dictionary_id='56967.Hesaplama Dönemi'>(<cf_get_lang dictionary_id ='58605.Periyod/Yıl'>): </label>
									</div>
									<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
										<label>#get_invent.account_period#</label>
									</div>
								</div>
							</div>
							<div class="col col-4 col-md-4 col-sm-6 col-xs-12" type="column" index="2" sort="true">
								<div class="form-group" id="item-quantity">
									<div class="col col-4 col-md-4 col-sm-4 col-xs-12">
										<label class="bold"><cf_get_lang dictionary_id='57635.Miktarı'>: </label>
									</div>
									<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
										<label>#get_invent.quantity#</label>
									</div>
								</div>
								<div class="form-group" id="item-tlformat">
									<div class="col col-4 col-md-4 col-sm-4 col-xs-12">
										<label class="bold"><cf_get_lang dictionary_id='29534.Toplam Tutar'>: </label>
									</div>
									<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
										<label>#TLFormat(quantity_info * get_invent.amount)#</label>
									</div>
								</div>
								<div class="form-group" id="item-inventory_duration">
									<div class="col col-4 col-md-4 col-sm-4 col-xs-12">
										<label class="bold"><cf_get_lang dictionary_id='56906.Faydalı Omur'>: </label>
									</div>
									<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
										<label><cfif len(get_invent.inventory_duration)>#TLFormat(get_invent.inventory_duration)#</cfif></label>
									</div>
								</div>
								<div class="form-group" id="item-inventory_duration_ifrs">
									<div class="col col-4 col-md-4 col-sm-4 col-xs-12">
										<label class="bold">IFRS <cf_get_lang dictionary_id='56906.Faydalı Omur'>: </label>
									</div>
									<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
										<label><cfif len(get_invent.inventory_duration_ifrs)>#TLFormat(get_invent.inventory_duration_ifrs)#</cfif></label>
									</div>
								</div>
								<div class="form-group" id="item-amortizaton_estimate">
									<div class="col col-4 col-md-4 col-sm-4 col-xs-12">
										<label class="bold"><cf_get_lang dictionary_id='56915.Amortisman Oranı'>: </label>
									</div>
									<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
										<label>#get_invent.amortizaton_estimate#</label>
									</div>
								</div>
								<div class="form-group" id="item-amortization_method">
									<div class="col col-4 col-md-4 col-sm-4 col-xs-12">
										<label class="bold"><cf_get_lang dictionary_id='29420.Amortisman Yöntemi'>: </label>
									</div>
									<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
										<label>
											<cfif get_invent.amortizaton_method eq 0>
												<cf_get_lang dictionary_id='29421.Azalan Bakiye Üzerinden'>
											<cfelseif get_invent.amortizaton_method eq 1 >
												<cf_get_lang dictionary_id='29422.Sabit Miktar Üzerinden'>
											</cfif>
										</label>
									</div>
								</div>
							</div>
							<div class="col col-4 col-md-4 col-sm-6 col-xs-12" type="column" index="3" sort="true">
								<div class="form-group" id="item-account_code">
									<div class="col col-4 col-md-4 col-sm-4 col-xs-12">
										<label class="bold"><cf_get_lang dictionary_id='58811.Muhasebe Kodu'>: </label>
									</div>
									<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
										<label>
											<cfquery name="GET_ACCOUNT_NAME" datasource="#DSN2#">
												SELECT
													ACCOUNT_NAME,
													ACCOUNT_CODE
													FROM
													ACCOUNT_PLAN
												WHERE
													ACCOUNT_CODE = '#get_invent.account_id#'
											</cfquery>
											#get_account_name.account_code# - #get_account_name.account_name#
										</label>
									</div>
								</div>
								<div class="form-group" id="item-claim_account_id">
									<div class="col col-4 col-md-4 col-sm-4 col-xs-12">
										<label class="bold"><cf_get_lang dictionary_id='56935.Alacak Muhasebe Kodu'>: </label>
									</div>
									<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
										<label>#get_invent.claim_account_id#</label>
									</div>
								</div>
								<div class="form-group" id="item-debt_account_id">
									<div class="col col-4 col-md-4 col-sm-4 col-xs-12">
										<label class="bold"><cf_get_lang dictionary_id='56933.Borçlu Muhasebe Kodu'>: </label>
									</div>
									<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
										<label>#get_invent.debt_account_id#</label>
									</div>
								</div>
								<div class="form-group" id="item-amortization_type">
									<div class="col col-4 col-md-4 col-sm-4 col-xs-12">
										<label class="bold"><cf_get_lang dictionary_id='29425.Amortisman türü'>: </label>
									</div>
									<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
										<label><cfif get_invent.amortization_type eq 1><cf_get_lang dictionary_id='29426.Kıst Amortismana Tabi'><cfelse><cf_get_lang dictionary_id='29427.Kıst Amortismana Tabi Değil'></cfif></label>
									</div>
								</div>
								<div class="form-group" id="item-subscription_id">
									<div class="col col-4 col-md-4 col-sm-4 col-xs-12">
										<label class="bold"><cf_get_lang_main no='1705.Sistem No'>: </label>
									</div>
									<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
										<label>
											<cfif len(get_invent.subscription_id)><a href="#request.self#?fuseaction=sales.list_subscription_contract&event=upd&subscription_id=#get_invent.subscription_id#" class="tableyazi">#get_system_no.subscription_no#</a></cfif>
										</label>
									</div>
								</div>
							</div>
						</cfoutput>
				</cf_box_elements>
				<cf_box_footer>
					<div class="col col-6 col-xs-12">
						<cf_record_info query_name="get_invent">
					</div>
					<div class="col col-6 col-xs-12">
						<cfif not(get_amortization.recordcount) and not(get_inventory.recordcount) and not(get_invoice.recordcount)><cf_workcube_buttons is_upd=1 is_delete=1 is_insert=0 delete_page_url='#request.self#?fuseaction=invent.emptypopup_del_invent&inventory_id=#attributes.inventory_id#'>
					</cfif>
				</div>
				</cf_box_footer>
				<cfsavecontent  variable="variable"><cf_get_lang dictionary_id='56944.Amortisman Değişimleri'></cfsavecontent>
				<cf_seperator title="#variable#" id="amortisman_table">
				<div  id="amortisman_table">
					<cf_grid_list>
						<thead>
							<tr>
								<th width="25"><cf_get_lang dictionary_id='57487.No'></th>
								<th width="25"><cf_get_lang dictionary_id='58455.Yıl'></th>
								<th><cf_get_lang dictionary_id='29420.Amortisman Yöntemi'></th>
								<th style="text-align:right;"><cf_get_lang dictionary_id='56915.Amortisman Oranı'></th>
								<th style="text-align:right;"><cf_get_lang dictionary_id='56973.Onceki Değer'></th>
								<th style="text-align:right;"><cf_get_lang dictionary_id ='56946.Amortisman Tutarı'></th>
								<th style="text-align:right;"><cf_get_lang dictionary_id='56967.Hesaplama Dönemi'>(<cf_get_lang dictionary_id ='58605.Periyod/Yıl'>)</th>
								<th style="text-align:right;"><cf_get_lang dictionary_id='56952.Dönemsel Amortisman Tutarı'></th>
								<th style="text-align:right;"><cf_get_lang dictionary_id="34093.Kıst Amortisman Tutarı"></th>
								<th style="text-align:right;"><cf_get_lang dictionary_id='56974.Sonraki Değer'></th>
								<th><cf_get_lang dictionary_id='57627.Kayıt Tarihi'></th>
								<th><cf_get_lang dictionary_id='57483.Kayıt'></th>
							</tr>
						</thead>
						<tbody>
							<cfset emp_id_list=''>
							<cfoutput query="get_amortization">
								<cfif not listfind(emp_id_list,get_amortization.record_emp)>
									<cfset emp_id_list=listappend(emp_id_list,get_amortization.record_emp)>
								</cfif>
							</cfoutput>
							<cfif listlen(emp_id_list)>
								<cfset emp_id_list=listsort(emp_id_list,"numeric","ASC",",")>
								<cfquery name="GET_EMP" datasource="#DSN#">
									SELECT
										EMPLOYEE_NAME,
										EMPLOYEE_SURNAME,
										EMPLOYEE_ID
									FROM 
										EMPLOYEES
									WHERE
										EMPLOYEE_ID IN (#emp_id_list#)
									ORDER BY
										EMPLOYEE_ID
								</cfquery>
							</cfif>
							<cfif get_amortization.recordcount>
								<cfoutput query="get_amortization">
									<tr>
										<td>#currentrow#</td>
										<td>#amortizaton_year#</td>
										<td><cfif amortizaton_method eq 0><cf_get_lang dictionary_id='29421.Azalan Bakiye Üzerinden'><cfelseif amortizaton_method eq 1><cf_get_lang dictionary_id='29422.Sabit Miktar Üzeriden'><cfelseif amortizaton_method eq 2><cf_get_lang dictionary_id='29423.Hızlandırılmış Azalan Bakiye'><cfelse><cf_get_lang dictionary_id='29424.Hızlandırılmış Sabit Değer'></cfif></td>
										<td style="text-align:right;">#amortizaton_estimate#</td>
										<td style="text-align:right;"><cfif attributes.old_value eq 0>#TLFormat(amount*quantity_info)#<cfelse>#TLFormat(attributes.old_value*quantity_info)#</cfif></td>
										<td style="text-align:right;">#TLFormat(amortizaton_inv_value*quantity_info)#</td>
										<td style="text-align:right;">#account_period#</td>
										<cfif isdefined(is_total_value) and is_total_value eq 0>
											<cfset inv_quantity_ = 1>
										<cfelse>
											<cfset inv_quantity_ = inv_quantity>
										</cfif>
										<td style="text-align:right;">#TLFormat(periodic_amort_value*inv_quantity_)#</td>
										<cfif len(periodic_amort_value)>
											<cfset toplam=toplam+periodic_amort_value*inv_quantity_>
										</cfif>
										<td style="text-align:right;"><cfif amortizaton_year eq year(get_invent.entry_date)>#TLFormat(partial_amortization_value)#</cfif></td>
										<td style="text-align:right;">#TLFormat(amortizaton_value*inv_quantity_)#</td>
										<cfif amortizaton_method eq 0 or amortizaton_method eq 2>
											<cfset attributes.old_value=amortizaton_value>
										<cfelse>
											<cfset attributes.old_value=0>
										</cfif>
										<td style="text-align:right;">#dateformat(action_date,dateformat_style)#</td>
										<td> <cfif listlen(emp_id_list)>#get_emp.EMPLOYEE_NAME[listfind(emp_id_list,record_emp,',')]# #get_emp.EMPLOYEE_SURNAME[listfind(emp_id_list,record_emp,',')]#</cfif></td>
									</tr>
								</cfoutput>
							<cfelse>
								<tr>
									<td colspan="12"><cf_get_lang dictionary_id='57484.Kayıt Yok'> !</td>
								</tr>
							</cfif>
						</tbody>
					</cf_grid_list>
					<div class="ui-info-bottom">
						<cfoutput><b><cf_get_lang dictionary_id='56932.Toplam Dönemsel Amortisman Tutarı'>: </b> <cfoutput>#Tlformat(toplam)#</cfoutput></cfoutput>
					</div>
				</div>
				<cfsavecontent  variable="variable"><cf_get_lang dictionary_id='56991.Alış Satış Stok İşlemler'></cfsavecontent>
				<cf_seperator title="#variable#" id="stock_table">
				<cf_grid_list id="stock_table">
					<thead>
						<tr>
							<th style="text-align:right;"><cf_get_lang dictionary_id='57742.Tarih'></th>
							<th><cf_get_lang dictionary_id='57800.İşlem Tipi'></th>
							<th style="text-align:right;"><cf_get_lang dictionary_id='57880.Belge No'></th>
							<th style="text-align:right;"><cf_get_lang dictionary_id='58133.Fatura No'></th>
							<th style="text-align:right;"><cf_get_lang dictionary_id='29430.İrsaliye Tipi'></th>
							<th style="text-align:right;"><cf_get_lang dictionary_id='58138.İrsaliye No'></th>
							<th style="text-align:right;"><cf_get_lang dictionary_id='57635.Miktar'></th>
							<th style="text-align:right;"><cf_get_lang dictionary_id='57638.Birim Fiyat'></th>
							<th style="text-align:right;"><cf_get_lang dictionary_id='57673.Tutar'></th>
						</tr>
					</thead>
					<tbody>
						<cfif get_inventory.recordcount>
							<cfoutput query="get_inventory">
								<tr>
									<td style="text-align:right;">#dateformat(action_date,dateformat_style)#</td>
									<td nowrap>#PROCESS_CAT#</td>
									<td style="text-align:right;">
										<cfif not listfind('65,66',FIS_TYPE)>
											<cfif session.ep.period_id eq RELATED_PERIOD_ID><a href="#request.self#?fuseaction=invent.add_invent_stock_fis<cfif FIS_TYPE eq 1182>_return</cfif>&event=upd&fis_id=#FIS_ID#" class="tableyazi">#paper_no#</a></cfif>
										<cfelse>
											<cfif session.ep.period_id eq RELATED_PERIOD_ID>
												<cfif fis_type eq 66>
													<a href="#request.self#?fuseaction=invent.add_invent_sale&event=upd&invoice_id=#FIS_ID#" class="tableyazi">#paper_no#</a>
												<cfelse>
													<a href="#request.self#?fuseaction=invent.add_invent_purchase&event=upd&invoice_id=#FIS_ID#" class="tableyazi">#paper_no#</a>
												</cfif>
											</cfif>
										</cfif>
									</td>
									<td style="text-align:right;"><cfif len(RELATED_INVOICE_ID) and session.ep.period_id eq RELATED_PERIOD_ID><a href="#request.self#?fuseaction=invoice.form_add_bill_purchase&event=upd&iid=#RELATED_INVOICE_ID#" class="tableyazi">#RELATED_INVOICE_NUMBER#</a></cfif></td>
									<td style="text-align:right;">#RELATED_PROCESS_CAT#</td>
									<td><cfif len(RELATED_SHIP_ID) and session.ep.period_id eq RELATED_PERIOD_ID><a href="#request.self#?fuseaction=stock.form_add_<cfif FIS_TYPE eq 1182>purchase<cfelse>sale</cfif>&event=upd&ship_id=#RELATED_SHIP_ID#" class="tableyazi">#RELATED_SHIP_NUMBER#</a><cfelse>#RELATED_SHIP_NUMBER#</cfif></td>
									<td style="text-align:right;">#quantity#</td>
									<td style="text-align:right;">#TLFormat(amount)#</td>
									<td style="text-align:right;">#TLFormat(quantity * amount)#</td>
								</tr>
							</cfoutput>
						<cfelse>
							<tr>
								<td colspan="9"><cf_get_lang dictionary_id='57484.Kayıt Yok'> !</td>
							</tr>
						</cfif>
					</tbody>
				</cf_grid_list>
				<cfsavecontent  variable="variable"><cf_get_lang dictionary_id='58602.Demirbas'><cf_get_lang dictionary_id='57473.Tarihce'></cfsavecontent>
				<cf_seperator title="#variable#" id="history_table">
				<cf_grid_list id="history_table">
					
					<thead>
						<tr>
							<th width="30"><cf_get_lang dictionary_id='58577.Sıra'></th>
							<th style="text-align:right;"><cf_get_lang dictionary_id='57742.Tarih'></th>
							<th><cf_get_lang dictionary_id='57416.Proje'></th>
							<th><cf_get_lang dictionary_id='58460.Masraf Merkezi'></th>
							<th><cf_get_lang dictionary_id='58551.Gider Kalemi'></th>				
							<th style="text-align:right;"><cf_get_lang dictionary_id='58811.Muhasebe Kodu'></th>
							<th style="text-align:right;"><cf_get_lang dictionary_id="57000.Borç Muh Kodu"></th>
							<th style="text-align:right;"><cf_get_lang dictionary_id="57001.Alacak Muh Kodu"></th>
							<th style="text-align:right;"><cf_get_lang dictionary_id='56915.Amortisman Oranı'></th>
							<th style="text-align:right;"><cf_get_lang dictionary_id='56906.Faydalı Ömür'></th>
							<th><cf_get_lang dictionary_id='57899.Kaydeden'></th>
							<th style="text-align:right;"><cf_get_lang dictionary_id='57627.Kayit Tarihi'></th>
							<th width="20"><i class="fa fa-minus"></i></th>
							<th width="20"><a href="<cfoutput>#request.self#?fuseaction=invent.upd_collacted_inventory&inventory_number=#get_invent.inventory_number#&form_varmi=1</cfoutput>" style="text-align:right;" target="_blank"><i class="fa fa-plus" alt="<cf_get_lang dictionary_id="57582.Ekle">" title="<cf_get_lang dictionary_id="57582.Ekle">"></i></a></th>
						</tr>
					</thead>
					<tbody>
						<cfset expense_item_id_list = "">
						<cfset expense_center_id_list = "">
						<cfoutput query="get_inventory_history">
							<cfif len(expense_center_id) and not listfind(expense_center_id_list,expense_center_id)>
								<cfset expense_center_id_list=listappend(expense_center_id_list,expense_center_id)>
							</cfif>
							<cfif len(expense_item_id) and not listfind(expense_item_id_list,expense_item_id)>
								<cfset expense_item_id_list=listappend(expense_item_id_list,expense_item_id)>
							</cfif>
						</cfoutput>
						<!--- masraf/gelir merkezleri --->
						<cfif len(expense_center_id_list)>
							<cfset expense_center_id_list=listsort(expense_center_id_list,"numeric","ASC",",")>
							<cfquery name="get_exp_inc_center_name" datasource="#dsn2#">
								SELECT EXPENSE, EXPENSE_ID FROM EXPENSE_CENTER WHERE EXPENSE_ID IN (#expense_center_id_list#) ORDER BY EXPENSE_ID
							</cfquery>
							<cfset expense_center_id_list = listsort(listdeleteduplicates(valuelist(get_exp_inc_center_name.expense_id,',')),'numeric','ASC',',')>
						</cfif>
						<!--- gider kalemleri --->
						<cfif len(expense_item_id_list)>
							<cfset expense_item_id_list=listsort(expense_item_id_list,"numeric","ASC",",")>
							<cfquery name="get_exp_detail" datasource="#dsn2#">
								SELECT EXPENSE_ITEM_NAME, EXPENSE_ITEM_ID FROM EXPENSE_ITEMS WHERE EXPENSE_ITEM_ID IN (#expense_item_id_list#) ORDER BY EXPENSE_ITEM_ID
							</cfquery>
							<cfset expense_item_id_list = listsort(listdeleteduplicates(valuelist(get_exp_detail.expense_item_id,',')),'numeric','ASC',',')>
						</cfif>
						<cfquery name="get_last_amortization_" datasource="#dsn3#">
							SELECT
								MAX(INVENTORY_AMORTIZATION_MAIN.ACTION_DATE) ACTION_DATE
							FROM
								INVENTORY_AMORTIZATON,
								INVENTORY_AMORTIZATION_MAIN
							WHERE
								INVENTORY_AMORTIZATON.INVENTORY_ID = #attributes.inventory_id# AND
								INVENTORY_AMORTIZATION_MAIN.INV_AMORT_MAIN_ID=INVENTORY_AMORTIZATON.INV_AMORT_MAIN_ID
						</cfquery>
						<cfif get_inventory_history.recordcount>
							<cfoutput query="get_inventory_history">
								<tr>
									<td nowrap="nowrap">#currentrow#</td>
									<td style="text-align:right;">#dateFormat(action_date,dateformat_style)#</td>
									<td><cfif len(project_id)><a href="#request.self#?fuseaction=project.projects&event=det&id=#project_id#" class="tableyazi">#get_project_name(project_id)#</a></cfif></td>
									<td><cfif isdefined("get_exp_inc_center_name")>#get_exp_inc_center_name.expense[listfind(expense_center_id_list,expense_center_id,',')]#</cfif></td>
									<td><cfif isdefined("get_exp_detail")>#get_exp_detail.expense_item_name[listfind(expense_item_id_list,expense_item_id,',')]#</cfif></td>
									<td style="text-align:right;">#account_code#</td>
									<td style="text-align:right;">#debt_account_code#</td>
									<td style="text-align:right;">#claim_account_code#</td>
									<td style="text-align:right;">#amortization_rate#</td>
									<td style="text-align:right;">#inventory_duration#</td>
									<td>#get_emp_info(record_emp,0,0)#</td>
									<td style="text-align:right;">#dateFormat(record_date,dateformat_style)#</td>
									<td style="text-align:right;">
										<cfif not len(action_id) and not(len(action_type) and action_type eq 1181)>
											<cfif not(isdefined("get_last_amortization_.action_date") and len(get_last_amortization_.action_date)) or datediff('d',dateformat(action_date),dateformat(get_last_amortization_.action_date)) lt 0>
												<a href="javascript://" onClick="javascript:if (confirm('Tarihçe Kaydını Silmek İstediğinizden Emin Misiniz?')) window.location='#request.self#?fuseaction=invent.emptypopup_del_inventory_history&history_id=#inventory_history_id#&inventory_id=#attributes.inventory_id#'; else return false;" class="tableyazi"><i class="fa fa-minus" alt="<cf_get_lang dictionary_id='57463.Sil'>" title="<cf_get_lang dictionary_id='57463.Sil'>"></i></a>
											</cfif>
										</cfif>
									</td>
									<td>
								</tr>
							</cfoutput>
						<cfelse>
							<tr>
								<td colspan="13"><cf_get_lang dictionary_id='57484.Kayıt Yok'> !</td>
							</tr>
						</cfif>
					</tbody>
				</cf_grid_list>				
			</cf_box>
				<cfset components = createObject('component','V16.inventory.cfc.inventory')>
				<cfset GetValuationInvent = components.ValuationInvent()>
				<cf_box title="#getLang('','Demirbaş Değer Artışı ve Düşüşü İşlemleri',35929)#-#getLang('','Yeni demirbaşlar',65385)#">
					<cf_grid_list>
						<thead>
							<tr>
								<th width="20"><cf_get_lang dictionary_id='58577.no'></th>
								<th><cf_get_lang dictionary_id='57879.İşlem Tarihi'></th>
								<th><cf_get_lang dictionary_id='57880.Belge No'></th>
								<th><cf_get_lang dictionary_id='36760.işlem kategorisi'></th>
								<th><cf_get_lang dictionary_id='29472.Yöntem'></th>
								<th><cf_get_lang dictionary_id='33992.Yeni Demirbaş'></th>
								<th width="20"><a href="javascript://"><i style="color:orange!important;" class="fa fa-briefcase" title=""></i></a></th>
								<th class="text-right"><cf_get_lang dictionary_id="56908.ilk değer"></th>
								<th class="text-right"><cf_get_lang dictionary_id="56909.son değer"></th>
								<th width="20"><a href="javascript://"><i class="fa fa-pencil" title=""></i></a></th>
							</tr>
						</thead>
						<tbody>
							<cfoutput query="GetValuationInvent">
								<tr>
									<td>#currentrow#</td>
									<td>#DateFormat(valuation_date,dateformat_style)#</td>
									<td>#paper_no#</td>
									<td>#process_name#</td>
									<td><cfif valuation_method eq 0>#getLang('','ek',53841)#<cfelse>#getLang('','Yeni',58674)#</cfif></td>
									<td>#new_inventory_name#</td>
									<td><a href="javascript://" onclick="window.open('#request.self#?fuseaction=invent.list_inventory&event=det&inventory_id=#INVENTORY_ID#','medium');"><i style="color:orange!important;" class="fa fa-briefcase"></i></a></td>
									<td class="text-right"><cfif valuation_method eq 1>#TLFORMAT(AMOUNT)#<cfelse>#TLFORMAT(NEW_VALUE_MONEY)#</cfif></td>
									<td class="text-right">#TLFORMAT(NEW_VALUE_MONEY)#</td>
									<td><a href="javascript://" onclick="window.open('#request.self#?fuseaction=invent.valuation&event=add&id=#INVENTORY_ID#','medium');"><i class="fa fa-pencil"></i></a></td>                
								</tr>
							</cfoutput>
						</tbody>
					</cf_grid_list>
				</cf_box>
		</div>
</cfif>