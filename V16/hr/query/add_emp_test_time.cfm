<cfquery name="ADD_EMP_TEST_TIME" datasource="#DSN#">
    INSERT INTO EMPLOYEES_TEST_TIME
        (EMPLOYEE_ID
        ,QUIZ_ID
        ,TEST_TIME_STAGE
        ,TEST_TIME_TYPE
        ,TEST_TIME_DAY
        ,CAUTION_TIME_DAY
        ,CAUTION_EMP_ID
        ,TEST_TIME_DETAIL
        ,RECORD_DATE
        ,RECORD_EMP
        ,RECORD_IP)
    VALUES
        (
            <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.emp_id#">
            ,<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.quiz_id#">
            ,<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.process_stage#">
            ,<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.test_time_type#">
            ,<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.test_time#">
            ,<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.caution_time#">
            ,<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.caution_emp_id#">
            ,<cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.test_detail#">
            ,<cfqueryparam cfsqltype="cf_sql_date" value="#NOW()#">
            ,<cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#">
            ,<cfqueryparam cfsqltype="cf_sql_varchar" value="#CGI.REMOTE_ADDR#">
        )
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
        <cfif not isdefined("attributes.draggable")>
            history.back();
        <cfelseif isdefined("attributes.draggable")>
            closeBoxDraggable( '<cfoutput>#attributes.modal_id#</cfoutput>' );
        </cfif>
    </script>
</cfif>
<script type="text/javascript">
    <cfif isdefined("attributes.draggable")>
        closeBoxDraggable( 'trial_time' );
    <cfelse>
        window.location = "<cfoutput>#request.self#?fuseaction=hr.list_hr&event=upd&employee_id=#attributes.emp_id#</cfoutput>";
    </cfif>
</script>