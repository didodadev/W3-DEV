<cf_get_lang_set module_name="ch">
<cf_xml_page_edit fuseact="ch.list_caris">
<cfparam name="attributes.keyword" default="">
<cfparam name="attributes.company_id" default="">
<cfparam name="attributes.company_name" default="">
<cfparam name="attributes.consumer_id" default="">
<cfparam name="attributes.employee_id" default="">
<cfparam name="attributes.employee_name" default="">
<cfparam name="attributes.action_type_ch" default="">
<cfparam name="attributes.member_cat_type" default="">
<cfparam name="attributes.record_emp" default="">
<cfparam name="attributes.record_name" default="">
<cfparam name="attributes.asset_id" default="">
<cfparam name="attributes.asset_name" default="">
<cfparam name="attributes.expense_center_id" default="">
<cfparam name="attributes.expense_center_name" default="">
<cfparam name="attributes.expense_item_id" default="">
<cfparam name="attributes.expense_item_name" default="">
<cfparam name="attributes.special_definition_id" default="">
<cfparam name="attributes.project_head" default="">
<cfparam name="attributes.project_id" default="">
<cfparam name="attributes.pos_code" default="">
<cfparam name="attributes.pos_code_text" default="">
<cfparam name="attributes.is_excel" default="">
<cfparam name="attributes.POSITION_CODE" default="">
<cfif isdefined("attributes.start_date") and isdate(attributes.start_date)>
	<cf_date tarih = "attributes.start_date">
<cfelse>
	<cfif session.ep.our_company_info.UNCONDITIONAL_LIST>
		<cfset attributes.start_date = ''>
	<cfelse>
		<cfset attributes.start_date = date_add('d',-7,wrk_get_today())>
	</cfif>
</cfif>
<cfif isdefined("attributes.finish_date") and isdate(attributes.finish_date)>
	<cf_date tarih = "attributes.finish_date">
<cfelse>
	<cfif session.ep.our_company_info.UNCONDITIONAL_LIST>
		<cfset attributes.finish_date = ''>
	<cfelse>
	<cfset attributes.finish_date = date_add('d',7,attributes.start_date)>
	</cfif>
</cfif>
	<cfparam name="attributes.page" default=1>
	<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
	<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
<cfif isdefined("attributes.form_varmi")>
	<cfif isdefined("attributes.employee_id")>
        <cfscript>
            attributes.acc_type_id = '';
            if(listlen(attributes.employee_id,'_') eq 2)
            {
                attributes.acc_type_id = listlast(attributes.employee_id,'_');
                attributes.emp_id = listfirst(attributes.employee_id,'_');
            }
            else
                attributes.emp_id = attributes.employee_id;
        </cfscript>
    </cfif>
	<cfset list_acc_type_id = "">
	<cfset list_company = "">
	<cfset list_consumer = "">
	<cfif len(attributes.member_cat_type)>
		<cfloop from="1" to="#listlen(attributes.member_cat_type,',')#" index="ix">
			<cfset list_getir = listgetat(attributes.member_cat_type,ix,',')>
			<cfif listfirst(list_getir,'-') eq 1 and listlast(list_getir,'-') neq 0>
				<cfset list_company = listappend(list_company,listlast(list_getir,'-'),'-')>
			<cfelseif listfirst(list_getir,'-') eq 2 and listlast(list_getir,'-') neq 0>
				<cfset list_consumer = listappend(list_consumer,listlast(list_getir,'-'),'-')>
			<cfelseif listfirst(list_getir,'-') eq 3 and replace(list_getir,'#listfirst(list_getir,'-')#-','') neq 0>
				<cfset list_acc_type_id = listappend(list_acc_type_id,replace(list_getir,'#listfirst(list_getir,'-')#-',''),',')>
			</cfif>
			<cfset list_company = listsort(listdeleteduplicates(replace(list_company,"-",",","all"),','),'numeric','ASC',',')>
			<cfset list_consumer = listsort(listdeleteduplicates(replace(list_consumer,"-",",","all"),','),'numeric','ASC',',')>
		</cfloop>
	</cfif>
	<cfscript>
	get_caris_list_action = createObject("component", "ch.cfc.get_caris");
	get_caris_list_action.dsn2 = dsn2;
	get_caris_list_action.dsn_alias = dsn_alias;
	get_caris_list_action.fusebox.general_cached_time = fusebox.general_cached_time;
	get_caris_list_action.upload_folder = upload_folder;
	get_caris = get_caris_list_action.get_caris_fnc
		(
			action_type_ch : '#IIf(IsDefined("attributes.action_type_ch"),"attributes.action_type_ch",DE(""))#',
			start_date : '#IIf(IsDefined("attributes.start_date"),"attributes.start_date",DE(""))#',
			finish_date : '#IIf(IsDefined("attributes.finish_date"),"attributes.finish_date",DE(""))#',
			keyword : '#IIf(IsDefined("attributes.keyword"),"attributes.keyword",DE(""))#',
			consumer_id : '#IIf(IsDefined("attributes.consumer_id"),"attributes.consumer_id",DE(""))#',
			company_name : '#IIf(IsDefined("attributes.company_name"),"attributes.company_name",DE(""))#',
			company_id : '#IIf(IsDefined("attributes.company_id"),"attributes.company_id",DE(""))#',
			emp_id : '#IIf(IsDefined("attributes.emp_id"),"#attributes.emp_id#",DE(""))#',
			employee_name : '#IIf(IsDefined("attributes.employee_name"),"attributes.employee_name",DE(""))#',
			member_cat_type : '#IIf(IsDefined("attributes.member_cat_type"),"attributes.member_cat_type",DE(""))#',
			branch_id : '#IIf(IsDefined("attributes.branch_id"),"attributes.branch_id",DE(""))#',
			record_name : '#IIf(IsDefined("attributes.record_name"),"attributes.record_name",DE(""))#',
			record_emp : '#IIf(IsDefined("attributes.record_emp"),"attributes.record_emp",DE(""))#',
			asset_id : '#IIf(IsDefined("attributes.asset_id"),"attributes.asset_id",DE(""))#',
			asset_name : '#IIf(IsDefined("attributes.asset_name"),"attributes.asset_name",DE(""))#',
			expense_center_id : '#IIf(IsDefined("attributes.expense_center_id"),"attributes.expense_center_id",DE(""))#',
			expense_center_name : '#IIf(IsDefined("attributes.expense_center_name"),"attributes.expense_center_name",DE(""))#',
			expense_item_id : '#IIf(IsDefined("attributes.expense_item_id"),"attributes.expense_item_id",DE(""))#',
			expense_item_name : '#IIf(IsDefined("attributes.expense_item_name"),"attributes.expense_item_name",DE(""))#',
			special_definition_id : '#IIf(IsDefined("attributes.special_definition_id"),"attributes.special_definition_id",DE(""))#',
			acc_type_id : '#IIf(IsDefined("attributes.acc_type_id"),"attributes.acc_type_id",DE(""))#',
			project_id : '#IIf(IsDefined("attributes.project_id"),"attributes.project_id",DE(""))#',
			project_head : '#IIf(IsDefined("attributes.project_head"),"attributes.project_head",DE(""))#',
			module_power_user_ehesap : '#get_module_power_user(48)#',
			module_power_user_hr : '#get_module_power_user(3)#',
			fuseaction_ : '#attributes.fuseaction#',
			dsn : '#dsn#',
			dsn_alias : '#dsn_alias#',
			dsn2_alias : '#dsn2_alias#',
			dsn3_alias : '#dsn3_alias#',
			oby : '#IIf(IsDefined("attributes.oby"),"attributes.oby",DE(""))#',
			list_company : '#IIf(IsDefined("list_company"),"list_company",DE(""))#',
			list_consumer : '#IIf(IsDefined("list_consumer"),"list_consumer",DE(""))#',
			list_acc_type_id : '#IIf(IsDefined("list_acc_type_id"),"list_acc_type_id",DE(""))#',
			startrow : '#IIf(IsDefined("attributes.startrow"),"attributes.startrow",DE(""))#',
			maxrows : '#IIf(IsDefined("attributes.maxrows"),"attributes.maxrows",DE(""))#',
			pos_code : '#IIf(IsDefined("attributes.pos_code"),"#attributes.pos_code#",DE(""))#',
			pos_code_text : '#IIf(IsDefined("attributes.pos_code_text"),"attributes.pos_code_text",DE(""))#',
			is_excel : attributes.is_excel,
			x_branch_info : x_branch_info,
			x_project_info : x_project_info
		);
	</cfscript>
	<cfset arama_yapilmali = 0>
<cfelse>
	<cfset get_caris.recordcount = 0>
	<cfset arama_yapilmali = 1>
</cfif>
<cfquery name="get_branchs" datasource="#dsn#">
	SELECT 
		BRANCH_ID,
		BRANCH_NAME 
	FROM 
		BRANCH 
	WHERE
		COMPANY_ID = #session.ep.company_id#
		<cfif session.ep.isBranchAuthorization >
			AND	BRANCH_ID IN (SELECT BRANCH_ID FROM EMPLOYEE_POSITION_BRANCHES WHERE POSITION_CODE = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.position_code#">)
		</cfif>
	ORDER BY 
		BRANCH_ID
</cfquery>
<cfif get_caris.recordcount>
	<cfif not (isdefined("attributes.is_excel") and attributes.is_excel eq 1)>
    	<cfparam name="attributes.totalrecords" default="#get_caris.query_count#">
    <cfelse>
    	<cfparam name="attributes.totalrecords" default="0">
    </cfif>
<cfelse>	
	<cfparam name="attributes.totalrecords" default="0">
</cfif>
<cfquery name="GET_MONEY_RATE" datasource="#DSN#">
	SELECT
		*
	FROM
		SETUP_MONEY
	WHERE
		PERIOD_ID = #session.ep.period_id# AND
		MONEY_STATUS = 1 
</cfquery>
<cfquery name="GET_COMPANY_CAT" datasource="#DSN#">
	SELECT DISTINCT	
		COMPANYCAT_ID,
		COMPANYCAT
	FROM
		GET_MY_COMPANYCAT
	WHERE
		EMPLOYEE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#"> AND
		OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#"> 
	ORDER BY
		COMPANYCAT
</cfquery>
<cfquery name="GET_CONSUMER_CAT" datasource="#DSN#">
	SELECT DISTINCT	
		CONSCAT_ID,
		CONSCAT,
		HIERARCHY
	FROM
		GET_MY_CONSUMERCAT
	WHERE
		EMPLOYEE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#"> AND
		OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#">
	ORDER BY
		HIERARCHY		
</cfquery>
<cfquery name="get_all_ch_type" datasource="#dsn#">
    SELECT ACC_TYPE_ID,ACC_TYPE_NAME FROM SETUP_ACC_TYPE ORDER BY ACC_TYPE_ID
</cfquery>
<cfscript>
	// Switch //
	WOStruct = StructNew();
	WOStruct['#attributes.fuseaction#'] = structNew();
	
	WOStruct['#attributes.fuseaction#']['list'] = structNew();
	WOStruct['#attributes.fuseaction#']['default'] = 'list';
	WOStruct['#attributes.fuseaction#']['list']['window'] = 'normal';
	WOStruct['#attributes.fuseaction#']['list']['fuseaction'] = 'ch.list_caris';
	WOStruct['#attributes.fuseaction#']['list']['filePath'] = 'ch/display/list_caris.cfm';
	
	/*
	WOStruct['#attributes.fuseaction#']['upd'] = structNew();
	WOStruct['#attributes.fuseaction#']['upd']['window'] = 'normal';
	WOStruct['#attributes.fuseaction#']['upd']['fuseaction'] = 'finance.list_creditcard';
	WOStruct['#attributes.fuseaction#']['upd']['filePath'] = 'finance/form/upd_creditcard.cfm';
	WOStruct['#attributes.fuseaction#']['upd']['queryPath'] = 'finance/query/upd_creditcard.cfm';
	WOStruct['#attributes.fuseaction#']['upd']['nextEvent'] = 'finance.list_creditcard&event=upd';
	WOStruct['#attributes.fuseaction#']['upd']['parameters'] = 'creditcard_id=##attributes.creditcard_id##';
	WOStruct['#attributes.fuseaction#']['upd']['Identity'] = '##attributes.creditcard_id##';
	
	WOStruct['#attributes.fuseaction#']['add'] = structNew();
	WOStruct['#attributes.fuseaction#']['add']['window'] = 'normal';
	WOStruct['#attributes.fuseaction#']['add']['fuseaction'] = 'finance.list_creditcard';
	WOStruct['#attributes.fuseaction#']['add']['filePath'] = 'finance/form/add_creditcard.cfm';
	WOStruct['#attributes.fuseaction#']['add']['queryPath'] = 'finance/query/add_creditcard.cfm';
	WOStruct['#attributes.fuseaction#']['add']['nextEvent'] = 'finance.list_creditcard&event=upd';
	
	if(IsDefined("attributes.event") && attributes.event is 'upd')
	{
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd'] = structNew();
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons'] = structNew();
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['add']['text'] = '#lang_array_main.item[170]#';
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['add']['href'] = "#request.self#?fuseaction=finance.list_creditcard&event=add";
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['add']['target'] = "_blank";
		tabMenuData = SerializeJSON(tabMenuStruct['#attributes.fuseaction#']['tabMenus']);
	}*/
</cfscript>
<script type="text/javascript">
	$(function(){
		document.getElementById('keyword').focus();
		})
	function input_control()
	{
		<cfif not session.ep.our_company_info.UNCONDITIONAL_LIST>
			if (list_caris.start_date.value.length == 0 && list_caris.finish_date.value.length == 0 &&list_caris.keyword.value.length == 0 && list_caris.action_type[list_caris.action_type.selectedIndex].value.length == 0 
				&& (list_caris.company_id.value.length == 0 || list_caris.company_name.value.length == 0) 
				&& (list_caris.consumer_id.value.length == 0 || list_caris.company_name.value.length == 0)  
				&& (list_caris.employee_id.value.length == 0 || list_caris.employee_name.value.length == 0))
				{
					alert("<cf_get_lang_main no='1538.En az bir alanda filtre etmelisiniz'> !");
					return false;
				}
			else return true;
		<cfelse>
			return true;
		</cfif>
	}	
</script>

