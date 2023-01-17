<cfquery name="upd_lib_cat" datasource="#dsn#">

	UPDATE
		LIBRARY_CAT
	SET
		LIBRARY_CAT = '#attributes.LIBCAT#',
		DETAIL = '#attributes.DETAIL#',
		UPDATE_IP = '#cgi.remote_addr#',
		UPDATE_DATE = #now()#,
		UPDATE_EMP = #session.ep.userid#
	WHERE 
		LIBRARY_CAT_ID = #ID#
</cfquery>
<cflocation url="#request.self#?fuseaction=settings.form_add_library_set" addtoken="no">
