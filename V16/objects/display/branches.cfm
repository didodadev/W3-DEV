<!--- Şubeler --->
<cfsetting showdebugoutput="no">
<cfparam name="branch_id" default="">
<cfif isdefined('attributes.company_id') and attributes.company_id is not "all">
	<cfquery name="GET_BRANCHES" datasource="#DSN#">
		SELECT
			BRANCH.BRANCH_STATUS,
			BRANCH.HIERARCHY,
			BRANCH.HIERARCHY2,
			BRANCH.BRANCH_ID,
			BRANCH.BRANCH_NAME,
			OUR_COMPANY.COMP_ID,
			OUR_COMPANY.COMPANY_NAME,
			OUR_COMPANY.NICK_NAME
		FROM
			BRANCH,
			OUR_COMPANY
		WHERE
			BRANCH.BRANCH_ID IS NOT NULL AND 
			BRANCH.COMPANY_ID = OUR_COMPANY.COMP_ID AND 
			BRANCH.BRANCH_STATUS = <cfqueryparam cfsqltype="cf_sql_smallint" value="1"> AND 
			BRANCH.COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.company_id#">
		ORDER BY
			OUR_COMPANY.NICK_NAME,
			BRANCH.BRANCH_NAME
	</cfquery>
	<select name="branch_id" id="branch_id" onChange="showDepartment(this.value)" style="width:150px;">
		<option value=""><cf_get_lang dictionary_id='57453.Şube'></option>
		<cfoutput query="get_branches">
			<option value="#branch_id#">#branch_name#</option>
		</cfoutput>
	</select>
</cfif>
