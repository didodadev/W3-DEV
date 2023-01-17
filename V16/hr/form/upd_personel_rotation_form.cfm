<!--- Bu sayfanın nerde ise aynısı myhome da var burda yapılan değişiklik ordada yapılsın--->
<cf_catalystHeader>
<cf_box>
    <cf_box_data asname="data_get_money" function="V16.hr.cfc.personal_rotation:get_money">
    <cfset attributes.yil=0>
    <cfset attributes.ay=0>
    <cfset attributes.gun=0>
    <cfscript>//çalıştığı süre hesabı
        
        if (len(data_personal_rotation.group_startdate))
        {
            attributes.gun=datediff('d',data_personal_rotation.group_startdate,now());
            attributes.yil=attributes.gun\365;
            if (attributes.gun mod 365 neq 0)
            {
                attributes.gun=attributes.gun-attributes.yil*365;
                attributes.ay=attributes.gun\30;
                if (attributes.gun mod 30 neq 0)
                attributes.gun=attributes.gun-attributes.ay*30;
                else
                attributes.gun=0;
            }else
            {
                attributes.gun=0;
                attributes.ay=0;
            }
        }
        attributes.training_level=data_personal_rotation.last_school;
        attributes.military_status=data_personal_rotation.military_status;
    </cfscript>
    <cfform name="add_form">
        <cf_box_elements>
            <div class="col col-5 col-md-4 col-sm-6 col-xs-12" type="column" index="1" sort="true">
                <cf_duxi name="per_rot_id" type="hidden" data="attributes.per_rot_id">
                <cf_duxi name="process_stage" label="58859" hint="süreç" required="yes">
                    <cf_workcube_process is_upd='0' select_value='#data_personal_rotation.form_stage#' process_cat_width='150' is_detail='1'>
                </cf_duxi>   
                <div class="form-group" id="item-form_type">
                    <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id ='56000.Form Tipi'> *</label>
                    <div class="col col-8 col-xs-12">
                        <label><input type="checkbox" name="rise" id="rise" value="1" <cfif data_personal_rotation.is_rise>checked</cfif>><cf_get_lang dictionary_id ='58567.Terfi'></label>
                        <label><input type="checkbox" name="transfer" id="transfer" value="1" <cfif data_personal_rotation.is_transfer>checked</cfif>><cf_get_lang dictionary_id ='58568.Transfer'></label>
                        <label><input type="checkbox" name="rotation" id="rotation" value="1" <cfif data_personal_rotation.is_rotation>checked</cfif>><cf_get_lang dictionary_id ='58569.Rotasyon'></label>
                        <label><input type="checkbox" name="salary_change" id="salary_change" value="1" <cfif data_personal_rotation.is_salary_change>checked</cfif>><cf_get_lang dictionary_id ='58570.Ücret Değişikliği'></label>
                    </div>
                </div>
                <cf_duxi name="form_head" type="text" data="data_personal_rotation.rotation_form_head"  label="58820" hint="Başlık" required="yes">  
                <cf_seperator id="current" title="#getLang('','Mevcut*','58571')#">
                <div id="current">
                    <cf_duxi name="headquarters_exist_id" type="hidden" data="data_personal_rotation.H_ID">  
                    <cf_duxi name="headquarters_exist" type="text" data="data_personal_rotation.hname" label="56098" hint="Grup Başkanlığı" readonly>
                    <cf_duxi name="company_exist_id" type="hidden" data="data_personal_rotation.COM_ID">  
                    <cf_duxi name="company_exist" type="text" data="data_personal_rotation.nick" label="57574" hint="Sirket">
                    <cf_duxi name="branch_exist_id" type="hidden" data="data_personal_rotation.BRANCH_ID_1" readonly>  
                    <cf_duxi name="branch_exist" type="text" data="data_personal_rotation.BRANCH_1" label="57453" hint="Şube" readonly>
                    <cf_duxi name="department_exist_id" type="hidden" data="data_personal_rotation.DEP_ID">  
                    <cf_duxi name="department_exist" type="text" data="data_personal_rotation.DEP" label="57572" hint="Departman" readonly>
                    <cf_duxi name="pos_exist" type="text" data="data_personal_rotation.POSNAME" label="57571" hint="Unvan" readonly>
                    <cf_duxi name="pos_code" type="hidden" data="data_personal_rotation.pos_code_exist">  
                    <cf_duxi name="emp_id" type="hidden" data="data_personal_rotation.employee_id">  
                    <cf_duxi name="emp_name" type="text" value="#data_personal_rotation.EMPNAME# #data_personal_rotation.EMPSNAME#" threepoint="#request.self#?fuseaction=hr.popup_list_positions_all&field_pos_name=add_form.pos_exist&field_code=add_form.pos_code&field_emp_name=add_form.emp_name&field_emp_id=add_form.emp_id&field_dep_name=add_form.department_exist&field_dep_id=add_form.department_exist_id&field_branch_name=add_form.branch_exist&field_branch_id=add_form.branch_exist_id&field_comp=add_form.company_exist&field_comp_id=add_form.company_exist_id&field_head_id=add_form.headquarters_exist_id&field_head=add_form.headquarters_exist&show_empty_pos=0" label="32370" hint="Adı Soyadı">
                    <cf_duxi name="salary_exist" type="text" data_control="money" currencyname="salary_exist_money" currencyvalue="data_get_money.money" value="#TLFormat(data_personal_rotation.salary_exist)#" label="55123" hint="Ücret">
                </div>
                <cf_seperator id="req" title="#getLang('','Talep Edilen*','56535')#">
                <div id="req">
                    <cf_duxi name="headquarters_request_id" type="hidden" data="data_personal_rotation.R_ID"> 
                    <cf_duxi name="birth_place" type="hidden" data="data_personal_rotation.birth_place">
                    <cf_duxi name="member_code" type="hidden" data="data_personal_rotation.member_code">  
                    <cf_duxi name="headquarters_request" type="text" data="data_personal_rotation.RNAME" label="56098" hint="Grup Başkanlığı" readonly>
                    <cf_duxi name="company_request_id" type="hidden" data="data_personal_rotation.COMPID">  
                    <cf_duxi name="company_request" type="text" data="data_personal_rotation.COMPNAME" label="57574" hint="Sirket" readonly>
                    <cf_duxi name="branch_request_id" type="hidden" data="data_personal_rotation.BRANCH_ID_2">  
                    <cf_duxi name="branch_request" type="text" data="data_personal_rotation.BRANCH_2" label="57453" hint="Şube" readonly>
                    <cf_duxi name="department_request_id" type="hidden" data="data_personal_rotation.DEP_ID_">  
                    <cf_duxi name="department_request" type="text" data="data_personal_rotation.DEP_" label="57572" hint="Departman" readonly>
                    <cf_duxi name="pos_request_id" type="hidden" data="data_personal_rotation.pos_code_request">  
                    <cf_duxi name="pos_request" type="text" data="data_personal_rotation.POSNAME_R" label="57571" hint="Unvan" readonly>
                    <cf_duxi name="emp_id_req" type="hidden">  
                    <cf_duxi name="emp_name_req" type="text"  value="#data_personal_rotation.EMPNAME_R# #data_personal_rotation.EMPSURNAME_R#" threepoint="#request.self#</cfoutput>?fuseaction=hr.popup_list_positions_all&field_code=add_form.pos_request_id&field_pos_name=add_form.pos_request&field_emp_name=add_form.emp_name_req&field_emp_id=add_form.emp_id_req&field_dep_name=add_form.department_request&field_dep_id=add_form.department_request_id&field_branch_name=add_form.branch_request&field_branch_id=add_form.branch_request_id&field_comp=add_form.company_request&field_comp_id=add_form.company_request_id&field_head_id=add_form.headquarters_request_id&field_head=add_form.headquarters_request" label="32370" hint="Adı Soyadı">
                    <cf_duxi name="salary_request" type="text" data_control="money" currencyname="salary_request_money" currencyvalue="data_get_money.money" value="#TLFormat(data_personal_rotation.salary_request)#" label="55123" hint="Ücret">
                </div>
                <cf_seperator id="current_emp" title="#getLang('','Mevcut Çalışanın','56541')#">
                <div id="current_emp">
                    <cf_duxi name="sicil_no" type="text" data="data_personal_rotation.sicil_no" label="56542" hint="Sicil No" readonly>
                    <cf_duxi name="emp_birth_city" type="text" data="data_personal_rotation.emp_birth_city" label="57790" hint="Doğum Yeri" readonly>
                    <div class="form-group" id="item-edu_level">
                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id ='56544.Öğrenim Durumu'></label>
                        <div class="col col-8 col-xs-12">
                            <cfif len(data_personal_rotation.training_level)>
                                <cfquery name="get_edu_level" datasource="#dsn#">
                                    SELECT
                                        EDUCATION_NAME
                                    FROM
                                        SETUP_EDUCATION_LEVEL
                                    WHERE
                                        EDU_LEVEL_ID=#data_personal_rotation.training_level#
                                </cfquery>
                            </cfif>
                            <input type="text" name="training_level" id="training_level" value="<cfif isdefined("get_edu_level")><cfoutput>#get_edu_level.education_name#</cfoutput></cfif>">
                        </div>
                    </div>
                    <cf_duxi type="hidden" name="gun" data="data_personal_rotation.work_day">
                    <cf_duxi type="hidden" name="ay" data="data_personal_rotation.work_month">
                    <cf_duxi type="hidden" name="yil" data="data_personal_rotation.work_year">
                    <cf_duxi name="total_time" type="text"  value="#data_personal_rotation.work_year# Yıl - #data_personal_rotation.work_month# Ay - #data_personal_rotation.work_day# Gün" label="56546" hint="Toplam Çalıştığı Süre" readony>
                    <cfif len(data_personal_rotation.work_startdate)>
                        <cf_duxi name="start_work" type="text" data_control="date" value="#dateformat(data_personal_rotation.work_startdate,dateformat_style)#" label="56543" hint="İşe Giriş Tarihi">
                    </cfif>
                    <cfif len(data_personal_rotation.emp_birth_date)>
                        <cf_duxi name="emp_birth_date" type="text"  data_control="date" value="#dateformat(data_personal_rotation.emp_birth_date,dateformat_style)#" readonly label="58727" hint="Doğum Tarihi">
                    </cfif>
                    <cfif data_personal_rotation.military_status eq 0><cfset askerlik="Yapmadı">
                    <cfelseif data_personal_rotation.military_status eq 1><cfset askerlik="Yaptı">
                    <cfelseif data_personal_rotation.military_status eq 2><cfset askerlik="Muaf">
                    <cfelseif data_personal_rotation.military_status eq 3><cfset askerlik="Yabancı">
                    <cfelseif data_personal_rotation.military_status eq 4><cfset askerlik="Tecilli">
                    <cfelse><cfset askerlik=""></cfif>
                    <cf_duxi name="military_status_" type="text" value="#askerlik#" label="56545" hint="Askerlik Durumu" readonly>
                </div>
                <cf_seperator id="pers_right" title="#getLang('','Özlük Hakları','56536')#">
                <div id="pers_right">
                    <cf_duxi name="tool_exist" type="text" data="data_personal_rotation.tool_exist" label="58480" hint="Araç">
                    <cf_duxi name="tel_exist" type="text" data="data_personal_rotation.tel_exist" label="57499" hint="Telefon">
                    <cf_duxi name="other_exist" type="text" data="data_personal_rotation.other_exist" label="58156" hint="Diğer">
                    <cf_duxi name="move_amount" type="text" value="#TLFormat(data_personal_rotation.move_amount)#" data_control="money" currencyname="move_amount_money" onKeyup='return(FormatCurrency(this,event));' currencyvalue="data_get_money.money" label="56537" hint="Taşınma Yardım Tutarı">
                    <cf_duxi name="move_date" type="text" data_control="date"  hint="Tahmini Taşınma Tarihi" label="56539" data="data_personal_rotation.move_date">  
                </div>
                <cf_duxi name="tool_request" type="text" data="data_personal_rotation.tool_request" label="58480" hint="Araç">
                <cf_duxi name="tel_request" type="text" data="data_personal_rotation.tel_request" label="57499" hint="Telefon" >
                <cf_duxi name="other_request" type="text" data="data_personal_rotation.other_request" label="58156" hint="Diğer">
                <cf_duxi name="new_start_date" type="text" data_control="date"  hint="Yeni Göreve Başlama Tarihi" label="56538" data="data_personal_rotation.new_start_date">  
                <cf_duxi name="rotation_finish_date" type="text" data_control="date"  hint="Rotasyon İse Tamamlanma Tarihi" label="56540" data="data_personal_rotation.rotation_finish_date">  
                <cf_duxi name="detail" type="text" data="data_personal_rotation.detail" label="57629" hint="Açıklama" >
            </div>
        </cf_box_elements>
        <cf_box_footer>
            <cf_record_info query_name="data_personal_rotation">
            <cf_workcube_buttons is_upd='1'
            data_action ="/V16/hr/cfc/personal_rotation:upd_per_rot_form"
            next_page="#request.self#?fuseaction=hr.list_personel_rotation_form&event=upd&per_rot_id="
            del_action= '/V16/hr/cfc/personal_rotation:DEL:per_rot_id=#attributes.per_rot_id#'
            del_next_page="#request.self#?fuseaction=hr.list_personel_rotation_form"
            add_function='kontrol()'>
        </cf_box_footer>
    </cfform>
</cf_box>
<script type="text/javascript">
function isSayi(nesne) 
{
	inputStr=nesne.value;
	if(inputStr.length>0)
	{
		var oneChar = inputStr.substring(0,1)
		if (oneChar < "1" ||  oneChar > "9") 
		{
			nesne.focus();
		}
	}
}

function kontrol()
{
if(document.getElementById('rise').checked==false && document.getElementById('transfer').checked==false && document.getElementById('rotation').checked==false && document.getElementById('salary_change').checked==false)
{
	alert("<cf_get_lang dictionary_id ='58481.Terfi,Transfer,Rotasyon ve Ücret Değişikliği Seçeneklerinden Birini Seçmelisiniz'>!");
	return false;
}
if(document.getElementById('emp_name').value.length==0)
{
	alert("<cf_get_lang dictionary_id ='56547.Mevcut kadroya bir çalışan seçmelisiniz'>!");
	return false;
}
if(document.getElementById('pos_request').value.length==0)
{
	alert("<cf_get_lang dictionary_id ='56548.Talep edilen unvanı seçmelisiniz'>!");
	return false;
}
	document.getElementById('move_amount').value=filterNum(document.getElementById('move_amount').value);
	document.getElementById('salary_exist').value = filterNum(document.getElementById('salary_exist').value);
	document.getElementById('salary_request').value = filterNum(document.getElementById('salary_request').value);
	return process_cat_control();
}
</script>
