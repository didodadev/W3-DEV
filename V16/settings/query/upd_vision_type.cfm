<cfif len(attributes.vision_type_image)>
	<cfset upload_folder = "#upload_folder##dir_seperator#settings#dir_seperator#">
	<CFTRY>
		<cffile action="UPLOAD" 
				filefield="vision_type_image" 
				destination="#upload_folder#" 
				mode="777" 
				nameconflict="MAKEUNIQUE" accept="image/*">

		<cfset file_name = createUUID()>
		<cffile action="rename" source="#upload_folder##cffile.serverfile#" destination="#upload_folder##file_name#.#cffile.serverfileext#">
		<cfset attributes.file_name = '#file_name#.#cffile.serverfileext#'>
	
		<CFCATCH type="Any">
			<script type="text/javascript">
				alert("<cf_get_lang_main no='43.Dosyaniz Upload Edilemedi Lütfen Konrol Ediniz '>!");
				history.back();
			</script>
			<cfabort>
		</CFCATCH>  
	</CFTRY>
	
	<cfif len(attributes.old_vision_type_image)>
		<cf_del_server_file output_file="finance/#attributes.old_vision_type_image#" output_server="#attributes.old_vision_type_image_server_id#">
	</cfif>
</cfif>
<cfquery name="get_lang" datasource="#dsn#">
	SELECT
		ITEM,
		LANGUAGE
	FROM 
		SETUP_LANGUAGE_INFO
	WHERE
		UNIQUE_COLUMN_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#vision_type_id#"> AND
		COLUMN_NAME = <cfqueryparam cfsqltype="cf_sql_varchar" value="VISION_TYPE_NAME"> AND
		TABLE_NAME = <cfqueryparam cfsqltype="cf_sql_varchar" value="SETUP_VISION_TYPE"> AND
		LANGUAGE = <cfqueryparam cfsqltype="cf_sql_varchar" value="#session.ep.language#">
</cfquery>
<cfif get_lang.recordcount>
	<cfquery name="upd_" datasource="#dsn#">
    	UPDATE 
			SETUP_LANGUAGE_INFO 
		SET 
			ITEM = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.vision_type_name#">
		WHERE 
			UNIQUE_COLUMN_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#vision_type_id#"> AND
			COLUMN_NAME = <cfqueryparam cfsqltype="cf_sql_varchar" value="VISION_TYPE_NAME"> AND
			TABLE_NAME = <cfqueryparam cfsqltype="cf_sql_varchar" value="SETUP_VISION_TYPE"> AND
			LANGUAGE = <cfqueryparam cfsqltype="cf_sql_varchar" value="#session.ep.language#">
    </cfquery>
</cfif>
<cfquery name="get_lang_det" datasource="#dsn#">
	SELECT
		ITEM,
		LANGUAGE
	FROM 
		SETUP_LANGUAGE_INFO
	WHERE
		UNIQUE_COLUMN_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#vision_type_id#"> AND
		COLUMN_NAME = <cfqueryparam cfsqltype="cf_sql_varchar" value="VISION_TYPE_DETAIL"> AND
		TABLE_NAME = <cfqueryparam cfsqltype="cf_sql_varchar" value="SETUP_VISION_TYPE"> AND
		LANGUAGE = <cfqueryparam cfsqltype="cf_sql_varchar" value="#session.ep.language#">
</cfquery>
<cfif get_lang.recordcount>
	<cfquery name="upd_det" datasource="#dsn#">
    	UPDATE 
			SETUP_LANGUAGE_INFO 
		SET 
			ITEM = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.vision_type_detail#">
		WHERE 
			UNIQUE_COLUMN_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#vision_type_id#"> AND
			COLUMN_NAME = <cfqueryparam cfsqltype="cf_sql_varchar" value="VISION_TYPE_DETAIL"> AND
			TABLE_NAME = <cfqueryparam cfsqltype="cf_sql_varchar" value="SETUP_VISION_TYPE"> AND
			LANGUAGE = <cfqueryparam cfsqltype="cf_sql_varchar" value="#session.ep.language#">
    </cfquery>
</cfif>
<cfquery name="UPD_VISION_TYPE" datasource="#DSN#">
	UPDATE 
   		SETUP_VISION_TYPE
	SET
		VISION_TYPE_NAME = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.vision_type_name#">,
		VISION_TYPE_DETAIL = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.vision_type_detail#">,
		VISION_TYPE_IMAGE = <cfif len(attributes.vision_type_image)><cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.file_name#">,<cfelse><cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.old_vision_type_image#">,</cfif>
		VISION_TYPE_IMAGE_SERVER_ID = <cfif len(attributes.vision_type_image)>#fusebox.server_machine#,<cfelseif len(attributes.old_vision_type_image_server_id)>#attributes.old_vision_type_image_server_id#,<cfelse>NULL,</cfif>
		UPDATE_IP = <cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.remote_addr#">,
		UPDATE_DATE = #now()#,
		UPDATE_EMP = #session.ep.userid#	 
	WHERE 
		VISION_TYPE_ID=#attributes.vision_type_id#
</cfquery>
<cflocation url="#request.self#?fuseaction=settings.form_upd_vision_type&vision_type_id=#attributes.vision_type_id#" addtoken="no">
