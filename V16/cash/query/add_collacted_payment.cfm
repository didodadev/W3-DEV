<cfif attributes.active_period neq session.ep.period_id>
	<script type="text/javascript">
		alert("<cf_get_lang_main no='1659.İşlem Yapmak İstediğiniz Muhasebe Dönemi ile Aktif Muhasebe Döneminiz Farklı Muhasebe Döneminizi Kontrol Ediniz'>!");
		history.back();
	</script>
	<cfabort>
</cfif>
<cfif not isdefined("attributes.new_period_id")><cfset new_period_id = session.ep.period_id><cfelse><cfset new_period_id = attributes.new_period_id></cfif>
<cfif not isdefined("attributes.new_dsn3")><cfset new_dsn3 = dsn3><cfelse><cfset new_dsn3 = attributes.new_dsn3></cfif>
<cfif not isdefined("attributes.new_dsn2")><cfset new_dsn2 = dsn2><cfelse><cfset new_dsn2 = attributes.new_dsn2></cfif>

<cfquery name="get_process_type" datasource="#new_dsn3#">
	SELECT PROCESS_TYPE,IS_CARI,IS_ACCOUNT,IS_ACCOUNT_GROUP,ACTION_FILE_NAME,ACTION_FILE_FROM_TEMPLATE,MULTI_TYPE FROM SETUP_PROCESS_CAT WHERE PROCESS_CAT_ID = #form.process_cat#
</cfquery>
<cfscript>
	multi_type = get_process_type.multi_type;
	process_type = get_process_type.process_type;
	is_account_group = get_process_type.is_account_group;
</cfscript>
<cf_date tarih='attributes.action_date'>
<cfif isdefined('attributes.new_period_id')>
	<!--- toplu ödemede seçilen işlem tarihine göre ilgili döneme kayıt atacak SG 20160114--->
	<cfquery name="get_period_id" datasource="#dsn#">
		SELECT
			PERIOD_ID,
			PERIOD_YEAR,
			OUR_COMPANY_ID
		FROM
			SETUP_PERIOD
		WHERE
			OUR_COMPANY_ID = (SELECT OUR_COMPANY_ID FROM SETUP_PERIOD WHERE PERIOD_ID = #new_period_id#)
			AND (PERIOD_YEAR = #year(attributes.action_date)# OR YEAR(FINISH_DATE) = #year(attributes.action_date)#)
			AND (FINISH_DATE IS NULL OR (FINISH_DATE IS NOT NULL AND FINISH_DATE >= #attributes.action_date#))
	</cfquery>
    <cfdump var="#get_period_id#">
	<cfset new_dsn2 = '#dsn#_#get_period_id.period_year#_#get_period_id.OUR_COMPANY_ID#'>
	<cfset new_dsn3 = '#dsn#_#get_period_id.OUR_COMPANY_ID#'>
	<cfset new_period_id = get_period_id.period_id>
</cfif>
<cfquery name="get_from_cash" datasource="#new_dsn2#">
	SELECT CASH_CURRENCY_ID,CASH_ACC_CODE FROM CASH WHERE CASH_ID = #ListFirst(cash_action_from_cash_id,';')#
</cfquery>
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
<cf_papers paper_type="cash_payment">
<cflock name="#createUUID()#" timeout="60">			
	<cftransaction>
		<cfquery name="add_cash_actions_multi" datasource="#new_dsn2#">
			INSERT INTO
				CASH_ACTIONS_MULTI
				(
					PROCESS_CAT,
					ACTION_TYPE_ID,
					FROM_CASH_ID,
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
					#listfirst(cash_action_from_cash_id,';')#,
					#attributes.action_date#,
					<cfif get_process_type.is_account eq 1>1,12,<cfelse>0,12,</cfif>
					#SESSION.EP.USERID#,
					'#CGI.REMOTE_ADDR#',
					#NOW()#				
					)
		</cfquery>
		<cfquery name="get_multi_id" datasource="#new_dsn2#">
			SELECT MAX(MULTI_ACTION_ID) AS MULTI_ID FROM CASH_ACTIONS_MULTI
		</cfquery>
		<cfif isdefined("attributes.puantaj_id")><!--- puantajdan geliyorsa puantaj tablolarını update edecek --->
			<cfquery name="upd_employee_act" datasource="#new_dsn2#">
				UPDATE
					#dsn_alias#.EMPLOYEES_PUANTAJ_CARI_ACTIONS
				SET
					CASH_ACTION_MULTI_ID = #get_multi_id.MULTI_ID#,
					CASH_PERIOD_ID = #new_period_id#
				WHERE
					PUANTAJ_ID = #attributes.puantaj_id# AND
					IS_VIRTUAL = #attributes.is_virtual#
			</cfquery>
		</cfif>
		<cfscript>
			currency_multiplier = '';
			if(isDefined('attributes.kur_say') and len(attributes.kur_say))
				for(mon=1;mon lte attributes.kur_say;mon=mon+1)
					if( evaluate("attributes.hidden_rd_money_#mon#") is session.ep.money2)
						currency_multiplier = evaluate('attributes.txt_rate2_#mon#/attributes.txt_rate1_#mon#');
		</cfscript>
		<cfif isdefined("attributes.record_num") and len(attributes.record_num)>
			<cfloop from="1" to="#attributes.record_num#" index="i">
				<cfif isdefined("attributes.row_kontrol#i#") and evaluate("attributes.row_kontrol#i#")>
					<cfset paper_number = paper_number + 1>
					<cfscript>
						attributes.acc_type_id = '';
						if(listlen(evaluate("action_employee_id#i#"),'_') eq 2)
						{
							attributes.acc_type_id = listlast(evaluate("action_employee_id#i#"),'_');
							"action_employee_id#i#" = listfirst(evaluate("action_employee_id#i#"),'_');
						}
						paper_currency_multiplier = '';
						if(isDefined('attributes.kur_say') and len(attributes.kur_say))
							for(mon=1;mon lte attributes.kur_say;mon=mon+1)
								if( evaluate("attributes.hidden_rd_money_#mon#") is listfirst(evaluate("attributes.money_id#i#"),';'))
									paper_currency_multiplier = evaluate('attributes.txt_rate2_#mon#/attributes.txt_rate1_#mon#');
					</cfscript>
					<cfquery name="add_revenue" datasource="#new_dsn2#">
						INSERT INTO
							CASH_ACTIONS
							(
								MULTI_ACTION_ID,
								PAPER_NO,
								ACTION_TYPE,
								ACTION_TYPE_ID,
								CASH_ACTION_VALUE,
								CASH_ACTION_CURRENCY_ID,
								CASH_ACTION_TO_COMPANY_ID,
								CASH_ACTION_TO_CONSUMER_ID,
								CASH_ACTION_TO_EMPLOYEE_ID,
								CASH_ACTION_FROM_CASH_ID,
								ACTION_DATE,
								OTHER_CASH_ACT_VALUE,
								OTHER_MONEY,
								PAYER_ID,
								ACTION_DETAIL,
								IS_ACCOUNT,
								IS_ACCOUNT_TYPE,
								PROJECT_ID,
								RECORD_EMP,
								RECORD_IP,
								RECORD_DATE,
								ACTION_VALUE,
								ACTION_CURRENCY_ID,
								SPECIAL_DEFINITION_ID,
								ASSETP_ID,
                                ACC_TYPE_ID,
								AVANS_ID
								<cfif len(session.ep.money2)>
									,ACTION_VALUE_2
									,ACTION_CURRENCY_ID_2
								</cfif>		
							)
							VALUES
							(
								#get_multi_id.multi_id#,
								<cfif len(evaluate("paper_number#i#"))>'#wrk_eval("paper_number#i#")#',<cfelse>NULL,</cfif>
								'ÖDEME',
								32,
								#evaluate("attributes.action_value#i#")#,
								'#get_from_cash.cash_currency_id#',
								<cfif len(evaluate("action_company_id#i#")) and evaluate("member_type#i#") eq 'partner'>#evaluate("action_company_id#i#")#,<cfelse>NULL,</cfif>
								<cfif len(evaluate("action_consumer_id#i#")) and evaluate("member_type#i#") eq 'consumer'>#evaluate("action_consumer_id#i#")#,<cfelse>NULL,</cfif>
								<cfif len(evaluate("action_employee_id#i#")) and evaluate("member_type#i#") eq 'employee'>#evaluate("action_employee_id#i#")#,<cfelse>NULL,</cfif>
								#listfirst(cash_action_from_cash_id,';')#,
								#attributes.action_date#,
								#evaluate("attributes.action_value_other#i#")#,
								'#listfirst(evaluate("attributes.money_id#i#"),';')#',
								#evaluate("attributes.employee_id#i#")#,
								<cfif isDefined("attributes.action_detail#i#") and len(evaluate("attributes.action_detail#i#"))>'#wrk_eval("attributes.action_detail#i#")#',<cfelse>NULL,</cfif>
								<cfif get_process_type.is_account eq 1>1,12,<cfelse>0,12,</cfif>
								<cfif len(evaluate("attributes.project_head#i#")) and len(evaluate("attributes.project_id#i#"))>#evaluate("attributes.project_id#i#")#<cfelse>NULL</cfif>,
								#SESSION.EP.USERID#,
								'#CGI.REMOTE_ADDR#',
								#NOW()#	,
								#evaluate("attributes.system_amount#i#")#,
								'#session.ep.money#',
								<cfif isDefined("attributes.special_definition_id#i#") and len(evaluate("attributes.special_definition_id#i#"))>#evaluate("attributes.special_definition_id#i#")#<cfelse>NULL</cfif>,
								<cfif isDefined("attributes.asset_id#i#") and len(evaluate("attributes.asset_name#i#")) and len(evaluate("attributes.asset_id#i#"))>#evaluate("attributes.asset_id#i#")#<cfelse>NULL</cfif>,
                                <cfif isdefined("attributes.acc_type_id") and len(attributes.acc_type_id)>#attributes.acc_type_id#<cfelse>NULL</cfif>,
								<cfif len(evaluate("attributes.avans_id#i#"))>#evaluate("attributes.avans_id#i#")#<cfelse>NULL</cfif>
								<cfif len(session.ep.money2)>
									,#wrk_round(evaluate("attributes.system_amount#i#")/currency_multiplier,4)#
									,'#session.ep.money2#'
								</cfif>			
							)
					</cfquery>		
					<cfquery name="get_act_id" datasource="#new_dsn2#">
						SELECT MAX(ACTION_ID) AS ACTION_ID FROM CASH_ACTIONS
					</cfquery>
					<cfif isdefined("attributes.payment_ids")><!--- avans taleplerinden geliyor ise avans --->
					<cfif len(evaluate("attributes.avans_id#i#"))>
					<cfquery name="upd_cor_payment" datasource="#new_dsn2#">
						UPDATE 
							#dsn_alias#.CORRESPONDENCE_PAYMENT
						SET
							ACTION_ID = #get_act_id.ACTION_ID#,
							ACTION_TYPE_ID = 32,
							ACTION_PERIOD_ID = #session.ep.period_id#
						WHERE
							ID = #evaluate("attributes.avans_id#i#")#
					</cfquery>
					</cfif>
					</cfif>
					<cfif isdefined("attributes.other_payment_ids")><!---Taksitli avans taleplerinden geliyor ise avans --->
						<cfif len(evaluate("attributes.avans_id#i#"))>
						<cfquery name="upd_cor_other_payment" datasource="#new_dsn2#">
							UPDATE 
								#dsn_alias#.SALARYPARAM_GET_REQUESTS
							SET
								ACTION_ID = #get_act_id.ACTION_ID#,
								ACTION_TYPE_ID = 32
							WHERE
								SPGR_ID = #evaluate("attributes.avans_id#i#")#
						</cfquery>
						</cfif>
						</cfif>
					<cfscript>
						if(get_process_type.is_cari eq 1)
						{
							to_cmp_id = '';
							to_consumer_id = '';
							to_employee_id = '';
							if (len(evaluate("action_company_id#i#")) and evaluate("member_type#i#") eq 'partner')
								to_cmp_id = evaluate("action_company_id#i#");
							else if (len(evaluate("action_consumer_id#i#")) and evaluate("member_type#i#") eq 'consumer') 
								to_consumer_id = evaluate("action_consumer_id#i#");
							else
								to_employee_id = evaluate("action_employee_id#i#");
							
							if(isDefined("attributes.asset_id#i#") and len(evaluate("attributes.asset_name#i#")) and len(evaluate("attributes.asset_id#i#")))
								asset_id = evaluate("asset_id#i#");
							else
								asset_id = '';
							if(isDefined("attributes.special_definition_id#i#") and len(evaluate("attributes.special_definition_id#i#")))
								special_definition_id = evaluate("special_definition_id#i#");
							else
								special_definition_id = '';
									
							if(get_from_cash.cash_currency_id is session.ep.money)
							{
								carici(
										action_id : get_act_id.action_id,
										action_table : 'CASH_ACTIONS',
										islem_belge_no : evaluate("paper_number#i#"),
										workcube_process_type : 32,		
										process_cat : 0,	
										islem_tarihi : attributes.action_date,
										from_cash_id : ListFirst(cash_action_from_cash_id,';'),
										from_branch_id : ListLast(cash_action_from_cash_id,';'),
										islem_tutari : evaluate("attributes.action_value#i#"),
										other_money_value : evaluate("attributes.action_value_other#i#"),
										other_money : listfirst(evaluate("attributes.money_id#i#"),';'),			
										action_currency : session.ep.money,
										action_detail : evaluate("attributes.action_detail#i#"),
										currency_multiplier : currency_multiplier,
										account_card_type : 12,
										acc_type_id : attributes.acc_type_id,
										islem_detay : 'ÖDEME',
										due_date: attributes.action_date,
										project_id : evaluate("attributes.project_id#i#"),
										to_cmp_id : to_cmp_id,
										to_consumer_id : to_consumer_id,
										to_employee_id : to_employee_id,
										special_definition_id : special_definition_id,
										assetp_id : asset_id,
										rate2:paper_currency_multiplier,
										cari_db:new_dsn2
									);
							}
							else
							{
								carici(
										action_id : get_act_id.action_id,
										action_table : 'CASH_ACTIONS',
										islem_belge_no : evaluate("paper_number#i#"),
										workcube_process_type : 32,		
										process_cat : 0,	
										islem_tarihi : attributes.action_date,
										from_cash_id : ListFirst(cash_action_from_cash_id,';'),
										from_branch_id : ListLast(cash_action_from_cash_id,';'),
										islem_tutari : evaluate("attributes.system_amount#i#"),
										action_currency : session.ep.money,
										action_detail : evaluate("attributes.action_detail#i#"),
										other_money_value : evaluate("attributes.action_value_other#i#"),
										other_money : listfirst(evaluate("attributes.money_id#i#"),';'),
										currency_multiplier : currency_multiplier,
										account_card_type : 12,
										acc_type_id : attributes.acc_type_id,
										islem_detay : 'ÖDEME',
										due_date: attributes.action_date,
										project_id : evaluate("attributes.project_id#i#"),
										to_cmp_id : to_cmp_id,
										to_consumer_id : to_consumer_id,
										to_employee_id : to_employee_id,
										special_definition_id : special_definition_id,
										assetp_id : asset_id,
										rate2:paper_currency_multiplier,
										cari_db:new_dsn2
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
				if(get_from_cash.cash_currency_id is session.ep.money)
				{
					if( isdefined("attributes.record_num") and len(attributes.record_num) )
					{
						for(k=1; k lte attributes.record_num; k=k+1)
							if( isdefined("attributes.row_kontrol#k#") and evaluate("attributes.row_kontrol#k#") eq 1)
							{
								attributes.acc_type_id = '';
								if(listlen(evaluate("attributes.action_employee_id#k#"),'_') eq 2)
								{
									attributes.acc_type_id = listlast(evaluate("attributes.action_employee_id#k#"),'_');
									"action_employee_id#k#" = listfirst(evaluate("attributes.action_employee_id#k#"),'_');
								}
								alacak_hesap_list = listappend(alacak_hesap_list,get_from_cash.cash_acc_code,',');
								alacak_tutar_list = listappend(alacak_tutar_list,evaluate("attributes.action_value#k#"),',');
								doviz_tutar_alacak = listappend(doviz_tutar_alacak,evaluate("attributes.action_value#k#"),',');
								doviz_currency_alacak = listappend(doviz_currency_alacak,get_from_cash.cash_currency_id,',');
								/* muhasebe alacakli satir aciklamalari */
								if(is_account_group neq 1)
								{
									if (len(evaluate("attributes.action_detail#k#")) )
										satir_detay_list[1][listlen(alacak_tutar_list)]='#evaluate("attributes.paper_number#k#")# - #evaluate("attributes.comp_name#k#")# - #evaluate("attributes.action_detail#k#")#';
									else
										satir_detay_list[1][listlen(alacak_tutar_list)]='#evaluate("attributes.paper_number#k#")# - #evaluate("attributes.comp_name#k#")# - TOPLU NAKİT ÖDEME';
								}
								else
								{
									satir_detay_list[1][listlen(alacak_tutar_list)]='TOPLU ÖDEME İŞLEMİ';
								}
								
								if(len(evaluate("action_company_id#k#")) and len(evaluate("member_type#k#")) and evaluate("member_type#k#") eq 'partner')
									my_acc_result = GET_COMPANY_PERIOD(evaluate("action_company_id#k#"),new_period_id,new_dsn2);
								else if(len(evaluate("action_consumer_id#k#")) and len(evaluate("member_type#k#")) and evaluate("member_type#k#") eq 'consumer')
									my_acc_result = GET_CONSUMER_PERIOD(evaluate("action_consumer_id#k#"),new_period_id,new_dsn2);
								else
									my_acc_result = GET_EMPLOYEE_PERIOD(evaluate("action_employee_id#k#"),attributes.acc_type_id,new_dsn2,new_dsn3,new_period_id);							
								borc_hesap_list = listappend(borc_hesap_list,my_acc_result,',');
								borc_tutar_list = listappend(borc_tutar_list,evaluate("attributes.action_value#k#"));
								doviz_tutar_borc = listappend(doviz_tutar_borc,evaluate("attributes.action_value_other#k#"),',');
								doviz_currency_borc = listappend(doviz_currency_borc,listfirst(evaluate("attributes.money_id#k#"),';'),',');
								/* acc_project_id muhasebeciye kaydediliyor */
								if(isdefined("attributes.project_id#k#") and len(evaluate("attributes.project_id#k#")) and len(evaluate("attributes.project_head#k#")))
								{
									acc_project_list_alacak = listappend(acc_project_list_alacak,evaluate("attributes.project_id#k#"),',');
									acc_project_list_borc = listappend(acc_project_list_borc,evaluate("attributes.project_id#k#"),',');
								}
								else
								{
									acc_project_list_alacak = listappend(acc_project_list_alacak,'0',',');
									acc_project_list_borc = listappend(acc_project_list_borc,'0',',');
								}	
								/* muhasebe borclu satir aciklamalari */
								if(is_account_group neq 1)
								{
									if (len(evaluate("attributes.action_detail#k#")) )
										satir_detay_list[2][listlen(borc_tutar_list)]='#evaluate("attributes.paper_number#k#")# - #evaluate("attributes.comp_name#k#")# - #evaluate("attributes.action_detail#k#")#';
									else
										satir_detay_list[2][listlen(borc_tutar_list)]='#evaluate("attributes.paper_number#k#")# - #evaluate("attributes.comp_name#k#")# - TOPLU NAKİT ÖDEME';
								}
								else
								{
									satir_detay_list[2][listlen(borc_tutar_list)]='TOPLU ÖDEME İŞLEMİ';
								}
							}
					}
					muhasebeci (
						action_id: get_multi_id.multi_id,
						workcube_process_type: multi_type,
						workcube_process_cat:form.process_cat,
						account_card_type: 12,
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
						from_branch_id : ListLast(cash_action_from_cash_id,';'),
						acc_project_list_alacak : acc_project_list_alacak,
						acc_project_list_borc : acc_project_list_borc,
						is_account_group : is_account_group,
						fis_detay: 'TOPLU ÖDEME İŞLEMİ',
						muhasebe_db : new_dsn2,
						belge_no : get_multi_id.multi_id
					);
				}
				else
				{
					if( isdefined("attributes.record_num") and attributes.record_num neq "")
					{
						for(j=1; j lte attributes.record_num; j=j+1)
							if( isdefined("attributes.row_kontrol#j#") and evaluate("attributes.row_kontrol#j#") eq 1)
							{
								attributes.acc_type_id = '';
								if(listlen(evaluate("attributes.action_employee_id#j#"),'_') eq 2)
								{
									attributes.acc_type_id = listlast(evaluate("attributes.action_employee_id#j#"),'_');
									"action_employee_id#j#" = listfirst(evaluate("attributes.action_employee_id#j#"),'_');
								}
								alacak_hesap_list = listappend(alacak_hesap_list,get_from_cash.cash_acc_code,',');
								alacak_tutar_list = listappend(alacak_tutar_list,evaluate("attributes.system_amount#j#"));
								doviz_tutar_alacak = listappend(doviz_tutar_alacak,evaluate("attributes.action_value#j#"));
								doviz_currency_alacak = listappend(doviz_currency_alacak,get_from_cash.cash_currency_id,',');
								/* muhasebe alacakli satir aciklamalari */
								if(is_account_group neq 1)
								{
									if (len(evaluate("attributes.action_detail#j#")))
										satir_detay_list[1][listlen(alacak_tutar_list)]='#evaluate("attributes.paper_number#j#")# - #evaluate("attributes.comp_name#j#")# - #evaluate("attributes.action_detail#j#")#';
									else
										satir_detay_list[1][listlen(alacak_tutar_list)]='#evaluate("attributes.paper_number#j#")# - #evaluate("attributes.comp_name#j#")# -TOPLU NAKİT ÖDEME';
								}
								else
								{
									satir_detay_list[1][listlen(alacak_tutar_list)]='TOPLU ÖDEME İŞLEMİ';
								}		
								
								if (len(evaluate("action_employee_id#j#")))
									my_acc_result = GET_EMPLOYEE_PERIOD(evaluate("action_employee_id#j#"),attributes.acc_type_id);		
								else if (len(evaluate("action_company_id#j#")))
									my_acc_result = GET_COMPANY_PERIOD(evaluate("action_company_id#j#"));
								else if(len(evaluate("action_consumer_id#j#")) and len(evaluate("member_type#j#")) and evaluate("member_type#j#") eq 'consumer')
									my_acc_result = GET_CONSUMER_PERIOD(evaluate("action_consumer_id#j#"));	
								borc_hesap_list = listappend(borc_hesap_list,my_acc_result,',');
								borc_tutar_list = listappend(borc_tutar_list,evaluate("attributes.system_amount#j#"));
								doviz_tutar_borc = listappend(doviz_tutar_borc,evaluate("attributes.action_value_other#j#"));
								doviz_currency_borc = listappend(doviz_currency_borc,listfirst(evaluate("attributes.money_id#j#"),';'),',');
								
								/* acc_project_id muhasebeciye kaydediliyor */
								if(isdefined("attributes.project_id#j#") and len(evaluate("attributes.project_id#j#")) and len(evaluate("attributes.project_head#j#")))
								{
									acc_project_list_alacak = listappend(acc_project_list_alacak,evaluate("attributes.project_id#j#"),',');
									acc_project_list_borc = listappend(acc_project_list_borc,evaluate("attributes.project_id#j#"),',');
								}
								else
								{
									acc_project_list_alacak = listappend(acc_project_list_alacak,'',',');
									acc_project_list_borc = listappend(acc_project_list_borc,'',',');
								}
								/* muhasebe borclu satir aciklamalari */
								if(is_account_group neq 1)
								{
									if (len(evaluate("attributes.action_detail#j#")))
										satir_detay_list[2][listlen(borc_tutar_list)]='#evaluate("attributes.paper_number#j#")# - #evaluate("attributes.comp_name#j#")# -#evaluate("attributes.action_detail#j#")#';
									else
										satir_detay_list[2][listlen(borc_tutar_list)]='#evaluate("attributes.paper_number#j#")# - #evaluate("attributes.comp_name#j#")# -TOPLU NAKİT ÖDEME';
								}
								else
								{
									satir_detay_list[2][listlen(alacak_tutar_list)]='TOPLU ÖDEME İŞLEMİ';
								}
							}
					}
					muhasebeci (
						action_id:  get_multi_id.multi_id,
						workcube_process_type: multi_type,
						workcube_process_cat:form.process_cat,
						account_card_type: 12,
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
						from_branch_id : ListLast(cash_action_from_cash_id,';'),
						acc_project_list_alacak : acc_project_list_alacak,
						acc_project_list_borc : acc_project_list_borc,
						is_account_group : is_account_group,
						fis_detay: 'TOPLU ÖDEME İŞLEMI',
						belge_no : get_multi_id.multi_id
					);
				}
			}
		</cfscript>
		<cfloop from="1" to="#attributes.kur_say#" index="r">
			<cfquery name="ADD_ACTION_MONEY" datasource="#new_dsn2#">
				INSERT 
				INTO 
					CASH_ACTION_MULTI_MONEY 
					(
						ACTION_ID,
						MONEY_TYPE,
						RATE2,
						RATE1,
						IS_SELECTED
					)
					VALUES
					(
						#get_multi_id.multi_id#,
						'#wrk_eval("attributes.hidden_rd_money_#r#")#',
						#evaluate("attributes.txt_rate2_#r#")#,
						#evaluate("attributes.txt_rate1_#r#")#,
						<cfif evaluate("attributes.hidden_rd_money_#r#") is listfirst(attributes.rd_money,',')>1<cfelse>0</cfif>
					)
			</cfquery>
		</cfloop>
		<cfquery name="upd_paper_no" datasource="#new_dsn2#">
			UPDATE 
				#new_dsn3#.GENERAL_PAPERS
			SET
				CASH_PAYMENT_NUMBER = #paper_number-1#
			WHERE
				CASH_PAYMENT_NUMBER IS NOT NULL
		</cfquery>
        <cf_workcube_process_cat 
            process_cat="#form.process_cat#"
            action_id = #get_multi_id.multi_id#
            is_action_file = 1
            action_db_type = '#new_dsn2#'
            action_page='#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.upd_collacted_payment&multi_id=#get_multi_id.multi_id#'
            action_file_name='#get_process_type.action_file_name#'
            is_template_action_file = '#get_process_type.action_file_from_template#'>
	</cftransaction>
</cflock>
<cfset attributes.actionid = get_multi_id.multi_id>
<cfif isdefined("attributes.puantaj_id") or isdefined("attributes.payment_ids")>
	<script type="text/javascript">
		wrk_opener_reload();
		window.close();
	</script>
<cfelse>
	<script type="text/javascript">
    	window.location.href='<cfoutput>#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.form_add_cash_payment&event=updMulti&multi_id=#get_multi_id.multi_id#</cfoutput>';
    </script>
</cfif>
