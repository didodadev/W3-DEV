<cflock timeout="60">
	<cftransaction>
		<cfloop list="#print_invoice_id#" index="i_invoice_id">
			<cfquery name="UPD_PRINT_COUNT" datasource="#DSN2#">
				UPDATE INVOICE SET ADD_FLAG = NULL, PRINT_COUNT = NULL WHERE INVOICE_ID = #i_invoice_id#
			</cfquery>
		</cfloop>
	</cftransaction>
</cflock>
<script type="text/javascript">
	wrk_opener_reload(); 
	self.close();
</script>

