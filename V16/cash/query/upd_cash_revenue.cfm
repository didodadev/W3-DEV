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
	to_branch_id=listlast(attributes.CASH_ACTION_TO_CASH_ID,';');
	attributes.CASH_ACTION_TO_CASH_ID = listfirst(attributes.CASH_ACTION_TO_CASH_ID,';');
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
		<script type="text/javascript">
			alert("<cf_get_lang no ='251.Seçtiğiniz Çalışan veya Üyenin Muhasebe Kodu Seçilmemiş'>!");
			history.back();	
		</script>
		<cfabort>
	</cfif>
</cfif>
<cf_date tarih='attributes.ACTION_DATE'>
<cfquery name="GET_FROM_CASH" datasource="#DSN2#">
	SELECT
		CASH_CURRENCY_ID,
		CASH_ACC_CODE
	FROM
		CASH
	WHERE
		CASH_ID = #attributes.CASH_ACTION_TO_CASH_ID#
</cfquery>
<cfscript>
	attributes.CASH_ACTION_VALUE = filterNum(attributes.CASH_ACTION_VALUE);
	attributes.OTHER_CASH_ACT_VALUE = filterNum(attributes.OTHER_CASH_ACT_VALUE);
	attributes.system_amount = filterNum(attributes.system_amount);
		for(p_say = 1; p_say lte attributes.kur_say; p_say = p_say+1)
		{
			'attributes.txt_rate1_#p_say#' = filterNum(evaluate('attributes.txt_rate1_#p_say#'),session.ep.our_company_info.rate_round_num);
			'attributes.txt_rate2_#p_say#' = filterNum(evaluate('attributes.txt_rate2_#p_say#'),session.ep.our_company_info.rate_round_num);
		}
	currency_multiplier = '';
	other_currency_multiplier = '';
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

<cflock name="#createUUID()#" timeout="20">
  <cftransaction>
	<cfquery name="UPD_CASH_REVENUE" datasource="#DSN2#">
		UPDATE
			CASH_ACTIONS
		SET		
			PAPER_NO = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.paper_number#">,
			CASH_ACTION_VALUE = #attributes.CASH_ACTION_VALUE#,
			CASH_ACTION_CURRENCY_ID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#get_from_cash.cash_currency_id#">,
			CASH_ACTION_FROM_COMPANY_ID = <cfif len(attributes.CASH_ACTION_FROM_COMPANY_ID)>#attributes.CASH_ACTION_FROM_COMPANY_ID#<cfelse>NULL</cfif>,
			CASH_ACTION_FROM_CONSUMER_ID = <cfif len(attributes.CASH_ACTION_FROM_CONSUMER_ID)>#attributes.CASH_ACTION_FROM_CONSUMER_ID#<cfelse>NULL</cfif>,
			CASH_ACTION_FROM_EMPLOYEE_ID = <cfif len(attributes.employee_id)>#attributes.employee_id#<cfelse>NULL</cfif>,
			CASH_ACTION_TO_CASH_ID = #attributes.CASH_ACTION_TO_CASH_ID#,
			ACTION_DATE = #attributes.ACTION_DATE#,
			OTHER_CASH_ACT_VALUE = <cfif len(attributes.OTHER_CASH_ACT_VALUE)>#attributes.OTHER_CASH_ACT_VALUE#<cfelse>NULL</cfif>,
			OTHER_MONEY = <cfif len(attributes.money_type)><cfqueryparam cfsqltype="cf_sql_varchar" value="#money_type#"><cfelse>NULL</cfif>,
			REVENUE_COLLECTOR_ID = #attributes.REVENUE_COLLECTOR_ID#,
			PROJECT_ID = <cfif len(attributes.project_id) and len(attributes.project_name)>#attributes.project_id#<cfelse>NULL</cfif>,
			ACTION_DETAIL = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.ACTION_DETAIL#">,
			IS_ACCOUNT = <cfif is_account>1<cfelse>0</cfif>,
			IS_ACCOUNT_TYPE = 11,
			UPDATE_EMP = #session.ep.userid#,
			UPDATE_IP = <cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.remote_addr#">,
			UPDATE_DATE = #now()#,
			PROCESS_CAT = #attributes.process_cat#,
			ASSETP_ID = <cfif isdefined("attributes.asset_id") and len(attributes.asset_id) and len(attributes.asset_name)>#attributes.asset_id#<cfelse>NULL</cfif>,
			SPECIAL_DEFINITION_ID = <cfif isdefined("attributes.special_definition_id") and len(attributes.special_definition_id)>#attributes.special_definition_id#<cfelse>NULL</cfif>,
			ACTION_VALUE = #attributes.system_amount#,
			ACTION_CURRENCY_ID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#session.ep.money#">,
            ACC_TYPE_ID = <cfif isdefined("attributes.acc_type_id") and len(attributes.acc_type_id)>#attributes.acc_type_id#<cfelse>NULL</cfif>
			<cfif len(session.ep.money2)>
				,ACTION_VALUE_2 = #wrk_round(attributes.system_amount/currency_multiplier,4)#
				,ACTION_CURRENCY_ID_2 = <cfqueryparam cfsqltype="cf_sql_varchar" value="#session.ep.money2#">
			</cfif>	
		WHERE
			ACTION_ID = #form.id#
	</cfquery>
			
	<cfscript>		
		if(is_cari eq 1)
		{
			carici(
				action_id:form.id,
				action_table:'CASH_ACTIONS',			
				workcube_process_type:process_type,	
				workcube_old_process_type:form.old_process_type,
				process_cat:form.process_cat,
				account_card_type:11,
				islem_tarihi: attributes.ACTION_DATE,
				islem_tutari: attributes.system_amount,
				islem_belge_no :attributes.paper_number,
				action_currency: session.ep.money,
				islem_detay : UCase(getLang('main',2284)),//NAKİT TAHSİLAT
				action_detail : attributes.action_detail,
				to_cash_id:attributes.CASH_ACTION_TO_CASH_ID,
				from_cmp_id:attributes.CASH_ACTION_FROM_COMPANY_ID,
				from_consumer_id : CASH_ACTION_FROM_CONSUMER_ID,
				from_employee_id : attributes.employee_id,
				acc_type_id : attributes.acc_type_id,
				other_money_value : iif(len(attributes.OTHER_CASH_ACT_VALUE),'attributes.OTHER_CASH_ACT_VALUE',de('')),
				other_money : form.money_type,
				currency_multiplier : currency_multiplier,
				revenue_collector_id :attributes.REVENUE_COLLECTOR_ID,
				project_id : iif((isdefined("attributes.project_id") and len(attributes.project_id) and len(attributes.project_name)),'attributes.project_id',de('')),
				special_definition_id : iif((isdefined("attributes.special_definition_id") and len(attributes.special_definition_id)),'attributes.special_definition_id',de('')),
				to_branch_id : to_branch_id,
				assetp_id : iif((isdefined("attributes.asset_id") and len(attributes.asset_id) and len(attributes.asset_name)),'attributes.asset_id',de('')),
				rate2:other_currency_multiplier
			);
		}
		else
			cari_sil(action_id:attributes.id,process_type:form.old_process_type);
			
		if(is_account eq 1)
		{
			if(isDefined("attributes.ACTION_DETAIL") and len(attributes.ACTION_DETAIL))
				str_card_detail = '#attributes.company_name#-#attributes.ACTION_DETAIL#';
			else if(GET_FROM_CASH.CASH_CURRENCY_ID is session.ep.money)
				str_card_detail = '#attributes.company_name#-' & UCase(getLang('main',2284)); //NAKİT TAHSİLAT
			else
				str_card_detail = '#attributes.company_name#-' & UCase(getLang('main',2745)); //DÖVİZLİ NAKİT TAHSİLAT İŞLEMİ
		
			muhasebeci (
				action_id:form.id,
				workcube_process_type:process_type,
				workcube_old_process_type :form.old_process_type,
				workcube_process_cat:form.process_cat,
				account_card_type:11,
				company_id : attributes.CASH_ACTION_FROM_COMPANY_ID,
				consumer_id : attributes.CASH_ACTION_FROM_CONSUMER_ID,
				islem_tarihi:attributes.ACTION_DATE,
				borc_hesaplar: get_from_cash.cash_acc_code,
				borc_tutarlar:attributes.system_amount,
				other_amount_borc : attributes.CASH_ACTION_VALUE,
				other_currency_borc : GET_FROM_CASH.CASH_CURRENCY_ID,
				alacak_hesaplar:MY_ACC_RESULT,
				alacak_tutarlar:attributes.system_amount,
				other_amount_alacak : iif(len(attributes.OTHER_CASH_ACT_VALUE),'attributes.OTHER_CASH_ACT_VALUE',de('')),
				other_currency_alacak : form.money_type,
				currency_multiplier : currency_multiplier,
				fis_satir_detay:str_card_detail,
				fis_detay : UCase(getLang('main',2284)),
				action_currency:session.ep.money,
				belge_no : attributes.paper_number,
				to_branch_id : to_branch_id,
				acc_project_id : iif((isdefined("attributes.project_id") and len(attributes.project_id) and len(attributes.project_name)),'attributes.project_id',de('')),
				assetp_id : iif((isdefined("attributes.asset_id") and len(attributes.asset_id) and len(attributes.asset_name)),'attributes.asset_id',de(''))
			);		
		}
		else
			muhasebe_sil(action_id:form.id,process_type:form.old_process_type,belge_no:attributes.paper_number);
		f_kur_ekle_action(action_id:form.id,process_type:1,action_table_name:'CASH_ACTION_MONEY',action_table_dsn:'#dsn2#');
	</cfscript>
	<!--- onay ve uyarıların gelebilmesi icin action file sarti kaldirildi --->
	<cf_workcube_process_cat 
		process_cat="#form.process_cat#"
		old_process_cat_id = "#attributes.old_process_cat_id#"
		action_id = #form.id#
		is_action_file = 1
		action_db_type = '#dsn2#'
		action_page='#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.form_add_cash_revenue&event=upd&id=#form.id#'
		action_file_name='#get_process_type.action_file_name#'
		is_template_action_file = '#get_process_type.action_file_from_template#'>
	</cftransaction>
    <cf_add_log log_type="0" action_id="#form.id#" action_name="#attributes.paper_number# Güncellendi" paper_no="#attributes.paper_number#" period_id="#session.ep.period_id#" process_type="#get_process_type.PROCESS_TYPE#" data_source="#dsn2#"> 
</cflock>
<cfquery name="get_closed_id" datasource="#dsn2#">
	SELECT CLOSED_ID FROM CARI_CLOSED_ROW WHERE ACTION_ID = #form.id# AND ACTION_TYPE_ID = #process_type#
</cfquery>
<script type="text/javascript">
	<cfif session.ep.our_company_info.is_paper_closer eq 1 and (len(attributes.CASH_ACTION_FROM_COMPANY_ID) or len(attributes.CASH_ACTION_FROM_CONSUMER_ID) or len(attributes.employee_id))>
		<cfif get_closed_id.recordcount gt 0>
			window.open('<cfoutput>#request.self#?fuseaction=finance.list_payment_actions&event=upd&closed_id=#get_closed_id.closed_id#&act_type=1</cfoutput>','page');
		<cfelse>
			window.open('<cfoutput>#request.self#?fuseaction=finance.list_payment_actions&event=add&act_type=1&member_id=#attributes.CASH_ACTION_FROM_COMPANY_ID#&consumer_id=#attributes.CASH_ACTION_FROM_CONSUMER_ID#&employee_id_new=#attributes.employee_id#&acc_type_id=#attributes.acc_type_id#&money_type=#form.money_type#&row_action_id=#form.id#&row_action_type=#process_type#</cfoutput>','page');
		</cfif>
	</cfif>
	window.location.href='<cfoutput>#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.form_add_cash_revenue&event=upd&id=#form.id#</cfoutput>';
</script>
