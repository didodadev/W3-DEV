<cfif not isDefined("new_dsn2")><cfset new_dsn2 = dsn2></cfif>
<cfif not isdefined("new_dsn3_group_alias")><cfset new_dsn3_group_alias = dsn3_alias></cfif>
<cfquery name="GET_PROCESS_TYPE" datasource="#new_dsn2#">
	SELECT 
		PROCESS_TYPE,
		PROCESS_CAT_ID,
		IS_CARI,
		IS_ACCOUNT,
		IS_STOCK_ACTION,
		IS_ACCOUNT_GROUP,
		IS_PROJECT_BASED_ACC,
		IS_COST,
		ACTION_FILE_NAME,
		ACTION_FILE_SERVER_ID,
		ACTION_FILE_FROM_TEMPLATE,
		ISNULL(IS_ADD_INVENTORY,0) IS_ADD_INVENTORY,
		ISNULL(IS_DEPT_BASED_ACC,0) IS_DEPT_BASED_ACC
	 FROM 
	 	#new_dsn3_group_alias#.SETUP_PROCESS_CAT 
	WHERE 
		PROCESS_CAT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.process_cat#">
</cfquery>
<cfscript>
	is_dept_based_acc = GET_PROCESS_TYPE.IS_DEPT_BASED_ACC;
</cfscript>
