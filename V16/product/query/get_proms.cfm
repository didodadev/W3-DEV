<cfif isdate(attributes.start_date)><cf_date tarih = "attributes.start_date"></cfif>
<cfif isdate(attributes.finish_date)><cf_date tarih = "attributes.finish_date"></cfif>
<cfif isdefined("attributes.branch_id")>
	<cfquery name="get_price_cats" datasource="#DSN3#">
		SELECT
			PRICE_CATID
		FROM
			PRICE_CAT
		WHERE
			BRANCH LIKE '%,#attributes.branch_id#,%'
	</cfquery>
	<cfset price_cat_list = valuelist(get_price_cats.price_catid)>
</cfif>
<cfquery name="PROMS" datasource="#DSN3#" cachedwithin="#fusebox.general_cached_time#">
	SELECT
		PROM_STATUS,
		PROM_ID,
		PROM_NO,
		PROM_HEAD AS PROM_HEAD,
		RECORD_DATE,
		VALID_EMP,
		VALID,
		STOCK_ID,
		VALIDATOR_POSITION_CODE,
		STARTDATE AS STARTDATE,
		FINISHDATE AS FINISHDATE,
		PROM_STAGE,
		CAMP_ID,
		PROM_RELATION_ID,
		IS_DETAIL,
		PROM_HIERARCHY,
		PROMOTION_CODE
	FROM
		PROMOTIONS 
	WHERE
		1=1
	  <cfif isDefined("attributes.keyword") and len(attributes.keyword)>
		AND
		(
			PROM_NO LIKE '%#attributes.keyword#%' OR
			PROM_HEAD LIKE '%#attributes.keyword#%' OR
			GIFT_HEAD LIKE '%#attributes.keyword#%'
		)
	</cfif>
	<cfif isdefined("attributes.branch_id") and len(PRICE_CAT_LIST)>
		AND PRICE_CATID IN (#PRICE_CAT_LIST#)
	</cfif>
	<cfif len(attributes.product_catid) and len(attributes.product_cat)>
		AND PRODUCT_CATID = #attributes.product_catid#
	</cfif>
	<cfif len(attributes.stock_id) and len(attributes.product_name)>
		<cfif isdefined("is_detail_prom") and is_detail_prom eq 1>
		AND PROM_ID IN 
			( 
			SELECT 
				PROMOTION_ID 
			FROM 
				PROMOTION_CONDITIONS 
			WHERE 
				PROM_CONDITION_ID IN 
				(
				SELECT 
					PROM_CONDITION_ID 
				FROM 
					PROMOTION_CONDITIONS_PRODUCTS 
				WHERE 
					STOCK_ID=#attributes.stock_id#
				)
			) 
		OR STOCK_ID = #attributes.stock_id#
		<cfelse>
			AND STOCK_ID = #attributes.stock_id#
		</cfif>
	</cfif>
	<cfif isdefined("attributes.brand_id") and len(attributes.brand_id) and isdefined("attributes.brand_name") and len(attributes.brand_name)>
		AND BRAND_ID = #attributes.brand_id#
	</cfif>
	<cfif isdefined("attributes.company_id") and isdefined("attributes.company") and len(attributes.company)>
		AND COMPANY_ID = #attributes.company_id#
	</cfif>
	<cfif isdefined("attributes.supplier_id") and isdefined("attributes.supplier_name") and len(attributes.supplier_name) and len(attributes.supplier_id)>
		AND SUPPLIER_ID = #attributes.supplier_id#
	</cfif>
	<cfif isdefined("attributes.price_catid") and len(attributes.price_catid)>
		AND PRICE_CATID = #attributes.price_catid#
	</cfif>
	<!--- BK 180 gune silinsin 20130724 <cfif len(attributes.discount_type_id_2)>
		AND DISCOUNT_TYPE_ID_2 = #attributes.discount_type_id_2#
	</cfif> --->
		<cfif len(attributes.start_date) and not len(attributes.finish_date)>
		AND STARTDATE >= #attributes.start_date#
		<cfelseif len(attributes.finish_date)and not len(attributes.start_date)>
		AND STARTDATE <= #attributes.finish_date#
		<cfelseif len(attributes.start_date) and len(attributes.finish_date)>
		AND STARTDATE <= #attributes.finish_date# AND STARTDATE >= #attributes.start_date#
		</cfif>
	<cfif isdefined('attributes.prom_stage') and len(attributes.prom_stage)>
		AND PROM_STAGE = #attributes.prom_stage#
	</cfif>
	<cfif len(attributes.is_status)>
		AND PROM_STATUS = #attributes.is_status#
	</cfif>
	<cfif len(attributes.collacted_status) and attributes.collacted_status eq 1>
		AND PROM_RELATION_ID IS NOT NULL
	<cfelseif len(attributes.collacted_status) and attributes.collacted_status eq 0> 
		AND PROM_RELATION_ID IS NULL AND ISNULL(IS_DETAIL,0) <> 1
	<cfelseif len(attributes.collacted_status) and attributes.collacted_status eq 2> 
		AND IS_DETAIL = 1
	</cfif>
	<cfif isDefined('attributes.oby') and attributes.oby eq 1>
		ORDER BY 
			PROM_HEAD
	<cfelseif isDefined('attributes.oby') and attributes.oby eq 2>
		ORDER BY 
			FINISHDATE DESC,
			STARTDATE DESC
	<cfelseif isDefined('attributes.oby') and attributes.oby eq 3>
		ORDER BY 
			PROM_NO
	<cfelseif isDefined('attributes.oby') and attributes.oby eq 4>
		ORDER BY 
			PROM_HIERARCHY
	<cfelse>
		ORDER BY 
			FINISHDATE DESC,
			STARTDATE DESC,
			PROM_HEAD		
	</cfif>
</cfquery>
