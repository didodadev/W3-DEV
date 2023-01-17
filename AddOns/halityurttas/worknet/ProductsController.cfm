<cfinclude template="config.cfm">
<cfscript>

    route = 'worknet.products';
    module = 'Products';

    if (attributes.tabMenuController eq 0)
    {
        WOStruct['#attributes.fuseaction#'] = structNew();

        WOStruct['#attributes.fuseaction#']['default'] = 'list';
        if (not isDefined('attributes.event'))
            attributes.event = WOStruct['#attributes.fuseaction#']['default'];

        WOStruct['#attributes.fuseaction#']['list'] = structNew();
        WOStruct['#attributes.fuseaction#']['list']['window'] = 'normal';
        WOStruct['#attributes.fuseaction#']['list']['fuseaction'] = '#route#';
        WOStruct['#attributes.fuseaction#']['list']['filePath'] = '#addonViewsPath#/#module#/list.cfm';

        WOStruct['#attributes.fuseaction#']['add'] = structNew();
        WOStruct['#attributes.fuseaction#']['add']['window'] = 'normal';
        WOStruct['#attributes.fuseaction#']['add']['fuseaction'] = '#route#&event=add';
        WOStruct['#attributes.fuseaction#']['add']['filePath'] = '#addonViewsPath#/#module#/add.cfm';
        WOStruct['#attributes.fuseaction#']['add']['queryPath'] = '#addonQueriesPath#/#module#/add.cfm';
        WOStruct['#attributes.fuseaction#']['add']['nextEvent'] = '#route#&event=upd&pid=';
        
        WOStruct['#attributes.fuseaction#']['det'] = structNew();
        WOStruct['#attributes.fuseaction#']['det']['window'] = 'normal';
        WOStruct['#attributes.fuseaction#']['det']['fuseaction'] = '#route#&event=det&pid=';
        WOStruct['#attributes.fuseaction#']['det']['filePath'] = '#addonViewsPath#/#module#/det.cfm';
        WOStruct['#attributes.fuseaction#']['det']['queryPath'] = '#addonQueriesPath#/#module#/upd.cfm';
        WOStruct['#attributes.fuseaction#']['det']['nextEvent'] = '#route#&event=det&pid=';

        WOStruct['#attributes.fuseaction#']['del'] = structNew();
        WOStruct['#attributes.fuseaction#']['del']['window'] = 'normal';
        WOStruct['#attributes.fuseaction#']['del']['fuseaction'] = '#route#&event=del&pid=';
        WOStruct['#attributes.fuseaction#']['del']['filePath'] = '#addonQueriesPath#/#module#/del.cfm';
        WOStruct['#attributes.fuseaction#']['del']['queryPath'] = '#addonQueriesPath#/#module#/del.cfm';
        WOStruct['#attributes.fuseaction#']['del']['nextEvent'] = '#route#';

        /// katalog
        WOStruct['#attributes.fuseaction#']['list-catalog'] = structNew();
        WOStruct['#attributes.fuseaction#']['list-catalog']['window'] = 'normal';
        WOStruct['#attributes.fuseaction#']['list-catalog']['fuseaction'] = '#route#&event=list-catalog';
        WOStruct['#attributes.fuseaction#']['list-catalog']['filePath'] = '#addonViewsPath#/#module#/list.cfm';
        
        WOStruct['#attributes.fuseaction#']['add-catalog'] = structNew();
        WOStruct['#attributes.fuseaction#']['add-catalog']['window'] = 'normal';
        WOStruct['#attributes.fuseaction#']['add-catalog']['fuseaction'] = '#route#&event=add-catalog';
        WOStruct['#attributes.fuseaction#']['add-catalog']['filePath'] = '#addonViewsPath#/#module#/add.cfm';
        WOStruct['#attributes.fuseaction#']['add-catalog']['queryPath'] = '#addonQueriesPath#/#module#/add.cfm';
        WOStruct['#attributes.fuseaction#']['add-catalog']['nextEvent'] = '#route#&event=upd-catalog&pid=';

        WOStruct['#attributes.fuseaction#']['det-catalog'] = structNew();
        WOStruct['#attributes.fuseaction#']['det-catalog']['window'] = 'normal';
        WOStruct['#attributes.fuseaction#']['det-catalog']['fuseaction'] = '#route#&event=det-catalog&pid=';
        WOStruct['#attributes.fuseaction#']['det-catalog']['filePath'] = '#addonViewsPath#/#module#/det.cfm';
        WOStruct['#attributes.fuseaction#']['det-catalog']['queryPath'] = '#addonQueriesPath#/#module#/upd.cfm';
        WOStruct['#attributes.fuseaction#']['det-catalog']['nextEvent'] = '#route#&event=det-catalog&pid=';

        if (isDefined('attributes.pid') and len(attributes.pid))
        {
            WOStruct['#attributes.fuseaction#']['det']['Identity'] = '#attributes.pid#';
            WOStruct['#attributes.fuseaction#']['det-catalog']['Identity'] = '#attributes.pid#';
        }

        /// ürün resmi
        WOStruct['#attributes.fuseaction#']['list-product-images'] = structNew();
        WOStruct['#attributes.fuseaction#']['list-product-images']['window'] = 'popup';
        WOStruct['#attributes.fuseaction#']['list-product-images']['fuseaction'] = '#route#&event=list-product-images&pid=';
        WOStruct['#attributes.fuseaction#']['list-product-images']['filePath'] = '#addonViewsPath#/#module#/list_product_images.cfm';

        WOStruct['#attributes.fuseaction#']['upd-product-image'] = structNew();
        WOStruct['#attributes.fuseaction#']['upd-product-image']['window'] = 'popup';
        WOStruct['#attributes.fuseaction#']['upd-product-image']['fuseaction'] = '#route#&event=upd-product-image';
        WOStruct['#attributes.fuseaction#']['upd-product-image']['filePath'] = '#addonViewsPath#/#module#/upd_product_image.cfm';

        WOStruct['#attributes.fuseaction#']['save-product-image'] = structNew();
        WOStruct['#attributes.fuseaction#']['save-product-image']['window'] = 'popup';
        WOStruct['#attributes.fuseaction#']['save-product-image']['fuseaction'] = '#route#&event=save-product-image';
        WOStruct['#attributes.fuseaction#']['save-product-image']['filePath'] = '#addonQueriesPath#/#module#/upd_product_image.cfm';

        /// belgeler
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

        WOStruct['#attributes.fuseaction#']['history'] = structNew();
        WOStruct['#attributes.fuseaction#']['history']['window'] = 'popup';
        WOStruct['#attributes.fuseaction#']['history']['fuseaction'] = '#route#&event=history&product_id=';
        WOStruct['#attributes.fuseaction#']['history']['filePath'] = '#addonViewsPath#/#module#/history.cfm';

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
            tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['list-ul']['target'] = "_self";
            tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['list-ul']['text'] = "#getLang('main', 97)#";
            tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['list-ul']['href'] = "#request.self#?fuseaction=#route#";

            tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['check']['text'] = "#getLang('main', 49)#";
            tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['check']['onClick'] = 'buttonClickFunction()';
        }
        else if (caller.attributes.event is 'det')
        {
            tabMenuStruct['#fuseactController#']['tabMenus']['det']['icons'] = structNew();
            tabMenuStruct['#fuseactController#']['tabMenus']['det']['icons']['list-ul']['target'] = "_self";
            tabMenuStruct['#fuseactController#']['tabMenus']['det']['icons']['list-ul']['text'] = "#getLang('main', 97)#";
            tabMenuStruct['#fuseactController#']['tabMenus']['det']['icons']['list-ul']['href'] = "#request.self#?fuseaction=#route#";

            tabMenuStruct['#fuseactController#']['tabMenus']['det']['icons']['add']['target'] = "_self";
            tabMenuStruct['#fuseactController#']['tabMenus']['det']['icons']['add']['text'] = "#getLang('main', 170)#";
            tabMenuStruct['#fuseactController#']['tabMenus']['det']['icons']['add']['href'] = "#request.self#?fuseaction=#route#&event=add";

            i = 0;
            tabMenuStruct['#fuseactController#']['tabMenus']['det']['menus'][i]['text'] = 'GE&Ccedil;Mi&Scedil;';
            tabMenuStruct['#fuseactController#']['tabMenus']['det']['menus'][i]['href'] = "javascript:windowopen('#request.self#?fuseaction=#route#&event=history&product_id=#caller.attributes.pid#','medium','popup_product_history');";
        }
        else if (caller.attributes.event is 'add-catalog')
        {
            tabMenuStruct['#fuseactController#']['tabMenus']['add-catalog']['icons'] = structNew();
            tabMenuStruct['#fuseactController#']['tabMenus']['add-catalog']['icons']['list-ul']['target'] = "_self";
            tabMenuStruct['#fuseactController#']['tabMenus']['add-catalog']['icons']['list-ul']['text'] = "#getLang('main', 97)#";
            tabMenuStruct['#fuseactController#']['tabMenus']['add-catalog']['icons']['list-ul']['href'] = "#request.self#?fuseaction=#route#&event=list-catalog";

            tabMenuStruct['#fuseactController#']['tabMenus']['add-catalog']['icons']['check']['text'] = "#getLang('main', 49)#";
            tabMenuStruct['#fuseactController#']['tabMenus']['add-catalog']['icons']['check']['onClick'] = 'buttonClickFunction()';
        }
        else if (caller.attributes.event is 'det-catalog')
        {
            tabMenuStruct['#fuseactController#']['tabMenus']['det-catalog']['icons'] = structNew();
            tabMenuStruct['#fuseactController#']['tabMenus']['det-catalog']['icons']['list-ul']['target'] = "_self";
            tabMenuStruct['#fuseactController#']['tabMenus']['det-catalog']['icons']['list-ul']['text'] = "#getLang('main', 97)#";
            tabMenuStruct['#fuseactController#']['tabMenus']['det-catalog']['icons']['list-ul']['href'] = "#request.self#?fuseaction=#route#";

            tabMenuStruct['#fuseactController#']['tabMenus']['det-catalog']['icons']['add']['target'] = "_self";
            tabMenuStruct['#fuseactController#']['tabMenus']['det-catalog']['icons']['add']['text'] = "#getLang('main', 170)#";
            tabMenuStruct['#fuseactController#']['tabMenus']['det-catalog']['icons']['add']['href'] = "#request.self#?fuseaction=#route#&event=add";

            i = 0;
            tabMenuStruct['#fuseactController#']['tabMenus']['det-catalog']['menus'][i]['text'] = 'GE&Ccedil;Mi&Scedil;';
            tabMenuStruct['#fuseactController#']['tabMenus']['det-catalog']['menus'][i]['href'] = "javascript:windowopen('#request.self#?fuseaction=#route#&event=history&product_id=#caller.attributes.pid#','medium','popup_product_history');";
        }

        tabMenuData = SerializeJSON(tabMenuStruct['#fuseactController#']['tabMenus']);
    }

</cfscript>