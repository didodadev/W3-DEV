<cfquery name="INS_SER" datasource="#dsn3#">
	INSERT INTO 
    	SETUP_SERVICE_ADD_OPTIONS
      	(
        	SERVICE_ADD_OPTION_NAME,
            DETAIL,
            RECORD_IP,
            RECORD_DATE,
            RECORD_EMP
        )
		VALUES
        (
        	<cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.add_option_name#">,
            <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.add_option_detail#">,
            <cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.remote_addr#">,
            <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">,
			<cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#">
        )      
       SELECT @@IDENTITY AS MAX_SERVICE_ADD_OPTION_ID
</cfquery>
<cflocation addtoken="no" url="#request.self#?fuseaction=settings.upd_service_add_option&service_option_id=#ins_ser.MAX_SERVICE_ADD_OPTION_ID#">
