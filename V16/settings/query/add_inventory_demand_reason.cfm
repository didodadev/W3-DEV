<cfquery name="upd_inventory_cat" datasource="#dsn#">
	INSERT INTO 
		SETUP_INVENTORY_DEMAND_REASON 
	(
		REASON,
        ACTIVE,
		RECORD_EMP,
		RECORD_DATE,
		RECORD_IP
	)
	VALUES 
	(
		<cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.demand_reason#">,
        <cfif isdefined("attributes.active")>1<cfelse>0</cfif>,
		#SESSION.EP.USERID#,
		#NOW()#,
		'#CGI.REMOTE_ADDR#'
	)
</cfquery>
<cflocation url="#request.self#?fuseaction=settings.form_add_inventory_demand_reason" addtoken="no">
