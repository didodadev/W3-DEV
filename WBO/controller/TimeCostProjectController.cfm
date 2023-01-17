<cfscript>
    if(attributes.tabMenuController eq 0)
    {
    	WOStruct = StructNew();
    	
    	WOStruct['#attributes.fuseaction#'] = structNew();	
    	
    	WOStruct['#attributes.fuseaction#']['default'] = 'add';
    	if(not isdefined('attributes.event'))
    		attributes.event = WOStruct['#attributes.fuseaction#']['default'];
    
    	WOStruct['#attributes.fuseaction#']['add'] = structNew();
    	WOStruct['#attributes.fuseaction#']['add']['window'] = 'normal';
    	WOStruct['#attributes.fuseaction#']['add']['fuseaction'] = 'hr.add_timecost_all';
		WOStruct['#attributes.fuseaction#']['add']['filePath'] = 'V16/myhome/form/add_timecost_project_all.cfm';
		WOStruct['#attributes.fuseaction#']['add']['queryPath'] = 'V16/myhome/query/add_timecost_project_all.cfm';	
    	
    }
    
    </cfscript>