<cfsetting showdebugoutput="no">
<cfif isdefined('attributes.price_list_id') and attributes.price_list_id gt 0>
	<cfset attributes.price_catid = attributes.price_list_id>
</cfif>
<cfif isdefined('attributes.basket_products')>
	<cf_date tarih='attributes.price_date'>
	<cfset attributes.search_process_date = attributes.price_date><!--- indirimler için --->
	
	<cfquery name="GET_BARCODE_INFO" datasource="#DSN3#">
		SELECT STOCK_ID,BARCODE FROM STOCKS_BARCODES WHERE BARCODE IN (#listqualify(attributes.basket_products,"'")#)
	</cfquery>
	<cfset problem_barcodes = ''>
	<cfloop list="#attributes.basket_products#" index="brcd">
		<cfif not listfind(valuelist(get_barcode_info.barcode),brcd)>
			<cfset problem_barcodes = listappend(problem_barcodes,brcd)>
		</cfif>
	</cfloop>
	<cfif len(valuelist(get_barcode_info.stock_id))>
		<cfquery name="GET_PRODUCT_INFO" datasource="#DSN3#">
			SELECT
				DISTINCT
				SB.BARCODE,
				STOCKS.PRODUCT_ID,
				STOCKS.PRODUCT_NAME,
				STOCKS.PRODUCT_CODE,
				STOCKS.BARCOD,
				STOCKS.PROPERTY,		
				STOCKS.STOCK_ID,
				STOCKS.TAX,
				STOCKS.MANUFACT_CODE,
				PU.ADD_UNIT,
				PU.PRODUCT_UNIT_ID,
				PU.MULTIPLIER
				<cfif isdefined('attributes.price_list_id') and attributes.price_list_id gt 0>
					,
					PRICE.PRICE,
					PRICE.MONEY		
				<cfelseif isdefined('attributes.price_list_id') and attributes.price_list_id is 0>
					,
					PRICE_STANDART.PRICE,
					PRICE_STANDART.MONEY
				<cfelse>
					,
					PRICE_STANDART.PRICE,
					PRICE_STANDART.MONEY
				</cfif>		
			FROM
				STOCKS,
				PRODUCT_UNIT AS PU,
				STOCKS_BARCODES SB
				<cfif isdefined('attributes.price_list_id') and attributes.price_list_id gt 0>
					,PRICE
				<cfelseif isdefined('attributes.price_list_id') and attributes.price_list_id is 0>
					,PRICE_STANDART
				<cfelse>
					,PRICE_STANDART
				</cfif>		
			WHERE
				STOCKS.PRODUCT_STATUS = 1 AND
				STOCKS.STOCK_STATUS = 1 AND
				STOCKS.PRODUCT_UNIT_ID = PU.PRODUCT_UNIT_ID AND
				STOCKS.PRODUCT_ID = PU.PRODUCT_ID AND
				PU.MAIN_UNIT = PU.ADD_UNIT AND
				SB.STOCK_ID = STOCKS.STOCK_ID AND		
				<cfif isdefined('attributes.price_list_id') and attributes.price_list_id gt 0>
					STOCKS.PRODUCT_ID = PRICE.PRODUCT_ID AND
					ISNULL(PRICE.STOCK_ID,0)=0 AND
					ISNULL(PRICE.SPECT_VAR_ID,0)=0 AND
					PRICE.PRICE_CATID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.price_list_id#"> AND
					(
						PRICE.STARTDATE <= #attributes.price_date# AND
						(PRICE.FINISHDATE >= #attributes.price_date# OR PRICE.FINISHDATE IS NULL)
					)
				<cfelseif isdefined('attributes.price_list_id') and attributes.price_list_id is 0>
					STOCKS.PRODUCT_ID = PRICE_STANDART.PRODUCT_ID AND
					PRICE_STANDART.PURCHASESALES = 1 AND
					PRICE_STANDART.PRICESTANDART_STATUS = 1 
				<cfelse>
					STOCKS.PRODUCT_ID = PRICE_STANDART.PRODUCT_ID AND
					PRICE_STANDART.PURCHASESALES = 1 AND
					PRICE_STANDART.PRICESTANDART_STATUS = 1 
				</cfif>
				AND SB.STOCK_ID IN (#valuelist(GET_BARCODE_INFO.STOCK_ID)#)
			ORDER BY
				STOCKS.PRODUCT_NAME, STOCKS.PROPERTY
		</cfquery>
        
		<!--- <cfset toplam = 0> --->
		<cfset toplam_ytl = 0>
		<cfscript>
			// indirimler default 0
			d1 = 0;
			d2 = 0;
			d3 = 0;
			d4 = 0;
			d5 = 0;
			d6 = 0;
			d7 = 0;
			d8 = 0;
			d9 = 0;
			d10= 0;
			disc_amount = 0;
			nettotal = 0;
		</cfscript>
		<cfif get_product_info.recordcount>
			<cfoutput query="get_product_info">
				<cfset attributes.product_id = get_product_info.product_id><!--- indirimler için --->
				<cfset attributes.str_money_currency = get_product_info.money><!--- indirimler için --->
				<!--- ANLAŞMA ŞARTLARI --->
				<cfquery name="GET_CONTRACTS" datasource="#DSN3#" maxrows="1">
					SELECT
						DISCOUNT1,
						DISCOUNT2,
						DISCOUNT3,
						DISCOUNT4,
						DISCOUNT5,
						DISCOUNT_CASH,
						DISCOUNT_CASH_MONEY
					FROM
						CONTRACT_SALES_PROD_DISCOUNT
					WHERE
						PRODUCT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.product_id#"> 
						<cfif isdefined("attributes.company_id") and len(attributes.company_id) and isdefined("attributes.price_catid") and len(attributes.price_catid)>
							AND (COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.company_id#">
							OR (COMPANY_ID IS NULL AND C_S_PROD_DISCOUNT_ID IN (SELECT C_S_PROD_DISCOUNT_ID FROM CONTRACT_SALES_PROD_PRICE_LIST CSPPL WHERE CSPPL.C_S_PROD_DISCOUNT_ID = CONTRACT_SALES_PROD_DISCOUNT.C_S_PROD_DISCOUNT_ID AND PRICE_CAT_ID IN (#attributes.price_catid#))) )
						<cfelseif isdefined("attributes.price_catid") and len(attributes.price_catid)>
							AND COMPANY_ID IS NULL AND C_S_PROD_DISCOUNT_ID IN (SELECT C_S_PROD_DISCOUNT_ID FROM CONTRACT_SALES_PROD_PRICE_LIST CSPPL WHERE CSPPL.C_S_PROD_DISCOUNT_ID = CONTRACT_SALES_PROD_DISCOUNT.C_S_PROD_DISCOUNT_ID AND PRICE_CAT_ID IN (#attributes.price_catid#))
						<cfelseif isdefined("attributes.company_id") and len(attributes.company_id)>
							AND COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.company_id#">
						</cfif>
						<cfif isdefined("attributes.search_process_date") and len(attributes.search_process_date)>
							AND (
									START_DATE <= #attributes.search_process_date#
									AND ( FINISH_DATE >= #attributes.search_process_date# OR FINISH_DATE IS NULL )
								)
						<cfelse>
							AND START_DATE <= #now()#
							AND FINISH_DATE >= #now()#
						</cfif>
					ORDER BY
						START_DATE DESC,
						RECORD_DATE DESC
				</cfquery>
				<cfif not get_contracts.recordcount>
					<cfquery name="GET_CONTRACTS" datasource="#DSN3#" maxrows="1">
						SELECT
							DISCOUNT1,
							DISCOUNT2,
							DISCOUNT3,
							DISCOUNT4,
							DISCOUNT5,
							DISCOUNT_CASH,
							DISCOUNT_CASH_MONEY
						FROM
							CONTRACT_SALES_PROD_DISCOUNT
						WHERE
							PRODUCT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.product_id#"> AND
							COMPANY_ID IS NULL AND
							C_S_PROD_DISCOUNT_ID NOT IN (SELECT C_S_PROD_DISCOUNT_ID FROM CONTRACT_SALES_PROD_PRICE_LIST )  AND
							<cfif isdefined("attributes.search_process_date") and len(attributes.search_process_date)>
								(
									START_DATE <= #attributes.search_process_date# AND
									(FINISH_DATE >= #attributes.search_process_date# OR FINISH_DATE IS NULL)			
								)
							<cfelse>
								START_DATE <= #now()# AND
								FINISH_DATE >= #now()#
							</cfif>
						ORDER BY
							START_DATE DESC,
							RECORD_DATE DESC
					</cfquery>
				</cfif>
				<cfscript>// indirimler anlaşma varsa
					if(get_contracts.recordcount)
					{
						if(len(trim(get_contracts.discount1))) d1 = get_contracts.discount1;
						if(len(trim(get_contracts.discount2))) d2 = get_contracts.discount2;
						if(len(trim(get_contracts.discount3))) d3 = get_contracts.discount3;
						if(len(trim(get_contracts.discount4))) d4 = get_contracts.discount4;
						if(len(trim(get_contracts.discount5))) d5 = get_contracts.discount5;
						if(len(get_contracts.discount_cash))
						{
							if( attributes.str_money_currency is get_contracts.discount_cash_money) //urunun para birimi ile retabe para birimi aynı ise tutar aynen alınır yoksa urun para birimine cevirilir
								disc_amount = get_contracts.discount_cash;
							else
								disc_amount = wrk_round( ( (get_contracts.discount_cash * evaluate("attributes.#get_contracts.discount_cash_money#"))/evaluate("attributes.#attributes.str_money_currency#") ),4);
						}
					}
				</cfscript>
				<cfif len(trim(listlast(session.pda.user_location,'-')))><!--- indirimler için --->
					<cfset attributes.branch_id = trim(listlast(session.pda.user_location,'-'))>
				</cfif>
				<cfif IsDefined("attributes.branch_id") and isnumeric(attributes.branch_id) and isdefined('attributes.company_id') and len(attributes.company_id)><!--- // indirimler anlaşmada genel indirimler tanımlı ise --->
					<cfquery name="GET_SALES_GENERAL_DISCOUNTS" datasource="#DSN3#" maxrows="5">
						SELECT
							DISCOUNT
						FROM
							CONTRACT_SALES_GENERAL_DISCOUNT AS CS_GD,
							CONTRACT_SALES_GENERAL_DISCOUNT_BRANCHES CS_GDB
						WHERE
							CS_GD.GENERAL_DISCOUNT_ID = CS_GDB.GENERAL_DISCOUNT_ID
							AND CS_GDB.BRANCH_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.branch_id#">
							AND CS_GD.COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.company_id#">
							<cfif isdefined("attributes.search_process_date") and len(attributes.search_process_date)>
								AND CS_GD.START_DATE <= #attributes.search_process_date#
								AND CS_GD.FINISH_DATE >= #attributes.search_process_date#
							<cfelse>
								AND CS_GD.START_DATE <= #now()#
								AND CS_GD.FINISH_DATE >= #now()#
							</cfif>
						ORDER BY
							CS_GD.GENERAL_DISCOUNT_ID
					</cfquery>
					<cfif get_sales_general_discounts.recordcount>
						<cfloop query="get_sales_general_discounts">
							<cfset 'd#currentrow+5#' = get_sales_general_discounts.discount>
						</cfloop>
					</cfif>
				</cfif>
				<!--- ANLAŞMA ŞARTLARI --->
				<cfset price_ytl = price * evaluate('attributes.txt_rate2_#money#') / evaluate('attributes.txt_rate2_#money#')>	
				<!--- ANLAŞMA ŞARTLARI --->
				<cfset indirim_carpan = (100-d1) * (100-d2) * (100-d3) * (100-d4) * (100-d5) * (100-d6) * (100-d7) * (100-d8) * (100-d9) * (100-d10)>
				<cfset price_ytl = wrk_round(price_ytl*indirim_carpan/100000000000000000000,2)>
				<!--- ANLAŞMA ŞARTLARI --->
				<cfset sira = listfind(attributes.basket_products,barcode)>
				<cfif sira>
					<!--- <cfset toplam = toplam + (evaluate('price_#attributes.basket_money#') * (1+(TAX/100)) * listgetat(attributes.basket_products_amount,sira))> --->
					<cfif not isDefined('attributes.basket_free_products') or (isDefined('attributes.basket_free_products') and listgetat(attributes.basket_free_products,sira) eq 0)>
						<cfset toplam_ytl = toplam_ytl + (price_ytl * (1+(tax/100)) * listgetat(attributes.basket_products_amount,sira))>
					<cfelseif isDefined('attributes.basket_free_products') and listgetat(attributes.basket_free_products,sira) eq 1>
						<cfset toplam_ytl = toplam_ytl + (0 * (1+(tax/100)) * listgetat(attributes.basket_free_products,sira))>					
					</cfif>
				</cfif>
			</cfoutput>
			<!--- <cfset nettotal_usd = tlformat(toplam,2)> --->
			<cfset nettotal = tlformat(toplam_ytl,2)>
		</cfif>
		<script type="text/javascript">
			<!--- //document.add_order.nettotal_usd.value = '<cfoutput>#nettotal_usd#</cfoutput> ';--->
			document.getElementById('nettotal').value = '<cfoutput>#nettotal#</cfoutput>';
			document.getElementById('net_adet').value = '<cfoutput>#ArraySum(ListToArray(attributes.basket_products_amount))#</cfoutput>';
			document.getElementById('net_cesit').value = '<cfoutput>#listlen(attributes.basket_products)#</cfoutput>';
			//fill_basket_fields();
		</script>
	<cfelse>
		<script type="text/javascript">
			alert('Gönderdiğiniz değerlere ait hiçbir kayıt bulunamadı.');
		</script>
	</cfif>
</cfif>
