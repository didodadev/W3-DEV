<cffunction name="get_training_sec_fnc" returntype="query">
	<cfargument name="training_sec_id" default="">
    <cfquery name="get_training_sec" datasource="#this.DSN#">
		SELECT
			TC.TRAINING_CAT_ID,
			TS.TRAINING_SEC_ID,
			TS.SECTION_NAME,
			TC.TRAINING_CAT
		FROM
			TRAINING_SEC TS,
			TRAINING_CAT TC
		WHERE
			TS.TRAINING_CAT_ID = TC.TRAINING_CAT_ID
			<cfif isdefined("arguments.training_sec_id") and len (arguments.training_sec_id)>
			AND TS.TRAINING_SEC_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.training_sec_id#">
			</cfif>
		ORDER BY
			TS.SECTION_NAME
    </cfquery>
    <cfreturn get_training_sec>
</cffunction>
