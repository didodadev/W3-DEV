<cfscript>
    if(attributes.tabMenuController eq 0)
    {
        WOStruct = StructNew();
        
        WOStruct['#attributes.fuseaction#'] = structNew();
        
        WOStruct['#attributes.fuseaction#']['default'] = 'add';
        
        WOStruct['#attributes.fuseaction#']['add'] = structNew();
        WOStruct['#attributes.fuseaction#']['add']['window'] = 'normal';
        WOStruct['#attributes.fuseaction#']['add']['fuseaction'] = 'objects.release_notes_row';
        WOStruct['#attributes.fuseaction#']['add']['filePath'] = 'V16\objects\form\release_note_row.cfm';
        WOStruct['#attributes.fuseaction#']['add']['queryPath'] = 'V16\objects\query\release_note_row.cfm';

        if(isdefined("attributes.note_row_id"))
        {
            WOStruct['#attributes.fuseaction#']['upd'] = structNew();
            WOStruct['#attributes.fuseaction#']['upd']['window'] = 'normal';
            WOStruct['#attributes.fuseaction#']['upd']['fuseaction'] = 'objects.release_notes_row';
            WOStruct['#attributes.fuseaction#']['upd']['filePath'] = 'V16\objects\form\release_note_row.cfm';
            WOStruct['#attributes.fuseaction#']['upd']['queryPath'] = 'V16\objects\query\release_note_row.cfm';

            WOStruct['#attributes.fuseaction#']['del'] = structNew();
            WOStruct['#attributes.fuseaction#']['del']['window'] = 'emptypopup';
            WOStruct['#attributes.fuseaction#']['del']['fuseaction'] = '#request.self#?objects.release_notes_row&note_row_id=#attributes.note_row_id#';
            WOStruct['#attributes.fuseaction#']['del']['filePath'] = 'V16\objects\query\release_note_row.cfm';
            WOStruct['#attributes.fuseaction#']['del']['queryPath'] = 'V16\objects\query\release_note_row.cfm';

        }
    
    }
</cfscript>