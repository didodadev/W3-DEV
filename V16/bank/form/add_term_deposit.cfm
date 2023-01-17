<cf_get_lang_set module_name="bank">
<cf_papers paper_type="virman">
<cfinclude template="../query/control_bill_no.cfm">

<cfset TERM_DEPOSIT = createObject("component", "V16.bank.cfc.vadeliMevduat")>

<cfif isdefined("attributes.ID") and len(attributes.ID)>
	<cfif (session.ep.isBranchAuthorization)>
        <cfquery name="get_all_cash" datasource="#dsn2#">
            SELECT CASH_ID FROM CASH WHERE BRANCH_ID = #ListGetAt(session.ep.user_location,2,"-")#
        </cfquery>
        <cfset cash_list = valuelist(get_all_cash.cash_id)>
        <cfif not listlen(cash_list)><cfset cash_list = 0></cfif>
        <cfset control_branch_id = ListGetAt(session.ep.user_location,2,"-")>
    </cfif>
    <cfquery name="get_iyp" datasource="#dsn2#">
        SELECT
            BA.*,
            IYP.*,
            IYPR.EXPENSE_ITEM_TAHAKKUK_ID,
            PP.PROJECT_HEAD        
        FROM
            BANK_ACTIONS BA
            LEFT JOIN #dsn_alias#.PRO_PROJECTS PP ON BA.PROJECT_ID = PP.PROJECT_ID
            LEFT JOIN INTEREST_YIELD_PLAN IYP ON BA.ACTION_ID = IYP.BANK_ACTION_ID
            LEFT JOIN INTEREST_YIELD_PLAN_ROWS IYPR ON IYP.YIELD_ID = IYPR.YIELD_ID
        WHERE
            ACTION_ID=#attributes.ID# OR ACTION_ID = #attributes.ID+1#
            <cfif (session.ep.isBranchAuthorization)>
            AND                    
            (
            	ACTION_TYPE_ID  = 2311 AND
                FROM_BRANCH_ID = #ListGetAt(session.ep.user_location,2,"-")# OR
				TO_BRANCH_ID = #ListGetAt(session.ep.user_location,2,"-")#
            )
        	</cfif>
    </cfquery>
    <cfquery name="GET_COST_WITH_EXPENSE_ROWS_ID" datasource="#dsn2#">
        SELECT * FROM EXPENSE_ITEMS_ROWS WHERE ACTION_ID = #URL.ID# AND EXPENSE_COST_TYPE = #get_iyp.action_type_id#
    </cfquery>
    <cfset process_cat = get_iyp.process_cat>
    <cfset from_account_id = get_iyp.action_from_account_id>
    <cfset action_to_account_id = get_iyp.action_to_account_id[2]>
    <cfset from_branch_id = get_iyp.from_branch_id>
    <cfset to_branch_id = get_iyp.to_branch_id[2]>
    <cfset action_date = get_iyp.action_date>
    <cfset action_value = get_iyp.action_value>
    <cfset due_value_date = get_iyp.due_value_date>
    <cfset masraf = get_iyp.masraf>
    <cfset due_value = get_iyp.due_value>
    <cfset yield_rate = get_iyp.yield_rate>
    <cfset yield_amount = get_iyp.yield_amount>
    <cfset yield_payment_period = get_iyp.yield_payment_period>
    <cfset special_day = get_iyp.special_day>
    <cfset getiri_tahsil_sayisi = get_iyp.NUMBER_YIELD_COLLECTION>
    <cfset getiri_tahsil_tutari = get_iyp.yield_collection_amount>
    <cfset other_cash_act_value = get_iyp.other_cash_act_value>
    <cfset expense_center_id = get_iyp.expense_center_id>
    <cfset other_money_order = get_iyp.other_money>
    <cfset action_detail = get_iyp.action_detail>
    <cfset expense_item_id = get_iyp.expense_item_id>
    <cfset expense_item_tahakkuk_id = get_iyp.expense_item_tahakkuk_id>
    <cfset expense_item_masraf_id = GET_COST_WITH_EXPENSE_ROWS_ID.expense_item_id>
<cfelse>
	<cfset process_cat = ''>
    <cfset from_account_id = ''>
    <cfset action_to_account_id = ''>
    <cfset from_branch_id = ''>
    <cfset to_branch_id = ''>
    <cfset action_date = now()>
    <cfset action_value = 0>
    <cfset due_value_date = now()>
    <cfset masraf = 0>
    <cfset due_value = 0>
    <cfset yield_rate = 0>
    <cfset yield_amount = 0>
    <cfset yield_payment_period = 6>
    <cfset special_day = ''>
    <cfset getiri_tahsil_sayisi = ''>
    <cfset getiri_tahsil_tutari = ''>
    <cfset other_cash_act_value = ''>
    <cfset expense_center_id = ''>
    <cfset expense_item_id = ''>
    <cfset expense_item_masraf_id = ''>
    <cfset expense_item_tahakkuk_id = ''>
    <cfset other_money_order = ''>
    <cfset action_detail = ''>
</cfif>

<cfset GET_SCENARIO = TERM_DEPOSIT.GET_SCENARIO()>

<cf_catalystHeader>
<cf_box>
    <cfform name="add_term_deposit" method="post" action="">
		<input type="hidden" name="ACTION_TYPE" id="ACTION_TYPE" value="<cfoutput>#UCase(getLang('credit',37))#</cfoutput>">
        <input type="hidden" name="active_period" id="active_period" value="<cfoutput>#session.ep.period_id#</cfoutput>">
        <cf_box_elements>
            <div class="col col-4 col-md-4 col-sm-4 col-xs-12" type="column" index="1" sort="true">
                <div class="form-group" id="item-process_cat">
                    <label class="col col-4 col-xs-12"><cfoutput>#getLang('main',388)#</cfoutput>*</label>
                    <div class="col col-8 col-xs-12">
                        <cf_workcube_process_cat slct_width="285" process_cat="#process_cat#" >
                    </div> 
                </div>
                <div class="form-group" id="item-surec">
                    <label class="col col-4 col-xs-12"><cf_get_lang_main no="1447.Süreç"></label>
                    <div class="col col-8 col-xs-12">
                        <cf_workcube_process is_upd='0' is_detail='0'>
                    </div>
                </div>
                <div class="form-group" id="item-from_account_id">
                    <label class="col col-4 col-xs-12"><cfoutput>#getLang('bank',62)#</cfoutput>*</label>
                    <div class="col col-8 col-xs-12">
                        <cf_wrkBankAccounts fieldId='from_account_id' call_function='kur_ekle_f_hesapla' width='285' selected_value='#from_account_id#'>
                    </div> 
                </div>
                <div class="form-group" id="item-to_account_id">
                    <label class="col col-4 col-xs-12"><cfoutput>#getLang('bank',65)#</cfoutput>*</label>
                    <div class="col col-8 col-xs-12">
                        <cf_wrkBankAccounts fieldId='to_account_id' call_function='kur_ekle_f_hesapla;change_currency_info' width='285'  selected_value='#action_to_account_id#' line_info='2'>
                    </div> 
                </div>
                <div class="form-group" id="item-branch_id_alacak">
                    <label class="col col-4 col-xs-12"><cfoutput>#getLang('main',2726)#</cfoutput></label>
                    <div class="col col-8 col-xs-12">
                        <cfif session.ep.isBranchAuthorization eq 0></cfif>
                        <cf_wrkDepartmentBranch fieldId='branch_id_alacak' is_branch='1' width='150' is_default='1' is_deny_control='1' selected_value='#from_branch_id#'>
                    </div> 
                </div>
                <div class="form-group" id="item-branch_id_borc">
                    <cfif session.ep.isBranchAuthorization eq 0></cfif>
                    <label class="col col-4 col-xs-12"><cfoutput>#getLang('main',2727)#</cfoutput></label>
                    <div class="col col-8 col-xs-12">
                        <cf_wrkDepartmentBranch fieldId='branch_id_borc' is_branch='1' width='150' is_default='1' is_deny_control='1' selected_value='#to_branch_id#'>
                    </div> 
                </div>
                <div class="form-group" id="item-project_id">
                    <label class="col col-4 col-xs-12"><cfoutput>#getLang('main',4)#</cfoutput></label>
                    <div class="col col-8 col-xs-12">
                        <div class="input-group">
                            <cfoutput>
                                <input type="hidden"  name="project_id" id="project_id"/>
                                <input type="text" style="width:150px" name="project_head" id="project_head" onfocus="AutoComplete_Create('project_head','PROJECT_HEAD','PROJECT_HEAD','get_project','','PROJECT_ID','project_id','','3','148');" autocomplete="off" />
                            </cfoutput>
                            <span class="input-group-addon icon-ellipsis btnPointer" onClick="openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_projects&project_id=add_cash_to_cash.project_id&project_head=add_cash_to_cash.project_head');"></span>
                        </div>
                    </div>
                </div>
                <div class="form-group" id="item-paper_number">
                    <label class="col col-4 col-xs-12"><cfoutput>#getLang('main',468)#</cfoutput></label>
                    <div class="col col-8 col-xs-12">
                        <cfinput type="text" name="paper_number" maxlength="50" value="#paper_code & '-' & paper_number#">
                    </div> 
                </div>
                <div class="form-group" id="item-ACTION_DATE">
                    <label class="col col-4 col-xs-12"><cfoutput>#getLang('main',330)#</cfoutput>*</label>
                    <div class="col col-8 col-xs-12">
                        <div class="input-group">
                            <cfsavecontent variable="message"><cf_get_lang_main no='1091.Lutfen Tarih Giriniz'></cfsavecontent>
                            <cfinput type="text" name="ACTION_DATE" value="#dateformat(ACTION_DATE,dateformat_style)#" validate="#validate_style#" required="Yes" message="#message#" onchange="change_paper_duedate('ACTION_DATE',1);specialVisible('yield_payment_period');FaizHesapla('getiri_tutari');" onBlur="change_money_info('add_term_deposit','ACTION_DATE');FaizHesapla('getiri_tutari');"> 
                            <span class="input-group-addon"><cf_wrk_date_image date_field="ACTION_DATE" call_function="change_money_info" control_date="#dateformat(ACTION_DATE,dateformat_style)#"></span>
                        </div>
                    </div> 
                </div>
                <div class="form-group" id="item-ACTION_VALUE">
                    <label class="col col-4 col-xs-12"><cfoutput>#getLang('main',261)#</cfoutput>*</label>
                    <div class="col col-8 col-xs-12">
                        <cfsavecontent variable="message1"><cf_get_lang no='83.Miktar Giriniz!'></cfsavecontent>
                        <cfinput type="text" name="ACTION_VALUE" value="#TLFormat(action_value-masraf)#" required="yes" message="#message1#" class="moneybox" onBlur="kur_ekle_f_hesapla('from_account_id');" onkeyup="specialVisible('yield_payment_period');return(FormatCurrency(this,event));">
                    </div> 
                </div>
                <div class="form-group" id="item-OTHER_CASH_ACT_VALUE">
                    <label class="col col-4 col-xs-12"><cfoutput>#getLang('main',644)#</cfoutput></label>
                    <div class="col col-8 col-xs-12">
                        <cfinput type="text" name="OTHER_CASH_ACT_VALUE" value="#TLFormat(OTHER_CASH_ACT_VALUE)#" class="moneybox" onBlur="kur_ekle_f_hesapla('from_account_id',true);" onkeyup="return(FormatCurrency(this,event));"> 
                    </div> 
                </div>
                <div class="form-group" id="item-due_value">
                    <label class="col col-4 col-xs-12"><cf_get_lang_main no='228.Vade'>*</label>
                    <div class="col col-4 col-xs-12">
                        <input type="number" name="due_value" id="due_value" value="<cfoutput>#due_value#</cfoutput>" onchange="change_paper_duedate('ACTION_DATE');specialVisible('yield_payment_period');FaizHesapla('getiri_tutari');">
                    </div>
                    <div class="col col-4 col-xs-12">
                        <div class="input-group">
                            <cfinput type="text" name="due_value_date" value="#dateformat(due_value_date,dateformat_style)#" onChange="change_paper_duedate('ACTION_DATE',1);specialVisible('yield_payment_period');FaizHesapla('getiri_tutari');" validate="#validate_style#" message="#message#" maxlength="10" readonly>
                            <span class="input-group-addon btnPointer"><cf_wrk_date_image date_field="due_value_date"></span>
                        </div>
                    </div>
                </div>
                <div class="form-group" id="item-getiri_orani">
                    <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id="51373.Getiri Oranı"> - YGS *</label>
                    <div class="col col-4 col-xs-12">
                        <cfinput type="text" name="getiri_orani" class="moneybox" value="#TLFormat(yield_rate,4)#" onblur="hesapla('getiri_orani');" onkeyup="FaizHesapla('getiri_orani');return(FormatCurrency(this,event));">
                    </div>
                    <div class="col col-4 col-xs-12">
                        <cfinput type="number" name="ygs" class="moneybox" value="365" onblur="hesapla('getiri_orani');" onkeyup="FaizHesapla('getiri_orani');return(FormatCurrency(this,event));">
                    </div>
                </div>
                <div class="form-group" id="item-getiri_tutari">
                    <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id="51374.Getiri Tutarı"></label>
                    <div class="col col-8 col-xs-12">
                        <cfsavecontent variable="message1"><cf_get_lang no='83.Miktar Giriniz!'></cfsavecontent>
                        <cfinput type="text" name="getiri_tutari" value="#TLFormat(yield_amount,2)#" required="yes" message="#message1#" class="moneybox" onkeyup="return(FormatCurrency(this,event));" onblur="FaizHesapla('getiri_tutari');">
                    </div> 
                </div>
                <div class="form-group" id="item-show-payment-row">
                    <label class="col col-4 col-xs-12"></label>
                    <div class="col col-8">
                        <button class="btn btn-sm widFull" onclick="CreatePaymentRow();ToggleRow();return false;"><cf_get_lang dictionary_id='34276.Getiri Tablosunu Göster'>/ <cf_get_lang dictionary_id='58628'></button>
                    </div>
                </div>
            </div>
            <div class="col col-4 col-md-4 col-sm-4 col-xs-12" type="column" index="2" sort="true">
                <div class="form-group" id="item-getiri_tahsil_sayisi" style="display:none;">
                    <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='34271.Getiri Tahsil Sayısı'> *</label>
                    <div class="col col-8 col-xs-12">
                        <cfinput type="number" value="#getiri_tahsil_sayisi#" name="getiri_tahsil_sayisi" readonly>
                    </div> 
                </div>
                <div class="form-group" id="item-getiri_tahsil_tutari" style="display:none;">
                    <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='34240.Getiri Tahsil Tutarı'> *</label>
                    <div class="col col-8 col-xs-12">
                        <cfinput type="text" name="getiri_tahsil_tutari" value="#TLFormat(getiri_tahsil_tutari,2)#" class="moneybox"  onkeyup="return(FormatCurrency(this,event));" readonly>
                    </div> 
                </div>
                <div class="form-group" id="item-finansal_senaryo">
                    <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='43503.Finansal'> <cf_get_lang dictionary_id='54557.Senaryo Tipi'></label>
                    <div class="col col-8 col-xs-12">
                        <select name="finansal_senaryo" id="finansal_senaryo">
                            <option value=""><cf_get_lang_main no='1281.Seç'></option>
                            <cfoutput query="GET_SCENARIO">
                                <option value="#SCENARIO_ID#">#SCENARIO#</option>
                            </cfoutput>
                        </select>
                    </div>
                </div>
                <div class="form-group" id="item-ACTION_DETAIL">
                    <label class="col col-4 col-xs-12"><cfoutput>#getLang('main',217)#</cfoutput></label>
                    <div class="col col-8 col-xs-12">
                        <textarea name="ACTION_DETAIL" id="ACTION_DETAIL" maxlength="200" onkeyup="return ismaxlength(this)" onBlur="return ismaxlength(this);" message="200 Karakterden Fazla Yazmayınız!"><cfoutput>#action_detail#</cfoutput></textarea>
                    </div> 
                </div>
                <div class="form-group" id="item-expense_item_tahakkuk_id">
                    <label class="col col-4 col-xs-12"><cfoutput>#getLang('main',822)#</cfoutput> <cf_get_lang dictionary_id='34760.Tahakkuk'> * </label>
                    <div class="col col-8 col-xs-12">
                        <cf_wrkExpenseItem width_info="150" fieldId="expense_item_tahakkuk_id" fieldName="expense_item_tahakkuk_name" form_name="add_term_deposit" income_type_info="0" expense_item_id="#expense_item_tahakkuk_id#" img_info="plus_thin">
                    </div> 
                </div>

                <div class="form-group" id="item-expense_item_id">
                    <label class="col col-4 col-xs-12"><cfoutput>#getLang('main',822)#</cfoutput> <cf_get_lang dictionary_id='57845.Tahsilat'> *</label>
                    <div class="col col-8 col-xs-12">
                        <cf_wrkExpenseItem width_info="150" fieldId="expense_item_id" fieldName="expense_item_name" form_name="add_term_deposit" expense_item_id="#expense_item_id#" income_type_info="1" img_info="plus_thin">
                    </div> 
                </div>
                <div class="form-group" id="item-masraf_baslik">
                    <label class="col col-12 bold"><cfoutput>#getLang('main',1518)#</cfoutput></label>
                </div>
                <div class="form-group" id="item-masraf">
                    <label class="col col-4 col-xs-12"><cfoutput>#getLang('main',261)#</cfoutput></label>
                    <div class="col col-8 col-xs-12">
                        <cfif masraf gt 0>
                        <cfinput type="text" name="masraf" class="moneybox" style="width:150px;" value="#TLFormat(MASRAF)#" onkeyup="return(FormatCurrency(this,event));">
                        <cfelse>
                            <cfinput type="text" name="masraf" class="moneybox" style="width:150px;" value="" onkeyup="return(FormatCurrency(this,event));">
                        </cfif>
                    </div> 
                </div>
                <div class="form-group" id="item-expense_center_id">
                    <label class="col col-4 col-xs-12"><cfoutput>#getLang('main',1048)#</cfoutput></label>
                    <div class="col col-8 col-xs-12">
                        <cf_wrkExpenseCenter width_info="150" fieldId="expense_center_id" fieldName="expense_center_name" form_name="add_term_deposit" expense_center_id="#expense_center_id#" img_info="plus_thin">
                    </div> 
                </div>
                <div class="form-group" id="item-expense_item_masraf_id">
                    <label class="col col-4 col-xs-12"><cfoutput>#getLang('main',822)#</cfoutput></label>
                    <div class="col col-8 col-xs-12">
                        <cf_wrkExpenseItem width_info="150" fieldId="expense_item_masraf_id" fieldName="expense_item_masraf_name" form_name="add_term_deposit" income_type_info="0" expense_item_id="#expense_item_masraf_id#" img_info="plus_thin">
                    </div> 
                </div>
            </div>
            <div class="col col-2 col-md-3 col-sm-4 col-xs-12" type="column" index="3" sort="true">
                <div class="form-group" id="item-kur-ekle">
                    <div class="col col-12">
                        <label class="bold"><cf_get_lang no='53.İşlem Para Br'></label>
                        <cfscript>f_kur_ekle(process_type:0,base_value:'ACTION_VALUE',other_money_value:'OTHER_CASH_ACT_VALUE',form_name:'add_term_deposit',select_input:'from_account_id',selected_money='#other_money_order#',is_disable='1');</cfscript>
                    </div>
                </div>
            </div>
            <div class="col col-12 col-md-12 col-sm-12 col-xs-12">
                <cfsavecontent variable="msg"><cf_get_lang dictionary_id='33153.Periyodik'> <cf_get_lang dictionary_id='51378.Getiri Tablosu'></cfsavecontent>
                <div id="div_getiri_tablosu" style="display:none;">
                    <cf_seperator id="getiri_tablosu" header="#msg#">
                    <div class="col col-6 col-md-5 col-sm-4 col-xs-12" id="getiri_tablosu" type="column" index="3" sort="true">
                        <div class="row" style="margin-left:3.5px;">
                            <div class="col col-12">
                                <div class="form-group col col-12" id="item-odeme_periyodu">
                                    <div class="col col-1"></div>
                                    <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='51376.Getiri Ödeme Periyodu'></label>
                                    <div class="col col-4 col-xs-12">
                                        <select name="yield_payment_period" id="yield_payment_period" onchange="specialVisible(this.value);CreatePaymentRow();">
                                            <option value=""><cf_get_lang_main no='1281.Seç'></option>
                                            <option value="1" <cfif yield_payment_period eq 1>selected</cfif>><cf_get_lang_main no='1312.Ay'></option>
                                            <option value="2" <cfif yield_payment_period eq 2>selected</cfif>>3 <cf_get_lang_main no='1312.Ay'></option>
                                            <option value="3" <cfif yield_payment_period eq 3>selected</cfif>>6 <cf_get_lang_main no='1312.Ay'></option>
                                            <option value="4" <cfif yield_payment_period eq 4>selected</cfif>><cf_get_lang_main no='1043.Yıl'></option>
                                            <option value="5" <cfif yield_payment_period eq 5>selected</cfif>><cf_get_lang_main no='567.Özel'></option>
                                            <option value="6" selected><cf_get_lang dictionary_id='33558.Vade Sonu'></option>
                                        </select>
                                    </div>
                                </div>
                                <div class="form-group col col-4" id="item-special_day" style="display:none">
                                    <label class="col col-12 col-xs-12"><cf_get_lang_main no='78.Day'></label>
                                    <div class="col col-8 col-xs-12">
                                        <cfinput type="number" name="special_day" onblur="specialVisible('5');CreatePaymentRow()">
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

                        </div>
                    </div>
                </div>
            </div>
        </cf_box_elements>
        <cf_box_footer>
            <cf_workcube_buttons type_format="1" is_upd='0' add_function='kontrol()'>
        </cf_box_footer>
	</cfform>
</cf_box>
<script type="text/javascript">
    
    <cfif isdefined("attributes.ID") and len(attributes.ID)>
        CreatePaymentRow();
    </cfif>

    kur_ekle_f_hesapla('from_account_id');

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
                                value : commaSplit(getiri_tahsil_tutari,2),
                                type : "text"
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

          // $("#getiri_tutari").val( commaSplit(lastTotal,2));
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
		if(!paper_control(add_term_deposit.paper_number,'VIRMAN')) return false;
		if(!chk_process_cat('add_term_deposit')) return false;
		if(!check_display_files('add_term_deposit')) return false;
		if(!chk_period(document.add_term_deposit.ACTION_DATE,'İşlem')) return false;
		if(!acc_control('from_account_id')) return false;
		if(!acc_control('to_account_id')) return false;
		kur_ekle_f_hesapla('from_account_id');//dövizli tutarı silinenler için
		if(document.add_term_deposit.from_account_id.value == document.add_term_deposit.to_account_id.value)				
		{
			alert("<cf_get_lang no='94.Seçtiğiniz Banka Hesapları Aynı !'>");		
			return false; 
        }
        if( $("#expense_center_id").val() == '' && $("#expense_center_name").val() == ''){
            alert("<cf_get_lang dictionary_id='48881.Masraf Merkezi Seçiniz'>!");
            return false;
        }
        if(document.getElementById('ACTION_VALUE').value == '0,00')
        {
            alert("<cf_get_lang_main no='261.Tutar Girmelisiniz!'>Girmelisiniz!");
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
        if(document.add_term_deposit.yield_payment_period.value == ""){
            alert("<cf_get_lang dictionary_id='33551.Ödeme Periyodu Girmelisiniz'>");
            return false;
        }

        inp_getiri_orani = $("#getiri_orani");
        inp_getiri_tutari = $("#getiri_tutari");
        input_getiri_tahsil_tutari = $("#getiri_tahsil_tutari");
        for(var i=1;i<=document.add_term_deposit.getiri_tahsil_sayisi.value;i++)
            {
                inp_getiri_tahsil_tutari = $("input[name=getiri_tutari_row"+i+"]");
                inp_getiri_tahsil_tutari.val( filterNum( inp_getiri_tahsil_tutari.val(),'<cfoutput>#session.ep.our_company_info.rate_round_num#</cfoutput>'));
            }

        inp_getiri_orani.val( filterNum( inp_getiri_orani.val(),'<cfoutput>#session.ep.our_company_info.rate_round_num#</cfoutput>'));
        inp_getiri_tutari.val( filterNum( inp_getiri_tutari.val(),'<cfoutput>#session.ep.our_company_info.rate_round_num#</cfoutput>'));
        input_getiri_tahsil_tutari.val( filterNum( input_getiri_tahsil_tutari.val(),'<cfoutput>#session.ep.our_company_info.rate_round_num#</cfoutput>'));
		return true;
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
                var currency_type = eval('document.add_term_deposit.'+select_input+'.options[document.add_term_deposit.'+select_input+'.selectedIndex]').value;
            
            var other_money_value_eleman= eval('document.add_term_deposit.OTHER_CASH_ACT_VALUE');
            var temp_act,temp_base_act,rate1_eleman,rate2_eleman;
            if(doviz_tutar && ( other_money_value_eleman.value.length==0 || filterNum(other_money_value_eleman.value)==0) )
            {
                other_money_value_eleman.value = '';
                return false;
            }
            if(!doviz_tutar && eval('document.add_term_deposit.ACTION_VALUE.value') != "" && currency_type != "")
            {
                if(document.getElementById('currency_id') != undefined)
                    currency_type = document.getElementById('currency_id').value;
                else
                    currency_type = list_getat(currency_type,2,';');
                for(var i=1;i<=document.add_term_deposit.kur_say.value;i++)
                {
                    rate1_eleman = filterNum(eval('document.add_term_deposit.txt_rate1_' + i).value,rate_round_num);
                    rate2_eleman = filterNum(eval('document.add_term_deposit.txt_rate2_' + i).value,rate_round_num);
                    if( eval('document.add_term_deposit.hidden_rd_money_'+i).value == currency_type)
                    {
                        temp_act=filterNum(document.add_term_deposit.ACTION_VALUE.value)*rate2_eleman/rate1_eleman;
                        document.add_term_deposit.system_amount.value = commaSplit(temp_act,rate_round_num);
                    }
                }
                if(document.add_term_deposit.kur_say.value == 1)
                {
                    for(var i=1;i<=document.add_term_deposit.kur_say.value;i++)
                    {
                        rate1_eleman = filterNum(eval('document.add_term_deposit.txt_rate1_' + i).value,rate_round_num);
                        rate2_eleman = filterNum(eval('document.add_term_deposit.txt_rate2_' + i).value,rate_round_num);
                        if( eval('document.add_term_deposit.rd_money.checked'))
                        {
                            if(eval('document.add_term_deposit.hidden_rd_money_'+i).value == currency_type)
                                other_money_value_eleman.value = commaSplit(filterNum(document.add_term_deposit.ACTION_VALUE.value));
                            else
                                other_money_value_eleman.value = commaSplit(filterNum(document.add_term_deposit.system_amount.value,4)*(rate1_eleman/rate2_eleman));
                            document.add_term_deposit.money_type.value = eval('document.add_term_deposit.hidden_rd_money_'+i).value;
                            document.add_term_deposit.system_amount.value = commaSplit(filterNum(document.add_term_deposit.system_amount.value),rate_round_num);
                        }
                    }
                }
                else
                {
                    for(var i=1;i<=document.add_term_deposit.kur_say.value;i++)
                    {
                        rate1_eleman = filterNum(eval('document.add_term_deposit.txt_rate1_' + i).value,rate_round_num);
                        rate2_eleman = filterNum(eval('document.add_term_deposit.txt_rate2_' + i).value,rate_round_num);
                        if( eval('document.add_term_deposit.rd_money['+(i-1)+'].checked'))
                        {
                            if(eval('document.add_term_deposit.hidden_rd_money_'+i).value == currency_type)
                                other_money_value_eleman.value = commaSplit(filterNum(document.add_term_deposit.ACTION_VALUE.value));
                            else
                                other_money_value_eleman.value = commaSplit(filterNum(document.add_term_deposit.system_amount.value,4)*(rate1_eleman/rate2_eleman));
                            document.add_term_deposit.money_type.value = eval('document.add_term_deposit.hidden_rd_money_'+i).value;
                            document.add_term_deposit.system_amount.value = commaSplit(filterNum(document.add_term_deposit.system_amount.value),rate_round_num);
                        }
                    }
                }
            }
            else if(doviz_tutar && document.add_term_deposit.ACTION_VALUE.value != "" && currency_type != "")
            {
                for(var i=1;i<=document.add_term_deposit.kur_say.value;i++)
                    if( eval('document.add_term_deposit.rd_money['+(i-1)+'].checked'))
                    {
                        rate1_eleman = filterNum(eval('document.add_term_deposit.txt_rate1_' + i).value,rate_round_num);
                        if(document.getElementById('currency_id') != undefined)
                            currency_type = document.getElementById('currency_id').value;
                        else
                            currency_type = list_getat(currency_type,2,';');
                        if (eval('document.add_term_deposit.hidden_rd_money_'+i).value != 'TL')//hesap TL olmayıp,kurdan TL seçilip,döviz inputu edit edilirse TL kurunu değiştirmesn diye
                            eval('document.add_term_deposit.txt_rate2_' + i).value = commaSplit(filterNum(document.add_term_deposit.system_amount.value)/filterNum(other_money_value_eleman.value)*rate1_eleman,rate_round_num);
                        else
                            for(var t=1;t<=add_term_deposit.kur_say.value;t++)//hesap TL olmayıp,kurdan TL seçilip,döviz inputu edit edilirse TL kurunu değiştirmesn,hesabın kurunu değiştirsn diye
                                if( eval('document.add_term_deposit.hidden_rd_money_'+t).value == currency_type && eval('document.add_term_deposit.hidden_rd_money_'+t).value != 'TL')
                                    eval('document.add_term_deposit.txt_rate2_' + t).value = commaSplit(filterNum(other_money_value_eleman.value)/filterNum(add_term_deposit.ACTION_VALUE.value)*rate1_eleman,rate_round_num);
                        if (eval('document.add_term_deposit.hidden_rd_money_'+i).value != 'TL')
                            for(var k=1;k<=document.add_term_deposit.kur_say.value;k++)
                            {
                                rate1_eleman = filterNum(eval('document.add_term_deposit.txt_rate1_' + k).value,rate_round_num);
                                rate2_eleman = filterNum(eval('document.add_term_deposit.txt_rate2_' + k).value,rate_round_num);
                                if( eval('document.add_term_deposit.hidden_rd_money_'+k).value == currency_type)
                                {
                                    temp_act=filterNum(document.add_term_deposit.ACTION_VALUE.value)*(rate2_eleman/rate1_eleman);
                                    document.add_term_deposit.system_amount.value = commaSplit(temp_act,rate_round_num);
                                }
                            }
                        else
                            document.add_term_deposit.system_amount.value = other_money_value_eleman.value;
                    }
                    return true;
                }
            
                document.add_term_deposit.ACTION_VALUE.value = commaSplit(filterNum(document.add_term_deposit.ACTION_VALUE.value));
            
            return true;
        }
        else
        {
            if(document.add_term_deposit.kur_say.value == 1)
            {
                for(var i=1;i<=document.add_term_deposit.kur_say.value;i++)
                    if( eval('document.add_term_deposit.rd_money.checked'))
                        document.add_term_deposit.money_type.value = eval('document.add_term_deposit.hidden_rd_money_'+i).value;
            }
            else
            {
                for(var i=1;i<=document.add_term_deposit.kur_say.value;i++)
                    if( eval('document.add_term_deposit.rd_money['+(i-1)+'].checked'))
                        document.add_term_deposit.money_type.value = eval('document.add_term_deposit.hidden_rd_money_'+i).value;
            }	
        }
    }
    function change_paper_duedate(field_name,type,is_row_parse) 
	{
		paper_date_=eval('document.add_term_deposit.ACTION_DATE.value');
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
    function hesapla(field_name)
	{
        document.getElementById(field_name).value = commaSplit(document.getElementById(field_name).value,'4');
    }
    function specialVisible(val){
        
        if(val == 'yield_payment_period') val = $("select[name=yield_payment_period]").val();
        
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

            if(val == 6){
                $("#item-getiri_tahsil_sayisi").hide();
            }
            else{
                $("#item-getiri_tahsil_sayisi").show();
            }
            
            var getiri_odeme_sayisi = Math.floor(due_date / day);
            $("input[name=getiri_tahsil_sayisi]").val(getiri_odeme_sayisi); // getiri ödeme sayısı

            var getiri_tahsil_tutari = getiri_tutari / getiri_odeme_sayisi;
            $("input[name=getiri_tahsil_tutari]").val( commaSplit( getiri_tahsil_tutari, '2') ); // getiri tahsil tutarı
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
