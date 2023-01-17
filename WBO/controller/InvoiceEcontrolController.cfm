<cfsavecontent variable="detail"><cf_get_lang dictionary_id="57771.Detaylar"></cfsavecontent>
	<cfsavecontent variable="edetail"><cf_get_lang dictionary_id="60555.Fatura Detay"></cfsavecontent>
<cfscript>
	if(attributes.tabMenuController eq 0)
	{
		// Switch //
		WOStruct = StructNew();
		
		WOStruct['#attributes.fuseaction#'] = structNew();	
		
		WOStruct['#attributes.fuseaction#']['default'] = 'list';
		if(not isdefined('attributes.event'))
			attributes.event = WOStruct['#attributes.fuseaction#']['default'];
		
		WOStruct['#attributes.fuseaction#']['list'] = structNew();
		WOStruct['#attributes.fuseaction#']['list']['window'] = 'normal';
		WOStruct['#attributes.fuseaction#']['list']['fuseaction'] = 'invoice.received_einvoices';
		WOStruct['#attributes.fuseaction#']['list']['filePath'] = 'V16/e_government/display/received_einvoices.cfm';
		WOStruct['#attributes.fuseaction#']['list']['queryPath'] = 'V16/e_government/cfc/get_efatura_det.cfc';

		WOStruct['#attributes.fuseaction#']['add'] = structNew();
		WOStruct['#attributes.fuseaction#']['add']['window'] = 'popup';
		WOStruct['#attributes.fuseaction#']['add']['fuseaction'] = 'invoice.popup_add_efatura_xml';
		WOStruct['#attributes.fuseaction#']['add']['filePath'] = 'V16/e_government/form/add_efatura_xml.cfm';
		WOStruct['#attributes.fuseaction#']['add']['queryPath'] = 'V16/e_government/query/add_efatura_xml.cfm';
		WOStruct['#attributes.fuseaction#']['add']['nextEvent'] = '';
		
		if(isdefined("attributes.receiving_detail_id")){
			WOStruct['#attributes.fuseaction#']['det'] = structNew();
			WOStruct['#attributes.fuseaction#']['det']['window'] = 'normal';
			WOStruct['#attributes.fuseaction#']['det']['fuseaction'] = 'objects.popup_dsp_efatura_detail';
			WOStruct['#attributes.fuseaction#']['det']['filePath'] = 'V16/e_government/display/dsp_efatura_detail.cfm';
			WOStruct['#attributes.fuseaction#']['det']['queryPath'] = 'V16/e_government/cfc/get_efatura_det.cfc';
			WOStruct['#attributes.fuseaction#']['det']['Identity'] = '#attributes.receiving_detail_id#';
			WOStruct['#attributes.fuseaction#']['det']['nextEvent'] = 'invoice.received_einvoices&event=det&type=1&receiving_detail_id=';
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
			tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['list-ul']['text'] = '#getLang('main',97)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['list-ul']['href'] = "#request.self#?fuseaction=invoice.received_einvoices";
			tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['check']['text'] = '#getLang('main',49)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['check']['onClick'] = "buttonClickFunction()";
		}
		if(caller.attributes.event is 'det')
		{		
			ekontrol_xslt=caller.attributes.ekontrol_xslt;
			if(CALLER.attributes.print eq 0){
				einvoice_id = caller.attributes.einvoice_id;
				eexpense_id=caller.attributes.eexpense_id;
				einvoice_cat=caller.attributes.einvoice_cat;
				eaction_type=caller.attributes.eaction_type;
				member_id=caller.attributes.member_id;
			}
			tabMenuStruct['#fuseactController#']['tabMenus']['det']['icons'] = structNew();
			
			tabMenuStruct['#fuseactController#']['tabMenus']['det']['icons']['list-ul']['text'] = '#getLang('main',97)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['det']['icons']['list-ul']['href'] = "#request.self#?fuseaction=invoice.received_einvoices";
			
			tabMenuStruct['#fuseactController#']['tabMenus']['det']['icons']['check']['text'] = '#getLang('main',49)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['det']['icons']['check']['onClick'] = "buttonClickFunction()";

			/* tabMenuStruct['#fuseactController#']['tabMenus']['det']['icons']['print']['text'] = '#getLang('main',62)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['det']['icons']['print']['onclick'] = "windowopen('#request.self#?fuseaction=objects.popup_print_files&iid=#attributes.receiving_detail_id#&print_type=10','page')"; */
			
			tabMenuStruct['#fuseactController#']['tabMenus']['det']['icons']['bell']['text'] = '#getlang('main',345)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['det']['icons']['bell']['onClick'] = "window.open('#request.self#?fuseaction=objects.workflowpages&tab=3&action=objects.popup_dsp_efatura_detail&action_name=action_id&action_id=#attributes.receiving_detail_id#','Workflow')";
			if( len(member_id)){
			tabMenuStruct['#fuseactController#']['tabMenus']['det']['icons']['detail']['text'] = '#detail#';
			tabMenuStruct['#fuseactController#']['tabMenus']['det']['icons']['detail']['href'] = "#request.self#?fuseaction=member.form_list_company&event=det&cpid=#member_id#";
			}
			tabMenuStruct['#fuseactController#']['tabMenus']['det']['icons']['fa fa-thumb-tack']['text'] = 'İlişkilendir';
			tabMenuStruct['#fuseactController#']['tabMenus']['det']['icons']['fa fa-thumb-tack']['href'] = "#request.self#?fuseaction=invoice.received_einvoices&event=det&receiving_detail_id=#attributes.receiving_detail_id#&associate=1";
		
				tabMenuStruct['#fuseactController#']['tabMenus']['det']['menus']['0']['text'] = '#edetail#';
				tabMenuStruct['#fuseactController#']['tabMenus']['det']['menus']['0']['onclick'] = "windowopen('#request.self#?fuseaction=objects.popup_dsp_efatura_detail&is_display=1&receiving_detail_id=#attributes.receiving_detail_id#&type=1&row=#ekontrol_xslt#','wide')";
			
			
			if(isdefined ("einvoice_id") and len(einvoice_id)){
				tabMenuStruct['#fuseactController#']['tabMenus']['det']['icons']['link']['text'] = 'İlişkili Belgeler';
				if(listfind("50,51,52,53,54,55,56,561,57,58,59,60,601,61,62,63,66,67,531,591,592,48,49,532",einvoice_cat,",")){
					tabMenuStruct['#fuseactController#']['tabMenus']['det']['icons']['link']['href'] ="#request.self#?fuseaction=invoice.form_add_bill_purchase&event=upd&iid=#einvoice_id#";
				}
				else if (listfind("65",einvoice_cat,",")){
					tabMenuStruct['#fuseactController#']['tabMenus']['det']['icons']['link']['href']  ="#request.self#?fuseaction=invent.add_invent_purchase&event=upd&invoice_id=#einvoice_id#";
				}
				else{
					tabMenuStruct['#fuseactController#']['tabMenus']['det']['icons']['link']['href'] ="#request.self#?fuseaction=invoice.form_add_bill_other&event=upd&iid=#einvoice_id#";
				}
				
			}
			if(isdefined("eexpense_id") and len(eexpense_id)){
				tabMenuStruct['#fuseactController#']['tabMenus']['det']['icons']['link']['text'] = 'İlişkili Belgeler';
				if(eaction_type eq 1201){
					tabMenuStruct['#fuseactController#']['tabMenus']['det']['icons']['link']['href'] ="#request.self#?fuseaction=health.expenses&event=upd&expense_id=#eexpense_id#";
				}
				else{
					tabMenuStruct['#fuseactController#']['tabMenus']['det']['icons']['link']['href'] ="#request.self#?fuseaction=cost.form_add_expense_cost&event=upd&expense_id=#eexpense_id#";
				}
			}
			
		}
		/*else if(caller.attributes.event is 'upd')
		{
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons'] = structNew();
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['add']['text'] = '#getLang('main',170)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['add']['href'] = "#request.self#?fuseaction=bank.form_add_virman";
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['add']['target'] = "_blank";
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['list-ul']['target'] = "_blank";
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['list-ul']['text'] = '#getLang('main',97)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['list-ul']['href'] = "#request.self#?fuseaction=bank.list_bank_actions";
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['check']['text'] = '#getLang('main',49)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['check']['onClick'] = "buttonClickFunction()";
		}*/
		tabMenuData = SerializeJSON(tabMenuStruct['#attributes.fuseaction#']['tabMenus']);
	}
/*	WOStruct['#attributes.fuseaction#']['systemObject']['extendedForm'] = true;
	WOStruct['#attributes.fuseaction#']['systemObject']['pageExtendedEventList'] = 'add,upd';
	WOStruct['#attributes.fuseaction#']['systemObject']['pageTableName'] = 'BANK_ACTIONS';
	WOStruct['#attributes.fuseaction#']['systemObject']['pageIdentityColumn'] = 'ACTION_ID';
	WOStruct['#attributes.fuseaction#']['systemObject']['pageSettings'] = "['item-process_cat','item-from_account_id','item-to_account_id','item-ACTION_DATE','item-ACTION_VALUE']";
*/</cfscript>