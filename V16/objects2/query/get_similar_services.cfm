<cfquery name="GET_SIMILAR_SERVICES" datasource="#dsn3#">
	SELECT
		SERVICE.* ,
		SERVICE_APPCAT.SERVICECAT,
		#dsn_alias#.SETUP_COMMETHOD.COMMETHOD,
		#dsn_alias#.SETUP_PRIORITY.PRIORITY,
		#dsn_alias#.SETUP_PRIORITY.COLOR,
		SERVICE_STATUS.SERVICE_STATUS
	FROM
		SERVICE,
		SERVICE_APPCAT,
		#dsn_alias#.SETUP_COMMETHOD,
		#dsn_alias#.SETUP_PRIORITY,
		SERVICE_STATUS
	WHERE
		SERVICE.SERVICECAT_ID = SERVICE_APPCAT.SERVICECAT_ID AND 
		#dsn_alias#.SETUP_COMMETHOD.COMMETHOD_ID = SERVICE.COMMETHOD_ID AND
		#dsn_alias#.SETUP_PRIORITY.PRIORITY_ID = SERVICE.PRIORITY_ID AND
		SERVICE_STATUS.SERVICE_STATUS_ID = SERVICE.SERVICE_STATUS_ID
		<cfif isdefined("attributes.keyword") and LEN(attributes.keyword) and not isdefined("attributes.service_product_id")>
		   AND SERVICE.SERVICE_HEAD LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.keyword#%">
		<cfelseif isdefined("attributes.keyword") and LEN(attributes.keyword) and  isdefined("attributes.service_product_id")>
		   AND
		   (SERVICE.SERVICE_HEAD LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.keyword#%">
		     OR
			SERVICE.SERVICE_PRODUCT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.service_product_id#">
			)		
		<cfelseif isdefined("attributes.keyword") and not LEN(attributes.keyword) and isdefined("attributes.service_product_id")>
		 	AND SERVICE.SERVICE_PRODUCT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.service_product_id#">
		</cfif>
		<cfif isdefined("attributes.id")>
			AND SERVICE.SERVICE_ID <> <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.id#">
		</cfif>
	ORDER BY SERVICE.RECORD_DATE
</cfquery>
