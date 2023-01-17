<cf_get_lang_set module_name="cash">
<cfif not isdefined("attributes.event")>
	<cfset attributes.event = "add">
</cfif>
<cfinclude template="../cash/query/get_cashes.cfm">
<cfset refmodule="#listgetat(attributes.fuseaction,1,'.')#">
<cfset attributes.TABLE_NAME = "CASH_ACTIONS">
<cfset processCat = "">
<cfset specialDef = "">
<cfset member_info = "">
<cfset emp_id = "">
<cfset company_id = "">
<cfset consumer_id = "">
<cfset paper_info = "">
<cfset amount = 0>
<cfset other_amount = 0>
<cfset collectorId = "">
<cfset collector = "">
<cfset assetId = "">
<cfset projectId = "">
<cfset projectName = "">
<cfset actionId = "">
<cfset actionDetail = "">
<cfset paperPrinterCode = "">
<cfset actionDate = dateformat(now(),'dd/mm/yyyy')>
<cfif isDefined('paper_printer_code')>
	<cfset paperPrinterCode = paper_printer_code>
</cfif>
<cfif isdefined("attributes.id") and isnumeric(attributes.id)>
	<cfset actionId = attributes.id>
	<cfinclude template="../cash/query/get_action_detail.cfm">
    <cfif get_action_detail.recordcount neq 0>
    	<cfset processCat = get_action_detail.process_cat>
        <cfset specialDef = get_action_detail.special_definition_id>
        <cfset emp_id = get_action_detail.CASH_ACTION_FROM_EMPLOYEE_ID>
        <cfif len(get_action_detail.acc_type_id)>
            <cfset emp_id = "#emp_id#_#get_action_detail.acc_type_id#">
        </cfif>
		<cfif len(get_action_detail.CASH_ACTION_FROM_EMPLOYEE_ID)>
            <cfset member_info = get_emp_info(get_action_detail.CASH_ACTION_FROM_EMPLOYEE_ID,0,0,0,get_action_detail.acc_type_id)>
        <cfelseif len(get_action_detail.CASH_ACTION_FROM_COMPANY_ID)>
            <cfset member_info = get_par_info(get_action_detail.CASH_ACTION_FROM_COMPANY_ID,1,1,0)>
            <cfset company_id = get_action_detail.CASH_ACTION_FROM_COMPANY_ID>
        <cfelseif len(get_action_detail.CASH_ACTION_FROM_CONSUMER_ID)>
            <cfset member_info = get_cons_info(get_action_detail.CASH_ACTION_FROM_CONSUMER_ID,0,0)>
            <cfset consumer_id = get_action_detail.CASH_ACTION_FROM_CONSUMER_ID>
        </cfif>
        <cfset amount = TLFormat(get_action_detail.CASH_ACTION_VALUE)>
        <cfset other_amount = TLFormat(get_action_detail.OTHER_CASH_ACT_VALUE)>
        <cfset assetId = get_action_detail.assetp_id>
        <cfset collectorId = get_action_detail.REVENUE_COLLECTOR_ID>
        <cfset collector = get_emp_info(get_action_detail.REVENUE_COLLECTOR_ID,0,0)>
        <cfset actionDetail = get_action_detail.ACTION_DETAIL>
        <cfset actionDate = dateformat(get_action_detail.ACTION_DATE,'dd/mm/yyyy')>
		<cfif len(get_action_detail.project_id)>
            <cfquery name="get_project_name" datasource="#dsn#">
                SELECT PROJECT_ID,PROJECT_HEAD FROM PRO_PROJECTS WHERE PROJECT_ID = #get_action_detail.project_id#
            </cfquery>
            <cfset projectId = get_action_detail.project_id>
            <cfset projectName = get_project_name.project_head>
        </cfif>
    </cfif>
<cfelse>
    <cfset get_action_detail.recordcount = 0>
    <cfset collectorId = session.ep.userid>
    <cfset collector = get_emp_info(session.ep.userid,0,0)>
</cfif>
<cfif attributes.event is "add">
	<cfset cash_status = 1>
    <cfinclude template="../cash/query/control_bill_no.cfm">
    <cf_papers paper_type="revenue_receipt">
	<cfif len(paper_code) and len(paper_number)>
        <cfset paper_info = paper_code & '-' & paper_number>
    </cfif>
<cfelseif attributes.event is "upd">
	<cfif not get_action_detail.recordcount>
        <cfset hata  = 11>
        <cfsavecontent variable="message"><cf_get_lang_main no='585.Şube Yetkiniz Uygun Değil'> <cf_get_lang_main no='586.Veya'> <cf_get_lang_main no='1531.Böyle Bir Kayıt Bulunmamaktadır'> !</cfsavecontent>
        <cfset hata_mesaj  = message>
        <cfinclude template="../dsp_hata.cfm">
        <cfexit method="exittemplate">
    <cfelse>
    	<cfset paper_info = get_action_detail.paper_no>
    </cfif>
</cfif>
<script type="text/javascript">
	$(document).ready(function(){
		kur_ekle_f_hesapla('CASH_ACTION_TO_CASH_ID');
	});
	function kontrol()
	{
		<cfif attributes.event is "add">
			var parameter = '-1*' + document.cash_revenue.paper_number.value + '*31*11'; <!---tahsilat işlemine göre paper no unique olmalı. 31 tahsilat işlemi action_type_id --->
			var parameter_2 = document.cash_revenue.paper_number.value + '*11';
			var get_paper_no = wrk_safe_query('csh_get_paper_no_3','dsn2',0,parameter);
			var get_paper_from_account = wrk_safe_query('acc_get_paper_no','dsn2',0,parameter_2);
			if( get_paper_no.recordcount || get_paper_from_account.recordcount)
			{
				alert("<cf_get_lang_main no='710.Girdiğiniz Belge Numarası Kullanılmaktadır'> !");
				return false;
			}
		<cfelseif attributes.event is "upd">
			control_account_process(<cfoutput>'#attributes.id#','#get_action_detail.action_type_id#'</cfoutput>);
			var parameter = document.cash_revenue.id.value + '*' + document.cash_revenue.paper_number.value + '*31*11'; <!---tahsilat işlemine göre paper no unique olmalı. 31 tahsilat işlemi action_type_id, 11 tahsil fişi --->
			var parameter_2 = document.cash_revenue.id.value + '*' + document.cash_revenue.paper_number.value + '*11';
			var get_paper_no = wrk_safe_query('csh_get_paper_no_3','dsn2',0,parameter);
			var get_paper_no_from_acc = wrk_safe_query('get_paper_no_from_acc','dsn2',0,parameter_2);<!---tahsilat işleminden oluşan tahsilat fişinin belge numarasıyla manuel olarak eklenmiş tahsilat fişi de var mı? ---> 	
			if( get_paper_no.recordcount || get_paper_no_from_acc.recordcount)
			{
				alert("<cf_get_lang_main no='710.Girdiğiniz Belge Numarası Kullanılmaktadır'> !");
				return false;
			}
		</cfif>
		if(!chk_process_cat('cash_revenue')) return false;
		if(!check_display_files('cash_revenue')) return false;
		if(!chk_period(cash_revenue.ACTION_DATE,'İşlem')) return false;
		if(document.getElementById('paper_number').value == "")
		{
			alert("<cf_get_lang_main no ='1144.Belge No Giriniz'>!");
			return false;	
		}
		if(document.getElementById('CASH_ACTION_VALUE').value == "")
		{
			alert("<cf_get_lang no='82.Miktar Girmelisiniz'>.");
			return false;
		}
		if(document.cash_revenue.REVENUE_COLLECTOR.value =='' )
		{
			alert("<cf_get_lang no ='203.Tahsil Eden Seçiniz '>!");
			return false;
		}
		if((document.cash_revenue.CASH_ACTION_FROM_COMPANY_ID.value =='') && (document.cash_revenue.EMPLOYEE_ID.value =='') && (document.cash_revenue.CASH_ACTION_FROM_CONSUMER_ID.value ==''))
		{
			alert("<cf_get_lang_main no ='782.Zorunlu Alan'>:<cf_get_lang_main no ='107.Cari Hesap'>");
			return false;
		}
		if(document.getElementById('CASH_ACTION_TO_CASH_ID').value=="")
		{
			alert("<cf_get_lang no ='204.Lütfen Kasa Seçiniz'>!");
			return false;
		}
		return true;
	}
	function hesap_sec()
	{
		if(document.cash_revenue.CASH_ACTION_FROM_COMPANY_ID.value!='')
		{
			document.cash_revenue.CASH_ACTION_FROM_COMPANY_ID.value='';
			document.cash_revenue.company_name.value='';
		}
		if(document.cash_revenue.CASH_ACTION_FROM_CONSUMER_ID.value!='')
		{
			document.cash_revenue.CASH_ACTION_FROM_CONSUMER_ID.value='';
			document.cash_revenue.company_name.value='';
		}
		if(document.cash_revenue.EMPLOYEE_ID.value!='')
		{
			document.cash_revenue.EMPLOYEE_ID.value='';
			document.cash_revenue.company_name.value='';
		}
	}
	<cfif attributes.event is "upd">
		function del_kontrol()
		{
			control_account_process(<cfoutput>'#attributes.id#','#get_action_detail.action_type_id#'</cfoutput>);
			if(!chk_period(cash_revenue.ACTION_DATE,'İşlem')) return false;
			else return true;
		}
	</cfif>
</script>
<cfscript>
	// Switch //
	WOStruct = StructNew();
	
	WOStruct['#attributes.fuseaction#'] = structNew();
	
	WOStruct['#attributes.fuseaction#']['default'] = 'add';
	
	if(not isdefined('attributes.event'))
		attributes.event = WOStruct['#attributes.fuseaction#']['default'];
	
	WOStruct['#attributes.fuseaction#']['add'] = structNew();
	WOStruct['#attributes.fuseaction#']['add']['window'] = 'normal';
	WOStruct['#attributes.fuseaction#']['add']['fuseaction'] = 'cash.form_add_cash_revenue';
	WOStruct['#attributes.fuseaction#']['add']['filePath'] = 'cash/form/form_cash_revenue.cfm';
	WOStruct['#attributes.fuseaction#']['add']['queryPath'] = 'cash/query/add_cash_revenue.cfm';
	WOStruct['#attributes.fuseaction#']['add']['nextEvent'] = 'cash.form_add_cash_revenue&event=upd';
	
	WOStruct['#attributes.fuseaction#']['upd'] = structNew();
	WOStruct['#attributes.fuseaction#']['upd']['window'] = 'normal';
	WOStruct['#attributes.fuseaction#']['upd']['fuseaction'] = 'cash.form_add_cash_revenue';
	WOStruct['#attributes.fuseaction#']['upd']['filePath'] = 'cash/form/form_cash_revenue.cfm';
	WOStruct['#attributes.fuseaction#']['upd']['queryPath'] = 'cash/query/upd_cash_revenue.cfm';
	WOStruct['#attributes.fuseaction#']['upd']['nextEvent'] = 'cash.form_add_cash_revenue&event=upd';
	WOStruct['#attributes.fuseaction#']['upd']['parameters'] = 'id=##attributes.id##';
	WOStruct['#attributes.fuseaction#']['upd']['Identity'] = '##attributes.id##';
	
	if(not attributes.event is 'add')
	{
		WOStruct['#attributes.fuseaction#']['del'] = structNew();
		WOStruct['#attributes.fuseaction#']['del']['window'] = 'emptypopup';
		WOStruct['#attributes.fuseaction#']['del']['fuseaction'] = '#listgetat(attributes.fuseaction,1,'.')#.del_cash_revenue&id=#attributes.id#&detail=#get_action_detail.paper_no#&old_process_type=#get_action_detail.action_type_id#';
		WOStruct['#attributes.fuseaction#']['del']['filePath'] = 'cash/query/del_cash_revenue.cfm';
		WOStruct['#attributes.fuseaction#']['del']['queryPath'] = 'cash/query/del_cash_revenue.cfm';
		WOStruct['#attributes.fuseaction#']['del']['nextEvent'] = 'cash.list_cash_actions';
	}

	if(attributes.event is 'upd')
	{
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd'] = structNew();
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'] = structNew();
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][0]['text'] = '#lang_array_main.item[1966]#';
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][0]['customTag'] = '<cf_get_workcube_related_acts period_id="#session.ep.period_id#" company_id="#session.ep.company_id#" asset_cat_id="-17" module_id="18" action_section="ACTION_ID" action_id="#attributes.id#">';
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][1]['text'] = '#lang_array_main.item[35]#';
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][1]['onClick'] = "windowopen('#request.self#?fuseaction=account.popup_list_card_rows&action_id=#attributes.id#&process_cat=#get_action_detail.action_type_id#','page');";
		
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons'] = structNew();
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['add']['text'] = '#lang_array_main.item[170]#';
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['add']['href'] = "#request.self#?fuseaction=cash.form_add_cash_revenue";
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['add']['target'] = "_blank";
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['copy']['text'] = '#lang_array_main.item[64]#';
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['copy']['href'] = '#request.self#?fuseaction=cash.form_add_cash_revenue&ID=#get_action_detail.action_id#';
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['copy']['target'] = "_blank";
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['print']['text'] = '#lang_array_main.item[62]#';
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['print']['onClick'] = "windowopen('#request.self#?fuseaction=objects.popup_print_files&action_id=#attributes.id#&print_type=133&action_type=#get_action_detail.action_type_id#','page')";
		tabMenuData = SerializeJSON(tabMenuStruct['#attributes.fuseaction#']['tabMenus']);
	}
	
	WOStruct['#attributes.fuseaction#']['extendedForm'] = structNew();
	WOStruct['#attributes.fuseaction#']['extendedForm']['controllerFileName'] = 'cashRevenue';
	WOStruct['#attributes.fuseaction#']['extendedForm']['eventList'] = 'add,upd';
	WOStruct['#attributes.fuseaction#']['extendedForm']['tableName'] = 'CASH_ACTIONS';
	WOStruct['#attributes.fuseaction#']['extendedForm']['dataSourceName'] = 'period';
	WOStruct['#attributes.fuseaction#']['extendedForm']['settings'] = "['item-processCat','item-cash','item-ch','item-paperNo','item-date','item-amount','item-collector']";
</cfscript>