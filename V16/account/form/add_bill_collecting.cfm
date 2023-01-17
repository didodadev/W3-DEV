<cf_xml_page_edit fuseact="account.form_add_bill_collecting">
<cfif isdefined("attributes.card_id") and len(attributes.card_id)>
    <cfinclude template="../query/get_acc_card.cfm">
    <cfif not get_account_card.recordcount>
        <br /><font class="txtbold"><cf_get_lang dictionary_id='58943.Böyle Bir Kayıt Bulunmamaktadır'> !</font>
        <cfexit method="exittemplate">
    </cfif>
    <cfquery name="GET_ACCOUNT_ROWS_MAIN" dbtype="query">
        SELECT * FROM GET_ACCOUNT_ROWS_MAIN_ALL WHERE BA=0
    </cfquery>
    <cfquery name="GET_ACCOUNT_ROWS_A" dbtype="query">
        SELECT * FROM GET_ACCOUNT_ROWS_MAIN_ALL WHERE BA=1
    </cfquery>
    <cfinclude template="../query/get_acc_process_type_info.cfm"><!--- money bilgileri --->
    <cfquery name="get_money_bskt" datasource="#dsn2#"><!--- account money tablosunda kayıt varsa --->
        SELECT MONEY_TYPE MONEY,RATE1,RATE2 FROM ACCOUNT_CARD_MONEY WHERE ACTION_ID = #attributes.card_id#
    </cfquery>
    <cfif not get_money_bskt.recordcount>
        <cfif len(from_money_table)><!--- entegre olarak gelmişse ilgili tablodan --->
            <cfquery name="get_money_bskt" datasource="#dsn2#">
                SELECT MONEY_TYPE MONEY,RATE1,RATE2 FROM #from_money_table# WHERE ACTION_ID = #GET_ACCOUNT_CARD.ACTION_ID#
            </cfquery>
        </cfif>
        <cfif not get_money_bskt.recordcount><!--- setup_money den --->
            <cfquery name="get_money_bskt" datasource="#dsn#">
                SELECT MONEY,RATE1,RATE2 FROM SETUP_MONEY WHERE COMPANY_ID = #session.ep.company_id# AND PERIOD_ID = #session.ep.period_id# AND MONEY_STATUS = 1
            </cfquery>
        </cfif>
    </cfif>
</cfif>
<cfinclude template="../query/control_bill_no.cfm">
<cfinclude template="../query/get_money_doviz.cfm">
<cfquery name="get_money_bskt" datasource="#dsn2#">
	SELECT MONEY,RATE1,RATE2 FROM SETUP_MONEY WHERE MONEY_STATUS = 1 AND MONEY <> <cfqueryparam cfsqltype="cf_sql_varchar" value="#session.ep.money#">
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
<cf_papers paper_type="revenue_receipt">
<cf_catalystHeader>
<cf_box>
<cfform name="add_bill" id="add_bill" method="post" action="#request.self#?fuseaction=account.emptypopup_add_bill_collecting">
    <cf_box_elements>
    <input type="hidden" name="active_period" id="active_period" value="<cfoutput>#session.ep.period_id#</cfoutput>">
    <input type="hidden" name="kur_say" id="kur_say" value="<cfoutput>#get_money_bskt.recordcount#</cfoutput>">
    <input type="hidden" name="money_type" id="money_type" value="">
    <input type="hidden" name="card_id" id="card_id" value="" />
                    <div class="col col-3 col-md-4 col-sm-6 col-xs-12" type="column" index="1" sort="true">
                        <div class="form-group" id="item-is_other_currency">
                            <label class="col col-4 col-md-4 col-sm-6 col-xs-12">
                                <cf_get_lang dictionary_id='47310.Dövizli İşlem'>
                                <input type="checkbox" name="is_other_currency" id="is_other_currency" value="1" onClick="other_money_action();" <cfif get_comp_info.is_other_money>disabled="disabled"</cfif> <cfif isdefined('GET_ACCOUNT_CARD') and get_account_card.is_other_currency eq 1>checked</cfif>>
                            </label>
                            <cfif session.ep.our_company_info.is_ifrs eq 1>
                                <label class="col col-4 col-md-4 col-sm-6 col-xs-12">
                                    <cf_get_lang dictionary_id='58130.UFRS Kod'>
                                    <input type="checkbox" name="is_ifrs" id="is_ifrs" value="1" onClick="ifrs_action();" checked>
                                </label>
                            </cfif>
                            <cfif session.ep.our_company_info.is_ifrs eq 1>
                                <label class="col col-4 col-md-4 col-sm-6 col-xs-12">
                                    <cf_get_lang dictionary_id='57789.Özel Kod'>
                                    <input type="checkbox" name="IS_ACCOUNT_CODE2" id="IS_ACCOUNT_CODE2" value="1" onClick="private_code_action();" <cfif isdefined('GET_ACCOUNT_CARD') and get_account_card.IS_ACCOUNT_CODE2 eq 1>checked</cfif>>
                                </label>
                            </cfif>
                        </div>
                        <div class="form-group" id="item-process_date">
                            <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57742.Tarih'> *</label>
                            <div class="col col-8 col-xs-12">
                                <div class="input-group">
                                	<cfsavecontent variable="message"><cf_get_lang dictionary_id='57471.Eksik Veri'>:<cf_get_lang dictionary_id='57742.Tarih'>!</cfsavecontent>
									<cfif isdefined('GET_ACCOUNT_CARD')>
                        				<cfinput type="text" name="process_date" required="Yes" message="#message#" validate="#validate_style#" value="#dateformat(get_account_card.ACTION_DATE,dateformat_style)#"  onblur="change_money_info('add_bill','process_date');">
                                    <cfelse>
                                        <cfinput type="text" name="process_date" maxlength="10" required="Yes" message="#message#" validate="#validate_style#" onblur="change_money_info('add_bill','process_date');">
                                    </cfif>
                                    <span class="input-group-addon btnPointer"><cf_wrk_date_image date_field="process_date" call_function="change_money_info"></span>
                                </div>
                            </div>
                        </div>
                        <div class="form-group" id="item-process_cat">
                            <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id="57742.İşlem Tipi"> *</label>
                            <div class="col col-8 col-xs-12">
                            	<cfif isdefined('GET_ACCOUNT_CARD')>
                                	<cf_workcube_process_cat slct_width="180px;" process_cat="#get_account_card.card_cat_id#">
                                <cfelse>
                                	<cf_workcube_process_cat slct_width="180px;">
                                </cfif>
                            </div>
                        </div>
                        <div class="form-group" id="item-paper_no">
                            <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57880.Belge No'></label>
                            <div class="col col-8 col-xs-12">
                                <input type="text" name="paper_no" id="paper_no" value="" maxlength="25">
                            </div>
                        </div>
                        <div class="form-group" id="item-document_type">
                            <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='58533.Belge Tipi'></label>
                            <div class="col col-8 col-xs-12">
                                <select name="document_type" id="document_type" style="width:180px;" onchange="display_duedate()">
                                    <option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
                                    <cfoutput query="get_account_card_document_types">
                                        <option value="#document_type_id#" <cfif isdefined('GET_ACCOUNT_CARD') and get_account_card.card_document_type eq document_type_id>selected</cfif>>#document_type#</option>
                                    </cfoutput>
                                </select>
                            </div>
                        </div>
                        <div class="form-group" id="item-payment_type">
                            <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='30057.Ödeme Şekli'></label>
                            <div class="col col-8 col-xs-12">
                                <select name="payment_type" id="payment_type" style="width:180px;">
                                    <option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
                                    <cfoutput query="get_account_card_payment_types">
                                        <option value="#payment_type_id#" <cfif isdefined('GET_ACCOUNT_CARD') and get_account_card.card_payment_method eq payment_type_id>selected</cfif>>#payment_type#</option>
                                    </cfoutput>
                                </select>
                            </div>
                        </div>
                        <div class="form-group" id="item-other_cash_currency">
                            <label class="col col-4 col-xs-12"><span id="text_other_money" style="display:none;"><cf_get_lang dictionary_id='58121.İşlem Dövizi'></span></label>
                            <div class="col col-8 col-xs-12">
                                <div class="input-group" id="main_other_money" style="display:none;">
                                    <input type="text" name="other_cash_amount" id="other_cash_amount" value="<cfif isdefined('GET_ACCOUNT_CARD') and len(GET_ACCOUNT_ROWS_MAIN.OTHER_AMOUNT)><cfoutput>#tlformat(GET_ACCOUNT_ROWS_MAIN.OTHER_AMOUNT,2)#</cfoutput></cfif>" style="width:74px;" onkeyup="return(FormatCurrency(this,event));">
                                    <span class="input-group-addon no-bg"></span>
                                    <select name="other_cash_currency" id="other_cash_currency" onChange="f_total_hesapla(this.value);" style="width:50px;">
                                        <cfoutput query="get_money_doviz">
                                            <option value="#MONEY#" <cfif isdefined('GET_ACCOUNT_CARD') and len(GET_ACCOUNT_ROWS_MAIN.OTHER_AMOUNT) and GET_ACCOUNT_ROWS_MAIN.OTHER_CURRENCY is money>selected <cfelseif money is session.ep.money>selected</cfif>>#MONEY#</option>
                                        </cfoutput>
                                    </select>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="col col-3 col-md-4 col-sm-6 col-xs-12" type="column" index="2" sort="true">
                        <div class="form-group" id="item-project_name">
                            <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57416.Proje'></label>
                            <div class="col col-8 col-xs-12">
                                <div class="input-group">
                                    <cfif isdefined('GET_ACCOUNT_CARD')>
                                        <input type="hidden" name="project_id" id="project_id" value="<cfoutput>#GET_ACCOUNT_ROWS_MAIN.acc_project_id#</cfoutput>">
                                        <input type="text" name="project_name" id="project_name"  value="<cfif len(GET_ACCOUNT_ROWS_MAIN.acc_project_id)><cfoutput>#get_project_name(GET_ACCOUNT_ROWS_MAIN.acc_project_id)#</cfoutput></cfif>" style="width:125px;" onFocus="AutoComplete_Create('project_name','PROJECT_HEAD','PROJECT_HEAD','get_project','','PROJECT_ID','project_id','list_works','3','250');" autocomplete="off">
                                    <cfelse>
                                        <input type="hidden" name="project_id" id="project_id" value="">
                                        <input type="text" name="project_name" id="project_name" value="" style="width:125px;" onFocus="AutoComplete_Create('project_name','PROJECT_HEAD','PROJECT_HEAD','get_project','','PROJECT_ID','project_id','list_works','3','250');" autocomplete="off">
                                    </cfif>
                                    <span class="input-group-addon btnPointer icon-ellipsis" title="<cf_get_lang dictionary_id='57734.Seciniz'>" onclick="openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_projects&project_id=add_bill.project_id&project_head=add_bill.project_name')"></span>
                                </div>
                            </div>
                        </div>
                        <div class="form-group" id="item-member_name">
                            <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57519.Cari Hesap'></label>
                            <div class="col col-8 col-xs-12">
                                <div class="input-group">
                                    <cfif isdefined('GET_ACCOUNT_CARD')>
                                        <input type="hidden" name="member_type" id="member_type" value="<cfif len(get_account_card.acc_company_id)>partner<cfelseif len(get_account_card.acc_consumer_id)>consumer</cfif>">
                                        <input type="hidden" name="member_id" id="member_id" value="<cfif len(get_account_card.acc_company_id)><cfoutput>#get_account_card.acc_company_id#</cfoutput><cfelseif len(get_account_card.acc_consumer_id)><cfoutput>#get_account_card.acc_consumer_id#</cfoutput></cfif>">
                                        <input type="text" name="member_name" id="member_name" value="<cfif len(get_account_card.acc_company_id) and len(get_account_card.company)><cfoutput>#get_account_card.company#</cfoutput><cfelseif len(get_account_card.acc_consumer_id) and len(get_account_card.consumer)><cfoutput>#get_account_card.consumer#</cfoutput></cfif>" style="width:155px;">
                                    <cfelse>
                                        <input type="hidden" name="member_type" id="member_type" value="">
                                        <input type="hidden" name="member_id" id="member_id" value="">
                                        <input type="text" name="member_name" id="member_name" value="" style="width:180px;">
                                    </cfif>
                                    <span class="input-group-addon btnPointer icon-ellipsis" title="<cf_get_lang dictionary_id='57519.Cari Hesap'>" onclick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_pars&field_member_name=add_bill.member_name&field_name=add_bill.member_name&field_type=add_bill.member_type&field_comp_id=add_bill.member_id&field_consumer=add_bill.member_id&select_list=2,3<cfif session.ep.isBranchAuthorization>&is_store_module=1</cfif>','list');"></span>
                                </div>
                            </div>
                        </div>
                        <div class="form-group" id="item-get_cash_plan">
                            <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='47301.Kasa Hesap Adı'> *</label>
                            <div class="col col-8 col-xs-12">
                                <cfinclude template="../query/get_cash_plan.cfm">
                                <select name="cash_acc_code" id="cash_acc_code" style="width:125px;">
                                    <option value=""><cf_get_lang dictionary_id='50246.Kasa Seçiniz'></option>
                                    <cfoutput query="get_cash_plan">
                                        <option value="#ACCOUNT_CODE#"<cfif isdefined("get_account_rows_MAIN") and (get_account_rows_MAIN.account_id is account_code)> selected</cfif>>#ACCOUNT_NAME#</option>
                                    </cfoutput>
                                </select>
                            </div>
                        </div>
                        <div class="form-group" id="item-cash_debt">
                            <label class="col col-4 col-xs-12"><cfoutput>#session.ep.money#</cfoutput> <cf_get_lang dictionary_id='57587.Borç'></label>
                            <div class="col col-8 col-xs-12">
                                <input type="text" name="cash_debt" id="cash_debt" class="moneybox" value="0" style="width:125px;" readonly>
                            </div>
                        </div>
                        <cfif len(session.ep.money2)>
                            <div class="form-group" id="item-cash_amount_2">
                                <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='47385.Sistem 2 Döviz'></label>
                                <div class="col col-8 col-xs-12">
                                    <input type="text" name="cash_amount_2" id="cash_amount_2" value="0" class="moneybox" readonly style="width:125px;">
                                </div>
                            </div>
                        </cfif>
                        <cfif not isdefined('GET_ACCOUNT_CARD')><cfset get_account_card.card_document_type = ''></cfif>
                        <div class="form-group" id="tr_due_date" <cfif not listFind("-1,-3",get_account_card.card_document_type)>style="display:none"</cfif>>
                            <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57881.Vade Tarihi'></label>
                            <div class="col col-8 col-xs-12">
                                <div class="input-group">
                                    <cfif isdefined('GET_ACCOUNT_CARD.due_date')>
                                        <cfinput type="text" name="due_date" maxlength="10" validate="#validate_style#" value="#dateformat(get_account_card.due_date,dateformat_style)#">
                                    <cfelse>
                                        <cfinput type="text" name="due_date" maxlength="10" validate="#validate_style#">
                                    </cfif>
                                    <span class="input-group-addon btnPointer"><cf_wrk_date_image date_field="due_date" call_function="change_money_info"></span>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="col col-3 col-md-4 col-sm-6 col-xs-12" type="column" index="3" sort="true">
                        <div class="form-group" id="item-bill_detail">
                            <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57629.Açıklama'></label>
                            <div class="col col-8 col-xs-12">
                                <textarea name="bill_detail" id="bill_detail"><cfif isdefined('GET_ACCOUNT_CARD.CARD_DETAIL')><cfoutput>#GET_ACCOUNT_CARD.CARD_DETAIL#</cfoutput></cfif></textarea>
                            </div>
                        </div>
                        <div class="form-group" id="item-cash_detail">
                            <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='47408.Satır Açıklama'></label>
                            <div class="col col-8 col-xs-12">
                                <input type="text" name="cash_detail" id="cash_detail" value="" style="width:125px;" maxlength="100">
                            </div>
                        </div>
                    </div>
                    <div class="col col-3 col-md-4 col-sm-6 col-xs-12" type="column" index="4" sort="false">
                        <label class="col col-12 bold"><cfif get_money_bskt.recordcount><cf_get_lang dictionary_id='57677.Döviz'></cfif></label>
                            <div class="col col-12 scrollContent scroll-x2">
                            <table style="width:100%">
                                <cfif session.ep.rate_valid eq 1>
                                    <cfset readonly_info = "yes">
                                <cfelse>
                                    <cfset readonly_info = "no">
                                </cfif>
                                <cfif get_money_bskt.recordcount>
                                    <cfoutput query="get_money_bskt">
                                        <tr>
                                            <td>#MONEY#</td>
                                            <input type="hidden" name="hidden_rd_money_#currentrow#" id="hidden_rd_money_#currentrow#" value="#money#">
                                            <input type="hidden" name="txt_rate1_#currentrow#" id="txt_rate1_#currentrow#" value="#tlformat(rate1)#">
                                            <td>
                                                 #TLFormat(RATE1,0)#/ 
                                                </td>
                                                 <td><input type="text" name="txt_rate2_#currentrow#" class="box" id="txt_rate2_#currentrow#" <cfif readonly_info>readonly</cfif> value="#TLFormat(rate2,session.ep.our_company_info.rate_round_num)#" onkeyup="return(FormatCurrency(this,event,#session.ep.our_company_info.rate_round_num#));" onBlur="if(parseFloat(filterNum(this.value,8))<=0) this.value=commaSplit(1);f_kur_hesapla_multi();hesapla();">
                                            </td>
                                        </tr>
                                    </cfoutput>
                                </cfif>
                            </table>
                        </div>
                    </div>
                <div class="row">
                    <div class="col col-12">
                        <cfinclude template="add_bill_frame_collecting.cfm">
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