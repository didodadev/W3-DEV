<cf_date tarih='attributes.process_date'>
<cfparam name="attributes.form_exist" default="0">
<cfquery name="get_process_type" datasource="#dsn3#">
	SELECT PROCESS_TYPE,IS_ACCOUNT,IS_ACCOUNT_GROUP,IS_BUDGET,ACTION_FILE_NAME,ACTION_FILE_FROM_TEMPLATE FROM SETUP_PROCESS_CAT WHERE PROCESS_CAT_ID = #form.process_cat#
</cfquery>
<cfscript>
	process_cat = form.PROCESS_CAT;
	is_account = get_process_type.IS_ACCOUNT;
	is_budget = get_process_type.IS_BUDGET;
	is_account_group = get_process_type.IS_ACCOUNT_GROUP;
	process_type = get_process_type.PROCESS_TYPE;
	borc_hesaplar_list="";
	alacak_hesaplar_list="";
	borc_tutarlar_list="";
	alacak_tutarlar_list="";
	acc_project_list_borc = '';
	acc_project_list_alacak = '';
	acc_project_id = "";
</cfscript>
<cfquery name = "get_inv_main" datasource = "#dsn3#">
	SELECT * FROM INVENTORY_AMORTIZATION_MAIN WHERE INV_AMORT_MAIN_ID = #attributes.inv_id#
</cfquery>
<cfset go_ifrs = get_inv_main.accounting_type>
<cfif len(session.ep.money2)>
	<cfquery name="get_money" datasource="#dsn2#">
		SELECT 
            MONEY,
            RATE1, 
            RATE2, 
            RECORD_DATE, 
            RECORD_EMP, 
            RECORD_IP, 
            UPDATE_DATE,
            UPDATE_EMP, 
            UPDATE_IP
        FROM 
	        SETUP_MONEY 
        WHERE 
        	MONEY = '#session.ep.money2#'
	</cfquery>
	<cfset currency_multiplier = get_money.rate2/get_money.rate1>
<cfelse>
	<cfset currency_multiplier = ''>
</cfif>
<cflock name="#CreateUUID()#" timeout="60">
	<cftransaction>
		<cfquery name="UPD_INVENT_MAIN" datasource="#DSN2#">
			UPDATE
				#dsn3_alias#.INVENTORY_AMORTIZATION_MAIN
			SET
				 PROCESS_TYPE = #process_type#,
				 PROCESS_CAT = #process_cat#,
				 ACTION_DATE = #attributes.process_date#,
				 DETAIL = <cfif isdefined("attributes.detail") and len(attributes.detail)>'#left(attributes.detail,500)#',<cfelse>NUll,</cfif>
				 UPDATE_DATE = #NOW()#,
				 UPDATE_EMP = #SESSION.EP.USERID#,
				 UPDATE_IP = '#CGI.REMOTE_ADDR#'
			WHERE 
				 INV_AMORT_MAIN_ID = #attributes.inv_id#	
		</cfquery>
		<cfquery name="DEL_AMORT" datasource="#DSN2#">
			DELETE FROM #dsn3_alias#.<cfif go_ifrs eq 0>INVENTORY_AMORTIZATON<cfelse>INVENTORY_AMORTIZATON_IFRS</cfif> WHERE INV_AMORT_MAIN_ID = #attributes.inv_id#
		</cfquery>
		<cfloop from="1" to="#attributes.all_records#" index="i">
			<cfif isdefined("attributes.invent_row#i#")>
				<cfscript>
					"attributes.new_inventory_value#i#" = filterNum(evaluate("attributes.new_inventory_value#i#"));
					"attributes.diff_value#i#" = filterNum(evaluate("attributes.diff_value#i#"));
					"attributes.period_diff_value#i#" = filterNum(evaluate("attributes.period_diff_value#i#"));
					"attributes.new_value#i#" = filterNum(evaluate("attributes.new_value#i#"));
					"attributes.total_amortization#i#" = filterNum(evaluate("attributes.total_amortization#i#"));
				</cfscript>
				<cfquery name="UPD_INVENTORY" datasource="#dsn2#">
					UPDATE
						#dsn3_alias#.INVENTORY
					SET
						<cfif go_ifrs eq 0>LAST_INVENTORY_VALUE<cfelse>LAST_INVENTORY_VALUE_IFRS</cfif> = #evaluate("attributes.new_value#i#")#,
						<cfif go_ifrs eq 0>LAST_INVENTORY_VALUE_2<cfelse>LAST_INVENTORY_VALUE_2_IFRS</cfif> = <cfif len(currency_multiplier)>#wrk_round(evaluate("attributes.new_value#i#")/currency_multiplier)#<cfelse>NULL</cfif>
					WHERE
						INVENTORY_ID = #evaluate("attributes.inventory_id#i#")#
				</cfquery>
				<cfquery name="ADD_AMORTIZATION" datasource="#dsn2#">
					INSERT INTO
						#dsn3_alias#.<cfif go_ifrs eq 0>INVENTORY_AMORTIZATON<cfelse>INVENTORY_AMORTIZATON_IFRS</cfif>
						(
							INVENTORY_ID,
							INV_AMORT_MAIN_ID,
							AMORTIZATON_VALUE,
							PERIODIC_AMORT_VALUE,
							AMORTIZATON_METHOD,
							AMORTIZATON_YEAR,
							AMORTIZATON_ESTIMATE,
							AMORTIZATON_INV_VALUE,
							DEBT_ACCOUNT_ID,
							CLAIM_ACCOUNT_ID,
							ACCOUNT_PERIOD,
							INV_QUANTITY
						)
						VALUES
						  (
							#evaluate("attributes.inventory_id#i#")#,
							#attributes.inv_id#,
							#evaluate("attributes.new_value#i#")#,
							#evaluate("attributes.period_diff_value#i#")#,
							#evaluate("attributes.amortization_method#i#")#,
							#Year(attributes.process_date)#,
							#evaluate("attributes.amortization_rate#i#")#,
							#evaluate("attributes.diff_value#i#")#,
							<cfif len(evaluate("attributes.debt_acc_id#i#"))>'#wrk_eval("attributes.debt_acc_id#i#")#'<cfelse>'#attributes.amort_debt_acc_id#'</cfif>,
							<cfif len(evaluate("attributes.claim_acc_id#i#"))>'#wrk_eval("attributes.claim_acc_id#i#")#'<cfelse>'#attributes.amort_claim_acc_id#'</cfif>,
							<cfif len(evaluate("attributes.period#i#"))>'#wrk_eval("attributes.period#i#")#'<cfelse>'#attributes.period#'</cfif>,
							#evaluate("attributes.quantity#i#")#
						   )
				</cfquery>
				<cfscript>
					if(len(evaluate("attributes.debt_acc_id#i#")))
						borc_hesaplar_list = ListAppend(borc_hesaplar_list,evaluate("attributes.debt_acc_id#i#"));
					else
						borc_hesaplar_list =ListAppend(borc_hesaplar_list,'#attributes.amort_debt_acc_id#');
					if(len(evaluate("attributes.claim_acc_id#i#")))	
						alacak_hesaplar_list=ListAppend(alacak_hesaplar_list,evaluate("attributes.claim_acc_id#i#"));
					else
						alacak_hesaplar_list=ListAppend(alacak_hesaplar_list,'#attributes.amort_claim_acc_id#');
					borc_tutarlar_list=ListAppend(borc_tutarlar_list,evaluate("attributes.total_amortization#i#"));
					alacak_tutarlar_list=ListAppend(alacak_tutarlar_list,evaluate("attributes.total_amortization#i#"));
					if(isdefined("attributes.project_id#i#") and len(evaluate("attributes.project_id#i#")))
					{
						acc_project_id = listappend(acc_project_id,evaluate("attributes.project_id#i#"),',');
						acc_project_list_alacak = listappend(acc_project_list_alacak,evaluate("attributes.project_id#i#"),',');
						acc_project_list_borc = listappend(acc_project_list_borc,evaluate("attributes.project_id#i#"),',');
					}
					else
					{
						acc_project_id = listappend(acc_project_id,'0',',');
						acc_project_list_alacak = listappend(acc_project_list_alacak,'0',',');
						acc_project_list_borc = listappend(acc_project_list_borc,'0',',');
					}
				</cfscript>
			</cfif>
		</cfloop>
		<cfscript>
			if(is_account eq 1)
			{
					muhasebeci (
						action_id: attributes.inv_id,
						workcube_process_type : process_type,
						workcube_old_process_type : attributes.old_process_type,
						account_card_type : 13,
						islem_tarihi : attributes.process_date,
						borc_hesaplar : borc_hesaplar_list,
						borc_tutarlar : borc_tutarlar_list,
						alacak_hesaplar : alacak_hesaplar_list,
						alacak_tutarlar : alacak_tutarlar_list,
						is_account_group : is_account_group,
						to_branch_id : ListGetAt(session.ep.user_location,2,'-'),
						fis_satir_detay: UCase(getLang('main',2747)),//AMORTİSMAN YENİDEN DEĞERLEME
						fis_detay : UCase(getLang('main',2747)),
						workcube_process_cat : form.process_cat,
						acc_project_list_alacak : acc_project_list_alacak,
						acc_project_list_borc : acc_project_list_borc//,
						//acc_project_id : acc_project_id liste olarak yollanıyor tek olmasına gerek var mı?
					);
			}
			else
			{
				muhasebe_sil(action_id:attributes.inv_id,process_type:attributes.old_process_type);
			}
			butce_sil (action_id:attributes.inv_id,muhasebe_db:dsn2,process_type:process_type);
			if(is_budget eq 1)
			{
				for(j=1;j lte attributes.all_records;j=j+1)
				{
					if (isdefined("attributes.invent_row#j#"))
					{
						net_total=evaluate("attributes.total_amortization#j#");
						if (len(evaluate("attributes.expense_item_id#j#")) and len(evaluate("attributes.expense_center_id#j#")))
						butceci(
							action_id : attributes.inv_id,
							muhasebe_db : dsn2,
							is_income_expense : false,
							process_type : process_type,
							nettotal : wrk_round(net_total),
							other_money_value : wrk_round(net_total/currency_multiplier),
							action_currency : session.ep.money,
							currency_multiplier : currency_multiplier,
							expense_date : attributes.process_date,
							expense_center_id : evaluate("attributes.expense_center_id#j#"),
							expense_item_id : evaluate("attributes.expense_item_id#j#"),
							detail : '#evaluate("attributes.invent_name#j#")#',
							branch_id : ListGetAt(session.ep.user_location,2,"-"),
							insert_type :1,
							project_id:'#evaluate("attributes.project_id#j#")#'
							);
						}
				}
			}
		</cfscript>
		<cfif len(get_process_type.action_file_name)> <!--- secilen islem kategorisine bir action file eklenmisse --->
			<cf_workcube_process_cat 
				process_cat="#form.process_cat#"
				action_id = #attributes.inv_id#
				is_action_file = 1
				action_file_name='#get_process_type.action_file_name#'
				action_db_type = '#dsn2#'
				is_template_action_file = '#get_process_type.action_file_from_template#'>
		</cfif>	
	</cftransaction>
</cflock>
<cfset attributes.actionId=attributes.inv_id />
<script type="text/javascript">
	window.location.href = "#request.self#?fuseaction=invent.list_invent_amortization&event=upd&inv_id=#attributes.inv_id#";
</script>
