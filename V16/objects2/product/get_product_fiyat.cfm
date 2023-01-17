<cfparam name="attributes.price_catid" default="-2">
<cfparam name="attributes.price_catid_2" default="-2">
<cfparam name="attributes.employee" default="">
<cfparam name="attributes.pos_code" default="">
<cfparam name="attributes.get_company_id" default="">
<cfparam name="attributes.get_company" default="">
<cfparam name="attributes.product_cat" default="">
<cfparam name="attributes.product_catid" default="0">
<cfparam name="attributes.brand_id" default="">
<cfparam name="attributes.brand_name" default="">
<cfparam name="attributes.is_promotion" default="0">

<cfif isdefined("session.pp")>
	<cfset session_base = evaluate('session.pp')>
	<cfset session_base.period_is_integrated = 0>
<cfelseif isdefined("session.ep")>
	<cfset session_base = evaluate('session.ep')>
<cfelseif isdefined("session.ww")>
	<cfset session_base = evaluate('session.ww')>
<cfelse>
	<cfset session_base = evaluate('session.qq')>
</cfif> 
<cfset dsn = application.systemParam.systemParam().dsn>
<cfset dsn1 = '#dsn#_product'>
<cfset dsn2 = '#dsn#_#session_base.period_year#_#session_base.our_company_id#'>
<cfset dsn3 = '#dsn#_#session_base.our_company_id#'>
<cfset int_comp_id = session_base.our_company_id>
<cfset int_period_id = session_base.period_id>

<cfinclude template="../query/get_price_cats_moneys.cfm">

<cfquery name="GET_ACTIVE_PRODUCT" datasource="#DSN3#" maxrows="1">
 WITH CT1 AS(
	SELECT 
		PRODUCT.PRODUCT_NAME,
		PRODUCT.IS_KARMA,        
		PRODUCT.PRODUCT_ID,        
		PRODUCT.TAX,
		PRODUCT.IS_ZERO_STOCK,
		PRODUCT.BRAND_ID,
		PRODUCT.PRODUCT_CODE,
		PRODUCT.PRODUCT_CODE_2,
		PRODUCT.USER_FRIENDLY_URL,
		PRODUCT.PRODUCT_DETAIL,
		PRODUCT.PRODUCT_DETAIL2,
		PRODUCT.PRODUCT_DETAIL_WATALOGY,
		PRODUCT.PRODUCT_CATID,
        PRODUCT.SHORT_CODE,
        PRODUCT.SEGMENT_ID,
        PRODUCT.IS_PROTOTYPE,
		PRODUCT.RECORD_DATE,
		PRODUCT.IS_PRODUCTION,
		PRODUCT_CAT.HIERARCHY,
		PRODUCT_CAT.PRODUCT_CAT,
		PRODUCT_UNIT.ADD_UNIT,
		STOCKS.STOCK_ID,
		STOCKS.STOCK_CODE,
		STOCKS.PROPERTY,
		STOCKS.BARCOD,        
		STOCKS.PRODUCT_UNIT_ID,
		PRICE_STANDART.PRICE PRICE,
		PRICE_STANDART.MONEY MONEY,
		PRICE_STANDART.IS_KDV IS_KDV,
		PRICE_STANDART.PRICE_KDV PRICE_KDV
	FROM 
		PRODUCT,
		PRODUCT_CAT,
		#dsn1_alias#.PRODUCT_CAT_OUR_COMPANY AS PRODUCT_CAT_OUR_COMPANY,
		STOCKS,
		<cfif isdefined("attributes.last_user_price_list") and isnumeric(attributes.last_user_price_list)>
			PRICE AS PRICE_STANDART,
		<cfelse>
			PRICE_STANDART,
		</cfif>
		PRODUCT_UNIT
	WHERE
		STOCKS.STOCK_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#fiyat_stock_id#"> AND
		STOCKS.PRODUCT_ID =<cfqueryparam cfsqltype="cf_sql_integer" value="#fiyat_product_id#"> AND
		PRODUCT_CAT.PRODUCT_CATID = PRODUCT_CAT_OUR_COMPANY.PRODUCT_CATID AND
		<cfif isdefined("session.ep")>
            PRODUCT_CAT_OUR_COMPANY.OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#"> AND
        <cfelse>
            PRODUCT_CAT_OUR_COMPANY.OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session_base.our_company_id#"> AND
        </cfif>
            PRODUCT.PRODUCT_ID = STOCKS.PRODUCT_ID AND
            PRODUCT_CAT.PRODUCT_CATID = PRODUCT.PRODUCT_CATID AND
            PRODUCT_UNIT.PRODUCT_ID = STOCKS.PRODUCT_ID AND
            STOCKS.PRODUCT_UNIT_ID = PRODUCT_UNIT.PRODUCT_UNIT_ID AND
            PRODUCT_UNIT.IS_MAIN = 1 AND			
        <cfif isdefined("session.pp")>
            PRODUCT.IS_EXTRANET = 1 AND
        <cfelse>
            PRODUCT.IS_INTERNET = 1 AND
        </cfif>
		<cfif isdefined("attributes.last_user_price_list") and isnumeric(attributes.last_user_price_list)>
			PRICE_STANDART.PRICE_CATID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.last_user_price_list#"> AND
			PRICE_STANDART.PRICE > 0 AND
			PRICE_STANDART.PRODUCT_ID = STOCKS.PRODUCT_ID AND
			(PRICE_STANDART.STOCK_ID IS NULL OR PRICE_STANDART.STOCK_ID = #fiyat_stock_id#) AND
			ISNULL(PRICE_STANDART.SPECT_VAR_ID,0) = 0 AND
			PRODUCT_UNIT.PRODUCT_UNIT_ID = PRICE_STANDART.UNIT AND
			(PRICE_STANDART.FINISHDATE IS NULL OR PRICE_STANDART.FINISHDATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">) AND
			(PRICE_STANDART.STARTDATE IS NULL OR PRICE_STANDART.STARTDATE < <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">) AND
		<cfelse>
			PRICE_STANDART.PRICE > 0 AND
			PRICE_STANDART.PRICESTANDART_STATUS = 1	AND
			PRICE_STANDART.PURCHASESALES = 1 AND
			PRODUCT_UNIT.PRODUCT_UNIT_ID = PRICE_STANDART.UNIT_ID AND
		</cfif>
		PRODUCT.PRODUCT_STATUS = 1 AND
		PRICE_STANDART.PRODUCT_ID = STOCKS.PRODUCT_ID
		 
	)
		SELECT
			COALESCE(SLIPN.ITEM,C.PRODUCT_NAME) PRODUCT_NAME,
			C.IS_KARMA,        
			C.PRODUCT_ID,        
			C.TAX,
			C.IS_ZERO_STOCK,
			C.BRAND_ID,
			C.PRODUCT_CODE,
			C.PRODUCT_CODE_2,
			C.USER_FRIENDLY_URL,
			COALESCE(SLIPD.ITEM,C.PRODUCT_DETAIL) PRODUCT_DETAIL,
			COALESCE(SLIPD2.ITEM,C.PRODUCT_DETAIL2) PRODUCT_DETAIL2,
			C.PRODUCT_DETAIL_WATALOGY,
			C.PRODUCT_CATID,
			C.SHORT_CODE,
			C.SEGMENT_ID,
			C.IS_PROTOTYPE,
			C.RECORD_DATE,
			C.IS_PRODUCTION,
			C.HIERARCHY,
			C.PRODUCT_CAT,
			C.ADD_UNIT,
			C.STOCK_ID,
			C.STOCK_CODE,
			C.PROPERTY,
			C.BARCOD,        
			C.PRODUCT_UNIT_ID,
			C.PRICE PRICE,
			C.MONEY MONEY,
			C.IS_KDV IS_KDV,
			C.PRICE_KDV PRICE_KDV
		FROM
		CT1 AS C
		LEFT JOIN #dsn#.SETUP_LANGUAGE_INFO SLIPN 
                        ON SLIPN.UNIQUE_COLUMN_ID = C.PRODUCT_ID 
                        AND SLIPN.COLUMN_NAME ='PRODUCT_NAME'
                        AND SLIPN.TABLE_NAME = 'PRODUCT'
                        AND SLIPN.LANGUAGE = '#session_base.language#'
		LEFT JOIN #dsn#.SETUP_LANGUAGE_INFO SLIPD
                        ON SLIPD.UNIQUE_COLUMN_ID = C.PRODUCT_ID 
                        AND SLIPD.COLUMN_NAME ='PRODUCT_DETAIL'
                        AND SLIPD.TABLE_NAME = 'PRODUCT'
                        AND SLIPD.LANGUAGE = '#session_base.language#'
		LEFT JOIN #dsn#.SETUP_LANGUAGE_INFO SLIPD2 
                        ON SLIPD2.UNIQUE_COLUMN_ID = C.PRODUCT_ID 
                        AND SLIPD2.COLUMN_NAME ='PRODUCT_DETAIL2'
                        AND SLIPD2.TABLE_NAME = 'PRODUCT'
                        AND SLIPD2.LANGUAGE = '#session_base.language#' 
		<cfif isdefined("attributes.last_user_price_list") and isnumeric(attributes.last_user_price_list)>
            ORDER BY
                ISNULL(C.STOCK_ID,0) DESC
        </cfif>
</cfquery>
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
		PROMOTIONS.AMOUNT_DISCOUNT_MONEY_1,			
		STOCKS.STOCK_ID
	FROM
		STOCKS,
		PROMOTIONS
	WHERE
		PROMOTIONS.PROM_STATUS = 1 AND 	
		PROMOTIONS.PROM_TYPE = 1 AND 	<!--- Satira Uygulanir --->
		PROMOTIONS.LIMIT_TYPE = 1 AND 	<!--- Birim  --->
		STOCKS.STOCK_ID =  <cfqueryparam cfsqltype="cf_sql_integer" value=" #fiyat_stock_id#"> AND
		(
			STOCKS.STOCK_ID = PROMOTIONS.STOCK_ID OR
			STOCKS.BRAND_ID = PROMOTIONS.BRAND_ID OR
			STOCKS.PRODUCT_CATID = PROMOTIONS.PRODUCT_CATID
		)	
		AND
		PROMOTIONS.STARTDATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#"> AND
		PROMOTIONS.FINISHDATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">
</cfquery>
<cfinclude template="../query/get_price_all.cfm">
<cfoutput query="get_active_product">
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
		<cfquery name="GET_P" dbtype="query" maxrows="1">
			SELECT * FROM GET_PRICE_ALL WHERE UNIT = <cfqueryparam cfsqltype="cf_sql_integer" value="#product_unit_id[currentrow]#"> AND PRODUCT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#product_id#"> AND STOCK_ID IN(0,#stock_id#) ORDER BY STOCK_ID DESC
		</cfquery>
	</cfif>
	<cfif attributes.price_catid neq -2 and get_p.recordcount>
		<cfscript>
			attributes.catalog_id = get_p.catalog_id;
			if(len(get_p.PRICE)){musteri_pro_price = get_p.PRICE; musteri_row_money=get_p.MONEY; }else{ musteri_pro_price = 0;musteri_row_money=default_money.money;}
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
			attributes.catalog_id = '';
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
	<cfquery name="GET_PRO" dbtype="query" maxrows="1">
		SELECT * FROM GET_PROM_ALL WHERE STOCK_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#stock_id#"> 				
			<cfif attributes.price_catid neq -2>
				<cfif len(get_p.price_catid)>
					AND PRICE_CATID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_p.price_catid#">
				</cfif>
			<cfelse>
				AND PRICE_CATID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.price_catid#">
			</cfif>
		ORDER BY
			PROM_ID DESC
	</cfquery>
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
	<cfif get_pro.recordcount>
		<cfscript>
			prom_id = get_pro.prom_id;
			prom_discount = get_pro.discount;
			prom_amount_discount = get_pro.amount_discount;
			if(len(get_pro.amount_discount_money_1))
				prom_amount_discount_money = trim(get_pro.amount_discount_money_1);
			else
				prom_amount_discount_money = row_money;
			prom_cost = get_pro.total_promotion_cost;
			prom_free_stock_id =  get_pro.free_stock_id;
			prom_stok_id = get_pro.stock_id; //Promosyonu olan urunun stok_id si
			if(len(get_pro.limit_value)) prom_stock_amount = get_pro.limit_value;
			if(len(get_pro.free_stock_amount)) prom_free_stock_amount = get_pro.free_stock_amount;
			if(len(get_pro.free_stock_price)) prom_free_stock_price = get_pro.free_stock_price;
			if(len(get_pro.amount_1_money)) 
				prom_free_stock_money = get_pro.amount_1_money;
			else
				prom_free_stock_money = row_money;
		</cfscript>
	</cfif>
	<cfif get_pro.recordcount>
		<cfif len(get_pro.discount) and get_pro.discount>
			<cfset musteri_flt_other_money_value_with_prom = musteri_flt_other_money_value * ((100-get_pro.discount)/100)>
		<cfelseif len(get_pro.amount_discount) and get_pro.amount_discount>
			<cfset musteri_flt_other_money_value_with_prom = musteri_flt_other_money_value - get_pro.amount_discount>
		<cfelse>
			<cfset musteri_flt_other_money_value_with_prom = musteri_flt_other_money_value>
		</cfif>
		<cfset price_form = musteri_flt_other_money_value_with_prom>
	<cfelse>
		<cfset price_form = musteri_flt_other_money_value>
	</cfif>
	<cfset attributes.sid = stock_id>
	
	<cfif attributes.price_catid neq -2 and get_p.recordcount>
		<cfset attributes.price_hesap = get_p.price>
		<cfset attributes.price_hesap_kdv = get_p.price_kdv>
	<cfelse>
		<cfset attributes.price_hesap = price>
		<cfset attributes.price_hesap_kdv = price_kdv>
	</cfif>
	<cfset attributes.price = price_form>
	<cfset attributes.price_kdv = price_form + (price_form * tax/ 100)>
	<cfset attributes.price_money = musteri_row_money>
	<cfset attributes.price_standard = get_active_product.price>
	<cfset attributes.price_standard_kdv = get_active_product.price_kdv>
	<cfset attributes.price_standard_money = get_active_product.money>
	<cfset attributes.prom_id = prom_id>
	<cfset attributes.prom_discount = prom_discount>
	<cfset attributes.prom_amount_discount = prom_amount_discount>
	<cfset attributes.prom_cost = prom_cost>
	<cfset attributes.prom_free_stock_id = prom_free_stock_id>
	<cfset attributes.prom_stock_amount = prom_stock_amount>
	<cfset attributes.prom_free_stock_amount = prom_free_stock_amount>
	<cfset attributes.prom_free_stock_price = prom_free_stock_price>
	<cfset attributes.prom_free_stock_money = prom_free_stock_money>
	<cfif get_pro.recordcount>
		<cfset attributes.price_old = musteri_flt_other_money_value>
	<cfelse>
		<cfset attributes.price_old = "">
	</cfif>
</cfoutput>
