<cfparam name="attributes.modal_id" default="">
<div class="col col-12 col-xs-12">
    <cf_box title="#getLang(2207,'Masalar - Fiziki Varlık',38785)#" id="desks" scroll="1" collapsable="1" resize="1" popup_box="#iif(isdefined("attributes.draggable"),1,0)#">
        <cfform name="add_assetp" method="post" action="#request.self#?fuseaction=assetcare.emptypopup_add_assetp_desk">
            <cfif isdefined("attributes.asset_p_space_id")>
                <input type="hidden" name="asset_p_space_id" id="asset_p_space_id" value="<cfoutput>#attributes.asset_p_space_id#</cfoutput>">
            </cfif>
            <cf_box_elements>
                <div class="col col-6 col-md-6 col-sm-6 col-xs-12" type="column" index="1" sort="true">
                    <div class="form-group" id="item-assetp_catid">
                        <label class="col col-4 col-xs-12"><cf_get_lang no='517.Varlık Tipi'> </label>
                        <div class="col col-8 col-xs-12">
                                <cf_wrkassetcat Lang_main="322.Seciniz" it_asset="0" is_motorized="0" compenent_name="GetAssetCat3" assetp_catid="assetp_catid">
                        </div>
                    </div>
                    <div class="form-group" id="item-department">
                        <label class="col col-4 col-xs-12"><cf_get_lang no='144.Kayıtlı Departman'> </label>
                        <div class="col col-8 col-xs-12">
                            <div class="input-group">
                                <input type="hidden" name="department_id" id="department_id" value="<cfif isdefined('attributes.asset_p_space_id')><cfoutput>#get_assetp_space.department_id#</cfoutput></cfif>">
                                <cfif isdefined('attributes.asset_p_space_id')>
                                    <cfif len(get_assetp_space.department_id)>
                                        <cfinput type="text" name="department" id="department" value="#get_branchs_deps.branch_name# - #get_branchs_deps.department_head#"  onFocus="AutoComplete_Create('department','DEPARTMENT_HEAD','DEPARTMENT_HEAD','get_department1','','DEPARTMENT_ID','department_id','upd_assetp','3','200','');">
                                    <cfelse>
                                        <cfinput type="text" name="department" id="department" value="" onFocus="AutoComplete_Create('department','DEPARTMENT_HEAD','DEPARTMENT_HEAD','get_department1','','DEPARTMENT_ID','department_id','upd_assetp','3','200','');">
                                    </cfif>
                                <cfelse>
                                    <input type="text" name="department" id="department" value="" onFocus="AutoComplete_Create('department','DEPARTMENT_HEAD','DEPARTMENT_HEAD','get_department1','','DEPARTMENT_ID','department_id','add_assetp','3','200','');">
                                </cfif>
                                <span class="input-group-addon btn_Pointer icon-ellipsis" onClick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_departments&field_id=add_assetp.department_id&field_dep_branch_name=add_assetp.department','list');" title="Seçiniz"></span>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="col col-6 col-md-6 col-sm-6 col-xs-12" type="column" index="2" sort="true">
                    <div class="form-group" id="item_assetp_space_id">
                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='60371.Mekan'> </label>
                            <div class="col col-8 col-xs-12">
						<div class="input-group">
							<input type="hidden" name="asset_p_space_id" id="asset_p_space_id">
							<input type="hidden" name="assetp_space_code" id="assetp_space_code">
							<input type="text" name="assetp_space_name" id="assetp_space_name" onFocus="AutoComplete_Create('assetp_space_name','SPACE_NAME','SPACE_NAME','get_assetp_space','3','asset_p_space_id','assetp_space_id','','3','135')">
							<span class="input-group-addon icon-ellipsis" onclick="windowopen('<cfoutput>#request.self#?fuseaction=objects.popup_list_assetp_space&field_name=add_assetp.assetp_space_name&field_code=add_assetp.assetp_space_code&field_id=add_assetp.asset_p_space_id&horeca=1</cfoutput>','list');"></span>
						</div>
					</div>
                </div>
                    <div class="form-group" id="item-employee_name">
                        <label class="col col-4 col-xs-12"><cf_get_lang_main no='132.Sorumlu'> </label>
                        <div class="col col-8 col-xs-12">
                            <div class="input-group">
                                <input type="hidden" name="position_code" id="position_code">
                                <input type="hidden" name="emp_id" id="emp_id" >
                                <input type="text" name="employee_name" id="employee_name" onFocus="AutoComplete_Create('employee_name','MEMBER_NAME','MEMBER_NAME','get_member_autocomplete','3','POSITION_CODE,EMPLOYEE_ID','position_code,emp_id','','3','135','fill_department()');">
                                <span class="input-group-addon btn_Pointer icon-ellipsis" onclick="windowopen('<cfoutput>#request.self#?fuseaction=objects.popup_list_positions&field_code=add_assetp.position_code&field_name=add_assetp.employee_name&field_emp_id=add_assetp.emp_id&function_name=fill_department</cfoutput>&select_list=1','list')"></span>
                            </div>
                        </div>
                    </div>
                </div>
            </cf_box_elements>
            <div class="col col-12 col-md-12 col-sm-12 col-xs-12" type="column" index="4" sort="true">
                <cf_seperator title="#getLang('main','Masalar',38666)#" id="detail_seperator">
                <cf_grid_list id="detail_seperator">
                    <thead>
                        <!--- <tr>
                            <th style="background-color:#c9d8c5;" colspan="3"><cfoutput>#getLang('main',754)#</cfoutput></th>
                        </tr>  --->  
                        <tr>
                            <th width="20">
                                <input type="hidden" name="record_num" id="record_num" value="0">
                                <a onclick="add_row();"><i class="fa fa-plus" title="<cf_get_lang dictionary_id='57582.Ekle'>" alt="<cf_get_lang dictionary_id='57582.Ekle'>"></i></a>                         
                            </th>
                            <th width="300"><cf_get_lang dictionary_id='45955.Masa No'></th>
                            <th width="300"><cf_get_lang dictionary_id='51104.Sandalye Sayısı'></th>
                            <th width="300"><cf_get_lang dictionary_id='50389.QR Kodu'></th>
                        </tr>
                    </thead>
                    <tbody name="new_row" id="new_row">
                    </tbody>
                </cf_grid_list>
            </div>
            <cf_box_footer>
                <cf_workcube_buttons is_upd='0' add_function="kontrol_()">
            </cf_box_footer>
        </cfform>
    </cf_box>
</div>
<script>
    var row_count=document.add_assetp.record_num.value;
    function add_row()
	{
		row_count++;
		var newRow;
		var newCell;
		newRow = document.getElementById("new_row").insertRow(document.getElementById("new_row").rows.length);
		newRow.setAttribute("name","frm_row" + row_count);
		newRow.setAttribute("id","frm_row" + row_count);		
		newRow.setAttribute("NAME","frm_row" + row_count);
		newRow.setAttribute("ID","frm_row" + row_count);
		
		document.add_assetp.record_num.value = row_count;
		
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<a onclick="sil(' + row_count + ');"><i class="fa fa-minus" alt="<cf_get_lang dictionary_id='57463.Sil'>" title="<cf_get_lang dictionary_id='57463.Sil'>"></i></a>';	
		
		newCell=newRow.insertCell(newRow.cells.length);
		newCell.setAttribute('nowrap','nowrap');
		newCell.innerHTML = '<div class="form-group"><div class="input-group"><input type="hidden" value="1" name="row_kontrol' + row_count +'"><input type="text" name="desk_no' + row_count +'" id="desk_no'+ row_count +'" style="width:300px!important;"></div>';
		
		newCell=newRow.insertCell(newRow.cells.length);
		newCell.setAttribute('nowrap','nowrap');
		newCell.innerHTML = '<div class="form-group"><input type="text" name="chair_count' + row_count +'" text-align:right;"></div>';
        newCell=newRow.insertCell(newRow.cells.length);
		newCell.setAttribute('nowrap','nowrap');
		newCell.innerHTML = '<div class="form-group"><div class="input-group"><input type="text" id="qr_code' + row_count +'" name="qr_code' + row_count +'" text-align:right;"><span class="input-group-addon btnPointer" onclick="barcode_('+row_count+')" title="<cf_get_lang dictionary_id='37940.Otomatik barkod'> !"><i class="fa fa-qrcode"></i></span></div></div>';
	}
    function barcode_(row_count){
        barcode="<cfoutput>#get_barcode_no()#</cfoutput>";
        barcode=barcode+row_count;
        $("#add_assetp #qr_code" + row_count).val(barcode);
    }
	function sil(sy)
	{
		var element=eval("add_assetp.row_kontrol"+sy);
		element.value=0;
		var element=eval("frm_row"+sy); 
		element.style.display="none";	
	} 
    function kontrol_(){
        loadPopupBox('add_assetp','<cfoutput>#attributes.modal_id#</cfoutput>');
        return false;
    }
</script>