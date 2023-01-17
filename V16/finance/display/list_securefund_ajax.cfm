<cfparam name="attributes.submitted_branch" default="">
<cfparam name="attributes.deny_control" default="0">
<cfif isdefined("attributes.our_company_id")>
    <cfquery name="ALL_BRANCHES" datasource="#DSN#">
	SELECT
		BRANCH_NAME,
		BRANCH_ID
	FROM 
		BRANCH
	WHERE
    	COMPANY_ID = #val(attributes.our_company_id)# AND
        BRANCH_STATUS = 1
        <cfif attributes.deny_control eq 1>
	        AND BRANCH_ID IN (SELECT BRANCH_ID FROM EMPLOYEE_POSITION_BRANCHES WHERE POSITION_CODE = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.position_code#">)
        </cfif>
    ORDER BY
    	BRANCH_NAME
    </cfquery>
    <select name="comp_branch_id" id="comp_branch_id" style="width:150px">
    	<option value=""><cf_get_lang_main no='41.Şube'></option>
        <cfoutput query="ALL_BRANCHES">
            <option value="#branch_id#" <cfif attributes.submitted_branch eq branch_id>selected</cfif>>#branch_name#</option>
        </cfoutput>
    </select>
</cfif>
