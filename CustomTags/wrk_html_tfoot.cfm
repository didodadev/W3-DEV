<cfif thisTag.executionMode eq "start">
	<cfif caller.active_table_draw_type eq 0>
		<cfoutput>
			<tfoot>
		</cfoutput>
	</cfif>
<cfelse>
	<cfif caller.active_table_draw_type eq 0>	
		</tfoot>		
	</cfif>
</cfif>
