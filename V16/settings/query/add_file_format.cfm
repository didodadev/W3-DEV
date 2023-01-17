<cfif not DirectoryExists("#upload_folder#settings")>
	<cfdirectory action="create" directory="#upload_folder#settings">
</cfif>
<cfset upload_folder = "#upload_folder#">
<cfif len(attributes.icon)>
    <cftry>
        <cffile 
        action="UPLOAD" 
        nameconflict="OVERWRITE" 
        filefield="icon" 
        destination="#upload_folder#settings" accept="image/*">			
        <cfcatch type="any">
            <script type="text/javascript">
                alert("<cf_get_lang_main no='43.Dosyaniz Upload Edilemedi Lütfen Konrol Ediniz '> : " + #attributes.icon#);
                history.back();
            </script>
            <cfabort>
        </cfcatch>			
    </cftry>
        <cfset file_name = createUUID()>
        <cfset filesize = cffile.filesize />
        <cfset server_file= cffile.serverfileext>
        <cffile action='rename' source='#upload_folder#settings#dir_seperator##cffile.serverFile#' destination='#upload_folder#settings#dir_seperator##file_name#.#server_file#'>
</cfif>
<cfquery name="get_format_id" datasource="#DSN#">
    SELECT
    	MAX(FORMAT_ID) FORMAT_ID
    FROM
    SETUP_FILE_FORMAT  
</cfquery>
<cfscript>
    if (get_format_id.format_id eq '')
    	max_format_id = 0;
	else max_format_id = get_format_id.format_id + 1;	
</cfscript>	
<cfquery name="INSFORMAT" datasource="#DSN#">
	INSERT INTO 
		SETUP_FILE_FORMAT
    (   
        FORMAT_ID,  
        FORMAT_SYMBOL,
        FORMAT_DESCRIPTION,
        ICON_NAME,
        ICON_NAME_SERVER_ID,
        FORMAT_SIZE,
        RECORD_IP,
        RECORD_DATE,
        RECORD_EMP,
        CSS_FILE_NAME
     )
    VALUES 
    (
        #max_format_id#,
        <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.format_symbol#">,
        <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.format_description#">,
        <cfqueryparam cfsqltype="cf_sql_varchar" value="#file_name#.#server_file#">,
        #fusebox.server_machine#,
        <cfif isdefined('attributes.format_size') and len(attributes.format_size)>#attributes.format_size#<cfelse>NULL</cfif>,
        <cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.remote_addr#">,
        #now()#,
        #session.ep.userid#,
        <cfif isDefined('attributes.CSS_FILE') and len(attributes.CSS_FILE) ><cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.css_file#"><cfelse>NULL</cfif>
    )
</cfquery>
<script type="text/javascript">
	window.location.href='<cfoutput>#request.self#</cfoutput>?fuseaction=settings.form_add_file_format';
</script>
