<cfquery name="UPDTITLE" datasource="#dsn#">
	UPDATE 
		SETUP_TITLE 
	SET 
		TITLE = '#TITLE#',	
		TITLE_DETAIL = <cfif len(TITLE_DETAIL)>'#TITLE_DETAIL#',<cfelse>NULL,</cfif>
		HIERARCHY = <cfif len(HIERARCHY)>'#HIERARCHY#'<cfelse>NULL</cfif>,
		RECORD_EMP = #SESSION.EP.USERID#,
		RECORD_DATE = #NOW()#,
		RECORD_IP = '#CGI.REMOTE_ADDR#',
		UPDATE_EMP = #session.ep.userid#,
		UPDATE_IP = '#cgi.remote_addr#',
		UPDATE_DATE = #now()#
	WHERE 
		TITLE_ID=#TITLE_ID#
</cfquery>
<cflocation url="#cgi.http_referer#" addtoken="no">
