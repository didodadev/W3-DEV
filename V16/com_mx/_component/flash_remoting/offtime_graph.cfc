<cfcomponent output="no">
	<cfset dsn = application.systemParam.systemParam().dsn>
    
    <!--- TEST --->
	<cffunction name="test" access="remote" returntype="string">
		<cfreturn "Offtime Graph component is accessible.">
	</cffunction>
    
    <!--- GET LANGUAGE SET --->
    <cffunction name="getLangSet" access="remote" returntype="array" output="no">
    	<cfargument name="lang" type="string" required="yes">
        <cfargument name="numbers" type="string" required="yes">
    
    	<cfset lang_component = CreateObject("component", "language")>
		<cfreturn lang_component.getLanguageSet(arguments.lang, arguments.numbers)>
    </cffunction>
    
    <!--- GET OFFTIME LIST --->
    <cffunction name="getOfftimeList" access="remote" returntype="any" output="no">
    	<cfargument name="start_date" type="date" required="no">
        <cfargument name="finish_date" type="date" required="no">
        <cfargument name="keyword" type="string" required="no">
        <cfargument name="branch_id" type="numeric" required="no">
        <cfargument name="department_id" type="numeric" required="no">
        <cfargument name="employee_id" type="numeric" required="no">
        <cfargument name="employee_name" type="string" required="no">
        <cfargument name="offtime_type" type="numeric" required="no" default="0">
        <cfargument name="category_id" type="numeric" required="no">
        <cfargument name="validation" type="numeric" required="no" default="0">
        <cfargument name="parent_position_code" type="any" required="no" default="">
                
        <cfquery name="get_offtime_list" datasource="#dsn#">
            SELECT DISTINCT
                OFFTIME.VALID AS validateType, 
                OFFTIME.VALIDDATE AS validateDate, 
                OFFTIME.EMPLOYEE_ID AS employeeID, 
                OFFTIME.OFFTIME_ID AS id, 
                OFFTIME.STARTDATE AS startDate, 
                OFFTIME.FINISHDATE AS finishDate, 
                OFFTIME.WORK_STARTDATE AS workStartDate,
                OFFTIME.IS_ADDED_OFFTIME AS isTurnedToAnotherOfftime,
                OFFTIME.IS_PUANTAJ_OFF AS isFactorCredit,
                EMPLOYEES.EMPLOYEE_NAME AS employeeName, 
                EMPLOYEES.EMPLOYEE_SURNAME AS employeeSurname, 
                SETUP_OFFTIME.OFFTIMECAT AS category,
                OFFTIME.VALID_EMPLOYEE_ID_1,
                OFFTIME.VALID_EMPLOYEE_ID_2,
                OFFTIME.VALID_EMPLOYEE_ID,
                DEPARTMENT.DEPARTMENT_HEAD AS departmentName
            FROM 
                OFFTIME,
                SETUP_OFFTIME,
                EMPLOYEES,
                EMPLOYEE_POSITIONS,
                DEPARTMENT
            WHERE
            	OFFTIME.EMPLOYEE_ID = EMPLOYEES.EMPLOYEE_ID AND
                OFFTIME.OFFTIMECAT_ID = SETUP_OFFTIME.OFFTIMECAT_ID AND
                EMPLOYEES.EMPLOYEE_ID = EMPLOYEE_POSITIONS.EMPLOYEE_ID AND
                EMPLOYEE_POSITIONS.DEPARTMENT_ID = DEPARTMENT.DEPARTMENT_ID
                <cfif isDefined("arguments.parent_position_code") and len(arguments.parent_position_code)>
                	AND (EMPLOYEE_POSITIONS.UPPER_POSITION_CODE = #arguments.parent_position_code# OR EMPLOYEE_POSITIONS.UPPER_POSITION_CODE2 = #arguments.parent_position_code#)
                </cfif>
                <cfif arguments.offtime_type eq 1>
                    AND OFFTIME.RECORD_EMP = OFFTIME.EMPLOYEE_ID
                <cfelseif arguments.offtime_type eq 2>
                    AND OFFTIME.RECORD_EMP <> OFFTIME.EMPLOYEE_ID
                </cfif>
            <cfif isDefined("arguments.keyword") and len(arguments.keyword)>
                AND
                    (
                        <cfif database_type is "MSSQL">
                        EMPLOYEES.EMPLOYEE_NAME+' '+EMPLOYEES.EMPLOYEE_SURNAME LIKE '<cfif len(arguments.keyword) gt 2>%</cfif>#arguments.keyword#%'
                        <cfelseif database_type is "DB2">
                        EMPLOYEES.EMPLOYEE_NAME||' '||EMPLOYEES.EMPLOYEE_SURNAME LIKE '<cfif len(arguments.keyword) gt 2>%</cfif>#arguments.keyword#%'
                        </cfif>
                    )
            </cfif>
            <cfif isDefined("arguments.category_id") and len(arguments.category_id)>
                AND SETUP_OFFTIME.OFFTIMECAT_ID = #arguments.category_id#
            </cfif>
            <cfif isDefined("arguments.start_date")>
                <cfif len(arguments.start_date) AND len(arguments.finish_date)>
                AND
                (
                    (
                    OFFTIME.STARTDATE >= #arguments.start_date# AND
                    OFFTIME.STARTDATE <= #arguments.finish_date#
                    )
                OR
                    (
                    OFFTIME.STARTDATE <= #arguments.start_date# AND
                    OFFTIME.FINISHDATE >= #arguments.start_date#
                    )
                )
                <cfelseif len(arguments.start_date)>
                AND
                (
                OFFTIME.STARTDATE >= #arguments.start_date#
                OR
                    (
                    OFFTIME.STARTDATE < #arguments.start_date# AND
                    OFFTIME.FINISHDATE >= #arguments.start_date#
                    )
                )
                <cfelseif len(arguments.finish_date)>
                AND
                (
                OFFTIME.FINISHDATE <= #arguments.finish_date#
                OR
                    (
                    OFFTIME.STARTDATE <= #arguments.finish_date# AND
                    OFFTIME.FINISHDATE > #arguments.finish_date#
                    )
                )
                </cfif>
            </cfif>
            <cfif isDefined("arguments.department_id") and len(arguments.department_id)>
            --AND OFFTIME.EMPLOYEE_ID IN (SELECT EP.EMPLOYEE_ID FROM EMPLOYEE_POSITIONS EP,DEPARTMENT D WHERE EP.DEPARTMENT_ID = D.DEPARTMENT_ID AND D.DEPARTMENT_ID = #arguments.department_id# )
            AND DEPARTMENT.DEPARTMENT_ID = #arguments.department_id#
            </cfif>
            <cfif isdefined("arguments.branch_id") and len(arguments.branch_id)>
            AND 
            	(
                	DEPARTMENT.BRANCH_ID = #arguments.branch_id# AND
                    (
                    	OFFTIME.EMPLOYEE_ID IN (SELECT EMPLOYEE_ID FROM EMPLOYEES_IN_OUT WHERE BRANCH_ID = DEPARTMENT.BRANCH_ID <cfif isdefined("arguments.start_date") and isdate(arguments.start_date)>AND (START_DATE <= #arguments.start_date# AND (FINISH_DATE IS NULL OR FINISH_DATE >= #arguments.start_date#))</cfif>)
	                    OR
    	                OFFTIME.EMPLOYEE_ID IN (SELECT EP.EMPLOYEE_ID FROM EMPLOYEE_POSITIONS EP,DEPARTMENT D WHERE EP.DEPARTMENT_ID = D.DEPARTMENT_ID AND D.BRANCH_ID = DEPARTMENT.BRANCH_ID AND EP.IS_MASTER = 1)
                    )
                )
            </cfif>
            <cfif isdefined("arguments.employee_name") and len(arguments.employee_name) and isdefined("arguments.employee_id") and len(arguments.employee_id)>
                AND OFFTIME.EMPLOYEE_ID = #arguments.employee_id#
            </cfif>
            <cfif arguments.validation eq 1>
                AND	OFFTIME.VALID = 1
            <cfelseif arguments.validation eq 2> 
                AND	OFFTIME.VALID = 0
            <cfelseif arguments.validation eq 3> 
                AND	OFFTIME.VALID IS NULL
            </cfif>
            ORDER BY
                EMPLOYEES.EMPLOYEE_NAME, EMPLOYEES.EMPLOYEE_SURNAME, DEPARTMENT.DEPARTMENT_HEAD, OFFTIME.STARTDATE DESC
        </cfquery>
        
        <cfset result = StructNew()>
        <cfset result["employees"] = ArrayNew(1)>
        <cfset created_employees = "">
        <cfloop query="get_offtime_list">
	        <cfif len(get_offtime_list.VALID_EMPLOYEE_ID_1)>
                <cfquery name="get_first_chief" datasource="#dsn#">
                    SELECT
                        EMPLOYEE_NAME +' '+ EMPLOYEE_SURNAME AS nameAndSurname
                    FROM
                        EMPLOYEES
                    WHERE
                        EMPLOYEE_ID = #get_offtime_list.VALID_EMPLOYEE_ID_1#
                </cfquery>
            <cfelse>
            	<cfset get_first_chief.nameAndSurname = "">
			</cfif>
            
            <cfif len(get_offtime_list.VALID_EMPLOYEE_ID_2)>
                <cfquery name="get_second_chief" datasource="#dsn#">
                    SELECT
                        EMPLOYEE_NAME +' '+ EMPLOYEE_SURNAME AS nameAndSurname
                    FROM
                        EMPLOYEES
                    WHERE
                        EMPLOYEE_ID = #get_offtime_list.VALID_EMPLOYEE_ID_2#
                </cfquery>
            <cfelse>
            	<cfset get_second_chief.nameAndSurname = "">
			</cfif>
            
            <cfif len(get_offtime_list.VALID_EMPLOYEE_ID)>
                <cfquery name="get_validator" datasource="#dsn#">
                    SELECT
                        EMPLOYEE_NAME +' '+ EMPLOYEE_SURNAME AS nameAndSurname
                    FROM
                        EMPLOYEES
                    WHERE
                        EMPLOYEE_ID = #get_offtime_list.VALID_EMPLOYEE_ID#
                </cfquery>
            <cfelse>
            	<cfset get_validator.nameAndSurname = "">
			</cfif>
        	
            <cfscript>
				offtime = StructNew();
				offtime["validateType"] = get_offtime_list.validateType;
				offtime["validateDate"] = get_offtime_list.validateDate;
                offtime["id"] = get_offtime_list.id;
                offtime["employeeID"] = get_offtime_list.employeeID;
                offtime["startDate"] = get_offtime_list.startDate;
                offtime["finishDate"] = get_offtime_list.finishDate;
				offtime["workStartDate"] = get_offtime_list.workStartDate;
                offtime["isTurnedToAnotherOfftime"] = get_offtime_list.isTurnedToAnotherOfftime;
                offtime["isFactorCredit"] = get_offtime_list.isFactorCredit;
                offtime["category"] = get_offtime_list.category;
				offtime["chief1"] = get_first_chief.nameAndSurname;
				offtime["chief2"] = get_second_chief.nameAndSurname;
				offtime["validator"] = get_validator.nameAndSurname;
            </cfscript>
            
            <cfset emp_index = listfind(created_employees, get_offtime_list.employeeID, ",")>
            <cfif len(created_employees) and emp_index neq 0>
                <cfset result["employees"][emp_index].list[arraylen(result["employees"][emp_index].list) + 1] = offtime>
            <cfelse>
            	<cfscript>
					employee = StructNew();
					employee["id"] = get_offtime_list.employeeID;
					employee["name"] = get_offtime_list.employeeName;
					employee["surname"] = get_offtime_list.employeeSurname;
					employee["department"] = get_offtime_list.departmentName;
					employee["list"] = ArrayNew(1);
					employee["list"][arraylen(employee.list) + 1] = offtime;
					result["employees"][arraylen(result["employees"]) + 1] = employee;
					created_employees = listappend(created_employees, get_offtime_list.employeeID, ",");
                </cfscript>                
            </cfif>
        </cfloop>
        
        <!-- Get general offtime dates -->
        <cfquery name="get_general_offtime_dates" datasource="#dsn#">
        	SELECT 
                START_DATE AS startDate,
                FINISH_DATE AS finishDate,
                ISNULL(IS_HALFOFFTIME, 0) AS isHalf
            FROM 
                SETUP_GENERAL_OFFTIMES 	
            WHERE
                START_DATE >= #arguments.start_date# AND FINISH_DATE <= #arguments.finish_date#
            ORDER BY
                START_DATE
        </cfquery>
        <cfset result["generalOfftimes"] = get_general_offtime_dates>
        
        <cfreturn result>
    </cffunction>
    
    <!--- UPDATE OFFTIME  --->
    <cffunction name="updateOfftimes" access="remote" returntype="boolean" output="no">
    	<cfargument name="rec_emp_id" type="numeric" required="yes">
        <cfargument name="offtime_list" type="any" required="yes">
    
    	<cfloop from="1" to="#ArrayLen(arguments.offtime_list)#" index="i">
        	<cfset offtime = arguments.offtime_list[i]>
            <cfquery name="update_offtime" datasource="#dsn#">
                UPDATE
                    OFFTIME
                SET
                    STARTDATE = #offtime.startDate#,
                    FINISHDATE = #offtime.finishDate#,
                    WORK_STARTDATE = #offtime.workStartDate#,
                    UPDATE_DATE = #now()#,
                    UPDATE_EMP = #arguments.rec_emp_id#,
                    UPDATE_IP = '#cgi.REMOTE_ADDR#'
                WHERE
                    OFFTIME_ID = #offtime.id#
            </cfquery>
        </cfloop>
        
        <cfreturn true>
    </cffunction>
</cfcomponent>
