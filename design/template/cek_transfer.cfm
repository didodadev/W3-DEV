<!--- Cek Transfer Standart Şablonu --->
<cfquery name="GET_MONEY_RATE" datasource="#dsn2#">
	SELECT
		*
	FROM
		PAYROLL_MONEY
	WHERE
		ACTION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.action_id#"> AND
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
	<cfif isdefined("SESSION.EP.COMPANY_ID")>
	    COMP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#">
	<cfelseif isdefined("SESSION.PP.COMPANY")>	
	    COMP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.pp.company_id#">
	</cfif> 
</cfquery>
<cfquery name="GET_ACTION_DETAIL" datasource="#dsn2#">
	SELECT * FROM PAYROLL WHERE	ACTION_ID =  <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.action_id#">
</cfquery>
<cfquery name="GET_CHEQUE_HISTORY" datasource="#dsn2#">
    SELECT 
        COUNT(CHEQUE_ID) AS KAYIT 
    FROM
        CHEQUE_HISTORY
    WHERE
        PAYROLL_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.action_id#">
</cfquery>
<cfquery name="GET_CHEQUE_DETAIL" datasource="#dsn2#">
	SELECT
		CHEQUE.CURRENCY_ID,*		
	FROM
		CHEQUE_HISTORY,
		CHEQUE
	WHERE 
		CHEQUE_HISTORY.PAYROLL_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.action_id#"> AND 
		CHEQUE.CHEQUE_ID = CHEQUE_HISTORY.CHEQUE_ID
    ORDER BY
		CHEQUE_HISTORY.HISTORY_ID
</cfquery>
<cfquery name="GET_TO_CASHES" datasource="#dsn2#">
	SELECT * FROM CASH ORDER BY CASH_ID
</cfquery>
<cfset list_birim = ''>
<cfset list_birim = ListDeleteDupLicates(valuelist(GET_CHEQUE_DETAIL.CURRENCY_ID,','))>
<cfset toplam_tutar = 0>
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
       <td style="height:6mm;" align="center"><strong>Çek Transfer Bordrosu</strong></td>
    </tr>
</table>
<table width="650" border="0">
    <tr>
    	<td style="text-align:left;">
        	<strong>Kasasından : </strong>
            <cfloop query="GET_TO_CASHES">
				<cfif cash_id eq get_action_detail.payroll_cash_id>#CASH_NAME#</cfif>
            </cfloop>
        </td>
        <td style="text-align:right;"><strong><cf_get_lang_main no='330.Tarih'></strong> :#dateformat(get_action_detail.PAYROLL_REVENUE_DATE,dateformat_style)#</td>
    </tr>
    <tr>
    	<td style="text-align:left;">
        	<strong>Kasasına : </strong>
            <cfloop query="GET_TO_CASHES">
				<cfif cash_id eq get_action_detail.transfer_cash_id>#CASH_NAME#</cfif>
            </cfloop>
        </td>
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
        </td>
	</tr>
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
            <td style="text-align:left;">
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
            <td style="text-align:right;">
                <table border="0">
                	<tr>
                    	<td style="text-align:left; width:20mm;"><strong><cf_get_lang_main no='80.Toplam'> #session.ep.money#</strong></td>
                        <td><strong>:</strong>&nbsp;<cfif len(get_action_detail.PAYROLL_TOTAL_VALUE)>#TLFormat(get_action_detail.PAYROLL_TOTAL_VALUE)# #session.ep.money#</cfif></td> 
                    </tr>
                    <tr>
                        <cfif listlen(list_birim) eq 1 and list_birim neq session.ep.money>
                            <td style="text-align:left; width:20mm;"><strong><cf_get_lang_main no='80.Toplam'> #get_cheque_detail.CURRENCY_ID#</strong></td>
                            <td><strong>:</strong>&nbsp;#TLFormat(toplam_tutar)# #get_cheque_detail.CURRENCY_ID#</td>	
                        <cfelse>
                            <td>&nbsp;</td>
                            <td>&nbsp;</td>
                        </cfif>
                    </tr>
                </table>
            </td>
        </tr>
	</cfoutput>
</table>
</div>
