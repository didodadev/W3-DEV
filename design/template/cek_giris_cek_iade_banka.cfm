<!--- Cek Giris Cek Iade Banka --->
<cfquery name="GET_MONEY_RATE" datasource="#dsn2#">
	SELECT * FROM PAYROLL_MONEY WHERE ACTION_ID = #attributes.ACTION_ID# AND IS_SELECTED=1
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
	SELECT * FROM PAYROLL WHERE	ACTION_ID=#URL.ID#
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
		CHEQUE.CURRENCY_ID,*		
	FROM
		CHEQUE_HISTORY,
		CHEQUE
	WHERE 
		CHEQUE_HISTORY.PAYROLL_ID = #URL.ID# AND 
		CHEQUE.CHEQUE_ID = CHEQUE_HISTORY.CHEQUE_ID
</cfquery>
<cfset list_birim = ''>
<cfset list_birim = ListDeleteDupLicates(valuelist(GET_CHEQUE_DETAIL.CURRENCY_ID,','))>
<cfset toplam_tutar = 0>
<cfif GET_ACTION_DETAIL.payroll_type neq 90 and  GET_ACTION_DETAIL.payroll_type neq 105>
	<script type="text/javascript">
		alert("Belge tipi uygun değil!");
	</script>
	<cfexit method="exittemplate">
</cfif>
<div align="center">
<br/>
<cfoutput query="GET_CHEQUE_DETAIL">
	<cfif (currentrow eq 1) or (GET_CHEQUE_DETAIL.currency_id eq GET_CHEQUE_DETAIL.currency_id[currentrow-1])>
		<cfset toplam_tutar = toplam_tutar + CHEQUE_VALUE>
	<cfelse>
		<cfset toplam_tutar = 0>
	</cfif>
</cfoutput>
<table width="650" border="0" cellspacing="0" cellpadding="0">
    <tr> 
		<cfif len(CHECK.asset_file_name3)>
            <td align="left">
            <cfoutput>
                <cf_get_server_file output_file="settings/#CHECK.asset_file_name3#" output_server="#CHECK.asset_file_name3_server_id#" output_type="5">
            </cfoutput>&nbsp;&nbsp;&nbsp;&nbsp;
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
<cfoutput>
<table width="100%" height="30">
    <tr>
        <td style="text-align:center;" class="formbold">
		<cfif len(get_action_detail.payroll_type)>
			<cfif get_action_detail.payroll_type eq 90>
                <b><cf_get_lang_main no='440.Çek Giriş Bordrosu'></b>
            <cfelseif get_action_detail.payroll_type eq 105>
                <b><cf_get_lang_main no='444.Çek İade Giriş Bordrosu'>-<cf_get_lang_main no='109.Banka'></b>
            </cfif>
        </cfif>
        </td>
    </tr>
</table>
<table width="650" border="0">
    <tr>
        <td><cf_get_lang_main no='1593.Bordro No'>:<strong>#get_action_detail.PAYROLL_NO#</strong></td>
        <td style="text-align:right;"><cf_get_lang_main no='330.Tarih'>:<strong>#dateformat(get_action_detail.PAYROLL_REVENUE_DATE,dateformat_style)#</strong></td>
    </tr>
    <tr>
        <td height="40" colspan="3">
			<cfif len(get_action_detail.COMPANY_ID)>
                <strong>#get_par_info(get_action_detail.COMPANY_ID,1,1,0)#</strong>
            <cfelseif len (get_action_detail.employee_id)>
                <strong>#get_emp_info(get_action_detail.employee_id,0,0)#</strong>
            <cfelseif len(get_action_detail.consumer_id)>
                <strong>#get_cons_info(get_action_detail.consumer_id,0,0)#</strong>
            </cfif>
            cari hesabına mahsuben
            <cfset myNumber = toplam_tutar>
            <cf_n2txt number="myNumber" para_birimi="#get_cheque_detail.CURRENCY_ID#"><strong>#myNumber#</strong> Çek Alınmıştır.
        </td>
	</tr>
    <tr>
        <td><strong><cf_get_lang_main no='4.Proje'> :</strong> &nbsp;<cfif isdefined("get_action_detail.project_id") and len(get_action_detail.project_id)>#get_project_name(get_action_detail.project_id)#</cfif></td>
	</tr>
    <tr><td></td></tr>
</table>
</cfoutput>
<table width="650">
    <tr class="txtbold">
		<td><cf_get_lang_main no='595.Çek'> <cf_get_lang_main no='75.No'></td>
		<td><cf_get_lang_main no='770.Portföy No'></td>
		<td><cf_get_lang_main no='109.Banka'></td>
		<td><cf_get_lang_main no='41.Şube'></td>
		<td><cf_get_lang_main no='766.Hesap No'></td>
		<td><cf_get_lang_main no='228.Vade'></td>
		<td><cf_get_lang_main no='261.Tutar'></td>
		<cfif get_cheque_detail.CURRENCY_ID neq session.ep.money or listlen(list_birim) neq 1>
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
        	<td>#TLFormat(OTHER_MONEY_VALUE)# #OTHER_MONEY#</td>
        </cfif>
	</tr>
    <tr valign="top">
        <cfif CURRENCY_ID neq session.ep.money or listlen(list_birim) neq 1>
            <td colspan="8"><hr></td>
        <cfelse>
	        <td colspan="7"><hr></td>
        </cfif>
    </tr>
    </cfoutput>
</table>
<table width="650" border="0">
    <cfoutput>
    <tr>
        <td style="text-align:right;">
        <table border="0">
            <tr>
                <td width="50"><strong><cf_get_lang_main no='1233.Nakit'></strong></td>
                <td width="150">:</td>
                <td width="75"><strong><cf_get_lang no='1093.Tahsil Eden'></strong></td>
                <td>:
                	<cfif isdefined("get_action_detail.REVENUE_COLLECTOR_ID") and len(get_action_detail.REVENUE_COLLECTOR_ID)>
                		#get_emp_info(get_action_detail.REVENUE_COLLECTOR_ID,0,0)#
					</cfif>
                </td>
            </tr>
            <tr>
				<cfif listlen(list_birim) eq 1 and list_birim neq session.ep.money>
                    <td><strong><cf_get_lang_main no='80.Toplam'> #get_cheque_detail.CURRENCY_ID#</strong></td>
                    <td>: #TLFormat(toplam_tutar)# #get_cheque_detail.CURRENCY_ID#</td>	
                <cfelse>
                    <td>&nbsp;</td>
                    <td>&nbsp;</td>
                </cfif>
                <td><strong><cf_get_lang_main no='80.Toplam'> #session.ep.money#</strong></td>
                <td>:<cfif len(get_action_detail.PAYROLL_TOTAL_VALUE)> #TLFormat(get_action_detail.PAYROLL_TOTAL_VALUE)# #session.ep.money#</cfif></td> 
            </tr>
        </table>
        </td>
    </tr>
    <tr>
        <td>
        <table>
            <tr><td colspan="2" style="height:4mm;">&nbsp;</td></tr>
            <tr>
                <td style="height:5mm;"><strong><cf_get_lang no="822.Toplam Çek Sayısı"></strong></td>
                <td><strong>:</strong>&nbsp;&nbsp;&nbsp;#GET_CHEQUE_HISTORY.KAYIT#</td>
            </tr>
            <tr>
                <td style="height:5mm;"><strong><cf_get_lang_main no='449.Ortalama Vade'></strong></td>
                <td><strong>:</strong>&nbsp;&nbsp;&nbsp;#dateformat(get_action_detail.PAYROLL_AVG_DUEDATE,dateformat_style)#</td>
            </tr>
			<cfif GET_MONEY_RATE.MONEY_TYPE neq session.ep.money>
            <tr>
                <td style="height:5mm;"><strong>#GET_MONEY_RATE.MONEY_TYPE# KUR</strong></td>
                <td><strong>:</strong>&nbsp;&nbsp;&nbsp;#GET_MONEY_RATE.RATE1# / #TLFormat(GET_MONEY_RATE.RATE2,4)#</td>
            </tr>
            </cfif>
        </table>
        </td>
    </tr>
	</cfoutput>
</table>
</div>
