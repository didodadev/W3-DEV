<cfif not isdefined("paper_currency_multiplier")><cfset paper_currency_multiplier = 0></cfif>
<cfif not isdefined("attributes.copy_order_count") or attributes.copy_order_count eq "">
	<cfset attributes.copy_order_count = 1>
	<cfset attributes.due_option = 3>
</cfif>
<cfset temp_order_count = attributes.copy_order_count-1>
<cfloop from="0" to="#temp_order_count#" index="i">
	<cfset temp_action_date = attributes.action_date>
	<cfif attributes.due_option eq 1>
		<cfset temp_payment_date = date_add('m',i,attributes.payment_date)>
	<cfelseif attributes.due_option eq 2>
		<cfset temp_payment_date = date_add('d',(i*attributes.due_day),attributes.payment_date)>
	<cfelseif attributes.due_option eq 3>
		<cfset temp_payment_date = attributes.payment_date>
	</cfif>
	<cfif isdefined("attributes.employee_id") and not isNumeric(attributes.employee_id)>
		<cfset attributes.employee_id = "">
	</cfif>
	<cfquery name="ADD_BANK_ORDER" datasource="#DSN2#" result="MAX_ID">
		INSERT INTO
			BANK_ORDERS
		(
			BANK_ORDER_TYPE,
			BANK_ORDER_TYPE_ID,
            FROM_BRANCH_ID,
			ACTION_VALUE,
			ACTION_MONEY,
            ACTION_BANK_ACCOUNT,
			ACCOUNT_ID,
			COMPANY_ID,
			CONSUMER_ID,
            EMPLOYEE_ID,
            ACC_TYPE_ID,
			TO_ACCOUNT_ID,
			PROJECT_ID,
			OTHER_MONEY_VALUE,
			OTHER_MONEY,
			ACTION_DATE,
			PAYMENT_DATE,
			IS_PAID,
			RELATED_ACTION_ID,
			RELATED_ACTION_TYPE_ID,
			ACTION_DETAIL,
			ASSETP_ID,
			CLOSED_ID,
			RECORD_DATE,
			RECORD_EMP,
			RECORD_IP,
			CREDIT_LIMIT_ID,
            SPECIAL_DEFINITION_ID
		)
		VALUES
		(
			#process_type#,
			<cfif isdefined("form.process_cat") and len(form.process_cat)>#form.process_cat#,<cfelse>NULL,</cfif>
            <cfif isdefined("attributes.branch_id") and len(attributes.branch_id)>#attributes.branch_id#<cfelse>NULL</cfif>,
			#attributes.ORDER_AMOUNT#,
			'#attributes.currency_id#',
            <cfif isdefined("attributes.list_bank") and len(attributes.list_bank)>#attributes.list_bank#<cfelse>NULL</cfif>,
			#attributes.account_id#,
            <cfif len(attributes.company_id)>#attributes.company_id#<cfelse>NULL</cfif>,
			<cfif len(attributes.consumer_id)>#attributes.consumer_id#<cfelse>NULL</cfif>,
            <cfif isDefined("attributes.employee_id") and len(attributes.employee_id)>#attributes.employee_id#<cfelse>NULL</cfif>,
            <cfif len(attributes.acc_type_id)>#attributes.acc_type_id#<cfelse>NULL</cfif>,
			<cfif not (isdefined("attributes.employee_id") and len(attributes.employee_id)) and get_bank.recordcount>#get_bank.BANK_ID#<cfelse>NULL</cfif>,
			<cfif len(attributes.project_name) and len(attributes.project_id)>#attributes.project_id#<cfelse>NULL</cfif>,
			<cfif isDefined("attributes.OTHER_CASH_ACT_VALUE") and len(attributes.OTHER_CASH_ACT_VALUE)>#attributes.OTHER_CASH_ACT_VALUE#<cfelse>NULL</cfif>,
			<cfif isDefined("attributes.money_type") and len(attributes.money_type)>'#attributes.money_type#'<cfelse>NULL</cfif>,
			#temp_action_date#,
			#temp_payment_date#,
			0, <!---banka talimatından havale olusturulmadigini gosteriyor  --->
			<cfif isDefined("attributes.related_action_id") and len(attributes.related_action_id)>#attributes.related_action_id#<cfelse>NULL</cfif>,
			<cfif isDefined("attributes.related_action_type_id") and len(attributes.related_action_type_id)>#attributes.related_action_type_id#<cfelse>NULL</cfif>,
			<cfif isDefined("attributes.ACTION_DETAIL") and len(attributes.ACTION_DETAIL)>'#attributes.ACTION_DETAIL#'<cfelse>NULL</cfif>,
			<cfif isdefined("attributes.asset_id") and len(attributes.asset_id) and len(attributes.asset_name)>#attributes.asset_id#<cfelse>NULL</cfif>,
			<cfif isdefined("attributes.order_id") and len(attributes.order_id)>#attributes.order_id#<cfelse>NULL</cfif>,
			#now()#,
			#session.ep.userid#,
			'#CGI.REMOTE_ADDR#',
			<cfif isdefined("attributes.credit_limit") and len(attributes.credit_limit)>#attributes.credit_limit#,<cfelse>NULL,</cfif>
            <cfif isdefined("attributes.special_definition_id") and len(attributes.special_definition_id)>#attributes.special_definition_id#<cfelse>NULL</cfif>
		)
	</cfquery>
	<cfscript>
		if(not isDefined("is_from_makeage"))
		{
			currency_multiplier = '';
			if(isDefined('attributes.kur_say') and len(attributes.kur_say))
				for(mon=1;mon lte attributes.kur_say;mon=mon+1)
					if(evaluate("attributes.hidden_rd_money_#mon#") is session.ep.money2)
						currency_multiplier = evaluate('attributes.txt_rate2_#mon#/attributes.txt_rate1_#mon#');
		}			
		if(is_account eq 1)
		{
			if (isDefined("attributes.ACTION_DETAIL") and len(attributes.ACTION_DETAIL))
				str_card_detail = '#attributes.ACTION_DETAIL#';
			else
				str_card_detail = 'Giden Banka Talimatı';
				
			//muhasebe fisi icin, olusabilecek yuvarlama satırının bilgileri
			GET_NO_ = cfquery(datasource:"#dsn2#", sqlstring:"SELECT FARK_GELIR,FARK_GIDER FROM #dsn3_alias#.SETUP_INVOICE_PURCHASE");
			str_fark_gelir = get_no_.fark_gelir;
			str_fark_gider = get_no_.fark_gider;
			str_max_round = 0.1;
			str_round_detail = 'GİDEN BANKA TALİMATI';
						
			muhasebeci
			(
				action_id : MAX_ID.IDENTITYCOL,
				workcube_process_type : process_type,
				workcube_process_cat:form.process_cat,
				islem_tarihi : temp_action_date,
				fis_detay : 'GİDEN BANKA TALİMATI',
				company_id : attributes.company_id,
				consumer_id : attributes.consumer_id,
				borc_hesaplar : borclu_hesap,
				borc_tutarlar : attributes.system_amount,
				other_amount_borc : iif(len(attributes.OTHER_CASH_ACT_VALUE),'attributes.OTHER_CASH_ACT_VALUE',de('')),
				other_currency_borc :attributes.money_type,
				alacak_hesaplar : GET_BANK_ORDER_CODE.ACCOUNT_ORDER_CODE,
				alacak_tutarlar : attributes.system_amount,
				other_amount_alacak : attributes.ORDER_AMOUNT,
				other_currency_alacak : attributes.currency_id,
				fis_satir_detay: str_card_detail,
				currency_multiplier : currency_multiplier,
				from_branch_id : branch_id_info,
				account_card_type : 13,
				dept_round_account :str_fark_gider,
				claim_round_account : str_fark_gelir,
				max_round_amount :str_max_round,
				acc_project_id : attributes.project_id,
				round_row_detail:str_round_detail				
			);
		}		
		if(is_cari eq 1)
		{
			if (isDefined("attributes.ACTION_DETAIL") and len(attributes.ACTION_DETAIL))
				act_detail = '#attributes.ACTION_DETAIL#';
			else
				act_detail = '';
			if (isdefined("attributes.order_id") and len(attributes.order_id))
				paper_no_info = '#MAX_ID.IDENTITYCOL#';
			else
				paper_no_info = '';
			carici
				(
				action_id : MAX_ID.IDENTITYCOL,
				workcube_process_type : process_type,	
				action_table : 'BANK_ORDERS',			
				process_cat : form.process_cat,
				islem_tarihi : temp_action_date,				
				to_cmp_id : attributes.company_id,	
				to_consumer_id : attributes.consumer_id,
				to_employee_id : iif(isdefined("attributes.employee_id") and len(attributes.employee_id),'attributes.employee_id',de('')),
				acc_type_id : attributes.acc_type_id,
				islem_tutari : attributes.system_amount,
				action_currency : session.ep.money,				
				other_money_value : iif(len(attributes.OTHER_CASH_ACT_VALUE),'attributes.OTHER_CASH_ACT_VALUE',de('')),
				other_money : attributes.money_type,
				currency_multiplier : currency_multiplier,
				action_detail : act_detail,
				islem_detay : 'Ödeme Emri(Giden Banka Talimatı)',					
				account_card_type : 13,
				due_date: temp_payment_date,
				from_account_id : attributes.account_id,
				from_branch_id : branch_id_info,
				project_id : attributes.project_id,
				islem_belge_no : paper_no_info,
				is_processed : 0, //banka banka talimatının havaleye çekilmedigini gösteriyor.
				assetp_id : iif((isdefined("attributes.asset_id") and len(attributes.asset_id) and len(attributes.asset_name)),'attributes.asset_id',de('')),
				rate2: paper_currency_multiplier
				);
		}
		f_kur_ekle_action(action_id:MAX_ID.IDENTITYCOL,process_type:0,action_table_name:'BANK_ORDER_MONEY',action_table_dsn:'#dsn2#');
	</cfscript>	
	<cfset fark = 8 - len(MAX_ID.IDENTITYCOL)>
	<cfset seri_no = "#MAX_ID.IDENTITYCOL#">
		<cfif fark gt 0>
			<cfloop from="1" to="#fark#" index="i">
				<cfset seri_no = '0' & '#seri_no#'>
			</cfloop>
		<cfelse>
			<cfset seri_no = "#MAX_ID.IDENTITYCOL#">
		</cfif>
	<cfquery name="upd_" datasource="#DSN2#">
		UPDATE BANK_ORDERS SET SERI_NO = '#seri_no#' WHERE BANK_ORDER_ID = #MAX_ID.IDENTITYCOL#
	</cfquery>
	<cfif isdefined("attributes.order_id") and len(attributes.order_id) and isdefined("attributes.order_row_id") and len(attributes.order_row_id)><!--- ödeme emirlerinden ödeme yapıldıgnda.. --->
		<cfquery name="UPD_CLOSED_" datasource="#DSN2#">
			UPDATE
				CARI_CLOSED
			SET
				IS_BANK_ORDER = 1
			WHERE
				CLOSED_ID = #attributes.order_id#
		</cfquery>
		<cfif is_cari eq 1>
			<cfquery name="GET_CARI_INFO" datasource="#DSN2#">
				SELECT 
					* 
				FROM 
					CARI_ROWS 
				WHERE 
					ACTION_ID = #MAX_ID.IDENTITYCOL# AND 
					ACTION_TYPE_ID = #process_type#
			</cfquery>
			<cfif len(GET_CARI_INFO.recordcount) and (isDefined("attributes.correspondence_info") and len(attributes.correspondence_info))>
				<cfquery name="UPD_CLOSED" datasource="#DSN2#">
					UPDATE
						CARI_CLOSED_ROW
					SET
						RELATED_CLOSED_ROW_ID = 0,
						RELATED_CARI_ACTION_ID = #GET_CARI_INFO.CARI_ACTION_ID#,
						CLOSED_AMOUNT = P_ORDER_VALUE,
						OTHER_CLOSED_AMOUNT = OTHER_P_ORDER_VALUE
					WHERE
						CLOSED_ID = #attributes.order_id#
				</cfquery>
			<cfelseif len(GET_CARI_INFO.recordcount)>
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
						#attributes.order_id#,
						#GET_CARI_INFO.CARI_ACTION_ID#,
						#MAX_ID.IDENTITYCOL#,
						#process_type#,
						#attributes.system_amount#,
						#attributes.system_amount#,
						#attributes.other_cash_act_value#,
						#attributes.system_amount#,
						#attributes.other_cash_act_value#,
						'#attributes.money_type#',
						#temp_payment_date#
					)
				</cfquery>
				<cfif isdefined("attributes.order_row_id") and len(attributes.order_row_id)>
					<cfquery name="GET_MAX_C_ID" datasource="#DSN2#">
						SELECT MAX(CLOSED_ROW_ID) C_MAX_ID FROM CARI_CLOSED_ROW
					</cfquery>
					<cfquery name="GET_CLOSED" datasource="#DSN2#">
						SELECT P_ORDER_DEBT_AMOUNT_VALUE,P_ORDER_CLAIM_AMOUNT_VALUE FROM CARI_CLOSED WHERE CLOSED_ID = #attributes.order_id#
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
							CLOSED_ID = #attributes.order_id#
					</cfquery>
					<cfquery name="UPD_CLOSED" datasource="#DSN2#">
						UPDATE
							CARI_CLOSED_ROW
						SET
							RELATED_CLOSED_ROW_ID = #GET_MAX_C_ID.C_MAX_ID#,
							CLOSED_AMOUNT = P_ORDER_VALUE,
							OTHER_CLOSED_AMOUNT = OTHER_P_ORDER_VALUE
						WHERE
							CLOSED_ROW_ID IN (#attributes.order_row_id#) AND
							CLOSED_ID = #attributes.order_id#
					</cfquery>
				</cfif>
		</cfif>
		</cfif>
	</cfif>
	<cf_workcube_process_cat 
			process_cat="#form.process_cat#"
			action_id = #MAX_ID.IDENTITYCOL#
			is_action_file = 1
			action_file_name='#get_process_type.action_file_name#'
			action_page='#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.list_assign_order&event=upd_assign&bank_order_id=#MAX_ID.IDENTITYCOL#'
			action_db_type = '#dsn2#'
			is_template_action_file = '#get_process_type.action_file_from_template#'>
</cfloop>
