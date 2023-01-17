<cfquery name="get_our_companies" datasource="#DSN#">
	SELECT 
		COMP_ID,
		NICK_NAME
	FROM
		OUR_COMPANY
	ORDER BY
		NICK_NAME
</cfquery>
