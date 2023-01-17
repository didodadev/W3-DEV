<!---<cfquery name="GET_STOCK_ARTAN_AZALAN" datasource="#DSN3#"><!--- siparisler stoktan dusulecek veya eklenecek miktar toplamı toplamını alalım--->
	SELECT
		SUM(STOCK_AZALT) AS AZALAN,
		SUM(STOCK_ARTIR) AS ARTAN
	FROM
		GET_STOCK_RESERVED
	WHERE
		STOCK_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.sid#">
</cfquery>

<cfquery name="GET_PROD_RESERVED" datasource="#DSN3#"><!--- üretim emrinden gelen stok rezerv --->
	SELECT
		SUM(STOCK_ARTIR-STOCK_AZALT) AS FARK,
		STOCK_ID
	FROM
		GET_PRODUCTION_RESERVED
	WHERE
		STOCK_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.sid#">
	GROUP BY STOCK_ID
</cfquery>
<!--- kullanılabilir lokasyonlardaki (satış yapılamaz lokasyonlar haricindeki) urun toplam miktarı --->
<cfquery name="LOCATION_BASED_STOCK" datasource="#DSN2#">
	SELECT 
		TOTAL_STOCK, 
		STOCK_ID
	FROM
		GET_STOCK_LOCATION
	WHERE
		STOCK_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.sid#">
	ORDER BY STOCK_ID
</cfquery>
<cfif location_based_stock.recordcount and len(location_based_stock.total_stock)>
	<cfset product_stock = location_based_stock.total_stock>
<cfelse>
	<cfset product_stock = 0>
</cfif>
<!--- alınan siparis/rezerve miktarı gercek stoktan dusuluyor --->
<cfif get_stock_artan_azalan.recordcount and len(get_stock_artan_azalan.azalan)>
	<cfset product_stock = product_stock - get_stock_artan_azalan.azalan>
</cfif>
<!--- verilen siparis/ beklenen miktar gercek stoga ekleniyor ---> 
<cfif get_stock_artan_azalan.recordcount and len(get_stock_artan_azalan.artan)>
	<cfset product_stock = product_stock + get_stock_artan_azalan.artan>
</cfif> 
<!--- üretim emri sonucu (beklenen miktar-sarf edilen miktar) farkı gerçek stoga ekleniyor --->
<cfif get_prod_reserved.recordcount and len(get_prod_reserved.fark)>
	<cfset product_stock = product_stock + get_prod_reserved.fark>
</cfif> --->

<cfquery name="GET_STOCK_LAST" datasource="#DSN2#">
	<cfif isdefined("attributes.is_stock_count_dept") and len(attributes.is_stock_count_dept) and listlen(attributes.is_stock_count_dept,'-') eq 2>
        get_stock_last_location_function '#attributes.sid#'
	<cfelseif isdefined("session.ww.department_ids") and len(session.ww.department_ids)>
        get_stock_last_location_function '#attributes.sid#'
    <cfelseif isdefined("session.pp.department_ids") and len(session.pp.department_ids)>
        get_stock_last_location_function '#attributes.sid#'
    <cfelse>
        get_stock_last_function '#attributes.sid#'
    </cfif>
</cfquery>

<cfquery name="GET_LAST_STOCKS" dbtype="query">
    SELECT
        SUM(PRODUCT_STOCK) AS PRODUCT_STOCK,
        SUM(SALEABLE_STOCK) AS SALEABLE_STOCK,
        SUM(PURCHASE_ORDER_STOCK) AS PURCHASE_ORDER_STOCK,
        STOCK_ID
    FROM
        GET_STOCK_LAST
	<cfif isdefined("attributes.is_stock_count_dept") and len(attributes.is_stock_count_dept) and listlen(attributes.is_stock_count_dept,'-') eq 2>
        WHERE
            DEPARTMENT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#listgetat(attributes.is_stock_count_dept,1,'-')#"> AND 
            LOCATION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#listgetat(attributes.is_stock_count_dept,2,'-')#">
	<cfelseif isdefined("session.ww.department_ids") and len(session.ww.department_ids)>
        WHERE
            DEPARTMENT_ID IN (#session.ww.department_ids#)
    <cfelseif isdefined("session.pp.department_ids") and len(session.pp.department_ids)>
        WHERE
            DEPARTMENT_ID IN (#session.pp.department_ids#)
    </cfif>
    GROUP BY 
        STOCK_ID
</cfquery>
<cfset product_stock = get_last_stocks.saleable_stock>

