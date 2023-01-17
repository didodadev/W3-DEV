<cfquery name="GET_ALTERNATE_PRODUCT" datasource="#dsn3#">
	SELECT
		AP.ALTERNATIVE_ID, 
		P.PRODUCT_NAME, 
		P.PRODUCT_ID
	FROM
		PRODUCT AS P,
		ALTERNATIVE_PRODUCTS AS AP
	WHERE
		(
			P.PRODUCT_ID=AP.PRODUCT_ID AND
			AP.ALTERNATIVE_PRODUCT_ID = #attributes.pid#
		)
		OR
		(
			P.PRODUCT_ID=AP.ALTERNATIVE_PRODUCT_ID AND
			AP.PRODUCT_ID = #attributes.pid#
		)
</cfquery>

<cfset prod_list=ValueList(GET_ALTERNATE_PRODUCT.PRODUCT_ID,',')>

<cfif isdefined("attributes.comp_id") and len(attributes.comp_id)>
	<cfquery name="GET_PRICE_CAT_CREDIT" datasource="#dsn#">
		SELECT 
			PRICE_CAT
		FROM 
			COMPANY_CREDIT 
		WHERE 
			COMPANY_ID = #attributes.comp_id#  AND 
			OUR_COMPANY_ID = #session.ep.company_id#
	</cfquery>
	<cfset price_cat=GET_PRICE_CAT_CREDIT.PRICE_CAT>
	
	<cfif not len(price_cat)>
		<cfquery name="GET_COMP_CAT" datasource="#dsn#">
			SELECT COMPANYCAT_ID FROM COMPANY WHERE COMPANY_ID = #attributes.comp_id#
		</cfquery>
		<cfquery name="GET_PRICE_CAT_COMP" datasource="#dsn3#">
			SELECT 
				PRICE_CATID
			FROM
				PRICE_CAT
			WHERE
				COMPANY_CAT LIKE '%,#GET_COMP_CAT.COMPANYCAT_ID#,%'
		</cfquery>
		<cfset price_cat=GET_PRICE_CAT_COMP.PRICE_CATID>
	</cfif>
</cfif>

<cfif listlen(prod_list)>
	<cfquery name="GET_PRODUCT" datasource="#DSN3#">
	SELECT
			STOCKS.STOCK_ID,
			STOCKS.STOCK_CODE,
			STOCKS.PRODUCT_STOCK,
			PRODUCT.PRODUCT_ID,
			PRODUCT.PRODUCT_NAME,
			PRODUCT_UNIT.ADD_UNIT,
			PRODUCT_UNIT.UNIT_ID,
			PRODUCT_UNIT.PRODUCT_UNIT_ID,
			PRODUCT_UNIT.MAIN_UNIT,
			PRODUCT_UNIT.MULTIPLIER
		FROM
			#dsn2_alias#.GET_STOCK STOCKS,
			PRODUCT,
			PRODUCT_UNIT
		WHERE
			PRODUCT.PRODUCT_ID = STOCKS.PRODUCT_ID AND 
			PRODUCT_UNIT.PRODUCT_ID=PRODUCT.PRODUCT_ID AND
			PRODUCT.PRODUCT_ID IN(#prod_list#)
	</cfquery>
</cfif>


<table width="98%" align="center">
	<tr>
		<td class="headbold" height="35"><cf_get_lang dictionary_id='45311.Alternatif Ürünler'></td>
	</tr>
</table>
<table width="98%" border="0" align="center" cellpadding="0" cellspacing="0">
  <tr class="color-border">
    <td>
      <table width="100%" border="0" cellspacing="1" cellpadding="2">
        <tr class="color-header">
          <td height="22" class="form-title" width="75"><cf_get_lang dictionary_id='57518.Stok Kodu'></td>
          <td class="form-title"><cf_get_lang dictionary_id='57657.Ürün'></td>
		  <td class="form-title" width="60"><cf_get_lang dictionary_id='57452.Stok'></td>
		  <td class="form-title" width="60"><cf_get_lang dictionary_id='57636.Birim'></td>
		  <td width="90"  class="form-title" style="text-align:right;"><cf_get_lang dictionary_id='58084.Fiyat'></td>
        </tr>
        <cfif isdefined("GET_PRODUCT") and GET_PRODUCT.recordcount>
          <cfoutput query="GET_PRODUCT">
		  <cfif isdefined("attributes.comp_id") and len(attributes.comp_id) and isdefined("price_cat") and len(price_cat)>
			<cfif isdefined("price_cat") and len(price_cat)>
				<cfquery name="get_price" datasource="#dsn3#">
					SELECT 
						PRICE_STANDART.MONEY,
						PRICE_STANDART.PRICE,
						PRICE_STANDART.PRICE_KDV
					FROM
						PRICE PRICE_STANDART,	
						PRODUCT_UNIT
					WHERE
						PRICE_STANDART.PRICE_CATID=#price_cat# AND
						PRICE_STANDART.STARTDATE< #now()# AND 
						(PRICE_STANDART.FINISHDATE >= #now()# OR PRICE_STANDART.FINISHDATE IS NULL) AND
						PRODUCT_UNIT.PRODUCT_ID = PRICE_STANDART.PRODUCT_ID AND 
						PRICE_STANDART.PRODUCT_ID = #GET_PRODUCT.PRODUCT_ID# AND 
						ISNULL(PRICE_STANDART.STOCK_ID,0)= 0 AND
						ISNULL(PRICE_STANDART.SPECT_VAR_ID,0)= 0 AND
						PRODUCT_UNIT.IS_MAIN = 1
				</cfquery>
			</cfif>
		  </cfif>
		  <cfif not isdefined("get_price") or (isQuery(get_price) and get_price.recordcount eq 0)>
				<cfquery name="get_price" datasource="#dsn3#">
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
						PRICE_STANDART.PRODUCT_ID = #GET_PRODUCT.PRODUCT_ID# AND 
						PRODUCT_UNIT.IS_MAIN = 1
				</cfquery>
			</cfif>
			<tr class="color-row" height="20">
				<td><a href="javascript://" onClick="add_row('#PRODUCT_ID#','#STOCK_ID#','#STOCK_CODE#','#PRODUCT_NAME#','#get_price.PRICE#','#get_price.MONEY#')" class="tableyazi">#STOCK_CODE#</a></td>
				<td>#PRODUCT_NAME#</td>
				<td  style="text-align:right;">#PRODUCT_STOCK#</td>
				<td  style="text-align:right;">#MAIN_UNIT#</td>
				<td  style="text-align:right;">#get_price.PRICE# #get_price.money#</td>
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
function add_row(product_id,stock_id,stock_code,product_name,price,money)
{
	<cfif isdefined("attributes.product_id")>
		opener.<cfoutput>#attributes.product_id#</cfoutput>.value =product_id ;
	</cfif>
	<cfif isdefined("attributes.stock_id")>
		opener.<cfoutput>#attributes.stock_id#</cfoutput>.value = stock_id;
	</cfif>
	<cfif isdefined("attributes.stock_code")>
		opener.<cfoutput>#attributes.stock_code#</cfoutput>.value = stock_code;
	</cfif>
	<cfif isdefined("attributes.product_name")>
		opener.<cfoutput>#attributes.product_name#</cfoutput>.value = product_name;
	</cfif>	
	<cfif isdefined("attributes.total_amount")>
		opener.<cfoutput>#attributes.total_amount#</cfoutput>.value = price;
	</cfif>
	<cfif isdefined("attributes.money_type")>
		<cfif isdefined("attributes.money_style")>
			money_box_value=opener.<cfoutput>#attributes.money_type#</cfoutput>;
			for (var r=0;r<=money_box_value.length-1;r++)
			{
				if(list_getat(money_box_value[r].value,3,',') == money)
				money_box_value[r].selected = true;
			}
			opener.hesapla();
		<cfelse>
			opener.<cfoutput>#attributes.money_type#</cfoutput>.value = money;
		</cfif>	
	</cfif>
	window.close();
}
</script>
