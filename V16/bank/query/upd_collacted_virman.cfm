<!--- Toplu Virman Guncelle Query --->
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
		IS_BUDGET,
		IS_ACCOUNT,
		ACTION_FILE_NAME,
		ACTION_FILE_FROM_TEMPLATE,
		MULTI_TYPE
	FROM 
	 	SETUP_PROCESS_CAT 
	WHERE 
		PROCESS_CAT_ID = #form.process_cat#
</cfquery>
<cfscript>
	multi_type = get_process_type.MULTI_TYPE;
	process_type = get_process_type.process_type;
	is_account = get_process_type.is_account;
	is_budget = get_process_type.is_budget;
	for(x=1; x lte attributes.record_num; x=x+1)
		if(evaluate("attributes.row_kontrol#x#") eq 1)
		{
			'attributes.action_value#x#' = filterNum(evaluate('attributes.action_value#x#'));
			'attributes.expense_amount#x#' = filterNum(evaluate('attributes.expense_amount#x#'));
		}
	for(y=1; y lte attributes.kur_say; y=y+1)
	{
		'attributes.txt_rate2_#y#' = filterNum(evaluate('attributes.txt_rate2_#y#'),session.ep.our_company_info.rate_round_num);
		'attributes.txt_rate1_#y#' = filterNum(evaluate('attributes.txt_rate1_#y#'),session.ep.our_company_info.rate_round_num);
	}
	if(isdefined("attributes.branch_id") and len(attributes.branch_id))
		branch_id_info = attributes.branch_id;
	else
		branch_id_info = listgetat(session.ep.user_location,2,'-');
</cfscript>
<cf_date tarih='attributes.action_date'>
<cf_papers paper_type="virman">

<cflock name="#createUUID()#" timeout="60">			
	<cftransaction>
		<cfquery name="upd_bank_actions_multi" datasource="#dsn2#">
			UPDATE
				BANK_ACTIONS_MULTI
			SET				
				PROCESS_CAT = #form.process_cat#,
				ACTION_TYPE_ID = #process_type#,
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
			if(isDefined('attributes.kur_say') and len(attributes.kur_say))
				for(mon=1;mon lte attributes.kur_say;mon=mon+1)
				{
					if( evaluate("attributes.hidden_rd_money_#mon#") is session.ep.money2)
						currency_multiplier = evaluate('attributes.txt_rate2_#mon#/attributes.txt_rate1_#mon#');
					if( evaluate("attributes.hidden_rd_money_#mon#") is money_type)
						currency_multiplier_other = evaluate('attributes.txt_rate2_#mon#/attributes.txt_rate1_#mon#');
				}
		</cfscript>
		<cfif isdefined("attributes.record_num") and len(attributes.record_num)>
			<cfloop from="1" to="#attributes.record_num#" index="i">
				<cfscript>
					from_account_id = listgetat(evaluate("attributes.from_account_id#i#"),1,';');
					to_account_id = listgetat(evaluate("attributes.to_account_id#i#"),1,';');
					currency_id = listgetat(evaluate("attributes.from_account_id#i#"),2,';');		//bankaya ait para birimi yani asil para birimi
					paper_currency_multiplier = '';													//asil para birimine ait katsayi
					if(isDefined('attributes.kur_say') and len(attributes.kur_say))
						for(mon=1;mon lte attributes.kur_say;mon=mon+1)
							if( evaluate("attributes.hidden_rd_money_#mon#") is currency_id)
								paper_currency_multiplier = evaluate('attributes.txt_rate2_#mon#/attributes.txt_rate1_#mon#');
				</cfscript>
				<!--- yeni eklenen satirlar --->
				<cfif isdefined("attributes.row_kontrol#i#") and evaluate("attributes.row_kontrol#i#") and not isdefined("attributes.act_row_id#i#")>
					<cfif len(paper_number)><cfset paper_number = paper_number + 1></cfif>
					<!--- from_account_id --->
					<cfquery name="add_virman_from" datasource="#dsn2#">
						INSERT INTO
							BANK_ACTIONS
							(
								MULTI_ACTION_ID,
								ACTION_TYPE,
								PROCESS_CAT,
								ACTION_TYPE_ID,
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
								MASRAF,
								EXPENSE_CENTER_ID,
								EXPENSE_ITEM_ID,
                                PROJECT_ID,
								RECORD_EMP,
								RECORD_IP,
								RECORD_DATE,
								FROM_BRANCH_ID,
								WITH_NEXT_ROW,
								SYSTEM_ACTION_VALUE,
								SYSTEM_CURRENCY_ID
								<cfif len(session.ep.money2)>
									,ACTION_VALUE_2
									,ACTION_CURRENCY_ID_2
								</cfif>		
							)
							VALUES
							(
								#attributes.multi_id#,
								'#UCase(getLang("main",2085))#',
								#attributes.process_cat#,
								230,
								#from_account_id#,
								<cfif isDefined("attributes.expense_amount#i#") and len(evaluate("attributes.expense_amount#i#"))>#evaluate("attributes.action_value#i#") + evaluate("attributes.expense_amount#i#")#<cfelse>#evaluate("attributes.action_value#i#")#</cfif>,
								#attributes.action_date#,
								<cfqueryparam cfsqltype="cf_sql_varchar" value="#currency_id#">,
								<cfif isDefined("attributes.action_detail#i#") and len(evaluate("attributes.action_detail#i#"))>'#wrk_eval("attributes.action_detail#i#")#'<cfelse>NULL</cfif>,
								#evaluate("attributes.action_value#i#")*paper_currency_multiplier/currency_multiplier_other#,
								'#money_type#',
								<cfif get_process_type.is_account eq 1>1,13,<cfelse>0,13,</cfif>
								<cfif isdefined("attributes.paper_number#i#") and len(evaluate("attributes.paper_number#i#"))>'#wrk_eval("attributes.paper_number#i#")#'<cfelse>NULL</cfif>,
								<cfif isDefined("attributes.expense_amount#i#") and len(evaluate("attributes.expense_amount#i#"))>#evaluate("attributes.expense_amount#i#")#<cfelse>NULL</cfif>,
								<cfif isDefined("attributes.expense_center_id#i#") and len(evaluate("attributes.expense_amount#i#")) and len(evaluate("attributes.expense_center_id#i#")) and len(evaluate("attributes.expense_center_name#i#"))>#evaluate("attributes.expense_center_id#i#")#<cfelse>NULL</cfif>,
								<cfif isDefined("attributes.expense_item_id#i#") and len(evaluate("attributes.expense_amount#i#")) and len(evaluate("attributes.expense_item_id#i#")) and len(evaluate("attributes.expense_center_id#i#"))>#evaluate("attributes.expense_item_id#i#")#<cfelse>NULL</cfif>,
                                <cfif isDefined("attributes.project_id#i#") and len(evaluate("attributes.project_id#i#"))>#evaluate("attributes.project_id#i#")#<cfelse>NULL</cfif>,
                                #SESSION.EP.USERID#,
								'#CGI.REMOTE_ADDR#',
								#NOW()#,
								#branch_id_info#,
								1,
								#wrk_round((evaluate("attributes.action_value#i#")+ evaluate("attributes.expense_amount#i#"))*paper_currency_multiplier)#,
								<cfqueryparam cfsqltype="cf_sql_varchar" value="#session.ep.money#">
								<cfif len(session.ep.money2)>
									,#wrk_round(((evaluate("attributes.action_value#i#")+ evaluate("attributes.expense_amount#i#"))*paper_currency_multiplier)/currency_multiplier,4)#
									,<cfqueryparam cfsqltype="cf_sql_varchar" value="#session.ep.money2#">
								</cfif>	
							)
					</cfquery>
					<!--- to_account_id --->
					<cfquery name="add_virman_to" datasource="#dsn2#">
						INSERT INTO
							BANK_ACTIONS
							(
								MULTI_ACTION_ID,
								ACTION_TYPE,
								PROCESS_CAT,
								ACTION_TYPE_ID,
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
								MASRAF,
                                PROJECT_ID,
								RECORD_EMP,
								RECORD_IP,
								RECORD_DATE,
								TO_BRANCH_ID,
								WITH_NEXT_ROW,
								SYSTEM_ACTION_VALUE,
								SYSTEM_CURRENCY_ID
								<cfif len(session.ep.money2)>
									,ACTION_VALUE_2
									,ACTION_CURRENCY_ID_2
								</cfif>		
							)
							VALUES
							(
								#attributes.multi_id#,
								'#UCase(getLang("main",2085))#',
								#attributes.process_cat#,
								#process_type#,
								#to_account_id#,
								#evaluate("attributes.action_value#i#")#,							
								#attributes.action_date#,
								<cfqueryparam cfsqltype="cf_sql_varchar" value="#currency_id#">,
								<cfif isDefined("attributes.action_detail#i#") and len(evaluate("attributes.action_detail#i#"))>'#wrk_eval("attributes.action_detail#i#")#'<cfelse>NULL</cfif>,
								#evaluate("attributes.action_value#i#")*paper_currency_multiplier/currency_multiplier_other#,
								'#money_type#',
								<cfif get_process_type.is_account eq 1>1,13,<cfelse>0,13,</cfif>
								<cfif isdefined("attributes.paper_number#i#") and len(evaluate("attributes.paper_number#i#"))>'#wrk_eval("attributes.paper_number#i#")#'<cfelse>NULL</cfif>,
								0,
                                <cfif isDefined("attributes.project_id#i#") and len(evaluate("attributes.project_id#i#"))>#evaluate("attributes.project_id#i#")#<cfelse>NULL</cfif>,
								#SESSION.EP.USERID#,
								'#CGI.REMOTE_ADDR#',
								#NOW()#,
								#branch_id_info#,
								0,
								#wrk_round(evaluate("attributes.action_value#i#")*paper_currency_multiplier)#,
								<cfqueryparam cfsqltype="cf_sql_varchar" value="#session.ep.money#">
								<cfif len(session.ep.money2)>
									,#wrk_round((evaluate("attributes.action_value#i#")*paper_currency_multiplier)/currency_multiplier,4)#
									,<cfqueryparam cfsqltype="cf_sql_varchar" value="#session.ep.money2#">
								</cfif>
							)
					</cfquery>
					<cfquery name="get_act_id" datasource="#dsn2#">
						SELECT MAX(ACTION_ID) AS ACTION_ID FROM BANK_ACTIONS
					</cfquery>
					<cfset bank_action_id = get_act_id.ACTION_ID-1>
					<cfscript>
						if(is_budget eq 1 and evaluate("attributes.expense_amount#i#") gt 0 and len(evaluate("attributes.expense_item_id#i#")) and len(evaluate("attributes.expense_item_name#i#")) and len(evaluate("attributes.expense_center_id#i#")) and len(evaluate("attributes.expense_center_name#i#")))
						{
							butceci(
								action_id : bank_action_id,
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
								detail : UCase(getLang('main',2728)), //TOPLU VİRMAN MASRAFI
								paper_no : evaluate("attributes.paper_number#i#"),
								branch_id : branch_id_info,
                                insert_type : 1,//banka vs den eklenen masraflar için farklı ekleme metodu tanımlar
                                project_id : evaluate("attributes.project_id#i#")
							);
						}		
					</cfscript>
				<!--- guncellenen satirlar --->
				<cfelseif isdefined("attributes.row_kontrol#i#") and evaluate("attributes.row_kontrol#i#") and isdefined("attributes.act_row_id#i#") and len(evaluate("attributes.act_row_id#i#"))>
					<!--- from_account_id --->
					<cfquery name="upd_virman_from" datasource="#dsn2#">
						UPDATE
							BANK_ACTIONS
						SET
							ACTION_FROM_ACCOUNT_ID = #from_account_id#,
							ACTION_VALUE = <cfif isDefined("attributes.expense_amount#i#") and len(evaluate("attributes.expense_amount#i#"))>#evaluate("attributes.action_value#i#") + evaluate("attributes.expense_amount#i#")#<cfelse>#evaluate("attributes.action_value#i#")#</cfif>,
							ACTION_DATE = #attributes.action_date#,
							ACTION_CURRENCY_ID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#currency_id#">,
							ACTION_DETAIL = <cfif isDefined("attributes.action_detail#i#") and len(evaluate("attributes.action_detail#i#"))>'#wrk_eval("attributes.action_detail#i#")#'<cfelse>NULL</cfif>,
							OTHER_CASH_ACT_VALUE = #evaluate("attributes.action_value#i#")*paper_currency_multiplier/currency_multiplier_other#,
							OTHER_MONEY = '#money_type#',
							IS_ACCOUNT = <cfif get_process_type.is_account eq 1>1<cfelse>0</cfif>,
							PAPER_NO = <cfif isdefined("attributes.paper_number#i#") and len(evaluate("attributes.paper_number#i#"))>'#wrk_eval("attributes.paper_number#i#")#'<cfelse>NULL</cfif>,
							MASRAF = <cfif isDefined("attributes.expense_amount#i#") and len(evaluate("attributes.expense_amount#i#"))>#evaluate("attributes.expense_amount#i#")#<cfelse>NULL</cfif>,
							EXPENSE_CENTER_ID = <cfif isDefined("attributes.expense_center_id#i#") and len(evaluate("attributes.expense_amount#i#")) and len(evaluate("attributes.expense_center_id#i#")) and len(evaluate("attributes.expense_center_name#i#"))>#evaluate("attributes.expense_center_id#i#")#<cfelse>NULL</cfif>,
							EXPENSE_ITEM_ID = <cfif isDefined("attributes.expense_item_id#i#") and len(evaluate("attributes.expense_amount#i#")) and len(evaluate("attributes.expense_item_id#i#")) and len(evaluate("attributes.expense_item_name#i#"))>#evaluate("attributes.expense_item_id#i#")#<cfelse>NULL</cfif>,
                            PROJECT_ID = <cfif isDefined("attributes.project_id#i#") and len(evaluate("attributes.project_id#i#"))>#evaluate("attributes.project_id#i#")#<cfelse>NULL</cfif>,
                            UPDATE_EMP = #SESSION.EP.USERID#,
							UPDATE_IP = '#CGI.REMOTE_ADDR#',
							UPDATE_DATE = #NOW()#,
							FROM_BRANCH_ID = #branch_id_info#,
							SYSTEM_ACTION_VALUE = <cfif isDefined("attributes.expense_amount#i#") and len(evaluate("attributes.expense_amount#i#"))>#wrk_round((evaluate("attributes.action_value#i#")+ evaluate("attributes.expense_amount#i#"))*paper_currency_multiplier)#<cfelse>#wrk_round(evaluate("attributes.action_value#i#")*paper_currency_multiplier)#</cfif>,
							SYSTEM_CURRENCY_ID =  <cfqueryparam cfsqltype="cf_sql_varchar" value="#session.ep.money#">
							<cfif len(session.ep.money2)>
								,ACTION_VALUE_2 = <cfif isDefined("attributes.expense_amount#i#") and len(evaluate("attributes.expense_amount#i#"))>#wrk_round(((evaluate("attributes.action_value#i#")+ evaluate("attributes.expense_amount#i#"))*paper_currency_multiplier)/currency_multiplier,4)#<cfelse>#wrk_round((evaluate("attributes.action_value#i#")*paper_currency_multiplier)/currency_multiplier,4)#</cfif>
								,ACTION_CURRENCY_ID_2 = <cfqueryparam cfsqltype="cf_sql_varchar" value="#session.ep.money2#">
							</cfif>	
						WHERE
							MULTI_ACTION_ID = #attributes.multi_id# AND
							ACTION_ID = #evaluate("attributes.act_row_id#i#")#
					</cfquery>
					<!--- to_account_id --->
					<cfquery name="upd_virman_to" datasource="#dsn2#">
						UPDATE
							BANK_ACTIONS
						SET
							ACTION_TO_ACCOUNT_ID = #to_account_id#,
							ACTION_VALUE = #evaluate("attributes.action_value#i#")#,
							ACTION_DATE = #attributes.action_date#,
							ACTION_CURRENCY_ID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#currency_id#">,
							ACTION_DETAIL = <cfif isDefined("attributes.action_detail#i#") and len(evaluate("attributes.action_detail#i#"))>'#wrk_eval("attributes.action_detail#i#")#'<cfelse>NULL</cfif>,
							OTHER_CASH_ACT_VALUE = #evaluate("attributes.action_value#i#")*paper_currency_multiplier/currency_multiplier_other#,
							OTHER_MONEY = '#money_type#',
							IS_ACCOUNT = <cfif get_process_type.is_account eq 1>1<cfelse>0</cfif>,
							PAPER_NO = <cfif isdefined("attributes.paper_number#i#") and len(evaluate("attributes.paper_number#i#"))>'#wrk_eval("attributes.paper_number#i#")#'<cfelse>NULL</cfif>,
							MASRAF = 0,
                            PROJECT_ID = <cfif isDefined("attributes.project_id#i#") and len(evaluate("attributes.project_id#i#"))>#evaluate("attributes.project_id#i#")#<cfelse>NULL</cfif>,
							UPDATE_EMP = #SESSION.EP.USERID#,
							UPDATE_IP = '#CGI.REMOTE_ADDR#',
							UPDATE_DATE = #NOW()#,
							TO_BRANCH_ID = #branch_id_info#,
							SYSTEM_ACTION_VALUE =#wrk_round(evaluate("attributes.action_value#i#")*paper_currency_multiplier)#,
							SYSTEM_CURRENCY_ID =  <cfqueryparam cfsqltype="cf_sql_varchar" value="#session.ep.money#">
							<cfif len(session.ep.money2)>
								,ACTION_VALUE_2 = #wrk_round((evaluate("attributes.action_value#i#")*paper_currency_multiplier)/currency_multiplier,4)#
								,ACTION_CURRENCY_ID_2 = <cfqueryparam cfsqltype="cf_sql_varchar" value="#session.ep.money2#">
							</cfif>	
						WHERE
							MULTI_ACTION_ID = #attributes.multi_id# AND
							ACTION_ID = #evaluate("attributes.act_row_id#i#")+1#
					</cfquery>
					<cfscript>
						butce_sil(action_id:evaluate("attributes.act_row_id#i#"),process_type:process_type);
						if(is_budget eq 1 and evaluate("attributes.expense_amount#i#") gt 0 and len(evaluate("attributes.expense_item_id#i#")) and len(evaluate("attributes.expense_item_name#i#")) and len(evaluate("attributes.expense_center_id#i#")) and len(evaluate("attributes.expense_center_name#i#")))
						{
							butceci(
								action_id : evaluate("attributes.act_row_id#i#"),
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
								detail : UCase(getLang('main',2728)), //TOPLU VİRMAN MASRAFI
								paper_no : evaluate("attributes.paper_number#i#"),
								branch_id : branch_id_info,
                                insert_type : 1,//banka vs den eklenen masraflar için farklı ekleme metodu tanımlar
                                project_id : evaluate("attributes.project_id#i#")
							);
						}	
					</cfscript>
				<!--- silinen satirlar --->
				<cfelseif isdefined("attributes.row_kontrol#i#") and evaluate("attributes.row_kontrol#i#") eq 0 and isdefined("attributes.act_row_id#i#") and len(evaluate("attributes.act_row_id#i#"))>
					<cfquery name="del_revenue_from" datasource="#dsn2#">
						DELETE FROM BANK_ACTIONS WHERE MULTI_ACTION_ID = #attributes.multi_id# AND ACTION_ID = #evaluate("attributes.act_row_id#i#")#
					</cfquery>
					<cfquery name="del_revenue_to" datasource="#dsn2#">
						DELETE FROM BANK_ACTIONS WHERE MULTI_ACTION_ID = #attributes.multi_id# AND ACTION_ID = #evaluate("attributes.act_row_id#i#")+1#
					</cfquery>
					<cfscript>
						butce_sil(action_id:evaluate("attributes.act_row_id#i#"),process_type:process_type);
					</cfscript>
				</cfif>
				<cfif isdefined("attributes.row_kontrol#i#") and evaluate("attributes.row_kontrol#i#")>
					<cfscript>
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
								satir_detay_list[1][listlen(str_alacakli_tutarlar)] = UCase(getLang('main',2085));// TOPLU VİRMAN
							else
								satir_detay_list[1][listlen(str_alacakli_tutarlar)] = UCase(getLang('main',2729));//DÖVİZLİ TOPLU VİRMAN
								
							str_borclu_hesaplar = ListAppend(str_borclu_hesaplar,account_acc_code2,",");
							str_borclu_tutarlar = ListAppend(str_borclu_tutarlar,evaluate("attributes.action_value#i#")*paper_currency_multiplier,",");
							str_borclu_other_amount_tutar = ListAppend(str_borclu_other_amount_tutar,evaluate("attributes.action_value#i#"),",");
							str_borclu_other_currency = ListAppend(str_borclu_other_currency,currency_id,",");
							if(isDefined("attributes.action_detail#i#") and len(evaluate("attributes.action_detail#i#")))
								satir_detay_list[2][listlen(str_borclu_tutarlar)] = '#evaluate("attributes.action_detail#i#")#';
							else if(currency_id is session.ep.money)
								satir_detay_list[2][listlen(str_borclu_tutarlar)] = UCase(getLang('main',2085));// TOPLU VİRMAN
							else
								satir_detay_list[2][listlen(str_borclu_tutarlar)] = UCase(getLang('main',2729));//DÖVİZLİ TOPLU VİRMAN

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
							
							if(len(evaluate("attributes.expense_amount#i#")) and evaluate("attributes.expense_amount#i#") gt 0)
							{
								GET_EXP_ACC = cfquery(datasource : "#dsn2#", sqlstring : "SELECT ACCOUNT_CODE FROM EXPENSE_ITEMS WHERE EXPENSE_ITEM_ID = #evaluate("attributes.expense_item_id#i#")#");
								str_alacakli_hesaplar = ListAppend(str_alacakli_hesaplar,account_acc_code,",");	
								str_alacakli_tutarlar = ListAppend(str_alacakli_tutarlar,wrk_round(evaluate("attributes.expense_amount#i#")*paper_currency_multiplier),",");
								str_alacakli_other_amount_tutar = ListAppend(str_alacakli_other_amount_tutar,evaluate("attributes.expense_amount#i#"),",");
								str_alacakli_other_currency = ListAppend(str_alacakli_other_currency,currency_id,",");
								if(isDefined("attributes.action_detail#i#") and len(evaluate("attributes.action_detail#i#")))
									satir_detay_list[1][listlen(str_alacakli_tutarlar)] = '#evaluate("attributes.action_detail#i#")#';
								else if(currency_id is session.ep.money)
									satir_detay_list[1][listlen(str_alacakli_tutarlar)] = UCase(getLang('main',2085));// TOPLU VİRMAN
								else
									satir_detay_list[1][listlen(str_alacakli_tutarlar)] = UCase(getLang('main',2729));//DÖVİZLİ TOPLU VİRMAN
	
								str_borclu_hesaplar = ListAppend(str_borclu_hesaplar,GET_EXP_ACC.ACCOUNT_CODE,",");	
								str_borclu_tutarlar = ListAppend(str_borclu_tutarlar,wrk_round(evaluate("attributes.expense_amount#i#")*paper_currency_multiplier),",");
								str_borclu_other_amount_tutar = ListAppend(str_borclu_other_amount_tutar,evaluate("attributes.expense_amount#i#"),",");
								str_borclu_other_currency = ListAppend(str_borclu_other_currency,currency_id,",");
								if(isDefined("attributes.action_detail#i#") and len(evaluate("attributes.action_detail#i#")))
									satir_detay_list[2][listlen(str_borclu_tutarlar)] = '#evaluate("attributes.action_detail#i#")#';
								else if(currency_id is session.ep.money)
									satir_detay_list[2][listlen(str_borclu_tutarlar)] = UCase(getLang('main',2085));// TOPLU VİRMAN
								else
									satir_detay_list[2][listlen(str_borclu_tutarlar)] = UCase(getLang('main',2729));//DÖVİZLİ TOPLU VİRMAN
									
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
					</cfscript>
				</cfif>
			</cfloop>
			<cfscript>
				if(is_account eq 1)
				{
					muhasebeci(
						action_id : attributes.multi_id,
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
						currency_multiplier : currency_multiplier,
						fis_detay : UCase(getLang('main',2085)),// TOPLU VİRMAN
						from_branch_id : branch_id_info,
                        to_branch_id : branch_id_info,
                        acc_project_list_alacak : acc_project_list_alacak,
                        acc_project_list_borc : acc_project_list_borc,
						belge_no : attributes.multi_id
					);
				}
				else
					muhasebe_sil(action_id:attributes.multi_id,process_type:form.old_process_multi_type);
			</cfscript>
		</cfif>
		<cfquery name="del_action_money" datasource="#dsn2#">
			DELETE FROM BANK_ACTION_MULTI_MONEY WHERE ACTION_ID = #attributes.multi_id#
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
						VIRMAN_NUMBER = #paper_number-1#
					WHERE
						VIRMAN_NUMBER IS NOT NULL
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
            action_page='#request.self#?fuseaction=bank.form_add_virman&event=updMulti&multi_id=#attributes.multi_id#'
            action_file_name='#get_process_type.action_file_name#'
            is_template_action_file = '#get_process_type.action_file_from_template#'>
	</cftransaction>
</cflock>
<cfset attributes.actionId=attributes.multi_id>
<script type="text/javascript">
	window.location.href='<cfoutput>#request.self#?fuseaction=#nextEvent##attributes.multi_id#</cfoutput>';
</script>