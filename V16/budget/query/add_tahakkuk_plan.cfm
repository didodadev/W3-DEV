<cfif isdefined("form.active_period") and form.active_period neq session.ep.period_id>
	<script type="text/javascript">
		alert("İşlem Yapmak İstediğiniz Muhasebe Dönemi ile Aktif Muhasebe Döneminiz Farklı. Muhasebe Döneminizi Kontrol Ediniz!");
		window.location.href='<cfoutput>#request.self#</cfoutput>?fuseaction=budget.list_tahakkuk';
	</script>
	<cfabort>
</cfif>
<cf_papers paper_type="TAHAKKUK_PLAN">
<cfif isDefined("attributes.due_date") and len(attributes.due_date)>
	<cf_date tarih = 'attributes.due_date'>
</cfif>
<cfif isDefined("attributes.start_date") and len(attributes.start_date)>
	<cf_date tarih = 'attributes.start_date'>
</cfif>
<cfif isDefined("attributes.finish_date") and len(attributes.finish_date)>
	<cf_date tarih = 'attributes.finish_date'>
</cfif>
<cfset wrk_id = 'THK_'&dateformat(now(),'YYYYMMDD')&timeformat(now(),'HHmmss')&'_#session.ep.userid#_'&round(rand()*100)>
<cfquery name="get_process_type" datasource="#dsn2#">
	SELECT PROCESS_TYPE,IS_CARI,IS_ACCOUNT,IS_ACCOUNT_GROUP,IS_BUDGET,ACTION_FILE_NAME,ACTION_FILE_FROM_TEMPLATE FROM #dsn3_alias#.SETUP_PROCESS_CAT WHERE PROCESS_CAT_ID = #form.process_cat#
</cfquery>
<cfscript>
	process_cat = form.process_cat;
	is_cari = get_process_type.is_cari;
	is_account = get_process_type.is_account;
	is_budget = get_process_type.is_budget;
	is_account_group = get_process_type.is_account_group;
	process_type = get_process_type.process_type;
	rd_money_value = attributes.rd_money;
	currency_multiplier = '';
	currency_multiplier2 = '';
	if(isDefined('attributes.kur_say') and len(attributes.kur_say))
		for(mon=1;mon lte attributes.kur_say;mon=mon+1)
		{
			if(evaluate("attributes.hidden_rd_money_#mon#") is rd_money_value)
				currency_multiplier = (evaluate('attributes.txt_rate2_#mon#'))/(evaluate('attributes.txt_rate1_#mon#'));
			if(evaluate("attributes.hidden_rd_money_#mon#") is session.ep.money2)
				currency_multiplier2 = (evaluate('attributes.txt_rate2_#mon#'))/(evaluate('attributes.txt_rate1_#mon#'));
		}
</cfscript>
<cflock name="#CreateUUID()#" timeout="60">
	<cftransaction>
		<cfquery name="ADD_PLAN" datasource="#dsn2#" result="MAX_ID">
			INSERT INTO
			#dsn3_alias#.TAHAKKUK_PLAN
			(
				WRK_ID,
				PROCESS_TYPE,
				PROCESS_CAT,
				PAPER_NO,
				START_DATE,
				FINISH_DATE,
				DUE_DATE,
				DETAIL,
				MEMBER_TYPE,
				COMPANY_ID,
				PARTNER_ID,
				CONSUMER_ID,
				EMPLOYEE_ID,
				PROJECT_ID,
				ASSETP_ID,
				EXPENSE_CENTER_ID,
				ACCOUNT_CODE,
				MONTH_EXPENSE_ITEM_ID,
				MONTH_ACCOUNT_CODE,
				YEAR_EXPENSE_ITEM_ID,
				YEAR_ACCOUNT_CODE,
				IS_PROJECT_ACCOUNT,
				NET_TOTAL,
				OTHER_NET_TOTAL,
				NET_TOTAL_SYSTEM,
				TAX,
				TAX_TOTAL,
				OTHER_TAX_TOTAL,
				EXPENSE_TOTAL,
				OTHER_EXPENSE_TOTAL,
				OTHER_MONEY,
				RECORD_DATE,
				RECORD_IP,
				RECORD_EMP,
				PERIOD_ID,
				PAYMETHOD_ID,
				CARD_PAYMETHOD_ID
			)
			VALUES
			(
				#sql_unicode()#'#wrk_id#',
				#process_type#,
				#process_cat#,
				'#attributes.paper_number#',
				<cfif isdefined("attributes.start_date") and len(attributes.start_date)><cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.start_date#"><cfelse>NULL</cfif>,
				<cfif isdefined("attributes.finish_date") and len(attributes.finish_date)><cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.finish_date#"><cfelse>NULL</cfif>,
				<cfif isdefined("attributes.due_date") and len(attributes.due_date)><cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.due_date#"><cfelse>NULL</cfif>,
				<cfif isDefined("attributes.detail") and len(attributes.detail)>'#left(attributes.detail,1000)#'<cfelse>NULL</cfif>,
				<cfif len(attributes.ch_member_type) and attributes.ch_member_type eq 'partner'> 
					'#attributes.ch_member_type#',
					<cfif len(attributes.ch_company) and len(attributes.ch_company_id)>#attributes.ch_company_id#<cfelse>NULL</cfif>,
					<cfif len(attributes.ch_partner) and len(attributes.ch_partner_id)>#attributes.ch_partner_id#<cfelse>NULL</cfif>,
					NULL,
					NULL,
				<cfelseif len(attributes.ch_member_type) and attributes.ch_member_type eq 'consumer'>
					'#attributes.ch_member_type#',
					NULL,
					NULL,
					<cfif isdefined("attributes.ch_partner") and len(attributes.ch_partner) and len(attributes.ch_partner_id)>#attributes.ch_partner_id#<cfelse>NULL</cfif>,
					NULL,
				<cfelseif len(attributes.ch_member_type) and attributes.ch_member_type eq 'employee'>
					'#attributes.ch_member_type#',
					NULL,
					NULL,
					NULL,
					<cfif len(attributes.ch_member_type) and len(attributes.emp_id)>#attributes.emp_id#<cfelse>NULL</cfif>,
				<cfelse>
					NULL,
					NULL,
					NULL,
					NULL,
					NULL,
				</cfif>
				<cfif isdefined("attributes.project_id") and len(attributes.project_id) and len(attributes.project_head)>#attributes.project_id#<cfelse>NULL</cfif>,
				<cfif isdefined("attributes.assetp_id") and len(attributes.assetp_id) and len(attributes.assetp_name)>#attributes.assetp_id#<cfelse>NULL</cfif>,
				<cfif isdefined("attributes.expense_center_id") and len(attributes.expense_center_id) and len(attributes.expense_center)>#attributes.expense_center_id#<cfelse>NULL</cfif>,
				<cfif isdefined("attributes.account_code") and len(attributes.account_code) and len(attributes.account_id)>'#attributes.account_id#'<cfelse>NULL</cfif>,
				<cfif isdefined("attributes.month_expense_item_id") and len(attributes.month_expense_item_id) and len(attributes.month_expense_item_name)>#attributes.month_expense_item_id#<cfelse>NULL</cfif>,
				<cfif isdefined("attributes.month_account_code") and len(attributes.month_account_code) and len(attributes.month_account_id)>'#attributes.month_account_id#'<cfelse>NULL</cfif>,
				<cfif isdefined("attributes.year_expense_item_id") and len(attributes.year_expense_item_id) and len(attributes.year_expense_item_name)>#attributes.year_expense_item_id#<cfelse>NULL</cfif>,
				<cfif isdefined("attributes.year_account_code") and len(attributes.year_account_code) and len(attributes.year_account_id)>'#attributes.year_account_id#'<cfelse>NULL</cfif>,
				<cfif isDefined("attributes.proje_muh_kod")>1<cfelse>0</cfif>,
				#attributes.expense_total_amount_tax#,
				#attributes.other_expense_total_amount_tax#,
				NULL,
				<cfif isdefined("attributes.tax_rate") and len(attributes.tax_rate)>#attributes.tax_rate#<cfelse>NULL</cfif>,
				#attributes.tax_total#,
				#attributes.other_tax_total#,
				#attributes.expense_total_amount#,
				#attributes.other_expense_total_amount#,
				'#attributes.rd_money#',
				#now()#,
				'#cgi.remote_addr#',
				#session.ep.userid#,
				#session.ep.period_id#,
				<cfif isdefined("attributes.paymethod_id") and len(attributes.paymethod_id)><cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.paymethod_id#"><cfelse>NULL</cfif>,
				<cfif isdefined("attributes.card_paymethod_id") and len(attributes.card_paymethod_id)><cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.card_paymethod_id#"><cfelse>NULL</cfif>
			)
		</cfquery>
		<cfloop from="1" to="#attributes.record_num#" index="i">
			<cfif isdefined("attributes.row_kontrol#i#") and evaluate("attributes.row_kontrol#i#")>
                <cfif isdefined("attributes.expense_date#i#")>
                    <cf_date tarih='attributes.expense_date#i#'>
                </cfif>
				<cfquery name="ADD_PLAN_ROW" datasource="#dsn2#">
					INSERT INTO
						#dsn3_alias#.TAHAKKUK_PLAN_ROW
						(
							TAHAKKUK_PLAN_ID,
							ROW_PLAN_DATE,
							ROW_EXPENSE_CENTER_ID,
							ROW_EXPENSE_ITEM_ID,
							ROW_ACCOUNT_CODE,
							ROW_TOTAL_EXPENSE,
							ROW_OTHER_TOTAL_EXPENSE,
							ROW_OTHER_MONEY,
							WRK_ROW_ID
						)
						VALUES
						(
							#MAX_ID.IDENTITYCOL#,
                            <cfif isdefined("attributes.expense_date#i#") and Len(evaluate("attributes.expense_date#i#"))>#evaluate("attributes.expense_date#i#")#<cfelse>#now()#</cfif>,							
							<cfif isdefined("attributes.expense_center_id#i#") and len(evaluate("attributes.expense_center_id#i#"))>#evaluate("attributes.expense_center_id#i#")#<cfelseif isdefined("attributes.expense_center_id") and len(attributes.expense_center_id) and len(attributes.expense_center)>#attributes.expense_center_id#<cfelse>NULL</cfif>,
							<cfif isdefined("attributes.expense_item_name#i#") and len(evaluate("attributes.expense_item_name#i#"))>#evaluate("attributes.expense_item_id#i#")#<cfelse>NULL</cfif>,
							<cfif isdefined("attributes.account_id#i#") and len(evaluate("attributes.account_id#i#")) and isdefined("attributes.account_code#i#") and len(evaluate("attributes.account_code#i#"))>'#wrk_eval("attributes.account_id#i#")#'<cfelse>NULL</cfif>,
							#evaluate("attributes.expense_total#i#")#,
							#evaluate("attributes.other_expense_total#i#")#,
							'#attributes.rd_money#',
							<cfif isdefined("attributes.wrk_row_id#i#") and len(evaluate("attributes.wrk_row_id#i#"))>#sql_unicode()#'#wrk_eval("attributes.wrk_row_id#i#")#'<cfelse>NULL</cfif>
						)
				</cfquery>
			</cfif>
		</cfloop>
		<cfloop from="1" to="#attributes.kur_say#" index="i">
			<cfquery name="ADD_MONEY_INFO" datasource="#dsn2#">
				INSERT INTO
					#dsn3_alias#.TAHAKKUK_PLAN_MONEY 
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
					'#wrk_eval("attributes.hidden_rd_money_#i#")#',
					#evaluate("attributes.txt_rate2_#i#")#,
					#evaluate("attributes.txt_rate1_#i#")#,
					<cfif evaluate("attributes.hidden_rd_money_#i#") is rd_money>1<cfelse>0</cfif>
				)
			</cfquery>
		</cfloop>
		<!--- cari - muhasebe --->
		<cfset islem_aciklama = attributes.paper_number&' Nolu Gider Tahakkuku'&' - '&attributes.detail>
		<cfscript>			
			act_name = UCase('Gider Tahakkuku');
			branch_id_info = ListGetAt(session.ep.user_location,2,"-");
			detail_info = "#attributes.detail#";
			attributes.acc_type_id = '';
			acc_department_id = '';
			if(isdefined("attributes.project_id") and len(attributes.project_id) and len(attributes.project_head)) main_project_id = attributes.project_id; else main_project_id = 0;
			
			if (isdefined("attributes.ch_company_id") and len(attributes.ch_company_id) and isdefined("attributes.ch_company") and len(attributes.ch_company) and isdefined("attributes.ch_member_type") and len(attributes.ch_member_type) and attributes.ch_member_type eq 'partner')
			{
				from_company_id = attributes.ch_company_id;
				from_consumer_id = '';
				from_employee_id= '';
			}
			else if (isdefined("attributes.ch_partner_id") and len(attributes.ch_partner_id) and isdefined("attributes.ch_partner") and len(attributes.ch_partner) and isdefined("attributes.ch_member_type") and len(attributes.ch_member_type) and attributes.ch_member_type eq 'consumer')
			{
				from_consumer_id = attributes.ch_partner_id;
				from_company_id = '';
				from_employee_id= '';
			}
			else if (isdefined("attributes.emp_id") and len(attributes.emp_id) and isdefined("attributes.ch_partner") and len(attributes.ch_partner) and isdefined("attributes.ch_member_type") and len(attributes.ch_member_type) and attributes.ch_member_type eq 'employee')
			{
				from_employee_id = attributes.emp_id;
				from_company_id = '';
				from_consumer_id= '';
			}
			else
			{
				from_employee_id = '';
				from_company_id = '';
				from_consumer_id= '';
			}
			
			if((isdefined("attributes.ch_company") and len(attributes.ch_company) and len(attributes.ch_company_id)) or (isdefined("attributes.emp_id") and len(attributes.emp_id) and isdefined("attributes.ch_partner") and len(attributes.ch_partner)) or (len(attributes.ch_partner_id) and isdefined("attributes.ch_partner") and len(attributes.ch_partner)))	{
				is_cari_islem=1;
				if(attributes.ch_member_type eq "partner")
					string_acc_code = GET_COMPANY_PERIOD(attributes.ch_company_id);
				else if(attributes.ch_member_type eq "consumer")
					string_acc_code = GET_CONSUMER_PERIOD(attributes.ch_partner_id);
				else
					string_acc_code = GET_EMPLOYEE_PERIOD(attributes.emp_id,attributes.acc_type_id);
				string_currency_id = session.ep.money;
			}
			
			str_alacak_tutar_list="";
			str_alacak_kod_list="";
			str_borc_tutar_list="";
			str_borc_kod_list="";
			satir_detay_list = ArrayNew(2); //muhasebe fisi satır detaylarını tutar 
			//muhasebe fisi satır detaylarını tutar. satir_detay_list[1]'a  borc yazan satırların acıklamaları, satir_detay_list[2]'a alacak yazan satırların acıklamaları set edilir. 
			str_other_alacak_tutar_list = "";
			str_other_borc_tutar_list = "";
			str_other_borc_currency_list = "";
			str_other_alacak_currency_list = "";
			str_borclu_tutar = ArrayNew(1) ;
			str_alacakli_tutar = ArrayNew(1) ;
			acc_project_list_borc = '';
			acc_project_list_alacak = '';
			
			if(is_cari eq 1)
			{
				carici(
					action_id : MAX_ID.IDENTITYCOL,
					action_table : 'TAHAKKUK_PLAN',
					workcube_process_type : process_type,
					account_card_type : 13,
					acc_type_id : attributes.acc_type_id,
					due_date : iif(len(attributes.due_date),de('#attributes.due_date#'),de('')),
					islem_tarihi : attributes.start_date,
					islem_tutari : attributes.expense_total_amount_tax,
					from_cmp_id : from_company_id,
					from_consumer_id : from_consumer_id,
					from_employee_id : from_employee_id,
					from_branch_id : branch_id_info,
					islem_detay : act_name,
					action_detail : detail_info,
					other_money_value : attributes.other_expense_total_amount_tax,
					other_money : rd_money_value,
					action_currency : session.ep.money,
					process_cat : attributes.process_cat,
					islem_belge_no : attributes.paper_number,
					currency_multiplier : currency_multiplier2,
					project_id: main_project_id,
					rate2:currency_multiplier2
				);
			}
			
			if(is_account eq 1)
			{
				str_alacak_tutar_list = ListAppend(str_alacak_tutar_list,attributes.expense_total_amount_tax,",");
				str_other_alacak_tutar_list = ListAppend(str_other_alacak_tutar_list,attributes.other_expense_total_amount_tax,",");
				str_alacak_kod_list = ListAppend(str_alacak_kod_list,string_acc_code,",");
				str_other_alacak_currency_list = ListAppend(str_other_alacak_currency_list,rd_money_value,",");
				// satir_detay_list[2][listlen(str_alacak_tutar_list)]= '#attributes.ch_partner# - #islem_aciklama#';
				satir_detay_list[2][listlen(str_alacak_tutar_list)]= '#attributes.paper_number# - #attributes.ch_company# - #attributes.detail#';
				// abort(str_other_alacak_tutar_list);
				
				for(j=1;j lte attributes.record_num;j=j+1)
				{
					if (isdefined("attributes.row_kontrol#j#") and evaluate("attributes.row_kontrol#j#") and len(evaluate("attributes.account_id#j#")) and len(evaluate("attributes.account_code#j#")))
					{
						str_borc_tutar_list = ListAppend(str_borc_tutar_list,evaluate("attributes.expense_total#j#"),",");
						str_borc_kod_list = ListAppend(str_borc_kod_list,evaluate("attributes.account_id#j#"),",");
						str_other_borc_tutar_list = ListAppend(str_other_borc_tutar_list, evaluate("attributes.other_expense_total#j#"),",");
						str_other_borc_currency_list = ListAppend(str_other_borc_currency_list,rd_money_value,",");										
						// satir_detay_list[1][listlen(str_borc_tutar_list)]='#islem_aciklama#';						
						satir_detay_list[1][listlen(str_borc_tutar_list)] = '#attributes.paper_number# - #attributes.ch_company# - #attributes.detail#';						
					}
				}
				if(isDefined("attributes.tax_rate") and Len(attributes.tax_rate)) //kdv
				{
					get_tax_acc_code = cfquery(datasource : "#dsn2#", sqlstring : "SELECT PURCHASE_CODE FROM SETUP_TAX WHERE TAX = #attributes.tax_rate#");
					tax_acc = get_tax_acc_code.purchase_code;
					str_borc_kod_list = ListAppend(str_borc_kod_list,tax_acc,",");
					str_borc_tutar_list = ListAppend(str_borc_tutar_list,attributes.tax_total,",");
					str_other_borc_tutar_list = ListAppend(str_other_borc_tutar_list,attributes.other_tax_total,",");
					str_other_borc_currency_list = ListAppend(str_other_borc_currency_list,rd_money_value,",");
					satir_detay_list[1][listlen(str_borc_tutar_list)] = '#attributes.paper_number# - #attributes.ch_company# - #attributes.detail#';
				}
				
				muhasebeci (
					wrk_id : wrk_id,
					action_id : MAX_ID.IDENTITYCOL,
					action_table :'TAHAKKUK_PLAN',
					acc_department_id : acc_department_id,
					workcube_process_type : process_type,
					workcube_process_cat : attributes.process_cat,
					account_card_type : 13,
					islem_tarihi : attributes.start_date,
					company_id : from_company_id,
					consumer_id : from_consumer_id,
					employee_id : from_employee_id,
					borc_hesaplar : str_borc_kod_list,
					borc_tutarlar : str_borc_tutar_list,
					alacak_hesaplar : str_alacak_kod_list,
					alacak_tutarlar : str_alacak_tutar_list,
					fis_satir_detay: satir_detay_list,
					fis_detay : act_name,
					belge_no : attributes.paper_number,
					from_branch_id : branch_id_info,
					to_branch_id : branch_id_info,
					other_amount_borc : str_other_borc_tutar_list,
					other_currency_borc : str_other_borc_currency_list,
					other_amount_alacak : str_other_alacak_tutar_list,
					other_currency_alacak : str_other_alacak_currency_list,
					is_account_group : is_account_group,
					currency_multiplier : currency_multiplier2,
					due_date: iif(len(attributes.due_date),de('#attributes.due_date#'),de('')),
					acc_project_id : main_project_id
				);
			}
		</cfscript>
		<cfquery name="GET_CARD_ID" datasource="#dsn2#">
			SELECT
				*
			FROM
				ACCOUNT_CARD
			WHERE
				ACTION_ID = #MAX_ID.IDENTITYCOL#							
				AND ACTION_TABLE = 'TAHAKKUK_PLAN'
				AND WRK_ID = '#wrk_id#'
		</cfquery>
		<cfif GET_CARD_ID.recordcount>
			<cfloop from="1" to="#attributes.kur_say#" index="i">
				<cfquery name="ADD_MONEY_INFO" datasource="#dsn2#">
					INSERT INTO
						ACCOUNT_CARD_MONEY 
					(
						ACTION_ID,
						MONEY_TYPE,
						RATE2,
						RATE1,
						IS_SELECTED
					)
					VALUES
					(
						#GET_CARD_ID.CARD_ID#,
						'#wrk_eval("attributes.hidden_rd_money_#i#")#',
						#evaluate("attributes.txt_rate2_#i#")#,
						#evaluate("attributes.txt_rate1_#i#")#,
						<cfif evaluate("attributes.hidden_rd_money_#i#") is rd_money>1<cfelse>0</cfif>
					)
				</cfquery>
			</cfloop>
		</cfif>
		<!--- cari - muhasebe --->			
		<!--- Belge No update ediliyor --->
			<cfquery name="UPD_GENERAL_PAPERS" datasource="#dsn2#">
				UPDATE 
					#dsn3_alias#.GENERAL_PAPERS
				SET
					TAHAKKUK_PLAN_NUMBER = '#paper_number#'
				WHERE
					TAHAKKUK_PLAN_NUMBER IS NOT NULL
			</cfquery>
		<!--- Belge No update ediliyor --->
		<cf_workcube_process_cat 
			process_cat="#attributes.process_cat#"
			action_id = #MAX_ID.IDENTITYCOL#
			is_action_file = 1
			action_table="TAHAKKUK_PLAN"
			action_column="TAHAKKUK_PLAN_ID"
			action_file_name='#get_process_type.action_file_name#'
			action_page='#request.self#?fuseaction=budget.list_tahakkuk&event=upd&tplan_id=#MAX_ID.IDENTITYCOL#'
			action_db_type="#dsn2#"
			is_template_action_file = '#get_process_type.action_file_from_template#'>		
	</cftransaction>
</cflock>
<script type="text/javascript">
	window.location.href="<cfoutput>#request.self#?fuseaction=budget.list_tahakkuk&event=upd&tplan_id=#MAX_ID.IDENTITYCOL#</cfoutput>";
</script>