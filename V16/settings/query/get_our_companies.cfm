<cfquery name="OUR_COMPANY" datasource="#DSN#">
	SELECT 
	    COMP_ID,
		COMPANY_NAME,
		NICK_NAME
	FROM 
	    OUR_COMPANY
	ORDER BY 
		COMPANY_NAME
</cfquery>
