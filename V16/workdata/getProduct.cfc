<cfcomponent>
	<cfset dsn = application.systemParam.systemParam().dsn>
    <cffunction name="getCompenentFunction">
		<cfif isdefined('session.ep')>
			<cfset dat_src = "#dsn#_#session.ep.company_id#">
		<cfelseif isdefined('session.pp.userid')>
			<cfset dat_src = "#dsn#_#session.pp.our_company_id#">
		<cfelseif isdefined('session.ww')>
			<cfset dat_src = "#dsn#_#session.ww.our_company_id#">
		</cfif>
        <cfquery name="getProduct_" datasource="#dat_src#">
			SELECT
				STOCKS.TAX_PURCHASE,
				STOCKS.TAX,
				STOCKS.IS_PRODUCTION,
				STOCKS.STOCK_ID,
				STOCKS.PRODUCT_ID,
				STOCKS.PROPERTY,
				STOCKS.STOCK_CODE,
				STOCKS.STOCK_CODE_2,
				STOCKS.PRODUCT_UNIT_ID,
				STOCKS.PRODUCT_NAME,
				STOCKS.COMPANY_ID,
				STOCKS.IS_SERIAL_NO,
				STOCKS.BARCOD,
				PRODUCT_UNIT.MAIN_UNIT,
				PRODUCT_UNIT.MAIN_UNIT_ID,
				PRODUCT_CAT.PROFIT_MARGIN,
				PRODUCT.IS_INTERNET,
				PRODUCT.IS_EXTRANET,
				C.FULLNAME
			FROM
				PRODUCT_CAT,
				PRODUCT,
				STOCKS,
				PRODUCT_UNIT,
				#dsn#.COMPANY C
			  <cfif isDefined("attributes.barcod") and len(attributes.barcod)>			
				,STOCKS_BARCODES
			  </cfif>
			WHERE
				STOCKS.PRODUCT_ID = PRODUCT.PRODUCT_ID AND 
				STOCKS.PRODUCT_STATUS = 1 AND
				STOCKS.PRODUCT_CATID = PRODUCT_CAT.PRODUCT_CATID AND
				PRODUCT_UNIT.PRODUCT_ID = STOCKS.PRODUCT_ID AND
				PRODUCT_UNIT.IS_MAIN = 1 AND
				STOCKS.COMPANY_ID IS NOT NULL AND
				STOCKS.COMPANY_ID = C.COMPANY_ID
			<cfif isdefined("attributes.from_promotion")>
				AND STOCKS.IS_SALES = 1
			</cfif>
			<cfif isdefined("attributes.is_hizmet") and (attributes.is_hizmet eq 1)>
				AND STOCKS.IS_INVENTORY = 0
			</cfif>	
			<cfif isDefined("attributes.product_cat") and len(attributes.product_cat) and isDefined("attributes.product_cat_code") and len(attributes.product_cat_code)>
				AND STOCKS.STOCK_CODE LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="'#PRODUCT_CAT_CODE#%'">
			</cfif>
			<cfif isDefined("arguments.keyword") and len(arguments.keyword)>
				AND
				(
				<cfif listlen(arguments.keyword,"+") gt 1>
					(
						<cfloop from="1" to="#listlen(arguments.keyword,'+')#" index="pro_index">
							STOCKS.PRODUCT_NAME LIKE '%#ListGetAt(arguments.keyword,pro_index,"+")#%' 
							<cfif pro_index neq listlen(arguments.keyword,'+')>AND</cfif>
						</cfloop>
					)	
				<cfelse>
					STOCKS.PRODUCT_NAME LIKE '<cfif len(arguments.keyword) gt 3>%</cfif>#arguments.keyword#%'
				</cfif>
					OR STOCKS.STOCK_CODE_2 LIKE '<cfif len(arguments.keyword) gt 3>%</cfif>#arguments.keyword#%'
					OR STOCKS.STOCK_CODE LIKE '<cfif len(arguments.keyword) gt 3>%</cfif>#arguments.keyword#%'
					OR STOCKS.MANUFACT_CODE LIKE '<cfif len(arguments.keyword) gt 3>%</cfif>#arguments.keyword#%'
				)
			</cfif>
			<cfif isDefined("attributes.barcod") and len(attributes.barcod)>
				AND STOCKS_BARCODES.STOCK_ID = STOCKS.STOCK_ID
				AND STOCKS_BARCODES.BARCODE = <cfqueryparam cfsqltype="cf_sql_varchar" value="'#attributes.barcod#'">
			</cfif>
			
			<cfif isdefined("attributes.is_only_alternative") and isdefined("attributes.alternative_product") and len(attributes.alternative_product)><!--- sadece alternatif ürünleri gelmesi için --->
				AND
				(
					STOCKS.PRODUCT_ID IN (SELECT ALTERNATIVE_PRODUCT_ID FROM ALTERNATIVE_PRODUCTS WHERE PRODUCT_ID=<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.alternative_product#"> <cfif isdefined('attributes.tree_stock_id')>AND TREE_STOCK_ID =<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.tree_stock_id#"> </cfif>)
					OR STOCKS.PRODUCT_ID IN (SELECT PRODUCT_ID FROM ALTERNATIVE_PRODUCTS WHERE ALTERNATIVE_PRODUCT_ID=<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.alternative_product#">)<!--- <cfif isdefined('attributes.tree_stock_id')>AND TREE_STOCK_ID =#attributes.tree_stock_id# </cfif> --->
				)
				AND STOCKS.PRODUCT_ID NOT IN (SELECT PRODUCT_ID FROM ALTERNATIVE_PRODUCTS_EXCEPT WHERE ALTERNATIVE_PRODUCT_ID=<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.alternative_product#">)
			</cfif>	
			<cfif isdefined("attributes.is_store_module")>
				<cfif isdefined('session.ep.userid')>
					AND STOCKS.PRODUCT_ID IN (SELECT PRODUCT_ID FROM #dsn1_alias#.PRODUCT_BRANCH WHERE BRANCH_ID IN(SELECT BRANCH_ID FROM #dsn_alias#.EMPLOYEE_POSITION_BRANCHES WHERE POSITION_CODE = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.position_code#">))
				<cfelseif isdefined('session.pp.userid')>
					AND STOCKS.PRODUCT_ID IN (SELECT PRODUCT_ID FROM #dsn1_alias#.PRODUCT_BRANCH WHERE BRANCH_ID IN(SELECT BRANCH_ID FROM #dsn_alias#.BRANCH WHERE COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.pp.our_company_id#">))
				</cfif>	
			</cfif>
		UNION ALL
		SELECT
				STOCKS.TAX_PURCHASE,
				STOCKS.TAX,
				STOCKS.IS_PRODUCTION,
				STOCKS.STOCK_ID,
				STOCKS.PRODUCT_ID,
				STOCKS.PROPERTY,
				STOCKS.STOCK_CODE,
				STOCKS.STOCK_CODE_2,
				STOCKS.PRODUCT_UNIT_ID,
				STOCKS.PRODUCT_NAME,
				STOCKS.COMPANY_ID,
				STOCKS.IS_SERIAL_NO,
				STOCKS.BARCOD,
				PRODUCT_UNIT.MAIN_UNIT,
				PRODUCT_UNIT.MAIN_UNIT_ID,
				PRODUCT_CAT.PROFIT_MARGIN,
				PRODUCT.IS_INTERNET,
				PRODUCT.IS_EXTRANET,
				'' FULLNAME
			FROM
				PRODUCT_CAT,
				PRODUCT,
				STOCKS,
				PRODUCT_UNIT
			  <cfif isDefined("attributes.barcod") and len(attributes.barcod)>			
				,STOCKS_BARCODES
			  </cfif>
			WHERE
				STOCKS.PRODUCT_ID = PRODUCT.PRODUCT_ID AND 
				STOCKS.PRODUCT_STATUS = 1 AND
				STOCKS.PRODUCT_CATID = PRODUCT_CAT.PRODUCT_CATID AND
				PRODUCT_UNIT.PRODUCT_ID = STOCKS.PRODUCT_ID AND
				PRODUCT_UNIT.IS_MAIN = 1 AND
				STOCKS.COMPANY_ID IS NULL
			<cfif isdefined("attributes.from_promotion")>
				AND STOCKS.IS_SALES = 1
			</cfif>
			<cfif isdefined("attributes.is_hizmet") and (attributes.is_hizmet eq 1)>
				AND STOCKS.IS_INVENTORY = 0
			</cfif>	
			<cfif isDefined("attributes.product_cat") and len(attributes.product_cat) and isDefined("attributes.product_cat_code") and len(attributes.product_cat_code)>
				AND STOCKS.STOCK_CODE LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="'#PRODUCT_CAT_CODE#%'">
			</cfif>
			<cfif isDefined("arguments.keyword") and len(arguments.keyword)>
				AND
				(
				<cfif listlen(arguments.keyword,"+") gt 1>
					(
						<cfloop from="1" to="#listlen(arguments.keyword,'+')#" index="pro_index">
							STOCKS.PRODUCT_NAME LIKE '%#ListGetAt(arguments.keyword,pro_index,"+")#%' 
							<cfif pro_index neq listlen(arguments.keyword,'+')>AND</cfif>
						</cfloop>
					)	
				<cfelse>
					STOCKS.PRODUCT_NAME LIKE '<cfif len(arguments.keyword) gt 3>%</cfif>#arguments.keyword#%'
				</cfif>
					OR STOCKS.STOCK_CODE_2 LIKE '<cfif len(arguments.keyword) gt 3>%</cfif>#arguments.keyword#%'
					OR STOCKS.STOCK_CODE LIKE '<cfif len(arguments.keyword) gt 3>%</cfif>#arguments.keyword#%'
					OR STOCKS.MANUFACT_CODE LIKE '<cfif len(arguments.keyword) gt 3>%</cfif>#arguments.keyword#%'
				)
			</cfif>
			<cfif isDefined("attributes.barcod") and len(attributes.barcod)>
				AND STOCKS_BARCODES.STOCK_ID = STOCKS.STOCK_ID
				AND STOCKS_BARCODES.BARCODE = <cfqueryparam cfsqltype="cf_sql_varchar" value="'#attributes.barcod#'">
			</cfif>
			
			<cfif isdefined("attributes.is_only_alternative") and isdefined("attributes.alternative_product") and len(attributes.alternative_product)><!--- sadece alternatif ürünleri gelmesi için --->
				AND
				(
					STOCKS.PRODUCT_ID IN (SELECT ALTERNATIVE_PRODUCT_ID FROM ALTERNATIVE_PRODUCTS WHERE PRODUCT_ID=<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.alternative_product#"> <cfif isdefined('attributes.tree_stock_id')>AND TREE_STOCK_ID =<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.tree_stock_id#"> </cfif>)
					OR STOCKS.PRODUCT_ID IN (SELECT PRODUCT_ID FROM ALTERNATIVE_PRODUCTS WHERE ALTERNATIVE_PRODUCT_ID=<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.alternative_product#">)<!--- <cfif isdefined('attributes.tree_stock_id')>AND TREE_STOCK_ID =#attributes.tree_stock_id# </cfif> --->
				)
				AND STOCKS.PRODUCT_ID NOT IN (SELECT PRODUCT_ID FROM ALTERNATIVE_PRODUCTS_EXCEPT WHERE ALTERNATIVE_PRODUCT_ID=<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.alternative_product#">)
			</cfif>	
			<cfif isdefined("attributes.is_store_module")>
				<cfif isdefined('session.ep.userid')>
					AND STOCKS.PRODUCT_ID IN (SELECT PRODUCT_ID FROM #dsn1_alias#.PRODUCT_BRANCH WHERE BRANCH_ID IN(SELECT BRANCH_ID FROM #dsn_alias#.EMPLOYEE_POSITION_BRANCHES WHERE POSITION_CODE = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.position_code#">))
				<cfelseif isdefined('session.pp.userid')>
					AND STOCKS.PRODUCT_ID IN (SELECT PRODUCT_ID FROM #dsn1_alias#.PRODUCT_BRANCH WHERE BRANCH_ID IN(SELECT BRANCH_ID FROM #dsn_alias#.BRANCH WHERE COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.pp.our_company_id#">))
				</cfif>	
			</cfif>
			ORDER BY
				STOCKS.PRODUCT_NAME,
				STOCKS.PROPERTY
        </cfquery>
        <cfreturn getProduct_>
    </cffunction>
</cfcomponent>

