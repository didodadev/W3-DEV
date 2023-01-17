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
		PROCESS_TYPE = 2931
</cfquery>

<cfquery name="GET_PAYMENT_ROW" datasource="#dsn2#">
    SELECT
        *,
        SYPR.PAPER_NO AS PP_NO,
        BA.EXPENSE_ITEM_ID,
        BA.ACTION_TYPE_ID,
        BA.ACTION_FROM_ACCOUNT_ID,
        BA.OTHER_CASH_ACT_VALUE,
        SS.ACCOUNT_CODE
    FROM
        #DSN3_alias#.STOCKBONDS_YIELD_PLAN_ROWS SYPR
        RIGHT JOIN #DSN3_alias#.STOCKBONDS AS ST ON ST.STOCKBOND_ID = SYPR.STOCKBOND_ID
        LEFT JOIN #DSN3_alias#.STOCKBONDS_SALEPURCHASE_ROW AS SSR ON SSR.STOCKBOND_ID = ST.STOCKBOND_ID 
        LEFT JOIN #DSN3_alias#.STOCKBONDS_SALEPURCHASE AS SS ON SS.ACTION_ID = SSR.SALES_PURCHASE_ID
        LEFT JOIN BANK_ACTIONS BA ON SYPR.BANK_ACTION_ID = BA.ACTION_ID
    WHERE 
        SYPR.YIELD_PLAN_ROWS_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.yield_plan_row_id#">
</cfquery>
<cf_xml_page_edit fuseact="credit.list_stockbonds">
<cfquery name="get_rows" datasource="#dsn3#">
    SELECT YIELD_PLAN_ROWS_ID FROM STOCKBONDS_YIELD_PLAN_ROWS WHERE STOCKBOND_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#GET_PAYMENT_ROW.stockbond_id#">
</cfquery> 
<cfquery name="get_reeskont_values" datasource="#dsn3#">
        SELECT SUM(STOCKBONDS_VALUATION_AMOUNT) AS TOTAL_REESKONT FROM STOCKBONDS_YIELD_VALUATION WHERE STOCKBONDS_ROWS_ID IN (#valuelist(get_rows.YIELD_PLAN_ROWS_ID)#)
</cfquery>
<cfif len(get_reeskont_values.TOTAL_REESKONT)>
    <cfset reeskont_values = get_reeskont_values.recordcount>
<cfelse>
    <cfset reeskont_values = 0>
</cfif>
<cfif len(GET_PAYMENT_ROW.COMPANY_ID)>
    <cfquery name="get_currency_money_comp" datasource="#dsn#">
        SELECT MONEY FROM COMPANY_CREDIT WHERE COMPANY_ID = '#GET_PAYMENT_ROW.COMPANY_ID#'
    </cfquery>
</cfif>

<cfsavecontent variable="message"><cf_get_lang dictionary_id='40997'></cfsavecontent>
<cfset pagehead="#message#">
<cf_catalystHeader>
    <cf_papers paper_type="incoming_transfer">
<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
    <cf_box>
        <cfform name="add_interest_revenue" method="post" action="">
            <input type="hidden" name="active_period" id="active_period" value="<cfoutput>#session.ep.period_id#</cfoutput>">
            <input type="hidden" name="ACTION_TYPE" id="ACTION_TYPE" value="<cf_get_lang dictionary_id = '40997.Menkul Kıymet Alış Hesapa Geçiş'>">
            <input type="hidden" name="row_id" id="row_id" value="<cfoutput>#attributes.yield_plan_row_id#</cfoutput>">
            <input type="hidden" name="expense_center_id" id="expense_center_id" value="<cfoutput>#GET_PAYMENT_ROW.ROW_EXP_CENTER_ID#</cfoutput>">
            <input type="hidden" name="acc_tahakkuk_code" id="acc_tahakkuk_code" value="<cfoutput>#attributes.acc_tahakkuk_code#</cfoutput>">
            <input type="hidden" name="my_company_id" id="my_company_id" value="<cfoutput>#GET_PAYMENT_ROW.COMPANY_ID#</cfoutput>">
            <input type="hidden" name="total_purchase" id="total_purchase" value="<cfoutput>#TLFormat(GET_PAYMENT_ROW.TOTAL_PURCHASE)#</cfoutput>">
            <input type="hidden" name="xml_net_or_brut" id="xml_net_or_brut" value="<cfoutput>#xml_net_or_brut#</cfoutput>">
            <cfif len(GET_PAYMENT_ROW.COMPANY_ID) and get_currency_money_comp.recordcount>
                <input type="hidden" name="currency_comp_id" id="currency_comp_id" value="<cfoutput>#get_currency_money_comp.MONEY#</cfoutput>">
            </cfif>
            <cfset toplam_tutar = 0>
            <cf_box_elements>
                <div class="col col-4 col-md-5 col-sm-6 col-xs-12" type="column" index="1" sort="true">
                    <div class="form-group" id="item-process_cat">
                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57800.Islem Tipi'>*</label>
                        <div class="col col-7 col-xs-12">
                                <cf_workcube_process_cat process_cat="#get_process_type.PROCESS_CAT_ID#">
                        </div>
                    </div>
                    <div class="form-group" id="item-paper_number">
                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57880.Belge No'></label>
                        <div class="col col-7 col-xs-12">
                            <cfinput type="text" name="paper_number" readonly="readonly" value="#GET_PAYMENT_ROW.PP_NO#" maxlength="50">
                        </div>
                    </div>
                    <div class="form-group" id="item-ACTION_DATE">
                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='48897.Hesaba Geçiş Tarihi'>*</label>
                        <div class="col col-7 col-xs-12">
                            <div class="input-group">
                                <input type="text" name="ACTION_DATE" required="yes" value="<cfif len(GET_PAYMENT_ROW.ACTION_DATE)><cfoutput>#dateformat(now(),dateformat_style)#</cfoutput><cfelse><cfoutput>#dateformat(now(),dateformat_style)#</cfoutput></cfif>" message="<cfoutput>#getLang('','Hesaba Geçiş Tarihi Giriniz','56313')#</cfoutput>">
                                <span class="input-group-addon"><cf_wrk_date_image date_field="ACTION_DATE"></span>
                            </div>
                        </div>
                    </div>
                    <div class="form-group" id="item-acc_code">
                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='32633.Hesap Kodu'></label>
                        <div class="col col-7 col-xs-12">
                            <div class="input-group">
                            <cf_wrk_account_codes form_name='add_interest_revenue' account_code='acc_id' account_name='acc_name' search_from_name='1'>	
                                <input type="hidden" name="acc_id" id="acc_id" value="<cfoutput>#GET_PAYMENT_ROW.ACCOUNT_CODE#</cfoutput>">
                                <cfinput type="text" name="acc_name" id="acc_name" value="#GET_PAYMENT_ROW.ACCOUNT_CODE#" onkeyup="get_wrk_acc_code_1();" onFocus="AutoComplete_Create('acc_name','ACCOUNT_CODE','ACCOUNT_CODE,ACCOUNT_NAME','get_account_code','\'0\',0','ACCOUNT_CODE','acc_id','add_interest_revenue','3','120');" autocomplete="off">
                                <span class="input-group-addon icon-ellipsis btnPointer" title="<cf_get_lang dictionary_id='57734.Seçiniz'>" onClick="openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_account_plan&field_name=add_interest_revenue.acc_name&field_id=add_interest_revenue.acc_id');"></span>
                            </div>
                        </div> 
                    </div> 
                    <div class="form-group" id="item-to_account_id">
                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='63827.Getiriyi Banka Hesabına Geçir'></label>
                        <div class="col col-7 col-xs-12">
                            <input type="checkbox" name="yield_to_bank" id="yield_to_bank" onclick="showPrincipals()" value="1" <cfif GET_PAYMENT_ROW.YIELD_TO_BANK eq 1>checked</cfif>>
                        </div> 
                    </div>
                    <div class="form-group" id="item-from_account_id" <cfif GET_PAYMENT_ROW.YIELD_TO_BANK neq 1>style="display:none;"</cfif>>
                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='29449.Banka Hesabı'></label>
                        <div class="col col-7 col-xs-12">
                            <cf_wrkBankAccounts fieldId='from_account_id' call_function='kur_ekle_f_hesapla' width='285' selected_value='#GET_PAYMENT_ROW.BANK_ACC_ID#'>
                        </div> 
                    </div> 
                    <div class="form-group" id="item-expense_item_id">
                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='64475.Bütçe Kalemi Tahsilat'> * </label>
                        <div class="col col-7 col-xs-12">
                            <cf_wrkExpenseItem width_info="150" fieldId="expense_item_id" fieldName="expense_item_name" form_name="add_interest_revenue" income_type_info="0" expense_item_id="#GET_PAYMENT_ROW.ROW_EXP_TAHAKKUK_ITEM_ID#" img_info="plus_thin">
                        </div> 
                    </div>
                    <cfif get_reeskont_values.TOTAL_REESKONT gt 0 >
                    <div class="form-group" id="item-yield_loss">
                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='63828.Toplam Reeskont Değeri'></label>
                        <div class="col col-7 col-xs-12">
                            <cfinput type="text" id="total_reeskont" name="total_reeskont" value="#TLFormat(get_reeskont_values.TOTAL_REESKONT)#" class="moneybox" onkeyup="return(FormatCurrency(this,event));" readonly>
                        </div> 
                    </div>
                    </cfif>
                    <div class="form-group" id="item-getiri_tutari">
                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id="51374.Getiri Tutarı"></label>
                        <div class="col col-7 col-xs-12">
                            <cfinput type="text" name="ACTION_VALUE" value="#TLFormat(GET_PAYMENT_ROW.AMOUNT)#" required="yes" class="moneybox" onkeyup="return(FormatCurrency(this,event));" readonly>
                        </div> 
                    </div>
                    <div class="form-group" id="item-OTHER_CASH_ACT_VALUE">
                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='58056.Dövizli Tutar'></label>
                        <div class="col col-7 col-xs-12">
                            <cfinput type="text" name="OTHER_CASH_ACT_VALUE" value="#TLFormat(GET_PAYMENT_ROW.OTHER_CASH_ACT_VALUE)#" readonly style="width:150px;" class="moneybox" onBlur="kur_ekle_f_hesapla('from_account_id',true);" onkeyup="return(FormatCurrency(this,event));">
                        </div> 
                    </div>
                    <div class="form-group" id="item-stopaj_rate">
                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='32930.Stopaj Oranı'>% *</label>
                        <div class="col col-7 col-xs-12">
                            <div class="input-group">
                                <cfinput type="hidden" name="field_stoppage_rate_id" id="field_stoppage_rate_id" value="#GET_PAYMENT_ROW.STOPAJ_ID#">
                                <cfinput type="text" name="stopaj_rate" id="stopaj_rate" value="#TLFormat(GET_PAYMENT_ROW.STOPAJ_RATE)#" required="yes" class="moneybox" onkeyup="totalStopaj();return(FormatCurrency(this,event));" readonly>
                                <span class="input-group-addon icon-ellipsis btnPointer" onclick="getStopajRate()"></span>
                            </div>
                        </div>
                    </div> 
                    <div class="form-group" id="item-stopaj_total">
                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='50038.Stopaj Tutarı'> *</label>
                        <div class="col col-7 col-xs-12">
                            <cfinput type="text" name="stopaj_total" id="stopaj_total" value="#TLFormat(GET_PAYMENT_ROW.STOPAJ_TOTAL)#" readonly required="yes" class="moneybox" onkeyup="return(FormatCurrency(this,event));">
                        </div> 
                    </div> 
                    <cfif xml_net_or_brut neq 1>
                        <div class="form-group" id="item-com_exp_center_id">
                            <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='50038.Stopaj Tutarı'><cf_get_lang_main no='1048.Masraf Merkezi'></label>
                            <div class="col col-7 col-xs-12">
                                <cf_wrkExpenseCenter fieldId="stoppage_expense_center_id" fieldName="stoppage_expense_center_name" form_name="add_interest_revenue" expense_center_id="#GET_PAYMENT_ROW.STOPPAGE_EXP_CENTER_ID#" img_info="plus_thin">
                            </div>
                        </div>
                        <div class="form-group" id="item-stoppage_exp_item_id">
                            <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='50038.Stopaj Tutarı'><cf_get_lang_main no ='1139.Gider Kalemi'></label>
                            <div class="col col-7 col-xs-12">
                                <cf_wrkExpenseItem fieldId="stoppage_expense_item_id" fieldName="stoppage_expense_item_name" form_name="add_interest_revenue" income_type_info="0" expense_item_id="#GET_PAYMENT_ROW.STOPPAGE_EXP_ITEM_ID#" img_info="plus_thin">
                            </div>
                        </div>
                    </cfif>
                    <div class="form-group" id="item-net_total">
                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id="57642.Net Toplam"></label>
                        <div class="col col-7 col-xs-12">
                            <cfinput type="text" name="net_total" value="#TLFormat(GET_PAYMENT_ROW.NET_TOTAL)#" required="yes" class="moneybox" onkeyup="return(FormatCurrency(this,event));">
                        </div> 
                    </div>
                    <div class="form-group" id="item-action_detail">
                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57629.Açıklama'></label>
                        <div class="col col-7 col-xs-12">
                            <textarea name="ACTION_DETAIL" id="ACTION_DETAIL"><cfoutput>#GET_PAYMENT_ROW.ACTION_DETAIL#</cfoutput></textarea>
                        </div>
                    </div>
                </div>
                <div class="col col-4 col-md-5 col-sm-6 col-xs-12" type="column" index="2" sort="true">
                    <div class="form-group">
                        <label class="bold"><cf_get_lang dictionary_id='48714.İşlem Para Br'></label>
                        <cfscript>f_kur_ekle(action_id:URL.yield_plan_row_id,process_type:1,base_value:'ACTION_VALUE',other_money_value:'OTHER_CASH_ACT_VALUE',form_name:'add_interest_revenue',action_table_name:'BANK_ACTION_MONEY',action_table_dsn:'#dsn2#',select_input:'from_account_id',is_disable='1');</cfscript>
                    </div>
                    <div class="form-group">
                        <label class="col col-4 col-xs-12"></label>
                        <div class="col col-7 col-xs-12">
                        </div> 
                    </div>
                    <div class="form-group">
                        <label class="col col-4 col-xs-12"></label>
                        <div class="col col-7 col-xs-12">
                        </div> 
                    </div>
                    <div class="form-group" id="item-commision_rate">
                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='35334.Komisyon Oranı'>%</label>
                        <div class="col col-7 col-xs-12">
                            <cfinput type="text" name="commision_rate" id="commision_rate" value="#TLFormat(GET_PAYMENT_ROW.COMMISION_RATE)#" class="moneybox" onblur="comHesapla('rate')" onkeyup="return(FormatCurrency(this,event));">
                        </div> 
                    </div> 
                    <div class="form-group" id="item-stopaj_total">
                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='40325.Komisyon Tutari'></label>
                        <div class="col col-7 col-xs-12">
                            <cfinput type="text" name="commision_amount" id="commision_amount" value="#TLFormat(GET_PAYMENT_ROW.COMMISION_AMOUNT)#" class="moneybox" onblur="comHesapla('amount')" onkeyup="return(FormatCurrency(this,event));">
                        </div> 
                    </div> 
                    <div class="form-group" id="item-com_exp_center_id">
                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='58791.Komisyon'><cf_get_lang_main no='1048.Masraf Merkezi'></label>
                        <div class="col col-7 col-xs-12">
                            <cf_wrkExpenseCenter fieldId="com_exp_center_id" fieldName="com_exp_center" form_name="add_interest_revenue" expense_center_id="#GET_PAYMENT_ROW.COMMISION_EXP_CENTER_ID#" img_info="plus_thin">
                        </div>
                    </div>
                    <div class="form-group" id="item-com_exp_item_id">
                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='58791.Komisyon'><cf_get_lang_main no ='1139.Gider Kalemi'></label>
                        <div class="col col-7 col-xs-12">
                            <cf_wrkExpenseItem fieldId="com_exp_item_id" fieldName="com_exp_item_name" form_name="add_interest_revenue" income_type_info="0" expense_item_id="#GET_PAYMENT_ROW.COMMISION_EXP_ITEM_ID#" img_info="plus_thin">
                        </div>
                    </div>
                </div>
            </cf_box_elements>
            <cf_box_footer>
                <cf_record_info query_name="GET_PAYMENT_ROW">
                <cf_workcube_buttons 
                    delete_page_url='#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.list_stockbonds&event=del&bank_action_id=#GET_PAYMENT_ROW.bank_action_id#&row_id=#attributes.yield_plan_row_id#'
                    is_upd='1' 
                    add_function='kontrol'> 
            </cf_box_footer>
        </cfform>
    </cf_box>
</div>
    <script>
        kur_ekle_f_hesapla('acc_id');
        if(document.getElementById('currency_comp_id') != undefined)
        document.getElementById('currency_id').value = document.getElementById('currency_comp_id').value;

        function open_exp_item()
        {
            if (!chk_process_cat('add_interest_revenue')) return false;
            var selected_ptype = document.add_interest_revenue.process_cat.options[document.add_interest_revenue.process_cat.selectedIndex].value;
            eval('var proc_control = document.add_interest_revenue.ct_process_type_'+selected_ptype+'.value');
            if(proc_control == 243)
                windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_exp_item&field_id=add_interest_revenue.expense_item_id&field_name=add_interest_revenue.expense_item_name','list');
            else
                windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_exp_item&field_id=add_interest_revenue.expense_item_id&field_name=add_interest_revenue.expense_item_name&is_income=1','list');
        }
  
        function change_currency_info()
        {
            new_kur_say = document.all.kur_say.value;
            for(var i=1;i<=new_kur_say;i++)
            {
                if(eval('document.all.hidden_rd_money_'+i) != undefined && eval('document.all.hidden_rd_money_'+i).value == document.getElementById('currency_id2').value)
                    eval('document.all.rd_money['+(i-1)+']').checked = true;
            }
            kur_ekle_f_hesapla('acc_id');
        }

        function getStopajRate(){
            var bank_code = '';
            if( $("#yield_to_bank").is(':checked') ){
                bank_code = $("input#bank_code").val()
            }
            windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_stoppage_rates&field_stoppage_rate=add_interest_revenue.stopaj_rate&field_stoppage_rate_id=add_interest_revenue.field_stoppage_rate_id&field_decimal=2&bank_code='+bank_code+'&call_function=totalStopaj()','list');
        }

        function comHesapla(val){
            if(val == 'rate'){
                commision_rate = filterNum(document.getElementById("commision_rate").value,'<cfoutput>#session.ep.our_company_info.rate_round_num#</cfoutput>');
                document.getElementById("commision_amount").value = commaSplit(filterNum(document.getElementById("ACTION_VALUE").value,'<cfoutput>#session.ep.our_company_info.rate_round_num#</cfoutput>') * commision_rate / 100,'<cfoutput>#session.ep.our_company_info.rate_round_num#</cfoutput>');
            }else{
                commision_amount = filterNum(document.getElementById("commision_amount").value,'<cfoutput>#session.ep.our_company_info.rate_round_num#</cfoutput>');
                document.getElementById("commision_rate").value = commaSplit( commision_amount * 100 / filterNum( document.getElementById("ACTION_VALUE").value,'<cfoutput>#session.ep.our_company_info.rate_round_num#</cfoutput>' ) ,'<cfoutput>#session.ep.our_company_info.rate_round_num#</cfoutput>');
            }
            
        }

        function totalStopaj(){
            var total_action_value = filterNum($("#ACTION_VALUE").val());
            var stopaj_rate = filterNum($("#stopaj_rate").val());

            $("#stopaj_total").val( commaSplit( (total_action_value * stopaj_rate) / 100, '2'));
            var stopaj_total = filterNum($("#stopaj_total").val());

            $("#net_total").val( commaSplit( total_action_value - stopaj_total , '2'));
        }

        function showPrincipals(){
            $("div#item-from_account_id").toggle();
        }
        
        function kontrol(){
            if(!paper_control(add_interest_revenue.paper_number,'INCOMING_TRANSFER')) return false;
            if( $("#stopaj_rate").val() == ''){
                alert("<cf_get_lang dictionary_id='43192.Stopaj Oranı Girmelisiniz'>");
                    return false;
            }
            if( $("#stopaj_total").val() == ''){
                alert("<cf_get_lang dictionary_id='57471.Eksik Veri'> "+':'+" <cf_get_lang dictionary_id='50038.Stopaj Tutarı'>");
                    return false;
            }
            if( $("#expense_item_id").val() == ''){
                alert("<cf_get_lang dictionary_id='49131.Bütçe Kalemi Girmelisiniz'>");
                return false;
            }
            <cfif xml_net_or_brut neq 1>
                if( $("#stoppage_expense_item_id").val() == ''){
                    alert("<cf_get_lang dictionary_id='49131.Bütçe Kalemi Girmelisiniz'>");
                    return false;
                }
            </cfif>
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
            if(document.getElementById('currency_comp_id') != undefined)
                var currency_type = document.getElementById('currency_comp_id').value;
            else if(document.getElementById('currency_id') != undefined)
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
                if(document.getElementById('currency_comp_id') != undefined)
                    currency_type = document.getElementById('currency_comp_id').value;
                else if(document.getElementById('currency_id') != undefined)
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
                                other_money_value_eleman.value = commaSplit(filterNum(document.add_interest_revenue.ACTION_VALUE.value));
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
                                other_money_value_eleman.value = commaSplit(filterNum(document.add_interest_revenue.ACTION_VALUE.value));
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
                        if(document.getElementById('currency_comp_id') != undefined)
                             currency_type = document.getElementById('currency_comp_id').value;
                        else if(document.getElementById('currency_id') != undefined)
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