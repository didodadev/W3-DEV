<!---
File: upd_assurance_type_contracted.cfm
Author: Workcube-Esma Uysal <esmauysal@workcube.com>
Date: 22.11.2019
Controller: AssuranceTypesController.cfm
Description: Sağlık Teminatı Tipi güncelleme sayfası anlaşmalı kurumlar sekmesidir.
--->
<cfset get_health_price_protocol = components.GET_HEALTH_PRICE_PROTOCOL()>
<cfset get_contract_company = components.GET_HEALTH_ASSURANCE_CONTRACT_COMPANY(assurance_id : attributes.assurance_id)><!--- Anlaşmalı Kurumlar --->
<div id="item-contracted" class="item-contracted col col-8 col-md-8 col-sm-8 col-xs-12">
    <cf_grid_list>
        <thead>
            <th style="text-align:center;width:25px;"><input type="button" class="eklebuton" title="" onClick="add_row_contract()" value=""></th>
            <th><cf_get_lang dictionary_id = "29528.Tedarikçi"></th>
            <th><cf_get_lang dictionary_id = "30044.Sözleşme No"></th>
            <th><cf_get_lang dictionary_id = "34700.Fiyat protokolü"></th>
            <th><cf_get_lang dictionary_id = "58560.İndirim"> %</th>
            <th><cfoutput>#Left(getLang('main',672,'fiyat'),1)##Left(getLang('invoice',199,'Kontrol'),1)#</cfoutput></th>
        </thead>
        <cfset contract_company_count = 0>
        <cfform name="form_add_product" method="post" action="">
            <tbody id="add_row_contract">
                <cfif get_contract_company.recordcount>
                    <cfset contract_company_count = get_contract_company.recordcount>
                    <cfoutput query = "get_contract_company">
                        <tr id="row_contract#currentrow#">
                            <cfset protocol_id_q = protocol_id> 
                            <td class="text-center"><a style="cursor:pointer" onclick="del_row_contract('#currentrow#',#contract_company_id#);" ><i class="fa fa-minus"></i></a></td>
                            <td>
                                <div class="form-group" >  
                                    <div class="input-group">
                                        <input type="hidden" name="company_id_#currentrow#" id="company_id_#currentrow#" value="#company_id#">
                                        <input type="text" name="company_name_#currentrow#" id="company_name_#currentrow#" class="boxtext" onfocus="AutoComplete_Create('company_name_#currentrow#','MEMBER_NAME,MEMBER_PARTNER_NAME','MEMBER_NAME,MEMBER_PARTNER_NAME','get_member_autocomplete','\'1\',0,0','COMPANY_ID','company_id_#currentrow#','','3','250');"  value="#get_par_info(company_id,1,1,0)#" autocomplete="off">
                                        <span class="input-group-addon icon-ellipsis" onclick="windowopen('?fuseaction=objects.popup_list_pars&field_comp_name=form_add_product.company_name_#currentrow#&field_comp_id=form_add_product.company_id_#currentrow#&select_list=2&is_form_submitted=1','list');"></span>
                            </div>
                            </td>
                            <td><input type="text" name="contrat_no_#currentrow#" id="contrat_no_#currentrow#" value="#contract_no#" class="boxtext"></td>
                            <td>
                                <select name="protocol_id_#currentrow#" id = "protocol_id_#currentrow#" class="boxtext">
                                    <cfloop query="get_health_price_protocol">
                                        <option value="#protocol_id#" <cfif protocol_id eq protocol_id_q>selected</cfif>>#protocol_name#</option>
                                    </cfloop>
                                </select>
                            </td>
                            <td>
                                <input type="text" name="discount_#currentrow#" id="discount_#currentrow#" value="#TLFormat(discount)#" class="box" onKeyup="return(FormatCurrency(this,event,3));" onchange="fieldCommaSplit(this)">
                            </td>
                            <td nowrap style="text-align:center;">
                                <a href="javascript://" onclick=" upd_row_contract(#currentrow#,#contract_company_id#);"><i class="fa fa-refresh"></i></a><div id = "update_div_cont_#currentrow#"></div>
                            </td>
                        </tr>
                    </cfoutput>                            
                </cfif>
            </tbody>
        </cfform>
    </cf_grid_list>
</div>
<script>
    contract_company_count = '<cfoutput>#contract_company_count#</cfoutput>';
    function add_row_contract(gelen_id) // Satır ekleme
    {
        contract_company_count++;
        var newRow;
        newRow = document.getElementById("add_row_contract").insertRow(document.getElementById("add_row_contract").rows.length);	
        newRow.setAttribute("name","" + contract_company_count);
        newRow.setAttribute("id","row_contract" + contract_company_count);

        newCell = newRow.insertCell(newRow.cells.length);
        newCell.innerHTML = '<a style="cursor:pointer" onclick="del_row_contract(' + contract_company_count + ');" ><i class="fa fa-minus"></i></a>';
        
        newCell = newRow.insertCell(newRow.cells.length);
        newCell.innerHTML = '<div class="form-group"><div class="input-group"><input type="hidden" name="company_id_'+contract_company_count+'" id="company_id_'+contract_company_count+'" value=""><input type="text" class="boxtext" name="company_name_'+contract_company_count+'" id="company_name_'+contract_company_count+'"> <span class="input-group-addon icon-ellipsis"  onClick="open_comp('+ contract_company_count +');" onfocus="on_focus('+contract_company_count+')"></span></div><div>';
       
        newCell = newRow.insertCell(newRow.cells.length);
        newCell.innerHTML = '<input type="text" name="contrat_no_' + contract_company_count +'" id="contrat_no_' + contract_company_count +'" value="" class="boxtext">';

        newCell = newRow.insertCell(newRow.cells.length);
        newCell.innerHTML = '<select name="protocol_id_'+ contract_company_count +'" id = "protocol_id_'+ contract_company_count +'" class="boxtext"><cfoutput query="get_health_price_protocol"><option value="#protocol_id#">#protocol_name#</option></cfoutput></select>';

        newCell = newRow.insertCell(newRow.cells.length);
        newCell.innerHTML = '<input type="text" name="discount_' + contract_company_count +'" id="discount_' + contract_company_count +'" value="" class="box" onKeyup="return(FormatCurrency(this,event,3));" onchange="fieldCommaSplit(this)"> ';

        newCell = newRow.insertCell(newRow.cells.length);
        newCell.innerHTML = '<a href="javascript://" onclick= "save_row_contract('+contract_company_count+')" id = "submit_'+contract_company_count+'"><i class="fa fa-check" id = "check_icon_'+contract_company_count+'"></i></a><div id ="add_text_cont'+contract_company_count+'"></div>';
        newCell.setAttribute("style","text-align:center");
    }
    function open_comp(no)
	{
		openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_pars&field_comp_name=all.company_name_'+no+'&field_comp_id=all.company_id_'+no+'&select_list=2&is_form_submitted=1');
	}
    function on_focus(no)
	{
		AutoComplete_Create('company_name_'+no,'MEMBER_NAME,MEMBER_PARTNER_NAME','MEMBER_NAME,MEMBER_PARTNER_NAME','get_member_autocomplete','\'1\',0,0','COMPANY_ID','company_id'+no,'','3','250');
	}
    function save_row_contract(row_num)
    {
        
        company_id = document.getElementById("company_id_" + row_num).value;//Tedarikçi
        contrat_no = document.getElementById("contrat_no_" + row_num).value;//sözleşme no
        protocol_id = document.getElementById("protocol_id_" + row_num).value;//protocol id
        discount = filterNum(document.getElementById("discount_" + row_num).value);//indirim
        assurance_id = '<cfoutput>#attributes.assurance_id#</cfoutput>';
        $.ajax({ 
            type:'POST',  
            url:'V16/hr/cfc/assurance_type.cfc?method=ADD_HEALTH_ASSURANCE_CONTRACT_COMPANY',  
            data: { 
                assurance_id : assurance_id,
                company_id : company_id,
                contrat_no : contrat_no,
                protocol_id : protocol_id,
                discount : discount,
                assurance_id : assurance_id
            },
            success: function (returnData) {
                document.getElementById("add_text_cont"+row_num).innerHTML = "<b><cfoutput>#getLang('objects',1338,'eklendi')#</cfoutput></b>";
                return false;
            },
            error: function () 
            {
                console.log('CODE:8 please, try again..');
                return false; 
            }
        }); 
        return false; 
    }
    function upd_row_contract(row_num,id)
    {
        company_id = document.getElementById("company_id_" + row_num).value;//Tedarikçi
        contrat_no = document.getElementById("contrat_no_" + row_num).value;//sözleşme no
        protocol_id = document.getElementById("protocol_id_" + row_num).value;//protocol id
        discount = filterNum(document.getElementById("discount_" + row_num).value);//indirim
        assurance_id = '<cfoutput>#attributes.assurance_id#</cfoutput>';
        $.ajax({ 
            type:'POST',  
            url:'V16/hr/cfc/assurance_type.cfc?method=UPD_HEALTH_ASSURANCE_CONTRACT_COMPANY',  
            data: { 
                assurance_id : assurance_id,
                company_id : company_id,
                contrat_no : contrat_no,
                protocol_id : protocol_id,
                discount : discount,
                assurance_id : assurance_id,
                company_contract_id : id
            },
            success: function (returnData) {
                document.getElementById("update_div_cont_"+row_num).innerHTML = "<b>Güncellendi</b>";
                return false;
            },
            error: function () 
            {
                console.log('CODE:8 please, try again..');
                return false; 
            }
        }); 
        return false; 
    }
    function del_row_contract(row_count,id)//Satır silme fonksiyonu
    {
        var my_medicine=eval("row_contract"+row_count);
        if(confirm ("<cf_get_lang dictionary_id = '36628.Satırı silmek istediğinize emin misiniz?'> ? "))
        {
            if(id != undefined)
            {
                $.ajax({ 
                    type:'POST',  
                    url:'V16/hr/cfc/assurance_type.cfc?method=DEL_HEALTH_ASSURANCE_CONTRACT_COMPANY',  
                    data: { 
                        id : id
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
            $( "[id = 'row_contract"+row_count+"']" ).each(function( index ) {
                $( this ).remove();
            });
        }else return false;
    }
</script>