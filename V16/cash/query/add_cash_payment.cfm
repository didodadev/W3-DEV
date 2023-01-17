<cf_get_lang_set module_name="cash"><!--- sayfanin en altinda kapanisi var --->
<cfif form.active_period neq session.ep.period_id>
	<script type="text/javascript">
		alert("<cf_get_lang_main no='1659.İşlem Yapmak İstediğiniz Muhasebe Dönemi ile Aktif Muhasebe Döneminiz Farklı Muhasebe Döneminizi Kontrol Ediniz'>!");
		window.location.href='<cfoutput>#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.list_cash_actions</cfoutput>';
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
		PROCESS_CAT
	 FROM 
	 	SETUP_PROCESS_CAT 
	WHERE 
		PROCESS_CAT_ID = #form.process_cat#
</cfquery>
<cfquery name="CHECK_PAPER_NUMBER" datasource="#dsn2#">
    SELECT PAPER_NO FROM CASH_ACTIONS WHERE PAPER_NO = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.PAPER_NUMBER#">
</cfquery>
<cfif check_paper_number.recordcount>
    <script type="text/javascript">
    	alert('Girdiğiniz Belge Numarası Kullanılmıştır!');
		history.back();
    </script>
    <cfif attributes.paper_number contains '-'>
    	<cfset caller.paper_number = ListGetAt(attributes.paper_number,2,'-') & '-' & (ListGetAt(attributes.paper_number,2,'-') + 1)>
    <cfelse>
    	<cfset caller.paper_number = attributes.paper_number + 1>
    </cfif>
    <cfabort>
</cfif>
<cfscript>
	process_type = get_process_type.PROCESS_TYPE;
	is_cari = get_process_type.IS_CARI;
	is_account = get_process_type.IS_ACCOUNT;
	CASH_ACTION_FROM_CASH_ID = listfirst(attributes.CASH_ACTION_FROM_CASH_ID,';');
	from_branch_id = listlast(attributes.CASH_ACTION_FROM_CASH_ID,';');
	attributes.acc_type_id = '';
	if(listlen(attributes.employee_id,'_') eq 2)
	{
		attributes.acc_type_id = listlast(attributes.employee_id,'_');
		attributes.employee_id = listfirst(attributes.employee_id,'_');
	}
</cfscript>
<cfset paper_no = "#form.paper_number#">
<cfif is_account eq 1>
	<cfif len(attributes.employee_id)>
		<cfset acc = GET_EMPLOYEE_PERIOD(attributes.employee_id,attributes.acc_type_id)>
	<cfelseif len(attributes.CASH_ACTION_TO_COMPANY_ID)>
		<cfset acc = GET_COMPANY_PERIOD(attributes.CASH_ACTION_TO_COMPANY_ID)>
	<cfelseif len(attributes.CASH_ACTION_TO_CONSUMER_ID)>
		<cfset acc = GET_CONSUMER_PERIOD(attributes.CASH_ACTION_TO_CONSUMER_ID)>
	</cfif>
	<cfif not len(acc)>
		<cfif not isdefined('xml_import')>
			<script type="text/javascript">
				alert("<cf_get_lang no ='251.Seçtiğiniz Çalışan veya Üyenin Muhasebe Kodu Seçilmemiş'>!");
				history.back();	
			</script>
			<cfabort>
		<cfelse>
			<cf_get_lang no ='251.Seçtiğiniz Çalışan veya Üyenin Muhasebe Kodu Seçilmemiş'>!<br/>
		</cfif>
	</cfif>
</cfif>
<cf_date tarih='attributes.ACTION_DATE'>
<cfif not isdefined('xml_import')>
	<cfscript>
		attributes.cash_action_value = filterNum(attributes.cash_action_value);
		attributes.other_cash_act_value = filterNum(attributes.other_cash_act_value);
		attributes.system_amount = filterNum(attributes.system_amount);
		for(m_sy=1; m_sy lte attributes.kur_say; m_sy = m_sy+1)
		{
			'attributes.txt_rate1_#m_sy#' = filterNum(evaluate('attributes.txt_rate1_#m_sy#'),session.ep.our_company_info.rate_round_num);
			'attributes.txt_rate2_#m_sy#' = filterNum(evaluate('attributes.txt_rate2_#m_sy#'),session.ep.our_company_info.rate_round_num);
		}
		
		currency_multiplier = '';
		paper_currency_multiplier = '';
		if(isDefined('attributes.kur_say') and len(attributes.kur_say))
			for(mon=1;mon lte attributes.kur_say;mon=mon+1)
			{
				if(evaluate("attributes.hidden_rd_money_#mon#") is session.ep.money2)
					currency_multiplier = evaluate('attributes.txt_rate2_#mon#/attributes.txt_rate1_#mon#');
				if(evaluate("attributes.hidden_rd_money_#mon#") is attributes.money_type)
					paper_currency_multiplier = evaluate('attributes.txt_rate2_#mon#/attributes.txt_rate1_#mon#');
			}
	</cfscript>
</cfif>

<cf_papers paper_type="cash_payment">
<cflock name="#createUUID()#" timeout="20">
	<cftransaction>
		<!--- Ödeme emrinden çağrılmışsa ödeme emrinde is_paid 1 e set ediliyor --->
		<cfquery name="GET_FROM_CASH" datasource="#dsn2#">
			SELECT CASH_CURRENCY_ID, CASH_ACC_CODE FROM CASH WHERE CASH_ID = #CASH_ACTION_FROM_CASH_ID#
		</cfquery>
		<cfquery name="ADD_CASH_PAYMENT" datasource="#dsn2#" result="MAX_ID">
			INSERT INTO
				CASH_ACTIONS
				(
					PROCESS_CAT,
					PAPER_NO,
					ACTION_TYPE,
					ACTION_TYPE_ID,
					CASH_ACTION_TO_COMPANY_ID,
					CASH_ACTION_TO_CONSUMER_ID,
					CASH_ACTION_FROM_CASH_ID,
					CASH_ACTION_TO_EMPLOYEE_ID,
					ACTION_DATE,
					CASH_ACTION_VALUE,
					CASH_ACTION_CURRENCY_ID,
					OTHER_CASH_ACT_VALUE,
					OTHER_MONEY,
					PAYER_ID,
					PROJECT_ID,
					ACTION_DETAIL,
					IS_ACCOUNT,
					IS_ACCOUNT_TYPE,
					RECORD_EMP,
					RECORD_IP,
					RECORD_DATE,
					ASSETP_ID,
					SPECIAL_DEFINITION_ID,
					EXPENSE_CENTER_ID,
					EXPENSE_ITEM_ID,
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
					<cfif isDefined("attributes.PAPER_NUMBER") and len(attributes.PAPER_NUMBER)><cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.PAPER_NUMBER#"><cfelse>NULL</cfif>,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#UCase(getLang('main',435))#">,
					#process_type#,
					<cfif len(attributes.CASH_ACTION_TO_COMPANY_ID) and (len(attributes.employee_id) eq 0)>#CASH_ACTION_TO_COMPANY_ID#<cfelse>NULL</cfif>,
					<cfif len(attributes.CASH_ACTION_TO_CONSUMER_ID)>#CASH_ACTION_TO_CONSUMER_ID#<cfelse>NULL</cfif>,
					#CASH_ACTION_FROM_CASH_ID#,
					<cfif len(attributes.employee_id)>#attributes.employee_id#<cfelse>NULL</cfif>,
					#attributes.ACTION_DATE#,
					#attributes.cash_action_value#,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#GET_FROM_CASH.CASH_CURRENCY_ID#">,
					<cfif len(attributes.other_cash_act_value)>#attributes.other_cash_act_value#<cfelse>NULL</cfif>,
					<cfif len(attributes.money_type)><cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.money_type#"><cfelse>NULL</cfif>,
					#PAYER_ID#,
					<cfif len(attributes.project_name) and len(attributes.project_id)>#attributes.project_id#<cfelse>NULL</cfif>,
					<cfif isDefined("attributes.ACTION_DETAIL") and len(attributes.ACTION_DETAIL)><cfqueryparam cfsqltype="cf_sql_varchar" value="#ACTION_DETAIL#"><cfelse>NULL</cfif>,
					<cfif is_account eq 1>1<cfelse>0</cfif>,
					12,
					#SESSION.EP.USERID#,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#CGI.REMOTE_ADDR#">,
					#NOW()#,
					<cfif isdefined("attributes.asset_id") and len(attributes.asset_id) and len(attributes.asset_name)>#attributes.asset_id#<cfelse>NULL</cfif>,
					<cfif isdefined("attributes.special_definition_id") and len(attributes.special_definition_id)>#attributes.special_definition_id#<cfelse>NULL</cfif>,
					<cfif isdefined("attributes.expense_center_id") and len(attributes.expense_center_id) and isdefined("attributes.expense_center_name") and len(attributes.expense_center_name)>#attributes.expense_center_id#<cfelse>NULL</cfif>,
					<cfif isdefined("attributes.expense_item_id") and len(attributes.expense_item_id) and isdefined("attributes.expense_item_name") and  len(attributes.expense_item_name)>#attributes.expense_item_id#<cfelse>NULL</cfif>,
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
				action_id : MAX_ID.IDENTITYCOL,
				action_table : 'CASH_ACTIONS',
				workcube_process_type : process_type,
				process_cat : form.process_cat,
				account_card_type : 12,
				islem_tarihi : attributes.ACTION_DATE,
				islem_tutari : attributes.system_amount,
				islem_belge_no : attributes.PAPER_NUMBER,
				other_money_value : iif(len(attributes.other_cash_act_value),'attributes.other_cash_act_value',de('')),
				other_money : attributes.money_type,
				to_cmp_id : CASH_ACTION_TO_COMPANY_ID,
				to_consumer_id : CASH_ACTION_TO_CONSUMER_ID,
				to_employee_id : attributes.employee_id,
				from_cash_id : CASH_ACTION_FROM_CASH_ID,
				currency_multiplier : currency_multiplier,
				islem_detay : UCase(getLang('main',435)),
				action_detail : attributes.action_detail,
				acc_type_id : attributes.acc_type_id,
				payer_id :PAYER_ID,
				action_currency : session.ep.money,
				project_id : iif((isdefined("attributes.project_id") and len(attributes.project_id) and len(attributes.project_name)),'attributes.project_id',de('')),
				expense_center_id : iif((isdefined("attributes.expense_center_id") and len(attributes.expense_center_id) and isdefined("attributes.expense_center_name") and len(attributes.expense_center_name)),'attributes.expense_center_id',de('')),
				expense_item_id : iif((isdefined("attributes.expense_item_id") and len(attributes.expense_item_id) and len(attributes.expense_item_name)),'attributes.expense_item_id',de('')),
				special_definition_id : iif((isdefined("attributes.special_definition_id") and len(attributes.special_definition_id)),'attributes.special_definition_id',de('')),
				from_branch_id : from_branch_id,
				assetp_id : iif((isdefined("attributes.asset_id") and len(attributes.asset_id) and len(attributes.asset_name)),'attributes.asset_id',de('')),
				rate2:paper_currency_multiplier
				);
		}
		if(isdefined("attributes.expense_center_name") and len(attributes.expense_center_name) and len(attributes.expense_center_id) and len(attributes.expense_item_id) and len(attributes.expense_item_name))
		{
			if(GET_FROM_CASH.CASH_CURRENCY_ID is session.ep.money)
			{
				butceci(
					action_id : MAX_ID.IDENTITYCOL,
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
					action_id : MAX_ID.IDENTITYCOL,
					muhasebe_db : dsn2,
					is_income_expense : false,
					process_type : process_type,
					nettotal : attributes.system_amount,
					other_money_value : attributes.cash_action_value,
					action_currency : GET_FROM_CASH.CASH_CURRENCY_ID,
					currency_multiplier : currency_multiplier,
					expense_date : attributes.ACTION_DATE,
					expense_center_id : attributes.expense_center_id,
					expense_item_id : attributes.expense_item_id,
					detail : UCase(getLang('main',2746)),
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
			if (isDefined("attributes.ACTION_DETAIL") and len(attributes.ACTION_DETAIL))
				str_card_detail = '#attributes.company_name#-#attributes.ACTION_DETAIL#';
			else
				str_card_detail = '#attributes.company_name#-' & UCase(getLang('cash',53));			
			muhasebeci (
				action_id:MAX_ID.IDENTITYCOL,
				workcube_process_type:process_type,
				workcube_process_cat:form.process_cat,
				account_card_type:12,
				company_id:attributes.CASH_ACTION_TO_COMPANY_ID,
				consumer_id:attributes.CASH_ACTION_TO_CONSUMER_ID,
				islem_tarihi:attributes.ACTION_DATE,
				borc_hesaplar: acc,
				borc_tutarlar: attributes.system_amount,
				alacak_hesaplar: GET_FROM_CASH.CASH_ACC_CODE,
				alacak_tutarlar: attributes.system_amount,
				other_amount_alacak : attributes.cash_action_value,
				other_currency_alacak : GET_FROM_CASH.CASH_CURRENCY_ID,
				other_amount_borc : iif(len(attributes.other_cash_act_value),'attributes.other_cash_act_value',de('')),
				other_currency_borc : form.money_type,
				fis_satir_detay:str_card_detail,
				currency_multiplier : currency_multiplier,
				fis_detay : UCase(getLang('cash',53)), //ÖDEME İŞLEMİ
				belge_no : attributes.PAPER_NUMBER,
				from_branch_id : from_branch_id,
				acc_project_id : iif((isdefined("attributes.project_id") and len(attributes.project_id) and len(attributes.project_name)),'attributes.project_id',de('')),
				is_abort : iif(isdefined('xml_import'),0,1)
				);		
		}
		f_kur_ekle_action(action_id:MAX_ID.IDENTITYCOL,process_type:0,action_table_name:'CASH_ACTION_MONEY',action_table_dsn:'#dsn2#');
		</cfscript>
		<cfif not isdefined('xml_import') and len(paper_number)>
			<!--- Belge No update ediliyor --->
			<cfquery name="UPD_GENERAL_PAPERS" datasource="#DSN2#">
				UPDATE 
					#dsn3_alias#.GENERAL_PAPERS
				SET
					CASH_PAYMENT_NUMBER = #paper_number#
				WHERE
					CASH_PAYMENT_NUMBER IS NOT NULL
			</cfquery>
		</cfif>
		<cfif isdefined("attributes.order_id") and len(attributes.order_id) and is_cari and isdefined("attributes.order_row_id") and len(attributes.order_row_id)><!--- ödeme emirlerinden ödeme yapıldıgnda.. --->
			<cfquery name="GET_CARI_INFO" datasource="#dsn2#">
				SELECT 
                	CARI_ACTION_ID, 
                    ACTION_ID, 
                    ACTION_TABLE, 
                    PAPER_NO, 
                    ACTION_TYPE_ID, 
                    ACTION_NAME, 
                    EXPENSE_ITEM_ID, 
                    EXPENSE_CENTER_ID, 
                    TO_CMP_ID, 
                    FROM_CMP_ID, 
                    TO_ACCOUNT_ID, 
                    FROM_CASH_ID, 
                    TO_CASH_ID, 
                    FROM_EMPLOYEE_ID, 
                    TO_EMPLOYEE_ID, 
                    FROM_CONSUMER_ID, 
                    TO_CONSUMER_ID, 
                    ACTION_VALUE, 
                    ACTION_DATE, 
                    DUE_DATE, 
                    ACTION_CURRENCY_ID, 
                    PAYER_ID, 
                    IS_ACCOUNT, 
                    IS_ACCOUNT_TYPE, 
                    OTHER_CASH_ACT_VALUE, 
                    OTHER_MONEY, 
                    PROCESS_CAT, 
                    IS_PROCESSED, 
                    ACTION_VALUE_2, 
                    ACTION_CURRENCY_2, 
                    ACTION_DETAIL, 
                    FROM_BRANCH_ID, 
                    TO_BRANCH_ID, 
                    PROJECT_ID, 
                    IS_CASH_PAYMENT, 
                    ASSETP_ID, 
                    SPECIAL_DEFINITION_ID, 
                    PAYROLL_ID, 
                    RATE2, 
                    PAYMENT_VALUE, 
                    RECORD_DATE, 
                    RECORD_CONS, 
                    RECORD_EMP, 
                    RECORD_PAR, 
                    RECORD_IP, 
                    UPDATE_DATE, 
                    UPDATE_CONS, 
                    UPDATE_EMP, 
                    UPDATE_PAR, 
                    UPDATE_IP, 
                    ACC_TYPE_ID, 
                    PAPER_ACT_DATE 
                FROM 
                	CARI_ROWS 
                WHERE 
                	ACTION_ID = #MAX_ID.IDENTITYCOL# AND ACTION_TYPE_ID = #process_type#
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
						#attributes.ACTION_DATE#
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
		<!--- onay ve uyarıların gelebilmesi icin action file sarti kaldirildi --->
		<cf_workcube_process_cat 
			process_cat="#form.process_cat#"
			action_id = #MAX_ID.IDENTITYCOL#
			is_action_file = 1
			action_db_type = '#dsn2#'
			action_page='#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.form_add_cash_payment&event=upd&id=#MAX_ID.IDENTITYCOL#'
			action_file_name='#get_process_type.action_file_name#'
			is_template_action_file = '#get_process_type.action_file_from_template#'>
	</cftransaction>
    <cf_add_log log_type="1" action_id="#MAX_ID.IDENTITYCOL#" action_name="#attributes.PAPER_NUMBER# Eklendi" paper_no="#attributes.PAPER_NUMBER#" period_id="#session.ep.period_id#" process_type="#get_process_type.PROCESS_TYPE#" data_source="#dsn2#">
</cflock>
<cfif not isdefined('xml_import')>
	<!--- Print ekranı  --->
	<script type="text/javascript">
		<cfif session.ep.our_company_info.is_paper_closer eq 1 and (not (isdefined("attributes.order_id") and len(attributes.order_id)) or (isDefined("attributes.correspondence_info") and len(attributes.correspondence_info)) and (len(attributes.CASH_ACTION_TO_COMPANY_ID) or len(attributes.CASH_ACTION_TO_CONSUMER_ID) or len(attributes.employee_id)))>
			window.open('<cfoutput>#request.self#?fuseaction=finance.list_payment_actions&event=add&act_type=1&member_id=#attributes.CASH_ACTION_TO_COMPANY_ID#&consumer_id=#attributes.CASH_ACTION_TO_CONSUMER_ID#&employee_id_new=#attributes.employee_id#&acc_type_id=#attributes.acc_type_id#&money_type=#form.money_type#&row_action_id=#MAX_ID.IDENTITYCOL#&row_action_type=#process_type#</cfoutput>','page');
		</cfif>
		<cfif isdefined("attributes.order_id") and len(attributes.order_id)>
			window.close();
			wrk_opener_reload();
		<cfelse>
			window.location.href='<cfoutput>#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.form_add_cash_payment&event=upd&id=#MAX_ID.IDENTITYCOL#</cfoutput>';
		</cfif>
	</script>
</cfif>
<cf_get_lang_set module_name="#lcase(listgetat(attributes.fuseaction,1,'.'))#"><!--- sayfanin en ustunde acilisi var --->
