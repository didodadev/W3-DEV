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
        WOStruct['#attributes.fuseaction#']['list']['fuseaction'] ='recycle.works';
        WOStruct['#attributes.fuseaction#']['list']['filePath'] ='WBP/Recycle/files/objects/display/works.cfm';
        WOStruct['#attributes.fuseaction#']['list']['queryPath'] ='';
        WOStruct['#attributes.fuseaction#']['list']['nextevent'] = '';	
    }
</cfscript>