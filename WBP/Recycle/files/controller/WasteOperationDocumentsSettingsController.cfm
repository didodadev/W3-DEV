<cfscript>
    if(attributes.tabMenuController eq 0)
    {
        WOStruct = StructNew();
        
        WOStruct['#attributes.fuseaction#'] = structNew();	
        
        WOStruct['#attributes.fuseaction#']['default'] = 'add';
        if(not isdefined('attributes.event')) 
            attributes.event = WOStruct['#attributes.fuseaction#']['default'];
    
        WOStruct['#attributes.fuseaction#']['add'] = structNew();
        WOStruct['#attributes.fuseaction#']['add']['window'] = 'normal';
        WOStruct['#attributes.fuseaction#']['add']['fuseaction'] ='recycle.waste_operation_documents_settings';
        WOStruct['#attributes.fuseaction#']['add']['filePath'] ='WBP/Recycle/files/waste_operation/form/waste_operation_documents_settings.cfm';
        WOStruct['#attributes.fuseaction#']['add']['queryPath'] ='WBP/Recycle/files/waste_operation/query/waste_operation_documents_settings.cfm';
        WOStruct['#attributes.fuseaction#']['add']['nextevent'] = '';	
    }
</cfscript>