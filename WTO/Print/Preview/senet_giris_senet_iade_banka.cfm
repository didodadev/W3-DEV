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
<cfset list_senet = ''>
<cfset list_senet = ListDeleteDupLicates(valuelist(GET_VOUCHER_DETAIL.CURRENCY_ID,','))>
<cfset senet_toplam = 0>
<cfif GET_ACTION_DETAIL.payroll_type neq 97 and  GET_ACTION_DETAIL.payroll_type neq 108 and  GET_ACTION_DETAIL.payroll_type neq 109>
	<script type="text/javascript">
		alert("Belge tipi uygun değil!");
	</script>
	<cfexit method="exittemplate">
</cfif>
<cfoutput query="GET_VOUCHER_DETAIL">
	<cfif (currentrow eq 1) or (GET_VOUCHER_DETAIL.currency_id eq GET_VOUCHER_DETAIL.currency_id[currentrow-1])>
		<cfset senet_toplam = senet_toplam + VOUCHER_VALUE>
	<cfelse>
		<cfset senet_toplam = ''>
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
								<cfif GET_ACTION_DETAIL.payroll_type eq 97>
									<td class="print_title"><cf_get_lang_main no='598.Senet Giriş Bordrosu'></td>
									<cfset cumle = 'Senet Alınmıştır'>
								<cfelseif GET_ACTION_DETAIL.payroll_type eq 108>
									<td class="print_title"><cf_get_lang_main no='1509.Senet Giriş İade Bordrosu'></td>
									<cfset cumle = 'Senet İade Edilmiştir'>
								<cfelseif GET_ACTION_DETAIL.payroll_type eq 109>
									<td class="print_title"><cf_get_lang_main no='1510.Senet Giriş İade Bordrosu(Banka)'></td>
									<cfset cumle = 'Senet İade Alınmıştır'>
								<cfelse>
									<td class="print_title"><cf_get_lang_main no='30091.Senet İşlemleri'></td>
									<cfset cumle = 'Senet Alınmıştır'>	
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
						<table>
							<cfoutput>
								<tr>
									<td style="width:140px"><b><cf_get_lang no='1593.Bordro No'></b></td>
									<td>#get_action_detail.PAYROLL_NO#</td>
								</tr>
								<tr>
									<td style="width:140px"><b><cf_get_lang_main no="80.Toplam"> <cf_get_lang_main no="596.Senet"></b></td>
									<td>#GET_VOUCHER_HISTORY.KAYIT#</td>
								</tr>
								<tr>
									<td style="width:140px"><b><cf_get_lang dictionary_id='57519.cari hesap'></b></td>
									<cfif len(get_action_detail.COMPANY_ID)>
									<td>#get_par_info(get_action_detail.COMPANY_ID,1,1,0)#</td></cfif>
								</tr>
								<tr>
									<td style="width:140px"><b><cf_get_lang  no='1093.Tahsil Eden'></b></td>
									<cfif isdefined("get_action_detail.REVENUE_COLLECTOR_ID") and len(get_action_detail.REVENUE_COLLECTOR_ID)>
									<td>#get_emp_info(get_action_detail.REVENUE_COLLECTOR_ID,0,0)#</td>
									</cfif>
								</tr>
								
								<tr>
									<td style="width:140px"><b><cf_get_lang_main no='330.Tarih'></b></td>
									<td>#dateformat(get_action_detail.PAYROLL_REVENUE_DATE,dateformat_style)#</td>
								</tr>
								<tr>
									<td style="width:140px"><b><cf_get_lang_main no='449.Ortalama Vade'></b></td>
									<td>#dateformat(get_action_detail.payroll_avg_duedate,dateformat_style)#</td>
								</tr>
							</cfoutput>
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
					<!--- 	<cfif get_voucher_detail.CURRENCY_ID neq session.ep.money or listlen(list_senet) neq 1>
					<th><cfoutput>#session.ep.money#</cfoutput> <cf_get_lang_main no='261.Tutar'></th>
					</cfif> --->
					</tr>
					<cfoutput query="GET_VOUCHER_DETAIL">
					<tr>
						<td>#VOUCHER_NO#</td>
						<td>#VOUCHER_PURSE_NO#</td>
						<td>#DEBTOR_NAME#</td>
						<td>#dateformat(VOUCHER_DUEDATE,dateformat_style)#</td>
						<td style="text-align:right;">#TLFormat(VOUCHER_VALUE)# #CURRENCY_ID#</td>
						<!--- <cfif CURRENCY_ID neq session.ep.money>
						<td style="text-align:right;">#TLFormat(OTHER_MONEY_VALUE)# #OTHER_MONEY#</td>
						</cfif> --->
					</tr>
					</cfoutput>
			
						<cfquery name="GET_MONEY" datasource="#dsn2#">
							SELECT
								*
							FROM
								VOUCHER_PAYROLL_MONEY
							WHERE
								ACTION_ID = #URL.ID# AND
								IS_SELECTED=1
						</cfquery>
					<tr>
						<!--- <cfif listlen(list_senet) eq 1 and list_senet neq session.ep.money>
							<cfoutput> 
							<th colspan="4" style="text-align:right;"><cf_get_lang_main no='80.Toplam'> #get_voucher_detail.CURRENCY_ID#</td>
							<td style="text-align:right;"> #TLFormat(senet_toplam)# #get_voucher_detail.CURRENCY_ID#</td>
							</cfoutput>	
						</cfif> --->
						
						<th colspan="4" style="text-align:right;"><cf_get_lang_main no='80.Toplam'></th>
						<td style="text-align:right;"><cfoutput>#TLFormat(get_action_detail.PAYROLL_TOTAL_VALUE)# #get_voucher_detail.CURRENCY_ID#</cfoutput></td>
					</tr>
				</table>
				<table >
					<cfoutput>
						<tr>
							<td style="height:50px;">
								#get_par_info(get_action_detail.COMPANY_ID,1,1,0)#<cf_get_lang no="826.cari hesabına mahsuben"> 
							<cfif listlen(list_senet) neq 1 or list_senet is session.ep.money>
								<cfset myNumber = get_action_detail.PAYROLL_TOTAL_VALUE>
								<cf_n2txt number="myNumber" para_birimi="#get_action_detail.CURRENCY_ID#"><td>#myNumber# #cumle#</td>
							<cfelseif listlen(list_senet) eq 1 and not list_senet is session.ep.money>
								<cfset myNumber = senet_toplam>
								<cfset cumle = ''>
								<cf_n2txt number="myNumber" para_birimi="#list_senet#"><td>#myNumber# #cumle#</td>
							</cfif>
							</td>
						</tr>
					</cfoutput>
				</table>
				<table>
					<tr class="fixed">
						<td style="font-size:9px!important;"><b><cf_get_lang dictionary_id='61710.© Copyright'></b> <cfoutput>#check.COMPANY_NAME#</cfoutput> <cf_get_lang dictionary_id='61711.dışında kullanılamaz, paylaşılamaz.'></td>
					</tr>
				</table>	
			</table>
		</td>
	</tr>
</table>
<cf_get_lang_set module_name="#lcase(listgetat(attributes.fuseaction,1,'.'))#">
