<cfsetting showdebugoutput="no">
<cfif IsDefined('attributes.employee_id')>
	<cfif  attributes.employee_id contains '-' or attributes.employee_id contains '_'>
      <cfset emp_id = ListToArray(attributes.employee_id,'_')>
      <cfset empl_id = emp_id[1]>
    <cfelse>
        <cfset empl_id = attributes.employee_id>
    </cfif>
</cfif>
<cfquery name="list_bank_account" datasource="#dsn#">
	SELECT 
		<cfif isdefined('attributes.consumer_id')>
            CONSUMER_BANK_ID,
            CONSUMER_ACCOUNT_NO,
            CONSUMER_BANK,
            CONSUMER_BANK_BRANCH,
            CONSUMER_ACCOUNT_DEFAULT,
            MONEY
        <cfelseif isdefined('attributes.company_id')>
        	COMPANY_BANK_ID,
            COMPANY_ACCOUNT_NO,
            COMPANY_BANK,
            COMPANY_BANK_BRANCH,
            COMPANY_ACCOUNT_DEFAULT,
            COMPANY_BANK_MONEY
        <cfelseif isdefined('empl_id')>
        	EMP_BANK_ID,
            BANK_ACCOUNT_NO,
            BANK_NAME,
            BANK_BRANCH_NAME,
            DEFAULT_ACCOUNT,
            MONEY
        </cfif>
       
      
	FROM 
		<cfif isdefined('attributes.consumer_id')>
            CONSUMER_BANK
        <cfelseif isdefined('attributes.company_id')>
            COMPANY_BANK
        <cfelseif isdefined('empl_id')>
       		EMPLOYEES_BANK_ACCOUNTS
		</cfif>
        

	WHERE
		<cfif isdefined('attributes.consumer_id')>
            CONSUMER_ID = #attributes.consumer_id#
        <cfelseif isdefined('attributes.company_id')>
            COMPANY_ID = #attributes.company_id#
        <cfelseif isdefined('empl_id')>
            EMPLOYEE_ID = #empl_id#
		</cfif>
        
		
</cfquery>
<select name="list_bank" id="list_bank" style="width:250px;">
    <option value="">Banka Hesabı Seçiniz</option>
		<cfoutput query="list_bank_account">
        	<cfif isdefined('attributes.consumer_id')>
            	<option value="#CONSUMER_BANK_ID#" <cfif CONSUMER_ACCOUNT_DEFAULT 	eq 1> selected</cfif>>#CONSUMER_BANK#-#CONSUMER_BANK_BRANCH#-#CONSUMER_ACCOUNT_NO#-#MONEY# </option>
            <cfelseif isdefined('attributes.company_id')>
            	<option value="#COMPANY_BANK_ID#" <cfif COMPANY_ACCOUNT_DEFAULT eq 1>selected</cfif>>#COMPANY_BANK#-#COMPANY_BANK_BRANCH#-#COMPANY_ACCOUNT_NO#-#COMPANY_BANK_MONEY#</option>
            <cfelseif isdefined('empl_id')>
            <option value="#EMP_BANK_ID#" <cfif DEFAULT_ACCOUNT eq 1>selected</cfif>>#BANK_NAME#-#BANK_BRANCH_NAME#-#BANK_ACCOUNT_NO#-#MONEY#</option>
			</cfif>
        </cfoutput>
</select>
