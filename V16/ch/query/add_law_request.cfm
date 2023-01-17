
<cfquery name="get_process_type" datasource="#dsn3#">
	SELECT 
		PROCESS_TYPE,
		IS_CARI,
		IS_ACCOUNT,
		PROCESS_CAT,
		ACTION_FILE_NAME,
		ACTION_FILE_FROM_TEMPLATE
		FROM 
			SETUP_PROCESS_CAT 
	WHERE 
		PROCESS_CAT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.process_cat#">
</cfquery>
<cfquery name="get_process_bad_debt" datasource="#dsn3#">
	SELECT IS_ACCOUNT,PROCESS_TYPE,IS_CARI FROM SETUP_PROCESS_CAT WHERE PROCESS_CAT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.process_cat#">
</cfquery>

<cfset process_type = IsDefined("attributes.acc_code") and len(attributes.acc_code) ? get_process_bad_debt.process_type : get_process_type.process_type>
<cfset is_cari = IsDefined("attributes.acc_code") and len(attributes.acc_code) ? get_process_bad_debt.is_cari : get_process_type.is_cari>
<cfset is_account = IsDefined("attributes.acc_code") and len(attributes.acc_code) ? get_process_bad_debt.is_account : get_process_type.is_account>
<cf_date tarih = 'attributes.revenue_date'>
<cfscript>
	if(len(attributes.obligee_company_id) && len(attributes.obligee_partner_id))
	{	
		from_cmp_id_ = attributes.obligee_company_id;
		from_consumer_id_ = '';
		from_employee_id_ = attributes.obligee_partner_id;
	}
	else if ((not len(attributes.obligee_company_id) && len(attributes.obligee_consumer_id)))
	{
		from_cmp_id_ = '';
		from_consumer_id_ = attributes.obligee_consumer_id;
		from_employee_id_ = '';
	}
	else if ((len(attributes.law_adwocate_comp) && len(attributes.law_adwocate_id)))
	{
		from_cmp_id_ = attributes.law_adwocate_comp;
		from_consumer_id_ = '';
		from_employee_id_ = attributes.law_adwocate_id;
	}
	else if (not len(attributes.law_adwocate_comp) && len(attributes.law_adwocate_id))
	{
		from_cmp_id_ = '';
		from_consumer_id_ = attributes.law_adwocate_id;
		from_employee_id_ = '';
	}
	else if (len(attributes.revenue_adwocate_comp) && len(attributes.revenue_adwocate_id))
	{
		from_cmp_id_ = attributes.revenue_adwocate_comp;
		from_consumer_id_ = '';
		from_employee_id_ = attributes.revenue_adwocate_id;
	}
	else if (not len(attributes.revenue_adwocate_comp) && len(attributes.revenue_adwocate_id))
	{
		from_cmp_id_ = '';
		from_consumer_id_ = attributes.revenue_adwocate_id;
		from_employee_id_ = '';
	}
	else {
		from_cmp_id_ = '';
		from_consumer_id_ = '';
		from_employee_id_ = '';
	}
	
</cfscript>
<cfif is_account eq 1>
	<cfif attributes.member_type eq "partner" and len(attributes.member_id)>
		<cfset get_acc_code.account_code = get_company_period(attributes.member_id,session.ep.period_id,dsn2)>
	<cfelseif attributes.member_type eq "consumer" and len(attributes.member_id)>
		<cfset get_acc_code.account_code = get_consumer_period(attributes.member_id,session.ep.period_id,dsn2)>
	<cfelseif attributes.member_type eq "" and len(attributes.member_id)>
		<cfset get_acc_code.account_code = get_employee_period(attributes.member_id)>
	</cfif>
	<cfif len(from_cmp_id_)>
		<cfset get_acc_code.account_code2 = get_company_period(from_cmp_id_,session.ep.period_id,dsn2)>
	<cfelseif len(from_consumer_id_) >
		<cfset get_acc_code.account_code2 = get_consumer_period(from_consumer_id_,session.ep.period_id,dsn2)>
	<cfelseif len(from_employee_id_)>
		<cfset get_acc_code.account_code2 = get_employee_period(from_employee_id_)>
	</cfif>
	<cfif not (len(get_acc_code.ACCOUNT_CODE))>
		<script type="text/javascript">
			alert("<cf_get_lang no='76.Seçtiğiniz Üyenin Muhasebe Kodu Seçilmemiş'>!");
			window.location.href='<cfoutput>#request.self#?fuseaction=ch.list_law_request&event=add</cfoutput>';
		</script>
		<cfabort>
	</cfif>
	
</cfif>
<cflock name="#CreateUUID()#" timeout="20">
	<cftransaction>
			<cfif isdefined("get_acc_code.account_code2") and len(get_acc_code.account_code2)>
				<cfquery name="ADD_CARI_TO_CARI" datasource="#dsn#">
					INSERT INTO
						#dsn2_alias#.CARI_ACTIONS
					(
						PROCESS_CAT,
						ACTION_NAME,
						ACTION_TYPE_ID,	
						ACTION_VALUE,
						ACTION_CURRENCY_ID,
						TO_CMP_ID,
						TO_CONSUMER_ID,
						TO_EMPLOYEE_ID,
						FROM_CMP_ID,
						FROM_CONSUMER_ID,
						FROM_EMPLOYEE_ID,
						OTHER_CASH_ACT_VALUE,
						OTHER_MONEY,
						ACTION_DETAIL,
						ACTION_DATE,
						PAPER_NO,          
						RECORD_DATE,
						RECORD_EMP,
						RECORD_IP		
					)
					VALUES
					(
						#form.process_cat#,
						'#UCase(getLang("main",1770))#',
						#process_type#,
						<cfif len(attributes.total_credit)>#attributes.total_credit#<cfelse>0</cfif>,
						'#attributes.money_currency#',
						<cfif attributes.member_type eq "partner" and len(attributes.member_id)>#attributes.member_id#<cfelse>NULL</cfif>,
						<cfif attributes.member_type eq "consumer" and len(attributes.member_id)>#attributes.member_id#<cfelse>NULL</cfif>,
						<cfif attributes.member_type eq "" and len(attributes.member_id)>#attributes.member_id#<cfelse>NULL</cfif>,
						<cfif len(from_cmp_id_)>#from_cmp_id_#<cfelse>NULL</cfif>,
						<cfif len(from_consumer_id_)>#from_consumer_id_#<cfelse>NULL</cfif>,
						<cfif len(from_employee_id_)>#from_employee_id_#<cfelse>NULL</cfif>,
						<cfif len(attributes.total_credit)>#attributes.total_credit#<cfelse>0</cfif>,
						'#attributes.money_currency#',
						<cfif len(attributes.detail)>'#attributes.detail#'<cfelse>NULL</cfif>,
						#attributes.revenue_date#,
						<cfif len(attributes.file_number)>'#attributes.file_number#'<cfelse>NULL</cfif>,
						#now()#,
						#session.ep.userid#,
						'#cgi.remote_addr#'	
					)					
				</cfquery>
				<cfquery name="GET_MAX" datasource="#DSN#">
					SELECT MAX(ACTION_ID) AS ACTION_ID FROM #dsn2_alias#.CARI_ACTIONS
				</cfquery>
			</cfif>

			<cfquery name="add_law_request" datasource="#dsn#" result="MAX_ID">
				INSERT INTO
					COMPANY_LAW_REQUEST
				(
					<cfif isdefined("attributes.member_type") and attributes.member_type is 'partner'>
						COMPANY_ID,
					<cfelse>
						CONSUMER_ID,
					</cfif>
					REQUEST_STATUS,
					PROCESS_STAGE,
					DETAIL,
					FILE_NUMBER,
					FILE_STAGE,
					LAW_STAGE,
					LAW_ADWOCATE,
					<cfif len(attributes.law_adwocate_comp) and len(attributes.law_adwocate_comp)>
					LAW_ADWOCATE_COMPANY,
					</cfif>
					REVENUE_ADWOCATE,
					<cfif len(attributes.revenue_adwocate_comp) and len(attributes.revenue_adwocate_comp)>
					REVENUE_ADWOCATE_COMPANY,
					</cfif>
					REVENUE_DATE,
					TOTAL_AMOUNT,
					MONEY_CURRENCY,
					TOTAL_REVENUE_MONEY_CURRENCY,
					KALAN_REVENUE_MONEY_CURRENCY,
					<cfif len(attributes.obligee_company_id) and len(attributes.obligee_partner_id)>
						OBLIGEE_COMPANY_ID,
						OBLIGEE_PARTNER_ID,
						<cfelseif not len(attributes.obligee_company_id) and len(attributes.obligee_consumer_id)>
						OBLIGEE_CONSUMER_ID,
						</cfif>
					OBLIGEE_DETAIL,
					PROCESS_CAT,
					CARI_ACTION_ID,
					RECORD_DATE,
					RECORD_IP,
					RECORD_EMP,
					DEFAULT_RATE,
					CREDIT_DATE,
					ACCOUNT_CODE
				)
				VALUES
				(
					<cfif isdefined("attributes.member_type") and attributes.member_type is 'partner'>
						#attributes.member_id#,
					<cfelse>
						#attributes.member_id#,
					</cfif>
					1,
					#attributes.process_stage#,
					<cfif len(attributes.detail)>'#attributes.detail#'<cfelse>NULL</cfif>,
					<cfif len(attributes.file_number)>'#attributes.file_number#'<cfelse>NULL</cfif>,
					<cfif len(attributes.file_stage)>'#attributes.file_stage#'<cfelse>NULL</cfif>,
					<cfif len(attributes.law_name)>'#attributes.law_name#'<cfelse>NULL</cfif>,
					<cfif len(attributes.law_adwocate_id) and len(attributes.law_adwocate)>'#attributes.law_adwocate_id#'<cfelse>NULL</cfif>,
					<cfif len(attributes.law_adwocate_comp) and len(attributes.law_adwocate_comp)>#attributes.law_adwocate_comp#,</cfif>
					<cfif len(attributes.revenue_adwocate_id) and len(attributes.revenue_adwocate)>'#attributes.revenue_adwocate_id#'<cfelse>NULL</cfif>,
					<cfif len(attributes.revenue_adwocate_comp) and len(attributes.revenue_adwocate_comp)>#attributes.revenue_adwocate_comp#,</cfif>
					#attributes.revenue_date#,
					<cfif len(attributes.total_credit)>#attributes.total_credit#<cfelse>0</cfif>,
					'#attributes.money_currency#',
					'#attributes.money_currency#',
					'#attributes.money_currency#',
					<cfif len(attributes.obligee_company_id) and len(attributes.obligee_partner_id)>
						<cfif len(attributes.obligee_company_id)>#attributes.obligee_company_id#<cfelse>NULL</cfif>,
						<cfif len(attributes.obligee_partner_id)>#attributes.obligee_partner_id#<cfelse>NULL</cfif>,
					<cfelseif not len(attributes.obligee_company_id) and len(attributes.obligee_consumer_id)>
						<cfif len(attributes.obligee_consumer_id)>#attributes.obligee_consumer_id#<cfelse>NULL</cfif>,
					</cfif>
					<cfif len(attributes.obligee_detail)>'#attributes.obligee_detail#'<cfelse>NULL</cfif>,
					#process_cat#,
					<cfif isdefined("get_acc_code.account_code2") and len(get_acc_code.account_code2)>
						#get_max.action_id#
					<cfelse>
						NULL
					</cfif>,
					#now()#,
					'#cgi.remote_addr#',
					#session.ep.userid#,
					<cfif IsDefined("attributes.default_rate") and len(attributes.default_rate)>
						<cfqueryparam cfsqltype="cf_sql_float" value="#filterNum(attributes.default_rate)#">
					<cfelse>
						<cfqueryparam cfsqltype="cf_sql_float" value="" null="yes">
					</cfif>,
					<cfif IsDefined("attributes.credite_date") and len(attributes.credite_date)><cfqueryparam cfsqltype="cf_sql_date" value="#attributes.credite_date#"><cfelse><cfqueryparam cfsqltype="cf_sql_date" value="" null="yes"></cfif>,
					<cfif IsDefined("attributes.acc_code") and len(attributes.acc_code)><cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.acc_code#"><cfelse><cfqueryparam cfsqltype="cf_sql_varchar" value="" null="yes"></cfif>
				)
			</cfquery>
			<cfif IsDefined("attributes.acc_code") and len(attributes.acc_code)>	
				<cfset get_max.action_id = MAX_ID.IDENTITYCOL>
			</cfif>
			<cfscript>
				currency_multiplier = '';
				paper_currency_multiplier = '';
				paper_currency_multiplier2 = '';
				if(isDefined('attributes.kur_say') and len(attributes.kur_say))
					for(mon=1;mon lte attributes.kur_say;mon=mon+1)
					{
						if(evaluate("attributes.hidden_rd_money_#mon#") is session.ep.money2)
							currency_multiplier = evaluate('attributes.txt_rate2_#mon#/attributes.txt_rate1_#mon#');
						if(evaluate("attributes.hidden_rd_money_#mon#") is attributes.money_currency) // borç tarafı para birimi
							paper_currency_multiplier = evaluate('attributes.txt_rate2_#mon#/attributes.txt_rate1_#mon#');
						if(evaluate("attributes.hidden_rd_money_#mon#") is attributes.money_currency) // alacak tarafı para pirimi
							paper_currency_multiplier2 = evaluate('attributes.txt_rate2_#mon#/attributes.txt_rate1_#mon#');
					}
				
				// borç tarafı 
					act_other_money_value = attributes.total_credit; // para değeri
					act_other_money = attributes.money_currency; // para birimi
	
				// alacak tarafı 
					act_other_money_value_ = attributes.total_credit; // para değeri
					act_other_money_ = attributes.money_currency; // para birimi 

				//borclu sube
				if(isdefined("attributes.branch_id_borc") and len(attributes.branch_id_borc))
					to_branch_id_info = attributes.branch_id_borc;
				else
					to_branch_id_info = listgetat(session.ep.user_location,2,'-');	
				//alacakli sube	
				if(isdefined("attributes.branch_id_alacak") and len(attributes.branch_id_alacak))
					from_branch_id_info = attributes.branch_id_alacak;
				else
					from_branch_id_info = listgetat(session.ep.user_location,2,'-');	
					
				if (is_cari eq 1 and isdefined("get_acc_code.account_code2") and len(get_acc_code.account_code2))
				{
						carici
						(
							action_id : get_max.action_id,
							islem_belge_no : attributes.file_number,
							process_cat : attributes.process_cat,
							workcube_process_type : process_type,
							action_table : 'CARI_ACTIONS',
							islem_tutari : attributes.total_credit,
							action_currency : session.ep.money,
							islem_tarihi : attributes.revenue_date,
							action_detail : attributes.detail,
							islem_detay : UCase(getLang('main',1770)), //CARİ VİRMAN
							to_cmp_id : iif(attributes.member_type eq "partner",'attributes.member_id',de('')),
							to_consumer_id : iif(attributes.member_type eq "consumer",'attributes.member_id',de('')),
							to_employee_id : iif(attributes.member_type eq "",'attributes.member_id',de('')),
							to_branch_id : to_branch_id_info,
							account_card_type : 13,
							other_money_value : act_other_money_value,
							other_money : act_other_money,
							currency_multiplier : currency_multiplier,
							rate2:paper_currency_multiplier,
							cari_db : dsn,
							cari_db_alias : dsn2_alias
						);
						carici
						(
							action_id : get_max.action_id,
							islem_belge_no : attributes.file_number,
							process_cat : attributes.process_cat,
							workcube_process_type : process_type,
							action_table : 'CARI_ACTIONS',
							islem_tutari : attributes.total_credit,
							action_currency : session.ep.money,
							islem_tarihi : attributes.revenue_date,
							action_detail : attributes.obligee_detail,
							islem_detay : UCase(getLang('main',1770)), //CARİ VİRMAN
							from_cmp_id : from_cmp_id_,
							from_consumer_id : from_consumer_id_,
							from_employee_id :from_employee_id_,
							from_branch_id : from_branch_id_info,
							account_card_type : 13,
							other_money_value : act_other_money_value_,
							other_money : act_other_money_,
							currency_multiplier : currency_multiplier,
							rate2:paper_currency_multiplier2,
							cari_db : dsn,
							cari_db_alias : dsn2_alias
						);
				}
					
				if (is_account eq 1)
				{
					satir_detay_list = ArrayNew(2);
					satir_detay_list[1][1]= '#attributes.member_name#-#attributes.detail#'; //borclu satırın acıklaması
					satir_detay_list[2][1]='#attributes.obligee_company#-#attributes.obligee_detail#';//alacak satırın acıklaması
					acc_project_list_borc = '';
					acc_project_list_alacak = '';
					/*borclu proje muhabesebe kaydi */
					if(isdefined("attributes.project_id") and len(attributes.project_id) and len(attributes.project_name))
						acc_project_list_borc = listappend(acc_project_list_borc,attributes.project_id,',');
					else
						acc_project_list_borc = listappend(acc_project_list_borc,'',',');
					/*alacakli proje muhabesebe kaydi */
					if(isdefined("attributes.project_id_2") and len(attributes.project_id_2) and len(attributes.project_name_2))
						acc_project_list_alacak = listappend(acc_project_list_alacak,attributes.project_id_2,',');
					else
						acc_project_list_alacak = listappend(acc_project_list_alacak,'',',');
						
					if (len(get_acc_code.account_code) and ( IsDefined("get_acc_code.account_code2") and len(get_acc_code.account_code2) or (IsDefined("attributes.acc_code") and len(attributes.acc_code))))
					{
						if(IsDefined("attributes.acc_code") and len(attributes.acc_code))
							{
							alacak_hesaplar = attributes.acc_code;
							fis_detay = UCase(getLang('','',58259));//Şüpheli Alacaklar 
							}
						else
							{
								alacak_hesaplar = get_acc_code.account_code2;
								fis_detay = UCase(getLang('main',1770));//CARİ VİRMAN
							}
						muhasebeci
						(
							action_id : get_max.action_id,
							belge_no : attributes.file_number,
							workcube_process_type : process_type,
							workcube_process_cat:attributes.process_cat,
							islem_tarihi : attributes.revenue_date,
							fis_detay : fis_detay, //Şüpheli Alacaklar ,CARİ VİRMAN
							fis_satir_detay: satir_detay_list,
							company_id : iif(attributes.member_type eq "partner",'attributes.member_id',de('')),
							consumer_id : iif(attributes.member_type eq "consumer",'attributes.member_id',de('')),
							employee_id : iif(attributes.member_type eq "",'attributes.member_id',de('')),
							borc_hesaplar : get_acc_code.account_code,
							borc_tutarlar : attributes.total_credit,
							alacak_hesaplar : alacak_hesaplar,
							alacak_tutarlar :attributes.total_credit,
							other_amount_alacak : iif(len(attributes.total_credit),'attributes.total_credit',de('')),
							other_currency_alacak : act_other_money_,
							other_amount_borc : attributes.total_credit,
							other_currency_borc : act_other_money,
							currency_multiplier : currency_multiplier,
							to_branch_id : to_branch_id_info,
							from_branch_id : from_branch_id_info,
							acc_project_list_alacak : acc_project_list_alacak,
							acc_project_list_borc : acc_project_list_borc,
							account_card_type : 13,
							muhasebe_db : '#dsn#',
							muhasebe_db_alias = dsn2_alias,
							is_acc_type : 1
						);	
					}	
				}
				f_kur_ekle_action(action_id:get_max.action_id,process_type:0,action_table_name:'CARI_ACTION_MONEY',action_table_dsn:'#dsn2#',transaction_dsn='#dsn#');
			</cfscript>
		<cf_workcube_process is_upd='1' 
				data_source='#dsn#' 
				old_process_line='0'
				process_stage='#attributes.process_stage#' 
				record_member='#session.ep.userid#' 
				record_date='#now()#' 
				action_table='COMPANY_LAW_REQUEST'
				action_column='LAW_REQUEST_ID'
				action_id='#MAX_ID.IDENTITYCOL#'
				action_page='#request.self#?fuseaction=ch.form_upd_law_request&id=#MAX_ID.IDENTITYCOL#' 
				warning_description='İcra Takibi : #MAX_ID.IDENTITYCOL#'>
	</cftransaction>
</cflock>
<script type="text/javascript">
	window.location.href='<cfoutput>#request.self#?fuseaction=ch.list_law_request&event=upd&id=#MAX_ID.IDENTITYCOL#</cfoutput>';
</script>