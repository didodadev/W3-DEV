<!---
File: upd_assurance_type_limb.cfm
Author: Workcube-Melek KOCABEY <melekkocabey@workcube.com>
Date: 25.11.2019
Controller: AssuranceTypesController.cfm
Description: Sağlık Teminatı Tipi güncelleme sayfası Uzuvlar tabıdır...
--->
<div id="item-limbs" class="item-limbs col col-9 col-md-9 col-xs-12">
    <cf_grid_list>
        <thead>
            <th style="text-align:center;width:25px;"><input type="button" class="eklebuton" title="" onClick="add_row_limbs('products_services')" value=""></th>
            <th><cf_get_lang dictionary_id = "59568.Uzuv / Organ"></th>
            <th><cf_get_lang dictionary_id = "41374.Periyot"></th>
            <th>(Max)</th>
            <th><cf_get_lang dictionary_id = "59996.Ödeme Limiti"></th>
            <th><cf_get_lang dictionary_id = "58456.Oran">%</th>
            <th><cf_get_lang dictionary_id = "57467.Not"></th>
            <th></th>
        </thead>
        <cfset limb_count = 0>
        <tbody id="limbs">
            <cfif get_assurance_limb.recordcount>
                <cfset limb_count = get_assurance_limb.recordcount>
                <cfoutput query = "get_assurance_limb">
                    <tr id="tr_row_limb#currentrow#">
                        <td class="text-center"><a style="cursor:pointer" onclick="del_row_limbs('#currentrow#',#assurance_limb_id#);" ><i class="fa fa-minus"></i></a></td>
                        <td>                            
                            <input type="hidden" name="limb_id_#currentrow#" id="limb_id_#currentrow#" value="#LIMB_ID#">
                            <input type="text" name="limb_name_#currentrow#" id="limb_name_#currentrow#" value="#LIMB_NAME#" class="boxtext" onfocus="AutoComplete_Create('limb_name_#currentrow#','LIMB_ID','LIMB_NAME','Get_SetupLimb','','LIMB_ID,LIMB_NAME','limb_id_#currentrow#,limb_name_#currentrow#');">
                        </td>
                        <td>
                            <select id = "period_limb_#currentrow#" name = "period_limb_#currentrow#" class="boxtext" value="#period#">
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
                        <td><input type="text" name="max_limb_#currentrow#" id="max_limb_#currentrow#" value="#max#" class="box"></td>
                        <td><input type="text" name="money_limit_limb_#currentrow#" id="money_limit_limb_#currentrow#" value="#tlformat(money_limit,2)#" onKeyup="return(FormatCurrency(this,event,3));" onchange="fieldCommaSplit(this)" class="box"></td>
                        <td><input type="text" name="payment_rate_limb_#currentrow#" id="payment_rate_limb_#currentrow#" value="#TLFormat(payment_rate)#" class="box" onKeyup="return(FormatCurrency(this,event,3));" onchange="fieldCommaSplit(this)"></td>
                        <td><input type="text" name="note_limb_#currentrow#" id="note_limb_#currentrow#" value="#note#" class="boxtext"></td>
                        <td nowrap style="text-align:center;">
                            <a href="javascript://" onclick="upd_row_limbs('#currentrow#',#assurance_limb_id#)"><i class="fa fa-refresh"></i></a><div id ="update_div_limb_#currentrow#"></div>
                        </td>
                    </tr>
                </cfoutput>                            
            </cfif>
        </tbody>
    </cf_grid_list>
</div>
<script>
    limb_count = '<cfoutput>#limb_count#</cfoutput>';
    function add_row_limbs(gelen_limb_id)
    {
        limb_count++;
        var newRow;
        newRow = document.getElementById("limbs").insertRow(document.getElementById("limbs").rows.length);	
        newRow.setAttribute("name","" + limb_count);
        newRow.setAttribute("id","row_" + limb_count);
        
        newCell = newRow.insertCell(newRow.cells.length);
        newCell.innerHTML = '<a style="cursor:pointer" onclick="del_row(' + limb_count + ');" ><i class="fa fa-minus"></i></a>';

        newCell = newRow.insertCell(newRow.cells.length);
        newCell.innerHTML = '<input type="hidden" name="limb_id_' + limb_count + '" id="limb_id_' + limb_count + '"><input type="text" class="boxtext" name="limb_name_' + limb_count + '" id="limb_name_' + limb_count + '" onFocus="auto_limbs('+ limb_count +');"><a href="javascript://"></a>';
    
        newCell = newRow.insertCell(newRow.cells.length);
        newCell.innerHTML ='<select name="period_limb_' + limb_count + '" id="period_limb_' + limb_count + '" class="boxtext"> <option value = "1" ><cf_get_lang dictionary_id = '57490.Gün'></option><option value = "2" ><cf_get_lang dictionary_id = '58724.Ay'></option><option value = "3" ><cf_get_lang dictionary_id = '58734.Hafta'></option><option value = "4" >3<cf_get_lang dictionary_id = '58724.Ay'></option><option value = "5" >6<cf_get_lang dictionary_id = '58724.Ay'></option><option value = "6" ><cf_get_lang dictionary_id = '58455.Yıl'></option><option value = "7" >2<cf_get_lang dictionary_id = '58455.Yıl'></option><option value = "8" >3<cf_get_lang dictionary_id = '58455.Yıl'></option><option value = "9" >4<cf_get_lang dictionary_id = '58455.Yıl'></option><option value = "10" >5<cf_get_lang dictionary_id = '58455.Yıl'></option></select>';

        newCell = newRow.insertCell(newRow.cells.length);
        newCell.innerHTML = '<input type="text" name="max_limb_' + limb_count +'" id="max_limb_' + limb_count +'" value="" class="box">';
 
        newCell = newRow.insertCell(newRow.cells.length);
        newCell.innerHTML = '<input type="text" name="money_limit_limb_' + limb_count +'" id="money_limit_limb_' + limb_count +'" class="box" value="<cfoutput>#TLFormat(0)#</cfoutput>" onKeyup="return(FormatCurrency(this,event,3));" onchange="fieldCommaSplit(this)">';

        newCell = newRow.insertCell(newRow.cells.length);
        newCell.innerHTML = '<input type="text" name="payment_rate_limb_' + limb_count +'" id="payment_rate_limb_' + limb_count +'" class="box" value="" onKeyup="return(FormatCurrency(this,event,3));" onchange="fieldCommaSplit(this)">';

        newCell = newRow.insertCell(newRow.cells.length);
        newCell.innerHTML = '<input type="text" name="note_limb_' + limb_count +'" id="note_limb_' + limb_count +'" value="" class="boxtext">';

        newCell = newRow.insertCell(newRow.cells.length);
        newCell.innerHTML = '<a href="javascript://" onclick= "save_row_limbs('+limb_count+')" id = "submit_'+limb_count+'"><i class="fa fa-check" id = "check_icon_'+limb_count+'"></i></a><div id ="add_text_limb_'+limb_count+'"></div>';
        newCell.setAttribute("style","text-align:center");
    }
    function save_row_limbs(row_num) 
    {
        limb_id = document.getElementById("limb_id_" + row_num).value;//uzuv
        max_limb_ = document.getElementById("max_limb_" + row_num).value;//maximum
        period = document.getElementById("period_limb_" + row_num).value;//periyot
        note_limb = document.getElementById("note_limb_" + row_num).value;//not
        payment_rate_limb = filterNum(document.getElementById("payment_rate_limb_" + row_num).value);//ödeme oranı
        money_limit_limb = filterNum(document.getElementById("money_limit_limb_" + row_num).value);//money
        assurance_id = '<cfoutput>#attributes.assurance_id#</cfoutput>';
        $.ajax({ 
            type:'POST',  
            url:'V16/hr/cfc/assurance_type.cfc?method=ADD_HEALTH_ASSURANCE_TYPE_LIMB',  
            data: { 
                limb_id :limb_id,
                assurance_id : assurance_id,
                period_limb_ : period,
                max_limb_ : max_limb_,
                note_limb : note_limb,
                payment_rate_limb : payment_rate_limb,
                money_limit_limb : money_limit_limb
            },
            success: function (returnData) {
                document.getElementById("add_text_limb_"+row_num).innerHTML = "<b><cfoutput>#getLang('objects',1338,'eklendi')#</cfoutput></b>";
                return false;
            },
            error: function () 
            {
                console.log('CODE:8 please, try again..');
                return false; 
            }
        }); 
    }
    function upd_row_limbs(row_num,assurance_limb_id)
    {
        limb_id = document.getElementById("limb_id_" + row_num).value;//uzuv
        max_limb_ = document.getElementById("max_limb_" + row_num).value;//maximum
        period= document.getElementById("period_limb_" + row_num).value;//Periyod
        note_limb = document.getElementById("note_limb_" + row_num).value;//not
        payment_rate_limb = filterNum(document.getElementById("payment_rate_limb_" + row_num).value);//ödeme oranı
        money_limit_limb = filterNum(document.getElementById("money_limit_limb_" + row_num).value);//money
        assurance_id = '<cfoutput>#attributes.assurance_id#</cfoutput>';
        $.ajax({ 
            type:'POST',  
            url:'V16/hr/cfc/assurance_type.cfc?method=UPD_HEALTH_ASSURANCE_TYPE_LIMB',  
            data: { 
                limb_id_ : limb_id,
                assurance_id : assurance_id,
                period_limb_ : period,
                max_limb_ : max_limb_,
                note_limb : note_limb,
                payment_rate_limb : payment_rate_limb,
                money_limit_limb : money_limit_limb,
                ASSURANCE_LIMB_ID: assurance_limb_id
            },
            success: function (returnData) {
                document.getElementById("update_div_limb_"+row_num).innerHTML = "<b>Güncellendi</b>";
                return false;
            },
            error: function () 
            {
                console.log('CODE:8 please, try again..');
                return false; 
            }
        }); 
    }
    function del_row_limbs(limb_count,assurance_limb_id)//Satır silme fonksiyonu
    {
        var my_element_limb=eval("tr_row_limb"+limb_count);
        if(confirm ("<cf_get_lang dictionary_id = '36628.Satırı silmek istediğinize emin misiniz?'> ? "))
        {
            if(assurance_limb_id != undefined)
            {
                $.ajax({ 
                    type:'POST',  
                    url:'V16/hr/cfc/assurance_type.cfc?method=DEL_HEALTH_ASSURANCE_TYPE_LIMB',  
                    data: { 
                        assurance_limb_id : assurance_limb_id
                    },
                    success: function (returnData) {
                        alertObject({type: 'success',message: 'kayıt silindi..', closeTime: 5000});
		                my_element_limb.style.display="none";
                    },
                    error: function () 
                    {
                        console.log('CODE:8 please, try again..');
                        return false; 
                    }
                }); 
            }
            $( "[assurance_limb_id = 'row_"+limb_count+"']" ).each(function( index ) {
                $( this ).remove();
            });
        }else return false;
    }
    function auto_limbs(no)
    {
        AutoComplete_Create('limb_name_' + limb_count +'','LIMB_ID','LIMB_NAME','Get_SetupLimb','','LIMB_ID,LIMB_NAME','limb_id_' + limb_count +',limb_name_' + limb_count +'');
    }
</script>