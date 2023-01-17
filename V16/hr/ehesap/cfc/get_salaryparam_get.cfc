<cfcomponent>
	<cffunction name="get_salary_get" access="public" returntype="query">
		<cfargument name="in_out_id">
		<cfargument name="term">
		<cfargument name="sal_mon_">
		<cfquery name="get_salaryparam" datasource="#this.dsn#">
           	SELECT 
                TERM,
                COMMENT_GET,
                AMOUNT_GET,
                START_SAL_MON,
                END_SAL_MON,
                MONEY
            FROM 
                SALARYPARAM_GET 
            WHERE 
                IN_OUT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.in_out_id#"> AND
                TERM >= <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.term#"> AND
                (
                	(TERM = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.term#"> AND END_SAL_MON > <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.sal_mon_#">) OR 
                	TERM > <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.term#">
                )
            GROUP BY
                TERM,
                COMMENT_GET,
                AMOUNT_GET,
                START_SAL_MON,
                END_SAL_MON,
                MONEY
            ORDER BY 
                TERM,
                START_SAL_MON
		</cfquery>
		<cfreturn get_salaryparam>
	</cffunction>
</cfcomponent>
