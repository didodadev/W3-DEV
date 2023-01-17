<cfparam name="attributes.EMP_ID" default="">
<link rel="stylesheet" href="/css/assets/template/catalyst/print.css" type="text/css">
<cfquery name="GET_MONEY_RATE" datasource="#dsn#">
	SELECT * FROM SETUP_MONEY WHERE PERIOD_ID = #SESSION.EP.PERIOD_ID# AND MONEY_STATUS = 1 AND RATE1 = RATE2
</cfquery>
<cfset url.id = attributes.action_id>
<cfquery name="GET_VOUCHER_HISTORY" datasource="#dsn2#">
	SELECT COUNT(VOUCHER_ID) AS KAYIT FROM VOUCHER_HISTORY WHERE PAYROLL_ID = #URL.ID#
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
<cfquery name="GET_ACTION_DETAIL" datasource="#dsn2#">
	SELECT * FROM VOUCHER_PAYROLL WHERE ACTION_ID = #URL.ID#
</cfquery>

<cfif GET_ACTION_DETAIL.recordcount and len(GET_ACTION_DETAIL.PAYROLL_ACCOUNT_ID)>
	<cfquery name="GET_ACCOUNTS" datasource="#DSN3#">
		SELECT
			ACCOUNTS.*,
			BANK_BRANCH.BANK_NAME,
			BANK_BRANCH.BANK_BRANCH_NAME
		FROM
			ACCOUNTS,	
			BANK_BRANCH
		WHERE
			ACCOUNTS.ACCOUNT_ID=#GET_ACTION_DETAIL.PAYROLL_ACCOUNT_ID# AND
			ACCOUNTS.ACCOUNT_BRANCH_ID = BANK_BRANCH.BANK_BRANCH_ID
		ORDER BY
			ACCOUNTS.ACCOUNT_NAME
	</cfquery>
</cfif>

<cfset list_para_birim = ''>
<cfset list_para_birim = ListDeleteDupLicates(valuelist(GET_VOUCHER_DETAIL.CURRENCY_ID,','))>
<cfset voucher_total_value = 0>
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
<cfif not ListFind("99,100",get_action_detail.payroll_type,',')>
	<script type="text/javascript">
		alert("Belge tipi uygun değil!");
	</script>
	<cfexit method="exittemplate">
</cfif>
<cfoutput query="GET_VOUCHER_DETAIL">
	<cfif (currentrow eq 1) or (GET_VOUCHER_DETAIL.currency_id eq GET_VOUCHER_DETAIL.currency_id[currentrow-1])>
		<cfset voucher_total_value = voucher_total_value + VOUCHER_VALUE>
	<cfelse>
		<cfset voucher_total_value = ''>
	</cfif>
</cfoutput>
<table style="width:210mm">
	<tr>
		<td>
			<table width="100%">
				<tr class="row_border">
					<td class="print-head">
						<table style="width:100%;">  
							<tr>
								<cfif GET_ACTION_DETAIL.payroll_type eq 99>
									<td class="print_title"><cfoutput><cf_get_lang_main no='599.Senet Çıkış Bordrosu'>-<cf_get_lang_main no='109.Banka'> (<cf_get_lang_main no="2223.Tahsil">)</cfoutput></td>
								<cfelseif GET_ACTION_DETAIL.payroll_type eq 100>
									<td class="print_title"><cfoutput><cf_get_lang_main no='599.Senet Çıkış Bordrosu'>-<cf_get_lang_main no='109.Banka'>(<cf_get_lang_main no='1277.Teminat'>)</cfoutput></td>
								</cfif>
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
						<cfset cumle = ''>
						<table>
							<tr>
								<td style="width:140px"><b><cf_get_lang dictionary_id='33983.Bordro No'></th>
								<td><cfoutput>#get_action_detail.PAYROLL_NO#</cfoutput></td>
							</tr>
							<tr>
								<td style="width:140px"><b><cf_get_lang_main no="2222.Senet Sayısı"></b></td>
								<td> <cfoutput>#GET_VOUCHER_HISTORY.KAYIT#</cfoutput> </td>
							</tr>
							<tr>
								<td><b><cf_get_lang_main no='109.Banka'></b></td>
								<td> <cfoutput><cfif GET_ACTION_DETAIL.recordcount>#GET_ACCOUNTS.BANK_NAME#</cfif></cfoutput></td>
							</tr>
							<tr>
								<td style="width:140px"><b><cf_get_lang_main no='41.Şube'></b></td>
								<td> <cfoutput><cfif GET_ACTION_DETAIL.recordcount>#GET_ACCOUNTS.BANK_BRANCH_NAME#</cfif></cfoutput></td>
							</tr>
							<tr>
								<td style="width:140px"><b><cf_get_lang_main no='766.Hesap Numarası'></b></td>
								<td> <cfoutput><cfif GET_ACTION_DETAIL.recordcount>#GET_ACCOUNTS.ACCOUNT_NO#</cfif></cfoutput></td>
							</tr>
							<tr>
								<td style="width:140px"><b><cf_get_lang_main no='330.Tarih'></b></td>
								<td> <cfoutput>#dateformat(get_action_detail.PAYROLL_REVENUE_DATE,dateformat_style)#</cfoutput></td>
							</tr>
							
						</table>
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
							<td style="text-align:right;">#dateformat(VOUCHER_DUEDATE,dateformat_style)#</td>
							<td style="text-align:right;">#TLFormat(VOUCHER_VALUE)#&nbsp;&nbsp;#currency_id#</td>
						</tr>
					</cfoutput>
					<cfquery name="GET_MONEY" datasource="#dsn2#">
						SELECT * FROM VOUCHER_PAYROLL_MONEY WHERE ACTION_ID = #URL.ID# AND IS_SELECTED = 1
					</cfquery>
					<tr>
						<cfoutput>
						
							<cfif listlen(list_para_birim) eq 1 and list_para_birim neq session.ep.money>
								<th colspan="4" style="text-align:right;"><cf_get_lang_main no='80.Toplam'> #get_voucher_detail.CURRENCY_ID#</td>
								<td style="text-align:right;">#TLFormat(voucher_total_value)# #get_voucher_detail.CURRENCY_ID#</td>	
							<cfelse>
								<th colspan="4" style="text-align:right;"><cf_get_lang_main no='80.Toplam'> #session.ep.money#</td>
								<td style="text-align:right;">#TLFormat(get_action_detail.PAYROLL_TOTAL_VALUE)# #session.ep.money#</td> 
							</cfif>
						</cfoutput>
					</tr>
				</table>
				<br>
				<table>
					<tr>
						<td> <cf_get_lang_main no="2220.Yalnız">
							<cfif listlen(list_para_birim) eq 1 and list_para_birim neq session.ep.money>
								<cfset myNumber = voucher_total_value>
								<b><cf_n2txt number="myNumber" para_birimi="#get_voucher_detail.CURRENCY_ID#"><cfoutput>#myNumber#</b> 'dir</cfoutput> 
							<cfelse>
								<cfset myNumber = get_action_detail.PAYROLL_TOTAL_VALUE>
								<b><cf_n2txt number="myNumber" para_birimi="#get_action_detail.CURRENCY_ID#"><cfoutput>#myNumber#</b>'dir.</cfoutput> 
							</cfif>
						</td>
					</tr>
				</table>
				<table>
					<tr class="fixed" style="height:35px;">
						<td style="font-size:9px!important;" ><b><cf_get_lang dictionary_id='61710.© Copyright'></b> <cfoutput>#check.COMPANY_NAME#</cfoutput> <cf_get_lang dictionary_id='61711.dışında kullanılamaz, paylaşılamaz.'></td>
					</tr>
				</table>
			</table>
		</td>
	</tr>
</table> 
