<cfparam name="attributes.keyword" default="">
<cfparam name="attributes.invent_no" default="">
<cfparam name="attributes.account_code" default="">
<cfparam name="attributes.debt_account_code" default="">
<cfparam name="attributes.claim_account_code" default="">
<cfparam name="attributes.expense_center_id" default="">
<cfparam name="attributes.expense_center_name" default="">
<cfparam name="attributes.expense_item_id" default="">
<cfparam name="attributes.expense_item_name" default="">
<cfparam name="attributes.project_id" default="">
<cfparam name="attributes.project_head" default="">
<cfparam name="attributes.invent_status" default="1">
<cfparam name="attributes.entry_date_1" default="">
<cfparam name="attributes.entry_date_2" default="">
<cfif not  IsDefined("attributes.event") or attributes.event eq 'list'>
	<cfif isdefined("attributes.form_varmi")>
    <cfset value = '0'>
	<cfquery name="get_invent1" datasource="#dsn3#">
		SELECT
			I.INVENTORY_ID,
			I.INVENTORY_NAME,
			I.INVENTORY_NUMBER,
			I.ACCOUNT_ID,
			I.DEBT_ACCOUNT_ID,
			I.CLAIM_ACCOUNT_ID,
			I.EXPENSE_CENTER_ID,
			I.EXPENSE_ITEM_ID,
			I.INVENTORY_DURATION,
			I.AMORTIZATON_ESTIMATE,
			I.PROJECT_ID,
            EXPENSE_CENTER.EXPENSE, 
            EXPENSE_CENTER.EXPENSE_ID,
            EXPENSE_ITEMS.EXPENSE_ITEM_NAME,
            EXPENSE_ITEMS.EXPENSE_ITEM_ID,
            PRO_PROJECTS.PROJECT_ID,
            PRO_PROJECTS.PROJECT_HEAD
		FROM
			INVENTORY I
            LEFT JOIN #dsn_alias#.EXPENSE_CENTER ON EXPENSE_CENTER.EXPENSE_ID = I.EXPENSE_CENTER_ID
            LEFT JOIN #dsn_alias#.EXPENSE_ITEMS ON EXPENSE_ITEMS.EXPENSE_ITEM_ID = I.EXPENSE_ITEM_ID
            LEFT JOIN #dsn_alias#.PRO_PROJECTS ON PRO_PROJECTS.PROJECT_ID = I.PROJECT_ID
		WHERE
			I.INVENTORY_ID IS NOT NULL	
			<cfif isdefined("attributes.entry_date_1") and  len(attributes.entry_date_1)>
				AND I.ENTRY_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.entry_date_1#">
			</cfif>
			<cfif isdefined("attributes.entry_date_2") and len(attributes.entry_date_2)>
				AND I.ENTRY_DATE < <cfqueryparam cfsqltype="cf_sql_timestamp" value="#DATE_ADD("d",1,attributes.entry_date_2)#">
			</cfif>
			<cfif isdefined("attributes.keyword") and len(attributes.keyword)>
				AND I.INVENTORY_NAME LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.keyword#%">
			</cfif>
			<cfif isdefined("attributes.invent_no") and len(attributes.invent_no)>
				AND I.INVENTORY_NUMBER LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.invent_no#%">
			</cfif>
			<cfif isdefined("inventory_number") and len(inventory_number)>
				AND I.INVENTORY_NUMBER LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#inventory_number#%">
			</cfif>  
			<cfif isdefined("attributes.account_code") and len(attributes.account_code)>
				AND I.ACCOUNT_ID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.account_code#">
			</cfif>
			<cfif isdefined("attributes.debt_account_code") and len(attributes.debt_account_code)>
				AND I.DEBT_ACCOUNT_ID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.debt_account_code#">
			</cfif>
			<cfif isdefined("attributes.claim_account_code") and len(attributes.claim_account_code)>
				AND I.CLAIM_ACCOUNT_ID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.claim_account_code#">
			</cfif>
			<cfif isdefined("attributes.expense_center_id") and  len(attributes.expense_center_id) and isdefined("attributes.expense_center_name") and len(attributes.expense_center_name)>
				AND I.EXPENSE_CENTER_ID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.expense_center_id#">
			</cfif>
			<cfif isdefined("attributes.expense_item_id") and len(attributes.expense_item_id) and isdefined("attributes.expense_item_name") and len(attributes.expense_item_name)>
				AND I.EXPENSE_ITEM_ID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.expense_item_id#">
			</cfif>
			<cfif isdefined("attributes.project_id") and len(attributes.project_id) and isdefined("attributes.project_head") and len(attributes.project_head)>
            	<cfif attributes.project_id eq -1>
                    AND I.PROJECT_ID IS NULL
                <cfelse>
                    AND I.PROJECT_ID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.project_id#">
                </cfif> 
			</cfif>
			<cfif isDefined("attributes.invent_status") and len(attributes.invent_status)>
				<cfif attributes.invent_status eq 1>
					AND I.LAST_INVENTORY_VALUE > <cfqueryparam cfsqltype="cf_sql_float" value="#value#">
					AND ISNULL((SELECT SUM(ISNULL(IR.STOCK_IN,0)-ISNULL(IR.STOCK_OUT,0)) FROM INVENTORY_ROW IR WHERE IR.INVENTORY_ID = I.INVENTORY_ID),I.QUANTITY) > <cfqueryparam cfsqltype="cf_sql_float" value="#value#">
				<cfelse>
					AND 
					(
                        I.LAST_INVENTORY_VALUE = <cfqueryparam cfsqltype="cf_sql_float" value="#value#">
                        OR 
                        ISNULL((SELECT SUM(ISNULL(IR.STOCK_IN,0)-ISNULL(IR.STOCK_OUT,0)) FROM INVENTORY_ROW IR WHERE IR.INVENTORY_ID = I.INVENTORY_ID),I.QUANTITY)  = <cfqueryparam cfsqltype="cf_sql_float" value="#value#">
					)
				</cfif>
			</cfif>
	</cfquery>
	
<cfelse>
	<cfset get_invent1.recordcount = 0>
    <cfset get_invent1.inventory_number = 0>
</cfif>
	<script type="text/javascript">
		$( document ).ready(function() {
		document.getElementById('keyword').focus();
		});
	function control_form()
	{ 
		if(document.getElementById('action_date').value == '')
		{
			alert("<cf_get_lang_main no='782.Zorunlu Alan'>:<cf_get_lang_main no='467.Islem Tarihi'>");
			return false;
		}
		var check_len = document.getElementsByName('row_check').length;
		var checked_row = 0;
		for(zz=0; zz < check_len; zz++)
		{
			if(document.getElementsByName('row_check')[zz] != undefined && document.getElementsByName('row_check')[zz].checked == true)
			{
				var checked_row = 1;
			}
		}
		if(checked_row == 0)
		{
			alert("<cf_get_lang_main no='2253.Lütfen Satır Seçiniz'> !");
			return false;
		}
		return true;
	}
	function apply_row(type)
	{
		var check_len = document.getElementsByName('row_check').length;
		for(zz=0; zz < check_len; zz++)
		{
			if(document.getElementsByName('row_check')[zz] != undefined && document.getElementsByName('row_check')[zz].checked == true)
			{
				var yy=((document.getElementById('page').value-1)*document.getElementById('maxrows').value)+zz+1;
				if(type == 1)	//proje
				{
					if(document.getElementById('main_project_id').value != '' && document.getElementById('main_project_head').value != '')
					{
						document.getElementById('project_id'+yy).value = document.getElementById('main_project_id').value;
						document.getElementById('project_head'+yy).value = document.getElementById('main_project_head').value;
					}
				}
				else if(type == 2)	//masraf merkezi
				{	
					if(document.getElementById('main_exp_center_id').value != '' && document.getElementById('main_exp_center_name').value != '')
					{
						document.getElementById('exp_center_id'+yy).value = document.getElementById('main_exp_center_id').value;
						document.getElementById('exp_center_name'+yy).value = document.getElementById('main_exp_center_name').value;
					}
				}
				else if(type == 3)	//gider kalemi
				{
					if(document.getElementById('main_exp_item_id').value != '' && document.getElementById('main_exp_item_name').value != '')
					{
						document.getElementById('exp_item_id'+yy).value = document.getElementById('main_exp_item_id').value;
						document.getElementById('exp_item_name'+yy).value = document.getElementById('main_exp_item_name').value;
					}
				}
				else if(type == 4)	//muhasebe kodu
				{	
					if(document.getElementById('main_acc_code').value != '')
						document.getElementById('acc_code'+yy).value = document.getElementById('main_acc_code').value;
				}
				else if(type == 5)	//amortisman borc muhasebe kodu
				{
					if(document.getElementById('main_debt_acc_code').value != '')
						document.getElementById('debt_acc_code'+yy).value = document.getElementById('main_debt_acc_code').value;
				}
				else if(type == 6)	//amortisman alacak muhasebe kodu
				{
					if(document.getElementById('main_claim_acc_code').value != '')
						document.getElementById('claim_acc_code'+yy).value = document.getElementById('main_claim_acc_code').value;
				}
				else if(type == 7) //faydali omur
				{	
					if(document.getElementById('main_inv_duration').value != '')
						document.getElementById('inventory_duration'+yy).value = document.getElementById('main_inv_duration').value;
				}
				else if(type == 8) //amortisman orani
				{	
					if(document.getElementById('main_inv_rate').value != '')
						document.getElementById('inventory_rate'+yy).value = document.getElementById('main_inv_rate').value;
				}
			}
		}
		return true;
	}
</script>
</cfif>
<cfscript>
	// Switch //
	WOStruct = StructNew();
	WOStruct['#attributes.fuseaction#'] = structNew();
	
	WOStruct['#attributes.fuseaction#']['upd'] = structNew();
	WOStruct['#attributes.fuseaction#']['default'] = 'upd';
	WOStruct['#attributes.fuseaction#']['upd']['window'] = 'normal';
	WOStruct['#attributes.fuseaction#']['upd']['fuseaction'] = 'invent.upd_collacted_inventory';
	WOStruct['#attributes.fuseaction#']['upd']['filePath'] = 'inventory/form/upd_collacted_inventory.cfm';
	WOStruct['#attributes.fuseaction#']['upd']['queryPath'] = 'inventory/query/add_inventory_history.cfm';
	WOStruct['#attributes.fuseaction#']['upd']['nextEvent'] = 'invent.upd_collacted_inventory';
	if( not IsDefined("attributes.event") or attributes.event is 'upd')
	{
	WOStruct['#attributes.fuseaction#']['upd']['parameters'] = 'inventory_number=#get_invent1.inventory_number#';
	}
	WOStruct['#attributes.fuseaction#']['upd']['parameters'] = 'form_varmi=1';
	WOStruct['#attributes.fuseaction#']['upd']['Identity'] = '##get_invent1.inventory_number##';
	/*
	
	
	WOStruct['#attributes.fuseaction#']['upd'] = structNew();
	WOStruct['#attributes.fuseaction#']['upd']['window'] = 'normal';
	WOStruct['#attributes.fuseaction#']['upd']['fuseaction'] = 'invent.add_collacted_inventory';
	WOStruct['#attributes.fuseaction#']['upd']['filePath'] = 'inventory/form/upd_collacted_inventory.cfm';
	WOStruct['#attributes.fuseaction#']['upd']['queryPath'] = 'inventory/query/add_inventory_history.cfm';
	WOStruct['#attributes.fuseaction#']['upd']['nextEvent'] = 'invent.add_collacted_inventory&event=upd';
	if( IsDefined("attributes.event") and attributes.event is 'upd')
	{
	WOStruct['#attributes.fuseaction#']['upd']['parameters'] = 'inventory_number=#get_invent1.inventory_number#';
	}
	WOStruct['#attributes.fuseaction#']['upd']['parameters'] = 'form_varmi=1';
	WOStruct['#attributes.fuseaction#']['upd']['Identity'] = '##get_invent1.inventory_number##';
	
	if( IsDefined("attributes.event") and attributes.event is 'del')
	{
		WOStruct['#attributes.fuseaction#']['del'] = structNew();
		WOStruct['#attributes.fuseaction#']['del']['window'] = 'emptypopup';
		WOStruct['#attributes.fuseaction#']['del']['fuseaction'] = '#request.self#?fuseaction=invent.emptypopup_del_invent';
		WOStruct['#attributes.fuseaction#']['del']['filePath'] = 'inventory/query/del_invent.cfm';
		WOStruct['#attributes.fuseaction#']['del']['queryPath'] = 'inventory/query/del_invent.cfm';
		WOStruct['#attributes.fuseaction#']['del']['nextEvent'] = 'invent.add_collacted_inventory&event=add';
	}
	/*
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
	} */
</cfscript>
