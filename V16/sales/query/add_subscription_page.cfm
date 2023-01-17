<cfquery name="add_subscription_page" datasource="#dsn3#">
	INSERT INTO
		SUBSCRIPTION_PAGES
		(
			SUBSCRIPTION_ID,
			PAGE_NAME,
			PAGE_NO,
			PAGE_TYPE,
			PAGE_CONTENT,
			RECORD_DATE,
			RECORD_EMP,
			RECORD_IP,
			SUBSCRIPTION_ZONE
		)
	VALUES
		(
			#SUBSCRIPTION_ID#,
			'#PAGE_NAME#',
			#PAGE_NO#,
			#PAGE_TYPE#,
			'#PAGE_CONTENT#',
			#now()#,
			#SESSION.EP.USERID#,
			'#CGI.REMOTE_ADDR#',
			0
		)
</cfquery>
<cflocation url="#request.self#?fuseaction=sales.popup_add_subscription_page&subs_id=#subscription_id#" addtoken="No">
