<cf_xml_page_edit fuseact="hr.popup_upd_inventory_zimmet">
<cfinclude template="../query/get_zimmet_detail.cfm">
<cf_catalystHeader>
<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
    <cf_box>
        <cfform name="upd_inventory_zimmet" action="#request.self#?fuseaction=hr.emptypopup_upd_inventory_zimmet" method="post">
                <cf_box_elements>
                            <div class="col col-4 col-md-4 col-sm-6 col-xs-12" type="column" sort="true" index="1">
                                <div class="form-group" id="item-employee">
                                    <label class="col col-3 col-xs-12"><cf_get_lang dictionary_id='57570.Ad Soyadı'> *</label>
                                    <div class="col col-9 col-xs-12">
                                        <div class="input-group">
                                            <input type="hidden" name="employee_id" id="employee_id" value="<cfoutput>#get_zimmet.EMPLOYEE_ID#</cfoutput>">
                                            <input type="hidden" name="zimmet_id" id="zimmet_id" value="<cfoutput>#attributes.zimmet_id#</cfoutput>">
                                            <cfset attributes.employee_id=get_zimmet.employee_id>
                                            <cfinclude template="../query/get_employee_name.cfm">
                                            <input name="employee_name" id="employee_name"  style="width:150px;"  value="<cfoutput>#GET_EMPLOYEE_NAME.EMPLOYEE_NAME# #GET_EMPLOYEE_NAME.EMPLOYEE_SURNAME#</cfoutput>"type="text" readonly>
                                            <span class="input-group-addon btnPointer icon-ellipsis" onClick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=hr.popup_list_positions&field_emp_id=upd_inventory_zimmet.employee_id&field_emp_name=upd_inventory_zimmet.employee_name','list');return false"></span>
                                        </div>
                                    </div>
                                </div>
                                <div class="form-group" id="item-process">
                                    <label class="col col-3 col-xs-12"><cf_get_lang dictionary_id="57482.Aşama"></label>
                                    <div class="col col-9 col-xs-12"><cf_workcube_process is_upd='0' process_cat_width='150'  is_detail='1' select_value='#get_zimmet.process_stage#'></div>
                                </div>
                                <div class="form-group" id="item-department">
                                    <label class="col col-3 col-xs-12"><cf_get_lang dictionary_id ='57572.Departman'></label>
                                    <div class="col col-9 col-xs-12">
                                        <cfinclude template="../query/get_emp_detail.cfm">
                                        <input type="text" name="department" id="department"  value="<cfoutput>#get_dep.DEPARTMENT_HEAD#</cfoutput>"style="width:150px;" readonly>
                                    </div>
                                </div>
                                <div class="form-group" id="item-company">
                                    <label class="col col-3 col-xs-12"><cf_get_lang dictionary_id='57574.Şirket'> *</label>
                                    <div class="col col-9 col-xs-12">
                                        <cfquery name="get_our_comp" datasource="#DSN#">
                                            SELECT 
                                                NICK_NAME,
                                                COMP_ID 
                                            FROM 
                                                OUR_COMPANY
                                                WHERE
                                                COMP_ID IN (SELECT DISTINCT BR.COMPANY_ID FROM EMPLOYEE_POSITION_BRANCHES EBR LEFT JOIN BRANCH BR ON BR.BRANCH_ID = EBR.BRANCH_ID WHERE EBR.POSITION_CODE = #session.ep.position_code# AND EBR.BRANCH_ID = #get_dep.BRANCH_ID#)
                                        </cfquery>
                                        <select name="company_id" id="company_id"  style="width:150px;">
                                            <cfoutput query="get_our_comp">
                                                <option value="#COMP_ID#" <cfif get_zimmet.company_id eq COMP_ID >selected</cfif>>#NICK_NAME#</option>
                                            </cfoutput>
                                        </select>
                                    </div>
                                </div>
                            </div>
                        </cf_box_elements>
                        <cfsavecontent variable="head"><cf_get_lang dictionary_id='30004.Fiziki Varlıklar'></cfsavecontent>
                        <cf_seperator id="sep1" header="#head#">
                            <div id="sep1" class="col-12">
                        <cf_grid_list sort="0">
                         
                            <thead>
                                <tr>
                                    <th width="15"><a href="javascript://" onClick="add_row();"><i class="fa fa-plus" border="0"></i></a></th>
                                    <th><cf_get_lang dictionary_id='57931.Cins'></th>
                                    <th><cf_get_lang dictionary_id='57487.No'></th>
                                    <th><cf_get_lang dictionary_id='58910.Özellikler'></th>
                                    <th><cf_get_lang dictionary_id='57742.Tarih'></th>
                                    <th><cf_get_lang dictionary_id='33211.Teslim Eden'></th>
                                    <cfif x_use_pam eq 1>
                                    <th><cf_get_lang dictionary_id='48445.İlişkili Fiziki Varlık'></th>
                                    </cfif>
                                </tr>
                            </thead>
                            <tbody id="table1">
                                <cfquery name="get_zimmet_row" datasource="#DSN#">
                                    SELECT 
                                        ZIMMET_ID, 
                                        DEVICE_NAME, 
                                        INVENTORY_NO, 
                                        PROPERTY, 
                                        ZIMMET_DATE, 
                                        GIVEN_EMP_ID,
                                        ASSET_ID,
                                        RELATION_PHYSICAL_ASSET_ID
                                    FROM 
                                        EMPLOYEES_INVENT_ZIMMET_ROWS 
                                    WHERE 
                                        ZIMMET_ID=#attributes.ZIMMET_ID#
                                </cfquery>
                                <input type="hidden" name="record_num" id="record_num" value="<cfoutput>#get_zimmet_row.recordcount#</cfoutput>">
                                <cfoutput query="get_zimmet_row">
                                    <cfset i=currentrow>
                                    <tr id="frm_row#currentrow#">
                                        <td><input type="hidden" value="1" name="row_kontrol#i#" id="row_kontrol#i#"><a href="javascript://" onClick="sil(#i#);"><i class="fa fa-minus" border="0"></i></a></td>
                                        <td width="100"><input type="text" name="device_name#i#" id="device_name#i#" value="#DEVICE_NAME#" style="width:100px;"></td>
                                        <td width="55"><input type="text"  name="inventory_no_#i#" id="inventory_no_#i#"  value="#INVENTORY_NO#" style="width:55px;"></td>
                                        <td width="100"><input type="text"  name="property_#i#" id="property_#i#"  value="#PROPERTY#" style="width:100px;"></td>
                                        <td width="90">
                                            <div class="form-group">
                                                <div class="input-group"> <cfinput  type="text" id="tarih#i#" name="tarih#i#" value="#dateformat(ZIMMET_DATE,dateformat_style)#" style="margin-right:4px;">
                                                    <span class="input-group-addon"><cf_wrk_date_image date_field="tarih#i#"></span>
                                                </div>
                                            </div>
                                        </td>
                                        <td width="150">
                                            <div class="form-group">
                                                <div class="input-group">
                                                    <input  type="hidden"  name="given_id_#i#" id="given_id_#i#" value="#GIVEN_EMP_ID#">
                                                    <cfif len(GIVEN_EMP_ID)>
                                                        <cfset attributes.EMPLOYEE_ID=GIVEN_EMP_ID>
                                                        <cfinclude template="../query/get_employee_name.cfm">
                                                        <input type="text" name="given_name_#i#" id="given_name_#i#"  value="#GET_EMPLOYEE_NAME.EMPLOYEE_NAME# #GET_EMPLOYEE_NAME.EMPLOYEE_SURNAME#" style="width:125px;">
                                                    <cfelse>
                                                        <input type="text" name="given_name_#i#" id="given_name_#i#"  value="" style="width:125px;">
                                                    </cfif>
                                                    <span class="input-group-addon btnPointer icon-ellipsis" onClick="windowopen('#request.self#?fuseaction=hr.popup_list_positions&field_emp_id=upd_inventory_zimmet.given_id_#i#&field_emp_name=upd_inventory_zimmet.given_name_#i#','list');return false"></span>
                                                </div>
                                            </div>
                                            <cfif x_use_pam eq 1>
                                            <td width="150">
                                                <cfif len(get_zimmet_row.RELATION_PHYSICAL_ASSET_ID)>
                                                <cfquery name="get_relation_asset" datasource="#DSN#">
                                                    SELECT ASSETP_ID,ASSETP FROM ASSET_P WHERE ASSETP_ID = #get_zimmet_row.RELATION_PHYSICAL_ASSET_ID#
                                                 </cfquery>
                                                </cfif>
                                            <div class="input-group"><input type="hidden"  id="relation_asset_id#i#" name="relation_asset_id#i#" value="<cfif len(get_zimmet_row.RELATION_PHYSICAL_ASSET_ID)>#get_relation_asset.ASSETP_ID# </cfif>">
                                                <input type="text" name="relation_asset#i#" value="<cfif len(get_zimmet_row.RELATION_PHYSICAL_ASSET_ID)>#get_relation_asset.ASSETP#</cfif>" id="relation_asset#i#" onfocus="AutoComplete_Create('relation_asset#i#','ASSETP','ASSETP','get_assetp_autocomplete','','ASSETP_ID,ASSETP','relation_asset_id#i#,relation_asset#i#','','3','135');">
                                                <span class="input-group-addon icon-ellipsis btn" onclick="openBoxDraggable('#request.self#?fuseaction=assetcare.popup_list_assetps&field_id=upd_inventory_zimmet.relation_asset_id#i#&field_name=upd_inventory_zimmet.relation_asset#i#&event_id=0&motorized_vehicle=0');"></span>
                                            </div>
                                        </td>
                                    </cfif>
                                        </td>
                                    </tr>
                                </cfoutput>
                            </tbody>
                        </cf_grid_list>
                    </div>
                        <cf_box_footer>
                            <div class="col col-6">
                                <cf_record_info query_name="get_zimmet">
                            </div>
                            <div class="col col-6">
                                <cf_workcube_buttons is_upd='1' del_function='control2()' add_function="kontrol()">
                            </div>
                </cf_box_footer>    
        </cfform>
    </cf_box>
</div>
<cfquery name="get_authority" datasource="#DSN#">
    SELECT BRANCH_ID FROM EMPLOYEE_POSITION_BRANCHES WHERE POSITION_CODE = #session.ep.position_code#  AND BRANCH_ID = #get_dep.BRANCH_ID#
 </cfquery>
 <cfquery name="get_authority_company" datasource="#DSN#">
    SELECT DISTINCT BR.COMPANY_ID FROM EMPLOYEE_POSITION_BRANCHES EBR LEFT JOIN BRANCH BR ON BR.BRANCH_ID = EBR.BRANCH_ID WHERE EBR.POSITION_CODE = #session.ep.position_code#
 </cfquery>
<cfif get_authority.recordCount eq 0 or get_authority_company.recordCount eq 0>
    <script type="text/javascript">
		alert("<cf_get_lang dictionary_id ='57532.Yetkiniz Yok'>!");
		window.history.go(-1);
	</script>
	<cfabort>
</cfif>
<script type="text/javascript">
	row_count=<cfoutput>#get_zimmet_row.recordcount#</cfoutput>;
	function control2()
	{
		if(document.getElementById('process_stage').value=='')
		{
			alert("<cf_get_lang dictionary_id='58842.Lütfen Süreç Seçiniz'>");
			return false;	
		} 
		else{
		upd_inventory_zimmet.action = "<cfoutput>#request.self#?fuseaction=ehesap.emptypopup_del_zimmet_rows&zimmet_id=#attributes.zimmet_id#</cfoutput>";
		upd_inventory_zimmet.submit();
		}
	}
	function sil(sy)
	{
		var my_element=eval("upd_inventory_zimmet.row_kontrol"+sy);
		my_element.value=0;
		//var my_element=eval("frm_row"+sy);
		//my_element.style.display="none";
		var my_elementx = document.getElementById('frm_row' + sy);
		my_elementx.parentNode.removeChild(my_elementx);	
	}
	
	function kontrol()
		{
			var hata_list = '';
			var satir=0;
			for(var i=1; i<=row_count; i++)
			{	
				if(document.getElementById('frm_row' + i)!=undefined && document.getElementById('frm_row' + i)!=null)		
				{
					satir=satir+1;
					given_name = document.getElementById('given_name_'+i).value;
					given_id = document.getElementById('given_id_'+i).value;
					if(given_name == '' || given_id == '')
					{
						if(hata_list!='') 
							hata_list = hata_list+','+satir;
						else 
							hata_list = satir;
					}
				}
			}
			var satir=0;
			for(var i=1; i<=row_count; i++)
			{
				if(document.getElementById('frm_row' +i)!=undefined && document.getElementById('frm_row' + i)!=null)		
				{	satir=satir+1;		
					date_kontrol = document.getElementById('tarih'+i).value;
					if(date_kontrol == '')
					{
						alert("<cf_get_lang dictionary_id='41538.Tarih girmediniz'>! <cf_get_lang dictionary_id='58230.Satır No'> :" +satir);
						return false;
					}
				}
			}
			if(hata_list!='')
			{
				alert(hata_list+ "<cf_get_lang dictionary_id='41537.Satırlarda Teslim Eden Girmelisiniz!'>");
				return false;
				}
			return process_cat_control();
				
		}

	function add_row()
	{
		row_count++;
		var newRow;
		var newCell;
		newRow = document.getElementById("table1").insertRow(document.getElementById("table1").rows.length);
		document.upd_inventory_zimmet.record_num.value=row_count;
		newRow.setAttribute("name","frm_row" + row_count);
		newRow.setAttribute("id","frm_row" + row_count);		
		newRow.setAttribute("NAME","frm_row" + row_count);
		newRow.setAttribute("ID","frm_row" + row_count);
	
		newCell = newRow.insertCell(newRow.cells.length);	
		newCell.innerHTML = '<a style="cursor:pointer" onclick="sil('+ row_count +');"><i class="fa fa-minus" border="0"></a>';
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<input  type="hidden" value="1"  name="row_kontrol' + row_count +'" ><input type="text" name="device_name' + row_count + '">';
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<input type="text" name="inventory_no_' + row_count + '">';
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<input type="text" name="property_' + row_count + '">';
		newCell = newRow.insertCell(newRow.cells.length);
		
		newCell.setAttribute("id","tarih_" + row_count + "_td");
		newCell.innerHTML = ' <div class="form-group"><div class="input-group"> <input type="text" name="tarih' + row_count +'" id="tarih' + row_count +'" class="text" maxlength="10"  value=""><span class="input-group-addon" id="tarih'+row_count + '_td'+'"></span></div></div>';
		wrk_date_image('tarih' + row_count);
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML =	' <div class="form-group"><div class="input-group"> <input type="hidden" name="given_id_' + row_count +'" id="given_id_' + row_count +'"><input type="text" name="given_name_' + row_count  +'" id="given_name_' + row_count  +'" style="width:125px;"> <span class="input-group-addon btnPointer icon-ellipsis no-bg" onClick="opage('+ row_count +');"></span><input type="hidden" name="is_active_' + row_count +'"></div></div>';
    <cfif x_use_pam eq 1>
        newCell = newRow.insertCell(newRow.cells.length);
        newCell.innerHTML = '<div class="input-group"><input type="hidden"  id="relation_asset_id' + row_count + '" name="relation_asset_id' + row_count + '">'+
	'<input type="text" name="relation_asset' + row_count + '" id="relation_asset' + row_count + '" onfocus="'+"AutoComplete_Create('relation_asset" + row_count + "','ASSETP','ASSETP','get_assetp_autocomplete','','ASSETP_ID,ASSETP','relation_asset_id" + row_count + ",relation_asset" + row_count + "','','3','135');"+'">'+
	'<span class="input-group-addon icon-ellipsis btn" onclick="'+"openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=assetcare.popup_list_assetps&field_id=upd_inventory_zimmet.relation_asset_id" + row_count + "&field_name=upd_inventory_zimmet.relation_asset" + row_count + "&event_id=0&motorized_vehicle=0');"+'"></span></div>';
    </cfif>
}
  
	function opage(deger)
	{
		windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=hr.popup_list_positions&field_emp_id=upd_inventory_zimmet.given_id_' + deger + '&field_emp_name=upd_inventory_zimmet.given_name_' + deger,'list');
	}
	function opage2(deger)
	{
		windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=hr.popup_list_positions&field_emp_id=upd_inventory_zimmet.taken_id_' + deger + '&field_emp_name=upd_inventory_zimmet.taken_name_' + deger,'list');
	}		
	function ac_tarih(deger)
	{
		windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_calender&alan=upd_inventory_zimmet.tarih' + deger + '&field_name=upd_inventory_zimmet.given_name_' + deger  , 'date');	
	}
</script>

