<cfif form.active_period neq session.ep.period_id>
	<script type="text/javascript">
		alert("<cf_get_lang_main no='1659.İşlem Yapmak İstediğiniz Muhasebe Dönemi ile Aktif Muhasebe Döneminiz Farklı Muhasebe Döneminizi Kontrol Ediniz'>!");
		history.back();
	</script>
	<cfabort>
</cfif>
<cfset wrk_id = dateformat(now(),'YYYYMMDD')&timeformat(now(),'HHmmss')&'_#session.ep.userid#_'&round(rand()*100)>
<cf_date tarih='attributes.invoice_date'>
<cfif isdefined("attributes.process_date") and len(attributes.process_date)>
	<cf_date tarih='attributes.process_date'>
</cfif>
<cfif isdefined("attributes.basket_due_value_date_") and isdate(attributes.basket_due_value_date_)>
	<cf_date tarih="attributes.basket_due_value_date_">
	<cfset invoice_due_date = '#attributes.basket_due_value_date_#'>
<cfelse>
	<cfset invoice_due_date = "">
</cfif>
<!--- sorun olabilddigi icin attributes&form olarak atandi --->
<cfif not isdefined("form.invoice_number")>
	<cfif isdefined('form.serial_number') and len(form.serial_number)>
		<cfset form.invoice_number = "#form.serial_number#-#form.serial_no#">
		<cfset attributes.invoice_number = "#form.serial_number#-#form.serial_no#">
	<cfelse>
		<cfset form.invoice_number = "#form.serial_no#">
		<cfset attributes.invoice_number = "#form.serial_no#">
	</cfif>
</cfif>

<cfquery name="get_process_type" datasource="#dsn3#">
	SELECT PROCESS_TYPE,IS_CARI,IS_ACCOUNT,IS_ACCOUNT_GROUP,IS_BUDGET,ACTION_FILE_NAME,ACTION_FILE_FROM_TEMPLATE,IS_PAYMETHOD_BASED_CARI FROM SETUP_PROCESS_CAT WHERE PROCESS_CAT_ID = #form.process_cat#
</cfquery>
<cfscript>
	process_cat = form.PROCESS_CAT;
	is_cari = get_process_type.IS_CARI;
	is_account = get_process_type.IS_ACCOUNT;
	is_budget = get_process_type.IS_BUDGET;
	is_account_group = get_process_type.IS_ACCOUNT_GROUP;
	is_paymethod_based_cari=get_process_type.IS_PAYMETHOD_BASED_CARI; //odeme yontemi bazlı cari yapılsın mı
	process_type = get_process_type.PROCESS_TYPE;
	rd_money_value = listfirst(attributes.rd_money, ',');
	currency_multiplier = 1;
	currency_multiplier_kasa = 1;
	masraf_curr_multiplier =1;
	paper_currency_multiplier =1;
	
	if(isdefined('attributes.acc_department_id') and len(attributes.acc_department_id) )
		acc_department_id = attributes.acc_department_id;
	else
		acc_department_id = '';

	if(isDefined('attributes.kur_say') and len(attributes.kur_say))
		for(mon=1;mon lte attributes.kur_say;mon=mon+1)
		{
			if(evaluate("attributes.hidden_rd_money_#mon#") is session.ep.money2)
				currency_multiplier = evaluate('attributes.txt_rate2_#mon#/attributes.txt_rate1_#mon#');
			if(isdefined('attributes.kasa') and evaluate("attributes.hidden_rd_money_#mon#") is ListLast(attributes.kasa,";"))
				currency_multiplier_kasa = evaluate('attributes.txt_rate2_#mon#/attributes.txt_rate1_#mon#');
			if(evaluate("attributes.hidden_rd_money_#mon#") is rd_money_value)
				paper_currency_multiplier = evaluate('attributes.txt_rate2_#mon#/attributes.txt_rate1_#mon#');
		}
	if (not (isdefined("attributes.project_id") and len(attributes.project_id) and isdefined("attributes.project_head") and len(attributes.project_head)))
		attributes.project_id = '';
</cfscript>
<cfset form.invoice_number = Trim(form.invoice_number)>
<cfset form.ship_number = Trim(form.ship_number)>
<cfquery name="GET_INVOICE_CONTROL" datasource="#dsn2#">
	SELECT
		INVOICE_NUMBER
	FROM
		INVOICE
	WHERE
		PURCHASE_SALES = 0 AND
		INVOICE_ID <> #attributes.invoice_id# AND
		INVOICE_NUMBER = '#form.invoice_number#'
	<cfif len(attributes.company_id)>
		AND COMPANY_ID = #attributes.company_id#
	<cfelseif len(attributes.consumer_id)>
		AND CONSUMER_ID = #attributes.consumer_id#
	<cfelseif len(attributes.emp_id)>
		AND EMPLOYEE_ID =#ListFirst(attributes.emp_id,'_')#
	</cfif>		
</cfquery>
<cfquery name="GET_INVOICE" datasource="#dsn2#">
	SELECT INVOICE_ID,INVOICE_NUMBER,CASH_ID,WRK_ID FROM INVOICE WHERE INVOICE_ID = #attributes.invoice_id#
</cfquery>
<cfquery name="GET_SHIP" datasource="#dsn2#">
	SELECT 
		INV_S.SHIP_ID,
		INV_S.INVOICE_NUMBER,
		INV_S.SHIP_NUMBER,
		INV_S.IS_WITH_SHIP
	FROM 
		INVOICE_SHIPS INV_S
	WHERE 
		INV_S.INVOICE_ID = #attributes.invoice_id# AND
		INV_S.SHIP_PERIOD_ID = #session.ep.period_id# AND
		INV_S.IS_WITH_SHIP = 1
</cfquery>
<cfif GET_INVOICE_CONTROL.recordcount>
	<script type="text/javascript">
		alert("Girdiğiniz Fatura Numarası Kullanılıyor!");
		history.back();
	</script>
	<cfabort>
</cfif>
<!--- emp_id and acc_type_id values --->
<cfif len(attributes.emp_id) and listlen(attributes.emp_id,'_') eq 2>
	<cfset acc_type_id = listlast(attributes.emp_id,'_')>
	<cfset attributes.emp_id = listfirst(attributes.emp_id,'_')>
<cfelse>
	<cfset acc_type_id = ''>
	<cfset attributes.emp_id = attributes.emp_id>
</cfif>

<cfif is_account eq 1>

	<cfif len(attributes.company_id)>
		<cfset MY_ACC_RESULT = GET_COMPANY_PERIOD(attributes.company_id)>

	<cfelseif len(attributes.consumer_id)>	
		<cfset MY_ACC_RESULT = GET_CONSUMER_PERIOD(attributes.consumer_id)>
           
	<cfelse>	
		<cfset MY_ACC_RESULT = GET_EMPLOYEE_PERIOD(attributes.emp_id,acc_type_id)>
        
	</cfif>
     <cfset attributes.my_acc_result = #MY_ACC_RESULT#>
	<cfif not len(MY_ACC_RESULT)>
		<script type="text/javascript">
			alert("Seçtiğiniz Üyenin Muhasebe Kodu Seçilmemiş!");
			history.back();	
		</script>
		<cfabort>
	</cfif>
</cfif>
<cflock name="#CreateUUID()#" timeout="60">
	<cftransaction>
		<cfquery name="ADD_INVOICE" datasource="#dsn2#">
			UPDATE INVOICE
				SET
					<cfif isDefined("FORM.CASH")>
					IS_CASH = 1,
					KASA_ID = #ListFirst(attributes.kasa,";")#,
					<cfelse>
					IS_CASH = 0,
					KASA_ID = NULL,
					</cfif>
					PURCHASE_SALES = 0,
					DUE_DATE = <cfif len(invoice_due_date) and isdate(invoice_due_date)>#invoice_due_date#<cfelse>NULL</cfif>,
					PROJECT_ID = <cfif len(attributes.project_id)>#attributes.project_id#<cfelse>NULL</cfif>,
					SERIAL_NUMBER = '#form.SERIAL_NUMBER#',
		            SERIAL_NO = '#FORM.SERIAL_NO#',
					INVOICE_NUMBER = '#FORM.INVOICE_NUMBER#',
					INVOICE_CAT = #process_type#,
					INVOICE_DATE = #attributes.invoice_date#,
                    PROCESS_DATE = <cfif isdefined("attributes.process_date") and len(attributes.process_date)><cfqueryparam cfsqltype="CF_SQL_TIMESTAMP" value="#attributes.process_date#"><cfelse>NULL</cfif>,
					COMPANY_ID = <cfif len(attributes.company_id)>#attributes.company_id#<cfelse>NULL</cfif>,
					CONSUMER_ID = <cfif len(attributes.consumer_id)>#attributes.consumer_id#<cfelse>NULL</cfif>,
					EMPLOYEE_ID = <cfif len(attributes.emp_id)>#attributes.emp_id#<cfelse>NULL</cfif>,
                    PARTNER_ID = <cfif isDefined("attributes.partner_id") and len(attributes.partner_id)>#attributes.partner_id#<cfelse>NULL</cfif>,
					ACC_TYPE_ID = <cfif isdefined("acc_type_id") and len(acc_type_id)>#acc_type_id#<cfelse>NULL</cfif>,
                    NETTOTAL = #attributes.net_total_amount#,
					GROSSTOTAL = #attributes.total_amount#,
					TAXTOTAL = #attributes.kdv_total_amount#, 
					OTV_TOTAL = #attributes.otv_total_amount#,
					NOTE = <cfif isDefined("attributes.detail") and len(attributes.detail)>'#attributes.detail#'<cfelse>NULL</cfif>,
					SALE_EMP = <cfif len(attributes.employee_id) and len(attributes.employee)>#attributes.employee_id#<cfelse>NULL</cfif>,
					DEPARTMENT_ID = #attributes.department_id#,
					DEPARTMENT_LOCATION = #attributes.location_id#,
					UPDATE_DATE = #NOW()#,
					UPDATE_EMP = #SESSION.EP.USERID#,
					UPD_STATUS = 1,
					OTHER_MONEY = <cfif len(rd_money_value)>'#rd_money_value#',<cfelse>NULL,</cfif>
					OTHER_MONEY_VALUE = <cfif len(attributes.other_net_total_amount)>#attributes.other_net_total_amount#,<cfelse>NULL,</cfif>
					IS_WITH_SHIP = 1,
					PAY_METHOD = <cfif isdefined("attributes.paymethod_id") and len(attributes.paymethod_id) and len(attributes.paymethod)>#attributes.paymethod_id#<cfelse>NULL</cfif>,
					<cfif isdefined("attributes.card_paymethod_id") and len(attributes.card_paymethod_id) and len(attributes.paymethod)>
						CARD_PAYMETHOD_ID= #attributes.card_paymethod_id#,
						CARD_PAYMETHOD_RATE = <cfif isdefined("attributes.commission_rate") and len(attributes.commission_rate) and len(attributes.paymethod)>#attributes.commission_rate#,<cfelse>NULL,</cfif>
					<cfelse>
						CARD_PAYMETHOD_ID= NULL,
						CARD_PAYMETHOD_RATE = NULL,
					</cfif>
					SA_DISCOUNT = #attributes.net_total_discount#,
					PROCESS_CAT = #FORM.PROCESS_CAT#,
					CARI_ACTION_TYPE = <!--- parçalı cari işlemi tutuyor --->
						<cfif isDefined("attributes.invoice_payment_plan") and attributes.invoice_payment_plan eq 0>
							<!--- FBS 20120711 Odeme Planini Yeniden Olusturmamasi Icin Type Degerinin Tasinmasi Gerekiyor --->
							<cfif isDefined("attributes.invoice_cari_action_type") and Len(attributes.invoice_cari_action_type)>#attributes.invoice_cari_action_type#<cfelse>4</cfif>
						<cfelse>
							0
						</cfif>, 
					TEVKIFAT = <cfif isdefined("attributes.tevkifat_box")>1<cfelse>0</cfif>,
					TEVKIFAT_ORAN = <cfif isdefined("attributes.tevkifat_box") and isdefined("attributes.tevkifat_oran") and len(attributes.tevkifat_oran)>#attributes.tevkifat_oran#<cfelse>NULL</cfif>,
					TEVKIFAT_ID = <cfif isdefined("attributes.tevkifat_box") and isdefined("attributes.tevkifat_id") and len(attributes.tevkifat_id)>#attributes.tevkifat_id#<cfelse>NULL</cfif>,
                    ACC_DEPARTMENT_ID=<cfif isdefined("attributes.acc_department_id") and len(attributes.acc_department_id)>#attributes.acc_department_id#<cfelse>NULL</cfif>,
					STOPAJ = <cfif isdefined("attributes.stopaj") and len(attributes.stopaj)>#attributes.stopaj#<cfelse>NULL</cfif>,
					STOPAJ_ORAN = <cfif isdefined("attributes.stopaj_yuzde") and len(attributes.stopaj_yuzde)>#attributes.stopaj_yuzde#<cfelse>NULL</cfif>,
					STOPAJ_RATE_ID = <cfif isdefined("attributes.stopaj_rate_id") and len(attributes.stopaj_rate_id)>#attributes.stopaj_rate_id#<cfelse>NULL</cfif>,
                    SHIP_ADDRESS_ID = <cfif isdefined("attributes.ship_address_id") and len(attributes.ship_address_id) and isdefined("attributes.adres") and len(attributes.adres)>#attributes.ship_address_id#<cfelse>NULL</cfif>,
                    SHIP_ADDRESS = <cfif isdefined("attributes.adres") and len(attributes.adres) and isdefined("attributes.ship_address_id") and len(attributes.ship_address_id)>'#attributes.adres#'<cfelse>NULL</cfif>,
                    IS_CREDIT =  <cfif isdefined("attributes.credit") and len(attributes.credit)>1 <cfelse>0</cfif>,
					IS_EARCHIVE = <cfif isDefined("attributes.is_earchive")>1<cfelse>0</cfif>
                    
				WHERE
					INVOICE_ID = #attributes.invoice_id#
		</cfquery>
        <cfscript>
			if(isdefined("attributes.process_date") and len(attributes.process_date))
				attributes.invoice_date = attributes.process_date;// işlem tarihi üzerinden hareketler yaptırılıyor
		</cfscript>
		<cfquery name="DEL_INVENTORY_ROW" datasource="#dsn2#">
			DELETE FROM #dsn3_alias#.INVENTORY_ROW WHERE ACTION_ID = #attributes.invoice_id# AND PROCESS_TYPE = #process_type# AND PERIOD_ID = #session.ep.period_id#
		</cfquery>
		<!--- inventory history kayitlari silinip tekrar olusturulur --->
		<cfquery name="DEL_INVENTORY_HISTORY" datasource="#dsn2#">
			DELETE FROM #dsn3_alias#.INVENTORY_HISTORY WHERE ACTION_ID = #attributes.invoice_id# AND ACTION_TYPE = #process_type#
		</cfquery>
		<cfquery name="DEL_ROW" datasource="#dsn2#">
			DELETE FROM INVOICE_ROW WHERE INVOICE_ID = #attributes.invoice_id#
		</cfquery>
        <cfif len(get_ship.ship_id)>
            <cfquery name="DEL_SHIP_ROW" datasource="#dsn2#">
                DELETE FROM SHIP_ROW WHERE SHIP_ID = #get_ship.ship_id#
            </cfquery>
            <cfquery name="DEL_SHIP" datasource="#dsn2#">
                DELETE FROM SHIP WHERE SHIP_ID = #get_ship.ship_id#
            </cfquery>
            <cfquery name="DEL_SHIP_ROW_MONEY" datasource="#dsn2#">
                DELETE FROM SHIP_MONEY WHERE ACTION_ID = #get_ship.ship_id#
            </cfquery>
        </cfif>			
		<cfquery name="DEL_INVOICE_ROW_MONEY" datasource="#dsn2#">
			DELETE FROM INVOICE_MONEY WHERE ACTION_ID = #attributes.invoice_id#
		</cfquery>			
		<cfquery name="DEL_INVOICE_SHIPS" datasource="#dsn2#">
			DELETE FROM INVOICE_SHIPS WHERE INVOICE_ID = #attributes.invoice_id#
		</cfquery>
		<cfquery name="ADD_SHIP" datasource="#dsn2#" result="MAX_ID">
			INSERT INTO
				SHIP
				(
					WRK_ID,
					PURCHASE_SALES,
					SHIP_NUMBER,
					SHIP_TYPE,
					SHIP_DATE,
					DELIVER_DATE,
					COMPANY_ID,
					CONSUMER_ID,
                    EMPLOYEE_ID,
					<cfif isDefined("attributes.partner_id") and len(attributes.partner_id)>
					PARTNER_ID,
					</cfif>
					DISCOUNTTOTAL,
					NETTOTAL,
					GROSSTOTAL,
					TAXTOTAL,
					DELIVER_STORE_ID,
					LOCATION,
					RECORD_DATE,
					RECORD_EMP,
					IS_WITH_SHIP,
					OTHER_MONEY,
					OTHER_MONEY_VALUE
				)
			VALUES
				(
					'#wrk_id#',
					0,
					'#form.ship_number#',
					82,
					#attributes.invoice_date#,
					#attributes.invoice_date#,
					<cfif len(attributes.company_id)>#attributes.company_id#<cfelse>NULL</cfif>,
					<cfif len(attributes.consumer_id)>#attributes.consumer_id#<cfelse>NULL</cfif>,
					<cfif len(attributes.emp_id)>#attributes.emp_id#<cfelse>NULL</cfif>,                    
					<cfif isDefined("attributes.partner_id") and len(attributes.partner_id)>
					#attributes.partner_id#,
					</cfif>
					0,
					#attributes.net_total_amount#,
					#attributes.total_amount#,
				    #attributes.kdv_total_amount#,
					#attributes.department_id#,
					#attributes.location_id#,
					#NOW()#,
					#SESSION.EP.USERID#,
					1,
					<cfif len(rd_money_value)>'#rd_money_value#',<cfelse>NULL,</cfif>
					<cfif len(attributes.other_net_total_amount)>#attributes.other_net_total_amount#<cfelse>NULL</cfif>
				)
		</cfquery>
        <cfset GET_SHIP_ID.MAX_ID = MAX_ID.IDENTITYCOL>
		<cfloop from="1" to="#attributes.record_num#" index="i"> 
		 <cfif isdefined("attributes.row_kontrol#i#") and evaluate("attributes.row_kontrol#i#")>
			<cfif isDefined("attributes.invent_id#i#") and len(evaluate("attributes.invent_id#i#"))>
				<cfquery name="get_inv_count" datasource="#dsn2#">
					SELECT ISNULL(AMORTIZATION_COUNT,0) AS INV_COUNT FROM #dsn3_alias#.INVENTORY WHERE INVENTORY_ID = #evaluate("attributes.invent_id#i#")#
				</cfquery>
				<cfquery name="UPD_INVT" datasource="#DSN2#">
					UPDATE
						#dsn3_alias#.INVENTORY
					SET
						INVENTORY_NUMBER = '#wrk_eval("attributes.invent_no#i#")#',
						INVENTORY_NAME = <cfqueryparam cfsqltype="cf_sql_varchar" value="#evaluate("attributes.invent_name#i#")#">,
						QUANTITY = #evaluate("attributes.quantity#i#")#,
						AMOUNT = #evaluate("attributes.row_total#i#")#,
						AMOUNT_2 = <cfif len(currency_multiplier)>#wrk_round(evaluate("attributes.row_total#i#")/currency_multiplier)#<cfelse>NULL</cfif>,
						AMORTIZATON_ESTIMATE = #evaluate("attributes.amortization_rate#i#")#,
						AMORTIZATON_METHOD = #evaluate("attributes.amortization_method#i#")#,
						DEBT_ACCOUNT_ID = <cfif len(evaluate("attributes.debt_account_id#i#")) and len(evaluate("attributes.debt_account_code#i#"))>'#wrk_eval("attributes.debt_account_id#i#")#'<cfelse>NULL</cfif>,
						CLAIM_ACCOUNT_ID = <cfif len(evaluate("attributes.claim_account_id#i#")) and len(evaluate("attributes.claim_account_code#i#"))>'#wrk_eval("attributes.claim_account_id#i#")#'<cfelse>NULL</cfif>,
						ACCOUNT_PERIOD= '#wrk_eval("attributes.period#i#")#',
						COMP_ID = <cfif len(attributes.company_id)>#attributes.company_id#<cfelse>NULL</cfif>,
						CONSUMER_ID = <cfif len(attributes.consumer_id)>#attributes.consumer_id#<cfelse>NULL</cfif>,
						EMPLOYEE_ID = <cfif len(attributes.emp_id)>#attributes.emp_id#<cfelse>NULL</cfif>,
                        COMP_PARTNER_ID = <cfif isDefined("attributes.partner_id") and len(attributes.partner_id)>#attributes.partner_id#<cfelse>NULL</cfif>,
						ACCOUNT_ID = '#wrk_eval("attributes.account_id#i#")#',
						EXPENSE_CENTER_ID = <cfif len(evaluate("attributes.expense_center_name#i#")) and len(evaluate("attributes.expense_center_id#i#"))>#evaluate("attributes.expense_center_id#i#")#<cfelse>NULL</cfif>,
						EXPENSE_ITEM_ID = <cfif len(evaluate("attributes.expense_item_name#i#"))>#evaluate("attributes.expense_item_id#i#")#<cfelse>NULL</cfif>,
						ENTRY_DATE = #attributes.invoice_date#,
						INVENTORY_CATID=<cfif isdefined('attributes.inventory_cat_id#i#') and len(evaluate("attributes.inventory_cat_id#i#")) and isdefined('attributes.inventory_cat#i#') and len(evaluate('attributes.inventory_cat#i#'))>#evaluate("attributes.inventory_cat_id#i#")#<cfelse>NULL</cfif>,
						INVENTORY_DURATION=<cfif isdefined('attributes.inventory_duration#i#') and len(evaluate("attributes.inventory_duration#i#"))>#evaluate("attributes.inventory_duration#i#")#<cfelse>NULL</cfif>,
						INVENTORY_DURATION_IFRS=<cfif isdefined('attributes.inventory_duration_ifrs#i#') and len(evaluate("attributes.inventory_duration_ifrs#i#"))>#evaluate("attributes.inventory_duration_ifrs#i#")#<cfelse>NULL</cfif>,
						AMORTIZATION_TYPE=<cfif isdefined('attributes.amortization_type#i#') and len(evaluate("attributes.amortization_type#i#"))>#evaluate("attributes.amortization_type#i#")#<cfelse>NULL</cfif>,
						<cfif get_inv_count.inv_count eq 0>
							AMORT_LAST_VALUE = #evaluate("attributes.row_total#i#")#,
							LAST_INVENTORY_VALUE = #evaluate("attributes.row_total#i#")#,
							LAST_INVENTORY_VALUE_2 = <cfif len(currency_multiplier)>#wrk_round(evaluate("attributes.row_total#i#")/currency_multiplier)#<cfelse>NULL</cfif>,
						</cfif>
						UPDATE_DATE = #NOW()#,
						UPDATE_EMP = #SESSION.EP.USERID#,
						UPDATE_IP = '#CGI.REMOTE_ADDR#',
						PROJECT_ID = <cfif len(attributes.project_id)>#attributes.project_id#<cfelse>NULL</cfif>
					WHERE
						INVENTORY_ID = #evaluate("attributes.invent_id#i#")#
				</cfquery>
				<cfset invent_id_info = evaluate("attributes.invent_id#i#")>
			<cfelse>
				<cfquery name="ADD_INVENT" datasource="#dsn2#">
					INSERT INTO
						#dsn3_alias#.INVENTORY
						(
							INVENTORY_NUMBER,
							INVENTORY_NAME,
							QUANTITY,
							AMOUNT,
							AMOUNT_2,
							LAST_INVENTORY_VALUE,
							LAST_INVENTORY_VALUE_2,
							AMORT_LAST_VALUE,
							AMORTIZATON_ESTIMATE,
							AMORTIZATON_METHOD,
							ACCOUNT_ID,
							DEBT_ACCOUNT_ID,
							CLAIM_ACCOUNT_ID,
							ACCOUNT_PERIOD,
							EXPENSE_CENTER_ID,
							EXPENSE_ITEM_ID,
							COMP_ID,
							CONSUMER_ID,
                            EMPLOYEE_ID,
							COMP_PARTNER_ID,
							AMORTIZATION_COUNT,
							ENTRY_DATE,
							INVENTORY_CATID,
							INVENTORY_DURATION,
							INVENTORY_DURATION_IFRS,
							AMORTIZATION_TYPE,
							RECORD_DATE,
							RECORD_EMP,
							RECORD_IP,
							INVENTORY_TYPE
						)
					VALUES
						(
							'#wrk_eval("attributes.invent_no#i#")#',
							'#evaluate("attributes.invent_name#i#")#',
							#evaluate("attributes.quantity#i#")#,
							#evaluate("attributes.row_total#i#")#,
							<cfif len(currency_multiplier)>#wrk_round(evaluate("attributes.row_total#i#")/currency_multiplier)#<cfelse>NULL</cfif>,
							#evaluate("attributes.row_total#i#")#,
							<cfif len(currency_multiplier)>#wrk_round(evaluate("attributes.row_total#i#")/currency_multiplier)#<cfelse>NULL</cfif>,
							#evaluate("attributes.row_total#i#")#,
							#evaluate("attributes.amortization_rate#i#")#,
							#evaluate("attributes.amortization_method#i#")#,
							'#wrk_eval("attributes.account_id#i#")#',
							<cfif len(evaluate("attributes.debt_account_id#i#")) and len(evaluate("attributes.debt_account_code#i#"))>'#wrk_eval("attributes.debt_account_id#i#")#'<cfelse>NULL</cfif>,
							<cfif len(evaluate("attributes.claim_account_id#i#")) and len(evaluate("attributes.claim_account_code#i#"))>'#wrk_eval("attributes.claim_account_id#i#")#'<cfelse>NULL</cfif>,
							'#wrk_eval("attributes.period#i#")#',
							<cfif len(evaluate("attributes.expense_center_name#i#")) and len(evaluate("attributes.expense_center_id#i#"))>#evaluate("attributes.expense_center_id#i#")#<cfelse>NULL</cfif>,
							<cfif len(evaluate("attributes.expense_item_name#i#"))>#evaluate("attributes.expense_item_id#i#")#<cfelse>NULL</cfif>,
							<cfif len(attributes.company_id)>#attributes.company_id#<cfelse>NULL</cfif>,
							<cfif len(attributes.consumer_id)>#attributes.consumer_id#<cfelse>NULL</cfif>,
							<cfif len(attributes.emp_id)>#attributes.emp_id#<cfelse>NULL</cfif>,                            
							<cfif isDefined("attributes.partner_id") and len(attributes.partner_id)>#attributes.partner_id#<cfelse>NULL</cfif>,
							0,
							#attributes.invoice_date#,
							<cfif isdefined('attributes.inventory_cat_id#i#') and len(evaluate("attributes.inventory_cat_id#i#")) and isdefined('attributes.inventory_cat#i#') and len(evaluate('attributes.inventory_cat#i#'))>#evaluate("attributes.inventory_cat_id#i#")#<cfelse>NULL</cfif>,
							<cfif isdefined('attributes.inventory_duration#i#') and len(evaluate("attributes.inventory_duration#i#"))>#evaluate("attributes.inventory_duration#i#")#<cfelse>NULL</cfif>,
							<cfif isdefined('attributes.inventory_duration_ifrs#i#') and len(evaluate("attributes.inventory_duration_ifrs#i#"))>#evaluate("attributes.inventory_duration_ifrs#i#")#<cfelse>NULL</cfif>,
							<cfif isdefined('attributes.amortization_type#i#') and len(evaluate("attributes.amortization_type#i#"))>#evaluate("attributes.amortization_type#i#")#<cfelse>NULL</cfif>,
							#NOW()#,
							#SESSION.EP.USERID#,
							'#CGI.REMOTE_ADDR#',
							2
						)
				</cfquery>
				<cfquery name="GET_INVENTORY_ID" datasource="#dsn2#">
					SELECT MAX(INVENTORY_ID) AS MAX_ID FROM #dsn3_alias#.INVENTORY
				</cfquery>
				<cfset invent_id_info = GET_INVENTORY_ID.MAX_ID>
			</cfif>
			<cfquery name="ADD_INVENT_ROW" datasource="#dsn2#">
				INSERT INTO 
					#dsn3_alias#.INVENTORY_ROW
				(
					INVENTORY_ID,
					PERIOD_ID,
					ACTION_ID,
					PAPER_NO,
					PROCESS_TYPE,
					QUANTITY,
					STOCK_IN,
					ACTION_DATE,
					STOCK_ID,
					PRODUCT_ID
				)
				VALUES
				(
					#invent_id_info#,
					#session.ep.period_id#,
					#attributes.invoice_id#,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.INVOICE_NUMBER#">,
					#process_type#,
					#evaluate("attributes.quantity#i#")#,
					#evaluate("attributes.quantity#i#")#,
					#attributes.invoice_date#,
					<cfif len(evaluate("attributes.stock_id#i#")) and len(evaluate("attributes.product_name#i#"))>#evaluate("attributes.stock_id#i#")#<cfelse>NULL</cfif>,
					<cfif len(evaluate("attributes.product_id#i#")) and len(evaluate("attributes.product_name#i#"))>#evaluate("attributes.product_id#i#")#<cfelse>NULL</cfif>
				)
			</cfquery>
			<!--- demirbasa ait histyory kaydi --->
			<cfset cmp = createObject("component","V16.inventory.cfc.inventory_history") />
			<cfset cmp.add_inventory_history(
					inventory_id : invent_id_info,
					action_id : attributes.invoice_id,
					action_type : process_type,
					action_date : attributes.invoice_date,
					project_id : attributes.project_id,
					expense_center_id : evaluate("attributes.expense_center_id#i#"),
					expense_item_id : evaluate("attributes.expense_item_id#i#"),
					claim_account_code : evaluate("attributes.claim_account_id#i#"),
					debt_account_code : evaluate("attributes.debt_account_id#i#"),
					account_code : evaluate("attributes.account_id#i#"),
					inventory_duration : evaluate("attributes.inventory_duration#i#"),
					inventory_duration_ifrs : evaluate("attributes.inventory_duration_ifrs#i#"),
					amortization_rate : evaluate("attributes.amortization_rate#i#")
			) />
			
			<cfquery name="ADD_INVOICE_ROW" datasource="#dsn2#">
				INSERT INTO
					INVOICE_ROW
				(
					PURCHASE_SALES,
					INVENTORY_ID,
					PRODUCT_ID,
					DESCRIPTION,
					NAME_PRODUCT,
					INVOICE_ID,
					STOCK_ID,
					AMOUNT,
					UNIT,
					UNIT_ID,		
					PRICE,
					GROSSTOTAL,
					NETTOTAL,
				    TAXTOTAL, 
					TAX,
					OTHER_MONEY,
					OTHER_MONEY_VALUE,
					PRICE_OTHER,
					OTHER_MONEY_GROSS_TOTAL,
					SHIP_ID,
					SHIP_PERIOD_ID,
					WRK_ROW_ID,
					WRK_ROW_RELATION_ID,
					OTVTOTAL,
					OTV_ORAN
				)
				VALUES
				(
					0,
					#invent_id_info#,
					<cfif len(evaluate("attributes.product_id#i#")) and len(evaluate("attributes.product_name#i#"))>#evaluate("attributes.product_id#i#")#,<cfelse>NULL,</cfif>
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#left(evaluate("attributes.invent_name#i#"),100)#">,
					<cfif len(evaluate("attributes.product_name#i#"))><cfqueryparam cfsqltype="cf_sql_varchar" value="#wrk_eval("attributes.product_name#i#")#">,<cfelse>NULL,</cfif>
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.invoice_id#">,
					<cfif len(evaluate("attributes.stock_id#i#")) and len(evaluate("attributes.product_name#i#"))>#evaluate("attributes.stock_id#i#")#,<cfelse>NULL,</cfif>
					#evaluate("attributes.quantity#i#")#,
					<cfif len(evaluate("attributes.stock_unit#i#"))>'#wrk_eval("attributes.stock_unit#i#")#',<cfelse>NULL,</cfif>
					<cfif len(evaluate("attributes.stock_unit_id#i#"))>#evaluate("attributes.stock_unit_id#i#")#,<cfelse>NULL,</cfif>		
					#evaluate("attributes.row_total#i#")#,
					#(evaluate("attributes.row_total#i#") * evaluate("attributes.quantity#i#")) + evaluate("attributes.kdv_total#i#") + evaluate("attributes.otv_total#i#")#,
					#evaluate("attributes.row_total#i#") * evaluate("attributes.quantity#i#")#,
				    #evaluate("attributes.kdv_total#i#")#, 
					#evaluate("attributes.tax_rate#i#")#,
					'#listgetat(evaluate("attributes.money_id#i#"), 1, ',')#',
					<cfif len(evaluate("attributes.row_other_total#i#"))>#wrk_round(evaluate("attributes.row_other_total#i#")/((evaluate("attributes.tax_rate#i#")+100)/100))#,<cfelse>NULL,</cfif><!--- kdvsiz döviz toplam --->
					<cfif len(evaluate("attributes.row_other_total#i#"))>#(wrk_round(evaluate("attributes.row_other_total#i#")/((evaluate("attributes.tax_rate#i#")+100)/100)))/evaluate("attributes.quantity#i#")#,<cfelse>NULL,</cfif>
					<cfif len(evaluate("attributes.row_other_total#i#"))>#evaluate("attributes.row_other_total#i#")#<cfelse>NULL</cfif>,<!--- kdvli döviz toplam --->
					0,
					#session.ep.period_id#,
					<cfif isdefined('attributes.wrk_row_id#i#') and len(evaluate('attributes.wrk_row_id#i#'))>'#wrk_eval('attributes.wrk_row_id#i#')#'<cfelse>NULL</cfif>,
					<cfif isdefined('attributes.wrk_row_relation_id#i#') and len(evaluate('attributes.wrk_row_relation_id#i#'))>'#wrk_eval('attributes.wrk_row_relation_id#i#')#'<cfelse>NULL</cfif>,
					#evaluate("attributes.otv_total#i#")#,
					<cfif isDefined("attributes.otv_rate#i#") and Len(evaluate("attributes.otv_rate#i#"))>#evaluate("attributes.otv_rate#i#")#<cfelse>NULL</cfif>
				)
			</cfquery>
			<cfset row_temp_wrk_id="#round(rand()*65)##dateformat(now(),'YYYYMMDD')##timeformat(now(),'HHmmssL')##session.ep.userid##round(rand()*100)#">
			<cfquery name="ADD_SHIP_ROW" datasource="#dsn2#">
				INSERT INTO
					SHIP_ROW
				(
					NAME_PRODUCT,
					SHIP_ID,
					STOCK_ID,
					PRODUCT_ID,
					AMOUNT,
					UNIT,
					UNIT_ID,
					TAX,
					PRICE,
					PURCHASE_SALES,
					GROSSTOTAL,
					NETTOTAL,
				    TAXTOTAL,	 				
					DELIVER_DATE,
					DELIVER_DEPT,
					DELIVER_LOC,
					OTHER_MONEY,
					OTHER_MONEY_VALUE,
					OTHER_MONEY_GROSS_TOTAL,
					PRICE_OTHER,
					WRK_ROW_ID,
					WRK_ROW_RELATION_ID,
					OTVTOTAL,
					OTV_ORAN
				)
				VALUES
				(
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#left(evaluate("attributes.invent_name#i#"),75)#">,
					#GET_SHIP_ID.MAX_ID#,
					<cfif len(evaluate("attributes.stock_id#i#"))>#evaluate("attributes.stock_id#i#")#,<cfelse>NULL,</cfif>
					<cfif len(evaluate("attributes.product_id#i#"))>#evaluate("attributes.product_id#i#")#,<cfelse>NULL,</cfif>
					#evaluate("attributes.quantity#i#")#,
					<cfif len(evaluate("attributes.stock_unit#i#"))>'#wrk_eval("attributes.stock_unit#i#")#',<cfelse>NULL,</cfif>
					<cfif len(evaluate("attributes.stock_unit_id#i#"))>#evaluate("attributes.stock_unit_id#i#")#,<cfelse>NULL,</cfif>		
					#evaluate("attributes.tax_rate#i#")#,
					#evaluate("attributes.row_total#i#")#,
					0,
					#(evaluate("attributes.row_total#i#") * evaluate("attributes.quantity#i#")) + evaluate("attributes.kdv_total#i#")#,
					#evaluate("attributes.row_total#i#") * evaluate("attributes.quantity#i#")#,
					#evaluate("attributes.kdv_total#i#")#,
					#attributes.invoice_date#,
					#attributes.department_id#,
					#attributes.location_id#,
					'#listgetat(evaluate("attributes.money_id#i#"),1,',')#',
					<cfif len(evaluate("attributes.row_other_total#i#"))>#wrk_round(evaluate("attributes.row_other_total#i#")/((evaluate("attributes.tax_rate#i#")+100)/100))#,<cfelse>NULL,</cfif><!--- kdvsiz döviz toplam --->
					<cfif len(evaluate("attributes.row_other_total#i#"))>#evaluate("attributes.row_other_total#i#")#,<cfelse>NULL,</cfif>
					<cfif len(evaluate("attributes.row_other_total#i#"))>#(evaluate("attributes.row_other_total#i#")/evaluate("attributes.quantity#i#"))#<cfelse>NULL</cfif>,
					#row_temp_wrk_id#,
					<cfif isdefined('attributes.wrk_row_id#i#') and len(evaluate('attributes.wrk_row_id#i#'))>'#wrk_eval('attributes.wrk_row_id#i#')#'<cfelse>NULL</cfif>,<!--- faturanın wrk_row_id si olusturdugu irsaliyenin wrk_row_relation_id sine gonderiliyor --->
					#evaluate("attributes.otv_total#i#")#,
					<cfif isDefined("attributes.otv_rate#i#") and Len(evaluate("attributes.otv_rate#i#"))>#evaluate("attributes.otv_rate#i#")#<cfelse>NULL</cfif>
				)
			</cfquery>
		  </cfif>
		</cfloop>
		<cfquery name="ADD_INVOICE_SHIPS" datasource="#dsn2#">
			INSERT INTO
				INVOICE_SHIPS
				(
					INVOICE_ID,
					INVOICE_NUMBER,
					SHIP_ID,
					SHIP_NUMBER,
					IS_WITH_SHIP,
					SHIP_PERIOD_ID
				)
				VALUES
				(
					#attributes.invoice_id#,					
					'#form.invoice_number#',
					#GET_SHIP_ID.MAX_ID#,
					'#form.ship_number#',
					1, <!--- faturanın kendi irsaliyesi --->
					#session.ep.period_id#
				)
		</cfquery>
		<!--- cari - muhasebe - kasa kayıtları --->
		<cfinclude template="upd_invent_purchase_1.cfm">		
		<!--- money kayıtları --->
		<cfloop from="1" to="#attributes.kur_say#" index="i">
			<cfquery name="ADD_MONEY_INFO_1" datasource="#dsn2#">
				INSERT INTO INVOICE_MONEY 
				(
					ACTION_ID,
					MONEY_TYPE,
					RATE2,
					RATE1,
					IS_SELECTED
				)
				VALUES
				(
					#attributes.invoice_id#,
					'#wrk_eval("attributes.hidden_rd_money_#i#")#',
					#evaluate("attributes.txt_rate2_#i#")#,
					#evaluate("attributes.txt_rate1_#i#")#,
					<cfif evaluate("attributes.hidden_rd_money_#i#") is rd_money_value>1<cfelse>0</cfif>
				)
			</cfquery>
			<cfquery name="ADD_MONEY_INFO_2" datasource="#dsn2#">
				INSERT INTO SHIP_MONEY 
				(
					ACTION_ID,
					MONEY_TYPE,
					RATE2,
					RATE1,
					IS_SELECTED
				)
				VALUES
				(
					#GET_SHIP_ID.MAX_ID#,
					'#wrk_eval("attributes.hidden_rd_money_#i#")#',
					#evaluate("attributes.txt_rate2_#i#")#,
					#evaluate("attributes.txt_rate1_#i#")#,
					<cfif evaluate("attributes.hidden_rd_money_#i#") is rd_money_value>1<cfelse>0</cfif>
				)
			</cfquery>
		</cfloop>
		
			<cf_workcube_process_cat 
				process_cat="#form.process_cat#"
				action_id = #attributes.invoice_id#
				is_action_file = 1
				action_file_name='#get_process_type.action_file_name#'
				action_page='#request.self#?fuseaction=invent.add_invent_purchase&event=upd&invoice_id=#attributes.invoice_id#'
				action_db_type = '#dsn2#'
				is_template_action_file = '#get_process_type.action_file_from_template#'>
		
    <cf_add_log employee_id="#session.ep.userid#" log_type="0" action_id="#attributes.invoice_id#" action_name="#form.invoice_number# Güncellendi" paper_no="#form.invoice_number#" period_id="#session.ep.period_id#" process_type="#get_process_type.PROCESS_TYPE#" data_source="#dsn2#">
	</cftransaction>
    <!--- Kredi kartı işlemleri --->
<cfif isdefined("attributes.credit")>
	<cfset wrk_id = dateformat(now(),'YYYYMMDD')&timeformat(now(),'HHmmss')&'_#session.ep.userid#_'&round(rand()*100)>
	<cfif isdefined('form.serial_number') and len(form.serial_number)>
			<cfset form.belge_no = "#form.serial_number#-#form.serial_no#">
			<cfset attributes.belge_no = "#form.serial_number#-#form.serial_no#">
		<cfelse>
			<cfset form.belge_no = "#form.serial_no#">
			<cfset attributes.belge_no = "#form.serial_no#">
		</cfif>
			<cfquery name="GET_MAXID" datasource="#dsn2#">
				SELECT MAX(EXPENSE_ID) AS MAX_ID FROM EXPENSE_ITEM_PLANS WHERE WRK_ID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#wrk_id#">
			</cfquery>
		<cfif isdefined("attributes.invoice_id")>
	
			<cfquery name="GET_CREDIT_ACTIONS" datasource="#dsn2#">
				SELECT CREDITCARD_EXPENSE_ID FROM #dsn3_alias#.CREDIT_CARD_BANK_EXPENSE WHERE INVOICE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.invoice_id#"> 
			</cfquery>
		<cfelse>
			<cfset get_credit_actions.recordcount = 0>
		</cfif>
		<cfif len(attributes.ACC_DEPARTMENT_ID)>
		<cfquery name="ADDD_CREDITCARD_PAYMENT" datasource="#dsn#">
		SELECT 
			BRANCH_ID 
		FROM 
			DEPARTMENT
		WHERE 
			DEPARTMENT_ID = #attributes.ACC_DEPARTMENT_ID# 
		</cfquery>
	<cfset branch_id_info = ADDD_CREDITCARD_PAYMENT.BRANCH_ID>
	<cfelse>
		<cfset branch_id_info = listgetat(session.ep.user_location,2,'-')>
	</cfif>
    <cfscript>
		get_process_type = cfquery(datasource : "#dsn3#", sqlstring : "SELECT ISNULL(IS_ROW_PROJECT_BASED_CARI,0) IS_ROW_PROJECT_BASED_CARI,IS_PROJECT_BASED_ACC,PROCESS_TYPE,IS_DEPT_BASED_ACC,IS_CARI,IS_ACCOUNT,IS_ACCOUNT_GROUP,ACTION_FILE_NAME,ACTION_FILE_FROM_TEMPLATE,IS_STOCK_ACTION,IS_EXP_BASED_ACC,IS_PAYMETHOD_BASED_CARI FROM SETUP_PROCESS_CAT WHERE  PROCESS_CAT_ID = #attributes.process_cat#");
		process_type = get_process_type.process_type;
		islem_detay = UCASETR(get_process_name(process_type));
		is_project_based_acc = get_process_type.IS_PROJECT_BASED_ACC;
		is_row_project_based_cari = get_process_type.IS_ROW_PROJECT_BASED_CARI;
		is_cari = get_process_type.is_cari;
		is_account = get_process_type.is_account;
		is_stock_action = get_process_type.is_stock_action;
		is_dept_based_acc = get_process_type.is_dept_based_acc;
		is_paymethod_based_cari=get_process_type.is_paymethod_based_cari;
		account_group=get_process_type.is_account_group;
		rate_round_info_=session.ep.our_company_info.rate_round_num;
		is_exp_based_acc = get_process_type.is_exp_based_acc;
		is_cari_islem=0;
		is_muh_action=0;
		str_alacak_tutar_list="";
		str_alacak_kod_list="";
		str_borc_tutar_list="";
		str_borc_kod_list="";
		satir_detay_list = ArrayNew(2); //muhasebe fisi satır detaylarını tutar
		rd_money_value = listfirst(attributes.rd_money, ',');
		str_other_alacak_tutar_list = "";
		str_other_borc_tutar_list = "";
		str_other_borc_currency_list = "";
		str_other_alacak_currency_list = "";
		acc_project_list_alacak='';
		acc_project_list_borc='';
		fis_satir_row_detail = '#attributes.belge_no# - #attributes.detail# - #islem_detay#';  //muhasebe islemlerinde kullanılıyor
		attributes.acc_type_id = '';
	
		account_id_first = listgetat(attributes.credit_card_info,1,';');
		action_curreny = listgetat(attributes.credit_card_info,2,';');
		account_id_last = listgetat(attributes.credit_card_info,3,';');
		get_credit_ = cfquery(datasource : "#dsn3#", sqlstring : "SELECT ACCOUNT_CODE FROM CREDIT_CARD WHERE CREDITCARD_ID = #account_id_last#");
		if (len(attributes.company_id))
		 string_acc_code = GET_COMPANY_PERIOD(attributes.company_id);
         else if( len(attributes.consumer_id))	
		 string_acc_code = GET_CONSUMER_PERIOD(attributes.consumer_id);
         else	
		 string_acc_code = GET_EMPLOYEE_PERIOD(attributes.emp_id,acc_type_id);
       	
		string_currency_id = listgetat(attributes.credit_card_info,2,';');
		currency_multiplier = 1;
		currency_multiplier_banka = 1;
		currency_multiplier_money2 = 1;
		rd_money_rate=1;
		paper_currency_multiplier = '';
	
        if(len(attributes.partner_id) and len(attributes.partner_name))
        {
            attributes.action_to_company_id = attributes.company_id;
            action_to_company_id = attributes.company_id;
            attributes.par_id = attributes.partner_id;
            cons_id = '';
            attributes.cons_id = '';
        }
        else if(len(attributes.consumer_id) )
        {
            attributes.action_to_company_id = '';
            action_to_company_id = '';
            attributes.cons_id = attributes.partner_id;
            cons_id = attributes.partner_id;
            attributes.par_id = '';
        }
        else
        {
            attributes.action_to_company_id = '';
            action_to_company_id = '';
            attributes.cons_id = '';
            cons_id = '';
            attributes.par_id = '';
        }
        if((isdefined("attributes.comp_name") and len(attributes.comp_name) and len(attributes.company_id)) or (len(attributes.emp_id) and len(attributes.partner_name)) or (len(attributes.partner_id) and len(attributes.partner_name)) )//cari seçilmiş ise
            is_cari_acc = 1;
        else
            is_cari_acc = 0;
        my_acc_result = attributes.my_acc_result;
        account_id_first = listgetat(attributes.credit_card_info,1,';');
        action_curreny = listgetat(attributes.credit_card_info,2,';');
        account_id_last = listgetat(attributes.credit_card_info,3,';');
        cc_rate=1;
        if(isDefined('attributes.kur_say') and len(attributes.kur_say))
        {
            for(mon=1;mon lte attributes.kur_say;mon=mon+1)
            {
					if(evaluate("attributes.hidden_rd_money_#mon#") is rd_money_value)
			{
				rd_money_rate = evaluate('attributes.txt_rate2_#mon#/attributes.txt_rate1_#mon#');
				paper_currency_multiplier = evaluate('attributes.txt_rate2_#mon#/attributes.txt_rate1_#mon#');
			}
                if(evaluate("attributes.hidden_rd_money_#mon#") is action_curreny)
                    cc_rate = evaluate('attributes.txt_rate2_#mon#/attributes.txt_rate1_#mon#');
            }
        }
        attributes.system_amount = attributes.net_total_amount;
        attributes.action_value = wrk_round(attributes.net_total_amount/cc_rate);
        attributes.other_money_value = attributes.other_net_total_amount;
        attributes.money_type = rd_money_value;
        attributes.action_date = attributes.invoice_date;
        attributes.action_detail = attributes.detail;
        attributes.paper_number = attributes.belge_no;
        process_type_credit = 242;
        old_process_type_credit = 242;
        if(get_credit_actions.recordcount gt 0)
        {
            invoice_id = attributes.invoice_id;
            attributes.creditcard_expense_id = get_credit_actions.creditcard_expense_id;
        }
        else
        {
            if (isdefined("attributes.invoice_id") and isdefined("is_upd_action"))
                invoice_id = attributes.invoice_id;
            else
                invoice_id = get_maxid.max_id;
            attributes.creditcard_expense_id = '';
        }
        if(not isdefined("attributes.project_id"))
        {
            attributes.project_id='';
            attributes.project_head='';
        }
        if(isdefined("attributes.project_head"))
            attributes.project_name = attributes.project_head;
            
        is_from_expense = 1;
    </cfscript>
    <cfquery name="GET_CREDIT_CARD" datasource="#dsn2#"><!--- Seçilen kredi kartının ek bilgileri --->
        SELECT 
            ISNULL(CLOSE_ACC_DAY,1) CLOSE_ACC_DAY,
            ACCOUNT_CODE
        FROM 
            #dsn3_alias#.CREDIT_CARD 
        WHERE 
            CREDITCARD_ID = #account_id_last#
    </cfquery>
      
    <cfif not len(attributes.invoice_id)>
        <cfinclude template="add_creditcard_bank_expense_ic.cfm">
    <cfelse>
        <cfinclude template="upd_creditcard_bank_expense_ic.cfm">
    </cfif>
    <cfquery name="get_cari_kontrol_credit" datasource="#dsn2#">
        SELECT DISTINCT PROJECT_ID FROM CARI_ROWS WHERE ACTION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.CREDITCARD_EXPENSE_ID#"> AND ACTION_TYPE_ID = #process_type_credit#
    </cfquery>
  
    <cfscript>
        if(is_cari eq 1)//kredi kartı carici
        {
            if(is_row_project_based_cari eq 1 or (is_row_project_based_cari eq 0 and get_cari_kontrol_credit.recordcount neq 1))
                cari_sil(action_id:attributes.CREDITCARD_EXPENSE_ID,process_type:process_type_credit);
            if(is_row_project_based_cari eq 1)
            {
                row_project_list='';
                total_cash_price=0;
                total_other_cash_price=0;
                row_number = 0;
                row_all_total = 0;
                for(j=1;j lte attributes.record_num;j=j+1)
                {
                    if (isdefined("attributes.row_kontrol#j#") and evaluate("attributes.row_kontrol#j#"))
                    {
                        row_all_total = row_all_total + evaluate("attributes.net_total#j#");
                    }
                }
                for(j=1;j lte attributes.record_num;j=j+1)
                {
                    if(row_all_total gt 0)
                        row_total_ = attributes.net_total_amount*evaluate("attributes.net_total#j#")/row_all_total;
                    else
                        row_total_ = 0;
                    if (isdefined("attributes.row_kontrol#j#") and evaluate("attributes.row_kontrol#j#") and isdefined("attributes.project_id#j#") and len(evaluate("attributes.project_id#j#")) and len(evaluate("attributes.project#j#")))
                    {
                        //row_number = row_number + 1;
                        if(not listfind(row_project_list,evaluate("attributes.project_id#j#")))
                        {
                            row_project_list = listappend(row_project_list,evaluate("attributes.project_id#j#"));
                            row_number = listfind(row_project_list,evaluate("attributes.project_id#j#"));
                            'row_amount_total_#row_number#' = row_total_;
                            'row_other_amount_total_#row_number#' = row_total_/paper_currency_multiplier;
                        }
                        else
                        {
                            row_number = listfind(row_project_list,evaluate("attributes.project_id#j#"));
                            'row_amount_total_#row_number#' = evaluate("row_amount_total_#row_number#")+row_total_;
                            'row_other_amount_total_#row_number#' = evaluate("row_other_amount_total_#row_number#")+(row_total_/paper_currency_multiplier);
                        }
                    }
                    else if (isdefined("attributes.row_kontrol#j#") and evaluate("attributes.row_kontrol#j#"))
                    {
                        total_cash_price = total_cash_price + row_total_;
                        total_other_cash_price = total_other_cash_price + row_total_/paper_currency_multiplier;
                    }	
                }
                for(ind_t=1;ind_t lte listlen(row_project_list); ind_t=ind_t+1)
                {
                    cari_row_project=listgetat(row_project_list,ind_t);
                    carici(
                        action_id : attributes.CREDITCARD_EXPENSE_ID,
                        action_table : 'CREDIT_CARD_BANK_EXPENSE',
                        workcube_process_type : process_type_credit,
                        process_cat : attributes.process_cat,
						acc_type_id : acc_type_id,	
                        islem_tarihi : attributes.action_date,
                        from_account_id : account_id_first,
                        from_branch_id : branch_id_info,
                        islem_tutari : evaluate('row_amount_total_#ind_t#'),
                        action_currency : session.ep.money,
                        other_money_value : evaluate('row_other_amount_total_#ind_t#'),
                        other_money : attributes.money_type,
                        currency_multiplier : currency_multiplier,
                        islem_detay : 'KREDİ KARTIYLA ÖDEME',
                        action_detail : attributes.action_detail,
                        account_card_type : 13,
                        to_cmp_id : action_to_company_id,
                        to_consumer_id : attributes.cons_id,
                        project_id : cari_row_project,
                        islem_belge_no : attributes.paper_number,
                        due_date : attributes.action_date,
                        special_definition_id : iif((isdefined("attributes.special_definition_id") and len(attributes.special_definition_id)),'attributes.special_definition_id',de('')),
                        assetp_id : iif((isdefined("attributes.asset_id") and len(attributes.asset_id) and len(attributes.asset_name)),'attributes.asset_id',de('')),
                        rate2:paper_currency_multiplier
                        );
                }
                if(total_cash_price gt 0)
                {
                    carici(
                        action_id : attributes.CREDITCARD_EXPENSE_ID,
                        action_table : 'CREDIT_CARD_BANK_EXPENSE',
                        workcube_process_type : process_type_credit,
                        process_cat : attributes.process_cat,
						acc_type_id : acc_type_id,	
                        islem_tarihi : attributes.action_date,
                        from_account_id : account_id_first,
                        from_branch_id : branch_id_info,
                        islem_tutari : total_cash_price,
                        action_currency : session.ep.money,
                        other_money_value : total_other_cash_price,
                        other_money : attributes.money_type,
                        currency_multiplier : currency_multiplier,
                        islem_detay : 'KREDİ KARTIYLA ÖDEME',
                        action_detail : attributes.action_detail,
                        account_card_type : 13,
                        to_cmp_id : action_to_company_id,
                        to_consumer_id : attributes.cons_id,
                        project_id : iif((isdefined("attributes.project_id") and len(attributes.project_id) and isDefined("attributes.project_name") and len(attributes.project_name)),attributes.project_id,de('')),
                        islem_belge_no : attributes.paper_number,
                        due_date : attributes.action_date,
                        special_definition_id : iif((isdefined("attributes.special_definition_id") and len(attributes.special_definition_id)),'attributes.special_definition_id',de('')),
                        assetp_id : iif((isdefined("attributes.asset_id") and len(attributes.asset_id) and len(attributes.asset_name)),'attributes.asset_id',de('')),
                        rate2:paper_currency_multiplier
                        );
                }
            }
        }
        else if(isdefined("attributes.invoice_id"))
            cari_sil(action_id:attributes.CREDITCARD_EXPENSE_ID,process_type:old_process_type_credit);
    </cfscript>
<cfelse>
		<cfquery name="GET_CREDIT_ACTIONS" datasource="#dsn3#">
			SELECT CREDITCARD_EXPENSE_ID FROM CREDIT_CARD_BANK_EXPENSE WHERE INVOICE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.invoice_id#"> 
		</cfquery>
		<cfif GET_CREDIT_ACTIONS.recordcount>
			<cfquery name="DEL_CARD_ACTIONS" datasource="#dsn3#">
				DELETE FROM CREDIT_CARD_BANK_EXPENSE WHERE INVOICE_ID = #GET_INVOICE.INVOICE_ID#
			</cfquery>
			<cfscript>
				muhasebe_sil(action_id:GET_CREDIT_ACTIONS.CREDITCARD_EXPENSE_ID, process_type:242);
				cari_sil(action_id:GET_CREDIT_ACTIONS.CREDITCARD_EXPENSE_ID, process_type:242);
			</cfscript>
		</cfif>
</cfif>
<!--- Kredi kartı işlemleri --->
</cflock>

<cfset attributes.actionId=attributes.invoice_id>
<!---Ek Bilgiler--->
<cfset attributes.info_id =  attributes.invoice_id>
<cfset attributes.is_upd = 1>
<cfset attributes.info_type_id = -8>
<cfinclude template="../../objects/query/add_info_plus2.cfm">
<!---Ek Bilgiler--->
<script type="text/javascript">
	window.location.href="<cfoutput>#request.self#?fuseaction=invent.add_invent_purchase&event=upd&invoice_id=#attributes.invoice_id#</cfoutput>";
</script>
