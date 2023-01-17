<cfquery name="GET_PRODUCT" datasource="#dsn1#" cachedwithin="#fusebox.general_cached_time#">
	SELECT 
		PU.MAIN_UNIT,
		P.PRODUCT_ID,
		P.PRODUCT_NAME,
		S.STOCK_ID,
		S.BARCOD,
		S.STOCK_CODE,
		S.PROPERTY,
		SUM(SR.STOCK_IN - SR.STOCK_OUT) AS PRODUCT_STOCK,
		SR.STORE
	FROM 
		PRODUCT AS P,
		STOCKS AS S,
		PRODUCT_UNIT AS PU,
		#dsn2_alias#.STOCKS_ROW SR
	WHERE
		P.IS_INVENTORY = 1 AND
		PU.IS_MAIN = 1 AND
		SR.STOCK_ID = S.STOCK_ID AND
		P.PRODUCT_ID = S.PRODUCT_ID AND
		P.PRODUCT_ID = PU.PRODUCT_ID AND
		(
		(SR.STORE IS NOT NULL AND SR.STORE IN (SELECT DEPARTMENT_ID FROM #dsn_alias#.DEPARTMENT WHERE BRANCH_ID=#listgetat(session.ep.user_location,2,'-')#))
		OR
		(SR.STORE IS NULL
        AND (SELECT COUNT(STOCK_ID) FROM #dsn2_alias#.STOCKS_ROW SR2 WHERE SR2.STOCK_ID = SR.STOCK_ID) = 1 <!--- Ürün ilk oluştuğunda stoğa 'store' alanı boş olan kayıt atıyordu buda listede çoklamasına sebep oluyordu bu yüzden eklendi--->
        AND P.PRODUCT_ID IN(SELECT PB.PRODUCT_ID FROM PRODUCT_BRANCH PB WHERE PB.BRANCH_ID = #listgetat(session.ep.user_location,2,'-')#))
		)
	<cfif isDefined("attributes.barcod") and len(attributes.barcod)>
		AND S.BARCOD='#attributes.barcod#'
	<cfelseif isdefined('attributes.keyword') and len(attributes.keyword)>
		AND P.PRODUCT_NAME LIKE '<cfif len(attributes.keyword) gt 2>%</cfif>#attributes.keyword#%'
	</cfif>
	<cfif isDefined("attributes.stock_code") and len(attributes.stock_code)>
		AND S.STOCK_CODE LIKE '<cfif len(attributes.stock_code) gt 3>%</cfif>#attributes.stock_code#%'
	 </cfif>
	<cfif attributes.is_stock_active neq 2>
		AND S.STOCK_STATUS = #attributes.is_stock_active#
	</cfif>
	<cfif len(attributes.company_id) and isnumeric(attributes.company_id)>
		AND P.COMPANY_ID = #attributes.company_id#
	</cfif>
	<cfif isDefined("attributes.search_product_catid") and len(attributes.search_product_catid)>
		AND S.STOCK_CODE LIKE '#attributes.search_product_catid#%'
	</cfif>	
	<cfif len(attributes.employee_id) and isnumeric(attributes.employee_id) and len(attributes.employee)>
		AND P.PRODUCT_MANAGER = #attributes.employee_id#
	</cfif>	
	<cfif len(attributes.department_id)>
	  <cfif listlen(attributes.department_id,'-') eq 1>
		AND SR.STORE = #attributes.department_id#
	  <cfelse>
		AND SR.STORE = #listfirst(attributes.department_id,'-')#	  
	  	AND SR.STORE_lOCATION = #listlast(attributes.department_id,'-')#
	  </cfif>
	</cfif>	
	GROUP BY
		PU.MAIN_UNIT,
		P.PRODUCT_ID,
		P.PRODUCT_NAME,
		S.STOCK_ID,
		S.BARCOD,
		S.STOCK_CODE,
		S.PROPERTY,
		SR.STORE<!--- ,
		D.DEPARTMENT_HEAD --->
	<cfif isDefined("attributes.amount_flag") and  attributes.amount_flag eq 0 >
		HAVING SUM(SR.STOCK_IN - SR.STOCK_OUT) < 0
	<cfelseif isDefined("attributes.amount_flag") and  attributes.amount_flag eq 1 >
		HAVING SUM(SR.STOCK_IN - SR.STOCK_OUT) > 0
    <cfelseif isDefined("attributes.amount_flag") and  attributes.amount_flag eq 2><!--- sıfır stok --->
        HAVING round(SUM(SR.STOCK_IN - SR.STOCK_OUT),2) = 0
	</cfif>
	ORDER BY
		P.PRODUCT_NAME,
		S.PROPERTY
</cfquery>

<!--- <cfquery name="GET_PRODUCT" datasource="#dsn3#">
	SELECT
		GSPB.PRODUCT_STOCK,
		S.PRODUCT_ID,
		S.PRODUCT_NAME,
		PU.ADD_UNIT,
		PU.MAIN_UNIT,
		S.STOCK_CODE,
		S.STOCK_ID,
		S.PROPERTY,
		S.BARCOD
	FROM 
		PRODUCT_UNIT PU,
		STOCKS S,
		#dsn2_alias#.GET_STOCK_PRODUCT_BRANCH GSPB
	WHERE 
		S.PRODUCT_ID = PU.PRODUCT_ID AND
		S.STOCK_ID = GSPB.STOCK_ID AND
		S.PRODUCT_UNIT_ID = PU.PRODUCT_UNIT_ID AND
		GSPB.BRANCH_ID = #listgetat(session.ep.user_location,2,'-')#
	<cfif isdefined('attributes.keyword') and len(attributes.keyword)>
		AND
		(
		S.PRODUCT_NAME LIKE '%#attributes.keyword#%' OR
		S.STOCK_CODE LIKE '%#attributes.keyword#%' OR
		S.BARCOD LIKE '%#attributes.keyword#%'
		)
	</cfif>
	<cfif attributes.is_stock_active neq 2>
		AND S.STOCK_STATUS = #attributes.is_stock_active#
	</cfif>
	<cfif len(attributes.company_id) and isnumeric(attributes.company_id)>
		AND S.COMPANY_ID = #attributes.company_id#
	</cfif>
	<cfif isDefined("attributes.search_product_catid") and len(attributes.search_product_catid)>
		AND S.STOCK_CODE LIKE '#attributes.search_product_catid#%'
	</cfif>	
	<cfif len(attributes.employee_id) and isnumeric(attributes.employee_id) and len(attributes.employee)>
		AND S.PRODUCT_MANAGER = #attributes.employee_id#
	</cfif>	
	ORDER BY 
		S.PRODUCT_NAME, S.PROPERTY
</cfquery> --->
