<cfquery name="GET_BUGS" datasource="#DSN_DEV#">
	SELECT 
		B.*,
		BS.BUG_STATUS_NAME
	FROM
		BUG_REPORT B,
		BUG_STATUS BS
	WHERE
		B.STAGE_ID = -2
		AND
		BS.BUG_STATUS_ID = B.BUG_STATUS_ID
		<cfif isdefined("attributes.keyword")>
		AND
		(
		B.BUG_HEAD LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.keyword#%">
		OR
		B.BUG_BODY LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.keyword#%">
		OR
		B.BUG_CIRCUIT LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.keyword#%">
		OR
		B.BUG_FUSEACTION LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.keyword#%">
		OR
		B.BUG_SOLUTION LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.keyword#%">
		OR
		B.WORKCUBE_USERNAME LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.keyword#%">
		OR
		B.WORKCUBE_SURNAME LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.keyword#%">
		OR
		B.WORKCUBE_COMPANY LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.keyword#%">
		)		
		AND
		B.BUG_STATUS_ID IS NOT NULL
		</cfif>
</cfquery>
