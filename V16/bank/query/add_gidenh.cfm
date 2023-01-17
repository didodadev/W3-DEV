<cf_get_lang_set module_name="bank">
<cfif form.active_period neq session.ep.period_id>
	<script type="text/javascript">
		alert("<cf_get_lang_main no='1659.İşlem Yapmak İstediğiniz Muhasebe Dönemi ile Aktif Muhasebe Döneminiz Farklı Muhasebe Döneminizi Kontrol Ediniz'>");
		window.location.href='<cfoutput>#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.list_bank_actions</cfoutput>';
	</script>
	<cfabort>
</cfif>
<!--- banka talimati process type ile karsilastirma yapiliyor --->
<cfquery name="get_process_type" datasource="#dsn3#">
	SELECT 
		PROCESS_TYPE,
		IS_CARI,
		IS_ACCOUNT,
		IS_ACCOUNT_GROUP,
		ACTION_FILE_NAME,
		ACTION_FILE_FROM_TEMPLATE,
		ACCOUNT_TYPE_ID
	 FROM 
	 	SETUP_PROCESS_CAT 
	WHERE 
		PROCESS_CAT_ID = #form.process_cat#
</cfquery>
<cfquery name="control_paper_no" datasource="#dsn2#">
	SELECT PAPER_NO FROM BANK_ACTIONS WHERE PAPER_NO = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.paper_number#">
</cfquery>
<cfif control_paper_no.recordcount>
	<cfif not isdefined('xml_import')>
		<script type="text/javascript">
			alert("Aynı Belge No İle Kayıtlı Giden Havale İşlemi Var!");
			history.back();	
		</script>
		<cfabort>
	<cfelse>
		Aynı Belge No İle Kayıtlı Giden Havale İşlemi Var!<br/>
	</cfif>
</cfif>
<cfscript>
	process_type = get_process_type.PROCESS_TYPE;
	is_cari = get_process_type.IS_CARI;
	is_account = get_process_type.IS_ACCOUNT;
	is_account_group = get_process_type.IS_ACCOUNT_GROUP;
	is_account_type_id = get_process_type.ACCOUNT_TYPE_ID;
	if(not isdefined('xml_import'))
	{
		attributes.ACTION_VALUE = filterNum(attributes.ACTION_VALUE);
		attributes.OTHER_CASH_ACT_VALUE = filterNum(attributes.OTHER_CASH_ACT_VALUE);
		attributes.system_amount = filterNum(attributes.system_amount);
		attributes.masraf = filterNum(attributes.masraf);
		for(a_sy = 1; a_sy lte attributes.kur_say; a_sy = a_sy + 1)
		{
			'attributes.txt_rate1_#a_sy#' = filterNum(evaluate('attributes.txt_rate1_#a_sy#'),session.ep.our_company_info.rate_round_num);
			'attributes.txt_rate2_#a_sy#' = filterNum(evaluate('attributes.txt_rate2_#a_sy#'),session.ep.our_company_info.rate_round_num);
		}
	}
	if(isdefined("attributes.branch_id") and len(attributes.branch_id))
		branch_id_info = attributes.branch_id;
	else
		branch_id_info = listgetat(session.ep.user_location,2,'-');
	
	/*if (session.ep.our_company_info.project_followup neq 1)
	{
		attributes.project_id = "";
		attributes.project_head = "";
	}*/

	currency_multiplier = '';
	if(isDefined('attributes.kur_say') and len(attributes.kur_say))
		for(mon=1;mon lte attributes.kur_say;mon=mon+1)
		{
			if(evaluate("attributes.hidden_rd_money_#mon#") is session.ep.money2)
				currency_multiplier = evaluate('attributes.txt_rate2_#mon#/attributes.txt_rate1_#mon#');
			if(evaluate("attributes.hidden_rd_money_#mon#") is form.money_type)
				masraf_curr_multiplier = evaluate('attributes.txt_rate2_#mon#/attributes.txt_rate1_#mon#');
			if(evaluate("attributes.hidden_rd_money_#mon#") is attributes.currency_id)
				dovizli_islem_multiplier = evaluate('attributes.txt_rate2_#mon#/attributes.txt_rate1_#mon#');
		}	
	attributes.acc_type_id = '';
	if(listlen(attributes.employee_id,'_') eq 2)
	{
		attributes.acc_type_id = listlast(attributes.employee_id,'_');
		attributes.employee_id = listfirst(attributes.employee_id,'_');
	}	
</cfscript>
<cfif len(form.bank_order_process_cat)>
	<cfquery name="get_bank_order_process_type" datasource="#dsn3#">
		SELECT 
			PROCESS_TYPE,
			IS_CARI,
			IS_ACCOUNT
		 FROM 
			SETUP_PROCESS_CAT 
		WHERE 
			PROCESS_CAT_ID = #form.bank_order_process_cat#
	</cfquery>
	<cfset assign_order_process_type = get_bank_order_process_type.PROCESS_TYPE>
	<cfset assign_order_cari = get_bank_order_process_type.IS_CARI>
	<cfset assign_order_account = get_bank_order_process_type.IS_ACCOUNT>
	<cfif ((assign_order_cari eq 1) and (is_cari eq 1)) or ((assign_order_account eq 1) and (is_account eq 0))>
		<cfif not isdefined('xml_import')>
			<script type="text/javascript">
				alert("<cf_get_lang no ='399.İşlem Kategorilerinizi Kontrol Ediniz'>!");
				window.location.href='<cfoutput>#cgi.referer#</cfoutput>';
			</script>
		<cfelse>
			Banka Havale işlemi için İşlem kategorilerinizi Kontrol Ediniz!<br/>
		</cfif>
		<cfabort>
	</cfif>
<cfelse>
	<cfset assign_order_cari = "">
	<cfset assign_order_account = "">
</cfif>
<cfif (is_account eq 1) and len(form.acc_order_code) and (assign_order_account eq 1)><!--- Banka Talimatı Muhasebe Kodu --->
	<cfset MY_ACC_RESULT = form.acc_order_code>
<cfelseif is_account eq 1>
	<cfif len(attributes.employee_id)><!--- çalışanın muhasebe kodu--->
		<cfset MY_ACC_RESULT = GET_EMPLOYEE_PERIOD(attributes.employee_id,attributes.acc_type_id)>
	<cfelseif len(form.ACTION_TO_COMPANY_ID)><!--- firmanın muhasebe kodu --->
		<cfset MY_ACC_RESULT = GET_COMPANY_PERIOD(company_id:form.ACTION_TO_COMPANY_ID,acc_type_id:len(is_account_type_id) ? is_account_type_id : "")>
	<cfelseif len(form.ACTION_TO_CONSUMER_ID)><!---bireysel uyenin muhasebe kodu--->
		<cfset MY_ACC_RESULT = GET_CONSUMER_PERIOD(consumer_id:form.ACTION_TO_CONSUMER_ID,acc_type_id:len(is_account_type_id) ? is_account_type_id : "")>
	</cfif>
	<cfif not len(MY_ACC_RESULT)>
		<cfif not isdefined('xml_import')>
			<script type="text/javascript">
				alert("<cf_get_lang no ='402.Seçtiğiniz Çalışan veya Üyenin Muhasebe Kodu Seçilmemiş'>!");
				history.back();	
			</script>
			<cfabort>
		<cfelse>
			Seçtiğiniz Çalışan veya Üyenin Muhasebe Kodu Seçilmemiş!<br/>
		</cfif>
	</cfif>
</cfif>
<cf_date tarih='attributes.ACTION_DATE'>
<cf_papers paper_type="outgoing_transfer">
<cfif not len(attributes.masraf)>
	<cfset attributes.masraf = 0>
</cfif>
<cflock name="#createUUID()#" timeout="60">
	<cftransaction>
		<cfquery name="ADD_GIDENH" datasource="#DSN2#" result="MAX_ID">
			INSERT INTO
				BANK_ACTIONS
			(
				BANK_ORDER_ID,
				ACTION_TYPE,
				PROCESS_CAT,
				ACTION_TYPE_ID,
				ACTION_FROM_ACCOUNT_ID,
				ACTION_TO_COMPANY_ID,
				ACTION_TO_EMPLOYEE_ID,
				ACTION_TO_CONSUMER_ID,
				ACTION_VALUE,
				ACTION_DATE,
				ACTION_CURRENCY_ID,
				PROJECT_ID,
				ACTION_DETAIL,
				OTHER_CASH_ACT_VALUE,
				OTHER_MONEY,
				IS_ACCOUNT,
				IS_ACCOUNT_TYPE,
				PAPER_NO,
				MASRAF,
				RECORD_EMP,
				RECORD_IP,
				RECORD_DATE,
				FROM_BRANCH_ID,
				ASSETP_ID,
				SUBSCRIPTION_ID,
				SPECIAL_DEFINITION_ID,
				EXPENSE_CENTER_ID,
				EXPENSE_ITEM_ID,
				SYSTEM_ACTION_VALUE,
				SYSTEM_CURRENCY_ID,
				ACC_DEPARTMENT_ID,
				ACC_TYPE_ID
				<cfif len(session.ep.money2)>
					,ACTION_VALUE_2
					,ACTION_CURRENCY_ID_2
				</cfif>
				<cfif isDefined('attributes.process_stage')>
					,PROCESS_STAGE
				</cfif>
			)
			VALUES
			(
				<cfif len(attributes.bank_order_id)>#attributes.bank_order_id#<cfelse>NULL</cfif>,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#ACTION_TYPE#">,
				#form.process_cat#,
				#process_type#,
				#attributes.account_id#,
				<cfif len(ACTION_TO_COMPANY_ID) and (len(attributes.employee_id) eq 0)>#ACTION_TO_COMPANY_ID#<cfelse>NULL</cfif>,
				<cfif len(attributes.employee_id)>#attributes.employee_id#<cfelse>NULL</cfif>,
				<cfif len(ACTION_TO_CONSUMER_ID)>#ACTION_TO_CONSUMER_ID#<cfelse>NULL</cfif>,
				<cfif len(attributes.masraf)>#attributes.ACTION_VALUE + attributes.masraf#<cfelse>#attributes.ACTION_VALUE#</cfif>,
				<!--- banka işlemlerinde masraflı tutar yansıması için --->
				#attributes.ACTION_DATE#,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.currency_id#">,
				<cfif len(attributes.project_head) and len(attributes.project_id)>#attributes.project_id#<cfelse>NULL</cfif>,
				<cfif isDefined("attributes.ACTION_DETAIL") and len(attributes.ACTION_DETAIL)><cfqueryparam cfsqltype="cf_sql_varchar" value="#ACTION_DETAIL#"><cfelse>NULL</cfif>,
				<cfif len(attributes.OTHER_CASH_ACT_VALUE)>#attributes.OTHER_CASH_ACT_VALUE#<cfelse>NULL</cfif>,
				<cfif len(money_type)><cfqueryparam cfsqltype="cf_sql_varchar" value="#money_type#"><cfelse>NULL</cfif>,
				<cfif is_account eq 1>1,13,<cfelse>0,13,</cfif>
				<cfif isdefined("attributes.paper_number") and len(attributes.paper_number)><cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.paper_number#"><cfelse>NULL</cfif>,
				<cfif len(attributes.masraf)>#attributes.masraf#<cfelse>0</cfif>,
				#SESSION.EP.USERID#,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#CGI.REMOTE_ADDR#">,
				#NOW()#,
				#branch_id_info#,
				<cfif isdefined("attributes.asset_id") and len(attributes.asset_id) and len(attributes.asset_name)>#attributes.asset_id#<cfelse>NULL</cfif>,
				<cfif isdefined("attributes.subscription_id") and len(attributes.subscription_id) and len(attributes.subscription_no)>#attributes.subscription_id#<cfelse>NULL</cfif>,
				<cfif isdefined("attributes.special_definition_id") and len(attributes.special_definition_id)>#attributes.special_definition_id#<cfelse>NULL</cfif>,
				<cfif isdefined("attributes.expense_center_id") and len(attributes.expense_center_id) and len(attributes.expense_center_name)>#attributes.expense_center_id#<cfelse>NULL</cfif>,
				<cfif isdefined("attributes.expense_item_id") and len(attributes.expense_item_id) and len(attributes.expense_item_name)>#attributes.expense_item_id#<cfelse>NULL</cfif>,
				#wrk_round((attributes.ACTION_VALUE + attributes.masraf)*dovizli_islem_multiplier)#,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#session.ep.money#">,
				<cfif isdefined("attributes.acc_department_id") and len(attributes.acc_department_id)>#attributes.acc_department_id#<cfelse>NULL</cfif>,
				<cfif isdefined("attributes.acc_type_id") and len(attributes.acc_type_id)>#attributes.acc_type_id#<cfelse>NULL</cfif>
				<cfif len(session.ep.money2)>
					,#wrk_round(((attributes.ACTION_VALUE + attributes.masraf)*dovizli_islem_multiplier)/currency_multiplier,4)#
					,<cfqueryparam cfsqltype="cf_sql_varchar" value="#session.ep.money2#">
				</cfif>
				<cfif isDefined('attributes.process_stage')>
					,<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.process_stage#">
				</cfif>
			)
		</cfquery>
		<cfif assign_order_cari eq 1>
			<cfquery name="upd_cari" datasource="#DSN2#">
				UPDATE
					CARI_ROWS
				SET 
					IS_PROCESSED = 1
				WHERE 
					ACTION_ID = #attributes.bank_order_id# AND
					ACTION_TYPE_ID = #assign_order_process_type#
			</cfquery>
		</cfif>
		<cfscript>
		if(is_cari eq 1)
		{
			carici (
				action_id : MAX_ID.IDENTITYCOL,
				action_table : 'BANK_ACTIONS',
				islem_belge_no : attributes.paper_number,
				workcube_process_type :process_type,		
				process_cat : form.process_cat,	
				islem_tarihi : attributes.ACTION_DATE,
				from_account_id : attributes.account_id,
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
				to_employee_id : attributes.employee_id,
				to_cmp_id : ACTION_TO_COMPANY_ID,
				to_consumer_id : ACTION_TO_CONSUMER_ID,
				project_id : attributes.project_id,
				subscription_id : iif((isdefined("attributes.subscription_id") and len(attributes.subscription_id) and len(attributes.subscription_no)),attributes.subscription_id,de('')),
				from_branch_id : branch_id_info,
				expense_center_id : iif((isdefined("attributes.expense_center_id") and len(attributes.expense_center_id) and len(attributes.expense_center_name)),'attributes.expense_center_id',de('')),
				expense_item_id : iif((isdefined("attributes.expense_item_id") and len(attributes.expense_item_id) and len(attributes.expense_item_name)),'attributes.expense_item_id',de('')),
				special_definition_id : iif((isdefined("attributes.special_definition_id") and len(attributes.special_definition_id)),'attributes.special_definition_id',de('')),
				assetp_id : iif((isdefined("attributes.asset_id") and len(attributes.asset_id) and len(attributes.asset_name)),'attributes.asset_id',de('')),
				rate2:masraf_curr_multiplier
				);
		}
		if(len(attributes.expense_item_id) and len(attributes.expense_item_name) and (attributes.masraf gt 0) and len(attributes.expense_center_id) and len(attributes.expense_center_name))
		{
			if(attributes.currency_id is session.ep.money)
			{
				butceci(
					action_id : MAX_ID.IDENTITYCOL,
					muhasebe_db : dsn2,
					is_income_expense : false,
					process_type : process_type,
					nettotal : attributes.masraf,
					other_money_value : wrk_round(attributes.masraf/masraf_curr_multiplier),
					action_currency : form.money_type,
					currency_multiplier : currency_multiplier,
					expense_date : attributes.action_date,
					expense_center_id : attributes.expense_center_id,
					expense_item_id : attributes.expense_item_id,
					detail : UCase(getLang('main',2608)),//GİDEN HAVALE MASRAFI
					paper_no : attributes.paper_number,
					project_id : attributes.project_id,
					company_id : ACTION_TO_COMPANY_ID,
					consumer_id : ACTION_TO_CONSUMER_ID,
					employee_id : attributes.employee_id,
					branch_id : branch_id_info,
					insert_type : 1//banka vs den eklenen masraflar için farklı ekleme metodu tanımlar
				);
			}
			else
			{
				butceci(
					action_id : MAX_ID.IDENTITYCOL,
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
					detail : UCase(getLang('main',2608)),//GİDEN HAVALE MASRAFI
					paper_no : attributes.paper_number,
					project_id : attributes.project_id,
					company_id : ACTION_TO_COMPANY_ID,
					consumer_id : ACTION_TO_CONSUMER_ID,
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
				str_card_detail = '#member_name_#-' & UCase(getLang('main',423));//GİDEN HAVALE
			else
				str_card_detail = '#member_name_#-' & UCase(getLang('main',2609));//DÖVİZLİ GİDEN HAVALE
			
			str_borclu_hesaplar = MY_ACC_RESULT;
			str_alacakli_hesaplar = attributes.account_acc_code;
			str_tutarlar = attributes.system_amount;
			
			if(len(form.acc_order_code) and (assign_order_account eq 1))//talimattan havale oluştrmak için
			{
				str_borclu_other_amount_tutar = attributes.ACTION_VALUE;
				str_borclu_other_currency = attributes.currency_id;
			}
			else
			{
				str_borclu_other_amount_tutar = attributes.OTHER_CASH_ACT_VALUE;
				str_borclu_other_currency = form.money_type;
			}
			str_alacakli_other_amount_tutar = attributes.ACTION_VALUE;
			str_alacakli_other_currency = attributes.currency_id;
			
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
			
			if(isdefined('attributes.acc_department_id') and len(attributes.acc_department_id) )
				acc_department_id = attributes.acc_department_id;
			else
				acc_department_id = '';
				
			muhasebeci (
				action_id:MAX_ID.IDENTITYCOL,
				workcube_process_type:process_type,
				workcube_process_cat:form.process_cat,
				acc_department_id : acc_department_id,
				account_card_type:13,
				company_id: attributes.ACTION_TO_COMPANY_ID,
				consumer_id:attributes.ACTION_TO_CONSUMER_ID,
				islem_tarihi : attributes.ACTION_DATE,
				belge_no : attributes.paper_number,
				fis_satir_detay : str_card_detail,
				borc_hesaplar : str_borclu_hesaplar,
				borc_tutarlar : str_tutarlar,
				other_amount_borc : str_borclu_other_amount_tutar,
				other_currency_borc : str_borclu_other_currency,
				alacak_hesaplar : str_alacakli_hesaplar,
				alacak_tutarlar : str_tutarlar,
				other_amount_alacak : str_alacakli_other_amount_tutar,
				other_currency_alacak : str_alacakli_other_currency,
				currency_multiplier : currency_multiplier,
				is_account_group : is_account_group,
				fis_detay : UCase(getLang('main',423)),
				from_branch_id : branch_id_info,
				acc_project_id : attributes.project_id,
				is_abort : iif(isdefined('xml_import'),0,1)
			);			
		}
		f_kur_ekle_action(action_id:MAX_ID.IDENTITYCOL,process_type:0,action_table_name:'BANK_ACTION_MONEY',action_table_dsn:'#dsn2#');
		</cfscript>
		<cfif not isdefined('xml_import')>
			<!--- Belge No update ediliyor --->
			<cfif Len(paper_number)>
				<cfquery name="UPD_GENERAL_PAPERS" datasource="#DSN2#">
					UPDATE 
						#dsn3_alias#.GENERAL_PAPERS
					SET
						OUTGOING_TRANSFER_NUMBER = #paper_number#
					WHERE
						OUTGOING_TRANSFER_NUMBER IS NOT NULL
				</cfquery>
			</cfif>
		</cfif>
		<cfif isdefined("attributes.order_id") and len(attributes.order_id) and is_cari and isdefined("attributes.order_row_id") and len(attributes.order_row_id)><!--- ödeme emirlerinden ödeme yapıldıgnda.. --->
			<cfquery name="GET_CARI_INFO" datasource="#dsn2#">
				SELECT 
					*
				FROM 
					CARI_ROWS 
				WHERE 
					ACTION_ID = #MAX_ID.IDENTITYCOL# AND 
					ACTION_TYPE_ID = #process_type#
			</cfquery>
			<cfif len(GET_CARI_INFO.recordcount) and (isDefined("attributes.correspondence_info") and len(attributes.correspondence_info))>
				<cfquery name="GET_CLOSED" datasource="#dsn2#">
					SELECT P_ORDER_DEBT_AMOUNT_VALUE,P_ORDER_CLAIM_AMOUNT_VALUE FROM CARI_CLOSED WHERE CLOSED_ID = #attributes.order_id#
				</cfquery>
				<cfquery name="UPD_CLOSED" datasource="#dsn2#">
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
				<cfquery name="UPD_CLOSED" datasource="#dsn2#">
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
				<cfquery name="UPD_CLOSED" datasource="#dsn2#">
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
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.money_type#">,
						#attributes.action_date#
					)
				</cfquery>
				<cfif isdefined("attributes.order_row_id") and len(attributes.order_row_id)>
					<cfquery name="GET_MAX_C_ID" datasource="#DSN2#">
						SELECT MAX(CLOSED_ROW_ID) C_MAX_ID FROM CARI_CLOSED_ROW
					</cfquery>
					<cfquery name="GET_CLOSED" datasource="#dsn2#">
						SELECT P_ORDER_DEBT_AMOUNT_VALUE,P_ORDER_CLAIM_AMOUNT_VALUE FROM CARI_CLOSED WHERE CLOSED_ID = #attributes.order_id#
					</cfquery>
					<cfquery name="UPD_CLOSED" datasource="#dsn2#">
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
					<cfquery name="UPD_CLOSED" datasource="#dsn2#">
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
		<!--- Eğer talimattan geliyorsa talimatın bağlı olduğu ödeme emri kapatılıyor --->
		<cfif len(attributes.bank_order_id)>
			<cfquery name="GET_BANK_ORDERS" datasource="#DSN2#">
				SELECT CLOSED_ID FROM BANK_ORDERS WHERE BANK_ORDER_ID = #attributes.bank_order_id#
			</cfquery>
			<cfif len(get_bank_orders.closed_id)>
				<cfquery name="GET_CARI_INFO" datasource="#DSN2#">
					SELECT * FROM CARI_ROWS WHERE ACTION_ID = #MAX_ID.IDENTITYCOL# AND ACTION_TYPE_ID = #process_type#
				</cfquery>
				<cfif len(GET_CARI_INFO.recordcount)>
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
							#get_bank_orders.closed_id#,
							#GET_CARI_INFO.CARI_ACTION_ID#,
							#MAX_ID.IDENTITYCOL#,
							#process_type#,
							#GET_CARI_INFO.ACTION_VALUE#,
							#GET_CARI_INFO.ACTION_VALUE#,
							#GET_CARI_INFO.OTHER_CASH_ACT_VALUE#,
							#GET_CARI_INFO.ACTION_VALUE#,
							#GET_CARI_INFO.OTHER_CASH_ACT_VALUE#,
							<cfqueryparam cfsqltype="cf_sql_varchar" value="#GET_CARI_INFO.OTHER_MONEY#">,
							#createodbcdatetime(GET_CARI_INFO.DUE_DATE)#
						)
					</cfquery>
					<cfquery name="GET_MAX_C_ID" datasource="#DSN2#">
						SELECT MAX(CLOSED_ROW_ID) C_MAX_ID FROM CARI_CLOSED_ROW
					</cfquery>
					<cfquery name="GET_CLOSED" datasource="#DSN2#">
						SELECT P_ORDER_DEBT_AMOUNT_VALUE,P_ORDER_CLAIM_AMOUNT_VALUE FROM CARI_CLOSED WHERE CLOSED_ID = #get_bank_orders.closed_id#
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
							CLOSED_ID = #get_bank_orders.closed_id#
					</cfquery>
					<cfquery name="UPD_CLOSED" datasource="#DSN2#">
						UPDATE
							CARI_CLOSED_ROW
						SET
							RELATED_CLOSED_ROW_ID = #GET_MAX_C_ID.C_MAX_ID#,
							CLOSED_AMOUNT = P_ORDER_VALUE,
							OTHER_CLOSED_AMOUNT = OTHER_P_ORDER_VALUE
						WHERE
							CLOSED_ID = #get_bank_orders.closed_id#
					</cfquery>
				</cfif>
			</cfif>
		</cfif>
		<!--- onay ve uyarıların gelebilmesi icin action file sarti kaldirildi --->
		<cf_workcube_process_cat 
			process_cat="#form.process_cat#"
			action_id = #MAX_ID.IDENTITYCOL#
			action_table="BANK_ACTIONS"
			action_column="ACTION_ID"
			is_action_file = 1
			action_db_type = '#dsn2#'
			action_page='#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.form_add_gidenh&event=upd&id=#MAX_ID.IDENTITYCOL#'
			action_file_name='#get_process_type.action_file_name#'
			is_template_action_file = '#get_process_type.action_file_from_template#'>
			<cfif isDefined('attributes.process_stage')>
				<cf_workcube_process
					is_upd='1' 
					data_source='#dsn2#'
					old_process_line='0'
					process_stage='#attributes.process_stage#'
					record_member='#session.ep.userid#'
					record_date='#now()#'
					action_table='BANK_ACTIONS'
					action_column='ACTION_ID'
					action_id='#MAX_ID.IDENTITYCOL#'
					action_page='#request.self#?fuseaction=bank.form_add_gidenh&event=upd&id=#MAX_ID.IDENTITYCOL#'
					warning_description='Giden Havale : #MAX_ID.IDENTITYCOL#'>
			</cfif>
            <cf_add_log employee_id="#session.ep.userid#" log_type="1" action_id="#MAX_ID.IDENTITYCOL#" action_name= "Giden Havale Eklendi" paper_no= "#attributes.paper_number#" period_id="#session.ep.period_id#" process_type="#get_process_type.PROCESS_TYPE#" data_source="#dsn2#">
	</cftransaction>
</cflock>
<cfif len(attributes.bank_order_id)>
	<cfquery name="upd_bank_orders" datasource="#DSN2#">
		UPDATE BANK_ORDERS SET IS_PAID = 1 WHERE BANK_ORDER_ID = #attributes.bank_order_id#
	</cfquery>
</cfif>
<cfif not isdefined('xml_import')>
	<script type="text/javascript">		
		<cfif session.ep.our_company_info.is_paper_closer eq 1 and (not (isdefined("attributes.order_id") and len(attributes.order_id)) or (isDefined("attributes.correspondence_info") and len(attributes.correspondence_info)) and (len(attributes.ACTION_TO_COMPANY_ID) or len(attributes.ACTION_TO_CONSUMER_ID) or len(attributes.employee_id)))>
			window.open('<cfoutput>#request.self#?fuseaction=finance.list_payment_actions&event=add&act_type=1&member_id=#attributes.ACTION_TO_COMPANY_ID#&consumer_id=#attributes.ACTION_TO_CONSUMER_ID#&employee_id_new=#attributes.employee_id#&acc_type_id=#attributes.acc_type_id#&money_type=#form.money_type#&row_action_id=#MAX_ID.IDENTITYCOL#&row_action_type=#process_type#</cfoutput>','page');
		</cfif>
		<cfif my_fuseaction contains 'popup'>
			wrk_opener_reload();
			window.close();
		<cfelse>
			window.location.href='<cfoutput>#request.self#?fuseaction=bank.form_add_gidenh&event=upd&id=#MAX_ID.IDENTITYCOL#</cfoutput>';
		</cfif>
	</script>
</cfif>
<cf_get_lang_set module_name="#lcase(listgetat(attributes.fuseaction,1,'.'))#">
