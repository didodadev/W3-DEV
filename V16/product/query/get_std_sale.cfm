<cfif not isDefined("attributes.price_type")>
	<cfquery name="GET_PRODUCT_PRICE" datasource="#dsn3#">
		SELECT 
			PS.START_DATE AS STARTDATE,PS.RECORD_DATE,PS.PRICE,PS.PRICE_KDV,PS.IS_KDV,PS.MONEY,PRODUCT_UNIT.ADD_UNIT,PS.RECORD_EMP, PRODUCT.TAX
		FROM 
			PRICE_STANDART AS PS, PRODUCT_UNIT, PRODUCT
		WHERE 
			PRODUCT_UNIT.PRODUCT_ID = PS.PRODUCT_ID AND 
			PRODUCT_UNIT.PRODUCT_ID = PRODUCT.PRODUCT_ID AND 
			PS.PRODUCT_ID = PRODUCT.PRODUCT_ID AND 
			PS.UNIT_ID = PRODUCT_UNIT.PRODUCT_UNIT_ID AND 
			PS.PRODUCT_ID = #attributes.PID# AND 
			PS.PURCHASESALES = 1 
		<cfif isdate(attributes.startdate)>
			AND PS.RECORD_DATE >= #attributes.startdate# 
		</cfif> 
		<cfif isdate(attributes.finishdate)>
			AND PS.RECORD_DATE <= #attributes.finishdate#
		</cfif>
		ORDER BY 
			PS.START_DATE DESC,
			PS.RECORD_DATE DESC
	</cfquery>
<cfelseif isdefined('attributes.pricecatid') and len(attributes.pricecatid)>
	<cfquery name="GET_PRODUCT_PRICE" datasource="#dsn3#">
		SELECT 
			PH.RECORD_DATE,PH.PRICE,PH.PRICE_KDV,PH.IS_KDV,PH.MONEY,PRODUCT_UNIT.ADD_UNIT,PH.CATALOG_ID,PH.RECORD_EMP,PH.STARTDATE,PH.FINISHDATE, PRODUCT.TAX
		FROM 
			PRICE_HISTORY AS PH, PRODUCT_UNIT, PRODUCT
		WHERE 
			PRODUCT_UNIT.PRODUCT_ID = PH.PRODUCT_ID AND 
			PRODUCT_UNIT.PRODUCT_ID = PRODUCT.PRODUCT_ID AND 
			PH.PRODUCT_ID = PRODUCT.PRODUCT_ID AND 
			PH.UNIT = PRODUCT_UNIT.PRODUCT_UNIT_ID AND 
			PH.PRODUCT_ID = #attributes.PID# AND 
			PH.PRICE_CATID = #attributes.pricecatid#
		<cfif isdate(attributes.startdate)>
			AND PH.STARTDATE >= #attributes.startdate#
		</cfif>
		<cfif isdate(attributes.finishdate)>
			AND PH.FINISHDATE <= #attributes.finishdate#
		</cfif>
		ORDER BY 
			PH.STARTDATE DESC
	</cfquery>
<cfelseif attributes.price_type is "sale">
	<cfquery name="GET_PRODUCT_PRICE" datasource="#dsn3#">
		SELECT 
			PS.START_DATE AS STARTDATE,PS.RECORD_DATE,PS.PRICE,PS.PRICE_KDV,PS.IS_KDV,PS.MONEY,PRODUCT_UNIT.ADD_UNIT,PS.RECORD_EMP, PRODUCT.TAX
		FROM 
			PRICE_STANDART AS PS, PRODUCT_UNIT, PRODUCT
		WHERE 
			PRODUCT_UNIT.PRODUCT_ID = PS.PRODUCT_ID AND 
			PRODUCT_UNIT.PRODUCT_ID = PRODUCT.PRODUCT_ID AND 
			PS.PRODUCT_ID = PRODUCT.PRODUCT_ID AND 
			PS.UNIT_ID = PRODUCT_UNIT.PRODUCT_UNIT_ID AND 
			PS.PRODUCT_ID = #attributes.PID# AND 
			PS.PURCHASESALES = 1
		<cfif isdate(attributes.startdate)>
			AND PS.RECORD_DATE >= #attributes.startdate# 
		</cfif> 
		<cfif isdate(attributes.finishdate)>
			AND PS.RECORD_DATE <= #attributes.finishdate#
		</cfif>
		ORDER BY 
			PS.START_DATE DESC,
			PS.RECORD_DATE DESC
	</cfquery>
<cfelseif attributes.price_type is "purc">
	<cfquery name="GET_PRODUCT_PRICE" datasource="#dsn3#">
		SELECT 
			PS.START_DATE AS STARTDATE,PS.RECORD_DATE,PS.PRICE,PS.PRICE_KDV,PS.IS_KDV,PS.MONEY,PRODUCT_UNIT.ADD_UNIT,PS.RECORD_EMP, PRODUCT.TAX_PURCHASE AS TAX
		FROM 
			PRICE_STANDART AS PS, PRODUCT_UNIT, PRODUCT
		WHERE 
			PRODUCT_UNIT.PRODUCT_ID = PS.PRODUCT_ID AND 
			PRODUCT_UNIT.PRODUCT_ID = PRODUCT.PRODUCT_ID AND 
			PS.PRODUCT_ID = PRODUCT.PRODUCT_ID AND 
			PS.UNIT_ID = PRODUCT_UNIT.PRODUCT_UNIT_ID AND 
			PS.PRODUCT_ID = #attributes.PID# AND 
			PS.PURCHASESALES = 0
		<cfif isdate(attributes.startdate)>
			AND PS.RECORD_DATE >= #attributes.startdate# 
		</cfif> 
		<cfif isdate(attributes.finishdate)>
			AND PS.RECORD_DATE <= #attributes.finishdate#
		</cfif>
		ORDER BY 
			PS.START_DATE DESC,
			PS.RECORD_DATE DESC
	</cfquery>
<cfelseif isNumeric(attributes.price_type)>
	<cfquery name="GET_PRODUCT_PRICE" datasource="#dsn3#">
		SELECT 
			PH.RECORD_DATE,PH.PRICE,PH.PRICE_KDV,PH.IS_KDV,PH.MONEY,PRODUCT_UNIT.ADD_UNIT,PH.CATALOG_ID,PH.RECORD_EMP,PH.STARTDATE,PH.FINISHDATE, PRODUCT.TAX
		FROM 
			PRICE_HISTORY AS PH, PRODUCT_UNIT, PRODUCT
		WHERE 
			PRODUCT_UNIT.PRODUCT_ID = PH.PRODUCT_ID AND 
			PRODUCT_UNIT.PRODUCT_ID = PRODUCT.PRODUCT_ID AND 
			PH.PRODUCT_ID = PRODUCT.PRODUCT_ID AND 
			PH.UNIT = PRODUCT_UNIT.PRODUCT_UNIT_ID AND 
			PH.PRODUCT_ID = #attributes.PID# AND 
			PH.PRICE_CATID = #attributes.price_type#
		<cfif isdate(attributes.startdate)>
			AND PH.STARTDATE >= #attributes.startdate#
		</cfif>
		<cfif isdate(attributes.finishdate)>
			AND PH.FINISHDATE <= #attributes.finishdate#
		</cfif>
		ORDER BY 
			PH.STARTDATE DESC
	</cfquery>
<cfelseif attributes.price_type is "daily">
<cfquery name="GET_PRODUCT_PRICE" datasource="#dsn3#">
	SELECT 
		PH.RECORD_DATE,PH.PRICE,PH.PRICE_KDV,PH.IS_KDV,PH.MONEY,PRODUCT_UNIT.ADD_UNIT,PH.CATALOG_ID,PH.RECORD_EMP,PH.STARTDATE AS STARTDATE,PH.FINISHDATE, PRODUCT.TAX, PH.PRICE_CATID
	FROM 
		PRICE_HISTORY AS PH, PRODUCT_UNIT, PRODUCT
	WHERE 
		PRODUCT_UNIT.PRODUCT_ID = PH.PRODUCT_ID AND 
		PRODUCT_UNIT.PRODUCT_ID = PRODUCT.PRODUCT_ID AND 
		PH.PRODUCT_ID = PRODUCT.PRODUCT_ID AND 
		PH.UNIT = PRODUCT_UNIT.PRODUCT_UNIT_ID AND 
		PH.PRODUCT_ID = #URL.PID#
	<cfif isdate(attributes.startdate)>
		AND PH.STARTDATE >= #attributes.startdate#
	</cfif>
	<cfif isdate(attributes.finishdate)>
		AND PH.STARTDATE <= #attributes.finishdate#
	</cfif>
	ORDER BY 
		STARTDATE DESC
</cfquery>
<cfelseif attributes.price_type is "all_list">
		<cfquery name="GET_PRODUCT_PRICE" datasource="#dsn3#">
		(SELECT 
			PS.START_DATE AS STARTDATE,PS.RECORD_DATE,PS.PRICE,PS.PRICE_KDV,PS.IS_KDV,PS.MONEY,PRODUCT_UNIT.ADD_UNIT,PS.RECORD_EMP, PRODUCT.TAX
		FROM 
			PRICE_STANDART AS PS, PRODUCT_UNIT, PRODUCT
		WHERE 
			PRODUCT_UNIT.PRODUCT_ID = PS.PRODUCT_ID AND 
			PRODUCT_UNIT.PRODUCT_ID = PRODUCT.PRODUCT_ID AND 
			PS.PRODUCT_ID = PRODUCT.PRODUCT_ID AND 
			PS.UNIT_ID = PRODUCT_UNIT.PRODUCT_UNIT_ID
			AND PS.PRODUCT_ID = #URL.PID#
				<cfif isdate(attributes.startdate)>
		AND PS.START_DATE >= #attributes.startdate#
	</cfif>
	<cfif isdate(attributes.finishdate)>
		AND PS.START_DATE <= #attributes.finishdate#
	</cfif>
				UNION
			SELECT 
			PH.STARTDATE AS STARTDATE,PH.RECORD_DATE,PH.PRICE,PH.PRICE_KDV,PH.IS_KDV,PH.MONEY,PRODUCT_UNIT.ADD_UNIT,PH.RECORD_EMP, PRODUCT.TAX
			FROM 
				PRICE_HISTORY AS PH, PRODUCT_UNIT, PRODUCT
			WHERE 
				PRODUCT_UNIT.PRODUCT_ID = PH.PRODUCT_ID AND 
				PRODUCT_UNIT.PRODUCT_ID = PRODUCT.PRODUCT_ID AND 
				PH.PRODUCT_ID = PRODUCT.PRODUCT_ID AND 
				PH.UNIT = PRODUCT_UNIT.PRODUCT_UNIT_ID AND 
				PH.PRODUCT_ID = #URL.PID#
				<cfif isdate(attributes.startdate)>
		AND PH.STARTDATE >= #attributes.startdate#
	</cfif>
	<cfif isdate(attributes.finishdate)>
		AND PH.STARTDATE <= #attributes.finishdate#
	</cfif>
				)
				ORDER BY 
		STARTDATE DESC
		</cfquery>
</cfif>