<cfquery name="upd_call_rec" datasource="dsn">
UPDATE
		G_SERVICE
	SET
		SERVICE_HEAD = '#SERVICE_HEAD#',
		SERVICE_DETAIL = <cfif len(SERVICE_DETAIL)>'#SERVICE_DETAIL#'<cfelse>NULL</cfif>
	WHERE
		SERVICE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#url.id#">
</cfquery>

