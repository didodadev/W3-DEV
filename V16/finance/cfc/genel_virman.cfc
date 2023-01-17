<cfcomponent extends="cfc.faFunctions">
    <cfscript>
		functions = CreateObject("component","WMO.functions");
		cfquery = functions.cfquery;
		wrk_round = functions.wrk_round;
		sql_unicode = functions.sql_unicode;
		getLang = functions.getLang;
		wrk_eval = functions.wrk_eval;
		TLFormat = functions.TLFormat;
		ListDeleteDuplicates = functions.ListDeleteDuplicates;
		get_company_period = functions.get_company_period;
		get_consumer_period = functions.get_consumer_period;
		get_employee_period = functions.get_employee_period;
		
		dsn = application.systemParam.systemParam().dsn;
		dsn3="#dsn#_#session.ep.company_id#";
		dsn2="#dsn#_#session.ep.period_year#_#session.ep.company_id#";
		dsn_alias = dsn;
		dsn2_alias="#dsn#_#session.ep.period_year#_#session.ep.company_id#";
		dsn3_alias="#dsn#_#session.ep.company_id#";
		workcube_mode = application.systemParam.systemParam().workcube_mode;
		fusebox.process_tree_control = application.systemParam.systemParam().fusebox.process_tree_control;
		dir_seperator = application.systemParam.systemParam().dir_seperator;
		attributes.fuseaction = 'finance.list_genel_virman';
		fusebox.fuseaction = attributes.fuseaction ;
		fusebox.circuit = listfirst(attributes.fuseaction,'.');
	</cfscript>

	<cffunction name="add_genel_virman" access="remote">
		<cfquery name="control_paper_no" datasource="#dsn2#">
			SELECT VIRMAN_NO FROM GENEL_VIRMAN WHERE VIRMAN_NO = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.virman_no#">
		</cfquery>
		<cfif control_paper_no.recordcount>
			<script type="text/javascript">
				alert("<cf_get_lang_main no ='710.Girdiğiniz Belge Numarası Kullanılmaktadır'>!");
				history.back();	
			</script>
			<cfabort>
		</cfif>
		<cf_papers paper_type="virman">
	 	<cfquery name="get_process_type" datasource="#dsn3#">
			SELECT 
				PROCESS_TYPE,
				IS_CARI,
				IS_ACCOUNT,
				IS_BUDGET,
				ACTION_FILE_NAME,
				ACTION_FILE_FROM_TEMPLATE,
				IS_ACCOUNT_GROUP
			FROM 
				SETUP_PROCESS_CAT 
			WHERE 
				PROCESS_CAT_ID = #form.process_cat#
		</cfquery>
		<cfscript>
			is_cari = get_process_type.is_cari;
			is_account = get_process_type.is_account;
			is_budget = get_process_type.is_budget;
		</cfscript>
		<cftransaction>
        	<cf_date tarih='form.expense_date'>
			<cfset to_branch_id = listGetAt(session.ep.user_location,2,"-")>
            <cfset rd_money_value = listfirst(form.rd_money,',')>
            <cfquery name="add_virman_new" datasource="#dsn2#">
                INSERT 
				INTO 
					GENEL_VIRMAN 
					( 
						VIRMAN_NO,
						VIRMAN_DETAIL,
						VIRMAN_DATE,
						VIRMAN_EMP,
						OTHER_MONEY,
						RECORD_DATE,
						RECORD_EMP,
						RECORD_IP,
						PROCESS_CAT,
						PROCESS_TYPE,
						PROCESS_STAGE
					)
					VALUES
					(
						'#form.virman_no#',
						<cfif len(form.expense_detail)>'#form.expense_detail#'<cfelse>'GENEL AMAÇLI VİRMAN'</cfif>,
						#form.expense_date#,
						<cfif len(form.expense_employee_id) and len(form.expense_employee)>#form.expense_employee_id#<cfelse>NULL</cfif>,
					   '#rd_money_value#',
						#now()#,
						#session.ep.userid#,
					   '#cgi.remote_addr#',
						#form.process_cat#,
						#get_process_type.process_type#,
						#form.process_stage#
					)
            </cfquery>
        	    <cfquery name="get_max_id" datasource="#dsn2#">
                SELECT MAX(VIRMAN_ID) AS VIRMAN_ID FROM GENEL_VIRMAN
            </cfquery>
            <cfscript>
				borc_hesap_list = '';
				alacak_hesap_list = '';
				borc_tutar_list ='';
				alacak_tutar_list = '';
				doviz_tutar_borc = '';
				doviz_tutar_alacak = '';
				doviz_currency_borc = '';
				doviz_currency_alacak = '';
				acc_project_list_borc = '';
				acc_project_list_alacak = '';
				satir_detay_list = ArrayNew(2);
				acc_department_id = '';
				aktif_row_b_no = 1;
				aktif_row_a_no = 1;
			</cfscript>
            <cfloop from="1" to="#record_num#" index="i">
				<cfif evaluate("row_kontrol#i#")>
					<cfscript>
                        form_wrk_row_id = evaluate("wrk_row_id#i#");
                        form_ba = evaluate("ba#i#");
                        form_action_type = evaluate("action_type#i#");
                        form_kasa = evaluate("kasa#i#");
                        form_banka = evaluate("banka#i#");
                        
						from_member_type = evaluate("ch_member_type#i#");
						if(form_action_type eq 3){
							if(listlen(evaluate("ch_member_id#i#"),'_') eq 2)
							{
								from_ch_acc_type_id = listlast(evaluate("ch_member_id#i#"),'_');
								form_ch_member_id = listfirst(evaluate("ch_member_id#i#"),'_');
							}else{
								form_ch_member_id = evaluate("ch_member_id#i#");
								from_ch_acc_type_id = -1;
							}
						}else{
							form_ch_member_id = "";
							from_ch_acc_type_id = "";
						}

                        form_ch_member = form_ch_member_id;
                        
						form_ch_account_code = evaluate("ch_account_code#i#");
						if(form_action_type eq 3){
							if(from_member_type eq "partner" and len(form_ch_member_id)){
								form_ch_account_code = get_company_period(form_ch_member_id,session.ep.period_id,dsn2,from_ch_acc_type_id);
							}else if(from_member_type eq "consumer" and len(form_ch_member_id)){
								form_ch_account_code = get_consumer_period(form_ch_member_id,session.ep.period_id,dsn2,from_ch_acc_type_id);
							}else if (from_member_type eq "employee" and len(form_ch_member_id)){
								form_ch_account_code = get_employee_period(form_ch_member_id,from_ch_acc_type_id);
							}
						}

                        form_row_detail = evaluate("row_detail#i#");
                        form_expense_center_id = evaluate("expense_center_id#i#");
						form_expense_center_name=evaluate("expense_center_name#i#");
                        form_expense_item_id = evaluate("expense_item_id#i#");
						form_expense_item_name=evaluate("expense_item_name#i#");
                        form_account_code = evaluate("account_code#i#");
                        form_quantity = evaluate("quantity#i#");
                        form_total = evaluate("net_total#i#"); //kdv ayrı hesaba yazılacaksa total alanı alınmalı
                        /* form_tax_rate = evaluate("tax_rate#i#");
                        form_otv_rate = evaluate("otv_rate#i#");
                        form_kdv_total = evaluate("kdv_total#i#");
                        form_otv_total = evaluate("otv_total#i#"); */
                        form_net_total = evaluate("net_total#i#");
                        form_money_id = evaluate("money_id#i#");
                        form_other_net_total = evaluate("other_net_total#i#");
						form_new_net_total=form_other_net_total;
                        form_project_id = evaluate("project_id#i#");
				
						form_cut_id = listgetat(form_money_id,1);
						form_rate1_= listgetat(form_money_id,2);
						form_rate2_= listgetat(form_money_id,3);
				
						if(form_action_type==2)
						{
							form_cut_kasa = form_kasa.substring(0,form_kasa.indexof(";"));
						}		
                    </cfscript>
                    <cfif form_action_type eq 1>
                        <!--- Banka --->
                        <cfquery name="GET_ACC_DETAIL" datasource="#DSN2#">
                            SELECT ACCOUNT_ACC_CODE, ACCOUNT_CURRENCY_ID FROM #dsn3_alias#.ACCOUNTS WHERE ACCOUNT_ID = #form_banka#
                        </cfquery>
                        <cfscript>
							if(form_ba eq 0)
							{
								borc_hesap_list= listappend(borc_hesap_list,GET_ACC_DETAIL.ACCOUNT_ACC_CODE);
								borc_tutar_list =listappend(borc_tutar_list,form_total);
								doviz_tutar_borc = listappend(doviz_tutar_borc,form_other_net_total);	
								doviz_currency_borc = listappend(doviz_currency_borc,form_cut_id);
								if(len(form_project_id))
									acc_project_list_borc = listappend(acc_project_list_borc,form_project_id);
								else
									acc_project_list_borc = listappend(acc_project_list_borc,0);
								satir_detay_list[1][aktif_row_b_no] = form_row_detail;
								aktif_row_b_no = aktif_row_b_no +1;
								//satir_detay_list[2][aktif_row_no] = form_row_detail;
							}
							else
							{
								alacak_hesap_list= listappend(alacak_hesap_list,GET_ACC_DETAIL.ACCOUNT_ACC_CODE);
								alacak_tutar_list =listappend(alacak_tutar_list,form_total);
								doviz_tutar_alacak = listappend(doviz_tutar_alacak,form_other_net_total);	
								doviz_currency_alacak = listappend(doviz_currency_alacak,form_cut_id);
								if(len(form_project_id))
									acc_project_list_alacak = listappend(acc_project_list_alacak,form_project_id);
								else
									acc_project_list_alacak = listappend(acc_project_list_alacak,0);
								satir_detay_list[2][aktif_row_a_no] = form_row_detail;
								aktif_row_a_no = aktif_row_a_no +1;
							}
						</cfscript>
                        <cfquery name="add_gelenh" datasource="#dsn2#">
							INSERT 
							INTO
								BANK_ACTIONS
								(
									PROCESS_CAT,
									GENEL_VIRMAN_ID,
									ACTION_TYPE,
									ACTION_TYPE_ID,
									<cfif form_ba eq 0>ACTION_TO_ACCOUNT_ID<cfelse>ACTION_FROM_ACCOUNT_ID</cfif>,
									ACTION_VALUE,
									ACTION_CURRENCY_ID,
									ACTION_DATE,
									ACTION_DETAIL,
									OTHER_CASH_ACT_VALUE,
									OTHER_MONEY,
									IS_ACCOUNT,
									IS_ACCOUNT_TYPE,
									PAPER_NO,
									PROJECT_ID, 
									RECORD_EMP,
									RECORD_IP,
									RECORD_DATE,
									SYSTEM_ACTION_VALUE,
									SYSTEM_CURRENCY_ID
								)
								VALUES
								(
									#form.process_cat#,
									#get_max_id.virman_id#,
								   'GENEL AMAÇLI VİRMAN',
								    #get_process_type.process_type#,
									#form_banka#,
									<cfif GET_ACC_DETAIL.ACCOUNT_CURRENCY_ID is 'TL'>
									#form_net_total#,
									'TL',
									<cfelse>
									#form_other_net_total#,
									'#form_cut_id#',
									</cfif>
									#form.expense_date#,
								   '#form_row_detail#',
								   '#form_other_net_total#',
								   '#form_cut_id#',
									0,
									0,
									'#form.virman_no#',
									<cfif len(form_project_id)>#form_project_id#<cfelse>null</cfif>,
									#session.ep.userid#,
								   '#cgi.remote_addr#',
									#now()#,
								<cfif session.ep.money eq 'TL'>
									#form_net_total#,
									'TL'
								<cfelse>
									#form_other_net_total#,
								   '#form_cut_id#'
								</cfif>
								)
						</cfquery>	
                        <!--- Banka --->
                    <cfelseif form_action_type eq 2>
                    	<!--- Kasa --->
                        <cfquery name="GET_CASH_DETAIL" datasource="#DSN2#">
                            SELECT CASH_ACC_CODE, CASH_CURRENCY_ID FROM CASH WHERE CASH_ID = #form_cut_kasa#
                        </cfquery>
                        <cfscript>
							if(form_ba eq 0)
							{
								borc_hesap_list= listappend(borc_hesap_list,GET_CASH_DETAIL.CASH_ACC_CODE);
								borc_tutar_list =listappend(borc_tutar_list,form_total);
								doviz_tutar_borc = listappend(doviz_tutar_borc,form_other_net_total);	
								doviz_currency_borc = listappend(doviz_currency_borc,form_cut_id);
								if(len(form_project_id))
									acc_project_list_borc = listappend(acc_project_list_borc,form_project_id);
								else
									acc_project_list_borc = listappend(acc_project_list_borc,0);
								satir_detay_list[1][aktif_row_b_no] = form_row_detail;
								aktif_row_b_no = aktif_row_b_no +1;
							}
							else
							{
								alacak_hesap_list= listappend(alacak_hesap_list,GET_CASH_DETAIL.CASH_ACC_CODE);
								alacak_tutar_list =listappend(alacak_tutar_list,form_total);
								doviz_tutar_alacak = listappend(doviz_tutar_alacak,form_other_net_total);	
								doviz_currency_alacak = listappend(doviz_currency_alacak,form_cut_id);
								if(len(form_project_id))
									acc_project_list_alacak = listappend(acc_project_list_alacak,form_project_id);
								else
									acc_project_list_alacak = listappend(acc_project_list_alacak,0);
								satir_detay_list[2][aktif_row_a_no] = form_row_detail;
								aktif_row_a_no = aktif_row_a_no +1;
							}
						</cfscript>
                        <cfquery name="ADD_CASH_PAYMENT" datasource="#dsn2#">
                        	INSERT 
							INTO
								CASH_ACTIONS
								(   
									PROCESS_CAT,
									GENEL_VIRMAN_ID,
									PAPER_NO,
									ACTION_TYPE,
									ACTION_TYPE_ID, 
									<cfif form_ba eq 0>CASH_ACTION_TO_CASH_ID<cfelse>CASH_ACTION_FROM_CASH_ID</cfif>,
									ACTION_DATE,
									CASH_ACTION_VALUE,
									CASH_ACTION_CURRENCY_ID,
									OTHER_CASH_ACT_VALUE,
									OTHER_MONEY,
									PROJECT_ID,
									ACTION_DETAIL,
									IS_ACCOUNT,
									IS_ACCOUNT_TYPE,
									RECORD_EMP,
									RECORD_IP,
									RECORD_DATE,
									ACTION_VALUE
								)
								VALUES
								(
									#form.process_cat#,
									#get_max_id.virman_id#,
								   '#form.virman_no#',
								   'GENEL AMAÇLI VİRMAN',
									#get_process_type.process_type#,
									#form_cut_kasa#,
									#form.expense_date#,
									<cfif GET_CASH_DETAIL.CASH_CURRENCY_ID is 'TL'>
									#form_net_total#,
									'TL',
									<cfelse>
									#form_other_net_total#,
								   '#form_cut_id#',
									</cfif>
								   '#form_other_net_total#',
								   '#form_cut_id#',
									<cfif len(form_project_id)>#form_project_id#<cfelse>null</cfif>,
									'#form_row_detail#',
									0,
									0,
									#session.ep.userid#,
								   '#cgi.remote_addr#',
									#now()#,
									#form_net_total#
								)
                    	</cfquery>
                        <!--- Kasa --->
                    <cfelseif form_action_type eq 3> 
                        <!--- Cari --->
                        <cfquery name="ADD_CASH_PAYMENT_IN_OP" datasource="#dsn2#">
                        	INSERT 
							INTO
								CARI_ACTIONS
								(
									MULTI_ACTION_ID,
									PAPER_NO,
									PROCESS_CAT,
									ACTION_NAME,
									ACTION_TYPE_ID,
									ACTION_VALUE,
									ACTION_CURRENCY_ID,
									OTHER_MONEY,
									<cfif form_ba eq 0>PROJECT_ID,<cfelse>PROJECT_ID_2,</cfif>
									OTHER_CASH_ACT_VALUE,
									<cfif form_ba eq 0>
									<cfif from_member_type eq "partner">TO_CMP_ID<cfelseif from_member_type eq "consumer">TO_CONSUMER_ID<cfelse>TO_EMPLOYEE_ID</cfif>,
										ACC_TYPE_ID,								
									<cfelse>
										<cfif from_member_type eq "partner">FROM_CMP_ID<cfelseif from_member_type eq "consumer">FROM_CONSUMER_ID<cfelse>FROM_EMPLOYEE_ID</cfif>,
										FROM_ACC_TYPE_ID,
									</cfif>
									ACTION_DETAIL,
									ACTION_DATE,
									RECORD_DATE,
									RECORD_EMP,
									RECORD_IP
								)
								VALUES
								(
									#get_max_id.virman_id#,
									'#form.virman_no#',
									#form.process_cat#,
									'GENEL AMAÇLI VİRMAN',
									#get_process_type.process_type#,
									#form_net_total#,
									'TL',
									'#form_cut_id#',
									<cfif len(form_project_id)>#form_project_id#<cfelse>null</cfif>,
									'#form_other_net_total#',
									#form_ch_member_id#,
									<cfif len(from_ch_acc_type_id)>#from_ch_acc_type_id#<cfelse>NULL</cfif>,
									'#form_row_detail#',
									#form.expense_date#,
									#now()#,
									#session.ep.userid#,
									'#cgi.remote_addr#'
								)
						</cfquery>
						<cfscript>
							if (is_cari eq 1){
							if(form_ba eq 0)
							{
								if(from_member_type eq "partner")
								{
									carici(
										action_id : get_max_id.virman_id,
										islem_belge_no : '#form.virman_no#',
										process_cat : form.process_cat,
										workcube_process_type : -41,
										action_table : 'CARI_ACTIONS',
										islem_tutari : form_net_total,
										action_currency : 'TL',
										other_money_value : form_other_net_total,
										other_money : form_cut_id,
										islem_tarihi : form.expense_date,
										islem_detay : 'GENEL AMAÇLI VİRMAN BORÇ',
										acc_type_id : from_ch_acc_type_id,
										action_detail : form_row_detail,
										to_cmp_id : form_ch_member_id,
										account_card_type : 13,
										project_id : form_project_id,
										rate1 : form_rate1_,
										rate2 : form_rate2_,
										period_is_integrated : 1,
										cari_db : dsn2,
										cari_db_alias : dsn2_alias
									);
								}else if(from_member_type eq "consumer")
								{
									carici(
										action_id : get_max_id.virman_id,
										islem_belge_no : '#form.virman_no#',
										process_cat : form.process_cat,
										workcube_process_type : -41,
										action_table : 'CARI_ACTIONS',
										islem_tutari : form_net_total,
										action_currency : 'TL',
										other_money_value : form_other_net_total,
										other_money : form_cut_id,
										islem_tarihi : form.expense_date,
										islem_detay : 'GENEL AMAÇLI VİRMAN BORÇ',
										acc_type_id : from_ch_acc_type_id,
										action_detail : form_row_detail,
										to_consumer_id : form_ch_member_id,
										account_card_type : 13,
										project_id : form_project_id,
										rate1 : form_rate1_,
										rate2 : form_rate2_,
										period_is_integrated : 1,
										cari_db : dsn2,
										cari_db_alias : dsn2_alias
									);
								}
								else
								{
									carici(
										action_id : get_max_id.virman_id,
										islem_belge_no : '#form.virman_no#',
										process_cat : form.process_cat,
										workcube_process_type : -41,
										action_table : 'CARI_ACTIONS',
										islem_tutari : form_net_total,
										action_currency : 'TL',
										other_money_value : form_other_net_total,
										other_money : form_cut_id,
										islem_tarihi : form.expense_date,
										islem_detay : 'GENEL AMAÇLI VİRMAN BORÇ',
										acc_type_id : from_ch_acc_type_id,
										action_detail : form_row_detail,
										to_employee_id : form_ch_member_id,
										account_card_type : 13,
										project_id : form_project_id,
										rate1 : form_rate1_,
										rate2 : form_rate2_,
										period_is_integrated : 1,
										cari_db : dsn2,
										cari_db_alias : dsn2_alias
									);
								}
							}
							else
							{
								if(from_member_type eq "partner")
								{
									carici(
										action_id : get_max_id.virman_id,
										islem_belge_no : '#form.virman_no#',
										process_cat : form.process_cat,
										workcube_process_type : -42,
										action_table : 'CARI_ACTIONS',
										islem_tutari : form_net_total,
										action_currency : 'TL',
										other_money_value : form_other_net_total,
										other_money : form_cut_id,
										islem_tarihi : form.expense_date,
										islem_detay : 'GENEL AMAÇLI VİRMAN ALACAK',
										acc_type_id : from_ch_acc_type_id,
										action_detail : form_row_detail,
										from_cmp_id : form_ch_member_id,
										account_card_type : 13,
										project_id : form_project_id,
										rate1 : form_rate1_,
										rate2 : form_rate2_,
										period_is_integrated : 1,
										cari_db : dsn2,
										cari_db_alias : dsn2_alias
									);
								}else if(from_member_type eq "consumer")
								{
									carici(
										action_id : get_max_id.virman_id,
										islem_belge_no : '#form.virman_no#',
										process_cat : form.process_cat,
										workcube_process_type : -42,
										action_table : 'CARI_ACTIONS',
										islem_tutari : form_net_total,
										action_currency : 'TL',
										other_money_value : form_other_net_total,
										other_money : form_cut_id,
										islem_tarihi : form.expense_date,
										islem_detay : 'GENEL AMAÇLI VİRMAN ALACAK',
										acc_type_id : from_ch_acc_type_id,
										action_detail : form_row_detail,
										from_consumer_id : form_ch_member_id,
										account_card_type : 13,
										project_id : form_project_id,
										rate1 : form_rate1_,
										rate2 : form_rate2_,
										period_is_integrated : 1,
										cari_db : dsn2,
										cari_db_alias : dsn2_alias
									);
								}
								else
								{
									carici(
										action_id : get_max_id.virman_id,
										islem_belge_no : '#form.virman_no#',
										process_cat : form.process_cat,
										workcube_process_type : -42,
										action_table : 'CARI_ACTIONS',
										islem_tutari : form_net_total,
										action_currency : 'TL',
										other_money_value : form_other_net_total,
										other_money : form_cut_id,
										islem_tarihi : form.expense_date,
										islem_detay : 'GENEL AMAÇLI VİRMAN ALACAK',
										acc_type_id : from_ch_acc_type_id,
										action_detail : form_row_detail,
										from_employee_id : form_ch_member_id,
										account_card_type : 13,
										project_id : form_project_id,
										rate1 : form_rate1_,
										rate2 : form_rate2_,
										period_is_integrated : 1,
										cari_db : dsn2,
										cari_db_alias : dsn2_alias
									);	
								}
							}
						}
						</cfscript>
						<cfscript>
							if(form_ba eq 0)
							{
								borc_hesap_list= listappend(borc_hesap_list,form_ch_account_code);
								borc_tutar_list =listappend(borc_tutar_list,form_total);
								doviz_tutar_borc = listappend(doviz_tutar_borc,form_other_net_total);	
								doviz_currency_borc = listappend(doviz_currency_borc,form_cut_id);
								if(len(form_project_id))
									acc_project_list_borc = listappend(acc_project_list_borc,form_project_id);
								else
									acc_project_list_borc = listappend(acc_project_list_borc,0);
								satir_detay_list[1][aktif_row_b_no] = form_row_detail;
								aktif_row_b_no = aktif_row_b_no +1;
							}
							else
							{
								alacak_hesap_list= listappend(alacak_hesap_list,form_ch_account_code);
								alacak_tutar_list =listappend(alacak_tutar_list,form_total);
								doviz_tutar_alacak = listappend(doviz_tutar_alacak,form_other_net_total);	
								doviz_currency_alacak = listappend(doviz_currency_alacak,form_cut_id);
								if(len(form_project_id))
									acc_project_list_alacak = listappend(acc_project_list_alacak,form_project_id);
								else
									acc_project_list_alacak = listappend(acc_project_list_alacak,0);
								satir_detay_list[2][aktif_row_a_no] = form_row_detail;
								aktif_row_a_no = aktif_row_a_no +1;
							}
						</cfscript>
                    	<!--- Cari --->
					<cfelseif form_action_type eq 4>
						<!--- Muhasebe --->
						<cfscript>
							if(form_ba eq 0)
							{
								borc_hesap_list= listappend(borc_hesap_list,form_account_code);
								borc_tutar_list =listappend(borc_tutar_list,form_total);
								doviz_tutar_borc = listappend(doviz_tutar_borc,form_other_net_total);	
								doviz_currency_borc = listappend(doviz_currency_borc,form_cut_id);
								if(len(form_project_id))
									acc_project_list_borc = listappend(acc_project_list_borc,form_project_id);
								else
									acc_project_list_borc = listappend(acc_project_list_borc,0);
								satir_detay_list[1][aktif_row_b_no] = form_row_detail;
								aktif_row_b_no = aktif_row_b_no +1;
							}
							else
							{
								alacak_hesap_list= listappend(alacak_hesap_list,form_account_code);
								alacak_tutar_list =listappend(alacak_tutar_list,form_total);
								doviz_tutar_alacak = listappend(doviz_tutar_alacak,form_other_net_total);	
								doviz_currency_alacak = listappend(doviz_currency_alacak,form_cut_id);
								if(len(form_project_id))
									acc_project_list_alacak = listappend(acc_project_list_alacak,form_project_id);
								else
									acc_project_list_alacak = listappend(acc_project_list_alacak,0);
								satir_detay_list[2][aktif_row_a_no] = form_row_detail;
								aktif_row_a_no = aktif_row_a_no +1;
							}
						</cfscript>
                    <cfelse>
						<!--- Diğer --->
						<cfscript>
							if(form_ba eq 0)
							{
								borc_hesap_list= listappend(borc_hesap_list,form_account_code);
								borc_tutar_list =listappend(borc_tutar_list,form_total);
								doviz_tutar_borc = listappend(doviz_tutar_borc,form_other_net_total);	
								doviz_currency_borc = listappend(doviz_currency_borc,form_cut_id);
								if(len(form_project_id))
									acc_project_list_borc = listappend(acc_project_list_borc,form_project_id);
								else
									acc_project_list_borc = listappend(acc_project_list_borc,0);
								satir_detay_list[1][aktif_row_b_no] = form_row_detail;
								aktif_row_b_no = aktif_row_b_no +1;
							}
							else
							{
								alacak_hesap_list= listappend(alacak_hesap_list,form_account_code);
								alacak_tutar_list =listappend(alacak_tutar_list,form_total);
								doviz_tutar_alacak = listappend(doviz_tutar_alacak,form_other_net_total);	
								doviz_currency_alacak = listappend(doviz_currency_alacak,form_cut_id);
								if(len(form_project_id))
									acc_project_list_alacak = listappend(acc_project_list_alacak,form_project_id);
								else
									acc_project_list_alacak = listappend(acc_project_list_alacak,0);
								satir_detay_list[2][aktif_row_a_no] = form_row_detail;
								aktif_row_a_no = aktif_row_a_no +1;
							} 
							if(is_budget eq 1){
							if(form_ba==0)
							{
								if(len(form_expense_center_id) and len(form_expense_item_id))
								{
									butceci
									(
										action_id : get_max_id.virman_id,
										muhasebe_db : dsn2,
										is_income_expense : false,
										process_type : get_process_type.process_type,
										nettotal : form_net_total,
										other_money_value : form_other_net_total,
										action_currency : form_cut_id,
										currency_multiplier : form_rate2_,
										expense_date : form.expense_date,
										expense_center_id : form_expense_center_id,
										expense_item_id : form_expense_item_id,
										detail : '#get_max_id.virman_id# - GENEL AMAÇLI VİRMAN',
										paper_no : '#form.virman_no#',
										branch_id : to_branch_id,
										insert_type : 1,
										employee_id : form.expense_employee_id,
										project_id:form_project_id
									);
								}
							} 
							else 
							{
								if(len(form_expense_center_id) and len(form_expense_item_id))
								{
									butceci
									(
										action_id : get_max_id.virman_id,
										muhasebe_db : dsn2,
										is_income_expense : true,
										process_type : get_process_type.process_type,
										nettotal : form_net_total,
										other_money_value : form_other_net_total,
										action_currency : form_cut_id,
										currency_multiplier : form_rate2_,
										expense_date : form.expense_date,
										expense_center_id : form_expense_center_id,
										expense_item_id : form_expense_item_id,
										detail : '#get_max_id.virman_id# - GENEL AMAÇLI VİRMAN',
										paper_no : '#form.virman_no#',
										branch_id : to_branch_id,
										insert_type : 1,
										employee_id : form.expense_employee_id,
										project_id:form_project_id
									);
								}
							}
						}
						</cfscript>
					</cfif>
                    <cfquery name="add_virman_rows" datasource="#dsn2#">
						INSERT 
						INTO 
							VIRMAN_ROWS
							(
								VIRMAN_ID,
								BA,
								BANK_ID,
								CASH_ID,
								COMPANY_ID,
								EMPLOYEE_ID,
								CONSUMER_ID,
								CH_ACCOUNT_CODE,
								ACTION_VALUE,
								ACTION_CURRENCY_ID,
								ACTION_DATE,
								ACTION_DETAIL,
								OTHER_CASH_ACT_VALUE,
								OTHER_MONEY,
								PROJECT_ID,
								ACCOUNT_CODE,
								CENTER_ID,
								CENTER_NAME,
								ITEM_ID,
								ITEM_NAME,
								QUANTITY,
                                ACC_TYPE_ID
							)
							VALUES
							(
								#get_max_id.virman_id#,
								<cfif len(form_ba)>#form_ba#<cfelse>NULL</cfif>,
								<cfif form_action_type eq 1>#form_banka#<cfelse>NULL</cfif>,
								<cfif form_action_type eq 2>#form_cut_kasa#<cfelse>NULL</cfif>,
								<cfif form_action_type eq 3 and from_member_type eq "partner">#form_ch_member_id#<cfelse>NULL</cfif>,
								<cfif form_action_type eq 3 and from_member_type eq "employee">#form_ch_member_id#<cfelse>NULL</cfif>,
								<cfif form_action_type eq 3 and from_member_type eq "consumer">#form_ch_member_id#<cfelse>NULL</cfif>,
								'#form_ch_account_code#',
								#form_net_total#,
								'TL',
								#form.expense_date#,
								'#form_row_detail#',
								'#form_other_net_total#',
								'#form_cut_id#',
								<cfif len(form_project_id)>#form_project_id#<cfelse>NULL</cfif>,
								'#form_account_code#',
								<cfif len(form_expense_center_id)>#form_expense_center_id#<cfelse>NULL</cfif>,
								'#form_expense_center_name#',
								<cfif len(form_expense_item_id)>#form_expense_item_id#<cfelse>NULL</cfif>,
								'#form_expense_item_name#',
								'#form_quantity#',
                                <cfif len(from_ch_acc_type_id)>#from_ch_acc_type_id#<cfelse>NULL</cfif>
							)
						</cfquery>
          			</cfif>
        		</cfloop>
				<cfscript>
					if(is_account eq 1){
					muhasebeci(
						action_id : get_max_id.virman_id,
						workcube_process_type: get_process_type.process_type,
						muhasebe_db_alias : dsn2,
						muhasebe_db : dsn2,
						workcube_process_cat:form.process_cat,
						account_card_type: 13,
						islem_tarihi: form.expense_date,
						fis_satir_detay: satir_detay_list,//form.expense_detail,
						borc_hesaplar: borc_hesap_list,
						borc_tutarlar: borc_tutar_list,
						other_amount_borc : doviz_tutar_borc,
						other_currency_borc : doviz_currency_borc,
						alacak_hesaplar: alacak_hesap_list,
						alacak_tutarlar: alacak_tutar_list,
						other_amount_alacak : doviz_tutar_alacak,
						other_currency_alacak : doviz_currency_alacak,
						currency_multiplier : '',
						belge_no: '#form.virman_no#',
						fis_detay: 'GENEL AMAÇLI VİRMAN',
						is_account_group : get_process_type.IS_ACCOUNT_GROUP,
						acc_project_list_alacak : acc_project_list_alacak,
						acc_project_list_borc : acc_project_list_borc
					);
					}
				</cfscript>
        		<cfloop from="1" to="#form.kur_say#" index="i">
					<cfquery name="ADD_MONEY_INFO" datasource="#dsn2#">
						INSERT 
						INTO 
							VIRMAN_MONEY 
							(
								ACTION_ID,
								MONEY_TYPE,
								RATE2,
								RATE1,
								IS_SELECTED
							)
							VALUES
							(
								#get_max_id.virman_id#,
								<cfqueryparam cfsqltype="cf_sql_varchar" value="#wrk_eval('form.hidden_rd_money_#i#')#">,
								#evaluate("form.txt_rate2_#i#")#,
								#evaluate("form.txt_rate1_#i#")#,
								<cfif evaluate("form.hidden_rd_money_#i#") is rd_money_value>1<cfelse>0</cfif>
							)
					</cfquery>
			</cfloop>
			<!--- Belge No update ediliyor --->
			<cfquery name="UPD_GENERAL_PAPERS" datasource="#DSN2#">
                UPDATE 
                    #dsn3_alias#.GENERAL_PAPERS
                SET
                    VIRMAN_NUMBER = #paper_number#
                WHERE
                    VIRMAN_NUMBER IS NOT NULL
            </cfquery>
			<cf_workcube_process 
				is_upd='1' 
				data_source='#dsn2#' 
				process_stage='#arguments.process_stage#' 
				old_process_line ='0'
				record_member='#session.ep.userid#'
				record_date='#now()#' 
				action_table='GENEL_VIRMAN'
				action_column='VIRMAN_ID'
				action_id='#get_max_id.virman_id#' 
				action_page='index.cfm?fuseaction=finance.list_genel_virman&event=upd&virman_id=#get_max_id.virman_id#' 
				warning_description='Genel Virman : #paper_number#'
				paper_no='#paper_number#'>
			</cftransaction>
        <script>
			window.location.href = '<cfoutput>/index.cfm?fuseaction=finance.list_genel_virman&event=upd&virman_id=#get_max_id.VIRMAN_ID#<cfif isdefined("arguments.keyword")>&keyword=#arguments.keyword#</cfif><cfif isdefined("arguments.start_date")>&start_date=#arguments.start_date#</cfif><cfif isdefined("arguments.finish_date")>&finish_date=#arguments.finish_date#</cfif><cfif isdefined("arguments.action_type_id")>&action_type_id=#arguments.action_type_id#</cfif></cfoutput>';
		</script>
    </cffunction>
      
    <cffunction name="get_genel_virman">
      	<cfargument name="keyword">
        <cfargument name="start_date">
        <cfargument name="finish_date">
          <cfquery name="get_genelvirman" datasource="#DSN2#">
                SELECT 
                	GV.*,
                    E.EMPLOYEE_NAME,
                    E.EMPLOYEE_SURNAME,
                    E2.EMPLOYEE_NAME AS RECORD_EMP_NAME,
                    E2.EMPLOYEE_SURNAME AS RECORD_EMP_SURNAME
               	FROM 
                	GENEL_VIRMAN GV
                    LEFT JOIN #dsn_alias#.EMPLOYEES E ON GV.VIRMAN_EMP = E.EMPLOYEE_ID,
                    #dsn_alias#.EMPLOYEES E2
                WHERE
                    GV.RECORD_EMP = E2.EMPLOYEE_ID
                    AND
                    (
                    	GV.VIRMAN_NO LIKE '%#arguments.keyword#%' OR
                    	GV.VIRMAN_DETAIL LIKE '%#arguments.keyword#%'
                    )
                    <cfif len(arguments.start_date)>
                    	AND GV.VIRMAN_DATE >= #arguments.start_date#
                    </cfif>
                    <cfif len(arguments.finish_date)>
                    	AND GV.VIRMAN_DATE <= #arguments.finish_date#
                    </cfif>
					<cfif arguments.action_type_id neq 0>
						<cfif arguments.action_type_id eq "">
							AND GV.VIRMAN_ID IN ( SELECT VIRMAN_ID FROM VIRMAN_ROWS WHERE BANK_ID IS NULL AND CASH_ID IS NULL AND COMPANY_ID IS NULL )
						</cfif>
						<cfif arguments.action_type_id eq 1>
							AND GV.VIRMAN_ID IN ( SELECT VIRMAN_ID FROM VIRMAN_ROWS WHERE BANK_ID IS NOT NULL )
						</cfif>
						<cfif arguments.action_type_id eq 2>
							AND GV.VIRMAN_ID IN ( SELECT VIRMAN_ID FROM VIRMAN_ROWS WHERE CASH_ID IS NOT NULL )
						</cfif>
						<cfif arguments.action_type_id eq 3>
							AND GV.VIRMAN_ID IN ( SELECT VIRMAN_ID FROM VIRMAN_ROWS WHERE COMPANY_ID IS NOT NULL )
						</cfif>
					</cfif>
				ORDER BY 
					GV.VIRMAN_DATE 
				DESC
          </cfquery>
          <cfreturn get_genelvirman>
      </cffunction>
      
	  <cffunction name="upd_genel_virman" access="remote">
		<cfargument name="virman_id">
		<cfquery name="control_paper_no" datasource="#dsn2#">
			SELECT VIRMAN_NO FROM GENEL_VIRMAN WHERE VIRMAN_NO = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.virman_no#"> AND VIRMAN_ID NOT IN (#virman_id#)
		</cfquery>
		<cfif control_paper_no.recordcount>
			<script type="text/javascript">
				alert("<cf_get_lang no ='348.Girdiginiz Belge Numarası Kullanılmaktadır'>!");
				history.back();	
			</script>
			<cfabort>
		</cfif>
			<cfquery name="get_process_type" datasource="#dsn3#">
				SELECT 
					PROCESS_TYPE,
					IS_CARI,
					IS_BUDGET,
					IS_ACCOUNT,
					ACTION_FILE_NAME,
					ACTION_FILE_FROM_TEMPLATE,
					IS_ACCOUNT_GROUP
				 FROM 
					SETUP_PROCESS_CAT 
				WHERE 
					PROCESS_CAT_ID = #form.process_cat#
			</cfquery>
			<cfscript>
				is_cari = get_process_type.is_cari;
				is_account = get_process_type.is_account;
				is_budget = get_process_type.is_budget;
			</cfscript>
				<cftransaction>
                	<cfset to_branch_id = listGetAt(session.ep.user_location,2,"-")>
					<cfset rd_money_value = listfirst(form.rd_money, ',')>
                	<cf_date tarih='form.expense_date'>
					<cfquery name="upd_virman_new" datasource="#dsn2#">
						UPDATE 
							GENEL_VIRMAN 
						SET 
							VIRMAN_DETAIL = '#form.expense_detail#',
							VIRMAN_DATE = #form.expense_date#,
							VIRMAN_EMP = <cfif len(form.expense_employee_id) and len(form.expense_employee)>#form.expense_employee_id#<cfelse>NULL</cfif>,
							OTHER_MONEY = '#rd_money_value#',
							UPDATE_DATE = #now()#, 
							UPDATE_EMP = #session.ep.userid#, 
							UPDATE_IP ='#cgi.remote_addr#',
							PROCESS_STAGE= '#form.process_stage#'
						WHERE
							VIRMAN_ID = #virman_id#
					</cfquery>
					<!--- Silip yeniden doldurcaz--->
					<cfquery name="del_virman_rows" datasource="#dsn2#" result="virmanrows">
						DELETE VIRMAN_ROWS WHERE VIRMAN_ID = #virman_id#
					</cfquery>
					<cfquery name="DEL_SHIP_MONEY" datasource="#DSN2#" result="virmanrows">
						DELETE FROM	VIRMAN_MONEY WHERE ACTION_ID = #virman_id#
					</cfquery>
					<cfquery name="del_bank_actions" datasource="#dsn2#" result="virmanrows">
						DELETE BANK_ACTIONS WHERE GENEL_VIRMAN_ID = #virman_id# AND ACTION_TYPE_ID = #get_process_type.process_type#
					</cfquery>
                	<cfquery name="del_cash_actions" datasource="#dsn2#" result="virmanrows">
                    	DELETE CASH_ACTIONS WHERE GENEL_VIRMAN_ID = #virman_id# AND ACTION_TYPE_ID = #get_process_type.process_type#
                	</cfquery>
                	<cfquery name="del_cari_actions" datasource="#dsn2#" result="virmanrows">
                	    DELETE CARI_ACTIONS WHERE MULTI_ACTION_ID = #virman_id#  AND ACTION_TYPE_ID = #get_process_type.process_type#
                	</cfquery>
                	<cfquery name="del_cari_rows" datasource="#dsn2#" result="virmanrows">
                	    DELETE CARI_ROWS WHERE ACTION_ID = #virman_id# AND (ACTION_TYPE_ID = -41 OR ACTION_TYPE_ID = -42)
                	</cfquery>
					<cfquery name="del_cari_rows" datasource="#dsn2#" result="virmanrows">
                    	DELETE EXPENSE_ITEMS_ROWS WHERE ACTION_ID = #virman_id# AND EXPENSE_COST_TYPE = #get_process_type.process_type#
					</cfquery>
					<cfquery name="get_card_id" datasource="#dsn2#">
						SELECT 
							AC.CARD_ID
						FROM 
							ACCOUNT_CARD_ROWS ACR,
							ACCOUNT_CARD AC 
						WHERE 
							ACR.CARD_ID = AC.CARD_ID AND 
							AC.ACTION_ID = #virman_id# AND 
							AC.ACTION_CAT_ID = #form.process_cat#
					</cfquery>
					<cfif get_card_id.recordcount>
						<cfloop query="get_card_id">
							<cfquery name="del_account_rows" datasource="#dsn2#">
								DELETE ACCOUNT_CARD_ROWS WHERE CARD_ID = #get_card_id.CARD_ID#
							</cfquery>
							<cfquery name="del_account" datasource="#dsn2#">
								DELETE ACCOUNT_CARD WHERE CARD_ID = #get_card_id.CARD_ID#
							</cfquery>
						</cfloop>
					</cfif>
                	<!--- Silip yeniden doldurcaz--->
                
					<cfscript>
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
						acc_department_id = '';
						aktif_row_a_no=1;
						aktif_row_b_no=1;
					</cfscript>
				
					<cfloop from="1" to="#record_num#" index="i">
						
						<cfif evaluate("row_kontrol#i#")>
							<cfscript>
								form_wrk_row_id = evaluate("wrk_row_id#i#");
								form_ba = evaluate("ba#i#");
								form_action_type = evaluate("action_type#i#");
								form_kasa = evaluate("kasa#i#");
								form_banka = evaluate("banka#i#");
								
								from_member_type = evaluate("ch_member_type#i#");
								if(form_action_type eq 3){
									if(listlen(evaluate("ch_member_id#i#"),'_') eq 2)
									{
										from_ch_acc_type_id = listlast(evaluate("ch_member_id#i#"),'_');
										form_ch_member_id = listfirst(evaluate("ch_member_id#i#"),'_');
									}else{
										form_ch_member_id = evaluate("ch_member_id#i#");
										from_ch_acc_type_id = "";
									}
								}else{
									form_ch_member_id = "";
									from_ch_acc_type_id = "";
								}
								
								form_ch_member = form_ch_member_id;
								
								form_ch_account_code = evaluate("ch_account_code#i#");
								if(form_action_type eq 3){
									if(from_member_type eq "partner" and len(form_ch_member_id)){
										form_ch_account_code = get_company_period(form_ch_member_id,session.ep.period_id,dsn2,from_ch_acc_type_id);
									}else if(from_member_type eq "consumer" and len(form_ch_member_id)){
										form_ch_account_code = get_consumer_period(form_ch_member_id,session.ep.period_id,dsn2,from_ch_acc_type_id);
									}else if (from_member_type eq "employee" and len(form_ch_member_id)){
										form_ch_account_code = get_employee_period(form_ch_member_id,from_ch_acc_type_id);
									}
								}
								form_row_detail = evaluate("row_detail#i#");
								form_expense_center_id = evaluate("expense_center_id#i#");
								form_expense_center_name=evaluate("expense_center_name#i#");
								form_expense_item_id = evaluate("expense_item_id#i#");
								form_expense_item_name=evaluate("expense_item_name#i#");
								form_account_code = evaluate("account_code#i#");
								form_quantity = evaluate("quantity#i#");
								form_total = evaluate("net_total#i#");//kdv ayrı hesaba yazılacaksa total alanı alınmalı
								/* form_tax_rate = evaluate("tax_rate#i#");
								form_otv_rate = evaluate("otv_rate#i#");
								form_kdv_total = evaluate("kdv_total#i#");
								form_otv_total = evaluate("otv_total#i#"); */
								form_net_total = evaluate("net_total#i#");
								form_money_id = evaluate("money_id#i#");
								form_other_net_total = evaluate("other_net_total#i#");
								form_project_id = evaluate("project_id#i#");
								form_cut_id = listgetat(form_money_id,1);
								form_rate1_= listgetat(form_money_id,2);
								form_rate2_= listgetat(form_money_id,3);
								form_new_net_total=form_other_net_total;
								if(form_action_type==2){
									form_cut_kasa = form_kasa.substring(0,form_kasa.indexof(";"));
								}		
							</cfscript>
							<cfif form_action_type eq 1>
								<!--- Banka --->
								<cfquery name="GET_ACC_DETAIL" datasource="#DSN2#">
									SELECT ACCOUNT_ACC_CODE, ACCOUNT_CURRENCY_ID FROM #dsn3_alias#.ACCOUNTS WHERE ACCOUNT_ID = #form_banka#
								</cfquery>
								<cfscript>
									if(form_ba eq 0)
									{
										borc_hesap_list= listappend(borc_hesap_list,GET_ACC_DETAIL.ACCOUNT_ACC_CODE);
										borc_tutar_list =listappend(borc_tutar_list,form_total);
										doviz_tutar_borc = listappend(doviz_tutar_borc,form_new_net_total);	
										doviz_currency_borc = listappend(doviz_currency_borc,form_cut_id);
										if(len(form_project_id))
											acc_project_list_borc = listappend(acc_project_list_borc,form_project_id);
										else
											acc_project_list_borc = listappend(acc_project_list_borc,0);
										satir_detay_list[1][aktif_row_b_no] = form_row_detail;
										aktif_row_b_no = aktif_row_b_no +1;
									}
									else
									{
										alacak_hesap_list= listappend(alacak_hesap_list,GET_ACC_DETAIL.ACCOUNT_ACC_CODE);
										alacak_tutar_list =listappend(alacak_tutar_list,form_total);
										doviz_tutar_alacak = listappend(doviz_tutar_alacak,form_new_net_total);	
										doviz_currency_alacak = listappend(doviz_currency_alacak,form_cut_id);
										if(len(form_project_id))
											acc_project_list_alacak = listappend(acc_project_list_alacak,form_project_id);
										else
											acc_project_list_alacak = listappend(acc_project_list_alacak,0);
										satir_detay_list[2][aktif_row_a_no] = form_row_detail;
										aktif_row_a_no = aktif_row_a_no +1;
									}
								</cfscript>
								<cfquery name="add_gelen_h" datasource="#dsn2#">
									INSERT 
									INTO 
										BANK_ACTIONS
										(
											PROCESS_CAT,
											GENEL_VIRMAN_ID,
											ACTION_TYPE,
											ACTION_TYPE_ID,
											<cfif form_ba eq 0>ACTION_TO_ACCOUNT_ID<cfelse>ACTION_FROM_ACCOUNT_ID</cfif>,
											ACTION_DATE,
											ACTION_VALUE,
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
											RECORD_DATE,
											SYSTEM_ACTION_VALUE,
											SYSTEM_CURRENCY_ID
										)
										VALUES
										(
											#form.process_cat#,
											#virman_id#,
										   'GENEL AMAÇLI VİRMAN',
											#get_process_type.process_type#,
											#form_banka#,
											#form.expense_date#,
											<cfif GET_ACC_DETAIL.ACCOUNT_CURRENCY_ID is 'TL'>
											#form_net_total#,
											'TL',
											<cfelse>
											#form_other_net_total#,
											'#form_cut_id#',
											</cfif>
											'#form_row_detail#',
											#form_new_net_total#,
											'#form_cut_id#',
											0,
											0,
											'#form.virman_no#',
											<cfif len(form_project_id)>#form_project_id#<cfelse>null</cfif>,
											#session.ep.userid#,
											'#cgi.remote_addr#',
											#now()#,
										<cfif session.ep.money is 'TL'>
											#form_net_total#,
											'TL'
										<cfelse>
											#form_new_net_total#,
											'#form_cut_id#'
										</cfif>
										)
								</cfquery>
								<!--- Banka --->
							<cfelseif form_action_type eq 2>
								<!--- Kasa --->
								<cfquery name="GET_CASH_DETAIL" datasource="#DSN2#">
									SELECT CASH_ACC_CODE, CASH_CURRENCY_ID FROM CASH WHERE CASH_ID = #form_cut_kasa#
								</cfquery>
								<cfscript>
									if(form_ba eq 0)
									{
										borc_hesap_list= listappend(borc_hesap_list,GET_CASH_DETAIL.CASH_ACC_CODE);
										borc_tutar_list =listappend(borc_tutar_list,form_total);
										doviz_tutar_borc = listappend(doviz_tutar_borc,form_new_net_total);	
										doviz_currency_borc = listappend(doviz_currency_borc,form_cut_id);
										if(len(form_project_id))
											acc_project_list_borc = listappend(acc_project_list_borc,form_project_id);
										else
											acc_project_list_borc = listappend(acc_project_list_borc,0);
										satir_detay_list[1][aktif_row_b_no] = form_row_detail;
										aktif_row_b_no = aktif_row_b_no +1;
									}
									else
									{
										alacak_hesap_list= listappend(alacak_hesap_list,GET_CASH_DETAIL.CASH_ACC_CODE);
										alacak_tutar_list =listappend(alacak_tutar_list,form_total);
										doviz_tutar_alacak = listappend(doviz_tutar_alacak,form_new_net_total);	
										doviz_currency_alacak = listappend(doviz_currency_alacak,form_cut_id);
										if(len(form_project_id))
											acc_project_list_alacak = listappend(acc_project_list_alacak,form_project_id);
										else
											acc_project_list_alacak = listappend(acc_project_list_alacak,0);
										satir_detay_list[2][aktif_row_a_no] = form_row_detail;
										aktif_row_a_no = aktif_row_a_no +1;
									}
								</cfscript>
								<cfquery name="ADD_CASH_PAYMENT" datasource="#dsn2#">
									INSERT 
									INTO
										CASH_ACTIONS
										(   
											PROCESS_CAT,
											GENEL_VIRMAN_ID,
											PAPER_NO,
											ACTION_TYPE,
											ACTION_TYPE_ID, 
											<cfif form_ba eq 0>CASH_ACTION_TO_CASH_ID<cfelse>CASH_ACTION_FROM_CASH_ID</cfif>,
											ACTION_DATE,
											CASH_ACTION_VALUE,
											CASH_ACTION_CURRENCY_ID,
											OTHER_CASH_ACT_VALUE,
											OTHER_MONEY,
											PROJECT_ID,
											ACTION_DETAIL,
											IS_ACCOUNT,
											IS_ACCOUNT_TYPE,
											RECORD_EMP,
											RECORD_IP,
											RECORD_DATE,
											ACTION_VALUE
										)
										VALUES
										(
											#form.process_cat#,
											#virman_id#,
											'#form.virman_no#',
											'GENEL AMAÇLI VİRMAN',
											#get_process_type.process_type#,
											#form_cut_kasa#,
											#form.expense_date#,
											<cfif GET_CASH_DETAIL.CASH_CURRENCY_ID is 'TL'>
											#form_net_total#,
											'TL',
											<cfelse>
											#form_other_net_total#,
											'#form_cut_id#',
											</cfif>
											'#form_new_net_total#',
											'#form_cut_id#',
											<cfif len(form_project_id)>#form_project_id#<cfelse>null</cfif>,
											'#form_row_detail#',
											0,
											0,
											#session.ep.userid#,
											'#cgi.remote_addr#',
											#now()#,
											#form_new_net_total#
										)
								</cfquery>
								<!--- Kasa --->
							<cfelseif form_action_type eq 3> 
								<!--- Cari --->
								<cfquery name="ADD_CASH_PAYMENT_IN_OP" datasource="#dsn2#">
									INSERT 
									INTO
										CARI_ACTIONS
										(
											MULTI_ACTION_ID,
											PAPER_NO,
											PROCESS_CAT,
											ACTION_NAME,
											ACTION_TYPE_ID,
											ACTION_VALUE,
											ACTION_CURRENCY_ID,
											OTHER_MONEY,
											<cfif form_ba eq 0>PROJECT_ID,<cfelse>PROJECT_ID_2,</cfif>
											OTHER_CASH_ACT_VALUE,
											<cfif form_ba eq 0>
												<cfif form_ch_member_id eq 'employee'>TO_CMP_ID<cfelseif form_ch_member_id eq 'consumer'>TO_CONSUMER_ID<cfelse>TO_EMPLOYEE_ID</cfif>,								
												ACC_TYPE_ID,	
											<cfelse>
												<cfif form_ch_member_id eq 'employee'>FROM_CMP_ID<cfelseif form_ch_member_id eq 'consumer'>FROM_CONSUMER_ID<cfelse>FROM_EMPLOYEE_ID</cfif>,
												FROM_ACC_TYPE_ID,
											</cfif>
											ACTION_DETAIL,
											ACTION_DATE,
											RECORD_DATE,
											RECORD_EMP,
											RECORD_IP
										)
										VALUES
										(
											#virman_id#,
										   '#form.virman_no#',
											#form.process_cat#,
										   'GENEL AMAÇLI VİRMAN',
											#get_process_type.process_type#,
											#form_net_total#,
											'TL',
											'#form_cut_id#',
											<cfif len(form_project_id)>#form_project_id#<cfelse>null</cfif>,
											'#form_new_net_total#',
											#form_ch_member_id#,
											<cfif len(from_ch_acc_type_id)>#from_ch_acc_type_id#<cfelse>NULL</cfif>,
											'#form_row_detail#',
											#form.expense_date#,
											#now()#,
											#session.ep.userid#,
											'#cgi.remote_addr#'
										)
								</cfquery>
								<cfscript>
									if(is_cari eq 1){
									if(form_ba eq 0)
									{
										if(from_member_type eq "partner")
										{
											carici(
											action_id : virman_id,
											islem_belge_no : '#form.virman_no#',
											process_cat : form.process_cat,
											workcube_process_type : -41,
											action_table : 'CARI_ACTIONS',
											islem_tutari : form_net_total,
											action_currency : 'TL',
											other_money_value : form_other_net_total,
											other_money : form_cut_id,
											islem_tarihi : form.expense_date,
											islem_detay : 'GENEL AMAÇLI VİRMAN BORÇ',
											acc_type_id : from_ch_acc_type_id,
											action_detail : form_row_detail,
											to_cmp_id : form_ch_member_id,
											account_card_type : 13,
											project_id : form_project_id,
											rate1 : form_rate1_,
											rate2 : form_rate2_,
											period_is_integrated:1,
											cari_db : dsn2,
											cari_db_alias : dsn2_alias
											);
										}
										else if(from_member_type eq "consumer")
										{
											carici(
											action_id : virman_id,
											islem_belge_no : '#form.virman_no#',
											process_cat : form.process_cat,
											workcube_process_type : -41,
											action_table : 'CARI_ACTIONS',
											islem_tutari : form_net_total,
											action_currency : 'TL',
											other_money_value : form_other_net_total,
											other_money : form_cut_id,
											islem_tarihi : form.expense_date,
											islem_detay : 'GENEL AMAÇLI VİRMAN BORÇ',
											acc_type_id : from_ch_acc_type_id,
											action_detail : form_row_detail,
											to_consumer_id : form_ch_member_id,
											account_card_type : 13,
											project_id : form_project_id,
											rate1 : form_rate1_,
											rate2 : form_rate2_,
											period_is_integrated:1,
											cari_db : dsn2,
											cari_db_alias : dsn2_alias
											);
										}
										else
										{
											carici(
											action_id : virman_id,
											islem_belge_no : '#form.virman_no#',
											process_cat : form.process_cat,
											workcube_process_type : -41,
											action_table : 'CARI_ACTIONS',
											islem_tutari : form_net_total,
											action_currency : 'TL',
											other_money_value : form_other_net_total,
											other_money : form_cut_id,
											islem_tarihi : form.expense_date,
											islem_detay : 'GENEL AMAÇLI VİRMAN BORÇ',
											acc_type_id : from_ch_acc_type_id,
											action_detail : form_row_detail,
											to_employee_id : form_ch_member_id,
											account_card_type : 13,
											project_id : form_project_id,
											rate1 : form_rate1_,
											rate2 : form_rate2_,
											period_is_integrated:1,
											cari_db : dsn2,
											cari_db_alias : dsn2_alias
											);
										}
									}
									else
									{
										if(from_member_type eq "partner")
										{
											carici(
											action_id : virman_id,
											islem_belge_no : '#form.virman_no#',
											process_cat : form.process_cat,
											workcube_process_type : -42,
											action_table : 'CARI_ACTIONS',
											islem_tutari : form_net_total,
											action_currency : 'TL',
											other_money_value : form_other_net_total,
											other_money : form_cut_id,
											islem_tarihi : form.expense_date,
											islem_detay : 'GENEL AMAÇLI VİRMAN ALACAK',
											acc_type_id : from_ch_acc_type_id,
											action_detail : form_row_detail,
											from_cmp_id : form_ch_member_id,
											account_card_type : 13,
											project_id : form_project_id,
											rate1 : form_rate1_,
											rate2 : form_rate2_,
											period_is_integrated:1,
											cari_db : dsn2,
											cari_db_alias : dsn2_alias
											);
										}
										else if(from_member_type eq "consumer")
										{
											carici(
											action_id : virman_id,
											islem_belge_no : '#form.virman_no#',
											process_cat : form.process_cat,
											workcube_process_type : -42,
											action_table : 'CARI_ACTIONS',
											islem_tutari : form_net_total,
											action_currency : 'TL',
											other_money_value : form_other_net_total,
											other_money : form_cut_id,
											islem_tarihi : form.expense_date,
											islem_detay : 'GENEL AMAÇLI VİRMAN ALACAK',
											acc_type_id : from_ch_acc_type_id,
											action_detail : form_row_detail,
											from_consumer_id : form_ch_member_id,
											account_card_type : 13,
											project_id : form_project_id,
											rate1 : form_rate1_,
											rate2 : form_rate2_,
											period_is_integrated:1,
											cari_db : dsn2,
											cari_db_alias : dsn2_alias
											);
										}
										else
										{
											carici(
											action_id : virman_id,
											islem_belge_no : '#form.virman_no#',
											process_cat : form.process_cat,
											workcube_process_type : -42,
											action_table : 'CARI_ACTIONS',
											islem_tutari : form_net_total,
											action_currency : 'TL',
											other_money_value : form_other_net_total,
											other_money : form_cut_id,
											islem_tarihi : form.expense_date,
											islem_detay : 'GENEL AMAÇLI VİRMAN ALACAK',
											acc_type_id : from_ch_acc_type_id,
											action_detail : form_row_detail,
											from_employee_id : form_ch_member_id,
											account_card_type : 13,
											project_id : form_project_id,
											rate1 : form_rate1_,
											rate2 : form_rate2_,
											period_is_integrated:1,
											cari_db : dsn2,
											cari_db_alias : dsn2_alias
											);	
										}
									}
								}
								</cfscript>
								<cfscript>
									if(form_ba eq 0)
									{
										borc_hesap_list= listappend(borc_hesap_list,form_ch_account_code);
										borc_tutar_list =listappend(borc_tutar_list,form_total);
										doviz_tutar_borc = listappend(doviz_tutar_borc,form_new_net_total);	
										doviz_currency_borc = listappend(doviz_currency_borc,form_cut_id);
										if(len(form_project_id))
											acc_project_list_borc = listappend(acc_project_list_borc,form_project_id);
										else
											acc_project_list_borc = listappend(acc_project_list_borc,0);
										satir_detay_list[1][aktif_row_b_no] = form_row_detail;
										aktif_row_b_no = aktif_row_b_no +1;
									}
									else
									{
										alacak_hesap_list= listappend(alacak_hesap_list,form_ch_account_code);
										alacak_tutar_list =listappend(alacak_tutar_list,form_total);
										doviz_tutar_alacak = listappend(doviz_tutar_alacak,form_new_net_total);	
										doviz_currency_alacak = listappend(doviz_currency_alacak,form_cut_id);
										if(len(form_project_id))
											acc_project_list_alacak = listappend(acc_project_list_alacak,form_project_id);
										else
											acc_project_list_alacak = listappend(acc_project_list_alacak,0);
										satir_detay_list[2][aktif_row_a_no] = form_row_detail;
										aktif_row_a_no = aktif_row_a_no +1;
									}
							</cfscript>
							<!--- Cari --->
						<cfelseif form_action_type eq 4>
							<!--- Muhasebe --->
							<cfscript>
								if(form_ba eq 0)
								{
									borc_hesap_list= listappend(borc_hesap_list,form_account_code);
									borc_tutar_list =listappend(borc_tutar_list,form_total);
									doviz_tutar_borc = listappend(doviz_tutar_borc,form_other_net_total);	
									doviz_currency_borc = listappend(doviz_currency_borc,form_cut_id);
									if(len(form_project_id))
										acc_project_list_borc = listappend(acc_project_list_borc,form_project_id);
									else
										acc_project_list_borc = listappend(acc_project_list_borc,0);
									satir_detay_list[1][aktif_row_b_no] = form_row_detail;
									aktif_row_b_no = aktif_row_b_no +1;
								}
								else
								{
									alacak_hesap_list= listappend(alacak_hesap_list,form_account_code);
									alacak_tutar_list =listappend(alacak_tutar_list,form_total);
									doviz_tutar_alacak = listappend(doviz_tutar_alacak,form_other_net_total);	
									doviz_currency_alacak = listappend(doviz_currency_alacak,form_cut_id);
									if(len(form_project_id))
										acc_project_list_alacak = listappend(acc_project_list_alacak,form_project_id);
									else
										acc_project_list_alacak = listappend(acc_project_list_alacak,0);
									satir_detay_list[2][aktif_row_a_no] = form_row_detail;
									aktif_row_a_no = aktif_row_a_no +1;
								}
							</cfscript>
							<!--- Muhasebe --->
						<cfelse>
							<cfscript>
								if(form_ba eq 0)
								{
									borc_hesap_list= listappend(borc_hesap_list,form_account_code);
									borc_tutar_list =listappend(borc_tutar_list,form_total);
									doviz_tutar_borc = listappend(doviz_tutar_borc,form_new_net_total);	
									doviz_currency_borc = listappend(doviz_currency_borc,form_cut_id);
									if(len(form_project_id))
										acc_project_list_borc = listappend(acc_project_list_borc,form_project_id);
									else
										acc_project_list_borc = listappend(acc_project_list_borc,0);
									satir_detay_list[1][aktif_row_b_no] = form_row_detail;
									aktif_row_b_no = aktif_row_b_no +1;
								}
								else
								{
									alacak_hesap_list= listappend(alacak_hesap_list,form_account_code);
									alacak_tutar_list =listappend(alacak_tutar_list,form_total);
									doviz_tutar_alacak = listappend(doviz_tutar_alacak,form_new_net_total);	
									doviz_currency_alacak = listappend(doviz_currency_alacak,form_cut_id);
									if(len(form_project_id))
										acc_project_list_alacak = listappend(acc_project_list_alacak,form_project_id);
									else
										acc_project_list_alacak = listappend(acc_project_list_alacak,0);
									satir_detay_list[2][aktif_row_a_no] = form_row_detail;
									aktif_row_a_no = aktif_row_a_no +1;
								}
								if(is_budget eq 1){
								if(len(form_expense_center_id) and len(form_expense_item_id))
								{
									if(form_ba==0)
									{
										if(len(form_expense_center_id) and len(form_expense_item_id))
										{
											butceci
											(
												action_id : virman_id,
												muhasebe_db : dsn2,
												is_income_expense : false,
												process_type : get_process_type.process_type,
												nettotal : form_net_total,
												other_money_value : form_other_net_total,
												action_currency : form_cut_id,
												currency_multiplier : form_rate2_,
												expense_date : form.expense_date,
												expense_center_id : form_expense_center_id,
												expense_item_id : form_expense_item_id,
												detail : '#virman_id# - GENEL AMAÇLI VİRMAN',
												paper_no : '#form.virman_no#',
												branch_id : to_branch_id,
												insert_type : 1,
												employee_id : form.expense_employee_id,
												project_id:form_project_id
											);
										}
									} 
									else 
									{
										if(len(form_expense_center_id) and len(form_expense_item_id))
										{
											butceci
											(
												action_id : virman_id,
												muhasebe_db : dsn2,
												is_income_expense : true,
												process_type : get_process_type.process_type,
												nettotal : form_net_total,
												other_money_value : form_other_net_total,
												action_currency : form_cut_id,
												currency_multiplier : form_rate2_,
												expense_date : form.expense_date,
												expense_center_id : form_expense_center_id,
												expense_item_id : form_expense_item_id,
												detail : '#virman_id# - GENEL AMAÇLI VİRMAN',
												paper_no : '#form.virman_no#',
												branch_id : to_branch_id,
												insert_type : 1,
												employee_id : form.expense_employee_id,
												project_id:form_project_id
											);
										}
									}
								}
							}
							</cfscript>
						</cfif>
						<cfquery name="add_virman_rows" datasource="#dsn2#">
							INSERT 
							INTO 
								VIRMAN_ROWS
								(
									VIRMAN_ID,
									BA,
									BANK_ID,
									CASH_ID,
									COMPANY_ID,
                                    EMPLOYEE_ID,
									CONSUMER_ID,
                                    CH_ACCOUNT_CODE,
									ACTION_VALUE,
									ACTION_DATE,
									ACTION_CURRENCY_ID,
									ACTION_DETAIL,
									OTHER_CASH_ACT_VALUE,
									OTHER_MONEY,
									PROJECT_ID,
									ACCOUNT_CODE,
									CENTER_ID,
									CENTER_NAME,
									ITEM_ID,
									ITEM_NAME,
									QUANTITY,
                                    ACC_TYPE_ID
								)
								VALUES
								(
									#virman_id#,
									<cfif len(form_ba)>#form_ba#<cfelse>NULL</cfif>,
									<cfif form_action_type eq 1>#form_banka#<cfelse>NULL</cfif>,
									<cfif form_action_type eq 2>#form_cut_kasa#<cfelse>NULL</cfif>,
									<cfif form_action_type eq 3 and from_member_type eq "partner">#form_ch_member_id#<cfelse>NULL</cfif>,
									<cfif form_action_type eq 3 and from_member_type eq "employee">#form_ch_member_id#<cfelse>NULL</cfif>,
									<cfif form_action_type eq 3 and from_member_type eq "consumer">#form_ch_member_id#<cfelse>NULL</cfif>,
                                    '#form_ch_account_code#',
									#form_net_total#,
									#form.expense_date#,
									'TL',
									'#form_row_detail#',
									'#form_new_net_total#',
									'#form_cut_id#',
									<cfif len(form_project_id)>#form_project_id#<cfelse>null</cfif>,
									'#form_account_code#',
									<cfif len(form_expense_center_id)>#form_expense_center_id#<cfelse>null</cfif>,
									'#form_expense_center_name#',
									<cfif len(form_expense_item_id)>#form_expense_item_id#<cfelse>null</cfif>,
									'#form_expense_item_name#',
									'#form_quantity#',
                                    <cfif len(from_ch_acc_type_id)>#from_ch_acc_type_id#<cfelse>NULL</cfif>
								)
							</cfquery>
						</cfif>
					</cfloop>
					<cfscript>
						if(is_account eq 1){
						muhasebeci(
							action_id : virman_id,
							workcube_process_type: get_process_type.process_type,
							workcube_old_process_type : form.old_process_type,
							workcube_process_cat:form.process_cat,
							account_card_type: 13,
							islem_tarihi: form.expense_date,
							fis_satir_detay: satir_detay_list,//form.expense_detail,
							borc_hesaplar: borc_hesap_list,
							borc_tutarlar: borc_tutar_list,
							other_amount_borc : doviz_tutar_borc,
							other_currency_borc : doviz_currency_borc,
							alacak_hesaplar: alacak_hesap_list,
							alacak_tutarlar: alacak_tutar_list,
							other_amount_alacak : doviz_tutar_alacak,
							other_currency_alacak : doviz_currency_alacak,
							currency_multiplier : '',
							belge_no:'#form.virman_no#',
							fis_detay: 'GENEL AMAÇLI VİRMAN',
							is_account_group : get_process_type.IS_ACCOUNT_GROUP,
							acc_project_list_alacak : acc_project_list_alacak,
							acc_project_list_borc : acc_project_list_borc
						);
						}
						else muhasebe_sil(action_id:virman_id, process_type:get_process_type.process_type);
					</cfscript>
					<cfloop from="1" to="#form.kur_say#" index="i">
						<cfquery name="ADD_MONEY_INFO" datasource="#dsn2#">
							INSERT 
							INTO 
								VIRMAN_MONEY
								(
									ACTION_ID,
									MONEY_TYPE,
									RATE2,
									RATE1,
									IS_SELECTED
								)
								VALUES
								(
									#virman_id#,
									<cfqueryparam cfsqltype="cf_sql_varchar" value="#wrk_eval('form.hidden_rd_money_#i#')#">,
									#evaluate("form.txt_rate2_#i#")#,
									#evaluate("form.txt_rate1_#i#")#,
									<cfif evaluate("form.hidden_rd_money_#i#") is rd_money_value>1<cfelse>0</cfif>
								)
						</cfquery>
					</cfloop>
					<cf_workcube_process 
						is_upd='1' 
						data_source='#dsn2#' 
						process_stage='#arguments.process_stage#' 
						old_process_line='#arguments.old_process_line#'
						record_member='#session.ep.userid#'
						record_date='#now()#' 
						action_table='GENEL_VIRMAN'
						action_column='VIRMAN_ID'
						action_id='#virman_id#' 
						action_page='index.cfm?fuseaction=finance.list_genel_virman&event=upd&virman_id=#virman_id#' 
						warning_description='Genel Virman : #form.virman_no#'
						paper_no='#form.virman_no#'>
				</cftransaction>
	  <script>
		  window.document.location.href='<cfoutput>/index.cfm?fuseaction=finance.list_genel_virman&event=upd&virman_id=#virman_id#<cfif isdefined("arguments.keyword")>&keyword=#arguments.keyword#</cfif><cfif isdefined("arguments.start_date")>&start_date=#arguments.start_date#</cfif><cfif isdefined("arguments.finish_date")>&finish_date=#arguments.finish_date#</cfif><cfif isdefined("arguments.action_type_id")>&action_type_id=#arguments.action_type_id#</cfif></cfoutput>';
      </script> 
      </cffunction>

      <cffunction name="dlt_genel_virman" access="remote">
      		<cfargument name="virman_id">
			<cfquery name="get_process_type" datasource="#dsn2#">
                SELECT PROCESS_TYPE,PROCESS_CAT FROM GENEL_VIRMAN WHERE VIRMAN_ID = #virman_id#
            </cfquery>
     		<cfquery name="del_virman" datasource="#dsn2#">
                DELETE GENEL_VIRMAN WHERE VIRMAN_ID = #virman_id#
            </cfquery>
            <cfquery name="del_virman_rows" datasource="#dsn2#">
                DELETE VIRMAN_ROWS WHERE VIRMAN_ID = #virman_id#
            </cfquery>
            <cfquery name="DEL_SHIP_MONEY" datasource="#DSN2#">
				DELETE FROM	VIRMAN_MONEY WHERE ACTION_ID = #virman_id#
			</cfquery>
             <cfquery name="del_bank_actions" datasource="#dsn2#">
                DELETE BANK_ACTIONS WHERE GENEL_VIRMAN_ID = #virman_id# AND ACTION_TYPE_ID =#get_process_type.process_type#
            </cfquery>
            <cfquery name="del_cash_actions" datasource="#dsn2#">
                DELETE CASH_ACTIONS WHERE GENEL_VIRMAN_ID = #virman_id# AND ACTION_TYPE_ID =#get_process_type.process_type#
            </cfquery>
            <cfquery name="del_cari_actions" datasource="#dsn2#">
                DELETE CARI_ACTIONS WHERE MULTI_ACTION_ID = #virman_id#  AND ACTION_TYPE_ID =#get_process_type.process_type#
            </cfquery>
            <cfquery name="del_cari_rows" datasource="#dsn2#">
                DELETE CARI_ROWS WHERE ACTION_ID = #virman_id# AND (ACTION_TYPE_ID = -41 OR ACTION_TYPE_ID = -42)
            </cfquery>
			<cfquery name="del_cari_rows" datasource="#dsn2#">
				DELETE EXPENSE_ITEMS_ROWS WHERE ACTION_ID = #virman_id# AND EXPENSE_COST_TYPE =#get_process_type.process_type#
			</cfquery>
            <cfquery name="get_card_id" datasource="#dsn2#">
                SELECT 
                    AC.CARD_ID
                FROM 
                    ACCOUNT_CARD_ROWS ACR,
                    ACCOUNT_CARD AC 
                WHERE 
					ACR.CARD_ID = AC.CARD_ID AND 
					AC.ACTION_ID = #virman_id# AND 
					AC.ACTION_CAT_ID = #get_process_type.process_cat#
            </cfquery>
            <cfif get_card_id.recordcount>
                <cfloop query="get_card_id">
					<cfquery name="del_account_rows" datasource="#dsn2#">
						DELETE ACCOUNT_CARD_ROWS WHERE CARD_ID = #get_card_id.CARD_ID#
					</cfquery>
					<cfquery name="del_account" datasource="#dsn2#">
						DELETE ACCOUNT_CARD WHERE CARD_ID = #get_card_id.CARD_ID#
					</cfquery>
				</cfloop>
            </cfif>
		  <script>
				
				window.document.location.href='/index.cfm?fuseaction=finance.list_genel_virman';
				
          </script> 
      </cffunction>
</cfcomponent>
