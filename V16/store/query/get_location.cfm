<cfquery name="GET_LOCATION" datasource="#dsn#">
	SELECT 
		* 
	FROM 
		STOCKS_LOCATION
	<cfif len(attributes.DEPARTMENT)>
	WHERE 
		DEPARTMENT_ID = #attributes.DEPARTMENT#
	</cfif>
</cfquery>
