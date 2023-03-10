<cfif isdefined("attributes.selected_id")>
	<cfquery name="GET_MAIN" datasource="#DSN#">
		SELECT 
			MAIN_MENU_SELECTS.*,
            MAIN_MENU_SETTINGS.MENU_NAME
		FROM 
			MAIN_MENU_SELECTS,
            MAIN_MENU_SETTINGS
		WHERE 
			MAIN_MENU_SELECTS.SELECTED_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.selected_id#"> AND
            MAIN_MENU_SELECTS.MENU_ID = MAIN_MENU_SETTINGS.MENU_ID
	</cfquery>
</cfif>
<cfif isdefined("attributes.main_layer_row_id")>
	<cfquery name="GET_MAIN" datasource="#DSN#">
		SELECT 
			MAIN_MENU_LAYER_SELECTS.*,
            MAIN_MENU_SETTINGS.MENU_NAME
		FROM 
			MAIN_MENU_LAYER_SELECTS,
			MAIN_MENU_SETTINGS
		WHERE 
			MAIN_MENU_LAYER_SELECTS.LAYER_ROW_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.main_layer_row_id#"> AND
            MAIN_MENU_LAYER_SELECTS.MENU_ID = MAIN_MENU_SETTINGS.MENU_ID
	</cfquery>
</cfif>

<cfquery name="GET_MAIN_MENU_SELECT" datasource="#DSN#">
	SELECT 
		* 
	FROM 
		MAIN_MENU_LAYER_SELECTS 
	WHERE 
		<cfif isdefined("attributes.selected_id")>
			SELECTED_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.selected_id#">
		<cfelseif isdefined("attributes.main_layer_row_id")>
			MAIN_LAYER_ROW_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.main_layer_row_id#">
		</cfif>
</cfquery>
<cf_popup_box title="#getLang('settings',2416)# : <cfoutput>#get_main.link_name# (#get_main.menu_name#)</cfoutput>">
    <cfform name="user_group" action="#request.self#?fuseaction=settings.emptypopup_upd_main_menu_layer" enctype="multipart/form-data" method="post" onsubmit="newRows()"> 
        <input type="hidden" name="menu_id" id="menu_id" value="<cfoutput>#attributes.menu_id#</cfoutput>">
       	<cf_medium_list>
            <thead>
                <tr>
                    <th colspan="10" class="formbold"><cf_get_lang no ='897.Menü Linkleri'></th>
                </tr>
                <tr class="txtboldblue" height="20">
                    <th width="15"><input type="button" class="eklebuton" title="<cf_get_lang_main no ='170.Ekle'>" onclick="add_row();"></th>
                    <th width="165"><cf_get_lang_main no='520.Sözlük'></th>
                    <th width="180"><cf_get_lang no='898.Link Adı'></th>
                    <th width="165"><cf_get_lang_main no='1964.URL'></th>
                    <th width="75"><cf_get_lang no ='899.Davranış'></th>
                    <th width="35"><cf_get_lang_main no='1165.Sıra'></th>
                    <th width="25"> LK</th>
                    <th><cf_get_lang no='2568.Login Kontrol'></th>
                 	<th width="150"><cf_get_lang_main no ='1965.İmaj'></th>
                    <th>&nbsp;</th>
                </tr>
            </thead>
            <tbody id="link_table">
                <input name="record_num_sabit" id="record_num_sabit" type="hidden" value="<cfoutput>#get_main_menu_select.recordcount#</cfoutput>">
                <input name="record_num" id="record_num" type="hidden" value="0">
                <cfif isdefined("attributes.selected_id")>
                    <input name="selected_id" id="selected_id" type="hidden" value="<cfoutput>#attributes.selected_id#</cfoutput>">
                </cfif>
                <cfif isdefined("attributes.main_layer_row_id")>
                    <input name="main_layer_row_id" id="main_layer_row_id" type="hidden" value="<cfoutput>#attributes.main_layer_row_id#</cfoutput>">
                </cfif>
                <cfoutput query="get_main_menu_select">
                    <input  type="hidden"  value="1"  name="row_kontrol_sabit_#currentrow#" id="row_kontrol_sabit_#currentrow#">
                    <input  type="hidden"  value="#LAYER_ROW_ID#"  name="layer_row_id_sabit_#currentrow#" id="layer_row_id_sabit_#currentrow#">
                    <tr id="frm_row_sabit_#currentrow#">
                        <td><a style="cursor:pointer" onclick="sil_sabit(#currentrow#);" ><img  src="images/delete_list.gif" border="0"></a></td>
                        <td>
							<cfif link_name_type eq 1>
                               <cfif isNumeric(link_name)>
                                    <cfquery name="get_lang_name" datasource="#dsn#">
                                        SELECT ITEM FROM SETUP_LANGUAGE_#UCase(session.ep.language)# WHERE MODULE_ID = 'main' AND ITEM_ID = #link_name#
                                    </cfquery>
                                <cfelse>
                                    <cfset get_lang_name.item = link_name>
                                </cfif>
                                <cfinput type="hidden" name="link_name_id_sabit_#currentrow#" value="#link_name#">
                                <cfinput type="text" value="#get_lang_name.item#" style="width:145px;" name="link_name_sabit_#currentrow#" maxlength="100">
                            <cfelseif link_name_type eq 2>
                               <cfif isNumeric(link_name)>
                                    <cfquery name="get_lang_name" datasource="#dsn#">
                                        SELECT ITEM FROM SETUP_LANGUAGE_#UCase(session.ep.language)# WHERE MODULE_ID = 'objects2' AND ITEM_ID = #link_name#
                                    </cfquery>
                                <cfelse>
                                    <cfset get_lang_name.item = link_name>
                                </cfif>
                                <cfinput type="hidden" name="link_name_id_sabit_#currentrow#" value="#link_name#">
                                <cfinput type="text" value="#get_lang_name.item#" style="width:145px;" name="link_name_sabit_#currentrow#" maxlength="100">
                            <cfelse>
                                <cfinput type="hidden" name="link_name_id_sabit_#currentrow#" value="">
                                <cfinput type="text" value="" style="width:145px;" name="link_name_sabit_#currentrow#" maxlength="100">
                            </cfif>					
                            <a href="javascript://" onclick="pencere_ac2('#currentrow#');"><img src="/images/plus_thin.gif" alt="<cf_get_lang no='1173.Dil Ekle'>" border="0" align="absmiddle"></a>
                            <cfinput type="hidden" name="link_name_type_sabit_#currentrow#" id="link_name_type_sabit_#currentrow#" value="#link_name_type#" />
                        </td>
                         <td>
							 <cfif link_name_type eq 0> 
                                 <cfinput type="text" value="#LINK_NAME#" style="width:145px;" name="link_name2_sabit_#currentrow#" maxlength="100" onFocus="get_value(#currentrow#,2)">
                             <cfelse>
                                 <cfinput type="text" value="" style="width:145px;" name="link_name2_sabit_#currentrow#" maxlength="100" onFocus="get_value(#currentrow#,2)">
                             </cfif>
                              <cf_language_info 
                                    table_name="MAIN_MENU_LAYER_SELECTS" 
                                    column_name="LINK_NAME" 
                                    column_id_value="#GET_MAIN_MENU_SELECT.LAYER_ROW_ID#" 
                                    maxlength="100" 
                                    datasource="#dsn#" 
                                    column_id="LAYER_ROW_ID" 
                                    control_type="0">
                        </td>
                        <td nowrap="nowrap">
                            <cfinput type="text" value="#SELECTED_LINK#" style="width:145px;" name="selected_link_sabit_#currentrow#" maxlength="250">
                            <a href="javascript://" onclick="windowopen('#request.self#?fuseaction=settings.popup_list_select_switch&selected_link=user_group.selected_link_sabit_#currentrow#','list');"><img src="/images/plus_thin.gif" border="0" align="absmiddle"></a>
                        </td>
                        <td>
                            <select name="link_type_sabit_#currentrow#" id="link_type_sabit_#currentrow#" style="width:75px;">
                                <option value="-1" <cfif LINK_TYPE eq -1>selected</cfif>><cf_get_lang no='379.Normal'></option>
                                <option value="-9" <cfif LINK_TYPE eq -9>selected</cfif>><cf_get_lang no='902.Layer'></option>
                                <option value="-2" <cfif LINK_TYPE eq -2>selected</cfif>><cf_get_lang no='903.Yeni Sayfa'></option>
                                <option value="-3" <cfif LINK_TYPE eq -3>selected</cfif>><cf_get_lang no='904.Popup Small'></option>
                                <option value="-4" <cfif LINK_TYPE eq -4>selected</cfif>><cf_get_lang no='905.Popup Medium'></option>
                                <option value="-5" <cfif LINK_TYPE eq -5>selected</cfif>><cf_get_lang no='906.Popup List'></option>
                                <option value="-6" <cfif LINK_TYPE eq -6>selected</cfif>><cf_get_lang no='907.Popup Page'></option>
                                <option value="-7" <cfif LINK_TYPE eq -7>selected</cfif>><cf_get_lang no='908.Popup Project'></option>
                                <option value="-8" <cfif LINK_TYPE eq -8>selected</cfif>><cf_get_lang no='909.Popup Horizantal'></option>
                                <option value="-10" <cfif LINK_TYPE eq -10>selected</cfif>><cf_get_lang no ='2420.Güvenli Link'></option>
                                <option value="-11" <cfif LINK_TYPE eq -11>selected</cfif>><cf_get_lang no ='2421.Popup Güvenli Link'></option>
                                <option value="-13" <cfif LINK_TYPE eq -13>selected</cfif>><cf_get_lang no ='2422.Site Dışı Link'></option>
                                <option value="-14" <cfif LINK_TYPE eq -14>selected</cfif>> Ajax</option>	
                            </select>
                        </td>
                        <td><cfinput type="text" value="#order_no#" style="width:35px;" name="order_no_sabit_#currentrow#" maxlength="2" validate="integer" message="<cf_get_lang no ='2423.Sıra No Hatalı'>!"></td>
                        <td><input type="checkbox" value="1" name="is_session_sabit_#currentrow#" id="is_session_sabit_#currentrow#" <cfif is_session eq 1>checked</cfif>></td>
                        <td>
                            <select name="login_control_#currentrow#" id="login_control_#currentrow#" style="width:100px;">
                                <option value="0" <cfif login_control eq 0>selected</cfif>><cf_get_lang no='2569.Her Durumda'></option>
                                <option value="1" <cfif login_control eq 1>selected</cfif>><cf_get_lang no ='2570.Üye Girişi Varken'></option>
                                <option value="2" <cfif login_control eq 2>selected</cfif>><cf_get_lang no ='2571.Üye Girişi Yokken'></option>
                                <option value="3" <cfif login_control eq 3>selected</cfif>><cf_get_lang_main no='1197.Üye Kategorisi'></option>
                            </select>
                        </td>
                        <td nowrap="nowrap">
                            <input type="file" name="menu_row_file_#currentrow#" id="menu_row_file_#currentrow#" style="width:150px;">
                            <cfif len(link_image)><cf_get_server_file output_file="settings/#link_image#" output_server="#link_image_server_id#" output_type="2" image_link="1"></cfif>
                            <input type="hidden" name="old_menu_row_file_#currentrow#" id="old_menu_row_file_#currentrow#" value="#link_image#">
                            <input type="hidden" name="old_menu_row_file_server_id_#currentrow#" id="old_menu_row_file_server_id_#currentrow#" value="#link_image_server_id#">
                            <cfif len(link_image)>
                                <a href="javascript://" <cfoutput>onClick="windowopen('#request.self#?fuseaction=settings.emptypopup_del_background_files&menu_id=#get_main_menu_select.menu_id#&selected_id=#selected_id#','small');"</cfoutput>><img src="/images/delete_list.gif" border="0" align="absmiddle" title="<cf_get_lang_main no ='51.sil'>"></a>
                            </cfif>
                        </td>
                        <td>
                            <cfif (link_type eq -1)>
                                <a href="javascript://" onclick="windowopen('#request.self#?fuseaction=settings.popup_form_upd_main_menu_sub&layer_row_id=#layer_row_id#&menu_id=#attributes.menu_id#','wide2');"><img src="/images/properties.gif" alt="<cf_get_lang no ='2424.Alt Menü Oluştur'>" border="0"></a>
                            </cfif>
                            <cfif (link_type eq -9)>
                                <a href="javascript://" onclick="windowopen('#request.self#?fuseaction=settings.popup_form_upd_main_menu_layer&main_layer_row_id=#layer_row_id#&menu_id=#attributes.menu_id#','wide2');"><img src="/images/hand.gif" alt="<cf_get_lang no ='2495.Layer Menü'>" border="0"></a>
                            </cfif>
                        
                            <cfif len(SELECTED_LINK)>
                                <a href="javascript://" onclick="windowopen('#request.self#?fuseaction=settings.popup_select_site_objects&faction=#listlast(SELECTED_LINK,'.')#&menu_id=#attributes.menu_id#','wide2');"><img src="/images/content_plus.gif" alt="<cf_get_lang no ='2425.Sayfa Tasarla'>" border="0"></a>
                            </cfif>
                        </td>	
                    </tr>
                </cfoutput>
            </tbody>
        </cf_medium_list>
        <cf_popup_box_footer>
            <cf_workcube_buttons is_upd='1' is_delete='0'>
        </cf_popup_box_footer>
	</cfform>
</cf_popup_box>
<script type="text/javascript">
row_count=0;
	function sil(sy)
	{   
		var my_element=document.getElementById('row_kontrol'+sy);
		my_element.value=0;
		var my_element=eval("frm_row"+sy);
		my_element.style.display="none";
	}
	
	function sil_sabit(sy)
	{
		var my_element1=eval("user_group.row_kontrol_sabit_"+sy);
		my_element1.value=0;
		var my_element1=eval("frm_row_sabit_"+sy);
		my_element1.style.display="none";	
	}
	
	function get_value(satir,type)
	{
		if(type == 1)
		{
			document.getElementById('link_name_id'+satir).value = '';
			document.getElementById('link_name'+satir).value = '';
			document.getElementById('link_name_type'+satir).value = 0;
		}
		else
		{
			document.getElementById('link_name_sabit_'+satir).value = '';
			document.getElementById('link_name_id_sabit_'+satir).value = '';
			document.getElementById('link_name_type_sabit_'+satir).value = 0;
		}

	}

	function add_row()
	{
			row_count++;
			var newRow;
			var newCell;
			newRow = document.getElementById("link_table").insertRow(document.getElementById("link_table").rows.length);
			
			newRow.setAttribute("name","frm_row" + row_count);
			newRow.setAttribute("id","frm_row" + row_count);		
			newRow.setAttribute("NAME","frm_row" + row_count);
			newRow.setAttribute("ID","frm_row" + row_count);		
						
			document.user_group.record_num.value=row_count;
			
			newCell = newRow.insertCell(newRow.cells.length);
			newCell.innerHTML = '<a style="cursor:pointer" onclick="sil(' + row_count + ');" ><img  src="images/delete_list.gif" border="0"></a>';	

			newCell = newRow.insertCell(newRow.cells.length);
			newCell.innerHTML = '<input  type="hidden"  value="1" name="row_kontrol' + row_count +'" id="row_kontrol' + row_count +'"><input type="hidden" name="link_name_id' + row_count + '" id="link_name_id' + row_count + '"><input type="text" name="link_name' + row_count + '" id="link_name' + row_count + '" style="width:145px;" onChange="get_value('+row_count+',1);" readonly="readonly"> <a href="javascript://" onClick="pencere_ac_(' + row_count + ');"><img border="0" alt="<cf_get_lang no="1173.Dil Ekle">" src="/images/plus_thin.gif" align="absmiddle"></a>';
			
			newCell = newRow.insertCell(newRow.cells.length);
			newCell.innerHTML = '<input type="hidden" name="link_name_type' + row_count + '" id="link_name_type' + row_count + '" style="width:20px;" value="0"><input type="text" name="link_name2' + row_count + '" id="link_name2' + row_count + '" onFocus="get_value('+row_count+',1);"  style="width:145px;">';
			
			newCell = newRow.insertCell(newRow.cells.length);
			newCell.innerHTML = '<input type="text" name="selected_link' + row_count + '" id="selected_link' + row_count + '" style="width:140px;"> <a href="javascript://" onClick="pencere_ac(' + row_count + ')"><img src="/images/plus_thin.gif" border="0" align="absmiddle"></a>';
			
			newCell = newRow.insertCell(newRow.cells.length);
			newCell.innerHTML = '<select name="link_type' + row_count + '" id="link_type' + row_count + '" style="width:75px;"><option value="-1"><cf_get_lang no="379.Normal!"></option><option value="-9"><cf_get_lang no="902.Layer"></option><option value="-2"><cf_get_lang no="2572.Yeni Pencere"></option><option value="-3"><cf_get_lang no="904.Popup Small"></option><option value="-4"><cf_get_lang no="905.Popup Medium"></option><option value="-5"><cf_get_lang no="906.Popup List"></option><option value="-6"><cf_get_lang no="907.Popup Page"></option><option value="-7"><cf_get_lang no="908.Popup Project"></option><option value="-8"><cf_get_lang no="909.Popup Horizantal"></option><option value="-10"><cf_get_lang no="2421.Güvenli Link"></option><option value="-11"><cf_get_lang no="2421.Popup Güvenli Link"></option><option value="-13"><cf_get_lang no="2422.Site Dışı Link"></option><option value="-14"> Ajax</option></select>';
			
			newCell = newRow.insertCell(newRow.cells.length);
			newCell.innerHTML = '<input type="text" name="order_no' + row_count + '" id="order_no' + row_count +'" style="width:35px;" maxlength="2">';
			
			newCell = newRow.insertCell(newRow.cells.length);
			newCell.innerHTML = '<input type="checkbox" value="1" name="is_session_' + row_count + '">';
			
			newCell = newRow.insertCell(newRow.cells.length);
			newCell.innerHTML = '<select name="login_control' + row_count + '" id="login_control' + row_count + '" style="width:100px;"><option value="0"><cf_get_lang no="2569.Her Durumda"></option><option value="1"><cf_get_lang no ="2570.Üye Girişi Varken"></option><option value="2"><cf_get_lang no ="2571.Üye Girişi Yokken"></option><option value="3"><cf_get_lang_main no="1197.Üye Kategorisi"></option></select>';
			
			newCell = newRow.insertCell(newRow.cells.length);
			newCell.innerHTML = '&nbsp;';
			
			newCell = newRow.insertCell(newRow.cells.length);
			newCell.innerHTML = '&nbsp;';
			
	}
	
	function newRows()
	{
			for(i=1;i<=row_count;i++)
			{
				document.user_group.appendChild(document.getElementById('link_name_type' + i + ''));
				document.user_group.appendChild(document.getElementById('link_name' + i + ''));
				document.user_group.appendChild(document.getElementById('link_name_id' + i + ''));
				document.user_group.appendChild(document.getElementById('link_name2' + i + ''));
				document.user_group.appendChild(document.getElementById('link_type' + i + ''));
				document.user_group.appendChild(document.getElementById('login_control' + i + ''));
				document.user_group.appendChild(document.getElementById('order_no' + i + ''));
				document.user_group.appendChild(document.getElementById('selected_link' + i + ''));
				document.user_group.appendChild(document.getElementById('row_kontrol' + i + ''));
			}
	}
	
	function pencere_ac_(no)
	{
		windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=settings.popup_list_lang_number&item_id=user_group.link_name_id' + no + '&item=user_group.link_name' + no+'&field_type=user_group.link_name_type'+no+'&field_name2=user_group.link_name2'+no,'medium');
	}
	function pencere_ac2(no)
	{
		windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=settings.popup_list_lang_number&item_id=user_group.link_name_id_sabit_' + no + '&item=user_group.link_name_sabit_' + no +'&field_type=user_group.link_name_type_sabit_'+no+'&field_name2=user_group.link_name2_sabit_'+no,'medium');
	}	
	function pencere_ac3(no)
	{
		windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=settings.popup_list_select_switch&selected_link=user_group.selected_link' + no,'medium');
	}
	
	function pencere_ac(no)
	{
		windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=settings.popup_list_select_switch&selected_link=user_group.selected_link_sabit_' + no,'medium');
	}
</script>

