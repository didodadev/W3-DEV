<cfquery name="ADD_STOCK_CODE" datasource="#DSN1#">
	DELETE FROM
		STOCKS_BARCODES
	WHERE 
		STOCK_ID=#attributes.stock_id# AND
		BARCODE='#attributes.barcode#'
</cfquery>
<script type="text/javascript">
	location.href = document.referrer;
</script>
<!--- <cflocation addtoken="no" url="#request.self#?fuseaction=objects.popup_form_add_stock_barcode&stock_id=#attributes.STOCK_ID#&is_terazi=#attributes.is_terazi#"> --->
