<!--- Departmanlar --->
<cfsetting showdebugoutput="no">
<cfparam name="department_id" default="">
<cfif isdefined('attributes.branch_id') and attributes.branch_id is not "all">
	<cfquery name="get_departmant" datasource="#dsn#">
		SELECT DEPARTMENT_ID,DEPARTMENT_HEAD FROM DEPARTMENT WHERE DEPARTMENT_STATUS = 1 AND  BRANCH_ID = #attributes.branch_id# ORDER BY DEPARTMENT_HEAD
	</cfquery>
	<select name="department" id="department" style="width:150px;">
		<option value=""><cf_get_lang dictionary_id="57572.Departman"></option>
		<cfoutput query="get_departmant">
			<option value="#department_id#">#department_head#</option>
		</cfoutput>
	</select>
</cfif>
