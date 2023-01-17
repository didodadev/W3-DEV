<cfquery name="UPDSERVICECAT" datasource="#DSN3#">
	UPDATE 
		SERVICE_APPCAT 
	SET 
		IS_INTERNET = <cfif isdefined("attributes.is_internet")>1,<cfelse>0,</cfif>
		SERVICECAT = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.servicecat#">,
		UPDATE_IP = <cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.remote_addr#">,
		UPDATE_DATE = #now()#,
		UPDATE_EMP = #session.ep.userid#
	WHERE 
		SERVICECAT_ID=#attributes.servicecat_id#
</cfquery>
<cflocation url="#request.self#?fuseaction=settings.form_upd_service_app_cat&ID=#attributes.servicecat_id#" addtoken="no">

