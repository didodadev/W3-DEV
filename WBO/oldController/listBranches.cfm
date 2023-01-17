<cf_get_lang_set module_name="settings">
<cfquery name="GET_BRANCH_CAT" datasource="#DSN#">
	SELECT BRANCH_CAT_ID,BRANCH_CAT FROM SETUP_BRANCH_CAT ORDER BY BRANCH_CAT
</cfquery>
<cfif (isdefined("attributes.event") and attributes.event is 'list') or not isdefined("attributes.event")>
	<cfparam name="attributes.is_active" default=1>
	<cfparam name="attributes.company_ids" default=''>
	<cfparam name="attributes.branch_cat" default=''>
	<cfparam name="attributes.keyword" default=''>
	<cfparam name="attributes.page" default=1>
	<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
	<cfif isdefined("attributes.form_submitted")>
		<cfquery name="get_branches" datasource="#dsn#">
			SELECT
				BRANCH.BRANCH_STATUS,
				BRANCH.HIERARCHY,
				BRANCH.HIERARCHY2,
				BRANCH.BRANCH_ID,
				BRANCH.BRANCH_NAME,
				OUR_COMPANY.COMP_ID,
				OUR_COMPANY.COMPANY_NAME,
		        SETUP_BRANCH_CAT.BRANCH_CAT
			FROM
				BRANCH 
				LEFT JOIN SETUP_BRANCH_CAT ON SETUP_BRANCH_CAT.BRANCH_CAT_ID = BRANCH.BRANCH_CAT_ID
				INNER JOIN OUR_COMPANY ON BRANCH.COMPANY_ID = OUR_COMPANY.COMP_ID 
			WHERE
				BRANCH.BRANCH_ID IS NOT NULL
				<cfif len(attributes.company_ids)>
					AND BRANCH.COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.company_ids#">
				</cfif>
		        <cfif len(attributes.branch_cat)>
					AND BRANCH.BRANCH_CAT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.branch_cat#">
				</cfif>
				<cfif len(attributes.keyword) and (len(attributes.keyword) eq 1)>
					AND BRANCH.BRANCH_NAME LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.keyword#%">
				<cfelseif len(attributes.keyword) and (len(attributes.keyword) gt 1)>
					AND BRANCH.BRANCH_NAME LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.keyword#%">
				</cfif>
				<cfif len(attributes.is_active) and attributes.is_active neq 2>
					AND BRANCH.BRANCH_STATUS = <cfqueryparam cfsqltype="cf_sql_bit" value="#attributes.is_active#">
				</cfif>
				<cfif not get_module_power_user(3)>
					AND BRANCH.BRANCH_ID IN (SELECT BRANCH_ID FROM EMPLOYEE_POSITION_BRANCHES WHERE POSITION_CODE = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.position_code#">)
				</cfif>
			ORDER BY
				OUR_COMPANY.NICK_NAME,
				BRANCH.BRANCH_NAME
		</cfquery>
	<cfelse>
		<cfset get_branches.recordcount = 0>
	</cfif>
	<cfparam name="attributes.totalrecords" default="#get_branches.recordcount#">
	<cfquery name="get_comps" datasource="#dsn#">
		SELECT COMP_ID,NICK_NAME FROM OUR_COMPANY ORDER BY NICK_NAME
	</cfquery>
	<cfscript>
		attributes.startrow = ((attributes.page-1)*attributes.maxrows)+1;
		url_str = "";
		if (isdefined("attributes.keyword"))
			url_str = "#url_str#&keyword=#attributes.keyword#";
		if (isdefined("attributes.is_active"))
			url_str = "#url_str#&is_active=#attributes.is_active#";
		if (isdefined("attributes.company_ids"))
			url_str = "#url_str#&company_ids=#attributes.company_ids#";
		if (isdefined("attributes.branch_cat"))
			url_str = "#url_str#&branch_cat=#attributes.branch_cat#";
		if (isdefined("attributes.form_submitted"))
			url_str = "#url_str#&form_submitted=#attributes.form_submitted#";
	</cfscript>
<cfelseif isdefined("attributes.event") and (attributes.event is 'add' or attributes.event is 'upd')>
	<cfquery name="ZONES" datasource="#DSN#">
        SELECT ZONE_NAME, ZONE_ID, ZONE_STATUS FROM ZONE ORDER BY ZONE_NAME
    </cfquery>
    <cfinclude template="../settings/query/get_our_companies.cfm">
	<cfif attributes.event is 'upd'>
		<cfinclude template="../settings/query/get_branch_dep_count.cfm">
		<cfset active_dep = 0>
		<cfquery name="CATEGORY" datasource="#DSN#">
			SELECT
				B.ADMIN1_POSITION_CODE,
				B.ADMIN2_POSITION_CODE,
				B.ASSET_FILE_NAME1,
				B.ASSET_FILE_NAME1_SERVER_ID,
				B.ASSET_FILE_NAME2,
				B.ASSET_FILE_NAME2_SERVER_ID,
				B.BRANCH_ADDRESS,
				B.BRANCH_CAT_ID,
				B.BRANCH_CITY,
				B.BRANCH_COUNTRY,
				B.BRANCH_COUNTY,
				B.BRANCH_EMAIL,
				B.BRANCH_FAX,
				B.BRANCH_FULLNAME,
				B.BRANCH_NAME,
				B.BRANCH_POSTCODE,
				B.BRANCH_STATUS,
				B.BRANCH_TAX_NO,
				B.BRANCH_TAX_OFFICE,
				B.BRANCH_TELCODE,
				B.BRANCH_TEL1,
				B.BRANCH_TEL2,
				B.BRANCH_TEL3,
				B.COMPANY_ID,
				B.COORDINATE_1,
				B.COORDINATE_2,
				B.HIERARCHY,
				B.HIERARCHY2,
				B.IS_INTERNET,
				B.IS_ORGANIZATION,
				B.IS_PRODUCTION,
				B.OZEL_KOD,
				B.RECORD_EMP,
				B.RECORD_DATE,
				B.RELATED_BRANCH_ID,
				B.RELATED_COMPANY,
				B.UPDATE_DATE,
				B.UPDATE_EMP,
				B.ZONE_ID,
				EP.EMPLOYEE_NAME + ' ' + EP.EMPLOYEE_SURNAME AS ADMIN1_NAME,
				EP2.EMPLOYEE_NAME + ' ' + EP2.EMPLOYEE_SURNAME AS ADMIN2_NAME
		    FROM 
			    BRANCH B
			    LEFT JOIN EMPLOYEE_POSITIONS EP ON EP.POSITION_CODE = B.ADMIN1_POSITION_CODE AND EP.POSITION_STATUS = 1
			    LEFT JOIN EMPLOYEE_POSITIONS EP2 ON EP2.POSITION_CODE = B.ADMIN2_POSITION_CODE AND EP2.POSITION_STATUS = 1
		    WHERE 
		    	B.BRANCH_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.id#">
		</cfquery>
		<cfquery name="get_dep" datasource="#dsn#">
			SELECT DEPARTMENT_STATUS FROM DEPARTMENT WHERE BRANCH_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.id#"> AND DEPARTMENT_STATUS = 1
		</cfquery>
		<cfif len(category.related_branch_id)>
            <cfquery name="get_related_branch" datasource="#DSN#">
                SELECT BRANCH_NAME FROM BRANCH WHERE BRANCH_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#category.related_branch_id#">
            </cfquery>
        </cfif>
		<cfif get_dep.recordcount>
			<cfset active_dep = 1>
		</cfif>
		<cfset attributes.head="">
	</cfif>
</cfif>
<script type="text/javascript">
	<cfif (isdefined("attributes.event") and attributes.event is 'list') or not isdefined("attributes.event")>
		$(document).ready(function() {
			$('#keyword').focus();
		});
	<cfelseif isdefined("attributes.event") and (attributes.event is 'add' or attributes.event is 'upd')>
		function kontrol()
		{
			if($('#coordinate_2').val().trim() == "" || $('#coordinate_1').val().trim() == "")
			{
				alert ("Lütfen koordinat değerlerini eksiksiz giriniz!");
				return false;
			}
			<cfif attributes.event is 'add'>
				debugger;
				alert($('#branch_comp_id').val());
				if ($('#branch_comp_id').val() == '')
				{
					alert("<cf_get_lang no='1449.Lütfen Şirket Seçiniz'>. <cf_get_lang no='1450.Eğer Kayıtlı Bir Şirket Yoksa Önce Şirket Tanımlayınız'>.");
				  	return false;
				} 
			<cfelseif attributes.event is 'upd'>
				active_dep = <cfoutput>#active_dep#</cfoutput>;
				if(active_dep == 1 && $('#branch_status').is(':checked') == false)
				{
					alert ("Bu şubeye ait aktif depolar ve departmanlar bulunmaktadır!");
					return false;	
				}
			</cfif>
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
	WOStruct['#attributes.fuseaction#']['list']['fuseaction'] = 'hr.list_branches';
	WOStruct['#attributes.fuseaction#']['list']['filePath'] = 'settings/display/list_branches.cfm';
	
	WOStruct['#attributes.fuseaction#']['add'] = structNew();
	WOStruct['#attributes.fuseaction#']['add']['window'] = 'normal';
	WOStruct['#attributes.fuseaction#']['add']['fuseaction'] = 'hr.list_branches';
	WOStruct['#attributes.fuseaction#']['add']['filePath'] = 'settings/form/add_branch.cfm';
	WOStruct['#attributes.fuseaction#']['add']['queryPath'] = 'settings/query/add_branch.cfm';
	WOStruct['#attributes.fuseaction#']['add']['nextEvent'] = 'hr.list_branches&event=upd';
	
	WOStruct['#attributes.fuseaction#']['upd'] = structNew();
	WOStruct['#attributes.fuseaction#']['upd']['window'] = 'normal';
	WOStruct['#attributes.fuseaction#']['upd']['fuseaction'] = 'hr.list_branches';
	WOStruct['#attributes.fuseaction#']['upd']['filePath'] = 'settings/form/upd_branch.cfm';
	WOStruct['#attributes.fuseaction#']['upd']['queryPath'] = 'settings/query/upd_branch.cfm';
	WOStruct['#attributes.fuseaction#']['upd']['nextEvent'] = 'hr.list_branches&event=upd';
	WOStruct['#attributes.fuseaction#']['upd']['parameters'] = 'id=##attributes.id##';
	WOStruct['#attributes.fuseaction#']['upd']['Identity'] = '##category.branch_name##';
	
	if(not attributes.event is 'add')
	{
		WOStruct['#attributes.fuseaction#']['del'] = structNew();
		WOStruct['#attributes.fuseaction#']['del']['window'] = 'emptypopup';
		WOStruct['#attributes.fuseaction#']['del']['fuseaction'] = 'hr.list_branches';
		WOStruct['#attributes.fuseaction#']['del']['filePath'] = 'settings/query/del_branch.cfm';
		WOStruct['#attributes.fuseaction#']['del']['queryPath'] = 'settings/query/del_branch.cfm';
		WOStruct['#attributes.fuseaction#']['del']['nextEvent'] = 'hr.list_branches';
	}
	
	if(attributes.event is 'upd')
	{
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd'] = structNew();
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'] = structNew();
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][0]['text'] = '#lang_array.item[1728]#';
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][0]['onClick'] = "windowopen('#request.self#?fuseaction=hr.popup_detail_branch&id=#attributes.id#','page');";
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][1]['text'] = '#lang_array.item[1729]#';
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][1]['onClick'] = "windowopen('#request.self#?fuseaction=hr.popup_upd_branch_ssk&id=#attributes.id#&upd_control=1','page');";
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][2]['text'] = '#lang_array_main.item[1399]#';
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][2]['onClick'] = "windowopen('#request.self#?fuseaction=hr.popup_list_period&branch_id=#attributes.id#','medium');";
		
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons'] = structNew();
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['add']['text'] = '#lang_array.item[367]#';
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['add']['href'] = "#request.self#?fuseaction=hr.list_branches&event=add";
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['add']['target'] = "_blank";
		tabMenuData = SerializeJSON(tabMenuStruct['#attributes.fuseaction#']['tabMenus']);
	}
</cfscript>
