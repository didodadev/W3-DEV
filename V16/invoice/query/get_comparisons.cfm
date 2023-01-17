<cfquery name="get_invoice_info" datasource="#dsn2#">
	SELECT 
		INVOICE.COMPANY_ID, 
		INVOICE.PARTNER_ID, 
		INVOICE.CONSUMER_ID,
		INVOICE.INVOICE_NUMBER,
		INVOICE.INVOICE_DATE, 
		INVOICE.INVOICE_CAT,
		INVOICE.SA_DISCOUNT, 
		INVOICE.DEPARTMENT_ID,
		INVOICE.DEPARTMENT_LOCATION,
		INVOICE_ROW.INVOICE_ROW_ID,
		INVOICE_ROW.PRODUCT_ID,
		INVOICE_ROW.PRICE,
		(INVOICE_ROW.NETTOTAL/INVOICE_ROW.AMOUNT) NET_TOTAL,
		INVOICE_ROW.NETTOTAL NETTOTAL_INVOICE_ROW,
		INVOICE_ROW.PRICE_OTHER,
		INVOICE_ROW.OTHER_MONEY,
		INVOICE_ROW.OTHER_MONEY_VALUE,
		INVOICE_ROW.AMOUNT, 
		INVOICE_ROW.UNIT,
		INVOICE_ROW.STOCK_ID,
		INVOICE_ROW.TAX,
		INVOICE_ROW.GROSSTOTAL, 
		INVOICE_ROW.DISCOUNT1,
		INVOICE_ROW.DISCOUNT2,
		INVOICE_ROW.DISCOUNT3,
		INVOICE_ROW.DISCOUNT4,
		INVOICE_ROW.DISCOUNT5,
		INVOICE_ROW.DISCOUNT6,
		INVOICE_ROW.DISCOUNT7,
		INVOICE_ROW.DISCOUNT8,
		INVOICE_ROW.DISCOUNT9,
		INVOICE_ROW.DISCOUNT10,
		INVOICE_ROW.DISCOUNT_COST,
		INVOICE_ROW.SHIP_ID,
		INVOICE_ROW.PROM_ID,
		INVOICE_ROW.WRK_ROW_ID,
		INVOICE_ROW.WRK_ROW_RELATION_ID,
		PRODUCT.PRODUCT_ID,
		PRODUCT.PRODUCT_NAME,
		PRODUCT.PRODUCT_CATID 
	FROM 
		INVOICE,
		INVOICE_ROW, 
		#dsn1_alias#.PRODUCT PRODUCT 
	WHERE 
		INVOICE.INVOICE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#url.iid#"> AND 
		INVOICE_ROW.INVOICE_ID = INVOICE.INVOICE_ID AND	
		PRODUCT.PRODUCT_ID = INVOICE_ROW.PRODUCT_ID
	ORDER BY 
		INVOICE_ROW.INVOICE_ROW_ID
</cfquery>
<cfset product_liste = ValueList(get_invoice_info.product_id)>
<cfif not listlen(product_liste,',')>
	<script type="text/javascript">
		alert('Faturaya kayıtlı ürün yok!');
		window.close();
	</script>
	<cfabort>
<cfelseif not len(get_invoice_info.company_id) and not len(get_invoice_info.consumer_id)>
	<script type="text/javascript">
		alert('Çalışanlar İçin Uygunluk Kontrolü Yok!');
		window.close();
	</script>
	<cfabort></cfif>
<cfset ship_list = listdeleteduplicates(valuelist(get_invoice_info.ship_id))>
<cfif listfind(ship_list,0)>
	<cfset ship_list = listdeleteat(ship_list,listfind(ship_list,0))>
</cfif>
<cfif listlen(ship_list)>
	<cfquery name="GET_INVOICE_SHIP_DATE_ALL" datasource="#DSN2#">
		SELECT SHIP_ID, SHIP_DATE FROM SHIP WHERE SHIP_ID IN (#ship_list#)
	</cfquery>
	<cfquery name="GET_ORDERS" datasource="#DSN3#">
		SELECT ORDER_ID FROM ORDERS_SHIP WHERE SHIP_ID IN (#ship_list#) AND PERIOD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.period_id#">
	</cfquery>
	<cfif isdefined('get_orders') and get_orders.recordcount>
		<cfset order_list = valuelist(get_orders.order_id,',')>
	</cfif>
</cfif>

<cfif not isdefined("order_list") or not listlen(order_list,',')>
	<cfquery name="GET_ORDERS" datasource="#DSN3#">
		SELECT
			ORDER_ID
		FROM
			ORDERS_INVOICE
		WHERE
			INVOICE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#url.iid#"> AND
			PERIOD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.period_id#">
	</cfquery>
	<cfif isdefined('get_orders') and get_orders.recordcount>
		<cfset order_list = valuelist(get_orders.order_id,',')>
	</cfif>
</cfif>

<cfif workcube_mode eq 0><!--- KULLANILMIYOR.. AK20041127 --->
	<cfquery name="ADD_INVOICE_CONTROL" datasource="#DSN2#">
		SELECT INVOICE_ID FROM INVOICE_CONTROL WHERE INVOICE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#url.iid#">
	</cfquery>
</cfif>
<cfif len(get_invoice_info.company_id)>
	<cfquery name="INVOICE_SHIP_RELATION" datasource="#DSN2#">
		SELECT 
			INVOICE_SHIPS.INVOICE_ID,
			INVOICE_SHIPS.SHIP_ID,
			SHIP.SHIP_ID,			
			SHIP.COMPANY_ID,
			SHIP.SHIP_NUMBER
		FROM
			INVOICE_SHIPS,
			SHIP
		WHERE
			INVOICE_SHIPS.SHIP_ID = SHIP.SHIP_ID AND 
			INVOICE_SHIPS.INVOICE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#url.iid#"> AND
			INVOICE_SHIPS.SHIP_PERIOD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.period_id#"> AND
			SHIP.COMPANY_ID <> <cfqueryparam cfsqltype="cf_sql_integer" value="#get_invoice_info.company_id#">
	</cfquery>
<cfelseif len(get_invoice_info.consumer_id)>
	<cfquery name="INVOICE_SHIP_RELATION" datasource="#DSN2#">
		SELECT 
			INVOICE_SHIPS.INVOICE_ID,
			INVOICE_SHIPS.SHIP_ID,
			SHIP.SHIP_ID,			
			SHIP.COMPANY_ID,
			SHIP.SHIP_NUMBER
		FROM
			INVOICE_SHIPS,
			SHIP
		WHERE
			INVOICE_SHIPS.SHIP_ID = SHIP.SHIP_ID AND 
			INVOICE_SHIPS.INVOICE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#url.iid#"> AND
			INVOICE_SHIPS.SHIP_PERIOD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.period_id#"> AND
			SHIP.CONSUMER_ID <> <cfqueryparam cfsqltype="cf_sql_integer" value="#get_invoice_info.consumer_id#">
	</cfquery>
<cfelse>
	<cfset invoice_ship_relation.recordcount = 0>
</cfif>
<cfif attributes.type eq 0><!--- Alış ise --->
	<cfquery name="GET_CAT_PUR" datasource="#DSN3#"><!--- alis kosulları --->
		SELECT
			*
		FROM
			CONTRACT_PURCHASE_PROD_DISCOUNT
		WHERE
			PRODUCT_ID IN (#product_liste#)
	</cfquery>
	<cfset attributes.company_id = get_invoice_info.company_id>
	<cfset branchid = "">
	<cfif len(get_invoice_info.department_id)>
		<cfquery name="GET_INVOICE_BRANCH" datasource="#DSN#">
			SELECT BRANCH_ID FROM DEPARTMENT WHERE DEPARTMENT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_invoice_info.department_id#">
		</cfquery>
		<cfset branchid = get_invoice_branch.branch_id>
	</cfif>
	<cfquery name="GET_CUSTOMER_VALUE" datasource="#dsn#">
		SELECT SCV.CUSTOMER_VALUE FROM COMPANY C LEFT JOIN SETUP_CUSTOMER_VALUE SCV WITH (NOLOCK) ON C.COMPANY_VALUE_ID = SCV.CUSTOMER_VALUE_ID <cfif len(get_invoice_info.company_id)>WHERE COMPANY_ID = #get_invoice_info.company_id#</cfif>
	</cfquery>
	<cfif len(branchid) and len(attributes.company_id)><!--- // indirimler anlaşmada genel indirimler tanımlı ise --->
		<cfquery name="GET_C_GENERAL_DISCOUNTS_ALL" datasource="#DSN3#">
			SELECT
				DISCOUNT,
				CPGD.START_DATE,
				CPGD.FINISH_DATE,
				CPGD.GENERAL_DISCOUNT_ID
			FROM
				CONTRACT_PURCHASE_GENERAL_DISCOUNT CPGD,
				CONTRACT_PURCHASE_GENERAL_DISCOUNT_BRANCHES
			WHERE
				CONTRACT_PURCHASE_GENERAL_DISCOUNT_BRANCHES.BRANCH_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#branchid#"> AND
				CPGD.COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.company_id#"> AND
				CPGD.GENERAL_DISCOUNT_ID = CONTRACT_PURCHASE_GENERAL_DISCOUNT_BRANCHES.GENERAL_DISCOUNT_ID
			ORDER BY
				CPGD.GENERAL_DISCOUNT_ID
		</cfquery>
	<cfelse>
		<cfset GET_C_GENERAL_DISCOUNTS_ALL.recordcount = 0>
	</cfif>
<cfelse><!--- satış için --->
	<cfquery name="GET_CAT_PUR" datasource="#DSN3#"><!--- alis kosulları --->
		SELECT
			*
		FROM
			CONTRACT_SALES_PROD_DISCOUNT
		WHERE
			PRODUCT_ID IN (#product_liste#)
	</cfquery>
	<cfset attributes.company_id = get_invoice_info.company_id>
	<cfset branchid = "">
	<cfif len(get_invoice_info.department_id)>
		<cfquery name="GET_INVOICE_BRANCH" datasource="#DSN#">
			SELECT BRANCH_ID FROM DEPARTMENT WHERE DEPARTMENT_ID = #get_invoice_info.department_id#
		</cfquery>
		<cfset branchid = get_invoice_branch.branch_id>
	</cfif>
	<cfif len(branchid) and len(attributes.company_id)><!--- // indirimler anlaşmada genel indirimler tanımlı ise --->
		<cfquery name="GET_C_GENERAL_DISCOUNTS_ALL" datasource="#DSN3#">
			SELECT
				DISCOUNT,
				CPGD.START_DATE,
				CPGD.FINISH_DATE,
				CPGD.GENERAL_DISCOUNT_ID
			FROM
				CONTRACT_SALES_GENERAL_DISCOUNT CPGD,
				CONTRACT_SALES_GENERAL_DISCOUNT_BRANCHES
			WHERE
				CONTRACT_SALES_GENERAL_DISCOUNT_BRANCHES.BRANCH_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#branchid#"> AND
				CPGD.COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.company_id#"> AND
				CPGD.GENERAL_DISCOUNT_ID = CONTRACT_SALES_GENERAL_DISCOUNT_BRANCHES.GENERAL_DISCOUNT_ID
			ORDER BY
				CPGD.GENERAL_DISCOUNT_ID
		</cfquery>
	<cfelse>
		<cfset GET_C_GENERAL_DISCOUNTS_ALL.recordcount = 0>
	</cfif>
</cfif>
<!--- aksiyonlar --->
<cfquery name="GET_CAT_PROMS" datasource="#DSN3#">
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
		CPP.MONEY,
		CPP.PRODUCT_ID,
		CP.KONDUSYON_DATE,
		CP.KONDUSYON_FINISH_DATE,
		CP.RECORD_DATE,
		CPP.REBATE_CASH_1,
		CPP.REBATE_RATE,
		CPP.EXTRA_PRODUCT_1,
		CPP.EXTRA_PRODUCT_2,
		CPP.RETURN_DAY,
		CPP.RETURN_RATE,
		CPP.PRICE_PROTECTION_DAY,
		CPP.ACTION_PRICE_DISCOUNT
	FROM
		CATALOG_PROMOTION CP,
		CATALOG_PROMOTION_PRODUCTS CPP
	<cfif len(branchid)>
		,CATALOG_PRICE_LISTS CPL
		,PRICE_CAT PCAT
	</cfif>
	WHERE
	<cfif len(branchid)>
		CPL.CATALOG_PROMOTION_ID = CP.CATALOG_ID AND
		CPL.PRICE_LIST_ID = PCAT.PRICE_CATID AND
		PCAT.BRANCH LIKE '%,#branchid#,%' AND
	</cfif>
		CP.IS_APPLIED = 1 AND
		CPP.PRODUCT_ID IN (#product_liste#) AND
		CP.CATALOG_ID = CPP.CATALOG_ID
</cfquery>

<!--- Kurlar --->
<cfquery name="GET_MONEY_INV" datasource="#DSN2#">
	SELECT MONEY_TYPE, (RATE2/RATE1) RATE FROM INVOICE_MONEY WHERE ACTION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#url.iid#">
</cfquery>
<cfoutput query="get_money_inv">
	<cfset 'attributes.#money_type#'=rate>
</cfoutput>
<!--- BK 20090106 aksiyonlar icin YTL - TL gecisi icin set edildi. --->
<cfif session.ep.period_year eq 2008>
	<cfset attributes.TL=1>
<cfelseif session.ep.period_year gte 2009>
	<cfset attributes.YTL=1>
</cfif>
