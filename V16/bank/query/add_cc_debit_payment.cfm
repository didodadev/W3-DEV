<cfif attributes.active_period neq session.ep.period_id>
	<script type="text/javascript">
		alert("<cf_get_lang_main no='1659.İşlem Yapmak İstediğiniz Muhasebe Dönemi ile Aktif Muhasebe Döneminiz Farklı Muhasebe Döneminizi Kontrol Ediniz'>!");
		window.location.href='<cfoutput>#request.self#?fuseaction=bank.list_bank_actions</cfoutput>';
	</script>
	<cfabort>
</cfif>
<cfif isdefined("attributes.del") and attributes.del eq 1 and isdefined("attributes.process_type") and attributes.process_type eq 249>
    <cfquery name="del_row" datasource="#dsn3#">
        delete from  #dsn3_alias#.CREDIT_CARD_BANK_EXPENSE_ROWS where CC_BANK_EXPENSE_ROWS_ID = #attributes.row_id#
    </cfquery> 
    <cfscript>
        muhasebe_sil (action_id:attributes.row_id,process_type:249);
    </cfscript>
    <script type="text/javascript">
        wrk_opener_reload();
        window.close();
    </script>
    <cfabort>
</cfif>
<cfquery name="get_process_type" datasource="#dsn3#">
	SELECT 
		PROCESS_TYPE,
		IS_CARI,
		IS_ACCOUNT,
		IS_ACCOUNT_GROUP,
		ACTION_FILE_NAME,
		ACTION_FILE_FROM_TEMPLATE
	 FROM 
		SETUP_PROCESS_CAT 
	WHERE 
		PROCESS_CAT_ID = #form.process_cat#
</cfquery>
<cfscript>
	credit_card_info = listgetat(attributes.credit_card_info,3,';');
	action_from_account_id = listfirst(attributes.action_from_account_id,';');
	action_currency_id = listlast(attributes.action_from_account_id,';');
	process_type = get_process_type.PROCESS_TYPE;
	is_account = get_process_type.IS_ACCOUNT;
    is_cari = get_process_type.IS_CARI;
	is_account_group = get_process_type.IS_ACCOUNT_GROUP;
	attributes.masraf = filterNum(attributes.masraf);
	attributes.action_value = filterNum(attributes.action_value);
	attributes.other_money_value = filterNum(attributes.other_money_value);
	attributes.system_amount = filterNum(attributes.system_amount);
	currency_multiplier = '';
	for(a_sy = 1; a_sy lte attributes.kur_say; a_sy = a_sy + 1)
	{
		'attributes.txt_rate1_#a_sy#' = filterNum(evaluate('attributes.txt_rate1_#a_sy#'),session.ep.our_company_info.rate_round_num);
		'attributes.txt_rate2_#a_sy#' = filterNum(evaluate('attributes.txt_rate2_#a_sy#'),session.ep.our_company_info.rate_round_num);
		if(evaluate("attributes.hidden_rd_money_#a_sy#") is session.ep.money2)
			currency_multiplier = evaluate('attributes.txt_rate2_#a_sy#/attributes.txt_rate1_#a_sy#');
		if(evaluate("attributes.hidden_rd_money_#a_sy#") is action_currency_id)
			dovizli_islem_multiplier = evaluate('attributes.txt_rate2_#a_sy#/attributes.txt_rate1_#a_sy#');
	}
</cfscript>
<cf_date tarih='attributes.start_date'>
<cfsavecontent  variable="detail"><cf_get_lang dictionary_id="60595.KREDİ KARTI BORCU ÖDEME İADE İŞLEMİ"></cfsavecontent>
<cfif process_type eq 249><!--- iade işlemi--->
    <cflock name="#CreateUUID()#" timeout="60">
	<cftransaction>
        <cfquery name="get_rec" datasource="#dsn2#">
            select * from  #dsn3_alias#.CREDIT_CARD_BANK_EXPENSE_ROWS 
            JOIN #dsn3_alias#.CREDIT_CARD_BANK_EXPENSE ON CREDIT_CARD_BANK_EXPENSE.CREDITCARD_EXPENSE_ID =CREDIT_CARD_BANK_EXPENSE_ROWS.CREDITCARD_EXPENSE_ID  where CC_BANK_EXPENSE_ROWS_ID = #attributes.row_id#
        </cfquery>
        <cfquery name="add_rec" datasource="#dsn2#" result="xx">
            INSERT INTO  #dsn3_alias#.CREDIT_CARD_BANK_EXPENSE_ROWS  ( CC_ACTION_DATE,ACC_ACTION_DATE,CREDITCARD_EXPENSE_ID,CREDITCARD_ID,INSTALLMENT_DETAIL,INSTALLMENT_AMOUNT) 
            SELECT
                CC_ACTION_DATE,
                ACC_ACTION_DATE,
                CREDITCARD_EXPENSE_ID,
                CREDITCARD_ID,
                INSTALLMENT_DETAIL + ' Iade',
                #attributes.action_value#*-1 as INSTALLMENT_AMOUNT
            FROM
              #dsn3_alias#.CREDIT_CARD_BANK_EXPENSE_ROWS 
            where CC_BANK_EXPENSE_ROWS_ID = #attributes.row_id#
        </cfquery> 
     
            <cfquery name="GET_PAY_TYPE_ACC" datasource="#dsn2#">
                SELECT ACCOUNT_CODE FROM #dsn3_alias#.CREDIT_CARD WHERE CREDITCARD_ID = #credit_card_info#
            </cfquery>
            <cfscript>
                currency_multiplier = '';
                
                if(isDefined('attributes.kur_say') and len(attributes.kur_say))
                    for(mon=1;mon lte attributes.kur_say;mon=mon+1)
                    {
                        if(evaluate("attributes.hidden_rd_money_#mon#") is session.ep.money2)
                            currency_multiplier = evaluate('attributes.txt_rate2_#mon#/attributes.txt_rate1_#mon#');
                        if(evaluate("attributes.hidden_rd_money_#mon#") is form.money_type)
                            masraf_curr_multiplier = evaluate('attributes.txt_rate2_#mon#/attributes.txt_rate1_#mon#');
                        if(evaluate("attributes.hidden_rd_money_#mon#") is action_currency_id)
                            dovizli_islem_multiplier = evaluate('attributes.txt_rate2_#mon#/attributes.txt_rate1_#mon#');
                    }
                    expense_detail = 'KREDİ KARTI BORCU ÖDEME İADE';
                if (len(attributes.expense_item_id) and len(attributes.expense_item_name) )
                    GET_EXP_ACC = cfquery(datasource : "#dsn2#", sqlstring : "SELECT ACCOUNT_CODE FROM EXPENSE_ITEMS WHERE EXPENSE_ITEM_ID = #attributes.expense_item_id#");
              
                    
              /*  if(len(attributes.expense_item_id) and len(attributes.expense_item_name) and (attributes.masraf gt 0) and len(attributes.expense_center_id) and len(attributes.expense_center))
                {
                    butceci(
                        action_id : xx.IDENTITYCOL,
                        muhasebe_db : dsn2,
                        is_income_expense : iif((process_type eq 244),false,true),
                        process_type : process_type,
                        nettotal : attributes.masraf,
                        other_money_value : wrk_round(attributes.masraf/masraf_curr_multiplier),
                        action_currency : form.money_type,
                        currency_multiplier : currency_multiplier,
                        expense_date : attributes.start_date,
                        expense_center_id : attributes.expense_center_id,
                        expense_item_id : attributes.expense_item_id,
                        detail : expense_detail,
                        paper_no : attributes.paper_number,
                        branch_id : listgetat(session.ep.user_location,2,'-'),
                        insert_type : 1//banka vs den eklenen masraflar için farklı ekleme metodu tanımlar
                    );
                    
                }*/
                if(is_cari eq 1){
                    carici (
                        action_id : xx.IDENTITYCOL,
                        action_table : 'CREDIT_CARD_BANK_EXPENSE',
                        workcube_process_type : 249,		
                        process_cat : attributes.process_cat,	
                        islem_tarihi : attributes.start_date,
                        to_account_id : action_from_account_id,
                        to_branch_id : listgetat(session.ep.user_location,2,'-'),
                        islem_tutari : attributes.system_amount,
                        action_currency : session.ep.money,
                        other_money_value : attributes.other_money_value,
                        other_money : attributes.money_type,
                        currency_multiplier : currency_multiplier,
                        islem_detay : detail,
                        action_detail : attributes.action_detail,
                        account_card_type : 13,
                        islem_belge_no : attributes.paper_number,
                        due_date: attributes.start_date,
                        from_cmp_id : get_rec.action_to_company_id,
                        from_consumer_id : get_rec.cons_id,
                        rate2:currency_multiplier
                        );
                }
                if(is_account)
                {	
                   
                        fis_detail = detail;
                    if (isDefined("attributes.ACTION_DETAIL") and len(attributes.ACTION_DETAIL))
                        str_card_detail = '#attributes.ACTION_DETAIL#';
                    else if (process_type eq 244)
                        str_card_detail = fis_detail;
                    else
                        str_card_detail = fis_detail;
                    
                    
                        str_borclu_hesaplar = GET_PAY_TYPE_ACC.ACCOUNT_CODE;
                        if(isdefined("GET_EXP_ACC.ACCOUNT_CODE"))
                        str_alacakli_hesaplar = GET_EXP_ACC.ACCOUNT_CODE;
                        else 
                        str_alacakli_hesaplar = "";
                    
                    str_tutarlar = attributes.system_amount;  
                    str_borclu_other_amount_tutar = attributes.other_money_value;
                    str_borclu_other_currency = attributes.money_type;
                    str_alacakli_other_amount_tutar = attributes.action_value;
                    str_alacakli_other_currency = action_currency_id;
                
                    muhasebeci (
                        action_id:xx.IDENTITYCOL,
                        workcube_process_type:process_type,
                        workcube_process_cat:form.process_cat,
                        account_card_type:13,
                        islem_tarihi : attributes.start_date,
                        belge_no : attributes.paper_number,
                        fis_satir_detay : str_card_detail,
                        borc_hesaplar : str_borclu_hesaplar,
                        borc_tutarlar : str_tutarlar,
                        other_amount_borc : str_borclu_other_amount_tutar,
                        other_currency_borc : str_borclu_other_currency,
                        alacak_hesaplar : str_alacakli_hesaplar,
                        alacak_tutarlar : str_tutarlar,
                        other_amount_alacak : str_alacakli_other_amount_tutar,
                        other_currency_alacak : str_alacakli_other_currency,
                        currency_multiplier : currency_multiplier,
                        is_account_group : is_account_group,
                        from_branch_id : listgetat(session.ep.user_location,2,'-'),
                        fis_detay:fis_detail
                    );
                }
               
            </cfscript>
           
    </cftransaction>
    </cflock>   
<cfelse>
    <cf_papers paper_type="creditcard_debit_payment">
    <cflock name="#CreateUUID()#" timeout="60">
        <cftransaction>
            <cfif attributes.action_value gt 0>
                <cfquery name="ADD_BANK" datasource="#dsn2#" result="MAX_ID">
                    INSERT INTO
                        BANK_ACTIONS
                        (
                            ACTION_TYPE,
                            PROCESS_CAT,
                            ACTION_TYPE_ID,
                            <cfif process_type eq 244>ACTION_FROM_ACCOUNT_ID,<cfelse>ACTION_TO_ACCOUNT_ID,</cfif>
                            ACTION_VALUE,
                            MASRAF,
                            ACTION_DATE,
                            ACTION_CURRENCY_ID,
                            ACTION_DETAIL,
                            OTHER_CASH_ACT_VALUE,
                            OTHER_MONEY,
                            IS_ACCOUNT,
                            IS_ACCOUNT_TYPE,
                            PAPER_NO,
                            RECORD_EMP,
                            RECORD_IP,
                            RECORD_DATE	,
                            FROM_BRANCH_ID,
                            SYSTEM_ACTION_VALUE,
                            SYSTEM_CURRENCY_ID,
                            CREDITCARD_ID
                            <cfif len(session.ep.money2)>
                                ,ACTION_VALUE_2
                                ,ACTION_CURRENCY_ID_2
                            </cfif>
                        )
                        VALUES
                        (
                            <cfif process_type eq 244>'KREDİ KARTI BORCU ÖDEME'<cfelse>'KREDİ KARTI BORCU ÖDEME İPTAL'</cfif>,
                            #form.process_cat#,
                            #process_type#,
                            #action_from_account_id#,
                            <cfif len(attributes.masraf)>#attributes.action_value + attributes.masraf#,<cfelse>#attributes.action_value#,</cfif>
                            <cfif len(attributes.masraf)>#attributes.masraf#,<cfelse>0,</cfif>
                            #attributes.start_date#,
                            '#action_currency_id#',
                            <cfif len(attributes.action_detail)>'#left(attributes.action_detail,250)#',<cfelse>NULL,</cfif>
                            #attributes.other_money_value#,
                            '#attributes.money_type#',
                            <cfif is_account eq 1>1,13,<cfelse>0,13,</cfif>
                            <cfif isdefined("attributes.paper_number") and len(attributes.paper_number)>'#attributes.paper_number#',<cfelse>NULL,</cfif>
                            #session.ep.userid#,
                            '#cgi.REMOTE_ADDR#',
                            #now()#,
                            #listgetat(session.ep.user_location,2,'-')#,
                            <cfif len(attributes.masraf)>
                                #wrk_round((attributes.action_value + attributes.masraf)*dovizli_islem_multiplier)#,
                            <cfelse>
                                #wrk_round((attributes.action_value)*dovizli_islem_multiplier)#,
                            </cfif>
                            '#session.ep.money#',
                            #credit_card_info#
                            <cfif len(session.ep.money2)>
                                <cfif len(attributes.masraf)>
                                    ,#wrk_round(((attributes.action_value + attributes.masraf)*dovizli_islem_multiplier)/currency_multiplier)#
                                <cfelse>
                                    ,#wrk_round(((attributes.action_value)*dovizli_islem_multiplier)/currency_multiplier)#
                                </cfif>
                                ,'#session.ep.money2#'
                            </cfif>
                        )
                </cfquery>
                <cfquery name="GET_ACCOUNT" datasource="#dsn2#">
                    SELECT ACCOUNT_ACC_CODE AS ACC_CODE FROM #dsn3_alias#.ACCOUNTS WHERE ACCOUNT_ID = #action_from_account_id#
                </cfquery>
                <cfquery name="GET_PAY_TYPE_ACC" datasource="#dsn2#">
                    SELECT ACCOUNT_CODE FROM #dsn3_alias#.CREDIT_CARD WHERE CREDITCARD_ID = #credit_card_info#
                </cfquery>
                <cfscript>
                    currency_multiplier = '';
                    if(isDefined('attributes.kur_say') and len(attributes.kur_say))
                        for(mon=1;mon lte attributes.kur_say;mon=mon+1)
                        {
                            if(evaluate("attributes.hidden_rd_money_#mon#") is session.ep.money2)
                                currency_multiplier = evaluate('attributes.txt_rate2_#mon#/attributes.txt_rate1_#mon#');
                            if(evaluate("attributes.hidden_rd_money_#mon#") is form.money_type)
                                masraf_curr_multiplier = evaluate('attributes.txt_rate2_#mon#/attributes.txt_rate1_#mon#');
                            if(evaluate("attributes.hidden_rd_money_#mon#") is action_currency_id)
                                dovizli_islem_multiplier = evaluate('attributes.txt_rate2_#mon#/attributes.txt_rate1_#mon#');
                        }
                    if (process_type eq 244)
                        expense_detail = 'KREDİ KARTI BORCU ÖDEME MASRAFI';
                    else
                        expense_detail = 'KREDİ KARTI BORCU ÖDEME İPTAL MASRAFI';
                    if(len(attributes.expense_item_id) and len(attributes.expense_item_name) and (attributes.masraf gt 0) and len(attributes.expense_center_id) and len(attributes.expense_center))
                    {
                        butceci(
                            action_id : MAX_ID.IDENTITYCOL,
                            muhasebe_db : dsn2,
                            is_income_expense : iif((process_type eq 244),false,true),
                            process_type : process_type,
                            nettotal : attributes.masraf,
                            other_money_value : wrk_round(attributes.masraf/masraf_curr_multiplier),
                            action_currency : form.money_type,
                            currency_multiplier : currency_multiplier,
                            expense_date : attributes.start_date,
                            expense_center_id : attributes.expense_center_id,
                            expense_item_id : attributes.expense_item_id,
                            detail : expense_detail,
                            paper_no : attributes.paper_number,
                            branch_id : listgetat(session.ep.user_location,2,'-'),
                            insert_type : 1//banka vs den eklenen masraflar için farklı ekleme metodu tanımlar
                        );
                        GET_EXP_ACC = cfquery(datasource : "#dsn2#", sqlstring : "SELECT ACCOUNT_CODE FROM EXPENSE_ITEMS WHERE EXPENSE_ITEM_ID = #attributes.expense_item_id#");
                    }
                        
                    if(is_account)
                    {	
                        if (process_type eq 244)
                            fis_detail = 'KREDİ KARTI BORCU ÖDEME İŞLEMİ';
                        else
                            fis_detail = 'KREDİ KARTI BORCU ÖDEME İPTAL İŞLEMİ';
                        if (isDefined("attributes.ACTION_DETAIL") and len(attributes.ACTION_DETAIL))
                            str_card_detail = '#attributes.ACTION_DETAIL#';
                        else if (process_type eq 244)
                            str_card_detail = fis_detail;
                        else
                            str_card_detail = fis_detail;
                        
                        if (process_type eq 244)
                        {
                            str_borclu_hesaplar = GET_PAY_TYPE_ACC.ACCOUNT_CODE;
                            str_alacakli_hesaplar = GET_ACCOUNT.ACC_CODE;
                        }
                        else
                        {
                            str_borclu_hesaplar = GET_ACCOUNT.ACC_CODE;
                            str_alacakli_hesaplar = GET_PAY_TYPE_ACC.ACCOUNT_CODE;
                        }
                        str_tutarlar = attributes.system_amount;
                        
                        str_borclu_other_amount_tutar = attributes.other_money_value;
                        str_borclu_other_currency = attributes.money_type;
                        str_alacakli_other_amount_tutar = attributes.action_value;
                        str_alacakli_other_currency = action_currency_id;
                        
                        if(len(attributes.masraf) and attributes.masraf gt 0 and len(GET_EXP_ACC.ACCOUNT_CODE))
                        {
                            str_borclu_hesaplar = ListAppend(str_borclu_hesaplar,GET_EXP_ACC.ACCOUNT_CODE,",");	
                            str_alacakli_hesaplar = ListAppend(str_alacakli_hesaplar,GET_ACCOUNT.ACC_CODE,",");
                            str_tutarlar = ListAppend(str_tutarlar,attributes.masraf,",");
                            str_borclu_other_amount_tutar = ListAppend(str_borclu_other_amount_tutar,attributes.masraf,",");
                            str_borclu_other_currency = ListAppend(str_borclu_other_currency,action_currency_id,",");
                            str_alacakli_other_amount_tutar = ListAppend(str_alacakli_other_amount_tutar,attributes.masraf,",");
                            str_alacakli_other_currency = ListAppend(str_alacakli_other_currency,action_currency_id,",");
                        }
                        muhasebeci (
                            action_id:MAX_ID.IDENTITYCOL,
                            workcube_process_type:process_type,
                            workcube_process_cat:form.process_cat,
                            account_card_type:13,
                            islem_tarihi : attributes.start_date,
                            belge_no : attributes.paper_number,
                            fis_satir_detay : str_card_detail,
                            borc_hesaplar : str_borclu_hesaplar,
                            borc_tutarlar : str_tutarlar,
                            other_amount_borc : str_borclu_other_amount_tutar,
                            other_currency_borc : str_borclu_other_currency,
                            alacak_hesaplar : str_alacakli_hesaplar,
                            alacak_tutarlar : str_tutarlar,
                            other_amount_alacak : str_alacakli_other_amount_tutar,
                            other_currency_alacak : str_alacakli_other_currency,
                            currency_multiplier : currency_multiplier,
                            is_account_group : is_account_group,
                            from_branch_id : listgetat(session.ep.user_location,2,'-'),
                            fis_detay:fis_detail
                        );
                    }
                    f_kur_ekle_action(action_id:MAX_ID.IDENTITYCOL,process_type:0,action_table_name:'BANK_ACTION_MONEY',action_table_dsn:'#dsn2#');
                </cfscript>
                
                <!--- Belge No update ediliyor --->
                <cfif len(paper_number)>
                    <cfquery name="UPD_GENERAL_PAPERS" datasource="#dsn2#">
                        UPDATE 
                            #dsn3_alias#.GENERAL_PAPERS
                        SET
                            CREDITCARD_DEBIT_PAYMENT_NUMBER = #paper_number#
                        WHERE
                            CREDITCARD_DEBIT_PAYMENT_NUMBER IS NOT NULL
                    </cfquery>
                </cfif>
                    <cf_workcube_process_cat 
                        process_cat="#form.process_cat#"
                        action_id = #MAX_ID.IDENTITYCOL#
                        is_action_file = 1
                        action_page='#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.list_credit_card_expense&event=updDebit&id=#MAX_ID.IDENTITYCOL#'
                        action_file_name='#get_process_type.action_file_name#'
                        action_db_type = '#dsn2#'
                        is_template_action_file = '#get_process_type.action_file_from_template#'>
            </cfif>       
            <!--- ara odemeler var ise kapamalar yapılıyor --->
            <!--- 
                attributes.exp_count gt 0 idi, Ara ödemelerde ilişki kurulmaması gerekiyor.
				Girilen tutar kadar işlem kapatılmalı.
            ---->
            <cfif process_type eq 244 and isDefined('attributes.exp_count') and attributes.exp_count gt 0 and isdefined('attributes.interim_payment') and attributes.interim_payment gt 0>
                <cfquery name="getCreditCardPaymentClose" datasource="#dsn2#">
                    WITH CIKIS AS (
                        SELECT
                            CBR.CC_BANK_EXPENSE_ROWS_ID,
                            ACC_ACTION_DATE,
                            ISNULL(SUM(INSTALLMENT_AMOUNT-ISNULL((SELECT SUM(CLOSED_AMOUNT) FROM #dsn3_alias#.CREDIT_CARD_BANK_EXPENSE_RELATIONS WHERE CREDIT_CARD_BANK_EXPENSE_RELATIONS.CC_BANK_EXPENSE_ROWS_ID = CBR.CC_BANK_EXPENSE_ROWS_ID),0)) OVER (ORDER BY ACC_ACTION_DATE ROWS BETWEEN UNBOUNDED PRECEDING AND 1 PRECEDING),0) AS CIKIS_START,
                            SUM(INSTALLMENT_AMOUNT-ISNULL((SELECT SUM(CLOSED_AMOUNT) FROM #dsn3_alias#.CREDIT_CARD_BANK_EXPENSE_RELATIONS WHERE CREDIT_CARD_BANK_EXPENSE_RELATIONS.CC_BANK_EXPENSE_ROWS_ID = CBR.CC_BANK_EXPENSE_ROWS_ID),0)) OVER (ORDER BY ACC_ACTION_DATE ROWS UNBOUNDED PRECEDING) AS CIKIS_END
                        FROM
                            #dsn3_alias#.CREDIT_CARD_BANK_EXPENSE CBE
                            RIGHT JOIN #dsn3_alias#.CREDIT_CARD_BANK_EXPENSE_ROWS CBR ON CBR.CREDITCARD_EXPENSE_ID = CBE.CREDITCARD_EXPENSE_ID
                        WHERE
                            CBE.CREDITCARD_ID = #credit_card_info# and
                            PROCESS_TYPE <> 246 AND
                            INSTALLMENT_AMOUNT-ISNULL((SELECT SUM(CLOSED_AMOUNT) FROM #dsn3_alias#.CREDIT_CARD_BANK_EXPENSE_RELATIONS WHERE CREDIT_CARD_BANK_EXPENSE_RELATIONS.CC_BANK_EXPENSE_ROWS_ID = CBR.CC_BANK_EXPENSE_ROWS_ID),0) > 0
                        ),
                        GIRIS AS (
                            SELECT * FROM
                            (
                            SELECT
                                BA.ACTION_ID,
                                BA.ACTION_DATE,
                                ISNULL(SUM(BA.ACTION_VALUE-ISNULL(BA.MASRAF,0)-ISNULL((SELECT SUM(CLOSED_AMOUNT) FROM #dsn3_alias#.CREDIT_CARD_BANK_EXPENSE_RELATIONS WHERE CREDIT_CARD_BANK_EXPENSE_RELATIONS.BANK_ACTION_ID = BA.ACTION_ID),0)) OVER (ORDER BY BA.ACTION_DATE ROWS BETWEEN UNBOUNDED PRECEDING AND 1 PRECEDING),0) AS GIRIS_START,
                                SUM(BA.ACTION_VALUE-ISNULL(BA.MASRAF,0)-ISNULL((SELECT SUM(CLOSED_AMOUNT) FROM #dsn3_alias#.CREDIT_CARD_BANK_EXPENSE_RELATIONS WHERE CREDIT_CARD_BANK_EXPENSE_RELATIONS.BANK_ACTION_ID = BA.ACTION_ID),0)) OVER (ORDER BY BA.ACTION_DATE ROWS UNBOUNDED PRECEDING) AS GIRIS_END
                            FROM 
                                BANK_ACTIONS BA
                                LEFT JOIN #dsn3_alias#.CREDIT_CARD_BANK_EXPENSE_RELATIONS CCB ON BA.ACTION_ID = CCB.BANK_ACTION_ID AND CCB.BANK_ACTION_PERIOD_ID = #session.ep.period_id#
                            WHERE 
                                BA.CREDITCARD_ID = #credit_card_info# 
                            ) AS T
                            WHERE 
                            GIRIS_END>0
                        ),
                        KARTEZYEN AS (
                            SELECT
                                GIRIS.ACTION_ID GIRIS_ID,
                                CIKIS.CC_BANK_EXPENSE_ROWS_ID CIKIS_ID,
                                GIRIS_START,
                                GIRIS_END,
                                CIKIS_START,
                                CIKIS_END,
                                (IIF(CIKIS_END > GIRIS_END, GIRIS_END, CIKIS_END) - IIF(CIKIS_START > GIRIS_START, CIKIS_START, GIRIS_START)) AMOUNT
                            FROM
                                CIKIS,GIRIS
                            WHERE
                                (CIKIS.CIKIS_START BETWEEN GIRIS.GIRIS_START AND GIRIS.GIRIS_END OR CIKIS.CIKIS_END BETWEEN GIRIS.GIRIS_START AND GIRIS.GIRIS_END OR (CIKIS.CIKIS_START <= GIRIS.GIRIS_START AND GIRIS.GIRIS_END <= CIKIS.CIKIS_END))
                        )
                    SELECT * FROM KARTEZYEN WHERE CIKIS_END <= #attributes.action_value#
                </cfquery>				
                <cfoutput query="getCreditCardPaymentClose">   
                    <cfquery name="ADD_RELATION" datasource="#dsn2#">
                        INSERT INTO
                            #dsn3_alias#.CREDIT_CARD_BANK_EXPENSE_RELATIONS
                            (
                                CC_BANK_EXPENSE_ROWS_ID,
                                BANK_ACTION_ID,
                                BANK_ACTION_PERIOD_ID,
                                CLOSED_AMOUNT
                            )
                            VALUES
                            (
                                #cikis_id#,
                                #giris_id#,
                                #session.ep.period_id#,
                                #amount#
                            )
                    </cfquery>
                </cfoutput>
            <cfelse>
				<cfset kalan_tutar_ = attributes.action_value>
				<cfset fark = 0>
				<cfloop from="1" to="#attributes.exp_count#" index="tt">
					<cfset fark = kalan_tutar_ - evaluate('attributes.exp_amount#tt#')>
					<cfif fark lte 0>
						<cfset closed_amount_ = kalan_tutar_>
					<cfelse>
						<cfset closed_amount_ = evaluate('attributes.exp_amount#tt#')>
					</cfif>
					<cfif kalan_tutar_ gt 0>
						<cfquery name="ADD_RELATION" datasource="#dsn2#">
							INSERT INTO
								#dsn3_alias#.CREDIT_CARD_BANK_EXPENSE_RELATIONS
								(
									CC_BANK_EXPENSE_ROWS_ID,
									BANK_ACTION_ID,
									BANK_ACTION_PERIOD_ID,
									CLOSED_AMOUNT
								)
								VALUES
								(
									#evaluate('attributes.exp_row_id#tt#')#,
									#MAX_ID.IDENTITYCOL#,
									#session.ep.period_id#,
									#closed_amount_#
								)
						</cfquery>
					</cfif>				
					<cfset kalan_tutar_ = kalan_tutar_ - evaluate('attributes.exp_amount#tt#')>
				</cfloop>
            </cfif>
        </cftransaction>
    </cflock>
</cfif>
<script type="text/javascript">
	wrk_opener_reload();
	window.close();
</script>