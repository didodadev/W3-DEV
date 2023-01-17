<cfquery name="get_content_products" datasource="#dsn3#">
	SELECT
		PRODUCT_ID,
		PRODUCT_NAME,
		PRODUCT_CATID
	FROM
		PRODUCT
	WHERE
	 1 = 1
	<cfif len(attributes.product_id) and len(attributes.product_name)>
	AND
	PRODUCT_ID = '#attributes.PRODUCT_ID#'
	</cfif>
	<cfif isdefined("attributes.keyword")>
	 AND     
	PRODUCT_NAME LIKE '%#attributes.keyword#%'
	</cfif>
	<cfif isDefined("attributes.PRODUCT_CAT") and len(attributes.PRODUCT_CAT)>
	  AND
	 PRODUCT_CATID = #attributes.PRODUCT_CAT#
	</cfif>
	<cfif isdefined("attributes.product_status") and attributes.product_status eq 1>
	AND
		PRODUCT_STATUS = 1
	</cfif>
	<cfif isdefined("attributes.product_status") and attributes.product_status eq 0>
	AND
		PRODUCT_STATUS = 0
	</cfif>
	ORDER BY 
		PRODUCT_NAME 
</cfquery>	

