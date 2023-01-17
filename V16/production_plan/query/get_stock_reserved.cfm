<cfif isdefined("attributes.stock_id") and len(attributes.stock_id)>
	<cfquery name='GET_STOCK_RESERVED_AZALAN' datasource="#DSN3#">
		SELECT
			ISNULL(SUM(STOCK_AZALT),0) AS AZALAN
		FROM
			GET_STOCK_RESERVED
		WHERE
			STOCK_ID = #attributes.stock_id#
	</cfquery>
	<cfquery name='GET_STOCK_RESERVED_ARTAN' datasource="#DSN3#">
		SELECT
			ISNULL(SUM(STOCK_ARTIR),0) AS ARTAN
		FROM
			GET_STOCK_RESERVED
		WHERE
			STOCK_ID = #attributes.stock_id#
	</cfquery>
	<!--- Üretim emrinden gelenleride dahil ediyoruz artık M.ER 20070927 --->
	<cfquery name="GET_PROD_RESERVED" datasource="#DSN3#"><!--- üretim emrinden gelen stok rezerv --->
		SELECT
			ISNULL(SUM(STOCK_AZALT),0) AS AZALAN,
			ISNULL(SUM(STOCK_ARTIR),0) AS ARTAN
		FROM
			GET_PRODUCTION_RESERVED
		WHERE
			PRODUCT_ID = #attributes.product_id#
	</cfquery>
</cfif>
<cfquery name="PRODUCT_TOTAL_STOCK" datasource="#DSN2#">
	SELECT 
		PRODUCT_TOTAL_STOCK 
	FROM 
		GET_PRODUCT_STOCK 
	WHERE 
	  <cfif isdefined("attributes.product_id") and len(attributes.product_id)>
		PRODUCT_ID = #attributes.product_id#
	  <cfelse>
		PRODUCT_ID IS NULL
	  </cfif>
</cfquery>
