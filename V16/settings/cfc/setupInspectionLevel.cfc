<!--- Muayene Seviyeleri --->
<cfcomponent>
	<cfset dsn = application.systemParam.systemParam().dsn>
	<cffunction name="addInspectionLevel" access="public" returntype="any">
		<cfargument name="is_active" type="numeric" required="yes" default="1">
		<cfargument name="level_code" type="string" required="yes">
		<cfargument name="level_name" type="string" required="yes">
		<cfargument name="description" type="string" required="no">
		<cfargument name="is_default" type="any" required="no" default="0">

		<cfquery name="add_Inspection_Level" datasource="#dsn3#">
			INSERT INTO
				SETUP_INSPECTION_LEVEL
			(
				IS_ACTIVE,
				INSPECTION_LEVEL_CODE,
				INSPECTION_LEVEL_NAME,
				DESCRIPTION,
				IS_DEFAULT,
				RECORD_EMP,
				RECORD_DATE,
				RECORD_IP
			)
			VALUES
			(
				<cfqueryparam cfsqltype="cf_sql_bigint" value="#arguments.is_active#">,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.level_code#">,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.level_name#">,
				<cfif Len(arguments.description)><cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.description#"><cfelse>NULL</cfif>,
				<cfqueryparam cfsqltype="cf_sql_bigint" value="#arguments.is_default#">,
				<cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#">,
				<cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.remote_addr#">
			)
		</cfquery>
	</cffunction>

	<cffunction name="updInspectionLevel" access="public" returntype="any">
		<cfargument name="level_id" type="numeric" required="yes">
		<cfargument name="is_active" type="numeric" required="yes" default="1">
		<cfargument name="level_code" type="string" required="yes">
		<cfargument name="level_name" type="string" required="yes">
		<cfargument name="description" type="string" required="no">
		<cfargument name="is_default" type="any" required="no">
		
		<cfquery name="upd_Inspection_Level" datasource="#dsn3#">
			UPDATE 
				SETUP_INSPECTION_LEVEL
			SET 
				IS_ACTIVE = <cfqueryparam cfsqltype="cf_sql_bigint" value="#arguments.is_active#">,
				INSPECTION_LEVEL_CODE = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.level_code#">,
				INSPECTION_LEVEL_NAME = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.level_name#">,
				DESCRIPTION = <cfif Len(arguments.description)><cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.description#"><cfelse>NULL</cfif>,
				IS_DEFAULT = <cfqueryparam cfsqltype="cf_sql_bigint" value="#arguments.is_default#">,
				UPDATE_EMP = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#">,
				UPDATE_DATE = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">,
				UPDATE_IP = <cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.remote_addr#">
			WHERE 
				INSPECTION_LEVEL_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.level_id#">
		</cfquery>
		<cfreturn true>
	</cffunction>
	
	<cffunction name="getInspectionLevel" access="public" returntype="query">
		<cfargument name="level_id" type="numeric" required="no">
		<cfargument name="keyword" type="string" required="no">
		<cfargument name="is_active" required="no">

		<cfquery name="get_Inspection_Level" datasource="#dsn3#">
			SELECT 
				IS_ACTIVE,
				INSPECTION_LEVEL_ID,
				INSPECTION_LEVEL_CODE,
				#dsn#.Get_Dynamic_Language(INSPECTION_LEVEL_ID,'#session.ep.language#','SETUP_INSPECTION_LEVEL','INSPECTION_LEVEL_NAME',NULL,NULL,INSPECTION_LEVEL_NAME) AS INSPECTION_LEVEL_NAME,
				DESCRIPTION,
				IS_DEFAULT,
				RECORD_EMP,
				RECORD_DATE,
				RECORD_IP,
				UPDATE_EMP,
				UPDATE_DATE,
				UPDATE_IP
			FROM 
				SETUP_INSPECTION_LEVEL
			WHERE
				INSPECTION_LEVEL_ID IS NOT NULL
				<cfif isDefined("arguments.is_active") and Len(arguments.is_active)>
					AND IS_ACTIVE = <cfqueryparam cfsqltype="cf_sql_bigint" value="#arguments.is_active#">
				</cfif>
				<cfif isDefined("arguments.level_id") and Len(arguments.level_id)>
					AND INSPECTION_LEVEL_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.level_id#">
				</cfif>
				<cfif isDefined("arguments.keyword") and Len(arguments.keyword)>
					AND	(
							INSPECTION_LEVEL_CODE LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.keyword#"> OR
							INSPECTION_LEVEL_NAME LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#arguments.keyword#%">
						)
				</cfif>
			ORDER BY 
				INSPECTION_LEVEL_CODE,
				INSPECTION_LEVEL_NAME
		</cfquery>
		<cfreturn get_Inspection_Level>
	</cffunction>
</cfcomponent>
