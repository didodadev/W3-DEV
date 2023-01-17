<cfparam name="is_dsp_cari_member" default="0">
<cf_xml_page_edit fuseact="account.form_add_bill_payment">
<cfinclude template="../query/control_bill_no.cfm">
<cfinclude template="../query/get_money_doviz.cfm">
<cfquery name="get_money_bskt" datasource="#dsn#">
	SELECT MONEY,RATE1,RATE2 FROM SETUP_MONEY WHERE COMPANY_ID = #session.ep.company_id# AND PERIOD_ID = #session.ep.period_id# AND MONEY_STATUS = 1 AND MONEY <> '#session.ep.money#'
</cfquery>
<cfscript>
	netbook = createObject("component","V16.e_government.cfc.netbook");
	netbook.dsn = dsn;
	get_account_card_document_types = netbook.getAccountCardDocumentTypes(is_company : 1, is_active : 1);
	get_account_card_payment_types = netbook.getAccountCardPaymentTypes(is_active : 1);
	//sirket akis parametrelerinde "islem dövizi ile muhasebe hareketi yapilsin" secenegini kontrol eder
	get_bill_info = createObject("component","V16.account.cfc.get_bill_info");
	get_bill_info.dsn = dsn;
	get_comp_info = get_bill_info.getBillInfo();
</cfscript>
<cfif isDefined("EQ")>
	<script type="text/javascript">
		alert("<cf_get_lang dictionary_id='56865.Bu Fiş Numarası Mevcut'>. <cf_get_lang dictionary_id='56875.Lütfen Yeni Bir Fiş No Giriniz'>!");
	</script>
</cfif>
<cf_catalystHeader>
<cf_papers paper_type="cash_payment">
<cf_box>
<cfform name="add_bill" id="add_bill" action="#request.self#?fuseaction=account.emptypopup_add_bill_payment" method="post">
<cf_box_elements>
	<input type="hidden" name="active_period" id="active_period" value="<cfoutput>#session.ep.period_id#</cfoutput>">
	<input type="hidden" name="kur_say" id="kur_say" value="<cfoutput>#get_money_bskt.recordcount#</cfoutput>">
	<input type="hidden" name="money_type" id="money_type" value="">
    <input type="hidden" name="card_id" id="card_id" value="" />
    				<div class="col col-3 col-md-4 col-sm-6 col-xs-12" type="column" index="1" sort="true">
                    	<div class="form-group" id="item-checkboxes">
                        	<label class="col col-4 col-xs-12 hide" ><cf_get_lang dictionary_id='44648.Dövizli İşlem'><cfif session.ep.our_company_info.is_ifrs eq 1>/<cf_get_lang dictionary_id='58130.UFRS Kod'>/<cf_get_lang dictionary_id='57789.Özel Kod'></cfif></label>
                        	<label class="col col-4 col-xs-12">
                                <cf_get_lang dictionary_id='44648.Dövizli İşlem'>
                                <input type="checkbox" name="is_other_currency" id="is_other_currency" value="1" onClick="other_money_action();" <cfif get_comp_info.is_other_money>disabled="disabled"</cfif> <cfif get_comp_info.is_other_money>checked</cfif>>&nbsp;                    
                            </label>
                            <cfif session.ep.our_company_info.is_ifrs eq 1>
                                <div class="col col-12 col-xs-12">
                                    <label  class="col col-6 col-xs-12">
                                        <cf_get_lang dictionary_id='58130.UFRS Kod'>
                                        <input type="checkbox" name="is_ifrs" id="is_ifrs" value="1" onClick="ifrs_action();" checked>&nbsp;
                                    </label>
                                    <label  class="col col-6 col-xs-12">
                                        <cf_get_lang dictionary_id='57789.Özel Kod'>
                                        <input type="checkbox" name="is_account_code2" id="is_account_code2" value="1" onClick="private_code_action();">
                                    </label>
                                </div>
                            </cfif>
                        </div>
                        <div class="form-group" id="item-process_date">
                        	<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57742.Tarih'> *</label>
                            <div class="col col-8 col-xs-12">
                            	<div class="input-group">
									<cfinput type="text" name="process_date" maxlength="10" validate="#validate_style#"  onblur="change_money_info('add_bill','process_date');">
                    				<span class="input-group-addon btnPointer"><cf_wrk_date_image date_field="process_date" call_function="change_money_info"></span>
                                </div>
                            </div>
                        </div>
                        <div class="form-group" id="item-process_cat">
                        	<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='61806.İşlem Tipi'> *</label>
                			<div class="col col-8 col-xs-12">
                                <cf_workcube_process_cat slct_width="180px;">
							</div>
                        </div>
                        <div class="form-group" id="item-paper_no">
                        	<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57880.Belge No'></label>
                			<div class="col col-8 col-xs-12">
                                <cfinput type="text" name="paper_no" id="paper_no" value="#paper_code#-#paper_number#"  maxlength="25">
							</div>
                        </div>
                        <div class="form-group" id="item-document_type">
                        	<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='58533.Belge Tipi'></label>
                			<div class="col col-8 col-xs-12">
                                <select name="document_type" id="document_type"  onchange="display_duedate()">
                                    <option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
                                    <cfoutput query="get_account_card_document_types">
                                        <option value="#document_type_id#">#document_type#</option>
                                    </cfoutput>
                                </select>
							</div>
                        </div>
						<div class="form-group" id="item-payment_type">
                        	<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='30057.Ödeme Şekli'></label>
                			<div class="col col-8 col-xs-12">
                                <select name="payment_type" id="payment_type" >
                                    <option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
                                    <cfoutput query="get_account_card_payment_types">
                                        <option value="#payment_type_id#">#payment_type#</option>
                                    </cfoutput>
                                </select>
							</div>
                        </div>
                        <div class="form-group" id="item-other">
                        	<label class="col col-4 col-xs-12" id="text_other_money" style="display:none;"><cf_get_lang dictionary_id='58121.İşlem Dövizi'></label>
                            <div class="col col-8 col-xs-12" id="main_other_money" style="display:none;">
                            	<div class="input-group">
                                <input type="text" name="other_cash_amount" id="other_cash_amount" class="moneybox" value="0"onkeyup="return(FormatCurrency(this,event));">
                                <span class="input-group-addon no-bg"></span>
                                <select name="other_cash_currency" id="other_cash_currency" onChange="f_total_hesapla(this.value);" >
                                    <cfoutput query="get_money_doviz">
                                        <option value="#money#" <cfif money is session.ep.money>selected</cfif>>#money#</option>
                                    </cfoutput>
                                </select>
                                </div>
                            </div>
                        </div>
                    </div>
    				<div class="col col-3 col-md-4 col-sm-6 col-xs-12" type="column" index="2" sort="true">
						<cfif xml_acc_project_info>
                        	<div class="form-group" id="item-project_id">
                            	<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57416.Proje'></label>
                            	<div class="col col-8 col-xs-12">
                                    <div class="input-group">
                                        <input type="hidden" name="project_id" id="project_id" value="">
                                        <input type="text" name="project_name" id="project_name" value=""  onFocus="AutoComplete_Create('project_name','PROJECT_HEAD','PROJECT_HEAD','get_project','','PROJECT_ID','project_id','list_works','3','250');" autocomplete="off">
                                        <span class="input-group-addon btnPointer icon-ellipsis" onclick="openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_projects&project_id=add_bill.project_id&project_head=add_bill.project_name')"></span> 
                                    </div>
                            	</div>
                            </div>
                        </cfif>
                    	<div class="form-group" id="item-cash_acc_code">
                        	<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='47301.Kasa Hesap Adı'> *</label>
                			<div class="col col-8 col-xs-12">
                                <cfinclude template="../query/get_cash_plan.cfm">
                                <select name="cash_acc_code" id="cash_acc_code" >
                                    <option value=""><cf_get_lang no='45.Kasa Seçiniz'></option>
                                    <cfoutput query="get_cash_plan">
                                        <option value="#account_code#"<cfif isdefined("get_account_rows_main") and (get_account_rows_main.account_id is account_code)> selected</cfif>>#account_name#</option>
                                    </cfoutput>
                                </select>
							</div>
                        </div>
                        <div class="form-group" id="item-cash_detail">
                        	<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='47408.Satır Açıklama'></label>
                			<div class="col col-8 col-xs-12">
                                <input type="text" name="cash_detail" id="cash_detail" value=""  maxlength="100">
							</div>
                        </div>
                        <div class="form-group" id="item-cash_claim">
                        	<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57588.Alacak'></label>
                			<div class="col col-8 col-xs-12">
                                <input type="text" name="cash_claim" id="cash_claim" value="0" class="moneybox"  readonly>
							</div>
                        </div>
                        <cfif len(session.ep.money2)>
                            <div class="form-group" id="item-cash_amount_2">
                                <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='47485.Sistem 2. Döviz'></label>
                                <div class="col col-8 col-xs-12">
                                    <input type="text" name="cash_amount_2" id="cash_amount_2" value="0" class="moneybox" readonly >
                                </div>
                            </div>
                        </cfif>
                        
                        <div class="form-group" id="tr_due_date" style="display:none;">
                        	<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57881.Vade Tarihi'></label>
                			<div class="col col-8 col-xs-12">
                            	<div class="input-group">
                            		<cfinput type="text" name="due_date" maxlength="10" validate="#validate_style#"  valign="top">
                                    <span class="input-group-addon btnPointer"><cf_wrk_date_image date_field="due_date" call_function="change_money_info"></span>
                                </div>
							</div>
                        </div>
                    </div>
                    <div class="col col-3 col-md-4 col-sm-6 col-xs-12" type="column" index="3" sort="false">
	                    <div class="form-group" id="item-bill_detail">
                        	<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='36199.Açıklama'></label>
                			<div class="col col-8 col-xs-12">
                                <textarea name="bill_detail" id="bill_detail" ></textarea>
							</div>
                        </div>
                    	<cfif is_dsp_cari_member eq 1>
                            <div class="form-group" id="item-member_name">
                                <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57519.Cari Hesap'></label>
                                <div class="col col-8 col-xs-12">
                                    <div class="input-group">
                                        <input type="hidden" name="member_type" id="member_type" value="">
                                        <input type="hidden" name="member_id" id="member_id" value="">
                                        <input type="text" name="member_name" id="member_name" value="" >
                                    	<span class="input-group-addon btnPointer icon-ellipsis" title="<cf_get_lang dictionary_id='57734.Seçiniz'>" onclick="openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_pars&field_member_name=add_bill.member_name&field_name=add_bill.member_name&field_type=add_bill.member_type&field_comp_id=add_bill.member_id&field_consumer=add_bill.member_id&select_list=2,3<cfif session.ep.isBranchAuthorization>&is_store_module=1</cfif>');"></span>
                                    </div>
                                </div>
                            </div>
                        </cfif>
                    </div>
                    <div class="col col-3 col-md-4 col-sm-6 col-xs-12" type="column" index="3" sort="true">
                        <div class="col col-12 padding-left-5">
                        	<label class="col col-12 bold"><cfif get_money_bskt.recordcount><cf_get_lang dictionary_id='57677.Döviz'></cfif></label>
                        </div>
                        <div class="col col-12">
                            <div class="row">
                               
                                     <cfif session.ep.rate_valid eq 1>
                                            <cfset readonly_info = "yes">
                                    <cfelse>
                                        <cfset readonly_info = "no">
                                    </cfif>
                                    <cfif get_money_bskt.recordcount>
                                        <cfoutput query="get_money_bskt">
                                            <div class="form-group">
                                                <input type="hidden" name="hidden_rd_money_#currentrow#" id="hidden_rd_money_#currentrow#" value="#money#">
                                                <input type="hidden" name="txt_rate1_#currentrow#" id="txt_rate1_#currentrow#" value="#tlformat(rate1)#">
                                                <div class="col col-4 col-md-4 col-sm-4 col-xs-12">
                                                    <label>#MONEY# #TLFormat(RATE1,0)#/</label>
                                                </div>
                                                <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                                                    <input type="text" name="txt_rate2_#currentrow#" id="txt_rate2_#currentrow#" <cfif readonly_info>readonly</cfif> value="#TLFormat(rate2,session.ep.our_company_info.rate_round_num)#" class="box" onkeyup="return(FormatCurrency(this,event,#session.ep.our_company_info.rate_round_num#));" onBlur="if(parseFloat(filterNum(this.value,8))<=0) this.value=commaSplit(1);f_kur_hesapla_multi();hesapla();">
                                                </div>
                                            </div>
                                        </cfoutput>
                                    </cfif>
                                
                            </div>
                        </div>
                    </div>
                <div class="row">
                    <div class="col col-12">
	                    <div class="ListContent">
                        	<cfinclude template="add_bill_frame_payment.cfm">
						</div>
                    </div>
                </div>
            </cf_box_elements>
            <cf_box_footer>
                <cf_workcube_buttons type_format="1" is_upd='0' add_function="kontrol2()">
            </cf_box_footer>
</cfform>
</cf_box>
<script type="text/javascript">
	function display_duedate()
	{
		if(document.getElementById('document_type').value == -1 || document.getElementById('document_type').value == -3)
			document.getElementById('tr_due_date').style.display = '';
		else
			document.getElementById('tr_due_date').style.display = 'none';
	}
</script>