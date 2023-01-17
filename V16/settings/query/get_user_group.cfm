<cfquery name="GET_USER_GROUP" datasource="#DSN#">
	SELECT
		*
	FROM
		USER_GROUP
	WHERE
		USER_GROUP_ID=#attributes.ID#
</cfquery>
