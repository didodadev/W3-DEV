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
            WOStruct['#attributes.fuseaction#']['list']['fuseaction'] = 'lab.test_parameters';
            WOStruct['#attributes.fuseaction#']['list']['filePath'] = 'WBP/Recycle/files/sample_analysis/display/list_test_parameters.cfm';
            WOStruct['#attributes.fuseaction#']['list']['queryPath'] = 'WBP/Recycle/files/sample_analysis/display/list_test_parameters.cfm';	

            
            WOStruct['#attributes.fuseaction#']['add'] = structNew();
            WOStruct['#attributes.fuseaction#']['add']['window'] = 'normal';
            WOStruct['#attributes.fuseaction#']['add']['fuseaction'] = 'lab.test_parameters&event=add';
            WOStruct['#attributes.fuseaction#']['add']['filePath'] = 'WBP/Recycle/files/sample_analysis/display/add_test_parameters.cfm';
        }
</cfscript>