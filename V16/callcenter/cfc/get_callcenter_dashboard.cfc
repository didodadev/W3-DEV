
<cfcomponent>
    <cfset dsn = application.systemParam.systemParam().dsn>
    <cfset dsn3 = "#dsn#_#session.ep.company_id#">
    <cffunction name="GetCompany" access="public">
        <cfargument name="startdate" default="">
        <cfargument name="finishdate" default="">
        <cfargument name="service_branch_id" default="">
        <cfargument name="workgroup_id" default="">
        
        <cfquery name="get_company" datasource="#dsn#">
            SELECT 
                TOP 20
                COMPANY.FULLNAME, 
                COUNT(COMPANY.COMPANY_ID) AS TOTAL       
            FROM 
                COMPANY
            LEFT JOIN 
                G_SERVICE  ON COMPANY.COMPANY_ID = SERVICE_COMPANY_ID 
            WHERE 
                G_SERVICE.APPLY_DATE between <cfqueryparam cfsqltype="cf_sql_date" value="#arguments.startdate#"> and <cfqueryparam cfsqltype="cf_sql_date" value="#dateadd('d',1,arguments.finishdate)#"> 
                <cfif len(arguments.service_branch_id)>
                    AND G_SERVICE.SERVICE_BRANCH_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.service_branch_id#">
                </cfif>
                <cfif len(arguments.workgroup_id)>
                    AND G_SERVICE.RESP_EMP_ID IN (SELECT EMPLOYEE_ID FROM WORKGROUP_EMP_PAR WHERE WORKGROUP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.workgroup_id#">)
                </cfif>
            GROUP BY 
               COMPANY.FULLNAME
            ORDER BY
               TOTAL DESC                   
        </cfquery>  
        <cfreturn get_company>
    </cffunction>
    <cffunction name="GetProject" access="public" >
        <cfargument name="startdate" default="">
        <cfargument name="finishdate" default="">
        <cfargument name="service_branch_id" default="">
        <cfargument name="workgroup_id" default="">

        <cfquery name="get_project" datasource="#dsn#">
            SELECT 
                TOP 20
                ISNULL(PRO_PROJECTS.PROJECT_HEAD,  'Isimsiz projeler') PROJECT_HEAD,
                COUNT(GS.SERVICE_ID) AS TOTAL 
            FROM 
                PRO_PROJECTS WITH (nolock)
            RIGHT JOIN 
                G_SERVICE GS ON PRO_PROJECTS.PROJECT_ID = GS.PROJECT_ID,
                G_SERVICE_APPCAT SERVICE_APPCAT,
                SETUP_PRIORITY SP,
                PROCESS_TYPE_ROWS PTR
            WHERE 
                GS.SERVICE_STATUS_ID = PTR.PROCESS_ROW_ID 
                AND SP.PRIORITY_ID = GS.PRIORITY_ID
                AND GS.SERVICECAT_ID = SERVICE_APPCAT.SERVICECAT_ID
                AND GS.APPLY_DATE between <cfqueryparam cfsqltype="cf_sql_date" value="#arguments.startdate#"> and <cfqueryparam cfsqltype="cf_sql_date" value="#dateadd('d',1,arguments.finishdate)#"> 
                <cfif len(arguments.service_branch_id)>
                    AND GS.SERVICE_BRANCH_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.service_branch_id#">
                </cfif>
                <cfif len(arguments.workgroup_id)>
                    AND GS.RESP_EMP_ID IN (SELECT EMPLOYEE_ID FROM WORKGROUP_EMP_PAR WHERE WORKGROUP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.workgroup_id#">)
                </cfif>
            GROUP BY 
                PRO_PROJECTS.PROJECT_ID,PRO_PROJECTS.PROJECT_HEAD
            ORDER BY
                TOTAL DESC          	 
       </cfquery>  
       <cfreturn get_project> 
    </cffunction>
    <cffunction name="GetCategory" access="public" >
        <cfargument name="startdate" default="">
        <cfargument name="finishdate" default="">
        <cfargument name="service_branch_id" default="">
        <cfargument name="workgroup_id" default="">

        <cfquery name="get_category" datasource="#dsn#">
            SELECT
                CAT.SERVICECAT,
                COUNT(GS.SERVICE_ID) AS TOTAL
            FROM 
                G_SERVICE GS WITH (nolock)
            LEFT JOIN 
                G_SERVICE_APPCAT CAT ON CAT.SERVICECAT_ID = GS.SERVICECAT_ID,
                SETUP_PRIORITY SP,
                PROCESS_TYPE_ROWS PTR
            WHERE 
                GS.SERVICE_STATUS_ID = PTR.PROCESS_ROW_ID 
                AND SP.PRIORITY_ID = GS.PRIORITY_ID
                AND GS.APPLY_DATE between <cfqueryparam cfsqltype="cf_sql_date" value="#arguments.startdate#"> and <cfqueryparam cfsqltype="cf_sql_date" value="#dateadd('d',1,arguments.finishdate)#"> 
                <cfif len(arguments.service_branch_id)>
                    AND GS.SERVICE_BRANCH_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.service_branch_id#">
                </cfif>
                <cfif len(arguments.workgroup_id)>
                    AND GS.RESP_EMP_ID IN (SELECT EMPLOYEE_ID FROM WORKGROUP_EMP_PAR WHERE WORKGROUP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.workgroup_id#">)
                </cfif>
            GROUP BY
               CAT.SERVICECAT,CAT.SERVICECAT_ID
            ORDER BY
               CAT.SERVICECAT             	 
       </cfquery>  
       <cfreturn get_category> 
    </cffunction>
    <cffunction name="GetStage" access="public" >
        <cfargument name="startdate" default="">
        <cfargument name="finishdate" default="">
        <cfargument name="service_branch_id" default="">
        <cfargument name="workgroup_id" default="">
        <cfquery name="get_stage" datasource="#dsn#">
            SELECT
                STAGE,
                COUNT(GS.SERVICE_ID) TOTAL
            FROM
                PROCESS_TYPE_ROWS PTR,
                G_SERVICE GS,
                SETUP_PRIORITY SP
            WHERE
                GS.SERVICE_STATUS_ID = PTR.PROCESS_ROW_ID 
                AND SP.PRIORITY_ID = GS.PRIORITY_ID
                AND GS.APPLY_DATE BETWEEN <cfqueryparam cfsqltype="cf_sql_date" value="#arguments.startdate#"> AND <cfqueryparam cfsqltype="cf_sql_date" value="#dateadd('d',1,arguments.finishdate)#"> 
                <cfif len(arguments.service_branch_id)>
                    AND GS.SERVICE_BRANCH_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.service_branch_id#">
                </cfif>
                <cfif len(arguments.workgroup_id)>
                    AND GS.RESP_EMP_ID IN (SELECT EMPLOYEE_ID FROM WORKGROUP_EMP_PAR WHERE WORKGROUP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.workgroup_id#">)
                </cfif>
            GROUP BY
                STAGE   	 
        </cfquery>
        <cfreturn get_stage> 
    </cffunction>
    <cffunction name="GetEmployee" access="public" >
        <cfargument name="startdate" default="">
        <cfargument name="finishdate" default="">
        <cfargument name="isactive" default="">
        <cfargument name="service_branch_id" default="">
        <cfargument name="workgroup_id" default="">

        <cfquery name="get_employee" datasource="#dsn#">
            SELECT
                ISNULL( T1.USER_, 'Atanmayanlar') USER_, 
                COUNT(GS.SERVICE_ID) TOTAL,
                SUM(CONVERT(INT, t1.WORK_STATUS)) as aktifler
            FROM 
                 G_SERVICE GS 
            JOIN
                (SELECT
                   E.EMPLOYEE_NAME + ' ' + E.EMPLOYEE_SURNAME  USER_, PW.G_SERVICE_ID,pw.WORK_STATUS
                FROM 
                   EMPLOYEES E, PRO_WORKS PW 
                WHERE 
                   E.EMPLOYEE_ID =PW.PROJECT_EMP_ID ) T1
                   ON T1.G_SERVICE_ID = GS.SERVICE_ID  
                AND
                    GS.APPLY_DATE between <cfqueryparam cfsqltype="cf_sql_date" value="#arguments.startdate#"> and <cfqueryparam cfsqltype="cf_sql_date" value="#dateadd('d',1,arguments.finishdate)#"> 
                <cfif len(arguments.service_branch_id)>
                    AND GS.SERVICE_BRANCH_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.service_branch_id#">
                </cfif>
                <cfif len(arguments.workgroup_id)>
                    AND GS.RESP_EMP_ID IN (SELECT EMPLOYEE_ID FROM WORKGROUP_EMP_PAR WHERE WORKGROUP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.workgroup_id#">)
                </cfif>
                GROUP BY T1.USER_ 
                ORDER BY TOTAL DESC  
       </cfquery>  
       <cfreturn get_employee> 
    </cffunction>
    <cffunction name="GetEmployeeResp" access="public" >
        <cfargument name="startdate" default="">
        <cfargument name="finishdate" default="">
        <cfargument name="isactive" default="">
        <cfargument name="service_branch_id" default="">
        <cfargument name="workgroup_id" default="">

        <cfquery name="get_employee_resp" datasource="#dsn#">
            SELECT
                COUNT(GS.SERVICE_ID) TOTAL,
                SUM(CONVERT(INT, GS.SERVICE_ACTIVE)) as aktifler,
                GS.RESP_EMP_ID,
                GS.RESP_CONS_ID,
                GS.RESP_PAR_ID
            FROM 
                 G_SERVICE GS 
            WHERE
                GS.APPLY_DATE between <cfqueryparam cfsqltype="cf_sql_date" value="#arguments.startdate#"> and <cfqueryparam cfsqltype="cf_sql_date" value="#dateadd('d',1,arguments.finishdate)#"> 
                <cfif len(arguments.service_branch_id)>
                    AND GS.SERVICE_BRANCH_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.service_branch_id#">
                </cfif>
                <cfif len(arguments.workgroup_id)>
                    AND GS.RESP_EMP_ID IN (SELECT EMPLOYEE_ID FROM WORKGROUP_EMP_PAR WHERE WORKGROUP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.workgroup_id#">)
                </cfif>
            GROUP BY 
                GS.RESP_EMP_ID,
                GS.RESP_CONS_ID,
                GS.RESP_PAR_ID
            ORDER BY TOTAL DESC  
       </cfquery>  
       <cfreturn get_employee_resp> 
    </cffunction>
    <cffunction name="GetTimespentStage" access="public" returntype="query" >
        <cfargument name="startdate" default="">
        <cfargument name="finishdate" default="#getdate()#">
        <cfargument name="service_branch_id" default="">
        <cfargument name="workgroup_id" default="">

        <cfquery name="get_timespent_stage" datasource="#dsn#">
            SELECT
                DATEDIFF(HOUR,APPLY_DATE,ISNULL(FINISH_DATE,getdate())) AS HarcananZaman
            FROM
                G_SERVICE, PROCESS_TYPE_ROWS 
            WHERE
                G_SERVICE.SERVICE_STATUS_ID = PROCESS_TYPE_ROWS.PROCESS_ROW_ID  
                AND G_SERVICE.APPLY_DATE between <cfqueryparam cfsqltype="cf_sql_date" value="#arguments.startdate#"> 
                AND <cfqueryparam cfsqltype="cf_sql_date" value="#dateadd('d',1,arguments.finishdate)#"> 
                <cfif len(arguments.service_branch_id)>
                    AND G_SERVICE.SERVICE_BRANCH_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.service_branch_id#">
                </cfif>
                <cfif len(arguments.workgroup_id)>
                    AND G_SERVICE.RESP_EMP_ID IN (SELECT EMPLOYEE_ID FROM WORKGROUP_EMP_PAR WHERE WORKGROUP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.workgroup_id#">)
                </cfif>
       </cfquery>  
       <cfreturn get_timespent_stage> 
    </cffunction>
    <cffunction name="GetTimespentCategory" access="public" returntype="query" >
        <cfargument name="startdate" default="">
        <cfargument name="finishdate" default="#getdate()#">
        <cfargument name="service_branch_id" default="">
        <cfargument name="workgroup_id" default="">

        <cfquery name="get_timespent_category" datasource="#dsn#">
            SELECT
                CAT.SERVICECAT,
                DATEDIFF(HOUR,APPLY_DATE,ISNULL(FINISH_DATE,getdate())) AS HarcananZaman
            FROM 
                G_SERVICE GS
        
            LEFT JOIN 
                G_SERVICE_APPCAT CAT ON CAT.SERVICECAT_ID = GS.SERVICECAT_ID
            WHERE 
                GS.APPLY_DATE between <cfqueryparam cfsqltype="cf_sql_date" value="#arguments.startdate#"> and <cfqueryparam cfsqltype="cf_sql_date" value="#dateadd('d',1,arguments.finishdate)#"> 
                <cfif len(arguments.service_branch_id)>
                    AND GS.SERVICE_BRANCH_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.service_branch_id#">
                </cfif>
                <cfif len(arguments.workgroup_id)>
                    AND GS.RESP_EMP_ID IN (SELECT EMPLOYEE_ID FROM WORKGROUP_EMP_PAR WHERE WORKGROUP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.workgroup_id#">)
                </cfif>
       </cfquery>  
       <cfreturn get_timespent_category> 
    </cffunction> 
</cfcomponent>


