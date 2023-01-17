
    <cfscript>
        if(attributes.tabMenuController eq 0)
        {
            WOStruct = StructNew();
            
            WOStruct['#attributes.fuseaction#'] = structNew();	
            
            WOStruct['#attributes.fuseaction#']['default'] = 'list';
            if(not isdefined('attributes.event'))
                attributes.event = WOStruct['#attributes.fuseaction#']['default'];

                WOStruct['#attributes.fuseaction#']['list'] = structNew();
                WOStruct['#attributes.fuseaction#']['list']['window'] = 'normal';
                WOStruct['#attributes.fuseaction#']['list']['fuseaction'] = 'objects.serial_no';
                WOStruct['#attributes.fuseaction#']['list']['filePath'] = 'V16/objects/display/collected_serial_number_print.cfm';
                        
                WOStruct['#attributes.fuseaction#']['det'] = structNew();
                WOStruct['#attributes.fuseaction#']['det']['window'] = 'normal';
                WOStruct['#attributes.fuseaction#']['det']['fuseaction'] = 'objects.serial_no';
                WOStruct['#attributes.fuseaction#']['det']['filePath'] = 'V16/objects/display/dsp_serial_number_result.cfm';
                

        }
        else
        {
            fuseactController = caller.attributes.fuseaction;
            getLang = caller.getLang;
            
            tabMenuStruct = StructNew();
            tabMenuStruct['#fuseactController#'] = structNew();
            tabMenuStruct['#fuseactController#']['tabMenus'] = structNew();
            tabMenuStruct['#fuseactController#']['tabMenus']['det']['icons']['list-ul']['text'] = '#getLang('main',62)#';
            tabMenuStruct['#fuseactController#']['tabMenus']['det']['icons']['list-ul']['href'] = "#request.self#?fuseaction=objects.serial_no";
            if(caller.attributes.event is 'det')
            {		
              if(isdefined("attributes.seri_stock_id") and isdefined("attributes.product_serial_no")){
                tabMenuStruct['#attributes.fuseaction#']['tabMenus']['det']['menus'][0]['target'] = "_blank";
                tabMenuStruct['#attributes.fuseaction#']['tabMenus']['det']['menus'][0]['text'] = '#getlang('','ürün ekle',57657)#';
				tabMenuStruct['#attributes.fuseaction#']['tabMenus']['det']['menus'][0]['href'] = "#request.self#?fuseaction=product.list_product&event=det&pid=#caller.get_search_results_.PRODUCT_ID#";
                tabMenuStruct['#attributes.fuseaction#']['tabMenus']['det']['menus'][1]['target'] = "_blank";
                tabMenuStruct['#attributes.fuseaction#']['tabMenus']['det']['menus'][1]['text'] = '#getlang('','service',57452)#';
				tabMenuStruct['#attributes.fuseaction#']['tabMenus']['det']['menus'][1]['href'] = "#request.self#?fuseaction=stock.list_stock&event=det&pid=#caller.get_search_results_.PRODUCT_ID#";
                tabMenuStruct['#fuseactController#']['tabMenus']['det']['icons']['print']['target'] = "_blank";	
                tabMenuStruct['#fuseactController#']['tabMenus']['det']['icons']['print']['text'] = '#getLang('main',62)#';
                tabMenuStruct['#fuseactController#']['tabMenus']['det']['icons']['print']['href'] = "#request.self#?fuseaction=objects.popup_print_files&action_type=87&action_id=&action_row_id=&print_type=192&sid=#caller.get_search_results_.STOCK_ID#&serial_no=#attributes.product_serial_no#&template_id=1175";

            }
        }
            
            tabMenuData = SerializeJSON(tabMenuStruct['#attributes.fuseaction#']['tabMenus']);
        }
    </cfscript>