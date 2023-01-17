<cf_get_lang_set module_name="bank">
<cfif form.active_period neq session.ep.period_id>
	<script type="text/javascript">
		alert("<cf_get_lang_main no='1659.İşlem Yapmak İstediğiniz Muhasebe Dönemi ile Aktif Muhasebe Döneminiz Farklı Muhasebe Döneminizi Kontrol Ediniz'>!");
		window.location.href='<cfoutput>#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.list_caris</cfoutput>';
	</script>
	<cfabort>
</cfif>
<cfquery name="get_process_type" datasource="#dsn3#">
	SELECT 
		PROCESS_TYPE,
		IS_CARI,
		IS_ACCOUNT,
		ACTION_FILE_NAME,
		ACTION_FILE_FROM_TEMPLATE,
		ACCOUNT_TYPE_ID
	 FROM 
	 	SETUP_PROCESS_CAT 
	WHERE 
		PROCESS_CAT_ID = #form.process_cat#
</cfquery>
<cfscript>
	process_type = get_process_type.PROCESS_TYPE;
	is_cari = get_process_type.IS_CARI;
	is_account = get_process_type.IS_ACCOUNT;
	is_account_type_id = get_process_type.ACCOUNT_TYPE_ID;
	attributes.ACTION_VALUE = filterNum(attributes.ACTION_VALUE);
	attributes.OTHER_CASH_ACT_VALUE = filterNum(attributes.OTHER_CASH_ACT_VALUE);
	attributes.system_amount = filterNum(attributes.system_amount);
	attributes.masraf = filterNum(attributes.masraf);
	paper_currency_multiplier = '';
	for(n_sy = 1; n_sy lte attributes.kur_say; n_sy = n_sy+1)
	{
		'attributes.txt_rate1_#n_sy#' = filterNum(evaluate('attributes.txt_rate1_#n_sy#'),session.ep.our_company_info.rate_round_num);
		'attributes.txt_rate2_#n_sy#' = filterNum(evaluate('attributes.txt_rate2_#n_sy#'),session.ep.our_company_info.rate_round_num);
		if( evaluate("attributes.hidden_rd_money_#n_sy#") is form.money_type)
			paper_currency_multiplier = evaluate('attributes.txt_rate2_#n_sy#/attributes.txt_rate1_#n_sy#');
		if(evaluate("attributes.hidden_rd_money_#n_sy#") is attributes.currency_id)
			dovizli_islem_multiplier = evaluate('attributes.txt_rate2_#n_sy#/attributes.txt_rate1_#n_sy#');
	}
	if(isdefined("attributes.branch_id") and len(attributes.branch_id))
		branch_id_info = attributes.branch_id;
	else
		branch_id_info = listgetat(session.ep.user_location,2,'-');
	if (session.ep.our_company_info.project_followup neq 1)//isdefined lar altta functionlarda sıkıntı yaratıyordu buraya tanımlandı
	{
		attributes.project_id = "";
		attributes.project_head = "";
	}
	currency_multiplier = '';
	if(isDefined('attributes.kur_say') and len(attributes.kur_say))
		for(mon=1;mon lte attributes.kur_say;mon=mon+1)
			if(evaluate("attributes.hidden_rd_money_#mon#") is session.ep.money2)
				currency_multiplier = evaluate('attributes.txt_rate2_#mon#/attributes.txt_rate1_#mon#');
	attributes.acc_type_id = '';
	if(listlen(attributes.employee_id,'_') eq 2)
	{
		attributes.acc_type_id = listlast(attributes.employee_id,'_');
		attributes.employee_id = listfirst(attributes.employee_id,'_');
	}
</cfscript>
<cfif isdefined('attributes.bank_order_id') and len(attributes.bank_order_id)>
	<cfquery name="get_bank_order" datasource="#dsn2#">
		SELECT 
			BON.BANK_ORDER_ID,
			SPC.IS_CARI,
			SPC.IS_ACCOUNT,
			SPC.PROCESS_TYPE,
			A.ACCOUNT_NO,
			A.ACCOUNT_ORDER_CODE
		FROM 
			BANK_ORDERS BON,
			#dsn3_alias#.ACCOUNTS AS A,
			#dsn3_alias#.SETUP_PROCESS_CAT AS SPC
		WHERE 		
			A.ACCOUNT_ID = BON.ACCOUNT_ID
			AND SPC.PROCESS_CAT_ID = BANK_ORDER_TYPE_ID
			AND SPC.PROCESS_TYPE = BANK_ORDER_TYPE
			AND BON.BANK_ORDER_ID = #attributes.bank_order_id#
	</cfquery>
	<cfif get_bank_order.recordcount>
		<cfset assign_order_process_type = get_bank_order.PROCESS_TYPE>
		<cfset assign_order_cari = get_bank_order.IS_CARI>
		<cfset assign_order_account = get_bank_order.IS_ACCOUNT>
		<!--- banka talimatı muhasebe islemi yapıyorsa, havale işlemi icin muhasebe hareketi yapan bir işlem kategorisi secilmeli.
		banka talimatı cari hareket yapmıssa, havalede yeniden cari işlem yapılan bir islem kategorisi secilemez --->
		<cfif ((assign_order_cari eq 1) and (is_cari eq 1)) or ((assign_order_account eq 1) and (is_account eq 0))>
			<script type="text/javascript">
				alert("<cf_get_lang no ='399.İşlem Kategorilerinizi Kontrol Ediniz'>");
				history.back();
			</script>
			<cfabort>
		</cfif>
	<cfelse>
		<cfset assign_order_cari = "">
		<cfset assign_order_account = "">
	</cfif>	
<cfelse>
	<cfset get_bank_order.recordcount=0>
</cfif>
<cfquery name="control_paper_no" datasource="#dsn2#">
	SELECT PAPER_NO FROM BANK_ACTIONS WHERE PAPER_NO = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.paper_number#"> AND ACTION_ID <> #attributes.id#
</cfquery>
<cfif control_paper_no.recordcount>
	<script type="text/javascript">
		alert("<cf_get_lang no ='401.Aynı Belge No İle Kayıtlı Gelen Havale İşlemi Var'>!");
		history.back();	
	</script>
	<cfabort>
</cfif>

<!--- firmanin muhasebe kodu --->
<cfif is_account eq 1 and get_bank_order.recordcount neq 0 and assign_order_account eq 1 and len(get_bank_order.ACCOUNT_ORDER_CODE)> <!--- Banka Talimatı Muhasebe Kodu --->
	<cfset MY_ACC_RESULT = get_bank_order.ACCOUNT_ORDER_CODE> <!--- banka talimatının muhasebe işleminde kullanılan talimat hesabı --->
<cfelseif is_account eq 1>
	<cfif len(attributes.employee_id)><!--- çalışanın muhasebe kodu--->
		<cfset MY_ACC_RESULT = GET_EMPLOYEE_PERIOD(attributes.employee_id,attributes.acc_type_id)>
	<cfelseif len(ACTION_FROM_COMPANY_ID)><!--- firmanın muhasebe kodu --->
		<cfset MY_ACC_RESULT=GET_COMPANY_PERIOD(company_id:ACTION_FROM_COMPANY_ID,acc_type_id:len(is_account_type_id) ? is_account_type_id : "")>
	<cfelse><!--- bireysel uyenin muhasebe kodu--->
		<cfset MY_ACC_RESULT = GET_CONSUMER_PERIOD(consumer_id:ACTION_FROM_CONSUMER_ID,acc_type_id:len(is_account_type_id) ? is_account_type_id : "")>
	</cfif>
	<cfif not len(MY_ACC_RESULT)>
		<script type="text/javascript">
			alert("<cf_get_lang no ='393.Seçtiğiniz Üyenin Muhasebe Kodu Seçilmemiş'>!");
			history.back();	
		</script>
		<cfabort>
	</cfif>
</cfif>
<cfif not len(attributes.masraf)>
	<cfset attributes.masraf = 0>
</cfif>
<cf_date tarih='attributes.ACTION_DATE'>
<cflock name="#createUUID()#" timeout="20">
	<cftransaction>
		<cfquery name="UPD_GELENH" datasource="#dsn2#">
			UPDATE
				BANK_ACTIONS
			SET
				PROCESS_CAT = #form.process_cat#,
				ACTION_VALUE = #attributes.ACTION_VALUE#,
				ACTION_DATE = #attributes.ACTION_DATE#,
				ACTION_CURRENCY_ID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.currency_id#">,
				PROJECT_ID = <cfif len(attributes.project_head) and len(attributes.project_id)>#attributes.project_id#<cfelse>NULL</cfif>,
				ACTION_DETAIL = <cfif len(attributes.ACTION_DETAIL)><cfqueryparam cfsqltype="cf_sql_varchar" value="#ACTION_DETAIL#"><cfelse>NULL</cfif>,
				ACTION_FROM_COMPANY_ID = <cfif len(ACTION_FROM_COMPANY_ID) and (len(attributes.employee_id) EQ 0)>#ACTION_FROM_COMPANY_ID#<cfelse>NULL</cfif>,
				ACTION_FROM_EMPLOYEE_ID = <cfif len(attributes.employee_id)>#attributes.employee_id#<cfelse>NULL</cfif>,
				ACTION_FROM_CONSUMER_ID = <cfif len(ACTION_FROM_CONSUMER_ID)>#ACTION_FROM_CONSUMER_ID#<cfelse>NULL</cfif>,
				ACTION_TO_ACCOUNT_ID = #attributes.account_id#,
				OTHER_CASH_ACT_VALUE= <cfif len(attributes.OTHER_CASH_ACT_VALUE)>#attributes.OTHER_CASH_ACT_VALUE#<cfelse>NULL</cfif>,
				OTHER_MONEY = <cfif len(money_type)><cfqueryparam cfsqltype="cf_sql_varchar" value="#money_type#"><cfelse>NULL</cfif>,
				IS_ACCOUNT = <cfif is_account eq 1>1<cfelse>0</cfif>,
				IS_ACCOUNT_TYPE = 13,
				PAPER_NO = <cfif isdefined("attributes.paper_number") and len(attributes.paper_number)><cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.paper_number#"><cfelse>NULL</cfif>,
				MASRAF = <cfif len(attributes.masraf)>#attributes.masraf#<cfelse>0</cfif>,
				TO_BRANCH_ID = #branch_id_info#,
				SUBSCRIPTION_ID = <cfif isdefined("attributes.subscription_id") and len(attributes.subscription_id) and len(attributes.subscription_no)>#attributes.subscription_id#<cfelse>NULL</cfif>,
				ASSETP_ID = <cfif isdefined("attributes.asset_id") and len(attributes.asset_id) and len(attributes.asset_name)>#attributes.asset_id#<cfelse>NULL</cfif>,
				SPECIAL_DEFINITION_ID = <cfif isdefined("attributes.special_definition_id") and len(attributes.special_definition_id)>#attributes.special_definition_id#<cfelse>NULL</cfif>,
				EXPENSE_CENTER_ID = <cfif isdefined("attributes.expense_center_id") and len(attributes.expense_center_id) and len(attributes.expense_center_name)>#attributes.expense_center_id#<cfelse>NULL</cfif>,
				EXPENSE_ITEM_ID = <cfif isdefined("attributes.expense_item_id") and len(attributes.expense_item_id) and len(attributes.expense_item_name)>#attributes.expense_item_id#<cfelse>NULL</cfif>,
				UPDATE_EMP = #SESSION.EP.USERID#,
				UPDATE_IP = <cfqueryparam cfsqltype="cf_sql_varchar" value="#CGI.REMOTE_ADDR#">,
				UPDATE_DATE = #now()#,
				SYSTEM_ACTION_VALUE = #wrk_round((attributes.ACTION_VALUE)*dovizli_islem_multiplier)#,
				SYSTEM_CURRENCY_ID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#session.ep.money#">,
				ACC_DEPARTMENT_ID = <cfif isdefined("attributes.acc_department_id") and len(attributes.acc_department_id)>#attributes.acc_department_id#<cfelse>NULL</cfif>,
				ACC_TYPE_ID = <cfif isdefined("attributes.acc_type_id") and len(attributes.acc_type_id)>#attributes.acc_type_id#<cfelse>NULL</cfif>
				<cfif len(session.ep.money2)>
					,ACTION_VALUE_2 = #wrk_round(((attributes.ACTION_VALUE)*dovizli_islem_multiplier)/currency_multiplier,4)#
					,ACTION_CURRENCY_ID_2 = <cfqueryparam cfsqltype="cf_sql_varchar" value="#session.ep.money2#">
				</cfif>
				<cfif isDefined('attributes.process_stage')>
					,PROCESS_STAGE = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.process_stage#">
				</cfif>
			WHERE
				ACTION_ID = #attributes.id#
		</cfquery>
        <cfif isdefined('UPD_GELENH')><cfdump var="#UPD_GELENH#"></cfif>
		<cfscript>
			//masraf kaydını siler
			butce_sil(action_id:attributes.id,process_type:form.old_process_type);
			
			if (is_cari eq 1)
			{
				carici(
					action_id : attributes.id,
					workcube_process_type : process_type,	
					workcube_old_process_type : form.old_process_type,	
					islem_belge_no : attributes.paper_number,
					action_table : 'BANK_ACTIONS',			
					process_cat : form.process_cat,
					islem_tarihi : attributes.action_date,				
					to_account_id : attributes.account_id,			
					islem_tutari : attributes.system_amount,
					action_currency : session.ep.money,
					other_money_value : iif(len(attributes.OTHER_CASH_ACT_VALUE),'attributes.OTHER_CASH_ACT_VALUE',de('')),
					other_money : form.money_type,
					currency_multiplier : currency_multiplier,
					islem_detay : ACTION_TYPE,					
					action_detail : attributes.action_detail,
					account_card_type : 13,
					acc_type_id : attributes.acc_type_id,
					due_date: attributes.action_date,
					from_employee_id : attributes.employee_id,
					from_cmp_id : ACTION_FROM_COMPANY_ID,
					from_consumer_id : ACTION_FROM_CONSUMER_ID,
					project_id : iif((len(attributes.project_id) and len(attributes.project_head)),attributes.project_id,de('')),
					subscription_id : iif((isdefined("attributes.subscription_id") and len(attributes.subscription_id) and len(attributes.subscription_no)),attributes.subscription_id,de('')),
					special_definition_id : iif((isdefined("attributes.special_definition_id") and len(attributes.special_definition_id)),'attributes.special_definition_id',de('')),
					to_branch_id : branch_id_info,
					assetp_id : iif((isdefined("attributes.asset_id") and len(attributes.asset_id) and len(attributes.asset_name)),'attributes.asset_id',de('')),
					rate2:paper_currency_multiplier
					);
			}
			else
				cari_sil(action_id:attributes.id,process_type:form.old_process_type);
			
			if(len(attributes.expense_item_id) and len(attributes.expense_item_name) and (attributes.masraf gt 0) and len(attributes.expense_center_id) and len(attributes.expense_center_name))
			{
				if(attributes.currency_id is session.ep.money)
				{
					butceci(
						action_id : attributes.id,
						muhasebe_db : dsn2,
						is_income_expense : false,
						process_type : process_type,
						nettotal : attributes.masraf,
						other_money_value : wrk_round(attributes.masraf/paper_currency_multiplier),
						action_currency : form.money_type,
						currency_multiplier : currency_multiplier,
						expense_date : attributes.action_date,
						expense_center_id : attributes.expense_center_id,
						expense_item_id : attributes.expense_item_id,
						detail : UCase(getLang('main',2721)),//GELEN HAVALE MASRAFI
						paper_no : attributes.paper_number,
						project_id : iif((len(attributes.project_id) and len(attributes.project_head)),attributes.project_id,de('')),
						company_id : ACTION_FROM_COMPANY_ID,
						consumer_id : ACTION_FROM_CONSUMER_ID,
						employee_id : attributes.employee_id,
						branch_id : branch_id_info,
						insert_type : 1
					);
				}
				else
				{				
					butceci(
						action_id : attributes.id,
						muhasebe_db : dsn2,
						is_income_expense : false,
						process_type : process_type,
						nettotal : wrk_round(attributes.masraf*dovizli_islem_multiplier),
						other_money_value : attributes.masraf,
						action_currency : attributes.currency_id,
						currency_multiplier : currency_multiplier,
						expense_date : attributes.action_date,
						expense_center_id : attributes.expense_center_id,
						expense_item_id : attributes.expense_item_id,
						detail : UCase(getLang('main',2721)),//GELEN HAVALE MASRAFI
						paper_no : attributes.paper_number,
						project_id : iif((len(attributes.project_id) and len(attributes.project_head)),attributes.project_id,de('')),
						company_id : ACTION_FROM_COMPANY_ID,
						consumer_id : ACTION_FROM_CONSUMER_ID,
						employee_id : attributes.employee_id,
						branch_id : branch_id_info,
						insert_type : 1
					);
				}
				GET_EXP_ACC = cfquery(datasource : "#dsn2#", sqlstring : "SELECT ACCOUNT_CODE FROM EXPENSE_ITEMS WHERE EXPENSE_ITEM_ID = #attributes.expense_item_id#");
			}
				
			if(is_account eq 1)
			{
				if(len(attributes.comp_name))
					member_name_='#attributes.comp_name#';
				else
					member_name_='#attributes.emp_name#';
			
				if(isDefined("attributes.ACTION_DETAIL") and len(attributes.ACTION_DETAIL))
					str_card_detail = '#member_name_#-#attributes.ACTION_DETAIL#';
				else if(attributes.currency_id is session.ep.money)
					str_card_detail = '#member_name_#-' & UCase(getLang('main',422));
				else
					str_card_detail = '#member_name_#-' & UCase(getLang('main',2723));

				if(isdefined('attributes.acc_department_id') and len(attributes.acc_department_id) )
					acc_department_id = attributes.acc_department_id;
				else
					acc_department_id = '';
				
				str_borclu_hesaplar = attributes.ACCOUNT_ACC_CODE;
				str_alacakli_hesaplar = MY_ACC_RESULT;
				str_tutarlar = attributes.system_amount;
				
				str_borclu_other_amount_tutar = attributes.ACTION_VALUE;
				str_borclu_other_currency = form.currency_id;
				str_alacakli_other_amount_tutar = attributes.OTHER_CASH_ACT_VALUE;
				str_alacakli_other_currency = form.money_type;
				
				if(len(attributes.masraf) and attributes.masraf gt 0 and len(GET_EXP_ACC.ACCOUNT_CODE))
				{
					str_borclu_hesaplar = ListAppend(str_borclu_hesaplar,GET_EXP_ACC.ACCOUNT_CODE,",");	
					str_alacakli_hesaplar = ListAppend(str_alacakli_hesaplar,attributes.account_acc_code,",");	
					if(attributes.currency_id is session.ep.money)
						str_tutarlar = ListAppend(str_tutarlar,attributes.masraf,",");
					else
						str_tutarlar = ListAppend(str_tutarlar,wrk_round(attributes.masraf*dovizli_islem_multiplier),",");
					str_borclu_other_amount_tutar = ListAppend(str_borclu_other_amount_tutar,attributes.masraf,",");
					str_borclu_other_currency = ListAppend(str_borclu_other_currency,attributes.currency_id,",");
					str_alacakli_other_amount_tutar = ListAppend(str_alacakli_other_amount_tutar,attributes.masraf,",");
					str_alacakli_other_currency = ListAppend(str_alacakli_other_currency,attributes.currency_id,",");
				}
							
				muhasebeci (
					action_id:attributes.id,
					workcube_process_type:process_type,
					workcube_old_process_type:form.old_process_type,
					workcube_process_cat:form.process_cat,
					acc_department_id : acc_department_id,
					account_card_type:13,
					company_id: attributes.ACTION_FROM_COMPANY_ID,
					consumer_id:attributes.ACTION_FROM_CONSUMER_ID,
					islem_tarihi:attributes.ACTION_DATE,
					fis_satir_detay:str_card_detail,
					borc_hesaplar: str_borclu_hesaplar,
					borc_tutarlar: str_tutarlar,
					other_amount_borc : str_borclu_other_amount_tutar,
					other_currency_borc : str_borclu_other_currency,
					alacak_hesaplar: str_alacakli_hesaplar,
					alacak_tutarlar: str_tutarlar,
					other_amount_alacak : str_alacakli_other_amount_tutar,
					other_currency_alacak : str_alacakli_other_currency,
					currency_multiplier : currency_multiplier,
					acc_project_id : iif((len(attributes.project_id) and len(attributes.project_head)),attributes.project_id,de('')),
					fis_detay : UCase(getLang('main',422)),
					belge_no : attributes.paper_number,
					to_branch_id : branch_id_info 
				);
			}
			else
				muhasebe_sil(action_id:attributes.id,process_type:form.old_process_type);
				
			f_kur_ekle_action(action_id:attributes.id,process_type:1,action_table_name:'BANK_ACTION_MONEY',action_table_dsn:'#dsn2#');
		</cfscript>
		<!--- onay ve uyarıların gelebilmesi icin action file sarti kaldirildi --->
        <cf_workcube_process_cat 
            process_cat="#form.process_cat#"
            old_process_cat_id = "#attributes.old_process_cat_id#"
            action_id = #attributes.id#
            is_action_file = 1
            action_db_type = '#dsn2#'
            action_page='#request.self#?fuseaction=bank.form_add_gelenh&event=upd&id=#attributes.id#'
            action_file_name='#get_process_type.action_file_name#'
            is_template_action_file = '#get_process_type.action_file_from_template#'>
			<cfif isDefined('attributes.process_stage')>
				<cf_workcube_process
					is_upd='1' 
					data_source='#dsn2#'
					old_process_line='#attributes.old_process_line#'
					process_stage='#attributes.process_stage#'
					record_member='#session.ep.userid#'
					record_date='#now()#'
					action_table='BANK_ACTIONS'
					action_column='ACTION_ID'
					action_id='#attributes.id#'
					action_page='#request.self#?fuseaction=bank.form_add_gelenh&event=upd&id=#attributes.id#'
					warning_description='Gelen Havale : #attributes.id#'>
			</cfif>
            <cf_add_log employee_id="#session.ep.userid#" log_type="0" action_id="#attributes.id#" action_name= "Gelen Havale Güncellendi" paper_no= "#attributes.paper_number#" period_id="#session.ep.period_id#" process_type="#get_process_type.PROCESS_TYPE#" data_source="#dsn2#">
	</cftransaction>
</cflock>
<cfquery name="get_closed_id" datasource="#dsn2#">
	SELECT CLOSED_ID FROM CARI_CLOSED_ROW WHERE ACTION_ID = #attributes.id# AND ACTION_TYPE_ID = #process_type#
</cfquery>
<cfset attributes.actionID = attributes.id>
<script type="text/javascript">
	<cfif session.ep.our_company_info.is_paper_closer eq 1 and (len(attributes.ACTION_FROM_COMPANY_ID) or len(attributes.ACTION_FROM_CONSUMER_ID) or len(attributes.employee_id))>
		<cfif get_closed_id.recordcount gt 0>
			window.open('<cfoutput>#request.self#?fuseaction=finance.upd_payment_actions&closed_id=#get_closed_id.closed_id#&act_type=1</cfoutput>','page');
		<cfelse>
			window.open('<cfoutput>#request.self#?fuseaction=finance.list_payment_actions&event=add&act_type=1&member_id=#attributes.ACTION_FROM_COMPANY_ID#&consumer_id=#attributes.ACTION_FROM_CONSUMER_ID#&employee_id_new=#attributes.employee_id#&acc_type_id=#attributes.acc_type_id#&money_type=#form.money_type#&row_action_id=#attributes.id#&row_action_type=#process_type#</cfoutput>','page');
		</cfif>			
	</cfif>
	window.location.href='<cfoutput>#request.self#?fuseaction=bank.form_add_gelenh&event=upd&id=#attributes.id#</cfoutput>';
</script>
<cf_get_lang_set module_name="#lcase(listgetat(attributes.fuseaction,1,'.'))#">
