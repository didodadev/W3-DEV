<cf_get_lang_set module_name="campaign">
<cfif (isdefined("attributes.event") and attributes.event is 'list') or not isdefined("attributes.event")>
	<cfif fuseaction eq "campaign.list_survey">
        <cfset xfa.upd =  "campaign.list_survey&event=upd">
        <cfset xfa.lst=  "campaign.list_survey">
        <cfset xfa.list=  "campaign.list_survey">	
    <cfelseif fuseaction eq "campaign.popup_add_email_surveys">
        <cfset xfa.upd =  "campaign.add_email_surveys">
        <cfset xfa.lst =  "campaign.popup_add_email_surveys">
        <cfset xfa.list =  "campaign.popup_add_email_surveys">
    <cfelseif fuseaction eq "campaign.popup_list_target_surveys">
        <cfset xfa.upd =  "campaign.add_target_surveys">
        <cfset xfa.list =  "campaign.popup_list_target_surveys">
    </cfif>
    <cfparam name="attributes.start_dates" default="">
    <cfparam name="attributes.finish_dates" default="">
    <cfparam name="attributes.survey_status" default="">
    <cfparam name="attributes.stage_id" default="">
    <cfparam name="attributes.keyword" default="">
    <cfparam name="attributes.camp_id" default="">
    <cfif isdefined("attributes.start_dates") and isdate(attributes.start_dates)>
        <cf_date tarih = "attributes.start_dates">
    <cfelse>
        <cfif session.ep.our_company_info.unconditional_list>
            <cfset attributes.start_dates=''>
        <cfelse>
            <cfset attributes.start_dates= date_add('m',-1,wrk_get_today())>
        </cfif>
    </cfif>
    <cfif isdefined("attributes.finish_dates") and isdate(attributes.finish_dates)>
        <cf_date tarih = "attributes.finish_dates">
    <cfelse>
        <cfif session.ep.our_company_info.unconditional_list>
            <cfset attributes.finish_dates=''>
        <cfelse>
            <cfset attributes.finish_dates= date_add('d',0,wrk_get_today())>
        </cfif>
    </cfif>
    <cfif isdefined("attributes.is_submit")>
        <cfinclude template="../campaign/query/get_surveys.cfm">
    <cfelse>
        <cfset get_surveys.recordcount = 0>   
    </cfif>
    <cfinclude template="../campaign/query/get_survey_stages.cfm">
    <cfparam name="attributes.page" default=1>
    <cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
    <cfparam name="attributes.totalrecords" default='#get_surveys.recordcount#'>
    <cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
<cfelseif isdefined("attributes.event") and ListFindNoCase('add,upd',attributes.event)>
	<cfinclude template="../campaign/query/get_departments.cfm">
    <cfinclude template="../campaign/query/get_consumers.cfm">
    <cfinclude template="../campaign/query/get_partners.cfm">    
	<cfquery name="GET_OUR_COMPS" datasource="#dsn#">
        SELECT
            COMP_ID,
            COMPANY_NAME
        FROM 
            OUR_COMPANY
        ORDER BY
            COMPANY_NAME
    </cfquery>
    <cfif attributes.event is 'add' and isdefined('attributes.camp_id')>
        	<cfquery name="GET_CAMPAIGN" datasource="#DSN3#">
            	SELECT CAMP_ID FROM CAMPAIGNS WHERE CAMP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.camp_id#">
        	</cfquery>    
    	<!--- Sadece aktif kategorilerin gelmesi için --->
    	<cfset attributes.is_active_consumer_cat = 1>
	<cfelseif attributes.event is 'upd'>
        <cfinclude template="../campaign/query/get_survey.cfm">			
        <cfinclude template="../campaign/query/get_survey_alts.cfm">			
        <cfinclude template="../campaign/query/get_survey_votes_count.cfm">    
        <cfif len(get_survey.product_id)>     	   	 
            <cfquery name="get_pro_name" datasource="#dsn3#">
                SELECT PRODUCT_NAME FROM PRODUCT WHERE PRODUCT_ID = #GET_SURVEY.PRODUCT_ID#
            </cfquery>
            <cfset campaignProductId = get_survey.product_id>
            <cfset campaignProduct = get_pro_name.product_name>
        <cfelse>
            <cfset campaignProductId = 0>
            <cfset campaignProduct = 0>  		
        </cfif>
	</cfif>
<cfelseif attributes.event is 'det'>
    <cfinclude template="../campaign/query/check_user_vote.cfm">
    <cfinclude template="../campaign/query/get_survey_alts.cfm">	
    <cfinclude template="../campaign/query/get_survey_votes_count.cfm">	
    <cfif not isdefined("attributes.chart_type")>
      <cfset attributes.chart_type = "pie">
    </cfif>
    <cfinclude template="../campaign/query/get_survey.cfm">
    <cfinclude template="../campaign/query/get_survey_alts.cfm">	
    
    <cfquery name="GET_EMP_NAMES" datasource="#DSN#">
        SELECT 
            DISTINCT EMPLOYEES.EMPLOYEE_NAME AS AD, 
            EMPLOYEES.EMPLOYEE_SURNAME AS SOYAD, 
            EMPLOYEES.EMPLOYEE_ID AS NO,
            SURVEY_VOTES.VOTES AS OY,
            SURVEY_VOTES.RECORD_DATE AS REC_DATE,
            '1' AS TIP
        FROM 
            EMPLOYEES, 
            SURVEY_VOTES
        WHERE 
            SURVEY_VOTES.SURVEY_ID = #attributes.survey_id# AND
            SURVEY_VOTES.EMP_ID = EMPLOYEES.EMPLOYEE_ID
              
        UNION
        
        SELECT 
            COMPANY_PARTNER.COMPANY_PARTNER_NAME AS ad,
            COMPANY_PARTNER.COMPANY_PARTNER_SURNAME AS soyad, 
            COMPANY_PARTNER.PARTNER_ID AS no,
            SURVEY_VOTES.VOTES  AS oy,
            SURVEY_VOTES.RECORD_DATE AS REC_DATE,
            '2' AS TIP
        FROM 
            COMPANY_PARTNER,
            SURVEY_VOTES 
        WHERE 
            SURVEY_VOTES.SURVEY_ID = #attributes.survey_id# AND
            SURVEY_VOTES.PAR_ID = COMPANY_PARTNER.PARTNER_ID
              
        UNION
        SELECT 
            CONSUMER.CONSUMER_NAME AS AD,
            CONSUMER.CONSUMER_SURNAME AS SOYAD, 
            CONSUMER.CONSUMER_ID AS NO,
            SURVEY_VOTES.VOTES  AS OY,
            SURVEY_VOTES.RECORD_DATE AS REC_DATE,
            '3' AS TIP
        FROM 
            CONSUMER, 
            SURVEY_VOTES
        WHERE 
            SURVEY_VOTES.SURVEY_ID = #attributes.survey_id# AND
            SURVEY_VOTES.CON_ID = CONSUMER.CONSUMER_ID
        UNION
        SELECT 
            RECORD_IP AS AD,
            ' - Misafir' AS SOYAD,
            0 AS NO,	
            VOTES AS OY,
            RECORD_DATE AS REC_DATE,
            '4' AS TIP
        FROM 
            SURVEY_VOTES 
        WHERE 
            GUEST = 1 AND
            SURVEY_ID = #attributes.survey_id# 
    </cfquery>
</cfif>
<script type="text/javascript">
<cfif (isdefined("attributes.event") and attributes.event is 'list') or not isdefined("attributes.event")>
	$( document ).ready(function() {
    	document.getElementById('keyword').focus();
	});	
	
	function windowreload()
	{
		wrk_opener_reload();
	}
	function kontrol()
	{
		if (!date_check (document.getElementById('start_dates'),document.getElementById('finish_dates'),"<cf_get_lang_main no='1450.Başlangıç Tarihi Bitiş Tarihinden Büyük Olamaz'>!") )
			return false;
		else
			return true;	
	}
<cfelseif isdefined("attributes.event") and ListFindNoCase('add,upd',attributes.event)>
	<cfif attributes.event is 'add'>
		$( document ).ready(function() {
		answer0.style.display = '';
		answer1.style.display = '';
	});
		
	<cfelse>
		$( document ).ready(function() {
			<cfif get_survey.answer_number gt 0>
				<cfloop from="0" to="#evaluate(get_survey.answer_number-1)#" index="i">
					<cfoutput>answer#i#.style.display = '';</cfoutput>
				</cfloop>
			</cfif>	
				
		});
	</cfif>
	function kontrol()
		{
		<cfif attributes.event is 'add'> 
			x = document.getElementById('process_stage').selectedIndex;
			if (document.getElementById('process_stage')[x].value == "")
			{ 
				alert ("<cf_get_lang_main no='564.Lütfen Süreçlerinizi Tanımlayınız ve/veya Tanımlanan Süreçler Üzerinde Yetkiniz Yok ! '>");
				return false;
			}
			if (document.getElementById('survey_head').value == "")
			{ 
				alert ("<cf_get_lang_main no='782.girilmesi zorunlu alan'>:<cf_get_lang no='112.Anket Başlığı'>");
				return false;
			}
		</cfif>		
		deger = 0;
			<cfif get_our_comps.recordcount gt 1>	
				for(dgr=0;dgr<<cfoutput>#get_our_comps.recordcount#</cfoutput>;dgr++)
					if(document.survey.survey_our_comp[dgr].disabled==false)
					{	
						if(document.survey.survey_our_comp[dgr].checked == true)
						{
							deger++;
							break;							
						}
					}
				if(deger == 0)
				{
					alert("<cf_get_lang_main no='782.girilmesi zorunlu alan'>:<cf_get_lang no='307.en az'> <cf_get_lang_main no='679.bir'> <cf_get_lang_main no='162.şirket'>!");
					return false;
				}
				else
					return true;
			<cfelseif get_our_comps.recordcount eq 1>
				if(document.survey.survey_our_comp.disabled==false)
				{	
					if(document.survey.survey_our_comp.checked == true)
					{
						deger++;
					}
				}
				if(deger== 0)
				{
					alert("<cf_get_lang_main no='782.girilmesi zorunlu alan'>:<cf_get_lang no='307.en az'> <cf_get_lang_main no='679.bir'> <cf_get_lang_main no='162.şirket'>!");
					return false;
				}
				else
					return true;
			</cfif>
		}
		function goster_survey(number)
			{
			/* sayı seçilenin 1 eksiği geliyor*/
				for (i=0;i<=number+1;i++)
				{
					eleman = eval('answer'+i);
					eleman.style.display = '';
				}
				for (i=number+2;i<=19;i++)
				{
					eleman = eval('answer'+i);
					eleman.style.display = 'none';
				}
			}	
			function hepsi()
			{
				if (document.survey.all.checked)
				{
					document.survey.survey_guest.checked = true;
					for(i=0;i<document.survey.survey_partners.length;i++)
						document.survey.survey_partners[i].checked = true;
			
					for(i=0;i<document.survey.survey_consumers.length;i++)
						document.survey.survey_consumers[i].checked = true;
			
					for(i=0;i<document.survey.survey_departments.length;i++)
						document.survey.survey_departments[i].checked = true;
				}
				else
				{
					document.survey.survey_guest.checked = false;
					for(i=0;i<document.survey.survey_partners.length;i++)
						document.survey.survey_partners[i].checked = false;
			
					for(i=0;i<document.survey.survey_consumers.length;i++)
						document.survey.survey_consumers[i].checked = false;
			
					for(i=0;i<document.survey.survey_departments.length;i++)
						document.survey.survey_departments[i].checked = false;
				}
			}		
</cfif>
</script>



<cfscript>
	// Switch //
	WOStruct = StructNew();
	
	WOStruct['#attributes.fuseaction#'] = structNew();
	
	WOStruct['#attributes.fuseaction#']['default'] = 'list';
	
	if(not isdefined("attributes.event"))
		attributes.event = WOStruct['#attributes.fuseaction#']['default'];
	
	WOStruct['#attributes.fuseaction#']['list'] = structNew();
	WOStruct['#attributes.fuseaction#']['list']['window'] = 'normal';
	WOStruct['#attributes.fuseaction#']['list']['fuseaction'] = 'campaign.list_survey';
	WOStruct['#attributes.fuseaction#']['list']['filePath'] = 'campaign/display/list_survey.cfm';
	
	WOStruct['#attributes.fuseaction#']['add'] = structNew();
	WOStruct['#attributes.fuseaction#']['add']['window'] = 'normal';
	WOStruct['#attributes.fuseaction#']['add']['fuseaction'] = 'campaign.list_survey';
	WOStruct['#attributes.fuseaction#']['add']['filePath'] = 'campaign/form/form_add_survey.cfm';
	WOStruct['#attributes.fuseaction#']['add']['queryPath'] = 'campaign/query/add_survey.cfm';
	WOStruct['#attributes.fuseaction#']['add']['nextEvent'] = 'campaign.list_survey&event=upd';
	
	WOStruct['#attributes.fuseaction#']['upd'] = structNew();
	WOStruct['#attributes.fuseaction#']['upd']['window'] = 'normal';
	WOStruct['#attributes.fuseaction#']['upd']['fuseaction'] = 'campaign.list_survey';
	WOStruct['#attributes.fuseaction#']['upd']['filePath'] = 'campaign/form/form_upd_survey.cfm';
	WOStruct['#attributes.fuseaction#']['upd']['queryPath'] = 'campaign/query/upd_survey.cfm';
	WOStruct['#attributes.fuseaction#']['upd']['nextEvent'] = 'campaign.list_survey&event=upd';
	WOStruct['#attributes.fuseaction#']['upd']['parameters'] = 'survey_id=##survey_id##';
	WOStruct['#attributes.fuseaction#']['upd']['Identity'] = '##survey_id##';
	
	WOStruct['#attributes.fuseaction#']['det'] = structNew();
	WOStruct['#attributes.fuseaction#']['det']['window'] = 'normal';
	WOStruct['#attributes.fuseaction#']['det']['fuseaction'] = 'campaign.list_survey';
	WOStruct['#attributes.fuseaction#']['det']['filePath'] = 'campaign/form/form_vote_survey.cfm';
	WOStruct['#attributes.fuseaction#']['det']['queryPath'] = '';
	WOStruct['#attributes.fuseaction#']['det']['nextEvent'] = '';
	WOStruct['#attributes.fuseaction#']['det']['parameters'] = '';
	WOStruct['#attributes.fuseaction#']['det']['Identity'] = '##get_survey.survey_id##';
	
	if(attributes.event is 'upd')
	{
		WOStruct['#attributes.fuseaction#']['del'] = structNew();
		WOStruct['#attributes.fuseaction#']['del']['window'] = 'emptypopup';
		WOStruct['#attributes.fuseaction#']['del']['fuseaction'] = '#request.self#?fuseaction=campaign.emptypopup_del_survey&survey_id=#attributes.survey_id#&head=#get_survey.survey_head#';
		WOStruct['#attributes.fuseaction#']['del']['filePath'] = 'campaign/query/del_survey.cfm';
		WOStruct['#attributes.fuseaction#']['del']['queryPath'] = 'campaign/query/del_survey.cfm';
		WOStruct['#attributes.fuseaction#']['del']['nextEvent'] = 'campaign.list_campaign';		
	}	
	
	// Tab Menus //
	tabMenuStruct = StructNew();
	tabMenuStruct['#attributes.fuseaction#'] = structNew();
	tabMenuStruct['#attributes.fuseaction#']['tabMenus'] = structNew();
	
	// Upd //	
	if(attributes.event is 'upd')
	{
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd'] = structNew();
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'] = structNew();
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][0]['text'] = '#lang_array.item[38]#';
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][0]['href'] = "#request.self#?fuseaction=campaign.list_survey&event=det&survey_id=#survey_id#";
		
		/*düzenleme yapılacak
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][1]['text'] = '#lang_array_main.item[1966]#';
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][1]['customTag'] = '<cf_np tablename="survey" primary_key="survey_id" pointer="survey_id=#survey_id#" dsn_var="DSN">';*/
			
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['add']['text'] = '#lang_array_main.item[207]#';
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['add']['href'] = "#request.self#?fuseaction=campaign.list_survey&event=add";
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['add']['target'] = "_blank";
		
		
				
		tabMenuData = SerializeJSON(tabMenuStruct['#attributes.fuseaction#']['tabMenus']);
	}
	else if(attributes.event is 'det')
	{
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['det'] = structNew();
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['det']['menus'] = structNew();
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['det']['menus'][0]['text'] = '#lang_array_main.item[359]#';
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['det']['menus'][0]['href'] = "#request.self#?fuseaction=campaign.list_survey&event=upd&survey_id=#attributes.survey_id#";
		tabMenuData = SerializeJSON(tabMenuStruct['#attributes.fuseaction#']['tabMenus']);
	}
	WOStruct['#attributes.fuseaction#']['extendedForm'] = structNew();
	WOStruct['#attributes.fuseaction#']['extendedForm']['controllerFileName'] = 'campaingListSurvey';
	WOStruct['#attributes.fuseaction#']['extendedForm']['eventList'] = 'add,upd';
	WOStruct['#attributes.fuseaction#']['extendedForm']['tableName'] = 'SURVEY';
	WOStruct['#attributes.fuseaction#']['extendedForm']['dataSourceName'] = 'main';
	WOStruct['#attributes.fuseaction#']['extendedForm']['settings'] = "['item-survey_head','item-date','item-partner_name','item-serial_no','item-invoice_date','item-location_id','item-adres']"; // Bu atama yapılmazsa sayfada her alan değiştirilebilir olur.		
</cfscript>
