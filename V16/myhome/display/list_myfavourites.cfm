<cfinclude template="../query/my_sett.cfm">
<cfif isdefined("attributes.employee_id")>
  <cfquery name="get_employee_name" datasource="#DSN#">
  		SELECT 
			EMPLOYEE_NAME , 
			EMPLOYEE_SURNAME 
		FROM 
			EMPLOYEES 
		WHERE 
			EMPLOYEES.EMPLOYEE_ID=
            <cfif isdefined("attributes.employee_id") and len(attributes.employee_id)>
            	<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.employee_id#">
            <cfelse>
            	<cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#">
            </cfif>
  </cfquery>
</cfif>
<cfinclude template="../includes/list_favourites.cfm">


