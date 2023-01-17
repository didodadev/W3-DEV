<cfquery name="add_main_rule" datasource="#dsn#">
	INSERT INTO 
		CUBE_MAIL_MAIN_RULES
		(
		RECORD_EMP,
		RECORD_IP,
		RECORD_DATE,
		TYPE,
		RULE_NAME,
		ACTION
		)
	VALUES
		(
		#session.ep.userid#,
		'#CGI.REMOTE_ADDR#',
		#now()#,
		#attributes.type#,
		'#attributes.rule_name#',
		'#attributes.action#'
		)	
</cfquery>
<cflocation url="#request.self#?fuseaction=correspondence.list_mymails" addtoken="no">
