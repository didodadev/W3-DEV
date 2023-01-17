<cfif len(SUPPORT_FINISH_DATE)>
    <cf_date tarih="SUPPORT_FINISH_DATE">
</cfif>
<cfif len (attributes.document)>
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
<cfquery name="add_asset_care" datasource="#DSN#">
	INSERT 
		INTO
	ASSET_CARE_REPORT
			(
			ASSET_ID,
			ASSET_TYPE,
			COMPANY_ID,
			COMPANY_PARTNER_ID,
			C_EMPLOYEE1_ID,
			C_EMPLOYEE2_ID,
			FILE_NAME,
		    FILE_SERVER_ID,
			CARE_DATE,
			CARE_TYPE,
			STATUS,
			DETAIL,
			RECORD_EMP,
			RECORD_IP,
			RECORD_DATE
			
			)
	VALUES
			(
			#attributes.ASSET_ID#,
			'P',
			<cfif len(attributes.SERVICE_COMPANY_ID)>
			#attributes.SERVICE_COMPANY_ID#,
			<cfelse>
			NULL,
			</cfif> 
			<cfif len(attributes.MEMBER_ID)>
			#attributes.MEMBER_ID#,
			<cfelse>
			NULL,
			</cfif>
			<cfif len(attributes.EMPLOYEE_ID)>
			#attributes.EMPLOYEE_ID#,
			<cfelse>
			NULL,
			</cfif>
			<cfif len(attributes.EMPLOYEE_ID2)>
			#attributes.EMPLOYEE_ID2#,
			<cfelse>
			NULL,
			</cfif>
			<cfif len (file_name)>
			'#file_name#',
			#fusebox.server_machine#,
			<cfelse>
			NULL,
			NULL,
			</cfif>
			#SUPPORT_FINISH_DATE#,
			#attributes.PERIODIC_CARE#,
			#attributes.SUPPORT_CAT#,
			<cfif len(attributes.CARE_DETAIL)>
			'#attributes.CARE_DETAIL#',
			<cfelse>
			NULL,
			</cfif>
			#SESSION.EP.USERID#,
			'#CGI.REMOTE_ADDR#',
			#NOW()#
			
			)
</cfquery>
<script type="text/javascript">
 wrk_opener_reload();
 window.close();
</script>
