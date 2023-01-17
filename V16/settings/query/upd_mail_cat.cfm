<cfquery name="UPD_MAIL_CAT" datasource="#DSN#">
	UPDATE
		SETUP_MAIL_WARNING
	SET
		MAIL_CAT = '#attributes.mail_cat#',
		DETAIL = <cfif len(attributes.detail)>'#trim(attributes.detail)#',<cfelse>NULL,</cfif>
		UPDATE_EMP = #SESSION.EP.USERID#,
		UPDATE_IP = '#CGI.REMOTE_ADDR#',
		UPDATE_DATE = #NOW()#
	WHERE
		MAIL_CAT_ID = #attributes.id#
</cfquery>
<cflocation url="#request.self#?fuseaction=settings.form_add_mail_cat" addtoken="no">

