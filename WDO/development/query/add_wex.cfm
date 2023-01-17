<cfparam name="attributes.is_active" default="0">
<cfparam name="attributes.time_plan" default="">
<cfset fileSystem = CreateObject("component","V16.asset.cfc.file_system")>
<cfset wex = createObject("component","WDO.development.cfc.wex")>

<cfset upload_folder = application.systemParam.systemParam().upload_folder>
<cfset fileUploadFolder = upload_folder & "wex">

<cfif not DirectoryExists("#fileUploadFolder#")>
    <cfset fileSystem.newFolder(folderPath:upload_folder,folderName:"wex")>
</cfif>

<cfif isdefined('attributes.image') and len(attributes.image)>

    <cffile action = "upload" 
            filefield = "image" 
            destination = "#fileUploadFolder#"
            nameconflict = "MakeUnique" 
            mode="777">	

    <cfset suitableFile = fileSystem.fileControl(filePath:fileUploadFolder,file:file)>
    
    <cfif suitableFile["status"] eq false>
        <script type="text/javascript">
            alert('<cfoutput>#suitableFile["message"]#</cfoutput>');
            history.back();
        </script>
    <cfelse>
        <cftry>
            <cfset oldFile = "#file.SERVERDIRECTORY#/#file.CLIENTFILE#">
            <cfset fileName = "#createUUID()#.#file.SERVERFILEEXT#">
            <cfset queryFileName = "wex/#fileName#">
            <cfset newFile = "#fileUploadFolder#/#fileName#">
            <cffile action = "rename" source = "#oldFile#" destination = "#newFile#" accept="image/jpg,image/png">
            <cfcatch>
                <script type="text/javascript">
                    alert('<cf_get_lang dictionary_id="51704">');
                    history.back();
                </script>
            </cfcatch>
        </cftry>
    </cfif>

</cfif>
<cfif isdefined("arguments.publishing_date") and len(arguments.publishing_date)>
    <cf_date tarih = "arguments.publishing_date">
</cfif>
<cfset response = wex.insert(
        is_active       :   '#attributes.is_active#',
        module          :   '#attributes.module#',
        head            :   '#attributes.head#',
        dictionary_id   :   '#attributes.dictionary_id#',
        version         :   '#attributes.version#',
		type			:	'#attributes.type#',
        licence         :   '#attributes.licence#',
        rest_name       :   '#attributes.rest_name#',
        time_plan_type  :   '#attributes.time_plan_type#',
        time_plan       :   '#iif(IsDefined("attributes.time_plan") and len(attributes.time_plan),attributes.time_plan,DE(''))#',
        authentication  :   '#attributes.authentication#',
        status          :   '#attributes.status#',
        process_stage   :   '#iif(IsDefined("attributes.process_stage") and len(attributes.process_stage),attributes.process_stage,DE(0))#',
        author_name     :   '#attributes.author_name#',
        file_path       :   '#attributes.file_path#',
        related_wo      :   '#iif(IsDefined("attributes.related_wo") and len(attributes.related_wo),"attributes.related_wo",DE(''))#',
        image           :   '#iif(IsDefined("attributes.image") and len(attributes.image),"queryFileName",DE(''))#',
        wex_detail      :   '#iif(IsDefined("attributes.wex_detail") and len(attributes.wex_detail),"attributes.wex_detail",DE(''))#',
        source_wo       :   '#iif(IsDefined("attributes.source_wo") and len(attributes.source_wo),"attributes.source_wo",DE(''))#',
        wex_file_id     :   '#iif(IsDefined("attributes.wex_file_id") and len(attributes.wex_file_id),"attributes.wex_file_id",DE(''))#',
        is_dataservice  :   isdefined("attributes.is_dataservice") and len(attributes.is_dataservice) ? attributes.is_dataservice : 0,
        main_version    :   isdefined("attributes.main_version") and len(attributes.main_version) ? attributes.main_version : '',
        publishing_date :   isdefined("attributes.publishing_date") and len(attributes.publishing_date) ? attributes.publishing_date : '',
        data_converter  :   '#iif(IsDefined("attributes.convert_json") and len(attributes.convert_json),"attributes.convert_json",DE(''))#'
)>

<cfif response.status eq false>
	<cftry>
        <cffile action = "delete" file = "#newFile#">
        <cfcatch type = "any"></cfcatch>
    </cftry>
<cfelse>
    <script type="text/javascript">
        window.location.href = '<cfoutput>#request.self#?fuseaction=dev.wex&event=upd&wxid=#response.RESULT.IDENTITYCOL#</cfoutput>';
    </script>
</cfif>