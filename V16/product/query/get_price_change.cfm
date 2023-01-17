
<cfquery name="PRO_PRICE_1" datasource="#DSN3#" cachedwithin="#fusebox.general_cached_time#">
	SELECT
		PC.*,
		P.PRODUCT_ID,
		P.PRODUCT_NAME,
		S.STOCK_CODE,
		S.PRODUCT_UNIT_ID,		
		S.BARCOD,
 		0 AS REAL_PRICE, 
		PL.PRICE_CAT,
		S.MAIN_SPEC,
		S.PROPERTY
		FROM
		PRICE_CHANGE PC,
		PRODUCT P,
		(	
		SELECT 
		*,
        (SELECT TOP 1 SPECT_MAIN_ID FROM SPECT_MAIN SM WHERE SM.STOCK_ID = S.STOCK_ID AND SM.IS_TREE = 1 ORDER BY SM.RECORD_DATE DESC,SM.UPDATE_DATE DESC) MAIN_SPEC
        FROM
        STOCKS S) S,
		PRICE_CAT PL
	WHERE
		PL.PRICE_CATID=PC.PRICE_CATID
		AND
		P.BARCOD=S.BARCOD
		AND
		PC.PRODUCT_ID=P.PRODUCT_ID
		AND
		S.PRODUCT_ID=P.PRODUCT_ID
		
	<cfif isDefined("attributes.keyword") and len(attributes.keyword)>
		AND
		(
		<cfif len(attributes.keyword) eq 1 >
			P.PRODUCT_NAME LIKE '#attributes.keyword#%' COLLATE SQL_Latin1_General_CP1_CI_AI
		<cfelseif len(attributes.keyword) gt 1>
			<cfif listlen(attributes.keyword,"+") gt 1>
				(
					<cfloop from="1" to="#listlen(attributes.keyword,'+')#" index="pro_index">
						P.PRODUCT_NAME LIKE '%#ListGetAt(attributes.keyword,pro_index,"+")#%' COLLATE SQL_Latin1_General_CP1_CI_AI
						<cfif pro_index neq listlen(attributes.keyword,'+')>AND</cfif>
					</cfloop>
				)		
			<cfelse>
				P.PRODUCT_NAME LIKE '%#attributes.keyword#%' COLLATE SQL_Latin1_General_CP1_CI_AI OR 
				P.PRODUCT_CODE LIKE '<cfif len(attributes.keyword) gt 1>%</cfif>#attributes.keyword#%' COLLATE SQL_Latin1_General_CP1_CI_AI OR
				P.PRODUCT_ID IN (SELECT PRODUCT_ID FROM GET_STOCK_BARCODES WHERE BARCODE LIKE '%#attributes.keyword#%' COLLATE SQL_Latin1_General_CP1_CI_AI)
			</cfif>
		</cfif>		
		) 
	</cfif>			
	<cfif isDefined("attributes.pc_status")>
		<cfif len(attributes.pc_status) and attributes.pc_status neq 2>
			AND 
			PC.IS_VALID = #attributes.pc_status# 
		<cfelseif attributes.pc_status eq 2>
			AND 
			PC.IS_VALID IS NULL
		</cfif>
	</cfif>
	<cfif isDefined("attributes.price_catid")  and len(attributes.price_catid)>
		AND 
		PC.PRICE_CATID = #attributes.price_catid# 
	<cfelse>
		AND 
		PC.PRICE_CATID >0
	</cfif>
	<cfif isDefined('attributes.product_id')>
		AND
		P.PRODUCT_ID=#attributes.product_id#
	</cfif>
	<cfif isDefined('attributes.spec') and attributes.spec eq 1>
		AND MAIN_SPEC IS NOT NULL
	</cfif>
</cfquery>
<cfif PRO_PRICE_1.RECORDCOUNT>
	<cfset my_list_prices=listdeleteduplicates(valuelist(PRO_PRICE_1.PRICE_CHANGE_ID))>
</cfif>
<cfquery name="PRO_PRICE_2" datasource="#DSN3#" cachedwithin="#fusebox.general_cached_time#">
	SELECT
		PC.*,
		P.PRODUCT_ID,
		P.PRODUCT_NAME,
		S.STOCK_CODE,
		S.PRODUCT_UNIT_ID,
		S.BARCOD,
 		0 AS REAL_PRICE, 
		''  AS PRICE_CAT,
		S.MAIN_SPEC,
		S.PROPERTY
	FROM
		PRICE_CHANGE PC,
		PRODUCT P,
		(	
		SELECT 
		*,
        (SELECT TOP 1 SPECT_MAIN_ID FROM SPECT_MAIN SM WHERE SM.STOCK_ID = S.STOCK_ID AND SM.IS_TREE = 1 ORDER BY SM.RECORD_DATE DESC,SM.UPDATE_DATE DESC) MAIN_SPEC
        FROM
        STOCKS S) S		
	WHERE
		P.PRODUCT_ID=S.PRODUCT_ID
	AND
		PC.PRODUCT_ID=P.PRODUCT_ID
	<cfif isDefined("attributes.keyword") and len(attributes.keyword)>
		AND
		(
		<cfif len(attributes.keyword) eq 1 >
			P.PRODUCT_NAME LIKE '#attributes.keyword#%' COLLATE SQL_Latin1_General_CP1_CI_AI
		<cfelseif len(attributes.keyword) gt 1>
			<cfif listlen(attributes.keyword,"+") gt 1>
				(
					<cfloop from="1" to="#listlen(attributes.keyword,'+')#" index="pro_index">
						P.PRODUCT_NAME LIKE '%#ListGetAt(attributes.keyword,pro_index,"+")#%' COLLATE SQL_Latin1_General_CP1_CI_AI
						<cfif pro_index neq listlen(attributes.keyword,'+')>AND</cfif>
					</cfloop>
				)		
			<cfelse>
				P.PRODUCT_NAME LIKE '%#attributes.keyword#%' COLLATE SQL_Latin1_General_CP1_CI_AI OR
				P.PRODUCT_CODE LIKE '<cfif len(attributes.keyword) gt 1>%</cfif>#attributes.keyword#%' COLLATE SQL_Latin1_General_CP1_CI_AI OR
				P.PRODUCT_ID IN (SELECT PRODUCT_ID FROM GET_STOCK_BARCODES WHERE BARCODE LIKE '%#attributes.keyword#%' COLLATE SQL_Latin1_General_CP1_CI_AI)
			</cfif>
		</cfif>		
		) 
	</cfif>			
	<cfif isDefined("attributes.pc_status") >
		<cfif len(attributes.pc_status) and attributes.pc_status neq 2>
			AND 
				PC.IS_VALID = #attributes.pc_status# 
		<cfelseif attributes.pc_status eq 2>
				AND 
					PC.IS_VALID IS NULL
		</cfif>
	</cfif>
	<cfif isDefined("attributes.price_catid") and len(attributes.price_catid)>
		AND 
			PC.PRICE_CATID = #attributes.price_catid# 
	<cfelse>
		AND	
			PRICE_CATID < 0
	</cfif>
	<cfif isDefined('attributes.product_id')>
		AND
			P.PRODUCT_ID=#attributes.product_id#
	</cfif>
	<cfif isDefined('my_list_prices') and len(my_list_prices)>
		AND
			PRICE_CHANGE_ID NOT IN (#my_list_prices#)
	</cfif>
	<cfif isDefined('attributes.spec') and attributes.spec eq 1>
	AND MAIN_SPEC IS NOT NULL
	</cfif>
</cfquery>
<cfquery dbtype="query" name="get_price_change" cachedwithin="#fusebox.general_cached_time#">
	(SELECT * FROM PRO_PRICE_1
	UNION ALL
	SELECT * FROM PRO_PRICE_2) order by PRODUCT_NAME
</cfquery>
