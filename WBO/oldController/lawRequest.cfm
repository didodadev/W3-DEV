<cf_get_lang_set module_name="ch">
<cfparam name="attributes.id" default="" >
<cfparam name="attributes.request_status" default="" >
<cfparam name="attributes.process_cat" default="" >
<cfparam name="attributes.upd" default=0 >
<cfparam name="attributes.law_stage" default="" >
<cfparam name="attributes.law_adwocate_company" default="" >
<cfparam name="attributes.law_adwocate" default=0>
<cfparam name="attributes.total_amount" default=0>
<cfparam name="attributes.money_currency" default="" >
<cfparam name="attributes.file_number" default="" >
<cfparam name="attributes.revenue_date" default="" >
<cfparam name="attributes.file_stage" default="" >
<cfparam name="attributes.revenue_adwocate_company" default="" >
<cfparam name="attributes.revenue_adwocate" default="" >
<cfparam name="attributes.total_revenue" default=0>
<cfparam name="attributes.detail" default="">
<cfparam name="attributes.kalan_revenue" default=0>
<cfparam name="attributes.is_detail" default=0>
<cfif not IsDefined("attributes.event") or (IsDefined("attributes.event") and attributes.event eq 'list')>
	<cfparam name="attributes.file_number" default="">
    <cfparam name="attributes.consumer_id" default="">
    <cfparam name="attributes.company_id" default="">
    <cfparam name="attributes.member_name" default="">
    <cfparam name="attributes.request_status" default="1">
    <cfparam name="attributes.process_stage_type" default="">
    <cfif isdefined("attributes.form_submitted")>
        <cfquery name="get_law_request" datasource="#dsn#">
            SELECT
                CLR.*,
                C.COMPANY_ID,
                C.FULLNAME,
                C.NICKNAME,
                CON.CONSUMER_ID,
                CON.CONSUMER_NAME,
                CON.CONSUMER_SURNAME,
                PTR.STAGE,
                PTR.PROCESS_ROW_ID
            FROM
                COMPANY_LAW_REQUEST CLR
                LEFT JOIN COMPANY C ON C.COMPANY_ID = CLR.COMPANY_ID
                LEFT JOIN CONSUMER CON ON CON.CONSUMER_ID = CLR.CONSUMER_ID
                LEFT JOIN PROCESS_TYPE_ROWS PTR ON PTR.PROCESS_ROW_ID = CLR.PROCESS_CAT
            WHERE
                1=1
            <cfif isdefined("attributes.file_number") and len(attributes.file_number)>
                AND CLR.FILE_NUMBER LIKE '%#attributes.file_number#%'
            </cfif>
            <cfif len(attributes.company_id) and len(attributes.member_name)>
                AND CLR.COMPANY_ID = #attributes.company_id#
            </cfif>
            <cfif len(attributes.request_status)>
                AND CLR.REQUEST_STATUS = #attributes.request_status#
            </cfif>
            <cfif len(attributes.consumer_id) and len(attributes.member_name)>
                AND CLR.CONSUMER_ID = #attributes.consumer_id#
            </cfif>
            <cfif len(attributes.process_stage_type)>
                AND CLR.PROCESS_CAT = #attributes.process_stage_type#
            </cfif>
        </cfquery>
    <cfelse>
        <cfset get_law_request.recordcount = 0>
    </cfif>
    <cfparam name="attributes.page" default="1">
    <cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
    <cfparam name="attributes.totalrecords" default="#get_law_request.recordcount#">
    <cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
    <cfquery name="GET_LAW_STAGE" datasource="#DSN#">
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
            PT.FACTION LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%ch.list_law_request%">
    </cfquery>
    <script type="text/javascript">
		$( document ).ready(function() {
			document.getElementById('file_number').focus();
		});
	</script>
</cfif>
<cfif IsDefined("attributes.event")>
	<cfif attributes.event eq 'add'>
	 	<cfset member_name = ''>
        <cfset member_id = ''>
        <cfset member_type = ''>
	</cfif>
	<cfquery name="GET_MONEY" datasource="#DSN#">
        SELECT
            *
        FROM
            SETUP_MONEY
        WHERE
            PERIOD_ID = #session.ep.period_id# AND
            MONEY_STATUS = 1
    </cfquery>
    <script type="text/javascript">
		function kontrol()
		{
			if(document.add_law_request.member_name.value == "" )
			{
				alert("<cf_get_lang no='108.Lütfen Cari Hesap Seçiniz'> !");
				return false;
			}
			if(document.add_law_request.file_number.value == "")
			{
				alert("<cf_get_lang no='107.Lütfen Dosya No Giriniz'> !");
				return false;
			}
			<cfif attributes.event eq 'upd'>
				var kontrol = 0;
				for (var i=1; i <= document.all.record_num1.value; i++)
				{
					var form_field = eval("document.all.cheque_row1" + i);
					if(form_field.checked == true)
						kontrol = 1;
				}
				for (var i=1; i <= document.all.record_num1_2.value; i++)
				{
					var form_field = eval("document.all.cheque_row1_2" + i);
					if(form_field.checked == true)
						kontrol = 1;
				}
				for (var i=1; i <= document.all.record_num2.value; i++)
				{
					var form_field = eval("document.all.cheque_row2" + i);
					if(form_field.checked == true)
						kontrol = 1;
				}
				for (var i=1; i <= document.all.record_num2_2.value; i++)
				{
					var form_field = eval("document.all.cheque_row2_2" + i);
					if(form_field.checked == true)
						kontrol = 1;
				}
			</cfif>
			document.add_law_request.total_credit.value = filterNum(document.add_law_request.total_credit.value);
			document.add_law_request.total_revenue.value = filterNum(document.add_law_request.total_revenue.value);
			document.add_law_request.kalan_revenue.value = filterNum(document.add_law_request.kalan_revenue.value);
			<cfif attributes.event eq 'upd'>
				if(process_cat_control()==false)
					return false;
				else
				{
					if(kontrol == 1)
						if(confirm("<cf_get_lang no='103.Seçtiğiniz Çek ve Senetler İcra Aşamasına Getirilecektir Emin misiniz'>?") == true)
							return true;
						else
							return false;
				}
			<cfelse>
				return process_cat_control();
			</cfif>
			return true;
		}
		function kalan()
		{
			document.add_law_request.kalan_revenue.value = commaSplit(filterNum(document.add_law_request.total_credit.value,2) - filterNum(document.add_law_request.total_revenue.value,2),2);
		}
	</script>
    <cfif attributes.event eq 'upd'>
    	<cfquery name="get_law_request" datasource="#dsn#">
            SELECT 
                LAW_REQUEST_ID, 
                REQUEST_STATUS, 
                COMPANY_ID, 
                CONSUMER_ID, 
                BRANCH_ID, 
                RELATED_ID, 
                PROCESS_CAT, 
                DETAIL, 
                GUARANTOR_DETAIL, 
                MORTGAGE_DETAIL, 
                PAWN_DETAIL, 
                PERFORM_PAY_NETTOTAL1, 
                PERFORM_PAY_NETTOTAL2, 
                IS_MUACCELLIYET, 
                TOTAL_AMOUNT, 
                MONEY_CURRENCY, 
                FILE_NUMBER, 
                FILE_STAGE, 
                LAW_STAGE, 
                LAW_ADWOCATE,
                LAW_ADWOCATE_COMPANY,
                REVENUE_TYPE, 
                REVENUE_DATE, 
                REVENUE_ADWOCATE, 
                REVENUE_ADWOCATE_COMPANY,
                TOTAL_REVENUE, 
                TOTAL_REVENUE_MONEY_CURRENCY, 
                KALAN_REVENUE, 
                KALAN_REVENUE_MONEY_CURRENCY, 
                RECORD_DATE, 
                RECORD_EMP, 
                RECORD_IP, 
                UPDATE_DATE, 
                UPDATE_EMP, 
                UPDATE_IP, 
                IS_ACTIVE, 
                IS_SUBMIT 
            FROM 
                COMPANY_LAW_REQUEST 
            WHERE 
                LAW_REQUEST_ID = #attributes.id#
        </cfquery>
		<cfif len(get_law_request.company_id)>
            <cfquery name="get_company" datasource="#dsn#">
                SELECT FULLNAME,COMPANY_ID FROM COMPANY WHERE COMPANY_ID = #get_law_request.company_id#
            </cfquery>
            <cfset member_name = '#get_company.fullname#'>
            <cfset member_id = get_law_request.company_id>
            <cfset member_type = 'partner'>
        <cfelse>
            <cfquery name="get_consumer" datasource="#dsn#">
                SELECT CONSUMER_NAME,CONSUMER_SURNAME,CONSUMER_ID FROM CONSUMER WHERE CONSUMER_ID = #get_law_request.consumer_id#
            </cfquery>
            <cfset member_name = '#get_consumer.consumer_name# #get_consumer.consumer_surname#'>
            <cfset member_id = get_law_request.consumer_id>
            <cfset member_type = 'consumer'>
        </cfif>

		<script type="text/javascript">
			function kontrol2()
			{ debugger;
				add_law_request.del_req_id.value = <cfoutput>#attributes.id#</cfoutput>;
				return true;
			}
			
			function sayfa_getir(id,type)
			{
				AjaxPageLoad('<cfoutput>#request.self#</cfoutput>?fuseaction=ch.ajax_popup_view_cheque_voucher&member_type='+type+'&member_id='+id+'','show_company_info');
			}
		</script>
		<cfset attributes.id=attributes.id >
		<cfset attributes.request_status=get_law_request.request_status >
		<cfset attributes.process_cat=get_law_request.process_cat >
		<cfset attributes.upd=1 >
		<cfset attributes.law_stage=get_law_request.law_stage >
		<cfset attributes.law_adwocate_company=get_law_request.law_adwocate_company >
		<cfset attributes.law_adwocate=get_law_request.law_adwocate>
		<cfset attributes.total_amount=get_law_request.total_amount>
		<cfset attributes.money_currency=get_law_request.money_currency >
		<cfset attributes.file_number="#get_law_request.file_number#" >
		<cfset attributes.revenue_date="#get_law_request.revenue_date#" >
		<cfset attributes.file_stage=get_law_request.file_stage >
		<cfset attributes.revenue_adwocate_company=get_law_request.revenue_adwocate_company>
		<cfset attributes.revenue_adwocate=get_law_request.revenue_adwocate >
		<cfset attributes.total_revenue=get_law_request.total_revenue>
		<cfset attributes.detail=get_law_request.detail>
		<cfset attributes.kalan_revenue=get_law_request.kalan_revenue>
		<cfset attributes.is_detail=1>
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
	WOStruct['#attributes.fuseaction#']['list']['fuseaction'] = 'ch.list_law_request';
	WOStruct['#attributes.fuseaction#']['list']['filePath'] = 'ch/display/list_law_request.cfm';
	
	WOStruct['#attributes.fuseaction#']['add'] = structNew();
	WOStruct['#attributes.fuseaction#']['add']['window'] = 'normal';
	WOStruct['#attributes.fuseaction#']['add']['fuseaction'] = 'ch.form_add_law_request';
	WOStruct['#attributes.fuseaction#']['add']['filePath'] = 'ch/form/add_law_request.cfm';
	WOStruct['#attributes.fuseaction#']['add']['queryPath'] = 'ch/query/add_law_request.cfm';
	WOStruct['#attributes.fuseaction#']['add']['nextEvent'] = 'ch.list_law_request&event=upd';
	WOStruct['#attributes.fuseaction#']['add']['js'] = "javascript:gizle_goster(add_law)";
	
	WOStruct['#attributes.fuseaction#']['upd'] = structNew();
	WOStruct['#attributes.fuseaction#']['upd']['window'] = 'normal';
	WOStruct['#attributes.fuseaction#']['upd']['fuseaction'] = 'bank.add_collacted_gelenh';
	WOStruct['#attributes.fuseaction#']['upd']['filePath'] = 'ch/form/add_law_request.cfm';
	WOStruct['#attributes.fuseaction#']['upd']['queryPath'] = 'ch/query/upd_law_request.cfm';
	WOStruct['#attributes.fuseaction#']['upd']['nextEvent'] = 'ch.list_law_request&event=upd';
	WOStruct['#attributes.fuseaction#']['upd']['parameters'] = 'id=##attributes.id##';
	WOStruct['#attributes.fuseaction#']['upd']['Identity'] = '##attributes.id##';
	WOStruct['#attributes.fuseaction#']['upd']['js'] = "javascript:gizle_goster(upd_law)";
	
	
		if( IsDefined("attributes.event") and (attributes.event is 'upd' or attributes.event is 'del'))
		{
			WOStruct['#attributes.fuseaction#']['del'] = structNew();
			WOStruct['#attributes.fuseaction#']['del']['window'] = 'emptypopup';
			WOStruct['#attributes.fuseaction#']['del']['fuseaction'] = 'ch.emptypopup_upd_law_request&id=#attributes.id#';
			WOStruct['#attributes.fuseaction#']['del']['filePath'] = 'ch/query/upd_law_request.cfm';
			WOStruct['#attributes.fuseaction#']['del']['queryPath'] = 'ch/query/upd_law_request.cfm';
			WOStruct['#attributes.fuseaction#']['del']['nextEvent'] = 'ch.list_law_request';
			WOStruct['#attributes.fuseaction#']['del']['extraParams'] = 'del_req_id&record_num1&record_num1_2&record_num2&record_num2_2';
		}
	
	if( IsDefined("attributes.event") and attributes.event is 'upd')
	{
		if(member_type eq 'partner')
		{
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd'] = structNew();
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'] = structNew();
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][0]['text'] = '#lang_array_main.item[359]#';
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][0]['href'] = "#request.self#?fuseaction=member.detail_company&cpid=#member_id#";
			if(get_module_user(33) and not listfindnocase(denied_pages,'report.bsc_company'))
			{
				tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][1]['text'] = '#lang_array.item[106]#';
				tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][1]['onClick'] = "windowopen('#request.self#?fuseaction=report.popup_bsc_company&member_type=partner&company_id=#member_id#&member_name=#member_name#&finance=1','wide')";
			}
			if(not listfindnocase(denied_pages,'myhome.my_company_details'))
			{
				tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][2]['text'] = '#lang_array_main.item[163]#';
				tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][2]['href'] = "#request.self#?fuseaction=myhome.my_company_details&cpid=#member_id#";
			}
		}
		else
		{
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd'] = structNew();
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'] = structNew();
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][0]['text'] = '#lang_array_main.item[359]#';
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][0]['href'] = "#request.self#?fuseaction=member.detail_consumer&cid=#member_id#";
			if(get_module_user(3) and not listfindnocase(denied_pages,'report.bsc_company'))
			{
				tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][1]['text'] = '#lang_array.item[106]#';
				tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][1]['onClick'] = "windowopen('#request.self#?fuseaction=report.popup_bsc_company&member_type=consumer&consumer_id=#member_id#&member_name=#member_name#&finance=1','wide')";
			}
			if(not listfindnocase(denied_pages,'myhome.my_consumer_details'))
			{
				tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][2]['text'] = '#lang_array_main.item[163]#';
				tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][2]['href'] = "#request.self#?fuseaction=myhome.my_consumer_details&cid=#member_id#";
			}
		}
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons'] = structNew();
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['add']['text'] = '#lang_array_main.item[170]#';
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['add']['href'] = "#request.self#?fuseaction=ch.list_law_request&event=add";
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['add']['target'] = "_blank";
		tabMenuData = SerializeJSON(tabMenuStruct['#attributes.fuseaction#']['tabMenus']);
	}
	WOStruct['#attributes.fuseaction#']['extendedForm'] = structNew();
	WOStruct['#attributes.fuseaction#']['extendedForm']['controllerFileName'] = 'lawRequest';
	WOStruct['#attributes.fuseaction#']['extendedForm']['eventList'] = 'add,upd';
	WOStruct['#attributes.fuseaction#']['extendedForm']['tableName'] = 'COMPANY_LAW_REQUEST';
	WOStruct['#attributes.fuseaction#']['extendedForm']['dataSourceName'] = '';
	WOStruct['#attributes.fuseaction#']['extendedForm']['settings'] = "['item-2','item-7']"; 
</cfscript>

