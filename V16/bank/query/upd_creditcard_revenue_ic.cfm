<cfif len(attributes.cari_action_id)>
    <cfquery name="DEL_CARI_ACTION" datasource="#dsn3#">
        DELETE FROM #dsn2_alias#.CARI_ACTIONS WHERE ACTION_ID = #attributes.cari_action_id#
    </cfquery>
    <cfquery name="DEL_CARI_ACTION_MONEY" datasource="#dsn3#">
        DELETE FROM #dsn2_alias#.CARI_ACTION_MONEY WHERE ACTION_ID = #attributes.cari_action_id#
    </cfquery>
    <cfif listfind('241,2410',attributes.old_process_type)><cfset process_type_info = 41><cfelse><cfset process_type_info = 42></cfif>
    <cfscript>
        cari_sil(action_id:attributes.cari_action_id,process_type:process_type_info,cari_db:dsn3);
        muhasebe_sil(action_id:attributes.cari_action_id,process_type:process_type_info,muhasebe_db:dsn3);
    </cfscript>
</cfif>
<cfif len(GET_CREDIT_PAYMENT.PAYMENT_RATE) and GET_CREDIT_PAYMENT.PAYMENT_RATE neq 0 and len(GET_CREDIT_PAYMENT.PAYMENT_RATE_ACC)><!--- ödeme yönteminde komisyon varsa hesap seçilmişse komisyon kadar dekont kaydedilr --->
    <cfset is_upd_info = 1>
    <cfinclude template="add_debit_from_cc_revenue.cfm">
<cfelse>
	<cfset GET_MAX_CH.ACTION_ID = ''>
</cfif>
<cfif len(GET_CREDIT_PAYMENT.SERVICE_RATE) and GET_CREDIT_PAYMENT.SERVICE_RATE neq 0>
    <!--- ödeme yöntemindeki seçilen banka komisyon oranına göre komisyonlar hesaplanır --->
    <cfset commission_multiplier_amount = wrk_round(attributes.sales_credit_comm * GET_CREDIT_PAYMENT.SERVICE_RATE /100)>
<cfelse>
    <cfset commission_multiplier_amount = 0>
</cfif>
<cfquery name="ADD_CREDIT_PAYMENT" datasource="#dsn3#">
    UPDATE
        CREDIT_CARD_BANK_PAYMENTS
    SET
        PROCESS_CAT = #attributes.process_cat#,
        ACTION_TYPE_ID = #process_type#,
        PAYMENT_TYPE_ID = #attributes.payment_type_id#,<!--- ödeme yöntemi --->
        NUMBER_OF_INSTALMENT = <cfif len(get_credit_payment.number_of_instalment)>#get_credit_payment.number_of_instalment#,<cfelse>NULL,</cfif><!--- ödeme yöntemi taksit sayısı --->
        ACTION_TO_ACCOUNT_ID = #attributes.account_id#,<!--- ödeme yöntmiyle seçilen hesap --->
        ACTION_CURRENCY_ID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.currency_id#">,<!--- hesap para birimi --->
        ACTION_FROM_COMPANY_ID = <cfif len(attributes.action_from_company_id)>#attributes.action_from_company_id#,<cfelse>NULL,</cfif>
        PARTNER_ID = <cfif len(attributes.par_id)>#attributes.par_id#,<cfelse>NULL,</cfif>
        CONSUMER_ID = <cfif len(attributes.cons_id)>#attributes.cons_id#,<cfelse>NULL,</cfif>
        STORE_REPORT_DATE = #attributes.action_date#,<!--- işlem tarihi --->
        DUE_START_DATE = #attributes.due_start_date#,<!--- vade baslangic tarihi --->
        SALES_CREDIT = #attributes.sales_credit#,<!--- işlem tutarı --->
        COMMISSION_AMOUNT = #commission_multiplier_amount#,<!--- ödeme yöntemindeki hizmet komisyon ORANIYLA yapılmış olan komsiyon tutarı--->
        OTHER_MONEY = <cfif len(money_type)><cfqueryparam cfsqltype="cf_sql_varchar" value="#money_type#">,<cfelse>NULL,</cfif>
        OTHER_CASH_ACT_VALUE = <cfif len(attributes.other_value_sales_credit)>#attributes.other_value_sales_credit#,<cfelse>null,</cfif>
        ACTION_DETAIL = <cfif len(attributes.action_detail)><cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.action_detail#">,<cfelse>NULL,</cfif>
        <cfif process_type eq 245>ACTION_TYPE = 'KREDİ KARTI TAHSİLAT İPTAL'<cfelseif process_type eq 2410>ACTION_TYPE = 'TOPLU KREDİ KARTI TAHSİLAT'<cfelse>ACTION_TYPE = 'KREDİ KARTI TAHSİLAT'</cfif>,
        <cfif is_account eq 1>IS_ACCOUNT = 1,IS_ACCOUNT_TYPE = 13,<cfelse>IS_ACCOUNT = 0,IS_ACCOUNT_TYPE = 13,</cfif>
        <cfif len(attributes.card_no)>CARD_NO = <cfqueryparam cfsqltype="cf_sql_varchar" value="#content#">,</cfif>										
        CARD_OWNER = <cfif len(attributes.card_owner)><cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.card_owner#">,<cfelse>NULL,</cfif>
        ACTION_PERIOD_ID = #session.ep.period_id#,
        CARI_ACTION_ID = <cfif isDefined("GET_MAX_CH.ACTION_ID") and len(GET_MAX_CH.ACTION_ID)>#GET_MAX_CH.ACTION_ID#,<cfelse>NULL,</cfif><!--- komisyondan kestiğimiz dekontun bilgisi --->
        CARI_ACTION_VALUE = <cfif isDefined("GET_MAX_CH.ACTION_ID") and len(GET_MAX_CH.ACTION_ID)>#wrk_round(attributes.sales_credit - attributes.sales_credit_comm)#,<cfelse>NULL,</cfif>
        PROJECT_ID = <cfif isdefined('attributes.project_id') and len(attributes.project_id) and isdefined('attributes.project_name') and len(attributes.project_name)>#attributes.project_id#,<cfelse>NULL,</cfif>
        PAPER_NO = <cfif isdefined("attributes.paper_number") and len(attributes.paper_number)><cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.paper_number#">,<cfelse>NULL,</cfif>
        REVENUE_COLLECTOR_ID = <cfif isdefined("attributes.revenue_collector_id") and len(attributes.revenue_collector_id) and len(attributes.revenue_collector)>#attributes.revenue_collector_id#,<cfelse>NULL,</cfif>
        TO_BRANCH_ID = #branch_id_info#,
        SPECIAL_DEFINITION_ID = <cfif isdefined("attributes.special_definition_id") and len(attributes.special_definition_id)>#attributes.special_definition_id#<cfelse>NULL</cfif>,
        ASSETP_ID = <cfif isdefined("attributes.asset_id") and len(attributes.asset_id) and len(attributes.asset_name)>#attributes.asset_id#<cfelse>NULL</cfif>,
        UPDATE_EMP = #session.ep.userid#,
        UPDATE_DATE = #now()#,
        UPDATE_IP = <cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.remote_addr#">,
        SUBSCRIPTION_ID = <cfif isdefined("attributes.subscription_id") and len(attributes.subscription_id) and len(attributes.subscription_no)>#attributes.subscription_id#<cfelse>NULL</cfif>,
        CANCEL_TYPE_ID = <cfif isdefined('attributes.cancel_type_id') and len(attributes.cancel_type_id) and process_type eq 245>#attributes.cancel_type_id#<cfelse>NULL</cfif>,
        MULTI_ACTION_ID = <cfif isdefined('attributes.multi_id')><cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.multi_id#"><cfelse>NULL</cfif>
    WHERE
        CREDITCARD_PAYMENT_ID = #attributes.id#
</cfquery>
<cfquery name="DEL_CARD_ROWS" datasource="#dsn3#">
    DELETE FROM CREDIT_CARD_BANK_PAYMENTS_ROWS WHERE CREDITCARD_PAYMENT_ID = #attributes.id#
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
        CREDITCARD_PAYMENT_ID = #attributes.id#
</cfquery>
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
	<cfset average_day = average_day+datediff("d",attributes.due_start_date,bank_action_date)>
    <cfquery name="ADD_CREDIT_CARD_BANK_PAYMENT_ROWS" datasource="#dsn3#">
        INSERT
        INTO
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
    if (is_cari eq 1)
    {
        average_due_date = dateadd("d",average_day,attributes.due_start_date);//ortalama vade tarihi taksitlere gore hesaplanir

        if (process_type eq 241 or process_type eq 2410)//kredi kartı tahsilat
        {
			if (process_type eq 241)
	        	islem_detay_ = 'KREDİ KARTI TAHSİLAT';
			else
				islem_detay_ = 'TOPLU KREDİ KARTI TAHSİLAT';	
				
            if(form.old_process_type neq 241)
                cari_sil(action_id:attributes.id,process_type:attributes.old_process_type,cari_db:dsn3);
				
            carici(
                action_id : attributes.id,
                action_table : 'CREDIT_CARD_BANK_PAYMENTS',
                workcube_process_type : process_type,
                workcube_old_process_type : form.old_process_type,
                process_cat : form.process_cat,	
                islem_tarihi : attributes.action_date,
                islem_belge_no : attributes.paper_number,
                due_date : average_due_date,
                to_account_id : attributes.account_id,
                islem_tutari : attributes.system_amount,
                action_currency : session.ep.money,
                other_money_value : iif(len(attributes.other_value_sales_credit),'attributes.other_value_sales_credit',de('')),
                other_money : form.money_type,
                currency_multiplier : currency_multiplier,
                islem_detay : attributes.action_type_info,
                action_detail : attributes.action_detail,
                islem_detay : islem_detay_,
                account_card_type : 13,
                cari_db : dsn3,
                subscription_id : iif((isdefined("attributes.subscription_id") and len(attributes.subscription_id) and len(attributes.subscription_no)),attributes.subscription_id,de('')),
                from_cmp_id : attributes.action_from_company_id,
                from_consumer_id : attributes.cons_id,
                project_id : iif((isdefined('attributes.project_id') and len(attributes.project_id) and len(attributes.project_name)),'attributes.project_id',de('')),
                to_branch_id : branch_id_info,
                special_definition_id : iif((isdefined("attributes.special_definition_id") and len(attributes.special_definition_id)),'attributes.special_definition_id',de('')),
                assetp_id : iif((isdefined("attributes.asset_id") and len(attributes.asset_id) and len(attributes.asset_name)),'attributes.asset_id',de('')),
                rate2:currency_multiplier_other
                );
        }
        else
        {
            if(form.old_process_type neq 245)
                cari_sil(action_id:attributes.id,process_type:attributes.old_process_type,cari_db:dsn3);
            carici(
                action_id : attributes.id,
                action_table : 'CREDIT_CARD_BANK_PAYMENTS',
                workcube_process_type : process_type,
                workcube_old_process_type : form.old_process_type,
                process_cat : form.process_cat,	
                islem_tarihi : attributes.action_date,
                islem_belge_no : attributes.paper_number,
                due_date : average_due_date,
                from_account_id : attributes.account_id,
                islem_tutari : attributes.system_amount,
                action_currency : session.ep.money,
                other_money_value : iif(len(attributes.other_value_sales_credit),'attributes.other_value_sales_credit',de('')),
                other_money : form.money_type,
                currency_multiplier : currency_multiplier,
                islem_detay : 'KREDİ KARTI TAHSİLAT İPTAL',
                action_detail : attributes.action_detail,
                account_card_type : 13,
                cari_db : dsn3,
                subscription_id : iif((isdefined("attributes.subscription_id") and len(attributes.subscription_id) and len(attributes.subscription_no)),attributes.subscription_id,de('')),
                to_cmp_id : attributes.action_from_company_id,
                to_consumer_id : attributes.cons_id,
                project_id : iif((isdefined('attributes.project_id') and len(attributes.project_id) and len(attributes.project_name)),attributes.project_id,de('')),
                from_branch_id : branch_id_info,
                special_definition_id : iif((isdefined("attributes.special_definition_id") and len(attributes.special_definition_id)),'attributes.special_definition_id',de('')),
                assetp_id : iif((isdefined("attributes.asset_id") and len(attributes.asset_id) and len(attributes.asset_name)),'attributes.asset_id',de('')),
                rate2:currency_multiplier_other
                );
        }
    }
    else
        cari_sil(action_id:attributes.id,process_type:attributes.old_process_type,cari_db:dsn3);
    
    if (is_account eq 1 and process_type neq 2410)
    {
       	if (process_type eq 241)//kredi kartı tahsilat
        {
            borc_hesap = GET_CREDIT_PAYMENT.account_code;
            alacak_hesap = MY_ACC_RESULT;
	        fis_detail = 'KREDİ KARTI TAHSİLAT';
            other_alacak_tutar = attributes.other_value_sales_credit;
            other_alacak_currceny = form.money_type;
            other_borc_tutar = attributes.sales_credit;
            other_borc_currency = attributes.currency_id;
        }
        else//kredi kartı tahsilat iptal
        {
            borc_hesap = MY_ACC_RESULT;
            alacak_hesap = GET_CREDIT_PAYMENT.account_code;
            fis_detail = 'KREDİ KARTI TAHSİLAT İPTAL';
            other_alacak_tutar = attributes.sales_credit;
            other_alacak_currceny = attributes.currency_id;
            other_borc_tutar = attributes.other_value_sales_credit;
            other_borc_currency = form.money_type;
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
            action_id: attributes.id,
            workcube_process_type: process_type,
            workcube_old_process_type:attributes.old_process_type,
            workcube_process_cat:form.process_cat,
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
            other_currency_alacak : other_alacak_currceny,
            currency_multiplier : currency_multiplier,
            muhasebe_db : dsn3,
            fis_detay: fis_detail,
            acc_project_id : iif((isdefined('attributes.project_id') and len(attributes.project_id) and len(attributes.project_name)),'attributes.project_id',de('')),
            to_branch_id : iif((process_type eq 241),branch_id_info,de('')),
            from_branch_id : iif((process_type eq 245),branch_id_info,de(''))
        );
    }
    else
        muhasebe_sil (action_id:attributes.id,process_type:attributes.old_process_type,muhasebe_db:dsn3);

    f_kur_ekle_action(action_id:attributes.id,process_type:1,action_table_name:'CREDIT_CARD_BANK_PAYMENT_MONEY',action_table_dsn:'#dsn3#');
</cfscript>
