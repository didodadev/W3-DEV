<cfquery name="UPD_EMPAPP_MAIL" datasource="#DSN#">
	UPDATE
		EMPLOYEES_APP_MAILS
	SET
		EMPAPP_ID = #attributes.empapp_id#,
		MAIL_HEAD = '#header#',
		EMPAPP_MAIL = '#EMPLOYEE_EMAIL#',
		MAIL_CONTENT = <cfif len(content)>'#content#'<cfelse>NULL</cfif>,
		UPDATE_DATE = #now()#,	
		UPDATE_IP = '#cgi.REMOTE_ADDR#',
		UPDATE_PAR = #session.pp.userid#
	WHERE
		EMP_APP_MAIL_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.EMP_APP_MAIL_ID#">
</cfquery>

<script type="text/javascript">
  wrk_opener_reload();
  window.close();
</script>
