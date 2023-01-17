<cfif pricecatid eq -1>
	<cfquery name="GET_PRODUCT_PRICES" datasource="#DSN3#">
		SELECT 
			PU.ADD_UNIT,
			PS.PRICE,
			PS.PRICE_KDV,
			PS.IS_KDV,
			PS.MONEY,
			PS.RECORD_DATE
		FROM 
			PRICE_STANDART PS, 
			PRODUCT_UNIT PU
		WHERE
			PS.PURCHASESALES = 0 AND
			PS.PRICESTANDART_STATUS = 1 AND 
			PS.UNIT_ID = PU.PRODUCT_UNIT_ID	AND
			PU.PRODUCT_UNIT_STATUS = 1 AND
			PS.PRODUCT_ID = #attributes.pid# 
	</cfquery>
<cfelseif pricecatid neq -1 and pricecatid neq -2>
	<cfquery name="GET_PRODUCT_PRICES" datasource="#DSN3#">
		SELECT 
			PR.MONEY,
			PR.PRICE,
			PR.PRICE_KDV,
			PR.IS_KDV,
			PU.ADD_UNIT,
			PR.RECORD_DATE
		FROM 
			PRICE PR, 
			PRODUCT_UNIT PU
		WHERE
			PR.PRICE_CATID = #pricecatid# AND
			PR.STARTDATE <= #now()# AND
			(PR.FINISHDATE >= #now()# OR PR.FINISHDATE IS NULL) AND
			PR.UNIT = PU.PRODUCT_UNIT_ID AND
			PU.PRODUCT_UNIT_STATUS = 1 AND
			<!---ISNULL(PR.STOCK_ID,0) =0 AND--->
			ISNULL(PR.SPECT_VAR_ID,0) =0 AND
			PR.PRODUCT_ID = #attributes.pid#
	</cfquery>
<cfelse>
	<cfquery name="GET_PRODUCT_PRICES" datasource="#DSN3#">
		SELECT 
			PU.ADD_UNIT,
			PS.MONEY,
			PS.PRICE,
			PS.PRICE_KDV,
			PS.IS_KDV,
			PS.RECORD_DATE
		FROM 
			PRICE_STANDART PS, 
			PRODUCT_UNIT PU
		WHERE
			PS.PURCHASESALES = 1 AND
			PS.PRICESTANDART_STATUS = 1 AND 
			PS.UNIT_ID = PU.PRODUCT_UNIT_ID AND
			PU.PRODUCT_UNIT_STATUS = 1 AND
			PS.PRODUCT_ID = #attributes.pid#
	</cfquery>
</cfif>
