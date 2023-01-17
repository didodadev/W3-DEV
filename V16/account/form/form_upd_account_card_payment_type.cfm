<cfscript>
	netbook = createObject("component","V16.e_government.cfc.netbook");
	netbook.dsn = dsn;
	netbook.dsn2 = dsn2;

	getAccountCardPaymentTypes_ = netbook.getAccountCardPaymentTypes(
		payment_type_id : attributes.payment_type_id
	);
	checkIfUsed = netbook.checkPaymentTypeIfUsed(
		payment_type_id : attributes.payment_type_id
	);
</cfscript>

<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
	<cfsavecontent variable="head"><cf_get_lang dictionary_id='31361.Ödeme Şekilleri'></cfsavecontent>
	<cf_box title="#head#" add_href="#request.self#?fuseaction=account.form_add_account_card_payment_type" is_blank="0">
		<div class="col col-3 col-md-3 col-sm-3 col-xs-12">
            <cfinclude template="../display/list_account_card_payment_type.cfm">
        </div> 
        <div class="col col-9 col-md-9 col-sm-9 col-xs-12">
            <cfform  method="post" name="account_card_payment_type" action="#request.self#?fuseaction=account.emptypopup_upd_account_card_payment_type">
                <input type="hidden" name="payment_type_id" id="payment_type_id" value="<cfoutput>#attributes.payment_type_id#</cfoutput>">
                <cf_box_elements>
                    <div class="col col-6 col-md-6 col-sm-6 col-xs-12" index="1" type="column" sort="true">
                        <div class="form-group" id="payment_type">
                            <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id="30057.Ödeme Şekli">*</label>
                            <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                                <div class="input-group">
                                    <input type="Text" <cfif attributes.payment_type_id lt 0 or checkIfUsed eq 1>readonly</cfif> name="payment_type" id="payment_type" value="<cfoutput>#getAccountCardPaymentTypes_.payment_type#</cfoutput>">		
                                    <span class="input-group-addon">
                                        <cf_language_info 
                                        table_name="ACCOUNT_CARD_PAYMENT_TYPES" 
                                        column_name="PAYMENT_TYPE" 
                                        column_id_value="#url.payment_type_id#" 
                                        maxlength="500" 
                                        datasource="#dsn#" 
                                        column_id="PAYMENT_TYPE_ID" 
                                        control_type="0">
                                    </span>	
                                </div>				
                            </div>	
                        </div>
                        <div class="form-group" id="detail">
                            <label class="col col-4 col-md-4 col-sm-4 col-xs-12" style="valign:top;"><cf_get_lang dictionary_id='57629.Açıklama'></label>
                                <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                                    <cfinput type="text" name="detail" id="detail" value="#getAccountCardPaymentTypes_.detail#">
                                </div>
                        </div>
                    </div>
                    <div  class="col col-6 col-md-6 col-sm-6 col-xs-12" index="2" type="column" sort="true">
                        <div class="form-group" id="is_active">
                            <input type="checkbox" name="is_active" id="is_active" value="1" <cfif getAccountCardPaymentTypes_.is_active eq 1>checked</cfif> <cfif attributes.payment_type_id lt 0>disabled</cfif> />&nbsp;<cf_get_lang_main no='81.Aktif'>
                        </div>
                    </div>
                </cf_box_elements>
                <cf_box_footer>
                    <cf_record_info query_name="getAccountCardPaymentTypes">
                        <cfif attributes.payment_type_id lt 0 or checkIfUsed eq 1>
                            <cf_workcube_buttons is_upd='1' is_delete='0' add_function="kontrol()">
                        <cfelse>
                            <cf_workcube_buttons is_upd='1' delete_page_url='#request.self#?fuseaction=account.emptypopup_del_account_card_payment_type&PAYMENT_TYPE_ID=#attributes.PAYMENT_TYPE_ID#' add_function="kontrol()">
                        </cfif>
                </cf_box_footer>
            </cfform>    
        </div> 
  	</cf_box>
</div>

<script>
	function kontrol()
	{
		if(document.getElementById("payment_type").value == '')
		{
			alert('<cf_get_lang dictionary_id='30058.Ödeme Şekli Girmelisiniz'>!')
			return false;
		}
	}
</script>
