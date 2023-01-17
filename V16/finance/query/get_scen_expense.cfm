<cfquery name="GET_SCEN_EXPENSE" datasource="#DSN3#">
	SELECT
		S.*,
		SM.RATE1,
		SM.RATE2
	FROM
		SCEN_EXPENSE_PERIOD S,
		#dsn_alias#.SETUP_MONEY SM
	WHERE
		S.PERIOD_CURRENCY = SM.MONEY AND
		SM.PERIOD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.period_id#">
		<cfif isDefined("attributes.keyword") and len(attributes.keyword)>AND S.PERIOD_DETAIL LIKE '%#attributes.keyword#%'</cfif>
		 <cfif isDefined("attributes.period_type") and len(attributes.period_type)>AND S.PERIOD_TYPE = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.period_type#"></cfif> 
		<cfif isDefined("attributes.is_type") and len(attributes.is_type)>AND S.TYPE = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.is_type#"></cfif>
		<cfif len(attributes.is_active) and attributes.is_active eq 2>AND SCEN_EXPENSE_STATUS = 1
		<cfelseif len(attributes.is_active) and attributes.is_active eq 3>AND SCEN_EXPENSE_STATUS = 0</cfif>
        <cfif len(attributes.start_date)>AND S.START_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.start_date#"></cfif>
        <cfif len(attributes.finish_date)>AND S.START_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.finish_date#"></cfif>
	ORDER BY 
		S.START_DATE
</cfquery>
