<cfquery name="upd_solution" datasource="#dsn#">
	UPDATE
		CUST_HELP_SOLUTIONS
	SET
		CUS_HELP_ID = #attributes.help_id#,
		SOLUTION_SUBJECT = '#attributes.header#',
		SOLUTION_DETAIL = '#attributes.content#',
		UPDATE_DATE = #now()#,
		UPDATE_IP = '#cgi.REMOTE_ADDR#',
		UPDATE_EMP = #session.ep.userid#
	WHERE
		HELP_SOL_ID = #attributes.help_sol_id#
</cfquery>
<script type="text/javascript">
	wrk_opener_reload();
	window.close();
</script>
