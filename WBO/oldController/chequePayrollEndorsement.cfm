<cf_get_lang_set module_name="cheque">
<cf_xml_page_edit fuseact="cheque.form_add_payroll_endorsement">
<cfset form_name = "form_payroll_revenue">
<cfif (isdefined("attributes.event") and attributes.event is "add") or not isdefined("attributes.event")>
	<cfinclude template="../cheque/query/get_control.cfm">
	<cfif isdefined("attributes.order_id") and len(attributes.order_id)>
        <cfif isdefined("attributes.to_company_id") and len(attributes.to_company_id)>
            <cfset to_company= get_par_info(attributes.to_company_id,1,1,0)>
            <cfset member_type="partner"> 
            <cfset member_code_ = get_company_period(attributes.to_company_id)>
        <cfelseif isdefined("attributes.to_employee_id") and len(attributes.to_employee_id)>
            <cfif listlen(attributes.to_employee_id,'_') eq 2>
                <cfset to_company= get_emp_info(listfirst(attributes.to_employee_id,'_'),0,0,0,listlast(attributes.to_employee_id,'_'))>
                <cfset attributes.to_employee_id = listfirst(attributes.to_employee_id,'_')>
            <cfelse>
                <cfset to_company= get_emp_info(attributes.to_employee_id,0,0)>
            </cfif>
            <cfset member_type="employee"> 
            <cfset member_code_ = get_employee_period(attributes.to_employee_id)>
        <cfelseif isdefined("attributes.to_consumer_id") and len(attributes.to_consumer_id)>
            <cfset to_company= get_cons_info(attributes.to_consumer_id,0,0)>
            <cfset member_type="consumer"> 
            <cfset member_code_ = get_consumer_period(attributes.to_consumer_id)>
        </cfif>
    </cfif>
<cfelseif isdefined("attributes.event") and attributes.event is "upd">
	<cfif isnumeric(attributes.id)>
        <cfquery name="GET_ACTION_DETAIL" datasource="#DSN2#">
            SELECT 
                P.*,
                PP.PROJECT_HEAD,
                RC.CONTRACT_HEAD
            FROM
                PAYROLL P
                LEFT JOIN #dsn_alias#.PRO_PROJECTS PP ON PP.PROJECT_ID = P.PROJECT_ID
                LEFT JOIN #dsn3_alias#.RELATED_CONTRACT RC ON RC.CONTRACT_ID = P.CONTRACT_ID
            WHERE
                P.ACTION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.id#"> AND
                P.PAYROLL_TYPE = 91 
            <cfif fusebox.circuit is "store">
                AND P.BRANCH_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#ListGetAt(session.ep.user_location,2,"-")#">
            </cfif>		
        </cfquery>
    <cfelse>
        <cfset get_action_detail.recordcount = 0>
    </cfif>
<cfelseif isdefined("attributes.event") and attributes.event is "det">
	<cfif isdefined("attributes.id")>
        <cfset attributes.CHEQUE_PAYROLL_ID = attributes.id>
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
        SELECT * FROM PAYROLL WHERE ACTION_ID=#URL.ID# AND PAYROLL_TYPE = 91
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
            CHEQUE_HISTORY.PAYROLL_ID = #attributes.CHEQUE_PAYROLL_ID# AND 
            (CHEQUE_HISTORY.STATUS = 4 OR CHEQUE_HISTORY.STATUS = 6) AND 
            CHEQUE.CHEQUE_ID = CHEQUE_HISTORY.CHEQUE_ID
    </cfquery>
</cfif>
<script type="text/javascript">
	<cfif isdefined("attributes.event") and attributes.event is "upd">
		function delete_action()
		{
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
		<cfif isdefined("attributes.order_id")>
			if(document.all.other_payroll_currency.value != document.form_payroll_revenue.order_money_type.value)
			{
				alert("<cf_get_lang no='291.Bordronun İşlem Para Birimi Ödeme Emrinin Para Biriminden Farklı Olamaz'> !");
				return false;
			}
			if(filterNum(document.all.other_payroll_total.value) != abs(document.form_payroll_revenue.order_amount.value))
			{
				alert("<cf_get_lang no='292.Bordronun Tutarı Ödeme Emrinin Tutarından Farklı Olamaz'> !");
				return false;
			}
		</cfif>
		if (!chk_process_cat('form_payroll_revenue')) return false;
		if(!check_display_files('form_payroll_revenue')) return false;
		if (!chk_period(form_payroll_revenue.payroll_revenue_date, 'İşlem')) return false;
		if(form_payroll_revenue.company_name.value=='' || (form_payroll_revenue.consumer_id.value=='' && form_payroll_revenue.company_id.value=='' && form_payroll_revenue.employee_id.value==''))
		{
			alert("<cf_get_lang dictionary_id='50081.Cari Hesap Seçiniz'>!");
			return false;
		}
		if(document.all.cheque_num.value == 0)
		{
			alert("<cf_get_lang no='28.Çek Seçiniz veya Çek Ekleyiniz !'>");
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
		<cfelseif isdefined("attributes.event") and attributes.event is "upd">
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
						alert("<cf_get_lang no='12.İşlem Tarihi Seçilen Çeklerin Son İşlem Tarihinden Önce Olamaz'>!");
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
	WOStruct['#attributes.fuseaction#']['add']['fuseaction'] = 'cheque.form_add_payroll_endorsement';
	WOStruct['#attributes.fuseaction#']['add']['filePath'] = 'cheque/form/add_payroll_endorsement.cfm';
	WOStruct['#attributes.fuseaction#']['add']['queryPath'] = 'cheque/query/add_payroll_endorsement.cfm';
	WOStruct['#attributes.fuseaction#']['add']['nextEvent'] = 'cheque.form_add_payroll_endorsement&event=upd';
	WOStruct['#attributes.fuseaction#']['add']['js'] = "javascript:gizle_goster_ikili('payroll_endorsement','payroll_endorsement_bask')";
	
	WOStruct['#attributes.fuseaction#']['upd'] = structNew();
	WOStruct['#attributes.fuseaction#']['upd']['window'] = 'normal';
	WOStruct['#attributes.fuseaction#']['upd']['fuseaction'] = 'cheque.form_add_payroll_endorsement';
	WOStruct['#attributes.fuseaction#']['upd']['filePath'] = 'cheque/form/upd_payroll_endorsement.cfm';
	WOStruct['#attributes.fuseaction#']['upd']['queryPath'] = 'cheque/query/upd_payroll_endorsement.cfm';
	WOStruct['#attributes.fuseaction#']['upd']['nextEvent'] = 'cheque.form_add_payroll_endorsement&event=upd';
	WOStruct['#attributes.fuseaction#']['upd']['parameters'] = 'id=##attributes.id##';
	WOStruct['#attributes.fuseaction#']['upd']['Identity'] = '##attributes.id##';
	WOStruct['#attributes.fuseaction#']['upd']['js'] = "javascript:gizle_goster_ikili('payroll_endorsement','payroll_endorsement_bask')";
	
	WOStruct['#attributes.fuseaction#']['det'] = structNew();
	WOStruct['#attributes.fuseaction#']['det']['window'] = 'popup';
	WOStruct['#attributes.fuseaction#']['det']['fuseaction'] = 'cheque.popup_upd_payroll_endorsement_';
	WOStruct['#attributes.fuseaction#']['det']['filePath'] = 'cheque/form/upd_payroll_endorsement_.cfm';
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
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['add']['href'] = "#request.self#?fuseaction=cheque.form_add_payroll_endorsement";
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['add']['target'] = "_blank";
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['print']['text'] = '#lang_array_main.item[62]#';
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['print']['onClick'] = "windowopen('#request.self#?fuseaction=objects.popup_print_files&action_id=#attributes.id#&print_type=112','page')";
		tabMenuData = SerializeJSON(tabMenuStruct['#attributes.fuseaction#']['tabMenus']);
	}

</cfscript>
