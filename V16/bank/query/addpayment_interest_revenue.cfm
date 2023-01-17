<cfif form.active_period neq session.ep.period_id>
    <script type="text/javascript">
        alert("<cf_get_lang_main no='1659.İşlem Yapmak İstediğiniz Muhasebe Dönemi ile Aktif Muhasebe Döneminiz Farklı Muhasebe Döneminizi Kontrol Ediniz'>!");
        window.location.href='<cfoutput>#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.list_bank_actions</cfoutput>';
    </script>
    <cfabort>
</cfif>
<cfquery name="control_paper_no" datasource="#dsn2#">
	SELECT PAPER_NO FROM BANK_ACTIONS WHERE PAPER_NO = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.paper_number#">
</cfquery>
<cfif control_paper_no.recordcount>
		<cf_get_lang no ='401.Aynı Belge No İle Kayıtlı Gelen Havale İşlemi Var'>!<br/>
</cfif>
    <cfif isdefined("attributes.showPrincipal") and attributes.showPrincipal eq 1>
        <cfset attributes.principal = filterNum(attributes.principal)>
    <cfelse>
        <cfset attributes.principal = 0>
    </cfif>
        <cfset attributes.stopaj_rate = filterNum(attributes.stopaj_rate)>

     <cfquery name="get_stoppage_acc_code" datasource="#dsn2#">
        SELECT STOPPAGE_ACCOUNT_CODE FROM SETUP_STOPPAGE_RATES WHERE SETUP_BANK_TYPE_ID = #attributes.bank_code# and STOPPAGE_RATE = #attributes.stopaj_rate#
    </cfquery> 
    <cf_papers paper_type="incoming_transfer">
    <cfset ADD_INTEREST = createObject("component", "V16.bank.cfc.vadeliMevduat")>
    <cfset get_process_type = ADD_INTEREST.get_process_type( process_cat : form.process_cat )>
    <cfset get_acc_code_expense_item = ADD_INTEREST.get_acc_code_exp( expense_item_id : attributes.expense_item_id )>
    <cfset acc_tahakkuk_code = ADD_INTEREST.get_acc_code_exp( expense_item_id : attributes.acc_tahakkuk_code)>

    <cfscript>
        process_type = get_process_type.PROCESS_TYPE;
        is_account = get_process_type.IS_ACCOUNT;
        is_budget = get_process_type.IS_BUDGET;
        attributes.total_action_value = filterNum(attributes.total_action_value);
        attributes.OTHER_CASH_ACT_VALUE = filterNum(attributes.OTHER_CASH_ACT_VALUE);

        attributes.stopaj_rate = filterNum(attributes.stopaj_rate);
        attributes.stopaj_total = filterNum(attributes.stopaj_total);
        attributes.net_total = filterNum(attributes.net_total);

        attributes.system_amount = filterNum(attributes.system_amount);
        attributes.masraf = filterNum(attributes.masraf);
        
        if( len(attributes.total_reeskont) ){
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
    <cfif not len(attributes.masraf)>
        <cfset attributes.masraf = 0>
    </cfif>

    <cf_date tarih="attributes.ACTION_DATE">

        <cflock name="#createUUID()#" timeout="20">		
            <cftransaction>
                <cfif attributes.from_account_id eq attributes.to_account_id>
                    <cfquery name="ADD_INTEREST_REVENUE" datasource="#dsn2#">
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
                        )
                        VALUES
                        (
                            <cfqueryparam cfsqltype="cf_sql_varchar" value="#ACTION_TYPE#">,
                            #form.process_cat#,
                            #process_type#,
                            #attributes.from_account_id#,
                            #attributes.stopaj_total#,
                            #attributes.ACTION_DATE#,
                            <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.currency_id#">,
                            <cfif isDefined("attributes.ACTION_DETAIL") and len(attributes.ACTION_DETAIL)><cfqueryparam cfsqltype="cf_sql_varchar" value="#ACTION_DETAIL#"><cfelse>'Vadeli Mevduat Getiri Stopaj Kesintisi'</cfif>,
                            <cfif isDefined("attributes.OTHER_CASH_ACT_VALUE") and len(attributes.OTHER_CASH_ACT_VALUE)>#attributes.OTHER_CASH_ACT_VALUE#<cfelse>NULL</cfif>,
                            <cfif isDefined("attributes.money_type") and len(attributes.money_type)><cfqueryparam cfsqltype="cf_sql_varchar" value="#form.money_type#"><cfelse>NULL</cfif>,
                            <cfif is_account eq 1>1,13,<cfelse>0,13,</cfif>
                            <cfif isdefined("attributes.paper_number") and len(attributes.paper_number)><cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.paper_number#"><cfelse>NULL</cfif>,
                            0,
                            #attributes.expense_item_id#,
                            <cfif isdefined('attributes.expense_center_id') and len(attributes.expense_center_id)><cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.expense_center_id#"><cfelse>NULL</cfif>,
                            #SESSION.EP.USERID#,
                            <cfqueryparam cfsqltype="cf_sql_varchar" value="#CGI.REMOTE_ADDR#">,
                            #NOW()#	,
                            #from_branch_id_info#,
                            1,
                            #wrk_round((attributes.principal + attributes.total_action_value + attributes.masraf)*dovizli_islem_multiplier)#,
                            <cfqueryparam cfsqltype="cf_sql_varchar" value="#session.ep.money#">
                            <cfif len(session.ep.money2)>
                                ,#wrk_round(((attributes.principal + attributes.total_action_value + attributes.masraf)*dovizli_islem_multiplier)/currency_multiplier,4)#
                                ,<cfqueryparam cfsqltype="cf_sql_varchar" value="#session.ep.money2#">
                            </cfif>
                        )
                    </cfquery>
                    <cfquery name="ADD_INTEREST_REVENUE_2" datasource="#dsn2#" result="MAX_ID">
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
                        )
                        VALUES
                        (
                            <cfqueryparam cfsqltype="cf_sql_varchar" value="#ACTION_TYPE#">,
                            #form.process_cat#,
                            #process_type#,
                            #attributes.to_account_id#,
                            <cfif len(attributes.masraf) and attributes.masraf gt 0>#attributes.total_action_value + attributes.masraf#,<cfelse>#attributes.total_action_value#,</cfif>
                            #attributes.ACTION_DATE#,
                            <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.currency_id#">,
                            <cfif isDefined("attributes.ACTION_DETAIL") and len(attributes.ACTION_DETAIL)><cfqueryparam cfsqltype="cf_sql_varchar" value="#ACTION_DETAIL#"><cfelse>'Vadeli Mevduat Getiri'</cfif>,
                            <cfif isDefined("attributes.OTHER_CASH_ACT_VALUE") and len(attributes.OTHER_CASH_ACT_VALUE)>#attributes.OTHER_CASH_ACT_VALUE#<cfelse>NULL</cfif>,
                            <cfif isDefined("attributes.money_type") and len(attributes.money_type)><cfqueryparam cfsqltype="cf_sql_varchar" value="#form.money_type#"><cfelse>NULL</cfif>,
                            <cfif is_account eq 1>1,13,<cfelse>0,13,</cfif>
                            <cfif isdefined("attributes.paper_number") and len(attributes.paper_number)><cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.paper_number#"><cfelse>NULL</cfif>,
                            <cfif len(attributes.masraf) and attributes.masraf gt 0>#attributes.masraf#,<cfelse>0,</cfif>
                            #attributes.expense_item_id#,
                            <cfif isdefined('attributes.expense_center_id') and len(attributes.expense_center_id)><cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.expense_center_id#"><cfelse>NULL</cfif>,
                            #SESSION.EP.USERID#,
                            <cfqueryparam cfsqltype="cf_sql_varchar" value="#CGI.REMOTE_ADDR#">,
                            #NOW()#	,
                            #to_branch_id_info#,
                            0,
                            #wrk_round((attributes.principal + attributes.total_action_value + attributes.masraf)*dovizli_islem_multiplier)#,
                            <cfqueryparam cfsqltype="cf_sql_varchar" value="#session.ep.money#">
                            <cfif len(session.ep.money2)>
                                ,#wrk_round(((attributes.principal + attributes.total_action_value + attributes.masraf)*dovizli_islem_multiplier)/currency_multiplier,4)#
                                ,<cfqueryparam cfsqltype="cf_sql_varchar" value="#session.ep.money2#">
                            </cfif>
                        )
                    </cfquery>
                <cfset BANK_ACT_ID = MAX_ID.IDENTITYCOL-1>
                <cfelse>
                    <cfquery name="ADD_INTEREST_REVENUE_4" datasource="#dsn2#">
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
                        )
                        VALUES
                        (
                            <cfqueryparam cfsqltype="cf_sql_varchar" value="#ACTION_TYPE#">,
                            #form.process_cat#,
                            #process_type#,
                            #attributes.to_account_id#,
                            #attributes.principal + attributes.total_action_value - attributes.stopaj_total#,
                            #attributes.ACTION_DATE#,
                            <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.currency_id#">,
                            <cfif isDefined("attributes.ACTION_DETAIL") and len(attributes.ACTION_DETAIL)><cfqueryparam cfsqltype="cf_sql_varchar" value="#ACTION_DETAIL#"><cfelse>NULL</cfif>,
                            <cfif isDefined("attributes.OTHER_CASH_ACT_VALUE") and len(attributes.OTHER_CASH_ACT_VALUE)>#attributes.OTHER_CASH_ACT_VALUE#<cfelse>NULL</cfif>,
                            <cfif isDefined("attributes.money_type") and len(attributes.money_type)><cfqueryparam cfsqltype="cf_sql_varchar" value="#form.money_type#"><cfelse>NULL</cfif>,
                            <cfif is_account eq 1>1,13,<cfelse>0,13,</cfif>
                            <cfif isdefined("attributes.paper_number") and len(attributes.paper_number)><cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.paper_number#"><cfelse>NULL</cfif>,
                            <cfif len(attributes.masraf) and attributes.masraf gt 0>#attributes.masraf#,<cfelse>0,</cfif>
                            #attributes.expense_item_id#,
                            <cfif isdefined('attributes.expense_center_id') and len(attributes.expense_center_id)><cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.expense_center_id#"><cfelse>NULL</cfif>,
                            #SESSION.EP.USERID#,
                            <cfqueryparam cfsqltype="cf_sql_varchar" value="#CGI.REMOTE_ADDR#">,
                            #NOW()#	,
                            #to_branch_id_info#,
                            0,
                            #wrk_round((attributes.principal + attributes.total_action_value - attributes.stopaj_total)*dovizli_islem_multiplier)#,
                            <cfqueryparam cfsqltype="cf_sql_varchar" value="#session.ep.money#">
                            <cfif len(session.ep.money2)>
                                ,#wrk_round(((attributes.principal + attributes.total_action_value - attributes.stopaj_total)*dovizli_islem_multiplier)/currency_multiplier,4)#
                                ,<cfqueryparam cfsqltype="cf_sql_varchar" value="#session.ep.money2#">
                            </cfif>
                        )
                    </cfquery> 
                    <cfquery name="ADD_INTEREST_REVENUE_3" datasource="#dsn2#">
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
                        )
                        VALUES
                        (
                            <cfqueryparam cfsqltype="cf_sql_varchar" value="#ACTION_TYPE#">,
                            #form.process_cat#,
                            #process_type#,
                            #attributes.from_account_id#,
                            #attributes.principal + attributes.total_action_value - attributes.stopaj_total#,
                            #attributes.ACTION_DATE#,
                            <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.currency_id#">,
                            <cfif isDefined("attributes.ACTION_DETAIL") and len(attributes.ACTION_DETAIL)><cfqueryparam cfsqltype="cf_sql_varchar" value="#ACTION_DETAIL#"><cfelse>NULL</cfif>,
                            <cfif isDefined("attributes.OTHER_CASH_ACT_VALUE") and len(attributes.OTHER_CASH_ACT_VALUE)>#attributes.OTHER_CASH_ACT_VALUE#<cfelse>NULL</cfif>,
                            <cfif isDefined("attributes.money_type") and len(attributes.money_type)><cfqueryparam cfsqltype="cf_sql_varchar" value="#form.money_type#"><cfelse>NULL</cfif>,
                            <cfif is_account eq 1>1,13,<cfelse>0,13,</cfif>
                            <cfif isdefined("attributes.paper_number") and len(attributes.paper_number)><cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.paper_number#"><cfelse>NULL</cfif>,
                            <cfif len(attributes.masraf) and attributes.masraf gt 0>#attributes.masraf#,<cfelse>0,</cfif>
                            #attributes.expense_item_id#,
                            <cfif isdefined('attributes.expense_center_id') and len(attributes.expense_center_id)><cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.expense_center_id#"><cfelse>NULL</cfif>,
                            #SESSION.EP.USERID#,
                            <cfqueryparam cfsqltype="cf_sql_varchar" value="#CGI.REMOTE_ADDR#">,
                            #NOW()#	,
                            #from_branch_id_info#,
                            1,
                            #wrk_round((attributes.principal + attributes.total_action_value - attributes.stopaj_total)*dovizli_islem_multiplier)#,
                            <cfqueryparam cfsqltype="cf_sql_varchar" value="#session.ep.money#">
                            <cfif len(session.ep.money2)>
                                ,#wrk_round(((attributes.principal + attributes.total_action_value - attributes.stopaj_total)*dovizli_islem_multiplier)/currency_multiplier,4)#
                                ,<cfqueryparam cfsqltype="cf_sql_varchar" value="#session.ep.money2#">
                            </cfif>
                        )
                    </cfquery>
                    <cfquery name="ADD_INTEREST_REVENUE" datasource="#dsn2#">
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
                        )
                        VALUES
                        (
                            <cfqueryparam cfsqltype="cf_sql_varchar" value="#ACTION_TYPE#">,
                            #form.process_cat#,
                            #process_type#,
                            #attributes.from_account_id#,
                            #attributes.stopaj_total#,
                            #attributes.ACTION_DATE#,
                            <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.currency_id#">,
                            'V. Mevduat Stopaj Kesintisi',
                            <cfif isDefined("attributes.OTHER_CASH_ACT_VALUE") and len(attributes.OTHER_CASH_ACT_VALUE)>#attributes.OTHER_CASH_ACT_VALUE#<cfelse>NULL</cfif>,
                            <cfif isDefined("attributes.money_type") and len(attributes.money_type)><cfqueryparam cfsqltype="cf_sql_varchar" value="#form.money_type#"><cfelse>NULL</cfif>,
                            <cfif is_account eq 1>1,13,<cfelse>0,13,</cfif>
                            <cfif isdefined("attributes.paper_number") and len(attributes.paper_number)><cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.paper_number#"><cfelse>NULL</cfif>,
                            <cfif len(attributes.masraf) and attributes.masraf gt 0>#attributes.masraf#,<cfelse>0,</cfif>
                            #attributes.expense_item_id#,
                            <cfif isdefined('attributes.expense_center_id') and len(attributes.expense_center_id)><cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.expense_center_id#"><cfelse>NULL</cfif>,
                            #SESSION.EP.USERID#,
                            <cfqueryparam cfsqltype="cf_sql_varchar" value="#CGI.REMOTE_ADDR#">,
                            #NOW()#	,
                            #from_branch_id_info#,
                            1,
                            #wrk_round((attributes.stopaj_total)*dovizli_islem_multiplier)#,
                            <cfqueryparam cfsqltype="cf_sql_varchar" value="#session.ep.money#">
                            <cfif len(session.ep.money2)>
                                ,#wrk_round(((attributes.stopaj_total)*dovizli_islem_multiplier)/currency_multiplier,4)#
                                ,<cfqueryparam cfsqltype="cf_sql_varchar" value="#session.ep.money2#">
                            </cfif>
                        )
                    </cfquery>
                    <cfquery name="ADD_INTEREST_REVENUE_2" datasource="#dsn2#" result="MAX_ID">
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
                        )
                        VALUES
                        (
                            <cfqueryparam cfsqltype="cf_sql_varchar" value="#ACTION_TYPE#">,
                            #form.process_cat#,
                            #process_type#,
                            #attributes.from_account_id#,
                            <cfif len(attributes.masraf) and attributes.masraf gt 0>#attributes.total_action_value + attributes.masraf#,<cfelse>#attributes.total_action_value#,</cfif>
                            #attributes.ACTION_DATE#,
                            <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.currency_id#">,
                            <cfif isDefined("attributes.ACTION_DETAIL") and len(attributes.ACTION_DETAIL)><cfqueryparam cfsqltype="cf_sql_varchar" value="#ACTION_DETAIL#"><cfelse>NULL</cfif>,
                            <cfif isDefined("attributes.OTHER_CASH_ACT_VALUE") and len(attributes.OTHER_CASH_ACT_VALUE)>#attributes.OTHER_CASH_ACT_VALUE#<cfelse>NULL</cfif>,
                            <cfif isDefined("attributes.money_type") and len(attributes.money_type)><cfqueryparam cfsqltype="cf_sql_varchar" value="#form.money_type#"><cfelse>NULL</cfif>,
                            <cfif is_account eq 1>1,13,<cfelse>0,13,</cfif>
                            <cfif isdefined("attributes.paper_number") and len(attributes.paper_number)><cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.paper_number#"><cfelse>NULL</cfif>,
                            <cfif len(attributes.masraf) and attributes.masraf gt 0>#attributes.masraf#,<cfelse>0,</cfif>
                            #attributes.expense_item_id#,
                            <cfif isdefined('attributes.expense_center_id') and len(attributes.expense_center_id)><cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.expense_center_id#"><cfelse>NULL</cfif>,
                            #SESSION.EP.USERID#,
                            <cfqueryparam cfsqltype="cf_sql_varchar" value="#CGI.REMOTE_ADDR#">,
                            #NOW()#	,
                            #to_branch_id_info#,
                            0,
                            #wrk_round((attributes.total_action_value)*dovizli_islem_multiplier)#,
                            <cfqueryparam cfsqltype="cf_sql_varchar" value="#session.ep.money#">
                            <cfif len(session.ep.money2)>
                                ,#wrk_round(((attributes.total_action_value)*dovizli_islem_multiplier)/currency_multiplier,4)#
                                ,<cfqueryparam cfsqltype="cf_sql_varchar" value="#session.ep.money2#">
                            </cfif>
                        )
                    </cfquery>
                <cfset BANK_ACT_ID = MAX_ID.IDENTITYCOL-3>
                </cfif>
                <cfquery name="ADD_INTEREST_YIELD_ROW" datasource="#dsn2#"> <!--- TAHSİL EDİLDİĞİNE DAİR SATIRDA İLGİLİ KOLONU GUNCELLIYORUZ . --->
                    UPDATE INTEREST_YIELD_PLAN_ROWS 
                        SET IS_PAYMENT = 1, 
                            BANK_ACTION_ID = #BANK_ACT_ID#, 
                            STOPAJ_RATE = <cfqueryparam cfsqltype="cf_sql_float" value="#attributes.stopaj_rate#">,
                            STOPAJ_TOTAL = <cfqueryparam cfsqltype="cf_sql_float" value="#attributes.stopaj_total#">,
                            PAYMENT_PRINCIPAL = <cfif isdefined("attributes.showPrincipal") and attributes.showPrincipal eq 1>1<cfelse>NULL</cfif>,
                            TERM_BANK_TO_BANK = <cfif attributes.from_account_id eq attributes.to_account_id>1<cfelse>0</cfif>, <!--- vadeliden vadeliye aktarılıyorsa --->
                            CHANGE_RATE = <cfif attributes.hiddenRate neq filterNum(attributes.newYieldRate) >1<cfelse>NULL</cfif>, 
                            CHANGE_NEW_RATE = <cfif attributes.hiddenRate neq filterNum(attributes.newYieldRate)>#filterNum(attributes.newYieldRate)#<cfelse>NULL</cfif> <!--- vadeliden vadeliye aktarılıyorsa --->
                    WHERE YIELD_ROWS_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.row_id#">
                </cfquery>

                <cfscript>
                    if(is_account eq 1) {

                        str_card_detail = ArrayNew(2);
                        acc_branch_list_borc = '';
                        acc_branch_list_alacak = '';
                        acc_branch_list_alacak = listappend(acc_branch_list_alacak,from_branch_id_info,',');
                        acc_branch_list_borc = listappend(acc_branch_list_borc,to_branch_id_info,',');
                        
                        str_borclu_hesaplar = attributes.account_acc_code;
                        if(attributes.currency_id2 is session.ep.money){
                            if(attributes.from_account_id eq attributes.to_account_id){ /* vadeliden vadeliye ise brüt getiriyi hesaba sokuyoruz */
                                if(xml_is_brut_yield){ /* getiri brüt tutardan gösterilsin ise */
                                    str_tutarlar = attributes.total_action_value;
                                }else{
                                    str_tutarlar = attributes.total_action_value - attributes.stopaj_total;
                                }
                            }else{
                                if(xml_is_brut_yield){
                                    str_tutarlar = attributes.total_action_value;
                                }else{
                                    str_tutarlar = attributes.total_action_value - attributes.stopaj_total;
                                }
                            }   
                        }
                        else{
                            if(attributes.from_account_id eq attributes.to_account_id){ /* vadeliden vadeliye ise brüt getiriyi hesaba sokuyoruz */
                                if(xml_is_brut_yield){ /* getiri brüt tutardan gösterilsin ise */
                                    str_tutarlar = (attributes.total_action_value * dovizli_islem_multiplier);
                                }else{
                                    str_tutarlar = ((attributes.total_action_value - attributes.stopaj_total) * dovizli_islem_multiplier);
                                }
                            }else{
                                if(xml_is_brut_yield){
                                    str_tutarlar = ((attributes.total_action_value)*dovizli_islem_multiplier);
                                }else{
                                    str_tutarlar = ((attributes.total_action_value - attributes.stopaj_total)*dovizli_islem_multiplier);
                                }
                            }
                        }
                        if(attributes.from_account_id eq attributes.to_account_id){
                            if(xml_is_brut_yield){
                                str_borclu_other_amount_tutar = attributes.total_action_value;
                            }else{
                                str_borclu_other_amount_tutar = attributes.total_action_value - attributes.stopaj_total;
                            }
                        }else{
                            if(xml_is_brut_yield){
                                str_borclu_other_amount_tutar = attributes.total_action_value;
                            }else{
                                str_borclu_other_amount_tutar = attributes.total_action_value - attributes.stopaj_total;
                            }
                        }
                        str_borclu_other_currency = attributes.currency_id;

                        str_alacakli_hesaplar = attributes.account_acc_code;
                        if(attributes.currency_id is session.ep.money){
                            if(attributes.from_account_id eq attributes.to_account_id){ /* vadeliden vadeliye ise anapara çıkışı yok zaten paramız vadelide */ 
                                if(xml_is_brut_yield){ /* brütten çalıştı ise bankadan stopaj kesintisini çıkarıyoruz */
                                    str_alacakli_tutarlar = attributes.stopaj_total;
                                }else{
                                    str_alacakli_tutarlar = 0;
                                }
                            }else{
                                if(xml_is_brut_yield){  /* brütten çalıştı ise bankadan stopaj kesintisini çıkarıyoruz */
                                    str_alacakli_tutarlar = attributes.stopaj_total;
                                }else{
                                    str_alacakli_tutarlar = 0;
                                }
                            }
                        }else{
                            if(attributes.from_account_id eq attributes.to_account_id){ /* vadeliden vadeliye ise anapara çıkışı yok zaten paramız vadelide */ 
                                if(xml_is_brut_yield){  /* brütten çalıştı ise bankadan stopaj kesintisini çıkarıyoruz */
                                    str_alacakli_tutarlar = attributes.stopaj_total;
                                }else{
                                    str_alacakli_tutarlar = 0;
                                }
                            }else{
                                if(xml_is_brut_yield){  /* brütten çalıştı ise bankadan stopaj kesintisini çıkarıyoruz */
                                    str_alacakli_tutarlar = attributes.stopaj_total;
                                }else{
                                    str_alacakli_tutarlar = 0;
                                }
                            }
                        }
                        if(attributes.from_account_id eq attributes.to_account_id){ /* vadeliden vadeliye ise anapara çıkışı yok zaten paramız vadelide */ 
                            if(xml_is_brut_yield){  /* brütten çalıştı ise bankadan stopaj kesintisini çıkarıyoruz */
                                str_alacakli_other_amount_tutar = attributes.stopaj_total;
                            }else{
                                str_alacakli_other_amount_tutar = 0;
                            }
                        }else{
                            if(xml_is_brut_yield){  /* brütten çalıştı ise bankadan stopaj kesintisini çıkarıyoruz */
                                str_alacakli_other_amount_tutar = attributes.stopaj_total;
                            }else{
                                str_alacakli_other_amount_tutar = 0;
                            }
                        }
                        str_alacakli_other_currency = attributes.currency_id;

                        str_card_detail[1][listlen(str_tutarlar)]= 'Anapara';
                        str_card_detail[2][listlen(str_alacakli_tutarlar)]= 'Banka Stopaj Kesintisi';

                        str_alacakli_hesaplar = listappend(str_alacakli_hesaplar,get_acc_code_expense_item.ACCOUNT_CODE,',');
                        if(attributes.currency_id is session.ep.money){
                            str_alacakli_tutarlar = listappend(str_alacakli_tutarlar, attributes.total_action_value - attributes.total_reeskont ,',');
                        }else{
                            str_alacakli_tutarlar = listappend(str_alacakli_tutarlar, (attributes.total_action_value - attributes.total_reeskont) * dovizli_islem_multiplier,',');
                        }

                        if(isDefined("attributes.ACTION_DETAIL") and len(attributes.ACTION_DETAIL))
                        {
                            str_card_detail[1][listlen(str_tutarlar)]='#attributes.ACTION_DETAIL#';
        
                            str_card_detail[2][listlen(str_alacakli_tutarlar)]='#attributes.ACTION_DETAIL#';
                        }
                        else
                        {
                            str_card_detail[1][listlen(str_tutarlar)]= 'Getiri';
        
                            str_card_detail[2][listlen(str_alacakli_tutarlar)]= 'Getiri';
                        }

                        str_alacakli_other_amount_tutar = listappend(str_alacakli_other_amount_tutar,attributes.total_action_value - attributes.total_reeskont,',');
                        str_alacakli_other_currency = listappend(str_alacakli_other_currency,attributes.currency_id,',');

                        if(len(attributes.masraf) and attributes.masraf gt 0)
                        {
                            acc_branch_list_alacak = listappend(acc_branch_list_alacak,from_branch_id_info,',');
                            acc_branch_list_borc = listappend(acc_branch_list_borc,from_branch_id_info,',');
                            str_borclu_hesaplar = ListAppend(str_borclu_hesaplar,get_acc_code_expense_item.ACCOUNT_CODE,",");	
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

                        str_borclu_hesaplar = ListAppend(str_borclu_hesaplar,get_stoppage_acc_code.STOPPAGE_ACCOUNT_CODE,",");
                        if(attributes.currency_id is session.ep.money){
                            str_tutarlar = ListAppend(str_tutarlar,attributes.stopaj_total,",");
                        }else{
                            str_tutarlar = ListAppend(str_tutarlar,attributes.stopaj_total*dovizli_islem_multiplier,",");
                        }
                        str_card_detail[1][listlen(str_tutarlar)] = 'Stopaj Tutarı';
                        str_borclu_other_amount_tutar = ListAppend(str_borclu_other_amount_tutar,attributes.stopaj_total,",");
                        str_borclu_other_currency = ListAppend(str_borclu_other_currency,attributes.currency_id,",");
                        acc_branch_list_borc = listappend(acc_branch_list_borc,to_branch_id_info,',');
                        acc_branch_list_alacak = listappend(acc_branch_list_alacak,from_branch_id_info,',');

                        str_alacakli_hesaplar = listappend(str_alacakli_hesaplar,acc_tahakkuk_code.ACCOUNT_CODE,',');

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

                      
                        if(attributes.from_account_id neq attributes.to_account_id){ /* vadeliden vadesize ise önce parayı vadeliye aldık şimdide vadesize geçiriyoruz */
                            

                            acc_branch_list_alacak = listappend(acc_branch_list_alacak,from_branch_id_info,',');
                            acc_branch_list_borc = listappend(acc_branch_list_borc,to_branch_id_info,',');
                            
                            str_borclu_hesaplar = listappend(str_borclu_hesaplar,attributes.account_acc_code2,',');
                            if(attributes.currency_id2 is session.ep.money){
                                str_tutarlar = listappend(str_tutarlar, attributes.principal + attributes.total_action_value - attributes.stopaj_total, ',');
                            }
                            else{
                                str_tutarlar = listappend(str_tutarlar,((attributes.principal + attributes.total_action_value - attributes.stopaj_total) * dovizli_islem_multiplier),',');
                            }
                            
                            str_borclu_other_amount_tutar = listappend(str_borclu_other_amount_tutar, attributes.principal + attributes.total_action_value - attributes.stopaj_total,',');
                            str_borclu_other_currency = listappend(str_borclu_other_currency,attributes.currency_id,',');

                            str_alacakli_hesaplar = listappend(str_alacakli_hesaplar,attributes.account_acc_code,',');
                            if(attributes.currency_id2 is session.ep.money){
                                str_alacakli_tutarlar = listappend(str_alacakli_tutarlar, attributes.principal + attributes.total_action_value - attributes.stopaj_total, ',');
                            }
                            else{
                                str_alacakli_tutarlar = listappend(str_alacakli_tutarlar,((attributes.principal + attributes.total_action_value - attributes.stopaj_total) * dovizli_islem_multiplier),',');
                            }

                            str_alacakli_other_amount_tutar = listappend(str_alacakli_other_amount_tutar, attributes.principal + attributes.total_action_value - attributes.stopaj_total,',');
                            str_alacakli_other_currency = listappend(str_alacakli_other_currency,attributes.currency_id,',');
                            str_card_detail[1][listlen(str_tutarlar)]= 'Virman İşlemi';
                            str_card_detail[2][listlen(str_alacakli_tutarlar)]= 'Virman İşlemi';
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
                                    fis_detay : UCase(getLang('credit',56)),
                                    acc_branch_list_borc : acc_branch_list_borc,
                                    acc_branch_list_alacak : acc_branch_list_alacak,
                                    belge_no : attributes.paper_number
                                );
                    }

                    if(is_budget eq 1)
                    {
                        if(len(attributes.expense_center_id))
                        {
                            butceci(
                                action_id : BANK_ACT_ID,
                                muhasebe_db : dsn2,
                                is_income_expense : true,
                                process_type : process_type,
                                nettotal : attributes.total_action_value - attributes.total_reeskont,
                                other_money_value :  attributes.OTHER_CASH_ACT_VALUE - attributes.total_reeskont,
                                action_currency : attributes.currency_id,
                                currency_multiplier : currency_multiplier,
                                expense_date : attributes.action_date,
                                expense_center_id : attributes.expense_center_id,
                                expense_item_id : attributes.expense_item_id,
                                detail : 'VADELİ MEVDUAT GETİRİ HESABA GEÇİŞ',
                                paper_no : attributes.paper_number,
                                branch_id : ListGetAt(session.ep.user_location,2,"-"),
                                insert_type : 1
                            );
                        }
                    }

                    f_kur_ekle_action(action_id:BANK_ACT_ID,process_type:0,action_table_name:'BANK_ACTION_MONEY',action_table_dsn:'#dsn2#');

                </cfscript>
            </cftransaction>
        </cflock>
        <cfif Len(paper_number)>
            <cfquery name="UPD_GENERAL_PAPERS" datasource="#DSN2#">
                UPDATE 
                    #dsn3_alias#.GENERAL_PAPERS
                SET
                    INCOMING_TRANSFER_NUMBER = #paper_number#
                WHERE
                    INCOMING_TRANSFER_NUMBER IS NOT NULL
            </cfquery>
        </cfif>
        <script type="text/javascript">
            window.location.href="<cfoutput>#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.interest_revenue&acc_tahakkuk_code=#attributes.acc_tahakkuk_code#&event=updPaymentRevenue&id=#attributes.row_id#</cfoutput>";
        </script>