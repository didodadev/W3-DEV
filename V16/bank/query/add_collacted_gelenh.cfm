<cfif form.active_period neq session.ep.period_id>
	<script type="text/javascript">
		alert("<cf_get_lang_main no='1659.İşlem Yapmak İstediğiniz Muhasebe Dönemi ile Aktif Muhasebe Döneminiz Farklı Muhasebe Döneminizi Kontrol Ediniz'>!");
		history.back();
	</script>
	<cfabort>
</cfif>
<!--- toplu gelen havale process_type --->
<cfquery name="get_process_type" datasource="#dsn3#">
	SELECT 
		PROCESS_TYPE,
		IS_CARI,
		IS_ACCOUNT,
		IS_ACCOUNT_GROUP,
		ACTION_FILE_NAME,
		ACTION_FILE_FROM_TEMPLATE,
        MULTI_TYPE
	FROM 
		SETUP_PROCESS_CAT 
	WHERE 
		PROCESS_CAT_ID = #form.process_cat#
</cfquery>
<cfscript>
	process_type = get_process_type.process_type;
	multi_type = get_process_type.multi_type;
	is_account_group = get_process_type.is_account_group;
	comp_id_list= '';
	cons_id_list='';
</cfscript>
<cf_date tarih='attributes.action_date'>
<cfscript>
	for(r=1; r lte attributes.record_num; r=r+1)
	{
		if(evaluate('attributes.row_kontrol#r#') eq 1)
		{
			'attributes.action_value#r#' = evaluate('attributes.action_value#r#');
			'attributes.action_value_other#r#' = evaluate('attributes.action_value_other#r#');
			'attributes.system_amount#r#' = evaluate('attributes.system_amount#r#');
			'attributes.expense_amount#r#' = evaluate('attributes.expense_amount#r#');
		}
	}
	for(k=1; k lte attributes.kur_say; k=k+1)
	{
		'attributes.txt_rate2_#k#' = filterNum(evaluate('attributes.txt_rate2_#k#'),session.ep.our_company_info.rate_round_num);
		'attributes.txt_rate1_#k#' = filterNum(evaluate('attributes.txt_rate1_#k#'),session.ep.our_company_info.rate_round_num);
	}
	if(isdefined("attributes.branch_id") and len(attributes.branch_id))
		branch_id_info = attributes.branch_id;
	else
		branch_id_info = listgetat(session.ep.user_location,2,'-');
</cfscript>
<cf_papers paper_type="incoming_transfer">
<cflock name="#createUUID()#" timeout="60">			
	<cftransaction>
		<cfquery name="add_bank_actions_multi" datasource="#dsn2#" result="MAX_ID">
			INSERT INTO
				BANK_ACTIONS_MULTI
				(
					PROCESS_CAT,
					ACTION_TYPE_ID,
					TO_ACCOUNT_ID,
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
					#attributes.account_id#,
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
				{
					if( evaluate("attributes.hidden_rd_money_#mon#") is session.ep.money2)
						currency_multiplier = evaluate('attributes.txt_rate2_#mon#/attributes.txt_rate1_#mon#');
					if(evaluate("attributes.hidden_rd_money_#mon#") eq attributes.currency_id)
						dovizli_islem_multiplier = evaluate('attributes.txt_rate2_#mon#/attributes.txt_rate1_#mon#');
				}
		</cfscript>
		<cfif isdefined("attributes.record_num") and len(attributes.record_num)>
			<cfloop from="1" to="#attributes.record_num#" index="i">
				<cfif isdefined("attributes.row_kontrol#i#") and evaluate("attributes.row_kontrol#i#")>
					<!--- gelen banka talimati ve toplu gelen havale process type ları karsılastırılıyor --->
					<cfif isDefined("attributes.bank_order_id#i#") and len(evaluate("attributes.bank_order_id#i#"))>
						<cfquery name="get_bank_order_process_type" datasource="#dsn2#">
							SELECT 
								PROCESS_TYPE,
								IS_CARI,
								IS_ACCOUNT
							 FROM 
								#dsn3_alias#.SETUP_PROCESS_CAT 
							WHERE 
								PROCESS_CAT_ID = #evaluate("attributes.bank_order_process_cat#i#")#
						</cfquery>
						<cfset bank_order_process_type = get_bank_order_process_type.PROCESS_TYPE>
						<cfset bank_order_cari = get_bank_order_process_type.IS_CARI>
						<cfset bank_order_account = get_bank_order_process_type.IS_ACCOUNT>
						<!--- Eğer banka talimatında cari işlem yapılmışsa havalede yapılmamalı, 
						veya banka talimatında muhasebe işlemi yapılmışsa havalede de bu işlemi kapatmak için muhasebe işlemi yapılmalı. Bunlar için kontrol yapılıyor.--->
						<cfif ((bank_order_cari eq 1) and (get_process_type.is_cari eq 1)) or ((bank_order_account eq 1) and (get_process_type.is_account eq 0))>
							<script type="text/javascript">
								alert("<cf_get_lang no ='399.İşlem Kategorilerinizi Kontrol Ediniz'>!");
								window.location.href='<cfoutput>#cgi.referer#</cfoutput>';
							</script>
							<cfabort>
						</cfif>
					<cfelse>
						<cfset bank_order_cari = "">
						<cfset bank_order_account = "">
					</cfif>
					<cfscript>
						attributes.acc_type_id = '';
						comp_id = "";
						cons_id = "";
						emp_id = "";
						if(listlen(evaluate("action_employee_id#i#"),'_') eq 2)
						{
							attributes.acc_type_id = listlast(evaluate("action_employee_id#i#"),'_');
							emp_id = listfirst(evaluate("action_employee_id#i#"),'_');
						}
						else
							emp_id = evaluate("action_employee_id#i#");
						if(listlen(evaluate("action_company_id#i#"),'_') eq 2)
						{
							attributes.acc_type_id = listlast(evaluate("action_company_id#i#"),'_');
							comp_id = listfirst(evaluate("action_company_id#i#"),'_');
						}
						else
							comp_id = evaluate("action_company_id#i#");
						if(listlen(evaluate("action_consumer_id#i#"),'_') eq 2)
						{
							attributes.acc_type_id = listlast(evaluate("action_consumer_id#i#"),'_');
							cons_id = listfirst(evaluate("action_consumer_id#i#"),'_');
						}
						else
							cons_id = evaluate("action_consumer_id#i#");
						paper_currency_multiplier = '';
						if(isDefined('attributes.kur_say') and len(attributes.kur_say))
							for(mon=1;mon lte attributes.kur_say;mon=mon+1)
								if( evaluate("attributes.hidden_rd_money_#mon#") is listfirst(evaluate("attributes.money_id#i#"),';'))
									paper_currency_multiplier = evaluate('attributes.txt_rate2_#mon#/attributes.txt_rate1_#mon#');
					</cfscript>
					<cfset paper_number = '#listlast(wrk_eval("attributes.paper_number#i#"),'-')#'>
					<cfif not len(evaluate("attributes.expense_amount#i#"))><cfset "attributes.expense_amount#i#" = 0></cfif>
					<cfquery name="add_gelenh" datasource="#dsn2#">
						INSERT INTO
							BANK_ACTIONS
							(
								MULTI_ACTION_ID,
								BANK_ORDER_ID,
								ACTION_TYPE,
								ACTION_TYPE_ID,
								ACTION_FROM_COMPANY_ID,
								ACTION_FROM_CONSUMER_ID,
								ACTION_FROM_EMPLOYEE_ID,
								ACTION_TO_ACCOUNT_ID,
								ACTION_VALUE,
								ACTION_DATE,
								ACTION_CURRENCY_ID,
								ACTION_DETAIL,
								OTHER_CASH_ACT_VALUE,
								OTHER_MONEY,
								IS_ACCOUNT,
								IS_ACCOUNT_TYPE,
								PAPER_NO,
								PROJECT_ID,
								MASRAF,
								RECORD_EMP,
								RECORD_IP,
								RECORD_DATE,
								TO_BRANCH_ID,
								SUBSCRIPTION_ID,
								EXPENSE_CENTER_ID,
								EXPENSE_ITEM_ID,
								SYSTEM_ACTION_VALUE,
								SYSTEM_CURRENCY_ID,
								SPECIAL_DEFINITION_ID,
								ASSETP_ID,
								ACC_DEPARTMENT_ID,
                                ACC_TYPE_ID,
                                PROCESS_CAT,
								IBAN_NO
								<cfif len(session.ep.money2)>
									,ACTION_VALUE_2
									,ACTION_CURRENCY_ID_2
								</cfif>
							)
							VALUES
							(
								#MAX_ID.IDENTITYCOL#,
								<cfif isDefined("attributes.bank_order_id#i#") and len(evaluate("attributes.bank_order_id#i#"))>#evaluate("attributes.bank_order_id#i#")#<cfelse>NULL</cfif>,
								'#UCase(getLang('main',422))#',
								24,
								<cfif len(evaluate("member_type#i#")) and evaluate("member_type#i#") eq 'partner' and len(evaluate("action_company_id#i#"))>#comp_id#,<cfelse>NULL,</cfif>
								<cfif len(evaluate("member_type#i#")) and evaluate("member_type#i#") eq 'consumer' and len(evaluate("action_consumer_id#i#"))>#cons_id#,<cfelse>NULL,</cfif>
								<cfif len(evaluate("member_type#i#")) and evaluate("member_type#i#") eq 'employee' and len(evaluate("action_employee_id#i#"))>#emp_id#,<cfelse>NULL,</cfif>
								#attributes.account_id#,
								<cfif len(evaluate("attributes.expense_amount#i#"))>#evaluate("attributes.action_value#i#") + evaluate("attributes.expense_amount#i#")#<cfelse>#evaluate("attributes.action_value#i#")#</cfif>,
								#attributes.action_date#,
								'#attributes.currency_id#',
								<cfif isDefined("attributes.action_detail#i#") and len(evaluate("attributes.action_detail#i#"))>'#wrk_eval("attributes.action_detail#i#")#',<cfelse>NULL,</cfif>
								#evaluate("attributes.action_value_other#i#")#,
								'#listfirst(evaluate("attributes.money_id#i#"),';')#',
								<cfif get_process_type.is_account eq 1>1,13,<cfelse>0,13,</cfif>
								<cfif isdefined("attributes.paper_number#i#") and len(evaluate("attributes.paper_number#i#"))>'#wrk_eval("attributes.paper_number#i#")#',<cfelse>NULL,</cfif>
								<cfif len(evaluate("attributes.project_head#i#")) and len(evaluate("attributes.project_id#i#"))>#evaluate("attributes.project_id#i#")#<cfelse>NULL</cfif>,
								<cfif len(evaluate("attributes.expense_amount#i#"))>#wrk_eval("attributes.expense_amount#i#")#<cfelse>0</cfif>,
								#SESSION.EP.USERID#,
								'#CGI.REMOTE_ADDR#',
								#NOW()#,
								#branch_id_info#,
								<cfif isDefined("attributes.subscription_id#i#") and len(evaluate("attributes.subscription_no#i#")) and len(evaluate("attributes.subscription_id#i#"))>#evaluate("attributes.subscription_id#i#")#<cfelse>NULL</cfif>,
								<cfif isDefined("attributes.expense_center_id#i#") and len(evaluate("attributes.expense_center_id#i#")) and isDefined("attributes.expense_center_name#i#") and len(evaluate("attributes.expense_center_name#i#"))>#wrk_eval("attributes.expense_center_id#i#")#<cfelse>NULL</cfif>,
								<cfif isDefined("attributes.expense_item_id#i#") and len(evaluate("attributes.expense_item_id#i#")) and isDefined("attributes.expense_item_name#i#") and len(evaluate("attributes.expense_item_name#i#"))>#wrk_eval("attributes.expense_item_id#i#")#<cfelse>NULL</cfif>,
									#wrk_round((evaluate("attributes.action_value#i#") + evaluate("attributes.expense_amount#i#"))*dovizli_islem_multiplier)#,
								'#session.ep.money#',
								<cfif isDefined("attributes.special_definition_id#i#") and len(evaluate("attributes.special_definition_id#i#"))>#evaluate("attributes.special_definition_id#i#")#<cfelse>NULL</cfif>,
								<cfif isDefined("attributes.asset_id#i#") and len(evaluate("attributes.asset_name#i#")) and len(evaluate("attributes.asset_id#i#"))>#evaluate("attributes.asset_id#i#")#<cfelse>NULL</cfif>,
								<cfif isdefined("attributes.acc_department_id") and len(attributes.acc_department_id)>#attributes.acc_department_id#<cfelse>NULL</cfif>,
                                <cfif isdefined("attributes.acc_type_id") and len(attributes.acc_type_id)>#attributes.acc_type_id#<cfelse>NULL</cfif>,
								#form.process_cat#,
								<cfif isDefined("attributes.iban_no#i#") and len(evaluate("attributes.iban_no#i#"))>'#evaluate("attributes.iban_no#i#")#'<cfelse>NULL</cfif>
								<cfif len(session.ep.money2)>
									,#wrk_round((evaluate("attributes.action_value#i#") + evaluate("attributes.expense_amount#i#"))*dovizli_islem_multiplier/currency_multiplier,4)#
									,'#session.ep.money2#'
								</cfif>			
							)
					</cfquery>
					<cfquery name="get_act_id" datasource="#dsn2#">
						SELECT MAX(ACTION_ID) AS ACTION_ID FROM BANK_ACTIONS
					</cfquery>
					<!--- banka talimatlarından kaydedilen toplu gelen havale satirlari icin 1 set ediliyor --->
					<cfif isDefined("attributes.bank_order_id#i#") and len(evaluate("attributes.bank_order_id#i#"))>
						<cfquery name="UPD_BANK_ORDERS" datasource="#DSN2#">
							UPDATE BANK_ORDERS SET IS_PAID = 1 WHERE BANK_ORDER_ID = #evaluate("attributes.bank_order_id#i#")#
						</cfquery>
						<cfquery name="upd_cari" datasource="#dsn2#">
							UPDATE
								CARI_ROWS
							SET 
								IS_PROCESSED = 1
							WHERE 
								ACTION_ID = #evaluate("attributes.bank_order_id#i#")#
								AND ACTION_TYPE_ID = #bank_order_process_type#
						</cfquery>
					</cfif>
					<cfscript>
						exp_center_id = exp_item_id = "";
						if(isDefined("attributes.expense_center_id#i#") and len(evaluate("attributes.expense_center_id#i#")) and isDefined("attributes.expense_center_name#i#") and len(evaluate("attributes.expense_center_name#i#"))) exp_center_id = evaluate("attributes.expense_center_id#i#");
						if(isDefined("attributes.expense_item_id#i#") and len(evaluate("attributes.expense_item_id#i#")) and isDefined("attributes.expense_item_name#i#") and len(evaluate("attributes.expense_item_name#i#"))) exp_item_id = evaluate("attributes.expense_item_id#i#");
						from_cmp_id = '';
						from_consumer_id = '';
						from_employee_id = '';
						if (len(evaluate("action_company_id#i#")) and evaluate("member_type#i#") eq 'partner')
							from_cmp_id = comp_id;
						else if (len(evaluate("action_consumer_id#i#")) and evaluate("member_type#i#") eq 'consumer') 
							from_consumer_id = cons_id;
						else
							from_employee_id = emp_id;
						
						if(isDefined("attributes.asset_id#i#") and len(evaluate("attributes.asset_name#i#")) and len(evaluate("attributes.asset_id#i#")))
							asset_id = evaluate("asset_id#i#");
						else
							asset_id = '';
						if(isDefined("attributes.special_definition_id#i#") and len(evaluate("attributes.special_definition_id#i#")))
							special_definition_id = evaluate("special_definition_id#i#");
						else
							special_definition_id = '';
						
						if(isDefined("attributes.subscription_id#i#") and len(evaluate("attributes.subscription_id#i#"))){
							subscription_id = evaluate("subscription_id#i#");
							subscription_no =  evaluate("subscription_no#i#");
						}
						else{
							subscription_id = '';
							subscription_no = '';
						}
							

						if(get_process_type.is_cari eq 1)
						{
							carici(
									action_id : get_act_id.action_id,
									action_table : 'BANK_ACTIONS',
									islem_belge_no : evaluate("attributes.paper_number#i#"),
									workcube_process_type : 24,		
									process_cat : form.process_cat,	
									islem_tarihi : attributes.action_date,
									to_account_id : attributes.account_id,
									to_branch_id : branch_id_info,
									islem_tutari : evaluate("attributes.system_amount#i#"),
									other_money_value : evaluate("attributes.action_value_other#i#"),
									other_money : listfirst(evaluate("attributes.money_id#i#"),';'),
									action_currency : session.ep.money,
									action_detail : evaluate("attributes.action_detail#i#"),
									currency_multiplier : currency_multiplier,
									account_card_type : 13,
									subscription_id : iif((len(subscription_id) and len(subscription_no)),subscription_id,de('')),
									acc_type_id : attributes.acc_type_id,
									islem_detay : UCase(getLang('main',422)),//GELEN HAVALE
									due_date: attributes.action_date,
									project_id : evaluate("attributes.project_id#i#"),
									from_cmp_id : from_cmp_id,
									from_consumer_id : from_consumer_id,
									from_employee_id : from_employee_id,
									special_definition_id : special_definition_id,
									assetp_id : asset_id,
									rate2 :paper_currency_multiplier
								);
						}
						if(len(exp_center_id) and len(exp_item_id) and evaluate("attributes.expense_amount#i#") gt 0)
						{
							butceci(
								action_id : get_act_id.action_id,
								muhasebe_db : dsn2,
								is_income_expense : false,
								process_type : 24,
								nettotal : wrk_round(evaluate("attributes.expense_amount#i#")*dovizli_islem_multiplier),
								other_money_value : evaluate("attributes.expense_amount#i#"),
								action_currency : attributes.currency_id,
								currency_multiplier : currency_multiplier,
								expense_date : attributes.action_date,
								expense_center_id : exp_center_id,
								expense_item_id : exp_item_id,
								detail : UCase(getLang('main',2721)),//GELEN HAVALE MASRAFI
								paper_no : evaluate("attributes.paper_number#i#"),
								project_id : evaluate("attributes.project_id#i#"),
								company_id : from_cmp_id,
								consumer_id : from_consumer_id,
								employee_id : from_employee_id,
								branch_id : branch_id_info,
								insert_type : 1
							);
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
				if(isdefined('attributes.acc_department_id') and len(attributes.acc_department_id) )
					acc_department_id = attributes.acc_department_id;
				else
					acc_department_id = '';
					
				if( isdefined("attributes.record_num") and attributes.record_num neq "")
				{
					for(j=1; j lte attributes.record_num; j=j+1)
						{
							if( isdefined("attributes.row_kontrol#j#") and evaluate("attributes.row_kontrol#j#") eq 1)
							{
								attributes.acc_type_id = '';
								from_cmp_id = '';
								from_consumer_id = '';
								from_employee_id = '';
								if(listlen(evaluate("attributes.action_employee_id#j#"),'_') eq 2)
								{
									attributes.acc_type_id = listlast(evaluate("attributes.action_employee_id#j#"),'_');
									from_employee_id = listfirst(evaluate("attributes.action_employee_id#j#"),'_');
								}
								else
									from_employee_id = evaluate("attributes.action_employee_id#j#");
								
								if(listlen(evaluate("attributes.action_company_id#j#"),'_') eq 2)
								{
									attributes.acc_type_id = listlast(evaluate("attributes.action_company_id#j#"),'_');
									from_cmp_id = listfirst(evaluate("attributes.action_company_id#j#"),'_');
								}
								else
									from_cmp_id = evaluate("attributes.action_company_id#j#");
								if(listlen(evaluate("attributes.action_consumer_id#j#"),'_') eq 2)
								{
									attributes.acc_type_id = listlast(evaluate("attributes.action_consumer_id#j#"),'_');
									from_consumer_id = listfirst(evaluate("attributes.action_consumer_id#j#"),'_');
								}
								else
									from_consumer_id = evaluate("attributes.action_consumer_id#j#");
								
								borc_hesap_list = listappend(borc_hesap_list,attributes.account_acc_code,',');
								borc_tutar_list = listappend(borc_tutar_list,evaluate("attributes.system_amount#j#"));
								doviz_tutar_borc = listappend(doviz_tutar_borc,evaluate("attributes.action_value#j#"));
								doviz_currency_borc = listappend(doviz_currency_borc,attributes.currency_id,',');
								if(is_account_group neq 1)
								{
									if (len(evaluate("attributes.action_detail#j#")))
										satir_detay_list[1][listlen(borc_tutar_list)]='#evaluate("attributes.comp_name#j#")# - #evaluate("attributes.action_detail#j#")#';
									else
										satir_detay_list[1][listlen(borc_tutar_list)]='#evaluate("attributes.comp_name#j#")# - ' & UCase(getLang('main',1750));
								}
								else
								{
									satir_detay_list[1][listlen(borc_tutar_list)] = UCase(getLang('main',1750));
								}
								if(len(evaluate("action_company_id#j#")) and len(evaluate("member_type#j#")) and evaluate("member_type#j#") eq 'partner')
									my_acc_result = GET_COMPANY_PERIOD(from_cmp_id,session.ep.period_id,dsn2,attributes.acc_type_id);
								else if(len(evaluate("action_consumer_id#j#")) and len(evaluate("member_type#j#")) and evaluate("member_type#j#") eq 'consumer')
									my_acc_result = GET_CONSUMER_PERIOD(from_consumer_id,session.ep.period_id,dsn2,attributes.acc_type_id);
								else
									my_acc_result = GET_EMPLOYEE_PERIOD(from_employee_id,attributes.acc_type_id);
								alacak_hesap_list = listappend(alacak_hesap_list,my_acc_result,',');
								alacak_tutar_list = listappend(alacak_tutar_list,evaluate("attributes.system_amount#j#"));
								doviz_tutar_alacak = listappend(doviz_tutar_alacak,evaluate("attributes.action_value_other#j#"),',');
								doviz_currency_alacak = listappend(doviz_currency_alacak,listfirst(evaluate("attributes.money_id#j#"),';'),',');
								
								if(isdefined("attributes.project_id#j#") and len(evaluate("attributes.project_id#j#")) and len(evaluate("attributes.project_head#j#")))
								{
									acc_project_list_alacak = listappend(acc_project_list_alacak,evaluate("attributes.project_id#j#"),',');
									acc_project_list_borc = listappend(acc_project_list_borc,evaluate("attributes.project_id#j#"),',');
								}
								else
								{
									acc_project_list_alacak = listappend(acc_project_list_alacak,'0',',');
									acc_project_list_borc = listappend(acc_project_list_borc,'0',',');
								}
								
								if(is_account_group neq 1)
								{
									if (len(evaluate("attributes.action_detail#j#")))
										satir_detay_list[2][listlen(alacak_tutar_list)]='#evaluate("attributes.comp_name#j#")# - #evaluate("attributes.action_detail#j#")#';
									else
										satir_detay_list[2][listlen(alacak_tutar_list)]='#evaluate("attributes.comp_name#j#")# - ' & UCase(getLang('main',1750));
								}
								else
								{
									satir_detay_list[2][listlen(alacak_tutar_list)]= UCase(getLang('main',1750));
								}
								
								if(isdefined("attributes.expense_item_id#j#") and len(evaluate("attributes.expense_item_id#j#")) and isdefined("attributes.expense_item_name#j#") and len(evaluate("attributes.expense_item_name#j#")) and evaluate("attributes.expense_amount#j#") gt 0)
								{
									GET_EXP_ACC = cfquery(datasource : "#dsn2#", sqlstring : "SELECT ACCOUNT_CODE FROM EXPENSE_ITEMS WHERE EXPENSE_ITEM_ID = '#evaluate("attributes.expense_item_id#j#")#'");
									borc_hesap_list = ListAppend(borc_hesap_list,GET_EXP_ACC.ACCOUNT_CODE,",");	
									alacak_hesap_list = ListAppend(alacak_hesap_list,attributes.account_acc_code,",");	
									if(attributes.currency_id is session.ep.money) {
										borc_tutar_list = ListAppend(borc_tutar_list,evaluate("attributes.expense_amount#j#"),",");
										alacak_tutar_list = ListAppend(alacak_tutar_list,evaluate("attributes.expense_amount#j#"),",");
									} else {
										borc_tutar_list = ListAppend(borc_tutar_list,wrk_round(evaluate("attributes.expense_amount#j#")*dovizli_islem_multiplier),",");
										alacak_tutar_list = ListAppend(alacak_tutar_list,wrk_round(evaluate("attributes.expense_amount#j#")*dovizli_islem_multiplier),",");
									}
									doviz_tutar_borc = ListAppend(doviz_tutar_borc,evaluate("attributes.expense_amount#j#"),",");
									doviz_currency_borc = ListAppend(doviz_currency_borc,attributes.currency_id,",");
									doviz_tutar_alacak = ListAppend(doviz_tutar_alacak,evaluate("attributes.expense_amount#j#"),",");
									doviz_currency_alacak = ListAppend(doviz_currency_alacak,attributes.currency_id,",");
										
									if(is_account_group neq 1)
									{
										if (len(evaluate("attributes.action_detail#j#"))) {
											satir_detay_list[1][listlen(borc_tutar_list)]='#evaluate("attributes.comp_name#j#")# - #evaluate("attributes.action_detail#j#")#';
											satir_detay_list[2][listlen(alacak_tutar_list)]='#evaluate("attributes.comp_name#j#")# - #evaluate("attributes.action_detail#j#")#';
										} else {
											satir_detay_list[1][listlen(borc_tutar_list)]='#evaluate("attributes.comp_name#j#")# - ' & UCase(getLang('main',2722));
											satir_detay_list[2][listlen(alacak_tutar_list)]='#evaluate("attributes.comp_name#j#")# - ' & UCase(getLang('main',2722));
										}
									}
									else
									{
										satir_detay_list[1][listlen(borc_tutar_list)]= UCase(getLang('main',2722));
										satir_detay_list[2][listlen(alacak_tutar_list)]= UCase(getLang('main',2722));
									}
									
									if(isdefined("attributes.project_id#j#") and len(evaluate("attributes.project_id#j#")) and len(evaluate("attributes.project_head#j#")))
									{
										acc_project_list_alacak = listappend(acc_project_list_alacak,evaluate("attributes.project_id#j#"),',');
										acc_project_list_borc = listappend(acc_project_list_borc,evaluate("attributes.project_id#j#"),',');
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

				muhasebeci(
						action_id : MAX_ID.IDENTITYCOL,
						workcube_process_type: multi_type,
						workcube_process_cat:form.process_cat,
						account_card_type: 13,
						acc_department_id:acc_department_id,
						islem_tarihi: attributes.action_date,
						fis_satir_detay: satir_detay_list,
						to_branch_id : branch_id_info,
						borc_hesaplar: borc_hesap_list,
						borc_tutarlar: borc_tutar_list,
						other_amount_borc : doviz_tutar_borc,
						other_currency_borc : doviz_currency_borc,
						alacak_hesaplar: alacak_hesap_list,
						alacak_tutarlar: alacak_tutar_list,
						other_amount_alacak : doviz_tutar_alacak,
						other_currency_alacak : doviz_currency_alacak,
						currency_multiplier : currency_multiplier,
						fis_detay: UCase(getLang('main',1750)), //TOPLU GELEN HAVALE
						is_account_group : is_account_group,
						acc_project_list_alacak : acc_project_list_alacak,
						acc_project_list_borc : acc_project_list_borc,
						belge_no : MAX_ID.IDENTITYCOL,
						is_acc_type : 1
					);
			}
		</cfscript>
		<cfloop from="1" to="#attributes.kur_say#" index="r">
			<cfquery name="ADD_ACTION_MONEY" datasource="#dsn2#">
				INSERT INTO 
					BANK_ACTION_MULTI_MONEY 
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
		<!--- Belge No update ediliyor --->
		<cfif Len(paper_number)>
			<cfquery name="UPD_GENERAL_PAPERS" datasource="#DSN2#">
				UPDATE 
					#dsn3_alias#.GENERAL_PAPERS
				SET
					INCOMING_TRANSFER_NUMBER = #paper_number#
				WHERE
					INCOMING_TRANSFER_NUMBER IS NOT NULL
			</cfquery>
		</cfif>
		<!--- onay ve uyarıların gelebilmesi icin action file sarti kaldirildi DT20141001 --->
        <cf_workcube_process_cat 
            process_cat="#form.process_cat#"
            action_id = #MAX_ID.IDENTITYCOL#
            is_action_file = 1
            action_db_type = '#dsn2#'
            action_page='#request.self#?fuseaction=#listGetAt(fuseaction,1,'.')#.form_add_gelenh&event=updMulti&multi_id=#MAX_ID.IDENTITYCOL#'
            action_file_name='#get_process_type.action_file_name#'
            is_template_action_file = '#get_process_type.action_file_from_template#'>
	</cftransaction>
</cflock>
<cfset attributes.actionId = MAX_ID.IDENTITYCOL>
<cfif isdefined("attributes.from_assign_order")>
	<script type="text/javascript">
		wrk_opener_reload();
		window.close();
	</script>
<cfelse>
	<script type="text/javascript">
    	window.location.href="<cfoutput>#request.self#?fuseaction=bank.form_add_gelenh&event=updMulti&multi_id=#MAX_ID.IDENTITYCOL#</cfoutput>";
	</script>
</cfif>

