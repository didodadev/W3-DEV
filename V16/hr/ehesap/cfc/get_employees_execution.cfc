<cfcomponent>
<cffunction name="get_execution" access="public" returntype="query">
		<cfargument name="in_out_id" type="numeric">
        <cfquery name="get_get_salary2" datasource="#this.dsn#">
            SELECT 
                EE.EXECUTION_ID,
                CASE WHEN EE.EXECUTION_CAT = 1 THEN 'İcra' WHEN EE.EXECUTION_CAT = 2 THEN 'Nafaka' END AS COMMENT_GET,
                EE.EXECUTION_CAT,
                EE.DEDUCTION_TYPE,
                EE.DEDUCTION_VALUE,
                EE.ACC_TYPE_ID,
                EE.ACCOUNT_CODE,
                EE.ACCOUNT_NAME,
                EE.COMPANY_ID,
                EE.CONSUMER_ID,
                EE.DEBT_AMOUNT,
                ISNULL((SELECT SUM(CASE WHEN PAY_METHOD = 1 THEN AMOUNT_2 WHEN PAY_METHOD = 2 THEN AMOUNT END) FROM EMPLOYEES_PUANTAJ_ROWS_EXT WHERE COMMENT_PAY_ID = EE.EXECUTION_ID AND EXT_TYPE = 3),0) AS ODENEN_TOPLAM
            FROM 
                EMPLOYEES_EXECUTIONS EE
                INNER JOIN EMPLOYEES_IN_OUT EIO ON EIO.EMPLOYEE_ID = EE.EMPLOYEE_ID 
            WHERE
                EE.IS_ACTIVE = 1
                <cfif len(arguments.in_out_id)>
                    AND EIO.IN_OUT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.in_out_id#">
                </cfif>
                AND ISNULL((SELECT SUM(CASE WHEN PAY_METHOD = 1 THEN AMOUNT_2 WHEN PAY_METHOD = 2 THEN AMOUNT END) FROM EMPLOYEES_PUANTAJ_ROWS_EXT WHERE COMMENT_PAY_ID = EE.EXECUTION_ID AND EXT_TYPE = 3),0) < EE.DEBT_AMOUNT
            ORDER BY
                EE.PRIORITY
        </cfquery>
  <cfreturn get_get_salary2>
</cffunction>
</cfcomponent>
