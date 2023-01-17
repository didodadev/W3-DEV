<!---
    File: setup_add_rule_set.cfm
    Author: Gramoni-Mahmut <mahmut.cifci@gramoni.com>
    Date: 29.07.2018
    Controller: WodibaSetupRuleSetsController.cfm
    Description:
		Kural seti ekleme ve güncelleme sayfası
--->

<cfset module_name = 'settings' />
<cfparam name="attributes.act_id" default="" />
<cfparam name="attributes.status" default="" />
<cfparam name="attributes.rule_name" default="" />
<cfparam name="attributes.account_id" default="0" />
<cfparam name="attributes.transaction_code" default="" />
<cfparam name="attributes.action_target" default="" />
<cfparam name="attributes.iban" default="" />
<cfparam name="attributes.vkn" default="" />
<cfparam name="attributes.process_type" default="" />
<cfparam name="attributes.expense_center_id" default="0" />
<cfparam name="attributes.expense_item_id" default="0" />
<cfparam name="attributes.other_expense_item_id" default="-1" />
<cfparam name="attributes.other_expense_item_rate" default="-1" />
<cfparam name="attributes.project_id" default="0" />
<cfparam name="attributes.ch_member_type" default="" />
<cfparam name="attributes.ch_company_id" default="" />
<cfparam name="attributes.ch_consumer_id" default="" />
<cfparam name="attributes.ch_employee_id" default="" />
<cfparam name="attributes.ch_company" default="" />
<cfparam name="attributes.acc_type_id" default="" />
<cfparam name="attributes.special_definition_id" default="0" />
<cfparam name="attributes.card_paymethod_id" default="0" />
<cfparam name="attributes.paymethod_id" default="0" />
<cfparam name="attributes.paymethod" default="" />
<cfparam name="attributes.asset_id" default="0" />
<cfparam name="attributes.branch_id" default="0" />
<cfparam name="attributes.department" default="0" />
<cfparam name="attributes.is_sales_zone" default="0" />
<cfparam name="attributes.sales_zone" default="" />
<cfparam name="attributes.is_branch_from_sales_zone" default="0" />
<cfparam name="attributes.tax" default="0" />
<cfparam name="attributes.tax_include" default="0" />

<cfsavecontent variable="head_text">
<title><cf_get_lang dictionary_id='44024.WoDiBa Banka Kural Seti Tanımları'></title>
</cfsavecontent>
<cfhtmlhead text="#head_text#" />

<cfscript>
    include "../cfc/Functions.cfc";
    wdb_hesaplar    = GetBankAccountsWithCompany(CompanyId=session.ep.company_id);

    if(isDefined('attributes.form_submitted')){
        if(Not Len(attributes.status)){
            attributes.status = 0;
        }
        if(Not Len(attributes.expense_center_id)){
            attributes.expense_center_id = 0;
        }
        if(Not Len(attributes.expense_item_id)){
            attributes.expense_item_id = 0;
        }
        if(Not Len(attributes.project)){
            attributes.project_id = 0;
        }
        if(Not Len(attributes.ch_company_id)){
            attributes.ch_company_id = 0;
        }
        if(Not Len(attributes.ch_consumer_id)){
            attributes.ch_consumer_id = 0;
        }
        if(Not Len(attributes.ch_employee_id)){
            attributes.ch_employee_id = 0;
        }
        if(attributes.ch_member_type Eq 'employee'){
            attributes.ch_employee_id = listFirst(attributes.ch_employee_id,'_');
        }
        if(Not Len(attributes.acc_type_id)){
            attributes.acc_type_id = 0;
        }
        if(Not Len(attributes.paymethod)){
            attributes.paymethod_id = 0;
        }
        if(Not Len(attributes.special_definition_id)){
            attributes.special_definition_id = 0;
        }
        if(Not Len(attributes.asset_id)){
            attributes.asset_id = 0;
        }
        if(Not Len(attributes.department)){
            attributes.department = 0;
		}
		if(Not Len(attributes.is_sales_zone)){
            attributes.is_sales_zone = 0;
		}
		if(Not Len(attributes.is_branch_from_sales_zone)){
            attributes.is_branch_from_sales_zone = 0;
        }
        if(attributes.event is 'row' And isDefined('attributes.row_id')){
            UpdateRuleSetRow(
                RowId: attributes.row_id,
                RuleId: attributes.id,
                Status: attributes.status,
                RuleName: attributes.rule_name,
                AccountId: attributes.account_id,
                TransactionCode: attributes.transaction_code,
                Target: attributes.action_target,
                IBAN: attributes.iban,
                VKN: attributes.vkn,
                Description: attributes.description,
                RegEx: attributes.reg_ex,
                RegExInput: attributes.reg_ex_input,
                RegExOutput: attributes.reg_ex_output,
                ProcessType: attributes.process_type,
                ProcessCat: attributes.process_cat_id,
                ExpenseCenter: attributes.expense_center_id,
                ExpenseItem: attributes.expense_item_id,
                Project: attributes.project_id,
                ChCompanyId: attributes.ch_company_id,
                ChConsumerId: attributes.ch_consumer_id,
                ChEmployeeId: attributes.ch_employee_id,
                AccTypeId: attributes.acc_type_id,
                PaymentType: attributes.paymethod_id,
                SpecialDefinition: attributes.special_definition_id,
                Asset: attributes.asset_id,
                Branch: attributes.branch_id,
				Department: attributes.department,
				IsSalesZone: attributes.is_sales_zone,
				SalesZone: attributes.sales_zone,
				IsBranchFromSalesZone: attributes.is_branch_from_sales_zone,
				Tax: attributes.tax,
				TaxInclude: attributes.tax_include
            );
            if (attributes.other_expense_item_id Gt 0) {
                AddRuleSetRowParam(attributes.row_id,'other_expense_item_id',attributes.other_expense_item_id);
            }
			if (attributes.other_expense_item_rate Gt 0) {
				AddRuleSetRowParam(attributes.row_id,'other_expense_item_rate',attributes.other_expense_item_rate);
			}
        }
        else if(attributes.event is 'del' And isDefined('attributes.row_id') And Len(attributes.row_id)){
            DelRuleSetRow(RuleId=attributes.id, RowId=attributes.row_id);
			DelRuleSetRowParam(attributes.row_id,'other_expense_item_id');
			DelRuleSetRowParam(attributes.row_id,'other_expense_item_rate');
        }
        else if(attributes.event is 'add' And Not isDefined('attributes.row_id')){
            add_row_id = AddRuleSetRow(
                RuleId: attributes.id,
                Status: attributes.status,
                RuleName: attributes.rule_name,
                AccountId: attributes.account_id,
                TransactionCode: attributes.transaction_code,
                Target: attributes.action_target,
                IBAN: attributes.iban,
                VKN: attributes.vkn,
				Description: attributes.description,
				RegEx: attributes.reg_ex,
                RegExInput: attributes.reg_ex_input,
                RegExOutput: attributes.reg_ex_output,
                ProcessType: attributes.process_type, 
                ProcessCat: attributes.process_cat_id,
                ExpenseCenter: attributes.expense_center_id,
                ExpenseItem: attributes.expense_item_id,
                Project: attributes.project_id,
                ChCompanyId: attributes.ch_company_id,
                ChConsumerId: attributes.ch_consumer_id,
                ChEmployeeId: attributes.ch_employee_id,
                AccTypeId: attributes.acc_type_id,
                PaymentType: attributes.paymethod_id,
                SpecialDefinition: attributes.special_definition_id,
                Asset: attributes.asset_id,
                Branch: attributes.branch_id,
				Department: attributes.department,
				IsSalesZone: attributes.is_sales_zone,
				SalesZone: attributes.sales_zone,
				IsBranchFromSalesZone: attributes.is_branch_from_sales_zone,
				Tax: attributes.tax,
				TaxInclude: attributes.tax_include
            );
			if (attributes.other_expense_item_id Gt 0) {
                AddRuleSetRowParam(add_row_id,'other_expense_item_id',attributes.other_expense_item_id);
            }
			if (attributes.other_expense_item_rate Gt 0) {
				AddRuleSetRowParam(add_row_id,'other_expense_item_rate',attributes.other_expense_item_rate);
			}
        }
        location("#request.self#?fuseaction=settings.wodiba_bank_rule_set_definitions&event=upd&id=#attributes.id#","false");
    }
</cfscript>

<cfif isDefined('attributes.form_submitted')>
    <script type="text/javascript">
        window.opener.location.reload();
        window.close();
    </script>
    <cfexit method="exittemplate" />
</cfif>

<cfif attributes.event is 'row' And isDefined('attributes.row_id')>
    <cfquery name="get_row_details" datasource="#dsn#">
        SELECT * FROM WODIBA_RULE_SET_ROWS WHERE RULE_SET_ROW_ID = #attributes.row_id#
    </cfquery>
    <cfif Not get_row_details.recordCount>
        <cfexit method="exittemplate" />
    </cfif>
</cfif>

<cfquery name="GET_ACCOUNTS" datasource="#dsn3#">
	SELECT
		A.ACCOUNT_ID,
        A.ACCOUNT_CURRENCY_ID,
		A.ACCOUNT_NAME
	FROM
		ACCOUNTS A
    WHERE
        A.ACCOUNT_ID IN(#valueList(wdb_hesaplar.ACCOUNT_ID)#)
	ORDER BY
		A.ACCOUNT_NAME
</cfquery>
<cfif isDefined('attributes.act_id') AND len('#attributes.act_id#') neq 0 >
    <cfquery name="GET_ACTION" datasource="#dsn#">
        Select * from WODIBA_BANK_ACTIONS where WDB_ACTION_ID = <cfqueryparam cfsqltype="CF_SQL_INTEGER" value="#attributes.act_id#">
    </cfquery>
    
</cfif>
<cfif not len('#attributes.id#') >
    <script type="text/javascript">
        alert('İşlem kodu için tanımlama bulunamadı!\nSistem yöneticisi ile iletişime geçiniz!');
        window.close();
    </script>
    <cfexit method="exittemplate" />
</cfif>
<cfquery name="GET_RULE_SET" datasource="#dsn#">
    Select * from WODIBA_RULE_SETS where RULE_ID = #attributes.id#
</cfquery>

<cfset attributes.process_type  = GET_RULE_SET.PROCESS_TYPE />

<cfquery name="GET_PROCESS_CAT" datasource="#dsn3#">
    Select PROCESS_CAT, PROCESS_CAT_ID from SETUP_PROCESS_CAT where PROCESS_TYPE = #GET_RULE_SET.PROCESS_TYPE# ORDER BY PROCESS_CAT
</cfquery>

<cfquery name="GET_EXPENSE_CENTER" datasource="#dsn2#">
	SELECT EXPENSE_ID, EXPENSE, EXPENSE_CODE FROM EXPENSE_CENTER ORDER BY EXPENSE_CODE, EXPENSE
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

<cfquery name="get_acc_types" datasource="#dsn#">
	SELECT ACC_TYPE_ID, ACC_TYPE_NAME FROM SETUP_ACC_TYPE ORDER BY ACC_TYPE_NAME
</cfquery>

<cfif listFind('120,121',GET_RULE_SET.process_type)>
    <cfset tax_object = createObject("component","V16.settings.cfc.tax") />
    <cfset get_tax = tax_object.Select() />
</cfif>

<cfoutput>
<div class="col col-12">
    <cf_box scroll="1" draggable="1" collapsable="1" resize="1" title="#getLang('main','',44024,'WoDiBa Banka Kural Seti Tanımları')#" popup_box="#iif(isdefined("attributes.draggable"),1,0)#">
    <form name="setup_rule_set" id="setup_rule_set" method="post">
        <input type="hidden" name="form_submitted" value="1" />
        <input type="hidden" name="process_type" value="#attributes.process_type#" />
        <cf_box_elements>
        <div class="row">
            <div class="col col-12 uniqueRow">
                <div class="row formContent">
                    <div class="row col-8" type="row">
                        <div class="form-group" id="item-status">
                            <label class="col col-4 col-xs-12" for="status"><cf_get_lang_main dictionary_id='57756.Durum'></label>
                            <div class="col col-8 col-xs-12">
                                <input type="checkbox" name="status" id="status" value="1"<cfif attributes.event is 'row' And isDefined('attributes.row_id') And Len(get_row_details.STATUS) And get_row_details.STATUS Eq 1> checked</cfif> />
                            </div>
                        </div>
                        <div class="form-group" id="item-rule_name">
                            <label class="col col-4 col-xs-12" for="rule_name"><cf_get_lang_main dictionary_id='51290.Kural tanımı'></label>
                            <div class="col col-8 col-xs-12">
                                <input type="text" name="rule_name" id="rule_name" style="width:65px" value="<cfif attributes.event is 'row' And isDefined('attributes.row_id')>#get_row_details.RULE_SET_ROW_NAME#</cfif>">
                            </div>
                        </div>
                    </div>
                    <!--- Girdiler --->
                    <cfsavecontent variable="group_input_txt"><cf_get_lang dictionary_id='36472.Girdiler'></cfsavecontent>
                    <cf_seperator id="group_input" title="#group_input_txt#">
                    <div id="group_input">
                        <div class="row col-8" type="row">
                            <!--- Banka Hesabı --->
                            <div class="form-group" id="item-account_id">
                                <label class="col col-4 col-xs-12" for="account_id"><cf_get_lang_main no='1652.Banka Hesabı'></label>
                                <div class="col col-8 col-xs-12">
                                    <select name="account_id" id="account_id" onchange="getTransactionTypes(this.options[this.selectedIndex].value);" style="width:100px;">
                                        <option value="0"><cf_get_lang_main no='322.Seçiniz'></option>
                                        <cfloop query="get_accounts">
                                            <option value="#account_id#"<cfif attributes.event is 'row' And isDefined('attributes.row_id') And get_row_details.ACCOUNT_ID eq get_accounts.account_id> selected <cfelseif isDefined('attributes.act_id' ) AND len('#attributes.act_id#') neq 0 AND #account_id# eq #GET_ACTION.ACCOUNT_ID#> selected</cfif>>#account_name#-#account_currency_id#</option>
                                        </cfloop>
                                    </select>
                                </div>
                            </div>
                            <!--- İşlem Kodu --->
                            <div class="form-group" id="item-transaction_code">
                                <label class="col col-4 col-xs-12" for="transaction_code"><cf_get_lang dictionary_id='48886.İşlem Kodu'></label>
                                <div class="col col-8 col-xs-12">
                                    <select name="transaction_code" id="transaction_code" style="width:100px;">
                                        <option value="0"><cf_get_lang_main no='322.Seçiniz'></option>
                                        <cfif attributes.event is 'row' And isDefined('attributes.row_id')>
                                        <cfquery name="get_transaction_codes" datasource="#dsn#">
                                            SELECT * FROM(
                                            SELECT
                                                WBTT.TRANSACTION_CODE AS TRANSACTION_CODE
                                            FROM
                                                WODIBA_BANK_TRANSACTION_TYPES AS WBTT
                                                INNER JOIN SETUP_BANK_TYPES AS SBT ON SBT.BANK_CODE = WBTT.BANK_CODE
                                                INNER JOIN #dsn3#.BANK_BRANCH AS BB ON BB.BANK_ID = SBT.BANK_ID
                                                INNER JOIN #dsn3#.ACCOUNTS A ON A.ACCOUNT_BRANCH_ID = BB.BANK_BRANCH_ID
                                            WHERE
                                                A.ACCOUNT_ID = #get_row_details.ACCOUNT_ID#
                                            UNION ALL
                                            SELECT
                                                WBTT.TRANSACTION_CODE2 AS TRANSACTION_CODE
                                            FROM
                                                WODIBA_BANK_TRANSACTION_TYPES AS WBTT
                                                INNER JOIN SETUP_BANK_TYPES AS SBT ON SBT.BANK_CODE = WBTT.BANK_CODE
                                                INNER JOIN #dsn3#.BANK_BRANCH AS BB ON BB.BANK_ID = SBT.BANK_ID
                                                INNER JOIN #dsn3#.ACCOUNTS A ON A.ACCOUNT_BRANCH_ID = BB.BANK_BRANCH_ID
                                            WHERE
                                                A.ACCOUNT_ID = #get_row_details.ACCOUNT_ID#) SQL1
                                            GROUP BY
                                                TRANSACTION_CODE
                                            ORDER BY
                                                TRANSACTION_CODE
                                        </cfquery>
                                        <cfloop query="get_transaction_codes">
                                        <option value="#TRANSACTION_CODE#"<cfif get_row_details.TRANSACTION_CODE Eq TRANSACTION_CODE> selected</cfif>>#TRANSACTION_CODE#</option>
                                        </cfloop>
                                        <cfelseif isDefined('attributes.act_id')>
                                        <cfelse>
                                        <option value="0"><cf_get_lang_main no='322.Seçiniz'></option>
                                        </cfif>
                                    </select>
                                </div>
                            </div>
                            <!--- İşlem Yönü --->
                            <div class="form-group" id="item-action_target">
                                <label class="col col-4 col-xs-12" for="action_target"><cf_get_lang dictionary_id='62593.İşlem Yönü'></label>
                                <div class="col col-8 col-xs-12">
                                    <select name="action_target" id="action_target" style="width:100px;">
                                        <option value=""><cf_get_lang_main no='322.Seçiniz'></option>
                                        <option value="IN"<cfif attributes.event is 'row' And isDefined('attributes.row_id') And get_row_details.IN_OUT Eq 'IN'> selected<cfelseif isDefined('attributes.act_id') AND len('#attributes.act_id#') neq 0 AND #GET_ACTION.MIKTAR# GT 0 > selected</cfif>><cf_get_lang_main no='142.Giriş'></option>
                                        <option value="OUT"<cfif attributes.event is 'row' And isDefined('attributes.row_id') And get_row_details.IN_OUT Eq 'OUT'> selected<cfelseif isDefined('attributes.act_id') AND len('#attributes.act_id#') neq 0 AND #GET_ACTION.MIKTAR# LT 0 > selected</cfif>><cf_get_lang_main no='19.Çıkış'></option>
                                    </select>
                                </div>
                            </div>
                            <!--- IBAN --->
                            <div class="form-group" id="item-iban">
                                <label class="col col-4 col-xs-12" for="iban">IBAN</label>
                                <div class="col col-8 col-xs-12">
                                    <input type="text" name="iban" id="iban" value="<cfif attributes.event is 'row' And isDefined('attributes.row_id')>#get_row_details.IBAN#<cfelseif isDefined('attributes.act_id')AND len('#attributes.act_id#')>#GET_ACTION.KARSIIBAN#</cfif>" />
                                </div>
                            </div>
                            <!--- VKN --->
                            <div class="form-group" id="item-vkn">
                                <label class="col col-4 col-xs-12" for="vkn">VKN</label>
                                <div class="col col-8 col-xs-12">
                                    <input type="text" name="vkn" id="vkn" value="<cfif attributes.event is 'row' And isDefined('attributes.row_id')>#get_row_details.VKN#<cfelseif isDefined('attributes.act_id')AND len('#attributes.act_id#')>#GET_ACTION.KARSIVKN#</cfif>" />
                                </div>
                            </div>
                            <!--- Açıklama --->
                            <div class="form-group" id="item-description">
                                <label class="col col-4 col-xs-12" for="description"><cf_get_lang_main no='217.Açıklama'></label>
                                <div class="col col-8 col-xs-12">
                                    <input type="text" name="description" id="description" value="<cfif attributes.event is 'row' And isDefined('attributes.row_id')>#get_row_details.DESCRIPTION#<cfelseif isDefined('attributes.act_id')AND len('#attributes.act_id#')>#GET_ACTION.ACIKLAMA#</cfif>" />
                                </div>
                            </div>
                            <!--- Düzenli İfade --->
                            <div class="form-group" id="item-reg_ex">
                                <label class="col col-4 col-xs-12" for="reg_ex">Düzenli İfade</label>
                                <div class="col col-8 col-xs-12">
                                    <input type="text" name="reg_ex" id="reg_ex" value="<cfif attributes.event is 'row' And isDefined('attributes.row_id')>#get_row_details.REG_EX#</cfif>" />
                                </div>
                            </div>
                            <!--- Aranan Değer --->
                            <div class="form-group" id="item-reg_ex_input">
                                <label class="col col-4 col-xs-12" for="reg_ex_input">Aranan Değer</label>
                                <div class="col col-8 col-xs-12">
                                    <select name="reg_ex_input" id="reg_ex_input" style="width:100px;">
                                        <option value=""><cf_get_lang_main no='322.Seçiniz'></option>
                                        <option value="EMPLOYEE_NAME_SURNAME"<cfif attributes.event is 'row' And isDefined('attributes.row_id') And get_row_details.REG_EX_INPUT Eq 'EMPLOYEE_NAME_SURNAME'> selected</cfif>>Çalışan Ad Soyad</option>
                                        <option value="CHEQUE_NO"<cfif attributes.event is 'row' And isDefined('attributes.row_id') And get_row_details.REG_EX_INPUT Eq 'CHEQUE_NO'> selected</cfif>>Çek No</option>
                                        <option value="IBAN"<cfif attributes.event is 'row' And isDefined('attributes.row_id') And get_row_details.REG_EX_INPUT Eq 'IBAN'> selected</cfif>>IBAN</option>
                                        <option value="CREDIT_NO"<cfif attributes.event is 'row' And isDefined('attributes.row_id') And get_row_details.REG_EX_INPUT Eq 'CREDIT_NO'> selected</cfif>>Kredi No</option>
                                        <option value="COMPANY_NAME"<cfif attributes.event is 'row' And isDefined('attributes.row_id') And get_row_details.REG_EX_INPUT Eq 'COMPANY_NAME'> selected</cfif>>Kurumsal Üye Adı</option>
                                        <option value="COMPANY_OZEL_KOD"<cfif attributes.event is 'row' And isDefined('attributes.row_id') And get_row_details.REG_EX_INPUT Eq 'COMPANY_OZEL_KOD'> selected</cfif>>Kurumsal Üye Özel Kod</option>
                                        <option value="ASSETP"<cfif attributes.event is 'row' And isDefined('attributes.row_id') And get_row_details.REG_EX_INPUT Eq 'ASSETP'> selected</cfif>>Fiziki Varlık Adı - Plaka No</option>
                                        <option value="VOUCHER_DUE_DATE"<cfif attributes.event is 'row' And isDefined('attributes.row_id') And get_row_details.REG_EX_INPUT Eq 'VOUCHER_DUE_DATE'> selected</cfif>>Senet Vade Tarihi</option>
                                    </select>
                                </div>
                            </div>
                            <!--- Bulunan Değer --->
                            <div class="form-group" id="item-reg_ex_output">
                                <label class="col col-4 col-xs-12" for="reg_ex_output">Bulunan Değer</label>
                                <div class="col col-8 col-xs-12">
                                    <select name="reg_ex_output" id="reg_ex_output" style="width:100px;">
                                        <option value=""><cf_get_lang_main no='322.Seçiniz'></option>
                                        <option value="EMPLOYEE"<cfif attributes.event is 'row' And isDefined('attributes.row_id') And get_row_details.REG_EX_OUTPUT Eq 'EMPLOYEE'> selected</cfif>>Çalışan</option>
                                        <option value="CHEQUE"<cfif attributes.event is 'row' And isDefined('attributes.row_id') And get_row_details.REG_EX_OUTPUT Eq 'CHEQUE'> selected</cfif>>Çek</option>
                                        <option value="IBAN"<cfif attributes.event is 'row' And isDefined('attributes.row_id') And get_row_details.REG_EX_OUTPUT Eq 'IBAN'> selected</cfif>>IBAN</option>
                                        <option value="CREDIT_CONTRACT"<cfif attributes.event is 'row' And isDefined('attributes.row_id') And get_row_details.REG_EX_OUTPUT Eq 'CREDIT_CONTRACT'> selected</cfif>>Kredi Sözleşmesi</option>
                                        <option value="COMPANY"<cfif attributes.event is 'row' And isDefined('attributes.row_id') And get_row_details.REG_EX_OUTPUT Eq 'COMPANY'> selected</cfif>>Kurumsal Üye</option>
                                        <option value="ASSETP_ID"<cfif attributes.event is 'row' And isDefined('attributes.row_id') And get_row_details.REG_EX_OUTPUT Eq 'ASSETP_ID'> selected</cfif>>Fiziki Varlık</option>
                                        <option value="VOUCHER"<cfif attributes.event is 'row' And isDefined('attributes.row_id') And get_row_details.REG_EX_OUTPUT Eq 'VOUCHER'> selected</cfif>>Senet</option>
                                    </select>
                                </div>
                            </div>
                        </div>
                    </div>
                    <!--- /Girdiler --->
                    <!--- Koşullar --->
                    <cfsavecontent variable="group_condition_txt"><cf_get_lang dictionary_id='32084.Koşullar'></cfsavecontent>
                    <cf_seperator id="group_condition" title="#group_condition_txt#">
                    <div id="group_condition">
                        <div class="row col-8" type="row">
                            <!--- Satış Bölgesi --->
                            <div class="form-group" id="item-is_sales_zone">
                                <label class="col col-4 col-xs-12" for="is_sales_zone"><cf_get_lang dictionary_id='57659.Satış bölgesi'></label>
                                <div class="col col-8 col-xs-12">
                                    <input type="checkbox" name="is_sales_zone" id="is_sales_zone" value="1"<cfif attributes.event is 'row' And isDefined('attributes.row_id') And Len(get_row_details.COND_IS_SALES_ZONE) And get_row_details.COND_IS_SALES_ZONE Eq 1> checked</cfif> />
                                </div>
                            </div>
                            <!--- Satış Bölgeleri --->
                            <div class="form-group" id="item-sales_zone">
                                <label class="col col-4 col-xs-12" for="sales_zone"><cf_get_lang dictionary_id='57659.Satış bölgesi'></label>
                                <div class="col col-8 col-xs-12">
                                    <cfsavecontent variable="message"><cf_get_lang dictionary_id="57659.Satış bölgesi"></cfsavecontent>
                                    <cfif attributes.event is 'row'>
                                        <cf_multiselect_check
                                            name="sales_zone"
                                            option_name="SZ_NAME"
                                            option_value="SZ_ID"
                                            table_name="SALES_ZONES"
                                            value="#valuelist(get_row_details.COND_SALES_ZONE)#"
                                            sort_type="SZ_NAME">
                                    <cfelse>
                                        <cf_multiselect_check 
                                            name="sales_zone"
                                            option_name="SZ_NAME"
                                            option_value="SZ_ID"
                                            table_name="SALES_ZONES"
                                            option_text="#message#">
                                    </cfif>
                                </div>
                            </div>
                            <!--- Şube tanımı satış bölgesinden gelsin --->
                            <div class="form-group" id="item-is_branch_from_sales_zone">
                                <label class="col col-4 col-xs-12" for="is_branch_from_sales_zone">Şube Tanımı Satış Bölgesinden Gelsin</label>
                                <div class="col col-8 col-xs-12">
                                    <input type="checkbox" name="is_branch_from_sales_zone" id="is_branch_from_sales_zone" value="1"<cfif attributes.event is 'row' And isDefined('attributes.row_id') And Len(get_row_details.COND_IS_BRANCH_FROM_SALES_ZONE) And get_row_details.COND_IS_BRANCH_FROM_SALES_ZONE Eq 1> checked</cfif> />
                                </div>
                            </div>
                        </div>
                    </div>
                    <!--- //Koşullar --->
                    <!--- Çıktılar --->
                    <cfsavecontent variable="group_output_txt"><cf_get_lang dictionary_id='36476.Çıktılar'></cfsavecontent>
                    <cf_seperator id="group_output" title="#group_output_txt#">
                    <div id="group_output">
                        <div class="row col-8" type="row">
                            <!--- İşlem Tipi --->
                            <div class="form-group" id="item-process_cat_id">
                                <label class="col col-4 col-xs-12" for="process_cat_id"><cf_get_lang_main no='388.İşlem Tipi'></label>
                                <div class="col col-8 col-xs-12">
                                    <select name="process_cat_id" id="process_cat_id" style="width:100px;">
                                        <option value=""><cf_get_lang_main no='322.Seçiniz'></option>
                                        <cfloop query="GET_PROCESS_CAT">
                                            <option value="#PROCESS_CAT_ID#"<cfif attributes.event is 'row' And isDefined('attributes.row_id') And get_row_details.PROCESS_CAT_ID Eq PROCESS_CAT_ID> selected</cfif>>#PROCESS_CAT# (#PROCESS_CAT_ID#)</option>
                                        </cfloop>
                                    </select>
                                </div>
                            </div>
                            <!--- Masraf merkezi --->
                            <div class="form-group" id="item-expense_center">
                                <label class="col col-4 col-xs-12" for="expense_center_id"><cf_get_lang_main no='1048.Masraf merkezi'></label>
                                <div class="col col-8 col-xs-12">
                                    <select name="expense_center_id" id="expense_center_id">
                                        <option value="0"><cf_get_lang_main no='322.Seçiniz'></option>
                                        <cfloop query="get_expense_center">
                                            <option value="#EXPENSE_ID#"<cfif attributes.event is 'row' And isDefined('attributes.row_id') And get_row_details.expense_center_id eq EXPENSE_ID> selected</cfif>>#EXPENSE_CODE# #expense#</option>
                                        </cfloop>
                                    </select>
                                </div>
                            </div>
                            <!--- Bütçe kalemi --->
                            <div class="form-group" id="item-expense_item">
                                <label class="col col-4 col-xs-12" for="expense_item_id"><cf_get_lang_main no='822.Bütçe kalemi'></label>
                                <div class="col col-8 col-xs-12">
                                    <select name="expense_item_id" id="expense_item_id">
                                        <option value="0"><cf_get_lang dictionary_id='57734.Seçiniz'></option>
                                        <cfloop query="get_expense_items">
                                            <option value="#EXPENSE_ITEM_ID#"<cfif attributes.event is 'row' And isDefined('attributes.row_id') And get_row_details.expense_item_id eq EXPENSE_ITEM_ID> selected</cfif>>#ACCOUNT_CODE# #EXPENSE_ITEM_NAME#</option>
                                        </cfloop>
                                    </select>
                                </div>
                            </div>
                            <!--- Diğer Bütçe Kalemi --->
                            <cfif listFind('120,121',GET_RULE_SET.process_type)>
                            <cfscript>
                                if(attributes.event is 'row' And isDefined('attributes.row_id')){
                                    get_other_expense = GetRuleSetRowParam(attributes.row_id,'other_expense_item_id');
                                    get_other_expense_rate = GetRuleSetRowParam(attributes.row_id,'other_expense_item_rate');
                                }
                            </cfscript>
                            <div class="form-group" id="item-other_expense_item">
                                <label class="col col-4 col-xs-12" for="other_expense_item_id"><cf_get_lang dictionary_id='58234.Bütçe Kalemi'></label>
                                <div class="col col-8 col-xs-12">
                                    <div class="form-group col col-8" style="padding-left: 0px !important;">
                                        <select name="other_expense_item_id" id="other_expense_item_id">
                                            <option value="0"><cf_get_lang dictionary_id='57734.Seçiniz'></option>
                                            <cfloop query="get_expense_items">
                                                <option value="#EXPENSE_ITEM_ID#"<cfif attributes.event is 'row' And isDefined('attributes.row_id') And isDefined('get_other_expense') And get_other_expense.param_value eq EXPENSE_ITEM_ID> selected</cfif>>#ACCOUNT_CODE# #EXPENSE_ITEM_NAME#</option>
                                            </cfloop>
                                        </select>
                                    </div>
                                    <div class="form-group col col-4">
                                        <div class="input-group">
                                            <input type="text" name="other_expense_item_rate" id="other_expense_item_rate" value="<cfif isDefined('get_other_expense_rate')>#get_other_expense_rate.param_value#</cfif>" />
                                            <div class="input-group_tooltip">Oran girilmelidir<br />Girilen değere göre bütçe kalemleri arasında tutarsal dağıtım yapılacaktır.</div>
                                            <span class="input-group-addon icon-question input-group-tooltip"></span>
                                        </div>
                                    </div>
                                </div>
                            </div>
                            </cfif>
                            <!--- Proje --->
                            <div class="form-group" id="item-project">
                                <label class="col col-4 col-xs-12" for="project"><cf_get_lang_main no='4.Proje'></label>
                                <div class="col col-8 col-xs-12">
                                    <div class="input-group">
                                        <cfif attributes.event is 'row' And isDefined('attributes.row_id') And Len(get_row_details.PROJECT_ID)>
                                            <cfquery name="get_project_name" datasource="#dsn#">
                                                SELECT PROJECT_HEAD FROM PRO_PROJECTS WHERE PROJECT_ID = #get_row_details.PROJECT_ID#
                                            </cfquery>
                                            <cfset project_name = get_project_name.PROJECT_HEAD />
                                        <cfelse>
                                            <cfset project_name = '' />
                                        </cfif>
                                        <input type="hidden" name="project_id" id="project_id" value="<cfif attributes.event is 'row' And isDefined('attributes.row_id')>#get_row_details.PROJECT_ID#</cfif>" />
                                        <input type="text" name="project" id="project" style="width:115px;" onFocus="AutoComplete_Create('project','PROJECT_HEAD','PROJECT_HEAD','get_project','','PROJECT_ID','project_id','','3','200');" value="#project_name#" autocomplete="off" />
                                        <span class="input-group-addon btnPointer icon-ellipsis" onclick="openBoxDraggable('#request.self#?fuseaction=objects.popup_list_projects&project_id=setup_rule_set.project_id&project_head=setup_rule_set.project');"></span>
                                    </div>
                                </div>
                            </div>
                            <!--- Cari hesap --->
                            <div class="form-group" id="item-ch_company">
                                <label class="col col-4 col-xs-12" for="ch_company"><cf_get_lang_main no='107.Cari hesap'></label>
                                <div class="col col-8 col-xs-12">
                                    <div class="input-group">
                                        <cfif attributes.event is 'row' And isDefined('attributes.row_id')>
                                            <cfif Len(get_row_details.COMPANY_ID) And get_row_details.COMPANY_ID Neq 0>
                                                <cfquery name="get_company_name" datasource="#dsn#">
                                                    SELECT FULLNAME FROM COMPANY WHERE COMPANY_ID = #get_row_details.COMPANY_ID#
                                                </cfquery>
                                                <cfset attributes.ch_member_type = 'partner' />
                                                <cfset attributes.ch_company = get_company_name.FULLNAME />
                                            <cfelseif Len(get_row_details.CONSUMER_ID) And get_row_details.CONSUMER_ID Neq 0>
                                                <cfquery name="get_company_name" datasource="#dsn#">
                                                    SELECT CONSUMER_NAME + ' ' + CONSUMER_SURNAME AS FULLNAME FROM CONSUMER WHERE CONSUMER_ID = #get_row_details.CONSUMER_ID#
                                                </cfquery>
                                                <cfset attributes.ch_member_type = 'consumer' />
                                                <cfset attributes.ch_company = get_company_name.FULLNAME />
                                            <cfelseif Len(get_row_details.EMPLOYEE_ID) And get_row_details.EMPLOYEE_ID Neq 0>
                                                <cfquery name="get_company_name" datasource="#dsn#">
                                                    SELECT EMPLOYEE_NAME + ' ' + EMPLOYEE_SURNAME AS FULLNAME FROM EMPLOYEES WHERE EMPLOYEE_ID = #get_row_details.EMPLOYEE_ID#
                                                </cfquery>
                                                <cfset attributes.ch_member_type = 'employee' />
                                                <cfset attributes.ch_company = get_company_name.FULLNAME />
                                            </cfif>
                                            <cfset attributes.ch_company_id = get_row_details.COMPANY_ID />
                                            <cfset attributes.ch_consumer_id = get_row_details.CONSUMER_ID />
                                            <cfset attributes.ch_employee_id = get_row_details.EMPLOYEE_ID />
                                        </cfif>
                                        <input type="hidden" name="ch_member_type" id="ch_member_type" value="#attributes.ch_member_type#">
                                        <input type="hidden" name="ch_company_id" id="ch_company_id" value="#attributes.ch_company_id#">
                                        <input type="hidden" name="ch_consumer_id" id="ch_consumer_id" value="#attributes.ch_consumer_id#">
                                        <input type="hidden" name="ch_employee_id"  id="ch_employee_id"value="#attributes.ch_employee_id#">
                                        <input type="text" name="ch_company" id="ch_company" style="width:120px;" value="#attributes.ch_company#" autocomplete="off">
                                        <span class="input-group-addon btnPointer icon-ellipsis" onclick="windowopen('#request.self#?fuseaction=objects.popup_list_pars&field_name=setup_rule_set.ch_company&is_cari_action=1&field_type=setup_rule_set.ch_member_type&field_comp_name=setup_rule_set.ch_company&field_consumer=setup_rule_set.ch_consumer_id&field_emp_id=setup_rule_set.ch_employee_id&field_comp_id=setup_rule_set.ch_company_id&select_list=2,3,1,9','list');" title="#getLang('main',107)#"></span>
                                    </div>
                                </div>
                            </div>
                            <!--- Cari hesap tipi --->
                            <cfif listFind('24,25,120,121',GET_RULE_SET.process_type)>
                            <div class="form-group" id="item-acc_type_id">
                                <label class="col col-4 col-xs-12" for="acc_type_id"><cf_get_lang dictionary_id='40546.Hesap Tipi'></label>
                                <div class="col col-8 col-xs-12">
                                    <select name="acc_type_id" id="acc_type_id" style="width:100px;">
                                        <option value=""><cf_get_lang_main no='322.Seçiniz'></option>
                                        <cfloop query="get_acc_types">
                                            <option value="#ACC_TYPE_ID#"<cfif attributes.event is 'row' And isDefined('attributes.row_id') And get_row_details.ACC_TYPE_ID Eq ACC_TYPE_ID> selected</cfif>>#ACC_TYPE_NAME#</option>
                                        </cfloop>
                                    </select>
                                </div>
                            </div>
                            </cfif>
                            <!--- Ödeme yöntemi --->
                            <div class="form-group" id="item-payment_type">
                                <label class="col col-4 col-xs-12" for="paymethod"><cf_get_lang_main no='1104.Ödeme yöntemi'></label>
                                <div class="col col-8 col-xs-12">
                                    <div class="input-group">
                                        <cfif attributes.event is 'row' And isDefined('attributes.row_id') And Len(get_row_details.PAYMENT_TYPE_ID) And get_row_details.PAYMENT_TYPE_ID Neq 0>
                                            <cfquery name="get_paymethod" datasource="#dsn#">
                                                SELECT PAYMETHOD FROM SETUP_PAYMETHOD WHERE PAYMETHOD_ID = #get_row_details.PAYMENT_TYPE_ID#
                                            </cfquery>
                                            <cfset attributes.paymethod = get_paymethod.PAYMETHOD />
                                        </cfif>
                                        <input type="hidden" name="card_paymethod_id" id="card_paymethod_id" value="<cfif isdefined("attributes.card_paymethod_id") and attributes.card_paymethod_id Neq 0>#attributes.card_paymethod_id#</cfif>">
                                        <input type="hidden" name="paymethod_id" id="paymethod_id" value="<cfif attributes.event is 'row' And isDefined('attributes.row_id')>#get_row_details.PAYMENT_TYPE_ID#</cfif>">
                                        <input type="text" name="paymethod" placeholder="<cf_get_lang_main no='1104.Ödeme Yöntemi'>" id="paymethod" value="<cfif attributes.event is 'row' And isDefined('attributes.row_id')>#attributes.paymethod#</cfif>">
                                        <span class="input-group-addon btnPointer icon-ellipsis"onclick="windowopen('#request.self#?fuseaction=objects.popup_paymethods&field_id=setup_rule_set.paymethod_id&field_name=setup_rule_set.paymethod&field_card_payment_id=setup_rule_set.card_paymethod_id&field_card_payment_name=setup_rule_set.paymethod','list');"></span>
                                    </div>
                                </div>
                            </div>
                            <!--- Tahsilat Ödeme Tipi --->
                            <div class="form-group" id="item-special_definition">
                                <label class="col col-4 col-xs-12" for="special_definition"><cf_get_lang_main no='2774.Tahsilat Ödeme Tipi'></label>
                                <div class="col col-8 col-xs-12">
                                    <cfif attributes.event is 'row' And isDefined('attributes.row_id')>
                                        <cfset attributes.special_definition_id = get_row_details.SPECIAL_DEFINITION_ID />
                                    </cfif>
                                    <cf_wrk_special_definition width_info="183" list_filter_info="1" field_id="special_definition_id" selected_value='#attributes.special_definition_id#'>
                                </div>
                            </div>
                            <!--- Fiziki varlık --->
                            <div class="form-group" id="item-asset">
                                <label class="col col-4 col-xs-12" for="asset_id"><cf_get_lang_main no='1421.Fiziki varlık'></label>
                                <div class="col col-8 col-xs-12">
                                    <cfif attributes.event is 'row' And isDefined('attributes.row_id')>
                                        <cfset attributes.asset_id = get_row_details.ASSET_ID />
                                    </cfif>
                                    <cf_wrkassetp fieldid='asset_id' width="110" fieldname='asset_name' form_name='setup_rule_set' asset_id='#attributes.asset_id#' button_type='plus_thin'>
                                </div>
                            </div>
                            <!--- Şube --->
                            <div class="form-group" id="item-branch">
                                <label class="col col-4 col-xs-12" for="branch"><cf_get_lang_main no='41.Şube'></label>
                                <div class="col col-8 col-xs-12">
                                    <select name="branch_id" id="branch_id" onChange="showDepartment(this.value)">
                                        <option value="0"><cf_get_lang_main no='322.Seçiniz'></option>
                                        <cfloop query="get_branch">
                                            <option value="#branch_id#"<cfif attributes.event is 'row' And isDefined('attributes.row_id') and get_row_details.branch_id eq branch_id> selected</cfif>>#branch_name#</option>
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
                                        <cfif isdefined('attributes.branch_id') and isnumeric(attributes.branch_id)>
                                            <cfloop query="get_department">
                                                <option value="#department_id#"<cfif attributes.event is 'row' And isDefined('attributes.row_id') And get_row_details.department_id eq department_id> selected</cfif>>#department_head#</option>
                                            </cfloop>
                                        </cfif>
                                    </select>
                                </div>
                            </div>
                            <!--- KDV --->
                            <cfif listFind('120,121',GET_RULE_SET.process_type)>
                            <div class="form-group" id="item-tax">
                                <label class="col col-4 col-xs-12" for="tax"><cf_get_lang dictionary_id='57639.KDV'></label>
                                <div class="col col-8 col-xs-12">
                                    <div class="input-group">
                                        <select name="tax" id="tax">
                                            <option value="-1"><cf_get_lang_main no='322.Seçiniz'></option>
                                            <cfloop query="get_tax">
                                                <option value="#TAX#"<cfif attributes.event is 'row' And isDefined('attributes.row_id') and get_row_details.TAX eq TAX> selected</cfif>>#TAX#</option>
                                            </cfloop>
                                        </select>
                                        <span class="input-group-addon">
                                        <label for="tax_include"><cf_get_lang dictionary_id='32924.Dahil'>/ <cf_get_lang dictionary_id='48213.Hariç'></label>
                                        </span>
                                        <span class="input-group-addon">
                                        <input type="checkbox" name="tax_include" id="tax_include" value="1"<cfif attributes.event is 'row' And isDefined('attributes.row_id') And Len(get_row_details.TAX_INCLUDE) And get_row_details.TAX_INCLUDE Eq 1> checked</cfif> />
                                        </span>
                                        <div class="input-group_tooltip">İşlemin KDV dahil ya da hariç olarak hesaplanarak kayıt edilmesini sağlar.<br />Seçili olduğunda KDV tutarı işlem tutarının içerisinden çıkartılarak hesaplanır ve kayıt edilir.<br />Masraf ve Gelir Fişleri için kullanılır.</div>
                                        <span class="input-group-addon icon-question input-group-tooltip"></span>
                                    </div>
                                </div>
                            </div>
                            </cfif>
                        </div>
                    </div>
                    <!--- /Çıktılar --->
                </div>
            </div>
        </div>
        </cf_box_elements>
		<cf_box_footer>
			<cfif attributes.event is 'row' And isDefined('attributes.row_id')>
			<cf_record_info query_name="get_row_details" record_emp="REC_USER" record_date="REC_DATE" update_emp="UPD_USER" update_date="UPD_DATE">
			<input type="button" class="btn red-mint" value="#getLang('main',51)#" onclick="controlDelete();" />
			<input type="button" class="btn green-haze" value="#getLang('main',52)#" onclick="controlAddDefinition();" />
			<cfelse>
			<input type="button" class="btn green-haze" value="#getLang('main',49)#" onclick="controlAddDefinition();" />
			</cfif>
			<!--- <cf_workcube_buttons is_upd='0' add_function="controlAddDefinition()"> --->
		</cf_box_footer>
    </form>
    </cf_box>
</div>
</cfoutput>

<script src="AddOns/Gramoni/WoDiBa/assets/js/select2.min.js"></script>
<script type="text/javascript">
    var select2 = $("#account_id,#transaction_code,#expense_center_id,#expense_item_id,#branch_id,#department,#other_expense_item_id").select2( {
        placeholder: "",
        allowClear: true,
        dropdownParent:$("#setup_rule_set")
    } );
    function controlAddDefinition()
        {
            if(!$("#ch_company").val().length)
            {
                $("#ch_member_type").val('');
                $("#ch_company_id").val('');
                $("#ch_consumer_id").val('');
                $("#ch_employee_id").val('');
            }

            if(!$("#rule_name").val().length)
            {
                alert('<cf_get_lang_main no="782.girilmesi zorunlu alan">: <cf_get_lang_main dictionary_id="51290.Kural tanımı">');
                $("#rule_name").focus();
                return false;
            }
            else if($('#account_id option:selected').val() === '')
            {
                alert('<cf_get_lang_main no="782.girilmesi zorunlu alan">: <cf_get_lang_main no="1652.Banka Hesabı">');
                $("#account_id").focus();
                return false;
            }
            else if($('#transaction_code option:selected').val() === '')
            {
                alert('<cf_get_lang_main no="782.girilmesi zorunlu alan">: <cf_get_lang dictionary_id="48886.İşlem Kodu">');
                $("#transaction_code").focus();
                return false;
			}
            else if($('#action_target option:selected').val() === '')
            {
                alert('<cf_get_lang_main no="782.girilmesi zorunlu alan">: <cf_get_lang dictionary_id="62593.İşlem Yönü">');
                $("#action_target").focus();
                return false;
			}
            else if($('#iban').val() === '' && $('#vkn').val() === '' && $('#description').val() === ''){
                alert('<cf_get_lang dictionary_id="63051.IBAN, VKN ya da Açıklama alanlarından en az biri dolu olmalıdır.">');
                return false;
            }
			else if($("#reg_ex").val().length && ($('#reg_ex_input option:selected').val() === '' || $('#reg_ex_output option:selected').val() === ''))
            {
                alert('Düzenli ifade girildiğinde Aranan Değer ve Bulunan Değer seçilmelidir');
                $("#reg_ex_input").focus();
                return false;
			}
			else if(($('#reg_ex_input option:selected').val().length || $('#reg_ex_output option:selected').val().length) && !$("#reg_ex").val().length)
            {
                alert('Düzenli ifade, Aranan Değer ve Bulunan Değer birlikte seçilmelidir');
                $("#reg_ex").focus();
                return false;
            }
            else if($('#process_cat_id option:selected').val() === '')
            {
                alert('<cf_get_lang_main no="782.girilmesi zorunlu alan">: <cf_get_lang_main no="388.İşlem Tipi">');
                $("#process_cat_id").focus();
                return false;
            }
			else if($('#other_expense_item_rate').val() > 100)
            {
                alert('Bütçe Kalemi dağıtım oranı %100\'den fazal olamaz!');
                $("#other_expense_item_rate").focus();
                return false;
            }
            else{
                $('#setup_rule_set').attr('action',"<cfoutput>#request.self#?fuseaction=settings.wodiba_bank_rule_set_definitions&event=#attributes.event#&id=#attributes.id#<cfif attributes.event is 'row' And isDefined('attributes.row_id')>&row_id=#attributes.row_id#</cfif></cfoutput>");
                $('#setup_rule_set').submit();
                return true;
            }
        }

    function controlDelete(){
        var r = confirm('<cf_get_lang_main no="121.Silmek İstediğinizden Emin Misiniz?">');
            if(r == true){
                $('#setup_rule_set').attr('action',"<cfoutput>#request.self#?fuseaction=settings.wodiba_bank_rule_set_definitions&event=del&id=#attributes.id#<cfif attributes.event is 'row' And isDefined('attributes.row_id')>&row_id=#attributes.row_id#</cfif></cfoutput>");
                $('#setup_rule_set').submit();
                return true;
            }
            else{
                return false;
            }
    }

    $(document).keydown(function(e){
        // ESCAPE key pressed
        if (e.keyCode == 27) {
            window.close();
        }
    });

    getTransactionTypes=function(accountId){
        var dropdown = $('#transaction_code');
		$.ajax({ url :'AddOns/Gramoni/WoDiBa/cfc/Functions.cfc?method=GetTransactionTypesByAccountId&AccountId=' + accountId, async:false,success : function(res){
            data = res.replace('//""','');
            data = $.parseJSON( data );
                dropdown.empty();//clear list
                $.each(data, function (key, entry) {
                    dropdown.append($('<option></option>').attr('value', "0").text("Seçiniz"));
                    dropdown.append($('<option></option>').attr('value', entry.TRANSACTIONCODE).text(entry.TRANSACTIONCODE));
                })
			}
		});
    }
    <cfif isDefined('attributes.act_id') AND len('#attributes.act_id#') neq 0>
        document.getElementById("transaction_code").onload = getTransactionTypes(document.getElementById("account_id").value);
        document.getElementById('transaction_code').value = <cfoutput>"#GET_ACTION.ISLEMKODU#"</cfoutput>;
    </cfif>
    function showDepartment(branch_id)
	{
		var branch_id = document.getElementById('branch_id').value;
		if (branch_id != "")
		{
			var send_address = "<cfoutput>#request.self#</cfoutput>?fuseaction=hr.popup_ajax_list_hr&branch_id="+branch_id;
			AjaxPageLoad(send_address,'department_place',1,'İlişkili Departmanlar');
		}
	}
</script>