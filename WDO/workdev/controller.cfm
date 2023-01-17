<cfscript>

    if(attributes.tabMenuController eq 0)
    {
		WOStruct = StructNew();

        WOStruct['#attributes.fuseaction#'] = StructNew();
        WOStruct['#attributes.fuseaction#']['default'] = 'layout';

        if (not isDefined('attributes.event'))
            attributes.event = WOStruct['#attributes.fuseaction#']['default'];

        WOStruct['#attributes.fuseaction#']['layout'] = structNew();
        WOStruct['#attributes.fuseaction#']['layout']['window'] = 'popup';
        WOStruct['#attributes.fuseaction#']['layout']['fuseaction'] = 'dev.workdev';
        WOStruct['#attributes.fuseaction#']['layout']['filePath'] = 'WDO/workdev/views/layout.cfm';

        WOStruct['#attributes.fuseaction#']['ajax-widget-list'] = structNew();
        WOStruct['#attributes.fuseaction#']['ajax-widget-list']['window'] = 'popup';
        WOStruct['#attributes.fuseaction#']['ajax-widget-list']['fuseaction'] = 'dev.workdev&event=ajax-widget-list&isAjax=1';
        WOStruct['#attributes.fuseaction#']['ajax-widget-list']['filePath'] = 'WDO/catalogs/designers/wrkdesigner/widget.cfm';

        WOStruct['#attributes.fuseaction#']['ajax-event-list'] = structNew();
        WOStruct['#attributes.fuseaction#']['ajax-event-list']['window'] = 'popup';
        WOStruct['#attributes.fuseaction#']['ajax-event-list']['fuseaction'] = 'dev.workdev&event=ajax-event-list&isAjax=1';
        WOStruct['#attributes.fuseaction#']['ajax-event-list']['filePath'] = 'WDO/catalogs/designers/wrkdesigner/event.cfm';

        /*
        WOStruct['#attributes.fuseaction#']['wrk'] = structNew();
        WOStruct['#attributes.fuseaction#']['wrk']['window'] = 'popup';
        WOStruct['#attributes.fuseaction#']['wrk']['fuseaction'] = 'dev.workdev';
        WOStruct['#attributes.fuseaction#']['RETIRED!!wrk']['filePath'] = 'WDO/modalWrkObject.cfm';

        WOStruct['#attributes.fuseaction#']['model'] = structNew();
        WOStruct['#attributes.fuseaction#']['model']['window'] = 'popup';
        WOStruct['#attributes.fuseaction#']['model']['fuseaction'] = 'dev.workdev';
        WOStruct['#attributes.fuseaction#']['RETIRED!!model']['filePath'] = 'WDO/modalModel.cfm';

        WOStruct['#attributes.fuseaction#']['widget'] = structNew();
        WOStruct['#attributes.fuseaction#']['widget']['window'] = 'popup';
        WOStruct['#attributes.fuseaction#']['widget']['fuseaction'] = 'dev.workdev';
        WOStruct['#attributes.fuseaction#']['RETIRED!!widget']['filePath'] = 'WDO/modalWidget.cfm';

        WOStruct['#attributes.fuseaction#']['controller'] = structNew();
        WOStruct['#attributes.fuseaction#']['controller']['window'] = 'popup';
        WOStruct['#attributes.fuseaction#']['controller']['fuseaction'] = 'dev.workdev';
        WOStruct['#attributes.fuseaction#']['RETIRED!!controller']['filePath'] = 'WDO/modalController.cfm';

        WOStruct['#attributes.fuseaction#']['trigger'] = structNew();
        WOStruct['#attributes.fuseaction#']['trigger']['window'] = 'popup';
        WOStruct['#attributes.fuseaction#']['trigger']['fuseaction'] = 'dev.workdev';
        WOStruct['#attributes.fuseaction#']['RETIRED!!trigger']['filePath'] = 'WDO/modalTrigger.cfm';

        WOStruct['#attributes.fuseaction#']['converter'] = structNew();
        WOStruct['#attributes.fuseaction#']['converter']['window'] = 'popup';
        WOStruct['#attributes.fuseaction#']['converter']['fuseaction'] = 'dev.workdev';
        WOStruct['#attributes.fuseaction#']['RETIRED!!converter']['filePath'] = 'WDO/modalConverter.cfm';

        WOStruct['#attributes.fuseaction#']['output'] = structNew();
        WOStruct['#attributes.fuseaction#']['output']['window'] = 'popup';
        WOStruct['#attributes.fuseaction#']['output']['fuseaction'] = 'dev.workdev';
        WOStruct['#attributes.fuseaction#']['RETIRED!!output']['filePath'] = 'WDO/modalOutput.cfm';

        WOStruct['#attributes.fuseaction#']['db'] = structNew();
        WOStruct['#attributes.fuseaction#']['db']['window'] = 'popup';
        WOStruct['#attributes.fuseaction#']['db']['fuseaction'] = 'dev.workdev';
        WOStruct['#attributes.fuseaction#']['RETIRED!!db']['filePath'] = 'WDO/modalDB.cfm';

        WOStruct['#attributes.fuseaction#']['bug'] = structNew();
        WOStruct['#attributes.fuseaction#']['bug']['window'] = 'popup';
        WOStruct['#attributes.fuseaction#']['bug']['fuseaction'] = 'dev.workdev';
        WOStruct['#attributes.fuseaction#']['RETIRED!!bug']['filePath'] = 'WDO/modalBugs.cfm';

        WOStruct['#attributes.fuseaction#']['support'] = structNew();
        WOStruct['#attributes.fuseaction#']['support']['window'] = 'popup';
        WOStruct['#attributes.fuseaction#']['support']['fuseaction'] = 'dev.workdev';
        WOStruct['#attributes.fuseaction#']['RETIRED!!support']['filePath'] = 'WDO/modalSupport.cfm';

        WOStruct['#attributes.fuseaction#']['icn'] = structNew();
        WOStruct['#attributes.fuseaction#']['icn']['window'] = 'popup';
        WOStruct['#attributes.fuseaction#']['icn']['fuseaction'] = 'dev.workdev';
        WOStruct['#attributes.fuseaction#']['RETIRED!!icn']['filePath'] = 'WDO/icons.cfm';
        */

    }

</cfscript>