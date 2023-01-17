<cfquery name="GET_MAX_ID" datasource="#DSN3#">
	SELECT MAX(SERVICECAT_ID) AS MAX_ID FROM SERVICE_APPCAT
</cfquery>
<cfif (get_max_id.recordcount) and len(get_max_id.MAX_ID)>
	<cfset max_id = get_max_id.MAX_ID + 1>	
<cfelse>
	<cfset max_id = 1>
</cfif>
<cfquery name="INSSERVICECAT" datasource="#DSN3#">
	INSERT INTO 
		SERVICE_APPCAT
    (
        IS_INTERNET,
        SERVICECAT,
        RECORD_IP,
        RECORD_DATE,
        RECORD_EMP
    ) 
	VALUES 
    (
        <cfif isdefined("attributes.is_internet")>1<cfelse>0</cfif>,
        <cfqueryparam cfsqltype="cf_sql_varchar" value="#SERVICECAT#">,
        <cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.remote_addr#">,
        #now()#,
        #session.ep.userid#
    )
</cfquery>
<cflocation url="#request.self#?fuseaction=settings.form_add_service_app_cat" addtoken="no">
