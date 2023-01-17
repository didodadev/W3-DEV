<!---
	File: add_bank_action.cfm
	Author: Gramoni-Mahmut <mahmut.cifci@gramoni.com>
	Date: 02.08.2019
	Controller: WodibaBankActionsController.cfm
	Description:
		Banka işlemleri listesinden kayıt eklemek için kullanılır.
--->
<script type="text/javascript">
	function formatMoney(n) {
		sonuc= parseFloat(n).toFixed(2).replace(/(\d)(?=(\d{3})+\.)/g, '$1.').replace(/\.(\d+)$/,',$1');
		
	}
</script>

<cfscript>
	if(Not isDefined("attributes.form_submitted")){
		attributes.definition_id =  0;
	}

	include '../cfc/Functions.cfc';

	wdb_bank_action     = GetBankActionWithId(ActionId=attributes.id);
	account_info        = GetAccountInfo(AccountId=wdb_bank_action.ACCOUNT_ID);
	if (Not Len(wdb_bank_action.ISLEMKODU)){//İşlem kodu gelmeyen hareketler için
		ISLEMKODU = 0;
	}
	else {
		ISLEMKODU = wdb_bank_action.ISLEMKODU;
	}

	in_out              = iIf(wdb_bank_action.MIKTAR Gt 0,de('IN'),de('OUT'));
	get_process_type    = GetProcessType(BankCode=account_info.BANK_CODE, TransactionCode=ISLEMKODU, InOut=in_out);

	if(isDefined("attributes.form_submitted")){
		if(Not isDefined('attributes.wdb_start_date')){
			attributes.wdb_start_date = '';
		}
		else{
			attributes.wdb_start_date = dateFormat(attributes.wdb_start_date,dateformat_style);
		}
	}
</cfscript>

<cfif Not get_process_type.RecordCount>
	<script type="text/javascript">
		alert('<cfoutput>#account_info.BANK_NAME# #wdb_bank_action.ISLEMKODU#</cfoutput> işlem kodu için tanımlama bulunamadı!\nSistem yöneticisi ile iletişime geçiniz!');
		window.close();
	</script>
	<cfexit method="exittemplate" />
</cfif>

<cfscript>
	getCCNOKey = createObject("component", "V16.settings.cfc.setupCcnoKey");
	getCCNOKey.dsn = dsn;
	getCCNOKey1 = getCCNOKey.getCCNOKey1();
	getCCNOKey2 = getCCNOKey.getCCNOKey2();
</cfscript>

<cfquery name="GET_CREDITCARD" datasource="#dsn3#">
	SELECT
		*
	FROM
		CREDIT_CARD
	WHERE 
		ACCOUNT_ID = #wdb_bank_action.ACCOUNT_ID#
	ORDER BY
		CREDITCARD_ID
</cfquery>

<cfquery name="GET_EXPENSE_CENTER" datasource="#dsn2#">
	SELECT EXPENSE_ID, EXPENSE, EXPENSE_CODE FROM EXPENSE_CENTER ORDER BY EXPENSE
</cfquery>

<cfquery name="GET_EXPENSE_ITEMS" datasource="#dsn2#">
	SELECT EXPENSE_ITEM_ID, ACCOUNT_CODE, EXPENSE_ITEM_NAME FROM EXPENSE_ITEMS ORDER BY ACCOUNT_CODE, EXPENSE_ITEM_NAME
</cfquery>

<cfquery name="get_branch" datasource="#dsn#">
	SELECT BRANCH_ID, BRANCH_NAME FROM BRANCH WHERE COMPANY_ID = #session.ep.company_id# ORDER BY BRANCH_NAME
</cfquery>

<cfquery name="get_department" datasource="#dsn#">
	SELECT
		DEPARTMENT_ID,
		DEPARTMENT_HEAD
	FROM
		DEPARTMENT
	WHERE
		DEPARTMENT_STATUS = 1
		AND IS_STORE <> 1
	ORDER BY
		DEPARTMENT_HEAD
</cfquery>
<cfquery name="GET_BANK_ORDER" datasource="#dsn2#">
	SELECT 
		BON.*,
		BB.BANK_NAME,
		BB.BANK_BRANCH_NAME,
		A.ACCOUNT_NO,
		A.ACCOUNT_ORDER_CODE,
		SA.ACC_TYPE_NAME
	FROM 
		BANK_ORDERS BON
		LEFT JOIN #dsn_alias#.SETUP_ACC_TYPE SA ON SA.ACC_TYPE_ID = BON.ACC_TYPE_ID
		,#dsn3_alias#.ACCOUNTS AS A,
		#dsn3_alias#.BANK_BRANCH AS BB
	WHERE 		
		A.ACCOUNT_ID = BON.ACCOUNT_ID AND
		A.ACCOUNT_BRANCH_ID = BB.BANK_BRANCH_ID 
</cfquery>
<cfscript>
	subscription_id = get_bank_order.subscription_id;
	if(len(subscription_id))
			subscription_no = get_subscription_no(subscription_id);
	else
		subscription_no = "";
</cfscript>
<cfset module_name = 'bank' />
<cfsavecontent variable="head_text">
<title><cf_get_lang_main no='2806.Wodiba'> - <cfoutput>#get_process_type.PROCESS_CAT#</cfoutput> - <cf_get_lang_main no='1081.Kayıt Ekle'></title>
</cfsavecontent>
<cfhtmlhead text="#head_text#" />
<cf_box title="#getLang('main','',59355,'Wodiba')# - #get_process_type.PROCESS_CAT# - #getLang('main','',58493,'Kayıt Ekle')#" scroll="1" collapsable="1" resize="1" popup_box="#iif(isdefined("attributes.draggable"),1,0)#">
<cfoutput>
<form name="wdb_add_bank_action" id="wdb_add_bank_action" method="post" action="#request.self#?fuseaction=bank.wodiba_bank_actions&event=add&id=#attributes.id#">
	<input type="hidden" name="form_submitted" value="1" />
	<input type="hidden" name="form_id" value="#attributes.id#" />
	 <div class="row">
		 <div class="col col-12  uniqueRow">
			<div class="row formContent">
			  <div class="row col-8" type="row">
				<!--- Hesap --->
				<div class="form-group" id="item-account_name">
					<label class="col col-4 col-xs-12" for="account_name"><cf_get_lang_main no='240.Hesap'></label>
					<div class="col col-8 col-xs-12">#account_info.ACCOUNT_NAME# (#account_info.ACCOUNT_NO#)</div>
				</div>
				<!--- İşlem Kodu --->
				<div class="form-group" id="item-transaction_code">
					<label class="col col-4 col-xs-12" for="transaction_code"><cf_get_lang dictionary_id='48886.İşlem Kodu'></label>
					<div class="col col-8 col-xs-12">#wdb_bank_action.ISLEMKODU#</div>
				</div>
				<!--- Dekont no --->
				<div class="form-group" id="item-paper_no">
					<label class="col col-4 col-xs-12" for="paper_no"><cf_get_lang_main no='650.Dekont'></label>
					<div class="col col-8 col-xs-12">#wdb_bank_action.DEKONTNO#</div>
				</div>
				<!--- İşlem tarihi --->
				<div class="form-group" id="item-process_date">
					<label class="col col-4 col-xs-12" for="process_date"><cf_get_lang_main no='467.İşlem tarihi'></label>
					<div class="col col-8 col-xs-12">#dateFormat(wdb_bank_action.TARIH,"dd.mm.YYYY")# #timeFormat(wdb_bank_action.TARIH,"HH:mm:ss")#</div>
				</div>
				<cfif wdb_bank_action.DOVIZTURU Eq 'TRY'><cfset DOVIZTURU = 'TL' /><cfelse><cfset DOVIZTURU = wdb_bank_action.DOVIZTURU /></cfif>
				<!--- Tutar --->
				<div class="form-group" id="item-amount">
					<label class="col col-4 col-xs-12" for="amount"><cf_get_lang_main no='261.Tutar'></label>
					<div class="col col-8 col-xs-12"><cf_wrk_crypto_gdpr mode="3" pattern="3" sensitive_label="7" data="#TLFormat(wdb_bank_action.MIKTAR)#"> <cf_wrk_crypto_gdpr mode="3" pattern="3" sensitive_label="7" data="#DOVIZTURU#"></div>
				</div>
				<!--- İşlem tipi --->
				<div class="form-group" id="item-process_cat_id">
					<label class="col col-4 col-xs-12" for="process_cat_id"><cf_get_lang_main no='388.İşlem tipi'><strong style="color:red">*</strong></label>
					<div class="col col-8 col-xs-12">
						<select name="process_cat_id" id="process_cat_id" style="width:100px;">
							<option value=""><cf_get_lang_main no='322.Seçiniz'></option>
							<cfloop query="get_process_type">
								<option value="#PROCESS_CAT_ID#">#PROCESS_CAT# (#PROCESS_CAT_ID#)</option>
							</cfloop>
						</select>
					</div>
				</div>
				<!--- IBAN --->
				<div class="form-group" id="item-iban">
					<label class="col col-4 col-xs-12" for="iban">IBAN</label>
					<div class="col col-8 col-xs-12">
						<input type="text" name="iban" id="iban" value="#wdb_bank_action.KARSIIBAN#" readonly="readonly" />
					</div>
				</div>
				<!--- VKN --->
				<div class="form-group" id="item-vkn">
					<label class="col col-4 col-xs-12" for="vkn">VKN</label>
					<div class="col col-8 col-xs-12">
						<input type="text" name="vkn" id="vkn" value="#wdb_bank_action.KARSIVKN#" readonly="readonly" />
					</div>
				</div>
				<!--- Açıklama --->
				<div class="form-group" id="item-description">
					<label class="col col-4 col-xs-12" for="description"><cf_get_lang_main no='217.Açıklama'></label>
					<div class="col col-8 col-xs-12">
						<textarea name="description" id="description" style="width:150px;height:80px;">#wdb_bank_action.ACIKLAMA#</textarea>
					</div>
				</div>
				<!--- Kredi Sözleşmesi --->
				<div class="form-group" id="item-credit_contract">
					<label class="col col-4 col-xs-12" for="mck_credit_contract_id"><cf_get_lang dictionary_id='29652.Kredi Sözleşmesi'><strong style="color:red">*</strong></label>
					<div class="col col-8 col-xs-12">
						<div class="input-group">
							<input type="hidden" name="mck_credit_contract_id" id="mck_credit_contract_id" value="" />
							<input type="text" name="mck_credit_contract" id="mck_credit_contract" style="width:115px;" value="" autocomplete="off" />
							<span class="input-group-addon btnPointer icon-ellipsis" onclick="windowopen('#request.self#?fuseaction=credit.list_credit_contract&event=contract&mck_form_input_id=wdb_add_bank_action.mck_credit_contract_id&mck_form_input_name=wdb_add_bank_action.mck_credit_contract','list');" title="#getLang('report',1644)#"></span>
						</div>
					</div>
				</div>
				<!--- Çek --->
				<div class="form-group" id="item-cheque">
					<label class="col col-4 col-xs-12" for="cheque_id"><cf_get_lang_main no='595.Çek'></label>
					<div class="col col-8 col-xs-12">
						<div class="input-group">
							<input type="text" name="cheque_id" id="cheque_id" style="width:115px;" value="" autocomplete="off" />
							<span class="input-group-addon btnPointer icon-ellipsis" onclick="windowopen('#request.self#?fuseaction=cheque.popup_selct_cheque&is_other_act=0&control=&out_bank=1&company_id=&consumer_id=&employee_id=&cur_id=<cfif wdb_bank_action.DOVIZTURU Eq 'TRY'>TL<cfelse>#wdb_bank_action.DOVIZTURU#</cfif>&acc_id=#wdb_bank_action.ACCOUNT_ID#&to_cash_id=&cash_id=','list');" title="#getLang('main',595)#"></span>
						</div>
					</div>
				</div>
				<!--- Senet --->
				<div class="form-group" id="item-voucher">
					<label class="col col-4 col-xs-12" for="voucher_id"><cf_get_lang_main no='596.Senet'></label>
					<div class="col col-8 col-xs-12">
						<div class="input-group">
							<input type="text" name="voucher_id" id="voucher_id" style="width:115px;" value="" autocomplete="off" />
							<span class="input-group-addon btnPointer icon-ellipsis" onclick="windowopen('#request.self#?fuseaction=cheque.popup_selct_voucher&is_other_act=0&control=&company_id=&consumer_id=&employee_id=&cur_id=<cfif wdb_bank_action.DOVIZTURU Eq 'TRY'>TL<cfelse>#wdb_bank_action.DOVIZTURU#</cfif>&acc_id=#wdb_bank_action.ACCOUNT_ID#&to_cash_id=&cash_id=','list');" title="#getLang('main',596)#"></span>
						</div>
					</div>
				</div>
				<!--- Karşı işlem --->
				<div class="form-group" id="item-other_action">
					<label class="col col-4 col-xs-12" for="other_action_id"><cf_get_lang dictionary_id='59806.Karşı İşlem'><strong style="color:red">*</strong></label>
					<div class="col col-8 col-xs-12">
						<div class="input-group">
							<input type="hidden" name="other_action_id" id="other_action_id" value="" />
							<input type="text" name="other_action" id="other_action" style="width:115px;" value="" autocomplete="off" />
							<span class="input-group-addon btnPointer icon-ellipsis" onclick="windowopen('#request.self#?fuseaction=bank.wodiba_bank_actions&event=action&id=#attributes.id#&form_input_id=wdb_add_bank_action.other_action_id&form_input_name=wdb_add_bank_action.other_action','list');" title="#getLang('report',1644)#"></span>
						</div>
					</div>
				</div>
				<!--- Kredi Kartı --->
				<div class="form-group" id="item-credit_card">
					<label class="col col-4 col-xs-12" for="credit_card"><cf_get_lang_main no='787.Kredi Kartı'><strong style="color:red">*</strong></label><!---58199--->
					<div class="col col-8 col-xs-12">
						<select name="credit_card_id" id="credit_card_id">
							<option value=""><cf_get_lang_main no='322.Seçiniz'></option>
							<cfloop query="get_creditcard">
								<cfset key_type = '#session.ep.company_id#'>
								<cfif getCCNOKey1.recordcount and getCCNOKey2.recordcount>
									<cfset ccno_key1 = contentEncryptingandDecodingAES(isEncode:0,accountKey:getCCNOKey1.record_emp,content:getCCNOKey1.ccnokey) />
									<cfset ccno_key2 = contentEncryptingandDecodingAES(isEncode:0,accountKey:getCCNOKey2.record_emp,content:getCCNOKey2.ccnokey) />
									<cfset content = contentEncryptingandDecodingAES(isEncode:0,content:get_creditcard.creditcard_number,accountKey:key_type,key1:ccno_key1,key2:ccno_key2) />
									<cfset content = '#mid(content,1,4)#********#mid(content,Len(content) - 3, Len(content))#'>
								<cfelse>
									<cfset content = '#mid(Decrypt(get_creditcard.creditcard_number,key_type,"CFMX_COMPAT","Hex"),1,4)#********#mid(Decrypt(get_creditcard.creditcard_number,key_type,"CFMX_COMPAT","Hex"),Len(Decrypt(get_creditcard.creditcard_number,key_type,"CFMX_COMPAT","Hex")) - 3, Len(Decrypt(get_creditcard.creditcard_number,key_type,"CFMX_COMPAT","Hex")))#'>
								</cfif>
								<option value="#creditcard_id#">#content#</option>
							</cfloop>
						</select>
					</div>
				</div>
				<!--- Masraf merkezi --->
				<div class="form-group" id="item-expense_center">
					<label class="col col-4 col-xs-12" for="expense_center_id"><cfif get_process_type.PROCESS_TYPE eq 292><cf_get_lang_main no='760.Gelir merkezi'><cfelse><cf_get_lang_main no='1048.Masraf merkezi'></cfif><cfif get_process_type.PROCESS_TYPE eq 120 or get_process_type.PROCESS_TYPE eq 121 or get_process_type.PROCESS_TYPE eq 291 or get_process_type.PROCESS_TYPE eq 292><strong style="color:red">*</strong></cfif></label>
					<div class="col col-8 col-xs-12">
						<select name="expense_center_id" id="expense_center_id">
							<option value=""><cf_get_lang_main no='322.Seçiniz'></option>
							<cfloop query="get_expense_center">
								<option value="#EXPENSE_ID#">#expense#</option>
							</cfloop>
						</select>
					</div>
				</div>
				<!--- Masraf merkezi 2--->
				<div class="form-group" id="item-expense_center2">
					<label class="col col-4 col-xs-12" for="expense_center_id2"><cfif get_process_type.PROCESS_TYPE eq 292><cf_get_lang_main no='760.Gelir merkezi'><cfelse><cf_get_lang_main no='1048.Masraf merkezi'></cfif>2</label><!---58172--->
					<div class="col col-8 col-xs-12">
						<select name="expense_center_id2" id="expense_center_id2">
							<option value=""><cf_get_lang_main no='322.Seçiniz'></option>
							<cfloop query="get_expense_center">
								<option value="#EXPENSE_ID#">#expense#</option>
							</cfloop>
						</select>
					</div>
				</div>
				<!--- Bütçe kalemi --->
				<div class="form-group" id="item-expense_item">
					<label class="col col-4 col-xs-12" for="expense_item_id"><cf_get_lang_main no='822.Bütçe kalemi'><cfif get_process_type.PROCESS_TYPE eq 120 or get_process_type.PROCESS_TYPE eq 121><strong style="color:red">*</strong></cfif></label>
					<div class="col col-8 col-xs-12">
						<select name="expense_item_id" id="expense_item_id">
							<option value=""><cf_get_lang_main no='322.Seçiniz'></option>
							<cfloop query="get_expense_items">
								<option value="#EXPENSE_ITEM_ID#">#ACCOUNT_CODE#-#EXPENSE_ITEM_NAME#</option>
							</cfloop>
						</select>
					</div>
				</div>
				<!---Masraf/Gelir--->
				<div class="form-group" id="item-money">
					<label class="col col-4 col-xs-12" for="money"><cfif get_process_type.PROCESS_TYPE eq 292><cf_get_lang dictionary_id="58677.GELİR"><cfelse><cf_get_lang dictionary_id="58930.MASRAF"></cfif></label>
					<div class="col col-8 col-xs-12">
						<div class="input-group">
							<cfinclude template="/V16/project/query/get_money_currency.cfm">
							<input type="hidden" name="money_id" id="money_id" value="" />
							<input type="text" name="money" id="money" style="width:115px;" value="" class="moneybox" onkeyup="return(FormatCurrency(this,event));"/>
							<span class="input-group-addon">
								<select name="budget_currency" id="budget_currency">                           
									<cfloop query="get_money">
										<option value="#money#" <cfif session.ep.money eq money>selected</cfif>>#money#</option>
									</cfloop>
								</select> 
							</span>
							<span class="input-group-addon btnPointer icon-ellipsis" onclick="windowopen('#request.self#?fuseaction=bank.wodiba_bank_actions&event=money&account_id=#wdb_bank_action.ACCOUNT_ID#&form_input_id=wdb_add_bank_action.money_id&form_input_name=wdb_add_bank_action.money&form_input_name1=wdb_add_bank_action.budget_currency','list');" title="#getLang('report',1644)#"></span>
						</div>
					</div>
				</div>
				<!--- Kasa --->
				<div class="form-group" id="item-cash">
					<label class="col col-4 col-xs-12" for="cash_id"><cf_get_lang_main no='108.Kasa'><strong style="color:red">*</strong></label><!---57520--->
					<div class="col col-8 col-xs-12">
						<cfif wdb_bank_action.DOVIZTURU Eq 'TRY'>
							<cfset attributes.cash_currency_id="TL"/>
						<cfelse>
							<cfset attributes.cash_currency_id="#wdb_bank_action.DOVIZTURU#"/>
						</cfif>

						<cfinclude template="/V16/cash/query/get_cashes_list.cfm">
						<select name="cash_id" id="cash_id">
							<option value=""><cf_get_lang_main no='322.Seçiniz'></option>
							<cfloop query="get_cashes">
								<option value="#get_cashes.CASH_ID#">#get_cashes.CASH_NAME#</option>
							</cfloop>
						</select>
					</div>
				</div>
				<!---Parayı Yatıran/Çeken--->
				<div class="form-group" id="item-employee">
					<label class="col col-4 col-xs-12" for="employee"><cfif get_process_type.PROCESS_TYPE eq 21><cf_get_lang dictionary_id='48713.Para Yatıran'><cfelse><cf_get_lang dictionary_id='48712.Parayı Çeken'></cfif></label>
					<div class="col col-8 col-xs-12">
						<div class="input-group">
							<input type="hidden" name="EMPLOYEE_ID" id="EMPLOYEE_ID" value="<cfoutput>#session.ep.userid#</cfoutput>" />
							<input type="text" name="EMPLOYEE" id="EMPLOYEE" style="width:115px;" onFocus= "AutoComplete_Create('EMPLOYEE','MEMBER_NAME','MEMBER_NAME','get_member_autocomplete','3','EMPLOYEE_ID','EMPLOYEE_ID','','2','250');" value="#get_emp_info(session.ep.userid,0,0)#" autocomplete="off"/>
							<span class="input-group-addon btnPointer icon-ellipsis" onclick="windowopen('#request.self#?fuseaction=objects.popup_list_positions&field_emp_id=wdb_add_bank_action.EMPLOYEE_ID&field_name=wdb_add_bank_action.EMPLOYEE<cfif session.ep.isBranchAuthorization>&is_store_module=1</cfif>&select_list=1,9','list');"></span>
						</div>
					</div>
				</div>
				 <!--- Cari hesap --->
				 <div class="form-group" id="item-ch_company">
					<label class="col col-4 col-xs-12" for="ch_company"><cf_get_lang_main no='107.Cari hesap'><cfif get_process_type.PROCESS_TYPE eq 24 or get_process_type.PROCESS_TYPE eq 25><strong style="color:red">*</strong></cfif></label>
					<div class="col col-8 col-xs-12">
						<div class="input-group">
							<input type="hidden" name="ch_member_type" id="ch_member_type" value="">
							<input type="hidden" name="ch_company_id" id="ch_company_id" value="">
							<input type="hidden" name="ch_consumer_id" id="ch_consumer_id" value="">
							<input type="hidden" name="ch_employee_id"  id="ch_employee_id"value="">
							<input type="text" name="ch_company" id="ch_company" style="width:120px;" value="" autocomplete="off">
							<span class="input-group-addon btnPointer icon-ellipsis" onclick="windowopen('#request.self#?fuseaction=objects.popup_list_pars&field_name=wdb_add_bank_action.ch_company&is_cari_action=1&field_type=wdb_add_bank_action.ch_member_type&field_comp_name=wdb_add_bank_action.ch_company&field_consumer=wdb_add_bank_action.ch_consumer_id&field_emp_id=wdb_add_bank_action.ch_employee_id&field_comp_id=wdb_add_bank_action.ch_company_id&select_list=2,3,1,9','list');" title="#getLang('main',107)#"></span>
						</div>
					</div>
				</div>
				<!--- Proje --->
				<div class="form-group" id="item-project">
					<label class="col col-4 col-xs-12" for="project"><cf_get_lang_main no='4.Proje'></label>
					<div class="col col-8 col-xs-12">
						<div class="input-group">
							<input type="hidden" name="project_id" id="project_id" value="" />
							<input type="text" name="project" id="project" style="width:115px;" onFocus="AutoComplete_Create('project','PROJECT_HEAD','PROJECT_HEAD','get_project','','PROJECT_ID','project_id','','3','200');" value="" autocomplete="off" />
							<span class="input-group-addon btnPointer icon-ellipsis" onclick="openBoxDraggable('#request.self#?fuseaction=objects.popup_list_projects&project_id=wdb_add_bank_action.project_id&project_head=wdb_add_bank_action.project');" title="#getLang('main',4)#"></span>
						</div>
					</div>
				</div>
				<!--- Ödeme yöntemi --->
				<div class="form-group" id="item-payment_type">
					<label class="col col-4 col-xs-12" for="paymethod"><cf_get_lang_main no='1104.Ödeme yöntemi'></label>
					<div class="col col-8 col-xs-12">
						<div class="input-group">
							<input type="hidden" name="card_paymethod_id" id="card_paymethod_id" value="" />
							<input type="hidden" name="paymethod_id" id="paymethod_id" value="" />
							<input type="text" name="paymethod" placeholder="<cf_get_lang_main no='1104.Ödeme Yöntemi'>" id="paymethod" value="">
							<span class="input-group-addon btnPointer icon-ellipsis"onclick="windowopen('#request.self#?fuseaction=objects.popup_paymethods&field_id=wdb_add_bank_action.paymethod_id&field_name=wdb_add_bank_action.paymethod&field_card_payment_id=wdb_add_bank_action.card_paymethod_id&field_card_payment_name=wdb_add_bank_action.paymethod','list');"></span>
						</div>
					</div>
				</div>
				<!--- Tahsilat Ödeme Tipi --->
				<div class="form-group" id="item-special_definition">
					<label class="col col-4 col-xs-12" for="special_definition"><cf_get_lang_main no='2774.Tahsilat Ödeme Tipi'></label>
					<div class="col col-8 col-xs-12">
						<cf_wrk_special_definition width_info="183" list_filter_info="1" field_id="special_definition_id" selected_value='' >
					</div>
				</div>
				<!---Abone Numarası--->
				<div class="form-group" id="item-subscriber">
					<label class="col col-4 col-xs-12" for="subscriber"><cf_get_lang_main no='1705.Abone No'></label><!---29502--->
					<div class="col col-8 col-xs-12">
						<cf_wrk_subscriptions fieldId='subscription_id' fieldName='subscription_no' form_name='wdb_add_bank_action' subscription_id='#subscription_id#' subscription_no='#subscription_no#'>
					</div>
				</div>
				<!--- Fiziki varlık --->
				<div class="form-group" id="item-asset">
					<label class="col col-4 col-xs-12" for="asset_id"><cf_get_lang_main no='1421.Fiziki varlık'></label>
					<div class="col col-8 col-xs-12">
						<cf_wrkassetp fieldid='asset_id' width="110" fieldname='asset_name' form_name='wdb_add_bank_action' asset_id='' button_type='plus_thin'>
					</div>
				</div>
				<!--- Şube --->
				<div class="form-group" id="item-branch">
					<label class="col col-4 col-xs-12" for="branch"><cf_get_lang_main no='41.Şube'></label>
					<div class="col col-8 col-xs-12">
						<select name="branch_id" id="branch_id" onChange="showDepartment(this.value)">
							<option value="0"><cf_get_lang_main no='322.Seçiniz'></option>
							<cfloop query="get_branch">
								<option value="#branch_id#">#branch_name#</option>
							</cfloop>
						</select>
					</div>
				</div>
				<!--- Departman --->
				<div class="form-group" id="item-department">
					<label class="col col-4 col-xs-12" for="department"><cf_get_lang_main no='160.Departman'></label>
					<div class="col col-8 col-xs-12" id="department_place">
						<select name="department" id="department">
							<option value="0"><cf_get_lang_main no='160.Departman'></option>
						</select>
					</div>
				</div>
			  </div>
			  <div class="row formContentFooter">
				<div class="col col-12">
					<cf_workcube_buttons is_upd='0' add_function="controlAddBankAction()">
				</div>
			 </div>
			</div>
		 </div>
	 </div>
</form>
</cfoutput>
</cf_box>
<script>
	div_hidden=[];
	div_imperative=[];
	div_imperative.push({id:"process_cat_id option:selected",no:'<cf_get_lang_main no="782.girilmesi zorunlu alan">: <cf_get_lang_main no="388.İşlem Tipi">'});
</script>
<cfif get_process_type.PROCESS_TYPE eq 21>
	<script>
		div_hidden=["item-credit_contract","item-cheque","item-voucher","item-other_action","item-expense_center","item-expense_center2","item-expense_item","item-ch_company","item-payment_type","item-special_definition","item-asset","item-department","item-money","item-subscriber","item-credit_card"];
		div_imperative.push({id:"cash_id option:selected",no:'<cf_get_lang_main no="782.girilmesi zorunlu alan">: <cf_get_lang_main no='108.Kasa'>'});
	</script>
</cfif>
<cfif get_process_type.PROCESS_TYPE eq 22>
	<script>
		div_hidden=["item-credit_contract","item-cheque","item-voucher","item-other_action","item-expense_center","item-expense_center2","item-expense_item","item-ch_company","item-payment_type","item-special_definition","item-asset","item-department","item-money","item-subscriber","item-credit_card"];
		div_imperative.push({id:"cash_id option:selected",no:'<cf_get_lang_main no="782.girilmesi zorunlu alan">: <cf_get_lang_main no='108.Kasa'>'});
	</script>
</cfif>
<cfif get_process_type.PROCESS_TYPE eq 23>
	<script>
		div_hidden=["item-credit_contract","item-cheque","item-voucher","item-ch_company","item-expense_center2","item-payment_type","item-special_definition","item-asset","item-branch","item-department","item-cash","item-employee","item-subscriber","item-credit_card"];
		div_imperative.push({id:"other_action",no:'<cf_get_lang_main no="782.girilmesi zorunlu alan">: <cf_get_lang dictionary_id='59806.Karşı İşlem'>'});
	</script>
</cfif>
<cfif get_process_type.PROCESS_TYPE eq 24>
	<script>
		div_hidden=["item-credit_contract","item-cheque","item-voucher","item-other_action","item-payment_type","item-cash","item-employee","item-credit_card","item-expense_center2"];
		div_imperative.push({id:"ch_company",no:'<cf_get_lang_main no="782.girilmesi zorunlu alan">: <cf_get_lang_main no='107.Cari Hesap'>'});
	</script>
</cfif>
<cfif get_process_type.PROCESS_TYPE eq 25>
	<script>
		div_hidden=["item-credit_contract","item-cheque","item-voucher","item-other_action","item-payment_type","item-cash","item-employee","item-credit_card","item-expense_center2"];
		div_imperative.push({id:"ch_company",no:'<cf_get_lang_main no="782.girilmesi zorunlu alan">: <cf_get_lang_main no='107.Cari Hesap'>'});
	</script>
</cfif>
<cfif get_process_type.PROCESS_TYPE eq 120>
	<script>
		div_hidden=["item-credit_contract","item-cheque","item-voucher","item-other_action","item-payment_type","item-cash","item-employee","item-credit_card","item-expense_center2"];
		div_imperative.push({id:"expense_center_id option:selected",no:'<cf_get_lang_main no="782.girilmesi zorunlu alan">: <cf_get_lang_main no='1048.Masraf merkezi'>'});
		div_imperative.push({id:"expense_item_id option:selected",no:'<cf_get_lang_main no="782.girilmesi zorunlu alan">: <cf_get_lang_main no='822.Bütçe kalemi'>'});
	</script>
</cfif>
<cfif get_process_type.PROCESS_TYPE eq 121>
	<script>
		div_hidden=["item-credit_contract","item-cheque","item-voucher","item-other_action","item-payment_type","item-cash","item-employee","item-credit_card","item-expense_center2"];
		div_imperative.push({id:"expense_center_id",no:'<cf_get_lang_main no="782.girilmesi zorunlu alan">: <cf_get_lang_main no="1048.Masraf merkezi">'});
		div_imperative.push({id:"expense_item_id",no:'<cf_get_lang_main no="782.girilmesi zorunlu alan">: <cf_get_lang_main no="822.Bütçe kalemi">'});
	</script>
</cfif>
<cfif get_process_type.PROCESS_TYPE eq 243>
	<script>
		div_hidden=["item-credit_contract","item-cheque","item-voucher","item-ch_company","item-expense_center2","item-payment_type","item-special_definition","item-asset","item-branch","item-department","item-cash","item-employee","item-subscriber","item-credit_card","item-project","item-other_action"];
	</script>
</cfif>
<cfif get_process_type.PROCESS_TYPE eq 244>
	<script>
		div_hidden=["item-credit_contract","item-cheque","item-voucher","item-ch_company","item-expense_center2","item-payment_type","item-special_definition","item-asset","item-branch","item-department","item-cash","item-employee","item-subscriber","item-project","item-other_action"];
		div_imperative.push({id:"credit_card_id option:selected",no:'<cf_get_lang_main no="782.girilmesi zorunlu alan">: <cf_get_lang_main no="787.Kredi Kartı">'});
	</script>
</cfif>
<cfif get_process_type.PROCESS_TYPE eq 247>
	<script>
		div_hidden=["item-credit_contract","item-cheque","item-voucher","item-ch_company","item-expense_center2","item-payment_type","item-special_definition","item-asset","item-branch","item-department","item-cash","item-employee","item-subscriber","item-credit_card","item-project","item-other_action"];
	</script>
</cfif>
<cfif get_process_type.PROCESS_TYPE eq 248>
	<script>
		div_hidden=["item-credit_contract","item-cheque","item-voucher","item-ch_company","item-expense_center2","item-payment_type","item-special_definition","item-asset","item-branch","item-department","item-cash","item-employee","item-subscriber","item-project","item-other_action"];
		div_imperative.push({id:"credit_card_id option:selected",no:'<cf_get_lang_main no="782.girilmesi zorunlu alan">: <cf_get_lang_main no="787.Kredi Kartı">'});
	</script>
</cfif>
<cfif get_process_type.PROCESS_TYPE eq 291>
	<script>
		div_hidden=["item-cheque","item-voucher","item-payment_type","item-special_definition","item-asset","item-branch","item-department","item-cash","item-employee","item-subscriber","item-credit_card","item-other_action"];
		div_imperative.push({id:"expense_center_id",no:'<cf_get_lang_main no="782.girilmesi zorunlu alan">: <cf_get_lang_main no="1048.Masraf merkezi">'});
	</script>
</cfif>
<cfif get_process_type.PROCESS_TYPE eq 292>
	<script>
		div_hidden=["item-cheque","item-voucher","item-payment_type","item-special_definition","item-asset","item-branch","item-department","item-cash","item-employee","item-subscriber","item-credit_card","item-other_action"];
		div_imperative.push({id:"expense_center_id",no:'<cf_get_lang_main no="782.girilmesi zorunlu alan">: <cf_get_lang_main no="1048.Masraf merkezi">'});
	</script>
</cfif>
<cfif get_process_type.PROCESS_TYPE eq 1043>
	<script>
		div_hidden=["item-credit_contract","item-voucher","item-payment_type","item-ch_company","item-expense_center2","item-expense_item","item-cash","item-employee","item-subscriber","item-credit_card","item-other_action",];
		div_imperative.push({id:"cheque_id",no:'<cf_get_lang_main no="782.girilmesi zorunlu alan">: <cf_get_lang_main no="595.Çek">'});
	</script>
</cfif>
<cfif get_process_type.PROCESS_TYPE eq 1044>
	<script>
		div_hidden=["item-credit_contract","item-voucher","item-payment_type","item-ch_company","item-expense_center2","item-expense_item","item-cash","item-employee","item-subscriber","item-credit_card","item-other_action"];
		div_imperative.push({id:"cheque_id",no:'<cf_get_lang_main no="782.girilmesi zorunlu alan">: <cf_get_lang_main no="595.Çek">'});
	</script>
</cfif>
<cfif get_process_type.PROCESS_TYPE eq 1051>
	<script>
		div_hidden=["item-credit_contract","item-cheque","item-payment_type","item-ch_company","item-expense_center2","item-expense_item","item-cash","item-employee","item-subscriber","item-credit_card","item-other_action"];
		div_imperative.push({id:"voucher_id",no:'<cf_get_lang_main no="782.girilmesi zorunlu alan">: <cf_get_lang_main no="596.Senet">'});
	</script>
</cfif>
<cfif get_process_type.PROCESS_TYPE eq 1053>
	<script>
		div_hidden=["item-credit_contract","item-cheque","item-payment_type","item-ch_company","item-expense_center2","item-expense_item","item-cash","item-employee","item-subscriber","item-credit_card","item-other_action"];
		div_imperative.push({id:"voucher_id",no:'<cf_get_lang_main no="782.girilmesi zorunlu alan">: <cf_get_lang_main no="596.Senet">'});
	</script>
</cfif>
<cfif get_process_type.PROCESS_TYPE eq 2501>
	<script>
	</script>
</cfif>
<script>
	for(i=0;i<div_hidden.length;i++)
		{
			document.getElementById(''+div_hidden[i]+'').hidden=true;
		}
	
</script>
<script type="text/javascript">
	function controlAddBankAction()
		{
			for(i=0;i<div_imperative.length;i++)
				{
					if($('#'+div_imperative[i]['id']+'').val() === '')
						{
							alert(div_imperative[i]['no']);
							var imperative=div_imperative[i]['id'];
							for(m=0;m<imperative.length;m++)
							{
								if(imperative[m]==' ')
								{
									imperative = imperative.substring(0,m);
									break;
								}
							}
							$('#'+imperative+'').focus();
							return false;
						}
				}
			return true;
		}

	function showDepartment(branch_id)
		{
			var branch_id = document.getElementById('branch_id').value;
			if (branch_id != "")
			{
				var send_address = "<cfoutput>#request.self#</cfoutput>?fuseaction=hr.popup_ajax_list_hr&branch_id="+branch_id;
				AjaxPageLoad(send_address,'department_place',1,'İlişkili Departmanlar');
			}
		}
	
	$(document).keydown(function(e){
		// ESCAPE key pressed
		if (e.keyCode == 27) {
			window.close();
		}
	});
</script>