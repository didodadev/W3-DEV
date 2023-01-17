
<cfquery name="GET_USERS" datasource="#dsn#">
	SELECT 
		TO_ALL,
		GROUP_NAME,
		POSITIONS,
		PARTNERS,
		CONSUMERS
	FROM 
		USERS
	WHERE
		GROUP_ID = #attributes.GROUP_ID#
</cfquery>		

