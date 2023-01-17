<cfquery name="INS_SER" datasource="#dsn3#">
	UPDATE 
    	SETUP_SERVICE_ADD_OPTIONS
    SET
        SERVICE_ADD_OPTION_NAME = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.add_option_name#">,
        DETAIL = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.add_option_detail#">,
        UPDATE_IP = <cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.remote_addr#">,
        UPDATE_DATE = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">,
        UPDATE_EMP = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#">
	WHERE 	
    	SERVICE_ADD_OPTION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.service_option_id#">
</cfquery>
<cflocation addtoken="no" url="#request.self#?fuseaction=settings.upd_service_add_option&service_option_id=#attributes.service_option_id#">
