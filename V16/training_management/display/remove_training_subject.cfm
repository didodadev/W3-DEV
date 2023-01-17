<cfset cfc = createObject('component','V16.training_management.cfc.training_groups')>
<cfset removeSubject = cfc.remove_training_group_subjects(
    train_group_id: attributes.train_group_id,
    train_id: attributes.train_id,
    subject_id: attributes.subject_id
)>
<cf_box title="Müfredatı Kaldır" scroll="1" collapsable="1" resize="1" popup_box="#iif(isdefined("attributes.draggable"),1,0)#">
    <script>
        <cfif isDefined("attributes.draggable")>
            closeBoxDraggable('remove_train_subject_box');
            $("#curriculum .catalyst-refresh").click();
        <cfelse>
            wrk_opener_reload();
            self.close();
        </cfif>
    </script>
</cf_box>