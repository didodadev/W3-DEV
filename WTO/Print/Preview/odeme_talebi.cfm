<cf_get_lang_set module_name="finance"><!--- sayfanin en altinda kapanisi var --->
<!--- action_type --->
<link rel="stylesheet" href="/css/assets/template/catalyst/print.css" type="text/css">
<cfif not isdefined("attributes.action_type")>
	<cfexit>
</cfif>
<cfquery name="GET_INVOICE_CLOSE" datasource="#DSN2#">
	SELECT
		<cfif attributes.action_type eq 1><!--- Kapama İşlemi İse --->
			DEBT_AMOUNT_VALUE,
			CLAIM_AMOUNT_VALUE,
			DIFFERENCE_AMOUNT_VALUE,
		<cfelseif attributes.action_type eq 2><!--- Ödeme talebi İse --->
			PAYMENT_DEBT_AMOUNT_VALUE DEBT_AMOUNT_VALUE,
			PAYMENT_CLAIM_AMOUNT_VALUE CLAIM_AMOUNT_VALUE,
			PAYMENT_DIFF_AMOUNT_VALUE DIFFERENCE_AMOUNT_VALUE,
		<cfelseif attributes.action_type eq 3><!--- Ödeme emri İse --->
			P_ORDER_DEBT_AMOUNT_VALUE DEBT_AMOUNT_VALUE,
			P_ORDER_CLAIM_AMOUNT_VALUE CLAIM_AMOUNT_VALUE,
			P_ORDER_DIFF_AMOUNT_VALUE DIFFERENCE_AMOUNT_VALUE,
		</cfif>
		COMPANY_ID,
		CONSUMER_ID,
		CLOSED_ID,
		PAPER_DUE_DATE,
		OTHER_MONEY,
		PAYMETHOD_ID,
		PAPER_ACTION_DATE,
		PROCESS_STAGE,
		ACTION_DETAIL,
		RECORD_EMP,
		RECORD_DATE,
		UPDATE_DATE,
		UPDATE_EMP
	FROM
		CARI_CLOSED
	WHERE
	
		CLOSED_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.action_id#">
    
</cfquery>
<!--- <cfdump var="#GET_INVOICE_CLOSE#"><cfabort> --->
<cfif len(get_invoice_close.company_id)>
<cfquery name="get_comp_information" datasource="#DSN#">
	SELECT * FROM COMPANY WHERE COMPANY_ID = #get_invoice_close.company_id#
</cfquery>
<cfif len(get_comp_information.country)>
    <cfquery name="get_county" datasource="#dsn#">
        SELECT COUNTY_NAME FROM SETUP_COUNTY WHERE COUNTY_ID = #get_comp_information.country#
    </cfquery>
    <cfset ilce = get_county.county_name>
</cfif>

<cfif len(get_comp_information.city)>
	<cfquery name="get_city" datasource="#dsn#">
		SELECT CITY_NAME FROM SETUP_CITY WHERE CITY_ID = #get_comp_information.city#
	</cfquery>
	<cfset sehir = ucase(get_city.city_name)>
</cfif>
</cfif>
<cfquery name="GET_CARI_CLOSED" datasource="#dsn2#">
SELECT 
		*
	FROM 
	(
		SELECT
			CR.CARI_ACTION_ID,
			CR.ACTION_TABLE,
			CR.ACTION_NAME,
			CR.ACTION_ID,
			CR.PAPER_NO,
			CR.ACTION_TYPE_ID,
			CR.TO_CMP_ID,
			CR.FROM_CMP_ID,
			CR.TO_CONSUMER_ID,
			CR.FROM_CONSUMER_ID,
			CR.ACTION_VALUE CR_ACTION_VALUE,
			CR.ACTION_DATE,
			CR.DUE_DATE,
			CR.OTHER_CASH_ACT_VALUE,
			CR.OTHER_MONEY,
			ICR.CLOSED_ROW_ID CLOSED_ROW_ID,
		<cfif attributes.action_type eq 1>
			ISNULL(ICR.CLOSED_AMOUNT,0) CLOSED_AMOUNT,
			SUM(ISNULL(ICR.CLOSED_AMOUNT,0)) TOTAL_CLOSED_AMOUNT,
			SUM(ISNULL(ICR.OTHER_CLOSED_AMOUNT,0)) OTHER_CLOSED_AMOUNT,
		<cfelseif attributes.action_type eq 2>
			ISNULL(ICR.PAYMENT_VALUE,0) CLOSED_AMOUNT,
			SUM(ISNULL(ICR.PAYMENT_VALUE,0)) TOTAL_CLOSED_AMOUNT,
			SUM(ISNULL(ICR.OTHER_PAYMENT_VALUE,0)) OTHER_CLOSED_AMOUNT,
		<cfelse>
			ISNULL(ICR.P_ORDER_VALUE,0) CLOSED_AMOUNT,
			SUM(ISNULL(ICR.P_ORDER_VALUE,0)) TOTAL_CLOSED_AMOUNT,
			SUM(ISNULL(ICR.OTHER_P_ORDER_VALUE,0)) OTHER_CLOSED_AMOUNT,
		</cfif>
			SUM(ISNULL(ICR.PAYMENT_VALUE,0)) TOTAL_PAYMENT_VALUE,
			SUM(ISNULL(ICR.OTHER_PAYMENT_VALUE,0)) OTHER_PAYMENT_VALUE,
			SUM(ISNULL(ICR.P_ORDER_VALUE,0)) TOTAL_P_ORDER_VALUE,
			SUM(ISNULL(ICR.OTHER_P_ORDER_VALUE,0)) OTHER_P_ORDER_VALUE,
			ICR.OTHER_MONEY I_OTHER_MONEY,
			1 KONTROL
		FROM 
			CARI_ROWS CR,
			CARI_CLOSED_ROW ICR
		WHERE
			ICR.CLOSED_ID =<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.action_id#"> AND
			CR.ACTION_TYPE_ID NOT IN (48,49) AND
			CR.ACTION_ID = ICR.ACTION_ID AND
			((CR.ACTION_TABLE <> 'INVOICE' AND CR.ACTION_TABLE <> 'EXPENSE_ITEM_PLANS' AND CR.CARI_ACTION_ID = ICR.CARI_ACTION_ID) OR (CR.ACTION_TABLE = 'INVOICE' OR CR.ACTION_TABLE = 'EXPENSE_ITEM_PLANS')) AND
			(((CR.ACTION_TABLE = 'INVOICE' OR CR.ACTION_TABLE = 'EXPENSE_ITEM_PLANS') AND CR.DUE_DATE = ICR.DUE_DATE) OR (CR.ACTION_TABLE <> 'INVOICE' AND CR.ACTION_TABLE <> 'EXPENSE_ITEM_PLANS')) AND
			CR.OTHER_MONEY = ICR.OTHER_MONEY AND	
			CR.ACTION_TYPE_ID = ICR.ACTION_TYPE_ID
			<cfif attributes.action_type eq 1><!--- Kapama İşlemi İse --->
				AND ISNULL(ICR.CLOSED_AMOUNT,0)>0							
			<cfelseif attributes.action_type eq 2><!--- Ödeme talebi İse --->
				AND ISNULL(ICR.PAYMENT_VALUE,0)>0
			<cfelseif attributes.action_type eq 3><!--- Ödeme emri İse --->
				AND ISNULL(ICR.P_ORDER_VALUE,0)>0
			</cfif>
		GROUP BY
			CR.CARI_ACTION_ID,
			CR.ACTION_TABLE,
			CR.ACTION_NAME,
			CR.ACTION_ID,
			CR.PAPER_NO,
			CR.ACTION_TYPE_ID,
			CR.TO_CMP_ID,
			CR.FROM_CMP_ID,
			CR.TO_CONSUMER_ID,
			CR.FROM_CONSUMER_ID,
			CR.ACTION_VALUE,
			CR.ACTION_DATE,
			CR.DUE_DATE,
			CR.OTHER_CASH_ACT_VALUE,
			CR.OTHER_MONEY,
			ICR.CLOSED_ROW_ID,
		<cfif attributes.action_type eq 1>
			ICR.CLOSED_AMOUNT,
		<cfelseif attributes.action_type eq 2>
			ICR.PAYMENT_VALUE,
		<cfelse>
			ICR.P_ORDER_VALUE,
		</cfif>
			ICR.OTHER_MONEY
	UNION ALL
		SELECT
			0 CARI_ACTION_ID,
			'' ACTION_TABLE,
			'' ACTION_NAME,
			0 ACTION_ID,
			'' PAPER_NO,
			0 ACTION_TYPE_ID,
			CC.COMPANY_ID TO_CMP_ID,
			'' FROM_CMP_ID,
			CC.CONSUMER_ID TO_CONSUMER_ID,
			'' FROM_CONSUMER_ID,
			SUM(ISNULL(ICR.PAYMENT_VALUE,0)) CR_ACTION_VALUE,
			CC.PAPER_ACTION_DATE ACTION_DATE,
			CC.PAPER_DUE_DATE DUE_DATE,
			SUM(ISNULL(ICR.OTHER_PAYMENT_VALUE,0)) OTHER_CASH_ACT_VALUE,
			ICR.OTHER_MONEY,
			ICR.CLOSED_ROW_ID CLOSED_ROW_ID,
		<cfif attributes.action_type eq 1>
			ISNULL(ICR.CLOSED_AMOUNT,0) CLOSED_AMOUNT,
			SUM(ISNULL(ICR.CLOSED_AMOUNT,0)) TOTAL_CLOSED_AMOUNT,
			SUM(ISNULL(ICR.OTHER_CLOSED_AMOUNT,0)) OTHER_CLOSED_AMOUNT,
		<cfelseif attributes.action_type eq 2>
			ISNULL(ICR.PAYMENT_VALUE,0) CLOSED_AMOUNT,
			SUM(ISNULL(ICR.PAYMENT_VALUE,0)) TOTAL_CLOSED_AMOUNT,
			SUM(ISNULL(ICR.OTHER_PAYMENT_VALUE,0)) OTHER_CLOSED_AMOUNT,
		<cfelse>
			ISNULL(ICR.P_ORDER_VALUE,0) CLOSED_AMOUNT,
			SUM(ISNULL(ICR.P_ORDER_VALUE,0)) TOTAL_CLOSED_AMOUNT,
			SUM(ISNULL(ICR.OTHER_P_ORDER_VALUE,0)) OTHER_CLOSED_AMOUNT,
		</cfif>
			SUM(ISNULL(ICR.PAYMENT_VALUE,0)) TOTAL_PAYMENT_VALUE,
			SUM(ISNULL(ICR.OTHER_PAYMENT_VALUE,0)) OTHER_PAYMENT_VALUE,
			SUM(ISNULL(ICR.P_ORDER_VALUE,0)) TOTAL_P_ORDER_VALUE,
			SUM(ISNULL(ICR.OTHER_P_ORDER_VALUE,0)) OTHER_P_ORDER_VALUE,
			ICR.OTHER_MONEY I_OTHER_MONEY,
			1 KONTROL
		FROM 
			CARI_CLOSED CC,
			CARI_CLOSED_ROW ICR
		WHERE
			ICR.CLOSED_ID = #attributes.action_id# AND
			CC.CLOSED_ID = ICR.CLOSED_ID AND
			ICR.ACTION_ID = 0
			<cfif attributes.action_type eq 1><!--- Kapama İşlemi İse --->
				AND ISNULL(ICR.CLOSED_AMOUNT,0)>0							
			<cfelseif attributes.action_type eq 2><!--- Ödeme talebi İse --->
				AND ISNULL(ICR.PAYMENT_VALUE,0)>0
			<cfelseif attributes.action_type eq 3><!--- Ödeme emri İse --->
				AND ISNULL(ICR.P_ORDER_VALUE,0)>0
			</cfif>
            
		GROUP BY
			CC.COMPANY_ID,
			CC.CONSUMER_ID,
			CC.PAPER_ACTION_DATE,
			CC.PAPER_DUE_DATE,
			ICR.CLOSED_ROW_ID,
		<cfif attributes.action_type eq 1>
			ICR.CLOSED_AMOUNT,
		<cfelseif attributes.action_type eq 2>
			ICR.PAYMENT_VALUE,
		<cfelse>
			ICR.P_ORDER_VALUE,
		</cfif>
			ICR.OTHER_MONEY
             ) 
		MAIN_GET_CLOSED

</cfquery>
<cfif len(get_invoice_close.paymethod_id)>
    <cfquery name="GET_PAYM" datasource="#dsn#">
    SELECT PAYMETHOD,PAYMETHOD_ID FROM SETUP_PAYMETHOD WHERE PAYMETHOD_ID = #get_invoice_close.paymethod_id#
    </cfquery>
</cfif>
<cfquery name="get_closed_" datasource="#dsn2#">
		SELECT
			ACTION_ID,
			CLOSED_ID,
			P_ORDER_VALUE,
			CLOSED_AMOUNT,
			RELATED_CLOSED_ROW_ID
		FROM 
			CARI_CLOSED_ROW
		WHERE
			CLOSED_ID = #attributes.action_id#
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
<cfif attributes.action_type eq 2>
	<cfquery name="get_order_actions" dbtype="query">
		SELECT CLOSED_ID FROM get_closed_ WHERE P_ORDER_VALUE IS NOT NULL
	</cfquery>	
<cfelseif attributes.action_type eq 3>	
	<cfquery name="get_order_actions" dbtype="query">
		SELECT CLOSED_ID FROM get_closed_ WHERE RELATED_CLOSED_ROW_ID IS NOT NULL
	</cfquery>	
	<cfquery name="get_order_actions_2" dbtype="query">
		SELECT RELATED_CLOSED_ROW_ID FROM get_closed_ WHERE RELATED_CLOSED_ROW_ID IS NOT NULL
	</cfquery>
	<cfset related_row_ids = valuelist(get_order_actions_2.RELATED_CLOSED_ROW_ID)>
<cfelse>
	<cfset get_order_actions.recordcount = 0>
</cfif>
<cfset sayfa_sayisi = ceiling(GET_INVOICE_CLOSE.recordcount / 25)>
<cfif sayfa_sayisi eq 0>
	<cfset sayfa_sayisi = 1>
</cfif>
<cfscript>
	satir_start = 1;
	satir_end = 25;
</cfscript>
<!--- //Tanimlamalar --->
<cfloop from="1" to="#sayfa_sayisi#" index="j">
	<table style="width:210mm">
		<tr>
			<td>
				<table width="100%">
					<tr class="row_border">
						<td class="print-head">
							<table style="width:100%;">  
								<tr>
									<td class="print_title"><cf_get_lang dictionary_id='35571.Ödeme İşlemi'></td>
									<td style="text-align:right;">
										<cfif len(check.asset_file_name2)>
										<cfset attributes.type = 1>
										<cf_get_server_file output_file="/settings/#check.asset_file_name2#" output_server="#check.asset_file_name2_server_id#" output_type="5">
										</cfif>
									</td>
								</tr>
							</table> 
						</td>
					</tr>
					<tr class="row_border">
						<td>
							<table>
								<cfoutput>
									<tr>
										<td style="width:140px"><b><cf_get_lang no='265.Ödeme Emri'><cf_get_lang_main no='75.No'> </b></td>
										<td>#attributes.action_id#</td>
									</tr>
									<tr>
										<td style="width:140px"><b><cf_get_lang_main no='649.Cari'></b></td>
										<td><cfif len(get_invoice_close.company_id)>#get_par_info(get_invoice_close.company_id,1,1,0)#<cfelse>#get_cons_info(get_invoice_close.consumer_id,0,0)#</cfif></td>
									</tr>
									<tr>
										<td style="width:140px"><b><cf_get_lang_main no='1104.Ödeme Yöntemi'> </b></td>
										<td><cfif len(get_invoice_close.paymethod_id)>#GET_PAYM.PAYMETHOD#</cfif></td>
									</tr>
									<tr>
										<td style="width:140px"><b><cf_get_lang_main no='330.Tarih'>  </b></td>
										<td>#dateformat(get_invoice_close.PAPER_ACTION_DATE,dateformat_style)#</td>
									</tr>
									<tr>
										<td style="width:140px"><b><cf_get_lang_main no='449.Ortalama Vade'> </b></td>
										<td>#dateformat(get_invoice_close.PAPER_DUE_DATE,dateformat_style)#</td>
									</tr>
									
									<tr>
										<td style="width:140px"><b><cf_get_lang dictionary_id='58723.Adres'></b></td> 
											<td><cfif len(get_invoice_close.company_id) and len(get_comp_information.company_address)>#get_comp_information.company_address# &nbsp; #get_comp_information.semt#<cfelse>&nbsp;</cfif></td>
										<td><cfif len(get_invoice_close.company_id) and len(get_comp_information.country)>#ilce#</cfif> &nbsp;<cfif len(get_invoice_close.company_id) and len(get_comp_information.city)>/#sehir#</cfif></td>
									</tr>
								</cfoutput>
							</table>
						</td>
					</td>
					<table>
						<tr>
							<td style="height:35px;"><b><cf_get_lang dictionary_id='57771. DETAY"'></b></td>
						</tr> 
					</table>
					<table class="print_border" style="width:210mm">
						<tr >
							<th rowspan="2"  nowrap="nowrap"><cf_get_lang_main no='468.Belge No'></th>
							<th rowspan="2"  ><cf_get_lang_main no='388.İşlem Tipi'></th>
							<th rowspan="2"  ><cf_get_lang_main no='467.İşlem Tarihi'></th>
							<th rowspan="2"  ><cf_get_lang_main no='228.Vade'></th>
							<th rowspan="2" ><cf_get_lang_main no='469.Vade Tarihi'></th>
							<th colspan="2"  ><cf_get_lang_main no='1511.Belge Tutari'></th>
							<th colspan="2"   ><cf_get_lang no='65.Kapanmış Tutar'></th>
							<cfif attributes.action_type eq 3><th colspan="2"  ><cf_get_lang_main no='115.Talepler'></th></cfif>
							<cfif attributes.action_type eq 2><th colspan="2"   ><cf_get_lang_main no='116.Emirler'></th></cfif>
							<th   colspan="2" ><cfif attributes.action_type eq 1><cf_get_lang no='25.Kapama'><cfelseif attributes.action_type eq 2><cf_get_lang no='17.Talep'><cfelseif attributes.action_type eq 3><cf_get_lang no='24.Emir'></cfif></th>
						</tr>
						<cfoutput>
						<tr >
							<th >#session.ep.money#<cf_get_lang_main no='261.Tutar'></td> 
							<th  ><cf_get_lang_main no ='470.İşlem Tutar'></td>
							<th >#session.ep.money# <cf_get_lang_main no='261.Tutar'></td>
							<th ><cf_get_lang_main no ='470.İşlem Tutar'></td>
							<cfif attributes.action_type eq 2>
							<th >#session.ep.money# <cf_get_lang_main no='261.Tutar'></td>
							<th ><cf_get_lang_main no ='470.İşlem Tutar'></td>
							</cfif>
							<cfif attributes.action_type eq 3>
							<th >#session.ep.money# <cf_get_lang_main no='261.Tutar'></td>
							<th ><cf_get_lang_main no ='470.İşlem Tutar'></td>
							</cfif>
							<th >#session.ep.money# <cf_get_lang_main no='261.Tutar'></td>
							<th ><cf_get_lang_main no ='470.İşlem Tutar'></td>
						</tr>
						</cfoutput>
						<cfoutput query="GET_CARI_CLOSED">
							<cfquery name="GET_ALL_ACTION" datasource="#dsn2#">
							SELECT 
								ACTION_ID,
								RELATED_CLOSED_ROW_ID,
								<!--- görebilmek için tüm kolonlar açıldı!!! --->
								SUM(ISNULL(CLOSED_AMOUNT,0)) ALL_CLOSED_AMOUNT,
								SUM(ISNULL(P_ORDER_VALUE,0)) ALL_ORDER_AMOUNT,
								SUM(CLOSED_AMOUNT) CLOSED_AMOUNT,
								SUM(OTHER_CLOSED_AMOUNT) OTHER_CLOSED_AMOUNT,
								SUM(PAYMENT_VALUE) PAYMENT_VALUE,
								SUM(OTHER_PAYMENT_VALUE) OTHER_PAYMENT_VALUE,
								SUM(ISNULL(P_ORDER_VALUE,0)) P_ORDER_VALUE,
								SUM(ISNULL(OTHER_P_ORDER_VALUE,0)) OTHER_P_ORDER_VALUE
							FROM 
								CARI_CLOSED_ROW
							WHERE
								ACTION_ID = #ACTION_ID# AND
								ACTION_TYPE_ID = #ACTION_TYPE_ID# AND
								<cfif ACTION_TABLE is 'INVOICE' OR ACTION_TABLE is 'EXPENSE_ITEM_PLANS'>
									DUE_DATE = #CreateODBCDateTime(DUE_DATE)# AND
								<cfelse>
									CARI_ACTION_ID = #CARI_ACTION_ID# AND
								</cfif>
								OTHER_MONEY = '#OTHER_MONEY#' AND
								CLOSED_ROW_ID = #CLOSED_ROW_ID#
							GROUP BY
								ACTION_ID,
								RELATED_CLOSED_ROW_ID
							</cfquery>
							<tr>
								<td ><cfif len(paper_no)>#paper_no#<cfelse>&nbsp;</cfif></td>
								<td ><cfif len(action_name)>#action_name#<cfelse>&nbsp;</cfif></td>
								<td >#dateformat(action_date,dateformat_style)#</td>
								<td ><cfif len(get_cari_closed.due_date)>#datediff("d",action_date, get_cari_closed.due_date)#<cfelse>0</cfif></td>
								<td >#dateformat(get_cari_closed.due_date ,dateformat_style)#</td>
								<td  style="text-align:right;">#TLFormat(get_cari_closed.CR_ACTION_VALUE)#&nbsp;#session.ep.money#</td>
								<td  style="text-align:right;"><cfif len(other_cash_act_value)>#TLFormat(other_cash_act_value)#&nbsp;#other_money#</cfif></td>
								<td  style="text-align:right;">#TLFormat(get_all_action.CLOSED_AMOUNT)#&nbsp;#session.ep.money#</td>
								<td  style="text-align:right;">#TLFormat(get_all_action.OTHER_CLOSED_AMOUNT)# #I_OTHER_MONEY#</td>
								<cfif attributes.action_type eq 3>
									<td  style="text-align:right;">#TLFormat(get_all_action.PAYMENT_VALUE)#&nbsp;#session.ep.money#</td>
									<td   style="text-align:right;">#TLFormat(get_all_action.OTHER_PAYMENT_VALUE)# #I_OTHER_MONEY#</td>
								</cfif>
								<cfif attributes.action_type eq 2>
									<td style="text-align:right;" >#TLFormat(get_all_action.P_ORDER_VALUE)#&nbsp;#session.ep.money#</td>
									<td  style="text-align:right;">#TLFormat(get_all_action.OTHER_P_ORDER_VALUE)# #I_OTHER_MONEY#</td>
								</cfif>
								<td  style="text-align:right;">#TLFormat(closed_amount)#&nbsp;#session.ep.money#</td>
								<td  style="text-align:right;">#tlformat(OTHER_CLOSED_AMOUNT)#&nbsp;#other_money#</td>
							</tr>
						</cfoutput>
					</table>
					<table>
						<tr>
							<td style="height:35px;"><b><cf_get_lang dictionary_id='57673. TUTAR'><cf_get_lang dictionary_id='57771. DETAY'></b></td>
						</tr> 
					</table>
					<table class="print_border" >
					
						<tr>
							<cfif get_closed_.action_id neq 0>
								<th><b><cf_get_lang no='69.Borç Toplamı'></th>
								<th><cf_get_lang no='70.Alacak Toplamı'></th>
							</cfif>
							<th><cfif attributes.action_type eq 1><cf_get_lang no='25.Kapama'><cfelseif attributes.action_type eq 2><cf_get_lang no='17.Talep'><cfelseif attributes.action_type eq 3><cf_get_lang no='24.Emir'></cfif><cf_get_lang no='66.Tutarı'></th>
						</tr>
						<tr>
							<cfif get_closed_.action_id neq 0>
								<td  style="text-align:right;"><cfoutput>#TLFormat(get_invoice_close.debt_amount_value)#</cfoutput></td>
								<td style="text-align:right;"><cfoutput>#TLFormat(get_invoice_close.claim_amount_value)#</cfoutput></td>
							</cfif>
							<cfif (len(GET_CARI_CLOSED.from_cmp_id) and len(get_invoice_close.company_id) and GET_CARI_CLOSED.from_cmp_id eq get_invoice_close.company_id) or (len(GET_CARI_CLOSED.from_consumer_id) and len(get_invoice_close.consumer_id) and GET_CARI_CLOSED.from_consumer_id eq get_invoice_close.consumer_id)>
								<td style="text-align:right;"><cfoutput>#TLFormat(get_invoice_close.difference_amount_value)#</cfoutput></td>
							<cfelse>
								<td style="text-align:right;"><cfoutput>#TLFormat(get_invoice_close.difference_amount_value)#</cfoutput></td>
							</cfif>
                        </tr>
					</table>
					<table>
						</br>
							<tr class="fixed">
								<td style="font-size:9px!important;"><b><cf_get_lang dictionary_id='61710.© Copyright'></b> <cfoutput>#check.COMPANY_NAME#</cfoutput> <cf_get_lang dictionary_id='61711.dışında kullanılamaz, paylaşılamaz.'></td>
							</tr>
						</br>
					</table>
				</table>
			</td>
		</tr>
	</table>
	<cfif sayfa_sayisi neq j>
		<div style="page-break-after: always">&nbsp;</div>
	</cfif>
	<cfset satir_start = satir_start + 25>
	<cfset satir_end = satir_start + 24>
</cfloop>
<cf_get_lang_set module_name="#lcase(listgetat(attributes.fuseaction,1,'.'))#"><!--- sayfanin en ustunde acilisi var --->
