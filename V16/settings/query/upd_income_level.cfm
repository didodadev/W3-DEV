<cfquery name="upd_income_level" datasource="#dsn#">
	UPDATE 
		SETUP_INCOME_LEVEL
	SET 
		INCOME_LEVEL='#income_level#',	
		DETAIL=<cfif isDefined("attributes.detail") and len(attributes.detail)>'#detail#',<cfelse>null,</cfif>
		UPDATE_DATE = #NOW()#,
		UPDATE_EMP = #SESSION.EP.USERID#,
		UPDATE_IP = '#CGI.REMOTE_ADDR#'
	WHERE 
		INCOME_LEVEL_ID=#LEVEL_ID#
</cfquery>
<cflocation url="#request.self#?fuseaction=settings.form_add_income_level" addtoken="no">
