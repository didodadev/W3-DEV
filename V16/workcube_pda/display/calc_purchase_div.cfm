bbbbbbb
<cfabort>
<cfsetting showdebugoutput="no">

<cfif isdefined('attributes.price_list_id') and attributes.price_list_id gt 0>
	<cfset attributes.price_catid = attributes.price_list_id>
</cfif>
<cfif isdefined('attributes.basket_products')>
	<cf_date tarih='attributes.price_date'>
	<cfset attributes.search_process_date = attributes.price_date><!--- indirimler için --->
	<cfset money_currency = session.pda.money>	
	<cfquery name="GET_BARCODE_INFO" datasource="#dsn3#">
		SELECT STOCK_ID,BARCODE FROM STOCKS_BARCODES WHERE BARCODE IN (#listqualify(attributes.basket_products,"'")#)
	</cfquery>
	<cfset problem_barcodes = ''>
	<cfloop list="#attributes.basket_products#" index="brcd">
		<cfif not listfind(valuelist(GET_BARCODE_INFO.BARCODE),brcd)>
			<cfset problem_barcodes = listappend(problem_barcodes,brcd)>
		</cfif>
	</cfloop>
	<cfif len(valuelist(GET_BARCODE_INFO.STOCK_ID))>
		<cfquery name="GET_PRODUCT_INFO" datasource="#dsn3#">
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
				,PRICE.PRICE
				,PRICE.MONEY		
			<cfelseif isdefined('attributes.price_list_id') and attributes.price_list_id is 0>
				,PRICE_STANDART.PRICE
				,PRICE_STANDART.MONEY
			<cfelse>
				,PRICE_STANDART.PRICE
				,PRICE_STANDART.MONEY
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
				PRICE.PRICE_CATID = #attributes.price_list_id# AND
				(
					PRICE.STARTDATE <= #attributes.price_date# AND
					(PRICE.FINISHDATE >= #attributes.price_date# OR PRICE.FINISHDATE IS NULL)
				)
			<cfelseif isdefined('attributes.price_list_id') and attributes.price_list_id is 0>
				STOCKS.PRODUCT_ID = PRICE_STANDART.PRODUCT_ID AND
				<cfif isdefined("attributes.is_purchase_sale") and is_purchase_sale eq 0>
					PRICE_STANDART.PURCHASESALES = 0 AND
				<cfelse>
					PRICE_STANDART.PURCHASESALES = 1 AND
				</cfif>
				PRICE_STANDART.PRICESTANDART_STATUS = 1 
			<cfelse>
				STOCKS.PRODUCT_ID = PRICE_STANDART.PRODUCT_ID AND
				<cfif isdefined("attributes.is_purchase_sale") and is_purchase_sale eq 0>
					PRICE_STANDART.PURCHASESALES = 0 AND
				<cfelse>
					PRICE_STANDART.PURCHASESALES = 1 AND
				</cfif>
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
		</cfscript>
		<cfif GET_PRODUCT_INFO.recordcount>
			<cfoutput query="GET_PRODUCT_INFO">
				<cfset attributes.product_id = GET_PRODUCT_INFO.PRODUCT_ID><!--- indirimler için --->
				<cfset attributes.str_money_currency = GET_PRODUCT_INFO.MONEY><!--- indirimler için --->
				<cfset attributes.branch_id = trim(listgetat(session.pda.user_location,2,'-'))><!--- indirimler için --->                
                <cfquery name="get_aksiyons" datasource="#dsn3#" maxrows="1">
                    SELECT
                        CPP.DISCOUNT1,
                        CPP.DISCOUNT2,
                        CPP.DISCOUNT3,
                        CPP.DISCOUNT4,
                        CPP.DISCOUNT5,
                        CPP.DISCOUNT6,
                        CPP.DISCOUNT7,
                        CPP.DISCOUNT8,
                        CPP.DISCOUNT9,
                        CPP.DISCOUNT10,
                        CPP.PURCHASE_PRICE,
                        CPP.MONEY
                    FROM
                        CATALOG_PROMOTION AS CP,
                        CATALOG_PROMOTION_PRODUCTS AS CPP
                        <cfif isdefined("attributes.branch_id") and len(attributes.branch_id)>
                        ,CATALOG_PRICE_LISTS CPL
                        ,PRICE_CAT PCAT
                        </cfif>
                    WHERE
                        CPP.PRODUCT_ID = #attributes.product_id# AND
                        (CP.IS_APPLIED = 1) AND
                    <cfif isdefined("attributes.search_process_date") and len(attributes.search_process_date)>
                        CP.KONDUSYON_DATE <= #attributes.search_process_date# AND
                        CP.KONDUSYON_FINISH_DATE > #attributes.search_process_date# AND
                    <cfelse>
                        CP.KONDUSYON_DATE <= #now()# AND
                        CP.KONDUSYON_FINISH_DATE > #now()# AND
                    </cfif>
                    <cfif isdefined("attributes.branch_id") and len(attributes.branch_id)>
                        CPL.CATALOG_PROMOTION_ID = CP.CATALOG_ID AND
                        CPL.PRICE_LIST_ID = PCAT.PRICE_CATID AND
                        PCAT.BRANCH LIKE '%,#attributes.branch_id#,%' AND
                    </cfif>
                        <!--- CP.BRANCH LIKE ',#attributes.branch_id#,' AND --->
                        CPP.CATALOG_ID = CP.CATALOG_ID
                    ORDER BY
                        CP.CATALOG_ID DESC
                </cfquery>
                <cfscript>// indirimler aksiyon varsa 
                    if(get_aksiyons.recordcount)
                    {
                        flt_price = get_aksiyons.PURCHASE_PRICE;
                        flt_price_other_amount = get_aksiyons.PURCHASE_PRICE;
                        d1 = get_aksiyons.discount1;
                        d2 = get_aksiyons.discount2;
                        d3 = get_aksiyons.discount3;
                        d4 = get_aksiyons.discount4;
                        d5 = get_aksiyons.discount5;
                        d6 = get_aksiyons.discount6;
                        d7 = get_aksiyons.discount7;
                        d8 = get_aksiyons.discount8;
                        d9 = get_aksiyons.discount9;
                        d10 = get_aksiyons.discount10;
                        if (get_aksiyons.MONEY neq money_currency)
                            flt_price = flt_price * evaluate("attributes.#attributes.str_money_currency#");
                        flt_price = flt_price * page_unit_multiplier;
                        
                        flt_price_other_amount = flt_price_other_amount * page_unit_multiplier;
                    }
                </cfscript>
                <!--- <cfelse>
                    <cfset get_aksiyons.recordcount =0>
                </cfif> --->

				<!--- ANLAŞMA ŞARTLARI --->
				<cfquery name="get_contracts" datasource="#dsn3#" maxrows="1">
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
						PRODUCT_ID = #attributes.product_id# 
					<cfif isdefined("attributes.company_id") and len(attributes.company_id) and isdefined("attributes.price_catid") and len(attributes.price_catid)>
						AND (COMPANY_ID = #attributes.COMPANY_ID#
						OR (COMPANY_ID IS NULL AND C_S_PROD_DISCOUNT_ID IN (SELECT C_S_PROD_DISCOUNT_ID FROM CONTRACT_SALES_PROD_PRICE_LIST CSPPL WHERE CSPPL.C_S_PROD_DISCOUNT_ID = CONTRACT_SALES_PROD_DISCOUNT.C_S_PROD_DISCOUNT_ID AND PRICE_CAT_ID IN (#attributes.price_catid#))) )
					<cfelseif isdefined("attributes.price_catid") and len(attributes.price_catid)>
						AND COMPANY_ID IS NULL AND C_S_PROD_DISCOUNT_ID IN (SELECT C_S_PROD_DISCOUNT_ID FROM CONTRACT_SALES_PROD_PRICE_LIST CSPPL WHERE CSPPL.C_S_PROD_DISCOUNT_ID = CONTRACT_SALES_PROD_DISCOUNT.C_S_PROD_DISCOUNT_ID AND PRICE_CAT_ID IN (#attributes.price_catid#))
					<cfelseif isdefined("attributes.company_id") and len(attributes.company_id)>
						AND COMPANY_ID = #attributes.COMPANY_ID#
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
					<cfquery name="get_contracts" datasource="#dsn3#" maxrows="1">
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
							PRODUCT_ID = #attributes.product_id# AND
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
					<cfquery name="get_sales_general_discounts" datasource="#dsn3#" maxrows="5">
						SELECT
							DISCOUNT
						FROM
							CONTRACT_SALES_GENERAL_DISCOUNT AS CS_GD,
							CONTRACT_SALES_GENERAL_DISCOUNT_BRANCHES CS_GDB
						WHERE
							CS_GD.GENERAL_DISCOUNT_ID = CS_GDB.GENERAL_DISCOUNT_ID
							AND CS_GDB.BRANCH_ID = #attributes.branch_id#
							AND CS_GD.COMPANY_ID = #attributes.company_id#
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
							<cfset 'd#currentrow+5#' = get_sales_general_discounts.DISCOUNT>
						</cfloop>
					</cfif>
				</cfif>
				<!--- ANLAŞMA ŞARTLARI --->
					<cfset price_ytl = PRICE * evaluate('attributes.txt_rate2_#MONEY#') / evaluate('attributes.txt_rate1_#MONEY#')>
					
					<!--- ANLAŞMA ŞARTLARI --->
					<cfset indirim_carpan = (100-d1) * (100-d2) * (100-d3) * (100-d4) * (100-d5) * (100-d6) * (100-d7) * (100-d8) * (100-d9) * (100-d10)>
					<cfset price_ytl = wrk_round(price_ytl*indirim_carpan/100000000000000000000,2)>
					<!--- ANLAŞMA ŞARTLARI --->
					
					<!--- <cfset 'price_#attributes.basket_money#' = price_ytl / evaluate('attributes.txt_rate2_#attributes.basket_money#') * evaluate('attributes.txt_rate1_#attributes.basket_money#')> --->

					<cfset sira = listfind(attributes.basket_products,BARCODE)>
					<cfif sira>
						<!--- <cfset toplam = toplam + (evaluate('price_#attributes.basket_money#') * (1+(TAX/100)) * listgetat(attributes.basket_products_amount,sira))> --->
						<cfset toplam_ytl = toplam_ytl + (price_ytl * (1+(TAX/100)) * listgetat(attributes.basket_products_amount,sira))>
					</cfif>
			</cfoutput>
			<!--- <cfset nettotal_usd = tlformat(toplam,2)> --->
			<cfset nettotal = tlformat(toplam_ytl,2)>
		<cfelse>
			<!--- <tr class="color-row">
				<td colspan="2" height="20">Kayıt Bulunamadı !</td>
			</tr> --->
		</cfif>
		<script type="text/javascript">
			//document.add_order.nettotal_usd.value = '<!--- <cfoutput>#nettotal_usd#</cfoutput> --->';
			document.add_order.nettotal.value = '<cfoutput>#nettotal#</cfoutput>';
			document.add_order.net_adet.value = '<cfoutput>#ArraySum(ListToArray(attributes.basket_products_amount))#</cfoutput>';
			document.add_order.net_cesit.value = '<cfoutput>#listlen(attributes.basket_products)#</cfoutput>';
			//fill_basket_fields();
		</script>
	<cfelse>
		<script type="text/javascript">
		alert('Gönderdiğiniz değerlere ait hiçbir kayıt bulunamadı.');
		</script>
	</cfif>
</cfif>

<!--- <cfsetting showdebugoutput="no">

<cfif isdefined('attributes.basket_products')>
	
	<cf_date tarih='attributes.price_date'>
	
	<cfquery name="GET_BARCODE_INFO" datasource="#dsn3#">
		SELECT STOCK_ID,BARCODE FROM STOCKS_BARCODES WHERE BARCODE IN (#listqualify(attributes.basket_products,"'")#)
	</cfquery>
	<cfset problem_barcodes = ''>
	<cfloop list="#attributes.basket_products#" index="brcd">
		<cfif not listfind(valuelist(GET_BARCODE_INFO.BARCODE),brcd)>
			<cfset problem_barcodes = listappend(problem_barcodes,brcd)>
		</cfif>
	</cfloop>
	<cfif len(valuelist(GET_BARCODE_INFO.STOCK_ID))>
		<cfquery name="GET_PRODUCT_INFO" datasource="#dsn3#">
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
				PRICE.PRICE_CATID = #attributes.price_list_id# AND
				(
					PRICE.STARTDATE <= #attributes.price_date# AND
					(PRICE.FINISHDATE >= #attributes.price_date# OR PRICE.FINISHDATE IS NULL)
				)
			<cfelseif isdefined('attributes.price_list_id') and attributes.price_list_id is 0>
				STOCKS.PRODUCT_ID = PRICE_STANDART.PRODUCT_ID AND
				PRICE_STANDART.PURCHASESALES = 0 AND
				PRICE_STANDART.PRICESTANDART_STATUS = 1 
			<cfelse>
				STOCKS.PRODUCT_ID = PRICE_STANDART.PRODUCT_ID AND
				PRICE_STANDART.PURCHASESALES = 0 AND
				PRICE_STANDART.PRICESTANDART_STATUS = 1 
			</cfif>
				AND SB.STOCK_ID IN (#valuelist(GET_BARCODE_INFO.STOCK_ID)#)
			ORDER BY
				STOCKS.PRODUCT_NAME, STOCKS.PROPERTY
		</cfquery>
		<!--- <cfset toplam = 0> --->
		<cfset toplam_ytl = 0>
		<cfif GET_PRODUCT_INFO.recordcount>
			<cfoutput query="GET_PRODUCT_INFO">
					<cfset price_ytl = PRICE * evaluate('attributes.txt_rate2_#MONEY#') / evaluate('attributes.txt_rate1_#MONEY#')>
					<!--- <cfset 'price_#attributes.basket_money#' = price_ytl / evaluate('attributes.txt_rate2_#attributes.basket_money#') * evaluate('attributes.txt_rate1_#attributes.basket_money#')> --->

					<cfset sira = listfind(attributes.basket_products,BARCODE)>
					<cfif sira>
						<!--- <cfset toplam = toplam + (evaluate('price_#attributes.basket_money#') * (1+(TAX/100)) * listgetat(attributes.basket_products_amount,sira))> --->
						<cfset toplam_ytl = toplam_ytl + (price_ytl * (1+(TAX/100)) * listgetat(attributes.basket_products_amount,sira))>
					</cfif>
			</cfoutput>
			<!--- <cfset nettotal_usd = tlformat(toplam,2)> --->
			<cfset nettotal = tlformat(toplam_ytl,2)>
		<cfelse>
			<!--- <tr class="color-row">
				<td colspan="2" height="20">Kayıt Bulunamadı !</td>
			</tr> --->
		</cfif>
		<script type="text/javascript">
			//document.add_order.nettotal_usd.value = '<!--- <cfoutput>#nettotal_usd#</cfoutput> --->';
			document.add_order.nettotal.value = '<cfoutput>#nettotal#</cfoutput>';
			document.add_order.net_adet.value = '<cfoutput>#ArraySum(ListToArray(attributes.basket_products_amount))#</cfoutput>';
			document.add_order.net_cesit.value = '<cfoutput>#listlen(attributes.basket_products)#</cfoutput>';
			//fill_basket_fields();
		</script>
	<cfelse>
		<script type="text/javascript">
		alert('Gönderdiğiniz değerlere ait hiçbir kayıt bulunamadı.');
		</script>
	</cfif>
</cfif> --->
