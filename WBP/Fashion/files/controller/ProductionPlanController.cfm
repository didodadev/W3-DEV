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
        WOStruct['#attributes.fuseaction#']['list']['filePath'] = '/WBP/Fashion/files/production/display/list_order_plans.cfm';

		WOStruct['#attributes.fuseaction#']['measurement'] = structNew();
        WOStruct['#attributes.fuseaction#']['measurement']['window'] = 'normal';
        WOStruct['#attributes.fuseaction#']['measurement']['fuseaction'] = 'textile.tracking&event=measurement';
        WOStruct['#attributes.fuseaction#']['measurement']['filePath'] = '/WBP/Fashion/files/production/display/measurement.cfm';
		WOStruct['#attributes.fuseaction#']['measurement']['queryPath'] = '/WBP/Fashion/files/production/query/measurement.cfm';
        WOStruct['#attributes.fuseaction#']['measurement']['nextEvent'] = '/WBP/Fashion/files/production/display/measurement.cfm';

        WOStruct['#attributes.fuseaction#']['measurementQuery'] = structNew();
        WOStruct['#attributes.fuseaction#']['measurementQuery']['window'] = 'normal';
        WOStruct['#attributes.fuseaction#']['measurementQuery']['fuseaction'] = 'textile.tracking&event=measurement';
        WOStruct['#attributes.fuseaction#']['measurementQuery']['filePath'] = '/WBP/Fashion/files/production/query/measurement.cfm';
		WOStruct['#attributes.fuseaction#']['measurementQuery']['queryPath'] = '/WBP/Fashion/files/production/query/measurement.cfm';
        WOStruct['#attributes.fuseaction#']['measurementQuery']['nextEvent'] = 'textile.operations&req_id=';

        WOStruct['#attributes.fuseaction#']['measurementDel'] = structNew();
        WOStruct['#attributes.fuseaction#']['measurementDel']['window'] = 'normal';
        WOStruct['#attributes.fuseaction#']['measurementDel']['fuseaction'] = 'textile.tracking&event=measurementDel';
        WOStruct['#attributes.fuseaction#']['measurementDel']['filePath'] = '/WBP/Fashion/files/production/query/measurement.cfm';
		WOStruct['#attributes.fuseaction#']['measurementDel']['queryPath'] = '/WBP/Fashion/files/production/query/measurement.cfm';
        WOStruct['#attributes.fuseaction#']['measurementDel']['nextEvent'] = 'textile.tracking&req_id=';
        
        WOStruct['#attributes.fuseaction#']['material'] = structNew();
        WOStruct['#attributes.fuseaction#']['material']['window'] = 'normal';
        WOStruct['#attributes.fuseaction#']['material']['fuseaction'] = 'textile.tracking&event=measurement';
        WOStruct['#attributes.fuseaction#']['material']['filePath'] = '/WBP/Fashion/files/production/form/form_material.cfm';
		WOStruct['#attributes.fuseaction#']['material']['queryPath'] = '/WBP/Fashion/files/production/form/form_material.cfm';
        WOStruct['#attributes.fuseaction#']['material']['nextEvent'] = '/WBP/Fashion/files/production/form/form_material.cfm';

    
    
    }

</cfscript>