<cfinclude template="./config.cfm">
<cfscript>

    route = 'worknet.companies';
    module = 'Companies';

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
        WOStruct['#attributes.fuseaction#']['add']['nextEvent'] = '#route#&event=det&cpid=';
        if (isDefined('attributes.cpid') and len(attributes.cpid))
            WOStruct['#attributes.fuseaction#']['add']['Identity'] = '#attributes.cpid#';

        WOStruct['#attributes.fuseaction#']['det'] = structNew();
        WOStruct['#attributes.fuseaction#']['det']['window'] = 'normal';
        WOStruct['#attributes.fuseaction#']['det']['fuseaction'] = '#route#&event=det&cpid=';
        WOStruct['#attributes.fuseaction#']['det']['filePath'] = '#addonViewsPath#/#module#/det.cfm';
        WOStruct['#attributes.fuseaction#']['det']['queryPath'] = '#addonQueriesPath#/#module#/upd.cfm';
        WOStruct['#attributes.fuseaction#']['det']['nextEvent'] = '#route#&event=det&cpid=';

        if (isDefined('attributes.cpid') and len(attributes.cpid))
            WOStruct['#attributes.fuseaction#']['det']['Identity'] = '#attributes.cpid#';

        //  PARTNER
        WOStruct['#attributes.fuseaction#']['list-partner'] = structNew();
        WOStruct['#attributes.fuseaction#']['list-partner']['window'] = 'normal';
        WOStruct['#attributes.fuseaction#']['list-partner']['fuseaction'] = '#route#&event=list-partner';
        WOStruct['#attributes.fuseaction#']['list-partner']['filePath'] = '#addonViewsPath#/#module#/list_partner.cfm';

        WOStruct['#attributes.fuseaction#']['add-partner'] = structNew();
        WOStruct['#attributes.fuseaction#']['add-partner']['window'] = 'normal';
        WOStruct['#attributes.fuseaction#']['add-partner']['fuseaction'] = '#route#&event=add-partner&compid=';
        WOStruct['#attributes.fuseaction#']['add-partner']['filePath'] = '#addonViewsPath#/#module#/add_partner.cfm';
        WOStruct['#attributes.fuseaction#']['add-partner']['queryPath'] = '#addonQueriesPath#/#module#/add_partner.cfm';
        WOStruct['#attributes.fuseaction#']['add-partner']['nextEvent'] = '#route#&event=det&cpid=';
        if (isDefined('attributes.cpid') and len(attributes.cpid))
            WOStruct['#attributes.fuseaction#']['add-partner']['Identity'] = '#attributes.cpid#';

        WOStruct['#attributes.fuseaction#']['det-partner'] = structNew();
        WOStruct['#attributes.fuseaction#']['det-partner']['window'] = 'normal';
        WOStruct['#attributes.fuseaction#']['det-partner']['fuseaction'] = '#route#&event=det-partner&pid=';
        WOStruct['#attributes.fuseaction#']['det-partner']['filePath'] = '#addonViewsPath#/#module#/det_partner.cfm';
        WOStruct['#attributes.fuseaction#']['det-partner']['queryPath'] = '#addonQueriesPath#/#module#/upd_partner.cfm';
        WOStruct['#attributes.fuseaction#']['det-partner']['nextEvent'] = '#route#&event=det&cpid=';
        if (isDefined('attributes.pid') and len(attributes.pid))
            WOStruct['#attributes.fuseaction#']['det-partner']['Identity'] = '#attributes.pid#';

        //  BRANCH
        WOStruct['#attributes.fuseaction#']['list-branch'] = structNew();
        WOStruct['#attributes.fuseaction#']['list-branch']['window'] = 'normal';
        WOStruct['#attributes.fuseaction#']['list-branch']['fuseaction'] = '#route#&event=list-branch';
        WOStruct['#attributes.fuseaction#']['list-branch']['filePath'] = '#addonViewsPath#/#module#/list_branch.cfm';
        
        WOStruct['#attributes.fuseaction#']['add-branch'] = structNew();
        WOStruct['#attributes.fuseaction#']['add-branch']['window'] = 'normal';
        WOStruct['#attributes.fuseaction#']['add-branch']['fuseaction'] = '#route#&event=add-branch';
        WOStruct['#attributes.fuseaction#']['add-branch']['filePath'] = '#addonViewsPath#/#module#/add_branch.cfm';
        WOStruct['#attributes.fuseaction#']['add-branch']['queryPath'] = '#addonQueriesPath#/#module#/add_branch.cfm';
        WOStruct['#attributes.fuseaction#']['add-branch']['nextEvent'] = '#route#&event=det&cpid=';

        WOStruct['#attributes.fuseaction#']['upd-branch'] = structNew();
        WOStruct['#attributes.fuseaction#']['upd-branch']['window'] = 'normal';
        WOStruct['#attributes.fuseaction#']['upd-branch']['fuseaction'] = '#route#&event=upd-branch&brid=';
        WOStruct['#attributes.fuseaction#']['upd-branch']['filePath'] = '#addonViewsPath#/#module#/upd_branch.cfm';
        WOStruct['#attributes.fuseaction#']['upd-branch']['queryPath'] = '#addonQueriesPath#/#module#/upd_branch.cfm';
        WOStruct['#attributes.fuseaction#']['upd-branch']['nextEvent'] = '#route#&event=det&cpid=';
        if (isDefined('attributes.brid') and len(attributes.brid))
            WOStruct['#attributes.fuseaction#']['upd-branch']['Identity'] = '#attributes.brid#';

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

        WOStruct['#attributes.fuseaction#']['det-relation-logo'] = structNew();
        WOStruct['#attributes.fuseaction#']['det-relation-logo']['window'] = 'popup';
        WOStruct['#attributes.fuseaction#']['det-relation-logo']['fuseaction'] = '#route#&event=det-relation-logo';
        WOStruct['#attributes.fuseaction#']['det-relation-logo']['filePath'] = '#addonViewsPath#/common/det_relation_logo.cfm';

        //  BRANDS
        WOStruct['#attributes.fuseaction#']['list-brands'] = structNew();
        WOStruct['#attributes.fuseaction#']['list-brands']['window'] = 'popup';
        WOStruct['#attributes.fuseaction#']['list-brands']['fuseaction'] = '#route#&event=list-brands';
        WOStruct['#attributes.fuseaction#']['list-brands']['filePath'] = '#addonViewsPath#/#module#/list_brands.cfm';

        WOStruct['#attributes.fuseaction#']['add-brands'] = structNew();
        WOStruct['#attributes.fuseaction#']['add-brands']['window'] = 'popup';
        WOStruct['#attributes.fuseaction#']['add-brands']['fuseaction'] = '#route#&event=add-brands';
        WOStruct['#attributes.fuseaction#']['add-brands']['filePath'] = '#addonViewsPath#/#module#/add_brands.cfm';

        WOStruct['#attributes.fuseaction#']['save-brands'] = structNew();
        WOStruct['#attributes.fuseaction#']['save-brands']['window'] = 'popup';
        WOStruct['#attributes.fuseaction#']['save-brands']['fuseaction'] = '#route#&event=save-brands';
        WOStruct['#attributes.fuseaction#']['save-brands']['filePath'] = '#addonQueriesPath#/#module#/save_brands.cfm';

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

            i = 0;
            tabMenuStruct['#fuseactController#']['tabMenus']['det']['menus'][i]['text'] = 'EK B&Iota;LG&Iota;LER';
            tabMenuStruct['#fuseactController#']['tabMenus']['det']['menus'][i]['href'] = "javascript:windowopen('#request.self#?fuseaction=objects.popup_list_comp_add_info&info_id=#url.cpid#&type_id=-1','list','popup_list_comp_add_info')";

            i = i+1;
            tabMenuStruct['#fuseactController#']['tabMenus']['det']['menus'][i]['text'] = 'PARTNER EKLE';
            tabMenuStruct['#fuseactController#']['tabMenus']['det']['menus'][i]['href'] = '#request.self#?fuseaction=#route#&event=add-partner&compid=#url.cpid#';

            i = i+1;
            tabMenuStruct['#fuseactController#']['tabMenus']['det']['menus'][i]['text'] = '&Scedil;UBE EKLE';
            tabMenuStruct['#fuseactController#']['tabMenus']['det']['menus'][i]['href'] = '#request.self#?fuseaction=#route#&event=add-branch&cpid=#url.cpid#';
        }
        else if (caller.attributes.event is 'add-partner') 
        {
            tabMenuStruct['#fuseactController#']['tabMenus']['add-partner']['icons'] = structNew();
            tabMenuStruct['#fuseactController#']['tabMenus']['add-partner']['icons']['list-ul']['target'] = '_self';
            tabMenuStruct['#fuseactController#']['tabMenus']['add-partner']['icons']['list-ul']['text'] = '#getLang('main', 97)#';
            tabMenuStruct['#fuseactController#']['tabMenus']['add-partner']['icons']['list-ul']['href'] = '#request.self#?fuseaction=#route#&event=det&cpid=#url.compid#';

            tabMenuStruct['#fuseactController#']['tabMenus']['add-partner']['icons']['check']['text'] = '#getLang('main', 49)#';
            tabMenuStruct['#fuseactController#']['tabMenus']['add-partner']['icons']['check']['onClick'] = 'buttonClickFunction()';
        }
        else if (caller.attributes.event is 'upd-partner')
        {
            tabMenuStruct['#fuseactController#']['tabMenus']['upd-partner']['icons'] = structNew();
            tabMenuStruct['#fuseactController#']['tabMenus']['upd-partner']['icons']['list-ul']['target'] = '_self';
            tabMenuStruct['#fuseactController#']['tabMenus']['upd-partner']['icons']['list-ul']['text'] = '#getLang('main', 97)#';
            tabMenuStruct['#fuseactController#']['tabMenus']['upd-partner']['icons']['list-ul']['href'] = '#request.self#?fuseaction=#route#&event=det&cpid=#url.cpid#';

            tabMenuStruct['#fuseactController#']['tabMenus']['upd-partner']['icons']['add']['target'] = '_self';
            tabMenuStruct['#fuseactController#']['tabMenus']['upd-partner']['icons']['add']['text'] = '#getLang('main', 170)#';
            tabMenuStruct['#fuseactController#']['tabMenus']['upd-partner']['icons']['add']['href'] = '#request.self#?fuseaction=#route#&event=add-partner&cpid=#url.cpid#';

            tabMenuStruct['#fuseactController#']['tabMenus']['upd-partner']['icons']['check']['text'] = '#getLang('main', 49)#';
            tabMenuStruct['#fuseactController#']['tabMenus']['upd-partner']['icons']['check']['onClick'] = 'buttonClickFunction()';
        }
        else if (caller.attributes.event is 'add-branch')
        {
            tabMenuStruct['#fuseactController#']['tabMenus']['add-branch']['icons'] = structNew();
            tabMenuStruct['#fuseactController#']['tabMenus']['add-branch']['icons']['list-ul']['target'] = '_self';
            tabMenuStruct['#fuseactController#']['tabMenus']['add-branch']['icons']['list-ul']['text'] = '#getLang('main', 97)#';
            tabMenuStruct['#fuseactController#']['tabMenus']['add-branch']['icons']['list-ul']['href'] = '#request.self#?fuseaction=#route#&event=det&cpid=#url.cpid#';

            tabMenuStruct['#fuseactController#']['tabMenus']['add-branch']['icons']['check']['text'] = '#getLang('main', 170)#';
            tabMenuStruct['#fuseactController#']['tabMenus']['add-branch']['icons']['check']['onClick'] = 'buttonClickFunction()';
        }
        else if (caller.attributes.event is 'upd-branch')
        {
            tabMenuStruct['#fuseactController#']['tabMenus']['upd-branch']['icons'] = structNew();
            tabMenuStruct['#fuseactController#']['tabMenus']['upd-branch']['icons']['list-ul']['target'] = '_self';
            tabMenuStruct['#fuseactController#']['tabMenus']['upd-branch']['icons']['list-ul']['text'] = '#getLang('main', 97)#';
            tabMenuStruct['#fuseactController#']['tabMenus']['upd-branch']['icons']['list-ul']['href'] = '#request.self#?fuseaction=#route#&event=det&cpid=#url.cpid#';

            tabMenuStruct['#fuseactController#']['tabMenus']['upd-branch']['icons']['add']['target'] = '_self';
            tabMenuStruct['#fuseactController#']['tabMenus']['upd-branch']['icons']['add']['text'] = '#getLang('main', 170)#';
            tabMenuStruct['#fuseactController#']['tabMenus']['upd-branch']['icons']['add']['href'] = '#request.self#?fuseaction=#route#&event=add-branch&cpid=#url.cpid#';

            tabMenuStruct['#fuseactController#']['tabMenus']['upd-branch']['icons']['check']['text'] = '#getLang('main', 170)#';
            tabMenuStruct['#fuseactController#']['tabMenus']['upd-branch']['icons']['check']['onClick'] = 'buttonClickFunction()';
        }

        tabMenuData = SerializeJSON(tabMenuStruct['#fuseactController#']['tabMenus']);
    }
</cfscript>