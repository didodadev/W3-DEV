<cfcomponent>
	<cfset dsn = application.systemParam.systemParam().dsn>
	<cfset dsn2="#dsn#_#session.ep.period_year#_#session.ep.company_id#">
	<cffunction name="getComponentFunction">
		<cfargument name="is_active">
		<cfargument name="income_expense">
			<cfquery name="GET_BUDGET_ITEM" datasource="#dsn2#">
				SELECT 
					EXPENSE_ITEM_ID, 
					EXPENSE_ITEM_NAME 
				FROM 
					EXPENSE_ITEMS  
				WHERE 
					1=1
					<cfif arguments.is_active eq 1>
						AND IS_ACTIVE=1	
					</cfif>
					<cfif arguments.income_expense eq 1>
						AND INCOME_EXPENSE=1
					<cfelseif arguments.income_expense eq 0>
						AND IS_EXPENSE=1
					</cfif>
				ORDER BY 
					EXPENSE_ITEM_NAME
		   </cfquery>
		<cfreturn GET_BUDGET_ITEM>
    </cffunction>
</cfcomponent>

