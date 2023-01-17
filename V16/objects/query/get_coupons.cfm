<cfquery name="COUPONS" datasource="#dsn3#">
	SELECT
		COUPON_ID,
		COUPON_NAME
	FROM
		COUPONS
	WHERE
		PROM_ID = #PROM_ID#
</cfquery>	
	

