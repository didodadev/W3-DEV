<!---
    File: ExtraWorkTimesController.cfm
    Author: Workcube-Esma Uysal <esmauysal@workcube.com>
    Date: 02.09.2019
    Description:
		Toplu Fazla Mesai ekleme controller'ıdır.
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
        WOStruct['#attributes.fuseaction#']['list']['window'] = 'normal';
        WOStruct['#attributes.fuseaction#']['list']['fuseaction'] = 'myhome.list_extra_worktimes';
        WOStruct['#attributes.fuseaction#']['list']['filePath'] = 'V16/myhome/display/list_extra_worktimes.cfm';
        WOStruct['#attributes.fuseaction#']['list']['queryPath'] = 'V16/myhome/query/view_extra_worktimes.cfm';
        WOStruct['#attributes.fuseaction#']['list']['nextEvent'] = 'myhome.list_extra_worktimes';
    }
</cfscript>
