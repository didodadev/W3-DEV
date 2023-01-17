<cfquery name="GET_PROCESS_CAT" datasource="#DSN3#">
	SELECT 
		<cfif isDefined("default_process_type") and len(default_process_type)>
			MAX(PROCESS_CAT_ID) PROCESS_CAT_ID
		<cfelse>
			PROCESS_TYPE,
			IS_STOCK_ACTION,
			IS_ACCOUNT,
			IS_ACCOUNT_GROUP,
			ACTION_FILE_NAME,
			ACTION_FILE_FROM_TEMPLATE,
			ISNULL(IS_DEPT_BASED_ACC,0) IS_DEPT_BASED_ACC
		</cfif>
	 FROM 
	 	SETUP_PROCESS_CAT 
	WHERE
		<cfif isDefined("default_process_type") and len(default_process_type)>
			PROCESS_TYPE = <cfqueryparam cfsqltype="cf_sql_integer" value="#default_process_type#">
		<cfelse>
			PROCESS_CAT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.process_cat#">
		</cfif>
</cfquery>
<cfif not (isDefined("default_process_type") and len(default_process_type))><cfset is_dept_based_acc = get_process_cat.is_dept_based_acc></cfif>

