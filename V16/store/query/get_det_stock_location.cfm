<cfquery name="GET_DET_STOCK_LOCATION" datasource="#dsn#">
	SELECT 
		* 
	FROM 
		STOCKS_LOCATION
	WHERE
		DEPARTMENT_LOCATION LIKE '#attributes.ID#'
</cfquery>
