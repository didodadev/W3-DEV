<cfquery name="GET_PRIORITY" datasource="#dsn#">
	SELECT
		*
	FROM
		SETUP_PRIORITY
	WHERE
		<cfif len(attributes.priority_id)>
		PRIORITY_ID=#attributes.priority_id#
		<cfelse>
		1=0
		</cfif>
</cfquery>
