<cfcomponent output="no" extends = "paramsControl">

    <!---
	
	NOTES:
		- Marina Tasarimcisi 'nda marinalar subelere g�re gelir.
		- �st istasyon PONTON, alt istasyon ise BAGLAMA YERI 'ni temsil eder.
		- LOA boy (HEIGHT),
		- BEAM en (WIDTH),
		- DRAUGHT derinlik (LENGTH).
	
	 --->

    <cfset dsn = this.getdsn()>
    
    <!--- TEST --->
	<cffunction name="test" access="remote" returntype="string">
		<cfreturn "Warehouse Designer component is accessible.">
	</cffunction>
    
    <!--- GET LANGUAGE SET --->
    <cffunction name="getLangSet" access="remote" returntype="array" output="no">
    	<cfargument name="lang" type="string" required="yes">
        <cfargument name="numbers" type="string" required="yes">
    
    	<cfset lang_component = CreateObject("component", "language")>
		<cfreturn lang_component.getLanguageSet(arguments.lang, arguments.numbers)>
    </cffunction>
    
    <!--- GET GENERAL DATA --->
    <cffunction name="getGeneralData" access="remote" output="no">
    	<cfquery name="get_electric_types" datasource="#dsn#">
        	SELECT
            	ELECTRIC_TYPE_ID AS id,
                ELECTRIC_TYPE_NAME AS name
			FROM
            	SETUP_ELECTRIC_TYPE
			ORDER BY
            	ELECTRIC_TYPE_NAME
        </cfquery>
        <cfquery name="get_marina_part_types" datasource="#dsn#">
        	SELECT
            	TYPE_ID AS id,
                TYPE_NAME AS name
			FROM
            	SETUP_MARINA_PART_TYPES
        </cfquery>
        
        <cfset result["electric_types"] = get_electric_types>
        <cfset result["marina_part_types"] = get_marina_part_types>
        <cfreturn result>
    </cffunction>
    
    <!--- GET BRANCH LIST --->
    <cffunction name="getBranchList" access="remote" returntype="query" output="no">
    	<cfquery name="get_branch_list" datasource="#dsn#">
            SELECT
            	BRANCH_ID AS id,
                BRANCH_NAME AS name,
                '/documents/settings/' + ASSET_FILE_NAME2 AS sketch
        	FROM
            	BRANCH
        	ORDER BY
            	BRANCH_NAME
        </cfquery>
        
        <cfreturn get_branch_list>
    </cffunction>
    
    <!--- GET UP STATIONS --->
    <cffunction name="getUpStations" access="remote" returntype="any" output="no">
    	<cfargument name="company_id" type="any" required="yes">
        <cfargument name="branch_id" type="any" required="yes">
        <cfargument name="filter" type="any" required="yes" default="">
        
        <cfquery name="get_upstations" datasource="#dsn#_#arguments.company_id#">
        	SELECT
            	STATION_ID AS id,
                STATION_NAME AS name
			FROM
            	WORKSTATIONS
			WHERE
            	UP_STATION IS NULL
                AND BRANCH = #arguments.branch_id#
                <cfif len(filter)>AND STATION_NAME LIKE '%#arguments.filter#%'</cfif>
			ORDER BY
            	STATION_NAME
        </cfquery>
    
    	<cfreturn get_upstations>
    </cffunction>
    
    <!--- LOAD DESIGN --->
    <cffunction name="loadDesign" access="remote" returntype="any" output="no">
    	<cfargument name="company_id" type="any" required="yes">
        <cfargument name="branch_id" type="any" required="yes">
        
        <cfquery name="get_upstations" datasource="#dsn#_#arguments.company_id#">
        	SELECT
            	STATION_ID AS id,
                STATION_NAME AS name,
                DESIGN_INFO AS designInfo,
                MARINA_PART_TYPE_ID AS partType,
                (SELECT TYPE_NAME FROM #dsn#.dbo.SETUP_MARINA_PART_TYPES WHERE TYPE_ID = WORKSTATIONS.MARINA_PART_TYPE_ID) AS partName
			FROM
            	WORKSTATIONS
			WHERE
            	BRANCH = #arguments.branch_id#
            	AND DESIGN_INFO IS NOT NULL
				AND UP_STATION IS NULL
        </cfquery>
        
        <cfset stations = ArrayNew(1)>
        <cfloop query="get_upstations">
        	<cfset station = StructNew()>
            <cfset station["id"] = get_upstations.id>
            <cfset station["name"] = get_upstations.name>
            <cfset station["designInfo"] = get_upstations.designInfo>
            <cfset station["partType"] = get_upstations.partType>
            <cfset station["partName"] = get_upstations.partName>
            
            <cfquery name="get_substations" datasource="#dsn#_#arguments.company_id#">
                SELECT
                    STATION_ID AS stationID,
                    STATION_NAME AS code,
                    WIDTH AS beam,
                    HEIGHT AS loa,
                    LENGTH AS draught,
                    ELECTRIC_TYPE AS elecID,
                    DESIGN_INFO AS designInfo,
                    (SELECT ELECTRIC_TYPE_NAME FROM #dsn#.dbo.SETUP_ELECTRIC_TYPE WHERE ELECTRIC_TYPE_ID = WS.ELECTRIC_TYPE) AS elecType
                FROM
                    WORKSTATIONS WS
                WHERE
                    UP_STATION = #station.id#
                    AND DESIGN_INFO IS NOT NULL
				ORDER BY
                	STATION_ID
			</cfquery>
            
            <cfset station["subList"] = get_substations>
            <cfset stations[ArrayLen(stations) + 1] = station>
        </cfloop>
        
        <cfreturn stations>
    </cffunction>
    
    <!--- DELETE UP STATION --->
    <cffunction name="deleteUpStation" access="remote" returntype="any" output="no">
    	<cfargument name="company_id" type="any" required="yes">
        <cfargument name="branch_id" type="any" required="yes">
        <cfargument name="station_id" type="any" required="yes">
        
        <cfquery name="deleteUpStation" datasource="#dsn#_#arguments.company_id#">
        	DELETE FROM WORKSTATIONS WHERE STATION_ID = #arguments.station_id#
        </cfquery>
        <cfquery name="deleteSubStations" datasource="#dsn#_#arguments.company_id#">
        	DELETE FROM WORKSTATIONS WHERE UP_STATION = #arguments.station_id#
        </cfquery>
        
        <cfreturn 1>
    </cffunction>
    
    <!--- SAVE UP STATION --->
    <cffunction name="saveUpStation" access="remote" returntype="any" output="no">
    	<cfargument name="company_id" type="any" required="yes">
        <cfargument name="branch_id" type="any" required="yes">
        <cfargument name="station_info" type="any" required="yes">
        <cfargument name="emp_id" type="any" required="yes">
    	
        <cftransaction>
            <cftry>
                <cfquery name="get_up_station" datasource="#dsn#_#arguments.company_id#">
                    SELECT STATION_ID FROM WORKSTATIONS WHERE STATION_ID = #arguments.station_info.id#
                </cfquery>
                <cfif get_up_station.recordcount gt 0>
                	<cfquery name="save_upstation" datasource="#dsn#_#arguments.company_id#">
                    	UPDATE
                            WORKSTATIONS
                        SET
                        	STATION_NAME = '#arguments.station_info.name#',
                            DESIGN_INFO = '#arguments.station_info.design_info#',
                            MARINA_PART_TYPE_ID = #arguments.station_info.part_type#,
                            UPDATE_IP = '#cgi.REMOTE_ADDR#',
                            UPDATE_EMP = #arguments.emp_id#,
                            UPDATE_DATE = #now()#
                        WHERE
                            STATION_ID = #arguments.station_info.id#
                    </cfquery>
                    <cfset target_id = arguments.station_info.id>
                <cfelse>
                	<cfquery name="save_upstation" datasource="#dsn#_#arguments.company_id#">
                        INSERT INTO
                            WORKSTATIONS
                            (
                                ACTIVE,
                                STATION_NAME,
                                BRANCH,
                                DESIGN_INFO,
                                MARINA_PART_TYPE_ID,
                                RECORD_IP,
                                RECORD_EMP,
                                RECORD_DATE
                            )
                        VALUES
                            (
                                1,
                                '#arguments.station_info.name#',
                                #arguments.branch_id#,
                                '#arguments.station_info.design_info#',
                                #arguments.station_info.part_type#,
                                '#cgi.REMOTE_ADDR#',
                                #arguments.emp_id#,
                                #now()#
                            )
					</cfquery>
					<cfquery name="get_last_id" datasource="#dsn#_#arguments.company_id#">
                        SELECT MAX(STATION_ID) AS STATION_ID FROM WORKSTATIONS
                    </cfquery>
                    <cfset target_id = get_last_id.STATION_ID>
                </cfif>
                
                <cfcatch type="any">
                    <cfreturn "#cfcatch.Message#\n\nDetail: #cfcatch.Detail#\n\nRaw Trace: #cfcatch.tagcontext[1].raw_trace#">
                </cfcatch>
            </cftry>
        </cftransaction>
        
        <cfreturn target_id>
    </cffunction>
    
    <!--- SAVE SUB STATION --->
    <cffunction name="saveSubStation" access="remote" returntype="any" output="no">
    	<cfargument name="company_id" type="any" required="yes">
        <cfargument name="branch_id" type="any" required="yes">
        <cfargument name="upstation_id" type="any" required="yes">
        <cfargument name="substation_data" type="any" required="yes">
        <cfargument name="emp_id" type="any" required="yes">
        
        <cftransaction>
        	<cftry>
				<cfset sub = arguments.substation_data>
                
                <cftry>
                    <cfquery name="check_sub" datasource="#dsn#_#arguments.company_id#">
                        SELECT STATION_ID FROM WORKSTATIONS WHERE STATION_ID = #sub.stationID#
                    </cfquery>
                    <cfif check_sub.recordcount gt 0><cfset sub_found = 1><cfelse><cfset sub_found = 0></cfif>
                <cfcatch type="any">
                    <cfset sub_found = 0>
                </cfcatch>
                </cftry>
                
                <cfquery name="save_sub" datasource="#dsn#_#arguments.company_id#">
                    <cfif sub_found eq 0>
                        INSERT INTO
                            WORKSTATIONS
                            (
                                STATION_NAME,
                                UP_STATION,
                                BRANCH,
                                ACTIVE,
                                WIDTH,
                                HEIGHT,
                                LENGTH,
                                DESIGN_INFO,
                                ELECTRIC_TYPE,
                                RECORD_IP,
                                RECORD_EMP,
                                RECORD_DATE
                            )
                        VALUES
                            (
                                '#sub.code#',
                                #arguments.upstation_id#,
                                #arguments.branch_id#,
                                1,
                                #sub.beam#,
                                #sub.loa#,
                                #sub.draught#,
                                '#sub.positionID#',
                                #sub.elecID#,
                                '#cgi.REMOTE_ADDR#',
                                #arguments.emp_id#,
                                #now()#
                            )
                    <cfelse>
                        UPDATE
                            WORKSTATIONS
                        SET
                            STATION_NAME = '#sub.code#',
                            WIDTH = #sub.beam#,
                            HEIGHT = #sub.loa#,
                            LENGTH = #sub.draught#,
                            DESIGN_INFO = '#sub.positionID#',
                            ELECTRIC_TYPE = #sub.elecID#,
                            UPDATE_IP = '#cgi.REMOTE_ADDR#',
                            UPDATE_EMP = #arguments.emp_id#,
                            UPDATE_DATE = #now()#
                        WHERE
                            STATION_ID = #sub.stationID#
                    </cfif>
                </cfquery>
                
                <cfif sub_found eq 0>
                	<cfquery name="get_last" datasource="#dsn#_#arguments.company_id#">
                    	SELECT MAX(STATION_ID) AS STATION_ID FROM WORKSTATIONS
                    </cfquery>
                    <cfset sub["newStationID"] = get_last.STATION_ID>
				</cfif>
                
                <cfcatch type="any">
                    <cfreturn "#cfcatch.Message#\n\nDetail: #cfcatch.Detail#\n\nRaw Trace: #cfcatch.tagcontext[1].raw_trace#">
                </cfcatch>
            </cftry>
        </cftransaction>
        
        <cfreturn sub>
    </cffunction>
    
    <!--- DELETE SUBSTATION --->
    <cffunction name="deleteSubstation" access="remote" returntype="any" output="no">
    	<cfargument name="company_id" type="any" required="yes">
        <cfargument name="station_id" type="any" required="yes">
        
    	<cfquery name="del_station" datasource="#dsn#_#arguments.company_id#">
        	DELETE FROM WORKSTATIONS WHERE STATION_ID = #arguments.station_id#
        </cfquery>
        
        <cfreturn 1>
    </cffunction>
    
    <!--- GET RESERVATIONS --->
    <cffunction name="getReservations" access="remote" returntype="any" output="no">
    	<cfargument name="company_id" type="any" required="yes">
        <cfargument name="station_list" type="any" required="yes">
        <cfargument name="start_date" type="date" required="yes">
        <cfargument name="finish_date" type="date" required="yes">
        <cfargument name="time_zone" type="any" required="yes">
        
        <cfquery name="get_reservations" datasource="#dsn#">
            SELECT 
                DISTINCT
                    WR.WS_RESERVATION_ID AS id,
                    WR.WORKSTATION_ID AS stationID,
                    WR.STATE AS state,
                    (SELECT COLOR FROM SETUP_RESERVATION WHERE RESERVATION_ID = WR.STATE) AS stateColor,
                    (SELECT RESERVATION FROM SETUP_RESERVATION WHERE RESERVATION_ID = WR.STATE) AS stateName,
                    DATEADD(hour,-#arguments.time_zone#, WR.START_DATE) AS startDate,
                    DATEADD(hour,-#arguments.time_zone#, WR.FINISH_DATE) AS finishDate,
                    AP.ASSETP_ID AS assetID,
                    AP.ASSETP AS asset,
                    AP.PHYSICAL_ASSETS_WIDTH AS assetWidth,
					AP.PHYSICAL_ASSETS_HEIGHT AS assetHeight,
					AP.PHYSICAL_ASSETS_SIZE AS assetLength
                FROM	
                    WORKSTATION_RESERVATION WR,
                    ASSET_P AP
                WHERE
                    AP.ASSETP_ID = WR.PSYCALASSET_ID AND
                    WR.WORKSTATION_ID IN (#arguments.station_list#) AND
                    WR.START_DATE >= #arguments.start_date# AND
                    WR.FINISH_DATE <= #arguments.finish_date#
				ORDER BY
                	startDate
        </cfquery>
        
        <cfreturn get_reservations>
    </cffunction>
    
    <!--- GET TRAFFIC --->
    <cffunction name="getTraffic" access="remote" returntype="any" output="no">
    	<cfargument name="company_id" type="any" required="yes">
        <cfargument name="station_list" type="any" required="yes">
        <cfargument name="start_date" type="date" required="yes">
        <cfargument name="finish_date" type="date" required="yes">
        <cfargument name="time_zone" type="any" required="yes">
        
        <!-- Temporary query below -->
        <cfquery name="get_traffic" datasource="#dsn#">
            SELECT WORKSTATION_ID FROM WORKSTATION_RESERVATION WHERE WORKSTATION_ID = -1
        </cfquery>
        
        <cfreturn get_traffic>
    </cffunction>
</cfcomponent>