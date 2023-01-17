<cfcomponent>
	<cfset dsn = application.systemParam.systemParam().dsn>
    <cffunction name="get_competencies">
        <cfquery name="get_competencies" datasource="#dsn#">
            SELECT
                *
            FROM
                SETUP_REQ_TYPE
        </cfquery>
		<cfreturn get_competencies>
    </cffunction>
    <cffunction name="getReqTypeForEmp">
        <cfargument name="employee_id">
        <cfquery name="getReqTypeForEmp" datasource="#dsn#">
            SELECT
                EC.*,
                SRT.*
            FROM
                EMPLOYEES_COMPETENCIES EC
                    INNER JOIN SETUP_REQ_TYPE SRT ON SRT.REQ_ID = EC.REQ_TYPE_ID
            WHERE
                EC.EMPLOYEE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.employee_id#">
        </cfquery>
		<cfreturn getReqTypeForEmp>
    </cffunction>
    <cffunction name="add_competencies_to_emp" access="remote" returntype="any">
        <cfargument name="employee_id">
        <cfargument name="req_type_id">
        <cfquery name="emp_competencies" datasource="#dsn#">
            SELECT
                EC.*,
                SRT.*
            FROM
                EMPLOYEES_COMPETENCIES EC
                    INNER JOIN SETUP_REQ_TYPE SRT ON SRT.REQ_ID = EC.REQ_TYPE_ID
            WHERE
                EC.EMPLOYEE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.employee_id#"> AND
                EC.REQ_TYPE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.req_type_id#">
        </cfquery>
        <cfif emp_competencies.recordcount>
            <cfreturn 'Kayıt Var.'>
        <cfelse>
            <cfquery name="add_competencies_to_emp" datasource="#dsn#">
                INSERT INTO
                    EMPLOYEES_COMPETENCIES
                    (
                        EMPLOYEE_ID,
                        REQ_TYPE_ID,
                        RECORD_EMP,
                        RECORD_DATE,
                        RECORD_IP
                    )
                VALUES
                    (
                        <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.employee_id#">,
                        <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.req_type_id#">,
                        <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#">,
                        #now()#,
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#CGI.REMOTE_ADDR#">
                    )
            </cfquery>
        </cfif>
    </cffunction>
    <cffunction name="del_competencies_from_emp" access="remote">
        <cfargument name="competencies_id">
        <cfquery name="del_competencies_from_emp" datasource="#dsn#">
            DELETE FROM
                EMPLOYEES_COMPETENCIES
            WHERE
                COMPETENCIES_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.competencies_id#">
        </cfquery>
        <cfreturn 'OK'>
    </cffunction>
</cfcomponent>