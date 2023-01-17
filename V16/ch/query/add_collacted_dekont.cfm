<cfif form.active_period neq session.ep.period_id>
	<script type="text/javascript">
		alert("<cf_get_lang_main no='1659.İşlem Yapmak İstediğiniz Muhasebe Dönemi ile Aktif Muhasebe Döneminiz Farklı Muhasebe Döneminizi Kontrol Ediniz'>!");
		history.back();
	</script>
	<cfabort>
</cfif>
<cfquery name="get_process_type" datasource="#dsn3#">
	SELECT PROCESS_TYPE,IS_CARI,IS_ACCOUNT,ACTION_FILE_NAME,ACTION_FILE_FROM_TEMPLATE,IS_ACCOUNT_GROUP FROM SETUP_PROCESS_CAT WHERE PROCESS_CAT_ID = #form.process_cat#
</cfquery>
<cfscript>
	process_type = get_process_type.process_type;
	comp_id_list= '';
	cons_id_list='';
	account_group = get_process_type.is_account_group;
</cfscript>
<cf_date tarih='attributes.action_date'>
<cfscript>
	for(r=1; r lte attributes.record_num; r=r+1)
	{
		if(evaluate('attributes.row_kontrol#r#') eq 1)
		{
			'attributes.action_value#r#' = filterNum(evaluate('attributes.action_value#r#'));
			'attributes.action_value_other#r#' = filterNum(evaluate('attributes.action_value_other#r#'));
			'attributes.system_amount#r#' = filterNum(evaluate('attributes.system_amount#r#'));
		}
	}
	for(k=1; k lte attributes.kur_say; k=k+1)
	{
		'attributes.txt_rate2_#k#' = filterNum(evaluate('attributes.txt_rate2_#k#'),session.ep.our_company_info.rate_round_num);
		'attributes.txt_rate1_#k#' = filterNum(evaluate('attributes.txt_rate1_#k#'),session.ep.our_company_info.rate_round_num);
	}
</cfscript>
<cfif session.ep.isBranchAuthorization>
	<cfset attributes.acc_branch_id = listgetat(session.ep.user_location,2,'-')>
</cfif>
<cf_papers paper_type="debit_claim">
<cflock name="#createUUID()#" timeout="60">			
	<cftransaction>
		<cfquery name="add_cari_actions_multi" datasource="#dsn2#" result="MAX_ID">
			INSERT INTO
				CARI_ACTIONS_MULTI
				(
					PROCESS_CAT,
					ACTION_TYPE_ID,
					ACTION_DATE,
					IS_ACCOUNT,
					IS_ACCOUNT_TYPE,
					RECORD_EMP,
					RECORD_IP,
					RECORD_DATE				
				)
				VALUES
				(
					#form.process_cat#,
					#process_type#,
					#attributes.action_date#,
					<cfif get_process_type.is_account eq 1>1,13,<cfelse>0,13,</cfif>
					#SESSION.EP.USERID#,
					'#CGI.REMOTE_ADDR#',
					#NOW()#				
				)
		</cfquery>
		<cfscript>
			currency_multiplier = '';
			if(isDefined('attributes.kur_say') and len(attributes.kur_say))
				for(mon=1;mon lte attributes.kur_say;mon=mon+1)
					if( evaluate("attributes.hidden_rd_money_#mon#") is session.ep.money2)
						currency_multiplier = evaluate('attributes.txt_rate2_#mon#/attributes.txt_rate1_#mon#');
		</cfscript>
		<cfset ACTION_CURRENCY_ID = session.ep.money>
		<cfif isdefined("attributes.record_num") and len(attributes.record_num)>
			<cfloop from="1" to="#attributes.record_num#" index="i">
				<cfif isdefined("attributes.row_kontrol#i#") and evaluate("attributes.row_kontrol#i#")>
					<cfscript>
						attributes.acc_type_id = '';
						"acc_type_id#i#" = '';
						if(listlen(evaluate("action_employee_id#i#"),'_') eq 2)
						{
							attributes.acc_type_id = listlast(evaluate("action_employee_id#i#"),'_');
							"acc_type_id#i#" = listlast(evaluate("action_employee_id#i#"),'_');
							"action_employee_id#i#" = listfirst(evaluate("action_employee_id#i#"),'_');
						}
						paper_currency_multiplier = '';
						if(isDefined('attributes.kur_say') and len(attributes.kur_say))
							for(mon=1;mon lte attributes.kur_say;mon=mon+1)
								if( evaluate("attributes.hidden_rd_money_#mon#") is listfirst(evaluate("attributes.money_id#i#"),';'))
									paper_currency_multiplier = evaluate('attributes.txt_rate2_#mon#/attributes.txt_rate1_#mon#');
					</cfscript>
					<cfset paper_number = paper_number + 1>
					<cfquery name="add_dekont" datasource="#dsn2#">
                  		INSERT INTO
							CARI_ACTIONS
							(
								MULTI_ACTION_ID,
								ACTION_NAME,
								ACTION_TYPE_ID,
								PROCESS_CAT,
								ACTION_VALUE,
								ACTION_CURRENCY_ID,
								OTHER_MONEY,
								PROJECT_ID,
								OTHER_CASH_ACT_VALUE,
								<cfif process_type eq 410 or process_type eq 45>
									TO_CMP_ID,								
									TO_CONSUMER_ID,
									TO_EMPLOYEE_ID,
								<cfelse>
									FROM_CMP_ID,								
									FROM_CONSUMER_ID,
									FROM_EMPLOYEE_ID,
								</cfif>
								ACTION_DETAIL,
								ACTION_ACCOUNT_CODE,
								ACTION_DATE,
								PAPER_NO,
								RECORD_EMP,
								RECORD_IP,		
								RECORD_DATE,
								SUBSCRIPTION_ID,
								EXPENSE_CENTER_ID,
								EXPENSE_ITEM_ID,
								INCOME_CENTER_ID,
								INCOME_ITEM_ID,
								ACC_DEPARTMENT_ID,
                                ACC_BRANCH_ID,
								ASSETP_ID,
								CONTRACT_ID,
                                ACC_TYPE_ID,
								RELATION_ACTION_TYPE_ID,
								RELATION_ACTION_ID
							)
							VALUES
							(
								#MAX_ID.IDENTITYCOL#,
								<cfif process_type eq 410>'#UCase(getLang("main",437))#'<cfelseif process_type eq 420>'#UCase(getLang("main",436))#'<cfelseif process_type eq 45>'#UCase(getLang("main",1483))#'<cfelseif process_type eq 46>'#UCase(getLang("main",1482))#'</cfif>,
								<cfif process_type eq 410>41<cfelseif process_type eq 420>42<cfelse>#process_type#</cfif>,
								0,
								#evaluate("attributes.action_value#i#")#,
								'#ACTION_CURRENCY_ID#',
								'#listfirst(evaluate("attributes.money_id#i#"),';')#',
								<cfif len(evaluate("attributes.project_head#i#")) and len(evaluate("attributes.project_id#i#"))>#evaluate("attributes.project_id#i#")#<cfelse>NULL</cfif>,
								#evaluate("attributes.action_value_other#i#")#,							
								<cfif len(evaluate("member_type#i#")) and evaluate("member_type#i#") eq 'partner' and len(evaluate("action_company_id#i#"))>#evaluate("action_company_id#i#")#,<cfelse>NULL,</cfif>
								<cfif len(evaluate("member_type#i#")) and evaluate("member_type#i#") eq 'consumer' and len(evaluate("action_consumer_id#i#"))>#evaluate("action_consumer_id#i#")#,<cfelse>NULL,</cfif>
								<cfif len(evaluate("member_type#i#")) and evaluate("member_type#i#") eq 'employee' and len(evaluate("action_employee_id#i#"))>#evaluate("action_employee_id#i#")#,<cfelse>NULL,</cfif>
								<cfif isDefined("attributes.action_detail#i#") and len(evaluate("attributes.action_detail#i#"))>'#wrk_eval("attributes.action_detail#i#")#',<cfelse>NULL,</cfif>
								<cfif isDefined("attributes.action_account_code#i#") and len(evaluate("attributes.action_account_code#i#"))>'#wrk_eval("attributes.action_account_code#i#")#',<cfelse>NULL,</cfif>
								#attributes.action_date#,
								<cfif isdefined("attributes.paper_number#i#") and len(evaluate("attributes.paper_number#i#"))>'#wrk_eval("attributes.paper_number#i#")#',<cfelse>NULL,</cfif>
								#SESSION.EP.USERID#,
								'#CGI.REMOTE_ADDR#',
								#NOW()#,	
								<cfif isDefined("attributes.subscription_id#i#") and len(evaluate("attributes.subscription_no#i#")) and len(evaluate("attributes.subscription_id#i#"))>#evaluate("attributes.subscription_id#i#")#<cfelse>NULL</cfif>,
								<cfif isDefined("attributes.expense_center_id#i#") and len(evaluate("attributes.expense_center_name#i#")) and len(evaluate("attributes.expense_center_id#i#"))>#evaluate("attributes.expense_center_id#i#")#<cfelse>NULL</cfif>,
								<cfif isDefined("attributes.expense_item_id#i#") and len(evaluate("attributes.expense_item_name#i#")) and len(evaluate("attributes.expense_item_id#i#"))>#evaluate("attributes.expense_item_id#i#")#<cfelse>NULL</cfif>,
								<cfif isDefined("attributes.income_center_id#i#") and len(evaluate("attributes.income_center_name#i#")) and len(evaluate("attributes.income_center_id#i#"))>#evaluate("attributes.income_center_id#i#")#<cfelse>NULL</cfif>,
								<cfif isDefined("attributes.income_item_id#i#") and len(evaluate("attributes.income_item_name#i#")) and len(evaluate("attributes.income_item_id#i#"))>#evaluate("attributes.income_item_id#i#")#<cfelse>NULL</cfif>,
								<cfif isdefined("attributes.acc_department_id") and len(attributes.acc_department_id)>#attributes.acc_department_id#<cfelse>NULL</cfif>,
                                <cfif isdefined("attributes.acc_branch_id") and len(attributes.acc_branch_id)>#attributes.acc_branch_id#<cfelse>NULL</cfif>,
								<cfif isDefined("attributes.asset_id#i#") and len(evaluate("attributes.asset_name#i#")) and len(evaluate("attributes.asset_id#i#"))>#evaluate("attributes.asset_id#i#")#<cfelse>NULL</cfif>,
								<cfif isDefined("attributes.contract_id#i#") and len(evaluate("attributes.contract_no#i#")) and len(evaluate("attributes.contract_id#i#"))>#evaluate("attributes.contract_id#i#")#<cfelse>NULL</cfif>,
                                <cfif isdefined("acc_type_id#i#") and len(evaluate("acc_type_id#i#"))>#evaluate("acc_type_id#i#")#<cfelse>NULL</cfif>,
								<cfif isDefined("attributes.related_action_type#i#") and len(evaluate("attributes.related_action_type#i#"))>#evaluate("attributes.related_action_type#i#")#<cfelse>NULL</cfif>,
                                <cfif isdefined("attributes.related_action_id#i#") and len(evaluate("attributes.related_action_id#i#"))>#evaluate("attributes.related_action_id#i#")#<cfelse>NULL</cfif>
							)
                    </cfquery>	
					<cfquery name="get_act_id" datasource="#dsn2#">
						SELECT MAX(ACTION_ID) AS ACTION_ID FROM CARI_ACTIONS
					</cfquery>
					<cfscript>
						_branch_id='';
						from_cmp_id = '';
						from_consumer_id = '';
						from_employee_id = '';
						if (isdefined("attributes.acc_branch_id") and len(attributes.acc_branch_id))
							_branch_id = attributes.acc_branch_id;
						else
							_branch_id = listgetat(session.ep.user_location,2,'-');
						if (len(evaluate("action_company_id#i#")) and evaluate("member_type#i#") eq 'partner')
							from_cmp_id = evaluate("action_company_id#i#");
						else if (len(evaluate("action_consumer_id#i#")) and evaluate("member_type#i#") eq 'consumer') 
							from_consumer_id = evaluate("action_consumer_id#i#");
						else
							from_employee_id = evaluate("action_employee_id#i#");
						
						if(isDefined("attributes.expense_center_id#i#"))
							exp_center_id = evaluate("expense_center_id#i#");
						else
							exp_center_id = '';

						if(isDefined("attributes.subscription_id#i#") and len(evaluate("attributes.subscription_no#i#")) and len(evaluate("attributes.subscription_id#i#")))
							subscription_id = evaluate("subscription_id#i#");
						else
							subscription_id = '';
						
						if(isDefined("attributes.expense_item_id#i#"))
							exp_item_id = evaluate("expense_item_id#i#");
						else
							exp_item_id = '';
							
						if(isDefined("attributes.income_center_id#i#"))
							inc_center_id = evaluate("income_center_id#i#");
						else
							inc_center_id = '';
						
						if(isDefined("attributes.income_item_id#i#"))
							inc_item_id = evaluate("income_item_id#i#");
						else
							inc_item_id = '';
							
						if(isDefined("attributes.asset_id#i#") and len(evaluate("attributes.asset_name#i#")) and len(evaluate("attributes.asset_id#i#")))
							asset_id = evaluate("asset_id#i#");
						else
							asset_id = '';
						
								
						if (process_type eq 410 or process_type eq 45)
						{
							if(process_type eq 410)
							{
								row_detail_ = UCase(getLang('main',437)); //BORÇ DEKONTU
								row_detail_2 = UCase(getLang('main',2713)); //BORÇ DEKONTU MASRAFI
								act_value_2 = '';
								act_value_other = evaluate("attributes.action_value_other#i#");
								pro_type = 41;
							}
							else
							{
								row_detail_ = UCase(getLang('main',1483)); //BORÇ KUR DEĞERLEME DEKONTU
								row_detail_2 = UCase(getLang('main',2714)); //BORÇ KUR DEĞERLEME DEKONTU MASRAFI
								act_value_2 = 0;
								act_value_other = 0;
								pro_type = 45;
							}
							if(get_process_type.is_cari eq 1)
							{
								carici(
									action_id : get_act_id.action_id,
									islem_belge_no : evaluate("attributes.paper_number#i#"),
									process_cat : form.process_cat,
									workcube_process_type : pro_type,
									action_table : 'CARI_ACTIONS',
									islem_tutari : evaluate("attributes.action_value#i#"),
									action_currency : session.ep.money,
									other_money_value : act_value_other,
									other_money : listfirst(evaluate("attributes.money_id#i#"),';'),
									islem_tarihi : attributes.action_date,
									islem_detay : row_detail_,
									action_detail : evaluate("attributes.action_detail#i#"),
									to_cmp_id : from_cmp_id,
									subscription_id : iif((isdefined("subscription_id") and len(subscription_id)),subscription_id,de('')),
									to_consumer_id : from_consumer_id,
									to_employee_id : from_employee_id,			
									currency_multiplier : currency_multiplier,
									account_card_type : 13,
									acc_type_id : evaluate("acc_type_id#i#"),
									project_id : evaluate("attributes.project_id#i#"),
									to_branch_id : _branch_id,
									action_value2 : act_value_2,
									assetp_id : asset_id,
									rate2:paper_currency_multiplier
									);
							}
							if(len(inc_center_id) and len(inc_item_id))
							{
								if(len(evaluate("attributes.action_detail#i#")))
									action_detail_ = evaluate("attributes.action_detail#i#");
								else
								{
									action_detail_ = row_detail_2;
								}
								butceci(
									action_id : get_act_id.action_id,
									muhasebe_db : dsn2,
									is_income_expense : true,
									process_type : pro_type,
									nettotal : evaluate("attributes.action_value#i#"),
									other_money_value : evaluate("attributes.action_value_other#i#"),
									action_currency : listfirst(evaluate("attributes.money_id#i#"),';'),
									project_id : evaluate("attributes.project_id#i#"),
									paper_no : evaluate("attributes.paper_number#i#"),
									currency_multiplier : currency_multiplier,
									expense_date : attributes.action_date,
									expense_center_id : inc_center_id,
									expense_item_id : inc_item_id,
									detail : action_detail_,
									company_id : from_cmp_id,
									consumer_id : from_consumer_id,
									employee_id : from_employee_id,
									branch_id : _branch_id,
									insert_type : 1
								);
							}
						}
						else
						{
							if(isDefined("attributes.subscription_id#i#") and len(evaluate("attributes.subscription_no#i#")) and len(evaluate("attributes.subscription_id#i#")))
                                subscription_id = evaluate("subscription_id#i#");
                            else
                                subscription_id = '';
							if(process_type eq 420)
							{
								row_detail_ =  UCase(getLang('main',436));//ALACAK DEKONTU
								row_detail_2 =  UCase(getLang('main',2715));//ALACAK DEKONTU MASRAFI
								act_value_2 = '';
								act_value_other = evaluate("attributes.action_value_other#i#");
								pro_type = 42;
							}
							else
							{
								row_detail_ =  UCase(getLang('main',1482));//ALACAK KUR DEĞERLEME DEKONTU
								row_detail_2 = UCase(getLang('main',2716));//ALACAK KUR DEĞERLEME DEKONTU MASRAFI
								act_value_2 = 0;
								act_value_other = 0;
								pro_type = 46;
							}
							if(get_process_type.is_cari eq 1)
							{								
								carici(
									action_id : get_act_id.action_id,
									islem_belge_no : evaluate("attributes.paper_number#i#"),
									process_cat : form.process_cat,
									workcube_process_type : pro_type,
									action_table : 'CARI_ACTIONS',
									islem_tutari : evaluate("attributes.action_value#i#"),
									action_currency : session.ep.money,
									other_money_value : act_value_other,
									other_money : listfirst(evaluate("attributes.money_id#i#"),';'),
									islem_tarihi : attributes.action_date,
									islem_detay : row_detail_,
									action_detail : evaluate("attributes.action_detail#i#"),
									from_cmp_id : from_cmp_id,
									from_consumer_id : from_consumer_id,
									subscription_id : iif((isdefined("subscription_id") and len(subscription_id)),subscription_id,de('')),
									from_employee_id : from_employee_id,			
									currency_multiplier : currency_multiplier,
									account_card_type : 13,
									acc_type_id : evaluate("acc_type_id#i#"),
									project_id : evaluate("attributes.project_id#i#"),
									from_branch_id : _branch_id,
									action_value2 : act_value_2,
									assetp_id : asset_id,
									rate2:paper_currency_multiplier
									);
							}
							if(len(exp_center_id) and len(exp_item_id))
							{
								if(len(evaluate("attributes.action_detail#i#")))
									action_detail_ = evaluate("attributes.action_detail#i#");
								else
								{
									action_detail_ = row_detail_2;
								}
								butceci(
									action_id : get_act_id.action_id,
									muhasebe_db : dsn2,
									is_income_expense : false,
									process_type : pro_type,
									nettotal : evaluate("attributes.action_value#i#"),
									other_money_value : evaluate("attributes.action_value_other#i#"),
									action_currency : listfirst(evaluate("attributes.money_id#i#"),';'),
									project_id : evaluate("attributes.project_id#i#"),
									paper_no : evaluate("attributes.paper_number#i#"),
									currency_multiplier : currency_multiplier,
									expense_date : attributes.action_date,
									expense_center_id : exp_center_id,
									expense_item_id : exp_item_id,
									detail : action_detail_,
									company_id : from_cmp_id,
									consumer_id : from_consumer_id,
									employee_id : from_employee_id,
									branch_id : _branch_id,
									insert_type : 1
								);
							}
						}
					</cfscript>
				</cfif>
			</cfloop>
		</cfif>
		<cfscript>
			if(get_process_type.is_account eq 1)
			{
				borc_hesap_list='';
				alacak_hesap_list='';
				borc_tutar_list ='';
				alacak_tutar_list = '';
				doviz_tutar_borc = '';
				doviz_tutar_alacak = '';
				doviz_currency_borc = '';
				doviz_currency_alacak = '';
				acc_project_list_borc = '';
				acc_project_list_alacak = '';
				satir_detay_list = ArrayNew(2);
				if(isdefined('attributes.acc_department_id') and len(attributes.acc_department_id))
					acc_department_id = attributes.acc_department_id;
				else
					acc_department_id = '';
				if (process_type eq 410 or process_type eq 45)
				{
					if( isdefined("attributes.record_num") and len(attributes.record_num) )
					{
						if(process_type eq 45)
							detail_ = UCase(getLang('main',2717));//BORÇ KUR DEĞERLEME
						else
							detail_ = UCase(getLang('main',1773));//TOPLU BORÇ DEKONTU
						for(k=1; k lte attributes.record_num; k=k+1)
							if( isdefined("attributes.row_kontrol#k#") and evaluate("attributes.row_kontrol#k#") eq 1 and len(evaluate("attributes.action_account_code#k#")))
							{
								if(len(evaluate("action_company_id#k#")) and len(evaluate("member_type#k#")) and evaluate("member_type#k#") eq 'partner')
									my_acc_result = GET_COMPANY_PERIOD(evaluate("action_company_id#k#"));
								else if(len(evaluate("action_consumer_id#k#")) and len(evaluate("member_type#k#")) and evaluate("member_type#k#") eq 'consumer')
									my_acc_result = GET_CONSUMER_PERIOD(evaluate("action_consumer_id#k#"));
								else
									my_acc_result = GET_EMPLOYEE_PERIOD(evaluate("action_employee_id#k#"),evaluate("acc_type_id#k#"));
								
								alacak_hesap_list = listappend(alacak_hesap_list,evaluate("attributes.action_account_code#k#"),',');
								borc_hesap_list = listappend(borc_hesap_list,my_acc_result,',');
								
								borc_tutar_list = listappend(borc_tutar_list,evaluate("attributes.action_value#k#"),',');
								doviz_tutar_borc = listappend(doviz_tutar_borc,evaluate("attributes.action_value_other#k#"),',');
								doviz_currency_borc = listappend(doviz_currency_borc,listfirst(evaluate("attributes.money_id#k#"),';'),',');
								if(account_group neq 1)
								{
									if (len(evaluate("attributes.action_detail#k#")))
										satir_detay_list[1][listlen(borc_tutar_list)]='#evaluate("attributes.comp_name#k#")# - #evaluate("attributes.action_detail#k#")#';
									else
									{
										if(process_type eq 45)
											satir_detay_list[1][listlen(borc_tutar_list)]='#evaluate("attributes.comp_name#k#")# - ' & UCase(getLang('main',2717));
										else
											satir_detay_list[1][listlen(borc_tutar_list)]='#evaluate("attributes.comp_name#k#")# - ' & UCase(getLang('main',1773));
									}
								}
								else
									satir_detay_list[1][listlen(borc_tutar_list)] = detail_;
									
								alacak_tutar_list = listappend(alacak_tutar_list,evaluate("attributes.action_value#k#"));
								doviz_tutar_alacak = listappend(doviz_tutar_alacak,evaluate("attributes.action_value_other#k#"),',');
								doviz_currency_alacak = listappend(doviz_currency_alacak,listfirst(evaluate("attributes.money_id#k#"),';'),',');
								
								if(account_group neq 1)
								{
									if (len(evaluate("attributes.action_detail#k#")))
										satir_detay_list[2][listlen(alacak_tutar_list)]='#evaluate("attributes.comp_name#k#")# - #evaluate("attributes.action_detail#k#")#';
									else
									{
										if(process_type eq 45)
											satir_detay_list[2][listlen(alacak_tutar_list)]='#evaluate("attributes.comp_name#k#")# - ' & UCase(getLang('main',2717));
										else
											satir_detay_list[2][listlen(alacak_tutar_list)]='#evaluate("attributes.comp_name#k#")# - ' & UCase(getLang('main',1773));
									}
								}
								else
									satir_detay_list[2][listlen(alacak_tutar_list)] = detail_;
								/* acc_project_id muhasebeciye kaydediliyor */
								if(isdefined("attributes.project_id#k#") and len(evaluate("attributes.project_id#k#")) and len(evaluate("attributes.project_head#k#")))
								{
									acc_project_list_alacak = listappend(acc_project_list_alacak,evaluate("attributes.project_id#k#"),',');
									acc_project_list_borc = listappend(acc_project_list_borc,evaluate("attributes.project_id#k#"),',');
								}
								else
								{
									acc_project_list_alacak = listappend(acc_project_list_alacak,0,',');
									acc_project_list_borc = listappend(acc_project_list_borc,0,',');
								}	
							}
							muhasebeci (
								action_id: MAX_ID.IDENTITYCOL,
								workcube_process_type: process_type,
								workcube_process_cat:form.process_cat,
								account_card_type: 13,
								acc_department_id:acc_department_id,
								islem_tarihi: attributes.action_date,
								fis_satir_detay: satir_detay_list,
								borc_hesaplar: borc_hesap_list,
								borc_tutarlar: borc_tutar_list,
								other_amount_borc : doviz_tutar_borc,
								other_currency_borc : doviz_currency_borc,
								alacak_hesaplar: alacak_hesap_list,
								alacak_tutarlar: alacak_tutar_list,
								other_amount_alacak : doviz_tutar_alacak,
								other_currency_alacak : doviz_currency_alacak,
								currency_multiplier : currency_multiplier,
								to_branch_id : _branch_id,
								fis_detay: detail_,
								acc_project_list_alacak : acc_project_list_alacak,
								acc_project_list_borc : acc_project_list_borc,
								is_account_group : account_group
							);
					}
				}
				else
				{
					if( isdefined("attributes.record_num") and len(attributes.record_num) )
					{
						if(process_type eq 46)
							detail_ = UCase(getLang('main',2718));//ALACAK KUR DEĞERLEME
						else
							detail_ = UCase(getLang('main',1774));//TOPLU ALACAK DEKONTU
						for(k=1; k lte attributes.record_num; k=k+1)
							if( isdefined("attributes.row_kontrol#k#") and evaluate("attributes.row_kontrol#k#") eq 1 and len(evaluate("attributes.action_account_code#k#")))
							{
								if(len(evaluate("action_company_id#k#")) and len(evaluate("member_type#k#")) and evaluate("member_type#k#") eq 'partner')
									my_acc_result = GET_COMPANY_PERIOD(evaluate("action_company_id#k#"));
								else if(len(evaluate("action_consumer_id#k#")) and len(evaluate("member_type#k#")) and evaluate("member_type#k#") eq 'consumer')
									my_acc_result = GET_CONSUMER_PERIOD(evaluate("action_consumer_id#k#"));
								else
									my_acc_result = GET_EMPLOYEE_PERIOD(evaluate("action_employee_id#k#"),evaluate("acc_type_id#k#"));
								
								borc_hesap_list = listappend(borc_hesap_list,evaluate("attributes.action_account_code#k#"),',');
								alacak_hesap_list = listappend(alacak_hesap_list,my_acc_result,',');
								borc_tutar_list = listappend(borc_tutar_list,evaluate("attributes.action_value#k#"),',');
								doviz_tutar_borc = listappend(doviz_tutar_borc,evaluate("attributes.action_value_other#k#"),',');
								doviz_currency_borc = listappend(doviz_currency_borc,listfirst(evaluate("attributes.money_id#k#"),';'),',');
								if(account_group neq 1)
								{
									if (len(evaluate("attributes.action_detail#k#")))
										satir_detay_list[1][listlen(borc_tutar_list)]='#evaluate("attributes.comp_name#k#")# - #evaluate("attributes.action_detail#k#")#';
									else
									{
										if(process_type eq 46)
											satir_detay_list[1][listlen(borc_tutar_list)]='#evaluate("attributes.comp_name#k#")# - ' & UCase(getLang('main',2718));
										else
											satir_detay_list[1][listlen(borc_tutar_list)]='#evaluate("attributes.comp_name#k#")# - ' & UCase(getLang('main',1774));
									}
								}
								else
									satir_detay_list[1][listlen(borc_tutar_list)]=detail_;
									
								alacak_tutar_list = listappend(alacak_tutar_list,evaluate("attributes.action_value#k#"));
								doviz_tutar_alacak = listappend(doviz_tutar_alacak,evaluate("attributes.action_value_other#k#"),',');
								doviz_currency_alacak = listappend(doviz_currency_alacak,listfirst(evaluate("attributes.money_id#k#"),';'),',');
								
								if(account_group neq 1)
								{
									if (len(evaluate("attributes.action_detail#k#")))
										satir_detay_list[2][listlen(alacak_tutar_list)]='#evaluate("attributes.comp_name#k#")# - #evaluate("attributes.action_detail#k#")#';
									else
									{									
										if(process_type eq 46)
											satir_detay_list[2][listlen(alacak_tutar_list)]='#evaluate("attributes.comp_name#k#")# - ' & UCase(getLang('main',2718));
										else
											satir_detay_list[2][listlen(alacak_tutar_list)]='#evaluate("attributes.comp_name#k#")# - ' & UCase(getLang('main',1774));
									}
								}
								else
									satir_detay_list[2][listlen(alacak_tutar_list)]=detail_;
								/* acc_project_id muhasebeciye kaydediliyor */
								if(isdefined("attributes.project_id#k#") and len(evaluate("attributes.project_id#k#")) and len(evaluate("attributes.project_head#k#")))
								{
									acc_project_list_alacak = listappend(acc_project_list_alacak,evaluate("attributes.project_id#k#"),',');
									acc_project_list_borc = listappend(acc_project_list_borc,evaluate("attributes.project_id#k#"),',');
								}
								else
								{
									acc_project_list_alacak = listappend(acc_project_list_alacak,0,',');
									acc_project_list_borc = listappend(acc_project_list_borc,0,',');
								}	
							}
							muhasebeci (
								action_id: MAX_ID.IDENTITYCOL,
								workcube_process_type: process_type,
								workcube_process_cat:form.process_cat,
								account_card_type: 13,
								acc_department_id:acc_department_id,
								islem_tarihi: attributes.action_date,
								fis_satir_detay: satir_detay_list,
								borc_hesaplar: borc_hesap_list,
								borc_tutarlar: borc_tutar_list,
								other_amount_borc : doviz_tutar_borc,
								other_currency_borc : doviz_currency_borc,
								alacak_hesaplar: alacak_hesap_list,
								alacak_tutarlar: alacak_tutar_list,
								other_amount_alacak : doviz_tutar_alacak,
								other_currency_alacak : doviz_currency_alacak,
								currency_multiplier : currency_multiplier,
								from_branch_id : _branch_id,
								fis_detay: detail_,
								acc_project_list_alacak : acc_project_list_alacak,
								acc_project_list_borc : acc_project_list_borc,
								is_account_group : account_group
							);
					}
				}
			}
		</cfscript>
		<cfloop from="1" to="#attributes.kur_say#" index="r">
			<cfquery name="ADD_ACTION_MONEY" datasource="#dsn2#">
				INSERT INTO 
					CARI_ACTION_MULTI_MONEY 
					(
						ACTION_ID,
						MONEY_TYPE,
						RATE2,
						RATE1,
						IS_SELECTED
					)
					VALUES
					(
						#MAX_ID.IDENTITYCOL#,
						'#wrk_eval("attributes.hidden_rd_money_#r#")#',
						#evaluate("attributes.txt_rate2_#r#")#,
						#evaluate("attributes.txt_rate1_#r#")#,
						<cfif evaluate("attributes.hidden_rd_money_#r#") is listfirst(attributes.rd_money,',')>1<cfelse>0</cfif>
					)
			</cfquery>
		</cfloop>
		<!--- Belge No Guncelleme --->
		<cfquery name="UPD_GENERAL_PAPERS" datasource="#DSN2#">
			UPDATE 
				#dsn3_alias#.GENERAL_PAPERS
			SET
				DEBIT_CLAIM_NUMBER = #paper_number-1#
			WHERE
				DEBIT_CLAIM_NUMBER IS NOT NULL
		</cfquery>
		<cfif len(get_process_type.action_file_name)>
			<cf_workcube_process_cat 
				process_cat="#form.process_cat#"
				action_id = #MAX_ID.IDENTITYCOL#
				is_action_file = 1
				action_file_name='#get_process_type.action_file_name#'
				action_page='#request.self#?fuseaction=#listGetAt(fuseaction,1,'.')#.form_add_debit_claim_note&event=updMulti&multi_id=#MAX_ID.IDENTITYCOL#'
				action_db_type = '#dsn2#'
				is_template_action_file = '#get_process_type.action_file_from_template#'>
		</cfif>
	</cftransaction>
</cflock>
<cfset attributes.actionId=MAX_ID.IDENTITYCOL>
<script type="text/javascript">	
	window.location.href='<cfoutput>#request.self#?fuseaction=#nextEvent##MAX_ID.IDENTITYCOL#</cfoutput>';
</script>
