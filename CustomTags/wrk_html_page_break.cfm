<cfif caller.active_table_draw_type eq 1>
	<cfif caller.is_auto_page_break eq 0>
		<cfset caller.newSheet.setRowBreak(caller.tr_satir_sayisi-1)>
	<cfelse>
	</cfif>
</cfif>
