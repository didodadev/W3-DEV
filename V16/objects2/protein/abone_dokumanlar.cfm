<cfset mediaplayer_extensions = ".asf,.wma,.avi,.mp3,.mp2,.mpa,.mid,.midi,.rmi,.aif,.aifc,aiff,.au,.snd,.wav,.cda,.wmv,.wm,.dvr-ms,.mpe,.mpeg,.mpg,.m1v,.vob" />
<cfset imageplayer_extensions = ".jpg,.jpeg,.bmp,.gif,.png,.wbmp"/>
<cfparam name="attributes.asset_cat_id" default="19">
<cfparam name="attributes.property_id" default="11">
<cfif isDefined("attributes.module_name") and len( attributes.module_name ) and isDefined("attributes.action_section") and len( attributes.action_section ) and isDefined("attributes.action_id_variable_name") and len( attributes.action_id_variable_name )>
    <cfset decrypt_id = (attributes.action_section eq 'OPP_ID' or attributes.action_section eq 'G_SERVICE_ID')?contentEncryptingandDecodingAES(isEncode:0,content:evaluate(attributes.action_id_variable_name),accountKey:'wrk'):evaluate(attributes.action_id_variable_name)>
    <cfquery name="get_asset" datasource="#dsn#">
        SELECT
            A.ASSET_FILE_NAME,
            A.MODULE_NAME,
            A.ASSET_ID,
            A.ASSETCAT_ID,
            A.ASSET_NAME,
            A.IMAGE_SIZE,
            A.ASSET_FILE_SERVER_ID,
            A.RELATED_COMPANY_ID,
            A.RELATED_CONSUMER_ID,
            A.RELATED_ASSET_ID,
            A.ACTION_ID,
            A.RECORD_EMP,
            A.RECORD_DATE,
            A.ASSET_DESCRIPTION,
            AC.ASSETCAT,
            AC.ASSETCAT_PATH
        FROM
            ASSET AS A,
            ASSET_CAT AS AC
        WHERE
            A.ASSETCAT_ID = AC.ASSETCAT_ID
            AND A.MODULE_NAME = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.module_name#">
            AND A.ACTION_SECTION = <cfqueryparam cfsqltype="cf_sql_varchar" value="#ucase(attributes.action_section)#">
            AND A.ACTION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#decrypt_id#">
            AND A.IS_SPECIAL <> 1
            AND A.IS_ACTIVE = 1
            AND A.COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session_base.our_company_id#">
        ORDER BY 
            A.RECORD_DATE DESC,
            A.ASSET_NAME 
    </cfquery>
    <div id="files_list">
    <cfsavecontent  variable="title"><cf_get_lang dictionary_id='29485.Döküman'></cfsavecontent>
    <cfif get_asset.recordcount>
        <cfset fileSystem = CreateObject("component","V16.asset.cfc.file_system")>
        <ul>
            <cfoutput query = "get_asset">
                <li>
                    <a href="javascript://" onclick="openBoxDraggable('widgetloader?widget_load=showAssetFile&title=#title#&asset_id=#ASSET_ID#&isbox=1&style=maxi&action_section=#attributes.action_section#&action_id=#decrypt_id#&page_name=#attributes.param_1#')" class="none-decoration" title="#ASSET_DESCRIPTION#">
                    
                        <cfset ext=lcase(listlast(asset_file_name, '.')) />
                        <cfset fileSysType = fileSystem.fileType(ext)>
                        <cfset fileType = fileSysType["fileType"]>
                        <cfif fileSysType["fileType"] eq "document" or fileSysType["fileType"] eq "other"> 
                            <cfset imagePath = "https://networg.workcube.com/css/assets/icons/catalyst-icon-svg/#UCase(ext)#.svg">
                            <cfif ext eq 'docx'>
                                <cfset imagePath = "https://networg.workcube.com/css/assets/icons/catalyst-icon-svg/DOC.svg">
                            </cfif>
                        <cfelse>
                            <cfset imagePath = "https://networg.workcube.com/css/assets/icons/catalyst-icon-svg/UNKOWN.svg">
                        </cfif>
                        <img src="#imagePath#" width="20px" class="mr-2">                 
                        #asset_name#                       
                    </a>
                </li>
                <hr>
            </cfoutput>
        </ul>
    <cfelse>
        <p><cf_get_lang dictionary_id='57484.No record'>!</p> 
    </cfif>
    </div>
<cfelse>
    Widget parametrik ayarları yapılandırılmamış!
</cfif>
<script>
  <cfif isdefined("attributes.is_add_file") and attributes.is_add_file eq 1 or 1 eq 1>
    $('#files_list')
    .append(
        $('<a>').addClass('btn btn-color-5')
        .attr({
        onclick :"openBoxDraggable('widgetloader?widget_load=addAsset&isbox=1&style=maxi&title=<cfoutput>#getLang('','',57466)#&asset_cat_id=#attributes.asset_cat_id#&property_id=#attributes.property_id#&action_section=#attributes.action_section#&action_id=#decrypt_id#&module=#attributes.module_name#&page_name=#attributes.param_1#</cfoutput>')"
        ,style:"position:absolute;right:5%;top:10%"
        })
        .prepend($('<i>').addClass('fa fa-cloud-upload')
            
            )
        );
    </cfif>
</script>