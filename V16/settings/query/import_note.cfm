<cfset upload_folder = "#upload_folder#temp#dir_seperator#">
<cftry>
	<cffile action = "upload" 
			fileField = "uploaded_file" 
			destination = "#upload_folder#"
			nameConflict = "MakeUnique"  
			mode="777" charset="#attributes.file_format#">
	<cfset file_name = "#createUUID()#.#cffile.serverfileext#">	
	
	<cffile action="rename" source="#upload_folder##cffile.serverfile#" destination="#upload_folder##file_name#" charset="#attributes.file_format#">
	
	<cfset file_size = cffile.filesize>
	<cfcatch type="Any">
		<script type="text/javascript">
			alert("<cf_get_lang_main no='43.Dosyanız Upload Edilemedi ! Dosyanızı Kontrol Ediniz '>!");
			history.back();
		</script>
		<cfabort>
	</cfcatch>  
</cftry>

<cftry>
	<cffile action="read" file="#upload_folder##file_name#" variable="dosya" charset="#attributes.file_format#">
	<cffile action="delete" file="#upload_folder##file_name#">
<cfcatch>
	<script type="text/javascript">
		alert("Dosya Okunamadı! Karakter Seti Yanlış Seçilmiş Olabilir.");
		history.back();
	</script>
	<cfabort>
</cfcatch>
</cftry>

<cfscript>
	ayirac = ';';
	CRLF = Chr(13) & Chr(10);// satır atlama karakteri
	dosya = Replace(dosya,'#ayirac##ayirac#','#ayirac# #ayirac#','all');
	dosya = Replace(dosya,'#ayirac##ayirac#','#ayirac# #ayirac#','all');
	dosya = ListToArray(dosya,CRLF);
	line_count = ArrayLen(dosya);
	counter = 0;
	liste = "";
</cfscript>

<cfloop from="2" to="#line_count#" index="i">
	<cftry>
		<cfscript>
			error_flag = 0;
			counter = counter + 1;
			satir=dosya[i];
			
			action_code = listgetat(satir,1,"#ayirac#");
			note_head = listgetat(satir,2,"#ayirac#");
			note_text = listgetat(satir,3,"#ayirac#");
			is_special = listgetat(satir,4,"#ayirac#");
			if(len(trim(is_special)) eq 0) is_special=0;
			if(listlen(satir,"#ayirac#"))
			{
				is_warning = listgetat(satir,5,"#ayirac#");
				if(len(trim(is_warning)) eq 0) is_warning=0;
			}else
				is_warning=0;
		</cfscript>
		<cfcatch type="Any">
			<cfoutput>#i#. satırda okuma sırasında hata oldu.</cfoutput>
		</cfcatch>
	</cftry>
	<cftry>
		<cfif attributes.note_type eq 1>
			<cfif attributes.action_section eq 'COMPANY_ID'>
				<cfquery name="GET_MEMBER" datasource="#DSN#">
					SELECT COMPANY_ID ACT_ID FROM COMPANY WHERE OZEL_KOD = '#action_code#'					
				</cfquery>
			<cfelseif attributes.action_section eq 'CONSUMER_ID'>
				<cfquery name="GET_MEMBER" datasource="#DSN#">
					SELECT CONSUMER_ID ACT_ID FROM CONSUMER WHERE OZEL_KOD = '#action_code#'					
				</cfquery>
			</cfif>
			<cfif isdefined("GET_MEMBER")>
				<cfset action_id=GET_MEMBER.ACT_ID>
			<cfelse>
				<cfset action_id="">
			</cfif>
		<cfelse>
			<cfset action_id=action_code>
		</cfif>
		
		<cfif len(action_id)>
			<cfquery name="ADD_NOTE" datasource="#dsn#">
				INSERT INTO 
						NOTES
						(
						ACTION_SECTION,
						<cfif attributes.action_type eq 0>ACTION_ID,<cfelse>ACTION_VALUE,</cfif>
						<!--- <cfif attributes.action_type eq 1 and len(attributes.action_id_2)>ACTION_ID,</cfif> --->
						NOTE_HEAD,
						NOTE_BODY,
						IS_SPECIAL,
						IS_WARNING,
						COMPANY_ID,
						RECORD_EMP,
						RECORD_DATE,
						RECORD_IP
						)
				VALUES
						(
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#UCASE(attributes.action_section)#">,
						<cfif attributes.action_type eq 0>#action_id#,<cfelse><cfqueryparam cfsqltype="cf_sql_varchar" value="#action_id#">,</cfif>
						<!--- <cfif attributes.action_type eq 1 and len(attributes.action_id_2)>#attributes.action_id_2#,</cfif> --->
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#note_head#">,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#note_text#">,
						<cfif is_special>1,<cfelse>0,</cfif>
						<cfif is_warning>1,<cfelse>0,</cfif>
						#session.ep.company_id#,
						#session.ep.userid#,
						#now()#,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#CGI.REMOTE_ADDR#">
						)
			</cfquery>
		<cfelse>
			<cfoutput>#i#. satırdaki verilere uygun kayıt bulunamadı!</cfoutput>
		</cfif>
 		<cfcatch type="Any">
			<cfoutput>#i#. satırda yazma sırasında hata oldu.</cfoutput>
		</cfcatch>
	</cftry>
</cfloop>
<script type="text/javascript">
	alert("<cf_get_lang no ='2510.Aktarım Tamamland'>");
	window.location.href='<cfoutput>#request.self#</cfoutput>?fuseaction=settings.import_note';
</script>
