<cfif isdefined("attibutes.folder") and len(attibutes.folder)>
	<cfset fold = ReplaceNoCase(attributes.folder, "/documents/", "")>
<cfelse>
	<cfif attributes.module EQ 'content'>
		<cfset fold = 'content'>
	<cfelseif attributes.module EQ 'training_management'>
		<cfset fold = 'training'>
	<cfelse>
		<cfset fold = attributes.module>
	</cfif>
</cfif>
<cfset file_name = createUUID()>
<cffile action="UPLOAD" nameconflict="OVERWRITE" filefield="dosya" destination="#upload_folder##fold#">
<cffile action="rename" source="#upload_folder##fold##dir_seperator##cffile.serverfile#" destination="#upload_folder##fold##dir_seperator##file_name#.#cffile.serverfileext#">
<!---Script dosyalarını engelle  02092010 FA-ND --->
<cfset assetTypeName = listlast(cffile.serverfile,'.')>
<cfset blackList = 'php,php2,php3,php4,php5,phtml,pwml,inc,asp,aspx,ascx,jsp,cfm,cfml,cfc,pl,bat,exe,com,dll,vbs,reg,cgi,htaccess,asis'>
<cfif listfind(blackList,assetTypeName,',')>
	<cffile action="delete" file="#upload_folder##fold##dir_seperator##file_name#.#cffile.serverfileext#">
	<script type="text/javascript">
		alert("\'php\',\'jsp\',\'asp\',\'cfm\',\'cfml\' Formatlarında Dosya Girmeyiniz!!");
		history.back();
	</script>
	<cfabort>
</cfif>

<script type="text/javascript">
	var eb = window.opener.document.all.editbar;	
	<cfoutput>
		eb._editor.InsertFile("#employee_domain#","/documents/#fold#/#file_name#.#cffile.serverfileext#","#form.detay#");
	</cfoutput>
	window.close();
</script>
