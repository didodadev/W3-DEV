<cfquery name="COUPON" datasource="#dsn3#">
	SELECT
		*
	FROM
		COUPONS
	WHERE
		COUPON_ID = #COUPON_ID#
</cfquery>	
	

