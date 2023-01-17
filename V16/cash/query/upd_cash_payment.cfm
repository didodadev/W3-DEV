<cf_get_lang_set module_name="cash"><!--- sayfanin en altinda kapanisi var --->
<cfif form.active_period neq session.ep.period_id>
	<script type="text/javascript">
		alert("<cf_get_lang_main no='1659.İşlem Yapmak İstediğiniz Muhasebe Dönemi ile Aktif Muhasebe Döneminiz Farklı Muhasebe Döneminizi Kontrol Ediniz'>!");
		window.location.href='<cfoutput>#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.list_cash_actions</cfoutput>';
	</script>
	<cfabort>
</cfif>
<cfif not isDefined("attributes.PAYER_ID") or not len(attributes.PAYER_ID)>
	<script type="text/javascript">
		alert("<cf_get_lang no='84.Ödeme Yapan Kişiyi Seçiniz !'>")
		history.back();
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
	CASH_CURRENCY_ID = listgetat(attributes.CASH_ACTION_FROM_CASH_ID,2,';');
	CASH_ACTION_FROM_CASH_ID = listfirst(attributes.CASH_ACTION_FROM_CASH_ID,';');
	from_branch_id = listlast(attributes.CASH_ACTION_FROM_CASH_ID,';');
	attributes.acc_type_id = '';
	if(listlen(attributes.employee_id,'_') eq 2)
	{
		attributes.acc_type_id = listlast(attributes.employee_id,'_');
		attributes.employee_id = listfirst(attributes.employee_id,'_');
	}
</cfscript>
<cfif is_account eq 1>
	<cfif len(attributes.employee_id)>
		<cfset acc = GET_EMPLOYEE_PERIOD(attributes.employee_id,attributes.acc_type_id)>
	<cfelseif len(attributes.CASH_ACTION_TO_COMPANY_ID)>
		<cfset acc = GET_COMPANY_PERIOD(attributes.CASH_ACTION_TO_COMPANY_ID)>
	<cfelseif len(attributes.CASH_ACTION_TO_CONSUMER_ID)>
		<cfset acc = GET_CONSUMER_PERIOD(attributes.CASH_ACTION_TO_CONSUMER_ID)>
	</cfif>
	<cfif not len(acc)>
		<script type="text/javascript">
			alert("<cf_get_lang no ='251.Seçtiğiniz Çalışan veya Üyenin Muhasebe Kodu Seçilmemiş'>!");
			history.back();	
		</script>
		<cfabort>
	</cfif>
</cfif>
<cf_date tarih='attributes.ACTION_DATE'>
<cfscript>
	attributes.cash_action_value = filterNum(attributes.cash_action_value);
	attributes.other_cash_act_value = filterNum(attributes.other_cash_act_value);
	attributes.system_amount = filterNum(attributes.system_amount);
	for(t_sy=1; t_sy lte attributes.kur_say; t_sy = t_sy+1)
	{
		'attributes.txt_rate1_#t_sy#' = filterNum(evaluate('attributes.txt_rate1_#t_sy#'),session.ep.our_company_info.rate_round_num);
		'attributes.txt_rate2_#t_sy#' = filterNum(evaluate('attributes.txt_rate2_#t_sy#'),session.ep.our_company_info.rate_round_num);
	}
	currency_multiplier = '';
	paper_currency_multiplier = '';
	if(isDefined('attributes.kur_say') and len(attributes.kur_say))
		for(mon=1;mon lte attributes.kur_say;mon=mon+1)
		{
			if(evaluate("attributes.hidden_rd_money_#mon#") is session.ep.money2)
				currency_multiplier = evaluate('attributes.txt_rate2_#mon#/attributes.txt_rate1_#mon#');
			if(evaluate("attributes.hidden_rd_money_#mon#") is money_type)
				paper_currency_multiplier = evaluate('attributes.txt_rate2_#mon#/attributes.txt_rate1_#mon#');
		}
</cfscript>

<cflock name="#createUUID()#" timeout="20">
	<cftransaction>
		<cfquery name="UPD_CASH_PAYMENT" datasource="#dsn2#">
			UPDATE
				CASH_ACTIONS
			SET
				PROCESS_CAT = #form.process_cat#,
				PAPER_NO = <cfif isDefined("attributes.PAPER_NUMBER") and len(attributes.PAPER_NUMBER)><cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.PAPER_NUMBER#">,<cfelse>NULL,</cfif>
				ACTION_TYPE = <cfqueryparam cfsqltype="cf_sql_varchar" value="#UCase(getLang('main',435))#">,
				ACTION_TYPE_ID = #process_type#,
				CASH_ACTION_TO_COMPANY_ID = <cfif len(attributes.CASH_ACTION_TO_COMPANY_ID) and (len(attributes.employee_id) eq 0)>#CASH_ACTION_TO_COMPANY_ID#,<cfelse>NULL,</cfif>
				CASH_ACTION_TO_CONSUMER_ID = <cfif len(attributes.CASH_ACTION_TO_CONSUMER_ID)>#CASH_ACTION_TO_CONSUMER_ID#,<cfelse>NULL,</cfif>
				CASH_ACTION_FROM_CASH_ID = #CASH_ACTION_FROM_CASH_ID#,
				CASH_ACTION_TO_EMPLOYEE_ID = <cfif len(attributes.employee_id)>#attributes.employee_id#,<cfelse>NULL,</cfif>
				ACTION_DATE = #attributes.ACTION_DATE#,
				CASH_ACTION_VALUE = #attributes.cash_action_value#,
				CASH_ACTION_CURRENCY_ID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#CASH_CURRENCY_ID#">,
				OTHER_CASH_ACT_VALUE = <cfif len(attributes.other_cash_act_value)>#attributes.other_cash_act_value#,<cfelse>NULL,</cfif>
				OTHER_MONEY = <cfif len(attributes.money_type)><cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.money_type#">,<cfelse>NULL,</cfif>
				PAYER_ID = #PAYER_ID#,
				PROJECT_ID = <cfif len(attributes.project_name) and len(attributes.project_id)>#attributes.project_id#<cfelse>NULL</cfif>,
				ACTION_DETAIL = <cfif isDefined("attributes.ACTION_DETAIL") and len(attributes.ACTION_DETAIL)><cfqueryparam cfsqltype="cf_sql_varchar" value="#ACTION_DETAIL#">,<cfelse>NULL,</cfif>	
				<cfif is_account eq 1>
					IS_ACCOUNT = 1,
					IS_ACCOUNT_TYPE = 12,
				<cfelse>
					IS_ACCOUNT = 0,
					IS_ACCOUNT_TYPE = 12,
				</cfif>	
				UPDATE_EMP = #SESSION.EP.USERID#,
				UPDATE_IP = <cfqueryparam cfsqltype="cf_sql_varchar" value="#CGI.REMOTE_ADDR#">,
				UPDATE_DATE = #NOW()#,
				ASSETP_ID = <cfif isdefined("attributes.asset_id") and len(attributes.asset_id) and len(attributes.asset_name)>#attributes.asset_id#<cfelse>NULL</cfif>,
				SPECIAL_DEFINITION_ID = <cfif isdefined("attributes.special_definition_id") and len(attributes.special_definition_id)>#attributes.special_definition_id#<cfelse>NULL</cfif>,
				EXPENSE_CENTER_ID = <cfif isdefined("attributes.expense_center_id") and len(attributes.expense_center_id) and isdefined("attributes.expense_center_name") and len(attributes.expense_center_name)>#attributes.expense_center_id#<cfelse>NULL</cfif>,
				EXPENSE_ITEM_ID = <cfif isdefined("attributes.expense_item_id") and len(attributes.expense_item_id) and isdefined("attributes.expense_item_name") and len(attributes.expense_item_name)>#attributes.expense_item_id#<cfelse>NULL</cfif>,
				ACTION_VALUE = #attributes.system_amount#,
				ACTION_CURRENCY_ID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#session.ep.money#">,
                ACC_TYPE_ID = <cfif isdefined("attributes.acc_type_id") and len(attributes.acc_type_id)>#attributes.acc_type_id#<cfelse>NULL</cfif>
				<cfif len(session.ep.money2)>
					,ACTION_VALUE_2 = #wrk_round(attributes.system_amount/currency_multiplier,4)#
					,ACTION_CURRENCY_ID_2 = <cfqueryparam cfsqltype="cf_sql_varchar" value="#session.ep.money2#">
				</cfif>	
			WHERE
				ACTION_ID=#attributes.ID#
		</cfquery>
		<cfscript>						
			//masraf kaydını siler
			butce_sil(action_id:attributes.id,process_type:form.old_process_type);
			if(is_cari eq 1)
			{
				carici(
					action_id :attributes.id,
					action_table : 'CASH_ACTIONS',
					islem_detay : UCase(getLang('main',435)),	//ÖDEME			
					action_detail : attributes.action_detail,
					workcube_process_type :process_type,
					workcube_old_process_type :form.old_process_type,
					process_cat : form.process_cat,
					account_card_type :12,
					islem_tarihi :attributes.ACTION_DATE,
					islem_tutari :attributes.system_amount,
					other_money_value : iif(len(attributes.other_cash_act_value),'attributes.other_cash_act_value',de('')),
					other_money : money_type,
					islem_belge_no : attributes.PAPER_NUMBER,
					acc_type_id : attributes.acc_type_id,
					action_currency : session.ep.money,
					from_cash_id :CASH_ACTION_FROM_CASH_ID,
					to_employee_id :attributes.employee_id,
					to_cmp_id :attributes.CASH_ACTION_TO_COMPANY_ID,
					currency_multiplier : currency_multiplier,
					to_consumer_id : CASH_ACTION_TO_CONSUMER_ID,
					payer_id :PAYER_ID,
					project_id : iif((isdefined("attributes.project_id") and len(attributes.project_id) and len(attributes.project_name)),'attributes.project_id',de('')),
					expense_center_id : iif((isdefined("attributes.expense_center_id") and len(attributes.expense_center_id) and len(attributes.expense_center_name)),'attributes.expense_center_id',de('')),
					expense_item_id : iif((isdefined("attributes.expense_item_id") and len(attributes.expense_item_id) and len(attributes.expense_item_name)),'attributes.expense_item_id',de('')),
					special_definition_id : iif((isdefined("attributes.special_definition_id") and len(attributes.special_definition_id)),'attributes.special_definition_id',de('')),
					from_branch_id : from_branch_id,
					assetp_id : iif((isdefined("attributes.asset_id") and len(attributes.asset_id) and len(attributes.asset_name)),'attributes.asset_id',de('')),
					rate2:paper_currency_multiplier
					);
			}
			else
				cari_sil(action_id:attributes.id,process_type:form.old_process_type);

			if (isdefined("attributes.expense_center_name") and len(attributes.expense_center_name) and len(attributes.expense_center_id) and len(attributes.expense_item_id) and len(attributes.expense_item_name))
			{
				if(CASH_CURRENCY_ID is SESSION.EP.MONEY)
				{
					butceci(
						action_id : attributes.id,
						muhasebe_db : dsn2,
						is_income_expense : false,
						process_type : process_type,
						nettotal : attributes.system_amount,
						other_money_value : iif(len(attributes.other_cash_act_value),'attributes.other_cash_act_value',de('')),
						action_currency : attributes.money_type,
						currency_multiplier : currency_multiplier,
						expense_date : attributes.ACTION_DATE,
						expense_center_id : attributes.expense_center_id,
						expense_item_id : attributes.expense_item_id,
						detail : UCase(getLang('main',2746)), //KASA ÖDEME MASRAFI
						paper_no : attributes.paper_number,
						company_id : CASH_ACTION_TO_COMPANY_ID,
						consumer_id : CASH_ACTION_TO_CONSUMER_ID,
						employee_id : attributes.employee_id,
						branch_id : from_branch_id,
						insert_type : 1//banka vs den eklenen masraflar için farklı ekleme metodu tanımlar
					);
				}
				else
				{
					butceci(
						action_id : attributes.id,
						muhasebe_db : dsn2,
						is_income_expense : false,
						process_type : process_type,
						nettotal : attributes.system_amount,
						other_money_value : attributes.cash_action_value,
						action_currency : CASH_CURRENCY_ID,
						currency_multiplier : currency_multiplier,
						expense_date : attributes.ACTION_DATE,
						expense_center_id : attributes.expense_center_id,
						expense_item_id : attributes.expense_item_id,
						detail : UCase(getLang('main',2746)), //KASA ÖDEME MASRAFI
						paper_no : attributes.paper_number,
						company_id : CASH_ACTION_TO_COMPANY_ID,
						consumer_id : CASH_ACTION_TO_CONSUMER_ID,
						employee_id : attributes.employee_id,
						branch_id : from_branch_id,
						insert_type : 1//banka vs den eklenen masraflar için farklı ekleme metodu tanımlar
					);
				}
			}
			
			if(is_account eq 1)
			{
				GET_CASH1_ACC_CODE=cfquery(datasource:"#dsn2#",sqlstring:"SELECT CASH_ACC_CODE FROM CASH WHERE CASH_ID=#CASH_ACTION_FROM_CASH_ID#");
				// company,consumer,employee adi satir detaya ek bilgi olarak ekleniyor
				if (isDefined("attributes.ACTION_DETAIL") and len(attributes.ACTION_DETAIL))
					str_card_detail = '#attributes.company_name#-#attributes.ACTION_DETAIL#';
				else
					str_card_detail = '#attributes.company_name#-' & UCase(getLang('cash',53));	
									
				muhasebeci (
					action_id:attributes.id,
					workcube_process_type:process_type,
					workcube_old_process_type :form.old_process_type,
					workcube_process_cat:form.process_cat,
					account_card_type:12,
					company_id: attributes.CASH_ACTION_TO_COMPANY_ID,
					consumer_id: attributes.CASH_ACTION_TO_CONSUMER_ID,
					islem_tarihi:attributes.ACTION_DATE,
					borc_hesaplar : ACC,
					borc_tutarlar : attributes.system_amount,
					other_amount_borc : iif(len(attributes.other_cash_act_value),'attributes.other_cash_act_value',de('')),
					other_currency_borc : money_type,
					alacak_hesaplar : GET_CASH1_ACC_CODE.CASH_ACC_CODE,
					alacak_tutarlar : attributes.system_amount,
					other_amount_alacak : attributes.cash_action_value,
					other_currency_alacak : CASH_CURRENCY_ID,
					currency_multiplier : currency_multiplier,
					fis_satir_detay:str_card_detail,
					currency_multiplier : currency_multiplier,
					fis_detay : UCase(getLang('cash',53)),
					belge_no : attributes.PAPER_NUMBER,
					acc_project_id : iif((isdefined("attributes.project_id") and len(attributes.project_id) and len(attributes.project_name)),'attributes.project_id',de('')),
					from_branch_id : from_branch_id
				);
			}
			else
				muhasebe_sil(action_id:attributes.id,process_type:form.old_process_type,belge_no:attributes.PAPER_NUMBER);
			f_kur_ekle_action(action_id:attributes.ID,process_type:1,action_table_name:'CASH_ACTION_MONEY',action_table_dsn:'#dsn2#');
		</cfscript>
		<!--- onay ve uyarıların gelebilmesi icin action file sarti kaldirildi --->
		<cf_workcube_process_cat 
			process_cat="#form.process_cat#"
			old_process_cat_id = "#attributes.old_process_cat_id#"
			action_id = #attributes.id#
			is_action_file = 1
			action_db_type = '#dsn2#'
			action_page='#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.form_add_cash_payment&event=upd&id=#attributes.id#'
			action_file_name='#get_process_type.action_file_name#'
			is_template_action_file = '#get_process_type.action_file_from_template#'>
	</cftransaction>
    <cf_add_log log_type="0" action_id="#attributes.id#" action_name="#attributes.PAPER_NUMBER# Güncellendi" paper_no="#attributes.PAPER_NUMBER#" period_id="#session.ep.period_id#" process_type="#get_process_type.process_type#" data_source="#dsn2#">
</cflock>
<cfquery name="get_closed_id" datasource="#dsn2#">
	SELECT CLOSED_ID FROM CARI_CLOSED_ROW WHERE ACTION_ID = #attributes.id# AND ACTION_TYPE_ID = #process_type#
</cfquery>
<script type="text/javascript">
	<cfif session.ep.our_company_info.is_paper_closer eq 1 and (len(attributes.CASH_ACTION_TO_COMPANY_ID) or len(attributes.CASH_ACTION_TO_CONSUMER_ID) or len(attributes.employee_id)) and session.ep.isBranchAuthorization eq 0>
		<cfif isdefined("attributes.is_popup") and attributes.is_popup eq 1>
			window.opener.cash_list.submit();
		</cfif>
		<cfif get_closed_id.recordcount gt 0>
			window.open('<cfoutput>#request.self#?fuseaction=finance.list_payment_actions&event=upd&closed_id=#get_closed_id.closed_id#&act_type=1</cfoutput>','page');
		<cfelse>
			window.open('<cfoutput>#request.self#?fuseaction=finance.list_payment_actions&event=add&act_type=1&member_id=#attributes.CASH_ACTION_TO_COMPANY_ID#&consumer_id=#attributes.CASH_ACTION_TO_CONSUMER_ID#&employee_id_new=#attributes.employee_id#&acc_type_id=#attributes.acc_type_id#&money_type=#form.money_type#&row_action_id=#attributes.id#&row_action_type=#process_type#</cfoutput>','page');
		</cfif>
	<cfelse>
		<cfif isdefined("attributes.is_popup") and attributes.is_popup eq 1>
			wrk_opener_reload();
		</cfif>
	</cfif>
	<cfif isdefined("attributes.is_popup") and attributes.is_popup eq 1>
	window.close();
	<cfelse>
		window.location.href='<cfoutput>#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.form_add_cash_payment&event=upd&id=#attributes.id#</cfoutput>';
	</cfif>
</script>
<cf_get_lang_set module_name="#lcase(listgetat(attributes.fuseaction,1,'.'))#"><!--- sayfanin en ustunde acilisi var --->
