<!-----------------------------------------------------------------------
*************************************************************************
Copyright Workcube E-Business Inc. www.workcube.com
*************************************************************************
Analys    : Cemil Durgan      Developer  : Cemil Durgan
Analys Date : 28/05/2016      Dev Date  : 28/05/2016
Description :
  * Bu controller Banka Hesabı Açılışı İşlemlerini içerir.
  * add,upd ve del eventlerini içerisinde barındırır.
----------------------------------------------------------------------->
<cf_get_lang_set module_name="bank">
<cfif isDefined('attributes.action_date')>
	<cf_date tarih = "attributes.action_date">
</cfif>
<cfscript>
	if(not isDefined('attributes.event'))
		attributes.event = 'add'; // Event yoksa add olsun.
	if(not isDefined('attributes.formSubmittedController'))
		attributes.formSubmittedController = 0; // formSubmittedController not defined ise 0 olsun. Her yerde defined mı diye bakmak istemiyorum.
	// Form elemanlarını boş atıyorum. Böylece formun içinde defined mı diye bakmıyorum.
	process_cat = '';
	account_id_info = '';
	branch_id_info = '';
	is_upd = 0;
	is_open = 1;
	is_default = 1;
	toAccountId = '';
	fromAccountId = '';
	actionValue = '';
	otherActionValue = '';
	action_date = now();
	action_detail = '';

	if(not attributes.formSubmittedController eq 1) {
		if(attributes.event is 'upd') {
			// Boş atamış olduğum form elemanlarını upd için yeniden set ediyorum, form dolu geliyor.
			get_action_detail = bankActionsModel.get(
				id     : attributes.ID
			);
			if(not get_action_detail.recordcount) {
				hata = 11;
				hata_mesaj = lang_array_main.item[1531];
				include("../dsp_hata.cfm");
				abort;
			} else {
				process_cat = get_action_detail.process_cat;
				account_id_info = iif(len(get_action_detail.action_to_account_id),get_action_detail.action_to_account_id,de(get_action_detail.action_from_account_id));
				branch_id_info = iif(len(get_action_detail.to_branch_id),get_action_detail.to_branch_id,de(get_action_detail.from_branch_id));
				is_upd = 1;
				is_open = 0;
				is_default = 0;
				toAccountId = get_action_detail.action_to_account_id;
				fromAccountId = get_action_detail.action_from_account_id;
				actionValue = get_action_detail.action_value;
				otherActionValue = get_action_detail.other_cash_act_value;
				action_date = get_action_detail.action_date;
				action_detail = get_action_detail.action_detail;
			}
		}
	} else {
		// attributes.formSubmittedController eq 1 durumu:
		if(isDefined('form.active_period') and form.active_period neq session.ep.period_id) {
			writeOutput('
				<script type="text/javascript">
					alertObject({message: "<cfoutput>#lang_array_main.item[1659]#!</cfoutput>"});
				</script>
			');
			abort;
		} else {
		// Aktif dönem konusunda sorun yok ise:
			if(attributes.event neq 'del') {
				get_process_type = getProcessCat.get(process_cat : attributes.process_cat);	//Utility
				process_cat = attributes.process_cat;
				process_type = get_process_type.PROCESS_TYPE;
				
				// Ekleme ve güncellemede alttaki değerlerin hepsi formdan geliyor. Filternum işlemini bir kez yapıyorum.
				attributes.ACTION_VALUE = filterNum(attributes.ACTION_VALUE);
				attributes.OTHER_CASH_ACT_VALUE = filterNum(attributes.OTHER_CASH_ACT_VALUE);
				attributes.system_amount = filterNum(attributes.system_amount);
				for(h_sy=1; h_sy lte attributes.kur_say; h_sy=h_sy+1)
				{
					'attributes.txt_rate1_#h_sy#' = filterNum(evaluate('attributes.txt_rate1_#h_sy#'),session.ep.our_company_info.rate_round_num);
					'attributes.txt_rate2_#h_sy#' = filterNum(evaluate('attributes.txt_rate2_#h_sy#'),session.ep.our_company_info.rate_round_num);
				}
				currency_multiplier = '';
				paper_currency_multiplier = '';
				if(isDefined('attributes.kur_say') and len(attributes.kur_say)) {
					for(mon=1;mon lte attributes.kur_say;mon=mon+1)
					{
						if(evaluate("attributes.hidden_rd_money_#mon#") is session.ep.money2) 
							currency_multiplier = evaluate('attributes.txt_rate2_#mon#/attributes.txt_rate1_#mon#');
						if(evaluate("attributes.hidden_rd_money_#mon#") is attributes.money_type)
							paper_currency_multiplier = evaluate('attributes.txt_rate2_#mon#/attributes.txt_rate1_#mon#');
					}
				}
			}
			// add,upd ve del için evente göre metot öttürüyorum.
			if(attributes.event is 'add') {
				add = bankActionsModel.add (
					process_cat 		: process_cat,
					process_type 		: process_type,
					action_value 		: attributes.action_value,
					currency_id 		: attributes.currency_id,
					action_date 		: attributes.action_date,
					to_account_id 		: iif(attributes.ba_status eq 0,attributes.account_id,de(0)),
					from_account_id		: iif(attributes.ba_status eq 1,attributes.account_id,de(0)),
					action_detail 		: iif(isdefined("attributes.ACTION_DETAIL") and len(attributes.ACTION_DETAIL),"attributes.ACTION_DETAIL",DE("")), 
					money_type 			: iif(isdefined("attributes.money_type") and len(attributes.money_type),"attributes.money_type",DE("")),
					action_type 		: 'HESAP AÇILIŞI',
					paper_number 		: iif(isdefined("attributes.paper_number") and len(attributes.paper_number),"attributes.paper_number",DE("")),
					to_branch_id 		: iif(attributes.ba_status eq 0,attributes.account_id,de(0)),
					from_branch_id 		: iif(attributes.ba_status eq 1,attributes.account_id,de(0)),
					system_amount 		: attributes.system_amount,
					currency_multiplier : currency_multiplier,
					other_cash_act_value: attributes.other_cash_act_value
				);
				
				setBankAccountStatus = setBankAccountStatus.set(attributes.account_id,1);
				
				attributes.actionId = add;
			} else if(attributes.event is 'upd') {
				upd = bankActionsModel.upd (
					id					: attributes.id,
					process_cat 		: process_cat,
					process_type 		: process_type,
					action_value 		: attributes.action_value,
					currency_id 		: attributes.currency_id,
					action_date 		: attributes.action_date,
					to_account_id 		: iif(attributes.ba_status eq 0,attributes.old_acc_id,de(0)),
					from_account_id		: iif(attributes.ba_status eq 1,attributes.old_acc_id,de(0)),
					action_detail 		: iif(isdefined("attributes.ACTION_DETAIL") and len(attributes.ACTION_DETAIL),"attributes.ACTION_DETAIL",DE("")), 
					money_type 			: iif(isdefined("attributes.money_type") and len(attributes.money_type),"attributes.money_type",DE("")),
					action_type 		: 'HESAP AÇILIŞI',
					paper_number 		: iif(isdefined("attributes.paper_number") and len(attributes.paper_number),"attributes.paper_number",DE("")),
					to_branch_id 		: iif(attributes.ba_status eq 0 and len(attributes.branch_id),attributes.branch_id,de(0)),
					from_branch_id 		: iif(attributes.ba_status eq 1 and len(attributes.branch_id),attributes.branch_id,de(0)),
					system_amount 		: attributes.system_amount,
					currency_multiplier : currency_multiplier,
					other_cash_act_value:attributes.other_cash_act_value
				);
				setBankAccountStatus = setBankAccountStatus.set(attributes.old_acc_id,1);
				attributes.actionId = upd;
			} else if(attributes.event is 'del') {
				get_action_detail = bankActionsModel.get(id : attributes.ID);
				if(isNumeric(get_action_detail.action_to_account_id))
					acc_id = get_action_detail.action_to_account_id;
				else if(isNumeric(get_action_detail.action_from_account_id))
					acc_id = get_action_detail.action_from_account_id;
				setBankAccountStatus = setBankAccountStatus.set(acc_id,0);
				del = bankActionsModel.del (
					id      : attributes.id
				);
				
				attributes.actionId = del;
			}
			f_kur_ekle_action(action_id:attributes.actionId,action_table_name:'BANK_ACTION_MONEY',action_table_dsn:'#dsn2#');
		}
	}
	WOStruct = StructNew();
	WOStruct['#attributes.fuseaction#'] = structNew();
	WOStruct['#attributes.fuseaction#']['default'] = 'add';
	WOStruct['#attributes.fuseaction#']['systemObject'] = structNew();
	WOStruct['#attributes.fuseaction#']['systemObject']['processCat'] = true;
	WOStruct['#attributes.fuseaction#']['systemObject']['processType'] = 20;
	WOStruct['#attributes.fuseaction#']['systemObject']['processCatSelected'] = process_cat;
	WOStruct['#attributes.fuseaction#']['systemObject']['paperDate'] = true;
	WOStruct['#attributes.fuseaction#']['systemObject']['paperDateCallFunction'] = 'change_money_info';
	WOStruct['#attributes.fuseaction#']['systemObject']['isTransaction'] = true;
	WOStruct['#attributes.fuseaction#']['systemObject']['dataSourceName'] = dsn2; // Transaction icin yapildi.
	
	WOStruct['#attributes.fuseaction#']['add'] = structNew();
	WOStruct['#attributes.fuseaction#']['add']['window'] = 'normal';
	WOStruct['#attributes.fuseaction#']['add']['fuseaction'] = 'bank.form_add_bank_account_open';
	WOStruct['#attributes.fuseaction#']['add']['filePath'] = 'bank/form/FormBankAccountOpen.cfm';
	WOStruct['#attributes.fuseaction#']['add']['queryPath'] = '';
	WOStruct['#attributes.fuseaction#']['add']['nextEvent'] = 'bank.form_add_bank_account_open&event=upd&id=';
	WOStruct['#attributes.fuseaction#']['add']['formName'] = 'bankAccountOpen';
	
	WOStruct['#attributes.fuseaction#']['add']['buttons'] = structNew();
	WOStruct['#attributes.fuseaction#']['add']['buttons']['save'] = 1;
	WOStruct['#attributes.fuseaction#']['add']['buttons']['saveFunction'] = 'kontrol() && validate().check()';
	
	WOStruct['#attributes.fuseaction#']['upd'] = structNew();
	WOStruct['#attributes.fuseaction#']['upd']['window'] = 'normal';
	WOStruct['#attributes.fuseaction#']['upd']['fuseaction'] = 'bank.form_upd_bank_account_open';
	WOStruct['#attributes.fuseaction#']['upd']['filePath'] = 'bank/form/FormBankAccountOpen.cfm';
	WOStruct['#attributes.fuseaction#']['upd']['queryPath'] = '';
	WOStruct['#attributes.fuseaction#']['upd']['nextEvent'] = 'bank.form_add_bank_account_open&event=upd&id=';
	WOStruct['#attributes.fuseaction#']['upd']['parameters'] = 'id=##attributes.id##';
	WOStruct['#attributes.fuseaction#']['upd']['Identity'] = '##attributes.id##';
	WOStruct['#attributes.fuseaction#']['upd']['recordQuery'] = 'get_action_detail';
	WOStruct['#attributes.fuseaction#']['upd']['formName'] = 'bankAccountOpen';
	
	WOStruct['#attributes.fuseaction#']['upd']['buttons'] = structNew();
	WOStruct['#attributes.fuseaction#']['upd']['buttons']['update'] = 1;
	WOStruct['#attributes.fuseaction#']['upd']['buttons']['updateFunction'] = 'kontrol() && validate().check()';
	WOStruct['#attributes.fuseaction#']['upd']['buttons']['delete'] = 1;
	
	if(attributes.event is 'upd' or attributes.event is 'del') {
		WOStruct['#attributes.fuseaction#']['del'] = structNew();
		WOStruct['#attributes.fuseaction#']['del']['window'] = 'normal';
		WOStruct['#attributes.fuseaction#']['del']['fuseaction'] = '#request.self#?fuseaction=bank.del_bank_account_open&id=#attributes.id#';
		if(not isdefined('attributes.formSubmittedController'))
			WOStruct['#attributes.fuseaction#']['del']['fuseaction'] = '#attributes.fuseaction#&event=del&id=#attributes.id#&old_process_type=#get_action_detail.action_type_id#';
		WOStruct['#attributes.fuseaction#']['del']['filePath'] = 'bank/query/del_bank_account_open.cfm';
		WOStruct['#attributes.fuseaction#']['del']['queryPath'] = '';
		WOStruct['#attributes.fuseaction#']['del']['nextEvent'] = 'bank.list_bank_actions';
	}
	
	if(isDefined('attributes.event') and attributes.event is 'upd')
	{
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons'] = structNew(); 
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['add']['text'] = '#lang_array_main.item[170]#';
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['add']['href'] = "#request.self#?fuseaction=bank.form_add_bank_account_open";
		tabMenuData = SerializeJSON(tabMenuStruct['#attributes.fuseaction#']['tabMenus']);
	}
	WOStruct['#attributes.fuseaction#']['systemObject']['extendedForm'] = true;
	WOStruct['#attributes.fuseaction#']['systemObject']['pageExtendedEventList'] = 'add,upd';
	WOStruct['#attributes.fuseaction#']['systemObject']['pageTableName'] = 'BANK_ACTIONS';
	WOStruct['#attributes.fuseaction#']['systemObject']['pageIdentityColumn'] = 'ACTION_ID';
	WOStruct['#attributes.fuseaction#']['systemObject']['pageSettings'] = "['item-processCat','item-account_id','item-ba_status','item-action_date','item-ACTION_VALUE']";
</cfscript> 
 
<script type="text/javascript">
	$(document).ready(function() {
		<cfif attributes.event is 'upd'>
			$('#account_id').attr('disabled',true);
		</cfif>
		kur_ekle_f_hesapla('account_id');
	});
	function kontrol()
	{
		if(!chk_process_cat('bankAccountOpen')) return false;
		if(!check_display_files('bankAccountOpen')) return false;
		if(!chk_period(document.getElementById('action_date'), 'İşlem')) return false;
		if(!acc_control()) return false;
		kur_ekle_f_hesapla('account_id');//dövizli tutarı silinenler için
		return true;
	}
</script> 