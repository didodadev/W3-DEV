<!--- Çek iade Çıkış Bordrosu --->
<cf_get_lang_set module_name="cheque"><!--- sayfanin en altinda kapanisi var --->
<cfquery name="GET_MONEY_RATE" datasource="#dsn2#">
	SELECT
		*
	FROM
		PAYROLL_MONEY
	WHERE
		ACTION_ID = #attributes.ACTION_ID# AND
		IS_SELECTED=1
</cfquery>
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
<cfset url.id=attributes.ACTION_ID>
<cfquery name="GET_ACTION_DETAIL" datasource="#dsn2#">
	SELECT
		*
	FROM
		PAYROLL
	WHERE
		ACTION_ID=#URL.ID#
		AND
		PAYROLL_TYPE = 94
</cfquery>
<cfquery name="GET_CHEQUE_HISTORY" datasource="#dsn2#">
	SELECT 
		COUNT(CHEQUE_ID) AS KAYIT 
	FROM
		CHEQUE_HISTORY
	WHERE
		PAYROLL_ID = #URL.ID#
</cfquery>
<cfquery name="GET_CHEQUE_DETAIL" datasource="#dsn2#">
	SELECT
		C.CHEQUE_NO,
		C.ACCOUNT_NO,
		C.BANK_NAME,
		C.BANK_BRANCH_NAME,
		C.CHEQUE_DUEDATE,
		C.CHEQUE_VALUE,
		C.OTHER_MONEY_VALUE,
		C.OTHER_MONEY,
		CH.OTHER_MONEY_VALUE OMV,
		CH.OTHER_MONEY OM,
		C.CURRENCY_ID,
        C.CHEQUE_PURSE_NO
	FROM
		CHEQUE_HISTORY CH,
		CHEQUE C
	WHERE
		CH.PAYROLL_ID = #url.id# 
		AND
		C.CHEQUE_ID = CH.CHEQUE_ID
	ORDER BY C.CHEQUE_PURSE_NO ASC
</cfquery>
<cfset list_birim2 = ''>
<cfset list_birim2 = ListDeleteDupLicates(valuelist(GET_CHEQUE_DETAIL.CURRENCY_ID,','))>
<cfset cheque_total = 0>
<cfif GET_ACTION_DETAIL.payroll_type neq 94>
	<script type="text/javascript">
		alert("Belge tipi uygun değil!");
	</script>
	<cfexit method="exittemplate">
</cfif>
<cfoutput query="GET_CHEQUE_DETAIL">
	<cfif (currentrow eq 1) or (GET_CHEQUE_DETAIL.currency_id eq GET_CHEQUE_DETAIL.currency_id[currentrow-1])>
		<cfset cheque_total = cheque_total + CHEQUE_VALUE>
	</cfif>
</cfoutput>
<div align="center">
<br/>
<table width="650" border="0" cellspacing="0" cellpadding="0">
	<tr> 
	<cfif len(CHECK.asset_file_name3)>
		<td align="left">
			<cfoutput><cf_get_server_file output_file="settings/#CHECK.asset_file_name3#" output_server="#CHECK.asset_file_name3_server_id#" output_type="5"></cfoutput>
		</td>
	</cfif>
		<td style="width:10mm;">&nbsp;</td>
		<td valign="top">
		<cfoutput QUERY="CHECK">
			<strong style="font-size:14px;">#company_name#</strong><br/>
			#address#<br/>
			<b><cf_get_lang_main no='87.Telefon'>: </b> (#tel_code#) - #tel#  #tel2#  #tel3# #tel4# <br/>
			<b><cf_get_lang_main no='76.Fax'>: </b> #fax# <br/>
			<b><cf_get_lang_main no='1350.Vergi Dairesi'> : </b> #TAX_OFFICE# <b><cf_get_lang_main no='340.No'> : </b> #TAX_NO#<br/>
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
		<td style="text-align:center" class="formbold">
			<b><cf_get_lang_main no='445.Çek İade Çıkış Bordrosu'></b>
		</td>
	</tr>
</table>
<table width="650">
	<tr>
		<td><cfoutput>#getLang('objects',1593)#</cfoutput> : <cfoutput><strong>#get_action_detail.PAYROLL_NO#</strong></cfoutput></td>
		<td style="text-align:right;"><cf_get_lang_main no='330.Tarih'>:
			<cfoutput><strong>#dateformat(get_action_detail.PAYROLL_REVENUE_DATE,dateformat_style)#</strong></cfoutput>
		</td>
	</tr>
	<tr>
		<td height="50" colspan="3">
		<cfif len(get_action_detail.COMPANY_ID)>
			<cfoutput><strong>#get_par_info(get_action_detail.COMPANY_ID,1,1,0)#</strong></cfoutput>
		</cfif>
		<cfoutput>#getLang('objects',826)#</cfoutput>
		<cfif listlen(list_birim2) eq 1 and list_birim2 neq session.ep.money>
			<cfset myNumber = cheque_total>
			<cf_n2txt number="myNumber" para_birimi="#get_cheque_detail.CURRENCY_ID#"><cfoutput><strong>#myNumber#</strong></cfoutput> 
			<cfoutput>#getLang('objects',827)#</cfoutput>
		<cfelse>
			<cfset myNumber = get_action_detail.PAYROLL_TOTAL_VALUE>
			<cf_n2txt number="myNumber" para_birimi="#get_action_detail.CURRENCY_ID#"><cfoutput><strong>#myNumber#</strong></cfoutput> 
			<cfoutput>#getLang('objects',827)#</cfoutput>
		</cfif>
		</td>
	</tr>
</table>
<table width="650">
	<tr height="18" class="txtbold">
		<td><cf_get_lang_main no='595.Çek'> <cf_get_lang_main no='75.No'></td>
		<td><cf_get_lang_main no='770.Portföy No'></td>
		<td><cf_get_lang_main no='109.Banka'></td>
		<td><cf_get_lang_main no='41.Şube'></td>
		<td><cf_get_lang_main no='766.Hesap No'></td>
		<td><cf_get_lang_main no='228.Vade'></td>
		<td><cf_get_lang_main no='261.Tutar'></td>
		<cfif get_cheque_detail.CURRENCY_ID neq session.ep.money or listlen(list_birim2) neq 1>
			<td><cfoutput>#session.ep.money#</cfoutput> <cf_get_lang_main no='261.Tutar'></td>
		</cfif>
	</tr>
<!--- Burasi cek sayisi kadar artacak..--->
	<cfoutput query="GET_CHEQUE_DETAIL">
	<tr>
		<td>#CHEQUE_NO#</td>
		<td>#CHEQUE_PURSE_NO#</td>
		<td>#BANK_NAME#</td>
		<td>#BANK_BRANCH_NAME#</td>
		<td>#ACCOUNT_NO#</td>
		<td>#dateformat(CHEQUE_DUEDATE,dateformat_style)#</td>
		<td>#TLFormat(CHEQUE_VALUE)# #CURRENCY_ID#</td>
		<cfif CURRENCY_ID neq session.ep.money>
			<td>#TLFormat(OMV)# #OM#</td>
		</cfif>
	</tr>
	<tr valign="top">
		<cfif CURRENCY_ID neq session.ep.money or listlen(list_birim2) neq 1><td colspan="8"><hr></td><cfelse><td colspan="7"><hr></td></cfif>
	</tr>
</cfoutput>
</table>
<table width="650">
	<tr>
		<td style="text-align:right;">
		<table>
			<tr>
				<td width="70"><strong><cf_get_lang no='49.Çek Sayısı'></strong></td>
				<td width="100"><strong>:</strong>&nbsp;&nbsp;&nbsp;<cfoutput>#GET_CHEQUE_HISTORY.KAYIT#</cfoutput></td>
				<td width="50"><strong><cf_get_lang_main no='1233.Nakit'></strong></td>
				<td width="150">:</td>
				<td width="75"><strong><cfoutput>#getLang('objects',821)#</cfoutput></strong></td>
				<td>:
				  <cfif isdefined("GET_ACTION_DETAIL.PAYROLL_REV_MEMBER") and len(GET_ACTION_DETAIL.PAYROLL_REV_MEMBER)>
					<cfoutput>#get_emp_info(GET_ACTION_DETAIL.PAYROLL_REV_MEMBER,0,0)#</cfoutput>
				  </cfif>
				</td>
			</tr>
			<tr>
				<td>&nbsp;</td>
				<td>&nbsp;</td>
				<cfoutput>
				<cfif listlen(list_birim2) eq 1 and list_birim2 neq session.ep.money>
					<td><strong><cf_get_lang_main no='80.Toplam'> #get_cheque_detail.CURRENCY_ID#</strong></td>
					<td>: #TLFormat(cheque_total)# #get_cheque_detail.CURRENCY_ID#</td>	
				<cfelse>
					<td>&nbsp;</td>
					<td>&nbsp;</td>
				</cfif>
				<td><strong><cf_get_lang_main no='80.Toplam'> #session.ep.money#</strong></td>
				<td>: #TLFormat(get_action_detail.PAYROLL_TOTAL_VALUE)# #session.ep.money#</td> 
				</cfoutput>
			</tr>
			<cfif GET_MONEY_RATE.MONEY_TYPE neq session.ep.money>
			<tr>
			<cfoutput>
				<td style="height:5mm;"><strong>#GET_MONEY_RATE.MONEY_TYPE# <cf_get_lang_main no='236.KUR'></strong></td>
				<td>:&nbsp;&nbsp;&nbsp;#GET_MONEY_RATE.RATE1# / #TLFormat(GET_MONEY_RATE.RATE2,4)#</td>
			</cfoutput>
			</tr>
			</cfif>
		</table>
		</td>
	</tr>
</table>
</div>
<cf_get_lang_set module_name="#lcase(listgetat(attributes.fuseaction,1,'.'))#"><!--- sayfanin en ustunde acilisi var --->
