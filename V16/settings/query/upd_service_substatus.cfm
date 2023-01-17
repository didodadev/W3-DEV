<cfquery name="UPDSERVICESUBSTATUS" datasource="#DSN3#">
	UPDATE 
		SERVICE_SUBSTATUS 
	SET 
		SERVICE_SUBSTATUS = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.service_substatus#">,
		UPDATE_IP = <cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.remote_addr#">,
		UPDATE_DATE = #now()#,
		UPDATE_EMP = #session.ep.userid#
	WHERE 
		SERVICE_SUBSTATUS_ID = #service_substatus_id#
</cfquery>
<cflocation url="#request.self#?fuseaction=settings.form_add_service_substatus" addtoken="no">
