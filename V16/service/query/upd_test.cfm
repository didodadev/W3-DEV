<cfquery name="upd_test" datasource="#dsn3#">
	UPDATE SERVICE_TEST
	SET
	 TEST_HEAD = '#attributes.test_head#',
	 DETAIL = '#attributes.detail#',
	 <cfif len(attributes.test_emp_id)>TEST_EMP_ID = #test_emp_id#,</cfif>
	 WORKING_BROKEN = #status#,
     SERVICE_DEFECT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.service_defect_id#">,
	 SERVICE_DEFECT_CODE = '#attributes.service_defect_code#'
    WHERE
		SERVICE_TEST_ID = #ATTRIBUTES.SERVICE_TEST_ID#
</cfquery>

<script type="text/javascript">
	<cfif not isdefined("attributes.draggable")>
		wrk_opener_reload();
		window.close();
	<cfelse>
		closeBoxDraggable( '<cfoutput>#attributes.modal_id#</cfoutput>', 'unique_form_test_id' );
	</cfif>
</script>
