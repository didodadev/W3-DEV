<cfparam name="attributes.branch_id" default="">
<cfparam name="attributes.branch_name" default="">
<cfparam name="attributes.department_id" default="">
<cfparam name="attributes.department_name" default="">
<cfif isdefined("form_submited")>
    <cfquery name="get_in_out_shift" datasource="#dsn#">
        SELECT DISTINCT
            EMPLOYEES_IN_OUT.BRANCH_ID,
            EMPLOYEES_IN_OUT.DEPARTMENT_ID,
            EMPLOYEES_IN_OUT.EMPLOYEE_ID,
            EMPLOYEES.EMPLOYEE_NAME,
            EMPLOYEES.EMPLOYEE_SURNAME,
            (SELECT SHIFT_ID FROM EMPLOYEES_DETAIL WHERE EMPLOYEE_ID = EMPLOYEES.EMPLOYEE_ID) AS SHIFT_ID
        FROM 
            EMPLOYEES_IN_OUT INNER JOIN 
            EMPLOYEES ON EMPLOYEES_IN_OUT.EMPLOYEE_ID = EMPLOYEES.EMPLOYEE_ID
        WHERE
            (EMPLOYEES_IN_OUT.FINISH_DATE IS NULL OR EMPLOYEES_IN_OUT.FINISH_DATE > #NOW()#)
            <cfif isdefined("attributes.branch_id") and len(attributes.branch_id)>
                AND EMPLOYEES_IN_OUT.BRANCH_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.branch_id#">
                AND EMPLOYEES_IN_OUT.DEPARTMENT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.department_id#">
            </cfif>
    </cfquery>
<cfelse>
    <cfset get_in_out_shift.recordcount = 0>
</cfif>
<cfquery name="get_shifts" datasource="#dsn#">
    SELECT 
        SHIFT_ID, 
        SHIFT_NAME, 
        START_HOUR, 
        END_HOUR, 
        START_MIN, 
        END_MIN, 
        RECORD_EMP, 
        RECORD_DATE, 
        RECORD_IP, 
        UPDATE_DATE, 
        UPDATE_EMP, 
        UPDATE_IP, 
        BRANCH_ID, 
        DEPARTMENT_ID
    FROM 
        SETUP_SHIFTS 
    ORDER BY 
        SHIFT_ID
</cfquery>
<script type="text/javascript">
    function control()
    {
        if(document.getElementById('branch_name').value == "")
        {
            alert("<cf_get_lang_main no ='1167.Şube Seçmelisiniz'> !");
            return false;
        }
        return true;
    }
</script>
<cfscript>
	// Switch //
	WOStruct = StructNew();
	
	WOStruct['#attributes.fuseaction#'] = structNew();
	
	WOStruct['#attributes.fuseaction#']['default'] = 'list';
	WOStruct['#attributes.fuseaction#']['list'] = structNew();
	
	WOStruct['#attributes.fuseaction#']['list']['window'] = 'normal';
	WOStruct['#attributes.fuseaction#']['list']['fuseaction'] = 'hr.popup_emp_daily_in_out_shift';
	WOStruct['#attributes.fuseaction#']['list']['filePath'] = 'hr/display/list_emp_daily_in_out_shift.cfm';
	WOStruct['#attributes.fuseaction#']['list']['queryPath'] = 'hr/query/add_employee_in_out_shift.cfm';
	WOStruct['#attributes.fuseaction#']['list']['nextEvent'] = 'hr.popup_emp_daily_in_out_shift';
</cfscript>