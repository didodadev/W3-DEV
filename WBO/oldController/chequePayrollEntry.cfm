<cf_xml_page_edit fuseact="cheque.form_add_payroll_entry">
<cf_get_lang_set module_name="cheque"><!--- sayfanin en altinda kapanisi var --->
<cfinclude template="../cheque/query/get_cashes.cfm">
<cfset form_name = "form_payroll_basket">
<cfif (isdefined("attributes.event") and attributes.event is "add") or not isdefined("attributes.event")>
    <cfparam name="attributes.revenue_collector_id" default="#session.ep.userid#">
    <cfparam name="attributes.revenue_collector" default="#session.ep.name# #session.ep.surname#">
    <cfinclude template="../cheque/query/get_control.cfm">
    <cfset cash_status = 1>
<cfelseif isdefined("attributes.event") and attributes.event is "upd">
	<cfif isnumeric(attributes.id)>
        <cfquery name="GET_ACTION_DETAIL" datasource="#DSN2#">
            SELECT
                P.*,
                SC.IS_UPD_CARI_ROW
            FROM
                PAYROLL P,
                #dsn3_alias#.SETUP_PROCESS_CAT SC
            WHERE 
                P.ACTION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.id#"> AND
                P.PAYROLL_TYPE = <cfqueryparam cfsqltype="cf_sql_integer" value="90"> AND
                SC.PROCESS_CAT_ID = P.PROCESS_CAT
            <cfif fusebox.circuit is "store">
                AND P.BRANCH_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#ListGetAt(session.ep.user_location,2,"-")#">
            </cfif>		
        </cfquery>
        <cfquery name="get_pay_cheques" datasource="#dsn2#">
            SELECT CHEQUE_ID FROM CHEQUE WHERE CHEQUE_PAYROLL_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.id#"> AND CHEQUE_STATUS_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="3">
        </cfquery>
    <cfelse>
        <cfset get_action_detail.recordcount = 0>
    </cfif>
    <cfscript>
        controlStatus = CreateObject("component","cheque.cfc.cheque");
        controlStatus.dsn2 = dsn2;
        control_cheque_status = controlStatus.controlChequeVoucherStatus(attributes.id,1);
    </cfscript>
<cfelseif isdefined("attributes.event") and attributes.event is "det">
	<cfif isdefined("attributes.ID")>
    	<cfset attributes.CHEQUE_PAYROLL_ID = attributes.ID>
    </cfif>
    <cfinclude template="../cheque/query/get_money_rate.cfm">
    <cfif isdefined("attributes.period_id") and len(attributes.period_id) >
        <cfquery name="get_period" datasource="#DSN#">
            SELECT * FROM SETUP_PERIOD WHERE PERIOD_ID = #attributes.period_id#
        </cfquery>
        <cfset db_adres = "#dsn#_#get_period.period_year#_#get_period.our_company_id#">
    <cfelse>
        <cfset db_adres = "#dsn2#">
    </cfif>
    <cfquery name="GET_ACTION_DETAIL" datasource="#db_adres#">
        SELECT * FROM PAYROLL WHERE ACTION_ID=#URL.ID# AND PAYROLL_TYPE = 90
    </cfquery>
    <cfquery name="GET_CHEQUE_DETAIL" datasource="#db_adres#">
        SELECT 
            CHEQUE.CHEQUE_NO,
            CHEQUE.BANK_NAME,
            CHEQUE.BANK_BRANCH_NAME,
            CHEQUE.CHEQUE_DUEDATE,
            CHEQUE.CHEQUE_VALUE,
            CHEQUE.CURRENCY_ID,
            CHEQUE.OTHER_MONEY_VALUE,
            CHEQUE.OTHER_MONEY	
        FROM 
            CHEQUE_HISTORY,
            CHEQUE 
        WHERE 
            PAYROLL_ID = #attributes.CHEQUE_PAYROLL_ID# AND 
            STATUS = 1 AND
            CHEQUE.CHEQUE_ID = CHEQUE_HISTORY.CHEQUE_ID
    </cfquery>
</cfif>
<script type="text/javascript">
	<cfif isdefined("attributes.event") and attributes.event is "upd">
		function delete_action()
		{
			if (!chk_period(form_payroll_basket.payroll_revenue_date, 'İşlem')) return false;			
			if (document.all.del_flag.value != 0)//basket_cheque de tutuluyor
			{
				alert("<cf_get_lang no='61.İşlem Görmüş Çekler Var, Bordroyu Silemezsiniz !'>");
				return false;
			}
			return control_account_process(<cfoutput>'#attributes.id#','#get_action_detail.payroll_type#'</cfoutput>);
		}
	</cfif>
	function kontrol()
	{
		if(!chk_process_cat('form_payroll_basket')) return false;
		if(!check_display_files('form_payroll_basket')) return false;
		if(!chk_period(form_payroll_basket.payroll_revenue_date, 'İşlem')) return false;
		if(document.form_payroll_basket.company_id.value=="" && document.form_payroll_basket.consumer_id.value=="" && document.form_payroll_basket.employee_id.value=="" && document.getElementById('company_name').value!='')
		{
			alert("<cf_get_lang_main no ='2570.Geçerli cari hesap giriniz'>!");
			return false;
		}
		if(document.form_payroll_basket.cash_id.value=="")
		{
			alert("<cf_get_lang no='51.Kasa Seçiniz !'>");
			return false;		
		}
		if(document.all.cheque_num.value == 0)
		{
			alert("<cf_get_lang no='28.Çek Seçiniz veya Çek Ekleyiniz !'>");
			return false;
		}
		<cfif (isdefined("attributes.event") and attributes.event is "add") or not isdefined("attributes.event")>
			process=document.form_payroll_basket.process_cat.value;
			var get_process_cat = wrk_safe_query('chq_get_process_cat','dsn3',0,process);
			if(get_process_cat.IS_ACCOUNT ==1)
			{
				if (document.form_payroll_basket.member_code.value=="")
				{ 
					alert ("<cf_get_lang no='126.Seçtiğiniz Üyenin Muhasebe Kodu Secilmemiş !'>");
					return false;
				}
			}
		</cfif>
		<cfif x_required_project eq 1>
			if(document.getElementById('project_id').value == "" || document.getElementById('project_name').value == "")
			{
				alert("<cf_get_lang_main no='1385.Proje Seçiniz'>!");
				return false;
			}
		</cfif>
		<cfif x_select_type_info eq 2>
			if(document.getElementById('special_definition_id').value == "")
			{
				alert("<cf_get_lang no='41.Tahsilat Tipi Seçiniz'> !");
				return false;
			}
		</cfif>
		for(kk=1; kk<=document.getElementById('kur_say').value; kk++)
		{
			cheque_rate_change(kk);
		}
		if(toplam(1,0,1)==false)return false;
		
		<cfif (isdefined("attributes.event") and attributes.event is "add") or not isdefined("attributes.event")>
			return true;
		<cfelseif isdefined("attributes.event") and attributes.event is "upd">
			return control_account_process(<cfoutput>'#attributes.id#','#get_action_detail.payroll_type#'</cfoutput>);
		</cfif>
	}
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
	WOStruct['#attributes.fuseaction#']['add']['fuseaction'] = 'cheque.form_add_payroll_entry';
	WOStruct['#attributes.fuseaction#']['add']['filePath'] = 'cheque/form/add_payroll_entry.cfm';
	WOStruct['#attributes.fuseaction#']['add']['queryPath'] = 'cheque/query/add_payroll_entry.cfm';
	WOStruct['#attributes.fuseaction#']['add']['nextEvent'] = 'cheque.form_add_payroll_entry&event=upd';
	WOStruct['#attributes.fuseaction#']['add']['js'] = "javascript:gizle_goster_ikili('payroll_entry','payroll_entry_bask')";
	
	WOStruct['#attributes.fuseaction#']['upd'] = structNew();
	WOStruct['#attributes.fuseaction#']['upd']['window'] = 'normal';
	WOStruct['#attributes.fuseaction#']['upd']['fuseaction'] = 'cheque.form_add_payroll_entry';
	WOStruct['#attributes.fuseaction#']['upd']['filePath'] = 'cheque/form/upd_payroll_entry.cfm';
	WOStruct['#attributes.fuseaction#']['upd']['queryPath'] = 'cheque/query/upd_payroll_entry.cfm';
	WOStruct['#attributes.fuseaction#']['upd']['nextEvent'] = 'cheque.form_add_payroll_entry&event=upd';
	WOStruct['#attributes.fuseaction#']['upd']['parameters'] = 'id=##attributes.id##';
	WOStruct['#attributes.fuseaction#']['upd']['Identity'] = '##attributes.id##';
	WOStruct['#attributes.fuseaction#']['upd']['js'] = "javascript:gizle_goster_ikili('payroll_entry','payroll_entry_bask')";

	WOStruct['#attributes.fuseaction#']['det'] = structNew();
	WOStruct['#attributes.fuseaction#']['det']['window'] = 'popup';
	WOStruct['#attributes.fuseaction#']['det']['fuseaction'] = 'cheque.popup_upd_payroll_entry_';
	WOStruct['#attributes.fuseaction#']['det']['filePath'] = 'cheque/form/upd_payroll_entry_.cfm';
	WOStruct['#attributes.fuseaction#']['det']['Identity'] = '##attributes.id##';	
	
	if(attributes.event is 'upd' or attributes.event is 'del')
	{
		WOStruct['#attributes.fuseaction#']['del'] = structNew();
		WOStruct['#attributes.fuseaction#']['del']['window'] = 'emptypopup';
		WOStruct['#attributes.fuseaction#']['del']['fuseaction'] = 'cheque.del_payroll&id=#attributes.id#&head=#get_action_detail.PAYROLL_NO#&cheque_base_acc=#get_action_detail.CHEQUE_BASED_ACC_CARI#';
		WOStruct['#attributes.fuseaction#']['del']['filePath'] = 'cheque/query/del_payroll.cfm';
		WOStruct['#attributes.fuseaction#']['del']['queryPath'] = 'cheque/query/del_payroll.cfm';
		WOStruct['#attributes.fuseaction#']['del']['nextEvent'] = 'cheque.list_cheque_actions';
	}
	/*
	WOStruct['#attributes.fuseaction#']['list'] = structNew();
	WOStruct['#attributes.fuseaction#']['list']['window'] = 'normal';
	WOStruct['#attributes.fuseaction#']['list']['fuseaction'] = 'cheque.list_cheque_actions';
	WOStruct['#attributes.fuseaction#']['list']['filePath'] = 'cheque/display/list_cheque_actions.cfm';
	*/
	if(attributes.event is 'add')
	{
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['add'] = structNew();
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['add']['menus'] = structNew();
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['add']['menus'][0]['text'] = '#lang_array_main.item[2576]#';
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['add']['menus'][0]['onClick'] = "openBox('#request.self#?fuseaction=cheque.popup_add_payroll_entry_file&cash_currency='+document.getElementById('cash_id').value+'',this,'payroll_entry_file')";
		tabMenuData = SerializeJSON(tabMenuStruct['#attributes.fuseaction#']['tabMenus']);
	}
	else if(attributes.event is 'upd')
	{		
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd'] = structNew();
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'] = structNew();
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][0]['text'] = '#lang_array_main.item[1966]#';
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][0]['customTag'] = '<cf_get_workcube_related_acts period_id="#session.ep.period_id#" company_id="#session.ep.company_id#" asset_cat_id="-17" module_id="21" action_section="PAYROLL" action_id="#attributes.id#">';
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][1]['text'] = '#lang_array_main.item[1040]#';
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][1]['onClick'] = "windowopen('#request.self#?fuseaction=objects.popup_list_order_account_cards&payroll_id=#attributes.id#&action_id=#attributes.id#&process_cat=#get_action_detail.PAYROLL_TYPE#','wide')";
		
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons'] = structNew();
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['add']['text'] = '#lang_array_main.item[170]#';
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['add']['href'] = "#request.self#?fuseaction=cheque.form_add_payroll_entry";
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['add']['target'] = "_blank";
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['print']['text'] = '#lang_array_main.item[62]#';
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['print']['onClick'] = "windowopen('#request.self#?fuseaction=objects.popup_print_files&action_id=#attributes.id#&print_type=111','page')";
		tabMenuData = SerializeJSON(tabMenuStruct['#attributes.fuseaction#']['tabMenus']);
	}

</cfscript>
