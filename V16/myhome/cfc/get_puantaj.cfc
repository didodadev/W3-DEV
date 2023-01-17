<cfcomponent>
    <cfset dsn = application.systemParam.systemParam().dsn>
	<cffunction name="GET_PUANTAJ_PERSONAL" access="public" returntype="query">
        <cfargument name="employee_id" default="">   
        <cfargument name="position_code" default="">
        <cfargument name="sal_year" default="">
        <cfargument name="sal_mon" default="">
        <cfargument name="sal_year_end" default="">
        <cfargument name="sal_mon_end" default="">
        <cfquery name="GET_PUANTAJ_PERSONAL" datasource="#DSN#">
            SELECT
                TOP 12
                EMPLOYEES_PUANTAJ.SAL_YEAR,
                EMPLOYEES_PUANTAJ.SAL_MON
            FROM
                BRANCH,
                EMPLOYEES_IN_OUT,
                EMPLOYEES,
                EMPLOYEES_PUANTAJ,
                EMPLOYEES_PUANTAJ_ROWS,
                EMPLOYEES_IDENTY,
                OUR_COMPANY
            WHERE
                EMPLOYEES_IN_OUT.IN_OUT_ID = EMPLOYEES_PUANTAJ_ROWS.IN_OUT_ID AND
                EMPLOYEES_IDENTY.EMPLOYEE_ID = #arguments.employee_id#
                AND EMPLOYEES_PUANTAJ.PUANTAJ_TYPE = '-1'
                AND EMPLOYEES.EMPLOYEE_ID = #arguments.employee_id#
                AND EMPLOYEES_PUANTAJ_ROWS.EMPLOYEE_ID = #arguments.employee_id#
                AND EMPLOYEES_PUANTAJ_ROWS.EMPLOYEE_ID = EMPLOYEES_IN_OUT.EMPLOYEE_ID
                AND EMPLOYEES_PUANTAJ_ROWS.PUANTAJ_ID = EMPLOYEES_PUANTAJ.PUANTAJ_ID
                AND EMPLOYEES_IN_OUT.BRANCH_ID = BRANCH.BRANCH_ID
                AND BRANCH.SSK_OFFICE = EMPLOYEES_PUANTAJ.SSK_OFFICE
                AND BRANCH.SSK_NO = EMPLOYEES_PUANTAJ.SSK_OFFICE_NO
                AND 
                    (
                        EMPLOYEES_IN_OUT.FINISH_DATE IS NULL
                        OR
					    EXPLANATION_ID = 18
                    )
                AND OUR_COMPANY.COMP_ID = BRANCH.COMPANY_ID
                <cfif not session.ep.ehesap and not isdefined("arguments.is_bireysel_bordro")>
                    AND BRANCH.BRANCH_ID IN ( SELECT BRANCH_ID FROM EMPLOYEE_POSITION_BRANCHES WHERE POSITION_CODE = #arguments.position_code#)
                </cfif>
                <cfif isdefined('arguments.sal_year_end') and len(arguments.sal_year_end) and isdefined('arguments.sal_mon_end') and len(arguments.sal_mon_end)>
                    AND (
                        (EMPLOYEES_PUANTAJ.SAL_YEAR > <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.sal_year#"> AND EMPLOYEES_PUANTAJ.SAL_YEAR < <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.sal_year_end#">)
                        OR
                        (
                            EMPLOYEES_PUANTAJ.SAL_YEAR = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.sal_year#"> AND 
                            EMPLOYEES_PUANTAJ.SAL_MON >= <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.sal_mon#"> AND
                            (
                                EMPLOYEES_PUANTAJ.SAL_YEAR < <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.sal_year_end#">
                                OR
                                (EMPLOYEES_PUANTAJ.SAL_MON <= <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.sal_mon_end#"> AND EMPLOYEES_PUANTAJ.SAL_YEAR = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.sal_year_end#">)
                            )
                        )
                        OR
                        (
                            EMPLOYEES_PUANTAJ.SAL_YEAR > <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.sal_year#"> AND 
                            (
                                EMPLOYEES_PUANTAJ.SAL_YEAR < <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.sal_year_end#">
                                OR
                                (EMPLOYEES_PUANTAJ.SAL_MON <= <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.sal_mon_end#"> AND EMPLOYEES_PUANTAJ.SAL_YEAR = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.sal_year_end#">)
                            )
                        )
                        OR
                        (
                            EMPLOYEES_PUANTAJ.SAL_YEAR = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.sal_year_end#"> AND 
                            EMPLOYEES_PUANTAJ.SAL_YEAR = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.sal_year_end#"> AND
                            EMPLOYEES_PUANTAJ.SAL_MON >= <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.sal_mon#"> AND
                            EMPLOYEES_PUANTAJ.SAL_MON <= <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.sal_mon_end#">
                        )
                    )
                <cfelse>
                    AND EMPLOYEES_PUANTAJ.SAL_MON = #arguments.sal_mon#
                    AND EMPLOYEES_PUANTAJ.SAL_YEAR = #arguments.sal_year#
                </cfif>
            ORDER BY
                EMPLOYEES_PUANTAJ.SAL_YEAR DESC,
                EMPLOYEES_PUANTAJ.SAL_MON DESC
        </cfquery>
  		<cfreturn GET_PUANTAJ_PERSONAL>
	</cffunction>
</cfcomponent>