
<cf_catalystHeader>
<div class="col col-12">
    <cf_box>
        <cfform name="add_bank" id="add_bank" method="post" action="#request.self#?fuseaction=#iif(fusebox.circuit eq 'ehesap',DE('ehesap'),DE('finance'))#.emptypopup_add_bank_types">
            <cf_box_elements>
                <div class="col col-6 col-xs-12">
                    <div class="form-group" id="item-bank_type">
                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57521.Banka'> *</label>
                        <div class="col col-8 col-xs-12">
                            <cfinput type="text" name="bank_type" required="yes"  maxlength="150" style="width:150px;">
                        </div>
                    </div>
                    <div class="form-group" id="item-export_type">
                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id="58520.Dosya Türü"></label>
                        <div class="col col-8 col-xs-12">
                            <select name="export_type" id="export_type">
                                <option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
                                <option value="5"><cf_get_lang dictionary_id="39541.Akbank"></option>
                                <option value="4"><cf_get_lang dictionary_id="48739.Denizbank"></option>
                                <option value="7"><cf_get_lang dictionary_id="57717.Garanti"></option>
                                <option value="6"><cf_get_lang dictionary_id="39564.HSBC"></option>
                                <option value="9"><cf_get_lang dictionary_id="39564.HSBC">2</option>
                                <option value="10"><cf_get_lang dictionary_id="39564.HSBC"><cf_get_lang dictionary_id="57677.Döviz"></option>
                                <option value="11"><cf_get_lang dictionary_id="48747.ING"></option>
                                <option value="3"><cf_get_lang dictionary_id="60894.İşbank"></option>
                                <option value="2"><cf_get_lang dictionary_id="48729.TEB"></option>
                                <option value="8"><cf_get_lang dictionary_id="42718.Vakıfbank"></option>
                                <option value="1"><cf_get_lang dictionary_id="39567.Yapı Kredi"></option>
                            </select>
                        </div>
                    </div>
                    <div class="form-group" id="item-bank_code">
                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='59006.Banka Kodu'></label>
                        <div class="col col-8 col-xs-12"> 
                            <input type="text" name="bank_code" id="bank_code" value="" onKeyUp="isNumber(this);" maxlength="4" style="width:150px;">
                        </div>
                    </div>
                    <div class="form-group" id="item-swift_code">
                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id ='29530.Swift Kodu'></label>
                        <div class="col col-8 col-xs-12">
                            <cfinput type="text" name="swift_code" id="swift_code" maxlength="50">
                        </div>
                    </div>
                    <div class="form-group" id="item-company_id">
                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='49909.Kurumsal Üye'></label>
                        <div class="col col-8 col-xs-12">
                            <div class="input-group">
                                <input type="hidden" name="company_id" id="company_id" value="">
                                <input type="text" name="company" id="company" value="" style="width:150px;" onFocus="AutoComplete_Create('company','MEMBER_NAME,MEMBER_CODE','MEMBER_NAME,MEMBER_CODE,MEMBER_PARTNER_NAME','get_member_autocomplete','\'1\',\'0\',\'0\',\'0\',\'2\',\'0\'','COMPANY_ID','company_id','add_bank','3','200');">	  
                                <span class="input-group-addon icon-ellipsis btnPointer " onClick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_all_pars&field_comp_id=add_bank.company_id&field_comp_name=add_bank.company&select_list=2','list');">
                                </span>
                            </div>
                        </div>
                    </div>
                    <div class="form-group" id="item-bank_TYPE">
                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='34102.Banka Tipi'></label>
                        <div class="col col-8 col-xs-12">
                            <cfquery name="get_bank_type_groups" datasource="#dsn#">
                                SELECT * FROM SETUP_BANK_TYPE_GROUPS ORDER BY BANK_TYPE_ID
                            </cfquery>
                            <select name="bank_type_group" id="bank_type_group" style="width:150px;">
                                <option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
                                <cfoutput query="get_bank_type_groups">
                                    <option value="#BANK_TYPE_ID#">#BANK_TYPE#</option>
                                </cfoutput>
                            </select>
                        </div>
                    </div>
                    <div class="form-group" id="item-detail">
                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='36199.Açıklama'></label>
                        <div class="col col-8 col-xs-12">
                            <textarea style="width:150px;height:30px;" name="detail" id="detail"></textarea>
                        </div>
                    </div>
                </div>
            </cf_box_elements>
            <cf_box_footer>
                <cf_workcube_buttons is_upd='0' add_function="controlAddBank()">
            </cf_box_footer>	
        </cfform>
    </cf_box>    
</div>
<script type="text/javascript">
function controlAddBank()
{
	if(!$("#bank_type").val().length)
	{
		alert('<cf_get_lang dictionary_id="58194.girilmesi zorunlu alan">:<cf_get_lang dictionary_id="57521.Banka">');
		return false;	
	}
	return true;
}
</script>