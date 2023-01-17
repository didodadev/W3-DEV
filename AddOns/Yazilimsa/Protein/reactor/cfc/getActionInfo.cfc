<cfcomponent>

    <cfset dsn = application.systemParam.systemParam().dsn>

    <cffunction name="get" access="public" returntype="struct">
        <cfargument name="action_table" required="yes">
        
        <cfset dsn_alias = dsn>
        <cfset dsn1_alias = "#dsn#_product">
        <cfset dsn2_alias = "#dsn#_#session.ep.period_year#_#session.ep.company_id#">
        <cfset dsn3_alias = "#dsn#_#session.ep.company_id#">
        
        <cfset actionInfo = structNew()>

        <cfif arguments.action_table is "OPPORTUNITIES">
			<cfset actionInfo.action_stage_column = "OPP_STAGE">
			<cfset actionInfo.action_db = dsn3_alias>
		<cfelseif arguments.action_table is "INTERNALDEMAND">
			<cfset actionInfo.action_stage_column = "INTERNALDEMAND_STAGE">
			<cfset actionInfo.action_db = dsn3_alias>
		<cfelseif arguments.action_table is "OFFER">
			<cfset actionInfo.action_stage_column = "OFFER_STAGE">
			<cfset actionInfo.action_db = dsn3_alias>
		<cfelseif arguments.action_table is "ORDERS">
			<cfset actionInfo.action_stage_column = "ORDER_STAGE">
			<cfset actionInfo.action_db = dsn3_alias>
		<cfelseif arguments.action_table is "PRODUCTION_ORDERS">
			<cfset actionInfo.action_stage_column = "PROD_ORDER_STAGE">
			<cfset actionInfo.action_db = dsn3_alias>
		<cfelseif arguments.action_table is "PRODUCT_TREE">
			<cfset actionInfo.action_stage_column = "PROCESS_STAGE">
			<cfset actionInfo.action_db = dsn3_alias>
		<cfelseif arguments.action_table is "PRODUCT">
			<cfset actionInfo.action_stage_column = "PRODUCT_STAGE">
			<cfset actionInfo.action_db = dsn1_alias>
		<cfelseif arguments.action_table is "PRODUCTION_ORDER_RESULT">
			<cfset actionInfo.action_stage_column = "PROD_ORD_RESULT_STAGE">
			<cfset actionInfo.action_db = dsn3_alias>
		<cfelseif arguments.action_table is "EVENT">
			<cfset actionInfo.action_stage_column = "EVENT_STAGE">
			<cfset actionInfo.action_db = dsn_alias>
		<cfelseif arguments.action_table is "ASSET_P">
			<cfset actionInfo.action_stage_column = "PROCESS_STAGE">
			<cfset actionInfo.action_db = dsn_alias>
		<cfelseif arguments.action_table is "BUDGET_PLAN">
			<cfset actionInfo.action_stage_column = "PROCESS_STAGE">
			<cfset actionInfo.action_db = dsn_alias>
		<cfelseif arguments.action_table is "CAMPAIGNS">
			<cfset actionInfo.action_stage_column = "PROCESS_STAGE">
			<cfset actionInfo.action_db = dsn3_alias>
		<cfelseif arguments.action_table is "CONTENT">
			<cfset actionInfo.action_stage_column = "PROCESS_STAGE">
			<cfset actionInfo.action_db = dsn_alias>
		<cfelseif arguments.action_table is "COMPANY_CREDIT">
			<cfset actionInfo.action_stage_column = "PROCESS_STAGE">
			<cfset actionInfo.action_db = dsn_alias>
		<cfelseif arguments.action_table is "CORRESPONDENCE">
			<cfset actionInfo.action_stage_column = "COR_STAGE">
			<cfset actionInfo.action_db = dsn_alias>
		<cfelseif arguments.action_table is "CARI_CLOSED">
			<cfset actionInfo.action_stage_column = "PROCESS_STAGE">
			<cfset actionInfo.action_db = dsn2_alias>
		<cfelseif arguments.action_table is "OFFTIME">
			<cfset actionInfo.action_stage_column = "OFFTIME_STAGE">
			<cfset actionInfo.action_db = dsn_alias>
		<cfelseif arguments.action_table is "EMPLOYEES">
			<cfset actionInfo.action_stage_column = "EMPLOYEE_STAGE">
			<cfset actionInfo.action_db = dsn_alias>
		<cfelseif arguments.action_table is "EMPLOYEE_POSITIONS">
			<cfset actionInfo.action_stage_column = "POSITION_STAGE">
			<cfset actionInfo.action_db = dsn_alias>
		<cfelseif arguments.action_table is "PERSONEL_REQUIREMENT_FORM">
			<cfset actionInfo.action_stage_column = "PER_REQ_STAGE">
			<cfset actionInfo.action_db = dsn_alias>
		<cfelseif arguments.action_table is "PERSONEL_ASSIGN_FORM">
			<cfset actionInfo.action_stage_column = "PER_ASSIGN_STAGE">
			<cfset actionInfo.action_db = dsn_alias>
		<cfelseif arguments.action_table is "PERSONEL_ROTATION_FORM">
			<cfset actionInfo.action_stage_column = "FORM_STAGE">
			<cfset actionInfo.action_db = dsn_alias>
		<cfelseif arguments.action_table is "CONSUMER">
			<cfset actionInfo.action_stage_column = "CONSUMER_STAGE">
			<cfset actionInfo.action_db = dsn_alias>
		<cfelseif arguments.action_table is "COMPANY">
			<cfset actionInfo.action_stage_column = "COMPANY_STATE">
			<cfset actionInfo.action_db = dsn_alias>
		<cfelseif arguments.action_table is "EVENT_PLAN_ROW">
			<cfset actionInfo.action_stage_column = "RESULT_PROCESS_STAGE">
			<cfset actionInfo.action_db = dsn_alias>
		<cfelseif arguments.action_table is "PRO_WORKS">
			<cfset actionInfo.action_stage_column = "WORK_CURRENCY_ID">
			<cfset actionInfo.action_db = dsn_alias>
		<cfelseif arguments.action_table is "PRO_PROJECTS">
			<cfset actionInfo.action_stage_column = "PRO_CURRENCY_ID">
			<cfset actionInfo.action_db = dsn_alias>
		<cfelseif arguments.action_table is "G_SERVICE">
			<cfset actionInfo.action_stage_column = "SERVICE_STATUS_ID">
			<cfset actionInfo.action_db = dsn_alias>
		<cfelseif arguments.action_table is "SERVICE">
			<cfset actionInfo.action_stage_column = "SERVICE_STATUS_ID">
			<cfset actionInfo.action_db = dsn3_alias>
		<cfelseif arguments.action_table is "SUBSCRIPTION_CONTRACT">
			<cfset actionInfo.action_stage_column = "SUBSCRIPTION_STAGE">
			<cfset actionInfo.action_db = dsn3_alias>
		<cfelseif arguments.action_table is "SALES_QUOTAS">
			<cfset actionInfo.action_stage_column = "PROCESS_STAGE">
			<cfset actionInfo.action_db = dsn3_alias>
		<cfelseif arguments.action_table is "EXPENSE_ITEM_PLAN_REQUESTS">
			<cfset actionInfo.action_stage_column = "EXPENSE_STAGE">
			<cfset actionInfo.action_db = dsn2_alias>
		<cfelseif arguments.action_table is "EMPLOYEES_OFFTIME_CONTRACT">
			<cfset actionInfo.action_stage_column = "CONTRACT_STAGE">
			<cfset actionInfo.action_db = dsn_alias>
		<cfelseif arguments.action_table is "EMPLOYEES_EXT_WORKTIMES">
			<cfset actionInfo.action_stage_column = "PROCESS_STAGE">
			<cfset actionInfo.action_db = dsn_alias>
		<cfelseif arguments.action_table is "EMPLOYEES_TRAVEL_DEMAND">
			<cfset actionInfo.action_stage_column = "DEMAND_STAGE">
			<cfset actionInfo.action_db = dsn_alias>
		<cfelseif arguments.action_table is "WORKTIME_FLEXIBLE">
			<cfset actionInfo.action_stage_column = "STAGE_ID">
			<cfset actionInfo.action_db = dsn_alias>
		<cfelseif arguments.action_table is "ASSET_P_DEMAND">
			<cfset actionInfo.action_stage_column = "STAGE">
			<cfset actionInfo.action_db = dsn_alias>
		</cfif>
		
		<cfif structCount(actionInfo)>
			<cfif actionInfo.action_db eq dsn_alias><cfset actionInfo.action_db_type = "main">
			<cfelseif actionInfo.action_db eq dsn1_alias><cfset actionInfo.action_db_type = "product">
			<cfelseif actionInfo.action_db eq dsn2_alias><cfset actionInfo.action_db_type = "period">
			<cfelseif actionInfo.action_db eq dsn3_alias><cfset actionInfo.action_db_type = "company">
			</cfif>
		</cfif>

        <cfreturn actionInfo>
    </cffunction>
</cfcomponent>