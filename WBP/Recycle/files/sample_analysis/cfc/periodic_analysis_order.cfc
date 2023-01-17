<cfcomponent extends="cfc.queryJSONConverter">

	<cfset dsn = application.systemParam.systemParam().dsn />
	<cfset dsn2 = "#dsn#_#session.ep.period_year#_#session.ep.company_id#" />
	<cfset dsn3 = "#dsn#_#session.ep.company_id#" />
	<cfset dsn1 = "#dsn#_product" />

	<cfsetting requesttimeout="2000">

	<cffunction name="getPeriodicAnalysisOrder" access="public" returntype="any">
		<cfargument name = "sample_points_id" default="" required="false">

		<cfquery name="getPeriodicAnalysisOrder" datasource="#DSN#">
			SELECT * FROM SAMPLE_POINTS AS SP 
			JOIN SAMPLING_POINTS AS SGP ON SP.SAMPLING_ID = SGP.SAMPLING_ID AND SGP.OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#">
			WHERE
				SP.OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#">
				<cfif isDefined("arguments.sample_points_id") and len(arguments.sample_points_id)>
					AND SP.SAMPLE_POINTS_ID = <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#arguments.sample_points_id#">
				</cfif>
		</cfquery>
		<cfreturn getPeriodicAnalysisOrder />
	</cffunction>
	<cffunction name="addPeriodicAnalysisOrder" access="public" returntype="any">
		<cfargument name="sampling_id" required="false">
		<cfargument name="sample_points_date_entry" required="false">
		<cfargument name="period" required="false">
		<cfargument name="sample_points_reason" required="false">

		<cfquery name="addPeriodicAnalysisOrder" datasource="#dsn#" result="result">
			INSERT INTO
				SAMPLE_POINTS
			(
				SAMPLING_ID,
				SAMPLE_POINTS_DATE_ENTRY,
				PERIOD,
				SAMPLE_POINTS_REASON,
				RECORD_EMP,
				RECORD_DATE,
				RECORD_IP,
				OUR_COMPANY_ID
			)
			VALUES
			(
				<cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.sampling_id#">,
				<cfqueryparam cfsqltype="cf_sql_timestamp" value="#arguments.sample_points_date_entry#">,
				<cfqueryparam cfsqltype="cf_sql_nvarchar" value="#arguments.period#">,
				<cfqueryparam cfsqltype="cf_sql_nvarchar" value="#arguments.sample_points_reason#">,
				#session.ep.userid#,
				#now()#,
				<cfqueryparam cfsqltype="cf_sql_nvarchar" value="#cgi.REMOTE_ADDR#">,
				<cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#">
			)
		</cfquery>
		<cfreturn result>
	</cffunction>
	<cffunction name="updPeriodicAnalysisOrder" access="public" returntype="any">
		<cfargument name="sample_points_id" default="" required="true">
		<cfargument name="sampling_id" default="" required="false">
		<cfargument name="sample_points_date_entry" default="" required="false">
		<cfargument name="period" default="" required="false">
		<cfargument name="sample_points_reason" default="" required="false">

		<cfquery name="updPeriodicAnalysisOrder" datasource="#dsn#">
			UPDATE SAMPLE_POINTS
			SET
				SAMPLING_ID = <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#arguments.sampling_id#">,
				SAMPLE_POINTS_DATE_ENTRY = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#arguments.sample_points_date_entry#">,
				PERIOD = <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#arguments.period#">,
				SAMPLE_POINTS_REASON = <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#arguments.sample_points_reason#">,
				UPDATE_EMP = #session.ep.userid#,
				UPDATE_DATE = #now()#,
				UPDATE_IP = <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#cgi.REMOTE_ADDR#">
			WHERE 
				SAMPLE_POINTS_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.sample_points_id#">
		</cfquery>
	</cffunction>
</cfcomponent>