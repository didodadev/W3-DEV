<!--- bu sayfada unicodelar icin sql_unicode fonksiyonu kullanildi --->
<cfset upload_folder = "#upload_folder#settings#dir_seperator#">
<cfloop from="1" to="#attributes.record_num_sabit#" index="i">
	<cfif evaluate("attributes.row_kontrol_sabit_#i#") neq 0 and len(evaluate("attributes.menu_row_file_#i#"))>
		<cfif len(evaluate("attributes.old_menu_row_file_#i#"))>
			<cf_del_server_file output_file="settings/#evaluate("attributes.old_menu_row_file_#i#")#" output_server="#evaluate("attributes.old_menu_row_file_server_id_#i#")#">
		</cfif>		
		<cftry>
			<cffile action="upload" filefield="menu_row_file_#i#" destination="#upload_folder#" nameconflict="MakeUnique" mode="777">
			<cfcatch type="Any">
				<cfset error=1>
				<script type="text/javascript">
					alert("<cf_get_lang_main no='43.Dosyanız Upload Edilemedi ! Dosyanızı Kontrol Ediniz '>!");
					history.back();
				</script>
				<cfabort>
			</cfcatch>
		</cftry>
		<cfset file_name11 = createUUID()>
		<cffile action="rename" source="#upload_folder##cffile.serverfile#" destination="#upload_folder##file_name11#.#cffile.serverfileext#">
		<cfset 'file_menu_row_#i#' = '#file_name11#.#cffile.serverfileext#'>
	</cfif>
</cfloop>
<cftransaction>
	<cfloop from="1" to="#attributes.record_num_sabit#" index="i">
		<cfif evaluate("attributes.row_kontrol_sabit_#i#") neq 0>
			<cfquery name="UPD_MAIN_MENU_SELECTS" datasource="#DSN#">
				UPDATE 
					MAIN_MENU_LAYER_SELECTS
				SET		
					<cfif isdefined("file_menu_row_#i#")>LINK_IMAGE = '#wrk_eval("file_menu_row_#i#")#',</cfif>
					<cfif isdefined("file_menu_row_#i#")>LINK_IMAGE_SERVER_ID = #fusebox.server_machine#,</cfif>			
					IS_SESSION = <cfif isdefined("attributes.is_session_sabit_#i#")>1,<cfelse>0,</cfif>
					ORDER_NO = <cfif isnumeric(#evaluate("attributes.order_no_sabit_#i#")#)>#evaluate("attributes.order_no_sabit_#i#")#,<cfelse>NULL,</cfif>
					SELECTED_LINK = '#wrk_eval("attributes.selected_link_sabit_#i#")#',
					LINK_TYPE = #evaluate("attributes.link_type_sabit_#i#")#,
					LINK_NAME = <cfif evaluate("attributes.link_name_type_sabit_#i#") eq 0>#sql_unicode()#'#wrk_eval("attributes.link_name2_sabit_#i#")#'<cfelse>#sql_unicode()#'#wrk_eval("attributes.link_name_id_sabit_#i#")#'</cfif>,
					LINK_NAME_TYPE = <cfif len(evaluate("attributes.link_name_type_sabit_#i#"))>#evaluate("attributes.link_name_type_sabit_#i#")#<cfelse>0</cfif>,
					LOGIN_CONTROL = #evaluate("attributes.login_control_#i#")#
				WHERE
					LAYER_ROW_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#evaluate("attributes.layer_row_id_sabit_#i#")#">
			</cfquery>
		<cfelse>
			<cfquery name="DEL_" datasource="#DSN#">
				DELETE FROM MAIN_MENU_LAYER_SELECTS WHERE LAYER_ROW_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#evaluate("attributes.layer_row_id_sabit_#i#")#">
			</cfquery>
		</cfif>
	</cfloop>
	<cfloop from="1" to="#attributes.record_num#" index="i">
		<cfif evaluate("attributes.row_kontrol#i#") neq 0>
            <cfquery name="ADD_PURCHASE_JOIN_WITHOUT" datasource="#DSN#">
                INSERT INTO 
                	MAIN_MENU_LAYER_SELECTS 
                    (
                        IS_SESSION,
                        ORDER_NO,
                        SELECTED_LINK,
                        LINK_TYPE,
                        SELECTED_ID,
                        MAIN_LAYER_ROW_ID,
                        LINK_NAME,
                        LINK_NAME_TYPE,
                        MENU_ID,
                        LOGIN_CONTROL
                    )
                	VALUES
                    (
						<cfif isdefined("attributes.is_session_#i#")>1,<CFELSE>0,</cfif>
                        <cfif isnumeric(#evaluate("attributes.order_no#i#")#)>#evaluate("attributes.order_no#i#")#,<cfelse>NULL,</cfif>
                        '#wrk_eval("attributes.selected_link#i#")#',
                        #evaluate("attributes.link_type#i#")#,
                        <cfif isdefined("attributes.selected_id") and len(attributes.selected_id)>#attributes.selected_id#,<cfelse>NULL,</cfif>
                        <cfif isdefined("attributes.main_layer_row_id") and len(attributes.main_layer_row_id)>#attributes.main_layer_row_id#,<cfelse>NULL,</cfif>
                        <cfif len(evaluate("attributes.link_name_type#i#")) and evaluate("attributes.link_name_type#i#") eq 0>#sql_unicode()#'#wrk_eval("attributes.link_name2#i#")#'<cfelse>#sql_unicode()#'#wrk_eval("attributes.link_name_id#i#")#'</cfif>,
                        <cfif len(evaluate("attributes.link_name_type#i#"))>#evaluate("attributes.link_name_type#i#")#<cfelse>0</cfif>,
                        #attributes.menu_id#,
                        #evaluate("attributes.login_control#i#")#
                    )
            </cfquery>
        </cfif>
	</cfloop>
</cftransaction>
<cfset url_str = ''>
<cfif isdefined('attributes.menu_id') and len(attributes.menu_id)>
	<cfset url_str = '#url_str#&menu_id=#attributes.menu_id#'>
</cfif>
<cfif isdefined('attributes.selected_id') and len(attributes.selected_id)>
	<cfset url_str = '#url_str#&selected_id=#attributes.selected_id#'>
</cfif>
<cfif isdefined('attributes.main_layer_row_id') and len(attributes.main_layer_row_id)>
	<cfset url_str = '#url_str#&main_layer_row_id=#attributes.main_layer_row_id#'>
</cfif>

<cflocation url="#request.self#?fuseaction=settings.popup_form_upd_main_menu_layer&#url_str#" addtoken="no">

