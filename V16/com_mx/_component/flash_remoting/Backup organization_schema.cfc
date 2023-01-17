<cfcomponent output="no">
	<cfset dsn = application.systemParam.systemParam().dsn>
    
    <!--- TEST --->
	<cffunction name="test" access="remote" returntype="string">
		<cfreturn "Organization Schema component is accessible.">
	</cffunction>
    
    <!--- GET LANGUAGE SET --->
    <cffunction name="getLangSet" access="remote" returntype="array" output="no">
    	<cfargument name="lang" type="string" required="yes">
        <cfargument name="numbers" type="string" required="yes">
    
    	<cfset lang_component = CreateObject("component", "language")>
		<cfreturn lang_component.getLanguageSet(arguments.lang, arguments.numbers)>
    </cffunction>
    
	<!--- GET POSITION(S) --->
    <cffunction name="getPositions" access="private" returntype="query" output="no">
        <cfargument name="position_code" type="numeric" required="no"><!-- returns position according to the code -->
        <cfargument name="upper_position_code" type="numeric" required="no"><!-- returns positions which upper position codes are equal to the code -->
        <cfargument name="upper_position_code_relation_type" type="numeric" required="no"><!-- 1 = administrative, 2 = functional -->
        <cfargument name="employee_id" type="numeric" required="no"><!-- returns position according to the employee id -->
        <cfargument name="filter" type="string" required="no"><!-- returns positions according to the filter -->
        
        <cfquery name="get_positions" datasource="#dsn#">	
            SELECT
            	EMPLOYEES.PHOTO,
                EMPLOYEE_POSITIONS.IS_VEKALETEN,
                EMPLOYEE_POSITIONS.IS_CRITICAL,
                EMPLOYEE_POSITIONS.POSITION_NAME,
                EMPLOYEE_POSITIONS.EMPLOYEE_NAME,
                EMPLOYEE_POSITIONS.EMPLOYEE_SURNAME,
                EMPLOYEE_POSITIONS.EMPLOYEE_ID,
                EMPLOYEE_POSITIONS.POSITION_ID,
                EMPLOYEE_POSITIONS.POSITION_CODE,
                EMPLOYEE_POSITIONS.UPPER_POSITION_CODE,
                EMPLOYEE_POSITIONS.UPPER_POSITION_CODE2,
                SETUP_POSITION_CAT.POSITION_CAT,
                SETUP_TITLE.TITLE
            FROM
            	EMPLOYEES, 
                EMPLOYEE_POSITIONS,
                SETUP_POSITION_CAT,
                SETUP_TITLE
            WHERE
            	EMPLOYEES.EMPLOYEE_ID = EMPLOYEE_POSITIONS.EMPLOYEE_ID AND
                EMPLOYEE_POSITIONS.IS_ORG_VIEW = 1 AND
                EMPLOYEE_POSITIONS.TITLE_ID = SETUP_TITLE.TITLE_ID AND
                EMPLOYEE_POSITIONS.POSITION_CAT_ID = SETUP_POSITION_CAT.POSITION_CAT_ID AND
                <cfif isDefined('arguments.position_code') and len(arguments.position_code)>
                    EMPLOYEE_POSITIONS.POSITION_CODE = #arguments.position_code# AND
                </cfif>
                <cfif isDefined('arguments.filter')>
                	(
                        EMPLOYEE_POSITIONS.POSITION_NAME LIKE '%#arguments.filter#%' OR	
                        EMPLOYEE_POSITIONS.EMPLOYEE_NAME + ' ' + EMPLOYEE_POSITIONS.EMPLOYEE_SURNAME LIKE '%#arguments.filter#%'
                    ) AND
				</cfif>
                <cfif isDefined('arguments.upper_position_code') and len(arguments.upper_position_code)>
                	<cfif upper_position_code_relation_type eq 1>
	                    EMPLOYEE_POSITIONS.UPPER_POSITION_CODE = #arguments.upper_position_code# AND
					<cfelse>
                    	EMPLOYEE_POSITIONS.UPPER_POSITION_CODE2 = #arguments.upper_position_code# AND
                    </cfif>
                </cfif>
                <cfif isDefined('arguments.employee_id') and len(arguments.employee_id)>
                    EMPLOYEE_POSITIONS.EMPLOYEE_ID = #arguments.employee_id#
                <cfelse>
                    EMPLOYEE_POSITIONS.EMPLOYEE_ID > 0
                </cfif>
			ORDER BY
            	EMPLOYEE_POSITIONS.EMPLOYEE_NAME, EMPLOYEE_POSITIONS.EMPLOYEE_SURNAME, EMPLOYEE_POSITIONS.POSITION_NAME
        </cfquery>
        
        <cfreturn get_positions> 
    </cffunction>
    
    <!--- GET POSITION AS OBJECT FROM A QUERY --->
    <cffunction name="getPositionQueryAsObject" access="private" returntype="struct" output="no">
        <cfargument name="target_query" type="query" required="yes">
        <cfargument name="upper_relation_type" type="numeric" required="no" defafult="1"><!-- 1 = administrative, 2 = functional -->
        <cfargument name="level" type="numeric" required="no" default="0">
        
        <cfscript>
            obj = StructNew();
            obj["positionCode"] = target_query.POSITION_CODE;
			if (isDefined('arguments.upper_relation_type'))
			{
				if (arguments.upper_relation_type eq 1)
				{
					obj["upperPositionCode"] = target_query.UPPER_POSITION_CODE;
				} else {
					obj["upperPositionCode"] = target_query.UPPER_POSITION_CODE2;
				}
			}
            obj["employeeID"] = target_query.EMPLOYEE_ID;
            obj["name"] = target_query.EMPLOYEE_NAME;
            obj["surname"] = target_query.EMPLOYEE_SURNAME;
			obj["positionName"] = target_query.POSITION_NAME;
            obj["isCritical"] = target_query.IS_CRITICAL;
            obj["level"] = arguments.level;
			obj["photo"] = "/documents/hr/#target_query.PHOTO#";
        </cfscript>
        
        <cfreturn obj>
    </cffunction>
    
    <!--- GET EMPLOYEE SCHEMA --->
    <cffunction name="getSchema" access="remote" returntype="array" output="no">
        <cfargument name="employee_id" type="numeric" required="yes">
        <cfargument name="relation_type" type="numeric" required="yes"><!-- 1 = administrative, 2 = functional -->
        <cfargument name="up_step_count" type="numeric" required="no" default="0"><!-- if 0, = unlimited -->
        <cfargument name="down_step_count" type="numeric" required="no" default="0"><!-- if 0, = unlimited -->
        
        <cfset list = ArrayNew(1)>
        <cfset id_list = "">
        
        <!-- Get position -->
        <cfset pos = getPositions(employee_id: arguments.employee_id)>
        <cfset list[ArrayLen(list) + 1] = getPositionQueryAsObject(pos, arguments.relation_type)>
        <cfset id_list = ListAppend(id_list, list[ArrayLen(list)].positionCode, ',')>
    
        <!-- Get uppers -->
        <cfif arguments.up_step_count eq 0>
            <cfloop condition="arguments.relation_type eq 1 and len(pos.UPPER_POSITION_CODE) and ListFind(id_list, pos.UPPER_POSITION_CODE, ',') eq 0 or arguments.relation_type eq 2 and len(pos.UPPER_POSITION_CODE2) and ListFind(id_list, pos.UPPER_POSITION_CODE2, ',') eq 0">
            	<cfif arguments.relation_type eq 1>
					<cfset pos = getPositions(position_code: pos.UPPER_POSITION_CODE)>
				<cfelse>
                	<cfset pos = getPositions(position_code: pos.UPPER_POSITION_CODE2)>
				</cfif>
                <cfset list[ArrayLen(list) + 1] = getPositionQueryAsObject(pos, arguments.relation_type)>
                <cfset id_list = ListAppend(id_list, list[ArrayLen(list)].positionCode, ',')>
            </cfloop>
        <cfelse>
            <cfloop from="1" to="#arguments.up_step_count#" index="i">
                <cfif arguments.relation_type eq 1 and len(pos.UPPER_POSITION_CODE) and ListFind(id_list, pos.UPPER_POSITION_CODE, ',') eq 0 or arguments.relation_type eq 2 and len(pos.UPPER_POSITION_CODE2) and ListFind(id_list, pos.UPPER_POSITION_CODE2, ',') eq 0>
                	<cfif arguments.relation_type eq 1>
						<cfset pos = getPositions(position_code: pos.UPPER_POSITION_CODE)>
                    <cfelse>
                        <cfset pos = getPositions(position_code: pos.UPPER_POSITION_CODE2)>
                    </cfif>
                    <cfset list[ArrayLen(list) + 1] = getPositionQueryAsObject(pos, arguments.relation_type)>
                    <cfset id_list = ListAppend(id_list, list[ArrayLen(list)].positionCode, ',')>
                <cfelse>
                    <cfbreak>
                </cfif>
            </cfloop>
        </cfif>
        <cfset list[ArrayLen(list)].upperPositionCode = "">
        
        <!-- Get downers -->
        <cfset level = 1>
        <cfset sublist = ArrayNew(1)>
        <cfset pos = getPositions(employee_id: arguments.employee_id)>
        <cfset pos_list = getPositions(upper_position_code: pos.POSITION_CODE, upper_position_code_relation_type: arguments.relation_type)>
        
        <cfloop query="pos_list">
        	<cfif ListFind(id_list, POSITION_CODE, ',') eq 0>
	            <cfset sublist[ArrayLen(sublist) + 1] = getPositionQueryAsObject(pos_list, arguments.relation_type, level)>
            </cfif>
        </cfloop>
        
        <cfloop condition="ArrayLen(sublist) gt 0">
            <cfset new_pos = sublist[1]>
            <cfif arguments.down_step_count eq 0 or arguments.down_step_count gt 0 and new_pos.level lt arguments.down_step_count>
                <cfset pos_list = getPositions(upper_position_code: new_pos.positionCode, upper_position_code_relation_type: arguments.relation_type)>
                <cfloop query="pos_list">
                	<cfif ListFind(id_list, POSITION_CODE, ',') eq 0>
	                    <cfset sublist[ArrayLen(sublist) + 1] = getPositionQueryAsObject(pos_list, arguments.relation_type, new_pos.level + 1)>
					</cfif>
                </cfloop>
            </cfif>
            <cfscript>
                ArrayDeleteAt(sublist, 1);
                ArrayAppend(list, new_pos);
				id_list = ListAppend(id_list, list[ArrayLen(list)].positionCode, ',');
            </cfscript>
        </cfloop>
    
        <cfreturn list>
    </cffunction>
    
    <!--- FIND POSITIONS --->
    <cffunction name="findPositions" access="remote" returntype="query" output="no">
    	<cfargument name="filter" type="string" required="yes">
        
        <cfquery name="positions" datasource="#dsn#">
        	SELECT DISTINCT
                EMPLOYEE_POSITIONS.EMPLOYEE_ID employeeID,
                EMPLOYEE_POSITIONS.POSITION_NAME positionName,
                EMPLOYEE_POSITIONS.EMPLOYEE_NAME employeeName,
                EMPLOYEE_POSITIONS.EMPLOYEE_SURNAME employeeSurname,
                DEPARTMENT.DEPARTMENT_HEAD departmentName,
                BRANCH.BRANCH_NAME branchName,
                ZONE.ZONE_NAME zoneName
            FROM
                EMPLOYEE_POSITIONS,
                DEPARTMENT,
                BRANCH,		
                ZONE,
                OUR_COMPANY
            WHERE
                OUR_COMPANY.COMP_ID = BRANCH.COMPANY_ID AND
                EMPLOYEE_POSITIONS.DEPARTMENT_ID = DEPARTMENT.DEPARTMENT_ID AND
                DEPARTMENT.BRANCH_ID = BRANCH.BRANCH_ID AND
                BRANCH.ZONE_ID = ZONE.ZONE_ID AND
                EMPLOYEE_POSITIONS.POSITION_STATUS = 1 AND
                (
                    EMPLOYEE_POSITIONS.POSITION_NAME LIKE '%#arguments.filter#%' OR	
                    EMPLOYEE_POSITIONS.EMPLOYEE_NAME + ' ' + EMPLOYEE_POSITIONS.EMPLOYEE_SURNAME LIKE '%#arguments.filter#%'
                )
            ORDER BY 
                EMPLOYEE_POSITIONS.EMPLOYEE_NAME,
                EMPLOYEE_POSITIONS.EMPLOYEE_SURNAME,
                EMPLOYEE_POSITIONS.POSITION_NAME
        </cfquery>
        
        <cfreturn positions>
    </cffunction>
    
    <!--- FILTER POSITIONS --->
    <cffunction name="filterPositions" access="remote" returntype="array" output="no">
    	<cfargument name="filter" type="string" required="yes">
        
        <cfset result = getPositions(filter: arguments.filter)>
        <cfset list = ArrayNew(1)>
        <cfloop query="result">
        	<cfscript>
				pos = getPositionQueryAsObject(result);
				ArrayAppend(list, pos);
            </cfscript>
        </cfloop>
        
        <cfreturn list>
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
	                    UPPER_POSITION_CODE = <cfif arguments.list[i].reset eq 0><cfif len(#arguments.list[i].upperPositionCode#)>#arguments.list[i].upperPositionCode#<cfelse>NULL</cfif><cfelse>NULL</cfif>,
					<cfelse>
                    	UPPER_POSITION_CODE2 = <cfif arguments.list[i].reset eq 0><cfif len(#arguments.list[i].upperPositionCode#)>#arguments.list[i].upperPositionCode#<cfelse>NULL</cfif><cfelse>NULL</cfif>,
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
</cfcomponent>
