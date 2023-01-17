<cfquery name="GET_PRICE" datasource="#DSN3#">
	SELECT
		PRICE,
		MONEY,
		IS_KDV,
		PRICE_KDV
	FROM 
		PRICE_STANDART,
		PRODUCT_UNIT
	WHERE 
		PRICE_STANDART.PURCHASESALES = 1 AND 
		PRODUCT_UNIT.IS_MAIN = 1 AND 
		PRICE_STANDART.PRICESTANDART_STATUS = 1 AND 
	  <cfif isdefined("attributes.product_id")>
		PRICE_STANDART.PRODUCT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.product_id#"> AND
	  <cfelse>
		PRICE_STANDART.PRODUCT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.pid#"> AND
	  </cfif>
	  <cfif isdefined("attributes.product_id")>
		PRODUCT_UNIT.PRODUCT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.product_id#"> 
	  <cfelse>
		PRODUCT_UNIT.PRODUCT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.pid#"> 
	  </cfif>
</cfquery>
