<cfquery name="UPD_COMPANY_STATUS" datasource="#dsn#">
	UPDATE 
		COMPANY_PARTNER_STATUS 
	SET 
		STATUS_NAME = '#attributes.status_name#',
		UPDATE_DATE = #NOW()#,
		UPDATE_IP = '#CGI.REMOTE_ADDR#',
		UPDATE_EMP = #SESSION.EP.USERID#
	WHERE
		CPS_ID = #attributes.cps_id#
</cfquery>
<cflocation url="#request.self#?fuseaction=settings.form_add_company_partner_status" addtoken="no">
