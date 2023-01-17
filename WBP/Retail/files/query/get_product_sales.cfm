<cfif isdefined("attributes.search_startdate") and isdate(attributes.search_startdate)>
	<cf_date tarih = "attributes.search_startdate">
<cfelse>
	<cfset attributes.search_startdate = dateadd("m",-3,now())>
</cfif>
<cfif isdefined("attributes.search_finishdate") and isdate(attributes.search_finishdate)>
	<cf_date tarih = "attributes.search_finishdate">
<cfelse>
	<cfset attributes.search_finishdate = now()>
</cfif>

<cfquery name="get_" datasource="#dsn3#">
	SELECT
        SUM(ISNULL(#dsn_dev_alias#.fnc_get_ortalama_satis_stok(P1.STOCK_ID,#merkez_depo_id#,#attributes.search_startdate#,#attributes.search_finishdate#),0)) AS ROW_ORT_STOK_SATIS_MIKTARI 
    FROM 
    	STOCKS P1 
    WHERE 
    	P1.PRODUCT_ID = #attributes.PRODUCT_ID#
</cfquery>

<cfif fusebox.fuseaction contains 'emptypopup_get_product_sales2'>
    <cfquery name="get_stocks_" datasource="#dsn3#">
        SELECT TOP 1
            ISNULL((SELECT SUM(PRODUCT_STOCK) FROM #DSN2_ALIAS#.GET_STOCK_PRODUCT WHERE P1.PRODUCT_ID = GET_STOCK_PRODUCT.PRODUCT_ID AND GET_STOCK_PRODUCT.DEPARTMENT_ID = #merkez_depo_id#),0) AS DEPO_STOCK,
            ISNULL((SELECT SUM(PRODUCT_STOCK) FROM #DSN2_ALIAS#.GET_STOCK_PRODUCT WHERE P1.PRODUCT_ID = GET_STOCK_PRODUCT.PRODUCT_ID AND GET_STOCK_PRODUCT.DEPARTMENT_ID <> #merkez_depo_id#),0) AS MAGAZA_STOK
        FROM 
            STOCKS P1 
        WHERE 
            P1.PRODUCT_ID = #attributes.PRODUCT_ID#
    </cfquery>
	<cfoutput><cfif get_.ROW_ORT_STOK_SATIS_MIKTARI gt 0>#tlformat((get_stocks_.DEPO_STOCK + get_stocks_.MAGAZA_STOK) / get_.ROW_ORT_STOK_SATIS_MIKTARI)#<cfelse>-</cfif></cfoutput>
<cfelse>
	<cfoutput>#tlformat(get_.ROW_ORT_STOK_SATIS_MIKTARI)#</cfoutput>
</cfif>