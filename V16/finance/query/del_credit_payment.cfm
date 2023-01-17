<cfquery name="DEL_CREDIT_PAYMENT" datasource="#DSN3#">
	DELETE
	FROM
		CREDITCARD_PAYMENT_TYPE
	WHERE
		PAYMENT_TYPE_ID = #attributes.id#
</cfquery>
<cf_add_log  log_type="-1" action_id="#attributes.id#" action_name="#attributes.detail#">
<script type="text/javascript">
	location.href='<cfoutput>#request.self#?fuseaction=finance.list_credit_payment_types</cfoutput>';
</script>
