<cfif isdefined("url.is_sil")>
	<cfquery name="UPD_EMP_TEST_TIME" datasource="#DSN#">
		DELETE FROM EMPLOYEES_TEST_TIME WHERE TEST_TIME_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.test_time_id#">
	</cfquery>
	<cf_add_log  log_type="-1" action_id="#attributes.test_time_id#" action_name="Deneme Süresi">
<cfelse>
	<cfquery name="UPD_EMP_TEST_TIME" datasource="#DSN#">
		UPDATE EMPLOYEES_TEST_TIME
		SET 
			 QUIZ_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.quiz_id#">
			,TEST_TIME_STAGE =<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.process_stage#">
			,TEST_TIME_TYPE = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.test_time_type#">
			,TEST_TIME_DAY = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.test_time#">
			,CAUTION_TIME_DAY = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.caution_time#">
			,CAUTION_EMP_ID =<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.caution_emp_id#">
			,TEST_TIME_DETAIL = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.test_detail#">
			,UPDATE_DATE = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#NOW()#">
			,UPDATE_EMP = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#">
			,UPDATE_IP = <cfqueryparam cfsqltype="cf_sql_varchar" value="#CGI.REMOTE_ADDR#">
		WHERE TEST_TIME_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.test_time_id#">
	</cfquery>
	<cfquery name="get_employee" datasource="#dsn#">
		SELECT EMPLOYEE_NAME,EMPLOYEE_SURNAME FROM EMPLOYEES WHERE EMPLOYEE_ID = #attributes.emp_id#
	</cfquery>
	<cfif isdefined('attributes.work_start_date') and len (attributes.work_start_date)>
		<cfif isdefined("test_time") and len(test_time) and isdefined("caution_time") and len(caution_time)>
			<cfset warning_day = attributes.test_time-attributes.caution_time>
			<cfset warning_date = dateadd('d',warning_day,attributes.work_start_date)>
		</cfif>
		<cfinclude template="upd_emp_test_time_warning.cfm">	
		<!--- uyarı*************** --->
	<cfelse>
		<script type="text/javascript">
		   alert("<cf_get_lang no ='1750.Çalışanın İşe Giriş İşlemini Yapınız'> !");
		   history.back();
		</script>
	</cfif>
	
</cfif>
<script type="text/javascript">
	<cfif not isdefined("attributes.draggable")>
		location.href=document.referrer;
    <cfelseif isdefined("attributes.draggable")>
        closeBoxDraggable( 'upd_test_time' );
        closeBoxDraggable( 'trial_time' );
        openBoxDraggable('<cfoutput>#request.self#?fuseaction=hr.popup_list_emp_test_time&emp_id=#attributes.emp_id#</cfoutput>','trial_time');
	</cfif>
</script>