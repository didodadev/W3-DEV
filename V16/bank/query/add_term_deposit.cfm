
<cf_get_lang_set module_name="bank">
    <cfif form.active_period neq session.ep.period_id>
        <script type="text/javascript">
            alert("<cf_get_lang_main no='1659.İşlem Yapmak İstediğiniz Muhasebe Dönemi ile Aktif Muhasebe Döneminiz Farklı Muhasebe Döneminizi Kontrol Ediniz'>!");
            window.location.href='<cfoutput>#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.list_bank_actions</cfoutput>';
        </script>
        <cfabort>
    </cfif>
    <cfset ADD_REVENUE = createObject("component", "V16.bank.cfc.vadeliMevduat")>
    <cfset get_process_type = ADD_REVENUE.get_process_type( process_cat : form.process_cat )>
    <cfset get_acc_code_expense_item = ADD_REVENUE.get_acc_code_exp( expense_item_id : attributes.expense_item_id )>
    <cfset get_acc_code_expense_tahakkuk_item = ADD_REVENUE.get_acc_code_exp( expense_item_id : attributes.expense_item_tahakkuk_id )>

    <cfscript>
        process_type = get_process_type.PROCESS_TYPE;
        is_cari = get_process_type.IS_CARI;
        is_account = get_process_type.IS_ACCOUNT;
        is_budget = get_process_type.IS_BUDGET;
        is_next_periods_accrual_action = get_process_type.NEXT_PERIODS_ACCRUAL_ACTION;
        ACCRUAL_BUDGET_ACTION = get_process_type.ACCRUAL_BUDGET_ACTION;
        attributes.ACTION_VALUE = filterNum(attributes.ACTION_VALUE);
        attributes.OTHER_CASH_ACT_VALUE = filterNum(attributes.OTHER_CASH_ACT_VALUE);
        attributes.system_amount = filterNum(attributes.system_amount);
        attributes.masraf = filterNum(attributes.masraf);
        for(k_say=1; k_say lte attributes.kur_say; k_say=k_say+1)
        {
            'attributes.txt_rate1_#k_say#' = filterNum(evaluate('attributes.txt_rate1_#k_say#'),session.ep.our_company_info.rate_round_num);
            'attributes.txt_rate2_#k_say#' = filterNum(evaluate('attributes.txt_rate2_#k_say#'),session.ep.our_company_info.rate_round_num);
        }
        //borclu sube
        if(isdefined("attributes.branch_id_borc") and len(attributes.branch_id_borc))
            to_branch_id_info = attributes.branch_id_borc;
        else
            to_branch_id_info = listgetat(session.ep.user_location,2,'-');	
        //alacakli sube	
        if(isdefined("attributes.branch_id_alacak") and len(attributes.branch_id_alacak))
            from_branch_id_info = attributes.branch_id_alacak;
        else
            from_branch_id_info = listgetat(session.ep.user_location,2,'-');	
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
                if(evaluate("attributes.hidden_rd_money_#mon#") is attributes.currency_id2)
                    dovizli_islem_multiplier_2 = evaluate('attributes.txt_rate2_#mon#/attributes.txt_rate1_#mon#');
            }
    </cfscript>
    <cfquery name="control_paper_no" datasource="#dsn2#">
        SELECT PAPER_NO FROM BANK_ACTIONS WHERE PAPER_NO = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.paper_number#">
    </cfquery>
    <cfif control_paper_no.recordcount>
        <script type="text/javascript">
            alert("<cf_get_lang_main no ='710.Girdiğiniz Belge Numarası Kullanılmaktadır'>!");
            history.back();	
        </script>
        <cfabort>
    </cfif>
    <cf_papers paper_type="virman">
    <cf_date tarih="attributes.ACTION_DATE">
    <cf_date tarih="attributes.due_value_date">
    <cfif not len(attributes.masraf)>
        <cfset attributes.masraf = 0>
    </cfif>
    <cflock name="#createUUID()#" timeout="20">		
        <cftransaction>
            <cfquery name="ADD_TERM_DEPOSIT" datasource="#DSN2#">
                INSERT INTO
                    BANK_ACTIONS
                (
                    ACTION_TYPE,
                    PROCESS_CAT,
                    ACTION_TYPE_ID,
                    ACTION_FROM_ACCOUNT_ID,
                    ACTION_VALUE,
                    ACTION_DATE,
                    ACTION_CURRENCY_ID,
                    ACTION_DETAIL,
                    OTHER_CASH_ACT_VALUE,
                    OTHER_MONEY,
                    IS_ACCOUNT,
                    IS_ACCOUNT_TYPE,
                    PAPER_NO,
                    PROCESS_STAGE,
                    MASRAF,
                    EXPENSE_ITEM_ID,
                    EXPENSE_CENTER_ID,
                    RECORD_EMP,
                    RECORD_IP,
                    RECORD_DATE,
                    FROM_BRANCH_ID,
                    WITH_NEXT_ROW,
                    SYSTEM_ACTION_VALUE,
                    SYSTEM_CURRENCY_ID
                    <cfif len(session.ep.money2)>
                        ,ACTION_VALUE_2
                        ,ACTION_CURRENCY_ID_2
                    </cfif>	
                    <cfif len(attributes.project_id)>
                        ,PROJECT_ID
                    </cfif>
                )
                VALUES
                (
                    <cfqueryparam cfsqltype="cf_sql_varchar" value="#ACTION_TYPE#">,
                    #form.process_cat#,
                    #process_type#,
                    #attributes.from_account_id#,
                    <cfif len(attributes.masraf)>#attributes.ACTION_VALUE + attributes.masraf#,<cfelse>#attributes.ACTION_VALUE#,</cfif>
                    #attributes.ACTION_DATE#,
                    <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.currency_id#">,
                    <cfif isDefined("attributes.ACTION_DETAIL") and len(attributes.ACTION_DETAIL)><cfqueryparam cfsqltype="cf_sql_varchar" value="#ACTION_DETAIL#"><cfelse>NULL</cfif>,
                    <cfif isDefined("attributes.OTHER_CASH_ACT_VALUE") and len(attributes.OTHER_CASH_ACT_VALUE)>#attributes.OTHER_CASH_ACT_VALUE#<cfelse>NULL</cfif>,
                    <cfif isDefined("attributes.money_type") and len(attributes.money_type)><cfqueryparam cfsqltype="cf_sql_varchar" value="#money_type#"><cfelse>NULL</cfif>,
                    <cfif is_account eq 1>1,13,<cfelse>0,13,</cfif>
                    <cfif isdefined("attributes.paper_number") and len(attributes.paper_number)><cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.paper_number#"><cfelse>NULL</cfif>,
                    <cfif isdefined('attributes.process_stage') and len(attributes.process_stage)><cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.process_stage#"><cfelse>NULL</cfif>,
                    <cfif len(attributes.masraf)>#attributes.masraf#,<cfelse>0,</cfif>
                    #attributes.expense_item_id#,
                    <cfif isdefined('attributes.expense_center_id') and len(attributes.expense_center_id)><cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.expense_center_id#"><cfelse>NULL</cfif>,
                    #SESSION.EP.USERID#,
                    <cfqueryparam cfsqltype="cf_sql_varchar" value="#CGI.REMOTE_ADDR#">,
                    #NOW()#	,
                    #from_branch_id_info#,
                    1,
                    #wrk_round((attributes.ACTION_VALUE + attributes.masraf)*dovizli_islem_multiplier)#,
                    <cfqueryparam cfsqltype="cf_sql_varchar" value="#session.ep.money#">
                    <cfif len(session.ep.money2)>
                        ,#wrk_round(((attributes.ACTION_VALUE + attributes.masraf)*dovizli_islem_multiplier)/currency_multiplier,4)#
                        ,<cfqueryparam cfsqltype="cf_sql_varchar" value="#session.ep.money2#">
                    </cfif>	
                    <cfif len(attributes.project_id)>
                        ,<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.project_id#">
                    </cfif>
                )
            </cfquery>
            <cfquery name="ADD_TERM_DEPOSIT2" datasource="#DSN2#" result="MAX_ID">
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
                    MASRAF,
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
                    <cfif len(attributes.project_id)>
                        ,PROJECT_ID
                    </cfif>
                )
                VALUES
                (
                    <cfqueryparam cfsqltype="cf_sql_varchar" value="#ACTION_TYPE#">,
                    #form.process_cat#,
                    #process_type#,
                    #attributes.to_account_id#,
                    #attributes.OTHER_CASH_ACT_VALUE#,
                    #attributes.ACTION_DATE#,
                    <cfqueryparam cfsqltype="cf_sql_varchar" value="#money_type#">,
                    <cfif isDefined("attributes.ACTION_DETAIL") and len(attributes.ACTION_DETAIL)><cfqueryparam cfsqltype="cf_sql_varchar" value="#ACTION_DETAIL#"><cfelse>NULL</cfif>,
                    #attributes.ACTION_VALUE#,
                    <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.currency_id#">,
                    <cfif is_account eq 1>1,13,<cfelse>0,13,</cfif>
                    <cfif isdefined("attributes.paper_number") and len(attributes.paper_number)><cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.paper_number#"><cfelse>NULL</cfif>,
                    0,
                    #attributes.expense_item_id#,
                    <cfif isdefined('attributes.expense_center_id') and len(attributes.expense_center_id)><cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.expense_center_id#"><cfelse>NULL</cfif>,
                    #SESSION.EP.USERID#,
                    <cfqueryparam cfsqltype="cf_sql_varchar" value="#CGI.REMOTE_ADDR#">,
                    #NOW()#	,
                    #to_branch_id_info#,
                    0,
                    #wrk_round(attributes.system_amount)#,
                    <cfqueryparam cfsqltype="cf_sql_varchar" value="#session.ep.money#">
                    <cfif len(session.ep.money2)>
                        ,#wrk_round((attributes.OTHER_CASH_ACT_VALUE*masraf_curr_multiplier)/currency_multiplier,4)#
                        ,<cfqueryparam cfsqltype="cf_sql_varchar" value="#session.ep.money2#">
                    </cfif>	
                    <cfif len(attributes.project_id)>
                        ,<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.project_id#">
                    </cfif>
                )
            </cfquery>
            <cfset BANK_ACT_ID = MAX_ID.IDENTITYCOL-1>

            <cfset ADD_INTEREST_YIELD = ADD_REVENUE.ADD_INTEREST_YIELD_PLAN(
                                                                        bank_action_id : BANK_ACT_ID,
                                                                        action_type : "",
                                                                        due_value : attributes.due_value,
                                                                        due_value_date : "#attributes.due_value_date#",
                                                                        getiri_orani : "#attributes.getiri_orani#",
                                                                        getiri_tutari : "#attributes.getiri_tutari#",
                                                                        yield_payment_period : attributes.yield_payment_period,
                                                                        ygs : attributes.ygs,
                                                                        special_day : "#iif(isdefined('attributes.special_day') and len(attributes.special_day), 'attributes.special_day', DE(''))#",
                                                                        getiri_tahsil_sayisi : attributes.getiri_tahsil_sayisi,
                                                                        getiri_tahsil_tutari : attributes.getiri_tahsil_tutari
            )>
            <cfset GET_INTEREST_YIELD = ADD_REVENUE.GET_INTEREST_YIELD(  id : BANK_ACT_ID )>

            <cfset row_count = attributes.getiri_tahsil_sayisi>
            <cfloop from="1" to="#row_count#" index="i">
                <cf_date tarih='attributes.bnk_action_date#i#'>
                <cfset ADD_INTEREST_YIELD_ROWS = ADD_REVENUE.ADD_INTEREST_YIELD_ROWS( yield_id :  "#GET_INTEREST_YIELD.YIELD_ID#",
                                                                                       getiri : "#i#. Getiri",
                                                                                       bank_action_date : "#evaluate('attributes.bnk_action_date#i#')#",
                                                                                       getiri_tahsil_tutari : "#evaluate('attributes.getiri_tutari_row#i#')#",
                                                                                       expense_item_tahakkuk_id : "#attributes.expense_item_tahakkuk_id#"  
                                                                                    )>
  
            </cfloop>

            <cfscript>
                if(len(attributes.expense_item_masraf_id) and len(attributes.expense_item_masraf_id) and len (attributes.masraf) and (attributes.masraf gt 0) and len(attributes.expense_center_id) and len(attributes.expense_center_name)){
    
                    if(attributes.currency_id is session.ep.money)
                    {
                        butceci(
                            action_id : BANK_ACT_ID,
                            muhasebe_db : dsn2,
                            is_income_expense : false,
                            process_type : process_type,
                            nettotal : attributes.masraf,
                            other_money_value : wrk_round(attributes.masraf/masraf_curr_multiplier),
                            action_currency : form.money_type,
                            currency_multiplier : currency_multiplier,
                            expense_date : attributes.action_date,
                            expense_center_id : attributes.expense_center_id,
                            expense_item_id : attributes.expense_item_masraf_id,
                            detail : UCase(getLang('main',2700)), //VİRMAN MASRAFI
                            paper_no : attributes.paper_number,
                            branch_id : from_branch_id_info,
                            insert_type : 1,
                            project_id : attributes.project_id
                        );
                    }
                    else
                    {
                        butceci(
                            action_id : BANK_ACT_ID,
                            muhasebe_db : dsn2,
                            is_income_expense : false,
                            process_type : process_type,
                            nettotal : wrk_round(attributes.masraf*dovizli_islem_multiplier),
                            other_money_value : attributes.masraf,
                            action_currency : attributes.currency_id,
                            currency_multiplier : currency_multiplier,
                            expense_date : attributes.action_date,
                            expense_center_id : attributes.expense_center_id,
                            expense_item_id : attributes.expense_item_masraf_id,
                            detail : UCase(getLang('main',2700)), //VİRMAN MASRAFI
                            paper_no : attributes.paper_number,
                            branch_id : from_branch_id_info,
                            insert_type : 1,
                            project_id : attributes.project_id
                        );
                    }
    
                    GET_EXP_ACC = cfquery(datasource : "#dsn2#", sqlstring : "SELECT ACCOUNT_CODE FROM EXPENSE_ITEMS WHERE EXPENSE_ITEM_ID = #attributes.expense_item_masraf_id#"); 
                }
                
            if(is_account eq 1)
			{
                str_card_detail = ArrayNew(2);
				acc_branch_list_borc = '';
				acc_branch_list_alacak = '';
				acc_branch_list_alacak = listappend(acc_branch_list_alacak,from_branch_id_info,',');
                acc_branch_list_borc = listappend(acc_branch_list_borc,to_branch_id_info,',');
                
                str_borclu_hesaplar = attributes.account_acc_code2;
				str_alacakli_hesaplar = attributes.account_acc_code;
                str_tutarlar = attributes.system_amount;
                str_alacakli_tutarlar = attributes.system_amount;

                if(isDefined("attributes.ACTION_DETAIL") and len(attributes.ACTION_DETAIL))
                {
                    str_card_detail[1][listlen(str_tutarlar)]='#attributes.ACTION_DETAIL#';

                    str_card_detail[2][listlen(str_alacakli_tutarlar)]='#attributes.ACTION_DETAIL#';
                }
                else
                {
                    str_card_detail[1][listlen(str_tutarlar)]= UCase(getLang('credit',37)); //VADELI MEVDUAT HESABA YATIRMA

                    str_card_detail[2][listlen(str_alacakli_tutarlar)]= UCase(getLang('credit',37));
                }


				str_borclu_other_amount_tutar = wrk_round(attributes.system_amount/dovizli_islem_multiplier_2);
				str_borclu_other_currency = attributes.currency_id2;
				str_alacakli_other_amount_tutar = attributes.ACTION_VALUE;
                str_alacakli_other_currency = attributes.currency_id;
                
                if(len(attributes.masraf) and attributes.masraf gt 0 and isdefined("attributes.expense_item_masraf_id") and len(attributes.expense_item_masraf_id))
				{
					acc_branch_list_alacak = listappend(acc_branch_list_alacak,from_branch_id_info,',');
					acc_branch_list_borc = listappend(acc_branch_list_borc,from_branch_id_info,',');
                    str_borclu_hesaplar = ListAppend(str_borclu_hesaplar,GET_EXP_ACC.ACCOUNT_CODE,",");    
					str_alacakli_hesaplar = ListAppend(str_alacakli_hesaplar,attributes.account_acc_code,",");	
					
					if(attributes.currency_id is session.ep.money)
					{
						masraf_doviz = wrk_round(attributes.masraf/masraf_curr_multiplier);
						str_tutarlar = ListAppend(str_tutarlar,attributes.masraf,",");
					}
					else
					{
						masraf_doviz = wrk_round(attributes.masraf*dovizli_islem_multiplier);
						str_tutarlar = ListAppend(str_tutarlar,masraf_doviz,",");
                    }
                    
                    if(attributes.currency_id is session.ep.money)
                    {
                        str_alacakli_tutarlar = ListAppend(str_alacakli_tutarlar,attributes.masraf,",");
                    }
                    else
                    {
                        getiri_alacakli_doviz = wrk_round(attributes.masraf*dovizli_islem_multiplier);
                        str_alacakli_tutarlar = ListAppend(str_alacakli_tutarlar,getiri_alacakli_doviz,",");
                    }

                    str_card_detail[1][listlen(str_tutarlar)]= 'MASRAF' ;
                    str_card_detail[2][listlen(str_alacakli_tutarlar)]= 'MASRAF' ;

					str_borclu_other_amount_tutar = ListAppend(str_borclu_other_amount_tutar,attributes.masraf,",");
					str_borclu_other_currency = ListAppend(str_borclu_other_currency,attributes.currency_id,",");
					str_alacakli_other_amount_tutar = ListAppend(str_alacakli_other_amount_tutar,attributes.masraf,",");
					str_alacakli_other_currency = ListAppend(str_alacakli_other_currency,attributes.currency_id,",");
                }
                
                if(is_next_periods_accrual_action eq 1) /* Gelecek Aylara Ait İşlemleri Tahakkuklaştır. */
                {
                    for(j = 1; j <= row_count; j++){

                        str_borclu_hesaplar = ListAppend(str_borclu_hesaplar,get_acc_code_expense_tahakkuk_item.ACCOUNT_CODE,",");
                    

                        if(attributes.currency_id is session.ep.money)
                        {
                            str_tutarlar = ListAppend(str_tutarlar,"#evaluate('attributes.getiri_tutari_row#j#')#",",");
                        }
                        else
                        {
                            getiri_doviz = wrk_round("#evaluate('attributes.getiri_tutari_row#j#')#" *dovizli_islem_multiplier);
                            str_tutarlar = ListAppend(str_tutarlar,getiri_doviz,",");
                        }

                        str_card_detail[1][listlen(str_tutarlar)]= '#j#' & '. GETİRİ' ;

                        str_borclu_other_amount_tutar = ListAppend(str_borclu_other_amount_tutar,"#evaluate('attributes.getiri_tutari_row#j#')#",",");
                        str_borclu_other_currency = ListAppend(str_borclu_other_currency,attributes.currency_id,",");
                        acc_branch_list_borc = listappend(acc_branch_list_borc,from_branch_id_info,',');

                    }

                    str_alacakli_hesaplar = ListAppend(str_alacakli_hesaplar,get_acc_code_expense_item.ACCOUNT_CODE,",");	

                    if(attributes.currency_id is session.ep.money)
                    {
                        str_alacakli_tutarlar = ListAppend(str_alacakli_tutarlar,attributes.getiri_tutari,",");
                    }
                    else
                    {
                        getiri_alacakli_doviz = wrk_round(attributes.getiri_tutari*dovizli_islem_multiplier);
                        str_alacakli_tutarlar = ListAppend(str_alacakli_tutarlar,getiri_alacakli_doviz,",");
                    }

                    str_card_detail[2][listlen(str_alacakli_tutarlar)]= 'TAHSİL';

                    acc_branch_list_alacak = listappend(acc_branch_list_alacak,from_branch_id_info,',');
                    str_alacakli_other_amount_tutar = ListAppend(str_alacakli_other_amount_tutar,attributes.getiri_tutari,",");
                    str_alacakli_other_currency = ListAppend(str_alacakli_other_currency,attributes.currency_id,",");
                }

				muhasebeci(
					action_id:BANK_ACT_ID,
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
					fis_detay : UCase(getLang('main',2724)),
					acc_branch_list_borc : acc_branch_list_borc,
					acc_branch_list_alacak : acc_branch_list_alacak,
                    belge_no : attributes.paper_number,
                    acc_project_id : attributes.project_id
				);
			}	
			f_kur_ekle_action(action_id:BANK_ACT_ID,process_type:0,action_table_name:'BANK_ACTION_MONEY',action_table_dsn:'#dsn2#');
            

            if(is_budget eq 1){

                if(attributes.currency_id is session.ep.money)
                {
                    butceci(
                        action_id : BANK_ACT_ID,
                        muhasebe_db : dsn2,
                        is_income_expense : true,
                        process_type : process_type,
                        nettotal : attributes.getiri_tutari,
                        other_money_value : wrk_round(attributes.getiri_tutari/masraf_curr_multiplier),
                        action_currency : form.money_type,
                        currency_multiplier : currency_multiplier,
                        expense_date : attributes.bnk_action_date1,
                        expense_center_id : attributes.expense_center_id,
                        expense_item_id : attributes.expense_item_tahakkuk_id,
                        detail : 'VADELİ MEVDUAT HESABA YATIRMA',
                        paper_no : attributes.paper_number,
                        branch_id : ListGetAt(session.ep.user_location,2,"-"),
                        insert_type : 1
                    );
                }else{
                    butceci(
                        action_id : BANK_ACT_ID,
                        muhasebe_db : dsn2,
                        is_income_expense : true,
                        process_type : process_type,
                        nettotal : wrk_round(attributes.getiri_tutari*dovizli_islem_multiplier),
                        other_money_value :  attributes.getiri_tutari,
                        action_currency : attributes.currency_id,
                        currency_multiplier : currency_multiplier,
                        expense_date : attributes.bnk_action_date1,
                        expense_center_id : attributes.expense_center_id,
                        expense_item_id : attributes.expense_item_tahakkuk_id,
                        detail : 'VADELİ MEVDUAT HESABA YATIRMA',
                        paper_no : attributes.paper_number,
                        branch_id : ListGetAt(session.ep.user_location,2,"-"),
                        insert_type : 1
                    );
                }
            }

            </cfscript>
            <cfif ACCRUAL_BUDGET_ACTION eq 1> <!---Tahakkuk işlemine göre bütçe plan kaydı at.. bütçe planlama fişlerini oluşturuyoruz ve senaryoya yazıyoruz --->
                <cfquery name="ADD_BUDGET_PLAN" datasource="#dsn2#" result="MAX_ID">
                    INSERT INTO
                        #dsn_alias#.BUDGET_PLAN
                    (
                        PROCESS_STAGE,
                        PROCESS_TYPE,
                        PROCESS_CAT,
                        PAPER_NO,
                        BUDGET_PLAN_DATE,
                        BUDGET_PLANNER_EMP_ID,
                        DETAIL,
                        INCOME_TOTAL,
                        EXPENSE_TOTAL,
                        DIFF_TOTAL,
                        INCOME_TOTAL_2,
                        EXPENSE_TOTAL_2,
                        DIFF_TOTAL_2,
                        OTHER_INCOME_TOTAL,
                        OTHER_EXPENSE_TOTAL,
                        OTHER_DIFF_TOTAL,
                        OTHER_MONEY,
                        IS_SCENARIO,
                        BRANCH_ID,
                        ACC_DEPARTMENT_ID,
                        RECORD_DATE,
                        RECORD_IP,
                        RECORD_EMP,
                        OUR_COMPANY_ID,
                        PERIOD_ID,
                        DOCUMENT_TYPE,
                        PAYMENT_METHOD,
                        DUE_DATE
                    )
                    VALUES
                    (
                        9,
                        160,
                        108,
                        'VDM-BGP-#BANK_ACT_ID#' ,
                        #attributes.ACTION_DATE#,
                        NULL,
                        'VADELİ MEVDUAT BÜTÇE TAHAKKUKU',
                        #attributes.getiri_tutari#,
                        0,
                        #attributes.getiri_tutari#,
                        #wrk_round(attributes.getiri_tutari*dovizli_islem_multiplier)#,
                        NULL,
                        #wrk_round(attributes.getiri_tutari/currency_multiplier)#,
                        #attributes.getiri_tutari#,
                        0,
                        NULL,
                        '#attributes.currency_id#',
                        1,
                        NULL,
                        NULL,
                        #now()#,
                        '#cgi.remote_addr#',
                        #session.ep.userid#,
                        #session.ep.company_id#,
                        #session.ep.period_id#,
                        NULL,
                        NULL,
                        NULL
                    )
                </cfquery>
                
                <cfset GET_MAX_ID.MAX_ID = MAX_ID.IDENTITYCOL>

                <cfloop from="1" to="#row_count#" index="i">
                    <cfquery name="ADD_BUDGET_PLAN_ROW" datasource="#dsn2#">
                        INSERT INTO
                            #dsn_alias#.BUDGET_PLAN_ROW
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
                                #evaluate('attributes.bnk_action_date#i#')#,
                                '#i#. Getiri',
                                #attributes.expense_center_id#, <!--- Masraf gelir merkezi --->
                                #attributes.expense_item_tahakkuk_id#,
                                '#get_acc_code_expense_tahakkuk_item.ACCOUNT_CODE#',
                                #evaluate('attributes.getiri_tutari_row#i#')#,
                                0,
                                #evaluate('attributes.getiri_tutari_row#i#')#,
                                #wrk_round(evaluate('attributes.getiri_tutari_row#i#')/currency_multiplier)#,
                                0,
                                #wrk_round(evaluate('attributes.getiri_tutari_row#i#')/currency_multiplier)#,
                                #wrk_round(evaluate('attributes.getiri_tutari_row#i#')/dovizli_islem_multiplier,4)#,
                                0,
                                #wrk_round(evaluate('attributes.getiri_tutari_row#i#')/dovizli_islem_multiplier,4)#,
                                0
                            )
                    </cfquery>
                </cfloop>
                <!--- money kayıtları --->
                <cfloop from="1" to="#attributes.kur_say#" index="i">
                    <cfquery name="ADD_MONEY_INFO" datasource="#dsn2#">
                        INSERT INTO
                            #dsn_alias#.BUDGET_PLAN_MONEY 
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
                            '#wrk_eval("attributes.hidden_rd_money_#i#")#',
                            #evaluate("attributes.txt_rate2_#i#")#,
                            #evaluate("attributes.txt_rate1_#i#")#,
                            <cfif evaluate("attributes.hidden_rd_money_#i#") is form.money_type>1<cfelse>0</cfif>
                        )
                    </cfquery>
                </cfloop>

                <cfquery name="update_plan" datasource="#dsn2#">
                    UPDATE INTEREST_YIELD_PLAN SET BUDGET_PLAN_ID = #GET_MAX_ID.MAX_ID# WHERE YIELD_ID = #GET_INTEREST_YIELD.YIELD_ID#
                </cfquery>
            </cfif>

             <!--- Belge No update ediliyor --->
             <cfquery name="UPD_GENERAL_PAPERS" datasource="#DSN2#">
                UPDATE 
                    #dsn3_alias#.GENERAL_PAPERS
                SET
                    VIRMAN_NUMBER = #paper_number#
                WHERE
                    VIRMAN_NUMBER IS NOT NULL
            </cfquery>
        </cftransaction>
    </cflock>
    <cf_workcube_process 
        is_upd='1' 
        old_process_line='0'
        process_stage='#attributes.process_stage#' 
        record_member='#session.ep.userid#' 
        record_date='#now()#'
        action_table='BANK_ACTIONS'
        action_column='ACTION_ID'
        action_id='#BANK_ACT_ID#'
        action_page='#request.self#?fuseaction=bank.form_add_term_deposit&event=upd&ID=#BANK_ACT_ID#' 
        warning_description='#getLang('credit',37)#'> 
    <script type="text/javascript">
        window.location.href="<cfoutput>#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.form_add_term_deposit&event=upd&id=#BANK_ACT_ID#</cfoutput>";
    </script>
    <cf_get_lang_set module_name="#lcase(listgetat(attributes.fuseaction,1,'.'))#">
    