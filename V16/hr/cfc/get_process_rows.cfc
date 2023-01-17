<cfcomponent>
	<cffunction name="get_process_type_rows" access="public" returntype="query">
		<cfargument name="faction" type="string">
		<cfargument name="our_company_id" default="#session.ep.company_id#">
		<cfargument name="is_active" default="1">
        <cfquery name="get_rows" datasource="#this.dsn#">
			SELECT 
				PTR.PROCESS_ROW_ID,
				PTR.STAGE
			FROM
				PROCESS_TYPE_ROWS PTR
				INNER JOIN PROCESS_TYPE PT ON PT.PROCESS_ID = PTR.PROCESS_ID
				INNER JOIN PROCESS_TYPE_OUR_COMPANY PTO ON PT.PROCESS_ID = PTO.PROCESS_ID
			WHERE
				PT.FACTION LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#arguments.faction#%">
				AND PTO.OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.our_company_id#">
				AND PT.IS_ACTIVE = <cfqueryparam cfsqltype="cf_sql_bit" value="#arguments.is_active#">
		</cfquery>
		<cfreturn get_rows>
	</cffunction>
</cfcomponent>
