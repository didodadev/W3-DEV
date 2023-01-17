<cfsetting showdebugoutput="no"> 
<cfquery name="GET_BANK_CONSUMER" datasource="#DSN#">
	SELECT 
		* 
	FROM 
	<cfif attributes.action_type eq 'CONSUMER'>
		CONSUMER_BANK
	<cfelseif attributes.action_type eq 'COMPANY'>
		COMPANY_BANK
	<cfelseif attributes.action_type eq 'EMPLOYEE'>
		EMPLOYEES_BANK_ACCOUNTS
	</cfif>
	WHERE
	<cfif attributes.action_type eq 'CONSUMER'>
		CONSUMER_ID = #attributes.action_id#
	<cfelseif attributes.action_type eq 'COMPANY'>
		COMPANY_ID = #attributes.action_id#
	<cfelseif attributes.action_type eq 'EMPLOYEE'>
		EMPLOYEE_ID = #attributes.action_id#
	</cfif>
</cfquery>

<div id="cont" style="z-index:1;overflow:auto;">
    <cf_ajax_list>
        <tbody>
        <cfif get_bank_consumer.recordcount>
            <cfoutput query="get_bank_consumer">
                <tr id="banka">
                    <td colspan="2">
                        <cfif attributes.action_type eq 'CONSUMER'>
                            <a href="javascript:openBoxDraggable('#request.self#?fuseaction=objects.popup_form_upd_bank_account&bid=#consumer_bank_id#&cid=#attributes.action_id#');" >#consumer_bank# - #consumer_bank_branch#<br />#consumer_account_no# <br />#consumer_iban_code# #money#</a>
                        <cfelseif attributes.action_type eq 'COMPANY'>
                            <a href="javascript:openBoxDraggable('#request.self#?fuseaction=objects.popup_form_upd_bank_account&bid=#company_bank_id#&cpid=#attributes.action_id#');">#company_bank# - #company_bank_branch#<br />#company_account_no# <br />#company_iban_code# #company_bank_money#</a>
                        <cfelseif attributes.action_type eq 'EMPLOYEE'>
                            <a href="javascript:openBoxDraggable('#request.self#?fuseaction=objects.popup_form_upd_bank_account&bid=#emp_bank_id#&employee_id=#attributes.action_id#');" >#bank_name# - #bank_branch_code#/#bank_account_no# <br />#iban_no# (#money#)</a>
                        </cfif>
                    </td>
                </tr>
            </cfoutput>
        <cfelse>
            <tr id="banka">
                <td colspan="2">
                    <cf_get_lang dictionary_id='57484.Kayıt Yok'>!
                </td>
            </tr> 
        </cfif>
        </tbody>  
    </cf_ajax_list>
</div>
