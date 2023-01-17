<!---
    File:V16\correspondence\form\add_paperandcargo.cfm
    Controller:WBO\controller\PaperAndCargoController.cfm
    Author: Fatma zehra Dere
    Date: 2020-12-04
    Description:
    Gelen giden evrak ve kargo işlemlerinin eklendiği sayfadır
    Correspendence kullanım sayfasıdır.
    History:
    To Do:
--->
<cfset comp    = createObject("component","V16.correspondence.cfc.PaperAndCargo") />
<cfset get_document = comp.get_document()/>
<cfset get_money=comp.GET_MONEY() />
<cfparam  name="attributes.carrier_company" default="">
<cfparam  name="attributes.carrier_partner" default="">
<cfparam  name="attributes.carrier_partner_id" default="">
<cfparam  name="attributes.carrier_company_id" default="">
<cfset save_folder      = "#upload_folder#cargo#dir_seperator#" />
    <!--- Dizin kontrolü --->
	<cfif Not DirectoryExists("#save_folder#")>
		<cfdirectory action="create" directory="#save_folder#" />
    </cfif>
<cf_catalystHeader>
<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
    <cf_box>
        <cfform name="add_cargo"  action="V16/correspondence/cfc/PaperAndCargo.cfc?method=ADD_CARGO" enctype="multipart/form-data" method="post">
            <input type="hidden" name="save_folder" id="save_folder" value="<cfoutput>#save_folder#</cfoutput>" />
            <cf_box_elements>
                <div class="col col-6 col-md-4 col-sm-12 column" type="column" index="1" sort="true">
                    <div class="form-group" id="item-process_stage">
                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='58859.Süreç'></label>
                        <div class="col col-8 col-xs-12">
                            <cf_workcube_process is_upd='0' process_cat_width='150' is_detail='0'>
                        </div>
                    </div>
                    <div class="form-group" id="item-coming_out">
                        <label class="col col-4 col-xs12"><cf_get_lang dictionary_id='58974.Gelen'>/<cf_get_lang dictionary_id='58975.Giden'> *</label>  
                        <div class="col col-8 col-xs-12">
                            <select name="coming_out" id="coming_out">
                                <option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
                                <option value="1"<cfif isDefined("attributes.coming_out") and (attributes.coming_out eq 1)> selected</cfif>><cf_get_lang dictionary_id ='58974.Gelen'></option>
                                <option value="2"<cfif isDefined("attributes.coming_out") and (attributes.coming_out eq 2)> selected</cfif>><cf_get_lang dictionary_id ='58975.Giden'></option>
                            </select>
                        </div>
                    </div>
                    <div class="form-group" id="item-document_registration_no">
                        <label class="col col-4 col-xs12"><cf_get_lang dictionary_id='48274.Evrak No'>/<cf_get_lang dictionary_id='31257.Kayıt No'> </label>
                        <div class="col col-8 col-xs-12">
                            <cfinput type="Text" name="document_registration_no" id="document_registration_no"  maxlength="100" value="">	
                        </div>
                    </div>                            
                    <div class="form-group" id="item-DATE_REGISTRATION">
                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id ='57627.Kayıt Tarihi'></label>
                        <div class="col col-8 col-xs-12">
                            <div class="input-group">
                                <cfinput type="text" name="DATE_REGISTRATION" id="DATE_REGISTRATION"   autocomplete="off" value="" >
                                <span class="input-group-addon btnPointer"><cf_wrk_date_image date_field="DATE_REGISTRATION"></span>
                            </div>
                        </div>
                    </div>
                    <div class="form-group" id="item-sender_name">
                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='60308.Gönderici'>*</label>
                        <div class="col col-8 col-xs-12">
                            <div class="input-group">
                                <input type="hidden" name="sender_id" id="sender_id" value=""  >
                                <input type="hidden" name="sender_comp_id" id="sender_comp_id"  value="">
                                <input type="text" name="sender_name" id="sender_name"  autocomplete="off" value=""  onfocus="AutoComplete_Create('sender_name','MEMBER_NAME,MEMBER_PARTNER_NAME','MEMBER_PARTNER_NAME2,MEMBER_NAME2','get_member_autocomplete','\'1,3\',0,0','PARTNER_ID2,MEMBER_TYPE','sender_id,sender_comp_id,deliver_member_type','','3','250');" >
                                <span class="input-group-addon btnPointer icon-ellipsis" title="<cf_get_lang dictionary_id='57734.seçiniz'>" onclick="openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_positions&field_emp_id=add_cargo.sender_id&field_comp_id=add_cargo.sender_comp_id&field_name=add_cargo.sender_name&select_list=1,7');"></span>
                            </div>
                        </div>
                    </div>
                    <div class="form-group" id="item-receiver_name">
                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='64077.Alıcı'>*</label>
                        <div class="col col-8 col-xs-12">
                            <div class="input-group">
                                <input type="hidden" name="receiver_id" id="receiver_id" value="" >
                                <input type="text" tabindex="66" name="receiver_name" id="receiver_name" onfocus="AutoComplete_Create('receiver_name','FULLNAME','FULLNAME','get_emp_pos','','POSITION_CODE','carrier_receiver_id','','3','130');" autocomplete="off">	
                                <span class="input-group-addon btnPointer icon-ellipsis" onclick="openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_positions&field_emp_id=add_cargo.receiver_id&field_name=add_cargo.receiver_name<cfif fusebox.circuit is "store">&is_store_module=1</cfif>&select_list=1');"></span>                        
                            </div>
                        </div>
                    </div>  
                    <div class="form-group" id="item-document_no">
                        <label class="col col-4 col-xs12"><cf_get_lang dictionary_id='57880.Belge No'> </label>
                        <div class="col col-8 col-xs-12">
                            <cfinput type="Text" name="document_no" id="document_no"  maxlength="100 " value=""  >							 
                        </div>
                    </div>     
                    <div class="form-group" id="item-sender_date">
                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id ='40913.Gönderi Tarihi'></label>
                        <div class="col col-8 col-xs-12">
                            <div class="input-group">
                                <input type="text" name="sender_date" id="sender_date"   autocomplete="off" value=""  value=""  >
                                <span class="input-group-addon btnPointer"><cf_wrk_date_image date_field="sender_date"></span>
                            </div>
                        </div>
                    </div>
                    <div class="form-group" id="item-delivery_date">
                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id ='57645.Teslim Tarihi'></label>
                        <div class="col col-8 col-xs-12">
                            <div class="input-group">
                                <input type="text" name="delivery_date" id="delivery_date" autocomplete="off"  value=""  >
                                <span class="input-group-addon btnPointer"><cf_wrk_date_image date_field="delivery_date"></span>
                            </div>
                        </div>
                    </div>
                    <div class="form-group" id="item-CARGO_FILE">
                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57691.Dosya'></label>
                        <div class="col col-8 col-xs-12">
                        <cfinput id="cargo_file" name="cargo_file" type="file" value=""  >
                        </div>
                    </div>
                </div>
                <div class="col col-6 col-md-4 col-sm-12 column" type="column" index="2" sort="true">
                    <div class="form-group" id="item-employee">
                        <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='33211.Teslim Eden'></label>  
                        <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                            <div class="input-group">
                                <input type="hidden" name="delivery_sender_id" id="delivery_sender_id" value="">
                                <cfinput name="delivery_sender_name" id="delivery_sender_name" type="text" >
                                <span class="input-group-addon btnPointer icon-ellipsis" onClick="openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=hr.popup_list_positions&field_emp_id=add_cargo.delivery_sender_id&field_emp_name=add_cargo.delivery_sender_name');"></span>
                            </div>
                        </div>
                    </div>
                    <div class="form-group" id="item-delivery_receiver">
                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57775.Teslim Alan'></label>
                        <div class="col col-8 col-xs-12">
                            <div class="input-group">
                                <cfoutput>
                                    <input type="hidden" name="delivery_receiver_id" id="delivery_receiver_id">
                                    <input type="text" name="delivery_receiver_name" id="delivery_receiver_name">
                                </cfoutput>
                                <span class="input-group-addon btnPointer icon-ellipsis" title="<cf_get_lang dictionary_id='57734.seçiniz'>" onclick="openBoxDraggable('<cfoutput>#request.self#?fuseaction=objects.popup_list_positions&select_list=1&field_name=add_cargo.delivery_receiver_name&field_emp_id2=add_cargo.delivery_receiver_id</cfoutput>');"></span>
                            </div>
                        </div>
                    </div>
                    <div class="form-group" id="item-document_type">
                        <label class="col col-4 col-sm-12"><cf_get_lang dictionary_id='48314.Gönderi Tipi'></label>
                        <div class="col col-8 col-xs-12"> 
                            <div class="col col-3 col-sm-12">
                                <cfinput type="text" name="piece" id="piece" placeholder="#getLang('','adet','58082')#" onkeyup="return(FormatCurrency(this,event,4));">
                            </div>
                            <div class="col col-3 col-sm-12">
                                <cfinput type="text" name="desi" id="desi" placeholder="#getLang('','adet','33088')#" onkeyup="return(FormatCurrency(this,event,4));">
                            </div>
                            <div class="col col-3 col-sm-12">
                                <cfinput type="text" name="kg" id="kg" placeholder="#getLang('','adet','37188')#" onkeyup="return(FormatCurrency(this,event,4));">
                            </div>
                            <div class="col col-3 col-sm-12">
                                <select name="document_type" id="document_type" tabindex="60">
                                    <option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
                                    <cfoutput query="get_document" >
                                        <option value="#TYPE_ID#">#DOCUMENT_TYPE#</option>
                                    </cfoutput>
                                </select>
                            </div> 
                        </div>             
                    </div> 
                    <div class="form-group" id="item-payment_method">
                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id ='30057.Ödeme Şekli'>*</label>
                        <div class="col col-8 col-xs-12">
                            <div class="col col-4 col-xs-4"><label><input type="radio" name="payment_method" id="payment_method" value="1"><cf_get_lang dictionary_id ='61456.Alıcı Ödemeli'></label></div>
                            <div class="col col-4 col-xs-4"><label><input type="radio" name="payment_method" id="payment_method" value="0"><cf_get_lang dictionary_id ='61457.Gönderici Ödemeli'></label></div>
                        </div>
                    </div>
                    <div class="form-group" id="item-cargo_price">
                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id ='50724.Ücret'>*</label>
                        <div class="col col-8 col-xs-12">
                            <div class="input-group">
                                <input type="text" name="cargo_price" id="cargo_price" value="" onKeyup='return(FormatCurrency(this,event,4));' class="moneybox"  value="">
                                <span class="input-group-addon width">
                                    <select name="money_type" id="money_type">
                                    <cfoutput query="get_money">
                                        <option value="#MONEY_ID#">#MONEY#</option> 
                                    </cfoutput>
                                    </select>
                                </span>
                            </div>
                        </div>
                    </div>
                    <div class="form-group" id="item-carrier_company_id">
                        <label class="col col-4 col-sm-12"><cf_get_lang dictionary_id='39248.Taşıyıcı Firma'>*</label>
                        <div class="col col-8 col-sm-12">
                            <div class="input-group">
                                <input type="hidden" name="carrier_company_id" id="carrier_company_id"  value="">
                                <input type="text" name="carrier_company" id="carrier_company"   autocomplete="off"value="<cfoutput>#attributes.carrier_company#</cfoutput>" >
                                <span class="input-group-addon btnPointer icon-ellipsis" onclick="openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_pars&field_comp_id=add_cargo.carrier_company_id&field_comp_name=add_cargo.carrier_company&field_name=add_cargo.carrier_partner&field_partner=add_cargo.carrier_partner_id&select_list=2');"></span>                        
                            </div>
                        </div>              
                    </div>
                    <div class="form-group" id="item-carrier_partner">
                        <label class="col col-4 col-sm-12"><cf_get_lang dictionary_id='35783.Taşıyıcı Yetkilisi'></label>
                        <div class="col col-8 col-sm-12">
                            <input type="hidden" name="carrier_partner_id" id="carrier_partner_id" value="">
                            <input type="text" tabindex="66" name="carrier_partner" id="carrier_partner" autocomplete="off" readonly value="">
                        </div>              
                    </div>
                    <div class="form-group" id="item-detail">
                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='36199.Açıklama'></label>
                        <div class="col col-8 col-xs-12">
                            <textarea name="detail" id="detail" maxlength="300" onkeyup="return ismaxlength(this);" onBlur="return ismaxlength(this);" rows="4" ></textarea>
                        </div>
                    </div>
                </div>
            </cf_box_elements>
            <cf_box_footer>
                <div class="col col-12"><cf_workcube_buttons is_upd='0' add_function="saveform()"></div>
            </cf_box_footer>
        </cfform>
    </cf_box>
</div>
<script>
  function saveform()
   {
		if(document.getElementById('coming_out').value == "")
		{
			alert("<cf_get_lang_main no='782.Zorunlu Alan'>:<cf_get_lang dictionary_id='58974.Gelen'>/<cf_get_lang dictionary_id='58975.Giden'>!");
			document.getElementById('coming_out').focus();
			return false;
        }
        if(document.getElementById('sender_name').value == "")
		{
			alert("<cf_get_lang_main no='782.Zorunlu Alan'>:<cf_get_lang dictionary_id='60308.Gönderici'>!");
			document.getElementById('sender_name').focus();
			return false;
        }
        if(document.getElementById('receiver_name').value == "")
		{
			alert("<cf_get_lang_main no='782.Zorunlu Alan'>:<cf_get_lang dictionary_id='64077.Alıcı'>!");
			document.getElementById('receiver_name').focus();
			return false;
        }
        if(document.getElementById('payment_method').value == "")
		{
			alert("<cf_get_lang_main no='782.Zorunlu Alan'>:<cf_get_lang dictionary_id ='30057.Ödeme Şekli'>!");
			document.getElementById('payment_method').focus();
			return false;
        }
        if(document.getElementById('carrier_company').value == "")
		{
			alert("<cf_get_lang_main no='782.Zorunlu Alan'>:<cf_get_lang dictionary_id='39248.Taşıyıcı Firma'>!");
			document.getElementById('carrier_company').focus();
			return false;
        }
        if(document.getElementById('cargo_price').value == "")
		{
			alert("<cf_get_lang_main no='782.Zorunlu Alan'>:<cf_get_lang dictionary_id ='50724.Ücret'>!");
			document.getElementById('cargo_price').focus();
			return false;
        }
    }
</script> 
