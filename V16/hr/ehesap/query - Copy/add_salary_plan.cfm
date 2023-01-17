<cfquery name="add_salary_plan" datasource="#dsn#">
	INSERT INTO
		EMPLOYEES_SALARY_PLAN
		(
		EMPLOYEE_ID,
		PERIOD_YEAR,
		M1,
		M2,
		M3,
		M4,
		M5,
		M6,
		M7,
		M8,
		M9,
		M10,
		M11,
		M12,
		MONEY,
		RECORD_IP,
		RECORD_DATE,
		RECORD_EMP,
		IN_OUT_ID
		)
	VALUES
		(
		#attributes.EMPLOYEE_ID#,
		#attributes.SAL_YEAR#,
		#attributes.M1#,
		#attributes.M2#,
		#attributes.M3#,
		#attributes.M4#,
		#attributes.M5#,
		#attributes.M6#,
		#attributes.M7#,
		#attributes.M8#,
		#attributes.M9#,
		#attributes.M10#,
		#attributes.M11#,
		#attributes.M12#,
		'#attributes.MONEY#',
		'#CGI.REMOTE_ADDR#',
		#NOW()#,
		#SESSION.EP.USERID#,
		#attributes.IN_OUT_ID#
		)
</cfquery>

<script type="text/javascript">
	<cfif not isdefined("attributes.draggable")>
		wrk_opener_reload();
		window.close();
	<cfelse>
		closeBoxDraggable( '<cfoutput>#attributes.modal_id#</cfoutput>' );
		location.reload();
	</cfif>
</script>
