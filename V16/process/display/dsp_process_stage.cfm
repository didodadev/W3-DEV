<cf_xml_page_edit fuseact="process.upd_process">
<cfsetting showdebugoutput="no">
<cfset d_hata = 0>
<cfset a_hata = 0>
<cfquery name="GET_PROCESS_STAGE" datasource="#dsn#">
	SELECT PROCESS_TYPE_ROWS.PROCESS_ID, #dsn#.Get_Dynamic_Language(PROCESS_TYPE_ROWS.PROCESS_ROW_ID,'#session.ep.language#','PROCESS_TYPE_ROWS','STAGE',NULL,NULL,STAGE) AS STAGE, IS_SMS, IS_EMAIL, IS_ONLINE, PROCESS_ROW_ID, LINE_NUMBER,STAGE_CODE, PROCESS_NAME FROM PROCESS_TYPE_ROWS LEFT JOIN PROCESS_TYPE ON PROCESS_TYPE_ROWS.PROCESS_ID = PROCESS_TYPE.PROCESS_ID WHERE PROCESS_TYPE_ROWS.PROCESS_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.process_id#"> ORDER BY LINE_NUMBER
</cfquery>
<cfquery name="GET_KONTROL" datasource="#dsn#">
	SELECT IS_MAIN_FILE, IS_MAIN_ACTION_FILE, MAIN_ACTION_FILE, MAIN_ACTION_FILE_SERVER_ID, MAIN_FILE, MAIN_FILE_SERVER_ID FROM PROCESS_TYPE WHERE PROCESS_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.process_id#">
</cfquery>
<div id="process_rows"></div>

    <cf_grid_list>
        <thead>
            <tr>
                <th width="20"><a style="cursor:pointer" href="<cfoutput>#request.self#?fuseaction=process.form_add_process_rows&process_id=#attributes.process_id#&process_name=#get_process_stage.process_name#</cfoutput>"><i class="fa fa-plus"title="<cf_get_lang dictionary_id ='36222.Aşama Ekle'>"></i></a></th>
                <th  width="10">
                    <ul class="ui-icon-list">
                        <li>
                            <a href="javascript://"><i class="fa fa-caret-down"></i></a>
                        </li>
                        <li>
                            <a href="javascript://"><i class="fa fa-caret-up"></i> </a>
                        </li>
                    </ul>
                </th>
                <th width="30"><cf_get_lang dictionary_id='57487.No'></th>
				<cfif xml_show_stage_code eq 1>
					<th><cf_get_lang dictionary_id='57482.Aşama'> <cf_get_lang dictionary_id='32646.Kodu'></th>
				</cfif>
                <th width="350"><cf_get_lang dictionary_id='57482.Aşama'></th>
               
                <th width="20">
                    <ul class="ui-icon-list">
                        <li><a href="javascript://"><i class="fa fa-mobile-phone"title="Sms"></i></a></li>
                        <li><a href="javascript://"><i class="fa fa-envelope-o" title="Mail"></i></a></li>
                        <li><a href="javascript://"><i class="fa fa-user-o" title="<cf_get_lang dictionary_id ='57427.Online mesaj'>"></i></a></li>
                    </ul>
                </th>
               
            </tr>
        </thead>
        <tbody>
            <cfoutput query="get_process_stage">
                <tr>
                    <td>
                        <cfsavecontent variable="delete_stage"><cf_get_lang dictionary_id ='36257.Kayıtlı Aşamayı Siliyorsunuz Emin misiniz'>!</cfsavecontent>
                        <cfif session.ep.admin eq 1>
                            <a href="javascript://" onClick="if (confirm('#delete_stage#')) windowopen('#request.self#?fuseaction=process.emptypopup_del_process_type_rows&process_row_id=#process_row_id#&line_number=#line_number#&process_id=#process_id#','small');"><i class="fa fa-minus" title="<cf_get_lang dictionary_id ='57463.Sil'>"></i></a>
                        </cfif>
                    </td>
                    <td> 
                        <ul class="ui-icon-list">
                            <cfif currentrow neq get_process_stage.recordcount>
                            <li>
                                <a href="javascript://" onclick="loadPage(#line_number#,#process_row_id#,#attributes.process_id#,0);" align="absmiddle" title="<cf_get_lang dictionary_id ='36258.Aşağı'>"><i class="fa fa-caret-down"></i></a>
                            </li>
                            
                            </cfif>
                            <cfif currentrow neq 1>
                            <li>
                                <a href="javascript://" onclick="loadPage(#line_number#,#process_row_id#,#attributes.process_id#,1);"  title="<cf_get_lang dictionary_id ='36259.Yukarı'>"> <i class="fa fa-caret-up"></i> </a>
                            </li>
                            </cfif>
                        </ul>
                    </td>
                    <td>#line_number#</td>
					<cfif xml_show_stage_code eq 1>
						<td>#stage_code#</td>
					</cfif>
                    <td><a style="cursor:pointer" href="#request.self#?fuseaction=process.form_add_process_rows&event=upd&process_id=#process_id#&process_row_id=#process_row_id#&process_name=#process_name#">#stage#</a></td>
                    <td>
                        <ul class="ui-icon-list">
                            <cfif (is_sms eq 1) and (session.ep.our_company_info.sms eq 1) ><li><a href="javascript://"><i class="fa fa-mobile-phone"title="Sms"></i></a></li></cfif>
                            <cfif is_email eq 1><li><a href="javascript://"><i class="fa fa-envelope-o" title="Mail"></i></a></li></cfif>
                            <cfif is_online eq 1><li><a href="javascript://"><i class="fa fa-user-o" title="<cf_get_lang dictionary_id ='57427.Online mesaj'>"></i></a></li></cfif>
                        </ul>
                    </td>
                    
                </tr>
            </cfoutput>
       </tbody>
    </cf_grid_list>
    <cf_seperator title="Main Display - Action File" id="df_af_file">
    <cf_flat_list id="df_af_file">
        <cfif len(get_kontrol.main_action_file) or len(get_kontrol.main_file)>
            <cfoutput>
				<cfif len(get_kontrol.main_action_file)>
                    <tr><td><a href="javascript://" onclick="openBoxDraggable('#request.self#?fuseaction=process.popup_main_display_action_file&is_main_action_file=#get_kontrol.is_main_action_file#&main_action_file=#get_kontrol.main_action_file#&process_id=#attributes.process_id#');">Main Display File</a></td></tr>
				</cfif>
				<cfif len(get_kontrol.main_file)>
                    <tr><td><a href="javascript://" onClick="openBoxDraggable('#request.self#?fuseaction=process.popup_main_display_action_file&is_main_file=#get_kontrol.is_main_file#&main_file=#get_kontrol.main_file#&process_id=#attributes.process_id#');">Main Action File</a></td></tr>
				</cfif>
			</cfoutput>
        <cfelse>
            <tr><td><cf_get_lang dictionary_id='57484.Kayıt Yok'></td></tr>
        </cfif>
    </cf_flat_list>
<script type="text/javascript">
	function loadPage(xx,yy,zz,tt)
	{	
		process_rows_div = 'process_rows';
		var send_address = '<cfoutput>#request.self#</cfoutput>?fuseaction=process.emptypopup_add_process_rows_line&type='+tt+'&process_id='+zz+'&process_row_id='+yy+'&line_number='+xx;
		
		AjaxPageLoad(send_address,process_rows_div ,1);
	} 
</script>
