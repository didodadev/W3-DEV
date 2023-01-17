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
            WOStruct['#attributes.fuseaction#']['list']['fuseaction'] = 'rule.list_hr';
            WOStruct['#attributes.fuseaction#']['list']['filePath'] = '/V16/rules/display/list_hr.cfm';
    
    
            if(isdefined("attributes.emp_id"))
            {
            WOStruct['#attributes.fuseaction#']['det'] = structNew();
            WOStruct['#attributes.fuseaction#']['det']['window'] = 'normal';
            WOStruct['#attributes.fuseaction#']['det']['fuseaction'] = 'rule.list_hr';
            WOStruct['#attributes.fuseaction#']['det']['filePath'] = '/V16/objects/display/detail_emp.cfm';
            WOStruct['#attributes.fuseaction#']['det']['queryPath'] = '/V16/objects/display/detail_emp.cfm';
            WOStruct['#attributes.fuseaction#']['det']['Identity'] = '#attributes.emp_id#';
            WOStruct['#attributes.fuseaction#']['det']['nextEvent'] = 'rule.list_hr&event=det&emp_id=';}

    
        
    }
    
</cfscript>
    
    