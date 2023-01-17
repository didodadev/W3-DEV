<cfloop list="#attributes.product_id#" item="i" index="j">
<cfif isdefined("attributes.compid")>
	<cfset dsn3 = "#dsn#_#attributes.compid#">
</cfif>

<cfif isdefined("attributes.finishdate")>
	<cfset attributes.finishdate2 = attributes.finishdate>
	<cf_date tarih='attributes.finishdate2'>
</cfif>
<cfif isdefined("attributes.kondusyon_date")>
	<cfset attributes.kondusyon_date2 = attributes.kondusyon_date>
	<cf_date tarih='attributes.kondusyon_date2'>
</cfif>
<cfif isdefined("attributes.kondusyon_finish_date")>
	<cfset attributes.kondusyon_finish_date2 = attributes.kondusyon_finish_date>
	<cf_date tarih='attributes.kondusyon_finish_date2'>
</cfif>

<cfquery name="CONTROL_CATALOG" datasource="#DSN3#">
	SELECT
		CP.CATALOG_ID,
		CP.CATALOG_HEAD,
		CP.IS_APPLIED,
		CP.KONDUSYON_DATE,
		CP.KONDUSYON_FINISH_DATE,
		CPP.PRODUCT_ID
	FROM 
		#dsn3_alias#.CATALOG_PROMOTION_PRODUCTS CPP,
		#dsn3_alias#.CATALOG_PROMOTION CP
	WHERE
		CP.CATALOG_ID = CPP.CATALOG_ID AND
	<cfif isdefined("attributes.kondusyon_finish_date")>
		(
			#attributes.kondusyon_date2# BETWEEN CP.KONDUSYON_DATE AND CP.KONDUSYON_FINISH_DATE OR
			#attributes.kondusyon_finish_date2# BETWEEN CP.KONDUSYON_DATE AND CP.KONDUSYON_FINISH_DATE OR
			CP.KONDUSYON_DATE BETWEEN #attributes.kondusyon_date2# AND #attributes.kondusyon_finish_date2# OR
			CP.KONDUSYON_FINISH_DATE BETWEEN #attributes.kondusyon_date2# AND #attributes.kondusyon_finish_date2#
		)
		AND
	</cfif>
	<cfif isdefined("attributes.catalog_id") and len(attributes.catalog_id)>
		CP.CATALOG_ID <> #attributes.catalog_id# AND
	</cfif>
		CPP.PRODUCT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#i#"> AND
        CPP.STOCK_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#ListGetAt(attributes.stock_id,j)#">
</cfquery>

<cfquery name="PRODUCTS" datasource="#DSN3#">
	SELECT
		P.COMPANY_ID,
		P.PRODUCT_ID,
        S.STOCK_ID,
		P.PRODUCT_NAME +' '+ S.PROPERTY PRODUCT_NAME,
		P.MANUFACT_CODE,
		P.PRODUCT_CODE,
		P.PRODUCT_CODE_2,
		P.BARCOD,
		P.TAX,
		P.TAX_PURCHASE,
		P.PRODUCT_CATID,
		PS.PRICE,
		PS.PRICE_KDV PRICE_KDV2,
		PS.MONEY,
		PS2.PRICE_KDV,
		PU.ADD_UNIT,
		PU.PRODUCT_UNIT_ID,
		PU.MAIN_UNIT,
		PU.MULTIPLIER,
		P.MIN_MARGIN,
		P.MAX_MARGIN,
		ISNULL(PC.PROFIT_MARGIN,0) PROFIT_MARGIN
	FROM
		PRODUCT P,
        STOCKS S,
		PRODUCT_CAT PC,
		PRODUCT_UNIT PU,
		PRICE_STANDART PS,
		PRICE_STANDART PS2
	WHERE
	    S.PRODUCT_ID = P.PRODUCT_ID AND
        S.STOCK_ID = #ListGetAt(attributes.stock_id,j)# AND
		P.PRODUCT_ID = #i# AND 
		P.PRODUCT_STATUS = 1 AND 	
		PU.PRODUCT_UNIT_STATUS = 1 AND 
		P.IS_SALES = 1 AND
		PU.IS_MAIN = 1 AND 
		PS.PRICESTANDART_STATUS = 1	AND 
		PS.PURCHASESALES = 0 AND 
		PU.PRODUCT_UNIT_ID = PS.UNIT_ID AND 
		PS2.PRICESTANDART_STATUS = 1 AND 
		PS2.PURCHASESALES = 1 AND 
		PU.PRODUCT_UNIT_ID = PS2.UNIT_ID AND 
		PU.PRODUCT_ID = P.PRODUCT_ID AND 
		PC.PRODUCT_CATID = P.PRODUCT_CATID		
	ORDER BY
		P.PRODUCT_NAME
</cfquery>
			
<cfquery name="GET_DISCOUNT_PUR" datasource="#DSN3#" maxrows="1">
	SELECT
		DISCOUNT1,
		DISCOUNT2,
		DISCOUNT3,
		DISCOUNT4,
		DISCOUNT5,
		REBATE_CASH_1,
		REBATE_CASH_1_MONEY,
		REBATE_RATE,
		RETURN_DAY,
		RETURN_RATE,
		PRICE_PROTECTION_DAY,
		EXTRA_PRODUCT_1,
		EXTRA_PRODUCT_2
	FROM
		CONTRACT_PURCHASE_PROD_DISCOUNT
	WHERE
		PRODUCT_ID = #i# AND
		START_DATE < #CreateODBCDateTime(attributes.finishdate2)# 
	ORDER BY
		START_DATE DESC,
		RECORD_DATE DESC
</cfquery>
<cfquery name="GET_LAST_PRICE" datasource="#DSN3#" maxrows="1">
	SELECT 
		PRICE,
		PRICE_KDV,
		IS_KDV,
		MONEY,
		PRICE_CATID,
		PRICE_DISCOUNT
	FROM 
		PRICE
	WHERE 
		STARTDATE < #CreateODBCDateTime(attributes.finishdate2)# AND
	<cfif isdefined("attributes.price_lists")>
		PRICE_CATID  IN (#attributes.price_lists#) AND
	</cfif>
		ISNULL(STOCK_ID,0)=0 AND
		ISNULL(SPECT_VAR_ID,0)=0 AND
		UNIT = #products.product_unit_id# AND
		PRODUCT_ID = #i#
	ORDER BY
		STARTDATE DESC
</cfquery>
<cfquery name="GET_PRODUCT_COST" datasource="#DSN3#" maxrows="1">
	SELECT  
		ISNULL(PURCHASE_NET_SYSTEM,0) PURCHASE_NET_SYSTEM,
		ISNULL(PURCHASE_EXTRA_COST_SYSTEM,0) PURCHASE_EXTRA_COST_SYSTEM
	FROM
		PRODUCT_COST	
	WHERE
		PRODUCT_ID = #i#	
	ORDER BY 
		START_DATE DESC,
		RECORD_DATE DESC,
		PRODUCT_COST_ID DESC
</cfquery>

<script type="text/javascript">
	<cfif control_catalog.recordcount>
		if (!confirm("<cf_get_lang dictionary_id ='37868.Ürün Daha Önce Bir Aksiyonda Kullanılmış! Devam Etmek İstiyor Musunuz! Aksiyon Adı - Aksiyon ID'>:"<cfoutput query="control_catalog"> + '\n#catalog_head# - #catalog_id#'</cfoutput>))
			history.back();
	</cfif>
</script>

<cfoutput query="products">
	<cfscript>
		d6 = "";
		d7 = "";
		d8 = "";
		d9 = "";
		d10 = "";
	</cfscript>
	<cfif isdefined("attributes.price_lists")>
		<cfquery name="GET_PRICE_LISTS_BRANCHES" datasource="#DSN3#">
			SELECT BRANCH FROM PRICE_CAT WHERE PRICE_CATID IN (#attributes.price_lists#)
		</cfquery>
		<cfset branch_id_list = listsort(valuelist(get_price_lists_branches.branch),'numeric')>
		<cfif len(PRODUCTS.COMPANY_ID)><!--- indirimler anlasmada genel indirimler tanimli ise --->
			<cfquery name="get_c_general_discounts" datasource="#dsn3#" maxrows="5">
				SELECT	DISTINCT 
					CPGD.DISCOUNT,
					CPGD.GENERAL_DISCOUNT_ID
				FROM
					CONTRACT_PURCHASE_GENERAL_DISCOUNT AS CPGD,
					CONTRACT_PURCHASE_GENERAL_DISCOUNT_BRANCHES
				WHERE
					<cfif listlen(branch_id_list)>CONTRACT_PURCHASE_GENERAL_DISCOUNT_BRANCHES.BRANCH_ID IN (#branch_id_list#) AND</cfif>
					<cfif isdefined("attributes.kondusyon_finish_date")>
						CPGD.START_DATE <= #attributes.kondusyon_finish_date2# AND
						CPGD.FINISH_DATE >= #attributes.kondusyon_date2# AND
					</cfif>
					CPGD.COMPANY_ID = #PRODUCTS.COMPANY_ID# AND
					CPGD.GENERAL_DISCOUNT_ID = CONTRACT_PURCHASE_GENERAL_DISCOUNT_BRANCHES.GENERAL_DISCOUNT_ID
				ORDER BY
					CPGD.GENERAL_DISCOUNT_ID
			</cfquery>
			<cfif get_c_general_discounts.recordcount>
				<cfloop query="get_c_general_discounts">
					<cfset 'd#currentrow+5#' = get_c_general_discounts.discount>
				</cfloop>
			</cfif>
		</cfif>	
	</cfif>
	<cfscript>
		indirim1 = iif(len(get_discount_pur.discount1),get_discount_pur.discount1,0);
		indirim2 = iif(len(get_discount_pur.discount2),get_discount_pur.discount2,0);
		indirim3 = iif(len(get_discount_pur.discount3),get_discount_pur.discount3,0);
		indirim4 = iif(len(get_discount_pur.discount4),get_discount_pur.discount4,0);
		indirim5 = iif(len(get_discount_pur.discount5),get_discount_pur.discount5,0);
		indirim6 = iif(len(d6),d6,0);
		indirim7 = iif(len(d7),d7,0);
		indirim8 = iif(len(d8),d8,0);
		indirim9 = iif(len(d9),d9,0);
		indirim10 = iif(len(d10),d10,0);
		
		if(len(get_discount_pur.rebate_cash_1)) back_end_rebate = get_discount_pur.rebate_cash_1; else back_end_rebate = '';
		if(len(get_discount_pur.rebate_rate)) rebate_rate = get_discount_pur.rebate_rate; else rebate_rate = '';
		if(len(get_discount_pur.return_day)) return_day = get_discount_pur.return_day; else return_day = '';
		if(len(get_discount_pur.return_rate)) return_rate = get_discount_pur.return_rate; else return_rate = '';
		if(len(get_discount_pur.price_protection_day)) price_protection_day = get_discount_pur.price_protection_day; else price_protection_day = '';
		if(len(get_discount_pur.extra_product_1)) extra_product_1 = get_discount_pur.extra_product_1; else extra_product_1 = '';
		if(len(get_discount_pur.extra_product_2)) extra_product_2 = get_discount_pur.extra_product_2; else extra_product_2 = '';				
		
		if (get_last_price.is_kdv is 1)
			end_price_2_w_kdv = get_last_price.price_kdv;
		else
			end_price_2_w_kdv = wrk_round(( (iif(len(get_last_price.price),get_last_price.price,0) * (100+iif(len(tax),tax,0))) / 100 ),2);
		if(get_product_cost.recordcount)
			end_cost = get_product_cost.purchase_net_system+get_product_cost.purchase_extra_cost_system;
		else
			end_cost = 0;
	</cfscript>
	<script type="text/javascript">
		opener.add_row('#currentrow#','#product_id#','#stock_id#','#product_name#', '#manufact_code#', '#iif(len(tax),tax,0)#','#iif(len(tax_purchase),tax_purchase,0)#','#products.add_unit#','#products.product_unit_id#','#products.money#','#indirim1#','#indirim2#','#indirim3#','#indirim4#','#indirim5#','#indirim6#','#indirim7#','#indirim8#','#indirim9#','#indirim10#','#iif(IsNumeric(price),price,0)#','#iif(IsNumeric(price_kdv),price_kdv,0)#','#end_price_2_w_kdv#','#get_last_price.price_discount#','#back_end_rebate#','#rebate_rate#','#return_day#','#return_rate#','#price_protection_day#','#extra_product_1#','#extra_product_2#','#product_code#','#barcod#','#product_code_2#','#end_cost#','#profit_margin#','','','','','','','','','','','#iif(IsNumeric(price_kdv2),price_kdv2,0)#',#iif(IsNumeric(min_margin),min_margin,0)#,#iif(IsNumeric(max_margin),max_margin,0)#);
	</script>
</cfoutput>
</cfloop>

<script type="text/javascript">
	window.close();
</script>