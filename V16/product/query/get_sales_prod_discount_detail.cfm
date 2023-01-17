<cfquery name="get_sales_prod_discount_detail" datasource="#dsn3#">
	SELECT
		C_S_PROD_DISCOUNT_ID,
		COMPANY_ID,
		START_DATE,
		FINISH_DATE,
		DISCOUNT1,
		DISCOUNT2,
		DISCOUNT3,
		DISCOUNT4,
		DISCOUNT5,
		DELIVERY_DATENO,
		C_S_PROD_DISCOUNT_ID,
		PAYMETHOD_ID,
		RECORD_DATE,
		RECORD_EMP
	FROM
		CONTRACT_SALES_PROD_DISCOUNT
	WHERE
		PRODUCT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.pid#">
	ORDER BY
		RECORD_DATE DESC
</cfquery>
