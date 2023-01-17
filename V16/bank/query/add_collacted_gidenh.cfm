<cfif form.active_period neq session.ep.period_id>
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
<cfif isdefined('attributes.new_period_id')>
	<!--- giden havale işlem tarihine göre ilgili döneme kayıt atacak SG 20141017--->
	<cfquery name="get_period_id" datasource="#dsn#">
		SELECT
			PERIOD_ID,
			PERIOD_YEAR,
			OUR_COMPANY_ID
		FROM
			SETUP_PERIOD
		WHERE
			OUR_COMPANY_ID = (SELECT OUR_COMPANY_ID FROM SETUP_PERIOD WHERE PERIOD_ID = #attributes.new_period_id#)
			AND (PERIOD_YEAR = #year(attributes.action_date)# OR YEAR(FINISH_DATE) = #year(attributes.action_date)#)
			AND (FINISH_DATE IS NULL OR (FINISH_DATE IS NOT NULL AND FINISH_DATE >= #attributes.action_date#))
	</cfquery>
	<cfset new_dsn2 = '#dsn#_#get_period_id.period_year#_#get_period_id.OUR_COMPANY_ID#'>
	<cfset new_dsn3 = '#dsn#_#get_period_id.OUR_COMPANY_ID#'>
	<cfset new_period_id = get_period_id.period_id>
</cfif>
<cf_papers paper_type="outgoing_transfer">
<cflock name="#createUUID()#" timeout="60">			
	<cftransaction>
		<cfquery name="add_bank_actions_multi" datasource="#new_dsn2#" result="MAX_ID">
			INSERT INTO
				BANK_ACTIONS_MULTI
				(
					PROCESS_CAT,
					ACTION_TYPE_ID,
					FROM_ACCOUNT_ID,
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
		<cfif isdefined("attributes.puantaj_id")><!--- puantajdan geliyorsa puantaj tablolarını update edecek --->
			<cfquery name="upd_employee_act" datasource="#new_dsn2#">
				UPDATE
					#dsn_alias#.EMPLOYEES_PUANTAJ_CARI_ACTIONS
				SET
					BANK_ACTION_MULTI_ID = #MAX_ID.IDENTITYCOL#,
					BANK_PERIOD_ID = #new_period_id#
				WHERE
					PUANTAJ_ID = #attributes.puantaj_id# AND
					IS_VIRTUAL = #attributes.is_virtual#
			</cfquery>
		</cfif>
		<cfscript>
			currency_multiplier = '';
			if(isDefined('attributes.kur_say') and len(attributes.kur_say))
				for(mon=1;mon lte attributes.kur_say;mon=mon+1)
				{
					if( evaluate("attributes.hidden_rd_money_#mon#") is session.ep.money2)
						currency_multiplier = evaluate('attributes.txt_rate2_#mon#/attributes.txt_rate1_#mon#');
					if(evaluate("attributes.hidden_rd_money_#mon#") is listfirst(attributes.rd_money,','))
						masraf_curr_multiplier = evaluate('attributes.txt_rate2_#mon#/attributes.txt_rate1_#mon#');
					if(evaluate("attributes.hidden_rd_money_#mon#") eq attributes.currency_id)
						dovizli_islem_multiplier = evaluate('attributes.txt_rate2_#mon#/attributes.txt_rate1_#mon#');
				}
		</cfscript>
		<cfif isdefined("attributes.record_num") and len(attributes.record_num)>
			<cfloop from="1" to="#attributes.record_num#" index="i">
				<cfif isdefined("attributes.row_kontrol#i#") and evaluate("attributes.row_kontrol#i#")>
					<!--- gelen banka talimati ve toplu giden havale process type ları karsılastırılıyor --->
					<cfif isDefined("attributes.bank_order_id#i#") and len(evaluate("attributes.bank_order_id#i#"))>
						<cfquery name="get_bank_order_process_type" datasource="#new_dsn2#">
							SELECT 
								PROCESS_TYPE,
								IS_CARI,
								IS_ACCOUNT
							 FROM 
								#new_dsn3#.SETUP_PROCESS_CAT 
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
						if(listlen(evaluate("attributes.action_company_id#i#"),'_') eq 2)
						{
							attributes.acc_type_id = listlast(evaluate("attributes.action_company_id#i#"),'_');
							comp_id = listfirst(evaluate("attributes.action_company_id#i#"),'_');
						}
						else
							comp_id = evaluate("attributes.action_company_id#i#");
						if(listlen(evaluate("attributes.action_consumer_id#i#"),'_') eq 2)
						{
							attributes.acc_type_id = listlast(evaluate("attributes.action_consumer_id#i#"),'_');
							cons_id = listfirst(evaluate("attributes.action_consumer_id#i#"),'_');
						}
						else
							cons_id = evaluate("attributes.action_consumer_id#i#");
						paper_currency_multiplier = '';
						if(isDefined('attributes.kur_say') and len(attributes.kur_say))
							for(mon=1;mon lte attributes.kur_say;mon=mon+1)
								if( evaluate("attributes.hidden_rd_money_#mon#") is listfirst(evaluate("attributes.money_id#i#"),';'))
									paper_currency_multiplier = evaluate('attributes.txt_rate2_#mon#/attributes.txt_rate1_#mon#');
					</cfscript>
					<cfset paper_number = '#listlast(wrk_eval("attributes.paper_number#i#"),'-')#'>
					<cfif not len(evaluate("attributes.expense_amount#i#"))><cfset "attributes.expense_amount#i#" = 0></cfif>
					<cfquery name="add_gelenh" datasource="#new_dsn2#">
						INSERT INTO
							BANK_ACTIONS
							(
								MULTI_ACTION_ID,
								BANK_ORDER_ID,
								ACTION_TYPE,
								ACTION_TYPE_ID,
                                PROCESS_CAT,
								ACTION_TO_COMPANY_ID,
								ACTION_TO_CONSUMER_ID,
								ACTION_TO_EMPLOYEE_ID,
								ACTION_FROM_ACCOUNT_ID,
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
								FROM_BRANCH_ID,
								SUBSCRIPTION_ID,
								EXPENSE_CENTER_ID,
								EXPENSE_ITEM_ID,
								SYSTEM_ACTION_VALUE,
								SYSTEM_CURRENCY_ID,
								SPECIAL_DEFINITION_ID,
								ASSETP_ID,
								ACC_DEPARTMENT_ID,
                                ACC_TYPE_ID,
								AVANS_ID,
								RELATED_ACTION_ID
								<cfif len(session.ep.money2)>
									,ACTION_VALUE_2
									,ACTION_CURRENCY_ID_2
								</cfif>	
							)
							VALUES
							(
								#MAX_ID.IDENTITYCOL#,
								<cfif isDefined("attributes.bank_order_id#i#") and len(evaluate("attributes.bank_order_id#i#"))>#evaluate("attributes.bank_order_id#i#")#<cfelse>NULL</cfif>,
								'#UCase(getLang('main',423))#',
								25,
                                #form.process_cat#,
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
								<cfif get_process_type.is_account eq 1>1,12,<cfelse>0,12,</cfif>
								<cfif isdefined("attributes.paper_number#i#") and len(evaluate("attributes.paper_number#i#"))>'#wrk_eval("attributes.paper_number#i#")#',<cfelse>NULL,</cfif>
								<cfif len(evaluate("attributes.project_head#i#")) and len(evaluate("attributes.project_id#i#"))>#wrk_eval("attributes.project_id#i#")#<cfelse>NULL</cfif>,
								<cfif len(evaluate("attributes.expense_amount#i#"))>#wrk_eval("attributes.expense_amount#i#")#<cfelse>0</cfif>,
								#SESSION.EP.USERID#,
								'#CGI.REMOTE_ADDR#',
								#NOW()#	,
								#branch_id_info#,
								<cfif isDefined("attributes.subscription_id#i#") and len(evaluate("attributes.subscription_no#i#")) and len(evaluate("attributes.subscription_id#i#"))>#evaluate("attributes.subscription_id#i#")#<cfelse>NULL</cfif>,
								<cfif isDefined("attributes.row_exp_center_id#i#") and len(evaluate("attributes.row_exp_center_id#i#")) and isDefined("attributes.row_exp_center_name#i#") and len(evaluate("attributes.row_exp_center_name#i#"))>#wrk_eval("attributes.row_exp_center_id#i#")#<cfelse>NULL</cfif>,
								<cfif isDefined("attributes.row_exp_item_id#i#") and len(evaluate("attributes.row_exp_item_id#i#")) and isDefined("attributes.row_exp_item_name#i#") and len(evaluate("attributes.row_exp_item_name#i#"))>#wrk_eval("attributes.row_exp_item_id#i#")#<cfelse>NULL</cfif>,
								#wrk_round((evaluate("attributes.action_value#i#") + evaluate("attributes.expense_amount#i#"))*dovizli_islem_multiplier)#,
								'#session.ep.money#',
								<cfif isDefined("attributes.special_definition_id#i#") and len(evaluate("attributes.special_definition_id#i#"))>#evaluate("attributes.special_definition_id#i#")#<cfelse>NULL</cfif>,
								<cfif isDefined("attributes.asset_id#i#") and len(evaluate("attributes.asset_name#i#")) and len(evaluate("attributes.asset_id#i#"))>#evaluate("attributes.asset_id#i#")#<cfelse>NULL</cfif>,
								<cfif isdefined("attributes.acc_department_id") and len(attributes.acc_department_id)>#attributes.acc_department_id#<cfelse>NULL</cfif>,
								<cfif isdefined("attributes.acc_type_id") and len(attributes.acc_type_id)>#attributes.acc_type_id#<cfelse>NULL</cfif>,
								<cfif len(evaluate("attributes.avans_id#i#"))>#evaluate("attributes.avans_id#i#")#<cfelse>NULL</cfif>,
								<cfif isdefined("attributes.related_cari_action_id#i#") and len(evaluate("attributes.related_cari_action_id#i#"))>#evaluate("attributes.related_cari_action_id#i#")#<cfelse>NULL</cfif>
								<cfif len(session.ep.money2)>
									,#wrk_round((evaluate("attributes.action_value#i#") + evaluate("attributes.expense_amount#i#"))*dovizli_islem_multiplier/currency_multiplier,4)#
									,'#session.ep.money2#'
								</cfif>
							)
					</cfquery>		
					<cfquery name="get_act_id" datasource="#new_dsn2#">
						SELECT MAX(ACTION_ID) AS ACTION_ID FROM BANK_ACTIONS
					</cfquery>
					<!--- banka talimatlarından kaydedilen toplu gelen havale satirlari icin 1 set ediliyor --->
					<cfif isDefined("attributes.bank_order_id#i#") and len(evaluate("attributes.bank_order_id#i#"))>
						<cfquery name="UPD_BANK_ORDERS" datasource="#new_dsn2#">
							UPDATE BANK_ORDERS SET IS_PAID = 1 WHERE BANK_ORDER_ID = #evaluate("attributes.bank_order_id#i#")#
						</cfquery>
						<cfquery name="upd_cari" datasource="#new_dsn2#">
							UPDATE
								CARI_ROWS
							SET 
								IS_PROCESSED = 1
							WHERE 
								ACTION_ID = #evaluate("attributes.bank_order_id#i#")#
								AND ACTION_TYPE_ID = #bank_order_process_type#
						</cfquery>
					</cfif>
					<cfif isdefined("attributes.payment_ids")><!--- avans taleplerinden geliyor ise avans --->
						<cfif len(evaluate("attributes.avans_id#i#"))>
							<cfquery name="upd_cor_payment" datasource="#new_dsn2#">
								UPDATE 
									#dsn_alias#.CORRESPONDENCE_PAYMENT
								SET
									ACTION_ID = #get_act_id.ACTION_ID#,
									ACTION_TYPE_ID = 25,
									ACTION_PERIOD_ID = #new_period_id#
								WHERE
									ID = #evaluate("attributes.avans_id#i#")#
							</cfquery>
						</cfif>
					</cfif>
					<cfif isdefined("attributes.other_payment_ids")><!--- Taksitli avans taleplerinden geliyor ise avans --->
						<cfif len(evaluate("attributes.avans_id#i#"))>
							<cfquery name="upd_cor_other_payment" datasource="#new_dsn2#">
								UPDATE 
									#dsn_alias#.SALARYPARAM_GET_REQUESTS
								SET
									ACTION_ID = #get_act_id.ACTION_ID#,
									ACTION_TYPE_ID = 25
								WHERE
									SPGR_ID = #evaluate("attributes.avans_id#i#")#
							</cfquery>
						</cfif>
					</cfif>
					<cfscript>
						attributes.paper_no = wrk_eval("attributes.paper_number#i#");
						exp_center_id = exp_item_id = "";
						if(isDefined("attributes.row_exp_center_id#i#") and len(evaluate("attributes.row_exp_center_id#i#")) and isDefined("attributes.row_exp_center_name#i#") and len(evaluate("attributes.row_exp_center_name#i#"))) exp_center_id = evaluate("attributes.row_exp_center_id#i#");
						if(isDefined("attributes.row_exp_item_id#i#") and len(evaluate("attributes.row_exp_item_id#i#")) and isDefined("attributes.row_exp_item_name#i#") and len(evaluate("attributes.row_exp_item_name#i#"))) exp_item_id = evaluate("attributes.row_exp_item_id#i#");							
						to_cmp_id = '';
						to_consumer_id = '';
						to_employee_id = '';
						if (len(evaluate("action_company_id#i#")) and evaluate("member_type#i#") eq 'partner')
							to_cmp_id = comp_id;
						else if (len(evaluate("action_consumer_id#i#")) and evaluate("member_type#i#") eq 'consumer') 
							to_consumer_id = cons_id;
						else
							to_employee_id = emp_id;							
						
						if(isDefined("attributes.asset_id#i#") and len(evaluate("attributes.asset_name#i#")) and len(evaluate("attributes.asset_id#i#")))
							asset_id = evaluate("asset_id#i#");
						else
							asset_id = '';
					
						if(isDefined("attributes.special_definition_id#i#") and len(evaluate("attributes.special_definition_id#i#")))
							special_definition_id = evaluate("special_definition_id#i#");
						else
							special_definition_id = '';
						if(isDefined("attributes.subscription_id#i#") and len(evaluate("attributes.subscription_no#i#")) and len(evaluate("attributes.subscription_id#i#")))
							subscription_id = evaluate("subscription_id#i#");
						else
							subscription_id = '';
						if(get_process_type.is_cari eq 1)
						{

							carici(
								action_id : get_act_id.action_id,
								action_table : 'BANK_ACTIONS',
								islem_belge_no : evaluate("attributes.paper_number#i#"),
								workcube_process_type : 25,		
								process_cat : form.process_cat,	
								islem_tarihi : attributes.action_date,
								from_account_id : attributes.account_id,
								from_branch_id : branch_id_info,
								islem_tutari : evaluate("attributes.system_amount#i#"),
								action_currency : session.ep.money,
								action_detail : evaluate("attributes.action_detail#i#"),
								other_money_value : evaluate("attributes.action_value_other#i#"),
								other_money : listfirst(evaluate("attributes.money_id#i#"),';'),
								currency_multiplier : currency_multiplier,
								account_card_type : 13,
								subscription_id : iif((isdefined("subscription_id") and len(subscription_id)),subscription_id,de('')),
								acc_type_id : attributes.acc_type_id,
								islem_detay : UCase(getLang('main',423)),//GİDEN HAVALE
								due_date: attributes.action_date,
								project_id : evaluate("attributes.project_id#i#"),
								to_cmp_id : to_cmp_id,
								to_consumer_id : to_consumer_id,
								to_employee_id : to_employee_id,
								special_definition_id : special_definition_id,
								assetp_id : asset_id,
								rate2:paper_currency_multiplier,
								cari_db : new_dsn2
								);
						}
						if(len(exp_center_id) and len(exp_item_id) and evaluate("attributes.expense_amount#i#") gt 0)
						{
							butceci(
								action_id : get_act_id.action_id,
								muhasebe_db : new_dsn2,
								is_income_expense : false,
								process_type : 25,
								nettotal : wrk_round(evaluate("attributes.expense_amount#i#")*dovizli_islem_multiplier),
								other_money_value : evaluate("attributes.expense_amount#i#"),
								action_currency : attributes.currency_id,
								currency_multiplier : currency_multiplier,
								expense_date : attributes.action_date,
								expense_center_id : exp_center_id,
								expense_item_id : exp_item_id,
								detail :  UCase(getLang('main',2608)),//GİDEN HAVALE MASRAFI
								paper_no : evaluate("attributes.paper_number#i#"),
								project_id : evaluate("attributes.project_id#i#"),
								company_id : to_cmp_id,
								consumer_id : to_consumer_id,
								employee_id : to_employee_id,
								branch_id : branch_id_info,
								insert_type : 1
							);
						}
					</cfscript>
					<!--- Eğer talimattan geliyorsa talimatın bağlı olduğu ödeme emri kapatılıyor --->
					<cfif isDefined("attributes.bank_order_id#i#") and len(evaluate("attributes.bank_order_id#i#"))>
						<cfquery name="GET_BANK_ORDERS" datasource="#DSN2#">
							SELECT CLOSED_ID FROM BANK_ORDERS WHERE BANK_ORDER_ID = #evaluate("attributes.bank_order_id#i#")#
						</cfquery>
						<cfif len(get_bank_orders.closed_id)>
							<cfquery name="GET_CARI_INFO" datasource="#DSN2#">
								SELECT * FROM CARI_ROWS WHERE ACTION_ID = #get_act_id.action_id# AND ACTION_TYPE_ID = 25
							</cfquery>
							<cfif len(GET_CARI_INFO.recordcount)>
								<cfquery name="UPD_CLOSED" datasource="#DSN2#">
									INSERT INTO
										CARI_CLOSED_ROW
									(
										CLOSED_ID,
										CARI_ACTION_ID,
										ACTION_ID,
										ACTION_TYPE_ID,
										ACTION_VALUE,
										CLOSED_AMOUNT,
										OTHER_CLOSED_AMOUNT,
										P_ORDER_VALUE,
										OTHER_P_ORDER_VALUE,							
										OTHER_MONEY,
										DUE_DATE
									)
									VALUES
									(
										#get_bank_orders.closed_id#,
										#GET_CARI_INFO.CARI_ACTION_ID#,
										#get_act_id.action_id#,
										25,
										#GET_CARI_INFO.ACTION_VALUE#,
										#GET_CARI_INFO.ACTION_VALUE#,
										#GET_CARI_INFO.OTHER_CASH_ACT_VALUE#,
										#GET_CARI_INFO.ACTION_VALUE#,
										#GET_CARI_INFO.OTHER_CASH_ACT_VALUE#,
										<cfqueryparam cfsqltype="cf_sql_varchar" value="#GET_CARI_INFO.OTHER_MONEY#">,
										#createodbcdatetime(GET_CARI_INFO.DUE_DATE)#
									)
								</cfquery>
								<cfquery name="GET_MAX_C_ID" datasource="#DSN2#">
									SELECT MAX(CLOSED_ROW_ID) C_MAX_ID FROM CARI_CLOSED_ROW
								</cfquery>
								<cfquery name="GET_CLOSED" datasource="#DSN2#">
									SELECT P_ORDER_DEBT_AMOUNT_VALUE,P_ORDER_CLAIM_AMOUNT_VALUE FROM CARI_CLOSED WHERE CLOSED_ID = #get_bank_orders.closed_id#
								</cfquery>
								<cfquery name="UPD_CLOSED" datasource="#DSN2#">
									UPDATE
										CARI_CLOSED
									SET
										IS_CLOSED = 1,
									<cfif GET_CLOSED.P_ORDER_DEBT_AMOUNT_VALUE neq 0>
										DEBT_AMOUNT_VALUE = P_ORDER_DEBT_AMOUNT_VALUE,
										CLAIM_AMOUNT_VALUE = P_ORDER_DEBT_AMOUNT_VALUE,
									<cfelse>
										DEBT_AMOUNT_VALUE = P_ORDER_CLAIM_AMOUNT_VALUE,
										CLAIM_AMOUNT_VALUE = P_ORDER_CLAIM_AMOUNT_VALUE,
									</cfif>
										DIFFERENCE_AMOUNT_VALUE = 0
									WHERE
										CLOSED_ID = #get_bank_orders.closed_id#
								</cfquery>
								<cfquery name="UPD_CLOSED" datasource="#DSN2#">
									UPDATE
										CARI_CLOSED_ROW
									SET
										RELATED_CLOSED_ROW_ID = #GET_MAX_C_ID.C_MAX_ID#,
										CLOSED_AMOUNT = P_ORDER_VALUE,
										OTHER_CLOSED_AMOUNT = OTHER_P_ORDER_VALUE
									WHERE
										CLOSED_ID = #get_bank_orders.closed_id#
								</cfquery>
							</cfif>
						</cfif>
					</cfif>
				</cfif>
			</cfloop>
		</cfif>
		<cfscript>
			if(get_process_type.is_account eq 1)
			{
				borc_hesap_list='';
				alacak_hesap_list='';
				borc_tutar_list ='';
				paper_list = '';
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
							alacak_hesap_list = listappend(alacak_hesap_list,attributes.account_acc_code,',');
							alacak_tutar_list = listappend(alacak_tutar_list,evaluate("attributes.system_amount#j#"));
							doviz_tutar_alacak = listappend(doviz_tutar_alacak,evaluate("attributes.action_value#j#"));
							doviz_currency_alacak = listappend(doviz_currency_alacak,attributes.currency_id,',');
							if(is_account_group neq 1)
							{
								if (len(evaluate("attributes.action_detail#j#")))
									satir_detay_list[1][listlen(alacak_tutar_list)]='#evaluate("attributes.comp_name#j#")# - #evaluate("attributes.action_detail#j#")#';
								else
									satir_detay_list[1][listlen(alacak_tutar_list)]='#evaluate("attributes.comp_name#j#")# - ' & UCase(getLang('main',1758));
							}
							else
							{
								satir_detay_list[1][listlen(alacak_tutar_list)]=UCase(getLang('main',1758));
							}
							if(len(evaluate("action_company_id#j#")) and len(evaluate("member_type#j#")) and evaluate("member_type#j#") eq 'partner')
								my_acc_result = GET_COMPANY_PERIOD(from_cmp_id,new_period_id,new_dsn2,attributes.acc_type_id);
							else if(len(evaluate("action_consumer_id#j#")) and len(evaluate("member_type#j#")) and evaluate("member_type#j#") eq 'consumer')
								my_acc_result = GET_CONSUMER_PERIOD(from_consumer_id,new_period_id,new_dsn2,attributes.acc_type_id);
							else
								my_acc_result = GET_EMPLOYEE_PERIOD(from_employee_id,attributes.acc_type_id,new_dsn2,new_dsn3,new_period_id);
							borc_hesap_list = listappend(borc_hesap_list,my_acc_result,',');
							borc_tutar_list = listappend(borc_tutar_list,evaluate("attributes.system_amount#j#"));
							paper_list = listappend(paper_list,evaluate("attributes.paper_number#j#"));
							doviz_tutar_borc = listappend(doviz_tutar_borc,evaluate("attributes.action_value_other#j#"),',');
							doviz_currency_borc = listappend(doviz_currency_borc,listfirst(evaluate("attributes.money_id#j#"),';'),',');
							
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
									satir_detay_list[2][listlen(borc_tutar_list)]='#evaluate("attributes.comp_name#j#")# - #evaluate("attributes.action_detail#j#")#';
								else
									satir_detay_list[2][listlen(borc_tutar_list)]='#evaluate("attributes.comp_name#j#")# - ' & UCase(getLang('main',1758));
							}
							else
							{
								satir_detay_list[2][listlen(borc_tutar_list)]=UCase(getLang('main',1758));
							}
							//masraf varsa muhasebeciye ekleniyor
													
							if(evaluate("attributes.expense_amount#j#") gt 0 and len(exp_center_id) and len(exp_item_id))
							{
								GET_EXP_ACC = cfquery(datasource : "#new_dsn2#", sqlstring : "SELECT ACCOUNT_CODE FROM EXPENSE_ITEMS WHERE EXPENSE_ITEM_ID = #exp_item_id#");
								borc_hesap_list = ListAppend(borc_hesap_list,GET_EXP_ACC.ACCOUNT_CODE,",");	
								alacak_hesap_list = ListAppend(alacak_hesap_list,attributes.account_acc_code,",");	
									
								borc_tutar_list = ListAppend(borc_tutar_list,wrk_round(evaluate("attributes.expense_amount#j#")*dovizli_islem_multiplier),",");
								alacak_tutar_list = ListAppend(alacak_tutar_list,wrk_round(evaluate("attributes.expense_amount#j#")*dovizli_islem_multiplier),",");
								paper_list = listappend(paper_list,evaluate("attributes.paper_number#j#"));
								
								doviz_tutar_borc = ListAppend(doviz_tutar_borc,evaluate("attributes.expense_amount#j#"),",");
								doviz_currency_borc = ListAppend(doviz_currency_borc,attributes.currency_id,",");
								
								doviz_tutar_alacak = ListAppend(doviz_tutar_alacak,evaluate("attributes.expense_amount#j#"),",");
								doviz_currency_alacak = ListAppend(doviz_currency_alacak,attributes.currency_id,",");
								/* masraf icin project_id_list ekleniyor */
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
										satir_detay_list[1][listlen(alacak_tutar_list)]='#evaluate("attributes.comp_name#j#")# - #evaluate("attributes.action_detail#j#")#';
									else
										satir_detay_list[1][listlen(alacak_tutar_list)]='#evaluate("attributes.comp_name#j#")# - ' & UCase(getLang('main',1758));
	
									if (len(evaluate("attributes.action_detail#j#")))
										satir_detay_list[2][listlen(borc_tutar_list)]='#evaluate("attributes.comp_name#j#")# - #evaluate("attributes.action_detail#j#")#';
									else
										satir_detay_list[2][listlen(borc_tutar_list)]='#evaluate("attributes.comp_name#j#")# - ' & UCase(getLang('main',1758));
								}
								else
								{
									satir_detay_list[1][listlen(alacak_tutar_list)]=UCase(getLang('main',1758));
									satir_detay_list[2][listlen(borc_tutar_list)]=UCase(getLang('main',1758));
								}
							}
						}
				}
				muhasebeci (
					action_id:  MAX_ID.IDENTITYCOL,
					workcube_process_type: multi_type,
					workcube_process_cat:form.process_cat,
					account_card_type: 13,
					acc_department_id:acc_department_id,
					company_id: to_cmp_id,
					consumer_id:to_consumer_id,
					employee_id : to_employee_id,
					islem_tarihi: attributes.action_date,
					fis_satir_detay: satir_detay_list,
					borc_hesaplar: borc_hesap_list,
					borc_tutarlar: borc_tutar_list,
					other_amount_borc : doviz_tutar_borc,
					other_currency_borc : doviz_currency_borc,
					from_branch_id : branch_id_info,
					alacak_hesaplar: alacak_hesap_list,
					alacak_tutarlar: alacak_tutar_list,
					other_amount_alacak : doviz_tutar_alacak,
					other_currency_alacak : doviz_currency_alacak,
					currency_multiplier : currency_multiplier,
					fis_detay: UCase(getLang('main',1758)), //TOPLU GİDEN HAVALE
					is_account_group : is_account_group,
					acc_project_list_alacak : acc_project_list_alacak,
					acc_project_list_borc : acc_project_list_borc,
					muhasebe_db : new_dsn2,
					belge_no : attributes.paper_no,
					belge_no_satir : paper_list,
					is_acc_type : 1
				);
			}
		</cfscript>
		<cfloop from="1" to="#attributes.kur_say#" index="r">
			<cfquery name="ADD_ACTION_MONEY" datasource="#new_dsn2#">
				INSERT 
				INTO 
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
			<cfquery name="UPD_GENERAL_PAPERS" datasource="#new_dsn2#">
				UPDATE 
					#new_dsn3#.GENERAL_PAPERS
				SET
					OUTGOING_TRANSFER_NUMBER = #paper_number#
				WHERE
					OUTGOING_TRANSFER_NUMBER IS NOT NULL
			</cfquery>
		</cfif>
		<!--- banka talimatlarından kaydedilen toplu giden havale satirlari icin 1 set ediliyor --->
		<cfif isdefined("attributes.from_bank_orders_list") and len(attributes.from_bank_orders_list)>
			<cfquery name="UPD_BANK_ORDERS" datasource="#new_dsn2#">
				UPDATE BANK_ORDERS SET IS_PAID = 1 WHERE BANK_ORDER_ID IN (#attributes.from_bank_orders_list#)
			</cfquery>
		</cfif>
		<!--- onay ve uyarıların gelebilmesi icin action file sarti kaldirildi DT20141001 --->
        <cf_workcube_process_cat 
            process_cat="#form.process_cat#"
            action_id = #MAX_ID.IDENTITYCOL#
            is_action_file = 1
            action_db_type = '#new_dsn2#'
            action_page='#request.self#?fuseaction=#listGetAt(fuseaction,1,'.')#.form_add_gidenh&event=updMulti&multi_id=#MAX_ID.IDENTITYCOL#'
            action_file_name='#get_process_type.action_file_name#'
            is_template_action_file = '#get_process_type.action_file_from_template#'>
	</cftransaction>
</cflock>
<cfif isdefined("attributes.puantaj_id") or isdefined("attributes.payment_ids") or isdefined("attributes.from_assign_order")>
	<script type="text/javascript">
		wrk_opener_reload();
		window.close();
	</script>
<cfelse>
	<script type="text/javascript">
    	window.location.href="<cfoutput>#request.self#?fuseaction=bank.form_add_gidenh&event=updMulti&multi_id=#MAX_ID.IDENTITYCOL#</cfoutput>";
	</script>
</cfif>

