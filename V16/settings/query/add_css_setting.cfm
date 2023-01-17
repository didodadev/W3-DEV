<CFTRANSACTION>
<cfquery name="ADD_" datasource="#dsn#">
	INSERT INTO CSS_SETTINGS 
		(
		IS_ACTIVE,
		CSS_NAME,
		RECORD_DATE,
		RECORD_EMP,
		RECORD_IP
		) 
		VALUES 
		(
		<cfif isdefined("attributes.is_active")>1,<cfelse>0,</cfif>
		'#attributes.CSS_NAME#',
		#NOW()#,
		#SESSION.EP.USERID#,
		'#CGI.REMOTE_ADDR#'
		)
</cfquery>

<cfquery name="get_" datasource="#dsn#" maxrows="1">
	SELECT CSS_ID FROM CSS_SETTINGS ORDER BY CSS_ID DESC
</cfquery>
</CFTRANSACTION>

<cflocation url="#request.self#?fuseaction=settings.form_upd_css_setting&CSS_ID=#get_.CSS_ID#" addtoken="no">
