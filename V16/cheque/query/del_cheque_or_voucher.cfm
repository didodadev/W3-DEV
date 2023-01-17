<cfif isDefined("attributes.cheque_id")>
	<cfquery name="del_cheque" datasource="#dsn2#">
		DELETE FROM CHEQUE WHERE CHEQUE_ID = #attributes.cheque_id#
	</cfquery>
	<cfquery name="del_cheque_hist" datasource="#dsn2#">
		DELETE FROM CHEQUE_HISTORY WHERE CHEQUE_ID = #attributes.cheque_id#
	</cfquery>
	<cfscript>cari_sil(action_id:attributes.cheque_id,process_type:106);</cfscript>
<cfelse>
	<cfquery name="del_voucher" datasource="#dsn2#">
		DELETE FROM VOUCHER WHERE VOUCHER_ID = #attributes.voucher_id#
	</cfquery>
	<cfquery name="del_voucher_hist" datasource="#dsn2#">
		DELETE FROM VOUCHER_HISTORY WHERE VOUCHER_ID = #attributes.voucher_id#
	</cfquery>
	<cfscript>cari_sil(action_id:attributes.voucher_id,process_type:107);</cfscript>
</cfif>
<script type="text/javascript">
	location.href = document.referrer;
	wrk_opener_reload();
	window.close();
</script>
