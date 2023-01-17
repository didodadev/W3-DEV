<cfscript>
    if(attributes.tabMenuController eq 0)
	    {
            WOStruct = StructNew();

            WOStruct['#attributes.fuseaction#'] = structNew();

            WOStruct['#attributes.fuseaction#']['default'] = 'list';

            WOStruct['#attributes.fuseaction#']['list'] = structNew();
		    WOStruct['#attributes.fuseaction#']['list']['window'] = 'normal';
            WOStruct['#attributes.fuseaction#']['list']['filePath'] = 'V16/myhome/display/welcome_crm.cfm';
            WOStruct['#attributes.fuseaction#']['list']['fuseaction'] = 'myhome.welcome_crm';
        }
</cfscript>
