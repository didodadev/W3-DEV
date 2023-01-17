<cfparam name="attributes.form_id" default="">
<cfquery name="get_print_files" datasource="#dsn3#">
	SELECT
		SPF.FORM_ID, 
        SPF.PROCESS_TYPE, 
        SPF.MODULE_ID, 
        SPF.ACTIVE, 
        SPF.NAME,
        SPF.TEMPLATE_FILE, 
        SPF.DETAIL, 
        SPF.IS_DEFAULT, 
        SPF.TEMPLATE_FILE_SERVER_ID, 
        SPF.IS_STANDART, 
        SPF.IS_PARTNER, 
        SPF.RECORD_DATE, 
        SPF.RECORD_IP, 
        SPF.RECORD_EMP, 
        SPF.UPDATE_DATE, 
        SPF.UPDATE_EMP, 
        SPF.UPDATE_IP,
		EMPLOYEES.EMPLOYEE_NAME,
		EMPLOYEES.EMPLOYEE_SURNAME
	FROM
		SETUP_PRINT_FILES SPF
		LEFT JOIN #dsn_alias#.EMPLOYEES ON EMPLOYEES.EMPLOYEE_ID = SPF.RECORD_EMP
	WHERE
    	1= 1
    	<cfif len(attributes.form_id)>
	    	AND SPF.FORM_ID = #attributes.form_id#
        </cfif>
</cfquery>
