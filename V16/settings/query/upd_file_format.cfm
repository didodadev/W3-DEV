<cfif not DirectoryExists("#upload_folder#settings")>
	<cfdirectory action="create" directory="#upload_folder#settings">
</cfif>
<cfset upload_folder = "#upload_folder#settings#dir_seperator#">
<cfif len(attributes.icon)>
    <cftry>
        <cffile action="UPLOAD" 
                nameconflict="OVERWRITE" 
                filefield="icon"
                destination="#upload_folder#" accept="image/*">			
    	<cfcatch type="any">
        <cfsavecontent  variable="message"><cf_get_lang_main no='43.Dosyanız Upload Edilemedi ! Lütfen Konrol Ediniz !'></cfsavecontent> 
        <script type="text/javascript">
            alert('aaaaa<cfoutput>#message# : #attributes.icon#</cfoutput>');
            history.back();
        </script>
        <cfabort>
    </cfcatch>
	</cftry>
    <cfset file_name = createUUID()>
    <cfset server_file= cffile.serverfileext>
    <cfset upload_file = cffile.serverfile>
    <cffile action='rename' source='#upload_folder##upload_file#' destination='#upload_folder##file_name#.#server_file#'>
    <cfif len(attributes.old_icon)>
    <cffile action="delete" file="#upload_folder##attributes.old_icon#"></cfif>
</cfif>
<cfquery name="UPDFORMAT" datasource="#dsn#">
	UPDATE 
		SETUP_FILE_FORMAT
	SET 
		FORMAT_SYMBOL = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.format_symbol#">,
		FORMAT_DESCRIPTION = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.format_description#">,
		<cfif isDefined("cffile.serverFile")>
            ICON_NAME= <cfqueryparam cfsqltype="cf_sql_varchar" value="#file_name#.#server_file#">,
            ICON_NAME_SERVER_ID= #fusebox.server_machine#,
        <cfelse>
            ICON_NAME= <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.icon_name#">,
            ICON_NAME_SERVER_ID= <cfif isdefined('attributes.server_id') and len(attributes.server_id)>#attributes.server_id#<cfelse>NULL</cfif>,     
		</cfif>
        FORMAT_SIZE=<cfif isdefined('attributes.format_size') and len(attributes.format_size)>#attributes.format_size#<cfelse>NULL</cfif>,
        UPDATE_IP = <cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.remote_addr#">,
        UPDATE_DATE = #now()#,
        UPDATE_EMP = #session.ep.userid#,
        CSS_FILE_NAME=<cfif isDefined("attributes.CSS_FILE")> <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.CSS_FILE#"><cfelse>NULL</cfif>
        
	WHERE 
		FORMAT_ID = #attributes.file_format_id#
</cfquery>
<script type="text/javascript">
	location.href= document.referrer;
</script>

