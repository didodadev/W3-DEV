<cfquery name="GET_BRANDS" datasource="#DSN3#">
	SELECT <cfif isdefined('attributes.max_brand_num') and len(attributes.max_brand_num)>TOP #attributes.max_brand_num#</cfif>
		PB.BRAND_NAME,
		PB.BRAND_ID,
		UFU.USER_FRIENDLY_URL
	FROM 
		PRODUCT_BRANDS PB
		OUTER APPLY(
			SELECT TOP 1 UFU.USER_FRIENDLY_URL 
			FROM #dsn#.USER_FRIENDLY_URLS UFU 
			WHERE UFU.ACTION_TYPE = 'BRAND_ID' 
			AND UFU.ACTION_ID = PB.BRAND_ID 		
			AND UFU.PROTEIN_SITE = #GET_PAGE.PROTEIN_SITE#) UFU	
	WHERE	
				
		PB.IS_ACTIVE = 1 AND
		PB.IS_INTERNET = 1 
	ORDER BY 
		PB.BRAND_NAME
</cfquery>
<cfset brand_list = valuelist(get_brands.brand_id)>
<cfif isdefined("attributes.is_brand_prod_number") and attributes.is_brand_prod_number eq 1>
	<cfquery name="GET_COUNT_BRAND" datasource="#DSN3#">
		SELECT
			COUNT(P.PRODUCT_ID) AS PRODUCT_COUNT,
			P.BRAND_ID		
		FROM 
			PRODUCT P,
			PRICE_STANDART PR,
			PRODUCT_CAT PC
		WHERE 
			P.IS_INTERNET = 1 AND		
			PR.PRODUCT_ID = P.PRODUCT_ID AND
			PR.PRICE > 0 AND
			PR.PRICESTANDART_STATUS = 1	AND
			PR.PURCHASESALES = 1 AND
			P.PRODUCT_STATUS = 1 AND
			P.PRODUCT_CATID = PC.PRODUCT_CATID AND
			P.BRAND_ID IN (#brand_list#)
		GROUP BY
			P.BRAND_ID
	</cfquery>
	<cfset product_brand_id_list = valuelist(get_count_brand.brand_id)>
	<cfset product_brand_count_list = valuelist(get_count_brand.product_count)>
</cfif>

<div>	
	<h1>
		<cfif isDefined("attributes.brand_menu_header") and len(attributes.brand_menu_header)>
			<cf_get_lang dictionary_id='#attributes.brand_menu_header#'>
		</cfif>
	</h1>
	<ul>
		<cfoutput query="get_brands">
			<cfif isdefined("attributes.is_brand_prod_number") and attributes.is_brand_prod_number eq 1>
				<cfif listfindnocase(product_brand_id_list,brand_id)>
					<cfset product_count_ = listgetat(product_brand_count_list,listfindnocase(product_brand_id_list,brand_id))>
				<cfelse>
					<cfset product_count_ = 0>
				</cfif>
			</cfif>  	
			<li>
				<a href="#USER_FRIENDLY_URL#">#brand_name#
					<cfif isdefined("attributes.is_brand_prod_number") and attributes.is_brand_prod_number eq 1> (#product_count_#)</cfif>
				</a> 
			</li>
		</cfoutput>
	</ul>
</div>