<cfscript>
	if(is_cari eq 1)
	{
		if(is_cheque_based eq 1) /*islem kategorisinde cek bazında carici secili*/
		{	
			/*bordro ilk kaydedildiginde carici bordro bazında calıstırılmıssa, once bu kayıt silinir ardından cek bazında carici cagırılır*/
			if(attributes.payroll_acc_cari_cheque_based neq 1) 
				cari_sil(action_id:attributes.id,action_table:'PAYROLL',process_type:form.old_process_type);
			else
			{ /*bordrodan cıkarılan ceklerin cari hareketleri siliniyor*/
				for(cheq_n=1;cheq_n lte listlen(ches_flag);cheq_n=cheq_n+1)
					cari_sil(action_id:listgetat(ches_flag,cheq_n,','),action_table:'CHEQUE',process_type:form.old_process_type,payroll_id :attributes.id);
			}
			
			for(cheq_x=1;cheq_x lte listlen(last_cheque_list);cheq_x=cheq_x+1) /*bordrodaki ceklerin herbiri icin cari hareket yazılıyor*/
			{
				if(get_cheques_last.CURRENCY_ID[cheq_x] is not session.ep.money)
				{
					other_money =get_cheques_last.CURRENCY_ID[cheq_x];
					other_money_value =get_cheques_last.CHEQUE_VALUE[cheq_x];
				}
				else if(len(attributes.basket_money) and len(attributes.basket_money_rate))
				{
					other_money = attributes.basket_money;
					other_money_value = wrk_round(get_cheques_last.OTHER_MONEY_VALUE[cheq_x]/attributes.basket_money_rate);
				}
				else if(len(get_cheques_last.OTHER_MONEY_VALUE2[cheq_x]) and len(get_cheques_last.OTHER_MONEY2[cheq_x]) )
				{
					other_money =get_cheques_last.OTHER_MONEY2[cheq_x];
					other_money_value =get_cheques_last.OTHER_MONEY_VALUE2[cheq_x];
				}
				else
				{
					other_money = get_cheques_last.OTHER_MONEY[cheq_x];
					other_money_value = get_cheques_last.OTHER_MONEY_VALUE[cheq_x];
				}
				paper_currency_multiplier = '';
				if(isDefined('attributes.kur_say') and len(attributes.kur_say))
					for(mon=1;mon lte attributes.kur_say;mon=mon+1)
					{
						if(evaluate("attributes.hidden_rd_money_#mon#") is other_money)
							paper_currency_multiplier = evaluate('attributes.txt_rate2_#mon#/attributes.txt_rate1_#mon#');
					}
				GET_CHEQUE_STATUS=cfquery(datasource:"#dsn2#",sqlstring:"SELECT CHEQUE_STATUS_ID FROM CHEQUE WHERE CHEQUE_ID=#listgetat(last_cheque_list,cheq_x,',')#");
				carici(
					action_id :listgetat(last_cheque_list,cheq_x,','),
					action_table :'CHEQUE',
					workcube_process_type :process_type,
					workcube_old_process_type :form.old_process_type,
					process_cat :form.process_cat,
					account_card_type :13,
					islem_tarihi :attributes.PAYROLL_REVENUE_DATE,
					islem_tutari :get_cheques_last.OTHER_MONEY_VALUE[cheq_x],
					other_money_value : iif(isdefined('other_money_value'),'other_money_value',de('')),
					other_money :iif(isdefined('other_money'),'other_money',de('')),
					islem_belge_no : get_cheques_last.CHEQUE_NO[cheq_x],
					from_cmp_id : iif(attributes.member_type eq "partner",'attributes.company_id',de('')),
					from_consumer_id : iif(attributes.member_type eq "consumer",'attributes.consumer_id',de('')),
					from_employee_id : iif(attributes.member_type eq "employee",'attributes.employee_id',de('')),
					to_cash_id : listfirst(form.cash_id,';'),
					due_date : iif(len(get_cheques_last.CHEQUE_DUEDATE[cheq_x]),'createodbcdatetime(get_cheques_last.CHEQUE_DUEDATE[cheq_x])','attributes.pyrll_avg_duedate'),
					currency_multiplier : currency_multiplier,
					islem_detay : 'ÇEK GİRİŞ BORDROSU(Çek Bazında)',
					acc_type_id : attributes.acc_type_id,
					action_detail : attributes.action_detail,
					project_id : attributes.project_id,
					to_branch_id : branch_id_info,
					payroll_id :attributes.id,
					special_definition_id : iif((isdefined("attributes.special_definition_id") and len(attributes.special_definition_id)),'attributes.special_definition_id',de('')),
					assetp_id : iif((isdefined("attributes.asset_id") and len(attributes.asset_id) and len(attributes.asset_name)),'attributes.asset_id',de('')),
					is_upd_other_value : iif(GET_CHEQUE_STATUS.CHEQUE_STATUS_ID eq 3,is_upd_cari_row,0),//işlem kategrnsdeki extre güncelleme işlemnde dövizleri tekrar değiştirmesn
					rate2:paper_currency_multiplier
				);
			}
		}
		else
		{
			/*bordro ilk kaydedildiginde carici cek bazında calıstırılmıssa, once bu kayıt silinir ardından bordro bazında carici cagırılır*/
			if(attributes.payroll_acc_cari_cheque_based eq 1)
			{ 
				for(cheq_w=1;cheq_w lte listlen(ches);cheq_w=cheq_w+1)
					cari_sil(action_id:listgetat(ches,cheq_w,','),action_table:'CHEQUE',process_type:form.old_process_type,payroll_id :attributes.id);
			}
			carici(
				action_table :'PAYROLL',
				action_id :attributes.id,
				workcube_process_type :process_type,
				workcube_old_process_type :form.old_process_type,
				process_cat :form.process_cat,
				account_card_type :13,
				islem_tarihi :attributes.PAYROLL_REVENUE_DATE,
				islem_tutari :attributes.payroll_total,
				other_money_value : iif(len(attributes.other_payroll_total),'attributes.other_payroll_total',de('')),
				other_money :iif(len(attributes.basket_money),'attributes.basket_money',de('')),
				islem_belge_no : attributes.payroll_no,
				from_cmp_id : iif(attributes.member_type eq "partner",'attributes.company_id',de('')),
				from_consumer_id : iif(attributes.member_type eq "consumer",'attributes.consumer_id',de('')),
				from_employee_id : iif(attributes.member_type eq "employee",'attributes.employee_id',de('')),
				to_cash_id :listfirst(form.cash_id,';'),
				due_date : attributes.pyrll_avg_duedate,
				currency_multiplier : currency_multiplier,
				islem_detay : 'ÇEK GİRİŞ BORDROSU',
				acc_type_id : attributes.acc_type_id,
				action_detail : attributes.action_detail,
				project_id : attributes.project_id,
				special_definition_id : iif((isdefined("attributes.special_definition_id") and len(attributes.special_definition_id)),'attributes.special_definition_id',de('')),
				assetp_id : iif((isdefined("attributes.asset_id") and len(attributes.asset_id) and len(attributes.asset_name)),'attributes.asset_id',de('')),
				to_branch_id : branch_id_info,
				rate2:paper_currency_multiplier
				);
		}
	}
	else
	{
		if(attributes.payroll_acc_cari_cheque_based eq 1) /*bordro kaydedilirken cari-muhasebe hareketleri çek bazında yapılmış ise*/
			{
			for(che_q=1;che_q lte listlen(old_cheque_list);che_q=che_q+1) /*her bir cek icin olusturulmus cari hareket siliniyor*/
				cari_sil(action_id:listgetat(old_cheque_list,che_q,','),action_table:'CHEQUE',process_type:form.old_process_type,payroll_id :attributes.id);	
			}
		else /*bordro bazında cari hareket siliniyor*/
			cari_sil(action_id:attributes.id,action_table:'PAYROLL',process_type:form.old_process_type);
	}
	if(is_account eq 1)
	{
		if(is_cheque_based_acc neq 1)	/*standart muhasebe islemleri yapılıyor*/
		{
			GET_ACC_CODE=cfquery(datasource:"#dsn2#", sqlstring:"SELECT A_CHEQUE_ACC_CODE FROM CASH WHERE CASH_ID=#listfirst(form.cash_id,';')#");
			borc_tutarlar = '';
			borc_hesaplar = '';
			other_currency_borc_list= '';
			other_amount_borc_list= '';
			satir_detay_list = ArrayNew(2);
			for(i=1; i lte attributes.record_num; i=i+1)
			{
				if (isdefined("attributes.row_kontrol#i#") and evaluate("attributes.row_kontrol#i#"))
				{
					if(evaluate("attributes.currency_id#i#") neq session.ep.money)
						borc_tutarlar = listappend(borc_tutarlar,evaluate("attributes.cheque_system_currency_value#i#"),',');
					else
						borc_tutarlar=listappend(borc_tutarlar,evaluate("attributes.cheque_value#i#"),',');
		
					other_currency_borc_list = listappend(other_currency_borc_list,listgetat(form.cash_id,3,';'),',');
					other_amount_borc_list =  listappend(other_amount_borc_list,evaluate("attributes.cheque_value#i#"),',');
					borc_hesaplar=listappend(borc_hesaplar,GET_ACC_CODE.A_CHEQUE_ACC_CODE,',');
					
					if (is_account_group neq 1)
					{
						if (attributes.x_detail_acc_card eq 1) //detaylı muhasebe seçilmişse çek bilgilerini yazıyoruz
							satir_detay_list[1][listlen(borc_tutarlar)]='Ç.G.B.:#attributes.payroll_no#:#evaluate("attributes.bank_name#i#")#:#evaluate("attributes.bank_branch_name#i#")#:#evaluate("attributes.account_no#i#")#'; //satır acıklamaları borc acıklama aray e set edilir.
						else if (isDefined("attributes.action_detail") and len(attributes.action_detail))
							satir_detay_list[1][listlen(borc_tutarlar)] = ' #evaluate("attributes.cheque_no#i#")# - #attributes.company_name# - #attributes.action_detail#';
						else
							satir_detay_list[1][listlen(borc_tutarlar)] = ' #evaluate("attributes.cheque_no#i#")# - #attributes.company_name# - ÇEK GİRİŞ İŞLEMİ';					
					}
					else
					{
						if (attributes.x_detail_acc_card eq 1) //detaylı muhasebe seçilmişse çek bilgilerini yazıyoruz
							satir_detay_list[1][listlen(borc_tutarlar)]='Ç.G.B.:#attributes.payroll_no#:#evaluate("attributes.bank_name#i#")#:#evaluate("attributes.bank_branch_name#i#")#:#evaluate("attributes.account_no#i#")#'; //satır acıklamaları borc acıklama aray e set edilir.
						else if (isDefined("attributes.action_detail") and len(attributes.action_detail))
							satir_detay_list[1][listlen(borc_tutarlar)] = ' #attributes.company_name# - #attributes.action_detail#';
						else
							satir_detay_list[1][listlen(borc_tutarlar)] = ' #attributes.company_name# - ÇEK GİRİŞ İŞLEMİ';	
					}
				}
			}
			if(isDefined("attributes.action_detail") and len(attributes.action_detail))
				satir_detay_list[2][1] = ' #attributes.company_name# - #attributes.action_detail#';
			else
				satir_detay_list[2][1] = ' #attributes.company_name# - ÇEK GİRİŞ İŞLEMİ';		
							
			muhasebeci (
				action_id:attributes.id,
				workcube_process_type:process_type,
				workcube_old_process_type :form.old_process_type,
				action_table :'PAYROLL',
				account_card_type:13,
				islem_tarihi:attributes.PAYROLL_REVENUE_DATE,
				borc_hesaplar: borc_hesaplar,
				borc_tutarlar: borc_tutarlar,
				company_id : iif(attributes.member_type eq "partner",'attributes.company_id',de('')),
				consumer_id : iif(attributes.member_type eq "consumer",'attributes.consumer_id',de('')),
				employee_id : iif(attributes.member_type eq "employee",'attributes.employee_id',de('')),
				other_amount_borc : other_amount_borc_list,
				other_currency_borc :other_currency_borc_list,
				alacak_hesaplar: acc,
				alacak_tutarlar: attributes.payroll_total,
				other_amount_alacak : iif(len(attributes.other_payroll_total),'attributes.other_payroll_total',de('')),
				other_currency_alacak : iif(len(form.basket_money),'form.basket_money',de('')),
				fis_detay:'ÇEK GİRİŞ İŞLEMİ',
				fis_satir_detay:satir_detay_list,
				currency_multiplier : currency_multiplier,
				belge_no : form.payroll_no,
				to_branch_id : branch_id_info,
				workcube_process_cat : form.process_cat,
				acc_project_id : attributes.project_id,
				is_account_group : is_account_group
			);
		}
		else		/*e-deftere uygun muhasebe islemleri yapılıyor*/
		{
			GET_ACC_CODE=cfquery(datasource:"#dsn2#", sqlstring:"SELECT A_CHEQUE_ACC_CODE FROM CASH WHERE CASH_ID=#listfirst(form.cash_id,';')#");
			// tum muhasebe kayıtlari silinir sonra yaniden eklenir.
			muhasebe_sil(action_id:attributes.id,action_table:'PAYROLL',process_type:form.old_process_type,belge_no:attributes.payroll_no);
			
			satir_detay_list = ArrayNew(2);
			for(kk=1; kk lte get_cheques_last.recordcount; kk=kk+1)
			{
				if(get_cheques_last.CURRENCY_ID[kk] neq session.ep.money)
					borc_tutar = get_cheques_last.OTHER_MONEY_VALUE[kk];
				else
					borc_tutar = get_cheques_last.CHEQUE_VALUE[kk];
				
				if (is_account_group neq 1)
				{
					if(isDefined("attributes.action_detail") and len(attributes.action_detail))
						satir_detay_list[1][1] = ' #get_cheques_last.cheque_no[kk]# - #attributes.company_name# - #attributes.action_detail#';
					else
						satir_detay_list[1][1] = ' #get_cheques_last.cheque_no[kk]# - #attributes.company_name# - ÇEK GİRİŞ İŞLEMİ';					
				}
				else
				{
					if(isDefined("attributes.action_detail") and len(attributes.action_detail))
						satir_detay_list[1][1] = ' #attributes.company_name# - #attributes.action_detail#';
					else
						satir_detay_list[1][1] = ' #attributes.company_name# - ÇEK GİRİŞ İŞLEMİ';					
				}
				if(isDefined("attributes.action_detail") and len(attributes.action_detail))
					satir_detay_list[2][1] = ' #attributes.company_name# - #attributes.action_detail#';
				else
					satir_detay_list[2][1] = ' #attributes.company_name# - ÇEK GİRİŞ İŞLEMİ';		
								
				muhasebeci (
					action_id:attributes.id,
					action_row_id : get_cheques_last.CHEQUE_ID[kk],
					due_date :iif(len(get_cheques_last.CHEQUE_DUEDATE[kk]),'createodbcdatetime(get_cheques_last.CHEQUE_DUEDATE[kk])','attributes.pyrll_avg_duedate'),
					workcube_process_type:process_type,
					workcube_old_process_type :form.old_process_type,
					action_table :'PAYROLL',
					account_card_type:13,
					islem_tarihi:attributes.PAYROLL_REVENUE_DATE,
					borc_hesaplar: GET_ACC_CODE.A_CHEQUE_ACC_CODE,
					borc_tutarlar: borc_tutar,
					company_id : iif(attributes.member_type eq "partner",'attributes.company_id',de('')),
					consumer_id : iif(attributes.member_type eq "consumer",'attributes.consumer_id',de('')),
					employee_id : iif(attributes.member_type eq "employee",'attributes.employee_id',de('')),
					other_amount_borc : get_cheques_last.CHEQUE_VALUE[kk],
					other_currency_borc : listgetat(form.cash_id,3,';'),
					alacak_hesaplar: acc,
					alacak_tutarlar: borc_tutar,
					other_amount_alacak : get_cheques_last.OTHER_MONEY_VALUE[kk]/paper_currency_multiplier,
					other_currency_alacak : iif(len(form.basket_money),'form.basket_money',de('')),
					fis_detay:'ÇEK GİRİŞ İŞLEMİ',
					fis_satir_detay:satir_detay_list,
					currency_multiplier : currency_multiplier,
					belge_no : get_cheques_last.CHEQUE_NO[kk],
					to_branch_id : branch_id_info,
					workcube_process_cat : form.process_cat,
					acc_project_id : attributes.project_id,
					is_account_group : is_account_group
				);		
			}
		}
	}
	else
	{
		muhasebe_sil(action_id:attributes.id,action_table:'PAYROLL',process_type:form.old_process_type,belge_no:attributes.payroll_no);
	}
</cfscript>
