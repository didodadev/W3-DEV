<cf_get_lang_set module_name = "prod">
<cfinclude template="../production_plan/query/get_branch.cfm">
<cfinclude template="../production_plan/query/get_money.cfm">
<cfinclude template="../production_plan/query/get_workstation.cfm">
<cfinclude template="../production_plan/query/get_basic_types.cfm">
<cfif not isdefined("attributes.event") or attributes.event is 'list'>
    <cf_xml_page_edit fuseact="prod.list_workstation">
    <cfparam name="attributes.keyword" default="">
    <cfparam name="attributes.is_active" default="1">
    <cfparam name="attributes.branch_id" default="">
    <cfparam name="is_active" default="1">
    <cfparam name="attributes.page" default=1>
    <cfif isdefined("attributes.is_submit")>
        <cfinclude template="../production_plan/query/get_workstation_all.cfm">
    <cfelse>
        <cfset get_workstation_all.recordcount = 0>    
    </cfif>
    <cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
    <cfparam name="attributes.totalrecords" default='#get_workstation_all.recordcount#'>
    <cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
    <cfif not isdefined('attributes.field_id')>
        <cfset send_value = "prod.list_workstation">
    <cfelse>
        <cfset send_value = "prod.popup_list_workstation">
    </cfif>
    <cfset emp_position_list = ''>
    <cfif get_workstation_all.recordcount>
		<cfoutput query="get_workstation_all" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
            <cfif len(emp_id) and not listfind(emp_position_list,emp_id)>
                <cfset emp_position_list = ListAppend(emp_position_list,emp_id)>
            </cfif>
        </cfoutput>
        <cfif len(emp_position_list)>
            <cfset emp_position_list = listsort(emp_position_list,"numeric","ASC",",")>
            <cfquery name="GET_EMPLOYEES" datasource="#dsn#">
                SELECT  EMPLOYEE_ID, EMPLOYEE_NAME, EMPLOYEE_SURNAME FROM EMPLOYEE_POSITIONS WHERE EMPLOYEE_ID IN (#emp_position_list#) AND IS_MASTER = 1 ORDER BY EMPLOYEE_ID
            </cfquery>
            <cfset emp_position_list = listsort(listdeleteduplicates(valuelist(GET_EMPLOYEES.EMPLOYEE_ID,',')),'numeric','ASC',',')>               
        </cfif>
    </cfif>
<cfelseif isdefined("attributes.event") and attributes.event is 'upd'>
    <cfquery name="GET_WORKSTATION_DETAIL" datasource="#DSN3#">
        SELECT 
            W.*,
            C.FULLNAME as FULLNAME2,
            CP.COMPANY_PARTNER_NAME,
            CP.COMPANY_PARTNER_SURNAME,
            EXIT1.COMMENT AS EXIT_COMMENT,
            PRODUCTION.COMMENT AS PROD_COMMENT,
            ENTER.COMMENT AS ENTER_COMMENT,
            (SELECT DEPARTMENT_HEAD FROM #dsn_alias#.DEPARTMENT WHERE DEPARTMENT_ID = W.EXIT_DEP_ID) AS EXIT_DEP,
            (SELECT DEPARTMENT_HEAD FROM #dsn_alias#.DEPARTMENT WHERE DEPARTMENT_ID = W.PRODUCTION_DEP_ID) AS PROD_DEP,
            (SELECT DEPARTMENT_HEAD FROM #dsn_alias#.DEPARTMENT WHERE DEPARTMENT_ID = W.ENTER_DEP_ID) AS ENTER_DEP
        FROM 
            WORKSTATIONS W
            LEFT JOIN #dsn_alias#.STOCKS_LOCATION EXIT1 ON EXIT1.DEPARTMENT_ID= W.EXIT_DEP_ID AND EXIT1.LOCATION_ID = W.EXIT_LOC_ID
            LEFT JOIN #dsn_alias#.STOCKS_LOCATION PRODUCTION ON PRODUCTION.DEPARTMENT_ID= W.PRODUCTION_DEP_ID AND PRODUCTION.LOCATION_ID = W.PRODUCTION_LOC_ID
            LEFT JOIN #dsn_alias#.STOCKS_LOCATION ENTER ON ENTER.DEPARTMENT_ID= W.ENTER_DEP_ID AND ENTER.LOCATION_ID = W.ENTER_LOC_ID
            LEFT JOIN #dsn_alias#.COMPANY_PARTNER CP ON CP.PARTNER_ID = W.OUTSOURCE_PARTNER
            LEFT JOIN #dsn_alias#.COMPANY C ON C.COMPANY_ID = CP.COMPANY_ID
        WHERE 
            STATION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.station_id#">
    </cfquery>
    <cfset attributes.department_id= GET_WORKSTATION_DETAIL.DEPARTMENT>
<cfelseif isdefined("attributes.event") and attributes.event is 'add'>
	<cfquery name="GET_DEPARTMENT" datasource="#DSN#">
        SELECT
            DEPARTMENT_ID,
            BRANCH_ID,
            IS_PRODUCTION,
            DEPARTMENT_HEAD
        FROM
            DEPARTMENT
        WHERE
            BRANCH_ID IS NOT NULL AND
            IS_PRODUCTION = 1
            <cfif isDefined("attributes.branch_id")>
                <cfif attributes.branch_id NEQ 0>
                    AND BRANCH_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.branch_id#">
                </cfif>
            </cfif>
        ORDER BY
            DEPARTMENT_HEAD
    </cfquery>
</cfif>
<script type="text/javascript">
	function add_product(id,name,capacity,emp_id,emp_name)
	{
		window.close();
		<cfif isdefined("attributes.field_name")>
			opener.<cfoutput>#field_name#</cfoutput>.value = name;
		</cfif>
		<cfif isdefined("attributes.field_capacity")>
			opener.<cfoutput>#field_capacity#</cfoutput>.value = capacity;
		</cfif>
		<cfif isdefined("attributes.field_id")>
			opener.<cfoutput>#field_id#</cfoutput>.value = id;
		</cfif>
		<cfif isdefined("attributes.field_employee_id")>
			opener.<cfoutput>#field_employee_id#</cfoutput>.value = emp_id;
		</cfif>
		<cfif isdefined("attributes.emp_name")>
			opener.<cfoutput>#emp_name#</cfoutput>.value = emp_name;
		</cfif>
	}
	function unformat_fields()
		{
			document.add_workstation.energy.value = filterNum(document.add_workstation.energy.value);
			document.add_workstation.cost.value = filterNum(document.add_workstation.cost.value,4);
			document.add_workstation.employee_number.value = filterNum(document.add_workstation.employee_number.value,0);
			document.add_workstation.setting_period_hour.value = filterNum(document.add_workstation.setting_period_hour.value,0);
			document.add_workstation.setting_period_minute.value = filterNum(document.add_workstation.setting_period_minute.value,0);
			document.add_workstation.avg_capacity_day.value = filterNum(document.add_workstation.avg_capacity_day.value,0);
			document.add_workstation.avg_capacity_hour.value = filterNum(document.add_workstation.avg_capacity_hour.value,0);
			<cfif isdefined("attributes.event") and attributes.event is 'upd'>
			document.add_workstation.ws_avg_cost.value = filterNum(document.add_workstation.ws_avg_cost.value);
			</cfif>
	
		}
	function change_comp()
		{
			document.getElementById('comp_id').value = '';
			document.getElementById('comp_name').value = '';
			document.getElementById('partner_id').value = '';	
			document.getElementById('partner_name').value = '';	
		}

	<cfif isdefined("attributes.event") and attributes.event is 'upd'>
		<cfoutput>
		$( document ).ready(function() {
			get_departments('#GET_WORKSTATION_DETAIL.BRANCH#');
			my_moneys=document.add_workstation.COST_MONEY.options.length;
			money=new Array(my_moneys);
			<cfset count=0>
			<cfloop query="get_money">
				<cfset count=count+1>
				money[<cfoutput>#count#</cfoutput>]=<cfoutput>#Evaluate(rate2/rate1)#</cfoutput>;
			</cfloop>
			<cfif len(GET_WORKSTATION_DETAIL.DEPARTMENT)>
				document.getElementById('department_id').value='#GET_WORKSTATION_DETAIL.DEPARTMENT#';	
			</cfif>
		});
		</cfoutput>
		function get_departments(branch_id){
			get_dep=workdata('get_branch_dep',branch_id);
			document.getElementById('department_id').options.length=0;
			document.getElementById('department_id').options[0] = new Option('Departman','');
			if (get_dep.recordcount)
			{
				for(var jj=0;jj<get_dep.recordcount;jj++)
				document.getElementById('department_id').options[jj+1] = new Option(get_dep.DEPARTMENT_HEAD[jj],get_dep.DEPARTMENT_ID[jj]);
			}
		}
	
		function control(){
			if(document.getElementById('cc_emp_ids') == undefined)
			{
				alert("<cf_get_lang no='600.Görevli Seçiniz'>!");
				return false;
			}
			if (document.add_workstation.branch_id_sta.value== 0 || document.add_workstation.department_id.value==0){
				alert("<cf_get_lang no ='601.Sube ve Departmani Eksiksiz Seçiniz'>");	
				return false;
			}
			unformat_fields();
			return true;
		}
	</cfif>
	<cfif isdefined("attributes.event") and attributes.event is 'add'>
		$( document ).ready(function() {
			<cfoutput>
			groups=document.add_workstation.branch_id.options.length;
			group=new Array(groups);
			for (i=0; i<groups; i++)
			group[i]= new Array();
			<cfset sayac = 1>
			<cfloop query="get_branch">
				<cfset attributes.branch_id = branch_id>
				<cfset attributes.names=1>
				<cfquery name="GET_DEPARTMENT_ROW" dbtype="query">
					SELECT
						*
					FROM
						GET_DEPARTMENT
					WHERE
						BRANCH_ID IS NOT NULL AND
						IS_PRODUCTION = 1
						<cfif isDefined("attributes.branch_id")>
							<cfif attributes.branch_id NEQ 0>
						AND
							BRANCH_ID = #attributes.branch_id#
							</cfif>
						</cfif>
					ORDER BY
						DEPARTMENT_HEAD
				</cfquery> 
				group[#sayac#][0]=new Option("Seçiniz","0");
					<cfloop query="get_department_row">
						  <cfif isDefined("attributes.department_id")>
							<cfif attributes.department_id eq department_id>
								<cfset id = currentrow>
							</cfif>
						  </cfif>
						group[#sayac#][#currentrow#]=new Option("#department_head#","#department_id#");
					</cfloop>
				<cfset sayac = sayac + 1>
			</cfloop>
			</cfoutput>
			<cfif isDefined("attributes.department_id")>
				<cfoutput>
					document.add_workstation.branch_id.selectedIndex = #cat_id#;
					redirect(#cat_id#);
					document.add_workstation.department_id.selectedIndex = #id#;
				</cfoutput>
			</cfif>
		});
		function redirect(x)
		{
			for (m=document.add_workstation.department_id.options.length-1;m>0;m--)
				document.add_workstation.department_id.options[m]=null;
			for (i=0;i<group[x].length;i++)
			{
				document.add_workstation.department_id.options[i]=new Option(group[x][i].text,group[x][i].value);
			}
			document.add_workstation.department_id.options[0].selected=true;
		}

		function control()
		{
			if(document.add_workstation.station_name.value=='')
			{
				alert("<cf_get_lang_main no='782.Zorunlu Alan'> : <cf_get_lang_main no='1422.İstasyon'>");
				return false;
			}
			if (document.add_workstation.branch_id.value== 0 || document.add_workstation.department_id.value==0)
			{
				alert("<cf_get_lang_main no='782.Zorunlu Alan'> : <cf_get_lang_main no='41.Şube'> <cf_get_lang_main no='577.ve'> <cf_get_lang_main no='160.Departman'>");	
				return false;
			}
			if ((document.add_workstation.comment.value.length) > 250)
			{
				alert("<cf_get_lang no='331.En Fazla 250 Karakter Açıklama Girebilirsiniz'>.");	
				return false;
			}
			if(isNaN(document.add_workstation.length.value))
			{
				alert("<cf_get_lang no='332.Hatalı Veri Girişi : En / Boy / Yükseklik'> ");
				return false;
			}
		if(document.getElementById('cc_emp_ids') == undefined)
			{
				alert("<cf_get_lang_main no='782.Zorunlu Alan'> : <cf_get_lang_main no='157.Görevli'>");
				return false;
			}
			unformat_fields();
			return true;
		}
	</cfif>
</script>
<cfscript>
	// Switch //
	WOStruct = StructNew();
	WOStruct['#attributes.fuseaction#'] = structNew();
	WOStruct['#attributes.fuseaction#']['default'] = 'list';
	if(not isdefined('attributes.event'))
		attributes.event = WOStruct['#attributes.fuseaction#']['default'];
	
	WOStruct['#attributes.fuseaction#']['list'] = structNew();
	WOStruct['#attributes.fuseaction#']['list']['window'] = 'normal';
	WOStruct['#attributes.fuseaction#']['list']['fuseaction'] = 'prod.list_workstation';
	WOStruct['#attributes.fuseaction#']['list']['filePath'] = 'production_plan/display/list_workstation.cfm';
	
	WOStruct['#attributes.fuseaction#']['upd'] = structNew();
	WOStruct['#attributes.fuseaction#']['upd']['window'] = 'normal';
	WOStruct['#attributes.fuseaction#']['upd']['fuseaction'] = 'prod.list_workstation';
	WOStruct['#attributes.fuseaction#']['upd']['filePath'] = 'production_plan/display/upd_workstation.cfm';
	WOStruct['#attributes.fuseaction#']['upd']['queryPath'] = 'production_plan/query/upd_workstation.cfm';
	WOStruct['#attributes.fuseaction#']['upd']['nextEvent'] = 'prod.list_workstation&event=upd';
	WOStruct['#attributes.fuseaction#']['upd']['parameters'] = 'station_id=##attributes.station_id##';
	WOStruct['#attributes.fuseaction#']['upd']['Identity'] = '##attributes.station_id##';
	
	WOStruct['#attributes.fuseaction#']['add'] = structNew();
	WOStruct['#attributes.fuseaction#']['add']['window'] = 'popup';
	WOStruct['#attributes.fuseaction#']['add']['fuseaction'] = 'prod.list_workstation';
	WOStruct['#attributes.fuseaction#']['add']['filePath'] = 'production_plan/display/add_workstation.cfm';
	WOStruct['#attributes.fuseaction#']['add']['queryPath'] = 'production_plan/query/add_workstation.cfm';
	WOStruct['#attributes.fuseaction#']['add']['nextEvent'] = 'prod.list_workstation&event=upd';

	
	if(attributes.event is 'upd')       
	{
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd'] = structNew();
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'] = structNew();
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][0]['text'] = '#lang_array.item[1]#';
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][0]['onClick'] = "windowopen('#request.self#?fuseaction=prod.popup_list_product_workstations&station_id=#attributes.station_id#&station_name=#GET_WORKSTATION_DETAIL.STATION_NAME#','list');";
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][1]['text'] = '#lang_array.item[339]#';
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][1]['onClick'] = "windowopen('#request.self#?fuseaction=prod.popup_list_workstation_orders&station_id=#attributes.station_id#','page')";
		
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons'] = structNew();
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['add']['text'] = '#lang_array_main.item[170]#';
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['add']['onClick'] = "windowopen('#request.self#?fuseaction=prod.list_workstation&event=add','wide')";
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['extra']['text'] = 'Oklar';
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['extra']['customTag'] = '<cf_np tablename="WORKSTATIONS" primary_key = "STATION_ID" pointer="STATION_ID=#attributes.station_id#,event=upd" dsn_var="DSN3" ekstraUrlParams="event=upd">';
		tabMenuData = SerializeJSON(tabMenuStruct['#attributes.fuseaction#']['tabMenus']);
	}
	
	WOStruct['#attributes.fuseaction#']['extendedForm'] = structNew();
	WOStruct['#attributes.fuseaction#']['extendedForm']['controllerFileName'] = 'prodListWorkstation';
	WOStruct['#attributes.fuseaction#']['extendedForm']['eventList'] = 'add,upd';
	WOStruct['#attributes.fuseaction#']['extendedForm']['tableName'] = 'WORKSTATIONS';
	WOStruct['#attributes.fuseaction#']['extendedForm']['dataSourceName'] = 'company';
	WOStruct['#attributes.fuseaction#']['extendedForm']['settings'] = "['item-station_name','item-branch_id','item-department_id','item-cost','item-energy']"; // Bu atama yapılmazsa sayfada her alan değiştirilebilir olur.
</cfscript>
