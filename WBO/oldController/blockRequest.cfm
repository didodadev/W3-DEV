<cf_get_lang_set module_name="ch">
<cfparam name="attributes.process_stage" default="" >
<cfparam name="attributes.block_id" default="" >
<cfparam name="attributes.block_employee_id" default="#session.ep.userid#" >
<cfparam name="attributes.block_start_date" default="#now()#" >
<cfparam name="attributes.block_finish_date" default="#now()#" >
<cfparam name="attributes.detail" default="" >
<cfparam name="attributes.is_detail" default=0>
<cfparam name="attributes.upd" default=0>
<cfif not IsDefined("attributes.event") or (IsDefined("attributes.event") and attributes.event eq 'list')>
	<cfparam name="attributes.consumer_id" default="">
    <cfparam name="attributes.company_id" default="">
    <cfparam name="attributes.member_name" default="">
    <cfparam name="attributes.block_group" default="">
    <cfparam name="attributes.start_date" default="">
    <cfparam name="attributes.finish_date" default="">
    <cfparam name="attributes.process_stage_type" default="">
    <cfquery name="GET_BLOCK_GROUP" datasource="#DSN#">
        SELECT 
            BLOCK_GROUP_ID,
            BLOCK_GROUP_NAME
        FROM 
            BLOCK_GROUP
        ORDER BY
            BLOCK_GROUP_NAME
    </cfquery>
    <cfquery name="GET_STAGE" datasource="#DSN#">
        SELECT
            PTR.STAGE,
            PTR.PROCESS_ROW_ID 
        FROM
            PROCESS_TYPE_ROWS PTR,
            PROCESS_TYPE_OUR_COMPANY PTO,
            PROCESS_TYPE PT
        WHERE
            PT.IS_ACTIVE = 1 AND
            PTR.PROCESS_ID = PT.PROCESS_ID AND
            PT.PROCESS_ID = PTO.PROCESS_ID AND
            PTO.OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#"> AND
            PT.FACTION LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%ch.list_block_request%">
    </cfquery>
    <cfif isdefined("attributes.form_submitted")>
        <cfset attributes.start_date = #dateformat(attributes.start_date,'dd/mm/yyyy')#>
        <cfset attributes.finish_date = #dateformat(attributes.finish_date,'dd/mm/yyyy')#>
        <cfquery name="GET_BLOCK_REQUEST" datasource="#DSN#">
            SELECT
                CBR.COMPANY_ID,
                CBR.CONSUMER_ID,
                CBR.COMPANY_BLOCK_ID,
                CBR.PROCESS_STAGE,
                CBR.BLOCK_GROUP_ID,
                CBR.BLOCK_START_DATE,
                CBR.BLOCK_FINISH_DATE,
                CBR.BLOCK_GROUP_ID,
                CBR.PROCESS_STAGE,
                CBR.RECORD_DATE,
                C.COMPANY_ID,
                C.FULLNAME,
                C.NICKNAME,
                CON.CONSUMER_ID,
                CON.CONSUMER_NAME,
                CON.CONSUMER_SURNAME,
                PTR.STAGE,
                PTR.PROCESS_ROW_ID,
                BG.BLOCK_GROUP_NAME,
                BG.BLOCK_GROUP_ID
            FROM
                COMPANY_BLOCK_REQUEST CBR
                LEFT JOIN COMPANY C ON C.COMPANY_ID = CBR.COMPANY_ID
                LEFT JOIN CONSUMER CON ON CON.CONSUMER_ID = CBR.CONSUMER_ID
                LEFT JOIN PROCESS_TYPE_ROWS PTR ON PTR.PROCESS_ROW_ID = CBR.PROCESS_STAGE
                LEFT JOIN BLOCK_GROUP BG ON BG.BLOCK_GROUP_ID = CBR.BLOCK_GROUP_ID
            WHERE
                1 = 1
            <cfif len(attributes.company_id) and len(attributes.member_name)>
                AND CBR.COMPANY_ID = #attributes.company_id#
            </cfif>
            <cfif len(attributes.consumer_id) and len(attributes.member_name)>
                AND CBR.CONSUMER_ID = #attributes.consumer_id#
            </cfif>
            <cfif len(attributes.block_group)>
                AND CBR.BLOCK_GROUP_ID = #attributes.block_group#
            </cfif>
            <cfif len(attributes.process_stage_type)>
                AND CBR.PROCESS_STAGE = #attributes.process_stage_type#
            </cfif>
            <cfif isdefined("attributes.start_date") and isdate(attributes.start_date)>
                AND CBR.RECORD_DATE >= #createodbcdatetime(attributes.start_date)#
            </cfif>
            <cfif isdefined("attributes.finish_date") and isdate(attributes.finish_date)>
                AND CBR.RECORD_DATE <= #createodbcdatetime(attributes.finish_date)#
            </cfif>
        </cfquery>
    <cfelse>
        <cfset get_block_request.recordcount = 0>
    </cfif>
    <cfparam name="attributes.page" default="1">
    <cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
    <cfparam name="attributes.totalrecords" default="#get_block_request.recordcount#">
    <cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>

	 <script>
		 $( document ).ready(function() {
			document.getElementById('member_name').focus();
		});
		
		function kontrol()
			{
				if( !date_check(document.getElementById('start_date'),document.getElementById('finish_date'), "<cf_get_lang_main no='1450.Başlangıç Tarihi Bitiş Tarihinden Büyük Olamaz'>!") )
					return false;
				else
					return true;
			}
	</script>
</cfif>
<cfif isdefined('attributes.event') and  attributes.event eq 'add'>
	<cfset member_name = ''>
	<cfset member_id = ''>
	<cfset member_type = ''>
</cfif>
<cfif IsDefined("attributes.event")>
	<cfquery name="get_block_group" datasource="#dsn#">
        SELECT BLOCK_GROUP_ID,BLOCK_GROUP_NAME FROM BLOCK_GROUP
    </cfquery>
	<script type="text/javascript">
		function kontrol()
		{
			if(document.add_block_request.member_name.value == "" || document.add_block_request.member_id.value == "")
			{
				alert("<cf_get_lang no='108.Lütfen Cari Hesap Seçiniz'>!");
				return false;
			}
			if(document.add_block_request.blocker_employee.value == "" || document.add_block_request.blocker_employee_id.value == "")
			{
				alert("<cf_get_lang no='80.Lütfen İşlem Yapan Seçiniz'>!");
				return false;
			}
			<cfif attributes.event eq 'add'>
				if(document.add_block_request.block_group.value == "")
				{
					alert("<cf_get_lang no='79.Lütfen Bloklama Nedeni Seçiniz'>!");
					return false;
				}
			</cfif>
			return process_cat_control();
			return true;
		}
	</script>
    <cfif attributes.event eq 'upd'>
    	<cfquery name="get_block_request" datasource="#dsn#">
            SELECT 
                COMPANY_BLOCK_ID, 
                PROCESS_STAGE, 
                BLOCK_START_DATE, 
                BLOCK_FINISH_DATE, 
                COMPANY_ID, 
                CONSUMER_ID, 
                BLOCK_EMPLOYEE_ID, 
                BLOCK_GROUP_ID, 
                DETAIL, 
                RECORD_DATE, 
                RECORD_EMP, 
                RECORD_IP, 
                UPDATE_DATE, 
                UPDATE_EMP, 
                UPDATE_IP 
            FROM 
                COMPANY_BLOCK_REQUEST 
            WHERE 
                COMPANY_BLOCK_ID = #attributes.block_id#
        </cfquery>
		<cfif len(get_block_request.company_id)>
            <cfquery name="get_company" datasource="#dsn#">
                SELECT FULLNAME,COMPANY_ID FROM COMPANY WHERE COMPANY_ID = #get_block_request.company_id#
            </cfquery>
            <cfset member_name = '#get_company.fullname#'>
            <cfset member_id = get_block_request.company_id>
            <cfset member_type = 'partner'>
        <cfelse>
            <cfquery name="get_consumer" datasource="#dsn#">
                SELECT CONSUMER_NAME,CONSUMER_SURNAME,CONSUMER_ID FROM CONSUMER WHERE CONSUMER_ID = #get_block_request.consumer_id#
            </cfquery>
            <cfset member_name = '#get_consumer.consumer_name# #get_consumer.consumer_surname#'>
            <cfset member_id = get_block_request.consumer_id>
            <cfset member_type = 'consumer'>
        </cfif>
        <cfset attributes.process_stage = get_block_request.process_stage>
		<cfset attributes.block_employee_id = get_block_request.block_employee_id>
		<cfset attributes.block_start_date = get_block_request.block_start_date>
		<cfset attributes.block_finish_date = get_block_request.block_finish_date>
		<cfset attributes.detail =  get_block_request.detail>
		<cfset attributes.is_detail =1 >
		<cfparam name="attributes.upd" default=1>
    </cfif>
</cfif>
<cfscript>
	// Switch //
	WOStruct = StructNew();
	
	WOStruct['#attributes.fuseaction#'] = structNew();
	
	WOStruct['#attributes.fuseaction#']['default'] = 'list';
	
	if(not isdefined('attributes.event'))
		attributes.event = WOStruct['#attributes.fuseaction#']['default'];
	
	WOStruct['#attributes.fuseaction#']['list'] = structNew();
	WOStruct['#attributes.fuseaction#']['list']['window'] = 'normal';
	WOStruct['#attributes.fuseaction#']['list']['fuseaction'] = 'ch.list_block_request';
	WOStruct['#attributes.fuseaction#']['list']['filePath'] = 'ch/display/list_block_request.cfm';
	
	WOStruct['#attributes.fuseaction#']['add'] = structNew();
	WOStruct['#attributes.fuseaction#']['add']['window'] = 'normal';
	WOStruct['#attributes.fuseaction#']['add']['fuseaction'] = 'ch.form_add_block_request';
	WOStruct['#attributes.fuseaction#']['add']['filePath'] = 'ch/form/add_block_request.cfm';
	WOStruct['#attributes.fuseaction#']['add']['queryPath'] = 'ch/query/add_block_request.cfm';
	WOStruct['#attributes.fuseaction#']['add']['nextEvent'] = 'ch.list_block_request&event=upd';
	
	WOStruct['#attributes.fuseaction#']['upd'] = structNew();
	WOStruct['#attributes.fuseaction#']['upd']['window'] = 'normal';
	WOStruct['#attributes.fuseaction#']['upd']['fuseaction'] = 'ch.form_upd_block_request';
	WOStruct['#attributes.fuseaction#']['upd']['filePath'] = 'ch/form/add_block_request.cfm';
	WOStruct['#attributes.fuseaction#']['upd']['queryPath'] = 'ch/query/upd_block_request.cfm';
	WOStruct['#attributes.fuseaction#']['upd']['nextEvent'] = 'ch.list_block_request&event=upd';
	WOStruct['#attributes.fuseaction#']['upd']['parameters'] = 'block_id=##attributes.block_id##';
	WOStruct['#attributes.fuseaction#']['upd']['Identity'] = '##attributes.block_id##';
	
	if(IsDefined("attributes.event") and (attributes.event is 'upd' or attributes.event is 'del'))
	{
		WOStruct['#attributes.fuseaction#']['del'] = structNew();
		WOStruct['#attributes.fuseaction#']['del']['window'] = 'emptypopup';
		WOStruct['#attributes.fuseaction#']['del']['fuseaction'] = '#request.self#?fuseaction=ch.emptypopup_del_block_request&block_id=#attributes.block_id#';
		WOStruct['#attributes.fuseaction#']['del']['filePath'] = 'ch/query/del_block_request.cfm';
		WOStruct['#attributes.fuseaction#']['del']['queryPath'] = 'ch/query/del_block_request.cfm';
		WOStruct['#attributes.fuseaction#']['del']['nextEvent'] = 'ch.list_block_request';
	}
	
	if( IsDefined("attributes.event") and attributes.event is 'upd')
	{
		if(member_type eq 'partner')
		{
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd'] = structNew();
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'] = structNew();
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][0]['text'] = '#lang_array_main.item[359]#';
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][0]['href'] = "#request.self#?fuseaction=member.detail_company&cpid=#member_id#";
			if(not listfindnocase(denied_pages,'myhome.my_company_details'))
			{
				tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][1]['text'] = '#lang_array.item[106]#';
				tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][1]['href'] = "#request.self#?fuseaction=member.detail_company&cpid=#member_id#";
			}
		}
		else
		{
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd'] = structNew();
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'] = structNew();
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][0]['text'] = '#lang_array_main.item[359]#';
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][0]['href'] = "#request.self#?fuseaction=member.detail_consumer&cid=#member_id#";
			if(not listfindnocase(denied_pages,'myhome.my_consumer_details'))
			{
				tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][1]['text'] = '#lang_array.item[106]#';
				tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][1]['href'] = "#request.self#?fuseaction=myhome.my_consumer_details&cid=#member_id#";
			}
		}
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons'] = structNew();
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['add']['text'] = '#lang_array_main.item[170]#';
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['add']['href'] = "#request.self#?fuseaction=ch.list_block_request&event=add";
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['add']['target'] = "_blank";
		tabMenuData = SerializeJSON(tabMenuStruct['#attributes.fuseaction#']['tabMenus']);
	}
	WOStruct['#attributes.fuseaction#']['extendedForm'] = structNew();
	WOStruct['#attributes.fuseaction#']['extendedForm']['controllerFileName'] = 'blockRequest';
	WOStruct['#attributes.fuseaction#']['extendedForm']['eventList'] = 'add,upd';
	WOStruct['#attributes.fuseaction#']['extendedForm']['tableName'] = 'COMPANY_BLOCK_REQUEST';
	WOStruct['#attributes.fuseaction#']['extendedForm']['dataSourceName'] = '';
	WOStruct['#attributes.fuseaction#']['extendedForm']['settings'] = "['item-1','item-3','item-4']"; 
</cfscript>

