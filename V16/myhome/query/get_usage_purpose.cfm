<cfquery name="GET_USAGE_PURPOSE" datasource="#dsn#">
	SELECT 
		USAGE_PURPOSE_ID, 
		USAGE_PURPOSE 
	FROM 
		SETUP_USAGE_PURPOSE
	<cfif isdefined("attributes.purpose_id")>
	WHERE
		USAGE_PURPOSE_ID = #attributes.purpose_id#
	</cfif>
	ORDER BY 
		USAGE_PURPOSE
</cfquery>
