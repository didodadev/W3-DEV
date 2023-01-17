<cf_get_lang_set module_name="cash">
<cfif not isdefined("attributes.event")>
	<cfset attributes.event = "add">
</cfif>
<cfinclude template="../cash/query/get_cashes.cfm">
<cfset refmodule="#listgetat(attributes.fuseaction,1,'.')#">
<cfset attributes.table_name = 'CASH_ACTIONS'>
<cfset member_info = "">
<cfset processCat = "">
<cfset specialDef = "">
<cfset emp_id = "">
<cfset company_id = "">
<cfset consumer_id = "">
<cfset paper_info = "">
<cfset projectId = "">
<cfset projectName = "">
<cfset assetId = "">
<cfset payerId = "">
<cfset payer = "">
<cfset expenseCenterId = "">
<cfset expenseItemId = "">
<cfset actionDetail = "">
<cfset actionId = "">
<cfset actionDate = dateformat(now(),'dd/mm/yyyy')>
<cfif not (isdefined("attributes.money_type") and len(attributes.money_type))>
	<cfset attributes.money_type = ""> 
</cfif>
<cfif not isdefined("attributes.order_id")>
	<cfset attributes.order_id = "">
</cfif>
<cfif not isdefined("attributes.order_row_id")>
	<cfset attributes.order_row_id = "">
</cfif>
<cfif not isdefined("attributes.correspondence_info")>
	<cfset attributes.correspondence_info = "">
</cfif>
<cfif isdefined('attributes.date1')>
	<cfset actionDate = attributes.date1>
</cfif>
<cfif isdefined("attributes.id") and isnumeric(attributes.id)>
	<cfset actionId = attributes.id>
	<cfinclude template="../cash/query/get_action_detail.cfm">
	<cfif get_action_detail.recordcount neq 0>
    	<cfif attributes.event eq "add">
            <cfquery name="GET_COST_WITH_EXPENSE_ROWS_ID" datasource="#dsn2#">
                SELECT * FROM EXPENSE_ITEMS_ROWS WHERE ACTION_ID = #attributes.ID# AND EXPENSE_COST_TYPE = #get_action_detail.action_type_id#
            </cfquery>
            <cfif len(get_cost_with_expense_rows_id.expense_center_id)>
              <cfquery name="GET_EXPENSE" datasource="#dsn2#">
                  SELECT * FROM EXPENSE_CENTER WHERE EXPENSE_ID = #GET_COST_WITH_EXPENSE_ROWS_ID.EXPENSE_CENTER_ID#
              </cfquery>
            </cfif>
            <cfif len(get_cost_with_expense_rows_id.expense_item_id)>
                <cfquery name="GET_EXPENSE_ITEM" datasource="#dsn2#">
                    SELECT * FROM EXPENSE_ITEMS WHERE EXPENSE_ITEM_ID = #GET_COST_WITH_EXPENSE_ROWS_ID.EXPENSE_ITEM_ID#
                </cfquery>
            </cfif>  	
        </cfif>
        <cfset processCat = get_action_detail.process_cat>
        <cfset specialDef = get_action_detail.special_definition_id>
		<cfif len(get_action_detail.CASH_ACTION_TO_EMPLOYEE_ID)>
            <cfset member_info = get_emp_info(get_action_detail.CASH_ACTION_TO_EMPLOYEE_ID,0,0,0,get_action_detail.acc_type_id)>
			<cfset emp_id = get_action_detail.CASH_ACTION_TO_EMPLOYEE_ID>
            <cfif len(get_action_detail.acc_type_id)>
                <cfset emp_id = "#emp_id#_#get_action_detail.acc_type_id#">
            </cfif>
        <cfelseif len(get_action_detail.CASH_ACTION_TO_COMPANY_ID)>
            <cfset member_info = get_par_info(get_action_detail.CASH_ACTION_TO_COMPANY_ID,1,1,0)>
            <cfset company_id = get_action_detail.CASH_ACTION_TO_COMPANY_ID>
        <cfelseif len(get_action_detail.CASH_ACTION_TO_CONSUMER_ID)>
            <cfset member_info = get_cons_info(get_action_detail.CASH_ACTION_TO_CONSUMER_ID,0,0)>
            <cfset consumer_id = get_action_detail.CASH_ACTION_TO_CONSUMER_ID>
        <cfelseif isdefined('attributes.company_id') and len(attributes.company_id)>
            <cfset member_info = get_par_info(attributes.company_id,1,1,0)>
            <cfset company_id = attributes.company_id>
        <cfelseif isdefined('attributes.consumer_id') and len(attributes.consumer_id)>
            <cfset member_info = get_cons_info(attributes.consumer_id,0,0)>
            <cfset consumer_id = attributes.consumer_id>
        <cfelseif isdefined('attributes.employee_id') and len(attributes.employee_id)>
        	<cfset emp_id = attributes.employee_id>
			<cfif listlen(attributes.employee_id,'_') eq 2>
                <cfset acc_type_id = listlast(attributes.employee_id,'_')>
                <cfset attributes.employee_id = listfirst(attributes.employee_id,'_')>
            <cfelse>
            	<cfset acc_type_id = "">
            </cfif>
            <cfset member_info = get_emp_info(attributes.employee_id,0,0,0,acc_type_id)>
        </cfif>
        <cfset actionDate = dateformat(get_action_detail.ACTION_DATE,'dd/mm/yyyy')>
		<cfif len(get_action_detail.project_id)>
            <cfquery name="get_project_name" datasource="#dsn#">
                SELECT PROJECT_ID,PROJECT_HEAD FROM PRO_PROJECTS WHERE PROJECT_ID = #get_action_detail.project_id#
            </cfquery>
            <cfset projectId = get_action_detail.project_id>
            <cfset projectName = get_project_name.project_head>
        </cfif>
        <cfset assetId = get_action_detail.assetp_id>
        <cfset payerId = get_action_detail.payer_id>
        <cfset payer = get_emp_info(get_action_detail.payer_id,0,0)>
        <cfset expenseCenterId = get_action_detail.expense_center_id>
        <cfset expenseItemId = get_action_detail.expense_item_id>
        <cfset actionDetail = get_action_detail.action_detail>
    </cfif>
<cfelse>
    <cfset get_action_detail.recordcount = 0>
	<cfset payerId = session.ep.userid>
    <cfset payer = get_emp_info(session.ep.userid,0,0)>
</cfif>
<cfif attributes.event eq "add">
	<cfset cash_status = 1>
    <cfinclude template="../cash/query/control_bill_no.cfm">
    <cf_papers paper_type="cash_payment">
    <cfif len(paper_code) and len(paper_number)>
		<cfset paper_info = paper_code & '-' & paper_number>
     </cfif>
<cfelseif attributes.event eq "upd">
	<cfif not get_action_detail.recordcount>
        <font class="txtbold"><cf_get_lang_main no='1531.Böyle Bir Kayıt Bulunmamaktadır'> !</font>
        <cfexit method="exittemplate">
    <cfelse>
    	<cfset paper_info = get_action_detail.paper_no>
    </cfif>
</cfif>
<script type="text/javascript">
	$(document).ready(function(){
		kur_ekle_f_hesapla('CASH_ACTION_FROM_CASH_ID');
	});
	function hesap_sec()
	{
		if(document.cash_payment.CASH_ACTION_TO_COMPANY_ID.value!='')
		{
			document.cash_payment.CASH_ACTION_TO_COMPANY_ID.value='';
			document.cash_payment.company_name.value='';
		}
		if(document.cash_payment.EMPLOYEE_ID.value!='')
		{
			document.cash_payment.EMPLOYEE_ID.value='';
			document.cash_payment.company_name.value='';
		}
		if(document.cash_payment.CASH_ACTION_TO_CONSUMER_ID.value!='')
		{
			document.cash_payment.CASH_ACTION_TO_CONSUMER_ID.value='';
			document.cash_payment.company_name.value='';
		}
	}
	function kontrol()
	{
		<cfif attributes.event is "upd">
			control_account_process(<cfoutput>'#attributes.id#','#get_action_detail.action_type_id#'</cfoutput>);
		</cfif>
		if(!chk_process_cat('cash_payment')) return false;
		if(!check_display_files('cash_payment')) return false;

		if(document.cash_payment.PAYER_NAME.value=='' )	
		{
			alert("<cf_get_lang no='132.Lütfen Ödeme Yapanı Giriniz !'>");
			return false;
		}
		if(document.cash_payment.company_name.value!="" )
		{
			if (!chk_period(cash_payment.action_date, 'Cari Ödeme')) return false;
		}
		else
		{
			alert("<cf_get_lang no='90.Lütfen Ödeme Yapılan Kişi,Yapan Kişi Veya Çalışanı Seçiniz !'>");
			return false;
		}
		if((cash_payment.CASH_ACTION_TO_COMPANY_ID.value =="") && (cash_payment.CASH_ACTION_TO_CONSUMER_ID.value =="") && (cash_payment.EMPLOYEE_ID.value ==""))
		{
			alert("<cf_get_lang_main no ='782.Zorunlu Alan'>:<cf_get_lang_main no ='107.Cari Hesap'>");
			return false;
		}
		<cfif attributes.event is "add">
			deger1=list_getat(document.cash_payment.CASH_ACTION_FROM_CASH_ID.value,2,';');
			if ((document.cash_payment.money_type_id.value != '')&&(deger1 != document.cash_payment.money_type_id.value))
			{
				if (!confirm("<cf_get_lang no ='206.Kasanın para birimi ödeme emrinin para biriminden farklı'>!"))
				return false;
			}
			
			var parameter = '-1*' + document.cash_payment.paper_number.value + '*32*12';<!--- ödeme işlemine göre paper_no unique olmalı. 32 ödeme işlemi action_type_id, 12 tediye fişi--->
			var parameter_2 = document.cash_payment.paper_number.value + '*12';
			var get_paper_no = wrk_safe_query('csh_get_paper_no_3','dsn2',0,parameter);
			var get_paper_from_account = wrk_safe_query('acc_get_paper_no','dsn2',0,parameter_2);
			if(get_paper_no.recordcount || get_paper_from_account.recordcount)
			{
				alert("<cf_get_lang_main no='710.Girdiğiniz Belge Numarası Kullanılmaktadır'> !");
				if(document.getElementById('paper_number').value.indexOf("-") > 0 )
				{
					var index=document.getElementById('paper_number').value.indexOf("-")+1;
					var index2=document.getElementById('paper_number').value.length;
					var temp = parseInt(document.getElementById('paper_number').value.substring(index,index2));
					temp = temp +1;
					document.getElementById('paper_number').value = document.getElementById('paper_number').value.substring(0,index-1) + '-' + temp;
				}
				else
				{
					document.getElementById('paper_number').value = parseInt(document.getElementById('paper_number').value) + 1;	
				}
				return false;
			}
		<cfelseif attributes.event is "upd">
			var parameter = document.cash_payment.id.value + '*' + document.cash_payment.paper_number.value + '*32*12';<!--- ödeme işlemine göre paper_no unique olmalı. 32 ödeme işlemi action_type_id, 12 tediye fişi--->
			var parameter_2 = document.cash_payment.id.value + '*' + document.cash_payment.paper_number.value + '*12';
			var get_paper_no = wrk_safe_query('csh_get_paper_no_3','dsn2',0,parameter);
			var get_paper_no_from_acc = wrk_safe_query('get_paper_no_from_acc','dsn2',0,parameter_2);<!---ödeme işleminden oluşan tediye fişinin belge numarasıyla manuel olarak eklenmiş tediye fişi de var mı? --->
			if( get_paper_no.recordcount || get_paper_no_from_acc.recordcount)
			{
				alert("<cf_get_lang_main no='710.Girdiğiniz Belge Numarası Kullanılmaktadır'>!");
				return false;
			}
		</cfif>
		return true;
	}
	<cfif attributes.event is "add">
		function unformat_fields() 
		{
			document.cash_payment.exp_emp_id.value = document.cash_payment.EMPLOYEE_ID.value;
		}
	<cfelseif attributes.event is "upd">
		function del_kontrol()
		{
			control_account_process(<cfoutput>'#attributes.id#','#get_action_detail.action_type_id#'</cfoutput>);
			if (!chk_period(cash_payment.action_date, "<cf_get_lang_main no='1764.Cari Ödeme'>")) return false;
			else return true;
		}
	</cfif>
</script>
<cfscript>
	// Switch //
	WOStruct = StructNew();
	
	WOStruct['#attributes.fuseaction#'] = structNew();
	
	WOStruct['#attributes.fuseaction#']['default'] = 'add';
	
	if(not isDefined("attributes.event"))
			attributes.event = WOStruct['#attributes.fuseaction#']['default'];
	
	WOStruct['#attributes.fuseaction#']['add'] = structNew();
	WOStruct['#attributes.fuseaction#']['add']['window'] = 'normal';
	WOStruct['#attributes.fuseaction#']['add']['fuseaction'] = 'cash.form_add_cash_payment';
	WOStruct['#attributes.fuseaction#']['add']['filePath'] = 'cash/form/form_cash_payment.cfm';
	WOStruct['#attributes.fuseaction#']['add']['queryPath'] = 'cash/query/add_cash_payment.cfm';
	WOStruct['#attributes.fuseaction#']['add']['nextEvent'] = 'cash.form_add_cash_payment&event=upd';
	
	WOStruct['#attributes.fuseaction#']['upd'] = structNew();
	WOStruct['#attributes.fuseaction#']['upd']['window'] = 'normal';
	WOStruct['#attributes.fuseaction#']['upd']['fuseaction'] = 'cash.form_add_cash_payment';
	WOStruct['#attributes.fuseaction#']['upd']['filePath'] = 'cash/form/form_cash_payment.cfm';
	WOStruct['#attributes.fuseaction#']['upd']['queryPath'] = 'cash/query/upd_cash_payment.cfm';
	WOStruct['#attributes.fuseaction#']['upd']['nextEvent'] = 'cash.form_add_cash_payment&event=upd';
	WOStruct['#attributes.fuseaction#']['upd']['parameters'] = 'id=##attributes.id##';
	WOStruct['#attributes.fuseaction#']['upd']['Identity'] = '##attributes.id##';
	
	if(attributes.event is 'upd' or attributes.event is 'del')
	{
		WOStruct['#attributes.fuseaction#']['del'] = structNew();
		WOStruct['#attributes.fuseaction#']['del']['window'] = 'emptypopup';
		WOStruct['#attributes.fuseaction#']['del']['fuseaction'] = '#listgetat(attributes.fuseaction,1,'.')#.del_cash_payment&id=#attributes.id#';
		WOStruct['#attributes.fuseaction#']['del']['filePath'] = 'cash/query/del_cash_payment.cfm';
		WOStruct['#attributes.fuseaction#']['del']['queryPath'] = 'cash/query/del_cash_payment.cfm';
		WOStruct['#attributes.fuseaction#']['del']['nextEvent'] = 'cash.list_cash_actions';	
	}
	
	if(attributes.event is 'upd')
	{
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd'] = structNew();
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'] = structNew();
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][0]['text'] = '#lang_array_main.item[1966]#';
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][0]['customTag'] = '<cf_get_workcube_related_acts period_id="#session.ep.period_id#" company_id="#session.ep.company_id#" asset_cat_id="-17" module_id="18" action_section="ACTION_ID" action_id="#attributes.id#">';
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][1]['text'] = '#lang_array_main.item[35]#';
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][1]['onClick'] = "windowopen('#request.self#?fuseaction=account.popup_list_card_rows&action_id=#attributes.id#&process_cat=#get_action_detail.action_type_id#','list','upd_cash_payment');";
		
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons'] = structNew();
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['add']['text'] = '#lang_array_main.item[170]#';
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['add']['href'] = "#request.self#?fuseaction=cash.form_add_cash_payment";
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['add']['target'] = "_blank";
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['copy']['text'] = '#lang_array_main.item[64]#';
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['copy']['href'] = '#request.self#?fuseaction=cash.form_add_cash_payment&ID=#get_action_detail.action_id#';
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['copy']['target'] = "_blank";
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['print']['text'] = '#lang_array_main.item[62]#';
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['print']['onClick'] = "windowopen('#request.self#?fuseaction=objects.popup_print_files&action_id=#attributes.id#&print_type=132&action_type=#get_action_detail.action_type_id#','page')";
		tabMenuData = SerializeJSON(tabMenuStruct['#attributes.fuseaction#']['tabMenus']);
	}

	WOStruct['#attributes.fuseaction#']['extendedForm'] = structNew();
	WOStruct['#attributes.fuseaction#']['extendedForm']['controllerFileName'] = 'cashPayment';
	WOStruct['#attributes.fuseaction#']['extendedForm']['eventList'] = 'add,upd';
	WOStruct['#attributes.fuseaction#']['extendedForm']['tableName'] = 'CASH_ACTIONS';
	WOStruct['#attributes.fuseaction#']['extendedForm']['dataSourceName'] = 'period';
	WOStruct['#attributes.fuseaction#']['extendedForm']['settings'] = "['item-processCat','item-cash','item-ch','item-paperNo','item-date','item-amount','item-payer']";
</cfscript>