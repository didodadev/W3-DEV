<cfquery name="GET_POSITION_CATS" datasource="#DSN#">
	SELECT 
		POSITION_CAT_ID,
		#dsn#.Get_Dynamic_Language(POSITION_CAT_ID,'#session.ep.language#','SETUP_POSITION_CAT','POSITION_CAT',NULL,NULL,POSITION_CAT) AS POSITION_CAT
	FROM 
		SETUP_POSITION_CAT
	WHERE
		<cfif isdefined("attributes.keyword") and len(attributes.keyword)>
		POSITION_CAT LIKE '<cfif len(attributes.keyword) gt 1>%</cfif>#attributes.keyword#%' AND
		</cfif>
		POSITION_CAT_STATUS = 1
	ORDER BY 
		POSITION_CAT 
</cfquery>
