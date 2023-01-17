
<cf_catalystHeader>
<cf_box>
    <cfform name="add_form">
        <cf_box_elements>
            <div class="col col-5 col-md-4 col-sm-6 col-xs-12" type="column" index="1" sort="true">
                <cf_duxi name="process_stage" label="58859" hint="süreç" required="yes">
                    <cf_workcube_process is_upd='0' is_detail='0'>
                </cf_duxi>   
                <div class="form-group" id="item-form_type">
                    <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id ='56000.Form Tipi'> *</label>
                    <div class="col col-8 col-xs-12">
                        <label><input type="checkbox" name="rise" id="rise" value="1"><cf_get_lang dictionary_id ='58567.Terfi'></label>
                        <label><input type="checkbox" name="transfer" id="transfer" value="1"><cf_get_lang dictionary_id ='58568.Transfer'></label>
                        <label><input type="checkbox" name="rotation" id="rotation" value="1"><cf_get_lang dictionary_id ='58569.Rotasyon'></label>
                        <label><input type="checkbox" name="salary_change" id="salary_change" value="1"><cf_get_lang dictionary_id ='58570.Ücret Değişikliği'></label>
                    </div>
                </div>
                <cf_duxi name="form_head" type="text" label="58820" hint="Başlık" required="yes"> 
                <cf_seperator id="current" title="#getLang('','Mevcut*','58571')#">
                <div id="current"> 
                    <cf_duxi name="headquarters_exist_id" type="hidden" value="">  
                    <cf_duxi name="headquarters_exist" type="text" value="" label="56098" hint="Grup Başkanlığı" readonly>
                    <cf_duxi name="company_exist_id" type="hidden" value="">  
                    <cf_duxi name="company_exist" type="text" value="" label="57574" hint="Sirket">
                    <cf_duxi name="branch_exist_id" type="hidden" value="" readonly>  
                    <cf_duxi name="branch_exist" type="text" value="" label="57453" hint="Şube" readonly>
                    <cf_duxi name="department_exist_id" type="hidden" value="">  
                    <cf_duxi name="department_exist" type="text" value="" label="57572" hint="Departman" readonly>
                    <cf_duxi name="pos_exist" type="text" value="" label="57571" hint="Unvan" readonly>
                    <cf_duxi name="pos_code" type="hidden" value="">
                    <cf_duxi name="emp_id" type="hidden" value="">  
                    <cf_duxi name="emp_name" type="text" value="" threepoint="#request.self#?fuseaction=hr.popup_list_positions_all&field_pos_name=add_form.pos_exist&field_code=add_form.pos_code&field_emp_name=add_form.emp_name&field_emp_id=add_form.emp_id&field_dep_name=add_form.department_exist&field_dep_id=add_form.department_exist_id&field_branch_name=add_form.branch_exist&field_branch_id=add_form.branch_exist_id&field_comp=add_form.company_exist&field_comp_id=add_form.company_exist_id&field_head_id=add_form.headquarters_exist_id&field_head=add_form.headquarters_exist&show_empty_pos=0" label="32370" hint="Adı Soyadı">
                    <cf_duxi name="salary_exist" type="text" data_control="money" currencyname="salary_exist_money" currencyvalue="data_get_money.money" value="" label="55123" hint="Ücret">
                </div>
                <cf_seperator id="req" title="#getLang('','Talep Edilen*','56535')#">
                <div id="req">
                    <cf_duxi name="headquarters_request_id" type="hidden" value=""> 
                    <cf_duxi name="headquarters_request" type="text" value="" label="56098" hint="Grup Başkanlığı" readonly>
                    <cf_duxi name="company_request_id" type="hidden" value="">  
                    <cf_duxi name="company_request" type="text" value="" label="57574" hint="Sirket" readonly>
                    <cf_duxi name="branch_request_id" type="hidden" value="">  
                    <cf_duxi name="branch_request" type="text" value="" label="57453" hint="Şube" readonly>
                    <cf_duxi name="department_request_id" type="hidden" value="">  
                    <cf_duxi name="department_request" type="text" value="" label="57572" hint="Departman" readonly>
                    <cf_duxi name="pos_request_id" type="hidden" value="">  
                    <cf_duxi name="pos_request" type="text" value="" label="57571" hint="Unvan" readonly>
                    <cf_duxi name="emp_id_req" type="hidden">  
                    <cf_duxi name="emp_name_req" type="text"  value="" threepoint="#request.self#?fuseaction=hr.popup_list_positions_all&field_code=add_form.pos_request_id&field_pos_name=add_form.pos_request&field_emp_name=add_form.emp_name_req&field_emp_id=add_form.emp_id_req&field_dep_name=add_form.department_request&field_dep_id=add_form.department_request_id&field_branch_name=add_form.branch_request&field_branch_id=add_form.branch_request_id&field_comp=add_form.company_request&field_comp_id=add_form.company_request_id&field_head_id=add_form.headquarters_request_id&field_head=add_form.headquarters_request" label="32370" hint="Adı Soyadı">
                    <cf_duxi name="salary_request" type="text" data_control="money" currencyname="salary_request_money" currencyvalue="data_get_money.money" value="" label="55123" hint="Ücret">
                </div>
                <cf_seperator id="pers_right" title="#getLang('','Özlük Hakları','56536')#">
                <div id="pers_right">
                    <cf_duxi name="tool_exist" type="text" value="" label="58480" hint="Araç">
                    <cf_duxi name="tel_exist" type="text" value="" label="57499" hint="Telefon">
                    <cf_duxi name="other_exist" type="text" value="" label="58156" hint="Diğer">
                    <cf_duxi name="move_amount" type="text" value="" data_control="money" currencyname="move_amount_money" onKeyup='return(FormatCurrency(this,event));' currencyvalue="data_get_money.money" label="56537" hint="Taşınma Yardım Tutarı">
                    <cf_duxi name="move_date" type="text" data_control="date"  hint="Tahmini Taşınma Tarihi" label="56539" value="">  
                </div>
                <cf_duxi name="tool_request" type="text" value="" label="58480" hint="Araç">
                <cf_duxi name="tel_request" type="text" value="" label="57499" hint="Telefon" >
                <cf_duxi name="other_request" type="text" value="" label="58156" hint="Diğer">
                <cf_duxi name="new_start_date" type="text" data_control="date"  hint="Yeni Göreve Başlama Tarihi" label="56538">  
                <cf_duxi name="rotation_finish_date" type="text" data_control="date"  hint="Rotasyon İse Tamamlanma Tarihi" label="56540">  
                <cf_duxi name="detail" type="text" label="57629" hint="Açıklama" >
            </div>
        </cf_box_elements>
        <cf_box_footer>
            <cf_workcube_buttons
            is_upd='0'
            add_function='kontrol()'
            data_action ="/V16/hr/cfc/personal_rotation:add_per_rot_form"
            next_page="#request.self#?fuseaction=hr.list_personel_rotation_form&event=upd&per_rot_id=">
        </cf_box_footer>
    </cfform>
</cf_box>
<script type="text/javascript">
function kontrol()
{
if(document.getElementById('rise').checked==false && document.getElementById('transfer').checked==false && document.getElementById('rotation').checked==false && document.getElementById('salary_change').checked==false)
{
	alert("<cf_get_lang dictionary_id='55612.Terfi,Transfer,Rotasyon ve Ücret Değişikliği Seçeneklerinden Birini Seçmelisiniz'>!");
	return false;
}
if(document.getElementById('emp_name').value.length==0 || document.getElementById('pos_code').value.length==0)
{
	alert("<cf_get_lang dictionary_id='56547.Mevcut kadroya bir çalışan seçmelisiniz'>!");
	return false;
}
if(document.getElementById('pos_request').value.length==0 || document.getElementById('pos_request_id').value.length==0)
{
	alert("<cf_get_lang dictionary_id='56548.Talep edilen unvanı seçmelisiniz'>!");
	return false;
}
if(document.getElementById('rotation').checked && document.getElementById('rotation_finish_date').value.length==0)
{
	alert("<cf_get_lang dictionary_id='55613.Rotasyon tarihini girmelisiniz'>!");
	return false;
}
	document.getElementById('salary_exist').value = filterNum(document.getElementById('salary_exist').value);
	document.getElementById('salary_request').value = filterNum(document.getElementById('salary_request').value);
	document.getElementById('move_amount').value = filterNum(document.getElementById('move_amount').value);

	return process_cat_control();
}
</script>
