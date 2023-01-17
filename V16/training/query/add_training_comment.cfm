<cfquery name="ADD_COMMENT" datasource="#dsn#">
	INSERT INTO 
		TRAINING_COMMENT 
		(
		TRAINING_ID,
		TRAINING_COMMENT,
		TRAINING_COMMENT_POINT,
		NAME,
		SURNAME,
		STAGE_ID,
		MAIL_ADDRESS,						
		RECORD_DATE,
		RECORD_IP
		)
	VALUES
		(
		#attributes.TRAINING_ID#,
		'#attributes.TRAINING_COMMENT#',
		#attributes.TRAINING_COMMENT_POINT#,													
		'#attributes.NAME#',
		'#attributes.SURNAME#',
		-1,				
		'#attributes.MAIL_ADDRESS#',				
		#NOW()#,
		'#CGI.REMOTE_ADDR#'
		)
</cfquery>
<cfif len(attributes.MAIL_ADDRESS)>
	<!--- Mail list kayıt --->
	<cfquery name="GET_MAIL" datasource="#dsn#">
	 SELECT MAILLIST_EMAIL FROM MAILLIST WHERE MAILLIST_EMAIL = '#attributes.MAIL_ADDRESS#'
	</cfquery>
	
	<cfif NOT GET_MAIL.RECORDCOUNT>
	<cfquery name="ADD_MAIL" datasource="#dsn#">
		INSERT INTO 
			MAILLIST 
			(
			MAILLIST_NAME,
			MAILLIST_SURNAME,
			MAILLIST_EMAIL,
			RECORD_DATE,
			MAILLIST_CAT_ID
			)
		VALUES
			(
			'#attributes.NAME#',
			'#attributes.SURNAME#',
			'#attributes.MAIL_ADDRESS#',				
			#NOW()#,
			-1
			)
		</cfquery>		
	</cfif>
		<!--- Mail list kayıt --->
</cfif>
<script type="text/javascript">
	wrk_opener_reload();
	window.close();
</script>
