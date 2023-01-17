<cfcomponent>
	<cfset dsn = application.systemParam.systemParam().dsn>
	<cfset dsn2="#dsn#_#session.ep.period_year#_#session.ep.company_id#">
    <cffunction name="getComponentFunction">
	<cfargument name="is_hr">
	<cfargument name="is_training">
            <cfquery name="GET_BUDGET_CAT" datasource="#dsn2#">
               	SELECT 
					EXPENSE_CAT_ID,
					EXPENSE_CAT_NAME
				FROM 
					EXPENSE_CATEGORY
				WHERE
					1=1
					<cfif arguments.is_hr eq 1>
						AND EXPENCE_IS_HR = 1
					</cfif>
					<cfif arguments.is_training eq 1>
						AND EXPENCE_IS_TRAINING = 1
					</cfif>
				ORDER BY
					EXPENSE_CAT_NAME
            </cfquery>
        <cfreturn GET_BUDGET_CAT>
    </cffunction>
</cfcomponent>

