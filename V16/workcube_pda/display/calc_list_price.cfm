<cfsetting showdebugoutput="no">
<cfif isdefined('attributes.basket_products')>
	<cfset attributes.price_date = now()>
	<cfquery name="GET_PRODUCT_INFO" datasource="#DSN3#"> 
		SELECT DISTINCT
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
                PRICE.UNIT = PU.PRODUCT_UNIT_ID AND
                PRICE.PRICE_CATID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.price_list_id#"> AND
                <!--- Urune ait aktif birden fazla fiyat varsa, son olani getirmesi icin eklendi  --->
                PRICE.PRICE_ID IN (SELECT MAX(PRICE_ID) FROM PRICE PRICE2 WHERE PRICE2.PRICE_CATID = PRICE.PRICE_CATID AND PRICE2.PRODUCT_ID = PRICE.PRODUCT_ID AND PRICE2.STARTDATE <= #attributes.price_date# AND (PRICE2.FINISHDATE >= #attributes.price_date# OR PRICE2.FINISHDATE IS NULL)) AND
                (
                    PRICE.STARTDATE <= #attributes.price_date# AND
                    (PRICE.FINISHDATE >= #attributes.price_date# OR PRICE.FINISHDATE IS NULL)
                )
                <cfelseif isdefined('attributes.price_list_id') and attributes.price_list_id is 0>
                    STOCKS.PRODUCT_ID = PRICE_STANDART.PRODUCT_ID AND
                    PRICE_STANDART.UNIT_ID = PU.PRODUCT_UNIT_ID AND
                    PRICE_STANDART.PURCHASESALES = 1 AND
                    PRICE_STANDART.PRICESTANDART_STATUS = 1 
                <cfelse>
                    STOCKS.PRODUCT_ID = PRICE_STANDART.PRODUCT_ID AND
                    PRICE_STANDART.UNIT_ID = PU.PRODUCT_UNIT_ID AND
                    PRICE_STANDART.PURCHASESALES = 1 AND
                    PRICE_STANDART.PRICESTANDART_STATUS = 1 
                </cfif>
				AND SB.BARCODE IN (#listqualify(attributes.basket_products,"'")#)
            ORDER BY
                STOCKS.PRODUCT_NAME, STOCKS.PROPERTY
	</cfquery> 
	<cfset toplam_ytl = 0>
	<cfset nettotal = '??'>

	<cfif get_product_info.recordcount>
		<cfoutput query="get_product_info">
			<cfset price_ytl = price>
            <cfset sira = listfind(attributes.basket_products,barcode)>
            <cfif sira>
            	<cfset toplam_ytl = toplam_ytl + (price_ytl * listgetat(attributes.basket_products_amount,sira))>
            </cfif>
		</cfoutput>
		<cfset nettotal = TLFormat(toplam_ytl,2)>
		   
		<script type="text/javascript">
			document.getElementById('stock_name').innerHTML = ':&nbsp;<cfoutput>#get_product_info.product_name#<cfif len(trim(get_product_info.property)) and trim(get_product_info.property) neq '-'>-#get_product_info.property#</cfif></cfoutput>';
			document.getElementById('nettotal').value = '<cfoutput>#nettotal#</cfoutput>';
			document.getElementById('money_type').value = '<cfoutput>#get_product_info.money#</cfoutput>';
			document.getElementById('search_product').focus();
		</script>
	<cfelse>
		<script type="text/javascript">
			document.getElementById('stock_name').innerHTML = '';
			document.getElementById('nettotal').value = '';
			alert('Gönderdiğiniz barkoda ait bir kayıt bulunamadı.');
			document.getElementById('search_product').focus();
		</script>
	</cfif>
</cfif>
