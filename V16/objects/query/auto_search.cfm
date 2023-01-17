<cfset displays = "">
<cfif isdefined("attributes.product_name")><cfset displays = "#displays#&product_name=1"></cfif>
<cfif isdefined("attributes.manufact_code")><cfset displays = "#displays#&manufact_code=1"></cfif>
<cfif isdefined("attributes.stock_code")><cfset displays = "#displays#&stock_code=1"></cfif>
<cfif isdefined("attributes.barcod")><cfset displays = "#displays#&barcod=1"></cfif>
<cfif isdefined("attributes.location")><cfset displays = "#displays#&location=1"></cfif>
<cfif isdefined("attributes.spec")><cfset displays = "#displays#&spec=1"></cfif>
<cfif isdefined("attributes.is_promotion")><cfset displays = "#displays#&is_promotion=1"></cfif>
<cfif isdefined("attributes.prom_stock_id")><cfset displays = "#displays#&prom_stock_id=1"></cfif>
<cfif isdefined("attributes.disc_ount")><cfset displays = "#displays#&disc_ount=1"></cfif>
<cfif isdefined("attributes.disc_ount2_")><cfset displays = "#displays#&disc_ount2_=1"></cfif>
<cfif isdefined("attributes.disc_ount3_")><cfset displays = "#displays#&disc_ount3_=1"></cfif>
<cfif isdefined("attributes.amount")><cfset displays = "#displays#&amount=1"></cfif>
<cfif isdefined("attributes.price")><cfset displays = "#displays#&price=1"></cfif>
<cfif isdefined("attributes.unit")><cfset displays = "#displays#&unit=1"></cfif>
<cfif isdefined("attributes.tax")><cfset displays = "#displays#&tax=1"></cfif>
<cfif isdefined("attributes.duedate")><cfset displays = "#displays#&duedate=1"></cfif>
<cfif isdefined("attributes.row_total")><cfset displays = "#displays#&row_total=1"></cfif>
<cfif isdefined("attributes.row_nettotal")><cfset displays = "#displays#&row_nettotal=1"></cfif>
<cfif isdefined("attributes.row_taxtotal")><cfset displays = "#displays#&row_taxtotal=1"></cfif>
<cfif isdefined("attributes.row_lasttotal")><cfset displays = "#displays#&row_lasttotal=1"></cfif>
<cfif isdefined("attributes.deliver_date")><cfset displays = "#displays#&deliver_date=1"></cfif>
<cfif isdefined("attributes.deliver_dept")><cfset displays = "#displays#&deliver_dept=1"></cfif>
<cfif isdefined("attributes.is_serialno_guaranty")><cfset displays = "#displays#&is_serialno_guaranty=1"> </cfif>
<!---<cfif isdefined("attributes.is_serial_no")><cfset displays = "#displays#&is_serial_no=1"></cfif>--->
<cfif isdefined("attributes.keyword")>
	<cfset deg = trim(attributes.keyword)>
</cfif>
<cfif isDefined("attributes.keyword") and len(attributes.keyword) and ISNUMERIC(attributes.keyword)>
<cfquery name="get_product" datasource="#dsn3#">
		SELECT DISTINCT
			STOCKS.STOCK_ID,
			STOCKS.PRODUCT_ID,
			STOCKS.STOCK_CODE,
			GET_STOCK.PRODUCT_STOCK,
			PRODUCT.PRODUCT_NAME,
			STOCKS.PROPERTY,
			STOCKS.BARCOD,
			PRODUCT.TAX,
			STOCKS.MANUFACT_CODE,
			<cfif isDefined("FORM.PRICE_CATID") AND FORM.PRICE_CATID GT 0>
			PRICE.PRICE,
			PRICE.MONEY,
			<cfelse>
			PRICE_STANDART.PRICE,
			PRICE_STANDART.MONEY,
			</cfif>
			PRODUCT_UNIT.ADD_UNIT,
			PRODUCT_UNIT.MAIN_UNIT,
			0 AS CATALOG_ID
		FROM
			PRODUCT,
			PRODUCT_CAT,
				<cfif isDefined("FORM.PRICE_CATID") AND FORM.PRICE_CATID GT 0>
					PRICE, PRICE_CAT,
				<cfelse>
					PRICE_STANDART,
				</cfif>
			PRODUCT_UNIT,				
			STOCKS,
			#dsn2_alias#.GET_STOCK AS GET_STOCK
		WHERE
			PRODUCT.PRODUCT_STATUS = 1 AND
			PRODUCT_UNIT.PRODUCT_ID = PRODUCT.PRODUCT_ID AND
			PRODUCT_UNIT.PRODUCT_UNIT_STATUS = 1 AND	
			PRODUCT.PRODUCT_ID = STOCKS.PRODUCT_ID AND
			GET_STOCK.STOCK_ID = STOCKS.STOCK_ID AND
			PRODUCT_CAT.PRODUCT_CATID = PRODUCT.PRODUCT_CATID
						
			<cfif isDefined("FORM.PRODUCT_CAT_CODE") AND len(FORM.PRODUCT_CAT_CODE)>
				AND PRODUCT.PRODUCT_CODE LIKE '#FORM.PRODUCT_CAT_CODE#%'
			</cfif>
						
			<cfif isDefined("FORM.PRICE_CATID") AND FORM.PRICE_CATID LT 0>
				AND PRICE_STANDART.PRICESTANDART_STATUS = 1			
			</cfif>
			
			<cfif isDefined("FORM.PRICE_CATID") AND FORM.PRICE_CATID GT 0><!--- FIYAT KATEGORI SECILMISSE--->
				AND PRICE_CAT.PRICE_CATID = #PRICE_CATID#			
				AND	PRICE_CAT.PRICE_CAT_STATUS = 1
				AND PRICE.PRODUCT_ID = STOCKS.PRODUCT_ID
				AND ((ISNULL(PRICE.STOCK_ID,0) = STOCKS.STOCK_ID AND PRICE.STOCK_ID IS NOT NULL) OR (ISNULL(PRICE.STOCK_ID,0) = 0 AND PRICE.STOCK_ID IS NULL))
				AND ISNULL(PRICE.SPECT_VAR_ID,0)=0
				AND	PRICE_CAT.PRICE_CATID = PRICE.PRICE_CATID
				AND PRICE.STARTDATE <= #now()#
				AND	(PRICE.FINISHDATE >= #now()# OR PRICE.FINISHDATE IS NULL)
				AND PRICE.UNIT = PRODUCT_UNIT.PRODUCT_UNIT_ID
				AND PRICE.UNIT = STOCKS.PRODUCT_UNIT_ID				
			<cfelseif isDefined("FORM.PRICE_CATID") AND FORM.PRICE_CATID EQ "-1"><!--- ALIS FIYATLARI--->
				AND PRICE_STANDART.PURCHASESALES = 0
				AND PRICE_STANDART.PRODUCT_ID = STOCKS.PRODUCT_ID
				AND PRODUCT_UNIT.PRODUCT_UNIT_ID = STOCKS.PRODUCT_UNIT_ID
				AND PRODUCT_UNIT.PRODUCT_UNIT_ID = PRICE_STANDART.UNIT_ID				
			<cfelseif isDefined("FORM.PRICE_CATID") AND FORM.PRICE_CATID EQ "-2"><!--- SATIS FIYATLARI--->
				AND PRICE_STANDART.PURCHASESALES = 1
				AND PRICE_STANDART.PRODUCT_ID = STOCKS.PRODUCT_ID
				<!--- AND PRODUCT_UNIT.IS_MAIN = 1 ---> 
				AND PRODUCT_UNIT.PRODUCT_UNIT_ID = STOCKS.PRODUCT_UNIT_ID
				AND PRODUCT_UNIT.PRODUCT_UNIT_ID = PRICE_STANDART.UNIT_ID				
			<cfelse>
				AND PRICE_STANDART.PURCHASESALES = 1 <!--- SATIS FIYATLARI DEFAULT GELSIN--->
				AND PRICE_STANDART.PRODUCT_ID = STOCKS.PRODUCT_ID
				AND PRODUCT_UNIT.PRODUCT_UNIT_ID = STOCKS.PRODUCT_UNIT_ID
				AND PRODUCT_UNIT.PRODUCT_UNIT_ID = PRICE_STANDART.UNIT_ID
			</cfif>					
			AND PRODUCT.PRODUCT_ID IN (SELECT PRODUCT_ID FROM GET_STOCK_BARCODES WHERE BARCODE = '#DEG#')
</cfquery><!--- AND STOCKS.BARCOD = '#DEG#' --->
</cfif>

<cfif isdefined("get_product") and get_product.recordcount>
	<!--- sessionlarda kullanılacak product değerleri tanımlama --->
	<cfset attributes.product_id=get_product.product_id>
	<cfset attributes.product_code=get_product.stock_code>
	<cfset attributes.amount="1">
	<cfset attributes.product_name=get_product.product_name>
	<cfset attributes.tax=get_product.tax>
	<cfset attributes.unit=get_product.add_unit>
	<cfset attributes.stock_id=get_product.stock_id>
	<cfset attributes.stock_code=get_product.stock_code>
	<cfset attributes.barcod=get_product.barcod>
	<cfset attributes.MANUFACT_CODE=get_product.MANUFACT_CODE>
	<cfquery name="GET_PRO" datasource="#dsn3#">
		SELECT
			*
		FROM
			STOCKS S, PROMOTIONS P
		WHERE
			S.STOCK_ID = P.STOCK_ID AND
			S.PRODUCT_ID = #attributes.PRODUCT_ID#							
	</cfquery>
	<cfinclude template="get_default_money.cfm">
	<cfset attributes.money = get_product.money>
	<cfinclude template="get_money.cfm">
	<cfif money.money is default_money.money>
		<cfif len(get_pro.DISCOUNT)>
			<cfset attributes.discount=get_pro.DISCOUNT>
		<cfelse>
			<cfset attributes.discount=0>
		</cfif>
		<cfset discount_per = (( (get_product.price) * attributes.discount) / 100)>
		<cfset pro_price = (get_product.price - discount_per)>
		<cfset attributes.price=pro_price> 
	<cfelse>
		<cfset attributes.price = evaluate(get_product.price*(money.rate2/money.rate1))>
	</cfif>
	<cfset attributes.to_day = dateformat(now(),dateformat_style)>
	<cf_date tarih="attributes.to_day">
	<cfquery name="GET_PROMO" datasource="#dsn3#">
		SELECT * FROM PROMOTIONS
		WHERE PROMOTIONS.STOCK_ID =#get_product.STOCK_ID# AND PROMOTIONS.STARTDATE <= #attributes.TO_DAY#
			AND PROMOTIONS.FINISHDATE >= #attributes.TO_DAY#
	</cfquery> 
	<cfif get_promo.recordcount>
		<cfset attributes.prom_id=get_promo.prom_id>
	</cfif>
	
<cfelse>
<!--- Ürünün Olmaması Halinde Kullanıcıyı Uyarma --->
	<script type="text/javascript">
		alert('Ürün Tanimli Degil\r Lütfen Baska Bir Ürün Seçiniz!');			
		history.back();
	</script>
	<cfabort>
</cfif>
