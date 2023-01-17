<cfquery name="GET_STOCK_PROPERTY" datasource="#DSN3#">
	SELECT
		STOCKS.STOCK_ID,
		STOCKS.STOCK_CODE,
		STOCKS.PRODUCT_STOCK,
		PRODUCT.PRODUCT_ID,
		PRODUCT.PRODUCT_NAME,
		STOCKS_PROPERTY.TOTAL_MAX,
		STOCKS_PROPERTY.TOTAL_MIN,
		PRODUCT_UNIT.ADD_UNIT,
		PRODUCT_UNIT.UNIT_ID,
		PRODUCT_UNIT.PRODUCT_UNIT_ID,
		PRODUCT_UNIT.MAIN_UNIT,
		PRODUCT_UNIT.MULTIPLIER
	FROM
		#dsn2_alias#.GET_STOCK STOCKS,
		PRODUCT,
		PRODUCT_UNIT,
		STOCKS_PROPERTY,
		#dsn1_alias#.PRODUCT_DT_PROPERTIES PRODUCT_DT_PROPERTIES
	WHERE
		PRODUCT.PRODUCT_ID = STOCKS.PRODUCT_ID AND 
		STOCKS_PROPERTY.STOCK_ID = STOCKS.STOCK_ID AND
		PRODUCT_UNIT.PRODUCT_ID=PRODUCT.PRODUCT_ID AND
		STOCKS_PROPERTY.PROPERTY_ID = #attributes.property_id# AND
		STOCKS_PROPERTY.PROPERTY_DETAIL_ID = #attributes.property_detail_id# AND
		PRODUCT_DT_PROPERTIES.PROPERTY_ID =STOCKS_PROPERTY.PROPERTY_ID AND
		PRODUCT_DT_PROPERTIES.VARIATION_ID = STOCKS_PROPERTY.PROPERTY_DETAIL_ID AND
		PRODUCT.PRODUCT_ID <> #attributes.product_id# AND
		<cfif isdefined("attributes.total_max") and len(attributes.total_max)>STOCKS_PROPERTY.TOTAL_MAX<=#attributes.total_max# AND</cfif> 
		<cfif isdefined("attributes.total_min") and len(attributes.total_min)>STOCKS_PROPERTY.TOTAL_MIN>=#attributes.total_min# AND</cfif>
		PRODUCT_DT_PROPERTIES.PRODUCT_ID=PRODUCT.PRODUCT_ID AND
		PRODUCT_DT_PROPERTIES.IS_EXIT=1
</cfquery>

<!--- üyenin fiyat listesini bulmak için--->
<cfif isdefined("attributes.company_id") and len(attributes.company_id)>
	<cfquery name="GET_PRICE_CAT_CREDIT" datasource="#dsn#">
		SELECT 
			PRICE_CAT 
		FROM 
			COMPANY_CREDIT 
		WHERE 
			COMPANY_ID = #attributes.company_id#  AND 
			OUR_COMPANY_ID = #session.ep.company_id#
	</cfquery>
	<cfif GET_PRICE_CAT_CREDIT.RECORDCOUNT and len(GET_PRICE_CAT_CREDIT.PRICE_CAT)>
		<cfset attributes.price_catid=GET_PRICE_CAT_CREDIT.PRICE_CAT>
	<cfelse>
		<cfquery name="GET_COMP_CAT" datasource="#dsn#">
			SELECT COMPANYCAT_ID FROM COMPANY WHERE COMPANY_ID = #attributes.company_id#
		</cfquery>
		<cfquery name="GET_PRICE_CAT_COMP" datasource="#dsn3#">
			SELECT 
				PRICE_CATID
			FROM
				PRICE_CAT
			WHERE
				COMPANY_CAT LIKE '%,#GET_COMP_CAT.COMPANYCAT_ID#,%'
		</cfquery>
		<cfset attributes.price_catid=GET_PRICE_CAT_COMP.PRICE_CATID>
	</cfif>
</cfif>
<cfif isdefined("attributes.consumer_id") and len(attributes.consumer_id)>
	<cfquery name="GET_COMP_CAT" datasource="#DSN#">
		SELECT CONSUMER_CAT_ID FROM CONSUMER WHERE CONSUMER_ID = #attributes.consumer_id#
	</cfquery>
	<cfquery name="GET_PRICE_CAT" datasource="#DSN3#">
		SELECT PRICE_CATID FROM PRICE_CAT WHERE CONSUMER_CAT LIKE '%,#get_comp_cat.consumer_cat_id#,%'
	</cfquery>
	<cfset attributes.price_catid=get_price_cat.PRICE_CATID>
</cfif>
<!--- //üyenin fiyat listesini bulmak için--->

<table width="98%" align="center">
	<tr>
		<td class="headbold" height="35"><cf_get_lang dictionary_id="33085.Uyumlu Bileşenler"></td>
	</tr>
</table>
<table width="98%" border="0" align="center" cellpadding="0" cellspacing="0">
  <tr class="color-border">
    <td>
      <table width="100%" border="0" cellspacing="1" cellpadding="2">
        <tr class="color-header">
          <td height="22" class="form-title" width="75"><cf_get_lang dictionary_id="57518.Stok Kodu"></td>
          <td class="form-title"><cf_get_lang dictionary_id="57657.Ürün"></td>
          <td width="60"  class="form-title" style="text-align:right;"><cf_get_lang dictionary_id="57452.Stok"></td>
		  <td class="form-title" width="60"><cf_get_lang dictionary_id="57636.Birim"></td>
		  <td width="90"  class="form-title" style="text-align:right;"><cf_get_lang dictionary_id="58084.Fiyat"></td>
        </tr>
        <cfif GET_STOCK_PROPERTY.recordcount>
          <cfoutput query="GET_STOCK_PROPERTY">
			<cfif isdefined("attributes.price_catid") and len(attributes.price_catid)>
				<cfquery name="get_price#currentrow#" datasource="#dsn3#">
					SELECT 
						PRICE_STANDART.MONEY,
						PRICE_STANDART.PRICE,
						PRICE_STANDART.PRICE_KDV
					FROM
						PRICE PRICE_STANDART,	
						PRODUCT_UNIT
					WHERE
						PRICE_STANDART.PRICE_CATID=#attributes.price_catid# AND
						PRICE_STANDART.STARTDATE< #now()# AND 
						(PRICE_STANDART.FINISHDATE >= #now()# OR PRICE_STANDART.FINISHDATE IS NULL) AND
						PRODUCT_UNIT.PRODUCT_ID = PRICE_STANDART.PRODUCT_ID AND 
						PRICE_STANDART.PRODUCT_ID = #GET_STOCK_PROPERTY.PRODUCT_ID# AND 
						ISNULL(PRICE_STANDART.STOCK_ID,0)=0 AND
						ISNULL(PRICE_STANDART.SPECT_VAR_ID,0)=0 AND
						PRODUCT_UNIT.IS_MAIN = 1
				</cfquery>
			</cfif>

			<cfif not isdefined("attributes.price_catid") or evaluate('get_price#currentrow#.recordcount') eq 0>
				<cfquery name="get_price#currentrow#" datasource="#dsn3#">
					SELECT 
						PRICE_STANDART.MONEY,
						PRICE_STANDART.PRICE,
						PRICE_STANDART.PRICE_KDV
					FROM
						PRICE_STANDART,
						PRODUCT_UNIT
					WHERE
						PURCHASESALES = 1 AND
						PRICESTANDART_STATUS = 1 AND
						PRODUCT_UNIT.PRODUCT_ID = PRICE_STANDART.PRODUCT_ID AND 
						PRICE_STANDART.PRODUCT_ID = #GET_STOCK_PROPERTY.PRODUCT_ID# AND 
						PRODUCT_UNIT.IS_MAIN = 1
				</cfquery>
			</cfif>
			<cfset fiyat=evaluate('get_price#currentrow#.PRICE')>
			<cfset fiyat_money=evaluate('get_price#currentrow#.MONEY')>
			<tr class="color-row" height="20">
				<td><a href="javascript://" onClick="add_row('#PRODUCT_ID#','#STOCK_ID#','#STOCK_CODE#','#PRODUCT_NAME#','#TOTAL_MAX#','#TOTAL_MIN#','#fiyat#','#fiyat_money#','#attributes.property_id#','#attributes.property_detail_id#','#attributes.table_id#')" class="tableyazi">#STOCK_CODE#</a></td>
				<td>#PRODUCT_NAME#</td>
				<td  style="text-align:right;">#PRODUCT_STOCK#</td>
				<td>#MAIN_UNIT#</td>
				<td  style="text-align:right;">#fiyat# #fiyat_money#</td>
			</tr>
          </cfoutput>
        <cfelse>
          <tr height="20" class="color-row">
            <td colspan="5"><cf_get_lang dictionary_id='57484.Kayıt Yok'> !</td>
          </tr>
        </cfif>
      </table>
    </td>
  </tr>
</table>
<script type="text/javascript">
	function add_row(product_id,stock_id,stock_code,product_name,total_max,total_min,price,money,property_id,variation_id,table_id)
	{
		opener.<cfoutput>#attributes.add_row_func#</cfoutput>(product_id,stock_id,stock_code,product_name,total_max,total_min,price,money,property_id,variation_id,table_id);
		window.close();
	}
</script>
