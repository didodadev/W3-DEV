<cfquery name="GET_GROUPS" datasource="#dsn#">
	SELECT
		GROUP_ID,
		GROUP_NAME
	FROM
		USERS
	WHERE
		GROUP_ID IN (#attributes.GROUP_IDS#)
</cfquery>
