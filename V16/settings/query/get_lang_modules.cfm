<cfquery name="GET_MODULES" datasource="#DSN#">
	SELECT
		<cfif isdefined("attributes.language") and attributes.language neq "tr">
			MODULE_NAME AS MODULE_NAME_,
		<cfelse>
			MODULE_NAME_TR AS MODULE_NAME_,
		</cfif>
		MODULE_SHORT_NAME
	 FROM	
		MODULES
	WHERE 
		<cfif isdefined("attributes.language") and attributes.language neq "tr">
			MODULE_NAME IS NOT NULL AND 
		<cfelse>
			MODULE_NAME_TR IS NOT NULL AND
		</cfif>
		MODULE_SHORT_NAME IS NOT NULL
	ORDER BY
		MODULE_NAME_TR 
</cfquery>
