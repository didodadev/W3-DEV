<cfscript>
    if(attributes.tabMenuController eq 0)
    {
        WOStruct = StructNew();
        
        WOStruct['#attributes.fuseaction#'] = structNew();	
        
        WOStruct['#attributes.fuseaction#']['default'] = 'list';
        if(not isdefined('attributes.event')) 
            attributes.event = WOStruct['#attributes.fuseaction#']['default'];
    
        WOStruct['#attributes.fuseaction#']['list'] = structNew();
        WOStruct['#attributes.fuseaction#']['list']['window'] = 'normal';
        WOStruct['#attributes.fuseaction#']['list']['fuseaction'] ='recycle.loading_tasks';
        WOStruct['#attributes.fuseaction#']['list']['filePath'] ='WBP/Recycle/files/recycle_process/display/loading_tasks.cfm';
        WOStruct['#attributes.fuseaction#']['list']['queryPath'] ='';
        WOStruct['#attributes.fuseaction#']['list']['nextevent'] = '';	
    }
</cfscript>