<cfif len(GET_CREDIT_PAYMENT.PAYMENT_RATE) and GET_CREDIT_PAYMENT.PAYMENT_RATE neq 0 and len(GET_CREDIT_PAYMENT.PAYMENT_RATE_ACC)><!--- ödeme yönteminde komisyon varsa hesap seçilmişse komisyon kadar dekont kaydedilr --->
    <cfinclude template="add_debit_from_cc_revenue.cfm">
<cfelse>
	<cfset GET_MAX_CH.ACTION_ID = ''>
</cfif>
<cfif len(GET_CREDIT_PAYMENT.SERVICE_RATE) and GET_CREDIT_PAYMENT.SERVICE_RATE neq 0>
    <!--- ödeme yöntemindeki seçilen banka komisyon oranına göre komisyon hesaplanır --->
    <cfset commission_multiplier_amount = wrk_round(attributes.sales_credit_comm * GET_CREDIT_PAYMENT.SERVICE_RATE /100)>
<cfelse>
    <cfset commission_multiplier_amount = 0>
</cfif>
<cfquery name="ADD_CREDIT_PAYMENT" datasource="#DSN3#" result="MAX_ID"> <!--- Kredi kartı tahsilat hareketi yazılır --->
    INSERT INTO
        CREDIT_CARD_BANK_PAYMENTS
        (
            PROCESS_CAT,
            ACTION_TYPE_ID,
            WRK_ID,
            PAYMENT_TYPE_ID,<!--- ödeme yöntemi --->
            NUMBER_OF_INSTALMENT,<!--- ödeme yöntemi taksit sayısı --->
            ACTION_TO_ACCOUNT_ID,<!--- ödeme yöntmiyle seçilen hesap --->
            ACTION_CURRENCY_ID,<!--- hesap para birimi --->
            ACTION_FROM_COMPANY_ID,
            PARTNER_ID,
            CONSUMER_ID,
            STORE_REPORT_DATE,<!--- işlem tarihi --->
            DUE_START_DATE,
            SALES_CREDIT,<!--- işlem tutarı --->
            COMMISSION_AMOUNT,<!--- ödeme yöntemindeki hizmet komisyon ORANIYLA yapılmış olan komsiyon tutarı--->
            OTHER_MONEY,
            OTHER_CASH_ACT_VALUE,
            ACTION_DETAIL,
            ACTION_TYPE,
            IS_ACCOUNT,
            IS_ACCOUNT_TYPE,
            CARD_NO,
            CARD_OWNER,
            ACTION_PERIOD_ID,
            CARI_ACTION_ID,<!--- komisyondan kestiğimiz dekontun bilgisi --->
            CARI_ACTION_VALUE,
            PROJECT_ID,
            PAPER_NO,
            ASSETP_ID,
            RECORD_EMP,
            RECORD_DATE,
            RECORD_IP,
            SPECIAL_DEFINITION_ID,
            REVENUE_COLLECTOR_ID,
            TO_BRANCH_ID,
            RELATION_CREDITCARD_PAYMENT_ID,
            CANCEL_TYPE_ID,
            MULTI_ACTION_ID,
            SUBSCRIPTION_ID
        )
        VALUES
        (
            #attributes.process_cat#,
            #process_type#,
            <!--- <cfqueryparam cfsqltype="cf_sql_varchar" value="#wrk_id#">, --->
            '#wrk_id#',
            #attributes.payment_type_id#,
            <cfif len(get_credit_payment.number_of_instalment)>#get_credit_payment.number_of_instalment#,<cfelse>NULL,</cfif>
            #attributes.account_id#,
            <!--- <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.currency_id#">, --->
            '#attributes.currency_id#',
            <cfif len(attributes.action_from_company_id)>#attributes.action_from_company_id#,<cfelse>NULL,</cfif>
            <cfif len(attributes.par_id)>#attributes.par_id#,<cfelse>NULL,</cfif>
            <cfif len(attributes.cons_id)>#attributes.cons_id#,<cfelse>NULL,</cfif>
            #attributes.action_date#,
            #attributes.due_start_date#,
            #attributes.sales_credit#,
            #commission_multiplier_amount#,
            <!--- <cfif len(attributes.money_type)><cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.money_type#">,<cfelse>NULL,</cfif> --->
            <cfif len(attributes.money_type)>'#attributes.money_type#',<cfelse>NULL,</cfif>
            <cfif len(attributes.other_value_sales_credit)>#attributes.other_value_sales_credit#,<cfelse>NULL,</cfif>
            <!--- <cfif len(attributes.action_detail)><cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.action_detail#">,<cfelse>NULL,</cfif> --->
            <cfif len(attributes.action_detail)>'#attributes.action_detail#',<cfelse>NULL,</cfif>
            <!--- <cfif process_type eq 241><cfqueryparam cfsqltype="cf_sql_varchar" value="KREDİ KARTI TAHSİLAT">,<cfelse><cfqueryparam cfsqltype="cf_sql_varchar" value="KREDİ KARTI TAHSİLAT İPTAL">,</cfif> --->
            <cfif process_type eq 241>'KREDİ KARTI TAHSİLAT'<cfelseif process_type eq 2410>'TOPLU KREDİ KARTI TAHSİLAT'<cfelse>'KREDİ KARTI TAHSİLAT İPTAL'</cfif>,
            <cfif is_account eq 1>1,13,<cfelse>0,13,</cfif>
            <!--- <cfif len(attributes.card_no)><cfqueryparam cfsqltype="cf_sql_varchar" value="#content#">,<cfelse>NULL,</cfif>
            <cfif len(attributes.card_owner)><cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.card_owner#">,<cfelse>NULL,</cfif> --->
            <cfif len(attributes.card_no)>'#attributes.card_no#',<cfelse>NULL,</cfif>
            <cfif len(attributes.card_owner)>'#attributes.card_owner#',<cfelse>NULL,</cfif>
            #session_base.period_id#,
            <cfif isDefined("GET_MAX_CH.ACTION_ID") and len(GET_MAX_CH.ACTION_ID)>#GET_MAX_CH.ACTION_ID#,<cfelse>NULL,</cfif>
            <cfif isDefined("GET_MAX_CH.ACTION_ID") and len(GET_MAX_CH.ACTION_ID)>#wrk_round(attributes.sales_credit - attributes.sales_credit_comm)#,<cfelse>NULL,</cfif>
            <cfif len(attributes.project_id) and len(attributes.project_name)>#attributes.project_id#,<cfelse>NULL,</cfif>
            <!--- <cfif isdefined("attributes.paper_number") and len(attributes.paper_number)><cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.paper_number#">,<cfelse>NULL,</cfif> --->
            <cfif isdefined("attributes.paper_number") and len(attributes.paper_number)>'#attributes.paper_number#',<cfelse>NULL,</cfif>
            <cfif isdefined("attributes.asset_id") and len(attributes.asset_id) and len(attributes.asset_name)>#attributes.asset_id#<cfelse>NULL</cfif>,
            #session_base.userid#,
            #now()#,
            <!--- <cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.remote_addr#">, --->
            '#cgi.remote_addr#',
            <cfif isdefined("attributes.special_definition_id") and len(attributes.special_definition_id)>#attributes.special_definition_id#<cfelse>NULL</cfif>,
            <cfif isdefined("attributes.revenue_collector_id") and len(attributes.revenue_collector_id)>#attributes.revenue_collector_id#<cfelse>NULL</cfif>,
            <cfif len(#branch_id_info#)>#branch_id_info#<cfelse>NULL</cfif>,
            <cfif isdefined('attributes.relation_payment_id') and len(attributes.relation_payment_id)>#attributes.relation_payment_id#<cfelse>NULL</cfif>,
            <cfif isdefined('attributes.cancel_type_id') and len(attributes.cancel_type_id) and process_type eq 245>#attributes.cancel_type_id#<cfelse>NULL</cfif>,
            <cfif isdefined('get_multi_id.multi_id') and len(get_multi_id.multi_id)><cfqueryparam cfsqltype="cf_sql_integer" value="#get_multi_id.multi_id#"><cfelseif isdefined('attributes.multi_id')><cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.multi_id#"><cfelse>NULL</cfif>,
            <cfif isdefined("attributes.subscription_id") and len(attributes.subscription_id) and len(attributes.subscription_no)>#attributes.subscription_id#<cfelse>NULL</cfif>
        )
</cfquery>

<cfquery name="GET_CREDIT_CARD_BANK_PAYMENT" datasource="#DSN3#">
    SELECT 
        SALES_CREDIT,
        COMMISSION_AMOUNT,
        PAYMENT_TYPE_ID,
        STORE_REPORT_DATE,
        DUE_START_DATE,
        CREDITCARD_PAYMENT_ID
    FROM 
        CREDIT_CARD_BANK_PAYMENTS 
    WHERE
        CREDITCARD_PAYMENT_ID = #MAX_ID.IDENTITYCOL#
</cfquery>

<!--- iptal islemlerinde yani bugün yapilan tahsilatlarda iliskili tahsilata iptal edildigini tutuyor --->
<cfif isdefined('attributes.relation_payment_id') and len(attributes.relation_payment_id)>
    <cfquery name="updRelaionCreditCardPayment" datasource="#dsn3#">
        UPDATE CREDIT_CARD_BANK_PAYMENTS SET IS_VOID = <cfif isdefined('is_iptal') and is_iptal eq 1>1<cfelse>0</cfif> WHERE CREDITCARD_PAYMENT_ID = #attributes.relation_payment_id#
    </cfquery>
</cfif>
        
<!--- işlem tarihi üstüne hesaba geçiş tarihi eklenerek rowlara yazılır --->
<cfset bank_action_date = dateadd("d", GET_CREDIT_PAYMENT.P_TO_INSTALMENT_ACCOUNT,GET_CREDIT_CARD_BANK_PAYMENT.DUE_START_DATE)>

<cfif (GET_CREDIT_PAYMENT.IS_PESIN eq 1) or (not len(GET_CREDIT_PAYMENT.NUMBER_OF_INSTALMENT)) or (GET_CREDIT_PAYMENT.NUMBER_OF_INSTALMENT eq 0)><!--- Banka hemen öder seçeneği seçilmemişse veya işlem taksitsizse tek satır paişn giriş yazar --->
    <cfset satir_sayisi = 1>
    <cfset operation_type = 'Peşin Giriş'>
    <cfset tutar = GET_CREDIT_CARD_BANK_PAYMENT.SALES_CREDIT>
    <cfif (GET_CREDIT_CARD_BANK_PAYMENT.COMMISSION_AMOUNT) gt 0>
        <cfset komisyon_tutar = GET_CREDIT_CARD_BANK_PAYMENT.COMMISSION_AMOUNT>
    <cfelse>
        <cfset komisyon_tutar = 0>
    </cfif>
<cfelse>
    <cfset satir_sayisi = GET_CREDIT_PAYMENT.NUMBER_OF_INSTALMENT>
    <cfset tutar = (GET_CREDIT_CARD_BANK_PAYMENT.SALES_CREDIT/GET_CREDIT_PAYMENT.NUMBER_OF_INSTALMENT)>
    <cfif (GET_CREDIT_CARD_BANK_PAYMENT.COMMISSION_AMOUNT) gt 0>
        <cfset komisyon_tutar = (GET_CREDIT_CARD_BANK_PAYMENT.COMMISSION_AMOUNT/GET_CREDIT_PAYMENT.NUMBER_OF_INSTALMENT)>
    <cfelse>
        <cfset komisyon_tutar = 0>
    </cfif>
</cfif>


<cfset average_day = 0><!--- vade gun hesaplama taksitlere gore ortalama vade hesapliyor --->
<cfloop from="1" to="#satir_sayisi#" index="i">
	<cfset average_day = average_day+datediff("d",GET_CREDIT_CARD_BANK_PAYMENT.DUE_START_DATE,bank_action_date)>
    <cfquery name="ADD_CREDIT_CARD_BANK_PAYMENT_ROWS" datasource="#dsn3#">
        INSERT INTO
            CREDIT_CARD_BANK_PAYMENTS_ROWS
        (
            STORE_REPORT_DATE,<!--- tahsilat işlem tarihi --->
            BANK_ACTION_DATE,<!--- hesaba geçiş tarihi --->
            CREDITCARD_PAYMENT_ID,<!--- tahsilat id si --->
            PAYMENT_TYPE_ID,<!--- ödeme yöntemi id si --->
            OPERATION_NAME,
            AMOUNT,<!--- işlem tutarı --->
            COMMISSION_AMOUNT<!--- komsiyon tutarı --->
        )
        VALUES
        (
            #CreateODBCDateTime(GET_CREDIT_CARD_BANK_PAYMENT.STORE_REPORT_DATE)#,
            #bank_action_date#,
            #GET_CREDIT_CARD_BANK_PAYMENT.CREDITCARD_PAYMENT_ID#,
            #GET_CREDIT_CARD_BANK_PAYMENT.PAYMENT_TYPE_ID#,
            <cfif isDefined("operation_type")><cfqueryparam cfsqltype="cf_sql_varchar" value="#operation_type#"><cfelse><cfqueryparam cfsqltype="cf_sql_varchar" value="#i#. Taksit"></cfif>,
            #tutar#,
            #komisyon_tutar#
        )
    </cfquery>
    
    <cfset bank_action_date = dateadd("m",1,bank_action_date)>
</cfloop>
<cfset average_day = ceiling(average_day/satir_sayisi)>

<!--- cari muhasebe işlemleri --->
<cfscript>
    if(isdefined("attributes.project_id") and len(attributes.project_id) and len(attributes.project_name))
        project_id_info = attributes.project_id;
    else
        project_id_info = '';
    if (is_cari eq 1)
    {	
        if(satir_sayisi eq 1) average_due_date = dateadd("d",0,attributes.due_start_date);
        else average_due_date = dateadd("d",average_day,attributes.due_start_date);//ortalama vade tarihi taksitlere gore hesaplanir
	
        if (process_type eq 241 or process_type eq 2410)//kredi kartı tahsilat
        {		
			if (process_type eq 241)
	        	islem_detay_ = 'KREDİ KARTI TAHSİLAT';
			else
				islem_detay_ = 'TOPLU KREDİ KARTI TAHSİLAT';	
			
            carici(
                action_id : MAX_ID.IDENTITYCOL,
                action_table : 'CREDIT_CARD_BANK_PAYMENTS',
                workcube_process_type : process_type,
                process_cat : attributes.process_cat,
                islem_tarihi : attributes.action_date,
                islem_belge_no : attributes.paper_number,
                due_date : average_due_date,
                to_account_id : attributes.account_id,
                islem_tutari : attributes.system_amount,
                action_currency : session_base.money,
                other_money_value : iif(len(attributes.other_value_sales_credit),'attributes.other_value_sales_credit',de('')),
                other_money : attributes.money_type,
                currency_multiplier : currency_multiplier,
                islem_detay : islem_detay_,
                action_detail : attributes.action_detail,
                account_card_type : 13,
                cari_db : dsn3,
                from_cmp_id : attributes.ACTION_FROM_COMPANY_ID,
                from_consumer_id : attributes.cons_id,
                project_id : project_id_info,
                to_branch_id : branch_id_info,
                subscription_id : iif((isdefined("attributes.subscription_id") and len(attributes.subscription_id) and len(attributes.subscription_no)),attributes.subscription_id,de('')),
                special_definition_id : iif((isdefined("attributes.special_definition_id") and len(attributes.special_definition_id)),'attributes.special_definition_id',de('')),
                assetp_id : iif((isdefined("attributes.asset_id") and len(attributes.asset_id) and len(attributes.asset_name)),'attributes.asset_id',de('')),
                rate2:currency_multiplier_other,
				cari_db_alias = dsn2_alias
                );
        }
        else
        {
            carici(
                action_id : MAX_ID.IDENTITYCOL,
                action_table : 'CREDIT_CARD_BANK_PAYMENTS',
                workcube_process_type : process_type,
                process_cat : attributes.process_cat,
                islem_tarihi : attributes.action_date,
                islem_belge_no : attributes.paper_number,
                due_date : average_due_date,
                from_account_id : attributes.account_id,
                islem_tutari : attributes.system_amount,
                action_currency : session_base.money,
                other_money_value : iif(len(attributes.other_value_sales_credit),'attributes.other_value_sales_credit',de('')),
                other_money : attributes.money_type,
                currency_multiplier : currency_multiplier,
                islem_detay : 'KREDİ KARTI TAHSİLAT İPTAL',
                action_detail : attributes.action_detail,
                account_card_type : 13,
                cari_db : dsn3,
                to_cmp_id : attributes.ACTION_FROM_COMPANY_ID,
                to_consumer_id : attributes.cons_id,
                project_id : project_id_info,
                from_branch_id : branch_id_info,
                subscription_id : iif((isdefined("attributes.subscription_id") and len(attributes.subscription_id) and len(attributes.subscription_no)),attributes.subscription_id,de('')),
                special_definition_id : iif((isdefined("attributes.special_definition_id") and len(attributes.special_definition_id)),'attributes.special_definition_id',de('')),
                assetp_id : iif((isdefined("attributes.asset_id") and len(attributes.asset_id) and len(attributes.asset_name)),'attributes.asset_id',de('')),
                rate2:currency_multiplier_other,
				cari_db_alias = dsn2_alias
                );
        }
    }
    if (is_account eq 1 and process_type neq 2410)
    {
		if (process_type eq 241)//kredi kartı tahsilat
		{
			borc_hesap = GET_CREDIT_PAYMENT.account_code;
			alacak_hesap = MY_ACC_RESULT;
			fis_detail = 'KREDİ KARTI TAHSİLAT';
			other_alacak_tutar = attributes.other_value_sales_credit;
			other_alacak_currency = attributes.money_type;
			other_borc_tutar = attributes.sales_credit;
			other_borc_currency = attributes.currency_id;
		}
		else//kredi kartı tahsilat iptal
		{
			borc_hesap = MY_ACC_RESULT;
			alacak_hesap = GET_CREDIT_PAYMENT.account_code;
			fis_detail = 'KREDİ KARTI TAHSİLAT İPTAL';
			other_alacak_tutar = attributes.sales_credit;
			other_alacak_currency = attributes.currency_id;
			other_borc_tutar = attributes.other_value_sales_credit;
			other_borc_currency = attributes.money_type;
		}
		if(isDefined("attributes.ACTION_DETAIL") and len(attributes.ACTION_DETAIL))
		{
			if(process_type eq 241) str_card_detail = '#member_name_# - KREDİ KARTI TAHSİLAT - #attributes.ACTION_DETAIL#';
			else str_card_detail = '#member_name_# - KREDİ KARTI TAHSİLAT İPTAL - #attributes.ACTION_DETAIL#';
		}
		else
			if(process_type eq 241) str_card_detail = '#member_name_# - KREDİ KARTI TAHSİLAT'; 
			else str_card_detail = '#member_name_# - KREDİ KARTI TAHSİLAT İPTAL';
						
		muhasebeci (
			wrk_id : wrk_id,
			action_id: MAX_ID.IDENTITYCOL,
			workcube_process_type: process_type,
			workcube_process_cat:attributes.process_cat,
			account_card_type: 13,
			islem_tarihi: attributes.ACTION_DATE,
			fis_satir_detay: str_card_detail,
			belge_no : attributes.paper_number,
			company_id : attributes.action_from_company_id,
			consumer_id : attributes.cons_id,
			borc_hesaplar: borc_hesap,
			borc_tutarlar: attributes.system_amount,
			other_amount_borc : other_borc_tutar,
			other_currency_borc : other_borc_currency,
			alacak_hesaplar: alacak_hesap,
			alacak_tutarlar: attributes.system_amount,
			other_amount_alacak : other_alacak_tutar,
			other_currency_alacak : other_alacak_currency,
			currency_multiplier : currency_multiplier,
			muhasebe_db : dsn3,
			fis_detay: fis_detail,
			acc_project_id : project_id_info,
			to_branch_id : iif((process_type eq 241),branch_id_info,de('')),
			from_branch_id : iif((process_type eq 245),branch_id_info,de('')),
			is_abort : iif(isdefined('xml_import'),0,1),
			muhasebe_db_alias = dsn2_alias
		);
    }
    f_kur_ekle_action(action_id:MAX_ID.IDENTITYCOL,process_type:0,action_table_name:'CREDIT_CARD_BANK_PAYMENT_MONEY',action_table_dsn:'#dsn3#');	
</cfscript>
