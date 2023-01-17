<!--- E.A select ifadeleri düzenlendi.23.07.2012 --->
<!--- otomatik ödeme dönüş import dosyasıdır..pronet ve dore için desen çalışılmıştır --->

<cfset CRLF = Chr(13)&Chr(10)>
<cf_date tarih='attributes.process_date'>
<!--- islem tarihine ait e-defter varsa import edilmesi engelleniyor --->
<cfif session.ep.our_company_info.is_edefter eq 1 and isdefined("attributes.process_date")>
	<cfstoredproc procedure="GET_NETBOOK" datasource="#dsn2#">
    	<cfprocparam cfsqltype="cf_sql_timestamp" value="#attributes.process_date#">
		<cfprocparam cfsqltype="cf_sql_timestamp" value="#attributes.process_date#">
		<cfprocparam cfsqltype="cf_sql_varchar" value="">
		<cfprocresult name="getNetbook">
	</cfstoredproc>
	<cfif getNetbook.recordcount>
		<script type="text/javascript">
			alert('<cf_get_lang dictionary_id='52611.İşlemi yapamazsınız'>');
		</script>
		<cfabort>
	</cfif>
	
</cfif>
<cfif not isDefined("attributes.bank_order_type")>
    <cfquery name="GET_IMPORT" datasource="#DSN2#">
        SELECT 
            SOURCE_SYSTEM,
            FILE_NAME,
            FILE_CONTENT,
            ISNULL(IS_DBS,0) AS IS_DBS
        FROM 
            FILE_IMPORTS 
        WHERE 
            PROCESS_TYPE = -12 
            AND IMPORTED = 0
            <cfif isdefined("attributes.i_id")>
                AND I_ID = #attributes.i_id#
            </cfif>
    </cfquery>
</cfif>
<cfquery name="GET_MONEY_INFO" datasource="#DSN2#">
	SELECT MONEY,RATE1,RATE2,MONEY_STATUS FROM SETUP_MONEY
</cfquery>
<cfquery name="GET_PROCESS_MONEY" datasource="#DSN#">
	SELECT STANDART_PROCESS_MONEY FROM SETUP_PERIOD WHERE PERIOD_ID = #session.ep.period_id#
</cfquery>
<cfif GET_PROCESS_MONEY.recordcount>
	<cfset process_money_info = GET_PROCESS_MONEY.STANDART_PROCESS_MONEY>
<cfelse>
	<cfset process_money_info = session.ep.money2>
</cfif>
<cfoutput query="GET_MONEY_INFO">
	<cfif GET_MONEY_INFO.MONEY eq session.ep.money2>
		<cfset currency_multiplier = wrk_round(GET_MONEY_INFO.RATE2/GET_MONEY_INFO.RATE1,session.ep.our_company_info.rate_round_num)>
	</cfif>
	<cfif GET_MONEY_INFO.MONEY eq process_money_info>
		<cfset currency_multiplier_other = wrk_round(GET_MONEY_INFO.RATE2/GET_MONEY_INFO.RATE1,session.ep.our_company_info.rate_round_num)>
	</cfif>
</cfoutput>
<cfquery name="get_process_type" datasource="#DSN3#">
	SELECT PROCESS_TYPE,IS_CARI,IS_ACCOUNT FROM SETUP_PROCESS_CAT WHERE PROCESS_CAT_ID = #attributes.process_cat#
</cfquery>

<cfscript>
	process_cat = attributes.process_cat;
	process_type = get_process_type.process_type;
	is_cari = get_process_type.is_cari;
	is_account = get_process_type.is_account;
</cfscript>

<cfif len(attributes.action_to_account_id)>
	<cfscript>
		action_to_account_id = listfirst(attributes.action_to_account_id,';');
		account_currency_id = listgetat(attributes.action_to_account_id,2,';');
		if(process_type eq 24)
		{
			to_branch_id = listlast(attributes.action_to_account_id,';');
			from_branch_id = "";
		}
		else
		{
			from_branch_id = listlast(attributes.action_to_account_id,';');
			to_branch_id = "";
		}
	</cfscript>
</cfif>
<cfif isDefined("attributes.bank_order_type") and not isDefined("attributes.i_id")><!--- talimattan, otomatik havale olusturma işlemleri için --->
	<cfquery name="GET_SUBSCRIPTION_DETAIL" datasource="#DSN2#">
		SELECT 
			BO.BANK_ORDER_TYPE,
			BO.BANK_ORDER_TYPE_ID,
			BO.ACTION_VALUE,
			BO.ACCOUNT_ID,
			BO.COMPANY_ID,
			BO.CONSUMER_ID,
            BO.EMPLOYEE_ID,
            BO.ACC_TYPE_ID,
			BO.TO_ACCOUNT_ID,
            BO.TO_BRANCH_ID,
            BO.FROM_BRANCH_ID,
			BO.IS_PAID,
			BO.OTHER_MONEY,
			BO.UPDATE_IP,
			BO.UPDATE_EMP,
			BO.UPDATE_DATE,
			BO.BANK_ORDER_ID,
            BO.ASSETP_ID,
            BO.PROJECT_ID,
            BO.PAYMENT_DATE,
            BO.ACTION_DETAIL,
			ACCOUNTS.ACCOUNT_ORDER_CODE,
			ACCOUNTS.ACCOUNT_CURRENCY_ID,
			ACCOUNTS.ACCOUNT_BRANCH_ID,
            BO.SPECIAL_DEFINITION_ID
		FROM 
			BANK_ORDERS BO,
			#dsn3_alias#.ACCOUNTS 
		WHERE 
			ACCOUNTS.ACCOUNT_ID = BO.ACCOUNT_ID AND
			(BO.IS_PAID = 0 OR BO.IS_PAID IS NULL) AND 
			BO.BANK_ORDER_ID IN (#checked_value#)
	</cfquery>
    
	<cfif GET_SUBSCRIPTION_DETAIL.recordcount>
		<cfquery name="get_bank_order_process_type" datasource="#DSN3#">
			SELECT 
				PROCESS_TYPE,
				IS_CARI,
				IS_ACCOUNT
			 FROM 
				SETUP_PROCESS_CAT 
			WHERE 
				PROCESS_CAT_ID = #GET_SUBSCRIPTION_DETAIL.BANK_ORDER_TYPE_ID#
		</cfquery>
		<cfif len(attributes.action_to_account_id)>
			<cfquery name="GET_ACC_CODE_INFO" datasource="#DSN3#">
				SELECT ACCOUNT_ORDER_CODE FROM ACCOUNTS WHERE ACCOUNT_ID = #listfirst(attributes.action_to_account_id,';')#
			</cfquery>
		</cfif>
		<cfset assign_order_process_type = get_bank_order_process_type.PROCESS_TYPE>
		<cfset assign_order_cari = get_bank_order_process_type.IS_CARI>
		<cfset assign_order_account = get_bank_order_process_type.IS_ACCOUNT>
		<!--- Talimatta Cari islem yapilirsa havalede yapilamaz, talimatta Muhasebe islemi secili ise havalede de secilmelidir --->
		<cfif ((assign_order_cari eq 1) and (is_cari eq 1)) or ((assign_order_account eq 1) and (is_account eq 0))><!--- talimattan havale dönüştürme kontrolü --->
			<script type="text/javascript">
				alert("İşlem Kategorilerinizi Kontrol Ediniz!");
				history.back();
			</script>
			<cfabort>
		</cfif>
		<cfoutput query="GET_SUBSCRIPTION_DETAIL">
			<cfquery name="GET_MONEY_INFO" datasource="#DSN2#">
				SELECT MONEY_TYPE AS MONEY,RATE1,RATE2,1 AS MONEY_STATUS FROM BANK_ORDER_MONEY WHERE ACTION_ID = #BANK_ORDER_ID#
			</cfquery>		
			<cfif not GET_MONEY_INFO.recordcount>
				<cfquery name="GET_MONEY_INFO" datasource="#DSN2#">
					SELECT MONEY,RATE1,RATE2,MONEY_STATUS FROM SETUP_MONEY
				</cfquery>
			</cfif>
			<cfif isdefined("attributes.from_list") and attributes.from_list eq 1>
				<cfquery name="GET_MONEY_INFO_ROW" dbtype="query">
					SELECT MONEY,RATE1,RATE2 FROM GET_MONEY_INFO WHERE MONEY_STATUS = 1
				</cfquery>
				<cfset attributes.kur_say = GET_MONEY_INFO_ROW.RECORDCOUNT>
				<cfset attributes.process_date = dateformat(now(),dateformat_style)>
				<cf_date tarih='attributes.process_date'>
				<cfloop query="GET_MONEY_INFO_ROW">
					<cfset "attributes.hidden_rd_money_#currentrow#" = money>
					<cfset "attributes.txt_rate1_#currentrow#" = rate1>
					<cfset "attributes.txt_rate2_#currentrow#" = TLFormat(rate2,4)>
					<cfif money eq session.ep.money2>
						<cfset attributes.rd_money = "#money#,#currentrow#,#rate1#,#rate2#">
					</cfif>
				</cfloop>
			</cfif>
			<cfset currency_multiplier = "">
			<cfset currency_multiplier_other = "">
			<cfif isdefined("attributes.rd_money") and isDefined("attributes.bank_order_type") and not isDefined("attributes.i_id")>
				<cfscript>
					for(k=1; k lte attributes.kur_say; k=k+1)
					{
						'attributes.txt_rate1_#k#' = filterNum(evaluate('attributes.txt_rate1_#k#'),session.ep.our_company_info.rate_round_num);
						'attributes.txt_rate2_#k#' = filterNum(evaluate('attributes.txt_rate2_#k#'),session.ep.our_company_info.rate_round_num);
						if( evaluate("attributes.hidden_rd_money_#k#") is session.ep.money2)
							currency_multiplier = evaluate('attributes.txt_rate2_#k#/attributes.txt_rate1_#k#');
					}
				</cfscript>
			</cfif>
			<cfset attributes.process_date = dateformat(GET_SUBSCRIPTION_DETAIL.payment_date,'dd/mm/yyyy')>
			<cf_date tarih='attributes.process_date'>
            
			<!--- talimatin oldugu bankaya direkt havale yapiliyorsa, yani arayuzden banka secilmiyorsa --->
			<cfif not len(attributes.action_to_account_id)>
				<cfset GET_ACC_CODE_INFO.ACCOUNT_ORDER_CODE = GET_SUBSCRIPTION_DETAIL.ACCOUNT_ORDER_CODE>
				<cfset action_to_account_id = GET_SUBSCRIPTION_DETAIL.ACCOUNT_ID>
				<cfset account_currency_id = GET_SUBSCRIPTION_DETAIL.ACCOUNT_CURRENCY_ID>
				<cfif process_type eq 24>
					<cfset to_branch_id = GET_SUBSCRIPTION_DETAIL.TO_BRANCH_ID>
					<cfset from_branch_id = "">
				<cfelse>
					<cfset to_branch_id = "">
					<cfset from_branch_id = GET_SUBSCRIPTION_DETAIL.FROM_BRANCH_ID>
				</cfif>
			</cfif>
            <cfset action_detail = GET_SUBSCRIPTION_DETAIL.action_detail>
			<cfset ozel_kod = GET_SUBSCRIPTION_DETAIL.SPECIAL_DEFINITION_ID>
			<cfset nettotal = GET_SUBSCRIPTION_DETAIL.ACTION_VALUE>
			<cfif len(GET_SUBSCRIPTION_DETAIL.COMPANY_ID)>
				<cfset acc_member_name = get_par_info(GET_SUBSCRIPTION_DETAIL.COMPANY_ID,1,1,0)>
			<cfelseif len(GET_SUBSCRIPTION_DETAIL.CONSUMER_ID)>
				<cfset acc_member_name = get_cons_info(GET_SUBSCRIPTION_DETAIL.CONSUMER_ID,0,0)>
			<cfelseif len(GET_SUBSCRIPTION_DETAIL.EMPLOYEE_ID)>
				<cfset acc_member_name = get_emp_info(GET_SUBSCRIPTION_DETAIL.EMPLOYEE_ID,0,0,0)>
			</cfif>
			<cfset process_money_info = GET_SUBSCRIPTION_DETAIL.OTHER_MONEY>
			<cfscript>
				for(k=1; k lte attributes.kur_say; k=k+1)
				{
					if(evaluate("attributes.hidden_rd_money_#k#") eq process_money_info)
						currency_multiplier_other = evaluate('attributes.txt_rate2_#k#/attributes.txt_rate1_#k#');
					if( evaluate("attributes.hidden_rd_money_#k#") eq  account_currency_id)
						system_currency_multiplier = evaluate('attributes.txt_rate2_#k#/attributes.txt_rate1_#k#');
				}
			</cfscript>
		<!---	<cfif (is_account eq 1) and len(GET_ACC_CODE_INFO.ACCOUNT_ORDER_CODE) and (assign_order_account eq 1)><!--- Banka Talimatı Muhasebe Kodu --->
				<cfset my_acc_result = GET_ACC_CODE_INFO.ACCOUNT_ORDER_CODE>
			<cfelse> ---->
				<cfif len(GET_SUBSCRIPTION_DETAIL.COMPANY_ID)>
					<cfset my_acc_result = get_company_period(GET_SUBSCRIPTION_DETAIL.COMPANY_ID)>
				<cfelseif len(GET_SUBSCRIPTION_DETAIL.CONSUMER_ID)>
					<cfset my_acc_result = get_consumer_period(GET_SUBSCRIPTION_DETAIL.CONSUMER_ID)>
				<cfelseif len(GET_SUBSCRIPTION_DETAIL.EMPLOYEE_ID)>
					<cfset my_acc_result = get_employee_period(GET_SUBSCRIPTION_DETAIL.EMPLOYEE_ID, GET_SUBSCRIPTION_DETAIL.ACC_TYPE_ID)>
				</cfif>
		<!---	</cfif> --->
			<script type="text/javascript">
                <cfif not len(my_acc_result)>
                    alert("<cf_get_lang dictionary_id='49064.Seçtiğiniz Çalışan veya Üyenin Muhasebe Kodu Seçilmemiş'>!");
						<cfif not isdefined("attributes.draggable")>window.close();<cfelse>closeBoxDraggable( '<cfoutput>#attributes.modal_id#</cfoutput>' );</cfif>
                </cfif>
            </script>
			 <cftry> 
				<cflock name="#CreateUUID()#" timeout="20">
					<cftransaction>
						<cfinclude template="../query/add_gelenh_from_autopayment.cfm">
					</cftransaction>
				</cflock>
				 <cfcatch type="any">
                 	<br /><br /><br />
					#currentrow#.<cf_get_lang dictionary_id='48752.Havale Oluşturulamadı'>.
                    <cfabort>
				</cfcatch>
			</cftry> 
		</cfoutput>
		<script type="text/javascript">
			<cfif not isdefined("attributes.draggable")>window.close();<cfelse>
				window.opener.location.reload();
			window.close();</cfif>
		</script>
		<cfabort>
	<cfelse>
		<script language="JavaScript">
			alert("<cf_get_lang dictionary_id='48678.Havale oluşturulacak işlem bulunamadı'>!");
				<cfif not isdefined("attributes.draggable")>window.close();<cfelse>
					opener.location.reload();
				window.close();</cfif>
		</script>
		<cfabort>
	</cfif>
</cfif>

<cfif GET_IMPORT.recordcount>
	<cfif not len(GET_IMPORT.FILE_CONTENT)>
		<script language="JavaScript">
			alert("<cf_get_lang dictionary_id='49050.Şifrenizi Kontrol Ediniz'>!");
			<cfif not isdefined("attributes.draggable")>window.close();<cfelse>
				opener.location.reload();
			window.close();</cfif>
		</script>
		<cfabort>
	</cfif>
	<cfif attributes.is_encrypt_file eq 1>
		<cfset file_content_result = Decrypt(GET_IMPORT.FILE_CONTENT,attributes.key_type,"CFMX_COMPAT","Hex")>
	<cfelse>
		<cfset file_content_result = GET_IMPORT.FILE_CONTENT>
	</cfif>
	<cfset dosya = ListToArray(file_content_result,CRLF)>
	<cfif attributes.is_encrypt_file eq 1>
		<cfif not(left(file_content_result,1) eq "H" or left(file_content_result,2) eq "10")><!--- encrypt in doğru açılması kontrolu --->
			<script language="JavaScript">
				alert("<cf_get_lang dictionary_id='49050.Şifrenizi Kontrol Ediniz'>");
					<cfif not isdefined("attributes.draggable")>window.close();<cfelse>
						opener.location.reload();
					window.close();</cfif>
			</script>
			<cfabort>
		</cfif>
	</cfif>
	<cfscript>
		ArrayDeleteAt(dosya,1);//header satırını silmek için
		line_count = ArrayLen(dosya);
	</cfscript>
	<cflock name="#CreateUUID()#" timeout="20">
		<cftransaction>
			<cfif GET_IMPORT.IS_DBS eq 1>
				<cfscript>
					attributes.kur_say = get_money_info.recordcount;
					attributes.rd_money = session.ep.money;
					to_branch_id = listgetat(session.ep.user_location,2,'-');
					from_branch_id = '';
				</cfscript>
				<cfloop from="1" to="#line_count#" index="i">
					<cfscript>
						for(k=1; k lte attributes.kur_say; k=k+1)
						{
							get_money_rate=cfquery(datasource:"#dsn2#", 
													sqlstring:"
													SELECT 
														TOP 1 RATE1,RATE2
													FROM 
														#dsn_alias#.MONEY_HISTORY
													WHERE
														VALIDATE_DATE = #CreateODBCDate(attributes.process_date)# AND
														MONEY = '#GET_MONEY_INFO.MONEY[k]#' 
													ORDER BY 
														VALIDATE_DATE DESC");
							if(get_money_rate.recordcount)
							{
								rate1 = get_money_rate.RATE1;
								rate2 = get_money_rate.RATE2;
							}
							else
							{
								rate1 = GET_MONEY_INFO.RATE1[k];
								rate2 = GET_MONEY_INFO.RATE2[k];
							}
							'attributes.hidden_rd_money_#k#'=GET_MONEY_INFO.MONEY[k];
							'attributes.txt_rate1_#k#'=rate1;	
							'attributes.txt_rate2_#k#'=rate2;
							if(evaluate("attributes.hidden_rd_money_#k#") is session.ep.money2)
								currency_multiplier = evaluate('attributes.txt_rate2_#k#/attributes.txt_rate1_#k#');
						}
					</cfscript>
					<cftry>
						<cfscript>
							banka_kur = '';
							satir = dosya[i];
							other_nettotal = val(oku(satir,94,15));		//tutar (islem dovizi tutari)
							process_money_info = oku(satir,109,3);		//doviz (islem dovizi)
							prov_row_id = val(oku(satir,113,20));		//prov satır idsi
							is_approved = oku(satir,133,3);				//geri donus bilgisi tahsil edildi ise 001 edilmedi ise 000
							result_code = oku(satir,136,3);				//akibet kodu
							result_detail = oku(satir,139,20);			//akibet aciklamasi
							banka_kur = oku(satir,159,7);				//kur bilgisi
							iban = trim(oku(satir,166,34));				//iban bilgisi
							discount_value = val(oku(satir,200,15));	//iskonto tutari
							last_value = val(oku(satir,215,15));		//iskonto dusulmus tutar
							payment_date = oku(satir,230,8);			//fatura odeme tarihi
						</cfscript>
						<cfset banka_kur_ = Replace(banka_kur,".",",","all")>
                        <cfif process_money_info eq 'TRY'><cfset process_money_info = 'TL'></cfif>
						<!--- satirdaki iban numarasina göre account_id, para birimi ve şube set ediliyor --->
						<cfif len(iban) and not len(attributes.action_to_account_id)>
							<cfquery name="get_accounts_" datasource="#dsn2#">
								SELECT
									ACCOUNT_CURRENCY_ID,
									ACCOUNT_ID
								FROM
									#dsn3_alias#.ACCOUNTS
								WHERE
									ACCOUNT_OWNER_CUSTOMER_NO ='#iban#'
							</cfquery>
							<cfif get_accounts_.recordcount>
								<cfset action_to_account_id = get_accounts_.ACCOUNT_ID>
								<cfset account_currency_id = get_accounts_.ACCOUNT_CURRENCY_ID>
							<cfelse>
								<cfoutput>#i#. Iban No Kontrol Ediniz.<br/></cfoutput>
							</cfif>
						</cfif>
						<cfif (len(iban) and isdefined("get_accounts_") and get_accounts_.recordcount) or len(attributes.action_to_account_id)>
							<cfif len(prov_row_id) and prov_row_id neq 0>
								<cfif is_approved eq '001'>
									<cfif len(banka_kur_) and (filterNum(banka_kur_) neq 0.00000)>
										<cfset get_money_info_row.rate2 = filterNum(banka_kur_,5)>
										<cfif process_money_info eq account_currency_id>
											<cfset get_money_info_row2.rate2 = filterNum(banka_kur_,5)>
										</cfif>
										<cfif process_money_info eq session.ep.money2>
											<cfset currency_multiplier = filterNum(banka_kur_,5)>
										</cfif>
										<cfset currency_multiplier_other = filterNum(banka_kur_,5)>
										<cfscript>
											for(k=1; k lte attributes.kur_say; k=k+1)
											{
												if( evaluate("attributes.hidden_rd_money_#k#") is process_money_info)
													'attributes.txt_rate2_#k#' = filterNum(banka_kur_,5);
											}
										</cfscript>
									<cfelse>
										<cfquery name="get_money_info_row" datasource="#DSN2#">
											SELECT
												RATE2
											FROM 
												#dsn_alias#.MONEY_HISTORY
											WHERE 
												VALIDATE_DATE <= #CreateODBCDate(attributes.process_date)#
												AND PERIOD_ID = #session.ep.period_id#
												AND MONEY = '#process_money_info#'
											ORDER BY 
												MONEY_HISTORY_ID DESC
										</cfquery>
										<cfif get_money_info_row.recordcount eq 0>
											<cfquery name="get_money_info_row" dbtype="query">
												SELECT 
													* 
												 FROM 
													get_money_info 
												WHERE 
													MONEY = '#process_money_info#'
											</cfquery>
										</cfif>
										<cfset currency_multiplier_other = get_money_info_row.rate2>
									</cfif>
									<cfscript>
										banka_kur_2 = val(banka_kur_); 
									</cfscript>
									<cfif not (len(banka_kur_) and banka_kur_2 neq 0 and process_money_info eq account_currency_id)>
										<cfquery name="get_money_info_row2" datasource="#DSN2#">
											SELECT
												RATE2
											FROM 
												#dsn_alias#.MONEY_HISTORY
											WHERE 
												VALIDATE_DATE <= #CreateODBCDate(attributes.process_date)#
												AND PERIOD_ID = #session.ep.period_id#
												AND MONEY = '#account_currency_id#'
											ORDER BY 
												MONEY_HISTORY_ID DESC
										</cfquery>
										<cfif get_money_info_row2.recordcount eq 0>
											<cfquery name="get_money_info_row2" dbtype="query">
												SELECT 
													* 
												 FROM 
													get_money_info 
												WHERE 
													MONEY = '#account_currency_id#'
											</cfquery>
										</cfif>
									</cfif>
                                    <!--- dosya ile gonderilen iskontodan dusulmus tutarin dogrulugu onaylanir --->
                                    <cfif last_value eq val(other_nettotal - discount_value)>
                                    	<cfset other_nettotal = last_value>
                                    </cfif>
									<!--- other_nettotal: dosya ile gonderilen islem dovizi tutar karsiligi
										  nettotal_system: sistem dovizi karsiligi (TL)
										  nettotal: secilen banka hesabina ait islem doviz tutar karsiligi
									  --->
									<cfset nettotal_system = wrk_round(other_nettotal*get_money_info_row.rate2)>
									<cfset nettotal = wrk_round(nettotal_system/get_money_info_row2.rate2)>
									<cfquery name="GET_INVOICE_PAYMENT_PLAN_DETAIL" datasource="#DSN2#">
										SELECT COMPANY_ID,CONSUMER_ID, EMPLOYEE_ID FROM #dsn3_alias#.INVOICE_PAYMENT_PLAN WITH (NOLOCK) WHERE INVOICE_PAYMENT_PLAN_ID = #prov_row_id#
									</cfquery>
									<cfif len(GET_INVOICE_PAYMENT_PLAN_DETAIL.COMPANY_ID)>
										<cfset GET_SUBSCRIPTION_DETAIL.COMPANY_ID = GET_INVOICE_PAYMENT_PLAN_DETAIL.COMPANY_ID>
										<cfset my_acc_result = get_company_period(GET_INVOICE_PAYMENT_PLAN_DETAIL.COMPANY_ID)>
									<cfelseif len(GET_INVOICE_PAYMENT_PLAN_DETAIL.CONSUMER_ID)>
										<cfset GET_SUBSCRIPTION_DETAIL.CONSUMER_ID = GET_INVOICE_PAYMENT_PLAN_DETAIL.CONSUMER_ID>
										<cfset my_acc_result = get_consumer_period(GET_INVOICE_PAYMENT_PLAN_DETAIL.CONSUMER_ID)>
									<cfelseif len(GET_INVOICE_PAYMENT_PLAN_DETAIL.EMPLOYEE_ID)>
										<cfset GET_SUBSCRIPTION_DETAIL.EMPLOYEE_ID = GET_INVOICE_PAYMENT_PLAN_DETAIL.EMPLOYEE_ID>
										<cfset my_acc_result = get_employee_period(GET_INVOICE_PAYMENT_PLAN_DETAIL.EMPLOYEE_ID)>
									</cfif>
									<cfset wrk_id = dateformat(now(),'YYYYMMDD')&timeformat(now(),'HHmmssL')&'_#session.ep.userid#_'&round(rand()*100)>
									<!--- gelen havale kaydı yapılır --->
									<cfinclude template="../query/add_gelenh_from_autopayment.cfm">
                                    <cfif len(payment_date)><cfset payment_date_ = "#mid(payment_date,5,2) & '/' &right(payment_date,2) & '/' & left(payment_date,4)#"></cfif>
									<cfquery name="UPD_INVOICE_PAYMENT_PLAN" datasource="#DSN2#"><!--- onay aldıysa ödendi set edilir --->
										UPDATE
											#dsn3_alias#.INVOICE_PAYMENT_PLAN
										SET
											IS_PAID = 1,
											RESULT_CODE = '#result_code#',
											RESULT_DETAIL = '#result_detail#',
											BANK_ACTION_ID = #MAX_ID.IDENTITYCOL#,
											BANK_PERIOD_ID = #session.ep.period_id#,
                                            DISCOUNT_TOTAL = <cfif last_value eq other_nettotal>#val(discount_value)#<cfelse>0</cfif>,
                                            PAYMENT_DATE = <cfif len(payment_date)>#createODBCDate(payment_date_)#<cfelse>NULL</cfif>,
											UPDATE_DATE = #now()#,
											UPDATE_IP = '#cgi.remote_addr#',
											UPDATE_EMP = #session.ep.userid#
										WHERE
											INVOICE_PAYMENT_PLAN_ID = #prov_row_id#
									</cfquery>
									<cfoutput>#i#. <cf_get_lang dictionary_id='64412.Otomatik Ödeme İşlemi Onaylandı'><br/></cfoutput>
								<cfelse>
									<cfquery name="UPD_INVOICE_PAYMENT_PLAN" datasource="#DSN2#"><!--- onay almadiysa sadece akibet kodu ile aciklamasi set edilir --->
										UPDATE
											#dsn3_alias#.INVOICE_PAYMENT_PLAN
										SET
											RESULT_CODE = #result_code#,
											RESULT_DETAIL = '#result_detail#',
											UPDATE_DATE = #now()#,
											UPDATE_IP = '#cgi.remote_addr#',
											UPDATE_EMP = #session.ep.userid#
										WHERE
											INVOICE_PAYMENT_PLAN_ID = #prov_row_id#
									</cfquery>
									<cfoutput>#i#. <cf_get_lang dictionary_id='64413.Otomatik Ödeme İşlemi Onaylanmadı'><br/></cfoutput>
								</cfif>
							<cfelse>
								<cfoutput>#i#. <cf_get_lang dictionary_id='64415.Provizyon ID Kontrol Ediniz'>.<br/></cfoutput>
							</cfif>
						</cfif>
						<cfcatch type="any">
							<cfoutput>
								<script>
								alert("#i#. <cf_get_lang dictionary_id='64411.Satırda İşlem Kesilmiştir! Belgenizi Düzeltip Tekrar İmport Etmeniz Gerekmektedir'>");
									<cfif not isdefined("attributes.draggable")>window.close();<cfelse>closeBoxDraggable( '<cfoutput>#attributes.modal_id#</cfoutput>' );</cfif>
								</script>
							</cfoutput>
							<cfabort>
						</cfcatch> 
					</cftry>
				</cfloop>
			<cfelse>
				<cfif GET_IMPORT.SOURCE_SYSTEM eq 30><!--- HSBC --->
					<cfloop from="1" to="#line_count-1#" index="i"><!--- trailer satırını almamak için --->
						<cftry>
							<cfscript>
								satir = dosya[i];
								invoice_id = oku(satir,12,12);//invoice idsi
								prov_row_id = oku(satir,24,12);//prov satır idsi
								nettotal = oku(satir,36,15);//Tutar
							</cfscript>
							
							<cfquery name="GET_PERIOD_INFO" datasource="#DSN2#">
								SELECT PERIOD_ID FROM #dsn3_alias#.SUBSCRIPTION_PAYMENT_PLAN_ROW WITH (NOLOCK) WHERE SUBSCRIPTION_PAYMENT_ROW_ID = #prov_row_id#
							</cfquery>
							<cfquery name="GET_SUBSCRIPTION_DETAIL" datasource="#DSN2#">
								SELECT 
									INVOICE_COMPANY_ID COMPANY_ID,
									INVOICE_CONSUMER_ID CONSUMER_ID
								FROM 
									#dsn3_alias#.SUBSCRIPTION_PAYMENT_PLAN_ROW SPR WITH (NOLOCK),
									#dsn3_alias#.SUBSCRIPTION_CONTRACT SC WITH (NOLOCK)
								WHERE 
									SPR.SUBSCRIPTION_ID = SC.SUBSCRIPTION_ID AND
									SPR.INVOICE_ID = #invoice_id# AND
									SPR.PERIOD_ID = #GET_PERIOD_INFO.PERIOD_ID#
							</cfquery>
							<cfif len(GET_SUBSCRIPTION_DETAIL.COMPANY_ID)>
								<cfset my_acc_result = get_company_period(GET_SUBSCRIPTION_DETAIL.COMPANY_ID)>
							<cfelse>
								<cfset my_acc_result = get_consumer_period(GET_SUBSCRIPTION_DETAIL.CONSUMER_ID)>
							</cfif>
							<cfset wrk_id = dateformat(now(),'YYYYMMDD')&timeformat(now(),'HHmmssL')&'_#session.ep.userid#_'&round(rand()*100)>
							<!--- gelen havale kaydı yapılır --->
							<cfinclude template="../query/add_gelenh_from_autopayment.cfm">
							<cfquery name="UPD_PAYMENT_ROWS" datasource="#DSN2#"><!--- onay aldıysa ödendi set edilir --->
								UPDATE
									#dsn3_alias#.SUBSCRIPTION_PAYMENT_PLAN_ROW
								SET
									IS_PAID = 1,
									<cfif isdefined("cari_act_id_inf") and len(cari_act_id_inf) and get_cari_rows.recordcount>
										CARI_ACTION_ID = #get_cari_rows.cari_action_id#,
										CARI_PERIOD_ID = #session.ep.period_id#,
										CARI_ACT_TYPE = #get_cari_rows.action_type_id#,
										CARI_ACT_ID = #get_cari_rows.action_id#,
										CARI_ACT_TABLE = '#get_cari_rows.action_table#',
									</cfif>
									UPDATE_DATE = #now()#,
									UPDATE_IP = '#cgi.remote_addr#',
									UPDATE_EMP = #session.ep.userid#
								WHERE
									INVOICE_ID = #invoice_id# AND
									PERIOD_ID = #GET_PERIOD_INFO.PERIOD_ID#
							</cfquery>
							<cfquery name="get_period_year" datasource="#dsn2#">
								SELECT PERIOD_YEAR FROM #dsn_alias#.SETUP_PERIOD WHERE PERIOD_ID = #GET_PERIOD_INFO.PERIOD_ID#
							</cfquery>
							<cfset new_dsn2 = "#dsn#_#get_period_year.period_year#_#session.ep.company_id#">
							<cfquery name="upd_inv" datasource="#dsn2#">
								UPDATE #new_dsn2#.INVOICE SET BANK_ACTION_ID = #get_cari_rows.action_id#,BANK_PERIOD_ID = #session.ep.period_id# WHERE INVOICE_ID = #invoice_id#
							</cfquery>
							<cfoutput>#i# <cf_get_lang dictionary_id='64412.Otomatik Ödeme İşlemi Onaylandı'><br/></cfoutput>
							<cfcatch type="any">
								<cfoutput>
									<script>
										alert("#i#. <cf_get_lang dictionary_id='64411.Satırda İşlem Kesilmiştir! Belgenizi Düzeltip Tekrar İmport Etmeniz Gerekmektedir'>");
										<cfif not isdefined("attributes.draggable")>window.close();<cfelse>closeBoxDraggable( '<cfoutput>#attributes.modal_id#</cfoutput>' );</cfif>
									</script><br/>
								</cfoutput>
								<cfabort>
							</cfcatch>
						</cftry>
					</cfloop>
				</cfif>
				
				<cfif GET_IMPORT.SOURCE_SYSTEM eq 31><!--- Finansbank --->
					<cfloop from="1" to="#line_count-1#" index="i"><!--- trailer satırını almamak için --->
						<cftry>
							<cfscript>
								satir = dosya[i];
								invoice_id = val(oku(satir,14,12));//invoice idsi
								prov_row_id = oku(satir,57,15);//prov satır idsi
								nettotal = oku(satir,42,15);//Tutar
							</cfscript>
							<cfquery name="GET_PERIOD_INFO" datasource="#DSN2#">
								SELECT PERIOD_ID FROM #dsn3_alias#.SUBSCRIPTION_PAYMENT_PLAN_ROW WITH (NOLOCK) WHERE SUBSCRIPTION_PAYMENT_ROW_ID = #prov_row_id#
							</cfquery>
							<cfquery name="GET_SUBSCRIPTION_DETAIL" datasource="#DSN2#">
								SELECT 
									INVOICE_COMPANY_ID COMPANY_ID,
									INVOICE_CONSUMER_ID CONSUMER_ID
								FROM 
									#dsn3_alias#.SUBSCRIPTION_PAYMENT_PLAN_ROW SPR WITH (NOLOCK),
									#dsn3_alias#.SUBSCRIPTION_CONTRACT SC WITH (NOLOCK)
								WHERE 
									SPR.SUBSCRIPTION_ID = SC.SUBSCRIPTION_ID AND
									SPR.INVOICE_ID = #invoice_id# AND
									SPR.PERIOD_ID = #GET_PERIOD_INFO.PERIOD_ID#
							</cfquery>
							<cfif len(GET_SUBSCRIPTION_DETAIL.COMPANY_ID)>
								<cfset my_acc_result = get_company_period(GET_SUBSCRIPTION_DETAIL.COMPANY_ID)>
							<cfelse>
								<cfset my_acc_result = get_consumer_period(GET_SUBSCRIPTION_DETAIL.CONSUMER_ID)>
							</cfif>
							<cfset wrk_id = dateformat(now(),'YYYYMMDD')&timeformat(now(),'HHmmssL')&'_#session.ep.userid#_'&round(rand()*100)>
							<!--- gelen havale kaydı yapılır --->
							<cfinclude template="../query/add_gelenh_from_autopayment.cfm">
							<cfquery name="UPD_PAYMENT_ROWS" datasource="#DSN2#"><!--- onay aldıysa ödendi set edilir --->
								UPDATE
									#dsn3_alias#.SUBSCRIPTION_PAYMENT_PLAN_ROW
								SET
									IS_PAID = 1,
									<cfif isdefined("cari_act_id_inf") and len(cari_act_id_inf) and get_cari_rows.recordcount>
											CARI_ACTION_ID = #get_cari_rows.cari_action_id#,
											CARI_PERIOD_ID = #session.ep.period_id#,
											CARI_ACT_TYPE = #get_cari_rows.action_type_id#,
											CARI_ACT_ID = #get_cari_rows.action_id#,
											CARI_ACT_TABLE = '#get_cari_rows.action_table#',
										</cfif>
									UPDATE_DATE = #now()#,
									UPDATE_IP = '#cgi.remote_addr#',
									UPDATE_EMP = #session.ep.userid#
								WHERE
									INVOICE_ID = #invoice_id# AND
									PERIOD_ID = #GET_PERIOD_INFO.PERIOD_ID#
							</cfquery>
							<cfquery name="get_period_year" datasource="#dsn2#">
								SELECT PERIOD_YEAR FROM #dsn_alias#.SETUP_PERIOD WHERE PERIOD_ID = #GET_PERIOD_INFO.PERIOD_ID#
							</cfquery>
							<cfset new_dsn2 = "#dsn#_#get_period_year.period_year#_#session.ep.company_id#">
							<cfquery name="upd_inv" datasource="#dsn2#">
								UPDATE #new_dsn2#.INVOICE SET BANK_ACTION_ID = #get_cari_rows.action_id#,BANK_PERIOD_ID = #session.ep.period_id# WHERE INVOICE_ID = #invoice_id#
							</cfquery>
							<cfoutput>#i# <cf_get_lang dictionary_id='64412.Otomatik Ödeme İşlemi Onaylandı'><br/></cfoutput>
							<cfcatch type="any">
								<cfoutput>
									<script>
										alert("#i#. <cf_get_lang dictionary_id='64411.Satırda İşlem Kesilmiştir! Belgenizi Düzeltip Tekrar İmport Etmeniz Gerekmektedir'>");
										<cfif not isdefined("attributes.draggable")>window.close();<cfelse>closeBoxDraggable( '<cfoutput>#attributes.modal_id#</cfoutput>' );</cfif>
										</script><br/>
								</cfoutput>
								<cfabort>
							</cfcatch>
						</cftry>
					</cfloop>
				</cfif>
				
				<cfif GET_IMPORT.SOURCE_SYSTEM eq 32><!--- İşBankası --->
					<cfloop from="1" to="#line_count-2#" index="i"><!--- trailer satırlarını almamak için --->
						<cftry>
							<cfscript>
								satir = dosya[i];
								invoice_id = oku(satir,18,16);//invoice idsi
								nettotal = oku(satir,42,15);//Tutar
								prov_code = oku(satir,89,2);//Onay kodu
								prov_row_id = oku(satir,134,105);//prov satır idsi
							</cfscript>
							<cfif prov_code eq 71 and left(satir,2) eq 51><!--- 51otomatik ödeme alonan kayıtlar  ve  71 tahsilat yapıldı onay kodu --->
								<cfquery name="GET_PERIOD_INFO" datasource="#DSN2#">
									SELECT PERIOD_ID FROM #dsn3_alias#.SUBSCRIPTION_PAYMENT_PLAN_ROW WITH (NOLOCK) WHERE SUBSCRIPTION_PAYMENT_ROW_ID = #prov_row_id#
								</cfquery>
								<cfquery name="GET_SUBSCRIPTION_DETAIL" datasource="#DSN2#">
									SELECT 
										INVOICE_COMPANY_ID COMPANY_ID,
										INVOICE_CONSUMER_ID CONSUMER_ID
									FROM 
										#dsn3_alias#.SUBSCRIPTION_PAYMENT_PLAN_ROW SPR WITH (NOLOCK),
										#dsn3_alias#.SUBSCRIPTION_CONTRACT SC WITH (NOLOCK)
									WHERE 
										SPR.SUBSCRIPTION_ID = SC.SUBSCRIPTION_ID AND
										SPR.INVOICE_ID = #invoice_id# AND
										SPR.PERIOD_ID = #GET_PERIOD_INFO.PERIOD_ID#
								</cfquery>
								<cfif len(GET_SUBSCRIPTION_DETAIL.COMPANY_ID)>
									<cfset my_acc_result = get_company_period(GET_SUBSCRIPTION_DETAIL.COMPANY_ID)>
								<cfelse>
									<cfset my_acc_result = get_consumer_period(GET_SUBSCRIPTION_DETAIL.CONSUMER_ID)>
								</cfif>
								<cfset wrk_id = dateformat(now(),'YYYYMMDD')&timeformat(now(),'HHmmssL')&'_#session.ep.userid#_'&round(rand()*100)>
								<!--- gelen havale kaydı yapılır --->
								<cfinclude template="../query/add_gelenh_from_autopayment.cfm">
								<cfquery name="UPD_PAYMENT_ROWS" datasource="#DSN2#"><!--- onay aldıysa ödendi set edilir --->
									UPDATE
										#dsn3_alias#.SUBSCRIPTION_PAYMENT_PLAN_ROW
									SET
										IS_PAID = 1,
										<cfif isdefined("cari_act_id_inf") and len(cari_act_id_inf) and get_cari_rows.recordcount>
											CARI_ACTION_ID = #get_cari_rows.cari_action_id#,
											CARI_PERIOD_ID = #session.ep.period_id#,
											CARI_ACT_TYPE = #get_cari_rows.action_type_id#,
											CARI_ACT_ID = #get_cari_rows.action_id#,
											CARI_ACT_TABLE = '#get_cari_rows.action_table#',
										</cfif>
										UPDATE_DATE = #now()#,
										UPDATE_IP = '#cgi.remote_addr#',
										UPDATE_EMP = #session.ep.userid#
									WHERE
										INVOICE_ID = #invoice_id# AND
										PERIOD_ID = #GET_PERIOD_INFO.PERIOD_ID#
								</cfquery>
								<cfquery name="get_period_year" datasource="#dsn2#">
									SELECT PERIOD_YEAR FROM #dsn_alias#.SETUP_PERIOD WHERE PERIOD_ID = #GET_PERIOD_INFO.PERIOD_ID#
								</cfquery>
								<cfset new_dsn2 = "#dsn#_#get_period_year.period_year#_#session.ep.company_id#">
								<cfquery name="upd_inv" datasource="#dsn2#">
									UPDATE #new_dsn2#.INVOICE SET BANK_ACTION_ID = #get_cari_rows.action_id#,BANK_PERIOD_ID = #session.ep.period_id# WHERE INVOICE_ID = #invoice_id#
								</cfquery>
								<cfoutput>#i# <cf_get_lang dictionary_id='64412.Otomatik Ödeme İşlemi Onaylandı'><br/></cfoutput>
							<cfelse>
								<cfoutput>#i# <cf_get_lang dictionary_id='64413.Otomatik Ödeme İşlemi Onaylanmadı'> (<cf_get_lang dictionary_id='64414.Tahsilat Kodu'> : #prov_code#)<br/></cfoutput>
							</cfif>
							<cfcatch type="any">
								<cfoutput>
									<script>
										alert("#i#. <cf_get_lang dictionary_id='64411.Satırda İşlem Kesilmiştir! Belgenizi Düzeltip Tekrar İmport Etmeniz Gerekmektedir'>");
										<cfif not isdefined("attributes.draggable")>window.close();<cfelse>closeBoxDraggable( '<cfoutput>#attributes.modal_id#</cfoutput>' );</cfif>
										</script>><br/>
								</cfoutput>
								<cfabort>
							</cfcatch>
						</cftry>
					</cfloop>
				</cfif>
				
				<cfif ListFind('33,36,37,39,44,46',GET_IMPORT.SOURCE_SYSTEM)><!--- Garanti,YKB,Akbank,Ziraat,halkbank ortak format, Sekerbank --->
					<cfloop from="1" to="#line_count-1#" index="i"><!--- trailer satırlarını almamak için --->
						<cftry>
							<cfscript>
								satir = dosya[i];
								invoice_id = oku(satir,57,13);//invoice idsi
								nettotal = oku(satir,86,15);//Tutar
								prov_code = oku(satir,179,2);//Onay kodu
								prov_row_id = oku(satir,119,60);//prov satır idsi
							</cfscript>
							<cfif prov_code eq 91>
								<cfquery name="GET_PERIOD_INFO" datasource="#DSN2#">
									SELECT PERIOD_ID FROM #dsn3_alias#.SUBSCRIPTION_PAYMENT_PLAN_ROW WITH (NOLOCK) WHERE SUBSCRIPTION_PAYMENT_ROW_ID = #prov_row_id#
								</cfquery>
								<cfquery name="GET_SUBSCRIPTION_DETAIL" datasource="#DSN2#">
									SELECT 
										INVOICE_COMPANY_ID COMPANY_ID,
										INVOICE_CONSUMER_ID CONSUMER_ID
									FROM 
										#dsn3_alias#.SUBSCRIPTION_PAYMENT_PLAN_ROW SPR WITH (NOLOCK),
										#dsn3_alias#.SUBSCRIPTION_CONTRACT SC WITH (NOLOCK)
									WHERE 
										SPR.SUBSCRIPTION_ID = SC.SUBSCRIPTION_ID AND
										SPR.INVOICE_ID = #invoice_id# AND
										SPR.PERIOD_ID = #GET_PERIOD_INFO.PERIOD_ID#
								</cfquery>
								<cfif len(GET_SUBSCRIPTION_DETAIL.COMPANY_ID)>
									<cfset my_acc_result = get_company_period(GET_SUBSCRIPTION_DETAIL.COMPANY_ID)>
								<cfelse>
									<cfset my_acc_result = get_consumer_period(GET_SUBSCRIPTION_DETAIL.CONSUMER_ID)>
								</cfif>
								<cfset wrk_id = dateformat(now(),'YYYYMMDD')&timeformat(now(),'HHmmssL')&'_#session.ep.userid#_'&round(rand()*100)>
								<!--- gelen havale kaydı yapılır --->
								<cfinclude template="../query/add_gelenh_from_autopayment.cfm">
								<cfquery name="UPD_PAYMENT_ROWS" datasource="#DSN2#"><!--- onay aldıysa ödendi set edilir --->
									UPDATE
										#dsn3_alias#.SUBSCRIPTION_PAYMENT_PLAN_ROW
									SET
										IS_PAID = 1,
										<cfif isdefined("cari_act_id_inf") and len(cari_act_id_inf) and get_cari_rows.recordcount>
											CARI_ACTION_ID = #get_cari_rows.cari_action_id#,
											CARI_PERIOD_ID = #session.ep.period_id#,
											CARI_ACT_TYPE = #get_cari_rows.action_type_id#,
											CARI_ACT_ID = #get_cari_rows.action_id#,
											CARI_ACT_TABLE = '#get_cari_rows.action_table#',
										</cfif>
										UPDATE_DATE = #now()#,
										UPDATE_IP = '#cgi.remote_addr#',
										UPDATE_EMP = #session.ep.userid#
									WHERE
										INVOICE_ID = #invoice_id# AND
										PERIOD_ID = #GET_PERIOD_INFO.PERIOD_ID#
								</cfquery>
								<cfquery name="get_period_year" datasource="#dsn2#">
									SELECT PERIOD_YEAR FROM #dsn_alias#.SETUP_PERIOD WHERE PERIOD_ID = #GET_PERIOD_INFO.PERIOD_ID#
								</cfquery>
								<cfset new_dsn2 = "#dsn#_#get_period_year.period_year#_#session.ep.company_id#">
								<cfquery name="upd_inv" datasource="#dsn2#">
									UPDATE #new_dsn2#.INVOICE SET BANK_ACTION_ID = #get_cari_rows.action_id#,BANK_PERIOD_ID = #session.ep.period_id# WHERE INVOICE_ID = #invoice_id#
								</cfquery>
								<cfoutput>#i# <cf_get_lang dictionary_id='64412.Otomatik Ödeme İşlemi Onaylandı'><br/></cfoutput>
							<cfelse>
								<cfoutput>#i# <cf_get_lang dictionary_id='64413.Otomatik Ödeme İşlemi Onaylanmadı'> (<cf_get_lang dictionary_id='64414.Tahsilat Kodu'> : #prov_code#)<br/></cfoutput>
							</cfif>
							<cfcatch type="any">
								<cfoutput>
									<script>
										alert("#i#. <cf_get_lang dictionary_id='64411.Satırda İşlem Kesilmiştir! Belgenizi Düzeltip Tekrar İmport Etmeniz Gerekmektedir'>");
										<cfif not isdefined("attributes.draggable")>window.close();<cfelse>closeBoxDraggable( '<cfoutput>#attributes.modal_id#</cfoutput>' );</cfif>
										</script><br/>
								</cfoutput>
								<cfabort>
							</cfcatch>
						</cftry>
					</cfloop>
				</cfif>
				
				<cfif GET_IMPORT.SOURCE_SYSTEM eq 34><!--- Oyakbank--->
					<cfloop from="1" to="#line_count-1#" index="i"><!--- trailer satırlarını almamak için --->
						<cftry>
							<cfscript>
								satir = dosya[i];
								invoice_id = oku(satir,57,13);//invoice idsi
								nettotal = oku(satir,86,15);//Tutar
								prov_code = oku(satir,179,2);//Onay kodu
								prov_row_id = oku(satir,119,60);//prov satır idsi
							</cfscript>
							<cfif prov_code eq 91>
								<cfquery name="GET_PERIOD_INFO" datasource="#DSN2#">
									SELECT PERIOD_ID FROM #dsn3_alias#.SUBSCRIPTION_PAYMENT_PLAN_ROW WITH (NOLOCK) WHERE SUBSCRIPTION_PAYMENT_ROW_ID = #prov_row_id#
								</cfquery>
								<cfquery name="GET_SUBSCRIPTION_DETAIL" datasource="#DSN2#">
									SELECT 
										INVOICE_COMPANY_ID COMPANY_ID,
										INVOICE_CONSUMER_ID CONSUMER_ID
									FROM 
										#dsn3_alias#.SUBSCRIPTION_PAYMENT_PLAN_ROW SPR WITH (NOLOCK),
										#dsn3_alias#.SUBSCRIPTION_CONTRACT SC WITH (NOLOCK)
									WHERE 
										SPR.SUBSCRIPTION_ID = SC.SUBSCRIPTION_ID AND
										SPR.INVOICE_ID = #invoice_id# AND
										SPR.PERIOD_ID = #GET_PERIOD_INFO.PERIOD_ID#
								</cfquery>
								<cfif len(GET_SUBSCRIPTION_DETAIL.COMPANY_ID)>
									<cfset my_acc_result = get_company_period(GET_SUBSCRIPTION_DETAIL.COMPANY_ID)>
								<cfelse>
									<cfset my_acc_result = get_consumer_period(GET_SUBSCRIPTION_DETAIL.CONSUMER_ID)>
								</cfif>
								<cfset wrk_id = dateformat(now(),'YYYYMMDD')&timeformat(now(),'HHmmssL')&'_#session.ep.userid#_'&round(rand()*100)>
								<!--- gelen havale kaydı yapılır --->
								<cfinclude template="../query/add_gelenh_from_autopayment.cfm">
								<cfquery name="UPD_PAYMENT_ROWS" datasource="#DSN2#"><!--- onay aldıysa ödendi set edilir --->
									UPDATE
										#dsn3_alias#.SUBSCRIPTION_PAYMENT_PLAN_ROW
									SET
										IS_PAID = 1,
										<cfif isdefined("cari_act_id_inf") and len(cari_act_id_inf) and get_cari_rows.recordcount>
											CARI_ACTION_ID = #get_cari_rows.cari_action_id#,
											CARI_PERIOD_ID = #session.ep.period_id#,
											CARI_ACT_TYPE = #get_cari_rows.action_type_id#,
											CARI_ACT_ID = #get_cari_rows.action_id#,
											CARI_ACT_TABLE = '#get_cari_rows.action_table#',
										</cfif>
										UPDATE_DATE = #now()#,
										UPDATE_IP = '#cgi.remote_addr#',
										UPDATE_EMP = #session.ep.userid#
									WHERE
										INVOICE_ID = #invoice_id# AND
										PERIOD_ID = #GET_PERIOD_INFO.PERIOD_ID#
								</cfquery>
									<cfquery name="get_period_year" datasource="#dsn2#">
									SELECT PERIOD_YEAR FROM #dsn_alias#.SETUP_PERIOD WHERE PERIOD_ID = #GET_PERIOD_INFO.PERIOD_ID#
								</cfquery>
								<cfset new_dsn2 = "#dsn#_#get_period_year.period_year#_#session.ep.company_id#">
								<cfquery name="upd_inv" datasource="#dsn2#">
									UPDATE #new_dsn2#.INVOICE SET BANK_ACTION_ID = #get_cari_rows.action_id#,BANK_PERIOD_ID = #session.ep.period_id# WHERE INVOICE_ID = #invoice_id#
								</cfquery>
								<cfoutput>#i# <cf_get_lang dictionary_id='64412.Otomatik Ödeme İşlemi Onaylandı'><br/></cfoutput>
							<cfelse>
								<cfoutput>#i# <cf_get_lang dictionary_id='64413.Otomatik Ödeme İşlemi Onaylanmadı'> (<cf_get_lang dictionary_id='64414.Tahsilat Kodu'> : #prov_code#)<br/></cfoutput>
							</cfif>
							<cfcatch type="any">
								<cfoutput>
									<script>
										alert("#i#. <cf_get_lang dictionary_id='64411.Satırda İşlem Kesilmiştir! Belgenizi Düzeltip Tekrar İmport Etmeniz Gerekmektedir'>");
										<cfif not isdefined("attributes.draggable")>window.close();<cfelse>closeBoxDraggable( '<cfoutput>#attributes.modal_id#</cfoutput>' );</cfif>
										</script><br/>
								</cfoutput>
								<cfabort>
							</cfcatch>
						</cftry>
					</cfloop>
				</cfif>
			
				<cfif GET_IMPORT.SOURCE_SYSTEM eq 35><!--- TEB--->
					<cfloop from="1" to="#line_count-1#" index="i"><!--- trailer satırlarını almamak için --->
						<cftry>
							<cfscript>
								satir = dosya[i];
								invoice_id = oku(satir,57,13);//invoice idsi
								nettotal = oku(satir,86,15);//Tutar
								prov_code = oku(satir,179,2);//Onay kodu
								prov_row_id = oku(satir,119,60);//prov satır idsi
							</cfscript>
							<cfif prov_code eq 91>
								<cfquery name="GET_PERIOD_INFO" datasource="#DSN2#">
									SELECT PERIOD_ID FROM #dsn3_alias#.SUBSCRIPTION_PAYMENT_PLAN_ROW WITH (NOLOCK) WHERE SUBSCRIPTION_PAYMENT_ROW_ID = #prov_row_id#
								</cfquery>
								<cfquery name="GET_SUBSCRIPTION_DETAIL" datasource="#DSN2#">
									SELECT 
										INVOICE_COMPANY_ID COMPANY_ID,
										INVOICE_CONSUMER_ID CONSUMER_ID
									FROM 
										#dsn3_alias#.SUBSCRIPTION_PAYMENT_PLAN_ROW SPR WITH (NOLOCK),
										#dsn3_alias#.SUBSCRIPTION_CONTRACT SC WITH (NOLOCK)
									WHERE 
										SPR.SUBSCRIPTION_ID = SC.SUBSCRIPTION_ID AND
										SPR.INVOICE_ID = #invoice_id# AND
										SPR.PERIOD_ID = #GET_PERIOD_INFO.PERIOD_ID#
								</cfquery>
								<cfif len(GET_SUBSCRIPTION_DETAIL.COMPANY_ID)>
									<cfset my_acc_result = get_company_period(GET_SUBSCRIPTION_DETAIL.COMPANY_ID)>
								<cfelse>
									<cfset my_acc_result = get_consumer_period(GET_SUBSCRIPTION_DETAIL.CONSUMER_ID)>
								</cfif>
								<cfset wrk_id = dateformat(now(),'YYYYMMDD')&timeformat(now(),'HHmmssL')&'_#session.ep.userid#_'&round(rand()*100)>
								<!--- gelen havale kaydı yapılır --->
								<cfinclude template="../query/add_gelenh_from_autopayment.cfm">
								<cfquery name="UPD_PAYMENT_ROWS" datasource="#DSN2#"><!--- onay aldıysa ödendi set edilir --->
									UPDATE
										#dsn3_alias#.SUBSCRIPTION_PAYMENT_PLAN_ROW
									SET
										IS_PAID = 1,
										<cfif isdefined("cari_act_id_inf") and len(cari_act_id_inf) and get_cari_rows.recordcount>
											CARI_ACTION_ID = #get_cari_rows.cari_action_id#,
											CARI_PERIOD_ID = #session.ep.period_id#,
											CARI_ACT_TYPE = #get_cari_rows.action_type_id#,
											CARI_ACT_ID = #get_cari_rows.action_id#,
											CARI_ACT_TABLE = '#get_cari_rows.action_table#',
										</cfif>
										UPDATE_DATE = #now()#,
										UPDATE_IP = '#cgi.remote_addr#',
										UPDATE_EMP = #session.ep.userid#
									WHERE
										INVOICE_ID = #invoice_id# AND
										PERIOD_ID = #GET_PERIOD_INFO.PERIOD_ID#
								</cfquery>
								<cfquery name="get_period_year" datasource="#dsn2#">
									SELECT PERIOD_YEAR FROM #dsn_alias#.SETUP_PERIOD WHERE PERIOD_ID = #GET_PERIOD_INFO.PERIOD_ID#
								</cfquery>
								<cfset new_dsn2 = "#dsn#_#get_period_year.period_year#_#session.ep.company_id#">
								<cfquery name="upd_inv" datasource="#dsn2#">
									UPDATE #new_dsn2#.INVOICE SET BANK_ACTION_ID = #get_cari_rows.action_id#,BANK_PERIOD_ID = #session.ep.period_id# WHERE INVOICE_ID = #invoice_id#
								</cfquery>
								<cfoutput>#i# <cf_get_lang dictionary_id='64412.Otomatik Ödeme İşlemi Onaylandı'><br/></cfoutput>
							<cfelse>
								<cfoutput>#i# <cf_get_lang dictionary_id='64413.Otomatik Ödeme İşlemi Onaylanmadı'> (<cf_get_lang dictionary_id='64414.Tahsilat Kodu'> : #prov_code#)<br/></cfoutput>
							</cfif>
							<cfcatch type="any">
								<cfoutput>
									<script>
										alert("#i#. <cf_get_lang dictionary_id='64411.Satırda İşlem Kesilmiştir! Belgenizi Düzeltip Tekrar İmport Etmeniz Gerekmektedir'>");
										<cfif not isdefined("attributes.draggable")>window.close();<cfelse>closeBoxDraggable( '<cfoutput>#attributes.modal_id#</cfoutput>' );</cfif>
										</script><br/>
								</cfoutput>
								<cfabort>
							</cfcatch>
						</cftry>
					</cfloop>
				</cfif>
				
				<cfif ListFind('41,45',GET_IMPORT.SOURCE_SYSTEM)><!--- Denizbank ve odeabank--->
					<cfloop from="1" to="#line_count-1#" index="i"><!--- trailer satırlarını almamak için --->
						  <cftry> 
							<cfscript>
								satir = dosya[i];
								invoice_id = oku(satir,17,15);//invoice nosu
								nettotal_1 = oku(satir,48,21);//Tutar
								prov_code = oku(satir,72,1);//Onay kodu
								prov_row_id = oku(satir,113,20);//prov satır idsi
								nettotal = "#nettotal_1#";
							</cfscript>
							<cfif prov_code eq 'T'>
								<cfquery name="GET_PERIOD_INFO" datasource="#DSN2#">
									SELECT PERIOD_ID FROM #dsn3_alias#.SUBSCRIPTION_PAYMENT_PLAN_ROW WITH (NOLOCK) WHERE SUBSCRIPTION_PAYMENT_ROW_ID = #prov_row_id#
								</cfquery>
	
								<cfquery name="GET_SUBSCRIPTION_DETAIL" datasource="#DSN2#">
									SELECT 
										INVOICE_COMPANY_ID COMPANY_ID,
										INVOICE_CONSUMER_ID CONSUMER_ID
									FROM 
										#dsn3_alias#.SUBSCRIPTION_PAYMENT_PLAN_ROW SPR WITH (NOLOCK),
										#dsn3_alias#.SUBSCRIPTION_CONTRACT SC WITH (NOLOCK)
									WHERE 
										SPR.SUBSCRIPTION_ID = SC.SUBSCRIPTION_ID AND
										SPR.INVOICE_ID = #invoice_id# AND
										SPR.PERIOD_ID = #GET_PERIOD_INFO.PERIOD_ID#
								</cfquery>
								<cfif len(GET_SUBSCRIPTION_DETAIL.COMPANY_ID)>
									<cfset my_acc_result = get_company_period(GET_SUBSCRIPTION_DETAIL.COMPANY_ID)>
								<cfelse>
									<cfset my_acc_result = get_consumer_period(GET_SUBSCRIPTION_DETAIL.CONSUMER_ID)>
								</cfif>
								<cfset wrk_id = dateformat(now(),'YYYYMMDD')&timeformat(now(),'HHmmssL')&'_#session.ep.userid#_'&round(rand()*100)>
								<!--- gelen havale kaydı yapılır --->
								<cfinclude template="../../bank/query/add_gelenh_from_autopayment.cfm"> 
								<cfquery name="UPD_PAYMENT_ROWS" datasource="#DSN2#"><!--- onay aldıysa ödendi set edilir --->
									UPDATE
										#dsn3_alias#.SUBSCRIPTION_PAYMENT_PLAN_ROW
									SET
										IS_PAID = 1,
										<cfif isdefined("cari_act_id_inf") and len(cari_act_id_inf) and get_cari_rows.recordcount>
											CARI_ACTION_ID = #get_cari_rows.cari_action_id#,
											CARI_PERIOD_ID = #session.ep.period_id#,
											CARI_ACT_TYPE = #get_cari_rows.action_type_id#,
											CARI_ACT_ID = #get_cari_rows.action_id#,
											CARI_ACT_TABLE = '#get_cari_rows.action_table#',
										</cfif>
										UPDATE_DATE = #now()#,
										UPDATE_IP = '#cgi.remote_addr#',
										UPDATE_EMP = #session.ep.userid#
									WHERE
										INVOICE_ID = #invoice_id# AND
										PERIOD_ID = #GET_PERIOD_INFO.PERIOD_ID#
								</cfquery>
								<cfquery name="get_period_year" datasource="#dsn2#">
									SELECT PERIOD_YEAR FROM #dsn_alias#.SETUP_PERIOD WHERE PERIOD_ID = #GET_PERIOD_INFO.PERIOD_ID#
								</cfquery>
								<cfset new_dsn2 = "#dsn#_#get_period_year.period_year#_#session.ep.company_id#">
								<cfquery name="upd_inv" datasource="#dsn2#">
									UPDATE #new_dsn2#.INVOICE SET BANK_ACTION_ID = #get_cari_rows.action_id#,BANK_PERIOD_ID = #session.ep.period_id# WHERE INVOICE_ID = #invoice_id#
								</cfquery>
								<cfoutput>#i# <cf_get_lang dictionary_id='64412.Otomatik Ödeme İşlemi Onaylandı'><br/></cfoutput>
							<cfelse>
								<cfoutput>#i# <cf_get_lang dictionary_id='64413.Otomatik Ödeme İşlemi Onaylanmadı'> (<cf_get_lang dictionary_id='64414.Tahsilat Kodu'> : #prov_code#)<br/></cfoutput>
							</cfif>
							<cfcatch type="any"> 
								<cfoutput>
									<script>
										alert("#i#. <cf_get_lang dictionary_id='64411.Satırda İşlem Kesilmiştir! Belgenizi Düzeltip Tekrar İmport Etmeniz Gerekmektedir'>");
										<cfif not isdefined("attributes.draggable")>window.close();<cfelse>closeBoxDraggable( '<cfoutput>#attributes.modal_id#</cfoutput>' );</cfif>
										</script><br/>
								</cfoutput>
								 <cfabort> 
							</cfcatch>
						</cftry>
					</cfloop>
				</cfif>
				
				<cfif ListFind('43',GET_IMPORT.SOURCE_SYSTEM)><!--- Vakıf Bank--->
					<cfloop from="1" to="#line_count-1#" index="i"><!--- trailer satırlarını almamak için --->
						<cftry>   
							<cfscript>
								satir = dosya[i];
								satir_id = oku(satir,1,2);//satir id
								nettotal_1 = oku(satir,42,12);//Tutar
								nettotal_2 = oku(satir,55,2);//Kurus
								prov_code = oku(satir,89,2);//Onay kodu
								prov_row_id = oku(satir,134,46);//prov satır idsi
								invoice_id = oku(satir,180,30);//invoice id
								nettotal = "#nettotal_1#.#nettotal_2#";
							</cfscript>
							<cfif prov_code eq '71' and satir_id eq '51'>
								<cfquery name="GET_PERIOD_INFO" datasource="#DSN2#">
									SELECT PERIOD_ID FROM #dsn3_alias#.SUBSCRIPTION_PAYMENT_PLAN_ROW WHERE SUBSCRIPTION_PAYMENT_ROW_ID = #prov_row_id#
								</cfquery>
								<cfquery name="GET_SUBSCRIPTION_DETAIL" datasource="#DSN2#">
									SELECT 
										INVOICE_COMPANY_ID COMPANY_ID,
										INVOICE_CONSUMER_ID CONSUMER_ID
									FROM 
										#dsn3_alias#.SUBSCRIPTION_PAYMENT_PLAN_ROW SPR,
										#dsn3_alias#.SUBSCRIPTION_CONTRACT SC
									WHERE 
										SPR.SUBSCRIPTION_ID = SC.SUBSCRIPTION_ID AND
										SPR.INVOICE_ID = #invoice_id# AND
										SPR.PERIOD_ID = #GET_PERIOD_INFO.PERIOD_ID#
								</cfquery>
								<cfif len(GET_SUBSCRIPTION_DETAIL.COMPANY_ID)>
									<cfset my_acc_result = get_company_period(GET_SUBSCRIPTION_DETAIL.COMPANY_ID)>
								<cfelse>
									<cfset my_acc_result = get_consumer_period(GET_SUBSCRIPTION_DETAIL.CONSUMER_ID)>
								</cfif>
								<cfset wrk_id = dateformat(now(),'YYYYMMDD')&timeformat(now(),'HHmmssL')&'_#session.ep.userid#_'&round(rand()*100)>
								<!--- gelen havale kaydı yapılır --->
								<cfinclude template="../../bank/query/add_gelenh_from_autopayment.cfm"> 
								<cfquery name="UPD_PAYMENT_ROWS" datasource="#DSN2#"><!--- onay aldıysa ödendi set edilir --->
									UPDATE
										#dsn3_alias#.SUBSCRIPTION_PAYMENT_PLAN_ROW
									SET
										IS_PAID = 1,
										<cfif isdefined("cari_act_id_inf") and len(cari_act_id_inf) and get_cari_rows.recordcount>
											CARI_ACTION_ID = #get_cari_rows.cari_action_id#,
											CARI_PERIOD_ID = #session.ep.period_id#,
											CARI_ACT_TYPE = #get_cari_rows.action_type_id#,
											CARI_ACT_ID = #get_cari_rows.action_id#,
											CARI_ACT_TABLE = '#get_cari_rows.action_table#',
										</cfif>
										UPDATE_DATE = #now()#,
										UPDATE_IP = '#cgi.remote_addr#',
										UPDATE_EMP = #session.ep.userid#
									WHERE
										INVOICE_ID = #invoice_id# AND
										PERIOD_ID = #GET_PERIOD_INFO.PERIOD_ID#
								</cfquery>
								<cfquery name="get_period_year" datasource="#dsn2#">
									SELECT PERIOD_YEAR FROM #dsn_alias#.SETUP_PERIOD WHERE PERIOD_ID = #GET_PERIOD_INFO.PERIOD_ID#
								</cfquery>
								<cfset new_dsn2 = "#dsn#_#get_period_year.period_year#_#session.ep.company_id#">
								<cfquery name="upd_inv" datasource="#dsn2#">
									UPDATE #new_dsn2#.INVOICE SET BANK_ACTION_ID = #get_cari_rows.action_id#,BANK_PERIOD_ID = #session.ep.period_id# WHERE INVOICE_ID = #invoice_id#
								</cfquery>
								<cfoutput>#i# <cf_get_lang dictionary_id='64412.Otomatik Ödeme İşlemi Onaylandı'><br/></cfoutput>
							<cfelse>
								<cfoutput>#i# <cf_get_lang dictionary_id='64413.Otomatik Ödeme İşlemi Onaylanmadı'> (<cf_get_lang dictionary_id='64414.Tahsilat Kodu'> : #prov_code#)<br/></cfoutput>
							</cfif>
							<cfcatch type="any"> 
								<cfoutput>
									<script>
										alert("#i#. <cf_get_lang dictionary_id='64411.Satırda İşlem Kesilmiştir! Belgenizi Düzeltip Tekrar İmport Etmeniz Gerekmektedir'>");
										<cfif not isdefined("attributes.draggable")>window.close();<cfelse>closeBoxDraggable( '<cfoutput>#attributes.modal_id#</cfoutput>' );</cfif>
										</script>
										<br/>
								</cfoutput>
								<cfabort> 
							</cfcatch>
						</cftry>   
					</cfloop>
				</cfif>
			</cfif>
			<!--- import işlemi set edilir --->
			<cfquery name="UPD_FILE_IMPORTS" datasource="#DSN2#">
				UPDATE FILE_IMPORTS SET IMPORTED = 1, STARTDATE = #form.process_date# WHERE I_ID = #attributes.i_id#
			</cfquery>
			<cfoutput><cf_get_lang dictionary_id='64410.Import Işlemi Tamamlandı'>...</cfoutput>
		</cftransaction>
	</cflock>
	
	<script type="text/javascript">
	
		history.back();
	</script>
	
<cfelse>
	<script language="JavaScript">
		alert("<cf_get_lang dictionary_id='64409.Bu Belge İçin Import Yapılmıştır'>");
			<cfif  isdefined("attributes.draggable")>location.href = document.referrer;<cfelse>opener.location.reload();
				window.close();</cfif>
	</script>
	<cfabort>
</cfif>
