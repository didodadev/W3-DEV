<cfquery name="get_paper" datasource="#dsn3#">
	SELECT COUPON_NO FROM COUPONS WHERE COUPON_ID=#attributes.coupon_id#
</cfquery>
<cfquery name="DEL_PROPERTY_DETAIL" datasource="#dsn3#">
	DELETE FROM COUPONS WHERE COUPON_ID = #attributes.coupon_id#
</cfquery>
<cf_add_log  log_type="-1" action_id="#attributes.coupon_id#" PAPER_NO="#get_paper.COUPON_NO#" action_name="#attributes.head#">
<script>
	location.href = document.referrer;
</script>