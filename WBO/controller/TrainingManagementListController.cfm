<cfscript>
    if(attributes.tabMenuController eq 0)
    {
        WOStruct = StructNew();
        WOStruct['#attributes.fuseaction#'] = structNew();
        WOStruct['#attributes.fuseaction#']['default'] = 'list';

        WOStruct['#attributes.fuseaction#']['list'] = structNew();
        WOStruct['#attributes.fuseaction#']['list']['window'] = 'normal';
        WOStruct['#attributes.fuseaction#']['list']['fuseaction'] = 'training_management.list_content';
        WOStruct['#attributes.fuseaction#']['list']['filePath'] = 'V16/content/display/dsp_list_content.cfm';
        WOStruct['#attributes.fuseaction#']['list']['queryPath'] = 'V16/content/display/dsp_list_content.cfm';
		
		
		

      }
</cfscript>