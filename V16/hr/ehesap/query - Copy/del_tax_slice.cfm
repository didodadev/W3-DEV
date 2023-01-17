<cfquery name="del_tax_slice" datasource="#dsn#">
	DELETE FROM
		SETUP_TAX_SLICES
	WHERE
		TAX_SL_ID = #attributes.TAX_SL_ID#		
</cfquery>
<script type="text/javascript">
	wrk_opener_reload();
	window.close();
</script>

