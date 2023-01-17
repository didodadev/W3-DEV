<cfquery name="add_pro_rol" datasource="#DSN3#">
	INSERT 
	INTO 
		SETUP_CAMPAIGN_ROLES
	(
		CAMPAIGN_ROLE,
		DETAIL,
		RECORD_EMP,
		RECORD_IP,
		RECORD_DATE
	)
	VALUES
	(
		'#ROLE#',
		<cfif len(ATTRIBUTES.DETAIL)>'#ATTRIBUTES.DETAIL#',<cfelse>NULL,</cfif>
		#SESSION.EP.USERID#,
		'#CGI.REMOTE_ADDR#',
		#NOW()#
	)
</cfquery>
<cflocation url="#request.self#?fuseaction=settings.form_add_camp_rol" addtoken="no">
