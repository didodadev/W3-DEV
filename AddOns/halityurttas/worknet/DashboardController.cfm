<cfinclude template="./config.cfm">
<cfscript>

    route = 'worknet.dashboard';
    module = 'Dashboard';

    if (attributes.tabMenuController eq 0) {
        
        WOStruct = structNew();
        
        WOStruct['#attributes.fuseaction#'] = structNew();

        WOStruct['#attributes.fuseaction#']['default'] = 'list';
        if (not isDefined('attributes.event'))
            attributes.event = WOStruct['#attributes.fuseaction#']['default'];

        
        WOStruct['#attributes.fuseaction#']['list'] = structNew();
        WOStruct['#attributes.fuseaction#']['list']['window'] = 'normal';
        WOStruct['#attributes.fuseaction#']['list']['fuseaction'] = '#route#';
        WOStruct['#attributes.fuseaction#']['list']['filePath'] = '#addonViewsPath#/#module#/list.cfm';

        WOStruct['#attributes.fuseaction#']['companies'] = structNew();
        WOStruct['#attributes.fuseaction#']['companies']['window'] = 'popup';
        WOStruct['#attributes.fuseaction#']['companies']['fuseaction'] = '#route#&event=companies';
        WOStruct['#attributes.fuseaction#']['companies']['filePath'] = '#addonViewsPath#/#module#/member.cfm';

        WOStruct['#attributes.fuseaction#']['products'] = structNew();
        WOStruct['#attributes.fuseaction#']['products']['window'] = 'popup';
        WOStruct['#attributes.fuseaction#']['products']['fuseaction'] = '#route#&event=products';
        WOStruct['#attributes.fuseaction#']['products']['filePath'] = '#addonViewsPath#/#module#/product.cfm';

        WOStruct['#attributes.fuseaction#']['catalogs'] = structNew();
        WOStruct['#attributes.fuseaction#']['catalogs']['window'] = 'popup';
        WOStruct['#attributes.fuseaction#']['catalogs']['fuseaction'] = '#route#&event=catalogs';
        WOStruct['#attributes.fuseaction#']['catalogs']['filePath'] = '#addonViewsPath#/#module#/catalog.cfm';

        WOStruct['#attributes.fuseaction#']['demands'] = structNew();
        WOStruct['#attributes.fuseaction#']['demands']['window'] = 'popup';
        WOStruct['#attributes.fuseaction#']['demands']['fuseaction'] = '#route#&event=demands';
        WOStruct['#attributes.fuseaction#']['demands']['filePath'] = '#addonViewsPath#/#module#/demand.cfm';

        WOStruct['#attributes.fuseaction#']['interactions'] = structNew();
        WOStruct['#attributes.fuseaction#']['interactions']['window'] = 'popup';
        WOStruct['#attributes.fuseaction#']['interactions']['fuseaction'] = '#route#&event=interactions';
        WOStruct['#attributes.fuseaction#']['interactions']['filePath'] = '#addonViewsPath#/#module#/interaction.cfm';

        WOStruct['#attributes.fuseaction#']['chart'] = structNew();
        WOStruct['#attributes.fuseaction#']['chart']['window'] = 'popup';
        WOStruct['#attributes.fuseaction#']['chart']['fuseaction'] = '#route#&event=chart';
        WOStruct['#attributes.fuseaction#']['chart']['filePath'] = '#addonViewsPath#/#module#/chart.cfm';

        //  RELATIONS
        WOStruct['#attributes.fuseaction#']['companies-relation'] = { fuseaction = "worknet.companies&event=det&cpid=" };
        WOStruct['#attributes.fuseaction#']['companies-list'] = { fuseaction = "worknet.companies&form_submitted=1&is_potential=1&sortfield=RECORD_DATE&sortdir=desc" };
        WOStruct['#attributes.fuseaction#']['products-relation'] = { fuseaction = "worknet.products&event=det&pid=" };
        WOStruct['#attributes.fuseaction#']['products-list'] = { fuseaction = "worknet.products&form_submitted=1&is_catalog=0" };
        WOStruct['#attributes.fuseaction#']['catalogs-relation'] = { fuseaction = "worknet.products&event=det&pid=" };
        WOStruct['#attributes.fuseaction#']['catalogs-list'] = { fuseaction = "worknet.products&form_submitted=1&is_catalog=1" };
        WOStruct['#attributes.fuseaction#']['demands-relation'] = { fuseaction = "worknet.demands&event=det&demand_id=" };
        WOStruct['#attributes.fuseaction#']['demands-list'] = { fuseaction = "worknet.demands&form_submitted=1" };
        WOStruct['#attributes.fuseaction#']['interactions-list'] = { fuseaction = "call.helpdesk&form_submitted=1&ordertype=3" };
        WOStruct['#attributes.fuseaction#']['interactions-relation'] = { fuseaction = "call.helpdesk&event=upd&cus_help_id=" };
    }

</cfscript>