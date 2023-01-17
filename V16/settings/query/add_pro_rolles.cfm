<cfquery name="add_pro_rol" datasource="#DSN#">
  INSERT INTO 
  		SETUP_PROJECT_ROLES
  	(
  		 PROJECT_ROLES,
  		 DETAIL,
  		 RECORD_DATE,
  		 RECORD_EMP,
  		 RECORD_IP
  	)
  		VALUES
  	(
  		 '#ROL#',
  		 <cfif len(detail)>'#DETAIL#',<cfelse>NULL,</cfif>
		 #NOW()#,
		 #SESSION.EP.USERID#,
		 '#CGI.REMOTE_ADDR#'
  	)
</cfquery>
<cflocation url="#request.self#?fuseaction=settings.form_add_pro_rol" addtoken="no">
