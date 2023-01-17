<cfif not isdefined("attributes.invoice_row_id_list")>
	<script>
		alert('Kapama Satırı Seçmediniz!');
		history.back();
	</script>
    <cfabort>
</cfif>

<cfinclude template="close_action_group_rows_ic.cfm">

<script>
	alert('Kapama İşlemleri Tamamlandı!');
	window.close();
</script>
<cfabort>