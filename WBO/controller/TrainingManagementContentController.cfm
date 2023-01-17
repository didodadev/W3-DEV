<cfscript>
    if(attributes.tabMenuController eq 0)
    {
        WOStruct = StructNew();
        WOStruct['#attributes.fuseaction#'] = structNew();
        WOStruct['#attributes.fuseaction#']['default'] = 'list';

        WOStruct['#attributes.fuseaction#']['list'] = structNew();
        WOStruct['#attributes.fuseaction#']['list']['window'] = 'normal';
        WOStruct['#attributes.fuseaction#']['list']['fuseaction'] = 'training_management.list_content';
        WOStruct['#attributes.fuseaction#']['list']['filePath'] = 'V16/content/display/dsp_list_content.cfm';
        WOStruct['#attributes.fuseaction#']['list']['queryPath'] = 'V16/content/display/dsp_list_content.cfm';
		
		WOStruct['#attributes.fuseaction#']['add'] = structNew();
		WOStruct['#attributes.fuseaction#']['add']['window'] = 'normal';
		WOStruct['#attributes.fuseaction#']['add']['fuseaction'] = 'training_management.add_form_content';
		WOStruct['#attributes.fuseaction#']['add']['filePath'] = 'V16/content/form/form_add_content.cfm';
		WOStruct['#attributes.fuseaction#']['add']['queryPath'] = 'V16/content/query/add_content.cfm';
		WOStruct['#attributes.fuseaction#']['add']['nextEvent'] = 'training_management.list_content&event=det&cntid=';	
		
		
		if(isdefined("attributes.cntid"))
		{
		
			WOStruct['#attributes.fuseaction#']['det'] = structNew();
			WOStruct['#attributes.fuseaction#']['det']['window'] = 'normal';
			WOStruct['#attributes.fuseaction#']['det']['fuseaction'] = 'training_management.view_content';
			WOStruct['#attributes.fuseaction#']['det']['filePath'] = 'V16/content/display/dsp_content_form.cfm';
			WOStruct['#attributes.fuseaction#']['det']['queryPath'] = 'V16/content/query/update_content.cfm';
			WOStruct['#attributes.fuseaction#']['det']['Identity'] = '#attributes.cntid#';
			WOStruct['#attributes.fuseaction#']['det']['nextEvent'] = 'training_management.list_content&event=det&cntid=';

			WOStruct['#attributes.fuseaction#']['relatedQuestions'] = structNew();
			WOStruct['#attributes.fuseaction#']['relatedQuestions']['window'] = 'normal';
			WOStruct['#attributes.fuseaction#']['relatedQuestions']['fuseaction'] = 'training_management.view_content';
			WOStruct['#attributes.fuseaction#']['relatedQuestions']['filePath'] = 'V16/content/display/content_related_questions.cfm';
			WOStruct['#attributes.fuseaction#']['relatedQuestions']['queryPath'] = 'V16/content/display/content_related_questions.cfm';

			WOStruct['#attributes.fuseaction#']['delRelatedQuestions'] = structNew();
			WOStruct['#attributes.fuseaction#']['delRelatedQuestions']['window'] = 'normal';
			WOStruct['#attributes.fuseaction#']['delRelatedQuestions']['fuseaction'] = 'training_management.view_content';
			WOStruct['#attributes.fuseaction#']['delRelatedQuestions']['filePath'] = 'V16/content/display/del_content_related_questions.cfm';
			WOStruct['#attributes.fuseaction#']['delRelatedQuestions']['queryPath'] = 'V16/content/display/del_content_related_questions.cfm';

			WOStruct['#attributes.fuseaction#']['listContentQuestions'] = structNew();
			WOStruct['#attributes.fuseaction#']['listContentQuestions']['window'] = 'normal';
			WOStruct['#attributes.fuseaction#']['listContentQuestions']['fuseaction'] = 'training_management.view_content';
			WOStruct['#attributes.fuseaction#']['listContentQuestions']['filePath'] = 'V16/training_management/display/popup_list_content_questions.cfm';
			WOStruct['#attributes.fuseaction#']['listContentQuestions']['queryPath'] = 'V16/training_management/display/popup_list_content_questions.cfm';
		}
		
		if(isdefined("attributes.event") and listFind('det,del',attributes.event))
			{
				WOStruct['#attributes.fuseaction#']['del'] = structNew();
				WOStruct['#attributes.fuseaction#']['del']['window'] = 'emptypopup';
				WOStruct['#attributes.fuseaction#']['del']['fuseaction'] = '#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,".")#.del_content&cntid=#attributes.cntid#';
				WOStruct['#attributes.fuseaction#']['del']['filePath'] = 'V16/content/query/del_content.cfm';
				WOStruct['#attributes.fuseaction#']['del']['queryPath'] = 'V16/content/query/del_content.cfm';
				WOStruct['#attributes.fuseaction#']['del']['nextEvent'] = 'training_management.list_content';
			}
		
		WOStruct['#attributes.fuseaction#']['systemObject']['extendedForm'] = true;
		WOStruct['#attributes.fuseaction#']['systemObject']['pageExtendedEventList'] = 'add,det';
		WOStruct['#attributes.fuseaction#']['systemObject']['pageTableName'] = 'CONTENT';
		WOStruct['#attributes.fuseaction#']['systemObject']['pageIdentityColumn'] = 'CONTENT_ID';
		WOStruct['#attributes.fuseaction#']['systemObject']['pageSettings'] = "['item-chapter_id,item-cont_catid']";

		
      }
	  	else
	{
		fuseactController = caller.attributes.fuseaction;
		// Tab Menus //
		tabMenuStruct = StructNew();
		getLang = caller.getLang;
		
		tabMenuStruct['#fuseactController#'] = structNew();
		tabMenuStruct['#fuseactController#']['tabMenus'] = structNew();
		// Upd //
		if(isdefined("caller.attributes.event") and caller.attributes.event is 'det')
		{
			
			get_content = caller.get_content;
			
			tabMenuStruct['#fuseactController#']['tabMenus']['det'] = structNew();
			tabMenuStruct['#fuseactController#']['tabMenus']['det']['menus'] = structNew();
			
			
			tabMenuStruct['#fuseactController#']['tabMenus']['det']['menus'][0]['text'] = "#getLang('content',158,'Yorum Ekle')#";
			tabMenuStruct['#fuseactController#']['tabMenus']['det']['menus'][0]['onClick'] = "windowopen('#request.self#?fuseaction=rule.popup_add_content_comment&content_id=#attributes.cntid#','list')";
			
			tabMenuStruct['#fuseactController#']['tabMenus']['det']['menus'][1]['text'] = "#getLang('main',345,'Uyarılar')#";
			tabMenuStruct['#fuseactController#']['tabMenus']['det']['menus'][1]['onClick'] = "windowopen('#request.self#?fuseaction=objects.popup_page_warnings&action=content.view_content&action_name=cntid&action_id=#attributes.cntid#','list')";
			
			tabMenuStruct['#fuseactController#']['tabMenus']['det']['menus'][2]['text'] = "#getLang('content',159,'İçerik Takip')#";
			tabMenuStruct['#fuseactController#']['tabMenus']['det']['menus'][2]['onClick'] = "windowopen('#request.self#?fuseaction=content.popup_view_content_follows&cntid=#attributes.cntid#','list')";

			tabMenuStruct['#fuseactController#']['tabMenus']['det']['menus'][3]['text'] = "#getLang('main',6,'Literatür')#";
			tabMenuStruct['#fuseactController#']['tabMenus']['det']['menus'][3]['href'] = "#request.self#?fuseaction=rule.dsp_rule&cntid=#attributes.cntid#";	
			
			tabMenuStruct['#fuseactController#']['tabMenus']['det']['menus'][4]['text'] = "#getLang('main',773,'Yorumlar')#";
			tabMenuStruct['#fuseactController#']['tabMenus']['det']['menus'][4]['onClick'] = "windowopen('#request.self#?fuseaction=content.popup_view_content_comment&content_id=#url.cntid#','medium')";
			
			tabMenuStruct['#fuseactController#']['tabMenus']['det']['menus'][5]['text'] = '#getLang('main',1666)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['det']['menus'][5]['onclick'] = "windowopen('index.cfm?fuseaction=objects.popup_mail&module=content&trail=1','list','popup_mail')";

			tabMenuStruct['#fuseactController#']['tabMenus']['det']['icons']['add']['text'] = '#getLang('main',170)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['det']['icons']['add']['href'] = "#request.self#?fuseaction=training_management.list_content&event=add";
			tabMenuStruct['#fuseactController#']['tabMenus']['det']['icons']['add']['target'] = "_blank";

			tabMenuStruct['#fuseactController#']['tabMenus']['det']['icons']['copy']['text'] = '#getLang('main',64)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['det']['icons']['copy']['href'] = "#request.self#?fuseaction=training_management.list_content&event=add&cntid=#attributes.cntid#";
			tabMenuStruct['#fuseactController#']['tabMenus']['det']['icons']['copy']['target'] = "_blank";
			
            tabMenuStruct['#fuseactController#']['tabMenus']['det']['icons']['print']['text'] = '#getLang('','Yazdır','57474')#';
			tabMenuStruct['#fuseactController#']['tabMenus']['det']['icons']['print']['onclick'] = "window.open('#request.self#?fuseaction=objects.popup_print_editor&editor_name=fHtmlEditor.CONT_BODY&editor_header=fHtmlEditor.subject&module=content&title1=Başlık&title2=Detay')";
			
			tabMenuStruct['#fuseactController#']['tabMenus']['det']['icons']['fa fa-history']['text'] = "#getLang('main',61,'Tarihçe')#";
			tabMenuStruct['#fuseactController#']['tabMenus']['det']['icons']['fa fa-history']['onClick'] = "openBoxDraggable('#request.self#?fuseaction=content.popup_list_content_history&content_id=#url.cntid#')";
			
			tabMenuStruct['#fuseactController#']['tabMenus']['det']['icons']['bell']['text'] = '#getLang('','Uyarılar','57757')#';
			tabMenuStruct['#fuseactController#']['tabMenus']['det']['icons']['bell']['onclick'] = "window.open('#request.self#?fuseaction=objects.workflowpages&tab=3&action=#attributes.fuseaction#&action_name=cntid&action_id=#attributes.cntid#','Workflow')";
			
			tabMenuStruct['#fuseactController#']['tabMenus']['det']['icons']['list-ul']['target'] = "_blank";
			tabMenuStruct['#fuseactController#']['tabMenus']['det']['icons']['list-ul']['text'] = '#getLang('main',97)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['det']['icons']['list-ul']['href'] = "#request.self#?fuseaction=training_management.list_content";

			tabMenuStruct['#fuseactController#']['tabMenus']['det']['icons']['check']['text'] = '#getLang('main',49)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['det']['icons']['check']['onClick'] = "buttonClickFunction()";
			tabMenuData = SerializeJSON(tabMenuStruct['#fuseactController#']['tabMenus']);
		}
		
	}
</cfscript>