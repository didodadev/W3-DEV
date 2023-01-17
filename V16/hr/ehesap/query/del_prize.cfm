<cfquery name="DEL_PRIZE" datasource="#DSN#">
	DELETE FROM EMPLOYEES_PRIZE WHERE PRIZE_ID = #attributes.PRIZE_ID#
</cfquery>

<script type="text/javascript">
	<cfif not isdefined("attributes.draggable")>location.href = document.referrer;<cfelse>closeBoxDraggable( '<cfoutput>#attributes.modal_id#</cfoutput>');</cfif>
</script>
