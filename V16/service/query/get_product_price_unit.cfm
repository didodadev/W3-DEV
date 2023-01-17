<!---
<cfquery name="GET_PRODUCT_PRICE" datasource="#dsn3#">
	SELECT
		DISTINCT
		PR.PRODUCT_NAME,
		PR.PRODUCT_ID,
		P.PRICE_ID,
		P.PRICE,
		P.MONEY,
		P.RECORD_EMP,
		P.STARTDATE,
		P.FINISHDATE,
		PU.ADD_UNIT,
		PU.PRODUCT_UNIT_ID,
		PU.WEIGHT,
		
		PC.PRICE_CAT
	FROM
		PRICE AS P,
		PRICE_CAT AS PC,
		PRODUCT_UNIT AS PU
		,PRODUCT PR
	WHERE
		
		PR.PRODUCT_ID = P.PRODUCT_ID
		AND
		PU.PRODUCT_ID = PR.PRODUCT_ID
		AND
		P.PRICE_CATID = PC.PRICE_CATID 
		AND
		P.PRICE_CATID = -2 AND
		P.STARTDATE <= #now()# 
		AND 
		(P.FINISHDATE >= #now()# OR P.FINISHDATE IS NULL) 
		AND
		P.UNIT = PU.PRODUCT_UNIT_ID 
	<cfif isdefined("attributes.keyword") and len(attributes.keyword)>
		AND
		PR.PRODUCT_NAME LIKE '<cfif len(attributes.keyword) gt 1>%</cfif>#attributes.keyword#%'
	</cfif>
</cfquery>
--->
<cfquery name="GET_PRODUCT_PRICE" datasource="#DSN3#">
	SELECT
		PRODUCT.IS_INVENTORY,
		PRODUCT.PRODUCT_NAME,
		PRODUCT.PRODUCT_ID,
		PRODUCT.PRODUCT_CODE,
		PRODUCT.TAX,
		PRODUCT.PRODUCT_CATID,
		PRODUCT.IS_SERIAL_NO,
		PRICE_STANDART.PRICE,
		PRICE_STANDART.PRICE_KDV,
		PRICE_STANDART.IS_KDV,
		PRICE_STANDART.MONEY,
		PRODUCT_UNIT.ADD_UNIT,
		PRODUCT_UNIT.UNIT_ID,
		PRODUCT_UNIT.MAIN_UNIT,
		PRODUCT_UNIT.MULTIPLIER,
		PRODUCT_UNIT.ADD_UNIT,
		PRODUCT_UNIT.PRODUCT_UNIT_ID,
		PRODUCT_UNIT.WEIGHT
	FROM
		PRODUCT,
		PRODUCT_CAT,
		PRODUCT_UNIT,
		PRICE_STANDART
	WHERE			
		PRODUCT.PRODUCT_STATUS = 1 AND 	
		PRODUCT_UNIT.PRODUCT_ID = PRODUCT.PRODUCT_ID AND 
		PRODUCT_UNIT.PRODUCT_UNIT_STATUS = 1 AND
		PRODUCT_CAT.PRODUCT_CATID = PRODUCT.PRODUCT_CATID AND 
		PRODUCT.IS_PURCHASE=1 AND
		PRODUCT_UNIT.IS_MAIN =1 AND 
		PRICE_STANDART.PRICESTANDART_STATUS = 1	AND 
		PRICE_STANDART.PURCHASESALES = 1 AND 
		PRODUCT_UNIT.PRODUCT_UNIT_ID = PRICE_STANDART.UNIT_ID
		<cfif isdefined("attributes.keyword") and len(attributes.keyword)>
			AND PRODUCT.PRODUCT_NAME LIKE '<cfif len(attributes.keyword) gt 1>%</cfif>#attributes.keyword#%'
		</cfif>
		<cfif isdefined("attributes.product_cat") and len(attributes.product_cat)>
			AND PRODUCT_CAT.HIERARCHY = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.product_cat_id#">
		</cfif>
		<cfif isdefined("attributes.barcode") and len(attributes.barcode)>
			AND PRODUCT.BARCOD = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.barcode#">
		</cfif>
	ORDER BY
		PRODUCT.PRODUCT_NAME		
</cfquery>

