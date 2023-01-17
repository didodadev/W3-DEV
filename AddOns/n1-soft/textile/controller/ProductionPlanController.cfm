<cfscript>

    if (attributes.tabMenuController eq 0)
    {

        WOStruct = structNew();

        WOStruct['#attributes.fuseaction#'] = structNew();

        WOStruct['#attributes.fuseaction#']['default'] = 'list';
        if (not isDefined('attributes.event'))
            attributes.event = WOStruct['#attributes.fuseaction#']['default'];

        WOStruct['#attributes.fuseaction#']['list'] = structNew();
        WOStruct['#attributes.fuseaction#']['list']['window'] = 'normal';
        WOStruct['#attributes.fuseaction#']['list']['fuseaction'] = 'textile.tracking';
        WOStruct['#attributes.fuseaction#']['list']['filePath'] = '/AddOns/N1-Soft/textile/production/display/list_order_plans.cfm';

		WOStruct['#attributes.fuseaction#']['measurement'] = structNew();
        WOStruct['#attributes.fuseaction#']['measurement']['window'] = 'normal';
        WOStruct['#attributes.fuseaction#']['measurement']['fuseaction'] = 'textile.tracking&event=measurement';
        WOStruct['#attributes.fuseaction#']['measurement']['filePath'] = '/AddOns/N1-Soft/textile/production/display/measurement.cfm';
		WOStruct['#attributes.fuseaction#']['measurement']['queryPath'] = '/AddOns/N1-Soft/textile/production/query/measurement.cfm';
        WOStruct['#attributes.fuseaction#']['measurement']['nextEvent'] = '/AddOns/N1-Soft/textile/production/display/measurement.cfm';

        WOStruct['#attributes.fuseaction#']['measurementQuery'] = structNew();
        WOStruct['#attributes.fuseaction#']['measurementQuery']['window'] = 'normal';
        WOStruct['#attributes.fuseaction#']['measurementQuery']['fuseaction'] = 'textile.tracking&event=measurement';
        WOStruct['#attributes.fuseaction#']['measurementQuery']['filePath'] = '/AddOns/N1-Soft/textile/production/query/measurement.cfm';
		WOStruct['#attributes.fuseaction#']['measurementQuery']['queryPath'] = '/AddOns/N1-Soft/textile/production/query/measurement.cfm';
        WOStruct['#attributes.fuseaction#']['measurementQuery']['nextEvent'] = 'textile.operations&req_id=';

        WOStruct['#attributes.fuseaction#']['measurementDel'] = structNew();
        WOStruct['#attributes.fuseaction#']['measurementDel']['window'] = 'normal';
        WOStruct['#attributes.fuseaction#']['measurementDel']['fuseaction'] = 'textile.tracking&event=measurementDel';
        WOStruct['#attributes.fuseaction#']['measurementDel']['filePath'] = '/AddOns/N1-Soft/textile/production/query/measurement.cfm';
		WOStruct['#attributes.fuseaction#']['measurementDel']['queryPath'] = '/AddOns/N1-Soft/textile/production/query/measurement.cfm';
        WOStruct['#attributes.fuseaction#']['measurementDel']['nextEvent'] = 'textile.tracking&req_id=';
        
        WOStruct['#attributes.fuseaction#']['material'] = structNew();
        WOStruct['#attributes.fuseaction#']['material']['window'] = 'normal';
        WOStruct['#attributes.fuseaction#']['material']['fuseaction'] = 'textile.tracking&event=measurement';
        WOStruct['#attributes.fuseaction#']['material']['filePath'] = '/AddOns/N1-Soft/textile/production/form/form_material.cfm';
		WOStruct['#attributes.fuseaction#']['material']['queryPath'] = '/AddOns/N1-Soft/textile/production/form/form_material.cfm';
        WOStruct['#attributes.fuseaction#']['material']['nextEvent'] = '/AddOns/N1-Soft/textile/production/form/form_material.cfm';

    
    
    }

</cfscript>