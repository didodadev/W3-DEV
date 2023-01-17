<cf_papers paper_type="debit_claim">
<cf_xml_page_edit fuseact="ch.popup_form_add_debit_claim_note">
<cf_get_lang_set module_name="ch">
<cfquery name="GET_MONEY_RATE" datasource="#DSN2#">
	SELECT MONEY_ID,MONEY FROM SETUP_MONEY WHERE MONEY_STATUS = 1 ORDER BY MONEY_ID
</cfquery>
<cfif isdefined("attributes.id") and len(attributes.id)>
	<cfquery name="GET_NOTE" datasource="#DSN2#">
		SELECT 
			* 
		FROM 
			CARI_ACTIONS 
		WHERE 
			ACTION_ID = #attributes.id#
	</cfquery>
    <cfif get_note.action_type_id eq 41>
        <cfquery name="GET_COST_WITH_EXPENSE_ROWS_ID_CLAIM" datasource="#dsn2#">
                SELECT * FROM EXPENSE_ITEMS_ROWS WHERE ACTION_ID = #attributes.ID# AND EXPENSE_COST_TYPE = #get_note.action_type_id#
            </cfquery>
            <cfif len(GET_COST_WITH_EXPENSE_ROWS_ID_CLAIM.expense_center_id)>
              <cfquery name="GET_EXPENSE" datasource="#dsn2#">
                  SELECT EXPENSE FROM EXPENSE_CENTER WHERE EXPENSE_ID = #GET_COST_WITH_EXPENSE_ROWS_ID_CLAIM.EXPENSE_CENTER_ID#
              </cfquery>
            <cfelse>
            	<cfset GET_EXPENSE.recordcount = 0>
            </cfif>
            <cfif len(GET_COST_WITH_EXPENSE_ROWS_ID_CLAIM.expense_item_id)>
                <cfquery name="GET_EXPENSE_ITEM" datasource="#dsn2#">
                    SELECT EXPENSE_ITEM_NAME FROM EXPENSE_ITEMS WHERE EXPENSE_ITEM_ID = #GET_COST_WITH_EXPENSE_ROWS_ID_CLAIM.EXPENSE_ITEM_ID#
                </cfquery>
            </cfif>
     <cfelse>
        <cfquery name="GET_COST_WITH_EXPENSE_ROWS_ID_DEBIT" datasource="#iif(fusebox.use_period,'dsn2','dsn')#">
            SELECT * FROM EXPENSE_ITEMS_ROWS WHERE ACTION_ID = #attributes.ID# AND EXPENSE_COST_TYPE = #get_note.action_type_id#
        </cfquery>
        <cfif len(GET_COST_WITH_EXPENSE_ROWS_ID_DEBIT.expense_center_id)>
          <cfquery name="GET_EXPENSE_A" datasource="#iif(fusebox.use_period,'dsn2','dsn')#">
              SELECT EXPENSE FROM EXPENSE_CENTER WHERE EXPENSE_ID = #GET_COST_WITH_EXPENSE_ROWS_ID_DEBIT.EXPENSE_CENTER_ID#
          </cfquery>
        <cfelse>
            <cfset GET_EXPENSE_A.recordcount = 0>
        </cfif>
        <cfif len(GET_COST_WITH_EXPENSE_ROWS_ID_DEBIT.expense_item_id)>
            <cfquery name="GET_EXPENSE_ITEM_A" datasource="#iif(fusebox.use_period,'dsn2','dsn')#">
                SELECT EXPENSE_ITEM_NAME FROM EXPENSE_ITEMS WHERE EXPENSE_ITEM_ID = #GET_COST_WITH_EXPENSE_ROWS_ID_DEBIT.EXPENSE_ITEM_ID#
            </cfquery>
        </cfif>
    </cfif>
	<cfif len(get_note.contract_id)>
        <cfquery name="getContract" datasource="#dsn3#">
            SELECT CONTRACT_HEAD FROM RELATED_CONTRACT WHERE CONTRACT_ID = #get_note.contract_id#
        </cfquery>
    </cfif>
    
    <cfif IsDefined("attributes.event") and attributes.event eq 'upd'>
		<cfquery name="control_payment" datasource="#dsn2#">
            SELECT I.CAMPAIGN_ID FROM INVOICE_MULTILEVEL_PAYMENT_ROWS IR,INVOICE_MULTILEVEL_PAYMENT I WHERE I.INV_PAYMENT_ID = IR.INV_PAYMENT_ID AND IR.CARI_ACTION_ID IS NOT NULL AND IR.CARI_ACTION_ID = #get_note.action_id#
        </cfquery>	
        <cfif control_payment.recordcount neq 0>
        	<cfquery name="get_camp_head" datasource="#dsn3#">
                SELECT CAMP_HEAD FROM CAMPAIGNS WHERE CAMP_ID = #control_payment.campaign_id#
            </cfquery>
        </cfif>
    </cfif>
<cfelseif isDefined("attributes.project_id") and Len(attributes.project_id)>
	<cfquery name="get_project_info" datasource="#dsn#">
		SELECT COMPANY_ID,PARTNER_ID,CONSUMER_ID FROM PRO_PROJECTS WHERE PROJECT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.project_id#">
	</cfquery>
	<cfif len(get_project_info.partner_id)>
		<cfset attributes.to_cmp_id = get_project_info.company_id>
		<cfset attributes.from_cmp_id = get_project_info.company_id>
	<cfelseif len(get_project_info.consumer_id)>
		<cfset attributes.to_consumer_id = get_project_info.consumer_id>
		<cfset attributes.to_consumer_id = get_project_info.consumer_id>
	</cfif>
</cfif>
<cfif IsDefined("attributes.id") and len(attributes.id)>
	<cfset attributes.process_cat =	get_note.process_cat>
    <cfset attributes.action_id =get_note.action_id>
	<cfset attributes.to_employee_id = get_note.acc_type_id>
    <cfset attributes.from_employee_id = get_note.from_employee_id>
    <cfset attributes.acc_type_id = get_note.acc_type_id>
    <cfset attributes.action_type_id = get_note.action_type_id>
    <cfset attributes.TO_CMP_ID = get_note.TO_CMP_ID>
    <cfset attributes.TO_CONSUMER_ID = get_note.TO_CONSUMER_ID>
    <cfset attributes.from_cmp_id = get_note.from_cmp_id>
    <cfset attributes.from_consumer_id = get_note.from_consumer_id>
    <cfset attributes.action_value = get_note.action_value>
    <cfset attributes.action_currency_id = get_note.ACTION_CURRENCY_ID>
    <cfset attributes.other_cash_act_value = get_note.other_cash_act_value>
    <cfset attributes.ACC_BRANCH_ID = get_note.ACC_BRANCH_ID>
    <cfset attributes.ACC_DEPARTMENT_ID = get_note.ACC_DEPARTMENT_ID>
    <cfset attributes.project_id = get_note.project_id>
    <cfset attributes.assetp_id = get_note.assetp_id>
    <cfset attributes.contract_id = get_note.contract_id>
    <cfif len(attributes.contract_id)>
        <cfset attributes.contract_head = getContract.contract_head>
    <cfelse>
    	<cfset attributes.contract_head = "">
    </cfif>
    <cfif IsDefined("attributes.event") and attributes.event eq 'upd'>
        <cfset paper_number_ = get_note.paper_no>
    <cfelse>
        <cfset paper_number_ = paper_code & '-' & paper_number>
   </cfif> 
    <cfset attributes.action_account_code = get_note.action_account_code>
    <cfset attributes.action_date = get_note.action_date>
    <cfset attributes.ACTION_DETAIL = get_note.ACTION_DETAIL>
    <cfif attributes.action_type_id eq 41>
    	<cfset attributes.expense_center_id_claim = GET_COST_WITH_EXPENSE_ROWS_ID_CLAIM.expense_center_id>
        <cfif IsDefined("get_expense.expense") and len(get_expense.expense)>
        	<cfset attributes.expense_claim = get_expense.expense>
        <cfelse>
        	<cfset attributes.expense_claim = "">
        </cfif>
         <cfset attributes.expense_item_id_claim = GET_COST_WITH_EXPENSE_ROWS_ID_CLAIM.expense_item_id>
        <cfif IsDefined("get_expense_item.expense_item_name") and len(get_expense_item.expense_item_name)>
        	 <cfset attributes.expense_item_name_claim = get_expense_item.expense_item_name>
        <cfelse>
        	 <cfset attributes.expense_item_name_claim = "">
        </cfif>
        <cfset attributes.expense_center_id_debit = "">
		<cfset attributes.expense_debit = "">
        <cfset attributes.expense_item_id_debit = "">
        <cfset attributes.expense_item_name_debit = "">
    <cfelse>
   		<cfset attributes.expense_center_id_claim = "">
		<cfset attributes.expense_claim = "">
        <cfset attributes.expense_item_id_claim = "">
        <cfset attributes.expense_item_name_claim = "">
    	<cfset attributes.expense_center_id_debit = GET_COST_WITH_EXPENSE_ROWS_ID_DEBIT.expense_center_id>
        <cfif IsDefined("get_expense_a.expense") and  len(get_expense_a.expense)>
        	<cfset attributes.expense_debit = get_expense_a.expense>
        <cfelse>
        	<cfset attributes.expense_debit = "">
        </cfif>
		<cfset attributes.expense_item_id_debit = GET_COST_WITH_EXPENSE_ROWS_ID_DEBIT.expense_item_id>
        <cfif IsDefined("get_expense_item_a.expense_item_name") and len(get_expense_item_a.expense_item_name)>
        	<cfset attributes.expense_item_name_debit = get_expense_item_a.expense_item_name>
        <cfelse>
        	<cfset attributes.expense_item_name_debit = "">
        </cfif>
        
    </cfif>
<cfelse>
    <cfset paper_number_ = paper_code & '-' & paper_number>
    <cfif not IsDefined("attributes.event") or (IsDefined("attributes.event") and attributes.event eq 'add')>
        <cfparam name="attributes.process_cat" default="">
        <cfparam name="attributes.expense_center_id_claim" default="">
        <cfparam name="attributes.expense_claim" default="">
        <cfparam name="attributes.expense_item_id_claim" default="">
        <cfparam name="attributes.expense_item_name_claim" default="">
        <cfparam name="attributes.expense_center_id_debit" default="">
        <cfparam name="attributes.expense_debit" default="">
        <cfparam name="attributes.expense_item_id_debit" default="">
        <cfparam name="attributes.expense_item_name_debit" default="">
        <cfparam name="attributes.action_id" default="">
        <cfparam name="attributes.action_type_id" default="">
        <cfparam name="attributes.to_employee_id" default="">
        <cfparam name="attributes.acc_type_id" default="">
        <cfparam name="attributes.from_employee_id" default="">
        <cfparam name="attributes.to_cmp_id" default="">
        <cfparam name="attributes.to_consumer_id" default="">
        <cfparam name="attributes.from_cmp_id" default="">
        <cfparam name="attributes.from_consumer_id" default="">
        <cfparam name="attributes.action_value" default="">
        <cfparam name="attributes.other_cash_act_value" default="">
        <cfparam name="attributes.action_currency_id" default="#session.ep.money#">
        <cfparam name="attributes.acc_branch_id" default="">
        <cfparam name="attributes.acc_department_id" default="">
        <cfparam name="attributes.project_id" default="">
        <cfparam name="attributes.assetp_id" default="">
        <cfparam name="attributes.action_date" default="#now()#">
        <cfparam name="attributes.contract_id" default="">
        <cfparam name="attributes.contract_head" default="">
        <cfparam name="attributes.action_account_code" default="">
        <cfparam name="attributes.action_detail" default="">
    <cfelse>
        <cfset refmodule="#listgetat(attributes.fuseaction,1,'.')#">
    </cfif>
</cfif>
<cfif attributes.action_type_id eq 41>
	<cfset emp_id = attributes.to_employee_id>
    <cfif len(attributes.acc_type_id)>
        <cfset emp_id = "#emp_id#_#attributes.acc_type_id#">
    </cfif>
<cfelse>
	<cfset attributes.to_cmp_id = attributes.from_cmp_id>
    <cfset attributes.TO_CONSUMER_ID = attributes.from_consumer_id>
    <cfset emp_id = attributes.from_employee_id>
    <cfif len(attributes.acc_type_id)>
        <cfset emp_id = "#emp_id#_#attributes.acc_type_id#">
    </cfif>
</cfif>	
<cfset member_name = "">
<cfif len(attributes.from_cmp_id)>
	<cfset member_name = get_par_info(attributes.from_cmp_id,1,1,0)>
<cfelseif len(attributes.to_cmp_id)>
	<cfset member_name = get_par_info(attributes.to_cmp_id,1,1,0)>
<cfelseif len(attributes.from_consumer_id)>
	<cfset member_name = get_cons_info(attributes.from_consumer_id,0,0)>
<cfelseif len(attributes.to_consumer_id)>
	<cfset member_name = get_cons_info(attributes.to_consumer_id,0,0)>
<cfelseif len(attributes.to_employee_id)>
	<cfset member_name = get_emp_info(attributes.to_employee_id,0,0,0,attributes.acc_type_id)>
<cfelseif len(attributes.from_employee_id)>
	<cfset member_name = get_emp_info(attributes.from_employee_id,0,0,0,attributes.acc_type_id)>
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
	WOStruct['#attributes.fuseaction#']['add']['fuseaction'] = 'ch.form_add_debit_claim_note';
	WOStruct['#attributes.fuseaction#']['add']['filePath'] = 'ch/form/form_debit_claim_note.cfm';
	WOStruct['#attributes.fuseaction#']['add']['queryPath'] = 'ch/query/add_debit_claim_note.cfm';
	WOStruct['#attributes.fuseaction#']['add']['nextEvent'] = 'ch.form_add_debit_claim_note&event=upd';
	
	WOStruct['#attributes.fuseaction#']['upd'] = structNew();
	WOStruct['#attributes.fuseaction#']['upd']['window'] = 'normal';
	WOStruct['#attributes.fuseaction#']['upd']['fuseaction'] = 'ch.form_add_debit_claim_note';
	WOStruct['#attributes.fuseaction#']['upd']['filePath'] = 'ch/form/form_debit_claim_note.cfm';
	WOStruct['#attributes.fuseaction#']['upd']['queryPath'] = 'ch/query/upd_debit_claim_note.cfm';
	WOStruct['#attributes.fuseaction#']['upd']['nextEvent'] = 'ch.form_add_debit_claim_note&event=upd';
	WOStruct['#attributes.fuseaction#']['upd']['parameters'] = 'id=##attributes.id##';
	WOStruct['#attributes.fuseaction#']['upd']['Identity'] = '##attributes.id##';
	
	if(IsDefined("attributes.event") && (attributes.event is 'upd' || attributes.event is 'del'))
	{
		WOStruct['#attributes.fuseaction#']['del'] = structNew();
		WOStruct['#attributes.fuseaction#']['del']['window'] = 'emptypopup';
		WOStruct['#attributes.fuseaction#']['del']['fuseaction'] = 'ch.form_add_debit_claim_note';
		WOStruct['#attributes.fuseaction#']['del']['filePath'] = 'ch/query/del_debit_claim.cfm';
		WOStruct['#attributes.fuseaction#']['del']['queryPath'] = 'ch/query/del_debit_claim.cfm';
		WOStruct['#attributes.fuseaction#']['del']['nextEvent'] = 'ch.form_add_debit_claim_note';;
	}
	
	if(IsDefined("attributes.event") && attributes.event is 'upd')
	{
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd'] = structNew();
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'] = structNew();
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][0]['text'] = '#lang_array_main.item[1114]#';
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][0]['onClick'] = "openBox('#request.self#?fuseaction=objects.popup_add_collacted_from_file&type=2',this)";
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][1]['text'] = '#lang_array_main.item[1966]#';
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][1]['customTag'] = '<cf_get_workcube_related_acts period_id="#session.ep.period_id#" company_id="#session.ep.company_id#" asset_cat_id="-17" module_id="23" action_section="ACTION_ID" action_id="#get_note.action_id#">';
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][2]['text'] = '#lang_array_main.item[1040]#';
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][2]['onClick'] = "windowopen('#request.self#?fuseaction=account.popup_list_card_rows&action_id=#attributes.id#&process_cat=#get_note.action_type_id#','page','emptypopup_upd_debit_claim_note')";
		
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons'] = structNew();
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['add']['text'] = '#lang_array_main.item[170]#';
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['add']['href'] = "#request.self#?fuseaction=ch.form_add_debit_claim_note";
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['add']['target'] = "_blank";
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['copy']['text'] = '#lang_array_main.item[64]#';
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['copy']['href'] = '#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.form_add_debit_claim_note&id=#attributes.id#';
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['copy']['target'] = "_blank";
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['print']['text'] = '#lang_array_main.item[62]#';
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['print']['onClick'] = "windowopen('#request.self#?fuseaction=objects.popup_print_files&print_type=212&action_id=#get_note.action_id#','page')";
		tabMenuData = SerializeJSON(tabMenuStruct['#attributes.fuseaction#']['tabMenus']);
	} 
	WOStruct['#attributes.fuseaction#']['extendedForm'] = structNew();
	WOStruct['#attributes.fuseaction#']['extendedForm']['controllerFileName'] = 'addDebitClaim';
	WOStruct['#attributes.fuseaction#']['extendedForm']['eventList'] = 'add,upd';
	WOStruct['#attributes.fuseaction#']['extendedForm']['tableName'] = 'CARI_ACTIONS';
	WOStruct['#attributes.fuseaction#']['extendedForm']['dataSourceName'] = 'period';
	WOStruct['#attributes.fuseaction#']['extendedForm']['settings'] = "['process_cat','item1','item3']"; 
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
<cfif IsDefined("attributes.event") and attributes.event eq 'add'>
  	<script type="text/javascript">
	$( document ).ready(function() {
		calc_kur('ACTION_CURRENCY_ID',false);
		if(document.form_debit_claim.process_cat.options[document.form_debit_claim.process_cat.selectedIndex].value)
			ayarla_gizle_goster();
	});

		
	function calc_kur(input_,doviz_tutar_)
	{
		if(document.form_debit_claim.process_cat.options[document.form_debit_claim.process_cat.selectedIndex].value)
		{ 
			var selected_ptype = document.form_debit_claim.process_cat.options[document.form_debit_claim.process_cat.selectedIndex].value;
			
			url_= '/V16/ch/cfc/get_caris.cfc?method=get_is_process_currency';
			
			$.ajax({
				type: "get",
				url: url_,
				data: {selected_ptype: selected_ptype},
				cache: false,
				async: false,
				success: function(read_data){
					data_ = jQuery.parseJSON(read_data.replace('//',''));
					if(data_.DATA.length != 0)
					{
						$.each(data_.DATA,function(i){
							get_is_process_currency=data_.DATA[i][0];						
							});
					}
				}
			});			
			



			
			
			if(get_is_process_currency == 1)
				kur_ekle_f_hesapla(input_,doviz_tutar_,1);
			else
				kur_ekle_f_hesapla(input_,doviz_tutar_,0);	
		}
		else
			kur_ekle_f_hesapla(input_,doviz_tutar_,0);	
	}
	
	function kontrol_()
	{
		<!---Muhasebe hesabı alt hesaplar gelirken üst hesapların yazılamaması kontrolü--->
		var action_account_code = document.getElementById("action_account_code").value;
		if(action_account_code != "")
		{ 
			if(WrkAccountControl(action_account_code, "<cf_get_lang dictionary_id='52213.Muhasebe Hesabı Hesap Planında Tanımlı Değildir!'>" ) == 0)
			return false;
		}
		if(document.form_debit_claim.process_cat.options[document.form_debit_claim.process_cat.selectedIndex].value)
		{
			var selected_ptype = document.form_debit_claim.process_cat.options[document.form_debit_claim.process_cat.selectedIndex].value;
			eval('var proc_control = document.form_debit_claim.ct_process_type_'+selected_ptype+'.value');
		}
		paper_control(document.form_debit_claim.paper_number,'DEBIT_CLAIM');
		if(!chk_period(document.form_debit_claim.action_date,'İşlem')) return false;
		if(!chk_process_cat('form_debit_claim')) return false;
		if(!check_display_files('form_debit_claim')) return false;
		if(document.form_debit_claim.company_id.value=="" && document.form_debit_claim.employee_id.value=="" && document.form_debit_claim.consumer_id.value=="")
		{
			alert("<cf_get_lang_main no='59.Eksik veri'> : <cf_get_lang_main no='107.Cari Hesap'> <cf_get_lang_main no='586.veya'> <cf_get_lang no='189.Çalışan Hesap'>");
			return false;
		}
		if(proc_control == 42)
		{
			if( (form_debit_claim.expense_center_id_debit.value=="" && form_debit_claim.expense_item_id_debit.value != "" && form_debit_claim.expense_item_name_debit.value != "") || (form_debit_claim.expense_center_id_debit.value!="" && form_debit_claim.expense_debit.value!="" && form_debit_claim.expense_item_id_debit.value == "") || (form_debit_claim.expense_debit.value=="" && form_debit_claim.expense_item_name_debit.value != "") || (form_debit_claim.expense_debit.value!="" && form_debit_claim.expense_item_name_debit.value == "") )
			{
				alert("<cf_get_lang_main no='59.Eksik veri'> : <cf_get_lang_main no='1048.Masraf Merkezi'> <cf_get_lang_main no='577.ve'> <cf_get_lang_main no='1139.Gider Kalemi'>");
				return false;
			}
		}
		else
		{
			if( (form_debit_claim.expense_center_id_claim.value=="" && form_debit_claim.expense_item_id_claim.value != "" && form_debit_claim.expense_item_name_claim.value != "") || (form_debit_claim.expense_center_id_claim.value!="" && form_debit_claim.expense_claim.value!="" && form_debit_claim.expense_item_id_claim.value == "") || (form_debit_claim.expense_claim.value=="" && form_debit_claim.expense_item_name_claim.value != "") || (form_debit_claim.expense_claim.value!="" && form_debit_claim.expense_item_name_claim.value == "") )
			{
				alert("<cf_get_lang_main no='59.Eksik veri'> : <cf_get_lang_main no='760.Gelir Merkezi'> <cf_get_lang_main no='577.ve'> <cf_get_lang_main no='761.Gelir Kalemi'>");
				return false;
			}
		}
		<cfif x_required_project eq 1>
			if(document.getElementById('project_id').value == "" || document.getElementById('project_name').value == "")
			{
				alert("<cf_get_lang_main no='1385.Proje Seçiniz'>!");
				return false;
			}
		</cfif>
		process=document.form_debit_claim.process_cat.value;
		var get_process_cat = wrk_safe_query('ch_get_process_cat','dsn3',0,process);
		if(get_process_cat.IS_ACCOUNT == 1)
		{
			if (document.form_debit_claim.action_account_code.value=="")
			{ 
				alert ("<cf_get_lang no='15.Muhasebe Kodu Seçiniz'>!");
				return false;
			}
			var get_account_code = wrk_safe_query('ch_get_account_code','dsn2',0,document.form_debit_claim.action_account_code.value);
			if(get_account_code.recordcount == 0)
			{
				alert("<cf_get_lang no='204.Muhasebe Kodunu kontrol ediniz'>");
				return false;
			}
		}		
		//sysytem amount kontrolu
		if(document.getElementById("system_amount") != undefined && document.getElementById("system_amount").value == '')
		{
			alert("<cf_get_lang_main no='2602.Sistem Tutarı Girmelisiniz'>!");
			return false;
		}
		return true;
	}
	function get_expense()
	{
		<cfif isdefined("x_expense_show") and x_expense_show eq 1>
			var selected_ptype_ = document.form_debit_claim.process_cat.options[document.form_debit_claim.process_cat.selectedIndex].value;
			if(selected_ptype_ != '')
			{
				eval('var proc_control_ = document.form_debit_claim.ct_process_type_'+selected_ptype_+'.value');
				if(proc_control_ == 42 && document.form_debit_claim.employee_id.value!='' && document.form_debit_claim.member_name.value!='')
				{
					employee_id_ = document.form_debit_claim.employee_id.value;
					period_id = document.form_debit_claim.active_period.value;
					var listParam = period_id + "*" + employee_id_;
					var get_expense_center = wrk_safe_query('ch_get_expense_center','dsn',0,listParam);
					if(get_expense_center.recordcount)
					{
						document.form_debit_claim.expense_center_id_debit.value = get_expense_center.EXPENSE_CENTER_ID;
						document.form_debit_claim.expense_item_id_debit.value = get_expense_center.EXPENSE_ITEM_ID;
						document.form_debit_claim.expense_debit.value = get_expense_center.EXPENSE_CODE_NAME;
						document.form_debit_claim.expense_item_name_debit.value = get_expense_center.EXPENSE_ITEM_NAME;
					}
					else
					{
						document.form_debit_claim.expense_center_id_debit.value = '';
						document.form_debit_claim.expense_item_id_debit.value = '';
						document.form_debit_claim.expense_debit.value = '';
						document.form_debit_claim.expense_item_name_debit.value = '';
					}
				}
				if (proc_control_ == 41 && document.form_debit_claim.employee_id.value!='' && document.form_debit_claim.member_name.value!='')
				{
					employee_id_ = document.form_debit_claim.employee_id.value;
					period_id = document.form_debit_claim.active_period.value;
					var listParam = period_id + "*" + employee_id_;
					var get_expense_center = wrk_safe_query('ch_get_expense_center','dsn',0,listParam);
					if(get_expense_center.recordcount)
					{
						document.form_debit_claim.expense_center_id_claim.value = get_expense_center.EXPENSE_CENTER_ID;
						document.form_debit_claim.expense_item_id_claim.value = get_expense_center.EXPENSE_ITEM_ID;
						document.form_debit_claim.expense_claim.value = get_expense_center.EXPENSE_CODE_NAME;
						document.form_debit_claim.expense_item_name_claim.value = get_expense_center.EXPENSE_ITEM_NAME;
					}
					else
					{
						document.form_debit_claim.expense_center_id_claim.value = '';
						document.form_debit_claim.expense_item_id_claim.value = '';
						document.form_debit_claim.expense_claim.value = '';
						document.form_debit_claim.expense_item_name_claim.value = '';
					}
				}
			}
		</cfif>	
	}
	
</script>
</cfif>

<cfif IsDefined("attributes.event") and attributes.event eq 'upd'>
	<script type="text/javascript">
$( document ).ready(function() {
    ayarla_gizle_goster();
	calc_kur('ACTION_CURRENCY_ID',false);
});
	function del_kontrol()
	{
		if(!chk_period(document.form_debit_claim.action_date, 'İşlem')) return false;
		else return true;
	}
	function calc_kur(input_,doviz_tutar_)
	{
		if(document.form_debit_claim.process_cat.options[document.form_debit_claim.process_cat.selectedIndex].value)
		{
			var selected_ptype = document.form_debit_claim.process_cat.options[document.form_debit_claim.process_cat.selectedIndex].value;
			url_= '/V16/ch/cfc/get_caris.cfc?method=get_is_process_currency';
			
			$.ajax({
				type: "get",
				url: url_,
				data: {selected_ptype: selected_ptype},
				cache: false,
				async: false,
				success: function(read_data){
					data_ = jQuery.parseJSON(read_data.replace('//',''));
					if(data_.DATA.length != 0)
					{
						$.each(data_.DATA,function(i){
							get_is_process_currency=data_.DATA[i][0];						
							});
					}
				}
			});			
			
			if(get_is_process_currency.IS_PROCESS_CURRENCY == 1)
				kur_ekle_f_hesapla(input_,doviz_tutar_,1);
			else
				kur_ekle_f_hesapla(input_,doviz_tutar_,0);	
		}
		else
			kur_ekle_f_hesapla(input_,doviz_tutar_,0);	
	}
	function kontrol()
	{
		if(!document.form_debit_claim.process_cat.options[document.form_debit_claim.process_cat.selectedIndex].value)
		{
			alert("<cf_get_lang_main no='1358.İşlem Tipi Seçiniz'>");
			return false;
		}
		<!---Muhasebe hesabı alt hesaplar gelirken üst hesapların yazılamaması kontrolü--->
		var action_account_code = document.getElementById("action_account_code").value;
		if(action_account_code != "")
		{ 
			if(WrkAccountControl(action_account_code,"<cf_get_lang dictionary_id='52213.Muhasebe Hesabı Hesap Planında Tanımlı Değildir!'>") == 0)
			return false;
		}
		if(document.form_debit_claim.process_cat.options[document.form_debit_claim.process_cat.selectedIndex].value)
		{
			var selected_ptype = document.form_debit_claim.process_cat.options[document.form_debit_claim.process_cat.selectedIndex].value;
			eval('var proc_control = document.form_debit_claim.ct_process_type_'+selected_ptype+'.value');
		}
		if(proc_control == 42)
		{
			if( (form_debit_claim.expense_center_id_debit.value=="" && form_debit_claim.expense_item_id_debit.value != "" && form_debit_claim.expense_item_name_debit.value != "") || (form_debit_claim.expense_center_id_debit.value!="" && form_debit_claim.expense_debit.value!="" && form_debit_claim.expense_item_id_debit.value == "") || (form_debit_claim.expense_debit.value=="" && form_debit_claim.expense_item_name_debit.value != "") || (form_debit_claim.expense_debit.value!="" && form_debit_claim.expense_item_name_debit.value == "") )
			{
				alert("<cf_get_lang no='45.Gider Kalemi Seçiniz'>!");
				return false;
			}
		}
		else
		{
			if( (form_debit_claim.expense_center_id_claim.value=="" && form_debit_claim.expense_item_id_claim.value != "" && form_debit_claim.expense_item_name_claim.value != "") || (form_debit_claim.expense_center_id_claim.value!="" && form_debit_claim.expense_claim.value!="" && form_debit_claim.expense_item_id_claim.value == "") || (form_debit_claim.expense_claim.value=="" && form_debit_claim.expense_item_name_claim.value != "") || (form_debit_claim.expense_claim.value!="" && form_debit_claim.expense_item_name_claim.value == "") )
			{
				alert("<cf_get_lang no='46.Lütfen Masraf Merkezi Seçiniz'>!");
				return false;
			}
		}
		if(!chk_period(document.form_debit_claim.action_date, "<cf_get_lang dictionary_id='57692.İşlem'>")) return false;
		if (!chk_process_cat('form_debit_claim')) return false;
		if(!check_display_files('form_debit_claim')) return false;
		if(document.form_debit_claim.company_id.value=="" && document.form_debit_claim.employee_id.value=="" && document.form_debit_claim.consumer_id.value=="")
		{
			alert("<cf_get_lang no='108.Lütfen Cari Hesap Seçiniz'>!");
			return false;
		}
		<cfif x_required_project eq 1>
			if(document.getElementById('project_id').value == "" || document.getElementById('project_name').value == "")
			{
				alert("<cf_get_lang_main no='1385.Proje Seçiniz'>!");
				return false;
			}
		</cfif>
		process=document.form_debit_claim.process_cat.value;
		var get_process_cat = wrk_safe_query('ch_get_process_cat','dsn3',0,process);
		if(get_process_cat.IS_ACCOUNT ==1)
		{
			if (document.form_debit_claim.action_account_code.value=="")
			{ 
				alert ("<cf_get_lang no='15.Muhasebe Kodu Seçiniz'>!");
				return false;
			}
			var get_account_code = wrk_safe_query('ch_get_account_code','dsn2',0,document.form_debit_claim.action_account_code.value);
			if(get_account_code.recordcount == 0)
			{
				alert("<cf_get_lang no='204.Muhasebe Kodunu kontrol ediniz'>");
				return false;
			}
		}
		//sysytem amount kontrolu
		if(document.getElementById("system_amount") != undefined && document.getElementById("system_amount").value == '')
		{
			alert("<cf_get_lang_main no='2602.Sistem Tutarı Girmelisiniz'>!");
			return false;
		}
		return true;
	}
	
	function get_expense()
	{
		<cfif isdefined("x_expense_show") and x_expense_show eq 1>
		
			var selected_ptype_ = document.getElementById("process_cat").value;
			if(selected_ptype_ != '')
			{
				eval('var proc_control_ = document.form_debit_claim.ct_process_type_'+selected_ptype_+'.value');
				if(proc_control_ == 42 && document.form_debit_claim.employee_id.value!='' && document.form_debit_claim.member_name.value!='')
				{
					employee_id_ = document.form_debit_claim.employee_id.value.split("_")[0];;
					period_id = document.form_debit_claim.active_period.value;
					var listParam = period_id + "*" + employee_id_;
					var get_expense_center = wrk_safe_query('ch_get_expense_center','dsn',0,listParam);
					if(get_expense_center.recordcount)
					{
						document.form_debit_claim.expense_center_id_debit.value = get_expense_center.EXPENSE_CENTER_ID;
						document.form_debit_claim.expense_item_id_debit.value = get_expense_center.EXPENSE_ITEM_ID;
						document.form_debit_claim.expense_debit.value = get_expense_center.EXPENSE_CODE_NAME;
						document.form_debit_claim.expense_item_name_debit.value = get_expense_center.EXPENSE_ITEM_NAME;
					}
					else
					{
						document.form_debit_claim.expense_center_id_debit.value = '';
						document.form_debit_claim.expense_item_id_debit.value = '';
						document.form_debit_claim.expense_debit.value = '';
						document.form_debit_claim.expense_item_name_debit.value = '';
					}
				}
				if (proc_control_ == 41 && document.form_debit_claim.employee_id.value!='' && document.form_debit_claim.member_name.value!='')
				{
					employee_id_ = document.form_debit_claim.employee_id.value.split("_")[0];
					period_id = document.form_debit_claim.active_period.value;
					var listParam = period_id + "*" + employee_id_;
					var get_expense_center = wrk_safe_query('ch_get_expense_center','dsn',0,listParam);
					
					if(get_expense_center.recordcount)
					{
						document.getElementById("expense_center_id_claim").value = get_expense_center.EXPENSE_CENTER_ID;
						document.getElementById("expense_item_id_claim").value = get_expense_center.EXPENSE_ITEM_ID;
						document.getElementById("expense_claim").value = get_expense_center.EXPENSE_CODE_NAME;
						document.getElementById("expense_item_name_claim").value = get_expense_center.EXPENSE_ITEM_NAME;
					}
					else
					{
						document.form_debit_claim.expense_center_id_claim.value = '';
						document.form_debit_claim.expense_item_id_claim.value = '';
						document.form_debit_claim.expense_claim.value = '';
						document.form_debit_claim.expense_item_name_claim.value = '';
					}
				}
			}
		</cfif>	
	}
	function ayarla_gizle_goster()
	{
		if(chk_process_cat('form_debit_claim'))
		{
			var selected_ptype = document.form_debit_claim.process_cat.options[document.form_debit_claim.process_cat.selectedIndex].value;
			eval('var proc_control = document.form_debit_claim.ct_process_type_'+selected_ptype+'.value');
			if(proc_control == 42)
			{
				merkez_borc.style.display='';
				kalem_borc.style.display='';
				merkez_alacak.style.display='none';
				kalem_alacak.style.display='none';
			}
			else
			{
				merkez_alacak.style.display='';
				kalem_alacak.style.display='';
				merkez_borc.style.display='none';
				kalem_borc.style.display='none';
			}
		}
		else
		{
			merkez_alacak.style.display='none';
			kalem_alacak.style.display='none';
			merkez_borc.style.display='none';
			kalem_borc.style.display='none';
		}
		get_expense();
		
		/* islem kategorilerine eklenen İşlem Dövizi Kurlarından Hesap Yapılmasın parametresi icin eklendi */
		if(document.form_debit_claim.process_cat.options[document.form_debit_claim.process_cat.selectedIndex].value)
		{
			var selected_ptype = document.form_debit_claim.process_cat.options[document.form_debit_claim.process_cat.selectedIndex].value;
			url_= '/V16/ch/cfc/get_caris.cfc?method=get_is_process_currency';
			
			$.ajax({
				type: "get",
				url: url_,
				data: {selected_ptype: selected_ptype},
				cache: false,
				async: false,
				success: function(read_data){
					data_ = jQuery.parseJSON(read_data.replace('//',''));
					if(data_.DATA.length != 0)
					{
						$.each(data_.DATA,function(i){
							get_is_process_currency=data_.DATA[i][0];						
							});
					}
				}
			});			
			
			url_= '/V16/ch/cfc/get_caris.cfc?method=get_act_value_method';
			
			$.ajax({
				type: "get",
				url: url_,
				data: {selected_ptype: selected_ptype,action_id:document.getElementById("action_id").value},
				cache: false,
				async: false,
				success: function(read_data){
					data_ = jQuery.parseJSON(read_data.replace('//',''));
					if(data_.DATA.length != 0)
					{
						$.each(data_.DATA,function(i){
							get_act_value=data_.DATA[i][0];						
							});
					}
				}
			});			
			if(get_act_value.recordcount)
				temp_system_val = get_act_value.ACTION_VALUE;
			
			if(get_is_process_currency.IS_PROCESS_CURRENCY == 1)
			{	
				$('#tr_system_price').show();
				if(temp_system_val == undefined)
					temp_system_val =  $('#system_amount').val();
				temp_system_val = commaSplit(temp_system_val,2);
				$('#system_amount').remove();
				$('<input>').attr({
					type: 'text',
					id: 'system_amount',
					name: 'system_amount',
					style: 'width:180px;text-align:right;',
					value: temp_system_val
				}).appendTo('#td_system_price');
			}
			else
				$('#tr_system_price').hide();
		}
		else
			$('#tr_system_price').hide();
	}
	
</script>
</cfif>
<script type="text/javascript">
	function ayarla_gizle_goster()
	{
		if(document.form_debit_claim.process_cat.options[document.form_debit_claim.process_cat.selectedIndex].value)	
		{
			if(chk_process_cat('form_debit_claim'))
			{
				var selected_ptype = document.form_debit_claim.process_cat.options[document.form_debit_claim.process_cat.selectedIndex].value;
				eval('var proc_control = document.form_debit_claim.ct_process_type_'+selected_ptype+'.value');
				if(proc_control == 42)
				{
					merkez_borc.style.display='';
					kalem_borc.style.display='';
					merkez_alacak.style.display='none';
					kalem_alacak.style.display='none';
				}
				else
				{
					merkez_alacak.style.display='';
					kalem_alacak.style.display='';
					merkez_borc.style.display='none';
					kalem_borc.style.display='none';
				}
			}
			else
			{
				merkez_alacak.style.display='none';
				kalem_alacak.style.display='none';
				merkez_borc.style.display='none';
				kalem_borc.style.display='none';
			}
			get_expense();
		}
		else
		{
			merkez_alacak.style.display='none';
			kalem_alacak.style.display='none';
			merkez_borc.style.display='none';
			kalem_borc.style.display='none';
		}
		
		/* islem kategorilerine eklenen İşlem Dövizi Kurlarından Hesap Yapılmasın parametresi icin eklendi */
		if(document.form_debit_claim.process_cat.options[document.form_debit_claim.process_cat.selectedIndex].value)
		{
			var selected_ptype = document.form_debit_claim.process_cat.options[document.form_debit_claim.process_cat.selectedIndex].value;
			url_= '/V16/ch/cfc/get_caris.cfc?method=get_is_process_currency';
			
			$.ajax({
				type: "get",
				url: url_,
				data: {selected_ptype: selected_ptype},
				cache: false,
				async: false,
				success: function(read_data){
					data_ = jQuery.parseJSON(read_data.replace('//',''));
					if(data_.DATA.length != 0)
					{
						$.each(data_.DATA,function(i){
							get_is_process_currency=data_.DATA[i][0];						
							});
					}
				}
			});			
			
			
			if(get_is_process_currency.IS_PROCESS_CURRENCY == 1)
			{
				$('#tr_system_price').show();
				temp_system_val =  $('#system_amount').val();
				$('#system_amount').remove();
				$('<input>').attr({
					type: 'text',
					id: 'system_amount',
					name: 'system_amount',
					style: 'width:180px;text-align:right;',
					value: temp_system_val
				}).appendTo('#td_system_price');
			}
			else
				$('#tr_system_price').hide();
		}
		else
			$('#tr_system_price').hide();
	}
	function pencere_ac_member()
	{
		windowopen('index.cfm?fuseaction=objects.popup_list_pars&is_cari_action=1&select_list=1,2,3,9&field_comp_id=form_debit_claim.company_id&field_member_name=form_debit_claim.member_name&field_name=form_debit_claim.member_name&field_consumer=form_debit_claim.consumer_id&field_emp_id=form_debit_claim.employee_id','list');
	}
	function auto_complate_member()
	{
		AutoComplete_Create('member_name','MEMBER_NAME,MEMBER_CODE','MEMBER_NAME,MEMBER_CODE,MEMBER_PARTNER_NAME','get_member_autocomplete','\'1,2,3\',\'\',\'\',\'\',\'2\',\'\',\'\',\'1\'','COMPANY_ID,CONSUMER_ID,EMPLOYEE_ID','company_id,consumer_id,employee_id','','3','180','get_money_info(\'form_debit_claim\',\'action_date\')');
	}
	function pencere_ac_contract()
	{ 
		windowopen('index.cfm?fuseaction=objects.popup_list_contract&field_id=form_debit_claim.contract_id&field_name=form_debit_claim.contract_no','large');
	}
	function pencere_ac_account_code()
	{ 
		windowopen('index.cfm?fuseaction=objects.popup_account_plan&field_id=form_debit_claim.action_account_code','list');
	}
	function auto_complate_account_code()
	{ 
		AutoComplete_Create('action_account_code','ACCOUNT_CODE,ACCOUNT_NAME','ACCOUNT_CODE,ACCOUNT_NAME','get_account_code','0','','','','3','225');
	}
	function pencere_ac_expense_center_id_claim()
	{ 
		windowopen('index.cfm?fuseaction=objects.popup_expense_center&field_name=form_debit_claim.expense_claim&field_id=form_debit_claim.expense_center_id_claim&is_invoice=1','list');
	}
	function pencere_ac_expense_item_id_claim()
	{ 
		windowopen('index.cfm?fuseaction=objects.popup_list_exp_item&field_id=form_debit_claim.expense_item_id_claim&field_name=form_debit_claim.expense_item_name_claim&is_income=1','list');
	}
	function pencere_ac_expense_center_id_debit()
	{ 
		windowopen('index.cfm?fuseaction=objects.popup_expense_center&field_name=form_debit_claim.expense_debit&field_id=form_debit_claim.expense_center_id_debit&is_invoice=1','list');
	}
	function pencere_ac_expense_item_id_debit()
	{ 
		windowopen('index.cfm?fuseaction=objects.popup_list_exp_item&field_id=form_debit_claim.expense_item_id_debit&field_name=form_debit_claim.expense_item_name_debit','list');
	}
</script>
	
