<cfquery name="UPD_RETURN_CAT" datasource="#DSN3#">
	UPDATE 
		SETUP_PROD_RETURN_CATS 
	SET 
		RETURN_CAT='#attributes.returncat#',
		UPDATE_IP = '#cgi.remote_addr#',
		UPDATE_DATE = #now()#,
		UPDATE_EMP = #session.ep.userid#
	WHERE 
		RETURN_CAT_ID = #attributes.return_cat_id#
</cfquery>
<cflocation url="#request.self#?fuseaction=settings.form_add_prod_return_cats" addtoken="no">

