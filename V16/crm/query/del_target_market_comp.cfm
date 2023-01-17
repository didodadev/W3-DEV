<cfquery name="DEL_TMARKET" datasource="#dsn3#">
	DELETE FROM TARGET_MARKETS WHERE TMARKET_ID = #attributes.tmarket_id#
</cfquery>	


