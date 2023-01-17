<cfscript>
    if( attributes.TabMenuController eq 0)
    {
        WoStruct=structnew();
        WOStruct['#attributes.fuseaction#'] = structNew();	
		
        WOStruct['#attributes.fuseaction#']['default'] = 'list';
        if(not isdefined('attributes.event')){
            attributes.event = WOStruct['#attributes.fuseaction#']['default'];
        }   
        WOStruct['#attributes.fuseaction#']['list'] = structNew();
        WOStruct['#attributes.fuseaction#']['list']['window'] = 'normal';
        WOStruct['#attributes.fuseaction#']['list']['fuseaction'] ='myhome.welcome_hr';
        WOStruct['#attributes.fuseaction#']['list']['filePath'] = 'V16/myhome/display/welcome_hr.cfm';
        
       
    }
</cfscript>