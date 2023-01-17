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
		<cfset form.photo = '#file_name#.#cffile.serverfileext#'>
		
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
<cfelse>
<cfset file_name=0>
</cfif>
<cfoutput>
<cfquery name="UPD_ASSET_CATE" datasource="#DSN#">
	UPDATE
		ASSET_CARE_REPORT
	SET
		ASSET_ID = #attributes.ASSET_ID#,
		<cfif len(SERVICE_COMPANY_ID)>
			COMPANY_ID = #SERVICE_COMPANY_ID#,
		</cfif>
		<cfif len(MEMBER_ID)>
			COMPANY_PARTNER_ID = #MEMBER_ID#,
		</cfif>
		<cfif len(EMPLOYEE_ID)>
			C_EMPLOYEE1_ID = #EMPLOYEE_ID#,
		</cfif>
		<cfif len(EMPLOYEE_ID)>
			C_EMPLOYEE2_ID = #EMPLOYEE_ID2#,
		</cfif>
		FILE_NAME =	'#file_name#',
		FILE_SERVER_ID=#fusebox.server_machine#,
		CARE_DATE = #SUPPORT_FINISH_DATE#,
		CARE_TYPE = #PERIODIC_CARE#,
		STATUS = #SUPPORT_CAT#,
		DETAIL = '#CARE_DETAIL#',
		UPDATE_EMP =#SESSION.EP.USERID#,
		UPDATE_IP ='#CGI.REMOTE_ADDR#',
		UPDATE_DATE = #NOW()#
	WHERE CARE_REPORT_ID = #URL.CARE_REPORT_ID#
</cfquery>
</cfoutput>
<script type="text/javascript">
	window.location.href ='<cfoutput>#request.self#?fuseaction=assetcare.list_asset_care&event=upd&care_report_id=#url.care_report_id#</cfoutput>';
</script>
