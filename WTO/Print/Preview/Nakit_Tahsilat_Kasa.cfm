<cf_get_lang_set module_name="cash"><!--- sayfanin en altinda kapanisi var --->
<!--- Standart Print Sablonu Kasa Nakit Tahsilat Islemi FB 20080115 --->
<link rel="stylesheet" href="/css/assets/template/catalyst/print.css" type="text/css">
<cfif isdefined("attributes.keyword") and attributes.keyword is 'is_multi'>
	<cfquery name="get_action_detail" datasource="#dsn2#">
		SELECT
			CM.*,
			CA.CASH_ACTION_FROM_COMPANY_ID,
			CA.CASH_ACTION_FROM_CONSUMER_ID,
			CA.CASH_ACTION_FROM_EMPLOYEE_ID,
			CA.OTHER_CASH_ACT_VALUE,
			CA.PROJECT_ID,
			CA.PAPER_NO,
			CA.CASH_ACTION_VALUE,
			CA.CASH_ACTION_CURRENCY_ID,
			CA.ACTION_DETAIL,
			CA.ACTION_ID,
			CA.OTHER_MONEY AS ACTION_CURRENCY,
			CA.REVENUE_COLLECTOR_ID,
			CM.UPD_STATUS
		FROM
			CASH_ACTIONS_MULTI CM,
			CASH_ACTIONS CA
		WHERE
			CM.MULTI_ACTION_ID = CA.MULTI_ACTION_ID 
			AND CM.MULTI_ACTION_ID = #attributes.action_id#
	</cfquery>
<cfelse>
	<cfquery name="get_action_detail" datasource="#dsn2#">
		SELECT * FROM CASH_ACTIONS WHERE ACTION_ID = #attributes.action_id#
	</cfquery>
</cfif>
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
<cfoutput query="get_action_detail">
	<table style="width:210mm">
		<tr>
			<td>
				<table width="100%">
					<tr class="row_border">
						<td class="print-head">
							<table style="width:100%;">  
								<tr>
									<td class="print_title"><cf_get_lang dictionary_id='34286.tahsilatlar'></td></td>
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
								<tr>
									<td style="width:140px"><b><cf_get_lang no='117.Tahsilat Makbuzu No'></b></td>
									<td>#get_action_detail.paper_no#</td>
										
								</tr>
								<tr>
									<td style="width:140px"><b><cf_get_lang dictionary_id='57519.cari hesap'></b></td>
									<cfif len(get_action_detail.CASH_ACTION_FROM_COMPANY_ID)>
									<td>#get_par_info(get_action_detail.CASH_ACTION_FROM_COMPANY_ID,1,1,0)#</td></cfif>
								</tr>
								<tr>
									<td style="width:140px"><b><cf_get_lang no='22.Tahsil Eden'></b></td>
									<td> <cfif len(get_action_detail.revenue_collector_id)>#get_emp_info(get_action_detail.revenue_collector_id,0,0)#</cfif></td>
								</tr>
								<tr>
									<td style="width:140px"><b><cf_get_lang_main no='1233.Nakit'></b></td>
									<td> #TLFormat(get_action_detail.CASH_ACTION_VALUE)#&nbsp;#get_action_detail.cash_action_currency_id#</td>
								</tr>
									
								<tr>
									<td style="width:140px"><b><cf_get_lang_main no='330.Tarih'></b></td>
										<td>#dateformat(get_action_detail.action_date,dateformat_style)#</td>
								</tr>
								<tr>
									<td style="width:140px"><b><cf_get_lang dictionary_id='57629.açıklama'></b></td><td>#get_action_detail.ACTION_DETAIL#</td>
								</tr>
							</table>
						</td>
					</tr>
					<table>
						<tr>
							<td style="height:40px;">
							
							<cf_get_lang no='108.Hesabına Mahsuben Yalnız'>
							<cfset mynumber = get_action_detail.cash_action_value>
							<cfset mybirim = get_action_detail.cash_action_currency_id>
							<cf_n2txt number="mynumber" para_birimi="#mybirim#">#myNumber#
							<cf_get_lang no='119.Tahsil Edilmiştir'>
							
							</td>
						</tr>
					</table>
					<table>
						<tr class="fixed">
							<td style="font-size:9px!important;" style="height:40px;"><b><cf_get_lang dictionary_id='61710.© Copyright'></b> <cfoutput>#check.COMPANY_NAME#</cfoutput> <cf_get_lang dictionary_id='61711.dışında kullanılamaz, paylaşılamaz.'></td>
						</tr>
					</table>
				</table>
			</td>
		</tr>
	</table>
</cfoutput>
<cf_get_lang_set module_name="#lcase(listgetat(attributes.fuseaction,1,'.'))#"><!--- sayfanin en ustunde acilisi var --->

