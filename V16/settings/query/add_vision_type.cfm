<cfif len(attributes.vision_type_image)>
	<cfset upload_folder = "#upload_folder##dir_seperator#settings#dir_seperator#">
	<cftry>
		<cffile action="UPLOAD" 
				filefield="vision_type_image" 
				destination="#upload_folder#" 
				mode="777" 
				nameconflict="MAKEUNIQUE" accept="image/*">

		<cfset file_name = createUUID()>
		<cffile action="rename" source="#upload_folder##cffile.serverfile#" destination="#upload_folder##file_name#.#cffile.serverfileext#">
		<cfset attributes.file_name = '#file_name#.#cffile.serverfileext#'>
	
		<cfcatch type="Any">
			<script type="text/javascript">
				alert("<cf_get_lang_main no='43.Dosyaniz Upload Edilemedi Lütfen Konrol Ediniz '>!");
				history.back();
			</script>
			<cfabort>
		</cfcatch>  
	</cftry>
</cfif>

<cfquery name="ADD_VISION_TYPE" datasource="#DSN#">
	INSERT INTO 
    	SETUP_VISION_TYPE
    (
        VISION_TYPE_NAME,
        VISION_TYPE_DETAIL,
        VISION_TYPE_IMAGE,
        VISION_TYPE_IMAGE_SERVER_ID,
        RECORD_IP,
        RECORD_DATE,
        RECORD_EMP
    )
	VALUES
    (
        <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.vision_type_name#">,
        <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.vision_type_detail#">,
        <cfif len(attributes.vision_type_image)><cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.file_name#"><cfelse>NULL</cfif>,
        <cfif len(attributes.vision_type_image)>#fusebox.server_machine#<cfelse>NULL</cfif>,
        <cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.remote_addr#">,
        #now()#,
        #session.ep.userid#
    )
</cfquery>
<cflocation url="#request.self#?fuseaction=settings.form_add_vision_type" addtoken="no">
