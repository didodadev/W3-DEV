<cf_date tarih="form.process_date">
<cftry>
	<cffile action="read" file="#uploaded_file#" variable="dosya">
	<cfset file_name = "#createUUID()#.txt">
	<cfcatch type="Any">
		<script type="text/javascript">
			alert("<cf_get_lang dictionary_id='57455.Dosyanız Upload Edilemedi ! Dosyanızı Kontrol Ediniz'>!");
			history.back();
		</script>
		<cfabort>
	</cfcatch>
</cftry>
<cflock name="#CreateUUID()#" timeout="60">
	<cftransaction>
		<cfquery name="ADD_FILE" datasource="#DSN2#">
			INSERT INTO
				FILE_IMPORTS
				(	
					PROCESS_TYPE,
					STARTDATE,
					FILE_NAME,
					<!--- FILE_SIZE, --->
					FILE_SERVER_ID,
					FILE_CONTENT,
					IMPORTED,
					SOURCE_SYSTEM,
					RECORD_DATE,
					RECORD_IP,
					RECORD_EMP
				)
				VALUES
				(
					-7,
					#form.process_date#,
					'#file_name#',
					<!--- #file_size#, --->
					#fusebox.server_machine#,
					'#Encrypt(dosya,attributes.key_type,"CFMX_COMPAT","Hex")#',
					0,
					#attributes.bank_type#,
					#now()#,		
					'#cgi.remote_addr#',
					#session.ep.userid#
				)
		</cfquery>
	</cftransaction>
</cflock>
<script type="text/javascript">
	alert("<cf_get_lang dictionary_id='56819.Dosyanız upload edildi'>!");
	<cfif  isdefined("attributes.draggable")>location.href = document.referrer;<cfelse>	wrk_opener_reload();window.close();</cfif>

</script>
