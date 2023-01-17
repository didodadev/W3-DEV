<cfif thisTag.executionMode eq "start">
<script>
	document.getElementById('<cfoutput>#caller.last_table_id#_open_area</cfoutput>').style.display = 'block';
</script>
	<div style="clear:both;float:right; display:none;" id="<cfoutput>#caller.last_table_id#_search_div</cfoutput>">
<cfelse>
	</div>
</cfif>
