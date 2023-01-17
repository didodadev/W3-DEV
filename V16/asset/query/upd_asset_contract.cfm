<cfif len(SUPPORT_START_DATE)>
   <cf_date tarih="SUPPORT_START_DATE">
</cfif>
<cfif len(SUPPORT_FINISH_DATE)>
    <cf_date tarih="SUPPORT_FINISH_DATE">
</cfif>
<cfif attributes.document neq ''>
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
				alert("<cf_get_lang_main no ='43.Dosyanız Upload Edilemedi ! Dosyanizi Kontrol Ediniz'>");
				history.back();
			</script>
			<cfabort>
		</cfcatch>  
	</cftry>
</cfif>
<cfquery name="upd_asset_contract" datasource="#DSN#">
  UPDATE
   ASSET_CARE_CONTRACT
  SET
    ASSET_ID = #URL.ASSET_ID#,
	SUPPORT_COMPANY_ID = #company_id#,
	SUPPORT_AUTHORIZED_ID = #authorized_id#,
	SUPPORT_EMPLOYEE_ID = #EMPLOYEE_ID#,
	DETAIL = '#detail#',
	SUPPORT_START_DATE = #SUPPORT_START_DATE#,
	SUPPORT_FINISH_DATE = #SUPPORT_FINISH_DATE#,
	<cfif isdefined("file_name")>
	USE_CERTIFICATE = '#file_name#',
	USE_CERTIFICATE_SERVER_ID=#fusebox.server_machine#,
	</cfif>
	SUPPORT_CAT_ID = #support_cat#
WHERE
	ASSET_CARE_CONTRACT_ID = #attributes.asset_care_contract_id#
</cfquery>
<script type="text/javascript">
 wrk_opener_reload();
 window.close();
</script>
