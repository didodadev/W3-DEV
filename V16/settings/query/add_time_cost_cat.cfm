<cfquery name="instimecostcat" datasource="#DSN#">
 	INSERT INTO 
    	TIME_COST_CAT
	(
		TIME_COST_CAT,
		COLOUR,
		RECORD_IP,
		RECORD_DATE,
		RECORD_EMP
	) 
	VALUES 
	(
		<cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.time_cost_cat#">,
		<cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.colour#">,
		<cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.remote_addr#">,
		<cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">,
		<cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#">
	)
</cfquery>
<cflocation url="#request.self#?fuseaction=settings.form_add_time_cost_cat" addtoken="no">
