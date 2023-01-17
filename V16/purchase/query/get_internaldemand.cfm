<cfquery name="GET_INTERNALDEMAND" datasource="#DSN3#">
	SELECT 
		INTERNAL_ID,
        SHIP_METHOD,
        REF_NO,
        DEPARTMENT_IN,
        LOCATION_IN,
        TARGET_DATE
	FROM 
		INTERNALDEMAND
	<cfif isdefined("attributes.id") and len(attributes.id)>
		WHERE
			INTERNAL_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.id#">
	</cfif>
</cfquery>
