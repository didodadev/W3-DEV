<cfquery name="get_process_type" datasource="#dsn3#">
	SELECT 
		PROCESS_TYPE,
		IS_CARI,
		IS_ACCOUNT,
		IS_ACCOUNT_GROUP,
		IS_CHEQUE_BASED_ACTION,
		IS_BUDGET
	FROM 
		SETUP_PROCESS_CAT 
	WHERE 
		PROCESS_CAT_ID = #form.process_cat#
</cfquery>
<cfscript>
	process_type = get_process_type.PROCESS_TYPE;
	is_cari =get_process_type.IS_CARI;
	is_account = get_process_type.IS_ACCOUNT;
	is_account_group = get_process_type.IS_ACCOUNT_GROUP;
	is_voucher_based = get_process_type.IS_CHEQUE_BASED_ACTION;
	is_budget =get_process_type.IS_BUDGET;
</cfscript>
<cfscript>
	attributes.total_system_amount = filterNum(attributes.total_system_amount);
	for(r=1; r lte attributes.record_num; r=r+1)
	{
		'attributes.other_money_value_#r#' = filterNum(evaluate('attributes.other_money_value_#r#'));
		'attributes.f_other_money_value_#r#' = filterNum(evaluate('attributes.f_other_money_value_#r#'));
		'attributes.delay_interest_value_#r#' = filterNum(evaluate('attributes.delay_interest_value_#r#'));
		'attributes.new_closed_amount_#r#' = filterNum(evaluate('attributes.new_closed_amount_#r#'));
		'attributes.new_delay_closed_amount_#r#' = filterNum(evaluate('attributes.new_delay_closed_amount_#r#'));
		'attributes.payment_discount#r#' = filterNum(evaluate('attributes.payment_discount#r#'));
	}	
	PAPER = "#form.paper_code#-#form.paper_number#";
</cfscript>
<cfif is_account eq 1>
	<cfif len(attributes.company_id)>
		<cfset MY_ACC_RESULT = GET_COMPANY_PERIOD(attributes.company_id)>
	<cfelseif len(attributes.consumer_id)>
		<cfset MY_ACC_RESULT = GET_CONSUMER_PERIOD(attributes.consumer_id)>
	</cfif>
	<cfif not len(MY_ACC_RESULT)>
		<script type="text/javascript">
			alert("<cf_get_lang no ='126.Seçtiğiniz Üyenin Muhasebe Kodu Seçilmemiş'>!");
			history.back();	
		</script>
		<cfabort>
	</cfif>
</cfif>
<cfset attributes.basket_money = '#session.ep.money#'>
<cfset attributes.basket_money_rate = 1>
<cfset action_date = attributes.action_date>
<cf_date tarih = "action_date">
<cfquery name="get_moneys" datasource="#dsn2#">
	SELECT * FROM SETUP_MONEY
</cfquery>
<cfset currency_multiplier = ''>
<cfset currency_multiplier_system = ''>
<cfoutput query="get_moneys">
	<cfif get_moneys.money eq session.ep.money2>
		<cfset currency_multiplier = get_moneys.rate2 / get_moneys.rate1>
	</cfif>
	<cfif get_moneys.money eq session.ep.money>
		<cfset currency_multiplier_system = get_moneys.rate2 / get_moneys.rate1>
	</cfif>
</cfoutput>
<cflock name="#createUUID()#" timeout="60">
	<cftransaction>
		<cfset belge_no = get_cheque_no(belge_tipi:'voucher_payroll')>	
		<cfset my_payroll_no = belge_no>
		<cfset belge_no = get_cheque_no(belge_tipi:'voucher_payroll',belge_no:belge_no+1)>
		<cfquery name="ADD_REVENUE_TO_PAYROLL" datasource="#dsn2#">
			INSERT INTO
				VOUCHER_PAYROLL
				(
					PROCESS_CAT,
					PAYROLL_TYPE,
					COMPANY_ID,
					CONSUMER_ID,
					PAYROLL_TOTAL_VALUE,
					PAYROLL_OTHER_MONEY,
					PAYROLL_OTHER_MONEY_VALUE,
					PAYROLL_CASH_ID,
					NUMBER_OF_VOUCHER,
					CURRENCY_ID,
					PAYROLL_REVENUE_DATE,
					PAYROLL_REV_MEMBER,
					PAYROLL_AVG_DUEDATE,
					PAYROLL_NO,
					MASRAF,
					MASRAF_CURRENCY,
					RECORD_EMP,
					RECORD_IP,
					RECORD_DATE,
					VOUCHER_BASED_ACC_CARI,
					INCOME_CENTER_ID,
					INCOME_ITEM_ID
				)
				VALUES
				(
					#form.process_cat#,
					#process_type#,
					<cfif len(attributes.company_id)>#attributes.company_id#<cfelse>NULL</cfif>,
					<cfif len(attributes.consumer_id)>#attributes.consumer_id#<cfelse>NULL</cfif>,
					<cfif isdefined("attributes.cash") and attributes.cash eq 1>
						#attributes.cash_amount#,
					<cfelseif isdefined("attributes.is_bank") and attributes.is_bank eq 1>
						#attributes.bank_amount#,
					<cfelse>
						#attributes.pos_amount_first#,
					</cfif>
					'#attributes.CURRENCY_TYPE#',
					<cfif isdefined("attributes.cash") and attributes.cash eq 1>
						#attributes.cash_amount#,
					<cfelseif isdefined("attributes.is_bank") and attributes.is_bank eq 1>
						#attributes.bank_amount#,
					<cfelse>
						#attributes.pos_amount_first#,
					</cfif>
					<cfif isdefined("attributes.kasa") and len(attributes.kasa)> #listfirst(attributes.kasa,';')#<cfelseif isdefined("attributes.ACTION_TO_ACCOUNT_ID") and len(attributes.ACTION_TO_ACCOUNT_ID)>#listfirst(attributes.ACTION_TO_ACCOUNT_ID,';')# </cfif> ,
					#listlen(attributes.voucher_ids,',')#,
					'#attributes.CURRENCY_TYPE#',
					#action_date#,
					#session.ep.userid#,
					#action_date#,
					'#my_payroll_no#',
					0,
					NULL,
					#session.ep.userid#,
					'#CGI.REMOTE_ADDR#',
					#NOW()#,
					<cfif len(is_voucher_based)>#is_voucher_based#<cfelse>0</cfif>,
					<cfif len(attributes.expense_center_id)>#attributes.expense_center_id#<cfelse>NULL</cfif>,
					<cfif len(attributes.expense_item_id)>#attributes.expense_item_id#<cfelse>NULL</cfif>
				)
		</cfquery>
		<cfquery name="GET_BORDRO_ID" datasource="#dsn2#">
			SELECT MAX(ACTION_ID) AS P_ID FROM VOUCHER_PAYROLL
		</cfquery>
		<cfset p_id=get_bordro_id.P_ID>
		<cfset total_pay_term_value = 0>
		<!--- senet durumları senet tablosundan update ediliyor ve history kaydı, closed kayıtları yapılıyor --->
		<cfloop from="1" to="#attributes.record_num#" index="kk">
			<cfif listfind('1,11,10',evaluate("attributes.voucher_status_#kk#")) and isdefined("attributes.is_pay_#kk#") and listfind(attributes.voucher_ids_2,evaluate("attributes.voucher_id_#kk#"),',')>
				<cfquery name="UPD_VOUCHERS" datasource="#dsn2#">
					UPDATE 
						VOUCHER 
					SET 
						<cfif listfind(attributes.voucher_ids,evaluate("attributes.voucher_id_#kk#"),',')>
							VOUCHER_STATUS_ID=3,
						<cfelseif listfind(attributes.voucher_ids_3,evaluate("attributes.voucher_id_#kk#"),',')>
							VOUCHER_STATUS_ID=11,
						</cfif>
						DELAY_INTEREST_SYSTEM_VALUE = #evaluate("attributes.delay_interest_value_#kk#")#,
						DELAY_INTEREST_OTHER_VALUE = #evaluate("attributes.delay_interest_value_#kk#")#,
						DELAY_INTEREST_VALUE2 = #(evaluate("attributes.delay_interest_value_#kk#")/currency_multiplier)#,
						EARLY_PAYMENT_SYSTEM_VALUE = #evaluate("attributes.payment_discount#kk#")#,
						EARLY_PAYMENT_OTHER_VALUE = #evaluate("attributes.payment_discount#kk#")#,
						EARLY_PAYMENT_VALUE2 = #(evaluate("attributes.payment_discount#kk#")/currency_multiplier)#
					WHERE 
						VOUCHER_ID= #evaluate("attributes.voucher_id_#kk#")#
				</cfquery>
				<cfquery name="get_vouchers" datasource="#dsn2#">
					SELECT * FROM VOUCHER WHERE VOUCHER_ID = #evaluate("attributes.voucher_id_#kk#")#
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
							#evaluate("attributes.voucher_id_#kk#")#,
							#P_ID#,
							#get_vouchers.voucher_status_id#,
							#action_date#,
							#get_vouchers.other_money_value#,
							'#get_vouchers.other_money#',
							#get_vouchers.other_money_value2#,
							'#get_vouchers.other_money2#',
							#now()#
						)
				</cfquery>
				<cfquery name="get_cari_id" datasource="#dsn2#">
					SELECT CARI_ACTION_ID,ACTION_TYPE_ID,FROM_CMP_ID,FROM_CONSUMER_ID FROM CARI_ROWS WHERE ACTION_ID = #evaluate("attributes.voucher_id_#kk#")# AND ACTION_TYPE_ID IN(97,107)
				</cfquery>
				<cfif evaluate("attributes.new_delay_closed_amount_#kk#") gt 0>
					<cfquery name="add_voucher_close" datasource="#dsn2#">
						INSERT INTO
							VOUCHER_CLOSED
						(
							PAYROLL_ID,
							CARI_ACTION_ID,
							ACTION_ID,
							ACTION_TYPE_ID,
							ACTION_VALUE,
							CLOSED_AMOUNT,
							OTHER_CLOSED_AMOUNT,
							OTHER_MONEY,
							IS_VOUCHER_DELAY
						)
						VALUES
						(
							#p_id#,
							<cfif get_cari_id.recordcount>#get_cari_id.cari_action_id#,<cfelse>NULL,</cfif>
							#evaluate("attributes.voucher_id_#kk#")#,
							<cfif get_cari_id.recordcount>#get_cari_id.action_type_id#,<cfelse>NULL,</cfif>
							#evaluate("attributes.delay_interest_value_#kk#")#,
							#evaluate("attributes.new_delay_closed_amount_#kk#")#,
							#evaluate("attributes.new_delay_closed_amount_#kk#")#,
							'#session.ep.money#',
							1
						)
					</cfquery>
				</cfif>
				<cfif evaluate("attributes.new_closed_amount_#kk#") gt 0>
					<cfquery name="add_voucher_close" datasource="#dsn2#">
						INSERT INTO
							VOUCHER_CLOSED
						(
							PAYROLL_ID,
							CARI_ACTION_ID,
							ACTION_ID,
							ACTION_TYPE_ID,
							ACTION_VALUE,
							CLOSED_AMOUNT,
							OTHER_CLOSED_AMOUNT,
							OTHER_MONEY
						)
						VALUES
						(
							#p_id#,
							<cfif get_cari_id.recordcount>#get_cari_id.cari_action_id#,<cfelse>NULL,</cfif>
							#evaluate("attributes.voucher_id_#kk#")#,
							<cfif get_cari_id.recordcount>#get_cari_id.action_type_id#,<cfelse>NULL,</cfif>
							#evaluate("attributes.other_money_value_#kk#")#,
							#evaluate("attributes.new_closed_amount_#kk#")#,
							#evaluate("attributes.new_closed_amount_#kk#")#,
							'#session.ep.money#'
						)
					</cfquery>
				</cfif>
				<cfif get_vouchers.is_pay_term eq 1>
					<cfset total_pay_term_value = total_pay_term_value + evaluate("attributes.new_closed_amount_#kk#")>
				</cfif>
			</cfif>
		</cfloop>
		<cfif isdefined("attributes.cash") and attributes.cash eq 1>
			<!--- Kasa Hareketleri Yapılıyor --->
			<cfinclude template="add_payment_voucher_revenue_1.cfm">
		<cfelseif isdefined("attributes.is_pos") and attributes.is_pos eq 1>
			<!--- Pos hareketleri yapılıyor --->
			<cfinclude template="add_payment_voucher_revenue_2.cfm">
		<cfelseif isdefined("attributes.is_bank") and attributes.is_bank eq 1>
			<!--- Banka hareketleri yapılıyor --->
			<cfinclude template="add_payment_voucher_revenue_3.cfm">
		</cfif>
		<!--- Faiz varsa bütçe kaydı yapacak --->
		<cfif is_budget eq 1 and attributes.total_interest_amount gt 0>
			<cfscript>
				butceci(
					action_id : p_id,
					muhasebe_db : dsn2,
					is_income_expense : true,
					process_type : process_type,
					nettotal : attributes.total_interest_amount,
					other_money_value : attributes.total_interest_amount,
					action_currency : session.ep.money,
					currency_multiplier : currency_multiplier,
					expense_date : action_date,
					expense_center_id : attributes.expense_center_id,
					expense_item_id : attributes.expense_item_id,
					detail : 'SENET FAİZ GELİRİ',
					paper_no : PAPER,
					company_id : attributes.company_id,
					consumer_id : attributes.consumer_id,
					branch_id : listgetat(session.ep.user_location,2,'-'),
					insert_type : 1
				);
			</cfscript>
		</cfif>
	</cftransaction>
</cflock>
<script type="text/javascript">
	window.location.href="<cfoutput>#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.list_payment_voucher<cfif len(attributes.consumer_id)>&consumer_id=#attributes.consumer_id#&company=#attributes.company#&company_id=&member_type=consumer</cfif><cfif len(attributes.company_id)>&consumer_id=&company_id=#attributes.company_id#&company=#attributes.company#&member_type=partner</cfif></cfoutput>";
</script>

