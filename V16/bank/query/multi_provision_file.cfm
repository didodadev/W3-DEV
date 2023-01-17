<!--- Pronet için provizyon belgesi oluşturan sayfasıdır,Garanti,Garanti TPOS ,HSBC ve TEB,İşBankası formatları vardır.
Başka firmalar için istenirse firma bilgileri değiştitirilerek add_options a taşıanabilir
Ayşenur 20060810 --->
<cfsetting showdebugoutput="no">
<cfif not isDefined("attributes.is_detailed") and attributes.bank_name neq 5>
	<script type="text/javascript">
		alert("İşBankası Dışındaki Pos Tiplerinde Detaylı Parametresini Seçerek İşlem Yapabilirsiniz!");
		history.back();
	</script>
	<cfabort>
</cfif>
<cfscript>
	CRLF=chr(13)&chr(10);
	file_content = ArrayNew(1);
	file_content_first = ArrayNew(1);
	file_content_main = ArrayNew(1);
	index_array = 1;
	toplam = 0;
	kayit_sayisi = 0;
	islem_tarihi = createodbcdatetime('#year(now())#-#month(now())#-#day(now())#');
</cfscript>
<cfif attributes.bank_name eq 1><!--- Garanti(txt) Belge Formatı--->
	<cfloop from="1" to="#attributes.all_records#" index="i">
		<cftry>
			<cflock name="#CreateUUID()#" timeout="20">
				<cftransaction>
					<cfif isdefined("attributes.payment_row#i#")>
						<cfquery name="GET_PROV_INFO" datasource="#DSN3#"><!--- aynı anda yapılan işlemlerin kontrolu --->
							SELECT
								IS_COLLECTED_PROVISION
							FROM
								SUBSCRIPTION_PAYMENT_PLAN_ROW
							WHERE
								INVOICE_ID = #evaluate("attributes.invoice_id#i#")# AND
							<cfif isDefined("attributes.prov_period") and len(attributes.prov_period)>
								PERIOD_ID = #ListGetAt(attributes.prov_period,3,";")#
							<cfelse>
								PERIOD_ID = #session.ep.period_id#
							</cfif>
						</cfquery>
						<cfif GET_PROV_INFO.IS_COLLECTED_PROVISION eq 0>
							<cfscript>
								satir = "";
								tutar = evaluate("attributes.nettotal#i#");
								if(int(tutar) eq tutar)tutar = tutar & "00";
								else if((int(tutar * 10)) eq (tutar * 10))tutar = (tutar*10) & "0";
								else tutar = tutar * 100;
								satir = satir & "001" & repeatString(" ",508);//İşlem Tipi
								satir = yerles(satir,dateformat(islem_tarihi,'yyyy.mm.dd') & "." & timeformat(islem_tarihi,'hh.mm.ss'),4,19," ");//Tahsilat Başlangıç Tarihi (yyyy.mm.dd.hh.mm.ss)
								satir = yerles(satir,evaluate("attributes.card_number#i#"),23,19," ");//Kart No
								satir = yerles(satir,right(evaluate("attributes.ex_year#i#"),2),42,2," ");//Expire Date YYAA
								satir = yerles_saga(satir,evaluate("attributes.ex_month#i#"),44,2,"0");
								satir = yerles(satir,evaluate("attributes.cvs#i#"),46,3," ");//CVV
								satir = yerles(satir," ",49,26," ");//Kart no2 bilgileri
								satir = yerles_saga(satir,tutar,75,13,"0");//İşlem Tutarı
								satir = yerles(satir,"0",88,26,"0");//Bonus vs bilgileri boş set edildi
								satir = yerles(satir,"004",114,3," ");//Kur YTL
								satir = yerles(satir,"02",117,2," ");//Kur Hesap Tipi - garanti bankasi kuru
								satir = yerles_saga(satir,"0",119,13,"0");//Kur değeri
								satir = yerles(satir," ",132,6," ");//Provizyon No
								satir = yerles_saga(satir,"0",138,4,"0");//İşlem Sıra No
								satir = yerles(satir," ",142,309," ");//boş
								satir = yerles(satir,evaluate("attributes.payment_row#i#"),451,30," ");//ödeme planı satır id
								satir = yerles_saga(satir,evaluate("attributes.invoice_id#i#"),481,30," ");//invoice_id
								file_content[index_array] = "#satir#";
								index_array = index_array+1;
							</cfscript>
							<cfquery name="UPD_PAYMENT_ROWS" datasource="#DSN3#">
								UPDATE
									SUBSCRIPTION_PAYMENT_PLAN_ROW
								SET
									IS_COLLECTED_PROVISION = 1,
									UPDATE_DATE = #now()#,
									UPDATE_IP = '#cgi.remote_addr#',
									UPDATE_EMP = #session.ep.userid#
								WHERE
									INVOICE_ID = #evaluate("attributes.invoice_id#i#")# AND
								<cfif isDefined("attributes.prov_period") and len(attributes.prov_period)>
									PERIOD_ID = #ListGetAt(attributes.prov_period,3,";")#
								<cfelse>
									PERIOD_ID = #session.ep.period_id#
								</cfif>
							</cfquery>
								<cfoutput>#i#. Satıra Provizyon Oluşturuldu</cfoutput><br/>
						</cfif>
					</cfif>
				</cftransaction>
			</cflock>
			<cfcatch>
				<cfoutput>#i#. Satıra Provizyon Oluşturulamadı</cfoutput><br/>
			</cfcatch> 
		</cftry>
	</cfloop>
<cfelseif attributes.bank_name eq 2><!---HSBC  Belge Formatı--->
	<cfquery name="GET_FILE_KONTROL" datasource="#dsn2#">
		SELECT
			TARGET_SYSTEM
		FROM
			FILE_EXPORTS
		WHERE
			YEAR(RECORD_DATE) = #year(now())# AND
			MONTH(RECORD_DATE) = #month(now())# AND
			DAY(RECORD_DATE) = #day(now())# AND
			TARGET_SYSTEM = 2
	</cfquery>
	<cfif GET_FILE_KONTROL.recordcount gt 8>
		<script type="text/javascript">
			alert("<cf_get_lang no ='415.Günlük Dosya Oluşturma Sayısı En Fazla 9 dur'>!");
			history.back();
		</script>
		<cfabort>
	<cfelseif GET_FILE_KONTROL.recordcount>
		<cfset dosya_sayisi = GET_FILE_KONTROL.recordcount>
	<cfelse>
		<cfset dosya_sayisi = 0>
	</cfif>
	<cfscript>
		tarih_farki = datediff('d','1/1/#year(islem_tarihi)#',islem_tarihi);
		header = "HEADERD072400000000016PRN" & right(dateformat(islem_tarihi,dateformat_style),2) & repeatString("0",3-len(tarih_farki)) & tarih_farki & "#dosya_sayisi + 1#" & "000123";
		file_content[index_array] = "#header#";
		index_array = index_array+1;
	</cfscript>
	<cfloop from="1" to="#attributes.all_records#" index="i">
		<cftry>
			<cflock name="#CreateUUID()#" timeout="20">
				<cftransaction>
					<cfif isdefined("attributes.payment_row#i#") and len(evaluate("attributes.cvs#i#"))>
						<cfquery name="GET_PROV_INFO" datasource="#DSN3#"><!--- aynı anda yapılan işlemlerin kontrolu --->
							SELECT
								IS_COLLECTED_PROVISION
							FROM
								SUBSCRIPTION_PAYMENT_PLAN_ROW
							WHERE
								INVOICE_ID = #evaluate("attributes.invoice_id#i#")# AND
							<cfif isDefined("attributes.prov_period") and len(attributes.prov_period)>
								PERIOD_ID = #ListGetAt(attributes.prov_period,3,";")#
							<cfelse>
								PERIOD_ID = #session.ep.period_id#
							</cfif>
						</cfquery>
						<cfif GET_PROV_INFO.IS_COLLECTED_PROVISION eq 0>
							<cfscript>
								satir = "";
								tutar = evaluate("attributes.nettotal#i#");
								if(int(tutar) eq tutar)tutar = tutar & "00";
								else if((int(tutar * 10)) eq (tutar * 10))tutar = (tutar*10) & "0";
								else tutar = tutar * 100;
								id_info = evaluate("attributes.invoice_id#i#")&"."&evaluate("attributes.payment_row#i#");//yerles 2 den basladıgı icin ilk elemanlar sabit yazıldı
								satir = satir & id_info & repeatString(" ",40-len(id_info)) & repeatString(" ",218);//invoice_id . ödeme planı satır id 
								satir = yerles(satir,dateformat(islem_tarihi,'yyyymmdd'),41,8," ");//IslemTarihi YYYYMMDD
								satir = yerles(satir,"949",49,3," ");//IslemCurrencyCode - YTL
								satir = yerles_saga(satir,tutar,52,15,"0");//IslemTutar
								satir = yerles(satir," ",67,3," ");//BillingCurrencyCode
								satir = yerles(satir,"0",70,15,"0");//BillingTutar			//Boş set edildi
								satir = yerles(satir," ",85,14," ");//BINLength & BIN
								satir = yerles(satir,len(evaluate("attributes.card_number#i#")),99,2," ");//KartNoLength
								satir = yerles(satir,evaluate("attributes.card_number#i#"),101,19," ");//KartNo
								satir = yerles(satir,right(evaluate("attributes.ex_year#i#"),2),120,2," ");//KartExpDate YYAA
								satir = yerles_saga(satir,evaluate("attributes.ex_month#i#"),122,2,"0");//KartExpDate
								satir = yerles(satir,evaluate("attributes.cvs#i#"),124,3," ");//CVV
								satir = yerles(satir," ",127,50," ");//Diğer kart bilgileri  Boş set edildi
								satir = yerles(satir,"5969",177,4," ");//MCC Üye Kategori Kodu
								satir = yerles(satir,"PC002456",181,8," ");//TermID Kayıt girişinin yapıldığı terminal ID     !!!!sorulck
								satir = yerles(satir," ",189,65," ");//Boşluk
								satir = yerles(satir,"01",254,2," ");//MaxDenemeGunSayısı
								satir = yerles(satir,"01",256,2," ");//MaxDenemeGunSayısı alınamadığında
								toplam = toplam + tutar;//trailerda toplam tutar bilgisi için
								kayit_sayisi = kayit_sayisi + 1;//trailerda seçili satırların toplamı için
								file_content[index_array] = "#satir#";
								index_array = index_array+1;
							</cfscript>
							<cfquery name="UPD_PAYMENT_ROWS" datasource="#dsn3#">
								UPDATE
									SUBSCRIPTION_PAYMENT_PLAN_ROW
								SET
									IS_COLLECTED_PROVISION = 1,
									UPDATE_DATE = #now()#,
									UPDATE_IP = '#cgi.remote_addr#',
									UPDATE_EMP = #session.ep.userid#
								WHERE
									INVOICE_ID = #evaluate("attributes.invoice_id#i#")# AND
								<cfif isDefined("attributes.prov_period") and len(attributes.prov_period)>
									PERIOD_ID = #ListGetAt(attributes.prov_period,3,";")#
								<cfelse>
									PERIOD_ID = #session.ep.period_id#
								</cfif>
							</cfquery>
							<cfoutput>#i#. Satıra Provizyon Oluşturuldu</cfoutput><br/>
						</cfif>
					</cfif>
				</cftransaction>
			</cflock>
			<cfcatch>
				<cfoutput>#i#. Satıra Provizyon Oluşturulamadı</cfoutput><br/>
			</cfcatch> 
		</cftry>
	</cfloop>
	<cfscript>
		trailer = "TRAILER" & repeatString("0",15-len(kayit_sayisi)) & kayit_sayisi & repeatString("0",15-len(toplam)) & replace(toplam,".","",'All');
		file_content[index_array] = "#trailer#";
		index_array = index_array+1;
	</cfscript>
<cfelseif attributes.bank_name eq 3><!---Garanti TPOS--->
	<cfscript>
		header = "560" & repeatString("0",79) & CRLF 
		& "520" & left(dateformat(islem_tarihi,'ddmmyyyy'),4) & "00689344945599999000100010000949" & repeatString("0",43) & CRLF
		& "530" & repeatString("0",79);
		file_content[index_array] = "#header#";
		index_array = index_array+1;
	</cfscript>
	<cfloop from="1" to="#attributes.all_records#" index="i">
		<cftry>
			<cflock name="#CreateUUID()#" timeout="20">
				<cftransaction>
					<cfif isdefined("attributes.payment_row#i#")>
						<cfquery name="GET_PROV_INFO" datasource="#DSN3#"><!--- aynı anda yapılan işlemlerin kontrolu --->
							SELECT
								IS_COLLECTED_PROVISION
							FROM
								SUBSCRIPTION_PAYMENT_PLAN_ROW
							WHERE
								INVOICE_ID = #evaluate("attributes.invoice_id#i#")# AND
							<cfif isDefined("attributes.prov_period") and len(attributes.prov_period)>
								PERIOD_ID = #ListGetAt(attributes.prov_period,3,";")#
							<cfelse>
								PERIOD_ID = #session.ep.period_id#
							</cfif>
						</cfquery>
						<cfif GET_PROV_INFO.IS_COLLECTED_PROVISION eq 0>
							<cfscript>
								satir = "";
								tutar = evaluate("attributes.nettotal#i#");
								if(int(tutar) eq tutar)tutar = tutar & "00";
								else if((int(tutar * 10)) eq (tutar * 10))tutar = (tutar*10) & "0";
								else tutar = tutar * 100;
								satir = satir & "545" & repeatString(" ",107);//Kayıt Tipi
								satir = yerles(satir,"0001",4,4," ");//Filler1
								satir = yerles(satir,right(evaluate("attributes.ex_year#i#"),2),8,2," ");//Expire Date YY
								satir = yerles_saga(satir,evaluate("attributes.ex_month#i#"),10,2,"0");//Expire Date AA
								satir = yerles(satir,left(dateformat(islem_tarihi,'ddmmyyyy'),4),12,4," ");//İşlem Tarihi GGYY
								satir = yerles(satir,evaluate("attributes.card_number#i#"),16,19," ");//KartNo
								satir = yerles(satir," ",35,3," ");//Cvc2
								satir = yerles(satir,"T",38,1," ");//Filler2
								satir = yerles(satir,"Q",39,1," ");//Filler3
								satir = yerles_saga(satir,tutar,40,13,"0");//Tutar
								satir = yerles(satir," ",53,2," ");//Filler4
								satir = yerles(satir," ",55,6," ");//Provizyon Numarası
								satir = yerles_saga(satir,index_array-1,61,4,"0");//İşlem Sıra No
								satir = yerles(satir,"0",65,4,"0");//İşlem Zamanı
								satir = yerles(satir," ",69,21," ");//İşlem Zamanı
								satir = yerles_saga(satir,evaluate("attributes.payment_row#i#"),90,10," ");//ödeme planı satır id
								satir = yerles_saga(satir,evaluate("attributes.invoice_id#i#"),100,10," ");//invoice_id
								file_content[index_array] = "#satir#";
								index_array = index_array+1;
							</cfscript>
							<cfquery name="UPD_PAYMENT_ROWS" datasource="#dsn3#">
								UPDATE
									SUBSCRIPTION_PAYMENT_PLAN_ROW
								SET
									IS_COLLECTED_PROVISION = 1,
									UPDATE_DATE = #now()#,
									UPDATE_IP = '#cgi.remote_addr#',
									UPDATE_EMP = #session.ep.userid#
								WHERE
									INVOICE_ID = #evaluate("attributes.invoice_id#i#")# AND

								<cfif isDefined("attributes.prov_period") and len(attributes.prov_period)>
									PERIOD_ID = #ListGetAt(attributes.prov_period,3,";")#
								<cfelse>
									PERIOD_ID = #session.ep.period_id#
								</cfif>
							</cfquery>
							<cfoutput>#i#. Satıra Provizyon Oluşturuldu</cfoutput><br/>
						</cfif>
					</cfif>
				</cftransaction>
			</cflock>
			<cfcatch>
				<cfoutput>#i#. Satıra Provizyon Oluşturulamadı</cfoutput><br/>
			</cfcatch> 
		</cftry>
	</cfloop>
	<cfscript>
		trailer = "550" & repeatString("0",79) & CRLF & "570" & repeatString("0",79);
		file_content[index_array] = "#trailer#";
		index_array = index_array+1;
	</cfscript>
<cfelseif attributes.bank_name eq 4><!---TEB--->
	<cfscript>
		header = "H" & dateformat(islem_tarihi,'yyyymmdd');
		file_content[index_array] = "#header#";
		index_array = index_array+1;
	</cfscript>
	<cfloop from="1" to="#attributes.all_records#" index="i">
		<cftry>
			<cflock name="#CreateUUID()#" timeout="20">
				<cftransaction>
					<cfif isdefined("attributes.payment_row#i#")>
						<cfquery name="GET_PROV_INFO" datasource="#DSN3#"><!--- aynı anda yapılan işlemlerin kontrolu --->
							SELECT
								IS_COLLECTED_PROVISION
							FROM
								SUBSCRIPTION_PAYMENT_PLAN_ROW
							WHERE
								INVOICE_ID = #evaluate("attributes.invoice_id#i#")# AND
							<cfif isDefined("attributes.prov_period") and len(attributes.prov_period)>
								PERIOD_ID = #ListGetAt(attributes.prov_period,3,";")#
							<cfelse>
								PERIOD_ID = #session.ep.period_id#
							</cfif>
						</cfquery>
						<cfif GET_PROV_INFO.IS_COLLECTED_PROVISION eq 0>
							<cfscript>
								satir = "";
								tutar = evaluate("attributes.nettotal#i#");
								satir = satir & "DSA" & repeatString(" ",345);//Kayıt Tipi
								satir = yerles(satir,evaluate("attributes.card_number#i#"),4,19," ");//KartNo
								satir = yerles(satir,right(evaluate("attributes.ex_year#i#"),2),23,2," ");//Expire Date YY
								satir = yerles_saga(satir,evaluate("attributes.ex_month#i#"),25,2,"0");//Expire Date AA
								satir = yerles(satir," ",27,3," ");//CVV
								satir = yerles_saga(satir,NumberFormat(tutar,"00.00"),30,12,"0");//Tutar
								satir = yerles_saga(satir,evaluate("attributes.payment_row#i#"),42,20," ");//ödeme planı satır id
								satir = yerles_saga(satir,evaluate("attributes.invoice_id#i#"),62,255," ");//invoice_id
								satir = yerles(satir," ",317,1," ");//Onay / Red
								satir = yerles(satir," ",318,6," ");//Provizyon Kodu
								satir = yerles(satir," ",324,4," ");//BatchNo
								satir = yerles(satir," ",328,6," ");//BatchIsNo
								satir = yerles(satir," ",334,14," ");//IslemTarihi
								toplam = toplam + tutar;//trailerda toplam tutar bilgisi için
								kayit_sayisi = kayit_sayisi + 1;//trailerda seçili satırların toplamı için
								file_content[index_array] = "#satir#";
								index_array = index_array+1;
							</cfscript>
							<cfquery name="UPD_PAYMENT_ROWS" datasource="#dsn3#">
								UPDATE
									SUBSCRIPTION_PAYMENT_PLAN_ROW
								SET
									IS_COLLECTED_PROVISION = 1,
									UPDATE_DATE = #now()#,
									UPDATE_IP = '#cgi.remote_addr#',
									UPDATE_EMP = #session.ep.userid#
								WHERE
									INVOICE_ID = #evaluate("attributes.invoice_id#i#")# AND
								<cfif isDefined("attributes.prov_period") and len(attributes.prov_period)>
									PERIOD_ID = #ListGetAt(attributes.prov_period,3,";")#
								<cfelse>
									PERIOD_ID = #session.ep.period_id#
								</cfif>
							</cfquery>
							<cfoutput>#i#. Satıra Provizyon Oluşturuldu</cfoutput><br/>
						</cfif>
					</cfif>
				</cftransaction>
			</cflock>
			<cfcatch>
				<cfoutput>#i#. Satıra Provizyon Oluşturulamadı</cfoutput><br/>
			</cfcatch> 
		</cftry>
	</cfloop>
	<cfscript>
		trailer = "T" & repeatString("0",12-len(kayit_sayisi)) & kayit_sayisi & repeatString("0",20-len(toplam)) & toplam;
		file_content[index_array] = "#trailer#";
		index_array = index_array+1;
	</cfscript>
<cfelseif attributes.bank_name eq 5><!---İşBankası--->
	<cfquery name="GET_FILE_KONTROL" datasource="#dsn2#">
		SELECT
			TARGET_SYSTEM
		FROM
			FILE_EXPORTS
		WHERE
			YEAR(RECORD_DATE) = #year(now())# AND
			MONTH(RECORD_DATE) = #month(now())# AND
			DAY(RECORD_DATE) = #day(now())# AND
			TARGET_SYSTEM = 5
	</cfquery>
	<cfscript>
		if(isDefined("attributes.comp_code_info") and len(attributes.comp_code_info))//işyeri kodu bilgisi
		{
			comp_code_info = left(attributes.comp_code_info,9);
			term_code_info = '033715090';
		}
		else
		{
			comp_code_info = '334344017';
			term_code_info = '060633990';
		}
		header = "I" & "#comp_code_info#" & "#term_code_info#" & dateformat(islem_tarihi,'ddmmyyyy') & repeatString("0",3-len(GET_FILE_KONTROL.recordcount+1)) & GET_FILE_KONTROL.recordcount+1 & repeatString(" ",4);
		file_content[index_array] = "#header#";
		index_array = index_array+1;
	</cfscript>
	<cfif not isDefined("attributes.is_detailed")>
		<cfif isDefined("attributes.prov_period") and len(attributes.prov_period)>
			<cfset new_dsn2 = '#dsn#_#ListGetAt(attributes.prov_period,1,";")#_#ListGetAt(attributes.prov_period,2,";")#'>
			<cfset period_id = ListGetAt(attributes.prov_period,3,";")>
		<cfelse>
			<cfset new_dsn2 = '#dsn2#'>
			<cfset period_id = session.ep.period_id>
		</cfif>
		<cfquery name="GET_PAYMENT_PLAN" datasource="#dsn3#">
			SELECT
				SPR.*,
				SC.SUBSCRIPTION_NO,
				SC.SUBSCRIPTION_ID,
				SC.MEMBER_CC_ID,
				COMP_CC.COMPANY_CC_NUMBER CC_NUMBER,
				COMP_CC.COMP_CVS CVS,
				COMP_CC.COMPANY_EX_MONTH EX_MONTH,
				COMP_CC.COMPANY_EX_YEAR EX_YEAR,
				COMP_CC.COMPANY_ID MEMBER_ID,
				COMPANY.NICKNAME MEMBER_NAME,
				0 MEMBER_TYPE,
				I.NETTOTAL,
				I.INVOICE_ID INVOICE_ID,
				I.INVOICE_NUMBER,
				CARD_PAYM.CARD_NO
			FROM
				SUBSCRIPTION_PAYMENT_PLAN_ROW SPR,
				SUBSCRIPTION_CONTRACT SC,
				#dsn_alias#.COMPANY_CC COMP_CC,
				#dsn_alias#.COMPANY COMPANY,
				#new_dsn2#.INVOICE I,
				CREDITCARD_PAYMENT_TYPE CARD_PAYM
			WHERE
				SPR.SUBSCRIPTION_ID = SC.SUBSCRIPTION_ID AND
				SC.INVOICE_COMPANY_ID = COMP_CC.COMPANY_ID AND
				SC.INVOICE_COMPANY_ID = COMPANY.COMPANY_ID AND
				COMPANY.COMPANY_ID = COMP_CC.COMPANY_ID AND
				SC.MEMBER_CC_ID = COMP_CC.COMPANY_CC_ID AND
				I.INVOICE_ID = SPR.INVOICE_ID AND
				CARD_PAYM.PAYMENT_TYPE_ID = SPR.CARD_PAYMETHOD_ID AND
				SPR.PAYMENT_DATE BETWEEN #attributes.start_date# AND #attributes.finish_date# AND
				<cfif len(attributes.pay_method)>
					SPR.CARD_PAYMETHOD_ID = #attributes.pay_method# AND<!---ödeme yöntemi--->
				</cfif>
				SPR.PERIOD_ID = #period_id# AND
				SPR.IS_BILLED = 1 AND<!--- faturalandı --->
				SPR.IS_PAID = 0 AND<!--- ödenmedi --->
				SPR.IS_COLLECTED_PROVISION = 0 AND<!--- toplu provizyon oluşturulmadı --->
				SPR.IS_ACTIVE = 1 AND<!--- aktif satırlar --->
				I.NETTOTAL > 0 AND
				I.IS_IPTAL = 0
				<cfif len(attributes.company) and len(attributes.company_id)>
					AND SC.INVOICE_COMPANY_ID =	#attributes.company_id#
				</cfif>
				<cfif len(attributes.company) and len(attributes.consumer_id)>
					AND SC.INVOICE_CONSUMER_ID = #attributes.consumer_id#
				</cfif>
				<cfif isdefined("attributes.subscription_id") and len(attributes.subscription_id) and len(attributes.subscription_no)>
					AND SC.SUBSCRIPTION_ID = #attributes.subscription_id#
				</cfif>
				<cfif isDefined("attributes.setup_bank_type") and len(attributes.setup_bank_type)>
					AND COMP_CC.COMPANY_BANK_TYPE IN (#attributes.setup_bank_type#)
				</cfif>
				<cfif isDefined("attributes.is_cvv")>
					AND COMP_CC.COMP_CVS IS NOT NULL
				</cfif>
				<cfif len(attributes.year_info) and len(attributes.month_info)>
					AND (
							(COMP_CC.COMPANY_EX_MONTH >= #attributes.month_info# AND COMP_CC.COMPANY_EX_YEAR = #attributes.year_info#)
							 OR 
							(COMP_CC.COMPANY_EX_YEAR > #attributes.year_info# AND COMP_CC.COMPANY_EX_MONTH >= #attributes.month_info#)
							 OR
							(COMP_CC.COMPANY_EX_YEAR > #attributes.year_info#)			    
						)
				</cfif>
				<cfif len(attributes.contract_start) and len(attributes.contract_finish)>
					AND SPR.SUBSCRIPTION_ID IN (SELECT SUBSCRIPTION_ID FROM SUBSCRIPTION_PAYMENT_PLAN_ROW <cfif isDefined("xml_product_list") and len(xml_product_list)>WHERE PRODUCT_ID IN (#xml_product_list#)</cfif> GROUP BY SUBSCRIPTION_ID HAVING MIN(PAYMENT_DATE) BETWEEN #attributes.contract_start# AND #attributes.contract_finish#)
				<cfelseif len(attributes.contract_start)>
					AND SPR.SUBSCRIPTION_ID IN (SELECT SUBSCRIPTION_ID FROM SUBSCRIPTION_PAYMENT_PLAN_ROW <cfif isDefined("xml_product_list") and len(xml_product_list)>WHERE PRODUCT_ID IN (#xml_product_list#)</cfif> GROUP BY SUBSCRIPTION_ID HAVING MIN(PAYMENT_DATE) >= #attributes.contract_start#)
				<cfelseif len(attributes.contract_finish)>
					AND SPR.SUBSCRIPTION_ID IN (SELECT SUBSCRIPTION_ID FROM SUBSCRIPTION_PAYMENT_PLAN_ROW <cfif isDefined("xml_product_list") and len(xml_product_list)>WHERE PRODUCT_ID IN (#xml_product_list#)</cfif> GROUP BY SUBSCRIPTION_ID HAVING MIN(PAYMENT_DATE) <= #attributes.contract_finish#)
				</cfif>
		UNION ALL
			SELECT
				SPR.*,
				SC.SUBSCRIPTION_NO,
				SC.SUBSCRIPTION_ID,
				SC.MEMBER_CC_ID,
				CONS_CC.CONSUMER_CC_NUMBER CC_NUMBER,
				CONS_CC.CONS_CVS CVS,
				CONS_CC.CONSUMER_EX_MONTH EX_MONTH,
				CONS_CC.CONSUMER_EX_YEAR EX_YEAR,
				CONS_CC.CONSUMER_ID MEMBER_ID,
				CONSUMER.CONSUMER_NAME + ' ' + CONSUMER.CONSUMER_SURNAME MEMBER_NAME,
				1 MEMBER_TYPE,
				I.NETTOTAL,
				I.INVOICE_ID INVOICE_ID,
				I.INVOICE_NUMBER,
				CARD_PAYM.CARD_NO
			FROM
				SUBSCRIPTION_PAYMENT_PLAN_ROW SPR,
				SUBSCRIPTION_CONTRACT SC,
				#dsn_alias#.CONSUMER_CC CONS_CC,
				#dsn_alias#.CONSUMER CONSUMER,
				#new_dsn2#.INVOICE I,
				CREDITCARD_PAYMENT_TYPE CARD_PAYM
			WHERE
				SPR.SUBSCRIPTION_ID = SC.SUBSCRIPTION_ID AND
				SC.INVOICE_CONSUMER_ID = CONS_CC.CONSUMER_ID AND
				SC.INVOICE_CONSUMER_ID = CONSUMER.CONSUMER_ID AND
				CONSUMER.CONSUMER_ID = CONS_CC.CONSUMER_ID AND
				SC.MEMBER_CC_ID = CONS_CC.CONSUMER_CC_ID AND
				I.INVOICE_ID = SPR.INVOICE_ID AND
				CARD_PAYM.PAYMENT_TYPE_ID = SPR.CARD_PAYMETHOD_ID AND
				SPR.PAYMENT_DATE BETWEEN #attributes.start_date# AND #attributes.finish_date# AND
				<cfif len(attributes.pay_method)>
					SPR.CARD_PAYMETHOD_ID = #attributes.pay_method# AND<!---ödeme yöntemi--->
				</cfif>
				SPR.PERIOD_ID = #period_id# AND
				SPR.IS_BILLED = 1 AND<!--- faturalandı --->
				SPR.IS_PAID = 0 AND<!--- ödenmedi --->
				SPR.IS_COLLECTED_PROVISION = 0 AND<!--- toplu provizyon oluşturulmadı --->
				SPR.IS_ACTIVE = 1 AND<!--- aktif satırlar --->
				I.NETTOTAL > 0 AND
				I.IS_IPTAL = 0
				<cfif len(attributes.company) and len(attributes.company_id)>
					AND SC.INVOICE_COMPANY_ID =	#attributes.company_id#
				</cfif>
				<cfif len(attributes.company) and len(attributes.consumer_id)>
					AND SC.INVOICE_CONSUMER_ID = #attributes.consumer_id#
				</cfif>
				<cfif isdefined("attributes.subscription_id") and len(attributes.subscription_id) and len(attributes.subscription_no)>
					AND SC.SUBSCRIPTION_ID = #attributes.subscription_id#
				</cfif>
				<cfif isDefined("attributes.setup_bank_type") and len(attributes.setup_bank_type)>
					AND CONS_CC.CONSUMER_BANK_TYPE IN (#attributes.setup_bank_type#)
				</cfif>
				<cfif isDefined("attributes.is_cvv")>
					AND CONS_CC.CONS_CVS IS NOT NULL
				</cfif>
				<cfif len(attributes.year_info) and len(attributes.month_info)>
					AND (
							(CONS_CC.CONSUMER_EX_MONTH >= #attributes.month_info# AND CONS_CC.CONSUMER_EX_YEAR = #attributes.year_info#)
							 OR 
							(CONS_CC.CONSUMER_EX_YEAR > #attributes.year_info# AND CONS_CC.CONSUMER_EX_MONTH >= #attributes.month_info#)
							 OR
							(CONS_CC.CONSUMER_EX_YEAR > #attributes.year_info#)			    
						)
				</cfif>
				<cfif len(attributes.contract_start) and len(attributes.contract_finish)>
					AND SPR.SUBSCRIPTION_ID IN (SELECT SUBSCRIPTION_ID FROM SUBSCRIPTION_PAYMENT_PLAN_ROW <cfif isDefined("xml_product_list") and len(xml_product_list)>WHERE PRODUCT_ID IN (#xml_product_list#)</cfif> GROUP BY SUBSCRIPTION_ID HAVING MIN(PAYMENT_DATE) BETWEEN #attributes.contract_start# AND #attributes.contract_finish#)
				<cfelseif len(attributes.contract_start)>
					AND SPR.SUBSCRIPTION_ID IN (SELECT SUBSCRIPTION_ID FROM SUBSCRIPTION_PAYMENT_PLAN_ROW <cfif isDefined("xml_product_list") and len(xml_product_list)>WHERE PRODUCT_ID IN (#xml_product_list#)</cfif> GROUP BY SUBSCRIPTION_ID HAVING MIN(PAYMENT_DATE) >= #attributes.contract_start#)
				<cfelseif len(attributes.contract_finish)>
					AND SPR.SUBSCRIPTION_ID IN (SELECT SUBSCRIPTION_ID FROM SUBSCRIPTION_PAYMENT_PLAN_ROW <cfif isDefined("xml_product_list") and len(xml_product_list)>WHERE PRODUCT_ID IN (#xml_product_list#)</cfif> GROUP BY SUBSCRIPTION_ID HAVING MIN(PAYMENT_DATE) <= #attributes.contract_finish#)
				</cfif>
			ORDER BY
				I.INVOICE_ID<!--- provizyon sırası değiştirilmemeli!! AE--->
		</cfquery>
		<cfif GET_PAYMENT_PLAN.recordcount>
			<cfoutput query="GET_PAYMENT_PLAN" maxrows="#GET_PAYMENT_PLAN.recordcount/2#">
				<cftry>
				<cflock name="#CreateUUID()#" timeout="20">
					<cftransaction>
						<cfquery name="GET_PROV_INFO" datasource="#DSN3#"><!--- aynı anda yapılan işlemlerin kontrolu --->
							SELECT
								IS_COLLECTED_PROVISION
							FROM
								SUBSCRIPTION_PAYMENT_PLAN_ROW
							WHERE
								INVOICE_ID = #GET_PAYMENT_PLAN.INVOICE_ID# AND
							<cfif isDefined("attributes.prov_period") and len(attributes.prov_period)>
								PERIOD_ID = #ListGetAt(attributes.prov_period,3,";")#
							<cfelse>
								PERIOD_ID = #session.ep.period_id#
							</cfif>
						</cfquery>
						<cfif GET_PROV_INFO.IS_COLLECTED_PROVISION eq 0>
							<cfscript>
								satir = "";
								tutar = wrk_round(GET_PAYMENT_PLAN.NETTOTAL);
								if(int(tutar) eq tutar)tutar = tutar & "00";
								else if((int(tutar * 10)) eq (tutar * 10))tutar = (tutar*10) & "0";
								else tutar = tutar * 100;
								id_info = GET_PAYMENT_PLAN.INVOICE_ID&"."&GET_PAYMENT_PLAN.SUBSCRIPTION_PAYMENT_ROW_ID;
								satir = satir & repeatString("0",6-len(index_array-1)) & index_array-1 & repeatString(" ",185);//İŞLEM SIRA NO
								satir = yerles(satir,"S",7,1," ");//İŞLEM TİPİ.
								
								/* FA-09102013 kredi kartı Gelişmiş şifreleme standartları ile şifrelenmesi. 
									Bu sistemin çalışması için sistem/güvenlik altında kredi kartı şifreleme anahtarlırının tanımlanması gerekmektedir */
								getCCNOKey = createObject("component", "V16.settings.cfc.setupCcnoKey");
								getCCNOKey.dsn = dsn;
								getCCNOKey1 = getCCNOKey.getCCNOKey1();
								getCCNOKey2 = getCCNOKey.getCCNOKey2();
								if (getCCNOKey1.recordcount and getCCNOKey2.recordcount)
								{
									// anahtarlar decode ediliyor 
									ccno_key1 = contentEncryptingandDecodingAES(isEncode:0,accountKey:getCCNOKey1.record_emp,content:getCCNOKey1.ccnokey);
									ccno_key2 = contentEncryptingandDecodingAES(isEncode:0,accountKey:getCCNOKey2.record_emp,content:getCCNOKey2.ccnokey);
									// kart no encode ediliyor
									card_number_ = contentEncryptingandDecodingAES(isEncode:0,content:GET_PAYMENT_PLAN.CC_NUMBER,accountKey:GET_PAYMENT_PLAN.MEMBER_ID,key1:ccno_key1,key2:ccno_key2);
								}
								else
									card_number_ = Decrypt(GET_PAYMENT_PLAN.CC_NUMBER,GET_PAYMENT_PLAN.MEMBER_ID,"CFMX_COMPAT","Hex");
								
								satir = yerles(satir,card_number_,8,16,"0");//KART NUMARASI
								satir = yerles_saga(satir,tutar,24,15,"0");//İŞLEM TUTARI
								satir = yerles(satir,dateformat(islem_tarihi,'ddmmyyyy'),39,8," ");//IslemTarihi GGAAYYYY
								satir = yerles_saga(satir,GET_PAYMENT_PLAN.EX_MONTH,47,2,"0");//KartExpDate
								satir = yerles(satir,right(GET_PAYMENT_PLAN.EX_YEAR,2),49,2," ");//KartExpDate AAYY
								satir = yerles(satir,"TRY",51,3," ");//PARA BİRİMİ
								satir = yerles(satir," ",54,30," ");//KART SAHİBİN ADI SOYADI
								satir = yerles(satir," ",84,8," ");//ORJİNAL İŞLEM TARİHİ 
								satir = yerles(satir,"0",92,6,"0");//ORJİNAL İŞLEM SIRA NO
								satir = yerles(satir," ",98,35," ");//ödeme planı satır id
								satir = yerles(satir,id_info,133,30," ");//invoice_id
								satir = yerles(satir,GET_PAYMENT_PLAN.CVS,163,3,"0");//CVV
								satir = yerles(satir,"N",166,1," ");//MAXI PUAN VER/VERME
								satir = yerles(satir,"00",167,2," ");//TAKSİT SAYISI
								satir = yerles_saga(satir," ",169,22," ");//ödeme planı satır id
								toplam = toplam + tutar;//trailerda toplam tutar bilgisi için
								kayit_sayisi = kayit_sayisi + 1;//trailerda seçili satırların toplamı için
								file_content[index_array] = "#satir#";
								index_array = index_array+1;
							</cfscript>
							<cfquery name="UPD_PAYMENT_ROWS" datasource="#dsn3#">
								UPDATE
									SUBSCRIPTION_PAYMENT_PLAN_ROW
								SET
									IS_COLLECTED_PROVISION = 1,
									UPDATE_DATE = #now()#,
									UPDATE_IP = '#cgi.remote_addr#',
									UPDATE_EMP = #session.ep.userid#
								WHERE
									INVOICE_ID = #GET_PAYMENT_PLAN.INVOICE_ID# AND
								<cfif isDefined("attributes.prov_period") and len(attributes.prov_period)>
									PERIOD_ID = #ListGetAt(attributes.prov_period,3,";")#
								<cfelse>
									PERIOD_ID = #session.ep.period_id#
								</cfif>
							</cfquery>
							#currentrow#. Satıra Provizyon Oluşturuldu<br/>
						</cfif>
					</cftransaction>
				</cflock>
				<cfcatch>
					#currentrow#. Satıra Provizyon Oluşturulamadı<br/>
				</cfcatch> 
			</cftry>
			</cfoutput>
		</cfif>
	<cfelse>
		<cfloop from="1" to="#attributes.all_records#" index="i">
		<cftry>
			<cflock name="#CreateUUID()#" timeout="20">
				<cftransaction>
					<cfif isdefined("attributes.payment_row#i#")>
						<cfquery name="GET_PROV_INFO" datasource="#DSN3#"><!--- aynı anda yapılan işlemlerin kontrolu --->
							SELECT
								IS_COLLECTED_PROVISION
							FROM
								SUBSCRIPTION_PAYMENT_PLAN_ROW
							WHERE
								INVOICE_ID = #evaluate("attributes.invoice_id#i#")# AND
							<cfif isDefined("attributes.prov_period") and len(attributes.prov_period)>
								PERIOD_ID = #ListGetAt(attributes.prov_period,3,";")#
							<cfelse>
								PERIOD_ID = #session.ep.period_id#
							</cfif>
						</cfquery>
						<cfif GET_PROV_INFO.IS_COLLECTED_PROVISION eq 0>
							<cfscript>
								satir = "";
								tutar = evaluate("attributes.nettotal#i#");
								if(int(tutar) eq tutar)tutar = tutar & "00";
								else if((int(tutar * 10)) eq (tutar * 10))tutar = (tutar*10) & "0";
								else tutar = tutar * 100;
								id_info = evaluate("attributes.invoice_id#i#")&"."&evaluate("attributes.payment_row#i#");
								satir = satir & repeatString("0",6-len(index_array-1)) & index_array-1 & repeatString(" ",185);//İŞLEM SIRA NO
								satir = yerles(satir,"S",7,1," ");//İŞLEM TİPİ.
								satir = yerles(satir,evaluate("attributes.card_number#i#"),8,16,"0");//KART NUMARASI
								satir = yerles_saga(satir,tutar,24,15,"0");//İŞLEM TUTARI
								satir = yerles(satir,dateformat(islem_tarihi,'ddmmyyyy'),39,8," ");//IslemTarihi GGAAYYYY
								satir = yerles_saga(satir,evaluate("attributes.ex_month#i#"),47,2,"0");//KartExpDate
								satir = yerles(satir,right(evaluate("attributes.ex_year#i#"),2),49,2," ");//KartExpDate AAYY
								satir = yerles(satir,"TRY",51,3," ");//PARA BİRİMİ
								satir = yerles(satir," ",54,30," ");//KART SAHİBİN ADI SOYADI
								satir = yerles(satir," ",84,8," ");//ORJİNAL İŞLEM TARİHİ 
								satir = yerles(satir,"0",92,6,"0");//ORJİNAL İŞLEM SIRA NO
								satir = yerles(satir," ",98,35," ");//ödeme planı satır id
								satir = yerles(satir,id_info,133,30," ");//invoice_id
								satir = yerles(satir,evaluate("attributes.cvs#i#"),163,3,"0");//CVV
								satir = yerles(satir,"N",166,1," ");//MAXI PUAN VER/VERME
								satir = yerles(satir,"00",167,2," ");//TAKSİT SAYISI
								satir = yerles_saga(satir," ",169,22," ");//ödeme planı satır id
								toplam = toplam + tutar;//trailerda toplam tutar bilgisi için
								kayit_sayisi = kayit_sayisi + 1;//trailerda seçili satırların toplamı için
								file_content[index_array] = "#satir#";
								index_array = index_array+1;
							</cfscript>
							<cfquery name="UPD_PAYMENT_ROWS" datasource="#dsn3#">
								UPDATE
									SUBSCRIPTION_PAYMENT_PLAN_ROW
								SET
									IS_COLLECTED_PROVISION = 1,
									UPDATE_DATE = #now()#,
									UPDATE_IP = '#cgi.remote_addr#',
									UPDATE_EMP = #session.ep.userid#
								WHERE
									INVOICE_ID = #evaluate("attributes.invoice_id#i#")# AND
								<cfif isDefined("attributes.prov_period") and len(attributes.prov_period)>
									PERIOD_ID = #ListGetAt(attributes.prov_period,3,";")#
								<cfelse>
									PERIOD_ID = #session.ep.period_id#
								</cfif>
							</cfquery>
							<cfoutput>#i#. Satıra Provizyon Oluşturuldu</cfoutput><br/>
						</cfif>
					</cfif>
				</cftransaction>
			</cflock>
			<cfcatch>
				<cfoutput>#i#. Satıra Provizyon Oluşturulamadı</cfoutput><br/>
			</cfcatch> 
		</cftry>
	</cfloop>
	</cfif>
	<cfscript>
		trailer = "T" & "#comp_code_info#" & repeatString("0",9-len(kayit_sayisi)) & kayit_sayisi & repeatString("0",18-len(replace(toplam,".","",'All'))) & replace(toplam,".","",'All') & repeatString("0",81) & repeatString(" ",72);
		file_content[index_array] = "#trailer#";
		index_array = index_array+1;
	</cfscript>
<cfelseif attributes.bank_name eq 6><!---YKB--->
	<cfquery name="GET_FILE_KONTROL" datasource="#dsn2#">
		SELECT
			TARGET_SYSTEM
		FROM
			FILE_EXPORTS
		WHERE
			YEAR(RECORD_DATE) = #year(now())# AND
			MONTH(RECORD_DATE) = #month(now())# AND
			DAY(RECORD_DATE) = #day(now())# AND
			TARGET_SYSTEM = 5
	</cfquery>
	<cfscript>
		tarih_farki = datediff('d','1/1/#year(islem_tarihi)#',islem_tarihi);
		header = right(dateformat(islem_tarihi,dateformat_style),2) & repeatString("0",3-len(tarih_farki)) & tarih_farki & "000000000000000" & repeatString("0",2-len(GET_FILE_KONTROL.recordcount+1)) & GET_FILE_KONTROL.recordcount+1 & repeatString(" ",50) & "AAAAAAAAA" & "BBBBBBBBBBBBBBB" & "YTL" & repeatString("0",71);
		file_content[index_array] = "#header#";
		index_array = index_array+1;
	</cfscript>
	<cfloop from="1" to="#attributes.all_records#" index="i">
		<cftry>
			<cflock name="#CreateUUID()#" timeout="20">
				<cftransaction>
					<cfif isdefined("attributes.payment_row#i#")>
						<cfquery name="GET_PROV_INFO" datasource="#DSN3#"><!--- aynı anda yapılan işlemlerin kontrolu --->
							SELECT
								IS_COLLECTED_PROVISION
							FROM
								SUBSCRIPTION_PAYMENT_PLAN_ROW
							WHERE
								INVOICE_ID = #evaluate("attributes.invoice_id#i#")# AND
							<cfif isDefined("attributes.prov_period") and len(attributes.prov_period)>
								PERIOD_ID = #ListGetAt(attributes.prov_period,3,";")#
							<cfelse>
								PERIOD_ID = #session.ep.period_id#
							</cfif>
						</cfquery>
						<cfif GET_PROV_INFO.IS_COLLECTED_PROVISION eq 0>
							<cfscript>
								satir = "";
								tutar = evaluate("attributes.nettotal#i#");
								if(int(tutar) eq tutar)tutar = tutar & "00";
								else if((int(tutar * 10)) eq (tutar * 10))tutar = (tutar*10) & "0";
								else tutar = tutar * 100;
								id_info = evaluate("attributes.invoice_id#i#")&"."&evaluate("attributes.payment_row#i#");
								satir = satir & evaluate("attributes.card_number#i#") & repeatString(" ",19-len(evaluate("attributes.card_number#i#"))) & repeatString(" ",152);//KART NUMARASI
								satir = yerles(satir,evaluate("attributes.cvs#i#"),20,3,"0");//CVV
								satir = yerles(satir,right(evaluate("attributes.ex_year#i#"),2),23,2," ");//KartExpDate YYAA
								satir = yerles_saga(satir,evaluate("attributes.ex_month#i#"),25,2,"0");//KartExpDate
								satir = yerles_saga(satir,NumberFormat(tutar,"00.00"),27,15,"0");//Tutar
								satir = yerles(satir," ",42,35," ");//KART SAHİBİN ADI SOYADI
								satir = yerles(satir,id_info,77,74," ");//invoice_id-prov_id
								satir = yerles(satir,"00",151,2," ");//TAKSİT SAYISI
								satir = yerles(satir," ",153,10," ");//ÜİY Numarası
								satir = yerles(satir," ",163,8," ");//Boş Alan
								toplam = toplam + tutar;//trailerda toplam tutar bilgisi için
								kayit_sayisi = kayit_sayisi + 1;//trailerda seçili satırların toplamı için
								file_content[index_array] = "#satir#";
								index_array = index_array+1;
							</cfscript>
							<cfquery name="UPD_PAYMENT_ROWS" datasource="#dsn3#">
								UPDATE
									SUBSCRIPTION_PAYMENT_PLAN_ROW
								SET
									IS_COLLECTED_PROVISION = 1,
									UPDATE_DATE = #now()#,
									UPDATE_IP = '#cgi.remote_addr#',
									UPDATE_EMP = #session.ep.userid#
								WHERE
									INVOICE_ID = #evaluate("attributes.invoice_id#i#")# AND
								<cfif isDefined("attributes.prov_period") and len(attributes.prov_period)>
									PERIOD_ID = #ListGetAt(attributes.prov_period,3,";")#
								<cfelse>
									PERIOD_ID = #session.ep.period_id#
								</cfif>
							</cfquery>
							<cfoutput>#i#. Satıra Provizyon Oluşturuldu</cfoutput><br/>
						</cfif>
					</cfif>
				</cftransaction>
			</cflock>
			<cfcatch>
				<cfoutput>#i#. Satıra Provizyon Oluşturulamadı</cfoutput><br/>
			</cfcatch> 
		</cftry>
	</cfloop>
	<cfscript>//burası yeniden düzenlenecek!!!! Aysenur20070823
		file_content_first[1] = replace(ArraytoList(file_content,CRLF),"AAAAAAAAA",repeatString("0",9-len(kayit_sayisi)) & kayit_sayisi,'All');
		file_content_last = replace(ArraytoList(file_content_first,CRLF),"BBBBBBBBBBBBBBB",repeatString("0",15-len(toplam)) & toplam,'All');
		file_content_main[index_array] = "#file_content_last#";
		file_content = file_content_main;
		index_array = index_array+1;
	</cfscript>
<cfelseif attributes.bank_name eq 7><!---Akbank--->
	<cfloop from="1" to="#attributes.all_records#" index="i">
		<cftry>
			<cflock name="#CreateUUID()#" timeout="20">
				<cftransaction>
					<cfif isdefined("attributes.payment_row#i#")>
						<cfquery name="GET_PROV_INFO" datasource="#DSN3#"><!--- aynı anda yapılan işlemlerin kontrolu --->
							SELECT
								IS_COLLECTED_PROVISION
							FROM
								SUBSCRIPTION_PAYMENT_PLAN_ROW
							WHERE
								INVOICE_ID = #evaluate("attributes.invoice_id#i#")# AND
							<cfif isDefined("attributes.prov_period") and len(attributes.prov_period)>
								PERIOD_ID = #ListGetAt(attributes.prov_period,3,";")#
							<cfelse>
								PERIOD_ID = #session.ep.period_id#
							</cfif>
						</cfquery>
						<cfif GET_PROV_INFO.IS_COLLECTED_PROVISION eq 0>
							<cfscript>
								satir = "";
								tutar = evaluate("attributes.nettotal#i#");
								if(int(tutar) eq tutar)tutar = tutar & "00";
								else if((int(tutar * 10)) eq (tutar * 10))tutar = (tutar*10) & "0";
								else tutar = tutar * 100;
								satir = satir & "001" & repeatString(" ",642);//işlem tipi
								satir = yerles(satir,dateformat(now(),'yyyy.mm.dd') & '.' & timeformat(now(),"hh.mm.ss"),4,19," ");//Tahsilat Başlangıç Tarihi
								satir = yerles(satir,evaluate("attributes.card_number#i#"),23,19," ");//KART NUMARASI
								satir = yerles_saga(satir,evaluate("attributes.ex_month#i#"),42,2,"0");//KartExpDate
								satir = yerles(satir,right(evaluate("attributes.ex_year#i#"),2),44,2," ");//KartExpDate AAYY
								satir = yerles(satir,evaluate("attributes.cvs#i#"),46,3,"0");//CVV
								satir = yerles_saga(satir,tutar,49,13,"0");//İŞLEM TUTARI
								satir = yerles(satir,"004",62,3," ");//PARA BİRİMİ
								satir = yerles(satir," ",65,6," ");//prov no
								satir = yerles(satir,"0",71,2,"0");//taksit
								satir = yerles(satir,"0",73,2,"0");//tekrar sayısı
								satir = yerles(satir,left(trim(replacelist(evaluate("attributes.member_name#i#"),"ş,Ş,ğ,Ğ,ı,İ,Ç,ç,Ö,ö,Ü,ü","s,S,g,G,i,I,C,c,O,o,U,u")),40),75,40," ");//müşteri adısoyadı
								satir = yerles(satir," ",115,261," ");//adres tel vs
								satir = yerles_saga(satir,evaluate("attributes.payment_row#i#"),376,30," ");//ödeme planı satır id
								satir = yerles_saga(satir,evaluate("attributes.invoice_id#i#"),406,30," ");//invoice_id
								satir = yerles(satir," ",436,210," ");//
								file_content[index_array] = "#satir#";
								index_array = index_array+1;
							</cfscript>
							<cfquery name="UPD_PAYMENT_ROWS" datasource="#dsn3#">
								UPDATE
									SUBSCRIPTION_PAYMENT_PLAN_ROW
								SET
									IS_COLLECTED_PROVISION = 1,
									UPDATE_DATE = #now()#,
									UPDATE_IP = '#cgi.remote_addr#',
									UPDATE_EMP = #session.ep.userid#
								WHERE
									INVOICE_ID = #evaluate("attributes.invoice_id#i#")# AND
								<cfif isDefined("attributes.prov_period") and len(attributes.prov_period)>
									PERIOD_ID = #ListGetAt(attributes.prov_period,3,";")#
								<cfelse>
									PERIOD_ID = #session.ep.period_id#
								</cfif>
							</cfquery>
							<cfoutput>#i#. Satıra Provizyon Oluşturuldu</cfoutput><br/>
						</cfif>
					</cfif>
				</cftransaction>
			</cflock>
			<cfcatch>
				<cfoutput>#i#. Satıra Provizyon Oluşturulamadı</cfoutput><br/>
			</cfcatch> 
		</cftry>
	</cfloop>
<cfelseif attributes.bank_name eq 8><!---Denizbank--->
	<cfloop from="1" to="#attributes.all_records#" index="i">
		<cftry>
			<cflock name="#CreateUUID()#" timeout="20">
				<cftransaction>
					<cfif isdefined("attributes.payment_row#i#")>
						<cfquery name="GET_PROV_INFO" datasource="#DSN3#"><!--- aynı anda yapılan işlemlerin kontrolu --->
							SELECT
								IS_COLLECTED_PROVISION
							FROM
								SUBSCRIPTION_PAYMENT_PLAN_ROW
							WHERE
								INVOICE_ID = #evaluate("attributes.invoice_id#i#")# AND
							<cfif isDefined("attributes.prov_period") and len(attributes.prov_period)>
								PERIOD_ID = #ListGetAt(attributes.prov_period,3,";")#
							<cfelse>
								PERIOD_ID = #session.ep.period_id#
							</cfif>
						</cfquery>
						<cfif GET_PROV_INFO.IS_COLLECTED_PROVISION eq 0>
							<cfscript>
								satir = "";
								tutar = evaluate("attributes.nettotal#i#");
								if(int(tutar) eq tutar)tutar = tutar & "00";
								else if((int(tutar * 10)) eq (tutar * 10))tutar = (tutar*10) & "0";
								else tutar = tutar * 100;
								satir = satir & "001" & repeatString(" ",642);//işlem tipi
								satir = yerles(satir,dateformat(now(),'yyyy.mm.dd') & '.' & timeformat(now(),"hh.mm.ss"),4,19," ");//Tahsilat Başlangıç Tarihi
								satir = yerles(satir,evaluate("attributes.card_number#i#"),23,19," ");//KART NUMARASI
								satir = yerles_saga(satir,evaluate("attributes.ex_month#i#"),42,2,"0");//KartExpDate
								satir = yerles(satir,right(evaluate("attributes.ex_year#i#"),2),44,2," ");//KartExpDate AAYY
								satir = yerles(satir,evaluate("attributes.cvs#i#"),46,3,"0");//CVV
								satir = yerles_saga(satir,tutar,49,13,"0");//İŞLEM TUTARI
								satir = yerles(satir,"004",62,3," ");//PARA BİRİMİ/KUR
								satir = yerles(satir," ",65,6," ");//prov no
								satir = yerles(satir,"0",71,2,"0");//taksit
								satir = yerles(satir,"0",73,2,"0");//tekrar sayısı
								satir = yerles(satir,left(trim(replacelist(evaluate("attributes.member_name#i#"),"ş,Ş,ğ,Ğ,ı,İ,Ç,ç,Ö,ö,Ü,ü","s,S,g,G,i,I,C,c,O,o,U,u")),40),75,40," ");//müşteri adısoyadı
								satir = yerles(satir," ",115,261," ");//adres tel email
								satir = yerles_saga(satir,evaluate("attributes.payment_row#i#"),376,30," ");//ödeme planı satır id
								satir = yerles_saga(satir,evaluate("attributes.invoice_id#i#"),406,30," ");//invoice_id
								satir = yerles(satir," ",436,210," ");//
								file_content[index_array] = "#satir#";
								index_array = index_array+1;
							</cfscript>
							<cfquery name="UPD_PAYMENT_ROWS" datasource="#dsn3#">
								UPDATE
									SUBSCRIPTION_PAYMENT_PLAN_ROW
								SET
									IS_COLLECTED_PROVISION = 1,
									UPDATE_DATE = #now()#,
									UPDATE_IP = '#cgi.remote_addr#',
									UPDATE_EMP = #session.ep.userid#
								WHERE
									INVOICE_ID = #evaluate("attributes.invoice_id#i#")# AND
								<cfif isDefined("attributes.prov_period") and len(attributes.prov_period)>
									PERIOD_ID = #ListGetAt(attributes.prov_period,3,";")#
								<cfelse>
									PERIOD_ID = #session.ep.period_id#
								</cfif>
							</cfquery>
							<cfoutput>#i#. Satıra Provizyon Oluşturuldu</cfoutput><br/>
						</cfif>
					</cfif>
				</cftransaction>
			</cflock>
			<cfcatch>
				<cfoutput>#i#. Satıra Provizyon Oluşturulamadı</cfoutput><br/>
			</cfcatch> 
		</cftry>
	</cfloop>
<cfelseif attributes.bank_name eq 9><!---ING--->
	<cfloop from="1" to="#attributes.all_records#" index="i">
		<cftry>
			<cflock name="#CreateUUID()#" timeout="20">
				<cftransaction>
					<cfif isdefined("attributes.payment_row#i#")>
						<cfquery name="GET_PROV_INFO" datasource="#DSN3#"><!--- aynı anda yapılan işlemlerin kontrolu --->
							SELECT
								IS_COLLECTED_PROVISION
							FROM
								SUBSCRIPTION_PAYMENT_PLAN_ROW
							WHERE
								INVOICE_ID = #evaluate("attributes.invoice_id#i#")# AND
							<cfif isDefined("attributes.prov_period") and len(attributes.prov_period)>
								PERIOD_ID = #ListGetAt(attributes.prov_period,3,";")#
							<cfelse>
								PERIOD_ID = #session.ep.period_id#
							</cfif>
						</cfquery>
						<cfif GET_PROV_INFO.IS_COLLECTED_PROVISION eq 0>
							<cfscript>
								satir = "";
								tutar = evaluate("attributes.nettotal#i#");
								if(int(tutar) eq tutar)tutar = tutar & "00";
								else if((int(tutar * 10)) eq (tutar * 10))tutar = (tutar*10) & "0";
								else tutar = tutar * 100;
								satir = satir & "001" & repeatString(" ",645);//işlem tipi
								satir = yerles(satir,dateformat(now(),'yyyy.mm.dd') & '.' & timeformat(now(),"hh.mm.ss"),4,19," ");//Tahsilat Başlangıç Tarihi
								satir = yerles(satir,evaluate("attributes.card_number#i#"),23,19," ");//KART NUMARASI
								satir = yerles_saga(satir,evaluate("attributes.ex_month#i#"),42,2,"0");//KartExpDate
								satir = yerles(satir,right(evaluate("attributes.ex_year#i#"),2),44,2," ");//KartExpDate AAYY
								satir = yerles(satir,evaluate("attributes.cvs#i#"),46,3,"0");//CVV
								satir = yerles_saga(satir,tutar,49,13,"0");//İŞLEM TUTARI
								satir = yerles(satir,"004",62,3," ");//PARA BİRİMİ/KUR
								satir = yerles(satir," ",65,6," ");//prov no
								satir = yerles(satir,"0",71,2,"0");//taksit
								satir = yerles(satir,"0",73,2,"0");//tekrar sayısı
								satir = yerles(satir,left(trim(replacelist(evaluate("attributes.member_name#i#"),"ş,Ş,ğ,Ğ,ı,İ,Ç,ç,Ö,ö,Ü,ü","s,S,g,G,i,I,C,c,O,o,U,u")),40),75,40," ");//müşteri adısoyadı
								satir = yerles(satir," ",115,261," ");//adres tel email
								satir = yerles_saga(satir,evaluate("attributes.payment_row#i#"),376,30," ");//ödeme planı satır id
								satir = yerles_saga(satir,evaluate("attributes.invoice_id#i#"),406,30," ");//invoice_id
								satir = yerles(satir," ",436,213," ");//
								file_content[index_array] = "#satir#";
								index_array = index_array+1;
							</cfscript>
							<cfquery name="UPD_PAYMENT_ROWS" datasource="#dsn3#">
								UPDATE
									SUBSCRIPTION_PAYMENT_PLAN_ROW
								SET
									IS_COLLECTED_PROVISION = 1,
									UPDATE_DATE = #now()#,
									UPDATE_IP = '#cgi.remote_addr#',
									UPDATE_EMP = #session.ep.userid#
								WHERE
									INVOICE_ID = #evaluate("attributes.invoice_id#i#")# AND
								<cfif isDefined("attributes.prov_period") and len(attributes.prov_period)>
									PERIOD_ID = #ListGetAt(attributes.prov_period,3,";")#
								<cfelse>
									PERIOD_ID = #session.ep.period_id#
								</cfif>
							</cfquery>
							<cfoutput>#i#. Satıra Provizyon Oluşturuldu</cfoutput><br/>
						</cfif>
					</cfif>
				</cftransaction>
			</cflock>
			<cfcatch>
				<cfoutput>#i#. Satıra Provizyon Oluşturulamadı</cfoutput><br/>
			</cfcatch> 
		</cftry>
	</cfloop>
<cfelseif attributes.bank_name eq 10><!---Banksoft--->
	<cfscript>
		header = "H" & "M" & repeatString(" ",15) & repeatString(" ",6) & year(islem_tarihi)& dayofyear(islem_tarihi) & repeatString("0",5-len(dayofyear(islem_tarihi))) & repeatString(" ",2) & "000109";
		file_content[index_array] = "#header#";
		index_array = index_array+1;
	</cfscript>
	<cfloop from="1" to="#attributes.all_records#" index="i">
		  <cftry> 
			<cflock name="#CreateUUID()#" timeout="20">
				<cftransaction> 
					<cfif isdefined("attributes.payment_row#i#")>
						<cfquery name="GET_PROV_INFO" datasource="#DSN3#"><!--- aynı anda yapılan işlemlerin kontrolu --->
							SELECT
								IS_COLLECTED_PROVISION
							FROM
								SUBSCRIPTION_PAYMENT_PLAN_ROW
							WHERE
								INVOICE_ID = #evaluate("attributes.invoice_id#i#")# AND
							<cfif isDefined("attributes.prov_period") and len(attributes.prov_period)>
								PERIOD_ID = #ListGetAt(attributes.prov_period,3,";")#
							<cfelse>
								PERIOD_ID = #session.ep.period_id#
							</cfif>
						</cfquery>
						
						<cfif GET_PROV_INFO.IS_COLLECTED_PROVISION eq 0>
							<cfscript>
								satir = "";
								tutar = evaluate("attributes.nettotal#i#");
								if(int(tutar) eq tutar)tutar = tutar & "00";
								else if((int(tutar * 10)) eq (tutar * 10))tutar = (tutar*10) & "0";
								else tutar = tutar * 100;
								id_info = evaluate("attributes.invoice_id#i#")&"."&evaluate("attributes.payment_row#i#");
								satir = satir & "DSA" & repeatString("0",217);//işlem tipi
								satir = yerles(satir,evaluate("attributes.payment_row#i#"),4,15," ");//prov id
								satir = yerles(satir,dateformat(islem_tarihi,'yyyymmdd'),19,8,"0");//islem tarihi
								satir = yerles(satir,"949",27,3,"0");//islem currency code
								satir = yerles_saga(satir,tutar,30,15,"0");//islem Tutar
								satir = yerles(satir,"949",45,3,"0");//billing currency code
								satir = yerles_saga(satir,tutar,48,15,"0");//billing Tutar
								satir = yerles(satir,len(evaluate("attributes.card_number#i#")),63,2,"0");//Kart No Length
								satir = yerles(satir,evaluate("attributes.card_number#i#"),65,19," ");//Kart No
								satir = yerles_saga(satir,evaluate("attributes.ex_month#i#"),84,2,"0");//KartExpDate
								satir = yerles(satir,right(evaluate("attributes.ex_year#i#"),2),86,2,"0");//KartExpDate AAYY
								satir = yerles(satir,evaluate("attributes.cvs#i#"),88,3," ");//CVV
								satir = yerles(satir,"0",91,2,"0");
								satir = yerles(satir," ",93,19," ");
								satir = yerles(satir,"0",112,15,"0");
								satir = yerles(satir,"1234",127,4," ");
								satir = yerles(satir," ",131,9," ");
								satir = yerles(satir,"0",140,3,"0");
								satir = yerles(satir,"0",143,9,"0");
								satir = yerles(satir," ",152,1," ");
								satir = yerles(satir,"0",153,18,"0");
								satir = yerles(satir,evaluate("attributes.invoice_id#i#"),171,50," ");//invoice_id
								toplam = toplam + tutar;//trailerda toplam tutar bilgisi için
								kayit_sayisi = kayit_sayisi + 1;//trailerda seçili satırların toplamı için
								file_content[index_array] = "#satir#";
								index_array = index_array+1;
							</cfscript>
							<cfquery name="UPD_PAYMENT_ROWS" datasource="#dsn3#">
								UPDATE
									SUBSCRIPTION_PAYMENT_PLAN_ROW
								SET
									IS_COLLECTED_PROVISION = 1,
									UPDATE_DATE = #now()#,
									UPDATE_IP = '#cgi.remote_addr#',
									UPDATE_EMP = #session.ep.userid#
								WHERE
									INVOICE_ID = #evaluate("attributes.invoice_id#i#")# AND
								<cfif isDefined("attributes.prov_period") and len(attributes.prov_period)>
									PERIOD_ID = #ListGetAt(attributes.prov_period,3,";")#
								<cfelse>
									PERIOD_ID = #session.ep.period_id#
								</cfif>
							</cfquery>
							<cfoutput>#i#. Satıra Provizyon Oluşturuldu</cfoutput><br/>
						</cfif>
					</cfif>
				 </cftransaction>
			</cflock>
			 <cfcatch> 
				<cfoutput>#i#. Satıra Provizyon Oluşturulamadı</cfoutput><br/>
			 </cfcatch>  
		</cftry> 
	</cfloop>
	<cfscript>
		file_content[index_array] = 'T' & repeatString("0",15-len(kayit_sayisi)) & kayit_sayisi & repeatString("0",15-len(toplam)) & toplam;
		index_array = index_array+1;
	</cfscript>
</cfif>
<cftry>
	<cfset file_name = "#CreateUUID()#.txt">
	<cflock name="#CreateUUID()#" timeout="60">
		<cftransaction>
			<cfquery name="ADD_FILE_EXPORTS" datasource="#dsn2#">
				INSERT INTO
					FILE_EXPORTS
					(
						PROCESS_TYPE,
						FILE_NAME,
						FILE_CONTENT,
						TARGET_SYSTEM,
						RECORD_DATE,
						RECORD_IP,
						RECORD_EMP
					)
					VALUES
					(
						-6,
						'#file_name#',
						'#Encrypt(ArraytoList(file_content,CRLF),attributes.key_type,"CFMX_COMPAT","Hex")#',
						#attributes.bank_name#,
						#now()#,
						'#cgi.remote_addr#',
						#session.ep.userid#
					)
			</cfquery>
		</cftransaction>
	</cflock>
	<cfoutput>Provizyon İşlemi Tamamlandı...</cfoutput>
	<cfcatch><!--- belge kaydedilirken sorun olmussa islem geri alınır --->
		<cfloop from="1" to="#attributes.all_records#" index="i">
			<cfif isdefined("attributes.payment_row#i#")>
				<cflock name="#CreateUUID()#" timeout="60">
					<cftransaction>
						<cfquery name="UPD_PAYMENT_ROWS" datasource="#dsn3#">
							UPDATE
								SUBSCRIPTION_PAYMENT_PLAN_ROW
							SET
								IS_COLLECTED_PROVISION = 0,
								UPDATE_DATE = #now()#,
								UPDATE_IP = '#cgi.remote_addr#',
								UPDATE_EMP = #session.ep.userid#
							WHERE
								INVOICE_ID = #evaluate("attributes.invoice_id#i#")# AND
							<cfif isDefined("attributes.prov_period") and len(attributes.prov_period)>
								PERIOD_ID = #ListGetAt(attributes.prov_period,3,";")#
							<cfelse>
								PERIOD_ID = #session.ep.period_id#
							</cfif>
						</cfquery>	
					</cftransaction>
				</cflock>
			</cfif>
		</cfloop>
		<cfoutput>Provizyon İşlemi Geri Alındı</cfoutput>
	</cfcatch>
</cftry>
