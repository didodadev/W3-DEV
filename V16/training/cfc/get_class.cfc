<cfcomponent>
<cffunction name="get_class_fnc" returntype="query">
	<cfargument name="class_id" default="">
    <cfquery name="GET_CLASS" datasource="#this.dsn#">
        SELECT 
			CLASS_ID,
			CLASS_NAME,
			FINISH_DATE,
			START_DATE,
			TRAINING_SEC_ID,
			ONLINE,
			CLASS_TARGET,
			VIEW_TO_ALL,
            TRAINING_LINK
        FROM 
			TRAINING_CLASS
        WHERE 
			CLASS_ID IS NOT NULL
			<cfif isdefined("arguments.class_id") and len (arguments.class_id)>
				AND CLASS_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.class_id#">
			</cfif>
    </cfquery>
    <cfreturn GET_CLASS>
</cffunction>
</cfcomponent>
