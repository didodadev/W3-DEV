<cf_xml_page_edit fuseact="bank.interest_revenue">
    <cfquery name="get_process_type" datasource="#dsn3#">
        SELECT 
            PROCESS_TYPE,
            IS_CARI,
            IS_ACCOUNT,
            ACTION_FILE_NAME,
            ACTION_FILE_FROM_TEMPLATE,
            PROCESS_CAT_ID
        FROM 
             SETUP_PROCESS_CAT 
        WHERE 
            PROCESS_TYPE = 2313
    </cfquery>
    <cfquery name="GET_BANK_ACTION" datasource="#dsn2#">
        SELECT
            IYPR.BANK_ACTION_ID,
            IYPR.YIELD_ID,
            IYPR.TERM_BANK_TO_BANK
        FROM
            INTEREST_YIELD_PLAN_ROWS IYPR
        WHERE 
            YIELD_ROWS_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.id#">
    </cfquery>
    <cfquery name="GET_PRINCIPAL" datasource="#dsn2#">
        SELECT
            BA.ACTION_VALUE,
            IYP.BANK_ACTION_ID
        FROM
            BANK_ACTIONS BA LEFT JOIN INTEREST_YIELD_PLAN IYP ON IYP.BANK_ACTION_ID = BA.ACTION_ID
        WHERE 
            IYP.YIELD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#GET_BANK_ACTION.YIELD_ID#">
    </cfquery>
    <cfquery name="GET_PAYMENT_ROW" datasource="#dsn2#">
        SELECT 
            IYPR.*,
            IYP.YIELD_ID,
            IYP.YIELD_RATE,
            IYP.DUE_VALUE,
            IYP.YGS,
            BA.ACTION_DATE,
            BA.EXPENSE_ITEM_ID,
            BA.ACTION_TYPE_ID,
            BA.ACTION_FROM_ACCOUNT_ID,
            BA.ACTION_TO_ACCOUNT_ID,
            BA.OTHER_CASH_ACT_VALUE,
            BA.PAPER_NO,
            BA.MASRAF,
            BA.EXPENSE_CENTER_ID,
            BA.ACTION_VALUE,
            BA.RECORD_EMP,
            BA.RECORD_DATE,
            BA.RECORD_IP,
            BA.UPDATE_EMP,
            BA.UPDATE_DATE,
            BA.UPDATE_EMP
        FROM 
            BANK_ACTIONS BA
            LEFT JOIN INTEREST_YIELD_PLAN_ROWS IYPR ON IYPR.BANK_ACTION_ID = BA.ACTION_ID
            LEFT JOIN INTEREST_YIELD_PLAN IYP ON IYP.YIELD_ID = IYPR.YIELD_ID
        WHERE 1=1 
            AND ( 
                <cfif GET_BANK_ACTION.TERM_BANK_TO_BANK eq 1> <!--- vadeliden vadeliye ise --->
                    ACTION_ID = #GET_BANK_ACTION.BANK_ACTION_ID# OR ACTION_ID =#GET_BANK_ACTION.BANK_ACTION_ID+1#   
                <cfelse> <!--- vadeliden vadesize ise --->
                    ACTION_ID = #GET_BANK_ACTION.BANK_ACTION_ID# OR ACTION_ID =#GET_BANK_ACTION.BANK_ACTION_ID+3#  
                </cfif>
                ) 
            ORDER BY ACTION_ID ASC
    </cfquery>
    <cfif GET_BANK_ACTION.TERM_BANK_TO_BANK eq 0>
        <cfset GET_PAYMENT_ROW.ACTION_FROM_ACCOUNT_ID = GET_PAYMENT_ROW.ACTION_TO_ACCOUNT_ID[2]>
        <cfset GET_PAYMENT_ROW.ACTION_TO_ACCOUNT_ID[2] = GET_PAYMENT_ROW.ACTION_TO_ACCOUNT_ID>
    </cfif>
        <cfquery name="get_rows" datasource="#dsn2#">
            SELECT YIELD_ROWS_ID FROM INTEREST_YIELD_PLAN_ROWS WHERE YIELD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#GET_PAYMENT_ROW.YIELD_ID#">
        </cfquery>     
        <cfquery name="get_reeskont_values" datasource="#dsn2#">
            SELECT SUM(YIELD_VALUATION_AMOUNT) AS TOTAL_REESKONT FROM INTEREST_YIELD_VALUATION WHERE YIELD_ROWS_ID IN (#valuelist(get_rows.YIELD_ROWS_ID)#)
        </cfquery>
        <cfif len(get_reeskont_values.TOTAL_REESKONT)>
            <cfset reeskont_values = get_reeskont_values.recordcount>
        <cfelse>
            <cfset reeskont_values = 0>
        </cfif>
     
    <cfset ADD_PAYMENT = createObject("component", "V16.bank.cfc.vadeliMevduat")>
    <cfset get_acc_code_expense_item = ADD_PAYMENT.get_acc_code_exp( expense_item_id : GET_PAYMENT_ROW.EXPENSE_ITEM_ID )>
    <cfsavecontent variable="message"><cf_get_lang dictionary_id='33561'></cfsavecontent>
    <cfset pagehead="#message#">
    <cf_catalystHeader>
    <div class="col col-12 col-xs-12">
        <cf_box>      
            <cf_papers paper_type="incoming_transfer">
            <cfform name="add_interest_revenue" method="post" action="">
                <input type="hidden" name="active_period" id="active_period" value="<cfoutput>#session.ep.period_id#</cfoutput>">
                <input type="hidden" name="ACTION_TYPE" id="ACTION_TYPE" value="<cfoutput>#UCase(getLang('credit',56))#</cfoutput>">
                <input type="hidden" name="row_id" id="row_id" value="<cfoutput>#attributes.id#</cfoutput>">
                <input type="hidden" name="bank_action_id" id="bank_action_id" value="<cfoutput>#GET_PAYMENT_ROW.bank_action_id#</cfoutput>">
                <input type="hidden" name="bank_action_id_last" id="bank_action_id_last" value="<cfoutput>#GET_PAYMENT_ROW.bank_action_id+1#</cfoutput>">
                <input type="hidden" name="acc_tahakkuk_code" id="acc_tahakkuk_code" value="<cfoutput>#attributes.acc_tahakkuk_code#</cfoutput>">
                <input type="hidden" name="xml_is_brut_yield" value="<cfoutput>#xml_is_brut_yield#</cfoutput>">
                <cfset toplam_tutar = 0>
                <cf_box_elements>            
                    <div class="col col-4 col-md-4 col-sm-6 col-xs-12" type="column" index="1" sort="true">
                        <div class="form-group" id="item-process_cat">
                            <label class="col col-4 col-xs-12"><cfoutput>#getLang('main',388)#​</cfoutput>*</label>
                            <div class="col col-8 col-xs-12">
                                    <cf_workcube_process_cat process_cat="#get_process_type.PROCESS_CAT_ID#">
                            </div>
                        </div>
                        <div class="form-group" id="item-paper_number">
                            <label class="col col-4 col-xs-12"><cfoutput>#getLang('main',468)#​</cfoutput></label>
                            <div class="col col-8 col-xs-12">
                                <cfinput type="text" name="paper_number" readonly="readonly" value="#GET_PAYMENT_ROW.paper_no#"  maxlength="50">
                            </div>
                        </div>
                        <div class="form-group" id="item-ACTION_DATE">
                            <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57879.İşlem Tarihi'>*</label>
                            <div class="col col-8 col-xs-12">
                                <div class="input-group">
                                    <cfinput type="text" name="ACTION_DATE" required="yes" value="#dateformat(GET_PAYMENT_ROW.ACTION_DATE,dateformat_style)#" style="width:175px;" message="Hesaba Geçiş Tarihi Giriniz!" onBlur="dateDiffHesapla('action_date');" onchange="dateDiffHesapla('action_date');">
                                <span class="input-group-addon"><cf_wrk_date_image date_field="ACTION_DATE"></span>
                                </div>
                            </div>
                        </div>
                        <div class="form-group" id="item-BANK_ACTION_DATE">
                            <label class="col col-4 col-xs-12"><cfoutput>#getLang('bank',236)#​</cfoutput>*</label>
                            <div class="col col-8 col-xs-12">
                                <div class="input-group">
                                    <cfinput type="text" name="BANK_ACTION_DATE" required="yes" value="#dateformat(GET_PAYMENT_ROW.BANK_ACTION_DATE,dateformat_style)#" message="Hesaba Geçiş Tarihi Giriniz!" onBlur="dateDiffHesapla('action_date');" onchange="dateDiffHesapla('action_date');">
                                <span class="input-group-addon"><cf_wrk_date_image date_field="BANK_ACTION_DATE"></span>
                                </div>
                            </div>
                        </div>
                        <div class="form-group" id="item-diff-day" style="display:none;">
                            <label class="col col-3 col-xs-12">Gün Farkı</label>
                            <label class="col col-1 col-xs-12" id="day_diff"><cfoutput>#DateDiff("d",GET_PAYMENT_ROW.ACTION_DATE,GET_PAYMENT_ROW.BANK_ACTION_DATE)#</cfoutput> </label>
                            <label class="col col-8 col-xs-12" style="color:red;font-weight:bold;" id="day_diff_label">Bu İşlemi Yapmak Getiri Kaybına Yol Açabilir!  </label>
                        </div>
                        <div class="form-group" id="item-from_account_id">
                            <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='29449.Banka Hesabı'></label>
                            <div class="col col-8 col-xs-12">
                                <cf_wrkBankAccounts fieldId='from_account_id' call_function='kur_ekle_f_hesapla' width='285' selected_value='#GET_PAYMENT_ROW.ACTION_FROM_ACCOUNT_ID#'>
                            </div> 
                        </div> 
                        <div class="form-group" id="item-to_account_id">
                            <label class="col col-4 col-xs-12"><cfoutput>#getLang('bank',65)#</cfoutput>*</label>
                            <div class="col col-8 col-xs-12">
                                <cf_wrkBankAccounts fieldId='to_account_id' call_function='kur_ekle_f_hesapla;change_currency_info' selected_value='#GET_PAYMENT_ROW.ACTION_TO_ACCOUNT_ID[2]#' line_info='2'>
                            </div> 
                        </div>
                        <div class="form-group" id="item-to_account_id">
                            <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id="60887.Anaparayı Çek"></label>
                            <div class="col col-8 col-xs-12">
                                <input type="checkbox" name="showPrincipal" onclick="showPrincipals()" value="1" <cfif GET_PAYMENT_ROW.PAYMENT_PRINCIPAL eq 1>checked</cfif>>
                            </div> 
                        </div>
                        <div class="form-group" id="item-to_new_rate">
                            <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id="51373.Getiri oranı">/ YGS</label>
                            <div class="col col-5 col-xs-12"  id="newRate">
                                <cfinput type="hidden" name="newDueValue" value="#GET_PAYMENT_ROW.DUE_VALUE#">
                                <div class="input-group">
                                    <cfinput type="text" name="newYieldRate" value="#iif(len(GET_PAYMENT_ROW.CHANGE_NEW_RATE),'TLFormat(GET_PAYMENT_ROW.CHANGE_NEW_RATE)',DE(TLFormat(GET_PAYMENT_ROW.YIELD_RATE)))#" id="newYieldRate" onblur="changeAmount()" class="moneybox" onkeyup="return(FormatCurrency(this,event));">
                                    <span class="input-group-addon no-bg">-</span>
                                    <cfinput type="number" name="ygs" class="moneybox" value="#iif(len(GET_PAYMENT_ROW.YGS),'GET_PAYMENT_ROW.ygs',DE(365))#" onblur="changeAmount()" onkeyup="return(FormatCurrency(this,event));">
                                </div>                                
                            </div> 
                        </div>
                        <div class="form-group" id="item-principal" <cfif GET_PAYMENT_ROW.PAYMENT_PRINCIPAL neq 1>style="display:none;"</cfif> >
                            <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id="51344.Anapara"></label>
                            <div class="col col-8 col-xs-12">
                                <cfinput type="text" name="principal" value="#TLFormat(GET_PRINCIPAL.ACTION_VALUE)#" required="yes" class="moneybox" onkeyup="return(FormatCurrency(this,event));" readonly>
                            </div> 
                        </div>
                        <div class="form-group" id="item-yield_loss">
                            <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id="57492.Toplam"><cf_get_lang dictionary_id="59804.Reeskont Değeri"></label>
                            <div class="col col-8 col-xs-12">
                                <cfinput type="text" id="total_reeskont" name="total_reeskont" value="#TLFormat(get_reeskont_values.TOTAL_REESKONT)#" class="moneybox" onkeyup="return(FormatCurrency(this,event));" readonly>
                            </div> 
                        </div>
                        <div class="form-group" id="item-ACTION_VALUE">
                            <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id="58548.İlk"><cf_get_lang dictionary_id="51374.Getiri Tutarı"></label>
                            <div class="col col-8 col-xs-12">
                                <cfinput type="text" name="ACTION_VALUE" value="#TLFormat(GET_PAYMENT_ROW.AMOUNT)#" required="yes" class="moneybox" onkeyup="return(FormatCurrency(this,event));">
                            </div>
                        </div>
                        <div class="form-group" id="item-LAST-ACTION_VALUE" style="display:none;">
                            <label class="col col-4 col-xs-12">Son <cf_get_lang dictionary_id="51374.Getiri Tutarı"></label>
                            <div class="col col-8 col-xs-12">
                                <cfinput type="text" name="last_ACTION_VALUE" id="last_ACTION_VALUE" class="moneybox" onkeyup="return(FormatCurrency(this,event));">
                            </div>
                        </div>
                        <div class="form-group" id="item-yield_loss">
                            <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id="60890.Getiri Kaybı"></label>
                            <div class="col col-8 col-xs-12">
                                <cfinput type="text" id="yield_loss" name="yield_loss" value="#TLFormat((DateDiff("d",GET_PAYMENT_ROW.ACTION_DATE,GET_PAYMENT_ROW.BANK_ACTION_DATE) * GET_PAYMENT_ROW.AMOUNT / GET_PAYMENT_ROW.DUE_VALUE ))#" required="yes" class="moneybox" onkeyup="return(FormatCurrency(this,event));" readonly>
                            </div> 
                        </div>
                        <div class="form-group" id="item-total_action_value">
                            <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='58083.Net'><cf_get_lang dictionary_id='51374.Getiri Tutarı'></label>
                            <div class="col col-8 col-xs-12">
                                <cfinput type="text" id="total_action_value" name="total_action_value" value="#TLFormat(GET_PAYMENT_ROW.AMOUNT - (DateDiff("d",GET_PAYMENT_ROW.ACTION_DATE,GET_PAYMENT_ROW.BANK_ACTION_DATE) * GET_PAYMENT_ROW.AMOUNT / GET_PAYMENT_ROW.DUE_VALUE) )#" required="yes" class="moneybox" onblur="kur_ekle_f_hesapla('from_account_id');dateDiffHesapla('total_action_value');" onkeyup="return(FormatCurrency(this,event));">
                            </div> 
                        </div>
                        <div class="form-group" id="item-OTHER_CASH_ACT_VALUE">
                            <label class="col col-4 col-xs-12"><cfoutput>#getLang('main',644)#</cfoutput></label>
                            <div class="col col-8 col-xs-12">
                                <cfinput type="text" name="OTHER_CASH_ACT_VALUE" value="#TLFormat(GET_PAYMENT_ROW.OTHER_CASH_ACT_VALUE)#" readonly style="width:150px;" class="moneybox" onBlur="kur_ekle_f_hesapla('from_account_id',true);" onkeyup="return(FormatCurrency(this,event));">
                            </div> 
                        </div>
                        <div class="form-group" id="item-stopaj_rate">
                            <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='32930.Stopaj Oranı'>% *</label>
                            <div class="col col-8 col-xs-12">
                                <div class="input-group">
                                    <cfinput type="text" name="stopaj_rate" id="stopaj_rate" value="#TLFormat(GET_PAYMENT_ROW.STOPAJ_RATE)#" required="yes" class="moneybox" onkeyup="return(FormatCurrency(this,event));" readonly>
                                    <span class="input-group-addon icon-ellipsis btnPointer" onclick="getStopajRate()"></span>
                                </div>
                            </div>
                        </div> 
                        <div class="form-group" id="item-stopaj_total">
                            <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='50038.Stopaj Tutarı'> *</label>
                            <div class="col col-8 col-xs-12">
                                <cfinput type="text" name="stopaj_total" id="stopaj_total" value="#TLFormat(GET_PAYMENT_ROW.STOPAJ_TOTAL)#" readonly required="yes" class="moneybox" onkeyup="return(FormatCurrency(this,event));">
                            </div> 
                        </div> 
                        <div class="form-group" id="item-net_total">
                            <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id="57642.Net Toplam"></label>
                            <div class="col col-8 col-xs-12">
                                <cfinput type="text" name="net_total" value="#TLFormat( GET_PAYMENT_ROW.AMOUNT - (DateDiff("d",GET_PAYMENT_ROW.ACTION_DATE,GET_PAYMENT_ROW.BANK_ACTION_DATE) * GET_PAYMENT_ROW.AMOUNT / GET_PAYMENT_ROW.DUE_VALUE) - GET_PAYMENT_ROW.STOPAJ_TOTAL)#" required="yes" class="moneybox" onkeyup="return(FormatCurrency(this,event));" readonly>
                            </div> 
                        </div>
                        <div class="form-group" id="item-action_detail">
                            <label class="col col-4 col-xs-12"><cfoutput>#getLang('main',217)#​</cfoutput></label>
                            <div class="col col-8 col-xs-12">
                                <textarea name="ACTION_DETAIL" id="ACTION_DETAIL"></textarea>
                            </div>
                        </div>
                        <div class="form-group" id="item-expense_item_id">
                            <label class="col col-4 col-xs-12"><cfoutput>#getLang('main',822)#</cfoutput> <cf_get_lang dictionary_id='57845.Tahsilat'>* </label>
                            <div class="col col-8 col-xs-12">
                                <cf_wrkExpenseItem width_info="150" fieldId="expense_item_id" fieldName="expense_item_name" form_name="add_interest_revenue" income_type_info="0" expense_item_id="#GET_PAYMENT_ROW.EXPENSE_ITEM_ID#" img_info="plus_thin">
                            </div> 
                        </div>
                        <div class="form-group" id="item-masraf_baslik">
                            <label class="col col-12 bold"><cfoutput>#getLang('main',1518)#</cfoutput></label>
                        </div>
                        <div class="form-group" id="item-masraf">
                            <label class="col col-4 col-xs-12"><cfoutput>#getLang('main',261)#</cfoutput></label>
                            <div class="col col-8 col-xs-12">
                                <cfinput type="text" name="masraf" class="moneybox"  value="#TLFormat(GET_PAYMENT_ROW.MASRAF)#" onkeyup="return(FormatCurrency(this,event));">
                            </div> 
                        </div>
                        <div class="form-group" id="item-expense_center_id">
                            <label class="col col-4 col-xs-12"><cfoutput>#getLang('main',1048)#</cfoutput></label>
                            <div class="col col-8 col-xs-12">
                                <cf_wrkExpenseCenter width_info="150" fieldId="expense_center_id" fieldName="expense_center_name" form_name="add_interest_revenue" expense_center_id="#GET_PAYMENT_ROW.expense_center_id#"  img_info="plus_thin">
                            </div> 
                        </div>
                    </div>
                    <div class="col col-4 col-md-5 col-sm-6 col-xs-12" type="column" index="2" sort="true">
                        <div class="form-group">  
                            <label class="col col-12 col-xs-12 bold" ><cf_get_lang dictionary_id='48714.İşlem Para Br'>*</label>
                        </div>
                        <div class="form-group">
                        <div class="col col-12 col-xs-12">
                            <cfscript>f_kur_ekle(action_id:GET_BANK_ACTION.BANK_ACTION_ID,process_type:1,base_value:'ACTION_VALUE',other_money_value:'OTHER_CASH_ACT_VALUE',form_name:'add_interest_revenue',action_table_name:'BANK_ACTION_MONEY',action_table_dsn:'#dsn2#',select_input:'from_account_id',is_disable='1');</cfscript>
                        </div>
                    </div>
                    </div>
                </cf_box_elements>
                <cf_box_footer>
                    <div class="col col-6">
                        <cf_record_info query_name="GET_PAYMENT_ROW">
                    </div>
                    <div class="col col-6">
                        <cf_workcube_buttons 
                            delete_page_url='#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.interest_revenue&event=del&bank_action_id=#GET_PAYMENT_ROW.bank_action_id#&row_id=#attributes.id#'
                            is_upd='1' 
                            add_function='kontrol'> 
                    </div>
                </cf_box_footer>
            </cfform>
        </cf_box>
    </div>
        <script>
            $('select#to_account_id').prop('disable', true);
            dateDiffHesapla('action_date');
            kur_ekle_f_hesapla('from_account_id');
            totalStopaj($("#stopaj_rate").val());
            var action_date = $("input[name=ACTION_DATE]").val();
            var bank_action_date = $("input[name=BANK_ACTION_DATE]").val();
            if(datediff(action_date,bank_action_date) > 0 ){
                $("#item-diff-day").show();
            }else{
                $("#item-diff-day").hide();
            }
            <cfif GET_PAYMENT_ROW.CHANGE_RATE eq 1>
                changeAmount();
            </cfif>
    
            function showPrincipals(){
                $("div#item-principal").toggle();
            }
    
            function getStopajRate(){
                bank_code = $("input#bank_code").val();
                windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_stoppage_rates&field_stoppage_rate=add_interest_revenue.stopaj_rate&field_decimal=2&bank_code='+bank_code+'&call_function=totalStopaj()','list');
            }
    
            function dateDiffHesapla(fieldName){
                var action_value = filterNum($("#ACTION_VALUE").val());
                var action_date = $("input[name=ACTION_DATE]").val();
                var bank_action_date = $("input[name=BANK_ACTION_DATE]").val();
                var day = datediff(action_date,bank_action_date);
                $("#day_diff").html(day); // gün farkı
    
                if(day > 0){
                    $("#item-diff-day, #day_diff_label").show();
                }else{
                    $("#item-diff-day, #day_diff_label").hide();
                }
    
                if(fieldName == 'action_date'){
                    $("#yield_loss").val(commaSplit((datediff(action_date,bank_action_date) * action_value) / <cfoutput>#GET_PAYMENT_ROW.DUE_VALUE#</cfoutput>,2)); // faiz kaybı
                    $("#total_action_value").val( commaSplit( action_value - ( (datediff(action_date,bank_action_date) * action_value) / <cfoutput>#GET_PAYMENT_ROW.DUE_VALUE#</cfoutput> ) ,2 ) ); // total getiri
                }else if(fieldName == 'total_action_value'){
                    $("#yield_loss").val(commaSplit( action_value - filterNum($("#total_action_value").val()) ,2)); // faiz kaybı
                }
                kur_ekle_f_hesapla('from_account_id');
                totalStopaj($("#stopaj_rate").val());
            }

            function changeAmount(){
                due_value = $("input[name=newDueValue]").val();
                rate = filterNum($("input[name=newYieldRate]").val());
                principal_new = filterNum($("input[name=principal]").val());
                action_date = $("input[name=ACTION_DATE]").val();
        
                $("div#item-LAST-ACTION_VALUE").show();
                $("input#last_ACTION_VALUE").prop('disabled', false);
        
                getiri_tutari =  ( ( rate / 100 ) / $("input[name=ygs]").val() )  * due_value * principal_new ;
                $("input[name=last_ACTION_VALUE]").val(commaSplit(getiri_tutari, <cfoutput>#session.ep.our_company_info.rate_round_num#</cfoutput>) );
                $("input[name=total_action_value]").val( commaSplit( filterNum($("input[name=last_ACTION_VALUE]").val()) - (datediff(action_date,$("input[name=BANK_ACTION_DATE]").val()) * filterNum($("input[name=last_ACTION_VALUE]").val()) / due_value) ),<cfoutput>#session.ep.our_company_info.rate_round_num#</cfoutput> );
                kur_ekle_f_hesapla('from_account_id');
                totalStopaj();
            }


            function totalStopaj(){
                var total_action_value = filterNum($("#total_action_value").val());
                var stopaj_rate = filterNum($("#stopaj_rate").val());
    
                $("#stopaj_total").val( commaSplit( (total_action_value * stopaj_rate) / 100, '2'));
                var stopaj_total = filterNum($("#stopaj_total").val());
    
                $("#net_total").val( commaSplit( total_action_value - stopaj_total , '2'));
    
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
            
            function kontrol(){
                if(!paper_control(add_interest_revenue.paper_number,'INCOMING_TRANSFER')) return false;
                if( $("#masraf").val() != '' || $("#masraf").val() > 0 ){
                    if( $("#expense_center_id").val() == '' && $("#expense_center_name").val() == ''){
                        alert("<cf_get_lang dictionary_id='48881.Masraf Merkezi Seçiniz'>!");
                        return false;
                    }
                }
                if( $("#stopaj_rate").val() == ''){
                    alert("<cf_get_lang dictionary_id='43192.Stopaj Oranı Girmelisiniz'>");
                        return false;
                }
                if( $("#stopaj_total").val() == ''){
                    alert("<cf_get_lang dictionary_id='57471.Eksik Veri'> "+':'+" <cf_get_lang dictionary_id='50038.Stopaj Tutarı'>");
                        return false;
                }
                if( $("#expense_center_id").val() == ''){
                    alert("<cf_get_lang dictionary_id='33459.Masraf Merkezi Seçiniz'>!");
                    return false;
                }
    
                <!--- var parameter = document.getElementById("bank_code").value + '*' + filterNum(document.getElementById("stopaj_rate").value);
    
                var get_acc_code = wrk_safe_query('get_acc_code','dsn2',0,parameter); 
    
                if(!get_acc_code.recordcount)
                { 
                    alert("Girdiğiniz Stopaj Oranında Banka Kodu Bulunamadı!");
                    return false;
                } --->
    
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
                    var currency_type = eval('document.add_interest_revenue.'+select_input+'.options[document.add_interest_revenue.'+select_input+'.selectedIndex]').value;
                
                var other_money_value_eleman= eval('document.add_interest_revenue.OTHER_CASH_ACT_VALUE');
                var temp_act,temp_base_act,rate1_eleman,rate2_eleman;
                if(doviz_tutar && ( other_money_value_eleman.value.length==0 || filterNum(other_money_value_eleman.value)==0) )
                {
                    other_money_value_eleman.value = '';
                    return false;
                }
                if(!doviz_tutar && eval('document.add_interest_revenue.ACTION_VALUE.value') != "" && currency_type != "")
                {
                    if(document.getElementById('currency_id') != undefined)
                        currency_type = document.getElementById('currency_id').value;
                    else
                        currency_type = list_getat(currency_type,2,';');
                    for(var i=1;i<=document.add_interest_revenue.kur_say.value;i++)
                    {
                        rate1_eleman = filterNum(eval('document.add_interest_revenue.txt_rate1_' + i).value,rate_round_num);
                        rate2_eleman = filterNum(eval('document.add_interest_revenue.txt_rate2_' + i).value,rate_round_num);
                        if( eval('document.add_interest_revenue.hidden_rd_money_'+i).value == currency_type)
                        {
                            temp_act=filterNum(document.add_interest_revenue.ACTION_VALUE.value)*rate2_eleman/rate1_eleman;
                            document.add_interest_revenue.system_amount.value = commaSplit(temp_act,rate_round_num);
                        }
                    }
                    if(document.add_interest_revenue.kur_say.value == 1)
                    {
                        for(var i=1;i<=document.add_interest_revenue.kur_say.value;i++)
                        {
                            rate1_eleman = filterNum(eval('document.add_interest_revenue.txt_rate1_' + i).value,rate_round_num);
                            rate2_eleman = filterNum(eval('document.add_interest_revenue.txt_rate2_' + i).value,rate_round_num);
                            if( eval('document.add_interest_revenue.rd_money.checked'))
                            {
                                if(eval('document.add_interest_revenue.hidden_rd_money_'+i).value == currency_type)
                                    other_money_value_eleman.value = commaSplit(filterNum(document.add_interest_revenue.total_action_value.value));
                                else
                                    other_money_value_eleman.value = commaSplit(filterNum(document.add_interest_revenue.system_amount.value,4)*(rate1_eleman/rate2_eleman));
                                document.add_interest_revenue.money_type.value = eval('document.add_interest_revenue.hidden_rd_money_'+i).value;
                                document.add_interest_revenue.system_amount.value = commaSplit(filterNum(document.add_interest_revenue.system_amount.value),rate_round_num);
                            }
                        }
                    }
                    else
                    {
                        for(var i=1;i<=document.add_interest_revenue.kur_say.value;i++)
                        {
                            rate1_eleman = filterNum(eval('document.add_interest_revenue.txt_rate1_' + i).value,rate_round_num);
                            rate2_eleman = filterNum(eval('document.add_interest_revenue.txt_rate2_' + i).value,rate_round_num);
                            if( eval('document.add_interest_revenue.rd_money['+(i-1)+'].checked'))
                            {
                                if(eval('document.add_interest_revenue.hidden_rd_money_'+i).value == currency_type)
                                    other_money_value_eleman.value = commaSplit(filterNum(document.add_interest_revenue.total_action_value.value));
                                else
                                    other_money_value_eleman.value = commaSplit(filterNum(document.add_interest_revenue.system_amount.value,4)*(rate1_eleman/rate2_eleman));
                                document.add_interest_revenue.money_type.value = eval('document.add_interest_revenue.hidden_rd_money_'+i).value;
                                document.add_interest_revenue.system_amount.value = commaSplit(filterNum(document.add_interest_revenue.system_amount.value),rate_round_num);
                            }
                        }
                    }
                }
                else if(doviz_tutar && document.add_interest_revenue.ACTION_VALUE.value != "" && currency_type != "")
                {
                    for(var i=1;i<=document.add_interest_revenue.kur_say.value;i++)
                        if( eval('document.add_interest_revenue.rd_money['+(i-1)+'].checked'))
                        {
                            rate1_eleman = filterNum(eval('document.add_interest_revenue.txt_rate1_' + i).value,rate_round_num);
                            if(document.getElementById('currency_id') != undefined)
                                currency_type = document.getElementById('currency_id').value;
                            else
                                currency_type = list_getat(currency_type,2,';');
                            if (eval('document.add_interest_revenue.hidden_rd_money_'+i).value != 'TL')//hesap TL olmayıp,kurdan TL seçilip,döviz inputu edit edilirse TL kurunu değiştirmesn diye
                                eval('document.add_interest_revenue.txt_rate2_' + i).value = commaSplit(filterNum(document.add_interest_revenue.system_amount.value)/filterNum(other_money_value_eleman.value)*rate1_eleman,rate_round_num);
                            else
                                for(var t=1;t<=add_interest_revenue.kur_say.value;t++)//hesap TL olmayıp,kurdan TL seçilip,döviz inputu edit edilirse TL kurunu değiştirmesn,hesabın kurunu değiştirsn diye
                                    if( eval('document.add_interest_revenue.hidden_rd_money_'+t).value == currency_type && eval('document.add_interest_revenue.hidden_rd_money_'+t).value != 'TL')
                                        eval('document.add_interest_revenue.txt_rate2_' + t).value = commaSplit(filterNum(other_money_value_eleman.value)/filterNum(add_interest_revenue.ACTION_VALUE.value)*rate1_eleman,rate_round_num);
                            if (eval('document.add_interest_revenue.hidden_rd_money_'+i).value != 'TL')
                                for(var k=1;k<=document.add_interest_revenue.kur_say.value;k++)
                                {
                                    rate1_eleman = filterNum(eval('document.add_interest_revenue.txt_rate1_' + k).value,rate_round_num);
                                    rate2_eleman = filterNum(eval('document.add_interest_revenue.txt_rate2_' + k).value,rate_round_num);
                                    if( eval('document.add_interest_revenue.hidden_rd_money_'+k).value == currency_type)
                                    {
                                        temp_act=filterNum(document.add_interest_revenue.ACTION_VALUE.value)*(rate2_eleman/rate1_eleman);
                                        document.add_interest_revenue.system_amount.value = commaSplit(temp_act,rate_round_num);
                                    }
                                }
                            else
                                document.add_interest_revenue.system_amount.value = other_money_value_eleman.value;
                        }
                        return true;
                    }
                
                    document.add_interest_revenue.ACTION_VALUE.value = commaSplit(filterNum(document.add_interest_revenue.ACTION_VALUE.value));
                
                return true;
            }
            else
            {
                if(document.add_interest_revenue.kur_say.value == 1)
                {
                    for(var i=1;i<=document.add_interest_revenue.kur_say.value;i++)
                        if( eval('document.add_interest_revenue.rd_money.checked'))
                            document.add_interest_revenue.money_type.value = eval('document.add_interest_revenue.hidden_rd_money_'+i).value;
                }
                else
                {
                    for(var i=1;i<=document.add_interest_revenue.kur_say.value;i++)
                        if( eval('document.add_interest_revenue.rd_money['+(i-1)+'].checked'))
                            document.add_interest_revenue.money_type.value = eval('document.add_interest_revenue.hidden_rd_money_'+i).value;
                }	
            }
        }
        </script>