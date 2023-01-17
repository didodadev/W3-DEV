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
        	SELECT IS_MANAGER_VIDEO AS onlyManagerVideos FROM SETUP_RADIO_CHANNEL WHERE CHANNEL_ID = #arguments.channel_id#
        </cfquery>
    
        <cfquery name="archive" datasource="#dsn#">
			SELECT
            	ASSET.ASSET_ID 				AS assetID,
            	ASSET.ASSET_FILE_NAME,
               	ASSET.ASSET_NAME 			AS virtualName,
                ASSET.ASSET_FILE_PATH_NAME,
                ASSET.ASSET_DESCRIPTION 	AS description,
                ASSET.ASSET_DETAIL 			AS keywords,
                ASSET.ASSETCAT_ID,
                ASSET_CAT.ASSETCAT_PATH
			FROM
            	ASSET,
                ASSET_CAT
			WHERE
            	ASSET_CAT.ASSETCAT_ID = ASSET.ASSETCAT_ID
                AND (ASSET.ASSET_FILE_NAME LIKE '%.flv%' OR	ASSET.ASSET_FILE_NAME LIKE '%.mp3%' OR	ASSET.ASSET_FILE_NAME LIKE '%.mp4%')
                AND ASSET.IS_RADIO = 1
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
    
    <!--- GET SURVEY DATA --->
    <cffunction name="getSurveyData" access="remote" returntype="any" output="no">
    	<cfargument name="company_id" type="any" required="yes">
    
    	<cfquery name="get_surveys" datasource="#dsn#">
        	SELECT
            	SURVEY_ID,
                SURVEY,
                SURVEY_HEAD,
                SURVEY_TYPE,
                STAGE_ID
			FROM
            	SURVEY
			WHERE
            	SURVEY_STATUS = 1
                AND STAGE_ID = -2
                AND (#NOW()# BETWEEN VIEW_DATE_START AND VIEW_DATE_FINISH)
                AND SURVEY_OUR_COMP LIKE '%,#arguments.company_id#,%'
			ORDER BY
            	RECORD_DATE DESC
        </cfquery>
        
        <cfset surveys = ArrayNew(1)>
        <cfloop query="get_surveys">
        	<cfset _survey = StructNew()>
            <cfset _survey["id"] = get_surveys.SURVEY_ID>
            <cfset _survey["title"] = get_surveys.SURVEY>
            <cfset _survey["multiSelect"] = get_surveys.SURVEY_TYPE>
            <cfquery name="get_options" datasource="#dsn#">
            	SELECT
	                ALT_ID 		AS id,
                    ALT 		AS title,
                	VOTE_COUNT 	AS voteCount
				FROM
                	SURVEY_ALTS
				WHERE
                	SURVEY_ID = #get_surveys.SURVEY_ID#
            </cfquery>
            <cfset _survey["optionList"] = get_options>
            
            <cfset surveys[ArrayLen(surveys) + 1] = _survey>
        </cfloop>
        
    	<cfreturn surveys>
    </cffunction>
    
    <!--- GET SURVEY RESULTS --->
    <cffunction name="getSurveyResults" access="remote" returntype="any" output="no">
    	<cfargument name="employee_id" type="string" required="yes">
        <cfargument name="survey_id" type="string" required="yes">
        
        <cfquery name="survey_results" datasource="#dsn#">
        	SELECT
                SURVEY_ALTS.VOTE_COUNT
			FROM
            	SURVEY,
                SURVEY_ALTS
			WHERE
            	SURVEY_ALTS.SURVEY_ID = SURVEY.SURVEY_ID
                AND SURVEY.SURVEY_ID = #arguments.survey_id#
        </cfquery>
        
        <!-- Check user voted the survey before or not -->
        <cfquery name="check_vote" datasource="#dsn#">
        	SELECT SURVEY_ID FROM SURVEY_VOTES WHERE EMP_ID = #arguments.employee_id# AND SURVEY_ID = #arguments.survey_id#
        </cfquery>
        
        <cfset result = valuelist(survey_results.VOTE_COUNT, ',')>
        <cfif check_vote.recordcount>
        	 <cfset result = "true,#result#">
		<cfelse>
        	<cfset result = "false,#result#">
		</cfif>
        <cfreturn result>
    </cffunction>
    
    <!--- VOTE SURVEY --->
    <cffunction name="voteSurvey" access="remote" returntype="any" output="no">
    	<cfargument name="employee_id" type="string" required="yes">
        <cfargument name="survey_id" type="string" required="yes">
        <cfargument name="votes" type="string" required="yes">
        
        <cfquery name="get_votes" datasource="#dsn#">
        	SELECT SURVEY_ID FROM SURVEY_VOTES WHERE EMP_ID = #arguments.employee_id# AND SURVEY_ID = #arguments.survey_id#
        </cfquery>
        <cfif get_votes.recordcount eq 0>
            <cfquery name="vote_survey" datasource="#dsn#">
                INSERT INTO SURVEY_VOTES
					(
                    SURVEY_ID,
                    EMP_ID,
                    GUEST,
                    VOTES,
                    RECORD_IP,
                    RECORD_DATE
                    )
				VALUES
					(
                    #arguments.survey_id#,
                    #arguments.employee_id#,
                    0,
                    ',#arguments.votes#,',
                    '#CGI.REMOTE_ADDR#',
                    #NOW()#
                    )
            </cfquery>
            <cfloop from="1" to="#listlen(votes, ',')#" index="i">
                <cfquery name="increase_vote_count" datasource="#dsn#">
                    UPDATE SURVEY_ALTS SET VOTE_COUNT = VOTE_COUNT + 1 WHERE SURVEY_ID = #arguments.survey_id# AND ALT_ID = #listgetat(votes, i, ',')#
                </cfquery>
            </cfloop>
        </cfif>
        <cfreturn arguments.survey_id>
    </cffunction>
    
    <!--- GET COLLECTION DATA --->
    <cffunction name="getCollections" access="remote" returntype="any" output="no">
    	<cfargument name="channel_id" type="any" required="yes">
    
    	<cfquery name="get_collections" datasource="#dsn#">
        	SELECT
            	PLAYLIST_ID	AS collectionID,
                TITLE		AS name,
                ASSETS		AS assets
			FROM
            	RADIO_PLAYLIST
            WHERE
            	CHANNEL_ID = #arguments.channel_id#
            ORDER BY
            	collectionID
        </cfquery>
        
        <cfreturn get_collections>
    </cffunction>
    
    <!--- SAVE COLLECTION --->
    <cffunction name="saveCollection" access="remote" returntype="any" output="no">
    	<cfargument name="channel_id" type="any" required="yes">
    	<cfargument name="collection_title" type="any" required="yes">
        <cfargument name="collection_assets" type="any" required="yes">
        <cfargument name="collection_id" type="any" required="no" default="">
        
        <cfif len(arguments.collection_id)>
        	<cfquery name="update_playlist" datasource="#dsn#">
            	UPDATE
                	RADIO_PLAYLIST
                SET
                	TITLE = '#arguments.collection_title#',
                    ASSETS = '#arguments.collection_assets#'
                WHERE
                	CHANNEL_ID = #arguments.channel_id# AND
                	PLAYLIST_ID = #arguments.collection_id#
            </cfquery>
        <cfelse>
        	<cfquery name="insert_playlist" datasource="#dsn#">
            	INSERT INTO RADIO_PLAYLIST
                	(
                    CHANNEL_ID,
                	TITLE,
                    ASSETS
                    )
                    VALUES
                    (
                    '#arguments.channel_id#',
                    '#arguments.collection_title#',
                    '#arguments.collection_assets#'
                    )
            </cfquery>
            <cfquery name="get_last_playlist" datasource="#dsn#">
            	SELECT MAX(PLAYLIST_ID) AS PLAYLIST_ID FROM RADIO_PLAYLIST
            </cfquery>
            <cfset arguments.collection_id = get_last_playlist.PLAYLIST_ID>
		</cfif>
        
        <cfreturn arguments.collection_id>
    </cffunction>
    
    <!--- DELETE COLLECTION --->
    <cffunction name="deleteCollection" access="remote" returntype="any" output="no">
    	<cfargument name="channel_id" type="any" required="yes">
        <cfargument name="collection_id" type="any" required="no" default="">
        
		<cfquery name="delete_playlist" datasource="#dsn#">
			DELETE FROM RADIO_PLAYLIST WHERE CHANNEL_ID = #arguments.channel_id# AND PLAYLIST_ID = #arguments.collection_id#
        </cfquery>
                
        <cfreturn true>
    </cffunction>
</cfcomponent>