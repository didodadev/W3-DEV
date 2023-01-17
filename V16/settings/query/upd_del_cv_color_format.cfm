<!---img dosyalar \documents\hr\cv_image klasoru icine kayit edilir.--->
<cfif not DirectoryExists("#upload_folder#hr#dir_seperator#cv_image#dir_seperator#")>
	<cfdirectory action="create" directory="#upload_folder#hr#dir_seperator#cv_image#dir_seperator#">
</cfif>
<cfset upload_folder = "#upload_folder#hr#dir_seperator#cv_image#dir_seperator#">
<cfif len(attributes.icon)>
	<cftry>
		<cffile action="DELETE" file="#upload_folder##attributes.old_icon#">
		<cfcatch type="Any">
			<cfoutput>#attributes.old_icon# => Dosya bulunamadı  ! <br/></cfoutput>
		</cfcatch>
	</cftry>
	<cftry>
		<cffile action = "upload" 
			  filefield = "icon" 
			  destination = "#upload_folder#" 
			  nameconflict = "MakeUnique" 
			  mode="777">
		<cfset file_name = createUUID()>
		<cffile action="rename" source="#upload_folder##cffile.serverfile#" destination="#upload_folder##file_name#.#cffile.serverfileext#">
	<cfcatch type="any">
		<script type="text/javascript">
			alert("<cf_get_lang_main no='43.Dosyaniz Upload Edilemedi Lütfen Konrol Ediniz '> : " + #attributes.icon#);
			history.back();
		</script>
		<cfabort>
	</cfcatch>			
	</cftry>
</cfif>

<cfquery name="UPDFORMAT" datasource="#dsn#">
	UPDATE 
		SETUP_CV_STATUS
	SET 
		STATUS= <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.status#">,
		DETAIL = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.detail#">,
		<cfif isDefined("cffile.serverFile")>
		ICON_NAME= <cfqueryparam cfsqltype="cf_sql_varchar" value="#file_name#.#cffile.serverfileext#">,
		</cfif>
		UPDATE_IP = <cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.remote_addr#">,
		UPDATE_DATE = #now()#,
		UPDATE_EMP = #session.ep.userid#
	WHERE 
		STATUS_ID = #attributes.file_status_id#
</cfquery>
<script>
    location.href = document.referrer;
</script>

