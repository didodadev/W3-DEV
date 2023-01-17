<cfquery name="UPDPRO_rolles" datasource="#dsn#">
	UPDATE 
	 SETUP_PROJECT_ROLES 
	SET 
	  PROJECT_ROLES ='#PROJECT_ROLLES#',
	  DETAIL = '#DETAIL#',
	  UPDATE_EMP = #SESSION.EP.USERID#,
	  UPDATE_DATE = #NOW()#,
	  UPDATE_IP = '#CGI.REMOTE_ADDR#'
	WHERE 
	 PROJECT_ROLES_ID=#PROJECT_ROLES_ID#
</cfquery>
<cflocation url="#request.self#?fuseaction=settings.form_add_pro_rol" addtoken="no">
