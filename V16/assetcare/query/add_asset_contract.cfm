<cfif len(attributes.SUPPORT_START_DATE)>
   <cf_date tarih="SUPPORT_START_DATE">
</cfif>
<cfif len(attributes.SUPPORT_FINISH_DATE)>
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


<cfset form.photo = '#file_name#.#cffile.serverfileext#'>
<cfcatch type="Any">
	<script type="text/javascript">
		alert("<cf_get_lang no='18.Dosyaniz Upload Edilemedi ! Dosyanizi Kontrol Ediniz !'>");
		history.back();
	</script>
	<cfabort>
</cfcatch>  
</cftry>
</cfif>
<cfquery name="ADD_ASSET_CONTRACT" datasource="#DSN#">
	INSERT
		ASSET_CARE_CONTRACT
	(
		ASSET_ID,
		CONTRACT_HEAD,
		SUPPORT_COMPANY_ID,
		SUPPORT_AUTHORIZED_ID,
		SUPPORT_EMPLOYEE_ID,
		SUPPORT_START_DATE,
		SUPPORT_FINISH_DATE,
		<cfif len(document)>USE_CERTIFICATE,</cfif>
		<cfif len(document)>USE_CERTIFICATE_SERVER_ID,</cfif>
		SUPPORT_CAT_ID,
		DETAIL,
		RECORD_EMP,
		RECORD_DATE,
		RECORD_IP
	)
	VALUES
	(
		#attributes.ASSET_ID#,
		<cfif len(attributes.CONTRACT_HEAD)>'#attributes.CONTRACT_HEAD#',<cfelse>NULL,</cfif>
		<cfif isdefined("attributes.COMPANY_ID") and len(attributes.COMPANY_ID)>#attributes.COMPANY_ID#,<cfelse>NULL,</cfif>
		<cfif isdefined("attributes.AUTHORIZED_ID") and len(attributes.AUTHORIZED_ID)>#attributes.AUTHORIZED_ID#,<cfelse>NULL,</cfif>
		<cfif isdefined("attributes.EMPLOYEE_ID") and len(attributes.EMPLOYEE_ID)>#attributes.EMPLOYEE_ID#,<cfelse>NULL,</cfif>
		<cfif len(SUPPORT_START_DATE)>#SUPPORT_START_DATE#,<cfelse>NULL,</cfif>
		<cfif len(SUPPORT_FINISH_DATE)>#SUPPORT_FINISH_DATE#,<cfelse>NULL,</cfif>
		<cfif len(attributes.document)>'#file_name#',</cfif>
		<cfif len(attributes.document)>#fusebox.server_machine#,</cfif>
		<cfif len(attributes.SUPPORT_CAT)>#attributes.SUPPORT_CAT#,<cfelse>NULL,</cfif>
		'#attributes.detail#',
		#session.ep.userid#,
		#now()#,
		'#cgi.remote_addr#'
   )
</cfquery>
<script type="text/javascript">
	wrk_opener_reload();
	window.close();
</script>
