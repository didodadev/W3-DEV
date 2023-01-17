<cfsetting showdebugoutput="no">
<cfif isdefined('attributes.branch_id') and attributes.branch_id is not "">
	<cfquery name="get_departmant" datasource="#dsn#">
		SELECT * FROM DEPARTMENT WHERE  DEPARTMENT_STATUS = 1 AND  BRANCH_ID = #attributes.branch_id# ORDER BY DEPARTMENT_HEAD
	</cfquery>
	<select name="department" id="department" style="width:150px;">
		<option value="">Departman Seçiniz</option>
		<cfoutput query="get_departmant">
			<option value="#DEPARTMENT_ID#">#DEPARTMENT_HEAD#</option>
		</cfoutput>
	</select>
	<cfabort>
</cfif>
<select name="department" id="department" style="width:150;">
	<option value="">Departman Seçiniz</option>
</select>

