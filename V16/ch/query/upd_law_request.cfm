<cf_date tarih = 'attributes.revenue_date'>
<cfif len(attributes.credite_date)><cf_date tarih = 'attributes.credite_date'></cfif>
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
		PROCESS_CAT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.process_cat#">
</cfquery>
<cfquery name="get_process_bad_debt" datasource="#dsn3#">
	SELECT IS_ACCOUNT,PROCESS_TYPE,IS_CARI FROM SETUP_PROCESS_CAT WHERE PROCESS_CAT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.process_cat#">
</cfquery>

<cfset process_type = IsDefined("attributes.acc_code") and len(attributes.acc_code) ? get_process_bad_debt.process_type : get_process_type.process_type>
<cfset is_cari = IsDefined("attributes.acc_code") and len(attributes.acc_code) ? get_process_bad_debt.is_cari : get_process_type.is_cari>
<cfset is_account = IsDefined("attributes.acc_code") and len(attributes.acc_code) ? get_process_bad_debt.is_account : get_process_type.is_account>

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
				window.location.href='<cfoutput>#request.self#?fuseaction=ch.list_law_request&event=upd&id=#attributes.id#</cfoutput>';
			</script>
		<cfabort>
	</cfif>
</cfif>
<cflock name="#CreateUUID()#" timeout="20">
	<cftransaction>
		<cfquery name="get_action_id" datasource="#dsn2#">
			SELECT CARI_ACTION_ID FROM #dsn_alias#.COMPANY_LAW_REQUEST
			WHERE LAW_REQUEST_ID = #attributes.id#
		</cfquery>
		<cfif attributes.del_req_id eq 0>
			<cfif len(get_action_id.cari_action_id)>	
				<cfquery name="UPD_CARI_TO_CARI" datasource="#DSN2#">
					UPDATE 
						CARI_ACTIONS
					SET
						ACTION_TYPE_ID = #process_type#,
						ACTION_VALUE = #attributes.total_credit#,
						ACTION_CURRENCY_ID = '#attributes.money_currency#',
						OTHER_CASH_ACT_VALUE = <cfif len(attributes.total_revenue)>#attributes.total_revenue#,<cfelse>NULL,</cfif>
						OTHER_MONEY = '#attributes.money_currency#',
						TO_CMP_ID = <cfif attributes.member_type eq "partner" and len(attributes.member_id)>#attributes.member_id#,<cfelse>NULL,</cfif>
						TO_CONSUMER_ID = <cfif attributes.member_type eq "consumer" and len(attributes.to_consumer_id)>#attributes.member_id#,<cfelse>NULL,</cfif>
						TO_EMPLOYEE_ID = <cfif attributes.member_type eq "" and len(attributes.member_id)>#attributes.member_id#,<cfelse>NULL,</cfif>
						FROM_CMP_ID = <cfif len(from_cmp_id_)>#from_cmp_id_#<cfelse>NULL</cfif>,
						FROM_CONSUMER_ID = <cfif len(from_consumer_id_)>#from_consumer_id_#<cfelse>NULL</cfif>,
						FROM_EMPLOYEE_ID = <cfif len(from_employee_id_)>#from_employee_id_#<cfelse>NULL</cfif>,
						ACTION_DETAIL = '#attributes.detail#',
						ACTION_DATE = #attributes.revenue_date#,
						PAPER_NO = <cfif len(attributes.file_number)>'#attributes.file_number#'<cfelse>NULL</cfif>,
						TO_BRANCH_ID = <cfif isdefined("attributes.branch_id_borc") and len(attributes.branch_id_borc)>#attributes.branch_id_borc#<cfelse>NULL</cfif>,
						UPDATE_DATE = #now()#,
						UPDATE_EMP = #session.ep.userid#,
						UPDATE_IP =	'#cgi.remote_addr#'		
					WHERE 
						ACTION_ID = #get_action_id.cari_action_id#
				</cfquery>
			<cfelseif isdefined("get_acc_code.account_code2") and len(get_acc_code.account_code2)>
				<cfquery name="ADD_CARI_TO_CARI" datasource="#DSN2#" result="MAX_ID">
					INSERT INTO
						CARI_ACTIONS
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
						<cfif len(attributes.total_revenue)>#attributes.total_revenue#<cfelse>0</cfif>,
						'#attributes.money_currency#',
						<cfif len(attributes.detail)>'#attributes.detail#'<cfelse>NULL</cfif>,
						#attributes.revenue_date#,
						<cfif len(attributes.file_number)>'#attributes.file_number#'<cfelse>NULL</cfif>,
						#now()#,
						#session.ep.userid#,
						'#cgi.remote_addr#'	
					)					
				</cfquery>
				<cfset get_action_id.cari_action_id = MAX_ID.IDENTITYCOL>
			</cfif>
			<cfif IsDefined("attributes.acc_code") and len(attributes.acc_code)>	
				<cfset get_action_id.cari_action_id = attributes.id>
			</cfif>
			<cfquery name="upd_law_request" datasource="#dsn2#">
				UPDATE 
					#dsn_alias#.COMPANY_LAW_REQUEST
				SET
					<cfif isdefined("attributes.member_type") and attributes.member_type is 'partner'>
						COMPANY_ID = #attributes.member_id#,
						CONSUMER_ID = NULL,
					<cfelseif isdefined("attributes.member_type") and attributes.member_type is 'consumer'>
						CONSUMER_ID = #attributes.member_id#,
						COMPANY_ID = NULL,
					</cfif>	
					REQUEST_STATUS = <cfif isdefined("attributes.request_status")>1<cfelse>0</cfif>,
					PROCESS_STAGE = #attributes.process_stage#,
					DETAIL = <cfif len(attributes.detail)>'#attributes.detail#'<cfelse>NULL</cfif>,
					FILE_NUMBER = <cfif len(attributes.file_number)>'#attributes.file_number#'<cfelse>NULL</cfif>,
					FILE_STAGE = <cfif len(attributes.file_stage)>'#attributes.file_stage#'<cfelse>NULL</cfif>,
					LAW_STAGE = <cfif len(attributes.law_name)>'#attributes.law_name#'<cfelse>NULL</cfif>,
					LAW_ADWOCATE = <cfif len(attributes.law_adwocate_id) and len(attributes.law_adwocate)>'#attributes.law_adwocate_id#'<cfelse>NULL</cfif>,
                    LAW_ADWOCATE_COMPANY = <cfif isdefined("attributes.law_adwocate_comp") and len(attributes.law_adwocate_comp) and len(attributes.law_adwocate)>#attributes.law_adwocate_comp#<cfelse>NULL</cfif>,
					REVENUE_ADWOCATE = <cfif len(attributes.revenue_adwocate_id) and len(attributes.revenue_adwocate)>'#attributes.revenue_adwocate_id#'<cfelse>NULL</cfif>,
                    REVENUE_ADWOCATE_COMPANY = <cfif isdefined("attributes.revenue_adwocate_comp") and len(attributes.revenue_adwocate_comp) and len(attributes.revenue_adwocate)>#attributes.revenue_adwocate_comp#<cfelse>NULL</cfif>,
					REVENUE_DATE = #attributes.revenue_date#,
					TOTAL_AMOUNT = <cfif len(attributes.total_credit)>#attributes.total_credit#<cfelse>0</cfif>,
					MONEY_CURRENCY = '#attributes.money_currency#',
					TOTAL_REVENUE = <cfif len(attributes.total_revenue)>#attributes.total_revenue#<cfelse>0</cfif>,
					TOTAL_REVENUE_MONEY_CURRENCY = '#attributes.money_currency#',
					KALAN_REVENUE = <cfif len(attributes.kalan_revenue)>#attributes.kalan_revenue#<cfelse>0</cfif>,
					KALAN_REVENUE_MONEY_CURRENCY = '#attributes.money_currency#',
					<cfif len(attributes.obligee_company_id) and len(attributes.obligee_partner_id) and len(attributes.obligee_company)>
						OBLIGEE_COMPANY_ID = #attributes.obligee_company_id#,
						OBLIGEE_PARTNER_ID = #attributes.obligee_partner_id#,
						OBLIGEE_CONSUMER_ID = NULL,
					<cfelseif not (len(attributes.obligee_company_id) and len (attributes.obligee_partner_id)) and len(attributes.obligee_consumer_id) and len(attributes.obligee_company)>
						OBLIGEE_COMPANY_ID = NULL,
						OBLIGEE_PARTNER_ID = NULL,
						OBLIGEE_CONSUMER_ID = #attributes.obligee_consumer_id#,
					<cfelse>
						OBLIGEE_COMPANY_ID = NULL,
						OBLIGEE_PARTNER_ID = NULL,
						OBLIGEE_CONSUMER_ID = NULL,
					</cfif>
					OBLIGEE_DETAIL = <cfif len(attributes.obligee_detail)>'#attributes.obligee_detail#'<cfelse>NULL</cfif>,
					PROCESS_CAT = #process_cat#,
					UPDATE_DATE = #now()#,
					UPDATE_IP = '#cgi.remote_addr#',
					UPDATE_EMP = #session.ep.userid#,
					CARI_ACTION_ID = <cfif isdefined("get_acc_code.account_code2") and len(get_acc_code.account_code2)> #get_action_id.cari_action_id# <cfelse> NULL </cfif>,
					DEFAULT_RATE = <cfif IsDefined("attributes.default_rate") and len(attributes.default_rate)><cfqueryparam cfsqltype="cf_sql_float" value="#filterNum(attributes.default_rate)#"><cfelse><cfqueryparam cfsqltype="cf_sql_float" value="" null="yes"></cfif>,
					CREDIT_DATE = <cfif IsDefined("attributes.credite_date") and len(attributes.credite_date)><cfqueryparam cfsqltype="cf_sql_date" value="#attributes.credite_date#"><cfelse><cfqueryparam cfsqltype="cf_sql_date" value="" null="yes"></cfif>,
					ACCOUNT_CODE = <cfif IsDefined("attributes.acc_code") and len(attributes.acc_code)><cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.acc_code#"><cfelse><cfqueryparam cfsqltype="cf_sql_varchar" value="" null="yes"></cfif>
				WHERE
					LAW_REQUEST_ID = #attributes.id#
			</cfquery>
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
						act_other_money_value_ = attributes.total_revenue; // para değeri
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
							cari_sil(action_id:get_action_id.cari_action_id,process_type:process_type);
							carici
							(
								action_id : get_action_id.cari_action_id,
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
								rate2:paper_currency_multiplier
							);
							carici
							(
								action_id : get_action_id.cari_action_id,
								islem_belge_no : attributes.file_number,
								process_cat : attributes.process_cat,
								workcube_process_type : process_type,
								action_table : 'CARI_ACTIONS',
								islem_tutari : attributes.total_revenue,
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
								rate2:paper_currency_multiplier2
							);
					}
					else
					{
						cari_sil(action_id:get_action_id.cari_action_id,process_type:process_type);
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
								action_id : get_action_id.cari_action_id,
								belge_no : attributes.file_number,
								workcube_process_type : process_type,
								workcube_old_process_type:process_type,
								workcube_process_cat:attributes.process_cat,
								islem_tarihi : attributes.revenue_date,
								fis_detay : fis_detay, //Şüpheli Alacaklar ,CARİ VİRMAN
								fis_satir_detay: satir_detay_list,
								company_id : iif(attributes.member_type eq "partner",'attributes.member_id',de('')),
								consumer_id : iif(attributes.member_type eq "consumer",'attributes.member_id',de('')),
								employee_id : iif(attributes.member_type eq "",'attributes.member_id',de('')),
								borc_hesaplar : get_acc_code.account_code,
								borc_tutarlar : attributes.total_revenue,
								alacak_hesaplar : alacak_hesaplar,
								alacak_tutarlar :attributes.total_revenue,
								other_amount_alacak : iif(len(attributes.total_revenue),'attributes.total_revenue',de('')),
								other_currency_alacak : act_other_money_,
								other_amount_borc : attributes.total_revenue,
								other_currency_borc : act_other_money,
								currency_multiplier : currency_multiplier,
								to_branch_id : to_branch_id_info,
								from_branch_id : from_branch_id_info,
								acc_project_list_alacak : acc_project_list_alacak,
								acc_project_list_borc : acc_project_list_borc,
								account_card_type : 13,
								is_acc_type : 1
							);	
						}	
					}
					else
					{
						muhasebe_sil(action_id:get_action_id.cari_action_id,process_type:process_type);
					}
					f_kur_ekle_action(action_id:get_action_id.cari_action_id,process_type:0,action_table_name:'CARI_ACTION_MONEY',action_table_dsn:'#dsn2#');
				</cfscript>
			
			<!--- Seçilen çek ve senetler icra aşamasına gelecek --->
			<cfloop from="1" to="#attributes.record_num1#" index="i">
				<cfif isdefined("attributes.cheque_row1#i#")>
					<cfif evaluate("attributes.cheque_type1#i#") eq 1>
						<cfquery name="get_cheque" datasource="#dsn2#" maxrows="1">
							SELECT CHEQUE_STATUS_ID FROM CHEQUE WHERE CHEQUE_ID=#evaluate("attributes.id1#i#")#
						</cfquery>
						<cfif get_cheque.cheque_status_id neq 12>
							<cfquery name="upd_cheque" datasource="#dsn2#">
								UPDATE 
									CHEQUE
								SET
									CHEQUE_STATUS_ID = 12
								WHERE
									CHEQUE_ID= #evaluate("attributes.id1#i#")#
							</cfquery>
							<cfquery name="get_cheque" datasource="#dsn2#">
								SELECT * FROM CHEQUE WHERE CHEQUE_ID = #evaluate("attributes.id1#i#")#
							</cfquery>
							<cfquery name="add_history" datasource="#dsn2#">
								INSERT INTO
									CHEQUE_HISTORY
										(
											CHEQUE_ID,
											STATUS,
											ACT_DATE,
											OTHER_MONEY_VALUE,
											OTHER_MONEY,
											OTHER_MONEY_VALUE2,
											OTHER_MONEY2,
											RECORD_DATE
										)
									VALUES
										(
											#evaluate("attributes.id1#i#")#,
											12,
											#attributes.revenue_date#,
											<cfif len(get_cheque.OTHER_MONEY_VALUE)>#get_cheque.OTHER_MONEY_VALUE#,<cfelse>NULL,</cfif>
											<cfif len(get_cheque.OTHER_MONEY)>'#get_cheque.OTHER_MONEY#',<cfelse>NULL,</cfif>
											<cfif len(get_cheque.OTHER_MONEY_VALUE2)>#get_cheque.OTHER_MONEY_VALUE2#,<cfelse>NULL,</cfif>
											<cfif len(get_cheque.OTHER_MONEY2)>'#get_cheque.OTHER_MONEY2#',<cfelse>NULL,</cfif>
											#NOW()#
										)
							</cfquery>
						</cfif>
					<cfelse>
						<cfquery name="get_cheque" datasource="#dsn2#" maxrows="1">
							SELECT VOUCHER_STATUS_ID CHEQUE_STATUS_ID FROM VOUCHER WHERE VOUCHER_ID = #evaluate("attributes.id1#i#")#
						</cfquery>
						<cfif get_cheque.cheque_status_id neq 12>
							<cfquery name="upd_voucher" datasource="#dsn2#">
								UPDATE 
									VOUCHER
								SET
									VOUCHER_STATUS_ID = 12
								WHERE
									VOUCHER_ID= #evaluate("attributes.id1#i#")#
							</cfquery>
							<cfquery name="get_voucher" datasource="#dsn2#">
								SELECT * FROM VOUCHER WHERE VOUCHER_ID = #evaluate("attributes.id1#i#")#
							</cfquery>
							<cfquery name="add_history" datasource="#dsn2#">
								INSERT INTO
									VOUCHER_HISTORY
										(
											VOUCHER_ID,
											STATUS,
											ACT_DATE,
											OTHER_MONEY_VALUE,
											OTHER_MONEY,
											OTHER_MONEY_VALUE2,
											OTHER_MONEY2,
											RECORD_DATE
										)
									VALUES
										(
											#evaluate("attributes.id1#i#")#,
											12,
											#attributes.revenue_date#,
											<cfif len(get_voucher.OTHER_MONEY_VALUE)>#get_voucher.OTHER_MONEY_VALUE#,<cfelse>NULL,</cfif>
											<cfif len(get_voucher.OTHER_MONEY)>'#get_voucher.OTHER_MONEY#',<cfelse>NULL,</cfif>
											<cfif len(get_voucher.OTHER_MONEY_VALUE2)>#get_voucher.OTHER_MONEY_VALUE2#,<cfelse>NULL,</cfif>
											<cfif len(get_voucher.OTHER_MONEY2)>'#get_voucher.OTHER_MONEY2#',<cfelse>NULL,</cfif>
											#NOW()#
										)
							</cfquery>
						</cfif>
					</cfif>
				<cfelse>
					<cfif evaluate("attributes.cheque_type1#i#") eq 1>
						<cfquery name="get_cheque_first" datasource="#dsn2#" maxrows="1">
							SELECT STATUS FROM CHEQUE_HISTORY WHERE CHEQUE_ID=#evaluate("attributes.id1#i#")# AND STATUS = 12
						</cfquery>
						<cfquery name="get_cheque" datasource="#dsn2#" maxrows="1">
							SELECT OLD_STATUS FROM CHEQUE WHERE CHEQUE_ID=#evaluate("attributes.id1#i#")#
						</cfquery>
						<cfif get_cheque_first.recordcount>
							<cfquery name="get_cheque_hist" datasource="#dsn2#" maxrows="1">
								SELECT STATUS FROM CHEQUE_HISTORY WHERE CHEQUE_ID=#evaluate("attributes.id1#i#")# AND STATUS <> 12 ORDER BY RECORD_DATE DESC
							</cfquery>
							<cfif get_cheque_hist.recordcount>
								<cfset new_status = get_cheque_hist.status>
							<cfelseif len(get_cheque.old_status)>
								<cfset new_status = get_cheque.old_status>
							</cfif>
							<cfif isdefined("new_status")>
								<cfquery name="upd_cheque" datasource="#dsn2#">
									UPDATE CHEQUE SET CHEQUE_STATUS_ID=#new_status# WHERE CHEQUE_ID=#evaluate("attributes.id1#i#")#
								</cfquery>
								<cfquery name="get_cheque" datasource="#dsn2#">
									SELECT * FROM CHEQUE WHERE CHEQUE_ID = #evaluate("attributes.id1#i#")#
								</cfquery>
								<cfquery name="add_history" datasource="#dsn2#">
									INSERT INTO
										CHEQUE_HISTORY
											(
												CHEQUE_ID,
												STATUS,
												ACT_DATE,
												OTHER_MONEY_VALUE,
												OTHER_MONEY,
												OTHER_MONEY_VALUE2,
												OTHER_MONEY2,
												RECORD_DATE
											)
										VALUES
											(
												#evaluate("attributes.id1#i#")#,
												#new_status#,
												#attributes.revenue_date#,
												<cfif len(get_cheque.OTHER_MONEY_VALUE)>#get_cheque.OTHER_MONEY_VALUE#,<cfelse>NULL,</cfif>
												<cfif len(get_cheque.OTHER_MONEY)>'#get_cheque.OTHER_MONEY#',<cfelse>NULL,</cfif>
												<cfif len(get_cheque.OTHER_MONEY_VALUE2)>#get_cheque.OTHER_MONEY_VALUE2#,<cfelse>NULL,</cfif>
												<cfif len(get_cheque.OTHER_MONEY2)>'#get_cheque.OTHER_MONEY2#',<cfelse>NULL,</cfif>
												#NOW()#
											)
								</cfquery>
							</cfif>
						</cfif>
					<cfelse>
						<cfquery name="get_cheque_first" datasource="#dsn2#" maxrows="1">
							SELECT STATUS FROM VOUCHER_HISTORY WHERE VOUCHER_ID=#evaluate("attributes.id1#i#")# ORDER BY RECORD_DATE DESC
						</cfquery>
						<cfquery name="get_cheque" datasource="#dsn2#" maxrows="1">
							SELECT OLD_STATUS FROM VOUCHER WHERE VOUCHER_ID=#evaluate("attributes.id1#i#")#
						</cfquery>
						<cfif get_cheque_first.recordcount>
							<cfquery name="get_cheque_hist" datasource="#dsn2#" maxrows="1">
								SELECT STATUS FROM VOUCHER_HISTORY WHERE VOUCHER_ID=#evaluate("attributes.id1#i#")# AND STATUS <> 12 ORDER BY RECORD_DATE DESC
							</cfquery>
							<cfif get_cheque_hist.recordcount>
								<cfset new_status = get_cheque_hist.status>
							<cfelseif len(get_cheque.old_status)>
								<cfset new_status = get_cheque.old_status>
							</cfif>
							<cfif isdefined("new_status")>
								<cfquery name="upd_voucher" datasource="#dsn2#">
									UPDATE VOUCHER SET VOUCHER_STATUS_ID=#new_status# WHERE VOUCHER_ID=#evaluate("attributes.id1#i#")#
								</cfquery>
								<cfquery name="get_voucher" datasource="#dsn2#">
									SELECT * FROM VOUCHER WHERE VOUCHER_ID = #evaluate("attributes.id1#i#")#
								</cfquery>
								<cfquery name="add_history" datasource="#dsn2#">
									INSERT INTO
										VOUCHER_HISTORY
											(
												VOUCHER_ID,
												STATUS,
												ACT_DATE,
												OTHER_MONEY_VALUE,
												OTHER_MONEY,
												OTHER_MONEY_VALUE2,
												OTHER_MONEY2,
												RECORD_DATE
											)
										VALUES
											(
												#evaluate("attributes.id1#i#")#,
												#new_status#,
												#attributes.revenue_date#,
												<cfif len(get_voucher.OTHER_MONEY_VALUE)>#get_voucher.OTHER_MONEY_VALUE#,<cfelse>NULL,</cfif>
												<cfif len(get_voucher.OTHER_MONEY)>'#get_voucher.OTHER_MONEY#',<cfelse>NULL,</cfif>
												<cfif len(get_voucher.OTHER_MONEY_VALUE2)>#get_voucher.OTHER_MONEY_VALUE2#,<cfelse>NULL,</cfif>
												<cfif len(get_voucher.OTHER_MONEY2)>'#get_voucher.OTHER_MONEY2#',<cfelse>NULL,</cfif>
												#NOW()#
											)
								</cfquery>
							</cfif>
						</cfif>
					</cfif>
				</cfif>
			</cfloop>
			<cfloop from="1" to="#attributes.record_num1_2#" index="i">
				<cfif isdefined("attributes.cheque_row1_2#i#")>
					<cfif evaluate("attributes.cheque_type1_2#i#") eq 1>
						<cfquery name="get_cheque" datasource="#dsn2#" maxrows="1">
							SELECT CHEQUE_STATUS_ID FROM CHEQUE WHERE CHEQUE_ID = #evaluate("attributes.id1_2#i#")#
						</cfquery>
						<cfif get_cheque.cheque_status_id neq 12>
							<cfquery name="upd_cheque" datasource="#dsn2#">
								UPDATE 
									CHEQUE
								SET
									CHEQUE_STATUS_ID = 12
								WHERE
									CHEQUE_ID= #evaluate("attributes.id1_2#i#")#
							</cfquery>
							<cfquery name="get_cheque" datasource="#dsn2#">
								SELECT * FROM CHEQUE WHERE CHEQUE_ID = #evaluate("attributes.id1_2#i#")#
							</cfquery>
							<cfquery name="add_history" datasource="#dsn2#">
								INSERT INTO
									CHEQUE_HISTORY
										(
											CHEQUE_ID,
											STATUS,
											ACT_DATE,
											OTHER_MONEY_VALUE,
											OTHER_MONEY,
											OTHER_MONEY_VALUE2,
											OTHER_MONEY2,
											RECORD_DATE
										)
									VALUES
										(
											#evaluate("attributes.id1_2#i#")#,
											12,
											#attributes.revenue_date#,
											<cfif len(get_cheque.OTHER_MONEY_VALUE)>#get_cheque.OTHER_MONEY_VALUE#,<cfelse>NULL,</cfif>
											<cfif len(get_cheque.OTHER_MONEY)>'#get_cheque.OTHER_MONEY#',<cfelse>NULL,</cfif>
											<cfif len(get_cheque.OTHER_MONEY_VALUE2)>#get_cheque.OTHER_MONEY_VALUE2#,<cfelse>NULL,</cfif>
											<cfif len(get_cheque.OTHER_MONEY2)>'#get_cheque.OTHER_MONEY2#',<cfelse>NULL,</cfif>
											#NOW()#
										)
							</cfquery>
						</cfif>
					<cfelse>
						<cfquery name="get_cheque" datasource="#dsn2#" maxrows="1">
							SELECT VOUCHER_STATUS_ID CHEQUE_STATUS_ID FROM VOUCHER WHERE VOUCHER_ID = #evaluate("attributes.id1_2#i#")#
						</cfquery>
						<cfif get_cheque.cheque_status_id neq 12>
						<cfquery name="upd_voucher" datasource="#dsn2#">
							UPDATE 
								VOUCHER
							SET
								VOUCHER_STATUS_ID = 12
							WHERE
								VOUCHER_ID= #evaluate("attributes.id1_2#i#")#
						</cfquery>
						<cfquery name="get_voucher" datasource="#dsn2#">
							SELECT * FROM VOUCHER WHERE VOUCHER_ID = #evaluate("attributes.id1_2#i#")#
						</cfquery>
						<cfquery name="add_history" datasource="#dsn2#">
							INSERT INTO
								VOUCHER_HISTORY
									(
										VOUCHER_ID,
										STATUS,
										ACT_DATE,
										OTHER_MONEY_VALUE,
										OTHER_MONEY,
										OTHER_MONEY_VALUE2,
										OTHER_MONEY2,
										RECORD_DATE
									)
								VALUES
									(
										#evaluate("attributes.id1_2#i#")#,
										12,
										#attributes.revenue_date#,
										<cfif len(get_voucher.OTHER_MONEY_VALUE)>#get_voucher.OTHER_MONEY_VALUE#,<cfelse>NULL,</cfif>
										<cfif len(get_voucher.OTHER_MONEY)>'#get_voucher.OTHER_MONEY#',<cfelse>NULL,</cfif>
										<cfif len(get_voucher.OTHER_MONEY_VALUE2)>#get_voucher.OTHER_MONEY_VALUE2#,<cfelse>NULL,</cfif>
										<cfif len(get_voucher.OTHER_MONEY2)>'#get_voucher.OTHER_MONEY2#',<cfelse>NULL,</cfif>
										#NOW()#
									)
						</cfquery>
						</cfif>
					</cfif>
				<cfelse>
					<cfif evaluate("attributes.cheque_type1_2#i#") eq 1>
						<cfquery name="get_cheque_first" datasource="#dsn2#" maxrows="1">
							SELECT STATUS FROM CHEQUE_HISTORY WHERE CHEQUE_ID=#evaluate("attributes.id1_2#i#")# AND STATUS = 12
						</cfquery>
						<cfquery name="get_cheque" datasource="#dsn2#" maxrows="1">
							SELECT OLD_STATUS FROM CHEQUE WHERE CHEQUE_ID=#evaluate("attributes.id1_2#i#")#
						</cfquery>
						<cfif get_cheque_first.recordcount>
							<cfquery name="get_cheque_hist" datasource="#dsn2#" maxrows="1">
								SELECT STATUS FROM CHEQUE_HISTORY WHERE CHEQUE_ID=#evaluate("attributes.id1_2#i#")# AND STATUS <> 12 ORDER BY RECORD_DATE DESC
							</cfquery>
							<cfif get_cheque_hist.recordcount>
								<cfset new_status = get_cheque_hist.status>
							<cfelseif len(get_cheque.old_status)>
								<cfset new_status = get_cheque.old_status>
							</cfif>
							<cfif isdefined("new_status")>
								<cfquery name="upd_cheque" datasource="#dsn2#">
									UPDATE CHEQUE SET CHEQUE_STATUS_ID=#new_status# WHERE CHEQUE_ID=#evaluate("attributes.id1_2#i#")#
								</cfquery>
								<cfquery name="get_cheque" datasource="#dsn2#">
									SELECT * FROM CHEQUE WHERE CHEQUE_ID = #evaluate("attributes.id1_2#i#")#
								</cfquery>
								<cfquery name="add_history" datasource="#dsn2#">
									INSERT INTO
										CHEQUE_HISTORY
											(
												CHEQUE_ID,
												STATUS,
												ACT_DATE,
												OTHER_MONEY_VALUE,
												OTHER_MONEY,
												OTHER_MONEY_VALUE2,
												OTHER_MONEY2,
												RECORD_DATE
											)
										VALUES
											(
												#evaluate("attributes.id1_2#i#")#,
												#new_status#,
												#attributes.revenue_date#,
												<cfif len(get_cheque.OTHER_MONEY_VALUE)>#get_cheque.OTHER_MONEY_VALUE#,<cfelse>NULL,</cfif>
												<cfif len(get_cheque.OTHER_MONEY)>'#get_cheque.OTHER_MONEY#',<cfelse>NULL,</cfif>
												<cfif len(get_cheque.OTHER_MONEY_VALUE2)>#get_cheque.OTHER_MONEY_VALUE2#,<cfelse>NULL,</cfif>
												<cfif len(get_cheque.OTHER_MONEY2)>'#get_cheque.OTHER_MONEY2#',<cfelse>NULL,</cfif>
												#NOW()#
											)
								</cfquery>
							</cfif>
						</cfif>
					<cfelse>
						<cfquery name="get_cheque_first" datasource="#dsn2#" maxrows="1">
							SELECT STATUS FROM VOUCHER_HISTORY WHERE VOUCHER_ID=#evaluate("attributes.id1_2#i#")# ORDER BY RECORD_DATE DESC
						</cfquery>
						<cfquery name="get_cheque" datasource="#dsn2#" maxrows="1">
							SELECT OLD_STATUS FROM VOUCHER WHERE VOUCHER_ID=#evaluate("attributes.id1_2#i#")#
						</cfquery>
						<cfif get_cheque_first.recordcount>
							<cfquery name="get_cheque_hist" datasource="#dsn2#" maxrows="1">
								SELECT STATUS FROM VOUCHER_HISTORY WHERE VOUCHER_ID=#evaluate("attributes.id1_2#i#")# AND STATUS <> 12 ORDER BY RECORD_DATE DESC
							</cfquery>
							<cfif get_cheque_hist.recordcount>
								<cfset new_status = get_cheque_hist.status>
							<cfelseif len(get_cheque.old_status)>
								<cfset new_status = get_cheque.old_status>
							</cfif>
							<cfif isdefined("new_status")>
								<cfquery name="upd_voucher" datasource="#dsn2#">
									UPDATE VOUCHER SET VOUCHER_STATUS_ID=#new_status# WHERE VOUCHER_ID=#evaluate("attributes.id1_2#i#")#
								</cfquery>
								<cfquery name="get_voucher" datasource="#dsn2#">
									SELECT * FROM VOUCHER WHERE VOUCHER_ID = #evaluate("attributes.id1_2#i#")#
								</cfquery>
								<cfquery name="add_history" datasource="#dsn2#">
									INSERT INTO
										VOUCHER_HISTORY
											(
												VOUCHER_ID,
												STATUS,
												ACT_DATE,
												OTHER_MONEY_VALUE,
												OTHER_MONEY,
												OTHER_MONEY_VALUE2,
												OTHER_MONEY2,
												RECORD_DATE
											)
										VALUES
											(
												#evaluate("attributes.id1_2#i#")#,
												#new_status#,
												#attributes.revenue_date#,
												<cfif len(get_voucher.OTHER_MONEY_VALUE)>#get_voucher.OTHER_MONEY_VALUE#,<cfelse>NULL,</cfif>
												<cfif len(get_voucher.OTHER_MONEY)>'#get_voucher.OTHER_MONEY#',<cfelse>NULL,</cfif>
												<cfif len(get_voucher.OTHER_MONEY_VALUE2)>#get_voucher.OTHER_MONEY_VALUE2#,<cfelse>NULL,</cfif>
												<cfif len(get_voucher.OTHER_MONEY2)>'#get_voucher.OTHER_MONEY2#',<cfelse>NULL,</cfif>
												#NOW()#
											)
								</cfquery>
							</cfif>
						</cfif>
					</cfif>
				</cfif>
			</cfloop>
			<cfloop from="1" to="#attributes.record_num2#" index="i">
				<cfif isdefined("attributes.cheque_row2#i#")>
					<cfif evaluate("attributes.cheque_type2#i#") eq 1>
						<cfquery name="get_cheque" datasource="#dsn2#" maxrows="1">
							SELECT CHEQUE_STATUS_ID FROM CHEQUE WHERE CHEQUE_ID = #evaluate("attributes.id2#i#")#
						</cfquery>
						<cfif get_cheque.cheque_status_id neq 12>
						<cfquery name="upd_cheque" datasource="#dsn2#">
							UPDATE 
								CHEQUE
							SET
								CHEQUE_STATUS_ID = 12
							WHERE
								CHEQUE_ID= #evaluate("attributes.id2#i#")#
						</cfquery>
						<cfquery name="get_cheque" datasource="#dsn2#">
							SELECT * FROM CHEQUE WHERE CHEQUE_ID = #evaluate("attributes.id2#i#")#
						</cfquery>
						<cfquery name="add_history" datasource="#dsn2#">
							INSERT INTO
								CHEQUE_HISTORY
									(
										CHEQUE_ID,
										STATUS,
										ACT_DATE,
										OTHER_MONEY_VALUE,
										OTHER_MONEY,
										OTHER_MONEY_VALUE2,
										OTHER_MONEY2,
										RECORD_DATE
									)
								VALUES
									(
										#evaluate("attributes.id2#i#")#,
										12,
										#attributes.revenue_date#,
										<cfif len(get_cheque.OTHER_MONEY_VALUE)>#get_cheque.OTHER_MONEY_VALUE#,<cfelse>NULL,</cfif>
										<cfif len(get_cheque.OTHER_MONEY)>'#get_cheque.OTHER_MONEY#',<cfelse>NULL,</cfif>
										<cfif len(get_cheque.OTHER_MONEY_VALUE2)>#get_cheque.OTHER_MONEY_VALUE2#,<cfelse>NULL,</cfif>
										<cfif len(get_cheque.OTHER_MONEY2)>'#get_cheque.OTHER_MONEY2#',<cfelse>NULL,</cfif>
										#NOW()#
									)
						</cfquery>
						</cfif>
					<cfelse>
						<cfquery name="get_cheque" datasource="#dsn2#" maxrows="1">
							SELECT VOUCHER_STATUS_ID CHEQUE_STATUS_ID FROM VOUCHER WHERE VOUCHER_ID = #evaluate("attributes.id2#i#")#
						</cfquery>
						<cfif get_cheque.cheque_status_id neq 12>
						<cfquery name="upd_voucher" datasource="#dsn2#">
							UPDATE 
								VOUCHER
							SET
								VOUCHER_STATUS_ID = 12
							WHERE
								VOUCHER_ID= #evaluate("attributes.id2#i#")#
						</cfquery>
						<cfquery name="get_voucher" datasource="#dsn2#">
							SELECT * FROM VOUCHER WHERE VOUCHER_ID = #evaluate("attributes.id2#i#")#
						</cfquery>
						<cfquery name="add_history" datasource="#dsn2#">
							INSERT INTO
								VOUCHER_HISTORY
									(
										VOUCHER_ID,
										STATUS,
										ACT_DATE,
										OTHER_MONEY_VALUE,
										OTHER_MONEY,
										OTHER_MONEY_VALUE2,
										OTHER_MONEY2,
										RECORD_DATE
									)
								VALUES
									(
										#evaluate("attributes.id2#i#")#,
										12,
										#attributes.revenue_date#,
										<cfif len(get_voucher.OTHER_MONEY_VALUE)>#get_voucher.OTHER_MONEY_VALUE#,<cfelse>NULL,</cfif>
										<cfif len(get_voucher.OTHER_MONEY)>'#get_voucher.OTHER_MONEY#',<cfelse>NULL,</cfif>
										<cfif len(get_voucher.OTHER_MONEY_VALUE2)>#get_voucher.OTHER_MONEY_VALUE2#,<cfelse>NULL,</cfif>
										<cfif len(get_voucher.OTHER_MONEY2)>'#get_voucher.OTHER_MONEY2#',<cfelse>NULL,</cfif>
										#NOW()#
									)
						</cfquery>
						</cfif>
					</cfif>
				<cfelse>
					<cfif evaluate("attributes.cheque_type2#i#") eq 1>
						<cfquery name="get_cheque_first" datasource="#dsn2#" maxrows="1">
							SELECT STATUS FROM CHEQUE_HISTORY WHERE CHEQUE_ID=#evaluate("attributes.id2#i#")# AND STATUS = 12
						</cfquery>
						<cfquery name="get_cheque" datasource="#dsn2#" maxrows="1">
							SELECT OLD_STATUS FROM CHEQUE WHERE CHEQUE_ID=#evaluate("attributes.id2#i#")#
						</cfquery>
						<cfif get_cheque_first.recordcount>
							<cfquery name="get_cheque_hist" datasource="#dsn2#" maxrows="1">
								SELECT STATUS FROM CHEQUE_HISTORY WHERE CHEQUE_ID=#evaluate("attributes.id2#i#")# AND STATUS <> 12 ORDER BY RECORD_DATE DESC
							</cfquery>
							<cfif get_cheque_hist.recordcount>
								<cfset new_status = get_cheque_hist.status>
							<cfelseif len(get_cheque.old_status)>
								<cfset new_status = get_cheque.old_status>
							</cfif>
							<cfif isdefined("new_status")>
								<cfquery name="upd_cheque" datasource="#dsn2#">
									UPDATE CHEQUE SET CHEQUE_STATUS_ID=#new_status# WHERE CHEQUE_ID=#evaluate("attributes.id2#i#")#
								</cfquery>
								<cfquery name="get_cheque" datasource="#dsn2#">
									SELECT * FROM CHEQUE WHERE CHEQUE_ID = #evaluate("attributes.id2#i#")#
								</cfquery>
								<cfquery name="add_history" datasource="#dsn2#">
									INSERT INTO
										CHEQUE_HISTORY
											(
												CHEQUE_ID,
												STATUS,
												ACT_DATE,
												OTHER_MONEY_VALUE,
												OTHER_MONEY,
												OTHER_MONEY_VALUE2,
												OTHER_MONEY2,
												RECORD_DATE
											)
										VALUES
											(
												#evaluate("attributes.id2#i#")#,
												#new_status#,
												#attributes.revenue_date#,
												<cfif len(get_cheque.OTHER_MONEY_VALUE)>#get_cheque.OTHER_MONEY_VALUE#,<cfelse>NULL,</cfif>
												<cfif len(get_cheque.OTHER_MONEY)>'#get_cheque.OTHER_MONEY#',<cfelse>NULL,</cfif>
												<cfif len(get_cheque.OTHER_MONEY_VALUE2)>#get_cheque.OTHER_MONEY_VALUE2#,<cfelse>NULL,</cfif>
												<cfif len(get_cheque.OTHER_MONEY2)>'#get_cheque.OTHER_MONEY2#',<cfelse>NULL,</cfif>
												#NOW()#
											)
								</cfquery>
							</cfif>
						</cfif>
					<cfelse>
						<cfquery name="get_cheque_first" datasource="#dsn2#" maxrows="1">
							SELECT STATUS FROM VOUCHER_HISTORY WHERE VOUCHER_ID=#evaluate("attributes.id2#i#")# ORDER BY RECORD_DATE DESC
						</cfquery>
						<cfif get_cheque_first.recordcount>
							<cfquery name="get_cheque_hist" datasource="#dsn2#" maxrows="1">
								SELECT STATUS FROM VOUCHER_HISTORY WHERE VOUCHER_ID=#evaluate("attributes.id2#i#")# AND STATUS <> 12 ORDER BY RECORD_DATE DESC
							</cfquery>
							<cfif get_cheque_hist.recordcount>
								<cfset new_status = get_cheque_hist.status>
							<cfelseif len(get_cheque_first.old_status)>
								<cfset new_status = get_cheque_first.old_status>
							</cfif>
							<cfif isdefined("new_status")>
								<cfquery name="upd_voucher" datasource="#dsn2#">
									UPDATE VOUCHER SET VOUCHER_STATUS_ID=#new_status# WHERE VOUCHER_ID=#evaluate("attributes.id2#i#")#
								</cfquery>
								<cfquery name="get_voucher" datasource="#dsn2#">
									SELECT * FROM VOUCHER WHERE VOUCHER_ID = #evaluate("attributes.id2#i#")#
								</cfquery>
								<cfquery name="add_history" datasource="#dsn2#">
									INSERT INTO
										VOUCHER_HISTORY
											(
												VOUCHER_ID,
												STATUS,
												ACT_DATE,
												OTHER_MONEY_VALUE,
												OTHER_MONEY,
												OTHER_MONEY_VALUE2,
												OTHER_MONEY2,
												RECORD_DATE
											)
										VALUES
											(
												#evaluate("attributes.id2#i#")#,
												#new_status#,
												#attributes.revenue_date#,
												<cfif len(get_voucher.OTHER_MONEY_VALUE)>#get_voucher.OTHER_MONEY_VALUE#,<cfelse>NULL,</cfif>
												<cfif len(get_voucher.OTHER_MONEY)>'#get_voucher.OTHER_MONEY#',<cfelse>NULL,</cfif>
												<cfif len(get_voucher.OTHER_MONEY_VALUE2)>#get_voucher.OTHER_MONEY_VALUE2#,<cfelse>NULL,</cfif>
												<cfif len(get_voucher.OTHER_MONEY2)>'#get_voucher.OTHER_MONEY2#',<cfelse>NULL,</cfif>
												#NOW()#
											)
								</cfquery>
							</cfif>
						</cfif>
					</cfif>
				</cfif>
			</cfloop>
			<cfloop from="1" to="#attributes.record_num2_2#" index="i">
				<cfif isdefined("attributes.cheque_row2_2#i#")>
					<cfif evaluate("attributes.cheque_type2_2#i#") eq 1>
						<cfquery name="get_cheque" datasource="#dsn2#" maxrows="1">
							SELECT CHEQUE_STATUS_ID FROM CHEQUE WHERE CHEQUE_ID = #evaluate("attributes.id2_2#i#")#
						</cfquery>
						<cfif get_cheque.cheque_status_id neq 12>
						<cfquery name="upd_cheque" datasource="#dsn2#">
							UPDATE 
								CHEQUE
							SET
								CHEQUE_STATUS_ID = 12
							WHERE
								CHEQUE_ID= #evaluate("attributes.id2_2#i#")#
						</cfquery>
						<cfquery name="get_cheque" datasource="#dsn2#">
							SELECT * FROM CHEQUE WHERE CHEQUE_ID = #evaluate("attributes.id2_2#i#")#
						</cfquery>
						<cfquery name="add_history" datasource="#dsn2#">
							INSERT INTO
								CHEQUE_HISTORY
									(
										CHEQUE_ID,
										STATUS,
										ACT_DATE,
										OTHER_MONEY_VALUE,
										OTHER_MONEY,
										OTHER_MONEY_VALUE2,
										OTHER_MONEY2,
										RECORD_DATE
									)
								VALUES
									(
										#evaluate("attributes.id2_2#i#")#,
										12,
										#attributes.revenue_date#,
										<cfif len(get_cheque.OTHER_MONEY_VALUE)>#get_cheque.OTHER_MONEY_VALUE#,<cfelse>NULL,</cfif>
										<cfif len(get_cheque.OTHER_MONEY)>'#get_cheque.OTHER_MONEY#',<cfelse>NULL,</cfif>
										<cfif len(get_cheque.OTHER_MONEY_VALUE2)>#get_cheque.OTHER_MONEY_VALUE2#,<cfelse>NULL,</cfif>
										<cfif len(get_cheque.OTHER_MONEY2)>'#get_cheque.OTHER_MONEY2#',<cfelse>NULL,</cfif>
										#NOW()#
									)
						</cfquery>
						</cfif>
					<cfelse>
						<cfquery name="get_cheque" datasource="#dsn2#" maxrows="1">
							SELECT VOUCHER_STATUS_ID CHEQUE_STATUS_ID FROM VOUCHER WHERE VOUCHER_ID = #evaluate("attributes.id2_2#i#")#
						</cfquery>
						<cfif get_cheque.cheque_status_id neq 12>
						<cfquery name="upd_voucher" datasource="#dsn2#">
							UPDATE 
								VOUCHER
							SET
								VOUCHER_STATUS_ID = 12
							WHERE
								VOUCHER_ID= #evaluate("attributes.id2_2#i#")#
						</cfquery>
						<cfquery name="get_voucher" datasource="#dsn2#">
							SELECT * FROM VOUCHER WHERE VOUCHER_ID = #evaluate("attributes.id2_2#i#")#
						</cfquery>
						<cfquery name="add_history" datasource="#dsn2#">
							INSERT INTO
								VOUCHER_HISTORY
									(
										VOUCHER_ID,
										STATUS,
										ACT_DATE,
										OTHER_MONEY_VALUE,
										OTHER_MONEY,
										OTHER_MONEY_VALUE2,
										OTHER_MONEY2,
										RECORD_DATE
									)
								VALUES
									(
										#evaluate("attributes.id2_2#i#")#,
										12,
										#attributes.revenue_date#,
										<cfif len(get_voucher.OTHER_MONEY_VALUE)>#get_voucher.OTHER_MONEY_VALUE#,<cfelse>NULL,</cfif>
										<cfif len(get_voucher.OTHER_MONEY)>'#get_voucher.OTHER_MONEY#',<cfelse>NULL,</cfif>
										<cfif len(get_voucher.OTHER_MONEY_VALUE2)>#get_voucher.OTHER_MONEY_VALUE2#,<cfelse>NULL,</cfif>
										<cfif len(get_voucher.OTHER_MONEY2)>'#get_voucher.OTHER_MONEY2#',<cfelse>NULL,</cfif>
										#NOW()#
									)
						</cfquery>
						</cfif>
					</cfif>
				<cfelse>
					<cfif evaluate("attributes.cheque_type2_2#i#") eq 1>
						<cfquery name="get_cheque_first" datasource="#dsn2#" maxrows="1">
							SELECT STATUS FROM CHEQUE_HISTORY WHERE CHEQUE_ID=#evaluate("attributes.id2_2#i#")# AND STATUS = 12
						</cfquery>
						<cfquery name="get_cheque" datasource="#dsn2#" maxrows="1">
							SELECT OLD_STATUS FROM CHEQUE WHERE CHEQUE_ID=#evaluate("attributes.id2_2#i#")#
						</cfquery>
						<cfif get_cheque_first.recordcount>
							<cfquery name="get_cheque_hist" datasource="#dsn2#" maxrows="1">
								SELECT STATUS FROM CHEQUE_HISTORY WHERE CHEQUE_ID=#evaluate("attributes.id2_2#i#")# AND STATUS <> 12 ORDER BY RECORD_DATE DESC
							</cfquery>
							<cfif get_cheque_hist.recordcount>
								<cfset new_status = get_cheque_hist.status>
							<cfelseif len(get_cheque.old_status)>
								<cfset new_status = get_cheque.old_status>
							</cfif>
							<cfif isdefined("new_status")>
								<cfquery name="upd_cheque" datasource="#dsn2#">
									UPDATE CHEQUE SET CHEQUE_STATUS_ID=#new_status# WHERE CHEQUE_ID=#evaluate("attributes.id2_2#i#")#
								</cfquery>
								<cfquery name="get_cheque" datasource="#dsn2#">
									SELECT * FROM CHEQUE WHERE CHEQUE_ID = #evaluate("attributes.id2_2#i#")#
								</cfquery>
								<cfquery name="add_history" datasource="#dsn2#">
									INSERT INTO
										CHEQUE_HISTORY
											(
												CHEQUE_ID,
												STATUS,
												ACT_DATE,
												OTHER_MONEY_VALUE,
												OTHER_MONEY,
												OTHER_MONEY_VALUE2,
												OTHER_MONEY2,
												RECORD_DATE
											)
										VALUES
											(
												#evaluate("attributes.id2_2#i#")#,
												#new_status#,
												#attributes.revenue_date#,
												<cfif len(get_cheque.OTHER_MONEY_VALUE)>#get_cheque.OTHER_MONEY_VALUE#,<cfelse>NULL,</cfif>
												<cfif len(get_cheque.OTHER_MONEY)>'#get_cheque.OTHER_MONEY#',<cfelse>NULL,</cfif>
												<cfif len(get_cheque.OTHER_MONEY_VALUE2)>#get_cheque.OTHER_MONEY_VALUE2#,<cfelse>NULL,</cfif>
												<cfif len(get_cheque.OTHER_MONEY2)>'#get_cheque.OTHER_MONEY2#',<cfelse>NULL,</cfif>
												#NOW()#
											)
								</cfquery>
							</cfif>
						</cfif>
					<cfelse>
						<cfquery name="get_cheque_first" datasource="#dsn2#" maxrows="1">
							SELECT STATUS FROM VOUCHER_HISTORY WHERE VOUCHER_ID=#evaluate("attributes.id2_2#i#")# ORDER BY RECORD_DATE DESC
						</cfquery>
						<cfquery name="get_cheque" datasource="#dsn2#" maxrows="1">
							SELECT OLD_STATUS FROM VOUCHER WHERE VOUCHER_ID=#evaluate("attributes.id2_2#i#")#
						</cfquery>
						<cfif get_cheque_first.recordcount>
							<cfquery name="get_cheque_hist" datasource="#dsn2#" maxrows="1">
								SELECT STATUS FROM VOUCHER_HISTORY WHERE VOUCHER_ID=#evaluate("attributes.id2_2#i#")# AND STATUS <> 12 ORDER BY RECORD_DATE DESC
							</cfquery>
							<cfif get_cheque_hist.recordcount>
								<cfset new_status = get_cheque_hist.status>
							<cfelseif len(get_cheque.old_status)>
								<cfset new_status = get_cheque.old_status>
							</cfif>
							<cfif isdefined("new_status")>
								<cfquery name="upd_voucher" datasource="#dsn2#">
									UPDATE VOUCHER SET VOUCHER_STATUS_ID=#new_status# WHERE VOUCHER_ID=#evaluate("attributes.id2_2#i#")#
								</cfquery>
								<cfquery name="get_voucher" datasource="#dsn2#">
									SELECT * FROM VOUCHER WHERE VOUCHER_ID = #evaluate("attributes.id2_2#i#")#
								</cfquery>
								<cfquery name="add_history" datasource="#dsn2#">
									INSERT INTO
										VOUCHER_HISTORY
											(
												VOUCHER_ID,
												STATUS,
												ACT_DATE,
												OTHER_MONEY_VALUE,
												OTHER_MONEY,
												OTHER_MONEY_VALUE2,
												OTHER_MONEY2,
												RECORD_DATE
											)
										VALUES
											(
												#evaluate("attributes.id2_2#i#")#,
												#new_status#,
												#attributes.revenue_date#,
												<cfif len(get_voucher.OTHER_MONEY_VALUE)>#get_voucher.OTHER_MONEY_VALUE#,<cfelse>NULL,</cfif>
												<cfif len(get_voucher.OTHER_MONEY)>'#get_voucher.OTHER_MONEY#',<cfelse>NULL,</cfif>
												<cfif len(get_voucher.OTHER_MONEY_VALUE2)>#get_voucher.OTHER_MONEY_VALUE2#,<cfelse>NULL,</cfif>
												<cfif len(get_voucher.OTHER_MONEY2)>'#get_voucher.OTHER_MONEY2#',<cfelse>NULL,</cfif>
												#NOW()#
											)
								</cfquery>
							</cfif>
						</cfif>
					</cfif>
				</cfif>
			</cfloop>
			<cf_workcube_process is_upd='1' 
					data_source='#dsn2#' 
					old_process_line='#attributes.old_process_line#'
					process_stage='#attributes.process_stage#' 
					record_member='#session.ep.userid#'
					record_date='#now()#' 
					action_table='COMPANY_LAW_REQUEST'
					action_column='LAW_REQUEST_ID'
					action_id='#attributes.id#' 
					action_page='#request.self#?fuseaction=ch.form_upd_law_request&id=#attributes.id#' 
					warning_description='İcra Takip : #attributes.id#'>
			<script type="text/javascript">
				window.location.href='<cfoutput>#request.self#?fuseaction=ch.list_law_request&event=upd&id=#attributes.id#</cfoutput>';
			</script>
		<cfelse>
			<cfquery name="del_law_request" datasource="#dsn2#">
				DELETE FROM #dsn_alias#.COMPANY_LAW_REQUEST WHERE LAW_REQUEST_ID = #attributes.del_req_id#
			</cfquery>
			<cfif IsDefined("get_acc_code.account_code2") and len(get_acc_code.account_code2)>
				<cfquery name="del_law_request" datasource="#dsn2#">
					DELETE FROM CARI_ACTIONS WHERE ACTION_ID = #get_action_id.cari_action_id#
				</cfquery>
				<cfscript>
					cari_sil(action_id:get_action_id.cari_action_id,process_type:process_type);
					muhasebe_sil(action_id:get_action_id.cari_action_id,process_type:process_type);
				</cfscript>
			<cfelse>
				<cfscript> muhasebe_sil(action_id:attributes.del_req_id,process_type:process_type);</cfscript>
			</cfif>
			<cfloop from="1" to="#attributes.record_num1#" index="i">
				<cfif not isdefined("attributes.cheque_row1#i#")>
				<cfif evaluate("attributes.cheque_type1#i#") eq 1>
					<cfquery name="get_cheque_first" datasource="#dsn2#" maxrows="1">
						SELECT STATUS FROM CHEQUE_HISTORY WHERE CHEQUE_ID=#evaluate("attributes.id1#i#")# AND STATUS = 12
					</cfquery>
					<cfquery name="get_cheque" datasource="#dsn2#" maxrows="1">
						SELECT OLD_STATUS FROM CHEQUE WHERE CHEQUE_ID=#evaluate("attributes.id1#i#")#
					</cfquery>
					<cfif get_cheque_first.recordcount>
						<cfquery name="get_cheque_hist" datasource="#dsn2#" maxrows="1">
							SELECT STATUS FROM CHEQUE_HISTORY WHERE CHEQUE_ID=#evaluate("attributes.id1#i#")# AND STATUS <> 12 ORDER BY RECORD_DATE DESC
						</cfquery>
						<cfif get_cheque_hist.recordcount>
							<cfset new_status = get_cheque_hist.status>
						<cfelseif len(get_cheque.old_status)>
							<cfset new_status = get_cheque.old_status>
						</cfif>
						<cfif isdefined("new_status")>
							<cfquery name="upd_cheque" datasource="#dsn2#">
								UPDATE CHEQUE SET CHEQUE_STATUS_ID=#new_status# WHERE CHEQUE_ID=#evaluate("attributes.id1#i#")#
							</cfquery>
							<cfquery name="get_cheque" datasource="#dsn2#">
								SELECT * FROM CHEQUE WHERE CHEQUE_ID = #evaluate("attributes.id1#i#")#
							</cfquery>
							<cfquery name="add_history" datasource="#dsn2#">
								INSERT INTO
									CHEQUE_HISTORY
										(
											CHEQUE_ID,
											STATUS,
											ACT_DATE,
											OTHER_MONEY_VALUE,
											OTHER_MONEY,
											OTHER_MONEY_VALUE2,
											OTHER_MONEY2,
											RECORD_DATE
										)
									VALUES
										(
											#evaluate("attributes.id1#i#")#,
											#new_status#,
											#attributes.revenue_date#,
											<cfif len(get_cheque.OTHER_MONEY_VALUE)>#get_cheque.OTHER_MONEY_VALUE#,<cfelse>NULL,</cfif>
											<cfif len(get_cheque.OTHER_MONEY)>'#get_cheque.OTHER_MONEY#',<cfelse>NULL,</cfif>
											<cfif len(get_cheque.OTHER_MONEY_VALUE2)>#get_cheque.OTHER_MONEY_VALUE2#,<cfelse>NULL,</cfif>
											<cfif len(get_cheque.OTHER_MONEY2)>'#get_cheque.OTHER_MONEY2#',<cfelse>NULL,</cfif>
											#NOW()#
										)
							</cfquery>
						</cfif>
					</cfif>
				<cfelse>
					<cfquery name="get_cheque_first" datasource="#dsn2#" maxrows="1">
						SELECT STATUS FROM VOUCHER_HISTORY WHERE VOUCHER_ID=#evaluate("attributes.id1#i#")# ORDER BY RECORD_DATE DESC
					</cfquery>
					<cfquery name="get_cheque" datasource="#dsn2#" maxrows="1">
						SELECT OLD_STATUS FROM VOUCHER WHERE VOUCHER_ID=#evaluate("attributes.id1#i#")#
					</cfquery>
					<cfif get_cheque_first.recordcount>
						<cfquery name="get_cheque_hist" datasource="#dsn2#" maxrows="1">
							SELECT STATUS FROM VOUCHER_HISTORY WHERE VOUCHER_ID=#evaluate("attributes.id1#i#")# AND STATUS <> 12 ORDER BY RECORD_DATE DESC
						</cfquery>
						<cfif get_cheque_hist.recordcount>
							<cfset new_status = get_cheque_hist.status>
						<cfelseif len(get_cheque.old_status)>
							<cfset new_status = get_cheque.old_status>
						</cfif>
						<cfif isdefined("new_status")>
							<cfquery name="upd_voucher" datasource="#dsn2#">
								UPDATE VOUCHER SET VOUCHER_STATUS_ID=#new_status# WHERE VOUCHER_ID=#evaluate("attributes.id1#i#")#
							</cfquery>
							<cfquery name="get_voucher" datasource="#dsn2#">
								SELECT * FROM VOUCHER WHERE VOUCHER_ID = #evaluate("attributes.id1#i#")#
							</cfquery>
							<cfquery name="add_history" datasource="#dsn2#">
								INSERT INTO
									VOUCHER_HISTORY
										(
											VOUCHER_ID,
											STATUS,
											ACT_DATE,
											OTHER_MONEY_VALUE,
											OTHER_MONEY,
											OTHER_MONEY_VALUE2,
											OTHER_MONEY2,
											RECORD_DATE
										)
									VALUES
										(
											#evaluate("attributes.id1#i#")#,
											#new_status#,
											#attributes.revenue_date#,
											<cfif len(get_voucher.OTHER_MONEY_VALUE)>#get_voucher.OTHER_MONEY_VALUE#,<cfelse>NULL,</cfif>
											<cfif len(get_voucher.OTHER_MONEY)>'#get_voucher.OTHER_MONEY#',<cfelse>NULL,</cfif>
											<cfif len(get_voucher.OTHER_MONEY_VALUE2)>#get_voucher.OTHER_MONEY_VALUE2#,<cfelse>NULL,</cfif>
											<cfif len(get_voucher.OTHER_MONEY2)>'#get_voucher.OTHER_MONEY2#',<cfelse>NULL,</cfif>
											#NOW()#
										)
							</cfquery>
						</cfif>
					</cfif>
				</cfif>
				</cfif>
			</cfloop>
			<cfloop from="1" to="#attributes.record_num1_2#" index="i">
				<cfif not isdefined("attributes.cheque_row1_2#i#")>
				<cfif evaluate("attributes.cheque_type1_2#i#") eq 1>
					<cfquery name="get_cheque_first" datasource="#dsn2#" maxrows="1">
						SELECT STATUS FROM CHEQUE_HISTORY WHERE CHEQUE_ID=#evaluate("attributes.id1_2#i#")# AND STATUS = 12
					</cfquery>
					<cfquery name="get_cheque" datasource="#dsn2#" maxrows="1">
						SELECT OLD_STATUS FROM CHEQUE WHERE CHEQUE_ID=#evaluate("attributes.id1_2#i#")#
					</cfquery>
					<cfif get_cheque_first.recordcount>
						<cfquery name="get_cheque_hist" datasource="#dsn2#" maxrows="1">
							SELECT STATUS FROM CHEQUE_HISTORY WHERE CHEQUE_ID=#evaluate("attributes.id1_2#i#")# AND STATUS <> 12 ORDER BY RECORD_DATE DESC
						</cfquery>
						<cfif get_cheque_hist.recordcount>
							<cfset new_status = get_cheque_hist.status>
						<cfelseif len(get_cheque.old_status)>
							<cfset new_status = get_cheque.old_status>
						</cfif>
						<cfif isdefined("new_status")>
							<cfquery name="upd_cheque" datasource="#dsn2#">
								UPDATE CHEQUE SET CHEQUE_STATUS_ID=#new_status# WHERE CHEQUE_ID=#evaluate("attributes.id1_2#i#")#
							</cfquery>
							<cfquery name="get_cheque" datasource="#dsn2#">
								SELECT * FROM CHEQUE WHERE CHEQUE_ID = #evaluate("attributes.id1_2#i#")#
							</cfquery>
							<cfquery name="add_history" datasource="#dsn2#">
								INSERT INTO
									CHEQUE_HISTORY
										(
											CHEQUE_ID,
											STATUS,
											ACT_DATE,
											OTHER_MONEY_VALUE,
											OTHER_MONEY,
											OTHER_MONEY_VALUE2,
											OTHER_MONEY2,
											RECORD_DATE
										)
									VALUES
										(
											#evaluate("attributes.id1_2#i#")#,
											#new_status#,
											#attributes.revenue_date#,
											<cfif len(get_cheque.OTHER_MONEY_VALUE)>#get_cheque.OTHER_MONEY_VALUE#,<cfelse>NULL,</cfif>
											<cfif len(get_cheque.OTHER_MONEY)>'#get_cheque.OTHER_MONEY#',<cfelse>NULL,</cfif>
											<cfif len(get_cheque.OTHER_MONEY_VALUE2)>#get_cheque.OTHER_MONEY_VALUE2#,<cfelse>NULL,</cfif>
											<cfif len(get_cheque.OTHER_MONEY2)>'#get_cheque.OTHER_MONEY2#',<cfelse>NULL,</cfif>
											#NOW()#
										)
							</cfquery>
						</cfif>
					</cfif>
				<cfelse>
					<cfquery name="get_cheque_first" datasource="#dsn2#" maxrows="1">
						SELECT STATUS FROM VOUCHER_HISTORY WHERE VOUCHER_ID=#evaluate("attributes.id1_2#i#")# ORDER BY RECORD_DATE DESC
					</cfquery>
					<cfquery name="get_cheque" datasource="#dsn2#" maxrows="1">
						SELECT OLD_STATUS FROM VOUCHER WHERE VOUCHER_ID=#evaluate("attributes.id1_2#i#")#
					</cfquery>
					<cfif get_cheque_first.recordcount>
						<cfquery name="get_cheque_hist" datasource="#dsn2#" maxrows="1">
							SELECT STATUS FROM VOUCHER_HISTORY WHERE VOUCHER_ID=#evaluate("attributes.id1_2#i#")# AND STATUS <> 12 ORDER BY RECORD_DATE DESC
						</cfquery>
						<cfif get_cheque_hist.recordcount>
							<cfset new_status = get_cheque_hist.status>
						<cfelseif len(get_cheque.old_status)>
							<cfset new_status = get_cheque.old_status>
						</cfif>
						<cfif isdefined("new_status")>
							<cfquery name="upd_voucher" datasource="#dsn2#">
								UPDATE VOUCHER SET VOUCHER_STATUS_ID=#new_status# WHERE VOUCHER_ID=#evaluate("attributes.id1_2#i#")#
							</cfquery>
							<cfquery name="get_voucher" datasource="#dsn2#">
								SELECT * FROM VOUCHER WHERE VOUCHER_ID = #evaluate("attributes.id1_2#i#")#
							</cfquery>
							<cfquery name="add_history" datasource="#dsn2#">
								INSERT INTO
									VOUCHER_HISTORY
										(
											VOUCHER_ID,
											STATUS,
											ACT_DATE,
											OTHER_MONEY_VALUE,
											OTHER_MONEY,
											OTHER_MONEY_VALUE2,
											OTHER_MONEY2,
											RECORD_DATE
										)
									VALUES
										(
											#evaluate("attributes.id1_2#i#")#,
											#new_status#,
											#attributes.revenue_date#,
											<cfif len(get_voucher.OTHER_MONEY_VALUE)>#get_voucher.OTHER_MONEY_VALUE#,<cfelse>NULL,</cfif>
											<cfif len(get_voucher.OTHER_MONEY)>'#get_voucher.OTHER_MONEY#',<cfelse>NULL,</cfif>
											<cfif len(get_voucher.OTHER_MONEY_VALUE2)>#get_voucher.OTHER_MONEY_VALUE2#,<cfelse>NULL,</cfif>
											<cfif len(get_voucher.OTHER_MONEY2)>'#get_voucher.OTHER_MONEY2#',<cfelse>NULL,</cfif>
											#NOW()#
										)
							</cfquery>
						</cfif>
					</cfif>
				</cfif>
				</cfif>
			</cfloop>
			<cfloop from="1" to="#attributes.record_num2#" index="i">
				<cfif not isdefined("attributes.cheque_row2#i#")>
				<cfif evaluate("attributes.cheque_type2#i#") eq 1>
					<cfquery name="get_cheque_first" datasource="#dsn2#" maxrows="1">
						SELECT STATUS FROM CHEQUE_HISTORY WHERE CHEQUE_ID=#evaluate("attributes.id2#i#")# AND STATUS = 12
					</cfquery>
					<cfquery name="get_cheque" datasource="#dsn2#" maxrows="1">
						SELECT OLD_STATUS FROM CHEQUE WHERE CHEQUE_ID=#evaluate("attributes.id2#i#")#
					</cfquery>
					<cfif get_cheque_first.recordcount>
						<cfquery name="get_cheque_hist" datasource="#dsn2#" maxrows="1">
							SELECT STATUS FROM CHEQUE_HISTORY WHERE CHEQUE_ID=#evaluate("attributes.id2#i#")# AND STATUS <> 12 ORDER BY RECORD_DATE DESC
						</cfquery>
						<cfif get_cheque_hist.recordcount>
							<cfset new_status = get_cheque_hist.status>
						<cfelseif len(get_cheque.old_status)>
							<cfset new_status = get_cheque.old_status>
						</cfif>
						<cfif isdefined("new_status")>
							<cfquery name="upd_cheque" datasource="#dsn2#">
								UPDATE CHEQUE SET CHEQUE_STATUS_ID=#new_status# WHERE CHEQUE_ID=#evaluate("attributes.id2#i#")#
							</cfquery>
							<cfquery name="get_cheque" datasource="#dsn2#">
								SELECT * FROM CHEQUE WHERE CHEQUE_ID = #evaluate("attributes.id2#i#")#
							</cfquery>
							<cfquery name="add_history" datasource="#dsn2#">
								INSERT INTO
									CHEQUE_HISTORY
										(
											CHEQUE_ID,
											STATUS,
											ACT_DATE,
											OTHER_MONEY_VALUE,
											OTHER_MONEY,
											OTHER_MONEY_VALUE2,
											OTHER_MONEY2,
											RECORD_DATE
										)
									VALUES
										(
											#evaluate("attributes.id2#i#")#,
											#new_status#,
											#attributes.revenue_date#,
											<cfif len(get_cheque.OTHER_MONEY_VALUE)>#get_cheque.OTHER_MONEY_VALUE#,<cfelse>NULL,</cfif>
											<cfif len(get_cheque.OTHER_MONEY)>'#get_cheque.OTHER_MONEY#',<cfelse>NULL,</cfif>
											<cfif len(get_cheque.OTHER_MONEY_VALUE2)>#get_cheque.OTHER_MONEY_VALUE2#,<cfelse>NULL,</cfif>
											<cfif len(get_cheque.OTHER_MONEY2)>'#get_cheque.OTHER_MONEY2#',<cfelse>NULL,</cfif>
											#NOW()#
										)
							</cfquery>
						</cfif>
					</cfif>
				<cfelse>
					<cfquery name="get_cheque_first" datasource="#dsn2#" maxrows="1">
						SELECT STATUS FROM VOUCHER_HISTORY WHERE VOUCHER_ID=#evaluate("attributes.id2#i#")# ORDER BY RECORD_DATE DESC
					</cfquery>
					<cfquery name="get_cheque" datasource="#dsn2#" maxrows="1">
						SELECT OLD_STATUS FROM VOUCHER WHERE VOUCHER_ID=#evaluate("attributes.id2#i#")#
					</cfquery>
					<cfif get_cheque_first.recordcount>
						<cfquery name="get_cheque_hist" datasource="#dsn2#" maxrows="1">
							SELECT STATUS FROM VOUCHER_HISTORY WHERE VOUCHER_ID=#evaluate("attributes.id2#i#")# AND STATUS <> 12 ORDER BY RECORD_DATE DESC
						</cfquery>
						<cfif get_cheque_hist.recordcount>
							<cfset new_status = get_cheque_hist.status>
						<cfelseif len(get_cheque.old_status)>
							<cfset new_status = get_cheque.old_status>
						</cfif>
						<cfif isdefined("new_status")>
							<cfquery name="upd_voucher" datasource="#dsn2#">
								UPDATE VOUCHER SET VOUCHER_STATUS_ID=#new_status# WHERE VOUCHER_ID=#evaluate("attributes.id2#i#")#
							</cfquery>
							<cfquery name="get_voucher" datasource="#dsn2#">
								SELECT * FROM VOUCHER WHERE VOUCHER_ID = #evaluate("attributes.id2#i#")#
							</cfquery>
							<cfquery name="add_history" datasource="#dsn2#">
								INSERT INTO
									VOUCHER_HISTORY
										(
											VOUCHER_ID,
											STATUS,
											ACT_DATE,
											OTHER_MONEY_VALUE,
											OTHER_MONEY,
											OTHER_MONEY_VALUE2,
											OTHER_MONEY2,
											RECORD_DATE
										)
									VALUES
										(
											#evaluate("attributes.id2#i#")#,
											#new_status#,
											#attributes.revenue_date#,
											<cfif len(get_voucher.OTHER_MONEY_VALUE)>#get_voucher.OTHER_MONEY_VALUE#,<cfelse>NULL,</cfif>
											<cfif len(get_voucher.OTHER_MONEY)>'#get_voucher.OTHER_MONEY#',<cfelse>NULL,</cfif>
											<cfif len(get_voucher.OTHER_MONEY_VALUE2)>#get_voucher.OTHER_MONEY_VALUE2#,<cfelse>NULL,</cfif>
											<cfif len(get_voucher.OTHER_MONEY2)>'#get_voucher.OTHER_MONEY2#',<cfelse>NULL,</cfif>
											#NOW()#
										)
							</cfquery>
						</cfif>
					</cfif>
				</cfif>
				</cfif>
			</cfloop>
			<cfloop from="1" to="#attributes.record_num2_2#" index="i">
				<cfif not isdefined("attributes.cheque_row2_2#i#")>
				<cfif evaluate("attributes.cheque_type2_2#i#") eq 1>
					<cfquery name="get_cheque" datasource="#dsn2#" maxrows="1">
						SELECT OLD_STATUS FROM CHEQUE WHERE CHEQUE_ID=#evaluate("attributes.id2_2#i#")#
					</cfquery>
					<cfquery name="get_cheque_first" datasource="#dsn2#" maxrows="1">
						SELECT STATUS,OLD_STATUS FROM CHEQUE_HISTORY WHERE CHEQUE_ID=#evaluate("attributes.id2_2#i#")# AND STATUS = 12
					</cfquery>
					<cfif get_cheque_first.recordcount>
						<cfquery name="get_cheque_hist" datasource="#dsn2#" maxrows="1">
							SELECT STATUS FROM CHEQUE_HISTORY WHERE CHEQUE_ID=#evaluate("attributes.id2_2#i#")# AND STATUS <> 12 ORDER BY RECORD_DATE DESC
						</cfquery>
						<cfif get_cheque_hist.recordcount>
							<cfset new_status = get_cheque_hist.status>
						<cfelseif len(get_cheque.old_status)>
							<cfset new_status = get_cheque.old_status>
						</cfif>
						<cfif isdefined("new_status")>
							<cfquery name="upd_cheque" datasource="#dsn2#">
								UPDATE CHEQUE SET CHEQUE_STATUS_ID=#new_status# WHERE CHEQUE_ID=#evaluate("attributes.id2_2#i#")#
							</cfquery>
							<cfquery name="get_cheque" datasource="#dsn2#">
								SELECT * FROM CHEQUE WHERE CHEQUE_ID = #evaluate("attributes.id2_2#i#")#
							</cfquery>
							<cfquery name="add_history" datasource="#dsn2#">
								INSERT INTO
									CHEQUE_HISTORY
										(
											CHEQUE_ID,
											STATUS,
											ACT_DATE,
											OTHER_MONEY_VALUE,
											OTHER_MONEY,
											OTHER_MONEY_VALUE2,
											OTHER_MONEY2,
											RECORD_DATE
										)
									VALUES
										(
											#evaluate("attributes.id2_2#i#")#,
											#new_status#,
											#attributes.revenue_date#,
											<cfif len(get_cheque.OTHER_MONEY_VALUE)>#get_cheque.OTHER_MONEY_VALUE#,<cfelse>NULL,</cfif>
											<cfif len(get_cheque.OTHER_MONEY)>'#get_cheque.OTHER_MONEY#',<cfelse>NULL,</cfif>
											<cfif len(get_cheque.OTHER_MONEY_VALUE2)>#get_cheque.OTHER_MONEY_VALUE2#,<cfelse>NULL,</cfif>
											<cfif len(get_cheque.OTHER_MONEY2)>'#get_cheque.OTHER_MONEY2#',<cfelse>NULL,</cfif>
											#NOW()#
										)
							</cfquery>
						</cfif>
					</cfif>
				<cfelse>
					<cfquery name="get_cheque_first" datasource="#dsn2#" maxrows="1">
						SELECT STATUS FROM VOUCHER_HISTORY WHERE VOUCHER_ID=#evaluate("attributes.id2_2#i#")# ORDER BY RECORD_DATE DESC
					</cfquery>
					<cfquery name="get_cheque" datasource="#dsn2#" maxrows="1">
						SELECT OLD_STATUS FROM VOUCHER WHERE VOUCHER_ID=#evaluate("attributes.id2_2#i#")#
					</cfquery>
					<cfif get_cheque_first.recordcount>
						<cfquery name="get_cheque_hist" datasource="#dsn2#" maxrows="1">
							SELECT STATUS FROM VOUCHER_HISTORY WHERE VOUCHER_ID=#evaluate("attributes.id2_2#i#")# AND STATUS <> 12 ORDER BY RECORD_DATE DESC
						</cfquery>
						<cfif get_cheque_hist.recordcount>
							<cfset new_status = get_cheque_hist.status>
						<cfelseif len(get_cheque.old_status)>
							<cfset new_status = get_cheque.old_status>
						</cfif>
						<cfif isdefined("new_status")>
							<cfquery name="upd_voucher" datasource="#dsn2#">
								UPDATE VOUCHER SET VOUCHER_STATUS_ID=#new_status# WHERE VOUCHER_ID=#evaluate("attributes.id2_2#i#")#
							</cfquery>
							<cfquery name="get_voucher" datasource="#dsn2#">
								SELECT * FROM VOUCHER WHERE VOUCHER_ID = #evaluate("attributes.id2_2#i#")#
							</cfquery>
							<cfquery name="add_history" datasource="#dsn2#">
								INSERT INTO
									VOUCHER_HISTORY
										(
											VOUCHER_ID,
											STATUS,
											ACT_DATE,
											OTHER_MONEY_VALUE,
											OTHER_MONEY,
											OTHER_MONEY_VALUE2,
											OTHER_MONEY2,
											RECORD_DATE
										)
									VALUES
										(
											#evaluate("attributes.id2_2#i#")#,
											#new_status#,
											#attributes.revenue_date#,
											<cfif len(get_voucher.OTHER_MONEY_VALUE)>#get_voucher.OTHER_MONEY_VALUE#,<cfelse>NULL,</cfif>
											<cfif len(get_voucher.OTHER_MONEY)>'#get_voucher.OTHER_MONEY#',<cfelse>NULL,</cfif>
											<cfif len(get_voucher.OTHER_MONEY_VALUE2)>#get_voucher.OTHER_MONEY_VALUE2#,<cfelse>NULL,</cfif>
											<cfif len(get_voucher.OTHER_MONEY2)>'#get_voucher.OTHER_MONEY2#',<cfelse>NULL,</cfif>
											#NOW()#
										)
							</cfquery>
						</cfif>
					</cfif>
				</cfif>
				</cfif>
			</cfloop>
			<script type="text/javascript">
				window.location.href='<cfoutput>#request.self#?fuseaction=ch.list_law_request&form_submitted=1</cfoutput>';
			</script>
		</cfif>	
	</cftransaction>
</cflock>

