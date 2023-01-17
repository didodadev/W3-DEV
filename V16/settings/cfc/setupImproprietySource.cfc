<!--- Uygunsuzluk Kaynagı --->
<cfcomponent>
 	<cffunction name="addImproprietySource" access="public" returntype="any">
		<cfargument name="is_active" type="numeric" required="yes" default="1">
		<cfargument name="is_default" type="numeric" required="yes" default="1">
		<cfargument name="imp_source_name" type="string" required="yes">
		<cfargument name="description" type="string" required="no">

		<cfquery name="add_Impropriety_Source" datasource="#dsn3#">
			INSERT INTO
				SETUP_IMPROPRIETY_SOURCE
			(
				IS_ACTIVE,
				IS_DEFAULT,
				IMP_SOURCE_NAME,
				IMP_SOURCE_DETAIL,
				RECORD_EMP,
				RECORD_DATE,
				RECORD_IP
			)
			VALUES
			(
				<cfqueryparam cfsqltype="cf_sql_bigint" value="#arguments.is_active#">,
				<cfqueryparam cfsqltype="cf_sql_bigint" value="#arguments.is_default#">,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.imp_source_name#">,
				<cfif Len(arguments.description)><cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.description#"><cfelse>NULL</cfif>,
				<cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#">,
				<cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.remote_addr#">
			)
		</cfquery>
	</cffunction>

	<cffunction name="updImproprietySource" access="public" returntype="any">
		<cfargument name="imp_source_id" type="numeric" required="yes">
		<cfargument name="is_active" type="numeric" required="yes" default="1">
		<cfargument name="imp_source_name" type="string" required="yes">
		<cfargument name="description" type="string" required="no">
		<cfargument name="is_default" type="any" required="no">
		
		<cfquery name="upd_Inspection_Level" datasource="#dsn3#">
			UPDATE 
				SETUP_IMPROPRIETY_SOURCE
			SET 
				IS_ACTIVE = <cfqueryparam cfsqltype="cf_sql_bigint" value="#arguments.is_active#">,
				IMP_SOURCE_NAME = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.imp_source_name#">,
				IMP_SOURCE_DETAIL = <cfif Len(arguments.description)><cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.description#"><cfelse>NULL</cfif>,
				IS_DEFAULT = <cfqueryparam cfsqltype="cf_sql_bigint" value="#arguments.is_default#">,
				UPDATE_EMP = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#">,
				UPDATE_DATE = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">,
				UPDATE_IP = <cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.remote_addr#">
			WHERE 
				IMP_SOURCE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.imp_source_id#">
		</cfquery>
		<cfreturn true>
	</cffunction> 
	
	<cffunction name="getImproprietySource" access="public" returntype="query">
		<cfargument name="keyword" required="no">
		<cfargument name="imp_source_id" type="numeric" required="no">
		<cfquery name="get_Impropriety_Source" datasource="#dsn3#">
			SELECT 
				IS_ACTIVE,
				IS_DEFAULT,
				IMP_SOURCE_ID,
				IMP_SOURCE_NAME,
				IMP_SOURCE_DETAIL,
				RECORD_EMP,
				RECORD_DATE,
				RECORD_IP
			FROM 
				SETUP_IMPROPRIETY_SOURCE
			WHERE
				IMP_SOURCE_ID IS NOT NULL 
				<cfif isDefined("arguments.imp_source_id") and Len(arguments.imp_source_id)>
					AND IMP_SOURCE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.imp_source_id#">
				</cfif>
				<cfif isDefined("arguments.keyword") and Len(arguments.keyword)>
					AND	(
							IMP_SOURCE_NAME LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#arguments.keyword#%">
						)
				</cfif>
			ORDER BY 
				IMP_SOURCE_NAME
		</cfquery>
		<cfreturn get_Impropriety_Source>
	</cffunction>
</cfcomponent>
