<cf_date tarih="attributes.currentDate">
<cf_papers paper_type="mkdad">
<cfquery name="get_process_type" datasource="#dsn3#">
    SELECT 
        PROCESS_TYPE,
        IS_CARI,
        IS_ACCOUNT,
        IS_BUDGET,
        IS_ACCOUNT_GROUP,
        NEXT_PERIODS_ACCRUAL_ACTION,
        ACCRUAL_BUDGET_ACTION,
        ACTION_FILE_NAME,
        ACTION_FILE_FROM_TEMPLATE
     FROM 
         SETUP_PROCESS_CAT 
    WHERE 
        PROCESS_CAT_ID = #attributes.process_cat#
</cfquery>
<cfscript>
    process_type = get_process_type.PROCESS_TYPE;
    is_account = get_process_type.IS_ACCOUNT;
    is_budget = get_process_type.IS_BUDGET;
    is_account_group = get_process_type.IS_ACCOUNT_GROUP;
    to_branch_id_info = listgetat(session.ep.user_location,2,'-'); //borclu sube
    from_branch_id_info = listgetat(session.ep.user_location,2,'-'); //alacakli sube
    currency_multiplier = 1;
    masraf_curr_multiplier = 1;
    dovizli_islem_multiplier = 1;
    if(isDefined('form.deger_get_money') and len(form.deger_get_money))

    for(j=1;j lte listlen(attributes.Allrow); j=j+1){

        for(mon=1;mon lte form.deger_get_money;mon=mon+1)
        {
            if(evaluate("form.hidden_rd_money_#mon#") is session.ep.money2)
                currency_multiplier = evaluate('form.value_rate2#mon#/form.txt_rate1_#mon#');
            if(evaluate("form.hidden_rd_money_#mon#") is listgetat(attributes.Moneytype,j,','))
                masraf_curr_multiplier = evaluate('form.value_rate2#mon#/form.txt_rate1_#mon#');
            if(evaluate("form.hidden_rd_money_#mon#") is listgetat(attributes.Moneytype,j,','))
                dovizli_islem_multiplier = evaluate('form.value_rate2#mon#/form.txt_rate1_#mon#');
        }
        
    }

    str_card_detail = ArrayNew(2);
    acc_branch_list_borc = '';
    acc_branch_list_alacak = '';
    str_borclu_hesaplar = '';
    str_tutarlar = '';
    str_borclu_other_amount_tutar = '';
    str_borclu_other_currency = '';
    str_alacakli_hesaplar = '';
    str_alacakli_tutarlar = '';
    str_alacakli_other_amount_tutar = '';
    str_alacakli_other_currency = '';
</cfscript>

<cftransaction>
    <cftry>
    <cfset history_id = listGetAt(attributes.Allrow,1)>
    <cfoutput query="get_stockbonds_dad">
        <!--- <cfdump var="#get_stockbonds_dad#" abort> --->
        <cfif len(IS_DAD_LAST_ACTUAL_VALUE) and len(LAST_ACTUAL_VALUE)>
            <cfset total_dad = ( LAST_ACTUAL_VALUE - IS_DAD_LAST_ACTUAL_VALUE ) * ReplaceNoCase(NET_QUANTITY,'.',',','all')>
        <cfelseif len(LAST_ACTUAL_VALUE)>
            <cfset total_dad = ( LAST_ACTUAL_VALUE - PURCHASE_VALUE ) * ReplaceNoCase(NET_QUANTITY,'.',',','all') >
        </cfif>

        <cfquery name="GET_LAST_VALUE_CHANGES" datasource="#dsn2#">
            SELECT HISTORY_ID FROM #dsn3#.STOCKBONDS_VALUE_CHANGES WHERE HISTORY_ID = #listGetAt(attributes.Allrow,currentrow)#
        </cfquery>
        
        <cfquery name="UPD_VALUE_CHANGES" datasource="#dsn2#">
            UPDATE #dsn3#.STOCKBONDS_VALUE_CHANGES 
                   SET IS_DAD_ACCOUNT = 1,
                       IS_DAD_ACCOUNT_DATE = #attributes.currentDate#, 
                       IS_DAD_ACTION_ID = #history_id#
            WHERE HISTORY_ID = #GET_LAST_VALUE_CHANGES.HISTORY_ID#
        </cfquery>
         <!--- Belge No update ediliyor --->
         <cfquery name="UPD_GENERAL_PAPERS" datasource="#DSN2#">
            UPDATE 
                #dsn3_alias#.GENERAL_PAPERS
            SET
                MKDAD_NUMBER = #paper_number#
            WHERE
                MKDAD_NUMBER IS NOT NULL
        </cfquery>
      
        <cfscript>
            if(total_dad > 0){
                str_borclu_hesaplar = listAppend(str_borclu_hesaplar,get_stockbonds_dad.ACCOUNT_CODE,',');
                str_tutarlar = listAppend(str_tutarlar,total_dad,',');
                str_borclu_other_amount_tutar = listAppend(str_borclu_other_amount_tutar,total_dad,',');
                str_borclu_other_currency = listAppend(str_borclu_other_currency,listGetAt(attributes.Moneytype,currentrow),',');

                str_alacakli_hesaplar = listAppend(str_alacakli_hesaplar,attributes.acc_id,',');
                str_alacakli_tutarlar = listAppend(str_alacakli_tutarlar,total_dad,',');
                str_alacakli_other_amount_tutar = listAppend(str_alacakli_other_amount_tutar,total_dad,',');
                str_alacakli_other_currency = listAppend(str_alacakli_other_currency,listGetAt(attributes.Moneytype,currentrow),',');

                acc_branch_list_alacak = listappend(acc_branch_list_alacak,from_branch_id_info,',');
                acc_branch_list_borc = listappend(acc_branch_list_borc,to_branch_id_info,',');

                str_card_detail[1][listlen(str_tutarlar)]= 'Menkul Kıymet Değer Artışları';
                str_card_detail[2][listlen(str_alacakli_tutarlar)]= 'Menkul Kıymet Değer Artışları';
            }else{
    
                str_borclu_hesaplar = listAppend(str_borclu_hesaplar,attributes.acc_id_azalis,',');
                str_tutarlar = listAppend(str_tutarlar,abs(total_dad),',');
                str_borclu_other_amount_tutar = listAppend(str_borclu_other_amount_tutar,abs(total_dad),',');
                str_borclu_other_currency = listAppend(str_borclu_other_currency,listGetAt(attributes.Moneytype,currentrow),',');

                str_alacakli_hesaplar = listAppend(str_alacakli_hesaplar,get_stockbonds_dad.ACCOUNT_CODE,',');
                str_alacakli_tutarlar = listAppend(str_alacakli_tutarlar,abs(total_dad),',');
                str_alacakli_other_amount_tutar = listAppend(str_alacakli_other_amount_tutar,abs(total_dad),',');
                str_alacakli_other_currency = listAppend(str_alacakli_other_currency,listGetAt(attributes.Moneytype,currentrow),',');

                acc_branch_list_alacak = listappend(acc_branch_list_alacak,from_branch_id_info,',');
                acc_branch_list_borc = listappend(acc_branch_list_borc,to_branch_id_info,',');

                str_card_detail[1][listlen(str_tutarlar)]= 'Menkul Kıymet Değer Düşüşleri';
                str_card_detail[2][listlen(str_alacakli_tutarlar)]= 'Menkul Kıymet Değer Düşüşleri';

            }

            if( total_dad gt 0 and is_budget eq 1) {

                butceci(
                    action_id : history_id,
                    muhasebe_db : dsn2,
                    is_income_expense : true,
                    process_type : process_type,
                    nettotal : wrk_round(total_dad),
                    other_money_value : wrk_round(total_dad),
                    action_currency : listGetAt(attributes.Moneytype,currentrow),
                    currency_multiplier : currency_multiplier,
                    expense_date : attributes.currentDate,
                    expense_center_id : attributes.expense_center_id,
                    expense_item_id : attributes.expense_item_masraf_id,
                    detail : 'Menkul Kıymet Değerleme İşlemi',
                    branch_id : from_branch_id_info,
                    paper_no : attributes.paper_number,
                    insert_type : 1
                );
            } 
            
            if( total_dad lt 0 and is_budget eq 1) {

                butceci(
                    action_id : history_id,
                    muhasebe_db : dsn2,
                    is_income_expense : false,
                    process_type : process_type,
                    nettotal : wrk_round(abs(total_dad)),
                    other_money_value : wrk_round(abs(total_dad)),
                    action_currency : listGetAt(attributes.Moneytype,currentrow),
                    currency_multiplier : currency_multiplier,
                    expense_date : attributes.currentDate,
                    expense_center_id : attributes.expense_center_id,
                    expense_item_id : attributes.expense_item_masraf_gider_id,
                    detail : 'Menkul Kıymet Değerleme İşlemi',
                    branch_id : from_branch_id_info,
                    paper_no : attributes.paper_number,
                    insert_type : 1
                );
            }
        </cfscript>
    </cfoutput>
        <cfscript>
            if( is_account eq 1) {
                muhasebeci(
                    action_id: history_id,
                    workcube_process_type:get_process_type.PROCESS_TYPE,
                    workcube_process_cat:attributes.process_cat,
                    account_card_type:13,
                    islem_tarihi: attributes.currentDate,
                    fis_satir_detay:str_card_detail,
                    borc_hesaplar:str_borclu_hesaplar,
                    borc_tutarlar:str_tutarlar,
                    other_amount_borc : str_borclu_other_amount_tutar,
                    other_currency_borc : str_borclu_other_currency,
                    alacak_hesaplar:str_alacakli_hesaplar,
                    alacak_tutarlar:str_alacakli_tutarlar,
                    other_amount_alacak : str_alacakli_other_amount_tutar,
                    other_currency_alacak : str_alacakli_other_currency,
                    currency_multiplier : currency_multiplier,
                    fis_detay : 'Menkul Kıymet Değerleme İşlemi',
                    acc_branch_list_borc : acc_branch_list_borc,
                    acc_branch_list_alacak : acc_branch_list_alacak,
                    belge_no : '#attributes.paper_number#',
                    is_account_group : is_account_group
                );
            }
        </cfscript>
        <cfcatch>
            <script>
                alert("Değerleme İşlemi Yapılırken Bir Hata Oluştu!");
            </script>
            <cfabort>
        </cfcatch>
    </cftry>
</cftransaction>