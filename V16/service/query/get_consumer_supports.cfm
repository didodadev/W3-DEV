<cfquery name="GET_SERVICE_SUPPORT" datasource="#DSN3#">
	SELECT
		*
	FROM
		SERVICE_SUPPORT,
		#dsn_alias#.SETUP_SUPPORT AS SETUP_SUPPORT
		
	WHERE 
		SERVICE_SUPPORT.SUPPORT_CAT_ID=SETUP_SUPPORT.SUPPORT_CAT_ID
		<cfif isDefined("attributes.keyword") and len(attributes.keyword)>
			AND
			(
				SERVICE_SUPPORT.SUPPORT_HEAD LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.keyword#%">
				OR
				SERVICE_SUPPORT.SUPPORT_NO LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.keyword#%">
			)	
		</cfif>
		<cfif isDefined("attributes.category") AND len(attributes.category)>
			AND SERVICE_SUPPORT.SUPPORT_CAT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.category#"> 
		</cfif> 
</cfquery>
