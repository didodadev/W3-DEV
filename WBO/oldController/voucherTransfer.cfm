<cf_get_lang_set module_name="cheque">
<cfinclude template="../cheque/query/get_cashes.cfm">
<cfquery name="GET_TO_CASHES" datasource="#dsn2#">
	SELECT 
		* 
	FROM 
		CASH 
	WHERE 
		CASH_STATUS = 1
	ORDER BY	
		CASH_ID
</cfquery>
<cfset form_name ="form_payroll_basket">
<cfif (isdefined("attributes.event") and attributes.event is "add") or not isdefined("attributes.event")>
    <cfinclude template="../cheque/query/get_control.cfm">
    <cfset cash_status = 1>
<cfelseif isdefined("attributes.event") and attributes.event is "upd">
	<cfif isnumeric(attributes.id)>
        <cfquery name="GET_ACTION_DETAIL" datasource="#DSN2#">
            SELECT
                P.*
            FROM
                VOUCHER_PAYROLL P
            WHERE 
                P.ACTION_ID = #attributes.id# AND
                P.PAYROLL_TYPE IN(136,137)
                <cfif fusebox.circuit is "store">
                    AND P.BRANCH_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#ListGetAt(session.ep.user_location,2,"-")#">
                </cfif>		
        </cfquery>
    <cfelse>
        <cfset get_action_detail.recordcount = 0>
    </cfif>
    <cfif get_action_detail.recordcount>
		<cfif get_action_detail.process_cat eq 110>
            <cfset p_type = 113>
        <cfelseif get_action_detail.process_cat eq 109>
            <cfset p_type = 114>
        </cfif>
        <cfif get_action_detail.payroll_type eq 136>
            <cfset attributes.bordro_type = 14>
        <cfelse>
            <cfset attributes.bordro_type = '1,11'>
        </cfif>
    </cfif>
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
		document.form_payroll_basket.process_cat.disabled = false;
		if(!chk_process_cat('form_payroll_basket')) return false;
		if(!check_display_files('form_payroll_basket')) return false;
		if(!chk_period(form_payroll_basket.payroll_revenue_date, 'İşlem')) return false;
		if(document.all.voucher_num.value == 0)
		{
			alert("<cf_get_lang no='127.Senet Seçiniz veya Senet Ekleyiniz !'>");
			return false;
		}
		<cfif (isdefined("attributes.event") and attributes.event is "add") or not isdefined("attributes.event")>
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
		</cfif>
		for(kk=1;kk<=document.all.kur_say.value;kk++)
		{
			cheque_rate_change(kk);
		}
		if(toplam(1,0,1)==false)return false;
		document.form_payroll_basket.cash_id.disabled = false;
		document.form_payroll_basket.to_cash_id.disabled = false;
		<cfif (isdefined("attributes.event") and attributes.event is "add") or not isdefined("attributes.event")>
			selected_cash = list_getat((document.form_payroll_basket.cash_id.value),1,';');
			var get_cash_3 = wrk_safe_query('chq_get_cash_3_3','dsn2',0,selected_cash); 
			if(get_cash_3.TRANSFER_VOUCHER_ACC_CODE =="")
			{
					alert ("Kasaların Yoldaki Senetler Muhasebe Kodu tanımlanmamıştır !");
					return false;
			}
			return true;
		<cfelseif isdefined("attributes.event") and attributes.event is "upd">
			return control_account_process(<cfoutput>'#attributes.id#','#get_action_detail.payroll_type#'</cfoutput>);
		</cfif>
	}
	function ayarla_gizle_goster()
	{
		var selected_ptype = document.form_payroll_basket.process_cat.options[document.form_payroll_basket.process_cat.selectedIndex].value;
		if (selected_ptype != '')
			eval('var proc_control = document.form_payroll_basket.ct_process_type_'+selected_ptype+'.value');
		else
			var proc_control = '';
		<cfif fusebox.circuit is "store">
			//Eğer şube modülüyse işlem tipine göre kasasından ve kasasına seçenekleri değişiyor
			var cash_id_len = eval('document.getElementById("cash_id")').options.length;
			for(j=cash_id_len;j>=0;j--)
				eval('document.getElementById("cash_id")').options[j] = null;	
			var to_cash_id_len = eval('document.getElementById("to_cash_id")').options.length;
			for(j=to_cash_id_len;j>=0;j--)
				eval('document.getElementById("to_cash_id")').options[j] = null;	

			eval('document.getElementById("cash_id")').options[0] = new Option('Seçiniz','');
			eval('document.getElementById("to_cash_id")').options[0] = new Option('Seçiniz','');

			var get_cash_1 = wrk_safe_query('chq_get_cash_1','dsn2');
			var get_cash_2 = wrk_safe_query('chq_get_cash_2','dsn2');
			if(proc_control == 136)
			{
				document.form_payroll_basket.bordro_type.value = 14;
				for(var jj=0;jj < get_cash_2.recordcount;jj++)
					eval('document.getElementById("cash_id")').options[jj+1]=new Option(''+get_cash_2.CASH_NAME[jj]+' '+get_cash_2.CASH_CURRENCY_ID[jj]+'',''+get_cash_2.CASH_ID[jj]+';'+get_cash_2.BRANCH_ID[jj]+';'+get_cash_2.CASH_CURRENCY_ID[jj]+'');
				for(var jj=0;jj < get_cash_1.recordcount;jj++)
					eval('document.getElementById("to_cash_id")').options[jj+1]=new Option(''+get_cash_1.CASH_NAME[jj]+' '+get_cash_1.CASH_CURRENCY_ID[jj]+'',''+get_cash_1.CASH_ID[jj]+';'+get_cash_1.BRANCH_ID[jj]+';'+get_cash_1.CASH_CURRENCY_ID[jj]+'');
			}
			else if(proc_control == 137)
			{
				document.form_payroll_basket.bordro_type.value = 1;
				for(var jj=0;jj < get_cash_2.recordcount;jj++)
					eval('document.getElementById("to_cash_id")').options[jj+1]=new Option(''+get_cash_2.CASH_NAME[jj]+' '+get_cash_2.CASH_CURRENCY_ID[jj]+'',''+get_cash_2.CASH_ID[jj]+';'+get_cash_2.BRANCH_ID[jj]+';'+get_cash_2.CASH_CURRENCY_ID[jj]+'');
				for(var jj=0;jj < get_cash_1.recordcount;jj++)
					eval('document.getElementById("cash_id")').options[jj+1]=new Option(''+get_cash_1.CASH_NAME[jj]+' '+get_cash_1.CASH_CURRENCY_ID[jj]+'',''+get_cash_1.CASH_ID[jj]+';'+get_cash_1.BRANCH_ID[jj]+';'+get_cash_1.CASH_CURRENCY_ID[jj]+'');
			}
		<cfelse>
			if(proc_control == 136)
				document.form_payroll_basket.bordro_type.value = 14;
			else
				document.form_payroll_basket.bordro_type.value = 1;
		</cfif>
	}
	$(document).ready(function(){
		var selected_ptype = document.form_payroll_basket.process_cat.options[document.form_payroll_basket.process_cat.selectedIndex].value;
		if (selected_ptype != '')
			eval('var proc_control = document.form_payroll_basket.ct_process_type_'+selected_ptype+'.value');
		else
			var proc_control = '';
		<cfif (isdefined("attributes.event") and attributes.event is "add") or not isdefined("attributes.event")>
			<cfif fusebox.circuit is "store">
				//Eğer şube modülüyse işlem tipine göre kasasından ve kasasına seçenekleri değişiyor
				var cash_id_len = eval('document.getElementById("cash_id")').options.length;
				for(j=cash_id_len;j>=0;j--)
					eval('document.getElementById("cash_id")').options[j] = null;	
				var to_cash_id_len = eval('document.getElementById("to_cash_id")').options.length;
				for(j=to_cash_id_len;j>=0;j--)
					eval('document.getElementById("to_cash_id")').options[j] = null;	
		
				eval('document.getElementById("cash_id")').options[0] = new Option('Seçiniz','');
				eval('document.getElementById("to_cash_id")').options[0] = new Option('Seçiniz','');
				
				var get_cash_1 = wrk_safe_query('chq_get_cash_1','dsn2');
				var get_cash_2 = wrk_safe_query('chq_get_cash_2','dsn2');
				if(proc_control == 136)
				{
					document.form_payroll_basket.bordro_type.value = 14;
					for(var jj=0;jj < get_cash_2.recordcount;jj++)
						eval('document.getElementById("cash_id")').options[jj+1]=new Option(''+get_cash_2.CASH_NAME[jj]+' '+get_cash_2.CASH_CURRENCY_ID[jj]+'',''+get_cash_2.CASH_ID[jj]+';'+get_cash_2.BRANCH_ID[jj]+';'+get_cash_2.CASH_CURRENCY_ID[jj]+'');
					for(var jj=0;jj < get_cash_1.recordcount;jj++)
						eval('document.getElementById("to_cash_id")').options[jj+1]=new Option(''+get_cash_1.CASH_NAME[jj]+' '+get_cash_1.CASH_CURRENCY_ID[jj]+'',''+get_cash_1.CASH_ID[jj]+';'+get_cash_1.BRANCH_ID[jj]+';'+get_cash_1.CASH_CURRENCY_ID[jj]+'');
				}
				else if(proc_control == 137)
				{
					document.form_payroll_basket.bordro_type.value = 1;
					for(var jj=0;jj < get_cash_2.recordcount;jj++)
						eval('document.getElementById("to_cash_id")').options[jj+1]=new Option(''+get_cash_2.CASH_NAME[jj]+' '+get_cash_2.CASH_CURRENCY_ID[jj]+'',''+get_cash_2.CASH_ID[jj]+';'+get_cash_2.BRANCH_ID[jj]+';'+get_cash_2.CASH_CURRENCY_ID[jj]+'');
					for(var jj=0;jj < get_cash_1.recordcount;jj++)
						eval('document.getElementById("cash_id")').options[jj+1]=new Option(''+get_cash_1.CASH_NAME[jj]+' '+get_cash_1.CASH_CURRENCY_ID[jj]+'',''+get_cash_1.CASH_ID[jj]+';'+get_cash_1.BRANCH_ID[jj]+';'+get_cash_1.CASH_CURRENCY_ID[jj]+'');
				}
			<cfelse>
				if(proc_control == 136)
					document.form_payroll_basket.bordro_type.value = 14;
				else
					document.form_payroll_basket.bordro_type.value = 1;
			</cfif>
		<cfelseif isdefined("attributes.event") and attributes.event is "upd">
			if(proc_control == 136)
				document.form_payroll_basket.bordro_type.value = 14;
			else
				document.form_payroll_basket.bordro_type.value = 1;
			document.form_payroll_basket.process_cat.disabled = true;
		</cfif>
	});
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
	WOStruct['#attributes.fuseaction#']['add']['fuseaction'] = 'cheque.form_add_voucher_transfer';
	WOStruct['#attributes.fuseaction#']['add']['filePath'] = 'cheque/form/add_voucher_transfer.cfm';
	WOStruct['#attributes.fuseaction#']['add']['queryPath'] = 'cheque/query/add_voucher_transfer.cfm';
	WOStruct['#attributes.fuseaction#']['add']['nextEvent'] = 'cheque.form_add_voucher_transfer&event=upd';
	WOStruct['#attributes.fuseaction#']['add']['js'] = "javascript:gizle_goster_ikili('voucher_transfer','voucher_transfer_bask')";
	
	WOStruct['#attributes.fuseaction#']['upd'] = structNew();
	WOStruct['#attributes.fuseaction#']['upd']['window'] = 'normal';
	WOStruct['#attributes.fuseaction#']['upd']['fuseaction'] = 'cheque.form_add_voucher_transfer';
	WOStruct['#attributes.fuseaction#']['upd']['filePath'] = 'cheque/form/upd_voucher_transfer.cfm';
	WOStruct['#attributes.fuseaction#']['upd']['queryPath'] = 'cheque/query/upd_voucher_transfer.cfm';
	WOStruct['#attributes.fuseaction#']['upd']['nextEvent'] = 'cheque.form_add_voucher_transfer&event=upd';
	WOStruct['#attributes.fuseaction#']['upd']['parameters'] = 'id=##attributes.id##';
	WOStruct['#attributes.fuseaction#']['upd']['Identity'] = '##attributes.id##';
	WOStruct['#attributes.fuseaction#']['upd']['js'] = "javascript:gizle_goster_ikili('voucher_transfer','voucher_transfer_bask')";
	
	if(not attributes.event is 'add')
	{
		WOStruct['#attributes.fuseaction#']['del'] = structNew();
		WOStruct['#attributes.fuseaction#']['del']['window'] = 'emptypopup';
		WOStruct['#attributes.fuseaction#']['del']['fuseaction'] = 'cheque.del_voucher_payroll&id=#attributes.id#&head=#get_action_detail.PAYROLL_NO#&cheque_base_acc=#get_action_detail.VOUCHER_BASED_ACC_CARI#';
		WOStruct['#attributes.fuseaction#']['del']['filePath'] = 'cheque/query/del_voucher_payroll.cfm';
		WOStruct['#attributes.fuseaction#']['del']['queryPath'] = 'cheque/query/del_voucher_payroll.cfm';
		WOStruct['#attributes.fuseaction#']['del']['nextEvent'] = 'cheque.list_voucher_actions';
	}
	
	if(attributes.event is 'upd')
	{		
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd'] = structNew();
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'] = structNew();
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][0]['text'] = '#lang_array_main.item[2582]#';
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][0]['onClick'] = "windowopen('#request.self#?fuseaction=objects.popup_list_order_account_cards&voucher_payroll_id=#attributes.id#&action_id=#attributes.id#&process_cat=#get_action_detail.PAYROLL_TYPE#','wide')";
		
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons'] = structNew();
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['add']['text'] = '#lang_array_main.item[170]#';
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['add']['href'] = "#request.self#?fuseaction=cheque.form_add_voucher_transfer";
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['add']['target'] = "_blank";
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['print']['text'] = '#lang_array_main.item[62]#';
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['print']['onClick'] = "windowopen('#request.self#?fuseaction=objects.popup_print_files&action_id=#attributes.id#&print_type=#p_type#','page')";
		tabMenuData = SerializeJSON(tabMenuStruct['#attributes.fuseaction#']['tabMenus']);
	}

</cfscript>
