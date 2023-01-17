<cffunction name="get_training_class_scodata_fnc" returntype="query">
	<cfargument name="class_id" default="">
	<cfargument name="sco_id" default="">
	<cfargument name="user_id" default="">
	<cfargument name="is_completed_status" default="">
    <cfquery name="get_training_class_scodata" datasource="#this.DSN#">
		SELECT 
			SCO.SCO_ID,
			SCO.NAME,
			VAR_VALUE AS COMPLETION_STATUS 
		FROM 
			TRAINING_CLASS_SCO_DATA SCO_DATA,
			TRAINING_CLASS_SCO SCO 
		WHERE 
			SCO.SCO_ID IS NOT NULL AND
			SCO_DATA.SCO_ID = SCO.SCO_ID
			<cfif isdefined("arguments.sco_id") and len (arguments.sco_id)>
			AND SCO.SCO_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.sco_id#">
			</cfif>
			<cfif isdefined("arguments.user_id") and len (arguments.user_id)>
			AND SCO_DATA.USER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.user_id#">
			</cfif>
			<cfif isdefined("arguments.class_id") and len (arguments.class_id)>
			AND SCO.CLASS_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.class_id#">
			</cfif>
			<cfif isdefined("arguments.is_completed_status") and len (arguments.is_completed_status)>
				AND (SCO_DATA.VAR_NAME LIKE 'cmi.completion_status' OR SCO_DATA.VAR_NAME LIKE 'cmi.core.lesson_status')
			</cfif>
    </cfquery>
    <cfreturn get_training_class_scodata>
</cffunction>
