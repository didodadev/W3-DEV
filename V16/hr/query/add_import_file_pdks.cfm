<cftransaction>
<cfset attributes.upload_folder = "#upload_folder#hr#dir_seperator#">
<cftry>
	<cffile action = "upload"
		fileField = "uploaded_file"
		destination = "#attributes.upload_folder#"
		nameConflict = "MakeUnique"
		mode="777">
		<cfset file_name = "#createUUID()#.#cffile.serverfileext#">
	<cffile action="rename" source="#attributes.upload_folder##cffile.serverfile#" destination="#attributes.upload_folder##file_name#">	
	<!---Script dosyalarını engelle  02092010 FA,ND --->
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
			alert("<cf_get_lang_main no ='43.Dosyanız upload edilemedi ! Dosyanızı kontrol ediniz'> !");
			history.back();
		</script>
		<cfabort>
	</cfcatch>
</cftry>
<cfquery name="ADD_FILE" datasource="#DSN#">
	INSERT INTO
		FILE_IMPORTS_MAIN
	(	
		FILE_FORMAT,
		PROCESS_TYPE,
		FILE_NAME,
		FILE_SIZE,
		FILE_SERVER_ID,
		DELIMITER,
		LINE_COUNT,
		IMPORTED,
		BRANCH_ID,
		PAPER_TYPE,
		IS_PUANTAJ_OFF,
		REAL_NAME,
		TIME_CHOICE,
		RECORD_DATE,
		RECORD_IP,
		RECORD_EMP
	)
	VALUES
	(
		2,<!---ISO-8859-9 için 1 ,UTF-8 için se 2 atıyoruz--->
		-1,<!---bu sayfa için -1 koydum --->
		'#file_name#',
		#file_size#,
		#fusebox.server_machine#,
		3,<!---virgül için 1 noktalı virgül için 2 atıyoruz tabloya boşluk için 3--->
		0,
		0,
		<cfif len(attributes.branch_id)>#attributes.branch_id#,<cfelse>NULL,</cfif>
		#attributes.paper_type#,
		<cfif isdefined("attributes.is_puantaj_off") and len(attributes.is_puantaj_off)>1,<cfelse>0,</cfif>
		'#cffile.CLIENTFILENAME#',
		#attributes.time_choice#,
		#now()#,		
		'#cgi.remote_addr#',
		#session.ep.userid#
	)
</cfquery>
<script type="text/javascript">
	alert("<cf_get_lang no ='1734.Dosyanız upload edildi '>!");
	location.href="<cfoutput>#request.self#</cfoutput>?fuseaction=hr.list_emp_daily_in_out";
//	window.close();
</script>
</cftransaction>
