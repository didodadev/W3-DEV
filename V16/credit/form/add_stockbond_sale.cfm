<cf_papers paper_type = "SECURITIES_SALE">
<cfquery name="GET_MONEY" datasource="#dsn#">
	SELECT * FROM SETUP_MONEY WHERE PERIOD_ID = #SESSION.EP.PERIOD_ID# AND MONEY_STATUS = 1
</cfquery>
<cfquery name="GET_STOCKBOND_TYPES" datasource="#dsn#">
	SELECT * FROM SETUP_STOCKBOND_TYPE
</cfquery>
<cfquery name="GET_EXPENSE_ITEM" datasource="#dsn2#">
	SELECT EXPENSE_ITEM_ID, EXPENSE_ITEM_NAME FROM EXPENSE_ITEMS WHERE IS_EXPENSE = 1 ORDER BY EXPENSE_ITEM_NAME
</cfquery>
<cfquery name="GET_EXPENSE_CENTER" datasource="#dsn2#">
	SELECT EXPENSE_ID, EXPENSE_CODE, EXPENSE FROM EXPENSE_CENTER WHERE EXPENSE_ACTIVE = 1 ORDER BY EXPENSE
</cfquery>
<cfparam name="attributes.company_id" default="">
<cfparam name="attributes.comp_name" default="">
<cfparam name="attributes.partner_name" default="">
<cf_catalystHeader>
<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
    <cf_box>
        <cfform name="add_bond" method="post" action="#request.self#?fuseaction=credit.emptypopup_add_stockbond_sale">
            <cf_box_elements>
                <div class="col col-3 col-md-4 col-sm-6 col-xs-12" type="column" index="1" sort="true">
                    <div class="form-group" id="item-islem">
                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id ='57800.İşlem Tipi'> *</label>
                        <div class="col col-8 col-xs-12">
                            <cf_workcube_process_cat slct_width="125">
                        </div>
                    </div>
                    <div class="form-group" id="item-company_id">
                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id ='57519.Cari Hesap'></label>
                        <div class="col col-8 col-xs-12">
                            <div class="input-group">
                                <input type="hidden" name="company_id" id="company_id" value="<cfoutput>#attributes.company_id#</cfoutput>">
                                <input type="text" name="comp_name" id="comp_name" value="<cfoutput>#attributes.comp_name#</cfoutput>"  onFocus="AutoComplete_Create('comp_name','MEMBER_NAME,MEMBER_PARTNER_NAME','MEMBER_NAME,MEMBER_PARTNER_NAME','get_member_autocomplete','\'1,2,3\',\'\',\'\',\'\',\'\',\'\',\'\',\'1\'','COMPANY_ID,PARTNER_ID,MEMBER_PARTNER_NAME','company_id,partner_id,partner_name','','3','250');" autocomplete="off">
                                <span class="input-group-addon icon-ellipsis btnPointer" title="<cf_get_lang dictionary_id='57734.Seçiniz'>" onClick="openBoxDraggable('<cfoutput>#request.self#?fuseaction=objects.popup_list_pars&select_list=2&field_name=add_bond.partner_name&field_partner=add_bond.partner_id&field_comp_name=add_bond.comp_name&field_comp_id=add_bond.company_id</cfoutput>');"></span>
                            </div>
                        </div>
                    </div>
                    <div class="form-group" id="item-partner_id">
                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id ='57578.Yetkili'></label>
                        <div class="col col-8 col-xs-12">
                            <input type="hidden" name="partner_id" id="partner_id" value="">
                            <input type="text" name="partner_name" id="partner_name" value="<cfoutput>#attributes.partner_name#</cfoutput>" >
                        </div>
                    </div>
                </div>
                <div class="col col-3 col-md-4 col-sm-6 col-xs-12" type="column" index="2" sort="true">
                    <div class="form-group" id="item-paper_no">
                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id ='57880.Belge No'> *</label>
                        <div class="col col-8 col-xs-12">
                            <cfinput type="text" name="paper_no" id="paper_no" value="#paper_full#" maxlength="50"  required="yes">
                        </div>
                    </div>
                    <div class="form-group" id="item-action_date">
                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id ='57742.Tarih'></label>
                        <div class="col col-8 col-xs-12">
                            <div class="input-group">
                                <cfinput type="text" name="action_date" id="action_date" validate="#validate_style#"  value="#dateformat(now(),dateformat_style)#" maxlength="10"  required="yes" onblur="change_money_info('add_bond','action_date');">
                                <span class="input-group-addon"><cf_wrk_date_image date_field="action_date" call_function="change_money_info"></span>
                            </div>
                        </div>
                    </div>
                    <div class="form-group" id="item-ref_no">
                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='58794.Referans No'></label>
                        <div class="col col-8 col-xs-12">
                            <input type="text" name="ref_no" id="ref_no" value="" >
                        </div>
                    </div>
                </div>
                <div class="col col-3 col-md-4 col-sm-6 col-xs-12" type="column" index="3" sort="true">
                    <div class="form-group" id="item-broker_company">
                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id ='51417.Aracı Kurum'></label>
                        <div class="col col-8 col-xs-12">
                            <input type="text" name="broker_company" id="broker_company" value="" >
                        </div>
                    </div>
                    <div class="form-group" id="item-employee_id">
                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id ='58586.İşlem Yapan'></label>
                        <div class="col col-8 col-xs-12">
                            <div class="input-group">
                                <input type="hidden" name="employee_id" id="employee_id" value="<cfoutput>#session.ep.userid#</cfoutput>">
                                <input type="text" name="employee" id="employee"  value="<cfoutput>#session.ep.name# #session.ep.surname#</cfoutput>">
                                <span class="input-group-addon icon-ellipsis btnPointer" title="<cf_get_lang dictionary_id ='58586.İşlem Yapan'>" onClick="openBoxDraggable('<cfoutput>#request.self#?fuseaction=objects.popup_list_positions&field_emp_id=add_bond.employee_id&field_name=add_bond.employee&select_list=1</cfoutput>');"></span>
                            </div>
                        </div>
                    </div>
                    <div class="form-group" id="item-account_id">
                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='29449.Banka Hesabı'></label>
                        <div class="col col-8 col-xs-12">
                            <cfinclude template="../query/get_accounts.cfm">
                            <select name="account_id" id="account_id" style="width:285px;" onChange="">
                                <option value=""><cf_get_lang dictionary_id ='57734.Seçiniz'></option>
                                <cfoutput query="get_accounts">
                                    <option value="#account_id#;#account_currency_id#" >#account_name#-#account_currency_id#</option>
                                </cfoutput>
                            </select>
                        </div>
                    </div>
                </div>
                <div class="col col-3 col-md-4 col-sm-6 col-xs-12" type="column" index="4" sort="true">
                    <div class="form-group" id="item-detail">
                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id ='57629.Açıklama'></label>
                        <div class="col col-8 col-xs-12">
                            <textarea name="detail" id="detail" style="width:285px;height:50px;"></textarea>
                        </div>
                    </div>
                    
                </div>
                <div class="col col-12 col-md-12 col-sm-12 col-xs-12">
                    <div class="form-group col col-12 col-md-12 col-sm-12 col-xs-12" style="background-color:#f9f9f9">
                        <input name="record_num" id="record_num" type="hidden" value="0">
                        <div class="ui-card-add-btn"><a href="javascript://" onClick="f_add_bond();"><i class="icon-pluss" alt="<cf_get_lang dictionary_id='63854.Menkul Kıymet Seç'>" title="<cf_get_lang dictionary_id='63854.Menkul Kıymet Seç'>"></i></a></div>
                        <div id="table_list"></div>
                    </div>
                </div>
            </cf_box_elements>
            <div class="row formContentFooter">
                <div id="sepetim_total" class="padding-10">
                    <div class="col col-3 col-md-3 col-sm-3 col-xs-12" id="basket_money_totals_table">
                        <div class="totalBox">
                            <div class="totalBoxHead font-grey-mint">
                                <span class="headText"><cf_get_lang dictionary_id='57677.Dövizler'></span>
                                <div class="collapse">
                                    <span class="icon-minus"></span>
                                </div>
                            </div>
                            <div class="totalBoxBody">
                                <table cellspacing="0" id="money_rate_table">
                                    <input type="hidden" name="kur_say" id="kur_say" value="<cfoutput>#get_money.recordcount#</cfoutput>">
                                    <input type="hidden" name="money_type" id="money_type" value="<cfoutput>#session.ep.money#</cfoutput>">
                                    <cfoutput>
                                        <cfif len(session.ep.money)>
                                            <cfset selected_money=session.ep.money>
                                        </cfif>
                                        <cfif session.ep.rate_valid eq 1>
                                            <cfset readonly_info = "yes">
                                        <cfelse>
                                            <cfset readonly_info = "no">
                                        </cfif>
                                        <cfloop query="get_money">
                                        <tr>
                                            <td nowrap="nowrap">
                                                <input type="hidden" name="hidden_rd_money_#currentrow#" id="hidden_rd_money_#currentrow#" value="#money#">
                                                <input type="hidden" name="txt_rate1_#currentrow#" id="txt_rate1_#currentrow#" value="#rate1#">
                                                <div class="form-group">
                                                    <input type="radio" name="rd_money" id="rd_money" value="#money#" onClick="doviz_hesapla();" <cfif selected_money eq money>checked</cfif>>#money#
                                                </div>
                                            </td>
                                            <td>
                                                <div class="form-group">
                                                    #TLFormat(rate1,0)#/
                                                </div>
                                            </td>
                                            <td nowrap="nowrap">
                                                <div class="form-group">
                                                    <input type="text" name="txt_rate2_#currentrow#" id="txt_rate2_#currentrow#" <cfif readonly_info>readonly</cfif> class="box" <cfif money eq session.ep.money> readonly="yes"</cfif> OnBlur="doviz_hesapla();" value="#TLFormat(rate2,session.ep.our_company_info.rate_round_num)#" onkeyup="return(FormatCurrency(this,event,#session.ep.our_company_info.rate_round_num#));">
                                                </div>
                                            </td>
                                        </tr>
                                        </cfloop>
                                    </cfoutput>
                                </table>
                            </div>
                        </div>
                    </div>
                    <div class="col col-5 col-md-5 col-sm-5 col-xs-12" id="basket_money_totals_table">
                        <div class="totalBox">
                            <div class="totalBoxHead font-grey-mint">
                                <span class="headText"><cf_get_lang dictionary_id="57492.Toplam"></span>
                                <div class="collapse">
                                    <span class="icon-minus"></span>
                                </div>
                            </div>
                            <div class="totalBoxBody">
                                <table>
                                    <!--- Toplam Satis --->
                                    <tbody>
                                        <tr>
                                            <td><cf_get_lang dictionary_id ='51436.Toplam Satis'><cfoutput>#session.ep.money#</cfoutput></td>
                                            <td><div class="form-group"><input type="text" name="action_value" id="action_value" class="moneybox" value="0" onBlur="doviz_hesapla();" readonly="yes"></div></td>
                                        </tr>
                                        <tr>
                                            <td><cf_get_lang dictionary_id ='51442.Toplam Satis Doviz '></td>
                                            <td nowrap="nowrap"><div class="form-group"><input type="text" name="sale_other" id="sale_other" class="moneybox"value="0" readonly="yes"></div></td>
                                            <td width="55"><div class="form-group"><input type="text" name="other_money_info" id="other_money_info" class="box" value="<cfoutput>#session.ep.money2#</cfoutput>" readonly="yes"></div></td>
                                        </tr>
                                        <tr>
                                            <td><cf_get_lang dictionary_id ='51423.Komisyon Oranı'>%</td>
                                            <td><div class="form-group"><input type="text" name="com_rate" id="com_rate" class="moneybox" value="0" onBlur="toplam_hesapla();" onkeyup="return(FormatCurrency(this,event,<cfoutput>#session.ep.our_company_info.rate_round_num#</cfoutput>));"></div></td>
                                        </tr>
                                        <tr>
                                            <td><cf_get_lang dictionary_id ='51425.Komisyon Toplam'><cfoutput>#session.ep.money#</cfoutput></td>
                                            <td><div class="form-group"><input type="text" name="com_ytl" id="com_ytl" class="moneybox" value="0" onBlur="total_doviz_hesapla();"></div></td>
                                        </tr>
                                        <tr>
                                            <td><cf_get_lang dictionary_id ='51425.Komisyon Toplam'><cf_get_lang dictionary_id='57677.Doviz'></td>
                                            <td><div class="form-group"><input type="text" name="com_other" id="com_other"  class="moneybox" value="0" readonly="yes"></div></td>
                                            <td width="55"><div class="form-group"><input type="text" name="other_money_info1" id="other_money_info1" class="box" readonly="" value="<cfoutput>#session.ep.money2#</cfoutput>"></div></td>
                                        </tr>
                                        <tr>
                                            <td><cf_get_lang dictionary_id='51336.Toplam Gelir/Gider'><cfoutput>#session.ep.money#</cfoutput></td>
                                            <td><div class="form-group"><input type="text" name="total_income" id="total_income" class="moneybox" value="0"  onBlur="total_doviz_hesapla();" readonly="yes"></div></td>
                                        </tr>
                                        <tr>
                                            <td><cf_get_lang dictionary_id ='51336.Toplam Gelir/Gider'><cf_get_lang dictionary_id='57677.Döviz'></td>
                                            <td><div class="form-group"><input type="text" name="total_income_other" id="total_income_other" class="moneybox" value="0"></div></td>
                                            <td width="55"><div class="form-group"><input type="text" name="other_money_info2" id="other_money_info2" class="box" value="<cfoutput>#session.ep.money2#</cfoutput>" readonly="yes"></div></td>
                                        </tr>
                                    </tbody>
                                </table>
                            </div>
                        </div>
                    </div>
                    <div class="col col-4 col-md-4 col-sm-4 col-xs-12" id="basket_money_totals_table">
                        <div class="totalBox">
                            <div class="totalBoxHead font-grey-mint">
                                <span class="headText"><cf_get_lang dictionary_id='54511.Masraflar'></span>
                                <div class="collapse">
                                    <span class="icon-minus"></span>
                                </div>
                            </div>
                            <div class="totalBoxBody">
                                <table>
                                    <tbody>
                                        <tr>
                                            <td><label><cf_get_lang dictionary_id='58172.Gelir Merkezi'>*</label></td>
                                            <td>   
                                                <div class="form-group" id="item-expense_center_id">
                                                    <div class="input-group">	
                                                        <input name="expense_center_id" id="expense_center_id" type="hidden" value="">
                                                        <cfinput name="expense_center" id="expense_center"   type="text" value="">
                                                        <span class="input-group-addon icon-ellipsis btnPointer" title="<cf_get_lang dictionary_id='57734.Seçiniz'>" onClick="openBoxDraggable('<cfoutput>#request.self#?fuseaction=objects.popup_expense_center&field_name=add_bond.expense_center&field_id=add_bond.expense_center_id&&is_invoice=1</cfoutput>');"></span>
                                                    </div>
                                                </div>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td><label><cf_get_lang dictionary_id='58173.Gelir Kalemi'>*</label></td>
                                            <td>   
                                                <div class="form-group" id="item-expense_item_id">
                                                    <div class="input-group">	
                                                        <input type="hidden" name="expense_item_id" id="expense_item_id" value="">
                                                        <cfinput type="text" name="expense_item_name" id="expense_item_name" value=""  onFocus="AutoComplete_Create('expense_item_name','EXPENSE_ITEM_NAME','EXPENSE_ITEM_NAME','get_expense_item','','EXPENSE_ITEM_ID,ACCOUNT_CODE,ACCOUNT_CODE','expense_item_id,acc_name,acc_id','add_bond',3);" autocomplete="off">
                                                        <span class="input-group-addon icon-ellipsis btnPointer" title="<cf_get_lang dictionary_id='57734.Seçiniz'>" onClick="openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_exp_item&field_id=add_bond.expense_item_id&field_name=add_bond.expense_item_name&is_income=1&field_account_no=add_bond.acc_id&field_account_no2=add_bond.acc_name');"></span>
                                                    </div>
                                                </div>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td><label><cf_get_lang dictionary_id='58811.Muhasebe Kodu'>*</label></td>
                                            <td>   
                                                <div class="form-group" id="item-acc_id">
                                                    <div class="input-group">	
                                                        <cf_wrk_account_codes form_name='add_bond' account_code='acc_id' account_name='acc_name' search_from_name='1'>		
                                                        <input type="hidden" name="acc_id" id="acc_id" value="" >
                                                        <cfinput type="text" name="acc_name" id="acc_name" value=""  onkeyup="get_wrk_acc_code_1();" onFocus="AutoComplete_Create('acc_name','ACCOUNT_CODE','ACCOUNT_CODE,ACCOUNT_NAME','get_account_code','\'0\',0','ACCOUNT_CODE','acc_id','add_bond','3','120');" autocomplete="off">
                                                        <span class="input-group-addon icon-ellipsis btnPointer" title="<cf_get_lang dictionary_id='57734.Seçiniz'>" onClick="openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_account_plan&field_name=add_bond.acc_name&field_id=add_bond.acc_id')"></span>
                                                    </div>
                                                </div>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td><label><cf_get_lang dictionary_id='58791.Komisyon'><cf_get_lang dictionary_id='58460.Masraf Merkezi'></label></td>
                                            <td>   
                                                <div class="form-group" id="item-com_exp_center_id">
                                                    <div class="input-group">	
                                                        <input name="com_exp_center_id" id="com_exp_center_id" type="hidden" value="">
                                                        <cfinput name="com_exp_center" id="com_exp_center"   type="text" value="">
                                                        <span class="input-group-addon icon-ellipsis btnPointer" title="<cf_get_lang dictionary_id='57734.Seçiniz'>" onClick="openBoxDraggable('<cfoutput>#request.self#?fuseaction=objects.popup_expense_center&field_name=add_bond.com_exp_center&field_id=add_bond.com_exp_center_id&is_invoice=1</cfoutput>');"></span>
                                                    </div>
                                                </div>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td><label><cf_get_lang dictionary_id='58791.Komisyon'><cf_get_lang dictionary_id ='58551.Gider Kalemi'></label></td>
                                            <td>   
                                                <div class="form-group" id="item-com_exp_item_id">
                                                    <div class="input-group">	
                                                        <input type="hidden" name="com_exp_item_id" id="com_exp_item_id" value="">
                                                        <cfinput type="text" name="com_exp_item_name" id="com_exp_item_name" value=""  onFocus="AutoComplete_Create('com_exp_item_name','EXPENSE_ITEM_NAME','EXPENSE_ITEM_NAME','get_expense_item','','EXPENSE_ITEM_ID,ACCOUNT_CODE,ACCOUNT_CODE','com_exp_item_id,com_acc_name,com_acc_id','add_bond',3);" autocomplete="off">
                                                        <span class="input-group-addon icon-ellipsis btnPointer" title="<cf_get_lang dictionary_id='57734.Seçiniz'>" onClick="openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_exp_item&field_id=add_bond.com_exp_item_id&field_name=add_bond.com_exp_item_name&field_account_no=add_bond.com_acc_id&field_account_no2=add_bond.com_acc_name');"></span>
                                                    </div>
                                                </div>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td><label><cf_get_lang dictionary_id='58791.Komisyon'><cf_get_lang dictionary_id='58811.Muhasebe Kodu'></label></td>
                                            <td>   
                                                <div class="form-group" id="item-com_acc_id">
                                                    <div class="input-group">	
                                                        <cf_wrk_account_codes form_name='add_bond' account_code='com_acc_id' account_name='com_acc_name' search_from_name='1' is_multi_no ='2'>
                                                        <input type="hidden" name="com_acc_id" id="com_acc_id" value="" >
                                                        <cfinput type="text" name="com_acc_name" id="com_acc_name" value=""  onkeyup="get_wrk_acc_code_2();" onFocus="AutoComplete_Create('com_acc_name','ACCOUNT_CODE','ACCOUNT_CODE,ACCOUNT_NAME','get_account_code','\'0\',0','ACCOUNT_CODE','com_acc_id','add_bond','3','120');" autocomplete="off">
                                                        <span class="input-group-addon icon-ellipsis btnPointer" title="<cf_get_lang dictionary_id='57734.Seçiniz'>" onClick="openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_account_plan&field_name=add_bond.com_acc_name&field_id=add_bond.com_acc_id');"></span>
                                                    </div>
                                                </div>
                                            </td>
                                        </tr>
                                        <input type="hidden" name="nominal_total_amount" id="nominal_total_amount" class="moneybox"  value="0">
                                        <input type="hidden" name="other_nominal_total_amount" id="other_nominal_total_amount" class="moneybox"  value="0">
                                        <tr>
                                            <td><label><cf_get_lang dictionary_id='51421.Masraf/Gelir Merkezi'>*</label></td>
                                            <td>   
                                                <div class="form-group" id="item-total_income_exp_center_id">
                                                    <div class="input-group">	
                                                        <input name="total_income_exp_center_id" id="total_income_exp_center_id" type="hidden" value="">
                                                        <cfinput name="total_income_exp_center" id="total_income_exp_center"   type="text" value="">
                                                        <span class="input-group-addon icon-ellipsis btnPointer" title="<cf_get_lang dictionary_id='57734.Seçiniz'>" onClick="openBoxDraggable('<cfoutput>#request.self#?fuseaction=objects.popup_expense_center&field_name=add_bond.total_income_exp_center&field_id=add_bond.total_income_exp_center_id&is_invoice=1</cfoutput>');"></span>
                                                    </div>
                                                </div>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td><label><cf_get_lang dictionary_id ='51335.Gelir/Gider Kalemi'>*</label></td>
                                            <td>   
                                                <div class="form-group" id="item-total_income_exp_item_id">
                                                    <div class="input-group">	
                                                        <input type="hidden" name="total_income_exp_item_id" id="total_income_exp_item_id" value="">
                                                        <cfinput type="text" name="total_income_exp_item_name" id="total_income_exp_item_name" value=""  onFocus="AutoComplete_Create('total_income_exp_item_name','EXPENSE_ITEM_NAME','EXPENSE_ITEM_NAME','get_expense_item','','EXPENSE_ITEM_ID,ACCOUNT_CODE,ACCOUNT_CODE','total_income_exp_item_id,total_income_acc_name,total_income_acc_id','add_bond',3);" autocomplete="off">
                                                        <span class="input-group-addon icon-ellipsis btnPointer" title="<cf_get_lang dictionary_id='57734.Seçiniz'>" onClick="openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_exp_item&is_budget_items=1&field_id=add_bond.total_income_exp_item_id&field_name=add_bond.total_income_exp_item_name&is_income=1&field_account_no=add_bond.total_income_acc_id&field_account_no2=add_bond.total_income_acc_name');"></span>
                                                    </div>
                                                </div>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td><label><cf_get_lang dictionary_id='58811.Muhasebe Kodu'>*</label></td>
                                            <td>   
                                                <div class="form-group" id="item-total_income_acc_id">
                                                    <div class="input-group">	
                                                        <cf_wrk_account_codes form_name='add_bond' account_code='total_income_acc_id' account_name='total_income_acc_name' search_from_name='1' is_multi_no ='2'>
                                                        <input type="hidden" name="total_income_acc_id" id="total_income_acc_id" value="" >
                                                        <cfinput type="text" name="total_income_acc_name" id="total_income_acc_name" value=""  onkeyup="get_wrk_acc_code_2();" onFocus="AutoComplete_Create('total_income_acc_name','ACCOUNT_CODE','ACCOUNT_CODE,ACCOUNT_NAME','get_account_code','\'0\',0','ACCOUNT_CODE','total_income_acc_id','add_bond','3','120');" autocomplete="off">
                                                        <span class="input-group-addon icon-ellipsis btnPointer" title="<cf_get_lang dictionary_id='57734.Seçiniz'>" onClick="openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_account_plan&field_name=add_bond.total_income_acc_name&field_id=add_bond.total_income_acc_id');"></span>
                                                    </div>
                                                </div>
                                            </td>
                                        </tr>
                                    </tbody>
                                </table>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
            <cf_box_footer>
                <cf_workcube_buttons is_upd='0' add_function='kontrol()'>
            </cf_box_footer>

        </cfform>
    </cf_box>
</div>
<script type="text/javascript">

var stockBondCounter = 0;
var stockBondObject = [{
    "sil" :                 "<a style='cursor:pointer;' onclick='sil(###id###);'><img src='images/delete_list.gif' border='0'></a><input name='productRow' value='###id###' type='hidden'>",
    "row_kontrol":          "<input type='hidden' name='row_kontrol###id###' id='row_kontrol###id###' value='1'>",
    "stockbond_id":         "<input type='hidden' name='stockbond_id###id###' id='stockbond_id###id###' value='###val-stockbond_id###'>",
    "stockbond_row_id":     "<input type='hidden' name='stockbond_row_id###id###' id='stockbond_row_id###id###' value='0'>",
    "bond_type":            "<div class='acc-block-name col col-12 col-md-12 col-sm-12 col-xs-12'><label class='col col-12 col-md-12 col-sm-12 col-xs-12'><cf_get_lang dictionary_id ='57630.Tip'>*</label><div class='col col-12 col-md-12 col-sm-12 col-xs-12'><input type='text' name='bond_type###id###' id='bond_type###id###' value='###val-bond_type###'></div></div>",
    "bond_code":            "<div class='acc-block-name col col-12 col-md-12 col-sm-12 col-xs-12'><label class='col col-12 col-md-12 col-sm-12 col-xs-12'><cf_get_lang dictionary_id ='58585.Kod'>*</label><div class='col col-12 col-md-12 col-sm-12 col-xs-12'><input type='text' name='bond_code###id###' id='bond_code###id###' value='###val-bond_code###' readonly></div></div>",
    "row_detail":           "<div class='acc-block-name col col-12 col-md-12 col-sm-12 col-xs-12'><label class='col col-12 col-md-12 col-sm-12 col-xs-12'><cf_get_lang dictionary_id ='57629.Açıklama'>*</label><div class='col col-12 col-md-12 col-sm-12 col-xs-12'><input type='text' name='row_detail###id###' id='row_detail###id###' value='###val-row_detail###'></div></div>",
    "nominal_value":        "<div class='acc-block-name col col-12 col-md-12 col-sm-12 col-xs-12'><label class='col col-12 col-md-12 col-sm-12 col-xs-12'><cf_get_lang dictionary_id ='51409.Nominal Değer'>*</label><div class='col col-12 col-md-12 col-sm-12 col-xs-12'><input type='text' name='nominal_value###id###' id='nominal_value###id###' value='###val-nominal_value###' class='moneybox' onkeyup='return(FormatCurrency(this,event,<cfoutput>#session.ep.our_company_info.rate_round_num#</cfoutput>));' onblur='hesapla(###id###);'></div></div>",
    "other_nominal_value":  "<div class='acc-block-name col col-12 col-md-12 col-sm-12 col-xs-12'><label class='col col-12 col-md-12 col-sm-12 col-xs-12'><cf_get_lang dictionary_id ='51410.Nominal Değer Döviz'>*</label><div class='col col-12 col-md-12 col-sm-12 col-xs-12'><input type='text' name='other_nominal_value###id###' id='other_nominal_value###id###' value='###val-other_nominal_value###' class='moneybox' onkeyup='return(FormatCurrency(this,event,<cfoutput>#session.ep.our_company_info.rate_round_num#</cfoutput>));' onblur='hesapla(###id###,1);'></div></div>",
    "sale_value":           "<div class='acc-block-name col col-12 col-md-12 col-sm-12 col-xs-12'><label class='col col-12 col-md-12 col-sm-12 col-xs-12'><cf_get_lang dictionary_id ='51440.Satis Değer'>*</label><div class='col col-12 col-md-12 col-sm-12 col-xs-12'><input type='text' name='sale_value###id###' id='sale_value###id###' value='###val-sale_value###' class='moneybox' onkeyup='return(FormatCurrency(this,event,<cfoutput>#session.ep.our_company_info.rate_round_num#</cfoutput>));' onblur='hesapla(###id###);'></div></div>",
    "other_sale_value":     "<div class='acc-block-name col col-12 col-md-12 col-sm-12 col-xs-12'><label class='col col-12 col-md-12 col-sm-12 col-xs-12'><cf_get_lang dictionary_id ='51441.Satis Değer Döviz'>*</label><div class='col col-12 col-md-12 col-sm-12 col-xs-12'><input type='text' name='other_sale_value###id###' id='other_sale_value###id###' value='###val-other_sale_value###' class='moneybox' onkeyup='return(FormatCurrency(this,event,<cfoutput>#session.ep.our_company_info.rate_round_num#</cfoutput>));' onblur='hesapla(###id###,1);'></div></div>",
    "quantity":             "<div class='acc-block-name col col-12 col-md-12 col-sm-12 col-xs-12'><label class='col col-12 col-md-12 col-sm-12 col-xs-12'><cf_get_lang dictionary_id ='57635.Miktar'></label><div class='col col-12 col-md-12 col-sm-12 col-xs-12'><input type='text' name='quantity###id###' id='quantity###id###' value='###val-quantity###' class='moneybox' onkeyup='return(FormatCurrency(this,event,4));' onblur='hesapla(###id###);'></div></div>",
    "total_sale":           "<div class='acc-block-name col col-12 col-md-12 col-sm-12 col-xs-12'><label class='col col-12 col-md-12 col-sm-12 col-xs-12'><cf_get_lang dictionary_id ='51436.Toplam Satis'></label><div class='col col-12 col-md-12 col-sm-12 col-xs-12'><input type='text' name='total_sale###id###' id='total_sale###id###' value='###val-total_sale###' class='moneybox' onkeyup='return(FormatCurrency(this,event,<cfoutput>#session.ep.our_company_info.rate_round_num#</cfoutput>));' onblur='hesapla(###id###);' readonly></div></div>",
    "other_total_sale":     "<div class='acc-block-name col col-12 col-md-12 col-sm-12 col-xs-12'><label class='col col-12 col-md-12 col-sm-12 col-xs-12'><cf_get_lang dictionary_id ='51442.Toplam Satis Döviz'></label><div class='col col-12 col-md-12 col-sm-12 col-xs-12'><input type='text' name='other_total_sale###id###' id='other_total_sale###id###' value='###val-other_total_sale###' class='moneybox' onkeyup='return(FormatCurrency(this,event,<cfoutput>#session.ep.our_company_info.rate_round_num#</cfoutput>));' readonly></div></div>",
    "expense_center_id":    "<div class='acc-block-name col col-12 col-md-12 col-sm-12 col-xs-12'><label class='col col-12 col-md-12 col-sm-12 col-xs-12'><cf_get_lang dictionary_id ='51421.Masraf / Gelir Merkezi'></label><div class='col col-12 col-md-12 col-sm-12 col-xs-12'><input type='text' name='expense_center_id###id###' id='expense_center_id###id###' value='###val-expense_center_id###' readonly></div></div>",
    "expense_item_id":      "<div class='acc-block-name col col-12 col-md-12 col-sm-12 col-xs-12'><label class='col col-12 col-md-12 col-sm-12 col-xs-12'><cf_get_lang dictionary_id ='58234.Bütçe Kalemi'></label><div class='col col-12 col-md-12 col-sm-12 col-xs-12'><input type='text' name='expense_item_id###id###' id='expense_item_id###id###' value='###val-expense_item_id###' readonly></div></div>",
    "due_date":             "<div class='acc-block-name col col-12 col-md-12 col-sm-12 col-xs-12'><label class='col col-12 col-md-12 col-sm-12 col-xs-12'><cf_get_lang dictionary_id ='57881.Vade Tarihi'></label><div class='col col-12 col-md-12 col-sm-12 col-xs-12'><div class='input-group'><input type='text' name='due_date###id###' id='due_date###id###' maxlength='10'><span class='input-group-addon'><span class='date-group' id='due_date###id###_td'></span></span></div></div></div>"
}];

var find = ["val-stockbond_id","val-bond_type", "val-bond_code", "val-row_detail", "val-nominal_value", "val-other_nominal_value", "val-sale_value", "val-other_sale_value", "val-quantity", "val-total_sale", "val-other_total_sale", "val-expense_center_id", "val-expense_item_id"];

String.prototype.replaceArray = function(find, replace) {
  var replaceString = this, regex;
  for (var i = 0; i < find.length; i++) {
    regex = new RegExp("###"+find[i]+"###", "g");
    replaceString = replaceString.replace(regex, replace[i]);
  }
  return replaceString;
};

function gonder(stockbond_id,bond_type,bond_code,detail,quantity,nominal_value,other_nominal_value,sale_value,other_sale_value,total_sale,other_total_sale,due_date,expense_center_name,expense_center_name)
{
    stockBondCounter +=1;
    document.getElementById("record_num").value = parseInt(document.getElementById("record_num").value) + 1;
    var replace = [stockbond_id, bond_type, bond_code, detail, nominal_value, other_nominal_value, sale_value, other_sale_value, quantity, total_sale, other_total_sale, expense_center_name, expense_center_name  ];
    var template="<div class='ui-card-item' id='block_row_"+stockBondCounter+"'>{row_kontrol}{stockbond_id}{stockbond_row_id}<div class='ui-card-item-hide'><a href='javascript://' onclick='removeItem("+stockBondCounter+")'><i class='icon-minus'></i></a></div><div class='acc-body'><div class='col col-3 col-md-4 col-sm-6 col-xs-12'>{bond_type}{bond_code}{row_detail}</div><div class='col col-3 col-md-4 col-sm-6 col-xs-12'>{nominal_value}{other_nominal_value}{sale_value}{other_sale_value}</div><div class='col col-3 col-md-4 col-sm-6 col-xs-12'>{quantity}{total_sale}{other_total_sale}{expense_center_id}</div><div class='col col-3 col-md-4 col-sm-6 col-xs-12'>{expense_item_id}{due_date}</div></div></div>";
    stockBondObject.filter((el) => { $('#table_list').append(nano( template, el ).replace(/###id###/g,stockBondCounter).replaceArray(find, replace)); });
    wrk_date_image('due_date' + stockBondCounter);
    toplam_hesapla();
}
function removeItem(id) {
    document.getElementById("block_row_"+id+"").remove();
    toplam_hesapla();
}
function hesapla(row_no, val)
{
	sale_value = document.getElementById("sale_value"+row_no);
	nominal_value = document.getElementById("nominal_value"+row_no);
	quantity = document.getElementById("quantity"+row_no);
	if(sale_value.value  == " ") sale_value.value  = 0;
	if(nominal_value.value  == " ") nominal_value.value  = 0;
	if(quantity.value  == " ") quantity.value  = 1;
	for (var i=1; i<=document.getElementById("kur_say").value; i++)
	{		
		if(document.add_bond.rd_money[i-1].checked == true)
		{
			form_txt_rate2_ = filterNum(document.getElementById("txt_rate2_"+i).value,'<cfoutput>#session.ep.our_company_info.rate_round_num#</cfoutput>')/filterNum(document.getElementById("txt_rate1_"+i).value,'<cfoutput>#session.ep.our_company_info.rate_round_num#</cfoutput>');
            if( val == undefined){
                document.getElementById("other_total_sale"+row_no).value = commaSplit(filterNum(document.getElementById("total_sale"+row_no).value,'<cfoutput>#session.ep.our_company_info.rate_round_num#</cfoutput>')/form_txt_rate2_,'<cfoutput>#session.ep.our_company_info.rate_round_num#</cfoutput>');
			    document.getElementById("other_sale_value"+row_no).value = commaSplit(filterNum(document.getElementById("sale_value"+row_no).value,'<cfoutput>#session.ep.our_company_info.rate_round_num#</cfoutput>')/form_txt_rate2_,'<cfoutput>#session.ep.our_company_info.rate_round_num#</cfoutput>');
			    document.getElementById("other_nominal_value"+row_no).value = commaSplit(filterNum(document.getElementById("nominal_value"+row_no).value,'<cfoutput>#session.ep.our_company_info.rate_round_num#</cfoutput>')/form_txt_rate2_,'<cfoutput>#session.ep.our_company_info.rate_round_num#</cfoutput>');
            }else{
                document.getElementById("total_sale"+row_no).value = commaSplit(filterNum(document.getElementById("other_total_sale"+row_no).value,'<cfoutput>#session.ep.our_company_info.rate_round_num#</cfoutput>')*form_txt_rate2_,'<cfoutput>#session.ep.our_company_info.rate_round_num#</cfoutput>');
			    document.getElementById("sale_value"+row_no).value = commaSplit(filterNum(document.getElementById("other_sale_value"+row_no).value,'<cfoutput>#session.ep.our_company_info.rate_round_num#</cfoutput>')*form_txt_rate2_,'<cfoutput>#session.ep.our_company_info.rate_round_num#</cfoutput>');
			    document.getElementById("nominal_value"+row_no).value = commaSplit(filterNum(document.getElementById("other_nominal_value"+row_no).value,'<cfoutput>#session.ep.our_company_info.rate_round_num#</cfoutput>')*form_txt_rate2_,'<cfoutput>#session.ep.our_company_info.rate_round_num#</cfoutput>');
            }
        }
	}
	toplam_hesapla();
}
function toplam_hesapla()
{
    var total_amount = 0;
	var other_total_amount = 0;
	var nominal_total_amount = 0;
	var other_nominal_total_amount = 0;
    if(document.getElementById("record_num").value > 0){
        for(j=1;j<=document.getElementById("record_num").value;j++)
        {	
            if( typeof( document.getElementById("row_kontrol"+j) ) != 'undefined' && document.getElementById("row_kontrol"+j) != null && document.getElementById("row_kontrol"+j).value==1)
            {
                document.getElementById("total_sale"+j).value = commaSplit(parseFloat(filterNum(document.getElementById("sale_value"+j).value,'<cfoutput>#session.ep.our_company_info.rate_round_num#</cfoutput>'))*parseFloat(filterNum(document.getElementById("quantity"+j).value,'<cfoutput>#session.ep.our_company_info.rate_round_num#</cfoutput>')),'<cfoutput>#session.ep.our_company_info.rate_round_num#</cfoutput>');
                document.getElementById("other_total_sale"+j).value = commaSplit(parseFloat(filterNum(document.getElementById("other_sale_value"+j).value,'<cfoutput>#session.ep.our_company_info.rate_round_num#</cfoutput>'))*parseFloat(filterNum(document.getElementById("quantity"+j).value,'<cfoutput>#session.ep.our_company_info.rate_round_num#</cfoutput>')),'<cfoutput>#session.ep.our_company_info.rate_round_num#</cfoutput>');
                total_amount += parseFloat(filterNum(document.getElementById("total_sale"+j).value,'<cfoutput>#session.ep.our_company_info.rate_round_num#</cfoutput>'));
                other_total_amount += parseFloat(filterNum(document.getElementById("other_total_sale"+j).value,'<cfoutput>#session.ep.our_company_info.rate_round_num#</cfoutput>'));
                nominal_total_amount += parseFloat(filterNum(document.getElementById("nominal_value"+j).value,'<cfoutput>#session.ep.our_company_info.rate_round_num#</cfoutput>'))*parseFloat(filterNum(document.getElementById("quantity"+j).value,'<cfoutput>#session.ep.our_company_info.rate_round_num#</cfoutput>'));
                other_nominal_total_amount += parseFloat(filterNum(document.getElementById("other_nominal_value"+j).value,'<cfoutput>#session.ep.our_company_info.rate_round_num#</cfoutput>'))*parseFloat(filterNum(document.getElementById("quantity"+j).value,'<cfoutput>#session.ep.our_company_info.rate_round_num#</cfoutput>'));
            }
        }
    }else{
        total_amount = 0;
        other_total_amount = 0;
        nominal_total_amount = 0;
        other_nominal_total_amount = 0;
    }
	com_rate = filterNum(document.getElementById("com_rate").value,'<cfoutput>#session.ep.our_company_info.rate_round_num#</cfoutput>');
	document.getElementById("action_value").value = commaSplit(total_amount,'<cfoutput>#session.ep.our_company_info.rate_round_num#</cfoutput>');
	document.getElementById("sale_other").value = commaSplit(other_total_amount,'<cfoutput>#session.ep.our_company_info.rate_round_num#</cfoutput>');
	document.getElementById("com_ytl").value =commaSplit(filterNum(document.getElementById("action_value").value,'<cfoutput>#session.ep.our_company_info.rate_round_num#</cfoutput>')*com_rate/100,'<cfoutput>#session.ep.our_company_info.rate_round_num#</cfoutput>');
	document.getElementById("com_other").value =commaSplit(filterNum(document.getElementById("sale_other").value,'<cfoutput>#session.ep.our_company_info.rate_round_num#</cfoutput>')*com_rate/100,'<cfoutput>#session.ep.our_company_info.rate_round_num#</cfoutput>');
	document.getElementById("total_income").value =commaSplit(total_amount-nominal_total_amount,'<cfoutput>#session.ep.our_company_info.rate_round_num#</cfoutput>');
	document.getElementById("total_income_other").value =commaSplit(other_total_amount-other_nominal_total_amount,'<cfoutput>#session.ep.our_company_info.rate_round_num#</cfoutput>');
	document.getElementById("nominal_total_amount").value =commaSplit(nominal_total_amount,'<cfoutput>#session.ep.our_company_info.rate_round_num#</cfoutput>');
	document.getElementById("other_nominal_total_amount").value =commaSplit(other_nominal_total_amount,'<cfoutput>#session.ep.our_company_info.rate_round_num#</cfoutput>');
}
function doviz_hesapla()
{
	for (var t=1; t<=document.getElementById("kur_say").value; t++)
	{		
		if(document.add_bond.rd_money[t-1].checked == true)
		{
			for(k=1;k<=document.getElementById("record_num").value;k++)
			{		
				rate2_value = filterNum(document.getElementById("txt_rate2_"+t).value,'<cfoutput>#session.ep.our_company_info.rate_round_num#</cfoutput>')/filterNum(document.getElementById("txt_rate1_"+t).value,'<cfoutput>#session.ep.our_company_info.rate_round_num#</cfoutput>');
				document.getElementById("other_nominal_value"+k).value = commaSplit(filterNum(document.getElementById("nominal_value"+k).value,'<cfoutput>#session.ep.our_company_info.rate_round_num#</cfoutput>')/rate2_value,'<cfoutput>#session.ep.our_company_info.rate_round_num#</cfoutput>');
				document.getElementById("other_sale_value"+k).value = commaSplit(filterNum(document.getElementById("sale_value"+k).value,'<cfoutput>#session.ep.our_company_info.rate_round_num#</cfoutput>')/rate2_value,'<cfoutput>#session.ep.our_company_info.rate_round_num#</cfoutput>');
				document.getElementById("other_total_sale"+k).value = commaSplit(filterNum(document.getElementById("total_sale"+k).value,'<cfoutput>#session.ep.our_company_info.rate_round_num#</cfoutput>')/rate2_value,'<cfoutput>#session.ep.our_company_info.rate_round_num#</cfoutput>');
				document.getElementById("sale_other").value = commaSplit(filterNum(document.getElementById("action_value").value,'<cfoutput>#session.ep.our_company_info.rate_round_num#</cfoutput>')/rate2_value,'<cfoutput>#session.ep.our_company_info.rate_round_num#</cfoutput>');
			}
			document.getElementById("other_money_info").value = document.add_bond.rd_money[t-1].value;
			document.getElementById("other_money_info1").value = document.add_bond.rd_money[t-1].value;
			document.getElementById("other_money_info2").value = document.add_bond.rd_money[t-1].value;
		}
	}
	toplam_hesapla();
}
function total_doviz_hesapla()
{
	for (var t=1; t<=document.getElementById("kur_say").value; t++)
	{		
		if(document.add_bond.rd_money[t-1].checked == true)
		{
			rate2_value = filterNum(document.getElementById("txt_rate2_"+t).value,'<cfoutput>#session.ep.our_company_info.rate_round_num#</cfoutput>')/filterNum(document.getElementById("txt_rate1_"+t).value,'<cfoutput>#session.ep.our_company_info.rate_round_num#</cfoutput>');
			document.getElementById("com_other").value = commaSplit(filterNum(document.getElementById("com_ytl").value,'<cfoutput>#session.ep.our_company_info.rate_round_num#</cfoutput>')/rate2_value,'<cfoutput>#session.ep.our_company_info.rate_round_num#</cfoutput>');
			document.getElementById("com_ytl").value = commaSplit(filterNum(document.getElementById("com_ytl").value,'<cfoutput>#session.ep.our_company_info.rate_round_num#</cfoutput>'),'<cfoutput>#session.ep.our_company_info.rate_round_num#</cfoutput>');
			document.getElementById("total_income_other").value = commaSplit(filterNum(document.getElementById("total_income").value,'<cfoutput>#session.ep.our_company_info.rate_round_num#</cfoutput>')/rate2_value,'<cfoutput>#session.ep.our_company_info.rate_round_num#</cfoutput>');
			document.getElementById("total_income").value = commaSplit(filterNum(document.getElementById("total_income").value,'<cfoutput>#session.ep.our_company_info.rate_round_num#</cfoutput>'),'<cfoutput>#session.ep.our_company_info.rate_round_num#</cfoutput>');
		}
	}
}
function kontrol()
{	
	if(!$("#action_date").val().length)
	{
		alertObject({message: "<cfoutput><cf_get_lang dictionary_id ='58503.Tarih Girmelisiniz '></cfoutput>"})    
		return false;
    }
    if(!paper_control(add_bond.paper_no,'SECURITIES_SALE','','','','','','','<cfoutput>#dsn3#</cfoutput>')) return false;
	var record_exist=0;
	if (!chk_process_cat('add_bond')) return false;
	if (!check_display_files('add_bond')) return false;
	if(document.getElementById("comp_name").value == "" && document.getElementById("account_id").value == "")			
	{
		alert("<cf_get_lang dictionary_id='57320.Cari ya da Banka Seçeneklerinden En Az Birini Seçmelisiniz'>");
		return false;
	}
	if(document.getElementById("comp_name").value != "" && document.getElementById("account_id").value != "")			
	{
		alert("<cf_get_lang dictionary_id='57317.Cari ve Banka Birlikte Seçilemez'>");
		return false;
	}
	if(document.getElementById("expense_center_id").value=="")
    {
        alert("<cf_get_lang dictionary_id='48225.Masraf Merkezi Girmelisiniz'>!");
        return false;
    }
    if(document.getElementById("expense_item_id").value=="")
    {
        alert("<cf_get_lang dictionary_id='49131.Bütçe Kalemi Girmelisiniz'>");
        return false;
    }
    if(document.getElementById("acc_id").value=="")
    {
        alert("<cf_get_lang dictionary_id='57316.Muhasebe Kodu Giriniz'>!");
        return false;
    }
    if(document.getElementById("total_income_exp_center_id").value=="")
    {
        alert("<cf_get_lang dictionary_id='48225.Masraf Merkezi Girmelisiniz'>!");
        return false;
    }
    if(document.getElementById("total_income_exp_item_id").value=="")
    {
        alert("<cf_get_lang dictionary_id='49131.Bütçe Kalemi Girmelisiniz'>");
        return false;
    }
    if(document.getElementById("total_income_acc_id").value=="")
    {
        alert("<cf_get_lang dictionary_id='57316.Muhasebe Kodu Giriniz'>!");
        return false;
    }
    var list = "";

    if( document.getElementById("record_num").value > 0 ){
        for(r = 1; r <= document.getElementById("record_num").value; r++){
            if( typeof( document.getElementById("row_kontrol"+r) ) != "undefined" && document.getElementById("row_kontrol"+r) != null && document.getElementById("row_kontrol"+r).value == 1 )
            {
                record_exist = 1;
                if (document.getElementById("row_detail"+r).value == "")
                { 
                    alert ("<cf_get_lang dictionary_id ='51432.Lütfen Açıklama Giriniz'>!");
                    return false;
                }
                if ((document.getElementById("nominal_value"+r).value == "")||(document.getElementById("nominal_value"+r).value ==0))
                { 
                    alert ("<cf_get_lang dictionary_id ='51433.Lütfen Nominal Değer Giriniz'>!");
                    return false;
                }
                if ((document.getElementById("sale_value"+r).value == "")||(document.getElementById("sale_value"+r).value ==0))
                { 
                    alert ("<cf_get_lang dictionary_id ='51439.Lütfen Satış Değeri Giriniz'>!");
                    return false;
                }
                if (document.getElementById("quantity"+r).value != '')
                {
                    var listParam =document.getElementById("stockbond_id"+r).value+"*"+document.getElementById("stockbond_row_id"+r).value;
                    var get_quantity = wrk_safe_query('get_stockbond_quantity','dsn3',0,listParam); 
                    
                    if(parseFloat(document.getElementById("quantity"+r).value) > parseFloat(get_quantity.NET_QUANTITY))
                    {
                        var list = list+'\n'+document.getElementById("bond_code"+r).value+'-'+document.getElementById("row_detail"+r).value;
                    }					
                }
            }
        }
    }else{
        alert("<cf_get_lang dictionary_id ='51435.Lütfen Satır Giriniz'>!");
        return false;
    }
    
	if(list != '')
	{
		alert("<cf_get_lang dictionary_id='57300.Aşağıdaki Menkul Kıymetlerin Satış Miktarları Alış Miktarlarından Fazladır'>. <cf_get_lang dictionary_id='48547.Lütfen Kontrol Ediniz'>!" +list+"")				
		return false;
	}	
	if (record_exist == 0) 
	{
		alert("<cf_get_lang dictionary_id ='51435.Lütfen Satır Giriniz'>!");
		return false;
	}
	return unformat_fields();
}
function unformat_fields()
{
	for(rm=1;rm<=document.getElementById("record_num").value;rm++)
	{
        if( typeof( document.getElementById("row_kontrol"+rm) ) != "undefined" && document.getElementById("row_kontrol"+rm) != null && document.getElementById("row_kontrol"+rm).value == 1){
            document.getElementById("nominal_value"+rm).value =  filterNum(document.getElementById("nominal_value"+rm).value,'<cfoutput>#session.ep.our_company_info.rate_round_num#</cfoutput>');
            document.getElementById("sale_value"+rm).value =  filterNum(document.getElementById("sale_value"+rm).value,'<cfoutput>#session.ep.our_company_info.rate_round_num#</cfoutput>');
            document.getElementById("total_sale"+rm).value =  filterNum(document.getElementById("total_sale"+rm).value,'<cfoutput>#session.ep.our_company_info.rate_round_num#</cfoutput>');
            document.getElementById("other_nominal_value"+rm).value =  filterNum(document.getElementById("other_nominal_value"+rm).value,'<cfoutput>#session.ep.our_company_info.rate_round_num#</cfoutput>');
            document.getElementById("other_sale_value"+rm).value =  filterNum(document.getElementById("other_sale_value"+rm).value,'<cfoutput>#session.ep.our_company_info.rate_round_num#</cfoutput>');
            document.getElementById("quantity"+rm).value =  filterNum(document.getElementById("quantity"+rm).value,'4');
            document.getElementById("other_total_sale"+rm).value =  filterNum(document.getElementById("other_total_sale"+rm).value,'<cfoutput>#session.ep.our_company_info.rate_round_num#</cfoutput>');
        }
	}

	document.getElementById("action_value").value = filterNum(document.getElementById("action_value").value,'<cfoutput>#session.ep.our_company_info.rate_round_num#</cfoutput>');
	document.getElementById("sale_other").value = filterNum(document.getElementById("sale_other").value,'<cfoutput>#session.ep.our_company_info.rate_round_num#</cfoutput>');
	document.getElementById("com_rate").value = filterNum(document.getElementById("com_rate").value,'<cfoutput>#session.ep.our_company_info.rate_round_num#</cfoutput>');
	document.getElementById("com_ytl").value = filterNum(document.getElementById("com_ytl").value,'<cfoutput>#session.ep.our_company_info.rate_round_num#</cfoutput>');
	document.getElementById("com_other").value = filterNum(document.getElementById("com_other").value,'<cfoutput>#session.ep.our_company_info.rate_round_num#</cfoutput>');
	document.getElementById("total_income").value = filterNum(document.getElementById("total_income").value,'<cfoutput>#session.ep.our_company_info.rate_round_num#</cfoutput>');
	document.getElementById("total_income_other").value = filterNum(document.getElementById("total_income_other").value,'<cfoutput>#session.ep.our_company_info.rate_round_num#</cfoutput>');
	document.getElementById("nominal_total_amount").value = filterNum(document.getElementById("nominal_total_amount").value,'<cfoutput>#session.ep.our_company_info.rate_round_num#</cfoutput>');
	document.getElementById("other_nominal_total_amount").value = filterNum(document.getElementById("other_nominal_total_amount").value,'<cfoutput>#session.ep.our_company_info.rate_round_num#</cfoutput>');
	for(st=1;st<=document.getElementById("kur_say").value;st++)
	{
        document.getElementById("txt_rate2_"+st).value = filterNum(document.getElementById("txt_rate2_"+ st).value,'<cfoutput>#session.ep.our_company_info.rate_round_num#</cfoutput>');
        document.getElementById("txt_rate1_"+st).value = filterNum(document.getElementById("txt_rate1_"+ st).value,'<cfoutput>#session.ep.our_company_info.rate_round_num#</cfoutput>');
	}
}
function f_add_bond()
{
	windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_stockbonds&field_id=add_bond.stockbond_id','wide');
}

    $(function(){
        var count = 0;
       	$('.collapse').click(function(){
            
            if(count == 0){
                $(this).parent().parent().find('.totalBoxBody').slideUp();
                $(this).find("span").removeClass().addClass("icon-pluss");
                count++;
            }
            else{
                $(this).parent().parent().find('.totalBoxBody').slideDown();
                $(this).find("span").removeClass().addClass("icon-minus");
                count = 0;
            }
       });
    })
</script>