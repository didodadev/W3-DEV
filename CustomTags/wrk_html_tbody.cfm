<cfif thisTag.executionMode eq "start">
	<cfif caller.active_table_draw_type eq 0>
		<cfoutput>
			<tbody>
		</cfoutput>
	</cfif>
<cfelse>
	<cfif caller.active_table_draw_type eq 0>	
		</tbody>		
	</cfif>
</cfif>
