<cfquery name="GET_PRODUCT" datasource="#dsn3#">
	SELECT 
		DISTINCT * 
	FROM 
		PRODUCT P , 
		PRODUCT_CAT PC,
		PRODUCT_UNIT PU,
		STOCKS S
	WHERE  
		PC.PRODUCT_CATID = P.PRODUCT_CATID AND 
		P.PRODUCT_ID = PU.PRODUCT_ID AND
		P.IS_PROTOTYPE = 1 AND
		S.PRODUCT_ID=P.PRODUCT_ID AND
		S.BARCOD=P.BARCOD
	<cfif len(attributes.keyword)>
		AND P.PRODUCT_NAME LIKE '%#attributes.keyword#%'
	</cfif>
	<cfif attributes.cat neq 0>
		AND PC.HIERARCHY LIKE '%#attributes.CAT#%'
	</cfif>
	<cfif (isdefined("attributes.product_status") and (attributes.product_status neq 2))>
		AND P.PRODUCT_STATUS = #attributes.product_status#
	</cfif>
	ORDER BY
		P.PRODUCT_NAME
</cfquery>
