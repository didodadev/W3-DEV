<cfcomponent output="no" extends = "paramsControl">

    <cfset dsn = this.getdsn()>
    
    <!--- TEST --->
	<cffunction name="test" access="remote" returntype="string">
		<cfreturn "Organization Schema component is accessible.">
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
    
    <!--- GET EMPLOYEE SCHEMA --->
    <cffunction name="getSchema" access="remote" returntype="any" output="no">
        <cfargument name="position_code" type="numeric" required="yes">
        <cfargument name="relation_type" type="numeric" required="yes"><!-- 1 = administrative, 2 = functional -->
        <cfargument name="up_step_count" type="numeric" required="no" default="0"><!-- if -1, = unlimited -->
        <cfargument name="down_step_count" type="numeric" required="no" default="0"><!-- if -1, = unlimited -->
        <cfargument name="company_id" type="any" required="no" default="NULL"><!-- NULL means all -->
        
        <cfquery name="get_schema" datasource="#dsn#">
            /*	Define vars	*/
            
            DECLARE @lastRowNum int;
            SET @lastRowNum = 0;
            DECLARE @totalRows int;
            SET @totalRows = 0;
            DECLARE @companyID int;
            SET @companyID = #arguments.company_id#;
            DECLARE @targetPositionCode int;
            SET @targetPositionCode = #arguments.position_code#;
            DECLARE @currentPositionCode int;
            SET @currentPositionCode = @targetPositionCode;
            DECLARE @currentUpperLevel int;
            SET @currentUpperLevel = 1;
            DECLARE @currentDownerLevel int;
            SET @currentDownerLevel = 1;
            DECLARE @maxUpperLevel int;
            SET @maxUpperLevel = #arguments.up_step_count#;
            DECLARE @maxDownerLevel int;
            SET @maxDownerLevel = #arguments.down_step_count#;
            DECLARE @relationType int;		-- 1: administrative, 2: functional
            SET @relationType = #arguments.relation_type#;
            DECLARE @foundPositions TABLE
            (
                rowNum int,
                photo nvarchar(max),
                isCritical bit,
                department nvarchar(max),
                positionName nvarchar(max),
                positionType nvarchar(max),
                positionTitle nvarchar(max),
                name nvarchar(max),
                surname nvarchar(max),
                employeeID int,
                positionCode int,
                upperPositionCode int,
                posLevel int,
                done bit,
                isConnectedHorizontal bit
            )
            
            /*	Get self and upper positions	*/
            
            GET_SELF_OR_UPPER:
                INSERT INTO @foundPositions
                SELECT
                    ROW_NUMBER() OVER(ORDER BY EP.POSITION_ID) + @lastRowNum AS rowNum,
                    (SELECT PHOTO FROM EMPLOYEES WHERE EMPLOYEE_ID = EP.EMPLOYEE_ID) AS PHOTO,
                    EP.IS_CRITICAL,
                    D.DEPARTMENT_HEAD,
                    EP.POSITION_NAME,
                    PC.POSITION_CAT,
                    PT.TITLE,
                    EP.EMPLOYEE_NAME,
                    EP.EMPLOYEE_SURNAME,
                    EP.EMPLOYEE_ID,
                    EP.POSITION_CODE,
                    (
                        CASE WHEN @relationType = 1 THEN
                            EP.UPPER_POSITION_CODE
                        ELSE
                            EP.UPPER_POSITION_CODE2
                        END
                    ),
                    @currentUpperLevel,
                    0,
                    SOS.ORG_DSP
                FROM
                    EMPLOYEE_POSITIONS EP
                    LEFT JOIN SETUP_ORGANIZATION_STEPS SOS ON SOS.ORGANIZATION_STEP_ID = EP.ORGANIZATION_STEP_ID,
                    SETUP_POSITION_CAT PC,
                    SETUP_TITLE PT,
                    DEPARTMENT D
                WHERE
                    EP.IS_ORG_VIEW = 1 AND EP.POSITION_STATUS = 1 AND
                    EP.POSITION_CAT_ID = PC.POSITION_CAT_ID AND
                    EP.TITLE_ID = PT.TITLE_ID AND
                    D.DEPARTMENT_ID = EP.DEPARTMENT_ID AND
                    --EP.EMPLOYEE_ID IS NOT NULL AND
                    (
                        EP.DEPARTMENT_ID IN (SELECT D.DEPARTMENT_ID FROM DEPARTMENT D, BRANCH B WHERE D.BRANCH_ID = B.BRANCH_ID AND B.COMPANY_ID = @companyID OR @companyID IS NULL) OR
                        @lastRowNum = 0	-- to keep target position in hierarchy even its company different from the target company
                    ) AND
                    EP.POSITION_CODE = @currentPositionCode
            
            SET @totalRows = (SELECT COUNT(positionCode) FROM @foundPositions);
            
            WHILE (@totalRows > 0 AND (SELECT TOP(1) upperPositionCode FROM @foundPositions WHERE upperPositionCode IS NOT NULL AND LEN(upperPositionCode) > 0 AND done = 0) > 0)
            BEGIN
                SET @currentPositionCode = (SELECT TOP(1) upperPositionCode FROM @foundPositions WHERE done = 0 AND (@maxUpperLevel = -1 OR posLevel <= @maxUpperLevel));
                SET @lastRowNum = @totalRows;
                UPDATE TOP(1) @foundPositions SET done = 1 WHERE done = 0;
                IF (@currentPositionCode IS NOT NULL AND LEN(@currentPositionCode) > 0) 
                BEGIN
                    SET @currentUpperLevel = @currentUpperLevel + 1;
                    GOTO GET_SELF_OR_UPPER;
                END
            END
            
            /*	Reset positions to loop again	*/
            
            UPDATE @foundPositions SET done = (CASE WHEN positionCode = @targetPositionCode THEN 0 ELSE 1 END);
            SET @lastRowNum = @totalRows;
            SET @currentPositionCode = @targetPositionCode;
            
            /*	Get downer positions	*/
            
            GET_DOWNER:
                IF (@maxDownerLevel > 0 OR @maxDownerLevel = -1)
                
                INSERT INTO @foundPositions
                SELECT
                    ROW_NUMBER() OVER(ORDER BY EP.POSITION_ID) + @lastRowNum AS rowNum,
                    (SELECT PHOTO FROM EMPLOYEES WHERE EMPLOYEE_ID = EP.EMPLOYEE_ID) AS PHOTO,
                    EP.IS_CRITICAL,
                    D.DEPARTMENT_HEAD,
                    EP.POSITION_NAME,
                    PC.POSITION_CAT,
                    PT.TITLE,
                    EP.EMPLOYEE_NAME,
                    EP.EMPLOYEE_SURNAME,
                    EP.EMPLOYEE_ID,
                    EP.POSITION_CODE,
                    (
                        CASE WHEN @relationType = 1 THEN
                            EP.UPPER_POSITION_CODE
                        ELSE
                            EP.UPPER_POSITION_CODE2
                        END
                    ),
                    @currentDownerLevel,
                    0,
                    SOS.ORG_DSP
                FROM
                    EMPLOYEE_POSITIONS EP
                    LEFT JOIN SETUP_ORGANIZATION_STEPS SOS ON SOS.ORGANIZATION_STEP_ID = EP.ORGANIZATION_STEP_ID,
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
                    (@relationType = 1 AND EP.UPPER_POSITION_CODE = @currentPositionCode OR @relationType = 2 AND EP.UPPER_POSITION_CODE2 = @currentPositionCode) AND
                    EP.POSITION_CODE NOT IN (SELECT positionCode FROM @foundPositions)
            
            SET @totalRows = (SELECT COUNT(positionCode) FROM @foundPositions);
            
            WHILE (@totalRows > 0 AND (SELECT TOP(1) positionCode FROM @foundPositions WHERE done = 0) > 0)
            BEGIN
                SET @currentPositionCode = (SELECT TOP(1) positionCode FROM @foundPositions WHERE done = 0 AND (@maxDownerLevel = -1 OR posLevel < @maxDownerLevel));
                SET @lastRowNum = @totalRows;
                UPDATE TOP(1) @foundPositions SET done = 1 WHERE done = 0;
                IF (@currentPositionCode IS NOT NULL AND LEN(@currentPositionCode) > 0)
                BEGIN
                    SET @currentDownerLevel = (SELECT posLevel FROM @foundPositions WHERE positionCode = @currentPositionCode) + 1;
                    GOTO GET_DOWNER;
                END
            END
            
            /*	Get results	*/
            
            SELECT (CASE WHEN photo IS NOT NULL AND LEN(photo) > 0 THEN '/documents/hr/' + photo ELSE NULL END) AS photo, isCritical, department, positionName, positionType, positionTitle, name, surname, employeeID, positionCode, upperPositionCode, isConnectedHorizontal FROM @foundPositions ORDER BY name, surname, positionName
        </cfquery>
    
        <cfreturn get_schema>
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
    <cffunction name="getOrganizationSchema" access="remote" returntype="any" output="no">
    	<cfargument name="manager_nr" type="any" required="no" default="NULL">
        <cfargument name="headquarter_id" type="any" required="no" default="NULL">
        <cfargument name="company_id" type="any" required="no" default="NULL">
        <cfargument name="branch_id" type="any" required="no" default="NULL">
        <cfargument name="department_id" type="any" required="no" default="NULL">
        
        <cfif arguments.headquarter_id is "NULL" and arguments.company_id is "NULL"><cfreturn "Atleast one of headquarters or companies must be selected to filter!"></cfif>
        
        <cfquery name="get_schema" datasource="#dsn#">
        	DECLARE @managerNr int = #arguments.manager_nr#;
        	DECLARE @headQuarterID int = #arguments.headquarter_id#;
            DECLARE @companyID int = #arguments.company_id#;
            DECLARE @branchID int = #arguments.branch_id#;
            DECLARE @departmentID int = #arguments.department_id#;
            DECLARE @skipHeadquarters bit = 0;
            
            IF (@headQuarterID IS NULL AND @companyID IS NOT NULL) SET @headQuarterID = (SELECT HEADQUARTERS_ID FROM OUR_COMPANY WHERE IS_ORGANIZATION = 1 AND COMP_ID = @companyID);
            IF (@headQuarterID IS NULL AND @companyID IS NOT NULL) SET @skipHeadquarters = 1; -- skip if the company is not related a headquarter
            
            SELECT
                0					AS type,
                H.HEADQUARTERS_ID	AS id,
                H.NAME				AS name,
                NULL				AS parentID,
                NULL				AS hierarchy,
                NULL				AS manager,
                NULL				AS photo,
                NULL				AS positionName,
                NULL			 	AS positionType,
                NULL 				AS positionTitle
            FROM
                SETUP_HEADQUARTERS H
            WHERE
            	H.IS_ORGANIZATION = 1 AND
                (@headQuarterID IS NULL OR H.HEADQUARTERS_ID = @headQuarterID) AND
                (@skipHeadquarters = 0 OR @skipHeadquarters = 1 AND H.HEADQUARTERS_ID = -1)
            UNION
            SELECT
                1					AS type,
                C.COMP_ID			AS id,
                C.COMPANY_NAME		AS name,
                H.HEADQUARTERS_ID	AS parentID,
                NULL				AS hierarchy
                <cfif IsNumeric(arguments.manager_nr)>
                    ,(E.EMPLOYEE_NAME + ' ' + E.EMPLOYEE_SURNAME) AS manager,
                    (CASE WHEN E.PHOTO IS NOT NULL AND LEN(E.PHOTO) > 0 THEN '/documents/hr/' + E.PHOTO ELSE NULL END) AS photo,
                    EP.POSITION_NAME	AS positionName,
                    PC.POSITION_CAT 	AS positionType,
                    PT.TITLE 			AS positionTitle
                <cfelse>
                	,NULL				AS manager,
                    NULL				AS photo,
                    NULL				AS positionName,
                    NULL			 	AS positionType,
                    NULL 				AS positionTitle
               	</cfif>
            FROM
                OUR_COMPANY C
                LEFT JOIN SETUP_HEADQUARTERS H ON C.HEADQUARTERS_ID = H.HEADQUARTERS_ID
                <cfif IsNumeric(arguments.manager_nr)>
                    LEFT JOIN EMPLOYEE_POSITIONS EP ON (@managerNr = 1 AND EP.POSITION_CODE = C.MANAGER_POSITION_CODE OR @managerNr = 2 AND EP.POSITION_CODE = C.MANAGER_POSITION_CODE2)
                    LEFT JOIN EMPLOYEES E ON E.EMPLOYEE_ID = EP.EMPLOYEE_ID
                    LEFT JOIN SETUP_POSITION_CAT PC ON PC.POSITION_CAT_ID = EP.POSITION_CAT_ID
                    LEFT JOIN SETUP_TITLE PT ON PT.TITLE_ID = EP.TITLE_ID
                </cfif>
            WHERE
            	C.IS_ORGANIZATION = 1 AND COMP_STATUS = 1 AND
                (@headQuarterID IS NULL OR C.HEADQUARTERS_ID = @headQuarterID) AND
                (@companyID IS NULL OR C.COMP_ID = @companyID)
            UNION
            SELECT
                2					AS type,
                B.BRANCH_ID			AS id,
                B.BRANCH_NAME		AS name,
                C.COMP_ID			AS parentID,
                NULL				AS hierarchy
                <cfif IsNumeric(arguments.manager_nr)>
                    ,(E.EMPLOYEE_NAME + ' ' + E.EMPLOYEE_SURNAME) AS manager,
                    (CASE WHEN E.PHOTO IS NOT NULL AND LEN(E.PHOTO) > 0 THEN '/documents/hr/' + E.PHOTO ELSE NULL END) AS photo,
                    EP.POSITION_NAME	AS positionName,
                    PC.POSITION_CAT 	AS positionType,
                    PT.TITLE 			AS positionTitle
                <cfelse>
                	,NULL				AS manager,
                    NULL				AS photo,
                    NULL				AS positionName,
                    NULL			 	AS positionType,
                    NULL 				AS positionTitle
               	</cfif>
            FROM
                BRANCH B
                <cfif IsNumeric(arguments.manager_nr)>
                    LEFT JOIN EMPLOYEE_POSITIONS EP ON (@managerNr = 1 AND EP.POSITION_CODE = B.ADMIN1_POSITION_CODE OR @managerNr = 2 AND EP.POSITION_CODE = B.ADMIN2_POSITION_CODE)
                    LEFT JOIN EMPLOYEES E ON E.EMPLOYEE_ID = EP.EMPLOYEE_ID
                    LEFT JOIN SETUP_POSITION_CAT PC ON PC.POSITION_CAT_ID = EP.POSITION_CAT_ID
                    LEFT JOIN SETUP_TITLE PT ON PT.TITLE_ID = EP.TITLE_ID
                </cfif> ,
                OUR_COMPANY C
                LEFT JOIN SETUP_HEADQUARTERS H ON C.HEADQUARTERS_ID = H.HEADQUARTERS_ID
            WHERE
            	C.IS_ORGANIZATION = 1 AND COMP_STATUS = 1 AND
            	B.IS_ORGANIZATION = 1 AND BRANCH_STATUS = 1 AND
                B.COMPANY_ID = C.COMP_ID AND
                (@headQuarterID IS NULL OR H.HEADQUARTERS_ID = @headQuarterID) AND
                (@companyID IS NULL OR C.COMP_ID = @companyID) AND
                (@branchID IS NULL OR B.BRANCH_ID = @branchID)
            UNION
            SELECT
                3					AS type,
                D.DEPARTMENT_ID		AS id,
                D.DEPARTMENT_HEAD	AS name,
                B.BRANCH_ID			AS parentID,
                HIERARCHY_DEP_ID	AS hierarchy
                <cfif IsNumeric(arguments.manager_nr)>
                    ,(E.EMPLOYEE_NAME + ' ' + E.EMPLOYEE_SURNAME) AS manager,
                    (CASE WHEN E.PHOTO IS NOT NULL AND LEN(E.PHOTO) > 0 THEN '/documents/hr/' + E.PHOTO ELSE NULL END) AS photo,
                    EP.POSITION_NAME	AS positionName,
                    PC.POSITION_CAT 	AS positionType,
                    PT.TITLE 			AS positionTitle
                <cfelse>
                	,NULL				AS manager,
                    NULL				AS photo,
                    NULL				AS positionName,
                    NULL			 	AS positionType,
                    NULL 				AS positionTitle
                </cfif>
            FROM
                DEPARTMENT D
                <cfif IsNumeric(arguments.manager_nr)>
                    LEFT JOIN EMPLOYEE_POSITIONS EP ON (@managerNr = 1 AND EP.POSITION_CODE = D.ADMIN1_POSITION_CODE OR @managerNr = 2 AND EP.POSITION_CODE = D.ADMIN2_POSITION_CODE)
                    LEFT JOIN EMPLOYEES E ON E.EMPLOYEE_ID = EP.EMPLOYEE_ID
                    LEFT JOIN SETUP_POSITION_CAT PC ON PC.POSITION_CAT_ID = EP.POSITION_CAT_ID
                    LEFT JOIN SETUP_TITLE PT ON PT.TITLE_ID = EP.TITLE_ID
                </cfif> ,
                BRANCH B,
                OUR_COMPANY C
                LEFT JOIN SETUP_HEADQUARTERS H ON C.HEADQUARTERS_ID = H.HEADQUARTERS_ID
            WHERE
            	D.IS_ORGANIZATION = 1 AND DEPARTMENT_STATUS = 1 AND
                D.BRANCH_ID = B.BRANCH_ID AND
                B.IS_ORGANIZATION = 1 AND BRANCH_STATUS = 1 AND
                B.COMPANY_ID = C.COMP_ID AND
                (@headQuarterID IS NULL OR H.HEADQUARTERS_ID = @headQuarterID) AND
                (@companyID IS NULL OR C.COMP_ID = @companyID) AND
                (@branchID IS NULL OR B.BRANCH_ID = @branchID) AND
                (@departmentID IS NULL OR D.DEPARTMENT_ID = @departmentID)
            ORDER BY
                type
        </cfquery>
        
        <cfreturn get_schema>
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