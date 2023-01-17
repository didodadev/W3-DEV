<cfquery name="del_rank" datasource="#DSN#">
  DELETE FROM EMPLOYEES_RANK_DETAIL WHERE ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.id#">
</cfquery>	
<cflocation addtoken="no" url="#request.self#?fuseaction=hr.popup_form_add_rank&employee_id=#attributes.employee_id#">
