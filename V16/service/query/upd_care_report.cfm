<cfif isdefined("attributes.service_start_date") and len(attributes.service_start_date)>
	<cf_date tarih='attributes.service_start_date'>
<cfscript>
	if(isDefined ("attributes.start_clock") and len(attributes.start_clock))
		attributes.service_start_date = date_add('h',attributes.start_clock, attributes.service_start_date);
	if( isDefined ("attributes.start_minute") and len(attributes.start_minute))
		attributes.service_start_date = date_add('n',attributes.start_minute, attributes.service_start_date);
</cfscript>
<cfif isdefined("attributes.service_finish_date") and len(attributes.service_finish_date)>
	<cf_date tarih='attributes.service_finish_date'>
	<cfscript>
		if( isDefined("attributes.finish_clock") and len(attributes.finish_clock))
			attributes.service_finish_date = date_add('h',attributes.finish_clock, attributes.service_finish_date);
		if( isDefined("attributes.finish_minute") and len(attributes.finish_minute))
			attributes.service_finish_date = date_add('n',attributes.finish_minute, attributes.service_finish_date);
	</cfscript>
</cfif>
</cfif>
<cfif isdefined("attributes.document") and len(attributes.document)>
	<cftry>
	<cffile action = "upload" 
	  fileField = "document" 
	  destination = "#upload_folder#service#dir_seperator#" 
	  nameConflict = "MakeUnique" 
	  mode="777">
	<cfset file_name = createUUID() & '.' & cffile.serverfileext>
	<cffile action="rename" source="#upload_folder#service#dir_seperator##cffile.serverfile#" destination="#upload_folder#service#dir_seperator##file_name#">
	<!---Script dosyalarini engelle  02092010 FA-ND --->
	<cfset assetTypeName = listlast(cffile.serverfile,'.')>
	<cfset blackList = 'php,php2,php3,php4,php5,phtml,pwml,inc,asp,aspx,ascx,jsp,cfm,cfml,cfc,pl,bat,exe,com,dll,vbs,reg,cgi,htaccess,asis'>
	<cfif listfind(blackList,assetTypeName,',')>
		<cffile action="delete" file="#upload_folder#service#dir_seperator##file_name#">
		<script type="text/javascript">
			alert("\'php\',\'jsp\',\'asp\',\'cfm\',\'cfml\' Formatlarinda Dosya Girmeyiniz!!");
			history.back();
		</script>
		<cfabort>
	</cfif>	
	<cfset form.photo = '#file_name#.#cffile.serverfileext#'>
	<cfcatch type="Any">
		<script type="text/javascript">
			alert("<cf_get_lang_main no='43.Dosyaniz upload edilemedi ! Dosyanizi kontrol ediniz !'>");
			history.back();
		</script>
		<cfabort>
	</cfcatch>  
	</cftry>
	<cfif isDefined("attributes.old_document") and Len(attributes.old_document) and FileExists("#upload_folder#service#dir_seperator##attributes.old_document#")>
		<!--- Yeni Dosya Eklenirken Eskisini De Silmesi Lazim FBS 20101102 --->
		<cffile action="delete" file="#upload_folder#service#dir_seperator##attributes.old_document#">
	</cfif>
</cfif>
<cfquery NAME="ADD_SERVICE_CONTRACT" DATASOURCE="#DSN3#">
	UPDATE
		SERVICE_CARE_REPORT
	SET
		SERIAL_NO='#attributes.serial_no#',
		COMPANY_PARTNER_TYPE=<cfif len(attributes.service_member_type)>'#attributes.service_member_type#'<cfelse>NULL</cfif>,
		COMPANY_PARTNER_ID=<cfif len(attributes.service_member_id)>#attributes.service_member_id#<cfelse>NULL</cfif>,
		EMPLOYEE1_ID=<cfif len(attributes.employee_id)>#attributes.employee_id#<cfelse>NULL</cfif>,
		EMPLOYEE2_ID=<cfif len(attributes.employee_id2)>#attributes.employee_id2#<cfelse>NULL</cfif>,
		<cfif len(attributes.document)>
			FILE_NAME='#file_name#',
			FILE_SERVER_ID=#fusebox.server_machine#,
		</cfif>
		CARE_DATE=<cfif isdefined("attributes.service_start_date") and len(attributes.service_start_date)>#attributes.service_start_date#<cfelse>NULL</cfif>,
		CARE_FINISH_DATE = <cfif isDefined("attributes.service_finish_date") and len(attributes.service_finish_date)>#attributes.service_finish_date#<cfelse>NULL</cfif>,
		DETAIL=<cfif len(attributes.detail)>'#attributes.detail#'<cfelse>NULL</cfif>,
		PRODUCT_ID=#attributes.product_id#,
		SERVICE_SUBSTATUS=<cfif len(attributes.service_substatus)>#attributes.service_substatus#<cfelse>NULL</cfif>,
		CONTRACT_HEAD='#attributes.contract_head#',
		CARE_CAT=<cfif len(attributes.service_care)>#attributes.service_care#<cfelse>NULL</cfif>,
		UPDATE_EMP=#SESSION.EP.USERID#,
		UPDATE_IP='#CGI.REMOTE_ADDR#',
		UPDATE_DATE=#NOW()#
	WHERE
		CARE_REPORT_ID=#attributes.id#
</cfquery>
<cfset attributes.actionId = attributes.id>
<script type="text/javascript">
	window.location.href = '<cfoutput>#request.self#?fuseaction=service.list_service_report&event=upd&id=#attributes.id#</cfoutput>';
</script>