<cfquery name="GET_SERVICE" datasource="#dsn3#">
	SELECT
		SERVICE.SERVICE_ID,
		SERVICE.SERVICE_HEAD,
		SERVICE_APPCAT.SERVICECAT,
		SERVICE.SERVICE_DETAIL
	FROM
		SERVICE,
		SERVICE_APPCAT
	WHERE 
		SERVICE.SERVICECAT_ID = SERVICE_APPCAT.SERVICECAT_ID
		<cfif isDefined("attributes.CATEGORY") AND len(attributes.CATEGORY)>
			AND SERVICE.SERVICECAT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.category#">
		</cfif>
		<cfif isDefined("attributes.seri_no") AND len(attributes.seri_no)>
			AND SERVICE.PRO_SERIAL_NO = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.seri_no#">
		</cfif>		
		<cfif isDefined("attributes.KEYWORD") AND len(attributes.KEYWORD)>
		AND(				(
					SERVICE.SERVICE_DETAIL LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.KEYWORD#%">
					OR
					SERVICE.SERVICE_HEAD LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.KEYWORD#%">
									)
		)
		</cfif>      
         AND SERVICE.SERVICE_ACTIVE=1   
	ORDER BY
		SERVICE.SERVICE_ID
</cfquery>

