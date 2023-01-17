<cfquery name="UPD_WORKGROUP_TYPE" datasource="#dsn#">
	UPDATE 
		SETUP_NOTICE_GROUP 
	SET 
		NOTICE='#attributes.notice#',
		DETAIL = '#attributes.detail#',
		UPDATE_IP = '#cgi.remote_addr#',
		UPDATE_DATE = #now()#,
		UPDATE_EMP = #session.ep.userid#	 
	WHERE 
		NOTICE_CAT_ID=#attributes.notice_cat_id#
</cfquery>
<cflocation url="#request.self#?fuseaction=settings.form_upd_notice_type&notice_cat_id=#attributes.notice_cat_id#" addtoken="no">
