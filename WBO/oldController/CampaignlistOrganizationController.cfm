<cf_get_lang_set module_name="campaign">
<cfif (isdefined("attributes.event") and attributes.event is 'list') or not isdefined("attributes.event")>
    <cfparam name="attributes.keyword" default="">
    <cfparam name="attributes.emp_id" default="">
    <cfparam name="attributes.par_id" default="">
    <cfparam name="attributes.cons_id" default="">
    <cfparam name="attributes.member_type" default="">
    <cfparam name="attributes.member_name" default="">
    <cfparam name="attributes.keyword" default="">
    <cfparam name="attributes.is_active" default="1">
    <cfif isdefined("attributes.is_submitted")>
        <cfquery name="GET_ORGANIZATION" datasource="#dsn#">
            SELECT 
                ORGANIZATION_ID,
                ORGANIZATION_HEAD,
                ORGANIZATION_CAT_ID,
                (SELECT ORGANIZATION_CAT_NAME FROM ORGANIZATION_CAT WHERE ORGANIZATION_CAT_ID = ORGANIZATION.ORGANIZATION_CAT_ID) ORGANIZATION_CAT_NAME,
                CASE 
                    WHEN ORGANIZATION.ORGANIZER_PAR IS NOT NULL THEN 
                        (SELECT C2.NICKNAME+' - '+CP2.COMPANY_PARTNER_NAME + ' ' + CP2.COMPANY_PARTNER_SURNAME NAME FROM COMPANY_PARTNER CP2,COMPANY C2 WHERE C2.COMPANY_ID = CP2.COMPANY_ID AND CP2.PARTNER_ID = ORGANIZATION.ORGANIZER_PAR)
                    WHEN ORGANIZATION.ORGANIZER_EMP IS NOT NULL THEN 
                        (SELECT EMPLOYEES.EMPLOYEE_NAME + ' ' + EMPLOYEES.EMPLOYEE_SURNAME NAME FROM EMPLOYEES WHERE EMPLOYEES.EMPLOYEE_ID = ORGANIZATION.ORGANIZER_EMP) 
                    WHEN ORGANIZATION.ORGANIZER_CON IS NOT NULL THEN
                        (SELECT CONSUMER.CONSUMER_NAME +' '+ CONSUMER.CONSUMER_SURNAME FROM CONSUMER WHERE CONSUMER.CONSUMER_ID = ORGANIZATION.ORGANIZER_CON)
                END AS ORGANIZER,
                CASE 
                    WHEN IS_ACTIVE = 1 THEN 'Aktif'
                    WHEN IS_ACTIVE = 0 THEN 'Pasif'
                END AS ACTIVE,
                ORGANIZER_PAR,
                START_DATE,
                FINISH_DATE,
                MAX_PARTICIPANT,
                ADDITIONAL_PARTICIPANT,
                ORGANIZATION_PLACE,
                CAMPAIGN_ID,
                PROJECT_ID,
                INT_OR_EXT,
                IS_INTERNET,
                TOTAL_DATE,
                TOTAL_HOUR,
                RECORD_DATE,
                (SELECT EMPLOYEE_NAME +' '+EMPLOYEE_SURNAME FROM EMPLOYEES WHERE EMPLOYEES.EMPLOYEE_ID = ORGANIZATION.RECORD_EMP) NAME
            FROM
                ORGANIZATION
            WHERE
                1=1 
            <cfif attributes.is_active eq 1>
                AND IS_ACTIVE = 1
            <cfelseif  attributes.is_active eq 0>
                AND IS_ACTIVE = 0
            </cfif>
            <cfif len(attributes.keyword)>
                AND 
                (
                    ORGANIZATION_HEAD LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.keyword#%"> OR
                    ORGANIZATION_PLACE LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.keyword#%">
                )
            </cfif>
            <cfif len(attributes.member_name)>
                <cfif len(attributes.emp_id)>AND ORGANIZER_EMP= <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.emp_id#"></cfif> 
                <cfif len(attributes.par_id)>AND ORGANIZER_CON = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.par_id#"></cfif>
                <cfif len(attributes.cons_id)>AND ORGANIZER_PAR = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.cons_id#"></cfif>
            </cfif>
        </cfquery>
    <cfelse>
        <cfset get_organization.recordcount = 0>	
    </cfif>
    <cfquery name="GET_ORGANIZATION_CAT" datasource="#DSN#">
        SELECT ORGANIZATION_CAT_ID,ORGANIZATION_CAT_NAME FROM ORGANIZATION_CAT
    </cfquery>
    <cfparam name="attributes.page" default="1">
    <cfparam name="attributes.maxrows" default="20">
    <cfparam name="attributes.totalrecords" default="#get_organization.recordcount#">
    <cfset attributes.startrow =((attributes.page-1)*attributes.maxrows+1)>
<cfelseif isdefined("attributes.event") and attributes.event is 'upd'>
        <cfquery name="GET_ORGANIZATIONS" datasource="#DSN#">
            SELECT 
                O.IS_ACTIVE,
                O.ORGANIZATION_HEAD,
                O.ORGANIZATION_CAT_ID,
                O.ORGANIZER_EMP,
                O.ORGANIZER_CON,
                O.ORGANIZER_PAR,
                O.START_DATE,
                O.FINISH_DATE,
                O.MAX_PARTICIPANT,
                O.ADDITIONAL_PARTICIPANT,
                O.ORGANIZATION_DETAIL,
                O.ORGANIZATION_PLACE,
                O.ORGANIZATION_PLACE_ADDRESS,
                O.ORGANIZATION_PLACE_TEL,
                O.ORGANIZATION_PLACE_MANAGER,
                O.ORGANIZATION_ANNOUNCEMENT,
                O.ORGANIZATION_TARGET,
                O.ORGANIZATION_TOOLS,
                O.CAMPAIGN_ID,
                O.PROJECT_ID,
                O.VIEW_TO_ALL,
                O.INT_OR_EXT,
                O.IS_INTERNET,
                O.IS_VIEW_BRANCH,
                O.IS_VIEW_DEPARTMENT,
                O.TOTAL_DATE,
                O.TOTAL_HOUR,
                O.RECORD_DATE,
                O.RECORD_EMP,
                O.RECORD_IP,
                O.UPDATE_DATE,
                O.UPDATE_EMP,
                O.UPDATE_IP,
                EP.EMPLOYEE_NAME + ' ' + EP.EMPLOYEE_SURNAME AS EMPLOYEE_NICKNAME,
                CP.COMPANY_PARTNER_NAME + ' ' + CP.COMPANY_PARTNER_SURNAME AS COMPANY_PARTNER_NICKNAME,
                CC.CONSUMER_NAME + ' ' + CC.CONSUMER_SURNAME AS CCONSUMER_NICKNAME,
                EEP.POSITION_CODE,
                PP.PROJECT_ID,
                PP.PROJECT_HEAD,
                CMK.CAMP_ID,
                CMK.CAMP_HEAD
            FROM 
                ORGANIZATION O
                LEFT JOIN EMPLOYEES EP ON EP.EMPLOYEE_ID = O.ORGANIZER_EMP
                LEFT JOIN COMPANY_PARTNER CP ON CP.PARTNER_ID = O.ORGANIZER_PAR
                LEFT JOIN CONSUMER CC ON CC.CONSUMER_ID = O.ORGANIZER_CON
                LEFT JOIN #dsn3_alias#.CAMPAIGNS CMK ON CMK.CAMP_ID = O.CAMPAIGN_ID
                LEFT JOIN EMPLOYEE_POSITIONS EEP ON EEP.EMPLOYEE_ID = O.RECORD_EMP
                LEFT JOIN PRO_PROJECTS PP ON PP.PROJECT_ID = O.PROJECT_ID
            WHERE 
                O.ORGANIZATION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.org_id#">
                AND EEP.IS_MASTER = 1
        </cfquery>
    <cfquery name="GET_SITE_DOMAINS" datasource="#DSN#">
        SELECT ORGANIZATION_ID,MENU_ID FROM ORGANIZATION_SITE_DOMAIN
    </cfquery>
    
    <cfif len(get_organizations.start_date)>
         <cfset start_date = date_add('h',session.ep.time_zone,get_organizations.start_date)> 
    <cfelse>
        <cfset start_date = "">
    </cfif>
    <cfif len(get_organizations.finish_date)>
        <cfset finish_date = date_add('h',session.ep.time_zone,get_organizations.finish_date)>
    <cfelse>
        <cfset finish_date = "">
    </cfif>
    
    <cfoutput query="get_organizations">
        <input type="hidden" name="emp_id" id="emp_id" value="<cfif len(organizer_emp)>#organizer_emp#</cfif>">
        <input type="hidden" name="par_id" id="par_id" value="<cfif len(organizer_par)>#organizer_par#</cfif>">
        <input type="hidden" name="con_id" id="con_id" value="<cfif len(organizer_con)>#organizer_con#</cfif>"> 
        <input type="hidden" name="member_type" id="member_type" value="">
        <cfif len(get_organizations.organizer_emp)>
			<cfset Emp_Par_Name =   Employee_Nickname>      
      <cfelseif len(get_organizations.organizer_par)>
            <cfset Emp_Par_Name =   Company_Partner_Nickname>
        <cfelseif len(get_organizations.organizer_con)>
            <cfset Emp_Par_Name =  Consumer_Nickname>
        <cfelse>
            <cfset Ep_Par_Name =  "">
        </cfif>
    </cfoutput>
</cfif>
<cfif (isdefined("attributes.event") and attributes.event is 'add') or (isdefined("attributes.event") and attributes.event is 'upd')>
    <cfquery name="get_site_menu" datasource="#DSN#">
        SELECT MENU_ID,SITE_DOMAIN,OUR_COMPANY_ID FROM MAIN_MENU_SETTINGS WHERE IS_ACTIVE = 1 AND SITE_DOMAIN IS NOT NULL
    </cfquery>
    <cfif isdefined("attributes.prj_id")>
        <cfquery name="GET_PROJECT" datasource="#DSN#">
            SELECT PROJECT_HEAD,PROJECT_ID FROM PRO_PROJECTS WHERE PROJECT_ID = #attributes.prj_id#
        </cfquery>
	</cfif>
	<cfquery name="FIND_DEPARTMENT_BRANCH" datasource="#DSN#">
    SELECT
        EMPLOYEE_POSITIONS.EMPLOYEE_ID,
        EMPLOYEE_POSITIONS.POSITION_ID,
        EMPLOYEE_POSITIONS.POSITION_CODE,
        BRANCH.BRANCH_ID,
        BRANCH.BRANCH_NAME,
        DEPARTMENT.DEPARTMENT_ID,
        DEPARTMENT.DEPARTMENT_HEAD
    FROM
        EMPLOYEE_POSITIONS,
        DEPARTMENT,
        BRANCH
    WHERE
        EMPLOYEE_POSITIONS.DEPARTMENT_ID = DEPARTMENT.DEPARTMENT_ID AND
        DEPARTMENT.BRANCH_ID = BRANCH.BRANCH_ID AND
		<cfif (isdefined("attributes.event") and attributes.event is 'upd')>
            EMPLOYEE_POSITIONS.POSITION_CODE = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_organizations.position_code#">
        <cfelse>
            EMPLOYEE_POSITIONS.POSITION_CODE = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.position_code#">
        </cfif>
</cfquery>
</cfif>
<cfscript>
	// Switch //
	WOStruct = StructNew();
	
	WOStruct['#attributes.fuseaction#'] = structNew();
	
	WOStruct['#attributes.fuseaction#']['default'] = 'list';
	
	
		WOStruct['#attributes.fuseaction#']['add'] = structNew();
		WOStruct['#attributes.fuseaction#']['add']['window'] = 'normal';
		WOStruct['#attributes.fuseaction#']['add']['fuseaction'] = 'campaign.add_organization';
		WOStruct['#attributes.fuseaction#']['add']['filePath'] = 'campaign/form/add_organization.cfm';
		WOStruct['#attributes.fuseaction#']['add']['queryPath'] = 'campaign/query/add_organization.cfm';
		WOStruct['#attributes.fuseaction#']['add']['nextEvent'] = 'campaign.list_organization&event=upd';

		WOStruct['#attributes.fuseaction#']['upd'] = structNew();
		WOStruct['#attributes.fuseaction#']['upd']['window'] = 'normal';
		WOStruct['#attributes.fuseaction#']['upd']['fuseaction'] = 'campaign.upd_organization';
		WOStruct['#attributes.fuseaction#']['upd']['filePath'] = 'campaign/form/upd_organization.cfm';
		WOStruct['#attributes.fuseaction#']['upd']['queryPath'] = 'campaign/query/upd_organization.cfm';
		WOStruct['#attributes.fuseaction#']['upd']['nextEvent'] = 'campaign.list_organization&event=upd';
		WOStruct['#attributes.fuseaction#']['upd']['parameters'] = 'org_id=##attributes.org_id##';
		WOStruct['#attributes.fuseaction#']['upd']['Identity'] = '##attributes.org_id##';

		WOStruct['#attributes.fuseaction#']['list'] = structNew();
		WOStruct['#attributes.fuseaction#']['list']['window'] = 'normal';
		WOStruct['#attributes.fuseaction#']['list']['fuseaction'] = 'campaign.list_organization';
		WOStruct['#attributes.fuseaction#']['list']['filePath'] = 'campaign/display/list_organization.cfm';
		
		if(isdefined("attributes.event") and attributes.event is 'upd')
		{
			WOStruct['#attributes.fuseaction#']['del'] = structNew();
			WOStruct['#attributes.fuseaction#']['del']['window'] = 'emptypopup';
			WOStruct['#attributes.fuseaction#']['del']['fuseaction'] = 'campaign.del_organization&org_id=#attributes.org_id#';
			WOStruct['#attributes.fuseaction#']['del']['filePath'] = 'campaign/query/del_organization.cfm';
			WOStruct['#attributes.fuseaction#']['del']['queryPath'] = 'campaign/query/del_organization.cfm';
			WOStruct['#attributes.fuseaction#']['del']['nextEvent'] = 'campaign.list_organization';
		}
	
	// Tab Menus //
	tabMenuStruct = StructNew();
	tabMenuStruct['#attributes.fuseaction#'] = structNew();
	tabMenuStruct['#attributes.fuseaction#']['tabMenus'] = structNew();
	// Upd //
	if(isdefined("attributes.event") and attributes.event is 'upd')
	{
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd'] = structNew();
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'] = structNew();
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['add']['text'] = 'Ekle';
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['add']['href'] = "#request.self#?fuseaction=campaign.list_organization&event=add";
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['add']['target'] = "_blank";
		tabMenuData = SerializeJSON(tabMenuStruct['#attributes.fuseaction#']['tabMenus']);
	}
	WOStruct['#attributes.fuseaction#']['extendedForm'] = structNew();
	WOStruct['#attributes.fuseaction#']['extendedForm']['controllerFileName'] = 'CampainglistOrganizationController';
	WOStruct['#attributes.fuseaction#']['extendedForm']['eventList'] = 'add,upd';
	WOStruct['#attributes.fuseaction#']['extendedForm']['tableName'] = 'ORGANIZATION';
	WOStruct['#attributes.fuseaction#']['extendedForm']['dataSourceName'] = 'main';
	WOStruct['#attributes.fuseaction#']['extendedForm']['settings'] = "['item-organization_cat_id','item-organization_head','item-emp_par_name','item-start_date','item-finish_date']"; // Bu atama yapılmazsa sayfada her alan değiştirilebilir olur.
</cfscript>

<cfif (isdefined("attributes.event") and attributes.event is 'add') or (isdefined("attributes.event") and attributes.event is 'upd')>
	<script type="text/javascript">
        //temp=organization_form.organization_id;
//        funsction redirect(x)
//        {
//            for (m=temp.options.length-1;m>0;m--)
//                temp.options[m] = null;
//            for (i=0;i<group[x].length;i++)
//                temp.options[i]=new Option(group[x][i].text,group[x][i].value);
//        
//            temp.options[0].selected=true;
//        }
        function check()
        {
            if (document.organization_form.organization_cat_id.value =='' || document.organization_form.organization_cat_id.value == 0)
                {
                    alert("<cf_get_lang_main no='782.Zorunlu Alan'>:<cf_get_lang_main no='74.Kategori'>");
                    return false;
                }
            
            if ( (organization_form.start_date.value != "") && (organization_form.finish_date.value != "") )
                return time_check(organization_form.start_date, organization_form.event_start_clock, organization_form.event_start_minute, organization_form.finish_date,  organization_form.event_finish_clock, organization_form.event_finish_minute, "Ders Başlama Tarihi Bitiş Tarihinden önce olmalıdır!");
            return true;
            
        }
        function kontrol()
        {
            if(document.getElementById('organization_announcement').value.length > 1500)
            {
                alert("<cf_get_lang dictionary_id='52642.Etkinlik Duyurusu Karakter Sayısı Maksimum: 1500 !'>");
                return false;
            }
            if(document.getElementById('organization_target').value.length > 4000)
            {
                alert("<cf_get_lang dictionary_id='Etkinlik İçeriğinin Karakter sayısı 4000 den fazla olamaz'>!");
                return false;
            }
            if(document.getElementById("organization_cat_id").value == "")
            {
                alert("<cf_get_lang_main no='782.Zorunlu Alan'>:<cf_get_lang_main no='74.Kategori'>");
                return false;
            }
            if(document.getElementById("emp_par_name").value == "")
            {
                alert("<cf_get_lang_main no='782.Zorunlu Alan'>:<cf_get_lang no='394.Etkinlik Yetkilisi'>");
                return false;
            }	
            return check();
        }
        function view_control(type)
        {
            if(type==1)
            {
                document.organization_form.is_view_branch.checked=false;
                document.organization_form.is_view_department.checked=false;
            }
            if(type==2)
            {
                document.organization_form.view_to_all.checked=false;
                document.organization_form.is_view_department.checked=false;
            }
            if(type==3)
            {
                document.organization_form.view_to_all.checked=false;
                document.organization_form.is_view_branch.checked=false;
            }
        }
    </script>
    <cfif (isdefined("attributes.event") and attributes.event is 'upd')>
		<script type="text/javascript">
            //BURASI "OLAY TAKVİMİ" İLE İLGİLİ
            try{ // Eğer ilk satır hata verirse ki olay takviminden gelirse hata vermez. o zaman çalışmaz
                scheduler = window.opener.scheduler;
                d1 = document.getElementById('start_date').value.split('/');
                d2 = document.getElementById('finish_date').value.split('/');
                
                tmpobj = scheduler.getEvent(scheduler.pre_obj.id);
                
                tmpobj.text = document.getElementById('organization_head').value;
                    
                start_clock = document.getElementById('event_start_clock').value;
                start_minute = document.getElementById('event_start_minute').value;
                tmpobj.start_date = d1[0]+'-'+d1[1]+'-'+d1[2]+' '+start_clock+':'+start_minute;
                
                finish_clock = document.getElementById('event_finish_clock').value;
                finish_minute = document.getElementById('event_finish_minute').value;
                tmpobj.end_date = d2[0]+'-'+d2[1]+'-'+d2[2]+' '+finish_clock+':'+finish_minute;	
                
                scheduler.addEvent(tmpobj);
            }catch(err){}
        </script>
    </cfif>
</cfif>    
