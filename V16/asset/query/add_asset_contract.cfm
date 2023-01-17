<cfif len(SUPPORT_START_DATE)>
   <cf_date tarih="SUPPORT_START_DATE">
</cfif>
<cfif len(SUPPORT_FINISH_DATE)>
    <cf_date tarih="SUPPORT_FINISH_DATE">
</cfif>
<cfif len(document)>
<cftry>
<cffile action = "upload" 
  fileField = "document" 
  destination = "#upload_folder#asset#dir_seperator#" 
  nameConflict = "MakeUnique" 
  mode="777">
<cfset file_name = createUUID() & '.' & #cffile.serverfileext#>
<cffile action="rename" source="#upload_folder#asset#dir_seperator##cffile.serverfile#" destination="#upload_folder#asset#dir_seperator##file_name#">

<!---Script dosyalarını engelle  02092010 ND --->
<cfset assetTypeName = listlast(cffile.serverfile,'.')>
<cfset blackList = 'php,php2,php3,php4,php5,phtml,pwml,inc,asp,aspx,ascx,jsp,cfm,cfml,cfc,pl,bat,exe,com,dll,vbs,reg,cgi,htaccess,asis'>
<cfif listfind(blackList,assetTypeName,',')>
	<cffile action="delete" file="#upload_folder#asset#dir_seperator##file_name#">
	<script type="text/javascript">
		alert("\'php\',\'jsp\',\'asp\',\'cfm\',\'cfml\' Formatlarında Dosya Girmeyiniz!!");
		history.back();
	</script>
	<cfabort>
</cfif>	

<cfcatch type="Any">
	<script type="text/javascript">
		alert("<cf_get_lang_main no ='43.Dosyanız Upload Edilemedi ! Dosyanizi Kontrol Ediniz'>!");
		history.back();
	</script>
	<cfabort>
</cfcatch>  
</cftry>
</cfif>
<cfquery name="add_asset_contract" datasource="#DSN#">
  INSERT
    ASSET_CARE_CONTRACT
	   (
		 ASSET_ID,
		 SUPPORT_COMPANY_ID,
		 SUPPORT_AUTHORIZED_ID,
		 SUPPORT_EMPLOYEE_ID,
		 DETAIL,
		 SUPPORT_START_DATE,
		 SUPPORT_FINISH_DATE,
		 USE_CERTIFICATE,
		 USE_CERTIFICATE_SERVER_ID,
		 SUPPORT_CAT_ID
	   )
   VALUES
	   (
		#URL.ASSET_ID#,
		#COMPANY_ID#,
		#AUTHORIZED_ID#,
		#EMPLOYEE_ID#,
		'#detail#',
		#SUPPORT_START_DATE#,
		#SUPPORT_FINISH_DATE#,
		'#file_name#',
		#fusebox.server_machine#,
		#SUPPORT_CAT#
	   )
</cfquery>
<script type="text/javascript">
 wrk_opener_reload();
 window.close();
</script>
