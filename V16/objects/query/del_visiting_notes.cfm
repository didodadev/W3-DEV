<cfsetting showdebugoutput="no">
<cfquery name="DEL_NOTES" datasource="#DSN#">
	DELETE FROM
		VISITING_NOTES
	WHERE 
		V_NOTE_ID  = #attributes.note_id#
</cfquery>
 <cfif not isdefined('attributes.ajax')>
	<script type="text/javascript">
        window.close();
    </script>
<cfelse>
	<cfif isDefined("attributes.draggable") and attributes.draggable eq 1>
		<script type="text/javascript">
			closeBoxDraggable( '<cfoutput>#attributes.modal_id#</cfoutput>' , 'homebox_notes' );
		</script>
	</cfif>	
</cfif>