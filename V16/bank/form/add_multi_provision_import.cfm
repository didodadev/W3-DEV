<cf_box title="#getLang('','Toplu Provizyon Dönüşleri','54783')#"popup_box="#iif(isdefined("attributes.draggable"),1,0)#">
    <cfform name="provision_import" enctype="multipart/form-data" method="post" action="#request.self#?fuseaction=bank.emptypopup_multi_provision_import">
        <cf_box_elements>
            <cfinput type="hidden" name="modal_id" id="modal_id" value="#attributes.modal_id#">
            <div class="col col-6 col-md-6 col-sm-6 col-xs-12" type="column" index="1" sort="true">
                <div class="form-group" id="item-bank_type">
                    <label class="col col-4 col-xs-12"><cf_get_lang_main no='109.Banka'> *</label>
                    <div class="col col-8 col-xs-12">
                        <select name="bank_type" id="bank_type">
                            <option value="7"><cf_get_lang dictionary_id="48737.Akbank"></option>
                            <option value="10"><cf_get_lang dictionary_id='48751.Banksoft'></option>
                            <option value="8"><cf_get_lang dictionary_id="48739.Denizbank"></option>
                            <option value="3"><cf_get_lang dictionary_id='48725.Garanti TPOS'></option>
                            <option value="1"><cf_get_lang dictionary_id='57717.Garanti'></option>
                            <option value="2"><cf_get_lang dictionary_id="48720.HSBC"></option>
                            <option value="5"><cf_get_lang dictionary_id="48730.İşBankası"></option>
                            <option value="4"><cf_get_lang dictionary_id="48729.TEB"></option>
                            <option value="6"><cf_get_lang dictionary_id='48784.YKB'></option>
                            <option value="9"><cf_get_lang dictionary_id='42764.ING Bank'></option>
                        </select>
                    </div>
                </div>
                <div class="form-group" id="item-uploaded_file">
                    <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57468.Belge'> *</label>
                    <div class="col col-8 col-xs-12">
                        <input type="file" name="uploaded_file" >
                    </div>
                </div>
                <div class="form-group" id="item-process_date">
                    <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57742.Tarih'>*</label>
                    <div class="col col-8 col-xs-12">
                        <div class="input-group">
                            <cfsavecontent variable="message"><cf_get_lang dictionary_id='58503.Lütfen Tarih Giriniz'></cfsavecontent>
                            <cfinput value="#dateformat(now(),dateformat_style)#" required="Yes" message="#message#" type="text" name="process_date" style="width:180px;" validate="#validate_style#" maxlength="10">
                            <span class="input-group-addon"><cf_wrk_date_image date_field="process_date"></span>
                        </div>
                    </div>
                </div>
                <div class="form-group" id="item-uploaded_file">
                    <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='48918.Anahtar'>*</label>
                    <div class="col col-8 col-xs-12">
                        <input name="key_type" id="key_type" type="password" autocomplete="off" >
                    </div>
                </div>
            </div>
        </cf_box_elements>
        <cf_box_footer>
            <div class="col col-12">
                <cf_workcube_buttons type_format="1" is_upd='0' add_function='kontrol()&&#iif(isdefined("attributes.draggable"),DE("loadPopupBox('provision_import' , #attributes.modal_id#)"),DE(""))#'>                      
            </div>
        </cf_box_footer>
    </cfform>
</cf_box>
<script type="text/javascript">
function kontrol()
{
	if(provision_import.key_type.value == "")
	{
		alert("<cf_get_lang dictionary_id='48964.Anahtar Giriniz'>!");
		return false;
	}
	if(provision_import.bank_type.value=="")
	{
		alert("<cf_get_lang dictionary_id='58940.Banka Seçiniz'>!");
		return false;
	}
	return true;
}
</script>
