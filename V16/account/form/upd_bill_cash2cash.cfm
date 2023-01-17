<cfparam name="is_dsp_cari_member" default="0">
<cf_xml_page_edit  fuseact="account.form_add_bill_cash2cash">
<cfinclude template="../query/get_acc_card.cfm">
<cfparam name="attributes.special_code" default="1">
<cfquery name="CONTROL_ACC_UPDATE" datasource="#DSN#">
    SELECT ISNULL(IS_ACCOUNT_CARD_UPDATE,0) AS IS_ACCOUNT_CARD_UPDATE FROM OUR_COMPANY_INFO WHERE COMP_ID = #session.ep.COMPANY_ID#
</cfquery>
<cfquery name="get_branchs" datasource="#dsn#">
	SELECT
		BRANCH_ID,BRANCH_NAME
	FROM
		BRANCH
	WHERE
		BRANCH_STATUS = 1
		AND COMPANY_ID = #session.ep.company_id#
	<cfif session.ep.isBranchAuthorization>
		AND BRANCH_ID IN (SELECT BRANCH_ID FROM EMPLOYEE_POSITION_BRANCHES WHERE POSITION_CODE = #session.ep.position_code#)
	</cfif>
	ORDER BY BRANCH_NAME
</cfquery>
<cfif not get_account_card.recordcount>
	<br /><font class="txtbold"><cf_get_lang_main no='1531.Böyle Bir Kayıt Bulunmamaktadır'> !</font>
	<cfexit method="exittemplate">
</cfif>
<cfquery name="GET_ACCOUNT_ROWS_MAIN" dbtype="query">
	SELECT * FROM GET_ACCOUNT_ROWS_MAIN_ALL
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
<cfset acc_process_type= GET_ACCOUNT_CARD.ACTION_TYPE><!--- get_acc_process_type_info.cfm'de kullanılıyor --->
<cfinclude template="../query/get_acc_process_type_info.cfm"><!--- money bilgileri --->
<cfquery name="get_money_bskt" datasource="#dsn2#"><!--- account money tablosunda kayıt varsa --->
	SELECT MONEY_TYPE MONEY,RATE1,RATE2 FROM ACCOUNT_CARD_MONEY WHERE ACTION_ID = #attributes.card_id# AND MONEY_TYPE <> '#session.ep.money#'
</cfquery>
<cfif not get_money_bskt.recordcount>
	<cfif len(from_money_table)><!--- entegre olarak gelmişse ilgili tablodan --->
		<cfquery name="get_money_bskt" datasource="#muhasebe_db#">
			SELECT MONEY_TYPE MONEY,RATE1,RATE2 FROM #from_money_table# WHERE ACTION_ID = #GET_ACCOUNT_CARD.ACTION_ID# AND MONEY_TYPE <> '#session.ep.money#'
		</cfquery>
	</cfif>
	<cfif not get_money_bskt.recordcount><!--- setup_money den --->
		<cfquery name="get_money_bskt" datasource="#dsn#">
			SELECT MONEY,RATE1,RATE2 FROM SETUP_MONEY WHERE COMPANY_ID = #session.ep.company_id# AND PERIOD_ID = #session.ep.period_id# AND MONEY_STATUS = 1 AND MONEY <> '#session.ep.money#'
		</cfquery>
	</cfif>
</cfif>
<cfif len(get_account_card.acc_company_id)>
	<cfquery name="get_company_name" datasource="#dsn#">
		SELECT FULLNAME FROM COMPANY WHERE COMPANY_ID = #get_account_card.acc_company_id#
	</cfquery>
<cfelseif len(get_account_card.acc_consumer_id)>
	<cfquery name="get_consumer_name" datasource="#dsn#">
		SELECT CONSUMER_NAME + ' ' + CONSUMER_SURNAME AS CONSUMER_FULLNAME FROM CONSUMER WHERE CONSUMER_ID = #get_account_card.acc_consumer_id#
	</cfquery>
</cfif>
<cfsavecontent variable="title_">
	<cfif GET_ACCOUNT_CARD.CARD_TYPE eq 14>
        <cf_get_lang_main no='1638.Özel Fiş'>
    <cfelseif GET_ACCOUNT_CARD.CARD_TYPE eq 19>
        <cf_get_lang_main no='1746.Kapanış Fiş'>
    <cfelse>
        <cf_get_lang_main no='1040.Mahsup Fişi'>
    </cfif>
</cfsavecontent>
<cfsavecontent variable="img_">
    <a href="javascript://" onclick="ekle();"><img src="/images/plus1.gif" alt="<cf_get_lang_main no='170.Ekle'>" align="absbottom" title="<cf_get_lang_main no='170.Ekle'>" border="0"></a>
    <cfoutput>
    <a href="#request.self#?fuseaction=account.popup_add_bill_cash2cash_copy&card_id=#attributes.card_id#" ><img src="images/plus.gif" alt="<cf_get_lang_main no='64.Kopyala'>" title="<cf_get_lang_main no='64.Kopyala'>" border="0"></a>
    <cfif isdefined('link_str') and len(link_str) and len(get_account_card.action_cat_id) and get_account_card.action_id neq 0>
        &nbsp;<a href="#link_str##GET_ACCOUNT_CARD.ACTION_ID#" target="_blank"><img src="/images/extre.gif" border="0" alt="<cf_get_lang no ='199.İşlem Detay'>" title="<cf_get_lang no ='199.İşlem Detay'>"></a>
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
    <cfelseif listfind('241',get_account_card.action_type,',')>
        <cfquery name="get_order_id" datasource="#dsn3#">
            SELECT
                ORDER_ID
            FROM
                ORDER_CASH_POS
            WHERE
                POS_ACTION_ID = #get_account_card.action_id#
        </cfquery>
    <cfelseif listfind('97',get_account_card.action_type,',')>
        <cfquery name="get_order_id" datasource="#dsn2#">
            SELECT
                PAYMENT_ORDER_ID ORDER_ID
            FROM
                VOUCHER_PAYROLL
            WHERE
                ACTION_ID = #get_account_card.action_id#
        </cfquery>
    <cfelseif listfind('90',get_account_card.action_type,',')>
        <cfquery name="get_order_id" datasource="#dsn2#">
            SELECT
                PAYMENT_ORDER_ID ORDER_ID
            FROM
                PAYROLL
            WHERE
                ACTION_ID = #get_account_card.action_id#
        </cfquery>
    <cfelseif listfind('1043,1044',get_account_card.action_type,',')>
        <cfquery name="get_cheque_id" datasource="#dsn2#">
            SELECT
                BA.CHEQUE_ID
            FROM
                BANK_ACTIONS BA,
                CHEQUE C
            WHERE
                BA.ACTION_ID = #get_account_card.action_id# AND
                BA.ACTION_TYPE_ID = #get_account_card.action_type# AND
                BA.CHEQUE_ID = C.CHEQUE_ID
        </cfquery>
    <cfelseif listfind('1053,1054',get_account_card.action_type,',')>
        <cfquery name="get_voucher_id" datasource="#dsn2#">
            SELECT
                BA.VOUCHER_ID
            FROM
                BANK_ACTIONS BA,
                VOUCHER V
            WHERE
                BA.ACTION_ID = #get_account_card.action_id# AND
                BA.ACTION_TYPE_ID = #get_account_card.action_type# AND
                BA.CHEQUE_ID = V.VOUCHER_ID
        </cfquery>
    <cfelseif listfind('8110',get_account_card.action_type,',')>
        <cfquery name="get_ship_id" datasource="#dsn2#">
            SELECT
                SHIP_ID
            FROM
                INVOICE_COST
            WHERE
                INVOICE_COST_ID = #get_account_card.action_id#
        </cfquery>
    </cfif>
    </cfoutput>
</cfsavecontent>
<cf_catalystHeader>
<cf_box>
	<cfform name="add_bill" action="#request.self#?fuseaction=account.emptypopup_upd_bill_cash2cash">
    	<input type="hidden" name="card_id" id="card_id" value="<cfoutput>#attributes.card_id#</cfoutput>">
		<input type="hidden" name="active_period" id="active_period" value="<cfoutput>#session.ep.period_id#</cfoutput>">
		<input type="hidden" name="kur_say" id="kur_say" value="<cfoutput>#get_money_bskt.recordcount#</cfoutput>">
		<input type="hidden" name="action_id"  id="action_id" value="<cfoutput>#get_account_card.action_id#</cfoutput>">
		<input type="hidden" name="money_type" id="money_type" value="">
       
        <div class="ui-form-list row" type="row">
            <div class="col col-3 col-md-6 col-sm-6 col-xs-12" type="column" index="2" sort="true">
                <div class="form-group" id="item-checkbox">
                    <div class="col col-4 col-md-4 col-sm-4 col-xs-12">
                        <input type="checkbox" name="is_other_currency" id="is_other_currency" value="1" onClick="other_money_action();" <cfif get_comp_info.is_other_money>disabled="disabled"</cfif> <cfif get_account_card.is_other_currency eq 1>checked</cfif>>
                        <label><cfoutput>#getLang('account',48)#</cfoutput></label>
                    </div>
                    <cfif session.ep.our_company_info.is_ifrs eq 1>
                        <div class="col col-4 col-md-4 col-sm-4 col-xs-12">
                            <input type="checkbox" name="is_ifrs" id="is_ifrs" value="1" onClick="ifrs_action();" checked>
                            <label><cf_get_lang_main no='718.UFRS Kod'></label>
                        </div>
                        <div class="col col-4 col-md-4 col-sm-4 col-xs-12">
                            <input type="checkbox" name="IS_ACCOUNT_CODE2" id="IS_ACCOUNT_CODE2" value="1" onClick="private_code_action();" <cfif get_account_card.IS_ACCOUNT_CODE2 eq 1>checked</cfif>>
                            <label><cf_get_lang_main no='377.Özel Kod'></label>
                        </div>
                    </cfif>
                </div>
                <div class="form-group" id="item-process_date">
                    <label class="col col-4 col-xs-12"><cf_get_lang_main no='330.Tarih'> *</label>
                    <div class="col col-8 col-xs-12">
                        <div class="input-group">
                            <cfsavecontent variable="message"><cf_get_lang_main no='59.Eksik Veri'>:<cf_get_lang_main no='330.Tarih'></cfsavecontent>
                            <cfinput type="text" name="process_date" required="Yes" message="#message#" validate="#validate_style#" value="#dateformat(get_account_card.ACTION_DATE,dateformat_style)#" onblur="change_money_info('add_bill','process_date');" readonly>
                            <span class="input-group-addon btnPointer"><cf_wrk_date_image date_field="process_date" call_function="change_money_info" control_date="#dateformat(get_account_card.ACTION_DATE,dateformat_style)#"></span>
                        </div>
                    </div>
                </div>
                <div class="form-group" id="item-process_cat">
                    <label class="col col-4 col-xs-12"><cf_get_lang_main no="388.İşlem Tipi"> *</label>
                    <div class="col col-8 col-xs-12"><cf_workcube_process_cat process_cat="#get_account_card.card_cat_id#" slct_width="180px;"></div>
                </div>
                <div class="form-group" id="item-paper_no">
                    <label class="col col-4 col-xs-12"><cf_get_lang_main no='468.Belge No'></label>
                    <div class="col col-8 col-xs-12">
                        <input type="text" name="paper_no" id="paper_no" value="<cfoutput>#get_account_card.paper_no#</cfoutput>" maxlength="25">
                    </div>	
                </div>
                <div class="form-group" id="item-document_type">
                    <label class="col col-4 col-xs-12"><cf_get_lang_main no='1121.Belge Tipi'></label>
                    <div class="col col-8 col-xs-12">
                        <select name="document_type" id="document_type" onchange="display_duedate()">
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
                        <select name="payment_type" id="payment_type">
                            <option value=""><cf_get_lang_main no='322.Seçiniz'></option>
                            <cfoutput query="get_account_card_payment_types">
                                <option value="#payment_type_id#" <cfif get_account_card.card_payment_method eq payment_type_id>selected</cfif>>#payment_type#</option>
                            </cfoutput>
                        </select>
                    </div>	
                </div>
            </div>
            <div class="col col-3 col-md-6 col-sm-6 col-xs-12" type="column" index="1" sort="true">
                <cfif is_dsp_cari_member eq 1>
                    <div class="form-group" id="item-member_name">
                        <label class="col col-4 col-xs-12"><cf_get_lang_main no='107.Cari Hesap'></label>
                        <div class="col col-8 col-xs-12">
                            <div class="input-group">
                                <input type="hidden" name="member_type" id="member_type" value="<cfif len(get_account_card.acc_company_id)>partner<cfelseif len(get_account_card.acc_consumer_id)>consumer</cfif>">
                                <input type="hidden" name="member_id" id="member_id" value="<cfif len(get_account_card.acc_company_id)><cfoutput>#get_account_card.acc_company_id#</cfoutput><cfelseif len(get_account_card.acc_consumer_id)><cfoutput>#get_account_card.acc_consumer_id#</cfoutput></cfif>">
                                <input name="member_name" type="text" id="member_name" onFocus="AutoComplete_Create('member_name','MEMBER_NAME,MEMBER_PARTNER_NAME','MEMBER_NAME,MEMBER_PARTNER_NAME','get_member_autocomplete','\'1,2\',0,0,0','MEMBER_TYPE,MEMBER_ID','member_type,member_id','','3','250');" value="<cfif len(get_account_card.acc_company_id) and len(get_company_name.fullname)><cfoutput>#get_company_name.fullname#</cfoutput><cfelseif len(get_account_card.acc_consumer_id) and len(get_consumer_name.consumer_fullname)><cfoutput>#get_consumer_name.consumer_fullname#</cfoutput></cfif>" autocomplete="off">
                                <span class="input-group-addon btnPointer icon-ellipsis" onclick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_pars&field_member_name=add_bill.member_name&field_name=add_bill.member_name&field_type=add_bill.member_type&field_comp_id=add_bill.member_id&field_consumer=add_bill.member_id&select_list=2,3<cfif session.ep.isBranchAuthorization>&is_store_module=1</cfif>','list');"></span>
                            </div>
                        </div>
                    </div>
                </cfif>
                <cfif session.ep.isBranchAuthorization eq 0>
                    <div class="form-group" id="item-branch_id">
                        <label class="col col-4 col-xs-12"><cf_get_lang_main no='41.Şube'></label>
                        <div class="col col-8 col-xs-12">
                            <select name="acc_branch_id" id="acc_branch_id">
                                <option value=""><cf_get_lang_main no='322.Seçiniz'></option>
                                <cfoutput query="get_branchs">
                                    <option value="#BRANCH_ID#" <cfif GET_ACCOUNT_ROWS_MAIN_ALL.ACC_BRANCH_ID eq branch_id>selected</cfif>>#BRANCH_NAME#</option>
                                </cfoutput>
                            </select>
                        </div>
                    </div>
                </cfif>
                <div class="form-group" id="item-bill_no">
                    <label class="col col-4 col-xs-12"><cfoutput>#getLang('account',51)#</cfoutput></label>
                    <div class="col col-8 col-xs-12">
                        <input type="text" name="bill_NO" id="bill_NO" value="<cfoutput>#get_account_card.BILL_NO#</cfoutput>" disabled>
                    </div>
                </div>
                <div class="form-group" id="item-mahsup_bill_no">
                    <label class="col col-4 col-xs-12"><cfoutput>#getLang('account',57)#</cfoutput></label>
                    <div class="col col-8 col-xs-12">
                        <cfsavecontent variable="message1"><cf_get_lang_main no='59.Eksik veri'>:<cf_get_lang no='43.Fiş Numarası'></cfsavecontent>
                        <cfinput type="text" validate="integer" name="MAHSUP_BILL_NO" required="yes" message="#message1#" value="#get_account_card.CARD_TYPE_NO#">
                    </div>
                </div>
                <div class="form-group"  id="item-due_date" <cfif get_account_card.card_document_type neq -1 AND get_account_card.card_document_type neq -3>style="display:none"</cfif>>
                    <label class="col col-4 col-xs-12"><cf_get_lang_main no='469.Vade Tarihi'></label>
                    <div class="col col-8 col-xs-12">
                        <div class="input-group">
                            <cfinput type="text" name="due_date" value="#dateformat(get_account_card.due_date,dateformat_style)#" maxlength="10" validate="#validate_style#" valign="top">
                            <div class="input-group-addon btnPointer">
                                <cf_wrk_date_image date_field="due_date" call_function="change_money_info">
                            </div>
                        </div>
                    </div>
                </div>
                <div class="form-group" id="item-detail">
                    <label class="col col-4 col-xs-12"><cf_get_lang_main no='217.Açıklama'></label>
                    <div class="col col-8 col-xs-12"><textarea name="bill_detail" id="bill_detail" maxlength="500" onkeyup="return ismaxlength(this);" onBlur="return ismaxlength(this);"><cfoutput>#get_account_card.CARD_DETAIL#</cfoutput></TEXTAREA></div>
                </div>
            </div>
            <div class="col col-2 col-md-6 col-sm-6 col-xs-12" type="column" index="3" sort="true">
                <cfif get_money_bskt.recordcount>
                    <div class="col col-12 padding-left-5">
                        <label class="bold"><cf_get_lang_main no='265.Dövizler'></label>
                    </div>
                </cfif>
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
                                    <div class="col col-4 col-md-4 col-sm-4 col-xs-12"><label>#MONEY# #TLFormat(RATE1,0)#/</label></div>
                                    <div class="col col-8 col-xs-12">
                                        <input type="text" name="txt_rate2_#currentrow#" id="txt_rate2_#currentrow#" <cfif readonly_info>readonly</cfif> value="#TLFormat(rate2,session.ep.our_company_info.rate_round_num)#"  class="box" onkeyup="return(FormatCurrency(this,event,#session.ep.our_company_info.rate_round_num#));" onBlur="if(parseFloat(filterNum(this.value,8))<=0) this.value=commaSplit(1);f_kur_hesapla_multi();hesapla();">
                                    </div>
                                </div>
                            </cfoutput>
                        </cfif>
                    </div>
                </div>
            </div>
            <div class="col col-2 col-md-6 col-sm-6 col-xs-12 padding-top-15" type="column" index="4" sort="true">
                <div class="form-group">
                    <div class="col col-4 col-md-4 col-sm-4 col-xs-12">
                        <label width="50" class="txtbold"><cf_get_lang_main no='175.Borç'></label>
                    </div>
                    <div class="col col-8 col-md-8 col-sm-8 col-xs-12 text-right">
                        <label id="td_debt_ust"></label>
                        <label width="30"></label>
                    </div>
                </div>
                <div class="form-group">
                    <div class="col col-4 col-md-4 col-sm-4 col-xs-12">
                        <label class="txtbold"><cf_get_lang_main no='176.Alacak'></label>
                    </div>
                    <div class="col col-8 col-md-8 col-sm-8 col-xs-12 text-right">
                        <label  id="td_claim_ust">&nbsp;</label>
                        <label width="30"></label>
                    </div>
                </div>
                <div class="form-group">
                    <div class="col col-4 col-md-4 col-sm-4 col-xs-12">
                        <label class="txtbold"><cfoutput>#getLang('account',123)#</cfoutput></label>
                    </div>
                    <div class="col col-8 col-md-8 col-sm-8 col-xs-12 text-right">
                        <label id="td_bakiye_ust">&nbsp;</label>
                        <label width="30" id="td_bakiye_ust_ba"></label>
                    </div>
                </div>
            </div>
        </div>
        <div class="row">
            <cfinclude template="add_bill_frame_cash2cash.cfm">
        </div>
        <cf_box_footer>
            <div class="col col-6"><cf_record_info query_name="get_account_card"></div>
            <div class="col col-6">
                <cfif not (len(GET_ACCOUNT_CARD.ACTION_ID) and CONTROL_ACC_UPDATE.IS_ACCOUNT_CARD_UPDATE eq 0) OR GET_ACCOUNT_CARD.ACTION_TYPE eq 17 > 
                    <cfif isdefined("get_account_rows_main") and not Find("copy",attributes.fuseaction,0)>
                        <cf_workcube_buttons is_upd='1'  is_cancel="0" add_function="control_add()" del_function="kontrol2()">
                    <cfelse>
                        <cf_workcube_buttons is_upd='0' add_function="control_add()">
                    </cfif>
                </cfif>
            </div>
        </cf_box_footer>
            
    </cfform>
</cf_box>
<script type="text/javascript">
        try{
            window.onload = function () { change_money_info('add_bill','process_date');}
        }
        catch(e){}
	function ekle()
	{
		window.opener.location.href='<cfoutput>#request.self#</cfoutput>?fuseaction=account.form_add_bill_cash2cash';
		window.close();
	}

	function control_add()
	{
		if (!check_display_files('add_bill'))
			return false;
		return kontrol();
	}

	function display_duedate()
	{
		if(document.getElementById('document_type').value == -1 || document.getElementById('document_type').value == -3)
			document.getElementById('item-due_date').style.display = '';
		else
			document.getElementById('item-due_date').style.display = 'none';
	}
</script>