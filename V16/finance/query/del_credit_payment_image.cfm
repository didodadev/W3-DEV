<cfquery name="GET_CREDIT_PAYMENT" datasource="#DSN3#">
	SELECT
		CARD_IMAGE,
		CARD_IMAGE_SERVER_ID
	FROM
		CREDITCARD_PAYMENT_TYPE
	WHERE
		PAYMENT_TYPE_ID = #attributes.id#
</cfquery>
<cf_del_server_file output_file="finance/#GET_CREDIT_PAYMENT.CARD_IMAGE#" output_server="#GET_CREDIT_PAYMENT.CARD_IMAGE_SERVER_ID#">
<cfquery name="UPD_CREDIT_PAYMENT" datasource="#DSN3#">
	UPDATE
		CREDITCARD_PAYMENT_TYPE
	SET
		CARD_IMAGE = NULL,
		CARD_IMAGE_SERVER_ID = NULL
	WHERE
		PAYMENT_TYPE_ID = #attributes.id#
</cfquery>

<script type="text/javascript">
	wrk_opener_reload();
	window.close();
</script>
