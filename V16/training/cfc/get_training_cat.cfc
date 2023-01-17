<cffunction name="get_training_cat_fnc" returntype="query">
	<cfargument name="training_cat_id" default="">
    <cfquery name="get_training_cat" datasource="#this.DSN#">
		SELECT 
			TRAINING_CAT_ID,
			TRAINING_CAT 
		FROM 
			TRAINING_CAT 
		WHERE
			TRAINING_CAT_ID IS NOT NULL
			<cfif isdefined("arguments.training_cat_id") and len (arguments.training_cat_id)>
			AND TRAINING_CAT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.training_cat_id#">
			</cfif>
		ORDER BY 
			TRAINING_CAT
    </cfquery>
    <cfreturn get_training_cat>
</cffunction>
