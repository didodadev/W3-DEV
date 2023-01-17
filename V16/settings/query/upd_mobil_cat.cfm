<cfquery name="UPDMOBILCAT" datasource="#dsn#">
	UPDATE 
		SETUP_MOBILCAT 
	SET 
		MOBILCAT = '#MOBILCAT#',
		UPDATE_DATE = #NOW()#,
		UPDATE_EMP = #SESSION.EP.USERID#,
		UPDATE_IP = '#CGI.REMOTE_ADDR#'
	WHERE 
		MOBILCAT_ID=#MOBILCAT_ID#
</cfquery>
<cflocation url="#request.self#?fuseaction=settings.form_add_mobil_cat" addtoken="no">
