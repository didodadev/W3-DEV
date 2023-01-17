<cfquery name="GET_MAX_ID" datasource="#DSN3#">
	SELECT MAX(SERVICE_SUBSTATUS_ID) AS MAX_ID FROM SERVICE_SUBSTATUS
</cfquery>
<cfquery name="INSSERVICESUBSTATUS" datasource="#DSN3#">
	INSERT INTO 
		SERVICE_SUBSTATUS
    (
        SERVICE_SUBSTATUS_ID,
        SERVICE_SUBSTATUS,
        RECORD_IP,
        RECORD_DATE,
        RECORD_EMP
    ) 
	VALUES 
    (
        <cfif (get_max_id.recordcount) and len(get_max_id.MAX_ID)>#get_max_id.MAX_ID+1#<cfelse>1</cfif>,
        <cfqueryparam cfsqltype="cf_sql_varchar" value="#SERVICE_SUBSTATUS#">,
       	<cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.remote_addr#">,
        #now()#,
        #session.ep.userid#
    )
</cfquery>
<cflocation url="#request.self#?fuseaction=settings.form_add_service_substatus" addtoken="no">
