<!--- FBS 20080805 toplu odeme kosullari eklendi --->
<cf_get_lang_set module_name="cash"><!--- sayfanin en altinda kapanisi var --->
<link rel="stylesheet" href="/css/assets/template/catalyst/print.css" type="text/css">
<cfif isdefined("attributes.keyword") and attributes.keyword is 'multi_payment'>
	<cfset table_name = "CASH_ACTIONS">
	<cfset column_name = "MULTI_ACTION_ID">
<cfelse>
	<cfset table_name = "CASH_ACTIONS">
	<cfset column_name = "ACTION_ID">
</cfif>
<cfquery name="get_action_detail" datasource="#dsn2#">
	SELECT
		*
	FROM
		#table_name#
	WHERE
		#column_name# = #attributes.action_id#
	ORDER BY
		ACTION_ID
</cfquery>
<cfquery name="get_cashes" datasource="#dsn2#">
	SELECT * FROM CASH WHERE CASH_ID = #get_action_detail.cash_action_from_cash_id#
</cfquery>
<cfquery name="get_action_rate" datasource="#dsn#">
	SELECT * FROM SETUP_MONEY WHERE PERIOD_ID = #session.ep.period_id# AND MONEY = '#get_cashes.cash_currency_id#'
</cfquery>
<!--- <cfquery name="check" datasource="#dsn#">
	SELECT
		COMPANY_NAME,
		TEL_CODE,
		TEL,
		TEL2,
		TEL3,
		TEL4,
		FAX,
		ADDRESS,
		WEB,
		EMAIL,
		ASSET_FILE_NAME3,
		ASSET_FILE_NAME3_SERVER_ID,
		TAX_OFFICE,
		TAX_NO
	FROM
		OUR_COMPANY
	WHERE
		<cfif isDefined("session.ep.company_id")>
			COMP_ID = #session.ep.company_id#
		<cfelseif isDefined("session.pp.company")>	
			COMP_ID = #session.pp.company_id#
		</cfif> 
</cfquery> --->
<cfquery name="check" datasource="#DSN#">
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

<cfset genel_toplam = 0>
<cfloop query="get_action_detail">
	<cfoutput>
		<table style="width:210mm">
			<tr>
				<td>
					<table width="100%">
						<tr class="row_border">
							<td class="print-head">
								<table style="width:100%;">
									<tr>
										<td class="print_title"><cf_get_lang dictionary_id='57847.ÖDEME'></b></td>
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
								<table>
									<tr>
										<td style="width:140px"><b><cf_get_lang no='107.Tediye Makbuzu No'></b></td>
										<td>#get_action_detail.paper_no#</td>
									</tr>
									<tr>
										<cfif len(get_action_detail.CASH_ACTION_TO_COMPANY_ID)>
											<td   style="width:140px"> <b><cf_get_lang dictionary_id='57519.Cari Hesap'></b></td>
											<td>#get_par_info(get_action_detail.CASH_ACTION_TO_COMPANY_ID,1,1,0)#</td>
										</cfif>
									</tr>
									<tr>
										<td style="width:140px"><b><cf_get_lang_main no='215.Kayıt Tarihi'></b></td>
										<td> #dateformat(get_action_detail.record_date,dateformat_style)#</td>
									</tr>
									<tr>
										<td style="width:140px"><b><cf_get_lang_main no='330.Tarih'></b></td>
										<td>#dateformat(get_action_detail.ACTION_DATE,dateformat_style)#</td>
									</tr>
									<tr>
										<td style="width:140px"><b><cf_get_lang_main no='217.Açıklama'></b></td>
										</td><td>  #get_action_detail.action_detail#</td>
									</tr>
								</table>
							</td>
						</tr>
						<table>
                            <tr>
                                <td  style="height:35px;"><b><cf_get_lang dictionary_id='57771.detay'></b></td>
                            </tr>
                        </table>
                        <table class="print_border" style="width:80mm;" >
							<tr>
								
								<th><b><cf_get_lang no='112.Ödemeyi Yapan'></b>
								</th><th><b><cf_get_lang_main no='1233.Nakit'></b></th>	
								<th><b><cf_get_lang_main no='80.Toplam'></b></th>
							</tr>
							<tr>
								<cfset genel_toplam = genel_toplam + get_action_detail.CASH_ACTION_VALUE>
								<cfif len(get_action_detail.PAYER_ID)><td>#get_emp_info(get_action_detail.PAYER_ID,0,0)#</cfif></td>
								<td style="text-align:right;"> #TLFormat(get_action_detail.CASH_ACTION_VALUE)#&nbsp;#get_action_rate.MONEY#</td>
								<td style="text-align:right;">#TLFormat(genel_toplam)# #get_action_rate.money#</td>
							</tr>
						</table>	
						<table >
							<tr>
								<td style="height:50px;">
								<cfif len(get_action_detail.CASH_ACTION_TO_EMPLOYEE_ID)>
									<td>#get_emp_info(get_action_detail.CASH_ACTION_TO_EMPLOYEE_ID,0,0)#</td>
								</cfif>
								<cf_get_lang no='108.Hesabına Mahsuben Yalnız'>
								<cfset mynumber = get_action_detail.CASH_ACTION_VALUE >
								<cfset mybirim = '#get_cashes.CASH_CURRENCY_ID#'>
								<cf_n2txt number="myNumber" para_birimi="#mybirim#">
								#mynumber#
								<cf_get_lang no='109.Ödenmiştir'>
								</td>
							</tr>
						</table>
						<table>
							<tr class="fixed">
								<td style="font-size:9px!important;"style="height:35px;" ><b><cf_get_lang dictionary_id='61710.© Copyright'></b> <cfoutput>#check.COMPANY_NAME#</cfoutput> <cf_get_lang dictionary_id='61711.dışında kullanılamaz, paylaşılamaz.'></td>
							</tr>
							
						</table>
					</table>
				</td>
			</tr>
		</table>
	</cfoutput>
</cfloop>
<cf_get_lang_set module_name="#lcase(listgetat(attributes.fuseaction,1,'.'))#"><!--- sayfanin en ustunde acilisi var --->
