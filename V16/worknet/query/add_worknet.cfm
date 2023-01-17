<cfif isDefined("upload_file") and len(attributes.upload_file)>
	<cfset upload_folder = "#upload_folder#/asset/watalogyImages/">
	<cfif Not directoryExists('#upload_folder#')>
        <cfset directoryCreate('#upload_folder#') />
    </cfif>
	<cftry>
		<cffile action="UPLOAD" filefield="upload_file" destination="#upload_folder#" mode="777" nameconflict="MAKEUNIQUE" accept="image/*">

		<cfset file_name = createUUID()>
		<cffile action="rename" source="#upload_folder##cffile.serverfile#" destination="#upload_folder##file_name#.#cffile.serverfileext#">
		
		<!---Script dosyalarını engelle  02092010 FA,ND --->
		<cfset assetTypeName = listlast(cffile.serverfile,'.')>
		<cfset blackList = 'php,php2,php3,php4,php5,phtml,pwml,inc,asp,aspx,ascx,jsp,cfm,cfml,cfc,pl,bat,exe,com,dll,vbs,reg,cgi,htaccess,asis'>
		<cfif listfind(blackList,assetTypeName,',')>
			<cffile action="delete" file="#upload_folder##file_name#.#cffile.serverfileext#">
			<script type="text/javascript">
				alert("\'php\',\'jsp\',\'asp\',\'cfm\',\'cfml\' Formatlarında Dosya Girmeyiniz!!");
				history.back();
			</script>
			<cfabort>
		</cfif>		
			
		<cfset attributes.upload_file = '#file_name#.#cffile.serverfileext#'>
		<cfcatch type="Any">
			<script type="text/javascript">
				alert("<cf_get_lang_main no ='43.Dosyanız upload edilemedi ! Dosyanızı kontrol ediniz'> !");
				history.back();
			</script>
			<cfabort>
		</cfcatch>  
	</cftry>
</cfif>

<cfset worknetInsert = createObject("component","V16.worknet.cfc.worknet")>
<cfparam name="attributes.is_active" default="0">
<cfparam name="attributes.upload_file" default="">
<cfset response = worknetInsert.insert(
    worknet      :   attributes.worknet,
	website          :   attributes.website,
    detail          :   attributes.detail,
    company_id          :   attributes.company_id,
	partner_id          :   attributes.partner_id,
	is_active          :   attributes.is_active,
    process_stage          :   attributes.process_stage,
    emp_id          :   attributes.emp_id,
    emp_name          :   attributes.emp_name,
    emp_email     :   attributes.emp_email,
    image_path :   attributes.upload_file,
    server_image_path_id   :   fusebox.server_machine
)>
<cfif response.status>
    <script type="text/javascript">
        <cfoutput>
            window.location.href = '#request.self#?fuseaction=worknet.list_worknet&event=upd&wid=#response.result.IDENTITYCOL#';
        </cfoutput>
    </script>
<cfelse>
    <script>
        alert('<cf_get_lang dictionary_id = "48344">');
    </script>
</cfif>