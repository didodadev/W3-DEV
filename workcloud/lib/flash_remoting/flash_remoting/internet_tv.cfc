<cfcomponent extends = "paramsControl">

    <cfset dsn = this.getdsn()>

    <cfset _index_folder = replacelist(expandPath("/"), "\", "/")>
    <cfset _host = getLocalMachineName()>
    
    <!--- TEST --->
    <cffunction name="test" access="remote" returntype="string" output="no">
    	<cfreturn "test component is accessible">
    </cffunction>
    
    <!--- DETECT SERVER MACHINE NAME --->
    <cffunction name="getLocalMachineName" access="private" returntype="any" output="no">
        <cfset _inet_address = CreateObject("java", "java.net.InetAddress")>
        <cfset _inet_address = _inet_address.getLocalHost()>
        
        <cfreturn _inet_address.getHostName()>
    </cffunction>
     
    <!--- CONVERT DD:MM:YYYY DATE FORMAT AND HH:MM:SS TIME FORMAT TO DATE-TIME FORMAT --->
    <cffunction name="convertToDateTime" access="private" returntype="date" output="no">
    	<cfargument name="date" type="string" required="yes">
        <cfargument name="time" type="string" required="yes">
        
        <cfset date_time = "{ts '" & listgetat(arguments.date, 3 ,'.') & "-" & listgetat(arguments.date, 2, '.') & "-"& listgetat(arguments.date, 1, '.') & " " & arguments.time &"'}">
        <cfreturn date_time>
    </cffunction>

	<!--- GET ARCHIVE DATA --->
	<cffunction name="getArchiveData" access="remote" returntype="any" output="no">
    	<cfargument name="emp_id" type="any" required="yes">
        <cfargument name="channel_id" type="any" required="yes">
        
        <cfquery name="get_archive_limitation" datasource="#dsn#">
        	SELECT IS_MANAGER_VIDEO AS onlyManagerVideos FROM SETUP_TV_CHANNEL WHERE CHANNEL_ID = #arguments.channel_id#
        </cfquery>
    
        <cfquery name="archive" datasource="#dsn#">
            SELECT
                ASSET.ASSET_ID AS id,
                ASSET.ASSET_FILE_NAME,
                ASSET.ASSET_NAME AS virtualName,
                ASSET.ASSET_DESCRIPTION AS description,
                ASSET.ASSET_DETAIL AS keywords,
                ASSET.ASSETCAT_ID,
                ASSET_CAT.ASSETCAT_PATH,
                ASSET.ASSET_FILE_PATH_NAME,
                ASSET.RECORD_DATE,
                ASSET.ASSET_FILE_SIZE AS size,
                ASSET.DURATION AS duration
            FROM
                ASSET,
                ASSET_CAT
            WHERE
                ASSET_CAT.ASSETCAT_ID = ASSET.ASSETCAT_ID AND
                ASSET.ASSET_FILE_NAME LIKE '%.flv%' AND
                ASSET.IS_TV_PUBLISH = 1
                <cfif get_archive_limitation.onlyManagerVideos eq 1>AND ASSET.RECORD_EMP = '#arguments.emp_id#'</cfif>
            ORDER BY
                ASSET.RECORD_DATE DESC
        </cfquery>
        
        <!-- Assign required columns to data -->
        <cfset emptyList = ArrayNew(1)>
        <cfset result = QueryAddColumn(archive, "streamName", "VarChar", emptyList)>
        <cfloop query="archive">            
            <!-- Assign physical streamName -->
            <cfif not len(ASSET_FILE_PATH_NAME)>
                <cfif ASSETCAT_ID gte 0>
                    <cfset result = QuerySetCell(archive, "streamName", '#_host#/#_index_folder#documents/asset/#ASSETCAT_PATH#/#ASSET_FILE_NAME#', currentrow)>
                <cfelse>
                    <cfset result = QuerySetCell(archive, "streamName", '#_host#/#_index_folder#documents/#ASSETCAT_PATH#/#ASSET_FILE_NAME#', currentrow)>
                </cfif>
            <cfelse>
                <cfset result = QuerySetCell(archive, "streamName", ASSET_FILE_PATH_NAME, currentrow)>
            </cfif>
                                   
            <!-- Convert the streamName as web based address for FMS to read them -->
            <cfset result = QuerySetCell(archive, "streamName", replace(streamName, ":/", "$/"), currentrow)>
        </cfloop>
        
        <cfreturn archive>
	</cffunction>
    
    <!--- GET BROADCAST DATA --->
    <cffunction name="getBroadcast" access="remote" returntype="any" output="no">
    	<cfargument name="channel_id" type="any" required="yes">
        <cfargument name="broadcast_date" type="any" required="yes">
        
        <cfset broadcast_date_start = convertToDateTime(arguments.broadcast_date, "00:00:00")>
        <cfset broadcast_date_finish = convertToDateTime(arguments.broadcast_date, "23:59:59")>

        <cfquery name="broadcast" datasource="#dsn#">
            SELECT
                BROADCAST_TV.ID AS broadcastID,
                BROADCAST_TV.ASSET_ID AS id,
                BROADCAST_TV.TITLE AS title,
                BROADCAST_TV.DETAIL AS description,
                BROADCAST_TV.CAT_ID AS categoryID,
                BROADCAST_TV.IS_LIVE AS live,
                BROADCAST_TV.START_TIME AS startTime,
                BROADCAST_TV.FINISH_TIME AS finishTime,
                BROADCAST_TV.SEEK_TIME AS seekTime
            FROM
                BROADCAST_TV
            WHERE
                BROADCAST_TV.CHANNEL_ID = #arguments.channel_id# AND BROADCAST_TV.BROADCAST_DATE >= #broadcast_date_start# AND BROADCAST_TV.BROADCAST_DATE <= #broadcast_date_finish#
            ORDER BY
            	BROADCAST_TV.ID
        </cfquery>
        
        <cfreturn broadcast>
    </cffunction>
    
     <!--- GET NEXT BROADCAST START INFO --->
    <cffunction name="getNextBroadcastStartInfo" access="remote" returntype="string" output="no">
    	<cfargument name="channel_id" type="any" required="yes">
        <cfargument name="broadcast_date" type="any" required="yes">
		
        <cfset arguments.broadcast_date = convertToDateTime(arguments.broadcast_date, "23:59:59")>
        
        <cfquery name="broadcast_start_info" datasource="#dsn#" maxrows="1">
            SELECT
                START_TIME,
                BROADCAST_DATE
            FROM
                BROADCAST_TV
            WHERE
                CHANNEL_ID = #arguments.channel_id# AND BROADCAST_DATE > #arguments.broadcast_date#
            ORDER BY
            	BROADCAST_DATE
        </cfquery>
        
        <cfif broadcast_start_info.recordCount>
	        <cfset result = DateFormat(broadcast_start_info.BROADCAST_DATE, "dd.mm.yyyy") & "-" & broadcast_start_info.START_TIME>
        <cfelse>
        	<cfset result = "">
        </cfif>
        
        <cfreturn result>
    </cffunction>
    
    <!--- SAVE BROADCAST DATA --->
    <cffunction name="saveBroadcast" access="remote" returntype="any" output="no">
    	<cfargument name="channel_id" type="any" required="yes">
        <cfargument name="broadcast_date" type="any" required="yes">
        <cfargument name="data_list" type="any" required="yes">
        
        <cfset broadcast_date_start = convertToDateTime(arguments.broadcast_date, "00:00:00")>
        <cfset broadcast_date_finish = convertToDateTime(arguments.broadcast_date, "23:59:59")>
        
        <!-- Delete current records which are related specified broadcast date -->
        <cfquery name="delete_broadcast" datasource="#dsn#">
        	DELETE FROM BROADCAST_TV WHERE CHANNEL_ID = #arguments.channel_id# AND BROADCAST_DATE >= #broadcast_date_start# AND BROADCAST_DATE <= #broadcast_date_finish#
        </cfquery>
        
        <!-- Add new records -->
        <cfloop index="i" from="1" to="#arraylen(data_list)#">
        	<cfset _id = data_list[i]["id"]>
            <cfset _title = data_list[i]["title"]>
            <cfset _detail = data_list[i]["description"]>
            <cfset _category_id = data_list[i]["categoryID"]>
            <cfset _is_live = data_list[i]["live"]>
            <cfset _start_time = data_list[i]["startTime"]>
            <cfset _finish_time = data_list[i]["finishTime"]>
            <cfset _seek_time = data_list[i]["seekTime"]>
            
            <cfquery name="add_broadcast" datasource="#dsn#">
            	INSERT INTO BROADCAST_TV
                	(
                    CHANNEL_ID,
                    BROADCAST_DATE,
                    ASSET_ID,
                    TITLE,
                    DETAIL,
                    CAT_ID,
                    IS_LIVE,
                    START_TIME,
                    FINISH_TIME,
                    SEEK_TIME
                    )
               	VALUES
                	(
                    #arguments.channel_id#,
                    #convertToDateTime(arguments.broadcast_date, _start_time)#,
                    <cfif len(_id)>'#_id#'<cfelse>NULL</cfif>,
                    '#_title#',
                    <cfif len(_detail)>'#_detail#'<cfelse>NULL</cfif>,
                    <cfif len(_category_id)>'#_category_id#'<cfelse>NULL</cfif>,
                    #_is_live#,
                    '#_start_time#',
                    '#_finish_time#',
                    '#_seek_time#'
                    )
            </cfquery>
        </cfloop>

        <cfreturn true>
    </cffunction>
    
    <!--- GET BROADCAST FLOW CATEGORIES --->
    <cffunction name="getCategories" access="remote" returntype="any" output="no">
    	<cfquery name="categories" datasource="#dsn#">
        	SELECT CAT_ID AS categoryID, BROADCAST_CAT_NAME AS categoryName FROM BROADCAST_CAT ORDER BY BROADCAST_CAT_NAME
        </cfquery>
        
        <cfreturn categories>
    </cffunction>
    
    <!--- COPY BROADCAST FLOW --->
    <cffunction name="copyBroadcastFlow" access="remote" returntype="any" output="no">
    	<cfargument name="channel_id" type="any" required="yes">
    	<cfargument name="source_ids" type="string" required="yes">
        <cfargument name="target_date" type="string" required="yes">
    
    	<cftry>
            <cfquery name="get_source_flow" datasource="#dsn#">
                SELECT * FROM BROADCAST_TV WHERE ID IN (#arguments.source_ids#)
            </cfquery>
            
            <cfquery name="clear_target_flow" datasource="#dsn#">
                DELETE FROM BROADCAST_TV WHERE CHANNEL_ID = #arguments.channel_id# AND BROADCAST_DATE >= #convertToDateTime(arguments.target_date, "00:00:00")# AND BROADCAST_DATE <= #convertToDateTime(arguments.target_date, "23:59:59")#
            </cfquery>
            
            <cfloop query="get_source_flow">
                <cfquery name="insert_flow_item" datasource="#dsn#">
                    INSERT INTO BROADCAST_TV
                        (
                        CHANNEL_ID,
                        BROADCAST_DATE,
                        ASSET_ID,
                        TITLE,
                        DETAIL,
                        CAT_ID,
                        IS_LIVE,
                        START_TIME,
                        FINISH_TIME,
                        SEEK_TIME
                        )
                    VALUES
                        (
                        '#get_source_flow.CHANNEL_ID#',
                        #convertToDateTime(arguments.target_date, get_source_flow.START_TIME)#,
                        <cfif len(get_source_flow.ASSET_ID)>'#get_source_flow.ASSET_ID#'<cfelse>NULL</cfif>,
                        '#get_source_flow.TITLE#',
                        '#get_source_flow.DETAIL#',
                        '#get_source_flow.CAT_ID#',
                        '#get_source_flow.IS_LIVE#',
                        '#get_source_flow.START_TIME#',
                        '#get_source_flow.FINISH_TIME#',
                        '#get_source_flow.SEEK_TIME#'
                        )
                </cfquery>
            </cfloop>
            
            <cfcatch type="any">
                <cfthrow message="#cfcatch.Message#\n\nDetail: #cfcatch.Detail#\n\nRaw Trace: #cfcatch.tagcontext[1].raw_trace#">
            </cfcatch>
        </cftry>
        
    	<cfreturn true>
    </cffunction>
</cfcomponent>