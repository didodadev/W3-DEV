<!--- asagıdaki queryler kullanılabilir stok miktarı hesaplamalarında kullanıyor OZDEN20060530--->
<cfscript>
	active_stock_list="";
	artan_stock_list="";
</cfscript>

<cfquery name="GET_STOCK_LAST" datasource="#DSN2#">
	<cfif isdefined("session.ww.department_ids") and len(session.ww.department_ids) or  isdefined("session.pp.department_ids") and len(session.pp.department_ids)>
        get_stock_last_location_function '#stock_list#'
    <cfelse>
        get_stock_last_function '#stock_list#'
    </cfif>
</cfquery>
<cfquery name="GET_SALEABLE_STOCKS" dbtype="query">
    SELECT
        SUM(SALEABLE_STOCK) AS SALEABLE_STOCK,
        STOCK_ID
    FROM
        GET_STOCK_LAST
    <cfif isdefined("session.ww.department_ids") and len(session.ww.department_ids)>
        WHERE
            DEPARTMENT_ID IN (#session.ww.department_ids#)
    <cfelseif isdefined("session.pp.department_ids") and len(session.pp.department_ids)>
        WHERE
            DEPARTMENT_ID IN (#session.pp.department_ids#)
    </cfif>
    GROUP BY 
        STOCK_ID
</cfquery>
<cfset active_stock_list=valuelist(get_saleable_stocks.stock_id,',')>
<cfquery name="GET_STOCK_ARTAN" datasource="#DSN3#"><!--- verilen sipariş  sonucu beklenen miktar--->
	SELECT
		SUM((ORR.RESERVE_STOCK_IN-ORR.STOCK_IN) * PU.MULTIPLIER) AS ARTAN,
		S.STOCK_ID
	FROM
		#dsn1_alias#.STOCKS S,
		GET_ORDER_ROW_RESERVED ORR, 
		ORDERS ORDS,
		PRODUCT_UNIT PU
	WHERE
		ORR.STOCK_ID = S.STOCK_ID AND 
		ORDS.RESERVED = 1 AND 
		ORDS.ORDER_STATUS = 1 AND	
		ORR.ORDER_ID = ORDS.ORDER_ID AND
		ORDS.PURCHASE_SALES = 0 AND
		ORDS.ORDER_ZONE = 0  AND
		S.PRODUCT_UNIT_ID = PU.PRODUCT_UNIT_ID  AND
		S.STOCK_ID IN (#stock_list#)
	GROUP BY S.STOCK_ID
	HAVING SUM((ORR.RESERVE_STOCK_IN-ORR.STOCK_IN) * PU.MULTIPLIER) <> 0 <!--- kapatılmıs satırların gelmesini engellemek icin eklendi --->
</cfquery>
<cfset artan_stock_list=valuelist(get_stock_artan.stock_id,',')>
