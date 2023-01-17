<!-----------------------------------------------------------------------
*************************************************************************
Copyright Workcube E-Business Inc. www.workcube.com
*************************************************************************
Analys    : Cemil Durgan      Developer  : Cemil Durgan
Analys Date : 02/06/2016      Dev Date  : 02/06/2016
Description :
  * Bu controller Banka Virman işlemini içerir.
  * add,upd ve del eventlerini ve multilerini içerisinde barındırır.
----------------------------------------------------------------------->
<cf_get_lang_set module_name="bank">
<cf_papers paper_type="virman">
<cfif isDefined('attributes.action_date') and len(attributes.action_date)>
	<cf_date tarih = "attributes.action_date">
</cfif>
<cfscript>
	if(not isDefined('attributes.event'))
		attributes.event = 'add'; // Event yoksa add olsun.
	if(not isDefined('attributes.formSubmittedController'))
		attributes.formSubmittedController = 0; // formSubmittedController not defined ise 0 olsun. Her yerde defined mı diye bakmak istemiyorum.
	// Form elemanlarını boş atıyorum. Böylece formun içinde defined mı diye bakmıyorum.
	
	if (attributes.event contains 'multi') {
		branch_id = '';
		date_info = now();
		process_cat = '';
		is_default = 1;
		
		getBankAccounts = bankAccounts.get();
		if(not isDefined('attributes.multi_id'))
			getMoney = getActionMoney.get( table_name : 'BANK_ACTION_MULTI_MONEY', action_id : 0);
		else
			getMoney = getActionMoney.get( table_name : 'BANK_ACTION_MULTI_MONEY', action_id : attributes.multi_id);
	}
	
	process_cat = '';
	from_account_id = '';
	action_to_account_id = '';
	from_branch_id = '';
	to_branch_id = '';
	action_date = now();
	action_value = 0;
	masraf = 0;
	other_cash_act_value = '';
	expense_center_id = '';
	expense_item_id = '';
	other_money_order = '';
	action_detail = '';
	project_id = '';
	project_head = '';
	
	if(isDefined('attributes.id')) {
		get_action_detail1 = bankActionsModel.get(
			id     : attributes.ID
		);
		get_action_detail2 = bankActionsModel.get(
			id     : attributes.ID + 1
		);
	}
	if(isDefined('attributes.multi_id')) {
		getMultiData = bankActionsModel.getMulti(
			multiId     : attributes.multi_id
		);
	}
	if(attributes.formSubmittedController neq 1) {
		if(isDefined('attributes.id')) {
			// Boş atamış olduğum form elemanlarını upd için yeniden set ediyorum, form dolu geliyor.
			if(not (get_action_detail1.with_next_row eq 1 and get_action_detail2.with_next_row eq 0)) {
				hata = 11;
				hata_mesaj = lang_array_main.item[1531];
				include("../dsp_hata.cfm");
				abort;
			} else {
				process_cat = get_action_detail1.process_cat;
				from_account_id = get_action_detail1.action_from_account_id;
				action_to_account_id = get_action_detail2.action_to_account_id;
				from_branch_id = get_action_detail1.from_branch_id;
				to_branch_id = get_action_detail2.to_branch_id;
				action_date = get_action_detail1.action_date;
				action_value = get_action_detail1.action_value;
				masraf = get_action_detail1.masraf;
				other_cash_act_value = get_action_detail1.other_cash_act_value;
				expense_center_id = get_action_detail1.expense_center_id;
				expense_item_id = get_action_detail1.expense_item_id;
				other_money_order = get_action_detail1.other_money;
				action_detail = get_action_detail1.action_detail;
				project_id = get_action_detail1.project_id;
				project_head = get_action_detail1.project_head;
			}
		} else if(isDefined('attributes.multi_id')) {
			getMultiData = bankActionsModel.getMulti(
				multiId     : attributes.multi_id
			);
			if(not getMultiData.mainData.recordcount or not getMultiData.rowData.recordcount) {
				hata = 11;
				hata_mesaj = lang_array_main.item[1531];
				include("../dsp_hata.cfm");
				abort;
			} else {
				date_info = getMultiData.mainData.action_date;
				process_cat = getMultiData.mainData.process_cat;
				is_default = 0;
				branch_id = 0;
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
			if(not attributes.event contains 'del') {
				get_process_type = getProcessCat.get(process_cat : attributes.process_cat);	//Utility
				process_cat = attributes.process_cat;
				process_type = get_process_type.PROCESS_TYPE;
				is_account = get_process_type.IS_ACCOUNT;
				is_budget = get_process_type.IS_BUDGET;
				multi_type = get_process_type.MULTI_TYPE;
				
				if(not isDefined('attributes.old_process_type'))
					attributes.old_process_type = process_type;

				for(h_sy=1; h_sy lte attributes.kur_say; h_sy=h_sy+1)
				{
					'attributes.txt_rate1_#h_sy#' = filterNum(evaluate('attributes.txt_rate1_#h_sy#'),session.ep.our_company_info.rate_round_num);
					'attributes.txt_rate2_#h_sy#' = filterNum(evaluate('attributes.txt_rate2_#h_sy#'),session.ep.our_company_info.rate_round_num);
				}
				if(not attributes.event contains 'multi') {
					currency_multiplier = '';
					masraf_curr_multiplier = '';
					if(isDefined('attributes.kur_say') and len(attributes.kur_say))
						for(mon=1;mon lte attributes.kur_say;mon=mon+1)
						{
							if(evaluate("attributes.hidden_rd_money_#mon#") is session.ep.money2)
								currency_multiplier = evaluate('attributes.txt_rate2_#mon#/attributes.txt_rate1_#mon#');
							if(evaluate("attributes.hidden_rd_money_#mon#") is form.money_type)
								masraf_curr_multiplier = evaluate('attributes.txt_rate2_#mon#/attributes.txt_rate1_#mon#');
							if(evaluate("attributes.hidden_rd_money_#mon#") is attributes.currency_id)
								dovizli_islem_multiplier = evaluate('attributes.txt_rate2_#mon#/attributes.txt_rate1_#mon#');
							if(evaluate("attributes.hidden_rd_money_#mon#") is attributes.currency_id2)
								dovizli_islem_multiplier_2 = evaluate('attributes.txt_rate2_#mon#/attributes.txt_rate1_#mon#');
						}
				}
				// Ekleme ve güncellemede alttaki değerlerin hepsi formdan geliyor. Filternum işlemini bir kez yapıyorum.
				if(not attributes.event contains 'multi') {
					attributes.ACTION_VALUE = filterNum(attributes.ACTION_VALUE);
					attributes.OTHER_CASH_ACT_VALUE = filterNum(attributes.OTHER_CASH_ACT_VALUE);
					attributes.MASRAF = filterNum(attributes.MASRAF);
					attributes.system_amount = filterNum(attributes.system_amount);
				} else {
					for(r=1; r lte attributes.record_num; r=r+1) {
						if(evaluate('attributes.row_kontrol#r#') eq 1)
						{
							'attributes.action_value#r#' = filterNum(evaluate('attributes.action_value#r#'));
							'attributes.expense_amount#r#' = filterNum(evaluate('attributes.expense_amount#r#'));
						}
					}
					if(isdefined("attributes.branch_id") and len(attributes.branch_id))
						branch_id_info = attributes.branch_id;
					else
						branch_id_info = listgetat(session.ep.user_location,2,'-');
						
					attributes.branch_id_alacak = branch_id_info;
					attributes.branch_id_borc = branch_id_info;
				}
			}
			// add,upd ve del için evente göre metot öttürüyorum.
			if(attributes.event is 'add') {
				add1 = BankActionsModel.add ( // borç satırı
					process_cat 		: process_cat,
					process_type 		: process_type,
					action_value 		: attributes.action_value,
					currency_id 		: attributes.currency_id,
					action_date 		: attributes.action_date,
					from_account_id		: attributes.from_account_id,
					action_detail 		: iif(isdefined("attributes.ACTION_DETAIL") and len(attributes.ACTION_DETAIL),"attributes.ACTION_DETAIL",DE("")), 
					money_type 			: iif(isdefined("attributes.money_type") and len(attributes.money_type),"attributes.money_type",DE("")),
					action_type 		: 'VİRMAN',
					paper_number 		: iif(isdefined("attributes.paper_number") and len(attributes.paper_number),"attributes.paper_number",DE("")),
					from_branch_id 		: attributes.branch_id_alacak,
					system_amount 		: attributes.system_amount,
					currency_multiplier : currency_multiplier,
					other_cash_act_value: attributes.other_cash_act_value,
					with_next_row		: 1,
					masraf				: attributes.masraf,
					expense_center_id	: iif(len(attributes.expense_center_id),"attributes.expense_center_id",DE(0)),
					expense_item_id		: iif(len(attributes.expense_item_id),"attributes.expense_item_id",DE(0))
				);
				add2 = BankActionsModel.add ( // alacak satırı
					process_cat 		: process_cat,
					process_type 		: process_type,
					action_value 		: attributes.action_value,
					currency_id 		: attributes.currency_id,
					action_date 		: attributes.action_date,
					to_account_id		: attributes.to_account_id,
					action_detail 		: iif(isdefined("attributes.ACTION_DETAIL") and len(attributes.ACTION_DETAIL),"attributes.ACTION_DETAIL",DE("")), 
					money_type 			: iif(isdefined("attributes.money_type") and len(attributes.money_type),"attributes.money_type",DE("")),
					action_type 		: 'VİRMAN',
					paper_number 		: iif(isdefined("attributes.paper_number") and len(attributes.paper_number),"attributes.paper_number",DE("")),
					to_branch_id 		: attributes.branch_id_borc,
					system_amount 		: attributes.system_amount,
					currency_multiplier : currency_multiplier,
					other_cash_act_value: attributes.other_cash_act_value,
					with_next_row		: 0,
					masraf				: attributes.masraf,
					expense_center_id	: iif(len(attributes.expense_center_id),"attributes.expense_center_id",DE(0)),
					expense_item_id		: iif(len(attributes.expense_item_id),"attributes.expense_item_id",DE(0))
				);
				attributes.actionId = add1;
			} else if(attributes.event is 'upd') {
				upd1 = BankActionsModel.upd (
					id					: attributes.id,
					process_cat 		: process_cat,
					process_type 		: process_type,
					action_value 		: attributes.action_value,
					currency_id 		: attributes.currency_id,
					action_date 		: attributes.action_date,
					from_account_id		: attributes.from_account_id,
					action_detail 		: iif(isdefined("attributes.ACTION_DETAIL") and len(attributes.ACTION_DETAIL),"attributes.ACTION_DETAIL",DE("")), 
					money_type 			: iif(isdefined("attributes.money_type") and len(attributes.money_type),"attributes.money_type",DE("")),
					action_type 		: 'BANKA VİRMAN',
					paper_number 		: iif(isdefined("attributes.paper_number") and len(attributes.paper_number),"attributes.paper_number",DE("")),
					from_branch_id 		: attributes.branch_id_alacak,
					system_amount 		: attributes.system_amount,
					currency_multiplier : currency_multiplier,
					other_cash_act_value: attributes.other_cash_act_value,
					with_next_row		: 1,
					masraf				: attributes.masraf,
					expense_center_id	: iif(len(attributes.expense_center_id),"attributes.expense_center_id",DE(0)),
					expense_item_id		: iif(len(attributes.expense_item_id),"attributes.expense_item_id",DE(0))
				);
				upd2 = BankActionsModel.upd (
					id					: attributes.id + 1,
					process_cat 		: process_cat,
					process_type 		: process_type,
					action_value 		: attributes.action_value,
					currency_id 		: attributes.currency_id,
					action_date 		: attributes.action_date,
					to_account_id 		: attributes.to_account_id,
					action_detail 		: iif(isdefined("attributes.ACTION_DETAIL") and len(attributes.ACTION_DETAIL),"attributes.ACTION_DETAIL",DE("")), 
					money_type 			: iif(isdefined("attributes.money_type") and len(attributes.money_type),"attributes.money_type",DE("")),
					action_type 		: 'BANKA VİRMAN',
					paper_number 		: iif(isdefined("attributes.paper_number") and len(attributes.paper_number),"attributes.paper_number",DE("")),
					to_branch_id 		: attributes.branch_id_borc,
					system_amount 		: attributes.system_amount,
					currency_multiplier : currency_multiplier,
					other_cash_act_value: attributes.other_cash_act_value,
					with_next_row		: 0,
					masraf				: attributes.masraf,
					expense_center_id	: iif(len(attributes.expense_center_id),"attributes.expense_center_id",DE(0)),
					expense_item_id		: iif(len(attributes.expense_item_id),"attributes.expense_item_id",DE(0))
				);
				attributes.actionId = upd1;
			} else if(attributes.event is 'del') {
				del1 = BankActionsModel.del (
					id      : attributes.id
				);
				del2 = BankActionsModel.del (
					id      : attributes.id + 1
				);
				attributes.actionId = del1;
			} else if(attributes.event is 'addmulti') {
				addMulti = BankActionsModel.addMulti (
					process_cat : process_cat,
					action_type	: process_type,
					action_date : action_date
				);
				attributes.actionId = addMulti;
				
				acc_project_list_borc = '';
				acc_project_list_alacak = '';
				str_borclu_hesaplar = '';	
				str_alacakli_hesaplar = '';	
				str_borclu_tutarlar = '';
				str_alacakli_tutarlar = '';
				str_borclu_other_amount_tutar = '';
				str_borclu_other_currency = '';
				str_alacakli_other_amount_tutar = '';
				str_alacakli_other_currency = '';
				currency_multiplier = '';								//sistem ikinci para birimine gore hesaplanan katsayi
				currency_multiplier_other = '';							//secilen kura gore hesaplanan katsayi
				money_type = listgetat(attributes.rd_money,1,',');		//radio buttonlarda secilen kur bilgisi
				satir_detay_list = ArrayNew(2);
				
				for(r=1; r lte attributes.record_num; r=r+1) {
					currency_multiplier = '';
					masraf_curr_multiplier = '';
					if(isDefined('attributes.kur_say') and len(attributes.kur_say))
						for(mon=1;mon lte attributes.kur_say;mon=mon+1)
						{
							if(evaluate("attributes.hidden_rd_money_#mon#") is session.ep.money2)
								currency_multiplier = evaluate('attributes.txt_rate2_#mon#/attributes.txt_rate1_#mon#');
							if(evaluate("attributes.hidden_rd_money_#mon#") is listgetat(evaluate("attributes.from_account_id#r#"),2,';'))
								dovizli_islem_multiplier = evaluate('attributes.txt_rate2_#mon#/attributes.txt_rate1_#mon#');
							if(evaluate("attributes.hidden_rd_money_#mon#") is listgetat(evaluate("attributes.to_account_id#r#"),2,';'))
								dovizli_islem_multiplier_2 = evaluate('attributes.txt_rate2_#mon#/attributes.txt_rate1_#mon#');
						}
					
					attributes.action_value = evaluate('attributes.action_value#r#');
					attributes.masraf = evaluate('attributes.expense_amount#r#');
					attributes.expense_center_id = evaluate('attributes.expense_center_id#r#');
					attributes.expense_item_id = evaluate('attributes.expense_item_id#r#');
					attributes.system_amount = evaluate('attributes.action_value#r#') * dovizli_islem_multiplier;
					attributes.currency_id = listgetat(evaluate("attributes.from_account_id#r#"),2,';');
					attributes.from_account_id = listgetat(evaluate("attributes.from_account_id#r#"),1,';');
					attributes.to_account_id = listgetat(evaluate("attributes.to_account_id#r#"),1,';');
					attributes.action_detail = evaluate('attributes.action_detail#r#');
					if(isDefined('attributes.act_row_id#r#'))
						attributes.act_row_id = evaluate('attributes.act_row_id#r#');
					else
						attributes.act_row_id = 0;
					attributes.paper_number = evaluate('attributes.paper_number#r#');
					attributes.money_type = listgetat(evaluate("attributes.to_account_id#r#"),2,';');
					
					if(evaluate('attributes.row_kontrol#r#') eq 1)
					{
						add1 = BankActionsModel.add ( // borç satırı
							process_cat 		: process_cat,
							process_type 		: process_type,
							action_value 		: attributes.action_value,
							currency_id 		: attributes.currency_id,
							action_date 		: attributes.action_date,
							from_account_id		: attributes.from_account_id,
							action_detail 		: iif(isdefined("attributes.ACTION_DETAIL") and len(attributes.ACTION_DETAIL),"attributes.ACTION_DETAIL",DE("")), 
							money_type 			: iif(isdefined("attributes.money_type") and len(attributes.money_type),"attributes.money_type",DE("")),
							action_type 		: 'VİRMAN',
							paper_number 		: iif(len(attributes.paper_number),"attributes.paper_number",DE("")),
							from_branch_id 		: attributes.branch_id_alacak,
							system_amount 		: attributes.system_amount,
							currency_multiplier : currency_multiplier,
							other_cash_act_value: attributes.action_value * (dovizli_islem_multiplier / dovizli_islem_multiplier_2),
							with_next_row		: 1,
							multi_action_id		: attributes.actionId,
							masraf				: attributes.masraf,
							expense_center_id	: iif(len(attributes.expense_center_id),attributes.expense_center_id,DE(0)),
							expense_item_id		: iif(len(attributes.expense_item_id),attributes.expense_item_id,DE(0))
						);
						add2 = BankActionsModel.add ( // alacak satırı
							process_cat 		: process_cat,
							process_type 		: process_type,
							action_value 		: attributes.action_value,
							currency_id 		: attributes.currency_id,
							action_date 		: attributes.action_date,
							to_account_id		: attributes.to_account_id,
							action_detail 		: iif(isdefined("attributes.ACTION_DETAIL") and len(attributes.ACTION_DETAIL),"attributes.ACTION_DETAIL",DE("")), 
							money_type 			: iif(isdefined("attributes.money_type") and len(attributes.money_type),"attributes.money_type",DE("")),
							action_type 		: 'VİRMAN',
							paper_number 		: iif(len(attributes.paper_number),"attributes.paper_number",DE("")),
							to_branch_id 		: attributes.branch_id_borc,
							system_amount 		: attributes.system_amount,
							currency_multiplier : currency_multiplier,
							other_cash_act_value: attributes.action_value * (dovizli_islem_multiplier / dovizli_islem_multiplier_2),
							with_next_row		: 0,
							multi_action_id		: attributes.actionId,
							masraf				: attributes.masraf,
							expense_center_id	: iif(len(attributes.expense_center_id),attributes.expense_center_id,DE(0)),
							expense_item_id		: iif(len(attributes.expense_item_id),attributes.expense_item_id,DE(0))
						);
					}
				}
			} else if(attributes.event is 'updmulti') {
				updMulti = BankActionsModel.updMulti (
					process_cat 	: process_cat,
					action_type		: process_type,
					action_date 	: action_date,
					multi_action_id : attributes.multi_id
				);
				attributes.actionId = updMulti;
				
				acc_project_list_borc = '';
				acc_project_list_alacak = '';
				str_borclu_hesaplar = '';	
				str_alacakli_hesaplar = '';	
				str_borclu_tutarlar = '';
				str_alacakli_tutarlar = '';
				str_borclu_other_amount_tutar = '';
				str_borclu_other_currency = '';
				str_alacakli_other_amount_tutar = '';
				str_alacakli_other_currency = '';
				currency_multiplier = '';								//sistem ikinci para birimine gore hesaplanan katsayi
				currency_multiplier_other = '';							//secilen kura gore hesaplanan katsayi
				money_type = listgetat(attributes.rd_money,1,',');		//radio buttonlarda secilen kur bilgisi
				satir_detay_list = ArrayNew(2);
				
				for(r=1; r lte attributes.record_num; r=r+1) {
					if(evaluate('attributes.row_kontrol#r#') eq 1)
					{
						if(not isDefined('attributes.act_row_id#r#'))
							'attributes.act_row_id#r#' = 0;
						currency_multiplier = '';
						masraf_curr_multiplier = '';
						if(isDefined('attributes.kur_say') and len(attributes.kur_say))
							for(mon=1;mon lte attributes.kur_say;mon=mon+1)
							{
								if(evaluate("attributes.hidden_rd_money_#mon#") is session.ep.money2)
									currency_multiplier = evaluate('attributes.txt_rate2_#mon#/attributes.txt_rate1_#mon#');
								if(evaluate("attributes.hidden_rd_money_#mon#") is listgetat(evaluate("attributes.from_account_id#r#"),2,';'))
									dovizli_islem_multiplier = evaluate('attributes.txt_rate2_#mon#/attributes.txt_rate1_#mon#');
								if(evaluate("attributes.hidden_rd_money_#mon#") is listgetat(evaluate("attributes.to_account_id#r#"),2,';'))
									dovizli_islem_multiplier_2 = evaluate('attributes.txt_rate2_#mon#/attributes.txt_rate1_#mon#');
							}
						
						attributes.action_value = evaluate('attributes.action_value#r#');
						attributes.masraf = evaluate('attributes.expense_amount#r#');
						attributes.expense_center_id = evaluate('attributes.expense_center_id#r#');
						attributes.expense_item_id = evaluate('attributes.expense_item_id#r#');
						attributes.system_amount = evaluate('attributes.action_value#r#') * dovizli_islem_multiplier;
						attributes.currency_id = listgetat(evaluate("attributes.from_account_id#r#"),2,';');
						attributes.from_account_id = listgetat(evaluate("attributes.from_account_id#r#"),1,';');
						attributes.to_account_id = listgetat(evaluate("attributes.to_account_id#r#"),1,';');
						attributes.action_detail = evaluate('attributes.action_detail#r#');
						attributes.act_row_id = evaluate('attributes.act_row_id#r#');
						attributes.paper_number = evaluate('attributes.paper_number#r#');
						attributes.money_type = listgetat(evaluate("attributes.to_account_id#r#"),2,';');
						
						if(not len(attributes.masraf))
							attributes.masraf = 0;
							
						if(evaluate('attributes.act_row_id#r#') neq 0)
						{
							upd1 = BankActionsModel.upd ( // borç satırı
								id					: attributes.act_row_id,
								process_cat 		: process_cat,
								process_type 		: process_type,
								action_value 		: attributes.action_value,
								currency_id 		: attributes.currency_id,
								action_date 		: attributes.action_date,
								from_account_id		: attributes.from_account_id,
								action_detail 		: iif(isdefined("attributes.ACTION_DETAIL") and len(attributes.ACTION_DETAIL),"attributes.ACTION_DETAIL",DE("")), 
								money_type 			: iif(isdefined("attributes.money_type") and len(attributes.money_type),"attributes.money_type",DE("")),
								action_type 		: 'VİRMAN',
								paper_number 		: iif(len(attributes.paper_number),"attributes.paper_number",DE("")),
								from_branch_id 		: attributes.branch_id_alacak,
								system_amount 		: attributes.system_amount,
								currency_multiplier : currency_multiplier,
								other_cash_act_value: attributes.action_value * (dovizli_islem_multiplier / dovizli_islem_multiplier_2),
								with_next_row		: 1,
								multi_action_id		: attributes.actionId,
								masraf				: attributes.masraf,
								expense_center_id	: iif(len(attributes.expense_center_id),attributes.expense_center_id,DE(0)),
								expense_item_id		: iif(len(attributes.expense_item_id),attributes.expense_item_id,DE(0))
							);
							upd2 = BankActionsModel.upd ( // alacak satırı
								id					: attributes.act_row_id + 1,
								process_cat 		: process_cat,
								process_type 		: process_type,
								action_value 		: attributes.action_value,
								currency_id 		: attributes.currency_id,
								action_date 		: attributes.action_date,
								to_account_id		: attributes.to_account_id,
								action_detail 		: iif(isdefined("attributes.ACTION_DETAIL") and len(attributes.ACTION_DETAIL),"attributes.ACTION_DETAIL",DE("")), 
								money_type 			: iif(isdefined("attributes.money_type") and len(attributes.money_type),"attributes.money_type",DE("")),
								action_type 		: 'VİRMAN',
								paper_number 		: iif(len(attributes.paper_number),"attributes.paper_number",DE("")),
								to_branch_id 		: attributes.branch_id_borc,
								system_amount 		: attributes.system_amount,
								currency_multiplier : currency_multiplier,
								other_cash_act_value: attributes.action_value * (dovizli_islem_multiplier / dovizli_islem_multiplier_2),
								with_next_row		: 0,
								multi_action_id		: attributes.actionId,
								masraf				: attributes.masraf,
								expense_center_id	: iif(len(attributes.expense_center_id),attributes.expense_center_id,DE(0)),
								expense_item_id		: iif(len(attributes.expense_item_id),attributes.expense_item_id,DE(0))
							);
						} else {
							add1 = BankActionsModel.add ( // borç satırı
								process_cat 		: process_cat,
								process_type 		: process_type,
								action_value 		: attributes.action_value,
								currency_id 		: attributes.currency_id,
								action_date 		: attributes.action_date,
								from_account_id		: attributes.from_account_id,
								action_detail 		: iif(isdefined("attributes.ACTION_DETAIL") and len(attributes.ACTION_DETAIL),"attributes.ACTION_DETAIL",DE("")), 
								money_type 			: iif(isdefined("attributes.money_type") and len(attributes.money_type),"attributes.money_type",DE("")),
								action_type 		: 'VİRMAN',
								paper_number 		: iif(len(attributes.paper_number),"attributes.paper_number",DE("")),
								from_branch_id 		: attributes.branch_id_alacak,
								system_amount 		: attributes.system_amount,
								currency_multiplier : currency_multiplier,
								other_cash_act_value: attributes.action_value * (dovizli_islem_multiplier / dovizli_islem_multiplier_2),
								with_next_row		: 1,
								multi_action_id		: attributes.actionId,
								masraf				: attributes.masraf,
								expense_center_id	: iif(len(attributes.expense_center_id),attributes.expense_center_id,DE(0)),
								expense_item_id		: iif(len(attributes.expense_item_id),attributes.expense_item_id,DE(0))
							);
							add2 = BankActionsModel.add ( // alacak satırı
								process_cat 		: process_cat,
								process_type 		: process_type,
								action_value 		: attributes.action_value,
								currency_id 		: attributes.currency_id,
								action_date 		: attributes.action_date,
								to_account_id		: attributes.to_account_id,
								action_detail 		: iif(isdefined("attributes.ACTION_DETAIL") and len(attributes.ACTION_DETAIL),"attributes.ACTION_DETAIL",DE("")), 
								money_type 			: iif(isdefined("attributes.money_type") and len(attributes.money_type),"attributes.money_type",DE("")),
								action_type 		: 'VİRMAN',
								paper_number 		: iif(len(attributes.paper_number),"attributes.paper_number",DE("")),
								to_branch_id 		: attributes.branch_id_borc,
								system_amount 		: attributes.system_amount,
								currency_multiplier : currency_multiplier,
								other_cash_act_value: attributes.action_value * (dovizli_islem_multiplier / dovizli_islem_multiplier_2),
								with_next_row		: 0,
								multi_action_id		: attributes.actionId,
								masraf				: attributes.masraf,
								expense_center_id	: iif(len(attributes.expense_center_id),attributes.expense_center_id,DE(0)),
								expense_item_id		: iif(len(attributes.expense_item_id),attributes.expense_item_id,DE(0))
							);
						}
					} else {
						del = BankActionsModel.del (
							id      : attributes.act_row_id
						);
						butce_sil(action_id:attributes.act_row_id,muhasebe_db:dsn2,process_type:process_type);
					}
				}
			} else if(attributes.event is 'delmulti') {
				del = BankActionsModel.delMulti (
					multi_id      : attributes.multi_id
				);
				butce_sil(action_id:attributes.multi_id,process_type:23);
				muhasebe_sil(action_id:attributes.multi_id,process_type:230);
				attributes.actionId = del;
			}
			// bütçe ve muhasebe işlemleri :
			if(not attributes.event contains 'del') {
				if(not attributes.event contains 'multi') {
					butce_sil(action_id:attributes.actionId,muhasebe_db:dsn2,process_type:process_type);
					if(len(attributes.expense_item_id) and len(attributes.expense_item_name) and (attributes.masraf gt 0) and len(attributes.expense_center_id) and len(attributes.expense_center_name))
					{
						if(attributes.currency_id is session.ep.money)
						{
							butceci(
								action_id : attributes.actionId,
								muhasebe_db : dsn2,
								is_income_expense : false,
								process_type : process_type,
								nettotal : attributes.masraf,
								other_money_value : wrk_round(attributes.masraf/masraf_curr_multiplier),
								action_currency : form.money_type,
								currency_multiplier : currency_multiplier,
								expense_date : attributes.action_date,
								expense_center_id : attributes.expense_center_id,
								expense_item_id : attributes.expense_item_id,
								detail : 'VİRMAN MASRAFI',
								paper_no : attributes.paper_number,
								branch_id : attributes.branch_id_alacak,
								insert_type : 1,//banka vs den eklenen masraflar için farklı ekleme metodu tanımlar
								project_id : attributes.project_id
							);
						}
						else
						{
							butceci(
								action_id : attributes.actionId,
								muhasebe_db : dsn2,
								is_income_expense : false,
								process_type : process_type,
								nettotal : wrk_round(attributes.masraf*dovizli_islem_multiplier),
								other_money_value : attributes.masraf,
								action_currency : attributes.currency_id,
								currency_multiplier : currency_multiplier,
								expense_date : attributes.action_date,
								expense_center_id : attributes.expense_center_id,
								expense_item_id : attributes.expense_item_id,
								detail : 'VİRMAN MASRAFI',
								paper_no : attributes.paper_number,
								branch_id : attributes.branch_id_alacak,
								insert_type : 1,
								project_id : attributes.project_id
							);
						}
						GET_EXP_ACC = cfquery(datasource : "#dsn2#", sqlstring : "SELECT ACCOUNT_CODE FROM EXPENSE_ITEMS WHERE EXPENSE_ITEM_ID = #attributes.expense_item_id#");
					}
					if(is_account eq 1)
					{
						acc_branch_list_borc = '';
						acc_branch_list_alacak = '';
						acc_branch_list_alacak = listappend(acc_branch_list_alacak,attributes.branch_id_alacak,',');
						acc_branch_list_borc = listappend(acc_branch_list_borc,attributes.branch_id_borc,',');
						if(isDefined("attributes.ACTION_DETAIL") and len(attributes.ACTION_DETAIL))
							str_card_detail = '#attributes.ACTION_DETAIL#';
						else if(attributes.currency_id is session.ep.money)
							str_card_detail = 'VİRMAN HESAP İŞLEMİ';
						else
							str_card_detail = 'DÖVİZLİ VİRMAN HESAP İŞLEMİ';
					
						str_borclu_hesaplar = attributes.account_acc_code2;
						str_alacakli_hesaplar = attributes.account_acc_code;
						str_tutarlar = attributes.system_amount;
					
						str_borclu_other_amount_tutar = wrk_round(attributes.system_amount/dovizli_islem_multiplier_2);
						str_borclu_other_currency = attributes.currency_id2;
						str_alacakli_other_amount_tutar = attributes.ACTION_VALUE;
						str_alacakli_other_currency = attributes.currency_id;
								
						if(len(attributes.masraf) and attributes.masraf gt 0 and len(GET_EXP_ACC.ACCOUNT_CODE))
						{
							acc_branch_list_alacak = listappend(acc_branch_list_alacak,attributes.branch_id_alacak,',');
							acc_branch_list_borc = listappend(acc_branch_list_borc,attributes.branch_id_borc,',');
							str_borclu_hesaplar = ListAppend(str_borclu_hesaplar,GET_EXP_ACC.ACCOUNT_CODE,",");	
							str_alacakli_hesaplar = ListAppend(str_alacakli_hesaplar,attributes.account_acc_code,",");	
							
							if(attributes.currency_id is session.ep.money)
							{
								masraf_doviz = wrk_round(attributes.masraf/masraf_curr_multiplier);
								str_tutarlar = ListAppend(str_tutarlar,attributes.masraf,",");
							}
							else
							{
								masraf_doviz = wrk_round(attributes.masraf*dovizli_islem_multiplier);
								str_tutarlar = ListAppend(str_tutarlar,masraf_doviz,",");
							}
							str_borclu_other_amount_tutar = ListAppend(str_borclu_other_amount_tutar,attributes.masraf,",");
							str_borclu_other_currency = ListAppend(str_borclu_other_currency,attributes.currency_id,",");
							str_alacakli_other_amount_tutar = ListAppend(str_alacakli_other_amount_tutar,attributes.masraf,",");
							str_alacakli_other_currency = ListAppend(str_alacakli_other_currency,attributes.currency_id,",");
						}
						muhasebeci(
							action_id:attributes.actionId,
							workcube_process_type:process_type,
							workcube_old_process_type: attributes.old_process_type,
							workcube_process_cat:form.process_cat,
							account_card_type:13,
							islem_tarihi: attributes.ACTION_DATE,
							fis_satir_detay:str_card_detail,
							borc_hesaplar:str_borclu_hesaplar,
							borc_tutarlar:str_tutarlar,
							other_amount_borc : str_borclu_other_amount_tutar,
							other_currency_borc : str_borclu_other_currency,
							alacak_hesaplar:str_alacakli_hesaplar,
							alacak_tutarlar:str_tutarlar,
							other_amount_alacak : str_alacakli_other_amount_tutar,
							other_currency_alacak : str_alacakli_other_currency,
							currency_multiplier : currency_multiplier,
							fis_detay : 'VİRMAN HESAP İŞLEMİ',
							acc_branch_list_borc : acc_branch_list_borc,
							acc_branch_list_alacak : acc_branch_list_alacak,
							belge_no : attributes.paper_number,
							acc_project_id : attributes.project_id
						);
					}
				} else {
					if(attributes.event neq 'addmulti')
						butce_sil(action_id:attributes.multi_id,process_type:23);
					for(i=1; i lte attributes.record_num; i=i+1) {
						if(isdefined("attributes.row_kontrol#i#") and evaluate("attributes.row_kontrol#i#")) {
							from_account_id = listgetat(evaluate("attributes.from_account_id#i#"),1,';');
							to_account_id = listgetat(evaluate("attributes.to_account_id#i#"),1,';');
							currency_id = listgetat(evaluate("attributes.from_account_id#i#"),2,';');		//bankaya ait para birimi yani asil para birimi
							paper_currency_multiplier = '';													//asil para birimine ait katsayi
							if(isDefined('attributes.kur_say') and len(attributes.kur_say))
								for(mon=1;mon lte attributes.kur_say;mon=mon+1)
									if( evaluate("attributes.hidden_rd_money_#mon#") is currency_id)
										paper_currency_multiplier = evaluate('attributes.txt_rate2_#mon#/attributes.txt_rate1_#mon#');
										
							if(is_budget eq 1 and evaluate("attributes.expense_amount#i#") gt 0 and len(evaluate("attributes.expense_item_id#i#")) and len(evaluate("attributes.expense_item_name#i#")) and len(evaluate("attributes.expense_center_id#i#")) and len(evaluate("attributes.expense_center_name#i#")))
							{
								butceci(
									action_id : attributes.actionId,
									muhasebe_db : dsn2,
									is_income_expense : false,
									process_type : process_type,
									nettotal : wrk_round(evaluate("attributes.expense_amount#i#")*paper_currency_multiplier),
									other_money_value : evaluate("attributes.expense_amount#i#"),
									action_currency : currency_id,
									currency_multiplier : currency_multiplier,
									expense_date : attributes.action_date,
									expense_center_id : evaluate("expense_center_id#i#"),
									expense_item_id : evaluate("expense_item_id#i#"),
									detail : 'TOPLU VİRMAN MASRAFI',
									paper_no : evaluate("attributes.paper_number#i#"),
									branch_id : branch_id_info,
									insert_type : 1,//banka vs den eklenen masraflar için farklı ekleme metodu tanımlar
									project_id : evaluate("attributes.project_id#i#")
								);
								GET_EXP_ACC = cfquery(datasource : "#dsn2#", sqlstring : "SELECT ACCOUNT_CODE FROM EXPENSE_ITEMS WHERE EXPENSE_ITEM_ID = #evaluate("attributes.expense_item_id#i#")#");
							}

							if(is_account eq 1)
							{	
								query_from = cfquery(datasource : "#dsn2#", sqlstring : "SELECT ACCOUNT_ACC_CODE FROM #dsn3_alias#.ACCOUNTS WHERE ACCOUNT_ID = #from_account_id# ");
								account_acc_code = query_from.ACCOUNT_ACC_CODE;
								query_to =  cfquery(datasource : "#dsn2#", sqlstring : "SELECT ACCOUNT_ACC_CODE FROM #dsn3_alias#.ACCOUNTS WHERE ACCOUNT_ID = #to_account_id#");
								account_acc_code2 = query_to.ACCOUNT_ACC_CODE;
								
								str_alacakli_hesaplar = ListAppend(str_alacakli_hesaplar,account_acc_code,",");
								str_alacakli_tutarlar = ListAppend(str_alacakli_tutarlar,evaluate("attributes.action_value#i#")*paper_currency_multiplier,",");
								str_alacakli_other_amount_tutar = ListAppend(str_alacakli_other_amount_tutar,evaluate("attributes.action_value#i#"),",");
								str_alacakli_other_currency = ListAppend(str_alacakli_other_currency,currency_id,",");
								if(isDefined("attributes.action_detail#i#") and len(evaluate("attributes.action_detail#i#")))
									satir_detay_list[1][listlen(str_alacakli_tutarlar)] = '#evaluate("attributes.action_detail#i#")#';
								else if(currency_id is session.ep.money)
									satir_detay_list[1][listlen(str_alacakli_tutarlar)] = 'TOPLU VİRMAN';
								else
									satir_detay_list[1][listlen(str_alacakli_tutarlar)] = 'DÖVİZLİ TOPLU VİRMAN';
									
								str_borclu_hesaplar = ListAppend(str_borclu_hesaplar,account_acc_code2,",");
								str_borclu_tutarlar = ListAppend(str_borclu_tutarlar,evaluate("attributes.action_value#i#")*paper_currency_multiplier,",");
								str_borclu_other_amount_tutar = ListAppend(str_borclu_other_amount_tutar,evaluate("attributes.action_value#i#"),",");
								str_borclu_other_currency = ListAppend(str_borclu_other_currency,currency_id,",");
								if(isDefined("attributes.action_detail#i#") and len(evaluate("attributes.action_detail#i#")))
									satir_detay_list[2][listlen(str_borclu_tutarlar)] = '#evaluate("attributes.action_detail#i#")#';
								else if(currency_id is session.ep.money)
									satir_detay_list[2][listlen(str_borclu_tutarlar)] = 'TOPLU VİRMAN';
								else
									satir_detay_list[2][listlen(str_borclu_tutarlar)] = 'DÖVİZLİ TOPLU VİRMAN';
		
								if(isdefined("attributes.project_id#i#") and len(evaluate("attributes.project_id#i#")) and isdefined("attributes.project_head#i#") and len(evaluate("attributes.project_head#i#")))
								{
									acc_project_list_alacak = listappend(acc_project_list_alacak,evaluate("attributes.project_id#i#"),',');
									acc_project_list_borc = listappend(acc_project_list_borc,evaluate("attributes.project_id#i#"),',');
								}
								else
								{
									acc_project_list_alacak = listappend(acc_project_list_alacak,'0',',');
									acc_project_list_borc = listappend(acc_project_list_borc,'0',',');
								}
								
								if(len(evaluate("attributes.expense_amount#i#")) and evaluate("attributes.expense_amount#i#") gt 0 and isdefined("GET_EXP_ACC.ACCOUNT_CODE") and len(GET_EXP_ACC.ACCOUNT_CODE))
								{
									str_alacakli_hesaplar = ListAppend(str_alacakli_hesaplar,account_acc_code,",");	
									str_alacakli_tutarlar = ListAppend(str_alacakli_tutarlar,wrk_round(evaluate("attributes.expense_amount#i#")*paper_currency_multiplier),",");
									str_alacakli_other_amount_tutar = ListAppend(str_alacakli_other_amount_tutar,evaluate("attributes.expense_amount#i#"),",");
									str_alacakli_other_currency = ListAppend(str_alacakli_other_currency,currency_id,",");
									if(isDefined("attributes.action_detail#i#") and len(evaluate("attributes.action_detail#i#")))
										satir_detay_list[1][listlen(str_alacakli_tutarlar)] = '#evaluate("attributes.action_detail#i#")#';
									else if(currency_id is session.ep.money)
										satir_detay_list[1][listlen(str_alacakli_tutarlar)] = 'TOPLU VİRMAN';
									else
										satir_detay_list[1][listlen(str_alacakli_tutarlar)] = 'DÖVİZLİ TOPLU VİRMAN';
		
									str_borclu_hesaplar = ListAppend(str_borclu_hesaplar,GET_EXP_ACC.ACCOUNT_CODE,",");	
									str_borclu_tutarlar = ListAppend(str_borclu_tutarlar,wrk_round(evaluate("attributes.expense_amount#i#")*paper_currency_multiplier),",");
									str_borclu_other_amount_tutar = ListAppend(str_borclu_other_amount_tutar,evaluate("attributes.expense_amount#i#"),",");
									str_borclu_other_currency = ListAppend(str_borclu_other_currency,currency_id,",");
									if(isDefined("attributes.action_detail#i#") and len(evaluate("attributes.action_detail#i#")))
										satir_detay_list[2][listlen(str_borclu_tutarlar)] = '#evaluate("attributes.action_detail#i#")#';
									else if(currency_id is session.ep.money)
										satir_detay_list[2][listlen(str_borclu_tutarlar)] = 'TOPLU VİRMAN';
									else
										satir_detay_list[2][listlen(str_borclu_tutarlar)] = 'DÖVİZLİ TOPLU VİRMAN';
										
									if(isdefined("attributes.project_id#i#") and len(evaluate("attributes.project_id#i#")) and isdefined("attributes.project_head#i#") and len(evaluate("attributes.project_head#i#")))
									{
										acc_project_list_alacak = listappend(acc_project_list_alacak,evaluate("attributes.project_id#i#"),',');
										acc_project_list_borc = listappend(acc_project_list_borc,evaluate("attributes.project_id#i#"),',');
									}
									else
									{
										acc_project_list_alacak = listappend(acc_project_list_alacak,'0',',');
										acc_project_list_borc = listappend(acc_project_list_borc,'0',',');
									}    									
								}
							}
						}
					}
					if(not isDefined('form.old_process_multi_type'))
						form.old_process_multi_type = multi_type;
					if(is_account eq 1)
					{
						muhasebeci(
							action_id : attributes.actionId,
							workcube_process_type: multi_type,
							workcube_old_process_type:form.old_process_multi_type,
							workcube_process_cat : form.process_cat,
							account_card_type : 13,
							islem_tarihi : attributes.action_date,
							fis_satir_detay : satir_detay_list,
							borc_hesaplar : str_borclu_hesaplar,
							borc_tutarlar : str_borclu_tutarlar,
							other_amount_borc : str_borclu_other_amount_tutar,
							other_currency_borc : str_borclu_other_currency,
							alacak_hesaplar : str_alacakli_hesaplar,
							alacak_tutarlar : str_alacakli_tutarlar,
							other_amount_alacak : str_alacakli_other_amount_tutar,
							other_currency_alacak : str_alacakli_other_currency,
							fis_detay : 'TOPLU VİRMAN',
							from_branch_id : branch_id_info,
							to_branch_id : branch_id_info,
							acc_project_list_alacak : acc_project_list_alacak,
							acc_project_list_borc : acc_project_list_borc,
							belge_no : attributes.actionId
						);
					}
					else
						muhasebe_sil(action_id:form.multi_id,process_type:form.old_process_type);
				}
			} else {
				if(attributes.event is 'del') {
					butce_sil(action_id:attributes.actionId,muhasebe_db:dsn2,process_type:23);
					muhasebe_sil(action_id:attributes.actionId,process_type:23);
				}
			}
			if(not attributes.event contains 'multi')
				f_kur_ekle_action(action_id:attributes.actionId,action_table_name:'BANK_ACTION_MONEY',action_table_dsn:'#dsn2#');
			else
				f_kur_ekle_action(action_id:attributes.actionId,action_table_name:'BANK_ACTION_MULTI_MONEY',action_table_dsn:'#dsn2#');
		}
	}
	
	// Switch //
	WOStruct = StructNew();
	
	WOStruct['#attributes.fuseaction#'] = structNew();
	
	WOStruct['#attributes.fuseaction#']['default'] = 'add';
	
	if(not isdefined('attributes.event'))
		attributes.event = WOStruct['#attributes.fuseaction#']['default'];
		
	WOStruct['#attributes.fuseaction#']['list'] = structNew();
	WOStruct['#attributes.fuseaction#']['list']['window'] = 'normal';
	WOStruct['#attributes.fuseaction#']['list']['fuseaction'] = 'bank.list_bank_actions';
	
	WOStruct['#attributes.fuseaction#']['systemObject'] = structNew();
	WOStruct['#attributes.fuseaction#']['systemObject']['processCat'] = true;
	WOStruct['#attributes.fuseaction#']['systemObject']['processType'] = 23;
	WOStruct['#attributes.fuseaction#']['systemObject']['processCatSelected'] = process_cat;
	
	if(not attributes.event contains 'multi'){
		WOStruct['#attributes.fuseaction#']['systemObject']['paperNumber'] = true;
		WOStruct['#attributes.fuseaction#']['systemObject']['paperType'] = 'virman';
	}
	
	WOStruct['#attributes.fuseaction#']['systemObject']['paperDate'] = true;
	WOStruct['#attributes.fuseaction#']['systemObject']['paperDateCallFunction'] = 'change_money_info';
	WOStruct['#attributes.fuseaction#']['systemObject']['isTransaction'] = true;
	WOStruct['#attributes.fuseaction#']['systemObject']['dataSourceName'] = dsn2; // Transaction ve extendedFields icin yapildi.
	
	if(attributes.event is "add" or attributes.event is "upd")
	{
		WOStruct['#attributes.fuseaction#']['systemObject']['extendedForm'] = true;
		WOStruct['#attributes.fuseaction#']['systemObject']['pageExtendedEventList'] = 'add,upd';
		WOStruct['#attributes.fuseaction#']['systemObject']['pageTableName'] = 'BANK_ACTIONS';
		WOStruct['#attributes.fuseaction#']['systemObject']['pageIdentityColumn'] = 'ACTION_ID';
		WOStruct['#attributes.fuseaction#']['systemObject']['pageSettings'] = "['item-process_cat','item-from_account_id','item-comp_name','item-action_date','item-ACTION_VALUE']";
	}
	else if(attributes.event is "addmulti" or attributes.event is "updmulti")
	{
		WOStruct['#attributes.fuseaction#']['systemObject']['extendedForm'] = true;
		WOStruct['#attributes.fuseaction#']['systemObject']['pageExtendedEventList'] = 'addmulti,updmulti';
		WOStruct['#attributes.fuseaction#']['systemObject']['pageTableName'] = 'BANK_ACTIONS_MULTI';
		WOStruct['#attributes.fuseaction#']['systemObject']['pageIdentityColumn'] = 'MULTI_ACTION_ID';
		WOStruct['#attributes.fuseaction#']['systemObject']['pageSettings'] = "['item-process_cat','item-action_date']";
	}
	
	WOStruct['#attributes.fuseaction#']['add'] = structNew();
	WOStruct['#attributes.fuseaction#']['add']['window'] = 'normal';
	WOStruct['#attributes.fuseaction#']['add']['fuseaction'] = 'bank.form_add_virman';
	WOStruct['#attributes.fuseaction#']['add']['filePath'] = 'bank/form/FormBankCurrencyChange.cfm';
	WOStruct['#attributes.fuseaction#']['add']['queryPath'] = '';
	WOStruct['#attributes.fuseaction#']['add']['nextEvent'] = 'bank.form_add_virman&event=upd&id=';
	WOStruct['#attributes.fuseaction#']['add']['formName'] = 'virman';
	
	WOStruct['#attributes.fuseaction#']['add']['buttons'] = structNew();
	WOStruct['#attributes.fuseaction#']['add']['buttons']['save'] = 1;
	WOStruct['#attributes.fuseaction#']['add']['buttons']['saveFunction'] = 'kontrol() && validate().check()';
	
	WOStruct['#attributes.fuseaction#']['upd'] = structNew();
	WOStruct['#attributes.fuseaction#']['upd']['window'] = 'normal';
	WOStruct['#attributes.fuseaction#']['upd']['fuseaction'] = 'bank.form_add_virman';
	WOStruct['#attributes.fuseaction#']['upd']['filePath'] = 'bank/form/FormBankCurrencyChange.cfm';
	WOStruct['#attributes.fuseaction#']['upd']['queryPath'] = '';
	WOStruct['#attributes.fuseaction#']['upd']['nextEvent'] = 'bank.form_add_virman&event=upd&id=';
	WOStruct['#attributes.fuseaction#']['upd']['parameters'] = 'id=##attributes.id##';
	WOStruct['#attributes.fuseaction#']['upd']['Identity'] = '##attributes.id##';
	WOStruct['#attributes.fuseaction#']['upd']['recordQuery'] = 'get_action_detail1';
	WOStruct['#attributes.fuseaction#']['upd']['formName'] = 'virman';
	
	WOStruct['#attributes.fuseaction#']['upd']['buttons']['update'] = 1;
	WOStruct['#attributes.fuseaction#']['upd']['buttons']['updateFunction'] = 'kontrol() && validate().check()';
	WOStruct['#attributes.fuseaction#']['upd']['buttons']['delete'] = 1;
	WOStruct['#attributes.fuseaction#']['upd']['buttons']['deleteEvent'] = 'del';
	
	WOStruct['#attributes.fuseaction#']['addmulti'] = structNew();
	WOStruct['#attributes.fuseaction#']['addmulti']['window'] = 'normal';
	WOStruct['#attributes.fuseaction#']['addmulti']['fuseaction'] = 'bank.form_add_virman';
	WOStruct['#attributes.fuseaction#']['addmulti']['filePath'] = 'bank/form/FormBankCurrencyChangeMulti.cfm';
	WOStruct['#attributes.fuseaction#']['addmulti']['queryPath'] = '';
	WOStruct['#attributes.fuseaction#']['addmulti']['nextEvent'] = 'bank.form_add_virman&event=updmulti&multi_id=';
	WOStruct['#attributes.fuseaction#']['addmulti']['js'] = "javascript:gizle_goster_ikili('collacted_virman','collacted_virman_sepet')";
	WOStruct['#attributes.fuseaction#']['addmulti']['formName'] = 'virman';
   
	WOStruct['#attributes.fuseaction#']['addMulti']['buttons'] = structNew();
	WOStruct['#attributes.fuseaction#']['addMulti']['buttons']['save'] = 1;
	WOStruct['#attributes.fuseaction#']['addMulti']['buttons']['saveFunction'] = 'kontrol()';
   
	WOStruct['#attributes.fuseaction#']['updmulti'] = structNew();
	WOStruct['#attributes.fuseaction#']['updmulti']['window'] = 'normal';
	WOStruct['#attributes.fuseaction#']['updmulti']['fuseaction'] = 'bank.form_add_virman';
	WOStruct['#attributes.fuseaction#']['updmulti']['filePath'] = 'bank/form/FormBankCurrencyChangeMulti.cfm';
	WOStruct['#attributes.fuseaction#']['updmulti']['queryPath'] = '';
	WOStruct['#attributes.fuseaction#']['updmulti']['nextEvent'] = 'bank.form_add_virman&event=updmulti&multi_id=';
	WOStruct['#attributes.fuseaction#']['updmulti']['parameters'] = 'multi_id=##attributes.multi_id##';
	WOStruct['#attributes.fuseaction#']['updmulti']['Identity'] = '##attributes.multi_id##';
	WOStruct['#attributes.fuseaction#']['updmulti']['js'] = "javascript:gizle_goster_ikili('collacted_virman','collacted_virman_sepet')";
	WOStruct['#attributes.fuseaction#']['updmulti']['formName'] = 'virman';
	WOStruct['#attributes.fuseaction#']['updmulti']['recordQuery'] = 'getMultiData.mainData';
   
	WOStruct['#attributes.fuseaction#']['updmulti']['buttons'] = structNew();

	WOStruct['#attributes.fuseaction#']['updmulti']['buttons']['update'] = 1;
	WOStruct['#attributes.fuseaction#']['updmulti']['buttons']['updateFunction'] = 'kontrol()';
	WOStruct['#attributes.fuseaction#']['updmulti']['buttons']['delete'] = 1;
	WOStruct['#attributes.fuseaction#']['updmulti']['buttons']['deleteFunction'] = 'control_del_form()';
	WOStruct['#attributes.fuseaction#']['updmulti']['buttons']['deleteUrl'] = '#request.self#?fuseaction=bank.form_add_virman&event=delmulti&id=169';
	
	if(attributes.event is 'upd' or attributes.event is 'updmulti' or attributes.event is 'del' or attributes.event is 'delmulti')
	{
	   if(isdefined("attributes.multi_id"))
	   {
			WOStruct['#attributes.fuseaction#']['delmulti'] = structNew();
			WOStruct['#attributes.fuseaction#']['delmulti']['window'] = 'emptypopup';
			WOStruct['#attributes.fuseaction#']['delmulti']['fuseaction'] = 'bank.form_add_virman&multi_id=#attributes.multi_id#';
			WOStruct['#attributes.fuseaction#']['delmulti']['filePath'] = '';
			WOStruct['#attributes.fuseaction#']['delmulti']['queryPath'] = '';
			WOStruct['#attributes.fuseaction#']['delmulti']['nextEvent'] = 'bank.list_bank_actions';                   
	   }
	   else if(isdefined("attributes.id"))
	   {
			WOStruct['#attributes.fuseaction#']['del'] = structNew();
			WOStruct['#attributes.fuseaction#']['del']['window'] = 'emptypopup';
			if(not isdefined('attributes.formSubmittedController'))
				WOStruct['#attributes.fuseaction#']['del']['fuseaction'] = 'bank.emptypopup_del_virman&id=#attributes.id#';
			else
				WOStruct['#attributes.fuseaction#']['del']['fuseaction'] = 'bank.emptypopup_del_virman&id=#attributes.id#';
			WOStruct['#attributes.fuseaction#']['del']['filePath'] = '';
			WOStruct['#attributes.fuseaction#']['del']['queryPath'] = '';
			WOStruct['#attributes.fuseaction#']['del']['nextEvent'] = 'bank.list_bank_actions';      
	   }
	}
	
	if(attributes.event is 'add')
	{
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['add'] = structNew();
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['add']['menus'][0]['text'] = '#lang_array_main.item[620]# #lang_array_main.item[280]#';
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['add']['menus'][0]['href'] = "#request.self#?fuseaction=bank.form_add_virman&event=addmulti";
	}
	
	if(attributes.event is 'upd')
	{
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd'] = structNew();
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'] = structNew();
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][0]['text'] = '#lang_array_main.item[1966]#';
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][0]['customTag'] = '<cf_get_workcube_related_acts period_id="#session.ep.period_id#" company_id="#session.ep.company_id#" asset_cat_id="-17" module_id="19" action_section="BANK_ACTION_ID" action_id="#attributes.id#">';
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][1]['text'] = '#lang_array_main.item[1040]#';
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][1]['onClick'] = "windowopen('#request.self#?fuseaction=account.popup_list_card_rows&action_id=#attributes.id#&process_cat=#get_action_detail1.action_type_id#','page','upd_virman');";
		
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons'] = structNew();
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['add']['text'] = '#lang_array_main.item[170]#';
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['add']['href'] = "#request.self#?fuseaction=bank.form_add_virman";
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['add']['target'] = "_blank";
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['copy']['text'] = '#lang_array_main.item[64]#';
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['copy']['href'] = '#request.self#?fuseaction=bank.form_add_virman&ID=#get_action_detail1.action_id#';
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['copy']['target'] = "_blank";
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['print']['text'] = '#lang_array_main.item[62]#';
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['print']['onClick'] = "windowopen('#request.self#?fuseaction=objects.popup_print_files&action_id=#attributes.id#&print_type=155&action_type=#get_action_detail1.action_type_id#','page')";
		tabMenuData = SerializeJSON(tabMenuStruct['#attributes.fuseaction#']['tabMenus']);
	}
	
	if(attributes.event is 'updmulti')
	{		
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['updmulti'] = structNew();
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['updmulti']['menus'] = structNew();
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['updmulti']['menus'][0]['text'] = '#lang_array_main.item[1966]#';
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['updmulti']['menus'][0]['customTag'] = '<cf_get_workcube_related_acts period_id="#session.ep.period_id#" company_id="#session.ep.company_id#" asset_cat_id="-17" module_id="19" action_section="BANK_MULTI_ACTION_ID" action_id="#attributes.multi_id#">';
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['updmulti']['menus'][1]['text'] = '#lang_array_main.item[1040]#';
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['updmulti']['menus'][1]['onClick'] = "windowopen('#request.self#?fuseaction=account.popup_list_card_rows&action_id=#attributes.multi_id#&process_cat=230','page','virman')";
		
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['updmulti']['icons'] = structNew();
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['updmulti']['icons']['add']['text'] = '#lang_array_main.item[170]#';
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['updmulti']['icons']['add']['href'] = "#request.self#?fuseaction=bank.form_add_virman&event=addmulti";
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['updmulti']['icons']['add']['target'] = "_blank";
		tabMenuData = SerializeJSON(tabMenuStruct['#attributes.fuseaction#']['tabMenus']);
	}
	
	if(attributes.event is 'addmulti')
	{		
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['updmulti'] = structNew();
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['updmulti']['menus'] = structNew();
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['addmulti']['menus'][0]['text'] = '#lang_array_main.item[1998]# #lang_array_main.item[280]#';
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['addmulti']['menus'][0]['href'] = "#request.self#?fuseaction=bank.form_add_virman&event=add";  
		tabMenuData = SerializeJSON(tabMenuStruct['#attributes.fuseaction#']['tabMenus']);
	}
</cfscript>

<script type="text/javascript">
	<cfoutput>
		<cfif not (len(paper_code) and len(paper_number))>
			var auto_paper_code = "";
			var auto_paper_number = "";
		<cfelse>
			var auto_paper_code = "#paper_code#-";
			var auto_paper_number = "#paper_number#";
		</cfif>
		<cfif (isdefined("attributes.event") and attributes.event is 'updmulti')>
			var all_action_list = "#ListDeleteDuplicates(ValueList(getMultiData.rowData.action_id,','))#";
			var all_action_list_ = "#ListDeleteDuplicates(ValueList(getMultiData.rowData.action_id,','))#";
			all_action_list += ","+all_action_list_;
			row_count=#getMultiData.rowData.recordcount#;
		<cfelseif (isdefined("attributes.event") and attributes.event is 'addmulti')>
			row_count=0;
		</cfif>
	</cfoutput>
	<cfif (isdefined("attributes.event") and attributes.event is 'updmulti')>
		function control_del_form()
		{
			return control_account_process(<cfoutput>'#getMultiData.rowData.multi_action_id#','#getMultiData.rowData.action_type_id#'</cfoutput>);
		}
		$( document ).ready(function() {
			toplam_hesapla();
		});
	</cfif>
</script>

<script type="text/javascript">
	<cfif attributes.event contains 'multi'>
		function sil(sy)
		{
			var my_element=document.getElementById('row_kontrol'+sy);	
			my_element.value=0;		
			var my_element=eval("frm_row"+sy);	
			my_element.style.display="none";
			
			toplam_hesapla();
		}
	   function add_row(amount,paper_no,exp_center_id,exp_item_id,exp_center_name,exp_item_name,expense_amount,action_detail,from_account_id,to_account_id,project_id,project_head)
		{
			if(amount == undefined) amount = 0;
			if(expense_amount == undefined) expense_amount = 0;	
			if(paper_no == undefined) paper_no = '';
			if(action_detail == undefined) action_detail = '';
			if(project_id == undefined) project_id = '';
			if(project_head == undefined) project_head = '';
			if(exp_center_id == undefined) exp_center_id = '';
			if(exp_item_id == undefined) exp_item_id = '';
			if(exp_center_name == undefined) exp_center_name = '';
			if(exp_item_name == undefined) exp_item_name = '';
			if(from_account_id == undefined) from_account_id = '';
			if(to_account_id == undefined) to_account_id = '';
			
			row_count++;
			var newRow;
			var newCell;	
			document.getElementById('record_num').value=row_count;
			newRow = document.getElementById("table1").insertRow(document.getElementById("table1").rows.length);
			newRow.setAttribute("name","frm_row" + row_count);
			newRow.setAttribute("id","frm_row" + row_count);
			newRow.className = 'color-row';
			newCell = newRow.insertCell(newRow.cells.length);
			newCell.setAttribute("nowrap","nowrap");
			newCell.innerHTML = '<input  type="hidden"  value="1"  name="row_kontrol' + row_count +'" id="row_kontrol' + row_count +'"><a href="javascript://" onclick="sil(' + row_count + ');"><img src="/images/delete_list.gif" border="0" align="absmiddle"></a><a style="cursor:pointer" onclick="copy_row('+row_count+');" title="<cf_get_lang_main no="1560.Satır Kopyala">"><img  src="images/copy_list.gif" border="0" align="absmiddle"></a>';
			newCell = newRow.insertCell(newRow.cells.length);
			newCell.setAttribute("nowrap","nowrap");
			newCell.innerHTML = '<input type="text" name="paper_number' + row_count +'" id="paper_number' + row_count +'" value="'+auto_paper_code + auto_paper_number+'" class="boxtext">';
			if(auto_paper_number != '')
				auto_paper_number++;
			// hangi hesaptan	
			newCell = newRow.insertCell(newRow.cells.length);
			newCell.setAttribute("nowrap","nowrap");
			a = '<select name="from_account_id' + row_count +'" id="from_account_id' + row_count +'" style="width:200px;"><option value=""><cf_get_lang_main no='322.Seçiniz'></option>';
			<cfoutput query="getBankAccounts">
				if ('#account_id#;#account_currency_id#' == from_account_id)
					a += '<option value="#account_id#;#account_currency_id#" selected>#account_name# #account_currency_id#</option>';
				else
					a += '<option value="#account_id#;#account_currency_id#">#account_name# #account_currency_id#</option>';
			</cfoutput>
			newCell.innerHTML = a+ '</select>';
			// hangi hesaba
			newCell = newRow.insertCell(newRow.cells.length);
			newCell.setAttribute("nowrap","nowrap");
			b = '<select name="to_account_id' + row_count +'" id="to_account_id' + row_count +'" style="width:200px;"><option value=""><cf_get_lang_main no='322.Seçiniz'></option>';
			<cfoutput query="getBankAccounts">
				if ('#account_id#;#account_currency_id#' == to_account_id)
					b += '<option value="#account_id#;#account_currency_id#" selected>#account_name# #account_currency_id#</option>';
				else
					b += '<option value="#account_id#;#account_currency_id#">#account_name# #account_currency_id#</option>';
			</cfoutput>
			newCell.innerHTML = b + '</select>';
			//tutar
			newCell = newRow.insertCell(newRow.cells.length);
			newCell.setAttribute("nowrap","nowrap");
			newCell.innerHTML = '<input type="text" name="action_value' + row_count +'" id="action_value' + row_count + '" value="'+commaSplit(amount)+'" onkeyup="return(FormatCurrency(this,event));" onBlur="toplam_hesapla();" style="width:100%;" class="box">';
			//aciklama
			newCell = newRow.insertCell(newRow.cells.length);
			newCell.setAttribute("nowrap","nowrap");
			newCell.innerHTML = '<input type="text" name="action_detail' + row_count +'" id="action_detail' + row_count + '" value="'+action_detail+'" style="width:100%;" class="boxtext">';
			// proje
			newCell = newRow.insertCell(newRow.cells.length);
			newCell.setAttribute("nowrap","nowrap");
			newCell.innerHTML ='<input type="hidden" name="project_id' + row_count +'" value="'+project_id+'" id="project_id' + row_count +'"><input type="text" id="project_head' + row_count +'" name="project_head' + row_count +'"  onFocus="autocomp_project('+row_count+');" value="'+project_head+'" style="width:150px;" class="boxtext"><a href="javascript://" onClick="pencere_ac_project('+ row_count +');"><img src="/images/plus_thin.gif" align="absmiddle" border="0"></a>';
			// masraf tutari
			newCell = newRow.insertCell(newRow.cells.length);
			newCell.setAttribute("nowrap","nowrap");
			newCell.innerHTML = '<input type="text" name="expense_amount' + row_count +'" id="expense_amount' + row_count +'" value="'+commaSplit(expense_amount)+'" onkeyup="return(FormatCurrency(this,event));" style="width:100%;" class="box">';
			// masraf merkezi
			newCell = newRow.insertCell(newRow.cells.length);
			newCell.setAttribute("nowrap","nowrap");
			newCell.innerHTML ='<input type="hidden" name="expense_center_id' + row_count +'" value="'+exp_center_id+'" id="expense_center_id' + row_count +'"><input type="text" id="expense_center_name' + row_count +'" name="expense_center_name' + row_count +'"  onFocus="exp_center('+row_count+');" value="'+exp_center_name+'" style="width:150px;" class="boxtext"><a href="javascript://" onClick="pencere_ac_exp('+ row_count +');"><img src="/images/plus_thin.gif" align="absmiddle" border="0"></a>';
			//gider kalemi
			newCell = newRow.insertCell(newRow.cells.length);
			newCell.setAttribute("nowrap","nowrap");
			newCell.innerHTML ='<input type="hidden" name="expense_item_id' + row_count +'" value="'+exp_item_id+'" id="expense_item_id' + row_count +'"><input type="text" id="expense_item_name' + row_count +'" name="expense_item_name' + row_count +'" value="'+exp_item_name+'" style="width:150px;" onFocus="exp_item('+row_count+');" class="boxtext"><a href="javascript://" onClick="pencere_ac_item('+ row_count +');"><img src="/images/plus_thin.gif"  align="absmiddle" border="0"></a>';
			toplam_hesapla();
		}
		function copy_row(no_info)
		{
			paper_number = document.getElementById('paper_number' + no_info).value;
			if(filterNum(document.getElementById('action_value' + no_info).value) > 0 )
				action_value = filterNum(document.getElementById('action_value' + no_info).value,'<cfoutput>#rate_round_num_info#</cfoutput>');else action_value = 0;
			action_detail = document.getElementById('action_detail' + no_info).value;
			project_id = document.getElementById('project_id' + no_info).value;
			project_head = document.getElementById('project_head' + no_info).value;
			expense_amount = document.getElementById('expense_amount' + no_info).value;
			expense_center_id = document.getElementById('expense_center_id' + no_info).value;
			expense_center_name = document.getElementById('expense_center_name' + no_info).value;
			expense_item_id = document.getElementById('expense_item_id' + no_info).value;
			expense_item_name = document.getElementById('expense_item_name' + no_info).value;
			from_account_id = document.getElementById('from_account_id' + no_info).value;
			to_account_id = document.getElementById('to_account_id' + no_info).value;
	
			add_row(action_value,paper_number,expense_center_id,expense_item_id,expense_center_name,expense_item_name,expense_amount,action_detail,from_account_id,to_account_id,project_id,project_head);    
		}
		function autocomp_project(no)
		{
			AutoComplete_Create("project_head"+no,"PROJECT_HEAD","PROJECT_HEAD","get_project","","PROJECT_ID","project_id"+no,"",3,200);
		}
		function pencere_ac_project(no)
		{
			windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_projects&project_id=virman.project_id' + no +'&project_head=virman.project_head' + no +'','list');
		}
		function pencere_ac_exp(no)
		{
			windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_expense_center&is_invoice=1&field_id=virman.expense_center_id' + no +'&field_name=virman.expense_center_name' + no,'list');
		}
		function pencere_ac_item(no)
		{
			windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_exp_item&field_id=virman.expense_item_id' + no +'&field_name=virman.expense_item_name' + no,'list');
		}
		function exp_center(no)
		{
			AutoComplete_Create("expense_center_name" + no,"EXPENSE,EXPENSE_CODE","EXPENSE,EXPENSE_CODE","get_expense_center","","EXPENSE_ID","expense_center_id"+no,"",3);
		}
		function exp_item(no)
		{
			AutoComplete_Create("expense_item_name" + no,"EXPENSE_ITEM_NAME","EXPENSE_ITEM_NAME","get_expense_item","","EXPENSE_ITEM_ID","expense_item_id"+no,"",3);
		}
		function toplam_hesapla()
		{
			rate2_value = 0;
			deger_diger_para = '<cfoutput>#session.ep.money#</cfoutput>';
			for (var t=1; t<=document.getElementById('kur_say').value; t++)
			{
				if(document.virman.rd_money[t-1].checked == true)
				{
					for(k=1; k<=document.getElementById('record_num').value; k++)
					{
						rate2_value = filterNum(document.getElementById('txt_rate2_'+t).value,'<cfoutput>#rate_round_num_info#</cfoutput>');
						deger_diger_para = list_getat(document.virman.rd_money[t-1].value,1,',');
					}
				}
			}
			var total_amount = 0;
			var rate_ = 1;
			for(j=1; j<=document.getElementById('record_num').value; j++)
			{
				if(document.getElementById('row_kontrol'+j).value==1)
				{
					url_= '/V16/bank/cfc/bankInfo.cfc?method=getCurrencyInfo';
					
					$.ajax({
						type: "get",
						url: url_,
						data: {money: list_getat(document.getElementById('from_account_id'+j).value,2,';'),period: document.getElementById('active_period').value,company: document.getElementById('active_company').value},
						cache: false,
						async: false,
						success: function(read_data){
							data_ = jQuery.parseJSON(read_data.replace('//',''));
							if(data_.DATA.length != 0)
							{
								$.each(data_.DATA,function(i){
									rate_ = data_.DATA[i][0];
									});
							}
						}
					});
					total_amount += parseFloat(filterNum(document.getElementById('action_value'+j).value)*rate_);
					var selected_ptype = document.getElementById('process_cat').options[document.getElementById('process_cat').selectedIndex].value;
					if (selected_ptype != '')
						eval('var proc_control = document.virman.ct_process_type_'+selected_ptype+'.value');
					else
						var proc_control = '';
				}
			}
			document.getElementById('total_amount').value = commaSplit(total_amount);
		}
		function kontrol()
		{
			if(!chk_process_cat('virman')) return false;
			if(!check_display_files('virman')) return false;
			if(!chk_period(virman.action_date,'İşlem')) return false;
			
			var record_exist = 0;
			
			for(j=1; j<=document.getElementById('record_num').value; j++)
			{
				if(document.getElementById('row_kontrol'+j).value==1)
				{
					record_exist=1;
					//satirda hesaplarin kontrolu 
					if (list_getat(document.getElementById('from_account_id'+j).value,1,';') == "" || list_getat(document.getElementById('to_account_id'+j).value,1,';') == "")
					{
						alertObject({message: document.getElementById('paper_number'+j).value+":<cf_get_lang_main no='793.Lutfen Banka Hesabi Seciniz'>!", closeTime : 3000});
						return false;
					}
					//satirda tutar kontrolu
					if(parseFloat(document.getElementById('action_value'+j).value) == 0)				
					{
						alertObject({message: document.getElementById('paper_number'+j).value+":<cf_get_lang_main no='1738.Lütfen Tutar Giriniz'>", closeTime : 3000});
						return false;
					}
					if(list_getat(document.getElementById('from_account_id'+j).value,1,';') == list_getat(document.getElementById('to_account_id'+j).value,1,';'))				
					{
						alertObject({message: document.getElementById('paper_number'+j).value+":<cf_get_lang no='94.Seçtiğiniz Banka Hesapları Aynı'>", closeTime : 3000});
						return false;
					}
					//satirda bankalara ait para birimi kontrolu
					if (list_getat(document.getElementById('from_account_id'+j).value,2,';') != list_getat(document.getElementById('to_account_id'+j).value,2,';'))
					{
						alertObject({message: document.getElementById('paper_number'+j).value+":<cf_get_lang dictionary_id='52402.Seçilen Bankalara Ait Para birimleri Aynı Olmalıdır'>!", closeTime : 3000});
						return false;
					}
					//masraf girilmisse buna bagli masraf merkezi ve gider kalemi kontrolu
					if(document.getElementById('expense_amount'+j).value != "" && parseFloat(filterNum(document.getElementById('expense_amount'+j).value)) > 0)
					{
						if(document.getElementById('expense_center_id'+j).value == "" || document.getElementById('expense_center_name'+j).value == "")
						{
							alertObject({message: document.getElementById('paper_number'+j).value+":<cf_get_lang dictionary_id='48881.Masraf Merkezi Seçiniz'>!", closeTime : 3000});
							return false;
						}
						if(document.getElementById('expense_item_id'+j).value == "" || document.getElementById('expense_item_name'+j).value == "")
						{
							alertObject({message: document.getElementById('paper_number'+j).value+":<cf_get_lang dictionary_id='50018.Gider Kalemi Seçiniz'>!", closeTime : 3000});
							return false;
						}
					}
				}
			}
			if (record_exist == 0) 
			{
				alertObject({message: "<cf_get_lang no ='3.Lütfen Satır Ekleyiniz'>!", closeTime : 3000});
				return false;
			}
			return true;
		}
	<cfelse>
		<cfif attributes.event is 'addmulti'>
			$( document ).ready(function() {
				kur_ekle_f_hesapla('from_account_id');
			});
		<cfelseif attributes.event is 'updmulti'>
			function del_kontrol()
			{
				control_account_process(<cfoutput>'#attributes.id#','#get_action_detail1.action_type_id#'</cfoutput>);
				if(!chk_period(document.virman.action_date, 'İşlem')) return false;
				else return true;
			}
		</cfif>
		function change_currency_info()
		{
			new_kur_say = document.all.kur_say.value;
			for(var i=1;i<=new_kur_say;i++)
			{
				if(eval('document.all.hidden_rd_money_'+i) != undefined && eval('document.all.hidden_rd_money_'+i).value == document.getElementById('currency_id2').value)
					eval('document.all.rd_money['+(i-1)+']').checked = true;
			}
			kur_ekle_f_hesapla('from_account_id');
		}
		function kontrol()
		{
			var formName = 'virman',  // scripttin en başına bir defa yazılacak
			form  = $('form[name="'+ formName +'"]'); // form'u seçer  
						  
			if(!chk_process_cat('virman')) return false;
			if(!check_display_files('virman')) return false;
			if(!chk_period(document.virman.action_date,'İşlem')) return false;
		<cfif attributes.event is 'addmulti'>
			if(!acc_control('from_account_id')) return false;
			if(!acc_control('to_account_id')) return false;
		<cfelseif attributes.event is 'updmulti'>
			control_account_process(<cfoutput>'#attributes.id#','#get_action_detail1.action_type_id#'</cfoutput>);
		</cfif>
		kur_ekle_f_hesapla('from_account_id');//dövizli tutarı silinenler için
		if($('#from_account_id').val() == $('#to_account_id').val())				
		{
			validateMessage('notValid',form.find('select#from_account_id')); 
			validateMessage('notValid',form.find('select#to_account_id'));	
			return false; 
		}
		else
		{
			validateMessage('valid',form.find('select#from_account_id'));
			validateMessage('valid',form.find('select#to_account_id'));
		}
		if(parseFloat($('#ACTION_VALUE').val()) == 0) {
			validateMessage('notValid',form.find('input#ACTION_VALUE'));
			return false; // validate niye bunu durdurmuyor? halbuki alttaki kontrollerde durduruyor. Durgan	
		}
		else
			validateMessage('valid',form.find('input#ACTION_VALUE'));
		if(document.virman.masraf.value != "" && parseFloat(document.virman.masraf.value) > 0)
		{
			if(document.virman.expense_center_id.value == "" || document.virman.expense_center_name.value == "")
			{
				validateMessage('notValid',form.find('input#expense_center_name'));
				return false;
			}
			else
			{
				validateMessage('valid',form.find('input#expense_center_name'));
			}
			if(document.virman.expense_item_id.value == "" || document.virman.expense_item_name.value == "")
			{
				validateMessage('notValid',form.find('input#expense_item_name'));
				return false;
			}
			else
			{
				validateMessage('valid',form.find('input#expense_item_name'));
			}

		}
		else
		{
			validateMessage('valid',form.find('input#expense_item_name'));
			validateMessage('valid',form.find('input#expense_center_name'));
		}
		return true;
		}
	</cfif>
</script>