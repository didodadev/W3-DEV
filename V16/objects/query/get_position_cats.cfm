<cfquery name="GET_POSITION_CATS" datasource="#dsn#">
	SELECT 
	POSITION_CAT_ID,
	#dsn#.Get_Dynamic_Language(POSITION_CAT_ID,'#session.ep.language#','SETUP_POSITION_CAT','POSITION_CAT',NULL,NULL,POSITION_CAT) AS POSITION_CAT
	FROM 
		SETUP_POSITION_CAT
	WHERE
		POSITION_CAT_STATUS = 1
		<cfif isdefined("attributes.keyword") and len(attributes.keyword)>
			AND POSITION_CAT LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.keyword#%">
		</cfif>
		<cfif isdefined("attributes.position_hierarchy") and len(attributes.position_hierarchy)>
			AND HIERARCHY = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.position_hierarchy#">
		</cfif>
	ORDER BY 
		POSITION_CAT 
</cfquery>
