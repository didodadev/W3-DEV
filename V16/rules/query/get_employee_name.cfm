<cfquery name="GET_EMPLOYEE_NAME" datasource="#DSN#">
    SELECT 
        EMPLOYEE_EMAIL,
        EMPLOYEE_NAME,
        EMPLOYEE_SURNAME
    FROM 
        EMPLOYEES
    WHERE
        EMPLOYEE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.employee_id#">
</cfquery>