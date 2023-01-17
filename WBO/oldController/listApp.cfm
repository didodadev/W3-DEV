<cf_get_lang_set module_name="hr">
<cfif (isdefined("attributes.event") and attributes.event is 'list') or not isdefined("attributes.event")>
	<cfset url_str = "">
    <cfif not isdefined("attributes.keyword")>
        <cfset filtered = 0>
    <cfelse>
        <cfset filtered = 1>
    </cfif>
    <cfparam name="attributes.keyword" default="">
    <cfparam name="attributes.status" default="1">
    <cfparam name="attributes.in_status" default="">
    <cfparam name="attributes.date_status" default="1">
    <cfparam name="attributes.commethod_id" default="0">
    <cfparam name="attributes.company_id" default="">
    <cfparam name="attributes.company" default="">
    <cfparam name="attributes.notice_cat_id" default="">
    <cfif isdefined("attributes.start_date") and isdate(attributes.start_date)>
        <cf_date tarih = "attributes.start_date">
    <cfelse>
        <cfset attributes.start_date = date_add('d',-7,wrk_get_today())>
    </cfif>
    <cfif isdefined("attributes.finish_date") and isdate(attributes.finish_date)>
        <cf_date tarih = "attributes.finish_date">
    <cfelse>
        <cfset attributes.finish_date = date_add('d',7,attributes.start_date)>
    </cfif>
    <!--- <cfparam name="attributes.process_stage" default=""> &process_stage=#attributes.process_stage#--->
    <cfset url_str = "#url_str#&keyword=#attributes.keyword#&status=#attributes.status#&date_status=#attributes.date_status#&commethod_id=#attributes.commethod_id#&company_id=#attributes.company_id#&company=#attributes.company#&in_status=#attributes.in_status#">
    <cfif isDefined("attributes.notice_head") and IsDefined("attributes.notice_id") and len(attributes.notice_head)>
       <cfset url_str = "#url_str#&notice_id=#attributes.notice_id#&notice_head=#attributes.notice_head#">
    </cfif>
    <cfquery name="get_notice_groups" datasource="#DSN#"><!--- İlan Grupları --->
        SELECT NOTICE_CAT_ID,NOTICE FROM SETUP_NOTICE_GROUP ORDER BY NOTICE
    </cfquery>
    <cfquery name="GET_NOTICESS" datasource="#DSN#">
      SELECT NOTICE_CAT_ID,NOTICE_ID,NOTICE_HEAD,NOTICE_NO,STATUS FROM NOTICES ORDER BY NOTICE_HEAD
    </cfquery>
    <cfset notice_list="">
    <cfset notice_cat_list="">
    <cfoutput query="GET_NOTICESS">
        <cfset notice_list=listappend(notice_list,NOTICE_ID,',')>
        <cfset notice_list=listappend(notice_list,NOTICE_NO,',')>
        <cfset notice_list=listappend(notice_list,NOTICE_HEAD,',')>
        <cfset notice_cat_list = ListAppend(notice_cat_list,NOTICE_CAT_ID)>
    </cfoutput>
    <cfif len(notice_cat_list)>
        <cfset notice_cat_list=listsort(notice_cat_list,"numeric","ASC",",")>
        <cfquery name="get_notice_groups_" dbtype="query">
            SELECT
                NOTICE_CAT_ID,NOTICE
            FROM
                get_notice_groups
            WHERE
                NOTICE_CAT_ID IN (#notice_cat_list#)
            ORDER BY
                NOTICE_CAT_ID
        </cfquery>
        <cfset notice_cat_list = listsort(listdeleteduplicates(valuelist(get_notice_groups_.NOTICE_CAT_ID,',')),'numeric','ASC',',')>
    </cfif>
    <cfinclude template="../hr/query/get_commethods.cfm">
    
    <cfif filtered>
        <cfinclude template="../hr/query/get_search_app.cfm">
    <cfelse>
        <cfset get_apps.recordcount = 0>
    </cfif>
    <cfparam name="attributes.page" default=1>
    <cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
    <cfparam name="attributes.totalrecords" default=#get_apps.recordcount#>
    <cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
    <cfset commethod_list="">
    <cfif get_commethods.recordcount>
        <cfoutput query="get_commethods">
            <cfset commethod_list=ListAppend(commethod_list,commethod_id,',')>
            <cfset commethod_list=ListAppend(commethod_list,commethod,',')>
        </cfoutput>
    </cfif>
    <cfif get_apps.recordcount>
        <cfoutput query="get_apps">		
            <cfset attributes.COMMETHOD_ID = COMMETHOD_ID>
            <cfset attributes.step_no = step_no>
            <!---<cfif len(get_apps.NOTICE_ID)>
                <cfquery name="GET_NOTICESS_" dbtype="query">
                    SELECT NOTICE_CAT_ID FROM GET_NOTICESS WHERE NOTICE_ID = #get_apps.NOTICE_ID#
                </cfquery>
            </cfif>
            <cfquery name="get_app_edu_info" datasource="#dsn#" maxrows="1">
                SELECT EDU_NAME,EDU_PART_NAME FROM EMPLOYEES_APP_EDU_INFO WHERE EMPAPP_ID = #empapp_id# ORDER BY EDU_START DESC
            </cfquery>--->
            <cfquery name="get_app_work_info" datasource="#dsn#" maxrows="1">
                SELECT EXP,EXP_POSITION,EXP_FINISH FROM EMPLOYEES_APP_WORK_INFO WHERE EMPAPP_ID = #empapp_id# ORDER BY EXP_START DESC
            </cfquery>
        </cfoutput>
    </cfif>
    <cfif isdate(attributes.start_date)>
        <cfset url_str = "#url_str#&start_date=#dateformat(attributes.start_date,'dd/mm/yyyy')#">
    </cfif>
        <cfif isdate(attributes.finish_date)>
        <cfset url_str = "#url_str#&finish_date=#dateformat(attributes.finish_date,'dd/mm/yyyy')#">
    </cfif>
<cfelseif isdefined("attributes.event") and attributes.event is 'add'>
	<cfset xfa.upd= "hr.emptypopup_add_app_pos">
	<cfinclude template="../hr/query/get_app.cfm">
	<cfinclude template="../hr/query/get_commethods.cfm">
	<cfinclude template="../hr/query/get_moneys.cfm">
<cfelseif isdefined("attributes.event") and attributes.event is 'upd'>
	<cfset xfa.upd= "hr.emptypopup_upd_app_pos">
    <cfset xfa.del= "hr.emptypopup_del_app_pos">
    <cfquery name="get_app" datasource="#dsn#"><!---gerekli query--->
        SELECT * FROM EMPLOYEES_APP_POS WHERE APP_POS_ID=#attributes.app_pos_id#
    </cfquery>
    <cfif isdefined('attributes.empapp_id')>
      <cfquery name="get_empapp" datasource="#dsn#">
      SELECT EMPAPP_ID,NAME, SURNAME FROM EMPLOYEES_APP WHERE EMPAPP_ID=#attributes.empapp_id#
      </cfquery>
    </cfif>
    <cfif get_app.recordcount or get_empapp.recordcount>
        <cfif len(GET_APP.POSITION_ID)>
            <cfset attributes.POSITION_CODE = GET_APP.POSITION_ID>
            <cfquery name="get_position" datasource="#dsn#">
                SELECT
                    POSITION_ID,
                    POSITION_CODE,
                    POSITION_NAME,
                    EMPLOYEE_NAME,
                    EMPLOYEE_SURNAME
                FROM
                    EMPLOYEE_POSITIONS
                WHERE
                    POSITION_CODE = #GET_APP.POSITION_ID#
            </cfquery>
            <cfset app_position = "#GET_POSITION.POSITION_NAME#">
        <cfelse>
            <cfset attributes.POSITION_CODE = "">
            <cfset app_position = "">
        </cfif>
        <cfif len(GET_APP.POSITION_CAT_ID)>
            <cfset attributes.position_cat_id = GET_APP.POSITION_CAT_ID>
            <cfinclude template="../hr/query/get_position_cat.cfm">
            <cfset position_cat = "#GET_POSITION_CAT.POSITION_CAT#">
        <cfelse>
            <cfset attributes.position_cat_id = "">
            <cfset position_cat = "">
        </cfif>
        <cfinclude template="../hr/query/get_moneys.cfm">
        <cfinclude template="../hr/query/get_commethods.cfm">
        <cfif len(get_app.notice_id)>
            <cfquery name="get_notice" datasource="#dsn#">
                SELECT NOTICE_HEAD,NOTICE_NO FROM NOTICES WHERE NOTICE_ID = #get_app.notice_id#
            </cfquery>
       	</cfif>
        <cfif len(get_app.department_id) and len(get_app.our_company_id)>
            <cfquery name="get_our_company" datasource="#dsn#">
                SELECT BRANCH.BRANCH_NAME, BRANCH.BRANCH_ID, DEPARTMENT.DEPARTMENT_HEAD, DEPARTMENT.DEPARTMENT_ID FROM DEPARTMENT, BRANCH WHERE BRANCH.COMPANY_ID=#get_app.our_company_id# AND BRANCH.BRANCH_ID=DEPARTMENT.BRANCH_ID AND BRANCH.BRANCH_ID=#get_app.branch_id# AND DEPARTMENT.DEPARTMENT_ID=#get_app.department_id#
            </cfquery>
          </cfif>
   	</cfif>
</cfif>
<script type="text/javascript">
	<cfif (isdefined("attributes.event") and attributes.event is 'list') or not isdefined("attributes.event")>
		$(document).ready(function() {
			$('#keyword').focus();
		});
	<cfelseif isdefined("attributes.event") and attributes.event is 'add'>
		function kontrol()
		{
			if (add_app_pos.app_position.value.length == 0) add_app_pos.position_id.value = "";
			if (add_app_pos.position_cat.value.length == 0) add_app_pos.position_cat_id.value = "";
			if ( (add_app_pos.notice_id.value.length==0) && (add_app_pos.position_id.value.length == 0) && (add_app_pos.position_cat_id.value.length == 0) )
				{
					alert("<cf_get_lang no='1094.Pozisyon Veya İlan Seçmelisiniz'> !");
					return false;
				}
		
			if ((document.add_app_pos.detail_app.value.length)>1000)
			{
				alert("<cf_get_lang no='1095.Ön yazı alanının uzunluğu 1000 karakterden az olmalıdır'>!");
				return false;
			}
			document.add_app_pos.salary_wanted.value = filterNum(document.add_app_pos.salary_wanted.value);
			/*aşama kontrol return process_cat_control();*/
			return true;
		}
	<cfelseif isdefined("attributes.event") and attributes.event is 'upd'>
		function kontrol()
		{
			if ((document.emp_pos_detail.detail_app.value.length)>1000)
			{
				alert("<cf_get_lang no='1095.Ön yazı alanının uzunluğu 1000 karakterden az olmalıdır'>!");
				return false;
			}
			document.emp_pos_detail.salary_wanted.value = filterNum(document.emp_pos_detail.salary_wanted.value);
			/*return  process_cat_control(); aşama kontrol*/
			return true;
		}
	</cfif>
</script>
<cfscript>
	WOStruct = StructNew();
	WOStruct['#attributes.fuseaction#'] = structNew();
	WOStruct['#attributes.fuseaction#']['default'] = 'list';
	if(not isdefined('attributes.event'))
		attributes.event = WOStruct['#attributes.fuseaction#']['default'];
	
	WOStruct['#attributes.fuseaction#']['list'] = structNew();
	WOStruct['#attributes.fuseaction#']['list']['window'] = 'normal';
	WOStruct['#attributes.fuseaction#']['list']['fuseaction'] = 'hr.apps';
	WOStruct['#attributes.fuseaction#']['list']['filePath'] = 'hr/display/list_app.cfm';
	
	WOStruct['#attributes.fuseaction#']['add'] = structNew();
	WOStruct['#attributes.fuseaction#']['add']['window'] = 'normal';
	WOStruct['#attributes.fuseaction#']['add']['fuseaction'] = 'hr.apps';
	WOStruct['#attributes.fuseaction#']['add']['filePath'] = 'hr/form/add_app_pos.cfm';
	WOStruct['#attributes.fuseaction#']['add']['queryPath'] = 'hr/query/add_app_pos.cfm';
	WOStruct['#attributes.fuseaction#']['add']['nextEvent'] = 'hr.apps&event=upd';
	
	WOStruct['#attributes.fuseaction#']['upd'] = structNew();
	WOStruct['#attributes.fuseaction#']['upd']['window'] = 'normal';
	WOStruct['#attributes.fuseaction#']['upd']['fuseaction'] = 'hr.apps';
	WOStruct['#attributes.fuseaction#']['upd']['filePath'] = 'hr/form/upd_app_pos.cfm';
	WOStruct['#attributes.fuseaction#']['upd']['queryPath'] = 'hr/query/upd_app_pos.cfm';
	WOStruct['#attributes.fuseaction#']['upd']['nextEvent'] = 'hr.apps&event=upd';
	WOStruct['#attributes.fuseaction#']['upd']['parameters'] = 'empapp_id=##attributes.empapp_id##&app_pos_id=##attributes.app_pos_id##';
	WOStruct['#attributes.fuseaction#']['upd']['Identity'] = '##get_app.empapp_id##';
	
	
	if(isdefined('attributes.event') and attributes.event is 'upd')
	{
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd'] = structNew();
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'] = structNew();
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][0]['text'] = '#lang_array.item[862]#';
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][0]['onClick'] = "windowopen('#request.self#?fuseaction=hr.popup_select_list_empapp&empapp_id=#get_app.empapp_id#&app_pos_id=#app_pos_id#','medium')";
		
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['print']['text'] = '#lang_array_main.item[62]#';
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['print']['onClick'] = "windowopen('#request.self#?fuseaction=objects.popup_print_files&iid=#app_pos_id#&print_type=171','page','workcube_print')";

		tabMenuData = SerializeJSON(tabMenuStruct['#attributes.fuseaction#']['tabMenus']);

	}
	WOStruct['#attributes.fuseaction#']['extendedForm'] = structNew();
	WOStruct['#attributes.fuseaction#']['extendedForm']['controllerFileName'] = 'listApp';
	WOStruct['#attributes.fuseaction#']['extendedForm']['eventList'] = 'add,upd';
	WOStruct['#attributes.fuseaction#']['extendedForm']['tableName'] = 'EMPLOYEES_APP_POS';
	WOStruct['#attributes.fuseaction#']['extendedForm']['dataSourceName'] = 'main';
	WOStruct['#attributes.fuseaction#']['extendedForm']['settings'] = "['item-notice','item-position_cat','item-position','item-department','item-company','item-detail_app','item-app_date']"; // Bu atama yapılmazsa sayfada her alan değiştirilebilir olur.
</cfscript>