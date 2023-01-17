<cf_get_lang_set module_name="salesplan">
<cfif (isdefined("attributes.event") and attributes.event is 'list') or not isdefined("attributes.event")>
	<cfif isdefined("attributes.form_submitted")>
        <cfinclude template="../salesplan/query/get_sales_zones.cfm">
    <cfelse>
        <cfset get_sales_zones.recordcount=0>
    </cfif>
    <cfparam name="attributes.page" default=1>
    <cfparam name="attributes.is_active" default="">
    <cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
    <cfparam name="attributes.totalrecords" default='#get_sales_zones.recordcount#'>
    <cfparam name="attributes.branch_id" default="">
    <cfparam name="attributes.form_submitted" default="">
    <cfparam name="attributes.keyword" default="">
    <cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
    <cfquery name="get_branch" datasource="#dsn#">
        SELECT 
            BRANCH_NAME,
            BRANCH_ID
        FROM
            BRANCH
        WHERE
            BRANCH_ID IN(
                        SELECT
                            BRANCH_ID
                        FROM
                            EMPLOYEE_POSITION_BRANCHES
                        WHERE
                            POSITION_CODE = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.position_code#">
                        )
        ORDER BY
            BRANCH_NAME
    </cfquery>
    <cfelseif isdefined("attributes.event") and listfindnocase('add,upd',attributes.event)>
    	<cfinclude template="../salesplan/query/get_sales_zone_hierarchy.cfm">
    	<cfif attributes.event is 'add'>        	
			<cfinclude template="../salesplan/query/get_branchs.cfm">
			<cfinclude template="../salesplan/query/get_sales_zone_hierarchy.cfm">
        </cfif>
        <cfif attributes.event is 'upd'>
        	<cf_xml_page_edit fuseact="salesplan.popup_add_sales_zones_team" is_multi_page="1">
            <cfinclude template="../salesplan/query/get_sales_zone.cfm">
            <cfif not session.ep.ehesap>
                <cfquery name="CONTROL_BRANCH" datasource="#DSN#">
                    SELECT
                        BRANCH_ID
                    FROM
                        EMPLOYEE_POSITION_BRANCHES
                    WHERE
                        POSITION_CODE = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.position_code#"> AND
                        BRANCH_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_sales_zone.responsible_branch_id#">
                </cfquery>
                <cfif not control_branch.recordcount>
                    <script type="text/javascript">
                        alert("<cf_get_lang no='17.Bu Satış Bölgesinde İşlem Yetkiniz Bulunmamaktadır'>!");
                        history.back();
                    </script>
                </cfif>   
            </cfif>             
				<cfif xml_select_upper_team>
                    <cfquery name="GET_SALES_ZONES_TEAM" datasource="#DSN#">
                        SELECT DISTINCT
                            UST_TAKIM.TEAM_ID, 
                            UST_TAKIM.TEAM_NAME, 
                            UST_TAKIM.SALES_ZONES, 
                            UST_TAKIM.OZEL_KOD, 
                            UST_TAKIM.RESPONSIBLE_BRANCH_ID, 
                            UST_TAKIM.LEADER_POSITION_CODE, 
                            UST_TAKIM.LEADER_POSITION_ROLE_ID, 
                            UST_TAKIM.COUNTRY_ID, 
                            UST_TAKIM.CITY_ID,
                            UST_TAKIM.RECORD_DATE, 
                            UST_TAKIM.RECORD_EMP, 
                            UST_TAKIM.RECORD_IP, 
                            UST_TAKIM.UPDATE_DATE, 
                            UST_TAKIM.UPDATE_EMP, 
                            UST_TAKIM.UPDATE_IP, 
                            UST_TAKIM.COMPANY_CAT_IDS, 
                            UST_TAKIM.CONSUMER_CAT_IDS,
                            UST_TAKIM.UPPER_TEAM_ID
                            <cfif isdefined("attributes.upper_filter") and attributes.upper_filter neq 1>
                            ,ALT_TAKIM.TEAM_ID AS TEAM_ID2, 
                            ALT_TAKIM.TEAM_NAME AS TEAM_NAME2, 
                            ALT_TAKIM.SALES_ZONES AS SALES_ZONES2, 
                            ALT_TAKIM.OZEL_KOD AS OZEL_KOD2, 
                            ALT_TAKIM.RESPONSIBLE_BRANCH_ID AS RESPONSIBLE_BRANCH_ID2, 
                            ALT_TAKIM.LEADER_POSITION_CODE AS LEADER_POSITION_CODE2, 
                            ALT_TAKIM.LEADER_POSITION_ROLE_ID AS LEADER_POSITION_ROLE_ID2, 
                            ALT_TAKIM.COUNTRY_ID AS COUNTRY_ID2, 
                            ALT_TAKIM.CITY_ID AS CITY_ID2,
                            ALT_TAKIM.RECORD_DATE AS RECORD_DATE2, 
                            ALT_TAKIM.RECORD_EMP AS RECORD_EMP2, 
                            ALT_TAKIM.RECORD_IP AS RECORD_IP2, 
                            ALT_TAKIM.UPDATE_DATE AS UPDATE_DATE2, 
                            ALT_TAKIM.UPDATE_EMP AS UPDATE_EMP2, 
                            ALT_TAKIM.UPDATE_IP AS UPDATE_IP2, 
                            ALT_TAKIM.COMPANY_CAT_IDS AS COMPANY_CAT_IDS2, 
                            ALT_TAKIM.CONSUMER_CAT_IDS AS CONSUMER_CAT_IDS2,
                            ALT_TAKIM.UPPER_TEAM_ID AS UPPER_TEAM_ID2
                            </cfif> 
                         FROM 
                            SALES_ZONES_TEAM ALT_TAKIM RIGHT JOIN
                            SALES_ZONES_TEAM UST_TAKIM
                        ON
                            ALT_TAKIM.UPPER_TEAM_ID = UST_TAKIM.TEAM_ID
                        WHERE 
                            UST_TAKIM.SALES_ZONES = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.sz_id#"> AND UST_TAKIM.UPPER_TEAM_ID IS NULL 
                        ORDER BY 
                            UST_TAKIM.TEAM_NAME
                    </cfquery>
                <cfelse>
                    <cfquery name="GET_SALES_ZONES_TEAM" datasource="#DSN#">
                        SELECT
                            TEAM_ID, 
                            TEAM_NAME, 
                            SALES_ZONES, 
                            OZEL_KOD, 
                            RESPONSIBLE_BRANCH_ID, 
                            LEADER_POSITION_CODE, 
                            LEADER_POSITION_ROLE_ID, 
                            COUNTRY_ID, 
                            CITY_ID,
                            RECORD_DATE, 
                            RECORD_EMP, 
                            RECORD_IP, 
                            UPDATE_DATE, 
                            UPDATE_EMP, 
                            UPDATE_IP, 
                            COMPANY_CAT_IDS, 
                            CONSUMER_CAT_IDS,
                            UPPER_TEAM_ID
                        FROM 
                            SALES_ZONES_TEAM
                        WHERE 
                            SALES_ZONES = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.sz_id#"> 
                        ORDER BY 
                            TEAM_NAME
                    </cfquery>
                </cfif>
                <cfquery name="GET_SALES_SUB_ZONE" datasource="#DSN#">
                    SELECT 
                        SZ_NAME, 
                        SZ_ID,
                        SZ_HIERARCHY,
                        IS_ACTIVE,
                        RESPONSIBLE_BRANCH_ID,
                        B.BRANCH_NAME
                    FROM 
                        SALES_ZONES,
                        BRANCH B
                    WHERE 
                        SZ_ID <> <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.sz_id#"> AND 
                        SZ_HIERARCHY LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="#get_sales_zone.sz_hierarchy#.%"> AND
                        B.BRANCH_ID = SALES_ZONES.RESPONSIBLE_BRANCH_ID
                </cfquery>
				<cfif len(get_sales_zone.responsible_branch_id)>
                    <cfquery name="GET_BRANCH" datasource="#DSN#">
                        SELECT BRANCH_NAME FROM BRANCH WHERE BRANCH_ID = #get_sales_zone.responsible_branch_id#
                    </cfquery>
                </cfif>  
        </cfif> 
        
</cfif>

<script type="text/javascript">
	<cfif (isdefined("attributes.event") and attributes.event is 'list') or not isdefined("attributes.event")>
		$( document ).ready(function() {
		   document.getElementById('keyword').focus();
		});
	<cfelseif isdefined("attributes.event") and listfindnocase('add,upd',attributes.event)>
		function check()
			{
				if (document.sales_zone.responsible_position.value == "" || (document.sales_zone.responsible_position_code.value == "" && document.sales_zone.responsible_cmp_id.value=="" && document.sales_zone.responsible_consumer_id.value==""))
				{
					alert("<cf_get_lang_main no='782.Zorunlu Alan'> : <cf_get_lang no='13.Bölge Yöneticisi'>");
					return false;
				}
				if((document.sales_zone.responsible_branch.value=="") || (document.sales_zone.responsible_branch_id.value==""))
				{
					alert("<cf_get_lang_main no='782.Zorunlu Alan'> : <cf_get_lang no='12.İlgili Şube'>");
					return false;
				}
				return true;		
			}
			function return_company()
			{	
				if(document.getElementById('member_type').value=='employee')
				{	
					var pos_id=document.getElementById('responsible_par_id').value;
					var GET_COMPANY = wrk_safe_query('slsp_get_compny','dsn',0,pos_id);
					document.getElementById('responsible_company_id').value=GET_COMPANY.COMP_ID;
				}
				 if(document.getElementById('member_type').value=='consumer')
				{
					var responsible_name=document.getElementById('responsible_par_id').value;
					var GET_COMPANY_NAME=wrk_safe_query('slsp_get_cmp_name','dsn',0,responsible_name);
					if(GET_COMPANY_NAME.COMPANY!=undefined)
						document.getElementById('responsible_company').value=GET_COMPANY_NAME.COMPANY;
				}
				else
					return false;
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
	WOStruct['#attributes.fuseaction#']['list']['fuseaction'] = 'salesplan.list_plan';
	WOStruct['#attributes.fuseaction#']['list']['filePath'] = 'salesplan/display/dsp_sales_plan.cfm';
	
	WOStruct['#attributes.fuseaction#']['add'] = structNew();
	WOStruct['#attributes.fuseaction#']['add']['window'] = 'normal';
	WOStruct['#attributes.fuseaction#']['add']['fuseaction'] = 'salesplan.list_plan';
	WOStruct['#attributes.fuseaction#']['add']['filePath'] = 'salesplan/form/add_sales_zone.cfm';
	WOStruct['#attributes.fuseaction#']['add']['queryPath'] = 'salesplan/query/add_sales_zone.cfm';
	WOStruct['#attributes.fuseaction#']['add']['nextEvent'] = 'salesplan.list_plan&event=upd';
	
	WOStruct['#attributes.fuseaction#']['upd'] = structNew();
	WOStruct['#attributes.fuseaction#']['upd']['window'] = 'normal';
	WOStruct['#attributes.fuseaction#']['upd']['fuseaction'] = 'salesplan.list_sales_plan_quotas';
	WOStruct['#attributes.fuseaction#']['upd']['filePath'] = 'salesplan/form/detail_sales_zone.cfm';
	WOStruct['#attributes.fuseaction#']['upd']['queryPath'] = 'salesplan/query/upd_sales_zone.cfm';
	WOStruct['#attributes.fuseaction#']['upd']['nextEvent'] = 'salesplan.list_plan&event=upd&sz_id=';
	WOStruct['#attributes.fuseaction#']['upd']['parameters'] = 'sz_id=##attributes.sz_id##';
	WOStruct['#attributes.fuseaction#']['upd']['Identity'] = '##attributes.sz_id##';
	
	if(isdefined("attributes.event") and attributes.event is 'upd')
	{
		
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd'] = structNew();
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'] = structNew();
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][0]['text'] = '#lang_array_main.item[345]#';
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][0]['onClick'] = "windowopen('#request.self#?fuseaction=objects.popup_page_warnings&action=salesplan.form_upd_sales_zone&action_name=sz_id&action_id=#attributes.sz_id#','list')";
		
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][1]['text'] = '#lang_array.item[18]#';
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][1]['onClick'] = "windowopen('#request.self#?fuseaction=salesplan.list_sales_team&event=add&sz_id=#sz_id#&branch_id=#get_sales_zone.responsible_branch_id#','list')";
		
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][2]['text'] = '#lang_array.item[2]#';
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][2]['onClick'] = "windowopen('#request.self#?fuseaction=salesplan.popup_list_sales_company&sz_id=#sz_id#','project')";
		if(get_sales_zones_team.recordcount)
		{
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][3]['text'] = '#lang_array.item[20]#';
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][3]['onClick'] = "windowopen('#request.self#?fuseaction=salesplan.popup_check_sales_quote_employee_based&sales_zone_id=#sz_id#&branch_id=#get_sales_zone.responsible_branch_id#','wide')";
	
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][4]['text'] = '#lang_array.item[21]#';
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][4]['onClick'] = "windowopen('#request.self#?fuseaction=salesplan.popup_check_sales_quote_ims_based&sales_zone_id=#sz_id#&branch_id=#get_sales_zone.responsible_branch_id#','wide')";
	
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][5]['text'] = '#lang_array.item[22]#';
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][5]['onClick'] = "windowopen('#request.self#?fuseaction=salesplan.popup_check_sales_quote_team_based&team_id=#sz_id#-#get_sales_zone.responsible_branch_id#&is_submit=1','wide')";
			
			if(get_sales_zones_team.recordcount)
			{
				tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][6]['text'] = '#lang_array.item[25]#';
				tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][6]['onClick'] = "windowopen('#request.self#?fuseaction=salesplan.popup_check_sales_quote_customer_based&sales_zone_id=#sz_id#&branch_id=#get_sales_zone.responsible_branch_id#x','wide')";
			}
		}
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['add']['text'] = '#lang_array_main.item[170]#';
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['add']['href'] = "#request.self#?fuseaction=salesplan.list_plan&event=add";		
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['add']['target'] = "_blank";
		
		tabMenuData = SerializeJSON(tabMenuStruct['#attributes.fuseaction#']['tabMenus']);
	}
	WOStruct['#attributes.fuseaction#']['extendedForm'] = structNew();
	WOStruct['#attributes.fuseaction#']['extendedForm']['controllerFileName'] = 'salesplanListPlan';
	WOStruct['#attributes.fuseaction#']['extendedForm']['eventList'] = 'add,upd';
	WOStruct['#attributes.fuseaction#']['extendedForm']['tableName'] = 'SALES_ZONES';
	WOStruct['#attributes.fuseaction#']['extendedForm']['dataSourceName'] = 'main';
	WOStruct['#attributes.fuseaction#']['extendedForm']['settings'] = "['item-sz_name','item-responsible_branch','item-responsible_position']"; // Bu atama yapılmazsa sayfada her alan değiştirilebilir olur.
</cfscript>
