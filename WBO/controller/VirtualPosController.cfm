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
		WOStruct['#attributes.fuseaction#']['list']['fuseaction'] = 'settings.list_pos_relation';
		WOStruct['#attributes.fuseaction#']['list']['filePath'] = '/V16/settings/display/list_pos_relation.cfm';
		
		WOStruct['#attributes.fuseaction#']['add'] = structNew();
		WOStruct['#attributes.fuseaction#']['add']['window'] = 'normal';
		WOStruct['#attributes.fuseaction#']['add']['fuseaction'] = 'settings.list_pos_relation';
		WOStruct['#attributes.fuseaction#']['add']['filePath'] = 'V16/settings/form/form_add_pos_relation.cfm';
		WOStruct['#attributes.fuseaction#']['add']['queryPath'] = 'V16/settings/query/add_pos_relation.cfm';
		WOStruct['#attributes.fuseaction#']['add']['formName'] = 'form_pos';
		
		if(isdefined("attributes.pos_id"))
		{
			WOStruct['#attributes.fuseaction#']['upd'] = structNew();
			WOStruct['#attributes.fuseaction#']['upd']['window'] = 'normal';
			WOStruct['#attributes.fuseaction#']['upd']['fuseaction'] = 'settings.list_pos_relation';
			WOStruct['#attributes.fuseaction#']['upd']['filePath'] = 'V16/settings/form/form_upd_pos_relation.cfm';
			WOStruct['#attributes.fuseaction#']['upd']['queryPath'] = 'V16/settings/query/upd_pos_relation.cfm';
			WOStruct['#attributes.fuseaction#']['upd']['Identity'] = '#attributes.pos_id#';	
			
			if(listFind('upd,del',attributes.event))
			{
				WOStruct['#attributes.fuseaction#']['del'] = structNew();
				WOStruct['#attributes.fuseaction#']['del']['window'] = 'emptypopup';
				WOStruct['#attributes.fuseaction#']['del']['fuseaction'] = '#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.emptypopup_del_pos_relation&pos_id=#attributes.pos_id#';
				WOStruct['#attributes.fuseaction#']['del']['filePath'] = 'V16/settings/query/del_pos_relation.cfm';
				WOStruct['#attributes.fuseaction#']['del']['queryPath'] = 'V16/settings/query/del_pos_relation.cfm';
			}
		}
	}


</cfscript>
