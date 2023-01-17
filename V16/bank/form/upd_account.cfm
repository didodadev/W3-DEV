<cf_get_lang_set module_name="bank">
<cf_xml_page_edit fuseact='bank.form_add_bank_account'>
<cfparam name="attributes.active_period" default="#session.ep.period_id#">
<cfinclude template="../query/get_money_rate.cfm">
<cfinclude template="../query/get_acc_detail.cfm">
<cfquery name="GET_PERIODS" datasource="#DSN#">
	SELECT PERIOD_YEAR FROM SETUP_PERIOD WHERE OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#">
</cfquery>
<cfquery name="CONTROL" datasource="#DSN2#" maxrows="1">
	<cfloop query="get_periods">
		<cfset new_dsn_2 = "#dsn#_#period_year#_#session.ep.company_id#">
		SELECT ACTION_ID FROM #new_dsn_2#.BANK_ACTIONS WHERE ACTION_FROM_ACCOUNT_ID =<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.id#">  OR ACTION_TO_ACCOUNT_ID =<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.id#"> 
		<cfif currentrow neq get_periods.recordcount>UNION ALL</cfif>
	</cfloop>
</cfquery>
<!--- Banka Talimatlari icin eklendi. --->
<cfquery name="CONTROL2" datasource="#DSN2#" maxrows="1">
	<cfloop query="get_periods">
		<cfset new_dsn_2 = "#dsn#_#period_year#_#session.ep.company_id#">
		SELECT ACCOUNT_ID FROM #new_dsn_2#.BANK_ORDERS WHERE ACCOUNT_ID =<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.id#">
		<cfif currentrow neq get_periods.recordcount>UNION ALL</cfif>
	</cfloop>
</cfquery>
<!--- kredi kartı tahsilatları için(gerçi hesaba geçiş işlemi yapılmış bir kayıtsa üst query e girer ama henuz hesaba geçiş yapılmamış kayıtsa hesap silinmemeli) AE20060622--->
<cfquery name="CONTROL3" datasource="#DSN3#" maxrows="1">
	SELECT ACTION_TO_ACCOUNT_ID FROM CREDIT_CARD_BANK_PAYMENTS WHERE ACTION_TO_ACCOUNT_ID =<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.id#"> 
</cfquery>
<cfif not get_acc_detail.recordcount>
	<br/><font class="txtbold"><cf_get_lang_main no='1531.Böyle Bir Kayıt Bulunmamaktadır'> !</font>
<cfexit method="exittemplate">
</cfif>
<cfquery name="GET_BANK_NAMES" datasource="#DSN#">
	SELECT BANK_ID, BANK_CODE, BANK_NAME FROM SETUP_BANK_TYPES ORDER BY BANK_NAME
</cfquery>
<cfquery name="GET_BRANCH_NAMES" datasource="#DSN3#">
	SELECT BANK_ID, BANK_BRANCH_ID, BANK_BRANCH_NAME, BRANCH_CODE FROM BANK_BRANCH WHERE BANK_ID IN (SELECT BANK_ID FROM BANK_BRANCH WHERE BANK_BRANCH_ID =<cfqueryparam cfsqltype="cf_sql_integer" value="#get_acc_detail.account_branch_id#">) ORDER BY BANK_BRANCH_NAME
</cfquery>
<cfquery name="GET_ACC_BRANCHS" datasource="#DSN3#">
	SELECT BRANCH_ID FROM ACCOUNTS_BRANCH WHERE ACCOUNT_ID =<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.id#">
</cfquery>
<cfsavecontent variable="right">
	<cfoutput>
		<a href="#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.form_add_bank_account"><img src="/images/plus1.gif" align="absmiddle" title="<cf_get_lang_main no='170.Ekle'>" border="0"></a>
	</cfoutput>
</cfsavecontent>
<cf_catalystHeader>
<div class="col col-12 col-xs-12">
    <cf_box>
        <cfform name="upd_account" method="post" action="#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.upd_bank_account&id=#attributes.id#">
           <cf_box_elements>
                <div class="col col-4 col-md-6 col-sm-6 col-xs-12" type="column" index="1" sort="true">
                    <input type="hidden" name="active_period" id="active_period" value="<cfoutput>#session.ep.period_id#</cfoutput>" style="width:177px;">
                    <div class="form-group" id="item-status">
                            <div class="col col-4">
                                <label><input type="checkbox" name="status" id="status" <cfif get_acc_detail.account_status eq 1>checked</cfif>>&nbsp;<cf_get_lang_main no ='81.Aktif'></label>
                            </div>
                            <div class="col col-4">
                                <label><input type="checkbox" name="is_partner" id="is_partner" <cfif get_acc_detail.is_partner eq 1>checked</cfif>>&nbsp;<cf_get_lang_main no='1473.Partner'></label>
                            </div>
                            <div class="col col-4">
                                <label><input type="checkbox" name="is_public" id="is_public" <cfif get_acc_detail.is_public eq 1>checked</cfif>>&nbsp;<cf_get_lang no='9.Public'></label>
                            </div>
                    </div>
                    <div class="form-group" id="item-status">
                        <div class="col col-4">
                            <label><input type="checkbox" name="is_civil" id="is_civil" value="<cfoutput>#get_acc_detail.is_civil#</cfoutput>" <cfif get_acc_detail.is_civil eq 1>checked</cfif>>&nbsp;<cf_get_lang Dictionary_id='41536.Kamu'></label>
                        </div>
                        <div class="col col-6">
                            <label><input type="checkbox" name="is_internet" id="is_internet"  <cfif get_acc_detail.is_internet eq 1>checked</cfif>>&nbsp;<cf_get_lang no ='258.Internetde Görünsün'></label>
                        </div>
                    </div>
                    <div class="form-group" id="item-DepartmentBranch">
                        <label class="col col-4 col-xs-12"><cf_get_lang_main no='41.Şube'> *</label>
                        <div class="col col-8 col-xs-12">
                            <cf_wrkDepartmentBranch selected_value='#valuelist(get_acc_branchs.branch_id)#' is_branch='1' fieldId='branch_id' is_multiple='#is_multiple_branch#' width='175' height='80'>
                        </div>
                    </div>
                    <div class="form-group" id="item-IbanCode">
                        <label class="col col-4 col-xs-12"><cf_get_lang_main no='1595.IBAN Kodu'> <cfif xml_iban_required eq 1>*</cfif></label>
                        <div class="col col-8 col-xs-12">
                            <!---<cfsavecontent variable="message"><cf_get_lang no='120.IBAN Kodu Girmelisiniz'> !</cfsavecontent>
                            <cfinput type="text" name="account_owner_customer_no" id="account_owner_customer_no"  required="yes" message="#message#" value="#get_acc_detail.account_owner_customer_no#" style="width:175px;" maxlength="50">--->
                            <cf_wrkIbanCode fieldId='account_owner_customer_no' iban_code="#get_acc_detail.account_owner_customer_no#" iban_maxlength="#xml_iban_maxlength#" iban_required="#xml_iban_required#" width_info='175' numpad="true" accessible="true" keypad="true">
                        </div>
                    </div>
                    <div class="form-group" id="item-account_name">
                        <label class="col col-4 col-xs-12"><cf_get_lang no='16.Hesap Adı'> *</label>
                        <div class="col col-8 col-xs-12">
                            <cfinput type="text" name="account_name"  id="account_name" value="#get_acc_detail.account_name#" required="yes" style="width:175px;" maxlength="50">
                        </div>
                    </div>
                    <div class="form-group" id="item-account_bank_id">
                        <label class="col col-4 col-xs-12"><cf_get_lang no='34.Banka Adı'> *</label>
                        <div class="col col-8 col-xs-12">
                            <select name="account_bank_id" id="account_bank_id" style="width:175px;" onChange="set_bank_branch(this.value);">
                                <option value=""><cf_get_lang_main no ='322.Seçiniz'></option>
                                <cfoutput query="get_bank_names">
                                    <option value="#bank_id#;#bank_code#" <cfif bank_id eq get_branch_names.bank_id>selected</cfif>>#bank_name#</option>
                                </cfoutput>
                            </select>
                        </div>
                    </div>
                    <div class="form-group" id="item-account_branch_id">
                        <label class="col col-4 col-xs-12"><cf_get_lang_main no='1521.Banka Şubesi'>*</label>
                        <div class="col col-8 col-xs-12">
                            <select name="account_branch_id" id="account_branch_id" style="width:175px;" onChange="set_branch_code(this.value);">
                                <option value=""><cf_get_lang_main no ='322.Seçiniz'></option>
                                <cfoutput query="get_branch_names">
                                    <option value="#bank_branch_id#;#branch_code#" <cfif bank_branch_id eq get_acc_detail.account_branch_id>selected</cfif>>#bank_branch_name#</option>
                                </cfoutput>
                            </select>
                        </div>
                    </div>
                    <div class="form-group" id="item-bank_code">
                        <label class="col col-4 col-xs-12"><cf_get_lang no='25.Banka/Şube'> <cf_get_lang no='427.Kodu'></label>
                        <div class="col col-8 col-xs-12">
                            <div class="input-group">
                                <cfinput type="text" name="bank_code" value="#get_acc_detail.bank_code#" style="width:86px;" readonly>
                                <span class="input-group-addon no-bg"></span>
                                <cfinput type="text" name="branch_code" value="#get_acc_detail.branch_code#" style="width:86px;" readonly>
                            </div>
                        </div>
                    </div>
                    <div class="form-group" id="item-account_no">
                        <label class="col col-4 col-xs-12"><cf_get_lang_main no='766.Hesap No'> *</label>
                        <div class="col col-8 col-xs-12">
                            <cfinput type="text" name="account_no" id="account_no" required="yes" value="#get_acc_detail.account_no#" style="width:175px;" maxlength="50">
                        </div>
                    </div>
                    <div class="form-group" id="item-account_type">
                        <label class="col col-4 col-xs-12"><cf_get_lang no='26.Hesap Türü'> *</label>
                        <div class="col col-8 col-xs-12">
                            <select name="account_type" id="account_type" style="width:175px;">
                                <cfoutput>
                                    <option value="1" <cfif get_acc_detail.account_type is 1>selected</cfif>><cf_get_lang_main no='1650.Kredili'></option>
                                    <option value="2" <cfif get_acc_detail.account_type is 2>selected</cfif>><cf_get_lang_main no='1649.Ticari'></option>
                                    <option value="3" <cfif get_acc_detail.account_type is 3>selected</cfif>><cf_get_lang dictionary_id='57798.Vadeli'></option>
                                </cfoutput>
                            </select>
                        </div>
                    </div>
                    <cfif control.recordcount eq 0>
                    <div class="form-group" id="item-account_currency_id">
                        <label class="col col-4 col-xs-12"><cf_get_lang no='84.Döviz Kodu'></label>
                        <div class="col col-8 col-xs-12">
                            <select name="account_currency_id" id="account_currency_id" style="width:175px;">
                                <cfoutput query="get_money_rate">
                                    <option value="#money#" <cfif money eq get_acc_detail.account_currency_id >selected</cfif> >#money#</option>
                                </cfoutput>
                            </select>
                        </div>
                    </div>
                    </cfif>
                    <div class="form-group" id="item-account_credit_limit">
                        <label class="col col-4 col-xs-12"><cf_get_lang_main no='1551.Kredi Limiti'></label>
                        <div class="col col-8 col-xs-12">
                            <cfinput type="text" name="account_credit_limit" id="account_credit_limit" value="#TLFormat(get_acc_detail.account_credit_limit)#" onkeyup="return(FormatCurrency(this,event));"  style="width:175px;">
                        </div>
                    </div>
                    <div class="form-group" id="item-account_detail">
                        <label class="col col-4 col-xs-12"><cf_get_lang_main no='217.Açıklama'></label>
                        <div class="col col-8 col-xs-12">
                            <textarea name="account_detail" id="account_detail" style="width:175px; height:40px;" maxlength="250" onkeyup="return ismaxlength(this)" onBlur="return ismaxlength(this);"><cfoutput>#get_acc_detail.account_detail#</cfoutput></textarea>
                        </div>
                    </div>
                </div>
                <div class="col col-4 col-md-6 col-sm-6 col-xs-12" type="column" index="2" sort="true">
                    <div class="form-group" id="item-account_id">
                        <label class="col col-4 col-xs-12"><cf_get_lang_main no='1399.Muhasebe Kodu'> *</label>
                        <div class="col col-8 col-xs-12">
                            <div class="input-group">
                                <cfquery name="GET_ACC_1" datasource="#DSN2#">
                                    SELECT ACCOUNT_NAME FROM ACCOUNT_PLAN WHERE ACCOUNT_CODE =<cfqueryparam cfsqltype="cf_sql_varchar" value="#get_acc_detail.account_acc_code#">
                                </cfquery>
                                <cf_wrk_account_codes form_name='upd_account' search_from_name='1' account_code="account_id" account_name='account_code_name'>
                                <input type="hidden" name="account_id" id="account_id" value="<cfoutput>#get_acc_detail.account_acc_code#</cfoutput>" style="width:177px;">
                                <cfinput type="text" name="account_code_name" id="account_code_name" value="#get_acc_detail.account_acc_code# - #get_acc_1.account_name#" style="width:177px;" onFocus="AutoComplete_Create('account_code_name','ACCOUNT_CODE','ACCOUNT_CODE,ACCOUNT_NAME','get_account_code','','ACCOUNT_CODE,CODE_NAME','account_id,account_code_name','','3','250');" autocomplete="off"/>
                                <span class="input-group-addon icon-ellipsis btnPointer" title="<cf_get_lang_main no='1399.Muhasebe Kodu'>" onClick="windowopen('<cfoutput>#request.self#?fuseaction=objects.popup_account_plan&field_name=upd_account.account_code_name&field_id=upd_account.account_id</cfoutput>','list')"></span>
                            </div>
                        </div>
                    </div>
                    <div class="form-group" id="item-bank_order_name">
                        <label class="col col-4 col-xs-12"><cf_get_lang no='182.Banka Talimatı Muhasebe Kodu'>*</label>
                        <div class="col col-8 col-xs-12">
                            <div class="input-group">
                                <cfquery name="GET_ACC_2" datasource="#DSN2#">
                                    SELECT ACCOUNT_NAME FROM ACCOUNT_PLAN WHERE ACCOUNT_CODE =<cfqueryparam cfsqltype="cf_sql_varchar" value="#get_acc_detail.account_order_code#">
                                </cfquery>
                                <cf_wrk_account_codes form_name='upd_account' search_from_name='1' account_code="bank_order" account_name='bank_order_name' is_multi_no='2'>
                                <input type="hidden" name="bank_order" id="bank_order" value="<cfoutput>#get_acc_detail.account_order_code#</cfoutput>" style="width:177px;">
                                <cfinput type="text" name="bank_order_name" id="bank_order_name" value="#get_acc_detail.account_order_code# - #get_acc_2.account_name#" style="width:177px;" onfocus="AutoComplete_Create('bank_order_name','ACCOUNT_CODE','ACCOUNT_CODE,ACCOUNT_NAME','get_account_code','','ACCOUNT_CODE,CODE_NAME','bank_order,bank_order_name','','3','250');" autocomplete="off" />
                                <span class="input-group-addon icon-ellipsis btnPointer" title="<cf_get_lang no='182.Banka Talimatı Muhasebe Kodu'>" onClick="windowopen('<cfoutput>#request.self#?fuseaction=objects.popup_account_plan&field_name=upd_account.bank_order_name&field_id=upd_account.bank_order</cfoutput>','list')"></span>
                            </div>
                        </div>
                    </div>
                    <div class="form-group" id="item-v_account_name">
                        <label class="col col-4 col-xs-12"><cf_get_lang no='29.Verilen Çek Muhasebe Kodu'>*</label>
                        <div class="col col-8 col-xs-12">
                            <div class="input-group">
                                <cfquery name="GET_ACC_3" datasource="#DSN2#">
                                    SELECT ACCOUNT_NAME FROM ACCOUNT_PLAN WHERE ACCOUNT_CODE =<cfqueryparam cfsqltype="cf_sql_varchar" value="#get_acc_detail.v_cheque_acc_code#">
                                </cfquery>
                                <cf_wrk_account_codes form_name='upd_account' search_from_name='1' account_code="v_account_id" account_name='v_account_name' is_multi_no='3'>
                                <input type="hidden" name="v_account_id" id="v_account_id" value="<cfoutput>#get_acc_detail.v_cheque_acc_code#</cfoutput>" style="width:177px;">
                                <cfinput type="text" name="v_account_name" id="v_account_name" value="#get_acc_detail.v_cheque_acc_code# - #get_acc_3.account_name#" style="width:177px;" onFocus="AutoComplete_Create('v_account_name','ACCOUNT_CODE','ACCOUNT_CODE,ACCOUNT_NAME','get_account_code','','ACCOUNT_CODE,CODE_NAME','v_account_id,v_account_name','','3','250');" autocomplete="off"/>
                                <span class="input-group-addon icon-ellipsis btnPointer" title="<cf_get_lang no='29.Verilen Çek Muhasebe Kodu'>" onClick="windowopen('<cfoutput>#request.self#?fuseaction=objects.popup_account_plan&field_name=upd_account.v_account_name&field_id=upd_account.v_account_id</cfoutput>','list')"></span>
                            </div>
                        </div>
                    </div>
                    <div class="form-group" id="item-exchange_code_name">
                        <label class="col col-4 col-xs-12"><cf_get_lang no ='260.Takas Çeki Muhasebe Kodu'> *</label>
                        <div class="col col-8 col-xs-12">
                            <div class="input-group">
                                <cfquery name="GET_ACC_4" datasource="#DSN2#">
                                    SELECT ACCOUNT_NAME FROM ACCOUNT_PLAN WHERE ACCOUNT_CODE =<cfqueryparam cfsqltype="cf_sql_varchar" value="#get_acc_detail.cheque_exchange_code#">
                                </cfquery>
                                <cf_wrk_account_codes form_name='upd_account' search_from_name='1' account_code="exchange_code_id" account_name='exchange_code_name' is_multi_no='4'>
                                <input type="hidden" name="exchange_code_id" id="exchange_code_id" value="<cfoutput>#get_acc_detail.cheque_exchange_code#</cfoutput>" style="width:177px;">
                                <cfinput type="text" name="exchange_code_name" id="exchange_code_name" value="#get_acc_detail.cheque_exchange_code# - #get_acc_4.account_name#" style="width:177px;" onFocus="AutoComplete_Create('exchange_code_name','ACCOUNT_CODE','ACCOUNT_CODE,ACCOUNT_NAME','get_account_code','','ACCOUNT_CODE,CODE_NAME','exchange_code_id,exchange_code_name','','3','250');" autocomplete="off"/>
                                <span class="input-group-addon icon-ellipsis btnPointer" title="<cf_get_lang no ='260.Takas Çeki Muhasebe Kodu'>" onClick="windowopen('<cfoutput>#request.self#?fuseaction=objects.popup_account_plan&field_name=upd_account.exchange_code_name&field_id=upd_account.exchange_code_id</cfoutput>','list')"></span>
                            </div>
                        </div>
                    </div>
                    <div class="form-group" id="item-v_exchange_code_name">
                        <label class="col col-4 col-xs-12"><cf_get_lang no ='261.Takas Senedi Muhasebe Kodu'> *</label>
                        <div class="col col-8 col-xs-12">
                            <div class="input-group">
                                <cfif len(get_acc_detail.voucher_exchange_code)>
                                    <cfquery name="GET_ACC_5" datasource="#DSN2#">
                                        SELECT ACCOUNT_NAME FROM ACCOUNT_PLAN WHERE ACCOUNT_CODE =<cfqueryparam cfsqltype="cf_sql_varchar" value="#get_acc_detail.voucher_exchange_code#">
                                    </cfquery>
                                </cfif>
                                <cf_wrk_account_codes form_name='upd_account' search_from_name='1' account_code="v_exchange_code_id" account_name='v_exchange_code_name' is_multi_no='5'>
                                <input type="hidden" name="v_exchange_code_id" id="v_exchange_code_id" value="<cfoutput>#get_acc_detail.voucher_exchange_code#</cfoutput>" style="width:177px;">
                                <input type="text" name="v_exchange_code_name" id="v_exchange_code_name" value="<cfoutput>#get_acc_detail.voucher_exchange_code# <cfif len(get_acc_detail.voucher_exchange_code)>- #get_acc_5.account_name#</cfif></cfoutput>" style="width:177px;"  onFocus="AutoComplete_Create('v_exchange_code_name','ACCOUNT_CODE','ACCOUNT_CODE,ACCOUNT_NAME','get_account_code','','ACCOUNT_CODE,CODE_NAME','v_exchange_code_id,v_exchange_code_name','','3','250');" autocomplete="off"/>
                                <span class="input-group-addon icon-ellipsis btnPointer" title="<cf_get_lang no ='261.Takas Senedi Muhasebe Kodu'>" onClick="windowopen('<cfoutput>#request.self#?fuseaction=objects.popup_account_plan&field_name=upd_account.v_exchange_code_name&field_id=upd_account.v_exchange_code_id</cfoutput>','list')"></span>
                            </div>
                        </div>
                    </div>
                    <div class="form-group" id="item-guaranty_code_name">
                        <label class="col col-4 col-xs-12"><cf_get_lang no ='423.Teminat Çeki Muhasebe Kodu'></label>
                        <div class="col col-8 col-xs-12">
                            <div class="input-group">
                                <cf_wrk_account_codes form_name='upd_account' search_from_name='1' account_code="guaranty_code_id" account_name='guaranty_code_name' is_multi_no='6'>
                                <cfif len(get_acc_detail.cheque_guaranty_code)>
                                    <cfquery name="GET_ACC_6" datasource="#DSN2#">
                                        SELECT ACCOUNT_NAME FROM ACCOUNT_PLAN WHERE ACCOUNT_CODE = <cfqueryparam cfsqltype="cf_sql_varchar" value="#get_acc_detail.cheque_guaranty_code#">
                                    </cfquery>
                                </cfif>
                                <input type="hidden" name="guaranty_code_id" id="guaranty_code_id" value="<cfoutput>#get_acc_detail.cheque_guaranty_code#</cfoutput>" style="width:177px;">
                                <input type="text" name="guaranty_code_name" id="guaranty_code_name" style="width:177px;" value="<cfoutput>#get_acc_detail.cheque_guaranty_code#<cfif len(get_acc_detail.cheque_guaranty_code)>- #GET_ACC_6.ACCOUNT_NAME#</cfif></cfoutput>" message="#message#" onFocus="AutoComplete_Create('guaranty_code_name','ACCOUNT_CODE','ACCOUNT_CODE,ACCOUNT_NAME','get_account_code','','ACCOUNT_CODE,CODE_NAME','guaranty_code_id,guaranty_code_name','','3','250');" autocomplete="off"/>
                                <span class="input-group-addon icon-ellipsis btnPointer" title="<cf_get_lang no ='423.Teminat Çeki Muhasebe Kodu'>" onClick="windowopen('<cfoutput>#request.self#?fuseaction=objects.popup_account_plan&field_name=upd_account.guaranty_code_name&field_id=upd_account.guaranty_code_id</cfoutput>&account_code='+document.upd_account.guaranty_code_id.value,'list')"></span>
                            </div>
                        </div>
                    </div>
                    <div class="form-group" id="item-v_guaranty_code_name">
                        <label class="col col-4 col-xs-12"><cf_get_lang no ='424.Teminat Senedi Muhasebe Kodu'></label>
                        <div class="col col-8 col-xs-12">
                            <div class="input-group">
                                <cf_wrk_account_codes form_name='upd_account' search_from_name='1' account_code="v_guaranty_code_id" account_name='v_guaranty_code_name' is_multi_no='7'>
                                <cfif len(get_acc_detail.voucher_guaranty_code)>
                                    <cfquery name="GET_ACC_7" datasource="#DSN2#">
                                        SELECT ACCOUNT_NAME FROM ACCOUNT_PLAN WHERE ACCOUNT_CODE =<cfqueryparam cfsqltype="cf_sql_varchar" value="#get_acc_detail.voucher_guaranty_code#">
                                    </cfquery>
                                </cfif>
                                <input type="hidden" name="v_guaranty_code_id" id="v_guaranty_code_id" value="<cfoutput>#get_acc_detail.voucher_guaranty_code#</cfoutput>" style="width:177px;">
                                <input type="text" name="v_guaranty_code_name" id="v_guaranty_code_name" style="width:177px;" value="<cfoutput>#get_acc_detail.voucher_guaranty_code#<cfif len(get_acc_detail.voucher_guaranty_code)>- #GET_ACC_7.ACCOUNT_NAME#</cfif></cfoutput>" message="#message#" onFocus="AutoComplete_Create('v_guaranty_code_name','ACCOUNT_CODE','ACCOUNT_CODE,ACCOUNT_NAME','get_account_code','','ACCOUNT_CODE,CODE_NAME','v_guaranty_code_id,v_guaranty_code_name','','3','250');" autocomplete="off"/>
                                <span class="input-group-addon icon-ellipsis btnPointer" title="" onClick="windowopen('<cfoutput>#request.self#?fuseaction=objects.popup_account_plan&field_name=upd_account.v_guaranty_code_name&field_id=upd_account.v_guaranty_code_id</cfoutput>&account_code='+document.upd_account.v_guaranty_code_id.value,'list')"></span>
                            </div>
                        </div>
                    </div>
                    <div class="form-group" id="item-">
                        <label class="col col-4 col-xs-12"><cf_get_lang no="154.Karşılıksız Çekler"> *</label>
                        <div class="col col-8 col-xs-12">
                            <div class="input-group">
                                <cf_wrk_account_codes form_name='upd_account' search_from_name='1' account_code="karsiliksiz_cekler_id" account_name='karsiliksiz_cekler_name' is_multi_no='8'>
                                <cfif len(get_acc_detail.karsiliksiz_cekler_code)>
                                    <cfquery name="GET_ACC_8" datasource="#DSN2#">
                                        SELECT ACCOUNT_NAME FROM ACCOUNT_PLAN WHERE ACCOUNT_CODE =<cfqueryparam cfsqltype="cf_sql_varchar" value="#get_acc_detail.karsiliksiz_cekler_code#">
                                    </cfquery>
                                </cfif>
                                <input type="hidden" name="karsiliksiz_cekler_id" id="karsiliksiz_cekler_id" value="<cfoutput>#get_acc_detail.karsiliksiz_cekler_code#</cfoutput>" style="width:177px;">
                                <input type="text" name="karsiliksiz_cekler_name" id="karsiliksiz_cekler_name" style="width:177px;" value="<cfoutput>#get_acc_detail.karsiliksiz_cekler_code#<cfif len(get_acc_detail.karsiliksiz_cekler_code)>- #GET_ACC_8.ACCOUNT_NAME#</cfif></cfoutput>" message="#message#" onFocus="AutoComplete_Create('karsiliksiz_cekler_name','ACCOUNT_CODE','ACCOUNT_CODE,ACCOUNT_NAME','get_account_code','','ACCOUNT_CODE,CODE_NAME','karsiliksiz_cekler_id,karsiliksiz_cekler_name','','3','250');" autocomplete="off"/>
                                <span class="input-group-addon icon-ellipsis btnPointer" title="" onClick="windowopen('<cfoutput>#request.self#?fuseaction=objects.popup_account_plan&field_name=upd_account.karsiliksiz_cekler_name&field_id=upd_account.karsiliksiz_cekler_id</cfoutput>&account_code='+document.upd_account.karsiliksiz_cekler_id.value,'list')"></span>
                            </div>
                        </div>
                    </div>
                    <div class="form-group" id="item-protestolu_senetler_name">
                        <label class="col col-4 col-xs-12"><cf_get_lang no="155.Protestolu Senetler"> *</label>
                        <div class="col col-8 col-xs-12">
                            <div class="input-group">
                                <cf_wrk_account_codes form_name='upd_account' search_from_name='1' account_code="protestolu_senetler_id" account_name='protestolu_senetler_name' is_multi_no='9'>
                                <cfif len(get_acc_detail.protestolu_senetler_code)>
                                    <cfquery name="GET_ACC_9" datasource="#DSN2#">
                                        SELECT ACCOUNT_NAME FROM ACCOUNT_PLAN WHERE ACCOUNT_CODE =<cfqueryparam cfsqltype="cf_sql_varchar" value="#get_acc_detail.protestolu_senetler_code#">
                                    </cfquery>
                                </cfif>
                                <input type="hidden" name="protestolu_senetler_id" id="protestolu_senetler_id" value="<cfoutput>#get_acc_detail.protestolu_senetler_code#</cfoutput>" style="width:177px;">
                                <input type="text" name="protestolu_senetler_name" id="protestolu_senetler_name" style="width:177px;" value="<cfoutput>#get_acc_detail.protestolu_senetler_code#<cfif len(get_acc_detail.protestolu_senetler_code)>- #GET_ACC_9.ACCOUNT_NAME#</cfif></cfoutput>" message="#message#" onFocus="AutoComplete_Create('protestolu_senetler_name','ACCOUNT_CODE','ACCOUNT_CODE,ACCOUNT_NAME','get_account_code','','ACCOUNT_CODE,CODE_NAME','protestolu_senetler_id,protestolu_senetler_name','','3','250');" autocomplete="off"/>
                                <span class="input-group-addon icon-ellipsis btnPointer" title="<cf_get_lang no ='424.Teminat Senedi Muhasebe Kodu'>" onClick="windowopen('<cfoutput>#request.self#?fuseaction=objects.popup_account_plan&field_name=upd_account.protestolu_senetler_name&field_id=upd_account.protestolu_senetler_id</cfoutput>&account_code='+document.upd_account.protestolu_senetler_id.value,'list')"></span>
                            </div>
                        </div>
                    </div>
                </div>
            </cf_box_elements>
            <cf_box_footer>
                    <div class="col col-6 col-xs-12">
                        <cf_record_info query_name="get_acc_detail">                  
                    </div>
                    <div class="col col-6 col-xs-12">
                        <cfif control.recordcount or control2.recordcount or control3.recordcount>
                            <cf_workcube_buttons is_upd='1' is_delete='0' add_function='kontrol()'>
                        <cfelse>
                            <cfif session.ep.isBranchAuthorization eq 0>
                                <cf_workcube_buttons type_format="1" is_upd='1' delete_page_url='#request.self#?fuseaction=bank.del_bank_account&id=#url.id#&active_period=#attributes.active_period#' add_function='kontrol()'>
                            <cfelse>
                                <cf_workcube_buttons is_upd='1' type_format="1" is_delete='0' add_function='kontrol()'>
                            </cfif>
                        </cfif>
                    </div>
            </cf_box_footer>               
        </cfform>
    </cf_box>
</div>
<cfquery name="get_account" datasource="#DSN3#">
        SELECT 
          ACCOUNT_NAME,
          IS_CIVIL
        FROM
            ACCOUNTS
        WHERE 
            IS_CIVIL = 1
</cfquery> 
<script type="text/javascript">
	function unformat_fields()
	{
		fld=upd_account.account_credit_limit;
		fld.value=filterNum(fld.value);
	}
	function kontrol()
	{
        var is_civil_ =  document.upd_account.is_civil.value; 
        if(is_civil_ == 0)
        {
            if(document.upd_account.is_civil.checked == true)
                {
                    alert('<cfoutput>#get_account.account_name#</cfoutput> <cf_get_lang Dictionary_id='41526.Hesabı Kamu Olarak Tanımlanmış'> .<cf_get_lang Dictionary_id='41524.Seçenek Değiştirilecektir'> ,<cf_get_lang Dictionary_id='37871.Değişiklikleri kaydetmek istediğinizden emin misiniz?'> ');  
                
                } 
        }  
		if (document.upd_account.branch_id.value == "")
        { 
            alert ("<cf_get_lang_main no ='2329.Şube Seçiniz'>!");
            document.getElementById('branch_id').focus();
            return false;
        }
        if (document.upd_account.account_bank_id.value == "")
        { 
            alert ("<cf_get_lang no ='88.Banka Seçiniz'>");
            document.getElementById('account_bank_id').focus();
            return false;
        }
        if (document.upd_account.account_branch_id.value == "")
        { 
            alert ("<cf_get_lang no ='262.Banka Şubesi Seçiniz'>!");
            document.getElementById('account_branch_id').focus();
            return false;
        }
        if (document.upd_account.account_type.value == "")
        { 
            alert ("<cf_get_lang no='184.Hesap Türü Seçiniz'> !");
            document.getElementById('account_type').focus();
            return false;
        }
        if (document.upd_account.account_currency_id.value == "")
        { 
            alert ("Döviz cinsi seçiniz");
            document.getElementById('account_currency_id').focus();
            return false;
        }
        if (document.upd_account.account_code_name.value == "")
        { 
            alert ("<cf_get_lang no='186.Muhasebe Kodu Seçiniz'> !");
            document.getElementById('account_code_name').focus();
            return false;
        }
        if (document.upd_account.bank_order_name.value == "")
        { 
            alert ("<cf_get_lang no='182.Banka Talimatı Muhasebe Kodu'> !");
            document.getElementById('bank_order_name').focus();
            return false;
        }
        if (document.upd_account.v_account_name.value == "")
        { 
            alert ("<cf_get_lang no='187.Verilen Çek Muhasebe Kodu Seçiniz'> !");
            document.getElementById('v_account_name').focus();
            return false;
        }
        if (document.upd_account.exchange_code_name.value == "")
        { 
            alert ("<cf_get_lang no ='264.Takas Senet Muhasebe Kodunu Seçiniz'>!");
            document.getElementById('exchange_code_name').focus();
            return false;
        }
        if (document.upd_account.v_exchange_code_name.value == "")
        { 
            alert ("<cf_get_lang no ='264.Takas Senet Muhasebe Kodunu Seçiniz'>!");
            document.getElementById('v_exchange_code_name').focus();
            return false;
        }
        if (document.upd_account.karsiliksiz_cekler_name.value == "")
        { 
            alert ("Karşılıksız Çekler <cf_get_lang no='186.Muhasebe Kodu Seçiniz'> !");
            document.getElementById('karsiliksiz_cekler_name').focus();
            return false;
        }
        if (document.upd_account.protestolu_senetler_name.value == "")
        { 
            alert ("Protestolu Senetler <cf_get_lang no='186.Muhasebe Kodu Seçiniz'> !");
            document.getElementById('protestolu_senetler_name').focus();
            return false;
        }
		return unformat_fields();
		return true;
	}
	function pencere_ac(isim)
	{
		temp_account_code = eval('cheques.'+isim);
		if (temp_account_code.value.length != 0)
			windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_account_plan&field_id=cheques.'+isim+'&account_code=' + temp_account_code.value, 'list');
		else
			windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_account_plan&field_id=cheques.'+isim, 'list');
	}
	function set_bank_branch(xyz)
	{
		document.upd_account.branch_code.value = "";
		if(xyz.split(';')[1]!= undefined)
			document.upd_account.bank_code.value = xyz.split(';')[1];
		else
			document.upd_account.bank_code.value = "";
		
		var bank_id_ = xyz.split(';')[0];
		var bank_branch_names = wrk_safe_query('bnk_branch_names','dsn3',0,bank_id_);
		
		var option_count = document.getElementById('account_branch_id').options.length; 
		for(x=option_count;x>=0;x--)
			document.getElementById('account_branch_id').options[x] = null;
		
		if(bank_branch_names.recordcount != 0)
		{	
			document.getElementById('account_branch_id').options[0] = new Option('Seçiniz','');
			for(var xx=0;xx<bank_branch_names.recordcount;xx++)
				document.getElementById('account_branch_id').options[xx+1]=new Option(bank_branch_names.BANK_BRANCH_NAME[xx],bank_branch_names.BANK_BRANCH_ID[xx]+';'+bank_branch_names.BRANCH_CODE[xx]);
		}
		else
			document.getElementById('account_branch_id').options[0] = new Option('Seçiniz','');
	}
	function set_branch_code(abc)
	{
		if(abc.split(';')[1]!= undefined)
			document.upd_account.branch_code.value = abc.split(';')[1];
		else
			document.upd_account.branch_code.value = "";
	}
</script>
<cf_get_lang_set module_name="#lcase(listgetat(attributes.fuseaction,1,'.'))#">
