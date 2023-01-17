<cf_xml_page_edit fuseact="objects.popup_form_add_target">
<cfquery name="GET_MONEY" datasource="#dsn#">
	SELECT MONEY, RATE1, RATE2 FROM SETUP_MONEY WHERE PERIOD_ID = #SESSION.EP.PERIOD_ID# AND MONEY_STATUS = 1
</cfquery>
<cfparam name="attributes.startdate" default="">
<cfparam name="attributes.finishdate" default="">
<cf_catalystHeader>
<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
    <cf_box title="#getLang('','Hedefler',57964)#" closable="0">
        <cfform name="add_target" id="add_target" method="post" action="#request.self#?fuseaction=objects.emptypopup_add_target" >
            <input type="hidden" name="fbx" id="fbx" value="<cfif isdefined('attributes.fbx')><cfoutput>#attributes.fbx#</cfoutput></cfif>">
            <input type="hidden" name="emp_id" id="emp_id" value="<cfif isdefined('attributes.emp_id')><cfoutput>#attributes.emp_id#</cfoutput></cfif>">
            <input type="hidden" name="record_emp" id="record_emp" value="<cfoutput>#session.ep.userid#</cfoutput>">
            <input type="hidden" name="record_ip" id="record_ip" value="<cfoutput>#cgi.remote_addr#</cfoutput>">
            <input type="hidden" name="counter" id="counter" value="">
            <input type="hidden" name="xml_is_show_add_info_input" id="xml_is_show_add_info_input" value="<cfoutput>#xml_is_show_add_info#</cfoutput>" />
            <cfif isdefined('attributes.per_id')>
                <input type="hidden" name="per_id" id="per_id" value="<cfoutput>#attributes.per_id#</cfoutput>">
            </cfif>
            <cf_box_elements>
                <div class="col col-6 col-md-6 col-sm-6 col-xs-12" type="column" index="1" sort="true">
                    <div class="form-group" id="item-startdate"  >
                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='58053.Başlangıç Tarihi'>*</label>
                        <div class="col col-6 col-md-6 col-sm-6 col-xs-12">
                            <div class="input-group">
                                <cfinput type="text" name="startdate" maxlength="10" validate="#validate_style#" required="yes" message="#getLang('','Başlangıç Tarihi Girmelisiniz',57738)#" value="#attributes.startdate#">
                                <span class="input-group-addon"><cf_wrk_date_image date_field="startdate"></span>
                            </div>
                        </div>
                    </div>
                    <div class="form-group" id="item-finishdate">
                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57700.Bitiş'>*</label>
                        <div class="col col-6 col-md-6 col-sm-6 col-xs-12">
                            <div class="input-group">
                                <cfinput type="text" name="finishdate" maxlength="10" validate="#validate_style#" required="yes" message="#getLang('','Bitiş Tarihi Giriniz',58491)# !" value="#attributes.finishdate#">
                                <span class="input-group-addon"><cf_wrk_date_image date_field="finishdate"></span>
                            </div>
                        </div>
                    </div>
                    <div class="form-group" id="item-targetcat_id">
                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57486.Kategori'>*</label>
                        <div class="col col-6 col-md-6 col-sm-6 col-xs-12">
                            <select name="targetcat_id" id="targetcat_id">
                                <cfinclude template="../query/get_target_cats.cfm">
                                <option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
                                <cfoutput query="get_target_cats">
                                    <option value="#targetcat_id#">#targetcat_name#</option>
                                </cfoutput>
                            </select>
                        </div>
                    </div>
                     
                    <cfif xml_is_show_add_info eq 1>
                        <div class="form-group" id="item-target_number">
                            <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='33533.Rakam'></label>
                            <div class="col col-2 col-xs-12">
                                <input type="text" name="target_number" id="target_number" class="moneybox" value="" validate="float" onkeyup="return(FormatCurrency(this,event));">
                            </div>
                            <div class="col col-4 col-xs-12">
                                <select name="calculation_type" id="calculation_type">
                                    <option value="1"> + (<cf_get_lang dictionary_id='33534.Artış Hedefi'>)</option>
                                    <option value="2"> - (<cf_get_lang dictionary_id='33535.Düşüş Hedefi'>)</option>
                                    <option value="3"> +% (<cf_get_lang dictionary_id='33537.Yüzde Artış Hedefi'>)</option>
                                    <option value="4"> -% (<cf_get_lang dictionary_id='33536.Yüzde Düşüş Hedefi'>)</option>
                                    <option value="5"> = (<cf_get_lang dictionary_id='33541.Hedeflenen Rakam'>)</option>
                                </select>
                            </div>
                        </div>
                    </cfif>
                    <div class="form-group" id="item-target_weight">
                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='29784.Ağırlık'>*</label>
                        <div class="col col-6 col-md-6 col-sm-6 col-xs-12">
                            <input type="text" name="target_weight" id="target_weight" maxlength="3" value="" class="moneybox" validate="float" onkeyup="return(FormatCurrency(this,event));">
                        </div>
                    </div>
                    <cfif xml_is_show_add_info eq 1>
                        <div class="form-group" id="item-suggested_budget">
                            <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='33538.Ayrılan Bütçe'></label>
                            <div class="col col-6 col-md-6 col-sm-6 col-xs-12">
                                <div class="input-group">
                                    <cfinput type="text" name="suggested_budget" class="moneybox"  value="" validate="float" onkeyup="return(FormatCurrency(this,event));">
                                    <span class="input-group-addon width">
                                        <select name="money_type" id="money_type">
                                            <cfoutput query="get_money">
                                                <option value="#money#" <cfif get_money.money eq session.ep.money>selected</cfif>>#money#</option>
                                            </cfoutput>
                                        </select>
                                    </span>
                                </div>
                            </div>
                        </div>
                    </cfif>
                    <cfif xml_is_show_add_info eq 1>
                        <div class="form-group" id="item-other_date1">
                            <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='33691.Ara Görüşme Tarihi 1'></label>
                            <div class="col col-6 col-md-6 col-sm-6 col-xs-12">
                                <div class="input-group">
                                    <cfsavecontent variable="messaget"><cf_get_lang dictionary_id ='58492.Tarihi Kontrol Ediniz'></cfsavecontent>
                                    <cfinput type="text" name="other_date1" validate="#validate_style#" value="" maxlength="10" message="#messaget#">
                                    <span class="input-group-addon"><cf_wrk_date_image date_field="other_date1"></span>
                                </div>
                            </div>
                        </div>
                        <div class="form-group" id="item-other_date2">
                            <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='33692.Ara Görüşme Tarihi 2'></label>
                            <div class="col col-6 col-md-6 col-sm-6 col-xs-12">
                                <div class="input-group">
                                    <cfinput type="text" name="other_date2" validate="#validate_style#" value="" maxlength="10" message="#messaget#">
                                    <span class="input-group-addon"><cf_wrk_date_image date_field="other_date2"></span>
                                </div>
                            </div>
                        </div>
                    </cfif>
                    <div class="form-group" id="item-target_head">
                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57951.Hedef'>*</label>
                        <div class="col col-6 col-md-6 col-sm-6 col-xs-12">
                            <textarea name="target_head" id="target_head" style="width:140px;height:45px;" maxlength="300"></textarea>
                        </div>
                    </div>
                    <div class="form-group" id="item-target_emp">
                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='33540.Hedef Veren'></label>
                        <div class="col col-6 col-md-6 col-sm-6 col-xs-12">
                            <cfif not isdefined('attributes.fbx') or attributes.fbx neq 'myhome'>
                                <div class="input-group">
                            </cfif>
                                <input type="hidden" name="target_emp_id" id="target_emp_id"  value="<cfoutput>#session.ep.userid#</cfoutput>">
                                <input type="text" name="target_emp" id="target_emp" value="<cfoutput>#get_emp_info(session.ep.userid,0,0)#</cfoutput>" readonly>
                                <cfif not isdefined('attributes.fbx') or attributes.fbx neq 'myhome'>
                                    <span class="input-group-addon icon-ellipsis" onClick="openBoxDraggable('<cfoutput>#request.self#?fuseaction=objects.popup_list_positions&select_list=1&field_name=add_target.target_emp&field_emp_id2=add_target.target_emp_id</cfoutput>');" title="<cf_get_lang dictionary_id='32436.Markalar'>"></span>
                                </cfif>
                            <cfif not isdefined('attributes.fbx') or attributes.fbx neq 'myhome'>
                                </div>
                            </cfif>
                        </div>
                    </div>
                    <div class="form-group" id="item-target_detail">
                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57629.Açıklama'></label>
                        <div class="col col-6 col-md-6 col-sm-6 col-xs-12">
                            <textarea name="target_detail" id="target_detail" style="width:140px;height:45px;"></textarea>
                            <input type="hidden" name="record_num" id="record_num" value="">
                        </div>
                    </div>
                    
                    <cfif isDefined("attributes.position_code")>
                        <cfinclude template="../query/get_position.cfm">
                        <input type="hidden" name="position_code" id="position_code" value="<cfoutput>#attributes.position_code#</cfoutput>">
                        <div class="form-group" id="item-target_detail">
                            <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57576.Çalışan'></label>
                            <div class="col col-6 col-md-6 col-sm-6 col-xs-12">
                                <cfoutput>#get_position.employee_name# #get_position.employee_surname#</cfoutput>
                                <cfinput type="hidden" name="emp_id" value="#get_position.employee_id#">
                            </div>
                        </div>
                    <cfelseif isDefined("attributes.employee_id")>
                        <cfinclude template="../query/get_position.cfm">
                        <input type="hidden" name="position_code" id="position_code" value="<cfoutput>#get_position.position_code#</cfoutput>">
                        <div class="form-group" id="item-target_detail">
                            <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57576.Çalışan'></label>
                            <div class="col col-6 col-md-6 col-sm-6 col-xs-12">
                                <cfoutput>#get_position.employee_name# #get_position.employee_surname#</cfoutput>
                            </div>
                        </div>
                    </cfif>
                </div>
                <div class="row">
                        <div class="col col-12">
                            <cfif not (isDefined("attributes.employee_id") or isDefined("attributes.position_code"))>
                                <cf_grid_list margin="1">
                                    <thead>
                                        <tr>
                                            <th width="20" id="add0" width="20"><a onClick="add_row();"><i class="fa fa-plus" title="<cf_get_lang dictionary_id='44630.Ekle'>" alt="<cf_get_lang dictionary_id='44630.Ekle'>"></i></a></th>
                                            <th id="employee0"><cf_get_lang dictionary_id='57576.Çalışan'>*</th>
                                            <th><cf_get_lang dictionary_id='58497.Pozisyon'></th>
                                            <th><cf_get_lang dictionary_id='57453.Şube'></th>
                                            <th width="20"></th>
                                        </tr>
                                    </thead>
                                    <tbody name="table1" id="table1"></tbody>
                                </cf_grid_list>
                            </cfif>
                        </div>
                    </div>
            </cf_box_elements>
            <cf_box_footer>
                <cf_workcube_buttons  is_upd='0' add_function='check()'>
            </cf_box_footer>
        </cfform>
    </cf_box>
</div>
<script type="text/javascript">
function check()
{	
	selected_emp=0;
	x = document.add_target.targetcat_id.selectedIndex;
	if (document.add_target.targetcat_id[x].value == "")
	{ 
		alert ("<cf_get_lang dictionary_id='58947.Lütfen Kategori Seçiniz'>!");
		return false;
	}
	
	if (add_target.target_head.value == "") 
		{
			alert("<cf_get_lang dictionary_id='33542.Hedef Girmelisiniz'>!");
			return false;
		}
	
	if (add_target.target_weight.value == "") 
		{
			alert("<cf_get_lang dictionary_id='33698.Hedef Ağırlığı Girmelisiniz'>!");
			return false;
		} 
	<cfif not (isDefined("attributes.employee_id") or isDefined("attributes.position_code"))>
		if(row_count >= 1)
		{
			for(i=1; i<=row_count; i++)
			{
				if((eval('document.getElementById("row_kontrol' + i + '").value') == 1) && (eval('document.getElementById("emp_id' + i + '").value') == ""))
					{	
						alert("<cf_get_lang dictionary_id='33737.Çalışan Ekleyiniz'>!");
						return false;
					}
				else if ((eval('document.getElementById("row_kontrol' + i + '").value') == 1) && (eval('document.getElementById("emp_id' + i + '").value') != ""))
					selected_emp++
			}
		}
		
		if (selected_emp == 0)
		{	
			alert("<cf_get_lang dictionary_id='29498.Çalışan Girmelisiniz'> !");
			return false;
		}
	</cfif>

	if ((add_target.startdate.value != "") && (add_target.finishdate.value != ""))
		if (! date_check(add_target.startdate, add_target.finishdate, "<cfoutput><cf_get_lang dictionary_id='33707.Başlangıç tarihi bitiş tarihinden küçük olmalıdır'></cfoutput>!"))
			return false;
	if (add_target.xml_is_show_add_info_input.value == 1){
		add_target.target_number.value = filterNum(add_target.target_number.value);	
		add_target.suggested_budget.value = filterNum(add_target.suggested_budget.value);
	}
	add_target.target_weight.value = filterNum(add_target.target_weight.value);
	return true;
}

function sil(sy)
	{
		var my_element=eval("add_target.row_kontrol"+sy);
		my_element.value=0;
		var my_element=eval("frm_row"+sy);
		my_element.style.display="none";	
	}

row_count=0;

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
	
	document.add_target.record_num.value=row_count;		
	newCell = newRow.insertCell(newRow.cells.length);
	newCell.innerHTML = '<a style="cursor:pointer" onclick="sil('+ row_count +');"><i class="fa fa-minus" title="<cf_get_lang dictionary_id='57463.Sil'>" alt="<cf_get_lang dictionary_id='57463.Sil'>"></i></a><input type="hidden" name="emp_id' + row_count + '" id="emp_id' + row_count + '">';
	newCell = newRow.insertCell(newRow.cells.length);
	newCell.innerHTML = '<div class="form-group"><input type="text" name="employee' + row_count + '" id="employee' + row_count + '" readonly class="formfieldright"></div>';	
	newCell = newRow.insertCell(newRow.cells.length);
	newCell.innerHTML = '<div class="form-group"><input type="text" readonly name="pos_name' + row_count + '" id="pos_name' + row_count + '" value=""></div>';
	newCell = newRow.insertCell(newRow.cells.length);
	newCell.innerHTML = '<div class="form-group"><input  type="hidden"  value="1"  name="row_kontrol' + row_count +'" id="row_kontrol' + row_count +'" ><input type="text" readonly name="branch_name' + row_count + '" value=""></div>';					
	newCell = newRow.insertCell(newRow.cells.length);
	newCell.innerHTML = '<a onclick="javascript:opage(' + row_count +');"><img src="/images/plus_thin.gif" border="0" align="absmiddle" style="cursor:pointer;"></a>';					

}
function opage(deger)
{
	if(document.add_target.fbx.value == 'myhome')
		openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_positions&select_list=1&call_function=change_upper_pos_codes()&upper_pos_code=<cfoutput>#session.ep.position_code#</cfoutput>&field_emp_id=add_target.emp_id' + deger + '&field_name=add_target.employee' + deger +'&field_branch_name=add_target.branch_name'+ deger +'&field_pos_name=add_target.pos_name' + deger);
	else
		openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_positions&select_list=1&field_emp_id=add_target.emp_id' + deger + '&field_name=add_target.employee' + deger +'&field_branch_name=add_target.branch_name'+ deger +'&field_pos_name=add_target.pos_name' + deger);
}
</script>
