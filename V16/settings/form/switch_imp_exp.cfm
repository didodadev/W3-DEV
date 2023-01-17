<cfform name="switch_import" method="post" action="#request.self#?fuseaction=test.switch&import=1">
	<table width="98%" height="35" border="0" align="center" cellpadding="0" cellspacing="0">
		<tr>
			<td class="headbold">Switch Aktarım</td>
		</tr>
	</table>
	<br /><br />
	<table>
		<tr align="left">
			<td align="left" valign="top"></td>
		</tr>
		<tr>
			<td class="txtboldblue"><cf_get_lang_main no='56.Belge'>*</td>
			<td><input type="file" name="uploaded_file" id="uploaded_file" style="width:200;"></td>
                <input type="hidden" name="import" id="import" value="0" />
                <input type="hidden" name="export" id="export" value="0" />
		</tr>
		<br /><br />
		<tr>
			<td height="35"><cf_workcube_buttons is_upd='0' insert_info="Import Et"> </td>
		</tr>
	</table>
</cfform>

<!--- <cfif isdefined("attributes.export") and attributes.export eq 1><!--- CSV Dosyaya Yazıyor --->
	<cfquery name="GET_FUSEACTION" datasource="#DSN#">
		SELECT * FROM WRK_OBJECTS
	</cfquery>
	<!--- Wrk Fuseaction Export Kayıtları wrk_switchs.csv dosyası içine yazar --->
	<cffile action="write" charset="iso-8859-9" file="#upload_folder#switch#dir_seperator#wrk_switchs.csv" output="WRK_OBJECTS_ID;BASE;MODUL;MODUL_SHORT_NAME;FUSEACTION;HEAD;FRIENDLY_URL;FOLDER;FILE_NAME;FILE_TYPE;STAGE;TYPE;WINDOW;SECURITY;STATUS;VERSION;AUTHOR;DETAIL;RECORD_IP;RECORD_EMP;RECORD_DATE;UPDATE_IP;UPDATE_EMP;UPDATE_DATE" addnewline="yes">
	<cfoutput>
		<cfloop query="GET_FUSEACTION">
			<cffile action="append" charset="iso-8859-9" file="#upload_folder#switch#dir_seperator#wrk_switchs.csv" output="#WRK_OBJECTS_ID#;#BASE#;#MODUL#;#MODUL_SHORT_NAME#;#FUSEACTION#;#HEAD#;#FRIENDLY_URL#;#FOLDER#;#FILE_NAME#;#FILE_TYPE#;#STAGE#;#TYPE#;#WINDOW#;#SECURITY#;#STATUS#;#VERSION#;#AUTHOR#;#DETAIL#;#RECORD_IP#;#RECORD_EMP#;#RECORD_DATE#;#UPDATE_IP#;#UPDATE_EMP#;#UPDATE_DATE#" addnewline="yes">
		</cfloop>
	</cfoutput>
	<table>
		<tr>
			<td><a href="http://ep.workcube/documents/switch/wrk_switchs.csv">wrk_switchs.csv Dosyası Oluşturuldu</a></td>
		</tr>
	</table>
</cfif> --->

<cfif isdefined("attributes.import") and attributes.import eq 1>
<cfoutput>#attributes.uploaded_file#</cfoutput>
<cfset upload_folder_ = "#upload_folder#temp#dir_seperator#">
<cftry>
 	<cffile action = "upload" fileField = "uploaded_file" destination = "#upload_folder_#" nameConflict = "MakeUnique" mode="777" charset="#attributes.file_format#">
	<cfset file_name = "#createUUID()#.#cffile.serverfileext#">	
	<cffile action="rename" source="#upload_folder_##cffile.serverfile#" destination="#upload_folder_##file_name#" charset="#attributes.file_format#">	
	<cfset file_size = cffile.filesize>
	<cfcatch type="Any">
		<script type="text/javascript">
			alert("Dosyaniz Upload Edilemedi Lütfen Konrol Ediniz!");
			history.back();
		</script>
		<cfabort>
	</cfcatch>  
</cftry>

<cftry>
	<cffile action="read" file="#upload_folder_##file_name#" variable="dosya" charset="#attributes.file_format#">
	<cffile action="delete" file="#upload_folder_##file_name#">
<cfcatch>
	<script type="text/javascript">
		alert("Dosya Okunamadı! Karakter Seti Yanlış Seçilmiş Olabilir.");
		history.back();
	</script>
	<cfabort>
</cfcatch>
</cftry>
	
<cfloop index="index" list="#dosya#" delimiters="#chr(10)##chr(13)#"> 
	<cftry>
    	<cfquery name="importcsv" datasource="calisma"> 
		INSERT INTO WBO_DENEME 
		(
			BASE,
			MODUL,
			MODUL_SHORT_NAME,
			FUSEACTION,
			HEAD,
			FRIENDLY_URL,
			FOLDER,
			FILE_NAME,
			FILE_TYPE,
			STAGE,
			TYPE,
			WINDOW,
			SECURITY,
			STATUS,
			VERSION,
			AUTHOR,
			DETAIL,
			RECORD_IP,
			RECORD_EMP,
			RECORD_DATE,
			UPDATE_IP,
			UPDATE_EMP,
			UPDATE_DATE,
		) 
         VALUES 
		(
			<cfqueryparam cfsqltype="cf_sql_varchar" value="#listgetAt('#index#',1, ';')#">, 
			<cfqueryparam cfsqltype="cf_sql_varchar" value="#listgetAt('#index#',2, ';')#">, 
			<cfqueryparam cfsqltype="cf_sql_varchar" value="#listgetAt('#index#',3, ';')#">, 
			<cfqueryparam cfsqltype="cf_sql_varchar" value="#listgetAt('#index#',4, ';')#">, 
			<cfqueryparam cfsqltype="cf_sql_varchar" value="#listgetAt('#index#',5, ';')#">,
			<cfqueryparam cfsqltype="cf_sql_varchar" value="#listgetAt('#index#',6, ';')#">, 
			<cfqueryparam cfsqltype="cf_sql_varchar" value="#listgetAt('#index#',7, ';')#">, 
			<cfqueryparam cfsqltype="cf_sql_varchar" value="#listgetAt('#index#',8, ';')#">, 
			<cfqueryparam cfsqltype="cf_sql_varchar" value="#listgetAt('#index#',9, ';')#">, 
			<cfqueryparam cfsqltype="cf_sql_varchar" value="#listgetAt('#index#',10, ';')#">, 
			<cfqueryparam cfsqltype="cf_sql_varchar" value="#listgetAt('#index#',11, ';')#">, 
			<cfqueryparam cfsqltype="cf_sql_varchar" value="#listgetAt('#index#',12, ';')#">, 
			<cfqueryparam cfsqltype="cf_sql_varchar" value="#listgetAt('#index#',13, ';')#">, 
			<cfqueryparam cfsqltype="cf_sql_varchar" value="#listgetAt('#index#',14, ';')#">, 
			<cfqueryparam cfsqltype="cf_sql_varchar" value="#listgetAt('#index#',15, ';')#">, 
			<cfqueryparam cfsqltype="cf_sql_varchar" value="#listgetAt('#index#',16, ';')#">, 
			<cfqueryparam cfsqltype="cf_sql_varchar" value="#listgetAt('#index#',17, ';')#">, 
			<cfqueryparam cfsqltype="cf_sql_varchar" value="#listgetAt('#index#',18, ';')#">, 
			<cfqueryparam cfsqltype="cf_sql_varchar" value="#listgetAt('#index#',19, ';')#">, 
			<cfqueryparam cfsqltype="cf_sql_varchar" value="#listgetAt('#index#',20, ';')#">, 
			<cfqueryparam cfsqltype="cf_sql_varchar" value="#listgetAt('#index#',21, ';')#">, 
		) 
   		</cfquery>
   <cfcatch>
   	
   </cfcatch> 
   </cftry>
</cfloop> 

<cfoutput>
<table>
	<tr>
		<td>Import İşlemi Gerçekleşti...</a></td>
	</tr>
</table>
</cfoutput>

</cfif>
