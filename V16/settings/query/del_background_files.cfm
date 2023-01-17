<cfif isdefined('attributes.selected_id') and len(attributes.selected_id)>
    <cfquery name="get_menu" datasource="#dsn#">
        SELECT LINK_IMAGE,LINK_IMAGE_SERVER_ID FROM MAIN_MENU_SELECTS WHERE SELECTED_ID = #attributes.selected_id# AND MENU_ID = #attributes.menu_id#
    </cfquery>
    
    <cfif len(get_menu.LINK_IMAGE)>
        <cf_del_server_file output_file="settings/#get_menu.LINK_IMAGE#" output_server="#get_menu.LINK_IMAGE_SERVER_ID#">
    </cfif>	
    <cfquery name="upd_menu_link_image" datasource="#dsn#">
        UPDATE
            MAIN_MENU_SELECTS
        SET
            LINK_IMAGE = NULL,
            LINK_IMAGE_SERVER_ID = NULL
        WHERE
            MENU_ID = #attributes.menu_id# AND
            SELECTED_ID = #attributes.selected_id#
    </cfquery>
<cfelseif isdefined('attributes.Design_Id') and len(attributes.Design_Id)>
	<cfquery name="get_old_file" datasource="#dsn3#">
		SELECT TEMPLATE_FILE,IMAGE_FILE,IMAGE_FILE_SERVER_ID FROM SETUP_PRINT_FILES WHERE FORM_ID = #attributes.design_id#
	</cfquery>
	<cfif len(get_old_file.IMAGE_FILE)>
		<cf_del_server_file output_file="settings/#get_old_file.IMAGE_FILE#" output_server="#get_old_file.IMAGE_FILE_SERVER_ID#">
	</cfif>
	<cfquery name="add_setup_print_design" datasource="#dsn3#">
		UPDATE
			SETUP_PRINT_FILES
		SET
			IMAGE_FILE = NULL,
			IMAGE_FILE_SERVER_ID = NULL,
			UPDATE_EMP = #session.ep.userid#,
			UPDATE_DATE = #now()#,
			UPDATE_IP = '#cgi.remote_addr#'
		WHERE
			FORM_ID = #attributes.design_id#
	</cfquery>
<cfelse>
    <cfquery name="get_menu" datasource="#dsn#">
        SELECT #attributes.type# DEL_FILE,#attributes.type_server_id# DEL_FILE_SERVER_ID FROM MAIN_MENU_SETTINGS WHERE MENU_ID = #attributes.menu_id#
    </cfquery>
    
    <cfif len(get_menu.DEL_FILE)>
        <cf_del_server_file output_file="settings/#get_menu.DEL_FILE#" output_server="#get_menu.DEL_FILE_SERVER_ID#">
    </cfif>	
    
    <cfquery name="upd_menu_background" datasource="#dsn#">
        UPDATE
            MAIN_MENU_SETTINGS
        SET
            #attributes.type# = NULL,
            #attributes.type_server_id# = NULL
        WHERE
            MENU_ID = #attributes.menu_id#
    </cfquery>
</cfif>
<script type="text/javascript">
	wrk_opener_reload();
	window.close();
</script>
