<cfif isDefined("url.prom_id")>
	<cfquery name="GET_DET_PROMOTION" datasource="#dsn3#">
		SELECT * FROM PROMOTIONS_HISTORY WHERE PROM_ID=#URL.PROM_ID#
	</cfquery>
	<cfif not get_det_promotion.recordcount>
	<script type="text/javascript">
		alert('Bu Promosyona Ait Tarihçe Kaydı Bulunmamaktadır!');
		window.close();
	</script>
	<cfabort>
	<cfelse>
	<cfset coupon_id_list = ''>
 <cfset DISCOUNT_TYPE_ID_LIST = ''> 
	<cfset brand_id_list = ''>
	<cfset camp_id_list = ''>
	<cfset stock_id_list = ''>
	<cfset product_catid_list = ''>
	<cfset free_stock_id_list = ''>
	<cfoutput query="get_det_promotion">
		<cfif len(coupon_id) and not listfind(coupon_id_list,coupon_id,',')>
			<cfset coupon_id_list = listappend(coupon_id_list,coupon_id,',')>
		</cfif>
		<cfif len(_DISCOUNT_TYPE_ID_2) and not listfind(DISCOUNT_TYPE_ID_LIST,_DISCOUNT_TYPE_ID_2,',')>
			<cfset DISCOUNT_TYPE_ID_LIST = listappend(DISCOUNT_TYPE_ID_LIST,_DISCOUNT_TYPE_ID_2,',')>
		</cfif> 
		<cfif len(brand_id) and not listfind(brand_id_list,brand_id,',')>
			<cfset brand_id_list = listappend(brand_id_list,brand_id,',')>
		</cfif>
		<cfif len(camp_id) and not listfind(camp_id_list,camp_id,',')>
			<cfset camp_id_list = listappend(camp_id_list,camp_id,',')>
		</cfif>
		<cfif len(stock_id) and not listfind(stock_id_list,stock_id,',')>
			<cfset stock_id_list = listappend(stock_id_list,stock_id,',')>
		</cfif>
		<cfif len(product_catid) and not listfind(product_catid_list,product_catid,',')>
			<cfset product_catid_list = listappend(product_catid_list,product_catid,',')>
		</cfif>
		<cfif len(free_stock_id) and not listfind(free_stock_id_list,free_stock_id,',')>
			<cfset free_stock_id_list = listappend(free_stock_id_list,free_stock_id,',')>
		</cfif>
	</cfoutput>
	<cfif len(coupon_id_list)>
		<cfset coupon_id_list=listsort(coupon_id_list,'numeric','ASC',',')>
		<cfquery name="GET_Coupon" datasource="#DSN3#">
			SELECT COUPON_NO,COUPON_NAME FROM COUPONS WHERE COUPON_ID IN(#coupon_id_list#)
		</cfquery>
	</cfif>
	<!--- <cfif len(DISCOUNT_TYPE_ID_LIST)>
		<cfset discount_type_id_list = listsort(discount_type_id_list,'numeric','ASC',',')>
		 <cfquery name="GET_DISCOUNT_TYPES" datasource="#DSN3#">
			SELECT * FROM SETUP_DISCOUNT_TYPE WHERE  DISCOUNT_TYPE_ID IN(#discount_type_id_list#) ORDER BY DISCOUNT_TYPE
		</cfquery>
	</cfif> ---> 
	<cfif len(brand_id_list)>
		<cfset brand_id_list = listsort(brand_id_list,'numeric','ASC',',')>
		<cfquery name="get_brand_name" datasource="#dsn3#">
			SELECT BRAND_NAME FROM PRODUCT_BRANDS WHERE BRAND_ID IN (#brand_id_list#) 
		</cfquery>
	</cfif>
	<cfif len(camp_id_list)>
		<cfset camp_id_list = listsort(camp_id_list,'numeric','ASC',',')>
		<cfquery name="GET_CAMP_NAME" datasource="#dsn3#">
			SELECT 	CAMP_HEAD,CAMP_STARTDATE,CAMP_FINISHDATE FROM CAMPAIGNS WHERE CAMP_ID IN(#camp_id_list#)
		</cfquery>
	</cfif>
	<cfif len(stock_id_list)>
		<cfset stock_id_list = listsort(stock_id_list,'numeric','ASC',',')>
		<cfquery name="GET_MAIN_PRODUCT" datasource="#dsn3#">
			SELECT STOCKS.PRODUCT_ID,PRODUCT.PRODUCT_ID,PRODUCT.PRODUCT_NAME FROM PRODUCT,STOCKS WHERE STOCKS.PRODUCT_ID = PRODUCT.PRODUCT_ID AND STOCKS.STOCK_ID IN(#stock_id_list#) ORDER BY STOCK_ID 
		</cfquery>
	</cfif>
	<cfif len(product_catid_list)>
		<cfset product_catid_list = listsort(product_catid_list,'numeric','ASC',',')>
		<cfquery name="GET_PRODUCT_CAT" datasource="#dsn3#">
			SELECT PRODUCT_CAT FROM PRODUCT_CAT WHERE PRODUCT_CATID IN(#product_catid_list#)
		</cfquery>
	</cfif>
	<cfif len(free_stock_id_list)>
		<cfset free_stock_id_list = listsort(free_stock_id_list,'numeric','ASC',',')>
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
				STOCKS.STOCK_ID IN(#free_stock_id_list#)
				AND STOCKS.PRODUCT_ID=PRODUCT.PRODUCT_ID
		</cfquery>
	</cfif>
</cfif>
</cfif>

