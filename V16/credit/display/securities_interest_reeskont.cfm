
<cfset wrk_id = dateformat(now(),'YYYYMMDD')&timeformat(now(),'HHmmss')&'_#session.ep.userid#_'&round(rand()*100)>
<cfset reeskontVal = 0>
<cfset attributes.yield_valuation_amount = left(attributes.yield_valuation_amount,len(attributes.yield_valuation_amount)-1)>
<cfset attributes.reeskont_datediff_val = left(attributes.reeskont_datediff_val,len(attributes.reeskont_datediff_val)-1)>
<cfset attributes.bank_currency_id = left(attributes.bank_currency_id,len(attributes.bank_currency_id)-1)>
<cfloop from="1" to="#listlen(attributes.currently_value)#" index="i">
    <cfset reeskontVal += listGetAt(attributes.yield_valuation_amount,i)> <!--- getiri listesi reeskont satır toplamları --->
</cfloop>
<cfquery name="GET_YIELD_INTEREST_PLAN_ROWS" datasource="#dsn3#">
    SELECT STOCKBOND_ID FROM STOCKBONDS_YIELD_PLAN_ROWS WHERE YIELD_PLAN_ROWS_ID IN (#attributes.currently_value#)
</cfquery>
<cfquery name="GET_YIELD_INTEREST_PLAN" datasource="#dsn3#">
    SELECT STOCKBOND_ID, YIELD_AMOUNT, BANK_ACTION_ID FROM STOCKBONDS WHERE STOCKBOND_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#GET_YIELD_INTEREST_PLAN_ROWS.STOCKBOND_ID#">
</cfquery> 
<cfscript>
    currency_multiplier = 1;
    masraf_curr_multiplier = 1;
    dovizli_islem_multiplier = 1;
    if(isDefined('form.deger_get_money') and len(form.deger_get_money))

    for(j=1;j lte listlen(attributes.currently_value); j=j+1){

        for(mon=1;mon lte form.deger_get_money;mon=mon+1)
        {
            if(evaluate("form.hidden_rd_money_#mon#") is session.ep.money2)
                currency_multiplier = evaluate('form.value_rate2#mon#/form.txt_rate1_#mon#');
            if(evaluate("form.hidden_rd_money_#mon#") is listgetat(attributes.bank_currency_id,j,','))
                masraf_curr_multiplier = evaluate('form.value_rate2#mon#/form.txt_rate1_#mon#');
            if(evaluate("form.hidden_rd_money_#mon#") is listgetat(attributes.bank_currency_id,j,','))
                dovizli_islem_multiplier = evaluate('form.value_rate2#mon#/form.txt_rate1_#mon#');
        }
        
    }
</cfscript>
<cfif attributes.budget_type eq 2>
    <cflock name="#createUUID()#" timeout="20">		
        <cftransaction>
            <!--- <cftry> --->
                <cfquery name="CREATE_BUDGET_PLAN" datasource="#dsn2#" result="MAX_ID">
                    INSERT INTO
                        #dsn#.BUDGET_PLAN
                        (
                            PROCESS_STAGE,
                            PROCESS_TYPE,
                            PROCESS_CAT,
                            PAPER_NO,
                            BUDGET_PLAN_DATE,
                            DETAIL,
                            INCOME_TOTAL,
                            EXPENSE_TOTAL,
                            DIFF_TOTAL,
                            INCOME_TOTAL_2,
                            DIFF_TOTAL_2,
                            OTHER_INCOME_TOTAL,
                            OTHER_EXPENSE_TOTAL,
                            OTHER_DIFF_TOTAL,
                            OTHER_MONEY,
                            IS_SCENARIO,
                            RECORD_DATE,
                            RECORD_IP,
                            RECORD_EMP,
                            OUR_COMPANY_ID,
                            PERIOD_ID
                        )
                        VALUES
                        (
                            9,
                            161,
                            109,
                            'MK-BGP-#GET_YIELD_INTEREST_PLAN.BANK_ACTION_ID#',
                            #attributes.yield_valuation_date#,
                            'MENKUL KIYMETLER REESKONT TAHAKKUKU',
                            #reeskontVal#,
                            0,
                            #reeskontVal#,
                            <cfqueryparam cfsqltype="cf_sql_float" value="#application.functions.wrk_round(reeskontVal*dovizli_islem_multiplier)#">,
                            <cfqueryparam cfsqltype="cf_sql_float" value="#application.functions.wrk_round(reeskontVal/currency_multiplier)#">,
                            #reeskontVal#,
                            0,
                            NULL,
                            '#form.rd_money#',
                            1,
                            #now()#,
                            '#cgi.remote_addr#',
                            #session.ep.userid#,
                            #session.ep.company_id#,
                            #session.ep.period_id#
                        )
                </cfquery> 
                <cfset GET_MAX_ID.MAX_ID = MAX_ID.IDENTITYCOL>
                <cfloop from="1" to="#listlen(attributes.currently_value)#" index="i">
                    <cfquery name="GET_YIELD_INTEREST_PLAN_ROWS" datasource="#dsn2#">
                        SELECT STOCKBOND_ID, EXPENSE_ITEM_TAHAKKUK_ID FROM #dsn3_alias#.STOCKBONDS_YIELD_PLAN_ROWS WHERE YIELD_PLAN_ROWS_ID = #listgetat(attributes.currently_value,i,',')#
                    </cfquery>
                    <cfquery name="GET_YIELD_INTEREST_PLAN" datasource="#dsn2#">
                        SELECT ST.STOCKBOND_ID, ST.YIELD_AMOUNT, ST.BANK_ACTION_ID, SP.EXP_CENTER_ID, SP.PAPER_NO 
                        FROM #dsn3_alias#.STOCKBONDS as ST
                        LEFT JOIN #dsn3_alias#.STOCKBONDS_SALEPURCHASE_ROW AS STCK_R ON ST.STOCKBOND_ID = STCK_R.STOCKBOND_ID 
                        LEFT JOIN #dsn3_alias#.STOCKBONDS_SALEPURCHASE AS SP ON SP.ACTION_ID = STCK_R.SALES_PURCHASE_ID
                        WHERE STOCKBOND_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#GET_YIELD_INTEREST_PLAN_ROWS.STOCKBOND_ID#">
                    </cfquery> 
                    <cfset get_acc_code_expense_tahakkuk_item = INTEREST_REVENUE.get_acc_code_exp( expense_item_id : GET_YIELD_INTEREST_PLAN_ROWS.expense_item_tahakkuk_id )>

                    <cfquery name="ADD_BUDGET_PLAN_ROW" datasource="#dsn2#" result="LAST_ID">
                        INSERT INTO
                            #dsn#.BUDGET_PLAN_ROW
                            (
                                BUDGET_PLAN_ID,
                                PLAN_DATE,
                                DETAIL,
                                EXP_INC_CENTER_ID,
                                BUDGET_ITEM_ID,
                                BUDGET_ACCOUNT_CODE,
                                ROW_TOTAL_INCOME,
                                ROW_TOTAL_EXPENSE,
                                ROW_TOTAL_DIFF,
                                ROW_TOTAL_INCOME_2,
                                ROW_TOTAL_EXPENSE_2,
                                ROW_TOTAL_DIFF_2,
                                OTHER_ROW_TOTAL_INCOME,
                                OTHER_ROW_TOTAL_EXPENSE,
                                OTHER_ROW_TOTAL_DIFF,
                                IS_PAYMENT
                            )
                            VALUES
                            (
                                #GET_MAX_ID.MAX_ID#,
                                #attributes.yield_valuation_date#,
                                'Getiri Reeskont',
                                #GET_YIELD_INTEREST_PLAN.EXP_CENTER_ID#, <!--- Masraf gelir merkezi --->
                                #GET_YIELD_INTEREST_PLAN_ROWS.expense_item_tahakkuk_id#, <!--- BÜTÇE TAHAKKUK --->
                                '#get_acc_code_expense_tahakkuk_item.ACCOUNT_CODE#',
                                <cfif session.ep.money eq listgetat(attributes.bank_currency_id,i,',')> <!--- Gelir ---> 
                                    #listgetat(attributes.yield_valuation_amount,i,',')# 
                                <cfelse>
                                    #listgetat(attributes.yield_valuation_amount,i,',') * dovizli_islem_multiplier#
                                </cfif>,
                                0,
                                <cfif session.ep.money eq listgetat(attributes.bank_currency_id,i,',')>  <!--- Fark --->
                                    #listgetat(attributes.yield_valuation_amount,i,',')# 
                                <cfelse>
                                    #listgetat(attributes.yield_valuation_amount,i,',') * dovizli_islem_multiplier#
                                </cfif>,
                                #wrk_round(listgetat(attributes.yield_valuation_amount,i,',') / currency_multiplier)#,
                                0,
                                #wrk_round(listgetat(attributes.yield_valuation_amount,i,',') / currency_multiplier)#,
                                #wrk_round(listgetat(attributes.yield_valuation_amount,i,',') / dovizli_islem_multiplier,4)#,
                                0,
                                #wrk_round(listgetat(attributes.yield_valuation_amount,i,',') / dovizli_islem_multiplier,4)#,
                                0
                            )
                    </cfquery>
                    <cfset GET_ROW_ID = LAST_ID.IDENTITYCOL>
                    <cfquery name="ADD_YIELD_VALUATION" datasource="#dsn2#">
                        INSERT INTO
                             #dsn3_alias#.STOCKBONDS_YIELD_VALUATION
                            (
                                STOCKBONDS_ROWS_ID,
                                STOCKBONDS_VALUATION_DATE,
                                STOCKBONDS_VALUATION_AMOUNT,
                                BUDGET_PLAN_ROW_ID,
                                DATE_DIFF
                            )
                        VALUES
                            (
                                <cfqueryparam cfsqltype="cf_sql_integer" value="#listgetat(attributes.currently_value,i,',')#">,
                                <cfqueryparam cfsqltype="cf_sql_date" value="#attributes.yield_valuation_date#">,
                                <cfqueryparam cfsqltype="cf_sql_float" value="#listgetat(attributes.yield_valuation_amount,i,',')#">,
                                #GET_ROW_ID#,
                                <cfqueryparam cfsqltype="cf_sql_float" value="#listgetat(attributes.reeskont_datediff_val,i,',')#">
                            )
                    </cfquery>

                    <cfscript>
                        str_alacak_tutar_list="";
                        str_alacak_kod_list="";
                        str_borc_tutar_list="";
                        str_borc_kod_list="";
                        satir_detay_list = ArrayNew(2); //muhasebe fisi satır detaylarını tutar
                        str_other_alacak_tutar_list = "";
                        str_other_borc_tutar_list = "";
                        str_other_borc_currency_list = "";
                        str_other_alacak_currency_list = "";
                        acc_department_id = "";
                        branch_id_info = ListGetAt(session.ep.user_location,2,"-");

                        for(j=1;j lte listlen(attributes.currently_value); j=j+1)

                            get_yield_id = cfquery(datasource:"#dsn2#", sqlstring:"SELECT STOCKBOND_ID, EXPENSE_ITEM_TAHAKKUK_ID FROM #dsn3_alias#.STOCKBONDS_YIELD_PLAN_ROWS WHERE YIELD_PLAN_ROWS_ID = #listgetat(attributes.currently_value,i,',')#");
                            get_yield_rows = cfquery(datasource:"#dsn2#", sqlstring:"SELECT ST.STOCKBOND_ID, ST.YIELD_AMOUNT, ST.BANK_ACTION_ID, SP.EXP_ITEM_ID FROM #dsn3_alias#.STOCKBONDS as ST LEFT JOIN BANK_ACTIONS AS BA ON ST.BANK_ACTION_ID = BA.ACTION_ID LEFT JOIN #dsn3_alias#.STOCKBONDS_SALEPURCHASE AS SP ON SP.BANK_ACTION_ID = BA.ACTION_ID WHERE STOCKBOND_ID = #get_yield_id.STOCKBOND_ID#");
                            get_acc_code_expense_tahakkuk_item = INTEREST_REVENUE.get_acc_code_exp( expense_item_id : get_yield_id.expense_item_tahakkuk_id );
                            get_acc_code_expense_acc_code = INTEREST_REVENUE.get_acc_code_exp( expense_item_id : get_yield_rows.EXP_ITEM_ID );

                            {
                                if(session.ep.money eq listgetat(attributes.bank_currency_id,i,',')){
                                    str_borc_tutar_list = ListAppend(str_borc_tutar_list,listgetat(attributes.yield_valuation_amount,i,','),",");
                                }else{
                                    str_borc_tutar_list = ListAppend(str_borc_tutar_list,( listgetat(attributes.yield_valuation_amount,i,',') * dovizli_islem_multiplier ) ,",");
                                }
                                str_borc_kod_list = ListAppend(str_borc_kod_list,get_acc_code_expense_tahakkuk_item.ACCOUNT_CODE,",");
                                str_other_borc_tutar_list = ListAppend(str_other_borc_tutar_list, listgetat(attributes.yield_valuation_amount,i,','),",");
                                str_other_borc_currency_list = ListAppend(str_other_borc_currency_list, listgetat(attributes.bank_currency_id,i,',') ,",");
                                
                                if(session.ep.money eq listgetat(attributes.bank_currency_id,i,',')){
                                    str_alacak_tutar_list = ListAppend(str_alacak_tutar_list,listgetat(attributes.yield_valuation_amount,i,','),",");
                                }else{
                                    str_alacak_tutar_list = ListAppend(str_alacak_tutar_list, (listgetat(attributes.yield_valuation_amount,i,',') * dovizli_islem_multiplier ),",");
                                }

                                str_alacak_kod_list = ListAppend(str_alacak_kod_list,get_acc_code_expense_acc_code.ACCOUNT_CODE,",");
                                str_other_alacak_tutar_list = ListAppend(str_other_alacak_tutar_list, listgetat(attributes.yield_valuation_amount,i,','),",");
                                str_other_alacak_currency_list = ListAppend(str_other_alacak_currency_list, listgetat(attributes.bank_currency_id,i,',') ,",");

                                satir_detay_list[1][listlen(str_borc_tutar_list)]='Reeskont Tahakkuk';
                                satir_detay_list[2][listlen(str_alacak_tutar_list)]='Reeskont Tahsilat';
                            }
                        
                        muhasebeci (
                            wrk_id:wrk_id,
                            action_id:get_max_id.max_id,
                            action_table :'BUDGET_PLAN',
                            acc_department_id : acc_department_id,
                            workcube_process_type : 161, /* tahakkuk fişi process type */
                            workcube_process_cat: 109, /* tahakkuk fişi */
                            account_card_type : 13,
                            islem_tarihi : attributes.yield_valuation_date,
                            borc_hesaplar : str_borc_kod_list,
                            borc_tutarlar : str_borc_tutar_list,
                            alacak_hesaplar : str_alacak_kod_list,
                            alacak_tutarlar : str_alacak_tutar_list,
                            fis_satir_detay: satir_detay_list,
                            fis_detay : UCase(getLang('main',1853)),
                            belge_no : 'MK-BGP-#GET_YIELD_INTEREST_PLAN.BANK_ACTION_ID#',
                            from_branch_id : branch_id_info,
                            to_branch_id : branch_id_info,
                            other_amount_borc : str_other_borc_tutar_list,
                            other_currency_borc : str_other_borc_currency_list,
                            other_amount_alacak : str_other_alacak_tutar_list,
                            other_currency_alacak : str_other_alacak_currency_list,
                            currency_multiplier : currency_multiplier
                        );
                    </cfscript>
                    <!--- money kayıtları --->
                        <cfloop from="1" to="#form.deger_get_money#" index="i">
                            <cfquery name="ADD_MONEY_INFO" datasource="#dsn2#">
                                INSERT INTO
                                    #dsn#.BUDGET_PLAN_MONEY 
                                (
                                    ACTION_ID,
                                    MONEY_TYPE,
                                    RATE2,
                                    RATE1,
                                    IS_SELECTED
                                )
                                VALUES
                                (
                                    #GET_MAX_ID.MAX_ID#,
                                    '#wrk_eval("form.hidden_rd_money_#i#")#',
                                    #evaluate("form.value_rate2#i#")#,
                                    #evaluate("form.txt_rate1_#i#")#,
                                    <cfif evaluate("form.hidden_rd_money_#i#") is attributes.bank_currency_id>1<cfelse>0</cfif>
                                )
                            </cfquery>
                        </cfloop>
                </cfloop>
            <!--- <cfcatch>
                <script type="text/javascript">
                    alert("Planlama Fişi Oluşturulurken Bir Hata Oluştu!");
                    history.back();
                </script>
                <cfabort>
            </cfcatch> 
            </cftry> --->
        </cftransaction>
    </cflock>
<cfelseif attributes.budget_type eq 1>
    <cflock name="#createUUID()#" timeout="20">		
        <cftransaction>
            <cftry>
                <cfset str_alacak_tutar_list="">
                <cfset str_alacak_kod_list="">
                <cfset str_borc_tutar_list="">
                <cfset str_borc_kod_list="">
                <cfset satir_detay_list = ArrayNew(2)> 
                <cfset str_other_alacak_tutar_list = "">
                <cfset str_other_borc_tutar_list = "">
                <cfset str_other_borc_currency_list = "">
                <cfset str_other_alacak_currency_list = "">
                <cfset acc_department_id = "">
                <cfset branch_id_info = ListGetAt(session.ep.user_location,2,"-")>
                <cfloop from="1" to="#listlen(attributes.currently_value)#" index="i">
                    <cfquery name="GET_YIELD_INTEREST_PLAN_ROWS" datasource="#dsn2#">
                        SELECT STOCKBOND_ID, EXPENSE_ITEM_TAHAKKUK_ID FROM #dsn3_alias#.STOCKBONDS_YIELD_PLAN_ROWS WHERE YIELD_PLAN_ROWS_ID = #listgetat(attributes.currently_value,i,',')#
                    </cfquery>
                    <cfquery name="GET_YIELD_INTEREST_PLAN" datasource="#dsn2#">
                        SELECT ST.STOCKBOND_ID, ST.YIELD_AMOUNT, ST.BANK_ACTION_ID, SP.EXP_CENTER_ID, SP.PAPER_NO 
                        FROM #dsn3_alias#.STOCKBONDS AS ST
                        LEFT JOIN #dsn3_alias#.STOCKBONDS_SALEPURCHASE_ROW AS STCK_R ON ST.STOCKBOND_ID = STCK_R.STOCKBOND_ID 
                        LEFT JOIN #dsn3_alias#.STOCKBONDS_SALEPURCHASE AS SP ON SP.ACTION_ID = STCK_R.SALES_PURCHASE_ID
                        WHERE ST.STOCKBOND_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#GET_YIELD_INTEREST_PLAN_ROWS.STOCKBOND_ID#">
                    </cfquery> 
                    <cfset get_acc_code_expense_tahakkuk_item = INTEREST_REVENUE.get_acc_code_exp( expense_item_id : GET_YIELD_INTEREST_PLAN_ROWS.expense_item_tahakkuk_id )>
                    <cfquery name="ADD_YIELD_VALUATION" datasource="#dsn2#" result="MAX_ID">
                        INSERT INTO
                            #dsn3_alias#.STOCKBONDS_YIELD_VALUATION
                            (
                                STOCKBONDS_ROWS_ID,
                                STOCKBONDS_VALUATION_DATE,
                                STOCKBONDS_VALUATION_AMOUNT,
                                DATE_DIFF
                            )
                        VALUES
                            (
                                <cfqueryparam cfsqltype="cf_sql_integer" value="#listgetat(attributes.currently_value,i,',')#">,
                                <cfqueryparam cfsqltype="cf_sql_date" value="#attributes.yield_valuation_date#">,
                                <cfqueryparam cfsqltype="cf_sql_float" value="#listgetat(attributes.yield_valuation_amount,i,',')#">,
                                <cfqueryparam cfsqltype="cf_sql_float" value="#listgetat(attributes.reeskont_datediff_val,i,',')#">
                            )
                    </cfquery>
                    <cfset VALUATION_ID = MAX_ID.IDENTITYCOL>
                    <cfscript>

                        for(j=1;j lte listlen(attributes.currently_value); j=j+1)

                            get_yield_id = cfquery(datasource:"#dsn2#", sqlstring:"SELECT STOCKBOND_ID, EXPENSE_ITEM_TAHAKKUK_ID FROM #dsn3_alias#.STOCKBONDS_YIELD_PLAN_ROWS WHERE YIELD_PLAN_ROWS_ID = #listgetat(attributes.currently_value,i,',')#");
                            get_yield_rows = cfquery(datasource:"#dsn2#", sqlstring:"SELECT ST.STOCKBOND_ID, ST.YIELD_AMOUNT, ST.BANK_ACTION_ID, SP.EXP_ITEM_ID FROM #dsn3_alias#.STOCKBONDS as ST LEFT JOIN #dsn3_alias#.STOCKBONDS_SALEPURCHASE_ROW AS STCK_R ON ST.STOCKBOND_ID = STCK_R.STOCKBOND_ID LEFT JOIN #dsn3_alias#.STOCKBONDS_SALEPURCHASE AS SP ON SP.ACTION_ID = STCK_R.SALES_PURCHASE_ID WHERE ST.STOCKBOND_ID = #get_yield_id.STOCKBOND_ID#");

                            get_acc_code_expense_tahakkuk_item = INTEREST_REVENUE.get_acc_code_exp( expense_item_id : get_yield_id.expense_item_tahakkuk_id );
                            get_acc_code_expense_acc_code = INTEREST_REVENUE.get_acc_code_exp( expense_item_id : get_yield_rows.EXP_ITEM_ID );

                            {
                                if(session.ep.money eq listgetat(attributes.bank_currency_id,i,',')){
                                    str_borc_tutar_list = ListAppend(str_borc_tutar_list,listgetat(attributes.yield_valuation_amount,i,','),",");
                                }else{
                                    str_borc_tutar_list = ListAppend(str_borc_tutar_list,( listgetat(attributes.yield_valuation_amount,i,',') * dovizli_islem_multiplier ) ,",");
                                }
                                
                                str_borc_kod_list = ListAppend(str_borc_kod_list,get_acc_code_expense_tahakkuk_item.ACCOUNT_CODE,",");
                                str_other_borc_tutar_list = ListAppend(str_other_borc_tutar_list, listgetat(attributes.yield_valuation_amount,i,','),",");
                                str_other_borc_currency_list = ListAppend(str_other_borc_currency_list, listgetat(attributes.bank_currency_id,i,',') ,",");
                                
                                if(session.ep.money eq listgetat(attributes.bank_currency_id,i,',')){
                                    str_alacak_tutar_list = ListAppend(str_alacak_tutar_list,listgetat(attributes.yield_valuation_amount,i,','),",");
                                }else{
                                    str_alacak_tutar_list = ListAppend(str_alacak_tutar_list, (listgetat(attributes.yield_valuation_amount,i,',') * dovizli_islem_multiplier ),",");
                                }

                                str_alacak_kod_list = ListAppend(str_alacak_kod_list,get_acc_code_expense_acc_code.ACCOUNT_CODE,",");
                                str_other_alacak_tutar_list = ListAppend(str_other_alacak_tutar_list, listgetat(attributes.yield_valuation_amount,i,','),",");
                                str_other_alacak_currency_list = ListAppend(str_other_alacak_currency_list, listgetat(attributes.bank_currency_id,i,',') ,",");

                                satir_detay_list[1][listlen(str_borc_tutar_list)]='Reeskont Tahakkuk';
                                satir_detay_list[2][listlen(str_alacak_tutar_list)]='Reeskont Tahsilat';
                            }
                        
                         if(session.ep.money neq attributes.bank_currency_id){
                             reeskontVal_ = reeskontVal * dovizli_islem_multiplier;
                         }else{
                            reeskontVal_ = reeskontVal;
                         }
                            
                        butceci(
                            action_id : VALUATION_ID,
                            muhasebe_db : dsn2,
                            is_income_expense : true,
                            process_type : 2933,
                            nettotal : reeskontVal_,
                            other_money_value : wrk_round(reeskontVal),
                            action_currency : attributes.bank_currency_id,
                            currency_multiplier : currency_multiplier,
                            expense_date : attributes.yield_valuation_date,
                            expense_center_id : GET_YIELD_INTEREST_PLAN.EXP_CENTER_ID,
                            expense_item_id : get_yield_rows.EXP_ITEM_ID,
                            detail : 'MENKUL KIYMETLER REESKONT',
                            paper_no : GET_YIELD_INTEREST_PLAN.PAPER_NO,
                            branch_id : ListGetAt(session.ep.user_location,2,"-"),
                            insert_type : 1
                        );
                    </cfscript>
                </cfloop>
                <cfscript>
                        muhasebeci (
                            wrk_id:wrk_id,
                            action_id:VALUATION_ID,
                            action_table :'INTEREST_YIELD_VALUATION',
                            acc_department_id : acc_department_id,
                            workcube_process_type : 2933, /* mk reeskont */
                            account_card_type : 13,
                            islem_tarihi : attributes.yield_valuation_date,
                            borc_hesaplar : str_borc_kod_list,
                            borc_tutarlar : str_borc_tutar_list,
                            alacak_hesaplar : str_alacak_kod_list,
                            alacak_tutarlar : str_alacak_tutar_list,
                            fis_satir_detay: satir_detay_list,
                            fis_detay : UCase(getLang('main',1853)),
                            belge_no : 'MK-#GET_YIELD_INTEREST_PLAN.BANK_ACTION_ID#',
                            from_branch_id : branch_id_info,
                            to_branch_id : branch_id_info,
                            other_amount_borc : str_other_borc_tutar_list,
                            other_currency_borc : str_other_borc_currency_list,
                            other_amount_alacak : str_other_alacak_tutar_list,
                            other_currency_alacak : str_other_alacak_currency_list,
                            currency_multiplier : currency_multiplier
                        );
                </cfscript>
            <cfcatch>
                <script type="text/javascript">
                    alert("Gelirleştirme işlemi oluşturulurken Bir Hata Oluştu!");
                    history.back();
                </script>
                <cfabort>
            </cfcatch>
            </cftry>
        </cftransaction>
    </cflock>
</cfif>