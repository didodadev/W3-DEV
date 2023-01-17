<cf_date tarih="attributes.processdate">
<cfif not isdefined("form.department_id") and not isdefined("attributes.processdate")>
	<script type="text/javascript">
		alert("Form'da hata var, lütfen tekrar deneyiniz!");
		history.back();
	</script>
	<cfabort>
</cfif>
<cflock name="#CreateUUID()#" timeout="20">
	<cftransaction>
		<cfset attributes.upload_folder = "#upload_folder#store#dir_seperator#">
		<cftry>
			<cffile action = "upload"
				fileField = "uploaded_file"
				destination = "#attributes.upload_folder#"
				nameConflict = "MakeUnique"
				mode="777">
			
				<cfset file_name = "#createUUID()#.#cffile.serverfileext#">
			<cffile action="rename" source="#attributes.upload_folder##cffile.serverfile#" destination="#attributes.upload_folder##file_name#">	
			<!---Script dosyalarını engelle  02092010 FA-ND --->
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
					alert("Dosyanız upload edilemedi ! Dosyanızı kontrol ediniz!");
					history.back();
				</script>
				<cfabort>
			</cfcatch>
		</cftry>
		
		<cfscript>
			if (listlen(form.department_id,"-") eq 2)
				{
					department_id = listfirst(form.department_id,"-");
					department_location = listlast(form.department_id,"-");
				}
			else
				department_id = listfirst(form.department_id,"-");
		</cfscript>
		
		<cfquery name="ADD_FILE" datasource="#DSN2#">
			INSERT INTO
				FILE_IMPORTS
			(	
				SOURCE_SYSTEM,
				PROCESS_TYPE,
				STARTDATE,
				FILE_NAME,
				FILE_SERVER_ID,
				FILE_SIZE,
				IS_MUHASEBE,
				DEPARTMENT_ID,
				DEPARTMENT_LOCATION,
				IMPORTED,
				RECORD_DATE,
				RECORD_IP,
				RECORD_EMP,
				PRICE_CATID
			)
			VALUES
			(
				#target_pos#,
				-9,
				#attributes.processdate#,
				'#file_name#',
				#fusebox.server_machine#,
				#file_size#,
				0,
				#department_id#,
				<cfif isdefined("department_location")>#department_location#<cfelse>NULL</cfif>,
				0,
				#now()#,		
				'#cgi.remote_addr#',
				#session.ep.userid#,
				#attributes.price_catid#
			)
		</cfquery>
		<cfquery name="GET_MAX_ID" datasource="#DSN2#">
			SELECT MAX(I_ID) MAX_ID FROM FILE_IMPORTS WHERE PROCESS_TYPE=-9 AND SOURCE_SYSTEM=#target_pos#
		</cfquery>
	</cftransaction>
</cflock>
<!--- import işlemine başlıyor--->
<cflocation url="#request.self#?fuseaction=objects.emptypopupflush_stock_import&i_id=#GET_MAX_ID.MAX_ID#" addtoken="no">
