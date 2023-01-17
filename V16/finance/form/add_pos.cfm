<cfquery name="BRANCHES" datasource="#DSN#">
	SELECT 
		BRANCH_ID, 
		BRANCH_NAME 
	FROM 
		BRANCH 
	ORDER BY 
		BRANCH_NAME
</cfquery>
<cfparam name="attributes.modal_id" default="">
<cfif not isdefined("attributes.draggable")><cf_catalystHeader></cfif>
<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
    <cf_box id="box_counter" title="#iif(isDefined("attributes.draggable"),"getLang('','Yazar Kasa',39344)",DE(''))#" scroll="1" collapsable="1" resize="1" popup_box="#iif(isdefined("attributes.draggable"),DE(1),DE(0))#">
        <cfform name="add_pos" id="add_pos" method="post" action="#request.self#?fuseaction=finance.emptypopup_add_pos">
            <cf_box_elements>
                <div class="col col-5 col-md-5 col-sm-6 col-xs-12" type="column" index="1" sort="true">
                    <div class="form-group" id="item-equipment">
                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='49775.Kasa Adı'> *</label>
                        <div class="col col-8 col-xs-12">
                            <cfinput type="text" name="equipment" id="equipment" maxlength="100" required="yes" message="#getLang('','Kasa Girmelisiniz',54596)#">
                        </div>
                    </div>
                    <div class="form-group" id="item-equipment">
                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='49778.Kasa Kodu'> *</label>
                        <div class="col col-8 col-xs-12">
							<cfinput type="text" name="equipment_code" maxlength="50" required="yes" message="#getLang('','Kasa Kodu Girmelisiniz',62623)#!">
                        </div>
                    </div>
                    <div class="form-group" id="item-branch_id">
                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57453.Şube'></label>
                        <div class="col col-8 col-xs-12">
                            <select name="branch_id" id="branch_id" onchange="loadCatList(this.value)">
                                <option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
                                <cfoutput query="branches">
                                    <option value="#branch_id#">#branch_name#</option>
                                </cfoutput>
                            </select>
                        </div>
                    </div>
                    <div class="form-group" id="item-integration_type">
                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='49399.Entegrasyon'><cf_get_lang dictionary_id='52735.Type'></label>
                        <div class="col col-8 col-xs-12">
                            <select name="type" id="type" onchange="CheckShow(this.value)">
                                <option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
                                <option value="1"><cf_get_lang dictionary_id='62481.Whops'></option>
                                <option value="2"><cf_get_lang dictionary_id='36997.NCR'></option>
                                <option value="3"><cf_get_lang dictionary_id='36609.Toshiba'></option>
                                <option value="4"><cf_get_lang dictionary_id='35294.Diebold Nixdorf'></option>
                            </select>
                        </div>
                    </div>
                    <div class="form-group" id="item-path">
                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='49399.Entegrasyon'><cf_get_lang dictionary_id='47708.Path'> *</label>
                        <div class="col col-8 col-xs-12">
                            <cfinput type="text" name="path" maxlength="200" required="yes" message="#getLang('','Path Girmelisiniz',43428)#!">
                        </div>
                    </div>
					<div class="form-group" id="item-offline_path">
                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='62624.Offline Path'> *</label>
                        <div class="col col-8 col-xs-12">
                            <cfinput type="text" name="offline_path" maxlength="200" required="yes" message="#getLang('','Offline Path Girmelisiniz',62625)#!">
                        </div>
                    </div>
					<div class="form-group" id="item-filename">
                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='62626.Filename'> *</label>
                        <div class="col col-8 col-xs-12">
							<cfinput type="text" name="filename" maxlength="100" required="yes" message="#getLang('','Filename Girmelisiniz',62627)#!">
                        </div>
                    </div>
                </div>
                <div class="col col-5 col-md-5 col-sm-6 col-xs-12" type="column" index="2" sort="true">
                    <div class="form-group" id="item-assetp_id">
                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='58833.Fiziki Varlık'></label>
                        <div class="col col-8 col-xs-12">
                            <div class="input-group">
                                <input type="hidden" name="assetp_id" id="assetp_id" value="">
                                <input type="text" name="assetp" id="assetp">
                                <span class="input-group-addon icon-ellipsis btnPointer" onClick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_assets&field_id=add_pos.assetp_id&field_name=add_pos.assetp&event_id=0','list');return false"></span>
                            </div>
                        </div>
                    </div>
                    <div class="form-group" id="item-serial_no">
                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='62628.Seri Numarası'></label>
                        <div class="col col-8 col-xs-12">
							<cfinput type="text" name="serial_number" maxlength="100">
                        </div>
                    </div>
					<div class="form-group" id="item-memory_no">
                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='65199.Mali Bellek No'></label>
                        <div class="col col-8 col-xs-12">
							<cfinput type="text" name="mali_no" maxlength="100">
                        </div>
                    </div>
                    <div class="form-group" id="item-customer_id">
                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='65204.İsimsiz Müşteri'></label>
                        <div class="col col-8 col-xs-12">
							<cfinput type="text" name="customer_id" maxlength="11">
                        </div>
                    </div>
                    <!--- 
                        129666 - Kasiyerler şube bazında yetki verildiği için kaldırılmıştır     
                    <div class="form-group" id="item-pos_code1">
                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='54577.Kasiyer'> 1</label>
                        <div class="col col-8 col-xs-12">
                            <div class="input-group">
                                <input type="hidden" name="pos_code1" id="pos_code1" value="">
                                <input type="text" name="pos_code_text1" id="pos_code_text1" readonly>
                                <span class="input-group-addon icon-ellipsis btnPointer" onClick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_positions&field_code=add_pos.pos_code1&field_name=add_pos.pos_code_text1&select_list=1','list');return false"></span>
                            </div>
                        </div>
                    </div>
                    <div class="form-group" id="item-pos_code2">
                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='54577.Kasiyer'> 2</label>
                        <div class="col col-8 col-xs-12">
                            <div class="input-group">
                                <input type="hidden" name="pos_code2" id="pos_code2" value="">
                                <input type="text" name="pos_code_text2" id="pos_code_text2" readonly>
                                <span class="input-group-addon icon-ellipsis btnPointer" onClick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_positions&field_code=add_pos.pos_code2&field_name=add_pos.pos_code_text2&select_list=1','list');return false"></span>
                            </div>
                        </div>
                    </div>
                    <div class="form-group" id="item-pos_code3">
                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='54577.Kasiyer'> 3</label>
                        <div class="col col-8 col-xs-12">
                            <div class="input-group">
                                <input type="hidden" name="pos_code3" id="pos_code3" value="">
                                <input type="text" name="pos_code_text3" id="pos_code_text3" readonly>
                                <span class="input-group-addon icon-ellipsis btnPointer" onClick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_positions&field_code=add_pos.pos_code3&field_name=add_pos.pos_code_text3&select_list=1','list');return false"></span>
                            </div>
                        </div>
                    </div> --->
                </div>
                <div class="col col-10 col-md-10 col-sm-12 col-xs-12" id="cash_auth" style="display:none;">
                    <cf_seperator id="kasa_auth" title="#getLang('','Kasa Yetkileri',65200)#">
                    <div class="col col-12 col-md-12 col-sm-12 col-xs-12" type="column" index="3" sort="true" id="kasa_auth">
                        <div class="col col-3 col-md-4 col-xs-12">
                            <div class="form-group">
                                <input type="checkbox" name="USE_FOREIGN_CURRENCY" id="USE_FOREIGN_CURRENCY" value="1" checked><cf_get_lang dictionary_id='65201.Dövizli Satış'>
                            </div>
                            <div class="form-group">
                                <input type="checkbox" name="USE_CATEGORY_ICON" id="USE_CATEGORY_ICON" value="1" checked><cf_get_lang dictionary_id='65202.Kategori İkonu'>
                            </div>
                            <div class="form-group">
                                <input type="checkbox" name="USE_PRODUCT_IMAGE" id="USE_PRODUCT_IMAGE" value="1" checked ><cf_get_lang dictionary_id='39090.Ürün İmajı'>
                            </div>
                            <div class="form-group">
                                <input type="checkbox" name="USE_CUSTOMER_RECORD" id="USE_CUSTOMER_RECORD" value="1" checked ><cf_get_lang dictionary_id='65203.Yeni Müşteri Kaydı ve Güncelleme'>
                            </div>
                            <div class="form-group">
                                <input type="checkbox" name="USE_LOYALTY_CARD" id="USE_LOYALTY_CARD" value="1" checked><cf_get_lang dictionary_id='62535.Sadakat Kart'>
                            </div>
                            <div class="form-group">
                                <input type="checkbox" name="USE_SERIAL_NO" id="USE_SERIAL_NO" value="1" checked><cf_get_lang dictionary_id='65228.Seri Noya göre Satış yapılsın'>
                            </div>
                            <div class="form-group">
                                <input type="checkbox" name="USE_LOT_NO" id="USE_LOT_NO" value="1" checked><cf_get_lang dictionary_id='65229.Lot Noya göre Satış yapılsın'>
                            </div>
                        </div>
                        <div class="col col-6">
                            <div class="form-group">
                                <div class="col col-6">
                                    <label class="col-12"><cf_get_lang dictionary_id='57635.Miktar'><cf_get_lang dictionary_id='57710. Yuvarlama'></label>
                                    <select class="col-12" name="amount_round">
                                        <option value="0">0</option>
                                        <option value="1">1</option>
                                        <option value="2">2</option>
                                        <option value="3">3</option>
                                        <option value="4">4</option>
                                    </select>
                                </div>
                            </div>
                            <div class="form-group">
                                <div class="col col-6">
                                    <label class="col-12"><cf_get_lang dictionary_id='43873. Yuvarlama'></label>
                                    <select class="col-12" name="price_round">
                                        <option value="2">2</option>
                                        <option value="3">3</option>
                                        <option value="4">4</option>
                                    </select>
                                </div>
                            </div>
                            <div class="form-group">
                                <div class="col col-6">
                                    <label class="col-12"><cf_get_lang dictionary_id='61806. İşlem Tipi'>( Pr. Cat. ID )</label>
                                    <input type="text" name="pos_process_cat">
                                </div>
                            </div>
                            <div class="form-group">
                                <div class="col col-6">
                                    <label class="col-12"><cf_get_lang dictionary_id='58964. Fiyat Listesi'></label>
                                    <select class="col-12" name="price_cat_id" id="price_cat_id">
                                        <option value=""><cf_get_lang dictionary_id="57734.Seçiniz"></option>
                                    </select>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </cf_box_elements>
            <cf_box_footer>
                <cf_workcube_buttons is_upd='0' add_function='kontrol()'>
            </cf_box_footer>
        </cfform>
    </cf_box>
</div>
<script type="text/javascript">
function kontrol(){
    var trim_equipment = $.trim($("#equipment").val());
	if(!trim_equipment.length)
	{
		alertObject({message: '<cfoutput>#getLang('hr',1195)#</cfoutput>'}) 
        return true;   
	}
    if(document.getElementById('equipment_name').value == ''){
        alert("<cf_get_lang dictionary_id='54596.Kasa Girmelisiniz'>"); 
        return false;
    }
    if(document.getElementById('equipment_code').value == ''){
        alert("<cf_get_lang dictionary_id='62623.Kasa Kodu Girmelisiniz'>"); 
        return false;
    }
    if(document.getElementById('path').value == ''){
        alert("<cf_get_lang dictionary_id='43428.Path Girmelisiniz'>"); 
        return false;
    }

    if(document.getElementById('offline_path').value == ''){
        alert("<cf_get_lang dictionary_id='62625.Offline Path Girmelisiniz'>");
        return false;
    }

    if(document.getElementById('filename').value == ''){
        alert("<cf_get_lang dictionary_id='62627.Filename Girmelisiniz'>");
        return false;
    }
    <cfif isdefined("attributes.draggable")>loadPopupBox('add_pos' , <cfoutput>#attributes.modal_id#</cfoutput>);<cfelse>return true;</cfif>
}
function CheckShow(val) {
    ( val == 1 ) ? $("div#cash_auth").show() : $("div#cash_auth").hide();
}

function loadCatList(value){
    var data = new FormData();
    data.append('branch_id', document.add_pos.branch_id.value );
    AjaxControlPostDataJson( '/V16/invoice/datagates/endpoints/products_endpoint.cfc?method=cat_list', data, function( response ){
        $("#price_cat_id option[value!='']").remove();
        if(response.length){
            response.forEach((e) => { 
                var option = $('<option/>');
                option.attr({ 'value': e.PRICE_CATID }).text( e.PRICE_CAT );
                $('#price_cat_id').append( option );
            });
        }
    });		
}

</script>