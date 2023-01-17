<cfquery name="GET_POS_EQUIPMENT" datasource="#DSN3#">
	SELECT
		*
	FROM
		POS_EQUIPMENT
	WHERE
		POS_ID IS NOT NULL
	<cfif isdefined("attributes.keyword") and len(attributes.keyword)>
		AND EQUIPMENT LIKE '%#attributes.keyword#%' COLLATE SQL_Latin1_General_CP1_CI_AI
	</cfif>
	<cfif isdefined("attirbutes.pos_id") and len(attirbutes.pos_id)>
		AND POS_ID = #attirbutes.pos_id#
	</cfif>
	<cfif isdefined("attributes.branch_id") and len(attributes.branch_id)>
		AND	BRANCH_ID = #attributes.branch_id#
	</cfif>
	<cfif isdefined("attributes.status") and len(attributes.status)>
		AND	IS_STATUS = #attributes.status#
	</cfif>	
</cfquery>
