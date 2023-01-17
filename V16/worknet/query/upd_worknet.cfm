<cfquery name="getImage" datasource="#DSN#">
	SELECT 
		IMAGE_PATH,
		SERVER_IMAGE_PATH_ID
	FROM 
		WORKNET
	WHERE 
		WORKNET_ID=<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.wid#">
</cfquery>

<cfif isDefined("attributes.upload_file") and len(attributes.upload_file)>
	<cfset upload_folder = "#upload_folder#/asset/watalogyImages/">
	<cfif Not directoryExists('#upload_folder#')>
        <cfset directoryCreate('#upload_folder#') />
    </cfif>
    <!--- eski varsa sil --->
    <cfif len(getImage.IMAGE_PATH)>
		<cffile action="delete" file="#upload_folder##getImage.IMAGE_PATH#">
    </cfif>
    <!--- Yenisini yükle --->
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
<cfelse>
    <cfset attributes.upload_file = getImage.IMAGE_PATH>
</cfif>
<cfset worknet = createObject("component","V16.worknet.cfc.worknet")>
<cfparam name="attributes.is_active" default="0">
<cfset response = worknet.update(
    wid         :   attributes.wid,
    worknet     :   attributes.worknet,
    website     :   attributes.website,
	application_web_adress       :   attributes.application_web_adress,
    detail      :   attributes.detail,
    company_id  :   attributes.company_id,
    partner_id  :   attributes.partner_id,
    is_active   :   attributes.is_active,
    emp_id      :   attributes.emp_id,
    emp_name    :   attributes.emp_name,
	emp_email   :   attributes.emp_email,
	image_path  :   attributes.upload_file,
    server_image_path_id    :   fusebox.server_machine
)>
<cfif response>
    <script type="text/javascript">
        <cfoutput>
            window.location.href = '#request.self#?fuseaction=worknet.list_worknet&event=upd&wid=#attributes.wid#';
        </cfoutput>
    </script>
<cfelse>
    <script>
        alert('<cf_get_lang dictionary_id = "48344">');
    </script>
</cfif>