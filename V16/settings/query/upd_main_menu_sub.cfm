<cftransaction>
	<cfloop from="1" to="#attributes.record_num_sabit#" index="i">
		<cfif evaluate("attributes.row_kontrol_sabit_#i#") neq 0>
			<cfquery name="UPD_MAIN_MENU_SELECTS" datasource="#DSN#">
				UPDATE 
					MAIN_MENU_SUB_SELECTS
				SET
					IS_SESSION = <cfif isdefined("attributes.is_session_sabit_#i#")>1,<CFELSE>0,</cfif>
					ORDER_NO = <cfif isnumeric(#evaluate("attributes.order_no_sabit_#i#")#)>#evaluate("attributes.order_no_sabit_#i#")#,<cfelse>NULL,</cfif>
					SELECTED_LINK = '#wrk_eval("attributes.selected_link_sabit_#i#")#',
					LINK_TYPE = #evaluate("attributes.link_type_sabit_#i#")#,
					LINK_NAME = <cfif evaluate("attributes.link_name_type_sabit_#i#") eq 0>#sql_unicode()#'#wrk_eval("attributes.link_name2_sabit_#i#")#'<cfelse>#sql_unicode()#'#wrk_eval("attributes.link_name_id_sabit_#i#")#'</cfif>,
					MENU_ID = #attributes.menu_id#,
					LINK_NAME_TYPE = <cfif len(evaluate("attributes.link_name_type_sabit_#i#"))>#evaluate("attributes.link_name_type_sabit_#i#")#<cfelse>0</cfif>,
					IS_VIEW = #evaluate("attributes.is_goster_sabit_#i#")#
				WHERE
					SUB_ROW_ID = #evaluate("attributes.sub_row_id_sabit_#i#")#
			</cfquery>
		<cfelse>
			<cfquery name="DEL_" datasource="#DSN#">
				DELETE FROM MAIN_MENU_SUB_SELECTS WHERE SUB_ROW_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#evaluate("attributes.sub_row_id_sabit_#i#")#">
			</cfquery>
		</cfif>
	</cfloop>	
	
	<cfloop from="1" to="#attributes.record_num#" index="i">
		<cfif evaluate("attributes.row_kontrol#i#") neq 0>
            <cfquery name="ADD_PURCHASE_JOIN_WITHOUT" datasource="#DSN#">
                INSERT INTO MAIN_MENU_SUB_SELECTS 
                    (
                        IS_SESSION,
                        ORDER_NO,
                        SELECTED_LINK,
                        LINK_TYPE,
                        SELECTED_ID,
                        LAYER_ROW_ID,
                        LINK_NAME,
                        MENU_ID,
                        LINK_NAME_TYPE,
                        IS_VIEW
                    )
					VALUES
                    (
						<cfif isdefined("attributes.is_session_#i#")>1,<CFELSE>0,</cfif>
                        <cfif isnumeric(#evaluate("attributes.order_no#i#")#)>#evaluate("attributes.order_no#i#")#,<cfelse>NULL,</cfif>
                        '#wrk_eval("attributes.selected_link#i#")#',
                        #evaluate("attributes.link_type#i#")#,
                        <cfif isdefined("attributes.selected_id")>#attributes.selected_id#,<cfelse>NULL,</cfif>
                        <cfif isdefined("attributes.layer_row_id")>#attributes.layer_row_id#,<cfelse>NULL,</cfif>
                        <cfif len(evaluate("attributes.link_name_type#i#")) and evaluate("attributes.link_name_type#i#") eq 0>#sql_unicode()#'#wrk_eval("attributes.link_name2#i#")#'<cfelse>#sql_unicode()#'#wrk_eval("attributes.link_name_id#i#")#'</cfif>,
                        #attributes.menu_id#,
                        <cfif len(evaluate("attributes.link_name_type#i#"))>#evaluate("attributes.link_name_type#i#")#<cfelse>0</cfif>,
                        #evaluate("attributes.is_goster#i#")#
                    )
            </cfquery>
        </cfif>
	</cfloop>
</cftransaction>
<cfif isDefined('attributes.selected_id')>
	<cflocation url="#request.self#?fuseaction=settings.popup_form_upd_main_menu_sub&selected_id=#attributes.selected_id#&menu_id=#attributes.menu_id#" addtoken="no">
<cfelse>
	<cflocation url="#request.self#?fuseaction=settings.popup_form_upd_main_menu_sub&layer_row_id=#attributes.layer_row_id#&menu_id=#attributes.menu_id#" addtoken="no">
</cfif>
