<cfif form.active_period neq session.ep.period_id>
	<script type="text/javascript">
		alert("İşlem Yapmak İstediğiniz Muhasebe Dönemi ile Aktif Muhasebe Döneminiz Farklı Muhasebe Döneminizi Kontrol Ediniz!");
		wrk_opener_reload();
		window.close();
	</script>
	<cfabort>
</cfif>
<cf_get_lang_set module_name="cheque">
<cf_date tarih="attributes.PAYROLL_REVENUE_DATE">
<cf_date tarih='attributes.pyrll_avg_duedate'>
<cfquery name="get_process_type" datasource="#dsn3#">
	SELECT 
		PROCESS_TYPE,
		IS_ACCOUNT,
		IS_ACCOUNT_GROUP,
		IS_CHEQUE_BASED_ACTION,
		ACTION_FILE_NAME,
		ACTION_FILE_FROM_TEMPLATE
	 FROM 
	 	SETUP_PROCESS_CAT 
	WHERE 
		PROCESS_CAT_ID = #form.process_cat#
</cfquery>
<cfscript>
	process_type = get_process_type.PROCESS_TYPE;
	is_account = get_process_type.IS_ACCOUNT;
	is_account_group = get_process_type.IS_ACCOUNT_GROUP;
	is_voucher_based = get_process_type.IS_CHEQUE_BASED_ACTION;
	attributes.payroll_total = filterNum(attributes.payroll_total);
	attributes.other_payroll_total = filterNum(attributes.other_payroll_total);
	attributes.masraf = filterNum(attributes.masraf);
	for(ff=1; ff lte attributes.record_num; ff=ff+1)
	{
		if (evaluate("attributes.row_kontrol#ff#"))
		{
			'attributes.voucher_system_currency_value#ff#' = filterNum(evaluate("attributes.voucher_system_currency_value#ff#"));
			'attributes.voucher_value#ff#' = filterNum(evaluate("attributes.voucher_value#ff#"));
		}
	}
	for(rt = 1; rt lte attributes.kur_say; rt = rt + 1)
	{
		'attributes.txt_rate1_#rt#' = filterNum(evaluate('attributes.txt_rate1_#rt#'),session.ep.our_company_info.rate_round_num);
		'attributes.txt_rate2_#rt#' = filterNum(evaluate('attributes.txt_rate2_#rt#'),session.ep.our_company_info.rate_round_num);
	}
	if (isdefined("attributes.cash_id"))
		branch_id_info = ListGetAt(attributes.cash_id,2,";");
	else if(isdefined("attributes.branch_id") and len(attributes.branch_id))
		branch_id_info = attributes.branch_id;
	else
		branch_id_info = listgetat(session.ep.user_location,2,'-');
</cfscript>
<cfquery name="CONTROL_NO" datasource="#DSN2#">
	SELECT 
		ACTION_ID 
	FROM 
		VOUCHER_PAYROLL 
	WHERE 
		PAYROLL_NO = <cfqueryparam cfsqltype="cf_sql_varchar" value="#PAYROLL_NO#"> AND
		ACTION_ID<>#attributes.ID#
</cfquery>
<cfif CONTROL_NO.RECORDCOUNT>
	<script type="text/javascript">
		alert("<cf_get_lang no='125.Aynı Bordro No lu Kayıt Var !'>");
		history.back();
	</script>
	<cfabort>
</cfif>
<cflock name="#createUUID()#" timeout="60">	
	<cftransaction>
		<!--- update payroll--->
		<cfquery name="UPD_PAYROLL" datasource="#dsn2#">
			UPDATE 
				VOUCHER_PAYROLL
			SET
				PROCESS_CAT=#form.process_cat#,
				PAYROLL_TYPE=#process_type#,
				PAYROLL_ACCOUNT_ID=#attributes.account_id#,
				PAYROLL_REV_MEMBER=#EMPLOYEE_ID#,
				PAYROLL_TOTAL_VALUE=#attributes.payroll_total#,
				PAYROLL_OTHER_MONEY=<cfif isdefined("attributes.basket_money") and len(attributes.basket_money)><cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.basket_money#">,<cfelse>NULL,</cfif>
				PAYROLL_OTHER_MONEY_VALUE=<cfif isdefined("attributes.other_payroll_total") and len(attributes.other_payroll_total)>#attributes.other_payroll_total#,<cfelse>NULL,</cfif>
				PAYROLL_REVENUE_DATE=#attributes.PAYROLL_REVENUE_DATE#,
				NUMBER_OF_VOUCHER=#attributes.voucher_num#,
				PAYROLL_AVG_DUEDATE=#attributes.pyrll_avg_duedate#,
				PAYROLL_AVG_AGE=<cfif len(attributes.pyrll_avg_age)>#attributes.pyrll_avg_age#,<cfelse>NULL,</cfif>
				<cfif len(attributes.PAYROLL_NO) >PAYROLL_NO= <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.PAYROLL_NO#">,</cfif>
				MASRAF=<cfif attributes.masraf gt 0>#attributes.masraf#<cfelse>0</cfif>,
				EXP_CENTER_ID = <cfif isdefined("attributes.expense_center") and len(attributes.expense_center)>#attributes.expense_center#<cfelse>NULL</cfif>,
				EXP_ITEM_ID = <cfif isdefined("attributes.exp_item_id") and len(attributes.exp_item_id) and len(attributes.exp_item_name)>#attributes.exp_item_id#<cfelse>NULL</cfif>,
				MASRAF_CURRENCY = <cfif len(attributes.masraf_currency)><cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.masraf_currency#"><cfelse>NULL</cfif>,
				UPDATE_EMP=#session.ep.userid#,
				UPDATE_IP = <cfqueryparam cfsqltype="cf_sql_varchar" value="#CGI.REMOTE_ADDR#">,
				UPDATE_DATE=#NOW()#,
				VOUCHER_BASED_ACC_CARI = <cfif len(is_voucher_based)>#is_voucher_based#<cfelse>0</cfif>,
				ACTION_DETAIL = <cfif isDefined("attributes.action_detail") and len(attributes.action_detail)><cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.action_detail#"><cfelse>NULL</cfif>,
				BRANCH_ID = #branch_id_info#
			WHERE
				ACTION_ID=#attributes.ID#
		</cfquery>
		<!--- update voucher --->
		<cfquery name="GET_REL_VOUCHERS" datasource="#dsn2#">
			SELECT VOUCHER_ID FROM VOUCHER_HISTORY WHERE PAYROLL_ID=#attributes.ID#
		</cfquery>
		<cfset old_voucher_list=valuelist(get_rel_vouchers.VOUCHER_ID)>
		<cfset ches=valuelist(get_rel_vouchers.VOUCHER_ID)>
		<cfloop list="#ches#" index="i">
			<cfset ctr=0>
			<cfloop from="1" to="#attributes.record_num#" index="k">
				<cfif i eq evaluate("attributes.voucher_id#k#") and evaluate("attributes.row_kontrol#k#")>
					<cfset ctr=1>
				</cfif>
			</cfloop>
			<cfif ctr eq 0>
				<!---çek tahsil bordrosundan çikarilmis,portföyde durumuna geri dönecek--->
				<cfquery name="GET_VOUCHER_STATUS" datasource="#dsn2#">
					SELECT VOUCHER_STATUS_ID FROM VOUCHER WHERE VOUCHER_ID=#i#
				</cfquery>
				<cfif GET_VOUCHER_STATUS.VOUCHER_STATUS_ID eq 2><!--- bankada icin --->
					<cfquery name="UPD_VOUCHER" datasource="#dsn2#">
						UPDATE VOUCHER SET VOUCHER_STATUS_ID=1 WHERE VOUCHER_ID=#i#
					</cfquery>
					<cfquery name="DEL_VCH_HIST" datasource="#dsn2#">
						DELETE FROM	VOUCHER_HISTORY WHERE VOUCHER_ID=#i# AND PAYROLL_ID=#attributes.ID#
					</cfquery>
				</cfif>
			</cfif>
		</cfloop>
		<cfloop from="1" to="#attributes.record_num#" index="i">
			<cfif evaluate("attributes.row_kontrol#i#")>
				<cfset ctr=0>
				<cfloop list="#ches#" index="k">
					<cfif k eq evaluate("attributes.voucher_id#i#")>
						<cfset ctr=1>
					</cfif>
				</cfloop>
				<cfif ctr eq 0>
					<cfquery name="UPD_VOUCHERS" datasource="#dsn2#">
						UPDATE
							VOUCHER
						SET 
							VOUCHER_STATUS_ID=2,
							OTHER_MONEY_VALUE= <cfif len(evaluate("attributes.voucher_system_currency_value#i#"))>#evaluate("attributes.voucher_system_currency_value#i#")#,<cfelse>NULL,</cfif>
							OTHER_MONEY= <cfif len(evaluate("attributes.system_money_info#i#"))><cfqueryparam cfsqltype="cf_sql_varchar" value='#wrk_eval("attributes.system_money_info#i#")#'>,<cfelse>NULL,</cfif>
							OTHER_MONEY_VALUE2= <cfif len(evaluate("attributes.other_money_value2#i#"))>#evaluate("attributes.other_money_value2#i#")#,<cfelse>NULL,</cfif>
							OTHER_MONEY2= <cfif len(evaluate("attributes.other_money2#i#"))><cfqueryparam cfsqltype="cf_sql_varchar" value='#wrk_eval("attributes.other_money2#i#")#'><cfelse>NULL</cfif>
						WHERE
							VOUCHER_ID= #evaluate("attributes.voucher_id#i#")#
					</cfquery>
					<cfquery name="ADD_VOUCHER_HISTORY" datasource="#dsn2#">
						INSERT INTO
							VOUCHER_HISTORY
								(
									VOUCHER_ID,
									PAYROLL_ID,
									STATUS,
									ACT_DATE,
									OTHER_MONEY_VALUE,
									OTHER_MONEY,
									OTHER_MONEY_VALUE2,
									OTHER_MONEY2,
									RECORD_DATE
								)
							VALUES
								(
									#evaluate("attributes.voucher_id#i#")#,
									#attributes.ID#,
									2,
									#attributes.PAYROLL_REVENUE_DATE#,
									<cfif len(evaluate("attributes.voucher_system_currency_value#i#"))>#evaluate("attributes.voucher_system_currency_value#i#")#,<cfelse>NULL,</cfif>
									<cfif len(evaluate("attributes.system_money_info#i#"))><cfqueryparam cfsqltype="cf_sql_varchar" value='#wrk_eval("attributes.system_money_info#i#")#'>,<cfelse>NULL,</cfif>
									<cfif len(evaluate("attributes.other_money_value2#i#"))>#evaluate("attributes.other_money_value2#i#")#,<cfelse>NULL,</cfif>
									<cfif len(evaluate("attributes.other_money2#i#"))><cfqueryparam cfsqltype="cf_sql_varchar" value='#wrk_eval("attributes.other_money2#i#")#'>,<cfelse>NULL,</cfif>
									#NOW()#
								)
					</cfquery>
				<cfelse>
					<cfquery name="UPD_VOUCHERS" datasource="#dsn2#">
						UPDATE
							VOUCHER_HISTORY
						SET 
							ACT_DATE = #attributes.PAYROLL_REVENUE_DATE#,
							OTHER_MONEY_VALUE= <cfif len(evaluate("attributes.voucher_system_currency_value#i#"))>#evaluate("attributes.voucher_system_currency_value#i#")#,<cfelse>NULL,</cfif>
							OTHER_MONEY= <cfif len(evaluate("attributes.system_money_info#i#"))><cfqueryparam cfsqltype="cf_sql_varchar" value='#wrk_eval("attributes.system_money_info#i#")#'>,<cfelse>NULL,</cfif>
							OTHER_MONEY_VALUE2= <cfif len(evaluate("attributes.other_money_value2#i#"))>#evaluate("attributes.other_money_value2#i#")#,<cfelse>NULL,</cfif>
							OTHER_MONEY2= <cfif len(evaluate("attributes.other_money2#i#"))><cfqueryparam cfsqltype="cf_sql_varchar" value='#wrk_eval("attributes.other_money2#i#")#'><cfelse>NULL</cfif>
						WHERE
							VOUCHER_ID= #evaluate("attributes.voucher_id#i#")# AND
							PAYROLL_ID=#attributes.ID#
					</cfquery>
				</cfif>
			</cfif>
		</cfloop>
		<cfquery name="GET_PAYROLL" datasource="#dsn2#">
			SELECT 
				*
			FROM
				VOUCHER_PAYROLL
			WHERE
				ACTION_ID=#attributes.ID#
		</cfquery>
		<cfquery name="GET_VOUCHERS_LAST" datasource="#dsn2#">
			SELECT 
				VOUCHER.* 
			FROM
				VOUCHER, 
				VOUCHER_HISTORY 
			WHERE
				VOUCHER.VOUCHER_ID=VOUCHER_HISTORY.VOUCHER_ID
				AND PAYROLL_ID=#attributes.ID#
		</cfquery>
		<cfset last_voucher_list = valuelist(GET_VOUCHERS_LAST.VOUCHER_NO)>
		<cfset ches_2 = old_voucher_list>
		<cfscript>
			butce_sil(action_id:attributes.ID,process_type:form.old_process_type);
			currency_multiplier = '';//sistem ikinci para biriminin kurunu sayfadan alıyor
			acc_currency_rate = '';
			masraf_curr_multiplier = '';
			if(isDefined('attributes.kur_say') and len(attributes.kur_say))
				for(mon=1;mon lte attributes.kur_say;mon=mon+1)
				{
					if(evaluate("attributes.hidden_rd_money_#mon#") is session.ep.money2)
						currency_multiplier = evaluate('attributes.txt_rate2_#mon#/attributes.txt_rate1_#mon#');
					if(evaluate("attributes.hidden_rd_money_#mon#") is attributes.masraf_currency)
						masraf_curr_multiplier = evaluate('attributes.txt_rate2_#mon#/attributes.txt_rate1_#mon#');	
					if (evaluate("attributes.hidden_rd_money_#mon#") is attributes.currency_id)
						acc_currency_rate = evaluate('attributes.txt_rate2_#mon#/attributes.txt_rate1_#mon#');
					if (evaluate("attributes.hidden_rd_money_#mon#") is attributes.rd_money)
						dovizli_islem_multiplier = evaluate('attributes.txt_rate2_#mon#/attributes.txt_rate1_#mon#');
				}
			if(len(attributes.exp_item_id) and len(attributes.exp_item_name) and (attributes.masraf gt 0) and len(attributes.expense_center))
			{
				butceci(
					action_id : attributes.id,
					muhasebe_db : dsn2,
					is_income_expense : false,
					process_type : process_type,
					nettotal : wrk_round(attributes.masraf*masraf_curr_multiplier),
					other_money_value : attributes.masraf,
					action_currency : attributes.masraf_currency,
					currency_multiplier : currency_multiplier,
					expense_date : attributes.PAYROLL_REVENUE_DATE,
					expense_center_id : attributes.expense_center,
					expense_item_id : attributes.exp_item_id,
					detail : 'SENET ÇIKIŞ -BANKA TAHSİL MASRAFI',
					paper_no : form.payroll_no,
					branch_id : branch_id_info,
					insert_type : 1//banka vs den eklenen masraflar için farklı ekleme metodu tanımlar
				);
				GET_EXP_ACC = cfquery(datasource : "#dsn2#", sqlstring : "SELECT ACCOUNT_CODE FROM EXPENSE_ITEMS WHERE EXPENSE_ITEM_ID = #attributes.exp_item_id#");
			}
		</cfscript>
		<cfif is_account eq 1>
       		<cfif session.ep.our_company_info.is_edefter eq 0>	<!--- standart muhasebe islemleri yapılıyor --->
            	<cfscript>
					//varsa butce mahsup kaydi silinmeli
					muhasebe_sil(action_id:attributes.id,action_table:'VOUCHER_PAYROLL',process_type:form.old_process_type);
				</cfscript>
				<cfset alacakli_hesaplar = ''>
                <cfset alacakli_tutarlar = ''>
                <cfset other_amount_alacak_list = ''>
                <cfset other_currency_alacak_list = ''>
                <cfset borclu_hesaplar = ''>
                <cfset borclu_tutarlar = ''>
                <cfset other_amount_borc_list=''>
                <cfset  other_currency_borc_list=''>
                <cfquery name="GET_ACC_CODE" datasource="#dsn2#">
                    SELECT VOUCHER_EXCHANGE_CODE FROM #dsn3_alias#.ACCOUNTS WHERE ACCOUNT_ID=#attributes.account_id#
                </cfquery>		
                <cfset acc=get_acc_code.VOUCHER_EXCHANGE_CODE>
                <cfloop from="1" to="#attributes.record_num#" index="i">
                    <cfif evaluate("attributes.row_kontrol#i#")>
                        <cfif evaluate("attributes.currency_id#i#") is session.ep.money>
                            <cfset alacakli_tutarlar=listappend(alacakli_tutarlar,evaluate("attributes.voucher_value#i#"),',')>
                        <cfelse>
                            <cfset alacakli_tutarlar=listappend(alacakli_tutarlar,evaluate("attributes.voucher_system_currency_value#i#"),',')>
                        </cfif>
                        <cfset other_amount_alacak_list = listappend(other_amount_alacak_list,evaluate("attributes.voucher_value#i#"),',')>
                        <cfset other_currency_alacak_list = listappend(other_currency_alacak_list,attributes.currency_id,',')>
                        <cfif listfind('1,2,3,9',evaluate("attributes.voucher_status_id#i#"),',')>
                            <cfquery name="GET_VOUCHER_ACC_CODE" datasource="#dsn2#">
                                SELECT
                                    C.A_VOUCHER_ACC_CODE
                                FROM
                                    VOUCHER_PAYROLL AS VP,
                                    VOUCHER_HISTORY AS VH,
                                    CASH AS C
                                WHERE
                                    VP.TRANSFER_CASH_ID = C.CASH_ID AND
                                    VP.PAYROLL_TYPE IN(137) AND
                                    VP.ACTION_ID= VH.PAYROLL_ID AND
                                    VH.VOUCHER_ID=#evaluate("attributes.voucher_id#i#")#
                            </cfquery>
                            <cfif GET_VOUCHER_ACC_CODE.recordcount eq 0>
                                <cfquery name="GET_VOUCHER_ACC_CODE" datasource="#dsn2#">
                                    SELECT
                                        C.A_VOUCHER_ACC_CODE
                                    FROM
                                        VOUCHER_PAYROLL AS VP,
                                        VOUCHER_HISTORY AS VH,
                                        CASH AS C
                                    WHERE
                                        VP.PAYROLL_CASH_ID = C.CASH_ID AND
                                        (VP.PAYROLL_TYPE=97 OR (VP.PAYROLL_TYPE=107 AND VP.PAYROLL_NO='-1') OR VP.PAYROLL_TYPE = 109) AND
                                        VP.ACTION_ID= VH.PAYROLL_ID AND
                                        VH.VOUCHER_ID=#evaluate("attributes.voucher_id#i#")#
                                </cfquery>
                            </cfif>
                            <cfset alacakli_hesaplar=listappend(alacakli_hesaplar, GET_VOUCHER_ACC_CODE.A_VOUCHER_ACC_CODE, ',')>
                        </cfif>
                        <cfscript>
                            if (is_account_group neq 1)
                            {
                                 if(isDefined("attributes.action_detail") and len(attributes.action_detail))
                                    str_card_detail[2][listlen(alacakli_tutarlar)] = ' #evaluate("attributes.voucher_no#i#")# - #attributes.action_detail#';
                                else
                                    str_card_detail[2][listlen(alacakli_tutarlar)] = ' #evaluate("attributes.voucher_no#i#")# - SENET BANKA ÇIKIŞ İŞLEMİ';
                            }
                            else
                            {
                                if (isDefined("attributes.action_detail") and len(attributes.action_detail))
                                    str_card_detail[2][listlen(alacakli_tutarlar)] = ' #attributes.action_detail#';
                                else
                                    str_card_detail[2][listlen(alacakli_tutarlar)] = ' SENET BANKA ÇIKIŞ İŞLEMİ';
                            }
                        </cfscript>
                    </cfif>
                </cfloop>
                <cfscript>
                    borclu_hesaplar=listappend(borclu_hesaplar,acc,',');
                    borclu_tutarlar=listappend(borclu_tutarlar,attributes.payroll_total,',');
                    other_amount_borc_list = listappend(other_amount_borc_list,wrk_round(attributes.payroll_total/acc_currency_rate),',');
                    other_currency_borc_list = listappend(other_currency_borc_list,attributes.currency_id,',');
                    if(isDefined("attributes.action_detail") and len(attributes.action_detail))
                        str_card_detail[1][1] = ' #attributes.action_detail#';
                    else
                        str_card_detail[1][1] = ' SENET BANKA ÇIKIŞ İŞLEMİ';
                    
                    if(len(attributes.exp_item_id) and len(attributes.exp_item_name) and isdefined("attributes.masraf") and (attributes.masraf gt 0) and len(attributes.expense_center))
                    { 
                        borclu_hesaplar = listappend(borclu_hesaplar,GET_EXP_ACC.ACCOUNT_CODE,',');
                        borclu_tutarlar = listappend(borclu_tutarlar,attributes.sistem_masraf_tutari,',');
                        other_amount_borc_list = listappend(other_amount_borc_list,attributes.masraf,',');
                        other_currency_borc_list = listappend(other_currency_borc_list,attributes.masraf_currency,',');
                        alacakli_hesaplar = listappend(alacakli_hesaplar,acc, ',');
                        alacakli_tutarlar = listappend(alacakli_tutarlar,attributes.sistem_masraf_tutari,',');
                        other_amount_alacak_list = listappend(other_amount_alacak_list,attributes.masraf,',');
                        other_currency_alacak_list = listappend(other_currency_alacak_list,attributes.masraf_currency,',');
                        if(isDefined("attributes.action_detail") and len(attributes.action_detail))
                        {
                            str_card_detail[2][listlen(alacakli_tutarlar)] = ' #attributes.action_detail#';
                            str_card_detail[1][2] = ' #attributes.action_detail#';
                        }
                        else
                        {
                            str_card_detail[2][listlen(alacakli_tutarlar)] = ' SENET BANKA ÇIKIŞ İŞLEMİ';
                            str_card_detail[1][2] = ' SENET BANKA ÇIKIŞ İŞLEMİ';
                        }
                    }
                    muhasebeci (
                        action_id:attributes.id,
                        workcube_process_type:process_type,
                        workcube_old_process_type:form.old_process_type,
                        account_card_type:13,
                        action_table :'VOUCHER_PAYROLL',
                        islem_tarihi: attributes.PAYROLL_REVENUE_DATE,
                        borc_hesaplar: borclu_hesaplar,
                        borc_tutarlar: borclu_tutarlar,
                        other_amount_borc: other_amount_borc_list,
                        other_currency_borc: other_currency_borc_list,
                        alacak_hesaplar: alacakli_hesaplar,
                        alacak_tutarlar: alacakli_tutarlar,
                        other_amount_alacak: other_amount_alacak_list,
                        other_currency_alacak: other_currency_alacak_list,
                        currency_multiplier : currency_multiplier,
                        fis_detay : 'SENET BANKA ÇIKIŞ İŞLEMİ',
                        fis_satir_detay : str_card_detail,
                        belge_no : form.payroll_no,
                        from_branch_id : branch_id_info,
                        workcube_process_cat : form.process_cat,
                        is_account_group : is_account_group
                    );
                </cfscript>
        	<cfelse>		<!--- e-deftere uygun muhasebe islemi yapiliyor --->
            	<cfscript>
					// tum muhasebe kayıtlari silinir sonra yaniden eklenir.
					muhasebe_sil(action_id:attributes.id,action_table:'VOUCHER_PAYROLL',process_type:form.old_process_type);
				</cfscript>
            	<cfset alacakli_hesaplar = ''>
                <cfset alacakli_tutarlar = ''>
                <cfset project_id = ''>
                <cfquery name="GET_ACC_CODE" datasource="#dsn2#">
                    SELECT VOUCHER_EXCHANGE_CODE FROM #dsn3_alias#.ACCOUNTS WHERE ACCOUNT_ID=#attributes.account_id#
                </cfquery>		
                <cfset acc=get_acc_code.VOUCHER_EXCHANGE_CODE>
                <cfloop from="1" to="#attributes.record_num#" index="i">
                    <cfif evaluate("attributes.row_kontrol#i#")>
                        <cfif evaluate("attributes.currency_id#i#") is session.ep.money>
                            <cfset alacakli_tutarlar = evaluate("attributes.voucher_value#i#")>
                        <cfelse>
                            <cfset alacakli_tutarlar = evaluate("attributes.voucher_system_currency_value#i#")>
                        </cfif>
                        <cfif listfind('1,2,3,9',evaluate("attributes.voucher_status_id#i#"),',')>
                            <cfquery name="GET_VOUCHER_ACC_CODE" datasource="#dsn2#">
                                SELECT
                                    C.A_VOUCHER_ACC_CODE,
                                    VP.PROJECT_ID
                                FROM
                                    VOUCHER_PAYROLL AS VP,
                                    VOUCHER_HISTORY AS VH,
                                    CASH AS C
                                WHERE
                                    VP.TRANSFER_CASH_ID = C.CASH_ID AND
                                    VP.PAYROLL_TYPE IN(137) AND
                                    VP.ACTION_ID= VH.PAYROLL_ID AND
                                    VH.VOUCHER_ID=#evaluate("attributes.voucher_id#i#")#
                            </cfquery>
                            <cfif GET_VOUCHER_ACC_CODE.recordcount eq 0>
                                <cfquery name="GET_VOUCHER_ACC_CODE" datasource="#dsn2#">
                                    SELECT
                                        C.A_VOUCHER_ACC_CODE,
                                        VP.PROJECT_ID
                                    FROM
                                        VOUCHER_PAYROLL AS VP,
                                        VOUCHER_HISTORY AS VH,
                                        CASH AS C
                                    WHERE
                                        VP.PAYROLL_CASH_ID = C.CASH_ID AND
                                        (VP.PAYROLL_TYPE=97 OR (VP.PAYROLL_TYPE=107 AND VP.PAYROLL_NO='-1') OR VP.PAYROLL_TYPE = 109) AND
                                        VP.ACTION_ID= VH.PAYROLL_ID AND
                                        VH.VOUCHER_ID=#evaluate("attributes.voucher_id#i#")#
                                </cfquery>
                            </cfif>
                            <cfset alacakli_hesaplar = GET_VOUCHER_ACC_CODE.A_VOUCHER_ACC_CODE>
                            <cfset project_id = GET_VOUCHER_ACC_CODE.PROJECT_ID>
                        </cfif>
                        <cfscript>
                            if (is_account_group neq 1)
                            {
                                 if(isDefined("attributes.action_detail") and len(attributes.action_detail))
                                    str_card_detail[2][1] = ' #evaluate("attributes.voucher_no#i#")# - #attributes.action_detail#';
                                else
                                    str_card_detail[2][1] = ' #evaluate("attributes.voucher_no#i#")# - SENET BANKA ÇIKIŞ İŞLEMİ';
                            }
                            else
                            {
                                if (isDefined("attributes.action_detail") and len(attributes.action_detail))
                                    str_card_detail[2][1] = ' #attributes.action_detail#';
                                else
                                    str_card_detail[2][1] = ' SENET BANKA ÇIKIŞ İŞLEMİ';
                            }
							if(isDefined("attributes.action_detail") and len(attributes.action_detail))
								str_card_detail[1][1] = ' #attributes.action_detail#';
							else
								str_card_detail[1][1] = ' SENET BANKA ÇIKIŞ İŞLEMİ';
							muhasebeci (
								action_id:attributes.id,
								action_row_id : evaluate("attributes.VOUCHER_ID#i#"),
								due_date :iif(len(evaluate("attributes.VOUCHER_DUEDATE#i#")),'createodbcdatetime(evaluate("attributes.VOUCHER_DUEDATE#i#"))','attributes.pyrll_avg_duedate'),
								workcube_process_type:process_type,
								workcube_process_type:process_type,
								workcube_old_process_type:form.old_process_type,
								account_card_type:13,
								action_table :'VOUCHER_PAYROLL',
								islem_tarihi: attributes.PAYROLL_REVENUE_DATE,
								borc_hesaplar: acc,
								borc_tutarlar: alacakli_tutarlar,
								other_amount_borc: wrk_round(evaluate("attributes.voucher_system_currency_value#i#")/acc_currency_rate),
								other_currency_borc: attributes.currency_id,
								alacak_hesaplar: alacakli_hesaplar,
								alacak_tutarlar: alacakli_tutarlar,
								other_amount_alacak: evaluate("attributes.voucher_value#i#"),
								other_currency_alacak: attributes.currency_id,
								currency_multiplier : currency_multiplier,
								fis_detay : 'SENET BANKA ÇIKIŞ İŞLEMİ',
								fis_satir_detay : str_card_detail,
								belge_no : evaluate("attributes.voucher_no#i#"),
								from_branch_id : branch_id_info,
								workcube_process_cat : form.process_cat,
								is_account_group : is_account_group,
								acc_project_id : project_id
							);
                        </cfscript>
                    </cfif>
                </cfloop>
                <!--- butce kaydi mahsup --->
                <cfscript>
                    if(len(attributes.exp_item_id) and len(attributes.exp_item_name) and isdefined("attributes.masraf") and (attributes.masraf gt 0) and len(attributes.expense_center))
                    { 
                        if(isDefined("attributes.action_detail") and len(attributes.action_detail))
                        {
                            str_card_detail[2][1] = ' #attributes.action_detail#';
                            str_card_detail[1][2] = ' #attributes.action_detail#';
                        }
                        else
                        {
                            str_card_detail[2][1] = ' SENET BANKA ÇIKIŞ MASRAFI';
                            str_card_detail[1][2] = ' SENET BANKA ÇIKIŞ MASRAFI';
                        }
						muhasebeci (
							action_id:attributes.id,
							workcube_process_type:process_type,
							workcube_old_process_type:form.old_process_type,
							account_card_type:13,
							action_table :'VOUCHER_PAYROLL',
							islem_tarihi: attributes.PAYROLL_REVENUE_DATE,
							borc_hesaplar: GET_EXP_ACC.ACCOUNT_CODE,
							borc_tutarlar: attributes.sistem_masraf_tutari,
							other_amount_borc: attributes.masraf,
							other_currency_borc: attributes.masraf_currency,
							alacak_hesaplar: acc,
							alacak_tutarlar: attributes.sistem_masraf_tutari,
							other_amount_alacak: attributes.masraf,
							other_currency_alacak: attributes.masraf_currency,
							currency_multiplier : currency_multiplier,
							fis_detay : 'SENET BANKA ÇIKIŞ MASRAFI',
							fis_satir_detay : str_card_detail,
							belge_no : form.payroll_no,
							from_branch_id : branch_id_info,
							workcube_process_cat : form.process_cat
						);
                    }	
                </cfscript>
            </cfif>
		<cfelse>
			<cfscript>
				muhasebe_sil(action_id:attributes.id,action_table:'VOUCHER_PAYROLL',process_type:form.old_process_type);
			</cfscript>
		</cfif>
		<!--- eger masraf tutarı girilmiş ise ve gider kalemi seçili ise bankaya ait kayıt oluşturur --->
		<cfset is_upd_action = 1>
		<cfif len(attributes.exp_item_id) and len(attributes.exp_item_name) and (attributes.masraf gt 0) and len(attributes.expense_center)>
			<cfinclude template="add_voucher_bank_masraf.cfm">
		<cfelse>
			<cfquery name="DEL_BANK_ACTIONS" datasource="#dsn2#">
				DELETE FROM BANK_ACTIONS WHERE VOUCHER_PAYROLL_ID = #attributes.ID#
			</cfquery>
		</cfif> 
		<cfscript>basket_kur_ekle(action_id:attributes.id,table_type_id:12,process_type:1);</cfscript>	
		<cf_workcube_process_cat 
			process_cat="#form.process_cat#"
			old_process_cat_id = "#attributes.old_process_cat_id#"
			action_id = #attributes.id#
			is_action_file = 1
			action_db_type = '#dsn2#'
			action_page='#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.form_add_voucher_payroll_bank_tah&event=upd&ID=#attributes.ID#'
			action_file_name='#get_process_type.action_file_name#'
			is_template_action_file = '#get_process_type.action_file_from_template#'>
            <cf_add_log employee_id="#session.ep.userid#" log_type="0" action_id="#attributes.id#" action_name= "#form.payroll_no# Güncellendi" paper_no= "#form.payroll_no#" period_id="#session.ep.period_id#" process_type="#get_process_type.PROCESS_TYPE#" data_source="#dsn2#">
	</cftransaction>
</cflock> 
<script type="text/javascript">
	window.location.href="<cfoutput>#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.form_add_voucher_payroll_bank_tah&event=upd&ID=#attributes.ID#</cfoutput>";
</script>
<cf_get_lang_set module_name="#lcase(listgetat(attributes.fuseaction,1,'.'))#">
