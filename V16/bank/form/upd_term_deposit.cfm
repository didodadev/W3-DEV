<cf_get_lang_set module_name="bank">
    <cfset refmodule="#listgetat(attributes.fuseaction,1,'.')#">
    
    <cfset ACTION_DETAIL = createObject("component", "V16.bank.cfc.vadeliMevduat")>
    
    <cfset GET_ACTION_DETAIL = ACTION_DETAIL.GET_ACTION_DETAIL(id : attributes.id )>    
    <cfset GET_SCENARIO = ACTION_DETAIL.GET_SCENARIO()>
    <cfif not GET_ACTION_DETAIL.recordcount>
        <br/><font class="txtbold"><cf_get_lang_main no='1531.Böyle Bir Kayıt Bulunmamaktadır'> !</font>
        <cfexit method="exittemplate">
    </cfif>
    <cfquery name="get_row_detail" datasource="#dsn2#">
        SELECT
            IYP.YIELD_ID,
            IYP.BUDGET_PLAN_ID,
            IYPR.YIELD_ID,
            IYPR.YIELD_ROWS_ID,
            IYPR.BANK_ACTION_DATE,
            IYPR.AMOUNT
        FROM
            BANK_ACTIONS
            LEFT JOIN INTEREST_YIELD_PLAN AS IYP ON BANK_ACTIONS.ACTION_ID = IYP.BANK_ACTION_ID
            RIGHT JOIN INTEREST_YIELD_PLAN_ROWS AS IYPR ON IYPR.YIELD_ID = IYP.YIELD_ID 
        WHERE
            ACTION_ID = #ATTRIBUTES.ID# AND ACTION_TYPE_ID IN (2311)
    </cfquery>
    <cfquery name="GET_COST_WITH_EXPENSE_ROWS_ID" datasource="#dsn2#">
        SELECT * FROM EXPENSE_ITEMS_ROWS WHERE ACTION_ID = #URL.ID# AND EXPENSE_COST_TYPE = #get_action_detail.action_type_id#
    </cfquery>

    <cfsavecontent variable="right">
        <cf_get_workcube_related_acts period_id="#session.ep.period_id#" company_id="#session.ep.company_id#" asset_cat_id="-17" module_id='19' action_section='BANK_ACTION_ID' action_id='#attributes.id#'>
    </cfsavecontent>
    <cf_catalystHeader>
    <cf_box>
        <cfform name="upd_term_deposit" action="" method="post">
            <input type="hidden" name="ids" id="ids" value="<cfoutput>#attributes.id#,#attributes.id+1#</cfoutput>">
            <input type="hidden" name="id" id="id" value="<cfoutput>#attributes.id#</cfoutput>">
            <input type="hidden" name="ACTION_TYPE" id="ACTION_TYPE" value="<cfoutput>#UCase(getLang('credit',37))#</cfoutput>">
            <input type="hidden" name="active_period" id="active_period" value="<cfoutput>#session.ep.period_id#</cfoutput>">
            <cf_box_elements>
                <div class="col col-4 col-md-4 col-sm-6 col-xs-12" type="column" index="1" sort="true">
                    <div class="form-group" id="item-process_cat">
                        <label class="col col-4 col-xs-12"><cfoutput>#getLang('main',388)#</cfoutput>*</label>
                        <div class="col col-8 col-xs-12">
                            <cf_workcube_process_cat process_cat=#get_action_detail.process_cat# slct_width="285">
                        </div> 
                    </div>
                    <div class="form-group" id="item-surec">
                        <label class="col col-4 col-xs-12"><cf_get_lang_main no="1447.Süreç"></label>
                        <div class="col col-8 col-xs-12">
                            <cf_workcube_process is_upd='0' id="process_stage" select_value='#get_action_detail.process_stage#' is_detail='1'>
                        </div>
                    </div>
                    <div class="form-group" id="item-from_account_id">
                        <label class="col col-4 col-xs-12"><cfoutput>#getLang('bank',62)#</cfoutput>*</label>
                        <div class="col col-8 col-xs-12">
                            <cf_wrkBankAccounts fieldId='from_account_id' call_function='kur_ekle_f_hesapla' width='285' selected_value='#get_action_detail.action_from_account_id#' is_upd='1'>
                        </div> 
                    </div>
                    <div class="form-group" id="item-to_account_id">
                        <label class="col col-4 col-xs-12"><cfoutput>#getLang('bank',65)#</cfoutput>*</label>
                        <div class="col col-8 col-xs-12">
                            <cf_wrkBankAccounts fieldId='to_account_id' call_function='kur_ekle_f_hesapla;change_currency_info' width='285'  selected_value='#get_action_detail.action_to_account_id[get_action_detail.recordcount]#' is_upd='1' line_info='2'>
                        </div> 
                    </div>
                    <cfif session.ep.isBranchAuthorization eq 0>
                        <div class="form-group" id="item-branch_id_alacak">
                            <label class="col col-4 col-xs-12"><cfoutput>#getLang('main',2726)#​</cfoutput></label>
                            <div class="col col-8 col-xs-12">
                                <cf_wrkDepartmentBranch fieldId='branch_id_alacak' is_branch='1' width='150' is_default='1' is_deny_control='1' selected_value='#get_action_detail.from_branch_id#'>
                            </div> 
                        </div>
                    
                        <div class="form-group" id="item-branch_id_borc">
                            <label class="col col-4 col-xs-12"><cfoutput>#getLang('main',2727)#​</cfoutput></label>
                            <div class="col col-8 col-xs-12">
                                <cf_wrkDepartmentBranch fieldId='branch_id_borc' is_branch='1' width='150' is_default='1' is_deny_control='1' selected_value='#get_action_detail.to_branch_id[get_action_detail.recordcount]#'>
                            </div> 
                        </div>
                    </cfif>
                    <div class="form-group" id="item-project_id">
                        <label class="col col-4 col-xs-12"><cfoutput>#getLang('main',4)#</cfoutput></label>
                        <div class="col col-8 col-xs-12">
                            <div class="input-group">
                                    <cfoutput>
                                    <input type="hidden"  name="project_id" id="project_id" value="#get_action_detail.project_id#"/>
                                    <input type="text" style="width:150px" name="project_head" id="project_head" value="#get_action_detail.project_head#" onfocus="AutoComplete_Create('project_head','PROJECT_HEAD','PROJECT_HEAD','get_project','','PROJECT_ID','project_id','','3','148');" autocomplete="off" />
                                </cfoutput>
                                <span class="input-group-addon icon-ellipsis btnPointer" onClick="openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_projects&project_id=add_cash_to_cash.project_id&project_head=add_cash_to_cash.project_head');"></span>
                            </div>
                        </div> 
                    </div>
                    <div class="form-group" id="item-paper_number">
                        <label class="col col-4 col-xs-12"><cfoutput>#getLang('main',468)#</cfoutput></label>
                        <div class="col col-8 col-xs-12">
                            <cfinput type="text" name="paper_number" value="#get_action_detail.paper_no#" style="width:150px;">
                        </div> 
                    </div>
                    <div class="form-group" id="item-ACTION_DATE">
                        <label class="col col-4 col-xs-12"><cfoutput>#getLang('main',330)#</cfoutput>*</label>
                        <div class="col col-8 col-xs-12">
                            <div class="input-group">
                                <cfsavecontent variable="message"><cf_get_lang_main no='1091.Lutfen Tarih Giriniz !'></cfsavecontent>
                                <cfinput name="ACTION_DATE" type="text" value="#dateformat(get_action_detail.ACTION_DATE,dateformat_style)#" validate="#validate_style#" required="Yes" message="#message#" onchange="change_paper_duedate('ACTION_DATE',1);specialVisible('yield_payment_period');FaizHesapla('getiri_tutari');" onBlur="change_money_info('upd_term_deposit','ACTION_DATE');FaizHesapla('getiri_tutari');"> 
                                <span class="input-group-addon"><cf_wrk_date_image date_field="ACTION_DATE" call_function="change_money_info" control_date="#dateformat(get_action_detail.ACTION_DATE,dateformat_style)#"></span>
                            </div>
                        </div> 
                    </div>
                    <div class="form-group" id="item-ACTION_VALUE">
                        <label class="col col-4 col-xs-12"><cfoutput>#getLang('main',261)#</cfoutput>*</label>
                        <div class="col col-8 col-xs-12">
                            <cfsavecontent variable="message1"><cf_get_lang no='83.Miktar Giriniz!'></cfsavecontent>
                            <cfinput type="text" name="ACTION_VALUE" value="#TLFormat(get_action_detail.ACTION_VALUE-get_action_detail.MASRAF)#" required="yes" message="#message1#" class="moneybox" onBlur="kur_ekle_f_hesapla('from_account_id');FaizHesapla('getiri_tutari');" onkeyup="specialVisible('yield_payment_period');return(FormatCurrency(this,event));">
                        </div> 
                    </div>
                    <div class="form-group" id="item-OTHER_CASH_ACT_VALUE">
                        <label class="col col-4 col-xs-12"><cfoutput>#getLang('main',644)#</cfoutput></label>
                        <div class="col col-8 col-xs-12">
                            <cfinput type="text" name="OTHER_CASH_ACT_VALUE" value="#TLFormat(get_action_detail.OTHER_CASH_ACT_VALUE)#" class="moneybox" onBlur="kur_ekle_f_hesapla('from_account_id',true);" onkeyup="return(FormatCurrency(this,event));">
                        </div> 
                    </div>
                    <div class="form-group" id="item-due_value">
                        <label class="col col-4 col-xs-12"><cf_get_lang_main no='228.Vade'>*</label>
                        <div class="col col-4 col-xs-12">
                            <input type="number" name="due_value" id="due_value" value="<cfoutput>#get_action_detail.DUE_VALUE#</cfoutput>" onchange="change_paper_duedate('ACTION_DATE');specialVisible('yield_payment_period');FaizHesapla('getiri_tutari');">
                        </div>
                        <div class="col col-4 col-xs-12">
                            <div class="input-group">
                                <cfinput type="text" name="due_value_date" value="#dateformat(get_action_detail.DUE_VALUE_DATE,dateformat_style)#" onChange="change_paper_duedate('ACTION_DATE',1);specialVisible('yield_payment_period');FaizHesapla('getiri_tutari');" validate="#validate_style#" message="#message#" maxlength="10" readonly>
                                <span class="input-group-addon btnPointer"><cf_wrk_date_image date_field="due_value_date"></span>
                            </div>
                        </div>
                    </div>
                    <div class="form-group" id="item-getiri_orani">
                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id="51373.Getiri Oranı">- YGS *</label>
                        <div class="col col-4 col-xs-12">
                            <cfinput type="text" name="getiri_orani" class="moneybox" value="#TLFormat(get_action_detail.YIELD_RATE,4)#" onblur="hesapla('getiri_orani');FaizHesapla('getiri_orani');" onkeyup="return(FormatCurrency(this,event));">
                        </div>
                        <div class="col col-4 col-xs-12">
                            <cfinput type="number" name="ygs" class="moneybox" value="#iif(len(GET_ACTION_DETAIL.YGS),'get_action_detail.ygs',DE(365))#" onblur="hesapla('getiri_orani');" onkeyup="FaizHesapla('getiri_orani');return(FormatCurrency(this,event));">
                        </div> 
                    </div>
                    <div class="form-group" id="item-getiri_tutari">
                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id="51374.Getiri Tutarı"></label>
                        <div class="col col-8 col-xs-12">
                            <cfsavecontent variable="message1"><cf_get_lang no='83.Miktar Giriniz!'></cfsavecontent>
                            <cfinput type="text" name="getiri_tutari" value="#TLFormat(get_action_detail.YIELD_AMOUNT,2)#" required="yes" message="#message1#" class="moneybox" onkeyup="return(FormatCurrency(this,event));" onblur="FaizHesapla('getiri_tutari');">
                        </div> 
                    </div>
                    <div class="form-group" id="item-show-payment-row">
                        <label class="col col-4 col-xs-12"></label>
                        <div class="col col-8">
                            <button class="btn btn-sm widFull" onclick="CreatePaymentRow();ToggleRow();return false;"><cf_get_lang dictionary_id='34276.Getiri Tablosunu Göster'> / <cf_get_lang dictionary_id='58628'></button>
                        </div>
                    </div>
                </div>
                <div class="col col-4 col-md-4 col-sm-4 col-xs-12" type="column" index="2" sort="true">
                    <div class="form-group" id="item-getiri_tahsil_sayisi" style="display:none;">
                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='34271.Getiri Tahsil Sayısı'> *</label>
                        <div class="col col-8 col-xs-12">
                            <cfinput type="number" name="getiri_tahsil_sayisi" value="#get_action_detail.NUMBER_YIELD_COLLECTION#" readonly>
                        </div> 
                    </div>
                    <div class="form-group" id="item-getiri_tahsil_tutari" style="display:none;"> 
                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='34240.Getiri Tahsil Tutarı'> *</label>
                        <div class="col col-8 col-xs-12">
                            <cfinput type="text" name="getiri_tahsil_tutari" value="#TLFormat(get_action_detail.YIELD_COLLECTION_AMOUNT,2)#" class="moneybox"  onkeyup="return(FormatCurrency(this,event));" readonly>
                        </div> 
                    </div>
                    <div class="form-group" id="item-finansal_senaryo">
                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='43503.Finansal'> <cf_get_lang dictionary_id='54557.Senaryo Tipi'></label>
                        <div class="col col-8 col-xs-12">
                            <select name="finansal_senaryo" id="finansal_senaryo">
                                <option value=""><cf_get_lang_main no='1281.Seç'></option>
                                <cfoutput query="GET_SCENARIO">
                                    <option value="#SCENARIO_ID#" <cfif get_action_detail.FINANCIAL_SCENARIO_ID EQ SCENARIO_ID>selected</cfif>>#SCENARIO#</option>
                                </cfoutput>
                            </select>
                        </div>
                    </div>
                    <div class="form-group" id="item-ACTION_DETAIL">
                        <label class="col col-4 col-xs-12"><cfoutput>#getLang('main',217)#</cfoutput></label>
                        <div class="col col-8 col-xs-12">
                            <textarea name="ACTION_DETAIL" id="ACTION_DETAIL" style="width:150px;height:50px;"><cfoutput>#get_action_detail.ACTION_DETAIL#</cfoutput></textarea>
                        </div> 
                    </div>
                    <div class="form-group" id="item-expense_item_tahakkuk_id">
                        <label class="col col-4 col-xs-12"><cfoutput>#getLang('main',822)#</cfoutput> <cf_get_lang dictionary_id='34760.Tahakkuk'> *</label>
                        <div class="col col-8 col-xs-12">
                            <cf_wrkExpenseItem width_info="150" fieldId="expense_item_tahakkuk_id" fieldName="expense_item_tahakkuk_name" form_name="upd_term_deposit" income_type_info="0" expense_item_id="#GET_ACTION_DETAIL.expense_item_tahakkuk_id#" img_info="plus_thin">
                        </div> 
                    </div>
                    <div class="form-group" id="item-expense_item_id">
                        <label class="col col-4 col-xs-12"><cfoutput>#getLang('main',822)#</cfoutput> <cf_get_lang dictionary_id='57845.Tahsilat'> * </label>
                        <div class="col col-8 col-xs-12">
                            <cf_wrkExpenseItem width_info="150" fieldId="expense_item_id" fieldName="expense_item_name" form_name="upd_term_deposit" income_type_info="1" expense_item_id="#GET_ACTION_DETAIL.expense_item_id#" img_info="plus_thin">
                        </div> 
                    </div>
                    <div class="form-group" id="item-masraf_baslik">
                        <label class="col col-12 bold"><cfoutput>#getLang('main',1518)#​</cfoutput></label>
                    </div>
                    <div class="form-group" id="item-masraf">
                        <label class="col col-4 col-xs-12"><cfoutput>#getLang('main',261)#</cfoutput></label>
                        <div class="col col-8 col-xs-12">
                            <cfif get_action_detail.MASRAF gt 0>
                                <cfinput type="text" name="masraf" class="moneybox" style="width:150px;" value="#TLFormat(get_action_detail.MASRAF)#" onkeyup="return(FormatCurrency(this,event));">
                            <cfelse>
                                <cfinput type="text" name="masraf" class="moneybox" style="width:150px;" value="" onkeyup="return(FormatCurrency(this,event));">
                            </cfif>
                        </div> 
                    </div>
                    <div class="form-group" id="item-expense_center_id"> 
                        <label class="col col-4 col-xs-12"><cfoutput>#getLang('main',1048)#</cfoutput></label>
                        <div class="col col-8 col-xs-12">
                            <cf_wrkExpenseCenter width_info="150" fieldId="expense_center_id" fieldName="expense_center_name" form_name="upd_term_deposit" expense_center_id="#GET_ACTION_DETAIL.expense_center_id#" img_info="plus_thin">
                        </div> 
                    </div>
                    <div class="form-group" id="item-expense_item_masraf_id">
                        <label class="col col-4 col-xs-12"><cfoutput>#getLang('main',822)#</cfoutput></label>
                        <div class="col col-8 col-xs-12">
                            <cf_wrkExpenseItem width_info="150" fieldId="expense_item_masraf_id" fieldName="expense_item_masraf_name" form_name="upd_term_deposit" income_type_info="0" expense_item_id="#get_cost_with_expense_rows_id.expense_item_id#" img_info="plus_thin">
                        </div> 
                    </div>
                </div>
                <div class="col col-4 col-md-4 col-sm-4 col-xs-12" type="column" index="3" sort="false">
                    <div class="form-group" id="item-kur-ekle">
                        <div class="col col-12">
                            <label class="bold"><cf_get_lang no='53.İşlem Para Br'></label>
                            <cfscript>f_kur_ekle(action_id:URL.ID,process_type:1,base_value:'ACTION_VALUE',other_money_value:'OTHER_CASH_ACT_VALUE',form_name:'upd_term_deposit',action_table_name:'BANK_ACTION_MONEY',action_table_dsn:'#dsn2#',select_input:'from_account_id',is_disable='1');</cfscript>
                        </div>
                    </div>
                </div>
                <div class="col col-12 col-md-12 col-sm-12 col-xs-12">
                    <cfsavecontent variable="msg"><cf_get_lang dictionary_id='33153.Periyodik'> <cf_get_lang dictionary_id='51378.Getiri Tablosu'></cfsavecontent>
                    <div id="div_getiri_tablosu">
                        <cf_seperator id="getiri_tablosu" header="#msg#">
                        <div class="col col-6 col-md-5 col-sm- col-xs-12" id="getiri_tablosu" type="column" index="4" sort="true">
                            <div class="row" style="margin-left:3.5px;">
                                <div class="col col-12">
                                    <div class="form-group col col-12" id="item-odeme_periyodu">
                                        <div class="col col-1"></div>
                                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='51376.Getiri Ödeme Periyodu'></label>
                                        <div class="col col-4 col-xs-12">
                                            <select name="yield_payment_period" id="yield_payment_period" onchange="specialVisible(this.value);CreatePaymentRow();">
                                                <option value=""><cf_get_lang_main no='1281.Seç'></option>
                                                <option value="1" <cfif get_action_detail.YIELD_PAYMENT_PERIOD eq 1> selected </cfif>><cf_get_lang_main no='1312.Ay'></option>
                                                <option value="2" <cfif get_action_detail.YIELD_PAYMENT_PERIOD eq 2> selected </cfif>>3 <cf_get_lang_main no='1312.Ay'></option>
                                                <option value="3" <cfif get_action_detail.YIELD_PAYMENT_PERIOD eq 3> selected </cfif>>6 <cf_get_lang_main no='1312.Ay'></option>
                                                <option value="4" <cfif get_action_detail.YIELD_PAYMENT_PERIOD eq 4> selected </cfif>><cf_get_lang_main no='1043.Yıl'></option>
                                                <option value="5" <cfif get_action_detail.YIELD_PAYMENT_PERIOD eq 5> selected </cfif>><cf_get_lang_main no='567.Özel'></option>
                                                <option value="6" <cfif get_action_detail.YIELD_PAYMENT_PERIOD eq 6> selected </cfif>><cf_get_lang dictionary_id='33558.Vade Sonu'></option>
                                            </select>
                                        </div>
                                    </div>
                                    <div class="form-group col col-4" id="item-special_day" <cfif get_action_detail.YIELD_PAYMENT_PERIOD neq 5> style="display:none" </cfif>>
                                        <label class="col col-12 col-xs-12"><cf_get_lang_main no='78.Day'></label>
                                        <div class="col col-8 col-xs-12">
                                            <cfinput type="number" name="special_day" value="#get_action_detail.SPECIAL_DAY#" onblur="specialVisible('5');CreatePaymentRow();">
                                        </div> 
                                    </div>
                                </div>
                            </div>
                            <div class="row">
                                <div class="col col-12 col-md-12 col-sm-12 col-xs-12" id="getiri_tablosu_head">
                                    <label class="col col-1 bold"><cf_get_lang dictionary_id='58577.Sıra'></label>
                                    <label class="col col-4 bold"><cf_get_lang no ='236.Hesaba Geçiş Tarihi'></label>
                                    <label class="col col-4 bold"><cf_get_lang dictionary_id='51374.Getiri Tutarı'></label>
                                </div>
                            </div>
                            <div id="createRow">
                                <cfloop from="1" to="#get_action_detail.NUMBER_YIELD_COLLECTION#" index="i">
                                    <div class="col col-12 col-xs-12" id="getiri_tablosu_row<cfoutput>#i#</cfoutput>">
                                        <label class="bold col col-1"><cfoutput>#i#</cfoutput></label>
                                        <div class="col col-4 col-xs-12">
                                            <div class="form-group">
                                                <div class="input-group">
                                                    <cfsavecontent variable="message"><cf_get_lang_main no='1091.Lutfen Tarih Giriniz !'></cfsavecontent>
                                                    <cfinput name="bnk_action_date#i#" type="text" value="#dateformat(get_row_detail.BANK_ACTION_DATE[i],dateformat_style)#" validate="#validate_style#" required="Yes" message="#message#"> 
                                                    <span class="input-group-addon"><cf_wrk_date_image date_field="bnk_action_date#i#"></span>
                                                </div>
                                            </div>
                                        </div> 
                                        <div class="col col-4 col-xs-12">
                                            <div class="form-group">
                                                <cfsavecontent variable="message1"><cf_get_lang no='83.Miktar Giriniz!'></cfsavecontent>
                                                <cfinput type="text" name="getiri_tutari_row#i#" value="#TLFormat(get_row_detail.AMOUNT[i],2)#" required="yes" message="#message1#" class="moneybox" onkeyup="return(FormatCurrency(this,event));">
                                            </div>
                                        </div> 
                                    </div>    
                                </cfloop>
                            </div>
                        </div>
                    </div>
                </div>
            </cf_box_elements>
            <cf_box_footer>
                <cf_record_info query_name="get_action_detail">
                <cfset url_link="">
                <cf_workcube_buttons 
                    is_upd='1'
                    delete_page_url='#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.form_add_term_deposit&event=del&ids=#attributes.id#,#attributes.id+1#&head=#get_action_detail.paper_no#&old_process_type=#get_action_detail.action_type_id##url_link#'
                    add_function='kontrol()'>
            </cf_box_footer>
        </cfform>
    </cf_box>
    <script type="text/javascript">
        function ToggleRow(){
            $("div#div_getiri_tablosu").toggle();
        }
        function CreatePaymentRow(){
           
            var getiri_tahsil_sayisi = $("#getiri_tahsil_sayisi").val();
            var getiri_tahsil_tutari = filterNum($("#getiri_tahsil_tutari").val());
            var yield_payment_period = $("select#yield_payment_period").val();
            var due_value = parseInt($("#due_value").val());
            var special_day = parseInt($("#special_day").val());
            var action_date = $("input#ACTION_DATE").val();

            //var datePeriod = "<cfoutput>#dateformat(get_row_detail.BANK_ACTION_DATE,dateformat_style)#</cfoutput>";
            

            if(yield_payment_period == 1){
                bank_action_date = date_add("m",1,action_date);
                
            }else if(yield_payment_period == 2){
                bank_action_date = date_add("m",3,action_date)
            }else if(yield_payment_period == 3){
                bank_action_date = date_add("m",6,action_date)
            }else if(yield_payment_period == 4){
                bank_action_date = date_add("y",1,action_date)
            }else if(yield_payment_period == 5){
                bank_action_date = date_add("d",special_day,action_date)
            }else if(yield_payment_period == 6){
                bank_action_date = date_add("d", due_value ,action_date);
            }
            $("#createRow").html("");
            
            for(i=1; i <= getiri_tahsil_sayisi; i++){
                $("<div>").addClass("col col-12 col-xs-12").attr({
                    id : "getiri_tablosu_row"
                }).append(
                    $("<label>").addClass("bold col col-1").text(i),
                        $("<div>").addClass("col col-4 col-xs-12").append(
                            $("<div>").addClass("form-group").append(
                                $("<div>").addClass("input-group").attr({ id : "bnk_action_date"+i+"_td" }).append(
                                    $("<input>").attr({
                                        name : "bnk_action_date"+i,
                                        id : "bnk_action_date"+i,
                                        type : "text",
                                        value : bank_action_date
                                    })
                                )
                            )
                        ),
                        $("<div>").addClass("col col-4 col-xs-12").append(
                            $("<div>").addClass("form-group").append(
                                $("<input>").attr({
                                    name : "getiri_tutari_row"+i,
                                    id : "getiri_tutari_row"+i,
                                    onkeyup : "LastTotal();return(FormatCurrency(this,event))",
                                    value : commaSplit(getiri_tahsil_tutari,2)
                                }).addClass("moneybox")
                            )
                        )
                ).appendTo($("#createRow"));
                wrk_date_image('bnk_action_date'+i+'','',1);

                if(yield_payment_period == 1){
                    bank_action_date = date_add("m",1,bank_action_date)
                }else if(yield_payment_period == 2){
                    bank_action_date = date_add("m",3,bank_action_date)
                }else if(yield_payment_period == 3){
                    bank_action_date = date_add("m",6,bank_action_date)
                }else if(yield_payment_period == 4){
                    bank_action_date = date_add("y",1,bank_action_date)
                }else if(yield_payment_period == 5){
                    bank_action_date = date_add("d",special_day,bank_action_date)
                }else if(yield_payment_period == 6){
                    bank_action_date = date_add("d", due_value ,bank_action_date)
                }
            }
            LastTotal();
        }

        function LastTotal(){
            var getiri_tahsil_sayisi = $("#getiri_tahsil_sayisi").val();
            var lastTotal = 0;
            for(i=1; i <= getiri_tahsil_sayisi; i++){
                lastTotal += parseFloat(filterNum($("#getiri_tutari_row"+i).val()))
            }
            var rowTotal = lastTotal;
            var paymentTotal = filterNum($("#getiri_tutari").val());
            var ret = paymentTotal - rowTotal;
            console.log(paymentTotal + " " +ret);
            (ret < 0) ? $("#getiri_tutari_row"+getiri_tahsil_sayisi).val( commaSplit(filterNum($("#getiri_tutari_row"+getiri_tahsil_sayisi).val()) - Math.abs(ret)) ) : $("#getiri_tutari_row"+getiri_tahsil_sayisi).val( commaSplit(filterNum($("#getiri_tutari_row"+getiri_tahsil_sayisi).val()) + Math.abs(ret)) );

            //$("#getiri_tutari").val( commaSplit(lastTotal,2));
        }

        function change_currency_info()
        {
            new_kur_say = document.all.kur_say.value;
            for(var i=1;i<=new_kur_say;i++)
            {
                if(eval('document.all.hidden_rd_money_'+i) != undefined && eval('document.all.hidden_rd_money_'+i).value == document.getElementById('currency_id2').value)
                    eval('document.all.rd_money['+(i-1)+']').checked = true;
            }
            kur_ekle_f_hesapla('from_account_id');
        }

        function kontrol()
        {
            control_account_process(<cfoutput>'#attributes.id#','#get_action_detail.action_type_id#'</cfoutput>);
            if(!chk_period(document.upd_term_deposit.ACTION_DATE, 'İşlem')) return false;
            if(!chk_process_cat('upd_term_deposit')) return false;
            if(!check_display_files('upd_term_deposit')) return false;
            kur_ekle_f_hesapla('from_account_id');//dövizli tutarı silinenler için
            if(document.upd_term_deposit.from_account_id.value == document.upd_term_deposit.to_account_id.value)				
            {
                alert("<cf_get_lang no='94.Seçtiğiniz Banka Hesapları Aynı !'>");		
                return false; 
            }
    
            if(document.getElementById('ACTION_VALUE').value == '0,00')
            {
                alert("<cf_get_lang_main no='261.Tutar Girmelisiniz!'> Girmelisiniz!");
                return false;
            }
            if( $("#expense_center_id").val() == '' && $("#expense_center_name").val() == ''){
                alert("<cf_get_lang dictionary_id='48881.Masraf Merkezi Seçiniz'>!");
                return false;
            }
            if(document.getElementById('expense_item_tahakkuk_id').value == "")
            {
                alert("<cf_get_lang dictionary_id='49131.Bütçe Kalemi Girmelisiniz!'>");
                return false;
            }
            if(document.getElementById('expense_item_id').value == "")
            {
                alert("<cf_get_lang dictionary_id='49131.Bütçe Kalemi Girmelisiniz!'> <cf_get_lang dictionary_id='57845.Tahsilat'>");
                return false;
            }
            if(document.getElementById('getiri_orani').value == "")
            {
                alert("<cf_get_lang dictionary_id='33550.Getiri Oranı Girmelisiniz'>");
                return false;
            }
            if(document.getElementById('due_value').value == "")
            {
                alert("<cf_get_lang dictionary_id='49746.Vade Girmelisiniz'>");
                return false;
            }
            if(document.upd_term_deposit.yield_payment_period.value == ""){
                alert("<cf_get_lang dictionary_id='33551.Ödeme Periyodu Girmelisiniz'>");
                return false;
            }
    
            inp_getiri_orani = $("#getiri_orani");
            inp_getiri_tutari = $("#getiri_tutari");
            input_getiri_tahsil_tutari = $("#getiri_tahsil_tutari");
            for(var i=1;i<=document.upd_term_deposit.getiri_tahsil_sayisi.value;i++)
                {
                    inp_getiri_tahsil_tutari = $("input[name=getiri_tutari_row"+i+"]");
                    inp_getiri_tahsil_tutari.val( filterNum( inp_getiri_tahsil_tutari.val(),'<cfoutput>#session.ep.our_company_info.rate_round_num#</cfoutput>'));
                }

            inp_getiri_orani.val( filterNum( inp_getiri_orani.val(),'<cfoutput>#session.ep.our_company_info.rate_round_num#</cfoutput>'));
            inp_getiri_tutari.val( filterNum( inp_getiri_tutari.val(),'<cfoutput>#session.ep.our_company_info.rate_round_num#</cfoutput>'));
            input_getiri_tahsil_tutari.val( filterNum( input_getiri_tahsil_tutari.val(),'<cfoutput>#session.ep.our_company_info.rate_round_num#</cfoutput>'));
            return true;
        }
        function change_paper_duedate(field_name,type,is_row_parse) 
        {
            paper_date_=eval('document.upd_term_deposit.ACTION_DATE.value');
            if(type!=undefined && type==1)
                document.getElementById('due_value').value = datediff(paper_date_,document.getElementById('due_value_date').value,0);
            else
            {
                if(isNumber(document.getElementById('due_value'))!= false && (document.getElementById('due_value').value != 0))
                    document.getElementById('due_value_date').value = date_add('d',+document.getElementById('due_value').value,paper_date_);
                else
                {
                    document.getElementById('due_value_date').value = paper_date_;
                    if(document.getElementById('due_value').value == '')
                        document.getElementById('due_value').value = datediff(paper_date_,document.getElementById('due_value_date').value,0);
                }
            }
        }
        function kur_ekle_f_hesapla(select_input,doviz_tutar)
        {
            var process_cat_ = document.getElementById('process_cat').options[document.getElementById('process_cat').selectedIndex].value;
            var IS_PROCESS_CURRENCY = '';
    
            var rate_round_num = <cfoutput>#session.ep.our_company_info.rate_round_num#</cfoutput>;
            
            if(process_cat_ != '')
            {
                url_= '/V16/settings/cfc/processCat.cfc?method=getProcessCat';
                $.ajax({                                                                                             
                    url: url_,
                    dataType: "text",
                    data: {process_cat: process_cat_},
                    cache: false,
                    async: false,
                    success: function(read_data) {
                        data_ = jQuery.parseJSON(read_data.replace('//',''));
                        if(data_.DATA.length != 0)
                        {
                            $.each(data_.DATA,function(i){
                                IS_PROCESS_CURRENCY = data_.DATA[i][0];
                            });
                        }
                    }
                });
            }
            
            if(IS_PROCESS_CURRENCY != true)
            {
                
                if(!doviz_tutar) doviz_tutar=false;
                if(document.getElementById(select_input) == undefined || document.getElementById(select_input).value == '') return false;//eğerki kasada seçilecek hesap var ise....
                if(document.getElementById('currency_id') != undefined)
                    var currency_type = document.getElementById('currency_id').value;
                else
                    var currency_type = eval('document.upd_term_deposit.'+select_input+'.options[document.upd_term_deposit.'+select_input+'.selectedIndex]').value;
                
                var other_money_value_eleman= eval('document.upd_term_deposit.OTHER_CASH_ACT_VALUE');
                var temp_act,temp_base_act,rate1_eleman,rate2_eleman;
                if(doviz_tutar && ( other_money_value_eleman.value.length==0 || filterNum(other_money_value_eleman.value)==0) )
                {
                    other_money_value_eleman.value = '';
                    return false;
                }
                if(!doviz_tutar && eval('document.upd_term_deposit.ACTION_VALUE.value') != "" && currency_type != "")
                {
                    if(document.getElementById('currency_id') != undefined)
                        currency_type = document.getElementById('currency_id').value;
                    else
                        currency_type = list_getat(currency_type,2,';');
                    for(var i=1;i<=document.upd_term_deposit.kur_say.value;i++)
                    {
                        rate1_eleman = filterNum(eval('document.upd_term_deposit.txt_rate1_' + i).value,rate_round_num);
                        rate2_eleman = filterNum(eval('document.upd_term_deposit.txt_rate2_' + i).value,rate_round_num);
                        if( eval('document.upd_term_deposit.hidden_rd_money_'+i).value == currency_type)
                        {
                            temp_act=filterNum(document.upd_term_deposit.ACTION_VALUE.value)*rate2_eleman/rate1_eleman;
                            document.upd_term_deposit.system_amount.value = commaSplit(temp_act,rate_round_num);
                        }
                    }
                    if(document.upd_term_deposit.kur_say.value == 1)
                    {
                        for(var i=1;i<=document.upd_term_deposit.kur_say.value;i++)
                        {
                            rate1_eleman = filterNum(eval('document.upd_term_deposit.txt_rate1_' + i).value,rate_round_num);
                            rate2_eleman = filterNum(eval('document.upd_term_deposit.txt_rate2_' + i).value,rate_round_num);
                            if( eval('document.upd_term_deposit.rd_money.checked'))
                            {
                                if(eval('document.upd_term_deposit.hidden_rd_money_'+i).value == currency_type)
                                    other_money_value_eleman.value = commaSplit(filterNum(document.upd_term_deposit.ACTION_VALUE.value));
                                else
                                    other_money_value_eleman.value = commaSplit(filterNum(document.upd_term_deposit.system_amount.value,4)*(rate1_eleman/rate2_eleman));
                                document.upd_term_deposit.money_type.value = eval('document.upd_term_deposit.hidden_rd_money_'+i).value;
                                document.upd_term_deposit.system_amount.value = commaSplit(filterNum(document.upd_term_deposit.system_amount.value),rate_round_num);
                            }
                        }
                    }
                    else
                    {
                        for(var i=1;i<=document.upd_term_deposit.kur_say.value;i++)
                        {
                            rate1_eleman = filterNum(eval('document.upd_term_deposit.txt_rate1_' + i).value,rate_round_num);
                            rate2_eleman = filterNum(eval('document.upd_term_deposit.txt_rate2_' + i).value,rate_round_num);
                            if( eval('document.upd_term_deposit.rd_money['+(i-1)+'].checked'))
                            {
                                if(eval('document.upd_term_deposit.hidden_rd_money_'+i).value == currency_type)
                                    other_money_value_eleman.value = commaSplit(filterNum(document.upd_term_deposit.ACTION_VALUE.value));
                                else
                                    other_money_value_eleman.value = commaSplit(filterNum(document.upd_term_deposit.system_amount.value,4)*(rate1_eleman/rate2_eleman));
                                document.upd_term_deposit.money_type.value = eval('document.upd_term_deposit.hidden_rd_money_'+i).value;
                                document.upd_term_deposit.system_amount.value = commaSplit(filterNum(document.upd_term_deposit.system_amount.value),rate_round_num);
                            }
                        }
                    }
                }
                else if(doviz_tutar && document.upd_term_deposit.ACTION_VALUE.value != "" && currency_type != "")
                {
                    for(var i=1;i<=document.upd_term_deposit.kur_say.value;i++)
                        if( eval('document.upd_term_deposit.rd_money['+(i-1)+'].checked'))
                        {
                            rate1_eleman = filterNum(eval('document.upd_term_deposit.txt_rate1_' + i).value,rate_round_num);
                            if(document.getElementById('currency_id') != undefined)
                                currency_type = document.getElementById('currency_id').value;
                            else
                                currency_type = list_getat(currency_type,2,';');
                            if (eval('document.upd_term_deposit.hidden_rd_money_'+i).value != 'TL')//hesap TL olmayıp,kurdan TL seçilip,döviz inputu edit edilirse TL kurunu değiştirmesn diye
                                eval('document.upd_term_deposit.txt_rate2_' + i).value = commaSplit(filterNum(document.upd_term_deposit.system_amount.value)/filterNum(other_money_value_eleman.value)*rate1_eleman,rate_round_num);
                            else
                                for(var t=1;t<=upd_term_deposit.kur_say.value;t++)//hesap TL olmayıp,kurdan TL seçilip,döviz inputu edit edilirse TL kurunu değiştirmesn,hesabın kurunu değiştirsn diye
                                    if( eval('document.upd_term_deposit.hidden_rd_money_'+t).value == currency_type && eval('document.upd_term_deposit.hidden_rd_money_'+t).value != 'TL')
                                        eval('document.upd_term_deposit.txt_rate2_' + t).value = commaSplit(filterNum(other_money_value_eleman.value)/filterNum(upd_term_deposit.ACTION_VALUE.value)*rate1_eleman,rate_round_num);
                            if (eval('document.upd_term_deposit.hidden_rd_money_'+i).value != 'TL')
                                for(var k=1;k<=document.upd_term_deposit.kur_say.value;k++)
                                {
                                    rate1_eleman = filterNum(eval('document.upd_term_deposit.txt_rate1_' + k).value,rate_round_num);
                                    rate2_eleman = filterNum(eval('document.upd_term_deposit.txt_rate2_' + k).value,rate_round_num);
                                    if( eval('document.upd_term_deposit.hidden_rd_money_'+k).value == currency_type)
                                    {
                                        temp_act=filterNum(document.upd_term_deposit.ACTION_VALUE.value)*(rate2_eleman/rate1_eleman);
                                        document.upd_term_deposit.system_amount.value = commaSplit(temp_act,rate_round_num);
                                    }
                                }
                            else
                                document.upd_term_deposit.system_amount.value = other_money_value_eleman.value;
                        }
                        return true;
                    }
                
                    document.upd_term_deposit.ACTION_VALUE.value = commaSplit(filterNum(document.upd_term_deposit.ACTION_VALUE.value));
                
                return true;
            }
            else
            {
                if(document.upd_term_deposit.kur_say.value == 1)
                {
                    for(var i=1;i<=document.upd_term_deposit.kur_say.value;i++)
                        if( eval('document.upd_term_deposit.rd_money.checked'))
                            document.upd_term_deposit.money_type.value = eval('document.upd_term_deposit.hidden_rd_money_'+i).value;
                }
                else
                {
                    for(var i=1;i<=document.upd_term_deposit.kur_say.value;i++)
                        if( eval('document.upd_term_deposit.rd_money['+(i-1)+'].checked'))
                            document.upd_term_deposit.money_type.value = eval('document.upd_term_deposit.hidden_rd_money_'+i).value;
                }	
            }
        }
        function hesapla(field_name)
        {
            document.getElementById(field_name).value = commaSplit(document.getElementById(field_name).value,'4');
        }
        function specialVisible(val){
            
            var due_date = $("input[name=due_value]").val() // vade günü
            var tutar = filterNum($("input[name=ACTION_VALUE]").val()); // tutar
    
            if(due_date > 0)
            {
                var getiri_orani = filterNum($("input[name=getiri_orani]").val()); // getiri oranı 
                var getiri_orani_gunluk =  ( ( getiri_orani / 100 ) / $("input[name=ygs]").val() )  * due_date * tutar ;
                $("input[name=getiri_tutari]").val( commaSplit( getiri_orani_gunluk ,'2'));
    
                var getiri_tutari = filterNum($("input[name=getiri_tutari]").val()); // getiri tutarı
                var day = 0;
                if(val == 1) day = 30;
                else if(val == 2) day = 90;
                else if(val == 3) day = 180;
                else if(val == 4) day = $("input[name=ygs]").val();
                else if(val == 5) day = $("input[name=special_day]").val();
                else if(val == 6) day = $("input[name=due_value]").val();

                var getiri_odeme_sayisi = Math.floor(due_date / day);
                $("input[name=getiri_tahsil_sayisi]").val(getiri_odeme_sayisi); // getiri ödeme sayısı
    
                var getiri_tahsil_tutari = getiri_tutari / getiri_odeme_sayisi;
                $("input[name=getiri_tahsil_tutari]").val( commaSplit( getiri_tahsil_tutari,'2') ); // getiri tahsil tutarı
            }
    
            if(val == 5) $("div#item-special_day").show();
            else{
                $("div#item-special_day").hide();
                $("input[name=special_day]").val("");
            }
        }
        function FaizHesapla(fieldName){

                var due_date = $("input[name=due_value]").val(); // vade günü
                var tutar = filterNum($("input[name=ACTION_VALUE]").val()); // tutar
                var getiri_tutari = filterNum($("input[name=getiri_tutari]").val()); // getiri tutarı

                if( tutar > 0 && tutar != '' ){
                    var getiri_orani = filterNum($("input[name=getiri_orani]").val()); // getiri oranı 
                    var getiri_orani_gunluk =  ( ( getiri_orani / 100 ) / $("input[name=ygs]").val() )  * due_date * tutar ;


                    if(fieldName == 'getiri_orani') {
                        $("input[name=getiri_tutari]").val( commaSplit( getiri_orani_gunluk ,'2'));
                    }else if(fieldName == 'getiri_tutari'){
                        var getiri_orani_currently = ( ( getiri_tutari * $("input[name=ygs]").val() ) / due_date / ( tutar / 100 ) );
                        $("input[name=getiri_orani]").val( commaSplit( getiri_orani_currently ,'4'));
                    }

                    var day = 0;
                    var val = $("select#yield_payment_period").val();
                    if(val == 1) day = 30;
                    else if(val == 2) day = 90;
                    else if(val == 3) day = 180;
                    else if(val == 4) day = $("input[name=ygs]").val();
                    else if(val == 5) day = $("input[name=special_day]").val();
                    else if(val == 6) day = $("input[name=due_value]").val();

                    due_date = $("input[name=due_value]").val(); // vade günü
                    tutar = filterNum($("input[name=ACTION_VALUE]").val()); // tutar
                    getiri_tutari = filterNum($("input[name=getiri_tutari]").val()); // getiri tutarı

                    var getiri_odeme_sayisi = Math.floor(due_date / day);
                    $("input[name=getiri_tahsil_sayisi]").val(getiri_odeme_sayisi); // getiri ödeme sayısı
        
                    var getiri_tahsil_tutari = getiri_tutari / getiri_odeme_sayisi;
                    $("input[name=getiri_tahsil_tutari]").val( commaSplit( getiri_tahsil_tutari,'2') ); // getiri tahsil tutarı
        
                }   
                CreatePaymentRow();
        }
    </script>
    <cf_get_lang_set module_name="#lcase(listgetat(attributes.fuseaction,1,'.'))#">
    