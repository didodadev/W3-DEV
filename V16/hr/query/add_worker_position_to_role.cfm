<cfquery name="add_worker_emp" datasource="#DSN#">
  UPDATE WORKGROUP_EMP_PAR
  	SET 
	  EMPLOYEE_ID = #attributes.EMPLOYEE_ID#,
	  POSITION_CODE = NULL,
	  PARTNER_ID = NULL,
	  UPDATE_EMP = #session.ep.userid#,
	  UPDATE_IP ='#cgi.remote_addr#',
	  UPDATE_DATE = #now()#
  WHERE
	 WRK_ROW_ID = #attributes.WRK_ROW_ID#
 </cfquery>

<script type="text/javascript">
	wrk_opener_reload();
	window.close();
</script>
