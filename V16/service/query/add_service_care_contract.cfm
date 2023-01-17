<cfif isdefined("attributes.service_start_date") and len(attributes.service_start_date)>
	<cf_date tarih='attributes.service_start_date'>
	<cfscript>
		if(len(attributes.start_clock))
			attributes.service_start_date = date_add('h',attributes.start_clock, attributes.service_start_date);
		if(len(attributes.start_minute))
			attributes.service_start_date = date_add('n',attributes.start_minute, attributes.service_start_date);
	</cfscript>
</cfif>
<cfif isdefined("attributes.service_finish_date") and  len(attributes.service_finish_date)>
	<cf_date tarih='attributes.service_finish_date'>
	<cfscript>
		if(len(attributes.finish_clock))
			attributes.service_finish_date = date_add('h',attributes.finish_clock, attributes.service_finish_date);
		if(len(attributes.finish_minute))
			attributes.service_finish_date = date_add('n',attributes.finish_minute, attributes.service_finish_date);
	</cfscript>
</cfif>
<cfif isdefined("attributes.document") and len(attributes.document)>
<cftry>
<cffile action = "upload" 
  fileField = "document" 
  destination = "#upload_folder#service#dir_seperator#" 
  nameConflict = "MakeUnique" 
  mode="777">
<cfset file_name = createUUID() & '.' & #cffile.serverfileext#>
<cffile action="rename" source="#upload_folder#service#dir_seperator##cffile.serverfile#" destination="#upload_folder#service#dir_seperator##file_name#">
<!---Script dosyalarını engelle  02092010 FA-ND --->
<cfset assetTypeName = listlast(cffile.serverfile,'.')>
<cfset blackList = 'php,php2,php3,php4,php5,phtml,pwml,inc,asp,aspx,ascx,jsp,cfm,cfml,cfc,pl,bat,exe,com,dll,vbs,reg,cgi,htaccess,asis'>
<cfif listfind(blackList,assetTypeName,',')>
	<cffile action="delete" file="#upload_folder#service#dir_seperator##file_name#">
	<script type="text/javascript">
		alert("\'php\',\'jsp\',\'asp\',\'cfm\',\'cfml\' Formatlarında Dosya Girmeyiniz!!");
		history.back();
	</script>
	<cfabort>
</cfif>	
<cfset form.photo = '#file_name#.#cffile.serverfileext#'>
<cfcatch type="Any">
	<script type="text/javascript">
		alert("<cf_get_lang no='36.Dosyaniz upload edilemedi ! Dosyanizi kontrol ediniz !'>");
		history.back();
	</script>
	<cfabort>
</cfcatch>  
</cftry>
</cfif>
<cfquery NAME="ADD_SERVICE_CONTRACT" DATASOURCE="#DSN3#" result="MAXID">
	INSERT INTO
	SERVICE_CARE_REPORT
	(
		SERIAL_NO,
		COMPANY_PARTNER_TYPE,
		COMPANY_PARTNER_ID,
		EMPLOYEE1_ID,
		EMPLOYEE2_ID,
		FILE_NAME,
		FILE_SERVER_ID,
		CARE_DATE,
		CARE_FINISH_DATE,
		DETAIL,
		PRODUCT_ID,
		SERVICE_SUBSTATUS,
		CONTRACT_HEAD,
		CARE_CAT,
		RECORD_EMP,
		RECORD_IP,
		RECORD_DATE
	)
	VALUES
	(
		'#attributes.SERIAL_NO#',
		<cfif len(attributes.SERVICE_MEMBER_TYPE)>'#attributes.SERVICE_MEMBER_TYPE#'<cfelse>NULL</cfif>,
		<cfif len(attributes.SERVICE_MEMBER_ID)>#attributes.SERVICE_MEMBER_ID#<cfelse>NULL</cfif>,
		<cfif len(attributes.EMPLOYEE_ID)>#attributes.EMPLOYEE_ID#<cfelse>NULL</cfif>,
		<cfif len(attributes.EMPLOYEE_ID2)>#attributes.EMPLOYEE_ID2#<cfelse>NULL</cfif>,
		<cfif len(attributes.DOCUMENT)>'#FILE_NAME#'<cfelse>NULL</cfif>,
		<cfif len(attributes.DOCUMENT)>#fusebox.server_machine#<cfelse>NULL</cfif>,
		<cfif isdefined("attributes.service_start_date") and len(attributes.service_start_date)>#attributes.service_start_date#<cfelse>NULL</cfif>,
		<cfif isdefined("attributes.service_finish_date") and len(attributes.service_finish_date)>#attributes.service_finish_date#<cfelse>NULL</cfif>,
		<cfif len(attributes.DETAIL)>'#attributes.DETAIL#'<cfelse>NULL</cfif>,
		#attributes.PRODUCT_ID#,
		<cfif len(attributes.SERVICE_SUBSTATUS)>#attributes.SERVICE_SUBSTATUS#<cfelse>NULL</cfif>,
		'#attributes.CONTRACT_HEAD#',
		<cfif len(attributes.SERVICE_CARE)>#attributes.SERVICE_CARE#<cfelse>NULL</cfif>,
		#SESSION.EP.USERID#,
		'#CGI.REMOTE_ADDR#',
		#NOW()#
	)
</cfquery>
<cfset attributes.actionId = MAXID.IDENTITYCOL>
<script type="text/javascript">
	window.location.href = '<cfoutput>#request.self#?fuseaction=service.list_service_report&event=upd&id=#attributes.actionId#</cfoutput>';
</script>

