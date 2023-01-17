<!---img dosyalar \documents\hr\cv_image klasoru icine kayit edilir.--->
<cfif not DirectoryExists("#upload_folder#hr#dir_seperator#cv_image#dir_seperator#")>
	<cfdirectory action="create" directory="#upload_folder#hr#dir_seperator#cv_image#dir_seperator#">
</cfif>
<cfset upload_folder = "#upload_folder#hr#dir_seperator#cv_image#dir_seperator#">
<cfif len(attributes.icon)>
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
	</cfcatch>			
	</cftry>
</cfif>
<cfquery name="INSFORMAT" datasource="#DSN#">
    INSERT INTO 
        SETUP_CV_STATUS
    (   
        STATUS,
        DETAIL,
        ICON_NAME,
        RECORD_IP,
        RECORD_DATE,
        RECORD_EMP
    )
    VALUES 
    (
        <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.status#">,
        <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.detail#">,
        <cfif isDefined("cffile.serverFile")>
        <cfqueryparam cfsqltype="cf_sql_varchar" value="#file_name#.#cffile.serverfileext#">,
        <cfelse>
        NULL,
        </cfif>
        '#cgi.remote_addr#',
        #now()#,
        #session.ep.userid#
    )
</cfquery>
<script>
    location.href = document.referrer;
</script>
