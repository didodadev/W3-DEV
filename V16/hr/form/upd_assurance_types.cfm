<!---
File: upd_assurance_type.cfm
Author: Workcube-Esma Uysal <esmauysal@workcube.com>
Date: 22.11.2019
Controller: AssuranceTypesController.cfm
Description: Sağlık Teminatı Tipi güncelleme sayfasıdır..
--->
<cfset components = createObject('component','V16.hr.cfc.assurance_type')>
<cfset get_assurance = components.GET_HEALTH_ASSURANCE_TYPE(assurance_id : attributes.assurance_id)>
<cfset get_assurance_support = components.GET_HEALTH_ASSURANCE_TYPE_SUPPORT(assurance_id : attributes.assurance_id)>
<cfset get_money = components.GET_MONEY()>
<cfset get_assurance_treatments = components.GET_HEALTH_ASSURANCE_TYPE_TREATMENTS(assurance_id : attributes.assurance_id)>
<cfset get_assurance_medication = components.GET_HEALTH_ASSURANCE_TYPE_MEDICATION(assurance_id : attributes.assurance_id)>
<cfset get_assurance_limb = components.GET_HEALTH_ASSURANCE_TYPE_LIMB(assurance_id : attributes.assurance_id)>
<cfset main_assurance_types = components.GET_MAIN_ASSURANCE_TYPES(assurance_id : attributes.assurance_id) />
<cfset record_count_cf = 0>
<cfsavecontent variable = "header"><cf_get_lang dictionary_id = "34119.Sağlık Teminat Tipleri"></cfsavecontent>
<cf_box title="#header#" closable="0" add_href="#request.self#?fuseaction=health.assurance_types&event=add">
    <cfform name="assurance_type" id="assurance_type" action="" enctype="multipart/form-data" method="post">
        <cf_box_elements>
            <cfoutput>
                <div class="col col-4 col-md-6 col-xs-12" type="column" index="1" sort="true">
                    <div class="form-group" id="item-active">
                        <label class="col col-3 col-xs-12"><cf_get_lang dictionary_id = '57493.Aktif'></label>
                        <div class="col col-9 col-xs-12">
                            <input type="checkbox" name="is_active" id="is_active"<cfif get_assurance.is_active eq 1>checked</cfif>>
                        </div>
                    </div>
                    <div class="form-group" id="item-is_main_assurance_type">
                        <label class="col col-3 col-xs-12"><cf_get_lang dictionary_id = '62466.Ana Teminat'></label>
                        <div class="col col-9 col-xs-12">
                            <input type="checkbox" name="is_main" id="is_main" onclick="showHideMainTypes();" <cfif get_assurance.IS_MAIN eq 1>checked</cfif>>
                        </div>
                    </div>
                    <div class="form-group" id="item-is_requested">
                        <label class="col col-3 col-xs-12"><cf_get_lang dictionary_id = '62765.Talep Edilebilir'></label>
                        <div class="col col-9 col-xs-12">
                            <input type="checkbox" name="is_requested" id="is_requested" <cfif get_assurance.IS_REQUESTED eq 1>checked</cfif>>
                        </div>
                    </div>
                    <div class="form-group" id="item-kategori">
                        <label class="col col-3 col-xs-12">
                            <cf_get_lang dictionary_id = '58689.Teminat'>
                        </label>
                        <div class="col col-9 col-xs-12">
                            <div class="input-group">
                                <input type="text" name = "assurance" id = "assurance" value = "#get_assurance.ASSURANCE_NEW#" >
                                <span class="input-group-addon">  
                                    <cf_language_info 
                                        table_name="SETUP_HEALTH_ASSURANCE_TYPE" 
                                        column_name="ASSURANCE" 
                                        column_id_value="#attributes.assurance_id#" 
                                        maxlength="500" 
                                        datasource="#dsn#" 
                                        column_id="ASSURANCE_ID" 
                                        control_type="0"
                                        input_type="textarea"
                                        >
                                </span>
                            </div>
                        </div>
                    </div>
                    <div class="form-group" id="item-detail">
                        <label class="col col-3 col-xs-12"><cf_get_lang_main no='217.Açıklama'></label>
                        <div class="col col-9 col-xs-12"> 
                            <textarea name="detail" id="detail" style="height:60px;"><cfoutput>#get_assurance.detail#</cfoutput></textarea>
                        </div>
                    </div>
                    <div class="form-group" id="item-main_assurance_types" <cfif get_assurance.IS_MAIN eq 1>style="display:none;"</cfif>>
                        <label class="col col-3 col-xs-12"><cf_get_lang dictionary_id = '62467.Üst Teminat'></label>
                        <div class="col col-9 col-xs-12"> 
                            <select id = "main_assurance_type" name = "main_assurance_type">
                                <option value = "" ><cf_get_lang dictionary_id = '57734.Seçiniz'></option>
                                <cfloop query="main_assurance_types">
                                    <option value="#ASSURANCE_ID#" <cfif ASSURANCE_ID eq get_assurance.MAIN_ASSURANCE_TYPE_ID>selected</cfif>>#ASSURANCE#</option>
                                </cfloop>
                            </select>
                        </div>
                    </div>
                    <div class="form-group" id="item-working_type">
                        <label class="col col-3 col-xs-12"><cf_get_lang dictionary_id = '36861.Çalışma tipi'></label>
                        <div class="col col-9 col-xs-12"> 
                            <select id = "working_type" name = "working_type">
                                <option value = "1" <cfif get_assurance.working_type eq 1>selected</cfif>><cf_get_lang dictionary_id = '40460.Tutar Aralığı'></option>
                                <option value = "2" <cfif get_assurance.working_type eq 2>selected</cfif>><cf_get_lang dictionary_id = '34280.Uzuv Başına'></option>
                                <option value = "3" <cfif get_assurance.working_type eq 3>selected</cfif>><cf_get_lang dictionary_id = '41801.Tedavi Başına'></option>
                                <option value = "4" <cfif get_assurance.working_type eq 4>selected</cfif>>İlaç ve Malzeme Başına</option>
                            </select>
                        </div>
                    </div>
                    <div class="form-group" id="item-period">
                        <label class="col col-3 col-xs-12"><cf_get_lang dictionary_id = '32691.Periyot'></label>
                        <div class="col col-9 col-xs-12"> 
                            <select id = "period" name = "period">
                                <option value = "1" <cfif get_assurance.period eq 1>selected</cfif>>1 <cf_get_lang dictionary_id = '29400.Yıllık'></option>
                                <option value = "2" <cfif get_assurance.period eq 2>selected</cfif>>2 <cf_get_lang dictionary_id = '29400.Yıllık'></option>
                                <option value = "3" <cfif get_assurance.period eq 3>selected</cfif>>3 <cf_get_lang dictionary_id = '29400.Yıllık'></option>
                                <option value = "4" <cfif get_assurance.period eq 4>selected</cfif>>4 <cf_get_lang dictionary_id = '29400.Yıllık'></option>
                                <option value = "5" <cfif get_assurance.period eq 5>selected</cfif>>5 <cf_get_lang dictionary_id = '29400.Yıllık'></option>
                            </select>
                        </div>
                    </div>
                </div>
                <div class="col col-4 col-md-6 col-xs-12" type="column" index="2" sort="true">
                    <div class="form-group">&nbsp</div>
                    <div class="form-group">&nbsp</div>
                    <div class="form-group">&nbsp</div>
                    <div class="form-group" id="item-calc_formula">
                        <label class="col col-3 col-xs-12"><cf_get_lang dictionary_id = '58028.Formül'></label>
                        <div class="col col-9 col-xs-12">
                            <textarea name="calc_formula" id="calc_formula" style="height:100px;"><cfoutput>#get_assurance.calculation_formula#</cfoutput></textarea>
                        </div>
                    </div>
                </div>
            </cfoutput>
        </cf_box_elements>
        <cf_box_footer>
            <cf_record_info query_name="get_assurance">
            <cf_workcube_buttons type_format='1' is_upd='1' is_delete = '0' add_function="upd_form()">
        </cf_box_footer>
    </cfform>
</cf_box>
<cfsavecontent variable = "page1"><cf_get_lang dictionary_id = "47147.Limitler"></cfsavecontent>
<cfsavecontent variable = "page2"><cf_get_lang dictionary_id = "34925.Tedaviler"></cfsavecontent>
<cfsavecontent variable = "page3"><cf_get_lang dictionary_id = "42099.İlaç"> - <cf_get_lang dictionary_id = "37247.Malzeme"></cfsavecontent>
<cfsavecontent variable = "page4"><cf_get_lang dictionary_id = "59566.Uzuvlar"></cfsavecontent>
<cfsavecontent variable = "page5"><cf_get_lang dictionary_id = "34758.Anlaşmalı Kurumlar"></cfsavecontent>
<cf_box closable="0">
    <cf_tab divID = "sayfa_1,sayfa_2,sayfa_3,sayfa_4,sayfa_5" defaultOpen="sayfa_1" divLang = "#page1#;#page2#;#page3#;#page4#;#page5#" tabcolor = "fff">
        <div id = "unique_sayfa_1" class = "uniqueBox">
            <cfinclude  template="upd_assurance_type_limits.cfm">
        </div>
        <div id = "unique_sayfa_2" class = "uniqueBox">
            <cfinclude  template="upd_assurance_type_treatments.cfm">
        </div>
        <div id = "unique_sayfa_3" class = "uniqueBox">
            <cfinclude  template="upd_assurance_type_medication.cfm">
        </div>
        <div id = "unique_sayfa_4" class = "uniqueBox">
            <cfinclude  template="upd_assurance_type_limb.cfm"> 
        </div>
        <div id = "unique_sayfa_5" class = "uniqueBox">
            <cfinclude  template="upd_assurance_type_contracted.cfm"> 
        </div>
    </cf_tab>
</cf_box>
<script>
    row_count = '<cfoutput>#record_count_cf#</cfoutput>';
    function upd_form(){ //Güvence tipi güncelleme 
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
        assurance_id = '<cfoutput>#attributes.assurance_id#</cfoutput>';
        $.ajax({ 
            type:'POST',  
            url:'V16/hr/cfc/assurance_type.cfc?method=UPD_HEALTH_ASSURANCE_TYPE',  
            data: { 
                is_active : is_active,
                assurance : assurance,
                detail : detail,
                working_type : working_type,
                period : period,
                assurance_id : assurance_id,
                calc_formula : calc_formula,
                is_main : is_main,
                main_assurance_type_id : main_assurance_type_id,
                is_requested : is_requested
            },
            success: function (returnData) {  
                window.location.href='<cfoutput>#request.self#?fuseaction=health.assurance_types&event=upd&assurance_id=#attributes.assurance_id#</cfoutput>';
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
    function add_row_limits(gelen_id) // Satır ekleme
    {
        row_count++;
        var newRow;
        newRow = document.getElementById("limits").insertRow(document.getElementById("limits").rows.length);	
        newRow.setAttribute("name","" + row_count);
        newRow.setAttribute("id","row_" + row_count);
        
        newCell = newRow.insertCell(newRow.cells.length);
        newCell.innerHTML = '<a style="cursor:pointer" onclick="del_row(' + row_count + ');" ><img  src="images/delete_list.gif" border="0"></a>';
        <cfif get_assurance.working_type eq 4><!--- Çalışma Tipi Miktar sınırı değilse--->
            newCell = newRow.insertCell(newRow.cells.length);
            newCell.innerHTML = '<input type="text" name="quantity_' + row_count +'" id="quantity_' + row_count +'" value="" onkeyup="return(FormatCurrency(this,event));">';
        </cfif>
        newCell = newRow.insertCell(newRow.cells.length);
        newCell.innerHTML = '<input type="text" name="min_' + row_count +'" id="min_' + row_count +'" value="" class="boxtext text-right" onkeyup="return(FormatCurrency(this,event));" onchange="fieldCommaSplit(this)">';
        
        newCell = newRow.insertCell(newRow.cells.length);
        newCell.innerHTML = '<input type="text" name="max_' + row_count +'" id="max_' + row_count +'" value="" class="boxtext text-right" onkeyup="return(FormatCurrency(this,event));" onchange="fieldCommaSplit(this)">';
        
        newCell = newRow.insertCell(newRow.cells.length);
        newCell.innerHTML = '<select name="money_'+ row_count +'" id = "money_'+ row_count +'" class="boxtext"><cfoutput query="get_money"><option value="#money#" <cfif money eq session.ep.money>selected</cfif>>#money#</option></cfoutput></select>';
        
        newCell = newRow.insertCell(newRow.cells.length);
        newCell.innerHTML = '<input type="text" name="rate_' + row_count +'" id="rate_' + row_count +'" value="" class="boxtext text-right" onkeyup="return(FormatCurrency(this,event));" onchange="fieldCommaSplit(this)">';
		
		newCell = newRow.insertCell(newRow.cells.length);
        newCell.innerHTML = '<input type="text" name="private_rate_' + row_count +'" id="private_rate_' + row_count +'" value="" class="boxtext text-right" onkeyup="return(FormatCurrency(this,event));" onchange="fieldCommaSplit(this)">';
        
        newCell = newRow.insertCell(newRow.cells.length);
        newCell.setAttribute("id","effective_date_" + row_count + "_td");
        newCell.innerHTML = '<input type="text" name="effective_date_' + row_count +'" id="effective_date_' + row_count +'" class="boxtext" maxlength="10" value="" class="boxtext">';
        wrk_date_image('effective_date_' + row_count);

        newCell = newRow.insertCell(newRow.cells.length);
        newCell.innerHTML = '<input type="checkbox" name="is_active_'+ row_count +'" id="is_active_'+ row_count +'" value="1" class="boxtext">';
        
        newCell = newRow.insertCell(newRow.cells.length);
        newCell.innerHTML = '<a href="javascript://" onclick= "save_row('+row_count+')" id = "submit_'+row_count+'"><i class="fa fa-check" id = "check_icon_'+row_count+'"></i></a><div id ="add_text_limit'+row_count+'"></div>';
        newCell.setAttribute("style","text-align:center");       
    }
    function save_row(row_num)
    {
        unformat_fields(row_num);
        if(document.getElementById("is_active_" + row_num).checked ) //Yürürlülük tarihi
            is_active = 1;
        else
          is_active = 0;
        <cfif get_assurance.working_type eq 4>
            quantity = filterNum(document.getElementById("quantity_" + row_num).value);//miktar
        <cfelse>
            quantity = '';
        </cfif>
        min = document.getElementById("min_" + row_num).value;//minumum
        max = document.getElementById("max_" + row_num).value;//maximum
        money = document.getElementById("money_" + row_num).value;//para birimi
        rate = document.getElementById("rate_" + row_num).value;//oran
		private_rate = document.getElementById("private_rate_" + row_num).value;//oran
        effective_date = js_date(document.getElementById("effective_date_" + row_num).value);//Yürürlülük tarihi
        assurance_id = '<cfoutput>#attributes.assurance_id#</cfoutput>';
        $.ajax({ 
            type:'POST',  
            url:'V16/hr/cfc/assurance_type.cfc?method=ADD_HEALTH_ASSURANCE_TYPE_SUPPORT',  
            data: { 
                is_active : is_active,
                assurance_id : assurance_id,
                effective_date : effective_date,
                rate : rate,
                money : money,
                max : max,
                min : min,
                quantity : quantity,
				private_rate : private_rate
            },
            success: function (returnData) {
                document.getElementById("add_text_limit"+row_num).innerHTML = "<b><cfoutput>#getLang('objects',1338,'eklendi')#</cfoutput></b>";
            },
            error: function () 
            {
                console.log('CODE:8 please, try again..');
            }
        });
        format_fields(row_num);
        return false;
    }
    function upd_row_limits(row_num,id)
    {
        unformat_fields(row_num);
        if(document.getElementById("is_active_" + row_num).checked)//Yürürlülük tarihi
            is_active = 1;
        else
            is_active = 0;
        <cfif get_assurance.working_type eq 4>
            quantity = filterNum(document.getElementById("quantity_" + row_num).value);//miktar
        <cfelse>
            quantity = '';
        </cfif>
        min = document.getElementById("min_" + row_num).value;//minumum
        max = document.getElementById("max_" + row_num).value;//maximum
        money = document.getElementById("money_" + row_num).value;//para birimi
        rate = document.getElementById("rate_" + row_num).value;//oran
		private_rate = document.getElementById("private_rate_" + row_num).value;//oran
        effective_date= js_date(document.getElementById("effective_date_" + row_num).value);//Yürürlülük tarihi
        assurance_id = '<cfoutput>#attributes.assurance_id#</cfoutput>';
        $.ajax({ 
            type:'POST',  
            url:'V16/hr/cfc/assurance_type.cfc?method=UPD_HEALTH_ASSURANCE_TYPE_SUPPORT',  
            data: { 
                is_active : is_active,
                assurance_id : assurance_id,
                effective_date: effective_date,
                rate : rate,
                money : money,
                max : max,
                min : min,
                quantity : quantity,
                id : id,
				private_rate:private_rate
            },
            success: function (returnData) {
                document.getElementById("update_div_"+row_num).innerHTML = "<b>Güncellendi</b>";
            },
            error: function () 
            {
                console.log('CODE:8 please, try again..');
            }
        });
        format_fields(row_num);
        return false;
    }
    function del_row(row_count,id)//Satır silme fonksiyonu
    {
        if(confirm ("<cf_get_lang dictionary_id = '36628.Satırı silmek istediğinize emin misiniz?'> ? "))
        {
            if(id != undefined)
            {
                $.ajax({ 
                    type:'POST',  
                    url:'V16/hr/cfc/assurance_type.cfc?method=DEL_HEALTH_ASSURANCE_TYPE_SUPPORT',  
                    data: { 
                        id : id
                    },
                    success: function (returnData) {
                        window.location.reload();
                    },
                    error: function () 
                    {
                        console.log('CODE:8 please, try again..');
                        return false; 
                    }
                }); 
            }
            $( "[id = 'row_"+row_count+"']" ).each(function( index ) {
                $( this ).remove();
            });
        }else return false;
    }
    function fieldCommaSplit(obj)
    {
        obj.value = commaSplit(parseFloat(filterNum(obj.value)));
    }
    function unformat_fields(row_num)
    {
        $('#rate_' + row_num).val(filterNum($('#rate_' + row_num).val()));
        $('#private_rate_' + row_num).val(filterNum($('#private_rate_' + row_num).val()));
        $('#min_' + row_num).val(filterNum($('#min_' + row_num).val()));
        $('#max_' + row_num).val(filterNum($('#max_' + row_num).val()));
    }
    function format_fields(row_num)
    {
        $('#rate_' + row_num).val(commaSplit(parseFloat($('#rate_' + row_num).val())));
        $('#private_rate_' + row_num).val(commaSplit(parseFloat($('#private_rate_' + row_num).val())));
        $('#min_' + row_num).val(commaSplit(parseFloat($('#min_' + row_num).val())));
        $('#max_' + row_num).val(commaSplit(parseFloat($('#max_' + row_num).val())));
    }
    function showHideMainTypes() {
        if(document.getElementById("is_main").checked) $('#item-main_assurance_types').css('display','none');
        else $('#item-main_assurance_types').css('display','');
    }
</script>