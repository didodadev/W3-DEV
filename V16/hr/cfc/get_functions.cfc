<cfcomponent>
    <cfset dsn = application.systemParam.systemParam().dsn>
	<cffunction name="get_function" access="public" returntype="query">
        <cfquery name="get_functions" datasource="#this.dsn#">
            SELECT
            	UNIT_ID,
                #dsn#.Get_Dynamic_Language(UNIT_ID,'#session.ep.language#','SETUP_CV_UNIT','UNIT_NAME',NULL,NULL,UNIT_NAME) AS UNIT_NAME
            FROM
            	SETUP_CV_UNIT
             WHERE
             	IS_ACTIVE = 1
             ORDER BY
             	UNIT_NAME
        </cfquery>
  		<cfreturn get_functions>
	</cffunction>
    <cffunction name="get_accounting_code_cat" access="public" returnType="query">
        <cfquery name="get_accounting_code_cat" datasource="#dsn#">
            SELECT
                PAYROLL_ID,
                DEFINITION
            FROM
                SETUP_SALARY_PAYROLL_ACCOUNTS_DEFF
            ORDER BY
                DEFINITION
        </cfquery>
        <cfreturn get_accounting_code_cat>
    </cffunction>
</cfcomponent>
