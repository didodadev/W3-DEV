<cfquery name="UPD_DUTY_PERIOD" datasource="#DSN#">
	UPDATE
		SETUP_DUTY_PERIOD
		SET
			PERIOD_NAME = '#attributes.period_name#',
			DETAIL = '#attributes.detail#',
			UPDATE_IP = '#cgi.remote_addr#',
			UPDATE_DATE = #now()#,
			UPDATE_EMP = #session.ep.userid#	 
		WHERE
			PERIOD_ID = #attributes.id#
</cfquery>
<cflocation url="#request.self#?fuseaction=settings.form_add_duty_period" addtoken="no">
