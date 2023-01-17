<!--- Toplu Kredi Karti Tahsilatı Guncelleme Query--->
<cfif attributes.action_period_id neq session.ep.period_id>
	<script type="text/javascript">
		alert("<cf_get_lang_main no='1659.İşlem Yapmak İstediğiniz Muhasebe Dönemi ile Aktif Muhasebe Döneminiz Farklı Muhasebe Döneminizi Kontrol Ediniz'>!");
		window.location.href='<cfoutput>#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.list_creditcard_revenue</cfoutput>';
	</script>
	<cfabort>
</cfif>
<cfquery name="get_process_type" datasource="#dsn3#">
	SELECT 
		PROCESS_TYPE,
		IS_BUDGET,
		IS_ACCOUNT,
        IS_CARI,
		ACTION_FILE_NAME,
		ACTION_FILE_FROM_TEMPLATE,
		MULTI_TYPE
	FROM 
	 	SETUP_PROCESS_CAT 
	WHERE 
		PROCESS_CAT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.process_cat#">
</cfquery>
<cfscript>
	multi_type = get_process_type.MULTI_TYPE;
	process_type = get_process_type.process_type;
	is_account = get_process_type.is_account;
	is_cari = get_process_type.is_cari;
	for(r=1; r lte attributes.record_num; r=r+1)
	{
		if(evaluate('attributes.row_kontrol#r#') eq 1)
		{
			'attributes.system_amount#r#' = filterNum(attributes['system_amount#r#']);
			'attributes.amount#r#' = filterNum(attributes['amount#r#']);
			'attributes.commission_amount#r#' = filterNum(attributes['commission_amount#r#']);
			'attributes.other_amount#r#' = filterNum(attributes['other_amount#r#']);
		}
	}
	for(k=1; k lte attributes.kur_say; k=k+1)
	{
		'attributes.txt_rate2_#k#' = filterNum(attributes['txt_rate2_#k#'],session.ep.our_company_info.rate_round_num);
		'attributes.txt_rate1_#k#' = filterNum(attributes['txt_rate1_#k#'],session.ep.our_company_info.rate_round_num);
	}
	if(isdefined("attributes.branch_id") and len(attributes.branch_id))
		branch_id_info = attributes.branch_id;
	else
		branch_id_info = listgetat(session.ep.user_location,2,'-');
</cfscript>
<cf_date tarih='attributes.process_date'>
<cftransaction>
    <cfquery name="upd_creditcard_bank_payments_multi" datasource="#dsn3#">
        UPDATE
            CREDIT_CARD_BANK_PAYMENTS_MULTI
        SET				
            PROCESS_CAT = #attributes.process_cat#,
            ACTION_TYPE_ID = #process_type#,
            ACTION_DATE = #attributes.process_date#,
            ACC_BRANCH_ID = #branch_id_info#,
            UPDATE_EMP = #session.ep.userid#,
            UPDATE_IP = '#cgi.remote_addr#',
            UPDATE_DATE = #now()#,
            ACTION_PERIOD_ID = #session.ep.period_id#
        WHERE
            MULTI_ACTION_ID = #attributes.multi_id#		
    </cfquery>
    <cfscript>
		currency_multiplier = '';
		if(isDefined('attributes.kur_say') and len(attributes.kur_say))
			for(mon=1;mon lte attributes.kur_say;mon=mon+1)
			{
				if(evaluate("attributes.hidden_rd_money_#mon#") is session.ep.money2)
					currency_multiplier = evaluate('attributes.txt_rate2_#mon#/attributes.txt_rate1_#mon#');
			}
	</cfscript>
    
	<cfif isdefined("attributes.record_num") and len(attributes.record_num)>
    	<cfscript>	
			borc_hesap_list='';
			alacak_hesap_list='';
			borc_tutar_list ='';
			alacak_tutar_list = '';
			doviz_tutar_borc = '';
			doviz_tutar_alacak = '';
			doviz_currency_borc = '';
			doviz_currency_alacak = '';
			str_card_detail = ArrayNew(2); 
		</cfscript>
        <cfloop from="1" to="#attributes.record_num#" index="i">
            <cfif isdefined("attributes.row_kontrol#i#") and attributes["row_kontrol#i#"] EQ 1>
                <cf_date tarih="attributes.action_date#i#">
                <cf_date tarih="attributes.due_start_date#i#">
            	<cfquery name="GET_CREDIT_PAYMENT" datasource="#dsn3#"><!--- satirda seçilen ödeme yönteminin detay bilgileri --->
                    SELECT 
                        PAYMENT_TYPE_ID, 
                        ISNULL(NUMBER_OF_INSTALMENT,0) AS NUMBER_OF_INSTALMENT, 
                        P_TO_INSTALMENT_ACCOUNT,
                        ACCOUNT_CODE,
                        SERVICE_RATE,
                        PAYMENT_RATE,
                        PAYMENT_RATE_ACC,
                        IS_PESIN,
                        POS_TYPE
                    FROM 
                        CREDITCARD_PAYMENT_TYPE 
                    WHERE 
                        PAYMENT_TYPE_ID = #attributes["payment_type_id#i#"]#
                </cfquery>
                <cfif get_credit_payment.recordcount and len(get_credit_payment.p_to_instalment_account)>
					<cfset due_value_date = dateadd("d",get_credit_payment.p_to_instalment_account,attributes["due_start_date#i#"])>
                <cfelse>
                    <cfset due_value_date = attributes.due_start_date>
				</cfif> 
				<cfset due_start_date = attributes["due_start_date#i#"]>
            	
            	<cfset attributes.sales_credit_comm = attributes["amount#i#"]>						<!--- tutar --->
                <cfset attributes.sales_credit = attributes["commission_amount#i#"]>				<!--- komisyonlu tutar --->
                <cfset attributes.other_value_sales_credit = attributes["other_amount#i#"]>			<!--- dovizli tutar --->
                <cfset attributes.system_amount = attributes["system_amount#i#"]>	
                
                <cfset attributes.payment_type_id = attributes["payment_type_id#i#"]>
                <cfset attributes.account_id = attributes["account_id#i#"]>
                <cfset attributes.currency_id = attributes["currency_id#i#"]>
                <cfset attributes.action_date = attributes["action_date#i#"]>
                <cfset attributes.due_start_date = attributes["due_start_date#i#"]>
                
                <cfset attributes.action_from_company_id = attributes["action_company_id#i#"]>		<!--- satirdaki cari hesap --->
				<cfset attributes.par_id = attributes["action_par_id#i#"]>
                <cfset attributes.cons_id = attributes["action_consumer_id#i#"]>
                
                <cfset attributes.money_type = listfirst(attributes["money_id#i#"],';')>
                <cfset form.money_type = listfirst(attributes["money_id#i#"],';')>
                
                <cfset attributes.special_definition_id = attributes["special_definition_id#i#"]>
                <cfset attributes.revenue_collector_id = attributes["employee_id#i#"]>
                <cfset attributes.revenue_collector = attributes["employee_name#i#"]>
                <cfset attributes.paper_number = attributes["paper_number#i#"]>
                <cfset attributes.action_detail = ''>
                <cfset attributes.card_no =  ''>
				<cfset attributes.project_id = attributes["project_id#i#"]>
                <cfset attributes.project_name = attributes["project_name#i#"]>
				<cfset attributes.subscription_id = attributes["subscription_id#i#"]>
                <cfset attributes.subscription_no = attributes["subscription_no#i#"]>
                <cfset attributes.card_owner = attributes["card_owner#i#"]>
                <cfif len(attributes.action_from_company_id)>
					<cfset my_acc_result = get_company_period(attributes.action_from_company_id,session.ep.period_id,dsn3)>
                    <cfquery name="get_comp_name" datasource="#dsn3#">
                        SELECT FULLNAME,MEMBER_CODE FROM #dsn_alias#.COMPANY WHERE COMPANY_ID = #attributes.action_from_company_id#
                    </cfquery>
                    <cfset member_name_ = get_comp_name.FULLNAME>
                    <cfset member_code = get_comp_name.member_code>
                <cfelse>
                    <cfset my_acc_result = get_consumer_period(attributes.cons_id,session.ep.period_id,dsn3)>
                    <cfquery name="get_cons_name" datasource="#dsn3#">
                        SELECT CONSUMER_NAME + ' ' + CONSUMER_SURNAME FULLNAME,MEMBER_CODE FROM #dsn_alias#.CONSUMER WHERE CONSUMER_ID = #attributes.cons_id#
                    </cfquery>
                    <cfset member_name_ = get_cons_name.FULLNAME>
                    <cfset member_code = get_cons_name.member_code>
                </cfif>
                
                <cfscript>
					currency_multiplier_2 = '';
					currency_multiplier_other = '';//komisyonlarda dekont eklemek için
					
					if(isDefined('attributes.kur_say') and len(attributes.kur_say))
						for(mon=1;mon lte attributes.kur_say;mon=mon+1)
						{
							if(evaluate("attributes.hidden_rd_money_#mon#") is listfirst(evaluate("attributes.currency_id#i#"),';'))
								currency_multiplier_2 = evaluate('attributes.txt_rate2_#mon#/attributes.txt_rate1_#mon#');	
							if(evaluate("attributes.hidden_rd_money_#mon#") is listfirst(evaluate("attributes.money_id#i#"),';'))
								currency_multiplier_other = evaluate('attributes.txt_rate2_#mon#/attributes.txt_rate1_#mon#');
						}
				</cfscript>
                <cfif isdefined("attributes.id#i#") and len(attributes["id#i#"])>
                	<cfset attributes.cari_action_id = attributes["cari_action_id#i#"]>
                    <cfset attributes.id = attributes["id#i#"]>
                	<cfinclude template="upd_creditcard_revenue_ic.cfm">
                <cfelse>
                	<cfset wrk_id = dateformat(now(),'YYYYMMDD')&timeformat(now(),'HHmmss')&'_#session.ep.userid#_'&round(rand()*100)>
            		<cfinclude template="add_creditcard_revenue_ic.cfm"> 
                </cfif>
                <cfscript>
					//borc
					borc_hesap_list = listappend(borc_hesap_list,GET_CREDIT_PAYMENT.account_code,',');
					borc_tutar_list = listappend(borc_tutar_list,attributes.system_amount,',');
					doviz_tutar_borc = listappend(doviz_tutar_borc,attributes.sales_credit,',');
					doviz_currency_borc = listappend(doviz_currency_borc,attributes.currency_id,',');
					if(isDefined("attributes.ACTION_DETAIL") and len(attributes.ACTION_DETAIL))
						str_card_detail[1][listlen(borc_tutar_list)] = '#member_name_# - TOPLU KREDİ KARTI TAHSİLAT - #attributes.ACTION_DETAIL#';
					else
						str_card_detail[1][listlen(borc_tutar_list)] = '#member_name_# - TOPLU KREDİ KARTI TAHSİLAT'; 
					//alacak
					alacak_hesap_list = listappend(alacak_hesap_list,MY_ACC_RESULT,',');
					alacak_tutar_list = listappend(alacak_tutar_list,attributes.system_amount,',');
					doviz_tutar_alacak = listappend(doviz_tutar_alacak,attributes.other_value_sales_credit,',');
					doviz_currency_alacak  = listappend(doviz_currency_alacak,attributes.money_type,',');
					if(isDefined("attributes.ACTION_DETAIL") and len(attributes.ACTION_DETAIL))
						str_card_detail[2][listlen(alacak_tutar_list)] = '#member_name_# - TOPLU KREDİ KARTI TAHSİLAT - #attributes.ACTION_DETAIL#';
					else
						str_card_detail[2][listlen(alacak_tutar_list)] = '#member_name_# - TOPLU KREDİ KARTI TAHSİLAT';
				
				</cfscript>
			<cfelse>
				<cfif isdefined("attributes.id#i#") and len(attributes["id#i#"])>
					<cfquery name="del_payment" datasource="#dsn3#">
						DELETE FROM CREDIT_CARD_BANK_PAYMENTS WHERE CREDITCARD_PAYMENT_ID = #attributes["id#i#"]#
					</cfquery> 
					<cfset attributes.id=attributes["id#i#"]>
					<cfscript>
						if(form.old_process_type neq 241)
							cari_sil(action_id:attributes.id,process_type:attributes.old_process_type,cari_db:dsn3);
					</cfscript>
				</cfif>
			</cfif>
        </cfloop>
        <!--- toplu kredi karti tahsilat muhasebe islemi yapiliyor --->
        <cfscript>
			if (is_account eq 1)
			{
				fis_detail = 'TOPLU KREDİ KARTI TAHSİLAT';
				muhasebeci (
					action_id: attributes.multi_id,
					workcube_process_type: process_type,
					workcube_old_process_type:attributes.old_process_type,
					workcube_process_cat:form.process_cat,
					account_card_type: 13,
					islem_tarihi: attributes.ACTION_DATE,
					fis_satir_detay: str_card_detail,
					borc_hesaplar: borc_hesap_list,
					borc_tutarlar: borc_tutar_list,
					other_amount_borc : doviz_tutar_borc,
					other_currency_borc : doviz_currency_borc,
					alacak_hesaplar: alacak_hesap_list,
					alacak_tutarlar: alacak_tutar_list,
					other_amount_alacak : doviz_tutar_alacak,
					other_currency_alacak : doviz_currency_alacak,
					currency_multiplier : currency_multiplier,
					muhasebe_db : dsn3,
					fis_detay: fis_detail,
					to_branch_id : branch_id_info,
					belge_no : attributes.multi_id
				);
			}
			else
				 muhasebe_sil(action_id:attributes.multi_id,process_type:attributes.old_process_type,muhasebe_db:dsn3);
		</cfscript>
        <!--- Belge No update ediliyor --->
		<cfif not isdefined("attributes.id#attributes.record_num#")>
			<cfif Len(attributes.paper_number)>
                <cfquery name="UPD_GENERAL_PAPERS" datasource="#dsn3#">
                    UPDATE 
                        GENERAL_PAPERS
                    SET
                        CREDITCARD_REVENUE_NUMBER = #listlast(attributes.paper_number,'-')#
                    WHERE
                        CREDITCARD_REVENUE_NUMBER IS NOT NULL
                </cfquery>
            </cfif>
		</cfif>
    </cfif>
    <!--- belgeye ait para birimleri silinerek yeniden ekleniyor --->
    <cfquery name="del_action_money" datasource="#dsn3#">
        DELETE FROM CREDIT_CARD_BANK_PAYMENTS_MULTI_MONEY WHERE ACTION_ID = #attributes.multi_id#
    </cfquery>
    <cfloop from="1" to="#attributes.kur_say#" index="r">
        <cfquery name="add_action_money" datasource="#dsn3#">
            INSERT INTO 
                CREDIT_CARD_BANK_PAYMENTS_MULTI_MONEY 
                (
                    ACTION_ID,
                    MONEY_TYPE,
                    RATE2,
                    RATE1,
                    IS_SELECTED
                )
                VALUES
                (
                    #attributes.multi_id#,
                    '#wrk_eval("attributes.hidden_rd_money_#r#")#',
                    #attributes["txt_rate2_#r#"]#,
                    #attributes["txt_rate1_#r#"]#,
                    <cfif attributes["hidden_rd_money_#r#"] eq listfirst(attributes.rd_money,',')>1<cfelse>0</cfif>
                )
        </cfquery>
    </cfloop>
</cftransaction>
<script type="text/javascript">
	window.location.href='<cfoutput>#request.self#?fuseaction=#nextEvent##attributes.multi_id#</cfoutput>';
</script>