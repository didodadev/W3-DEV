<cfif form.active_period neq session.ep.period_id>
	<script type="text/javascript">
		alert("<cf_get_lang_main no='1659.İşlem Yapmak İstediğiniz Muhasebe Dönemi ile Aktif Muhasebe Döneminiz Farklı Muhasebe Döneminizi Kontrol Ediniz'>!");
		history.back();
	</script>
	<cfabort>
</cfif>
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
<cfquery name="get_all_gelenh" datasource="#dsn2#">
	SELECT ACTION_ID,ACTION_TYPE_ID FROM BANK_ACTIONS WHERE MULTI_ACTION_ID = #attributes.multi_id#
</cfquery>
<cf_date tarih='attributes.action_date'>
<cfscript>
	process_type = get_process_type.process_type;
	multi_type = get_process_type.multi_type;
	is_account_group = get_process_type.is_account_group;
	for(b=1; b lte attributes.record_num; b=b+1)
		if(evaluate("attributes.row_kontrol#b#") eq 1)
		{
			//'attributes.action_value#b#' = filterNum(evaluate('attributes.action_value#b#'));
			//'attributes.action_value_other#b#' = filterNum(evaluate('attributes.action_value_other#b#')); formdan formatlı geiyor
			//'attributes.system_amount#b#' = filterNum(evaluate('attributes.system_amount#b#'));
			//'attributes.expense_amount#b#' = filterNum(evaluate('attributes.expense_amount#b#'));
		}
	for(s=1; s lte attributes.kur_say; s=s+1)
	{
		'attributes.txt_rate2_#s#' = filterNum(evaluate('attributes.txt_rate2_#s#'),session.ep.our_company_info.rate_round_num);
		'attributes.txt_rate1_#s#' = filterNum(evaluate('attributes.txt_rate1_#s#'),session.ep.our_company_info.rate_round_num);
	}
	if(isdefined("attributes.branch_id") and len(attributes.branch_id))
		branch_id_info = attributes.branch_id;
	else
		branch_id_info = listgetat(session.ep.user_location,2,'-');
</cfscript>
<cf_papers paper_type="incoming_transfer">
<cflock name="#createUUID()#" timeout="60">			
	<cftransaction>
		<cfquery name="upd_bank_actions_multi" datasource="#dsn2#">
			UPDATE
				BANK_ACTIONS_MULTI
			SET				
				PROCESS_CAT = #form.process_cat#,
				ACTION_TYPE_ID = #process_type#,
				TO_ACCOUNT_ID = #attributes.account_id#,
				ACTION_DATE = #attributes.action_date#,
				IS_ACCOUNT = <cfif get_process_type.is_account eq 1>1<cfelse>0</cfif>,
				IS_ACCOUNT_TYPE = 13,
				UPDATE_EMP = #SESSION.EP.USERID#,
				UPDATE_IP = '#CGI.REMOTE_ADDR#',
				UPDATE_DATE = #NOW()#
			WHERE
				MULTI_ACTION_ID = #attributes.multi_id#					
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
        <cfset listDelete = ''>
		<cfif isdefined("attributes.record_num") and len(attributes.record_num)>
			<cfloop from="1" to="#attributes.record_num#" index="i">
            	<cfif  isdefined("attributes.act_row_id#i#")>
     				<cfset listDelete = ListAppend(listDelete,evaluate("attributes.act_row_id#i#"))>
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
					if(listlen(evaluate("attributes.action_company_id#i#"),'_') eq 2)
					{
						attributes.acc_type_id = listlast(evaluate("attributes.action_company_id#i#"),'_');
						comp_id =  listfirst(evaluate("attributes.action_company_id#i#"),'_');
					}
					else
						comp_id =  evaluate("attributes.action_company_id#i#");
					if(listlen(evaluate("attributes.action_consumer_id#i#"),'_') eq 2)
					{
						attributes.acc_type_id = listlast(evaluate("attributes.action_consumer_id#i#"),'_');
						cons_id =  listfirst(evaluate("attributes.action_consumer_id#i#"),'_');
					}
					else
						cons_id =  evaluate("attributes.action_consumer_id#i#");
					paper_currency_multiplier = '';
					if(isDefined('attributes.kur_say') and len(attributes.kur_say))
						for(mon=1;mon lte attributes.kur_say;mon=mon+1)
							if( evaluate("attributes.hidden_rd_money_#mon#") is listfirst(evaluate("attributes.money_id#i#"),';'))
								paper_currency_multiplier = evaluate('attributes.txt_rate2_#mon#/attributes.txt_rate1_#mon#');
				</cfscript>
				<cfif isdefined("attributes.row_kontrol#i#") and evaluate("attributes.row_kontrol#i#") and not isdefined("attributes.act_row_id#i#")><!--- yeni eklenen satırlar --->
					<cfset paper_number = '#listlast(wrk_eval("attributes.paper_number#i#"),'-')#'>
					<cfif not len(evaluate("attributes.expense_amount#i#"))><cfset "attributes.expense_amount#i#" = 0></cfif>
					<cfquery name="add_gelenh" datasource="#dsn2#">
						INSERT INTO
							BANK_ACTIONS
							(
								MULTI_ACTION_ID,
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
								RECORD_EMP,
								RECORD_IP,
								RECORD_DATE	,
								TO_BRANCH_ID,
								SUBSCRIPTION_ID,
								EXPENSE_CENTER_ID,
								EXPENSE_ITEM_ID,
								MASRAF,
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
								#attributes.multi_id#,
								'#UCase(getLang('main',422))#',
								24,
								<cfif len(evaluate("member_type#i#")) and evaluate("member_type#i#") eq 'partner' and len(comp_id)>#comp_id#,<cfelse>NULL,</cfif>
								<cfif len(evaluate("member_type#i#")) and evaluate("member_type#i#") eq 'consumer' and len(cons_id)>#cons_id#,<cfelse>NULL,</cfif>
								<cfif len(evaluate("member_type#i#")) and evaluate("member_type#i#") eq 'employee' and len(emp_id)>#emp_id#,<cfelse>NULL,</cfif>
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
								#SESSION.EP.USERID#,
								'#CGI.REMOTE_ADDR#',
								#NOW()#,
								#branch_id_info#,
								<cfif isDefined("attributes.subscription_id#i#") and len(evaluate("attributes.subscription_no#i#")) and len(evaluate("attributes.subscription_id#i#"))>#evaluate("attributes.subscription_id#i#")#<cfelse>NULL</cfif>,
								<cfif isDefined("attributes.row_exp_center_id#i#") and len(evaluate("attributes.row_exp_center_id#i#")) and isDefined("attributes.row_exp_center_name#i#") and len(evaluate("attributes.row_exp_center_name#i#"))>#evaluate("attributes.row_exp_center_id#i#")#<cfelse>NULL</cfif>,
								<cfif isDefined("attributes.row_exp_item_id#i#") and len(evaluate("attributes.row_exp_item_id#i#")) and isDefined("attributes.row_exp_item_name#i#") and len(evaluate("attributes.row_exp_item_name#i#"))>#evaluate("attributes.row_exp_item_id#i#")#<cfelse>NULL</cfif>,
								<cfif len(evaluate("attributes.expense_amount#i#"))>#wrk_eval("attributes.expense_amount#i#")#<cfelse>0</cfif>,
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
                    <cfif not isdefined("attributes.act_row_id#i#")>
     					<cfset listDelete = ListAppend(listDelete,get_act_id.ACTION_ID)>
               		 </cfif>
					<cfscript>
						exp_center_id = exp_item_id = "";
						if(isDefined("attributes.row_exp_center_id#i#") and len(evaluate("attributes.row_exp_center_id#i#")) and isDefined("attributes.row_exp_center_name#i#") and len(evaluate("attributes.row_exp_center_name#i#"))) exp_center_id = evaluate("attributes.row_exp_center_id#i#");
						if(isDefined("attributes.row_exp_item_id#i#") and len(evaluate("attributes.row_exp_item_id#i#")) and isDefined("attributes.row_exp_item_name#i#") and len(evaluate("attributes.row_exp_item_name#i#"))) exp_item_id = evaluate("attributes.row_exp_item_id#i#");
						
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
							
						if (session.ep.our_company_info.project_followup neq 1)//isdefined lar altta functionlarda sıkıntı yaratıyordu buraya tanımlandı
						{
							attributes.project_id = "";
							attributes.project_head = "";
						}
						else
						{
							attributes.project_id = evaluate("attributes.project_id#i#");
							attributes.project_head = evaluate("attributes.project_head#i#");
						}

						subscription_id = evaluate("attributes.subscription_id#i#");
						subscription_no =  evaluate("attributes.subscription_no#i#");
						
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
									action_currency : session.ep.money,
									other_money_value : evaluate("attributes.action_value_other#i#"),
									other_money : listfirst(evaluate("attributes.money_id#i#"),';'),		
									currency_multiplier : currency_multiplier,
									account_card_type : 13,
									subscription_id : iif((len(subscription_id) and len(subscription_no)),subscription_id,de('')),
									acc_type_id : attributes.acc_type_id,
									islem_detay : UCase(getLang('main',422)),//GELEN HAVALE
									action_detail : evaluate("attributes.ACTION_DETAIL#i#"),
									due_date: attributes.action_date,
									project_id : iif((len(attributes.project_id) and len(attributes.project_head)),attributes.project_id,de('')),
									from_cmp_id : from_cmp_id,
									from_consumer_id : from_consumer_id,
									from_employee_id : from_employee_id,
									special_definition_id : special_definition_id,
									assetp_id : asset_id,
									rate2:paper_currency_multiplier
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
								project_id : iif((len(attributes.project_id) and len(attributes.project_head)),attributes.project_id,de('')),
								company_id : from_cmp_id,
								consumer_id : from_consumer_id,
								employee_id : from_employee_id,
								branch_id : branch_id_info,
								insert_type : 1
							);
						}
					</cfscript>
				<cfelseif isdefined("attributes.row_kontrol#i#") and evaluate("attributes.row_kontrol#i#") and isdefined("attributes.act_row_id#i#") and len(evaluate("attributes.act_row_id#i#"))><!--- güncellenecek satırlar --->
                    <cfquery name="upd_gelenh" datasource="#dsn2#">
						UPDATE
							BANK_ACTIONS
						SET
							ACTION_FROM_COMPANY_ID = <cfif len(evaluate("member_type#i#")) and evaluate("member_type#i#") eq 'partner' and len(evaluate("action_company_id#i#"))>#comp_id#,<cfelse>NULL,</cfif>
							ACTION_FROM_CONSUMER_ID = <cfif len(evaluate("member_type#i#")) and evaluate("member_type#i#") eq 'consumer' and len(evaluate("action_consumer_id#i#"))>#cons_id#,<cfelse>NULL,</cfif>
							ACTION_FROM_EMPLOYEE_ID = <cfif len(evaluate("member_type#i#")) and evaluate("member_type#i#") eq 'employee' and len(evaluate("action_employee_id#i#"))>#emp_id#,<cfelse>NULL,</cfif>
							ACTION_TO_ACCOUNT_ID = #attributes.account_id#,
							ACTION_VALUE = <cfif len(evaluate("attributes.expense_amount#i#"))>#evaluate("attributes.action_value#i#") + evaluate("attributes.expense_amount#i#")#<cfelse>#evaluate("attributes.action_value#i#")#</cfif>,
							ACTION_DATE = #attributes.action_date#,
							ACTION_CURRENCY_ID = '#attributes.currency_id#',
							ACTION_DETAIL = <cfif isDefined("attributes.action_detail#i#") and len(evaluate("attributes.action_detail#i#"))>'#wrk_eval("attributes.action_detail#i#")#',<cfelse>NULL,</cfif>
							OTHER_CASH_ACT_VALUE = #evaluate("attributes.action_value_other#i#")#,
							OTHER_MONEY = '#listfirst(evaluate("attributes.money_id#i#"),';')#',
							IS_ACCOUNT = <cfif get_process_type.is_account eq 1>1,<cfelse>0,</cfif>
							PAPER_NO = <cfif isdefined("attributes.paper_number#i#") and len(evaluate("attributes.paper_number#i#"))>'#wrk_eval("attributes.paper_number#i#")#',<cfelse>NULL,</cfif>
							PROJECT_ID = <cfif len(evaluate("attributes.project_head#i#")) and len(evaluate("attributes.project_id#i#"))>#evaluate("attributes.project_id#i#")#<cfelse>NULL</cfif>,
							TO_BRANCH_ID = #branch_id_info#,
							MASRAF = <cfif len(evaluate("attributes.expense_amount#i#"))>#wrk_eval("attributes.expense_amount#i#")#<cfelse>0</cfif>,
							EXPENSE_CENTER_ID = <cfif isdefined("attributes.row_exp_center_id#i#") and len(evaluate("attributes.row_exp_center_id#i#")) and isdefined("attributes.row_exp_center_name#i#") and len(evaluate("attributes.row_exp_center_name#i#"))>#evaluate("attributes.row_exp_center_id#i#")#<cfelse>NULL</cfif>,
							EXPENSE_ITEM_ID = <cfif isdefined("attributes.row_exp_item_id#i#") and len(evaluate("attributes.row_exp_item_id#i#")) and isdefined("attributes.row_exp_item_name#i#") and len(evaluate("attributes.row_exp_item_name#i#"))>#evaluate("attributes.row_exp_item_id#i#")#<cfelse>NULL</cfif>,
							UPDATE_EMP = #SESSION.EP.USERID#,
							UPDATE_IP = '#CGI.REMOTE_ADDR#',
							UPDATE_DATE = #NOW()#,
							SUBSCRIPTION_ID = <cfif isDefined("attributes.subscription_id#i#") and len(evaluate("attributes.subscription_no#i#")) and len(evaluate("attributes.subscription_id#i#"))>#evaluate("attributes.subscription_id#i#")#<cfelse>NULL</cfif>,
							SYSTEM_ACTION_VALUE = #wrk_round((evaluate("attributes.action_value#i#") + evaluate("attributes.expense_amount#i#"))*dovizli_islem_multiplier)#,
							SYSTEM_CURRENCY_ID = '#session.ep.money#',
							SPECIAL_DEFINITION_ID = <cfif isDefined("attributes.special_definition_id#i#") and len(evaluate("attributes.special_definition_id#i#"))>#evaluate("attributes.special_definition_id#i#")#<cfelse>NULL</cfif>,
							ASSETP_ID = <cfif isDefined("attributes.asset_id#i#") and len(evaluate("attributes.asset_name#i#")) and len(evaluate("attributes.asset_id#i#"))>#evaluate("attributes.asset_id#i#")#<cfelse>NULL</cfif>,
							ACC_DEPARTMENT_ID = <cfif isdefined("attributes.acc_department_id") and len(attributes.acc_department_id)>#attributes.acc_department_id#<cfelse>NULL</cfif>,
                            ACC_TYPE_ID = <cfif isdefined("attributes.acc_type_id") and len(attributes.acc_type_id)>#attributes.acc_type_id#<cfelse>NULL</cfif>,
                            PROCESS_CAT = #form.process_cat#,
							IBAN_NO = <cfif isDefined("attributes.iban_no#i#") and len(evaluate("attributes.iban_no#i#"))>'#evaluate("attributes.iban_no#i#")#'<cfelse>NULL</cfif>
							<cfif len(session.ep.money2)>
								,ACTION_VALUE_2 = #wrk_round(((evaluate("attributes.action_value#i#") + evaluate("attributes.expense_amount#i#"))*dovizli_islem_multiplier)/currency_multiplier,4)#
								,ACTION_CURRENCY_ID_2 = '#session.ep.money2#'
							</cfif>
						WHERE
							MULTI_ACTION_ID = #attributes.multi_id# AND
							ACTION_ID = #evaluate("attributes.act_row_id#i#")#
					</cfquery>
					<cfscript>
						butce_sil(action_id:evaluate("attributes.act_row_id#i#"),process_type:24);
						exp_center_id = exp_item_id = "";
						if(isDefined("attributes.row_exp_center_id#i#") and len(evaluate("attributes.row_exp_center_id#i#")) and isDefined("attributes.row_exp_center_name#i#") and len(evaluate("attributes.row_exp_center_name#i#"))) exp_center_id = evaluate("attributes.row_exp_center_id#i#");
						if(isDefined("attributes.row_exp_item_id#i#") and len(evaluate("attributes.row_exp_item_id#i#")) and isDefined("attributes.row_exp_item_name#i#") and len(evaluate("attributes.row_exp_item_name#i#"))) exp_item_id = evaluate("attributes.row_exp_item_id#i#");
						from_cmp_id = '';
						from_consumer_id = '';
						from_employee_id = '';
						if (len(evaluate("action_company_id#i#")) and evaluate("member_type#i#") eq 'partner')
							from_cmp_id = listfirst(evaluate("action_company_id#i#"),'_');
						else if (len(evaluate("action_consumer_id#i#")) and evaluate("member_type#i#") eq 'consumer') 
							from_consumer_id =  listfirst(evaluate("action_consumer_id#i#"),'_');
						else
							from_employee_id =  listfirst(evaluate("action_employee_id#i#"),'_');
						if(isDefined("attributes.asset_id#i#") and len(evaluate("attributes.asset_name#i#")) and len(evaluate("attributes.asset_id#i#")))
							asset_id = evaluate("asset_id#i#");
						else
							asset_id = '';
						if(isDefined("attributes.special_definition_id#i#") and len(evaluate("attributes.special_definition_id#i#")))
							special_definition_id = evaluate("special_definition_id#i#");
						else
							special_definition_id = '';
						if (session.ep.our_company_info.project_followup neq 1)//isdefined lar altta functionlarda sıkıntı yaratıyordu buraya tanımlandı
						{
							attributes.project_id = "";
							attributes.project_head = "";
						}
						else
						{
							attributes.project_id = evaluate("attributes.project_id#i#");
							attributes.project_head = evaluate("attributes.project_head#i#");
						}
						subscription_id = evaluate("attributes.subscription_id#i#");
						subscription_no =  evaluate("attributes.subscription_no#i#");
						if(get_process_type.is_cari eq 1)
						{	
							carici(
									action_id : evaluate("attributes.act_row_id#i#"),
									action_table : 'BANK_ACTIONS',
									islem_belge_no : evaluate("attributes.paper_number#i#"),
									workcube_process_type : 24,		
									workcube_old_process_type : 24,		
									process_cat :form.process_cat,	
									islem_tarihi : attributes.action_date,
									to_account_id : attributes.account_id,
									to_branch_id : branch_id_info,
									islem_tutari : evaluate("attributes.system_amount#i#"),
									action_currency : session.ep.money,
									other_money_value : evaluate("attributes.action_value_other#i#"),
									other_money : listfirst(evaluate("attributes.money_id#i#"),';'),		
									currency_multiplier : currency_multiplier,
									account_card_type : 13,
									subscription_id : iif((len(subscription_id) and len(subscription_no)),subscription_id,de('')),
									acc_type_id : attributes.acc_type_id,
									islem_detay : UCase(getLang('main',422)),//GELEN HAVALE
									action_detail : evaluate("attributes.ACTION_DETAIL#i#"),
									due_date: attributes.action_date,
									project_id : iif((len(attributes.project_id) and len(attributes.project_head)),attributes.project_id,de('')),
									from_cmp_id : from_cmp_id,
									from_consumer_id : from_consumer_id,
									from_employee_id : from_employee_id,
									special_definition_id : special_definition_id,
									assetp_id : asset_id,
									rate2:paper_currency_multiplier
									);
						}
						else
							cari_sil(action_id:evaluate("attributes.act_row_id#i#"),process_type:24);
						if(len(exp_center_id) and len(exp_item_id) and evaluate("attributes.expense_amount#i#") gt 0)
						{
							butceci(
								action_id : evaluate("attributes.act_row_id#i#"),
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
								project_id : iif((len(attributes.project_id) and len(attributes.project_head)),attributes.project_id,de('')),
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
			<cfquery name="bank" datasource="#dsn2#">
            	SELECT * FROM BANK_ACTIONS WHERE MULTI_ACTION_ID = #attributes.multi_id# AND ACTION_ID NOT IN (#listDelete#)
            </cfquery>	
            <cfif  bank.recordcount>
            	<cfoutput query="bank">
            		<cfquery name="CHECK_BANK_ORDERS" datasource="#dsn2#">
	                	SELECT BANK_ORDER_ID FROM BANK_ACTIONS WHERE MULTI_ACTION_ID = #attributes.multi_id# AND ACTION_ID = #action_id#
	                </cfquery>
	                <cfif len(CHECK_BANK_ORDERS.BANK_ORDER_ID)>
	                	<cfquery name="UPDATE_BANK_ORDERS" datasource="#dsn2#">
	                    	UPDATE BANK_ORDERS SET IS_PAID = 0 WHERE BANK_ORDER_ID = #CHECK_BANK_ORDERS.BANK_ORDER_ID#
	                    </cfquery>
	                </cfif>
					<cfquery name="del_revenue" datasource="#dsn2#">
						DELETE FROM BANK_ACTIONS WHERE MULTI_ACTION_ID = #attributes.multi_id# AND ACTION_ID = #action_id#
					</cfquery>
					<cfscript>
						cari_sil(action_id:action_id,process_type:24);
	                	butce_sil(action_id:action_id,process_type:24);    
	                </cfscript>
            	</cfoutput>	
            </cfif>
             <cfquery name="deleteRows" datasource="#dsn2#">
            	DELETE FROM BANK_ACTIONS WHERE MULTI_ACTION_ID = #attributes.multi_id# AND ACTION_ID NOT IN (#listDelete#)
            </cfquery>
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
				emp_id_ = "";
				comp_id_ = "";
				cons_id_ = "";
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
							if(listlen(evaluate("attributes.action_employee_id#j#"),'_') eq 2)
							{
								attributes.acc_type_id = listlast(evaluate("attributes.action_employee_id#j#"),'_');
								"action_employee_id#j#" = listfirst(evaluate("attributes.action_employee_id#j#"),'_');
								emp_id_ = listfirst(evaluate("attributes.action_employee_id#j#"),'_');
							}
							else
								emp_id_ = evaluate("attributes.action_employee_id#j#");
							if(listlen(evaluate("attributes.action_company_id#j#"),'_') eq 2)
							{
								attributes.acc_type_id = listlast(evaluate("attributes.action_company_id#j#"),'_');
								"action_company_id#j#" = listfirst(evaluate("attributes.action_company_id#j#"),'_');
								comp_id_ = listfirst(evaluate("attributes.action_company_id#j#"),'_');
							}
							else
								comp_id_ = evaluate("attributes.action_company_id#j#");
							if(listlen(evaluate("attributes.action_consumer_id#j#"),'_') eq 2)
							{
								attributes.acc_type_id = listlast(evaluate("attributes.action_consumer_id#j#"),'_');
								"action_consumer_id#j#" = listfirst(evaluate("attributes.action_consumer_id#j#"),'_');
								cons_id_ = listfirst(evaluate("attributes.action_consumer_id#j#"),'_');
							}
							else
								cons_id_ = evaluate("attributes.action_consumer_id#j#");
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
								satir_detay_list[1][listlen(borc_tutar_list)]= UCase(getLang('main',1750));
							}
							if(len(evaluate("action_company_id#j#")) and len(evaluate("member_type#j#")) and evaluate("member_type#j#") eq 'partner')
								my_acc_result = GET_COMPANY_PERIOD(evaluate("action_company_id#j#"),session.ep.period_id,dsn2,attributes.acc_type_id);
							else if(len(evaluate("action_consumer_id#j#")) and len(evaluate("member_type#j#")) and evaluate("member_type#j#") eq 'consumer')
								my_acc_result = GET_CONSUMER_PERIOD(evaluate("action_consumer_id#j#"),session.ep.period_id,dsn2,attributes.acc_type_id);
							else
								my_acc_result = GET_EMPLOYEE_PERIOD(evaluate("action_employee_id#j#"),attributes.acc_type_id);
					//	writeoutput(my_acc_result);
							alacak_hesap_list = listappend(alacak_hesap_list,my_acc_result,',');
							alacak_tutar_list = listappend(alacak_tutar_list,evaluate("attributes.system_amount#j#"));
							doviz_tutar_alacak = listappend(doviz_tutar_alacak,evaluate("attributes.action_value_other#j#"));
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
							
							if(isdefined("attributes.row_exp_item_id#j#") and len(evaluate("attributes.row_exp_item_id#j#")) and isdefined("attributes.row_exp_item_name#j#") and len(evaluate("attributes.row_exp_item_name#j#")) and evaluate("attributes.expense_amount#j#") gt 0)
							{
								GET_EXP_ACC = cfquery(datasource : "#dsn2#", sqlstring : "SELECT ACCOUNT_CODE FROM EXPENSE_ITEMS WHERE EXPENSE_ITEM_ID = '#evaluate("attributes.row_exp_item_id#j#")#'");
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
						action_id: attributes.multi_id,
						workcube_process_type: multi_type,
						workcube_old_process_type: form.old_process_multi_type,
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
						belge_no : attributes.multi_id,
						company_id: comp_id_,
						consumer_id:cons_id_,
						employee_id : emp_id_,
						is_acc_type : 1
					);
			}
			else
				muhasebe_sil(action_id:attributes.multi_id,process_type:attributes.old_process_multi_type);
		//	abort(1);
		</cfscript>
		<cfquery name="del_action_money" datasource="#dsn2#">
			DELETE FROM BANK_ACTION_MULTI_MONEY WHERE ACTION_ID=#attributes.multi_id#
		</cfquery>
		<cfloop from="1" to="#attributes.kur_say#" index="i">
			<cfquery name="add_action_money" datasource="#dsn2#">
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
						#attributes.multi_id#,
						'#wrk_eval("attributes.hidden_rd_money_#i#")#',
						#evaluate("attributes.txt_rate2_#i#")#,
						#evaluate("attributes.txt_rate1_#i#")#,
						<cfif evaluate("attributes.hidden_rd_money_#i#") is listfirst(attributes.rd_money,',')>1<cfelse>0</cfif>
					)
			</cfquery>
		</cfloop>
		<!--- Belge No update ediliyor --->
		<cfif not isdefined("attributes.act_row_id#attributes.record_num#")>
			<cfif len(paper_number)>
				<cfquery name="UPD_GENERAL_PAPERS" datasource="#DSN2#">
					UPDATE 
						#dsn3_alias#.GENERAL_PAPERS
					SET
						INCOMING_TRANSFER_NUMBER = #paper_number#
					WHERE
						INCOMING_TRANSFER_NUMBER IS NOT NULL
				</cfquery>
			</cfif>
		</cfif>
		<!--- onay ve uyarıların gelebilmesi icin action file sarti kaldirildi DT20141001 --->
        <cf_workcube_process_cat 
            process_cat="#form.process_cat#"
            old_process_cat_id = "#attributes.old_process_cat_id#"
            action_id = #attributes.multi_id#
            is_action_file = 1
            action_db_type = '#dsn2#'
            action_page='#request.self#?fuseaction=#listGetAt(fuseaction,1,'.')#.form_add_gelenh&event=updMulti&multi_id=#attributes.multi_id#'
            action_file_name='#get_process_type.action_file_name#'
            is_template_action_file = '#get_process_type.action_file_from_template#'>
	</cftransaction>
</cflock>
<cfset attributes.actionId = attributes.multi_id>
<script type="text/javascript">
	window.location.href="<cfoutput>#request.self#?fuseaction=bank.form_add_gelenh&event=updMulti&multi_id=#attributes.multi_id#</cfoutput>";
</script>
