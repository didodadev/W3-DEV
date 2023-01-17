<cfparam name="attributes.price_catid" default="-2">
<cfparam name="attributes.price_catid_2" default="-2">
<form action="" method="post" name="vision_satir_gonder">
	<input type="hidden" name="price_catid_2" id="price_catid_2" value="">
	<input type="text" name="istenen_miktar" id="istenen_miktar" value="">
	<input type="hidden" name="pid" id="pid" value="">
	<input type="hidden" name="product_id" id="product_id" value="">
	<input type="hidden" name="sid" id="sid" value="">
	<input type="hidden" name="price" id="price" value="">
	<input type="hidden" name="price_old" id="price_old" value="">
	<input type="hidden" name="price_kdv" id="price_kdv" value="">
	<input type="hidden" name="price_money" id="price_money" value="">
	<input type="hidden" name="prom_id" id="prom_id" value="">
	<input type="hidden" name="prom_discount" id="prom_discount" value="">
	<input type="hidden" name="prom_amount_discount" id="prom_amount_discount" value="">
	<input type="hidden" name="prom_cost" id="prom_cost" value="">
	<input type="hidden" name="prom_free_stock_id" id="prom_free_stock_id" value="">
	<input type="hidden" name="prom_stock_amount" id="prom_stock_amount" value="1">
	<input type="hidden" name="prom_free_stock_amount" id="prom_free_stock_amount" value="1">
	<input type="hidden" name="prom_free_stock_price" id="prom_free_stock_price" value="0">
	<input type="hidden" name="prom_free_stock_money" id="prom_free_stock_money" value="">	
	<!--- son kullanici fiyatlari (=price_standart) AK 20060822--->
	<input type="hidden" name="price_standard" id="price_standard" value="">
	<input type="hidden" name="price_standard_kdv" id="price_standard_kdv" value="">
	<input type="hidden" name="price_standard_money" id="price_standard_money" value="">
</form>

<script type="text/javascript">
function vision_urun_gonder2()
{   
	vision_istenen_miktar = 1;
	vision_satir_gonder.istenen_miktar.value = vision_istenen_miktar;
	vision_satir_gonder.price_catid_2.value = '<cfoutput>#attributes.price_catid_2#</cfoutput>';
	vision_satir_gonder.sid.value = eval("document.getElementById('vision_sid')").value;
	vision_satir_gonder.pid.value = eval("document.getElementById('vision_pid')").value;
	vision_satir_gonder.product_id.value = eval("document.getElementById('vision_pid')").value;
	vision_satir_gonder.price.value = eval("document.getElementById('vision_price')").value;
	vision_satir_gonder.price_standard.value = eval("document.getElementById('vision_price')").value;
	vision_satir_gonder.price_standard_kdv.value = eval("document.getElementById('vision_price_kdv')").value;
	vision_satir_gonder.price_standard_money.value = eval("document.getElementById('vision_price_money')").value;
	vision_satir_gonder.price_kdv.value = eval("document.getElementById('vision_price_kdv')").value;
	vision_satir_gonder.price_money.value = eval("document.getElementById('vision_price_money')").value;
	vision_satir_gonder.prom_id.value = eval("document.getElementByıd('vision_prom_id')").value;
	vision_satir_gonder.prom_discount.value = eval("document.getElementById('vision_prom_discount')").value;
	vision_satir_gonder.prom_amount_discount.value = eval("document.getElementById('vision_prom_amount_discount')").value;
	vision_satir_gonder.prom_cost.value = eval("document.getElementById('vision_prom_cost')").value;
	vision_satir_gonder.prom_free_stock_id.value = eval("document.getElementById('vision_prom_free_stock_id')").value;
	vision_satir_gonder.prom_stock_amount.value = eval("document.getElementById('vision_prom_stock_amount')").value;
	vision_satir_gonder.prom_free_stock_amount.value = eval("document.getElementById('vision_prom_free_stock_amount')").value;
	vision_satir_gonder.prom_free_stock_price.value = eval("document.getElementById('vision_prom_free_stock_price')").value;
	vision_satir_gonder.prom_free_stock_money.value = eval("document.getElementById('vision_prom_free_stock_money')").value;
	if ((vision_satir_gonder.prom_discount.value.length) || (vision_satir_gonder.prom_amount_discount.value.length))
		vision_satir_gonder.price_old.value = eval("document.getElementById('vision_price_old')").value;
	
	vision_satir_gonder.action = '<cfoutput>#request.self#</cfoutput>?fuseaction=objects2.detail_product';
	vision_satir_gonder.submit();
}
</script>

<cfscript>
	if (listfindnocase(employee_url,'#cgi.http_host#',';'))
	{
		int_comp_id = session.ep.company_id;
		int_period_id = session.ep.period_id;
	}
	else if (listfindnocase(partner_url,'#cgi.http_host#',';'))
	{
		int_comp_id = session.pp.our_company_id;
		int_period_id = session.pp.period_id;
		attributes.company_id = session.pp.company_id;
	}
	else if (listfindnocase(server_url,'#cgi.http_host#',';') )
	{	
		int_comp_id = session.ww.our_company_id;
		int_period_id = session.ww.period_id;
		if(isdefined('session.ww.company_id'))
			attributes.company_id = session.ww.company_id;
		else if(isdefined('session.ww.userid'))
			attributes.consumer_id = session.ww.userid;
	}
</cfscript>

<cfquery name="MONEYS" datasource="#dsn#">
	SELECT
		COMPANY_ID,
		PERIOD_ID,
		MONEY,
		RATE1,
	<cfif isDefined("session.pp")>
		RATEPP2 RATE2
	<cfelse>
		RATEWW2 RATE2
	</cfif>
	FROM
		SETUP_MONEY
	WHERE
		COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#int_comp_id#"> AND
		PERIOD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#int_period_id#"> AND
		MONEY_STATUS = 1
</cfquery>

<cfquery name="DEFAULT_MONEY" datasource="#dsn#">
	SELECT
		MONEY,
		RATE1,
		RATE2
	FROM
		SETUP_MONEY
	WHERE
		COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#int_comp_id#"> AND
		RATE1=1 AND RATE2=1 AND
		PERIOD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#int_period_id#">
</cfquery>
<cfquery name="get_homepage_products" datasource="#DSN3#">
	SELECT 
		DISTINCT
			STOCKS.STOCK_ID,
			STOCKS.PRODUCT_ID,
			STOCKS.STOCK_CODE,
			GS.PRODUCT_STOCK, 
			PRODUCT.PRODUCT_NAME,
			STOCKS.PROPERTY,
			STOCKS.BARCOD,
			PRODUCT.TAX,
			PRODUCT.BRAND_ID,
			PRODUCT.PRODUCT_CODE,
			PRODUCT.PRODUCT_DETAIL,
			PRODUCT.PRODUCT_CATID,
			PRODUCT.RECORD_DATE,
			PRODUCT.IS_PRODUCTION,
			STOCKS.PRODUCT_UNIT_ID,
			PRICE_STANDART.PRICE PRICE,
			PRICE_STANDART.MONEY MONEY,
			PRICE_STANDART.IS_KDV IS_KDV,
			PRICE_STANDART.PRICE_KDV PRICE_KDV
		FROM
			PRODUCT,
			PRODUCT_CAT,
			STOCKS,
			PRICE_STANDART,
			#dsn2_alias#.GET_STOCK GS,
			PRODUCT_UNIT
		WHERE
			STOCKS.STOCK_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.stock_id#"> AND
			PRICE > 0 AND
			PRODUCT.PRODUCT_ID = STOCKS.PRODUCT_ID AND
			PRODUCT_CAT.PRODUCT_CATID = PRODUCT.PRODUCT_CATID AND
			PRODUCT_UNIT.PRODUCT_ID = STOCKS.PRODUCT_ID AND
			STOCKS.PRODUCT_UNIT_ID = PRODUCT_UNIT.PRODUCT_UNIT_ID AND
			GS.STOCK_ID = STOCKS.STOCK_ID AND
			PRODUCT_UNIT.IS_MAIN = 1 AND			
			PRODUCT.IS_INTERNET = 1 AND
			PRODUCT.PRODUCT_STATUS = 1
				AND PRICE_STANDART.PRICESTANDART_STATUS = 1			
				AND PRICE_STANDART.PURCHASESALES = 1
				AND PRICE_STANDART.PRODUCT_ID = STOCKS.PRODUCT_ID
				AND PRODUCT_UNIT.PRODUCT_UNIT_ID = PRICE_STANDART.UNIT_ID
</cfquery>

<cfset stock_list="">
<cfoutput query="get_homepage_products">
	<cfset stock_list = listappend(stock_list,STOCK_ID)>
</cfoutput> 

<cfif len(stock_list)>
	<cfquery name="GET_PROM_ALL" datasource="#DSN3#">
		SELECT
			PROMOTIONS.DISCOUNT,
			PROMOTIONS.AMOUNT_DISCOUNT,
			PROMOTIONS.TOTAL_PROMOTION_COST,
			PROMOTIONS.PROM_HEAD,
			PROMOTIONS.FREE_STOCK_ID,
			PROMOTIONS.PROM_ID,
			PROMOTIONS.LIMIT_VALUE,
			PROMOTIONS.FREE_STOCK_AMOUNT,
			PROMOTIONS.COMPANY_ID,
			PROMOTIONS.FREE_STOCK_PRICE,
			PROMOTIONS.AMOUNT_1_MONEY,
			PROMOTIONS.PRICE_CATID,
			PROMOTIONS.ICON_ID,			
			STOCKS.STOCK_ID,
			GS.PRODUCT_STOCK
		FROM
			STOCKS,
			PROMOTIONS,
			#dsn2_alias#.GET_STOCK GS
		WHERE
			PROMOTIONS.PROM_STATUS = 1 AND 	
			PROMOTIONS.PROM_TYPE = 1 AND 	<!--- Satira Uygulanir --->
			PROMOTIONS.LIMIT_TYPE = 1 AND 	<!--- Birim  --->
			GS.STOCK_ID = STOCKS.STOCK_ID AND
			STOCKS.STOCK_ID IN (#stock_list#) AND
			(
				STOCKS.STOCK_ID = PROMOTIONS.STOCK_ID OR
				STOCKS.BRAND_ID = PROMOTIONS.BRAND_ID OR
				STOCKS.PRODUCT_CATID = PROMOTIONS.PRODUCT_CATID
			)	
			AND
			PROMOTIONS.STARTDATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#"> AND
			PROMOTIONS.FINISHDATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">
	</cfquery>
</cfif>
<cfinclude template="get_price_all.cfm">
<cfset product_all_list = "">
<cfif get_homepage_products.recordcount>
		  <cfset brand_list = ''>
			<cfset main_brand_list = ''>
			<cfoutput query="get_homepage_products">
				<cfset brand_list = listappend(brand_list,get_homepage_products.brand_id,',')>
			</cfoutput>	
			<cfset brand_list=listsort(brand_list,"numeric","ASC",",")>
			<cfif listlen(brand_list)>
				<cfquery name="get_brands" datasource="#dsn3#">
					SELECT BRAND_NAME,BRAND_ID FROM PRODUCT_BRANDS WHERE BRAND_ID IN (#brand_list#)
				</cfquery>
			</cfif>
			<cfset main_brand_list = listsort(listdeleteduplicates(valuelist(GET_BRANDS.BRAND_ID,',')),'numeric','ASC',',')>
		  
		  <cfoutput query="get_homepage_products">
            <cfif isDefined("money")>
            	<cfset attributes.money = money>
            </cfif>
			<cfloop query="moneys">
				<cfif moneys.money is attributes.money>
					<cfset row_money = money >
					<cfset row_money_rate1 = moneys.rate1 >
					<cfset row_money_rate2 = moneys.rate2 >
				</cfif>
			</cfloop>
		  	<cfset pro_price = price>
		  	<cfset pro_price_kdv = price_kdv>
			<cfif attributes.price_catid neq -2>
				<cfquery name="get_p" dbtype="query">
					SELECT * FROM get_price_all WHERE UNIT = <cfqueryparam cfsqltype="cf_sql_integer" value="#product_unit_id[currentrow]#"> AND PRODUCT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#product_id#">
				</cfquery>
				<cfscript>
					if(len(get_p.PRICE)){ musteri_pro_price = get_p.PRICE; musteri_row_money=get_p.MONEY; }else{ musteri_pro_price = 0;musteri_row_money=	default_money.money;}
				</cfscript>
				<cfloop query="moneys">
					<cfif moneys.money is musteri_row_money>
						<cfset musteri_row_money_rate1 = moneys.rate1>
						<cfset musteri_row_money_rate2 = moneys.rate2>
					</cfif>
				</cfloop>				
				<cfscript>
					if(musteri_row_money is default_money.money)
					{
						musteri_str_other_money = musteri_row_money; 
						musteri_flt_other_money_value = musteri_pro_price;	
						musteri_flag_prc_other = 0;
					}
					else
					{
						musteri_flag_prc_other = 1 ;
						{
							musteri_str_other_money = musteri_row_money; 
							musteri_flt_other_money_value = musteri_pro_price;
						}
						musteri_pro_price = musteri_pro_price*(musteri_row_money_rate2/musteri_row_money_rate1);
					}
				</cfscript>
			<cfelse>
				<cfscript>
					musteri_flt_other_money_value = pro_price;
					musteri_str_other_money = row_money;
					musteri_row_money = row_money;
					{
						musteri_flag_prc_other = 1;
						musteri_pro_price = pro_price*(row_money_rate2/row_money_rate1);
						musteri_str_other_money = default_money.money;
					}
				</cfscript>
			</cfif>
		  <cfif musteri_flt_other_money_value>
			<cfscript>
				prom_id = '';
				prom_discount = '';
				prom_amount_discount = '';
				prom_cost = '';
				prom_free_stock_id = '';
				prom_stock_amount = 1;
				prom_free_stock_amount = 1;
				prom_free_stock_price = 0;
				prom_free_stock_money = '';
			 </cfscript>
				<cfquery name="GET_PRO" dbtype="query"><!--- maxrows="1" --->
					SELECT * FROM GET_PROM_ALL WHERE STOCK_ID = #STOCK_ID# 				
						<cfif attributes.price_catid neq -2>
							<cfif len(get_p.price_catid)>
								AND PRICE_CATID = #get_p.price_catid#
							</cfif>
						<cfelse>
							AND PRICE_CATID = #attributes.price_catid#
						</cfif>
					ORDER BY
						PROM_ID DESC
				</cfquery>
				<cfset bir_2_bir=0><!--- promosyonlardan herhangi biri bir alana bir bedava ise ürün gelmiyor promosyonlu hali geliyor sadece--->
						<cfloop from="1" to="#GET_PRO.RECORDCOUNT#" index="z">
							<cfif GET_PRO.LIMIT_VALUE[z] eq 1>
								<cfset bir_2_bir=1>
							</cfif>
						</cfloop>
						<cfif bir_2_bir neq 1>
							  <cfset product_all_list = listappend(product_all_list,product_id)>
								<input type="hidden" name="vision_pid" id="vision_pid" value="#product_id#">
								<input type="hidden" name="vision_sid" id="vision_sid" value="#stock_id#">
								<input type="hidden" name="vision_prom_id" id="vision_prom_id" value="#prom_id#">
								<input type="hidden" name="vision_prom_discount" id="vision_prom_discount" value="#prom_discount#">
								<input type="hidden" name="vision_prom_amount_discount" id="vision_prom_amount_discount" value="#prom_amount_discount#">
								<input type="hidden" name="vision_prom_cost" id="vision_prom_cost" value="#prom_cost#">
								<input type="hidden" name="vision_prom_free_stock_id" id="vision_prom_free_stock_id" value="#prom_free_stock_id#">				
								<input type="hidden" name="vision_prom_stock_amount" id="vision_prom_stock_amount" value="#prom_stock_amount#">
								<input type="hidden" name="vision_prom_free_stock_amount" id="vision_prom_free_stock_amount" value="#prom_free_stock_amount#">
								<input type="hidden" name="vision_prom_free_stock_price" id="vision_prom_free_stock_price" value="#prom_free_stock_price#">
								<input type="hidden" name="vision_prom_free_stock_money" id="vision_prom_free_stock_money" value="#prom_free_stock_money#">
								<cfset price_form = musteri_flt_other_money_value>
								<input type="hidden" name="vision_price_old" id="vision_price_old" value="">
								<input type="hidden" name="vision_price" id="vision_price" value="#price_form#">
								<input type="hidden" name="vision_price_kdv"id="vision_price_kdv"  value="#price_form*(1+(tax/100))#">
								<input type="hidden" name="vision_price_money" id="vision_price_money" value="#musteri_row_money#">
								<input type="hidden" name="vision_price_standard" id="vision_price_standard" value="#PRICE#">
								<input type="hidden" name="vision_price_standard_kdv" id="vision_price_standard_kdv" value="#PRICE*(1+(tax/100))#">
								<input type="hidden" name="vision_price_standard_money" id="vision_price_standard_money" value="#money#">
							  
						</cfif>
			</cfif><!--- ait oldugu yer: <cfif musteri_flt_other_money_value> --->
          </cfoutput>
		</cfif> 
<script type="text/javascript">
	vision_urun_gonder2();
</script>
