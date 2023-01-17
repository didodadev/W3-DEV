<cf_get_lang_set module_name="cheque">
<cf_xml_page_edit fuseact="cheque.form_add_voucher_payroll_endorsement">
<cfset form_name = "form_payroll_revenue">
<cfif (isdefined("attributes.event") and attributes.event is "add") or not isdefined("attributes.event")>
    <cfinclude template="../cheque/query/get_control.cfm">
    <cfinclude template="../cheque/query/get_voucher_cashes.cfm">
<cfelseif isdefined("attributes.event") and attributes.event is "upd">
    <cfinclude template="../cheque/query/get_cashes.cfm">
    <cfif isnumeric(attributes.id)>
        <cfquery name="GET_ACTION_DETAIL" datasource="#DSN2#">
            SELECT
                VP.*,
                PP.PROJECT_HEAD,
                RC.CONTRACT_HEAD
            FROM
                VOUCHER_PAYROLL VP
                LEFT JOIN #dsn_alias#.PRO_PROJECTS PP ON PP.PROJECT_ID = VP.PROJECT_ID
                LEFT JOIN #dsn3_alias#.RELATED_CONTRACT RC ON RC.CONTRACT_ID = VP.CONTRACT_ID
            WHERE
                VP.ACTION_ID = #attributes.id# AND
                VP.PAYROLL_TYPE = 98
            <cfif fusebox.circuit is "store">
                AND VP.BRANCH_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#ListGetAt(session.ep.user_location,2,"-")#">
            </cfif>		
        </cfquery>
    <cfelse>
        <cfset get_action_detail.recordcount = 0>
    </cfif>
    <cfif get_action_detail.recordcount>
		<cfset session.voucher.rev_date = createodbcdatetime(get_action_detail.payroll_revenue_date)>
    	<cfset session.voucher.bordro_type = "4,6">
    </cfif>
</cfif>
<script type="text/javascript">
	<cfif isdefined("attributes.event") and attributes.event is "upd">
		function delete_action()
		{
			if (!chk_period(form_payroll_revenue.payroll_revenue_date, 'İşlem')) return false;	
			if (document.all.del_flag.value != 0)//basket_voucher da tutuluyor
			{
				alert("<cf_get_lang no='61.İşlem Görmüş Senetler Var, Bordroyu Silemezsiniz !'>");
				return false;
			}
			return control_account_process(<cfoutput>'#attributes.id#','#get_action_detail.payroll_type#'</cfoutput>);
		}
	</cfif>
	function check()
	{
		if(!chk_process_cat('form_payroll_revenue')) return false;
		if(!check_display_files('form_payroll_revenue')) return false;
		
		<cfif (isdefined("attributes.event") and attributes.event is "add") or not isdefined("attributes.event")>
			if(!chk_period(form_payroll_revenue.payroll_revenue_date, 'İşlem')) return false;
		</cfif>
		
		if((document.form_payroll_revenue.company_id.value=="" && document.form_payroll_revenue.consumer_id.value=="" && document.form_payroll_revenue.employee_id.value=="") || document.getElementById('company_name').value=='')
		{
			alert("<cf_get_lang_main no ='2570.Geçerli cari hesap giriniz'>!");
			return false;
		}
		if(document.all.voucher_num.value == 0)
		{
			alert("<cf_get_lang no='127.Senet Seçiniz veya Senet Ekleyiniz !'>");
			return false;
		}
		<cfif (isdefined("attributes.event") and attributes.event is "add") or not isdefined("attributes.event")>
			process=document.form_payroll_revenue.process_cat.value;
			var get_process_cat = wrk_safe_query('chq_get_process_cat','dsn3',0,process);
			if(get_process_cat.IS_ACCOUNT ==1)
			{
				if (document.form_payroll_revenue.member_code.value=="")
				{ 
					alert ("<cf_get_lang no='126.Seçtiğiniz Üyenin Muhasebe Kodu Secilmemiş !'>");
					return false;
				}
			}
		</cfif>
		<cfif x_select_type_info eq 2>
			if(document.getElementById('special_definition_id').value == "")
			{
				alert("<cf_get_lang no='71.Ödeme Tipi Seçiniz'> !");
				return false;
			}
		</cfif>
		var kontrol_process_date = document.all.kontrol_process_date.value;
		if(kontrol_process_date != '')
		{
			var liste_uzunlugu = list_len(kontrol_process_date);
			for(var str_i_row=1; str_i_row <= liste_uzunlugu; str_i_row++)
				{
					var tarih_ = list_getat(kontrol_process_date,str_i_row,',');
					var sonuc_ = datediff(document.all.payroll_revenue_date.value,tarih_,0);
					if(sonuc_ > 0)
						{
							alert("<cf_get_lang no='13.İşlem Tarihi Seçilen Senetlerin Son İşlem Tarihinden Önce Olamaz'>!");
							return false;
						}
				}
		}
		for(kk=1;kk<=document.all.kur_say.value;kk++)
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
	WOStruct['#attributes.fuseaction#']['add']['fuseaction'] = 'cheque.form_add_voucher_payroll_endorsement';
	WOStruct['#attributes.fuseaction#']['add']['filePath'] = 'cheque/form/add_voucher_payroll_endorsement.cfm';
	WOStruct['#attributes.fuseaction#']['add']['queryPath'] = 'cheque/query/add_voucher_payroll_endorsement.cfm';
	WOStruct['#attributes.fuseaction#']['add']['nextEvent'] = 'cheque.form_add_voucher_payroll_endorsement&event=upd';
	WOStruct['#attributes.fuseaction#']['add']['js'] = "javascript:gizle_goster_ikili('voucher_payroll_endorsement','voucher_payroll_endorsement_bask')";
	
	WOStruct['#attributes.fuseaction#']['upd'] = structNew();
	WOStruct['#attributes.fuseaction#']['upd']['window'] = 'normal';
	WOStruct['#attributes.fuseaction#']['upd']['fuseaction'] = 'cheque.form_add_voucher_payroll_endorsement';
	WOStruct['#attributes.fuseaction#']['upd']['filePath'] = 'cheque/form/upd_voucher_payroll_endorsement.cfm';
	WOStruct['#attributes.fuseaction#']['upd']['queryPath'] = 'cheque/query/upd_voucher_payroll_endorsement.cfm';
	WOStruct['#attributes.fuseaction#']['upd']['nextEvent'] = 'cheque.form_add_voucher_payroll_endorsement&event=upd';
	WOStruct['#attributes.fuseaction#']['upd']['parameters'] = 'id=##attributes.id##';
	WOStruct['#attributes.fuseaction#']['upd']['Identity'] = '##attributes.id##';
	WOStruct['#attributes.fuseaction#']['upd']['js'] = "javascript:gizle_goster_ikili('voucher_payroll_endorsement','voucher_payroll_endorsement_bask')";
	
	if(not attributes.event is 'add')
	{
		WOStruct['#attributes.fuseaction#']['del'] = structNew();
		WOStruct['#attributes.fuseaction#']['del']['window'] = 'emptypopup';
		WOStruct['#attributes.fuseaction#']['del']['fuseaction'] = 'cheque.del_voucher_payroll&id=#attributes.id#&head=#get_action_detail.PAYROLL_NO#';
		WOStruct['#attributes.fuseaction#']['del']['filePath'] = 'cheque/query/del_voucher_payroll.cfm';
		WOStruct['#attributes.fuseaction#']['del']['queryPath'] = 'cheque/query/del_voucher_payroll.cfm';
		WOStruct['#attributes.fuseaction#']['del']['nextEvent'] = 'cheque.list_voucher_actions';
	}
	if(attributes.event is 'upd')
	{		
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd'] = structNew();
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'] = structNew();
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][0]['text'] = '#lang_array_main.item[1966]#';
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][0]['customTag'] = '<cf_get_workcube_related_acts period_id="#session.ep.period_id#" company_id="#session.ep.company_id#" asset_cat_id="-17" module_id="21" action_section="VOUCHER_PAYROLL" action_id="#attributes.id#">';
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][1]['text'] = '#lang_array_main.item[1040]#';
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][1]['onClick'] = "windowopen('#request.self#?fuseaction=objects.popup_list_order_account_cards&voucher_payroll_id=#attributes.id#&action_id=#attributes.id#&process_cat=#get_action_detail.PAYROLL_TYPE#','wide')";
		
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons'] = structNew();
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['add']['text'] = '#lang_array_main.item[170]#';
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['add']['href'] = "#request.self#?fuseaction=cheque.form_add_voucher_payroll_endorsement";
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['add']['target'] = "_blank";
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['print']['text'] = '#lang_array_main.item[62]#';
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['print']['onClick'] = "windowopen('#request.self#?fuseaction=objects.popup_print_files&action_id=#attributes.id#&print_type=114','page')";
		tabMenuData = SerializeJSON(tabMenuStruct['#attributes.fuseaction#']['tabMenus']);
	}
</cfscript>
