<cfset upload_folder = "#upload_folder#settings#dir_seperator#">
<cftry>
	<cffile action = "upload" 
		fileField = "uploaded_file" 
		destination = "#upload_folder#"
		nameConflict = "MakeUnique"  
		mode="777" charset="#attributes.file_format#">
	<cfset file_name = "#createUUID()#.#cffile.serverfileext#">	
	<cffile action="rename" source="#upload_folder##cffile.serverfile#" destination="#upload_folder##file_name#" charset="#attributes.file_format#">
	<cfset file_size = cffile.filesize>
	<cfcatch type="Any">
		<script type="text/javascript">
			alert("<cf_get_lang dictionary_id='63329.Dosyaniz Upload Edilemedi Lütfen Konrol Ediniz'>!");
			history.back();
		</script>
		<cfabort>
	</cfcatch>  
</cftry>

<cftry>
	<cffile action="read" file="#upload_folder##file_name#" variable="dosya" charset="#attributes.file_format#">
	<cffile action="delete" file="#upload_folder##file_name#">
<cfcatch>
	<script type="text/javascript">
		alert("<cf_get_lang dictionary_id='29450.Dosya Okunamadı! Karakter Seti Yanlış Seçilmiş Olabilir'>");
		history.back();
	</script>
	<cfabort>
</cfcatch>
</cftry>

<cfscript>
	CRLF = Chr(13) & Chr(10);// satır atlama karakteri
	dosya = Replace(dosya,';;','; ;','all');
	dosya = Replace(dosya,';;','; ;','all');
	dosya = ListToArray(dosya,CRLF);
	line_count = ArrayLen(dosya);
	satir_no =0;
	satir_say =0;
</cfscript>
<cfset currency_multiplier = ''>
<cfset currency_multiplier_2 = ''>
<cfset import_id_list = ''>
<cfquery name="get_money" datasource="#dsn2#">
	SELECT MONEY,RATE1,RATE2 FROM SETUP_MONEY WHERE MONEY_STATUS=1
</cfquery>
<cfoutput query="get_money">
	<cfif money eq session.ep.money>
		<cfset currency_multiplier = rate2/rate1>
	</cfif>
	<cfif money eq session.ep.money2> 
		<cfset currency_multiplier_2 = rate2/rate1>
	</cfif>
</cfoutput>
<cfset portfoy_no = get_cheque_no(belge_tipi:'cheque')>
<cfset v_portfoy_no = get_cheque_no(belge_tipi:'voucher')>
<cfset open_date = dateformat(session.ep.period_start_date,dateformat_style)>
<cfset error_flag = 0>
<cflock name="#createuuid()#" timeout="500">
	<cftransaction>
		<cfloop from="2" to="#line_count#" index="i">
			<cfset j= 1>
			<cfset error_flag = 0>
			<cftry>
				<cfscript>
					satir_say=satir_say+1;
					due_date = Listgetat(dosya[i],j,";");//Vade Tarihi
					j=j+1;
					
					debtor_name = Listgetat(dosya[i],j,";");//Borçlu
					debtor_name = trim(debtor_name);
					j=j+1;
					
					member_code = Listgetat(dosya[i],j,";");//Üye kodu / özel kod / tc kimlik no / vergi no
					member_code = trim(member_code);
					j=j+1;
					
					bank_name = Listgetat(dosya[i],j,";");//Banka Adı
					bank_name = trim(bank_name);
					j=j+1;
					
					bank_branch_name = Listgetat(dosya[i],j,";");//Şube Adı
					bank_branch_name = trim(bank_branch_name);
					j=j+1;
					
					process_number = Listgetat(dosya[i],j,";");//çek no
					process_number = trim(process_number);
					j=j+1;
					
					tutar = Listgetat(dosya[i],j,";");//toplam tutar
					tutar = trim(tutar);
					tutar=Replace(tutar,',','.');
					j=j+1;
					
					money_type = Listgetat(dosya[i],j,";");//Tutar para birimi
					money_type = trim(money_type);
					j=j+1;

					other_money_val = Listgetat(dosya[i],j,";");//işlem dövizi karşılığı
					other_money_val = trim(other_money_val);
					other_money_val=Replace(other_money_val,',','.');
					j=j+1;

					other_money = Listgetat(dosya[i],j,";");//işlem dövizi
					other_money = trim(other_money);
					j=j+1;
					
					is_customer_cheque = Listgetat(dosya[i],j,";");//Müşteri çeki
					is_customer_cheque = trim(is_customer_cheque);
					j=j+1;
					
					process_code = Listgetat(dosya[i],j,";");//Özel Kod
					process_code = trim(process_code);
					j=j+1;
					
					pay_method = Listgetat(dosya[i],j,";");//Ödeme yöntemi
					pay_method = trim(pay_method);
					j=j+1;					
					
					system_value = Listgetat(dosya[i],j,";");//sistem dövizi karşılığı
					system_value = trim(system_value);
					system_value=Replace(system_value,',','.');
					j=j+1;
					
					account_no = Listgetat(dosya[i],j,";");//hesap no
					account_no = trim(account_no);
					j=j+1;
					
					if(listlen(dosya[i],';') gte j)//çek sahibi
						owner_company = Listgetat(dosya[i],j,";");
					else
						owner_company ='';
					j=j+1;
					
					if(listlen(dosya[i],';') gte j)//Ciro Eden
						endorsement_member = Listgetat(dosya[i],j,";");
					else
						endorsement_member ='';
					j=j+1;
						
					if(listlen(dosya[i],';') gte j)//ödeme sözü
						is_pay_term = Listgetat(dosya[i],j,";");
					else
						is_pay_term ='';
					j=j+1;
						
					if(listlen(dosya[i],';') gte j)//işlem tarihi
						cari_act_date = Listgetat(dosya[i],j,";");
					else
						cari_act_date ='';
				</cfscript>
				<cfcatch type="Any">
					<cfoutput>#i#</cfoutput>. satır 1. adımda sorun oluştu.<br/>
					<cfset error_flag = 1>
				</cfcatch>
			</cftry>
			<cfif len(cari_act_date) and isdate(cari_act_date)>
				<cfset cari_action_date = cari_act_date>
			<cfelse>
				<cfset cari_action_date = dateformat(now(),dateformat_style)>
			</cfif>
			<cfif error_flag neq 1>
				<cfif attributes.status eq 4>
					<cfif not len(due_date) or not len(member_code) or not len(tutar) or not len(money_type) or not len(owner_company)>
						<cfoutput>
							<script type="text/javascript">
								alert('#i#. <cf_get_lang dictionary_id='57881.Vade Tarihi'>,<cf_get_lang dictionary_id='57658.Üye'>,<cf_get_lang dictionary_id='57673.Tutar'>,<cf_get_lang dictionary_id='57489.Para Birimi'>,<cf_get_lang dictionary_id='58902.Çek Sahibi'> <cf_get_lang dictionary_id='63632.alanlarını kontrol ediniz'> !');
								window.close();
							</script>
						</cfoutput>
						<cfabort>
					</cfif>
				<cfelse>					
					<cfif not len(due_date) or not len(member_code) or not len(tutar) or not len(money_type)>
						<cfoutput>
							<script type="text/javascript">
								alert('#i#. <cf_get_lang dictionary_id='57881.Vade Tarihi'>,<cf_get_lang dictionary_id='57658.Üye'>,<cf_get_lang dictionary_id='57673.Tutar'>,<cf_get_lang dictionary_id='57489.Para Birimi'><cf_get_lang dictionary_id='63632.alanlarını kontrol ediniz'> !');
								window.close();
							</script>
						</cfoutput>
						<cfabort>
					</cfif>
				</cfif>
				<cfif year(cari_action_date) neq session.ep.period_year>
					<cfoutput>#i#. <cf_get_lang dictionary_id='63633.satırdaki işlem tarihi döneme uygun değil'>.</cfoutput><br/>
				<cfelse>
					<cf_date tarih='cari_action_date'>
					<cfset get_comp_id.recordcount = 0>
					<cfset get_cons_id.recordcount = 0>
					<cfif attributes.import_format eq 1><!--- kurumsal üye numarası ile --->
						<cfquery name="get_comp_id" datasource="#dsn2#">
							SELECT COMPANY_ID FROM #dsn_alias#.COMPANY WHERE MEMBER_CODE = '#member_code#'
						</cfquery>
						<cfif len(owner_company)>
							<cfquery name="get_owner_comp_id" datasource="#dsn2#">
								SELECT COMPANY_ID FROM #dsn_alias#.COMPANY WHERE MEMBER_CODE = '#owner_company#'
							</cfquery>
						</cfif>
					<cfelseif attributes.import_format eq 2><!--- kurumsal özel kod ile --->
						<cfquery name="get_comp_id" datasource="#dsn2#">
							SELECT COMPANY_ID FROM #dsn_alias#.COMPANY WHERE OZEL_KOD = '#member_code#'
						</cfquery>
						<cfif len(owner_company)>
							<cfquery name="get_owner_comp_id" datasource="#dsn2#">
								SELECT COMPANY_ID FROM #dsn_alias#.COMPANY WHERE OZEL_KOD = '#owner_company#'
							</cfquery>
						</cfif>
					<cfelseif attributes.import_format eq 3><!--- kurumsal vergi no ile --->
						<cfquery name="get_comp_id" datasource="#dsn2#">
							SELECT COMPANY_ID FROM #dsn_alias#.COMPANY WHERE TAXNO = '#member_code#'
						</cfquery>
						<cfif len(owner_company)>
							<cfquery name="get_owner_comp_id" datasource="#dsn2#">
								SELECT COMPANY_ID FROM #dsn_alias#.COMPANY WHERE TAXNO = '#owner_company#'
							</cfquery>
						</cfif>
					<cfelseif attributes.import_format eq 4><!--- bireysel üye no ile --->
						<cfquery name="get_cons_id" datasource="#dsn2#">
							SELECT CONSUMER_ID FROM #dsn_alias#.CONSUMER WHERE MEMBER_CODE = '#member_code#'
						</cfquery>
						<cfif len(owner_company)>
							<cfquery name="get_owner_cons_id" datasource="#dsn2#">
								SELECT CONSUMER_ID FROM #dsn_alias#.CONSUMER WHERE MEMBER_CODE = '#owner_company#'
							</cfquery>
						</cfif>
					<cfelseif attributes.import_format eq 5><!--- bireysel tc kimlik no ile --->
						<cfquery name="get_cons_id" datasource="#dsn2#">
							SELECT CONSUMER_ID FROM #dsn_alias#.CONSUMER WHERE TC_IDENTY_NO = '#member_code#'
						</cfquery>
						<cfif len(owner_company)>
							<cfquery name="get_owner_cons_id" datasource="#dsn2#">
								SELECT CONSUMER_ID FROM #dsn_alias#.CONSUMER WHERE TC_IDENTY_NO = '#owner_company#'
							</cfquery>
						</cfif>
					<cfelseif attributes.import_format eq 6><!--- bireysel özel kod ile --->
						<cfquery name="get_cons_id" datasource="#dsn2#">
							SELECT CONSUMER_ID FROM #dsn_alias#.CONSUMER WHERE OZEL_KOD = '#member_code#'
						</cfquery>
						<cfif len(owner_company)>
							<cfquery name="get_owner_cons_id" datasource="#dsn2#">
								SELECT CONSUMER_ID FROM #dsn_alias#.CONSUMER WHERE OZEL_KOD = '#owner_company#'
							</cfquery>
						</cfif>
					</cfif>
					<cfif get_comp_id.recordcount neq 0 or get_cons_id.recordcount neq 0>
						<cfif ((attributes.status eq 1 or attributes.status eq 4 or (attributes.import_type eq 2 and attributes.status eq 6)) and listlast(evaluate("attributes.cash"),';') eq money_type) or (not (attributes.status eq 1 or attributes.status eq 4 or (attributes.import_type eq 2 and attributes.status eq 6)) and listlast(evaluate("attributes.bank_account"),';') eq money_type)>
							<cfset satir_no = satir_no + 1>
							<cfif attributes.import_type eq 1><!--- Çek --->
								<cfquery name="ADD_PAYROLL" datasource="#dsn2#">
									INSERT INTO 
										PAYROLL 
										(
											PAYROLL_NO,
											PAYROLL_TYPE,
											<cfif listfind('1,4',attributes.status)>
												PAYROLL_CASH_ID,
											<cfelseif attributes.status eq 2 or attributes.status eq 6 or attributes.status eq 5 or attributes.status eq 13>
												PAYROLL_ACCOUNT_ID,
											</cfif>
											COMPANY_ID,
											CONSUMER_ID,
											PAYROLL_RECORD_DATE,
											RECORD_EMP,
											RECORD_IP,
											RECORD_DATE
										)
										VALUES
										(
											'-1',
											106,
											<cfif listfind('1,4',attributes.status)>
												#listfirst(attributes.cash,';')#,
											<cfelseif attributes.status eq 2 or attributes.status eq 6 or attributes.status eq 5 or attributes.status eq 13>
												#listfirst(attributes.bank_account,';')#,
											</cfif>
											<cfif get_comp_id.recordcount neq 0>#get_comp_id.company_id#<cfelse>NULL</cfif>,
											<cfif get_cons_id.recordcount neq 0>#get_cons_id.consumer_id#<cfelse>NULL</cfif>,
											#now()#,
											#session.ep.userid#,
											<cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.remote_addr#">,
											#now()#
										)
								</cfquery>
								<cfquery name="get_max_payroll_id" datasource="#dsn2#">
									SELECT MAX(ACTION_ID) AS ACTION_ID FROM PAYROLL
								</cfquery>
								<cfset bordro_id = get_max_payroll_id.action_id>
								<cf_date tarih = 'due_date'>
								<cfset row_currency_multiplier = ''>
								<cfoutput query="get_money">
									<cfif money eq money_type>
										<cfset row_currency_multiplier = rate2/rate1>
									</cfif>
								</cfoutput>
								<cfquery name="add_cheque" datasource="#dsn2#">
									INSERT INTO
									CHEQUE
									(
										CHEQUE_PAYROLL_ID,
										CHEQUE_NO,
										CHEQUE_STATUS_ID,
										COMPANY_ID,
										CONSUMER_ID,
										OWNER_COMPANY_ID,
										OWNER_CONSUMER_ID,
										DEBTOR_NAME,
										BANK_NAME,
										BANK_BRANCH_NAME,
										ACCOUNT_ID,
										CURRENCY_ID,
										CHEQUE_VALUE,
										OTHER_MONEY,
										OTHER_MONEY_VALUE,
										OTHER_MONEY2,
										OTHER_MONEY_VALUE2,
										CH_OTHER_MONEY,
										CH_OTHER_MONEY_VALUE,
										CHEQUE_DUEDATE,
										CHEQUE_PURSE_NO,
										CHEQUE_CODE,
										RECORD_EMP,
										RECORD_IP,
										RECORD_DATE,
										ENTRY_DATE,
										ACCOUNT_NO
										<cfif listfind('1,4',attributes.status)>
											,CASH_ID
										</cfif>
										,ENDORSEMENT_MEMBER
										,SELF_CHEQUE
									)
									VALUES
									(
										#bordro_id#,
										<cfqueryparam cfsqltype="cf_sql_varchar" value="#process_number#">,
										#attributes.status#,
										<cfif get_comp_id.recordcount neq 0>#get_comp_id.company_id#<cfelse>NULL</cfif>,
										<cfif get_cons_id.recordcount neq 0>#get_cons_id.consumer_id#<cfelse>NULL</cfif>,
										<cfif attributes.status eq 4>
											<cfif isdefined("get_owner_comp_id") and get_owner_comp_id.recordcount>
												#get_owner_comp_id.company_id#,
											<cfelse>
												NULL,
											</cfif>
											<cfif isdefined("get_owner_cons_id") and get_owner_cons_id.recordcount>
												#get_owner_cons_id.consumer_id#,
											<cfelse>
												NULL,
											</cfif>
										<cfelse>
											<cfif get_comp_id.recordcount neq 0>#get_comp_id.company_id#<cfelse>NULL</cfif>,
											<cfif get_cons_id.recordcount neq 0>#get_cons_id.consumer_id#<cfelse>NULL</cfif>,
										</cfif>
										<cfif len(debtor_name)><cfqueryparam cfsqltype="cf_sql_varchar" value="#debtor_name#"><cfelse>NULL</cfif>,
										<cfif len(bank_name)><cfqueryparam cfsqltype="cf_sql_varchar" value="#bank_name#">,<cfelse>NULL,</cfif>
										<cfif len(bank_branch_name)><cfqueryparam cfsqltype="cf_sql_varchar" value="#bank_branch_name#">,<cfelse>NULL,</cfif>
										<cfif isdefined("attributes.bank_account") and len(attributes.bank_account)>#listfirst(attributes.bank_account,';')#,<cfelse>NULL,</cfif>
										<cfqueryparam cfsqltype="cf_sql_varchar" value="#money_type#">,
										#tutar#,
										<cfif len(system_value)>
											<cfqueryparam cfsqltype="cf_sql_varchar" value="#session.ep.money#">,
											#wrk_round(system_value)#,
											<cfif len(currency_multiplier_2)>
												<cfqueryparam cfsqltype="cf_sql_varchar" value="#session.ep.money2#">,
												#wrk_round(system_value/currency_multiplier_2)#,
											<cfelse>
												NULL,
												NULL,
											</cfif>
										<cfelse>
											<cfqueryparam cfsqltype="cf_sql_varchar" value="#session.ep.money#">,
											#wrk_round(tutar*row_currency_multiplier/currency_multiplier)#,
											<cfif len(currency_multiplier_2)>
												<cfqueryparam cfsqltype="cf_sql_varchar" value="#session.ep.money2#">,
												#wrk_round(tutar*row_currency_multiplier/currency_multiplier_2)#,
											<cfelse>
												NULL,
												NULL,
											</cfif>
										</cfif>
										<cfif len(other_money_val) and len(other_money)>
											<cfqueryparam cfsqltype="cf_sql_varchar" value="#other_money#">,
											#other_money_val#,
										<cfelse>
											NULL,
											NULL,
										</cfif>
										#createodbcdatetime(due_date)#,
										#portfoy_no#,
										<cfif len(process_code)><cfqueryparam cfsqltype="cf_sql_varchar" value="#process_code#"><cfelse>NULL</cfif>,
										#session.ep.userid#,
										<cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.remote_addr#">,
										#now()#,
										#cari_action_date#,
										<cfif len(account_no)><cfqueryparam cfsqltype="cf_sql_varchar" value="#account_no#"><cfelse>NULL</cfif>
										<cfif listfind('1,4',attributes.status)>
											,#listfirst(attributes.cash,';')#
										</cfif>
										<cfif len(endorsement_member)>,<cfqueryparam cfsqltype="cf_sql_varchar" value="#endorsement_member#"><cfelse>,NULL</cfif>
										<cfif len(is_customer_cheque)>,<cfqueryparam cfsqltype="cf_sql_varchar" value="#is_customer_cheque#"><cfelse>,NULL</cfif>
									)
								</cfquery>
								<cfset portfoy_no = portfoy_no+1>
								<cfquery name="get_max_id" datasource="#dsn2#">
									SELECT MAX(CHEQUE_ID) AS CHEQUE_ID FROM CHEQUE
								</cfquery>
								<cfset import_id_list = listappend(import_id_list,get_max_id.cheque_id,',')>
								<cfquery name="add_cheque_history" datasource="#dsn2#">
									INSERT INTO
									CHEQUE_HISTORY
									(
										CHEQUE_ID,
										PAYROLL_ID,
										STATUS,
										OTHER_MONEY,
										OTHER_MONEY_VALUE,
										OTHER_MONEY2,
										OTHER_MONEY_VALUE2,
										ACT_DATE,
										RECORD_EMP,
										RECORD_IP,
										RECORD_DATE
									)
									VALUES
									(
										#get_max_id.cheque_id#,
										#bordro_id#,
										#attributes.status#,
										<cfif len(system_value)>
											<cfqueryparam cfsqltype="cf_sql_varchar" value="#session.ep.money#">,
											#wrk_round(system_value)#,
											<cfif len(currency_multiplier_2)>
												<cfqueryparam cfsqltype="cf_sql_varchar" value="#session.ep.money2#">,
												#wrk_round(system_value/currency_multiplier_2)#,
											<cfelse>
												NULL,
												NULL,
											</cfif>
										<cfelse>
											<cfqueryparam cfsqltype="cf_sql_varchar" value="#session.ep.money#">,
											#wrk_round(tutar*row_currency_multiplier/currency_multiplier)#,
											<cfif len(currency_multiplier_2)>
												<cfqueryparam cfsqltype="cf_sql_varchar" value="#session.ep.money2#">,
												#wrk_round(tutar*row_currency_multiplier/currency_multiplier_2)#,
											<cfelse>
												NULL,
												NULL,
											</cfif>	
										</cfif>								
										#cari_action_date#,
										#session.ep.userid#,
										<cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.remote_addr#">,
										#now()#
									)
								</cfquery>
								<cfoutput query="get_money">
									<cfquery name="add_money_info" datasource="#dsn2#">
										INSERT INTO CHEQUE_MONEY 
										(
											ACTION_ID,
											MONEY_TYPE,
											RATE2,
											RATE1,
											IS_SELECTED
										)
										VALUES
										(
											#get_max_id.cheque_id#,
											<cfqueryparam cfsqltype="cf_sql_varchar" value="#get_money.money#">,
											#get_money.rate2#,
											#get_money.rate1#,
											<cfif money_type is get_money.money>1<cfelse>0</cfif>
										)
									</cfquery>
									<cfquery name="add_money_info2" datasource="#dsn2#">
										INSERT INTO CHEQUE_HISTORY_MONEY 
										(
											ACTION_ID,
											MONEY_TYPE,
											RATE2,
											RATE1,
											IS_SELECTED
										)
										VALUES
										(
											#get_max_id.cheque_id#,
											<cfqueryparam cfsqltype="cf_sql_varchar" value="#get_money.money#">,
											#get_money.rate2#,
											#get_money.rate1#,
											<cfif money_type is get_money.money>1<cfelse>0</cfif>
										)
									</cfquery>
								</cfoutput>
								<cfquery name="get_last_cheque" datasource="#dsn2#">
									SELECT 
        	                            CHEQUE_ID, 
                                        CHEQUE_PAYROLL_ID, 
                                        CHEQUE_CODE, 
                                        CHEQUE_DUEDATE, 
                                        CHEQUE_NO, 
                                        CHEQUE_VALUE, 
                                        CURRENCY_ID, 
                                        DEBTOR_NAME, 
                                        CHEQUE_STATUS_ID, 
                                        BANK_NAME, 
                                        BANK_BRANCH_NAME, 
                                        ACCOUNT_NO, 
                                        CHEQUE_PURSE_NO, 
                                        ACCOUNT_ID, 
                                        COMPANY_ID, 
                                        SELF_CHEQUE, 
                                        OTHER_MONEY_VALUE, 
                                        OTHER_MONEY, 
                                        OTHER_MONEY_VALUE2, 
                                        OTHER_MONEY2, 
                                        CONSUMER_ID, 
                                        EMPLOYEE_ID, 
                                        CASH_ID, 
                                        ENDORSEMENT_MEMBER, 
                                        OWNER_COMPANY_ID, 
                                        OWNER_CONSUMER_ID, 
                                        CH_OTHER_MONEY_VALUE, 
                                        CH_OTHER_MONEY, 
                                        RECORD_DATE, 
                                        RECORD_IP, 
                                        RECORD_EMP, 
                                        UPDATE_DATE,
                                        UPDATE_IP, 
                                        UPDATE_EMP
                                    FROM 
    	                                CHEQUE 
                                    WHERE 
	                                    CHEQUE_ID = #get_max_id.cheque_id#
								</cfquery>
								<cfif isdefined("attributes.is_cari_action") and listfind('1,2,5,13,4',attributes.status,',')>
									<cfscript>
										if(len(attributes.cash))
											from_branch_id_ = listgetat(attributes.cash,2,';');
										else
											from_branch_id_ = listgetat(session.ep.user_location,2,'-');
										if(len(other_money_val) and len(other_money))
										{
											new_other_money_value = other_money_val;
											new_other_money = other_money;
										}
										else
										{
											new_other_money_value = get_last_cheque.cheque_value;
											new_other_money = get_last_cheque.currency_id;
										}
										carici(
											action_id :get_last_cheque.cheque_id,
											workcube_process_type : 106,		
											process_cat : -1,
											account_card_type :13,
											action_table :'CHEQUE',
											islem_tarihi : cari_action_date,
											islem_tutari : get_last_cheque.other_money_value,
											other_money_value : new_other_money_value,
											other_money : new_other_money,
											islem_belge_no : get_last_cheque.cheque_no,
											action_currency :session.ep.money,
											to_cash_id : listfirst(attributes.cash,';'),
											due_date : createodbcdatetime(get_last_cheque.cheque_duedate),
											from_cmp_id : get_last_cheque.company_id,
											from_consumer_id : get_last_cheque.consumer_id,
											currency_multiplier : currency_multiplier_2,
											islem_detay : 'ÇEK AÇILIŞ DEVİR',
											payroll_id :bordro_id,
											from_branch_id : from_branch_id_
											);
									</cfscript>	
								</cfif> 
								<cfset belge_no = get_cheque_no(belge_tipi:'cheque',belge_no:portfoy_no)>
							<cfelse><!--- Senet --->
								<cfquery name="ADD_PAYROLL" datasource="#dsn2#">
									INSERT INTO 
										VOUCHER_PAYROLL 
										(
											PAYROLL_NO,
											PAYROLL_TYPE,
											<cfif listfind('1,4,6',attributes.status)>
												PAYROLL_CASH_ID,
											<cfelseif attributes.status eq 2 or attributes.status eq 5 or attributes.status eq 13>
												PAYROLL_ACCOUNT_ID,
											</cfif>
											PAYMETHOD_ID,
											COMPANY_ID,
											CONSUMER_ID,
											PAYROLL_RECORD_DATE,
											RECORD_EMP,
											RECORD_IP,
											RECORD_DATE
										)
										VALUES
										(
											'-1',
											107,
											<cfif listfind('1,4,6',attributes.status)>
												#listfirst(attributes.cash,';')#,
											<cfelseif attributes.status eq 2  or attributes.status eq 5 or attributes.status eq 13>
												#listfirst(attributes.bank_account,';')#,
											</cfif>
											<cfif len(pay_method)>#pay_method#<cfelse>NULL</cfif>,
											<cfif get_comp_id.recordcount neq 0>#get_comp_id.company_id#<cfelse>NULL</cfif>,
											<cfif get_cons_id.recordcount neq 0>#get_cons_id.consumer_id#<cfelse>NULL</cfif>,
											#now()#,
											#session.ep.userid#,
											<cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.remote_addr#">,
											#now()#
										)
								</cfquery>
								<cfquery name="get_max_payroll_id" datasource="#dsn2#">
									SELECT MAX(ACTION_ID) AS ACTION_ID FROM VOUCHER_PAYROLL
								</cfquery>
								<cfset bordro_id = get_max_payroll_id.action_id>
								<cf_date tarih = 'due_date'>
								<cfset row_currency_multiplier = ''>
								<cfoutput query="get_money">
									<cfif money eq money_type>
										<cfset row_currency_multiplier = rate2/rate1>
									</cfif>
								</cfoutput>
								<cfquery name="add_voucher" datasource="#dsn2#">
									INSERT INTO
									VOUCHER
									(
										VOUCHER_PAYROLL_ID,
										VOUCHER_NO,
										VOUCHER_STATUS_ID,
										COMPANY_ID,
										CONSUMER_ID,
										OWNER_COMPANY_ID,
										OWNER_CONSUMER_ID,
										DEBTOR_NAME,
										CURRENCY_ID,
										VOUCHER_VALUE,
										OTHER_MONEY,
										OTHER_MONEY_VALUE,
										OTHER_MONEY2,
										OTHER_MONEY_VALUE2,
										CH_OTHER_MONEY,
										CH_OTHER_MONEY_VALUE,
										VOUCHER_DUEDATE,
										VOUCHER_PURSE_NO,
										VOUCHER_CODE,
										RECORD_EMP,
										RECORD_IP,
										RECORD_DATE,
										ENTRY_DATE,
										ACCOUNT_NO
										<cfif listfind('1,4',attributes.status)>
											,CASH_ID
										</cfif>					
										,IS_PAY_TERM
										,SELF_VOUCHER
									)
									VALUES
									(
										#bordro_id#,
										<cfqueryparam cfsqltype="cf_sql_varchar" value="#process_number#">,
										#attributes.status#,
										<cfif get_comp_id.recordcount neq 0>#get_comp_id.company_id#<cfelse>NULL</cfif>,
										<cfif get_cons_id.recordcount neq 0>#get_cons_id.consumer_id#<cfelse>NULL</cfif>,
										<cfif attributes.status eq 4>
											<cfif isdefined("get_owner_comp_id") and get_owner_comp_id.recordcount>
												#get_owner_comp_id.company_id#,
											<cfelse>
												NULL,
											</cfif>
											<cfif isdefined("get_owner_cons_id") and get_owner_cons_id.recordcount>
												#get_owner_cons_id.consumer_id#,
											<cfelse>
												NULL,
											</cfif>
										<cfelse>
											<cfif get_comp_id.recordcount neq 0>#get_comp_id.company_id#<cfelse>NULL</cfif>,
											<cfif get_cons_id.recordcount neq 0>#get_cons_id.consumer_id#<cfelse>NULL</cfif>,
										</cfif>
										<cfif len(debtor_name)><cfqueryparam cfsqltype="cf_sql_varchar" value="#debtor_name#"><cfelse>NULL</cfif>,
										<cfqueryparam cfsqltype="cf_sql_varchar" value="#money_type#">,
										#tutar#,
										<cfif len(system_value)>
											<cfqueryparam cfsqltype="cf_sql_varchar" value="#session.ep.money#">,
											#wrk_round(system_value)#,
											<cfif len(currency_multiplier_2)>
												<cfqueryparam cfsqltype="cf_sql_varchar" value="#session.ep.money2#">,
												#wrk_round(system_value/currency_multiplier_2)#,
											<cfelse>
												NULL,
												NULL,
											</cfif>
										<cfelse>
											<cfqueryparam cfsqltype="cf_sql_varchar" value="#session.ep.money#">,
											#wrk_round(tutar*row_currency_multiplier/currency_multiplier)#,
											<cfif len(currency_multiplier_2)>
												<cfqueryparam cfsqltype="cf_sql_varchar" value="#session.ep.money2#">,
												#wrk_round(tutar*row_currency_multiplier/currency_multiplier_2)#,
											<cfelse>
												NULL,
												NULL,
											</cfif>
										</cfif>
										<cfif len(other_money_val) and len(other_money)>
											<cfqueryparam cfsqltype="cf_sql_varchar" value="#other_money#">,
											#other_money_val#,
										<cfelse>
											NULL,
											NULL,
										</cfif>
										#createodbcdatetime(due_date)#,
										#v_portfoy_no#,
										<cfif len(process_code)><cfqueryparam cfsqltype="cf_sql_varchar" value="#process_code#"><cfelse>NULL</cfif>,
										#session.ep.userid#,
										<cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.remote_addr#">,
										#now()#,
										#cari_action_date#,
										<cfif len(account_no)><cfqueryparam cfsqltype="cf_sql_varchar" value="#account_no#"><cfelse>NULL</cfif>
										<cfif listfind('1,4',attributes.status)>
											,#listfirst(attributes.cash,';')#				
										</cfif>			
										<cfif len(is_pay_term)>,<cfqueryparam cfsqltype="cf_sql_varchar" value="#is_pay_term#"><cfelse>,NULL</cfif>
										<cfif len(is_customer_cheque)>,<cfqueryparam cfsqltype="cf_sql_varchar" value="#is_customer_cheque#"><cfelse>,NULL</cfif>
									)
								</cfquery>
								<cfset v_portfoy_no = v_portfoy_no+1>
								<cfquery name="get_max_id" datasource="#dsn2#">
									SELECT MAX(VOUCHER_ID) AS VOUCHER_ID FROM VOUCHER
								</cfquery>
								<cfset import_id_list = listappend(import_id_list,get_max_id.voucher_id,',')>
								<cfquery name="add_voucher_history" datasource="#dsn2#">
									INSERT INTO
									VOUCHER_HISTORY
									(
										VOUCHER_ID,
										PAYROLL_ID,
										STATUS,
										OTHER_MONEY,
										OTHER_MONEY_VALUE,
										OTHER_MONEY2,
										OTHER_MONEY_VALUE2,
										ACT_DATE,
										RECORD_DATE
									)
									VALUES
									(
										#get_max_id.voucher_id#,
										#bordro_id#,
										#attributes.status#,
										<cfif len(system_value)>
											<cfqueryparam cfsqltype="cf_sql_varchar" value="#session.ep.money#">,
											#wrk_round(system_value)#,
											<cfif len(currency_multiplier_2)>
												<cfqueryparam cfsqltype="cf_sql_varchar" value="#session.ep.money2#">,
												#wrk_round(system_value/currency_multiplier_2)#,
											<cfelse>
												NULL,
												NULL,
											</cfif>
										<cfelse>
											<cfqueryparam cfsqltype="cf_sql_varchar" value="#session.ep.money#">,
											#wrk_round(tutar*row_currency_multiplier/currency_multiplier)#,
											<cfif len(currency_multiplier_2)>
												<cfqueryparam cfsqltype="cf_sql_varchar" value="#session.ep.money2#">,
												#wrk_round(tutar*row_currency_multiplier/currency_multiplier_2)#,
											<cfelse>
												NULL,
												NULL,
											</cfif>
										</cfif>								
										#cari_action_date#,
										#now()#
									)
								</cfquery>
								<cfoutput query="get_money">
									<cfquery name="add_money_info" datasource="#dsn2#">
										INSERT INTO VOUCHER_MONEY 
										(
											ACTION_ID,
											MONEY_TYPE,
											RATE2,
											RATE1,
											IS_SELECTED
										)
										VALUES
										(
											#get_max_id.voucher_id#,
											<cfqueryparam cfsqltype="cf_sql_varchar" value="#get_money.money#">,
											#get_money.rate2#,
											#get_money.rate1#,
											<cfif money_type is get_money.money>1<cfelse>0</cfif>
										)
									</cfquery>
									<cfquery name="add_money_info2" datasource="#dsn2#">
										INSERT INTO VOUCHER_HISTORY_MONEY 
										(
											ACTION_ID,
											MONEY_TYPE,
											RATE2,
											RATE1,
											IS_SELECTED
										)
										VALUES
										(
											#get_max_id.voucher_id#,
											<cfqueryparam cfsqltype="cf_sql_varchar" value="#get_money.money#">,
											#get_money.rate2#,
											#get_money.rate1#,
											<cfif money_type is get_money.money>1<cfelse>0</cfif>
										)
									</cfquery>
								</cfoutput>
								<cfquery name="get_last_voucher" datasource="#dsn2#">
									SELECT 
        	                            VOUCHER_ID, 
                                        VOUCHER_PAYROLL_ID, 
                                        VOUCHER_CODE, 
                                        VOUCHER_DUEDATE, 
                                        VOUCHER_NO, 
                                        VOUCHER_VALUE, 
                                        CURRENCY_ID, 
                                        DEBTOR_NAME, 
                                        VOUCHER_STATUS_ID, 
                                        ACCOUNT_NO, 
                                        VOUCHER_CITY, 
                                        VOUCHER_PURSE_NO, 
                                        SELF_VOUCHER, 
                                        ACCOUNT_CODE, 
                                        OTHER_MONEY, 
                                        OTHER_MONEY_VALUE, 
                                        COMPANY_ID, 
                                        OTHER_MONEY2, 
                                        OTHER_MONEY_VALUE2, 
                                        CONSUMER_ID, 
                                        DELAY_INTEREST_SYSTEM_VALUE, 
                                        DELAY_INTEREST_OTHER_VALUE, 
                                        DELAY_INTEREST_VALUE2, EARLY_PAYMENT_SYSTEM_VALUE, EARLY_PAYMENT_OTHER_VALUE, EARLY_PAYMENT_VALUE2, EMPLOYEE_ID, IS_PAY_TERM, CASH_ID, OWNER_COMPANY_ID, OWNER_CONSUMER_ID, OWNER_EMPLOYEE_ID, CH_OTHER_MONEY_VALUE, CH_OTHER_MONEY, RECORD_DATE, RECORD_EMP, RECORD_IP, OLD_STATUS 
                                    FROM 
    	                                VOUCHER 
                                    WHERE 
	                                    VOUCHER_ID = #get_max_id.voucher_id#
								</cfquery>
								<cfif isdefined("attributes.is_cari_action") and listfind('1,2,5,13,4',attributes.status,',')>
									<cfscript>
										if(len(attributes.cash))
											from_branch_id_ = listgetat(attributes.cash,2,';');
										else
											from_branch_id_ = listgetat(session.ep.user_location,2,'-');
										if(len(other_money_val) and len(other_money))
										{
											new_other_money_value = other_money_val;
											new_other_money = other_money;
										}
										else
										{
											new_other_money_value = get_last_voucher.voucher_value;
											new_other_money = get_last_voucher.currency_id;
										}
										carici(
											action_id :get_last_voucher.voucher_id,
											workcube_process_type : 107,		
											process_cat : -1,
											account_card_type :13,
											action_table :'VOUCHER',
											islem_tarihi : cari_action_date,
											islem_tutari : get_last_voucher.other_money_value,
											other_money_value : new_other_money_value,
											other_money : new_other_money,
											islem_belge_no : get_last_voucher.voucher_no,
											action_currency :session.ep.money,
											to_cash_id : listfirst(attributes.cash,';'),
											due_date : createodbcdatetime(get_last_voucher.voucher_duedate),
											from_cmp_id : get_last_voucher.company_id,
											from_consumer_id : get_last_voucher.consumer_id,
											currency_multiplier : currency_multiplier_2,
											islem_detay : 'SENET AÇILIŞ DEVİR',
											payroll_id :bordro_id,
											from_branch_id : from_branch_id_ 
											);
									</cfscript>	
								</cfif>
								<cfset belge_no = get_cheque_no(belge_tipi:'voucher',belge_no:v_portfoy_no)>
							</cfif>
						<cfelse>
							<cfif attributes.status eq 1 or attributes.status eq 4 or (attributes.import_type eq 2 and attributes.status eq 6)>
								<cfoutput>#i#. <cf_get_lang dictionary_id='63635.satırdaki para birimi kasanın para biriminden farklı'>.</cfoutput><br/>
							<cfelse>
								<cfoutput>#i#. <cf_get_lang dictionary_id='63636.satırdaki para birimi bankanın para biriminden farklı'></cfoutput><br/>
							</cfif>
						</cfif>
					<cfelse>
						<cfoutput>#i#. <cf_get_lang dictionary_id='63634.satırdaki üye bulunamadı'>. <cf_get_lang dictionary_id='30707.Üye Kodu'> : #member_code#</cfoutput><br/>
					</cfif>
				</cfif>
				<cftry>	
					<cfcatch type="Any">
						<cfoutput>#i#</cfoutput>. <cf_get_lang dictionary_id='63401.satır 2. adımda sorun oluştu'><br/>
					</cfcatch>
				</cftry>
			</cfif>
		</cfloop>
		<cfif isdefined("attributes.is_cari_action_dekont") and isdefined("attributes.is_cari_action") and attributes.import_type eq 1 and len(import_id_list)>
			<cfif listfind('1,2,3',attributes.import_format,',')>
				<cfquery name="get_all_cheques" datasource="#dsn2#">
					SELECT
						SUM(CHEQUE_VALUE) AS OTHER_MONEY_VALUE,
						SUM(OTHER_MONEY_VALUE) AS ACTION_VALUE,
						SUM(OTHER_MONEY_VALUE2) AS OTHER_MONEY_VALUE2,
						CURRENCY_ID,
						COMPANY_ID,
						''  AS CONSUMER_ID
					FROM
						CHEQUE
					WHERE
						CHEQUE_STATUS_ID IN (1,2,5,4,13) AND
						COMPANY_ID IS NOT NULL AND
						CHEQUE_ID IN (#import_id_list#)
					GROUP BY
						CURRENCY_ID,
						COMPANY_ID
				</cfquery>
			<cfelse>
				<cfquery name="get_all_cheques" datasource="#dsn2#">
					SELECT
						SUM(CHEQUE_VALUE) AS OTHER_MONEY_VALUE,
						SUM(OTHER_MONEY_VALUE) AS ACTION_VALUE,
						SUM(OTHER_MONEY_VALUE2) AS OTHER_MONEY_VALUE2,
						CURRENCY_ID,
						CONSUMER_ID,
						'' AS COMPANY_ID
					FROM
						CHEQUE
					WHERE
						CHEQUE_STATUS_ID IN (1,2,5,4,13) AND
						CONSUMER_ID IS NOT NULL AND
						CHEQUE_ID IN (#import_id_list#)
					GROUP BY
						CURRENCY_ID,
						CONSUMER_ID
				</cfquery>
			</cfif>
			<cfoutput query="get_all_cheques">
				<cfquery name="add_dekont" datasource="#dsn2#">
					INSERT INTO
						CARI_ACTIONS
						(
							PROCESS_CAT,
							ACTION_NAME,
							ACTION_TYPE_ID,
							ACTION_VALUE,
							ACTION_CURRENCY_ID,
							OTHER_MONEY,
							OTHER_CASH_ACT_VALUE,
							TO_CMP_ID,								
							TO_CONSUMER_ID,
							ACTION_DATE,
							RECORD_DATE,
							RECORD_EMP,
							RECORD_IP								
						)
					VALUES
						(
							#attributes.dekont_process_cat#,
							<cfqueryparam cfsqltype="cf_sql_varchar" value="BORÇ DEKONTU">,
							41,
							#get_all_cheques.action_value#,
							<cfqueryparam cfsqltype="cf_sql_varchar" value="#session.ep.money#">,
							<cfqueryparam cfsqltype="cf_sql_varchar" value="#get_all_cheques.currency_id#">,
							#get_all_cheques.other_money_value#,
							<cfif len(get_all_cheques.company_id)>#get_all_cheques.company_id#,<cfelse>NULL,</cfif>
							<cfif len(get_all_cheques.consumer_id)>#get_all_cheques.consumer_id#,<cfelse>NULL,</cfif>
							#createodbcdatetime(dateformat(now(),dateformat_style))#,
							#now()#,
							#session.ep.userid#,
							<cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.remote_addr#">						
						)					
				</cfquery>
				<cfquery name="get_max" datasource="#dsn2#">
					SELECT MAX(ACTION_ID) AS ACTION_ID FROM CARI_ACTIONS
				</cfquery>
				<cfscript>
					carici(
						action_id : get_max.action_id,
						process_cat : attributes.dekont_process_cat,
						workcube_process_type : 41,
						action_table : 'CARI_ACTIONS',
						islem_tutari : get_all_cheques.action_value,
						action_currency : session.ep.money,
						other_money_value : get_all_cheques.other_money_value,
						other_money : get_all_cheques.currency_id,
						islem_tarihi : createodbcdatetime(dateformat(now(),dateformat_style)),
						islem_detay : 'BORÇ DEKONTU',
						to_cmp_id : get_all_cheques.company_id,
						to_consumer_id : get_all_cheques.consumer_id,
						currency_multiplier : currency_multiplier_2,
						account_card_type : 13,
						to_branch_id : listgetat(session.ep.user_location,2,'-')
						);
				</cfscript>
			</cfoutput>
		<cfelseif isdefined("attributes.is_cari_action_dekont") and isdefined("attributes.is_cari_action") and attributes.import_type eq 2 and len(import_id_list)>
			<cfif listfind('1,2,3',attributes.import_format,',')>
				<cfquery name="get_all_vouchers" datasource="#dsn2#">
					SELECT
						SUM(VOUCHER_VALUE) AS OTHER_MONEY_VALUE,
						SUM(OTHER_MONEY_VALUE) AS ACTION_VALUE,
						SUM(OTHER_MONEY_VALUE2) AS OTHER_MONEY_VALUE2,
						CURRENCY_ID,
						COMPANY_ID,
						''  AS CONSUMER_ID
					FROM
						VOUCHER
					WHERE
						VOUCHER_STATUS_ID IN (1,2,5,4,13) AND
						COMPANY_ID IS NOT NULL AND
						VOUCHER_ID IN (#import_id_list#)
					GROUP BY
						CURRENCY_ID,
						COMPANY_ID
				</cfquery>
			<cfelse>
				<cfquery name="get_all_vouchers" datasource="#dsn2#">
					SELECT
						SUM(VOUCHER_VALUE) AS OTHER_MONEY_VALUE,
						SUM(OTHER_MONEY_VALUE) AS ACTION_VALUE,
						SUM(OTHER_MONEY_VALUE2) AS OTHER_MONEY_VALUE2,
						CURRENCY_ID,
						CONSUMER_ID,
						'' AS COMPANY_ID
					FROM
						VOUCHER
					WHERE
						VOUCHER_STATUS_ID IN (1,2,5,4,13) AND
						CONSUMER_ID IS NOT NULL AND
						VOUCHER_ID IN (#import_id_list#)
					GROUP BY
						CURRENCY_ID,
						CONSUMER_ID
				</cfquery>
			</cfif>
			<cfoutput query="get_all_vouchers">
				<cfquery name="add_dekont" datasource="#dsn2#">
					INSERT INTO
						CARI_ACTIONS
						(
							PROCESS_CAT,
							ACTION_NAME,
							ACTION_TYPE_ID,
							ACTION_VALUE,
							ACTION_CURRENCY_ID,
							OTHER_MONEY,
							OTHER_CASH_ACT_VALUE,
							TO_CMP_ID,								
							TO_CONSUMER_ID,
							ACTION_DATE,
							RECORD_DATE,
							RECORD_EMP,
							RECORD_IP								
						)
					VALUES
						(
							#attributes.dekont_process_cat#,
							<cfqueryparam cfsqltype="cf_sql_varchar" value="BORÇ DEKONTU">,
							41,
							#get_all_vouchers.action_value#,
							<cfqueryparam cfsqltype="cf_sql_varchar" value="#session.ep.money#">,
							<cfqueryparam cfsqltype="cf_sql_varchar" value="#get_all_vouchers.currency_id#">,
							#get_all_vouchers.other_money_value#,
							<cfif len(get_all_vouchers.company_id)>#get_all_vouchers.company_id#,<cfelse>NULL,</cfif>
							<cfif len(get_all_vouchers.consumer_id)>#get_all_vouchers.consumer_id#,<cfelse>NULL,</cfif>
							#createodbcdatetime(dateformat(now(),dateformat_style))#,
							#now()#,
							#session.ep.userid#,
							<cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.remote_addr#">						
						)					
				</cfquery>
				<cfquery name="get_max" datasource="#dsn2#">
					SELECT MAX(ACTION_ID) AS ACTION_ID FROM CARI_ACTIONS
				</cfquery>
				<cfscript>
					carici(
						action_id : get_max.action_id,
						process_cat : attributes.dekont_process_cat,
						workcube_process_type : 41,
						action_table : 'CARI_ACTIONS',
						islem_tutari : get_all_vouchers.action_value,
						action_currency : session.ep.money,
						other_money_value : get_all_vouchers.other_money_value,
						other_money : get_all_vouchers.currency_id,
						islem_tarihi : createodbcdatetime(dateformat(now(),dateformat_style)),
						islem_detay : 'BORÇ DEKONTU',
						to_cmp_id : get_all_vouchers.company_id,
						to_consumer_id : get_all_vouchers.consumer_id,
						currency_multiplier : currency_multiplier_2,
						account_card_type : 13,
						to_branch_id : listgetat(session.ep.user_location,2,'-')
						);
				</cfscript>
			</cfoutput>
		</cfif>
	</cftransaction>
</cflock>
<cfoutput><cf_get_lang dictionary_id='44647.İmport edilen satır sayısı'>: #satir_no# !!!</cfoutput><br/>
<cfoutput><cf_get_lang dictionary_id='44638.Toplam belge satır sayısı'>: #satir_say# !!!</cfoutput>
<script>
	window.location.href="<cfoutput>#request.self#?fuseaction=settings.form_cheque_voucher_import</cfoutput>";
</script>