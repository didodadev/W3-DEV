<cfquery name="ADD_VIDEO_COMMENT" datasource="#dsn#">
	INSERT INTO 
		COMMENTS 
		(
			BODY,
			TYPE_ID,
			RELATION_ID,
			RECORD_DATE,
			RECORD_EMP,
			RECORD_PAR,
			RECORD_PUB,
			RECORD_IP
		) 
		VALUES 
		(
			'#attributes.video_comment#',
			1,
			#attributes.video_id#,
			#NOW()#,
			<cfif isdefined("SESSION.EP.USERID")>#SESSION.EP.USERID#,<cfelse>NULL,</cfif>
			<cfif isdefined("SESSION.PP.USERID")>#SESSION.PP.USERID#,<cfelse>NULL,</cfif>
			<cfif isdefined("SESSION.WW.USERID")>#SESSION.WW.USERID#,<cfelse>NULL,</cfif>
			'#CGI.REMOTE_ADDR#'
		)
</cfquery>

