<cfquery name="DEL_NOTE" datasource="#DSN#">
	DELETE FROM
		NOTES
	WHERE 
		NOTE_ID = #attributes.note_id#
</cfquery>

<script>
	<cfif isDefined('attributes.draggable')>
		closeBoxDraggable(<cfoutput>#attributes.modal_id#</cfoutput>,'unique_get_notes');
	<cfelse>
		location.href = document.referrer;
	</cfif>
</script>
