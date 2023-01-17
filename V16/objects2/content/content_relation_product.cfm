<cfparam name="attributes.CONTENT_PRODUCT_MAXROWS" default="3">
<cfquery name="GET_RELATED_PRODUCTS" datasource="#DSN3#">
	SELECT 
		PCR.*,
		P.PRODUCT_NAME,
		P.PRODUCT_DETAIL,
		UFU.USER_FRIENDLY_URL,
		PS.PRICESTANDART_STATUS,
		PS.PRICE,
		PS.MONEY
	FROM
		#dsn_alias#.CONTENT_RELATION PCR,
		PRODUCT_CAT PC,
		PRODUCT P
		OUTER APPLY(
					SELECT TOP 1 UFU.USER_FRIENDLY_URL 
					FROM #dsn#.USER_FRIENDLY_URLS UFU 
					WHERE UFU.ACTION_TYPE = 'PRODUCT_ID' 
                    AND UFU.ACTION_ID = P.PRODUCT_ID 		
                    AND UFU.PROTEIN_SITE = #GET_PAGE.PROTEIN_SITE#) UFU,
		PRICE_STANDART PS
	WHERE
		<cfif isdefined("session.pp")>P.IS_EXTRANET = 1 AND<cfelse>P.IS_INTERNET = 1 AND</cfif>
		PCR.CONTENT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.cntid#"> AND
		PCR.ACTION_TYPE_ID = P.PRODUCT_ID AND
		P.PRODUCT_CATID = PC.PRODUCT_CATID AND
		PS.PRODUCT_ID = PCR.ACTION_TYPE_ID AND
		PS.PRICESTANDART_STATUS = 1 AND
		PS.PURCHASESALES = 1 
		<!---AND PC.IS_PUBLIC = 1--->	
</cfquery>
<cfif get_related_products.recordcount>
	<cfif len(attributes.content_product_maxrows)>
		<cfset content_product_maxrows = #attributes.content_product_maxrows#>
	<cfelse>
		<cfset content_product_maxrows = ''>
	</cfif>	
	<cfoutput query="get_related_products" maxrows="#content_product_maxrows#">
		<cfquery name="GET_PRODUCT_IMAGES" datasource="#DSN3#" maxrows="1">
			SELECT
				PATH, 
				PATH_SERVER_ID
			FROM
				PRODUCT_IMAGES 
			WHERE 
				PRODUCT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#action_type_id#"> AND
				(IMAGE_SIZE = 0 OR IMAGE_SIZE = 1 OR IMAGE_SIZE = 2)
		</cfquery>
		<div style="background-color:##e7f5ec;" class="product_slider_item">	
			<cfif len(get_product_images.path)>
				<cfif isdefined('attributes.content_product_image') and attributes.content_product_image eq 1>				
					<cfif isdefined("attributes.content_product_width") and len(attributes.content_product_width)>
						<cfset prod_image_width = #attributes.content_product_width#>
					<cfelse>
						<cfset prod_image_width = ''>
					</cfif>
					<cfif isdefined("attributes.content_product_height") and len(attributes.content_product_height)>
						<cfset prod_image_height = #attributes.content_product_height#>
					<cfelse>
						<cfset prod_image_height = ''>
					</cfif>		
					<div class="product_slider_item_img">
						<img src="/documents/product/#get_product_images.path#">
					</div>								
				</cfif>
			</cfif>
			<div class="product_slider_item_text">
				<cfif isdefined('attributes.content_product_name') and attributes.content_product_name eq 1>									
					<h2 style="color:##21b251">#product_name#</h2>
				</cfif>
				<!--- <cfif isdefined('attributes.content_product_price') and attributes.content_product_price eq 1>			
					<cf_get_lang_main no='672.Fiyat'> : #price# #money# +KDV			
				</cfif> --->
				<cfif isdefined('attributes.content_product_detail') and attributes.content_product_detail eq 1>			
					<span>#product_detail#</span>		
				</cfif>  
				<cfif isdefined('attributes.content_product_detail_btn') and attributes.content_product_detail_btn eq 1>
					<a style="background-color:##21b251;" href="#site_language_path#/#USER_FRIENDLY_URL#">daha fazla bilgi</a>
				</cfif> 
			</div>
		</div>				
	</cfoutput>	
</cfif>