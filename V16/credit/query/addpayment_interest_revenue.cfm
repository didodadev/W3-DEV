<cfif form.active_period neq session.ep.company_id>
    <script type="text/javascript">
        alert("<cf_get_lang_main no='1659.İşlem Yapmak İstediğiniz Muhasebe Dönemi ile Aktif Muhasebe Döneminiz Farklı Muhasebe Döneminizi Kontrol Ediniz'>!");
        window.location.href='<cfoutput>#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.list_bank_actions</cfoutput>';
    </script>
    <cfabort>
</cfif>
    <cfquery name="get_process_type" datasource="#dsn3#">
        SELECT 
            PROCESS_TYPE,
            IS_CARI,
            IS_ACCOUNT,
            IS_BUDGET,
            IS_ACCOUNT_GROUP,
            ACTION_FILE_NAME,
            ACTION_FILE_FROM_TEMPLATE
        FROM 
            SETUP_PROCESS_CAT 
        WHERE 
            PROCESS_CAT_ID = #form.process_cat#
    </cfquery>
    <cfquery name="get_acc_code_exp" datasource="#dsn2#">
        SELECT 
            ACCOUNT_CODE
        FROM 
            EXPENSE_ITEMS 
        WHERE 
            EXPENSE_ITEM_ID = '#attributes.expense_item_id#'
    </cfquery>

    <cfset get_acc_code_expense_item = get_acc_code_exp.ACCOUNT_CODE>
    <cfset attributes.stopaj_rate = filterNum(attributes.stopaj_rate)>
    <cfset attributes.stopaj_total = filterNum(attributes.stopaj_total)>
    <cfset attributes.net_total = filterNum(attributes.net_total)>
    <cfif len(attributes.commision_rate) and attributes.commision_rate gt 0 and len(attributes.commision_amount) and attributes.commision_amount gt 0>
        <cfset attributes.commision_rate = filterNum(attributes.commision_rate)>
        <cfset attributes.commision_amount = filterNum(attributes.commision_amount)>
        <cfquery name="get_com_exp_item_id" datasource="#dsn2#">
            SELECT ACCOUNT_CODE FROM EXPENSE_ITEMS WHERE EXPENSE_ITEM_ID = #attributes.com_exp_item_id#
        </cfquery>
        <cfset get_com_exp_item_id = get_com_exp_item_id.ACCOUNT_CODE>
    </cfif>
    <cfif isdefined("attributes.my_company_id") and len(attributes.my_company_id)>
        <cfset my_acc_result = get_company_period(attributes.my_company_id)>
    </cfif>
    <cfquery name="get_acc_code_exp" datasource="#dsn2#">
        SELECT ACCOUNT_CODE FROM EXPENSE_ITEMS WHERE EXPENSE_ITEM_ID = #attributes.acc_tahakkuk_code#
    </cfquery>
    <cfset acc_tahakkuk_code = get_acc_code_exp.ACCOUNT_CODE>
     <cfquery name="get_stoppage_acc_code" datasource="#dsn2#">
        SELECT STOPPAGE_ACCOUNT_CODE FROM SETUP_STOPPAGE_RATES WHERE STOPPAGE_RATE_ID = #attributes.field_stoppage_rate_id# and STOPPAGE_RATE = #attributes.stopaj_rate#
    </cfquery> 
    

    <cfscript>
        process_type = get_process_type.PROCESS_TYPE;
        is_account = get_process_type.IS_ACCOUNT;
        is_budget = get_process_type.IS_BUDGET;
        is_account_group = get_process_type.IS_ACCOUNT_GROUP;
        attributes.ACTION_VALUE = filterNum(attributes.ACTION_VALUE);
        attributes.OTHER_CASH_ACT_VALUE = filterNum(attributes.OTHER_CASH_ACT_VALUE);
        attributes.system_amount = filterNum(attributes.system_amount);
        if( isdefined("attributes.total_reeskont") and len(attributes.total_reeskont) ){
            attributes.total_reeskont = filterNum(attributes.total_reeskont);
        }else{
            attributes.total_reeskont = 0;
        }
       
        for(k_say=1; k_say lte attributes.kur_say; k_say=k_say+1)
        {
            'attributes.txt_rate1_#k_say#' = filterNum(evaluate('attributes.txt_rate1_#k_say#'),session.ep.our_company_info.rate_round_num);
            'attributes.txt_rate2_#k_say#' = filterNum(evaluate('attributes.txt_rate2_#k_say#'),session.ep.our_company_info.rate_round_num);
        }

        to_branch_id_info = listgetat(session.ep.user_location,2,'-'); //borclu sube
        from_branch_id_info = listgetat(session.ep.user_location,2,'-'); //alacakli sube
        	
        currency_multiplier = 1;
        masraf_curr_multiplier = 1;

        if(isDefined('attributes.kur_say') and len(attributes.kur_say))
            for(mon=1;mon lte attributes.kur_say;mon=mon+1)
            {
                if(evaluate("attributes.hidden_rd_money_#mon#") is session.ep.money2)
                    currency_multiplier = evaluate('attributes.txt_rate2_#mon#/attributes.txt_rate1_#mon#');
                if(evaluate("attributes.hidden_rd_money_#mon#") is form.money_type)
                    masraf_curr_multiplier = evaluate('attributes.txt_rate2_#mon#/attributes.txt_rate1_#mon#');
                if(evaluate("attributes.hidden_rd_money_#mon#") is attributes.currency_id)
                    dovizli_islem_multiplier = evaluate('attributes.txt_rate2_#mon#/attributes.txt_rate1_#mon#');
            }
    </cfscript>

    <cf_date tarih="attributes.ACTION_DATE">
    
        <cflock name="#createUUID()#" timeout="20">		
            <cftransaction>
                <cfif isdefined("attributes.yield_to_bank") and attributes.yield_to_bank eq 1>
                    <cfquery name="ADD_INTEREST_REVENUE" datasource="#dsn2#" result="MAX_ID">
                        INSERT INTO
                            BANK_ACTIONS
                        (
                            ACTION_TYPE,
                            PROCESS_CAT,
                            ACTION_TYPE_ID,
                            ACTION_TO_ACCOUNT_ID,
                            ACTION_VALUE,
                            ACTION_DATE,
                            ACTION_CURRENCY_ID,
                            ACTION_DETAIL,
                            OTHER_CASH_ACT_VALUE,
                            OTHER_MONEY,
                            IS_ACCOUNT,
                            IS_ACCOUNT_TYPE,
                            PAPER_NO,
                            EXPENSE_ITEM_ID,
                            EXPENSE_CENTER_ID,
                            RECORD_EMP,
                            RECORD_IP,
                            RECORD_DATE,
                            TO_BRANCH_ID,
                            WITH_NEXT_ROW,
                            SYSTEM_ACTION_VALUE,
                            SYSTEM_CURRENCY_ID
                            <cfif len(session.ep.money2)>
                                ,ACTION_VALUE_2
                                ,ACTION_CURRENCY_ID_2
                            </cfif>
                        )
                        VALUES
                        (
                            <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.ACTION_TYPE#">,
                            #form.process_cat#,
                            #process_type#,
                            #attributes.from_account_id#,
                            #attributes.ACTION_VALUE - attributes.stopaj_total#,
                            #attributes.ACTION_DATE#,
                            <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.currency_id#">,
                            <cfif isDefined("attributes.ACTION_DETAIL") and len(attributes.ACTION_DETAIL)><cfqueryparam cfsqltype="cf_sql_varchar" value="#ACTION_DETAIL#"><cfelse>NULL</cfif>,
                            <cfif isDefined("attributes.OTHER_CASH_ACT_VALUE") and len(attributes.OTHER_CASH_ACT_VALUE)>#attributes.OTHER_CASH_ACT_VALUE - attributes.stopaj_total#<cfelse>NULL</cfif>,
                            <cfif isDefined("attributes.money_type") and len(attributes.money_type)><cfqueryparam cfsqltype="cf_sql_varchar" value="#form.money_type#"><cfelse>NULL</cfif>,
                            <cfif is_account eq 1>1,13,<cfelse>0,13,</cfif>
                            <cfif isdefined("attributes.paper_number") and len(attributes.paper_number)><cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.paper_number#"><cfelse>NULL</cfif>,
                            #attributes.expense_item_id#,
                            <cfif isdefined('attributes.expense_center_id') and len(attributes.expense_center_id)><cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.expense_center_id#"><cfelse>NULL</cfif>,
                            #SESSION.EP.USERID#,
                            <cfqueryparam cfsqltype="cf_sql_varchar" value="#CGI.REMOTE_ADDR#">,
                            #NOW()#	,
                            #from_branch_id_info#,
                            1,
                            #wrk_round( (attributes.ACTION_VALUE - attributes.stopaj_total) * dovizli_islem_multiplier)#,
                            <cfqueryparam cfsqltype="cf_sql_varchar" value="#session.ep.money#">
                            <cfif len(session.ep.money2)>
                                ,#wrk_round(( (attributes.ACTION_VALUE - attributes.stopaj_total) * dovizli_islem_multiplier)/currency_multiplier,4)#
                                ,<cfqueryparam cfsqltype="cf_sql_varchar" value="#session.ep.money2#">
                            </cfif>
                        )
                    </cfquery>
                    <cfset BANK_ACT_ID = MAX_ID.IDENTITYCOL>
                </cfif>

                <cfquery name="ADD_STOCKBONDS_YIELD_PLAN_ROWS" datasource="#dsn2#">
                    UPDATE #DSN3_alias#.STOCKBONDS_YIELD_PLAN_ROWS 
                    SET IS_PAYMENT = 1, 
                        ACTION_DATE_ROW = #attributes.action_date#,
                        STOPAJ_ID =  <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.field_stoppage_rate_id#">,
                        STOPAJ_RATE = <cfqueryparam cfsqltype="cf_sql_float" value="#attributes.stopaj_rate#">,
                        STOPAJ_TOTAL = <cfqueryparam cfsqltype="cf_sql_float" value="#attributes.stopaj_total#">,
                        NET_TOTAL = <cfqueryparam cfsqltype="cf_sql_float" value="#attributes.net_total#">,
                        ACTION_DETAIL = <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#attributes.action_detail#">,
                        PAPER_NO = <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#attributes.paper_number#">,
                        BANK_ACTION_ID = <cfif isdefined("attributes.yield_to_bank") and attributes.yield_to_bank eq 1>#BANK_ACT_ID#<cfelse>NULL</cfif>,
                        YIELD_TO_BANK = <cfif isdefined("attributes.yield_to_bank") and attributes.yield_to_bank eq 1>1<cfelse>0</cfif>,
                        COMMISION_RATE = <cfif len(attributes.commision_rate) and attributes.commision_rate gt 0 and len(attributes.commision_amount) and attributes.commision_amount gt 0 >#attributes.commision_rate#<cfelse>NULL</cfif>,
                        COMMISION_AMOUNT = <cfif len(attributes.commision_rate) and attributes.commision_rate gt 0 and len(attributes.commision_amount) and attributes.commision_amount gt 0 >#attributes.commision_amount#<cfelse>NULL</cfif>,
                        COMMISION_EXP_CENTER_ID    = <cfif len(attributes.com_exp_center_id) and len(attributes.com_exp_center)>#attributes.com_exp_center_id#<cfelse>NULL</cfif>,
                        COMMISION_EXP_ITEM_ID = <cfif len(attributes.com_exp_item_id) and len(attributes.com_exp_item_name)>#attributes.com_exp_item_id#<cfelse>NULL</cfif>,
                        STOPPAGE_EXP_ITEM_ID = <cfif isDefined("attributes.stoppage_expense_item_id") and len(attributes.stoppage_expense_item_id) and isDefined("attributes.stoppage_expense_item_name") and len(attributes.stoppage_expense_item_name)><cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.stoppage_expense_item_id#"><cfelse>NULL</cfif>,
                        STOPPAGE_EXP_CENTER_ID = <cfif isDefined("attributes.stoppage_expense_center_id") and len(attributes.stoppage_expense_center_id) and isDefined("attributes.stoppage_expense_center_name") and len(attributes.stoppage_expense_center_name)><cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.stoppage_expense_center_id#"><cfelse>NULL</cfif>	
                    WHERE YIELD_PLAN_ROWS_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.row_id#">
                </cfquery>
                <cfscript>
                    if(is_account eq 1) {

                        str_card_detail = ArrayNew(2);
                        acc_branch_list_borc = '';
                        acc_branch_list_alacak = '';
                        acc_branch_list_alacak = listappend(acc_branch_list_alacak,from_branch_id_info,',');
                        acc_branch_list_borc = listappend(acc_branch_list_borc,to_branch_id_info,',');
                        
                        if( isdefined("attributes.yield_to_bank") and attributes.yield_to_bank eq 1){ /* Getiri Banka hesabına geçsin. */
                            str_borclu_hesaplar = attributes.account_acc_code;
                        }else{                                                                        /* Getiri M. Kıymet Hesabına geçsin. */
                            str_borclu_hesaplar = attributes.acc_id;
                        }
                        
                        str_alacakli_hesaplar = get_acc_code_expense_item;
                        str_tutarlar = attributes.system_amount - attributes.stopaj_total;
                        str_alacakli_tutarlar = attributes.system_amount - attributes.stopaj_total - attributes.total_reeskont;

                        if(isDefined("attributes.ACTION_DETAIL") and len(attributes.ACTION_DETAIL))
                        {
                            str_card_detail[1][listlen(str_tutarlar)]='#attributes.ACTION_DETAIL#';
                            str_card_detail[2][listlen(str_alacakli_tutarlar)]='#attributes.ACTION_DETAIL#';
                        }
                        else
                        {
                            str_card_detail[1][listlen(str_tutarlar)]= 'Getiri';
                            str_card_detail[2][listlen(str_alacakli_tutarlar)]= 'Tahsilat / Bütçe Kalemi';
                        }

                        str_borclu_other_amount_tutar = attributes.ACTION_VALUE - attributes.stopaj_total;
                        str_borclu_other_currency = attributes.currency_id;
                        str_alacakli_other_amount_tutar = attributes.ACTION_VALUE - attributes.stopaj_total- attributes.total_reeskont;
                        str_alacakli_other_currency = attributes.currency_id;

                        str_borclu_hesaplar = ListAppend(str_borclu_hesaplar,get_stoppage_acc_code.STOPPAGE_ACCOUNT_CODE,",");
                        str_tutarlar = ListAppend(str_tutarlar,attributes.stopaj_total,",");
                        str_card_detail[1][listlen(str_tutarlar)] = 'Stopaj Tutarı';
                        str_borclu_other_amount_tutar = ListAppend(str_borclu_other_amount_tutar,attributes.stopaj_total,",");
                        str_borclu_other_currency = ListAppend(str_borclu_other_currency,attributes.currency_id,",");
                        acc_branch_list_borc = listappend(acc_branch_list_borc,to_branch_id_info,',');
                        acc_branch_list_alacak = listappend(acc_branch_list_alacak,from_branch_id_info,',');
                       
                        str_alacakli_hesaplar = ListAppend(str_alacakli_hesaplar,get_acc_code_expense_item,",");
                        str_alacakli_tutarlar = ListAppend(str_alacakli_tutarlar,attributes.stopaj_total,",");
                        str_card_detail[2][listlen(str_alacakli_tutarlar)]= 'Tahsilat / Bütçe Kalemi';
                        str_alacakli_other_amount_tutar = ListAppend(str_alacakli_other_amount_tutar,attributes.stopaj_total,",");
                        str_alacakli_other_currency = ListAppend(str_alacakli_other_currency,attributes.currency_id,",");
                        acc_branch_list_borc = listappend(acc_branch_list_borc,to_branch_id_info,',');
                        acc_branch_list_alacak = listappend(acc_branch_list_alacak,from_branch_id_info,',');

                        str_alacakli_hesaplar = listappend(str_alacakli_hesaplar,acc_tahakkuk_code,',');
                        if(attributes.currency_id is session.ep.money){
                            str_alacakli_tutarlar = listappend(str_alacakli_tutarlar, attributes.total_reeskont ,',');
                        }else{
                            str_alacakli_tutarlar = listappend(str_alacakli_tutarlar, attributes.total_reeskont * dovizli_islem_multiplier,',');
                        }
                        if(isDefined("attributes.ACTION_DETAIL") and len(attributes.ACTION_DETAIL))
                        {
                            str_card_detail[2][listlen(str_alacakli_tutarlar)]='#attributes.ACTION_DETAIL#';
                        }
                        else
                        {
                            str_card_detail[2][listlen(str_alacakli_tutarlar)]= 'Tahakkuk';
                        }
                        str_alacakli_other_amount_tutar = listappend(str_alacakli_other_amount_tutar,attributes.total_reeskont,',');
                        str_alacakli_other_currency = listappend(str_alacakli_other_currency,attributes.currency_id,',');
                        acc_branch_list_borc = listappend(acc_branch_list_borc,to_branch_id_info,',');
                        acc_branch_list_alacak = listappend(acc_branch_list_alacak,from_branch_id_info,',');

                        if( isdefined("get_com_exp_item_id") ) 
                        {
                            str_borclu_hesaplar = ListAppend(str_borclu_hesaplar,get_com_exp_item_id,",");
                            str_tutarlar = ListAppend(str_tutarlar,attributes.commision_amount,",");
                            str_card_detail[1][listlen(str_tutarlar)] = 'Komisyon Tutarı';
                            str_borclu_other_amount_tutar = ListAppend(str_borclu_other_amount_tutar,attributes.commision_amount,",");
                            str_borclu_other_currency = ListAppend(str_borclu_other_currency,attributes.currency_id,",");
                            acc_branch_list_borc = listappend(acc_branch_list_borc,to_branch_id_info,',');
                            acc_branch_list_alacak = listappend(acc_branch_list_alacak,from_branch_id_info,','); 
        
                            if(isdefined("my_acc_result")) {
                                str_alacakli_hesaplar = ListAppend(str_alacakli_hesaplar,my_acc_result,",");
                            }else if( isdefined("attributes.yield_to_bank") and attributes.yield_to_bank eq 1){
                                str_alacakli_hesaplar = ListAppend(str_alacakli_hesaplar,account_acc_code,",");
                            }else{
                                str_alacakli_hesaplar = ListAppend(str_alacakli_hesaplar,acc_id,",");
                            }
        
                            str_alacakli_tutarlar = ListAppend(str_alacakli_tutarlar,attributes.commision_amount,",");
                            str_card_detail[2][listlen(str_alacakli_tutarlar)]= 'Komisyon Tutarı';
                            str_alacakli_other_amount_tutar = ListAppend(str_alacakli_other_amount_tutar,attributes.commision_amount,",");
                            str_alacakli_other_currency = ListAppend(str_alacakli_other_currency,attributes.currency_id,",");
                            acc_branch_list_borc = listappend(acc_branch_list_borc,to_branch_id_info,',');
                            acc_branch_list_alacak = listappend(acc_branch_list_alacak,from_branch_id_info,',');
                        }

                        muhasebeci(
                                action_id:attributes.row_id,
                                workcube_process_type:process_type,
                                workcube_process_cat:form.process_cat,
                                account_card_type:13,
                                islem_tarihi: attributes.ACTION_DATE,
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
                                fis_detay : UCase(getLang('credit',56)),
                                acc_branch_list_borc : acc_branch_list_borc,
                                acc_branch_list_alacak : acc_branch_list_alacak,
                                belge_no : attributes.paper_number,
                                is_account_group : is_account_group
                        );
                    }

                    f_kur_ekle_action(action_id:attributes.row_id,process_type:0,action_table_name:'STOCKBONDS_SALEPURCHASE_MONEY',action_table_dsn:'#dsn3#',transaction_dsn:'#dsn2#');

                    if(is_budget eq 1)
                    {
                        butceci(
                                action_id : attributes.row_id,
                                muhasebe_db : dsn2,
                                is_income_expense : true,
                                process_type : process_type,
                                nettotal : ( attributes.xml_net_or_brut eq 1 ) ? attributes.ACTION_VALUE - attributes.stopaj_total : attributes.ACTION_VALUE,
                                other_money_value : ( attributes.xml_net_or_brut eq 1 ) ? attributes.OTHER_CASH_ACT_VALUE - attributes.stopaj_total : attributes.ACTION_VALUE,
                                action_currency : attributes.currency_id,
                                currency_multiplier : currency_multiplier,
                                expense_date : attributes.action_date,
                                expense_center_id : attributes.expense_center_id,
                                expense_item_id : attributes.expense_item_id,
                                detail : 'MENKUL KIYMET GETİRİ HESABA GEÇİŞ',
                                paper_no : attributes.paper_number, 
                                branch_id : ListGetAt(session.ep.user_location,2,"-"),
                                insert_type : 1
                            );

                            // Stopaj ayrıca giderleştirilsin   
                            if( attributes.xml_net_or_brut neq 1 ){
                                butceci(
                                    action_id : attributes.row_id,
                                    muhasebe_db : dsn2,
                                    is_income_expense : false,
                                    process_type : process_type,
                                    nettotal : attributes.stopaj_total,
                                    other_money_value : wrk_round(attributes.stopaj_total/masraf_curr_multiplier),
                                    action_currency : attributes.currency_id,
                                    currency_multiplier : currency_multiplier,
                                    expense_date : attributes.action_date,
                                    expense_center_id : attributes.stoppage_expense_center_id,
                                    expense_item_id : attributes.stoppage_expense_item_id,
                                    detail : 'MENKUL KIYMET GETİRİ STOPAJ GİDERİ',
                                    paper_no : attributes.paper_number,
                                    branch_id : ListGetAt(session.ep.user_location,2,"-"),
                                    insert_type : 1
                                );
                            }

                            if( isdefined("get_com_exp_item_id") and len(attributes.com_exp_item_id) and len(attributes.com_exp_item_name)  and len(attributes.com_exp_center_id) and len(attributes.com_exp_center) ){
                                /* komisyon gideri*/
                            butceci(
                                    action_id : attributes.row_id,
                                    muhasebe_db : dsn2,
                                    is_income_expense : false,
                                    process_type : process_type,
                                    nettotal : attributes.commision_amount,
                                    other_money_value :  wrk_round(attributes.commision_amount/masraf_curr_multiplier),
                                    action_currency : attributes.currency_id,
                                    currency_multiplier : currency_multiplier,
                                    expense_date : attributes.action_date,
                                    expense_center_id : attributes.com_exp_center_id,
                                    expense_item_id : attributes.com_exp_item_id,
                                    detail : 'MENKUL KIYMET KOMİSYON ',
                                    paper_no : attributes.paper_number,
                                    branch_id : ListGetAt(session.ep.user_location,2,"-"),
                                    insert_type : 1
                                );
                            }
                    } 

                </cfscript>
            </cftransaction>
        </cflock>

        <script type="text/javascript">
            window.location.href="<cfoutput>#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.list_stockbonds&acc_tahakkuk_code=#attributes.acc_tahakkuk_code#&event=updPaymentRevenue&yield_plan_row_id=#attributes.row_id#</cfoutput>";
            window.opener.location.reload();
        </script>