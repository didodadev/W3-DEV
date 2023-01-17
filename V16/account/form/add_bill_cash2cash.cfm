<cf_xml_page_edit fuseact="account.form_add_bill_cash2cash">
    <cfparam name="attributes.special_code" default="0">
    <cfparam name="attributes.action_date" default="">
    <cfif isdefined('attributes.card_id') and attributes.event is 'copy'>
        <cfinclude template="../query/get_acc_card.cfm">
        <cfif not get_account_card.recordcount>
            <br /><font class="txtbold"><cf_get_lang_main no='1531.Böyle Bir Kayıt Bulunamamaktadır'> !</font>
            <cfexit method="exittemplate">
        </cfif>
        <cfquery name="GET_ACCOUNT_ROWS_MAIN" dbtype="query">
            SELECT * FROM GET_ACCOUNT_ROWS_MAIN_ALL
        </cfquery>
        <cfinclude template="../query/get_acc_process_type_info.cfm"><!--- money bilgileri --->
        <cfquery name="get_money_bskt" datasource="#dsn2#"><!--- account money tablosunda kayit varsa --->
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
    <cfelse>
        <cfquery name="get_money_bskt" datasource="#dsn#">
            SELECT MONEY,RATE1,RATE2 FROM SETUP_MONEY WHERE COMPANY_ID = #session.ep.company_id# AND PERIOD_ID = #session.ep.period_id# AND MONEY_STATUS = 1 AND MONEY <> '#session.ep.money#'
        </cfquery>
    </cfif>
    
    <cfquery name="get_branchs" datasource="#dsn#">
        SELECT
            BRANCH_ID,BRANCH_NAME
        FROM
            BRANCH
        WHERE
            BRANCH_STATUS = <cfqueryparam cfsqltype="cf_sql_integer" value="1">
            AND COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#">
        <cfif session.ep.isBranchAuthorization>
            AND BRANCH_ID IN (SELECT BRANCH_ID FROM EMPLOYEE_POSITION_BRANCHES WHERE POSITION_CODE = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.position_code#">)
        </cfif>
        ORDER BY BRANCH_NAME
    </cfquery>
    <cfinclude template="../query/control_bill_no.cfm">
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
    
    <cf_catalystHeader>
    <cf_box>
        <cfform name="add_bill" method="post" action="#request.self#?fuseaction=account.emptypopup_add_bill_cash2cash">
            <input type="hidden" name="active_period" id="active_period" value="<cfoutput>#session.ep.period_id#</cfoutput>">
            <input type="hidden" name="kur_say" id="kur_say" value="<cfoutput>#get_money_bskt.recordcount#</cfoutput>">
            <input type="hidden" name="money_type" id="money_type" value="">
            <cf_box_elements>
                <div class="col col-3 col-md-6 col-sm-6 col-xs-12"  type="column" index="1" sort="true">
                    <div class="form-group" id="item-is_other_currency">
                        <div class="col col-4 col-md-4 col-sm-4 col-xs-12">
                            <input type="checkbox" name="is_other_currency" id="is_other_currency" value="1" onClick="other_money_action();" <cfif get_comp_info.is_other_money>disabled="disabled"</cfif> <cfif (isdefined('attributes.from_rate_valuation') and isdate(attributes.action_date)) or get_comp_info.is_other_money eq 1>checked</cfif>>
                            <label class="large"><cfoutput>#getLang('account',48)#</cfoutput></label>
                        </div>
                        <div class="col col-4 col-md-4 col-sm-4 col-xs-12">
                            <cfif session.ep.our_company_info.is_ifrs eq 1>
                                <input type="checkbox" name="is_ifrs" id="is_ifrs" value="1" onClick="ifrs_action();" checked>
                                <label><cfoutput>#getLang('main',718)#</cfoutput></label>
                            </cfif>
                        </div>
                        <div class="col col-4 col-md-4 col-sm-4 col-xs-12">
                            <cfif session.ep.our_company_info.is_ifrs eq 1>
                                <input type="checkbox" name="IS_ACCOUNT_CODE2" id="IS_ACCOUNT_CODE2" value="1" onClick="private_code_action();">
                                <label><cfoutput>#getLang('main',377)#</cfoutput></label>
                            </cfif>
                        </div>
                    </div>
                    <div class="form-group" id="item-process_date">
                        <div class="col col-4 col-xs-12">
                            <label><cfoutput>#getLang('main',330)#</cfoutput> *</label>
                        </div>
                        <div class="col col-8 col-xs-12">
                            <div class="input-group">
                                <cfif isdefined('attributes.from_rate_valuation') and isdate(attributes.action_date)>
                                    <cfset process_date=attributes.action_date>
                                <cfelse>
                                    <cfset process_date=''>
                                </cfif>
                                <cfsavecontent variable="message"><cf_get_lang_main no='59.Eksik Veri'>:<cf_get_lang_main no='330.Tarih'>!</cfsavecontent>
                                <cfinput type="text" name="process_date" maxlength="10" value="#process_date#" style="width:80px;" required="Yes" message="#message#" validate="#validate_style#" onblur="change_money_info('add_bill','process_date');">
                                <span class="input-group-addon"><cf_wrk_date_image date_field="process_date" call_function="change_money_info"></span>
                            </div>
                        </div>
                    </div>
                    <div class="form-group" id="item-process_cat">
                        <div class="col col-4 col-xs-12">
                            <label><cfoutput>#getLang('main',388)#</cfoutput> *</label>
                        </div>
                        <div class="col col-8 col-xs-12">
                            <cf_workcube_process_cat slct_width="180px;">
                        </div>
                    </div>
                    <div class="form-group" id="item-paper_no">
                        <div class="col col-4 col-xs-12">
                            <label><cfoutput>#getLang('main',468)#</cfoutput></label>
                        </div>
                        <div class="col col-8 col-xs-12">
                            <input type="text" name="paper_no" id="paper_no" value="" maxlength="25">
                        </div>
                    </div>
                    <div class="form-group" id="item-document_type">
                        <div class="col col-4 col-xs-12">
                            <label><cfoutput>#getLang('main',1121)#</cfoutput></label>
                        </div>
                        <div class="col col-8 col-xs-12">
                            <select name="document_type" id="document_type" style="width:180px;" onchange="display_duedate()">
                                <option value=""><cf_get_lang_main no='322.Seçiniz'></option>
                                <cfoutput query="get_account_card_document_types">
                                    <option value="#document_type_id#">#document_type#</option>
                                </cfoutput>
                            </select>
                        </div>
                    </div>
                </div>
                <div class="col col-3 col-md-6 col-sm-6 col-xs-12" type="column" index="2" sort="true">
                    <div class="form-group" id="item-member_name">
                        <div class="col col-4 col-md-4 col-sm-4 col-xs-12">
                            <label><cfoutput>#getLang('main',107)#</cfoutput></label>
                        </div>
                        <div class="col col-8 col-xs-12">
                            <div class="input-group">
                                <input type="hidden" name="member_type" id="member_type" value="">
                                <input type="hidden" name="member_id" id="member_id" value="">
                                <input type="text" name="member_name" id="member_name" value="">
                                <span class="input-group-addon btnPointer icon-ellipsis" onclick="openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_pars&is_form_submitted=1&field_member_name=add_bill.member_name&field_name=add_bill.member_name&field_type=add_bill.member_type&field_comp_id=add_bill.member_id&field_consumer=add_bill.member_id&select_list=2,3<cfif session.ep.isBranchAuthorization>&is_store_module=1</cfif>');" title="<cfoutput>#getLang('main',107)#</cfoutput>"></span>
                            </div>
                        </div>
                    </div> 
                    <div class="form-group" id="item-detail">
                        <div class="col col-4 col-md-4 col-sm-4 col-xs-12">
                            <label><cfoutput>#getLang('main',217)#</cfoutput></label>
                        </div>
                        <div class="col col-8 col-xs-12">
                            <textarea name="bill_detail" id="bill_detail" valign="top" maxlength="500" onkeyup="return ismaxlength(this);" onBlur="return ismaxlength(this);" style="width:125px;height:58px;"></textarea>
                        </div>
                    </div>
                    <cfif session.ep.isBranchAuthorization eq 0> 
                        <div class="form-group" id="item-branch">
                            <div class="col col-4 col-md-4 col-sm-4 col-xs-12">
                                <label><cfoutput>#getLang('main',41)#</cfoutput></label>
                            </div>
                            <div class="col col-8 col-xs-12">
                                <select name="acc_branch_id" id="acc_branch_id">
                                    <option value=""><cf_get_lang_main no='322.Seçiniz'></option>
                                    <cfoutput query="get_branchs">
                                        <option value="#branch_id#">#branch_name#</option>
                                    </cfoutput>
                                </select>
                            </div>
                        </div> 
                    </cfif>
                    <div class="form-group" id="item-payment_type">
                        <div class="col col-4 col-md-4 col-sm-4 col-xs-12">
                            <label><cfoutput>#getLang('main',2260)#</cfoutput></label>
                        </div>
                        <div class="col col-8 col-xs-12">
                            <select name="payment_type" id="payment_type" style="width:180px;">
                                <option value=""><cf_get_lang_main no='322.Seçiniz'></option>
                                <cfoutput query="get_account_card_payment_types">
                                    <option value="#payment_type_id#">#payment_type#</option>
                                </cfoutput>
                            </select>
                        </div>
                    </div>
                    <div class="form-group" id="td_due_date_input" style="display:none;">
                        <div class="col col-4 col-md-4 col-sm-4 col-xs-12">
                            <label><cfoutput>#getLang('main',469)#</cfoutput></label>
                        </div>
                        <div class="col col-8 col-xs-12">
                            <div class="input-group">
                                <cfinput type="text" name="due_date" maxlength="10" validate="#validate_style#" style="width:80px;" valign="top">
                                <span class="input-group-addon">
                                    <cf_wrk_date_image date_field="due_date" call_function="change_money_info">
                                </span>
                            </div>
                        </div>
                    </div> 
                </div>
                <cfif get_money_bskt.recordcount>
                    <div class="col col-2 col-md-6 col-sm-6 col-xs-12" type="column" index="3" sort="true">
                        <div class="col col-12 padding-left-5">
                            <label class="bold"><cf_get_lang_main no='265.Dövizler'></label>
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
                                                <input type="text" name="txt_rate2_#currentrow#" id="txt_rate2_#currentrow#" <cfif readonly_info>readonly</cfif> value="#TLFormat(rate2,session.ep.our_company_info.rate_round_num)#" style="width:70px;" class="box" onkeyup="return(FormatCurrency(this,event,#session.ep.our_company_info.rate_round_num#));" onBlur="if(parseFloat(filterNum(this.value,8))<=0) this.value=commaSplit(1);f_kur_hesapla_multi();hesapla();">
                                            </div>
                                        </div>
                                    </cfoutput>
                                </cfif>
                            </div>
                        </div>
                    </div>
                </cfif>
                <div class="col col-3 col-md-6 col-sm-6 col-xs-12 padding-top-15" type="column" index="4" sort="true">
                        <div class="form-group">
                            <div class="col col-4 col-md-4 col-sm-4 col-xs-12">
                                <label class="txtbold"><cf_get_lang_main no='175.Borç'></label>
                            </div>
                            <div class="col col-8 col-md-8 col-sm-8 col-xs-12 text-right">
                                <label nowrap="nowrap" id="td_debt_ust"></label>
                                <label width="30"></label>
                            </div>
                        </div>
                        <div class="form-group">
                            <div class="col col-4 col-md-4 col-sm-4 col-xs-12">
                                <label class="txtbold"><cf_get_lang_main no='176.Alacak'></label>
                            </div>
                            <div class="col col-8 col-md-8 col-sm-8 col-xs-12 text-right">
                                <label id="td_claim_ust"></label>
                                <label width="30"></label>
                            </div>
                        </div>
                        <div class="form-group">
                            <div class="col col-4 col-md-4 col-sm-4 col-xs-12">
                                <label class="txtbold"><cf_get_lang_main no='177.Bakiye'></label>
                            </div>
                            <div class="col col-8 col-md-8 col-sm-8 col-xs-12 text-right">
                                <label id="td_bakiye_ust"></label>
                                <label width="30" id="td_bakiye_ust_ba"></label>
                            </div>
                        </div>
                </div>
            </cf_box_elements>
            <cfinclude template="add_bill_frame_cash2cash.cfm">
            <div class="col col-12 col-md-12 col-sm-12 col-xs-12">
                <cf_box_footer>
                    <cf_workcube_buttons is_upd='0' add_function="kontrol()">
                </cf_box_footer>
            </div>
        </cfform>
    </cf_box>
    <script language="javascript">
        change_money_info('add_bill','process_date');
    </script>
    <script type="text/javascript">
        function display_duedate()
        {
            if(document.getElementById('document_type').value == -1 || document.getElementById('document_type').value == -3)
                document.getElementById('td_due_date_input').style.display = '';
            else
                document.getElementById('td_due_date_input').style.display = 'none';
        }
    </script>