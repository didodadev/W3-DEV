<cfquery name="BRANCHES" datasource="#DSN#">
	SELECT 
		BRANCH_ID, 
		BRANCH_NAME 
	FROM 
		BRANCH 
	ORDER BY 
		BRANCH_NAME
</cfquery>
<cfquery name="GET_POS_EQUIPMENT" datasource="#DSN3#">
	SELECT
		*
	FROM
		POS_EQUIPMENT
	WHERE
		POS_ID = #attributes.pos_id#
</cfquery>
<cfparam name="attributes.modal_id" default="">
<cfsavecontent variable="title"><cf_get_lang dictionary_id='39344.Yazar Kasa'>: <cfoutput>#attributes.pos_id#</cfoutput></cfsavecontent>
<cfsavecontent variable="txt">
	<a href="<cfoutput>#request.self#?fuseaction=finance.popup_form_add_pos</cfoutput>"><i class="fa fa-plus" border="0" alt="<cf_get_lang dictionary_id='57582.Ekle'>" title="<cf_get_lang dictionary_id='57582.Ekle'>"></i></a>
</cfsavecontent>
<cfif not isdefined("attributes.draggable")><cf_catalystHeader></cfif>
<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
    <cf_box title="#iif(isDefined("attributes.draggable"),"title",DE(''))#" scroll="1" collapsable="1" resize="1" popup_box="#iif(isdefined("attributes.draggable"),DE(1),DE(0))#">
        <cfform name="add_pos" id="add_pos" method="post" action="#request.self#?fuseaction=finance.emptypopup_upd_pos">
            <input type="hidden" name="pos_id" id="pos_id" value="<cfoutput>#attributes.pos_id#</cfoutput>">
            <cf_box_elements>
                <div class="col col-12 col-md-4 col-sm-12" type="column" index="1" sort="true">
					<div class="form-group" id="item-is_status">
						<label class="col col-12">
							<input type="checkbox" name="is_status" id="is_status" value="1" <cfif get_pos_equipment.is_status> checked</cfif>><cf_get_lang dictionary_id='57493.Aktif'>
						</label>
					</div>
				</div>
                <div class="col col-5 col-md-5 col-sm-6 col-xs-12" type="column" index="1" sort="true">
                    <div class="form-group" id="item-equipment">
                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='49775.Kasa Adı'> *</label>
                        <div class="col col-8 col-xs-12">
                            <cfsavecontent variable="message"><cf_get_lang dictionary_id='54584.Cihaz Adı Girmelisiniz'></cfsavecontent>
                            <cfinput type="text" name="equipment" id="equipment"  maxlength="100" required="yes" value="#get_pos_equipment.equipment#" message="#message#">
                        </div>
                    </div>
                    <div class="form-group" id="item-equipment_code">
						<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='49778.Kasa Kodu'> *</label>
						<div class="col col-8 col-xs-12">
							<cfinput type="text" name="equipment_code" id="equipment_code" value="#get_pos_equipment.equipment_code#" maxlength="50" required="yes" message="#getLang('','Kasa Kodu Girmelisiniz',62623)#!">
						</div>
					</div>
                    <div class="form-group" id="item-branch_id">
                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57453.Şube'></label>
                        <div class="col col-8 col-xs-12">
                            <select name="branch_id" id="branch_id" onchange="loadCatList(this.value)">
                                <option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
                                <cfoutput query="branches">
                                    <option value="#branch_id#" <cfif branch_id eq get_pos_equipment.branch_id> selected</cfif>>#branch_name#</option>
                                </cfoutput>
                            </select>
                        </div>
                    </div>
                    <div class="form-group" id="item-integration_type">
                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='49399.Entegrasyon'><cf_get_lang dictionary_id='52735.Type'></label>
                        <div class="col col-8 col-xs-12">
                            <select name="type" id="type" onchange="CheckShow(this.value)">
                                <option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
                                <option value="1" <cfif get_pos_equipment.type eq 1> selected </cfif>><cf_get_lang dictionary_id='62481.Whops'></option>
                                <option value="2" <cfif get_pos_equipment.type eq 2> selected </cfif>><cf_get_lang dictionary_id='36997.NCR'></option>
                                <option value="3" <cfif get_pos_equipment.type eq 3> selected </cfif>><cf_get_lang dictionary_id='36609.Toshiba'></option>
                                <option value="4" <cfif get_pos_equipment.type eq 4> selected </cfif>><cf_get_lang dictionary_id='35294.Diebold Nixdorf'></option>
                            </select>
                        </div>
                    </div>
                    <div class="form-group" id="item-path">
						<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='49399.Entegrasyon'><cf_get_lang dictionary_id='47708.Path'> *</label>
						<div class="col col-8 col-xs-12">
							<cfinput type="text" name="path" id="path" value="#get_pos_equipment.path#" maxlength="200" required="yes" message="#getLang('','Path Girmelisiniz',43428)#!">
						</div>
					</div>
					<div class="form-group" id="item-offline_path">
						<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='62624.Offline Path'> *</label>
						<div class="col col-8 col-xs-12">
							<cfinput type="text" name="offline_path" id="offline_path" value="#get_pos_equipment.offline_path#" maxlength="200" required="yes" message="#getLang('','Offline Path Girmelisiniz',62625)#!">
						</div>
					</div>
					<div class="form-group" id="item-filename">
						<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='62626.Filename'> *</label>
						<div class="col col-8 col-xs-12">
							<cfinput type="text" name="filename" id="filename"  value="#get_pos_equipment.filename#" maxlength="100" required="yes" message="#getLang('','Filename Girmelisiniz',62627)#!">
						</div>
					</div>
				</div>
                <div class="col col-5 col-md-5 col-sm-6 col-xs-12" type="column" index="3" sort="true">
                    <div class="form-group" id="item-assetp_id">
                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='58833.Fiziki Varlık'></label>
                        <div class="col col-8 col-xs-12">
                            <div class="input-group">
                                <input type="hidden" name="assetp_id" id="assetp_id" value="<cfoutput>#get_pos_equipment.assetp_id#</cfoutput>">
                                <cfif len(get_pos_equipment.assetp_id)>
                                    <cfset attributes.assetp_id = get_pos_equipment.assetp_id>
                                    <cfinclude template="../query/get_assetp_name.cfm">
                                    <input type="text" name="assetp" id="assetp" value="<cfoutput>#get_assetp_name.assetp#</cfoutput>">
                                <cfelse>
                                    <input type="text" name="assetp" id="assetp">
                                </cfif>
                                <span class="input-group-addon icon-ellipsis btnPointer" onClick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_assets&field_id=add_pos.assetp_id&field_name=add_pos.assetp&event_id=0','list');return false"></span>
                            </div>
                        </div>
                    </div>
                    <div class="form-group" id="item-serial_number">
						<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='62628.Seri Numarası'></label>
						<div class="col col-8 col-xs-12">
							<cfinput type="text" name="serial_number" id="serial_number" value="#get_pos_equipment.serial_number#" maxlength="100">
						</div>
					</div>
					<div class="form-group" id="item-mali_no">
						<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='65199.Mali Bellek No'></label>
						<div class="col col-8 col-xs-12">
							<cfinput type="text" name="mali_no" value="#get_pos_equipment.mali_no#" maxlength="100">
						</div>
					</div>
                    <div class="form-group" id="item-customer_id">
                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='65204.İsimsiz Müşteri'></label>
                        <div class="col col-8 col-xs-12">
							<cfinput type="text" name="customer_id" value="#get_pos_equipment.customer_id#" maxlength="11">
                        </div>
                    </div>
                    <!--- 
                         129666 - Kasiyerler şube bazında yetki verildiği için kaldırılmıştır    
                    <div class="form-group" id="item-pos_code1">
                        <label class="col col-3 col-xs-12"><cf_get_lang dictionary_id='54577.Kasiyer'> 1</label>
                        <div class="col col-9 col-xs-12">
                            <div class="input-group">
                                <input type="hidden" name="pos_code1" id="pos_code1" value="<cfoutput>#get_pos_equipment.cashier1#</cfoutput>">
                                <cfif len(get_pos_equipment.cashier1)>
                                    <input type="text" name="pos_code_text1" id="pos_code_text1" value="<cfoutput>#get_emp_info(get_pos_equipment.cashier1,1,0)#</cfoutput>" readonly>
                                <cfelse>
                                    <input type="text" name="pos_code_text1" id="pos_code_text1" value="" readonly >
                                </cfif>
                                <span class="input-group-addon icon-ellipsis btnPointer" onClick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_positions&field_code=add_pos.pos_code1&field_name=add_pos.pos_code_text1&select_list=1','list');return false"></span>
                            </div>
                        </div>
                    </div>
                    <div class="form-group" id="item-pos_code2">
                        <label class="col col-3 col-xs-12"><cf_get_lang dictionary_id='54577.Kasiyer'> 2</label>
                        <div class="col col-9 col-xs-12">
                            <div class="input-group">
                                <input type="hidden" name="pos_code2" id="pos_code2" value="<cfoutput>#get_pos_equipment.cashier2#</cfoutput>">
                                <cfif len(get_pos_equipment.cashier2)>
                                    <input type="text" name="pos_code_text2" id="pos_code_text2" value="<cfoutput>#get_emp_info(get_pos_equipment.cashier2,1,0)#</cfoutput>" readonly >
                                <cfelse>
                                    <input type="text" name="pos_code_text2" id="pos_code_text2" value="" readonly>
                                </cfif>
                                <span class="input-group-addon icon-ellipsis btnPointer" onClick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_positions&field_code=add_pos.pos_code2&field_name=add_pos.pos_code_text2&select_list=1','list');return false"></span>
                            </div>
                        </div>
                    </div>
                    <div class="form-group" id="item-pos_code3">
                        <label class="col col-3 col-xs-12"><cf_get_lang dictionary_id='54577.Kasiyer'> 3</label>
                        <div class="col col-9 col-xs-12">
                            <div class="input-group">
                                <input type="hidden" name="pos_code3" id="pos_code3" value="<cfoutput>#get_pos_equipment.cashier3#</cfoutput>">
                                <cfif len(get_pos_equipment.cashier3)>
                                    <input type="text" name="pos_code_text3" id="pos_code_text3" value="<cfoutput>#get_emp_info(get_pos_equipment.cashier3,1,0)#</cfoutput>" readonly>
                                <cfelse>
                                    <input type="text" name="pos_code_text3" id="pos_code_text3" value="" readonly>
                                </cfif> 
                                <span class="input-group-addon icon-ellipsis btnPointer" onClick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_positions&field_code=add_pos.pos_code3&field_name=add_pos.pos_code_text3&select_list=1','list');return false"></span>
                            </div>
                        </div>
                    </div> --->
                </div>
                <div class="col col-10 col-md-10 col-sm-12 col-xs-12" id="cash_auth" style="display:none;">
                    <cf_seperator id="kasa_auth" title="#getLang('','Kasa Ayarları',65217)#">
                    <div class="col col-12 col-md-12 col-sm-12 col-xs-12" type="column" index="3" sort="true" id="kasa_auth">
                        <div class="col col-3 col-md-4 col-xs-12">
                            <div class="form-group">
                                <input type="checkbox" name="USE_FOREIGN_CURRENCY" id="USE_FOREIGN_CURRENCY" value="1" <cfif get_pos_equipment.USE_FOREIGN_CURRENCY eq 1> checked </cfif>><cf_get_lang dictionary_id='65201.Dövizli Satış'>
                            </div>
                            <div class="form-group">
                                <input type="checkbox" name="USE_CATEGORY_ICON" id="USE_CATEGORY_ICON" value="1" <cfif get_pos_equipment.USE_CATEGORY_ICON eq 1> checked </cfif>><cf_get_lang dictionary_id='65202.Kategori İkonu'>
                            </div>
                            <div class="form-group">
                                <input type="checkbox" name="USE_PRODUCT_IMAGE" id="USE_PRODUCT_IMAGE" value="1" <cfif get_pos_equipment.USE_PRODUCT_IMAGE eq 1> checked </cfif>><cf_get_lang dictionary_id='39090.Ürün İmajı'>
                            </div>
                            <div class="form-group">
                                <input type="checkbox" name="USE_CUSTOMER_RECORD" id="USE_CUSTOMER_RECORD" value="1" <cfif get_pos_equipment.USE_CUSTOMER_RECORD eq 1> checked </cfif>><cf_get_lang dictionary_id='65203.Yeni Müşteri Kaydı ve Güncelleme'>
                            </div>
                            <div class="form-group">
                                <input type="checkbox" name="USE_LOYALTY_CARD" id="USE_LOYALTY_CARD" value="1" <cfif get_pos_equipment.USE_LOYALTY_CARD eq 1> checked </cfif>><cf_get_lang dictionary_id='62535.Sadakat Kart'>
                            </div>
                            <div class="form-group">
                                <input type="checkbox" name="USE_SERIAL_NO" id="USE_SERIAL_NO" value="1" <cfif get_pos_equipment.USE_SERIAL_NO eq 1> checked </cfif>><cf_get_lang dictionary_id='65228.Seri Noya göre Satış yapılsın'>
                            </div>
                            <div class="form-group">
                                <input type="checkbox" name="USE_LOT_NO" id="USE_LOT_NO" value="1" <cfif get_pos_equipment.USE_LOT_NO eq 1> checked </cfif>><cf_get_lang dictionary_id='65229.Lot Noya göre Satış yapılsın'>
                            </div>
                        </div>
                        <div class="col col-6">
                            <div class="form-group">
                                <div class="col col-6">
                                    <label class="col-12"><cf_get_lang dictionary_id='57635.Miktar'><cf_get_lang dictionary_id='57710. Yuvarlama'></label>
                                    <select class="col-12" name="amount_round">
                                        <option value="0" <cfif GET_POS_EQUIPMENT.AMOUNT_ROUND eq 0> selected </cfif>>0</option>
                                        <option value="1" <cfif GET_POS_EQUIPMENT.AMOUNT_ROUND eq 1> selected </cfif>>1</option>
                                        <option value="2" <cfif GET_POS_EQUIPMENT.AMOUNT_ROUND eq 2> selected </cfif>>2</option>
                                        <option value="3" <cfif GET_POS_EQUIPMENT.AMOUNT_ROUND eq 3> selected </cfif>>3</option>
                                        <option value="4" <cfif GET_POS_EQUIPMENT.AMOUNT_ROUND eq 4> selected </cfif>>4</option>
                                    </select>
                                </div>
                            </div>
                            <div class="form-group">
                                <div class="col col-6">
                                    <label class="col-12"><cf_get_lang dictionary_id='43873. Yuvarlama'></label>
                                    <select class="col-12" name="price_round">
                                        <option value="2" <cfif GET_POS_EQUIPMENT.PRICE_ROUND eq 2> selected </cfif>>2</option>
                                        <option value="3" <cfif GET_POS_EQUIPMENT.PRICE_ROUND eq 3> selected </cfif>>3</option>
                                        <option value="4" <cfif GET_POS_EQUIPMENT.PRICE_ROUND eq 4> selected </cfif>>4</option>
                                    </select>
                                </div>
                            </div>
                            <div class="form-group">
                                <div class="col col-6">
                                    <label class="col-12"><cf_get_lang dictionary_id='61806. İşlem Tipi'>( Pr. Cat. ID )</label>
                                    <input type="text" value="<cfoutput>#GET_POS_EQUIPMENT.POS_PROCESS_CAT#</cfoutput>" name="pos_process_cat">
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
                <cf_record_info 
                query_name = "get_pos_equipment"
                record_emp = "record_emp"
                update_emp = "update_emp" 
                record_date = "record_date"
                update_date ="update_date">
                <cf_workcube_buttons type_format="1" is_upd='1' is_delete="1" delete_page_url='#request.self#?fuseaction=finance.list_pos_equipment&event=del&pos_id=#attributes.pos_id#' add_function='kontrol()'>
            </cf_box_footer>
        </cfform>
    </cf_box>
</div>
<script type="text/javascript">
function kontrol(){
    if(!$("#equipment").val().length)
    {
        alertObject({message:'<cfoutput>#getLang('hr',1195)#</cfoutput>'})    
        return true;
    }
    if(document.getElementById('equipment').value == ''){
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

    <cfif isdefined("attributes.draggable")>loadPopupBox('add_pos' , <cfoutput>#attributes.modal_id#</cfoutput>);</cfif>
}
    $( document ).ready(function() {
        CheckShow( <cfoutput>#get_pos_equipment.type#</cfoutput> );

        var cash_type = "<cfoutput>#get_pos_equipment.type#</cfoutput>";
        <cfif get_pos_equipment.type eq 1>
            loadCatList('<cfoutput>#get_pos_equipment.branch_id#</cfoutput>','<cfoutput>#get_pos_equipment.price_cat_id#</cfoutput>');
        </cfif>
    });

    function CheckShow(val) {
        ( val == 1 ) ? $("div#cash_auth, div#cash_sett").show() : $("div#cash_auth, div#cash_sett").hide();
    }

    function loadCatList(value, selected){
        var data = new FormData();
        data.append('branch_id', document.add_pos.branch_id.value );
        AjaxControlPostDataJson( '/V16/invoice/datagates/endpoints/products_endpoint.cfc?method=cat_list', data, function( response ){
            $("#price_cat_id option[value!='']").remove();
            if(response.length){
                response.forEach((e) => { 
                    var option = $('<option/>');

                    if(selected && selected == e.PRICE_CATID )
						option.attr({ 'value': e.PRICE_CATID, 'selected':'selected' }).text( e.PRICE_CAT );
					else
                        option.attr({ 'value': e.PRICE_CATID }).text( e.PRICE_CAT );
                    $('#price_cat_id').append( option );

                });

            }
        });		
    }
</script>