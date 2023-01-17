
<!---
    File: WBO\controller\DesignDataController.cfm
    Author: Esma R. Uysal <esmauysal@workcube.com>
    Date: 2022-04-12
    Description: Design data for product controller

--->
<cfscript>
    if(attributes.tabMenuController eq 0)
    {
        WOStruct = StructNew();
        
        WOStruct['#attributes.fuseaction#'] = structNew();
        
        WOStruct['#attributes.fuseaction#']['default'] = 'list';
        if(not isdefined('attributes.event'))
            attributes.event = WOStruct['#attributes.fuseaction#']['default'];

        WOStruct['#attributes.fuseaction#']['list'] = structNew();
        WOStruct['#attributes.fuseaction#']['list']['window'] = 'popup';
        WOStruct['#attributes.fuseaction#']['list']['fuseaction'] = 'product.design_data';
        WOStruct['#attributes.fuseaction#']['list']['filePath'] = 'V16/product/display/design_data.cfm';  
        
        WOStruct['#attributes.fuseaction#']['info'] = structNew();
        WOStruct['#attributes.fuseaction#']['info']['window'] = 'popup';
        WOStruct['#attributes.fuseaction#']['info']['fuseaction'] = 'product.product_sample';
        WOStruct['#attributes.fuseaction#']['info']['filePath'] = 'V16/product/display/design_data_info.cfm';

        WOStruct['#attributes.fuseaction#']['settings'] = structNew();
        WOStruct['#attributes.fuseaction#']['settings']['window'] = 'popup';
        WOStruct['#attributes.fuseaction#']['settings']['fuseaction'] = 'product.product_sample';
        WOStruct['#attributes.fuseaction#']['settings']['filePath'] = 'V16/product/display/design_data_settings.cfm';

        WOStruct['#attributes.fuseaction#']['import'] = structNew();
        WOStruct['#attributes.fuseaction#']['import']['window'] = 'popup';
        WOStruct['#attributes.fuseaction#']['import']['fuseaction'] = 'product.product_sample';
        WOStruct['#attributes.fuseaction#']['import']['filePath'] = 'V16/product/form/design_data_import.cfm';
        WOStruct['#attributes.fuseaction#']['import']['queryPath'] = 'V16/product/query/design_data_import.cfm';
    }
</cfscript>
    
    