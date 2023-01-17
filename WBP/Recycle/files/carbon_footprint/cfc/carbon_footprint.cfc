<cfcomponent>

	<cfset dsn = application.systemParam.systemParam().dsn />
	<cfset dsn2 = "#dsn#_#session.ep.period_year#_#session.ep.company_id#" />
	<cfset dsn3 = "#dsn#_#session.ep.company_id#" />
	<cfset dsn1 = "#dsn#_product" />

	<cfsetting requesttimeout="2000">
	<cffunction name="getCarbonFootprintReport" access="remote" returntype="any">
		<cfargument name = "keyword" default="" required="false">
		<cfargument name = "start_date" default="" required="true">
		<cfargument name = "finish_date" default="" required="true">
		<cfargument name = "page" default = "1">
		<cfargument name = "pageSize" default = "#session.ep.maxrows#">

		<cfquery name="getCarbonFootprintReport" datasource="#DSN#">
			WITH CTE1 AS (
				SELECT
					P.PRODUCT_NAME,
					SUM(IR.AMOUNT) AS TOTAL_AMOUNT,
					P.PURCHASE_CARBON_VALUE AS EMISSION,
					P.PURCHASE_CARBON_VALUE * SUM(IR.AMOUNT) AS TOTAL_EMISSION,
					ROW_NUMBER() OVER (ORDER BY P.PRODUCT_NAME) AS ROWNUM
				FROM
					#dsn2#.INVOICE I
						LEFT JOIN #dsn2#.INVOICE_ROW IR ON IR.INVOICE_ID = I.INVOICE_ID
						LEFT JOIN #dsn1#.STOCKS S ON S.STOCK_ID = IR.STOCK_ID
						LEFT JOIN #dsn1#.PRODUCT P ON P.PRODUCT_ID = S.PRODUCT_ID
				WHERE
					1 = 1
					AND I.PURCHASE_SALES = 0
					AND ISNULL(I.IS_IPTAL,0) = 0
					AND P.PURCHASE_CARBON_VALUE IS NOT NULL
				GROUP BY
					P.PRODUCT_NAME,
					P.PURCHASE_CARBON_VALUE
				HAVING
				P.PURCHASE_CARBON_VALUE * SUM(IR.AMOUNT) <> 0
			)
			SELECT
				*,
				(SELECT SUM(TOTAL_EMISSION) FROM CTE1) AS ALL_TOTAL_EMISSION,
				(SELECT COUNT(*) FROM CTE1) AS TOTALROWS
			FROM
				CTE1
			WHERE
				ROWNUM BETWEEN #(arguments.page - 1) * arguments.pageSize + 1# AND #arguments.page * arguments.pageSize#
			ORDER BY
				ROWNUM
		</cfquery>
		<cfreturn getCarbonFootprintReport />
	</cffunction>
</cfcomponent>