
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
            WOStruct['#attributes.fuseaction#']['list']['fuseaction'] = 'assetcare.fuel_password';
            WOStruct['#attributes.fuseaction#']['list']['filePath'] = 'V16/assetcare/form/fuel_password.cfm';
    
    
            WOStruct['#attributes.fuseaction#']['add'] = structNew();
            WOStruct['#attributes.fuseaction#']['add']['window'] = 'normal';
            WOStruct['#attributes.fuseaction#']['add']['fuseaction'] = 'assetcare.fuel_password';
            WOStruct['#attributes.fuseaction#']['add']['filePath'] = 'V16/assetcare/form/add_fuel_password.cfm';
          
    
            if(isdefined("attributes.password_id"))
            {
                WOStruct['#attributes.fuseaction#']['upd'] = structNew();
                WOStruct['#attributes.fuseaction#']['upd']['window'] = 'normal';
                WOStruct['#attributes.fuseaction#']['upd']['fuseaction'] = 'assetcare.fuel_password';
                WOStruct['#attributes.fuseaction#']['upd']['filePath'] = 'V16/assetcare/form/upd_fuel_password.cfm';
                WOStruct['#attributes.fuseaction#']['upd']['queryPath'] = 'V16/assetcare/query/upd_fuel_password.cfm';
                WOStruct['#attributes.fuseaction#']['upd']['nextEvent'] = 'assetcare.fuel_password&event=upd&password_id=';
            }              
    }   
</cfscript>

