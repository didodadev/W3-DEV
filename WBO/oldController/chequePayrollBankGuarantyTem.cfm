<cf_get_lang_set module_name="cheque">
<cf_xml_page_edit fuseact="cheque.form_add_payroll_bank_guaranty_tem">
<cfinclude template="../cheque/query/get_money2.cfm">
<cfset form_name = "form_payroll_revenue">
<cfquery name="GET_EXPENSE_CENTER" datasource="#dsn2#">
	SELECT EXPENSE_ID,EXPENSE,EXPENSE_CODE FROM EXPENSE_CENTER ORDER BY EXPENSE
</cfquery>
<cfif (isdefined("attributes.event") and attributes.event is "add") or not isdefined("attributes.event")>
    <cfinclude template="../cheque/query/get_control.cfm">
    <cfinclude template="../cheque/query/get_cashes.cfm">
<cfelseif isdefined("attributes.event") and attributes.event is "upd">
	<cfif isnumeric(attributes.id)>
        <cfquery name="GET_ACTION_DETAIL" datasource="#DSN2#">
            SELECT
                P.*,
                CL.CREDIT_LIMIT_ID,
                CL.LIMIT_HEAD,
                RC.CONTRACT_HEAD
            FROM
                PAYROLL P
                LEFT JOIN #dsn3_alias#.CREDIT_LIMIT CL ON CL.CREDIT_LIMIT_ID = P.CREDIT_LIMIT
                LEFT JOIN #dsn3_alias#.RELATED_CONTRACT RC ON RC.CONTRACT_ID = P.CONTRACT_ID
            WHERE 
                P.ACTION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.id#"> AND
                P.PAYROLL_TYPE = 133
            <cfif fusebox.circuit is "store">
                AND P.BRANCH_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#ListGetAt(session.ep.user_location,2,"-")#">
            </cfif>
        </cfquery>
    <cfelse>
        <cfset get_action_detail.recordcount = 0>
    </cfif>
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
        SELECT * FROM PAYROLL WHERE ACTION_ID=#URL.ID# AND PAYROLL_TYPE = 133
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
            STATUS = 13 AND
            CHEQUE.CHEQUE_ID = CHEQUE_HISTORY.CHEQUE_ID
    </cfquery>
</cfif>
<script type="text/javascript">
	<cfif isdefined("attributes.event") and attributes.event is "upd">
		function delete_action()
		{
			if (!chk_period(form_payroll_revenue.payroll_revenue_date, 'İşlem')) return false;	
			if (document.all.del_flag.value != 0)//basket_cheque de tutuluyor
			{
				alert("<cf_get_lang no='61.İşlem Görmüş Çekler Var Bordroyu Silemezsiniz !'>");
				return false;
			}
			return control_account_process(<cfoutput>'#attributes.id#','#get_action_detail.payroll_type#'</cfoutput>);
		}
	</cfif>
	function kontrol()
	{
		if (!chk_process_cat('form_payroll_revenue')) return false;
		if(!check_display_files('form_payroll_revenue')) return false;
		if(!chk_period(form_payroll_revenue.payroll_revenue_date, 'İşlem')) return false;
		if(document.all.cheque_num.value == 0)
		{
			alert("<cf_get_lang no='28.Çek Seçiniz veya Çek Ekleyiniz !'>");
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
						alert("<cf_get_lang no='12.İşlem Tarihi Seçilen Çeklerin Son İşlem Tarihinden Önce Olamaz'>!");
						return false;
					}
				}
		}
		if(document.form_payroll_revenue.masraf.value != "" && filterNum(document.form_payroll_revenue.masraf.value,2)> 0)
		{
			if(document.form_payroll_revenue.exp_item_id.value == "" || document.form_payroll_revenue.exp_item_name.value == "")
			{
				alert("<cf_get_lang no ='173.Gider Kalemi Seçiniz'>!");
				return false;
			}
			if(document.form_payroll_revenue.expense_center.value == "")
			{
				alert("<cf_get_lang no ='174.Masraf Merkezi Seçiniz'>!");
				return false;
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
	WOStruct['#attributes.fuseaction#']['add']['fuseaction'] = 'cheque.form_add_payroll_bank_guaranty_tem';
	WOStruct['#attributes.fuseaction#']['add']['filePath'] = 'cheque/form/add_payroll_bank_guaranty_tem.cfm';
	WOStruct['#attributes.fuseaction#']['add']['queryPath'] = 'cheque/query/add_payroll_bank_guaranty_tem.cfm';
	WOStruct['#attributes.fuseaction#']['add']['nextEvent'] = 'cheque.form_add_payroll_bank_guaranty_tem&event=upd';
	WOStruct['#attributes.fuseaction#']['add']['js'] = "javascript:gizle_goster_ikili('payroll_bank_quaranty_team','payroll_bank_quaranty_team_bask_bask')";
	
	WOStruct['#attributes.fuseaction#']['upd'] = structNew();
	WOStruct['#attributes.fuseaction#']['upd']['window'] = 'normal';
	WOStruct['#attributes.fuseaction#']['upd']['fuseaction'] = 'cheque.form_add_payroll_bank_guaranty_tem';
	WOStruct['#attributes.fuseaction#']['upd']['filePath'] = 'cheque/form/upd_payroll_bank_guaranty_tem.cfm';
	WOStruct['#attributes.fuseaction#']['upd']['queryPath'] = 'cheque/query/upd_payroll_bank_guaranty_tem.cfm';
	WOStruct['#attributes.fuseaction#']['upd']['nextEvent'] = 'cheque.form_add_payroll_bank_guaranty_tem&event=upd';
	WOStruct['#attributes.fuseaction#']['upd']['parameters'] = 'id=##attributes.id##';
	WOStruct['#attributes.fuseaction#']['upd']['Identity'] = '##attributes.id##';
	WOStruct['#attributes.fuseaction#']['upd']['js'] = "javascript:gizle_goster_ikili('payroll_bank_quaranty_team','payroll_bank_quaranty_team_bask')";
	
	WOStruct['#attributes.fuseaction#']['det'] = structNew();
	WOStruct['#attributes.fuseaction#']['det']['window'] = 'popup';
	WOStruct['#attributes.fuseaction#']['det']['fuseaction'] = 'cheque.popup_upd_payroll_bank_guaranty_tem_';
	WOStruct['#attributes.fuseaction#']['det']['filePath'] = 'cheque/form/upd_payroll_bank_guaranty_tem_.cfm';
	WOStruct['#attributes.fuseaction#']['det']['Identity'] = '##attributes.id##';

	if(attributes.event is 'upd' or attributes.event is 'del')
	{
		WOStruct['#attributes.fuseaction#']['del'] = structNew();
		WOStruct['#attributes.fuseaction#']['del']['window'] = 'emptypopup';
		WOStruct['#attributes.fuseaction#']['del']['fuseaction'] = 'cheque.del_payroll&id=#attributes.id#&head=#get_action_detail.PAYROLL_NO#';
		WOStruct['#attributes.fuseaction#']['del']['filePath'] = 'cheque/query/del_payroll.cfm';
		WOStruct['#attributes.fuseaction#']['del']['queryPath'] = 'cheque/query/del_payroll.cfm';
		WOStruct['#attributes.fuseaction#']['del']['nextEvent'] = 'cheque.list_cheque_actions';
	}
	if(attributes.event is 'upd')
	{		
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd'] = structNew();
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'] = structNew();
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][0]['text'] = '#lang_array_main.item[1966]#';
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][0]['customTag'] = '<cf_get_workcube_related_acts period_id="#session.ep.period_id#" company_id="#session.ep.company_id#" asset_cat_id="-17" module_id="21" action_section="PAYROLL" action_id="#attributes.id#">';
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][1]['text'] = '#lang_array_main.item[2582]#';
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][1]['onClick'] = "windowopen('#request.self#?fuseaction=objects.popup_list_order_account_cards&payroll_id=#attributes.id#&action_id=#attributes.id#&process_cat=#get_action_detail.PAYROLL_TYPE#','wide')";
		
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons'] = structNew();
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['add']['text'] = '#lang_array_main.item[170]#';
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['add']['href'] = "#request.self#?fuseaction=cheque.form_add_payroll_bank_guaranty_tem";
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['add']['target'] = "_blank";
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['print']['text'] = '#lang_array_main.item[62]#';
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['print']['onClick'] = "windowopen('#request.self#?fuseaction=objects.popup_print_files&action_id=#attributes.id#&print_type=112','page')";
		tabMenuData = SerializeJSON(tabMenuStruct['#attributes.fuseaction#']['tabMenus']);
	}

</cfscript>
