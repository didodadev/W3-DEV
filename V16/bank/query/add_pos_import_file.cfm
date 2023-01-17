<cf_date tarih="form.process_date">
<cfset attributes.upload_folder = "#upload_folder#finance#dir_seperator#">
<cftry>
	<cffile action = "upload"
		fileField = "uploaded_file"
		destination = "#attributes.upload_folder#"
		nameConflict = "MakeUnique"
		mode="777">
		<cfset file_name = "#createUUID()#.txt">
	<cffile action="rename" source="#attributes.upload_folder##cffile.serverfile#" destination="#attributes.upload_folder##file_name#">	
	<!---Script dosyalarını engelle  02092010 ND --->
	<cfset assetTypeName = listlast(cffile.serverfile,'.')>
	<cfset blackList = 'php,php2,php3,php4,php5,phtml,pwml,inc,asp,aspx,ascx,jsp,cfm,cfml,cfc,pl,bat,exe,com,dll,vbs,reg,cgi,htaccess,asis'>
	<cfif listfind(blackList,assetTypeName,',')>
		<cffile action="delete" file="#attributes.upload_folder##file_name#">
		<script type="text/javascript">
			alert("\'php\',\'jsp\',\'asp\',\'cfm\',\'cfml\' Formatlarında Dosya Girmeyiniz!!");
			history.back();
		</script>
		<cfabort>
	</cfif>	
	
	<cfset file_size = cffile.filesize>
	<cfcatch type="Any">
		<script type="text/javascript">
			alert("<cf_get_lang_main no ='43.Dosyanız Upload Edilemedi ! Dosyanizi Kontrol Ediniz'>!");
			history.back();
		</script>
		<cfabort>
	</cfcatch>
</cftry>
<cfquery name="ADD_FILE" datasource="#DSN2#">
	INSERT INTO
		FILE_IMPORTS
		(	
			PROCESS_TYPE,
			STARTDATE,
			FILE_NAME,
			FILE_SIZE,
			FILE_SERVER_ID,
			IMPORTED,
			SOURCE_SYSTEM,
			RECORD_DATE,
			RECORD_IP,
			RECORD_EMP
		)
		VALUES
		(
			-8,<!--- toplu pos dönüşleri import --->
			#attributes.process_date#,
			'#file_name#',
			#file_size#,
			#fusebox.server_machine#,
			0,
			#attributes.bank_type#,
			#now()#,		
			'#cgi.remote_addr#',
			#session.ep.userid#
		)
</cfquery>
<script type="text/javascript">
	alert("<cf_get_lang no ='391.Dosyanız Upload Edildi'> !");
	wrk_opener_reload();
	window.close();
</script>
