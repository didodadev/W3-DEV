<!--- <cfquery name="get_max_id" datasource="#DSN#">
	SELECT MAX(SERVICECAT_ID) AS MAX_ID FROM G_SERVICE_APPCAT
</cfquery>
<cfif (get_max_id.recordcount) and len(get_max_id.max_id)>
	<cfset max_id = get_max_id.max_id + 1>	
<cfelse>
	<cfset max_id = 1>
</cfif> --->
<cfquery name="add_service_appcat" datasource="#DSN#">
	INSERT INTO 
		G_SERVICE_APPCAT
    (
        IS_INTERNET,
        SERVICECAT,
        RECORD_IP,
        RECORD_DATE,
        RECORD_EMP,
        IS_STATUS,
        OUR_COMPANY_ID
    ) 
    VALUES 
    (
        <cfif isdefined("attributes.is_internet") and len(attributes.is_internet)>1<cfelse>0</cfif>,
        <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.servicecat#">,
        <cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.remote_addr#">,
        #now()#,
        #session.ep.userid#,
        <cfif isdefined("attributes.is_status")>1<cfelse>0</cfif>,
        <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.our_company_id#">
    )
</cfquery>
<cflocation url="#request.self#?fuseaction=settings.form_add_g_service_app_cat" addtoken="no">
