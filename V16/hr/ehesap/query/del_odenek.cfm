<cfquery name="DEL_ODENEK_YEARS" datasource="#DSN#">
	DELETE FROM SETUP_PAYMENT_INTERRUPTION WHERE ODKES_ID = #URL.ODKES_ID#
</cfquery>
<script type="text/javascript">
	<cfif not isdefined("attributes.draggable")>
		wrk_opener_reload();
		window.close();
	<cfelse>
		closeBoxDraggable( '<cfoutput>#attributes.modal_id#</cfoutput>' );
		location.reload();
	</cfif>
</script>
