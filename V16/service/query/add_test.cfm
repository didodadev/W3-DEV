<cfquery name="add_test" datasource="#dsn3#">
	INSERT INTO
		SERVICE_TEST
	(
		SERVICE_ID,
		TEST_HEAD,
	<cfif len(detail)>
		DETAIL,
	</cfif>	
    <cfif len(attributes.service_defect_id)>
		SERVICE_DEFECT_ID,
	</cfif>
	<cfif len(attributes.service_defect_code)>
		SERVICE_DEFECT_CODE,
	</cfif>
	<cfif len(attributes.test_emp_id)>
		TEST_EMP_ID,
	</cfif>
		WORKING_BROKEN
	)
	VALUES
	(
		#ATTRIBUTES.SERVICE_ID#,
		'#attributes.test_head#',
	<cfif len(detail)>
		'#attributes.detail#',
	</cfif>
    <cfif len(attributes.service_defect_id)>
		<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.service_defect_id#">,
	</cfif>
	<cfif len(attributes.service_defect_code)>
		'#attributes.service_defect_code#',
	</cfif>
	<cfif len(attributes.test_emp_id)>
		#attributes.test_emp_id#,
	</cfif>
	#status#
	)
</cfquery>

<script type="text/javascript">
	<cfif not isdefined("attributes.draggable")>
		wrk_opener_reload();
		window.close();
	<cfelse>
		closeBoxDraggable( '<cfoutput>#attributes.modal_id#</cfoutput>', 'unique_form_test_id' );
	</cfif>
</script>
