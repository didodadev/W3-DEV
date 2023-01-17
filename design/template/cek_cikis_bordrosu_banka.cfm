<!--- Çek Çıkış Bordrosu Banka --->
<cf_get_lang_set module_name="cheque"><!--- sayfanin en altinda kapanisi var --->
<cfquery name="GET_MONEY_RATE" datasource="#dsn#">
	SELECT * FROM SETUP_MONEY WHERE PERIOD_ID = #SESSION.EP.PERIOD_ID# AND MONEY_STATUS = 1 AND RATE1 = RATE2
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
<cfset url_id=attributes.ACTION_ID>
<cfquery name="GET_ACTION_DETAIL" datasource="#dsn2#">
	SELECT * FROM PAYROLL WHERE ACTION_ID = #URL_ID# AND PAYROLL_TYPE IN(93,133)
</cfquery>
<cfquery name="GET_CHEQUE_HISTORY" datasource="#dsn2#">
	SELECT 
		COUNT(CHEQUE_ID) AS KAYIT 
	FROM
		CHEQUE_HISTORY
	WHERE
		PAYROLL_ID = #URL_ID#
</cfquery>
<cfif GET_ACTION_DETAIL.recordcount>
	<cfquery name="GET_ACCOUNTS" datasource="#DSN3#">
		SELECT
			ACCOUNTS.*,
			BANK_BRANCH.BANK_NAME,
			BANK_BRANCH.BANK_BRANCH_NAME
		FROM
			ACCOUNTS,	
			BANK_BRANCH
		WHERE
			ACCOUNTS.ACCOUNT_ID = #GET_ACTION_DETAIL.PAYROLL_ACCOUNT_ID# AND
			ACCOUNTS.ACCOUNT_BRANCH_ID = BANK_BRANCH.BANK_BRANCH_ID
		ORDER BY
			ACCOUNTS.ACCOUNT_NAME
	</cfquery>
	<cfquery name="GET_CHEQUE_DETAIL" datasource="#dsn2#">
		SELECT
			C.COMPANY_ID,
			C.CHEQUE_NO,
			C.BANK_NAME,
			C.ACCOUNT_NO,
			C.BANK_BRANCH_NAME,
			C.CHEQUE_DUEDATE,
			C.CHEQUE_VALUE,
			C.CURRENCY_ID,
			C.DEBTOR_NAME AS BORCLU,
			C.OTHER_MONEY_VALUE,
            C.CHEQUE_PURSE_NO
		FROM
			CHEQUE_HISTORY CH,
			CHEQUE C
		WHERE 
			CH.PAYROLL_ID = #URL_ID# AND 
			CH.STATUS IN(2,13) AND 
			C.CHEQUE_ID = CH.CHEQUE_ID
        ORDER BY CH.HISTORY_ID
	</cfquery>
	<cfset list_para = ''>
	<cfset list_para = ListDeleteDupLicates(valuelist(GET_CHEQUE_DETAIL.CURRENCY_ID,','))>
</cfif>
<cfset cheque_total_value = 0>
<cfif GET_ACTION_DETAIL.payroll_type neq 93 and GET_ACTION_DETAIL.payroll_type neq 133>
	<script type="text/javascript">
		alert("Belge tipi uygun değil!");
	</script>
	<cfexit method="exittemplate">
</cfif>
<div align="center">
 <br/>
<table width="650" border="0" cellspacing="0" cellpadding="0">
    <tr> 
		<cfif len(CHECK.asset_file_name3)>
        <td style="text-align:right;">
            <cfoutput><cf_get_server_file output_file="settings/#CHECK.asset_file_name3#" output_server="#CHECK.asset_file_name3_server_id#" output_type="5"></cfoutput>
        </td>
        </cfif>
    	<td style="width:10mm;">&nbsp;</td>
		<td valign="top">
		<cfoutput query="CHECK">
            <strong style="font-size:14px;">#company_name#</strong><br/>
            #address#<br/>
            <b><cf_get_lang_main no='87.Telefon'>: </b> (#tel_code#) - #tel#  #tel2#  #tel3# #tel4# <br/>
            <b><cf_get_lang_main no='76.Fax'>: </b> #fax# <br/>
            <b><cf_get_lang_main no='1350.Vergi Dairesi'> : </b> #TAX_OFFICE# <b><cf_get_lang_main no='340.No'> : </b> #TAX_NO#<br/>
            #web# - #email#
        </cfoutput>
        </td>
    </tr>
	<tr><td colspan="3"><hr></td></tr>
 </table><br/>
<table width="100%" height="30">
    <tr>
        <td style="text-align:center" class="formbold">
        	<cfif GET_ACTION_DETAIL.PAYROLL_TYPE eq 93>
        		<b><cf_get_lang_main no='442.Çek Çıkış Bordrosu-Banka'></b> &nbsp;&nbsp;(<cf_get_lang_main no='2223.Tahsil'>)
        	<cfelse>
        		<b><cf_get_lang_main no='442.Çek Çıkış Bordrosu-Banka'></b> &nbsp;&nbsp;(<cf_get_lang_main no='1277.Teminat'>)
        	</cfif>
        </td>
    </tr>
</table>
<table width="650" border="0">
    <cfoutput>
    <tr>
        <td><cf_get_lang_main no='1593.Bordro No'>: <strong>#get_action_detail.PAYROLL_NO#</strong></td>
        <td style="text-align:right;"> <cf_get_lang_main no='330.Tarih'>:
		<strong>#dateformat(get_action_detail.PAYROLL_REVENUE_DATE,dateformat_style)#</strong>
        </td>
    </tr>
    <tr>
        <td colspan="2"><cf_get_lang_main no='109.Banka'> : <cfif GET_ACTION_DETAIL.recordcount><strong>#GET_ACCOUNTS.BANK_NAME#</strong></cfif></td>
    </tr>
    <tr><td><cf_get_lang_main no='41.Şube'> : <strong><cfif GET_ACTION_DETAIL.recordcount>#GET_ACCOUNTS.BANK_BRANCH_NAME#</strong></cfif></td></tr>
    <tr>
        <td><cf_get_lang_main no='240.Hesap'> <cf_get_lang_main no='75.Numarası'> :<strong><cfif GET_ACTION_DETAIL.recordcount>#GET_ACCOUNTS.ACCOUNT_NO#</strong></cfif></td>
    </tr>
    <tr>
        <td><cf_get_lang_main no='49.Çek Sayısı'> : <strong>#GET_CHEQUE_HISTORY.KAYIT#</strong></td>
    </tr>
    <tr>
        <td height="30" colspan="2"></td>
    </tr>
	</cfoutput>
</table>
<table width="650">
    <tr height="22" class="txtbold">
		<td><cf_get_lang_main no='595.Çek'> <cf_get_lang_main no='75.No'></td>
		<td><cf_get_lang_main no='109.Banka'></td>
		<td><cf_get_lang_main no='766.Hesap No'></td>
		<td><cf_get_lang_main no='41.Şube'></td>
		<td><cf_get_lang_main no='768.Borçlu'></td>
		<td><cf_get_lang_main no='228.Vade'></td>
		<td style="text-align:center"><cf_get_lang_main no='261.Tutar'></td>
    </tr>
	<!--- Burasi cek sayisi kadar artacak..--->
	<cfif GET_ACTION_DETAIL.recordcount>
	<cfoutput query="GET_CHEQUE_DETAIL">
    <tr>
        <td>#CHEQUE_NO#</td>
        <td>#BANK_NAME#</td>
        <td>#ACCOUNT_NO#</td>
        <td width="120">#BANK_BRANCH_NAME#</td>
        <td width="130">#BORCLU#</td>
        <td width="75">#dateformat(CHEQUE_DUEDATE,dateformat_style)#</td>
        <td style="text-align:right;">
        <cfif (currentrow eq 1) or (GET_CHEQUE_DETAIL.currency_id eq GET_CHEQUE_DETAIL.currency_id[currentrow-1])>
        	<cfset cheque_total_value = cheque_total_value+CHEQUE_VALUE>
        </cfif>
        #TLFormat(CHEQUE_VALUE)#&nbsp;&nbsp;#currency_id#
        </td>
    </tr>
    <tr valign="top"><td colspan="8"><hr></td></tr>
	</cfoutput>
</table>
<table width="650" border="0">
    <cfoutput>
    <tr>
        <td style="text-align:right;">
        <table border="0">
            <tr>
                <td>&nbsp;</td>
                <td>&nbsp;</td>
				<cfif listlen(list_para) eq 1 and list_para neq session.ep.money>
                    <td><strong><cf_get_lang_main no='80.Toplam'> #get_cheque_detail.CURRENCY_ID#</strong></td>
                    <td>: #TLFormat(cheque_total_value)# #get_cheque_detail.CURRENCY_ID#</td>	
                <cfelse>
                    <td><strong><cf_get_lang_main no='80.Toplam'> #session.ep.money#</strong></td>
                    <td>: #TLFormat(get_action_detail.PAYROLL_TOTAL_VALUE)# #session.ep.money#</td> 
                </cfif>
            </tr>
        </table>
        </td>
    </tr>
    <tr>
        <td> <cf_get_lang_main no="2220.Yalnız">
		<cfif listlen(list_para) eq 1 and list_para neq session.ep.money>
			<cfset myNumber = cheque_total_value>
            <cf_n2txt number="myNumber" para_birimi="#get_cheque_detail.CURRENCY_ID#"><strong>#myNumber#</strong>'dir.
        <cfelse>
			<cfset myNumber = get_action_detail.PAYROLL_TOTAL_VALUE>
            <cf_n2txt number="myNumber" para_birimi="#get_action_detail.CURRENCY_ID#"><strong>#myNumber#</strong>'dir.
        </cfif>
        </td>
    </tr>
	</cfoutput>
</table>  
</cfif>     
</div>
<cf_get_lang_set module_name="#lcase(listgetat(attributes.fuseaction,1,'.'))#"><!--- sayfanin en ustunde acilisi var --->
