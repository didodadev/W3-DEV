<cfinclude template="./config.cfm">
<cfscript>

    route = 'worknet.demands';
    module = 'Demands';

    if (attributes.tabMenuController eq 0) {
        
        WOStruct = structNew();
        
        WOStruct['#attributes.fuseaction#'] = structNew();

        WOStruct['#attributes.fuseaction#']['default'] = 'list';
        if (not isDefined('attributes.event'))
            attributes.event = WOStruct['#attributes.fuseaction#']['default'];

        //  COMPANY
        WOStruct['#attributes.fuseaction#']['list'] = structNew();
        WOStruct['#attributes.fuseaction#']['list']['window'] = 'normal';
        WOStruct['#attributes.fuseaction#']['list']['fuseaction'] = '#route#';
        WOStruct['#attributes.fuseaction#']['list']['filePath'] = '#addonViewsPath#/#module#/list.cfm';

        WOStruct['#attributes.fuseaction#']['add'] = structNew();
        WOStruct['#attributes.fuseaction#']['add']['window'] = 'normal';
        WOStruct['#attributes.fuseaction#']['add']['fuseaction'] = '#route#&event=add';
        WOStruct['#attributes.fuseaction#']['add']['filePath'] = '#addonViewsPath#/#module#/add.cfm';
        WOStruct['#attributes.fuseaction#']['add']['queryPath'] = '#addonQueriesPath#/#module#/add.cfm';
        WOStruct['#attributes.fuseaction#']['add']['nextEvent'] = '#route#&event=det&demand_id=';
        if (isDefined('attributes.cpid') and len(attributes.demand_id))
            WOStruct['#attributes.fuseaction#']['add']['Identity'] = '#attributes.demand_id#';

        WOStruct['#attributes.fuseaction#']['det'] = structNew();
        WOStruct['#attributes.fuseaction#']['det']['window'] = 'normal';
        WOStruct['#attributes.fuseaction#']['det']['fuseaction'] = '#route#&event=det&demand_id=';
        WOStruct['#attributes.fuseaction#']['det']['filePath'] = '#addonViewsPath#/#module#/det.cfm';
        WOStruct['#attributes.fuseaction#']['det']['queryPath'] = '#addonQueriesPath#/#module#/upd.cfm';
        WOStruct['#attributes.fuseaction#']['det']['nextEvent'] = '#route#&event=det&demand_id=';

        if (isDefined('attributes.cpid') and len(attributes.demand_id))
            WOStruct['#attributes.fuseaction#']['det']['Identity'] = '#attributes.demand_id#';

        WOStruct['#attributes.fuseaction#']['del'] = structNew();
        WOStruct['#attributes.fuseaction#']['del']['window'] = 'popup';
        WOStruct['#attributes.fuseaction#']['del']['fuseaction'] = '#route#&event=del&demand_id=';
        WOStruct['#attributes.fuseaction#']['del']['filePath'] = '#addonQueriesPath#/#module#/del.cfm';
        WOStruct['#attributes.fuseaction#']['del']['queryPath'] = '#addonQueriesPath#/#module#/del.cfm';
        WOStruct['#attributes.fuseaction#']['del']['nextEvent'] = '#route#';

        //  OFFERS
        WOStruct['#attributes.fuseaction#']['list-offer'] = structNew();
        WOStruct['#attributes.fuseaction#']['list-offer']['window'] = 'popup';
        WOStruct['#attributes.fuseaction#']['list-offer']['fuseaction'] = '#route#&event=list-offer&demand_id=';
        WOStruct['#attributes.fuseaction#']['list-offer']['filePath'] = '#addonViewsPath#/#module#/list_offer.cfm';

        WOStruct['#attributes.fuseaction#']['add-offer'] = structNew();
        WOStruct['#attributes.fuseaction#']['add-offer']['window'] = 'popup';
        WOStruct['#attributes.fuseaction#']['add-offer']['fuseaction'] = '#route#&event=add-offer&demand_id=';
        WOStruct['#attributes.fuseaction#']['add-offer']['filePath'] = '#addonViewsPath#/#module#/add_offer.cfm';
        WOStruct['#attributes.fuseaction#']['add-offer']['queryPath'] = '#addonQueriesPath#/#module#/add_offer.cfm';
        WOStruct['#attributes.fuseaction#']['add-offer']['nextEvent'] = '#route#&event=list-offer&demand_id=';

        WOStruct['#attributes.fuseaction#']['create-offer'] = structNew();
        WOStruct['#attributes.fuseaction#']['create-offer']['window'] = 'popup';
        WOStruct['#attributes.fuseaction#']['create-offer']['fuseaction'] = '#route#&event=create-offer&demand_id=';
        WOStruct['#attributes.fuseaction#']['create-offer']['filePath'] = WOStruct['#attributes.fuseaction#']['add-offer']['queryPath'];
        WOStruct['#attributes.fuseaction#']['create-offer']['nextEvent'] = WOStruct['#attributes.fuseaction#']['add-offer']['nextEvent'];

        WOStruct['#attributes.fuseaction#']['det-offer'] = structNew();
        WOStruct['#attributes.fuseaction#']['det-offer']['window'] = 'popup';
        WOStruct['#attributes.fuseaction#']['det-offer']['fuseaction'] = '#route#&event=det-offer&demand_offer_id=';
        WOStruct['#attributes.fuseaction#']['det-offer']['filePath'] = '#addonViewsPath#/#module#/det_offer.cfm';


        //  ASSETS
        WOStruct['#attributes.fuseaction#']['list-relation-asset'] = structNew();
        WOStruct['#attributes.fuseaction#']['list-relation-asset']['window'] = 'popup';
        WOStruct['#attributes.fuseaction#']['list-relation-asset']['fuseaction'] = '#route#&event=list-relation-asset';
        WOStruct['#attributes.fuseaction#']['list-relation-asset']['filePath'] = '#addonViewsPath#/common/list_relation_asset.cfm';

        WOStruct['#attributes.fuseaction#']['add-relation-asset'] = structNew();
        WOStruct['#attributes.fuseaction#']['add-relation-asset']['window'] = 'popup';
        WOStruct['#attributes.fuseaction#']['add-relation-asset']['fuseaction'] = '#route#&event=add-relation-asset';
        WOStruct['#attributes.fuseaction#']['add-relation-asset']['filePath'] = '#addonViewsPath#/common/add_relation_asset.cfm';

        WOStruct['#attributes.fuseaction#']['save-relation-asset'] = structNew();
        WOStruct['#attributes.fuseaction#']['save-relation-asset']['window'] = 'popup';
        WOStruct['#attributes.fuseaction#']['save-relation-asset']['fuseaction'] = '#route#&event=save-relation-asset';
        WOStruct['#attributes.fuseaction#']['save-relation-asset']['filePath'] = '#addonQueriesPath#/common/save_relation_asset.cfm';

        //register other referances
        WOStruct['#attributes.fuseaction#']['company'] = { fuseaction = 'worknet.companies&event=det&cpid=' } ;
        WOStruct['#attributes.fuseaction#']['partner'] = { fuseaction = 'worknet.companies&event=det-partner&pid=' };

    }
    else 
    {
        fuseactController = caller.attributes.fuseaction;
        getLang = caller.getLang;

        tabMenuStruct = structNew();
        tabMenuStruct['#fuseactController#'] = structNew();
        tabMenuStruct['#fuseactController#']['tabMenus'] = structNew();

        if (caller.attributes.event is 'add')
        {
            tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons'] = structNew();
            tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['list-ul']['target'] = '_self';
            tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['list-ul']['text'] = '#getLang('main', 97)#';
            tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['list-ul']['href'] = "#request.self#?fuseaction=#route#";

            tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['check']['text'] = '#getLang('main', 49)#';
            tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['check']['onClick'] = 'buttonClickFunction()';
        }
        else if (caller.attributes.event is 'det') 
        {
            tabMenuStruct['#fuseactController#']['tabMenus']['det']['icons'] = structNew();
            tabMenuStruct['#fuseactController#']['tabMenus']['det']['icons']['list-ul']['target'] = '_self';
            tabMenuStruct['#fuseactController#']['tabMenus']['det']['icons']['list-ul']['text'] = '#getLang('main', 97)#';
            tabMenuStruct['#fuseactController#']['tabMenus']['det']['icons']['list-ul']['href'] = "#request.self#?fuseaction=#route#";
            
            tabMenuStruct['#fuseactController#']['tabMenus']['det']['icons']['add']['target'] = '_self';
            tabMenuStruct['#fuseactController#']['tabMenus']['det']['icons']['add']['text'] = '#getLang('main', 170)#';
            tabMenuStruct['#fuseactController#']['tabMenus']['det']['icons']['add']['href'] = "#request.self#?fuseaction=#route#&event=add";

            tabMenuStruct['#fuseactController#']['tabMenus']['det']['icons']['check']['text'] = '#getLang('main', 49)#';
            tabMenuStruct['#fuseactController#']['tabMenus']['det']['icons']['check']['onClick'] = 'buttonClickFunction()';

        }


        tabMenuData = SerializeJSON(tabMenuStruct['#fuseactController#']['tabMenus']);
    }


</cfscript>