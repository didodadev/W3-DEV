<!---
    File:V16\correspondence\form\upd_paperandcargo.cfm
    Controller:WBO\controller\PaperAndCargoController.cfm
    Author: Zehra Dere
    Date: 2020-12-05
    Description:
    Gelen giden evrak ve kargo işlemlerininin güncellendiği ve silindiği  sayfadır
    Correspendence kullanım sayfasıdır.
    History:
    To Do:

--->
<cfset comp = createObject("component","V16.correspondence.cfc.PaperAndCargo") />
<cfset get_document = comp.get_document()/>
<cfset get_money=comp.GET_MONEY() />
<cfset get_list_cargo_=comp.get_list_cargo(cargo_id : attributes.cargo_id) />
<cfset save_folder = "#upload_folder#cargo#dir_seperator#" />
<!--- Dizin kontrolü --->
<cfif Not DirectoryExists("#save_folder#")>
    <cfdirectory action="create" directory="#save_folder#" />
</cfif>
<cf_catalystHeader>
<div class="col col-12 col-md-12 col-sm-12 col-xs-12"> 
    <cf_box>
        <cfform name="upd_cargo"  action="V16/correspondence/cfc/PaperAndCargo.cfc?method=UPDATE_CARGO&cargo_id=#attributes.cargo_id#" enctype="multipart/form-data" method="post" >
            <input type="hidden" name="save_folder" id="save_folder" value="<cfoutput>#save_folder#</cfoutput>" />
            <cfinput type="hidden" name="cargo_id" id="cargo_id" value="#attributes.cargo_id#">
            <cf_box_elements>
                <div class="col col-6 col-md-4 col-sm-12 column" id="column-1">
                    <div class="form-group" id="item-process_stage">
                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id="58859.Süreç"></label>
                        <div class="col col-8 col-xs-12">
                            <cf_workcube_process is_upd='0' select_value='#get_list_cargo_.process_stage#' process_cat_width='150' is_detail='1'>
                        </div>
                    </div>
                    <div class="form-group" id="item-comint_out">
                        <label class="col col-4 col-xs12"><cf_get_lang dictionary_id='58974.Gelen'>/<cf_get_lang dictionary_id='58975.Giden'> </label>  
                        <div class="col col-8 col-xs-12">
                            <select name="coming_out" id="coming_out">
                                <option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
                                <option value="1"<cfif get_list_cargo_.coming_out eq 1> selected</cfif>><cf_get_lang dictionary_id ='58974.Gelen'></option>
                                <option value="2"<cfif get_list_cargo_.coming_out eq 2> selected</cfif>><cf_get_lang dictionary_id ='58975.Giden'></option>
                            </select>
                        </div>
                    </div>
                    <div class="form-group" id="item-document_registration_no">
                        <label class="col col-4 col-xs12"><cf_get_lang dictionary_id='48274.Evrak No'>/<cf_get_lang dictionary_id='31257.Kayıt No'> </label>
                        <div class="col col-8 col-xs-12">
                            <cfinput type="Text" name="document_registration_no" id="document_registration_no" maxlength="100" value="#get_list_cargo_.document_registration_no#" >
                        </div>
                    </div>                            
                    <div class="form-group" id="item-DATE_REGISTRATION">
                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id ='57627.Kayıt Tarihi'></label>
                        <div class="col col-8 col-xs-12">
                            <div class="input-group">
                                <cfoutput> <input type="text" name="DATE_REGISTRATION" id="DATE_REGISTRATION" value="#Dateformat(get_list_cargo_.DATE_REGISTRATION,dateformat_style)#"></cfoutput>
                                <span class="input-group-addon btnPointer"><cf_wrk_date_image date_field="DATE_REGISTRATION"></span>
                            </div>
                        </div>
                    </div>
                    <div class="form-group" id="item-sender_id">
                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='60308.Gönderici'></label>
                        <div class="col col-8 col-xs-12">
                            <div class="input-group">
                                <cfoutput> 
                                <cfif isdefined("get_list_cargo_.sender_id") and len(get_list_cargo_.sender_id)>
                                    <cfset sender_name_ = get_emp_info(get_list_cargo_.sender_id,0,0)> 
                                <cfelseif isdefined("get_list_cargo_.sender_comp_id") and len(get_list_cargo_.sender_comp_id)>
                                    <cfset sender_name_ = get_par_info(get_list_cargo_.sender_comp_id,1,1,0)> 
                                <cfelse>
                                    <cfset sender_name_ = ""> 
                                </cfif>
                                <input type="hidden" name="sender_id" id="sender_id"   value="<cfif isdefined("get_list_cargo_.sender_id") and len(get_list_cargo_.sender_id)>#get_list_cargo_.sender_id#</cfif>">
                                <input type="hidden" name="sender_comp_id" id="sender_comp_id"  value="<cfif isdefined("get_list_cargo_.sender_comp_id") and len(get_list_cargo_.sender_comp_id)>#get_list_cargo_.sender_comp_id#</cfif>">
                                <input type="text" name="sender_name" id="sender_name"  autocomplete="off" value ="#sender_name_#" > 
                                <span class="input-group-addon btnPointer icon-ellipsis" title="<cf_get_lang dictionary_id='57734.seçiniz'>" onclick="openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_positions&field_emp_id=upd_cargo.sender_id&field_comp_id=upd_cargo.sender_comp_id&field_name=upd_cargo.sender_name&select_list=1,7');"></span>
                                </cfoutput>
                            </div>
                        </div>
                    </div> 
                    <div class="form-group" id="item-receiver_id">
                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='64077.Alıcı'></label>
                        <div class="col col-8 col-xs-12">
                            <div class="input-group">
                                <cfoutput> <input type="hidden" name="receiver_id" id="receiver_id" value="#get_list_cargo_.receiver_id#"  >
                                <input type="text" name="receiver_name" id="receiver_name"  autocomplete="off" value="<cfif len(get_list_cargo_.receiver_id)>#get_emp_info(get_list_cargo_.receiver_id,0,0)#</cfif>"> </cfoutput>
                                <span class="input-group-addon btnPointer icon-ellipsis" onclick="openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_positions&field_emp_id=upd_cargo.receiver_id&field_name=upd_cargo.receiver_name<cfif fusebox.circuit is "store">&is_store_module=1</cfif>&select_list=1');"></span>  
                            </div>
                        </div>
                    </div> 
                    <div class="form-group" id="item-document_no">
                        <label class="col col-4 col-xs12"><cf_get_lang dictionary_id='57880.Belge No'> </label>
                        <div class="col col-8 col-xs-12">
                            <cfinput type="Text" name="document_no" id="document_no"  value="#get_list_cargo_.document_no#"maxlength="100">	 
                        </div>
                    </div>  
                    <div class="form-group" id="item-sender_date">
                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id ='40913.Gönderi Tarihi'></label>
                        <div class="col col-8 col-xs-12">
                            <div class="input-group">
                                <cfoutput> <input type="text" name="sender_date" id="sender_date" 
                                    autocomplete="off"value="#Dateformat(get_list_cargo_.sender_date,dateformat_style)#"></cfoutput>
                                <span class="input-group-addon btnPointer"><cf_wrk_date_image date_field="sender_date"></span>
                            </div>
                        </div>
                    </div>
                    <div class="form-group" id="item-delivery_date">
                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id ='57645.Teslim Tarihi'></label>
                        <div class="col col-8 col-xs-12">
                            <div class="input-group">
                                <cfoutput> <input type="text" name="delivery_date" id="delivery_date"  autocomplete="off" value="#Dateformat(get_list_cargo_.delivery_date,dateformat_style)#"></cfoutput>
                                <span class="input-group-addon btnPointer"><cf_wrk_date_image date_field="delivery_date"></span>
                            </div>
                        </div>
                    </div>   
                    <div class="form-group" id="item-oldfile">
                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57691.Dosya'></label>
                        <div class="col col-8 col-xs-12">
                            <cfoutput>
                                <input type="file" id="CARGO_FILE" name="CARGO_FILE"  <cfif len(get_list_cargo_.CARGO_FILE)>value="#get_list_cargo_.CARGO_FILE#"</cfif>>
                                <cfif len(get_list_cargo_.CARGO_FILE)>
                                    <input type="checkbox" id="old_file" name="old_file" onchange="old_file_del_control();"/><cf_get_lang dictionary_id='35193.Dosyayı sil'>
                                </cfif>
                                <a href="#request.self#?fuseaction=objects.popup_download_file&file_name=/documents/cargo/#get_list_cargo_.CARGO_FILE#" class="tableyazi">#get_list_cargo_.CARGO_FILE_SERVER_ID#</a> 
                            </cfoutput>
                            </div>
                        </div>
                    </div>
                <div class="col col-6 col-md-4 col-sm-12 column" id="column-2">
                    <div class="form-group" id="item-employee">
                        <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='33211.Teslim Eden'></label>  
                        <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                            <div class="input-group">
                                <cfoutput> 
                                    <input type="hidden" name="delivery_sender_id" id="delivery_sender_id" value="<cfif isdefined("get_list_cargo_.delivery_sender_id") and len(get_list_cargo_.delivery_sender_id)>#get_list_cargo_.delivery_sender_id#</cfif>">
                                    <input name="delivery_sender_name" id="delivery_sender_name" type="text" value="<cfif isdefined("get_list_cargo_.delivery_sender_id") and len(get_list_cargo_.delivery_sender_id)>#get_emp_info(get_list_cargo_.delivery_sender_id,0,0)#</cfif>">
                                    <span class="input-group-addon btnPointer icon-ellipsis" onClick="openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=hr.popup_list_positions&field_emp_id=upd_cargo.delivery_sender_id&field_emp_name=upd_cargo.delivery_sender_name');"></span>
                                </cfoutput> 
                            </div>
                        </div>
                    </div>
                    <div class="form-group" id="item-delivery_receiver">
                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57775.Teslim Alan'></label>
                        <div class="col col-8 col-xs-12">
                            <div class="input-group">
                                <cfoutput>
                                    <input type="hidden" name="delivery_receiver_id" id="delivery_receiver_id"  value="<cfif isdefined("get_list_cargo_.delivery_receiver_id") and len(get_list_cargo_.delivery_receiver_id)>#get_list_cargo_.delivery_receiver_id#</cfif>">
                                    <input type="text" name="delivery_receiver_name" id="delivery_receiver_name" value="<cfif isdefined("get_list_cargo_.delivery_receiver_id") and len(get_list_cargo_.delivery_receiver_id)>#get_emp_info(get_list_cargo_.delivery_receiver_id,0,0)#</cfif>">
                                </cfoutput>
                                <span class="input-group-addon btnPointer icon-ellipsis" title="<cf_get_lang dictionary_id='57734.seçiniz'>" onclick="openBoxDraggable('<cfoutput>#request.self#?fuseaction=objects.popup_list_positions&select_list=1&field_name=upd_cargo.delivery_receiver_name&field_emp_id2=upd_cargo.delivery_receiver_id</cfoutput>');"></span>
                            </div>
                        </div>
                    </div>
                    <div class="form-group" id="item-document_type">
                        <label class="col col-4 col-sm-12"><cf_get_lang dictionary_id='48314.Gönderi Tipi'></label>
                        <div class="col col-8 col-xs-12"> 
                            <div class="col col-3 col-sm-12">
                                <input type="text" name="piece" id="piece" value="<cfif isdefined("get_list_cargo_.piece") and len(get_list_cargo_.piece)><cfoutput>#TLFormat(get_list_cargo_.piece,4)#</cfoutput></cfif>" onkeyup="return(FormatCurrency(this,event,4));" maxlength="10"  placeholder="adet">
                            </div>
                            <div class="col col-3 col-sm-12">
                                <input type="text" name="desi" id="desi" value="<cfif isdefined("get_list_cargo_.desi") and len(get_list_cargo_.desi)><cfoutput>#TLFormat(get_list_cargo_.desi,4)#</cfoutput></cfif>"  onKeyup="return(FormatCurrency(this,event,4));" maxlength="10"  placeholder="desi">
                            </div>
                            <div class="col col-3 col-sm-12">
                                <input type="text" name="kg"  id="kg"  value="<cfif isdefined("get_list_cargo_.kg") and  len(get_list_cargo_.kg)><cfoutput>#TLFormat(get_list_cargo_.kg,4)#</cfoutput></cfif>"  onKeyup="return(FormatCurrency(this,event,4));" maxlength="10" placeholder="kg">
                            </div>
                            <div class="col col-3 col-sm-12">
                                <select name="document_type" id="document_type" tabindex="60">
                                    <option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
                                    <cfoutput query="get_document" >
                                        <option value="#TYPE_ID#"<cfif type_id  eq get_list_cargo_.document_type >selected</cfif>>#DOCUMENT_TYPE#</option>
                                    </cfoutput>
                                </select>
                            </div> 
                        </div>             
                    </div> 
                    <div class="form-group" id="item-payment_method" short="true">
                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id ='30057.Ödeme Şekli'></label>
                        <div class="col col-8 col-xs-12">
                            <div class="col col-4 col-xs-4"><label><input type="radio" name="payment_method" value="1"<cfif  get_list_cargo_.payment_method eq 1 >checked</cfif>><cf_get_lang dictionary_id ='61456.Alıcı Ödemeli'></label></div>
                            <div class="col col-4 col-xs-4"><label><input type="radio" name="payment_method" value="0"<cfif  get_list_cargo_.payment_method eq 0 >checked</cfif>><cf_get_lang dictionary_id ='61457.Gönderici ödemeli'></label>
                            </div>    
                        </div>
                    </div>
                    <div class="form-group" id="item-cargo_price">
                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id ='50724.Ücret'></label>
                        <div class="col col-8 col-xs-12">
                            <div class="input-group">
                                <cfoutput>
                                <input type="text" name="cargo_price" id="cargo_price" onKeyup='return(FormatCurrency(this,event,4));' class="moneybox"  value="#TLFormat(get_list_cargo_.cargo_price,4)#" >
                                <span class="input-group-addon width">
                                    <select name="money_type" id="money_type"  value=""> </cfoutput>
                                    <cfoutput query="get_money">
                                        <option value="#MONEY_ID#" <cfif money_id eq get_list_cargo_.money_type>selected</cfif> >#MONEY#</option> 
                                    </cfoutput>
                                    </select>
                                </span>
                            </div>
                        </div>
                    </div>
                    <div class="form-group" id="item-carrier_company_id">
                        <label class="col col-4 col-sm-12"><cf_get_lang dictionary_id='39248.Taşıyıcı Firma'></label>
                        <div class="col col-8 col-sm-12">
                            <div class="input-group">
                                <cfoutput> <input type="hidden" name="carrier_company_id" id="carrier_company_id"  value="#get_list_cargo_.carrier_company_id#" >
                                <input type="text" name="carrier_company" id="carrier_company" value="<cfif len(get_list_cargo_.carrier_company_id)>#get_par_info(get_list_cargo_.carrier_company_id,1,1,0)#</cfif>" autocomplete="off"></cfoutput>
                                <span class="input-group-addon btnPointer icon-ellipsis" onclick="openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_pars&field_comp_id=upd_cargo.carrier_company_id&field_comp_name=upd_cargo.carrier_company&field_partner=upd_cargo.carrier_partner_id&field_name=upd_cargo.carrier_partner&select_list=2');"></span>                                              
                            </div>
                        </div>              
                    </div>
                    <div class="form-group" id="item-carrier_partner_id">
                        <label class="col col-4 col-sm-12"><cf_get_lang dictionary_id='35783.Taşıyıcı Yetkilisi'></label>
                        <div class="col col-8 col-sm-12">
                            <cfoutput> <input type="hidden" name="carrier_partner_id" id="carrier_partner_id" value="#get_list_cargo_.carrier_partner_id#"> 
                            <input type="text" tabindex="66" name="carrier_partner" id="carrier_partner"  value="<cfif len(get_list_cargo_.carrier_partner_id)>#get_par_info(get_list_cargo_.carrier_partner_id,0,-1,0)#</cfif>">
                            </cfoutput>
                        </div>
                    </div>
                    <div class="form-group" id="item-detail">
                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='36199.Açıklama'></label>
                        <div class="col col-8 col-xs-12">
                            <cfoutput>
                                <textarea name="detail" id="detail" maxlength="300" onkeyup="return ismaxlength(this);" onBlur="return ismaxlength(this);" rows="4"  >#get_list_cargo_.detail#</textarea>
                            </cfoutput>
                        </div>
                    </div>
                </div>
            </cf_box_elements>
            <cf_box_footer>
                <div class="col col-8 col-xs-12">
                    <cfoutput>
                        <cf_record_info query_name="get_list_cargo_" record_emp="RECORD_EMP" udate_emp="UPDATE_EMP">
                    </cfoutput>
                </div>
                <div class="col col-4"><cf_workcube_buttons is_upd='1' add_function='updform()' delete_page_url='V16/correspondence/cfc/PaperAndCargo.cfc?method=DEL_CARGO&cargo_id=#attributes.cargo_id#'></div>
            </cf_box_footer>
        </cfform> 
    </cf_box>
</div>
<script>
    function old_file_del_control() {
        if (document.getElementById('old_file').checked)
            document.getElementById('CARGO_FILE').disabled=true;
        else 
            document.getElementById('CARGO_FILE').disabled=false;
    }
</script>
  