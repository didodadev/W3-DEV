<!--- eger sorgunun bu hali dogru ise bu sorgu buyuk cfoutputun icine yazilacak.. --->
<cfif len(attributes.price_catid) and attributes.price_catid gt 0>
	<cfset pro_cat_lists = attributes.price_catid&",-1,-2">
<cfelse>
	<cfset pro_cat_lists = "-1,-2" >
</cfif>

<cfquery name="GET_PRO" datasource="#DSN3#">
	SELECT 
		* 
	FROM 
		STOCKS S, 
		PROMOTIONS P
	WHERE 
		S.STOCK_ID = P.STOCK_ID AND 
		S.PRODUCT_ID = #PID# AND 
		P.STARTDATE < #now()# AND 
		P.FINISHDATE >= #now()# AND
		P.PRICE_CATID IN (#pro_cat_lists#)
</cfquery>
