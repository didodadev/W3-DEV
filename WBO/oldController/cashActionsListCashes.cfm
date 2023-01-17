<cf_get_lang_set module_name="cash">
<cfif (isdefined("attributes.event") and attributes.event eq "list") or not isdefined("attributes.event")>
	<cfparam name="attributes.cash_status" default="1">
	<cfif isdefined("attributes.form_submitted")>
        <cfinclude template="../cash/query/get_cashes_list.cfm">
    <cfelse>
        <cfset get_cashes.recordcount=0>
    </cfif>
    <cfinclude template="../cash/query/get_money.cfm">
    <cfparam name="attributes.keyword" default="">
    <cfparam name="attributes.branch_id" default="">
    <cfparam name="attributes.cash_currency_id" default="">
    <cfparam name="attributes.page" default="1">
    <cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
    <cfparam name="attributes.totalrecords" default=#get_cashes.recordcount#>
    <cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
<cfelseif isdefined("attributes.event") and attributes.event eq "add">
	<cfset attributes.according_to_session=1>
    <cfinclude template="../cash/query/get_com_branch.cfm">
    <cfinclude template="../cash/query/get_money.cfm">
    <cfquery name="get_accounts" datasource="#dsn2#">
        SELECT
            ACCOUNT_CODE,
            ACCOUNT_NAME
        FROM
            ACCOUNT_PLAN
        WHERE
            SUB_ACCOUNT = 0
    </cfquery>
    <cfset cashStatus = "">
    <cfset branchId = "">
    <cfset departmentId = "">
    <cfset cashName = "">
    <cfset cashCode = "">
    <cfset accountCodeId = "">
    <cfset accountCode = "">
    <cfset aChequeAccCodeId = "">
    <cfset aChequeAccCode = "">
    <cfset aVoucherAccCodeId = "">
    <cfset aVoucherAccCode = "">
	<cfset vVoucherAccCodeId = "">
    <cfset vVoucherAccCode = "">
    <cfset dueAccountCodeId = "">
    <cfset dueAccountCode = "">
    <cfset chequeTransferCodeId = "">
    <cfset chequeTransferCode = "">
    <cfset voucherTransferCodeId = "">
    <cfset voucherTransferCode = "">
    <cfset karsiliksizCekId = "">
    <cfset karsiliksizCek = "">
    <cfset protestoluSenetId = "">
    <cfset protestoluSenet = "">
    <cfset cashEmployeeId = "">
    <cfset cashEmployee = "">
    <cfset isAllBranch = "">
<cfelseif isdefined("attributes.event") and attributes.event eq "upd">
	<cfset attributes.according_to_session=1>
    <cfinclude template="../cash/query/get_com_branch.cfm">
    <cfinclude template="../cash/query/get_cash_detail.cfm">
    <cfinclude template="../cash/query/get_com_department.cfm">
    <cfquery name="GET_PAYMENT_TYPE_ROW" datasource="#DSN2#">
        SELECT
            C.*,
            A.ACCOUNT_NAME
        FROM
            CASH_PAYMENT_TYPE_ROW C,
            ACCOUNT_PLAN A
        WHERE
            C.CASH_ID = #attributes.id# AND
            C.POS_ACCOUNT_CODE = A.ACCOUNT_CODE	
    </cfquery>
    <cfset row = get_payment_type_row.recordcount>
    <cfquery name="GET_CASH_ACT" datasource="#DSN2#">
        SELECT
            ACTION_ID
        FROM
            CASH_ACTIONS
        WHERE
            CASH_ACTION_FROM_CASH_ID = #attributes.id# OR
            CASH_ACTION_TO_CASH_ID = #attributes.id#
    </cfquery>
    <cfquery name="GET_ACCOUNTS" datasource="#DSN2#">
        SELECT
            ACCOUNT_CODE,
            ACCOUNT_NAME
        FROM
            ACCOUNT_PLAN
        WHERE
            SUB_ACCOUNT = 0
    </cfquery>
    <cfquery name="GET_ACC_1" datasource="#DSN2#">
        SELECT
            ACCOUNT_NAME
        FROM
            ACCOUNT_PLAN
        WHERE
            ACCOUNT_CODE = '#get_cash_detail.due_diff_acc_code#'
    </cfquery>
    <cfquery name="GET_ACC_2" datasource="#DSN2#">
        SELECT
            ACCOUNT_NAME
        FROM
            ACCOUNT_PLAN
        WHERE
            ACCOUNT_CODE = '#get_cash_detail.transfer_cheque_acc_code#'
    </cfquery>
    <cfquery name="GET_ACC_3" datasource="#DSN2#">
        SELECT
            ACCOUNT_NAME
        FROM
            ACCOUNT_PLAN
        WHERE
            ACCOUNT_CODE = '#get_cash_detail.transfer_voucher_acc_code#'
    </cfquery>
    <cfquery name="GET_ACC_4" datasource="#DSN2#">
        SELECT
            ACCOUNT_NAME
        FROM
            ACCOUNT_PLAN
        WHERE
            ACCOUNT_CODE = '#get_cash_detail.V_VOUCHER_ACC_CODE#'
    </cfquery>
    <cfquery name="GET_ACC_5" datasource="#DSN2#">
        SELECT
            ACCOUNT_NAME
        FROM
            ACCOUNT_PLAN
        WHERE
            ACCOUNT_CODE = '#get_cash_detail.A_VOUCHER_ACC_CODE#'
    </cfquery>
    <cfquery name="GET_ACC_6" datasource="#DSN2#">
        SELECT
            ACCOUNT_NAME
        FROM
            ACCOUNT_PLAN
        WHERE
            ACCOUNT_CODE = '#get_cash_detail.A_CHEQUE_ACC_CODE#'
    </cfquery>
    <cfquery name="GET_ACC_7" datasource="#DSN2#">
        SELECT
            ACCOUNT_NAME
        FROM
            ACCOUNT_PLAN
        WHERE
            ACCOUNT_CODE = '#get_cash_detail.cash_acc_code#'
    </cfquery>
    <cfquery name="GET_ACC_8" datasource="#DSN2#">
        SELECT
            ACCOUNT_NAME
        FROM
            ACCOUNT_PLAN
        WHERE
            ACCOUNT_CODE = '#get_cash_detail.KARSILIKSIZ_CEKLER_CODE#'
    </cfquery>
    <cfquery name="GET_ACC_9" datasource="#DSN2#">
        SELECT
            ACCOUNT_NAME
        FROM
            ACCOUNT_PLAN
        WHERE
            ACCOUNT_CODE = '#get_cash_detail.PROTESTOLU_SENETLER_CODE#'
    </cfquery>
    <cfset cashStatus = get_cash_detail.cash_status>
    <cfset branchId = get_cash_detail.branch_id>
    <cfset departmentId = get_cash_detail.department_id>
    <cfset cashName = get_cash_detail.cash_name>
    <cfset cashCode = get_cash_detail.cash_code>
    <cfset accountCodeId = get_cash_detail.cash_acc_code>
    <cfset accountCode = get_cash_detail.cash_acc_code & ' - ' & get_acc_7.account_name>
    <cfset aChequeAccCodeId = get_cash_detail.A_CHEQUE_ACC_CODE>
    <cfset aChequeAccCode = get_cash_detail.A_CHEQUE_ACC_CODE & ' - ' & get_acc_6.account_name>
    <cfset aVoucherAccCodeId = get_cash_detail.a_voucher_acc_code>
    <cfset aVoucherAccCode = get_cash_detail.a_voucher_acc_code & ' - ' & get_acc_5.account_name>
	<cfset vVoucherAccCodeId = get_cash_detail.V_VOUCHER_ACC_CODE>
    <cfset vVoucherAccCode = get_cash_detail.V_VOUCHER_ACC_CODE & ' - ' & get_acc_4.account_name>
    <cfset dueAccountCodeId = get_cash_detail.due_diff_acc_code>
    <cfset dueAccountCode = get_cash_detail.due_diff_acc_code & ' - ' & get_acc_1.account_name>
    <cfset chequeTransferCodeId = get_cash_detail.transfer_cheque_acc_code>
    <cfset chequeTransferCode = get_cash_detail.transfer_cheque_acc_code & ' - ' & get_acc_2.account_name>
    <cfset voucherTransferCodeId = get_cash_detail.transfer_voucher_acc_code>
    <cfset voucherTransferCode = get_cash_detail.transfer_voucher_acc_code & ' - ' & get_acc_3.account_name>
    <cfset karsiliksizCekId = get_cash_detail.karsiliksiz_cekler_code>
    <cfset karsiliksizCek = get_cash_detail.karsiliksiz_cekler_code & ' - ' & get_acc_8.account_name>
    <cfset protestoluSenetId = get_cash_detail.protestolu_senetler_code>
    <cfset protestoluSenet = get_cash_detail.protestolu_senetler_code & ' - ' & get_acc_9.account_name>
    <cfset cashEmployeeId = get_cash_detail.emp_id>
    <cfset cashEmployee = get_emp_info(get_cash_detail.emp_id,0,0)>
    <cfset isAllBranch = "">
</cfif>
<script type="text/javascript">
	<cfif (isdefined("attributes.event") and attributes.event eq "list") or not isdefined("attributes.event")>
		$(document).ready(function(){
			document.getElementById('keyword').focus();	
		});
	<cfelseif isdefined("attributes.event") and (attributes.event eq "add" or attributes.event eq "upd")>
		my_arr=new Array();
		<cfloop  from="1" to="#get_com_branch.recordcount#" index="i">
			<cfset s=#get_com_branch.BRANCH_ID[i]#>
			my_arr[<cfoutput>#s#</cfoutput>] = new Array(3);
			<cfquery name="get_deps" datasource="#DSN#">
				SELECT
					 BRANCH_ID,
					 DEPARTMENT_ID,
					 DEPARTMENT_HEAD  
				FROM
					DEPARTMENT
				WHERE
					BRANCH_ID=#get_com_branch.BRANCH_ID[i]#
				ORDER BY
					DEPARTMENT_HEAD
			</cfquery>
			<cfset say=0>
			<cfoutput query="get_deps" >
				my_arr[#s#][#say#]='#DEPARTMENT_HEAD#';
				<cfset say=say+1>				
				my_arr[#s#][#say#]=#DEPARTMENT_ID#;
				<cfset say=say+1>				
			</cfoutput>
		</cfloop>
		
		function get_departments(x)
		{
			temp_opt=add_cash.department_id;
			for (m=add_cash.department_id.options.length-1;m>=0;m--)
				temp_opt.options[m]=null;		
				
			i=add_cash.branch_id.options[x].value;
			s=0;
			for(j=0;j<my_arr[i].length;j+=2){
				temp_opt.options[s]=null;
				temp_opt.options[s]=new Option(my_arr[i][j],my_arr[i][j+1]);
				s=s+1;
			}
			for (m=add_cash.department_id.options.length-1;m>=0;m--){
				if(temp_opt.options[m].value == "")
				{
					temp_opt.options[m]=null;	
				}
			}
		}
		
		function kontrol()
		{
			if (document.getElementById('branch_id').value == '')
			{
				alert("<cf_get_lang_main no='782.Zorunlu Alan'>:<cf_get_lang_main no='41.Sube'>");
				return false;
			}
			if (document.getElementById('department_id').value == '')
			{
				alert("<cf_get_lang_main no='782.Zorunlu Alan'>:<cf_get_lang_main no='160.Departman'>");
				return false;
			}
			if (document.getElementById('cash_name').value == '')
			{
				alert("<cf_get_lang_main no='782.Zorunlu Alan'>:<cf_get_lang no='60.Kasa Adi'>");
				return false;
			}
			<cfif isdefined("attributes.event") and attributes.event eq "add">
				if (document.getElementById('currency_id').value == '')
				{
					alert("<cf_get_lang_main no='782.Zorunlu Alan'>:<cf_get_lang_main no='77.Para Birimi'>");
					return false;
				}
			</cfif>
			if (document.getElementById('account_id').value == "" || document.getElementById('account_name').value == "")
			{ 
				alert ("<cf_get_lang_main no='782.Zorunlu Alan'>:<cf_get_lang no='72.Kasa Muhasebe Kodu'>");
				return false;
			}	
			if (document.getElementById('a_cheque_account_id').value == "" || document.getElementById('a_cheque_account_name').value == "")
			{ 
				alert ("<cf_get_lang_main no='782.Zorunlu Alan'>:<cf_get_lang no='73.Alınan Çek Muhasebe Kodu'>");
				return false;
			}
			if (document.getElementById("karsiliksiz_cekler_id").value == "" || document.getElementById("karsiliksiz_cekler_name").value == "")
			{ 
				alert ("<cf_get_lang_main no='782.Zorunlu Alan'>: Karşılıksız Çekler");
				return false;
			}
			if (document.getElementById("protestolu_senetler_id").value == "" || document.getElementById("protestolu_senetler_name").value == "")
			{ 
				alert ("<cf_get_lang_main no='782.Zorunlu Alan'>: Protestolu Senetler");
				return false;
			}
			return true;
		}	
	</cfif>
	<cfif isdefined("attributes.event") and attributes.event eq "upd">
		function pencere_ac_acc(no)
		{
			windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_account_plan&field_name=upd_cash.account_code_name' + no +'&field_id=upd_cash.account_code' + no +'','list');
		}
	</cfif>
</script>
<cfscript>
	// Switch //
	WOStruct = StructNew();
	
	WOStruct['#attributes.fuseaction#'] = structNew();
	
	WOStruct['#attributes.fuseaction#']['default'] = 'list';
	
	if(not isDefined("attributes.event"))
		attributes.event = WOStruct['#attributes.fuseaction#']['default'];

	WOStruct['#attributes.fuseaction#']['list'] = structNew();
	WOStruct['#attributes.fuseaction#']['list']['window'] = 'normal';
	WOStruct['#attributes.fuseaction#']['list']['fuseaction'] = 'cash.list_cashes';
	WOStruct['#attributes.fuseaction#']['list']['filePath'] = 'cash/display/list_cashes.cfm';

	WOStruct['#attributes.fuseaction#']['add'] = structNew();
	WOStruct['#attributes.fuseaction#']['add']['window'] = 'normal';
	WOStruct['#attributes.fuseaction#']['add']['fuseaction'] = 'cash.list_cashes';
	WOStruct['#attributes.fuseaction#']['add']['filePath'] = 'cash/form/form_cash.cfm';
	WOStruct['#attributes.fuseaction#']['add']['queryPath'] = 'cash/query/add_cash.cfm';
	WOStruct['#attributes.fuseaction#']['add']['nextEvent'] = 'cash.list_cashes';

	WOStruct['#attributes.fuseaction#']['upd'] = structNew();
	WOStruct['#attributes.fuseaction#']['upd']['window'] = 'normal';
	WOStruct['#attributes.fuseaction#']['upd']['fuseaction'] = 'cash.list_cashes';
	WOStruct['#attributes.fuseaction#']['upd']['filePath'] = 'cash/form/form_cash.cfm';
	WOStruct['#attributes.fuseaction#']['upd']['queryPath'] = 'cash/query/upd_cash.cfm';
	WOStruct['#attributes.fuseaction#']['upd']['nextEvent'] = 'cash.list_cashes';
	WOStruct['#attributes.fuseaction#']['upd']['parameters'] = 'id=##attributes.id##';
	WOStruct['#attributes.fuseaction#']['upd']['Identity'] = '##attributes.id##';
	
	if(attributes.event is 'upd' or attributes.event is 'del')
	{
		WOStruct['#attributes.fuseaction#']['del'] = structNew();
		WOStruct['#attributes.fuseaction#']['del']['window'] = 'emptypopup';
		WOStruct['#attributes.fuseaction#']['del']['fuseaction'] = '#listgetat(attributes.fuseaction,1,'.')#.del_cash&id=#attributes.id#';
		WOStruct['#attributes.fuseaction#']['del']['filePath'] = 'cash/query/del_cash.cfm';
		WOStruct['#attributes.fuseaction#']['del']['queryPath'] = 'cash/query/del_cash.cfm';
		WOStruct['#attributes.fuseaction#']['del']['nextEvent'] = 'cash.list_cashes';
	}
	
	if(attributes.event is 'upd')
	{
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons'] = structNew();
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['add']['text'] = '#lang_array_main.item[170]#';
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['add']['href'] = "#request.self#?fuseaction=cash.list_cashes&event=add";
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['add']['target'] = "_blank";
		tabMenuData = SerializeJSON(tabMenuStruct['#attributes.fuseaction#']['tabMenus']);
	}
	WOStruct['#attributes.fuseaction#']['extendedForm'] = structNew();
	WOStruct['#attributes.fuseaction#']['extendedForm']['controllerFileName'] = 'cashActionsListCashes';
	WOStruct['#attributes.fuseaction#']['extendedForm']['eventList'] = 'add,upd';
	WOStruct['#attributes.fuseaction#']['extendedForm']['tableName'] = 'CASH';
	WOStruct['#attributes.fuseaction#']['extendedForm']['dataSourceName'] = 'period';
	if(attributes.event is "add")
		WOStruct['#attributes.fuseaction#']['extendedForm']['settings'] = "['item-branch_id','item-department_id','item-cash_name','item-currency_id','item-account_id','item-a_cheque_account_id','item-karsiliksiz_cekler_id','item-protestolu_senetler_id']";
	else if(attributes.event is "upd")
		WOStruct['#attributes.fuseaction#']['extendedForm']['settings'] = "['item-branch_id','item-department_id','item-cash_name','item-account_id','item-a_cheque_account_id','item-karsiliksiz_cekler_id','item-protestolu_senetler_id']";
</cfscript>
