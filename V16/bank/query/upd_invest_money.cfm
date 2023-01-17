<!---Select ifadeleri düzenlendi.e.a 23.07.2012--->
<cf_get_lang_set module_name="bank"><!--- sayfanin en altinda kapanisi var --->
<cfif form.active_period neq session.ep.period_id>
	<script type="text/javascript">
		alert("<cf_get_lang_main no='1659.İşlem Yapmak İstediğiniz Muhasebe Dönemi ile Aktif Muhasebe Döneminiz Farklı Muhasebe Döneminizi Kontrol Ediniz'>!");
		window.location.href='<cfoutput>#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.list_bank_actions</cfoutput>';
	</script>
	<cfabort>
</cfif>
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
	FROM_CASH_ID = listfirst(attributes.FROM_CASH_ID,';');
	attributes.ACTION_VALUE = filterNum(attributes.ACTION_VALUE);
	attributes.OTHER_CASH_ACT_VALUE = filterNum(attributes.OTHER_CASH_ACT_VALUE);
	attributes.system_amount = filterNum(attributes.system_amount);
	for(f_sy=1; f_sy lte attributes.kur_say; f_sy = f_sy+1)
	{
		'attributes.txt_rate1_#f_sy#' = filterNum(evaluate('attributes.txt_rate1_#f_sy#'),session.ep.our_company_info.rate_round_num);
		'attributes.txt_rate2_#f_sy#' = filterNum(evaluate('attributes.txt_rate2_#f_sy#'),session.ep.our_company_info.rate_round_num);
	}
	if(isdefined("attributes.branch_id") and len(attributes.branch_id))
		to_branch_id_info = attributes.branch_id;
	else
		to_branch_id_info = listgetat(session.ep.user_location,2,'-');
	/* kasaya ait sube */
	from_branch_id_info = listlast(attributes.FROM_CASH_ID,';');	
	currency_multiplier = '';
	if(isDefined('attributes.kur_say') and len(attributes.kur_say))
		for(mon=1;mon lte attributes.kur_say;mon=mon+1)
			if(evaluate("attributes.hidden_rd_money_#mon#") is session.ep.money2)
				currency_multiplier = evaluate('attributes.txt_rate2_#mon#/attributes.txt_rate1_#mon#');
</cfscript>
<cfquery name="control_paper_no" datasource="#dsn2#">
	SELECT ACTION_ID FROM BANK_ACTIONS WHERE PAPER_NO='#attributes.paper_number#' AND ACTION_ID <> #attributes.id#
</cfquery>
<cfif control_paper_no.recordcount>
	<script type="text/javascript">
		alert("<cf_get_lang no ='348.Girdiginiz Belge Numarası Kullanılmaktadır'>!");
		history.back();	
	</script>
	<cfabort>
</cfif>
<cf_date tarih='attributes.ACTION_DATE'>
<!---hesabýn muhasebe kodu--->
<cfquery name="GET_CASH_CUR" datasource="#dsn2#">
	SELECT CASH_CURRENCY_ID,CASH_ACC_CODE FROM CASH WHERE CASH_ID=#FROM_CASH_ID#
</cfquery>
<cflock name="#createUUID()#" timeout="20">
	<cftransaction>			
		<cfquery name="INVEST_MONEY_BANK" datasource="#dsn2#">
			UPDATE
				BANK_ACTIONS
			SET		
				PROCESS_CAT = #form.process_cat#,
				ACTION_VALUE = #attributes.ACTION_VALUE#,
				ACTION_CURRENCY_ID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.currency_id#">,
				ACTION_DATE = #attributes.ACTION_DATE#,
				ACTION_TO_ACCOUNT_ID = #attributes.account_id#,
				ACTION_FROM_CASH_ID = #FROM_CASH_ID#,
				ACTION_DETAIL = <cfqueryparam cfsqltype="cf_sql_varchar" value="#ACTION_DETAIL#">,
				OTHER_CASH_ACT_VALUE = <cfif len(attributes.OTHER_CASH_ACT_VALUE)>#attributes.OTHER_CASH_ACT_VALUE#<cfelse>NULL</cfif>,
				OTHER_MONEY = <cfif LEN(money_type)><cfqueryparam cfsqltype="cf_sql_varchar" value="#money_type#"><cfelse>NULL</cfif>,
				IS_ACCOUNT = <cfif is_account eq 1>1,<cfelse>0,</cfif>
				IS_ACCOUNT_TYPE = 13,
				ACTION_EMPLOYEE_ID = #attributes.EMPLOYEE_ID#,
				PAPER_NO = <cfif isdefined("attributes.paper_number") and len(attributes.paper_number)><cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.paper_number#"><cfelse>NULL</cfif>,
				UPDATE_EMP = #SESSION.EP.USERID#,
				UPDATE_IP = <cfqueryparam cfsqltype="cf_sql_varchar" value="#CGI.REMOTE_ADDR#">,
				UPDATE_DATE = #NOW()#	,
				SYSTEM_ACTION_VALUE = #attributes.system_amount#,
				SYSTEM_CURRENCY_ID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#session.ep.money#">,
				TO_BRANCH_ID = #to_branch_id_info#,
				FROM_BRANCH_ID = #from_branch_id_info#
				<cfif len(session.ep.money2)>
					,ACTION_VALUE_2 = #wrk_round(attributes.system_amount/currency_multiplier,4)#
					,ACTION_CURRENCY_ID_2 = <cfqueryparam cfsqltype="cf_sql_varchar" value="#session.ep.money2#">
				</cfif>
				<cfif IsDefined("attributes.project_id") and len(attributes.project_id) and len(attributes.project_head)>
					,PROJECT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.project_id#">
				<cfelse>
					,PROJECT_ID = NULL
				</cfif>
			WHERE
				ACTION_ID = #attributes.id#
		</cfquery>
		<cfquery name="INVEST_MONEY_CASH" datasource="#dsn2#">
			UPDATE
				CASH_ACTIONS
			SET
				PROCESS_CAT = #form.process_cat#,
				CASH_ACTION_VALUE = #attributes.ACTION_VALUE#,
				CASH_ACTION_CURRENCY_ID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.currency_id#">,
				ACTION_DATE = #attributes.ACTION_DATE#,
				CASH_ACTION_TO_ACCOUNT_ID = #attributes.account_id#,
				CASH_ACTION_FROM_CASH_ID = #FROM_CASH_ID#,
				ACTION_DETAIL = <cfqueryparam cfsqltype="cf_sql_varchar" value="#ACTION_DETAIL#">,
				OTHER_CASH_ACT_VALUE = <cfif len(attributes.OTHER_CASH_ACT_VALUE)>#attributes.OTHER_CASH_ACT_VALUE#<cfelse>NULL</cfif>,
				OTHER_MONEY = <cfif LEN(money_type)><cfqueryparam cfsqltype="cf_sql_varchar" value="#money_type#"><cfelse>NULL</cfif>,
				IS_ACCOUNT = <cfif is_account>1,<cfelse>0,</cfif>
				IS_ACCOUNT_TYPE = 12,
				PAPER_NO = <cfif isdefined("attributes.paper_number") and len(attributes.paper_number)><cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.paper_number#"><cfelse>NULL</cfif>,
				UPDATE_EMP = #SESSION.EP.USERID#,
				UPDATE_IP = <cfqueryparam cfsqltype="cf_sql_varchar" value="#CGI.REMOTE_ADDR#">,
				UPDATE_DATE = #NOW()#,
				ACTION_VALUE = #attributes.system_amount#,
				ACTION_CURRENCY_ID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#session.ep.money#">
				<cfif len(session.ep.money2)>
					,ACTION_VALUE_2 = #wrk_round(attributes.system_amount/currency_multiplier,4)#
					,ACTION_CURRENCY_ID_2 = <cfqueryparam cfsqltype="cf_sql_varchar" value="#session.ep.money2#">
				</cfif>
				<cfif IsDefined("attributes.project_id") and len(attributes.project_id) and len(attributes.project_head)>
					,PROJECT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.project_id#">
				<cfelse>
					,PROJECT_ID = NULL
				</cfif>
			WHERE
				BANK_ACTION_ID = #attributes.id#
		</cfquery>
		<cfquery name="GET_CASH_ACTION" datasource="#dsn2#">
			SELECT ACTION_ID FROM CASH_ACTIONS WHERE BANK_ACTION_ID = #attributes.id#
		</cfquery>
		<cfscript>
			if(is_account eq 1)
			{
				if (isDefined("attributes.ACTION_DETAIL") and len(attributes.ACTION_DETAIL))
					str_card_detail = '#attributes.ACTION_DETAIL#';
				else
					str_card_detail = UCase(getLang('main',2285));		
				muhasebeci (
					action_id:attributes.ID,
					workcube_process_type:process_type,
					workcube_old_process_type:form.old_process_type,
					workcube_process_cat:form.process_cat,
					account_card_type:12,
					islem_tarihi: attributes.ACTION_DATE,
					fis_satir_detay:str_card_detail,
					borc_hesaplar: attributes.account_acc_code,
					borc_tutarlar: attributes.system_amount,
					other_amount_borc : attributes.ACTION_VALUE,
					other_currency_borc : attributes.currency_id,
					alacak_hesaplar: GET_CASH_CUR.CASH_ACC_CODE,
					alacak_tutarlar: attributes.system_amount,
					other_amount_alacak : attributes.ACTION_VALUE,
					other_currency_alacak : attributes.currency_id,
					currency_multiplier : currency_multiplier,
					fis_detay: UCase(getLang('main',2285)),
					from_branch_id : from_branch_id_info,
					to_branch_id : to_branch_id_info,
					belge_no : attributes.paper_number
				);
			}
			else
				muhasebe_sil (action_id:attributes.ID,process_type:form.old_process_type);

			f_kur_ekle_action(action_id:attributes.ID,process_type:1,action_table_name:'BANK_ACTION_MONEY',action_table_dsn:'#dsn2#');
			if(GET_CASH_ACTION.recordcount)
				f_kur_ekle_action(action_id:GET_CASH_ACTION.ACTION_ID,process_type:1,action_table_name:'CASH_ACTION_MONEY',action_table_dsn:'#dsn2#');
		</cfscript>	
        <cf_workcube_process_cat 
            process_cat="#form.process_cat#"
            action_id = #attributes.ID#
            is_action_file = 1
            action_page='#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.form_add_invest_money&event=upd&id=#attributes.ID#'
            action_file_name='#get_process_type.action_file_name#'
            action_db_type = '#dsn2#'
            is_template_action_file = '#get_process_type.action_file_from_template#'>
             <cf_add_log employee_id="#session.ep.userid#" log_type="0" action_id="#attributes.id#" action_name= "Hesaba Para Yatırma Güncelleme" paper_no= "#attributes.paper_number#" period_id="#session.ep.period_id#" process_type="#get_process_type.PROCESS_TYPE#" data_source="#dsn2#">
	</cftransaction>
</cflock>
<script type="text/javascript">
	<cfif isdefined("attributes.is_popup") and attributes.is_popup eq 1>
		wrk_opener_reload();
		window.close();
	<cfelse>
		window.location.href='<cfoutput>#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.form_add_invest_money&event=upd&id=#attributes.ID#</cfoutput>';
	</cfif>
</script>
<cf_get_lang_set module_name="#lcase(listgetat(attributes.fuseaction,1,'.'))#"><!--- sayfanin en ustunde acilisi var --->
