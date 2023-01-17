<cfset dsn = application.systemParam.systemParam().dsn>
<cfquery name="woCountQuery" datasource="#dsn#">
	SELECT COUNT(*) TotalWO FROM WRK_OBJECTS
</cfquery>
<cfscript>
	if(attributes.tabMenuController eq 0)
	{
		WOStruct = StructNew();
		
		WOStruct['#attributes.fuseaction#'] = structNew();
		
		WOStruct['#attributes.fuseaction#']['default'] = 'det';
	
		WOStruct['#attributes.fuseaction#']['det'] = structNew();
		WOStruct['#attributes.fuseaction#']['det']['window'] = 'normal';
		WOStruct['#attributes.fuseaction#']['det']['fuseaction'] = 'dev.wo_detboard';
		WOStruct['#attributes.fuseaction#']['det']['filePath'] = 'V16/report/wo_dashboard.cfm';
		WOStruct['#attributes.fuseaction#']['det']['identity'] = '#woCountQuery.totalwo#';
		
	}
	else
	{
		fuseactController = caller.attributes.fuseaction;
		getLang = caller.getLang;
		
		tabMenuStruct = StructNew();
		tabMenuStruct['#fuseactController#'] = structNew();
        tabMenuStruct['#fuseactController#']['tabMenus'] = structNew();
	if(caller.attributes.event is 'det')
	{
		tabMenuStruct['#fuseactController#']['tabMenus']['det']['icons'] = structNew();
		tabMenuStruct['#fuseactController#']['tabMenus']['det']['icons']['list-ul']['text'] = '#getLang('main',97)#';
		tabMenuStruct['#fuseactController#']['tabMenus']['det']['icons']['list-ul']['href'] = "#request.self#?fuseaction=dev.wo"; 
		tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['fa fa-folder']['text'] = '#getLang('main',49)#';
		tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['fa fa-folder']['href'] = "#request.self#?fuseaction=dev.tools";
	}
	tabMenuData = SerializeJSON(tabMenuStruct['#attributes.fuseaction#']['tabMenus']);
	}
	

</cfscript>