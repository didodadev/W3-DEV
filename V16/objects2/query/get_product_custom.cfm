<cfquery name="GET_PRODUCT_CAT_CUSTOM_PROPERTY" datasource="#DSN1#">
	SELECT
		PRODUCT_DT_PROPERTIES.*,
		PRODUCT_PROPERTY.PROPERTY,
		PRODUCT_PROPERTY.PROPERTY_ID,
		PRODUCT_PROPERTY_DETAIL.PROPERTY_DETAIL,
		PRODUCT_PROPERTY_DETAIL.PROPERTY_DETAIL_ID
	FROM
		PRODUCT_DT_PROPERTIES,
		PRODUCT_PROPERTY,
		PRODUCT_PROPERTY_DETAIL
	WHERE
		PRODUCT_DT_PROPERTIES.VARIATION_ID = PRODUCT_PROPERTY_DETAIL.PROPERTY_DETAIL_ID AND
		PRODUCT_DT_PROPERTIES.PRODUCT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.pid#"> AND
		PRODUCT_PROPERTY.PROPERTY_ID = PRODUCT_DT_PROPERTIES.PROPERTY_ID AND
		PRODUCT_PROPERTY_DETAIL.PRPT_ID = PRODUCT_PROPERTY.PROPERTY_ID AND
		PRODUCT_DT_PROPERTIES.IS_OPTIONAL = 1
</cfquery>
