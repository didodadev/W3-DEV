<cfif isdefined('attributes.product_cat') and len(attributes.product_cat)>
	<cfquery name="GET_PRODUCT" datasource="#DSN1#">
		SELECT HIERARCHY FROM PRODUCT_CAT WHERE PRODUCT_CATID = #attributes.product_cat#
	</cfquery>
</cfif>

<cfquery name="GET_PRODUCT_PRICE" datasource="#dsn3#">
	SELECT
		<cfif attributes.price_cat_id eq "-2">
			PRICE_STANDART.PRICE_KDV,
			<!--- 
			PRICE_STANDART.PRICE,
			PRICE_STANDART.IS_KDV,--->
			PRICE_STANDART.MONEY,
			 
		<cfelse>
			PRICE.PRICE_KDV,
			<!--- 
			PRICE.PRICE,
			PRICE.IS_KDV,--->
			PRICE.MONEY,
			 
		</cfif>
		PRODUCT.BARCOD,
		PRODUCT.PRODUCT_NAME,
		PRODUCT.PRODUCT_ID,
		STOCKS.STOCK_ID
		<!--- 
		STOCKS.PROPERTY,
		PRODUCT.IS_INVENTORY,
		STOCKS.STOCK_CODE,
		PRODUCT.PRODUCT_CODE,
		PRODUCT.TAX,
		<cfif isdefined('attributes.sort_type') and (attributes.sort_type eq 3 or attributes.sort_type eq 4)> 
			PRODUCT_COST.PHYSICAL_DATE,
		</cfif>
		PRODUCT.IS_SERIAL_NO
		PRODUCT_UNIT.ADD_UNIT,
		PRODUCT_UNIT.UNIT_ID,
		PRODUCT_UNIT.MAIN_UNIT,
		PRODUCT_UNIT.MULTIPLIER,
		PRODUCT_UNIT.ADD_UNIT,
		PRODUCT_UNIT.PRODUCT_UNIT_ID,
		PRODUCT_UNIT.WEIGHT
		 --->
	FROM
		PRODUCT,
		PRODUCT_UNIT,
		PRODUCT_PERIOD PP,
		<!---<cfif isdefined('attributes.product_cat') and len(attributes.product_cat) and get_product.recordcount and len(get_product.hierarchy)>
			#dsn1_alias#.PRODUCT_CAT PC,
		</cfif>--->
		<cfif isdefined('attributes.sort_type') and (attributes.sort_type eq 3 or attributes.sort_type eq 4)> 
			PRODUCT_COST,
		</cfif>
		<cfif isdefined('attributes.stock_status') and (attributes.stock_status eq 1 or attributes.stock_status eq 2)>
			#dsn2_alias#.GET_STOCK_LAST G,
		</cfif>
		<cfif attributes.price_cat_id eq "-2">
			PRICE_STANDART,
		<cfelse>
			PRICE,
		</cfif>
		STOCKS
	WHERE	
		PP.PRODUCT_ID = PRODUCT.PRODUCT_ID AND 
		PP.PERIOD_ID = #session.pda.period_id# AND
		<cfif isdefined('attributes.sort_type') and (attributes.sort_type eq 3 or attributes.sort_type eq 4)> 
			PRODUCT_COST.PRODUCT_ID = PRODUCT.PRODUCT_ID AND 
		</cfif>
		<cfif isdefined('attributes.stock_status') and attributes.stock_status eq 1>
			G.SALEABLE_STOCK > 0 AND
			STOCKS.STOCK_ID = G.STOCK_ID AND	
		<cfelseif isdefined('attributes.stock_status') and attributes.stock_status eq 2>
			G.SALEABLE_STOCK <= 0 AND
			STOCKS.STOCK_ID = G.STOCK_ID AND
		</cfif>
		<cfif isdefined('attributes.brand_id') and len(attributes.brand_id) and isdefined('attributes.brand_name') and len(attributes.brand_name)>
			PRODUCT.BRAND_ID = #attributes.brand_id# AND 
		</cfif>	
		PRODUCT.PRODUCT_STATUS = 1 AND
		STOCKS.STOCK_STATUS = 1 AND
		<cfif isdefined('attributes.product_cat') and len(attributes.product_cat) and get_product.recordcount and len(get_product.hierarchy)>
			<!---PC.PRODUCT_CATID = PRODUCT.PRODUCT_CATID AND
			PC.HIERARCHY LIKE '#get_product.hierarchy#.%' AND
			PRODUCT.PRODUCT_CODE LIKE '#get_product.hierarchy#.%' AND--->
		</cfif>
		PRODUCT_UNIT.PRODUCT_ID = PRODUCT.PRODUCT_ID AND 
		PRODUCT.PRODUCT_ID = STOCKS.PRODUCT_ID AND
		PRODUCT_UNIT.PRODUCT_UNIT_STATUS = 1 AND
		PRODUCT.PRODUCT_CATID IS NOT NULL AND
		PRODUCT_UNIT.IS_MAIN = 1 AND
		<cfif attributes.price_cat_id eq "-2">
			PRICE_STANDART.PRICESTANDART_STATUS = 1	AND
			PRICE_STANDART.PURCHASESALES = 1 AND
			PRODUCT_UNIT.PRODUCT_UNIT_ID = PRICE_STANDART.UNIT_ID
		<cfelse>
			PRICE.PRICE_CATID = #attributes.price_cat_id# AND
			PRODUCT_UNIT.PRODUCT_UNIT_ID = PRICE.UNIT AND
			PRICE.STARTDATE <= #now()# AND
			(PRICE.FINISHDATE >= #now()# OR PRICE.FINISHDATE IS NULL)	
		</cfif>
		<cfif isDefined("attributes.keyword") and len(attributes.keyword)>
			AND PRODUCT.PRODUCT_NAME LIKE #sql_unicode()#'%#attributes.keyword#%'
		</cfif>
		<cfif isdefined("attributes.list_property_id") and len(attributes.list_property_id) and len(attributes.list_variation_id)>
			AND
			STOCKS.PRODUCT_ID IN
			(
				SELECT
					PRODUCT_ID
				FROM
					#dsn1_alias#.PRODUCT_DT_PROPERTIES PRODUCT_DT_PROPERTIES
				WHERE
					(
				  <cfloop from="1" to="#listlen(attributes.list_property_id,',')#" index="pro_index">
					(PROPERTY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#ListGetAt(attributes.list_property_id,pro_index,",")#"> AND VARIATION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#ListGetAt(attributes.list_variation_id,pro_index,",")#">)
					<cfif pro_index lt listlen(attributes.list_property_id,',')>OR</cfif>
				  </cfloop>
					)
				GROUP BY
					PRODUCT_ID
				HAVING
					COUNT(PRODUCT_ID)> = <cfqueryparam cfsqltype="cf_sql_integer" value="#listlen(attributes.list_property_id,',')#">
			)
		</cfif>
		<cfif isDefined("attributes.keyword") and len(attributes.keyword)>
			AND 
			(
				(
					<cfif listlen(attributes.keyword,"+") gt 1>
						(
							<cfloop from="1" to="#listlen(attributes.keyword,'+')#" index="pro_index">
								PRODUCT.PRODUCT_NAME LIKE #sql_unicode()#'<cfif pro_index neq 1>%</cfif>#ListGetAt(attributes.keyword,pro_index,"+")#%' 
								<cfif pro_index neq listlen(attributes.keyword,'+')>AND</cfif>
							</cfloop>
						)		
					<cfelse>
						<cfif not isnumeric(attributes.keyword)>
							PRODUCT.PRODUCT_NAME LIKE #sql_unicode()#'%#attributes.keyword#%'
						<cfelse>
							PRODUCT.PRODUCT_NAME LIKE #sql_unicode()#'%#attributes.keyword#%' OR
							PRODUCT.PRODUCT_CODE LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#replace(attributes.keyword,'+','')#%"> OR
							PRODUCT.BARCOD = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.keyword#"> OR 
							PRODUCT.MANUFACT_CODE LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.keyword#%">
						</cfif>
					</cfif>
				)
			)
		</cfif>

	ORDER BY
		<cfif isdefined('attributes.sort_type') and attributes.sort_type eq 1>
			G.SALEABLE_STOCK ASC
		<cfelseif isdefined('attributes.sort_type') and attributes.sort_type eq 2>
			G.SALEABLE_STOCK DESC
		<cfelseif isdefined('attributes.sort_type') and attributes.sort_type eq 3>
			PRODUCT_COST.PHYSICAL_DATE DESC
		<cfelseif isdefined('attributes.sort_type') and attributes.sort_type eq 4>
			PRODUCT_COST.PHYSICAL_DATE ASC
		<cfelseif isdefined('attributes.sort_type') and attributes.sort_type eq 5>
			PRODUCT.PRODUCT_NAME ASC
		<cfelse>
			PRODUCT.PRODUCT_NAME DESC
		</cfif>
</cfquery>
