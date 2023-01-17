<!---
File: V16\report\cfc\employees_bes.cfc
Author: Workcube-Esma Uysal <esmauysal@workcube.com>
Date:10.03.2021
Description: Otomatik Bes Raporu CFC
--->
<cfcomponent>
    <cfset dsn = application.systemParam.systemParam().dsn>
    <cffunction name="GET_EMPLOYEES_BES" access="public" returntype="query"><!--- Filtreleme Query'sidir--->
        <cfargument name = "comp_id" default="">
        <cfargument name = "keyword" default="">
        <cfargument name = "department_id" default="">
        <cfargument name = "inout_statue" default="">
        <cfargument name = "startdate" default="">
        <cfargument name = "finishdate" default="">
        <cfargument name = "start_mon" default="#month(now())-1#">
        <cfargument name = "finish_mon" default="#month(now())-1#">
        <cfargument name = "period_years" default="#session.ep.period_year#">
        <cfquery name="GET_EMPLOYEES_BES" datasource="#dsn#">
            SELECT
                SG.RATE_BES,
                E.EMPLOYEE_NAME,
                EI.TC_IDENTY_NO,
                EI.BIRTH_DATE,
                B.BRANCH_NAME,
                E.EMPLOYEE_SURNAME,
                EIO.DEPARTMENT_ID,
                EIO.IN_OUT_ID,
                EIO.START_DATE,
                EIO.FINISH_DATE,
                (CASE WHEN ED.MOBILTEL_SPC IS NULL THEN E.MOBILCODE+''+E.MOBILTEL ELSE ED.MOBILCODE_SPC+''+ED.MOBILTEL_SPC END) AS PHONE_NUMBER,
                (CASE WHEN ED.EMAIL_SPC IS NULL THEN E.EMPLOYEE_EMAIL ELSE ED.EMAIL_SPC END) AS EMAIL,
                B.SSK_M + '' + B.SSK_JOB + '' + B.SSK_BRANCH + '' + B.SSK_BRANCH_OLD + '' + B.SSK_NO + '' + B.SSK_CITY + '' + B.SSK_COUNTRY + '' + B.SSK_CD AS SSK_ISYERI,
                B.SSK_AGENT,
                ED.HOMEADDRESS,
                EIO.SSK_STATUTE,
                EBA.IBAN_NO
            FROM 
                SALARYPARAM_BES SG
                    LEFT JOIN EMPLOYEES_IN_OUT EIO ON EIO.IN_OUT_ID = SG.IN_OUT_ID
                    LEFT JOIN DEPARTMENT D ON D.DEPARTMENT_ID = EIO.DEPARTMENT_ID
                    LEFT JOIN BRANCH B ON  EIO.BRANCH_ID = B.BRANCH_ID
                    LEFT JOIN EMPLOYEES E ON E.EMPLOYEE_ID = SG.EMPLOYEE_ID AND EIO.EMPLOYEE_ID = E.EMPLOYEE_ID
                    LEFT JOIN EMPLOYEES_IDENTY EI ON E.EMPLOYEE_ID = EI.EMPLOYEE_ID 
                    LEFT JOIN EMPLOYEES_DETAIL ED ON ED.EMPLOYEE_ID = E.EMPLOYEE_ID
                    LEFT JOIN EMPLOYEE_POSITIONS EP ON (E.EMPLOYEE_ID = EP.EMPLOYEE_ID AND EP.IS_MASTER = 1)
                    LEFT JOIN SETUP_POSITION_CAT SPC ON SPC.POSITION_CAT_ID = EP.POSITION_CAT_ID
                    LEFT JOIN EMPLOYEES_BANK_ACCOUNTS EBA ON EIO.EMPLOYEE_ID = EBA.EMPLOYEE_ID AND DEFAULT_ACCOUNT = 1
            WHERE
                (
                    <cfif arguments.start_mon lte arguments.finish_mon>
                        (START_SAL_MON <= <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.start_mon#"> AND END_SAL_MON >= <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.start_mon#">)
                        OR
                        (END_SAL_MON >= <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.start_mon#"> AND END_SAL_MON <= <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.finish_mon#">)
                        OR
                        (	
                            END_SAL_MON = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.start_mon#"> OR 
                            END_SAL_MON = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.finish_mon#"> OR 
                            START_SAL_MON = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.start_mon#"> OR 
                            START_SAL_MON = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.finish_mon#">
                        )
                    <cfelse>
                        START_SAL_MON IS NULL
                    </cfif>
                )
                AND SG.TERM = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.period_years#">
            <cfif len(arguments.keyword)>
                AND ((E.EMPLOYEE_NAME + ' ' + E.EMPLOYEE_SURNAME) LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#arguments.keyword#%"> COLLATE SQL_Latin1_General_CP1_CI_AI
                OR EI.TC_IDENTY_NO = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.keyword#"> OR E.EMPLOYEE_NO = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.keyword#">)
            </cfif>
            <cfif isdefined("arguments.comp_id") and len(arguments.comp_id)>
                AND B.COMPANY_ID IN (<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.comp_id#"  list="yes">)
            </cfif>
            <cfif isdefined("arguments.branch_id") and len(arguments.branch_id)>
                AND EIO.BRANCH_ID IN (<cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.branch_id#"  list="yes">)
            <cfelseif not session.ep.ehesap>
                AND
                (
                EIO.BRANCH_ID IN (
                                SELECT
                                    BRANCH_ID
                                FROM
                                    EMPLOYEE_POSITION_BRANCHES
                                WHERE
                                    EMPLOYEE_POSITION_BRANCHES.POSITION_CODE = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.position_code#">
                                )
                )
            </cfif>
            <cfif isdefined("arguments.department_id") and len(arguments.department_id) and arguments.department_id gt 0>
                AND EIO.DEPARTMENT_ID IN (<cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.department_id#" list="yes">)
            </cfif>
            <cfif isdefined('arguments.inout_statue') and arguments.inout_statue eq 1><!--- Girişler --->
                <cfif isdefined('arguments.startdate') and isdate(arguments.startdate)>
                    AND EIO.START_DATE >= <cfqueryparam cfsqltype="cf_sql_date" value="#arguments.startdate#">
                </cfif>
                <cfif isdefined('arguments.finishdate') and isdate(arguments.finishdate)>
                    AND EIO.START_DATE <= <cfqueryparam cfsqltype="cf_sql_date" value="#arguments.finishdate#">
                </cfif>
            <cfelseif isdefined('arguments.inout_statue') and arguments.inout_statue eq 0><!--- Çıkışlar --->
                <cfif isdefined('arguments.startdate') and isdate(arguments.startdate)>
                    AND EIO.FINISH_DATE >= <cfqueryparam cfsqltype="cf_sql_date" value="#arguments.startdate#">
                </cfif>
                <cfif isdefined('arguments.finishdate') and isdate(arguments.finishdate)>
                    AND EIO.FINISH_DATE <= <cfqueryparam cfsqltype="cf_sql_date" value="#arguments.finishdate#">
                </cfif>
                AND	EIO.FINISH_DATE IS NOT NULL
            <cfelseif isdefined('arguments.inout_statue') and arguments.inout_statue eq 2><!--- aktif calisanlar --->
                AND E.EMPLOYEE_ID IN (SELECT DISTINCT EMPLOYEE_ID FROM EMPLOYEES_IN_OUT WHERE
                (
                    <cfif isdate(arguments.startdate) or isdate(arguments.finishdate)>
                        <cfif isdate(arguments.startdate) and not isdate(arguments.finishdate)>
                        (
                            (
                                EIO.START_DATE <= <cfqueryparam cfsqltype="cf_sql_date" value="#arguments.startdate#"> AND
                                EIO.FINISH_DATE >= <cfqueryparam cfsqltype="cf_sql_date" value="#arguments.startdate#">
                            )
                            OR
                            (
                                EIO.START_DATE <= <cfqueryparam cfsqltype="cf_sql_date" value="#arguments.startdate#"> AND
                                EIO.FINISH_DATE IS NULL
                            )
                        )
                        <cfelseif not isdate(arguments.startdate) and isdate(arguments.finishdate)>
                        (
                            (
                                EIO.START_DATE <= <cfqueryparam cfsqltype="cf_sql_date" value="#arguments.finishdate#"> AND
                                EIO.FINISH_DATE >= <cfqueryparam cfsqltype="cf_sql_date" value="#arguments.finishdate#">
                            )
                            OR
                            (
                                EIO.START_DATE <= <cfqueryparam cfsqltype="cf_sql_date" value="#arguments.finishdate#"> AND
                                EIO.FINISH_DATE IS NULL
                            )
                        )
                        <cfelse>
                        (
                            (
                                EIO.START_DATE <= <cfqueryparam cfsqltype="cf_sql_date" value="#arguments.startdate#"> AND
                                EIO.FINISH_DATE >= <cfqueryparam cfsqltype="cf_sql_date" value="#arguments.finishdate#">
                            )
                            OR
                            (
                                EIO.START_DATE <= <cfqueryparam cfsqltype="cf_sql_date" value="#arguments.startdate#"> AND
                                EIO.FINISH_DATE IS NULL
                            )
                            OR
                            (
                                EIO.START_DATE >= <cfqueryparam cfsqltype="cf_sql_date" value="#arguments.startdate#"> AND
                                EIO.START_DATE <= <cfqueryparam cfsqltype="cf_sql_date" value="#arguments.finishdate#">
                            )
                            OR
                            (
                                EIO.FINISH_DATE >= <cfqueryparam cfsqltype="cf_sql_date" value="#arguments.startdate#"> AND
                                EIO.FINISH_DATE <= <cfqueryparam cfsqltype="cf_sql_date" value="#arguments.finishdate#">
                            )
                        )
                        </cfif>
                    <cfelse>
                        EIO.FINISH_DATE IS NULL
                    </cfif>
                ) )
            <cfelse><!--- giriş ve çıkışlar Seçili ise --->
                AND 
                (
                    (
                        EIO.START_DATE IS NOT NULL
                        <cfif isdefined('arguments.startdate') and isdate(arguments.startdate)>
                            AND EIO.START_DATE >= <cfqueryparam cfsqltype="cf_sql_date" value="#arguments.startdate#">
                        </cfif>
                        <cfif isdefined('arguments.finishdate') and isdate(arguments.finishdate)>
                            AND EIO.START_DATE <= <cfqueryparam cfsqltype="cf_sql_date" value="#arguments.finishdate#">
                        </cfif>
                    )
                    OR
                    (
                        EIO.START_DATE IS NOT NULL
                        <cfif isdefined('arguments.startdate') and isdate(arguments.startdate)>
                            AND EIO.FINISH_DATE >= <cfqueryparam cfsqltype="cf_sql_date" value="#arguments.startdate#">
                        </cfif>
                        <cfif isdefined('arguments.finishdate') and isdate(arguments.finishdate)>
                            AND EIO.FINISH_DATE <= <cfqueryparam cfsqltype="cf_sql_date" value="#arguments.finishdate#">
                        </cfif>
                    )
                )
            </cfif>
        </cfquery>
        <cfreturn GET_EMPLOYEES_BES>
    </cffunction>
    <cffunction name="GET_PAYROLL_BES" access="public" returntype="query"><!--- Bordrodaki bes katılım payı--->
        <cfargument name = "in_out_id" default="">
        <cfargument name = "period_years" default="">
        <cfargument name = "period_years_end" default="">
        <cfargument name = "start_mon" default="">
        <cfargument name = "finish_mon" default="">
        <cfquery name="GET_PAYROLL_BES" datasource="#dsn#">
            SELECT
                SUM(BES_ISCI_HISSESI) TOTAL_BES,
                SUM(SSK_MATRAH) TOTAL_MATRAH
            FROM
                EMPLOYEES_PUANTAJ_ROWS EPR
                LEFT JOIN EMPLOYEES_PUANTAJ EP ON EP.PUANTAJ_ID = EPR.PUANTAJ_ID
            WHERE
                (
					(EP.SAL_YEAR > <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.period_years#"> AND EP.SAL_YEAR < <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.period_years_end#">)
					OR
					(
						EP.SAL_YEAR = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.period_years#"> AND 
						EP.SAL_MON >= <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.start_mon#"> AND
						(
							EP.SAL_YEAR < <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.period_years_end#">
							OR
							(EP.SAL_MON <= <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.finish_mon#"> AND EP.SAL_YEAR = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.period_years_end#">)
						)
					)
					OR
					(
						EP.SAL_YEAR > <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.period_years#"> AND 
						(
							EP.SAL_YEAR < <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.period_years_end#">
							OR
							(EP.SAL_MON <= <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.finish_mon#"> AND EP.SAL_YEAR = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.period_years_end#">)
						)
					)
					OR
					(
						EP.SAL_YEAR = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.period_years_end#"> AND 
						EP.SAL_YEAR = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.period_years_end#"> AND
						EP.SAL_MON >= <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.start_mon#"> AND
						EP.SAL_MON <= <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.finish_mon#">
					)
				)
                AND IN_OUT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.in_out_id#">
        </cfquery>
        <cfreturn GET_PAYROLL_BES>
    </cffunction>
</cfcomponent>