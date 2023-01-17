<cfif form.active_period neq session.ep.period_id>
	<script type="text/javascript">
		alert("<cf_get_lang_main no='1659.İşlem Yapmak İstediğiniz Muhasebe Dönemi ile Aktif Muhasebe Döneminiz Farklı Muhasebe Döneminizi Kontrol Ediniz'>!");
		window.location.href='<cfoutput>#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.form_add_bank_rate_valuation</cfoutput>';
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
		PROCESS_CAT
	 FROM 
	 	SETUP_PROCESS_CAT 
	WHERE 
		PROCESS_CAT_ID = #form.process_cat#
</cfquery>
<cfscript>
	process_type = get_process_type.PROCESS_TYPE;
	is_budget = get_process_type.IS_BUDGET;
	is_account = get_process_type.IS_ACCOUNT;
</cfscript>
<cf_date tarih='attributes.action_date'>
<cfscript>
	for(r=1; r lte attributes.total_record; r=r+1)
	{
		if(isdefined("attributes.is_pay_#r#"))
		{
			'attributes.control_amount_2_#r#' = filterNum(evaluate('attributes.control_amount_2_#r#'));
		}
	}
	for(m_sy=1; m_sy lte attributes.kur_say; m_sy = m_sy+1)
	{
		'attributes.txt_rate1_#m_sy#' = filterNum(evaluate('attributes.txt_rate1_#m_sy#'),session.ep.our_company_info.rate_round_num);
		'attributes.txt_rate2_#m_sy#' = filterNum(evaluate('attributes.txt_rate2_#m_sy#'),session.ep.our_company_info.rate_round_num);
	}		
	currency_multiplier = 1;
	if(isDefined('attributes.kur_say') and len(attributes.kur_say))
		for(mon=1;mon lte attributes.kur_say;mon=mon+1)
			if(evaluate("attributes.hidden_rd_money_#mon#") is session.ep.money2)
				currency_multiplier = evaluate('attributes.txt_rate2_#mon#/attributes.txt_rate1_#mon#');
	
	if(isdefined('attributes.acc_department_id') and len(attributes.acc_department_id))
		acc_department_id = attributes.acc_department_id;
	else
		acc_department_id = '';
</cfscript>
<cflock name="#createUUID()#" timeout="20">
	<cftransaction>
		<cfquery name="add_bank_actions_multi" datasource="#dsn2#">
			INSERT INTO
				BANK_ACTIONS_MULTI
				(
					PROCESS_CAT,
					ACTION_TYPE_ID,
					ACTION_DATE,
					IS_ACCOUNT,
					IS_ACCOUNT_TYPE,
					RECORD_EMP,
					RECORD_IP,
					RECORD_DATE,
					ACC_DEPARTMENT_ID			
				)
				VALUES
				(
					#form.process_cat#,
					#process_type#,
					#attributes.action_date#,
					<cfif get_process_type.is_account eq 1>1,13,<cfelse>0,13,</cfif>
					#SESSION.EP.USERID#,
					'#CGI.REMOTE_ADDR#',
					#NOW()#,
					<cfif len(acc_department_id)>#acc_department_id#<cfelse>NULL</cfif>			
					)
		</cfquery>
		<cfquery name="get_multi_id" datasource="#dsn2#">
			SELECT MAX(MULTI_ACTION_ID) AS MULTI_ID FROM BANK_ACTIONS_MULTI
		</cfquery>
		<cfset total_borc_amount = 0>
		<cfset total_alacak_amount = 0>
		<cfloop from="1" to="#attributes.total_record#" index="kk">
			<cfif isdefined("attributes.is_pay_#kk#")>				
				<cfquery name="ADD_BANK_ACT" datasource="#dsn2#">
					INSERT INTO
						BANK_ACTIONS
						(
							MULTI_ACTION_ID,
							PROCESS_CAT,
							ACTION_TYPE,
							ACTION_TYPE_ID,
							ACTION_TO_ACCOUNT_ID,
							TO_BRANCH_ID,
							ACTION_FROM_ACCOUNT_ID,
							FROM_BRANCH_ID,
							ACTION_DATE,
							ACTION_VALUE,
							ACTION_CURRENCY_ID,
							OTHER_CASH_ACT_VALUE,
							OTHER_MONEY,
							IS_ACCOUNT,
							IS_ACCOUNT_TYPE,
							ACTION_DETAIL,
							RECORD_EMP,
							RECORD_IP,
							RECORD_DATE,
							SYSTEM_ACTION_VALUE,
							SYSTEM_CURRENCY_ID
							<cfif len(session.ep.money2)>
								,ACTION_VALUE_2
								,ACTION_CURRENCY_ID_2
							</cfif>
						)
						VALUES
						(
							#get_multi_id.multi_id#,
							#form.process_cat#,
							'KUR DEĞERLEME İŞLEMİ',
							#process_type#,
							<cfif evaluate("attributes.control_amount_2_#kk#") gt 0>
								#evaluate("attributes.acc_id_#kk#")#,
								#listgetat(session.ep.user_location,2,'-')#
							<cfelse>
								NULL,
								NULL
							</cfif>,
							<cfif evaluate("attributes.control_amount_2_#kk#") lt 0>
								#evaluate("attributes.acc_id_#kk#")#,
								#listgetat(session.ep.user_location,2,'-')#
							<cfelse>
								NULL,
								NULL
							</cfif>,
							#attributes.action_date#,
							0,
							'#evaluate("attributes.other_money_#kk#")#',
							0,
							'#evaluate("attributes.other_money_#kk#")#',
							<cfif is_account eq 1>1<cfelse>0</cfif>,
							13,
							'#attributes.action_detail#',
							#SESSION.EP.USERID#,
							'#CGI.REMOTE_ADDR#',
							#NOW()#,
							#abs(evaluate("attributes.control_amount_2_#kk#"))#,
							'#session.ep.money#'
							<cfif len(session.ep.money2)>
								,#wrk_round(abs(evaluate("attributes.control_amount_2_#kk#"))/currency_multiplier,4)#
								,'#session.ep.money2#'
							</cfif>
						)
				</cfquery>
				<cfif evaluate("attributes.control_amount_2_#kk#") gt 0>
					<cfset total_borc_amount = total_borc_amount + abs(evaluate("attributes.control_amount_2_#kk#"))>
				<cfelse>
					<cfset total_alacak_amount = total_alacak_amount + abs(evaluate("attributes.control_amount_2_#kk#"))>
				</cfif>
				<cfquery name="get_act_id" datasource="#dsn2#">
					SELECT MAX(ACTION_ID) AS ACTION_ID FROM BANK_ACTIONS
				</cfquery>
				<cfscript>
					if(is_budget eq 1 and len(attributes.expense_center) and len(attributes.expense_center_id) and len(attributes.expense_item_id) and len(attributes.expense_item_name))
					{
						if(evaluate("attributes.control_amount_2_#kk#") gt 0)
							is_income = 'true';
						else
							is_income = 'false';
						
						butceci(
							action_id : get_act_id.action_id,
							muhasebe_db : dsn2,
							is_income_expense : is_income,
							process_type : process_type,
							nettotal : abs(evaluate("attributes.control_amount_2_#kk#")),
							other_money_value : 0,
							action_currency : evaluate("attributes.other_money_#kk#"),
							currency_multiplier : currency_multiplier,
							expense_date : attributes.action_date,
							expense_center_id : attributes.expense_center_id,
							expense_item_id : attributes.expense_item_id,
							detail : 'BANKA KUR DEĞERLEME FİŞİ',
							branch_id : listgetat(session.ep.user_location,2,'-'),
							insert_type : 1
						);
					}
				</cfscript>
			</cfif>
		</cfloop>
		<cfscript>		
			if(is_account eq 1)
			{
				hesap_list = '';
				tutar_list='';
				doviz_tutar_borc='';
				doviz_currency_borc='';
				for(k=1; k lte attributes.total_record; k=k+1)
					if(isdefined("attributes.is_pay_#k#"))
					{
						hesap_list = listappend(hesap_list,evaluate("attributes.account_code_#k#"),',');						
						tutar_list = listappend(tutar_list,abs(evaluate("attributes.control_amount_2_#k#")),',');
						doviz_tutar_borc = listappend(doviz_tutar_borc,0,',');
						doviz_currency_borc = listappend(doviz_currency_borc,evaluate("attributes.other_money_#k#"),',');
						satir_detay_list[1][listlen(tutar_list)]='BANKA KUR DEĞERLEME';
					}
				if(total_borc_amount gt 0)
				{			
					muhasebeci (
						action_id: get_multi_id.multi_id,
						workcube_process_type:process_type,
						workcube_process_cat:form.process_cat,
						acc_department_id:acc_department_id,
						account_card_type:13,
						islem_tarihi:attributes.action_date,
						borc_hesaplar: hesap_list,
						borc_tutarlar: tutar_list,
						alacak_hesaplar: attributes.action_account_code,
						alacak_tutarlar: total_borc_amount,
						other_amount_alacak : total_borc_amount,
						other_currency_alacak : session.ep.money,
						other_amount_borc : doviz_tutar_borc,
						other_currency_borc : doviz_currency_borc,
						fis_satir_detay:'BANKA KUR DEĞERLEME İŞLEMİ',
						currency_multiplier : currency_multiplier,
						fis_detay:'BANKA KUR DEĞERLEME İŞLEMİ',
						from_branch_id : listgetat(session.ep.user_location,2,'-')
						);
				}	
				else
				{			
					muhasebeci (
						action_id: get_multi_id.multi_id,
						workcube_process_type:process_type,
						workcube_process_cat:form.process_cat,
						acc_department_id:acc_department_id,
						account_card_type:13,
						islem_tarihi:attributes.action_date,
						borc_hesaplar: attributes.action_account_code,
						borc_tutarlar: total_alacak_amount,
						alacak_hesaplar: hesap_list,
						alacak_tutarlar: tutar_list,
						other_amount_alacak : doviz_tutar_borc,
						other_currency_alacak : doviz_currency_borc,
						other_amount_borc : total_alacak_amount,
						other_currency_borc : session.ep.money,
						fis_satir_detay:'BANKA KUR DEĞERLEME İŞLEMİ',
						currency_multiplier : currency_multiplier,
						fis_detay:'BANKA KUR DEĞERLEME İŞLEMİ',
						from_branch_id : listgetat(session.ep.user_location,2,'-')
						);
				}	
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
						RATE1
					)
					VALUES
					(
						#get_multi_id.multi_id#,
						'#wrk_eval("attributes.hidden_rd_money_#r#")#',
						#evaluate("attributes.txt_rate2_#r#")#,
						#evaluate("attributes.txt_rate1_#r#")#
					)
			</cfquery>
		</cfloop>
		
			<cf_workcube_process_cat 
				process_cat="#form.process_cat#"
				action_id = #GET_ACT_ID.ACTION_ID#
				is_action_file = 1
				action_file_name='#get_process_type.action_file_name#'
				action_page='#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.form_add_bank_rate_valuation'
				action_db_type = '#dsn2#'
				is_template_action_file = '#get_process_type.action_file_from_template#'>
		
	</cftransaction>
</cflock>
<script type="text/javascript">
	windowopen('<cfoutput>#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.popup_dsp_bank_rate_valuation&multi_action_id=#get_multi_id.multi_id#</cfoutput>','small');
	window.location.href='<cfoutput>#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.form_add_bank_rate_valuation</cfoutput>';
</script>
