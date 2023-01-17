<cfquery name="ADD_PUANTAJ_PROTEST" datasource="#DSN#">
	INSERT INTO
	   EMPLOYEES_PUANTAJ_PROTESTS
	(
	   EMPLOYEE_ID,
	   PROTEST_DETAIL,
	   PROTEST_DATE,
	   SAL_MON,
	   SAL_YEAR,
	   EMPLOYEE_PUANTAJ_ID,
	   BRANCH_ID,
	   PUANTAJ_ID
	)
	VALUES
	(
	  #session.ep.userid#,
	  '#left(attributes.detail,500)#',
	  #now()#,
	  #attributes.salary_mon#,
	  #attributes.salary_year#,
	  #attributes.employee_puantaj_id#,
	  #attributes.branch_id#,
	  #attributes.puantaj_id#
	 )  
</cfquery>
<script type="text/javascript">
	wrk_opener_reload();
	window.close();
</script>
