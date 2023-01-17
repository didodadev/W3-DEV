<cfquery name="get_our_company" datasource="#dsn#">
	SELECT 
	    COMP_ID, 
        COMPANY_NAME, 
        ADDRESS, 
        RECORD_EMP, 
        RECORD_DATE, 
        RECORD_IP,
        UPDATE_EMP, 
        UPDATE_DATE, 
        UPDATE_IP
    FROM 
    	OUR_COMPANY
</cfquery>
<cfparam  name="attributes.modal_id" default="">
<cf_box title="#getLang('','','43477')#"popup_box="#iif(isdefined("attributes.draggable"),1,0)#">
    <cfform name="add_bank_relation" method="post" action="#request.self#?fuseaction=settings.emptypopup_add_bank_relation">
        <cf_box_elements>
            <div class="col col-6 col-md-6 col-sm-6 col-xs-12" type="column" index="1" sort="true">
                <div class="form-group" id="item-bank_name">
                    <label class="col col-4 col-xs12"><cf_get_lang dictionary_id='57521.Banka'></label>
                    <div class="col col-8 col-xs-12"><cfoutput>#attributes.bank_name#</cfoutput></div>
                </div>
                <div class="form-group" id="item-bank_id"> 
                    <label class="col col-4 col-xs12"><cf_get_lang dictionary_id='63893.Şirket'></label>
                    <input type="hidden" name="bank_id" id="bank_id" value="<cfoutput>#attributes.bank_id#</cfoutput>">
                    <div class="col col-8 col-xs-12">
                        <select name="our_company" id="our_company" style="width:180px;" onChange="showBranches()">
                            <cfoutput query="get_our_company"> 
                                <option value="#comp_id#">#company_name#</option>
                            </cfoutput> 
                        </select>
                    </div>
                </div>
                <div class="form-group" id="item-BRANCH_PLACE">
                    <label class="col col-4 col-xs12"><cf_get_lang dictionary_id='57453.Şube'></label>
                    <div class="col col-8 col-xs-12"id="BRANCH_PLACE"><cf_get_lang dictionary_id='54096.Şirket Seçiniz'></div>
                </div>
                <div class="form-group" id="item-relation_number"> 
                    <label class="col col-4 col-xs12"><cf_get_lang dictionary_id='43742.İlişki Numarası'>*</label>
                    <div class="col col-8 col-xs-12"><cfinput type="text" name="relation_number" value="" style="width:180px;" maxlength="50" required="yes" message="İlişki Numarası Girmelisiniz!"></div>
                </div>
                <div class="form-group" id="item-bank_account_code"> 
                    <label class="col col-4 col-xs12"><cf_get_lang dictionary_id='43743.Banka Hesap Kodu'></label>
                    <div class="col col-8 col-xs-12"><cfinput type="text" name="bank_account_code" value="" style="width:180px;" maxlength="15"></div>
                </div>
                <div class="form-group" id="item-bank_branch_code"> 
                    <label class="col col-4 col-xs12"><cf_get_lang dictionary_id='43744.Banka Şube Kodu'></label>
                    <div class="col col-8 col-xs-12"><cfinput type="text" name="bank_branch_code" value="" style="width:180px;" maxlength="5"></div>
                </div>
                <div class="form-group" id="item-bank_user_code"> 
                    <label class="col col-4 col-xs12"><cf_get_lang dictionary_id='58522.Kullanıcı Kodu'></label>
                    <div class="col col-8 col-xs-12"><cfinput type="text" name="bank_user_code" value="" style="width:180px;" maxlength="10"></div>
                </div>
                <div class="form-group" id="item-iban_no">
                    <label class="col col-4 col-xs12"><cf_get_lang dictionary_id='54332.IBAN No'></label>
                    <div class="col col-8 col-xs-12"><cfinput type="text" name="iban_no" value="" style="width:180px;" maxlength="26"></div>
                </div>
            </div>
        </cf_box_elements>
        <cf_box_footer><cf_workcube_buttons is_upd='0' add_function='#iif(isdefined("attributes.draggable"),DE("loadPopupBox('add_bank_relation' , #attributes.modal_id#)"),DE(""))#'></cf_box_footer>
    </cfform>
</cf_box>
<script type="text/javascript">
function showBranches()
	{
		var tmp = document.add_bank_relation.our_company.value;
    	var send_address = "<cfoutput>#request.self#</cfoutput>?fuseaction=settings.emptypopup_get_branches_for_add_relation&company_id=";
		send_address +=tmp;
		AjaxPageLoad(send_address,'BRANCH_PLACE');
	}
showBranches();
</script>
