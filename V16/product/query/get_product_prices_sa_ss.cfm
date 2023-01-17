<!--- 
	Bu sayfadan objects*query icindede var orayida update ediniz.arzubt 051122003
--->
<cfquery name="GET_PRICE_SS" datasource="#DSN3#"> <!--- standart satis --->
	SELECT	
		PS.PRICE,
		PS.PRICE_KDV,
		PS.IS_KDV,
		PS.ROUNDING,
		PS.MONEY,
		CASE
			WHEN LEN(SLI.ITEM) > 0 THEN SLI.ITEM
			ELSE PU.ADD_UNIT
		END AS ADD_UNIT
	FROM 
		PRICE_STANDART AS PS,
		PRODUCT_UNIT AS PU
		LEFT JOIN #DSN#.SETUP_LANGUAGE_INFO SLI ON SLI.UNIQUE_COLUMN_ID = PU.UNIT_ID
		AND SLI.COLUMN_NAME = <cfqueryparam cfsqltype="cf_sql_varchar" value="UNIT">
		AND SLI.TABLE_NAME = <cfqueryparam cfsqltype="cf_sql_varchar" value="SETUP_UNIT">
		AND SLI.LANGUAGE = <cfqueryparam cfsqltype="cf_sql_varchar" value="#session.ep.language#">
	WHERE 
		PS.PRODUCT_ID = #attributes.pid# AND 
		PS.PURCHASESALES = 1 AND 
		PS.PRICESTANDART_STATUS = 1 AND 
		PU.PRODUCT_ID = PS.PRODUCT_ID AND 
		PS.UNIT_ID = PU.PRODUCT_UNIT_ID
	ORDER BY
		PU.PRODUCT_UNIT_ID
</cfquery>

<cfquery name="GET_PRICE_SA" datasource="#DSN3#"> <!--- standart alis --->
	SELECT	
		PS.PRICE,
		PS.PRICE_KDV,
		PS.IS_KDV,
		PS.ROUNDING,
		PS.MONEY,
		CASE
			WHEN LEN(SLI.ITEM) > 0 THEN SLI.ITEM
			ELSE PU.ADD_UNIT
		END AS ADD_UNIT 
	FROM 
		PRICE_STANDART AS PS,
		PRODUCT_UNIT AS PU
		LEFT JOIN #DSN#.SETUP_LANGUAGE_INFO SLI ON SLI.UNIQUE_COLUMN_ID = PU.UNIT_ID
		AND SLI.COLUMN_NAME = <cfqueryparam cfsqltype="cf_sql_varchar" value="UNIT">
		AND SLI.TABLE_NAME = <cfqueryparam cfsqltype="cf_sql_varchar" value="SETUP_UNIT">
		AND SLI.LANGUAGE = <cfqueryparam cfsqltype="cf_sql_varchar" value="#session.ep.language#">
	WHERE 
		PS.PRODUCT_ID = #attributes.pid# AND 
		PS.PURCHASESALES = 0 AND 
		PS.PRICESTANDART_STATUS = 1 AND 
		PU.PRODUCT_ID = PS.PRODUCT_ID AND 
		PS.UNIT_ID = PU.PRODUCT_UNIT_ID
	ORDER BY
		PU.PRODUCT_UNIT_ID
</cfquery>
