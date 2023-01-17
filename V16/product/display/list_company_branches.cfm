<cfif isdefined('attributes.company_id') and len(attributes.company_id)>
	<cfquery name="GET_BRANCHES" datasource="#DSN#">
		SELECT BRANCH_ID, BRANCH_FULLNAME FROM BRANCH WHERE COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.company_id#">
	</cfquery>
	<select name="branches" id="branches" multiple="multiple">
		<cfoutput query="get_branches">
			<option value="#branch_id#" <cfif isdefined('attributes.branches') and listfind(attributes.branches,BRANCH_ID)>selected</cfif>>#branch_fullname#</option>
		</cfoutput>
	</select>	
</cfif>
<cfabort>
