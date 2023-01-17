<!---
    File: banka_gelen_giden_havale.cfm
    Folder: WTO\Print\Preview\
    Author:
    Date:
    Description:
        Gelen Giden Havale ve Toplu Gelen Giden Havale print şablonu
    History:

    To Do:

--->

<cfif len(attributes.action_id)>
	<cfset is_multi = 0 />
	<cfif isDefined('attributes.keyword') And attributes.keyword Eq 'multi'>
		<cfset is_multi = 1 />
	</cfif>
	<cfif is_multi>
		<cfquery name="Get_Havale" datasource="#dsn2#">
			SELECT * FROM BANK_ACTIONS_MULTI WHERE MULTI_ACTION_ID = #attributes.action_id#
		</cfquery>
	<cfelse>
		<cfquery name="Get_Havale" datasource="#dsn2#">
			SELECT * FROM BANK_ACTIONS WHERE ACTION_ID = #attributes.action_id#
		</cfquery>
	</cfif>
	<cfif Len(Get_Havale.ACTION_TYPE_ID) and (Get_Havale.ACTION_TYPE_ID Eq 24) or (Get_Havale.ACTION_TYPE_ID Eq 25)>
    	<cfquery name="get_action_detail" datasource="#dsn2#">
            SELECT
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
			<cfif is_multi>
                BANK_ACTIONS_MULTI BAM,
			</cfif>
                BANK_ACTIONS BA
            WHERE
			<cfif is_multi>
                BAM.MULTI_ACTION_ID = BA.MULTI_ACTION_ID AND
                BAM.MULTI_ACTION_ID = #attributes.action_id#
			<cfelse>
				BA.ACTION_ID = #attributes.action_id#
			</cfif>
            ORDER BY
                BA.ACTION_ID
    	</cfquery>
    </cfif>

    <cfset account_id_ = "">
    <cfset action_company_id = "">
    <cfset action_consumer_id = "">
    <cfset action_employee_id = "">

    <!--- Toplu Gelen / Giden --->
    <cfif is_multi And len(Get_Havale.TO_ACCOUNT_ID)>
        <cfset account_id_ = Get_Havale.TO_ACCOUNT_ID>
    <cfelseif is_multi And len(Get_Havale.FROM_ACCOUNT_ID)>
        <cfset account_id_ = Get_Havale.FROM_ACCOUNT_ID>
    <!--- Gelen / Giden Havale --->
    <cfelseif is_multi Eq 0 And len(Get_Havale.ACTION_TO_ACCOUNT_ID)>
        <cfset account_id_ = Get_Havale.action_to_account_id>
    <cfelseif is_multi Eq 0 And len(Get_Havale.ACTION_FROM_ACCOUNT_ID)>
        <cfset account_id_ = Get_Havale.ACTION_FROM_ACCOUNT_ID>
    </cfif>

    <cfif len(account_id_)>
        <cfquery name="get_account_info" datasource="#dsn3#">
            SELECT ACCOUNT_NAME, ACCOUNT_CURRENCY_ID FROM ACCOUNTS WHERE ACCOUNT_ID = #account_id_#
        </cfquery>
    </cfif>

   
    <cfif is_multi And Get_Havale.ACTION_TYPE_ID eq 24>
        <cf_woc_header title="#getLang('','Toplu Gelen Havale',29547)#">
    <cfelseif is_multi And Get_Havale.ACTION_TYPE_ID eq 25>
        <cf_woc_header title="#getLang('','Toplu Giden Havale',29555)#">
    <cfelseif is_multi Eq 0 And Get_Havale.ACTION_TYPE_ID eq 24>
        <cf_woc_header title="#getLang('','Gelen Havale',57834)#">
    <cfelseif is_multi Eq 0 And Get_Havale.ACTION_TYPE_ID eq 25>
        <cf_woc_header title="#getLang('','Giden Havale',57835)#">
    </cfif>
        <cf_woc_elements>
            <cfif Len(account_id_)>
                <cf_wuxi id="bank_acc" data="#get_account_info.ACCOUNT_NAME# #get_account_info.ACCOUNT_CURRENCY_ID#" label="50342" type="cell"></cfif>
            <cf_wuxi id="date" data="#dateformat(get_havale.action_date,dateformat_style)#" label="57742" type="cell">
            <cfif Get_Action_Detail.RecordCount>
                <cf_wuxi id="doc_no" data="#Get_Action_Detail.Paper_No#" label="57880" type="cell">
                <cfif len(Get_Action_Detail.ACTION_TO_COMPANY_ID)>
                    <cf_wuxi id="emp_acc" data="#get_par_info(Get_Action_Detail.ACTION_TO_COMPANY_ID,1,1,0)#" label="53363" type="cell">
                <cfelseif len(Get_Action_Detail.ACTION_FROM_COMPANY_ID)>
                    <cf_wuxi id="emp_acc" data="#get_par_info(Get_Action_Detail.ACTION_FROM_COMPANY_ID,1,1,0)#  " label="53363" type="cell">                                                    
                <cfelseif len(Get_Action_Detail.ACTION_TO_CONSUMER_ID)>
                    <cf_wuxi id="emp_acc" data="#get_cons_info(Get_Action_Detail.ACTION_TO_CONSUMER_ID,0,0)#" label="53363" type="cell">                   
                <cfelseif len(Get_Action_Detail.ACTION_FROM_CONSUMER_ID)>
                    <cf_wuxi id="emp_acc" data="#get_cons_info(Get_Action_Detail.ACTION_FROM_CONSUMER_ID,0,0)#" label="53363" type="cell">                  
                <cfelseif len(Get_Action_Detail.ACTION_TO_EMPLOYEE_ID)>
                    <cf_wuxi id="emp_acc" data="#get_emp_info(Get_Action_Detail.ACTION_TO_EMPLOYEE_ID,0,0)#" label="53363" type="cell">
                <cfelseif len(Get_Action_Detail.ACTION_FROM_EMPLOYEE_ID)>
                    <cf_wuxi id="emp_acc" data="#get_emp_info(Get_Action_Detail.ACTION_FROM_EMPLOYEE_ID,0,0)#" label="53363" type="cell">
                </cfif>
                <cf_wuxi id="total" data="#TLFormat(Get_Action_Detail.action_value_other)# #Get_Action_Detail.ACTION_CURRENCY#" label="57492" type="cell">
            </cfif>
        </cf_woc_elements>
   <cf_woc_footer>
</cfif>