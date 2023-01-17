<!---toplu provizyon belgesi import sayfasıdır
banka tiplerine göre dönüş belgelerindeki desenlere göre import işlemi yapılır ve kredi kartı tahsilat işlemleri yapılır,ve fatura id sine göre 
ilgili ödeme planı satırları ödendi yapılrı veya onaysızlarda provizyon oluşturuldusu kaldırılırki tekrar provizyona gönderilsin
her banka için farklı bloklar vardır,bloklar arasında ufakta olsa farklar var gözden kaçmamalı!

import ederken sorun oluşursa bakılacak ilk şey belgenin deseni düzgünmü,invoice_id ve provizyon satırı id si dogru yerdemi
ilgili sistemin detayındaki kredi kartı bilgisi seçilimi
ilgili fatura bilgileri yerindemi,üye ve kart bilgileri düzgünmü
try catch blokları açılıp hataya bakılabilir import ederken,provizyonun geri alması vardır...
Ayşenur--->
<cfset CRLF = Chr(13)&Chr(10)>
<cfsetting showdebugoutput="no">
<cf_date tarih='attributes.process_date'>
<cfquery name="GET_MONEY_INFO" datasource="#dsn2#">
	SELECT MONEY,RATE1,RATE2 FROM SETUP_MONEY
</cfquery>
<cfset currency_multiplier = "">
<cfoutput query="GET_MONEY_INFO">
	<cfif GET_MONEY_INFO.MONEY eq session.ep.money2>
		<cfset currency_multiplier = wrk_round(GET_MONEY_INFO.RATE2/GET_MONEY_INFO.RATE1,session.ep.our_company_info.rate_round_num)>
	</cfif>
</cfoutput>
<cfquery name="GET_IMPORT" datasource="#DSN2#">
	SELECT SOURCE_SYSTEM,FILE_NAME,FILE_CONTENT FROM FILE_IMPORTS WHERE PROCESS_TYPE = -7 AND I_ID = #attributes.i_id# AND IMPORTED = 0
</cfquery>
<cfif isdefined("cari_act_id_inf") and len(cari_act_id_inf)>
	<cfquery name="get_cari_rows" datasource="#dsn3#">
		SELECT CARI_ACTION_ID,ACTION_TYPE_ID,ACTION_ID,ACTION_TABLE FROM #dsn2_alias#.CARI_ROWS WHERE CARI_ACTION_ID = #cari_act_id_inf#
	</cfquery>
</cfif>
<cfset attributes.action_detail = ''>
<cfif isDefined("attributes.x_is_add_ins_number") and attributes.x_is_add_ins_number eq 1>
	<cfquery name="get_ins_num" datasource="#dsn3#">
		SELECT 
			PAYMENT_TYPE_ID, 
			ISNULL(NUMBER_OF_INSTALMENT,0) NUMBER_OF_INSTALMENT,
			P_TO_INSTALMENT_ACCOUNT,
			ACCOUNT_CODE,
			SERVICE_RATE,
			IS_PESIN
		FROM 
			CREDITCARD_PAYMENT_TYPE 
		WHERE 
			PAYMENT_TYPE_ID = #listgetat(attributes.action_to_account_id,3,';')#
	</cfquery>
	<cfif get_ins_num.number_of_instalment eq 0>
		<cfset attributes.action_detail = 'Tek Çekim'>
	<cfelse>
		<cfset attributes.action_detail = '#get_ins_num.number_of_instalment# Taksit'>
	</cfif>
</cfif>
<cfif GET_IMPORT.recordcount>
	<cfif not len(GET_IMPORT.FILE_CONTENT)>
		<script type="text/javascript">
			alert("<cf_get_lang dictionary_id='49050.Şifrenizi Kontrol Ediniz'>!");
				<cfif  isdefined("attributes.draggable")>location.href = document.referrer;<cfelse>	wrk_opener_reload();window.close();</cfif>
		</script>
		<cfabort>
	</cfif>
	<cfset file_content_result = Decrypt(GET_IMPORT.FILE_CONTENT,attributes.key_type,"CFMX_COMPAT","Hex")>
	<cfset kontrol_part = left(file_content_result,6)>
	<cfset dosya = ListToArray(file_content_result,CRLF)>
	<cfif not(IsNumeric(kontrol_part) or kontrol_part eq "HEADER" or left(kontrol_part,3) eq "H20" or left(kontrol_part,1) eq "O"  or left(kontrol_part,2) eq "HM")><!--- encrypt in doğru açılması kontrolu --->
		<script type="text/javascript">
			alert("<cf_get_lang dictionary_id='49050.Şifrenizi Kontrol Ediniz'>!");
				<cfif  isdefined("attributes.draggable")>location.href = document.referrer;<cfelse>	wrk_opener_reload();window.close();</cfif>
		</script>
		<cfabort>
	</cfif>
	<cfquery name="get_process_type" datasource="#dsn3#">
		SELECT PROCESS_TYPE,IS_CARI,IS_ACCOUNT FROM SETUP_PROCESS_CAT WHERE PROCESS_CAT_ID = #form.process_cat#
	</cfquery>
	<!--- Önce import işlemi set edilir --->
	<cfquery name="UPD_FILE_IMPORTS" datasource="#DSN2#">
		UPDATE FILE_IMPORTS SET IMPORTED = 1 WHERE I_ID = #attributes.i_id#
	</cfquery>
	<cfscript>
		process_type = get_process_type.process_type;
		is_cari = get_process_type.is_cari;
		is_account = get_process_type.is_account;
		action_to_account_id_first = listfirst(attributes.action_to_account_id,';');
		payment_type_id = listgetat(attributes.action_to_account_id,3,';');
		account_currency_id = listgetat(attributes.action_to_account_id,2,';');
		to_branch_id = listgetat(attributes.action_to_account_id,4,';');

		if (listfind("2,4,5,6,10",GET_IMPORT.SOURCE_SYSTEM,','))//TPOS - TEB - İşbank - YKB		
			ArrayDeleteAt(dosya,1);//header satırını silmek için
		else if(GET_IMPORT.SOURCE_SYSTEM eq 3){//HSBC
			for(i = 1; i lte 3; i=i+1)
				ArrayDeleteAt(dosya,1);}//header satırını silmek için
		line_count = ArrayLen(dosya);
		islem_tarihi = attributes.process_date;
	</cfscript>
	<cfif GET_IMPORT.SOURCE_SYSTEM eq 2><!--- HSBC --->
		<cfscript>//ilk satırdan dönem kontrolu
			satir = dosya[1];
			prov_row_id = oku(satir,Find(".",satir)+1,Find(" ",satir)-1);//prov satır idsi
		</cfscript>
		<cfquery name="GET_PERIOD_INFO" datasource="#dsn2#">
			SELECT PERIOD_ID FROM #dsn3_alias#.SUBSCRIPTION_PAYMENT_PLAN_ROW WHERE SUBSCRIPTION_PAYMENT_ROW_ID = #prov_row_id#
		</cfquery>
		<cfif (not (isDefined("attributes.prov_period") and len(attributes.prov_period)) and GET_PERIOD_INFO.PERIOD_ID neq session.ep.period_id) or (isDefined("attributes.prov_period") and len(attributes.prov_period) and GET_PERIOD_INFO.PERIOD_ID neq attributes.prov_period)>
			<script type="text/javascript">
				alert("<cf_get_lang dictionary_id='49068.Lütfen Döneminizi Kontrol Ediniz'>!");
				<cfif  isdefined("attributes.draggable")>location.href = document.referrer;<cfelse>	wrk_opener_reload();window.close();</cfif>
			</script>
			<cfabort>
		</cfif>
		<cfloop from="1" to="#line_count-1#" index="i"><!--- trailer satırını almamak için --->
			<cftry>
				<cflock name="#CreateUUID()#" timeout="20">
					<cftransaction>
						<cfscript>
							satir = dosya[i];
							invoice_id = oku(satir,1,Find(".",satir)-1);//invoice idsi
							nettotal = oku(satir,52,13) & "." & oku(satir,65,2);//Tutar
							resp_code = oku(satir,190,3);//AuthRespCode
							detail = oku(satir,193,40);//AuthRespAciklama
							card_no = oku(satir,101,19);//kart no
						</cfscript>
						<cfquery name="GET_SUBSCRIPTION_DETAIL" datasource="#dsn2#">
							SELECT 
								INVOICE_COMPANY_ID COMPANY_ID,
								INVOICE_CONSUMER_ID CONSUMER_ID,
								SC.SUBSCRIPTION_NO,
								SC.MEMBER_CC_ID
							FROM 
								#dsn3_alias#.SUBSCRIPTION_PAYMENT_PLAN_ROW SPR,
								#dsn3_alias#.SUBSCRIPTION_CONTRACT SC
							WHERE 
								SPR.SUBSCRIPTION_ID = SC.SUBSCRIPTION_ID AND
								SPR.INVOICE_ID = #invoice_id# AND
							<cfif isDefined("attributes.prov_period") and len(attributes.prov_period)>
								PERIOD_ID = #attributes.prov_period#
							<cfelse>
								PERIOD_ID = #session.ep.period_id#
							</cfif>
						</cfquery>
						<cfif resp_code eq "000">
							<cfif len(GET_SUBSCRIPTION_DETAIL.COMPANY_ID)>
								<cfset my_acc_result = get_company_period(GET_SUBSCRIPTION_DETAIL.COMPANY_ID)>
								<cfset key_type = GET_SUBSCRIPTION_DETAIL.COMPANY_ID>
							<cfelse>
                            	<cfset my_acc_result = get_consumer_period(GET_SUBSCRIPTION_DETAIL.CONSUMER_ID)>
								<cfset key_type = GET_SUBSCRIPTION_DETAIL.CONSUMER_ID>
							</cfif>
                            <!--- 
								FA-09102013
								kredi kartı Gelişmiş şifreleme standartları ile şifrelenmesi. 
								Bu sistemin çalışması için sistem/güvenlik altında kredi kartı şifreleme anahtarlırının tanımlanması gerekmektedir 
							--->
							<cfscript>
								getCCNOKey = createObject("component", "V16.settings.cfc.setupCcnoKey");
								getCCNOKey.dsn = dsn;
								getCCNOKey1 = getCCNOKey.getCCNOKey1();
								getCCNOKey2 = getCCNOKey.getCCNOKey2();
							</cfscript>
							<!--- key 1 ve key 2 DB ye kaydedilmiş ise buna göre encryptleme sistemi çalışıyor --->
							<cfif getCCNOKey1.recordcount and getCCNOKey2.recordcount>
								<!--- anahtarlar decode ediliyor --->
								<cfset ccno_key1 = contentEncryptingandDecodingAES(isEncode:0,accountKey:getCCNOKey1.record_emp,content:getCCNOKey1.ccnokey) />
								<cfset ccno_key2 = contentEncryptingandDecodingAES(isEncode:0,accountKey:getCCNOKey2.record_emp,content:getCCNOKey2.ccnokey) />
								<!--- kart no encode ediliyor --->
								<cfset content = contentEncryptingandDecodingAES(isEncode:1,content:card_no,accountKey:key_type,key1:ccno_key1,key2:ccno_key2) />
							<cfelse>
								<cfset content = Encrypt(card_no,key_type,"CFMX_COMPAT","Hex")>
							</cfif>
                            
							<cfset wrk_id = dateformat(now(),'YYYYMMDD')&timeformat(now(),'HHmmssL')&'_#session.ep.userid#_'&round(rand()*100)>
							<!--- kredi kartı tahsilat kaydı yapılır --->
							<cfinclude template="../query/add_cc_revenue_from_multiprov.cfm">
							<cfquery name="UPD_PAYMENT_ROWS" datasource="#dsn2#"><!--- onay aldıysa ödendi set edilir --->
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
								<cfif isDefined("attributes.prov_period") and len(attributes.prov_period)>
									PERIOD_ID = #attributes.prov_period#
								<cfelse>
									PERIOD_ID = #session.ep.period_id#
								</cfif>
							</cfquery>
							<cfif len(GET_SUBSCRIPTION_DETAIL.COMPANY_ID)><!--- Dönüş kodlarının kredi kartının detayına yazılması --->
								<cfquery name="UPD_COMPANY_CC" datasource="#dsn2#">
									UPDATE
										#dsn_alias#.COMPANY_CC
									SET
										RESP_CODE = NULL,
										UPDATE_DATE = #now()#,
										UPDATE_IP = '#cgi.remote_addr#',
										UPDATE_EMP = #session.ep.userid#
									WHERE
										COMPANY_CC_ID = #GET_SUBSCRIPTION_DETAIL.MEMBER_CC_ID#
								</cfquery>
							<cfelse>
								<cfquery name="UPD_CONSUMER_CC" datasource="#dsn2#">
									UPDATE
										#dsn_alias#.CONSUMER_CC
									SET
										RESP_CODE = NULL,
										UPDATE_DATE = #now()#,
										UPDATE_IP = '#cgi.remote_addr#',
										UPDATE_EMP = #session.ep.userid#
									WHERE
										CONSUMER_CC_ID = #GET_SUBSCRIPTION_DETAIL.MEMBER_CC_ID#
								</cfquery>
							</cfif>
							<cfoutput>#i# Provizyon İşlemi Onaylandı<br/></cfoutput>
						<cfelse>
							<cfquery name="UPD_PAYMENT_ROWS" datasource="#dsn2#"><!--- onay almadıysa prov oluşmadı set edilir --->
								UPDATE
									#dsn3_alias#.SUBSCRIPTION_PAYMENT_PLAN_ROW
								SET
									IS_COLLECTED_PROVISION = 0,
									UPDATE_DATE = #now()#,
									UPDATE_IP = '#cgi.remote_addr#',
									UPDATE_EMP = #session.ep.userid#
								WHERE
									INVOICE_ID = #invoice_id# AND
								<cfif isDefined("attributes.prov_period") and len(attributes.prov_period)>
									PERIOD_ID = #attributes.prov_period#
								<cfelse>
									PERIOD_ID = #session.ep.period_id#
								</cfif>
							</cfquery>
							<cfif len(GET_SUBSCRIPTION_DETAIL.COMPANY_ID)><!--- Dönüş kodlarının kredi kartının detayına yazılması --->
								<cfquery name="UPD_COMPANY_CC" datasource="#dsn2#">
									UPDATE
										#dsn_alias#.COMPANY_CC
									SET
										RESP_CODE = '#resp_code#',
										UPDATE_DATE = #now()#,
										UPDATE_IP = '#cgi.remote_addr#',
										UPDATE_EMP = #session.ep.userid#
									WHERE
										COMPANY_CC_ID = #GET_SUBSCRIPTION_DETAIL.MEMBER_CC_ID#
								</cfquery>
							<cfelse>
								<cfquery name="UPD_CONSUMER_CC" datasource="#dsn2#">
									UPDATE
										#dsn_alias#.CONSUMER_CC
									SET
										RESP_CODE = '#resp_code#',
										UPDATE_DATE = #now()#,
										UPDATE_IP = '#cgi.remote_addr#',
										UPDATE_EMP = #session.ep.userid#
									WHERE
										CONSUMER_CC_ID = #GET_SUBSCRIPTION_DETAIL.MEMBER_CC_ID#
								</cfquery>
							</cfif>
							<cfoutput>#i# Provizyon İşlemi Onaylanmadı:	Dönüş Kodu:	#resp_code#-#detail#	Sistem No:	#GET_SUBSCRIPTION_DETAIL.SUBSCRIPTION_NO#<br/></cfoutput>
						</cfif>
					</cftransaction>
				</cflock>
				<cfcatch>
					<cfoutput>
						#i#.<cf_get_lang dictionary_id='64411.Satırda İşlem Kesilmiştir! Belgenizi Düzeltip Tekrar İmport Etmeniz Gerekmektedir'>.<br/>
					</cfoutput>
					<cfabort>
				</cfcatch> 
			</cftry>
		</cfloop>
	</cfif>

	<cfif GET_IMPORT.SOURCE_SYSTEM eq 1><!--- GARANTI text format--->
		<cfscript>// ilk satırdan dönem kontrolu
			satir = dosya[1];
			prov_row_id = oku(satir,451,30);//prov satır idsi
		</cfscript>
		<cfquery name="GET_PERIOD_INFO" datasource="#dsn2#">
			SELECT PERIOD_ID FROM #dsn3_alias#.SUBSCRIPTION_PAYMENT_PLAN_ROW WHERE SUBSCRIPTION_PAYMENT_ROW_ID = #prov_row_id#
		</cfquery>
		<cfif (not (isDefined("attributes.prov_period") and len(attributes.prov_period)) and GET_PERIOD_INFO.PERIOD_ID neq session.ep.period_id) or (isDefined("attributes.prov_period") and len(attributes.prov_period) and GET_PERIOD_INFO.PERIOD_ID neq attributes.prov_period)>
			<script type="text/javascript">
				alert("<cf_get_lang dictionary_id='49068.Lütfen Döneminizi Kontrol Ediniz'>!");
					<cfif  isdefined("attributes.draggable")>location.href = document.referrer;<cfelse>	wrk_opener_reload();window.close();</cfif>
			</script>
			<cfabort>
		</cfif>
		<cfloop from="1" to="#line_count#" index="i">
			<cftry>
				<cflock name="#CreateUUID()#" timeout="20">
					<cftransaction>
						<cfscript>
							satir = dosya[i];
							invoice_id = oku(satir,481,30);
							nettotal = oku(satir,75,11) & "." & oku(satir,86,2);//Tutar
							resp_code = oku(satir,132,6);//AuthRespCode
							card_no = oku(satir,23,19);//kart no
						</cfscript>
						<cfquery name="GET_SUBSCRIPTION_DETAIL" datasource="#dsn2#">
							SELECT 
								INVOICE_COMPANY_ID COMPANY_ID,
								INVOICE_CONSUMER_ID CONSUMER_ID,
								SC.SUBSCRIPTION_NO,
								SC.MEMBER_CC_ID
							FROM 
								#dsn3_alias#.SUBSCRIPTION_PAYMENT_PLAN_ROW SPR,
								#dsn3_alias#.SUBSCRIPTION_CONTRACT SC
							WHERE 
								SPR.SUBSCRIPTION_ID = SC.SUBSCRIPTION_ID AND
								SPR.INVOICE_ID = #invoice_id# AND
							<cfif isDefined("attributes.prov_period") and len(attributes.prov_period)>
								PERIOD_ID = #attributes.prov_period#
							<cfelse>
								PERIOD_ID = #session.ep.period_id#
							</cfif>
						</cfquery>
						<cfif isnumeric(resp_code)>
							<cfif len(GET_SUBSCRIPTION_DETAIL.COMPANY_ID)>
								<cfset my_acc_result = get_company_period(GET_SUBSCRIPTION_DETAIL.COMPANY_ID)>
								<cfset content = Encrypt(card_no,GET_SUBSCRIPTION_DETAIL.COMPANY_ID,"CFMX_COMPAT","Hex")>
							<cfelse>
								<cfset my_acc_result = get_consumer_period(GET_SUBSCRIPTION_DETAIL.CONSUMER_ID)>
								<cfset content = Encrypt(card_no,GET_SUBSCRIPTION_DETAIL.CONSUMER_ID,"CFMX_COMPAT","Hex")>
							</cfif>
							<cfset wrk_id = dateformat(now(),'YYYYMMDD')&timeformat(now(),'HHmmssL')&'_#session.ep.userid#_'&round(rand()*100)>
							<!--- kredi kartı tahsilat kaydı yapılır --->
							<cfinclude template="../query/add_cc_revenue_from_multiprov.cfm">
							<cfquery name="UPD_PAYMENT_ROWS" datasource="#dsn2#">
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
								<cfif isDefined("attributes.prov_period") and len(attributes.prov_period)>
									PERIOD_ID = #attributes.prov_period#
								<cfelse>
									PERIOD_ID = #session.ep.period_id#
								</cfif>
							</cfquery>
							<cfif len(GET_SUBSCRIPTION_DETAIL.COMPANY_ID)><!--- Dönüş kodlarının kredi kartının detayına yazılması --->
								<cfquery name="UPD_COMPANY_CC" datasource="#dsn2#">
									UPDATE
										#dsn_alias#.COMPANY_CC
									SET
										RESP_CODE = NULL,
										UPDATE_DATE = #now()#,
										UPDATE_IP = '#cgi.remote_addr#',
										UPDATE_EMP = #session.ep.userid#
									WHERE
										COMPANY_CC_ID = #GET_SUBSCRIPTION_DETAIL.MEMBER_CC_ID#
								</cfquery>
							<cfelse>
								<cfquery name="UPD_CONSUMER_CC" datasource="#dsn2#">
									UPDATE
										#dsn_alias#.CONSUMER_CC
									SET
										RESP_CODE = NULL,
										UPDATE_DATE = #now()#,
										UPDATE_IP = '#cgi.remote_addr#',
										UPDATE_EMP = #session.ep.userid#
									WHERE
										CONSUMER_CC_ID = #GET_SUBSCRIPTION_DETAIL.MEMBER_CC_ID#
								</cfquery>
							</cfif>
							<cfoutput>#i# Provizyon İşlemi Onaylandı<br/></cfoutput>
						<cfelse>
							<cfquery name="UPD_PAYMENT_ROWS" datasource="#dsn2#">
								UPDATE
									#dsn3_alias#.SUBSCRIPTION_PAYMENT_PLAN_ROW
								SET
									IS_COLLECTED_PROVISION = 0,
									UPDATE_DATE = #now()#,
									UPDATE_IP = '#cgi.remote_addr#',
									UPDATE_EMP = #session.ep.userid#
								WHERE
									INVOICE_ID = #invoice_id# AND
								<cfif isDefined("attributes.prov_period") and len(attributes.prov_period)>
									PERIOD_ID = #attributes.prov_period#
								<cfelse>
									PERIOD_ID = #session.ep.period_id#
								</cfif>
							</cfquery>
							<cfif len(GET_SUBSCRIPTION_DETAIL.COMPANY_ID)><!--- Dönüş kodlarının kredi kartının detayına yazılması --->
								<cfquery name="UPD_COMPANY_CC" datasource="#dsn2#">
									UPDATE
										#dsn_alias#.COMPANY_CC
									SET
										RESP_CODE = '#resp_code#',
										UPDATE_DATE = #now()#,
										UPDATE_IP = '#cgi.remote_addr#',
										UPDATE_EMP = #session.ep.userid#
									WHERE
										COMPANY_CC_ID = #GET_SUBSCRIPTION_DETAIL.MEMBER_CC_ID#
								</cfquery>
							<cfelse>
								<cfquery name="UPD_CONSUMER_CC" datasource="#dsn2#">
									UPDATE
										#dsn_alias#.CONSUMER_CC
									SET
										RESP_CODE = '#resp_code#',
										UPDATE_DATE = #now()#,
										UPDATE_IP = '#cgi.remote_addr#',
										UPDATE_EMP = #session.ep.userid#
									WHERE
										CONSUMER_CC_ID = #GET_SUBSCRIPTION_DETAIL.MEMBER_CC_ID#
								</cfquery>
							</cfif>
							<cfoutput>#i# Provizyon İşlemi Onaylanmadı:	Dönüş Kodu:	#resp_code# Sistem No:	#GET_SUBSCRIPTION_DETAIL.SUBSCRIPTION_NO#<br/></cfoutput>
						</cfif>
					</cftransaction>
				</cflock>
				<cfcatch>
					<cfoutput>
						#i#.<cf_get_lang dictionary_id='64411.Satırda İşlem Kesilmiştir! Belgenizi Düzeltip Tekrar İmport Etmeniz Gerekmektedir'>.<br/>
					</cfoutput>
					<cfabort>
				</cfcatch> 
			</cftry>
		</cfloop>
	</cfif>

	<cfif GET_IMPORT.SOURCE_SYSTEM eq 3><!--- GARANTI TPOS format--->
		<cfscript>// ilk satırdan dönem kontrolu
			satir = dosya[1];
			prov_row_id = oku(satir,90,10);//prov satır idsi
		</cfscript>
		<cfquery name="GET_PERIOD_INFO" datasource="#dsn2#">
			SELECT PERIOD_ID FROM #dsn3_alias#.SUBSCRIPTION_PAYMENT_PLAN_ROW WHERE SUBSCRIPTION_PAYMENT_ROW_ID = #prov_row_id#
		</cfquery>
		<cfif (not (isDefined("attributes.prov_period") and len(attributes.prov_period)) and GET_PERIOD_INFO.PERIOD_ID neq session.ep.period_id) or (isDefined("attributes.prov_period") and len(attributes.prov_period) and GET_PERIOD_INFO.PERIOD_ID neq attributes.prov_period)>
			<script type="text/javascript">
				alert("<cf_get_lang dictionary_id='49068.Lütfen Döneminizi Kontrol Ediniz'>!");
				<cf_get_lang dictionary_id='49068.Lütfen Döneminizi Kontrol Ediniz'>
			</script>
			<cfabort>
		</cfif>
		<cfloop from="1" to="#line_count-2#" index="i"><!---trailer ları almamak için--->
			<cftry>
				<cflock name="#CreateUUID()#" timeout="20">
					<cftransaction>
						<cfscript>
							satir = dosya[i];
							card_no = oku(satir,16,19);//kart no
							nettotal = oku(satir,40,11) & "." & oku(satir,51,2);//Tutar
							resp_code = oku(satir,55,6);//Provizyon Numarası
							invoice_id = oku(satir,100,10);//invoice_id
						</cfscript>
						<cfquery name="GET_SUBSCRIPTION_DETAIL" datasource="#dsn2#">
							SELECT 
								INVOICE_COMPANY_ID COMPANY_ID,
								INVOICE_CONSUMER_ID CONSUMER_ID,
								SC.SUBSCRIPTION_NO,
								SC.MEMBER_CC_ID
							FROM 
								#dsn3_alias#.SUBSCRIPTION_PAYMENT_PLAN_ROW SPR,
								#dsn3_alias#.SUBSCRIPTION_CONTRACT SC
							WHERE 
								SPR.SUBSCRIPTION_ID = SC.SUBSCRIPTION_ID AND
								SPR.INVOICE_ID = #invoice_id# AND
							<cfif isDefined("attributes.prov_period") and len(attributes.prov_period)>
								PERIOD_ID = #attributes.prov_period#
							<cfelse>
								PERIOD_ID = #session.ep.period_id#
							</cfif>
						</cfquery>
						<cfif left(resp_code,3) neq "RED" and len(resp_code)>
							<cfif len(GET_SUBSCRIPTION_DETAIL.COMPANY_ID)>
								<cfset my_acc_result = get_company_period(GET_SUBSCRIPTION_DETAIL.COMPANY_ID)>
								<cfset content = Encrypt(card_no,GET_SUBSCRIPTION_DETAIL.COMPANY_ID,"CFMX_COMPAT","Hex")>
							<cfelse>
								<cfset my_acc_result = get_consumer_period(GET_SUBSCRIPTION_DETAIL.CONSUMER_ID)>
								<cfset content = Encrypt(card_no,GET_SUBSCRIPTION_DETAIL.CONSUMER_ID,"CFMX_COMPAT","Hex")>
							</cfif>
							<cfset wrk_id = dateformat(now(),'YYYYMMDD')&timeformat(now(),'HHmmssL')&'_#session.ep.userid#_'&round(rand()*100)>
							<!--- kredi kartı tahsilat kaydı yapılır --->
							<cfinclude template="../query/add_cc_revenue_from_multiprov.cfm">
							<cfquery name="UPD_PAYMENT_ROWS" datasource="#dsn2#">
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
								<cfif isDefined("attributes.prov_period") and len(attributes.prov_period)>
									PERIOD_ID = #attributes.prov_period#
								<cfelse>
									PERIOD_ID = #session.ep.period_id#
								</cfif>
							</cfquery>
							<cfif len(GET_SUBSCRIPTION_DETAIL.COMPANY_ID)><!--- Dönüş kodlarının kredi kartının detayına yazılması --->
								<cfquery name="UPD_COMPANY_CC" datasource="#dsn2#">
									UPDATE
										#dsn_alias#.COMPANY_CC
									SET
										RESP_CODE = NULL,
										UPDATE_DATE = #now()#,
										UPDATE_IP = '#cgi.remote_addr#',
										UPDATE_EMP = #session.ep.userid#
									WHERE
										COMPANY_CC_ID = #GET_SUBSCRIPTION_DETAIL.MEMBER_CC_ID#
								</cfquery>
							<cfelse>
								<cfquery name="UPD_CONSUMER_CC" datasource="#dsn2#">
									UPDATE
										#dsn_alias#.CONSUMER_CC
									SET
										RESP_CODE = NULL,
										UPDATE_DATE = #now()#,
										UPDATE_IP = '#cgi.remote_addr#',
										UPDATE_EMP = #session.ep.userid#
									WHERE
										CONSUMER_CC_ID = #GET_SUBSCRIPTION_DETAIL.MEMBER_CC_ID#
								</cfquery>
							</cfif>
							<cfoutput>#i# Provizyon İşlemi Onaylandı<br/></cfoutput>
						<cfelse>
							<cfquery name="UPD_PAYMENT_ROWS" datasource="#dsn2#">
								UPDATE
									#dsn3_alias#.SUBSCRIPTION_PAYMENT_PLAN_ROW
								SET
									IS_COLLECTED_PROVISION = 0,
									UPDATE_DATE = #now()#,
									UPDATE_IP = '#cgi.remote_addr#',
									UPDATE_EMP = #session.ep.userid#
								WHERE
									INVOICE_ID = #invoice_id# AND
								<cfif isDefined("attributes.prov_period") and len(attributes.prov_period)>
									PERIOD_ID = #attributes.prov_period#
								<cfelse>
									PERIOD_ID = #session.ep.period_id#
								</cfif>
							</cfquery>
							<cfif len(GET_SUBSCRIPTION_DETAIL.COMPANY_ID)><!--- Dönüş kodlarının kredi kartının detayına yazılması --->
								<cfquery name="UPD_COMPANY_CC" datasource="#dsn2#">
									UPDATE
										#dsn_alias#.COMPANY_CC
									SET
										RESP_CODE = '#resp_code#',
										UPDATE_DATE = #now()#,
										UPDATE_IP = '#cgi.remote_addr#',
										UPDATE_EMP = #session.ep.userid#
									WHERE
										COMPANY_CC_ID = #GET_SUBSCRIPTION_DETAIL.MEMBER_CC_ID#
								</cfquery>
							<cfelse>
								<cfquery name="UPD_CONSUMER_CC" datasource="#dsn2#">
									UPDATE
										#dsn_alias#.CONSUMER_CC
									SET
										RESP_CODE = '#resp_code#',
										UPDATE_DATE = #now()#,
										UPDATE_IP = '#cgi.remote_addr#',
										UPDATE_EMP = #session.ep.userid#
									WHERE
										CONSUMER_CC_ID = #GET_SUBSCRIPTION_DETAIL.MEMBER_CC_ID#
								</cfquery>
							</cfif>
							<cfoutput>#i# Provizyon İşlemi Onaylanmadı:	Dönüş Kodu:	#resp_code#	Sistem No:	#GET_SUBSCRIPTION_DETAIL.SUBSCRIPTION_NO#<br/></cfoutput>
						</cfif>
					</cftransaction>
				</cflock>
				<cfcatch>
					<cfoutput>
						#i#.<cf_get_lang dictionary_id='64411.Satırda İşlem Kesilmiştir! Belgenizi Düzeltip Tekrar İmport Etmeniz Gerekmektedir'>.<br/>
					</cfoutput>
					<cfabort>
				</cfcatch> 
			</cftry>
		</cfloop>
	</cfif>

	<cfif GET_IMPORT.SOURCE_SYSTEM eq 4><!--- TEB format--->
		<cfscript>// ilk satırdan dönem kontrolu 
			satir = dosya[1];
			prov_row_id = oku(satir,42,20);//prov satır idsi
		</cfscript>
		<cfquery name="GET_PERIOD_INFO" datasource="#dsn2#">
			SELECT PERIOD_ID FROM #dsn3_alias#.SUBSCRIPTION_PAYMENT_PLAN_ROW WHERE SUBSCRIPTION_PAYMENT_ROW_ID = #prov_row_id#
		</cfquery>
		<cfif (not (isDefined("attributes.prov_period") and len(attributes.prov_period)) and GET_PERIOD_INFO.PERIOD_ID neq session.ep.period_id) or (isDefined("attributes.prov_period") and len(attributes.prov_period) and GET_PERIOD_INFO.PERIOD_ID neq attributes.prov_period)>
			<script type="text/javascript">
				alert("<cf_get_lang dictionary_id='49068.Lütfen Döneminizi Kontrol Ediniz'>!");
				<cfif  isdefined("attributes.draggable")>location.href = document.referrer;<cfelse>	wrk_opener_reload();window.close();</cfif>
			</script>
			<cfabort>
		</cfif>
		<cfloop from="1" to="#line_count-1#" index="i"><!---trailer ları almamak için--->
			<cftry>
				<cflock name="#CreateUUID()#" timeout="20">
					<cftransaction>
						<cfscript>
							satir = dosya[i];
							card_no = oku(satir,4,19);//kart no
							nettotal = oku(satir,30,12);//Tutar
							resp_code = oku(satir,317,1);//onay kodu
							resp_detail = oku(satir,318,6);//prov kodu
							invoice_id = oku(satir,62,255);//invoice_id
						</cfscript>
						<cfquery name="GET_SUBSCRIPTION_DETAIL" datasource="#dsn2#">
							SELECT 
								INVOICE_COMPANY_ID COMPANY_ID,
								INVOICE_CONSUMER_ID CONSUMER_ID,
								SC.SUBSCRIPTION_NO,
								SC.MEMBER_CC_ID
							FROM 
								#dsn3_alias#.SUBSCRIPTION_PAYMENT_PLAN_ROW SPR,
								#dsn3_alias#.SUBSCRIPTION_CONTRACT SC
							WHERE
								SPR.SUBSCRIPTION_ID = SC.SUBSCRIPTION_ID AND
								SPR.INVOICE_ID = #invoice_id# AND
							<cfif isDefined("attributes.prov_period") and len(attributes.prov_period)>
								PERIOD_ID = #attributes.prov_period#
							<cfelse>
								PERIOD_ID = #session.ep.period_id#
							</cfif>
						</cfquery>
						<cfif resp_code eq "O">
							<cfif len(GET_SUBSCRIPTION_DETAIL.COMPANY_ID)>
								<cfset my_acc_result = get_company_period(GET_SUBSCRIPTION_DETAIL.COMPANY_ID)>
								<cfset content = Encrypt(card_no,GET_SUBSCRIPTION_DETAIL.COMPANY_ID,"CFMX_COMPAT","Hex")>
							<cfelse>
								<cfset my_acc_result = get_consumer_period(GET_SUBSCRIPTION_DETAIL.CONSUMER_ID)>
								<cfset content = Encrypt(card_no,GET_SUBSCRIPTION_DETAIL.CONSUMER_ID,"CFMX_COMPAT","Hex")>
							</cfif>
							<cfset wrk_id = dateformat(now(),'YYYYMMDD')&timeformat(now(),'HHmmssL')&'_#session.ep.userid#_'&round(rand()*100)>
							<!--- kredi kartı tahsilat kaydı yapılır --->
							<cfinclude template="../query/add_cc_revenue_from_multiprov.cfm">
							<cfquery name="UPD_PAYMENT_ROWS" datasource="#dsn2#">
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
								<cfif isDefined("attributes.prov_period") and len(attributes.prov_period)>
									PERIOD_ID = #attributes.prov_period#
								<cfelse>
									PERIOD_ID = #session.ep.period_id#
								</cfif>
							</cfquery>
							<cfif len(GET_SUBSCRIPTION_DETAIL.COMPANY_ID)><!--- Dönüş kodlarının kredi kartının detayına yazılması --->
								<cfquery name="UPD_COMPANY_CC" datasource="#dsn2#">
									UPDATE
										#dsn_alias#.COMPANY_CC
									SET
										RESP_CODE = NULL,
										UPDATE_DATE = #now()#,
										UPDATE_IP = '#cgi.remote_addr#',
										UPDATE_EMP = #session.ep.userid#
									WHERE
										COMPANY_CC_ID = #GET_SUBSCRIPTION_DETAIL.MEMBER_CC_ID#
								</cfquery>
							<cfelse>
								<cfquery name="UPD_CONSUMER_CC" datasource="#dsn2#">
									UPDATE
										#dsn_alias#.CONSUMER_CC
									SET
										RESP_CODE = NULL,
										UPDATE_DATE = #now()#,
										UPDATE_IP = '#cgi.remote_addr#',
										UPDATE_EMP = #session.ep.userid#
									WHERE
										CONSUMER_CC_ID = #GET_SUBSCRIPTION_DETAIL.MEMBER_CC_ID#
								</cfquery>
							</cfif>
							<cfoutput>#i# Provizyon İşlemi Onaylandı<br/></cfoutput>
						<cfelse>
							<cfquery name="UPD_PAYMENT_ROWS" datasource="#dsn2#">
								UPDATE
									#dsn3_alias#.SUBSCRIPTION_PAYMENT_PLAN_ROW
								SET
									IS_COLLECTED_PROVISION = 0,
									UPDATE_DATE = #now()#,
									UPDATE_IP = '#cgi.remote_addr#',
									UPDATE_EMP = #session.ep.userid#
								WHERE
									INVOICE_ID = #invoice_id# AND
								<cfif isDefined("attributes.prov_period") and len(attributes.prov_period)>
									PERIOD_ID = #attributes.prov_period#
								<cfelse>
									PERIOD_ID = #session.ep.period_id#
								</cfif>
							</cfquery>
							<cfif len(GET_SUBSCRIPTION_DETAIL.COMPANY_ID)><!--- Dönüş kodlarının kredi kartının detayına yazılması --->
								<cfquery name="UPD_COMPANY_CC" datasource="#dsn2#">
									UPDATE
										#dsn_alias#.COMPANY_CC
									SET
										RESP_CODE = '#resp_detail#',
										UPDATE_DATE = #now()#,
										UPDATE_IP = '#cgi.remote_addr#',
										UPDATE_EMP = #session.ep.userid#
									WHERE
										COMPANY_CC_ID = #GET_SUBSCRIPTION_DETAIL.MEMBER_CC_ID#
								</cfquery>
							<cfelse>
								<cfquery name="UPD_CONSUMER_CC" datasource="#dsn2#">
									UPDATE
										#dsn_alias#.CONSUMER_CC
									SET
										RESP_CODE = '#resp_detail#',
										UPDATE_DATE = #now()#,
										UPDATE_IP = '#cgi.remote_addr#',
										UPDATE_EMP = #session.ep.userid#
									WHERE
										CONSUMER_CC_ID = #GET_SUBSCRIPTION_DETAIL.MEMBER_CC_ID#
								</cfquery>
							</cfif>
							<cfoutput>#i# Provizyon İşlemi Onaylanmadı:	Dönüş Kodu:	#resp_detail#	Sistem No:	#GET_SUBSCRIPTION_DETAIL.SUBSCRIPTION_NO#<br/></cfoutput>
						</cfif>
					</cftransaction>
				</cflock>
				<cfcatch>
					<cfoutput>
						#i#.<cf_get_lang dictionary_id='64411.Satırda İşlem Kesilmiştir! Belgenizi Düzeltip Tekrar İmport Etmeniz Gerekmektedir'>.<br/>
					</cfoutput>
					<cfabort>
				</cfcatch> 
			</cftry>
		</cfloop>
	</cfif>
	
	<cfif GET_IMPORT.SOURCE_SYSTEM eq 5><!--- İşBankası format--->
		<cfscript>// ilk satırdan dönem kontrolu 
			satir = dosya[1];
			prov_row_id = ListGetAt(oku(satir,133,30),2,'.');//prov satır idsi
		</cfscript>
		<cfquery name="GET_PERIOD_INFO" datasource="#dsn2#">
			SELECT PERIOD_ID FROM #dsn3_alias#.SUBSCRIPTION_PAYMENT_PLAN_ROW WHERE SUBSCRIPTION_PAYMENT_ROW_ID = #prov_row_id#
		</cfquery>
		<cfif (not (isDefined("attributes.prov_period") and len(attributes.prov_period)) and GET_PERIOD_INFO.PERIOD_ID neq session.ep.period_id) or (isDefined("attributes.prov_period") and len(attributes.prov_period) and GET_PERIOD_INFO.PERIOD_ID neq attributes.prov_period)>
			<script type="text/javascript">
				alert("<cf_get_lang dictionary_id='49068.Lütfen Döneminizi Kontrol Ediniz'>!");
				<cfif  isdefined("attributes.draggable")>location.href = document.referrer;<cfelse>	wrk_opener_reload();window.close();</cfif>
			</script>
			<cfabort>
		</cfif>
		<cfloop from="1" to="#line_count-2#" index="i"><!---trailer ları almamak için--->
			<cftry>
				<cflock name="#CreateUUID()#" timeout="20">
					<cftransaction>
						<cfscript>
							satir = dosya[i];
							card_no = oku(satir,8,16);//kart no
							nettotal = oku(satir,24,13) & "." & oku(satir,37,2);//Tutar
							resp_code = oku(satir,92,6);//onay kodu
							resp_detail = oku(satir,98,6);//prov kodu
							invoice_id = ListGetAt(oku(satir,133,30),1,'.');//invoice_id
						</cfscript>
						<cfquery name="GET_SUBSCRIPTION_DETAIL" datasource="#dsn2#">
							SELECT 
								INVOICE_COMPANY_ID COMPANY_ID,
								INVOICE_CONSUMER_ID CONSUMER_ID,
								SC.SUBSCRIPTION_NO,
								SC.MEMBER_CC_ID
							FROM 
								#dsn3_alias#.SUBSCRIPTION_PAYMENT_PLAN_ROW SPR,
								#dsn3_alias#.SUBSCRIPTION_CONTRACT SC
							WHERE
								SPR.SUBSCRIPTION_ID = SC.SUBSCRIPTION_ID AND
								SPR.INVOICE_ID = #invoice_id# AND
							<cfif isDefined("attributes.prov_period") and len(attributes.prov_period)>
								PERIOD_ID = #attributes.prov_period#
							<cfelse>
								PERIOD_ID = #session.ep.period_id#
							</cfif>
						</cfquery>
						<cfif len(resp_code)>
							<cfif len(GET_SUBSCRIPTION_DETAIL.COMPANY_ID)>
								<cfset my_acc_result = get_company_period(GET_SUBSCRIPTION_DETAIL.COMPANY_ID)>
								<cfset content = Encrypt(card_no,GET_SUBSCRIPTION_DETAIL.COMPANY_ID,"CFMX_COMPAT","Hex")>
							<cfelse>
								<cfset my_acc_result = get_consumer_period(GET_SUBSCRIPTION_DETAIL.CONSUMER_ID)>
								<cfset content = Encrypt(card_no,GET_SUBSCRIPTION_DETAIL.CONSUMER_ID,"CFMX_COMPAT","Hex")>
							</cfif>
							<cfset wrk_id = dateformat(now(),'YYYYMMDD')&timeformat(now(),'HHmmssL')&'_#session.ep.userid#_'&round(rand()*100)>
							<!--- kredi kartı tahsilat kaydı yapılır --->
							<cfinclude template="../query/add_cc_revenue_from_multiprov.cfm">
							<cfquery name="UPD_PAYMENT_ROWS" datasource="#dsn2#">
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
								<cfif isDefined("attributes.prov_period") and len(attributes.prov_period)>
									PERIOD_ID = #attributes.prov_period#
								<cfelse>
									PERIOD_ID = #session.ep.period_id#
								</cfif>
							</cfquery>
							<cfif len(GET_SUBSCRIPTION_DETAIL.COMPANY_ID)><!--- Dönüş kodlarının kredi kartının detayına yazılması --->
								<cfquery name="UPD_COMPANY_CC" datasource="#dsn2#">
									UPDATE
										#dsn_alias#.COMPANY_CC
									SET
										RESP_CODE = NULL,
										UPDATE_DATE = #now()#,
										UPDATE_IP = '#cgi.remote_addr#',
										UPDATE_EMP = #session.ep.userid#
									WHERE
										COMPANY_CC_ID = #GET_SUBSCRIPTION_DETAIL.MEMBER_CC_ID#
								</cfquery>
							<cfelse>
								<cfquery name="UPD_CONSUMER_CC" datasource="#dsn2#">
									UPDATE
										#dsn_alias#.CONSUMER_CC
									SET
										RESP_CODE = NULL,
										UPDATE_DATE = #now()#,
										UPDATE_IP = '#cgi.remote_addr#',
										UPDATE_EMP = #session.ep.userid#
									WHERE

										CONSUMER_CC_ID = #GET_SUBSCRIPTION_DETAIL.MEMBER_CC_ID#
								</cfquery>
							</cfif>
							<cfoutput>#i# Provizyon İşlemi Onaylandı<br/></cfoutput>
						<cfelse>
							<cfquery name="UPD_PAYMENT_ROWS" datasource="#dsn2#">
								UPDATE
									#dsn3_alias#.SUBSCRIPTION_PAYMENT_PLAN_ROW

								SET
									IS_COLLECTED_PROVISION = 0,
									UPDATE_DATE = #now()#,
									UPDATE_IP = '#cgi.remote_addr#',
									UPDATE_EMP = #session.ep.userid#
								WHERE
									INVOICE_ID = #invoice_id# AND
								<cfif isDefined("attributes.prov_period") and len(attributes.prov_period)>
									PERIOD_ID = #attributes.prov_period#
								<cfelse>
									PERIOD_ID = #session.ep.period_id#
								</cfif>
							</cfquery>
							<cfif len(GET_SUBSCRIPTION_DETAIL.COMPANY_ID)><!--- Dönüş kodlarının kredi kartının detayına yazılması --->
								<cfquery name="UPD_COMPANY_CC" datasource="#dsn2#">
									UPDATE
										#dsn_alias#.COMPANY_CC
									SET
										RESP_CODE = '#resp_detail#',
										UPDATE_DATE = #now()#,
										UPDATE_IP = '#cgi.remote_addr#',
										UPDATE_EMP = #session.ep.userid#
									WHERE
										COMPANY_CC_ID = #GET_SUBSCRIPTION_DETAIL.MEMBER_CC_ID#
								</cfquery>
							<cfelse>
								<cfquery name="UPD_CONSUMER_CC" datasource="#dsn2#">
									UPDATE
										#dsn_alias#.CONSUMER_CC
									SET
										RESP_CODE = '#resp_detail#',
										UPDATE_DATE = #now()#,
										UPDATE_IP = '#cgi.remote_addr#',
										UPDATE_EMP = #session.ep.userid#
									WHERE
										CONSUMER_CC_ID = #GET_SUBSCRIPTION_DETAIL.MEMBER_CC_ID#
								</cfquery>
							</cfif>
							<cfoutput>#i# Provizyon İşlemi Onaylanmadı:	Dönüş Kodu:	#resp_detail#	Sistem No:	#GET_SUBSCRIPTION_DETAIL.SUBSCRIPTION_NO#<br/></cfoutput>
						</cfif>
					</cftransaction>
				</cflock>
				<cfcatch>
					<cfoutput>
						#i#.<cf_get_lang dictionary_id='64411.Satırda İşlem Kesilmiştir! Belgenizi Düzeltip Tekrar İmport Etmeniz Gerekmektedir'>.<br/>
					</cfoutput>
					<cfabort>
				</cfcatch> 
			</cftry>
		</cfloop>
	</cfif>
	
	<cfif GET_IMPORT.SOURCE_SYSTEM eq 6><!--- YKB--->
		<cfscript>// ilk satırdan dönem kontrolu 
			satir = dosya[1];
			prov_row_id = ListGetAt(oku(satir,96,74),2,'.');//prov satır idsi
		</cfscript>
		<cfquery name="GET_PERIOD_INFO" datasource="#dsn2#">
			SELECT PERIOD_ID FROM #dsn3_alias#.SUBSCRIPTION_PAYMENT_PLAN_ROW WHERE SUBSCRIPTION_PAYMENT_ROW_ID = #prov_row_id#
		</cfquery>
		<cfif (not (isDefined("attributes.prov_period") and len(attributes.prov_period)) and GET_PERIOD_INFO.PERIOD_ID neq session.ep.period_id) or (isDefined("attributes.prov_period") and len(attributes.prov_period) and GET_PERIOD_INFO.PERIOD_ID neq attributes.prov_period)>
			<script type="text/javascript">
				alert("<cf_get_lang dictionary_id='49068.Lütfen Döneminizi Kontrol Ediniz'>!");
				<cfif  isdefined("attributes.draggable")>location.href = document.referrer;<cfelse>	wrk_opener_reload();window.close();</cfif>
			</script>
			<cfabort>
		</cfif>
		<cfloop from="1" to="#line_count#" index="i"><!---trailer ları almamak için--->
			<cftry>
				<cflock name="#CreateUUID()#" timeout="20">
					<cftransaction>
						<cfscript>
							satir = dosya[i];
							card_no = oku(satir,1,16);//kart no
							nettotal = oku(satir,23,15);//Tutar
							resp_code = oku(satir,85,2);//onay kodu
							resp_detail = oku(satir,87,6);//prov kodu
							invoice_id = ListGetAt(oku(satir,96,74),1,'.');//invoice_id
						</cfscript>
						<cfquery name="GET_SUBSCRIPTION_DETAIL" datasource="#dsn2#">
							SELECT 
								INVOICE_COMPANY_ID COMPANY_ID,
								INVOICE_CONSUMER_ID CONSUMER_ID,
								SC.SUBSCRIPTION_NO,
								SC.MEMBER_CC_ID
							FROM 
								#dsn3_alias#.SUBSCRIPTION_PAYMENT_PLAN_ROW SPR,
								#dsn3_alias#.SUBSCRIPTION_CONTRACT SC
							WHERE
								SPR.SUBSCRIPTION_ID = SC.SUBSCRIPTION_ID AND
								SPR.INVOICE_ID = #invoice_id# AND
							<cfif isDefined("attributes.prov_period") and len(attributes.prov_period)>
								PERIOD_ID = #attributes.prov_period#
							<cfelse>
								PERIOD_ID = #session.ep.period_id#
							</cfif>
						</cfquery>
						<cfif len(resp_code)>
							<cfif len(GET_SUBSCRIPTION_DETAIL.COMPANY_ID)>
								<cfset my_acc_result = get_company_period(GET_SUBSCRIPTION_DETAIL.COMPANY_ID)>
								<cfset content = Encrypt(card_no,GET_SUBSCRIPTION_DETAIL.COMPANY_ID,"CFMX_COMPAT","Hex")>
							<cfelse>
								<cfset my_acc_result = get_consumer_period(GET_SUBSCRIPTION_DETAIL.CONSUMER_ID)>
								<cfset content = Encrypt(card_no,GET_SUBSCRIPTION_DETAIL.CONSUMER_ID,"CFMX_COMPAT","Hex")>
							</cfif>
							<cfset wrk_id = dateformat(now(),'YYYYMMDD')&timeformat(now(),'HHmmssL')&'_#session.ep.userid#_'&round(rand()*100)>
							<!--- kredi kartı tahsilat kaydı yapılır --->
							<cfinclude template="../query/add_cc_revenue_from_multiprov.cfm">
							<cfquery name="UPD_PAYMENT_ROWS" datasource="#dsn2#">
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
								<cfif isDefined("attributes.prov_period") and len(attributes.prov_period)>
									PERIOD_ID = #attributes.prov_period#
								<cfelse>
									PERIOD_ID = #session.ep.period_id#
								</cfif>
							</cfquery>
							<cfif len(GET_SUBSCRIPTION_DETAIL.COMPANY_ID)><!--- Dönüş kodlarının kredi kartının detayına yazılması --->
								<cfquery name="UPD_COMPANY_CC" datasource="#dsn2#">
									UPDATE
										#dsn_alias#.COMPANY_CC
									SET
										RESP_CODE = NULL,
										UPDATE_DATE = #now()#,
										UPDATE_IP = '#cgi.remote_addr#',
										UPDATE_EMP = #session.ep.userid#
									WHERE
										COMPANY_CC_ID = #GET_SUBSCRIPTION_DETAIL.MEMBER_CC_ID#
								</cfquery>
							<cfelse>
								<cfquery name="UPD_CONSUMER_CC" datasource="#dsn2#">
									UPDATE
										#dsn_alias#.CONSUMER_CC
									SET
										RESP_CODE = NULL,
										UPDATE_DATE = #now()#,
										UPDATE_IP = '#cgi.remote_addr#',
										UPDATE_EMP = #session.ep.userid#
									WHERE

										CONSUMER_CC_ID = #GET_SUBSCRIPTION_DETAIL.MEMBER_CC_ID#
								</cfquery>
							</cfif>
							<cfoutput>#i# Provizyon İşlemi Onaylandı<br/></cfoutput>
						<cfelse>
							<cfquery name="UPD_PAYMENT_ROWS" datasource="#dsn2#">
								UPDATE
									#dsn3_alias#.SUBSCRIPTION_PAYMENT_PLAN_ROW
								SET
									IS_COLLECTED_PROVISION = 0,
									UPDATE_DATE = #now()#,
									UPDATE_IP = '#cgi.remote_addr#',
									UPDATE_EMP = #session.ep.userid#
								WHERE
									INVOICE_ID = #invoice_id# AND
								<cfif isDefined("attributes.prov_period") and len(attributes.prov_period)>
									PERIOD_ID = #attributes.prov_period#
								<cfelse>
									PERIOD_ID = #session.ep.period_id#
								</cfif>
							</cfquery>
							<cfif len(GET_SUBSCRIPTION_DETAIL.COMPANY_ID)><!--- Dönüş kodlarının kredi kartının detayına yazılması --->
								<cfquery name="UPD_COMPANY_CC" datasource="#dsn2#">
									UPDATE
										#dsn_alias#.COMPANY_CC
									SET
										RESP_CODE = '#resp_detail#',
										UPDATE_DATE = #now()#,
										UPDATE_IP = '#cgi.remote_addr#',
										UPDATE_EMP = #session.ep.userid#
									WHERE
										COMPANY_CC_ID = #GET_SUBSCRIPTION_DETAIL.MEMBER_CC_ID#
								</cfquery>
							<cfelse>
								<cfquery name="UPD_CONSUMER_CC" datasource="#dsn2#">
									UPDATE
										#dsn_alias#.CONSUMER_CC
									SET
										RESP_CODE = '#resp_detail#',
										UPDATE_DATE = #now()#,
										UPDATE_IP = '#cgi.remote_addr#',
										UPDATE_EMP = #session.ep.userid#
									WHERE
										CONSUMER_CC_ID = #GET_SUBSCRIPTION_DETAIL.MEMBER_CC_ID#
								</cfquery>
							</cfif>
							<cfoutput>#i# Provizyon İşlemi Onaylanmadı:	Dönüş Kodu:	#resp_detail#	Sistem No:	#GET_SUBSCRIPTION_DETAIL.SUBSCRIPTION_NO#<br/></cfoutput>
						</cfif>
					</cftransaction>
				</cflock>
				<cfcatch>
					<cfoutput>
						#i#.<cf_get_lang dictionary_id='64411.Satırda İşlem Kesilmiştir! Belgenizi Düzeltip Tekrar İmport Etmeniz Gerekmektedir'>.<br/>
					</cfoutput>
					<cfabort>
				</cfcatch> 
			</cftry>
		</cfloop>
	</cfif>
	
	<cfif GET_IMPORT.SOURCE_SYSTEM eq 7><!--- Akbank format--->
		<cfscript>// ilk satırdan dönem kontrolu
			satir = dosya[1];
			prov_row_id = oku(satir,376,30);//prov satır idsi
		</cfscript>
		<cfquery name="GET_PERIOD_INFO" datasource="#dsn2#">
			SELECT PERIOD_ID FROM #dsn3_alias#.SUBSCRIPTION_PAYMENT_PLAN_ROW WHERE SUBSCRIPTION_PAYMENT_ROW_ID = #prov_row_id#
		</cfquery>
		<cfif (not (isDefined("attributes.prov_period") and len(attributes.prov_period)) and GET_PERIOD_INFO.PERIOD_ID neq session.ep.period_id) or (isDefined("attributes.prov_period") and len(attributes.prov_period) and GET_PERIOD_INFO.PERIOD_ID neq attributes.prov_period)>
			<script type="text/javascript">
				alert("<cf_get_lang dictionary_id='49068.Lütfen Döneminizi Kontrol Ediniz'>!");
				<cfif  isdefined("attributes.draggable")>location.href = document.referrer;<cfelse>	wrk_opener_reload();window.close();</cfif>
			</script>
			<cfabort>
		</cfif>
		<cfloop from="1" to="#line_count#" index="i">
			<cftry>
				<cflock name="#CreateUUID()#" timeout="20">
					<cftransaction>
						<cfscript>
							satir = dosya[i];
							card_no = oku(satir,23,16);//kart no
							nettotal = oku(satir,49,11) & "." & oku(satir,60,2);//Tutar
							resp_code = oku(satir,688,2);//Provizyon Numarası
							invoice_id = oku(satir,406,30);//invoice_id
						</cfscript>
						<cfquery name="GET_SUBSCRIPTION_DETAIL" datasource="#dsn2#">
							SELECT 
								INVOICE_COMPANY_ID COMPANY_ID,
								INVOICE_CONSUMER_ID CONSUMER_ID,
								SC.SUBSCRIPTION_NO,
								SC.MEMBER_CC_ID
							FROM 
								#dsn3_alias#.SUBSCRIPTION_PAYMENT_PLAN_ROW SPR,
								#dsn3_alias#.SUBSCRIPTION_CONTRACT SC
							WHERE 
								SPR.SUBSCRIPTION_ID = SC.SUBSCRIPTION_ID AND
								SPR.INVOICE_ID = #invoice_id# AND
							<cfif isDefined("attributes.prov_period") and len(attributes.prov_period)>
								PERIOD_ID = #attributes.prov_period#
							<cfelse>
								PERIOD_ID = #session.ep.period_id#
							</cfif>
						</cfquery>
						<cfif resp_code eq 00>
							<cfif len(GET_SUBSCRIPTION_DETAIL.COMPANY_ID)>
								<cfset my_acc_result = get_company_period(GET_SUBSCRIPTION_DETAIL.COMPANY_ID)>
								<cfset content = Encrypt(card_no,GET_SUBSCRIPTION_DETAIL.COMPANY_ID,"CFMX_COMPAT","Hex")>
							<cfelse>
								<cfset my_acc_result = get_consumer_period(GET_SUBSCRIPTION_DETAIL.CONSUMER_ID)>
								<cfset content = Encrypt(card_no,GET_SUBSCRIPTION_DETAIL.CONSUMER_ID,"CFMX_COMPAT","Hex")>
							</cfif>
							<cfset wrk_id = dateformat(now(),'YYYYMMDD')&timeformat(now(),'HHmmssL')&'_#session.ep.userid#_'&round(rand()*100)>
							<!--- kredi kartı tahsilat kaydı yapılır --->
							<cfinclude template="../query/add_cc_revenue_from_multiprov.cfm">
							<cfquery name="UPD_PAYMENT_ROWS" datasource="#dsn2#">
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
								<cfif isDefined("attributes.prov_period") and len(attributes.prov_period)>
									PERIOD_ID = #attributes.prov_period#
								<cfelse>
									PERIOD_ID = #session.ep.period_id#
								</cfif>
							</cfquery>
							<cfif len(GET_SUBSCRIPTION_DETAIL.COMPANY_ID)><!--- Dönüş kodlarının kredi kartının detayına yazılması --->
								<cfquery name="UPD_COMPANY_CC" datasource="#dsn2#">
									UPDATE
										#dsn_alias#.COMPANY_CC
									SET
										RESP_CODE = NULL,
										UPDATE_DATE = #now()#,
										UPDATE_IP = '#cgi.remote_addr#',
										UPDATE_EMP = #session.ep.userid#
									WHERE
										COMPANY_CC_ID = #GET_SUBSCRIPTION_DETAIL.MEMBER_CC_ID#
								</cfquery>
							<cfelse>
								<cfquery name="UPD_CONSUMER_CC" datasource="#dsn2#">
									UPDATE
										#dsn_alias#.CONSUMER_CC
									SET
										RESP_CODE = NULL,
										UPDATE_DATE = #now()#,
										UPDATE_IP = '#cgi.remote_addr#',
										UPDATE_EMP = #session.ep.userid#
									WHERE
										CONSUMER_CC_ID = #GET_SUBSCRIPTION_DETAIL.MEMBER_CC_ID#
								</cfquery>
							</cfif>
							<cfoutput>#i# Provizyon İşlemi Onaylandı<br/></cfoutput>
						<cfelse>
							<cfquery name="UPD_PAYMENT_ROWS" datasource="#dsn2#">
								UPDATE
									#dsn3_alias#.SUBSCRIPTION_PAYMENT_PLAN_ROW
								SET
									IS_COLLECTED_PROVISION = 0,
									UPDATE_DATE = #now()#,
									UPDATE_IP = '#cgi.remote_addr#',
									UPDATE_EMP = #session.ep.userid#
								WHERE
									INVOICE_ID = #invoice_id# AND
								<cfif isDefined("attributes.prov_period") and len(attributes.prov_period)>
									PERIOD_ID = #attributes.prov_period#
								<cfelse>
									PERIOD_ID = #session.ep.period_id#
								</cfif>
							</cfquery>
							<cfif len(GET_SUBSCRIPTION_DETAIL.COMPANY_ID)><!--- Dönüş kodlarının kredi kartının detayına yazılması --->
								<cfquery name="UPD_COMPANY_CC" datasource="#dsn2#">
									UPDATE
										#dsn_alias#.COMPANY_CC
									SET
										RESP_CODE = '#resp_code#',
										UPDATE_DATE = #now()#,
										UPDATE_IP = '#cgi.remote_addr#',
										UPDATE_EMP = #session.ep.userid#
									WHERE
										COMPANY_CC_ID = #GET_SUBSCRIPTION_DETAIL.MEMBER_CC_ID#
								</cfquery>
							<cfelse>
								<cfquery name="UPD_CONSUMER_CC" datasource="#dsn2#">
									UPDATE
										#dsn_alias#.CONSUMER_CC
									SET
										RESP_CODE = '#resp_code#',
										UPDATE_DATE = #now()#,
										UPDATE_IP = '#cgi.remote_addr#',
										UPDATE_EMP = #session.ep.userid#
									WHERE
										CONSUMER_CC_ID = #GET_SUBSCRIPTION_DETAIL.MEMBER_CC_ID#
								</cfquery>
							</cfif>
							<cfoutput>#i# Provizyon İşlemi Onaylanmadı:	Dönüş Kodu:	#resp_code#	Sistem No:	#GET_SUBSCRIPTION_DETAIL.SUBSCRIPTION_NO#<br/></cfoutput>
						</cfif>
					</cftransaction>
				</cflock>
				<cfcatch>
					<cfoutput>
						#i#.<cf_get_lang dictionary_id='64411.Satırda İşlem Kesilmiştir! Belgenizi Düzeltip Tekrar İmport Etmeniz Gerekmektedir'>.<br/>
					</cfoutput>
					<cfabort>
				</cfcatch> 
			</cftry>
		</cfloop>
	</cfif>
	
	<cfif GET_IMPORT.SOURCE_SYSTEM eq 8><!--- Denizbank format--->
		<cfscript>// ilk satırdan dönem kontrolu
			satir = dosya[1];
			prov_row_id = oku(satir,376,30);//prov satır idsi
		</cfscript>
		<cfquery name="GET_PERIOD_INFO" datasource="#dsn2#">
			SELECT PERIOD_ID FROM #dsn3_alias#.SUBSCRIPTION_PAYMENT_PLAN_ROW WHERE SUBSCRIPTION_PAYMENT_ROW_ID = #prov_row_id#
		</cfquery>
		<cfif (not (isDefined("attributes.prov_period") and len(attributes.prov_period)) and GET_PERIOD_INFO.PERIOD_ID neq session.ep.period_id) or (isDefined("attributes.prov_period") and len(attributes.prov_period) and GET_PERIOD_INFO.PERIOD_ID neq attributes.prov_period)>
			<script type="text/javascript">
				alert("<cf_get_lang dictionary_id='49068.Lütfen Döneminizi Kontrol Ediniz'>!");
				<cfif  isdefined("attributes.draggable")>location.href = document.referrer;<cfelse>	wrk_opener_reload();window.close();</cfif>
			</script>
			<cfabort>
		</cfif>
		<cfloop from="1" to="#line_count#" index="i">
			<cftry>
				<cflock name="#CreateUUID()#" timeout="20">
					<cftransaction>
						<cfscript>
							satir = dosya[i];
							card_no = oku(satir,23,16);//kart no
							nettotal = oku(satir,49,11) & "." & oku(satir,60,2);//Tutar
							resp_code = oku(satir,688,2);//Provizyon Numarası
							invoice_id = oku(satir,406,30);//invoice_id
						</cfscript>
						<cfquery name="GET_SUBSCRIPTION_DETAIL" datasource="#dsn2#">
							SELECT 
								INVOICE_COMPANY_ID COMPANY_ID,
								INVOICE_CONSUMER_ID CONSUMER_ID,
								SC.SUBSCRIPTION_NO,
								SC.MEMBER_CC_ID
							FROM 
								#dsn3_alias#.SUBSCRIPTION_PAYMENT_PLAN_ROW SPR,
								#dsn3_alias#.SUBSCRIPTION_CONTRACT SC
							WHERE 
								SPR.SUBSCRIPTION_ID = SC.SUBSCRIPTION_ID AND
								SPR.INVOICE_ID = #invoice_id# AND
							<cfif isDefined("attributes.prov_period") and len(attributes.prov_period)>
								PERIOD_ID = #attributes.prov_period#
							<cfelse>
								PERIOD_ID = #session.ep.period_id#
							</cfif>
						</cfquery>
						<cfif resp_code eq 00>
							<cfif len(GET_SUBSCRIPTION_DETAIL.COMPANY_ID)>
								<cfset my_acc_result = get_company_period(GET_SUBSCRIPTION_DETAIL.COMPANY_ID)>
								<cfset content = Encrypt(card_no,GET_SUBSCRIPTION_DETAIL.COMPANY_ID,"CFMX_COMPAT","Hex")>
							<cfelse>
								<cfset my_acc_result = get_consumer_period(GET_SUBSCRIPTION_DETAIL.CONSUMER_ID)>
								<cfset content = Encrypt(card_no,GET_SUBSCRIPTION_DETAIL.CONSUMER_ID,"CFMX_COMPAT","Hex")>
							</cfif>
							<cfset wrk_id = dateformat(now(),'YYYYMMDD')&timeformat(now(),'HHmmssL')&'_#session.ep.userid#_'&round(rand()*100)>
							<!--- kredi kartı tahsilat kaydı yapılır --->
							<cfinclude template="../query/add_cc_revenue_from_multiprov.cfm">
							<cfquery name="UPD_PAYMENT_ROWS" datasource="#dsn2#">
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
								<cfif isDefined("attributes.prov_period") and len(attributes.prov_period)>
									PERIOD_ID = #attributes.prov_period#
								<cfelse>
									PERIOD_ID = #session.ep.period_id#
								</cfif>
							</cfquery>
							<cfif len(GET_SUBSCRIPTION_DETAIL.COMPANY_ID)><!--- Dönüş kodlarının kredi kartının detayına yazılması --->
								<cfquery name="UPD_COMPANY_CC" datasource="#dsn2#">
									UPDATE
										#dsn_alias#.COMPANY_CC
									SET
										RESP_CODE = NULL,
										UPDATE_DATE = #now()#,
										UPDATE_IP = '#cgi.remote_addr#',
										UPDATE_EMP = #session.ep.userid#
									WHERE
										COMPANY_CC_ID = #GET_SUBSCRIPTION_DETAIL.MEMBER_CC_ID#
								</cfquery>
							<cfelse>
								<cfquery name="UPD_CONSUMER_CC" datasource="#dsn2#">
									UPDATE
										#dsn_alias#.CONSUMER_CC
									SET
										RESP_CODE = NULL,
										UPDATE_DATE = #now()#,
										UPDATE_IP = '#cgi.remote_addr#',
										UPDATE_EMP = #session.ep.userid#
									WHERE
										CONSUMER_CC_ID = #GET_SUBSCRIPTION_DETAIL.MEMBER_CC_ID#
								</cfquery>
							</cfif>
							<cfoutput>#i# Provizyon İşlemi Onaylandı<br/></cfoutput>
						<cfelse>
							<cfquery name="UPD_PAYMENT_ROWS" datasource="#dsn2#">
								UPDATE
									#dsn3_alias#.SUBSCRIPTION_PAYMENT_PLAN_ROW
								SET
									IS_COLLECTED_PROVISION = 0,
									UPDATE_DATE = #now()#,
									UPDATE_IP = '#cgi.remote_addr#',
									UPDATE_EMP = #session.ep.userid#
								WHERE
									INVOICE_ID = #invoice_id# AND
								<cfif isDefined("attributes.prov_period") and len(attributes.prov_period)>
									PERIOD_ID = #attributes.prov_period#
								<cfelse>
									PERIOD_ID = #session.ep.period_id#
								</cfif>
							</cfquery>
							<cfif len(GET_SUBSCRIPTION_DETAIL.COMPANY_ID)><!--- Dönüş kodlarının kredi kartının detayına yazılması --->
								<cfquery name="UPD_COMPANY_CC" datasource="#dsn2#">
									UPDATE
										#dsn_alias#.COMPANY_CC
									SET
										RESP_CODE = '#resp_code#',
										UPDATE_DATE = #now()#,
										UPDATE_IP = '#cgi.remote_addr#',
										UPDATE_EMP = #session.ep.userid#
									WHERE
										COMPANY_CC_ID = #GET_SUBSCRIPTION_DETAIL.MEMBER_CC_ID#
								</cfquery>
							<cfelse>
								<cfquery name="UPD_CONSUMER_CC" datasource="#dsn2#">
									UPDATE
										#dsn_alias#.CONSUMER_CC
									SET
										RESP_CODE = '#resp_code#',
										UPDATE_DATE = #now()#,
										UPDATE_IP = '#cgi.remote_addr#',
										UPDATE_EMP = #session.ep.userid#
									WHERE
										CONSUMER_CC_ID = #GET_SUBSCRIPTION_DETAIL.MEMBER_CC_ID#
								</cfquery>
							</cfif>
							<cfoutput>#i# Provizyon İşlemi Onaylanmadı:	Dönüş Kodu:	#resp_code#	Sistem No:	#GET_SUBSCRIPTION_DETAIL.SUBSCRIPTION_NO#<br/></cfoutput>
						</cfif>
					</cftransaction>
				</cflock>
				<cfcatch>
					<cfoutput>
						#i#.<cf_get_lang dictionary_id='64411.Satırda İşlem Kesilmiştir! Belgenizi Düzeltip Tekrar İmport Etmeniz Gerekmektedir'>.<br/>
					</cfoutput>
					<cfabort>
				</cfcatch> 
			</cftry>
		</cfloop>
	</cfif>
	
	<cfif GET_IMPORT.SOURCE_SYSTEM eq 9><!--- ING format--->
		<cfscript>// ilk satırdan dönem kontrolu
			satir = dosya[1];
			prov_row_id = oku(satir,376,30);//prov satır idsi
		</cfscript>
		<cfquery name="GET_PERIOD_INFO" datasource="#dsn2#">
			SELECT PERIOD_ID FROM #dsn3_alias#.SUBSCRIPTION_PAYMENT_PLAN_ROW WHERE SUBSCRIPTION_PAYMENT_ROW_ID = #prov_row_id#
		</cfquery>
		<cfif (not (isDefined("attributes.prov_period") and len(attributes.prov_period)) and GET_PERIOD_INFO.PERIOD_ID neq session.ep.period_id) or (isDefined("attributes.prov_period") and len(attributes.prov_period) and GET_PERIOD_INFO.PERIOD_ID neq attributes.prov_period)>
			<script language="JavaScript">
				alert("<cf_get_lang dictionary_id='49068.Lütfen Döneminizi Kontrol Ediniz'>!");
				<cfif  isdefined("attributes.draggable")>location.href = document.referrer;<cfelse>opener.location.reload();window.close();</cfif>
			</script>
			<cfabort>
		</cfif>
		<cfloop from="1" to="#line_count#" index="i">
			<cftry>
				<cflock name="#CreateUUID()#" timeout="20">
					<cftransaction>
						<cfscript>
							satir = dosya[i];
							card_no = oku(satir,23,16);//kart no
							nettotal = oku(satir,49,11) & "." & oku(satir,60,2);//Tutar
							resp_code = oku(satir,645,3);//onay kodu
							invoice_id = oku(satir,406,30);//invoice_id
						</cfscript>
						
						<cfquery name="GET_SUBSCRIPTION_DETAIL" datasource="#dsn2#">
							SELECT 
								INVOICE_COMPANY_ID COMPANY_ID,
								INVOICE_CONSUMER_ID CONSUMER_ID,
								SC.SUBSCRIPTION_NO,
								SC.MEMBER_CC_ID
							FROM 
								#dsn3_alias#.SUBSCRIPTION_PAYMENT_PLAN_ROW SPR,
								#dsn3_alias#.SUBSCRIPTION_CONTRACT SC
							WHERE 
								SPR.SUBSCRIPTION_ID = SC.SUBSCRIPTION_ID AND
								SPR.INVOICE_ID = #invoice_id# AND
							<cfif isDefined("attributes.prov_period") and len(attributes.prov_period)>
								PERIOD_ID = #attributes.prov_period#
							<cfelse>
								PERIOD_ID = #session.ep.period_id#
							</cfif>
						</cfquery>
						<cfif resp_code eq '000' or resp_code eq '011'>
							<cfif len(GET_SUBSCRIPTION_DETAIL.COMPANY_ID)>
								<cfset my_acc_result = get_company_period(GET_SUBSCRIPTION_DETAIL.COMPANY_ID)>
								<cfset content = Encrypt(card_no,GET_SUBSCRIPTION_DETAIL.COMPANY_ID,"CFMX_COMPAT","Hex")>
							<cfelse>
								<cfset my_acc_result = get_consumer_period(GET_SUBSCRIPTION_DETAIL.CONSUMER_ID)>
								<cfset content = Encrypt(card_no,GET_SUBSCRIPTION_DETAIL.CONSUMER_ID,"CFMX_COMPAT","Hex")>
							</cfif>
							<cfset wrk_id = dateformat(now(),'YYYYMMDD')&timeformat(now(),'HHmmssL')&'_#session.ep.userid#_'&round(rand()*100)>
							<!--- kredi kartı tahsilat kaydı yapılır --->
							<cfinclude template="../query/add_cc_revenue_from_multiprov.cfm">
							<cfquery name="UPD_PAYMENT_ROWS" datasource="#dsn2#">
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
								<cfif isDefined("attributes.prov_period") and len(attributes.prov_period)>
									PERIOD_ID = #attributes.prov_period#
								<cfelse>
									PERIOD_ID = #session.ep.period_id#
								</cfif>
							</cfquery>
							<cfif len(GET_SUBSCRIPTION_DETAIL.COMPANY_ID)><!--- Dönüş kodlarının kredi kartının detayına yazılması --->
								<cfquery name="UPD_COMPANY_CC" datasource="#dsn2#">
									UPDATE
										#dsn_alias#.COMPANY_CC
									SET
										RESP_CODE = NULL,
										UPDATE_DATE = #now()#,
										UPDATE_IP = '#cgi.remote_addr#',
										UPDATE_EMP = #session.ep.userid#
									WHERE

										COMPANY_CC_ID = #GET_SUBSCRIPTION_DETAIL.MEMBER_CC_ID#
								</cfquery>
							<cfelse>
								<cfquery name="UPD_CONSUMER_CC" datasource="#dsn2#">
									UPDATE
										#dsn_alias#.CONSUMER_CC
									SET
										RESP_CODE = NULL,
										UPDATE_DATE = #now()#,
										UPDATE_IP = '#cgi.remote_addr#',
										UPDATE_EMP = #session.ep.userid#
									WHERE
										CONSUMER_CC_ID = #GET_SUBSCRIPTION_DETAIL.MEMBER_CC_ID#
								</cfquery>
							</cfif>
							<cfoutput>#i# Provizyon İşlemi Onaylandı<br/></cfoutput>
						<cfelse>
							<cfquery name="UPD_PAYMENT_ROWS" datasource="#dsn2#">
								UPDATE
									#dsn3_alias#.SUBSCRIPTION_PAYMENT_PLAN_ROW
								SET
									IS_COLLECTED_PROVISION = 0,
									UPDATE_DATE = #now()#,
									UPDATE_IP = '#cgi.remote_addr#',
									UPDATE_EMP = #session.ep.userid#
								WHERE
									INVOICE_ID = #invoice_id# AND
								<cfif isDefined("attributes.prov_period") and len(attributes.prov_period)>
									PERIOD_ID = #attributes.prov_period#
								<cfelse>
									PERIOD_ID = #session.ep.period_id#
								</cfif>
							</cfquery>
							<cfif len(GET_SUBSCRIPTION_DETAIL.COMPANY_ID)><!--- Dönüş kodlarının kredi kartının detayına yazılması --->
								<cfquery name="UPD_COMPANY_CC" datasource="#dsn2#">
									UPDATE
										#dsn_alias#.COMPANY_CC
									SET
										RESP_CODE = '#resp_code#',
										UPDATE_DATE = #now()#,
										UPDATE_IP = '#cgi.remote_addr#',
										UPDATE_EMP = #session.ep.userid#
									WHERE
										COMPANY_CC_ID = #GET_SUBSCRIPTION_DETAIL.MEMBER_CC_ID#
								</cfquery>
							<cfelse>
								<cfquery name="UPD_CONSUMER_CC" datasource="#dsn2#">
									UPDATE
										#dsn_alias#.CONSUMER_CC
									SET
										RESP_CODE = '#resp_code#',
										UPDATE_DATE = #now()#,
										UPDATE_IP = '#cgi.remote_addr#',
										UPDATE_EMP = #session.ep.userid#
									WHERE
										CONSUMER_CC_ID = #GET_SUBSCRIPTION_DETAIL.MEMBER_CC_ID#
								</cfquery>
							</cfif>
							<cfoutput>#i# Provizyon İşlemi Onaylanmadı:	Dönüş Kodu:	#resp_code#	Sistem No:	#GET_SUBSCRIPTION_DETAIL.SUBSCRIPTION_NO#<br/></cfoutput>
						</cfif>
					</cftransaction>
				</cflock>
				<cfcatch>
					<cfoutput>
						#i#.<cf_get_lang dictionary_id='64411.Satırda İşlem Kesilmiştir! Belgenizi Düzeltip Tekrar İmport Etmeniz Gerekmektedir'>.<br/>
					</cfoutput>
					<cfabort>
				</cfcatch> 
			</cftry>
		</cfloop>
	</cfif>

	<cfif GET_IMPORT.SOURCE_SYSTEM eq 10><!--- Banksoft format--->
		<cfscript>// ilk satırdan dönem kontrolu
			satir = dosya[1];
			prov_row_id = oku(satir,4,15);//prov satır idsi
		</cfscript>
		<cfquery name="GET_PERIOD_INFO" datasource="#dsn2#">
			SELECT PERIOD_ID FROM #dsn3_alias#.SUBSCRIPTION_PAYMENT_PLAN_ROW WHERE SUBSCRIPTION_PAYMENT_ROW_ID = #prov_row_id#
		</cfquery>
		<cfif (not (isDefined("attributes.prov_period") and len(attributes.prov_period)) and GET_PERIOD_INFO.PERIOD_ID neq session.ep.period_id) or (isDefined("attributes.prov_period") and len(attributes.prov_period) and GET_PERIOD_INFO.PERIOD_ID neq attributes.prov_period)>
			<script type="text/javascript">
				alert("<cf_get_lang dictionary_id='49068.Lütfen Döneminizi Kontrol Ediniz'>!");
				<cfif  isdefined("attributes.draggable")>location.href = document.referrer;<cfelse>	wrk_opener_reload();window.close();</cfif>
			</script>
			<cfabort>
		</cfif>
		<cfloop from="1" to="#line_count-1#" index="i">
			<cftry>
				<cflock name="#CreateUUID()#" timeout="20">
					<cftransaction>
						<cfscript>
							satir = dosya[i];
							nettotal = oku(satir,30,13) & "." & oku(satir,43,2);//Tutar
							card_no = oku(satir,65,19);//kart no
							resp_code = oku(satir,140,3);//onay kodu
							invoice_id = oku(satir,171,50);//invoice_id
						</cfscript><!--- <cfdump var="#nettotal#"><cfabort> --->
						<cfquery name="GET_SUBSCRIPTION_DETAIL" datasource="#dsn2#">
							SELECT 
								INVOICE_COMPANY_ID COMPANY_ID,
								INVOICE_CONSUMER_ID CONSUMER_ID,
								SC.SUBSCRIPTION_NO,
								SC.MEMBER_CC_ID
							FROM 
								#dsn3_alias#.SUBSCRIPTION_PAYMENT_PLAN_ROW SPR,
								#dsn3_alias#.SUBSCRIPTION_CONTRACT SC
							WHERE 
								SPR.SUBSCRIPTION_ID = SC.SUBSCRIPTION_ID AND
								SPR.INVOICE_ID = #invoice_id# AND
							<cfif isDefined("attributes.prov_period") and len(attributes.prov_period)>
								PERIOD_ID = #attributes.prov_period#
							<cfelse>
								PERIOD_ID = #session.ep.period_id#
							</cfif>
						</cfquery>
						<cfif resp_code eq 000>
							<cfif len(GET_SUBSCRIPTION_DETAIL.COMPANY_ID)>
								<cfset my_acc_result = get_company_period(GET_SUBSCRIPTION_DETAIL.COMPANY_ID)>
								<cfset content = Encrypt(card_no,GET_SUBSCRIPTION_DETAIL.COMPANY_ID,"CFMX_COMPAT","Hex")>
							<cfelse>
								<cfset my_acc_result = get_consumer_period(GET_SUBSCRIPTION_DETAIL.CONSUMER_ID)>
								<cfset content = Encrypt(card_no,GET_SUBSCRIPTION_DETAIL.CONSUMER_ID,"CFMX_COMPAT","Hex")>
							</cfif>
							<cfset wrk_id = dateformat(now(),'YYYYMMDD')&timeformat(now(),'HHmmssL')&'_#session.ep.userid#_'&round(rand()*100)>
							<!--- kredi kartı tahsilat kaydı yapılır --->
							<cfinclude template="../query/add_cc_revenue_from_multiprov.cfm">
							<cfquery name="UPD_PAYMENT_ROWS" datasource="#dsn2#">
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
								<cfif isDefined("attributes.prov_period") and len(attributes.prov_period)>
									PERIOD_ID = #attributes.prov_period#
								<cfelse>
									PERIOD_ID = #session.ep.period_id#
								</cfif>
							</cfquery>
							<cfif len(GET_SUBSCRIPTION_DETAIL.COMPANY_ID)><!--- Dönüş kodlarının kredi kartının detayına yazılması --->
								<cfquery name="UPD_COMPANY_CC" datasource="#dsn2#">
									UPDATE
										#dsn_alias#.COMPANY_CC
									SET
										RESP_CODE = NULL,
										UPDATE_DATE = #now()#,
										UPDATE_IP = '#cgi.remote_addr#',
										UPDATE_EMP = #session.ep.userid#
									WHERE
										COMPANY_CC_ID = #GET_SUBSCRIPTION_DETAIL.MEMBER_CC_ID#
								</cfquery>
							<cfelse>
								<cfquery name="UPD_CONSUMER_CC" datasource="#dsn2#">
									UPDATE
										#dsn_alias#.CONSUMER_CC
									SET
										RESP_CODE = NULL,
										UPDATE_DATE = #now()#,
										UPDATE_IP = '#cgi.remote_addr#',
										UPDATE_EMP = #session.ep.userid#
									WHERE
										CONSUMER_CC_ID = #GET_SUBSCRIPTION_DETAIL.MEMBER_CC_ID#
								</cfquery>
							</cfif>
							<cfoutput>#i# Provizyon İşlemi Onaylandı<br/></cfoutput>
						<cfelse>
							<cfquery name="UPD_PAYMENT_ROWS" datasource="#dsn2#">
								UPDATE
									#dsn3_alias#.SUBSCRIPTION_PAYMENT_PLAN_ROW
								SET
									IS_COLLECTED_PROVISION = 0,
									UPDATE_DATE = #now()#,
									UPDATE_IP = '#cgi.remote_addr#',
									UPDATE_EMP = #session.ep.userid#
								WHERE
									INVOICE_ID = #invoice_id# AND
								<cfif isDefined("attributes.prov_period") and len(attributes.prov_period)>
									PERIOD_ID = #attributes.prov_period#
								<cfelse>
									PERIOD_ID = #session.ep.period_id#
								</cfif>
							</cfquery>
							<cfif len(GET_SUBSCRIPTION_DETAIL.COMPANY_ID)><!--- Dönüş kodlarının kredi kartının detayına yazılması --->
								<cfquery name="UPD_COMPANY_CC" datasource="#dsn2#">
									UPDATE
										#dsn_alias#.COMPANY_CC
									SET
										RESP_CODE = '#resp_code#',
										UPDATE_DATE = #now()#,
										UPDATE_IP = '#cgi.remote_addr#',
										UPDATE_EMP = #session.ep.userid#
									WHERE
										COMPANY_CC_ID = #GET_SUBSCRIPTION_DETAIL.MEMBER_CC_ID#
								</cfquery>
							<cfelse>
								<cfquery name="UPD_CONSUMER_CC" datasource="#dsn2#">
									UPDATE
										#dsn_alias#.CONSUMER_CC
									SET
										RESP_CODE = '#resp_code#',
										UPDATE_DATE = #now()#,
										UPDATE_IP = '#cgi.remote_addr#',
										UPDATE_EMP = #session.ep.userid#
									WHERE
										CONSUMER_CC_ID = #GET_SUBSCRIPTION_DETAIL.MEMBER_CC_ID#
								</cfquery>
							</cfif>
							<cfoutput>#i# Provizyon İşlemi Onaylanmadı:	Dönüş Kodu:	#resp_code#	Sistem No:	#GET_SUBSCRIPTION_DETAIL.SUBSCRIPTION_NO#<br/></cfoutput>
						</cfif>
					</cftransaction>
				</cflock>
				<cfcatch>
					<cfoutput>
						#i#.<cf_get_lang dictionary_id='64411.Satırda İşlem Kesilmiştir! Belgenizi Düzeltip Tekrar İmport Etmeniz Gerekmektedir'>.<br/>
					</cfoutput>
					<cfabort>
				</cfcatch> 
			</cftry>
		</cfloop>
	</cfif>
	
	<cfoutput><cf_get_lang dictionary_id='54060.İmport işlemi tamamlandı'>...</cfoutput>
	<script type="text/javascript">
		<cfif  isdefined("attributes.draggable")>location.href = document.referrer;<cfelse>	wrk_opener_reload();window.close();</cfif>
	</script>
<cfelse>
	<script type="text/javascript">
		alert("<cf_get_lang dictionary_id='64409.Bu Belge İçin Import Yapılmıştır'>!");
		<cfif  isdefined("attributes.draggable")>location.href = document.referrer;<cfelse>	wrk_opener_reload();window.close();</cfif>
	</script>
	<cfabort>
</cfif>
