<!--- 
	TODO:ARZU
	Siparisin durumu kontrol ediliyor ve ona gore update edilecek 
	Eger tam olarak karsilanmis sa -6
	Eksik ise  -7 
	Fazla ise -8
--->
<cfquery name="get_shp_rdr" datasource="#DSN2#">
	SELECT 
		PRODUCT_ID,SUM(AMOUNT) AS AMOUNT_ALL 
	FROM 
		SHIP,SHIP_ROW WHERE  SHIP.SHIP.SHIP_ID = SHIP_ROW.SHIP_ID AND SHIP.ORDER_ID = #ATTRIBUTES.ORDER_ID#
	ORDER BY PRODUCT_ID
	GROUP BY PRODUCT_ID
</cfquery>

<cfset liste_ship_1 = ValueList(get_shp_rdr.PRODUCT_ID) >
<cfset liste_ship_2 = ValueList(get_shp_rdr.AMOUNT_ALL) >

<cfquery name="get_shp_rdr_order" datasource="#DSN2#">
	SELECT 
		PRODUCT_ID,SUM(QUANTITY) AS AMOUNT_ALL 
	FROM 
		ORDER_ROW WHERE ORDER_ID = #ATTRIBUTES.ORDER_ID#
	ORDER BY PRODUCT_ID
	GROUP BY PRODUCT_ID
</cfquery>

<cfset liste_order_1 = ValueList(get_shp_rdr_order.PRODUCT_ID)>
<cfset liste_order_2 = ValueList(get_shp_rdr_order.AMOUNT_ALL)>
<cfif listlen(liste_order_1) eq listlen(liste_ship_1)>
	<cfset total = 0>
	<cfset int_kontrol = 0>
	<cfloop from="1" to="#listlen(liste_order_1)#" index="i">
		<cfloop from="1" to="#listlen(liste_ship_1)#" index="k">
			<cfif ListGetAt(liste_order_1,i) eq ListGetAt(liste_ship_1,i)>
				<cfset total = total + ListGetAt(liste_order_2,i) - ListGetAt(liste_ship_2,i) >
				<cfset int_kontrol = int_kontrol + 1 >
			</cfif>
		</cfloop>
	</cfloop>
	<cfif total lt 0>
		<cfset status = -7>
	<cfelse>
		<cfset status = -8>	
	</cfif>
<cfelse>
	<cfset total=listlen(liste_order_1) - listlen(liste_ship_1) >
	<cfif total lt 0>
		<cfset status = -7>
	<cfelse>
		<cfset status = -8>		
	</cfif>
</cfif>
