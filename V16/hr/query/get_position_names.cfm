<cfquery name="get_pos_name" datasource="#dsn#">
	SELECT
		POS_NAME_ID,
		#dsn#.Get_Dynamic_Language(POS_NAME_ID,'#session.ep.language#','EMPLOYEE_POSITION_NAMES','POSITION_NAME',NULL,NULL,POSITION_NAME) AS POSITION_NAME
	FROM
		EMPLOYEE_POSITION_NAMES
	WHERE
		POS_NAME_ID IS NOT NULL
	<cfif isdefined("attributes.keyword") and len(attributes.keyword) eq 1>
		AND POSITION_NAME LIKE '#attributes.keyword#%'
	<cfelseif isdefined("attributes.keyword") and len(attributes.keyword) gt 1>
		AND POSITION_NAME LIKE '%#attributes.keyword#%'
	</cfif>			
	<cfif isdefined('attributes.id')>
		AND POS_NAME_ID=#attributes.id#	
	</cfif>
	ORDER BY POSITION_NAME
</cfquery>
