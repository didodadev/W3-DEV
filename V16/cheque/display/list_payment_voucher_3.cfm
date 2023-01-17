<!---- toplam_kalan tl cinsinden tutuyor  toplam_kalan_br o anki işlem birimi ---->
<cfinvoke 
         component = "/workdata/get_cash" 
         method="getComponentFunction" 
         returnvariable="get_cashes">
        <cfinvokeargument name="acc_code" value="0">
        <cfinvokeargument name="onchange" value="kasa_dovizi_hesapla(2);">
</cfinvoke>
<cfinclude template="../../bank/query/get_accounts.cfm">
<cfinclude template="../../sales/query/get_pos_detail.cfm">
<cf_papers paper_type="revenue_receipt">
<cfif isDefined("attributes.company_id") and len(attributes.company_id) or isdefined("attributes.consumer_id") and len(attributes.consumer_id)>
    <input type="hidden" name="kur_say" id="kur_say" value="<cfoutput>#get_money.recordcount#</cfoutput>">
    <cfif session.ep.rate_valid eq 1>
        <cfset readonly_info = "yes">
    <cfelse>
        <cfset readonly_info = "no">
    </cfif>
    <cfoutput>
        <cfloop query="get_money">
            <input type="hidden" name="hidden_rd_money_#currentrow#" id="hidden_rd_money_#currentrow#" value="#money#">
            <input type="hidden" name="txt_rate1_#currentrow#" id="txt_rate1_#currentrow#" value="#rate1#">
            <input type="hidden" class="box" <cfif readonly_info>readonly</cfif> name="txt_rate2_#currentrow#" id="txt_rate2_#currentrow#" <cfif money eq session.ep.money>readonly="yes"</cfif> value="#TLFormat(rate2,'#session.ep.our_company_info.rate_round_num#')#" onKeyUp="return(FormatCurrency(this,event,#session.ep.our_company_info.rate_round_num#));" onBlur="return(FormatCurrency(this,event,#session.ep.our_company_info.rate_round_num#));"></td>
        </cfloop>
    </cfoutput>
    <cf_box>
        <cf_box_elements>
            <div class="col col-4 col-md-4 col-sm-6 col-xs-12" type="column" index="1" sort="true">
                <div class="form-group" id="item-process">
                    <label class="col col-3 col-xs-12"><cf_get_lang_main no='388.İşlem'> *</label>
                    <div class="col col-9 col-xs-12">
                        <cf_workcube_process_cat>
                    </div>
                </div>
                <div class="form-group" id="item-paper">
                    <label class="col col-3 col-xs-12"><cf_get_lang no ='222.Makbuz No'></label>
                    <div class="col col-9 col-xs-12">
                        <div class="col col-12 col-md-12 col-sm-12 col-xs-12">
                            <div class="col col-4 col-md-4 col-sm-4 col-xs-12">
                                <input type="hidden" name="paper_printer_id" id="paper_printer_id" value="<cfif isDefined('paper_printer_code')><cfoutput>#paper_printer_code#</cfoutput></cfif>">
                                <cfinput type="text" name="paper_code" value="#paper_code#">
                            </div>
                            <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                                <cfinput type="text" name="paper_number" required="no" value="#paper_number#" onKeyUp="isNumber(this);" onBlur="isNumber(this);" message="" validate="integer">
                            </div>
                        </div>
                    </div>
                </div>
                <div class="form-group" id="item-action_date">
                    <label class="col col-3 col-xs-12"><cf_get_lang_main no='467.İşlem Tarihi '> *</label>
                    <div class="col col-9 col-xs-12">
                        <div class="input-group">
                            <cfinput validate="#validate_style#" required="Yes" message="#message#" type="text" name="action_date" value="#dateformat(now(),dateformat_style)#">
                            <span class="input-group-addon"><cf_wrk_date_image date_field="action_date"></span>
                        </div>
                    </div>
                </div>
                <div class="form-group" id="item-action_type">
                    <label class="col col-3 col-xs-12"><span class="hide"><cf_get_lang_main no ='108.Kasa'>/<cf_get_lang_main no ='109.Banka'>/<cf_get_lang_main no='787.Kredi Kartı'></span></label>
                    <div class="col col-9 col-xs-12">
                        <label><cf_get_lang_main no ='108.Kasa'><input name="action_type" id="action_type" type="radio" value="1" checked onclick="kont_action_type(1)"></label>
                        <label><cf_get_lang_main no ='109.Banka'><input name="action_type" id="action_type" type="radio" value="3" onclick="kont_action_type(3)"></label>
                        <label><cf_get_lang_main no='787.Kredi Kartı'><input name="action_type" id="action_type" type="radio" value="2" onclick="kont_action_type(2)"></label>
                    </div>
                </div>
                <cfif get_cashes.recordcount>
                    <cfoutput>
                        <input type="hidden" name="kontrol_cash" id="kontrol_cash" value="<cfoutput>#get_cashes.recordcount#</cfoutput>">
                        <div class="form-group" id="cash_td_1">
                            <label class="col col-3 col-xs-12"><cf_get_lang_main no ='261.Tutar'></label>
                            <div class="col col-9 col-xs-12">
                                <input type="hidden" name="other_cash_amount" id="other_cash_amount" value="">
                                <input type="text" name="cash_amount" id="cash_amount" value="" class="moneybox" onkeyup="kasa_dovizi_hesapla(1);return(FormatCurrency(this,event));" >
                            </div>
                        </div>
                        <div class="form-group" id="cash_td_2">
                            <label class="col col-3 col-xs-12"><cf_get_lang_main no ='108.Kasa'></label>
                            <div class="col col-9 col-xs-12">
                                <input type="hidden" name="cash_action_id" id="cash_action_id" value="">
                                <cfif isdefined("get_voucher_actions.CURRENCY_ID") and len(get_voucher_actions.CURRENCY_ID)>
                                    <cfset temp_currency = "#get_voucher_actions.CURRENCY_ID#">
                                </cfif>
                                <cf_wrk_Cash name="kasa" currency_branch="2" acc_code="0" onchange="kasa_dovizi_hesapla(2);">
                                <input type="hidden" name="system_cash_amount" id="system_cash_amount" value="">
                                <input type="hidden" name="system_total_amounts" id="system_total_amounts" value="">
                                <input type="hidden" name="currency_type" id="currency_type" value="">
                            </div>
                        </div>
                    </cfoutput>
                <cfelse>
                    <div class="form-group" id="item-kontrol_cash">
                        <label class="col col-12 bold"><cf_get_lang_main no='1327.Kasa Tanımları Eksik'>!</label>
                        <input type="hidden" name="kontrol_cash"  id="kontrol_cash" value="0">
                    </div>
                </cfif>
                <cfif get_accounts.recordcount>
                    <input type="hidden" name="kontrol_bank"  id="kontrol_bank" value="<cfoutput>#get_accounts.recordcount#</cfoutput>">
                    <div class="form-group" id="bank_td_1" style="display:none;">
                        <label class="col col-3 col-xs-12"><cf_get_lang_main no ='261.Tutar'></label>
                        <div class="col col-9 col-xs-12">
                            <input type="text" name="bank_amount" id="bank_amount" value="" class="moneybox" onkeyup="banka_dovizi_hesapla(1);return(FormatCurrency(this,event));">
                        </div>
                    </div>
                    <div class="form-group" id="bank_td_2" style="display:none;">
                        <label class="col col-3 col-xs-12"><cf_get_lang_main no ='109.Banka'></label>
                        <div class="col col-9 col-xs-12">
                        <cfoutput>
                            <input type="hidden" name="bank_action_id" id="bank_action_id" value="">
                            <select name="action_to_account_id" id="action_to_account_id" onchange="banka_dovizi_hesapla(2);">
                                <cfloop query="get_accounts">
                                    <option value="#ACCOUNT_ID#;#ACCOUNT_CURRENCY_ID#;#ListGetAt(session.ep.user_location,2,"-")#">
                                    #ACCOUNT_NAME#&nbsp;#ACCOUNT_CURRENCY_ID#</option>
                                </cfloop>
                            </select>
                            <input type="hidden" name="system_bank_amount" id="system_bank_amount" value="">
                            <input type="hidden" name="currency_type_bank" id="currency_type_bank" value="#get_accounts.account_currency_id#">
                        </cfoutput>
                        </div>
                    </div>
                <cfelse>
                    <div class="form-group" id="item-kontrol_bank">
                        <label class="col col-12 bold"><cf_get_lang no ='270.Banka Tanımları Eksik'>!</label>
                        <input type="hidden" name="kontrol_bank" id="kontrol_bank" value="0">
                    </div>
                </cfif>
                <cfif get_pos_detail.recordcount>
                    <input type="hidden" name="kontrol_bank"  id="kontrol_bank" value="<cfoutput>#get_accounts.recordcount#</cfoutput>">
                    <div class="form-group" id="pos_td_1" style="display:none;">
                        <label class="col col-3 col-xs-12"><cf_get_lang_main no ='1104.Ödeme Yöntemi'></label>
                        <div class="col col-9 col-xs-12">
                        <cfoutput>
                            <select name="pos" id="pos" onchange="pos_hesapla();">
                                <cfloop query="get_pos_detail">
                                    <option value="#account_id#;#account_currency_id#;#payment_rate#;#payment_type_id#">#card_no#</option>
                                </cfloop>
                            </select>
                            <input type="hidden" name="currency_type_pos" id="currency_type_pos" value="#get_pos_detail.account_currency_id#">
                        </cfoutput>
                        </div>
                    </div>
                    <div class="form-group" id="pos_td_2" style="display:none;">
                        <label class="col col-3 col-xs-12"><cf_get_lang_main no ='261.Tutar'></label>
                        <div class="col col-3 col-xs-12">
                            <input type="hidden" name="pos_action_id" id="pos_action_id" value="">
                            <input type="text" name="pos_amount_first" id="pos_amount_first" value="" class="moneybox" onkeyup="pos_hesapla(2);return(FormatCurrency(this,event));">
                            <input type="hidden" name="system_pos_amount_first" id="system_pos_amount_first" value="">
                            <input type="hidden" name="com_amount" id="com_amount" value="" class="moneybox">
                            <input type="hidden" name="system_com_amount" id="system_com_amount" value="" class="moneybox">
                        </div>
                        <label class="col col-3 col-xs-12"><cf_get_lang no ='226.Komisyonlu Tutar'></label>
                        <div class="col col-3 col-xs-12">
                            <input type="text" name="pos_amount" id="pos_amount" value="" class="moneybox" readonly>
                            <input type="hidden" name="system_pos_amount" id="system_pos_amount" value="" readonly>
                        </div>
                    </div>
                <cfelse>
                    <div class="form-group" id="item-pos_error">
                        <label class="col col-12 bold"><cf_get_lang dictionary_id='58740.Pos Tanımları Eksik'>!</label>
                    </div>
                </cfif>
            </div>
            <div class="col col-4 col-md-4 col-sm-6 col-xs-12" type="column" index="2" sort="true">
                <div class="form-group" id="item-gelir">
                    <label class="col col-12 bold"><cf_get_lang dictionary_id="58677.Gelir"></label>
                </div>
                <div class="form-group" id="item-expense_item_name">
                    <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id="58173.Gelir Kalemi"></label>
                    <div class="col col-8 col-xs-12">
                        <div class="input-group">
                            <input type="hidden" name="expense_item_id" id="expense_item_id" value="">
                            <cfinput type="text" name="expense_item_name" id="expense_item_name" value="" onFocus="AutoComplete_Create('expense_item_name','EXPENSE_ITEM_NAME','EXPENSE_ITEM_NAME','get_expense_item','','EXPENSE_ITEM_ID','expense_item_id','','3','175');">
                            <span class="input-group-addon icon-ellipsis btnPointer" onclick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_exp_item&field_id=add_voucher_action.expense_item_id&field_name=add_voucher_action.expense_item_name&is_income=1','medium');" title="Gelir Kalemi"></span>
                        </div>
                    </div>
                </div>
                <div class="form-group" id="item-expense_center">
                    <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id="58172.Gelir Merkezi"></label>
                    <div class="col col-8 col-xs-12">
                        <div class="input-group">
                            <input type="hidden" name="expense_center_id" id="expense_center_id" value="">
                            <cfinput type="text" name="expense_center" id="expense_center" value="" onFocus="AutoComplete_Create('expense_center','EXPENSE,EXPENSE_CODE','EXPENSE,EXPENSE_CODE','get_expense_center','','EXPENSE_ID','expense_center_id','','3','175');">
                            <span class="input-group-addon icon-ellipsis btnPointer" onclick="windowopen('<cfoutput>#request.self#?fuseaction=objects.popup_expense_center&field_name=add_voucher_action.expense_center&field_id=add_voucher_action.expense_center_id&is_invoice=1</cfoutput>','medium');" title="Gelir Merkezi"></span>
                        </div>
                    </div>
                </div>
                <cfif len(payroll_id_list)>
                    <cfquery name="get_closeds" datasource="#dsn2#">
                        SELECT SUM(CLOSED_AMOUNT) AS TOTAL_ FROM VOUCHER_CLOSED WHERE PAYROLL_ID IN(#payroll_id_list#)
                    </cfquery>
                <cfelse>
                    <cfset get_closeds.TOTAL_ = 0>
                </cfif>
                <div class="form-group" id="item-not_pay_value">
                    <label class="col col-4 col-xs-12"><cf_get_lang no ='229.Kalan Senet Tutar'></label>
                    <div class="col col-8 col-xs-12">
                        <div class="input-group">
                            <input type="text" name="not_pay_value" id="not_pay_value" value="<cfoutput>#tlformat(toplam_kalan)#</cfoutput>" class="box" readonly>
                            <span class="input-group-addon other_currency_id_cash" ><cfoutput>#session.ep.money#</cfoutput></span>
                        </div>
                    </div>
                </div>
                <div class="form-group" id="item-total_interest_amount">
                    <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id="50361.Gecikme Faizi"></label>
                    <div class="col col-8 col-xs-12">
                        <div class="input-group">
                            <input type="text" name="total_interest_amount" id="total_interest_amount" value="<cfoutput>#tlformat(toplam_interest_amount)#</cfoutput>" class="box" readonly="yes">
                            <span class="input-group-addon other_currency_id"><cfoutput>#session.ep.money#</cfoutput></span>
                        </div>
                    </div>
                </div>
                <div class="form-group" id="item-total_system_amount">
                    <label class="col col-4 col-xs-12"><cf_get_lang no ='230.Ödenecek Senet Tutar'></label>
                    <div class="col col-8 col-xs-12">
                        <div class="input-group">
                            <input type="text" name="total_system_amount" id="total_system_amount" value="0" class="box" readonly="yes"> 
                            <span class="input-group-addon other_currency_id"><cfoutput>#session.ep.money#</cfoutput></span>
                        </div>
                    </div>
                </div>
            </div>
        </cf_box_elements>
        <cf_box_footer>
            <cfsavecontent variable="message3"><cf_get_lang no ='231.Seçilen Senetler İade Edilip Yeniden Düzenleme Yapılacak Emin Misiniz'> ?</cfsavecontent>
            <cfsavecontent variable="message4"><cf_get_lang no ='232.Yeniden Düzenle'></cfsavecontent>
            <cf_workcube_buttons is_upd='0' is_cancel='0' insert_info='#message4#' insert_alert='#message3#' add_function='kontrol3()'>
            <cf_workcube_buttons is_upd='0' add_function='kontrol2()'>
        </cf_box_footer>
    </cf_box>
</cfif>

