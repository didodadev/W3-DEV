<cfquery name="GET_ASSETP_GROUPS" datasource="#DSN#">
	SELECT
		GROUP_ID,
		GROUP_NAME
	FROM
		SETUP_ASSETP_GROUP
	ORDER BY 
		GROUP_NAME
</cfquery>
