<cfquery name="UPDTITLE" datasource="#dsn#">
	UPDATE 
		SETUP_EMPLOYEE_FIRE_REASONS
	SET 
		REASON = '#REASON#',	
		REASON_DETAIL = '#REASON_DETAIL#',
		UPDATE_EMP = #SESSION.EP.USERID#,
		UPDATE_DATE = #NOW()#,
		UPDATE_IP = '#CGI.REMOTE_ADDR#'
	WHERE 
		REASON_ID=#REASON_ID#
</cfquery>
<cflocation url="#cgi.http_referer#" addtoken="no">
