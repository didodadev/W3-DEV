<cfif listfind('52,53,62',invoice_cat,',')><!--- stok işlemi yapılabilir bir fatura ise --->
	<cfif invoice_cat eq 52>
		<cfset int_ship_process_type = 70>
	<cfelseif invoice_cat eq 53>
		<cfset int_ship_process_type = 71>
	<cfelse>
		<cfset int_ship_process_type = 78>
	</cfif>
	<cfif (GET_BILLED_INFO.PAYMENT_DATE neq pre_payment_date) or
			(GET_BILLED_INFO.SUBSCRIPTION_ID neq pre_subs_id and attributes.multi_sale_grup eq 1) or
			(GET_BILLED_INFO.INVOICE_COMPANY_ID neq pre_comp_id) or
            (GET_BILLED_INFO.INVOICE_CONSUMER_ID neq pre_cons_id) or
			(GET_BILLED_INFO.PAYMETHOD_ID neq pre_pay_type) or
			(GET_BILLED_INFO.CARD_PAYMETHOD_ID neq pre_card_type) or
			(invoice_other_money neq pre_money_type)>
		<cfquery name="ADD_SALE" datasource="#dsn2#">
			INSERT INTO SHIP
				(
					WRK_ID,
					PAYMETHOD_ID,
					CARD_PAYMETHOD_ID,
					PURCHASE_SALES,
					SHIP_NUMBER,
					SHIP_TYPE,
					SHIP_DATE,
					DELIVER_DATE,
					COMPANY_ID,
					PARTNER_ID,
					CONSUMER_ID,
					DISCOUNTTOTAL,
					NETTOTAL,
					GROSSTOTAL,
					TAXTOTAL,
					OTHER_MONEY,
					OTHER_MONEY_VALUE,
					DELIVER_STORE_ID,
					LOCATION,
					RECORD_DATE,
					RECORD_EMP,
					IS_WITH_SHIP
				)
			VALUES
				(
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#wrk_id#">,
					<cfif len(GET_BILLED_INFO.PAYMETHOD_ID)>#GET_BILLED_INFO.PAYMETHOD_ID#<cfelse>NULL</cfif>,
					<cfif len(GET_BILLED_INFO.CARD_PAYMETHOD_ID)>#GET_BILLED_INFO.CARD_PAYMETHOD_ID#<cfelse>NULL</cfif>,
					1,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.invoice_number#">,
					#int_ship_process_type#,
					#attributes.invoice_date#,
					#attributes.invoice_date#,
				<cfif len(GET_BILLED_INFO.INVOICE_COMPANY_ID)>
					#GET_BILLED_INFO.INVOICE_COMPANY_ID#,
					<cfif len(GET_BILLED_INFO.INVOICE_PARTNER_ID)>#GET_BILLED_INFO.INVOICE_PARTNER_ID#<cfelse>NULL</cfif>,
					NULL,
				<cfelse>
					NULL,
					NULL,
					#GET_BILLED_INFO.INVOICE_CONSUMER_ID#,
				</cfif>
					<!--- '#LEFT(TRIM(DELIVER_GET),50)#',--->
					#toplam_indirim * miktar#,
					#kdvli_toplam#,
					#toplam#,
					#kdv_toplam#,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#invoice_other_money#">,
					#other_money_tutar#,
					#attributes.department_id#,
					#attributes.location_id#,
					#NOW()#,
					#SESSION.EP.USERID#,
					1
				)
		</cfquery>	
		<cfquery name="GET_SHIP_ID" datasource="#dsn2#">
			SELECT MAX(SHIP_ID) AS MAX_ID FROM SHIP WHERE WRK_ID = '#wrk_id#'
		</cfquery>
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
					#get_invoice_id.max_id#,					
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.invoice_number#">,
					#GET_SHIP_ID.MAX_ID#,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.invoice_number#">,
					1, <!--- faturanın kendi irsaliyesi --->
					#session.ep.period_id#
				)
		</cfquery>
	</cfif>
	<cfif inventory_product_exists eq 1><!--- envantere dahil ürün satırı ise --->
		<!--- <cfinclude template="get_dis_amount.cfm"> --->
		<cfquery name="ADD_SHIP_ROW" datasource="#dsn2#">
			INSERT INTO SHIP_ROW
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
					DISCOUNT,
					DISCOUNTTOTAL,
					GROSSTOTAL, 
					NETTOTAL,
					TAXTOTAL,
					OTVTOTAL,
					OTV_ORAN,
					OTHER_MONEY,
					OTHER_MONEY_VALUE,
					DELIVER_DATE,
					DELIVER_DEPT,
					DELIVER_LOC,
					IS_PROMOTION
				)
			VALUES
				(
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#left(GET_BILLED_INFO.DETAIL,75)#">,
					#GET_SHIP_ID.MAX_ID#,
					#GET_BILLED_INFO.STOCK_ID#,
					#GET_BILLED_INFO.PRODUCT_ID#,
					#GET_BILLED_INFO.QUANTITY#,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#GET_BILLED_INFO.UNIT#">,
					#GET_BILLED_INFO.PRODUCT_UNIT_ID#,					
					#GET_BILLED_INFO.TAX#,
					#tutar#,
					1,
					#GET_BILLED_INFO.DISCOUNT#,
					#toplam_indirim * miktar#,
					#kdvli_toplam#,
					#(tutar - toplam_indirim) * miktar#,
					#kdv_toplam#,
					#otv_toplam#,
					<cfif len(GET_BILLED_INFO.OTV)>#GET_BILLED_INFO.OTV#<cfelse>0</cfif>,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#invoice_other_money#">,
					#(GET_BILLED_INFO.AMOUNT - (GET_BILLED_INFO.AMOUNT * GET_BILLED_INFO.DISCOUNT/100)) * miktar#,
					#attributes.invoice_date#,
					#attributes.department_id#,
					#attributes.location_id#,
					0
				)
		</cfquery>
		<cfif get_process_type.IS_STOCK_ACTION eq 1><!--- Stok hareketi yapılsın --->
			<cfquery name="GET_UNIT" datasource="#dsn2#">
				SELECT 
					ADD_UNIT,
					MULTIPLIER,
					MAIN_UNIT,
					PRODUCT_UNIT_ID
				FROM
					#dsn3_alias#.PRODUCT_UNIT 
				WHERE
					PRODUCT_ID = #GET_BILLED_INFO.PRODUCT_ID# AND
					ADD_UNIT = '#GET_BILLED_INFO.UNIT#'
			</cfquery>
			<cfif get_unit.recordcount and len(get_unit.multiplier)>
				<cfset multi = get_unit.multiplier*GET_BILLED_INFO.QUANTITY>
			<cfelse>
				<cfset multi = GET_BILLED_INFO.QUANTITY>
			</cfif>
			<cfquery name="ADD_STOCK_ROW" datasource="#dsn2#">
				INSERT INTO STOCKS_ROW
					(
						UPD_ID,
						PRODUCT_ID,
						STOCK_ID,
						PROCESS_TYPE,
						STOCK_OUT,
						STORE,
						STORE_LOCATION,
						PROCESS_DATE
					)
				VALUES
					(
						#GET_SHIP_ID.MAX_ID#,
						#GET_BILLED_INFO.PRODUCT_ID#,
						#GET_BILLED_INFO.STOCK_ID#,
						#int_ship_process_type#,
						#multi#,
						#attributes.department_id#,
						#attributes.location_id#,
						#attributes.invoice_date#
					)
			</cfquery>
		</cfif>
	</cfif>
	<cfif (GET_BILLED_INFO.PAYMENT_DATE neq GET_BILLED_INFO_2.PAYMENT_DATE) or
			(GET_BILLED_INFO.SUBSCRIPTION_ID neq GET_BILLED_INFO_2.SUBSCRIPTION_ID and attributes.multi_sale_grup eq 1) or
			(GET_BILLED_INFO.INVOICE_COMPANY_ID neq GET_BILLED_INFO_2.INVOICE_COMPANY_ID) or
            (GET_BILLED_INFO.INVOICE_CONSUMER_ID neq GET_BILLED_INFO_2.INVOICE_CONSUMER_ID) or
			(GET_BILLED_INFO.PAYMETHOD_ID neq GET_BILLED_INFO_2.PAYMETHOD_ID) or
			(GET_BILLED_INFO.CARD_PAYMETHOD_ID neq GET_BILLED_INFO_2.CARD_PAYMETHOD_ID) or
			(invoice_other_money neq GET_BILLED_INFO_2.MONEY_TYPE_)>
		<cfquery name="UPD_SHIP" datasource="#DSN2#">
			UPDATE SHIP
				SET 
					GROSSTOTAL = #toplam_main#,
					NETTOTAL = #kdvli_toplam_main#,
					TAXTOTAL = #kdv_toplam_main#,
					OTHER_MONEY_VALUE = #wrk_round(other_money_tutar_main)#
				WHERE
					SHIP_ID = #GET_SHIP_ID.MAX_ID#
		</cfquery>
	</cfif>
</cfif>
<cfif (GET_BILLED_INFO.PAYMENT_DATE neq pre_payment_date) or
		(GET_BILLED_INFO.SUBSCRIPTION_ID neq pre_subs_id and attributes.multi_sale_grup eq 1) or
		(GET_BILLED_INFO.INVOICE_COMPANY_ID neq pre_comp_id) or
        (GET_BILLED_INFO.INVOICE_CONSUMER_ID neq pre_cons_id) or
		(GET_BILLED_INFO.PAYMETHOD_ID neq pre_pay_type) or
		(GET_BILLED_INFO.CARD_PAYMETHOD_ID neq pre_card_type) or
		(invoice_other_money neq pre_money_type)>
	<cfif isDefined("xml_money_type") and xml_money_type eq 5 and len(rate_count)><!--- xml deki kuru risk bilgilerinden alsın parametresi --->
		<cfloop from="1" to="#rate_count#" index="mm">
			<cfif Len(GET_RATE_INFO.RATE_INFO[mm])>
			<cfquery name="ADD_INVOICE_MONEY" datasource="#dsn2#">
				INSERT INTO
					INVOICE_MONEY
					(
						ACTION_ID,
						MONEY_TYPE,
						RATE2,
						RATE1,
						IS_SELECTED
					)
					VALUES
					(
						#get_invoice_id.max_id#,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#GET_RATE_INFO.MONEY[mm]#">,
						#GET_RATE_INFO.RATE_INFO[mm]#,
						#GET_RATE_INFO.RATE1[mm]#,
						<cfif (GET_RATE_INFO.MONEY[mm] eq invoice_other_money)>
						1
						<cfelse>
						0
						</cfif>
					)
			</cfquery>
			</cfif>
		</cfloop>
		<cfquery name="get_invoice_money" datasource="#dsn2#">
			SELECT MONEY_TYPE FROM INVOICE_MONEY WHERE ACTION_ID = #get_invoice_id.max_id# AND MONEY_TYPE = '#session.ep.money#'
		</cfquery>
		<cfif not get_invoice_money.recordcount>
			<!--- Money_History tablosunda Session.ep.money olmadigindan faturadaki kur eksik olusuyordu bu sekilde duzenlendi FBS 20120511 --->
			<cfquery name="ADD_INVOICE_MONEY_SYSTEM" datasource="#dsn2#">
				INSERT INTO
					INVOICE_MONEY
					(
						ACTION_ID,
						MONEY_TYPE,
						RATE2,
						RATE1,
						IS_SELECTED
					)
					SELECT TOP 1
						#get_invoice_id.max_id#,
						MONEY,
						RATE2,
						RATE1,
						<cfif invoice_other_money eq session.ep.money>1<cfelse>0</cfif>
					FROM
						SETUP_MONEY
					WHERE
						MONEY = <cfqueryparam cfsqltype="cf_sql_varchar" value="#session.ep.money#"> AND
						PERIOD_ID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#session.ep.period_id#"> AND
						COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#session.ep.company_id#">
			</cfquery>
		</cfif>
	<cfelse>
		<cfloop from="1" to="#attributes.kur_say#" index="mm">
			<cfquery name="ADD_INVOICE_MONEY" datasource="#dsn2#">
				INSERT INTO
					INVOICE_MONEY
					(
						ACTION_ID,
						MONEY_TYPE,
						RATE2,
						RATE1,
						IS_SELECTED
					)
					VALUES
					(
						#get_invoice_id.max_id#,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#wrk_eval('attributes.money_type_#mm#')#">,
						#evaluate("attributes.money_rate2_#mm#")#,
						#evaluate("attributes.money_rate1_#mm#")#,
						<cfif (evaluate("attributes.money_type_#mm#") eq invoice_other_money)>
						1
						<cfelse>
						0
						</cfif>
					)
			</cfquery>
		</cfloop>
	</cfif>
</cfif>
