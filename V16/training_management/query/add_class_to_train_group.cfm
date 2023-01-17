<cfscript>
    addClassToTrainGroup = createObject("component","V16.training_management.cfc.training_groups");
    addClassToTrainGroup.dsn = dsn;
    addClassToTrainingGroup = addClassToTrainGroup.addClassToTrainingGroup
    (
        train_group_id : attributes.train_group_id,
        class_id : attributes.class_id
    );
</cfscript>
<script type="text/javascript">
    <cfif isdefined("attributes.draggable")>
        closeBoxDraggable( 'add_training_group_box' );
        $("#training_groups .catalyst-refresh").click();
    <cfelse>
        window.onbeforeunload = function (e) {
            window.opener.refresh_box('training_groups','index.cfm?fuseaction=training_management.emptypopup_upd_class_training_groups_ajax&class_id=<cfoutput>#class_id#</cfoutput>','0');
        };
        window.close();
    </cfif>
</script>