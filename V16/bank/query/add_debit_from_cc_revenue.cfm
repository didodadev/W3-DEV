<!--- kredi kartı tahsilatlarında ödeme yönteminde komisyon varsa hesap seçilmişse komisyon kadar dekont kaydedilr --->
<cfif isDefined("is_upd_info")><!--- güncelleme sayfasından gelen kayıtlar için --->
	<cfquery name="GET_PROCESS_CAT" datasource="#dsn3#">
		SELECT PROCESS_CAT_ID,IS_CARI,IS_ACCOUNT FROM SETUP_PROCESS_CAT WHERE PROCESS_TYPE = <cfif listfind('241,2410',process_type)>41<cfelse>42</cfif>
	</cfquery>
	<cfif not len(GET_PROCESS_CAT.PROCESS_CAT_ID)>
		<script type="text/javascript">
			alert("<cf_get_lang no ='397.Lütfen Dekont İşlem Tipi Tanımlayınız'>!");
			history.back();	
		</script>
		<cfabort>
	</cfif>
	<cfquery name="ADD_CASH_PAYMENT_IN_OP" datasource="#dsn3#">
		INSERT INTO
			#dsn2_alias#.CARI_ACTIONS
			(
				PROCESS_CAT,
				ACTION_NAME,
				ACTION_TYPE_ID,
				ACTION_VALUE,
				ACTION_CURRENCY_ID,
				OTHER_MONEY,
				OTHER_CASH_ACT_VALUE,
				TO_CMP_ID,								
				FROM_CMP_ID,
				TO_CONSUMER_ID,
				FROM_CONSUMER_ID,
				ACTION_DETAIL,
				ACTION_ACCOUNT_CODE,
				ACTION_DATE,
				PROJECT_ID,
				PAPER_NO,
				ASSETP_ID,
				RECORD_DATE,
				RECORD_EMP,
				RECORD_IP								
			)
			VALUES
			(
				#GET_PROCESS_CAT.PROCESS_CAT_ID#,
				<cfif listfind('241,2410',process_type)>'BORÇ DEKONTU',<cfelse>'ALACAK DEKONTU',</cfif>
				<cfif listfind('241,2410',process_type)>41,<cfelse>42,</cfif>
				#wrk_round(attributes.sales_credit - attributes.sales_credit_comm)#,
				'#attributes.currency_id#',
				<cfif len(attributes.money_type)>'#attributes.money_type#',<cfelse>NULL,</cfif>
				<cfif len(currency_multiplier_2) and len(currency_multiplier_other)>#wrk_round(((attributes.sales_credit - attributes.sales_credit_comm)*currency_multiplier_2)/currency_multiplier_other)#,<cfelse>NULL,</cfif>
				<cfif listfind('241,2410',process_type) and len(attributes.action_from_company_id)>#attributes.action_from_company_id#,<cfelse>NULL,</cfif>
				<cfif process_type eq 245 and len(attributes.action_from_company_id)>#attributes.action_from_company_id#,<cfelse>NULL,</cfif>
				<cfif listfind('241,2410',process_type) and len(attributes.cons_id)>#attributes.cons_id#,<cfelse>NULL,</cfif>
				<cfif process_type eq 245 and len(attributes.cons_id)>#attributes.cons_id#,<cfelse>NULL,</cfif>
				<cfif len(attributes.action_detail)>'#attributes.action_detail#',<cfelse>NULL,</cfif>
				'#GET_CREDIT_PAYMENT.PAYMENT_RATE_ACC#',
				#attributes.action_date#,
				<cfif isdefined('attributes.project_id') and len(attributes.project_id) and len(attributes.project_name)>#attributes.project_id#,<cfelse>NULL,</cfif>
				<cfif isdefined("attributes.paper_number") and len(attributes.paper_number)>'#attributes.paper_number#',<cfelse>NULL,</cfif>
				<cfif isdefined("attributes.asset_id") and len(attributes.asset_id) and len(attributes.asset_name)>#attributes.asset_id#<cfelse>NULL</cfif>,
				#now()#,
				#session.ep.userid#,
				'#cgi.remote_addr#'						
			)					
	</cfquery>
	<cfquery name="GET_MAX_CH" datasource="#dsn3#">
		SELECT MAX(ACTION_ID) AS ACTION_ID FROM #dsn2_alias#.CARI_ACTIONS
	</cfquery>
	<cfscript>
		act_value_ch = wrk_round(attributes.sales_credit - attributes.sales_credit_comm);
		if (len(currency_multiplier_2) and len(currency_multiplier_other))
			act_other_money_value = wrk_round((attributes.sales_credit - attributes.sales_credit_comm)/currency_multiplier_other);
		else
			act_other_money_value = '';
		act_other_money = form.money_type;
		if(GET_PROCESS_CAT.IS_CARI eq 1)
		{
			carici(
				action_id : GET_MAX_CH.ACTION_ID,
				process_cat : GET_PROCESS_CAT.PROCESS_CAT_ID,
				workcube_process_type : iif((listfind('241,2410',process_type)),41,42),
				action_table : 'CARI_ACTIONS',
				islem_tutari : act_value_ch,
				islem_belge_no : attributes.paper_number,
				action_currency : session.ep.money,
				other_money_value : iif(len(act_other_money_value),'act_other_money_value',de('')),
				other_money : act_other_money,
				islem_tarihi : attributes.action_date,
				islem_detay : iif((listfind('241,2410',process_type)),de('BORÇ DEKONTU'),de('ALACAK DEKONTU')),
				action_detail : attributes.action_detail,
				to_cmp_id : iif((listfind('241,2410',process_type) and len(attributes.action_from_company_id)),attributes.action_from_company_id,de('')),
				from_cmp_id : iif((process_type eq 245 and len(attributes.action_from_company_id)),attributes.action_from_company_id,de('')),
				to_consumer_id : iif((listfind('241,2410',process_type) and len(attributes.cons_id)),attributes.cons_id,de('')),
				from_consumer_id : iif((process_type eq 245 and len(attributes.cons_id)),attributes.cons_id,de('')),
				currency_multiplier : currency_multiplier,
				account_card_type : 13,
				cari_db : dsn3,
				project_id : iif((isdefined('attributes.project_id') and len(attributes.project_id) and len(attributes.project_name)),attributes.project_id,de('')),
				to_branch_id : iif((listfind('241,2410',process_type)),branch_id_info,de('')),
				from_branch_id : iif((process_type eq 245),branch_id_info,de('')),
				assetp_id : iif((isdefined("attributes.asset_id") and len(attributes.asset_id) and len(attributes.asset_name)),'attributes.asset_id',de('')),
				rate2:currency_multiplier_other
				);
		}
		if(GET_PROCESS_CAT.IS_ACCOUNT eq 1)
		{
			muhasebeci (
				action_id:GET_MAX_CH.ACTION_ID,
				workcube_process_type : iif((listfind('241,2410',process_type)),41,42),
				workcube_old_process_type : iif((listfind('241,2410',process_type)),41,42),
				workcube_process_cat:form.process_cat,
				account_card_type:13,
				company_id : attributes.action_from_company_id,
				consumer_id : attributes.cons_id,
				islem_tarihi:attributes.action_date,
				fis_detay : iif((listfind('241,2410',process_type)),de('BORÇ DEKONTU'),de('ALACAK DEKONTU')),
				belge_no : attributes.paper_number,
				borc_hesaplar : iif((listfind('241,2410',process_type)),de('#MY_ACC_RESULT#'),de('#GET_CREDIT_PAYMENT.PAYMENT_RATE_ACC#')),
				borc_tutarlar:act_value_ch,
				other_amount_borc : iif(len(act_other_money_value),'act_other_money_value',de('')),
				other_currency_borc : act_other_money,
				alacak_hesaplar : iif((listfind('241,2410',process_type)),de('#GET_CREDIT_PAYMENT.PAYMENT_RATE_ACC#'),de('#MY_ACC_RESULT#')),
				alacak_tutarlar:act_value_ch,
				other_amount_alacak : iif(len(act_other_money_value),'act_other_money_value',de('')),
				other_currency_alacak : act_other_money,
				currency_multiplier : currency_multiplier,
				muhasebe_db : dsn3,
				fis_satir_detay:attributes.ACTION_DETAIL,
				acc_project_id : iif((isdefined('attributes.project_id') and len(attributes.project_id) and len(attributes.project_name)),attributes.project_id,de('')),
				to_branch_id : iif((listfind('241,2410',process_type)),branch_id_info,de('')),
				from_branch_id : iif((process_type eq 245),branch_id_info,de(''))
			);		
		}
		f_kur_ekle_action(action_id:GET_MAX_CH.ACTION_ID,process_type:0,action_table_name:'CARI_ACTION_MONEY',action_table_dsn:'#dsn2#', transaction_dsn='#dsn3#');
	</cfscript>
<cfelse>
	<cfquery name="GET_PROCESS_CAT" datasource="#dsn3#">
		SELECT PROCESS_CAT_ID,IS_CARI,IS_ACCOUNT FROM SETUP_PROCESS_CAT WHERE PROCESS_TYPE = <cfif listfind('241,2410',process_type)>41<cfelse>42</cfif>
	</cfquery>
	<cfif not len(GET_PROCESS_CAT.PROCESS_CAT_ID)>
		<cfif not isdefined('xml_import')>
			<script type="text/javascript">
				alert("<cf_get_lang no ='397.Lütfen Dekont İşlem Tipi Tanımlayınız'>!");
				history.back();	
			</script>
		<cfelse>
			<cf_get_lang no ='397.Lütfen Dekont İşlem Tipi Tanımlayınız'>!<br/>
		</cfif>
		<cfabort>
	</cfif>
	<cfquery name="ADD_CARI_ACTION" datasource="#dsn3#">
		INSERT INTO
			#dsn2_alias#.CARI_ACTIONS
		(
			PROCESS_CAT,
			ACTION_NAME,
			ACTION_TYPE_ID,
			ACTION_VALUE,
			ACTION_CURRENCY_ID,
			OTHER_MONEY,
			OTHER_CASH_ACT_VALUE,
			TO_CMP_ID,								
			FROM_CMP_ID,
			TO_CONSUMER_ID,
			FROM_CONSUMER_ID,
			ACTION_DETAIL,
			ACTION_ACCOUNT_CODE,
			ACTION_DATE,
			PROJECT_ID,
			PAPER_NO,
			ASSETP_ID,
			RECORD_DATE,
			RECORD_EMP,
			RECORD_IP								
		)
		VALUES
		(
			#GET_PROCESS_CAT.PROCESS_CAT_ID#,
			<cfif listfind('241,2410',process_type)>'BORÇ DEKONTU',<cfelse>'ALACAK DEKONTU',</cfif>
			<cfif listfind('241,2410',process_type)>41,<cfelse>42,</cfif>
			#wrk_round(attributes.sales_credit - attributes.sales_credit_comm)#,
			'#attributes.currency_id#',
			<cfif len(attributes.money_type)>'#attributes.money_type#',<cfelse>NULL,</cfif>
			<cfif len(currency_multiplier_2) and len(currency_multiplier_other)>#wrk_round(((attributes.sales_credit - attributes.sales_credit_comm)*currency_multiplier_2)/currency_multiplier_other)#,<cfelse>NULL,</cfif>
			<cfif listfind('241,2410',process_type) and len(attributes.action_from_company_id)>#attributes.action_from_company_id#,<cfelse>NULL,</cfif>
			<cfif process_type eq 245 and len(attributes.action_from_company_id)>#attributes.action_from_company_id#,<cfelse>NULL,</cfif>
			<cfif listfind('241,2410',process_type) and len(attributes.cons_id)>#attributes.cons_id#,<cfelse>NULL,</cfif>
			<cfif process_type eq 245 and len(attributes.cons_id)>#attributes.cons_id#,<cfelse>NULL,</cfif>
			<cfif len(attributes.action_detail)>'#attributes.action_detail#',<cfelse>NULL,</cfif>
			'#GET_CREDIT_PAYMENT.PAYMENT_RATE_ACC#',
			#attributes.action_date#,
			<cfif isdefined('attributes.project_id') and len(attributes.project_id) and len(attributes.project_name)>#attributes.project_id#,<cfelse>NULL,</cfif>
			<cfif isdefined("attributes.paper_number") and len(attributes.paper_number)>'#attributes.paper_number#',<cfelse>NULL,</cfif>
			<cfif isdefined("attributes.asset_id") and len(attributes.asset_id) and len(attributes.asset_name)>#attributes.asset_id#<cfelse>NULL</cfif>,
			#now()#,
			#session.ep.userid#,
			'#cgi.remote_addr#'						
		)					
	</cfquery>
	<cfquery name="GET_MAX_CH" datasource="#dsn3#">
		SELECT MAX(ACTION_ID) AS ACTION_ID FROM #dsn2_alias#.CARI_ACTIONS
	</cfquery>
	<cfscript>
		act_value_ch = wrk_round(attributes.sales_credit - attributes.sales_credit_comm);
		if (len(currency_multiplier_2) and len(currency_multiplier_other))
			act_other_money_value = wrk_round((attributes.sales_credit - attributes.sales_credit_comm)/currency_multiplier_other);
		else
			act_other_money_value = '';
		act_other_money = form.money_type;
		if(GET_PROCESS_CAT.IS_CARI eq 1)
		{
			carici(
				action_id : GET_MAX_CH.ACTION_ID,
				process_cat : GET_PROCESS_CAT.PROCESS_CAT_ID,
				workcube_process_type : iif((listfind('241,2410',process_type)),41,42),
				action_table : 'CARI_ACTIONS',
				islem_tutari : act_value_ch,
				islem_belge_no : attributes.paper_number,
				action_currency : session.ep.money,
				other_money_value : iif(len(act_other_money_value),'act_other_money_value',de('')),
				other_money : act_other_money,
				islem_tarihi : attributes.action_date,
				islem_detay : iif((listfind('241,2410',process_type)),de('BORÇ DEKONTU'),de('ALACAK DEKONTU')),
				action_detail : attributes.action_detail,
				to_cmp_id : iif((listfind('241,2410',process_type) and len(attributes.action_from_company_id)),attributes.action_from_company_id,de('')),
				from_cmp_id : iif((process_type eq 245 and len(attributes.action_from_company_id)),attributes.action_from_company_id,de('')),
				to_consumer_id : iif((listfind('241,2410',process_type) and len(attributes.cons_id)),attributes.cons_id,de('')),
				from_consumer_id : iif((process_type eq 245 and len(attributes.cons_id)),attributes.cons_id,de('')),
				currency_multiplier : currency_multiplier,
				account_card_type : 13,
				project_id : iif((isdefined('attributes.project_id') and len(attributes.project_id) and len(attributes.project_name)),attributes.project_id,de('')),
				cari_db : dsn3,
				to_branch_id : iif((listfind('241,2410',process_type)),branch_id_info,de('')),
				from_branch_id : iif((process_type eq 245),branch_id_info,de('')),
				assetp_id : iif((isdefined("attributes.asset_id") and len(attributes.asset_id) and len(attributes.asset_name)),'attributes.asset_id',de('')),
				rate2:currency_multiplier_other
				);
		}
		if(GET_PROCESS_CAT.IS_ACCOUNT eq 1)
		{

			muhasebeci (
				action_id:GET_MAX_CH.ACTION_ID,
				workcube_process_type : iif((listfind('241,2410',process_type)),41,42),
				workcube_old_process_type : iif((listfind('241,2410',process_type)),41,42),
				workcube_process_cat:form.process_cat,
				account_card_type:13,
				company_id : attributes.action_from_company_id,
				consumer_id : attributes.cons_id,
				islem_tarihi:attributes.action_date,
				fis_detay : iif((listfind('241,2410',process_type)),de('BORÇ DEKONTU'),de('ALACAK DEKONTU')),
				belge_no : attributes.paper_number,
				borc_hesaplar : iif((listfind('241,2410',process_type)),de('#MY_ACC_RESULT#'),de('#GET_CREDIT_PAYMENT.PAYMENT_RATE_ACC#')),
				borc_tutarlar:act_value_ch,
				other_amount_borc : iif(len(act_other_money_value),'act_other_money_value',de('')),
				other_currency_borc : act_other_money,
				alacak_hesaplar : iif((listfind('241,2410',process_type)),de('#GET_CREDIT_PAYMENT.PAYMENT_RATE_ACC#'),de('#MY_ACC_RESULT#')),
				alacak_tutarlar:act_value_ch,
				other_amount_alacak : iif(len(act_other_money_value),'act_other_money_value',de('')),
				other_currency_alacak : act_other_money,
				currency_multiplier : currency_multiplier,
				muhasebe_db : dsn3,
				fis_satir_detay:attributes.ACTION_DETAIL,
				acc_project_id : iif((isdefined('attributes.project_id') and len(attributes.project_id) and len(attributes.project_name)),attributes.project_id,de('')),
				to_branch_id : iif((listfind('241,2410',process_type)),branch_id_info,de('')),
				from_branch_id : iif((process_type eq 245),branch_id_info,de('')),
				is_abort : iif(isdefined('xml_import'),0,1)
			);		
		}
		f_kur_ekle_action(action_id:GET_MAX_CH.ACTION_ID,process_type:0,action_table_name:'CARI_ACTION_MONEY',action_table_dsn:'#dsn2#', transaction_dsn='#dsn3#');
	</cfscript>
</cfif>
