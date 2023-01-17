<cfset upload_folder = "#upload_folder#sales#dir_seperator#">
<cfif not directoryexists("#upload_folder#")>
	<cfdirectory action="create" directory="#upload_folder#">
</cfif>
<CFTRY>
	<CFFILE ACTION="UPLOAD" 
			FILEFIELD="ICON" 
			DESTINATION="#UPLOAD_FOLDER#" 
			MODE="777"
			NAMECONFLICT="MAKEUNIQUE" accept="image/jpeg, image/png, image/bmp, image/gif, image/pjpeg, image/x-png, image/*">
	<CFCATCH TYPE="ANY">
		<script type="text/javascript">
			alert("<cf_get_lang_main no='43.Dosyaniz Upload Edilemedi Lütfen Konrol Ediniz '>!");
			history.back();
		</script>
	</CFCATCH>  
</CFTRY>
<cfset file_name = createUUID()>
	<cffile action='rename' source='#upload_folder##cffile.serverfile#' destination='#upload_folder##file_name#.#cffile.serverfileext#'>
<cfset form.photo = '#file_name#.#cffile.serverfileext#'>
<cfquery name="INSICON" datasource="#dsn3#">
	INSERT 
	INTO 
		SETUP_PROMO_ICON
		(
		ICON,
		ICON_SERVER_ID,
		IS_VISION,
		RECORD_DATE,
		RECORD_EMP,
		RECORD_IP
		) 
	VALUES 
		(
		<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.photo#">,
		#fusebox.server_machine#,
		<cfif isdefined("attributes.is_vision")>1<cfelse>0</cfif>,
		#NOW()#,
		#SESSION.EP.USERID#,
		'#CGI.REMOTE_ADDR#'
		)
</cfquery>
<cflocation url="#request.self#?fuseaction=settings.form_add_icon" addtoken="no">
