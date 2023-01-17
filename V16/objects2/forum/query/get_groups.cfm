<cfquery name="GROUPS" datasource="#dsn#">
	SELECT
		GROUP_NAME
	FROM
		USERS
	WHERE
		GROUP_ID IN (#attributes.GROUP_IDS#)
</cfquery>	
	
