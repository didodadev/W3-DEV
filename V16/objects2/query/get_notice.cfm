<cfquery name="GET_NOTICE" datasource="#dsn#">
	SELECT * FROM NOTICES WHERE NOTICE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.notice_id#">
</cfquery>
