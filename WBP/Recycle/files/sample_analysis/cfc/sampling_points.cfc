<cfcomponent extends="cfc.queryJSONConverter">

	<cfset dsn = application.systemParam.systemParam().dsn />
	<cfset dsn2 = "#dsn#_#session.ep.period_year#_#session.ep.company_id#" />
	<cfset dsn3 = "#dsn#_#session.ep.company_id#" />
	<cfset dsn1 = "#dsn#_product" />

	<cfsetting requesttimeout="2000">

	<cffunction name="getSamplingPoints" access="public" returntype="any">
		<cfargument name = "sampling_id" default="" required="false">

		<cfquery name="getSamplingPoints" datasource="#DSN#">
			SELECT * FROM SAMPLING_POINTS
			WHERE 
				1 = 1 AND OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#">
				<cfif isDefined("arguments.sampling_id") and len(arguments.sampling_id)>
					AND SAMPLING_ID = <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#arguments.sampling_id#">
				</cfif>
		</cfquery>
		<cfreturn getSamplingPoints />
	</cffunction>
	<cffunction name="addSamplingPoints" access="public" returntype="any">
		<cfargument name="sampling_points_name" required="false">

		<cfquery name="addSamplingPoints" datasource="#dsn#" result="result">
			INSERT INTO
				SAMPLING_POINTS
			(
				SAMPLING_POINTS_NAME,
				RECORD_EMP,
				RECORD_DATE,
				RECORD_IP,
				OUR_COMPANY_ID
			)
			VALUES
			(
				<cfqueryparam cfsqltype="cf_sql_nvarchar" value="#arguments.sampling_points_name#">,
				#session.ep.userid#,
				#now()#,
				<cfqueryparam cfsqltype="cf_sql_nvarchar" value="#cgi.REMOTE_ADDR#">,
				<cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#">
			)
		</cfquery>
		<cfreturn result>
	</cffunction>
	<cffunction name="updSamplingPoints" access="public" returntype="any">
		<cfargument name="sampling_id" default="" required="true">
		<cfargument name="sampling_points_name" default="" required="false">

		<cfquery name="updSamplingPoints" datasource="#dsn#">
			UPDATE SAMPLING_POINTS
			SET
				SAMPLING_POINTS_NAME = <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#arguments.sampling_points_name#">,
				UPDATE_EMP = #session.ep.userid#,
				UPDATE_DATE = #now()#,
				UPDATE_IP = <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#cgi.REMOTE_ADDR#">
			WHERE 
				SAMPLING_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.sampling_id#">
		</cfquery>
	</cffunction>
</cfcomponent>