<cfsetting showdebugoutput="no">
    <cfset upload_folder_ = "#upload_folder#settings#dir_seperator#">
     <!--- <cfdump var="#upload_folder_#" abort> --->
	<cftry>
		<cffile action = "upload" 
				filefield = "uploaded_file" 
				destination = "#upload_folder_#"
				nameconflict = "MakeUnique"  
				mode="777" charset="utf-8">
		<cfset file_name = "#createUUID()#.#cffile.serverfileext#">	
		<cffile action="rename" source="#upload_folder_##cffile.serverfile#" destination="#upload_folder_##file_name#" charset="utf-8">	
		<cfset file_size = cffile.filesize>
		<cfcatch type="Any">
			<script type="text/javascript">
				alert("<cf_get_lang_main no='43.Dosyaniz Upload Edilemedi Lütfen Konrol Ediniz '>!");
				history.back();
			</script>
			<cfabort>
		</cfcatch>  
    </cftry>
    
	<cftry>
		<cffile action="read" file="#upload_folder_##file_name#" variable="dosya" charset="utf-8">
		<cffile action="delete" file="#upload_folder_##file_name#">
        <cfcatch>
            <script type="text/javascript">
                alert("<cf_get_lang_main no='1653.Dosya Okunamadı Karakter Seti Yanlış Seçilmiş Olabilir'>.");
                history.back();
            </script>
            <cfabort>
        </cfcatch>
    </cftry>

    <cfscript>
        CRLF = Chr(13) & Chr(10);// satır atlama karakteri
        dosya = Replace(dosya,';;','; ;','all');
        dosya = Replace(dosya,';;','; ;','all');
        dosya = ListToArray(dosya,CRLF);
        line_count = ArrayLen(dosya);
        counter = 0;
        liste = "";
    </cfscript>

    <cfloop from="2" to="#line_count#" index="i">
        <cfset kont=1>
        <cftry>
            <cfset mk_type = trim(listgetat(dosya[i],1,';'))>
            <cfset mk_code = trim(listgetat(dosya[i],2,';'))>
            <cfset mk_destination = trim(listgetat(dosya[i],3,';'))>
            <cfset mk_buy_date = trim(listgetat(dosya[i],4,';'))>
            <cfset mk_process_cat = trim(listgetat(dosya[i],5,';'))>
            <cfset mk_nominal_deger = trim(listgetat(dosya[i],6,';'))>
            <cfset mk_nominal_deger_doviz = trim(listgetat(dosya[i],7,';'))>
            <cfset mk_alis_deger = trim(listgetat(dosya[i],8,';'))>
            <cfset mk_alis_deger_doviz = trim(listgetat(dosya[i],9,';'))>
            <cfset mk_miktar = trim(listgetat(dosya[i],10,';'))>
            <cfset mk_toplam_alis = trim(listgetat(dosya[i],11,';'))>
            <cfset mk_toplam_alis_doviz = trim(listgetat(dosya[i],12,';'))>
            <cfset mk_masraf_merkezi = trim(listgetat(dosya[i],13,';'))>
            <cfset mk_butce_kalemi = trim(listgetat(dosya[i],14,';'))>
            <cfset mk_muhasebe_code = trim(listgetat(dosya[i],15,';'))>
            <cfset mk_getiri_type = trim(listgetat(dosya[i],16,';'))>
            <cfif (listlen(dosya[i],';') gte 17)>
                <cfset mk_account_code = trim(listgetat(dosya[i],17,';'))>
                <cfif mk_account_code eq ''><cfset mk_account_code = ''></cfif>
            <cfelse>
                <cfset mk_account_code = ''>
            </cfif>
            <cfif (listlen(dosya[i],';') gte 18)>
                <cfset mk_company_id = trim(listgetat(dosya[i],18,';'))>
                <cfif mk_company_id eq '"'><cfset mk_company_id = ''></cfif>
            <cfelse>
                <cfset mk_company_id = ''>
            </cfif>
            <cfif (listlen(dosya[i],';') gte 19)>
                <cfset com_tl = trim(listgetat(dosya[i],19,';'))>
                <cfif com_tl eq ''><cfset com_tl = 0></cfif>
            <cfelse>
                <cfset com_tl = 0>
            </cfif>
            <cfif (listlen(dosya[i],';') gte 20)>
                <cfset com_other = trim(listgetat(dosya[i],20,';'))>
                <cfif com_other eq ''><cfset com_other = 0></cfif>
            <cfelse>
                <cfset com_other = 0>
            </cfif>
            <cfif (listlen(dosya[i],';') gte 21)>
                <cfset com_rate = trim(listgetat(dosya[i],21,';'))>
                <cfif com_rate eq ''><cfset com_rate = 0></cfif>
            <cfelse>
                <cfset com_rate = 0>
            </cfif>
            <cfcatch type="Any">
                <cfoutput>#i#</cfoutput>. satır 1. adımda sorun oluştu.<br/>
                <cfset error_flag = 1>
            </cfcatch>  
        </cftry>
        <!--- Masraf Merkezi Kontrol --->
        <cfquery name="control_masraf_merkezi" datasource=#dsn2#>
            SELECT EXPENSE FROM EXPENSE_CENTER WHERE EXPENSE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#mk_masraf_merkezi#">
        </cfquery>
        <cfif control_masraf_merkezi.recordCount neq 1>
            <script type="text/javascript">
                alert("Masraf Merkezi Bulunamadı, Kontrol Edin!");
                history.back();
            </script>
            <cfabort>
        </cfif>

        <!--- Bütçe Kalemi Kontrol --->
        <cfquery name="control_butce_kalemi" datasource=#dsn2#>
            SELECT EXPENSE_ITEM_NAME FROM EXPENSE_ITEMS WHERE EXPENSE_ITEM_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#mk_butce_kalemi#">
        </cfquery>
        <cfif control_butce_kalemi.recordCount neq 1>
            <script type="text/javascript">
                alert("Bütçe Kalemi Bulunamadı, Kontrol Edin!");
                history.back();
            </script>
            <cfabort>
        </cfif>

        <!--- M.K Muhasebe Kodu Kontrol --->
        <cfquery name="control_mk_hesap" datasource=#dsn2#>
            SELECT ACCOUNT_CODE FROM ACCOUNT_PLAN WHERE ACCOUNT_CODE = <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#mk_muhasebe_code#">
        </cfquery>
        <cfif control_mk_hesap.recordCount neq 1>
            <script type="text/javascript">
                alert("Muhasebe Kodu Bulunamadı, Kontrol Edin!");
                history.back();
            </script>
            <cfabort>
        </cfif>

        <!--- İşlem Tipini Göre CMB Set Ediliyor --->
        <cfquery name="get_process_type" datasource="#dsn3#">
            SELECT PROCESS_TYPE,IS_CARI,IS_ACCOUNT,NEXT_PERIODS_ACCRUAL_ACTION,IS_ACCOUNT_GROUP,IS_BUDGET,ACTION_FILE_NAME,ACTION_FILE_FROM_TEMPLATE FROM SETUP_PROCESS_CAT WHERE PROCESS_CAT_ID = #mk_process_cat#
        </cfquery>
        
        <cfscript>
            if(isDefined('attributes.deger_get_money') and len(attributes.deger_get_money))
            for(mon=1;mon lte attributes.deger_get_money;mon=mon+1)
            {
                if(evaluate("attributes.hidden_rd_money_#mon#") is session.ep.money2)
                    currency_multiplier = evaluate('attributes.value_rate2#mon#/attributes.txt_rate1_#mon#');
                if(evaluate("attributes.hidden_rd_money_#mon#") is attributes.rd_money)
                    masraf_curr_multiplier = evaluate('attributes.value_rate2#mon#/attributes.txt_rate1_#mon#');
                if(isdefined('mk_account_code') and evaluate("attributes.hidden_rd_money_#mon#") is ListLast(mk_account_code,"-"))
                    currency_multiplier_banka = evaluate('attributes.value_rate2#mon#/attributes.txt_rate1_#mon#');
            }

        </cfscript>

        <cfset process_type = get_process_type.PROCESS_TYPE>
        <cfset is_cari = get_process_type.IS_CARI>
        <cfset is_account = get_process_type.IS_ACCOUNT>
        <cfset is_account_group = get_process_type.IS_ACCOUNT_GROUP>
        <cfset is_budget = get_process_type.IS_BUDGET>
        <cfset is_next_periods_accrual_action = get_process_type.NEXT_PERIODS_ACCRUAL_ACTION>
        <cfset action_from_account_id = listfirst(mk_account_code,'-')>
        <cfset action_from_currency = listlast(mk_account_code,'-')>
        <cfset currency_multiplier = 1>
        <cfset branch_id_info = listgetat(session.ep.user_location,2,'-')>

        <cf_date tarih='mk_buy_date'>
        <cf_papers paper_type="BUYING_SECURITIES">

        <cfif is_account eq 1 and len(mk_company_id)>
            <cfset my_acc_result = get_company_period(mk_company_id)>
            <cfif isdefined("my_acc_result") and not len(my_acc_result)>
                <script type="text/javascript">
                    alert("Seçtiğiniz Üyenin Muhasebe Kodu Seçilmemiş");
                    history.back();	
                </script>
                <cfabort>
            </cfif>
        </cfif>

        <cfset paper_no = paper_code & '-' & paper_number>

        <cftransaction>
            <cftry>
                <!--- Banka varsa Banka kaydı atılıyor --->
                <cfif len(mk_account_code)>
                    <cfquery name="GET_ACC_CODE" datasource="#dsn2#">
                        SELECT ACCOUNT_ACC_CODE FROM #dsn3_alias#.ACCOUNTS WHERE ACCOUNT_ID = #listfirst(mk_account_code,'-')#
                    </cfquery>
                    <cfquery name="ADD_BANK_ACTION" datasource="#dsn2#">
                        INSERT INTO
                            BANK_ACTIONS
                            (
                                ACTION_TYPE,
                                PROCESS_CAT,
                                ACTION_TYPE_ID,
                                ACTION_FROM_ACCOUNT_ID,
                                ACTION_TO_COMPANY_ID,
                                ACTION_VALUE,
                                MASRAF,
                                ACTION_DATE,
                                ACTION_DETAIL,
                                ACTION_CURRENCY_ID,
                                OTHER_CASH_ACT_VALUE,
                                OTHER_MONEY,
                                IS_ACCOUNT,
                                IS_ACCOUNT_TYPE,
                                PAPER_NO,
                                RECORD_EMP,
                                RECORD_IP,
                                RECORD_DATE,
                                SYSTEM_ACTION_VALUE,
                                SYSTEM_CURRENCY_ID
                                <cfif len(session.ep.money2)>
                                    ,ACTION_VALUE_2
                                    ,ACTION_CURRENCY_ID_2
                                </cfif>
                            )
                        VALUES
                            (
                                'MENKUL KIYMET ALIMI',
                                #mk_process_cat#,
                                #process_type#,
                                #action_from_account_id#,
                                <cfif len(mk_company_id)>#mk_company_id#<cfelse>NULL</cfif>,
                                #(filterNum(mk_toplam_alis)+com_tl)/currency_multiplier_banka#,
                                #com_tl/currency_multiplier_banka#,
                                #mk_buy_date#,
                                <cfif len(mk_destination)>'#left(mk_destination,100)#',<cfelse>NULL,</cfif>
                                '#action_from_currency#',
                                <cfif len(mk_toplam_alis_doviz)>#filterNum(mk_toplam_alis_doviz)+com_other#,<cfelse>NULL,</cfif>
                                '#attributes.rd_money#',
                                <cfif is_account eq 1>1,13,<cfelse>0,13,</cfif>
                                '#paper_no#',
                                #SESSION.EP.USERID#,
                                '#CGI.REMOTE_ADDR#',
                                #NOW()#,
                                #filterNum(mk_toplam_alis)#,
                                '#session.ep.money#'
                                <cfif len(session.ep.money2)>
                                    ,#wrk_round((filterNum(mk_toplam_alis))/currency_multiplier,4)#
                                    ,'#session.ep.money2#'
                                </cfif>
                            )
                    </cfquery>
                    <cfquery name="GET_ACT_ID" datasource="#dsn2#">
                        SELECT MAX(ACTION_ID) AS MAX_ID FROM BANK_ACTIONS
                    </cfquery>
                </cfif>

                <cfquery name="ADD_STOCKBOND_PURCHASE" datasource="#dsn2#">
                    INSERT INTO
                        #dsn3_alias#.STOCKBONDS_SALEPURCHASE
                        (
                            IS_SALES_PURCHASE,
                            PROCESS_CAT,
                            PROCESS_TYPE,
                            PAPER_NO,
                            ACTION_DATE,
                            BANK_ACC_ID,
                            COMPANY_ID,
                            PARTNER_ID,
                            EMPLOYEE_ID,
                            BROKER_COMPANY,
                            REF_NO,
                            DETAIL,
                            OTHER_MONEY,
                            NET_TOTAL,
                            OTHER_MONEY_VALUE,
                            COM_RATE,
                            COM_TOTAL,
                            OTHER_COM_TOTAL,
                            EXP_CENTER_ID,
                            EXP_ITEM_ID,
                            ACCOUNT_CODE,
                            /* COM_EXP_CENTER_ID,
                            COM_EXP_ITEM_ID,
                            COM_ACCOUNT_CODE, */
                            BANK_ACTION_ID,
                            RECORD_DATE,
                            RECORD_EMP,
                            RECORD_IP
                        )
                        VALUES
                        (
                            0,
                            #mk_process_cat#,
                            #process_type#,
                            '#paper_no#',
                            #mk_buy_date#,
                            <cfif len(mk_account_code)>#listfirst(mk_account_code,'-')#,<cfelse>NULL,</cfif>
                            <cfif len(mk_company_id)>#mk_company_id#,<cfelse>NULL,</cfif>
                            NULL,
                            NULL,
                            NULL,
                            NULL,
                            <cfif len(mk_destination)>'#left(mk_destination,200)#',<cfelse>NULL,</cfif>
                            '#attributes.rd_money#',
                            #filterNum(mk_toplam_alis)#,
                            #filterNum(mk_toplam_alis_doviz)#,
                            #filterNum(com_rate)#,
                            #filterNum(com_tl)#,
                            #filterNum(com_other)#,
                            <cfif len(mk_masraf_merkezi)>#mk_masraf_merkezi#,<cfelse>NULL,</cfif>
                            <cfif len(mk_butce_kalemi)>#mk_butce_kalemi#,<cfelse>NULL,</cfif>
                            <cfif len(mk_muhasebe_code)>'#mk_muhasebe_code#',<cfelse>NULL,</cfif>
                            <!--- <cfif len(attributes.com_exp_center_id) and len(attributes.com_exp_center)>#attributes.com_exp_center_id#,<cfelse>NULL,</cfif>
                            <cfif len(attributes.com_exp_item_id) and len(attributes.com_exp_item_name)>#attributes.com_exp_item_id#,<cfelse>NULL,</cfif>
                            <cfif len(attributes.com_acc_id) and len(attributes.com_acc_name)>'#attributes.com_acc_id#',<cfelse>NULL,</cfif> --->
                            <cfif isdefined("mk_account_code") and len(mk_account_code)>#GET_ACT_ID.MAX_ID#<cfelse>NULL</cfif>,
                            #now()#,
                            #session.ep.userid#,
                            '#cgi.remote_addr#'
                        )
                </cfquery>
                <cfquery name="GET_ACTION_ID" datasource="#dsn2#">
                    SELECT MAX(ACTION_ID) AS MAX_ID FROM #dsn3_alias#.STOCKBONDS_SALEPURCHASE
                </cfquery>

                <!--- Banka Muhasebe Kaydi --->
                <cfif isdefined("mk_account_code") and len(mk_account_code)>
                    <cfscript>
                        //sadece banka secili ise yapilacak muhasebe islemi
                        if(is_account)
                        {
                            str_borclu_hesaplar='';
                            str_alacakli_hesaplar='';
                            str_borclu_tutarlar ='';
                            str_alacakli_tutarlar = '';
                            str_borclu_other_tutar = '';
                            str_alacakli_other_tutar = '';
                            str_other_borc_currency_list = '';
                            str_other_alacak_currency_list = '';
                            satir_detay_list = ArrayNew(2); 
                            
                            
                            str_borclu_hesaplar = listappend(str_borclu_hesaplar,mk_muhasebe_code);
                            str_borclu_tutarlar = listappend(str_borclu_tutarlar,filterNum(mk_toplam_alis));
                            str_borclu_other_tutar = listappend(str_borclu_other_tutar,filterNum(mk_toplam_alis_doviz));
                            str_other_borc_currency_list = listappend(str_other_borc_currency_list,attributes.rd_money,',');

                            satir_detay_list[1][listlen(str_borclu_tutarlar)]='MENKUL KIYMET ALIŞ İŞLEMİ';
                        
                                
                            
                            //komisyon gider kalemine ait muhasebe koduna borc kaydeder
                            /* str_borclu_hesaplar = ListAppend(str_borclu_hesaplar,attributes.com_acc_id);
                            str_borclu_tutarlar = ListAppend(str_borclu_tutarlar,attributes.com_ytl);
                            str_borclu_other_tutar = ListAppend(str_borclu_other_tutar,attributes.com_other);
                            str_other_borc_currency_list = ListAppend(str_other_borc_currency_list,attributes.rd_money);
                            if(is_account_group neq 1)
                            {
                                satir_detay_list[1][listlen(str_borclu_tutarlar)]='#attributes.com_exp_item_name# - MENKUL KIYMET ALIŞ İŞLEMİ';
                            }
                            else
                            {
                                if (len(attributes.detail))
                                    satir_detay_list[1][listlen(str_borclu_tutarlar)]='#attributes.detail# - MENKUL KIYMET ALIŞ İŞLEMİ';
                                else
                                    satir_detay_list[1][listlen(str_borclu_tutarlar)]='MENKUL KIYMET ALIŞ İŞLEMİ';
                            } */
                            
                            //bankaya alis tutari toplami kadar alacak kaydeder
                            str_alacakli_hesaplar = ListAppend(str_alacakli_hesaplar,GET_ACC_CODE.ACCOUNT_ACC_CODE);
                            str_alacakli_tutarlar = ListAppend(str_alacakli_tutarlar,filterNum(mk_toplam_alis));
                            str_alacakli_other_tutar = ListAppend(str_alacakli_other_tutar,filterNum(mk_toplam_alis_doviz));
                            str_other_alacak_currency_list = ListAppend(str_other_alacak_currency_list,attributes.rd_money);
                            
                            if(is_account_group neq 1)
                            {
                                get_item_name = cfquery(datasource:"#dsn2#", sqlstring:"SELECT EXPENSE_ITEM_NAME FROM EXPENSE_ITEMS WHERE EXPENSE_ITEM_ID = #mk_butce_kalemi#");
                                satir_detay_list[2][listlen(str_alacakli_tutarlar)]='#get_item_name.EXPENSE_ITEM_NAME# - MENKUL KIYMET ALIŞ İŞLEMİ';
                            }
                            else
                            {
                                satir_detay_list[2][listlen(str_alacakli_tutarlar)]='MENKUL KIYMET ALIŞ İŞLEMİ';
                            }
                            
                            //bankaya komisyon tutari toplami kadar alacak kaydeder	
                            str_alacakli_hesaplar = ListAppend(str_alacakli_hesaplar,GET_ACC_CODE.ACCOUNT_ACC_CODE);
                            str_alacakli_tutarlar = ListAppend(str_alacakli_tutarlar,filterNum(com_tl));
                            str_alacakli_other_tutar = ListAppend(str_alacakli_other_tutar,filterNum(com_other));
                            str_other_alacak_currency_list = ListAppend(str_other_alacak_currency_list,attributes.rd_money);
                            
                            satir_detay_list[2][listlen(str_alacakli_tutarlar)]='MENKUL KIYMET ALIŞ İŞLEMİ';

                            muhasebeci (
                                action_id : get_action_id.max_id,
                                workcube_process_type : process_type,
                                workcube_process_cat : mk_process_cat,
                                account_card_type : 13,
                                company_id :  mk_company_id,
                                from_branch_id : branch_id_info,
                                islem_tarihi : mk_buy_date,
                                alacak_hesaplar : str_alacakli_hesaplar,
                                alacak_tutarlar : str_alacakli_tutarlar,
                                borc_hesaplar : str_borclu_hesaplar,
                                borc_tutarlar : str_borclu_tutarlar,
                                fis_satir_detay: satir_detay_list,
                                fis_detay : 'MENKUL KIYMET ALIŞ İŞLEMİ',
                                belge_no : paper_no,
                                other_amount_borc :  str_borclu_other_tutar,
                                other_currency_borc : str_other_borc_currency_list,
                                other_amount_alacak : str_alacakli_other_tutar,
                                other_currency_alacak : str_other_alacak_currency_list,
                                currency_multiplier : currency_multiplier,
                                is_account_group : is_account_group
                            );
                        }
                    </cfscript>
                </cfif>

                <cfquery name="ADD_STOCKBOND" datasource="#dsn2#">
                    INSERT INTO
                        #dsn3_alias#.STOCKBONDS
                        (
                            STOCKBOND_TYPE,
                            STOCKBOND_CODE,
                            DETAIL,
                            NOMINAL_VALUE,
                            OTHER_NOMINAL_VALUE,
                            PURCHASE_VALUE,
                            OTHER_PURCHASE_VALUE,
                            QUANTITY,
                            TOTAL_PURCHASE,
                            OTHER_TOTAL_PURCHASE,
                            ACTUAL_VALUE,
                            OTHER_ACTUAL_VALUE,
                            ROW_EXP_CENTER_ID,
                            ROW_EXP_ITEM_ID,
                            DUE_DATE,
                            BANK_ACTION_ID,
                            YIELD_TYPE,
                            RECORD_DATE,
                            RECORD_EMP,
                            RECORD_IP				
                        )
                        VALUES
                        (
                            #mk_type#,
                            '#mk_code#',
                            '#mk_destination#',
                            #filterNum(mk_nominal_deger)#,
                            #filterNum(mk_nominal_deger_doviz)#,
                            #filterNum(mk_alis_deger)#,
                            #filterNum(mk_alis_deger_doviz)#,
                            #filterNum(mk_miktar)#,
                            #filterNum(mk_toplam_alis)#,
                            #filterNum(mk_toplam_alis_doviz)#,
                            #filterNum(mk_alis_deger)#,
                            #filterNum(mk_alis_deger_doviz)#,
                            #mk_masraf_merkezi#,
                            #mk_butce_kalemi#,
                            NULL,
                            <cfif isdefined("mk_account_code") and len(mk_account_code)>#GET_ACT_ID.MAX_ID#<cfelse>NULL</cfif>,
                            #mk_getiri_type#,
                            #now()#,
                            #session.ep.userid#,
                            '#cgi.remote_addr#'
                        )
                </cfquery>
                <cfquery name="GET_STOCKBOND_ID" datasource="#dsn2#">
                    SELECT MAX(STOCKBOND_ID) AS MAX_ID FROM #dsn3_alias#.STOCKBONDS
                </cfquery>
                <cfquery name="ADD_STOCKBOND_ROW" datasource="#dsn2#">
                    INSERT INTO
                        #dsn3_alias#.STOCKBONDS_SALEPURCHASE_ROW
                        (
                            IS_SALES_PURCHASE,
                            SALES_PURCHASE_ID,
                            STOCKBOND_ID,
                            DESCRIPTION,
                            NOMINAL_VALUE,
                            OTHER_NOMINAL_VALUE,
                            PRICE,
                            OTHER_PRICE,
                            QUANTITY,
                            NET_TOTAL,
                            OTHER_MONEY_VALUE,
                            OTHER_MONEY,
                            DUE_DATE,
                            YIELD_TYPE,
                            RECORD_DATE,
                            RECORD_EMP,
                            RECORD_IP
                        )
                        VALUES
                        (
                            0,
                            #get_action_id.max_id#,
                            #get_stockbond_id.max_id#,
                            '#mk_destination#',
                            #filterNum(mk_nominal_deger)#,
                            #filterNum(mk_nominal_deger_doviz)#,
                            #filterNum(mk_alis_deger)#,
                            #filterNum(mk_alis_deger_doviz)#,
                            #filterNum(mk_miktar)#,
                            #filterNum(mk_toplam_alis)#,
                            #filterNum(mk_toplam_alis_doviz)#,
                            '#attributes.rd_money#',
                            NULL,
                            #mk_getiri_type#,
                            #now()#,
                            #session.ep.userid#,
                            '#cgi.remote_addr#'
                        )
                </cfquery>
                <cfquery name="ADD_STOCKBOND_ROW" datasource="#dsn2#">
                    INSERT INTO
                        #dsn3_alias#.STOCKBONDS_INOUT
                        (
                            STOCKBOND_ID,
                            PERIOD_ID,
                            ACTION_ID,
                            PAPER_NO,
                            PROCESS_TYPE,
                            QUANTITY,
                            STOCKBOND_IN
                        )
                        VALUES
                        (
                            #get_stockbond_id.max_id#,
                            #session.ep.period_id#,
                            #get_action_id.max_id#,
                            '#paper_no#',
                            #process_type#,
                            #filterNum(mk_miktar)#,
                            #filterNum(mk_miktar)#
                        )
                </cfquery>
                <cfif len(mk_company_id)>
                    <cfscript>
                        //Cari Islem
                        if(is_cari eq 1 and len(mk_company_id))
                        {
                            carici(
                                action_id : get_action_id.max_id,
                                action_table : 'STOCKBONDS_SALEPURCHASE',
                                workcube_process_type : process_type,
                                account_card_type : 13,
                                islem_tarihi : mk_buy_date,
                                islem_tutari : filterNum(mk_toplam_alis)+filterNum(com_tl),
                                islem_belge_no : paper_no,
                                from_cmp_id : mk_company_id,
                                from_branch_id : ListGetAt(session.ep.user_location,2,"-"),
                                islem_detay : 'MENKUL KIYMET ALIŞ',
                                action_detail : mk_destination,
                                other_money_value : filterNum(mk_toplam_alis_doviz)+filterNum(com_other),
                                other_money : attributes.rd_money,
                                action_currency : SESSION.EP.MONEY,
                                process_cat : mk_process_cat,
                                currency_multiplier : currency_multiplier,
                                rate2:masraf_curr_multiplier
                            );
                        }
                        //Muhasebe Hareketleri
                        if(is_account and isdefined("my_acc_result"))
                        {
                            str_borclu_hesaplar='';
                            str_alacakli_hesaplar='';
                            str_borclu_tutarlar ='';
                            str_alacakli_tutarlar = '';
                            str_borclu_other_tutar = '';
                            str_alacakli_other_tutar = '';
                            str_other_borc_currency_list = '';
                            str_other_alacak_currency_list = '';
                            satir_detay_list = ArrayNew(2); 
                            GET_NO_ = cfquery(datasource:"#dsn2#", sqlstring:"SELECT FARK_GELIR,FARK_GIDER FROM #dsn3_alias#.SETUP_INVOICE_PURCHASE");
                            //muhasebe fisi icin, olusabilecek yuvarlama satırının bilgileri
                            str_fark_gelir =GET_NO_.FARK_GELIR;
                            str_fark_gider =GET_NO_.FARK_GIDER;
                            str_max_round = 0.1;
                            str_round_detail = '#paper_no# MENKUL KIYMET';

                            //toplam alis gider kalemine ait muhasebe koduna borc kaydeder (satir bazinda)
                            
                            str_borclu_hesaplar = listappend(str_borclu_hesaplar,mk_muhasebe_code);
                            str_borclu_tutarlar = listappend(str_borclu_tutarlar,filterNum(mk_toplam_alis));
                            str_borclu_other_tutar = listappend(str_borclu_other_tutar,filterNum(mk_toplam_alis_doviz));
                            str_other_borc_currency_list = listappend(str_other_borc_currency_list,attributes.rd_money,',');
                            
                            if(is_account_group neq 1)
                            {
                                satir_detay_list[1][listlen(str_borclu_tutarlar)]= 'MENKUL KIYMET ALIŞ İŞLEMİ';
                            }

                            //komisyon gider kalemine ait muhasebe koduna borc kaydeder
                            /*str_borclu_hesaplar = ListAppend(str_borclu_hesaplar,attributes.com_acc_id);
                            str_borclu_tutarlar = ListAppend(str_borclu_tutarlar,attributes.com_ytl);
                            str_borclu_other_tutar = ListAppend(str_borclu_other_tutar,attributes.com_other);
                            str_other_borc_currency_list = ListAppend(str_other_borc_currency_list,attributes.rd_money);
                            if(is_account_group neq 1)
                            {
                                satir_detay_list[1][listlen(str_borclu_tutarlar)]='#attributes.comp_name# - #attributes.com_exp_item_name# - MENKUL KIYMET ALIŞ İŞLEMİ';
                            }
                            else
                            {
                                if (len(attributes.detail))
                                    satir_detay_list[1][listlen(str_borclu_tutarlar)]='#attributes.comp_name# - #attributes.detail# - MENKUL KIYMET ALIŞ İŞLEMİ';
                                else
                                    satir_detay_list[1][listlen(str_borclu_tutarlar)]='#attributes.comp_name# - MENKUL KIYMET ALIŞ İŞLEMİ';
                            } */
                            
                            //bankaya alis tutari toplami kadar alacak kaydeder
                            str_alacakli_hesaplar = ListAppend(str_alacakli_hesaplar,MY_ACC_RESULT);
                            str_alacakli_tutarlar = ListAppend(str_alacakli_tutarlar,filterNum(mk_toplam_alis));
                            str_alacakli_other_tutar = ListAppend(str_alacakli_other_tutar,filterNum(mk_toplam_alis_doviz));
                            str_other_alacak_currency_list = ListAppend(str_other_alacak_currency_list,attributes.rd_money);
                            
                            if(is_account_group neq 1)
                            {
                                get_item_name = cfquery(datasource:"#dsn2#", sqlstring:"SELECT EXPENSE_ITEM_NAME FROM EXPENSE_ITEMS WHERE EXPENSE_ITEM_ID = #mk_butce_kalemi#");
                                satir_detay_list[2][listlen(str_alacakli_tutarlar)]='#get_item_name.EXPENSE_ITEM_NAME# - MENKUL KIYMET ALIŞ İŞLEMİ';
                            }
                            else
                            {
                                satir_detay_list[2][listlen(str_alacakli_tutarlar)]='#attributes.comp_name# - MENKUL KIYMET ALIŞ İŞLEMİ';
                            }
                            
                            //bankaya komisyon tutari toplami kadar alacak kaydeder	
                            str_alacakli_hesaplar = ListAppend(str_alacakli_hesaplar,MY_ACC_RESULT);
                            str_alacakli_tutarlar = ListAppend(str_alacakli_tutarlar,filterNum(com_tl));
                            str_alacakli_other_tutar = ListAppend(str_alacakli_other_tutar,filterNum(com_other));
                            str_other_alacak_currency_list = ListAppend(str_other_alacak_currency_list,attributes.rd_money);
                            
                            if(is_account_group neq 1)
                            {
                                satir_detay_list[2][listlen(str_alacakli_tutarlar)]='MENKUL KIYMET ALIŞ İŞLEMİ';
                            }
                            else
                            {
                                satir_detay_list[2][listlen(str_alacakli_tutarlar)]='MENKUL KIYMET ALIŞ İŞLEMİ';
                            }
                            
                            muhasebeci (
                                action_id : get_action_id.max_id,
                                workcube_process_type : process_type,
                                workcube_process_cat : mk_process_cat,
                                account_card_type : 13,
                                company_id : mk_company_id,
                                islem_tarihi : mk_buy_date,
                                belge_no : paper_no,
                                fis_satir_detay : satir_detay_list,
                                borc_hesaplar : str_borclu_hesaplar,
                                borc_tutarlar : str_borclu_tutarlar,
                                other_amount_borc : str_borclu_other_tutar,
                                other_currency_borc : str_other_borc_currency_list,
                                alacak_hesaplar : str_alacakli_hesaplar,
                                alacak_tutarlar : str_alacakli_tutarlar,
                                other_amount_alacak : str_alacakli_other_tutar,
                                other_currency_alacak : str_other_alacak_currency_list,
                                currency_multiplier : currency_multiplier,
                                is_account_group : is_account_group,
                                fis_detay: 'MENKUL KIYMET ALIŞ İŞLEMİ',
                                from_branch_id : ListGetAt(session.ep.user_location,2,"-"),
                                dept_round_account :str_fark_gider,
                                claim_round_account : str_fark_gelir,
                                max_round_amount :str_max_round,
                                round_row_detail:str_round_detail
                            );
                        }
                    </cfscript>
                </cfif>
                    <!--- Money Kayıtları --->
                <cfloop from="1" to="#attributes.deger_get_money#" index="i">
                    <cfquery name="ADD_MONEY_INFO" datasource="#dsn2#">
                        INSERT INTO
                            #dsn3_alias#.STOCKBONDS_SALEPURCHASE_MONEY 
                            (
                                ACTION_ID,
                                MONEY_TYPE,
                                RATE2,
                                RATE1,
                                IS_SELECTED
                            )
                            VALUES
                            (
                                #get_action_id.max_id#,
                                '#wrk_eval("attributes.hidden_rd_money_#i#")#',
                                #evaluate("attributes.value_rate2#i#")#,
                                #evaluate("attributes.txt_rate1_#i#")#,
                                <cfif evaluate("attributes.hidden_rd_money_#i#") is attributes.rd_money>1<cfelse>0</cfif>
                            )
                    </cfquery>
                </cfloop>
                <!--- Belge No update ediliyor --->
                <cfquery name="UPD_GENERAL_PAPERS" datasource="#DSN2#">
                    UPDATE 
                        #dsn3_alias#.GENERAL_PAPERS
                    SET
                        BUYING_SECURITIES_NUMBER = #paper_number#
                    WHERE
                        BUYING_SECURITIES_NUMBER IS NOT NULL
                </cfquery>
                <cfcatch>
                    <cfoutput>
                        #i#. Satırda Sorun Oluştu. 
                    </cfoutput>	
                    <cfset kont=0>
                </cfcatch>
            </cftry>
            <cfif kont eq 1>
				<cfoutput>İmport Edildi... <br/></cfoutput>
			</cfif>
        </cftransaction>
    </cfloop>