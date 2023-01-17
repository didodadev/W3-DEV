<!-----------------------------------------------------------------------
*************************************************************************
		Copyright Workcube E-Business Inc. www.workcube.com
*************************************************************************
Analys		: Fatih Ayık			Developer	: Semih Bozal		
Analys Date : 01/04/2016			Dev Date	: 17/05/2016		
Description :
	* Bu controller etkileşim objesine ait kontrolleri yapar modelleri çağırarak ilgili setleri çalıştırır.
	
	* add,upd ve list eventlerini içerisinde barındırır.
	* objede kullanılan utilityler tanımlanır.
----------------------------------------------------------------------->

<cfif not isdefined('attributes.formSubmittedController')>
	<!--- objede kullanılan utility ler --->
    <cfscript>
		get_com_method = getComMethod.get();
		get_interaction_cat = getInteractionCat.get();
		get_special_definition = getSpecialDefinition.get(specialDefinitionType:5);
		if(isdefined("attributes.event") and listFind('add,upd',attributes.event))
			get_module_template = getModuleTemplate.get(templateModule:27);		
		if((isdefined("attributes.event") and attributes.event is 'list') or not isdefined("attributes.event"))
			getCompanyCat = getCompanyCat.get();
	</cfscript>
   
    <cf_get_lang_set module_name="call">
    <cfif (isdefined("attributes.event") and attributes.event is 'list') or not isdefined("attributes.event")>
        <cf_xml_page_edit fuseact="call.helpdesk">
        
        <cfparam name="attributes.record_emp" default="">
        <cfparam name="attributes.record_name" default="">
        <cfparam name="attributes.keyword" default="">
        <cfparam name="attributes.app_cat" default="">
        <cfparam name="attributes.subscription_id" default="">
        <cfparam name="attributes.subscription_no" default="">
        <cfparam name="attributes.applicant_name" default="">
        <cfparam name="attributes.is_reply" default="">
        <cfparam name="attributes.process_stage" default="">
        <cfparam name="attributes.site_domain" default="">
        <cfparam name="attributes.company_id" default="">
        <cfparam name="attributes.member_name" default="">
        <cfparam name="attributes.partner_id" default="">
        <cfparam name="attributes.consumer_id" default="">
        <cfparam name="attributes.member_type" default="">
        <cfparam name="attributes.interactioncat_id" default="">
        <cfparam name="attributes.interaction_cat" default="">
        <cfparam name="attributes.special_definition" default="">
        <cfparam name="attributes.subscriber_stage" default="">
        <cfparam name="attributes.project_id" default="">
        <cfparam name="attributes.comp_cat" default="">
        <cfif isdefined("attributes.start_date") and isdate(attributes.start_date)>
            <cf_date tarih = "attributes.start_date">
        <cfelse>
            <cfset attributes.start_date = date_add('d',-7,createodbcdatetime('#session.ep.period_year#-#month(now())#-#day(now())#'))>
        </cfif>
        <cfif isdefined("attributes.finish_date") and isdate(attributes.finish_date)>
            <cf_date tarih = "attributes.finish_date">
        <cfelse>
            <cfset attributes.finish_date = date_add('d',7,attributes.start_date)>
        </cfif>
        <cfset attributes.finish_date = date_add('h',23,attributes.finish_date)>
        <cfset attributes.finish_date = date_add('n',59,attributes.finish_date)>
        <cfquery name="GET_MAIN_MENU" datasource="#DSN#">
            SELECT SITE_DOMAIN FROM MAIN_MENU_SETTINGS WHERE SITE_DOMAIN IS NOT NULL	
        </cfquery>
        <cfif isDefined('x_show_authorized_stage') and x_show_authorized_stage eq 1>
            <cf_workcube_process_info>
        </cfif>
        <cfquery name="GET_CALLCENTER_STAGE" datasource="#DSN#">
            SELECT
                PTR.STAGE,
                PTR.PROCESS_ROW_ID 
            FROM
                PROCESS_TYPE_ROWS PTR,
                PROCESS_TYPE_OUR_COMPANY PTO,
                PROCESS_TYPE PT
            WHERE
                PT.IS_ACTIVE = 1 AND
                PTR.PROCESS_ID = PT.PROCESS_ID AND
                PT.PROCESS_ID = PTO.PROCESS_ID AND
                PTO.OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#"> AND
                PT.FACTION LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%call.helpdesk%">
                <cfif isDefined('x_show_authorized_stage') and x_show_authorized_stage eq 1 and isDefined("process_rowid_list") and ListLen(process_rowid_list)>
                    AND PTR.PROCESS_ROW_ID IN (#process_rowid_list#)
                </cfif>
        </cfquery>
        <cfquery name="GET_SUBSCRIBER_STAGE" datasource="#DSN#">
            SELECT
                PTR.STAGE,
                PTR.PROCESS_ROW_ID 
            FROM
                PROCESS_TYPE_ROWS PTR,
                PROCESS_TYPE_OUR_COMPANY PTO,
                PROCESS_TYPE PT
            WHERE
                PT.IS_ACTIVE = 1 AND
                PTR.PROCESS_ID = PT.PROCESS_ID AND
                PT.PROCESS_ID = PTO.PROCESS_ID AND
                PTO.OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#"> AND
                PT.FACTION LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%sales.list_subscription_contract%">
                <cfif isDefined('x_show_authorized_stage') and x_show_authorized_stage eq 1 and isDefined("process_rowid_list") and ListLen(process_rowid_list)>
                    AND PTR.PROCESS_ROW_ID IN (#process_rowid_list#)
                </cfif>
        </cfquery>
    </cfif>
    
	<cfif isdefined("attributes.event") and attributes.event is 'add'>
        <cfparam name="attributes.company" default="">
        <cfparam name="attributes.workcube_id" default="">
        <cfparam name="attributes.email" default="">
        <cfparam name="attributes.app_name" default="">
        <cfparam name="attributes.help_page" default="">
        <cfparam name="attributes.product_name" default="">

        <cfscript>
			if(isdefined("attributes.partner_id") and len(attributes.partner_id))
				getCompanyPartnerInfo = getCompanyPartnerInfo.get(partnerId:attributes.partner_id);
			else if(isdefined("attributes.company_id") and len(attributes.company_id))
				getCompanyPartnerInfo = getCompanyPartnerInfo.get(companyId:attributes.company_id);
			else if(isdefined("attributes.consumer_id") and len(attributes.consumer_id))
				getConsumerInfo = getConsumerInfo.get(consumerId:attributes.consumer_id);
		
            get_help.interaction_cat = '';
            get_help.app_cat = '';
            get_help.special_definition_id = '';
            campName = '';
            campId = '';
            subscriptionNo = '';
            subscriptionId = '';
            productId = '';
            productName = '';
            subject = session.ep.company;
            if(isdefined("getCompanyPartnerInfo") and len(getCompanyPartnerInfo.recordcount)) 
                {
                    consumerId = '';
                    companyName = getCompanyPartnerInfo.nickname;
                    partnerId = attributes.partner_id;
                    companyId = getCompanyPartnerInfo.company_id;
                    memberType = "partner";
                    memberName = getCompanyPartnerInfo.company_partner_name &' '& getCompanyPartnerInfo.company_partner_surname;
                    applicantName = getCompanyPartnerInfo.company_partner_name &' '& getCompanyPartnerInfo.company_partner_surname;
                    if(isdefined("get_partner.mail") and len("get_partner.mail")) applicantMail = getCompanyPartnerInfo.company_partner_email;
                }
            else if(isdefined("attributes.consumer_id"))
                {
                    companyName = '';
                    partnerId = '';
                    companyId = '';
                    consumerId= attributes.consumer_id;
                    memberName = getConsumerInfo.consumer_name &' '& getConsumerInfo.consumer_surname;
                    memberType = "consumer";
                    applicantName = getConsumerInfo.consumer_name &' '& getConsumerInfo.consumer_surname;
                    if (isdefined("get_consumer.mail") and len("get_consumer.mail")) applicantMail = getConsumerInfo.consumer_email;
                }
            else
                {
                    companyName = '';
                    partnerId = '';
                    companyId = '';
                    consumerId = '';
                    memberName = '';
                    memberType = '';
                    applicantName = attributes.app_name;
                    applicantMail = '';
                }
                
            telCode = "";
            telNo = "";
            editor = "";
            action_date = now();
			detail = '';
        </cfscript>
    <cfelseif isdefined("attributes.event") and listFind('upd,det',attributes.event)>
        <cfscript>
			get_help = CallLeadModel.get(cus_help_id:attributes.cus_help_id);
			
            if(len(get_help.partner_id)) 
                {
                    consumerId = '';
                    partnerId = get_help.partner_id;
                    companyId = get_help.company_id;
                    memberType = "partner";
                    memberName = get_help.partner_name;
                    companyName = get_help.nickname;
                }
            else if(isdefined("attributes.consumer_id"))
                {
                    companyName = '';
                    partnerId = '';
                    companyId = '';
                    consumerId= get_help.consumer_id;
                    memberName = get_help.cons_name;
                    memberType = "consumer";
                }
            else
                {
                    companyName = '';
                    partnerId = '';
                    companyId = '';
                    consumerId = '';
                    memberName = '';
                    memberType = '';
                    applicantName = '';
                    applicantMail = '';
                }
            action_date = get_help.interaction_date;			
            campName = get_help.camp_head;
            campId = get_help.camp_id;
            subscriptionNo = get_help.subscription_id;
            subscriptionId = get_help.subscription_no;
            productId = get_help.product_id;
            productName = get_help.PRODUCT_NAME;
            detail = get_help.detail;
            applicantName = get_help.applicant_name;
            applicantMail = get_help.applicant_mail;
            telCode = get_help.customer_telcode;
            telNo = get_help.customer_telno;
            editor = get_help.detail;
            subject = get_help.subject;
        </cfscript>
    </cfif>
    
    <script type="text/javascript">
    //Event : list
    <cfif (isdefined("attributes.event") and attributes.event is 'list') or not isdefined("attributes.event")>
        $( document ).ready(function() {
            $('#keyword').focus();
        });
        function kontrol()
        {
            if ($('#project_head').val() == '')
                $('#project_id').val('');
            if(!date_check(document.getElementById("start_date"), document.getElementById("finish_date"), "<cf_get_lang no='109.Başlangıç Tarihi Bitiş Tarihinden Büyük Olamaz'>!") )
                return false;
            else
                return true;
        }	
        //Event : add
        
    <cfelseif isdefined("attributes.event") and listFindNoCase('add,upd',attributes.event)>	
        function changevalue()
        {
            $('#applicant_name').val($('#member_name').val());
        }
    
        function _load(template_id)
        {
            if(template_id != undefined)
            {
                <cfif attributes.event is 'upd'>
                    AjaxPageLoad('<cfoutput>#request.self#?fuseaction=call.popup_get_template&cus_help_id=#attributes.cus_help_id#</cfoutput>&template_id='+template_id+'','fckedit',1);
                <cfelse>
                    AjaxPageLoad('<cfoutput>#request.self#</cfoutput>?fuseaction=call.popup_get_template&template_id='+template_id+'','fckedit',1);
                </cfif>
            }
        }
    
        function kontrol(type)
        {
            var formName = 'add_helpdesk';
            form  = $('form[name="'+ formName +'"]');
            <cfif listfindnocase('upd',attributes.event)>
                $( "#subject" ).prop( "disabled", false );
            </cfif>	
            if(type==1)
            {
                if($('#applicant_mail').val() == ''	) 
                    {
                         validateMessage('notValid',form.find('input#applicant_mail'));
                         return false;
                    }
                else
                    {
                        validateMessage('valid',form.find('input#applicant_mail') );
                    }
                if(!$('#email').val().length)
                    $('#email').val(1);
            }
            else
                 $('#email').val(0);	
            return true;
        }
        </cfif>
    </script>
</cfif>

<cfscript>
	WOStruct = StructNew();
	
	WOStruct['#attributes.fuseaction#'] = structNew();
	
	WOStruct['#attributes.fuseaction#']['default'] = 'list';

	if(not isdefined("attributes.event"))
		attributes.event = WOStruct['#attributes.fuseaction#']['default'];
	
	WOStruct['#attributes.fuseaction#']['systemObject'] = structNew();	
	WOStruct['#attributes.fuseaction#']['systemObject']['processStage'] = true;
	if(not isdefined('attributes.formSubmittedController') and isdefined("attributes.event") and (attributes.event contains 'upd' or attributes.event contains 'det'))
		WOStruct['#attributes.fuseaction#']['systemObject']['processStageSelected'] = GET_HELP.PROCESS_STAGE;
	else
		WOStruct['#attributes.fuseaction#']['systemObject']['processStageSelected'] = '';
	
	WOStruct['#attributes.fuseaction#']['systemObject']['paperDate'] = true;
	
	WOStruct['#attributes.fuseaction#']['systemObject']['isTransaction'] = true;
	WOStruct['#attributes.fuseaction#']['systemObject']['dataSourceName'] = dsn; // Transaction icin yapildi.*/
	

	WOStruct['#attributes.fuseaction#']['systemObject']['extendedForm'] = true;
	WOStruct['#attributes.fuseaction#']['systemObject']['pageExtendedEventList'] = 'add,upd,det';
	WOStruct['#attributes.fuseaction#']['systemObject']['pageTableName'] = 'CUSTOMER_HELP';
	WOStruct['#attributes.fuseaction#']['systemObject']['pageIdentityColumn'] = 'CUS_HELP_ID';
	WOStruct['#attributes.fuseaction#']['systemObject']['pageSettings'] = "['item-app_cat','item-company_name','item-detail','item-member_name','item-editor','item-applicant_name']";	
	
	WOStruct['#attributes.fuseaction#']['list'] = structNew();
	WOStruct['#attributes.fuseaction#']['list']['window'] = 'normal';
	WOStruct['#attributes.fuseaction#']['list']['fuseaction'] = 'call.helpdesk';
	WOStruct['#attributes.fuseaction#']['list']['filePath'] = 'callcenter/display/helpdesk.cfm';
	
	WOStruct['#attributes.fuseaction#']['add'] = structNew();
	WOStruct['#attributes.fuseaction#']['add']['window'] = 'normal';
	WOStruct['#attributes.fuseaction#']['add']['fuseaction'] = 'call.add_helpdesk';
	WOStruct['#attributes.fuseaction#']['add']['filePath'] = 'callcenter/form/FormCallLead.cfm';
	WOStruct['#attributes.fuseaction#']['add']['queryPath'] = '';
	WOStruct['#attributes.fuseaction#']['add']['nextEvent'] = 'call.helpdesk&event=det&cus_help_id=';
	WOStruct['#attributes.fuseaction#']['add']['formName'] = 'add_helpdesk';
	
	WOStruct['#attributes.fuseaction#']['add']['buttons'] = structNew();
	WOStruct['#attributes.fuseaction#']['add']['buttons']['save'] = 1;
	WOStruct['#attributes.fuseaction#']['add']['buttons']['saveFunction'] = 'kontrol(2) && validate().check()';
	WOStruct['#attributes.fuseaction#']['add']['buttons']['extra'] = 1;
	WOStruct['#attributes.fuseaction#']['add']['buttons']['extraText'] = '#lang_array.item[120]#';
	WOStruct['#attributes.fuseaction#']['add']['buttons']['extraAlert'] = '#lang_array_main.item[123]#';
	WOStruct['#attributes.fuseaction#']['add']['buttons']['extraFunction'] = 'kontrol(1) && validate().check()';
	 	
	WOStruct['#attributes.fuseaction#']['upd'] = structNew();
	WOStruct['#attributes.fuseaction#']['upd']['window'] = 'normal';
	WOStruct['#attributes.fuseaction#']['upd']['fuseaction'] = 'call.upd_helpdesk';
	WOStruct['#attributes.fuseaction#']['upd']['filePath'] = 'callcenter/form/FormCallLead.cfm';
	WOStruct['#attributes.fuseaction#']['upd']['queryPath'] = '';
	WOStruct['#attributes.fuseaction#']['upd']['nextEvent'] = 'call.helpdesk&event=upd&cus_help_id=';
	WOStruct['#attributes.fuseaction#']['upd']['parameters'] = '##attributes.cus_help_id##';
	WOStruct['#attributes.fuseaction#']['upd']['Identity'] = '##attributes.cus_help_id##';
	WOStruct['#attributes.fuseaction#']['upd']['formName'] = 'add_helpdesk';	
	WOStruct['#attributes.fuseaction#']['upd']['recordQuery'] = 'get_help';
	WOStruct['#attributes.fuseaction#']['upd']['recordQueryRecordEmp'] = 'RECORD_EMP';
	WOStruct['#attributes.fuseaction#']['upd']['recordQueryIsConsumer'] = '1';
	
	WOStruct['#attributes.fuseaction#']['upd']['buttons'] = structNew();
	WOStruct['#attributes.fuseaction#']['upd']['buttons']['update'] = 1;
	WOStruct['#attributes.fuseaction#']['upd']['buttons']['updateFunction'] = 'kontrol() && validate().check()';
	WOStruct['#attributes.fuseaction#']['upd']['buttons']['delete'] = 1;
	WOStruct['#attributes.fuseaction#']['add']['buttons']['extra'] = 1;
	WOStruct['#attributes.fuseaction#']['add']['buttons']['extraText'] = '#lang_array.item[120]#';
	WOStruct['#attributes.fuseaction#']['add']['buttons']['extraAlert'] = '#lang_array_main.item[123]#';
	WOStruct['#attributes.fuseaction#']['add']['buttons']['extraFunction'] = 'kontrol(1) && validate().check()';
	
	if(listfindNoCase('del,upd,det',attributes.event,','))
	{
		WOStruct['#attributes.fuseaction#']['del'] = structNew();
		WOStruct['#attributes.fuseaction#']['del']['window'] = 'emptypopup';
		WOStruct['#attributes.fuseaction#']['del']['fuseaction'] = 'call.emptypopup_del_helpdesk&cus_help_id=#attributes.cus_help_id#';
		WOStruct['#attributes.fuseaction#']['del']['filePath'] = '';
		WOStruct['#attributes.fuseaction#']['del']['queryPath'] = '';
		WOStruct['#attributes.fuseaction#']['del']['nextEvent'] = 'call.helpdesk';	
	}
	
	WOStruct['#attributes.fuseaction#']['det']['pageParams'] = structNew();
	WOStruct['#attributes.fuseaction#']['det']['pageParams']['size'] = '8-4';
	WOStruct['#attributes.fuseaction#']['det']['queryPath'] = '';
	WOStruct['#attributes.fuseaction#']['det']['nextEvent'] = 'call.helpdesk&event=det&cus_help_id=';
	WOStruct['#attributes.fuseaction#']['det']['Identity'] = '##get_help.cus_help_id##';
	
	if(not isdefined('attributes.formSubmittedController'))
	{
		WOStruct['#attributes.fuseaction#']['det']['window'] = 'normal';
		WOStruct['#attributes.fuseaction#']['det']['fuseaction'] = 'member.consumer_list';
		WOStruct['#attributes.fuseaction#']['det']['filePath'] = 'member/display/list_consumer.cfm';
		WOStruct['#attributes.fuseaction#']['det']['pageObjects'] = structNew();
		
		if(not (attributes.event is 'add' or attributes.event is 'list'))
		{
			WOStruct['#attributes.fuseaction#']['det']['pageObjects'][0][0]['type'] = 0; // Include
			WOStruct['#attributes.fuseaction#']['det']['pageObjects'][0][0]['referenceController']  = 'CallLeadController.cfm';
			WOStruct['#attributes.fuseaction#']['det']['pageObjects'][0][0]['referenceEvent']  = 'upd';	
			
			WOStruct['#attributes.fuseaction#']['det']['pageObjects'][1][0]['type'] = 2;
			WOStruct['#attributes.fuseaction#']['det']['pageObjects'][1][0]['file'] = '#request.self#?fuseaction=call.similar_request&cus_help_id=#cus_help_id#';
			WOStruct['#attributes.fuseaction#']['det']['pageObjects'][1][0]['id'] = 'similar_call';
			WOStruct['#attributes.fuseaction#']['det']['pageObjects'][1][0]['title'] = '#lang_array.item[123]#';
			
			WOStruct['#attributes.fuseaction#']['det']['pageObjects'][1][1]['type'] = 2;
			WOStruct['#attributes.fuseaction#']['det']['pageObjects'][1][1]['file'] = '#request.self#?fuseaction=call.list_detail_related_actions&cus_help_id=#cus_help_id#';
			WOStruct['#attributes.fuseaction#']['det']['pageObjects'][1][1]['id'] = 'Related_Actions';
			WOStruct['#attributes.fuseaction#']['det']['pageObjects'][1][1]['title'] = '#lang_array.item[45]#';		
			
			WOStruct['#attributes.fuseaction#']['det']['pageObjects'][1][2]['type'] = 1;//Custom Tag
			WOStruct['#attributes.fuseaction#']['det']['pageObjects'][1][2]['file'] = '<cf_get_workcube_asset asset_cat_id="-2" module_id="27" action_section="CUS_HELP_ID" action_id="##attributes.cus_help_id##" style="1">';		
		}
	
		tabMenuStruct = StructNew();
		tabMenuStruct['#attributes.fuseaction#'] = structNew();
		tabMenuStruct['#attributes.fuseaction#']['tabMenus'] = structNew();
		
		if(not (listFindNoCase('add,list,del',attributes.event,',')))
		{
			
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['det'] = structNew();
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['det']['menus'] = structNew();		
			i = 0;
			if((len(get_help.company_id) and len(get_help.partner_id)) or (len(get_help.consumer_id)))
			{
				tabMenuStruct['#attributes.fuseaction#']['tabMenus']['det']['menus'][i]['text'] = '#lang_array.item[25]#';
				if (len(get_help.company_id) and len(get_help.partner_id))
					{	
						tabMenuStruct['#attributes.fuseaction#']['tabMenus']['det']['menus'][i]['onClick'] = "windowopen('#request.self#?fuseaction=call.popup_add_timecost&cus_help_id=#attributes.cus_help_id#&comp_id=#get_help.company_id#&partner_id=#get_help.partner_id#&subscription_id=#get_help.subscription_id#&is_cus_help=1','page_horizantal');";
						i = i + 1;
					}
				else if (len(get_help.consumer_id))
					{
						tabMenuStruct['#attributes.fuseaction#']['tabMenus']['det']['menus'][i]['onClick'] = "windowopen('#request.self#?fuseaction=call.popup_add_timecost&cus_help_id=#attributes.cus_help_id#&cons_id=#get_help.consumer_id#&subscription_id=#get_help.subscription_id#&is_cus_help=1','medium');";
						i = i + 1;
					}
			}
			
			if(len(get_help.company_id) or len(get_help.consumer_id))
				{	
					tabMenuStruct['#attributes.fuseaction#']['tabMenus']['det']['menus'][i]['text'] = '#lang_array_main.item[163]#';
					if (len(get_help.company_id))
						{
							tabMenuStruct['#attributes.fuseaction#']['tabMenus']['det']['menus'][i]['href'] = "#request.self#?fuseaction=myhome.my_company_details&cpid=#get_help.company_id#";
							i = i + 1;
						}
					else if (len(get_help.consumer_id))
						{
							tabMenuStruct['#attributes.fuseaction#']['tabMenus']['det']['menus'][i]['href'] = "#request.self#?fuseaction=myhome.my_consumer_details&cid=#get_help.consumer_id#";
							i = i + 1;
						}
				}
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['det']['menus'][i]['text'] = '#lang_array_main.item[521]#';
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['det']['menus'][i]['onClick'] = "windowopen('#request.self#?fuseaction=project.popup_add_work&cus_help_id=#attributes.cus_help_id#&work_fuse=#attributes.fuseaction#','wwide1');";
			i = i + 1;
			
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['det']['menus'][i]['text'] = '#lang_array.item[96]#';
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['det']['menus'][i]['href'] = "#request.self#?fuseaction=service.list_service&event=add&cus_help_id=#attributes.cus_help_id#";
			i = i + 1;
			
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['det']['menus'][i]['text'] = '#lang_array.item[46]#';
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['det']['menus'][i]['href'] = "#request.self#?fuseaction=call.list_service&event=add&cus_help_id=#attributes.cus_help_id#";
			i = i + 1;
			
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['det']['menus'][i]['text'] = '#lang_array_main.item[1077]#';
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['det']['menus'][i]['href'] = "#request.self#?fuseaction=sales.list_opportunity&event=add&cus_help_id=#attributes.cus_help_id#";
			
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons'] = structNew();
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['add']['text'] = '#lang_array_main.item[170]#';
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['add']['href'] = "#request.self#?fuseaction=call.helpdesk&event=add";
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['add']['target'] = "_blank";
			tabMenuData = SerializeJSON(tabMenuStruct['#attributes.fuseaction#']['tabMenus']);
		}
	}
</cfscript>

<cfif isdefined('attributes.formSubmittedController') and attributes.formSubmittedController eq 1>
	<cfif isdefined("attributes.detail") and not len(attributes.detail) and isdefined("attributes.event") and not attributes.event contains 'del'>
        <script type="text/javascript">
            alertObject({message: "<cf_get_lang_main no='782.girilmesi zorunlu alan'>:<cf_get_lang_main no='217.Açıklama'> !"});
        </script>
        <cfabort>
    </cfif>

	<cfif isdefined('attributes.event') and attributes.event is 'add'>
        <!--- add --->
        <cf_date tarih="attributes.action_date">
        
        <cfscript>
            add = CallLeadModel.add (
                isEmail			: attributes.email,
                camp_id			: iif(isdefined('attributes.camp_id') and len(attributes.camp_id), attributes.camp_id,0),
                partner_id		: iif(len(attributes.partner_id), attributes.partner_id,0),
                company_id		: iif(len(attributes.company_id), attributes.company_id,0),
                consumer_id		: iif(len(attributes.consumer_id), attributes.consumer_id,0),
                workcube_id		: attributes.workcube_id,
                product_id		: iif(len(attributes.product_name) and len(attributes.product_id), attributes.product_id,0),
                company			: attributes.company,
				app_cat			: attributes.app_cat,
                interaction_cat	: iif(len(attributes.interaction_cat), attributes.interaction_cat,0),
                action_date		: attributes.action_date,
                subject			: attributes.subject,
                process_stage	: attributes.process_stage,
                detail			: attributes.detail,
                applicant_name	: attributes.applicant_name,
				applicant_mail 	: attributes.applicant_mail,
                subscription_id : iif(len(attributes.subscription_id), attributes.subscription_id,0),
				tel_code 		: attributes.tel_code,
				tel_no 			: attributes.tel_no,
				special_definition : iif(len(attributes.special_definition), attributes.special_definition,0)
            );
            attributes.actionId = add;
			
			
			if(attributes.email eq 1 and isdefined("attributes.applicant_mail") and len(attributes.applicant_mail))
			{
				if(isdefined('attributes.template_id') and len(attributes.template_id))
					get_template = getModuleTemplate.get(templateId:attributes.template_id);
				
				getEmployeeInfo = getEmployeeInfo.get();
				
				from_mail='#session.ep.company#<#session.ep.company_email#>';
				if(isdefined("attributes.is_reply_email") and (attributes.is_reply_email eq 1))
					replyto_mail = "#getEmployeeInfo.employee_name# #getEmployeeInfo.employee_surname#<#getEmployeeInfo.employee_email#>;#from_mail#";
				else
					replyto_mail = "#from_mail#";
				
				mailSubject = '#attributes.actionId# - #attributes.detail#';
				
				emailSend = CallLeadModel.emailSend (
					from_mail		: from_mail,
					to_mail			: attributes.applicant_mail,
					fail_to			: get_employee_email.employee_email,
					reply_to		: replyto_mail,
					subject			: attribtes.subject,
					mailSubject		: mailSubject,
					isLogo			: iif(isdefined("get_template") and get_template.recordcount, get_template.is_logo,0),
					applicant_name	: attributes.applicant_name
				);
			}
		</cfscript>
    <cfelseif isdefined('attributes.event') and listFind('upd,det',attributes.event)>
        <!--- upd --->
       <cf_date tarih="attributes.action_date">
        
        <cfscript>
            upd = CallLeadModel.upd (
                help_id			: attributes.help_id,
				isEmail			: attributes.email,
                camp_id			: iif(isdefined('attributes.camp_id') and len(attributes.camp_id), attributes.camp_id,0),
                partner_id		: iif(len(attributes.partner_id), attributes.partner_id,0),
                company_id		: iif(len(attributes.company_id), attributes.company_id,0),
                consumer_id		: iif(len(attributes.consumer_id), attributes.consumer_id,0),
                product_id		: iif(len(attributes.product_name) and len(attributes.product_id), attributes.product_id,0),
				app_cat			: attributes.app_cat,
                interaction_cat	: iif(len(attributes.interaction_cat), attributes.interaction_cat,0),
                action_date		: attributes.action_date,
                subject			: attributes.subject,
                process_stage	: attributes.process_stage,
                detail			: attributes.detail,
                applicant_name	: attributes.applicant_name,
				applicant_mail 	: attributes.applicant_mail,
                subscription_id : iif(len(attributes.subscription_id), attributes.subscription_id,0),
				tel_code 		: attributes.tel_code,
				tel_no 			: attributes.tel_no,
				special_definition : iif(len(attributes.special_definition), attributes.special_definition,0),
				content			: attributes.content
            );
            attributes.actionId = upd;
			
			//helpDesk kaydı atılıyor
			if(isdefined('attributes.is_help_desk'))
			{
				CallLeadModel.addHelpDesk (
					modul_name	: attributes.modul_name,
					faction		: attributes.faction,
					help_head	: attributes.help_head,
					content		: attributes.content,
					is_internet	: iif(isdefined("attributes.is_internet"), 1,0),
					is_faq		: iif(isdefined("attributes.is_faq"), 1,0)
				);		
			}
        
        	//email gönderiliyor
			if(attributes.email eq 1 and isdefined("attributes.applicant_mail") and len(attributes.applicant_mail))
			{
                if(isdefined('attributes.template_id') and len(attributes.template_id))
					get_template = getModuleTemplate.get(templateId:attributes.template_id);
				
				getEmployeeInfo = getEmployeeInfo.get();
				
				from_mail='#session.ep.company#<#session.ep.company_email#>';
				if(isdefined("attributes.is_reply_email") and (attributes.is_reply_email eq 1))
					replyto_mail = "#getEmployeeInfo.employee_name# #getEmployeeInfo.employee_surname#<#getEmployeeInfo.employee_email#>;#from_mail#";
				else
					replyto_mail = "#from_mail#";
				
				mailSubject = '#attributes.actionId# - #attributes.detail#';
                
                emailSend = CallLeadModel.emailSend (
                    from_mail		: from_mail,
                    to_mail			: attributes.applicant_mail,
                    fail_to			: get_employee_email.employee_email,
                    reply_to		: replyto_mail,
                    subject			: attribtes.subject,
                    mailSubject		: mailSubject,
                    isLogo			: iif(isdefined("get_template") and get_template.recordcount, get_template.is_logo,0),
                    applicant_name	: attributes.applicant_name
                );
			}
       </cfscript>
    <cfelseif isdefined('attributes.event') and attributes.event is 'del'>
        <!--- del --->
        <cfscript>
			del = CallLeadModel.del (
				help_id	: attributes.cus_help_id
				);
				
			attributes.actionId = del;
		</cfscript>
    </cfif>
</cfif>