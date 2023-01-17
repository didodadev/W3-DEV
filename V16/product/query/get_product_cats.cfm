<cfquery name="GET_PRODUCT_CATS" datasource="#DSN3#">
	SELECT 
		PRODUCT_CAT,
		HIERARCHY,
		PROFIT_MARGIN,
		PRODUCT_CATID,
		IS_SUB_PRODUCT_CAT
	FROM
		PRODUCT_CAT
	<cfif isDefined('attributes.cat') and len(attributes.cat)>
	WHERE 
		HIERARCHY LIKE '%#attributes.cat#%' 
	</cfif>
	ORDER BY 
		<cfif isDefined("order_by")>
		#order_by#
		<cfelse>
		HIERARCHY ASC
		</cfif>
</cfquery>
