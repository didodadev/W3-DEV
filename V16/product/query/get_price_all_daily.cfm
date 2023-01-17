<!--- <cfif not isDefined("attributes.price_type")> --->
	<!--- <cfquery name="GET_PRODUCT_PRICE" datasource="#dsn3#">
		SELECT 
			PS.START_DATE AS STARTDATE,PS.RECORD_DATE,PS.PRICE,PS.PRICE_KDV,PS.IS_KDV,PS.MONEY,PRODUCT_UNIT.ADD_UNIT,PS.RECORD_EMP, PRODUCT.TAX, 'Alış' AS P_TYPE
		FROM 
			PRICE_STANDART AS PS, PRODUCT_UNIT, PRODUCT
		WHERE 
			PRODUCT_UNIT.PRODUCT_ID = PS.PRODUCT_ID AND 
			PRODUCT_UNIT.PRODUCT_ID = PRODUCT.PRODUCT_ID AND 
			PS.PRODUCT_ID = PRODUCT.PRODUCT_ID AND 
			PS.UNIT_ID = PRODUCT_UNIT.PRODUCT_UNIT_ID AND 
			PS.PRODUCT_ID = #URL.PID# AND 
			PS.PURCHASESALES = 1 
		<cfif isdate(attributes.startdate)>
			AND PS.RECORD_DATE >= #attributes.startdate# 
		</cfif> 
		<cfif isdate(attributes.finishdate)>
			AND PS.RECORD_DATE <= #attributes.finishdate#
		</cfif>
		ORDER BY 
			PS.RECORD_DATE DESC
	</cfquery>
<cfelseif attributes.price_type is "sale"> --->
	<cfquery name="GET_PRODUCT_PRICE" datasource="#dsn3#">
		
		<!--- SELECT 
			PS.RECORD_DATE,PS.PRICE,PS.PRICE_KDV,PS.IS_KDV,PS.MONEY,PRODUCT_UNIT.ADD_UNIT,'' CATALOG_ID,PS.RECORD_EMP,PS.START_DATE AS STARTDATE,'' FINISHDATE, PRODUCT.TAX, '1' AS P_TYPE
		FROM 
			PRICE_STANDART AS PS, PRODUCT_UNIT, PRODUCT
		WHERE 
			PRODUCT_UNIT.PRODUCT_ID = PS.PRODUCT_ID AND 
			PRODUCT_UNIT.PRODUCT_ID = PRODUCT.PRODUCT_ID AND 
			PS.PRODUCT_ID = PRODUCT.PRODUCT_ID AND 
			PS.UNIT_ID = PRODUCT_UNIT.PRODUCT_UNIT_ID AND 
			PS.PRODUCT_ID = #URL.PID# AND 
			PS.PURCHASESALES = 1 
		<cfif isdate(attributes.startdate)>
			AND PS.START_DATE >= #attributes.startdate# 
		</cfif> 
		<cfif isdate(attributes.finishdate)>
			AND PS.START_DATE <= #attributes.finishdate#
		</cfif>
		UNION ALL --->
		<!--- ORDER BY 
			PS.RECORD_DATE DESC
	</cfquery>
<cfelseif attributes.price_type is "purc">
	<cfquery name="GET_PRODUCT_PRICE" datasource="#dsn3#"> --->
		<!--- SELECT 
			PS.RECORD_DATE,PS.PRICE,PS.PRICE_KDV,PS.IS_KDV,PS.MONEY,PRODUCT_UNIT.ADD_UNIT,'' CATALOG_ID,PS.RECORD_EMP,PS.START_DATE AS STARTDATE,'' FINISHDATE,PRODUCT.TAX_PURCHASE AS TAX, '0' AS P_TYPE
		FROM 
			PRICE_STANDART AS PS, PRODUCT_UNIT, PRODUCT
		WHERE 
			PRODUCT_UNIT.PRODUCT_ID = PS.PRODUCT_ID AND 
			PRODUCT_UNIT.PRODUCT_ID = PRODUCT.PRODUCT_ID AND 
			PS.PRODUCT_ID = PRODUCT.PRODUCT_ID AND 
			PS.UNIT_ID = PRODUCT_UNIT.PRODUCT_UNIT_ID AND 
			PS.PRODUCT_ID = #URL.PID# AND 
			PS.PURCHASESALES = 0
		<cfif isdate(attributes.startdate)>
			AND PS.START_DATE >= #attributes.startdate# 
		</cfif> 
		<cfif isdate(attributes.finishdate)>
			AND PS.START_DATE <= #attributes.finishdate#
		</cfif>
		UNION ALL --->
		<!--- ORDER BY 
			PS.RECORD_DATE DESC
	</cfquery>
<cfelseif isNumeric(attributes.price_type)>
	<cfquery name="GET_PRODUCT_PRICE" datasource="#dsn3#"> --->
		SELECT 
			PH.RECORD_DATE,PH.PRICE,PH.PRICE_KDV,PH.IS_KDV,PH.MONEY,PRODUCT_UNIT.ADD_UNIT,PH.CATALOG_ID,PH.RECORD_EMP,PH.STARTDATE AS STARTDATE,PH.FINISHDATE, PRODUCT.TAX, PH.PRICE_CATID
		FROM 
			PRICE_HISTORY AS PH, PRODUCT_UNIT, PRODUCT
		WHERE 
			PRODUCT_UNIT.PRODUCT_ID = PH.PRODUCT_ID AND 
			PRODUCT_UNIT.PRODUCT_ID = PRODUCT.PRODUCT_ID AND 
			PH.PRODUCT_ID = PRODUCT.PRODUCT_ID AND 
			PH.UNIT = PRODUCT_UNIT.PRODUCT_UNIT_ID AND 
			PH.PRODUCT_ID = #URL.PID#<!---  AND 
			PH.PRICE_CATID = #attributes.price_type# --->
		<cfif isdate(attributes.startdate)>
			AND PH.STARTDATE <= #attributes.startdate#
			AND (PH.FINISHDATE >= #attributes.startdate# OR PH.FINISHDATE IS NULL)
		</cfif>
		<!--- <cfif isdate(attributes.finishdate)>
			AND PH.FINISHDATE <= #attributes.finishdate#
		</cfif> --->
		ORDER BY 
			STARTDATE DESC
	</cfquery>
<!--- </cfif> --->
<!--- <CFDUMP var="#GET_PRODUCT_PRICE#"> --->

