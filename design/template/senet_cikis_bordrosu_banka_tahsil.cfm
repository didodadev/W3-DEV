<cfparam name="attributes.EMP_ID" default="">
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
	<cfif isDefined("SESSION.EP.COMPANY_ID")>
	    COMP_ID = #SESSION.EP.COMPANY_ID#
	<cfelseif isDefined("SESSION.PP.COMPANY")>	
	    COMP_ID = #session.pp.company_id#
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
<div align="center">
<br/>
<table width="650" border="0" cellspacing="0" cellpadding="0">
	<tr> 
		<cfif len(CHECK.asset_file_name3)>
			<td style="text-align:right;">
				<cfoutput>
					<cf_get_server_file output_file="settings/#CHECK.asset_file_name3#" output_server="#CHECK.asset_file_name3_server_id#" output_type="5">
				</cfoutput>
			</td>
		</cfif>
		<td style="width:10mm;">&nbsp;</td>
		<td valign="top">
			<cfoutput QUERY="CHECK">
				<strong style="font-size:14px;">#company_name#</strong><br/>
				#address#<br/>
				<b><cf_get_lang_main no='87.Telefon'>: </b> (#tel_code#) - #tel#  #tel2#  #tel3# #tel4# <br/>
				<b><cf_get_lang_main no='76.Fax'>: </b> #fax# <br/>
				<b><cf_get_lang_main no='1350.Vergi Dairesi'> : </b> #TAX_OFFICE# <b><cf_get_lang_main no='75.No'> : </b> #TAX_NO#<br/>
				#web# - #email#
			</cfoutput>
		</td>
	</tr>
	<tr>
		<td colspan="3"><hr></td>
	</tr>
</table>
<br/>
<table width="100%" height="30">
	<tr>
		<cfif GET_ACTION_DETAIL.payroll_type eq 99>
			<td align="center" class="formbold"><cfoutput><b><cf_get_lang_main no='599.Senet Çıkış Bordrosu'>-<cf_get_lang_main no='109.Banka'></b> &nbsp;&nbsp;(<cf_get_lang_main no="2223.Tahsil">)</cfoutput></td>
		<cfelseif GET_ACTION_DETAIL.payroll_type eq 100>
			<td align="center" class="formbold"><cfoutput><b><cf_get_lang_main no='599.Senet Çıkış Bordrosu'>-<cf_get_lang_main no='109.Banka'></b> &nbsp;&nbsp;(<cf_get_lang_main no='1277.Teminat'>)</cfoutput></td>
		</cfif>
	</tr>
</table>
<cfset cumle = ''>
<table width="100%" height="30">
	<tr>
		<td align="center" class="formbold">
			<cfif isdefined("attributes.type")>
				<cfif attributes.type eq 99>
					<cfoutput><b><cf_get_lang_main no='1803.Senet Çıkış Bord-Banka Tahsil'></b></cfoutput>
					<cfset cumle = 'Senet Tahsil Edilmiştir'>
				<cfelseif attributes.type eq 100>
					<cfoutput><b><cf_get_lang_main no='1804.Senet Çıkış Bord-Banka Teminat'></b></cfoutput>
					<cfset cumle = 'Senet Tahsil Edilmiştir'>
				</cfif>
			</cfif>
		</td>
	</tr>
</table>
<table width="650">
	<tr>
		<td><cf_get_lang no='1593.Bordro No'>: <cfoutput><strong>#get_action_detail.PAYROLL_NO#</strong></cfoutput></td>
		<td style="text-align:right;"><cf_get_lang_main no='330.Tarih'>: <cfoutput><strong>#dateformat(get_action_detail.PAYROLL_REVENUE_DATE,dateformat_style)#</strong></cfoutput></td>
	</tr>
	<tr>
		<td colspan="2"><cf_get_lang_main no='109.Banka'> : <cfoutput><cfif GET_ACTION_DETAIL.recordcount><strong>#GET_ACCOUNTS.BANK_NAME#</strong></cfif></cfoutput></td>
	</tr>
	<tr>
		<td><cf_get_lang_main no='41.Şube'> : <cfoutput><strong><cfif GET_ACTION_DETAIL.recordcount>#GET_ACCOUNTS.BANK_BRANCH_NAME#</strong></cfif></cfoutput></td>
	</tr>
	<tr>
		<td><cf_get_lang_main no='766.Hesap Numarası'> :<cfoutput><strong><cfif GET_ACTION_DETAIL.recordcount>#GET_ACCOUNTS.ACCOUNT_NO#</strong></cfif></cfoutput></td>
	</tr>
	<tr>
		<td><cf_get_lang_main no="2222.Senet Sayısı"> : <cfoutput><strong>#GET_VOUCHER_HISTORY.KAYIT#</cfoutput> </strong></td>
	</tr>
	<tr>
		<td height="30" colspan="2">&nbsp;</td>
	</tr>
</table>
<table width="650">
	<tr height="22" class="txtbold">
		<td><cf_get_lang_main no='1090.Senet No'></td>
		<td><cf_get_lang_main no='770.Portföy No'></td>
		<td><cf_get_lang_main no='768.Borçlu'></td>
		<td><cf_get_lang_main no='228.Vade'></td>
		<td><cf_get_lang_main no='261.Tutar'></td>
	</tr>
	<cfoutput query="GET_VOUCHER_DETAIL">
		<tr>
			<td>#VOUCHER_NO#</td>
			<td>#VOUCHER_PURSE_NO#</td>
			<td>#DEBTOR_NAME#</td>
			<td>#dateformat(VOUCHER_DUEDATE,dateformat_style)#</td>
			<td>#TLFormat(VOUCHER_VALUE)#&nbsp;&nbsp;#currency_id#</td>
		</tr>
		<tr valign="top">
			<td colspan="5"><hr></td>
		</tr>
	</cfoutput>
</table>
<cfquery name="GET_MONEY" datasource="#dsn2#">
	SELECT * FROM VOUCHER_PAYROLL_MONEY WHERE ACTION_ID = #URL.ID# AND IS_SELECTED = 1
</cfquery>
<table width="650" border="0">
	<tr>
		<td style="text-align:right;">
		<table border="0">
			<tr>
				<cfoutput>
					<td>&nbsp;</td>
					<td>&nbsp;</td>
					<cfif listlen(list_para_birim) eq 1 and list_para_birim neq session.ep.money>
						<td><strong><cf_get_lang_main no='80.Toplam'> #get_voucher_detail.CURRENCY_ID#</strong></td>
						<td>: #TLFormat(voucher_total_value)# #get_voucher_detail.CURRENCY_ID#</td>	
					<cfelse>
						<td><strong><cf_get_lang_main no='80.Toplam'> #session.ep.money#</strong></td>
						<td>: #TLFormat(get_action_detail.PAYROLL_TOTAL_VALUE)# #session.ep.money#</td> 
					</cfif>
				</cfoutput>
			</tr>
		</table>
		</td>
	</tr>
	<tr>
		<td> <cf_get_lang_main no="2220.Yalnız">
			<cfif listlen(list_para_birim) eq 1 and list_para_birim neq session.ep.money>
				<cfset myNumber = voucher_total_value>
				<cf_n2txt number="myNumber" para_birimi="#get_voucher_detail.CURRENCY_ID#"><cfoutput><strong>#myNumber#</strong>'dir</cfoutput>  
			<cfelse>
				<cfset myNumber = get_action_detail.PAYROLL_TOTAL_VALUE>
				<cf_n2txt number="myNumber" para_birimi="#get_action_detail.CURRENCY_ID#"><cfoutput><strong>#myNumber#</strong>'dir.</cfoutput> 
			</cfif>
		</td>
	</tr>
</table>  
</div>
