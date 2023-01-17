<cffunction name="get_training_sco_fnc" returntype="query">
	<cfargument name="class_id" default="">
    <cfquery name="get_sco" datasource="#this.DSN#">
        SELECT 
			SCO_ID,
			CLASS_ID,
			VERSION,
			NAME
        FROM 
			TRAINING_CLASS_SCO
        WHERE 
			SCO_ID IS NOT NULL
			<cfif isdefined("arguments.class_id") and len (arguments.class_id)>
			AND CLASS_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.class_id#">
			</cfif>
    </cfquery>
    <cfreturn get_sco>
</cffunction>
