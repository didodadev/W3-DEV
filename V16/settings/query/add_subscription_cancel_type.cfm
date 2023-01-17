<cfquery name="ADD_SUBSCRIPTION_CANCEL_TYPE" datasource="#DSN3#">
	INSERT INTO 
		SETUP_SUBSCRIPTION_CANCEL_TYPE
	(
		SUBSCRIPTION_CANCEL_TYPE,
		RECORD_DATE,
		RECORD_EMP,
		RECORD_IP
	) 
	VALUES 
	(
		'#attributes.subscripton_cancel_type#',
		#now()#,
		#session.ep.userid#,
		'#cgi.remote_addr#'
	)
</cfquery>
<cflocation url="#request.self#?fuseaction=settings.add_subscription_cancel_type" addtoken="no">
