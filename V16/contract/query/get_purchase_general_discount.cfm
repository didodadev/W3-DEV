<cfquery name="GET_PURCHASE_GENERAL_DISCOUNT" datasource="#dsn3#">
SELECT
	*
FROM
	<cfif not isdefined('TABLE_NAME')><!--- Bu alan satın alma ve satış tablolarının güncellemesine giderken,seçilen yerden gelen tipe göre çalışıyor,else'li bloğu başka yerde çalışıyor diye bıraktım. --->
	CONTRACT_PURCHASE_GENERAL_DISCOUNT
	<cfelse>
	#TABLE_NAME#
	</cfif>
	
WHERE
	GENERAL_DISCOUNT_ID = #general_discount_id#
</cfquery>
<cfquery name="GET_PURCHASE_GENERAL_DISCOUNT_BRANCHES" datasource="#dsn3#">
SELECT
	*
FROM
	<cfif not isdefined('BRACH_TABLE')>
	CONTRACT_PURCHASE_GENERAL_DISCOUNT_BRANCHES
	<cfelse>
	#BRACH_TABLE#
	</cfif>
	
WHERE
	GENERAL_DISCOUNT_ID = #general_discount_id#
</cfquery>
