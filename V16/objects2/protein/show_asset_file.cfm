<cfparam  name="attributes.asset_id" default="">
<cfset siteUrl = cgi.SERVER_PORT neq '443' ? "http://#cgi.HTTP_HOST#" : "https://#cgi.HTTP_HOST#" />

<cfset fileSystem = CreateObject("component","V16.asset.cfc.file_system")>

<cfif len( attributes.asset_id )>
    <cfquery name="get_asset" datasource="#dsn#">
        SELECT 
            A.ASSET_FILE_REAL_NAME,
            A.ASSET_FILE_NAME,
            A.ASSETCAT_ID,
            A.RECORD_EMP,
            A.EMBEDCODE_URL,
            A.RECORD_DATE,
            AC.ASSETCAT,
            A.RECORD_PAR,
            A.RECORD_EMP,
            AC.ASSETCAT_PATH
        FROM 
            ASSET AS A,
            ASSET_CAT AS AC 
        WHERE
            A.ASSETCAT_ID = AC.ASSETCAT_ID
            AND A.IS_ACTIVE = 1
            AND ASSET_ID = <cfqueryparam cfsqltype = "cf_sql_integer" value = "#attributes.asset_id#">
    </cfquery>

<!---     <cfquery name="get_asset_related" datasource="#dsn#">
        SELECT ASSET_ID, ALL_EMPLOYEE, ALL_PEOPLE FROM ASSET_RELATED WHERE ASSET_ID = #attributes.asset_id#
    </cfquery>

    <cfquery name="get_emp_all" dbtype="query">
        SELECT ASSET_ID FROM get_asset_related /* WHERE ALL_EMPLOYEE = 1 OR ALL_PEOPLE = 1 */
    </cfquery> --->

    <cfif get_asset.recordcount>
        <cfform name="del_asset" method="post" enctype="multipart/form-data">
            <input type="hidden" name="action_id" id="action_id" value="<cfoutput>#attributes.action_id#</cfoutput>">
            <input type="hidden" name="action_section" id="action_section" value="<cfoutput>#attributes.action_section#</cfoutput>">
            <input type="hidden" name="asset_id" id="asset_id" value="<cfoutput>#attributes.asset_id#</cfoutput>">
            <input type="hidden" name="assetcat_id" id="assetcat_id" value="<cfoutput>#get_asset.assetcat_id#</cfoutput>">
            <input type="hidden" name="page_name" id="page_name" value="<cfoutput>#attributes.page_name#</cfoutput>">
                       
            <div class="row ui-scroll">
                <div class="col col-12 col-md-12 col-sm-12 col-xs-12">
                    <cfif not len( get_asset.EMBEDCODE_URL )>

                        <cfset filePath = get_asset.assetcat_id gte 0 ? "asset/#get_asset.assetcat_path#" : get_asset.assetcat_path />
                        <cfset fileExtention = listlast(get_asset.asset_file_name,'.') />
                        <cfset fileFullPath = "#expandPath('/documents/#filePath#/#get_asset.asset_file_name#')#" />
                        <cfif fileExists( fileFullPath )>

                            <cfoutput>
                                <cfset fileType = fileSystem.fileType( fileExtention ) />
                                <cfif fileType['fileType'] eq 'video'>
                                    
                                    <cfif (fileExtention eq "mp4")><cfset videoType = "video/mp4">
                                    <cfelseif (fileExtention eq "mpeg")><cfset videoType = "video/mpeg">
                                    </cfif>
                                    <cfif isDefined("videoType")>
                                        <video width="100%" controls controlsList="nodownload">
                                            <source src="/documents/#filePath#/#get_asset.asset_file_name###t=1" type="#videoType#">
                                            <p>Your browser doesn't support HTML5 video.</p>
                                        </video>
                                    <cfelse>
                                        Bu video formatı desteklenmiyor!
                                    </cfif>

                                <cfelseif fileType['fileType'] eq "audio">
                                    
                                    <cfif (fileExtention eq "ogg")><cfset audioType = "audio/ogg">
                                    <cfelseif (ext eq "mp3")><cfset audioType = "audio/mpeg">
                                    <cfelseif (ext eq "wav")><cfset audioType = "audio/wav">
                                    </cfif>

                                    <cfif isDefined("audioType")>
                                        <audio style="width:250px;" controls controlsList="nodownload">
                                            <source src="/documents/#filePath#/#get_asset.asset_file_name#" type="#audioType#">
                                            Your browser does not support the HTML5 audio element.
                                        </audio>
                                    <cfelse>
                                        Bu ses formatı desteklenmiyor!
                                    </cfif>

                                <cfelseif fileType['fileType'] eq "image">
                                    <div class="">
                                        <img src="/documents/#filePath#/#get_asset.asset_file_name#" width="auto" height="auto">
                                    </div>
                                <cfelse>
                                    <script>
                                        window.open('#siteUrl#/documents/#filePath#/#get_asset.asset_file_name#','Download File');
                                        location.reload();
                                    </script>
                                </cfif>
                            </cfoutput>

                        <cfelse>
                            <cf_get_lang dictionary_id='46489.File not found'>!
                        </cfif>
                    <cfelse>
                        <cfoutput><a href="#get_asset.EMBEDCODE_URL#" target="_blank">#get_asset.EMBEDCODE_URL#</a></cfoutput>
                    </cfif>
                </div>
            </div>
            <cfif get_asset.record_par eq session_base.userid>
                <div class="draggable-footer">
                    <cfset act_id=attributes.action_section>
                    <cfif attributes.action_section eq 'G_SERVICE_ID'>
                        <cfset act_id='id'>
                    <cfelseif attributes.action_section eq 'WORK_ID'>
                        <cfset act_id='wid'>
                    </cfif>
                    <cf_workcube_buttons is_insert="1" class="btn-danger" data_action="/V16/objects2/cfc/asset:delAsset" next_page="#site_language_path#/#attributes.page_name#?#act_id#=" insert_info="#getLang('','',57463)#" insert_alert="#getLang('','',33888)#">
                </div>
            </cfif>
        </cfform>

    <cfelse>
        <cf_get_lang dictionary_id='57532.You are not authorized!'>!
    </cfif>

<cfelse>
    <cf_get_lang dictionary_id='52351.Please Select Document'>!
</cfif>