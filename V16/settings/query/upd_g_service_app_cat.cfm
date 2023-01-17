<cfquery name="upd_service_appcat" datasource="#dsn#">
	UPDATE 
		G_SERVICE_APPCAT 
	SET 
		SERVICECAT = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.servicecat#">,
		IS_INTERNET = <cfif isdefined("attributes.is_internet") and len(attributes.is_internet)>1<cfelse>0</cfif>,
		UPDATE_IP = <cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.remote_addr#">,
		UPDATE_DATE = #now()#,
		UPDATE_EMP = #session.ep.userid#,
        IS_STATUS = <cfif isdefined("attributes.is_status")>1<cfelse>0</cfif>,
        OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.our_company_id#"> 
	WHERE 
		SERVICECAT_ID = #attributes.servicecat_id#
</cfquery>
<cflocation url="#request.self#?fuseaction=settings.form_upd_g_service_app_cat&servicecat_id=#attributes.servicecat_id#" addtoken="no">

