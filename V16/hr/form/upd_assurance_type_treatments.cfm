<!---
File: upd_assurance_type_treatments.cfm
Author: Workcube-Melek KOCABEY <melekkocabey@workcube.com>
Date: 25.11.2019
Controller: AssuranceTypesController.cfm
Description: Sağlık Teminatı Tipi güncelleme sayfası Tedaviler tabıdır.
--->
<div id="item-treatments" class="item-treatments col col-9 col-md-9 col-sm-9 col-xs-12">
    <cf_grid_list>
        <thead>
            <th style="text-align:center;width:25px;"><input type="button" class="eklebuton" title="" onClick="add_row_treatments('products_services')" value=""></th>
            <th><cf_get_lang dictionary_id = "56623.Tedavi"></th>
            <th><cf_get_lang dictionary_id = "41374.Periyot"></th>
            <th>(Max)</th>
            <th><cf_get_lang dictionary_id = "59996.Ödeme Limiti"></th>            
            <th><cf_get_lang dictionary_id = "58456.Oran">%</th>
            <th><cf_get_lang dictionary_id = "57467.Not"></th>
            <th><cfoutput>#Left(getLang('main',672,'fiyat'),1)##Left(getLang('invoice',199,'Kontrol'),1)#</cfoutput></th>
        </thead>
        <cfset treatment_count = 0>
        <tbody id="treatments">
            <cfif get_assurance_treatments.recordcount>
                <cfset treatment_count = get_assurance_treatments.recordcount>
                <cfoutput query = "get_assurance_treatments">
                    <tr id="tr_row#currentrow#">
                        <td class="text-center"><a style="cursor:pointer" onclick="del_row_treatments('#currentrow#',#treatment_id#);" ><i class="fa fa-minus"></i></a></td>
                        <td>  
                            <div class="form-group" >  
                                <div class="input-group">
                                    <input type="hidden" name="treatment_id_#currentrow#" id="treatment_id_#currentrow#" value="#setup_complaint_id#">
                                    <input type="text" name="treatment_#currentrow#" id="treatment_#currentrow#" value="#COMPLAINT#" class="boxtext" onfocus="AutoComplete_Create('treatment_#currentrow#','COMPLAINT','COMPLAINT','GetComplaint','','COMPLAINT_ID,COMPLAINT','treatment_id_#currentrow#,treatment_#currentrow#');">
                                    <span class="input-group-addon icon-ellipsis" onclick="openBoxDraggable('#request.self#?fuseaction=objects.popup_list_complaints&field_id=treatment_id_#currentrow#' +'&field_name=treatment_#currentrow#')"></span>
                                </div>   
                            </div>
                        </td>
                        <td>
                            <select id = "period_#currentrow#" name = "period_#currentrow#" class="boxtext">
                                <option value = "1" <cfif period eq 1>selected</cfif>><cf_get_lang dictionary_id = '57490.Gün'></option>
                                <option value = "2" <cfif period eq 2>selected</cfif>><cf_get_lang dictionary_id = '58724.Ay'></option>
                                <option value = "3" <cfif period eq 3>selected</cfif>><cf_get_lang dictionary_id = '58734.Hafta'></option>
                                <option value = "4" <cfif period eq 4>selected</cfif>>3<cf_get_lang dictionary_id = '58724.Ay'></option>
                                <option value = "5" <cfif period eq 5>selected</cfif>>6<cf_get_lang dictionary_id = '58724.Ay'></option>
                                <option value = "6" <cfif period eq 6>selected</cfif>><cf_get_lang dictionary_id = '58455.Yıl'></option>
                                <option value = "7" <cfif period eq 7>selected</cfif>>2<cf_get_lang dictionary_id = '58455.Yıl'></option>
                                <option value = "8" <cfif period eq 8>selected</cfif>>3<cf_get_lang dictionary_id = '58455.Yıl'></option>
                                <option value = "9" <cfif period eq 9>selected</cfif>>4<cf_get_lang dictionary_id = '58455.Yıl'></option>
                                <option value = "10" <cfif period eq 10>selected</cfif>>5<cf_get_lang dictionary_id = '58455.Yıl'></option>
                            </select>
                        </td>
                        <td><input type="text" name="max_trea_#currentrow#" id="max_trea_#currentrow#" value="#max#" class="box"></td>
                        <td><input type="text" name="money_limit_trea_#currentrow#" id="money_limit_trea_#currentrow#" value="#tlformat(money_limit,2)#" onKeyup="return(FormatCurrency(this,event,3));" onchange="fieldCommaSplit(this)" class="box"></td>
                        <td><input type="text" name="tre_payment_rate_#currentrow#" id="tre_payment_rate_#currentrow#" value="#TLFormat(payment_rate,2)#" onKeyup="return(FormatCurrency(this,event,3));" onchange="fieldCommaSplit(this)" class="box"></td>
                        <td><input type="text" name="note_trea_#currentrow#" id="note_trea_#currentrow#" value="#note#" ></td>
                        <td nowrap style="text-align:center;">
                            <a href="javascript://" onclick="upd_row_treatments(#currentrow#,#treatment_id#)"><i class="fa fa-refresh"></i></a><div id ="update_div_trea_#currentrow#"></div>
                        </td>
                    </tr>
                </cfoutput>                            
            </cfif>
        </tbody>
    </cf_grid_list>
</div>
<script>
    treatment_count = '<cfoutput>#treatment_count#</cfoutput>';
    function select_treatment(no) {
        openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_complaints&event=popUp&field_id=treatment_id_' + no +'&field_name=treatment_' + no);
    }
    function add_row_treatments(gelen_treatment_id)
    {
        treatment_count++;
        var newRow;
        newRow = document.getElementById("treatments").insertRow(document.getElementById("treatments").rows.length);	
        newRow.setAttribute("name","" + treatment_count);
        newRow.setAttribute("id","row_" + treatment_count);
        
        newCell = newRow.insertCell(newRow.cells.length);
        newCell.innerHTML = '<a style="cursor:pointer" onclick="del_row(' + treatment_count + ');" ><img  src="images/delete_list.gif" border="0"></a>';

        newCell = newRow.insertCell(newRow.cells.length);
        newCell.innerHTML = '<div class="form-group"><div class="input-group"><input type="hidden" name="treatment_id_' + treatment_count + '" id="treatment_id_' + treatment_count + '"><input type="text" class="boxtext" name="treatment_' + treatment_count + '" id="treatment_' + treatment_count + '" onFocus="auto_treatments('+ treatment_count +');"><span class="input-group-addon icon-ellipsis"  onClick="select_treatment('+ treatment_count +');"></span></div><div>'
       
        newCell = newRow.insertCell(newRow.cells.length);
        newCell.innerHTML ='<select name="period_' + treatment_count + '" id="period_' + treatment_count + '" class="boxtext"> <option value = "1" ><cf_get_lang dictionary_id = '57490.Gün'></option><option value = "2" ><cf_get_lang dictionary_id = '58724.Ay'></option><option value = "3" ><cf_get_lang dictionary_id = '58734.Hafta'></option><option value = "4" >3<cf_get_lang dictionary_id = '58724.Ay'></option><option value = "5" >6<cf_get_lang dictionary_id = '58724.Ay'></option><option value = "6" ><cf_get_lang dictionary_id = '58455.Yıl'></option><option value = "7" >2<cf_get_lang dictionary_id = '58455.Yıl'></option><option value = "8" >3<cf_get_lang dictionary_id = '58455.Yıl'></option><option value = "9" >4<cf_get_lang dictionary_id = '58455.Yıl'></option><option value = "10" >5<cf_get_lang dictionary_id = '58455.Yıl'></option></select>';

        newCell = newRow.insertCell(newRow.cells.length);
        newCell.innerHTML = '<input type="text" name="max_trea_' + treatment_count +'" id="max_trea_' + treatment_count +'" value="" class="box">';
    
        newCell = newRow.insertCell(newRow.cells.length);
        newCell.innerHTML = '<input type="text" name="money_limit_trea_' + treatment_count +'" id="money_limit_trea_' + treatment_count +'" class="box" value="<cfoutput>#TLFormat(0)#</cfoutput>" onKeyup="return(FormatCurrency(this,event,3));" onchange="fieldCommaSplit(this)">';

        newCell = newRow.insertCell(newRow.cells.length);
        newCell.innerHTML = '<input type="text" name="tre_payment_rate_' + treatment_count +'" id="tre_payment_rate_' + treatment_count +'" class="box" value="" onKeyup="return(FormatCurrency(this,event,3));" onchange="fieldCommaSplit(this)">';

        newCell = newRow.insertCell(newRow.cells.length);
        newCell.innerHTML = '<input type="text" name="note_trea_' + treatment_count +'" id="note_trea_' + treatment_count +'" value="" class="boxtext">';

        newCell = newRow.insertCell(newRow.cells.length);
        newCell.innerHTML = '<a href="javascript://" onclick= "save_treatments('+treatment_count+')" id = "submit_'+treatment_count+'"><i class="fa fa-check" id = "check_icon_'+treatment_count+'"></i></a><div id ="add_text_'+treatment_count+'"></div>';
        newCell.setAttribute("style","text-align:center");
    }
    function save_treatments(row_num) 
    {
        treatment_id = document.getElementById("treatment_id_" + row_num).value;
        treatment = document.getElementById("treatment_" + row_num).value;//tedavi
        max_trea_ = document.getElementById("max_trea_" + row_num).value;//maximum
        period = document.getElementById("period_" + row_num).value;//periyot
        note_trea = document.getElementById("note_trea_" + row_num).value;//not
        trea_payment_rate = filterNum(document.getElementById("tre_payment_rate_" + row_num).value);//ödeme oranı
        money_limit_trea = filterNum(document.getElementById("money_limit_trea_" + row_num).value);//money
        assurance_id = '<cfoutput>#attributes.assurance_id#</cfoutput>';
        $.ajax({ 
            type:'POST',  
            url:'V16/hr/cfc/assurance_type.cfc?method=ADD_HEALTH_ASSURANCE_TYPE_TREATMENTS',
            data: { 
                treatment : treatment,
                assurance_id : assurance_id,
                period : period,
                max_trea_ : max_trea_,
                note_trea : note_trea,
                payment_rate : trea_payment_rate,
                money_limit_trea : money_limit_trea,
                treatment_id : treatment_id
            },
            success: function (returnData) {
                document.getElementById("add_text_"+row_num).innerHTML = "<b><cfoutput>#getLang('objects',1338,'eklendi')#</cfoutput></b>";
                return false;
            },
            error: function () 
            {
                console.log('CODE:8 please, try again..');
                return false; 
            }
        }); 
    }
    function upd_row_treatments(row_num,treatment_id)
    {
        setup_treatment_id = document.getElementById("treatment_id_" + row_num).value;
        treatment = document.getElementById("treatment_" + row_num).value;//tedavi
        max_trea_ = document.getElementById("max_trea_" + row_num).value;//maximum
        period = document.getElementById("period_" + row_num).value;//para birimi
        note_trea = document.getElementById("note_trea_" + row_num).value;//not
        trea_payment_rate = filterNum(document.getElementById("tre_payment_rate_" + row_num).value);//ödeme oranı
        money_limit_trea = filterNum(document.getElementById("money_limit_trea_" + row_num).value);//money
        assurance_id = '<cfoutput>#attributes.assurance_id#</cfoutput>';
        $.ajax({ 
            type:'POST',  
            url:'V16/hr/cfc/assurance_type.cfc?method=UPD_HEALTH_ASSURANCE_TYPE_TREATMENTS',  
            data: { 
                treatment : treatment,
                assurance_id : assurance_id,
                period : period,
                max_trea_ : max_trea_,
                treatment_id : treatment_id,
                note_trea : note_trea,
                payment_rate : trea_payment_rate,
                money_limit_trea : money_limit_trea,
                setup_treatment_id : setup_treatment_id
            },
            success: function (returnData) 
            {
                document.getElementById("update_div_trea_"+row_num).innerHTML = "<b>Güncellendi</b>";
                return false;
            },
            error: function () 
            {
                console.log('CODE:8 please, try again..');
                return false; 
            }
        }); 
    }
    function del_row_treatments(treatment_count,treatment_id)//Satır silme fonksiyonu
    {
        var my_element=eval("tr_row"+treatment_count);
        if(confirm ("<cf_get_lang dictionary_id = '36628.Satırı silmek istediğinize emin misiniz?'> ? "))
        {
            if(treatment_id != undefined)
            {
                $.ajax({ 
                    type:'POST',  
                    url:'V16/hr/cfc/assurance_type.cfc?method=DEL_HEALTH_ASSURANCE_TYPE_TREATMENTS',  
                    data: { 
                        treatment_id : treatment_id
                    },
                    success: function (returnData) 
                    {
                        alertObject({type: 'success',message: 'kayıt silindi..', closeTime: 5000});
		                my_element.style.display="none";
                    },
                    error: function () 
                    {
                        console.log('CODE:8 please, try again..');
                        return false; 
                    }
                }); 
            }
            $( "[treatment_id = 'row_"+treatment_count+"']" ).each(function( index ) {
                $( this ).remove();
            });
        }else return false;
    }
    function auto_treatments(no)
        {
            AutoComplete_Create('treatment_' + treatment_count +'','COMPLAINT','COMPLAINT','GetComplaint','','COMPLAINT_ID,COMPLAINT','treatment_id_' + treatment_count +',treatment_' + treatment_count +'');
        }
</script>