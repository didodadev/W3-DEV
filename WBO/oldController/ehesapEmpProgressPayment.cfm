<cfif (isdefined("attributes.event") and attributes.event is 'list') or not isdefined("attributes.event")>
	<cfparam name="attributes.page" default=1>
	<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
	<cfif isdefined('attributes.form_submit')>
		<cfquery name="get_progress_pay" datasource="#dsn#">
			SELECT 
				E.EMPLOYEE_NAME,
				E.EMPLOYEE_SURNAME,
				EP.STARTDATE,
				EP.WORKED_DAY,
				EP.KIDEM_AMOUNT,
				EP.PROGRESS_ID,
				B.BRANCH_NAME,
				O.NICK_NAME
			FROM 
				EMPLOYEE_PROGRESS_PAYMENT EP
				INNER JOIN EMPLOYEES E ON EP.EMPLOYEE_ID = E.EMPLOYEE_ID
				INNER JOIN BRANCH B ON EP.BRANCH_ID = B.BRANCH_ID
				INNER JOIN OUR_COMPANY O ON EP.COMP_ID = O.COMP_ID
			<cfif isdefined("attributes.keyword") and len(attributes.keyword)>
				WHERE
					(E.EMPLOYEE_NAME LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.keyword#%"> OR
					E.EMPLOYEE_SURNAME LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.keyword#%">)
			</cfif>
			ORDER BY
				E.EMPLOYEE_NAME
		</cfquery>
	<cfelse>
		<cfset get_progress_pay.recordcount = 0>
	</cfif>
	<cfparam name="attributes.totalrecords" default="#get_progress_pay.recordcount#">
	<cfscript>
		attributes.startrow=((attributes.page-1)*attributes.maxrows)+1;
		url_str = "";
		if (isdefined('attributes.form_submit'))
			url_str ="#url_str#&form_submit=#attributes.form_submit#";
		if (isdefined('attributes.branch_id') and len(attributes.branch_id))
			url_str ="#url_str#&branch_id=#attributes.branch_id#";
		if (isdefined('attributes.keyword') and len(attributes.keyword))
			url_str ="#url_str#&keyword=#attributes.keyword#";
	</cfscript>
<cfelseif isdefined("attributes.event") and (attributes.event is 'add' or attributes.event is 'upd')>
	<cf_get_lang_set module_name="ehesap">
	<cfinclude template="../hr/ehesap/query/get_all_branches.cfm">
	<cfif attributes.event is 'add'>
		<cfquery name="get_company" datasource="#dsn#">
			SELECT COMP_ID, NICK_NAME FROM OUR_COMPANY ORDER BY NICK_NAME
		</cfquery>
	<cfelseif attributes.event is 'upd'>
		<cfquery name="get_progress_pay" datasource="#dsn#">
			SELECT
				EPP.BRANCH_ID,
				EPP.EMPLOYEE_ID,
				EPP.FINISHDATE,
				EPP.IS_KIDEM_PAY,
				EPP.KIDEM_AMOUNT,
				EPP.PROGRESS_DETAIL,
				EPP.PROGRESS_ID,
				EPP.RECORD_DATE,
				EPP.RECORD_EMP,
				EPP.RELATED_COMPANY,
				EPP.STARTDATE,
				EPP.UPDATE_DATE,
				EPP.UPDATE_EMP,
				EPP.USED_OFFTIME,
				EPP.WORKED_DAY,
				E.EMPLOYEE_NAME,
				E.EMPLOYEE_SURNAME
			FROM 
				EMPLOYEE_PROGRESS_PAYMENT EPP
				INNER JOIN EMPLOYEES E ON E.EMPLOYEE_ID = EPP.RECORD_EMP
			WHERE 
				EPP.PROGRESS_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.progress_id#">
		</cfquery>
	</cfif>
</cfif>

<script type="text/javascript">
	<cfif (isdefined("attributes.event") and attributes.event is 'list') or not isdefined("attributes.event")>
		$(document).ready(function() {
			$('#keyword').focus();
		});
	<cfelseif isdefined("attributes.event") and (attributes.event is 'add' or attributes.event is 'upd')>
		function isNumber(inputStr) 
		{
			for (var i = 0; i < inputStr.length; i++) 
			{
				var oneChar = inputStr.substring(i, i + 1)
				if (oneChar < "0" ||  oneChar > "9") {
					return false;
			  	}
			}
			return true;
		}
		
		function UnformatFields()
		{
			var x = (500 - $('#detail').val().length);
			if ( x < 0 )
			{ 
				alert ("<cf_get_lang no ='855.Açıklama Alanı 500 Karakter Olmalıdır'>!");
				return false;
			}
			<cfif attributes.event is 'add'>
				if($('#branch_id').val() == '')
				{
					alert("<cf_get_lang_main no='782.Zorunlu Alan'> : <cf_get_lang_main no ='41.Şube'>");
					return false;
				}
				if($('#employee_id').val() == '')
				{
					alert("<cf_get_lang_main no='782.Zorunlu Alan'> : <cf_get_lang_main no='164.Çalışan'>");
					return false;
				}
				if($('#startdate').val() == '' && $('#finishdate').val() == '')
				{
					alert("<cf_get_lang_main no='782.Zorunlu Alan'> : <cf_get_lang_main no='641.Başlangıç Tarihi'> - <cf_get_lang_main no ='288.Bitiş Tarihi'>");
					return false;
				}
				
				if(date_check(add_progress_payment.startdate,add_progress_payment.finishdate,'Başlangıç Tarihi Bitiş Tarihinden Küçük Olmalıdır')!=1)
				{
					return false;
				}
			</cfif>
			$('#KIDEM_AMOUNT').val(filterNum($('#KIDEM_AMOUNT').val()));
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
	WOStruct['#attributes.fuseaction#']['list']['fuseaction'] = 'ehesap.list_emp_progress_payment';
	WOStruct['#attributes.fuseaction#']['list']['filePath'] = 'hr/ehesap/display/list_emp_progress_payment.cfm';
	
	WOStruct['#attributes.fuseaction#']['add'] = structNew();
	WOStruct['#attributes.fuseaction#']['add']['window'] = 'popup';
	WOStruct['#attributes.fuseaction#']['add']['fuseaction'] = 'ehesap.popup_add_progress_payment';
	WOStruct['#attributes.fuseaction#']['add']['filePath'] = 'hr/ehesap/form/popup_add_progress_payment.cfm';
	WOStruct['#attributes.fuseaction#']['add']['queryPath'] = 'hr/ehesap/query/add_progress_pay.cfm';
	WOStruct['#attributes.fuseaction#']['add']['nextEvent'] = 'ehesap.list_emp_progress_payment&event=upd';
	
	WOStruct['#attributes.fuseaction#']['upd'] = structNew();
	WOStruct['#attributes.fuseaction#']['upd']['window'] = 'popup';
	WOStruct['#attributes.fuseaction#']['upd']['fuseaction'] = 'ehesap.popup_upd_progress_payment';
	WOStruct['#attributes.fuseaction#']['upd']['filePath'] = 'hr/ehesap/form/popup_upd_progress_payment.cfm';
	WOStruct['#attributes.fuseaction#']['upd']['queryPath'] = 'hr/ehesap/query/upd_progress_pay.cfm';
	WOStruct['#attributes.fuseaction#']['upd']['nextEvent'] = 'ehesap.list_emp_progress_payment&event=upd';
	WOStruct['#attributes.fuseaction#']['upd']['parameters'] = 'progress_id=##attributes.progress_id##';
	WOStruct['#attributes.fuseaction#']['upd']['Identity'] = '##attributes.progress_id##';
	
	if(not attributes.event is 'add')
	{
		WOStruct['#attributes.fuseaction#']['del'] = structNew();
		WOStruct['#attributes.fuseaction#']['del']['window'] = 'emptypopup';
		WOStruct['#attributes.fuseaction#']['del']['fuseaction'] = 'ehesap.emptypopup_del_progress_pay';
		WOStruct['#attributes.fuseaction#']['del']['filePath'] = 'hr/ehesap/query/del_progress_pay.cfm';
		WOStruct['#attributes.fuseaction#']['del']['queryPath'] = 'hr/ehesap/query/del_progress_pay.cfm';
		WOStruct['#attributes.fuseaction#']['del']['nextEvent'] = 'ehesap.list_emp_progress_payment';
	}
	
	if(attributes.event is 'upd')
	{
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd'] = structNew();
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons'] = structNew();
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['add']['text'] = '#lang_array_main.item[170]#';
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['add']['href'] = "#request.self#?fuseaction=ehesap.list_emp_progress_payment&event=add";
		tabMenuData = SerializeJSON(tabMenuStruct['#attributes.fuseaction#']['tabMenus']);
	}
	
	WOStruct['#attributes.fuseaction#']['extendedForm'] = structNew();
	WOStruct['#attributes.fuseaction#']['extendedForm']['controllerFileName'] = 'ehesapEmpProgressPayment';
	WOStruct['#attributes.fuseaction#']['extendedForm']['eventList'] = 'add,upd';
	WOStruct['#attributes.fuseaction#']['extendedForm']['tableName'] = 'EMPLOYEE_PROGRESS_PAYMENT';
	WOStruct['#attributes.fuseaction#']['extendedForm']['dataSourceName'] = 'main';
	if(attributes.event is 'add')
	{
		WOStruct['#attributes.fuseaction#']['extendedForm']['settings'] = "['item-startdate','item-finishdate']"; 
	}else if(attributes.event is 'upd')
	{
		WOStruct['#attributes.fuseaction#']['extendedForm']['settings'] = "['item-branch_id','item-employee_id','item-startdate','item-finishdate']"; 
	}
</cfscript>
