<cfquery name="upd_cv_unit" datasource="#dsn#">
	UPDATE 
		SETUP_CV_UNIT
	SET 
		IS_VIEW = <cfif isdefined("attributes.is_view") and len(attributes.is_view)>1<cfelse>0</cfif>,
		IS_ACTIVE=<cfif isdefined("attributes.is_active") and len(attributes.is_active)>1<cfelse>0</cfif>,
		UNIT_NAME = <cfqueryparam cfsqltype="cf_sql_varchar" value="#title#">,	
		UNIT_DETAIL = <cfqueryparam cfsqltype="cf_sql_varchar" value="#title_detail#">,
		HIERARCHY = <cfif len(attributes.hierarchy)><cfqueryparam cfsqltype="cf_sql_varchar" value="#hierarchy#"><cfelse>NULL</cfif>,
		UPDATE_DATE = #NOW()#,
		UPDATE_EMP = #SESSION.EP.USERID#,
		UPDATE_IP = '#CGI.REMOTE_ADDR#'
	WHERE 
		UNIT_ID=#attributes.unit_id#
</cfquery>
<cflocation url="#request.self#?fuseaction=settings.form_add_cv_unit" addtoken="no">
