<!---15.03.21 Alper Çitmen - Sınıflara müfredat eklenmesi için oluşturuldu --->
<cfset cfc = createObject('component','V16.training_management.cfc.training_groups')>
<cfset get_training_group_subjects = cfc.get_training_group_subjects(TRAIN_GROUP_ID:attributes.TRAIN_GROUP_ID)>
<cfloop query="get_training_group_subjects">
    <cfif train_id eq attributes.train_id>
        <script>
            alert("<cfoutput><cf_get_lang dictionary_id='62387.Seçtiğiniz müfredat daha önce eklenmiş!'></cfoutput>");
            <cfif isDefined("attributes.draggable")>
                closeBoxDraggable(<cfoutput>#attributes.modal_id#</cfoutput>);
            <cfelse>
                window.close();
            </cfif>  
        </script>
        <cfabort>
    </cfif>
</cfloop>
<cflock name="CreateUUID()" timeout="20">
    <cftransaction>
        <cfset cfc = createObject('component','V16.training_management.cfc.training_groups')>
        <cfset training_group_subjects = cfc.add_training_group_subjects(
            TRAIN_GROUP_ID:attributes.TRAIN_GROUP_ID,
            TRAINING_SEC_ID:attributes.TRAINING_SEC_ID,
            TRAINING_CAT_ID:attributes.TRAINING_CAT_ID,
            TRAIN_ID:attributes.TRAIN_ID
        )>
    </cftransaction>
</cflock>
<script type="text/javascript">
    <cfif isDefined("attributes.draggable")>
        refresh_box('curriculum','index.cfm?fuseaction=objects.widget_loader&widget_load=listTrainSubjects&train_group_id=<cfoutput>#attributes.TRAIN_GROUP_ID#</cfoutput>','0');
        closeBoxDraggable(<cfoutput>#attributes.modal_id#</cfoutput>);
    <cfelse>
        window.opener.close();
        window.close();
    </cfif>  
</script>