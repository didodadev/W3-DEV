<cfif form.sta eq 5><!---Çek Karşılıksız İse--->
	<cfinclude template="upd_status_cheque_karsiliksiz.cfm">
<cfelseif form.sta eq 7><!--- Firmanyn Kendi Çeki Ödendi İse--->
	<cfinclude template="upd_status_cheque_payment.cfm">
<cfelseif form.sta eq 3>
	<cfinclude template="upd_status_cheque_collect.cfm">
</cfif>
<script type="text/javascript">
	wrk_opener_reload();
	window.close();
</script>
