<cfstoredproc procedure="GET_MY_SETTINGS" datasource="#DSN#" >
	<cfif isdefined("attributes.employee_id") and len(attributes.employee_id)>
		<cfprocparam cfsqltype="cf_sql_integer" value="#attributes.employee_id#">
    <cfelse>
    	<cfprocparam cfsqltype="cf_sql_integer" value="#session.ep.userid#">	 
    </cfif>
    <cfprocresult name="MY_SETT">     
</cfstoredproc>