<cfquery name="GET_SUB_PRODUCTS" datasource="#dsn3#">
		(
		SELECT 
			RELATED_ID ,
			PRODUCT_TREE.AMOUNT,
			S.PRODUCT_NAME,
			S.IS_PURCHASE,
			S.IS_PRODUCTION,
			'' AS NICKNAME,
			-1 AS COMPANY_ID,
			S.PRODUCT_ID,
			S.PROPERTY
		FROM 
			PRODUCT_TREE,
			STOCKS S
		WHERE 
			S.COMPANY_ID IS NULL AND
			PRODUCT_TREE.STOCK_ID = #attributes.STOCK_ID# AND 
			S.STOCK_ID=PRODUCT_TREE.RELATED_ID		
			AND
			(
				S.IS_PURCHASE=1 OR
				S.IS_PRODUCTION=1
			)
			<cfif isDefined('attributes.keyword') and len(attributes.keyword)>
			AND S.PRODUCT_NAME LIKE '%#attributes.keyword#%'
			</cfif>	
		)
	UNION
		(
		SELECT 
			RELATED_ID ,
			PRODUCT_TREE.AMOUNT,
			S.PRODUCT_NAME,
			S.IS_PURCHASE,
			S.IS_PRODUCTION,
			C.NICKNAME,
			C.COMPANY_ID,
			S.PRODUCT_ID,
			S.PROPERTY
		FROM 
			PRODUCT_TREE,
			STOCKS S,
			#dsn_alias#.COMPANY C
		WHERE 
			C.COMPANY_ID=S.COMPANY_ID AND
			PRODUCT_TREE.STOCK_ID = #attributes.STOCK_ID# AND 
			S.STOCK_ID=PRODUCT_TREE.RELATED_ID		
			AND
			(
				S.IS_PURCHASE=1 OR
				S.IS_PRODUCTION=1
			)
			<cfif isDefined('attributes.keyword') and len(attributes.keyword)>
			AND
			(
				S.PRODUCT_NAME LIKE '%#attributes.keyword#%' OR 
				C.NICKNAME LIKE '%#attributes.keyword#%' OR
				C.FULLNAME LIKE '%#attributes.keyword#%'
			)
			</cfif>	
		)
</cfquery>
