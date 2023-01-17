<cf_get_lang_set module_name="settings">
<cfif (isdefined("attributes.event") and (attributes.event is 'list' or attributes.event is 'add')) or not isdefined("attributes.event")>
	<cfquery name="GET_BRANCH" datasource="#dsn#">
        SELECT 
			BRANCH_NAME,
			BRANCH_ID,
			BRANCH_STATUS 
		FROM 
			BRANCH
		WHERE
			1=1
			<cfif not get_module_power_user(3)>
				AND BRANCH_ID IN (SELECT BRANCH_ID FROM EMPLOYEE_POSITION_BRANCHES WHERE POSITION_CODE = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.position_code#">)
			</cfif>
			<cfif ((isdefined("attributes.event") and attributes.event is 'list') or not isdefined("attributes.event")) and isdefined("attributes.company_id") and len(attributes.company_id)>
				AND COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.company_id#">
			</cfif>
		ORDER BY 
			BRANCH_NAME
    </cfquery>
    
    <cfif (isdefined("attributes.event") and attributes.event is 'list') or not isdefined("attributes.event")>
		<cfparam name="attributes.is_active" default=1>
		<cfparam name="attributes.keyword" default=''>
		<cfparam name="attributes.company_id" default="">
		<cfparam name="attributes.branch_id" default="">
		<cfparam name="attributes.up_department_id" default="">
		<cfparam name="attributes.up_department" default="">
		<cfparam name="attributes.is_store" default="">
		<cfparam name="attributes.page" default=1>
		<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
		<cfif isdefined("attributes.form_submitted")>
			<cfquery name="get_depts" datasource="#DSN#">
				SELECT
					D.DEPARTMENT_STATUS,
					D.DEPARTMENT_ID,
					D.HIERARCHY,
					D.HEADQUARTERS_ID,
					D.DEPARTMENT_HEAD,
			        D.LEVEL_NO,
			        D.HIERARCHY_DEP_ID,
			        O.NICK_NAME,
					B.BRANCH_NAME,
					D.IS_STORE,
					ISNULL((SELECT COUNT(DEPARTMENT_ID) AS TOTAL FROM EMPLOYEE_POSITIONS WHERE DEPARTMENT_ID = D.DEPARTMENT_ID GROUP BY DEPARTMENT_ID),0) AS TOTAL
				FROM
					DEPARTMENT D
					INNER JOIN BRANCH B ON D.BRANCH_ID = B.BRANCH_ID
					INNER JOIN OUR_COMPANY O ON B.COMPANY_ID = O.COMP_ID
				WHERE
					<cfif attributes.is_active neq 2>
						D.DEPARTMENT_STATUS = <cfqueryparam cfsqltype="cf_sql_bit" value="#attributes.is_active#">
					</cfif>	
					<cfif len(attributes.keyword) and (len(attributes.keyword) eq 1)>
						AND D.DEPARTMENT_HEAD LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.keyword#%">
					<cfelseif len(attributes.keyword) and (len(attributes.keyword) gt 1)>
						AND D.DEPARTMENT_HEAD LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.keyword#%">
					</cfif>
					<cfif isdefined("attributes.company_id") and len(attributes.company_id)>
						AND O.COMP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.company_id#">
					</cfif>
					<cfif isDefined("attributes.branch_id") and len(attributes.branch_id)>
						AND B.BRANCH_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.branch_id#">
					</cfif>
					<cfif isdefined("attributes.up_department_id") and len(attributes.up_department_id) and isdefined('attributes.up_department') and len(attributes.up_department)>
						AND '.'+D.HIERARCHY_DEP_ID+'.' LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%.#attributes.up_department_id#.%">
					</cfif> 
					<cfif fusebox.circuit eq 'hr' and not get_module_power_user(3)>
						AND B.BRANCH_ID IN (SELECT BRANCH_ID FROM EMPLOYEE_POSITION_BRANCHES WHERE POSITION_CODE = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.position_code#">)
					</cfif>
			        <cfif isDefined("attributes.is_store") and len(attributes.is_store)>
			        	AND D.IS_STORE IN (<cfqueryparam cfsqltype="cf_sql_integer" list="true" value="#attributes.is_store#">)
			        </cfif>
				ORDER BY
					B.BRANCH_NAME,
					D.DEPARTMENT_HEAD
			</cfquery>
		<cfelse>
			<cfset get_depts.recordcount=0>
		</cfif>
		<cfparam name="attributes.totalrecords" default="#get_depts.recordcount#">
		<cfquery name="GET_COMPANY" datasource="#dsn#">
			SELECT COMPANY_NAME,COMP_ID FROM OUR_COMPANY ORDER BY COMPANY_NAME
		</cfquery>
	</cfif>
<cfelseif isdefined("attributes.event") and attributes.event is 'upd'>
	<cf_xml_page_edit fuseact="hr.form_upd_department">
	<cfinclude template="../settings/query/get_dep_emp_count.cfm">
	<cfquery name="CATEGORY" datasource="#dsn#">
		SELECT
			D.ADMIN1_POSITION_CODE,
			D.ADMIN2_POSITION_CODE,
			D.BRANCH_ID,
			D.CHANGE_DATE,
			D.DEPARTMENT_DETAIL,
			D.DEPARTMENT_EMAIL,
			D.DEPARTMENT_HEAD,
			D.DEPARTMENT_ID,
			D.DEPARTMENT_STATUS,
			D.HIERARCHY,
			D.HIERARCHY_DEP_ID,
			D.IS_ORGANIZATION,
			D.IS_PRODUCTION,
			D.IS_STORE,
			D.LEVEL_NO,
			D.RECORD_DATE,
			D.RECORD_EMP,
			D.UPDATE_DATE,
			D.UPDATE_EMP,
			B.BRANCH_NAME,
			ISNULL(D.CHANGE_DATE,(SELECT MAX(CHANGE_DATE) AS CHANGE_DATE FROM DEPARTMENT_HISTORY WHERE DEPARTMENT_ID = D.DEPARTMENT_ID)) AS LAST_CHANGE_DATE,
			EP.EMPLOYEE_NAME + ' ' + EP.EMPLOYEE_SURNAME AS ADMIN1_NAME,
			EP2.EMPLOYEE_NAME + ' ' + EP2.EMPLOYEE_SURNAME AS ADMIN2_NAME
		FROM 
			DEPARTMENT D
			LEFT JOIN BRANCH B ON B.BRANCH_ID = D.BRANCH_ID
			LEFT JOIN EMPLOYEE_POSITIONS EP ON EP.POSITION_CODE = D.ADMIN1_POSITION_CODE AND EP.POSITION_STATUS = 1
			LEFT JOIN EMPLOYEE_POSITIONS EP2 ON EP2.POSITION_CODE = D.ADMIN2_POSITION_CODE AND EP2.POSITION_STATUS = 1
		WHERE 
			D.DEPARTMENT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.id#">
	</cfquery>
    <cfif listlen(category.hierarchy_dep_id,'.') gt 1>
        <cfset up_dep=ListGetAt(category.hierarchy_dep_id,evaluate("#listlen(category.hierarchy_dep_id,".")#-1"),".") >	
        <cfquery name="DEPARTMANS" datasource="#dsn#">
            SELECT 
                DEPARTMENT_HEAD 
            FROM
                DEPARTMENT
            WHERE 
                DEPARTMENT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#up_dep#">
        </cfquery>
        <cfset up_dep_name="#departmans.department_head#">
    <cfelse>
        <cfset up_dep="">
        <cfset up_dep_name="">	
    </cfif>
</cfif>

<script type="text/javascript">
	<cfif (isdefined("attributes.event") and attributes.event is 'list') or not isdefined("attributes.event")>
		$(document).ready(function() {
			document.getElementById('keyword').focus();
		});
		
		function Load_Branch(company_id)
		{
			var option_count_sub = document.getElementById('branch_id').options.length; 
			for(y=option_count_sub;y>=0;y--)
				document.getElementById('branch_id').options[y] = null;
			document.getElementById('branch_id').options.value=0;
			var deger = workdata('get_branch',company_id);
			document.getElementById('branch_id').options[0]=new Option('Şubeler','')
			for(var jj=0;jj<deger.recordcount;jj++)
			{
				if('<cfoutput>#attributes.branch_id#</cfoutput>' == deger.BRANCH_ID[jj])
					var goster=true;
				else 
					var goster=false;	
				document.getElementById('branch_id').options[jj+1]=new Option(deger.BRANCH_NAME[jj],deger.BRANCH_ID[jj],goster,goster);
			}	
		}
	<cfelseif isdefined("attributes.event") and (attributes.event is 'upd' or attributes.event is 'add')>
		function kontrol_et()
		{
			a = $('#branch_id').val();
			if(a=="")
			{
				alert("<cf_get_lang no='1003.Şube Seçmelisiniz'>!");
				return false;
			}
			else
			{
				var is_production_branch = wrk_safe_query("set_is_production_branch","dsn",0,a);
				if(is_production_branch.IS_PRODUCTION == 0 && $('#is_production').is(':checked') == true)
				{
					alert(is_production_branch.BRANCH_NAME + " Şubesinde Üretim Yapılmazken Bağlı Departmanında Üretim Yapılamaz.");
					return false;
				}
			}
			<cfif attributes.event is 'upd'>
				if ($('#department_id').val() == $('#up_department_id').val() && $('#up_department').val() != '')
				{
					alert("Departmanın üst departmanı kendisi olamaz!");
					return false;
				}
				if ($('#x_change_date').val() == 1 && ($('#old_is_store').val() != $('#is_store').val() || $('#old_email').val() != $('#email').val() || $('#old_department_detail').val() != $('#department_Detail').val() || $('#old_level_no').val() != $('#level_no').val()
					|| $('#old_up_department_id').val() != $('#up_department_id').val() || $('#old_department_head').val() != $('#department_head').val() || $('#old_hierarchy').val() != $('#hierarchy').val()))
				{
					if($('#change_date').val() == "")
					{
						alert("Departman bilgilerinde değişiklik yaptınız.Lütfen Değişiklik tarihini giriniz");
						return false;
					}
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
	WOStruct['#attributes.fuseaction#']['list']['fuseaction'] = 'hr.list_depts';
	WOStruct['#attributes.fuseaction#']['list']['filePath'] = 'settings/display/list_depts.cfm';
	
	WOStruct['#attributes.fuseaction#']['add'] = structNew();
	WOStruct['#attributes.fuseaction#']['add']['window'] = 'normal';
	WOStruct['#attributes.fuseaction#']['add']['fuseaction'] = 'hr.list_depts';
	WOStruct['#attributes.fuseaction#']['add']['filePath'] = 'settings/form/add_department.cfm';
	WOStruct['#attributes.fuseaction#']['add']['queryPath'] = 'settings/query/add_department.cfm';
	WOStruct['#attributes.fuseaction#']['add']['nextEvent'] = 'hr.list_depts&event=upd';
	
	WOStruct['#attributes.fuseaction#']['upd'] = structNew();
	WOStruct['#attributes.fuseaction#']['upd']['window'] = 'normal';
	WOStruct['#attributes.fuseaction#']['upd']['fuseaction'] = 'hr.list_depts';
	WOStruct['#attributes.fuseaction#']['upd']['filePath'] = 'settings/form/upd_department.cfm';
	WOStruct['#attributes.fuseaction#']['upd']['queryPath'] = 'settings/query/upd_department.cfm';
	WOStruct['#attributes.fuseaction#']['upd']['nextEvent'] = 'hr.list_depts&event=upd';
	WOStruct['#attributes.fuseaction#']['upd']['parameters'] = 'id=##attributes.id##';
	WOStruct['#attributes.fuseaction#']['upd']['Identity'] = '##category.department_head##';
	
	if(not attributes.event is 'add')
	{
		WOStruct['#attributes.fuseaction#']['del'] = structNew();
		WOStruct['#attributes.fuseaction#']['del']['window'] = 'emptypopup';
		WOStruct['#attributes.fuseaction#']['del']['fuseaction'] = 'hr.list_depts';
		WOStruct['#attributes.fuseaction#']['del']['filePath'] = 'settings/query/del_department.cfm';
		WOStruct['#attributes.fuseaction#']['del']['queryPath'] = 'settings/query/del_department.cfm';
		WOStruct['#attributes.fuseaction#']['del']['nextEvent'] = 'hr.list_depts';
	}
	
	if ((isdefined("attributes.event") and attributes.event is 'list') or not isdefined("attributes.event"))
	{
		attributes.startrow=((attributes.page-1)*attributes.maxrows)+1;
		dep_type = QueryNew("DEP_TYPE_ID, DEP_TYPE_NAME");
	    QueryAddRow(dep_type,3);
		QuerySetCell(dep_type,"DEP_TYPE_ID",1,1);
		QuerySetCell(dep_type,"DEP_TYPE_NAME","#lang_array_main.item[1351]#",1); //depo
		QuerySetCell(dep_type,"DEP_TYPE_ID",2,2);
		QuerySetCell(dep_type,"DEP_TYPE_NAME",'#lang_array_main.item[160]#',2);//departman
		QuerySetCell(dep_type,"DEP_TYPE_ID",3,3);
		QuerySetCell(dep_type,"DEP_TYPE_NAME",'#lang_array_main.item[1351]# ve #lang_array_main.item[160]#',3);//depo ve departman
		url_str = "";
		if (isdefined("attributes.form_submitted"))
			url_str = "#url_str#&form_submitted=#attributes.form_submitted#";
		if (isdefined("attributes.is_store"))
			url_str = "#url_str#&is_store=#attributes.is_store#";
		if (isdefined("attributes.keyword"))
			url_str = "#url_str#&keyword=#attributes.keyword#";
		if (isdefined("attributes.is_active"))
			url_str = "#url_str#&is_active=#attributes.is_active#";
		if (isdefined("attributes.company_id"))
			url_str = "#url_str#&company_id=#attributes.company_id#";
		if (isdefined("attributes.branch_id"))
			url_str = "#url_str#&branch_id=#attributes.branch_id#";
		if (isdefined("attributes.up_department_id"))
			url_str = "#url_str#&up_department_id=#attributes.up_department_id#";
		if (isdefined("attributes.up_department"))
			url_str = "#url_str#&up_department=#attributes.up_department#";
	}
	
	if(attributes.event is 'upd')
	{
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd'] = structNew();
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'] = structNew();
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][0]['text'] = '#lang_array_main.item[61]#';
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][0]['onClick'] = "windowopen('#request.self#?fuseaction=hr.popup_dept_history&dept_id=#attributes.id#&x_change_date=#x_change_date#','wide');";
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][1]['text'] = '#lang_array_main.item[1399]#';
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][1]['onClick'] = "windowopen('#request.self#?fuseaction=hr.popup_list_period&branch_id=#category.branch_id#&department_id=#category.department_id#','medium');";
		
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons'] = structNew();
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['add']['text'] = '#lang_array.item[349]#';
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['add']['href'] = "#request.self#?fuseaction=hr.list_depts&event=add";
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['add']['target'] = "_blank";
		tabMenuData = SerializeJSON(tabMenuStruct['#attributes.fuseaction#']['tabMenus']);
	}
</cfscript>
