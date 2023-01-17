<cfquery name="GET_PRODUCTION_STOCKS_SHOW" datasource="#DSN3#">
	SELECT 
		* 
	FROM 
		GET_PRODUCTION_STOCKS 
	WHERE 
		STOCK_ID=#attributes.s_id#
</cfquery>
