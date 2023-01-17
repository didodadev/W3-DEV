<cfquery name="del_class_trainer" datasource="#dsn#">
	DELETE FROM TRAINING_CLASS_TRAINERS WHERE ID = #attributes.id#
</cfquery>
<script type="text/javascript">
    <cfif isDefined("attributes.draggable")>
        closeBoxDraggable('<cfoutput>#attributes.modal_id#</cfoutput>');
        $("#trainer .catalyst-refresh").click();
    <cfelse>
        wrk_opener_reload();
	    window.close();
    </cfif>
</script>