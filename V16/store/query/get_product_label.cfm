<cfif isdefined("attributes.start_date") and isdate(attributes.finish_date) and isdate(attributes.start_date)>
	<cf_date tarih='attributes.start_date'>
	<cf_date tarih='attributes.finish_date'>
<cfelse>
	<cfset bugun = createdate(year(now()),month(now()),day(now()))>
	<cfset attributes.start_date = bugun>
	<cfset attributes.finish_date = date_add('d',1,bugun)>
</cfif>
<cfif datediff("d",attributes.start_date,attributes.finish_date) gt 3>
	<cfset attributes.start_date = date_add("d",-3,attributes.finish_date)>
</cfif>
<cfif isdefined("attributes.product_cat") and len(attributes.product_cat) and len(attributes.product_catid)>
	<cfquery name="GET_PRODUCT_CATS" datasource="#dsn3#">
		SELECT 
			PRODUCT_CATID, 
			HIERARCHY,
			PRODUCT_CAT
		FROM 
			PRODUCT_CAT 
		WHERE 
			PRODUCT_CATID = #attributes.product_catid#
		ORDER BY 
			HIERARCHY
	</cfquery>		  
</cfif>  
<cfquery name="GET_PRODUCT" datasource="#dsn1#">
	SELECT 
		PRODUCT.PRODUCT_NAME,
		PRODUCT.PRODUCT_ID,
		PRODUCT.PRODUCT_CATID,
		PRODUCT.PROD_COMPETITIVE,
		PRODUCT.TAX,
		PRICE.RECORD_DATE,
		PRICE.PRICE,
		PRICE.PRICE_KDV,
		PRICE.IS_KDV,
		PRICE.MONEY,
		PRICE.STARTDATE,
		PRICE.FINISHDATE,
		PRICE.PRICE_CATID,
		PRODUCT_UNIT.ADD_UNIT,
		PRODUCT_UNIT.UNIT_MULTIPLIER,
		PRODUCT_UNIT.UNIT_MULTIPLIER_STATIC,
		STOCKS.STOCK_CODE,
		STOCKS.PROPERTY,
		STOCKS.BARCOD
	FROM 
		PRODUCT, 
		#dsn3_alias#.PRICE PRICE,
		PRODUCT_UNIT,
		STOCKS
	WHERE
		PRODUCT.PRODUCT_ID = PRICE.PRODUCT_ID AND
		PRODUCT.IS_INVENTORY = 1 AND
		PRICE.PRICE <> 0 AND
		PRICE.PRICE_CATID=#attributes.price_catid# AND
		ISNULL(PRICE.STOCK_ID,0)=0 AND
		ISNULL(PRICE.SPECT_VAR_ID,0)=0 AND
		PRODUCT_UNIT.PRODUCT_UNIT_ID = PRICE.UNIT AND
		STOCKS.PRODUCT_ID = PRODUCT.PRODUCT_ID AND
		PRICE.STARTDATE <= #now()# AND
		(PRICE.FINISHDATE >= #now()# OR PRICE.FINISHDATE IS NULL) AND
		PRICE.RECORD_DATE <= #attributes.finish_date# AND
		PRICE.RECORD_DATE > #attributes.start_date#
	  <cfif isDefined("attributes.product_cat") and len(attributes.product_cat) and len(attributes.product_catid)>
		AND PRODUCT_CODE LIKE '#get_product_cats.hierarchy#.%'
	  </cfif>
	  <cfif isdefined("attributes.keyword") and len(attributes.keyword) eq 1>
		AND PRODUCT.PRODUCT_NAME LIKE '#attributes.keyword#%'
	  <cfelseif isdefined("attributes.keyword") and len(attributes.keyword) gt 1>
		AND
			(
		<cfloop from="1" to="#listlen(attributes.keyword,'+')#" index="pro_index">
			PRODUCT.PRODUCT_NAME LIKE '%#ListGetAt(attributes.keyword,pro_index,"+")#%'
			<cfif pro_index neq listlen(attributes.keyword,'+')>AND</cfif>
		</cfloop>
			)
	</cfif>
	<cfif attributes.oby eq 2>
		ORDER BY PRODUCT.PRODUCT_NAME DESC
	<cfelseif attributes.oby eq 3>
		ORDER BY PRICE.RECORD_DATE
	<cfelseif attributes.oby eq 4>
		ORDER BY PRICE.RECORD_DATE DESC
	<cfelse>
		ORDER BY PRODUCT.PRODUCT_NAME
	</cfif>	
</cfquery>
