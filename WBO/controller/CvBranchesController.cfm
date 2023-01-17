<cfscript>
	if(attributes.tabMenuController eq 0)
	{
		WOStruct = StructNew();
		
		WOStruct['#attributes.fuseaction#'] = structNew();	
		
		WOStruct['#attributes.fuseaction#']['default'] = 'add';
		if(not isdefined('attributes.event'))
			attributes.event = WOStruct['#attributes.fuseaction#']['default'];
	
	/* 	WOStruct['#attributes.fuseaction#']['list'] = structNew();
		WOStruct['#attributes.fuseaction#']['list']['window'] = 'normal';
		WOStruct['#attributes.fuseaction#']['list']['fuseaction'] = 'settings.list_cv_branches';
		WOStruct['#attributes.fuseaction#']['list']['filePath'] = 'V16/settings/display/list_cv_branches.cfm';
 */
		WOStruct['#attributes.fuseaction#']['add'] = structNew();
		WOStruct['#attributes.fuseaction#']['add']['window'] = 'normal';
		WOStruct['#attributes.fuseaction#']['add']['fuseaction'] = 'settings.list_cv_branches';
		WOStruct['#attributes.fuseaction#']['add']['filePath'] = 'V16/settings/form/form_add_app_branches.cfm';
		WOStruct['#attributes.fuseaction#']['add']['queryPath'] = 'V16/settings/query/add_app_branches.cfm';
		WOStruct['#attributes.fuseaction#']['add']['nextEvent'] = 'settings.list_cv_branches';

		if(isdefined("attributes.branches_id"))
		{
			WOStruct['#attributes.fuseaction#']['upd'] = structNew();
			WOStruct['#attributes.fuseaction#']['upd']['window'] = 'normal';
			WOStruct['#attributes.fuseaction#']['upd']['fuseaction'] = 'settings.list_cv_branches';
			WOStruct['#attributes.fuseaction#']['upd']['filePath'] = 'V16/settings/form/form_upd_app_branches.cfm';
			WOStruct['#attributes.fuseaction#']['upd']['queryPath'] = 'V16/settings/query/upd_app_branches.cfm';
			WOStruct['#attributes.fuseaction#']['upd']['Identity'] = '#attributes.branches_id#';
			WOStruct['#attributes.fuseaction#']['upd']['nextEvent'] = 'settings.list_cv_branches&event=upd&branches_id=';
			
			WOStruct['#attributes.fuseaction#']['del'] = structNew();
			WOStruct['#attributes.fuseaction#']['del']['window'] = 'emptypopup';
			WOStruct['#attributes.fuseaction#']['del']['fuseaction'] = 'settings.list_cv_branches';
			WOStruct['#attributes.fuseaction#']['del']['filePath'] = 'V16/settings/query/del_app_branches.cfm';
			WOStruct['#attributes.fuseaction#']['del']['queryPath'] = 'V16/settings/query/del_app_branches.cfm';
			WOStruct['#attributes.fuseaction#']['del']['nextEvent'] = 'settings.list_cv_branches';
			
		}
		
		WOStruct['#attributes.fuseaction#']['addSub'] = structNew();
		WOStruct['#attributes.fuseaction#']['addSub']['window'] = 'normal';
		WOStruct['#attributes.fuseaction#']['addSub']['fuseaction'] = 'settings.list_cv_branches';
		WOStruct['#attributes.fuseaction#']['addSub']['filePath'] = 'V16/settings/form/form_add_branches_rows.cfm';
		WOStruct['#attributes.fuseaction#']['addSub']['queryPath'] = 'V16/settings/query/add_app_branches_rows.cfm';
		WOStruct['#attributes.fuseaction#']['addSub']['nextEvent'] = 'settings.list_cv_branches&event=upd&branches_id';

		if(isdefined("attributes.bid"))
		{
			WOStruct['#attributes.fuseaction#']['updSub'] = structNew();
			WOStruct['#attributes.fuseaction#']['updSub']['window'] = 'normal';
			WOStruct['#attributes.fuseaction#']['updSub']['fuseaction'] = 'settings.list_cv_branches';
			WOStruct['#attributes.fuseaction#']['updSub']['filePath'] = 'V16/settings/form/form_upd_app_branches_rows.cfm';
			WOStruct['#attributes.fuseaction#']['updSub']['queryPath'] = 'V16/settings/query/upd_app_branches_rows.cfm';
			WOStruct['#attributes.fuseaction#']['updSub']['Identity'] = '#attributes.bid#';
			WOStruct['#attributes.fuseaction#']['updSub']['nextEvent'] = 'settings.list_cv_branches&event=updSub&branches_id=#attributes.branches_id#&bid=#attributes.bid#';
			
			WOStruct['#attributes.fuseaction#']['delSub'] = structNew();
			WOStruct['#attributes.fuseaction#']['delSub']['window'] = 'emptypopup';
			WOStruct['#attributes.fuseaction#']['delSub']['fuseaction'] = '#request.self#?fuseaction=settings.emptypopup_del_app_branches_rows&branches_row_id=#attributes.bid#';
			WOStruct['#attributes.fuseaction#']['delSub']['filePath'] = 'V16/settings/query/del_app_branches_rows.cfm';
			WOStruct['#attributes.fuseaction#']['delSub']['queryPath'] = 'V16/settings/query/del_app_branches_rows.cfm';
			WOStruct['#attributes.fuseaction#']['delSub']['nextEvent'] = 'settings.list_cv_branches';
		}
		
	}
	
</cfscript>
