<cfquery name="GET_PRICE_SS" datasource="#DSN3#">
	SELECT	
		PRICE,
		PRICE_KDV,
	<cfif session.ep.period_year lt 2009>
		CASE WHEN MONEY ='TL' THEN '<cfoutput>#session.ep.money#</cfoutput>' ELSE MONEY END AS MONEY,
	<cfelse>
		MONEY,
	</cfif> 
		ADD_UNIT,
		PRODUCT_UNIT_ID
	FROM 
		PRICE_STANDART,
		PRODUCT_UNIT
	WHERE
	<cfif isdefined("attributes.pid") >
		PRICE_STANDART.PRODUCT_ID = #attributes.pid# AND 
	</cfif>
		PRICE_STANDART.PURCHASESALES = 1 AND 
		PRICE_STANDART.PRICESTANDART_STATUS = 1 AND 
		PRODUCT_UNIT.PRODUCT_ID = PRICE_STANDART.PRODUCT_ID AND 
		PRICE_STANDART.UNIT_ID = PRODUCT_UNIT.PRODUCT_UNIT_ID
	<cfif isdefined("attributes.product_id")>
		AND PRICE_STANDART.PRODUCT_ID = #attributes.product_id# 
	</cfif>
	ORDER BY
		PRODUCT_UNIT.PRODUCT_UNIT_ID
</cfquery>
<cfquery name="GET_PRICE_SA" datasource="#DSN3#">
	SELECT	
		PRICE,
		PRICE_KDV,
	<cfif session.ep.period_year lt 2009>
		CASE WHEN MONEY ='TL' THEN '<cfoutput>#session.ep.money#</cfoutput>' ELSE MONEY END AS MONEY,
	<cfelse>
		MONEY,
	</cfif> 
		ADD_UNIT,
		PRODUCT_UNIT_ID
	FROM 
		PRICE_STANDART,
		PRODUCT_UNIT
	WHERE
	<cfif isdefined("attributes.pid") >
		PRICE_STANDART.PRODUCT_ID = #attributes.pid# AND 
	</cfif>
		PRICE_STANDART.PURCHASESALES = 0 AND 
		PRICE_STANDART.PRICESTANDART_STATUS = 1 AND 
		PRODUCT_UNIT.PRODUCT_ID = PRICE_STANDART.PRODUCT_ID AND 
		PRICE_STANDART.UNIT_ID = PRODUCT_UNIT.PRODUCT_UNIT_ID
	<cfif isdefined("attributes.product_id")>
		AND PRICE_STANDART.PRODUCT_ID = #attributes.product_id# 
	</cfif>
	ORDER BY
		PRODUCT_UNIT.PRODUCT_UNIT_ID
</cfquery>
