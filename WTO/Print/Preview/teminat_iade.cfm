<!--- Finans-Teminatlar-Teminat İade Standart Şablonu --->
<cf_get_lang_set module_name="finance">
<cfquery name="GET_MONEY_RATE" datasource="#dsn2#">
	SELECT * FROM SETUP_MONEY WHERE MONEY_STATUS = 1
</cfquery>
<cfquery name="GET_MONEY" datasource="#dsn#">
	SELECT * FROM COMPANY_SECUREFUND_MONEY WHERE ACTION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.iid#"> ORDER BY MONEY_TYPE
</cfquery>
<cfif GET_MONEY.recordcount eq 0>
	<cfquery name="GET_MONEY" datasource="#dsn2#">
		SELECT MONEY AS MONEY_TYPE,* FROM SETUP_MONEY WHERE MONEY_STATUS=1
	</cfquery>
</cfif>
<cfquery name="GET_BANKS_NAME" datasource="#DSN3#">
	SELECT * FROM BANK_BRANCH WHERE BANK_ID IS NOT NULL ORDER BY BANK_NAME
</cfquery>  
<cfquery name="GET_COMPANY_SECUREFUND" datasource="#DSN#">
	SELECT * FROM COMPANY_SECUREFUND WHERE SECUREFUND_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.iid#"> 
</cfquery> 
<cfquery name="GET_OUR_COMPANIES" datasource="#dsn#">
    SELECT * FROM OUR_COMPANY WHERE COMP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#GET_COMPANY_SECUREFUND.OUR_COMPANY_ID#">  
</cfquery>
<cfquery name="GET_COMPANIES" datasource="#dsn#">        
	SELECT * 
	FROM 
        COMPANY_SECUREFUND 
            INNER JOIN COMPANY ON COMPANY_SECUREFUND.COMPANY_ID = COMPANY.COMPANY_ID
	WHERE 
    	COMPANY_SECUREFUND.SECUREFUND_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#GET_COMPANY_SECUREFUND.SECUREFUND_ID#"> 
</cfquery>
<cfif Len(GET_COMPANIES.RECORD_EMP)>
	<cfquery name="GET_RECORD_EMP" datasource="#dsn#">
		SELECT EMPLOYEE_NAME,EMPLOYEE_SURNAME FROM  EMPLOYEES WHERE EMPLOYEE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#GET_COMPANIES.RECORD_EMP#">
    </cfquery>
</cfif>
<cfif Len(GET_COMPANIES.SECUREFUND_CAT_ID)>
	<cfquery name="GET_SECUREFUND_CAT" datasource="#dsn#">
		SELECT SECUREFUND_CAT,SECUREFUND_CAT_ID FROM SETUP_SECUREFUND WHERE SECUREFUND_CAT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#GET_COMPANIES.SECUREFUND_CAT_ID#">
    </cfquery>
</cfif>
<cfif Len(GET_COMPANY_SECUREFUND.BANK_BRANCH_ID)>
    <cfquery name="get_bank_" datasource="#dsn3#">
        SELECT BANK_BRANCH_NAME,BANK_BRANCH_ID,BANK_ID FROM BANK_BRANCH WHERE BANK_BRANCH_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#GET_COMPANY_SECUREFUND.BANK_BRANCH_ID#">
    </cfquery>
</cfif>
<cfif Len(GET_COMPANIES.PROJECT_ID)>
    <cfquery name="GET_PROJECT" datasource="#dsn#">
        SELECT PROJECT_HEAD,PROJECT_ID FROM PRO_PROJECTS WHERE PROJECT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#GET_COMPANIES.PROJECT_ID#">
    </cfquery>
</cfif>
<cfif len(GET_COMPANY_SECUREFUND.BANK_BRANCH_ID)>
    <cfquery name="get_bank_branch_" datasource="#dsn3#">
        SELECT BANK_BRANCH_ID,BANK_BRANCH_NAME FROM BANK_BRANCH WHERE BANK_ID = #get_bank_.BANK_ID#
    </cfquery>
</cfif>
<table border="0" cellpadding="0" cellspacing="0" style="height:175mm;width:170mm;">
	<tr>
    	<td style="width:5mm;" rowspan="30">&nbsp;</td>
        <td style="height:12mm;">&nbsp;</td>        
    </tr>
    <tr>
    	<td valign="top">
        	<table border="0" cellpadding="0" cellspacing="0" width="100%">
            	<tr>
                	<td style="height:50mm;width:250mm;">
                    	<table border="0" cellpadding="0" cellspacing="0" width="100%">
						<cfoutput query="GET_OUR_COMPANIES">
                        	<tr>
                            	<td style="height:20mm;width:50mm;">
                                <cfif Len(ASSET_FILE_NAME3)>
                                    <cf_get_server_file 
                                    output_file="settings/#ASSET_FILE_NAME3#" 
                                    output_server="#ASSET_FILE_NAME3_SERVER_ID#" 
                                    output_type="5">
                            	</cfif>
                                </td><!--- LOGO --->
                                <td valign="top" colspan="2">
                                	<table border="0" cellpadding="0" cellspacing="0" width="100%">
                                            <tr><td style="text-align:left;width:18mm;" colspan="2"><b>#COMPANY_NAME#</b></td></tr>
                                            <tr>
                                                <td style="width:130mm;" colspan="2">#ADDRESS#</td><!---  Adres --->
                                            </tr>
                                            <tr><td style="height:3mm;">&nbsp;</td></tr>
                                            <tr>
                                                <td style="width:17mm;"><b><cf_get_lang_main no='87.Telefon'></b></td>
                                                <td>: #TEL_CODE# #TEL#</td><!--- Telefon No --->
                                            </tr>
                                            <tr>
                                                <td style="width:17mm;"><b><cf_get_lang_main no='76.Fax'></b></td>
                                                <td>: #TEL_CODE# #FAX#</td><!--- Fax No --->
                                            </tr>
                                            <tr>
                                                <td style="width:20mm;"><b><cf_get_lang_main no='1350.Vergi Dairesi'></b></td><!--- VD ve No --->
                                                <td>:#TAX_OFFICE#</td>
                                                <td style="width:20mm;"><b><cf_get_lang_main no='340.Vergi No'>:</b></td>
                                                <td>#TAX_NO#</td>
                                            </tr>
                                            <tr>
                                                <td style="width:20mm;" colspan="2">#WEB#&nbsp;&nbsp;#EMAIL#</td>
                                            </tr>
                                        </cfoutput>
                                    </table>
                                </td>
                            </tr>
                        </table>
                        <table border="0" cellpadding="0" cellspacing="0" width="100%">
                        	<tr><td>&nbsp;</td></tr>
                        	<tr><td valign="middle" colspan="2" style="width:220mm;"><hr>&nbsp;</hr></td></tr>
                            <tr><td style="text-align:center;" ><b><cf_get_lang_main no='1858.Teminat İade'></b></td></tr>
                            <tr>
                            	<td style="text-align:right;width:62mm;"><b><cf_get_lang_main no='1621.İade'><cf_get_lang_main no='1181.Tarihi'>:</b></td>
                                <td style="text-align:left;width:10mm;" colspan="2"><cfoutput>#dateformat(get_company_securefund.return_date,dateformat_style)#</cfoutput></td>
                            </tr>
                            <tr><td>&nbsp;</td></tr>
                        </table>
                        <table border="0" cellpadding="0" cellspacing="0" width="100%">
                        	<cfoutput>
                                <tr>
                                    <td style="width:20mm;"><cfif isdefined('iid')>#GET_COMPANIES.FULLNAME#</cfif><!--- Cari Adı --->
                                    <cf_get_lang no="31.cari hesabına mahsuben">
                                    	<cfset mynumber = wrk_round(GET_COMPANY_SECUREFUND.ACTION_VALUE)>
                                        <cfset mybirim = GET_COMPANY_SECUREFUND.MONEY_CAT>
                                        <cf_n2txt number="mynumber" para_birimi="#mybirim#">#mynumber#
                                        <cf_get_lang no="47.Teminat iade edilmiştir">.
                                    </td>
                                </tr>
							</cfoutput>
                            <tr><td>&nbsp;</td></tr>
                        </table>
                        <table border="0" cellpadding="0" cellspacing="0" width="100%">
                        	<tr>
                            	<td style="width:30mm;"><b><cf_get_lang_main no='1277.Teminat'><cf_get_lang_main no='75.No'></b></td>
                                <td style="width:20mm;"><b><cf_get_lang_main no='109.Banka'></b></td>
                                <td style="width:30mm;"><b><cf_get_lang_main no='41.Şube'></b></td>
                                <td style="width:40mm;"><b><cf_get_lang_main no='4.Proje'></b></td>
                                <td style="width:22mm;"><b><cf_get_lang_main no='228.Vade'></b></td>
                                <td style="width:25mm;"><b><cf_get_lang_main no='261.Tutar'></b></td>
                            </tr>
                        </table>
                        <table border="0" cellpadding="0" cellspacing="0" width="100%">
                        	<cfoutput>
                                <tr>
                                    <td style="width:30mm;height:6mm;text-align:left;">#GET_COMPANY_SECUREFUND.SECUREFUND_ID#</td><!--- Teminat No --->
                                    <td style="width:20mm;"><cfif Len(GET_BANKS_NAME.BANK_ID) or isdefined('bank_id')>#GET_BANKS_NAME.BANK_NAME#</cfif></td><!--- Banka --->
                                    <td style="width:30mm;"><cfif Len(GET_BANKS_NAME.BANK_ID) or isdefined('bank_id')>#GET_BANKS_NAME.BANK_BRANCH_NAME#</cfif></td><!--- Şube --->
                                    <td style="width:40mm;"><cfif Len(GET_COMPANY_SECUREFUND.PROJECT_ID)>#GET_PROJECT.PROJECT_HEAD#</cfif></td><!--- Proje --->
                                    <td style="width:22mm;">#dateformat(GET_COMPANY_SECUREFUND.FINISH_DATE,dateformat_style)#</td><!--- Vade --->
                                    <td style="width:25mm;">#GET_COMPANY_SECUREFUND.ACTION_VALUE# #GET_COMPANY_SECUREFUND.MONEY_CAT#</td><!--- Tutar MONEY_CAT_EXPENSE  --->	
                                </tr>
							</cfoutput>
                        </table>
                        <table border="0" cellpadding="0" cellspacing="0" width="100%">
                        	<tr><td>&nbsp;</td></tr>
                        	<tr><td valign="middle" colspan="2"><hr>&nbsp;</hr></td></tr>
                        </table>
                        <table border="0" cellpadding="0" cellspacing="0" width="100%">
                        	 <cfoutput>
                                 <tr>
                                    <td style="width:65mm;">&nbsp;</td>
                                    <td style="width:40mm;;"><b><cf_get_lang no='560.Teminat Kategorisi'>:</b></td>
                                    <td style="width:45mm;">#GET_SECUREFUND_CAT.SECUREFUND_CAT#</td>
                                    <td style="width:25mm;"><b><cf_get_lang_main no='363.Teslim Alan'>:</b></td>
                                    <td style="width:40mm;">#GET_RECORD_EMP.EMPLOYEE_NAME# #GET_RECORD_EMP.EMPLOYEE_SURNAME#</td>
                                </tr>
                                 <tr>
                                    <td style="width:65mm;">&nbsp;</td>
                                    <td style="width:40mm;;">&nbsp;</td>
                                    <td style="width:45mm;">&nbsp;</td>
                                    <td style="width:25mm;"><b><cf_get_lang_main no='80.Toplam'>:</b></td>
                                    <td style="width:40mm;">#GET_COMPANY_SECUREFUND.ACTION_VALUE# #GET_COMPANY_SECUREFUND.MONEY_CAT#</td><!--- Toplam  --->
                                </tr>
                            </cfoutput>
                        </table>
                    </td>
                </tr>
            </table>
        </td>
    </tr>
</table>
<cf_get_lang_set module_name="#lcase(listgetat(attributes.fuseaction,1,'.'))#">
