<cfquery name="PRODUCT_NAMES" datasource="#dsn3#">
	WITH CTE1 AS (
    SELECT 
	DISTINCT
		STOCKS.PRODUCT_UNIT_ID,
		STOCKS.STOCK_ID,
		STOCKS.PRODUCT_ID,
		STOCKS.STOCK_CODE,
		#dsn2_alias#.GET_STOCK.PRODUCT_STOCK, 
		STOCKS.PRODUCT_NAME,
		STOCKS.PROPERTY,
		STOCKS.BARCOD,
		STOCKS.TAX,
		STOCKS.IS_PRODUCTION,
		STOCKS.TAX_PURCHASE,
		STOCKS.MANUFACT_CODE,
		PRICE_STANDART.PRICE,
		PRICE_STANDART.MONEY,
		PRODUCT_UNIT.ADD_UNIT,
		ISNULL((SELECT SLI.ITEM FROM #dsn_alias#.SETUP_LANGUAGE_INFO SLI WHERE SLI.UNIQUE_COLUMN_ID = PRODUCT_UNIT.UNIT_ID AND SLI.COLUMN_NAME = 'UNIT' AND SLI.TABLE_NAME = 'SETUP_UNIT' AND SLI.LANGUAGE = '#session.ep.language#'),PRODUCT_UNIT.MAIN_UNIT) MAIN_UNIT,
		PRODUCT_UNIT.DIMENTION,
		0 AS CATALOG_ID,
        (SELECT TOP 1 SPECT_MAIN_ID FROM SPECT_MAIN SM WHERE SM.STOCK_ID = STOCKS.STOCK_ID AND SM.SPECT_STATUS = 1 AND SM.IS_TREE = 1 ORDER BY SM.RECORD_DATE DESC,SM.UPDATE_DATE DESC) SPECT_MAIN_ID,
		STOCKS.COMPANY_ID,
		COMPANY.FULLNAME MEMBER_NAME,
		COMPANY.MEMBER_CODE,
		ISNULL((SELECT TOP 1 PURCHASE_NET_SYSTEM FROM PRODUCT_COST PC WHERE PC.PRODUCT_ID = STOCKS.PRODUCT_ID ORDER BY START_DATE DESC,RECORD_DATE DESC, PRODUCT_COST_ID DESC),0) PRODUCT_COST,
		ISNULL((SELECT TOP 1 PURCHASE_NET_SYSTEM_2 FROM PRODUCT_COST PC WHERE PC.PRODUCT_ID = STOCKS.PRODUCT_ID ORDER BY START_DATE DESC,RECORD_DATE DESC, PRODUCT_COST_ID DESC),0) PRODUCT_COST2
	FROM
		PRODUCT_CAT,
		PRICE_STANDART,
		PRODUCT_UNIT,				
		STOCKS LEFT JOIN #dsn_alias#.COMPANY ON COMPANY.COMPANY_ID = STOCKS.COMPANY_ID,
		#dsn2_alias#.GET_STOCK
	WHERE
		PRODUCT_UNIT.PRODUCT_ID = STOCKS.PRODUCT_ID
		AND PRODUCT_UNIT.PRODUCT_UNIT_STATUS = 1
		AND #dsn2_alias#.GET_STOCK.STOCK_ID = STOCKS.STOCK_ID 
		AND PRODUCT_CAT.PRODUCT_CATID = STOCKS.PRODUCT_CATID
		AND PRICE_STANDART.PURCHASESALES = 0
		AND PRICESTANDART_STATUS = 1
		AND PRICE_STANDART.PRODUCT_ID = STOCKS.PRODUCT_ID 
		AND PRODUCT_UNIT.PRODUCT_UNIT_ID = PRICE_STANDART.UNIT_ID
		AND PRODUCT_UNIT.PRODUCT_UNIT_ID = STOCKS.PRODUCT_UNIT_ID
		<cfif len(attributes.keyword)>AND (STOCKS.PRODUCT_NAME LIKE '%#attributes.keyword#%' OR STOCKS.STOCK_CODE LIKE '%#attributes.keyword#%' OR STOCKS.STOCK_CODE_2 LIKE '%#attributes.keyword#%')</cfif>
		<cfif len(attributes.employee) and len(attributes.pos_code)>AND STOCKS.PRODUCT_MANAGER=#attributes.pos_code#</cfif>
		<cfif len(attributes.product_cat) and len(attributes.product_catid)>
			AND STOCKS.PRODUCT_CODE LIKE (SELECT HIERARCHY FROM PRODUCT_CAT WHERE PRODUCT_CATID=#attributes.product_catid#)+'.%' <!---kategori hiyerarşisine gore arama yapıyor --->
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
				<!---HAVING
					COUNT(PRODUCT_ID)> = <cfqueryparam cfsqltype="cf_sql_integer" value="#listlen(attributes.list_property_id,',')#">--->
			)
		</cfif>
		<cfif len(attributes.get_company) and len(attributes.get_company_id)>AND STOCKS.COMPANY_ID = #attributes.get_company_id#</cfif>
		<cfif len(attributes.brand_id) and len(attributes.brand_name)>AND STOCKS.BRAND_ID = #attributes.brand_id#</cfif>
		<cfif isdefined("attributes.is_production")>AND STOCKS.IS_PRODUCTION = 1</cfif>
		<cfif isdefined("attributes.search_status") and len(attributes.search_status) and attributes.search_status eq 1>
			AND (STOCKS.STOCK_STATUS = #attributes.search_status# AND STOCKS.PRODUCT_STATUS = #attributes.search_status#)
		<cfelseif isdefined("attributes.search_status") and len(attributes.search_status) and attributes.search_status eq 0>
			AND (STOCKS.STOCK_STATUS = #attributes.search_status# OR STOCKS.PRODUCT_STATUS = #attributes.search_status#)
		</cfif>
        ),
        CTE2 AS (
                SELECT
                    CTE1.*,
                        ROW_NUMBER() OVER (
                                                 ORDER BY PRODUCT_NAME             
                                          ) AS RowNum,(SELECT COUNT(*) FROM CTE1) AS QUERY_COUNT
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