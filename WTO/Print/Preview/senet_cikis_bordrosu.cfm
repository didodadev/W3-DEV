<cf_get_lang_set module_name="objects">
<link rel="stylesheet" href="/css/assets/template/catalyst/print.css" type="text/css">
<cfparam name="attributes.EMP_ID" default="">
<cfquery name="GET_MONEY_RATE" datasource="#dsn#">
	SELECT
		*
	FROM
		SETUP_MONEY
	WHERE
		PERIOD_ID = #SESSION.EP.PERIOD_ID# AND
		MONEY_STATUS=1 AND 
		RATE1=RATE2
</cfquery>
<cfset url.id=attributes.action_id>
<cfquery name="GET_ACTION_DETAIL" datasource="#dsn2#">
	SELECT
		*
	FROM
		VOUCHER_PAYROLL
	WHERE
		ACTION_ID=#URL.ID#
</cfquery>
<cfquery name="GET_VOUCHER_HISTORY" datasource="#dsn2#">
		SELECT 
			COUNT(VOUCHER_ID) AS KAYIT 
		FROM
			VOUCHER_HISTORY
		WHERE
			PAYROLL_ID = #URL.ID#
</cfquery>

<cfquery name="GET_VOUCHER_DETAIL" datasource="#dsn2#">
	SELECT
		*
	FROM
		VOUCHER_HISTORY,
		VOUCHER
	WHERE 
		VOUCHER_HISTORY.PAYROLL_ID = #URL.ID# AND 
		VOUCHER.VOUCHER_ID = VOUCHER_HISTORY.VOUCHER_ID
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
<cfif GET_ACTION_DETAIL.payroll_type neq 98>
	<script type="text/javascript">
		alert("<cf_get_lang_main no='2221.Belge Tipi Uygun Değil'>!");
	</script>
	<cfexit method="exittemplate">
</cfif>

<table style="width:210mm">
	<tr>
		<td>
			<table width="100%">
				<tr class="row_border">
					<td class="print-head">
						<table style="width:100%;">  
							<tr>
								<td class="print_title">
									<cfif GET_ACTION_DETAIL.PAYROLL_TYPE  eq 98>
										<cf_get_lang_main no='1805.Senet Çikis Iade Bordrosu'>
										<cfset cumle = 'Senet İade Edilmiştir'>
									</cfif>
								</td>
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
						<cfoutput>
							<table>
								<tr>
									<td style="width:140px"><b><cf_get_lang no='1593.Bordro No'></b></td>
									<td>#get_action_detail.PAYROLL_NO#</td>
								</tr>
								<tr>
									<td style="width:140px"><b><cf_get_lang_main no="80.Toplam"> <cf_get_lang_main no="596.Senet"></b></td>
									<td>#GET_VOUCHER_HISTORY.KAYIT#</td>
								</tr>
								<tr>
									<td style="width:140px"><b><cf_get_lang_main no='363.Teslim Alan'></b></td>
										
										<cfif isdefined("get_action_detail.PAYROLL_REV_MEMBER") and len(get_action_detail.PAYROLL_REV_MEMBER)>
										<td>#get_emp_info(get_action_detail.PAYROLL_REV_MEMBER,0,0)#</td>
										</cfif>
								</tr>
								<tr>
									<td style="width:140px"><b><cf_get_lang dictionary_id='57519.cari hesap'></b></td>
									<cfif len(get_action_detail.COMPANY_ID)>
									<td>#get_par_info(get_action_detail.COMPANY_ID,1,1,0)#</td></cfif>
								</tr>
								<tr>
									<td style="width:140px"><b><cf_get_lang_main no='330.Tarih'></b></td>
									<td>#dateformat(get_action_detail.PAYROLL_REVENUE_DATE,dateformat_style)#</td>
								</tr>
							</table>
						</cfoutput>
					</td>
				</tr>
				<table>
					<tr>
						<td style="height:35px;"><b><cf_get_lang dictionary_id='57771. DETAY"'></b></td>
					</tr> 
				</table>
				<table class="print_border" style="width:150mm">
					<tr>
						<th><cf_get_lang_main no='1090.Senet No'></th>
						<th><cf_get_lang_main no='770.Portföy No'></th>
						<th><cf_get_lang_main no='768.Borçlu'></th>
						<th><cf_get_lang_main no='228.Vade'></th>
						<th><cf_get_lang_main no='261.Tutar'></th>
					</tr>
			
					<cfoutput query="GET_VOUCHER_DETAIL">
						<tr>
							<td>#VOUCHER_NO#</td>
							<td>#VOUCHER_PURSE_NO#</td>
							<td>#DEBTOR_NAME#</td>
							<td>#dateformat(VOUCHER_DUEDATE,dateformat_style)#</td>
							<td style="text-align:right;">#TLFormat(OTHER_MONEY_VALUE)# #OTHER_MONEY#</td>
							
						</tr>
					</cfoutput>
						<tr>
							<th colspan="4"  style="text-align:right;"><cf_get_lang_main no='80.Toplam'></th>
							<td style="text-align:right;"> <cfoutput>
							#TLFormat(get_action_detail.PAYROLL_TOTAL_VALUE)# #GET_VOUCHER_DETAIL.OTHER_MONEY#</cfoutput></td>
						</tr>
				</table>
				<table>
					<tr class="fixed" style="height:50px;">
						<td style="font-size:9px!important;" ><b><cf_get_lang dictionary_id='61710.© Copyright'></b> <cfoutput>#check.COMPANY_NAME#</cfoutput> <cf_get_lang dictionary_id='61711.dışında kullanılamaz, paylaşılamaz.'></td>
					</tr>
				</table>
			</table>
		</td>
	</tr>
</table> 
							
		

<cf_get_lang_set module_name="#lcase(listgetat(attributes.fuseaction,1,'.'))#">
