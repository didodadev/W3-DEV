<cf_xml_page_edit fuseact="account.form_add_bill_collecting">
<cfinclude template="../query/get_acc_card.cfm">
<cfinclude template="../query/get_money_doviz.cfm">
<cfif not get_account_card.recordcount>
	<br /><font class="txtbold"><cf_get_lang_main no='1531.Böyle Bir Kayıt Bulunmamaktadır'> !</font>
	<cfexit method="exittemplate">
</cfif>
<cfquery name="GET_ACCOUNT_ROWS_MAIN" dbtype="query">
	SELECT * FROM GET_ACCOUNT_ROWS_MAIN_ALL WHERE BA=0
</cfquery>
<cfquery name="GET_ACCOUNT_ROWS_A" dbtype="query">
	SELECT * FROM GET_ACCOUNT_ROWS_MAIN_ALL WHERE BA=1
</cfquery>
<cfset acc_process_type= GET_ACCOUNT_CARD.ACTION_TYPE><!--- get_acc_process_type_info.cfm'de kullanılıyor --->
<cfinclude template="../query/get_acc_process_type_info.cfm"><!--- money bilgileri --->
<cfquery name="get_money_bskt" datasource="#dsn2#"><!--- account money tablosunda kayıt varsa --->
	SELECT MONEY_TYPE MONEY,RATE1,RATE2 FROM ACCOUNT_CARD_MONEY WHERE ACTION_ID = #attributes.card_id# AND MONEY_TYPE <> '#session.ep.money#'
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
<cfif not get_money_bskt.recordcount>
	<cfif len(from_money_table)><!--- entegre olarak gelmişse ilgili tablodan --->
		<cfquery name="get_money_bskt" datasource="#dsn2#">
			SELECT MONEY_TYPE MONEY,RATE1,RATE2 FROM #from_money_table# WHERE ACTION_ID = #GET_ACCOUNT_CARD.ACTION_ID# AND MONEY_TYPE <> '#session.ep.money#'
		</cfquery>
	</cfif>
	<cfif not get_money_bskt.recordcount><!--- setup_money den --->
		<cfquery name="get_money_bskt" datasource="#dsn#">
			SELECT MONEY,RATE1,RATE2 FROM SETUP_MONEY WHERE COMPANY_ID = #session.ep.company_id# AND PERIOD_ID = #session.ep.period_id# AND MONEY_STATUS = 1 AND MONEY <> '#session.ep.money#'
		</cfquery>
	</cfif>
</cfif>
<cfsavecontent variable="right_">
	<cfoutput>
	<cfif isdefined('link_str') and len(link_str) and len(get_account_card.action_cat_id)>
		<a href="#link_str##GET_ACCOUNT_CARD.ACTION_ID#" target="_blank"><img src="/images/extre.gif" align="top" border="0" alt="İşlem Detay" title="İşlem Detay"></a>
	<cfelseif listfind('31',get_account_card.action_type,',')>
		<cfquery name="get_order_id" datasource="#dsn3#">
			SELECT
				ORDER_ID
			FROM
				ORDER_CASH_POS
			WHERE
				CASH_ID = #get_account_card.action_id# AND
				KASA_PERIOD_ID = #session.ep.period_id#
		</cfquery>
		<cfif get_order_id.recordcount>
	        <a href="#request.self#?fuseaction=sales.upd_fast_sale&order_id=#get_order_id.order_id#" target="invoice_window"><img src="/images/extre.gif" align="top" border="0" alt="<cf_get_lang_main no ='35.Muhasebe'>" title="<cf_get_lang_main no ='35.Muhasebe'>"></a>
        </cfif>
	<cfelseif listfind('241',get_account_card.action_type,',')>
		<cfquery name="get_order_id" datasource="#dsn3#">
			SELECT
				ORDER_ID
			FROM
				ORDER_CASH_POS
			WHERE
				POS_ACTION_ID = #get_account_card.action_id#
		</cfquery>
        <cfif get_order_id.recordcount>
			<a href="#request.self#?fuseaction=sales.upd_fast_sale&order_id=#get_order_id.order_id#" target="invoice_window"><img src="/images/extre.gif" align="top" border="0" alt="<cf_get_lang_main no ='35.Muhasebe'>" title="<cf_get_lang_main no ='35.Muhasebe'>"></a>
		</cfif>
	<cfelseif listfind('97',get_account_card.action_type,',')>
		<cfquery name="get_order_id" datasource="#dsn2#">
			SELECT
				PAYMENT_ORDER_ID ORDER_ID
			FROM
				VOUCHER_PAYROLL
			WHERE
				ACTION_ID = #get_account_card.action_id#
		</cfquery>
        <cfif get_order_id.recordcount>
			<a href="#request.self#?fuseaction=sales.upd_fast_sale&order_id=#get_order_id.order_id#" target="invoice_window"><img src="/images/extre.gif" align="top" border="0" alt="<cf_get_lang_main no ='35.Muhasebe'>" title="<cf_get_lang_main no ='35.Muhasebe'>"></a>
		</cfif>
	<cfelseif listfind('90',get_account_card.action_type,',')>
		<cfquery name="get_order_id" datasource="#dsn2#">
			SELECT
				PAYMENT_ORDER_ID ORDER_ID
			FROM
				PAYROLL
			WHERE
				ACTION_ID = #get_account_card.action_id#
		</cfquery>
        <cfif get_order_id.recordcount>
			<a href="#request.self#?fuseaction=sales.upd_fast_sale&order_id=#get_order_id.order_id#" target="invoice_window"><img src="/images/extre.gif" border="0" title="<cf_get_lang_main no ='35.Muhasebe'>"></a>
		</cfif>
    </cfif>
	</cfoutput>
</cfsavecontent>
<cf_catalystHeader>
<cf_box>
<cfform name="add_bill" id="add_bill" action="#request.self#?fuseaction=account.emptypopup_upd_bill_collecting&card_id=#attributes.card_id#" method="post">
    <input type="hidden" name="active_period" id="active_period" value="<cfoutput>#session.ep.period_id#</cfoutput>">
    <input type="hidden" name="kur_say" id="kur_say" value="<cfoutput>#get_money_bskt.recordcount#</cfoutput>">
    <input type="hidden" name="action_id" id="action_id" value="<cfoutput>#get_account_card.action_id#</cfoutput>">
    <input type="hidden" name="money_type" id="money_type" value="">
    <input type="hidden" name="card_id" id="card_id" value="<cfoutput>#attributes.card_id#</cfoutput>" />
        <cf_box_elements>
                    <div class="col col-3 col-md-4 col-sm-6 col-xs-12" type="column" index="1" sort="true">
                        <div class="form-group" id="item-is_other_currency">
                            <label>
                                <cf_get_lang no='48.Dövizli İşlem'>
                                <input type="checkbox" name="is_other_currency" id="is_other_currency" value="1" onClick="other_money_action();" <cfif get_comp_info.is_other_money>disabled="disabled"</cfif> <cfif get_account_card.IS_OTHER_CURRENCY eq 1>checked</cfif>>
                            </label>
                            <cfif session.ep.our_company_info.is_ifrs eq 1>
                                <label>
                                    <cf_get_lang_main no='718.UFRS Kod'>
                                    <input type="checkbox" name="is_ifrs" id="is_ifrs" value="1" onClick="ifrs_action();" checked>
                                </label>
                                <label>
                                    <cf_get_lang_main no='377.Özel Kod'>
                                    <input type="checkbox" name="IS_ACCOUNT_CODE2" id="IS_ACCOUNT_CODE2" value="1" onClick="private_code_action();" <cfif get_account_card.IS_ACCOUNT_CODE2 eq 1>checked</cfif>>
                                </label>
                            </cfif>
                        </div>
                        <div class="form-group" id="item-process_date">
                            <label class="col col-4 col-xs-12"><cf_get_lang_main no='330.Tarih'></label>
                            <div class="col col-8 col-xs-12">
                                <div class="input-group">
                                    <cfsavecontent variable="message"><cf_get_lang_main no='59.Eksik Veri'>:<cf_get_lang_main no='330.Tarih'>!</cfsavecontent>
                                    <cfinput type="text" name="process_date" style="width:65px;" required="Yes" readonly="yes" message="#message#" validate="#validate_style#" value="#dateformat(get_account_card.ACTION_DATE,dateformat_style)#" onblur="change_money_info('add_bill','process_date');">
                                    <span class="input-group-addon btnPointer"><cf_wrk_date_image date_field="process_date" call_function="change_money_info"control_date="#dateformat(get_account_card.ACTION_DATE,dateformat_style)#"></span>
                                </div>
                            </div>
                        </div>
                        <div class="form-group" id="item-process_cat">
                            <label class="col col-4 col-xs-12"><cf_get_lang_main no="388.İşlem Tipi"> *</label>
                            <div class="col col-8 col-xs-12">
                                <cf_workcube_process_cat process_cat="#get_account_card.card_cat_id#" slct_width="155px;">
                            </div>
                        </div>
                        <div class="form-group" id="item-paper_no">
                            <label class="col col-4 col-xs-12"><cf_get_lang_main no='468.Belge No'></label>
                            <div class="col col-8 col-xs-12">
                                <input type="text" name="paper_no" id="paper_no" value="<cfoutput>#get_account_card.paper_no#</cfoutput>" style="width:160px;" maxlength="25">
                            </div>
                        </div>
                        <div class="form-group" id="item-document_type">
                            <label class="col col-4 col-xs-12"><cf_get_lang_main no='1121.Belge Tipi'></label>
                            <div class="col col-8 col-xs-12">
                                <select name="document_type" id="document_type" style="width:160px;" onchange="display_duedate()">
                                    <option value=""><cf_get_lang_main no='322.Seçiniz'></option>
                                    <cfoutput query="get_account_card_document_types">
                                        <option value="#document_type_id#" <cfif get_account_card.card_document_type eq document_type_id>selected</cfif>>#document_type#</option>
                                    </cfoutput>
                                </select>
                            </div>
                        </div>
                        <div class="form-group" id="item-payment_type">
                            <label class="col col-4 col-xs-12"><cf_get_lang_main no='2260.Ödeme Şekli'></label>
                            <div class="col col-8 col-xs-12">
                                <select name="payment_type" id="payment_type" style="width:160px;">
                                    <option value=""><cf_get_lang_main no='322.Seçiniz'></option>
                                    <cfoutput query="get_account_card_payment_types">
                                        <option value="#payment_type_id#" <cfif get_account_card.card_payment_method eq payment_type_id>selected</cfif>>#payment_type#</option>
                                    </cfoutput>
                                </select>
                            </div>
                        </div>
                        <div class="form-group" id="item-other_cash_currency">
                            <label class="col col-4 col-xs-12"><span id="text_other_money" <cfif get_account_card.is_other_currency neq 1>style="display:none;"</cfif>><cf_get_lang_main no='709.İşlem Dövizi'></span></label>
                            <div class="col col-8 col-xs-12">
                                <div class="input-group" id="main_other_money" <cfif get_account_card.is_other_currency neq 1>style="display:none;"</cfif>>
                                    <input type="text" name="other_cash_amount" id="other_cash_amount" class="moneybox" value="<cfif len(GET_ACCOUNT_ROWS_MAIN.OTHER_AMOUNT)><cfoutput>#tlformat(GET_ACCOUNT_ROWS_MAIN.OTHER_AMOUNT,2)#</cfoutput></cfif>" style="width:74px;" onkeyup="return(FormatCurrency(this,event));">
                                    <span class="input-group-addon no-bg"></span>
                                    <select name="other_cash_currency" id="other_cash_currency" style="width:50px;" onChange="f_total_hesapla(this.value);">
                                        <option value=""><cf_get_lang_main no='77.Para Br'></option>
                                        <cfoutput query="get_money_doviz">
                                            <option value="#money#" <cfif len(GET_ACCOUNT_ROWS_MAIN.OTHER_AMOUNT) and GET_ACCOUNT_ROWS_MAIN.OTHER_CURRENCY is money>selected</cfif>>#MONEY#</option>
                                        </cfoutput>
                                    </select>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="col col-3 col-md-4 col-sm-6 col-xs-12" type="column" index="2" sort="true">
                        <div class="form-group" id="item-project_name">
                            <label class="col col-4 col-xs-12"><cf_get_lang_main no='4.Proje'></label>
                            <div class="col col-8 col-xs-12">
                                <div class="input-group">
                                    <input type="hidden" name="project_id" id="project_id" value="<cfoutput>#GET_ACCOUNT_ROWS_MAIN.acc_project_id#</cfoutput>">
                                    <input type="text" name="project_name" id="project_name"  value="<cfif len(GET_ACCOUNT_ROWS_MAIN.acc_project_id)><cfoutput>#get_project_name(GET_ACCOUNT_ROWS_MAIN.acc_project_id)#</cfoutput></cfif>" style="width:125px;" onFocus="AutoComplete_Create('project_name','PROJECT_HEAD','PROJECT_HEAD','get_project','','PROJECT_ID','project_id','list_works','3','250');" autocomplete="off">
                                    <span class="input-group-addon btnPointer icon-ellipsis" title="<cf_get_lang_main no='322.Seciniz'>" onclick="openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_projects&project_id=add_bill.project_id&project_head=add_bill.project_name')"></span>
                                </div>
                            </div>
                        </div>
                        <div class="form-group" id="item-member_name">
                            <label class="col col-4 col-xs-12"><cf_get_lang_main no='107.Cari Hesap'></label>
                            <div class="col col-8 col-xs-12">
                                <div class="input-group">
                                    <input type="hidden" name="member_type" id="member_type" value="<cfif len(get_account_card.acc_company_id)>partner<cfelseif len(get_account_card.acc_consumer_id)>consumer</cfif>">
                                    <input type="hidden" name="member_id" id="member_id" value="<cfif len(get_account_card.acc_company_id)><cfoutput>#get_account_card.acc_company_id#</cfoutput><cfelseif len(get_account_card.acc_consumer_id)><cfoutput>#get_account_card.acc_consumer_id#</cfoutput></cfif>">
                                    <input type="text" name="member_name" id="member_name" value="<cfif len(get_account_card.acc_company_id) and len(get_account_card.company)><cfoutput>#get_account_card.company#</cfoutput><cfelseif len(get_account_card.acc_consumer_id) and len(get_account_card.consumer)><cfoutput>#get_account_card.consumer#</cfoutput></cfif>" style="width:155px;">
                                    <span class="input-group-addon btnPointer icon-ellipsis" title="<cf_get_lang_main no='107.Cari Hesap'>" onclick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_pars&field_member_name=add_bill.member_name&field_name=add_bill.member_name&field_type=add_bill.member_type&field_comp_id=add_bill.member_id&field_consumer=add_bill.member_id&select_list=2,3<cfif session.ep.isBranchAuthorization>&is_store_module=1</cfif>','list');"></span>
                                </div>
                            </div>
                        </div>
                        <div class="form-group" id="item-get_cash_plan">
                            <label class="col col-4 col-xs-12"><cf_get_lang no='39.Kasa Hesap Adı'> *</label>
                            <div class="col col-8 col-xs-12">
                                <cfinclude template="../query/get_cash_plan.cfm">
                                <select name="cash_acc_code" id="cash_acc_code" style="width:125px;">
                                    <option value=""><cf_get_lang no='45.Kasa Seçiniz'></option>
                                    <cfoutput query="get_cash_plan">
                                        <option value="#ACCOUNT_CODE#"<cfif isdefined("GET_ACCOUNT_ROWS_MAIN") and (GET_ACCOUNT_ROWS_MAIN.account_id is account_code)> selected</cfif>>#ACCOUNT_NAME#</option>
                                    </cfoutput>
                                </select>
                            </div>
                        </div>
                        <div class="form-group" id="item-cash_debt">
                            <label class="col col-4 col-xs-12"><cfoutput>#session.ep.money#</cfoutput> <cf_get_lang_main no='175.Borç'></label>
                            <div class="col col-8 col-xs-12">
                                <input type="text" name="cash_debt" id="cash_debt" value="0" class="moneybox" readonly style="width:125px;">
                            </div>
                        </div>
                        <cfif len(session.ep.money2)>
                            <div class="form-group" id="item-cash_amount_2">
                                <label class="col col-4 col-xs-12"><cf_get_lang no='123.Sistem 2 Döviz'></label>
                                <div class="col col-8 col-xs-12">
                                    <input type="text" name="cash_amount_2" id="cash_amount_2" value="0" class="moneybox" readonly style="width:125px;">
                                </div>
                            </div>
                        </cfif>
                        <div class="form-group" id="tr_due_date" <cfif get_account_card.card_document_type neq -1 AND get_account_card.card_document_type neq -3>style="display:none"</cfif>>
                            <label class="col col-4 col-xs-12"><cf_get_lang_main no='469.Vade Tarihi'></label>
                            <div class="col col-8 col-xs-12">
                                <div class="input-group">
                                    <cfinput type="text" name="due_date" value="#dateformat(get_account_card.due_date,dateformat_style)#" maxlength="10" validate="#validate_style#" style="width:80px;" valign="top">
                                    <span class="input-group-addon btnPointer"><cf_wrk_date_image date_field="due_date" call_function="change_money_info"></span>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="col col-3 col-md-4 col-sm-6 col-xs-12" type="column" index="3" sort="true">
                        <div class="form-group" id="item-bill_detail">
                            <label class="col col-4 col-xs-12"><cf_get_lang_main no='217.Açıklama'></label>
                            <div class="col col-8 col-xs-12">
                                <textarea name="bill_detail" id="bill_detail" style="width:160px;height:60px;"><cfoutput>#get_account_card.CARD_DETAIL#</cfoutput></textarea>
                            </div>
                        </div>
                        <div class="form-group" id="item-cash_detail">
                            <label class="col col-4 col-xs-12"><cf_get_lang no='146.Satır Açıklama'></label>
                            <div class="col col-8 col-xs-12">
                                <input type="text" name="cash_detail" id="cash_detail" value="<cfoutput>#GET_ACCOUNT_ROWS_MAIN.DETAIL#</cfoutput>" style="width:125px;" maxlength="100">
                            </div>
                        </div>
                        <div class="form-group" id="item-bill_no">
                            <label class="col col-4 col-xs-12"><cf_get_lang no='51.Sistem Fiş No'></label>
                            <div class="col col-8 col-xs-12">
                                <input type="text" name="bill_no" id="bill_no" value="<cfoutput>#get_account_card.BILL_NO#</cfoutput>" style="width:155px;" disabled>
                            </div>
                        </div>
                        <div class="form-group" id="item-tahsil_bill_no">
                            <label class="col col-4 col-xs-12"><cf_get_lang no='56.Tahsil Fiş No'></label>
                            <div class="col col-8 col-xs-12">
                                <cfsavecontent variable="message1"><cf_get_lang_main no='59.Eksik veri'>:<cf_get_lang no='43.Fiş Numarası'>!</cfsavecontent>
                                <cfinput type="text" validate="integer" name="tahsil_bill_no" required="yes" message="#message1#" value="#get_account_card.CARD_TYPE_NO#" style="width:155px;">
                            </div>
                        </div>
                    </div>
                    <div class="col col-2 col-md-4 col-sm-6 col-xs-12" type="column" index="4" sort="false">
                        <label class="col col-12 bold"><cfif get_money_bskt.recordcount><cf_get_lang_main no='265.Dövizler'></cfif></label>
                        <div class="col col-12 scrollContent scroll-x2">
                            <table>
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
                                            </td><td>
                                                 <input type="text" name="txt_rate2_#currentrow#" id="txt_rate2_#currentrow#" <cfif readonly_info>readonly</cfif> value="#TLFormat(rate2,session.ep.our_company_info.rate_round_num)#" class="box" onkeyup="return(FormatCurrency(this,event,#session.ep.our_company_info.rate_round_num#));" onBlur="if(parseFloat(filterNum(this.value,8))<=0) this.value=commaSplit(1);f_kur_hesapla_multi();hesapla();">
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
                        <cf_record_info query_name="get_account_card">
                 
                        <cfquery name="CONTROL_ACC_UPDATE" datasource="#DSN#">
                            SELECT ISNULL(IS_ACCOUNT_CARD_UPDATE,0) AS IS_ACCOUNT_CARD_UPDATE FROM OUR_COMPANY_INFO WHERE COMP_ID = #session.ep.COMPANY_ID#
                        </cfquery>
                        <cfif not (len(GET_ACCOUNT_CARD.ACTION_ID) and CONTROL_ACC_UPDATE.IS_ACCOUNT_CARD_UPDATE eq 0)>
                            <cfif isdefined("get_account_rows_A") and not Find("copy",attributes.fuseaction,0)>
                                <cf_workcube_buttons is_upd='1' is_delete="0" is_cancel="0" add_function="kontrol2()">
                            <cfelse>
                                <cf_workcube_buttons is_upd='0'>
                            </cfif>
                        </cfif>
            </cf_box_footer>
</cfform>
</cf_box>
<script type="text/javascript">
	function ekle()
	{
		window.opener.location.href='<cfoutput>#request.self#</cfoutput>?fuseaction=account.form_add_bill_collecting';
		window.close();
	}
	function display_duedate()
	{
		if(document.getElementById('document_type').value == -1 || document.getElementById('document_type').value == -3)
			document.getElementById('tr_due_date').style.display = '';
		else
			document.getElementById('tr_due_date').style.display = 'none';
	}
</script>