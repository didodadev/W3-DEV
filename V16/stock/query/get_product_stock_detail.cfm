<cfif isDefined("attributes.pid")>
	<cfquery name="GET_STOCK_GRAPH" datasource="#dsn2#">
	SELECT 
		SUM(PRODUCT_STOCK) AS PRODUCT_TOTAL_STOCK,
		DEPARTMENT_HEAD,
		STORE
	FROM
		GET_STOCK_LOCATION_TOTAL,
		#DSN#.DEPARTMENT
	WHERE
		PRODUCT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.pid#">
		AND
		DEPARTMENT.DEPARTMENT_ID=GET_STOCK_LOCATION_TOTAL.STORE
	GROUP BY
		STORE,
		DEPARTMENT_HEAD
	</cfquery>
	
</cfif>
