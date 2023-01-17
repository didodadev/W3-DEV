<cfquery name="INS_CONTRACT_CAT" datasource="#dsn3#">
	INSERT INTO 
			CONTRACT_CAT
		(
			CONTRACT_CAT,
			RECORD_EMP,
			RECORD_DATE,
			RECORD_IP
		) 
	VALUES 
		(
			'#CONTRACT_CAT#',
			#SESSION.EP.USERID#,
			#NOW()#,
			'#CGI.REMOTE_ADDR#'
		)
</cfquery>
<cflocation url="#request.self#?fuseaction=settings.form_add_contract_cat" addtoken="no">
