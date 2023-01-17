<cfquery name="GET_PRODUCT_CAT" datasource="#DSN1_alias#">
	SELECT <cfif isdefined('attributes.max_productcat_num') and len(attributes.max_productcat_num)>TOP #attributes.max_productcat_num#</cfif>
		PC.PRODUCT_CAT,
		PC.PRODUCT_CATID,
		PC.HIERARCHY,
		PC.LIST_ORDER_NO,        
		PC.IS_PUBLIC,
		PC.DETAIL,
		UFU.USER_FRIENDLY_URL
	FROM 
		PRODUCT_CAT PC
		OUTER APPLY(
            SELECT TOP 1 UFU.USER_FRIENDLY_URL 
            FROM #dsn#.USER_FRIENDLY_URLS UFU 
            WHERE UFU.ACTION_TYPE = 'PRODUCT_CATID' 
        AND UFU.ACTION_ID = PC.PRODUCT_CATID 		
        AND UFU.PROTEIN_SITE = #GET_PAGE.PROTEIN_SITE#) UFU,		
		PRODUCT_CAT_OUR_COMPANY PCO
	WHERE 		
		PCO.PRODUCT_CATID = PC.PRODUCT_CATID	
		<cfif isDefined("attributes.product_category_ids") and len(attributes.product_category_ids)>
			AND PC.PRODUCT_CATID IN (<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.product_category_ids#" list="true">)
		</cfif>
		AND PC.IS_PUBLIC = 1
	ORDER BY
		<cfif isdefined("attributes.product_category_order_type") and attributes.product_category_order_type eq 1>
			PC.PRODUCT_CAT	
		<cfelseif isdefined("attributes.product_category_order_type") and attributes.product_category_order_type eq 0>
			PC.HIERARCHY
		<cfelseif isdefined("attributes.product_category_order_type") and attributes.product_category_order_type eq 2>
			PC.LIST_ORDER_NO
		<cfelse>
			PC.HIERARCHY
		</cfif>
</cfquery>

<div>    	
	<h1>
		<cfif isDefined("attributes.product_cat_menu_header") and len(attributes.product_cat_menu_header)>
			<cf_get_lang dictionary_id='#attributes.product_cat_menu_header#'>
		</cfif>
	</h1>
	<ul>
		<cfloop query="get_product_cat">
			<cfoutput>			
				<li>
					<a href="#USER_FRIENDLY_URL#">
						<cfif isDefined("attributes.show_product_cat_header") and attributes.show_product_cat_header eq 1> 
							#product_cat#
						</cfif>		
					</a>					
					<cfif isDefined("attributes.show_product_cat_detail") and attributes.show_product_cat_detail eq 1> 
						<div style="font-family: 'PoppinsM';font-size: 12px;line-height: 16px;color: ##524b4b;margin:5px 0 5px 0;">
							#detail#
						</div>
					</cfif>					
				</li>	                   
			</cfoutput>	
		</cfloop>
	</ul>
</div>	
