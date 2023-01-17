<cf_date tarih='attributes.action_date'>
<cfquery name="add_" datasource="#dsn3#" result="add_r">
	INSERT INTO
		WAREHOUSE_RATES
		(
		COMPANY_ID,
		ACTION_DATE,
		RECORD_EMP,
		RECORD_IP,
		RECORD_DATE,
		BRANCH_ID
		)
		VALUES
		(
		#attributes.company_id#,
		#attributes.action_date#,
		#SESSION.EP.USERID#,
		<cfqueryparam cfsqltype="cf_sql_varchar" value="#CGI.REMOTE_ADDR#">,
		#NOW()#,
		<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.branch_id#">
		)
</cfquery>
<cflocation url="#request.self#?fuseaction=settings.list_warehouse_rates&event=upd&rate_id=#add_r.identitycol#" addtoken="no">