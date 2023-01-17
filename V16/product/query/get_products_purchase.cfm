<cfquery name="PRODUCTS" datasource="#DSN3#">
	WITH CTE1 AS (
	SELECT
		PRODUCT.COMPANY_ID,
		PRODUCT.PRODUCT_ID,
		PRODUCT.PRODUCT_NAME,
		PRODUCT.MANUFACT_CODE,
		PRODUCT.TAX,
		PRODUCT.TAX_PURCHASE,
		PRODUCT.PRODUCT_CATID,
		PRICE_STANDART.PRICE,
		PRICE_STANDART.MONEY,
		PS2.PRICE_KDV,
		PRODUCT_UNIT.ADD_UNIT,
		PRODUCT_UNIT.PRODUCT_UNIT_ID,
		PRODUCT_UNIT.MAIN_UNIT,
		PRODUCT_UNIT.MULTIPLIER
	FROM
		PRODUCT,
		PRODUCT_CAT,
		PRODUCT_UNIT,
		PRICE_STANDART,
		PRICE_STANDART as PS2
	WHERE
	<!--- <cfif not ( len(attributes.product_cat_code) or len(attributes.keyword) or (len(attributes.employee_id) and len(attributes.employee)) or (len(attributes.search_company_id) and len(attributes.search_company)) )>
		PRODUCT.PRODUCT_ID IS NULL AND <!--- kayit getirmesin --->
	</cfif> --->
		PRODUCT.PRODUCT_STATUS = 1 AND 	
		PRODUCT_UNIT.PRODUCT_UNIT_STATUS = 1 AND 
		PRODUCT.IS_SALES = 1 AND
		PRODUCT_UNIT.IS_MAIN = 1 AND 
		PRICE_STANDART.PRICESTANDART_STATUS = 1	AND 
		PRICE_STANDART.PURCHASESALES = 0 AND 
		PRODUCT_UNIT.PRODUCT_UNIT_ID = PRICE_STANDART.UNIT_ID AND 
		PS2.PRICESTANDART_STATUS = 1	AND 
		PS2.PURCHASESALES = 1 AND 
		PRODUCT_UNIT.PRODUCT_UNIT_ID = PS2.UNIT_ID AND 
		PRODUCT_UNIT.PRODUCT_ID = PRODUCT.PRODUCT_ID AND 
		PRODUCT_CAT.PRODUCT_CATID = PRODUCT.PRODUCT_CATID
		<cfif isDefined("attributes.product_cat_code") and len(attributes.product_cat_code)>
			AND PRODUCT.PRODUCT_CODE LIKE '#attributes.product_cat_code#.%'
		</cfif>
		<cfif isDefined("attributes.keyword") and len(attributes.keyword)>
			AND 
			(
			<cfif len(attributes.keyword) eq 1 >
				PRODUCT.PRODUCT_NAME LIKE '#attributes.keyword#%' 
			<cfelseif len(attributes.keyword) gt 1>
				<cfif listlen(attributes.keyword,"+") gt 1>
					(
						<cfloop from="1" to="#listlen(attributes.keyword,'+')#" index="pro_index">
							PRODUCT.PRODUCT_NAME LIKE '%#ListGetAt(attributes.keyword,pro_index,"+")#%' 
							<cfif pro_index neq listlen(attributes.keyword,'+')>AND</cfif>
						</cfloop>
					)		
				<cfelse>
					PRODUCT.PRODUCT_NAME LIKE '%#attributes.keyword#%' OR
					PRODUCT.PRODUCT_CODE LIKE '<cfif len(attributes.keyword) gt 1>%</cfif>#attributes.keyword#%' OR
					PRODUCT.BARCOD='#attributes.keyword#' OR 
					PRODUCT.MANUFACT_CODE LIKE '<cfif len(attributes.keyword) gt 1>%</cfif>#attributes.keyword#%' 
				</cfif>
			</cfif>		
			) 
		</cfif>
		<cfif len(attributes.employee_id) and isdefined("attributes.employee") and len(attributes.employee)>
			AND PRODUCT.PRODUCT_MANAGER = #attributes.employee_id#
		</cfif>
		<cfif len(attributes.search_company_id) and isdefined("attributes.search_company") and len(attributes.search_company)>
			AND PRODUCT.COMPANY_ID = #attributes.search_company_id#
		</cfif>
	),
	CTE2 AS (
				SELECT
					CTE1.*,
					ROW_NUMBER() OVER (	ORDER BY PRODUCT_NAME) AS RowNum,(SELECT COUNT(*) FROM CTE1) AS QUERY_COUNT
				FROM
					CTE1
			)
			SELECT
				CTE2.*
			FROM
				CTE2
			WHERE
				RowNum BETWEEN #attributes.startrow# and #attributes.startrow#+(#attributes.maxrows#-1)	
</cfquery>

