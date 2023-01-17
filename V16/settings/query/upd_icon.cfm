<cfset upload_folder = "#upload_folder#sales#dir_seperator#">
<cfif len(attributes.icon)>
	<cfset change_image = 1>
<cfelse>
	<cfset change_image = 0>
</cfif>
<cfquery name="DOSYA" datasource="#dsn3#">
	SELECT 
		ICON ,
		ICON_SERVER_ID
	FROM 
		SETUP_PROMO_ICON 
	WHERE 
		ICON_ID=#ICON_ID#
</cfquery>

<cfif change_image eq 1>
    <cf_del_server_file output_file="sales/#DOSYA.ICON#" output_server="#DOSYA.ICON_SERVER_ID#">
    <CFTRY>
        <CFFILE ACTION="UPLOAD" FILEFIELD="ICON" DESTINATION="#UPLOAD_FOLDER#" MODE="777" NAMECONFLICT="OVERWRITE" accept="image/*">
        <CFCATCH TYPE="ANY">
            <script type="text/javascript">
                alert("<cf_get_lang_main no='43.Dosyanız Upload Edilemedi ! Dosyanızı Kontrol Ediniz '>!");
                history.back();
            </script>
        </CFCATCH>  
    </CFTRY>
    
    <cfset file_name = createUUID()>
    <cffile action='rename' source='#upload_folder##cffile.serverfile#' destination='#upload_folder##file_name#.#cffile.serverfileext#'>
    <cfset form.photo = '#file_name#.#cffile.serverfileext#'>
<cfelse>
	<cfset form.photo = '#DOSYA.ICON#'>
</cfif>

<cfquery name="UPDICON" datasource="#dsn3#">
	UPDATE 
		SETUP_PROMO_ICON
	SET 
		ICON = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.photo#">,
		ICON_SERVER_ID=#fusebox.server_machine#,
		IS_VISION= <cfif isdefined("attributes.is_vision")>1<cfelse>0</cfif>,
		update_DATE = #now()#,
		update_EMP = #session.ep.userid#,
		update_IP = '#cgi.remote_addr#'
	WHERE 
		ICON_ID=#ICON_ID#
</cfquery>
<cflocation url="#request.self#?fuseaction=settings.form_add_icon" addtoken="no">
