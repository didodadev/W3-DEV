<cf_get_lang_set module_name ="prod">
<cfif not isdefined("attributes.event") or attributes.event is 'list'>
	<cfparam name="attributes.keyword" default="">
    <cfparam name="attributes.is_active" default="">
    <cfif isdefined("attributes.form_submitted")>
        <cfinclude template="../production_plan/query/get_operation_type.cfm">
    <cfelse>
        <cfset get_operation_type.recordcount=0>
    </cfif>
    <cfif not len(attributes.is_active)><cfset attributes.is_active = 1></cfif>
    <cfparam name="attributes.page" default=1>
    <cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
    <cfparam name="attributes.totalrecords" default=#get_operation_type.recordcount#>
    <cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
<cfelseif isdefined("attributes.event") and listfind('add,upd',attributes.event)>
    <cfquery name="GET_MONEY" datasource="#DSN#">
        SELECT * FROM SETUP_MONEY WHERE PERIOD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.period_id#">
    </cfquery>
    <cfif isdefined("attributes.operation_type_id") and len(attributes.operation_type_id)>
        <cfquery name="get_op_type" datasource="#dsn3#">
            SELECT 
                O.*, 
                E.EMPLOYEE_NAME, 
                E.EMPLOYEE_SURNAME 
            FROM 
                OPERATION_TYPES O, 
                #dsn_alias#.EMPLOYEES E 
            WHERE 
                E.EMPLOYEE_ID = O.RECORD_EMP  AND	
                O.OPERATION_TYPE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.operation_type_id#">
        </cfquery>
    </cfif>
</cfif>
<script type="text/javascript">
<cfif isdefined("attributes.event") and listfind('add',attributes.event)>
	function unformat_fields()
	{
		if ((document.getElementById('comment_2').value.length) > 100 || (document.getElementById('comment').value.length) > 100 )
		{
			alert('<cf_get_lang no="466.En Fazla 100 Karakter Açıklama Girebilirsiniz">.');	
			return false;
		}
		if(document.getElementById('operation_code').value != '')
		{
			operation_code_control=wrk_safe_query("prdp_op_code","dsn3",0,document.getElementById('operation_code').value);
			if(operation_code_control.recordcount > 0)
			{
				alert("<cf_get_lang no='475.Girdiginiz Operasyon Kodu Kullanılıyor'>!");
				return false;
			}
		}
		else
		{
			alert("<cf_get_lang no='478.Lütfen Operasyon Kodu Giriniz'>");
			return false;
		}
		document.getElementById('operation_cost').value = filterNum(document.getElementById('operation_cost').value);
		return true;
	}
<cfelseif isdefined("attributes.event") and listfind('upd',attributes.event)>
function unformat_fields()
{	
	if(document.getElementById('operation_code').value != '')
	{
		var listParam = document.getElementById('operation_code').value + "*" + "<cfoutput>#attributes.operation_type_id#</cfoutput>";
		operation_code_control=wrk_safe_query("prdp_operation_code_control",'dsn3',0,listParam);
		if(operation_code_control.recordcount > 0)
		{
			alert("Girdiginiz Operasyon Kodu Kullanılıyor!");
			return false;
		}
	}
	document.getElementById('operation_cost').value = filterNum(document.getElementById('operation_cost').value);
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
	WOStruct['#attributes.fuseaction#']['list']['fuseaction'] = 'prod.list_operationtype';
	WOStruct['#attributes.fuseaction#']['list']['filePath'] = 'production_plan/display/list_operationtype.cfm';
	WOStruct['#attributes.fuseaction#']['list']['queryPath'] = 'production_plan/display/list_operationtype.cfm';
	WOStruct['#attributes.fuseaction#']['list']['nextEvent'] = 'prod.form_add_gelenh&event=upd';
	
	WOStruct['#attributes.fuseaction#']['add'] = structNew();
	WOStruct['#attributes.fuseaction#']['add']['window'] = 'normal';
	WOStruct['#attributes.fuseaction#']['add']['fuseaction'] = 'prod.list_operationtype&event=add';
	WOStruct['#attributes.fuseaction#']['add']['filePath'] = 'production_plan/display/add_operationtype.cfm';
	WOStruct['#attributes.fuseaction#']['add']['queryPath'] = 'production_plan/query/add_operation_type.cfm';
	WOStruct['#attributes.fuseaction#']['add']['nextEvent'] = 'prod.list_operationtype&event=upd';
	
	WOStruct['#attributes.fuseaction#']['upd'] = structNew();
	WOStruct['#attributes.fuseaction#']['upd']['window'] = 'normal';
	WOStruct['#attributes.fuseaction#']['upd']['fuseaction'] = 'prod.list_operationtype&event=upd';
	WOStruct['#attributes.fuseaction#']['upd']['filePath'] = 'production_plan/display/upd_operationtype.cfm';
	WOStruct['#attributes.fuseaction#']['upd']['queryPath'] = 'production_plan/query/upd_operation_type.cfm';
	WOStruct['#attributes.fuseaction#']['upd']['nextEvent'] = 'prod.list_operationtype&event=upd';
	WOStruct['#attributes.fuseaction#']['upd']['parameters'] = 'operation_type_id=##attributes.operation_type_id##';
	WOStruct['#attributes.fuseaction#']['upd']['Identity'] = '##attributes.operation_type_id##';
	
	if(attributes.event is 'upd')
	{         
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons'] = structNew();
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['add']['text'] = '#lang_array_main.item[170]#';
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['add']['href'] = "#request.self#?fuseaction=prod.list_operationtype&event=add";
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['copy']['text'] = '#lang_array_main.item[64]#';
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['copy']['href'] = '#request.self#?fuseaction=prod.list_operationtype&event=add&operation_type_id=#attributes.operation_type_id#';
		tabMenuData = SerializeJSON(tabMenuStruct['#attributes.fuseaction#']['tabMenus']);
	}
	
	WOStruct['#attributes.fuseaction#']['extendedForm'] = structNew();
	WOStruct['#attributes.fuseaction#']['extendedForm']['controllerFileName'] = 'prodOperationType';
	WOStruct['#attributes.fuseaction#']['extendedForm']['eventList'] = 'add,upd';
	WOStruct['#attributes.fuseaction#']['extendedForm']['tableName'] = 'OPERATION_TYPES';
	WOStruct['#attributes.fuseaction#']['extendedForm']['dataSourceName'] = 'company';
	WOStruct['#attributes.fuseaction#']['extendedForm']['settings'] = "['item-op_name','item-operation_code','item-operation_cost']"; // Bu atama yapılmazsa sayfada her alan değiştirilebilir olur.

</cfscript>
