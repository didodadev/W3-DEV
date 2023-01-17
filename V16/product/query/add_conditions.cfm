<cfif not IsDefined('attributes.is_record_active')>
	<script type="text/javascript">
	alert("<cf_get_lang no ='804.En az 1 ürün seçmelisiniz'>!");
	history.back();
	</script>
	<cfabort>
</cfif>
<cf_date tarih='attributes.start_date'>
<cf_date tarih='attributes.finish_date'>
<cfset compids = "#session.ep.company_id#">
<cfif attributes.compid>
	<cfset compids = "#compids#,#attributes.compid#">
</cfif>
<cfif listgetat(attributes.form_purchase_sales,1,",") eq 1>
	<cfloop list="#attributes.is_record_active#" index="record_PRODUCT_ID">
		<cfscript>
			attributes.form_discount1 = evaluate('attributes.discount1#record_PRODUCT_ID#');
			attributes.form_discount2 = evaluate('attributes.discount2#record_PRODUCT_ID#');
			attributes.form_discount3 = evaluate('attributes.discount3#record_PRODUCT_ID#');
			attributes.form_discount4 = evaluate('attributes.discount4#record_PRODUCT_ID#');
			attributes.form_discount5 = evaluate('attributes.discount5#record_PRODUCT_ID#');
			attributes.form_paymethod_id = evaluate('attributes.paymethod_type#record_PRODUCT_ID#');
			attributes.form_discount_cash = evaluate('attributes.discount_cash#record_PRODUCT_ID#');
			attributes.price_money = evaluate('attributes.price_money_#record_PRODUCT_ID#');
			attributes.form_old_price_amount = filterNum(evaluate('attributes.old_price_amount#record_PRODUCT_ID#'));
			attributes.form_price_amount = filterNum(evaluate('attributes.price_amount#record_PRODUCT_ID#'));
			attributes.tax_deger = evaluate('attributes.tax_deger#record_PRODUCT_ID#');
			if(not len(attributes.price_money)) attributes.price_money = session.ep.money;
			
			if(isdefined('attributes.extra_product_1_#record_PRODUCT_ID#'))
				attributes.form_extra_product_1 = evaluate('attributes.extra_product_1_#record_PRODUCT_ID#');
			else
				attributes.form_extra_product_1 ='';
			if(isdefined('attributes.extra_product_2_#record_PRODUCT_ID#'))
				attributes.form_extra_product_2 = evaluate('attributes.extra_product_2_#record_PRODUCT_ID#');
			else
				attributes.form_extra_product_2 ='';
			if(isdefined('attributes.rebate_cash_1_#record_PRODUCT_ID#'))
				attributes.form_rebate_cash_1 = evaluate('attributes.rebate_cash_1_#record_PRODUCT_ID#');
			else
				attributes.form_rebate_cash_1 ='';

			if(isdefined('attributes.rebate_rate_#record_PRODUCT_ID#'))
				attributes.form_rebate_rate = evaluate('attributes.rebate_rate_#record_PRODUCT_ID#');
			else
				attributes.form_rebate_rate ='';
			if(isdefined('attributes.return_day_#record_PRODUCT_ID#'))
				attributes.form_return_day = evaluate('attributes.return_day_#record_PRODUCT_ID#');
			else
				attributes.form_return_day ='';
			if(isdefined('attributes.return_day_#record_PRODUCT_ID#'))
				attributes.form_return_rate = evaluate('attributes.return_rate_#record_PRODUCT_ID#');
			else
				attributes.form_return_rate ='';
			if(isdefined('attributes.price_protection_day_#record_PRODUCT_ID#'))
				attributes.form_price_protection_day = evaluate('attributes.price_protection_day_#record_PRODUCT_ID#');
			else
				attributes.form_price_protection_day ='';
		</cfscript>
		<cfloop list="#compids#" index="dsn3_compid">
			<cflock name="#createuuid()#" timeout="60">
				<cftransaction>

					<!--- ürün fiyatında değişim yapılmışsa --->
					<cfif attributes.form_old_price_amount neq attributes.form_price_amount>
						<cfquery name="GET_UNIT" datasource="#dsn#_#dsn3_compid#">
							SELECT 
								PRODUCT_UNIT_ID 
							FROM 
								#dsn1#.PRODUCT_UNIT 
							WHERE 
								PRODUCT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#record_PRODUCT_ID#"> AND 
								IS_MAIN = <cfqueryparam cfsqltype="cf_sql_smallint" value="1"> AND 
								PRODUCT_UNIT_STATUS = 1
						</cfquery>
						<cfquery name="GET_PRICE_STANDART" datasource="#dsn#_#dsn3_compid#">
							SELECT 
								IS_KDV, MONEY
							FROM 
								#dsn1#.PRICE_STANDART 
							WHERE 
								PRODUCT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#record_PRODUCT_ID#"> AND 
								PRICESTANDART_STATUS = <cfqueryparam cfsqltype="cf_sql_smallint" value="1"> AND
								PURCHASESALES = <cfqueryparam cfsqltype="cf_sql_smallint" value="0">
						</cfquery>

						<cfif isnumeric(attributes.form_price_amount)>
							<cfif GET_PRICE_STANDART.IS_KDV EQ 1>
								<cfset price_kdvsiz = wrk_round(attributes.form_price_amount*100/(attributes.tax_deger+100),session.ep.our_company_info.sales_price_round_num)>
								<cfset price_kdvli = attributes.form_price_amount>
								<cfset price_is_tax_included = 1>
							<cfelse>
								<cfset price_kdvsiz = attributes.form_price_amount>
								<cfset price_kdvli = wrk_round(attributes.form_price_amount*(1+(attributes.tax_deger/100)),session.ep.our_company_info.sales_price_round_num)>
								<cfset price_is_tax_included = 0>
							</cfif>
						<cfelse>
							<cfset price_kdvsiz = 0>
							<cfset price_kdvli = 0>
							<cfset price_is_tax_included = 0>
						</cfif>
						<cfquery name="CORRECT_PRICE_0" datasource="#dsn#_#dsn3_compid#">
							UPDATE 
								#dsn1#.PRICE_STANDART
							SET 
								PRICESTANDART_STATUS = <cfqueryparam cfsqltype="cf_sql_smallint" value="0">,
								RECORD_EMP = <cfqueryparam cfsqltype="cf_sql_integer" value="#SESSION.EP.USERID#">
							WHERE 
								PRODUCT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#record_PRODUCT_ID#"> AND 
								PURCHASESALES = <cfqueryparam cfsqltype="cf_sql_smallint" value="0"> AND
								UNIT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#GET_UNIT.PRODUCT_UNIT_ID#"> AND
								PRICESTANDART_STATUS = <cfqueryparam cfsqltype="cf_sql_smallint" value="1">
						</cfquery>
						<cfquery name="ADD_STANDART_PRICE" datasource="#dsn#_#dsn3_compid#">
							INSERT INTO #dsn1#.PRICE_STANDART 
								(
									PRODUCT_ID,
									PURCHASESALES,							
									PRICE,
									PRICE_KDV,
									IS_KDV,
									ROUNDING,
									START_DATE,
									RECORD_DATE,
									RECORD_IP,
									PRICESTANDART_STATUS,
									MONEY,
									UNIT_ID,
									RECORD_EMP
								)
							VALUES 
								(
									<cfqueryparam cfsqltype="cf_sql_integer" value="#record_PRODUCT_ID#">,
									<cfqueryparam cfsqltype="cf_sql_smallint" value="0">,							
									<cfqueryparam cfsqltype="cf_sql_float" value="#price_kdvsiz#">,
									<cfqueryparam cfsqltype="cf_sql_float" value="#price_kdvli#">,
									<cfqueryparam cfsqltype="cf_sql_smallint" value="#price_is_tax_included#">,
									<cfqueryparam cfsqltype="cf_sql_integer" value="0">,
									<cfqueryparam cfsqltype="cf_sql_timestamp" value="#DateFormat(now(),dateformat_style)#">,
									<cfqueryparam cfsqltype="cf_sql_timestamp" value="#NOW()#">,
									<cfqueryparam cfsqltype="cf_sql_varchar" value="#CGI.REMOTEADDR#">,
									<cfqueryparam cfsqltype="cf_sql_smallint" value="1">,
									<cfqueryparam cfsqltype="cf_sql_varchar" value="#GET_PRICE_STANDART.MONEY#">,
									<cfqueryparam cfsqltype="cf_sql_integer" value="#GET_UNIT.PRODUCT_UNIT_ID#">,
									<cfqueryparam cfsqltype="cf_sql_integer" value="#SESSION.EP.USERID#">
								)						
						</cfquery>
					</cfif>

					<cfquery name="GET_COMPID" datasource="#dsn#_#dsn3_compid#">
						SELECT OUR_COMPANY_ID FROM #dsn1_alias#.PRODUCT_OUR_COMPANY WHERE OUR_COMPANY_ID = #dsn3_compid# AND PRODUCT_ID = #record_PRODUCT_ID#
					</cfquery>
					<cfif GET_COMPID.recordcount>			
						<cfquery name="UPDATE_PREVIOUS_FINISH_DATE" datasource="#dsn#_#dsn3_compid#" maxrows="1">
							UPDATE 
								CONTRACT_PURCHASE_PROD_DISCOUNT 
							SET 
								FINISH_DATE=#DATEADD('s',-1,attributes.start_date)# 
							WHERE 
								PRODUCT_ID=#record_PRODUCT_ID# AND 
								<cfif len(attributes.get_company) and len(attributes.get_company_id)>
									COMPANY_ID=#attributes.get_company_id# AND 
								<cfelse>
									COMPANY_ID IS NULL AND 
								</cfif>
								START_DATE < #attributes.start_date# AND 
								(FINISH_DATE IS NULL OR FINISH_DATE > #attributes.start_date#)
						</cfquery>
						<cfquery name="SELECT_NEXT_PRODUCT_STARTDATE" datasource="#dsn#_#dsn3_compid#" maxrows="1">
							SELECT 
								START_DATE
							FROM 
								CONTRACT_PURCHASE_PROD_DISCOUNT 
							WHERE 
								PRODUCT_ID=#record_PRODUCT_ID# AND
								<cfif len(attributes.get_company) and len(attributes.get_company_id)>COMPANY_ID = #attributes.get_company_id# AND
								<cfelse>COMPANY_ID IS NULL AND
								</cfif>
								START_DATE > #attributes.start_date# 
							ORDER BY 
								START_DATE
						</cfquery>
						<cfquery name="ADD_PURCHASE_PROD_DISCOUNT" datasource="#dsn#_#dsn3_compid#">
							INSERT INTO
								CONTRACT_PURCHASE_PROD_DISCOUNT
								(
									CONTRACT_ID,
									COMPANY_ID,
									PRODUCT_ID, 
									DISCOUNT1,
									DISCOUNT2,
									DISCOUNT3,
									DISCOUNT4,
									DISCOUNT5,
									PAYMETHOD_ID,
									RECORD_EMP, 
									RECORD_IP, 
									RECORD_DATE,
									START_DATE,
									FINISH_DATE,
									EXTRA_PRODUCT_1,
									EXTRA_PRODUCT_2,
									REBATE_CASH_1,
									REBATE_CASH_1_MONEY,
									RETURN_DAY,
									RETURN_RATE,
									PRICE_PROTECTION_DAY,
									DISCOUNT_CASH,
									DISCOUNT_CASH_MONEY,
									REBATE_RATE,
									PROCESS_STAGE,
									RELATED_CONTRACTS
								)
							VALUES
								(
									NULL,
									<cfif len(attributes.company_id) and len(attributes.company_name)>#attributes.company_id#<cfelse>NULL</cfif>,
									#record_PRODUCT_ID#,
									<cfif len(attributes.form_discount1)>#attributes.form_discount1#<cfelse>0</cfif>,
									<cfif len(attributes.form_discount2)>#attributes.form_discount2#<cfelse>0</cfif>,
									<cfif len(attributes.form_discount3)>#attributes.form_discount3#<cfelse>0</cfif>,
									<cfif len(attributes.form_discount4)>#attributes.form_discount4#<cfelse>0</cfif>,
									<cfif len(attributes.form_discount5)>#attributes.form_discount5#<cfelse>0</cfif>,
									<cfif len(attributes.form_paymethod_id)>#attributes.form_paymethod_id#<cfelse>NULL</cfif>,
									#session.ep.userid#,
									'#REMOTE_ADDR#',
									#now()#,
									<cfif len(attributes.start_date)>#attributes.start_date#<cfelse>NULL</cfif>,
									<cfif Len(attributes.finish_date)>
										#attributes.finish_date#
									<cfelseif len(SELECT_NEXT_PRODUCT_STARTDATE.START_DATE)>
										#date_add('s',-1,SELECT_NEXT_PRODUCT_STARTDATE.START_DATE)#
									<cfelse>
										NULL
									</cfif>,
									<cfif len(attributes.form_extra_product_1)>#attributes.form_extra_product_1#<cfelse>NULL</cfif>,
									<cfif len(attributes.form_extra_product_2)>#attributes.form_extra_product_2#<cfelse>NULL</cfif>,
									<cfif len(attributes.form_rebate_cash_1)>#attributes.form_rebate_cash_1#<cfelse>NULL</cfif>,
									<cfif len(attributes.form_rebate_cash_1)>'#attributes.price_money#'<cfelse>NULL</cfif>,
									<cfif len(attributes.form_return_day)>#attributes.form_return_day#<cfelse>NULL</cfif>,
									<cfif len(attributes.form_return_rate)>#attributes.form_return_rate#<cfelse>NULL</cfif>,
									<cfif len(attributes.form_price_protection_day)>#attributes.form_price_protection_day#<cfelse>NULL</cfif>,
									<cfif len(attributes.form_discount_cash)>#attributes.form_discount_cash#<cfelse>NULL</cfif>,
									<cfif len(attributes.form_discount_cash)>'#attributes.price_money#'<cfelse>NULL</cfif>,
									<cfif len(attributes.form_rebate_rate)>#attributes.form_rebate_rate#<cfelse>NULL</cfif>,
									<cfif len(attributes.process_stage)>#attributes.process_stage#<cfelse>NULL</cfif>,
									<cfif len(attributes.contract_id)>#attributes.contract_id#<cfelse>NULL</cfif>
								)
						</cfquery>
					</cfif>
				</cftransaction>
			</cflock>
		</cfloop>
	</cfloop>
<cfelseif listgetat(attributes.form_purchase_sales,1,",") eq 2>
	<cfloop list="#attributes.is_record_active#" index="record_PRODUCT_ID">
		<cfscript>
			attributes.form_discount1 = evaluate('attributes.discount1#record_PRODUCT_ID#');
			attributes.form_discount2 = evaluate('attributes.discount2#record_PRODUCT_ID#');
			attributes.form_discount3 = evaluate('attributes.discount3#record_PRODUCT_ID#');
			attributes.form_discount4 = evaluate('attributes.discount4#record_PRODUCT_ID#');
			attributes.form_discount5 = evaluate('attributes.discount5#record_PRODUCT_ID#');
			attributes.form_paymethod_id = evaluate('attributes.paymethod_type#record_PRODUCT_ID#');
			attributes.form_discount_cash = evaluate('attributes.discount_cash#record_PRODUCT_ID#');
			attributes.price_money = evaluate('attributes.price_money_#record_PRODUCT_ID#');
			attributes.form_old_price_amount = filterNum(evaluate('attributes.old_price_amount#record_PRODUCT_ID#'));
			attributes.form_price_amount = filterNum(evaluate('attributes.price_amount#record_PRODUCT_ID#'));
			attributes.tax_deger = evaluate('attributes.tax_deger#record_PRODUCT_ID#');
			if(not len(attributes.price_money)) attributes.price_money = session.ep.money;
			
			if(isdefined('attributes.extra_product_1_#record_PRODUCT_ID#'))
				attributes.form_extra_product_1 = evaluate('attributes.extra_product_1_#record_PRODUCT_ID#');
			else
				attributes.form_extra_product_1 ='';
			if(isdefined('attributes.extra_product_2_#record_PRODUCT_ID#'))
				attributes.form_extra_product_2 = evaluate('attributes.extra_product_2_#record_PRODUCT_ID#');
			else
				attributes.form_extra_product_2 ='';
			if(isdefined('attributes.rebate_cash_1_#record_PRODUCT_ID#'))
				attributes.form_rebate_cash_1 = evaluate('attributes.rebate_cash_1_#record_PRODUCT_ID#');
			else
				attributes.form_rebate_cash_1 ='';
			if(isdefined('attributes.rebate_rate_#record_PRODUCT_ID#'))
				attributes.form_rebate_rate = evaluate('attributes.rebate_rate_#record_PRODUCT_ID#');
			else
				attributes.form_rebate_rate ='';
			if(isdefined('attributes.return_day_#record_PRODUCT_ID#'))
				attributes.form_return_day = evaluate('attributes.return_day_#record_PRODUCT_ID#');
			else
				attributes.form_return_day ='';
			if(isdefined('attributes.return_day_#record_PRODUCT_ID#'))
				attributes.form_return_rate = evaluate('attributes.return_rate_#record_PRODUCT_ID#');
			else
				attributes.form_return_rate ='';
			if(isdefined('attributes.price_protection_day_#record_PRODUCT_ID#'))
				attributes.form_price_protection_day = evaluate('attributes.price_protection_day_#record_PRODUCT_ID#');
			else
				attributes.form_price_protection_day ='';
		</cfscript>
		<cfloop list="#compids#" index="dsn3_compid">
			<cflock name="#createuuid()#" timeout="60">
				<cftransaction>
					
					<!--- ürün fiyatında değişim yapılmışsa --->
					<cfif attributes.form_old_price_amount neq attributes.form_price_amount>
						<cfquery name="GET_UNIT" datasource="#dsn#_#dsn3_compid#">
							SELECT 
								PRODUCT_UNIT_ID 
							FROM 
								#dsn1#.PRODUCT_UNIT 
							WHERE 
								PRODUCT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#record_PRODUCT_ID#"> AND 
								IS_MAIN = <cfqueryparam cfsqltype="cf_sql_smallint" value="1"> AND 
								PRODUCT_UNIT_STATUS = 1
						</cfquery>
						<cfquery name="GET_PRICE_STANDART" datasource="#dsn#_#dsn3_compid#">
							SELECT 
								IS_KDV, MONEY
							FROM 
								#dsn1#.PRICE_STANDART 
							WHERE 
								PRODUCT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#record_PRODUCT_ID#"> AND 
								PRICESTANDART_STATUS = <cfqueryparam cfsqltype="cf_sql_smallint" value="1"> AND
								PURCHASESALES = <cfqueryparam cfsqltype="cf_sql_smallint" value="1">
						</cfquery>

						<cfif isnumeric(attributes.form_price_amount)>
							<cfif GET_PRICE_STANDART.IS_KDV EQ 1>
								<cfset price_kdvsiz = wrk_round(attributes.form_price_amount*100/(attributes.tax_deger+100),session.ep.our_company_info.sales_price_round_num)>
								<cfset price_kdvli = attributes.form_price_amount>
								<cfset price_is_tax_included = 1>
							<cfelse>
								<cfset price_kdvsiz = attributes.form_price_amount>
								<cfset price_kdvli = wrk_round(attributes.form_price_amount*(1+(attributes.tax_deger/100)),session.ep.our_company_info.sales_price_round_num)>
								<cfset price_is_tax_included = 0>
							</cfif>
						<cfelse>
							<cfset price_kdvsiz = 0>
							<cfset price_kdvli = 0>
							<cfset price_is_tax_included = 0>
						</cfif>
						<cfquery name="CORRECT_PRICE_0" datasource="#dsn#_#dsn3_compid#">
							UPDATE 
								#dsn1#.PRICE_STANDART
							SET 
								PRICESTANDART_STATUS = <cfqueryparam cfsqltype="cf_sql_smallint" value="0">,
								RECORD_EMP = <cfqueryparam cfsqltype="cf_sql_integer" value="#SESSION.EP.USERID#">
							WHERE 
								PRODUCT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#record_PRODUCT_ID#"> AND 
								PURCHASESALES = <cfqueryparam cfsqltype="cf_sql_smallint" value="1"> AND
								UNIT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#GET_UNIT.PRODUCT_UNIT_ID#"> AND
								PRICESTANDART_STATUS = <cfqueryparam cfsqltype="cf_sql_smallint" value="1">
						</cfquery>
						<cfquery name="ADD_STANDART_PRICE" datasource="#dsn#_#dsn3_compid#">
							INSERT INTO #dsn1#.PRICE_STANDART 
								(
									PRODUCT_ID,
									PURCHASESALES,							
									PRICE,
									PRICE_KDV,
									IS_KDV,
									ROUNDING,
									START_DATE,
									RECORD_DATE,
									RECORD_IP,
									PRICESTANDART_STATUS,
									MONEY,
									UNIT_ID,
									RECORD_EMP
								)
							VALUES 
								(
									<cfqueryparam cfsqltype="cf_sql_integer" value="#record_PRODUCT_ID#">,
									<cfqueryparam cfsqltype="cf_sql_smallint" value="1">,							
									<cfqueryparam cfsqltype="cf_sql_float" value="#price_kdvsiz#">,
									<cfqueryparam cfsqltype="cf_sql_float" value="#price_kdvli#">,
									<cfqueryparam cfsqltype="cf_sql_smallint" value="#price_is_tax_included#">,
									<cfqueryparam cfsqltype="cf_sql_integer" value="0">,
									<cfqueryparam cfsqltype="cf_sql_timestamp" value="#DateFormat(now(),dateformat_style)#">,
									<cfqueryparam cfsqltype="cf_sql_timestamp" value="#NOW()#">,
									<cfqueryparam cfsqltype="cf_sql_varchar" value="#CGI.REMOTEADDR#">,
									<cfqueryparam cfsqltype="cf_sql_smallint" value="1">,
									<cfqueryparam cfsqltype="cf_sql_varchar" value="#GET_PRICE_STANDART.MONEY#">,
									<cfqueryparam cfsqltype="cf_sql_integer" value="#GET_UNIT.PRODUCT_UNIT_ID#">,
									<cfqueryparam cfsqltype="cf_sql_integer" value="#SESSION.EP.USERID#">
								)						
						</cfquery>
					</cfif>

					<cfquery name="GET_COMPID" datasource="#dsn#_#dsn3_compid#">
						SELECT OUR_COMPANY_ID FROM #dsn1_alias#.PRODUCT_OUR_COMPANY WHERE OUR_COMPANY_ID = #dsn3_compid# AND PRODUCT_ID = #record_PRODUCT_ID#
					</cfquery>
					<cfif GET_COMPID.recordcount>
						<cfquery name="UPDATE_PREVIOUS_FINISH_DATE" datasource="#dsn#_#dsn3_compid#" maxrows="1">
							UPDATE 
								CONTRACT_SALES_PROD_DISCOUNT 
							SET 
								FINISH_DATE=#DATEADD('s',-1,attributes.start_date)# 
							WHERE 
								PRODUCT_ID=#record_PRODUCT_ID# AND 
								<cfif len(attributes.get_company) and len(attributes.get_company_id)>COMPANY_ID=#attributes.get_company_id# AND 
								<cfelse>COMPANY_ID IS NULL AND 
								</cfif>
								START_DATE < #attributes.start_date# AND 
								(FINISH_DATE IS NULL OR FINISH_DATE > #attributes.start_date#)
						</cfquery>
						<cfquery name="SELECT_NEXT_PRODUCT_STARTDATE" datasource="#dsn#_#dsn3_compid#" maxrows="1">
							SELECT 
								START_DATE
							FROM 
								CONTRACT_SALES_PROD_DISCOUNT 
							WHERE 
								PRODUCT_ID=#record_PRODUCT_ID# AND
								<cfif len(attributes.get_company) and len(attributes.get_company_id)>COMPANY_ID = #attributes.get_company_id# AND
								<cfelse>COMPANY_ID IS NULL AND
								</cfif>
								START_DATE > #attributes.start_date# 
							ORDER BY 
								START_DATE
						</cfquery>
						<cfquery name="ADD_PURCHASE_PROD_DISCOUNT" datasource="#dsn#_#dsn3_compid#" result="MAX_ID">
							INSERT INTO
								CONTRACT_SALES_PROD_DISCOUNT
								(
									CONTRACT_ID,
									COMPANY_ID,
									PRODUCT_ID, 
									DISCOUNT1,
									DISCOUNT2,
									DISCOUNT3,
									DISCOUNT4,
									DISCOUNT5,
									PAYMETHOD_ID,
									RECORD_EMP, 
									RECORD_IP, 
									RECORD_DATE,
									START_DATE,
									FINISH_DATE,
									EXTRA_PRODUCT_1,
									EXTRA_PRODUCT_2,
									REBATE_CASH_1,
									REBATE_CASH_1_MONEY,
									RETURN_DAY,
									RETURN_RATE,
									PRICE_PROTECTION_DAY,
									DISCOUNT_CASH,
									DISCOUNT_CASH_MONEY,
									REBATE_RATE,
									PROCESS_STAGE,
									RELATED_CONTRACTS
								)
							VALUES
								(
									NULL,
									<cfif len(attributes.company_name) and len(attributes.company_id)>#attributes.company_id#<cfelse>NULL</cfif>,
									#record_PRODUCT_ID#,
									<cfif len(attributes.form_discount1)>#attributes.form_discount1#,<cfelse>0,</cfif>
									<cfif len(attributes.form_discount2)>#attributes.form_discount2#,<cfelse>0,</cfif>
									<cfif len(attributes.form_discount3)>#attributes.form_discount3#,<cfelse>0,</cfif>
									<cfif len(attributes.form_discount4)>#attributes.form_discount4#,<cfelse>0,</cfif>
									<cfif len(attributes.form_discount5)>#attributes.form_discount5#,<cfelse>0,</cfif>
									<cfif len(attributes.form_paymethod_id)>#attributes.form_paymethod_id#,<cfelse>NULL,</cfif>
									#session.ep.userid#, 
									'#REMOTE_ADDR#', 
									#now()#,
									<cfif len(attributes.start_date)>#attributes.start_date#<cfelse>NULL</cfif>,
									<cfif Len(attributes.finish_date)>#attributes.finish_date#<cfelse>NULL</cfif>,
									<cfif len(attributes.form_extra_product_1)>#attributes.form_extra_product_1#<cfelse>NULL</cfif>,
									<cfif len(attributes.form_extra_product_2)>#attributes.form_extra_product_2#<cfelse>NULL</cfif>,
									<cfif len(attributes.form_rebate_cash_1)>#attributes.form_rebate_cash_1#<cfelse>NULL</cfif>,
									<cfif len(attributes.form_rebate_cash_1)>'#attributes.price_money#'<cfelse>NULL</cfif>,
									<cfif len(attributes.form_return_day)>#attributes.form_return_day#<cfelse>NULL</cfif>,
									<cfif len(attributes.form_return_rate)>#attributes.form_return_rate#<cfelse>NULL</cfif>,
									<cfif len(attributes.form_price_protection_day)>#attributes.form_price_protection_day#<cfelse>NULL</cfif>,
									<cfif len(attributes.form_discount_cash)>#attributes.form_discount_cash#<cfelse>NULL</cfif>,
									<cfif len(attributes.form_discount_cash)>'#attributes.price_money#'<cfelse>NULL</cfif>,
									<cfif len(attributes.form_rebate_rate)>#attributes.form_rebate_rate#<cfelse>NULL</cfif>,
									<cfif len(attributes.process_stage)>#attributes.process_stage#<cfelse>NULL</cfif>,
									<cfif len(attributes.contract_id)>#attributes.contract_id#<cfelse>NULL</cfif>
								)
						</cfquery>
						<cfif isDefined("form.price_cats_lists")>
							<cfloop list="#form.price_cats_lists#" index="i">
								<cfquery name="ADD_CONTRACT_SALES_PROD_PRICE_LIST" datasource="#dsn#_#dsn3_compid#">
									INSERT INTO 
									CONTRACT_SALES_PROD_PRICE_LIST
									(
										C_S_PROD_DISCOUNT_ID,
										PRICE_CAT_ID
									)
									VALUES
									(
										#MAX_ID.IDENTITYCOL#,
										#i#
									)
								</cfquery>
							</cfloop>
						</cfif>
					</cfif>
				</cftransaction>
			</cflock>
		</cfloop>
	</cfloop>
</cfif>
<script type="text/javascript">
	window.location.href="<cfoutput>#request.self#?fuseaction=product.conditions</cfoutput>";
</script>

