<cfquery name="DEL_COUPONS" datasource="#dsn3#">
	DELETE
	FROM
	   COUPONS
	WHERE 
	   COUPON_ID = #attributes.COUPON_ID#
</cfquery>
<!--- <script type="text/javascript">
wrk_opener_reload();
window.close();
</script>
 --->
