<cfcomponent output="no" extends = "paramsControl">

    <cfset dsn = this.getdsn()>
    
    <!--- TEST --->
	<cffunction name="test" access="remote" returntype="string">
		<cfreturn "Production Station Graph component is accessible.">
	</cffunction>
    
    <!--- GET LANGUAGE SET --->
    <cffunction name="getLangSet" access="remote" returntype="array" output="no">
    	<cfargument name="lang" type="string" required="yes">
        <cfargument name="numbers" type="string" required="yes">
    
    	<cfset lang_component = CreateObject("component", "language")>
		<cfreturn lang_component.getLanguageSet(arguments.lang, arguments.numbers)>
    </cffunction>
    
    <!--- GET BRANCH LIST --->
    <cffunction name="getBranchs" access="remote" returntype="query" output="no">
        <cfargument name="user_id" type="any" required="yes">
        
        <cfquery name="get_branchs" datasource="#dsn#">
        	SELECT 
                B.BRANCH_ID 	AS id, 
                B.BRANCH_NAME AS name 
            FROM 
                BRANCH B,
                EMPLOYEES E,
                EMPLOYEE_POSITIONS EP,
                EMPLOYEE_POSITION_BRANCHES EPB
            WHERE 
                EPB.BRANCH_ID = B.BRANCH_ID AND
                EPB.POSITION_CODE = EP.POSITION_CODE AND
                EP.EMPLOYEE_ID = E.EMPLOYEE_ID AND
                E.EMPLOYEE_ID = #arguments.user_id#
            ORDER BY 
                BRANCH_NAME;
        </cfquery>
        
        <cfreturn get_branchs>
    </cffunction>
    
    <!--- GET STATIONS --->
	<cffunction name="getStations" access="remote" returntype="array" output="no">
        <cfargument name="branch_id" type="string" required="yes">
        <cfargument name="company_id" type="string" required="yes">
        
        <cfquery name="get_list" datasource="#dsn#">
            SELECT
                WS.STATION_ID,
                WS.BRANCH,
                WS.DEPARTMENT,
                WS.STATION_NAME,
                WS.UP_STATION,
                BRANCH.BRANCH_ID,
                BRANCH.BRANCH_NAME,
                DEPARTMENT.DEPARTMENT_HEAD,
                (SELECT STATION_NAME FROM #dsn#_#arguments.company_id#.WORKSTATIONS WHERE STATION_ID = WS.UP_STATION) AS UP_STATION_NAME
            FROM
                #dsn#_#arguments.company_id#.WORKSTATIONS AS WS,
                BRANCH AS BRANCH,
                DEPARTMENT AS DEPARTMENT
            WHERE
                WS.BRANCH = BRANCH.BRANCH_ID AND
                WS.DEPARTMENT = DEPARTMENT.DEPARTMENT_ID AND
                BRANCH.BRANCH_ID = #arguments.branch_id#
            ORDER BY
                UP_STATION_NAME DESC
        </cfquery>

        <cfset departments = ArrayNew(1)>
        <cfset assigned_departments = "">
        <cfloop query="get_list">
           	<cfset department_index = listfind(assigned_departments, get_list.DEPARTMENT, ",")>
            <cfif department_index eq 0>
                <cfset assigned_departments = listappend(assigned_departments, get_list.DEPARTMENT, ",")>
                <cfset _department = StructNew()>
                <cfset _department.id = 1>
                <cfset _department["id"] = get_list.DEPARTMENT>
                <cfset _department["name"] = get_list.DEPARTMENT_HEAD>
                <cfset _department["stations"] = ArrayNew(1)>
                <cfset departments[arraylen(departments) + 1] = _department>
                <cfset target_department_index = arraylen(departments)>
            <cfelse>
                <cfset target_department_index = department_index>
            </cfif>
            
            <cfset target_station_index = arraylen(departments[target_department_index].stations) + 1>
			<cfset station = StructNew()>
            <cfset station["id"] = get_list.STATION_ID>
            <cfset station["name"] = get_list.STATION_NAME>
            <cfset station["upStationID"] = get_list.UP_STATION>
            <cfset station["upStationName"] = get_list.UP_STATION_NAME>
            <cfset departments[target_department_index].stations[target_station_index] = station>
        </cfloop>
        
        <cfreturn departments>
    </cffunction>
</cfcomponent>