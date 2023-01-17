<cfquery name="upd_school_part" datasource="#dsn#">
	UPDATE 
		SETUP_HIGH_SCHOOL_PART 
	SET 
		HIGH_PART_NAME='#TITLE#',	
		HIGH_DETAIL='#detail#',
		UPDATE_DATE = #NOW()#,
		UPDATE_EMP = #SESSION.EP.USERID#,
		UPDATE_IP = '#CGI.REMOTE_ADDR#'
	WHERE 
		HIGH_PART_ID=#PART_ID#
</cfquery>
<cflocation url="#request.self#?fuseaction=settings.form_highadd_school_part" addtoken="no">
