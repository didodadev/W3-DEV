<!--- Gelen Giden Havale ve Toplu Gelen Giden Havale print şablonu --->
<cfif not isdefined("attributes.action_id")>
	<cfset attributes.action_id = attributes.checked_value>
</cfif>
<cfif len(attributes.action_id)>
    <cfquery name="Get_Havale" datasource="#dsn2#">
        SELECT * FROM BANK_ACTIONS WHERE ACTION_ID = #attributes.action_id#
    </cfquery>
	<cfif Len(Get_Havale.ACTION_TYPE_ID) and (Get_Havale.ACTION_TYPE_ID neq 24) or (Get_Havale.ACTION_TYPE_ID neq 25)>
    	<cfquery name="get_action_detail" datasource="#dsn2#">
            SELECT
                BAM.*,
                BA.ACTION_TO_COMPANY_ID,
                BA.ACTION_TO_CONSUMER_ID,
                BA.ACTION_TO_EMPLOYEE_ID,
                BA.ACTION_FROM_COMPANY_ID,
                BA.ACTION_FROM_CONSUMER_ID,
                BA.ACTION_FROM_EMPLOYEE_ID,
                BA.OTHER_CASH_ACT_VALUE AS ACTION_VALUE_OTHER,
                BA.PAPER_NO,
                BA.PROJECT_ID,
                BA.ACTION_ID,
                BA.ACTION_VALUE,
                BA.ACTION_DETAIL,
                BA.OTHER_MONEY AS ACTION_CURRENCY,
                BAM.UPD_STATUS,
                BA.MASRAF,
                BA.EXPENSE_CENTER_ID,
                BA.EXPENSE_ITEM_ID,
                BA.ASSETP_ID,
                BA.FROM_BRANCH_ID,
                BA.SPECIAL_DEFINITION_ID,
                BA.ACC_DEPARTMENT_ID,
                BA.ACTION_TYPE_ID,
                BA.ACTION_TO_ACCOUNT_ID,
                BA.ACTION_FROM_ACCOUNT_ID
            FROM
                BANK_ACTIONS_MULTI BAM,
                BANK_ACTIONS BA
            WHERE
                BAM.MULTI_ACTION_ID = BA.MULTI_ACTION_ID AND
                BAM.MULTI_ACTION_ID = #attributes.action_id#
            ORDER BY
                BA.ACTION_ID
    	</cfquery>
    </cfif>
    
    <cfset account_id_ = "">
    <cfset action_company_id = "">
    <cfset action_consumer_id = "">
    <cfset action_employee_id = "">

    <!--- Toplu Gelen / Giden --->
    <cfif len(Get_Action_Detail.ACTION_TO_ACCOUNT_ID)>
        <cfset account_id_ = Get_Action_Detail.ACTION_TO_ACCOUNT_ID>
    <cfelseif len(Get_Action_Detail.ACTION_FROM_ACCOUNT_ID)>
        <cfset account_id_ = Get_Action_Detail.ACTION_FROM_ACCOUNT_ID>
    <!--- Gelen / Giden Havale --->
    <cfelseif len(Get_Havale.ACTION_TO_ACCOUNT_ID)>
        <cfset account_id_ = Get_Havale.action_to_account_id>
    <cfelseif len(Get_Havale.ACTION_FROM_ACCOUNT_ID)>
        <cfset account_id_ = Get_Havale.ACTION_FROM_ACCOUNT_ID>
    </cfif>
    
    <cfset aciklama = "">
	<cfif Get_Action_Detail.RecordCount>
    	<cfset aciklama = Get_Havale.ACTION_DETAIL>
    <cfelseif Get_Havale.RecordCount>
    	<cfset aciklama = Get_Action_Detail.ACTION_DETAIL>
    </cfif>    
    <cfif len(account_id_)>
        <cfquery name="get_account_info" datasource="#dsn3#">
            SELECT * FROM ACCOUNTS WHERE ACCOUNT_ID = #account_id_#
        </cfquery>
    </cfif>
	<style>
        .box_yazi{ font-weight:bold;}
		.stil{ font-weight:bold;font-size:16px;}
    </style>    
    <table border="0" cellspacing="0" cellpadding="0" align="left" style="width:180mm;">
        <tr>
            <td rowspan="40" style="width:10mm;">&nbsp;</td>
            <td style="height:10mm;">&nbsp;</td>
        </tr>
        <tr>
            <td>
            <table border="0" cellpadding="0" cellspacing="0" width="100%">
                <tr>
                    <td colspan="4" class="stil" style="text-align:center;height:14mm;">
                    <cfif Get_Action_Detail.ACTION_TYPE_ID eq 240>
                        <cf_get_lang_main no="1750.Toplu Gelen Havale">
                    <cfelseif Get_Action_Detail.ACTION_TYPE_ID eq 253>
                        <cf_get_lang_main no="1758.Toplu Giden Havale">
                    <cfelseif Get_Havale.ACTION_TYPE_ID eq 24>
                        <cf_get_lang_main no='422.Gelen Havale'>
                    <cfelseif Get_Havale.ACTION_TYPE_ID eq 25>
                        <cf_get_lang_main no='423.Giden Havale'>
                    </cfif>
                    </td>
                </tr>
                <tr>
                	<td>
                    <table border="0" cellpadding="0" cellspacing="0" width="100%">
					<cfoutput>
                    	<tr>
                        	<td style="height:6mm;width:25mm;"><strong><cf_get_lang_main no="109.Banka"> <cf_get_lang_main no="240.Hesap"> :</strong></td>
                            <td><cfif Len(account_id_)>#get_account_info.ACCOUNT_NAME# #get_account_info.ACCOUNT_CURRENCY_ID#</cfif></td>
                        </tr>
                        <tr>
                        	<td style="height:6mm;width:25mm;"><strong><cf_get_lang_main no="330.Tarih"> :</strong></td>
                            <td><cfif get_action_detail.RecordCount>#dateformat(get_action_detail.action_date,dateformat_style)#<cfelse>#dateformat(get_havale.action_date,dateformat_style)#</cfif></td>
                        </tr>
					</cfoutput>
                    </table>
                    </td>
                </tr>
                <tr><td colspan="4">&nbsp;</td></tr>
                <tr>
                    <td colspan="4" valign="top">
                    <table border="0" cellpadding="0" cellspacing="0" width="100%">
                        <tr class="box_yazi">
                            <td style="width:19mm;height:6mm;"><cf_get_lang_main no="468.Belge No"></td>
                            <td style="width:45mm;"><cf_get_lang_main no="164.Çalışan"> <cf_get_lang_main no="240.Hesap"></td>
                            <td style="width:15mm;text-align:right;"><cf_get_lang_main no="80.TOPLAM"></td>
                            <td style="width:50mm;">&nbsp;</td>
                        </tr>
                       	<cfif Get_Action_Detail.RecordCount>
                        	<cfoutput query="Get_Action_Detail">
                            <tr>
                                <td style="width:19mm;">#Paper_No#</td>
                                <td style="width:45mm;height:6mm;">
                                <cfif len(ACTION_TO_COMPANY_ID)>
									#get_par_info(ACTION_TO_COMPANY_ID,1,1,0)#
                                <cfelseif len(ACTION_FROM_COMPANY_ID)>
									#get_par_info(ACTION_FROM_COMPANY_ID,1,1,0)#                                   
                                <cfelseif len(ACTION_TO_CONSUMER_ID)>
									#get_cons_info(ACTION_TO_CONSUMER_ID,0,0)#
                                <cfelseif len(ACTION_FROM_CONSUMER_ID)>
                                    #get_cons_info(ACTION_FROM_CONSUMER_ID,0,0)#
                                <cfelseif len(ACTION_TO_EMPLOYEE_ID)>
                                    #get_emp_info(ACTION_TO_EMPLOYEE_ID,0,0)#
                                <cfelseif len(ACTION_FROM_EMPLOYEE_ID)>
                                    #get_emp_info(ACTION_FROM_EMPLOYEE_ID,0,0)#
                                </cfif>
                                </td>
                                <td style="width:25mm;text-align:right;">#TLFormat(action_value_other)# #ACTION_CURRENCY#</td>
                                <td style="width:50mm;">&nbsp;</td>
                            </tr>
                            </cfoutput>
                        </cfif>
                    </table>
                    </td>
                </tr>
                <tr>
                	<td colspan="4">
                    <table>
					<cfoutput>
                    	<tr><td style="height:5mm;">&nbsp;</td></tr>
                    	<tr>
                        	<td style="height:10mm;"><font size="2">
							<cfif Get_Action_Detail.RecordCount>
                            	#Get_Action_Detail.ACTION_DETAIL#
							<cfelseif Get_Havale.RecordCount>
                            	#Get_Havale.ACTION_DETAIL#
                            </cfif></font>
                            </td>
                        </tr>
                        <tr>
                        	<td class="box_yazi"><font size="2">#session.ep.company#</font></td>
                        </tr>
					</cfoutput>
                    </table>
                    </td>
                </tr>
            </table>
            </td>
        </tr>
    </table>
</cfif>
