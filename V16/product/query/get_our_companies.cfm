<cfquery name="GET_OUR_COMPANIES" datasource="#DSN#">
	SELECT 
		COMP_ID,
		NICK_NAME
	FROM
		OUR_COMPANY
	ORDER BY
		NICK_NAME
</cfquery>
