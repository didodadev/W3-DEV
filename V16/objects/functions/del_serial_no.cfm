<cfsetting enablecfoutputonly="yes"><cfprocessingdirective suppresswhitespace="yes">
<cffunction name="del_serial_no" output="false">
	<cfargument name="process_id" type="numeric" required="true">
	<cfargument name="process_cat" type="numeric" required="true">
	<cfargument name="period_id" type="numeric" required="true">
	<cfargument name="is_dsn3" type="numeric" required="no" default="0">

	<cfif arguments.is_dsn3 eq 0>
		<cfset serial_dsn = '#DSN2#'>
		<cfset dsn_add_ = '#dsn3_alias#'>
	<cfelse>
		<cfset serial_dsn = '#DSN3#'>
		<cfset dsn_add_ = ''>
	</cfif>

	<cfquery name="del_serial_numbers" datasource="#serial_dsn#">
		DELETE FROM 
			<cfif len(dsn_add_)>#dsn_add_#.</cfif>SERVICE_GUARANTY_NEW 
		WHERE
			PROCESS_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.process_id#"> AND
			PROCESS_CAT = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.process_cat#"> AND
			PERIOD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.period_id#">
	</cfquery>
	<!--- BK kaldirdi 6 aya kaldirilmali. 20130529
	<cfquery name="del_serial_numbers_history" datasource="#serial_dsn#">
		DELETE FROM 
			<cfif len(dsn_add_)>#dsn_add_#.</cfif>SERVICE_GUARANTY_NEW_HISTORY 
		WHERE
			PROCESS_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.process_id#"> AND
			PROCESS_CAT = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.process_cat#"> AND
			PERIOD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.period_id#">
	</cfquery> --->
	<cfreturn true>
</cffunction>
</cfprocessingdirective><cfsetting enablecfoutputonly="no">
