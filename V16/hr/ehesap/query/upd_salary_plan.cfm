	<cfquery name="upd_salary_plan" datasource="#dsn#">
		UPDATE 
			EMPLOYEES_SALARY_PLAN
		SET
			M1 = #attributes.M1#,
			M2 = #attributes.M2#,
			M3 = #attributes.M3#,
			M4 = #attributes.M4#,
			M5 = #attributes.M5#,
			M6 = #attributes.M6#,
			M7 = #attributes.M7#,
			M8 = #attributes.M8#,
			M9 = #attributes.M9#,
			M10 = #attributes.M10#,
			M11 = #attributes.M11#,
			M12 = #attributes.M12#,
			PERIOD_YEAR = #attributes.SAL_YEAR#,
			MONEY = '#attributes.MONEY#',
			UPDATE_IP = '#CGI.REMOTE_ADDR#',
			UPDATE_DATE = #NOW()#,
			UPDATE_EMP = #SESSION.EP.USERID#
		WHERE
			SALARY_PLAN_ID = #attributes.SALARY_PLAN_ID#
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
