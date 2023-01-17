<!---
File: organization_chart.cfm
Author: Workcube - Esma Uysal <esmauysal@workcube.com>, Yazılımsa - Semih Akartuna <semihakartuna@yazilimsa.com>
Date: 13.02.2020
Controller: -
Description: Organizasyon Şeması Queryleridir.
---->
<cfcomponent><!------->
	<cfset dsn = application.systemParam.systemParam().dsn>
    <cffunction name="GET_ORGANIZATION" access="public" returntype="query">
		<cfquery name="GET_ORGANIZATION" datasource="#dsn#">
		    SELECT DISTINCT(PERIOD_YEAR)  FROM SETUP_PERIOD
		</cfquery>
		<cfreturn GET_ORGANIZATION>
	</cffunction>
	
    <cffunction name = "returnData" access = "public">
        <cfargument name="queryData" type="string" required="yes">
        <cfset structQueryData = deserializeJson(queryData)>
        <cfset data = ArrayNew(1)> 
        <cfloop index = "i" from = "1" to = "#ArrayLen(structQueryData.DATA)#">
            <cfset row = StructNew()>
            <cfset data[i] = row>
            <cfloop index = "j" from = "1" to = "#ArrayLen(structQueryData.COLUMNS)#">
                <cftry>

                    <cfset data[i]["#LCase(structQueryData.COLUMNS[j])#"] = structQueryData.DATA[i][j]>
                    <cfcatch>
                        <cfset data[i]["#structQueryData.COLUMNS[j]#"] = ''>
                    </cfcatch>
                </cftry>
            </cfloop>
        </cfloop>
        <cfreturn data>
    </cffunction>
    
    <!--- GET LANGUAGE SET --->
    <cffunction name="getLangSet" access="remote" returntype="any" output="no">
    	<cfargument name="lang" type="string" required="yes">
        <cfargument name="numbers" type="string" required="yes">
    
    	<cfset lang_component = CreateObject("component", "language")>
		<cfreturn lang_component.getLanguageSet(arguments.lang, arguments.numbers)>
    </cffunction>
    
    <!--- GET GENERAL INFO --->
    <cffunction name="getGeneralInfo" access="remote" returntype="any" output="no">
    
    	<cfset info = StructNew()>
        <cfset info["headquarters"] = getHeadquarters()>
        <cfset info["companies"] = getCompanies()>
        <cfset info["branches"] = getBranches()>
        <cfset info["departments"] = getDepartments()>
        
    	<cfreturn info>
    </cffunction>
    <cffunction name="org_chart" returntype="any" returnFormat="json" access="remote">
		<cfargument name="POSITION_CODE" default=""/>
        <cfargument name="DATE" default=""/>
        <cfargument name="is_photo" type="any" required="no" default="0">
        <cfargument name="is_position" type="any" required="no" default="0">
        <cfargument name="is_position_type" type="any" required="no" default="0">
        <cfargument name="is_title" type="any" required="no" default="0">
        <cfargument name="baglilik" type="numeric" required="yes">
        <cf_date tarih="arguments.DATE">
		<cfquery name="me" datasource="#dsn#">
			SELECT
				TOP 1
				EMPLOYEE_POSITIONS_HISTORY.EMPLOYEE_ID,
				EMPLOYEE_POSITIONS_HISTORY.POSITION_ID,
				EMPLOYEE_POSITIONS_HISTORY.POSITION_CODE AS 'key',
				EMPLOYEE_POSITIONS_HISTORY.EMPLOYEE_NAME + ' ' + EMPLOYEE_POSITIONS_HISTORY.EMPLOYEE_SURNAME AS 'name',
				EMPLOYEE_POSITIONS_HISTORY.POSITION_NAME,
				EMPLOYEE_POSITIONS_HISTORY.UPPER_POSITION_CODE AS 'parent'
                <cfif arguments.is_position eq 1>,EMPLOYEE_POSITIONS_HISTORY.POSITION_NAME title</cfif>
                <cfif arguments.baglilik eq 1>,EMPLOYEE_POSITIONS_HISTORY.UPPER_POSITION_CODE parent<cfelse>,EMPLOYEE_POSITIONS_HISTORY.UPPER_POSITION_CODE2 parent </cfif>
                <cfif arguments.is_photo eq 1>,
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
                        E.EMPLOYEE_ID =   EMPLOYEE_POSITIONS_HISTORY.EMPLOYEE_ID
                        AND ED.EMPLOYEE_ID = E.EMPLOYEE_ID
                    ) AS PHOTO
                </cfif>
                <cfif arguments.is_position_type eq 1>,(SELECT POSITION_CAT FROM SETUP_POSITION_CAT WHERE POSITION_CAT_ID = EMPLOYEE_POSITIONS_HISTORY.POSITION_CAT_ID) AS POSITION_CAT</cfif>
                <cfif arguments.is_title eq 1>,(SELECT TITLE FROM SETUP_TITLE WHERE TITLE_ID = EMPLOYEE_POSITIONS_HISTORY.TITLE_ID) AS TITLE_ID</cfif>
			FROM
				EMPLOYEE_POSITIONS_HISTORY
                INNER JOIN EMPLOYEE_POSITIONS ON EMPLOYEE_POSITIONS.POSITION_ID = EMPLOYEE_POSITIONS_HISTORY.POSITION_ID AND EMPLOYEE_POSITIONS.IS_ORG_VIEW = 1
			WHERE
				EMPLOYEE_POSITIONS_HISTORY.POSITION_CODE = #POSITION_CODE#
				AND EMPLOYEE_POSITIONS_HISTORY.RECORD_DATE <= <cfqueryparam cfsqltype="CF_SQL_DATE" value="#arguments.DATE#">
			ORDER BY EMPLOYEE_POSITIONS_HISTORY.RECORD_DATE DESC
		</cfquery>
		<cfif me.recordcount>
            <cfset result.status = true>
            <cfset result.data = this.returnData(replace(serializeJSON(me),"//",""))>
        <cfelse>
            <cfset result.status = false>
        </cfif>
		<cfreturn Replace(serializeJSON(result),'//','')>
	</cffunction>
	<cffunction name="org_chart_lower" returntype="any" returnFormat="json" access="remote">
		<cfargument name="UPPER_POSITION_CODE" default=""/>
        <cfargument name="DATE" default=""/>
        <cfargument name="is_photo" type="any" required="no" default="0">
        <cfargument name="is_position" type="any" required="no" default="0">
        <cfargument name="is_position_type" type="any" required="no" default="0">
        <cfargument name="is_title" type="any" required="no" default="0">
        <cfargument name="baglilik" type="numeric" required="yes">
        <cf_date tarih="arguments.DATE">
        <cfset arguments.DATE = dateAdd("d",1,arguments.DATE)>
		<cfquery name="low" datasource="#dsn#">
				WITH L AS(
					SELECT
						EMPLOYEE_POSITIONS_HISTORY.HISTORY_ID,
						EMPLOYEE_POSITIONS_HISTORY.EMPLOYEE_ID,
						EMPLOYEE_POSITIONS_HISTORY.POSITION_ID,
						EMPLOYEE_POSITIONS_HISTORY.POSITION_CODE,
						EMPLOYEE_POSITIONS_HISTORY.EMPLOYEE_NAME,
						EMPLOYEE_POSITIONS_HISTORY.EMPLOYEE_SURNAME,
						EMPLOYEE_POSITIONS_HISTORY.UPPER_POSITION_CODE,
						EMPLOYEE_POSITIONS_HISTORY.RECORD_DATE,
                        EMPLOYEE_POSITIONS_HISTORY.POSITION_STATUS 
                        <cfif arguments.is_position eq 1>,EMPLOYEE_POSITIONS_HISTORY.POSITION_NAME title</cfif>
                        <cfif arguments.baglilik eq 1>,EMPLOYEE_POSITIONS_HISTORY.UPPER_POSITION_CODE parent<cfelse>,EMPLOYEE_POSITIONS_HISTORY.UPPER_POSITION_CODE2 parent </cfif>
                        <cfif arguments.is_photo eq 1>,
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
                                E.EMPLOYEE_ID =   EMPLOYEE_POSITIONS_HISTORY.EMPLOYEE_ID
                                AND ED.EMPLOYEE_ID = E.EMPLOYEE_ID
                            ) AS PHOTO
                        </cfif>
                        <cfif arguments.is_position_type eq 1>,(SELECT POSITION_CAT FROM SETUP_POSITION_CAT WHERE POSITION_CAT_ID = EMPLOYEE_POSITIONS_HISTORY.POSITION_CAT_ID) AS POSITION_CAT</cfif>
                        <cfif arguments.is_title eq 1>,(SELECT TITLE FROM SETUP_TITLE WHERE TITLE_ID = EMPLOYEE_POSITIONS_HISTORY.TITLE_ID) AS TITLE_ID</cfif>
					FROM
						EMPLOYEE_POSITIONS_HISTORY
                        INNER JOIN EMPLOYEE_POSITIONS ON EMPLOYEE_POSITIONS.POSITION_ID = EMPLOYEE_POSITIONS_HISTORY.POSITION_ID AND EMPLOYEE_POSITIONS.IS_ORG_VIEW = 1
					WHERE
						EMPLOYEE_POSITIONS_HISTORY.UPPER_POSITION_CODE = #UPPER_POSITION_CODE#
				), LA AS(
					SELECT
						TL.*,
						(SELECT TOP 1 UPPER_POSITION_CODE FROM EMPLOYEE_POSITIONS_HISTORY	WHERE POSITION_CODE = TL.POSITION_CODE	AND RECORD_DATE <= <cfqueryparam cfsqltype="CF_SQL_DATE" value="#arguments.DATE#"> ORDER BY RECORD_DATE DESC ) CONTROL_UPPER
					FROM L AS TL
				),LB AS( 
					SELECT CRS.* FROM (SELECT DISTINCT POSITION_CODE FROM LA) DSL
					CROSS APPLY(
						SELECT 	TOP 1 *	FROM LA CRS WHERE CRS.POSITION_CODE = DSL.POSITION_CODE AND CONTROL_UPPER = UPPER_POSITION_CODE AND RECORD_DATE <= <cfqueryparam cfsqltype="CF_SQL_DATE" value="#arguments.DATE#">	ORDER BY RECORD_DATE DESC
					) CRS
				)
				SELECT
					EMPLOYEE_ID,
					POSITION_ID,
					POSITION_CODE AS 'key',
					EMPLOYEE_NAME + ' ' + EMPLOYEE_SURNAME AS 'name'
                    <cfif arguments.is_position eq 1>,title</cfif>
                    ,parent
                    <cfif arguments.is_photo eq 1>,PHOTO</cfif>
                    <cfif arguments.is_position_type eq 1>,POSITION_CAT</cfif>
                    <cfif arguments.is_title eq 1>,TITLE_ID</cfif>
				FROM LB
                WHERE POSITION_STATUS = 1
		</cfquery>
		<cfif low.recordcount>
            <cfset result.status = true>
            <cfset result.data = this.returnData(replace(serializeJSON(low),"//",""))>
        <cfelse>
            <cfset result.status = false>
        </cfif>
		<cfreturn Replace(serializeJSON(result),'//','')>
	</cffunction>
	<cffunction name="org_chart_upper" returntype="any" returnFormat="json" access="remote">
        <cfargument name="is_photo" type="any" required="no" default="0">
        <cfargument name="is_position" type="any" required="no" default="0">
        <cfargument name="is_position_type" type="any" required="no" default="0">
        <cfargument name="is_title" type="any" required="no" default="0">
		<cfargument name="POSITION_CODE" default=""/>
        <cfargument name="DATE" default=""/>
        <cfargument name="baglilik" type="numeric" required="yes">
        <cf_date tarih="arguments.DATE">
        <cfset arguments.DATE = dateAdd("d",1,arguments.DATE)>
		<cfquery name="up" datasource="#dsn#">
			WITH U AS(
				SELECT
					TOP 1
					EMPLOYEE_POSITIONS_HISTORY.EMPLOYEE_ID,
					EMPLOYEE_POSITIONS_HISTORY.POSITION_ID,
					EMPLOYEE_POSITIONS_HISTORY.POSITION_CODE,
					EMPLOYEE_POSITIONS_HISTORY.EMPLOYEE_NAME,
					EMPLOYEE_POSITIONS_HISTORY.EMPLOYEE_SURNAME,
					EMPLOYEE_POSITIONS_HISTORY.UPPER_POSITION_CODE,
                    EMPLOYEE_POSITIONS_HISTORY.POSITION_STATUS 
                    <cfif arguments.is_position eq 1>,EMPLOYEE_POSITIONS_HISTORY.POSITION_NAME title</cfif>
                        <cfif arguments.baglilik eq 1>,EMPLOYEE_POSITIONS_HISTORY.UPPER_POSITION_CODE parent<cfelse>,EMPLOYEE_POSITIONS_HISTORY.UPPER_POSITION_CODE2 parent </cfif>
                        <cfif arguments.is_photo eq 1>,
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
                                E.EMPLOYEE_ID =   EMPLOYEE_POSITIONS_HISTORY.EMPLOYEE_ID
                                AND ED.EMPLOYEE_ID = E.EMPLOYEE_ID
                            ) AS PHOTO
                        </cfif>
                    <cfif arguments.is_position_type eq 1>,(SELECT POSITION_CAT FROM SETUP_POSITION_CAT WHERE POSITION_CAT_ID = EMPLOYEE_POSITIONS_HISTORY.POSITION_CAT_ID) AS POSITION_CAT</cfif>
                    <cfif arguments.is_title eq 1>,(SELECT TITLE FROM SETUP_TITLE WHERE TITLE_ID = EMPLOYEE_POSITIONS_HISTORY.TITLE_ID) AS TITLE_ID</cfif>
				FROM
					EMPLOYEE_POSITIONS_HISTORY
                    INNER JOIN EMPLOYEE_POSITIONS ON EMPLOYEE_POSITIONS.POSITION_ID = EMPLOYEE_POSITIONS_HISTORY.POSITION_ID AND EMPLOYEE_POSITIONS.IS_ORG_VIEW = 1
				WHERE
					EMPLOYEE_POSITIONS_HISTORY.POSITION_CODE = #POSITION_CODE#
					AND EMPLOYEE_POSITIONS_HISTORY.RECORD_DATE <= <cfqueryparam cfsqltype="CF_SQL_DATE" value="#arguments.DATE#">
				ORDER BY RECORD_DATE DESC
			),U_CONTROL AS (
				SELECT *,
				(SELECT TOP 1 UPPER_POSITION_CODE FROM EMPLOYEE_POSITIONS_HISTORY	WHERE POSITION_CODE =  U_CONTROL.POSITION_CODE	AND RECORD_DATE <= <cfqueryparam cfsqltype="CF_SQL_DATE" value="#arguments.DATE#">	ORDER BY RECORD_DATE DESC) CONTROL_UPPER
				FROM U as U_CONTROL			),
			UB AS(
				SELECT 
					EMPLOYEE_ID,
					POSITION_ID,
					POSITION_CODE,
					EMPLOYEE_NAME,
					EMPLOYEE_SURNAME,
					UPPER_POSITION_CODE,
                    POSITION_STATUS
                    <cfif arguments.is_position eq 1>,title</cfif>
                   ,parent
                    <cfif arguments.is_photo eq 1>,PHOTO</cfif>
                    <cfif arguments.is_position_type eq 1>,POSITION_CAT</cfif>
                    <cfif arguments.is_title eq 1>,TITLE_ID</cfif>
				FROM U_CONTROL WHERE CONTROL_UPPER = UPPER_POSITION_CODE OR UPPER_POSITION_CODE IS NULL
			)
			SELECT
				EMPLOYEE_ID,
				POSITION_ID,
				POSITION_CODE AS 'key',
				EMPLOYEE_NAME + ' ' + EMPLOYEE_SURNAME AS 'name'
                <cfif arguments.is_position eq 1>,title</cfif>
                ,parent
                <cfif arguments.is_photo eq 1>,PHOTO</cfif>
                <cfif arguments.is_position_type eq 1>,POSITION_CAT</cfif>
                <cfif arguments.is_title eq 1>,TITLE_ID</cfif>
			FROM UB	
            WHERE POSITION_STATUS = 1			
		</cfquery>
		<cfif up.recordcount>
            <cfset result.status = true>
            <cfset result.data = this.returnData(replace(serializeJSON(up),"//",""))>
        <cfelse>
            <cfset result.status = false>
        </cfif>
		<cfreturn Replace(serializeJSON(result),'//','')>
	</cffunction>
  
    
    <!--- FIND POSITIONS --->
    <cffunction name="findPositions" access="remote" returntype="any" output="no">
    	<cfargument name="filter" type="string" required="yes">
        
        <cfquery name="positions" datasource="#dsn#">
        	SELECT DISTINCT
                EP.POSITION_CODE positionCode,
                EP.POSITION_NAME positionName,
                PC.POSITION_CAT positionType,
                PT.TITLE positionTitle,
                EP.EMPLOYEE_NAME employeeName,
                EP.EMPLOYEE_SURNAME employeeSurname
            FROM
                EMPLOYEE_POSITIONS EP,
                SETUP_POSITION_CAT PC,
                SETUP_TITLE PT
            WHERE
            	EP.IS_ORG_VIEW = 1 AND
                EP.POSITION_CAT_ID = PC.POSITION_CAT_ID AND
                EP.TITLE_ID = PT.TITLE_ID AND
                EP.POSITION_STATUS = 1 AND
                (
                    EP.POSITION_NAME LIKE '%#arguments.filter#%' OR	
                    EP.EMPLOYEE_NAME + ' ' + EP.EMPLOYEE_SURNAME LIKE '%#arguments.filter#%'
                )
            ORDER BY 
                EP.EMPLOYEE_NAME, EP.EMPLOYEE_SURNAME, EP.POSITION_NAME
        </cfquery>
        
        <cfreturn positions>
    </cffunction>
    
    <!--- FILTER POSITIONS --->
    <cffunction name="filterPositions" access="remote" returntype="any" output="no">
    	<cfargument name="filter" type="string" required="yes">
        <cfargument name="company_id" type="any" required="no" default="NULL"><!-- NULL means all -->
        
        <cfquery name="positions" datasource="#dsn#">
        	DECLARE @companyID int;
			SET @companyID = #arguments.company_id#;
            DECLARE @foundPositions TABLE
            (
                photo nvarchar(max),
                isCritical bit,
                department nvarchar(max),
                positionName nvarchar(max),
                positionType nvarchar(max),
                positionTitle nvarchar(max),
                name nvarchar(max),
                surname nvarchar(max),
                employeeID int,
                positionCode int
            );
            
            INSERT INTO @foundPositions
            SELECT
                (SELECT PHOTO FROM EMPLOYEES WHERE EMPLOYEE_ID = EP.EMPLOYEE_ID)	AS photo,
                EP.IS_CRITICAL														AS isCritical,
                D.DEPARTMENT_HEAD													AS department,
                EP.POSITION_NAME													AS positionName,
                PC.POSITION_CAT 													AS positionType,
                PT.TITLE 															AS positionTitle,
                EP.EMPLOYEE_NAME													AS name,
                EP.EMPLOYEE_SURNAME													AS surname,
                EP.EMPLOYEE_ID														AS employeeID,
                EP.POSITION_CODE													AS positionCode
            FROM
                EMPLOYEE_POSITIONS EP,
                SETUP_POSITION_CAT PC,
                SETUP_TITLE PT,
                DEPARTMENT D
            WHERE
                EP.IS_ORG_VIEW = 1 AND EP.POSITION_STATUS = 1 AND
                EP.POSITION_CAT_ID = PC.POSITION_CAT_ID AND
                EP.TITLE_ID = PT.TITLE_ID AND
                D.DEPARTMENT_ID = EP.DEPARTMENT_ID AND
                --EP.EMPLOYEE_ID IS NOT NULL AND
                EP.DEPARTMENT_ID IN (SELECT D.DEPARTMENT_ID FROM DEPARTMENT D, BRANCH B WHERE D.BRANCH_ID = B.BRANCH_ID AND B.COMPANY_ID = @companyID OR @companyID IS NULL) AND
                (EP.EMPLOYEE_NAME LIKE '%#arguments.filter#%' OR EP.EMPLOYEE_SURNAME LIKE '%#arguments.filter#%' OR EP.POSITION_NAME LIKE '%#arguments.filter#%')
                
            SELECT (CASE WHEN photo IS NOT NULL AND LEN(photo) > 0 THEN '/documents/hr/' + photo ELSE NULL END) AS photo, isCritical, department, positionName, positionType, positionTitle, positionCode, name, surname, employeeID FROM @foundPositions ORDER BY name, surname, positionName;
        </cfquery>
        
        <cfreturn positions>
    </cffunction>
    
    <!--- UPDATE POSITIONS --->
    <cffunction name="updatePositions" access="remote" returntype="any" output="no">
    	<cfargument name="design_type" type="numeric" required="yes">
        <cfargument name="list" type="array" required="yes">
        <cfargument name="rec_emp" type="string" required="yes">
        
        <cfloop from="1" to="#ArrayLen(arguments.list)#" index="i">
        	<cfquery name="update_position" datasource="#dsn#">
            	UPDATE
	                EMPLOYEE_POSITIONS
				SET
	                <cfif arguments.design_type eq 1>
	                    UPPER_POSITION_CODE = <cfif arguments.list[i].reset eq 0><cfif len(arguments.list[i].upperPositionCode)>#arguments.list[i].upperPositionCode#<cfelse>NULL</cfif><cfelse>NULL</cfif>,
					<cfelse>
                    	UPPER_POSITION_CODE2 = <cfif arguments.list[i].reset eq 0><cfif len(arguments.list[i].upperPositionCode)>#arguments.list[i].upperPositionCode#<cfelse>NULL</cfif><cfelse>NULL</cfif>,
					</cfif>
                    UPDATE_DATE = #now()#,
	                UPDATE_EMP = #arguments.rec_emp#,
    	            UPDATE_IP = '#cgi.REMOTE_ADDR#'            	
				WHERE
                	POSITION_CODE = #arguments.list[i].positionCode#
            </cfquery>
        </cfloop>
        
        <cfreturn arguments.list>
    </cffunction>
    
    <!--- GET ORGANIZATION --->
    <cffunction name="getOrganizationSchema" access="remote" returntype="any" output="no" returnFormat="json">
    	<cfargument name="manager_nr" type="any" required="no" default="NULL">
        <cfargument name="headquarter_id" type="any" required="no" default="NULL">
        <cfargument name="company_id" type="any" required="no" default="NULL">
        <cfargument name="branch_id" type="any" required="no" default="NULL">
        <cfargument name="department_id" type="any" required="no" default="NULL">
        <cfargument name="organization_date" type="any" required="yes" default="NULL"><!-- NULL means all -->
        <cfargument name="is_photo" type="any" required="no" default="0">
        <cfargument name="is_position" type="any" required="no" default="0">
        <cfargument name="is_position_type" type="any" required="no" default="0">
        <cfargument name="is_title" type="any" required="no" default="0">
        <cfif arguments.headquarter_id is "NULL" and arguments.company_id is "NULL"><cfreturn "Atleast one of headquarters or companies must be selected to filter!"></cfif>
        
        <cf_date tarih="arguments.organization_date">
        <cfset arguments.organization_date = dateAdd("d",1,arguments.organization_date)>

        <cfquery name="get_schema" datasource="#dsn#">
            <cfif IsNumeric(arguments.manager_nr)>
                DECLARE @managerNr int = #arguments.manager_nr#;
            </cfif>
            <cfif IsNumeric(arguments.headquarter_id)>
        	    DECLARE @headQuarterID int = #arguments.headquarter_id#;
            <cfelse>
                DECLARE @headQuarterID int;
            </cfif>
            <cfif IsNumeric(arguments.company_id)>
                DECLARE @companyID int = #arguments.company_id#;
            </cfif>
            <cfif isdefined("arguments.branch_id") and len(arguments.branch_id)>
                DECLARE @branchID int = #arguments.branch_id#;
            </cfif>
            <cfif isdefined("arguments.department_id") and len(arguments.department_id)>
                DECLARE @departmentID int = #arguments.department_id#;
            </cfif>
            DECLARE @skipHeadquarters bit = 0;
            <cfif IsNumeric(arguments.company_id)>
                IF (@headQuarterID IS NULL AND @companyID IS NOT NULL) SET @headQuarterID = (SELECT HEADQUARTERS_ID FROM OUR_COMPANY WHERE IS_ORGANIZATION = 1 AND COMP_ID = @companyID);
                IF (@headQuarterID IS NULL AND @companyID IS NOT NULL) SET @skipHeadquarters = 1; -- skip if the company is not related a headquarter
            </cfif>
            WITH TYPE_ZERO AS  (
                SELECT
                    0					AS type,
                    REPLACE('0.'+STR(H.HEADQUARTERS_ID),' ','')	AS 'key_',
                    H.NAME				AS name,
                    NULL				AS parent,
                    NULL				AS hierarchy,
                    NULL				AS manager
                    ,HEADQUARTERS_ID
                    ,H.RECORD_DATE
                    <cfif arguments.is_photo eq 1>,NULL AS photo</cfif>
                    <cfif arguments.is_position eq 1>,NULL AS title</cfif>
                    <cfif arguments.is_position_type eq 1>,NULL AS POSITION_CAT</cfif>
                    <cfif arguments.is_title eq 1>,NULL AS title_id</cfif>
                FROM
                    SETUP_HEADQ_HISTORY H
                WHERE
                    H.IS_ORGANIZATION = 1 AND
                    (@headQuarterID IS NULL OR H.HEADQUARTERS_ID = @headQuarterID) AND
                    (@skipHeadquarters = 0 OR @skipHeadquarters = 1 AND H.HEADQUARTERS_ID = -1)
                    AND H.RECORD_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#arguments.organization_date#">
            ), 
            TYPE_ZERO_LAST AS
            (
                SELECT TZERO.* FROM (SELECT DISTINCT HEADQUARTERS_ID FROM TYPE_ZERO) TYZ
                CROSS APPLY(
                        SELECT 	TOP 1 *	FROM TYPE_ZERO TZ WHERE TZ.HEADQUARTERS_ID = TYZ.HEADQUARTERS_ID AND  TZ.RECORD_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#arguments.organization_date#">	ORDER BY RECORD_DATE DESC
                    ) TZERO
            ),
            TYPE_ONE AS(
                SELECT
                    1					AS type,
                    REPLACE('1.'+STR(C.COMP_ID),' ','')		AS 'key_',
                    C.COMPANY_NAME		AS name,
                    REPLACE('0.'+STR(H.HEADQUARTERS_ID),' ','')	AS parent,
                    NULL				AS hierarchy
                    ,C.COMP_ID
		            ,C.UPDATE_DATE
                    <cfif IsNumeric(arguments.manager_nr)>
                        ,(E.EMPLOYEE_NAME + ' ' + E.EMPLOYEE_SURNAME) AS manager
                        <cfif arguments.is_photo eq 1>,(CASE WHEN E.PHOTO IS NOT NULL AND LEN(E.PHOTO) > 0 THEN '/documents/hr/' + E.PHOTO ELSE NULL END) AS photo</cfif>
                        <cfif arguments.is_position eq 1>,EP.POSITION_NAME	AS title</cfif>
                        <cfif arguments.is_position_type eq 1>,PC.POSITION_CAT 	AS POSITION_CAT</cfif>
                        <cfif arguments.is_title eq 1>,PT.TITLE AS title_id</cfif>
                    <cfelse>
                        ,NULL				AS manager
                        <cfif arguments.is_photo eq 1>, NULL				AS photo</cfif>
                        <cfif arguments.is_position eq 1>,NULL AS title</cfif>
                        <cfif arguments.is_position_type eq 1>,NULL AS POSITION_CAT</cfif>
                        <cfif arguments.is_title eq 1>,NULL 	AS title_id</cfif>
                    </cfif>
                FROM
                    OUR_COMPANY_HISTORY C
                    LEFT JOIN SETUP_HEADQ_HISTORY H ON C.HEADQUARTERS_ID = H.HEADQUARTERS_ID
                    <cfif IsNumeric(arguments.manager_nr)>
                        LEFT JOIN EMPLOYEE_POSITIONS EP ON (@managerNr = 1 AND EP.POSITION_CODE = C.MANAGER_POSITION_CODE OR @managerNr = 2 AND EP.POSITION_CODE = C.MANAGER_POSITION_CODE2)
                        LEFT JOIN EMPLOYEES E ON E.EMPLOYEE_ID = EP.EMPLOYEE_ID
                        LEFT JOIN SETUP_POSITION_CAT PC ON PC.POSITION_CAT_ID = EP.POSITION_CAT_ID
                        LEFT JOIN SETUP_TITLE PT ON PT.TITLE_ID = EP.TITLE_ID
                    </cfif>
                WHERE
                    C.IS_ORGANIZATION = 1 AND COMP_STATUS = 1 AND
                    (@headQuarterID IS NULL OR C.HEADQUARTERS_ID = @headQuarterID) 
                    AND H.RECORD_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#arguments.organization_date#">
                    AND C.UPDATE_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#arguments.organization_date#">
                    <cfif IsNumeric(arguments.company_id)>
                        AND (@companyID IS NULL OR C.COMP_ID = @companyID)
                    </cfif>
            ), 
            TYPE_ONE_LAST AS(
            SELECT TONE.* FROM (SELECT DISTINCT COMP_ID FROM TYPE_ONE) TYONE
                CROSS APPLY(
                        SELECT 	TOP 1 *	FROM TYPE_ONE TYO WHERE TYO.COMP_ID = TYONE.COMP_ID AND  TYO.UPDATE_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#arguments.organization_date#">	ORDER BY TYO.UPDATE_DATE DESC
                    ) TONE
            ),
            TYPE_TWO AS(
                SELECT
                    2					AS type,
                    REPLACE('2.'+STR(B.BRANCH_ID),' ','')		AS 'key_',
                    B.BRANCH_NAME		AS name,
                    REPLACE('1.'+STR(C.COMP_ID),' ','')		AS parent,
                    NULL				AS hierarchy
                    ,B.BRANCH_ID
	                ,B.UPDATE_DATE
                    <cfif IsNumeric(arguments.manager_nr)>
                        ,(E.EMPLOYEE_NAME + ' ' + E.EMPLOYEE_SURNAME) AS manager
                        <cfif arguments.is_photo eq 1>,(CASE WHEN E.PHOTO IS NOT NULL AND LEN(E.PHOTO) > 0 THEN '/documents/hr/' + E.PHOTO ELSE NULL END) AS photo</cfif>
                        <cfif arguments.is_position eq 1>,EP.POSITION_NAME	AS title</cfif>
                        <cfif arguments.is_position_type eq 1>,PC.POSITION_CAT 	AS POSITION_CAT</cfif>
                        <cfif arguments.is_title eq 1>,PT.TITLE  AS title_id</cfif>
                    <cfelse>
                        ,NULL				AS manager
                        <cfif arguments.is_photo eq 1>,NULL AS photo</cfif>
                        <cfif arguments.is_position eq 1>,NULL AS title</cfif>
                        <cfif arguments.is_position_type eq 1>,NULL	AS POSITION_CAT</cfif>
                        <cfif arguments.is_title eq 1>,NULL 	AS title_id</cfif>
                    </cfif>
                FROM
                    BRANCH_HISTORY B
                    <cfif IsNumeric(arguments.manager_nr)>
                        LEFT JOIN EMPLOYEE_POSITIONS EP ON (@managerNr = 1 AND EP.POSITION_CODE = B.ADMIN1_POSITION_CODE OR @managerNr = 2 AND EP.POSITION_CODE = B.ADMIN2_POSITION_CODE)
                        LEFT JOIN EMPLOYEES E ON E.EMPLOYEE_ID = EP.EMPLOYEE_ID
                        LEFT JOIN SETUP_POSITION_CAT PC ON PC.POSITION_CAT_ID = EP.POSITION_CAT_ID
                        LEFT JOIN SETUP_TITLE PT ON PT.TITLE_ID = EP.TITLE_ID
                    </cfif> ,
                    OUR_COMPANY_HISTORY C
                    LEFT JOIN SETUP_HEADQ_HISTORY H ON C.HEADQUARTERS_ID = H.HEADQUARTERS_ID
                WHERE
                    C.IS_ORGANIZATION = 1 AND COMP_STATUS = 1 AND
                    B.IS_ORGANIZATION = 1 AND BRANCH_STATUS = 1 AND
                    B.COMPANY_ID = C.COMP_ID AND
                    (@headQuarterID IS NULL OR H.HEADQUARTERS_ID = @headQuarterID) 
                    AND H.RECORD_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#arguments.organization_date#">
                    AND C.UPDATE_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#arguments.organization_date#">
                    AND B.UPDATE_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#arguments.organization_date#">
                    <cfif IsNumeric(arguments.company_id)>
                    AND (@companyID IS NULL OR C.COMP_ID = @companyID) 
                    </cfif>
                    <cfif isdefined("arguments.branch_id") and len(arguments.branch_id)>
                        AND (@branchID IS NULL OR B.BRANCH_ID = @branchID)
                    </cfif>
            ), 
            TYPE_TWO_LAST AS(
            SELECT TYPETWO.* FROM (SELECT DISTINCT BRANCH_ID FROM TYPE_TWO) TTWO
                CROSS APPLY(
                        SELECT 	TOP 1 *	FROM TYPE_TWO TYT WHERE TYT.BRANCH_ID = TTWO.BRANCH_ID AND  TYT.UPDATE_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#arguments.organization_date#">	ORDER BY TYT.UPDATE_DATE DESC
                    ) TYPETWO
            ),
            TYPE_TREE AS (
                SELECT
                    3					AS type,
                    REPLACE('3.'+STR(D.DEPARTMENT_ID),' ','')	AS 'key_',
                    D.DEPARTMENT_HEAD	AS name,
                    REPLACE('2.'+STR(B.BRANCH_ID),' ','')		AS parent,
                    HIERARCHY_DEP_ID	AS hierarchy
                    ,d.DEPARTMENT_ID,
	                D.UPDATE_DATE
                    ,D.IS_ORGANIZATION,
                    DEPARTMENT_STATUS
                    <cfif IsNumeric(arguments.manager_nr)>
                        ,(E.EMPLOYEE_NAME + ' ' + E.EMPLOYEE_SURNAME) AS manager
                        <cfif arguments.is_photo eq 1>
                            ,(
                                CASE 
                                    WHEN E.PHOTO IS NOT NULL AND LEN(E.PHOTO) > 0 
                                        THEN '/documents/hr/'+E.PHOTO 
                                    WHEN E.PHOTO IS NULL AND ED.SEX = 0
                                        THEN  '/images/female.jpg'
                                ELSE '/images/male.jpg' END
                            ) AS photo
                        </cfif>
                        <cfif arguments.is_position eq 1>,EP.POSITION_NAME AS title</cfif>
                        <cfif arguments.is_position_type eq 1>,PC.POSITION_CAT 	AS POSITION_CAT</cfif>
                        <cfif arguments.is_title eq 1>,PT.TITLE 	AS title_id</cfif>
                    <cfelse>
                        ,NULL				AS manager
                        <cfif arguments.is_photo eq 1>,NULL	AS photo</cfif>
                        <cfif arguments.is_position eq 1>,NULL AS title</cfif>
                        <cfif arguments.is_position_type eq 1>,NULL AS POSITION_CAT</cfif>
                        <cfif arguments.is_title eq 1>,NULL AS title_id</cfif>
                    </cfif>
                FROM
                    DEPARTMENT_HISTORY D
                    <cfif IsNumeric(arguments.manager_nr)>
                        LEFT JOIN EMPLOYEE_POSITIONS EP ON (@managerNr = 1 AND EP.POSITION_CODE = D.ADMIN1_POSITION_CODE OR @managerNr = 2 AND EP.POSITION_CODE = D.ADMIN2_POSITION_CODE)
                        LEFT JOIN EMPLOYEES E ON E.EMPLOYEE_ID = EP.EMPLOYEE_ID
                        LEFT JOIN SETUP_POSITION_CAT PC ON PC.POSITION_CAT_ID = EP.POSITION_CAT_ID
                        LEFT JOIN SETUP_TITLE PT ON PT.TITLE_ID = EP.TITLE_ID
                        LEFT JOIN EMPLOYEES_DETAIL ED ON ED.EMPLOYEE_ID = E.EMPLOYEE_ID
                    </cfif> ,
                    BRANCH_HISTORY B,
                    OUR_COMPANY_HISTORY C
                    LEFT JOIN SETUP_HEADQ_HISTORY H ON C.HEADQUARTERS_ID = H.HEADQUARTERS_ID
                WHERE
                    D.BRANCH_ID = B.BRANCH_ID AND
                    B.IS_ORGANIZATION = 1 AND BRANCH_STATUS = 1 AND
                    B.COMPANY_ID = C.COMP_ID AND
                    H.RECORD_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#arguments.organization_date#"> AND
                    C.UPDATE_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#arguments.organization_date#"> AND
                    B.UPDATE_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#arguments.organization_date#"> AND
                    D.UPDATE_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#arguments.organization_date#"> AND
                    (@headQuarterID IS NULL OR H.HEADQUARTERS_ID = @headQuarterID) 
                    <cfif IsNumeric(arguments.company_id)>
                        AND (@companyID IS NULL OR C.COMP_ID = @companyID) 
                    </cfif>
                    <cfif isdefined("arguments.branch_id") and len(arguments.branch_id)>
                        AND (@branchID IS NULL OR B.BRANCH_ID = @branchID) 
                    </cfif>
                    <cfif isdefined("arguments.department_id") and len(arguments.department_id)>
                        AND (@departmentID IS NULL OR D.DEPARTMENT_ID = @departmentID)
                    </cfif>
            ), 
            TYPE_TREE_LAST AS(
            SELECT CRS.* FROM (SELECT DISTINCT DEPARTMENT_ID FROM TYPE_TREE) DSL
                CROSS APPLY(
                        SELECT 	TOP 1 *	FROM TYPE_TREE CRS WHERE CRS.DEPARTMENT_ID = DSL.DEPARTMENT_ID AND  UPDATE_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#arguments.organization_date#">	ORDER BY UPDATE_DATE DESC
                    ) CRS
            )
            select TYPE, KEY_ as 'key', NAME, PARENT, hierarchy, MANAGER<cfif IsNumeric(arguments.manager_nr)><cfif arguments.is_photo eq 1>,photo</cfif><cfif arguments.is_position eq 1>,title</cfif><cfif arguments.is_position_type eq 1>,POSITION_CAT</cfif><cfif arguments.is_title eq 1>,title_id</cfif></cfif> from TYPE_ZERO_LAST
            UNION 
            select TYPE, KEY_ as 'key', NAME, PARENT, hierarchy, MANAGER<cfif IsNumeric(arguments.manager_nr)><cfif arguments.is_photo eq 1>,photo</cfif><cfif arguments.is_position eq 1>,title</cfif><cfif arguments.is_position_type eq 1>,POSITION_CAT</cfif><cfif arguments.is_title eq 1>,title_id</cfif></cfif> from TYPE_ONE_LAST
            UNION 
            select TYPE, KEY_ as 'key', NAME, PARENT, hierarchy, MANAGER<cfif IsNumeric(arguments.manager_nr)><cfif arguments.is_photo eq 1>,photo</cfif><cfif arguments.is_position eq 1>,title</cfif><cfif arguments.is_position_type eq 1>,POSITION_CAT</cfif><cfif arguments.is_title eq 1>,title_id</cfif></cfif> from TYPE_TWO_LAST
            UNION 
            select TYPE, KEY_ as 'key', NAME, PARENT, hierarchy, MANAGER<cfif IsNumeric(arguments.manager_nr)><cfif arguments.is_photo eq 1>,photo</cfif><cfif arguments.is_position eq 1>,title</cfif><cfif arguments.is_position_type eq 1>,POSITION_CAT</cfif><cfif arguments.is_title eq 1>,title_id</cfif></cfif> from  TYPE_TREE_LAST WHERE IS_ORGANIZATION = 1 AND DEPARTMENT_STATUS = 1
            ORDER BY TYPE
        </cfquery>
        <cfset result = returnData(serializeJSON(GET_SCHEMA))>
        <cfreturn Replace(serializeJSON(result),'//','')>
    </cffunction>
    
    <!--- GET HEADQUARTERS --->
    <cffunction name="getHeadquarters" access="remote" returntype="any" output="no">
    	<cfquery name="get_headquarters" datasource="#dsn#">
        	SELECT HEADQUARTERS_ID AS id, NAME AS name FROM SETUP_HEADQUARTERS WHERE IS_ORGANIZATION = 1 ORDER BY name
        </cfquery>
        
        <cfreturn get_headquarters>
    </cffunction>
    
    <!--- GET COMPANIES --->
    <cffunction name="getCompanies" access="remote" returntype="any" output="no">
    	<cfargument name="headquarter_id" type="any" required="no" default="">
    
    	<cfquery name="get_companies" datasource="#dsn#">
        	SELECT COMP_ID AS id, COMPANY_NAME AS name FROM OUR_COMPANY WHERE IS_ORGANIZATION = 1 AND COMP_STATUS = 1
			<cfif len(arguments.headquarter_id)>AND HEADQUARTERS_ID = #arguments.headquarter_id#</cfif>
            ORDER BY name
        </cfquery>
        
        <cfreturn get_companies>
    </cffunction>
    
    <!--- GET BRANCHES --->
    <cffunction name="getBranches" access="remote" returntype="any" output="no">
    	<cfargument name="headquarter_id" type="any" required="no" default="">
        <cfargument name="company_id" type="any" required="no" default="">
    
    	<cfquery name="get_branches" datasource="#dsn#">
        	SELECT BRANCH_ID AS id, BRANCH_NAME AS name, B.COMPANY_ID AS parentID FROM BRANCH B, OUR_COMPANY C WHERE B.COMPANY_ID = C.COMP_ID AND C.IS_ORGANIZATION = 1 AND C.COMP_STATUS = 1 AND B.IS_ORGANIZATION = 1 AND B.BRANCH_STATUS = 1
			<cfif len(arguments.headquarter_id)>AND C.HEADQUARTERS_ID = #arguments.headquarter_id#</cfif>
            <cfif len(arguments.company_id)>AND B.COMPANY_ID = #arguments.company_id#</cfif>
            ORDER BY name
        </cfquery>
        
        <cfreturn get_branches>
    </cffunction>
    
    <!--- GET DEPARTMENTS --->
    <cffunction name="getDepartments" access="remote" returntype="any" output="no">
    	<cfargument name="headquarter_id" type="any" required="no" default="">
        <cfargument name="company_id" type="any" required="no" default="">
        <cfargument name="branch_id" type="any" required="no" default="">
    
    	<cfquery name="get_departments" datasource="#dsn#">
        	SELECT DEPARTMENT_ID AS id, DEPARTMENT_HEAD AS name, B.BRANCH_ID AS parentID FROM DEPARTMENT D, BRANCH B, OUR_COMPANY C WHERE D.BRANCH_ID = B.BRANCH_ID AND B.COMPANY_ID = C.COMP_ID AND C.IS_ORGANIZATION = 1 AND C.COMP_STATUS = 1 AND B.IS_ORGANIZATION = 1 AND B.BRANCH_STATUS = 1 AND D.IS_ORGANIZATION = 1 AND D.DEPARTMENT_STATUS = 1
			<cfif len(arguments.headquarter_id)>AND C.HEADQUARTERS_ID = #arguments.headquarter_id#</cfif>
            <cfif len(arguments.company_id)>AND B.COMPANY_ID = #arguments.company_id#</cfif>
            <cfif len(arguments.branch_id)>AND B.BRANCH_ID = #arguments.branch_id#</cfif>
            ORDER BY name
        </cfquery>
        
        <cfreturn get_departments>
    </cffunction>
</cfcomponent>