<cfcomponent>
	<cfset _index_folder = replacelist(expandPath("/"), "\", "/")>
    <cfset _host = getLocalMachineName()>
	<cfset dsn = application.systemParam.systemParam().dsn>
    
    <!--- DETECT SERVER MACHINE NAME --->
    <cffunction name="getLocalMachineName" access="private" returntype="any" output="no">
        <cfset _inet_address = CreateObject("java", "java.net.InetAddress")>
        <cfset _inet_address = _inet_address.getLocalHost()>
        
        <cfreturn _inet_address.getHostName()>
    </cffunction>
   	
    <!--- GET VIDEO FILE PATH BY CONTENT ID !--->
	<cffunction name="getFilePathByContentID" access="remote" returntype="string" output="no">
        <cfargument name="content_id" required="yes" type="string">
        
        <cfquery name="get_file_path" datasource="#dsn#" maxrows="1">
        	SELECT
                ASSET.ASSET_ID,
                ASSET.ASSET_FILE_NAME,
                ASSET.ASSET_FILE_PATH_NAME,
                ASSET.ASSETCAT_ID,
                ASSET_CAT.ASSETCAT_PATH,
				ASSET_CAT.ASSETCAT_ID
            FROM
                ASSET,
                ASSET_CAT
            WHERE
				ASSET.ASSET_ID = '#arguments.content_id#' AND
                ASSET_CAT.ASSETCAT_ID = ASSET.ASSETCAT_ID AND
                ASSET.ASSET_FILE_NAME LIKE '%.flv%' AND
                ASSET.IS_INTERNET = 1
        </cfquery>
        
        <cfif get_file_path.recordcount>
			<cfif not len(get_file_path.ASSET_FILE_PATH_NAME)>
                <cfif get_file_path.ASSETCAT_ID gte 0>
                    <cfset filepath = '#_host#/#_index_folder#documents/asset/#get_file_path.ASSETCAT_PATH#/#get_file_path.ASSET_FILE_NAME#'>
                <cfelse>
                    <cfset filepath = '#_host#/#_index_folder#documents/#get_file_path.ASSETCAT_PATH#/#get_file_path.ASSET_FILE_NAME#'>
                </cfif>
            <cfelse>
                <cfset filepath = '#get_file_path.ASSET_FILE_PATH_NAME#'>
            </cfif>
        <cfelse>
        	<cfset filepath = ''>
        </cfif>
        
        <cfreturn filepath>
    </cffunction>
    
    <!--- GET VIDEO PLAYLIST !--->
	<cffunction name="getVideoPlaylist" access="remote" returntype="query" output="no">
        <cfargument name="user_id" required="yes" type="string">
        <cfargument name="user_type" required="yes" type="string">
        <cfargument name="cookie_name" required="yes" type="string">
                      
		<cfquery name="playlist" datasource="#dsn#" maxrows="99">
        	SELECT
                ASSET.ASSET_ID AS id,
                ASSET.ASSET_FILE_NAME,
                ASSET.ASSET_NAME AS title,
                ASSET.ASSETCAT_ID,
                ASSET_CAT.ASSETCAT_PATH,
                ASSET.ASSET_FILE_PATH_NAME,
                ASSET.DURATION AS duration,
                ASSET_CAT.ASSETCAT AS category
            FROM
                ASSET,
                ASSET_CAT,
                VIDEO_PLAYLIST VP
            WHERE
                ASSET_CAT.ASSETCAT_ID = ASSET.ASSETCAT_ID AND
                ASSET.ASSET_ID = VP.VIDEO_ID
                <cfif isdefined('arguments.user_type') and arguments.user_type is "consumer">
   					AND VP.RECORD_CONS = #arguments.user_id#
  				<cfelseif isdefined('arguments.user_type') and arguments.user_type is "partner">
   					AND VP.RECORD_PAR = #arguments.user_id#
  				<cfelseif isdefined('arguments.user_type') and arguments.user_type is "employee">
               		AND VP.RECORD_EMP = #arguments.user_id#
  				<cfelseif len(arguments.cookie_name)>
   					AND VP.RECORD_GUEST = 1
   					AND COOKIE_NAME = '#arguments.cookie_name#'
                </cfif>

            ORDER BY 
            	VP.PLAYLIST_ID ASC
        </cfquery>
        
        <cfset emptyList = []>
        <cfset result = QueryAddColumn(playlist, "targetPath", "VarChar", emptyList)>
        <cfloop query="playlist">
        	<cfif not len(ASSET_FILE_PATH_NAME)>
            	<cfif ASSETCAT_ID gte 0>
                	<cfset result = QuerySetCell(playlist, "targetPath", '/documents/asset/#ASSETCAT_PATH#/#ASSET_FILE_NAME#', currentrow)>
				<cfelse>
                	<cfset result = QuerySetCell(playlist, "targetPath", '/documents/#ASSETCAT_PATH#/#ASSET_FILE_NAME#', currentrow)>
				</cfif>
            <cfelse>
            	<cfset result = QuerySetCell(playlist, "targetPath", ASSET_FILE_PATH_NAME, currentrow)>
            </cfif>
        </cfloop>
        
		<cfreturn playlist>
	</cffunction>
    
    <!--- GET VIDEO DETAIL !--->
    <cffunction name="getVideoDetail" access="remote" returntype="query" output="no">
	    <cfargument name="detail_type" type="string" required="yes">
    	<cfargument name="content_id" type="string" required="yes">
        <cfargument name="user_id" required="yes" type="string">
        <cfargument name="user_type" required="yes" type="string">
        <cfargument name="cookie_name" required="yes" type="string">
     	        
        <cfif isDefined('arguments.content_id') and len(arguments.content_id)>   
        	<cfquery name="get_asset_categroy" datasource="#dsn#" maxrows="1">
	            SELECT ASSETCAT_ID FROM ASSET WHERE ASSET_ID = #arguments.content_id#
	        </cfquery>
        </cfif>
        
        <cfquery name="detail" datasource="#dsn#" maxrows="20">
            SELECT 
                ASSET.ASSET_ID AS id,
                ASSET.ASSET_FILE_NAME,
                ASSET.ASSET_NAME AS title,
                ASSET.ASSETCAT_ID,
                ASSET_CAT.ASSETCAT_PATH,
                ASSET.ASSET_FILE_PATH_NAME,
                ASSET.DURATION AS duration,
                ASSET_CAT.ASSETCAT AS category
            FROM
                ASSET,
                ASSET_CAT
            WHERE
                <cfif arguments.detail_type is "related" and len(arguments.content_id)>
                    ASSET.ASSETCAT_ID = #get_asset_categroy.ASSETCAT_ID# AND
				</cfif>
                ASSET_CAT.ASSETCAT_ID = ASSET.ASSETCAT_ID AND
                ASSET.ASSET_FILE_NAME LIKE '%.flv%' AND
                ASSET.IS_INTERNET = 1
            ORDER BY
                <cfif arguments.detail_type is "related">
                    ASSET.RECORD_DATE DESC
                <cfelseif arguments.detail_type is "top">
                    ASSET.DOWNLOAD_COUNT DESC, ASSET.RECORD_DATE DESC
                <cfelseif arguments.detail_type is "new">
                    ASSET.RECORD_DATE DESC
                </cfif>
        </cfquery>
              
        <cfset emptyList = []>
        <cfset result = QueryAddColumn(detail, "targetPath", "VarChar", emptyList)>
        <cfset result = QueryAddColumn(detail, "previewPath", "VarChar", emptyList)>
        <cfset result = QueryAddColumn(detail, "addedToPlaylist", "Integer", emptyList)>
        <cfloop query="detail">
            <cfif not len(ASSET_FILE_PATH_NAME)>
                <cfif ASSETCAT_ID gte 0>
                    <cfset result = QuerySetCell(detail, "targetPath", '/documents/asset/#ASSETCAT_PATH#/#ASSET_FILE_NAME#', currentrow)>
                    <cfset result = QuerySetCell(detail, "previewPath", '#_host#/#_index_folder#documents/asset/#ASSETCAT_PATH#/#ASSET_FILE_NAME#', currentrow)>            
                <cfelse>
                    <cfset result = QuerySetCell(detail, "targetPath", '/documents/#ASSETCAT_PATH#/#ASSET_FILE_NAME#', currentrow)>
                    <cfset result = QuerySetCell(detail, "previewPath", '#_host#/#_index_folder#documents/#ASSETCAT_PATH#/#ASSET_FILE_NAME#', currentrow)> 
                </cfif>
            <cfelse>
                <cfset result = QuerySetCell(detail, "targetPath", ASSET_FILE_PATH_NAME, currentrow)>
                <cfset result = QuerySetCell(detail, "previewPath", '#ASSET_FILE_PATH_NAME#', currentrow)> 
            </cfif>
            <cfquery name="get_video_playlist" datasource="#dsn#">
                SELECT 
                    PLAYLIST_ID 
                FROM 
                    VIDEO_PLAYLIST 
                WHERE 
                    VIDEO_ID = #ID#
                <cfif isdefined('arguments.user_type') and arguments.user_type is "consumer">
                    AND RECORD_CONS = #arguments.user_id#
                <cfelseif isdefined('arguments.user_type') and arguments.user_type is "partner">
                    AND RECORD_PAR = #arguments.user_id#
                <cfelseif isdefined('arguments.user_type') and arguments.user_type is "employee">
                    AND RECORD_EMP = #arguments.user_id#
                <cfelseif len(arguments.cookie_name)>
                    AND RECORD_GUEST = 1
                    AND COOKIE_NAME = '#arguments.cookie_name#'
                </cfif>
            </cfquery>
            
            <cfif get_video_playlist.recordcount>
				<cfset result = QuerySetCell(detail, "addedToPlaylist", 1, currentrow)>
            <cfelse>
	            <cfset result = QuerySetCell(detail, "addedToPlaylist", 0, currentrow)>
            </cfif>
        </cfloop>
        
        <cfreturn detail>
    </cffunction>
    
    <!--- ADD VIDEO TO PLAYLIST !--->
	<cffunction name="addVideoToPlaylist" access="remote" returntype="boolean" output="no"> 
	    <cfargument name="content_id" type="string" required="yes">  
    	<cfargument name="user_id" required="yes" type="string">
        <cfargument name="user_type" required="yes" type="string">
        <cfargument name="cookie_name" required="yes" type="string">
        
        <cfquery name="add_video_playlist" datasource="#dsn#">
            INSERT INTO 
                VIDEO_PLAYLIST
                    (
                        VIDEO_ID,
                        COOKIE_NAME,
                        RECORD_EMP,
                        RECORD_CONS,
                        RECORD_PAR,
                        RECORD_GUEST,
                        RECORD_DATE,
                        RECORD_IP
                    )
                VALUES
                    (
                        #arguments.content_id#,
                        <cfif len(arguments.cookie_name)>'#arguments.cookie_name#'<cfelse>NULL</cfif>,
                        <cfif arguments.user_type is "employee">#arguments.user_id#<cfelse>NULL</cfif>,
                        <cfif arguments.user_type is "consumer">#arguments.user_id#<cfelse>NULL</cfif>,
                        <cfif arguments.user_type is "partner">#arguments.user_id#<cfelse>NULL</cfif>,
                        <cfif not len(arguments.user_id)>1<cfelse>0</cfif>,
                        #now()#,
                        '#cgi.remote_addr#'
                    )
        </cfquery>
        
        <cfreturn true>
    </cffunction>
    
    <!--- DELETE VIDEO FROM PLAYLIST !--->
	<cffunction name="deleteVideoFromPlaylist" access="remote" returntype="boolean" output="no">
	    <cfargument name="content_id" type="string" required="yes">  
    	<cfargument name="user_id" required="yes" type="string">
        <cfargument name="user_type" required="yes" type="string">
        <cfargument name="cookie_name" required="yes" type="string">
        
        <cfquery name="del_video_playlist" datasource="#dsn#">
            DELETE FROM
                VIDEO_PLAYLIST 
            WHERE 
                VIDEO_ID = #arguments.content_id#
                <cfif arguments.user_type is "consumer">
                    AND RECORD_CONS = #arguments.user_id#
                <cfelseif arguments.user_type is "partner">
                    AND RECORD_PAR = #arguments.user_id#
                <cfelseif arguments.user_type is "employee">
                    AND RECORD_EMP = #arguments.user_id#
                <cfelseif len(arguments.cookie_name) and not len(arguments.user_id)>
                    AND RECORD_GUEST = 1
                    AND COOKIE_NAME = '#arguments.cookie_name#'
                </cfif>
        </cfquery>
        
        <cfreturn true>
    </cffunction>
</cfcomponent>
