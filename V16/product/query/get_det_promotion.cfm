<cfif isDefined("url.prom_id")>
	<cfquery name="GET_DET_PROMOTION" datasource="#dsn3#">
		SELECT 
			* 
		FROM 
			PROMOTIONS 
		WHERE 
			PROM_ID=#URL.PROM_ID#
	</cfquery>
	
	<cfif len(get_det_promotion.camp_id)>
		<cfquery name="GET_CAMP_NAME" datasource="#dsn3#">
			SELECT 	
				CAMP_HEAD,
				CAMP_STARTDATE,
				CAMP_FINISHDATE 
			FROM 
				CAMPAIGNS
			WHERE 
				CAMP_ID = #GET_DET_PROMOTION.CAMP_ID#
		</cfquery>
	</cfif>
	
	<cfif len(get_det_promotion.valid_emp) and len(get_det_promotion.valid)>
		<cfquery name="GET_POSITION" datasource="#dsn#">
			SELECT 
				EMPLOYEE_NAME,
				EMPLOYEE_SURNAME
			FROM 
				EMPLOYEE_POSITIONS
			WHERE 
				POSITION_STATUS=1 
			AND 
				EMPLOYEE_ID=#GET_DET_PROMOTION.VALID_EMP#
		</cfquery>
	</cfif>
	<cfquery name="GET_MAIN_PRODUCT" datasource="#dsn3#">
		SELECT 	
			STOCKS.STOCK_ID,
			STOCKS.STOCK_CODE,
			STOCKS.PROPERTY,
			STOCKS.PRODUCT_ID,
			PRODUCT.PRODUCT_ID,
			PRODUCT.PRODUCT_NAME,
			PRODUCT_CAT.PRODUCT_CAT
		FROM 
			STOCKS,
			PRODUCT,
			PRODUCT_CAT
		WHERE 
			<!--- STOCKS.STOCK_ID=#GET_DET_PROMOTION.STOCK_ID# 
		AND  --->
			STOCKS.PRODUCT_ID=PRODUCT.PRODUCT_ID
		AND 
			PRODUCT_CAT.PRODUCT_CATID=PRODUCT.PRODUCT_CATID 
	</cfquery>
	<cfif len(get_det_promotion.free_stock_id)>
		<cfquery name="GET_FREE_PRODUCT" datasource="#dsn3#">
			SELECT 	
				STOCKS.STOCK_ID,
				STOCKS.STOCK_CODE,
				STOCKS.PROPERTY,
				STOCKS.PRODUCT_ID,
				PRODUCT.PRODUCT_ID,
				PRODUCT.PRODUCT_NAME 
			FROM 
				STOCKS,
				PRODUCT
			WHERE 
				STOCKS.STOCK_ID=#GET_DET_PROMOTION.FREE_STOCK_ID# 
			AND 
				STOCKS.PRODUCT_ID=PRODUCT.PRODUCT_ID
		</cfquery>
	</cfif>
	<cfquery name="GET_EMP" datasource="#dsn#">
		SELECT 
			EMPLOYEE_NAME,
			EMPLOYEE_SURNAME
			FROM EMPLOYEES
		WHERE 
			EMPLOYEE_ID=#GET_DET_PROMOTION.RECORD_EMP#
	</cfquery>
</cfif>

