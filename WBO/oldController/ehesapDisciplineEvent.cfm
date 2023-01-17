<!-----------------------------------------------------------------------
*************************************************************************
		Copyright Workcube E-Business Inc. www.workcube.com
*************************************************************************
Analys		: Fatih Ayık			Developer	: Meltem Aşkın		
Analys Date : 01/04/2016			Dev Date	: 13/05/2016		
Description :
	Bu controller E-Hesap Olay Tutanağı objesine ait kontrolleri yapar modelleri çağırarak ilgili setleri çalıştırır.
----------------------------------------------------------------------->

<cfset ehesapDisciplineEventModel = CreateObject("component","model.ehesapDisciplineEvent")>

<!------------------------------------------------------
	Event lere göre kontroller yapılıyor
-------------------------------------------------------->
<cfif not isdefined('attributes.formSubmittedController')>
    <cf_get_lang_set module="ehesap">
    <cfif (isdefined("attributes.event") and attributes.event is 'list') or not isdefined("attributes.event")>
        <cfparam name="attributes.param" default="">
        <cfparam name="attributes.keyword" default="">
        <cfparam name="attributes.page" default=1>
        <cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
        <cfset url_str="&keyword=#attributes.keyword#">
        <cfif isdefined('attributes.form_submit')>
            <cfset url_str = "&form_submit=#attributes.form_submit#">
        </cfif>
        <cfif isdefined('attributes.form_submit')>
            <cfinclude template="../hr/query/get_position_branches.cfm">
            <cfquery name="get_discipline_event" datasource="#DSN#">
                SELECT
                    EER.*,
                    E.EMPLOYEE_NAME,
                    E.EMPLOYEE_SURNAME
                FROM
                    EMPLOYEES_EVENT_REPORT EER
                    INNER JOIN EMPLOYEES E ON E.EMPLOYEE_ID = EER.TO_CAUTION
                WHERE
                    EVENT_TYPE LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.keyword#%">
                    <cfif not session.ep.ehesap>
                        AND E.EMPLOYEE_ID IN	
                        (	
                        SELECT EMPLOYEE_ID 
                        FROM EMPLOYEE_POSITIONS,DEPARTMENT
                        WHERE EMPLOYEE_POSITIONS.DEPARTMENT_ID = DEPARTMENT.DEPARTMENT_ID AND DEPARTMENT.BRANCH_ID IN (#my_branch_list#) 
                        )
                    </cfif>
            </cfquery>
        <cfelse>
            <cfset get_discipline_event.recordcount = 0>
        </cfif>
        <cfparam name="attributes.totalrecords" default="#get_discipline_event.recordcount#">
        <cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
    <cfelseif isdefined("attributes.event") and (attributes.event is 'add' or attributes.event is 'upd')>
        <cfinclude template="../hr/ehesap/query/get_branches.cfm">
        <cfif attributes.event is 'upd'>
            <cfscript>
            	get_event = ehesapDisciplineEventModel.GET (event_id:attributes.event_id);
				my_comp_branch_id=get_event.branch_id;
				include "../hr/ehesap/query/get_our_comp_and_branch_name.cfm";
				event_id = attributes.event_id;
				nick_name = get_com_branch.nick_name;
				event_type = get_event.event_type;
				caution_to_id = get_event.to_caution;
				caution_to = get_emp_info(get_event.to_caution,0,0);
				sign_date = dateformat(get_event.sign_date,'dd/mm/yyyy');
				witness1_id = get_event.witness_1;
				witness1_to = get_emp_info(get_event.witness_1,0,0);
				witness2_id = get_event.witness_2;
				witness2_to = get_emp_info(get_event.witness_2,0,0);
				witness3_id = get_event.witness_3;
				witness3_to = get_emp_info(get_event.witness_3,0,0);
				branch_id_cont = get_event.branch_id;
				detail = get_event.detail;
			</cfscript>
        <cfelse>
            <cfscript>
				nick_name = '';
				event_type = '';
				caution_to_id = '';
				caution_to = '';
				sign_date = '';
				witness1_id = '';
				witness1_to = '';
				witness2_id = '';
				witness2_to = '';
				witness3_id = '';
				witness3_to = '';
				branch_id_cont = '';
				detail = '';
			</cfscript>
        </cfif>
    </cfif>
</cfif>

<!------------------------------------------------------
	WOStruct
-------------------------------------------------------->

<cfscript>
	WOStruct = StructNew();
	WOStruct['#attributes.fuseaction#'] = structNew();
	WOStruct['#attributes.fuseaction#']['default'] = 'list';
	if(not isdefined('attributes.event'))
		attributes.event = WOStruct['#attributes.fuseaction#']['default'];
	
	WOStruct['#attributes.fuseaction#']['list'] = structNew();
	WOStruct['#attributes.fuseaction#']['list']['window'] = 'normal';
	WOStruct['#attributes.fuseaction#']['list']['fuseaction'] = 'ehesap.list_discipline_event';
	WOStruct['#attributes.fuseaction#']['list']['filePath'] = 'hr/ehesap/display/list_discipline_event.cfm';
	
	WOStruct['#attributes.fuseaction#']['add'] = structNew();
	WOStruct['#attributes.fuseaction#']['add']['window'] = 'popup';
	WOStruct['#attributes.fuseaction#']['add']['fuseaction'] = 'ehesap.list_discipline_event';
	WOStruct['#attributes.fuseaction#']['add']['filePath'] = 'hr/ehesap/form/add_event.cfm';
	WOStruct['#attributes.fuseaction#']['add']['queryPath'] = '';
	WOStruct['#attributes.fuseaction#']['add']['nextEvent'] = 'ehesap.list_discipline_event&event=upd&event_id=';
	WOStruct['#attributes.fuseaction#']['add']['formName'] = 'add_event';
	
	WOStruct['#attributes.fuseaction#']['add']['buttons'] = structNew();
	WOStruct['#attributes.fuseaction#']['add']['buttons']['save'] = 1;
	WOStruct['#attributes.fuseaction#']['add']['buttons']['saveFunction'] = 'validate().check()';
	
	WOStruct['#attributes.fuseaction#']['upd'] = structNew();
	WOStruct['#attributes.fuseaction#']['upd']['window'] = 'popup';
	WOStruct['#attributes.fuseaction#']['upd']['fuseaction'] = 'ehesap.list_discipline_event';
	WOStruct['#attributes.fuseaction#']['upd']['filePath'] = 'hr/ehesap/form/add_event.cfm';
	WOStruct['#attributes.fuseaction#']['upd']['queryPath'] = '';
	WOStruct['#attributes.fuseaction#']['upd']['nextEvent'] = 'ehesap.list_discipline_event&event=upd&event_id=';
	WOStruct['#attributes.fuseaction#']['upd']['parameters'] = 'event_id=##attributes.event_id##';
	WOStruct['#attributes.fuseaction#']['upd']['recordQuery'] = 'get_event';
	WOStruct['#attributes.fuseaction#']['upd']['Identity'] = '##get_event.event_id##';
	WOStruct['#attributes.fuseaction#']['upd']['formName'] = 'add_event';
	
	WOStruct['#attributes.fuseaction#']['upd']['buttons'] = structNew();
	WOStruct['#attributes.fuseaction#']['upd']['buttons']['update'] = 1;
	WOStruct['#attributes.fuseaction#']['upd']['buttons']['updateFunction'] = 'validate().check()';
	WOStruct['#attributes.fuseaction#']['upd']['buttons']['delete'] = 1;
	
	WOStruct['#attributes.fuseaction#']['systemObject']['isTransaction'] = true;
	WOStruct['#attributes.fuseaction#']['systemObject']['dataSourceName'] = dsn; // Transaction icin yapildi./
	
	if(isdefined("attributes.event") and (attributes.event is 'upd' or attributes.event is 'del'))
	{
		WOStruct['#attributes.fuseaction#']['del'] = structNew();
		WOStruct['#attributes.fuseaction#']['del']['window'] = 'emptypopup';
		WOStruct['#attributes.fuseaction#']['del']['fuseaction'] = 'ehesap.emptypopup_upd_event&event_id=#attributes.EVENT_ID#';
		WOStruct['#attributes.fuseaction#']['del']['filePath'] = '';
		WOStruct['#attributes.fuseaction#']['del']['queryPath'] = '';
		WOStruct['#attributes.fuseaction#']['del']['nextEvent'] = 'ehesap.list_discipline_event';
	}
	if(isdefined("attributes.event") and attributes.event is 'upd')
	{
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd'] = structNew();
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'] = structNew();
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][0]['text'] = '#lang_array.item[237]#';
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][0]['onClick'] = "windowopen('#request.self#?fuseaction=ehesap.popup_form_add_attorney_protocol&event_id=#attributes.event_id#','list');";
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][1]['text'] = '#lang_array.item[349]#';
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][1]['onClick'] = "windowopen('#request.self#?fuseaction=ehesap.popup_add_defence_paper&event_id=#attributes.event_id#','list');";
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][2]['text'] = '#lang_array.item[353]#';
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][2]['onClick'] = "windowopen('#request.self#?fuseaction=ehesap.popup_add_discipline_decision&event_id=#attributes.event_id#','list');";
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][3]['text'] = '#lang_array.item[510]#';
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][3]['onClick'] = "windowopen('#request.self#?fuseaction=ehesap.popup_add_punishment_paper&event_id=#attributes.event_id#','list');";
		if (not isdefined('attributes.formSubmittedController') and len(get_event.sign_date) and (dateformat(get_event.sign_date + 6,'yyyy/mm/dd') lt dateformat(now(),'yyyy/mm/dd')))
		{
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][4]['text'] = '#lang_array.item[207]#';
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][4]['onClick'] = "windowopen('#request.self#?fuseaction=ehesap.popup_add_abolition&event_id=#attributes.event_id#','list');";
		}
		
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['#attributes.event#']['icons'] = structNew();
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['#attributes.event#']['icons']['print']['text'] = '#lang_array_main.item[62]#';
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['#attributes.event#']['icons']['print']['onClick'] = "windowopen('#request.self#?fuseaction=ehesap.popup_detail_discipline_event&event_id=#attributes.event_id#&print=1','list');";
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['#attributes.event#']['icons']['print']['target'] = "_blank";
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['#attributes.event#']['icons']['add']['text'] = '#lang_array_main.item[170]#';
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['#attributes.event#']['icons']['add']['onClick'] = "windowopen('#request.self#?fuseaction=ehesap.list_discipline_event&event=add','list');";
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['#attributes.event#']['icons']['add']['target'] = "_blank";
		tabMenuData = SerializeJSON(tabMenuStruct['#attributes.fuseaction#']['tabMenus']);
	}
	
	WOStruct['#attributes.fuseaction#']['systemObject'] = structNew();	
	WOStruct['#attributes.fuseaction#']['systemObject']['dataSourceName'] = dsn;
	WOStruct['#attributes.fuseaction#']['systemObject']['extendedForm'] = true;
	WOStruct['#attributes.fuseaction#']['systemObject']['pageExtendedEventList'] = 'add,upd';
	WOStruct['#attributes.fuseaction#']['systemObject']['pageTableName'] = 'EMPLOYEES_EVENT_REPORT';
	WOStruct['#attributes.fuseaction#']['systemObject']['pageIdentityColumn'] = 'CAUTION_ID';
	WOStruct['#attributes.fuseaction#']['systemObject']['pageSettings'] = "['item-caution_to_id','item-witness1_to','item-witness2_to','item-witness3_to']"; 
</cfscript>

<!------------------------------------------------------
	modelden CRUD işlemleri yapılıyor...
-------------------------------------------------------->

<cfif isdefined('attributes.formSubmittedController') and attributes.formSubmittedController eq 1>
    <cfif isdefined('attributes.event') and attributes.event is 'add'>
        <cf_date tarih='attributes.sign_date'>
        
        <cfscript>
            add = ehesapDisciplineEventModel.add (
                caution_to_id	: attributes.caution_to_id,
                sign_date		: attributes.sign_date,
                witness1_id		: attributes.witness1_id,
				witness2_id		: attributes.witness1_id,
				witness3_id		: attributes.witness1_id,
                detail			: attributes.detail,
                event_type		: attributes.event_type,
                branch_id		: attributes.branch_id
            );
            
            attributes.actionId = add;
        </cfscript>
    <cfelseif isdefined('attributes.event') and attributes.event is 'upd'>
        <!--- upd modeli ve kontrolleri calisacak --->
        <cf_date tarih='attributes.sign_date'>
        
        <cfscript>
            upd = ehesapDisciplineEventModel.upd (
                event_id		: attributes.event_id,
				caution_to_id	: attributes.caution_to_id,
                sign_date		: attributes.sign_date,
                witness1_id		: attributes.witness1_id,
				witness2_id		: attributes.witness1_id,
				witness3_id		: attributes.witness1_id,
                detail			: attributes.detail,
                event_type		: attributes.event_type,
                branch_id		: attributes.branch_id
            );
            
            attributes.actionId = upd;
        </cfscript>
    <cfelseif isdefined('attributes.event') and attributes.event is 'del'>
        <!--- del modeli ve kontrolleri calisacak --->
        <cfscript>
			del = ehesapDisciplineEventModel.del (
				event_id: attributes.event_id
				);
		</cfscript>
    </cfif>
</cfif>
