<cfquery name="ADD_CAUTION" datasource="#DSN#">
	UPDATE 
  		EMPLOYEES_CAUTION 
	SET
		APOLOGY='#attributes.APOLOGY#',
		UPDATE_DATE = #now()#,
		UPDATE_EMP = #session.ep.userid#,
		UPDATE_IP = '#cgi.remote_addr#'
  WHERE
  		CAUTION_ID = #attributes.apolog#
</cfquery>	
<script type="text/javascript">
	window.close();
</script>
