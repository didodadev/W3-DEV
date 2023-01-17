<!--- 
	Bu sayfalar teklif ve siparis basketlerinde listelenecek olan 
	asorti ile ilgili islemler fakat bu sayfalari kullanilip kullanilmamasi implementasyona irakildigindan sistem icinde 
	kullanilmayabilir. ARZU BT 06112003	
--->
<cfquery name="get_assortment" datasource="#DSN3#">
	SELECT 
		* 
	FROM 
		PRODUCT_ASSORTMENTS 
	WHERE 
		ACTION_ID=#attributes.ORDER_ROW_ID# 
	AND 
		ACTION_TYPE_ID=2
</cfquery>
