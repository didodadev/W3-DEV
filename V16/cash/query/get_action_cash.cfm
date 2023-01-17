<cfif not isdefined("attributes.db_adres")>
	<cfset db_adres = "#dsn2#">
</cfif>
<cfquery name="GET_ACTION_CASH" datasource="#db_adres#">
	SELECT
		CASH_NAME
	FROM
		CASH
	WHERE	
		CASH_ID = #CASH_ID#
</cfquery>
