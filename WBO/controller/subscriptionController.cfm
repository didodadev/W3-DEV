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
        WOStruct['#attributes.fuseaction#']['list']['fuseaction'] = 'sales.list_subscription_contract';
        WOStruct['#attributes.fuseaction#']['list']['filePath'] = 'V16/sales/display/list_subscription_contract.cfm';
        WOStruct['#attributes.fuseaction#']['list']['queryPath'] = 'V16/sales/display/list_subscription_contract.cfm';


        WOStruct['#attributes.fuseaction#']['add'] = structNew();
        WOStruct['#attributes.fuseaction#']['add']['window'] = 'normal';
        WOStruct['#attributes.fuseaction#']['add']['fuseaction'] = 'sales.list_subscription_contract&event=add';
        WOStruct['#attributes.fuseaction#']['add']['filePath'] = 'V16/sales/form/add_subscription_contract.cfm';
        WOStruct['#attributes.fuseaction#']['add']['queryPath'] = 'V16/sales/query/add_subscription_contract.cfm';
        WOStruct['#attributes.fuseaction#']['add']['nextEvent'] = 'sales.list_subscription_contract&event=upd&subscription_id=';

        if(isdefined("attributes.subscription_id"))
        {
            WOStruct['#attributes.fuseaction#']['upd'] = structNew();
            WOStruct['#attributes.fuseaction#']['upd']['window'] = 'normal';
            WOStruct['#attributes.fuseaction#']['upd']['fuseaction'] = 'sales.upd_subscription_contract';
            WOStruct['#attributes.fuseaction#']['upd']['filePath'] = 'V16/sales/form/upd_subscription_contract.cfm';
            WOStruct['#attributes.fuseaction#']['upd']['queryPath'] = 'V16/sales/query/upd_subscription_contract.cfm';
            WOStruct['#attributes.fuseaction#']['upd']['Identity'] = '#attributes.subscription_id#';
            WOStruct['#attributes.fuseaction#']['upd']['nextEvent'] = 'sales.list_subscription_contract&event=upd&subscription_id=';

            WOStruct['#attributes.fuseaction#']['del'] = structNew();
            WOStruct['#attributes.fuseaction#']['del']['window'] = 'emptypopup';
            WOStruct['#attributes.fuseaction#']['del']['fuseaction'] = 'sales.emptypopup_upd_subscription_contract&event=del&subscription_id=#attributes.subscription_id#';
            WOStruct['#attributes.fuseaction#']['del']['filePath'] = 'V16/sales/query/del_subscription_contract.cfm';
            WOStruct['#attributes.fuseaction#']['del']['queryPath'] = 'V16/sales/query/del_subscription_contract.cfm';
        }

    }
    else  {
        fuseactController = caller.attributes.fuseaction;
        getLang = caller.getLang;

        tabMenuStruct = StructNew();
        tabMenuStruct['#fuseactController#'] = structNew();
        tabMenuStruct['#fuseactController#']['tabMenus'] = structNew();

        if (caller.attributes.event is 'add') {

            tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons'] = structNew();
            tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['list-ul']['target'] = "_blank";
            tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['list-ul']['text'] = '#getLang('sales','Liste',40956)#';
            tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['list-ul']['href'] = "#request.self#?fuseaction=sales.list_subscription_contract";
            tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['check']['text'] = '#getLang('main','Kaydet',57461)#';
            tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['check']['onClick'] = "buttonClickFunction()";
            tabMenuData = SerializeJSON(tabMenuStruct['#attributes.fuseaction#']['tabMenus']);

        }
        if (caller.attributes.event is 'upd')
        {
            xml_is_invoice_member =caller.xml_is_invoice_member;
            xml_iam =caller.xml_iam;
            GET_SUBSCRIPTION = caller.GET_SUBSCRIPTION;

            tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons'] = structNew();
            tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['add']['text'] = '#getLang('main','Abone',58832)#'&' '&#getLang('main','Ekle',57582)#;
            tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['add']['href'] = "#request.self#?fuseaction=sales.list_subscription_contract&event=add";
            tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['add']['target'] = "_blank";
            tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['copy']['text'] = '#getLang('main','Abone',58832)#'&' '&#getLang('main','Kopyala',57476)#;
            tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['copy']['href'] = "#request.self#?fuseaction=sales.list_subscription_contract&event=add&subscription_id=#attributes.subscription_id#";
            tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['copy']['target'] = "_blank";
            tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['bell']['text'] = '#getlang('main','Uyarılar',57757)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['bell']['href'] = "#request.self#?fuseaction=objects.workflowpages&tab=3&action=sales.list_subscription_contract&event=upd&action_name=subscription_id&action_id=#attributes.subscription_id#";
            tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['bell']['target'] = '_blank';
            tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['print']['text'] = '#getLang('main','Yazdır',57474)#';
            tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['print']['onClick'] = "windowopen('#request.self#?fuseaction=objects.popup_print_files&iid=#attributes.subscription_id#&print_type=74','page','workcube_print')";
            tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['list-ul']['target'] = "_blank";
            tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['list-ul']['text'] = '#getLang('sales','Listele',40956)#';
            tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['list-ul']['href'] = "#request.self#?fuseaction=sales.list_subscription_contract";
            tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['check']['text'] = '#getLang('main','Güncelle',57464)#';
            tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['check']['onClick'] = "buttonClickFunction()";
            i=0;
            if(session.ep.our_company_info.sms eq 1)
            {
                if (len(get_subscription.invoice_company_id))
                {
                    member_type_ = 'partner';
                    member_id_ = get_subscription.invoice_company_id;
                }
                else if (len(get_subscription.invoice_consumer_id))
                {
                    member_type_ = 'consumer';
                    member_id_ = get_subscription.invoice_consumer_id;
                }
                tabMenuStruct['#fuseactController#']['tabMenus']['upd']['menus'][i]['text'] = '#getLang('main','Hesap Ekstresi',57809)#';
                tabMenuStruct['#fuseactController#']['tabMenus']['upd']['menus'][i]['onclick'] = "windowopen('#request.self#?fuseaction=objects.popup_list_comp_extre&member_type=#member_type_#&member_id=#member_id_#','page')";
                i=i+1;
                tabMenuStruct['#fuseactController#']['tabMenus']['upd']['menus'][i]['text'] = '#getLang('main','SMS Gönder',58590)#';
                tabMenuStruct['#fuseactController#']['tabMenus']['upd']['menus'][i]['onclick'] = "windowopen('#request.self#?fuseaction=objects.popup_form_send_sms&member_type=#member_type_#&member_id=#member_id_#&paper_type=8&paper_id=#attributes.subscription_id#&sms_action=#fuseaction#','small')";
                i=i+1;
            }

            tabMenuStruct['#fuseactController#']['tabMenus']['upd']['menus'][i]['text'] = '#getLang('','Sözleşme Elektronik Onayları',64849)#';
            tabMenuStruct['#fuseactController#']['tabMenus']['upd']['menus'][i]['href'] = "#request.self#?fuseaction=sales.subscription_approve&subscription_id=#get_subscription.subscription_id#";
            tabMenuStruct['#fuseactController#']['tabMenus']['upd']['menus'][i]['target'] = "blank";
            i=i+1;
            
            if(len(get_subscription.company_id))
            {
                tabMenuStruct['#fuseactController#']['tabMenus']['upd']['menus'][i]['text'] = '#getLang('sales','Zaman Harcaması Ekle',41270)#';
                tabMenuStruct['#fuseactController#']['tabMenus']['upd']['menus'][i]['href'] = "#request.self#?fuseaction=myhome.mytime_management&event=add&subscription_id=#get_subscription.subscription_id#&comp_id=#get_subscription.COMPANY_ID#&partner_id=#get_subscription.PARTNER_ID#&is_subscription=1";
                tabMenuStruct['#fuseactController#']['tabMenus']['upd']['menus'][i]['target'] = "blank";
                i=i+1;
            }
            else if(len(get_subscription.consumer_id))
            {
                tabMenuStruct['#fuseactController#']['tabMenus']['upd']['menus'][i]['text'] = '#getLang('sales','Zaman Harcaması Ekle',41270)#';
                tabMenuStruct['#fuseactController#']['tabMenus']['upd']['menus'][i]['href'] = "#request.self#?fuseaction=myhome.mytime_management&event=add&subscription_id=#get_subscription.subscription_id#&cons_id=#get_subscription.CONSUMER_ID#&is_subscription=1";
                tabMenuStruct['#fuseactController#']['tabMenus']['upd']['menus'][i]['target'] = "blank";
                i=i+1;
            }
            tabMenuStruct['#fuseactController#']['tabMenus']['upd']['menus'][i]['text'] = '#getLang('sales','Sayaç okuma',41271)#';
            tabMenuStruct['#fuseactController#']['tabMenus']['upd']['menus'][i]['onclick'] = "openBoxDraggable('#request.self#?fuseaction=sales.popup_add_subscription_read_counter&subscription_id=#attributes.subscription_id#&subscription_no=#get_subscription.subscription_no#')";
            i=i+1;
            tabMenuStruct['#fuseactController#']['tabMenus']['upd']['menus'][i]['text'] = '#getLang('sales','Partition Detay',41132)#';
            tabMenuStruct['#fuseactController#']['tabMenus']['upd']['menus'][i]['onclick'] = "openBoxDraggable('#request.self#?fuseaction=sales.popup_list_subscription_partition&subscription_id=#attributes.subscription_id#')";
            i=i+1;
            tabMenuStruct['#fuseactController#']['tabMenus']['upd']['menus'][i]['text'] = '#getLang('sales','Ek Sayfa Ekle',40862)#';
            tabMenuStruct['#fuseactController#']['tabMenus']['upd']['menus'][i]['onclick'] = "windowopen('#request.self#?fuseaction=sales.popup_add_subscription_page&subs_id=#attributes.subscription_id#','page')";
            i=i+1;
            tabMenuStruct['#fuseactController#']['tabMenus']['upd']['menus'][i]['text'] = '#getLang('main','Ödeme Listesi',59657)#';
            tabMenuStruct['#fuseactController#']['tabMenus']['upd']['menus'][i]['onclick'] = "windowopen('#request.self#?fuseaction=sales.popup_dsp_subscription_payment_plan&subscription_id=#get_subscription.subscription_id#','wwide','popup_dsp_subscription_payment_plan')";
            i=i+1;
          /*   if(xml_iam eq 1)
            {
                tabMenuStruct['#fuseactController#']['tabMenus']['upd']['menus'][i]['text'] = '#getLang('','IAM User','63651')#';
                tabMenuStruct['#fuseactController#']['tabMenus']['upd']['menus'][i]['href'] = "#request.self#?fuseaction=plevne.iam&subs_no=#get_subscription.subscription_no#&is_form_submitted=1";
                tabMenuStruct['#fuseactController#']['tabMenus']['upd']['menus'][i]['target'] = "blank";
                i=i+1;
            } */
            
            if(len(get_subscription.company_id))
            {

                comp_id_list_ = get_subscription.company_id & "," & get_subscription.invoice_company_id;
                tabMenuStruct['#fuseactController#']['tabMenus']['upd']['menus'][i]['text'] = '#getLang('sales','Ödeme Planı',41108)#';
                tabMenuStruct['#fuseactController#']['tabMenus']['upd']['menus'][i]['href'] = "#request.self#?fuseaction=sales.subscription_payment_plan&event=add&subscription_id=#get_subscription.subscription_id#&subs_no=#get_subscription.subscription_no#&comp_id=#comp_id_list_#";
                tabMenuStruct['#fuseactController#']['tabMenus']['upd']['menus'][i]['target'] = "blank";
            }
            else
            {
                cons_id_list_ = get_subscription.consumer_id &"," & get_subscription.invoice_consumer_id;
                tabMenuStruct['#fuseactController#']['tabMenus']['upd']['menus'][i]['text'] = '#getLang('sales','Ödeme Planı',41108)#';
                tabMenuStruct['#fuseactController#']['tabMenus']['upd']['menus'][i]['href'] = "#request.self#?fuseaction=sales.subscription_payment_plan&event=add&subscription_id=#get_subscription.subscription_id#&subs_no=#get_subscription.subscription_no#&cons_id=#cons_id_list_#";
                tabMenuStruct['#fuseactController#']['tabMenus']['upd']['menus'][i]['target'] = "blank"; 
            }
            i=i+1;
            tabMenuStruct['#fuseactController#']['tabMenus']['upd']['menus'][i]['text'] = '#getLang('sales','CallCenter Başvuru Ekle',41275)#';
            tabMenuStruct['#fuseactController#']['tabMenus']['upd']['menus'][i]['onclick'] = "add_call_center.submit()";
            i=i+1;
            tabMenuStruct['#fuseactController#']['tabMenus']['upd']['menus'][i]['text'] = '#getLang('sales','CallCenter Başvurular',41276)#';
            tabMenuStruct['#fuseactController#']['tabMenus']['upd']['menus'][i]['onclick'] = "list_call_center.submit()";
            i=i+1;
            if(len(get_subscription.invoice_company_id))
            {
                company_id=#get_subscription.invoice_company_id#;
            }
            else
            {
                consumer_id=#get_subscription.invoice_consumer_id#;
            }
            tabMenuStruct['#fuseactController#']['tabMenus']['upd']['menus'][i]['text'] = '#getLang('sales','Sanal POS',41272)#';
            tabMenuStruct['#fuseactController#']['tabMenus']['upd']['menus'][i]['onclick'] = "windowopen('#request.self#?fuseaction=bank.list_multi_provision&event=add&subscription_id=#get_subscription.subscription_id#&subscription_no=#get_subscription.subscription_no#','wide')";
            i=i+1;
            tabMenuStruct['#fuseactController#']['tabMenus']['upd']['menus'][i]['text'] = '#getLang('sales','Sistem İptal',41137)#';
            tabMenuStruct['#fuseactController#']['tabMenus']['upd']['menus'][i]['onclick'] = "openBoxDraggable('#request.self#?fuseaction=sales.popup_subscription_to_cancel&subscription_id=#get_subscription.subscription_id#','','ui-draggable-box-small')";
            i=i+1;

            if(xml_is_invoice_member==1)
            {
                xml_is_invoice_member_val=xml_is_invoice_member;
            }
            else if(xml_is_invoice_member==0)
            {
                xml_is_invoice_member_val=xml_is_invoice_member;
            }
            tabMenuStruct['#fuseactController#']['tabMenus']['upd']['menus'][i]['text'] = '#getLang('main','Sipariş Ekle',58989)#';
            tabMenuStruct['#fuseactController#']['tabMenus']['upd']['menus'][i]['href'] = "#request.self#?fuseaction=sales.list_order&event=add&subscription_id=#get_subscription.subscription_id#&xml_is_invoice_member=#xml_is_invoice_member_val#";
            tabMenuStruct['#fuseactController#']['tabMenus']['upd']['menus'][i]['target'] = "";
            i=i+1;
            tabMenuStruct['#fuseactController#']['tabMenus']['upd']['menus'][i]['text'] = '#getLang('sales','Başvuru Ekle',41273)#';
            tabMenuStruct['#fuseactController#']['tabMenus']['upd']['menus'][i]['onclick'] = "add_service.submit()";
            i=i+1;
            tabMenuStruct['#fuseactController#']['tabMenus']['upd']['menus'][i]['text'] = '#getLang('main','Başvurular',58186)#';
            tabMenuStruct['#fuseactController#']['tabMenus']['upd']['menus'][i]['onclick'] = "list_service.submit()";
            i=i+1;
            if(len(get_subscription.company_id))
            {
                tabMenuStruct['#fuseactController#']['tabMenus']['upd']['menus'][i]['text'] = '#getLang('sales','Olaylar',41005)#';
                tabMenuStruct['#fuseactController#']['tabMenus']['upd']['menus'][i]['onclick'] = "openBoxDraggable('#request.self#?fuseaction=member.popup_list_comp_agenda&company_id=#get_subscription.company_id#&partner_id=#get_subscription.partner_id#')";
            }
            else
            {
                tabMenuStruct['#fuseactController#']['tabMenus']['upd']['menus'][i]['text'] = '#getLang('sales','Olaylar',41005)#';
                tabMenuStruct['#fuseactController#']['tabMenus']['upd']['menus'][i]['onclick'] = "windowopen('#request.self#?fuseaction=member.popup_list_con_agenda&consumer_id=#get_subscription.consumer_id#','list','popup_list_comp_agenda')";
            }
            i=i+1;
            tabMenuStruct['#fuseactController#']['tabMenus']['upd']['menus'][i]['text'] = '#getLang('main','Ek Bilgi',57810)#';
            tabMenuStruct['#fuseactController#']['tabMenus']['upd']['menus'][i]['onclick'] = "openBoxDraggable('#request.self#?fuseaction=objects.popup_list_comp_add_info&sub_catid=#get_subscription.subscription_type_id#&info_id=#attributes.subscription_id#&type_id=-11','','ui-draggable-box-small')";
            i=i+1;
            tabMenuStruct['#fuseactController#']['tabMenus']['upd']['menus'][i]['text'] = '#getLang('sales','Prim Bilgileri',41131)#';
            tabMenuStruct['#fuseactController#']['tabMenus']['upd']['menus'][i]['onclick'] = "openBoxDraggable('#request.self#?fuseaction=sales.popup_premium_info&subscription_id=#attributes.subscription_id#','','ui-draggable-box-small')";
            i=i+1;
            if(session.ep.userid eq 16 or session.ep.userid eq 292)
            {
                tabMenuStruct['#fuseactController#']['tabMenus']['upd']['menus'][i]['text'] = '#getLang('','Abone Bakım Planı Atama',62274)#';
                tabMenuStruct['#fuseactController#']['tabMenus']['upd']['menus'][i]['href'] = "#request.self#?fuseaction=report.detail_report&report_id=415&subscription_id=#attributes.subscription_id#";
                tabMenuStruct['#fuseactController#']['tabMenus']['upd']['menus'][i]['target'] = "";
                i=i+1;
                tabMenuStruct['#fuseactController#']['tabMenus']['upd']['menus'][i]['text'] = '#getLang('','Abone Bilg. Atama',62275)#';
                tabMenuStruct['#fuseactController#']['tabMenus']['upd']['menus'][i]['href'] = "#request.self#?fuseaction=report.detail_report&report_id=418&subscription_id=#attributes.subscription_id#";
                tabMenuStruct['#fuseactController#']['tabMenus']['upd']['menus'][i]['target'] = "";
                i=i+1;
                tabMenuStruct['#fuseactController#']['tabMenus']['upd']['menus'][i]['text'] = '#getLang('','Abone Bilg. Atama',62275)#';
                tabMenuStruct['#fuseactController#']['tabMenus']['upd']['menus'][i]['href'] = "#request.self#?fuseaction=report.detail_report&report_id=419&subscription_id=#attributes.subscription_id#";
                tabMenuStruct['#fuseactController#']['tabMenus']['upd']['menus'][i]['target'] = "";
                i=i+1;
                tabMenuStruct['#fuseactController#']['tabMenus']['upd']['menus'][i]['text'] = '#getLang('','Lokasyon Bazlı Atama',62277)#';
                tabMenuStruct['#fuseactController#']['tabMenus']['upd']['menus'][i]['href'] = "#request.self#?fuseaction=report.detail_report&report_id=424&subscription_id=#attributes.subscription_id#";
                tabMenuStruct['#fuseactController#']['tabMenus']['upd']['menus'][i]['target'] = "";
                i=i+1;
            }
           
            if(session.ep.our_company_info.guaranty_followup)
            {
                tabMenuStruct['#fuseactController#']['tabMenus']['upd']['menus'][i]['text'] = '#getLang('main','Garanti',57717)#'&' - '&#getLang('main','Seri Nolar',57718)#;
                tabMenuStruct['#fuseactController#']['tabMenus']['upd']['menus'][i]['href'] = "#request.self#?fuseaction=stock.list_serial_operations&is_filtre=1&belge_no=#get_subscription.subscription_no#&process_cat_id=1193&process_id=#get_subscription.subscription_id#";
                tabMenuStruct['#fuseactController#']['tabMenus']['upd']['menus'][i]['target'] = "";
                i=i+1;
            }
            tabMenuStruct['#fuseactController#']['tabMenus']['upd']['menus'][i]['text'] = '#getLang('project', 160)#';
            tabMenuStruct['#fuseactController#']['tabMenus']['upd']['menus'][i]['onclick'] = "openBoxDraggable('#request.self#?fuseaction=sales.popup_list_actions&subscription_id=#get_subscription.subscription_id#')";
            tabMenuStruct['#fuseactController#']['tabMenus']['upd']['menus'][i]['target'] = "";
            tabMenuData = SerializeJSON(tabMenuStruct['#attributes.fuseaction#']['tabMenus']);
        }
    }

    WOStruct['#attributes.fuseaction#']['systemObject']['extendedForm'] = true;
    WOStruct['#attributes.fuseaction#']['systemObject']['pageExtendedEventList'] = 'add,upd';
    WOStruct['#attributes.fuseaction#']['systemObject']['pageTableName'] = 'SUBSCRIPTION_CONTRACT';
    WOStruct['#attributes.fuseaction#']['systemObject']['pageIdentityColumn'] = 'SUBSCRIPTION_ID';
    WOStruct['#attributes.fuseaction#']['systemObject']['pageSettings'] = "['item-subscription_head' , 'item-form_ul_company_name' , 'item-form_ul_process_stage' , 'item-form_ul_subscription_type' , 'item-form_ul_start_date']";

</cfscript>