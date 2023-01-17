<cf_get_lang_set module_name="invent"><!--- sayfanin en altinda kapanisi var --->
<link rel="stylesheet" href="/css/assets/template/catalyst/print.css" type="text/css">
<cfif isDefined("attributes.iid")>
	<cfset attributes.action_id = attributes.iid>
</cfif>
<cfparam name="attributes.old_value" default="0">
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
			I.INVENTORY_ID = #attributes.action_id# AND
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
			I.INVENTORY_ID = #attributes.action_id# 
		<cfif get_periods.recordcount neq count_>UNION ALL</cfif>
	</cfloop>
</cfquery>
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
		INVENTORY_AMORTIZATON.INVENTORY_ID = #attributes.action_id# AND
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
		INVENTORY_AMORTIZATON.INVENTORY_ID = #attributes.action_id# AND
		INVENTORY_AMORTIZATION_MAIN.INV_AMORT_MAIN_ID=INVENTORY_AMORTIZATON.INV_AMORT_MAIN_ID
	ORDER BY 
		INVENTORY_AMORTIZATION_MAIN.ACTION_DATE
</cfquery>
<cfquery name="CHECK" datasource="#DSN#">
    SELECT 
      ASSET_FILE_NAME2,
      ASSET_FILE_NAME2_SERVER_ID,
    COMPANY_NAME
    FROM 
      OUR_COMPANY 
    WHERE 
      <cfif isdefined("attributes.our_company_id")>
        COMP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.our_company_id#">
      <cfelse>
        <cfif isDefined("session.ep.company_id") and len(session.ep.company_id)>
          COMP_ID = #session.ep.company_id#
        <cfelseif isDefined("session.pp.company_id") and len(session.pp.company_id)>  
          COMP_ID = #session.pp.company_id#
        <cfelseif isDefined("session.ww.our_company_id")>
          COMP_ID = #session.ww.our_company_id#
        <cfelseif isDefined("session.cp.our_company_id")>
          COMP_ID = #session.cp.our_company_id#
        </cfif> 
      </cfif> 
  </cfquery>
<cfquery name="GET_INVENT" datasource="#DSN3#">
	SELECT * FROM INVENTORY WHERE INVENTORY_ID = #attributes.action_id#
</cfquery>
<cfif isdefined("is_total_value") and is_total_value eq 1>
	<cfset quantity_info = get_invent.quantity>
<cfelse>
	<cfset quantity_info = 1>
</cfif>
<cfif GET_INVENT.recordcount>
	<table style="width:210mm">
		<tr>
			<td>
				<table width="100%">
					<tr class="row_border">
						<td class="print-head">
							<table style="width:100%;">
								<tr>
									<td class="print_title"><cf_get_lang dictionary_id='57531.Sabit Kıymetler'> (<cf_get_lang dictionary_id='58602.Demirbaş'>)</b></td>
										<td style="text-align:right;">
											<cfif len(check.asset_file_name2)>
											<cfset attributes.type = 1>
												<cf_get_server_file output_file="/settings/#check.asset_file_name2#" output_server="#check.asset_file_name2_server_id#" output_type="5">
											</cfif>
										</td>
									</td>
								</tr> 
							</table>
						</td>
					</tr> 
					<tr class="row_border">
						<td>
							<table style="width:100%;" align="center">
								<tr>
									<td width="110" class="txtbold"><b><cf_get_lang dictionary_id='58878.Demirbaş No'> </b></td>
									<td width="70"><cfoutput>#get_invent.inventory_number#</cfoutput></td>
									<td width="140" class="txtbold"><b><cf_get_lang dictionary_id='57631.Adı'> </b></td>
									<td width="150"><cfoutput>#get_invent.inventory_name#</cfoutput></td>
									<td width="140" class="txtbold"><b><cf_get_lang dictionary_id='56935.Alacak Muhasebe Kodu'> </b></td>
									<td width="60"><cfoutput>#get_invent.claim_account_id#</cfoutput></td>
								</tr>
								<tr>
									<td class="txtbold"><b><cf_get_lang dictionary_id='57635.Miktarı'></b></td>
									<td><cfoutput>#get_invent.quantity#</cfoutput></td>
									<td class="txtbold"><b><cf_get_lang dictionary_id='29534.Toplam Tutar'> </b></td>
									<td><cfoutput>#TLFormat(get_invent.quantity * get_invent.amount)#</cfoutput></td>
									<td class="txtbold"><b><cf_get_lang dictionary_id='56933.Borçlu Muhasebe Kodu'></b></td>
									<td><cfoutput>#get_invent.debt_account_id#</cfoutput></td>
								</tr>
								<tr>
									<td class="txtbold"><b><cf_get_lang dictionary_id='57628.Giriş Tarihi'> </b></td>
									<td><cfoutput>#dateformat(get_invent.entry_date,dateformat_style)#</cfoutput></td>
										<cfquery name="GET_ACCOUNT_NAME" datasource="#DSN2#">
											SELECT ACCOUNT_NAME, ACCOUNT_CODE FROM ACCOUNT_PLAN WHERE ACCOUNT_CODE = '#get_invent.account_id#'
										</cfquery>
									<td class="txtbold"><b><cf_get_lang dictionary_id='58811.Muhasebe Kodu'> </b></td>
									<td><cfoutput>#get_account_name.account_code# - #get_account_name.account_name#</cfoutput></td>
									<td class="txtbold"><b><cf_get_lang dictionary_id='56967.Hesaplama Dönemi'> </b></td>
									<td><cfoutput>#get_invent.account_period#</cfoutput></td>
								</tr>
								<tr>
									<td class="txtbold"><b><cf_get_lang dictionary_id='56915.Amortisman Oranı'> </b></td>
									<td><cfoutput>#get_invent.amortizaton_estimate#</cfoutput></td>
									<td class="txtbold"><b><cf_get_lang dictionary_id='29420.Amortisman Yöntemi'> </b></td>
									<td><cfif get_invent.amortizaton_method eq 0><cf_get_lang dictionary_id='29421.Azalan Bakiye Üzerinden'>
										<cfelseif get_invent.amortizaton_method eq 1><cf_get_lang dictionary_id='29422.Sabit Miktar Üzeriden'>
										<cfelseif get_invent.amortizaton_method eq 2><cf_get_lang dictionary_id='29423.Hızlandırılmış Azalan Bakiye'>
										<cfelse><cf_get_lang dictionary_id='29424.Hızlandırılmış Sabit Değer'></cfif>
									</td>
								</tr>
							</table>
						</td>
					</tr>
					<cfif get_amortization.recordcount>
						<table>
							<tr>
								<td style="height:35px;"><b><cf_get_lang dictionary_id='56944.Amortisman Değişimleri'></b></td>
							</tr> 
						</table>
						
						<table class="print_border" style="width:210mm">
							<tr>
								<th width="25" style="text-align:right;"><cf_get_lang dictionary_id='57487.No'></th>
								<th width="25" style="text-align:right;"><cf_get_lang dictionary_id='58455.Yıl'></th>
								<th><cf_get_lang dictionary_id='29420.Amortisman Yöntemi'></th>
								<th style="text-align:right;"><cf_get_lang dictionary_id='56915.Amortisman Oranı'></th>
								<th style="text-align:right;"><cf_get_lang dictionary_id='56973.Onceki Değer'></th>
								<th style="text-align:right;"><cf_get_lang dictionary_id ='56946.Amortisman Tutarı'></th>
								<th style="text-align:right;"><cf_get_lang dictionary_id='56952.Dönemsel Amortisman Tutarı'></th>
							</tr>
							<cfset toplam=0>
							<cfoutput query="get_amortization">
								<tr>
									<td style="text-align:right;">#currentrow#</td>
									<td style="text-align:right;">#amortizaton_year#</td>
									<td><cfif amortizaton_method eq 0><cf_get_lang dictionary_id='29421.Azalan Bakiye Üzerinden'><cfelseif amortizaton_method eq 1><cf_get_lang dictionary_id='29422.Sabit Miktar Üzeriden'><cfelseif amortizaton_method eq 2><cf_get_lang dictionary_id='29423.Hızlandırılmış Azalan Bakiye'><cfelse><cf_get_lang dictionary_id='29424.Hızlandırılmış Sabit Değer'></cfif></td>
									<td style="text-align:right;">#amortizaton_estimate#</td>
									<td style="text-align:right;"><cfif attributes.old_value eq 0>#TLFormat(amount*quantity_info)#<cfelse>#TLFormat(attributes.old_value*quantity_info)#</cfif></td>
									<td style="text-align:right;">#TLFormat(amortizaton_inv_value)#</td>
									<cfif amortizaton_method eq 0 or amortizaton_method eq 2>
										<cfset attributes.old_value=amortizaton_value>
									<cfelse>
										<cfset attributes.old_value=0>
									</cfif>
									<cfif len(periodic_amort_value)>
										<cfset toplam=toplam+periodic_amort_value>
									</cfif>
									<td style="text-align:right;">#TLFormat(periodic_amort_value*inv_quantity)#</td>
								</tr>
							</cfoutput>
						</table>
					</cfif>
					<cfif get_inventory.recordcount>
						<table>
							<tr>
								<td style="height:35px;"><b><cf_get_lang no='98.Alış - Satış Stok İşlemleri'></b></td>
							</tr> 
						</table>
						<table class="print_border" style="width:210mm">
							<tr>
								<th style="text-align:right;"><cf_get_lang dictionary_id='57742.Tarih'></th>
								<th><cf_get_lang dictionary_id='57800.İşlem Tipi'></th>
								<th style="text-align:right;"><cf_get_lang dictionary_id='57880.Belge No'></th>
								<th style="text-align:right;"><cf_get_lang dictionary_id='57635.Miktar'></th>
								<th style="text-align:right;"><cf_get_lang dictionary_id='57638.Birim Fiyat'></th>
								<th style="text-align:right;"><cf_get_lang dictionary_id='57673.Tutar'></th>
								

							</tr>
							
							<cfset toplam_2=0>
							
							<cfoutput query="get_inventory"> 
								<tr>
									<td style="text-align:right;">#dateformat(action_date,dateformat_style)#</td>
									<td nowrap>#PROCESS_CAT#</td>
									<td style="text-align:right;">
										<cfif not listfind('65,66',FIS_TYPE)>
											<cfif session.ep.period_id eq RELATED_PERIOD_ID><a href="#request.self#?fuseaction=invent.add_invent_stock_fis<cfif FIS_TYPE eq 1182>_return</cfif>&event=upd&fis_id=#FIS_ID#" >#paper_no#</a></cfif>
										<cfelse>
											<cfif session.ep.period_id eq RELATED_PERIOD_ID>
												<cfif fis_type eq 66>
													#paper_no#
												<cfelse>
													#paper_no#
												</cfif>
											</cfif>
										</cfif>
									</td>
									<td style="text-align:right;">#quantity#</td>
									<td style="text-align:right;">#TLFormat(amount)#</td>
									<td style="text-align:right;">#TLFormat(quantity * amount)#</td>
									<cfif len((quantity * amount))>
										<cfset toplam_2=toplam_2+(quantity * amount)>
									</cfif>
								</tr>
							</cfoutput>
						
							<tr>
								<td colspan="5" style="text-align:right;" class="txtbold"><b><cf_get_lang dictionary_id='29512.Toplam Stok'><cf_get_lang dictionary_id='57882.İşlem Tutarı'></b></td>

								<td class="txtbold" style="text-align:right;"><cfoutput>#Tlformat(toplam_2)#</cfoutput></td>
							</tr>
							
							
						</table>	
					</cfif>
					<table>
					</br>
						<tr class="fixed">
						<td style="font-size:9px!important;"><b><cf_get_lang dictionary_id='61710.© Copyright'></b> <cfoutput>#check.COMPANY_NAME#</cfoutput> <cf_get_lang dictionary_id='61711.dışında kullanılamaz, paylaşılamaz.'></td>
						</tr>
					</br>
				</table>		
			</td>
		</tr>
	</table>
</cfif>
<cf_get_lang_set module_name="#lcase(listgetat(attributes.fuseaction,1,'.'))#"><!--- sayfanin en ustunde acilisi var --->
