
<cfset Position_Assistant= createObject("component","V16.hr.ehesap.cfc.position_assistant") />
<cfset get_position_assistant=Position_Assistant.GET_POSITION_ASSISTANT(position_id:attributes.position_id_)/>
<cfset get_modules=Position_Assistant.get_modules()/>
<cfform name="position_assistant_form" action='V16/hr/ehesap/cfc/position_assistant.cfc?method=ADD_POSITION_ASSISTANT&position_assistant_modules_id=#get_position_assistant.position_assistant_modules_id#&position_id=#attributes.position_id_#'>
    <cf_flat_list sort="0">
        <thead>
            <tr>
                <th width="20"> 
                    <cfinput type="hidden" name="position_id" id="position_id" value="#attributes.position_id_#">
                    <cfinput type="hidden" name="record_num" id="record_num" value="#get_position_assistant.recordcount#" >
                    <a href="javascript://" onclick="add_row();"><i class="fa fa-plus"></i></a>
                </th>
                <th width="120"><cf_get_lang dictionary_id='57576.Çalışan'></th>
                <th><cf_get_lang dictionary_id='110.Modul Adı'></th>
            </tr>
        </thead>
        <tbody name="table1" id="table1">
            <cfif get_position_assistant.recordCount>
                <cfoutput query="get_position_assistant">
                    <tr id="frm_row#currentrow#">
                        <td>
                            <cfinput type="hidden" name="id#currentrow#" id="id#currentrow#" value="#position_assistant_modules_id#">
                            <input type="hidden" name="row_kontrol#currentrow#" id="row_kontrol#currentrow#" value="1">
                            <a href="javascript://" onClick="sil(#position_assistant_modules_id#);"><i class="fa fa-minus"></i></a>
                        </td>
                        <td>
                            <div class="form-group">
                                <div class="input-group">
                                    <input type="hidden" name="position_assistant_code#currentrow#" id="position_assistant_code#currentrow#" value="#position_assistant_code#">
                                    <input type="hidden" name="position_assistant_id#currentrow#" id="position_assistant_id#currentrow#" value="#position_assistant_id#">
                                    <input type="text" name="position_assistant#currentrow#" id="position_assistant#currentrow#" value="#get_emp_info(position_assistant_id,0,0)#">
                                    <span class="input-group-addon icon-ellipsis" onClick="pencere_ac_company(#currentrow#);"></span>
                                </div>
                            </div>
                        </td>
                        <td>
                            <div class="form-group">
                                <cfif get_modules.recordCount>
                                    <cfloop query="get_modules">
                                        <div class="col col-2 col-xs-2">
                                            <input type="checkbox" name="position_assistant_module#get_position_assistant.currentrow#" id="position_assistant_module#get_position_assistant.currentrow#" value="#get_modules.module_id#" <cfif listFind(get_position_assistant.position_assistant_modules,module_id)>checked</cfif>>
                                            <label><cf_get_lang dictionary_id="#MODULE_DICTIONARY_ID#"></label>
                                        </div>
                                    </cfloop>
                                </cfif>
                            </div>
                        </td>
                    </tr>
                </cfoutput>
            </cfif>
        </tbody> 
    </cf_flat_list>
    <cf_box_footer>
        <cf_workcube_buttons type_format='1' is_upd='0' add_function='kontrol()'>
    </cf_box_footer>
  
</cfform>
<script  type="text/javascript">
    <cfif isdefined("get_position_assistant") and get_position_assistant.recordcount>
		row_count=<cfoutput>#get_position_assistant.recordcount#</cfoutput>;
	<cfelse>
		row_count=0;
	</cfif>
    function sil(sy)
	{
        document.position_assistant_form.action="V16/hr/ehesap/cfc/position_assistant.cfc?method=DEL_POSITION_ASSISTANT&position_assistant_modules_id="+sy; 
        position_assistant_form.submit();
        return true;     
	}
    function add_row()
	{
		row_count++;
		var newRow;
		var newCell;
			newRow = document.getElementById("table1").insertRow(document.getElementById("table1").rows.length);	
			newRow.setAttribute("name","frm_row" + row_count);
            newRow.setAttribute("id","frm_row" + row_count);
            newRow.setAttribute("NAME","frm_row" + row_count);
			newRow.setAttribute("ID","frm_row" + row_count);				
            document.getElementById("record_num").value = row_count;
            newCell = newRow.insertCell(newRow.cells.length);
			newCell.setAttribute("nowrap","nowrap");
			newCell.innerHTML = '<input  type="hidden" name="row_kontrol' + row_count +'" id="row_kontrol' + row_count +'" value="1"><a onclick="sil(' + row_count + ');"  ><i class="fa fa-minus" title="<cf_get_lang dictionary_id='57463.Sil'>"></a>';
		
			newCell = newRow.insertCell(newRow.cells.length);
			newCell.innerHTML = '<div class="form-group"><div class="input-group"> <input type="hidden" name="position_assistant_code' + row_count  +'" id="position_assistant_code' + row_count  +'" value=""><input type="hidden" name="position_assistant_id' + row_count  +'" id="position_assistant_id' + row_count  +'" value=""><input type="text" name="position_assistant' + row_count  +'" id="position_assistant' + row_count  +'" value=""><span class="input-group-addon icon-ellipsis" onClick="pencere_ac_company('+ row_count +');"></span></div></div>';
            newCell = newRow.insertCell(newRow.cells.length);
            newCell.innerHTML = '<div class="form-group"><cfif get_modules.recordCount><cfloop query="get_modules"><div class="col col-2 col-xs-2"><input type="checkbox" name="position_assistant_module' + row_count  +'" id="position_assistant_module' + row_count  +'" value="<cfoutput>#get_modules.module_id#"><label>#get_modules.module#</label></cfoutput></div></cfloop></cfif></div>';
		
    }
    function pencere_ac_company(no)
	{
		document.getElementById("position_assistant_id"+no).value = '';
		document.getElementById("position_assistant"+no).value = '';
		openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_positions&field_emp_id=position_assistant_form.position_assistant_id' + no +'&field_name=position_assistant_form.position_assistant' + no +'&field_code=position_assistant_form.position_assistant_code' + no +'');
    }

    function kontrol()
	{
        for(r=1;r<=document.all.record_num.value;r++)
            {
                deger_row_kontrol = document.getElementById('row_kontrol'+r);
                deger_position_assistant_module = document.getElementById('position_assistant_module'+r);
                deger_position_assistant_id = document.getElementById('position_assistant_id'+r);
                var $checkboxes = $("input:checkbox[id^='position_assistant_module"+r+"']:checked");
                var countCheckedCheckboxes = $checkboxes.filter(':checked').length;
                if(deger_row_kontrol.value == 1)
                {
                    if (deger_position_assistant_id.value == "")
                    { 
                        alert ("<cf_get_lang dictionary_id='58194.Zorunlu Alan'><cf_get_lang dictionary_id='57576.Çalışan'>! <cf_get_lang dictionary_id='58230.Satir No'>:"+r);
                        return false;
                    }	
                    if (countCheckedCheckboxes == 0)
                    { 
                        alert ("<cf_get_lang dictionary_id='58194.Zorunlu Alan'><cf_get_lang dictionary_id='38728.Modül'>! <cf_get_lang dictionary_id='58230.Satir No'>:"+r);
                        return false;
                    }	
                  		
                }
            }
    }
</script>