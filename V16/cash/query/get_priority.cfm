<cfquery name="GET_PRIORITY" datasource="#dsn#">
	SELECT
		*
	FROM
		SETUP_PRIORITY
		<cfif isdefined('attributes.priority_id') and len(attributes.priority_id)>
	WHERE
		PRIORITY_ID=#attributes.priority_id#
		</cfif>
	ORDER BY
		PRIORITY_ID
</cfquery>
