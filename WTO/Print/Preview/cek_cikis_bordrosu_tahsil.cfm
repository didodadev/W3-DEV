﻿<cf_get_lang_set module_name="objects"><!--- sayfanin en altinda kapanisi var --->
<!--- Çek Çıkış Bordrosu Tahsil --->
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
	SELECT * FROM PAYROLL WHERE ACTION_ID = #URL_ID# AND PAYROLL_TYPE = 92
</cfquery>
<cfquery name="GET_CHEQUE_DETAIL" datasource="#dsn2#">
	SELECT
		C.COMPANY_ID,
		C.CHEQUE_NO,
		C.BANK_NAME,
		C.BANK_BRANCH_NAME,
		C.CHEQUE_DUEDATE,
		C.CHEQUE_VALUE,
        C.CHEQUE_PURSE_NO
	FROM
		CHEQUE_HISTORY CH,
		CHEQUE C
	WHERE 
		CH.PAYROLL_ID = #URL_ID# AND 
		(CH.STATUS = 3 OR CH.STATUS = 7) AND 
		C.CHEQUE_ID = CH.CHEQUE_ID
</cfquery>
<cfif GET_ACTION_DETAIL.payroll_type neq 92>
	<script type="text/javascript">
		alert("Belge tipi uygun değil!");
	</script>
	<cfexit method="exittemplate">
</cfif>
<div align="center">
<br/>
<table width="650" border="0" cellspacing="0" cellpadding="0">
    <tr> 
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
        <cfif len(CHECK.asset_file_name3)>
	        <td style="text-align:right;"><cfoutput><cf_get_server_file output_file="settings/#CHECK.asset_file_name3#" output_server="#CHECK.asset_file_name3_server_id#" output_type="5"></cfoutput></td>
        </cfif>
    </tr>
	<tr><td colspan="2"><hr></td></tr>
</table>
<br/>
<table border="0" width="100%" height="30">
    <tr>
        <td style="text-align:center" class="formbold"><b><cf_get_lang_main no='444.Çek İade Giriş Bordrosu'>-<cf_get_lang_main no="2223.Tahsil"></b></td>
    </tr>
</table>
<table border="0" width="650">
    <cfoutput>
    <tr>
        <td><cf_get_lang_main no='1593.Bordro No'>: <strong>#get_action_detail.PAYROLL_NO#</strong></td>
        <td style="text-align:right;"><cf_get_lang_main no='330.Tarih'>:
        	<strong>#dateformat(get_action_detail.PAYROLL_REVENUE_DATE,dateformat_style)#</strong>
        </td>
    </tr>
    <tr>
        <td height="50" colspan="2">
			<cfif len(GET_CHEQUE_DETAIL.COMPANY_ID)>
                <strong>#get_par_info(GET_CHEQUE_DETAIL.COMPANY_ID,1,1,0)#</strong>
            </cfif>
            <cf_get_lang no="816.cari hesabından mahsuben">
            <cfset myNumber = get_action_detail.PAYROLL_TOTAL_VALUE>
            <cf_n2txt number="myNumber"><strong>#myNumber#</strong> <cf_get_lang no="820.Çek Tahsil Edilmiştir">.
        </td>
    </tr>
	</cfoutput>
</table>
<table border="0" width="650">
    <tr height="22" class="txtbold">
		<td><cf_get_lang_main no='595.Çek'> <cf_get_lang_main no='75.No'></td>
		<td><cf_get_lang_main no='770.Portföy No'></td>
		<td><cf_get_lang_main no='109.Banka'></td>
		<td><cf_get_lang_main no='41.Şube'></td>
		<td><cf_get_lang_main no='228.Vade'></td>
		<td><cf_get_lang_main no='261.Tutar'></td>
    </tr>
	<!--- Burasi cek sayisi kadar artacak..--->
    <cfoutput query="GET_CHEQUE_DETAIL">
        <tr>
            <td>#CHEQUE_NO#</td>
            <td>#CHEQUE_PURSE_NO#</td>
            <td>#BANK_NAME#</td>
            <td>#BANK_BRANCH_NAME#</td>
            <td>#dateformat(CHEQUE_DUEDATE,dateformat_style)#</td>
            <td>#TLFormat(CHEQUE_VALUE)#</td>
        </tr>
        <tr valign="top"><td colspan="6"><hr></td></tr>
    </cfoutput>
</table>
<table border="0" width="650">
    <tr>
        <td style="text-align:right;">
        <table border="0">
           <cfoutput>
           <tr>
                <td width="50"><strong><cf_get_lang_main no='1233.Nakit'></strong></td>
                <td width="150">:</td>
                <td width="75"><strong><cf_get_lang no='1093.Tahsil Eden'></strong></td>
                <td>:
                <cfif isdefined("attributes.EMPLOYEE_ID") and len(attributes.EMPLOYEE_ID)>
                	#get_emp_info(attributes.EMP_ID,0,0)#
                </cfif>
                </td>
            </tr>
            <tr>
			<cfif get_action_detail.PAYROLL_OTHER_MONEY neq session.ep.money>
                <td><strong><cf_get_lang_main no='80.Toplam'> #get_action_detail.PAYROLL_OTHER_MONEY#</strong></td>
                <td>: #TLFormat(get_action_detail.PAYROLL_OTHER_MONEY_VALUE)# #get_action_detail.PAYROLL_OTHER_MONEY#</td>
            </cfif>	
                <td><strong><cf_get_lang_main no='80.Toplam'> #session.ep.money#</strong></td>
                <td>: #TLFormat(get_action_detail.PAYROLL_TOTAL_VALUE)# #session.ep.money#</td> 
            </tr>
			</cfoutput>
        </table>
        </td>
    </tr>
</table>
</div>
<cf_get_lang_set module_name="#lcase(listgetat(attributes.fuseaction,1,'.'))#"><!--- sayfanin en ustunde acilisi var --->
