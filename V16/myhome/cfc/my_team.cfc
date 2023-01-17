<cfcomponent extends="cfc.faFunctions">
<cfset dsn = application.systemParam.systemParam().dsn>
<cfset dsn2 = '#dsn#_#session.ep.period_year#_#session.ep.company_id#'>
<cfset dsn3 = '#dsn#_#session.ep.company_id#'>

<cffunction name="get_team" access="public" returntype="query">
    <cfargument name="position_code" default="">
    <cfquery name="get_team" datasource="#dsn#">
        SELECT
            DEPARTMENT_ID,
            DEPARTMENT_HEAD
        FROM 
            DEPARTMENT
        WHERE
            ADMIN1_POSITION_CODE = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.position_code#">
            OR 
            ADMIN2_POSITION_CODE = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.position_code#">
    </cfquery>
    <cfreturn get_team>
</cffunction>
<cffunction name="get_department" access="public" returntype="query">
    <cfargument name="position_code" default="">
    <cfquery name="get_department" datasource="#dsn#">
        SELECT
            D.DEPARTMENT_ID,
            D.DEPARTMENT_HEAD,
            B.BRANCH_NAME,
            OC.NICK_NAME
        FROM 
            EMPLOYEE_POSITIONS EP 
            INNER JOIN DEPARTMENT D ON EP.DEPARTMENT_ID = D.DEPARTMENT_ID 
            INNER JOIN BRANCH B ON D.BRANCH_ID = B.BRANCH_ID
            INNER JOIN OUR_COMPANY OC ON B.COMPANY_ID = OC.COMP_ID
        WHERE
            EP.POSITION_CODE = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.position_code#">
    </cfquery>
    <cfreturn get_department>
</cffunction>
<!--- Gelen Pozisyon Id'nin altındaki pozisyon listesidir. Esma R. Uysal ---->
<cffunction name="get_positions" access="public" returntype="void" output="true">
    <cfargument name="position_code" default="">

    <cfquery name="LOCAL.Children"  datasource="#dsn#">
		SELECT
            *,
            (SELECT   
                CASE 
                    WHEN E.PHOTO IS NOT NULL AND LEN(E.PHOTO) > 0 
                        THEN '/documents/hr/'+E.PHOTO 
                    WHEN E.PHOTO IS NULL AND ED.SEX = 0
                        THEN  '/images/female.jpg'
                ELSE '/images/male.jpg' END AS AA
            FROM 
                EMPLOYEES E,
                EMPLOYEES_DETAIL ED
            WHERE  
                E.EMPLOYEE_ID =   EMPLOYEE_POSITIONS.EMPLOYEE_ID
                AND ED.EMPLOYEE_ID = E.EMPLOYEE_ID
            ) AS PHOTO
        FROM
            EMPLOYEE_POSITIONS
        WHERE
            EMPLOYEE_ID <> 0
            AND
            (
                UPPER_POSITION_CODE = <cfqueryparam value = "#arguments.position_code#" CFSQLType = "cf_sql_integer">
                OR
                UPPER_POSITION_CODE2 = <cfqueryparam value = "#arguments.position_code#" CFSQLType = "cf_sql_integer">
            )

        ORDER BY
            EMPLOYEE_NAME,
            EMPLOYEE_SURNAME
	</cfquery>

	<cfif LOCAL.Children.RecordCount>
		<ul>
			<cfloop query="LOCAL.Children">
				<li>
					#LOCAL.Children.EMPLOYEE_NAME# #LOCAL.Children.EMPLOYEE_SURNAME#
					<cfset get_positions(
						position_code = LOCAL.Children.position_code
						) />
				</li>
			</cfloop>
		</ul>
	</cfif>
	<cfreturn>
</cffunction>
<!---- Gönderilen Pozisyon Id'nin 1. e 2. amiri olduğuM benim departmanımdaki pozisyonlar Esma R. Uysal ---->
<cffunction name="get_positions_upper" access="public" returntype="query" output="true">
    <cfargument name="position_code" default="">
    <cfargument name="department_id" default="">
    <cfquery name="get_positions_upper"  datasource="#dsn#">
		SELECT
            *
        FROM
            EMPLOYEE_POSITIONS
        WHERE
            EMPLOYEE_ID <> 0
            AND
            (
                UPPER_POSITION_CODE = <cfqueryparam value = "#arguments.position_code#" CFSQLType = "cf_sql_integer">
                OR
                UPPER_POSITION_CODE2 = <cfqueryparam value = "#arguments.position_code#" CFSQLType = "cf_sql_integer">
            )
            AND DEPARTMENT_ID  IN (<cfqueryparam value="#arguments.department_id#" cfsqltype="cf_sql_integer" list = "yes" >) 
	</cfquery>
	<cfreturn get_positions_upper>
</cffunction>
<!---- Gönderilen pozisyon kodunun yöneticisi olduğu Departmanlar ---->
<cffunction name="get_position_department" access="public" returntype="query" output="true">
    <cfargument name="position_code" default="">
    <cfquery name="get_position_department"  datasource="#dsn#">
		SELECT 
            * 
        FROM 
            DEPARTMENT D
                INNER JOIN EMPLOYEE_POSITIONS EP ON EP.DEPARTMENT_ID = D.DEPARTMENT_ID
                INNER JOIN EMPLOYEES E ON E.EMPLOYEE_ID = EP.EMPLOYEE_ID
        WHERE 
            (
                ADMIN1_POSITION_CODE = <cfqueryparam value = "#arguments.position_code#" CFSQLType = "cf_sql_integer">
                OR
                ADMIN2_POSITION_CODE = <cfqueryparam value = "#arguments.position_code#" CFSQLType = "cf_sql_integer">
            )
            AND POSITION_STATUS = 1
            AND EP.EMPLOYEE_ID <> 0
            AND E.EMPLOYEE_STATUS = 1
            AND D.DEPARTMENT_STATUS = 1
	</cfquery>
	<cfreturn get_position_department>
</cffunction>
<!--- İzinler --->
<cffunction name="get_offtimes" access="public" returntype="query">
    <cfargument name="department_id">
    <cfquery name="get_offtimes" datasource="#DSN#">
        SELECT
            *,
                CASE 
                    WHEN E.PHOTO IS NOT NULL AND LEN(E.PHOTO) > 0 
                        THEN '/documents/hr/'+E.PHOTO 
                    WHEN E.PHOTO IS NULL AND ED.SEX = 0
                        THEN  '/images/female.jpg'
                ELSE '/images/male.jpg' END AS PHOTOS
        FROM
            EMPLOYEE_POSITIONS EP 
			INNER JOIN OFFTIME O ON O.EMPLOYEE_ID = EP.EMPLOYEE_ID 
            INNER JOIN EMPLOYEES E ON E.EMPLOYEE_ID = EP.EMPLOYEE_ID
            INNER JOIN EMPLOYEES_DETAIL ED ON ED.EMPLOYEE_ID = E.EMPLOYEE_ID
        WHERE
            EP.DEPARTMENT_ID  IN (<cfqueryparam value="#arguments.department_id#" cfsqltype="cf_sql_integer" list = "yes" >) 
            AND
            (
                (
                O.STARTDATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#"> AND
                O.STARTDATE < <cfqueryparam cfsqltype="cf_sql_timestamp" value="#DATEADD("d",1,now())#">
                )
            OR
                (
                O.STARTDATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#"> AND
                O.FINISHDATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">
                )
            )
            AND EP.POSITION_STATUS = 1
            AND EP.EMPLOYEE_ID <> 0
            AND E.EMPLOYEE_STATUS = 1
        ORDER BY
            O.STARTDATE DESC
    </cfquery>
    <cfreturn get_offtimes>
</cffunction>
<!--- Eğitimdekiler ---->
<cffunction name="get_training" access="public" returntype="query">
    <cfargument name="employee_ids">
    <cfquery name="get_training" datasource="#DSN#">
        SELECT
            *,
            CASE 
                WHEN E.PHOTO IS NOT NULL AND LEN(E.PHOTO) > 0 
                    THEN '/documents/hr/'+E.PHOTO 
                WHEN E.PHOTO IS NULL AND ED.SEX = 0
                    THEN  '/images/female.jpg'
            ELSE '/images/male.jpg' END AS PHOTOS
        FROM
            TRAINING_CLASS TC
			INNER JOIN TRAINING_CLASS_ATTENDER TCA ON TCA.CLASS_ID = TC.CLASS_ID 
            INNER JOIN EMPLOYEES E ON E.EMPLOYEE_ID = TCA.EMP_ID
            INNER JOIN EMPLOYEES_DETAIL ED ON ED.EMPLOYEE_ID = E.EMPLOYEE_ID
        WHERE
            TCA.EMP_ID  IN (<cfqueryparam value="#arguments.employee_ids#" cfsqltype="cf_sql_integer" list = "yes" >) 
            AND
            (
                (
                TC.START_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#"> AND
                TC.START_DATE < <cfqueryparam cfsqltype="cf_sql_timestamp" value="#DATEADD("d",1,now())#">
                )
            OR
                (
                TC.START_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#"> AND
                TC.FINISH_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">
                )
            )
            AND E.EMPLOYEE_STATUS = 1
        ORDER BY
            TC.START_DATE DESC
    </cfquery>
    <cfreturn get_training>
</cffunction>
<!---- Online kullanıcılar ---->
<cffunction name="get_online_user" access="public" returntype="query" output="true">
    <cfargument name="employee_ids" default="">
    <cfquery name="get_online_user"  datasource="#dsn#">
		SELECT DISTINCT USERID FROM  WRK_SESSION where USERID IN (<cfqueryparam value="#arguments.employee_ids#" cfsqltype="cf_sql_integer" list = "yes" >)
	</cfquery>
	<cfreturn get_online_user>
</cffunction>

<cffunction name="get_my_budget" access="public" returntype="query" hint="Planlanan - Gerçekleşen - Revize Edilen Bütçe Durumları">
    <cfquery name="get_hierarcy" datasource="#dsn2#">
        SELECT 
            D.HIERARCHY_DEP_ID ,
            D.BRANCH_ID,
            EP.EMPLOYEE_ID
        FROM 
            #dsn#.DEPARTMENT D,
            #dsn#.EMPLOYEE_POSITIONS EP 
        WHERE 
            EP.DEPARTMENT_ID = D.DEPARTMENT_ID
            AND POSITION_CODE = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.position_code#">
    </cfquery>
    <cfif get_hierarcy.recordcount and listlen(get_hierarcy.HIERARCHY_DEP_ID,'.') gt 1>
        <cfset hierarcy_id_list = valuelist(get_hierarcy.HIERARCHY_DEP_ID,',')>
        <cfset up_dep=ListGetAt(hierarcy_id_list,evaluate("#listlen(hierarcy_id_list,".")#-1"),".") >	
    </cfif>
    <cfquery name="GET_EXPENSE_BUDGET" datasource="#dsn2#">
        WITH CTE1 AS
        (
            SELECT      
                GEC.EXPENSE_ITEM_ID,
                GEC.EXPENSE_ITEM_NAME,
                GEC.EXPENSE_ID,
                GEC.EXPENSE,
                ISNULL(ROW_TOTAL_INCOME,0) ROW_TOTAL_INCOME,
                ISNULL(ROW_TOTAL_INCOME_2,0) ROW_TOTAL_INCOME_2,
                ISNULL(ROW_TOTAL_EXPENSE,0) ROW_TOTAL_EXPENSE,
                ISNULL(ROW_TOTAL_EXPENSE_2,0) ROW_TOTAL_EXPENSE_2,
                ISNULL(TOTAL_AMOUNT_BORC,0) AS TOTAL_AMOUNT_BORC,
                ISNULL(TOTAL_AMOUNT_2_BORC,0) AS TOTAL_AMOUNT_BORC_2,
                ISNULL(REZ_TOTAL_AMOUNT_BORC,0) AS REZ_TOTAL_AMOUNT_BORC,
                ISNULL(REZ_TOTAL_AMOUNT_2_BORC,0) AS REZ_TOTAL_AMOUNT_2_BORC,
                ISNULL(REZ_TOTAL_AMOUNT_ALACAK,0) AS REZ_TOTAL_AMOUNT_ALACAK,
                ISNULL(REZ_TOTAL_AMOUNT_2_ALACAK,0) AS REZ_TOTAL_AMOUNT_2_ALACAK,
                ISNULL(TOTAL_AMOUNT_ALACAK,0)  AS TOTAL_AMOUNT_ALACAK,
                ISNULL(TOTAL_AMOUNT_2_ALACAK,0) AS TOTAL_AMOUNT_ALACAK_2
            FROM
                (
                    SELECT        
                        EI.EXPENSE_ITEM_ID,
                        EI.EXPENSE_ITEM_NAME,
                        ECEN.EXPENSE_ID,
                        ECEN.EXPENSE
                    FROM                
                        EXPENSE_ITEMS AS EI,
                        EXPENSE_CENTER AS ECEN   
                    WHERE 
                         (EXPENSE_BRANCH_ID IN (SELECT EP.BRANCH_ID FROM #dsn#.EMPLOYEE_POSITION_BRANCHES EP WHERE EP.POSITION_CODE = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.position_code#">) OR (EXPENSE_BRANCH_ID = -1))
                            <cfif get_hierarcy.recordcount and listlen(get_hierarcy.HIERARCHY_DEP_ID,'.') gt 1>
                                AND (EXPENSE_DEPARTMENT_ID IN 
                                    (	
                                        SELECT EP.DEPARTMENT_ID FROM #dsn#.EMPLOYEE_POSITIONS EP WHERE EP.POSITION_CODE = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.position_code#">
                                        UNION ALL 
                                            SELECT 
                                                DEPARTMENT_ID 
                                            FROM
                                                #dsn#.DEPARTMENT
                                            WHERE 
                                                DEPARTMENT_ID = #up_dep#
                                    ) 
                                    OR ( EXPENSE_DEPARTMENT_ID = -1)
                                    )
                            </cfif>
                    GROUP BY            
                        EI.EXPENSE_ITEM_ID,
                        EI.EXPENSE_ITEM_NAME,
                        ECEN.EXPENSE_ID,
                        ECEN.EXPENSE
                ) AS GEC 
            JOIN 
            (
                SELECT 
                    ISNULL(SUM(BUDGET_PLAN_ROW.ROW_TOTAL_EXPENSE),0) ROW_TOTAL_EXPENSE,
                    ISNULL(SUM(BUDGET_PLAN_ROW.ROW_TOTAL_EXPENSE_2),0) ROW_TOTAL_EXPENSE_2,
                    ISNULL(SUM(BUDGET_PLAN_ROW.ROW_TOTAL_INCOME),0) ROW_TOTAL_INCOME,
                    ISNULL(SUM(BUDGET_PLAN_ROW.ROW_TOTAL_INCOME_2),0) ROW_TOTAL_INCOME_2,
                    BUDGET_PLAN_ROW.BUDGET_ITEM_ID,
                    BUDGET_PLAN_ROW.EXP_INC_CENTER_ID
                FROM
                    #dsn#.BUDGET_PLAN,
                    #dsn#.BUDGET_PLAN_ROW 
                WHERE 
                    BUDGET_PLAN.PROCESS_TYPE <> 161 AND 
                    BUDGET_PLAN.BUDGET_PLAN_ID = BUDGET_PLAN_ROW.BUDGET_PLAN_ID 
                GROUP BY
                    BUDGET_PLAN_ROW.BUDGET_ITEM_ID,
                    BUDGET_PLAN_ROW.EXP_INC_CENTER_ID  
            ) AS PLANLANAN
        ON PLANLANAN.BUDGET_ITEM_ID = GEC.EXPENSE_ITEM_ID AND PLANLANAN.EXP_INC_CENTER_ID = GEC.EXPENSE_ID
        LEFT JOIN
            (
                SELECT
                    SUM(CASE WHEN IS_INCOME = 0 THEN TOTAL_AMOUNT ELSE 0 END) AS TOTAL_AMOUNT_BORC,
                    SUM(CASE WHEN IS_INCOME = 0 THEN TOTAL_AMOUNT_2 ELSE 0 END) AS TOTAL_AMOUNT_2_BORC,
                    SUM(CASE WHEN IS_INCOME = 1 THEN TOTAL_AMOUNT ELSE 0 END) AS  TOTAL_AMOUNT_ALACAK,
                    SUM( CASE WHEN IS_INCOME = 1 THEN TOTAL_AMOUNT_2 ELSE 0 END) TOTAL_AMOUNT_2_ALACAK,
                    EXPENSE_ITEM_ID,
                    EXPENSE_CENTER_ID          
                FROM
                (
                    SELECT 
                        EXPENSE_ITEMS_ROWS.TOTAL_AMOUNT TOTAL_AMOUNT,
                        EXPENSE_ITEMS_ROWS.OTHER_MONEY_VALUE_2 TOTAL_AMOUNT_2,
                        EXPENSE_ITEMS_ROWS.IS_INCOME,
                        EXPENSE_ITEMS_ROWS.EXPENSE_ITEM_ID,
                        EXPENSE_ITEMS_ROWS.ACTIVITY_TYPE,
                        EXPENSE_ITEMS_ROWS.EXPENSE_CENTER_ID
                    FROM
                        EXPENSE_ITEMS_ROWS
                    WHERE
                        TOTAL_AMOUNT > 0	
                )T1
                GROUP BY
                    EXPENSE_ITEM_ID,
                    EXPENSE_CENTER_ID
            ) AS GERCEKLESEN  
        ON GEC.EXPENSE_ITEM_ID = GERCEKLESEN.EXPENSE_ITEM_ID AND GERCEKLESEN.EXPENSE_CENTER_ID = GEC.EXPENSE_ID
        LEFT JOIN
            (
                SELECT
                    SUM(CASE WHEN IS_INCOME = 0 THEN TOTAL_AMOUNT ELSE 0 END) AS REZ_TOTAL_AMOUNT_BORC,
                    SUM(CASE WHEN IS_INCOME = 0 THEN TOTAL_AMOUNT_2 ELSE 0 END) AS REZ_TOTAL_AMOUNT_2_BORC,
                    SUM(CASE WHEN IS_INCOME = 1 THEN TOTAL_AMOUNT ELSE 0 END) AS REZ_TOTAL_AMOUNT_ALACAK,
                    SUM(CASE WHEN IS_INCOME = 1 THEN TOTAL_AMOUNT_2 ELSE 0 END) REZ_TOTAL_AMOUNT_2_ALACAK,
                    EXPENSE_ITEM_ID,
                    EXPENSE_CENTER_ID
                FROM
                (
                    SELECT 
                        ERR.TOTAL_AMOUNT TOTAL_AMOUNT,
                        ERR.OTHER_MONEY_VALUE_2 TOTAL_AMOUNT_2,
                        ERR.IS_INCOME,
                        ERR.EXPENSE_ITEM_ID,
                        ERR.ACTIVITY_TYPE,
                        ERR.EXPENSE_CENTER_ID
                    FROM
                        EXPENSE_RESERVED_ROWS AS ERR
                    WHERE
                        TOTAL_AMOUNT > 0					
                )T1
                GROUP BY
                    EXPENSE_ITEM_ID,
                    EXPENSE_CENTER_ID
            ) AS RESERVED  
        ON GEC.EXPENSE_ITEM_ID = RESERVED.EXPENSE_ITEM_ID AND RESERVED.EXPENSE_CENTER_ID = GEC.EXPENSE_ID 
         ),
             CTE2 AS (
                    SELECT
                        *
                    FROM
                        CTE1
                )
                SELECT
                    ( SELECT SUM(ROW_TOTAL_INCOME) FROM CTE2 ) ALL_ROW_TOTAL_INCOME,
                    ( SELECT SUM(ROW_TOTAL_EXPENSE) FROM CTE2 ) ALL_ROW_TOTAL_EXPENSE,
                    ( SELECT SUM(ROW_TOTAL_INCOME_2) FROM CTE2 ) ALL_ROW_TOTAL_INCOME_2,
                    ( SELECT SUM(ROW_TOTAL_EXPENSE_2) FROM CTE2 ) ALL_ROW_TOTAL_EXPENSE_2,
                    ( SELECT SUM(TOTAL_AMOUNT_BORC) FROM CTE2 ) ALL_TOTAL_AMOUNT_BORC,
                    ( SELECT SUM(TOTAL_AMOUNT_ALACAK) FROM CTE2 ) ALL_TOTAL_AMOUNT_ALACAK,
                    ( SELECT SUM(TOTAL_AMOUNT_BORC_2) FROM CTE2 ) ALL_TOTAL_AMOUNT_BORC_2,
                    ( SELECT SUM(TOTAL_AMOUNT_ALACAK_2) FROM CTE2 ) ALL_TOTAL_AMOUNT_ALACAK_2,
                    ( SELECT SUM(REZ_TOTAL_AMOUNT_ALACAK) FROM CTE2 ) ALL_REZ_TOTAL_AMOUNT_ALACAK,
                    ( SELECT SUM(REZ_TOTAL_AMOUNT_2_ALACAK) FROM CTE2 ) ALL_REZ_TOTAL_AMOUNT_2_ALACAK,
                    ( SELECT SUM(REZ_TOTAL_AMOUNT_BORC) FROM CTE2 ) ALL_REZ_TOTAL_AMOUNT_BORC,
                    ( SELECT SUM(REZ_TOTAL_AMOUNT_2_BORC) FROM CTE2 ) ALL_REZ_TOTAL_AMOUNT_2_BORC,
                    CTE2.*
                FROM
                    CTE2                		
    </cfquery>
    <cfreturn GET_EXPENSE_BUDGET>
</cffunction>

<cffunction name="GetStageCall" access="public" returntype="query">
    <cfquery name="get_stage_call_center" datasource="#dsn#">
        SELECT
            GS.SERVICE_ID,
            STAGE,
            COUNT(GS.SERVICE_ID) TOTAL
        FROM
            PROCESS_TYPE_ROWS PTR,
            G_SERVICE GS
        WHERE
            GS.SERVICE_STATUS_ID = PTR.PROCESS_ROW_ID AND GS.SERVICE_ACTIVE=1
            AND GS.RESP_EMP_ID IN (<cfqueryparam value="#arguments.employee_ids#" cfsqltype="cf_sql_integer" list = "yes">) 
        GROUP BY
            GS.SERVICE_ID,
            STAGE       	 
    </cfquery>  
    <cfreturn get_stage_call_center> 
</cffunction>
<cffunction name="GetStageService" access="public" returntype="query">
    <cfquery name="get_stage_service" datasource="#dsn3#">
       SELECT
            S.SERVICE_EMPLOYEE_ID,
            STAGE,
            S.SERVICE_ID,
            COUNT(S.SERVICE_ID) TOTAL
        FROM
            #dsn#.PROCESS_TYPE_ROWS PTR,
            SERVICE S
        WHERE
            S.SERVICE_STATUS_ID = PTR.PROCESS_ROW_ID AND S.SERVICE_ACTIVE=1
            AND S.SERVICE_EMPLOYEE_ID IN (<cfqueryparam value="#arguments.employee_ids#" cfsqltype="cf_sql_integer" list = "yes">) 
        GROUP BY
            STAGE,
            S.SERVICE_ID,
            SERVICE_EMPLOYEE_ID
    </cfquery>
     <cfreturn get_stage_service> 
</cffunction>
<cffunction name="GetEmployeeCall" access="public" returntype="query">
    <cfquery name="get_employee_call" datasource="#dsn#">
        SELECT
            RESP_EMP_ID,
            EMPLOYEE_NAME,
            EMPLOYEE_SURNAME,
            COUNT(GS.SERVICE_ID) TOTAL
        FROM
            EMPLOYEES E,
            G_SERVICE GS
        WHERE
            GS.RESP_EMP_ID = E.EMPLOYEE_ID AND GS.SERVICE_ACTIVE=1
            AND RESP_EMP_ID IN (<cfqueryparam value="#arguments.employee_ids#" cfsqltype="cf_sql_integer" list = "yes">) 
        GROUP BY
            RESP_EMP_ID,
            EMPLOYEE_NAME,
            EMPLOYEE_SURNAME
             	 
    </cfquery>  
    <cfreturn get_employee_call> 
</cffunction>
<cffunction name="GetEmployeeService" access="public" returntype="query">
    <cfquery name="get_employee_service" datasource="#dsn3#">
        SELECT
            SERVICE_EMPLOYEE_ID,
            EMPLOYEE_NAME,
            EMPLOYEE_SURNAME,
            COUNT(S.SERVICE_ID) TOTAL
        FROM
            #dsn#.EMPLOYEES E,
            SERVICE S
        WHERE
            S.SERVICE_EMPLOYEE_ID = E.EMPLOYEE_ID AND S.SERVICE_ACTIVE=1
            AND S.SERVICE_EMPLOYEE_ID IN (<cfqueryparam value="#arguments.employee_ids#" cfsqltype="cf_sql_integer" list = "yes">) 
        GROUP BY
            SERVICE_EMPLOYEE_ID,
            EMPLOYEE_NAME,
            EMPLOYEE_SURNAME
    </cfquery>  
    <cfreturn get_employee_service> 
</cffunction>

<cffunction name="GetCategoryTasks" access="public" returntype="query">
   <cfquery name="get_works_cat" datasource="#DSN#">
        SELECT 
            COUNT(PW.WORK_ID) WORK_COUNT,
            PWC.WORK_CAT  WORK_CAT
        FROM 
            PRO_WORKS PW,
            PRO_WORK_CAT PWC
        WHERE 
            PW.WORK_CAT_ID = PWC.WORK_CAT_ID AND
            PW.WORK_STATUS = 1 AND
            PW.PROJECT_EMP_ID IN (<cfqueryparam value="#arguments.employee_ids#" cfsqltype="cf_sql_integer" list = "yes" >) 
        GROUP BY
            PWC.WORK_CAT		
    </cfquery> 
    <cfreturn get_works_cat> 
</cffunction>

<cffunction name="GetStageTasks" access="public" returntype="query">
    <cfquery name="get_stage_works" datasource="#DSN#">
		SELECT 
			COUNT(PW.WORK_ID) WORK_COUNT, 
			PTR.STAGE AS STAGE
		FROM 
			PROCESS_TYPE_ROWS PTR,
			PRO_WORKS PW 
		WHERE
			PW.WORK_CURRENCY_ID = PTR.PROCESS_ROW_ID AND
            PW.WORK_STATUS = 1 AND
			PW.PROJECT_EMP_ID IN (<cfqueryparam value="#arguments.employee_ids#" cfsqltype="cf_sql_integer" list = "yes" >) 
		GROUP BY
			PTR.STAGE		
	</cfquery>  
    <cfreturn get_stage_works> 
</cffunction>

<cffunction name="GetEmployeeTasks" access="public" returntype="query">
    <cfquery name="get_employee_works" datasource="#DSN#">
        SELECT 
            COUNT(PW.WORK_ID) WORK_COUNT,
            E.EMPLOYEE_ID,
            E.EMPLOYEE_NAME,
            E.EMPLOYEE_SURNAME
        FROM 
            PRO_WORKS PW,
            EMPLOYEES E
        WHERE 
            PW.PROJECT_EMP_ID = E.EMPLOYEE_ID AND
            E.EMPLOYEE_STATUS = 1 AND
            PW.WORK_STATUS = 1 AND
            PW.PROJECT_EMP_ID IN (<cfqueryparam value="#arguments.employee_ids#" cfsqltype="cf_sql_integer" list = "yes" >) 
        GROUP BY
            E.EMPLOYEE_ID,
            E.EMPLOYEE_NAME,
            E.EMPLOYEE_SURNAME
        ORDER BY
            WORK_COUNT DESC
    </cfquery>  
    <cfreturn get_employee_works> 
</cffunction>
<cffunction name="GetMyTasks" access="public" returntype="query">
    <cfquery name="get_my_works" datasource="#DSN#">
        SELECT 
            COUNT(WORK_ID) WORK_COUNT
        FROM 
            PRO_WORKS 
        WHERE 
            WORK_STATUS = 1 AND
            PROJECT_EMP_ID IN (<cfqueryparam value="#arguments.employee_ids#" cfsqltype="cf_sql_integer" list = "yes" >) 
    </cfquery>  
    <cfreturn get_my_works> 
</cffunction>

<cffunction name = "get_warnings" returnType = "query" access = "public">
    <cfargument name="start_response_date" type="any" default="">
    <cfargument name="finish_response_date" type="any" default="#now()#">
    <cfargument name="position_code" type="any" default="">

    <cfquery name="get_warnings" datasource="#dsn#">
		SELECT
			PT.PROCESS_ID,
			PT.PROCESS_NAME,
			PROCESS_ROW_ID,
			COUNT(PTR.PROCESS_ROW_ID) AS PROCESS_STAGE_COUNT,
			PTR.STAGE
		FROM PAGE_WARNINGS AS PW
		JOIN PROCESS_TYPE_ROWS AS PTR ON PW.ACTION_STAGE_ID = PTR.PROCESS_ROW_ID
		JOIN PROCESS_TYPE AS PT ON PTR.PROCESS_ID = PT.PROCESS_ID
		LEFT JOIN GENERAL_PAPER AS GP ON PW.GENERAL_PAPER_ID = GP.GENERAL_PAPER_ID
		WHERE
			
            PW.RECORD_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#arguments.start_response_date#"> AND
            PW.RECORD_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#arguments.finish_response_date#"> AND
            PW.POSITION_CODE IN(<cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.position_code#">) AND
            PW.IS_PARENT = 1 AND 
            PW.IS_ACTIVE = <cfqueryparam cfsqltype="cf_sql_bit" value="1">
		GROUP BY
			PT.PROCESS_ID,
			PT.PROCESS_NAME,
			PTR.PROCESS_ROW_ID,
			PTR.STAGE
		ORDER BY 
			PT.PROCESS_NAME ASC
    </cfquery>
    
    <cfreturn get_warnings>

</cffunction>
<cffunction name = "get_projects" returnType = "query" access = "public">
    <cfquery name="get_projects" datasource="#dsn#">
		SELECT
			PR.PROJECT_ID,
			PR.PROJECT_HEAD,
            COUNT(PTR.PROCESS_ROW_ID) AS PROJECT_STAGE_COUNT,
			PTR.STAGE,
            COUNT(SMPC.MAIN_PROCESS_CAT_ID) AS MAIN_PROJECTCAT_ID_COUNT,
			SMPC.MAIN_PROCESS_CAT
		FROM 
            PRO_PROJECTS AS PR
            LEFT JOIN #dsn2#.EXPENSE_CENTER AS EC ON PR.EXPENSE_CODE = EC.EXPENSE_CODE
            LEFT JOIN PROCESS_TYPE_ROWS AS PTR ON PR.PRO_CURRENCY_ID = PTR.PROCESS_ROW_ID
            LEFT JOIN SETUP_MAIN_PROCESS_CAT SMPC ON SMPC.MAIN_PROCESS_CAT_ID = PR.PROCESS_CAT
		WHERE			
           <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#"> IN (EC.RESPONSIBLE1,EC.RESPONSIBLE2,EC.RESPONSIBLE3) OR
           (
                PR.PROJECT_EMP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#">
           )
           AND 
            PR.PROJECT_STATUS = <cfqueryparam cfsqltype="cf_sql_bit" value="1">
		GROUP BY
			PR.PROJECT_ID,
            PR.PROJECT_HEAD,
            PTR.STAGE,
            SMPC.MAIN_PROCESS_CAT
		ORDER BY 
			PR.PROJECT_ID ASC
    </cfquery>    
    <cfreturn get_projects>
</cffunction>

    <cffunction name="GET_ACTIVE_OFFERS" access="remote" returntype="any">
        <cfargument name="employee_ids" default="">
        <cfquery name="GET_ACTIVE_OFFERS" datasource="#dsn3#">
            SELECT
                O.OFFER_ID,
                (SELECT SUM(PRICE) FROM OFFER WHERE OFFER_ID = O.OFFER_ID OR FOR_OFFER_ID = O.OFFER_ID) AS SUM_RECORD
            FROM
                OFFER O
            WHERE
                ((O.OFFER_ZONE = 1 AND O.PURCHASE_SALES = 1) OR (O.OFFER_ZONE = 0 AND O.PURCHASE_SALES = 0))
                AND O.OFFER_STATUS = 1 AND O.FOR_OFFER_ID IS NULL
                <cfif len(arguments.employee_ids)>
                    AND O.SALES_EMP_ID IN (<cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.employee_ids#" list="true">)
                </cfif>
        </cfquery>
        <cfquery name="GET_ACTIVE_OFFERS_SUM" dbtype="query">
            SELECT
                COUNT(OFFER_ID) AS COUNT_RECORD,
                SUM(SUM_RECORD) AS SUM_RECORD
            FROM
                GET_ACTIVE_OFFERS
        </cfquery>
        <cfreturn GET_ACTIVE_OFFERS_SUM>
    </cffunction>
    <cffunction name="GET_ACTIVE_PURCHASEDEMANDS" access="remote" returntype="any">
        <cfargument name="employee_ids" default="">
        <cfquery name="GET_ACTIVE_PURCHASEDEMANDS" datasource="#dsn3#">
            SELECT
                COUNT(I.INTERNAL_ID) AS COUNT_RECORD,
                ISNULL(SUM(I.NET_TOTAL), 0) AS SUM_RECORD
            FROM
                INTERNALDEMAND I
            WHERE
                I.DEMAND_TYPE = 1 AND I.IS_ACTIVE = 1
                <cfif len(arguments.employee_ids)>
                    AND I.FROM_POSITION_CODE IN (<cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.employee_ids#" list="true">)
                </cfif>
        </cfquery>
        <cfreturn GET_ACTIVE_PURCHASEDEMANDS>
    </cffunction>
    <cffunction name="GET_ACTIVE_ORDERS" access="remote" returntype="any">
        <cfargument name="employee_ids" default="">
        <cfquery name="GET_ACTIVE_ORDERS" datasource="#dsn3#">
            SELECT
                COUNT(O.ORDER_ID) AS COUNT_RECORD,
                ISNULL(SUM(O.NETTOTAL), 0) AS SUM_RECORD
            FROM
                ORDERS O
            WHERE
                (O.PURCHASE_SALES = 0 AND O.ORDER_ZONE = 0 AND O.ORDER_STATUS = 1)
                <cfif len(arguments.employee_ids)>
                    AND O.ORDER_EMPLOYEE_ID IN (<cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.employee_ids#" list="true">)
                </cfif>
        </cfquery>
        <cfreturn GET_ACTIVE_ORDERS>
    </cffunction>
    <cffunction name="GET_ACTIVE_INTERNALDEMANDS" access="remote" returntype="any">
        <cfargument name="employee_ids" default="">
        <cfquery name="GET_ACTIVE_INTERNALDEMANDS" datasource="#dsn3#">
            SELECT
                COUNT(I.INTERNAL_ID) AS COUNT_RECORD,
                ISNULL(SUM(I.NET_TOTAL), 0) AS SUM_RECORD
            FROM
                INTERNALDEMAND I
            WHERE
                I.DEMAND_TYPE = 0 AND I.IS_ACTIVE = 1
                <cfif len(arguments.employee_ids)>
                    AND I.FROM_POSITION_CODE IN (<cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.employee_ids#" list="true">)
                </cfif>
        </cfquery>
        <cfreturn GET_ACTIVE_INTERNALDEMANDS>
    </cffunction>
    <cffunction name="GET_ACTIVE_SECUREFUND" access="remote" returntype="any">
        <cfargument name="employee_ids" default="">
        <cfquery name="get_positions" datasource="#dsn#">
            SELECT
                POSITION_ID
            FROM
                EMPLOYEE_POSITIONS
            WHERE
                EMPLOYEE_ID IN (<cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.employee_ids#" list="true">)
        </cfquery>
        <cfset position_codes = valueList(get_positions.POSITION_ID) />
        <cfquery name="GET_ACTIVE_SECUREFUND" datasource="#dsn#">
            SELECT
                CS.SECUREFUND_ID,
                CS.GIVE_TAKE,
                CS.ACTION_VALUE2,
                CS.ACTION_VALUE,
                CS.SECUREFUND_TOTAL,
                CS.MONEY_CAT
            FROM
                COMPANY_SECUREFUND CS
                LEFT JOIN #dsn3#.RELATED_CONTRACT RC ON RC.CONTRACT_ID = CS.CONTRACT_ID
            WHERE
                CS.OUR_COMPANY_ID = #session.ep.company_id#
                AND CS.GIVE_TAKE = 0
                AND ISNULL(CS.IS_CRM,0) = 0
                AND CS.SECUREFUND_STATUS = 1
                AND CS.START_DATE <= <cfqueryparam cfsqltype="cf_sql_date" value="#now()#">
                AND CS.FINISH_DATE >= <cfqueryparam cfsqltype="cf_sql_date" value="#now()#">
                <cfif len(position_codes)>
                    AND (
                        <cfloop index="i" from="1" to="#listLen(position_codes)#">
                            RC.EMPLOYEE LIKE '%,#listgetat(position_codes,i)#,%'
                            <cfif i lt listLen(position_codes)>OR</cfif>
                        </cfloop>
                    )
                <cfelse>
                    AND 1 = 0
                </cfif>
        </cfquery>
        <cfreturn GET_ACTIVE_SECUREFUND>
    </cffunction>
    <cffunction name="GET_ACTIVE_SALES_ORDERS" access="remote" returntype="any">
        <cfargument name="employee_ids" default="">
        <cfquery name="GET_ACTIVE_SALES_ORDERS" datasource="#dsn3#">
            SELECT
                COUNT(O.ORDER_ID) AS COUNT_RECORD,
                ISNULL(SUM(O.NETTOTAL), 0) AS SUM_RECORD
            FROM
                ORDERS O
            WHERE
                ((O.PURCHASE_SALES = 1 AND O.ORDER_ZONE = 0) OR (O.PURCHASE_SALES = 0 AND O.ORDER_ZONE = 1))
                AND O.ORDER_STATUS = 1
                <cfif len(arguments.employee_ids)>
                    AND O.ORDER_EMPLOYEE_ID IN (<cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.employee_ids#" list="true">)
                </cfif>
        </cfquery>
        <cfreturn GET_ACTIVE_SALES_ORDERS>
    </cffunction>
    <cffunction name="GET_ACTIVE_SALES_OFFERS" access="remote" returntype="any">
        <cfargument name="employee_ids" default="">
        <cfquery name="GET_ACTIVE_SALES_OFFERS" datasource="#dsn3#">
            SELECT
                O.OFFER_ID,
                (SELECT SUM(PRICE) FROM OFFER WHERE OFFER_ID = O.OFFER_ID OR FOR_OFFER_ID = O.OFFER_ID) AS SUM_RECORD
            FROM
                OFFER O
            WHERE
                ((O.PURCHASE_SALES = 1 AND O.OFFER_ZONE = 0) OR (O.PURCHASE_SALES = 0 AND O.OFFER_ZONE = 1))
                AND O.OFFER_STATUS = 1 AND O.FOR_OFFER_ID IS NULL
                <cfif len(arguments.employee_ids)>
                    AND O.SALES_EMP_ID IN (<cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.employee_ids#" list="true">)
                </cfif>
        </cfquery>
        <cfquery name="GET_ACTIVE_SALES_OFFERS_SUM" dbtype="query">
            SELECT
                COUNT(OFFER_ID) AS COUNT_RECORD,
                SUM(SUM_RECORD) AS SUM_RECORD
            FROM
                GET_ACTIVE_SALES_OFFERS
        </cfquery>
        <cfreturn GET_ACTIVE_SALES_OFFERS_SUM>
    </cffunction>
    <!--- Seyahat Talepleri --->
    <cffunction name="travel_demands" access="public" returntype="query">
    	<cfargument name="employee_id" required="no" type="numeric"/>
        <cfargument name="travel_demand_id" required="no" type="numeric">
        <cfargument name="is_valid_control" required="no" type="numeric">
        <cfargument name="keyword" required="no" type="string">
        <cfargument name="branch_id" required="no" type="string">
        <cfargument name="comp_id" required="no" type="string">
        <cfargument name="department_id" required="no" type="string">
        <cfargument name="process_stage" type="string">
		<cfquery name="get_travel_demands" datasource="#dsn#">
			SELECT      
                E.EMPLOYEE_NAME+' '+E.EMPLOYEE_SURNAME AS EMPNAME_SURNAME,
                TD.DEPARTURE_DATE,
                TD.DEPARTURE_OF_DATE,
                CASE 
                    WHEN E.PHOTO IS NOT NULL AND LEN(E.PHOTO) > 0 
                        THEN '/documents/hr/'+E.PHOTO 
                    WHEN E.PHOTO IS NULL AND ED.SEX = 0
                        THEN  '/images/female.jpg'
                ELSE '/images/male.jpg' END  AS PHOTO,
                E.EMPLOYEE_ID
            FROM
            	EMPLOYEES_TRAVEL_DEMAND TD 
                INNER JOIN EMPLOYEES E ON TD.EMPLOYEE_ID = E.EMPLOYEE_ID
                INNER JOIN DEPARTMENT D ON D.DEPARTMENT_ID = TD.EMP_DEPARTMENT_ID
                LEFT JOIN EMPLOYEES_DETAIL ED ON  ED.EMPLOYEE_ID = E.EMPLOYEE_ID
            WHERE
            	TD.EMPLOYEE_ID IS NOT NULL
                <cfif isdefined('arguments.department_id') and len(arguments.department_id)>
                	AND D.DEPARTMENT_ID IN (<cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.department_id#" list="yes">)
                </cfif>
                <cfif isdefined('arguments.startdate') and len(arguments.startdate) and isdefined('arguments.finishdate') and len(arguments.finishdate)>
				AND 
                (
					(
						TD.DEPARTURE_DATE <= #arguments.startdate# AND
						TD.DEPARTURE_OF_DATE >= #arguments.finishdate#
					)
					OR
					(
                        TD.DEPARTURE_DATE >= #arguments.startdate# AND
                        TD.DEPARTURE_DATE <= #arguments.finishdate#
					)
					OR
					(
                        TD.DEPARTURE_OF_DATE >= #arguments.startdate# AND
                        TD.DEPARTURE_OF_DATE <= #arguments.finishdate#
					)
                )   
                </cfif>   
            ORDER BY
            	TD.RECORD_DATE DESC          
        </cfquery>
    <cfreturn get_travel_demands>
    </cffunction>
</cfcomponent>
