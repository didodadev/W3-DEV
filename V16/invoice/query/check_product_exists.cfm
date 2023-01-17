<cfif not isdefined("attributes.rows_") or attributes.rows_ lte 0>
	<script type="text/javascript">
		alert("<cf_get_lang no='39.Ürün Seçmediniz Lütfen Ürün Seçiniz !'>");
		window.location.href='<cfoutput>#cgi.referer#</cfoutput>';
		//history.back();
	</script>
	<cfabort>
</cfif>
