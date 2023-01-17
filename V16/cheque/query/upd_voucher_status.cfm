<cfif attributes.sta eq 5><!---Senet Protestolu İse--->
	<cfinclude template="upd_status_voucher_karsiliksiz.cfm">
<cfelseif attributes.sta eq 7><!--- Firmanın Kendi Senedi Ödendi İse--->
	<cfinclude template="upd_status_voucher_payment.cfm">
<cfelseif attributes.sta eq 3>
	<cfinclude template="upd_status_voucher_collect.cfm">
</cfif>
<script type="text/javascript">
	<cfif isdefined("attributes.draggable")>
		closeBoxDraggable(<cfoutput>#attributes.modal_id#</cfoutput>);
		location.reload();
	<cfelse>
		wrk_opener_reload();
		window.close();
	</cfif>
</script>

