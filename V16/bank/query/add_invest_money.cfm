<!---E.A select ifadeleri düzenlendi 23.07.2012--->
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
	for(k_sy=1; k_sy lte attributes.kur_say; k_sy = k_sy+1)
	{
		'attributes.txt_rate1_#k_sy#' = filterNum(evaluate('attributes.txt_rate1_#k_sy#'),session.ep.our_company_info.rate_round_num);
		'attributes.txt_rate2_#k_sy#' = filterNum(evaluate('attributes.txt_rate2_#k_sy#'),session.ep.our_company_info.rate_round_num);
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
<cfif len(attributes.paper_number)>
	<cfquery name="control_paper_no" datasource="#dsn2#">
		SELECT ACTION_ID FROM BANK_ACTIONS WHERE PAPER_NO= <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.paper_number#">
	</cfquery>
	<cfif control_paper_no.recordcount>
		<script type="text/javascript">
			alert("<cf_get_lang_main no ='710.Girdiğiniz Belge Numarası Kullanılmaktadır'>!");
			history.back();	
		</script>
		<cfabort>
	</cfif>
</cfif>
<cf_date tarih='attributes.ACTION_DATE'>
<cfquery name="GET_CASH_CUR" datasource="#dsn2#">
	SELECT CASH_ACC_CODE,CASH_CURRENCY_ID FROM CASH WHERE CASH_ID=#FROM_CASH_ID#
</cfquery>
<cflock name="#createUUID()#" timeout="20">
	<cftransaction>	
		<cfquery name="INVEST_MONEY_BANK" datasource="#dsn2#">
			INSERT INTO
				BANK_ACTIONS
				(
					ACTION_TYPE,
					ACTION_TYPE_ID,
					ACTION_VALUE,
					ACTION_CURRENCY_ID,
					ACTION_DATE,
					ACTION_TO_ACCOUNT_ID,
					ACTION_FROM_CASH_ID,
					PROCESS_CAT,
					ACTION_EMPLOYEE_ID,
					ACTION_DETAIL,
					OTHER_CASH_ACT_VALUE,
					OTHER_MONEY,
					IS_ACCOUNT,
					IS_ACCOUNT_TYPE,
					PAPER_NO,
					RECORD_EMP,
					RECORD_IP,
					RECORD_DATE,
					TO_BRANCH_ID,
					FROM_BRANCH_ID,
					SYSTEM_ACTION_VALUE,
					SYSTEM_CURRENCY_ID
					<cfif len(session.ep.money2)>
						,ACTION_VALUE_2
						,ACTION_CURRENCY_ID_2
					</cfif>	
					<cfif IsDefined("attributes.project_id") and len(attributes.project_id) and len(attributes.project_head)>
						,PROJECT_ID
					</cfif>
				)
				VALUES
				(
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#UCase(getLang('main',2285))#">,
					#process_type#,
					#attributes.ACTION_VALUE#,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.currency_id#">,
					#attributes.ACTION_DATE#,
					#attributes.account_id#,
					#FROM_CASH_ID#,
					#form.process_cat#,
					#EMPLOYEE_ID#,
					<cfif isDefined("attributes.ACTION_DETAIL") and len(attributes.ACTION_DETAIL)><cfqueryparam cfsqltype="cf_sql_varchar" value="#ACTION_DETAIL#">,<cfelse>NULL,</cfif>
					<cfif isDefined("attributes.OTHER_CASH_ACT_VALUE") and len(attributes.OTHER_CASH_ACT_VALUE)>#attributes.OTHER_CASH_ACT_VALUE#,<cfelse>NULL,</cfif>
					<cfif isDefined("money_type") and len(attributes.money_type)><cfqueryparam cfsqltype="cf_sql_varchar" value="#money_type#">,<cfelse>NULL,</cfif>
					<cfif is_account eq 1>1,13,<cfelse>0,13,</cfif>
					<cfif isdefined("attributes.paper_number") and len(attributes.paper_number)><cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.paper_number#"><cfelse>NULL</cfif>,
					#SESSION.EP.USERID#,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#CGI.REMOTE_ADDR#">,
					#NOW()#,
					#to_branch_id_info#,
					#from_branch_id_info#,
					#attributes.system_amount#,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#session.ep.money#">
					<cfif len(session.ep.money2)>
						,#wrk_round(attributes.system_amount/currency_multiplier,4)#
						,<cfqueryparam cfsqltype="cf_sql_varchar" value="#session.ep.money2#">
					</cfif>
					<cfif IsDefined("attributes.project_id") and len(attributes.project_id) and len(attributes.project_head)>
						,<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.project_id#">
					</cfif>	
				)
		</cfquery>
		<cfquery name="GET_MAX_ID" datasource="#DSN2#">
			SELECT MAX(ACTION_ID) AS BANK_ACTION_ID FROM BANK_ACTIONS
		</cfquery>
		<cfquery name="INVEST_MONEY_CASH" datasource="#dsn2#">
			INSERT INTO
				CASH_ACTIONS
				(
					PROCESS_CAT,
					ACTION_TYPE,
					ACTION_TYPE_ID,
					CASH_ACTION_VALUE,
					CASH_ACTION_CURRENCY_ID,
					ACTION_DATE,
					CASH_ACTION_TO_ACCOUNT_ID,
					CASH_ACTION_FROM_CASH_ID,
					PAYER_ID,
					BANK_ACTION_ID,
					ACTION_DETAIL,
					OTHER_CASH_ACT_VALUE,
					OTHER_MONEY,
					IS_ACCOUNT,
					IS_ACCOUNT_TYPE,
					PAPER_NO,
					RECORD_EMP,
					RECORD_IP,
					RECORD_DATE,
					ACTION_VALUE,
					ACTION_CURRENCY_ID
					<cfif len(session.ep.money2)>
						,ACTION_VALUE_2
						,ACTION_CURRENCY_ID_2
					</cfif>
					<cfif IsDefined("attributes.project_id") and len(attributes.project_id) and len(attributes.project_head)>
						,PROJECT_ID
					</cfif>
				)
				VALUES
				(
					#form.process_cat#,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#UCase(getLang('main',2285))#">,
					#process_type#,
					#attributes.ACTION_VALUE#,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.currency_id#">,
					#attributes.ACTION_DATE#,
					#attributes.account_id#,
					#FROM_CASH_ID#,
					#EMPLOYEE_ID#,
					#GET_MAX_ID.BANK_ACTION_ID#,
					<cfif isDefined("attributes.ACTION_DETAIL") and len(attributes.ACTION_DETAIL)><cfqueryparam cfsqltype="cf_sql_varchar" value="#ACTION_DETAIL#">,<cfelse>NULL,</cfif>
					<cfif isDefined("attributes.OTHER_CASH_ACT_VALUE") and len(attributes.OTHER_CASH_ACT_VALUE)>#attributes.OTHER_CASH_ACT_VALUE#,<cfelse>NULL,</cfif>
				    <cfif isDefined("attributes.money_type") and len(attributes.money_type)><cfqueryparam cfsqltype="cf_sql_varchar" value="#money_type#">,<cfelse>NULL,</cfif>
					<cfif is_account eq 1>1,12,<cfelse>0,12,</cfif>
					<cfif isdefined("attributes.paper_number") and len(attributes.paper_number)><cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.paper_number#">,<cfelse>NULL,</cfif>
					#SESSION.EP.USERID#,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#CGI.REMOTE_ADDR#">,
					#NOW()#,
					#attributes.system_amount#,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#session.ep.money#">
					<cfif len(session.ep.money2)>
						,#wrk_round(attributes.system_amount/currency_multiplier,4)#
						,<cfqueryparam cfsqltype="cf_sql_varchar" value="#session.ep.money2#">
					</cfif>
					<cfif IsDefined("attributes.project_id") and len(attributes.project_id) and len(attributes.project_head)>
						,<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.project_id#">
					</cfif>
				)
		</cfquery>
		<cfquery name="GET_CASH_MAX_ID" datasource="#DSN2#">
			SELECT MAX(ACTION_ID) AS CASH_ACTION_ID FROM CASH_ACTIONS
		</cfquery>
		<cfscript>
			if(is_account)
			{
				if (isDefined("attributes.ACTION_DETAIL") and len(attributes.ACTION_DETAIL))
					str_card_detail = '#attributes.ACTION_DETAIL#';
				else
					str_card_detail = UCase(getLang('main',2285));		
				muhasebeci (
					action_id : GET_MAX_ID.BANK_ACTION_ID,
					workcube_process_type : process_type,
					workcube_process_cat:form.process_cat,
					account_card_type : 12,
					islem_tarihi : attributes.ACTION_DATE,
					fis_satir_detay : str_card_detail,
					borc_hesaplar : attributes.account_acc_code,
					borc_tutarlar : attributes.system_amount,
					other_amount_borc : attributes.ACTION_VALUE,
					other_currency_borc : attributes.currency_id,
					alacak_hesaplar : GET_CASH_CUR.CASH_ACC_CODE,
					alacak_tutarlar : attributes.system_amount,
					other_amount_alacak : attributes.ACTION_VALUE,
					other_currency_alacak : attributes.currency_id,
					currency_multiplier : currency_multiplier,
					fis_detay : UCase(getLang('main',2285)),
					from_branch_id : from_branch_id_info,
					to_branch_id : to_branch_id_info,
					belge_no : attributes.paper_number
				);
			}		

			f_kur_ekle_action(action_id:GET_MAX_ID.BANK_ACTION_ID,process_type:0,action_table_name:'BANK_ACTION_MONEY',action_table_dsn:'#dsn2#');
			f_kur_ekle_action(action_id:GET_CASH_MAX_ID.CASH_ACTION_ID,process_type:0,action_table_name:'CASH_ACTION_MONEY',action_table_dsn:'#dsn2#');
		</cfscript>
        <cf_workcube_process_cat 
            process_cat="#form.process_cat#"
            action_id = #GET_MAX_ID.BANK_ACTION_ID#
            is_action_file = 1
            action_file_name='#get_process_type.action_file_name#'
            action_page='#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.form_add_invest_money&event=upd&id=#GET_MAX_ID.BANK_ACTION_ID#'
            action_db_type = '#dsn2#'
            is_template_action_file = '#get_process_type.action_file_from_template#'>
             <cf_add_log employee_id="#session.ep.userid#" log_type="1" action_id="#GET_MAX_ID.BANK_ACTION_ID#" action_name= "Hesaba Para Yatırıldı" paper_no= "#attributes.paper_number#" period_id="#session.ep.period_id#" process_type="#get_process_type.PROCESS_TYPE#" data_source="#dsn2#">
	</cftransaction>	
</cflock>
<script type="text/javascript">	
<cfif session.ep.isBranchAuthorization>
	window.open('<cfoutput>#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.popup_upd_invest_money&id=#GET_MAX_ID.BANK_ACTION_ID#</cfoutput>','mywindow','resizable=1,menubar=1,status=1,toolbar=0,scrollbars=1,width=600,height=470');
	window.location.href='<cfoutput>#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.list_bank_actions</cfoutput>';
<cfelse>
	window.location.href='<cfoutput>#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.form_add_invest_money&event=upd&id=#GET_MAX_ID.BANK_ACTION_ID#</cfoutput>';
</cfif>
</script>
<!---<cflocation url="#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.list_bank_actions" addtoken="No">--->
<cf_get_lang_set module_name="#lcase(listgetat(attributes.fuseaction,1,'.'))#"><!--- sayfanin en ustunde acilisi var --->
