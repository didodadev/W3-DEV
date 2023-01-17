<cfset dsn = application.systemParam.systemParam().dsn>
<cffunction name="get_product_fnc" returntype="query">
	<cfargument name="keyword" default="">
	<cfargument name="department_id" default="">
	<cfargument name="employee_id" default="">
	<cfargument name="company_id" default="">
	<cfargument name="employee" default="">
	<cfargument name="company" default="">
	<cfargument name="search_product_catid" default="">
	<cfargument name="product_id" default="">
	<cfargument name="sort_type" default="">
	<cfargument name="product_cat" default="">
	<cfargument name="product_name" default="">
	<cfargument name="cost_date" default="">
	<cfargument name="list_type" default="">
	<cfargument name="sql_unicode_func" default="">
	<cfargument name="startrow" default="">
	<cfargument name="maxrows" default="">
	<cfquery name="GET_PRODUCT" datasource="#this.DSN3#">
		WITH CTE1 AS (
		SELECT 
			P.PRODUCT_ID,
			P.PRODUCT_NAME,
			P.PRODUCT_CODE_2,
			S.STOCK_ID, 
			S.STOCK_CODE,
			S.BARCOD, 
			S.PROPERTY, 
			PU.MAIN_UNIT,
			SUM(SR.STOCK_IN - SR.STOCK_OUT) TOTAL_STK
			<cfif isdefined("arguments.list_type") and arguments.list_type eq 1>
				,ISNULL(SR.SPECT_VAR_ID,0) SPECT_VAR_ID
			</cfif>
		FROM 
			PRODUCT P, 
			STOCKS S, 
			PRODUCT_UNIT PU, 
			#this.dsn2_alias#.STOCKS_ROW SR
		WHERE
			SR.STOCK_ID = S.STOCK_ID AND
			P.PRODUCT_STATUS = 1 AND 
			P.IS_INVENTORY = 1 AND 
			P.PRODUCT_ID = S.PRODUCT_ID AND
			P.PRODUCT_ID = PU.PRODUCT_ID AND 
			PU.IS_MAIN = 1 AND 
			SR.PROCESS_DATE <= #arguments.cost_date#
		<cfif isDefined("arguments.keyword") and len(arguments.keyword)>
			AND (
				P.PRODUCT_NAME LIKE #sql_unicode_func#'<cfif len(arguments.keyword) gt 2>%</cfif>#arguments.keyword#%' COLLATE SQL_Latin1_General_CP1_CI_AI OR
				S.BARCOD = '#arguments.keyword#' OR 
				S.STOCK_CODE LIKE '<cfif len(arguments.keyword) gt 2>%</cfif>#arguments.keyword#%' COLLATE SQL_Latin1_General_CP1_CI_AI
				)
		</cfif>
		<cfif len(arguments.department_id) and isnumeric(arguments.department_id)>
			AND SR.STORE = #arguments.department_id#
		</cfif>
		<cfif not len(arguments.department_id) or not isnumeric(arguments.department_id)><!--- departman secili degilse sevk halindeki urunler alinmaz --->
			AND SR.PROCESS_TYPE NOT IN (81,811)
		</cfif>
		<cfif len(arguments.employee_id) and isnumeric(arguments.employee_id) and len(arguments.employee)>
			AND P.PRODUCT_MANAGER = #arguments.employee_id#
		</cfif>
		<cfif len(arguments.company_id) and isnumeric(arguments.company_id) and len(arguments.company)>
			AND P.COMPANY_ID = #arguments.company_id#
		</cfif>
		<cfif isDefined("arguments.search_product_catid") and len(arguments.search_product_catid) and len(arguments.product_cat)>
			AND S.STOCK_CODE LIKE '#arguments.search_product_catid#%'
		</cfif>
		<cfif isDefined("arguments.product_id") and len(arguments.product_id) and len(arguments.product_name)>
			AND P.PRODUCT_ID = #arguments.product_id#
		</cfif>
		GROUP BY
			P.PRODUCT_ID,
			P.PRODUCT_NAME,
			P.PRODUCT_CODE_2,
			S.STOCK_ID, 
			S.STOCK_CODE, 
			S.BARCOD, 
			S.PROPERTY, 
			PU.MAIN_UNIT
			<cfif isdefined("arguments.list_type") and arguments.list_type eq 1>
				,SR.SPECT_VAR_ID
			</cfif>),
			CTE2 AS (
				SELECT
					CTE1.*,
					ROW_NUMBER() OVER (	ORDER BY
									<cfif isdefined('arguments.sort_type') and arguments.sort_type eq 0>
										PRODUCT_NAME
									<cfelse>
										STOCK_CODE
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
				RowNum BETWEEN #startrow# and #startrow#+(#maxrows#-1)
	</cfquery>
	<cfreturn GET_PRODUCT>
</cffunction>


<cffunction name="get_product_fnc2" returntype="query">
	<cfargument name="pid" default="">
	<cfquery name="GET_PRODUCT" datasource="#this.DSN3#">
			SELECT 
				P.PRODUCT_STATUS,
				P.PRODUCT_ID,
				#dsn#.Get_Dynamic_Language(P.PRODUCT_ID,'#session.ep.language#','PRODUCT','PRODUCT_NAME',NULL,NULL,P.PRODUCT_NAME) AS PRODUCT_NAME,
				P.PRODUCT_CODE,
				P.PRODUCT_CODE_2,
				P.BARCOD,
				P.SHELF_LIFE,
				P.COMPANY_ID,
				P.PRODUCT_MANAGER,
				P.IS_PRODUCTION,
				PC.PRODUCT_CAT,
				PU.MAIN_UNIT
			FROM 
				PRODUCT P
				LEFT JOIN PRODUCT_CAT PC ON PC.PRODUCT_CATID = P.PRODUCT_CATID,
				PRODUCT_UNIT PU
			WHERE 
				P.PRODUCT_ID = #arguments.pid# AND
				P.PRODUCT_ID = PU.PRODUCT_ID AND 
				PU.IS_MAIN = 1
	</cfquery>
	<cfreturn get_product>
</cffunction>
<cffunction name="get_product_fnc3" returntype="query">
	<cfargument name="keyword" default="">
	<cfargument name="department_id" default="">
	<cfargument name="employee_id" default="">
	<cfargument name="company_id" default="">
	<cfargument name="employee" default="">
	<cfargument name="company" default="">
	<cfargument name="search_product_catid" default="">
	<cfargument name="product_id" default="">
	<cfargument name="sort_type" default="">
	<cfargument name="product_cat" default="">
	<cfargument name="product_name" default="">
	<cfargument name="cost_date" default="">
	<cfargument name="list_type" default="">
	<cfargument name="sql_unicode_func" default="">
	<cfargument name="startrow" default="">
	<cfargument name="maxrows" default="">
	<cfquery name="GET_PRODUCT" datasource="#this.DSN3#">
		SELECT 
			P.PRODUCT_ID,
			P.PRODUCT_NAME,
			P.PRODUCT_CODE_2,
			S.STOCK_ID, 
			S.STOCK_CODE,
			S.BARCOD, 
			S.PROPERTY, 
			PU.MAIN_UNIT,
			SUM(SR.STOCK_IN - SR.STOCK_OUT) TOTAL_STK
			<cfif isdefined("arguments.list_type") and arguments.list_type eq 1>
				,ISNULL(SR.SPECT_VAR_ID,0) SPECT_VAR_ID
			</cfif>
		FROM 
			PRODUCT P, 
			STOCKS S, 
			PRODUCT_UNIT PU, 
			#this.dsn2_alias#.STOCKS_ROW SR
		WHERE
			SR.STOCK_ID = S.STOCK_ID AND
			P.PRODUCT_STATUS = 1 AND 
			P.IS_INVENTORY = 1 AND 
			P.PRODUCT_ID = S.PRODUCT_ID AND
			P.PRODUCT_ID = PU.PRODUCT_ID AND 
			PU.IS_MAIN = 1 AND 
			SR.PROCESS_DATE <= #arguments.cost_date#
		<cfif isDefined("arguments.keyword") and len(arguments.keyword)>
			AND (
				P.PRODUCT_NAME LIKE #sql_unicode_func#'<cfif len(arguments.keyword) gt 2>%</cfif>#arguments.keyword#%' COLLATE SQL_Latin1_General_CP1_CI_AI OR
				S.BARCOD = '#arguments.keyword#' OR 
				S.STOCK_CODE LIKE '<cfif len(arguments.keyword) gt 2>%</cfif>#arguments.keyword#%' COLLATE SQL_Latin1_General_CP1_CI_AI
				)
		</cfif>
		<cfif len(arguments.department_id) and isnumeric(arguments.department_id)>
			AND SR.STORE = #arguments.department_id#
		</cfif>
		<cfif not len(arguments.department_id) or not isnumeric(arguments.department_id)><!--- departman secili degilse sevk halindeki urunler alinmaz --->
			AND SR.PROCESS_TYPE NOT IN (81,811)
		</cfif>
		<cfif len(arguments.employee_id) and isnumeric(arguments.employee_id) and len(arguments.employee)>
			AND P.PRODUCT_MANAGER = #arguments.employee_id#
		</cfif>
		<cfif len(arguments.company_id) and isnumeric(arguments.company_id) and len(arguments.company)>
			AND P.COMPANY_ID = #arguments.company_id#
		</cfif>
		<cfif isDefined("arguments.search_product_catid") and len(arguments.search_product_catid) and len(arguments.product_cat)>
			AND S.STOCK_CODE LIKE '#arguments.search_product_catid#%'
		</cfif>
		<cfif isDefined("arguments.product_id") and len(arguments.product_id) and len(arguments.product_name)>
			AND P.PRODUCT_ID = #arguments.product_id#
		</cfif>
		GROUP BY
			P.PRODUCT_ID,
			P.PRODUCT_NAME,
			P.PRODUCT_CODE_2,
			S.STOCK_ID, 
			S.STOCK_CODE, 
			S.BARCOD, 
			S.PROPERTY, 
			PU.MAIN_UNIT
			<cfif isdefined("arguments.list_type") and arguments.list_type eq 1>
				,SR.SPECT_VAR_ID
			</cfif>
		ORDER BY
			P.PRODUCT_NAME
	</cfquery>
	<cfreturn GET_PRODUCT>
</cffunction>
