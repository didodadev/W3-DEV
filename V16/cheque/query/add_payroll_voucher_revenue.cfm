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
		IS_UPD_CARI_ROW,
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
<cfquery name="control_no" datasource="#dsn2#">
	SELECT ACTION_ID FROM VOUCHER_PAYROLL WHERE PAYROLL_NO = '#attributes.PAYROLL_NO#' 
</cfquery>
<cfif control_no.RECORDCOUNT>
	<script type="text/javascript">
		alert("<cf_get_lang no='125.Aynı Bordro No ya Ait Kayıt Var !'>");
		history.back();
	</script>
  <cfabort>
</cfif>
<cflock name="#createUUID()#" timeout="60">
	<cftransaction>
	<!--- BORDRO VOUCHER_PAYROLL TABLOSUNA KAYDEDILIYOR ---> 
	<cfquery name="ADD_REVENUE_TO_PAYROLL" datasource="#dsn2#">
		INSERT INTO
			VOUCHER_PAYROLL
			(
				PROCESS_CAT,
				PAYROLL_TYPE,
				PAYROLL_TOTAL_VALUE,
				PAYROLL_OTHER_MONEY,
				PAYROLL_OTHER_MONEY_VALUE,
				PAYROLL_CASH_ID,
				NUMBER_OF_VOUCHER,
				CURRENCY_ID,
				PAYROLL_REVENUE_DATE,
				PAYROLL_REV_MEMBER,
				PAYROLL_AVG_DUEDATE,
				PAYROLL_AVG_AGE,
				<cfif len(attributes.PAYROLL_NO)>PAYROLL_NO,</cfif>
				MASRAF,
				EXP_CENTER_ID,
				EXP_ITEM_ID,
				MASRAF_CURRENCY,
				RECORD_EMP,
				RECORD_IP,
				RECORD_DATE,
				VOUCHER_BASED_ACC_CARI,
				ACTION_DETAIL,
				BRANCH_ID
			)
			VALUES(
				#form.process_cat#,
				#process_type#,
				#attributes.payroll_total#,
				<cfif isdefined("attributes.basket_money") and len(attributes.basket_money)><cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.basket_money#">,<cfelse>NULL,</cfif>
				<cfif isdefined("attributes.other_payroll_total") and len(attributes.other_payroll_total)>#attributes.other_payroll_total#,<cfelse>NULL,</cfif>
				#listfirst(form.cash_id,';')#,
				#attributes.voucher_num#,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#session.ep.money#">,
				#attributes.PAYROLL_REVENUE_DATE#,
				#EMPLOYEE_ID#,
				<cfif len(attributes.pyrll_avg_duedate)>#attributes.pyrll_avg_duedate#,<cfelse>NULL,</cfif>
				<cfif len(attributes.pyrll_avg_age)>#attributes.pyrll_avg_age#,<cfelse>NULL,</cfif>
				<cfif len(attributes.PAYROLL_NO) ><cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.PAYROLL_NO#">,</cfif>
				<cfif attributes.masraf gt 0>#attributes.masraf#<cfelse>0</cfif>,
				<cfif isdefined("attributes.expense_center") and len(attributes.expense_center)>#attributes.expense_center#<cfelse>NULL</cfif>,
				<cfif isdefined("attributes.exp_item_id") and len(attributes.exp_item_id) and len(attributes.exp_item_name)>#attributes.exp_item_id#<cfelse>NULL</cfif>,
				<cfif len(attributes.masraf_currency)><cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.masraf_currency#"><cfelse>NULL</cfif>,
				#session.ep.userid#,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#CGI.REMOTE_ADDR#">,
				#NOW()#,
				<cfif len(is_voucher_based)>#is_voucher_based#<cfelse>0</cfif>,
				<cfif isDefined("attributes.action_detail") and len(attributes.action_detail)><cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.action_detail#"><cfelse>NULL</cfif>,
				#branch_id_info#
			)
	</cfquery>
	<!--- bordro cari tablosuna kaydedilek--->
	<cfquery name="GET_BORDRO_ID" datasource="#dsn2#">
		SELECT MAX(ACTION_ID) AS P_ID FROM VOUCHER_PAYROLL
	</cfquery>
	<cfset p_id=get_bordro_id.P_ID> 
	<cfset cash_currency_rate = ''>
	<cfset currency_multiplier = ''>
	<cfset masraf_curr_multiplier = ''>
	<cfset currency_multiplier_payroll= ''>
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
	<cfquery name="ADD_BORDRO_TO_CASH" datasource="#dsn2#">
		INSERT INTO
			CASH_ACTIONS
			(
				ACTION_TYPE,
				ACTION_TYPE_ID,
				PROCESS_CAT,
				CASH_ACTION_TO_CASH_ID,
				CASH_ACTION_CURRENCY_ID,
				CASH_ACTION_VALUE,
				ACTION_DATE,
				REVENUE_COLLECTOR_ID,
				IS_ACCOUNT,
				IS_ACCOUNT_TYPE,
				RECORD_EMP,
				RECORD_IP,
				RECORD_DATE,
				PAYROLL_ID,
				PAPER_NO,
				ACTION_VALUE,
				ACTION_CURRENCY_ID
				<cfif len(session.ep.money2)>
					,ACTION_VALUE_2
					,ACTION_CURRENCY_ID_2
				</cfif>
			)
			VALUES(
				<cfqueryparam cfsqltype="cf_sql_varchar" value="SENET ÇIKIŞ BORDROSU(TAHSİL)">,
				1050,
				#form.process_cat#,
				#listfirst(form.cash_id,';')#,
				<cfif len(cash_currency_rate)>
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#listgetat(form.cash_id,3,';')#">,
					#wrk_round((attributes.payroll_total-attributes.sistem_masraf_tutari)/cash_currency_rate)#,
				<cfelse>
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#session.ep.money#">,
					#attributes.payroll_total-attributes.sistem_masraf_tutari#,
				</cfif>
				#attributes.PAYROLL_REVENUE_DATE#,
				#EMPLOYEE_ID#,
				<cfif is_account eq 1>1,13,<cfelse>0,13,</cfif>
				#session.ep.userid#,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#CGI.REMOTE_ADDR#">,
				#NOW()#,
				#P_ID#,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.PAYROLL_NO#">,
				#attributes.payroll_total-attributes.sistem_masraf_tutari#,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#session.ep.money#">
				<cfif len(session.ep.money2)>
					,#wrk_round((attributes.payroll_total-attributes.sistem_masraf_tutari)/currency_multiplier,4)#
					,<cfqueryparam cfsqltype="cf_sql_varchar" value="#session.ep.money2#">
				</cfif>				
			)
	</cfquery>
	<!--- senet durumları senet tablosundan update edilecek--->
	<cfloop from="1" to="#attributes.record_num#" index="i">
		<cfif evaluate("attributes.row_kontrol#i#")>
			<cfquery name="UPD_VOUCHERS" datasource="#dsn2#">
				UPDATE VOUCHER SET VOUCHER_STATUS_ID=3 WHERE VOUCHER_ID = #evaluate("attributes.voucher_id#i#")#
			</cfquery>
			<!--- Bordroya girilen senetler için voucher_history tablosuna giriþ yapýlýyor...--->
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
						#P_ID#,
						3,
						#attributes.PAYROLL_REVENUE_DATE#,
						<cfif len(evaluate("attributes.voucher_system_currency_value#i#"))>#evaluate("attributes.voucher_system_currency_value#i#")#,<cfelse>NULL,</cfif>
						<cfif len(evaluate("attributes.system_money_info#i#"))><cfqueryparam cfsqltype="cf_sql_varchar" value='#wrk_eval("attributes.system_money_info#i#")#'>,<cfelse>NULL,</cfif>
						<cfif len(evaluate("attributes.other_money_value2#i#"))>#evaluate("attributes.other_money_value2#i#")#,<cfelse>NULL,</cfif>
						<cfif len(evaluate("attributes.other_money2#i#"))><cfqueryparam cfsqltype="cf_sql_varchar" value='#wrk_eval("attributes.other_money2#i#")#'>,<cfelse>NULL,</cfif>
						#NOW()#
					)
			</cfquery>
			<cfif is_voucher_based eq 1 and is_upd_cari_row eq 1>
				<cfquery name="UPD_CHEQUE" datasource="#dsn2#">
					UPDATE
						CARI_ROWS
					SET
						RATE2=#currency_multiplier_payroll#,
						<cfif len(evaluate("attributes.voucher_system_currency_value#i#")) and len(currency_multiplier_payroll)>OTHER_CASH_ACT_VALUE = #wrk_round(evaluate("attributes.voucher_system_currency_value#i#")/currency_multiplier_payroll)#,</cfif>
						<cfif len(evaluate("attributes.system_money_info#i#"))>OTHER_MONEY = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.basket_money#">,</cfif>
						<cfif len(evaluate("attributes.other_money_value2#i#"))>ACTION_VALUE_2 = #wrk_round(evaluate("attributes.other_money_value2#i#")/currency_multiplier)#,</cfif>
						<cfif len(evaluate("attributes.other_money2#i#"))>ACTION_CURRENCY_2 = <cfqueryparam cfsqltype="cf_sql_varchar" value="#session.ep.money2#">,</cfif>
						ACTION_ID = #evaluate("attributes.voucher_id#i#")#
					WHERE
						ACTION_ID = #evaluate("attributes.voucher_id#i#")# AND
						ACTION_TYPE_ID IN (97,107) AND
						ACTION_TABLE = 'VOUCHER'
				</cfquery>
			</cfif>
		</cfif>
	</cfloop>
	<cfscript>
		if(len(attributes.exp_item_id) and len(attributes.exp_item_name) and (attributes.masraf gt 0) and len(attributes.expense_center))
		{
			butceci(
				action_id : p_id,
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
				alacakli_hesaplar = '';
				alacakli_tutarlar = '';
				other_amount_alacak_list = '';
				other_currency_alacak_list = '';
				borclu_hesaplar = '';
				borclu_tutarlar = '';
				other_amount_borc_list='';
				other_currency_borc_list='';
				GET_ACC_CODE = cfquery(datasource:"#dsn2#",sqlstring:"SELECT CASH_ACC_CODE FROM CASH WHERE CASH_ID=#listfirst(form.cash_id,';')#");
				acc = GET_ACC_CODE.CASH_ACC_CODE;
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
						if(len(evaluate("attributes.acc_code#i#")))
							alacakli_hesaplar=listappend(alacakli_hesaplar,evaluate("attributes.acc_code#i#"),',');
						else if(evaluate("attributes.voucher_status_id#i#") eq 1)
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
					str_card_detail[1][listlen(borclu_tutarlar)] = ' #attributes.action_detail#';
				else
					str_card_detail[1][listlen(borclu_tutarlar)] = ' SENET TAHSİL İŞLEMİ';
				if(len(attributes.exp_item_id) and len(attributes.exp_item_name) and isdefined("attributes.masraf") and (attributes.masraf gt 0) and len(attributes.expense_center))
				{ /* masraf hesaplarini da muhasebe hesap ve tutarlara dahil edelim */
					borclu_hesaplar = listappend(borclu_hesaplar,GET_EXP_ACC.ACCOUNT_CODE,',');
					borclu_tutarlar = listappend(borclu_tutarlar,attributes.sistem_masraf_tutari,',');
					other_amount_borc_list = listappend(other_amount_borc_list,attributes.masraf,',');
					other_currency_borc_list = listappend(other_currency_borc_list,attributes.masraf_currency,',');
					alacakli_hesaplar = listappend(alacakli_hesaplar,GET_ACC_CODE.CASH_ACC_CODE, ',');
					alacakli_tutarlar = listappend(alacakli_tutarlar,attributes.sistem_masraf_tutari,',');
					other_amount_alacak_list = listappend(other_amount_alacak_list,attributes.masraf,',');
					other_currency_alacak_list = listappend(other_currency_alacak_list,attributes.masraf_currency,',');
					if(isDefined("attributes.action_detail") and len(attributes.action_detail))
						str_card_detail[1][listlen(borclu_tutarlar)] = ' #attributes.action_detail#';
					else
						str_card_detail[1][listlen(borclu_tutarlar)] = ' SENET TAHSİL İŞLEMİ';
					if(isDefined("attributes.action_detail") and len(attributes.action_detail))
						str_card_detail[2][listlen(alacakli_tutarlar)] = ' #attributes.action_detail#';
					else
						str_card_detail[2][listlen(alacakli_tutarlar)] = ' SENET TAHSİL İŞLEMİ';
				}
				
				muhasebeci (
					action_id:P_ID,
					workcube_process_type:process_type,
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
					fis_detay:'SENET TAHSİL İŞLEMİ',
					fis_satir_detay:str_card_detail,
					belge_no : form.PAYROLL_NO,
					from_branch_id : branch_id_info,
					workcube_process_cat : form.process_cat,
					is_account_group : is_account_group
				);
			}
			else		/*e-deftere uygun muhasebe islemleri yapılıyor*/
			{
				alacakli_hesaplar = '';
				alacakli_tutarlar = '';
				project_id = '';
				GET_ACC_CODE = cfquery(datasource:"#dsn2#",sqlstring:"SELECT CASH_ACC_CODE FROM CASH WHERE CASH_ID=#listfirst(form.cash_id,';')#");
				acc = GET_ACC_CODE.CASH_ACC_CODE;
				for(i=1; i lte attributes.record_num; i=i+1)
				{
					if (evaluate("attributes.row_kontrol#i#"))
					{
						if(evaluate("attributes.currency_id#i#") is session.ep.money)
							alacakli_tutarlar = evaluate("attributes.voucher_value#i#");
						else
							alacakli_tutarlar = evaluate("attributes.voucher_system_currency_value#i#");
		
						if(len(evaluate("attributes.acc_code#i#")))
							alacakli_hesaplar = evaluate("attributes.acc_code#i#");
						else if(evaluate("attributes.voucher_status_id#i#") eq 1)
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
							action_id:P_ID,
							action_row_id : evaluate("attributes.VOUCHER_ID#i#"),
							due_date :iif(len(evaluate("attributes.VOUCHER_DUEDATE#i#")),'createodbcdatetime(evaluate("attributes.VOUCHER_DUEDATE#i#"))','attributes.pyrll_avg_duedate'),
							workcube_process_type:process_type,
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
							fis_detay:'SENET TAHSİL İŞLEMİ',
							fis_satir_detay:str_card_detail,
							belge_no : evaluate("attributes.voucher_no#i#"),
							from_branch_id : branch_id_info,
							workcube_process_cat : form.process_cat,
							is_account_group : is_account_group,
							acc_project_id : project_id
						);
					}
				}
				/* masraf hesaplari da ayrica fis olusturur */
				if(len(attributes.exp_item_id) and len(attributes.exp_item_name) and isdefined("attributes.masraf") and (attributes.masraf gt 0) and len(attributes.expense_center))
				{ 
					if(isDefined("attributes.action_detail") and len(attributes.action_detail))
						str_card_detail[1][1] = ' #attributes.action_detail#';
					else
						str_card_detail[1][1] = ' SENET TAHSİL İŞLEMİ';
					if(isDefined("attributes.action_detail") and len(attributes.action_detail))
						str_card_detail[2][1] = ' #attributes.action_detail#';
					else
						str_card_detail[2][1] = ' SENET TAHSİL MASRAFI';
					muhasebeci(
						action_id:P_ID,
						workcube_process_type:process_type,
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
						fis_detay:'SENET TAHSİL MASRAFI',
						fis_satir_detay:str_card_detail,
						belge_no : form.PAYROLL_NO,
						from_branch_id : branch_id_info,
						workcube_process_cat : form.process_cat
					);
				}
			}
		}
		basket_kur_ekle(action_id:GET_BORDRO_ID.P_ID,table_type_id:12,process_type:0);
	  </cfscript> 
        <cf_workcube_process_cat 
            process_cat="#form.process_cat#"
            action_id = #p_id#
            is_action_file = 1
            action_db_type = '#dsn2#'
            action_page='#request.self#?fuseaction=cheque.form_add_voucher_payroll_revenue&event=upd&id=#p_id#'
            action_file_name='#get_process_type.action_file_name#'
            is_template_action_file = '#get_process_type.action_file_from_template#'>
	<cf_add_log log_type="1" action_id="#p_id#" action_name="#attributes.payroll_no# Eklendi" paper_no="#form.payroll_no#" period_id="#session.ep.period_id#" process_type="#get_process_type.PROCESS_TYPE#" data_source="#dsn2#">
	</cftransaction>
</cflock>
<script type="text/javascript">
	window.location.href="<cfoutput>#request.self#?fuseaction=cheque.form_add_voucher_payroll_revenue&event=upd&ID=#p_id#</cfoutput>";
</script>
<cf_get_lang_set module_name="#lcase(listgetat(attributes.fuseaction,1,'.'))#">

