<cfquery name="del_query" datasource="#dsn#">
	DELETE 
	FROM 
		INSURANCE_PAYMENT
	WHERE
		INS_PAY_ID = #attributes.INS_PAY_ID#
</cfquery>

<script type="text/javascript">
	wrk_opener_reload();
	window.close();
</script>
<!--- <cflocation url="#request.self#?fuseaction=hr.form_add_insurance_payments" addtoken="no"> --->
