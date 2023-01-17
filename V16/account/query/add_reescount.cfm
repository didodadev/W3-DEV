<cf_date tarih='attributes.due_date'>
<cf_date tarih='attributes.average_due_date'>
<cf_date tarih='attributes.action_date'>
<cfquery name="get_process_type" datasource="#dsn3#">
	SELECT 
		PROCESS_TYPE,
		IS_BUDGET
	FROM 
	 	SETUP_PROCESS_CAT 
	WHERE 
		PROCESS_CAT_ID = #form.process_cat#
</cfquery>
<cfscript>
	process_type = get_process_type.PROCESS_TYPE;
	is_budget = get_process_type.IS_BUDGET;
</cfscript>

<cflock name="#createUUID()#" timeout="60">			
	<cftransaction>
		<cfquery name="add_reescount" datasource="#dsn2#">
			INSERT INTO
				REESCOUNT
				(
					REESCOUNT_RATE,
					DUE_DATE,
					ACTION_DATE,
					BA,
					PROCESS_CAT,
					TOTAL_VALUE,
					TOTAL_REESCOUNT_VALUE,
					AVE_DUE_DATE,
					EXP_CENTER_ID,
					EXP_ITEM_ID,
					REESCOUNT_ACC_CODE,
					CHEQ_VOUCHER_ACC_CODE,
					DETAIL,
					RECORD_EMP,
					RECORD_IP,
					RECORD_DATE				
				)
				VALUES
				(
					#attributes.reeskont_rate#,
					#attributes.due_date#,
					#attributes.action_date#,
					<cfif len(attributes.duty_claim) and attributes.duty_claim eq 1>0<cfelseif len(attributes.duty_claim) and attributes.duty_claim eq 2>1<cfelse>NULL</cfif>,
					#get_process_type.process_type#,
					<cfif isdefined("attributes.total_value") and len(attributes.total_value)>#attributes.total_value#<cfelse>NULL</cfif>,
					<cfif isdefined("attributes.total_reescount_value") and len(attributes.total_reescount_value)>#attributes.total_reescount_value#<cfelse>NULL</cfif>,
					#attributes.average_due_date#,
					<cfif isdefined("attributes.expense_center_id") and len(attributes.expense_center_id)>#attributes.expense_center_id#<cfelse>NULL</cfif>,
					<cfif isdefined("attributes.expense_item_id") and len(attributes.expense_item_id)>#attributes.expense_item_id#<cfelse>NULL</cfif>,
					<cfif isdefined("attributes.reeskont_acc_code") and len(attributes.reeskont_acc_code)>'#attributes.reeskont_acc_code#'<cfelse>NULL</cfif>,
					<cfif isdefined("attributes.equivalent_acc_code") and len(attributes.equivalent_acc_code)>'#attributes.equivalent_acc_code#'<cfelse>NULL</cfif>,
					<cfif isdefined("attributes.detail") and len(attributes.detail)>'#attributes.detail#'<cfelse>NULL</cfif>,
					#session.ep.userid#,
					'#cgi.remote_addr#',
					#now()#				
				)
		</cfquery>
		<cfquery name="get_multi_id" datasource="#dsn2#">
			SELECT MAX(REESCOUNT_ID) AS MAX_REESCOUNT_ID FROM REESCOUNT
		</cfquery>
		<cfif isdefined("attributes.record_num") and len(attributes.record_num)>
			<cfloop from="1" to="#attributes.record_num#" index="i">
				<cfif isdefined("attributes.row_check#i#") and evaluate("attributes.row_check#i#")>
					<cfquery name="add_dekont" datasource="#dsn2#">
						INSERT INTO
							REESCOUNT_ROWS
							(
								REESCOUNT_ID,
								CHEQUE_ID,
								VOUCHER_ID,
								CHEQ_VOUCHER_DUE_DATE,
								NET_VALUE,
								REESCOUNT_VALUE,
								CURRENCY_ID,
								DUEDATE_DIFF						
							)
							VALUES
							(
								#get_multi_id.max_reescount_id#,
								<cfif isdefined("attributes.is_cheque") and len(attributes.is_cheque)>#evaluate("attributes.cheque_id#i#")#<cfelse>NULL</cfif>,
								<cfif isdefined("attributes.is_voucher") and len(attributes.is_voucher)>#evaluate("attributes.voucher_id#i#")#<cfelse>NULL</cfif>,
								<cfqueryparam cfsqltype="cf_sql_timestamp" value="#evaluate('attributes.cheq_voucher_due_date#i#')#">,	
								#evaluate("attributes.cheq_voucher_value#i#")#,	
								#evaluate("attributes.reescount_value#i#")#,
								'#evaluate("attributes.currency_id#i#")#',
								<cfif isdefined("attributes.duedate_diff#i#") and evaluate("attributes.duedate_diff#i#")>#evaluate("attributes.duedate_diff#i#")#<cfelse>NULL</cfif>
							)
					</cfquery>		
				</cfif>
			</cfloop>
		</cfif>
		
		<!--- reescount islemine ait muhasebe kaydi --->
		<cfscript>
			tutar = attributes.total_reescount_value;
			if (attributes.duty_claim eq 1)		//borc karakterli islem, reeskont muhasebe koduna borc kaydedilir
			{
				borc_hesaplar = attributes.reeskont_acc_code;
				alacak_hesaplar = attributes.equivalent_acc_code;
			}
			else								//alacak karakterli islem, reeskont muhasebe koduna alacak kaydedilir
			{
				alacak_hesaplar = attributes.reeskont_acc_code;
				borc_hesaplar = attributes.equivalent_acc_code;
			}
			
			if(isDefined("attributes.detail") and len(attributes.detail))
				satir_detay_list = '#attributes.detail#';
			else
				satir_detay_list = 'REESKONT İŞLEMİ';
					
			muhasebeci(
				action_id : get_multi_id.max_reescount_id,  
				workcube_process_type : process_type,		
				workcube_process_cat : form.process_cat,	
				account_card_type : listfirst(attributes.receipt_type,';'),
				account_card_catid : listlast(attributes.receipt_type,';'),		
				islem_tarihi : attributes.action_date,		
				borc_hesaplar : borc_hesaplar,				
				borc_tutarlar : tutar,						
				other_amount_borc : tutar,	
				other_currency_borc : session.ep.money,
				alacak_hesaplar : alacak_hesaplar,			
				alacak_tutarlar : tutar,					
				other_amount_alacak : tutar,
				other_currency_alacak : session.ep.money,
				fis_detay : 'REESKONT ISLEMI',				
				fis_satir_detay : satir_detay_list			
			);
			/* butce hareketi yapilsin secili ise ve butce kalemi ile masraf merkezi varsa butce hareketi yapilir */
			if(is_budget eq 1 and len(attributes.expense_center_name) and len(attributes.expense_center_id) and len(attributes.expense_item_id) and len(attributes.expense_item_name))
			{
				if(attributes.duty_claim eq 2)		//alacak 
					is_income = 'true';
				else								//borc
					is_income = 'false';
				
				butceci(
					action_id : get_multi_id.max_reescount_id,
					muhasebe_db : dsn2,
					is_income_expense : is_income,
					process_type : process_type,
					nettotal : attributes.total_reescount_value,
					other_money_value : 0,
					action_currency : attributes.money_type,
					expense_date : attributes.action_date,
					expense_center_id : attributes.expense_center_id,
					expense_item_id : attributes.expense_item_id,
					detail : 'REESKONT İŞLEMİ',
					branch_id : listgetat(session.ep.user_location,2,'-'),
					insert_type : 1
				);
			}
		</cfscript>
	</cftransaction>
</cflock>
<cflocation url="#request.self#?fuseaction=account.list_reescount" addtoken="No">
