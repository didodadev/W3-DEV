<cf_get_lang_set module_name="ch">
<cf_papers paper_type="virman">
<cf_xml_page_edit fuseact="ch.form_collacted_cari_virman">
<cfparam name="attributes.money_type_control" default="">
<cfparam name="attributes.currency_id_info" default="">
<cfset to_branch_id = ''>
<cfset select_input = 'action_currency_id'>
<cfset row_count = 0>

<cfif isDefined("attributes.upd_id")>
    <cfquery name="GET_MONEY" datasource="#DSN2#">
        SELECT
            MONEY_TYPE MONEY,
            RATE2,
            RATE1,
            ISNULL(IS_SELECTED,0)
        FROM
            CARI_ACTION_MULTI_MONEY
        WHERE
        	ACTION_ID = #attributes.upd_id#
        ORDER BY 
            MONEY_TYPE
    </cfquery>
    <cfquery name="get_action_detail" datasource="#dsn2#">
        SELECT * FROM CARI_ACTIONS_MULTI WHERE MULTI_ACTION_ID = #attributes.upd_id# AND ACTION_TYPE_ID = 430
    </cfquery>
<cfelse>
    <cfquery name="GET_MONEY" datasource="#DSN#">
        SELECT
            MONEY,
            RATE2,
            RATE1,
            0 AS IS_SELECTED
        FROM
            SETUP_MONEY
        WHERE
            PERIOD_ID = #SESSION.EP.PERIOD_ID# AND
            MONEY_STATUS = 1
            <cfif isDefined('attributes.money') and len(attributes.money)>
                AND MONEY_ID = #attributes.money#
            </cfif>
        ORDER BY 
            MONEY_ID
    </cfquery>
</cfif>
<cfquery name="get_branches" datasource="#dsn#">
	SELECT * FROM BRANCH WHERE BRANCH_STATUS = 1 AND COMPANY_ID=#session.ep.company_id#
</cfquery>
 <cfif (isDefined('attributes.upd_id') and len(attributes.upd_id)) or (isDefined('attributes._copy_id') and len(attributes._copy_id))>
	<cfif isDefined('attributes.upd_id')>
        <cfset multi_id = attributes.upd_id>
    <cfelseif isDefined('attributes._copy_id')>
        <cfset multi_id = attributes._copy_id>
    </cfif>
    <cfquery name="get_multi" datasource="#dsn2#">
        SELECT * FROM CARI_ACTIONS_MULTI WHERE MULTI_ACTION_ID = #multi_id#
    </cfquery>
    <cfquery name="get_rows" datasource="#dsn2#">
        SELECT
            CA.ACTION_VALUE,
            CA.ACTION_CURRENCY_ID,
            CA.OTHER_CASH_ACT_VALUE,
            CA.OTHER_MONEY,
            CA.ACTION_DATE,
            CA.ACTION_DETAIL,
            CA.PAPER_NO,
            ISNULL(C.FULLNAME,ISNULL(CNS.CONSUMER_NAME + ' ' + CNS.CONSUMER_SURNAME,EMP.EMPLOYEE_NAME + ' ' + EMP.EMPLOYEE_SURNAME + ' - ' + TO_SAT.ACC_TYPE_NAME)) TO_COMP_NAME,
            ISNULL(C2.FULLNAME,ISNULL(CNS2.CONSUMER_NAME + ' ' + CNS2.CONSUMER_SURNAME,EMP2.EMPLOYEE_NAME + ' ' + EMP2.EMPLOYEE_SURNAME + ' - ' +FROM_SAT.ACC_TYPE_NAME)) FROM_COMP_NAME,
            CA.FROM_BRANCH_ID,
            CA.TO_BRANCH_ID,
            FROM_AP.ASSETP FROM_ASSET_NAME,
            TO_AP.ASSETP TO_ASSET_NAME,
            FROM_PR.PROJECT_HEAD FROM_PROJECT_HEAD,
            TO_PR.PROJECT_HEAD TO_PROJECT_HEAD,
            CA.TO_CMP_ID,
            CA.FROM_CMP_ID,
            CA.TO_CONSUMER_ID,
            CA.FROM_CONSUMER_ID,
            CA.TO_EMPLOYEE_ID,
            CA.FROM_EMPLOYEE_ID,
            CA.ASSETP_ID,
            CA.ASSETP_ID_2,
            CA.PROJECT_ID FROM_PROJECT_ID,
            CA.PROJECT_ID_2 TO_PROJECT_ID
        FROM
            CARI_ACTIONS CA
            LEFT JOIN #dsn_alias#.COMPANY C ON CA.TO_CMP_ID = C.COMPANY_ID
            LEFT JOIN #dsn_alias#.COMPANY C2 ON CA.FROM_CMP_ID = C2.COMPANY_ID
            LEFT JOIN #dsn_alias#.CONSUMER CNS ON CA.TO_CONSUMER_ID = CNS.CONSUMER_ID
            LEFT JOIN #dsn_alias#.CONSUMER CNS2 ON CA.FROM_CONSUMER_ID = CNS2.CONSUMER_ID
            LEFT JOIN #dsn_alias#.EMPLOYEES EMP ON CA.TO_EMPLOYEE_ID = EMP.EMPLOYEE_ID
            LEFT JOIN #dsn_alias#.EMPLOYEES EMP2 ON CA.FROM_EMPLOYEE_ID = EMP2.EMPLOYEE_ID
            LEFT JOIN #dsn_alias#.ASSET_P FROM_AP ON CA.ASSETP_ID = FROM_AP.ASSETP_ID
            LEFT JOIN #dsn_alias#.ASSET_P TO_AP ON CA.ASSETP_ID_2 = TO_AP.ASSETP_ID
            LEFT JOIN #dsn_alias#.PRO_PROJECTS FROM_PR ON CA.PROJECT_ID = FROM_PR.PROJECT_ID
            LEFT JOIN #dsn_alias#.PRO_PROJECTS TO_PR ON CA.PROJECT_ID_2 = TO_PR.PROJECT_ID
            LEFT JOIN #dsn_alias#.SETUP_ACC_TYPE FROM_SAT ON CA.FROM_ACC_TYPE_ID = FROM_SAT.ACC_TYPE_ID
            LEFT JOIN #dsn_alias#.SETUP_ACC_TYPE TO_SAT ON CA.ACC_TYPE_ID = TO_SAT.ACC_TYPE_ID
        WHERE
            MULTI_ACTION_ID = #multi_id#
    </cfquery>
    <cfset row_count = get_rows.recordcount>
</cfif>
<cfscript>
	// Switch //
	WOStruct = StructNew();
	WOStruct['#attributes.fuseaction#'] = structNew();
	
	
	WOStruct['#attributes.fuseaction#']['default'] = 'add';
	if(not isdefined('attributes.event'))
		attributes.event = WOStruct['#attributes.fuseaction#']['default'];
	
	WOStruct['#attributes.fuseaction#']['add'] = structNew();
	WOStruct['#attributes.fuseaction#']['add']['window'] = 'normal';
	WOStruct['#attributes.fuseaction#']['add']['fuseaction'] = 'ch.form_collacted_cari_virman';
	WOStruct['#attributes.fuseaction#']['add']['filePath'] = 'ch/form/add_collacted_cari_virman.cfm';
	WOStruct['#attributes.fuseaction#']['add']['queryPath'] = 'ch/query/add_collacted_virman.cfm';
	WOStruct['#attributes.fuseaction#']['add']['nextEvent'] = 'ch.form_collacted_cari_virman&event=upd';
	
	WOStruct['#attributes.fuseaction#']['upd'] = structNew();
	WOStruct['#attributes.fuseaction#']['upd']['window'] = 'normal';
	WOStruct['#attributes.fuseaction#']['upd']['fuseaction'] = 'ch.form_collacted_cari_virman';
	WOStruct['#attributes.fuseaction#']['upd']['filePath'] = 'ch/form/add_collacted_cari_virman.cfm';
	WOStruct['#attributes.fuseaction#']['upd']['queryPath'] = 'ch/query/add_collacted_virman.cfm';
	WOStruct['#attributes.fuseaction#']['upd']['nextEvent'] = 'ch.form_collacted_cari_virman&event=upd';
	WOStruct['#attributes.fuseaction#']['upd']['parameters'] = 'upd_id=##attributes.upd_id##';
	WOStruct['#attributes.fuseaction#']['upd']['Identity'] = '##attributes.upd_id##';
	
	if(IsDefined("attributes.event") && (attributes.event is 'upd' || attributes.event is 'del'))
	{
		WOStruct['#attributes.fuseaction#']['del'] = structNew();
		WOStruct['#attributes.fuseaction#']['del']['window'] = 'emptypopup';
		WOStruct['#attributes.fuseaction#']['del']['fuseaction'] = 'ch.form_collacted_cari_virman';
		WOStruct['#attributes.fuseaction#']['del']['filePath'] = 'ch/query/add_collacted_virman.cfm';
		WOStruct['#attributes.fuseaction#']['del']['queryPath'] = 'ch/query/add_collacted_virman.cfm';
		WOStruct['#attributes.fuseaction#']['del']['nextEvent'] = 'ch.form_collacted_cari_virman';
		WOStruct['#attributes.fuseaction#']['del']['parameters'] = 'del_id=##attributes.upd_id##';
		WOStruct['#attributes.fuseaction#']['del']['parameters'] = 'active_period=##session.ep.period_id##';
		WOStruct['#attributes.fuseaction#']['del']['Identity'] = '##attributes.upd_id##';
	}
	
	if( IsDefined("attributes.event") && attributes.event is 'add')
	{
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['add'] = structNew();
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['add']['menus'] = structNew();
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['add']['menus'][0]['text'] = '#lang_array_main.item[1114]#';
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['add']['menus'][0]['onClick'] = "openBox('#request.self#?fuseaction=objects.popup_add_collacted_from_file&type=2',this)";
		tabMenuData = SerializeJSON(tabMenuStruct['#attributes.fuseaction#']['tabMenus']);
	}
	
	if(IsDefined("attributes.event") && attributes.event is 'upd')
	{
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd'] = structNew();
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'] = structNew();
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][0]['text'] = '#lang_array_main.item[1114]#';
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][0]['onClick'] = "openBox('#request.self#?fuseaction=objects.popup_add_collacted_from_file&type=2',this)";
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][1]['text'] = '#lang_array_main.item[1966]#';
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][1]['customTag'] = '<cf_get_workcube_related_acts period_id="#session.ep.period_id#" company_id="#session.ep.company_id#" asset_cat_id="-17" module_id="23" action_section="MULTI_ACTION_ID" action_id="#attributes.upd_id#">';
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][2]['text'] = '#lang_array_main.item[1040]#';
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][2]['onClick'] = "windowopen('#request.self#?fuseaction=account.popup_list_card_rows&action_id=#attributes.upd_id#&process_cat=430','page_horizantal','add_process')";
		
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons'] = structNew();
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['add']['text'] = '#lang_array_main.item[170]#';
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['add']['href'] = "#request.self#?fuseaction=ch.form_collacted_cari_virman";
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['add']['target'] = "_blank";
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['copy']['text'] = '#lang_array_main.item[64]#';
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['copy']['href'] = '#request.self#?fuseaction=#fusebox.circuit#.form_collacted_cari_virman&_copy_id=#attributes.upd_id#';
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['copy']['target'] = "_blank";
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['print']['text'] = '#lang_array_main.item[62]#';
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['print']['onClick'] = "windowopen('#request.self#?fuseaction=objects.popup_print_files&iid=#attributes.upd_id#&print_type=217','page')";
		tabMenuData = SerializeJSON(tabMenuStruct['#attributes.fuseaction#']['tabMenus']);
	} 
	WOStruct['#attributes.fuseaction#']['extendedForm'] = structNew();
	WOStruct['#attributes.fuseaction#']['extendedForm']['controllerFileName'] = 'addCollactedVirman';
	WOStruct['#attributes.fuseaction#']['extendedForm']['eventList'] = 'add,upd';
	WOStruct['#attributes.fuseaction#']['extendedForm']['tableName'] = 'CARI_ACTIONS';
	WOStruct['#attributes.fuseaction#']['extendedForm']['dataSourceName'] = 'period';
	WOStruct['#attributes.fuseaction#']['extendedForm']['settings'] = "['item1','item2']";
</cfscript>

<cfscript>
	CreateComponent = CreateObject("component","/../workdata/getAccounts");
	queryResult = CreateComponent.getCompenentFunction(is_system_money:0,money_type_control:attributes.money_type_control,is_branch_control:0,control_status:1,is_open_accounts:0,currency_id_info:attributes.currency_id_info);	
</cfscript>
<script type="text/javascript">
	<cfoutput>
		<cfif not (len(paper_code) and len(paper_number))>
			var auto_paper_code = "";
			var auto_paper_number = "";
		<cfelse>
			var auto_paper_code = "#paper_code#-";
			var auto_paper_number = "#paper_number#";
		</cfif>
		
		row_count = #row_count#;
		
	</cfoutput>
	$( document ).ready(function() {
		document.getElementById('record_num').value=row_count;
		});
	record_exist=0;

	function sil(sy)
	{
		var my_element=document.getElementById('row_kontrol'+sy);	
		my_element.value=0;		
		var my_element=eval("frm_row"+sy);	
		my_element.style.display="none";
		toplam_hesapla();		
	}

	function add_row(paper_number,from_company_id,from_consumer_id,from_employee_id,to_company_id,to_consumer_id,to_employee_id,action_value,action_value2,currency_id,action_date,action_detail,to_asset_id,from_asset_id,to_project_id,from_project_id,to_branch_id,from_branch_id)
	{
		if(paper_number == undefined) paper_number = '';
		
		if(from_company_id == undefined) from_company_id = '';
		if(from_consumer_id == undefined) from_consumer_id = '';
		if(from_employee_id == undefined) from_employee_id = '';
		
		from_comp_name = '';
		if(from_company_id != ''){
			get_comp_name = wrk_safe_query('cst_get_company','dsn',0,from_company_id);
			from_comp_name = get_comp_name.FULLNAME;
		}
		else if(from_consumer_id != ''){
			get_cons_name = wrk_safe_query('obj_get_cons_name','dsn',0,from_consumer_id);
			from_comp_name = get_cons_name.CONSUMER_NAME + ' ' + get_cons_name.CONSUMER_SURNAME;
		}
		else if(from_employee_id != ''){
			get_emp_name = wrk_safe_query('hr_get_emp_name','dsn',0,from_employee_id);
			from_comp_name = get_emp_name.NAME;
		}
		
		to_comp_name = '';
		if(to_company_id == undefined) to_company_id = '';
		if(to_consumer_id == undefined) to_consumer_id = '';
		if(to_employee_id == undefined) to_employee_id = '';

		if(to_company_id != ''){
			get_comp_name = wrk_safe_query('cst_get_company','dsn',0,to_company_id);
			to_comp_name = get_comp_name.FULLNAME;
		}
		else if(to_consumer_id != ''){
			get_cons_name = wrk_safe_query('obj_get_cons_name','dsn',0,to_consumer_id);
			to_comp_name = get_cons_name.CONSUMER_NAME + ' ' + get_cons_name.CONSUMER_SURNAME;
		}
		else if(to_employee_id != ''){
			get_emp_name = wrk_safe_query('hr_get_emp_name','dsn',0,to_employee_id);
			to_comp_name = get_emp_name.NAME;
		}

		if(action_value == undefined) action_value = 0;
		if(action_value2 == undefined) action_value2 = 0;
		if(currency_id == undefined) currency_id = '';

		if(action_date == undefined) action_date = <cfoutput>'#dateformat(now(),'dd/mm/yyyy')#'</cfoutput>;
		
		if(action_detail == undefined) action_detail = '';

		if(to_asset_id == undefined) to_asset_id = ''; to_asset_name = '';
		to_asset_name = '';
		if(to_asset_id != '')
		{
			get_asset_name = wrk_safe_query('obj_get_pro_name_2','dsn',0,to_asset_id);
			to_asset_name = get_asset_name.ASSETP;
		}
		if(from_asset_id == undefined) from_asset_id = ''; from_asset_name = '';
		from_asset_name = '';
		if(from_asset_id != '')
		{
			get_asset_name = wrk_safe_query('obj_get_pro_name_2','dsn',0,from_asset_id);
			from_asset_name = get_asset_name.ASSETP;
		}
		
		if(to_project_id == undefined) to_project_id = '';
		to_project_head = '';
		if(to_project_id != '')
		{
			get_project_head = wrk_safe_query('obj_get_pro_name','dsn',0,to_project_id);
			to_project_head = get_project_head.PROJECT_HEAD;
		}
		
		if(from_project_id == undefined) from_project_id = '';
		from_project_head = '';
		if(from_project_id != '')
		{
			get_project_head = wrk_safe_query('obj_get_pro_name','dsn',0,from_project_id);
			from_project_head = get_project_head.PROJECT_HEAD;
		}
		
		if(to_branch_id == undefined) to_branch_id = ''; to_branch_head = '';
		if(from_branch_id == undefined) from_branch_id = ''; from_branch_head = '';

		row_count++;
		var newRow;
		var newCell;	
		document.getElementById('record_num').value=row_count;
		newRow = document.getElementById("table1").insertRow(document.getElementById("table1").rows.length);
		newRow.setAttribute("name","frm_row" + row_count);
		newRow.setAttribute("id","frm_row" + row_count);
		newRow.className = 'color-row';
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.setAttribute("nowrap","nowrap");
		newCell.innerHTML = '<input  type="hidden"  value="1"  name="row_kontrol' + row_count +'" id="row_kontrol' + row_count +'"><a href="javascript://" onclick="sil(' + row_count + ');"><img src="/images/delete_list.gif" border="0" align="absmiddle"></a><a style="cursor:pointer" onclick="copy_row('+row_count+');" title="<cf_get_lang_main no="1560.Satır Kopyala">"><img  src="images/copy_list.gif" border="0" align="absmiddle"></a>';
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.setAttribute("nowrap","nowrap");
		if(!paper_number)
			paper_number = auto_paper_code + auto_paper_number;
		newCell.innerHTML = '<input type="text" name="paper_number' + row_count +'" id="paper_number' + row_count +'" value="'+paper_number+'" class="boxtext">';
		if(auto_paper_number != '')
			auto_paper_number++;
		// borçlu hesap
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.setAttribute("nowrap","nowrap");
		newCell.innerHTML += '<input type="hidden" name="to_company_id' + row_count +'" id="to_company_id' + row_count +'"  value="'+to_company_id+'"><input type="hidden" name="to_consumer_id' + row_count +'" id="to_consumer_id' + row_count +'"  value="'+to_consumer_id+'"><input type="hidden" name="to_employee_id' + row_count +'" id="to_employee_id' + row_count +'"  value="'+to_employee_id+'"><input type="text" name="to_comp_name' + row_count +'" id="to_comp_name' + row_count +'" onFocus="autocomp_to_comp('+row_count+');" value="'+to_comp_name+'" style="width:162px;"  class="boxtext"><a href="javascript://" onClick="pencere_ac_to_company('+ row_count +');"><img src="/images/plus_thin.gif"  align="absmiddle" border="0" alt="<cf_get_lang_main no='322.Seçiniz'>"></a>';
		// alacaklı hesap	
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.setAttribute("nowrap","nowrap");
		newCell.innerHTML += '<input type="hidden" name="from_company_id' + row_count +'" id="from_company_id' + row_count +'"  value="'+from_company_id+'"><input type="hidden" name="from_consumer_id' + row_count +'" id="from_consumer_id' + row_count +'"  value="'+from_consumer_id+'"><input type="hidden" name="from_employee_id' + row_count +'" id="from_employee_id' + row_count +'"  value="'+from_employee_id+'"><input type="text" name="from_comp_name' + row_count +'" id="from_comp_name' + row_count +'" onFocus="autocomp_from_comp('+row_count+');" value="'+from_comp_name+'" style="width:162px;"  class="boxtext"><a href="javascript://" onClick="pencere_ac_from_company('+ row_count +');"><img src="/images/plus_thin.gif"  align="absmiddle" border="0" alt="<cf_get_lang_main no='322.Seçiniz'>"></a>';
		//tutar + dövizli tutar
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.setAttribute("nowrap","nowrap");
		newCell.innerHTML = '<input type="text" name="action_value_' + row_count +'" id="action_value_' + row_count + '" value="'+commaSplit(action_value)+'" onkeyup="return(FormatCurrency(this,event));" onBlur="kur_ekle_f_hesapla(\'action_currency_id\',false,'+row_count+');" float:right;" class="box">';
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.setAttribute("nowrap","nowrap");
		newCell.innerHTML = '<input type="text" name="action_value2_' + row_count +'" id="action_value2_' + row_count + '" value="'+commaSplit(action_value2)+'" onkeyup="return(FormatCurrency(this,event));" style="width:100%;" class="box" onBlur="kur_ekle_f_hesapla(\'action_currency_id\',true,'+row_count+');">';
        // para br
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.setAttribute("nowrap","nowrap");
		a = '<select name="money_id' + row_count  +'" id="money_id' + row_count + '" style="width:100%;" class="boxtext" onChange="kur_ekle_f_hesapla(\'action_currency_id\',false,'+row_count+');">';
		<cfoutput query="get_money">
			if('#money#' == currency_id)
				a += '<option value="#money#;#rate1#;#filterNum(tlformat(rate2,"#rate_round_num_info#"),"#rate_round_num_info#")#" selected>#money#</option>';
			else
				a += '<option value="#money#;#rate1#;#filterNum(tlformat(rate2,"#rate_round_num_info#"),"#rate_round_num_info#")#">#money#</option>';
		</cfoutput>
		newCell.innerHTML =a+ '</select>';
		// ödeme tarihi
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.setAttribute("nowrap","nowrap");
		newCell.setAttribute("id","action_date" + row_count + "_td");
		newCell.innerHTML = '<input type="text" id="action_date' + row_count +'" name="action_date' + row_count +'" class="text" maxlength="10" style="width:65px;" value="' + action_date +'"> ';
		wrk_date_image('action_date' + row_count);
		// açıklama
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.setAttribute("nowrap","nowrap");
		newCell.innerHTML = '<input type="text" name="action_detail' + row_count +'" id="action_detail' + row_count + '" value="'+action_detail+'" style="width:130px;" class="boxtext">';
		
		//borçlu fiziki varlık
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.setAttribute("nowrap","nowrap");
		newCell.innerHTML = '<input type="hidden" id="to_asset_id'+ row_count +'" name="to_asset_id'+ row_count +'" value="'+to_asset_id+'"><input type="text" id="to_asset_name'+ row_count +'" name="to_asset_name'+ row_count +'" value="'+to_asset_name+'" style="width:150px;" class="boxtext" onFocus="autocomp_to_asset('+row_count+');"><a href="javascript://" onClick="pencere_ac_to_asset('+ row_count +');"><img src="/images/plus_thin.gif"  align="absmiddle" border="0"></a>';
		
		//alacaklı fiziki varlık
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.setAttribute("nowrap","nowrap");
		newCell.innerHTML = '<input type="hidden" id="from_asset_id'+ row_count +'" name="from_asset_id'+ row_count +'" value="'+from_asset_id+'"><input type="text" id="from_asset_name'+ row_count +'" name="from_asset_name'+ row_count +'" value="'+from_asset_name+'" style="width:150px;" class="boxtext" onFocus="autocomp_from_asset('+row_count+');"><a href="javascript://" onClick="pencere_ac_from_asset('+ row_count +');"><img src="/images/plus_thin.gif"  align="absmiddle" border="0"></a>';
				
		//borçlu proje
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.setAttribute("nowrap","nowrap");
		newCell.innerHTML = '<input type="hidden" name="to_project_id'+ row_count +'" id="to_project_id'+ row_count +'" value="'+to_project_id+'"><input type="text" style="width:143px;" name="to_project_head'+ row_count +'" id="to_project_head'+ row_count +'" onFocus="autocomp_to_project('+row_count+');" value="'+to_project_head+'" class="boxtext"><a href="javascript://" onClick="pencere_ac_to_project('+ row_count +');"><img src="/images/plus_thin.gif"  align="absmiddle" border="0" alt="<cf_get_lang_main no='322.Seçiniz'>"></a>';
		//alacaklı proje
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.setAttribute("nowrap","nowrap");
		newCell.innerHTML = '<input type="hidden" name="from_project_id'+ row_count +'" id="from_project_id'+ row_count +'" value="'+from_project_id+'"><input type="text" style="width:143px;" name="from_project_head'+ row_count +'" id="from_project_head'+ row_count +'" onFocus="autocomp_from_project('+row_count+');" value="'+from_project_head+'" class="boxtext"><a href="javascript://" onClick="pencere_ac_from_project('+ row_count +');"><img src="/images/plus_thin.gif"  align="absmiddle" border="0" alt="<cf_get_lang_main no='322.Seçiniz'>"></a>';
		 <cfif isDefined('x_show_branch') and x_show_branch eq 1>
			//borçlu şube
			newCell = newRow.insertCell(newRow.cells.length);
			newCell.setAttribute("nowrap","nowrap");
			a = '<select name="to_branch_id' + row_count  +'" id="to_branch_id' + row_count + '" style="width:100%;" class="boxtext">';
			a += '<option value="" selected>Seçiniz</option>';
			<cfoutput query="get_branches">
				if('#branch_id#' == to_branch_id)
					a += '<option value="#branch_id#" selected>#branch_name#</option>';
				else
					a += '<option value="#branch_id#">#branch_name#</option>';
			</cfoutput>
			newCell.innerHTML =a+ '</select>';
			//alacaklı şube
			newCell = newRow.insertCell(newRow.cells.length);
			newCell.setAttribute("nowrap","nowrap");
			a = '<select name="from_branch_id' + row_count  +'" id="from_branch_id' + row_count + '" style="width:100%;" class="boxtext">';
			a += '<option value="" selected>Seçiniz</option>';
			<cfoutput query="get_branches">
				if('#branch_id#' == from_branch_id)
					a += '<option value="#branch_id#" selected>#branch_name#</option>';
				else
					a += '<option value="#branch_id#">#branch_name#</option>';
			</cfoutput>
			newCell.innerHTML =a+ '</select>';
		<cfelse>
			newCell = newRow.insertCell(newRow.cells.length);
			newCell.setAttribute("nowrap","nowrap");
			newCell.innerHTML = '<input type="hidden" name="to_branch_id' + row_count +'" id="to_branch_id' + row_count + '" value="">';
			newCell = newRow.insertCell(newRow.cells.length);
			newCell.setAttribute("nowrap","nowrap");
			newCell.innerHTML = '<input type="hidden" name="from_branch_id' + row_count +'" id="from_branch_id' + row_count + '" value="">';
		</cfif>
		kur_ekle_f_hesapla('<cfoutput>#select_input#</cfoutput>',true,row_count);
		toplam_hesapla();
	}
	function copy_row(no_info)
	{	
		if (document.getElementById("from_company_id" + no_info) == undefined) from_company_id =""; else from_company_id = document.getElementById("from_company_id" + no_info).value;
		if (document.getElementById("from_consumer_id" + no_info) == undefined) from_consumer_id =""; else from_consumer_id = document.getElementById("from_consumer_id" + no_info).value;
		if (document.getElementById("from_employee_id" + no_info) == undefined) from_employee_id =""; else from_employee_id = document.getElementById("from_employee_id" + no_info).value;
		if (document.getElementById("to_company_id" + no_info) == undefined) to_company_id =""; else to_company_id = document.getElementById("to_company_id" + no_info).value;
		if (document.getElementById("to_consumer_id" + no_info) == undefined) to_consumer_id =""; else to_consumer_id = document.getElementById("to_consumer_id" + no_info).value;
		if (document.getElementById("to_employee_id" + no_info) == undefined) to_employee_id =""; else to_employee_id = document.getElementById("to_employee_id" + no_info).value;
		if (document.getElementById("action_value_" + no_info) == undefined) action_value =""; else action_value = document.getElementById("action_value_" + no_info).value.replace('.','');
		if (document.getElementById("action_value2_" + no_info) == undefined) action_value2 =""; else action_value2 = document.getElementById("action_value2_" + no_info).value.replace('.','');
		if (document.getElementById("money_id" + no_info) == undefined) currency_id =""; else currency_id = document.getElementById("money_id" + no_info).value.split(';')[0];
		if (document.getElementById("action_date" + no_info) == undefined) action_date =""; else action_date = document.getElementById("action_date" + no_info).value;
		if (document.getElementById("action_detail" + no_info) == undefined) action_detail =""; else action_detail = document.getElementById("action_detail" + no_info).value;
		if (document.getElementById("to_asset_id" + no_info) == undefined) to_asset_id =""; else to_asset_id = document.getElementById("to_asset_id" + no_info).value;
		if (document.getElementById("from_asset_id" + no_info) == undefined) from_asset_id =""; else from_asset_id = document.getElementById("from_asset_id" + no_info).value;
		if (document.getElementById("to_project_id" + no_info) == undefined) to_project_id =""; else to_project_id = document.getElementById("to_project_id" + no_info).value;
		if (document.getElementById("from_project_id" + no_info) == undefined) from_project_id =""; else from_project_id = document.getElementById("from_project_id" + no_info).value;
		if (document.getElementById("to_branch_id" + no_info) == undefined) to_branch_id =""; else to_branch_id = document.getElementById("to_branch_id" + no_info).value;
		if (document.getElementById("from_branch_id" + no_info) == undefined) from_branch_id =""; else from_branch_id = document.getElementById("from_branch_id" + no_info).value;
		
		add_row('',from_company_id,from_consumer_id,from_employee_id,to_company_id,to_consumer_id,to_employee_id,action_value,action_value2,currency_id,action_date,action_detail,to_asset_id,from_asset_id,to_project_id,from_project_id,to_branch_id,from_branch_id);
		kur_ekle_f_hesapla('<cfoutput>#select_input#</cfoutput>',false,row_count);	
	}
	function autocomp_from_comp(no)
	{
		AutoComplete_Create("from_comp_name"+no,"MEMBER_NAME,MEMBER_PARTNER_NAME,MEMBER_CODE","MEMBER_NAME,MEMBER_PARTNER_NAME,MEMBER_CODE","get_member_autocomplete","\"1,2,3\",\"\",\"\",\"\",\"\",\"\",\"\",\"1\"","COMPANY_ID,CONSUMER_ID,EMPLOYEE_ID","from_company_id"+no+",from_consumer_id"+no+",from_employee_id"+no+"","",3,250,"emp_comp_and_account("+ no +")");
	}
	function autocomp_to_comp(no)
	{
		AutoComplete_Create("to_comp_name"+no,"MEMBER_NAME,MEMBER_PARTNER_NAME,MEMBER_CODE","MEMBER_NAME,MEMBER_PARTNER_NAME,MEMBER_CODE","get_member_autocomplete","\"1,2,3\",\"\",\"\",\"\",\"\",\"\",\"\",\"1\"","COMPANY_ID,CONSUMER_ID,EMPLOYEE_ID","to_company_id"+no+",to_consumer_id"+no+",to_employee_id"+no+"","",3,250,"emp_comp_and_account("+ no +")");
	}
	
	function pencere_ac_from_company(sira_no)
	{
		windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_pars&is_cari_action=1&row_no='+ sira_no +'<cfif fusebox.circuit is "store">&is_store_module=1</cfif>&select_list=1,2,3,9&field_comp_id=add_process.from_company_id'+ sira_no +'&field_name=add_process.from_comp_name' + sira_no +'&field_emp_id=add_process.from_employee_id'+ sira_no +'&field_consumer=add_process.from_consumer_id'+ sira_no,'list');
	}
	function pencere_ac_to_company(sira_no)
	{
		windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_pars&is_cari_action=1&row_no='+ sira_no +'<cfif fusebox.circuit is "store">&is_store_module=1</cfif>&select_list=1,2,3,9&field_comp_id=add_process.to_company_id'+ sira_no +'&field_name=add_process.to_comp_name' + sira_no +'&field_emp_id=add_process.to_employee_id'+ sira_no +'&field_consumer=add_process.to_consumer_id'+ sira_no,'list');
	}
	
	function autocomp_to_asset(no)
	{
		AutoComplete_Create("to_asset_name"+no,"ASSETP","ASSETP","get_assetp_autocomplete","","ASSETP_ID","to_asset_id"+no,"",3,200);
	}
	function autocomp_from_asset(no)
	{
		AutoComplete_Create("from_asset_name"+no,"ASSETP","ASSETP","get_assetp_autocomplete","","ASSETP_ID","from_asset_id"+no,"",3,200);
	}
	function pencere_ac_to_asset(no)
	{
		windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=assetcare.popup_list_assetps&field_id=add_process.to_asset_id' + no +'&field_name=add_process.to_asset_name' + no +'&event_id=0&motorized_vehicle=0','list');
	}
	function pencere_ac_from_asset(no)
	{
		windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=assetcare.popup_list_assetps&field_id=add_process.from_asset_id' + no +'&field_name=add_process.from_asset_name' + no +'&event_id=0&motorized_vehicle=0','list');
	}
	
    function autocomp_to_project(no)
    {
        AutoComplete_Create("to_project_head"+no,"PROJECT_HEAD","PROJECT_HEAD","get_project","","PROJECT_ID","to_project_id"+no,"",3,200);
    }
    function autocomp_from_project(no)
    {
        AutoComplete_Create("from_project_head"+no,"PROJECT_HEAD","PROJECT_HEAD","get_project","","PROJECT_ID","from_project_id"+no,"",3,200);
    }
    function pencere_ac_to_project(no)
    {
        windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_projects&project_id=add_process.to_project_id' + no +'&project_head=add_process.to_project_head' + no +'','list');
    }
    function pencere_ac_from_project(no)
    {
        windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_projects&project_id=add_process.from_project_id' + no +'&project_head=add_process.from_project_head' + no +'','list');
    }
	
	function toplam_hesapla()
	{
		var total_amount = 0;
		for(j=1; j<=document.getElementById('record_num').value; j++)
		{
			if(document.getElementById('row_kontrol'+j).value==1)
			{
				total_amount += parseFloat(filterNum(document.getElementById('action_value_'+j).value));
			}
		}
		document.getElementById('total_amount').value = commaSplit(total_amount);
	}
	
	function kontrol()
	{
		if(!chk_process_cat('add_process')) return false;
		if(!check_display_files('add_process')) return false;
		if(!chk_period(add_process.action_date,'İşlem')) return false;
		
		kur_ekle_f_hesapla('<cfoutput>#select_input#</cfoutput>',false);
		
		var p_type_ = "VIRMAN";
		var table_name_ = "BANK_ACTIONS";
		var alert_name_ = "Aynı Belge No İle Kayıtlı Virman İşlemi Var";
		paper_num_list = '';
		<cfsavecontent veriable="message1">
			'<cf_get_lang dictionary_id="52190.Lütfen Borçlu Hesap Seçiniz">!'
		</cfsavecontent>
		<cfsavecontent veriable="message2">
			'<cf_get_lang dictionary_id="52207.Lütfen Alacaklı Hesap Seçiniz">!'
		</cfsavecontent>
		<cfsavecontent veriable="message3">
			'<cf_get_lang dictionary_id="47303.Seçtiğiniz Hesaplar Aynı">!'
		</cfsavecontent>

		for(j=1; j<=document.getElementById('record_num').value; j++)
		{
			if(document.getElementById('row_kontrol'+j).value==1)
			{
				record_exist=1;
				if(document.getElementById('paper_number'+j).value != "" )
				{
					paper = document.getElementById('paper_number'+j).value;
					paper = "'"+paper+"'";
					if(list_find(paper_num_list,paper,','))
					{
						alert('<cf_get_lang dictionary_id="33815.Aynı Belge Numarası İle Eklenen İki Farklı Satır Var:">'+ paper);
						return false;
					}
					else
					{
						if(list_len(paper_num_list,',') == 0)
							paper_num_list+=paper;
						else
							paper_num_list+=","+paper;
					}
				}
				//satirda hesaplarin kontrolu
				if (document.getElementById('from_company_id'+j).value == '' && document.getElementById('from_consumer_id'+j).value == '' && document.getElementById('from_employee_id'+j).value == '')
				{ 
					alert (document.getElementById('paper_number'+j).value+":"message1);
					return false;
				}
				if (document.getElementById('to_company_id'+j).value == '' && document.getElementById('to_consumer_id'+j).value == '' && document.getElementById('to_employee_id'+j).value == '')
				{ 
					alert (document.getElementById('paper_number'+j).value+":"message2);
					return false;
				}
				//satirda hesapların farkliligi kontrolu
				if((document.getElementById('from_company_id'+j).value != '' && document.getElementById('to_company_id'+j).value != '' && document.getElementById('from_company_id'+j).value == document.getElementById('to_company_id'+j).value) ||
					(document.getElementById('from_consumer_id'+j).value != '' && document.getElementById('to_consumer_id'+j).value != '' && document.getElementById('from_consumer_id'+j).value == document.getElementById('to_consumer_id'+j).value) ||
					(document.getElementById('from_employee_id'+j).value != '' && document.getElementById('to_employee_id'+j).value != '' && document.getElementById('from_employee_id'+j).value == document.getElementById('to_employee_id'+j).value))				
				{
					alert(document.getElementById('paper_number'+j).value+":"message3);		
					return false; 
				}
			}
		}
		if (record_exist == 0) 
		{
			alert('<cf_get_lang dictionary_id="48478.Lütfen Satır Ekleyiniz">!');
			return false;
		}
		return true;
	}
	
	function open_file()
	{
		document.getElementById("collacted_virman").style.display='';
		AjaxPageLoad('<cfoutput>#request.self#?fuseaction=#fusebox.circuit#.popup_add_collacted_virman_file<cfif isdefined("attributes.multi_id")>&multi_id=#attributes.multi_id#</cfif></cfoutput>','collacted_virman',1);
		return false;
	}
	
	function kur_ekle_f_hesapla(select_input,doviz_tutar,satir)
	{
		if(satir != undefined)
		{
			for(var kk=1;kk<=add_process.record_num.value;kk++)
			{
				if(!doviz_tutar) doviz_tutar=false;
				var currency_type = document.getElementById('action_currency_id').value;
				currency_type = list_getat(currency_type,2,';');
				
				row_currency = list_getat(eval("document.add_process.money_id"+kk).value,1,';');
				var other_money_value_eleman=eval("document.add_process.action_value2_"+kk);
				var rate1_eleman,rate2_eleman;
				if(doviz_tutar && ( other_money_value_eleman.value.length==0 || filterNum(other_money_value_eleman.value)==0) )
				{
					other_money_value_eleman.value = '';
					return false;
				}
				if(!doviz_tutar && eval("document.add_process.action_value_"+satir) != "" && currency_type != "")
				{
					for(var i=1;i<=add_process.kur_say.value;i++)
					{
						rate1_eleman = filterNum(eval('add_process.txt_rate1_' + i).value,'<cfoutput>#rate_round_num_info#</cfoutput>');
						rate2_eleman = filterNum(eval('add_process.txt_rate2_' + i).value,'<cfoutput>#rate_round_num_info#</cfoutput>');
						if(eval('add_process.hidden_rd_money_'+i).value == row_currency)
						{
							other_money_value_eleman.value = commaSplit(filterNum(eval("document.add_process.action_value_"+kk).value)*rate1_eleman/rate2_eleman);
						}
					}
				}
				else if(doviz_tutar)
				{
					for(var i=1;i<=add_process.kur_say.value;i++)
					{
						rate1_eleman = filterNum(eval('add_process.txt_rate1_' + i).value,'<cfoutput>#rate_round_num_info#</cfoutput>');
						rate2_eleman = filterNum(eval('add_process.txt_rate2_' + i).value,'<cfoutput>#rate_round_num_info#</cfoutput>');
						if(eval('add_process.hidden_rd_money_'+i).value == row_currency)
							eval("document.add_process.action_value_"+kk).value = commaSplit(filterNum(eval("document.add_process.action_value2_"+kk).value)*rate2_eleman/rate1_eleman);
					}
				}
			}
		}
		else
		{
			for(var kk=1;kk<=add_process.record_num.value;kk++)
			{
				if(!doviz_tutar) doviz_tutar=false;
				var currency_type = document.getElementById('action_currency_id').value;
				currency_type = list_getat(currency_type,2,';');
				document.getElementById('tl_value1').value = currency_type;
				
				row_currency = list_getat(eval("document.add_process.money_id"+kk).value,1,';');
				var other_money_value_eleman=eval("document.add_process.action_value2_"+kk);
				var rate1_eleman,rate2_eleman;			
							
				if(doviz_tutar && ( other_money_value_eleman.value.length==0 || filterNum(other_money_value_eleman.value)==0) )
				{
					other_money_value_eleman.value = '';
					return false;
				}
				if(currency_type != "")
				if(!doviz_tutar && eval("document.add_process.action_value_"+kk) != "" && currency_type != "")
				{
					for(var i=1;i<=add_process.kur_say.value;i++)
					{
						rate1_eleman = filterNum(eval('add_process.txt_rate1_' + i).value,'<cfoutput>#rate_round_num_info#</cfoutput>');
						rate2_eleman = filterNum(eval('add_process.txt_rate2_' + i).value,'<cfoutput>#rate_round_num_info#</cfoutput>');
						if(eval('add_process.hidden_rd_money_'+i).value == row_currency)
						{
							other_money_value_eleman.value = commaSplit(filterNum(eval("document.add_process.action_value_"+kk).value,'<cfoutput>#rate_round_num_info#</cfoutput>')*rate1_eleman/rate2_eleman);
						}
					}
				}
				else if(doviz_tutar)
				{
					for(var i=1;i<=add_process.kur_say.value;i++)
					{
						rate1_eleman = filterNum(eval('add_process.txt_rate1_' + i).value,'<cfoutput>#rate_round_num_info#</cfoutput>');
						rate2_eleman = filterNum(eval('add_process.txt_rate2_' + i).value,'<cfoutput>#rate_round_num_info#</cfoutput>');
						if(eval('add_process.hidden_rd_money_'+i).value == row_currency)
							eval("document.add_process.action_value_"+kk).value = commaSplit(filterNum(eval("document.add_process.action_value2_"+kk).value)*rate2_eleman/rate1_eleman);
					}
				}
			}
		}	
		toplam_hesapla();
		return true;
	}
	window.onload = function()
	{ 
		if(document.getElementById('<cfoutput>#select_input#</cfoutput>').value != '')
			kur_ekle_f_hesapla('<cfoutput>#select_input#</cfoutput>',false);
	}
</script>

<cf_get_lang_set module_name="#lcase(listgetat(attributes.fuseaction,1,'.'))#">


