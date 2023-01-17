<cfset dsn = application.systemParam.systemParam().dsn>
<cffunction name="get_training_content_fnc" returntype="query">
	<cfargument name="class_id" default="">
    <cfquery name="get_training_content" datasource="#this.DSN#">
	SELECT 
		CR.CONTENT_ID,
		CR.RECORD_EMP,
		C.RECORD_DATE,
		C.CONT_HEAD, 
		C.CONTENT_PROPERTY_ID,
		C.UPDATE_MEMBER AS UPDATE_EMP,
		C.STAGE_ID,
		C.WRITE_VERSION,
		C.CONT_SUMMARY,
		C.UPDATE_DATE
	FROM 
		CONTENT_RELATION CR, 
		CONTENT C
	WHERE 
		CR.CONTENT_ID = C.CONTENT_ID AND
		CR.ACTION_TYPE = 'CLASS_ID'
		<cfif isdefined("arguments.class_id") and len (arguments.class_id)>
		AND CR.ACTION_TYPE_ID  = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.class_id#">
		</cfif>
    </cfquery>
    <cfreturn get_training_content>
</cffunction>
<cffunction name="get_class_fnc" returntype="query">
	<cfargument name="class_id" default="">
    <cfquery name="GET_CLASS" datasource="#dsn#">
        SELECT 
			CLASS_ID,
			CLASS_NAME,
			FINISH_DATE,
			START_DATE,
			TRAINING_SEC_ID,
			ONLINE,
			CLASS_TARGET,
			VIEW_TO_ALL,
			CLASS_OBJECTIVE
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
