<!---
File: upd_assurance_type_medication.cfm
Author: Workcube-Melek KOCABEY <melekkocabey@workcube.com>
Date: 25.11.2019
Controller: AssuranceTypesController.cfm
Description: Sağlık Teminatı Tipi güncelleme sayfası İlaç ve Malzemeler tabıdır.
--->
<div id="item-med" class="item-med col col-9 col-md-9 col-sm-9 col-xs-12">
    <cf_grid_list>
        <thead>
            <th style="text-align:center;width:25px;"><input type="button" class="eklebuton" title="" onClick="add_row_medication('products_services')" value=""></th>
            <th><cf_get_lang dictionary_id = "55884.İlaç">-<cf_get_lang dictionary_id = "32045.Malzeme"></th>
            <th><cf_get_lang dictionary_id = "41374.Periyot"></th>
            <th>(Max)</th>
            <th><cf_get_lang dictionary_id = "59996.Ödeme Limiti"></th>
            <th><cf_get_lang dictionary_id = "58456.Oran">%</th>
            <th><cf_get_lang dictionary_id = "57467.Not"></th>
                <th><cfoutput>#Left(getLang('main',672,'fiyat'),1)##Left(getLang('invoice',199,'Kontrol'),1)#</cfoutput></th>
        </thead>
        <cfset medicine_count = 0>
        <tbody id="med">
            <cfif get_assurance_medication.recordcount>
                <cfset medicine_count = get_assurance_medication.recordcount>
                <cfset record_count_cf = get_assurance_medication.recordcount>
                <cfoutput query = "get_assurance_medication">
                    <tr id ="row_#currentrow#">
                        <td class="text-center"><a style="cursor:pointer" onclick="del_row_medications('#currentrow#',#medication_id#);" ><i class="fa fa-minus"></i></a></td>
                        <td>
                            <div class="form-group" >  
                                <div class="input-group">
                                    <input type="hidden" name="medication_id_#currentrow#" id="medication_id_#currentrow#" value="#DRUG_ID#">
                                    <input type="text" name="medication_#currentrow#" id="medication_#currentrow#" value="#DRUG_MEDICINE#" class="boxtext" onfocus="AutoComplete_Create('medication_#currentrow#','DRUG_ID','DRUG_MEDICINE','Get_SetupMedicineDrug','','DRUG_ID,DRUG_MEDICINE','medication_id_#currentrow#,treatment_#currentrow#');">
                                    <span class="input-group-addon icon-ellipsis" onClick="openBoxDraggable('#request.self#?fuseaction=objects.popup_list_decision_medicines&medicine_id=1&field_id=medication_id_#currentrow#&field_name=medication_#currentrow#');"></span>                      
                                </div>
                            </div>
                        </td>
                        <td>
                            <select id = "period_med_#currentrow#" name = "period_med_#currentrow#" class="boxtext">
                                <option value = "1" <cfif period eq 1>selected</cfif>><cf_get_lang dictionary_id = '57490.Gün'></option>
                                <option value = "2" <cfif period eq 2>selected</cfif>><cf_get_lang dictionary_id = '58724.Ay'></option>
                                <option value = "3" <cfif period eq 3>selected</cfif>><cf_get_lang dictionary_id = '58734.Hafta'></option>
                                <option value = "4" <cfif period eq 4>selected</cfif>>3 <cf_get_lang dictionary_id = '58724.Ay'></option>
                                <option value = "5" <cfif period eq 5>selected</cfif>>6 <cf_get_lang dictionary_id = '58724.Ay'></option>
                                <option value = "6" <cfif period eq 6>selected</cfif>><cf_get_lang dictionary_id = '58455.Yıl'></option>
                                <option value = "7" <cfif period eq 7>selected</cfif>>2 <cf_get_lang dictionary_id = '58455.Yıl'></option>
                                <option value = "8" <cfif period eq 8>selected</cfif>>3 <cf_get_lang dictionary_id = '58455.Yıl'></option>
                                <option value = "9" <cfif period eq 9>selected</cfif>>4 <cf_get_lang dictionary_id = '58455.Yıl'></option>
                                <option value = "10" <cfif period eq 10>selected</cfif>>5 <cf_get_lang dictionary_id = '58455.Yıl'></option>
                            </select>
                        </td>
                        <td><input type="text" name="max_med_#currentrow#" id="max_med_#currentrow#" value="#max#" class="box"></td>
                        <td><input type="text" name="money_limit_drug_#currentrow#" id="money_limit_drug_#currentrow#" value="#tlformat(money_limit,2)#" onKeyup="return(FormatCurrency(this,event,3));" onchange="fieldCommaSplit(this)" class="box"></td>
                        <td><input type="text" name="payment_rate_#currentrow#" id="payment_rate_#currentrow#" value="#TLFormat(payment_rate)#" class="box" onKeyup="return(FormatCurrency(this,event,3));" onchange="fieldCommaSplit(this)"></td>
                        <td><input type="text" name="note_med_#currentrow#" id="note_med_#currentrow#" value="#note#" class="boxtext"></td>
                        <td nowrap style="text-align:center;">
                            <a href="javascript://" onclick="upd_row_medications(#currentrow#,#medication_id#)"><i class="fa fa-refresh"></i></a><div id = "update_div_medic_#currentrow#"></div>
                        </td>
                    </tr>
                </cfoutput>                            
            </cfif>
        </tbody>
    </cf_grid_list>
</div>
<script>
medicine_count = '<cfoutput>#medicine_count#</cfoutput>';
function select_medication(no) 
    {
    openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_decision_medicines&medicine_id=1&field_id=medication_id_' + no +'&field_name=medication_' + no);
    }
    function add_row_medication(gelen_medication_id) 
    {
        medicine_count++;
        var newRow;
        newRow = document.getElementById("med").insertRow(document.getElementById("med").rows.length);	
        newRow.setAttribute("name","" + medicine_count);
        newRow.setAttribute("id","row_" + medicine_count);
        
        newCell = newRow.insertCell(newRow.cells.length);
        newCell.innerHTML = '<a style="cursor:pointer" onclick="del_row(' + medicine_count + ');"><i class="fa fa-minus"></i></a>';

        newCell = newRow.insertCell(newRow.cells.length);
        newCell.innerHTML = '<div class="form-group"><div class="input-group"><input type="hidden" name="medication_id_' + medicine_count + '" id="medication_id_' + medicine_count + '"><input type="text" name="medication_' + medicine_count + '" id="medication_' + medicine_count + '" class="boxtext" onFocus="auto_medicines('+ medicine_count +');"><span class="input-group-addon icon-ellipsis"  onClick="select_medication('+ medicine_count +');"></span></div><div>';
 
        newCell = newRow.insertCell(newRow.cells.length);
        newCell.innerHTML ='<select name="period_med_' + medicine_count + '" id="period_med_' + medicine_count + '" class="boxtext"> <option value = "1" ><cf_get_lang dictionary_id = '57490.Gün'></option><option value = "2" ><cf_get_lang dictionary_id = '58724.Ay'></option><option value = "3" ><cf_get_lang dictionary_id = '58734.Hafta'></option><option value = "4" >3<cf_get_lang dictionary_id = '58724.Ay'></option><option value = "5" >6<cf_get_lang dictionary_id = '58724.Ay'></option><option value = "6" ><cf_get_lang dictionary_id = '58455.Yıl'></option><option value = "7" >2<cf_get_lang dictionary_id = '58455.Yıl'></option><option value = "8" >3<cf_get_lang dictionary_id = '58455.Yıl'></option><option value = "9" >4<cf_get_lang dictionary_id = '58455.Yıl'></option><option value = "10" >5<cf_get_lang dictionary_id = '58455.Yıl'></option></select>';

        newCell = newRow.insertCell(newRow.cells.length);
        newCell.innerHTML = '<input type="text" name="max_med_' + medicine_count +'" id="max_med_' + medicine_count +'" value="" class="box">';
        
        newCell = newRow.insertCell(newRow.cells.length);
        newCell.innerHTML = '<input type="text" name="money_limit_drug_' + medicine_count +'" id="money_limit_drug_' + medicine_count +'" class="box" value="<cfoutput>#TLFormat(0)#</cfoutput>" onKeyup="return(FormatCurrency(this,event,3));" onchange="fieldCommaSplit(this)">';

        newCell = newRow.insertCell(newRow.cells.length);
        newCell.innerHTML = '<input type="text" name="payment_rate_' + medicine_count +'" id="payment_rate_' + medicine_count +'" class="box" value="" onKeyup="return(FormatCurrency(this,event,3));" onchange="fieldCommaSplit(this)">';

        newCell = newRow.insertCell(newRow.cells.length);
        newCell.innerHTML = '<input type="text" name="note_med_' + medicine_count +'" id="note_med_' + medicine_count +'" value="" class="boxtext">';
        
        newCell = newRow.insertCell(newRow.cells.length);
        newCell.innerHTML = '<a href="javascript://" onclick= "save_medication('+medicine_count+')" id = "submit_'+medicine_count+'"><i class="fa fa-check" id = "check_icon_'+medicine_count+'"></i></a><div id ="add_text_medicine'+medicine_count+'"></div>';
        newCell.setAttribute("style","text-align:center");
    }
    function save_medication(row_num) 
    {
        drug_id = document.getElementById("medication_id_" + row_num).value;
        medication = document.getElementById("medication_" + row_num).value;//ilaç
        max_med = document.getElementById("max_med_" + row_num).value;//maximum
        period_med = document.getElementById("period_med_" + row_num).value;//periyot
        note_med = document.getElementById("note_med_" + row_num).value;//not
        payment_rate = filterNum(document.getElementById("payment_rate_" + row_num).value);//ödeme oranı
        assurance_id = '<cfoutput>#attributes.assurance_id#</cfoutput>';
        money_limit_drug = filterNum(document.getElementById("money_limit_drug_" + row_num).value);//money
        $.ajax({ 
            type:'POST',  
            url:'V16/hr/cfc/assurance_type.cfc?method=ADD_HEALTH_ASSURANCE_TYPE_MEDICATION',  
            data: { 
                medication : medication,
                assurance_id : assurance_id,
                period_med : period_med,
                max_med : max_med,
                note_med : note_med,
                payment_rate : payment_rate,
                money_limit_drug : money_limit_drug,
                drug_id : drug_id
            },
            success: function (returnData) {
                document.getElementById("add_text_medicine"+row_num).innerHTML = "<b><cfoutput>#getLang('objects',1338,'eklendi')#</cfoutput></b>";
                return false;
            },
            error: function () 
            {
                console.log('CODE:8 please, try again..');
                return false; 
            }
        }); 
    }
    function upd_row_medications(row_num,medication_id)
    {
        drug_id = document.getElementById("medication_id_" + row_num).value;
        medication = document.getElementById("medication_" + row_num).value;//ilaç
        max_med = document.getElementById("max_med_" + row_num).value;//maximum
        period_med = document.getElementById("period_med_" + row_num).value;//periyot
        note_med = document.getElementById("note_med_" + row_num).value;//not
        payment_rate = filterNum(document.getElementById("payment_rate_" + row_num).value);//ödeme oranı
        assurance_id = '<cfoutput>#attributes.assurance_id#</cfoutput>';
        money_limit_drug = filterNum(document.getElementById("money_limit_drug_" + row_num).value);//money
        $.ajax({ 
            type:'POST',  
            url:'V16/hr/cfc/assurance_type.cfc?method=UPD_HEALTH_ASSURANCE_TYPE_MEDICATION',  
            data: { 
                medication : medication,
                assurance_id : assurance_id,
                period_med : period_med,
                max_med : max_med,
                medication_id : medication_id,
                note_med : note_med,
                payment_rate : payment_rate,
                money_limit_drug : money_limit_drug,
                drug_id : drug_id
            },
            success: function (returnData) {
                document.getElementById("update_div_medic_"+row_num).innerHTML = "<b>Güncellendi</b>";
                return false;
            },
            error: function () 
            {
                console.log('CODE:8 please, try again..');
                return false; 
            }
        }); 
    }
    function del_row_medications(medicine_count,medication_id)//Satır silme fonksiyonu
    {
        var my_medicine=eval("row_"+medicine_count);
        if(confirm ("<cf_get_lang dictionary_id = '36628.Satırı silmek istediğinize emin misiniz?'> ? "))
        {
            if(medication_id != undefined)
            {
                $.ajax({ 
                    type:'POST',  
                    url:'V16/hr/cfc/assurance_type.cfc?method=DEL_HEALTH_ASSURANCE_TYPE_MEDICATION',  
                    data: { 
                        medication_id : medication_id
                    },
                    success: function (returnData) {
                        alertObject({type: 'success',message: 'kayıt silindi..', closeTime: 5000});
		                my_medicine.style.display="none";
                    },
                    error: function () 
                    {
                        console.log('CODE:8 please, try again..');
                        return false; 
                    }
                }); 
            }
            $( "[medication_id = 'row_"+medicine_count+"']" ).each(function( index ) {
                $( this ).remove();
            });
        }else return false;
    }
    function auto_medicines(no)
        {
            AutoComplete_Create('medication_' + medicine_count +'','DRUG_ID','DRUG_MEDICINE','Get_SetupMedicineDrug','','DRUG_ID,DRUG_MEDICINE','medication_id_' + medicine_count +',medication_' + medicine_count +'');
        }
</script>