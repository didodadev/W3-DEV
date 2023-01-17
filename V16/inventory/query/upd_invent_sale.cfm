<cfif form.active_period neq session.ep.period_id>
	<script type="text/javascript">
		alert("<cf_get_lang_main no='1659.İşlem Yapmak İstediğiniz Muhasebe Dönemi ile Aktif Muhasebe Döneminiz Farklı Muhasebe Döneminizi Kontrol Ediniz'>!");
		history.back();
	</script>
	<cfabort>
</cfif>
<cfset wrk_id = dateformat(now(),'YYYYMMDD')&timeformat(now(),'HHmmss')&'_#session.ep.userid#_'&round(rand()*100)>
<cf_date tarih='attributes.invoice_date'>
<cfif isdefined("attributes.basket_due_value_date_") and isdate(attributes.basket_due_value_date_)>
	<cf_date tarih="attributes.basket_due_value_date_">
	<cfset invoice_due_date = '#attributes.basket_due_value_date_#'>
<cfelse>
	<cfset invoice_due_date = "">
</cfif>
<cfif not isdefined("form.invoice_number")>
	<cfif isdefined('form.serial_number') and len(form.serial_number)>
		<cfset form.invoice_number = "#form.serial_number#-#form.serial_no#">
	<cfelse>
		<cfset form.invoice_number = "#form.serial_no#">
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
	if (not (isdefined("attributes.project_id") and len(attributes.project_id) and isdefined("attributes.project_head") and len(attributes.project_head)))
		attributes.project_id = '';
	if(isdefined('attributes.acc_department_id') and len(attributes.acc_department_id) )
		acc_department_id = attributes.acc_department_id;
	else
		acc_department_id = '';	
</cfscript>
<cfset form.invoice_number = Trim(form.invoice_number)>
<cfset form.ship_number = Trim(form.ship_number)>
<cfquery name="GET_INVOICE_CONTROL" datasource="#dsn2#">
	SELECT
		INVOICE_NUMBER
	FROM
		INVOICE
	WHERE
		PURCHASE_SALES = 1 AND
		INVOICE_ID <> #attributes.invoice_id# AND
		INVOICE_NUMBER = '#form.invoice_number#'
</cfquery>
<cfquery name="GET_INVOICE" datasource="#dsn2#">
	SELECT INVOICE_NUMBER,CASH_ID,WRK_ID FROM INVOICE WHERE INVOICE_ID = #attributes.invoice_id#
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
		INV_S.SHIP_PERIOD_ID =#session.ep.period_id# AND
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
					PURCHASE_SALES = 1,
					DUE_DATE = <cfif len(invoice_due_date) and isdate(invoice_due_date)>#invoice_due_date#<cfelse>NULL</cfif>,		
					PROJECT_ID = <cfif len(attributes.project_id)>#attributes.project_id#<cfelse>NULL</cfif>,
					SERIAL_NUMBER = '#FORM.SERIAL_NUMBER#',
					SERIAL_NO = '#FORM.SERIAL_NO#',
					INVOICE_NUMBER = '#FORM.INVOICE_NUMBER#',
					INVOICE_CAT = #process_type#,
					INVOICE_DATE = #attributes.invoice_date#,
					COMPANY_ID = <cfif len(attributes.company_id)>#attributes.company_id#<cfelse>NULL</cfif>,
					CONSUMER_ID = <cfif len(attributes.consumer_id)>#attributes.consumer_id#<cfelse>NULL</cfif>,
					EMPLOYEE_ID = <cfif len(attributes.emp_id)>#attributes.emp_id#<cfelse>NULL</cfif>,
					ACC_TYPE_ID = <cfif isdefined("acc_type_id") and len(acc_type_id)>#acc_type_id#<cfelse>NULL</cfif>,
					PARTNER_ID = <cfif isDefined("attributes.partner_id") and len(attributes.partner_id)>#attributes.partner_id#<cfelse>NULL</cfif>,
					NETTOTAL = #attributes.net_total_amount#,
					GROSSTOTAL = #attributes.total_amount#,
					TAXTOTAL = #attributes.kdv_total_amount#, 
					OTV_TOTAL = #attributes.otv_total_amount#,
					SA_DISCOUNT = #attributes.net_total_discount#,
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
					STOPAJ = <cfif len(attributes.stopaj)>#attributes.stopaj#<cfelse>NULL</cfif>,
					STOPAJ_ORAN = <cfif len(attributes.stopaj_yuzde)>#attributes.stopaj_yuzde#<cfelse>NULL</cfif>,
					STOPAJ_RATE_ID = <cfif isdefined("attributes.stopaj_rate_id") and len(attributes.stopaj_rate_id)>#attributes.stopaj_rate_id#<cfelse>NULL</cfif>,
                    SHIP_ADDRESS_ID = <cfif isdefined("attributes.ship_address_id") and len(attributes.ship_address_id) and isdefined("attributes.adres") and len(attributes.adres)>#attributes.ship_address_id#<cfelse>NULL</cfif>,
                    SHIP_ADDRESS = <cfif isdefined("attributes.adres") and len(attributes.adres) and isdefined("attributes.ship_address_id") and len(attributes.ship_address_id)>'#attributes.adres#'<cfelse>NULL</cfif>
				WHERE
					INVOICE_ID = #attributes.invoice_id#
		</cfquery>
		<cfquery name="DEL_INVENTORY_ROW" datasource="#dsn2#">
			DELETE FROM #dsn3_alias#.INVENTORY_ROW WHERE ACTION_ID = #attributes.invoice_id# AND PROCESS_TYPE = #process_type# AND PERIOD_ID = #session.ep.period_id#
		</cfquery>
		<cfquery name="DEL_ROW" datasource="#dsn2#">
			DELETE FROM INVOICE_ROW WHERE INVOICE_ID = #attributes.invoice_id#
		</cfquery>
		<cfquery name="DEL_SHIP_ROW" datasource="#dsn2#">
			DELETE FROM SHIP_ROW WHERE SHIP_ID = #get_ship.ship_id#
		</cfquery>
		<cfquery name="DEL_SHIP" datasource="#dsn2#">
			DELETE FROM SHIP WHERE SHIP_ID = #get_ship.ship_id#
		</cfquery>
		<cfquery name="DEL_SHIP_ROW_MONEY" datasource="#dsn2#">
			DELETE FROM SHIP_MONEY WHERE ACTION_ID = #get_ship.ship_id#
		</cfquery>			
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
					1,
					'#form.ship_number#',
					83,
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
		<cfloop from="1" to="#attributes.record_num#" index="i">
		  <cfif isdefined("attributes.row_kontrol#i#") and evaluate("attributes.row_kontrol#i#")>
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
					STOCK_OUT,
					ACTION_DATE,
					STOCK_ID,
					PRODUCT_ID
				)
				VALUES
				(
					#evaluate("attributes.invent_id#i#")#,
					#session.ep.period_id#,
					#attributes.invoice_id#,
					'#FORM.INVOICE_NUMBER#',
					#process_type#,
					#evaluate("attributes.quantity#i#")#,
					#evaluate("attributes.quantity#i#")#,
					#attributes.invoice_date#,
					<cfif len(evaluate("attributes.stock_id#i#")) and len(evaluate("attributes.product_name#i#"))>#evaluate("attributes.stock_id#i#")#<cfelse>NULL</cfif>,
					<cfif len(evaluate("attributes.product_id#i#")) and len(evaluate("attributes.product_name#i#"))>#evaluate("attributes.product_id#i#")#<cfelse>NULL</cfif>
				)
			</cfquery>
			<cfquery name="upd_inventory" datasource="#dsn2#">
				UPDATE
					#dsn3_alias#.INVENTORY
				SET
					SALE_DIFF_ACCOUNT_ID = <cfif len(evaluate("attributes.budget_account_id#i#"))>'#wrk_eval("attributes.budget_account_id#i#")#'<cfelse>NULL</cfif>,
					AMORT_DIFF_ACCOUNT_ID = <cfif len(evaluate("attributes.amort_account_id#i#"))>'#wrk_eval("attributes.amort_account_id#i#")#'<cfelse>NULL</cfif>,
					SALE_EXPENSE_CENTER_ID = <cfif len(evaluate("attributes.expense_center_name#i#")) and len(evaluate("attributes.expense_center_id#i#"))>#evaluate("attributes.expense_center_id#i#")#<cfelse>NULL</cfif>,
					SALE_EXPENSE_ITEM_ID = <cfif len(evaluate("attributes.budget_item_name#i#")) and len(evaluate("attributes.budget_item_id#i#"))>#evaluate("attributes.budget_item_id#i#")#<cfelse>NULL</cfif>,
					ACCOUNT_ID = <cfif len(evaluate("attributes.account_id#i#"))>'#evaluate("attributes.account_id#i#")#'<cfelse>NULL</cfif>,
					PROJECT_ID = <cfif len(attributes.project_id)>#attributes.project_id#<cfelse>NULL</cfif>
				WHERE
					INVENTORY_ID = #evaluate("attributes.invent_id#i#")#
			</cfquery>
			 <cfif isdefined('attributes.reason_code#i#') and len(evaluate('attributes.reason_code#i#'))>
				<cfset reasonCode = Replace(evaluate('attributes.reason_code#i#'),'--','*')>
			<cfelse>
				<cfset reasonCode = ''>
			</cfif>
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
					OTV_ORAN,
					REASON_CODE,
            		REASON_NAME
				)
				VALUES
				(
					1,
					#evaluate("attributes.invent_id#i#")#,
					<cfif len(evaluate("attributes.product_id#i#")) and len(evaluate("attributes.product_name#i#"))>#evaluate("attributes.product_id#i#")#,<cfelse>NULL,</cfif>
					'#left(evaluate("attributes.invent_name#i#"),100)#',
					<cfif len(evaluate("attributes.product_name#i#"))>'#wrk_eval("attributes.product_name#i#")#',<cfelse>NULL,</cfif>
					#attributes.invoice_id#,
					<cfif len(evaluate("attributes.stock_id#i#")) and len(evaluate("attributes.product_name#i#"))>#evaluate("attributes.stock_id#i#")#,<cfelse>NULL,</cfif>
					#evaluate("attributes.quantity#i#")#,
					<cfif len(evaluate("attributes.stock_unit#i#"))>'#wrk_eval("attributes.stock_unit#i#")#',<cfelse>NULL,</cfif>
					<cfif len(evaluate("attributes.stock_unit_id#i#"))>#evaluate("attributes.stock_unit_id#i#")#,<cfelse>NULL,</cfif>		
					#evaluate("attributes.row_total_#i#")#,
                    #(evaluate("attributes.row_total_#i#") * evaluate("attributes.quantity#i#")) + evaluate("attributes.kdv_total#i#") + evaluate("attributes.otv_total#i#")#,
					#evaluate("attributes.row_total_#i#") * evaluate("attributes.quantity#i#")#,
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
					<cfif len(reasonCode) and reasonCode contains '*'>
						,<cfqueryparam cfsqltype="cf_sql_integer" value="#listfirst(reasonCode,'*')#">
						,<cfqueryparam cfsqltype="cf_sql_varchar" value="#listLast(reasonCode,'*')#">
					<cfelse>
						,NULL
						,NULL
					</cfif>
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
					'#left(evaluate("attributes.invent_name#i#"),75)#',
					#MAX_ID.IDENTITYCOL#,
					<cfif len(evaluate("attributes.stock_id#i#"))>#evaluate("attributes.stock_id#i#")#,<cfelse>NULL,</cfif>
					<cfif len(evaluate("attributes.product_id#i#"))>#evaluate("attributes.product_id#i#")#,<cfelse>NULL,</cfif>
					#evaluate("attributes.quantity#i#")#,
					<cfif len(evaluate("attributes.stock_unit#i#"))>'#wrk_eval("attributes.stock_unit#i#")#',<cfelse>NULL,</cfif>
					<cfif len(evaluate("attributes.stock_unit_id#i#"))>#evaluate("attributes.stock_unit_id#i#")#,<cfelse>NULL,</cfif>		
					#evaluate("attributes.tax_rate#i#")#,
					#evaluate("attributes.row_total_#i#")#,
					1,
					#(evaluate("attributes.row_total_#i#") * evaluate("attributes.quantity#i#")) + evaluate("attributes.kdv_total#i#")#,
					#evaluate("attributes.row_total_#i#") * evaluate("attributes.quantity#i#")#,
				    #evaluate("attributes.kdv_total#i#")#, 
					#attributes.invoice_date#,
					#attributes.department_id#,
					#attributes.location_id#,
					'#listgetat(evaluate("attributes.money_id#i#"),1,',')#',
					<cfif len(evaluate("attributes.row_other_total#i#"))>#wrk_round(evaluate("attributes.row_other_total#i#")/((evaluate("attributes.tax_rate#i#")+100)/100))#,<cfelse>NULL,</cfif><!--- kdvsiz döviz toplam --->
					<cfif len(evaluate("attributes.row_other_total#i#"))>#evaluate("attributes.row_other_total#i#")#,<cfelse>NULL,</cfif><!--- kdvli döviz toplaam --->
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
					#MAX_ID.IDENTITYCOL#,
					'#form.ship_number#',
					1, <!--- faturanın kendi irsaliyesi --->
					#session.ep.period_id#
				)
		</cfquery>
	
		<!--- cari - muhasebe - kasa kayıtları --->
		<cfinclude template="upd_invent_sale_1.cfm">		
		
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
					#MAX_ID.IDENTITYCOL#,
					'#wrk_eval("attributes.hidden_rd_money_#i#")#',
					#evaluate("attributes.txt_rate2_#i#")#,
					#evaluate("attributes.txt_rate1_#i#")#,
					<cfif evaluate("attributes.hidden_rd_money_#i#") is rd_money_value>1<cfelse>0</cfif>
				)
			</cfquery>
		</cfloop>
        
        <!--- Tevkifat islemleri BK 20150522 --->
        <cfquery name="DEL_INVOICE_TAXES" datasource="#dsn2#">
            DELETE FROM INVOICE_TAXES WHERE INVOICE_ID=#form.invoice_id#
        </cfquery>
        
        <cfif isdefined("attributes.tevkifat_box") and isdefined("attributes.tevkifat_oran") and len(attributes.tevkifat_oran)>
            <cfset list_tax = ''>
            <cfloop from="1" to="#attributes.record_num#" index="i">
                <cfset temp_kdv = evaluate("attributes.tax_rate#i#")>
                <cfif not listfind(list_tax,evaluate("attributes.tax_rate#i#"))>
                    <cfset list_tax=listappend(list_tax,temp_kdv)>
                </cfif>
                <cfif not isdefined("temp_tevkifat_tutar_#temp_kdv#")>
                    <cfset 'temp_tevkifat_tutar_#temp_kdv#' = evaluate("attributes.kdv_total#i#")>
                <cfelse>
                    <cfset 'temp_tevkifat_tutar_#temp_kdv#' = evaluate("temp_tevkifat_tutar_#temp_kdv#") + evaluate("attributes.kdv_total#i#")>
                </cfif>
            </cfloop>
            
            <cfloop from="1" to="#listlen(list_tax)#" index="tax_i">
            	<cfif listgetat(list_tax,tax_i) neq 0>
					<cfset 'attributes.tevkifat_tutar_#listgetat(list_tax,tax_i)#' = evaluate("temp_tevkifat_tutar_#listgetat(list_tax,tax_i)#") - evaluate("temp_tevkifat_tutar_#listgetat(list_tax,tax_i)#")* attributes.tevkifat_oran>
                    <cfset 'attributes.beyan_tutar_#listgetat(list_tax,tax_i)#' = (evaluate("temp_tevkifat_tutar_#listgetat(list_tax,tax_i)#") * attributes.tevkifat_oran)*100>
                    <cfquery name="ADD_INVOICE_TAXES" datasource="#dsn2#">
                        INSERT INTO
                            INVOICE_TAXES
                        (
                            INVOICE_ID,
                            TAX,
                            TEVKIFAT_TUTAR,
                            BEYAN_TUTAR					
                        )
                        VALUES
                        (
                            #form.invoice_id#,
                            #listgetat(list_tax,tax_i)#,
                            #evaluate("attributes.tevkifat_tutar_#listgetat(list_tax,tax_i)#")#,
                            #evaluate("attributes.beyan_tutar_#listgetat(list_tax,tax_i)#")#
                        )
                    </cfquery>
                </cfif>
            </cfloop>
        </cfif>      
        
		<cfif len(get_process_type.action_file_name)> <!--- secilen islem kategorisine bir action file eklenmisse --->
			<cf_workcube_process_cat 
				process_cat="#form.process_cat#"
				action_id = #attributes.invoice_id#
				is_action_file = 1
                action_table="INVOICE"
				action_column="INVOICE_ID"
				action_file_name='#get_process_type.action_file_name#'
				action_page='#request.self#?fuseaction=invent.add_invent_sale&event=upd&invoice_id=#attributes.invoice_id#'
				action_db_type = '#dsn2#'
				is_template_action_file = '#get_process_type.action_file_from_template#'>
		</cfif>	
    <cf_add_log employee_id="#session.ep.userid#" log_type="0" action_id="#attributes.invoice_id#" action_name="#form.invoice_number# Güncellendi" paper_no="#form.invoice_number#" period_id="#session.ep.period_id#" process_type="#get_process_type.PROCESS_TYPE#" data_source="#dsn2#">
	</cftransaction>
</cflock>
<cfset attributes.actionId = attributes.invoice_id >
<script type="text/javascript">
	window.location.href = "<cfoutput>#request.self#?fuseaction=invent.add_invent_sale&event=upd&invoice_id=#attributes.invoice_id#</cfoutput>";
</script>
