<cfquery name="UPD_COMPANY_SIZE_CAT" datasource="#dsn#">
	UPDATE 
		SETUP_COMPANY_SIZE_CATS 
	SET 
		COMPANY_SIZE_CAT = <cfqueryparam cfsqltype="cf_sql_varchar" value="#COMPANY_SIZE_CAT#">,
		UPDATE_DATE = #now()#,
		UPDATE_IP = '#cgi.remote_addr#',
		UPDATE_EMP = #session.ep.userid#
	WHERE
		COMPANY_SIZE_CAT_ID = #COMPANY_SIZE_CAT_ID#
</cfquery>
<cflocation url="#request.self#?fuseaction=settings.form_add_company_size_cat" addtoken="no">
