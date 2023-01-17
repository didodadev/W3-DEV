<cfquery name="ADD_SERVICE_SUPPORT_CAT" datasource="#DSN#">
	INSERT INTO 
		SETUP_SUPPORT
		(
			SUPPORT_CAT,
			RECORD_IP,
			RECORD_DATE,
			RECORD_EMP
		) 
		VALUES 
		(
			'#attributes.support_cat#',
			'#cgi.remote_addr#',
			#now()#,
			#session.ep.userid#
		)
</cfquery>
<cflocation url="#request.self#?fuseaction=settings.form_add_service_support_cat" addtoken="No">
