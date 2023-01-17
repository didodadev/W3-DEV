<cfquery name="GET_GROUPS" datasource="#DSN#">
	SELECT
		GROUP_ID,
		GROUP_NAME
	FROM
		USERS
	WHERE
		GROUP_ID IN (#attributes.group_ids#)
</cfquery>
