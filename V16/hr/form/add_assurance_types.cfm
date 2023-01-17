<!---
File: add_assurance_type.cfm
Author: Workcube-Esma Uysal <esmauysal@workcube.com>
Date: 22.11.2019
Controller: AssuranceTypesController.cfm
Description: Sağlık Teminatı Tipi ekleme sayfasıdır
--->

<cfset cmp = createObject('component','V16.hr.cfc.assurance_type')>
<cfset main_assurance_types = cmp.GET_MAIN_ASSURANCE_TYPES() />

<cfsavecontent variable = "header"><cf_get_lang dictionary_id = "34119.Sağlık Teminat Tipleri"></cfsavecontent>
<cf_box title="#header#" closable="0">
    <cfform name="assurance_type" id="assurance_type" action="" enctype="multipart/form-data" method="post">
        <cf_box_elements>
            <div class="col col-4 col-md-6 col-xs-12" type="column" index="1" sort="true">
                <div class="form-group" id="item-active">
                    <label class="col col-3 col-xs-12"><cf_get_lang dictionary_id = '57493.Aktif'></label>
                    <div class="col col-9 col-xs-12">
                        <input type="checkbox" name="is_active" id="is_active" >
                    </div>
                </div>
                <div class="form-group" id="item-is_main_assurance_type">
                    <label class="col col-3 col-xs-12"><cf_get_lang dictionary_id = '62466.Ana Teminat'></label>
                    <div class="col col-9 col-xs-12">
                        <input type="checkbox" name="is_main" id="is_main" onclick="showHideMainTypes();">
                    </div>
                </div>
                <div class="form-group" id="item-is_requested">
                    <label class="col col-3 col-xs-12"><cf_get_lang dictionary_id = '62765.Talep Edilebilir'></label>
                    <div class="col col-9 col-xs-12">
                        <input type="checkbox" name="is_requested" id="is_requested">
                    </div>
                </div>
                <div class="form-group" id="item-kategori">
                    <label class="col col-3 col-xs-12">
                        <cf_get_lang dictionary_id = '58689.Teminat'>
                    </label>
                    <div class="col col-9 col-xs-12">
                        <input type="text" name = "assurance" id = "assurance" value = "" >
                    </div>
                </div>
                <div class="form-group" id="item-detail">
                    <label class="col col-3 col-xs-12"><cf_get_lang_main no='217.Açıklama'></label>
                    <div class="col col-9 col-xs-12"> 
                        <textarea name="detail" id="detail" style="height:60px;"></textarea>
                    </div>
                </div>
                <div class="form-group" id="item-main_assurance_types">
                    <label class="col col-3 col-xs-12"><cf_get_lang dictionary_id = '62467.Üst Teminat'></label>
                    <div class="col col-9 col-xs-12"> 
                        <select id = "main_assurance_type" name = "main_assurance_type">
                            <option value = "" ><cf_get_lang dictionary_id = '57734.Seçiniz'></option>
                            <cfoutput query="main_assurance_types">
                                <option value="#ASSURANCE_ID#">#ASSURANCE#</option>
                            </cfoutput>
                        </select>
                    </div>
                </div>
                <div class="form-group" id="item-working_type">
                    <label class="col col-3 col-xs-12"><cf_get_lang dictionary_id = '36861.Çalışma tipi'></label>
                    <div class="col col-9 col-xs-12"> 
                        <select id = "working_type" name = "working_type">
                            <option value = "1" ><cf_get_lang dictionary_id = '40460.Tutar Aralığı'></option>
                            <option value = "2" ><cf_get_lang dictionary_id = '34280.Uzuv Başına'></option>
                            <option value = "3" ><cf_get_lang dictionary_id = '41801.Tedavi Başına'></option>
                            <option value = "4" >İlaç ve Malzeme Başına</option>
                        </select>
                    </div>
                </div>
                <div class="form-group" id="item-period">
                    <label class="col col-3 col-xs-12"><cf_get_lang dictionary_id = '32691.Periyot'></label>
                    <div class="col col-9 col-xs-12"> 
                        <select id = "period" name = "period">
                            <option value = "1">1<cf_get_lang dictionary_id = '29400.Yıllık'></option>
                            <option value = "2">2 <cf_get_lang dictionary_id = '29400.Yıllık'></option>
                            <option value = "3">3<cf_get_lang dictionary_id = '29400.Yıllık'></option>
                            <option value = "4">4<cf_get_lang dictionary_id = '29400.Yıllık'></option>
                            <option value = "5">5 <cf_get_lang dictionary_id = '29400.Yıllık'></option>
                        </select>
                    </div>
                </div>
            </div>
            <div class="col col-4 col-md-6 col-xs-12" type="column" index="2" sort="true">
                <div class="form-group" id="item-calc_formula">
                    <label class="col col-3 col-xs-12"><cf_get_lang dictionary_id = '58028.Formül'></label>
                    <div class="col col-9 col-xs-12">
                        <textarea name="calc_formula" id="calc_formula" style="height:100px;"></textarea>
                    </div>
                </div>
            </div>
        </cf_box_elements>
        <cf_box_footer>
            <cf_workcube_buttons type_format='1' is_upd='0'  add_function="save_form()">
        </cf_box_footer>
    </cfform>
</cf_box>
<script>
    function save_form(){
        if(document.getElementById("is_active").checked)
            is_active = 1;
        else
            is_active = 0;
        if(document.getElementById("is_main").checked){
            is_main = 1;
            main_assurance_type_id = '';
        }
        else{
            is_main = 0;
            main_assurance_type_id = document.getElementById("main_assurance_type").value;
        }
        is_requested = (document.getElementById("is_requested").checked) ? 1 : 0;
        assurance = document.getElementById("assurance").value;
        detail = document.getElementById("detail").value;
        working_type = document.getElementById("working_type").value;
        period = document.getElementById("period").value;
        calc_formula = document.getElementById("calc_formula").value;
        $.ajax({ 
            type:'POST',  
            url:'V16/hr/cfc/assurance_type.cfc?method=ADD_HEALTH_ASSURANCE_TYPE',
            data: { 
                is_active : is_active,
                assurance : assurance,
                detail : detail,
                working_type : working_type,
                period : period,
                calc_formula : calc_formula,
                is_main : is_main,
                main_assurance_type_id : main_assurance_type_id,
                is_requested : is_requested
            },
            success: function (returnData) {
                id = JSON.parse(returnData);
                window.location.href='<cfoutput>#request.self#?fuseaction=health.assurance_types&event=upd&assurance_id=</cfoutput>'+id;
                return true;
            },
            error: function () 
            {
                console.log('CODE:8 please, try again..');
                return false; 
            }
        }); 
        return false;
    }

    function showHideMainTypes() {
        if(document.getElementById("is_main").checked) $('#item-main_assurance_types').css('display','none');
        else $('#item-main_assurance_types').css('display','');
    }
</script>