<cfcomponent>
	<cfset dsn = application.systemParam.systemParam().dsn>
	<cffunction name="addInspectionType" access="public" returntype="any">
		<cfargument name="inspection_type" type="string" required="no">
		<cfquery name="INSERT_INSPECTION_TYPE" datasource="#DSN#"> 
			INSERT INTO 
				SETUP_INSPECTION_TYPES
			(
				INSPECTION_TYPE,
				RECORD_IP,
				RECORD_DATE,
				RECORD_EMP
			) 
			VALUES 
			(
				<cfif len(arguments.inspection_type)><cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.inspection_type#"><cfelse>NULL</cfif>,
				'#cgi.remote_addr#',
				#now()#,
				#session.ep.userid#
			)
		</cfquery>
		
	</cffunction>

	<cffunction name="updInspectionType" access="public" returntype="any">
		<cfargument name="inspection_type_id" type="numeric" required="yes">
		<cfargument name="inspection_type" type="string" required="no" default="">
		<cfquery name="UPDATE_INSPECTION_TYPE" datasource="#DSN#">
			UPDATE 
				SETUP_INSPECTION_TYPES
			SET 
				INSPECTION_TYPE = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.inspection_type#">,
				UPDATE_IP = <cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.remote_addr#">,
				UPDATE_DATE = #now()#,
				UPDATE_EMP = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#"> 
			WHERE 
				INSPECTION_TYPE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.inspection_type_id#">
		</cfquery>
		<cfreturn true>
	</cffunction>
	
	<cffunction name="getInspectionTypes" access="public" returntype="query">
		<cfargument name="inspection_type_id" type="numeric" required="no" default="0">
		<cfargument name="sortdir" type="string" required="no" default="ASC">
		<cfargument name="sortfield" type="string" required="no" default="INSPECTION_TYPE">
		<cfquery name="get_inspection_type_list" datasource="#dsn#">
			SELECT 
				*
			FROM 
				SETUP_INSPECTION_TYPES
			WHERE
				1 = 1
				<cfif arguments.inspection_type_id gt 0>
					AND INSPECTION_TYPE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.inspection_type_id#">
				</cfif>
			ORDER BY 
				#arguments.sortfield# #arguments.sortdir# 
		</cfquery>
		<cfreturn get_inspection_type_list>
	</cffunction> 
</cfcomponent>

