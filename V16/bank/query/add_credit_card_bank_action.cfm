<!---Select ifadeleri düzenlendi. e.a 23.07.2012--->
<cfquery name="get_process_type" datasource="#dsn3#">
	SELECT 
		PROCESS_TYPE,
		IS_CARI,
		IS_ACCOUNT,
		IS_PROJECT_BASED_ACC,
		IS_PROJECT_BASED_BUDGET
	 FROM 
		SETUP_PROCESS_CAT 
	WHERE 
		PROCESS_CAT_ID = #form.process_cat#
</cfquery>
<cfset process_type = get_process_type.PROCESS_TYPE>
<cfset is_account = get_process_type.IS_ACCOUNT>
<cf_date tarih='attributes.start_date'>
<cf_papers paper_type="creditcard_cc_bank_action">
<cfset full_paper_no = paper_code & '-' & paper_number>
<cfquery name="GET_ALL_MONEY" datasource="#DSN2#">
	SELECT MONEY,RATE2 FROM SETUP_MONEY
</cfquery>
<cfoutput query="GET_ALL_MONEY">
	<cfset "rate_2_#money#" = rate2>
</cfoutput>
<cfif len(attributes.checked_value)>
	<cfquery name="GET_PAYMENT_ROWS" datasource="#dsn2#">
		SELECT
			PAYMENTS_ROWS.ACTION_TO_ACCOUNT_ID,
			PAYMENTS_ROWS.PAYMENT_TYPE_ID,
			PAYMENTS_ROWS.BANK_ACTION_DATE,
			PAYMENTS_ROWS.OTHER_MONEY,
			PAYMENTS_ROWS.PROJECT_ID,
			SUM(DOVIZ_TOPLAM1-DOVIZ_TOPLAM2) DOVIZ_TOPLAM,
			SUM(COMS_TOPLAM1-COMS_TOPLAM2) COMS_TOPLAM,
			SUM(TOPLAM1-TOPLAM2) TOPLAM
		FROM
		(
			SELECT
				CCP.ACTION_TO_ACCOUNT_ID,
				CCP_R.PAYMENT_TYPE_ID,
				CCP_R.BANK_ACTION_DATE,
				CCP.PROJECT_ID,
				<cfif session.ep.period_year lt 2009>
					CASE WHEN(CCP.OTHER_MONEY = 'TL') THEN 'YTL' ELSE CCP.OTHER_MONEY END AS OTHER_MONEY,
				<cfelse>
					CASE WHEN(CCP.OTHER_MONEY = 'YTL') THEN 'TL' ELSE CCP.OTHER_MONEY END AS OTHER_MONEY,
				</cfif>
				SUM(CCP_R.AMOUNT/(CCP.SALES_CREDIT/CCP.OTHER_CASH_ACT_VALUE)) DOVIZ_TOPLAM1,
				0 DOVIZ_TOPLAM2,
				SUM(CCP_R.COMMISSION_AMOUNT) COMS_TOPLAM1,
				0 COMS_TOPLAM2,
				SUM(CCP_R.AMOUNT) TOPLAM1,
				0 TOPLAM2
			FROM
				#dsn3_alias#.CREDIT_CARD_BANK_PAYMENTS CCP,
				#dsn3_alias#.CREDIT_CARD_BANK_PAYMENTS_ROWS CCP_R
			WHERE
				CCP.CREDITCARD_PAYMENT_ID = CCP_R.CREDITCARD_PAYMENT_ID AND
				CCP_R.CC_BANK_PAYMENT_ROWS_ID IN (#attributes.checked_value#) AND
				CCP.ACTION_TYPE_ID <> 245<!--- iptal dışındakiler--->
			GROUP BY
				CCP.ACTION_TO_ACCOUNT_ID,
				CCP.OTHER_MONEY,
				CCP_R.PAYMENT_TYPE_ID,
				CCP_R.BANK_ACTION_DATE,
				CCP.PROJECT_ID
		UNION ALL
			SELECT
				CCP.ACTION_TO_ACCOUNT_ID,
				CCP_R.PAYMENT_TYPE_ID,
				CCP_R.BANK_ACTION_DATE,
				CCP.PROJECT_ID,
				<cfif session.ep.period_year lt 2009>
					CASE WHEN(CCP.OTHER_MONEY = 'TL') THEN 'YTL' ELSE CCP.OTHER_MONEY END AS OTHER_MONEY,
				<cfelse>
					CASE WHEN(CCP.OTHER_MONEY = 'YTL') THEN 'TL' ELSE CCP.OTHER_MONEY END AS OTHER_MONEY,
				</cfif>
				0 DOVIZ_TOPLAM1,
				SUM(CCP_R.AMOUNT/(CCP.SALES_CREDIT/CCP.OTHER_CASH_ACT_VALUE)) DOVIZ_TOPLAM2,
				0 COMS_TOPLAM1,
				SUM(CCP_R.COMMISSION_AMOUNT) COMS_TOPLAM2,
				0 TOPLAM1,
				SUM(CCP_R.AMOUNT) TOPLAM2
			FROM
				#dsn3_alias#.CREDIT_CARD_BANK_PAYMENTS CCP,
				#dsn3_alias#.CREDIT_CARD_BANK_PAYMENTS_ROWS CCP_R
			WHERE
				CCP.CREDITCARD_PAYMENT_ID = CCP_R.CREDITCARD_PAYMENT_ID AND
				CCP_R.CC_BANK_PAYMENT_ROWS_ID IN (#attributes.checked_value#) AND
				CCP.ACTION_TYPE_ID = 245<!--- kredi kartı tahsilat iptal --->
			GROUP BY
				CCP.ACTION_TO_ACCOUNT_ID,
				CCP.OTHER_MONEY,
				CCP_R.PAYMENT_TYPE_ID,
				CCP_R.BANK_ACTION_DATE,
				CCP.PROJECT_ID
		) AS PAYMENTS_ROWS
	GROUP BY
		PAYMENTS_ROWS.ACTION_TO_ACCOUNT_ID,
		PAYMENTS_ROWS.PAYMENT_TYPE_ID,
		PAYMENTS_ROWS.BANK_ACTION_DATE,
		PAYMENTS_ROWS.OTHER_MONEY,
		PAYMENTS_ROWS.PROJECT_ID
	ORDER BY
		PAYMENTS_ROWS.PAYMENT_TYPE_ID
	</cfquery>
	<cfoutput query="GET_PAYMENT_ROWS">
		<cflock name="#CreateUUID()#" timeout="60">
			<cftransaction>
				<cfif len(GET_PAYMENT_ROWS.OTHER_MONEY) and GET_PAYMENT_ROWS.DOVIZ_TOPLAM gt 0>
					<cfset currency_info = wrk_round(abs(GET_PAYMENT_ROWS.TOPLAM/GET_PAYMENT_ROWS.DOVIZ_TOPLAM))>
				<cfelse>
					<cfset currency_info = 1>
				</cfif>
				<cfquery name="ADD_BANK" datasource="#dsn2#" result="MAX_ID">
					INSERT INTO
						BANK_ACTIONS
						(
							ACTION_TYPE,
							PROCESS_CAT,
							ACTION_TYPE_ID,
							PAPER_NO,
							<cfif process_type eq 243>ACTION_TO_ACCOUNT_ID,<cfelse>ACTION_FROM_ACCOUNT_ID,</cfif>
							ACTION_VALUE,<!--- hesaba geçiş işlemlerinde masraf çıkarılmış tutar bank_actions a yazılır ---><!--- view de bu değerden çıkartılıp getirildiği için sadece amount değer atandı MK--->
							MASRAF,
							ACTION_DATE,
							ACTION_CURRENCY_ID,
							ACTION_DETAIL,
							OTHER_CASH_ACT_VALUE,
							OTHER_MONEY,
							IS_ACCOUNT,
							IS_ACCOUNT_TYPE,
							RECORD_EMP,
							RECORD_IP,
							RECORD_DATE,
							<cfif process_type eq 243>TO_BRANCH_ID<cfelse>FROM_BRANCH_ID</cfif>,
							SYSTEM_ACTION_VALUE,
							SYSTEM_CURRENCY_ID,
							EXPENSE_CENTER_ID,
							EXPENSE_ITEM_ID
							<cfif len(session.ep.money2)>
								,ACTION_VALUE_2
								,ACTION_CURRENCY_ID_2
							</cfif>
						)
						VALUES
						(
							<cfif process_type eq 243>'KREDİ KARTI HESABA GEÇİŞ',<cfelse>'KREDİ KARTI HESABA GEÇİŞ İPTAL',</cfif>
							#form.process_cat#,
							#process_type#,
							'#full_paper_no#',
							#GET_PAYMENT_ROWS.ACTION_TO_ACCOUNT_ID#,
							#abs(GET_PAYMENT_ROWS.TOPLAM)#,
							#evaluate("attributes.masraf_#currentrow#")#,
							#attributes.start_date#,
							'#session.ep.money#',<!--- zaten tahsilatlar sistem para birimi dışnda olmadgndan sıkıntı olmaz --->
							<cfif len(attributes.action_detail)>'#left(attributes.action_detail,250)#',<cfelse>NULL,</cfif>
							<cfif len(GET_PAYMENT_ROWS.DOVIZ_TOPLAM)>#wrk_round(abs(GET_PAYMENT_ROWS.DOVIZ_TOPLAM))#,<cfelse>NULL,</cfif>
							<cfif len(GET_PAYMENT_ROWS.OTHER_MONEY)>'#GET_PAYMENT_ROWS.OTHER_MONEY#',<cfelse>NULL,</cfif>
							<cfif is_account eq 1>1,13,<cfelse>0,13,</cfif>
							#session.ep.userid#,
							'#cgi.REMOTE_ADDR#',
							#now()#,
							#listgetat(session.ep.user_location,2,'-')#,
							#abs(GET_PAYMENT_ROWS.TOPLAM)#,
							'#session.ep.money#',
							<cfif len(attributes.expense_center_id)>#attributes.expense_center_id#<cfelse>NULL</cfif>,
							<cfif len(attributes.expense_item_id)>#attributes.expense_item_id#<cfelse>NULL</cfif>
							<cfif len(session.ep.money2)>
								,#wrk_round((abs(GET_PAYMENT_ROWS.TOPLAM))/evaluate("rate_2_#session.ep.money2#"),4)#
								,'#session.ep.money2#'
							</cfif>
						)
				</cfquery>
				<cfquery name="UPD_BANK" datasource="#dsn2#">
					UPDATE
						#dsn3_alias#.CREDIT_CARD_BANK_PAYMENTS_ROWS
					SET
						BANK_ACTION_ID = #MAX_ID.IDENTITYCOL#,
						BANK_ACTION_PERIOD_ID = #session.ep.period_id#
					WHERE
						CC_BANK_PAYMENT_ROWS_ID IN (#attributes.checked_value#) AND
						PAYMENT_TYPE_ID = #GET_PAYMENT_ROWS.PAYMENT_TYPE_ID# AND
						BANK_ACTION_DATE = #CreateODBCDateTime(GET_PAYMENT_ROWS.BANK_ACTION_DATE)# AND
						CREDITCARD_PAYMENT_ID IN 
						(
							SELECT 
								CREDIT_CARD_BANK_PAYMENTS.CREDITCARD_PAYMENT_ID
							FROM
								#dsn3_alias#.CREDIT_CARD_BANK_PAYMENTS CREDIT_CARD_BANK_PAYMENTS
							WHERE
								CREDIT_CARD_BANK_PAYMENTS.ACTION_TO_ACCOUNT_ID = #GET_PAYMENT_ROWS.ACTION_TO_ACCOUNT_ID# AND
							<cfif session.ep.period_year lt 2009>
								CREDIT_CARD_BANK_PAYMENTS.OTHER_MONEY = '#GET_PAYMENT_ROWS.OTHER_MONEY#' OR (CREDIT_CARD_BANK_PAYMENTS.OTHER_MONEY = 'TL' AND '#GET_PAYMENT_ROWS.OTHER_MONEY#' = 'YTL')
							<cfelse>
								CREDIT_CARD_BANK_PAYMENTS.OTHER_MONEY = '#GET_PAYMENT_ROWS.OTHER_MONEY#' OR (CREDIT_CARD_BANK_PAYMENTS.OTHER_MONEY = 'YTL' AND '#GET_PAYMENT_ROWS.OTHER_MONEY#' = 'TL')
							</cfif>
								
						)
				</cfquery>
				<cfquery name="GET_ACCOUNT" datasource="#dsn2#">
					SELECT ACCOUNT_ACC_CODE FROM #dsn3_alias#.ACCOUNTS WHERE ACCOUNT_ID = #GET_PAYMENT_ROWS.ACTION_TO_ACCOUNT_ID#
				</cfquery>
				<cfquery name="GET_PAY_TYPE_ACC" datasource="#dsn2#">
					SELECT ACCOUNT_CODE FROM #dsn3_alias#.CREDITCARD_PAYMENT_TYPE WHERE PAYMENT_TYPE_ID = #GET_PAYMENT_ROWS.PAYMENT_TYPE_ID#
				</cfquery>
				<cfscript>
					if(evaluate("attributes.masraf_#currentrow#") gt 0)
					{
						project_id_info = (len(GET_PAYMENT_ROWS.PROJECT_ID) and get_process_type.is_project_based_budget eq 1) ? GET_PAYMENT_ROWS.PROJECT_ID : "";

						butceci(
							action_id : MAX_ID.IDENTITYCOL,
							muhasebe_db : dsn2,
							is_income_expense : iif((process_type eq 243),false,true),
							process_type : process_type,
							nettotal : evaluate("attributes.masraf_#currentrow#"),
							other_money_value : wrk_round(evaluate("attributes.masraf_#currentrow#")/currency_info),
							action_currency : GET_PAYMENT_ROWS.OTHER_MONEY,
							currency_multiplier : currency_info,
							expense_date : attributes.start_date,
							expense_center_id : attributes.expense_center_id,
							expense_item_id : attributes.expense_item_id,
							detail : iif((process_type eq 243),de('HESABA GEÇİŞ MASRAFI'),de('HESABA GEÇİŞ İPTAL TUTARI')),
							paper_no : full_paper_no,
							branch_id : listgetat(session.ep.user_location,2,'-'),
							project_id : project_id_info,
							insert_type : 1//banka vs den eklenen masraflar için farklı ekleme metodu tanımlar
						);
					}
					if(len(attributes.expense_item_id))
					GET_EXP_ACC = cfquery(datasource : "#dsn2#", sqlstring : "SELECT ACCOUNT_CODE FROM EXPENSE_ITEMS WHERE EXPENSE_ITEM_ID = #attributes.expense_item_id#");
				
					if (is_account)//sadece sistem para birimi işlemleri yapılır tahsilatlarda
					{	
						//borc
						str_borclu_hesaplar = GET_ACCOUNT.ACCOUNT_ACC_CODE;
						str_borclu_tutarlar = abs(GET_PAYMENT_ROWS.TOPLAM);
						str_other_borclu_tutarlar = abs(GET_PAYMENT_ROWS.TOPLAM);
						str_other_borclu_currency = session.ep.money;
						//alacak
						str_alacak_hesaplar = GET_PAY_TYPE_ACC.ACCOUNT_CODE;
						str_alacak_tutarlar = abs(GET_PAYMENT_ROWS.TOPLAM);
						str_other_alacak_tutarlar = abs(GET_PAYMENT_ROWS.TOPLAM);
						str_other_alacak_currency = session.ep.money;
						project_id_info = (len(GET_PAYMENT_ROWS.PROJECT_ID) and get_process_type.is_project_based_acc eq 1) ? GET_PAYMENT_ROWS.PROJECT_ID : "";
						
						if(evaluate("attributes.masraf_#currentrow#") gt 0 and len(GET_EXP_ACC.ACCOUNT_CODE))
						{
							//borc
							str_borclu_hesaplar = ListAppend(str_borclu_hesaplar,GET_EXP_ACC.ACCOUNT_CODE, ",");	
							str_borclu_tutarlar = ListAppend(str_borclu_tutarlar,evaluate("attributes.masraf_#currentrow#"),",");
							str_other_borclu_tutarlar = ListAppend(str_other_borclu_tutarlar,evaluate("attributes.masraf_#currentrow#"),",");
							str_other_borclu_currency = ListAppend(str_other_borclu_currency,session.ep.money,",");	
							//alacak
							str_alacak_hesaplar = ListAppend(str_alacak_hesaplar,GET_ACCOUNT.ACCOUNT_ACC_CODE, ",");	
							str_alacak_tutarlar = ListAppend(str_alacak_tutarlar,evaluate("attributes.masraf_#currentrow#"),",");
							str_other_alacak_tutarlar = ListAppend(str_other_alacak_tutarlar,evaluate("attributes.masraf_#currentrow#"),",");
							str_other_alacak_currency = ListAppend(str_other_alacak_currency,session.ep.money,",");	
						}
						muhasebeci (
							action_id: MAX_ID.IDENTITYCOL,
							workcube_process_type: process_type,
							workcube_process_cat:form.process_cat,
							account_card_type: 13,
							belge_no : full_paper_no,
							islem_tarihi: attributes.start_date,
							fis_satir_detay: iif((process_type eq 243),de('KREDİ KARTI HESABA GEÇİŞ'),de('KREDİ KARTI HESABA GEÇİŞ İPTAL')),
							borc_hesaplar:  iif((process_type eq 243),de('#str_borclu_hesaplar#'),de('#str_alacak_hesaplar#')),
							borc_tutarlar: iif((process_type eq 243),de('#str_borclu_tutarlar#'),de('#str_alacak_tutarlar#')),
							other_amount_borc : iif((process_type eq 243),de('#str_other_borclu_tutarlar#'),de('#str_other_alacak_tutarlar#')),
							other_currency_borc : iif((process_type eq 243),de('#str_other_borclu_currency#'),de('#str_other_alacak_currency#')),
							alacak_hesaplar: iif((process_type eq 243),de('#str_alacak_hesaplar#'),de('#str_borclu_hesaplar#')),
							alacak_tutarlar: iif((process_type eq 243),de('#str_alacak_tutarlar#'),de('#str_borclu_tutarlar#')),
							other_amount_alacak : iif((process_type eq 243),de('#str_other_alacak_tutarlar#'),de('#str_other_borclu_tutarlar#')),
							other_currency_alacak : iif((process_type eq 243),de('#str_other_alacak_currency#'),de('#str_other_borclu_currency#')),
							to_branch_id : iif((process_type eq 243),listgetat(session.ep.user_location,2,'-'),de('')),
							from_branch_id : iif((process_type neq 243),listgetat(session.ep.user_location,2,'-'),de('')),
							fis_detay: iif((process_type eq 243),de('KREDİ KARTI HESABA GEÇİŞ'),de('KREDİ KARTI HESABA GEÇİŞ İPTAL')),
							acc_project_id : project_id_info
						);
					}
				</cfscript>
                <!--- Belge numarasi update ediliyor. --->
                <cfquery name="UPD_GEN_PAP" datasource="#DSN2#">
                    UPDATE 
                        #dsn3_alias#.GENERAL_PAPERS
                    SET
                        CREDITCARD_CC_BANK_ACTION_NUMBER = <cfqueryparam cfsqltype="cf_sql_integer" value="#paper_number#">
                    WHERE
                        CREDITCARD_CC_BANK_ACTION_NUMBER IS NOT NULL
                </cfquery>
			</cftransaction>
		</cflock>
	</cfoutput>
</cfif>
<script type="text/javascript">
	wrk_opener_reload();
	window.close();
</script>
