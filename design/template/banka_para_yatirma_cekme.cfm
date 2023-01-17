<!--- Para Yatırma Para Çekme print şablonu --->
<cfif not isdefined("attributes.action_id")>
	<cfset attributes.action_id = attributes.checked_value>
</cfif>
<cfif len(attributes.action_id)>
    <cfquery name="Get_Action_Detail" datasource="#dsn2#">
        SELECT * FROM BANK_ACTIONS WHERE ACTION_ID = #attributes.action_id#
    </cfquery>
    
    <cfset account_id_ = "">
    <cfset action_company_id = "">
    <cfset action_consumer_id = "">
    <cfset action_employee_id = "">

   
    <cfif len(Get_Action_Detail.ACTION_TO_ACCOUNT_ID)>
        <cfset account_id_ = Get_Action_Detail.action_to_account_id>
    <cfelseif len(Get_Action_Detail.ACTION_FROM_ACCOUNT_ID)>
        <cfset account_id_ = Get_Action_Detail.ACTION_FROM_ACCOUNT_ID>
    </cfif>
    <cfif len(Get_Action_Detail.action_to_cash_id)>
        <cfset cash_id_ = Get_Action_Detail.action_to_cash_id>
    <cfelseif len(Get_Action_Detail.action_from_cash_id)>
        <cfset cash_id_ = Get_Action_Detail.action_from_cash_id>
    </cfif>
    
    <cfset detail_ = "">
	<cfif Get_Action_Detail.RecordCount>
    	<cfset detail_ = Get_Action_Detail.ACTION_DETAIL>
    </cfif>    
    <cfif len(account_id_)>
        <cfquery name="get_account_info" datasource="#dsn3#">
            SELECT ACCOUNT_NAME,ACCOUNT_CURRENCY_ID FROM ACCOUNTS WHERE ACCOUNT_ID = #account_id_#
        </cfquery>
    </cfif>
    <cfif len(cash_id_)>
        <cfquery name="get_cash_info" datasource="#dsn2#">
            SELECT CASH_NAME FROM CASH WHERE CASH_ID = #cash_id_#
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
                    <cfoutput>
						<cfif Get_Action_Detail.ACTION_TYPE_ID eq 21>
                            #getLang('bank',100)#
                        <cfelseif Get_Action_Detail.ACTION_TYPE_ID eq 22>
                            #getLang('bank',101)#
                        </cfif>
                    </cfoutput>
                    </td>
                </tr>
                <tr>
                	<td>
                    <table border="0" cellpadding="0" cellspacing="0" width="100%">
					<cfoutput>
                    	<tr>
                        	<td style="height:6mm;width:25mm;"><strong>#getLang('prod',452,'işlemi yapan')#</strong></td>
                            <td><cfif len(get_action_detail.ACTION_EMPLOYEE_ID)>
                                    #get_emp_info(get_action_detail.ACTION_EMPLOYEE_ID,0,0)#
                                </cfif>
                            </td>
                        </tr>
                        <tr>
                        	<td style="height:6mm;width:25mm;"><strong><cf_get_lang_main no="330.Tarih"> :</strong></td>
                            <td><cfif get_action_detail.RecordCount>#dateformat(get_action_detail.action_date,dateformat_style)#</cfif></td>
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
                            <td style="width:45mm;"><cf_get_lang_main no="109.Banka"> <cf_get_lang_main no="240.Hesap"></td>
                            <td style="width:45mm;"><cf_get_lang_main no='108.Kasa'></td>
                            <td style="width:15mm;text-align:right;"><cf_get_lang_main no="80.TOPLAM"></td>
                            <td style="width:50mm;">&nbsp;</td>
                        </tr>
							<cfoutput query="get_action_detail">
                            <tr>
                                <td style="width:19mm;">#Paper_No#</td>
                                <td style="width:45mm;height:6mm;">
                                <cfif Len(account_id_)>#get_account_info.ACCOUNT_NAME# #get_account_info.ACCOUNT_CURRENCY_ID#</cfif>
                                </td>
                                <td style="width:45mm;"><cfif len(cash_id_)>#get_cash_info.cash_name#</cfif></td>
                                <td style="width:25mm;text-align:right;">#TLFormat(other_cash_act_value)# #OTHER_MONEY#</td>
                                <td style="width:50mm;">&nbsp;</td>
                            </tr>
                            </cfoutput>
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
