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
    
    <cfoutput>
        <cf_woc_header>
        <cf_woc_elements>
            <cfif Get_Action_Detail.ACTION_TYPE_ID eq 21>
                <cf_wuxi id="item_header" label="48761">
            <cfelseif Get_Action_Detail.ACTION_TYPE_ID eq 22>
                <cf_wuxi id="item_header_2" label="48762">
            </cfif>  
            <cf_wuxi id="wuxi-623568" data="&nbsp;" label="" type="cell">
            <cf_wuxi id="ACTION_EMPLOYEE_ID" data="#iif(len(get_action_detail.ACTION_EMPLOYEE_ID),'get_emp_info(get_action_detail.ACTION_EMPLOYEE_ID,0,0)',DE(''))#" label="36765" type="cell">
            <cf_wuxi id="action_date" data="#dateformat(get_action_detail.action_date,dateformat_style)#" label="30631" type="cell">
            <cfif Get_Action_Detail.RecordCount>
               <cfset detail_= Get_Action_Detail.ACTION_DETAIL>
            <cfelseif Get_Havale.RecordCount>
                <cfset detail_= Get_Havale.ACTION_DETAIL>
            </cfif> 
            <cf_wuxi id="details" data="#detail_#" label="57771" type="cell">

        </cf_woc_elements>

        <cf_woc_list id="aaa">
            <thead>
                <tr>
                    <cf_wuxi label="57880" type="cell" is_row="0" id="wuxi_57880"> 
                    <cf_wuxi label="57521+57652" type="cell" is_row="0" id="wuxi_57521_57652"> 
                    <cf_wuxi label="57520" type="cell" is_row="0" id="wuxi_57520"> 
                    <cf_wuxi label="57492" type="cell" is_row="0" id="wuxi_57492"> 
                    <cf_wuxi label="" type="cell" is_row="0" id="wuxi_00000">  
                </tr>
            </thead>
            <tbody>
                <tr>
                    <cfsavecontent variable="acc_name">
                        <cfif len(account_id_)>
                            #get_account_info.ACCOUNT_NAME#&nbsp
                            #get_account_info.ACCOUNT_CURRENCY_ID#
                        </cfif>
                    </cfsavecontent>
                    <cfif len(Get_Action_Detail.Paper_No)> 
                        <cf_wuxi data="#Get_Action_Detail.Paper_No#" type="cell" is_row="0"> <cfelse><td>&nbsp;</td></cfif>
                    <cf_wuxi data="#acc_name#" type="cell" is_row="0"> 
                    <cf_wuxi data="#iif(len(cash_id_),'get_cash_info.cash_name',DE('')) # " type="cell" is_row="0">  
                    <cfif not isDefined("other_cash_act_value")><cfset act_value=0></cfif>
                    <cf_wuxi data="#TLFormat(Get_Action_Detail.other_cash_act_value)# #Get_Action_Detail.OTHER_MONEY#" type="cell" is_row="0"> 
                    <cf_wuxi data="" type="cell" is_row="0">
                </tr>
            </tbody>
        </cf_woc_list> 
    </cfoutput>
</cfif>
<cf_woc_footer>
