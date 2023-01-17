<cfquery name="UPD_PAGE_TYPE" datasource="#dsn#">
	UPDATE
		SETUP_PAGE_TYPES
	SET
		PAGE_TYPE = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.PAGE_TYPE#">,
		PAGE_TYPE_DETAIL = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.detail#">,
		OUR_COMPANY_IDS = <cfif isdefined("form.our_company_ids") and len(form.our_company_ids)><cfqueryparam cfsqltype="cf_sql_varchar" value=",#form.our_company_ids#,"><cfelse>NULL</cfif>,
		UPDATE_DATE = #NOW()#,
		UPDATE_IP = <cfqueryparam cfsqltype="cf_sql_varchar" value="#CGI.REMOTE_ADDR#">,
		UPDATE_EMP = #SESSION.EP.USERID#
	WHERE
		PAGE_TYPE_ID = #FORM.PAGE_TYPE_ID#
</cfquery>

<cflocation url="#request.self#?fuseaction=settings.form_upd_page_type&page_type_id=#FORM.PAGE_TYPE_ID#" addtoken="no">
