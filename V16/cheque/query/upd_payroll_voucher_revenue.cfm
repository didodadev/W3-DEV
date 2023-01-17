<cfif form.active_period neq session.ep.period_id>
	<script type="text/javascript">
		alert("İşlem Yapmak İstediğiniz Muhasebe Dönemi ile Aktif Muhasebe Döneminiz Farklı Muhasebe Döneminizi Kontrol Ediniz!");
		wrk_opener_reload();
		window.close();
	</script>
	<cfabort>
</cfif>
<cf_get_lang_set module_name="cheque"><!--- sayfanin en altinda kapanisi var --->
<cf_date tarih="attributes.PAYROLL_REVENUE_DATE">
<cf_date tarih='attributes.pyrll_avg_duedate'>
<cfquery name="get_process_type" datasource="#dsn3#">
	SELECT 
		PROCESS_TYPE,
		IS_ACCOUNT,
		IS_ACCOUNT_GROUP,
		IS_CHEQUE_BASED_ACTION,
		IS_UPD_CARI_ROW,
        ACTION_FILE_NAME,
        ACTION_FILE_FROM_TEMPLATE
	 FROM 
	 	SETUP_PROCESS_CAT 
	WHERE 
		PROCESS_CAT_ID =<cfqueryparam cfsqltype="cf_sql_integer" value="#form.process_cat#">
</cfquery>
<cfscript>
	cash_currency_rate = '';
	currency_multiplier = '';
	currency_multiplier_payroll= '';
	masraf_curr_multiplier = '';
	process_type = get_process_type.PROCESS_TYPE;
	is_account = get_process_type.IS_ACCOUNT;
	is_account_group = get_process_type.IS_ACCOUNT_GROUP;
	is_voucher_based = get_process_type.IS_CHEQUE_BASED_ACTION;
	is_upd_cari_row = get_process_type.IS_UPD_CARI_ROW;
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
	branch_id_info = listgetat(session.ep.user_location,2,'-');
</cfscript>
<cfif isDefined('attributes.kur_say') and len(attributes.kur_say)>
	<cfloop from="1" to="#attributes.kur_say#" index="mon">
		<cfif evaluate("attributes.hidden_rd_money_#mon#") is listgetat(form.cash_id,3,';')>
			<cfset cash_currency_rate = evaluate('attributes.txt_rate2_#mon#/attributes.txt_rate1_#mon#')>
		</cfif>
		<cfif evaluate("attributes.hidden_rd_money_#mon#") is session.ep.money2>
			<cfset currency_multiplier = evaluate('attributes.txt_rate2_#mon#/attributes.txt_rate1_#mon#')>
		</cfif>
		<cfif evaluate("attributes.hidden_rd_money_#mon#") is attributes.masraf_currency>
			<cfset masraf_curr_multiplier = evaluate('attributes.txt_rate2_#mon#/attributes.txt_rate1_#mon#')>
		</cfif>
		<cfif evaluate("attributes.hidden_rd_money_#mon#") is attributes.basket_money>
			<cfset currency_multiplier_payroll = evaluate('attributes.txt_rate2_#mon#/attributes.txt_rate1_#mon#')>
		</cfif>
	</cfloop>	
</cfif>
<cfquery name="CONTROL_NO" datasource="#DSN2#">
	SELECT 
		ACTION_ID 
	FROM 
		VOUCHER_PAYROLL 
	WHERE 
		PAYROLL_NO = <cfqueryparam cfsqltype="cf_sql_varchar" value="#PAYROLL_NO#"> AND
		ACTION_ID<><cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.ID#">
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
		<cfquery name="UPD_PAYROLL" datasource="#dsn2#">
			UPDATE 
				VOUCHER_PAYROLL
			SET
			PROCESS_CAT=<cfqueryparam cfsqltype="cf_sql_integer" value="#form.process_cat#">,
				PAYROLL_TYPE=<cfqueryparam cfsqltype="cf_sql_integer" value="#process_type#">,
				PAYROLL_REV_MEMBER=<cfqueryparam cfsqltype="cf_sql_integer" value="#EMPLOYEE_ID#">,
				PAYROLL_TOTAL_VALUE=<cfqueryparam cfsqltype="cf_sql_float" value="#attributes.payroll_total#">,
				PAYROLL_OTHER_MONEY=<cfif isdefined("attributes.basket_money") and len(attributes.basket_money)><cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.basket_money#">,<cfelse>NULL,</cfif>
				PAYROLL_OTHER_MONEY_VALUE=<cfif isdefined("attributes.other_payroll_total") and len(attributes.other_payroll_total)><cfqueryparam cfsqltype="cf_sql_float" value="#attributes.other_payroll_total#">,<cfelse>NULL,</cfif>
				PAYROLL_REVENUE_DATE=<cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.PAYROLL_REVENUE_DATE#">,
				NUMBER_OF_VOUCHER=<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.voucher_num#">,
				PAYROLL_AVG_DUEDATE=<cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.pyrll_avg_duedate#">,
				PAYROLL_AVG_AGE=<cfif len(attributes.pyrll_avg_age)><cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.pyrll_avg_age#">,<cfelse>NULL,</cfif>
				PAYROLL_CASH_ID=<cfqueryparam cfsqltype="cf_sql_integer" value="#listfirst(form.cash_id,';')#">,
				<cfif len(attributes.PAYROLL_NO) >PAYROLL_NO= <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.PAYROLL_NO#">,</cfif>
				MASRAF=<cfif attributes.masraf gt 0><cfqueryparam cfsqltype="cf_sql_float" value="#attributes.masraf#"><cfelse>0</cfif>,
				EXP_CENTER_ID = <cfif isdefined("attributes.expense_center") and len(attributes.expense_center)><cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.expense_center#"><cfelse>NULL</cfif>,
				EXP_ITEM_ID = <cfif isdefined("attributes.exp_item_id") and len(attributes.exp_item_id) and len(attributes.exp_item_name)><cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.exp_item_id#"><cfelse>NULL</cfif>,
				MASRAF_CURRENCY=<cfif len(attributes.masraf_currency)><cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.masraf_currency#"><cfelse>NULL</cfif>,
				UPDATE_EMP=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#">,
				UPDATE_IP = <cfqueryparam cfsqltype="cf_sql_varchar" value="#CGI.REMOTE_ADDR#">,
				UPDATE_DATE=<cfqueryparam cfsqltype="cf_sql_timestamp" value="#NOW()#">,
				VOUCHER_BASED_ACC_CARI = <cfif len(is_voucher_based)><cfqueryparam cfsqltype="cf_sql_bit" value="#is_voucher_based#"><cfelse>0</cfif>,
				ACTION_DETAIL = <cfif isDefined("attributes.action_detail") and len(attributes.action_detail)><cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.action_detail#"><cfelse>NULL</cfif>,
				BRANCH_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#branch_id_info#">
			WHERE
				ACTION_ID= <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.ID#">
		</cfquery>
		<cfquery name="GET_REL_VOUCHERS" datasource="#dsn2#">
			SELECT VOUCHER_ID FROM VOUCHER_HISTORY WHERE PAYROLL_ID=<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.ID#">
		</cfquery>
		<cfset ches=valuelist(get_rel_vouchers.VOUCHER_ID)>
		<cfloop list="#ches#" index="i">
			<cfset ctr=0>
			<cfloop from="1" to="#attributes.record_num#" index="k">
				<cfif i eq evaluate("attributes.voucher_id#k#") and evaluate("attributes.row_kontrol#k#")>
					<cfset ctr=1>
				</cfif>
			</cfloop>
			<cfif ctr eq 0>
				<!---senet tahsil bordrosundan çikarilmis,portföyde durumuna geri dönecek--->
				<cfquery name="GET_VOUCHER_STATUS" datasource="#dsn2#">
					SELECT VOUCHER_STATUS_ID FROM VOUCHER WHERE VOUCHER_ID=<cfqueryparam cfsqltype="cf_sql_integer" value="#i#">
				</cfquery>
				<cfif GET_VOUCHER_STATUS.VOUCHER_STATUS_ID eq 3><!--- bankada icin --->
					<cfquery name="UPD_VOUCHER" datasource="#dsn2#">
						UPDATE VOUCHER SET VOUCHER_STATUS_ID=1 WHERE VOUCHER_ID=<cfqueryparam cfsqltype="cf_sql_integer" value="#i#">
					</cfquery>
					<cfquery name="DEL_VCH_HIST" datasource="#dsn2#">
						DELETE FROM	VOUCHER_HISTORY WHERE VOUCHER_ID=<cfqueryparam cfsqltype="cf_sql_integer" value="#i#"> AND PAYROLL_ID=<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.ID#">
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
					<cfquery name="UPD_VOUCHER" datasource="#dsn2#">
						UPDATE VOUCHER SET VOUCHER_STATUS_ID=3 WHERE VOUCHER_ID=<cfqueryparam cfsqltype="cf_sql_integer" value="#evaluate("attributes.voucher_id#i#")#">
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
								<cfqueryparam cfsqltype="cf_sql_integer" value="#evaluate("attributes.voucher_id#i#")#">,
								<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.ID#">,
								3,
								<cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.PAYROLL_REVENUE_DATE#">,
								<cfif len(evaluate("attributes.voucher_system_currency_value#i#"))><cfqueryparam cfsqltype="cf_sql_float" value="#evaluate("attributes.voucher_system_currency_value#i#")#">,<cfelse>NULL,</cfif>
								<cfif len(evaluate("attributes.system_money_info#i#"))><cfqueryparam cfsqltype="cf_sql_varchar" value='#wrk_eval("attributes.system_money_info#i#")#'>,<cfelse>NULL,</cfif>
								<cfif len(evaluate("attributes.other_money_value2#i#"))><cfqueryparam cfsqltype="cf_sql_float" value="#evaluate("attributes.other_money_value2#i#")#">,<cfelse>NULL,</cfif>
								<cfif len(evaluate("attributes.other_money2#i#"))><cfqueryparam cfsqltype="cf_sql_varchar" value='#wrk_eval("attributes.other_money2#i#")#'>,<cfelse>NULL,</cfif>
								<cfqueryparam cfsqltype="cf_sql_timestamp" value="#NOW()#">
							)		
					</cfquery>
				<cfelse>
					<cfquery name="UPD_VOUCHER_HISTORY" datasource="#dsn2#">
						UPDATE 
							VOUCHER_HISTORY
						SET 
							ACT_DATE = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.PAYROLL_REVENUE_DATE#">,
							OTHER_MONEY_VALUE=<cfif len(evaluate("attributes.voucher_system_currency_value#i#"))><cfqueryparam cfsqltype="cf_sql_float" value="#evaluate("attributes.voucher_system_currency_value#i#")#">,<cfelse>NULL,</cfif>
							OTHER_MONEY=<cfif len(evaluate("attributes.system_money_info#i#"))><cfqueryparam cfsqltype="cf_sql_varchar" value='#wrk_eval("attributes.system_money_info#i#")#'>,<cfelse>NULL,</cfif>
							OTHER_MONEY_VALUE2=<cfif len(evaluate("attributes.other_money_value2#i#"))><cfqueryparam cfsqltype="cf_sql_float" value="#evaluate("attributes.other_money_value2#i#")#">,<cfelse>NULL,</cfif>
							OTHER_MONEY2=<cfif len(evaluate("attributes.other_money2#i#"))><cfqueryparam cfsqltype="cf_sql_varchar" value='#wrk_eval("attributes.other_money2#i#")#'><cfelse>NULL</cfif>
						WHERE 
							VOUCHER_ID= <cfqueryparam cfsqltype="cf_sql_integer" value="#evaluate("attributes.voucher_id#i#")#"> AND
							PAYROLL_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.ID#">
					</cfquery>
				</cfif>
				<cfif is_voucher_based eq 1 and is_upd_cari_row eq 1>
					<cfquery name="UPD_CHEQUE" datasource="#dsn2#">
						UPDATE
							CARI_ROWS
						SET
							RATE2=<cfqueryparam cfsqltype="cf_sql_float" value="#currency_multiplier_payroll#">,
							<cfif len(evaluate("attributes.voucher_system_currency_value#i#")) and len(currency_multiplier_payroll)>OTHER_CASH_ACT_VALUE = #wrk_round(evaluate("attributes.voucher_system_currency_value#i#")/currency_multiplier_payroll)#,</cfif>
							<cfif len(evaluate("attributes.system_money_info#i#"))>OTHER_MONEY = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.basket_money#">,</cfif>
							<cfif len(evaluate("attributes.other_money_value2#i#"))>ACTION_VALUE_2 = #wrk_round(evaluate("attributes.other_money_value2#i#")/currency_multiplier)#,</cfif>
							<cfif len(evaluate("attributes.other_money2#i#"))>ACTION_CURRENCY_2 = <cfqueryparam cfsqltype="cf_sql_varchar" value="#session.ep.money2#">,</cfif>
							ACTION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#evaluate("attributes.voucher_id#i#")#">
						WHERE
							ACTION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#evaluate("attributes.voucher_id#i#")#"> AND
							ACTION_TYPE_ID IN (97,107) AND
							ACTION_TABLE = 'VOUCHER'
					</cfquery>
				</cfif>
			</cfif>
		</cfloop>
		<cfquery name="GET_PAYROLL" datasource="#dsn2#">
			SELECT PAYROLL_TOTAL_VALUE FROM VOUCHER_PAYROLL WHERE ACTION_ID=<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.ID#">
		</cfquery>
		<cfif not len(attributes.sistem_masraf_tutari)><cfset attributes.sistem_masraf_tutari = 0></cfif>
		<cfquery name="UPD_BORDRO_IN_CASH" datasource="#dsn2#">
			UPDATE
				CASH_ACTIONS
			SET
				PROCESS_CAT =<cfqueryparam cfsqltype="cf_sql_integer" value="#form.process_cat#">,
				CASH_ACTION_TO_CASH_ID=<cfqueryparam cfsqltype="cf_sql_integer" value="#listfirst(form.cash_id,';')#">,
				<cfif len(cash_currency_rate)>
					CASH_ACTION_CURRENCY_ID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#listgetat(form.cash_id,3,';')#">,
					CASH_ACTION_VALUE=<cfqueryparam cfsqltype="cf_sql_float" value="#wrk_round((attributes.payroll_total-attributes.sistem_masraf_tutari)/cash_currency_rate)#">,
				<cfelse>
					CASH_ACTION_CURRENCY_ID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#session.ep.money#">,
					CASH_ACTION_VALUE=<cfqueryparam cfsqltype="cf_sql_float" value="#attributes.payroll_total-attributes.sistem_masraf_tutari#">,
				</cfif>
				ACTION_DATE= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.PAYROLL_REVENUE_DATE#">,
				IS_ACCOUNT = <cfif is_account>1,<cfelse>0,</cfif>
				IS_ACCOUNT_TYPE = 13,
				REVENUE_COLLECTOR_ID=<cfqueryparam cfsqltype="cf_sql_integer" value="#EMPLOYEE_ID#">,
				PAPER_NO = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.PAYROLL_NO#">,
				ACTION_VALUE = <cfqueryparam cfsqltype="cf_sql_float" value="#attributes.payroll_total-attributes.sistem_masraf_tutari#">,
				ACTION_CURRENCY_ID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#session.ep.money#">
				<cfif len(session.ep.money2)>
					,ACTION_VALUE_2 = <cfqueryparam cfsqltype="cf_sql_float" value="#wrk_round((attributes.payroll_total-attributes.sistem_masraf_tutari)/currency_multiplier,4)#">
					,ACTION_CURRENCY_ID_2 = <cfqueryparam cfsqltype="cf_sql_varchar" value="#session.ep.money2#">
				</cfif>	
			WHERE
				PAYROLL_ID=<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.ID#">
		</cfquery>
		<cfscript>
			butce_sil(action_id:attributes.ID,process_type:form.old_process_type);
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
					detail : 'SENET TAHSİL MASRAFI',
					paper_no : form.payroll_no,
					branch_id : branch_id_info,
					insert_type : 1//banka vs den eklenen masraflar için farklı ekleme metodu tanımlar
				);
				GET_EXP_ACC = cfquery(datasource : "#dsn2#", sqlstring : "SELECT ACCOUNT_CODE FROM EXPENSE_ITEMS WHERE EXPENSE_ITEM_ID = #attributes.exp_item_id#");
			}
			if(is_account eq 1)
			{
				if(session.ep.our_company_info.is_edefter eq 0)	/*standart muhasebe islemleri yapılıyor*/
				{
					//varsa butce mahsup kaydi silinmeli
					muhasebe_sil(action_id:attributes.id,action_table:'VOUCHER_PAYROLL',process_type:form.old_process_type);
					/*bordrodaki senetlerin listesi alınıyor*/
					/*GET_VOUCHERS_LAST=cfquery(datasource:"#dsn2#",sqlstring:"SELECT 
								VOUCHER.* 
							FROM
								VOUCHER, 
								VOUCHER_HISTORY 
							WHERE
								VOUCHER.VOUCHER_ID=VOUCHER_HISTORY.VOUCHER_ID
								AND VOUCHER_HISTORY.PAYROLL_ID=#attributes.ID#");
					cheq_no_list=valuelist(GET_VOUCHERS_LAST.VOUCHER_NO);
					ches_2 = ches;*/
					/*bordrodan cıkarılan senetler bulunuyor*/
					/*for(cheq_x=1; cheq_x lte attributes.record_num; cheq_x=cheq_x+1)
					{
						if (evaluate("attributes.row_kontrol#cheq_x#"))
							if(len(evaluate("attributes.voucher_id#cheq_x#")) and ListFindNoCase(ches_2,evaluate("attributes.voucher_id#cheq_x#")))
								ches_2 = ListDeleteAt(ches_2,ListFindNoCase(ches_2,evaluate("attributes.voucher_id#cheq_x#"), ','), ',');
					}*/
					alacakli_hesaplar = '';
					alacakli_tutarlar = '';
					other_amount_alacak_list = '';
					other_currency_alacak_list = '';
					borclu_hesaplar = '';
					borclu_tutarlar = '';
					other_amount_borc_list='';
					other_currency_borc_list='';
					GET_ACC_CODE = cfquery(datasource:"#dsn2#",sqlstring:"SELECT CASH_ACC_CODE FROM CASH WHERE CASH_ID=#listfirst(form.cash_id,';')#");
					for(i=1; i lte attributes.record_num; i=i+1)
					{
						if (evaluate("attributes.row_kontrol#i#"))
						{
							if(evaluate("attributes.currency_id#i#") is session.ep.money)
								alacakli_tutarlar=listappend(alacakli_tutarlar,evaluate("attributes.voucher_value#i#"),',');
							else
								alacakli_tutarlar=listappend(alacakli_tutarlar,evaluate("attributes.voucher_system_currency_value#i#"),',');
							other_currency_alacak_list = listappend(other_currency_alacak_list,evaluate("attributes.currency_id#i#"),',');
							other_amount_alacak_list =  listappend(other_amount_alacak_list,evaluate("attributes.voucher_value#i#"),',');
							if(listfind('1,3',evaluate("attributes.voucher_status_id#i#"),','))
							{/*wrk_not : 
								ilgili olabilecek bir durumda olmayan bir senet icin hesap secilemez, bunu yapamazsa muhasebeci calismaz,
								durum saglamasi yapiliyor*/
								if(len(evaluate("attributes.acc_code#i#")))
									alacakli_hesaplar=listappend(alacakli_hesaplar,evaluate("attributes.acc_code#i#"),',');
								else
								{
									GET_VOUCHER_ACC_CODE=cfquery(datasource:"#dsn2#",sqlstring:"
										SELECT
											C.A_VOUCHER_ACC_CODE
										FROM
											VOUCHER_PAYROLL AS P,
											VOUCHER_HISTORY AS CH,
											CASH AS C
										WHERE
											P.TRANSFER_CASH_ID = C.CASH_ID AND
											P.PAYROLL_TYPE IN(137) AND
											P.ACTION_ID= CH.PAYROLL_ID AND
											CH.VOUCHER_ID=#evaluate("attributes.voucher_id#i#")#");
									if(GET_VOUCHER_ACC_CODE.recordcount eq 0)
									{
										GET_VOUCHER_ACC_CODE=cfquery(datasource:"#dsn2#", sqlstring:"
											SELECT
												C.A_VOUCHER_ACC_CODE
											FROM
												VOUCHER_PAYROLL AS VP,
												VOUCHER_HISTORY AS VH,
												CASH AS C
											WHERE
												VP.PAYROLL_CASH_ID = C.CASH_ID AND
												(VP.PAYROLL_TYPE=97 OR VP.PAYROLL_TYPE = 109 OR (VP.PAYROLL_TYPE=107 AND VP.PAYROLL_NO='-1')) AND
												VP.ACTION_ID= VH.PAYROLL_ID AND
												VH.VOUCHER_ID=#evaluate("attributes.voucher_id#i#")#");
									}
									alacakli_hesaplar=listappend(alacakli_hesaplar, GET_VOUCHER_ACC_CODE.A_VOUCHER_ACC_CODE, ',');
								}
							}
							if (is_account_group neq 1)
							{
								 if(isDefined("attributes.action_detail") and len(attributes.action_detail))
									str_card_detail[2][listlen(alacakli_tutarlar)] = ' #evaluate("attributes.voucher_no#i#")# - #attributes.action_detail#';
								else
									str_card_detail[2][listlen(alacakli_tutarlar)] = ' #evaluate("attributes.voucher_no#i#")# - SENET TAHSİL İŞLEMİ';
							}
							else
							{
								if (isDefined("attributes.action_detail") and len(attributes.action_detail))
									str_card_detail[2][listlen(alacakli_tutarlar)] = ' #attributes.action_detail#';
								else
									str_card_detail[2][listlen(alacakli_tutarlar)] = ' SENET TAHSİL İŞLEMİ';
							}
						}
					}
					borclu_hesaplar=listappend(borclu_hesaplar,GET_ACC_CODE.CASH_ACC_CODE,',');
					borclu_tutarlar=listappend(borclu_tutarlar,attributes.payroll_total,',');
					other_amount_borc_list = listappend(other_amount_borc_list,wrk_round(attributes.payroll_total/cash_currency_rate),',');
					other_currency_borc_list = listappend(other_currency_borc_list,listgetat(form.cash_id,3,';'),',');
					if(isDefined("attributes.action_detail") and len(attributes.action_detail))
						str_card_detail[1][1] = ' #attributes.action_detail#';
					else
						str_card_detail[1][1] = ' SENET TAHSİL İŞLEMİ';
					if(len(attributes.exp_item_id) and len(attributes.exp_item_name) and isdefined("attributes.masraf") and (attributes.masraf gt 0) and len(attributes.expense_center))
					{ 
						/* masraf hesaplarini da muhasebe hesap ve tutarlara dahil edelim */
						borclu_hesaplar = listappend(borclu_hesaplar,GET_EXP_ACC.ACCOUNT_CODE,',');
						borclu_tutarlar = listappend(borclu_tutarlar,attributes.sistem_masraf_tutari,',');
						other_amount_borc_list = listappend(other_amount_borc_list,attributes.masraf,',');
						other_currency_borc_list = listappend(other_currency_borc_list,attributes.masraf_currency,',');
						alacakli_hesaplar = listappend(alacakli_hesaplar,GET_ACC_CODE.CASH_ACC_CODE, ',');
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
							str_card_detail[2][listlen(alacakli_tutarlar)] = ' SENET TAHSİL İŞLEMİ';
							str_card_detail[1][2] = ' SENET TAHSİL İŞLEMİ';
						}
					} 
					muhasebeci (
						action_id:attributes.id,
						workcube_process_type:process_type,
						workcube_old_process_type :form.old_process_type,
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
						fis_detay : 'SENET TAHSİL İŞLEMİ',
						fis_satir_detay : str_card_detail,
						belge_no : form.PAYROLL_NO,
						from_branch_id : branch_id_info,
						workcube_process_cat : form.process_cat,
						is_account_group : is_account_group
					);
				}
				else		/*e-deftere uygun muhasebe islemleri yapılıyor*/
				{
					// tum muhasebe kayıtlari silinir sonra yaniden eklenir.
					muhasebe_sil(action_id:attributes.id,action_table:'VOUCHER_PAYROLL',process_type:form.old_process_type);
					
					alacakli_hesaplar = '';
					alacakli_tutarlar = '';
					project_id = '';
					GET_ACC_CODE = cfquery(datasource:"#dsn2#",sqlstring:"SELECT CASH_ACC_CODE FROM CASH WHERE CASH_ID=#listfirst(form.cash_id,';')#");
					
					for(i=1; i lte attributes.record_num; i=i+1)
					{
						if (evaluate("attributes.row_kontrol#i#"))
						{
							if(evaluate("attributes.currency_id#i#") is session.ep.money)
								alacakli_tutarlar = evaluate("attributes.voucher_value#i#");
							else
								alacakli_tutarlar = evaluate("attributes.voucher_system_currency_value#i#");
							
							if(listfind('1,3',evaluate("attributes.voucher_status_id#i#"),','))
							{/*wrk_not : 
								ilgili olabilecek bir durumda olmayan bir senet icin hesap secilemez, bunu yapamazsa muhasebeci calismaz,durum saglamasi yapiliyor*/
								if(len(evaluate("attributes.acc_code#i#")))
									alacakli_hesaplar = evaluate("attributes.acc_code#i#");
								else
								{
									GET_VOUCHER_ACC_CODE=cfquery(datasource:"#dsn2#",sqlstring:"
										SELECT
											C.A_VOUCHER_ACC_CODE
										FROM
											VOUCHER_PAYROLL AS P,
											VOUCHER_HISTORY AS CH,
											CASH AS C
										WHERE
											P.TRANSFER_CASH_ID = C.CASH_ID AND
											P.PAYROLL_TYPE IN(137) AND
											P.ACTION_ID= CH.PAYROLL_ID AND
											CH.VOUCHER_ID=#evaluate("attributes.voucher_id#i#")#");
									if(GET_VOUCHER_ACC_CODE.recordcount eq 0)
									{
										GET_VOUCHER_ACC_CODE=cfquery(datasource:"#dsn2#", sqlstring:"
											SELECT
												C.A_VOUCHER_ACC_CODE
											FROM
												VOUCHER_PAYROLL AS VP,
												VOUCHER_HISTORY AS VH,
												CASH AS C
											WHERE
												VP.PAYROLL_CASH_ID = C.CASH_ID AND
												(VP.PAYROLL_TYPE=97 OR VP.PAYROLL_TYPE = 109 OR (VP.PAYROLL_TYPE=107 AND VP.PAYROLL_NO='-1')) AND
												VP.ACTION_ID= VH.PAYROLL_ID AND
												VH.VOUCHER_ID=#evaluate("attributes.voucher_id#i#")#");
									}
									alacakli_hesaplar = GET_VOUCHER_ACC_CODE.A_VOUCHER_ACC_CODE;
								}
							}
							
							GET_VOUCHER_PROJECT=cfquery(datasource:"#dsn2#", sqlstring:"
								SELECT
									PROJECT_ID
								FROM
									VOUCHER_PAYROLL AS VP,
									VOUCHER AS V
								WHERE
									VP.ACTION_ID = V.VOUCHER_PAYROLL_ID AND
									V.VOUCHER_ID = #evaluate("attributes.voucher_id#i#")#");

							project_id = GET_VOUCHER_PROJECT.PROJECT_ID;

							if (is_account_group neq 1)
							{
								 if(isDefined("attributes.action_detail") and len(attributes.action_detail))
									str_card_detail[2][1] = ' #evaluate("attributes.voucher_no#i#")# - #attributes.action_detail#';
								else
									str_card_detail[2][1] = ' #evaluate("attributes.voucher_no#i#")# - SENET TAHSİL İŞLEMİ';
							}
							else
							{
								if (isDefined("attributes.action_detail") and len(attributes.action_detail))
									str_card_detail[2][1] = ' #attributes.action_detail#';
								else
									str_card_detail[2][1] = ' SENET TAHSİL İŞLEMİ';
							}
							if(isDefined("attributes.action_detail") and len(attributes.action_detail))
								str_card_detail[1][1] = ' #attributes.action_detail#';
							else
								str_card_detail[1][1] = ' SENET TAHSİL İŞLEMİ';
							
							muhasebeci (
								action_id:attributes.id,
								action_row_id : evaluate("attributes.VOUCHER_ID#i#"),
								due_date :iif(len(evaluate("attributes.VOUCHER_DUEDATE#i#")),'createodbcdatetime(evaluate("attributes.VOUCHER_DUEDATE#i#"))','attributes.pyrll_avg_duedate'),
								workcube_process_type:process_type,
								workcube_old_process_type :form.old_process_type,
								account_card_type:13,
								action_table :'VOUCHER_PAYROLL',
								islem_tarihi: attributes.PAYROLL_REVENUE_DATE,
								borc_hesaplar: GET_ACC_CODE.CASH_ACC_CODE,
								borc_tutarlar: alacakli_tutarlar,
								other_amount_borc: wrk_round(evaluate("attributes.voucher_system_currency_value#i#")/cash_currency_rate),
								other_currency_borc: listgetat(form.cash_id,3,';'),
								alacak_hesaplar: alacakli_hesaplar,
								alacak_tutarlar: alacakli_tutarlar,
								other_amount_alacak: evaluate("attributes.voucher_value#i#"),
								other_currency_alacak: evaluate("attributes.currency_id#i#"),
								currency_multiplier : currency_multiplier,
								fis_detay : 'SENET TAHSİL İŞLEMİ',
								fis_satir_detay : str_card_detail,
								belge_no : evaluate("attributes.voucher_no#i#"),
								from_branch_id : branch_id_info,
								workcube_process_cat : form.process_cat,
								is_account_group : is_account_group,
								acc_project_id : project_id
							);	
						}
					}
					
					if(len(attributes.exp_item_id) and len(attributes.exp_item_name) and isdefined("attributes.masraf") and (attributes.masraf gt 0) and len(attributes.expense_center))
					{ 
						/* masraf hesaplarini da muhasebe hesap ve tutarlara dahil edelim */
						if(isDefined("attributes.action_detail") and len(attributes.action_detail))
						{
							str_card_detail[2][1] = ' #attributes.action_detail#';
							str_card_detail[1][2] = ' #attributes.action_detail#';
						}
						else
						{
							str_card_detail[2][1] = ' SENET TAHSİL MASRAFI';
							str_card_detail[1][2] = ' SENET TAHSİL MASRAFI';
						}
						muhasebeci (
							action_id:attributes.id,
							workcube_process_type:process_type,
							workcube_old_process_type :form.old_process_type,
							account_card_type:12,
							action_table :'VOUCHER_PAYROLL',
							islem_tarihi: attributes.PAYROLL_REVENUE_DATE,
							borc_hesaplar: GET_EXP_ACC.ACCOUNT_CODE,
							borc_tutarlar: attributes.sistem_masraf_tutari,
							other_amount_borc: attributes.masraf,
							other_currency_borc: attributes.masraf_currency,
							alacak_hesaplar: GET_ACC_CODE.CASH_ACC_CODE,
							alacak_tutarlar: attributes.sistem_masraf_tutari,
							other_amount_alacak: attributes.masraf,
							other_currency_alacak: attributes.masraf_currency,
							currency_multiplier : currency_multiplier,
							fis_detay : 'SENET TAHSİL MASRAFI',
							fis_satir_detay : str_card_detail,
							belge_no : form.PAYROLL_NO,
							from_branch_id : branch_id_info,
							workcube_process_cat : form.process_cat
						);	
					} 		
				}
			}
			else
			{
				/*bordro bazında muhasebe hareketi veya masraf nedeniyle bordroya muhasebe fişi olusturulmus olabileceginden payrolla kayıtlı fis(varsa) siliniyor*/
				muhasebe_sil(action_id:attributes.id,action_table:'VOUCHER_PAYROLL',process_type:form.old_process_type);
			}
			basket_kur_ekle(action_id:attributes.id,table_type_id:12,process_type:1);
		</cfscript>	
        <cf_workcube_process_cat 
            process_cat="#form.process_cat#"
            action_id = #attributes.id#
            is_action_file = 1
            action_db_type = '#dsn2#'
            action_page='#request.self#?fuseaction=cheque.form_add_voucher_payroll_revenue&event=upd&id=#attributes.id#'
            action_file_name='#get_process_type.action_file_name#'
            is_template_action_file = '#get_process_type.action_file_from_template#'>
        <cf_add_log log_type="0" action_id="#id#" action_name="#attributes.payroll_no# Güncellendi" paper_no="#form.payroll_no#" period_id="#session.ep.period_id#" process_type="#get_process_type.PROCESS_TYPE#" data_source="#dsn2#">
	</cftransaction>	
</cflock>
<script type="text/javascript">
	window.location.href="<cfoutput>#request.self#?fuseaction=cheque.form_add_voucher_payroll_revenue&event=upd&ID=#attributes.ID#</cfoutput>";
</script>
<cf_get_lang_set module_name="#lcase(listgetat(attributes.fuseaction,1,'.'))#"><!--- sayfanin en ustunde acilisi var --->
