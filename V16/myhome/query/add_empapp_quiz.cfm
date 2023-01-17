<cfquery name="ADD_EMPQUIZ" datasource="#dsn#">
	INSERT INTO
		EMPLOYEES_APP_QUIZ
	(
		EMPAPP_ID,
		QUIZ_ID,
		RECORD_EMP,
		RECORD_DATE
	<cfif isdefined("attributes.app_pos_id")>
		,APP_POS_ID
	</cfif>
	)		
	VALUES
	(	
		#attributes.EMPAPP_ID#,
		#attributes.quiz_id#,
		#session.ep.userid#,
		#now()#		
	<cfif isdefined("attributes.app_pos_id")>
		,#attributes.app_pos_id#
	</cfif>
	)
</cfquery>

<script type="text/javascript">
	wrk_opener_reload();
	window.close();
</script>
