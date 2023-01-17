<cfsavecontent variable="deatils"><cf_get_lang dictionary_id="57911.Çalıştır"></cfsavecontent>
    <cfsavecontent variable="list"><cf_get_lang dictionary_id="57509.Liste"></cfsavecontent>
        <cfsavecontent variable="ekle"><cf_get_lang dictionary_id="61142.Kaydet"></cfsavecontent>
            <cfsavecontent variable="title2"><cf_get_lang dictionary_id='38808.Zaman Ayarlı Görev Ekle'></cfsavecontent>
                <cfsavecontent variable="rapor"><cf_get_lang dictionary_id='59295.Rapor Sakla'></cfsavecontent>
                    <cfsavecontent variable="güncelle"><cf_get_lang dictionary_id='57464.Güncelle'></cfsavecontent>

<cfscript>
    if(attributes.tabMenuController eq 0)
    {
        WOStruct = StructNew();
        WOStruct['#attributes.fuseaction#'] = structNew();
        WOStruct['#attributes.fuseaction#']['default'] = 'list';

        WOStruct['#attributes.fuseaction#']['list'] = structNew();
        WOStruct['#attributes.fuseaction#']['list']['window'] = 'normal';
        WOStruct['#attributes.fuseaction#']['list']['fuseaction'] = 'report.list_reports';
        WOStruct['#attributes.fuseaction#']['list']['filePath'] = 'V16/report/display/list_reports.cfm';

        WOStruct['#attributes.fuseaction#']['add'] = structNew();
        WOStruct['#attributes.fuseaction#']['add']['window'] = 'normal';
        WOStruct['#attributes.fuseaction#']['add']['fuseaction'] = 'report.form_add_report_special';
        WOStruct['#attributes.fuseaction#']['add']['filePath'] = 'V16/report/form/add_report_special.cfm';
        WOStruct['#attributes.fuseaction#']['add']['queryPath'] = 'V16/report/query/add_report_special.cfm';
        WOStruct['#attributes.fuseaction#']['add']['nextEvent'] = 'report.list_reports&event=upd&report_id=';

    if(isdefined("attributes.report_id"))
        {
            WOStruct['#attributes.fuseaction#']['det'] = structNew();
            WOStruct['#attributes.fuseaction#']['det']['window'] = 'normal';
            WOStruct['#attributes.fuseaction#']['det']['fuseaction'] = 'report.detail_report';
            WOStruct['#attributes.fuseaction#']['det']['filePath'] = 'V16/report/display/detail_report.cfm';
            WOStruct['#attributes.fuseaction#']['det']['queryPath'] = 'V16/report/query/upd_report_special.cfm';
            WOStruct['#attributes.fuseaction#']['det']['Identity'] = '#attributes.report_id#';
            WOStruct['#attributes.fuseaction#']['det']['nextEvent'] = 'report.list_reports&event=upd&report_id=';
	
            WOStruct['#attributes.fuseaction#']['upd'] = structNew();
            WOStruct['#attributes.fuseaction#']['upd']['window'] = 'normal';
            WOStruct['#attributes.fuseaction#']['upd']['fuseaction'] = 'report.form_upd_report_special';
            WOStruct['#attributes.fuseaction#']['upd']['filePath'] = 'V16/report/form/upd_report_special.cfm';
            WOStruct['#attributes.fuseaction#']['upd']['queryPath'] = 'V16/report/query/upd_report_special.cfm';
            WOStruct['#attributes.fuseaction#']['upd']['Identity'] = '#attributes.report_id#';
            WOStruct['#attributes.fuseaction#']['upd']['nextEvent'] = 'report.list_reports&event=upd&report_id=';

            WOStruct['#attributes.fuseaction#']['del'] = structNew();
            WOStruct['#attributes.fuseaction#']['del']['window'] = 'emptypopup';
            WOStruct['#attributes.fuseaction#']['del']['fuseaction'] = '#request.self#?fuseaction=report.emptypopup_del_report_special&report_id=#attributes.report_id#';
            WOStruct['#attributes.fuseaction#']['del']['filePath'] = 'V16/report/query/del_report_special.cfm';
            WOStruct['#attributes.fuseaction#']['del']['extraParams'] = 'report_id';
            WOStruct['#attributes.fuseaction#']['del']['queryPath'] = 'V16/report/query/del_report_special.cfm';
            WOStruct['#attributes.fuseaction#']['del']['nextEvent'] = 'report.list_reports';
       }
    }
    {			
        fuseactController = attributes.fuseaction;
        
        tabMenuStruct = StructNew();
        tabMenuStruct['#attributes.fuseaction#'] = structNew();
        tabMenuStruct['#attributes.fuseaction#']['tabMenus'] = structNew();
        if(isdefined("attributes.event") and attributes.event is 'upd')
        {
            tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd'] = structNew();
            
            tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons'] = structNew();
            tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['list-ul']['target'] = "_blank";
            tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['list-ul']['text'] = '#list#';
            tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['list-ul']['href'] = "#request.self#?fuseaction=report.list_reports";          

            tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['fa fa-calendar-plus-o']['text'] = '#title2#';
            tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['fa fa-calendar-plus-o']['onClick']  = "openBoxDraggable('#request.self#?fuseaction=report.popup_add_schedule_task&report_id=#attributes.report_id#')";

            tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['chart']['text'] = '#deatils#';
            tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['chart']['href']  = "#request.self#?fuseaction=report.list_reports&event=det&report_id=#attributes.report_id#";
           
            tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['add']['text'] = '#ekle#';
            tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['add']['href'] = "#request.self#?fuseaction=report.list_reports&event=add";	
            tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['add']['target'] = '_blank';           

            tabMenuData = SerializeJSON(tabMenuStruct['#attributes.fuseaction#']['tabMenus']);
        }
        else if(isdefined("attributes.event") and attributes.event is 'det')
        {
            tabMenuStruct['#fuseactController#']['tabMenus']['det']['icons'] = structNew();
            tabMenuStruct['#fuseactController#']['tabMenus']['det']['icons']['list-ul']['target'] = "_blank";
            tabMenuStruct['#fuseactController#']['tabMenus']['det']['icons']['list-ul']['text'] = '#list#';
            tabMenuStruct['#fuseactController#']['tabMenus']['det']['icons']['list-ul']['href'] = "#request.self#?fuseaction=report.list_reports";

           
            tabMenuData = SerializeJSON(tabMenuStruct['#attributes.fuseaction#']['tabMenus']);

        }
        else if(isdefined("attributes.event") and attributes.event is 'add')
        {
            tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons'] = structNew();
            tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['list-ul']['target'] = "_blank";
            tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['list-ul']['text'] = '#list#';
            tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['list-ul']['href'] = "#request.self#?fuseaction=report.list_reports";
            
            tabMenuData = SerializeJSON(tabMenuStruct['#attributes.fuseaction#']['tabMenus']);

        }
    }
</cfscript>