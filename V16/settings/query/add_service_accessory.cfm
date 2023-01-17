<cfquery name="INS_SERVICE_ACCESSORY" datasource="#DSN3#">
	INSERT INTO 
		SERVICE_ACCESSORY
		(
			ACCESSORY,
			RECORD_DATE,
			RECORD_EMP,
			RECORD_IP
		)
	VALUES
		(
			<cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.accessory_name#">,
			<cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">,
			<cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#">,
			<cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.remote_addr#">
		)
	SELECT @@IDENTITY AS MAX_ACCESSORY_ID
</cfquery>
<cflocation url="#request.self#?fuseaction=settings.form_upd_service_accessory&acc_id=#ins_service_accessory.max_accessory_id#" addtoken="no">
