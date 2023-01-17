<cfquery name="get_app_identy" datasource="#dsn#">
	SELECT * FROM EMPLOYEES_IDENTY WHERE EMPAPP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.EMPAPP_ID#">
</cfquery>
