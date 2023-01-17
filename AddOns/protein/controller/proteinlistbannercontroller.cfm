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
						WOStruct['#attributes.fuseaction#']['list']['fuseaction'] = 'protein.list_banners';
						WOStruct['#attributes.fuseaction#']['list']['filePath'] = 'AddOns/protein/display/list_banners.cfm';	
					
          if(IsDefined("attributes.event") && attributes.event is 'upd')
          {
              WOStruct['#attributes.fuseaction#']['upd'] = structNew();
              WOStruct['#attributes.fuseaction#']['upd']['window'] = 'normal';
              WOStruct['#attributes.fuseaction#']['upd']['fuseaction'] = 'content.upd_banner';
              WOStruct['#attributes.fuseaction#']['upd']['filePath'] = 'V16/content/form/upd_banner.cfm';
              WOStruct['#attributes.fuseaction#']['upd']['queryPath'] = 'V16/content/query/upd_banner.cfm';
              WOStruct['#attributes.fuseaction#']['upd']['nextevent'] = 'protein.list_banners'; 
          }
								
							WOStruct['#attributes.fuseaction#']['add'] = structNew();
							WOStruct['#attributes.fuseaction#']['add']['window'] = 'normal';
							WOStruct['#attributes.fuseaction#']['add']['fuseaction'] = 'content.add_banner';
							WOStruct['#attributes.fuseaction#']['add']['filePath'] = 'V16/content/form/add_banner.cfm';
							WOStruct['#attributes.fuseaction#']['add']['queryPath'] = 'V16/content/query/add_banner.cfm';
							WOStruct['#attributes.fuseaction#']['add']['nextevent'] = 'protein.list_banners&event=upd&banner_id';
									
  }
</cfscript>