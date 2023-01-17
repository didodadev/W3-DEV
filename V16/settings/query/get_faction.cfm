<cfquery name="get_faction" datasource="#dsn#">
	SELECT 
		MODUL,
		MODUL_SHORT_NAME,
		FUSEACTION,
		WRK_OBJECTS_ID,
		BASE
	FROM 
		WRK_OBJECTS 
	WHERE 
		1=1
		<cfif isDefined("attributes.module") AND len(attributes.module)>
			AND MODUL_SHORT_NAME = '#GET_NAME.MODULE_SHORT_NAME#'
		</cfif>
		<cfif isdefined("attributes.keyword") and len(attributes.keyword)>
			AND	FUSEACTION LIKE '%#attributes.keyword#%' 
		</cfif>
	ORDER BY
		MODUL
</cfquery> 
