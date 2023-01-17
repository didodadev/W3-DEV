<cfquery name="get_tree_xml" datasource="#dsn#">
	SELECT 
		PROPERTY_VALUE,
		PROPERTY_NAME
	FROM
		FUSEACTION_PROPERTY
	WHERE
		OUR_COMPANY_ID = #session.ep.company_id# AND
		FUSEACTION_NAME = 'product.popup_add_anative_product' AND
		PROPERTY_NAME = 'x_is_product_tree'
</cfquery>
<cfif get_tree_xml.recordcount>
	<cfset x_is_product_tree = get_tree_xml.PROPERTY_VALUE>
<cfelse>
	<cfset x_is_product_tree = 1>
</cfif>
<cfquery name="GET_ALTERNATE_PRODUCT" datasource="#dsn3#">
	SELECT 
		AP.*,
		S.PRODUCT_NAME,
		S.STOCK_CODE
	FROM 
		ALTERNATIVE_PRODUCTS AP,
		STOCKS S
	WHERE 
		S.PRODUCT_ID = AP.ALTERNATIVE_PRODUCT_ID AND
		S.STOCK_ID = AP.STOCK_ID AND
		AP.PRODUCT_ID = #attributes.pid# 
		<cfif x_is_product_tree eq 1>
			AND AP.TREE_STOCK_ID IS NULL
		</cfif>
	ORDER BY ALTERNATIVE_PRODUCT_NO
</cfquery>

