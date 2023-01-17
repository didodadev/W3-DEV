<cfscript>
    if(attributes.tabMenuController eq 0)
	    {
            WOStruct = StructNew();

            WOStruct['#attributes.fuseaction#'] = structNew();

            WOStruct['#attributes.fuseaction#']['default'] = 'list';

            WOStruct['#attributes.fuseaction#']['list'] = structNew();
		    WOStruct['#attributes.fuseaction#']['list']['window'] = 'normal';
            WOStruct['#attributes.fuseaction#']['list']['filePath'] = 'V16/report/standart/project_summary.cfm';
            WOStruct['#attributes.fuseaction#']['list']['fuseaction'] = 'report.project_summary';
        }
</cfscript>
