<!-----------------------------------------------------------------------
*************************************************************************
		Copyright Workcube E-Business Inc. www.workcube.com
*************************************************************************
Analys		: Fatih Ayık			Developer	: Merve Temel		
Analys Date : 01/04/2016			Dev Date	: 10/05/2016		
Description :
	Bu controller kampanya objesine ait kontrolleri yapar modelleri çağırarak ilgili setleri çalıştırır.
----------------------------------------------------------------------->

<!------------------------------------------------------
	Event lere göre kontroller yapılıyor
-------------------------------------------------------->

<cfif not isdefined('attributes.formSubmittedController')>
    <cf_get_lang_set module_name="campaign">    
    <!--- utility --->
    <cfset get_camp_types = getCampaignType.get()>
    <cfif (isdefined("attributes.event") and attributes.event is 'list') or not isdefined("attributes.event")>
        <cfparam name="attributes.start_dates" default="">
        <cfparam name="attributes.finish_dates" default="">
        <cfparam name="attributes.is_active" default=1>
        <cfparam name="attributes.is_filter" default="0">
        <cfparam name="attributes.keyword" default="">
        <cfparam name="attributes.emp_id" default="">
        <cfparam name="attributes.member_name" default="">
        <cfparam name="attributes.camp_type" default=''>
		<cfif isdefined("attributes.start_dates") and isdate(attributes.start_dates)>
            <cf_date tarih = "attributes.start_dates">
            <cfelse>
                <cfif session.ep.our_company_info.unconditional_list>
                <cfset attributes.start_dates=''>
            <cfelse>
                <cfset attributes.start_dates= date_add('d',-7,wrk_get_today())>
            </cfif>
        </cfif>
        <cfif isdefined("attributes.finish_dates") and isdate(attributes.finish_dates)>
            <cf_date tarih = "attributes.finish_dates">
        <cfelse>
            <cfif session.ep.our_company_info.unconditional_list>
                <cfset attributes.finish_dates=''>
            <cfelse>
                <cfset attributes.finish_dates= date_add('d',7,wrk_get_today())>
            </cfif>
        </cfif>
        
        <cfset get_campaign_cats = getCampaignCat.get(camp_type:get_camp_types.camp_type_id)>
        <cfif attributes.is_filter>
            <cfscript>
				campaigns = campaignModel.list(
						keyword		: attributes.keyword,
						camp_type	: attributes.camp_type,
						is_active	: attributes.is_active,
						emp_id		: iif(len(attributes.emp_id) and len(attributes.member_name),attributes.emp_id,0),
						startdate	: attributes.start_dates,
						finishdate	: attributes.finish_dates
					);
			</cfscript>
        <cfelse>
            <cfset campaigns.recordcount = 0>
        </cfif>
        
        <cfset url_str = "">
        <cfif len(attributes.keyword)><cfset url_str = "#url_str#&keyword=#attributes.keyword#"></cfif>
        <cfif isdefined("attributes.emp_id")><cfset url_str = "#url_str#&attributes.emp_id=#attributes.emp_id#"></cfif>
        <cfif isdefined("attributes.member_name")><cfset url_str = "#url_str#&attributes.member_name=#attributes.member_name#"></cfif>
        <cfif isdefined("camp_type")><cfset url_str = "#url_str#&camp_type=#attributes.camp_type#"></cfif>
        <cfif isdefined("is_active")><cfset url_str = "#url_str#&is_active=#attributes.is_active#"></cfif>
        <cfif len(attributes.start_dates)><cfset url_str="#url_str#&start_dates=#dateformat(attributes.start_dates,'dd/mm/yyyy')#"></cfif>
        <cfif len(attributes.finish_dates)><cfset url_str="#url_str#&finish_dates=#dateformat(attributes.finish_dates,'dd/mm/yyyy')#"></cfif>
        <cfset url_str = "#url_str#&is_filter=#attributes.is_filter#">
        <cfparam name="attributes.page" default=1>
        <cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
        <cfparam name="attributes.totalrecords" default="#campaigns.recordcount#">
        <cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>

    <cfelseif isdefined("attributes.event") and listfindnocase('add,upd,det',attributes.event)>  
		<cfscript>
            get_company_cat = getCompanyCat.get(); // utility
            get_consumer_cat = getConsumerCat.get(status:1);// utility

            if(listfindnocase('upd,det',attributes.event))
            {
                campaign = campaignModel.get(camp_id:attributes.camp_id);
                get_campaign_cats = getCampaignCat.get(camp_type:campaign.camp_type);// utility
				attributes.project_id = campaign.project_id;
                paper_num = campaign.camp_no;
            }
        </cfscript>
    </cfif>
    
    <script type="text/javascript">
        <cfif (isdefined("attributes.event") and attributes.event is 'list') or not isdefined("attributes.event")>
            $( document ).ready(function() {
                document.getElementById('keyword').focus();	
            });			
            function kontrol()
            {	
                if(document.getElementById("start_dates") != "" && document.getElementById("finish_dates") != "")
                {
                    if(!date_check(document.getElementById("start_dates"),document.getElementById("finish_dates"),"<cf_get_lang_main no='394.Tarih Araligini Kontrol Ediniz'>!"))
                    {
                        return false;
                    }
                }
                return true;
            }	
        <cfelseif isdefined("attributes.event") and (attributes.event is 'add' or attributes.event is 'upd')>	
            function redirect(x)
            {
                var temp = document.campaign.camp_cat_id;
                var groups=document.campaign.camp_type.options.length;
                var group=new Array(groups);
                for (i=0; i<groups; i++)
                    group[i]=new Array();
                    group[0][0]=new Option("Kategori","");
                    <cfset branch = ArrayNew(1)>
                    <cfoutput query="get_camp_types">
                        <cfset branch[currentrow]=#camp_type_id#>
                    </cfoutput>
                    <cfloop from="1" to="#ArrayLen(branch)#" index="indexer">
                        <cfquery name="dep_names" datasource="#dsn3#">
                            SELECT 
                                CAMP_CAT_ID,
                                CAMP_CAT_NAME,
                                CAMP_TYPE
                            FROM 
                                CAMPAIGN_CATS 
                            WHERE 
                                CAMP_TYPE = #branch[indexer]# ORDER BY CAMP_CAT_ID
                        </cfquery>
                        <cfif dep_names.recordcount>
                            <cfset deg = 0>
                            <cfoutput>group[#indexer#][#deg#]=new Option("Kategori","");</cfoutput>
                                <cfoutput query="dep_names">
                                    <cfset deg = currentrow>
                                        <cfif dep_names.recordcount>
                                            group[#indexer#][#deg#]=new Option("#camp_cat_name#","#camp_cat_id#");
                                        </cfif>
                                </cfoutput>
                        <cfelse>
                            <cfset deg = 0>
                            <cfoutput>
                            group[#indexer#][#deg#]=new Option("<cf_get_lang_main no='74.Kategori'>","");
                            </cfoutput>
                        </cfif>
                    </cfloop>
                for (m=temp.options.length-1;m>0;m--)
                temp.options[m]=null;
                for (i=0;i<group[x].length;i++)
                {
                    temp.options[i]=new Option(group[x][i].text,group[x][i].value)
                }
            }
            function kontrol()
            {	
				var formName = 'campaign',  // scripttin en başına bir defa yazılacak
				form  = $('form[name="'+ formName +'"]'); // form'u seçer 
				
				if (form.find('input#camp_startdate').val() != '' && form.find('input#camp_finishdate').val() != ''){  // çift # i coldfusion dan dolayı yazıyoruz bazı durumlarda gerekmiyor. İlgili objeyi seçtiğinizden emin olun
					if (form.find('input#camp_startdate').val() > form.find('input#camp_finishdate').val()){
						validateMessage('notValid',form.find('input#camp_startdate'),1);  // ilgili objenin uyarısını ve ya hata mesajını bastırmaız için ' notValid ' handler' ını fonksiyona gönderin
						return false;
					}else
						validateMessage('valid',form.find('input#camp_startdate') );  // aynı şekilde obje ile iligili tüm kontroller bittiğinde success için 'valid' hadler' ını fonksiyona gönderin.
				}
                return process_cat_control();
                return true;
            }
        </cfif>
    </script>
</cfif> 

<cfscript>
	// Switch //
	WOStruct = StructNew();
	
	WOStruct['#attributes.fuseaction#'] = structNew();
	
	WOStruct['#attributes.fuseaction#']['default'] = 'list';
	
	WOStruct['#attributes.fuseaction#']['systemObject'] = structNew();
	WOStruct['#attributes.fuseaction#']['systemObject']['modelName'] = 'campaign';
	
	WOStruct['#attributes.fuseaction#']['systemObject']['processStage'] = true;
	if(not isdefined('attributes.formSubmittedController') and isdefined('attributes.event') and attributes.event is 'upd')
		WOStruct['#attributes.fuseaction#']['systemObject']['processStageSelected'] = campaign.process_stage;
	
	WOStruct['#attributes.fuseaction#']['systemObject']['paperNumber'] = true;
	WOStruct['#attributes.fuseaction#']['systemObject']['paperType'] = 'CAMPAIGN';
	
	WOStruct['#attributes.fuseaction#']['systemObject']['isTransaction'] = true;
	WOStruct['#attributes.fuseaction#']['systemObject']['dataSourceName'] = DSN3; // Transaction icin yapildi.

	WOStruct['#attributes.fuseaction#']['systemObject']['extendedForm'] = true;
	WOStruct['#attributes.fuseaction#']['systemObject']['pageExtendedEventList'] = 'add,upd';
	WOStruct['#attributes.fuseaction#']['systemObject']['pageTableName'] = 'CAMPAIGNS';
	WOStruct['#attributes.fuseaction#']['systemObject']['pageIdentityColumn'] = 'CAMPAIGN_ID';
	WOStruct['#attributes.fuseaction#']['systemObject']['pageSettings'] = "['item-camp_type','item-camp_startdate','item-camp_finishdate','item-camp_head']";
		
	WOStruct['#attributes.fuseaction#']['list'] = structNew();
	WOStruct['#attributes.fuseaction#']['list']['window'] = 'normal';
	WOStruct['#attributes.fuseaction#']['list']['fuseaction'] = 'campaign.list_campaign';
	WOStruct['#attributes.fuseaction#']['list']['filePath'] = 'campaign/display/list_campaign.cfm';
	
	WOStruct['#attributes.fuseaction#']['add'] = structNew();
	WOStruct['#attributes.fuseaction#']['add']['window'] = 'normal';
	WOStruct['#attributes.fuseaction#']['add']['fuseaction'] = 'campaign.list_campaign';
	WOStruct['#attributes.fuseaction#']['add']['filePath'] = 'campaign/form/form_add_campaign.cfm';
	WOStruct['#attributes.fuseaction#']['add']['queryPath'] = '';
	WOStruct['#attributes.fuseaction#']['add']['nextEvent'] = 'campaign.list_campaign&event=det&camp_id=';
	WOStruct['#attributes.fuseaction#']['add']['formName'] = 'campaign';
	
	WOStruct['#attributes.fuseaction#']['add']['buttons'] = structNew();
	WOStruct['#attributes.fuseaction#']['add']['buttons']['save'] = 1;
	WOStruct['#attributes.fuseaction#']['add']['buttons']['saveFunction'] = 'kontrol() && validate().check()';
	
	WOStruct['#attributes.fuseaction#']['upd'] = structNew();
	WOStruct['#attributes.fuseaction#']['upd']['window'] = 'normal';
	WOStruct['#attributes.fuseaction#']['upd']['fuseaction'] = 'campaign.form_upd_campaign';
	WOStruct['#attributes.fuseaction#']['upd']['filePath'] = 'campaign/form/form_upd_campaign.cfm';
	WOStruct['#attributes.fuseaction#']['upd']['queryPath'] = '';
	WOStruct['#attributes.fuseaction#']['upd']['nextEvent'] = 'campaign.list_campaign&event=det&camp_id=';
	WOStruct['#attributes.fuseaction#']['upd']['parameters'] = 'camp_id=##attributes.camp_id##';
	WOStruct['#attributes.fuseaction#']['upd']['Identity'] = '##attributes.camp_id##';
	WOStruct['#attributes.fuseaction#']['upd']['recordQuery'] = 'CAMPAIGN';
	WOStruct['#attributes.fuseaction#']['upd']['formName'] = 'campaign';
	
	WOStruct['#attributes.fuseaction#']['upd']['buttons'] = structNew();
	WOStruct['#attributes.fuseaction#']['upd']['buttons']['update'] = 1;
	WOStruct['#attributes.fuseaction#']['upd']['buttons']['updateFunction'] = 'kontrol() && validate().check()';
	WOStruct['#attributes.fuseaction#']['upd']['buttons']['delete'] = 1;
	
	WOStruct['#attributes.fuseaction#']['det']['pageParams'] = structNew();
	WOStruct['#attributes.fuseaction#']['det']['pageParams']['size'] = '9-3';
	WOStruct['#attributes.fuseaction#']['det']['queryPath'] = '';
	WOStruct['#attributes.fuseaction#']['det']['nextEvent'] = 'campaign.list_campaign&event=det&camp_id=';
	WOStruct['#attributes.fuseaction#']['det']['Identity'] = '##attributes.camp_id##';
	WOStruct['#attributes.fuseaction#']['det']['pageObjects'] = structNew();
	
	if(isdefined("attributes.event") and listFind('upd,del',attributes.event))
	{
		WOStruct['#attributes.fuseaction#']['del'] = structNew();
		WOStruct['#attributes.fuseaction#']['del']['window'] = 'emptypopup';
		WOStruct['#attributes.fuseaction#']['del']['fuseaction'] = '#request.self#?fuseaction=campaign.emptypopup_del_campaign&camp_id=#attributes.camp_id#';
		WOStruct['#attributes.fuseaction#']['del']['filePath'] = '';
		WOStruct['#attributes.fuseaction#']['del']['queryPath'] = '';
		WOStruct['#attributes.fuseaction#']['del']['nextEvent'] = 'campaign.list_campaign';//
	}
	
	if(not isdefined('attributes.formSubmittedController'))
	{
		// type'lar include,box,custom tag şekline dönüşecek.
		WOStruct['#attributes.fuseaction#']['det']['window'] = 'normal';
		WOStruct['#attributes.fuseaction#']['det']['fuseaction'] = 'campaign.list_campaign&event=det&camp_id=';
		WOStruct['#attributes.fuseaction#']['det']['filePath'] = 'campaign/display/list_campaign.cfm';
		
		if(isdefined("attributes.event") and not (attributes.event is 'add' or attributes.event is 'list'))
		{
			//alt kısım
			WOStruct['#attributes.fuseaction#']['det']['pageObjects'][0][0]['type'] = 0; // Include
			WOStruct['#attributes.fuseaction#']['det']['pageObjects'][0][0]['referenceController']  = 'CampaignController.cfm';
			WOStruct['#attributes.fuseaction#']['det']['pageObjects'][0][0]['referenceEvent']  = 'upd';
			
			WOStruct['#attributes.fuseaction#']['det']['pageObjects'][0][1]['type'] = 2;
			WOStruct['#attributes.fuseaction#']['det']['pageObjects'][0][1]['file'] = '#request.self#?fuseaction=campaign.emptypopup_dsp_campaign_contents&camp_id=#attributes.camp_id#';
			WOStruct['#attributes.fuseaction#']['det']['pageObjects'][0][1]['addFile'] = '#request.self#?fuseaction=objects.popup_list_content_relation&action_type_id=#attributes.camp_id#&action_type=CAMPAIGN_ID';
			WOStruct['#attributes.fuseaction#']['det']['pageObjects'][0][1]['id'] = 'get_camp_content';
			WOStruct['#attributes.fuseaction#']['det']['pageObjects'][0][1]['title'] = '#lang_array.item[166]#';
			
			WOStruct['#attributes.fuseaction#']['det']['pageObjects'][0][2]['type'] = 2;
			WOStruct['#attributes.fuseaction#']['det']['pageObjects'][0][2]['file'] = '#request.self#?fuseaction=campaign.emptypopup_dsp_campaign_proms&camp_id=#attributes.camp_id#';
			WOStruct['#attributes.fuseaction#']['det']['pageObjects'][0][2]['addFile'] = '#request.self#?fuseaction=product.list_promotions&event=addcollectedprom&&camp_id=#attributes.camp_id#';
			WOStruct['#attributes.fuseaction#']['det']['pageObjects'][0][2]['id'] = 'get_camp_proms';
			WOStruct['#attributes.fuseaction#']['det']['pageObjects'][0][2]['title'] = '#lang_array_main.item[171]#';//promosyonlar
	
			WOStruct['#attributes.fuseaction#']['det']['pageObjects'][0][3]['type'] = 2;
			WOStruct['#attributes.fuseaction#']['det']['pageObjects'][0][3]['file'] = '#request.self#?fuseaction=campaign.emptypopup_dsp_campaign_catalogs&camp_id=#attributes.camp_id#';
			WOStruct['#attributes.fuseaction#']['det']['pageObjects'][0][3]['addFile'] = '#request.self#?fuseaction=product.list_catalog_promotion&event=add&camp_id=#attributes.camp_id#';
			WOStruct['#attributes.fuseaction#']['det']['pageObjects'][0][3]['id'] = 'get_camp_catalogs';
			WOStruct['#attributes.fuseaction#']['det']['pageObjects'][0][3]['title'] = '#lang_array_main.item[1576]#';//aksiyonlar

			WOStruct['#attributes.fuseaction#']['det']['pageObjects'][0][4]['type'] = 2;
			WOStruct['#attributes.fuseaction#']['det']['pageObjects'][0][4]['file'] = '#request.self#?fuseaction=objects.emptypopup_get_organization_detail&camp_id=#attributes.camp_id#';
			WOStruct['#attributes.fuseaction#']['det']['pageObjects'][0][4]['id'] = 'get_camp_operation_rows';
			WOStruct['#attributes.fuseaction#']['det']['pageObjects'][0][4]['title'] = '#lang_array.item[383]#';//Abonelik Operasyon Satırları
			
			WOStruct['#attributes.fuseaction#']['det']['pageObjects'][0][5]['type'] = 2;
			WOStruct['#attributes.fuseaction#']['det']['pageObjects'][0][5]['file'] = '#request.self#?fuseaction=objects.emptypopup_get_organization_detail&camp_id=#attributes.camp_id#';
			WOStruct['#attributes.fuseaction#']['det']['pageObjects'][0][5]['addFile'] = '#request.self#?fuseaction=campaign.form_add_organization&camp_id=#attributes.camp_id#';
			WOStruct['#attributes.fuseaction#']['det']['pageObjects'][0][5]['id'] = 'main_organization_id';
			WOStruct['#attributes.fuseaction#']['det']['pageObjects'][0][5]['title'] = '#lang_array_main.item[1669]#';//İlişkili Etkinlikler
			
			//yan kısım
			WOStruct['#attributes.fuseaction#']['det']['pageObjects'][1][0]['type'] = 2;
			WOStruct['#attributes.fuseaction#']['det']['pageObjects'][1][0]['file'] = '#request.self#?fuseaction=campaign.emptypopup_list_target_markets_ajax&camp_id=#camp_id#';
			WOStruct['#attributes.fuseaction#']['det']['pageObjects'][1][0]['addFile'] = '#request.self#?fuseaction=campaign.list_target_markets&event=add&camp_id=#camp_id#';
			WOStruct['#attributes.fuseaction#']['det']['pageObjects'][1][0]['infoFile'] = '#request.self#?fuseaction=campaign.popup_list_target_markets&camp_id=#camp_id#';
			WOStruct['#attributes.fuseaction#']['det']['pageObjects'][1][0]['id'] = 'list_target_markets';
			WOStruct['#attributes.fuseaction#']['det']['pageObjects'][1][0]['title'] = '#lang_array.item[43]#';//Hedef Kitle
			
			WOStruct['#attributes.fuseaction#']['det']['pageObjects'][1][1]['type'] = 1; // Custom Tag
			WOStruct['#attributes.fuseaction#']['det']['pageObjects'][1][1]['file'] = "<cf_get_workcube_content action_type ='CAMPAIGN_ID' company_id='##session.ep.company_id##' action_type_id ='##attributes.camp_id##' design='0'>";//İçerikler
			
			WOStruct['#attributes.fuseaction#']['det']['pageObjects'][1][2]['type'] = 2;
			WOStruct['#attributes.fuseaction#']['det']['pageObjects'][1][2]['file'] = '#request.self#?fuseaction=campaign.popup_form_add_member&campaign_id=#attributes.camp_id#';
			WOStruct['#attributes.fuseaction#']['det']['pageObjects'][1][2]['id'] = 'list_correspondence1_menu';
			WOStruct['#attributes.fuseaction#']['det']['pageObjects'][1][2]['title'] = '#lang_array.item[44]#';//Ekip
			
			WOStruct['#attributes.fuseaction#']['det']['pageObjects'][1][3]['type'] = 2;
			WOStruct['#attributes.fuseaction#']['det']['pageObjects'][1][3]['file'] = '#request.self#?fuseaction=campaign.emptypopup_list_campaigns_surveys_ajax&camp_id=#attributes.camp_id#';
			WOStruct['#attributes.fuseaction#']['det']['pageObjects'][1][3]['addFile'] = '#request.self#?fuseaction=campaign.list_survey&event=add&camp_id=#attributes.camp_id#';
			WOStruct['#attributes.fuseaction#']['det']['pageObjects'][1][3]['infoFile'] = '#request.self#?fuseaction=campaign.list_survey&camp_id=#attributes.camp_id#';
			WOStruct['#attributes.fuseaction#']['det']['pageObjects'][1][3]['id'] = 'list_campaigns_survey';
			WOStruct['#attributes.fuseaction#']['det']['pageObjects'][1][3]['title'] = '#lang_array_main.item[535]#';//Anketler
			
			WOStruct['#attributes.fuseaction#']['det']['pageObjects'][1][4]['type'] = 1; // Custom Tag
			WOStruct['#attributes.fuseaction#']['det']['pageObjects'][1][4]['file'] = "<cf_get_related_events action_section='CAMPAIGN_ID' action_id='##attributes.camp_id##' company_id='##session.ep.company_id##'>";//İlişkili Olaylar
			
			WOStruct['#attributes.fuseaction#']['det']['pageObjects'][1][5]['type'] = 1; // Custom Tag
			WOStruct['#attributes.fuseaction#']['det']['pageObjects'][1][5]['file'] = "<cf_get_workcube_note company_id='##session.ep.company_id##' action_section='CAMPAIGN_ID' action_id='##attributes.camp_id##'>";//Notlar

			WOStruct['#attributes.fuseaction#']['det']['pageObjects'][1][6]['type'] = 1; // Custom Tag
			WOStruct['#attributes.fuseaction#']['det']['pageObjects'][1][6]['file'] = "<cf_get_workcube_asset company_id='##session.ep.company_id##' asset_cat_id='-15' module_id='15' action_section='CAMPAIGN_ID' action_id='##attributes.camp_id##'>";//Varlıklar
		}
		
		// Tab Menus //
		tabMenuStruct = StructNew();
		tabMenuStruct['#attributes.fuseaction#'] = structNew();
		tabMenuStruct['#attributes.fuseaction#']['tabMenus'] = structNew();
			
		// Upd //	
		if(isdefined("attributes.event") and (attributes.event is 'upd' or attributes.event is 'det'))
		{
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd'] = structNew();
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'] = structNew();
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][0]['text'] = '#lang_array.item[258]#';
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][0]['onClick'] = "windowopen('#request.self#?fuseaction=campaign.popup_camp_maillist&camp_id=#campaign.camp_id#','list')";//mail listesi
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][1]['text'] = '#lang_array_main.item[345]#';
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][1]['onClick'] = "windowopen('#request.self#?fuseaction=objects.popup_page_warnings&action=campaign.form_upd_campaign&action_name=camp_id&action_id=#attributes.camp_id#','list')";//uyarılar
			controlParam = 1;
			if (len(attributes.project_id))
			{
				tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][controlParam]['text'] = '#lang_array.item[207]#';
				tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][controlParam]['href'] = "#request.self#?fuseaction=project.prodetail&id=#attributes.project_id#";//proje detayı	
				controlParam = controlParam + 1;
			}
	
			if(isdefined("session.ep.our_company_info.sms") and session.ep.our_company_info.sms eq 1)
			{
				tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][controlParam]['text'] = '#lang_array.item[61]#';
				tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][controlParam]['onClick'] = "windowopen('#request.self#?fuseaction=campaign.popup_form_add_sms_cont&camp_id=#camp_id#','small')";//sms içeriği ekle
				controlParam = controlParam + 1;
			}
	
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][controlParam]['text'] = '#lang_array.item[62]#';
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][controlParam]['href'] = "#request.self#?fuseaction=campaign.list_campaign_target&camp_id=#camp_id#";//liste yöneticisi
			controlParam = controlParam + 1;
			
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][controlParam]['text'] = '#lang_array_main.item[773]#';
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][controlParam]['onClick'] = "windowopen('#request.self#?fuseaction=campaign.popup_view_campaign_comment&camp_id=#camp_id#','medium')";//yorumlar
			controlParam = controlParam + 1;
			
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][controlParam]['text'] = '#lang_array.item[256]#';
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][controlParam]['onClick'] = "windowopen('#request.self#?fuseaction=campaign.popup_list_campaign_paymethods&campaign_id=#attributes.camp_id#','medium')";//ödeme yöntemleri
			controlParam = controlParam + 1;
			
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][controlParam]['text'] = '#lang_array.item[255]#';
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][controlParam]['onClick'] = "windowopen('#request.self#?fuseaction=campaign.popup_add_conscat_segmentation&campaign_id=#attributes.camp_id#','list_horizantal')";
			controlParam = controlParam + 1;
			
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][controlParam]['text'] = '#lang_array.item[254]#';
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][controlParam]['onClick'] = "windowopen('#request.self#?fuseaction=campaign.popup_add_conscat_premium&campaign_id=#attributes.camp_id#','horizantal')";	
			controlParam = controlParam + 1;
			
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['add']['text'] = '#lang_array_main.item[170]#';
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['add']['href'] = "#request.self#?fuseaction=campaign.list_campaign&event=add";
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['add']['target'] = "_blank";
			//tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['extra']['customTag'] = '<cf_np tablename="campaigns" primary_key="camp_id" pointer="camp_id=#camp_id#,event=det" dsn_var="DSN3" ekstraUrlParams="event=det">';
	
			tabMenuData = SerializeJSON(tabMenuStruct['#attributes.fuseaction#']['tabMenus']);
		}
	}
</cfscript>

<!------------------------------------------------------
	modelden CRUD işlemleri yapılıyor...
-------------------------------------------------------->

<cfif isdefined('attributes.formSubmittedController') and attributes.formSubmittedController eq 1>
    <cfif isdefined('attributes.event') and attributes.event is 'add'>
        <!--- add modeli ve kontrolleri calisacak --->
        <cf_date tarih="attributes.camp_startdate">
        <cf_date tarih="attributes.camp_finishdate">
        
        <cfscript>
            attributes.camp_startdate = date_add('h',attributes.camp_start_hour-session.ep.time_zone,attributes.camp_startdate);
            attributes.camp_startdate = date_add('n',attributes.camp_start_min,attributes.camp_startdate);
            attributes.camp_finishdate = date_add('h',attributes.camp_finish_hour-session.ep.time_zone,attributes.camp_finishdate);
            attributes.camp_finishdate = date_add('n',attributes.camp_finish_min,attributes.camp_finishdate);
            
            add = campaignModel.add (
                camp_status		: iif(isdefined('attributes.camp_status') and len(attributes.camp_status), 1,0),
                camp_cat_id		: attributes.camp_cat_id,
                is_extranet		: iif(isdefined('attributes.is_extranet') and len(attributes.is_extranet), 1,0),
                is_internet		: iif(isdefined('attributes.is_internet') and len(attributes.is_internet), 1,0),
                comp_cat		: iif(isdefined("attributes.comp_cat"),"attributes.comp_cat",DE("")),
                cons_cat		: iif(isdefined("attributes.cons_cat"),"attributes.cons_cat",DE("")),
                process_stage	: attributes.process_stage,
                paper_number	: paper_number,
				paper_no		: attributes.paper_no,
                camp_startdate	: attributes.camp_startdate,
                camp_finishdate	: attributes.camp_finishdate,
                camp_head		: attributes.camp_head,
                camp_objective	: attributes.camp_objective,
                project_id		: iif(len(attributes.project_head) and len(attributes.project_id), attributes.project_id,0),
                camp_type		: attributes.camp_type,
				leader_employee_id : iif(len(attributes.leader_employee) and len(attributes.leader_employee_id), attributes.leader_employee_id,0),
                participation_time : iif(isdefined('participation_time') and len(participation_time), attributes.participation_time,de(""))
            );
            
            attributes.actionId = add;
        </cfscript>
    <cfelseif isdefined('attributes.event') and attributes.event is 'upd'>
        <!--- upd modeli ve kontrolleri calisacak --->
        <cf_date tarih="attributes.camp_startdate">
        <cf_date tarih="attributes.camp_finishdate">
        
        <cfscript>
            attributes.camp_startdate = date_add('h',attributes.camp_start_hour-session.ep.time_zone,attributes.camp_startdate);
            attributes.camp_startdate = date_add('n',attributes.camp_start_min,attributes.camp_startdate);
            attributes.camp_finishdate = date_add('h',attributes.camp_finish_hour-session.ep.time_zone,attributes.camp_finishdate);
            attributes.camp_finishdate = date_add('n',attributes.camp_finish_min,attributes.camp_finishdate);
            
            upd = campaignModel.upd (
				camp_id			: attributes.camp_id,
                camp_status		: iif(isdefined('attributes.camp_status') and len(attributes.camp_status), 1,0),
                camp_cat_id		: attributes.camp_cat_id,
                is_extranet		: iif(isdefined('attributes.is_extranet') and len(attributes.is_extranet), 1,0),
                is_internet		: iif(isdefined('attributes.is_internet') and len(attributes.is_internet), 1,0),
                comp_cat		: iif(isdefined("attributes.comp_cat"),"attributes.comp_cat",DE("")),
                cons_cat		: iif(isdefined("attributes.cons_cat"),"attributes.cons_cat",DE("")),
                process_stage	: attributes.process_stage,
                paper_number	: paper_number,
                camp_startdate	: attributes.camp_startdate,
                camp_finishdate	: attributes.camp_finishdate,
                camp_head		: attributes.camp_head,
                camp_objective	: attributes.camp_objective,
                project_id		: iif(len(attributes.project_head) and len(attributes.project_id), attributes.project_id,0),
                camp_type		: attributes.camp_type,
				leader_employee_id : iif(len(attributes.leader_employee) and len(attributes.leader_employee_id), attributes.leader_employee_id,0),
                participation_time : iif(isdefined('participation_time') and len(participation_time), attributes.participation_time,de(""))
            );
            
            attributes.actionId = upd;
        </cfscript>
    <cfelseif isdefined('attributes.event') and attributes.event is 'del'>
        <!--- del modeli ve kontrolleri calisacak --->
        <cfscript>
			del = campaignModel.del (
				camp_id			: attributes.camp_id
				);
				
			attributes.actionId = attributes.camp_id;
		</cfscript>
    </cfif>
</cfif>
