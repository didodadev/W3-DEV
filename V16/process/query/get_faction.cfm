<cfquery name="get_modules" datasource="#dsn#">
	SELECT 
		MODULE_ID,
		MODULE_SHORT_NAME 
	FROM 
		MODULES 
	ORDER BY 
		MODULE_SHORT_NAME
</cfquery>

<cfquery name="get_faction" datasource="#dsn#">
	SELECT 
		MODUL,
		MODUL_SHORT_NAME,
		FUSEACTION,
		HEAD
	FROM 
		WRK_OBJECTS 
	WHERE
		1=1
	<cfif len(attributes.keyword)>
		<cfloop from="1" to="#listlen(attributes.keyword,'*')#" index="k">
		AND 
		(
			HEAD LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#listgetat(attributes.keyword,k,'*')#%"> OR 
			FUSEACTION LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#listgetat(attributes.keyword,k,'*')#%"> OR 
			FILE_NAME LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#listgetat(attributes.keyword,k,'*')#%"> OR
			(MODUL_SHORT_NAME+'.'+ FUSEACTION) = <cfqueryparam cfsqltype="cf_sql_varchar" value="#listgetat(attributes.keyword,k,'*')#">
		)
		</cfloop>
	</cfif>
	<cfif len(attributes.module)>
		AND
			MODUL_SHORT_NAME = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.module#">
	</cfif>
	ORDER BY 
		MODUL
</cfquery>
