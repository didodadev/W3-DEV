<cf_get_lang_set module_name="cheque">
<cf_xml_page_edit fuseact="cheque.form_add_voucher_payroll_entry">
<cfinclude template="../cheque/query/get_voucher_cashes.cfm">
<cfset form_name = "form_payroll_basket">
<cfif (isdefined("attributes.event") and attributes.event is "add") or not isdefined("attributes.event")>
	<cfinclude template="../cheque/query/get_control.cfm">
<cfelseif isdefined("attributes.event") and attributes.event is "upd">
	<cfif isnumeric(attributes.id)>
        <cfquery name="GET_ACTION_DETAIL" datasource="#DSN2#">
            SELECT
                VP.*,
                SC.IS_UPD_CARI_ROW,
                PP.PROJECT_HEAD,
                RC.CONTRACT_HEAD,
                SP.PAYMETHOD
            FROM
                VOUCHER_PAYROLL VP
                LEFT JOIN #dsn3_alias#.SETUP_PROCESS_CAT SC ON SC.PROCESS_CAT_ID = VP.PROCESS_CAT
                LEFT JOIN #dsn_alias#.PRO_PROJECTS PP ON PP.PROJECT_ID = VP.PROJECT_ID
                LEFT JOIN #dsn3_alias#.RELATED_CONTRACT RC ON RC.CONTRACT_ID = VP.CONTRACT_ID
                LEFT JOIN #dsn_alias#.SETUP_PAYMETHOD SP ON SP.PAYMETHOD_ID = VP.PAYMETHOD_ID
            WHERE
                VP.ACTION_ID = #attributes.id# AND
                VP.PAYROLL_TYPE = 97
            <cfif fusebox.circuit is "store">
                AND VP.BRANCH_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#ListGetAt(session.ep.user_location,2,"-")#">
            </cfif>		
        </cfquery>
        <cfquery name="get_pay_vouchers" datasource="#dsn2#">
            SELECT VOUCHER_ID FROM VOUCHER WHERE VOUCHER_PAYROLL_ID = #attributes.id# AND VOUCHER_STATUS_ID = 3
        </cfquery>
    <cfelse>
        <cfset get_action_detail.recordcount = 0>
    </cfif>
</cfif>
<script type="text/javascript">
	<cfif isdefined("attributes.event") and attributes.event is "upd">
		function delete_action()
		{
			if (!chk_period(form_payroll_basket.payroll_revenue_date, 'İşlem')) return false;			
			if (document.all.del_flag.value != 0)
			{
				alert("<cf_get_lang no='61.İşlem Görmüş Senetler Var, Bordroyu Silemezsiniz !'>");
				return false;
			}
			return control_account_process(<cfoutput>'#attributes.id#','#get_action_detail.payroll_type#'</cfoutput>);
		}
	</cfif>
	function kontrol()
	{
		if (!chk_process_cat('form_payroll_basket')) return false;
		if(!check_display_files('form_payroll_basket')) return false;
		if(!chk_period(form_payroll_basket.payroll_revenue_date, 'İşlem')) return false;
		if(document.form_payroll_basket.company_id.value=="" && document.form_payroll_basket.consumer_id.value=="" && document.form_payroll_basket.employee_id.value=="" && document.getElementById('company_name').value!='')
		{
			alert("<cf_get_lang_main no ='2570.Geçerli cari hesap giriniz'>!");
			return false;
		}		
		if (document.form_payroll_basket.cash_id[document.form_payroll_basket.cash_id.selectedIndex].value == "")
		{ 
			alert ("<cf_get_lang no='127.Senet Seçiniz veya Senet Ekleyiniz !'>");
			return false;
		}
		if(document.all.voucher_num.value == 0)
		{
			alert("<cf_get_lang no='134.Senet Ekle!'>");
			return false;
		}
		process=document.form_payroll_basket.process_cat.value;
		var get_process_cat = wrk_safe_query('chq_get_process_cat','dsn3',0,process);
		if(get_process_cat.IS_CHEQUE_BASED_ACTION == 0)
		{
			kontrol_payterm = 0;
			for(ttt=1;ttt<=document.getElementById('record_num').value;ttt++)
				if(document.getElementById('row_kontrol'+ttt).value==1 &&  document.getElementById('is_pay_term'+ttt) != undefined && document.getElementById('is_pay_term'+ttt).value==1)
				{
					kontrol_payterm = 1;
					break;
				}
			if(kontrol_payterm == 1)
			{
				alert("Ödeme Sözü Ekleyebilmeniz İçin İşlem Tipinde Senet Bazında Carileştirme Seçili Olmalıdır !");
				return false;
			}
		}
		<cfif (isdefined("attributes.event") and attributes.event is "add") or not isdefined("attributes.event")>
			if(get_process_cat.IS_ACCOUNT ==1)
			{
				if (document.form_payroll_basket.member_code.value=="")
				{ 
					alert ("<cf_get_lang no='126.Seçtiğiniz Üyenin Muhasebe Kodu Secilmemiş !'>");
					return false;
				}
			}
		</cfif>
		<cfif x_select_type_info eq 2>
			if(document.getElementById('special_definition_id').value == "")
			{
				alert("<cf_get_lang no='41.Tahsilat Tipi Seçiniz'> !");
				return false;
			}
		</cfif>
		for(kk=1;kk<=document.all.kur_say.value;kk++)
		{
			cheque_rate_change(kk);
		}
		if(toplam(1,0,1)==false) return false;
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
	WOStruct['#attributes.fuseaction#']['add']['fuseaction'] = 'cheque.form_add_voucher_payroll_entry';
	WOStruct['#attributes.fuseaction#']['add']['filePath'] = 'cheque/form/add_voucher_payroll_entry.cfm';
	WOStruct['#attributes.fuseaction#']['add']['queryPath'] = 'cheque/query/add_voucher_payroll_entry.cfm';
	WOStruct['#attributes.fuseaction#']['add']['nextEvent'] = 'cheque.form_add_voucher_payroll_entry&event=upd';
	WOStruct['#attributes.fuseaction#']['add']['js'] = "javascript:gizle_goster_ikili('voucher_payroll_entry','voucher_payroll_entry_bask')";
	
	WOStruct['#attributes.fuseaction#']['upd'] = structNew();
	WOStruct['#attributes.fuseaction#']['upd']['window'] = 'normal';
	WOStruct['#attributes.fuseaction#']['upd']['fuseaction'] = 'cheque.form_add_voucher_payroll_entry';
	WOStruct['#attributes.fuseaction#']['upd']['filePath'] = 'cheque/form/upd_payroll_voucher_entry.cfm';
	WOStruct['#attributes.fuseaction#']['upd']['queryPath'] = 'cheque/query/upd_payroll_voucher_entry.cfm';
	WOStruct['#attributes.fuseaction#']['upd']['nextEvent'] = 'cheque.form_add_voucher_payroll_entry&event=upd';
	WOStruct['#attributes.fuseaction#']['upd']['parameters'] = 'id=##attributes.id##';
	WOStruct['#attributes.fuseaction#']['upd']['Identity'] = '##attributes.id##';
	WOStruct['#attributes.fuseaction#']['upd']['js'] = "javascript:gizle_goster_ikili('payroll_voucher_entry','payroll_voucher_entry_bask')";
	
	if(not attributes.event is 'add')
	{
		WOStruct['#attributes.fuseaction#']['del'] = structNew();
		WOStruct['#attributes.fuseaction#']['del']['window'] = 'emptypopup';
		WOStruct['#attributes.fuseaction#']['del']['fuseaction'] = 'cheque.del_voucher_payroll&id=#attributes.id#&head=#get_action_detail.PAYROLL_NO#';
		WOStruct['#attributes.fuseaction#']['del']['filePath'] = 'cheque/query/del_voucher_payroll.cfm';
		WOStruct['#attributes.fuseaction#']['del']['queryPath'] = 'cheque/query/del_voucher_payroll.cfm';
		WOStruct['#attributes.fuseaction#']['del']['nextEvent'] = 'cheque.list_voucher_actions';
	}
	if(attributes.event is 'add')
	{
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['add'] = structNew();
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['add']['menus'] = structNew();
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['add']['menus'][0]['text'] = '#lang_array_main.item[2576]#';
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['add']['menus'][0]['onClick'] = "openBox('#request.self#?fuseaction=cheque.popup_add_voucher_payroll_entry_file&cash_currency='+document.getElementById('cash_id').value+'',this,'voucher_payroll_entry_file')";
		tabMenuData = SerializeJSON(tabMenuStruct['#attributes.fuseaction#']['tabMenus']);
	}
	else if(attributes.event is 'upd')
	{		
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd'] = structNew();
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'] = structNew();
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][0]['text'] = '#lang_array_main.item[1966]#';
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][0]['customTag'] = '<cf_get_workcube_related_acts period_id="#session.ep.period_id#" company_id="#session.ep.company_id#" asset_cat_id="-17" module_id="21" action_section="VOUCHER_PAYROLL" action_id="#url.id#">';
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][1]['text'] = '#lang_array_main.item[1040]#';
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][1]['onClick'] = "windowopen('#request.self#?fuseaction=objects.popup_list_order_account_cards&voucher_payroll_id=#attributes.id#&action_id=#attributes.id#&process_cat=#get_action_detail.PAYROLL_TYPE#','wide')";
		
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons'] = structNew();
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['add']['text'] = '#lang_array_main.item[170]#';
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['add']['href'] = "#request.self#?fuseaction=cheque.form_add_voucher_payroll_entry";
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['add']['target'] = "_blank";
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['print']['text'] = '#lang_array_main.item[62]#';
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['print']['onClick'] = "windowopen('#request.self#?fuseaction=objects.popup_print_files&action_id=#attributes.id#&print_type=113','page')";
		tabMenuData = SerializeJSON(tabMenuStruct['#attributes.fuseaction#']['tabMenus']);
	}
</cfscript>
