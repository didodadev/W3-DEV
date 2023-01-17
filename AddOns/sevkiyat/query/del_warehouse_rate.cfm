<cfquery name="add_" datasource="#dsn3#">
	DELETE FROM
		WAREHOUSE_RATES
	WHERE
		RATE_ID = #attributes.rate_id#
</cfquery>

<cfquery name="del_" datasource="#dsn3#">
	DELETE FROM WAREHOUSE_RATES_ROWS WHERE RATE_ID = #attributes.rate_id#
</cfquery>
<cflocation url="#request.self#?fuseaction=settings.list_warehouse_rates" addtoken="no">