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
	<cfif isdefined("attributes.list_id")>
		,SELECT_LIST_ID
	</cfif>
	)		
	VALUES
	(	
		<cfif isdefined("attributes.EMPAPP_ID")>#attributes.EMPAPP_ID#<cfelse>NULL</cfif>,
		<cfif isdefined("attributes.quiz_id")>#attributes.quiz_id#<cfelse>NULL</cfif>,
		#session.ep.userid#,
		#now()#		
	<cfif isdefined("attributes.app_pos_id")>
		,#attributes.app_pos_id#
	</cfif>
	<cfif isdefined("attributes.list_id")>
		,#attributes.list_id#
	</cfif>
	)
</cfquery>

<script type="text/javascript">
	wrk_opener_reload();
	window.close();
</script>


