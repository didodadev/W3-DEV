<cfset upload_folder = "#upload_folder#settings#dir_seperator#">
<cfif Not DirectoryExists("#upload_folder#")>
	<cfdirectory action="create" directory="#upload_folder#" />
</cfif>
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
			alert("<cf_get_lang_main no='43.Dosyaniz Upload Edilemedi Lütfen Konrol Ediniz '>!");
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
		alert("Dosya Okunamadı ! Karakter Seti Yanlış Seçilmiş Olabilir.");
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
<cfquery name="get_money" datasource="#dsn2#">
	SELECT MONEY,RATE1,RATE2 FROM SETUP_MONEY WHERE MONEY_STATUS=1
</cfquery>
<cflock name="#createuuid()#" timeout="500">
	<cftransaction>
		<cfloop from="2" to="#line_count#" index="i">
			<cfset j= 1>
			<cfset error_flag = 0>
			<cftry>
				<cfscript>
					satir_say=satir_say+1;
					member_code = Listgetat(dosya[i],j,";");//Üye kodu / özel kod / tc kimlik no / vergi no
					member_code = trim(member_code);
					j=j+1;
					
					stage_id = Listgetat(dosya[i],j,";");//Aşama
					stage_id = trim(stage_id);
					j=j+1;
					
					purchase_paymethod = Listgetat(dosya[i],j,";");//Alış ödeme yöntemi
					purchase_paymethod = trim(purchase_paymethod);
					j=j+1;
					
					sale_paymethod = Listgetat(dosya[i],j,";");//Satış ödeme yöntemi
					sale_paymethod = trim(sale_paymethod);
					j=j+1;
					
					shıp_method = Listgetat(dosya[i],j,";");//Sevk Yöntemi
					shıp_method = trim(shıp_method);
					j=j+1;
					
					shıp_member = Listgetat(dosya[i],j,";");//Taşıyıcı Firma
					shıp_member = trim(shıp_member);
					j=j+1;
					
					open_account_limit = Listgetat(dosya[i],j,";");//Açık Hesap Limit(İşlem dövizli)
					open_account_limit = trim(open_account_limit);
					open_account_limit=Replace(open_account_limit,',','.');
					j=j+1;
					
					due_account_limit = Listgetat(dosya[i],j,";");//Vadeli Ödeme Aracı Limit(İşlem dövizli)
					due_account_limit = trim(due_account_limit);
					due_account_limit= Replace(due_account_limit,',','.');
					j=j+1;
					
					money_type = Listgetat(dosya[i],j,";");//İşlem  para birimi
					money_type = trim(money_type);
					j=j+1;
					
					open_account_limit_system = Listgetat(dosya[i],j,";");//Açık Hesap Limit(Sistem dövizli)
					open_account_limit_system = trim(open_account_limit_system);
					open_account_limit_system= Replace(open_account_limit_system,',','.');
					j=j+1;
					
					due_account_limit_system = Listgetat(dosya[i],j,";");//Vadeli Ödeme Aracı Limit(İşlem dövizli)
					due_account_limit_system = trim(due_account_limit_system);
					due_account_limit_system= Replace(due_account_limit_system,',','.');
					j=j+1;
					
					first_payment_interest = Listgetat(dosya[i],j,";");//Erken Ödeme İndirimi
					first_payment_interest = trim(first_payment_interest);
					first_payment_interest= Replace(first_payment_interest,',','.');
					j=j+1;
					
				    last_payment_interest = Listgetat(dosya[i],j,";");//Geç Ödeme Faizi
					last_payment_interest = trim(last_payment_interest);
					last_payment_interest= Replace(last_payment_interest,',','.');
					j=j+1;
					
					payment_blokaj = Listgetat(dosya[i],j,";");//Ödeme Blokajı
					payment_blokaj = trim(payment_blokaj);
					payment_blokaj= Replace(payment_blokaj,',','.');
					j=j+1;
					
					price_cat_id = Listgetat(dosya[i],j,";");//Fiyat Listesi
					price_cat_id = trim(price_cat_id);
					j=j+1;
										
					if(listlen(dosya[i],';') gte j)
					{
						is_instalment = Listgetat(dosya[i],j,";");//Taksitli İşlem
						is_instalment = trim(is_instalment);
					}else
						is_instalment = 0;

					j=j+1;
					
					if(listlen(dosya[i],';') gte j)
					{
						rate_type = Listgetat(dosya[i],j,";");//Kur Tipi
						rate_type = trim(rate_type);
					}else
						rate_type = '';
				</cfscript>
				<cfcatch type="Any">
					<cfoutput>#i#</cfoutput>. satır 1. adımda sorun oluştu.<br/>
					<cfset error_flag = 1>
				</cfcatch>
			</cftry>
			<cfif error_flag neq 1>
				<cfif not len(member_code)or not len(open_account_limit) or not len(due_account_limit) or not len(money_type) or not len(stage_id) or (not len(purchase_paymethod) and not len(sale_paymethod))>
					<cfoutput>
						<script type="text/javascript">
							alert("#i#. <cf_get_lang no ='2513.satırdaki zorunlu alanlarda eksik değerler var Lütfen dosyanızı kontrol ediniz'> !");
							window.close();
						</script>
					</cfoutput>
					<cfabort>
				</cfif>
				<cfset get_comp_id.recordcount = 0>
				<cfset get_cons_id.recordcount = 0>
				<cfif attributes.import_format eq 1><!--- kurumsal üye numarası ile --->
					<cfquery name="get_comp_id" datasource="#dsn#">
						SELECT COMPANY_ID FROM COMPANY WHERE MEMBER_CODE = '#member_code#'
					</cfquery>
				<cfelseif attributes.import_format eq 2><!--- kurumsal özel kod ile --->
					<cfquery name="get_comp_id" datasource="#dsn#">
						SELECT COMPANY_ID FROM COMPANY WHERE OZEL_KOD = '#member_code#'
					</cfquery>
				<cfelseif attributes.import_format eq 3><!--- kurumsal vergi no ile --->
					<cfquery name="get_comp_id" datasource="#dsn#">
						SELECT COMPANY_ID FROM COMPANY WHERE TAXNO = '#member_code#'
					</cfquery>
				<cfelseif attributes.import_format eq 4><!--- bireysel üye no ile --->
					<cfquery name="get_cons_id" datasource="#dsn#">
						SELECT CONSUMER_ID FROM CONSUMER WHERE MEMBER_CODE = '#member_code#'
					</cfquery>
				<cfelseif attributes.import_format eq 5><!--- bireysel tc kimlik no ile --->
					<cfquery name="get_cons_id" datasource="#dsn#">
						SELECT CONSUMER_ID FROM CONSUMER WHERE TC_IDENTY_NO = '#member_code#'
					</cfquery>
				<cfelseif attributes.import_format eq 6><!--- bireysel özel kod ile --->
					<cfquery name="get_cons_id" datasource="#dsn#">
						SELECT CONSUMER_ID FROM CONSUMER WHERE OZEL_KOD = '#member_code#'
					</cfquery>
				</cfif>
				<cfif get_comp_id.recordcount neq 0 or get_cons_id.recordcount neq 0>
					<cfquery name="get_credit_limit" datasource="#dsn#">
						SELECT 
							COMPANY_CREDIT_ID 
						FROM 
							COMPANY_CREDIT
						WHERE 
							<cfif get_comp_id.recordcount gt 0>
								COMPANY_ID = #get_comp_id.company_id#
							<cfelseif get_cons_id.recordcount gt 0>
								CONSUMER_ID = #get_cons_id.consumer_id#
							</cfif>
							AND OUR_COMPANY_ID = #attributes.our_company#
					</cfquery>
					<cfif get_credit_limit.recordcount>
						<cfoutput>#i#</cfoutput>. satırdaki üyeye ait ilgili şirkette risk bilgisi tanımlanmış.<br/>
					<cfelse>
						<cfquery name="get_rate" dbtype="query">
							SELECT 
								RATE2,
								RATE1 
							FROM 
								get_money 
							WHERE 
								MONEY = '#money_type#'
						</cfquery>
						<cfif len(open_account_limit_system)>
							<cfset open_limit_system = open_account_limit_system>
						<cfelse>
							<cfset open_limit_system = wrk_round(open_account_limit * (get_rate.rate2/get_rate.rate1))>
						</cfif>
						<cfif len(due_account_limit_system)>
							<cfset due_limit_system = due_account_limit_system>
						<cfelse>
							<cfset due_limit_system = wrk_round(due_account_limit * (get_rate.rate2/get_rate.rate1))>
						</cfif>
						<cfif len(shıp_member)>
							<cfquery name="get_manager_partner" datasource="#dsn#">
								SELECT MANAGER_PARTNER_ID,COMPANY_ID FROM COMPANY WHERE COMPANY_ID = #shıp_member#
							</cfquery>
						<cfelse>
							<cfset get_manager_partner.recordcount = 0>
						</cfif>
						<cfset satir_no = satir_no + 1>
						<cfquery name="add_member_credit" datasource="#dsn#" result="MAX_ID">
							INSERT INTO
								COMPANY_CREDIT
								(
									PROCESS_STAGE,
									COMPANY_ID,
									CONSUMER_ID,								
									OPEN_ACCOUNT_RISK_LIMIT_OTHER,
									OPEN_ACCOUNT_RISK_LIMIT,
									FORWARD_SALE_LIMIT_OTHER,
									FORWARD_SALE_LIMIT,
									PAYMENT_BLOKAJ,
									LAST_PAYMENT_INTEREST,
									FIRST_PAYMENT_INTEREST,
									PAYMETHOD_ID,
									REVMETHOD_ID,
									MONEY,
									TOTAL_RISK_LIMIT_OTHER,
									TOTAL_RISK_LIMIT ,
									OUR_COMPANY_ID,
									SHIP_METHOD_ID,
									PRICE_CAT,
									IS_INSTALMENT_INFO,
									TRANSPORT_COMP_ID,
									TRANSPORT_DELIVER_ID,
									PAYMENT_RATE_TYPE,
									RECORD_DATE,
									RECORD_EMP,
									RECORD_IP 
								)
							VALUES
								(
									#stage_id#,
									<cfif get_comp_id.recordcount>
										#get_comp_id.company_id#,
										NULL,
									<cfelseif get_cons_id.recordcount gt 0>
										NULL,
										#get_cons_id.consumer_id#,
									</cfif>
									<cfif len(open_account_limit)>#open_account_limit#<cfelse>0</cfif>,
									#open_limit_system#,
									<cfif len(due_account_limit)>#due_account_limit#<cfelse>0</cfif>,
									#due_limit_system#,
									<cfif len(payment_blokaj)>#payment_blokaj#,<cfelse>NULL,</cfif>
									<cfif len(last_payment_interest)>#last_payment_interest#<cfelse>NULL</cfif>,
									<cfif len(first_payment_interest)>#first_payment_interest#<cfelse>NULL</cfif>,
									<cfif len(purchase_paymethod)>#purchase_paymethod#<cfelse>NULL</cfif>,
									<cfif len(sale_paymethod)>#sale_paymethod#<cfelse>NULL</cfif>,
									<cfif len(money_type)><cfqueryparam cfsqltype="cf_sql_varchar" value="#money_type#"><cfelse>NULL</cfif>,
									#wrk_round(open_account_limit+due_account_limit)#,
									#wrk_round(open_limit_system+due_limit_system)#,
									#attributes.our_company#,
									<cfif len(shıp_method)>#shıp_method#<cfelse>NULL</cfif>,
									<cfif len(price_cat_id)>#price_cat_id#<cfelse>NULL</cfif>,
									#is_instalment#,
									<cfif get_manager_partner.recordcount>#get_manager_partner.company_id#<cfelse>NULL</cfif>,
									<cfif get_manager_partner.recordcount>#get_manager_partner.manager_partner_id#<cfelse>NULL</cfif>,
									<cfif len(rate_type) and isNumeric(rate_type)>#rate_type#<cfelse>NULL</cfif>,
									#now()#,
									#session.ep.userid#,
									<cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.remote_addr#">
								)
						</cfquery>
						<cfif isdefined("price_cat_id") and len(price_cat_id) and get_comp_id.recordcount>
							<cfquery name="get_price_list" datasource="#dsn#">
								SELECT 
									* 
								FROM 
									#dsn#_#attributes.our_company#.PRICE_CAT_EXCEPTIONS 
								WHERE 
									PRICE_CATID = #price_cat_id#
									AND COMPANY_ID = #get_comp_id.company_id#
									AND ACT_TYPE = 2
							</cfquery>
							<cfif get_price_list.recordcount>
								<cfquery name="upd_price_list_for_company" datasource="#DSN#">
									UPDATE
										#dsn#_#attributes.our_company#.PRICE_CAT_EXCEPTIONS
									SET
										IS_DEFAULT = 0
									WHERE
										COMPANY_ID = #get_comp_id.company_id#
										AND ACT_TYPE = 2
								</cfquery>
								<cfquery name="upd_price_list_for_company" datasource="#DSN#">
									UPDATE
										#dsn#_#attributes.our_company#.PRICE_CAT_EXCEPTIONS
									SET
										IS_DEFAULT = 1
									WHERE
										PRICE_CATID = #price_cat_id#
										AND COMPANY_ID = #get_comp_id.company_id#
										AND ACT_TYPE = 2
								</cfquery>
							<cfelse>
								<cfquery name="upd_price_list_for_company" datasource="#DSN#">
									UPDATE
										#dsn#_#attributes.our_company#.PRICE_CAT_EXCEPTIONS
									SET
										IS_DEFAULT = 0
									WHERE
										COMPANY_ID = #get_comp_id.company_id#
										AND ACT_TYPE = 2
								</cfquery>
								<cfquery name="add_price_list_for_company" datasource="#DSN#">
									INSERT INTO
										#dsn#_#attributes.our_company#.PRICE_CAT_EXCEPTIONS
									(
										COMPANY_ID,
										PRICE_CATID,
										RECORD_EMP,
										RECORD_IP,
										RECORD_DATE,
										ACT_TYPE,
										IS_DEFAULT,
										PURCHASE_SALES
									)
									VALUES
									(
										#get_comp_id.company_id#,
										#price_cat_id#,
										#session.ep.userid#,
										<cfqueryparam cfsqltype="cf_sql_varchar" value="#remote_addr#">,
										#now()#,
										2,
										1,
										1
									)
								</cfquery>				
							</cfif>	
						</cfif>
						<cfoutput query="get_money">
							<cfquery name="add_credit_money" datasource="#dsn#">
								INSERT INTO COMPANY_CREDIT_MONEY 
								(
									ACTION_ID,
									MONEY_TYPE,
									RATE2,
									RATE1,
									IS_SELECTED
								)
								VALUES
								(
									#MAX_ID.IDENTITYCOL#,
									<cfqueryparam cfsqltype="cf_sql_varchar" value="#get_money.money#">,
									#get_money.rate2#,
									#get_money.rate1#,
									<cfif money_type is get_money.money>1<cfelse>0</cfif>
								)
							</cfquery>
						</cfoutput>
					</cfif>
				<cfelse>
					<cfoutput>#i#</cfoutput>. satırdaki üye bulunamadı.<br/>
				</cfif>
				<cftry>	
					<cfcatch type="Any">
						<cfoutput>#i#</cfoutput>. satır 2. adımda sorun oluştu.<br/>
					</cfcatch>
				</cftry>
			</cfif>
		</cfloop>
	</cftransaction>
</cflock>
<cfoutput><cf_get_lang no='2664.İmport edilen satır sayısı'>: #satir_no# !!!</cfoutput><br/>
<cfoutput><cf_get_lang no='2655.Toplam belge satır sayısı'>: #satir_say# !!!</cfoutput>

