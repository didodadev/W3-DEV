<cfquery name="GET_ORDER_HEAD" datasource="#DSN3#">
	SELECT ORDER_HEAD FROM ORDERS WHERE	ORDER_ID = #attributes.order_id#
</cfquery>
<cfquery name="get_branch" datasource="#DSN#">
	SELECT BRANCH_ID,BRANCH_NAME FROM BRANCH WHERE COMPANY_ID = #SESSION.EP.COMPANY_ID# 
</cfquery>
<cfquery name="GET_ORDER_PRODUCTS" datasource="#dsn3#">
	SELECT
	DISTINCT 
		ORDER_ROW.STOCK_ID,
		ORDER_ROW.PRODUCT_ID, 
		ORDER_ROW.SPECT_VAR_ID, 
		ORDER_ROW.SPECT_VAR_NAME,
		PRODUCT.IS_PRODUCTION
	FROM 
		ORDER_ROW,
		#dsn1_alias#.PRODUCT AS PRODUCT
	WHERE
		ORDER_ID = #attributes.order_id# AND
		PRODUCT.PRODUCT_ID = ORDER_ROW.PRODUCT_ID
</cfquery>
<cfscript>
	sepet = StructNew();
	sepet.satir = ArrayNew(1);
	for (i = 1; i lte get_order_products.recordcount;i=i+1)
		{
		sepet.satir[i] = StructNew();
		sepet.satir[i].product_id = get_order_products.product_id[i];
		sepet.satir[i].is_production = get_order_products.is_production[i];
		sepet.satir[i].spect_var_id = get_order_products.spect_var_id[i];
		sepet.satir[i].spect_var_name = get_order_products.spect_var_name[i];
		sepet.satir[i].stock_id = get_order_products.stock_id[i];
		SQLString = "SELECT STOCKS.PROPERTY,PRODUCT.PRODUCT_NAME FROM PRODUCT, STOCKS WHERE STOCKS.STOCK_ID = #get_order_products.stock_id[i]# AND PRODUCT.PRODUCT_ID = STOCKS.PRODUCT_ID";
		get_stock_name = cfquery(SQLString : SQLString, Datasource : DSN3);
		if(len(get_stock_name.PROPERTY))
			sepet.satir[i].product_name = get_stock_name.PRODUCT_NAME & "-" & get_stock_name.PROPERTY ;		
		else
			sepet.satir[i].product_name = get_stock_name.PRODUCT_NAME ;		
		}
</cfscript>
<cfloop from="1" to="#arraylen(sepet.satir)#" index="i" >
	<cfset attributes.pid = sepet.satir[i].product_id >
	<cfif not ListFind(stok_list,sepet.satir[i].stock_id,",") or not ListFind(spect_var_id_list,sepet.satir[i].spect_var_id,",")>
		<cfset stok_list = ListAppend(stok_list,sepet.satir[i].stock_id,",") >
		<cfset proname_list = ListAppend(proname_list,sepet.satir[i].product_name,";") >
	</cfif>
	<cfset product_ids = ListAppend(product_ids, attributes.pid)>
	<cfif len(sepet.satir[i].spect_var_id)>
		<cfset spect_var_id_list = ListAppend(spect_var_id_list,sepet.satir[i].spect_var_id,",")>
	<cfelse>
		<cfset spect_var_id_list = ListAppend(spect_var_id_list,0,",")>
	</cfif>
	<cfif len(sepet.satir[i].spect_var_name)>
		<cfset spect_var_name_list = ListAppend(spect_var_name_list,sepet.satir[i].spect_var_name,";")>
	<cfelse>
		<cfset spect_var_name_list = ListAppend(spect_var_name_list,9,";")>
	</cfif>
	<cfset is_production_list = ListAppend(is_production_list, attributes.pid)>
</cfloop>
<cfif not len(product_ids)>
	<script type="text/javascript">
		alert("sepet.satir Boş !");
		window.close();
	</script>
	<cfabort>
	<cfexit method="exittemplate">
</cfif>
<cfquery name="GET_STOCKS_ALL" datasource="#DSN2#">
	SELECT 
		SUM(GSB.PRODUCT_STOCK) AS PRODUCT_STOCK,
		D.DEPARTMENT_ID,
		GSB.PRODUCT_ID,
		D.DEPARTMENT_HEAD,
        GSB.STOCK_ID
	FROM
		GET_STOCK_PRODUCT GSB,
		#dsn_alias#.DEPARTMENT D
	WHERE
		GSB.PRODUCT_ID IN (#product_ids#) AND
        GSB.STOCK_ID IN (#stok_list#) AND 
        D.DEPARTMENT_ID = GSB.DEPARTMENT_ID
	GROUP BY
		D.DEPARTMENT_ID, GSB.PRODUCT_ID, D.DEPARTMENT_HEAD,GSB.STOCK_ID
</cfquery>
<cfquery name='get_stock_reserved_azalan' datasource="#dsn3#">
	SELECT 
		SUM(STOCK_AZALT) AS AZALAN,SUM(STOCK_ARTIR) AS ARTAN,PRODUCT_ID,STOCK_ID
	FROM 
		GET_STOCK_RESERVED 
	WHERE 
		PRODUCT_ID IN (#product_ids#) AND
        STOCK_ID IN (#stok_list#)
	GROUP BY
		PRODUCT_ID,
        STOCK_ID	
</cfquery>
<cfquery name="GET_PRODUCT_TOTAL_STOCK" datasource="#dsn2#">
	SELECT 
		SUM(PRODUCT_STOCK) AS PRODUCT_TOTAL_STOCK,PRODUCT_ID,STOCK_ID
	FROM 
		GET_STOCK_PRODUCT
	WHERE 
		STOCK_ID IN (#stok_list#)
	GROUP BY
		PRODUCT_ID,
        STOCK_ID
</cfquery>

<cfquery name="get_stock_profile" datasource="#dsn2#">
	SELECT 
		SUM(GSL.REAL_STOCK) REAL_STOCK,
		SUM(GSL.SALEABLE_STOCK) SALEABLE_STOCK,
		SUM(GSL.RESERVE_SALE_ORDER_STOCK) RESERVE_SALE_ORDER_STOCK,
		SUM(GSL.RESERVE_PURCHASE_ORDER_STOCK) RESERVE_PURCHASE_ORDER_STOCK,
		SUM(GSL.RESERVED_PROD_STOCK) RESERVED_PROD_STOCK,
		SUM(GSL.PURCHASE_PROD_STOCK) PURCHASE_PROD_STOCK,
		GSL.STOCK_ID
	FROM 
		GET_STOCK_LAST_PROFILE GSL
	WHERE 
		GSL.STOCK_ID IN (#stok_list#)
	GROUP BY
		GSL.STOCK_ID
</cfquery>	

<cfquery name="get_departments" dbtype="query">
	SELECT DISTINCT DEPARTMENT_ID,DEPARTMENT_HEAD FROM GET_STOCKS_ALL
</cfquery>
