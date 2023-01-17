<cf_get_lang_set module_name="cash"><!--- sayfanin en altinda kapanisi var --->
<cfif form.active_period neq session.ep.period_id>
	<script type="text/javascript">
		alert("<cf_get_lang_main no='1659.İşlem Yapmak İstediğiniz Muhasebe Dönemi ile Aktif Muhasebe Döneminiz Farklı Muhasebe Döneminizi Kontrol Ediniz'>!");
		window.location.href='<cfoutput>#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.list_cash_actions</cfoutput>';
	</script>
	<cfabort>
</cfif>

<cfquery name="GET_PROCESS_TYPE" datasource="#DSN3#">
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
	process_type = get_process_type.process_type;
	is_cari = get_process_type.is_cari;
	is_account = get_process_type.is_account;
	PAPER = "#form.paper_number#";
	CASH_ACTION_TO_CASH_ID=listfirst(attributes.CASH_ACTION_TO_CASH_ID,';');
	to_branch_id=listlast(attributes.CASH_ACTION_TO_CASH_ID,';');
	attributes.acc_type_id = '';
	if(listlen(attributes.employee_id,'_') eq 2)
	{
		attributes.acc_type_id = listlast(attributes.employee_id,'_');
		attributes.employee_id = listfirst(attributes.employee_id,'_');
	}
</cfscript>
<cfif is_account eq 1>
	<cfif len(attributes.employee_id)>
		<cfset MY_ACC_RESULT = GET_EMPLOYEE_PERIOD(attributes.employee_id,attributes.acc_type_id)>
	<cfelseif len(attributes.CASH_ACTION_FROM_COMPANY_ID)>
		<cfset MY_ACC_RESULT = GET_COMPANY_PERIOD(attributes.CASH_ACTION_FROM_COMPANY_ID)>
	<cfelseif len(attributes.CASH_ACTION_FROM_CONSUMER_ID)>
		<cfset MY_ACC_RESULT = GET_CONSUMER_PERIOD(attributes.CASH_ACTION_FROM_CONSUMER_ID)>
	</cfif>
	<cfif not len(MY_ACC_RESULT)>
		<cfif not isdefined('xml_import')>
			<script type="text/javascript">
				alert("<cf_get_lang no ='251.Seçtiğiniz Çalışan veya Üyenin Muhasebe Kodu Seçilmemiş'>!");
				history.back();	
			</script>
		<cfelse>
			<cf_get_lang no ='251.Seçtiğiniz Çalışan veya Üyenin Muhasebe Kodu Seçilmemiş'>!<br/>
		</cfif>
		<cfabort>
	</cfif>
</cfif>

<cf_date tarih='attributes.ACTION_DATE'>
<cfquery name="GET_FROM_CASH" datasource="#dsn2#">
	SELECT
		CASH_CURRENCY_ID,
		CASH_ACC_CODE
	FROM
		CASH
	WHERE
		CASH_ID = #CASH_ACTION_TO_CASH_ID#
</cfquery>
<cfset currency_multiplier = ''>
<cfscript>
	if(not isdefined('xml_import'))
	{
		attributes.CASH_ACTION_VALUE = filterNum(attributes.CASH_ACTION_VALUE);
		attributes.OTHER_CASH_ACT_VALUE = filterNum(attributes.OTHER_CASH_ACT_VALUE);
		attributes.system_amount = filterNum(attributes.system_amount);
		for(w_say=1; w_say lte attributes.kur_say; w_say=w_say+1)
		{
			'attributes.txt_rate1_#w_say#' = filterNum(evaluate('attributes.txt_rate1_#w_say#'),session.ep.our_company_info.rate_round_num);
			'attributes.txt_rate2_#w_say#' = filterNum(evaluate('attributes.txt_rate2_#w_say#'),session.ep.our_company_info.rate_round_num);
		}
	}
	
	currency_multiplier = '';
	other_currency_multiplier ='';
	if(isDefined('attributes.kur_say') and len(attributes.kur_say))
	{
		for(mon=1;mon lte attributes.kur_say;mon=mon+1)
		{
			if(evaluate("attributes.hidden_rd_money_#mon#") is session.ep.money2)
				currency_multiplier = evaluate('attributes.txt_rate2_#mon#/attributes.txt_rate1_#mon#');
			if(evaluate("attributes.hidden_rd_money_#mon#") is form.money_type)
				other_currency_multiplier = evaluate('attributes.txt_rate2_#mon#/attributes.txt_rate1_#mon#');
		}
	}
</cfscript>
<cf_papers paper_type="revenue_receipt">
<cflock name="#createUUID()#" timeout="20">
	<cftransaction>
	<cfquery name="ADD_CASH_REVENUE" datasource="#dsn2#" result="MAX_ID">
		INSERT INTO
			CASH_ACTIONS
			(
				PROCESS_CAT,
				PAPER_NO,
				ACTION_TYPE,
				ACTION_TYPE_ID,
				CASH_ACTION_VALUE,
				CASH_ACTION_CURRENCY_ID,
				CASH_ACTION_FROM_COMPANY_ID,
				CASH_ACTION_FROM_CONSUMER_ID,
				CASH_ACTION_FROM_EMPLOYEE_ID,
				CASH_ACTION_TO_CASH_ID,
				ACTION_DATE,
				OTHER_CASH_ACT_VALUE,
				OTHER_MONEY,
				REVENUE_COLLECTOR_ID,
				PROJECT_ID,
				ACTION_DETAIL,
				IS_ACCOUNT,
				IS_ACCOUNT_TYPE,
				RECORD_EMP,
				RECORD_IP,
				RECORD_DATE,
				ASSETP_ID,
				SPECIAL_DEFINITION_ID,
				ACTION_VALUE,
				ACTION_CURRENCY_ID,
                ACC_TYPE_ID
				<cfif len(session.ep.money2)>
					,ACTION_VALUE_2
					,ACTION_CURRENCY_ID_2
				</cfif>
			)
			VALUES
			(
				#form.process_cat#,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#PAPER#">,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#UCase(getLang('main',2284))#">,
				#process_type#,
				#attributes.CASH_ACTION_VALUE#,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#GET_FROM_CASH.CASH_CURRENCY_ID#">,
				<cfif len(attributes.CASH_ACTION_FROM_COMPANY_ID) and (len(attributes.EMPLOYEE_ID) EQ 0)>#attributes.CASH_ACTION_FROM_COMPANY_ID#<cfelse>NULL</cfif>,
				<cfif len(attributes.CASH_ACTION_FROM_CONSUMER_ID)>#attributes.CASH_ACTION_FROM_CONSUMER_ID#<cfelse>NULL</cfif>,
				<cfif len(attributes.employee_id)>#attributes.employee_id#<cfelse>NULL</cfif>,
				#CASH_ACTION_TO_CASH_ID#,
				#attributes.ACTION_DATE#,
				<cfif len(attributes.OTHER_CASH_ACT_VALUE)>#attributes.OTHER_CASH_ACT_VALUE#<cfelse>NULL</cfif>,
				<cfif len(attributes.money_type)><cfqueryparam cfsqltype="cf_sql_varchar" value="#money_type#"><cfelse>NULL</cfif>,
				#REVENUE_COLLECTOR_ID#,
				<cfif len(attributes.project_name) and len(attributes.project_id)>#project_id#<cfelse>NULL</cfif>,
				#sql_unicode()#'#ACTION_DETAIL#',
				<cfif is_account eq 1>1<cfelse>0</cfif>,
				11,
				#SESSION.EP.USERID#,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#CGI.REMOTE_ADDR#">,
				#NOW()#,
				<cfif isdefined("attributes.asset_id") and len(attributes.asset_id) and len(attributes.asset_name)>#attributes.asset_id#<cfelse>NULL</cfif>,
				<cfif isdefined("attributes.special_definition_id") and len(attributes.special_definition_id)>#attributes.special_definition_id#<cfelse>NULL</cfif>,
				#attributes.system_amount#,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#session.ep.money#">,
                    <cfif isdefined("attributes.acc_type_id") and len(attributes.acc_type_id)>#attributes.acc_type_id#<cfelse>NULL</cfif>
				<cfif len(session.ep.money2)>
					,#wrk_round(attributes.system_amount/currency_multiplier,4)#
					,<cfqueryparam cfsqltype="cf_sql_varchar" value="#session.ep.money2#">
				</cfif>
			)
	</cfquery>
	<cfscript>
		if (is_cari eq 1)
		{
			carici(
				action_id :MAX_ID.IDENTITYCOL,
				workcube_process_type :process_type,
				process_cat : form.process_cat,
				account_card_type :11,
				action_table :'CASH_ACTIONS',
				islem_tarihi :attributes.ACTION_DATE,
				islem_tutari :attributes.system_amount,
				islem_belge_no :PAPER,
				action_currency : session.ep.money,
				to_cash_id :CASH_ACTION_TO_CASH_ID,
				from_cmp_id :CASH_ACTION_FROM_COMPANY_ID,
				from_consumer_id : CASH_ACTION_FROM_CONSUMER_ID,
				from_employee_id : attributes.employee_id,
				revenue_collector_id :REVENUE_COLLECTOR_ID,
				acc_type_id : attributes.acc_type_id,
				other_money_value : iif(len(attributes.OTHER_CASH_ACT_VALUE),'attributes.OTHER_CASH_ACT_VALUE',de('')),
				other_money : form.money_type,
				project_id : iif((isdefined("attributes.project_id") and len(attributes.project_id) and len(attributes.project_name)),'attributes.project_id',de('')),
				special_definition_id : iif((isdefined("attributes.special_definition_id") and len(attributes.special_definition_id)),'attributes.special_definition_id',de('')),
				action_detail : attributes.action_detail,
				currency_multiplier : currency_multiplier,
				islem_detay : UCase(getLang('main',2284)),
				to_branch_id : to_branch_id,
				assetp_id : iif((isdefined("attributes.asset_id") and len(attributes.asset_id) and len(attributes.asset_name)),'attributes.asset_id',de('')),
				rate2:other_currency_multiplier
			);
		}
		/*entegre ise muhasebe tablosuna giris yapilacak*/
		if(is_account eq 1)
		{
			if(isDefined("attributes.ACTION_DETAIL") and len(attributes.ACTION_DETAIL))
				str_card_detail = '#attributes.company_name#-#attributes.ACTION_DETAIL#';
			else if(GET_FROM_CASH.CASH_CURRENCY_ID is session.ep.money)
				str_card_detail = '#attributes.company_name#-' & UCase(getLang('main',2284));//NAKİT TAHSİLAT
			else
				str_card_detail = '#attributes.company_name#-' & UCase(getLang('main',2745));//DÖVİZLİ NAKİT TAHSİLAT

			muhasebeci (
				action_id:MAX_ID.IDENTITYCOL,
				workcube_process_type:process_type,
				workcube_process_cat:form.process_cat,
				account_card_type:11,
				company_id : attributes.CASH_ACTION_FROM_COMPANY_ID,
				consumer_id : attributes.CASH_ACTION_FROM_CONSUMER_ID,
				islem_tarihi:attributes.ACTION_DATE,
				borc_hesaplar:GET_FROM_CASH.CASH_ACC_CODE,
				borc_tutarlar:attributes.system_amount,
				other_amount_borc : attributes.CASH_ACTION_VALUE,
				other_currency_borc : GET_FROM_CASH.CASH_CURRENCY_ID,
				alacak_hesaplar:MY_ACC_RESULT,
				alacak_tutarlar:attributes.system_amount,
				other_amount_alacak : iif(len(attributes.OTHER_CASH_ACT_VALUE),'attributes.OTHER_CASH_ACT_VALUE',de('')),
				other_currency_alacak : form.money_type,
				fis_satir_detay:str_card_detail,
				fis_detay : UCase(getLang('main',2284)),
				action_currency:session.ep.money,
				currency_multiplier : currency_multiplier,
				belge_no : PAPER,
				to_branch_id : to_branch_id,
				acc_project_id : iif((isdefined("attributes.project_id") and len(attributes.project_id) and len(attributes.project_name)),'attributes.project_id',de('')),
				is_abort : iif(isdefined('xml_import'),0,1)
			);
		}
		f_kur_ekle_action(action_id:MAX_ID.IDENTITYCOL,process_type:0,action_table_name:'CASH_ACTION_MONEY',action_table_dsn:'#dsn2#');
	</cfscript>
	<!--- onay ve uyarıların gelebilmesi icin action file sarti kaldirildi --->
	<cf_workcube_process_cat 
		process_cat="#form.process_cat#"
		action_id = #MAX_ID.IDENTITYCOL#
		is_action_file = 1
		action_db_type = '#dsn2#'
		action_page='#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.popup_upd_cash_revenue&id=#MAX_ID.IDENTITYCOL#'
		action_file_name='#get_process_type.action_file_name#'
		is_template_action_file = '#get_process_type.action_file_from_template#'>
	</cftransaction>
    <cf_add_log log_type="1" action_id="#MAX_ID.IDENTITYCOL#" action_name="#PAPER# Eklendi" paper_no="#PAPER#" period_id="#session.ep.period_id#" process_type="#get_process_type.PROCESS_TYPE#" data_source="#dsn2#">
</cflock>

<cfif not isdefined('xml_import')>
	<cfif len(PAPER_NUMBER)>
		<!---makbuz no kontrol edilip update edilecek--->
		<cfquery name="CHK_PAPER_NO" datasource="#dsn3#">
			UPDATE
				PAPERS_NO
			SET
				REVENUE_RECEIPT_NUMBER = #PAPER_NUMBER#
			WHERE
				<cfif isdefined('attributes.paper_printer_id') and len(attributes.paper_printer_id)>
					PRINTER_ID = #attributes.paper_printer_id#
				<cfelse>
					EMPLOYEE_ID = #session.ep.userid#
				</cfif>
		</cfquery>
	</cfif>
	<!---makbuz no upd bitti--->
	<script type="text/javascript">
		<cfif session.ep.isBranchAuthorization eq 0 and session.ep.our_company_info.is_paper_closer eq 1 and (len(attributes.CASH_ACTION_FROM_COMPANY_ID) or len(attributes.CASH_ACTION_FROM_CONSUMER_ID) or len(attributes.employee_id))>
			window.open('<cfoutput>#request.self#?fuseaction=finance.list_payment_actions&event=add&act_type=1&member_id=#attributes.CASH_ACTION_FROM_COMPANY_ID#&consumer_id=#attributes.CASH_ACTION_FROM_CONSUMER_ID#&employee_id_new=#attributes.employee_id#&acc_type_id=#attributes.acc_type_id#&money_type=#form.money_type#&row_action_id=#MAX_ID.IDENTITYCOL#&row_action_type=#process_type#</cfoutput>','page');
		</cfif>	  
		<cfif session.ep.isBranchAuthorization>
			window.open('<cfoutput>#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.form_add_cash_revenue&event=upd&ID=#MAX_ID.IDENTITYCOL#</cfoutput>','mywindow','resizable=1,menubar=1,status=1,toolbar=0,scrollbars=1,width=600,height=470');
			window.location.href='<cfoutput>#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.list_cash_actions&paper_number=#PAPER#&is_form_submitted=1&page_action_type=31-0</cfoutput>';
		<cfelse>
			window.location.href='<cfoutput>#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.form_add_cash_revenue&event=upd&id=#MAX_ID.IDENTITYCOL#</cfoutput>';
		</cfif>                                                                                                                                                                                  
	</script>
</cfif>
<cf_get_lang_set module_name="#lcase(listgetat(attributes.fuseaction,1,'.'))#"><!--- sayfanin en ustunde acilisi var --->
