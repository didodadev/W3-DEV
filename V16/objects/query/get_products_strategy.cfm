<!---Egemen Ates o9.07.2012 işlem uygulandı. --->
<cfif basket_prod_list.PRODUCT_SELECT_TYPE neq 13 and isDefined("attributes.company_id") and len(attributes.company_id)>
	<cfquery name="GET_COMP_CAT" datasource="#DSN#">
		SELECT COMPANYCAT_ID FROM COMPANY WHERE COMPANY_ID = #attributes.company_id#
	</cfquery>
</cfif>
<cfquery name="PRODUCTS" datasource="#DSN3#">
WITH CTE1 AS (
SELECT
	T1.*,
	GS_STRATEGY.MINIMUM_STOCK ,GS_STRATEGY.MAXIMUM_STOCK,GS_STRATEGY.REPEAT_STOCK_VALUE
FROM	
	(SELECT  
		GS.PRODUCT_STOCK, 
		STOCKS.STOCK_ID,
		STOCKS.PRODUCT_ID,
		STOCKS.STOCK_CODE,
		STOCKS.STOCK_CODE_2,
		STOCKS.PROPERTY,
		STOCKS.BARCOD,
		STOCKS.IS_INVENTORY,
		STOCKS.IS_PRODUCTION,
		STOCKS.PRODUCT_NAME,
		STOCKS.PRODUCT_CODE,
        STOCKS.STOCK_CODE_2 PRODUCT_CODE_2,
		<cfif isdefined('attributes.is_sale_product') and attributes.is_sale_product eq 0>
			STOCKS.TAX_PURCHASE AS TAX,
		<cfelse>
			STOCKS.TAX AS TAX,
		</cfif>
		STOCKS.OTV,
		STOCKS.PRODUCT_CATID,
		STOCKS.IS_SERIAL_NO,
		STOCKS.MANUFACT_CODE,
	<cfif attributes.price_catid gt 0>
		<cfif basket_prod_list.PRODUCT_SELECT_TYPE neq 13 and isDefined("attributes.company_id") and len(attributes.company_id)>
			PRICE_CAT.COMPANY_CAT,
		</cfif>
		PRICE.PRICE,
		PRICE.MONEY,
		PRICE.PRICE_CATID,
		PRICE.CATALOG_ID,
	<cfelse>
		PRICE_STANDART.PRICE,
		<cfif session.ep.period_year lt 2009>
			CASE WHEN PRICE_STANDART.MONEY ='TL' THEN '<cfoutput>#session.ep.money#</cfoutput>' ELSE PRICE_STANDART.MONEY END AS MONEY,
		<cfelse>
			PRICE_STANDART.MONEY,
		</cfif> 
		-1 AS PRICE_CATID,
		'' AS CATALOG_ID,
	</cfif>			
		PRODUCT_UNIT.ADD_UNIT,
		PRODUCT_UNIT.UNIT_ID,
		PRODUCT_UNIT.PRODUCT_UNIT_ID,
		PRODUCT_UNIT.MAIN_UNIT,
	<cfif len(evaluate("attributes.company_id"))>
		CPP.DISCOUNT1,
		CPP.DISCOUNT2,
		CPP.DISCOUNT3,
		CPP.DISCOUNT4,
		CPP.DISCOUNT5,
		CPP.PAYMETHOD_ID,
		CPP.DELIVERY_DATENO,
		CPP.COMPANY_ID,
		CPP.CONTRACT_ID,
	<cfelse>
		0 AS DISCOUNT1,
		0 AS DISCOUNT2,
		0 AS DISCOUNT3,
		0 AS DISCOUNT4,
		0 AS DISCOUNT5,
		-100 AS PAYMETHOD_ID,
		0 AS DELIVERY_DATENO,		
		STOCKS.COMPANY_ID,
		-1 AS CONTRACT_ID,		
	</cfif>
		PRODUCT_UNIT.MULTIPLIER
	<cfif basket_prod_list.PRODUCT_SELECT_TYPE eq 7>
		,GS.SPECT_VAR_ID
	</cfif>	
	FROM
		PRODUCT_CAT,
		STOCKS
		<cfif basket_prod_list.PRODUCT_SELECT_TYPE eq 7>
		LEFT JOIN #new_dsn2#.GET_STOCK_SPECT GS ON GS.STOCK_ID = STOCKS.STOCK_ID  
		<cfelse>
		LEFT JOIN #new_dsn2#.GET_STOCK GS ON GS.STOCK_ID = STOCKS.STOCK_ID
		</cfif>
		,PRODUCT_UNIT,
	<cfif len(evaluate("attributes.company_id"))>CONTRACT_PURCHASE_PROD_DISCOUNT CPP,</cfif>
	<cfif attributes.price_catid gt 0>
		PRICE, PRICE_CAT
	<cfelse>
		PRICE_STANDART
	</cfif>			
	WHERE
	<cfif len(evaluate("attributes.company_id"))>CPP.PRODUCT_ID = STOCKS.PRODUCT_ID AND</cfif>
		STOCKS.PRODUCT_STATUS = 1 AND
		STOCKS.STOCK_STATUS = 1 AND
		PRODUCT_UNIT.PRODUCT_ID = STOCKS.PRODUCT_ID AND 
		PRODUCT_UNIT.PRODUCT_UNIT_STATUS = 1 AND 		
		PRODUCT_CAT.PRODUCT_CATID = STOCKS.PRODUCT_CATID AND
		PRODUCT_UNIT.IS_MAIN =1 
	<cfif attributes.price_catid gt 0 and basket_prod_list.PRODUCT_SELECT_TYPE neq 13 and isDefined("attributes.company_id") and len(attributes.company_id)>
		AND PRICE_CAT.COMPANY_CAT LIKE '%,#get_comp_cat.companycat_id#,%'
	</cfif>
    <cfif len(attributes.product_name)>
		AND STOCKS.PRODUCT_NAME LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.product_name#%">
	</cfif>
    <cfif len(attributes.stock_code)>
		AND STOCKS.STOCK_CODE LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.stock_code#%">
	</cfif>
    <cfif len(attributes.stock_code2)>
       AND STOCKS.STOCK_CODE_2 LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.stock_code2#%">
    </cfif>
     <cfif len(attributes.barcod)>
		AND STOCKS.BARCOD LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.barcod#%">
	</cfif>
	<cfif not isdefined('attributes.is_condition_sale_or_purchase')><!--- alış veya satış olsada bu deger geldi ise urunlerin alış veya satışlarına bakmaz --->
		<cfif not isdefined("attributes.sepet_process_type") or not listfind('73,74,75,76,77,80,81,811,761,82,84,86,87,140,141',attributes.sepet_process_type,',')>
		AND STOCKS.IS_PURCHASE=1 
		</cfif>
	</cfif>
	<cfif attributes.price_catid lt 0>
		AND PRICE_STANDART.PRICESTANDART_STATUS = 1			
	</cfif>
	<cfif attributes.price_catid gt 0><!--- dinamik bir fiyat kategorisi istenmisse --->
		AND PRICE_CAT.PRICE_CATID = #attributes.price_catid#			
		AND	PRICE_CAT.PRICE_CAT_STATUS = 1
		AND PRICE.PRODUCT_ID = STOCKS.PRODUCT_ID
		AND	PRICE_CAT.PRICE_CATID = PRICE.PRICE_CATID
		AND PRICE.STARTDATE <= #now()#
		AND (PRICE.FINISHDATE >= #now()# OR PRICE.FINISHDATE IS NULL)
		AND PRICE.UNIT = PRODUCT_UNIT.PRODUCT_UNIT_ID
		AND PRICE.UNIT = STOCKS.PRODUCT_UNIT_ID
	<cfelseif attributes.price_catid eq '-1'><!--- Standart alis Fiyatlari Default Gelsin --->
		AND PRICE_STANDART.PURCHASESALES = 0
		AND PRICE_STANDART.PRODUCT_ID = STOCKS.PRODUCT_ID
		AND PRODUCT_UNIT.PRODUCT_UNIT_ID = PRICE_STANDART.UNIT_ID
	<cfelse>
		AND PRICE_STANDART.PURCHASESALES = 0
		AND PRICE_STANDART.PRODUCT_ID = STOCKS.PRODUCT_ID
		AND PRODUCT_UNIT.PRODUCT_UNIT_ID = PRICE_STANDART.UNIT_ID
	</cfif>
	<cfif len(attributes.company_id)>
		AND CPP.COMPANY_ID = #attributes.company_id#
	</cfif>
	<cfif len(attributes.product_cat) and len(attributes.product_catid)>
		AND STOCKS.PRODUCT_CATID = #attributes.product_catid#
	</cfif>
	<cfif len(attributes.employee) and len(attributes.pos_code)>
		AND STOCKS.PRODUCT_MANAGER=#attributes.pos_code#
	</cfif>
	<cfif len(attributes.get_company) and len(attributes.get_company_id)> <!--- tedarikci --->
		AND STOCKS.COMPANY_ID = #attributes.get_company_id#
	</cfif>
	<cfif len(attributes.brand_id) and len(attributes.brand_name)>
		AND STOCKS.BRAND_ID = #attributes.brand_id#
	</cfif>
	<cfif isdefined("attributes.list_property_id") and len(attributes.list_property_id) and len(attributes.list_variation_id)>
		AND STOCKS.PRODUCT_ID IN
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
	<cfif isDefined("attributes.manufact_code") and len(attributes.manufact_code)>
		AND	STOCKS.MANUFACT_CODE LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.manufact_code#%">
	</cfif>
	<cfif isdefined("sepet_process_type") and not listfind('591,140',sepet_process_type,',')>
			<cfif ListFind("52,53,54,55,59,62,70,71,73,74,75,76,78,80,81,86,114,-1",sepet_process_type)>
				AND STOCKS.IS_INVENTORY = 1
			<cfelseif ListFind("60,601",sepet_process_type)>
				AND STOCKS.IS_INVENTORY = 0
			</cfif>
		</cfif>
	) AS T1
	LEFT JOIN
			#new_dsn2#.GET_STOCK_STRATEGY GS_STRATEGY
			ON 
			   GS_STRATEGY.STOCK_ID=T1.STOCK_ID AND GS_STRATEGY.DEPARTMENT_ID IS NULL
	<cfif isdefined('attributes.stock_strategy_type') and len(attributes.stock_strategy_type)>
	WHERE
		<cfif isdefined('attributes.stock_strategy_type') and attributes.stock_strategy_type eq 1><!--- Tanımsız --->
		GS_STRATEGY.MAXIMUM_STOCK IS NULL AND GS_STRATEGY.MAXIMUM_STOCK IS NULL AND GS_STRATEGY.REPEAT_STOCK_VALUE IS NULL
		<cfelseif isdefined('attributes.stock_strategy_type') and attributes.stock_strategy_type eq 2><!--- Fazla Stok --->
		T1.PRODUCT_STOCK <> 0 AND T1.PRODUCT_STOCK >= GS_STRATEGY.MAXIMUM_STOCK
		<cfelseif isdefined('attributes.stock_strategy_type') and attributes.stock_strategy_type eq 3><!--- Sipariş Ver --->
		T1.PRODUCT_STOCK <> 0 AND T1.PRODUCT_STOCK <= GS_STRATEGY.REPEAT_STOCK_VALUE and T1.PRODUCT_STOCK > GS_STRATEGY.MINIMUM_STOCK
		<cfelseif isdefined('attributes.stock_strategy_type') and attributes.stock_strategy_type eq 4><!--- Yeterli Stok --->
		T1.PRODUCT_STOCK < GS_STRATEGY.MAXIMUM_STOCK AND T1.PRODUCT_STOCK > GS_STRATEGY.REPEAT_STOCK_VALUE
		<cfelseif isdefined('attributes.stock_strategy_type') and attributes.stock_strategy_type eq 5><!--- Yetersiz Stok --->
		T1.PRODUCT_STOCK <> 0 AND T1.PRODUCT_STOCK <= GS_STRATEGY.MINIMUM_STOCK
		</cfif>
	</cfif>
<cfif len(attributes.company_id)>
UNION	
	SELECT
		T2.*,GS_STRATEGY.MINIMUM_STOCK,GS_STRATEGY.MAXIMUM_STOCK,GS_STRATEGY.REPEAT_STOCK_VALUE
	FROM
		(	
		SELECT  
			GS.PRODUCT_STOCK, 
			STOCKS.STOCK_ID,
			STOCKS.PRODUCT_ID,
			STOCKS.STOCK_CODE,
			STOCKS.STOCK_CODE_2,
			STOCKS.PROPERTY,
			STOCKS.BARCOD,
			STOCKS.IS_INVENTORY,
			STOCKS.IS_PRODUCTION,
			STOCKS.PRODUCT_NAME,
			STOCKS.PRODUCT_CODE,
            STOCKS.STOCK_CODE_2 PRODUCT_CODE_2,				
			STOCKS.TAX_PURCHASE AS TAX,
			STOCKS.OTV,
			STOCKS.PRODUCT_CATID,
			STOCKS.IS_SERIAL_NO,
			STOCKS.MANUFACT_CODE,
		<cfif attributes.price_catid gt 0>
			<cfif basket_prod_list.PRODUCT_SELECT_TYPE neq 13 and isDefined("attributes.company_id") and len(attributes.company_id)>
				PRICE_CAT.COMPANY_CAT,
			</cfif>
			PRICE.PRICE,
			PRICE.MONEY,
			PRICE.PRICE_CATID,
			PRICE.CATALOG_ID,
		<cfelse>
			PRICE_STANDART.PRICE,
		<cfif session.ep.period_year lt 2009>
			CASE WHEN PRICE_STANDART.MONEY ='TL' THEN '<cfoutput>#session.ep.money#</cfoutput>' ELSE PRICE_STANDART.MONEY END AS MONEY,
		<cfelse>
			PRICE_STANDART.MONEY,
		</cfif> 
			-1 AS PRICE_CATID,
			'' AS CATALOG_ID,
		</cfif>			
			PRODUCT_UNIT.ADD_UNIT,
			PRODUCT_UNIT.UNIT_ID,
			PRODUCT_UNIT.PRODUCT_UNIT_ID,
			PRODUCT_UNIT.MAIN_UNIT,
			PRODUCT_UNIT.MULTIPLIER,
			0 AS DISCOUNT1,
			0 AS DISCOUNT2,
			0 AS DISCOUNT3,
			0 AS DISCOUNT4,
			0 AS DISCOUNT5,
			-100 AS PAYMETHOD_ID,
			0 AS DELIVERY_DATENO,		
			STOCKS.COMPANY_ID,
			-1 AS CONTRACT_ID
			<cfif basket_prod_list.PRODUCT_SELECT_TYPE eq 7>
			,GS.SPECT_VAR_ID
			</cfif>	
		FROM
			PRODUCT_CAT,
			STOCKS,
			<cfif basket_prod_list.PRODUCT_SELECT_TYPE eq 7>
			#new_dsn2#.GET_STOCK_SPECT GS,
			<cfelse>
			#new_dsn2#.GET_STOCK GS,
			</cfif>
			PRODUCT_UNIT,
		<cfif attributes.price_catid gt 0>
			PRICE,PRICE_CAT
		<cfelse>
			PRICE_STANDART
		</cfif>			
		WHERE
			STOCKS.PRODUCT_STATUS = 1 AND
			STOCKS.STOCK_STATUS = 1 AND
			PRODUCT_UNIT.PRODUCT_ID = STOCKS.PRODUCT_ID AND 
			PRODUCT_UNIT.PRODUCT_UNIT_STATUS = 1 AND 
			GS.STOCK_ID = STOCKS.STOCK_ID AND 
			PRODUCT_CAT.PRODUCT_CATID = STOCKS.PRODUCT_CATID AND 
			PRODUCT_UNIT.IS_MAIN =1
	
		<cfif attributes.price_catid gt 0 and basket_prod_list.PRODUCT_SELECT_TYPE neq 13 and isDefined("attributes.company_id") and len(attributes.company_id)>
			AND PRICE_CAT.COMPANY_CAT LIKE '%,#get_comp_cat.companycat_id#,%'
		</cfif>
        <cfif len(attributes.product_name)>
		    AND STOCKS.PRODUCT_NAME LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.product_name#%"> 
     	</cfif>
        <cfif len(attributes.stock_code)>
		   AND STOCKS.STOCK_CODE LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.stock_code#%">
	    </cfif>
        <cfif len(attributes.stock_code2)>
		   AND STOCKS.STOCK_CODE_2 LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.stock_code2#%">
	    </cfif>
        <cfif len(attributes.barcod)>
            AND STOCKS.BARCOD LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.barcod#%">
        </cfif>
		<cfif not isdefined('attributes.is_condition_sale_or_purchase')><!--- alış veya satış olsada bu deger geldi ise urunlerin alış veya satışlarına bakmaz --->
			<cfif not isdefined("attributes.sepet_process_type") or not listfind('73,74,75,76,77,80,81,811,761,82,84,86,87',attributes.sepet_process_type,',')>
				AND STOCKS.IS_PURCHASE=1
			</cfif>
		</cfif>
		<cfif attributes.price_catid lt 0>
			AND PRICE_STANDART.PRICESTANDART_STATUS = 1			
		</cfif>
		<cfif isdefined("attributes.list_property_id") and len(attributes.list_property_id) and len(attributes.list_variation_id)>
			AND STOCKS.PRODUCT_ID IN
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
		<cfif attributes.price_catid gt 0><!--- dinamik bir fiyat kategorisi istenmisse --->
			AND PRICE_CAT.PRICE_CATID = #attributes.price_catid#			
			AND	PRICE_CAT.PRICE_CAT_STATUS = 1
			AND PRICE.PRODUCT_ID = STOCKS.PRODUCT_ID
			AND	PRICE_CAT.PRICE_CATID = PRICE.PRICE_CATID
			AND PRICE.STARTDATE <= #now()#
			AND (PRICE.FINISHDATE >= #now()# OR PRICE.FINISHDATE IS NULL)
			AND PRICE.UNIT = PRODUCT_UNIT.PRODUCT_UNIT_ID
			AND PRICE.UNIT = STOCKS.PRODUCT_UNIT_ID
		<cfelseif attributes.price_catid eq '-1'><!--- Standart alis Fiyatlari Default Gelsin --->
			AND PRICE_STANDART.PURCHASESALES = 0
			AND PRICE_STANDART.PRODUCT_ID = STOCKS.PRODUCT_ID
			AND PRODUCT_UNIT.PRODUCT_UNIT_ID = PRICE_STANDART.UNIT_ID
		<cfelse>
			AND PRICE_STANDART.PURCHASESALES = 0
			AND PRICE_STANDART.PRODUCT_ID = STOCKS.PRODUCT_ID
			AND PRODUCT_UNIT.PRODUCT_UNIT_ID = PRICE_STANDART.UNIT_ID
		</cfif>
		AND STOCKS.PRODUCT_ID NOT IN (
				SELECT 
					DISTINCT PRODUCT_ID
				FROM 			
					CONTRACT_PURCHASE_PROD_DISCOUNT
				<cfif len(attributes.company_id)>
				WHERE
					COMPANY_ID =  #attributes.company_id#
				</cfif>
			)
		<cfif isDefined("attributes.product_cat_code") and len(attributes.product_cat_code)>
			AND STOCKS.PRODUCT_CODE LIKE '#attributes.product_cat_code#.%'
		</cfif>
		<cfif len(attributes.brand_id) and len(attributes.brand_name)>
			AND STOCKS.BRAND_ID = #attributes.brand_id#
		</cfif>
		<cfif isDefined("attributes.manufact_code") and len(attributes.manufact_code)>
			AND	STOCKS.MANUFACT_CODE LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.manufact_code#%">
		</cfif>
		<cfif len(attributes.get_company) and len(attributes.get_company_id)> <!--- tedarikci --->
			AND STOCKS.COMPANY_ID = #attributes.get_company_id#
		</cfif>
        <cfif len(attributes.employee) and len(attributes.pos_code)>
		   AND STOCKS.PRODUCT_MANAGER=#attributes.pos_code#
        </cfif>
		<cfif isdefined("sepet_process_type") and not listfind('591,140',sepet_process_type,',')>
			<cfif ListFind("52,53,54,55,59,62,70,71,73,74,75,76,78,80,81,86,114,-1",sepet_process_type)>
				AND STOCKS.IS_INVENTORY = 1
			<cfelseif ListFind("60,601",sepet_process_type)>
				AND STOCKS.IS_INVENTORY = 0
			</cfif>
		</cfif>
	) AS T2
	LEFT JOIN
       #new_dsn2#.GET_STOCK_STRATEGY GS_STRATEGY
        ON 
			GS_STRATEGY.STOCK_ID=T2.STOCK_ID AND GS_STRATEGY.DEPARTMENT_ID IS NULL
		<cfif isdefined('attributes.stock_strategy_type') and len(attributes.stock_strategy_type)>
			WHERE
				<cfif isdefined('attributes.stock_strategy_type') and attributes.stock_strategy_type eq 1><!--- Tanımsız --->
				GS_STRATEGY.MAXIMUM_STOCK IS NULL AND GS_STRATEGY.MAXIMUM_STOCK IS NULL AND GS_STRATEGY.REPEAT_STOCK_VALUE IS NULL
				<cfelseif isdefined('attributes.stock_strategy_type') and attributes.stock_strategy_type eq 2><!--- Fazla Stok --->
				GS_STRATEGY.MAXIMUM_STOCK <> 0 AND T2.PRODUCT_STOCK >= GS_STRATEGY.MAXIMUM_STOCK
				<cfelseif isdefined('attributes.stock_strategy_type') and attributes.stock_strategy_type eq 3><!--- Sipariş Ver --->
				T2.PRODUCT_STOCK <= GS_STRATEGY.REPEAT_STOCK_VALUE and T2.PRODUCT_STOCK > GS_STRATEGY.MINIMUM_STOCK
				<cfelseif isdefined('attributes.stock_strategy_type') and attributes.stock_strategy_type eq 4><!--- Yeterli Stok --->
				T2.PRODUCT_STOCK < GS_STRATEGY.MAXIMUM_STOCK AND T2.PRODUCT_STOCK > GS_STRATEGY.REPEAT_STOCK_VALUE
				<cfelseif isdefined('attributes.stock_strategy_type') and attributes.stock_strategy_type eq 5><!--- Yetersiz Stok --->
				GS_STRATEGY.MINIMUM_STOCK <> 0 AND T2.PRODUCT_STOCK <= GS_STRATEGY.MINIMUM_STOCK
				</cfif>
		</cfif>

</cfif>	
),
CTE2 AS (
		SELECT
			CTE1.*,
			ROW_NUMBER() OVER (
								<cfif isdefined('attributes.sort_type') and attributes.sort_type eq 0>
									ORDER BY PRODUCT_NAME, PROPERTY
								<cfelseif isdefined('attributes.sort_type') and attributes.sort_type eq 1>
									ORDER BY STOCK_CODE asc
								<cfelse>
									ORDER BY STOCK_CODE_2, PRODUCT_NAME
								</cfif>
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
