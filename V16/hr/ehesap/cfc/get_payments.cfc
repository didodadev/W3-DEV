<!---
File : get_payments.cfc
Author : Workcube-Esma Uysal <esmauysal@workcube.com>
Date : 02.10.2019
Description : Çalışana bağlı ek ödenek fonksiyonlarını içerir.
--->
<cfcomponent>
    <cfset dsn = application.systemParam.systemParam().dsn>
    <cffunction name="get_payments" access="public" returntype="query">
    <cfargument name="term"  default=""><!--- Yıl --->
    <cfargument name="start_sal_mon"  default=""><!--- Başlangıç Ay --->
    <cfargument name="end_sal_mon"  default=""><!--- Bitiş Ay --->
    <cfargument name="collar_type"  default=""><!--- Yaka Tipi --->
    <cfargument name="pos_cat_id"  default=""><!--- Pozisyon Tipi --->
    <cfargument name="branch_id"  default=""><!--- Şube --->
    <cfargument name="department_id"  default=""><!--- Departman --->
    <cfargument name="duty_type"  default=""><!--- Görev Tipi --->
    <cfargument name="func_id"  default=""><!--- Fonksiyon --->
    <cfargument name="title_id"  default=""><!--- Ünvan --->
    <cfargument name="odkes_id"  default=""><!--- Ödenek türü --->
    <cfargument name="bonus_id"  default=""><!--- Belge id --->

    
    <cfquery name="get_payments" datasource="#DSN#">
        SELECT	
            SG.TERM, 
            SG.SHOW,
            SG.SPP_ID,
            PERIOD_PAY,
            METHOD_PAY,
            AMOUNT_PAY,
            COMMENT_PAY, 
            END_SAL_MON,
            B.BRANCH_NAME,
            E.EMPLOYEE_ID,
            SG.PROJECT_ID,
            E.EMPLOYEE_NO,    
            START_SAL_MON, 
            EIO.IN_OUT_ID, 
            COMMENT_PAY_ID, 
            EIO.START_DATE,
            EP.COLLAR_TYPE,
            EIO.FINISH_DATE, 
            ED.TC_IDENTY_NO,                                     
            E.EMPLOYEE_NAME,
            EP.POSITION_NAME,
            D.DEPARTMENT_HEAD,
            SG.PROCESS_STAGE,
            EIO.DEPARTMENT_ID,
            EP.POSITION_CAT_ID,
            E.EMPLOYEE_SURNAME,
            E.EMPLOYEE_NAME + ' ' + E.EMPLOYEE_SURNAME AS EMPLOYEE
        FROM
            SALARYPARAM_PAY SG 
            INNER JOIN EMPLOYEES_IN_OUT EIO ON SG.IN_OUT_ID = EIO.IN_OUT_ID 
            INNER JOIN EMPLOYEES E ON E.EMPLOYEE_ID = EIO.EMPLOYEE_ID 
            LEFT JOIN EMPLOYEES_IDENTY ED ON ED.EMPLOYEE_ID = E.EMPLOYEE_ID
            INNER JOIN BRANCH B ON EIO.BRANCH_ID = B.BRANCH_ID
            LEFT JOIN DEPARTMENT D ON EIO.DEPARTMENT_ID = D.DEPARTMENT_ID
            LEFT JOIN EMPLOYEE_POSITIONS EP ON (E.EMPLOYEE_ID = EP.EMPLOYEE_ID AND EP.IS_MASTER = 1)
        WHERE
            1 = 1
            <cfif isdefined("arguments.term") and len(arguments.term)>
                and SG.TERM = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.term#">		
            </cfif>
            <cfif len(arguments.start_sal_mon) and arguments.start_sal_mon lte arguments.end_sal_mon>
                AND
                ( 
                    (
                        START_SAL_MON <= <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.start_sal_mon#"> AND 
                        END_SAL_MON > = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.start_sal_mon#">
                    )
                    OR
                    (
                        END_SAL_MON >= <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.start_sal_mon#"> AND 
                        END_SAL_MON <= <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.end_sal_mon#">
                    )
                    OR
                    (	
                        END_SAL_MON = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.start_sal_mon#"> OR 
                        END_SAL_MON = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.end_sal_mon#"> OR 
                        START_SAL_MON = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.start_sal_mon#"> OR 
                        START_SAL_MON = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.end_sal_mon#">
                    )
                )
            <cfelseif not len(arguments.bonus_id)>
                and START_SAL_MON IS NULL
            </cfif>
            <cfif isdefined("arguments.collar_type") and len(arguments.collar_type)>
                AND EP.COLLAR_TYPE IN (<cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.collar_type#" list = "yes">)
            </cfif>
            <cfif isdefined("arguments.pos_cat_id") and len(arguments.pos_cat_id)>
                AND EP.POSITION_CAT_ID IN (<cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.pos_cat_id#" list = "yes">)
            </cfif>
            <cfif isdefined("arguments.branch_id") and len(arguments.branch_id)>
                AND EIO.BRANCH_ID IN (<cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.branch_id#" list = "yes">)	
            </cfif>
            <cfif isdefined("arguments.department_id") and len(arguments.department_id)>
                AND EIO.DEPARTMENT_ID IN (<cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.department_id#" list = "yes">)
            </cfif>
            <cfif isdefined("arguments.duty_type") and len(arguments.duty_type)>
                AND EIO.DUTY_TYPE IN (<cfqueryparam cfsqltype="cf_sql_integer" list = "yes" value="#arguments.duty_type#">)
            </cfif>
            <cfif isdefined("arguments.func_id") and len(arguments.func_id)>
                AND EP.FUNC_ID IN (<cfqueryparam cfsqltype="cf_sql_integer" list = "yes" value="#arguments.func_id#">) 
            </cfif>
            <cfif isdefined("arguments.title_id") and len(arguments.title_id)>
                AND EP.TITLE_ID IN (<cfqueryparam cfsqltype="cf_sql_integer" list = "yes" value="#arguments.title_id#">) 
            </cfif>
            <cfif isdefined("arguments.odkes_id") and len(arguments.odkes_id)>
                AND COMMENT_PAY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.odkes_id#">
            </cfif>
            <cfif isdefined("arguments.bonus_id") and len(arguments.bonus_id)>
                AND BONUS_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.bonus_id#">
            </cfif>
        ORDER BY
            E.EMPLOYEE_NAME,
            E.EMPLOYEE_SURNAME
    </cfquery>
    <cfreturn get_payments>
    </cffunction>
    <cffunction name="SETUP_PAYMENT_INTERRUPTION" access="public" returntype="query">
        <cfargument name="odkes_id"  default=""><!--- Ödenek türü --->
        <cfquery name="SETUP_PAYMENT_INTERRUPTION" datasource="#DSN#">
            SELECT
                * 
            FROM 
                SETUP_PAYMENT_INTERRUPTION
            WHERE
                1 = 1
                <cfif isdefined("arguments.odkes_id") and len(arguments.odkes_id)>
                    AND ODKES_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.odkes_id#">
                </cfif>
        </cfquery>
        <cfreturn SETUP_PAYMENT_INTERRUPTION>
    </cffunction>
    <cffunction name="GET_BONUS_PAYROLL" access="public" returntype="query">
        <cfargument name="start_mon"  default=""><!--- Başlangıç Ay --->
        <cfargument name="end_mon"  default=""><!--- Bitiş Ay --->
        <cfargument name="bonus_id"  default=""><!--- Belge id --->
        <cfargument name="keyword"  default=""><!--- Keyword --->
        <cfquery name="GET_BONUS_PAYROLL" datasource="#DSN#">
            SELECT	
                *
            FROM
                BONUS_PAYROLL BP 
            WHERE
                1 = 1
                <cfif len(arguments.start_mon) and arguments.start_mon lte arguments.end_mon>
                    AND
                    ( 
                        (
                            START_SAL_MON <= <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.start_mon#"> AND 
                            END_SAL_MON > = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.start_mon#">
                        )
                        OR
                        (
                            END_SAL_MON >= <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.start_mon#"> AND 
                            END_SAL_MON <= <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.end_mon#">
                        )
                        OR
                        (	
                            END_SAL_MON = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.start_mon#"> OR 
                            END_SAL_MON = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.end_mon#"> OR 
                            START_SAL_MON = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.start_mon#"> OR 
                            START_SAL_MON = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.end_mon#">
                        )
                    )
                </cfif>
                <cfif len(arguments.bonus_id)> 
                    AND BONUS_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.bonus_id#">
                </cfif>
                <cfif len(arguments.keyword)> 
                    AND PAPER_NO LIKE <cfqueryparam cfsqltype="cf_sql_nvarchar" value="%#arguments.keyword#%">
                </cfif>
            ORDER BY
                BONUS_ID
        </cfquery>
        <cfreturn GET_BONUS_PAYROLL>
    </cffunction>
    
    <cffunction name="get_project" access="public" returntype="query">
        <cfargument name="project_id"  default="">
        <cfquery name="get_project" datasource="#dsn#">
            SELECT PROJECT_HEAD FROM PRO_PROJECTS WHERE PROJECT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.project_id#">
        </cfquery>
        <cfreturn get_project>
    </cffunction>

    <cffunction  name="DELETE_SALARYPARAM_PAY" access="public"  returntype="any"><!--- Puantajı oluşturulmu mu?--->
        <cfargument name = "action_list_id" default = ""><!--- Belge Puantaj Id --->
        <cfquery name="del_pay" datasource="#DSN#">
            DELETE FROM SALARYPARAM_PAY WHERE SPP_ID IN (<cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.action_list_id#" list="yes">)
        </cfquery>
        <cfreturn 1>
    </cffunction>
</cfcomponent>