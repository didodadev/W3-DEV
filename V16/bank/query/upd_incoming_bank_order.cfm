<cfif form.active_period neq session.ep.period_id>
	<script type="text/javascript">
		alert("<cf_get_lang_main no='1659.İşlem Yapmak İstediğiniz Muhasebe Dönemi ile Aktif Muhasebe Döneminiz Farklı Muhasebe Döneminizi Kontrol Ediniz'>!");
		window.location.href='<cfoutput>#request.self#?fuseaction=bank.list_assign_order</cfoutput>';
	</script>
	<cfabort>
</cfif>
<cfset attributes.acc_type_id = ''>
<cfscript>
	if(listlen(attributes.employee_id,'_') eq 2)
	{
		attributes.acc_type_id = listlast(attributes.employee_id,'_');
		attributes.employee_id = listfirst(attributes.employee_id,'_');
	}
</cfscript>
<cfquery name="get_process_type" datasource="#dsn3#">
	SELECT
		PROCESS_TYPE,
		IS_CARI,
		IS_ACCOUNT,
		ACTION_FILE_NAME,
		ACTION_FILE_FROM_TEMPLATE
	 FROM
	 	SETUP_PROCESS_CAT
	WHERE
		PROCESS_CAT_ID = #form.process_cat#
</cfquery>
<cfscript>
	process_type = get_process_type.PROCESS_TYPE;
	is_cari =get_process_type.IS_CARI;
	is_account = get_process_type.IS_ACCOUNT;
</cfscript>
<cfif (is_account eq 1)>
	<cfif len(attributes.company_id)>
		<cfset alacakli_hesap = get_company_period(attributes.company_id)>
	<cfelseif len(attributes.consumer_id)>
		<cfset alacakli_hesap = get_consumer_period(attributes.consumer_id)>
	<cfelseif len(attributes.employee_id)>
		<cfset alacakli_hesap = get_employee_period(attributes.employee_id, attributes.acc_type_id)>
	</cfif>
	<cfif not len(alacakli_hesap)>
		<script type="text/javascript">
			alert("<cf_get_lang no ='393.Seçtiğiniz Üyenin Muhasebe Kodu Seçilmemiş'>!");
			history.back();
		</script>
		<cfabort>
	</cfif>
	<cfif len(attributes.account_id)>
		<cfquery name="GET_BANK_ORDER_CODE" datasource="#dsn3#">
			SELECT ACCOUNT_ORDER_CODE FROM ACCOUNTS WHERE ACCOUNT_ID = #attributes.account_id#
		</cfquery>
		<cfif not len(GET_BANK_ORDER_CODE.ACCOUNT_ORDER_CODE)>
			<script type="text/javascript">
				alert("<cf_get_lang no ='388.Seçtiğiniz Banka Hesabının Talimat Muhasebe Kodu Secilmemiş'>!");
				history.back();
			</script>
			<cfabort>
		</cfif>
	</cfif>
</cfif>
<!--- üyenin üye detaydaki default banka hesabı,banka talimatı tablosunda tutuluyor,ne işe yarıyor bilemiyorm dokunmadım,üyenin o andaki default hesabı tutuluoyor olabilr belki..aysenur --->
<cfif len(attributes.company_id)>
	<cfquery name="get_bank" datasource="#dsn#">
		SELECT
			COMPANY_BANK_ID MEMBER_BANK_ID
		 FROM
			COMPANY_BANK
		WHERE
			COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.company_id#">
			AND COMPANY_ACCOUNT_DEFAULT = 1
			AND COMPANY_BANK_MONEY = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.currency_id#">
	</cfquery>
<cfelseif len(attributes.consumer_id)>
	<cfquery name="get_bank" datasource="#dsn#">
		SELECT
			CONSUMER_BANK_ID MEMBER_BANK_ID
		 FROM
			CONSUMER_BANK
		WHERE
			CONSUMER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.consumer_id#">
			AND CONSUMER_ACCOUNT_DEFAULT = 1
			AND MONEY = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.currency_id#">
	</cfquery>
<cfelseif len(attributes.employee_id)>
	<cfquery name="get_bank" datasource="#dsn#">
    	SELECT
        	EMP_BANK_ID MEMBER_BANK_ID
        FROM
        	EMPLOYEES_BANK_ACCOUNTS
        WHERE
        	EMPLOYEE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.employee_id#">
            AND DEFAULT_ACCOUNT = 1
            AND MONEY = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.currency_id#">
    </cfquery>
</cfif>
<cf_date tarih='attributes.ACTION_DATE'>
<cf_date tarih='attributes.PAYMENT_DATE'>
<cfscript>
	attributes.ORDER_AMOUNT = filterNum(attributes.ORDER_AMOUNT);
	attributes.OTHER_CASH_ACT_VALUE = filterNum(attributes.OTHER_CASH_ACT_VALUE);
	attributes.system_amount = filterNum(attributes.system_amount);
	paper_currency_multiplier = '';
	for(y_sy=1; y_sy lte attributes.kur_say; y_sy = y_sy+1)
	{
		'attributes.txt_rate1_#y_sy#' = filterNum(evaluate('attributes.txt_rate1_#y_sy#'),session.ep.our_company_info.rate_round_num);
		'attributes.txt_rate2_#y_sy#' = filterNum(evaluate('attributes.txt_rate2_#y_sy#'),session.ep.our_company_info.rate_round_num);
		if( evaluate("attributes.hidden_rd_money_#y_sy#") is form.money_type)
			paper_currency_multiplier = evaluate('attributes.txt_rate2_#y_sy#/attributes.txt_rate1_#y_sy#');
	}
</cfscript>
<cflock name="#createUUID()#" timeout="60">
	<cftransaction>
		<cfquery name="ADD_BANK_ORDER" datasource="#DSN2#">
			UPDATE
				BANK_ORDERS
			SET
				BANK_ORDER_TYPE_ID=<cfif isdefined("form.process_cat") and len(form.process_cat)>#form.process_cat#<cfelse>NULL</cfif>,
				ACTION_VALUE = #attributes.ORDER_AMOUNT#,
				ACTION_MONEY = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.currency_id#">,
                TO_BRANCH_ID = <cfif isdefined("attributes.branch_id") and len(attributes.branch_id)>#attributes.branch_id#<cfelse>NULL</cfif>,
				ACCOUNT_ID = #attributes.account_id#,
                ACTION_BANK_ACCOUNT=<cfif isdefined("attributes.list_bank") and len(attributes.list_bank)>#attributes.list_bank#<cfelse>NULL</cfif>,
				COMPANY_ID = <cfif len(attributes.company_id)>#attributes.company_id#,<cfelse>NULL,</cfif>
				CONSUMER_ID = <cfif len(attributes.consumer_id)>#attributes.consumer_id#,<cfelse>NULL,</cfif>
                EMPLOYEE_ID = <cfif len(attributes.employee_id)>#attributes.employee_id#,<cfelse>NULL,</cfif>
                ACC_TYPE_ID = <cfif len(attributes.acc_type_id)>#attributes.acc_type_id#,<cfelse>NULL,</cfif>
				TO_ACCOUNT_ID = <cfif get_bank.recordcount>#get_bank.MEMBER_BANK_ID#<cfelse>NULL</cfif>,
				PROJECT_ID = <cfif len(attributes.project_name) and len(attributes.project_id)>#attributes.project_id#<cfelse>NULL</cfif>,
				OTHER_MONEY_VALUE= <cfif len(attributes.OTHER_CASH_ACT_VALUE)>#attributes.OTHER_CASH_ACT_VALUE#<cfelse>NULL</cfif>,
				OTHER_MONEY = <cfif len(money_type)><cfqueryparam cfsqltype="cf_sql_varchar" value="#money_type#"><cfelse>NULL</cfif>,
				ACTION_DATE = #attributes.ACTION_DATE#,
				PAYMENT_DATE = #attributes.PAYMENT_DATE#,
				ACTION_DETAIL = <cfif isDefined("attributes.ACTION_DETAIL") and len(attributes.ACTION_DETAIL)><cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.ACTION_DETAIL#"><cfelse>NULL</cfif>,
				ASSETP_ID = <cfif isdefined("attributes.asset_id") and len(attributes.asset_id) and len(attributes.asset_name)>#attributes.asset_id#<cfelse>NULL</cfif>,
				UPDATE_DATE = #now()#,
				UPDATE_EMP = #session.ep.userid#,
				UPDATE_IP = <cfqueryparam cfsqltype="cf_sql_varchar" value="#CGI.REMOTE_ADDR#">,
				CREDIT_LIMIT_ID = <cfif isdefined("attributes.credit_limit") and len(attributes.credit_limit)>#attributes.credit_limit#,<cfelse>NULL,</cfif>
                SPECIAL_DEFINITION_ID=<cfif isdefined("attributes.special_definition_id") and len(attributes.special_definition_id)>#attributes.special_definition_id#<cfelse>NULL</cfif>
			WHERE
				BANK_ORDER_ID = #ATTRIBUTES.BANK_ORDER_ID#
				AND BANK_ORDER_TYPE = 251
		</cfquery>
		<cfscript>
			if (session.ep.our_company_info.project_followup neq 1)//isdefined lar altta functionlarda sıkıntı yaratıyordu buraya tanımlandı
			{
				attributes.project_id = "";
				attributes.project_name = "";
			}
			currency_id=attributes.currency_id;
			if (isDefined('attributes.branch_id'))
			{
				to_branch_id=attributes.branch_id;
			}
			else
			{
				to_branch_id=listgetat(session.ep.user_location,2,'-');
			}
			currency_multiplier = '';
			if(isDefined('attributes.kur_say') and len(attributes.kur_say))
				for(mon=1;mon lte attributes.kur_say;mon=mon+1)
					if(evaluate("attributes.hidden_rd_money_#mon#") is session.ep.money2)
						currency_multiplier = evaluate('attributes.txt_rate2_#mon#/attributes.txt_rate1_#mon#');

			if(is_account eq 1)
			{
				if (isDefined("attributes.ACTION_DETAIL") and len(attributes.ACTION_DETAIL))
					str_card_detail = '#attributes.ACTION_DETAIL#';
				else
					str_card_detail = 'Gelen Banka Talimatı';
				muhasebeci (
					action_id : form.bank_order_id,
					workcube_process_type : process_type,
					workcube_old_process_type : form.old_process_type,
					workcube_process_cat:form.process_cat,
					account_card_type : 13,
					company_id:attributes.company_id,
					consumer_id:attributes.consumer_id,
					islem_tarihi : attributes.ACTION_DATE,
					fis_satir_detay : str_card_detail,
					borc_hesaplar : GET_BANK_ORDER_CODE.ACCOUNT_ORDER_CODE,
					borc_tutarlar : attributes.system_amount,
					other_amount_borc : attributes.ORDER_AMOUNT,
					other_currency_borc : currency_id,
					alacak_hesaplar : alacakli_hesap,
					alacak_tutarlar : attributes.system_amount,
					other_amount_alacak : iif(len(attributes.OTHER_CASH_ACT_VALUE),'attributes.OTHER_CASH_ACT_VALUE',de('')),
					other_currency_alacak : form.money_type,
					currency_multiplier : currency_multiplier,
					to_branch_id :  to_branch_id,
					acc_project_id : iif((len(attributes.project_id) and len(attributes.project_name)),attributes.project_id,de('')),
					fis_detay : 'GELEN BANKA TALİMATI'
				);
			}
			else
				muhasebe_sil (action_id:form.bank_order_id,process_type:form.old_process_type);

			if(is_cari eq 1)
			{
				if (isDefined("attributes.ACTION_DETAIL") and len(attributes.ACTION_DETAIL))
					act_detail = '#attributes.ACTION_DETAIL#';
				else
					act_detail = '';
				carici
					(
					action_id : form.bank_order_id,
					workcube_process_type : process_type,
					workcube_old_process_type : form.old_process_type,
					action_table : 'BANK_ORDERS',
					process_cat : form.process_cat,
					islem_tarihi : attributes.ACTION_DATE,
					to_account_id : attributes.account_id,
					to_branch_id :  to_branch_id,
					islem_tutari : attributes.system_amount,
					action_currency : session.ep.money,
					other_money_value : iif(len(attributes.OTHER_CASH_ACT_VALUE),'attributes.OTHER_CASH_ACT_VALUE',de('')),
					other_money : form.money_type,
					currency_multiplier : currency_multiplier,
					action_detail : act_detail,
					islem_detay : 'Gelen Banka Talimatı',
					account_card_type : 13,
					due_date: attributes.PAYMENT_DATE,
					from_cmp_id : attributes.company_id,
					from_consumer_id : attributes.consumer_id,
					from_employee_id : attributes.employee_id,
					acc_type_id : attributes.acc_type_id,
					project_id : iif((len(attributes.project_id) and len(attributes.project_name)),attributes.project_id,de('')),
					is_processed : attributes.is_havale,
					assetp_id : iif((isdefined("attributes.asset_id") and len(attributes.asset_id) and len(attributes.asset_name)),'attributes.asset_id',de('')),
					rate2:paper_currency_multiplier
					);
			}
			else
				cari_sil(action_id:form.bank_order_id,process_type:form.old_process_type);

			f_kur_ekle_action(action_id:form.bank_order_id,process_type:1,action_table_name:'BANK_ORDER_MONEY',action_table_dsn:'#dsn2#');
		</cfscript>
		
			<cf_workcube_process_cat
				process_cat="#form.process_cat#"
				action_id = #form.bank_order_id#
				is_action_file = 1
				action_file_name='#get_process_type.action_file_name#'
				action_page='#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.list_assign_order&event=upd_incoming&bank_order_id=#form.bank_order_id#'
				action_db_type = '#dsn2#'
				is_template_action_file = '#get_process_type.action_file_from_template#'>
		
	</cftransaction>
</cflock>
<cfset attributes.actionId=attributes.bank_order_id >
<script type="text/javascript">
	window.location.href = "<cfoutput>#request.self#?fuseaction=bank.list_assign_order&event=upd_incoming&bank_order_id=#attributes.bank_order_id#</cfoutput>";
</script>
