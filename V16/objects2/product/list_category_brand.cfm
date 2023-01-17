<cfquery name="GET_PRODUCT_CAT_BRANDS" datasource="#DSN1_alias#">
	SELECT
		PRODUCT_BRANDS.BRAND_ID,
		PRODUCT_BRANDS.BRAND_NAME
	FROM
		PRODUCT_CAT_BRANDS,
		PRODUCT_BRANDS
	WHERE
		PRODUCT_CAT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.product_catid#"> AND
		PRODUCT_CAT_BRANDS.BRAND_ID = PRODUCT_BRANDS.BRAND_ID
</cfquery>

<cfif GET_PRODUCT_CAT_BRANDS.recordCount>
<h2><cf_get_lang dictionary_id='32097.Markalar'></h2>	
	<cfoutput query="GET_PRODUCT_CAT_BRANDS">
		<div>	
		#brand_name#  
		</div>  
	</cfoutput>  	
</cfif>
