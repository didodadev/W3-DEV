<cfset dsn = application.systemParam.systemParam().dsn>
<cfif isDefined("attributes.request_id")>
    <cfquery name="GET_COMPANY_RISK" datasource="#DSN#">
        SELECT * FROM COMPANY_RISK_REQUEST WHERE REQUEST_ID = #attributes.request_id#
    </cfquery>
</cfif>
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
		WOStruct['#attributes.fuseaction#']['list']['fuseaction'] = 'crm.list_risk_request';
		WOStruct['#attributes.fuseaction#']['list']['filePath'] = 'V16/crm/display/list_risk_request.cfm';
		
		WOStruct['#attributes.fuseaction#']['add'] = structNew();
		WOStruct['#attributes.fuseaction#']['add']['window'] = 'normal';
		WOStruct['#attributes.fuseaction#']['add']['fuseaction'] = 'crm.list_risk_request';
		WOStruct['#attributes.fuseaction#']['add']['filePath'] = 'V16/crm/form/add_company_risk.cfm';
		WOStruct['#attributes.fuseaction#']['add']['queryPath'] = 'V16/crm/query/add_company_risk.cfm';
		WOStruct['#attributes.fuseaction#']['add']['nextEvent'] = 'crm.list_risk_request&event=upd&request_id=';	
		
		if(isdefined("attributes.request_id"))
		{
			WOStruct['#attributes.fuseaction#']['upd'] = structNew();
			WOStruct['#attributes.fuseaction#']['upd']['window'] = 'normal';
			WOStruct['#attributes.fuseaction#']['upd']['fuseaction'] = 'crm.list_risk_request';
			WOStruct['#attributes.fuseaction#']['upd']['filePath'] = 'V16/crm/form/upd_company_risk.cfm';
    		WOStruct['#attributes.fuseaction#']['upd']['queryPath'] = 'V16/crm/query/upd_company_risk.cfm';
			WOStruct['#attributes.fuseaction#']['upd']['Identity'] = '#attributes.request_id#';
			WOStruct['#attributes.fuseaction#']['upd']['nextEvent'] = 'crm.list_risk_request&event=upd&request_id=';
		}
	}
	else
	{
		fuseactController = caller.attributes.fuseaction;
		getLang = caller.getLang;
		tabMenuStruct = StructNew();
		tabMenuStruct['#fuseactController#'] = structNew();
		tabMenuStruct['#fuseactController#']['tabMenus'] = structNew();
		
		if(caller.attributes.event is 'add')
		{
            tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons'] = structNew();
            tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['list-ul']['target'] = "_blank";
			tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['list-ul']['text'] = '#getLang('','Liste','57509')#';
			tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['list-ul']['href'] = "#request.self#?fuseaction=crm.list_risk_request";
			
			if(isdefined("attributes.consumer_id"))
			{
				tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['fa fa-edit']['target'] = "_blank";
				tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['fa fa-edit']['text'] = '#getLang('','Müşteri Teminatları','52294')#';
				tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['fa fa-edit']['onclick'] = "openBoxDraggable('#request.self#?fuseaction=crm.popup_list_securefund_info&cpid=#attributes.consumer_id#');";
			}
			
        }
        else if(caller.attributes.event is 'upd')
		{
			
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons'] = structNew();
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['add']['target'] = "_blank";
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['add']['text'] = '#getLang('','Ekle','57582')#';
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['add']['href'] = "#request.self#?fuseaction=crm.list_risk_request&event=add&is_page=1";
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['check']['text'] = '#getLang('main',49)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['check']['onClick'] = "buttonClickFunction()";
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['list-ul']['target'] = "_blank";
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['list-ul']['text'] = '#getLang('','Liste','57509')#';
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['list-ul']['href'] = "#request.self#?fuseaction=crm.list_risk_request";
			
            tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['fa fa-edit']['target'] = "_blank";
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['fa fa-edit']['text'] = '#getLang('','Müşteri Teminatları','52294')#';
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['fa fa-edit']['onclick'] = "openBoxDraggable('#request.self#?fuseaction=crm.popup_list_securefund_info&cpid=#get_company_risk.company_id#');";
		}
		tabMenuData = SerializeJSON(tabMenuStruct['#attributes.fuseaction#']['tabMenus']);
	}
</cfscript>
