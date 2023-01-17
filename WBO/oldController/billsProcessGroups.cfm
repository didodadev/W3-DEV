<cf_get_lang_set module_name="account">
<cfif (isdefined("attributes.event") and attributes.event is "list") or not isdefined("attributes.event")>
    <cfparam name="attributes.keyword" default="">
    <cfparam name="attributes.page" default=1>
    <cfset select_list="">
    <cfset account_list="">
    <cfset process_cat=ArrayNew(1)>
    <cfquery name="process_bills_group" datasource="#dsn3#">
        SELECT 
            PROCESS_TYPE_GROUP_ID,
            PROCESS_NAME,
            PROCESS_TYPE
        FROM  
            BILLS_PROCESS_GROUP
        <cfif isdefined("attributes.keyword") and len(attributes.keyword)>
            WHERE
                PROCESS_NAME LIKE '%#attributes.keyword#%'
        </cfif>
    </cfquery>
    <cfoutput query="process_bills_group">
        <cfquery name="process_bills_type_list" datasource="#dsn3#">
            SELECT
                PROCESS_CAT,
                IS_ACCOUNT
            FROM 
                SETUP_PROCESS_CAT 
            WHERE 
                PROCESS_CAT_ID IN (#process_bills_group.process_type#)
            ORDER BY
                PROCESS_CAT_ID
        </cfquery>
       <cfloop query="process_bills_type_list">
            <cfset select_list=listappend(select_list,process_bills_type_list.process_cat,',')>
        </cfloop>
        <cfset ArrayAppend(process_cat,select_list)>  
        <cfset select_list="">
    </cfoutput>
    <cfparam name="attributes.totalrecords" default="0">
    <cfif isdefined("attributes.form_submitted")>
        <cfset attributes.totalrecords = process_bills_group.recordcount>
    </cfif>
    <cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
    <cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
<cfelseif isdefined("attributes.event") and (attributes.event is "add" or attributes.event is "upd")>
    <cf_xml_page_edit fuseact="account.popup_form_add_bills_process_groups">
    <cfquery name="GET_ALL_PROCESS_CAT" datasource="#DSN3#">
        SELECT PROCESS_TYPE,PROCESS_CAT_ID,PROCESS_CAT,IS_ACCOUNT FROM SETUP_PROCESS_CAT
    </cfquery>
    <cfquery name="get_acc_card_type" dbtype="query">
        SELECT PROCESS_TYPE,PROCESS_CAT_ID,PROCESS_CAT,IS_ACCOUNT FROM GET_ALL_PROCESS_CAT WHERE 1=1 <cfif is_selected_account eq 0>AND IS_ACCOUNT = 1 </cfif> AND PROCESS_TYPE IN (11,12,13,14) ORDER BY PROCESS_TYPE
    </cfquery>
    <cfquery name="get_process_cat_process_type" dbtype="query">
        SELECT DISTINCT PROCESS_TYPE FROM GET_ALL_PROCESS_CAT WHERE 1=1 <cfif is_selected_account eq 0>AND IS_ACCOUNT = 1 </cfif> ORDER BY PROCESS_TYPE
    </cfquery>
    <cfquery name="get_process_cat" dbtype="query">
        SELECT PROCESS_TYPE,PROCESS_CAT_ID,PROCESS_CAT,IS_ACCOUNT FROM GET_ALL_PROCESS_CAT WHERE 1=1 <cfif is_selected_account eq 0>AND IS_ACCOUNT = 1 </cfif> ORDER BY PROCESS_TYPE
    </cfquery>
    <cfif attributes.event is "upd">
        <cfquery name="get_process_list_process" datasource="#DSN3#">
            SELECT 
                PROCESS_TYPE_GROUP_ID, 
                PROCESS_NAME, 
                PROCESS_TYPE, 
                RECORD_DATE, 
                RECORD_EMP, 
                RECORD_IP, 
                UPDATE_DATE, 
                UPDATE_EMP, 
                UPDATE_IP, 
                ACCOUNT_CODE_1, 
                ACCOUNT_CODE_2, 
                ACTION_DETAIL, 
                IS_DAY_GROUP, 
                IS_ACCOUNT_GROUP 
            FROM 
                BILLS_PROCESS_GROUP 
            WHERE 
                PROCESS_TYPE_GROUP_ID=#attributes.id#
        </cfquery>
        <cfquery name="record_name" datasource="#DSN#">
            SELECT EMPLOYEE_NAME,EMPLOYEE_SURNAME FROM EMPLOYEES WHERE EMPLOYEE_ID = #get_process_list_process.record_emp#
        </cfquery>
        <cfif len(#get_process_list_process.update_emp#)>
            <cfquery name="update_name" datasource="#DSN#">
                SELECT EMPLOYEE_NAME,EMPLOYEE_SURNAME FROM EMPLOYEES WHERE EMPLOYEE_ID = #get_process_list_process.update_emp#
            </cfquery>
        </cfif>   
    </cfif>
</cfif>
<script>
	<cfif (isdefined("attributes.event") and attributes.event is "list") or not isdefined("attributes.event")>
		$(document).ready(function(){
			document.getElementById('keyword').focus();
		});
	<cfelseif isdefined("attributes.event") and (attributes.event is "add" or attributes.event is "upd")>
		function pencere_ac_muavin(str_alan_1,str_alan_2,str_alan)
		{
			var txt_keyword = eval(str_alan_1 + ".value" );
			windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_account_plan_all&field_id='+str_alan_1+'&field_id2='+str_alan_1+'&keyword='+txt_keyword,'list');
		}
		function kontrol()
		{
			if(document.Add_Form_List_Bills.process_name.value == "")
			{
				alert("<cf_get_lang dictionary_id='İşlem Grup Adını Girmelisiniz'>");
				return false;
			}
			else if(document.Add_Form_List_Bills.process_type.value == "")
			{
				alert("<cf_get_lang dictionary_id='52633.İşlem Tipini Secmelisiniz'>");
				return false;
			}
			else 
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
	WOStruct['#attributes.fuseaction#']['list']['fuseaction'] = 'account.list_bills_process_groups';
	WOStruct['#attributes.fuseaction#']['list']['filePath'] = 'account/display/list_bills_process_groups.cfm';
	
	WOStruct['#attributes.fuseaction#']['add'] = structNew();
	WOStruct['#attributes.fuseaction#']['add']['window'] = 'popup';
	WOStruct['#attributes.fuseaction#']['add']['fuseaction'] = 'account.popup_form_add_bills_process_groups';
	WOStruct['#attributes.fuseaction#']['add']['filePath'] = 'account/form/form_add_bills_process_group.cfm';
	WOStruct['#attributes.fuseaction#']['add']['queryPath'] = 'account/query/add_bill_process_group.cfm';
	WOStruct['#attributes.fuseaction#']['add']['nextEvent'] = 'account.list_bills_process_groups';
	
	WOStruct['#attributes.fuseaction#']['upd'] = structNew();
	WOStruct['#attributes.fuseaction#']['upd']['window'] = 'popup';
	WOStruct['#attributes.fuseaction#']['upd']['fuseaction'] = 'account.popup_form_add_bills_process_groups';
	WOStruct['#attributes.fuseaction#']['upd']['filePath'] = 'account/form/form_upd_bill_process_grp.cfm';
	WOStruct['#attributes.fuseaction#']['upd']['queryPath'] = 'account/query/upt_bills_process_group.cfm';
	WOStruct['#attributes.fuseaction#']['upd']['nextEvent'] = 'account.list_bills_process_groups';
	WOStruct['#attributes.fuseaction#']['upd']['parameters'] = 'id=##attributes.id##';
	WOStruct['#attributes.fuseaction#']['upd']['Identity'] = '';
		
	if(attributes.event is 'upd')
	{
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons'] = structNew();
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['add']['text'] = '#lang_array_main.item[170]#';
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['add']['onClick'] = "windowopen('#request.self#?fuseaction=account.list_bills_process_groups&event=add','medium')";
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['add']['target'] = "_blank";
		tabMenuData = SerializeJSON(tabMenuStruct['#attributes.fuseaction#']['tabMenus']);
	}
</cfscript>
