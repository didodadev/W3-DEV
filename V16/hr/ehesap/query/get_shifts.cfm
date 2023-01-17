<cfquery name="get_shifts" datasource="#dsn#">
	SELECT
		*
	FROM
		SETUP_SHIFTS
	WHERE
		SHIFT_NAME IS NOT NULL
	<cfif isdefined('attributes.keyword') and len(attributes.keyword)>
		AND SHIFT_NAME LIKE  '%#attributes.keyword#%' COLLATE SQL_Latin1_General_CP1_CI_AI
	</cfif>
	<cfif isdefined('attributes.start_dates') and len(attributes.start_dates)>AND STARTDATE >= #attributes.start_dates# </cfif>
	<cfif isdefined('attributes.finish_dates') and len(attributes.finish_dates)>AND FINISHDATE <= #attributes.finish_dates# </cfif>
	<cfif isdefined('attributes.branch_id') and len(attributes.branch_id)>AND BRANCH_ID = #attributes.branch_id# </cfif>
</cfquery>
