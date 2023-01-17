<cf_get_lang_set module_name="cheque">
<cfinclude template="../cheque/query/get_voucher_cashes.cfm">
<cfinclude template="../cheque/query/get_money2.cfm">
<cfquery name="GET_EXPENSE_CENTER" datasource="#dsn2#">
    SELECT EXPENSE_ID,EXPENSE,EXPENSE_CODE FROM EXPENSE_CENTER ORDER BY EXPENSE
</cfquery>
<cfif (isdefined("attributes.event") and attributes.event is "add") or not isdefined("attributes.event")>
	<cfinclude template="../cheque/query/get_control.cfm">
<cfelseif isdefined("attributes.event") and attributes.event is "upd">
	<cfif isnumeric(attributes.id)>
        <cfquery name="GET_ACTION_DETAIL" datasource="#DSN2#">
            SELECT
                VP.*,
                EI.EXPENSE_ITEM_NAME
            FROM
                VOUCHER_PAYROLL VP
                LEFT JOIN EXPENSE_ITEMS EI ON EI.EXPENSE_ITEM_ID = VP.EXP_ITEM_ID
            WHERE
                VP.ACTION_ID = #attributes.id# AND
                VP.PAYROLL_TYPE = 104
            <cfif fusebox.circuit is "store">
                AND VP.BRANCH_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#ListGetAt(session.ep.user_location,2,"-")#">
            </cfif>		
        </cfquery>
    <cfelse>
        <cfset get_action_detail.recordcount = 0>
    </cfif>
</cfif>
<cfset form_name = "form_payroll_revenue">
<script type="text/javascript">
	<cfif isdefined("attributes.event") and attributes.event is "upd">
		function delete_action()
		{
			if (!chk_period(form_payroll_revenue.payroll_revenue_date, 'İşlem')) return false;	
			if (document.all.del_flag.value != 0)
			{
				alert("<cf_get_lang no='61.İşlem Görmüş Senetler Var, Bordroyu Silemezsiniz !'>");
				return false;
			}
			return control_account_process(<cfoutput>'#attributes.id#','#get_action_detail.payroll_type#'</cfoutput>);
		}	
	</cfif>
	function check()
	{
		if (!chk_process_cat('form_payroll_revenue')) return false;
		if(!check_display_files('form_payroll_revenue')) return false;
		if(!chk_period(form_payroll_revenue.payroll_revenue_date, 'İşlem')) return false;	
		if(document.form_payroll_revenue.masraf.value != "" && filterNum(document.form_payroll_revenue.masraf.value,2)> 0)
		{
			if(document.form_payroll_revenue.expense_center.value == "")
			{
				alert("<cf_get_lang no ='174.Masraf Merkezi Seçiniz'>!");
				return false;
			}
			if(document.form_payroll_revenue.exp_item_id.value == "" || document.form_payroll_revenue.exp_item_name.value == "")
			{
				alert("<cf_get_lang no ='173.Gider Kalemi Seçiniz'>!");
				return false;
			}
		}					
		if(document.all.voucher_num.value == 0)
		{
			alert("<cf_get_lang no='127.Senet Seçiniz veya Senet Ekleyiniz !'>");
			return false;
		}
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
		upd_masraf_value();
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
	function upd_masraf_value()
	{
		if (document.getElementById('masraf').value == '')	document.getElementById('masraf').value = 0;
		for(i=1; i<=form_payroll_revenue.kur_say.value; i++)
		{		
			rate2=filterNum(eval('form_payroll_revenue.txt_rate2_' + i + '.value'),'<cfoutput>#session.ep.our_company_info.rate_round_num#</cfoutput>');
			rate1=filterNum(eval('form_payroll_revenue.txt_rate1_' + i + '.value'),'<cfoutput>#session.ep.our_company_info.rate_round_num#</cfoutput>');
			rd_money=eval('form_payroll_revenue.hidden_rd_money_' + i + '.value');
			if(document.form_payroll_revenue.masraf_currency[document.form_payroll_revenue.masraf_currency.options.selectedIndex].value == rd_money)
				document.form_payroll_revenue.sistem_masraf_tutari.value=wrk_round(filterNum(form_payroll_revenue.masraf.value)*(rate2/rate1));
		}
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
	WOStruct['#attributes.fuseaction#']['add']['fuseaction'] = 'cheque.form_add_voucher_payroll_revenue';
	WOStruct['#attributes.fuseaction#']['add']['filePath'] = 'cheque/form/add_payroll_voucher_revenue.cfm';
	WOStruct['#attributes.fuseaction#']['add']['queryPath'] = 'cheque/query/add_payroll_voucher_revenue.cfm';
	WOStruct['#attributes.fuseaction#']['add']['nextEvent'] = 'cheque.form_add_voucher_payroll_revenue&event=upd';
	WOStruct['#attributes.fuseaction#']['add']['js'] = "javascript:gizle_goster_ikili('voucher_revenue','voucher_revenue_bask')";
	
	WOStruct['#attributes.fuseaction#']['upd'] = structNew();
	WOStruct['#attributes.fuseaction#']['upd']['window'] = 'normal';
	WOStruct['#attributes.fuseaction#']['upd']['fuseaction'] = 'cheque.form_add_voucher_payroll_revenue';
	WOStruct['#attributes.fuseaction#']['upd']['filePath'] = 'cheque/form/upd_payroll_voucher_revenue.cfm';
	WOStruct['#attributes.fuseaction#']['upd']['queryPath'] = 'cheque/query/upd_payroll_voucher_revenue.cfm';
	WOStruct['#attributes.fuseaction#']['upd']['nextEvent'] = 'cheque.form_add_voucher_payroll_revenue&event=upd';
	WOStruct['#attributes.fuseaction#']['upd']['parameters'] = 'id=##attributes.id##';
	WOStruct['#attributes.fuseaction#']['upd']['Identity'] = '##attributes.id##';
	WOStruct['#attributes.fuseaction#']['upd']['js'] = "javascript:gizle_goster_ikili('voucher_revenue','voucher_revenue_bask')";
	
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
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][1]['text'] = '#lang_array_main.item[2582]#';
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][1]['onClick'] = "windowopen('#request.self#?fuseaction=objects.popup_list_order_account_cards&voucher_payroll_id=#attributes.id#&action_id=#attributes.id#&process_cat=#get_action_detail.PAYROLL_TYPE#','wide')";
		
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons'] = structNew();
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['add']['text'] = '#lang_array_main.item[170]#';
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['add']['href'] = "#request.self#?fuseaction=cheque.form_add_voucher_payroll_revenue";
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['add']['target'] = "_blank";
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['print']['text'] = '#lang_array_main.item[62]#';
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['print']['onClick'] = "windowopen('#request.self#?fuseaction=objects.popup_print_files&action_id=#attributes.id#&print_type=114','page')";
		tabMenuData = SerializeJSON(tabMenuStruct['#attributes.fuseaction#']['tabMenus']);
	}

</cfscript>
