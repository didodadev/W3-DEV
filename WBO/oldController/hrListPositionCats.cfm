<cfif (isdefined("attributes.event") and attributes.event is 'list') or not isdefined("attributes.event")>
	<cfparam name="attributes.position_cat_status" default="1">
	<cfparam name="attributes.keyword" default="">
	<cfparam name="attributes.is_submit" default="">
	<cfparam name="attributes.page" default=1>
	<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
	
	<cfscript>
		attributes.startrow = ((attributes.page - 1) * attributes.maxrows) + 1;
		if (fuseaction contains "popup")
			is_popup = 1;
		else
			is_popup = 0;
			
		if (isdefined("attributes.is_submit"))
		{
			cmp_pos_cat = createObject("component","hr.cfc.get_position_cat");
			cmp_pos_cat.dsn = dsn;
			positioncategories = cmp_pos_cat.get_position_cat(
				position_cat_status: attributes.position_cat_status,
				position_cat: attributes.keyword,
				maxrows: attributes.maxrows,
				startrow: attributes.startrow
			);
		}
		else
			positioncategories.query_count = 0;
		
		url_str = "";
		if (isdefined('attributes.is_submit') and len (attributes.is_submit))
			url_str = "#url_str#&is_submit=#attributes.is_submit#";
		if (len(attributes.keyword))
			url_str = "#url_str#&keyword=#attributes.keyword#";
		if (len(attributes.position_cat_status))
			url_str = "#url_str#&position_cat_status=#attributes.position_cat_status#";
		if (len(attributes.is_submit))
			url_str = "#url_str#&is_submit=#attributes.is_submit#";
	</cfscript>
	<cfparam name="attributes.totalrecords" default="#positioncategories.query_count#">
<cfelseif isdefined("attributes.event") and listfind('add,upd',attributes.event)>
	<cfinclude template="../hr/query/get_titles.cfm">
	<cfquery name="GET_ORGANIZATION_STEPS" datasource="#DSN#">
		SELECT 
			ORGANIZATION_STEP_ID,
			ORGANIZATION_STEP_NAME
		FROM
			SETUP_ORGANIZATION_STEPS
		ORDER BY
			ORGANIZATION_STEP_NAME
	</cfquery>
	<cfquery name="GET_UNITS" datasource="#DSN#">
		SELECT UNIT_ID,UNIT_NAME FROM SETUP_CV_UNIT WHERE IS_ACTIVE = 1 ORDER BY UNIT_NAME
	</cfquery>
	<cfif attributes.event is 'upd'>
		<cf_get_lang_set module_name="hr">
		<cfquery name="CATEGORIES" datasource="#dsn#">
            SELECT
            	SPC.POSITION_CAT_STATUS,
            	SPC.POSITION_CAT,
            	SPC.POSITION_CAT_DETAIL,
            	SPC.HIERARCHY,
            	SPC.POSITION_CAT_UPPER_TYPE,
            	SPC.POSITION_CAT_TYPE,
            	SPC.PERF_STATUS,
            	SPC.TITLE_ID,
            	SPC.ORGANIZATION_STEP_ID,
            	SPC.COLLAR_TYPE,
            	SPC.FUNC_ID,
            	SPC.BUSINESS_CODE_ID,
            	SBC.BUSINESS_CODE_NAME,
            	SBC.BUSINESS_CODE
            FROM 
            	SETUP_POSITION_CAT SPC
            	LEFT JOIN SETUP_BUSINESS_CODES SBC ON SPC.BUSINESS_CODE_ID = SBC.BUSINESS_CODE_ID
            WHERE 
            	SPC.POSITION_CAT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.position_id#">
        </cfquery>
        <cfset attributes.position_cat_id = attributes.position_id>
        <cfinclude template="../hr/query/get_positioncat_content.cfm">
	</cfif>
<cfelseif isdefined("attributes.event") and attributes.event is 'pos_cat_norm'>
	<cfquery name="get_position_cat_norm" datasource="#dsn#">
		SELECT
			B.BRANCH_NAME,
			D.DEPARTMENT_HEAD,
			D.DEPARTMENT_ID,
			SUM(EMPLOYEE_COUNT1) AS EMPLOYEE_COUNT1,
			SUM(EMPLOYEE_COUNT2) AS EMPLOYEE_COUNT2,
			SUM(EMPLOYEE_COUNT3) AS EMPLOYEE_COUNT3,
			SUM(EMPLOYEE_COUNT4) AS EMPLOYEE_COUNT4,
			SUM(EMPLOYEE_COUNT5) AS EMPLOYEE_COUNT5,
			SUM(EMPLOYEE_COUNT6) AS EMPLOYEE_COUNT6,
			SUM(EMPLOYEE_COUNT7) AS EMPLOYEE_COUNT7,
			SUM(EMPLOYEE_COUNT8) AS EMPLOYEE_COUNT8,
			SUM(EMPLOYEE_COUNT9) AS EMPLOYEE_COUNT9,
			SUM(EMPLOYEE_COUNT10) AS EMPLOYEE_COUNT10,
			SUM(EMPLOYEE_COUNT11) AS EMPLOYEE_COUNT11,
			SUM(EMPLOYEE_COUNT12) AS EMPLOYEE_COUNT12
		FROM
			EMPLOYEE_NORM_POSITIONS ENP
			INNER JOIN DEPARTMENT D ON D.DEPARTMENT_ID = ENP.DEPARTMENT_ID
			INNER JOIN BRANCH B ON B.BRANCH_ID = D.BRANCH_ID
		WHERE
			ENP.POSITION_CAT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.position_cat_id#">
		GROUP BY 
			D.DEPARTMENT_ID,D.DEPARTMENT_HEAD,B.BRANCH_NAME
		ORDER BY B.BRANCH_NAME
	</cfquery>
	<cfset department_id_list = valuelist(get_position_cat_norm.department_id)>
	<cfquery name="get_all_depts" datasource="#dsn#">
		SELECT POSITION_CAT_ID,DEPARTMENT_ID,EMPLOYEE_ID FROM EMPLOYEE_POSITIONS WHERE POSITION_CAT_ID = #ATTRIBUTES.POSITION_CAT_ID# AND POSITION_STATUS = 1 <cfif listlen(department_id_list)>AND DEPARTMENT_ID IN (#department_id_list#)<cfelse>AND DEPARTMENT_ID IS NULL</cfif>
	</cfquery>
<cfelseif isdefined("attributes.event") and attributes.event is 'add_emp_career'>
	<cfquery datasource="#dsn#" name="get_alt_pos_cat">
		SELECT 
			EC.RELATED_POS_CAT_ID AS CAT_ID,
			EC.STEP_NO AS STEP_NO,
			SPC.POSITION_CAT AS POSITION_NAME
		FROM
			EMPLOYEE_CAREER EC
			INNER JOIN SETUP_POSITION_CAT SPC ON SPC.POSITION_CAT_ID=EC.RELATED_POS_CAT_ID
		WHERE
			EC.POSITION_CAT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.position_cat_id#">
			AND STATE=0
		ORDER BY STEP_NO
	</cfquery>
	<cfquery datasource="#dsn#" name="get_ust_pos_cat">
		SELECT 
			EC.RELATED_POS_CAT_ID AS CAT_ID,
			EC.STEP_NO AS STEP_NO,
			SPC.POSITION_CAT AS POSITION_NAME
		FROM
			EMPLOYEE_CAREER EC
			INNER JOIN SETUP_POSITION_CAT SPC ON SPC.POSITION_CAT_ID=EC.RELATED_POS_CAT_ID
		WHERE
			EC.POSITION_CAT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.position_cat_id#">
			AND STATE=1
		ORDER BY STEP_NO
	</cfquery>
	<cfquery name="get_position_cat_name" datasource="#dsn#">
        SELECT 
            POSITION_CAT 
        FROM
            SETUP_POSITION_CAT
        WHERE
            POSITION_CAT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.position_cat_id#">
    </cfquery>
<cfelseif isdefined("attributes.event") and attributes.event is 'add_pos_cat_req'>
	<cfquery name="GET_POS_CAT_REQ" datasource="#DSN#">
		SELECT 
			* 
		FROM 
			POSITION_REQUIREMENTS 
		WHERE 
			POSITION_CAT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.position_cat_id#">
	</cfquery>
	<cfset old_requirements = valuelist(get_pos_cat_req.req_type_id)>
</cfif>

<script type="text/javascript">
	<cfif isdefined("attributes.event") and attributes.event is 'add_pos_cat_req'>
		row_count=0;
		function kontrol_et()
		{
			if(row_count ==0)
				return false;
			else
				return true;
		}
	
		function add_row()
		{
			row_count++;
			var newRow;
			var newCell;
			newRow = document.getElementById("table1").insertRow(document.getElementById("table1").rows.length);
			document.add_position_cat_requirement.record_num.value=row_count;			
			
			newCell = newRow.insertCell(newRow.cells.length);
			newCell.innerHTML = '<input type="hidden" name="req_type_id_' + row_count + '"><input type="text" name="req_type_' + row_count + '" id="req_type' + row_count + '" style="width:170px;"  class="formfieldright"><a onclick="javascript:opage(' + row_count +');"><img src="/images/plus_list.gif" border="0" align="absmiddle" style="cursor:pointer;"></a>';

			newCell = newRow.insertCell(newRow.cells.length);
			newCell.innerHTML = '<input type="text" name="coefficient_' + row_count + '" id="coefficient' + row_count + '" style="width:50px;"   value="" class="formfieldright">';
		
			newCell = newRow.insertCell(newRow.cells.length);
			newCell.innerHTML = '';
		}		
	
		function opage(deger)
		{
			windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=hr.popup_list_pos_req_types&field_id=add_pos_requirement.req_type_id_' + deger + '&field_name=add_pos_requirement.req_type_' + deger,'list');
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
	WOStruct['#attributes.fuseaction#']['list']['fuseaction'] = 'hr.list_position_cats';
	WOStruct['#attributes.fuseaction#']['list']['filePath'] = 'hr/display/list_position_cat.cfm';
	
	WOStruct['#attributes.fuseaction#']['add'] = structNew();
	WOStruct['#attributes.fuseaction#']['add']['window'] = 'normal';
	WOStruct['#attributes.fuseaction#']['add']['fuseaction'] = 'hr.form_add_position_cat';
	WOStruct['#attributes.fuseaction#']['add']['filePath'] = 'hr/form/add_position_cat.cfm';
	WOStruct['#attributes.fuseaction#']['add']['queryPath'] = 'hr/query/add_position_cat.cfm';
	WOStruct['#attributes.fuseaction#']['add']['nextEvent'] = 'hr.list_position_cats&event=add';
	
	WOStruct['#attributes.fuseaction#']['upd'] = structNew();
	WOStruct['#attributes.fuseaction#']['upd']['window'] = 'normal';
	WOStruct['#attributes.fuseaction#']['upd']['fuseaction'] = 'hr.form_upd_position_cat';
	WOStruct['#attributes.fuseaction#']['upd']['filePath'] = 'hr/form/upd_position_cat.cfm';
	WOStruct['#attributes.fuseaction#']['upd']['queryPath'] = 'hr/query/upd_position_cat.cfm';
	WOStruct['#attributes.fuseaction#']['upd']['nextEvent'] = 'hr.list_position_cats&event=upd';
	WOStruct['#attributes.fuseaction#']['upd']['parameters'] = 'position_id=##attributes.position_id##';
	WOStruct['#attributes.fuseaction#']['upd']['Identity'] = '##attributes.position_id##';
	
	WOStruct['#attributes.fuseaction#']['pos_cat_norm'] = structNew();
	WOStruct['#attributes.fuseaction#']['pos_cat_norm']['window'] = 'popup';
	WOStruct['#attributes.fuseaction#']['pos_cat_norm']['fuseaction'] = 'hr.popup_list_position_cat_norms';
	WOStruct['#attributes.fuseaction#']['pos_cat_norm']['filePath'] = 'hr/display/dsp_norm_position_cat.cfm';
	WOStruct['#attributes.fuseaction#']['pos_cat_norm']['Identity'] = '##lang_array.item[1578]##';
	
	WOStruct['#attributes.fuseaction#']['add_emp_career'] = structNew();
	WOStruct['#attributes.fuseaction#']['add_emp_career']['window'] = 'popup';
	WOStruct['#attributes.fuseaction#']['add_emp_career']['fuseaction'] = 'hr.popup_add_employee_career';
	WOStruct['#attributes.fuseaction#']['add_emp_career']['filePath'] = 'hr/form/add_employee_career.cfm';
	WOStruct['#attributes.fuseaction#']['add_emp_career']['parameters'] = 'position_cat_id=##attributes.position_cat_id##';
	WOStruct['#attributes.fuseaction#']['add_emp_career']['Identity'] = '##lang_array.item[891]##';
	
	WOStruct['#attributes.fuseaction#']['add_pos_cat_req'] = structNew();
	WOStruct['#attributes.fuseaction#']['add_pos_cat_req']['window'] = 'popup';
	WOStruct['#attributes.fuseaction#']['add_pos_cat_req']['fuseaction'] = 'hr.popup_add_position_cat_requirements';
	WOStruct['#attributes.fuseaction#']['add_pos_cat_req']['filePath'] = 'hr/form/add_position_cat_requirements.cfm';
	WOStruct['#attributes.fuseaction#']['add_pos_cat_req']['queryPath'] = 'hr/query/add_position_cat_requirements.cfm';
	WOStruct['#attributes.fuseaction#']['add_pos_cat_req']['parameters'] = 'position_cat_id=##attributes.position_cat_id##';
	WOStruct['#attributes.fuseaction#']['add_pos_cat_req']['nextEvent'] = 'hr.list_position_cats&event=upd';
	WOStruct['#attributes.fuseaction#']['add_pos_cat_req']['Identity'] = '##lang_array.item[894]##';
	
	if(not attributes.event is 'add')
	{
		WOStruct['#attributes.fuseaction#']['del_career'] = structNew();
		WOStruct['#attributes.fuseaction#']['del_career']['window'] = 'emptypopup';
		WOStruct['#attributes.fuseaction#']['del_career']['fuseaction'] = 'hr.emptypopup_del_employee_career';
		WOStruct['#attributes.fuseaction#']['del_career']['filePath'] = 'hr/query/del_employee_career.cfm';
		WOStruct['#attributes.fuseaction#']['del_career']['queryPath'] = 'hr/query/del_employee_career.cfm';
		WOStruct['#attributes.fuseaction#']['del_career']['nextEvent'] = 'hr.list_position_cats';
		
		WOStruct['#attributes.fuseaction#']['del_pos_req'] = structNew();
		WOStruct['#attributes.fuseaction#']['del_pos_req']['window'] = 'emptypopup';
		WOStruct['#attributes.fuseaction#']['del_pos_req']['fuseaction'] = 'hr.emptypopup_del_pos_req';
		WOStruct['#attributes.fuseaction#']['del_pos_req']['filePath'] = 'hr/query/del_position_requirement.cfm';
		WOStruct['#attributes.fuseaction#']['del_pos_req']['queryPath'] = 'hr/query/del_position_requirement.cfm';
		WOStruct['#attributes.fuseaction#']['del_pos_req']['nextEvent'] = 'hr.list_position_cats';
	}
	
	if(attributes.event is 'upd')
	{
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd'] = structNew();
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'] = structNew();
		i = 0;
		if (not listfindnocase(denied_pages,'hr.popup_list_position_cat_norms'))
		{
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][i]['text'] = '#lang_array.item[126]#';
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][i]['onClick'] = "windowopen('#request.self#?fuseaction=hr.list_position_cats&event=pos_cat_norm&position_cat_id=#attributes.position_id#','horizantal');";
			i = i + 1;
		}
		if (not listfindnocase(denied_pages,'hr.popup_list_employee_career'))
		{
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][i]['text'] = '#lang_array.item[891]#';
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][i]['onClick'] = "windowopen('#request.self#?fuseaction=hr.list_position_cats&event=add_emp_career&position_cat_id=#attributes.position_id#','large');";
			i = i + 1;
		}
		if (not listfindnocase(denied_pages,'hr.popup_add_position_cat_requirements'))
		{
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][i]['text'] = '#lang_array.item[894]#';
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][i]['onClick'] = "windowopen('#request.self#?fuseaction=hr.list_position_cats&event=add_pos_cat_req&position_cat_id=#attributes.position_id#','large');";
			i = i + 1;
		}
		if (not listfindnocase(denied_pages,'hr.popup_form_add_position_content'))
		{
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][i]['text'] = '#lang_array.item[141]#';
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][i]['onClick'] = "windowopen('#request.self#?fuseaction=hr.popup_form_add_position_content&position_cat_id=#attributes.position_id#','large');";
		}
		
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons'] = structNew();
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['add']['text'] = '#lang_array.item[54]#';
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['add']['href'] = "#request.self#?fuseaction=hr.list_position_cats&event=add";
		tabMenuData = SerializeJSON(tabMenuStruct['#attributes.fuseaction#']['tabMenus']);
	}
	
	WOStruct['#attributes.fuseaction#']['extendedForm'] = structNew();
	WOStruct['#attributes.fuseaction#']['extendedForm']['controllerFileName'] = 'hrListPositionCats';
	WOStruct['#attributes.fuseaction#']['extendedForm']['eventList'] = 'add,upd';
	WOStruct['#attributes.fuseaction#']['extendedForm']['tableName'] = 'SETUP_POSITION_CAT';
	WOStruct['#attributes.fuseaction#']['extendedForm']['dataSourceName'] = 'main';
	WOStruct['#attributes.fuseaction#']['extendedForm']['settings'] = "['item-position_cat']"; // Bu atama yapılmazsa sayfada her alan değiştirilebilir olur.
</cfscript>
