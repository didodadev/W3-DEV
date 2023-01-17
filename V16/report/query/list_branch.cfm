<cfsetting showdebugoutput="no">
<cfif isdefined('attributes.comp_id') and attributes.comp_id is not "">
	<cfquery name="get_branchs" datasource="#dsn#">
		SELECT 
			BRANCH_ID,
			BRANCH_NAME 
		FROM 
			BRANCH
		WHERE
			COMPANY_ID = #attributes.comp_id# AND
			BRANCH_ID IN (SELECT BRANCH_ID FROM EMPLOYEE_POSITION_BRANCHES WHERE POSITION_CODE = #session.ep.position_code#)
		ORDER BY
			BRANCH_ID
	</cfquery>
	<select name="branch_id" id="branch_id" style="width:150px;" onChange="showDepartment(this.value)">
		<option value=""><cf_get_lang dictionary_id="29434.Şubeler"></option>
		<cfoutput query="get_branchs">
			<option value="#branch_id#" <cfif isdefined("attributes.branch_id") and attributes.branch_id eq branch_id>selected</cfif>>#branch_name#</option>
		</cfoutput>
	</select>
	<cfabort>
</cfif>
<select name="branch_id" id="branch_id" style="width:150px;" onChange="showDepartment(this.value)">
	<option value=""><cf_get_lang dictionary_id="29434.Şubeler"></option>
</select>
<script type="text/javascript">
	showDepartment("");
</script>

