<cfquery name="UPD_SUBSCRIPTION_CANCEL_TYPE" datasource="#DSN3#">
	UPDATE 
		SETUP_SUBSCRIPTION_CANCEL_TYPE
	SET 
		SUBSCRIPTION_CANCEL_TYPE = '#attributes.subscription_cancel_type#',
		UPDATE_DATE = #now()#,
		UPDATE_EMP = #session.ep.userid#,
		UPDATE_IP = '#cgi.remote_addr#'
	WHERE 
		SUBSCRIPTION_CANCEL_TYPE_ID = #attributes.subscription_cancel_type_id#
</cfquery>
<cflocation url="#request.self#?fuseaction=settings.add_subscription_cancel_type" addtoken="no">
