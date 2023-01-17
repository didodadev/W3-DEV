<cfquery name="upd_school_part" datasource="#dsn#">
	UPDATE 
		SETUP_SCHOOL_PART 
	SET 
		PART_NAME='#TITLE#',	
		DETAIL='#detail#',
		UPDATE_DATE = #NOW()#,
		UPDATE_EMP = #SESSION.EP.USERID#,
		UPDATE_IP = '#CGI.REMOTE_ADDR#'
	WHERE 
		PART_ID=#PART_ID#
</cfquery>
<cflocation url="#request.self#?fuseaction=settings.form_add_school_part" addtoken="no">
