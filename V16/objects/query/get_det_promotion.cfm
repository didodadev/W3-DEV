<cfif isDefined("url.prom_id")>
	<cfquery name="GET_DET_PROMOTION" datasource="#dsn3#">
		SELECT * FROM PROMOTIONS WHERE PROM_ID=#URL.PROM_ID#
	</cfquery>
	<cfquery name="GET_Coupon" datasource="#DSN3#">
		SELECT COUPON_NO,COUPON_NAME FROM COUPONS <cfif len(get_det_promotion.coupon_id)>WHERE COUPON_ID = #get_det_promotion.coupon_id#</cfif> 
	</cfquery>
	<!--- BK 180 gune silinsin 20130724 <cfif len(get_det_promotion.discount_type_id_2)>
		<cfquery name="GET_DISCOUNT_TYPES" datasource="#DSN3#">
			SELECT * FROM SETUP_DISCOUNT_TYPE WHERE  DISCOUNT_TYPE_ID= #get_det_promotion.discount_type_id_2# 
		</cfquery>
	</cfif> --->
	<cfif len(get_det_promotion.brand_id)>
		<cfquery name="get_brand_name" datasource="#dsn3#">
			SELECT 
				BRAND_NAME	
			FROM
				PRODUCT_BRANDS
			WHERE
				BRAND_ID = #get_det_promotion.BRAND_ID#
		</cfquery>
	</cfif>
	<cfif len(get_det_promotion.company_id)>
		<cfquery name="GET_COMPANY" datasource="#DSN#">
			SELECT NICKNAME FROM COMPANY WHERE COMPANY_ID = #get_det_promotion.company_id#
		</cfquery>
	</cfif>
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
				POSITION_STATUS=1 AND 
				EMPLOYEE_ID=#GET_DET_PROMOTION.VALID_EMP#
		</cfquery>
	</cfif>
	<cfif len(get_det_promotion.stock_id)>
	<cfquery name="GET_MAIN_PRODUCT" datasource="#dsn3#">
		SELECT 	
			<!--- STOCKS.STOCK_ID,
			STOCKS.STOCK_CODE,
			STOCKS.PROPERTY,
			STOCKS.PRODUCT_ID, --->
			PRODUCT.PRODUCT_ID,
			PRODUCT.PRODUCT_NAME,
			PRODUCT_CAT.PRODUCT_CAT
		FROM 
		 	STOCKS,
			PRODUCT,
			PRODUCT_CAT
		WHERE 
			STOCKS.STOCK_ID=#GET_DET_PROMOTION.STOCK_ID# AND 
			STOCKS.PRODUCT_ID=PRODUCT.PRODUCT_ID AND
			PRODUCT_CAT.PRODUCT_CATID=PRODUCT.PRODUCT_CATID 
	</cfquery>
	</cfif>
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
	<cfif len(GET_DET_PROMOTION.RECORD_EMP)>
	<cfquery name="GET_EMP" datasource="#dsn#">
		SELECT 
			EMPLOYEE_NAME,
			EMPLOYEE_SURNAME
		FROM 
			EMPLOYEES
		WHERE 
			EMPLOYEE_ID=#GET_DET_PROMOTION.RECORD_EMP#
	</cfquery>
	</cfif>
</cfif>

