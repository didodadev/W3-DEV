<cfif attributes.active_period neq session.ep.period_id>
	<script type="text/javascript">
		alert("<cf_get_lang_main no='1659.İşlem Yapmak İstediğiniz Muhasebe Dönemi ile Aktif Muhasebe Döneminiz Farklı Muhasebe Döneminizi Kontrol Ediniz'>!");
		window.location.href='<cfoutput>#request.self#?fuseaction=bank.list_assign_order</cfoutput>';
	</script>
	<cfabort>
</cfif>
<cfset attributes.acc_type_id = "">
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
	is_account = get_process_type.IS_ACCOUNT;
	is_cari = get_process_type.IS_CARI;
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
			COMPANY_ID = #attributes.company_id#
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
			CONSUMER_ID = #attributes.consumer_id#
			AND CONSUMER_ACCOUNT_DEFAULT = 1
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
	for(s_sy=1; s_sy lte attributes.kur_say; s_sy = s_sy+1)
	{
		'attributes.txt_rate1_#s_sy#' = filterNum(evaluate('attributes.txt_rate1_#s_sy#'),session.ep.our_company_info.rate_round_num);
		'attributes.txt_rate2_#s_sy#' = filterNum(evaluate('attributes.txt_rate2_#s_sy#'),session.ep.our_company_info.rate_round_num);
		if( evaluate("attributes.hidden_rd_money_#s_sy#") is attributes.money_type)
			paper_currency_multiplier = evaluate('attributes.txt_rate2_#s_sy#/attributes.txt_rate1_#s_sy#');
	}
</cfscript>
<cfif not isdefined("attributes.copy_order_count") or attributes.copy_order_count eq "">
	<cfset attributes.copy_order_count = 1>
	<cfset attributes.due_option = 3>
</cfif>
<cfset temp_order_count = attributes.copy_order_count-1>
<cfloop from="0" to="#temp_order_count#" index="i">
	<cfset temp_action_date = attributes.action_date>
	<cfif attributes.due_option eq 1>
		<cfset temp_payment_date = dateadd('m',i,attributes.payment_date)>
	<cfelseif attributes.due_option eq 2>
		<cfset temp_payment_date = dateadd('d',(i*attributes.due_day),attributes.payment_date)>
	<cfelseif attributes.due_option eq 3>
		<cfset temp_payment_date = attributes.payment_date>
	</cfif>
	<cflock name="#CREATEUUID()#" timeout="20">
		<cftransaction>
		<cfquery name="ADD_BANK_ORDER" datasource="#DSN2#" result="MAX_ID">
			INSERT INTO
				BANK_ORDERS
				(
					BANK_ORDER_TYPE,
					BANK_ORDER_TYPE_ID,
                    ACTION_BANK_ACCOUNT,
                    TO_BRANCH_ID,
					ACTION_VALUE,
					ACTION_MONEY,
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
					ACTION_DETAIL,
					ASSETP_ID,
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
                    <cfif isdefined("attributes.list_bank") and len(attributes.list_bank)>#attributes.list_bank#<cfelse>NULL</cfif>,
                    <cfif isdefined("attributes.branch_id") and len(attributes.branch_id)>#attributes.branch_id#<cfelse>NULL</cfif>,
					#attributes.ORDER_AMOUNT#,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.currency_id#">,
					#attributes.account_id#,
					<cfif len(attributes.company_id)>#attributes.company_id#,<cfelse>NULL,</cfif>
					<cfif len(attributes.consumer_id)>#attributes.consumer_id#,<cfelse>NULL,</cfif>
                    <cfif len(attributes.employee_id)>#attributes.employee_id#,<cfelse>NULL,</cfif>
                    <cfif len(attributes.acc_type_id)>#attributes.acc_type_id#,<cfelse>NULL,</cfif>
					<cfif not len(attributes.employee_id) and get_bank.recordcount>#get_bank.MEMBER_BANK_ID#<cfelse>NULL</cfif>,
					<cfif len(attributes.project_name) and len(attributes.project_id)>#attributes.project_id#<cfelse>NULL</cfif>,
					<cfif isDefined("attributes.OTHER_CASH_ACT_VALUE") and len(attributes.OTHER_CASH_ACT_VALUE)>#attributes.OTHER_CASH_ACT_VALUE#,<cfelse>NULL,</cfif>
					<cfif isDefined("attributes.money_type") and len(attributes.money_type)><cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.money_type#">,<cfelse>NULL,</cfif>
					#temp_action_date#,
					#temp_payment_date#,
					0, <!---banka talimatından havale olusturulmadigini gosteriyor  --->
					<cfif isDefined("attributes.ACTION_DETAIL") and len(attributes.ACTION_DETAIL)><cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.ACTION_DETAIL#"><cfelse>NULL</cfif>,
					<cfif isdefined("attributes.asset_id") and len(attributes.asset_id) and len(attributes.asset_name)>#attributes.asset_id#<cfelse>NULL</cfif>,
					#now()#,
					#session.ep.userid#,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#CGI.REMOTE_ADDR#">,
					<cfif isdefined("attributes.credit_limit") and len(attributes.credit_limit)>#attributes.credit_limit#,<cfelse>NULL,</cfif>
                    <cfif isdefined("attributes.special_definition_id") and len(attributes.special_definition_id)>#attributes.special_definition_id#<cfelse>NULL</cfif>
				)
		</cfquery>
		<cfscript>
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
				muhasebeci
				(
					action_id : MAX_ID.IDENTITYCOL,
					workcube_process_type : process_type,
					workcube_process_cat:form.process_cat,
					islem_tarihi : temp_action_date,
					company_id : attributes.company_id,
					consumer_id : attributes.consumer_id,
					fis_detay : 'GELEN BANKA TALİMATI',
					borc_hesaplar : GET_BANK_ORDER_CODE.ACCOUNT_ORDER_CODE,
					borc_tutarlar : attributes.system_amount,
					other_amount_borc : attributes.ORDER_AMOUNT,
					other_currency_borc : currency_id,
					alacak_hesaplar : alacakli_hesap,
					alacak_tutarlar : attributes.system_amount,
					other_amount_alacak : iif(len(attributes.OTHER_CASH_ACT_VALUE),'attributes.OTHER_CASH_ACT_VALUE',de('')),
					other_currency_alacak : attributes.money_type,
					currency_multiplier : currency_multiplier,
					fis_satir_detay : str_card_detail,
					to_branch_id : to_branch_id,
					acc_project_id : attributes.project_id,
					account_card_type : 13
				);
			}

			if(is_cari eq 1)
			{
				if (isDefined("attributes.ACTION_DETAIL") and len(attributes.ACTION_DETAIL))
					act_detail = '#attributes.ACTION_DETAIL#';
				else
					act_detail = '';
				carici
					(
					action_id : MAX_ID.IDENTITYCOL,
					workcube_process_type : process_type,
					action_table : 'BANK_ORDERS',
					process_cat : form.process_cat,
					islem_tarihi : temp_action_date,
					from_cmp_id : attributes.company_id,
					from_consumer_id : attributes.consumer_id,
					from_employee_id : attributes.employee_id,
					acc_type_id : attributes.acc_type_id,
					islem_tutari : attributes.system_amount,
					action_currency : session.ep.money,
					other_money_value : iif(len(attributes.OTHER_CASH_ACT_VALUE),'attributes.OTHER_CASH_ACT_VALUE',de('')),
					other_money : attributes.money_type,
					currency_multiplier : currency_multiplier,
					islem_detay : 'Gelen Banka Talimatı',
					account_card_type : 13,
					action_detail : act_detail,
					due_date: temp_payment_date,
					to_account_id : attributes.account_id,
					to_branch_id : to_branch_id,
					project_id : attributes.project_id,
					is_processed : 0, //banka talimatının havaleye çekilmedigini gösteriyor.
					assetp_id : iif((isdefined("attributes.asset_id") and len(attributes.asset_id) and len(attributes.asset_name)),'attributes.asset_id',de('')),
					rate2:paper_currency_multiplier
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
		<cfquery name="upd_" datasource="#dsn2#">
			UPDATE BANK_ORDERS SET SERI_NO = <cfqueryparam cfsqltype="cf_sql_varchar" value="#seri_no#"> WHERE BANK_ORDER_ID = #MAX_ID.IDENTITYCOL#
		</cfquery>
		
			<cf_workcube_process_cat
				process_cat="#form.process_cat#"
				action_id = #MAX_ID.IDENTITYCOL#
				is_action_file = 1
				action_file_name='#get_process_type.action_file_name#'
				action_page='#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.list_assign_order&event=upd_incoming&bank_order_id=#MAX_ID.IDENTITYCOL#'
				action_db_type = '#dsn2#'
				is_template_action_file = '#get_process_type.action_file_from_template#'>
		
	 </cftransaction>
	</cflock>
</cfloop>
<cfset attributes.actionId=MAX_ID.IDENTITYCOL>
<script type="text/javascript">
	window.location.href = "<cfoutput>#request.self#?fuseaction=bank.list_assign_order&event=upd_incoming&bank_order_id=#MAX_ID.IDENTITYCOL#</cfoutput>";
</script>


