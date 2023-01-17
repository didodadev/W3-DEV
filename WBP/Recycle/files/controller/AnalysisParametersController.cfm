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
        WOStruct['#attributes.fuseaction#']['add']['fuseaction'] ='recycle.analysis_parameters';
        WOStruct['#attributes.fuseaction#']['add']['filePath'] ='WBP/Recycle/files/sample_analysis/display/analysis_parameters.cfm';
        WOStruct['#attributes.fuseaction#']['add']['queryPath'] ='WBP/Recycle/files/sample_analysis/query/analysis_parameters_add.cfm';
        WOStruct['#attributes.fuseaction#']['add']['nextevent'] = '';	
    }
</cfscript>