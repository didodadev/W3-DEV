<cfcomponent output="no">
	<cfset dsn = application.systemParam.systemParam().dsn>
    
    <!--- TEST --->
	<cffunction name="test" access="remote" returntype="string">
		<cfreturn "Workstation Reservation Graph component is accessible.">
	</cffunction>
    
    <!--- GET LANGUAGE SET --->
    <cffunction name="getLangSet" access="remote" returntype="array" output="no">
    	<cfargument name="lang" type="string" required="yes">
        <cfargument name="numbers" type="string" required="yes">
    
    	<cfset lang_component = CreateObject("component", "language")>
		<cfreturn lang_component.getLanguageSet(arguments.lang, arguments.numbers)>
    </cffunction>
    
    <!--- GET BRANCH LIST --->
    <cffunction name="getBranchList" access="remote" returntype="query" output="no">
		<cfargument name="position_code" type="any" required="yes">
    	<cfquery name="get_branch_list" datasource="#dsn#">
            SELECT
            	BRANCH_ID AS id,
                BRANCH_NAME AS name
        	FROM
            	BRANCH
			WHERE
				BRANCH_ID IN (SELECT BRANCH_ID FROM EMPLOYEE_POSITION_BRANCHES WHERE POSITION_CODE = #arguments.position_code#)
        	ORDER BY
            	BRANCH_NAME
        </cfquery>
        
        <cfreturn get_branch_list>
    </cffunction>
    
    <!--- GET DEPARTMENT LIST --->
    <cffunction name="getDepartmentList" access="remote" returntype="query" output="no">
    	<cfargument name="branch_id" type="string" required="yes">
    
    	<cfquery name="get_department_list" datasource="#dsn#">
            SELECT
            	DEPARTMENT_HEAD AS name,
                DEPARTMENT_ID AS id
			FROM
            	DEPARTMENT
			WHERE
            	DEPARTMENT_STATUS = 1 AND IS_PRODUCTION = 1 AND
				BRANCH_ID = #arguments.branch_id#
        </cfquery>
        
        <cfreturn get_department_list>
    </cffunction>
    
    <!--- GET STATION LIST --->
    <cffunction name="getStationList" access="remote" returntype="query" output="no">
    	<cfargument name="company_id" type="string" required="yes"><!-- dsn tespiti i�in g�nderilmesi zorunludur. -->
       	<cfargument name="branch_id" type="string" required="yes">
        <cfargument name="department_id" type="string" required="no">
    
    	<cfquery name="get_station_list" datasource="#dsn#_#company_id#">
            SELECT
            	STATION_ID AS id,
                STATION_NAME AS name
			FROM
            	WORKSTATIONS
			WHERE
            	BRANCH = #arguments.branch_id#
                AND UP_STATION IS NULL
                <cfif isDefined('arguments.department_id') and len(arguments.department_id)>
	            	AND DEPARTMENT = #arguments.department_id#
                </cfif>
        </cfquery>
        
        <cfreturn get_station_list>
    </cffunction>
    
    <!--- GET ASSETS --->
    <cffunction name="getAssets" access="remote" returntype="query" output="no">
    	<cfargument name="filter" type="string" required="yes">
    
    	<cfquery name="get_assets" datasource="#dsn#">
            SELECT
            	ASSETP_ID AS id,
                ASSETP AS name,
                SUP_COMPANY_ID AS compID,
                SUP_PARTNER_ID AS partnerID,
                PHYSICAL_ASSETS_WIDTH AS assetWidth,
                PHYSICAL_ASSETS_HEIGHT AS assetHeight,
                PHYSICAL_ASSETS_SIZE AS assetLength
			FROM
            	ASSET_P
			WHERE
            	ASSETP LIKE '%#arguments.filter#%'
        </cfquery>
        
        <cfreturn get_assets>
    </cffunction>
    
    <!--- GET RESERVATIONS --->
   <cffunction name="getReservations" access="remote" returntype="struct" output="no">
    	<cfargument name="company_id" type="string" required="yes"><!-- dsn tespiti i�in g�nderilmesi zorunludur. -->
        <cfargument name="branch_id" type="string" required="no">
        <cfargument name="department_id" type="string" required="no">
        <cfargument name="station_id" type="string" required="no">
        <cfargument name="start_date" type="date" required="yes">
        <cfargument name="finish_date" type="date" required="yes">
        <cfargument name="time_zone" type="numeric" required="yes">
		<cfargument name="position_code" type="any" required="yes">
        <cfargument name="asset_id" type="any" required="no">
        
        <cfif isdefined('arguments.asset_id') and len(arguments.asset_id)>
        	<cfquery name="get_asset_properties" datasource="#dsn#">
            	SELECT
                	ASSETP AS name,
                    SUP_COMPANY_ID AS compID,
                    SUP_PARTNER_ID AS partnerID,
                	PHYSICAL_ASSETS_WIDTH AS assetWidth,
                	PHYSICAL_ASSETS_HEIGHT AS assetHeight,
                	PHYSICAL_ASSETS_SIZE AS assetLength
				FROM
                	ASSET_P
				WHERE
                	ASSETP_ID = #arguments.asset_id#
            </cfquery>
        </cfif> 
        
        <cfquery name="get_workstations" datasource="#dsn#_#company_id#">
            SELECT 
                STATION_ID,
                STATION_NAME,
                ACTIVE,
                BRANCH,
                DEPARTMENT,
                WIDTH,
                HEIGHT,
                LENGTH,
                UP_STATION,
                (SELECT STATION_NAME FROM WORKSTATIONS WHERE STATION_ID = WS.UP_STATION) AS UP_STATION_NAME
            FROM
                WORKSTATIONS WS
            WHERE
                UP_STATION IS NOT NULL AND 
				BRANCH IN (SELECT BRANCH_ID FROM #dsn#.EMPLOYEE_POSITION_BRANCHES WHERE POSITION_CODE = #arguments.position_code#)
				<cfif isdefined('arguments.branch_id') or isdefined('arguments.department_id') or isdefined('arguments.station_id') or isdefined('get_asset_properties')>
					<cfif isdefined('arguments.branch_id') and len(arguments.branch_id)>AND BRANCH = #arguments.branch_id#</cfif>
					<cfif isdefined('arguments.department_id') and len(arguments.department_id)>AND DEPARTMENT = #arguments.department_id#</cfif>
					<cfif isdefined('arguments.station_id') and len(arguments.station_id)>AND UP_STATION = #arguments.station_id#</cfif>
					<cfif isdefined('get_asset_properties') and get_asset_properties.recordcount gt 0>
						<cfif len(get_asset_properties.assetWidth)>AND WIDTH >= #get_asset_properties.assetWidth#</cfif>
						<cfif len(get_asset_properties.assetHeight)>AND HEIGHT >= #get_asset_properties.assetHeight#</cfif>
						<cfif len(get_asset_properties.assetLength)>AND LENGTH >= #get_asset_properties.assetLength#</cfif>
					</cfif>
                </cfif>
            ORDER BY
                WIDTH, HEIGHT, LENGTH
        </cfquery>
        
        <cfset result = StructNew()>
        <cfset result["workstations"] = ArrayNew(1)>
        
        <cfloop query="get_workstations">
        	<cfset station = StructNew()>
            <cfset station["id"] = get_workstations.STATION_ID>
            <cfset station["name"] = get_workstations.STATION_NAME>
            <cfset station["isActive"] = get_workstations.ACTIVE>
            <cfset station["branchID"] = get_workstations.BRANCH>
			<cfset station["departmentID"] = get_workstations.DEPARTMENT>
            <cfset station["upStationName"] = get_workstations.UP_STATION_NAME>
            <cfset station["wsWidth"] = get_workstations.WIDTH>
            <cfset station["wsHeight"] = get_workstations.HEIGHT>
            <cfset station["wsLength"] = get_workstations.LENGTH>
            
        	<cfquery name="get_reservations" datasource="#dsn#">
                SELECT 
                    DISTINCT
                        WR.WS_RESERVATION_ID AS id,
                        WR.WORKSTATION_ID AS stationID,
                        WR.STATE AS finalRegistration,
                        DATEADD(hour,-#arguments.time_zone#, WR.START_DATE) AS startDate,
                        DATEADD(hour,-#arguments.time_zone#, WR.FINISH_DATE) AS finishDate,
                        (SELECT STAGE FROM PROCESS_TYPE_ROWS WHERE PROCESS_ROW_ID = WR.RESERVATION_STAGE_ID) AS process,
                        AP.ASSETP AS asset,
                        AP.PHYSICAL_ASSETS_WIDTH AS assetWidth,
						AP.PHYSICAL_ASSETS_HEIGHT AS assetHeight,
						AP.PHYSICAL_ASSETS_SIZE AS assetLength
                    FROM	
                        WORKSTATION_RESERVATION WR,
                        ASSET_P AP
                    WHERE
                        AP.ASSETP_ID = WR.PSYCALASSET_ID AND
                        WR.WORKSTATION_ID = #station.id#
                        AND WR.START_DATE >= #arguments.start_date#
                        AND WR.FINISH_DATE <= #arguments.finish_date#
            </cfquery>
            
            <cfset station["reservations"] = get_reservations>
            <cfset result["workstations"][arraylen(result["workstations"]) + 1] = station>
            <cfif isdefined('get_asset_properties') and get_asset_properties.recordcount gt 0>
            	<cfset asset = StructNew()>
                <cfset asset["name"] = get_asset_properties.name>
                <cfset asset["compID"] = get_asset_properties.compID>
                <cfset asset["partnerID"] = get_asset_properties.partnerID>
                <cfset asset["width"] = get_asset_properties.assetWidth>
                <cfset asset["height"] = get_asset_properties.assetHeight>
                <cfset asset["length"] = get_asset_properties.assetLength>
                
                <cfset result["asset"] = asset>
			</cfif>
        </cfloop>
        
        <cfreturn result>
	</cffunction>
    
    <!--- UPDATE RESERVATION --->
    <cffunction name="updateReservation" access="remote" returntype="boolean" output="no">
    	<cfargument name="company_id" type="string" required="yes"><!-- dsn tespiti i�in g�nderilmesi zorunludur. -->
        <cfargument name="employee_id" type="numeric" required="yes">
    	<cfargument name="reservation_id" type="numeric" required="yes">
        <cfargument name="station_id" type="numeric" required="yes">
        <cfargument name="start_date" type="date" required="yes">
        <cfargument name="finish_date" type="date" required="yes">
    	
        <cfquery name="update_task" datasource="#dsn#">
            UPDATE
                WORKSTATION_RESERVATION
            SET
                START_DATE = #arguments.start_date#,
                FINISH_DATE = #arguments.finish_date#,
                WORKSTATION_ID = #arguments.station_id#,
                UPDATE_DATE = #now()#,
                UPDATE_EMP = #arguments.employee_id#,
                UPDATE_IP = '#cgi.REMOTE_ADDR#'
            WHERE
                WS_RESERVATION_ID = #arguments.reservation_id#
        </cfquery>
        
        <cfreturn true>
    </cffunction>
</cfcomponent>
