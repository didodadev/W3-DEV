<!---
File: additional_allowance.cfc
Author: Workcube-Esma Uysal <esmauysal@workcube.com>
Date:05.11.2019
Controller: -
Description: Ek Ödenek Raporu Fonksiyonları;  
Şubeler,
--->
<cfcomponent>
    <cfset dsn = application.systemParam.systemParam().dsn>
    <cffunction name="GET_BRANCH" access="public" returntype="query"><!---Şubeler--->
        <cfquery name="GET_BRANCH" datasource="#dsn#">
            SELECT
                BRANCH_ID,
                BRANCH_NAME
            FROM
                BRANCH
            WHERE 
                BRANCH_STATUS = 1
                <cfif not session.ep.ehesap>
					AND BRANCH_ID IN (
						SELECT
                            EBR.BRANCH_ID
						FROM
							EMPLOYEE_POSITION_BRANCHES EBR
						WHERE
                            EBR.POSITION_CODE = #session.ep.position_code#
					)
				</cfif>
        </cfquery>
        <cfreturn GET_BRANCH>
    </cffunction>
    <cffunction name="GET_ADDITIONAL_ALLOWANGE" access="public" returntype="query"><!--- Filtreleme Query'sidir--->
        <cfargument name="position_id" default="">
        <cfargument name="start_mon" default="">  
        <cfargument name="finish_mon" default="">
        <cfargument name="period_year" default=""> 
        <cfargument name="odkes_id_0" default="">
        <cfargument name="comment_pay_0" default="">
        <cfargument name="inout_statue" default=""> 
        <cfargument name="function_unit" default="">
        <cfargument name="title_id" default=""> 
        <cfargument name="branch_id" default="">
        <cfargument name="duty_type" default=""> 
        <cfargument name="collor_type" default="">
        <cfargument name="startdate" default=""> 
        <cfargument name="finishdate" default="">
        <cfquery name="GET_ADDITIONAL_ALLOWANGE" datasource="#dsn#">
            SELECT 
                EIO.IN_OUT_ID,
                E.EMPLOYEE_ID,
                E.EMPLOYEE_NAME,
                E.EMPLOYEE_SURNAME,
                B.BRANCH_NAME,
                D.DEPARTMENT_HEAD,
                EIO.FINISH_DATE
            FROM 
                EMPLOYEES E
                INNER JOIN EMPLOYEES_IN_OUT EIO ON EIO.EMPLOYEE_ID = E.EMPLOYEE_ID
                INNER JOIN EMPLOYEES_RELATIVES ER ON ER.EMPLOYEE_ID = E.EMPLOYEE_ID 
                LEFT JOIN EMPLOYEE_POSITIONS EP ON EP.EMPLOYEE_ID = E.EMPLOYEE_ID AND EP.POSITION_STATUS = 1 AND EP.IS_MASTER = 1
                LEFT JOIN DEPARTMENT D ON EP.DEPARTMENT_ID = D.DEPARTMENT_ID
                LEFT JOIN BRANCH B ON D.BRANCH_ID = B.BRANCH_ID
            WHERE 
                1 = 1
                <cfif len(arguments.position_id)>
                    AND EP.POSITION_CAT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.position_id#">
                </cfif>
                <cfif len(arguments.branch_id)>
                    AND B.BRANCH_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.branch_id#">
                </cfif>
                <cfif not session.ep.ehesap>
					AND B.BRANCH_ID IN (
						SELECT
                            EBR.BRANCH_ID
						FROM
							EMPLOYEE_POSITION_BRANCHES EBR
						WHERE
                            EBR.POSITION_CODE = #session.ep.position_code#
					)
				</cfif>
                <cfif len(arguments.title_id)>
					AND EP.TITLE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.title_id#">
                </cfif>
                <cfif len(arguments.duty_type)>
					AND EP.DUTY_TYPE = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.duty_type#">
                </cfif>
                <cfif len(arguments.collor_type)>
					AND EP.COLLAR_TYPE = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.collor_type#">
                </cfif>
                <cfif len(arguments.function_unit)>
					AND EP.FUNC_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.function_unit#">
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
            GROUP BY
                EIO.IN_OUT_ID,
                E.EMPLOYEE_ID,
                E.EMPLOYEE_NAME,
                E.EMPLOYEE_SURNAME,
                EIO.GROSS_NET,
                E.EMPLOYEE_NAME,
                E.EMPLOYEE_SURNAME,
                B.BRANCH_NAME,
                D.DEPARTMENT_HEAD,
                EIO.FINISH_DATE
            ORDER BY
                E.EMPLOYEE_NAME,
                E.EMPLOYEE_SURNAME
        </cfquery>
        <cfreturn GET_ADDITIONAL_ALLOWANGE>
    </cffunction>
    <cffunction name="GET_COMMENT_PAY" access="public" returntype="query"><!--- Ek Ödenek Query'sidir.--->
        <cfargument name="comment_pay_0" default="">
        <cfargument name="odkes_id_0" default="">
        <cfquery name="GET_COMMENT_PAY" datasource="#dsn#">
            SELECT 
                *
            FROM 
                SETUP_PAYMENT_INTERRUPTION
            WHERE
                1 = 1
                <cfif len(arguments.comment_pay_0)>
                    AND COMMENT_PAY = <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#arguments.comment_pay_0#">
                </cfif>
                <cfif len(arguments.odkes_id_0)>
                   AND PAY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.odkes_id_0#">
                </cfif>
        </cfquery>
        <cfreturn GET_COMMENT_PAY>
    </cffunction>
    <cffunction name="GET_EMP_ID_FROM_INOUT" access="public" returntype="query"><!--- In out tablosundan employee_id.--->
        <cfargument name="in_out_id" default="">
        <cfquery name="GET_EMP_ID_FROM_INOUT" datasource="#dsn#">
            SELECT 
               EMPLOYEE_ID
            FROM 
                EMPLOYEES_IN_OUT
            WHERE 
                IN_OUT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.in_out_id#">
        </cfquery>
        <cfreturn GET_EMP_ID_FROM_INOUT>
    </cffunction>
    <cffunction name="SET_ADD_ALLOWANCE" access="public" returntype="boolean"><!--- In out tablosundan employee_id.--->
        <cfargument name="in_out_id" default="">
        <cfargument name="employee_id" default="">
        <cfargument name="odkes_id" default="">
        <cfargument name="period_years" default="">
        <cfargument name="start_mon" default="">
        <cfargument name="finish_mon" default="">
        <cfargument name="child_count" default="">
        <cfquery name="SET_ADD_ALLOWANCE" datasource="#dsn#">
           INSERT INTO
				SALARYPARAM_PAY
				(
				IN_OUT_ID,
				COMMENT_PAY,
                COMMENT_PAY_ID,
				PERIOD_PAY,
				METHOD_PAY,
				AMOUNT_PAY,
				SSK,
				TAX,
				SHOW,
				START_SAL_MON,
				END_SAL_MON,
				EMPLOYEE_ID,
				TERM,
				CALC_DAYS,
				IS_KIDEM,
				FROM_SALARY,	
				IS_EHESAP,
				IS_DAMGA,
				IS_ISSIZLIK,
				RECORD_DATE,
				RECORD_EMP,
				RECORD_IP,
                SSK_STATUE,
				STATUE_TYPE,
                PROJECT_ID
				)
				SELECT
					<cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.in_out_id#">,
					COMMENT_PAY,
                    PAY_ID,
					PERIOD_PAY,
					METHOD_PAY,
					AMOUNT_PAY,
					SSK,
					TAX,
					SHOW,
					<cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.start_mon#">,
					<cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.finish_mon#">,
					<cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.employee_id#">,
					<cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.period_years#">,
					CALC_DAYS,
					IS_KIDEM,
					FROM_SALARY,	
					IS_EHESAP,
					IS_DAMGA,
					IS_ISSIZLIK,
					<cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">,
					<cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#">,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.remote_addr#">,
                    SSK_STATUE,
					STATUE_TYPE,
                    PROJECT_ID
				FROM
                    SETUP_PAYMENT_INTERRUPTION
				WHERE
					PAY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.odkes_id#">
            </cfquery>
        <cfreturn 1>
    </cffunction>
</cfcomponent>