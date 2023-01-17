<!---
    File: ExtraWorkTimeApproveController.cfm
    Author: Workcube-Emine Yılmaz
    Date: 02.09.2019
    Description:
		Avans Talebi controller'ıdır.
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
        WOStruct['#attributes.fuseaction#']['list']['fuseaction'] = 'myhome.payment_request_approve';
        WOStruct['#attributes.fuseaction#']['list']['filePath'] = '/V16/myhome/display/list_payment_request_approve.cfm';


        WOStruct['#attributes.fuseaction#']['upd'] = structNew();
		WOStruct['#attributes.fuseaction#']['upd']['window'] = 'normal';
		WOStruct['#attributes.fuseaction#']['upd']['fuseaction'] = 'myhome.payment_request_approve';
		WOStruct['#attributes.fuseaction#']['upd']['filePath'] = '/V16/myhome/form/upd_payment_request_valid.cfm';
		WOStruct['#attributes.fuseaction#']['upd']['queryPath'] = '/V16/myhome/query/upd_payment_request_valid.cfm';
        WOStruct['#attributes.fuseaction#']['upd']['nextEvent'] = '';



	}
	else
	{
		fuseactController = caller.attributes.fuseaction;
		getLang = caller.getLang;
		
		tabMenuStruct = StructNew();
		tabMenuStruct['#fuseactController#'] = structNew();
		tabMenuStruct['#fuseactController#']['tabMenus'] = structNew();

		if(caller.attributes.event is 'upd')
		{
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons'] = structNew();
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['list-ul']['target'] = "_blank";
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['list-ul']['text'] = '#getLang('main',97)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['list-ul']['href'] = "#request.self#?fuseaction=myhome.payment_request_approve";

			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['print']['text'] = '#getLang('main',62)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['print']['onclick'] = "windowopen('#request.self#?fuseaction=objects.popup_print_files&iid=#attributes.id#&print_type=184','page')";

			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['bell']['text'] = '#getlang('main',345)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['bell']['href'] = "#request.self#?fuseaction=objects.workflowpages&tab=3&action=#attributes.fuseaction#&action_name=id&action_id=#attributes.id#";
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['bell']['target'] ="_blank";

			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['check']['text'] = '#getLang('main',49)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['check']['onClick'] = "buttonClickFunction()";
			
		}
		
		tabMenuData = SerializeJSON(tabMenuStruct['#attributes.fuseaction#']['tabMenus']);
	}
</cfscript>
