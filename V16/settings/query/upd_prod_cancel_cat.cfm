<cfquery name="upd_return_cat" datasource="#dsn3#">
	UPDATE 
		SETUP_PROD_CANCEL_CATS 
	SET 
		CANCEL_CAT='#attributes.returncat#',
		UPDATE_IP = '#cgi.remote_addr#',
		UPDATE_DATE = #now()#,
		UPDATE_EMP = #session.ep.userid#
	WHERE 
		CANCEL_CAT_ID=#attributes.CANCEL_CAT_ID#
</cfquery>
<cflocation url="#request.self#?fuseaction=settings.form_add_prod_cancel_cats" addtoken="no">

