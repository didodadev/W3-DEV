<cfsetting showdebugoutput="no">
<cfparam name="attributes.other_amount" default="1">
<table cellpadding="0" cellspacing="0" width="100%" align="center">
	<tr class="color-list">
		<td>
		<form name="add_product" method="post" action="">
			<input type="hidden" name="date1" id="date1" value="">
			<input type="hidden" name="due_day_value" id="due_day_value" value="">
			<!--- <input type="hidden" name="department_id" value="">
			<input type="hidden" name="location_id" value=""> --->
			<table cellpadding="2" cellspacing="1" width="100%">
				<tr>
					<td nowrap><cf_get_lang_main no='223.Miktar'> <input name="other_amount" id="other_amount" type="text" value="<cfoutput>#attributes.other_amount#</cfoutput>" style="width:50px;">&nbsp;&nbsp;
					<cf_get_lang no ='1281.Barkod veya Stok Kodun dan Ürün Ekle'>&nbsp;<input name="other_barcod" id="other_barcod" type="text" style="width:150px;" value="" onKeyDown="if(event.keyCode == 13) {return add_barkod_serial();}">&nbsp;&nbsp;
				</tr>
			</table>
		</form>
		</td>
	</tr>
</table>
<script type="text/javascript">
function add_barkod_serial()
{
	document.add_product.date1.value=parent.form_basket.invoice_date.value;
	if(parent.form_basket.basket_due_value != undefined)
		document.add_product.due_day_value.value=parent.form_basket.basket_due_value.value
	//document.add_product.department_id.value=parent.form_basket.department_id.value;
	//document.add_product.location_id.value=parent.form_basket.location_id.value;
	add_product.submit();
	return true;
}
	document.add_product.other_barcod.value="";
	document.add_product.other_amount.value= 1 ;
	document.add_product.other_barcod.focus();
</script>

<cfif (isdefined("form.other_barcod") and len(form.other_barcod))><!--- form var mi? --->
	<script src="<cfoutput>#request.self#?fuseaction=home.emptypopup_js_functions</cfoutput>"></script>
	<cfif isdefined("session_base")>
		<cfset money_currency = session_base.money>
	<cfelse>
		<cfset money_currency = "">
	</cfif>
	<cfparam name="flt_price" default="0">
	<cfparam name="flt_price_other_amount" default="0">
	<cfparam name="attributes.str_money_currency" default="#money_currency#">
	<cfif isdefined("attributes.date1") and isdate(attributes.date1)>
		<cf_date tarih='attributes.date1'>
	</cfif>
	<cfif len(attributes.other_barcod)>
		<cfquery name="GET_PRODUCT_DETAIL" datasource="#dsn3#" cachedwithin="#fusebox.general_cached_time#">
			SELECT 
				STOCKS.STOCK_ID,
				STOCKS.PRODUCT_ID,
				STOCKS.STOCK_CODE,
				PRODUCT.PRODUCT_NAME,
				PRODUCT.TAX,
				PRODUCT.IS_INVENTORY,
				PRODUCT.IS_PRODUCTION,
				STOCKS.MANUFACT_CODE,
				PU.MULTIPLIER,
				PU.ADD_UNIT,
				PU.UNIT_ID,
				PS.PRICE,
				PS.MONEY,
				1 PRODUCT_RELATION_TYPE
			FROM
				PRODUCT,
				PRODUCT_CAT,
				#dsn1_alias#.PRODUCT_CAT_OUR_COMPANY AS PRODUCT_CAT_OUR_COMPANY,
				STOCKS,
				PRICE_STANDART PS,
				PRODUCT_UNIT PU
			WHERE	
				PRODUCT.PRODUCT_STATUS = 1 AND
				STOCKS.STOCK_STATUS = 1 AND
				PRODUCT_CAT.PRODUCT_CATID = PRODUCT_CAT_OUR_COMPANY.PRODUCT_CATID AND
				PRODUCT_CAT_OUR_COMPANY.OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session_base.our_company_id#"> AND
				PRODUCT_CAT.PRODUCT_CATID = PRODUCT.PRODUCT_CATID AND
				PRODUCT.IS_SALES = 1 AND
				PRODUCT.PRODUCT_ID = STOCKS.PRODUCT_ID AND
				(
					STOCKS.STOCK_ID IN (SELECT STOCK_ID FROM GET_STOCK_BARCODES GSB WHERE GSB.BARCODE = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.other_barcod#">) OR
					STOCKS.STOCK_CODE = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.other_barcod#">	
				) AND
				PU.PRODUCT_ID = STOCKS.PRODUCT_ID AND
				STOCKS.PRODUCT_UNIT_ID = PU.PRODUCT_UNIT_ID AND
				PU.IS_MAIN = 1 AND
				<cfif isdefined("session.pp")>PRODUCT.IS_EXTRANET = 1 AND <cfelse>PRODUCT.IS_INTERNET = 1 AND</cfif>
				PS.PRICESTANDART_STATUS = 1	AND
			 	PS.PURCHASESALES = 1 AND
				PS.PRODUCT_ID = STOCKS.PRODUCT_ID AND
			 	PU.PRODUCT_UNIT_ID = PS.UNIT_ID AND
				PRODUCT.IS_KARMA = 0
		UNION ALL
			SELECT 
				PRODUCT_ID STOCK_ID,
				PRODUCT_ID,
				PRODUCT_CODE STOCK_CODE,
				PRODUCT_NAME,
				TAX_SALES,
				1 IS_INVENTORY,
				IS_PRODUCTION,
				'' MANUFACT_CODE,
				MULTIPLIER,
				'' ADD_UNIT,
				UNIT_ID1,
				SALES_PRICE,
				SALES_MONEY,
				2 PRODUCT_RELATION_TYPE
			FROM
				#dsn1_alias#.PRODUCT_OF_PARTNER
			WHERE
				BARCOD = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.other_barcod#">
		</cfquery>
		<cfif not GET_PRODUCT_DETAIL.recordcount>
			<script type="text/javascript">
				alert("<cf_get_lang_main no ='1230.Ürün Kaydı Bulunamadı'>!");			
			</script>
			<cfexit method="exittemplate">
		</cfif>
	</cfif>
	<cfset is_multiple_price_flag = 0>
	<!--- <cfquery name="get_product_unit" datasource="#dsn3#">
		SELECT 
			MULTIPLIER,
			ADD_UNIT,
			UNIT_ID
		FROM 
			PRODUCT_UNIT 
		WHERE 
			PRODUCT_ID=#GET_PRODUCT_DETAIL.PRODUCT_ID#
			AND IS_MAIN=1
	</cfquery> --->
	<cfset page_unit = GET_PRODUCT_DETAIL.ADD_UNIT>
	<cfset page_unit_multiplier = GET_PRODUCT_DETAIL.MULTIPLIER>
	<!--- <cfquery name="get_price" datasource="#dsn3#" maxrows="1">
		SELECT
			PRICE,MONEY
		FROM
			PRICE_STANDART
		WHERE
			PRODUCT_ID = #GET_PRODUCT_DETAIL.PRODUCT_ID# AND
			UNIT_ID = #get_product_unit.unit_id#		
			AND PURCHASESALES = 1
		<cfif isdefined("attributes.date1") and len(attributes.date1)>
			AND START_DATE < #DATEADD('d',1,attributes.date1)#
		<cfelse>
			AND PRICESTANDART_STATUS = 1
		</cfif>
		ORDER BY
			START_DATE DESC,
			RECORD_DATE DESC
	</cfquery>
	<cfif not get_price.recordcount>
		<cfquery name="get_price" datasource="#dsn3#" maxrows="1">
			SELECT
				PS.PRICE,
				PS.MONEY
			FROM
				PRICE_STANDART AS PS,
				PRODUCT_UNIT AS PU
			WHERE
				PS.PRODUCT_ID = #GET_PRODUCT_DETAIL.PRODUCT_ID# AND
				PU.PRODUCT_ID = #GET_PRODUCT_DETAIL.PRODUCT_ID# AND
				PU.IS_MAIN = 1
				AND PS.PURCHASESALES = 1
			<cfif isdefined("attributes.date1") and len(attributes.date1)>
				AND PS.START_DATE < #DATEADD('d',1,attributes.date1)#
			<cfelse>
				AND PS.PRICESTANDART_STATUS = 1
			</cfif>
				AND PS.UNIT_ID = PU.PRODUCT_UNIT_ID
			ORDER BY
				PS.START_DATE DESC,
				PS.RECORD_DATE DESC
		</cfquery>
		<cfset is_multiple_price_flag = 1>
	</cfif> --->
	<cfif len(GET_PRODUCT_DETAIL.PRICE) and isnumeric(GET_PRODUCT_DETAIL.PRICE)>
		<cfset attributes.str_money_currency = GET_PRODUCT_DETAIL.MONEY>
		<cfif session_base.period_year eq 2004 and attributes.str_money_currency is 'YTL'>
			<cfset attributes.YTL = 1000000>
		</cfif>
		<cfset flt_price_other_amount = GET_PRODUCT_DETAIL.PRICE>
		<cfif attributes.str_money_currency eq money_currency>
			<cfset flt_price = GET_PRODUCT_DETAIL.PRICE>
		<cfelse>
			<cfset flt_price = GET_PRODUCT_DETAIL.PRICE * evaluate("attributes.#attributes.str_money_currency#")>
		</cfif>
	</cfif>
	<cfif is_multiple_price_flag>
		<cfset flt_price = flt_price * page_unit_multiplier>
		<cfset flt_price_other_amount = flt_price_other_amount * page_unit_multiplier>
	</cfif>
	<cfoutput>
		<script type="text/javascript">
			<cfif isdefined("attributes.other_amount") and len(attributes.other_amount) and isnumeric(replace(attributes.other_amount,",","."))>
				amount_ = #(GET_PRODUCT_DETAIL.MULTIPLIER * replace(attributes.other_amount,",","."))#;
			<cfelse>
				amount_ = #GET_PRODUCT_DETAIL.MULTIPLIER#
			</cfif>
			
			product_account_code = '#get_product_account(prod_id:get_product_detail.product_id).ACCOUNT_CODE#';
			parent.add_basket_row('#get_product_detail.product_id#', '#get_product_detail.stock_id#', '#get_product_detail.stock_code#', '#attributes.other_barcod#',  '#get_product_detail.manufact_code#', '#get_product_detail.product_name#', '#get_product_detail.unit_id#', '#page_unit#', '', '', '#flt_price#', '#flt_price_other_amount#', '#get_product_detail.tax#', '#attributes.due_day_value#', 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '', '', '', '','#attributes.str_money_currency#', 0, amount_,  product_account_code,'#get_product_detail.is_inventory#','#get_product_detail.is_production#','','',0,'','','','','','','0','','','','0','','#get_product_detail.PRODUCT_RELATION_TYPE#',1);
		</script>
	</cfoutput>
</cfif>
