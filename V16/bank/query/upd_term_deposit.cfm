<cf_get_lang_set module_name="bank">
    <cfif form.active_period neq session.ep.period_id>
        <script type="text/javascript">
            alert("<cf_get_lang_main no='1659.İşlem Yapmak İstediğiniz Muhasebe Dönemi ile Aktif Muhasebe Döneminiz Farklı Muhasebe Döneminizi Kontrol Ediniz'>!");
            window.location.href='<cfoutput>#request.self#?fuseaction=bank.list_bank_actions</cfoutput>';
        </script>
        <cfabort>
    </cfif>

    <cfset UPD_REVENUE = createObject("component", "V16.bank.cfc.vadeliMevduat")>
    <cfset get_process_type = UPD_REVENUE.get_process_type( process_cat : form.process_cat )>
    <cfset get_acc_code_expense_item = UPD_REVENUE.get_acc_code_exp( expense_item_id : attributes.expense_item_id )>
    <cfset get_acc_code_expense_tahakkuk_item = UPD_REVENUE.get_acc_code_exp( expense_item_id : attributes.expense_item_tahakkuk_id )>
    <cfscript>
        process_type = get_process_type.PROCESS_TYPE;
        is_cari =get_process_type.IS_CARI;
        is_account = get_process_type.IS_ACCOUNT;
        is_budget = get_process_type.IS_BUDGET;
        is_next_periods_accrual_action = get_process_type.NEXT_PERIODS_ACCRUAL_ACTION;
        ACCRUAL_BUDGET_ACTION = get_process_type.ACCRUAL_BUDGET_ACTION;
        attributes.ACTION_VALUE = filterNum(attributes.ACTION_VALUE);
        attributes.OTHER_CASH_ACT_VALUE= filterNum(attributes.OTHER_CASH_ACT_VALUE);
        attributes.system_amount = filterNum(attributes.system_amount);
        attributes.masraf = filterNum(attributes.masraf);
        for(t=1;t lte attributes.kur_say;t=t+1)
        {
            'attributes.txt_rate1_#t#' = filterNum(evaluate("attributes.txt_rate1_#t#"),session.ep.our_company_info.rate_round_num) ;
            'attributes.txt_rate2_#t#' = filterNum(evaluate("attributes.txt_rate2_#t#"),session.ep.our_company_info.rate_round_num) ;
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
        currency_multiplier = '';
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
        SELECT PAPER_NO FROM BANK_ACTIONS WHERE PAPER_NO = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.paper_number#"> AND ACTION_ID NOT IN (#attributes.IDS#)
    </cfquery>
    <cfif control_paper_no.recordcount>
        <script type="text/javascript">
            alert("<cf_get_lang no ='348.Girdiginiz Belge Numarası Kullanılmaktadır'>!");
            history.back();	
        </script>
        <cfabort>
    </cfif>
    <cf_date tarih='attributes.ACTION_DATE'>
    <cf_date tarih="attributes.due_value_date">
        <!--- <cf_papers paper_type="term_deposit"> --->
        <cfif not len(attributes.masraf)>
            <cfset attributes.masraf = 0>
        </cfif>
    <cflock name="#createUUID()#" timeout="20">
        <cftransaction>
            <cfscript>
                /* BANK ACTIONS */
             UPD_TERM_DEPOSIT = UPD_REVENUE.UPD_INTEREST_REVENUE(   action_id : listfirst(ATTRIBUTES.IDS,','),
                                                                    process_cat : form.process_cat,
                                                                    action_value : "#iif(len(attributes.masraf) , 'attributes.ACTION_VALUE + attributes.masraf' , DE('attributes.ACTION_VALUE'))#",
                                                                    action_date : "#attributes.ACTION_DATE#",
                                                                    action_currency_id : attributes.currency_id,
                                                                    action_from_account_id : attributes.from_account_id,
                                                                    action_detail : "#attributes.ACTION_DETAIL#",
                                                                    other_cash_act_value :"#iif(len(attributes.OTHER_CASH_ACT_VALUE), 'attributes.OTHER_CASH_ACT_VALUE', DE(''))#",
                                                                    other_money : "#iif(len(money_type), 'money_type' ,DE(''))#",
                                                                    is_account : "#iif( (is_account eq 1), '1' , DE('0'))#",
                                                                    is_account_type : 13,
                                                                    paper_no : "#iif(isdefined('attributes.paper_number') and len(attributes.paper_number), 'attributes.paper_number', DE(''))#",
                                                                    process_stage : "#iif(isdefined('attributes.process_stage') and len(attributes.process_stage), 'attributes.process_stage', DE(''))#",
                                                                    masraf : "#iif(isdefined('attributes.masraf') and attributes.masraf gt 0, 'attributes.masraf', DE('0'))#",
                                                                    expense_item_id : attributes.expense_item_id,
                                                                    expense_center_id : "#iif(isdefined('attributes.expense_center_id'), 'attributes.expense_center_id', DE('0'))#",
                                                                    from_branch_id : from_branch_id_info,
                                                                    system_action_value : wrk_round((attributes.ACTION_VALUE + attributes.masraf)*dovizli_islem_multiplier),
                                                                    action_value_2 :  "#iif(len(session.ep.money2), 'wrk_round(((attributes.ACTION_VALUE + attributes.masraf)*dovizli_islem_multiplier)/currency_multiplier,4)', DE(''))#",
                                                                    project_id : "#iif(isdefined('attributes.project_id') and len(attributes.project_id), 'attributes.project_id', DE(''))#"
             );
                /* BANK ACTIONS */
             UPD_TERM_DEPOSIT2 = UPD_REVENUE.UPD_INTEREST_REVENUE2( action_id : listlast(ATTRIBUTES.IDS,','),
                                                                    process_cat : form.process_cat,
                                                                    action_value : "#attributes.OTHER_CASH_ACT_VALUE#",
                                                                    action_date : "#attributes.ACTION_DATE#",
                                                                    action_currency_id : "#money_type#",
                                                                    action_to_account_id : attributes.to_account_id,
                                                                    action_detail : "#attributes.ACTION_DETAIL#",
                                                                    other_cash_act_value :"#attributes.ACTION_VALUE#",
                                                                    other_money : "#attributes.currency_id#",
                                                                    is_account : "#iif( (is_account eq 1), '1' , DE('0'))#",
                                                                    is_account_type : 13,
                                                                    paper_no : "#iif(isdefined('attributes.paper_number') and len(attributes.paper_number), 'attributes.paper_number', DE(''))#",
                                                                    masraf : 0,
                                                                    expense_item_id : attributes.expense_item_id,
                                                                    expense_center_id : "#iif(isdefined('attributes.expense_center_id'), 'attributes.expense_center_id', DE('0'))#",
                                                                    to_branch_id : to_branch_id_info,
                                                                    system_action_value : wrk_round(attributes.system_amount),
                                                                    action_value_2 :  "#iif(len(session.ep.money2), 'wrk_round((attributes.OTHER_CASH_ACT_VALUE*masraf_curr_multiplier)/currency_multiplier,4)', DE(''))#",
                                                                    project_id : "#iif(isdefined('attributes.project_id') and len(attributes.project_id), 'attributes.project_id', DE(''))#"
             );
                /* GETİRİ */
             UPD_INTEREST_YIELD = UPD_REVENUE.UPD_INTEREST_YIELD(   action_type : '',
                                                                    due_value : attributes.due_value,
                                                                    due_value_date : "#attributes.due_value_date#",
                                                                    getiri_orani : "#attributes.getiri_orani#",
                                                                    getiri_tutari : "#attributes.getiri_tutari#",
                                                                    yield_payment_period : attributes.yield_payment_period,
                                                                    ygs : attributes.ygs,
                                                                    special_day : "#iif(isdefined('attributes.special_day') and len(attributes.special_day), 'attributes.special_day', DE(''))#",
                                                                    getiri_tahsil_sayisi : attributes.getiri_tahsil_sayisi,
                                                                    getiri_tahsil_tutari : attributes.getiri_tahsil_tutari,
                                                                    finansal_senaryo : attributes.finansal_senaryo,
                                                                    id : attributes.id
             );
            
             GET_INTEREST_YIELD = UPD_REVENUE.GET_INTEREST_YIELD(  id : attributes.id );
             DELETE_INTEREST_YIELD_ROWS = UPD_REVENUE.DELETE_INTEREST_YIELD_ROWS( id : "#GET_INTEREST_YIELD.YIELD_ID#" );
            </cfscript>

            <cfset row_count = attributes.getiri_tahsil_sayisi>
            <cfloop from="1" to="#row_count#" index="i">    <!--- GETİRİ ROWS --->
                <cf_date tarih='attributes.bnk_action_date#i#'>
                <cfset ADD_INTEREST_YIELD_ROWS = UPD_REVENUE.ADD_INTEREST_YIELD_ROWS(  yield_id :  "#GET_INTEREST_YIELD.YIELD_ID#",
                                                                                       getiri : "#i#. Getiri",
                                                                                       bank_action_date : "#evaluate('attributes.bnk_action_date#i#')#",
                                                                                       getiri_tahsil_tutari : "#evaluate('attributes.getiri_tutari_row#i#')#",
                                                                                       expense_item_tahakkuk_id : "#attributes.expense_item_tahakkuk_id#" 
                                                                                        )>

            </cfloop>

            <cfscript>
            butce_sil(action_id:attributes.id,process_type:form.old_process_type);
            if(len(attributes.expense_item_masraf_id) and len(attributes.expense_item_masraf_id) and len (attributes.masraf) and (attributes.masraf gt 0) and len(attributes.expense_center_id) and len(attributes.expense_center_name)){

                if(attributes.currency_id is session.ep.money)
				{
					butceci(
						action_id : listfirst(ATTRIBUTES.IDS,','),
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
						action_id : listfirst(ATTRIBUTES.IDS,','),
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
					action_id:listfirst(ATTRIBUTES.IDS,','),
					workcube_process_type:process_type,
					workcube_old_process_type:form.old_process_type,
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
			else{
				muhasebe_sil(action_id:listfirst(ATTRIBUTES.IDS,','),process_type:form.old_process_type);
                f_kur_ekle_action(action_id:listfirst(ATTRIBUTES.IDS,','),process_type:1,action_table_name:'BANK_ACTION_MONEY',action_table_dsn:'#dsn2#');
            }
            if(is_budget eq 1){

                if(attributes.currency_id is session.ep.money)
				{
                    butceci(
                        action_id : listfirst(ATTRIBUTES.IDS,','),
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
                        action_id : listfirst(ATTRIBUTES.IDS,','),
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

                <cfif len(GET_INTEREST_YIELD.BUDGET_PLAN_ID)>
                    <cfquery name="ADD_BUDGET_PLAN" datasource="#dsn2#">
                        UPDATE
                            #dsn_alias#.BUDGET_PLAN
                        SET
                            INCOME_TOTAL =  #attributes.getiri_tutari#,
                            DIFF_TOTAL =  #attributes.getiri_tutari#,
                            INCOME_TOTAL_2 = #wrk_round(attributes.getiri_tutari*dovizli_islem_multiplier)#,
                            DIFF_TOTAL_2 = #wrk_round(attributes.getiri_tutari/currency_multiplier)#,
                            OTHER_INCOME_TOTAL = #attributes.getiri_tutari#,
                            OTHER_DIFF_TOTAL = #attributes.getiri_tutari#,
                            UPDATE_DATE = #now()#,
                            UPDATE_IP = '#cgi.remote_addr#',
                            UPDATE_EMP = #session.ep.userid#
                        WHERE
                            BUDGET_PLAN_ID = #GET_INTEREST_YIELD.BUDGET_PLAN_ID#
                    </cfquery>
                <cfelse>
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
                            'VDM-BGP-#listfirst(ATTRIBUTES.IDS,',')#' ,
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
                    <cfset GET_INTEREST_YIELD.BUDGET_PLAN_ID = MAX_ID.IDENTITYCOL>
                </cfif>

                <cfif len(GET_INTEREST_YIELD.BUDGET_PLAN_ID)>
                    <cfquery name="get_all_row" datasource="#dsn2#">
                        SELECT BUDGET_PLAN_ROW_ID FROM #dsn_alias#.BUDGET_PLAN_ROW WHERE BUDGET_PLAN_ID = #GET_INTEREST_YIELD.BUDGET_PLAN_ID#
                    </cfquery>

                    <cfset plan_row_list = valuelist(get_all_row.budget_plan_row_id)>
                </cfif>
                
                <cfif isdefined("plan_row_list") and len(plan_row_list)>
                    <cfquery name="DEL_ROW" datasource="#dsn2#">
                        DELETE FROM #dsn_alias#.BUDGET_PLAN_ROW WHERE BUDGET_PLAN_ROW_ID IN (#plan_row_list#)
                    </cfquery>
                </cfif>
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
                                #GET_INTEREST_YIELD.BUDGET_PLAN_ID#,
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

                <cfquery name="DEL_BUDGET_PLAN_MONEY" datasource="#dsn2#">
                    DELETE FROM #dsn_alias#.BUDGET_PLAN_MONEY WHERE ACTION_ID = #GET_INTEREST_YIELD.BUDGET_PLAN_ID#
                </cfquery>

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
                            #GET_INTEREST_YIELD.BUDGET_PLAN_ID#,
                            '#wrk_eval("attributes.hidden_rd_money_#i#")#',
                            #evaluate("attributes.txt_rate2_#i#")#,
                            #evaluate("attributes.txt_rate1_#i#")#,
                            <cfif evaluate("attributes.hidden_rd_money_#i#") is form.money_type>1<cfelse>0</cfif>
                        )
                    </cfquery>
                </cfloop>
                <cfquery name="UPDATE_YIELD_PLAN" datasource="#dsn2#"> <!--- PLANLAMA FİŞ İDSİNİ VADELİ MEVDUAT BELGESİNE YAZIYORUZ. --->
                    UPDATE INTEREST_YIELD_PLAN SET BUDGET_PLAN_ID = #GET_INTEREST_YIELD.BUDGET_PLAN_ID# WHERE YIELD_ID = #GET_INTEREST_YIELD.YIELD_ID#
                </cfquery>
            <cfelse>
                <cfif len(GET_INTEREST_YIELD.BUDGET_PLAN_ID)>
                    <cfquery name="DELETE_BUDGET_PLAN" datasource="#dsn2#">
                        DELETE FROM #dsn_alias#.BUDGET_PLAN WHERE BUDGET_PLAN_ID = #GET_INTEREST_YIELD.BUDGET_PLAN_ID#
                    </cfquery>
                    <cfquery name="DELETE_BUDGET_PLAN_ROW" datasource="#dsn2#">
                        DELETE FROM #dsn_alias#.BUDGET_PLAN_ROW WHERE BUDGET_PLAN_ID = #GET_INTEREST_YIELD.BUDGET_PLAN_ID#
                    </cfquery>
                    <cfquery name="DEL_BUDGET_PLAN_MONEY" datasource="#dsn2#">
                        DELETE FROM #dsn_alias#.BUDGET_PLAN_MONEY WHERE ACTION_ID = #GET_INTEREST_YIELD.BUDGET_PLAN_ID#
                    </cfquery>
                    <cfquery name="DELETE_YIELD_PLAN_BUDGET" datasource="#dsn2#"> <!--- PLANLAMA FİŞ İDSİNİ VADELİ MEVDUAT BELGESİNE YAZIYORUZ. --->
                        UPDATE INTEREST_YIELD_PLAN SET BUDGET_PLAN_ID = NULL WHERE YIELD_ID = #GET_INTEREST_YIELD.YIELD_ID#
                    </cfquery>
                </cfif>
            </cfif>
        </cftransaction>
    </cflock>

    <cf_workcube_process 
        is_upd="1" 
        old_process_line="#attributes.old_process_line#"
        process_stage="#attributes.process_stage#" 
        record_member="#session.ep.userid#"
        record_date="#now()#" 
        action_table='BANK_ACTIONS'
        action_column='ACTION_ID'
        action_id="#attributes.id#" 
        action_page="#request.self#?fuseaction=bank.form_add_term_deposit&event=upd&ID=#attributes.id#" 
        warning_description="#getLang('credit',37)#">
       
    <script type="text/javascript">
        window.location.href='<cfoutput>#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.form_add_term_deposit&event=upd&id=#listfirst(ATTRIBUTES.IDS,',')#</cfoutput>';
    </script>
    <cf_get_lang_set module_name="#lcase(listgetat(attributes.fuseaction,1,'.'))#">
    