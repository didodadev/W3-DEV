<cfsetting showdebugoutput="no">

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
				ISNULL(PRICE.STOCK_ID,0)=0 AND
				ISNULL(PRICE.SPECT_VAR_ID,0)=0 AND
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
</cfif>
