<cfif form.active_period neq session.ep.period_id>
	<script type="text/javascript">
		alert("İşlem Yapmak İstediğiniz Muhasebe Dönemi ile Aktif Muhasebe Döneminiz Farklı Muhasebe Döneminizi Kontrol Ediniz!");
		wrk_opener_reload();
		window.close();
	</script>
	<cfabort>
</cfif>
<cf_get_lang_set module_name="cheque">
<cf_date tarih='attributes.PAYROLL_REVENUE_DATE'>
<cf_date tarih='attributes.pyrll_avg_duedate'>
<cfquery name="get_process_type" datasource="#dsn3#">
	SELECT 
		PROCESS_TYPE,
		IS_ACCOUNT,
		IS_ACCOUNT_GROUP,
		IS_CHEQUE_BASED_ACTION,
		ACTION_FILE_NAME,
		IS_UPD_CARI_ROW,
		ACTION_FILE_FROM_TEMPLATE
	 FROM 
	 	SETUP_PROCESS_CAT 
	WHERE 
		PROCESS_CAT_ID = #form.process_cat#
</cfquery>
<cfscript>
	currency_multiplier = '';//sistem ikinci para biriminin kurunu sayfadan alıyor
	masraf_curr_multiplier = '';
	acc_currency_rate = '';
	currency_multiplier_payroll = '';
	process_type = get_process_type.PROCESS_TYPE;
	is_account = get_process_type.IS_ACCOUNT;
	is_account_group = get_process_type.IS_ACCOUNT_GROUP;
	is_cheque_based = get_process_type.IS_CHEQUE_BASED_ACTION;
	is_upd_cari_row = get_process_type.IS_UPD_CARI_ROW;
	attributes.payroll_total = filterNum(attributes.payroll_total);
	attributes.other_payroll_total = filterNum(attributes.other_payroll_total);
	attributes.masraf = filterNum(attributes.masraf);
	for(ff=1; ff lte attributes.record_num; ff=ff+1)
	{
		if (evaluate("attributes.row_kontrol#ff#"))
		{
			'attributes.cheque_system_currency_value#ff#' = filterNum(evaluate("attributes.cheque_system_currency_value#ff#"));
			'attributes.cheque_value#ff#' = filterNum(evaluate("attributes.cheque_value#ff#"));
		}
	}
	for(rt = 1; rt lte attributes.kur_say; rt = rt + 1)
	{
		'attributes.txt_rate1_#rt#' = filterNum(evaluate('attributes.txt_rate1_#rt#'),session.ep.our_company_info.rate_round_num);
		'attributes.txt_rate2_#rt#' = filterNum(evaluate('attributes.txt_rate2_#rt#'),session.ep.our_company_info.rate_round_num);

		if(evaluate("attributes.hidden_rd_money_#rt#") is session.ep.money2)
			currency_multiplier = evaluate('attributes.txt_rate2_#rt#/attributes.txt_rate1_#rt#');
		if(evaluate("attributes.hidden_rd_money_#rt#") is attributes.masraf_currency)
			masraf_curr_multiplier = evaluate('attributes.txt_rate2_#rt#/attributes.txt_rate1_#rt#');	
		if (evaluate("attributes.hidden_rd_money_#rt#") is attributes.currency_id)
			acc_currency_rate = evaluate('attributes.txt_rate2_#rt#/attributes.txt_rate1_#rt#');
		if (evaluate("attributes.hidden_rd_money_#rt#") is attributes.rd_money)
			dovizli_islem_multiplier = evaluate('attributes.txt_rate2_#rt#/attributes.txt_rate1_#rt#');
		if(evaluate("attributes.hidden_rd_money_#rt#") is attributes.basket_money)
			currency_multiplier_payroll = evaluate('attributes.txt_rate2_#rt#/attributes.txt_rate1_#rt#');
	}
	if(isdefined("attributes.branch_id") and len(attributes.branch_id))
		branch_id_info = attributes.branch_id;
	else
		branch_id_info = listgetat(session.ep.user_location,2,'-');
</cfscript>
<cfquery name="CONTROL_NO" datasource="#DSN2#">
	SELECT ACTION_ID FROM PAYROLL WHERE PAYROLL_NO = <cfqueryparam cfsqltype="cf_sql_varchar" value="#PAYROLL_NO#"> AND ACTION_ID <> #attributes.id#
</cfquery>
<cfif control_no.recordcount>
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
			PAYROLL
		SET
			PROCESS_CAT = #form.process_cat#,
			PAYROLL_TYPE = #process_type#,
			PAYROLL_ACCOUNT_ID = #attributes.account_id#,
			PAYROLL_REV_MEMBER = #EMPLOYEE_ID#,
			PAYROLL_TOTAL_VALUE=#attributes.payroll_total#,
			PAYROLL_OTHER_MONEY=<cfif isdefined("attributes.basket_money") and len(attributes.basket_money)><cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.basket_money#">,<cfelse>NULL,</cfif>
			PAYROLL_OTHER_MONEY_VALUE=<cfif isdefined("attributes.other_payroll_total") and len(attributes.other_payroll_total)>#attributes.other_payroll_total#,<cfelse>NULL,</cfif>
			PAYROLL_REVENUE_DATE=#attributes.PAYROLL_REVENUE_DATE#,
			NUMBER_OF_CHEQUE= #attributes.cheque_num#,
			PAYROLL_AVG_DUEDATE=#attributes.pyrll_avg_duedate#,
			PAYROLL_AVG_AGE=<cfif len(attributes.pyrll_avg_age)>#attributes.pyrll_avg_age#,<cfelse>NULL,</cfif>
			<cfif len(attributes.PAYROLL_NO) >PAYROLL_NO = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.PAYROLL_NO#">,</cfif>
			MASRAF=<cfif attributes.masraf gt 0>#attributes.masraf#<cfelse>0</cfif>,
			EXP_CENTER_ID = <cfif isdefined("attributes.expense_center") and len(attributes.expense_center)>#attributes.expense_center#<cfelse>NULL</cfif>,
			EXP_ITEM_ID = <cfif isdefined("attributes.exp_item_id") and len(attributes.exp_item_id) and len(attributes.exp_item_name)>#attributes.exp_item_id#<cfelse>NULL</cfif>,
			MASRAF_CURRENCY=<cfif len(attributes.masraf_currency)><cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.masraf_currency#"><cfelse>NULL</cfif>,
			CHEQUE_BASED_ACC_CARI = <cfif len(is_cheque_based)>#is_cheque_based#<cfelse>0</cfif>,
			BRANCH_ID = #branch_id_info#,
			UPDATE_EMP=#session.ep.userid#,
			UPDATE_IP = <cfqueryparam cfsqltype="cf_sql_varchar" value="#CGI.REMOTE_ADDR#">,
			UPDATE_DATE=#NOW()#,
			ACTION_DETAIL = <cfif isDefined("attributes.action_detail") and len(attributes.action_detail)><cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.action_detail#"><cfelse>NULL</cfif>
		WHERE
			ACTION_ID=#attributes.id#
	</cfquery>
	<cfquery name="GET_REL_CHEQUES" datasource="#dsn2#">
		SELECT CHEQUE_ID FROM CHEQUE_HISTORY WHERE PAYROLL_ID=#attributes.id#
	</cfquery>
	<cfset ches=valuelist(get_rel_cheques.CHEQUE_ID)>
	<cfloop list="#ches#" index="i">
		<cfset ctr=0>
		<cfloop from="1" to="#attributes.record_num#" index="k">
			<cfif i eq evaluate("attributes.cheque_id#k#") and evaluate("attributes.row_kontrol#k#")>
				<cfset ctr=1>
			</cfif>
		</cfloop>
		<cfif ctr eq 0><!---çek tahsil bordrosundan çikarilmis,portföyde durumuna geri dönecek--->
			<cfquery name="GET_CHEQUE_STATUS" datasource="#dsn2#">
				SELECT CHEQUE_STATUS_ID FROM CHEQUE WHERE CHEQUE_ID=#i#
			</cfquery>
			<cfif GET_CHEQUE_STATUS.CHEQUE_STATUS_ID eq 2><!--- bankada icin --->
				<cfquery name="UPD_CHEQUE" datasource="#dsn2#">
					UPDATE CHEQUE SET CHEQUE_STATUS_ID=1 WHERE CHEQUE_ID=#i#
				</cfquery>
				<cfquery name="DEL_CHE_HIST" datasource="#dsn2#">
					DELETE FROM	CHEQUE_HISTORY WHERE CHEQUE_ID=#i# AND PAYROLL_ID=#attributes.id#
				</cfquery>
			</cfif>
		</cfif>
	</cfloop>
	<cfloop from="1" to="#attributes.record_num#" index="i">
		<cfif evaluate("attributes.row_kontrol#i#")>
			<cfset ctr=0>
			<cfloop list="#ches#" index="k">
				<cfif k eq evaluate("attributes.cheque_id#i#")>
					<cfset ctr=1>
				</cfif>
			</cfloop>
			<cfif ctr eq 0>
				<cfquery name="UPD_CHEQUES" datasource="#dsn2#">
					UPDATE CHEQUE SET CHEQUE_STATUS_ID=2 WHERE CHEQUE_ID= #evaluate("attributes.cheque_id#i#")#
				</cfquery>
				<cfquery name="ADD_CHEQUE_HISTORY" datasource="#dsn2#">
					INSERT INTO
						CHEQUE_HISTORY
							(
							CHEQUE_ID,
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
							#evaluate("attributes.cheque_id#i#")#,
							#attributes.id#,
							2,
							#attributes.PAYROLL_REVENUE_DATE#,
							<cfif len(evaluate("attributes.cheque_system_currency_value#i#"))>#evaluate("attributes.cheque_system_currency_value#i#")#,<cfelse>NULL,</cfif>
							<cfif len(evaluate("attributes.system_money_info#i#"))><cfqueryparam cfsqltype="cf_sql_varchar" value='#wrk_eval("attributes.system_money_info#i#")#'>,<cfelse>NULL,</cfif>
							<cfif len(evaluate("attributes.other_money_value2#i#"))>#evaluate("attributes.other_money_value2#i#")#,<cfelse>NULL,</cfif>
							<cfif len(evaluate("attributes.other_money2#i#"))><cfqueryparam cfsqltype="cf_sql_varchar" value='#wrk_eval("attributes.other_money2#i#")#'>,<cfelse>NULL,</cfif>
							#now()#
							)
				</cfquery>
			<cfelseif ctr eq 1><!--- onceden payroll'a kaydedilmis cekler --->
				<cfquery name="UPD_CHEQUE_HISTORY" datasource="#dsn2#">
					UPDATE 
						CHEQUE_HISTORY
					SET 
						ACT_DATE = #attributes.PAYROLL_REVENUE_DATE#,
						OTHER_MONEY_VALUE=<cfif len(evaluate("attributes.cheque_system_currency_value#i#"))>#evaluate("attributes.cheque_system_currency_value#i#")#,<cfelse>NULL,</cfif>
						OTHER_MONEY=<cfif len(evaluate("attributes.system_money_info#i#"))><cfqueryparam cfsqltype="cf_sql_varchar" value='#wrk_eval("attributes.system_money_info#i#")#'>,<cfelse>NULL,</cfif>
						OTHER_MONEY_VALUE2=<cfif len(evaluate("attributes.other_money_value2#i#"))>#evaluate("attributes.other_money_value2#i#")#,<cfelse>NULL,</cfif>
						OTHER_MONEY2=<cfif len(evaluate("attributes.other_money2#i#"))><cfqueryparam cfsqltype="cf_sql_varchar" value='#wrk_eval("attributes.other_money2#i#")#'><cfelse>NULL</cfif>
					WHERE 
						CHEQUE_ID= #evaluate("attributes.cheque_id#i#")# AND
						PAYROLL_ID = #attributes.id#
				</cfquery>
			</cfif>
			<cfif is_cheque_based eq 1 and is_upd_cari_row eq 1>
				<cfquery name="UPD_CHEQUE" datasource="#dsn2#">
					UPDATE
						CARI_ROWS
					SET
						RATE2=#currency_multiplier_payroll#,
						<cfif len(evaluate("attributes.cheque_system_currency_value#i#")) and len(currency_multiplier_payroll)>OTHER_CASH_ACT_VALUE = #wrk_round(evaluate("attributes.cheque_system_currency_value#i#")/currency_multiplier_payroll)#,</cfif>
						<cfif len(evaluate("attributes.system_money_info#i#"))>OTHER_MONEY = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.basket_money#">,</cfif>
						<cfif len(evaluate("attributes.other_money_value2#i#"))>ACTION_VALUE_2 = #wrk_round(evaluate("attributes.cheque_system_currency_value#i#")/currency_multiplier)#,</cfif>
						<cfif len(evaluate("attributes.other_money2#i#"))>ACTION_CURRENCY_2 = <cfqueryparam cfsqltype="cf_sql_varchar" value="#session.ep.money2#">,</cfif>
						ACTION_ID = #evaluate("attributes.cheque_id#i#")#
					WHERE
						ACTION_ID = #evaluate("attributes.cheque_id#i#")# AND
						ACTION_TYPE_ID IN (90,106) AND
						ACTION_TABLE = 'CHEQUE'
				</cfquery>
			</cfif>
		</cfif>
	</cfloop>
	<!--- upd muhasebe ve butce--->
	<cfscript>
		butce_sil(action_id:attributes.id,process_type:form.old_process_type);
		
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
				detail : 'ÇEK ÇIKIŞ MASRAFI',
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
				muhasebe_sil(action_id:attributes.id,action_table:'PAYROLL',process_type:form.old_process_type,belge_no:form.payroll_no);
				/*GET_CHEQUES_LAST=cfquery(datasource:"#dsn2#",sqlstring:"SELECT 
								CHEQUE.* 
							FROM
								CHEQUE, 
								CHEQUE_HISTORY 
							WHERE
								CHEQUE.CHEQUE_ID=CHEQUE_HISTORY.CHEQUE_ID
								AND PAYROLL_ID=#attributes.id#");
				cheq_no_list=valuelist(GET_CHEQUES_LAST.CHEQUE_NO);
				ches_2 = ches;*/
				/*bordrodan cıkarılan cekler bulunuyor*/
				/*for(cheq_x=1; cheq_x lte attributes.record_num; cheq_x=cheq_x+1)
				{
					if (evaluate("attributes.row_kontrol#cheq_x#"))
						if(len(evaluate("attributes.cheque_id#cheq_x#")) and ListFindNoCase(ches_2,evaluate("attributes.cheque_id#cheq_x#")))
							ches_2 = ListDeleteAt(ches_2,ListFindNoCase(ches_2,evaluate("attributes.cheque_id#cheq_x#"), ','), ',');
				}*/
				//20140516 Kullanilmadigi icin kapatildi, sorun olursa kontrol edebilebilir.
				alacak_hesaplar = '';
				alacak_tutarlar = '';
				other_amount_alacak_list = '';
				other_currency_alacak_list = '';
				acc = '';
				toplam = '';
				other_amount_borc_list= '';
				other_currency_borc_list= '';
				satir_detay_list = ArrayNew(2);
				get_bank_acc_code = cfquery(datasource:"#dsn2#",sqlstring:"SELECT CHEQUE_EXCHANGE_CODE,ACCOUNT_ACC_CODE FROM #dsn3_alias#.ACCOUNTS AS ACCOUNTS WHERE ACCOUNT_ID =#attributes.account_id#");
				for(i=1; i lte attributes.record_num; i=i+1)
				{
					if (evaluate("attributes.row_kontrol#i#"))
					{
						if(evaluate("attributes.currency_id#i#") is session.ep.money)
							alacak_tutarlar=listappend(alacak_tutarlar,evaluate("attributes.cheque_value#i#"),',');
						else
							alacak_tutarlar=listappend(alacak_tutarlar,evaluate("attributes.cheque_system_currency_value#i#"),',');
						other_currency_alacak_list = listappend(other_currency_alacak_list,evaluate("attributes.currency_id#i#"),',');
						other_amount_alacak_list =  listappend(other_amount_alacak_list,evaluate("attributes.cheque_value#i#"),',');
						/*if(listfind('1,2,3,5',evaluate("attributes.cheque_status_id#i#"),',')) geriye donuk bordro guncellemede sorun olmaması icin kaldırıldı.
						{wrk_not : 
							bankada ilgili olabilecek bir durumunda olmayan bir cek icin hesap secilemez, bunu yapamazsa muasebeci calismaz,
							durum saglamasi yapiliyor
						*/
						GET_ACC_CODE=cfquery(datasource:"#dsn2#",sqlstring:"SELECT
									C.A_CHEQUE_ACC_CODE
								FROM
									PAYROLL AS P,
									CHEQUE_HISTORY AS CH,
									CASH AS C
								WHERE
									P.TRANSFER_CASH_ID = C.CASH_ID AND
									P.PAYROLL_TYPE IN (135) AND
									P.ACTION_ID= CH.PAYROLL_ID AND
									CH.CHEQUE_ID=#evaluate("attributes.cheque_id#i#")#
								ORDER BY
									CH.HISTORY_ID DESC");
						if(GET_ACC_CODE.recordcount eq 0)
						{
							GET_ACC_CODE=cfquery(datasource:"#dsn2#", sqlstring:"
								SELECT
									C.A_CHEQUE_ACC_CODE
								FROM
									PAYROLL AS P,
									CHEQUE_HISTORY AS CH,
									CASH AS C
								WHERE
									P.PAYROLL_CASH_ID = C.CASH_ID AND
									(P.PAYROLL_TYPE=90 OR (P.PAYROLL_TYPE=106 AND P.PAYROLL_NO='-1') OR P.PAYROLL_TYPE = 105) AND
									P.ACTION_ID= CH.PAYROLL_ID AND
									CH.CHEQUE_ID=#evaluate("attributes.cheque_id#i#")#");
						}
						alacak_hesaplar=listappend(alacak_hesaplar, GET_ACC_CODE.A_CHEQUE_ACC_CODE, ',');
						if (is_account_group neq 1)
						{ 	
							if(attributes.x_detail_acc_card eq 1) //detaylı muhasebe seçilmişse çek bilgilerini yazıyoruz
								satir_detay_list[2][listlen(alacak_tutarlar)]='Ç.Ç.B.B.:#attributes.payroll_no#:#evaluate("attributes.bank_name#i#")#:#evaluate("attributes.bank_branch_name#i#")#:#evaluate("attributes.account_no#i#")#'; //satır acıklamaları borc acıklama aray e set edilir.
							else if(isDefined("attributes.action_detail") and len(attributes.action_detail))
								satir_detay_list[2][listlen(alacak_tutarlar)] = ' #evaluate("attributes.cheque_no#i#")# - #attributes.action_detail#';
							else
								satir_detay_list[2][listlen(alacak_tutarlar)] = ' #evaluate("attributes.cheque_no#i#")# - ÇEK BANKA ÇIKIŞ İŞLEMİ';
						}
						else
						{
							if(attributes.x_detail_acc_card eq 1) //detaylı muhasebe seçilmişse çek bilgilerini yazıyoruz
								satir_detay_list[2][listlen(alacak_tutarlar)]='Ç.Ç.B.B.:#attributes.payroll_no#:#evaluate("attributes.bank_name#i#")#:#evaluate("attributes.bank_branch_name#i#")#:#evaluate("attributes.account_no#i#")#'; //satır acıklamaları borc acıklama aray e set edilir.
							else if(isDefined("attributes.action_detail") and len(attributes.action_detail))
								satir_detay_list[2][listlen(alacak_tutarlar)] = ' #attributes.action_detail#';
							else
								satir_detay_list[2][listlen(alacak_tutarlar)] = ' ÇEK BANKA ÇIKIŞ İŞLEMİ';
						}
					}
				}
				acc = get_bank_acc_code.CHEQUE_EXCHANGE_CODE;
				toplam = attributes.payroll_total;
				other_amount_borc_list=wrk_round(attributes.payroll_total/acc_currency_rate);
				other_currency_borc_list= attributes.currency_id;
				if(isDefined("attributes.action_detail") and len(attributes.action_detail))
					satir_detay_list[1][1] = ' #attributes.action_detail#';
				else
					satir_detay_list[1][1] = ' ÇEK BANKA ÇIKIŞ İŞLEMİ';
				if(len(attributes.exp_item_id) and len(attributes.exp_item_name) and isdefined("attributes.masraf") and (attributes.masraf gt 0) and len(attributes.expense_center))
				{ /* masraf hesaplarini da muhasebe hesap ve tutarlara dahil edelim */
					alacak_hesaplar=listappend(alacak_hesaplar,get_bank_acc_code.ACCOUNT_ACC_CODE, ',');
					alacak_tutarlar=listappend(alacak_tutarlar,attributes.sistem_masraf_tutari,',');
					other_amount_alacak_list=listappend(other_amount_alacak_list,attributes.masraf,',');
					other_currency_alacak_list=listappend(other_currency_alacak_list,attributes.masraf_currency,',');
					acc='#acc#,#GET_EXP_ACC.ACCOUNT_CODE#';
					toplam='#toplam#,#attributes.sistem_masraf_tutari#';
					other_amount_borc_list=listappend(other_amount_borc_list,attributes.masraf,',');
					other_currency_borc_list=listappend(other_currency_borc_list,attributes.masraf_currency,',');
					if(isDefined("attributes.action_detail") and len(attributes.action_detail))
					{
						satir_detay_list[2][listlen(alacak_tutarlar)] = ' #attributes.action_detail#';
						satir_detay_list[1][2] = ' #attributes.action_detail#';
					}
					else
					{
						satir_detay_list[2][listlen(alacak_tutarlar)] = ' ÇEK BANKA ÇIKIŞ İŞLEMİ';
						satir_detay_list[1][2] = ' ÇEK BANKA ÇIKIŞ İŞLEMİ';
					}
				}
				muhasebeci (
					action_id: attributes.id,
					workcube_process_type: process_type,
					workcube_old_process_type : form.old_process_type,
					account_card_type: 13,
					action_table :'PAYROLL',
					islem_tarihi: attributes.PAYROLL_REVENUE_DATE,
					borc_hesaplar: acc,
					borc_tutarlar: toplam,
					other_amount_borc: other_amount_borc_list,
					other_currency_borc: other_currency_borc_list,
					alacak_hesaplar: alacak_hesaplar,
					alacak_tutarlar: alacak_tutarlar,
					other_amount_alacak: other_amount_alacak_list,
					other_currency_alacak: other_currency_alacak_list,
					currency_multiplier : currency_multiplier,
					fis_detay:'ÇEK BANKA ÇIKIŞ İŞLEMİ',
					fis_satir_detay:satir_detay_list,
					belge_no : form.payroll_no,
					from_branch_id : branch_id_info,
					workcube_process_cat : form.process_cat,
					is_account_group : is_account_group
				);
			}
			else		/*e-deftere uygun muhasebe islemleri yapılıyor*/
			{
				// tum muhasebe kayıtlari silinir sonra yaniden eklenir.
				muhasebe_sil(action_id:attributes.id,action_table:'PAYROLL',process_type:form.old_process_type,belge_no:form.payroll_no);
				
				alacak_hesap = '';
				alacak_tutar = '';
				project_id = '';
				satir_detay_list = ArrayNew(2);
				get_bank_acc_code = cfquery(datasource:"#dsn2#",sqlstring:"SELECT CHEQUE_EXCHANGE_CODE,ACCOUNT_ACC_CODE FROM #dsn3_alias#.ACCOUNTS AS ACCOUNTS WHERE ACCOUNT_ID =#attributes.account_id#");
				
				for(i=1; i lte attributes.record_num; i=i+1)
				{
					if (evaluate("attributes.row_kontrol#i#"))
					{
						if(evaluate("attributes.currency_id#i#") is session.ep.money)
							alacak_tutar = evaluate("attributes.cheque_value#i#");
						else
							alacak_tutar = evaluate("attributes.cheque_system_currency_value#i#");
						
						GET_ACC_CODE=cfquery(datasource:"#dsn2#",sqlstring:"SELECT
									C.A_CHEQUE_ACC_CODE,
									P.PROJECT_ID
								FROM
									PAYROLL AS P,
									CHEQUE_HISTORY AS CH,
									CASH AS C
								WHERE
									P.TRANSFER_CASH_ID = C.CASH_ID AND
									P.PAYROLL_TYPE IN (135) AND
									P.ACTION_ID= CH.PAYROLL_ID AND
									CH.CHEQUE_ID=#evaluate("attributes.cheque_id#i#")#
								ORDER BY
									CH.HISTORY_ID DESC");
						if(GET_ACC_CODE.recordcount eq 0)
						{
							GET_ACC_CODE=cfquery(datasource:"#dsn2#", sqlstring:"
								SELECT
									C.A_CHEQUE_ACC_CODE,
									P.PROJECT_ID
								FROM
									PAYROLL AS P,
									CHEQUE_HISTORY AS CH,
									CASH AS C
								WHERE
									P.PAYROLL_CASH_ID = C.CASH_ID AND
									(P.PAYROLL_TYPE=90 OR (P.PAYROLL_TYPE=106 AND P.PAYROLL_NO='-1') OR P.PAYROLL_TYPE = 105) AND
									P.ACTION_ID= CH.PAYROLL_ID AND
									CH.CHEQUE_ID=#evaluate("attributes.cheque_id#i#")#");
						}
						alacak_hesap = GET_ACC_CODE.A_CHEQUE_ACC_CODE;
						project_id = GET_ACC_CODE.PROJECT_ID;
						if (is_account_group neq 1)
						{ 	
							if(isDefined("attributes.action_detail") and len(attributes.action_detail))
								satir_detay_list[2][1] = ' #evaluate("attributes.cheque_no#i#")# - #attributes.action_detail#';
							else
								satir_detay_list[2][1] = ' #evaluate("attributes.cheque_no#i#")# - ÇEK BANKA ÇIKIŞ İŞLEMİ';
						}
						else
						{
							if(isDefined("attributes.action_detail") and len(attributes.action_detail))
								satir_detay_list[2][1] = ' #attributes.action_detail#';
							else
								satir_detay_list[2][1] = ' ÇEK BANKA ÇIKIŞ İŞLEMİ';
						}
						if(isDefined("attributes.action_detail") and len(attributes.action_detail))
							satir_detay_list[1][1] = ' #attributes.action_detail#';
						else
							satir_detay_list[1][1] = ' ÇEK BANKA ÇIKIŞ İŞLEMİ';
							
						muhasebeci (
							action_id: attributes.id,
							action_row_id : evaluate("attributes.CHEQUE_ID#i#"),
							due_date :iif(len(evaluate("attributes.CHEQUE_DUEDATE#i#")),'createodbcdatetime(evaluate("attributes.CHEQUE_DUEDATE#i#"))','attributes.pyrll_avg_duedate'),
							workcube_process_type: process_type,
							workcube_old_process_type : form.old_process_type,
							account_card_type: 13,
							action_table :'PAYROLL',
							islem_tarihi: attributes.PAYROLL_REVENUE_DATE,
							borc_hesaplar: get_bank_acc_code.CHEQUE_EXCHANGE_CODE,
							borc_tutarlar: alacak_tutar,
							other_amount_borc: wrk_round(evaluate("attributes.cheque_system_currency_value#i#")/acc_currency_rate),
							other_currency_borc: attributes.currency_id,
							alacak_hesaplar: alacak_hesap,
							alacak_tutarlar: alacak_tutar,
							other_amount_alacak: evaluate("attributes.cheque_value#i#"),
							other_currency_alacak: evaluate("attributes.currency_id#i#"),
							currency_multiplier : currency_multiplier,
							fis_detay:'ÇEK BANKA ÇIKIŞ İŞLEMİ',
							fis_satir_detay:satir_detay_list,
							belge_no : evaluate("attributes.cheque_no#i#"),
							from_branch_id : branch_id_info,
							workcube_process_cat : form.process_cat,
							is_account_group : is_account_group,
							acc_project_id = project_id
						);	
					}
				}
				
				if(len(attributes.exp_item_id) and len(attributes.exp_item_name) and isdefined("attributes.masraf") and (attributes.masraf gt 0) and len(attributes.expense_center))
				{ /* masraf hesaplarini da muhasebe hesap ve tutarlara dahil edelim */
					if(isDefined("attributes.action_detail") and len(attributes.action_detail))
					{
						satir_detay_list[2][1] = ' #attributes.action_detail#';
						satir_detay_list[1][2] = ' #attributes.action_detail#';
					}
					else
					{
						satir_detay_list[2][1] = ' ÇEK BANKA ÇIKIŞ MASRAFI';
						satir_detay_list[1][2] = ' ÇEK BANKA ÇIKIŞ MASRAFI';
					}
					muhasebeci (
						action_id: attributes.id,
						workcube_process_type: process_type,
						workcube_old_process_type: form.old_process_type,
						account_card_type: 13,
						action_table :'PAYROLL',
						islem_tarihi: attributes.PAYROLL_REVENUE_DATE,
						borc_hesaplar: GET_EXP_ACC.ACCOUNT_CODE,
						borc_tutarlar: attributes.sistem_masraf_tutari,
						other_amount_borc: attributes.masraf,
						other_currency_borc: attributes.masraf_currency,
						alacak_hesaplar:get_bank_acc_code.ACCOUNT_ACC_CODE,
						alacak_tutarlar:attributes.sistem_masraf_tutari,
						other_amount_alacak: attributes.masraf,
						other_currency_alacak: attributes.masraf_currency,
						currency_multiplier : currency_multiplier,
						fis_detay:'ÇEK BANKA ÇIKIŞ MASRAFI',
						fis_satir_detay:satir_detay_list,
						belge_no : form.payroll_no,
						from_branch_id : branch_id_info,
						workcube_process_cat : form.process_cat
					);	
				}
			}
		}
		else
		{
			muhasebe_sil(action_id:attributes.id,action_table:'PAYROLL',process_type:form.old_process_type);
		}
		basket_kur_ekle(action_id:attributes.id,table_type_id:11,process_type:1);
		</cfscript>
		<!--- eger masraf tutarı girilmiş ise ve gider kalemi seçili ise bankaya ait kayıt oluşturur --->
		<cfset is_upd_action = 1>
		<cfif len(attributes.exp_item_id) and len(attributes.exp_item_name) and (attributes.masraf gt 0) and len(attributes.expense_center)>
			<cfinclude template="add_cheque_bank_masraf.cfm">
		<cfelse>
			<cfquery name="DEL_BANK_ACTIONS" datasource="#dsn2#">
				DELETE FROM BANK_ACTIONS WHERE PAYROLL_ID=#attributes.id#
			</cfquery>
		</cfif> 
		<cf_workcube_process_cat 
			process_cat="#form.process_cat#"
			old_process_cat_id = "#attributes.old_process_cat_id#"
			action_id = #attributes.id#
			is_action_file = 1
			action_db_type = '#dsn2#'
			action_page='#request.self#?fuseaction=cheque.form_add_payroll_bank_guaranty&event=upd&ID=#attributes.id#'
			action_file_name='#get_process_type.action_file_name#'
			is_template_action_file = '#get_process_type.action_file_from_template#'>
    <cf_add_log log_type="0" action_id="#attributes.id#" action_name="#attributes.payroll_no# Güncellendi" paper_no="#form.payroll_no#" period_id="#session.ep.period_id#" process_type="#get_process_type.PROCESS_TYPE#" data_source="#dsn2#">
	</cftransaction>
</cflock> 
<script type="text/javascript">
	window.location.href="<cfoutput>#request.self#?fuseaction=cheque.form_add_payroll_bank_guaranty&event=upd&ID=#attributes.id#</cfoutput>";
</script>
<cf_get_lang_set module_name="#lcase(listgetat(attributes.fuseaction,1,'.'))#">
