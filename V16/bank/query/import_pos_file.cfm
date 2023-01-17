<!--- toplu pos dönüşleri import sayfasıdır
bayilerin pos cihazlarından bankaya gönderilen raporların sisteme işlenmesidir,farklı bankalar için farklı desenler vardır
hsmagaza ve bilişim tarafı için add_optionsta dosya vardır,genel değişiklikler oraya da yansıtılmalıdır...Aysenur
 --->
<cfsetting showdebugoutput="no">
<cfset currency_multiplier = attributes.money_rate2/attributes.money_rate1>
<cfquery name="GET_IMPORT" datasource="#DSN2#">
	SELECT SOURCE_SYSTEM,FILE_NAME FROM FILE_IMPORTS WHERE PROCESS_TYPE = -8 AND I_ID = #attributes.i_id# AND IMPORTED = 0
</cfquery>
<cfif GET_IMPORT.recordcount>
	<cfquery name="UPD_FILE_IMPORTS" datasource="#DSN2#">
		UPDATE FILE_IMPORTS SET IMPORTED = 1 WHERE I_ID = #attributes.i_id#
	</cfquery>
<cffile action="read" file="#upload_folder#finance#dir_seperator##get_import.file_name#" variable="dosya">
<cfscript>
	CRLF = Chr(13)&Chr(10); // satır atlama karakteri
	if(GET_IMPORT.SOURCE_SYSTEM eq 10)//Akbank
	{
		dosya = ListToArray(dosya,CRLF);
		for(i=1; i lte 2; i=i+1)
			ArrayDeleteAt(dosya,1);//header satırlarını silmek için
			line_count = ArrayLen(dosya);
	
		for(i=1; i lte line_count-1; i=i+1)
		{
			satir = dosya[i];
			isyeri_no = oku(satir,1,9);//İşyeri No
			terminal_no = oku(satir,11,8);//POS No
			valor_date = oku(satir,134,10);//Valor Tarihi
			process_date = oku(satir,20,10);//İşlem Tarihi
			pos_process_type = oku(satir,57,9);//İşlem Tipi
			taksit_sayisi = oku(satir,74,8);//Taksit Sayısı
			komisyon = val(oku(satir,100,16));//Komisyon
			given_chip = val(oku(satir,162,16));//Verilen chip = ödül
			gross_total = val(oku(satir,83,16));//Brüt Tutar=İşlem Tutarı
			cari_tutar = (gross_total-komisyon-given_chip);//
			net_total = (gross_total-komisyon-given_chip);//net tutar
			/*sonra eklenebilir
			used_chip = oku(satir,145,16);//Kullanılan chip
        	kes_chip = oku(satir,179,16);//Kesilen chip
			net_chip = oku(satir,196,16);//Net chip*/
			try{
				f_add_bank_pos_file_rows(
					seller_code : isyeri_no,
					terminal_no : terminal_no,
					valor_date : valor_date,
					process_date : process_date,
					pos_process_type : pos_process_type,
					number_of_instalment : taksit_sayisi,
					commission : komisyon,
					award : given_chip,
					gross_total : gross_total,
					cari_tutar : cari_tutar,
					net_total : net_total,
					is_cancel : 0,
					bank_type : GET_IMPORT.SOURCE_SYSTEM,
					file_import_id : attributes.i_id
					);
			}//her satır için function a gönderildigi için dışarda tek degildir,function da bu sayfanın içindedir
			catch(any e)
			{
				writeoutput('<br/>#i#____İşyeriNo:#isyeri_no#_______TerminalNo:#terminal_no#_______ValorTarihi:#valor_date#____Satır Yazılamadı');	
			}
		}
	}
	else if(GET_IMPORT.SOURCE_SYSTEM eq 11)//İşBankası
	{
		dosya = ListToArray(dosya,CRLF);
		for(i=1; i lte 2; i=i+1)
			ArrayDeleteAt(dosya,1);//header satırlarını silmek için
		line_count = ArrayLen(dosya);
		for(i=1; i lte line_count; i=i+1)
		{
			satir = dosya[i];
			isyeri_no = oku(satir,71,15);//İşyeri No
			terminal_no = oku(satir,596,5);//POS No
			valor_date = oku(satir,561,10);//Hesaba Geçiş Tarihi
			process_date = oku(satir,246,10);//İşlem Tarihi
			pos_process_type = oku(satir,351,5);//İşlem Tipi
			taksit_sayisi = oku(satir,456,2);//Taksit Sayısı
			if(oku(satir,386,1) eq "-")//iptal satırları için
			{
				komisyon = val(Replace(oku(satir,981,12),",",".") + Replace(oku(satir,841,12),",",".") + Replace(oku(satir,911,12),",","."));//İskonto Tutarı + Hizmet Kom. Tutarı + İşyeri Puan Katkı Tutarı
				gross_total = val(Replace(oku(satir,387,12),",","."));//Brüt Tutar=işlem tutarı
				is_cancel = 1;
			}
			else
			{
				komisyon = val(Replace(oku(satir,982,12),",",".") + Replace(oku(satir,842,12),",",".") + Replace(oku(satir,912,12),",","."));//İskonto Tutarı + Hizmet Kom. Tutarı + İşyeri Puan Katkı Tutarı
				gross_total = val(Replace(oku(satir,386,12),",","."));//Brüt Tutar=işlem tutarı
				is_cancel = 0;
			}
			award = 0;//Ödül
			cari_tutar = gross_total - komisyon;//işlem_tutarı-komisyon
			net_total = cari_tutar;//net tutar
			try{
				f_add_bank_pos_file_rows(
					seller_code : isyeri_no,
					terminal_no : terminal_no,
					valor_date : valor_date,
					process_date : process_date,
					pos_process_type : pos_process_type,
					number_of_instalment : taksit_sayisi,
					commission : komisyon,
					award : award,
					gross_total : gross_total,
					cari_tutar : cari_tutar,
					net_total : net_total,
					is_cancel : is_cancel,
					bank_type : GET_IMPORT.SOURCE_SYSTEM,
					file_import_id : attributes.i_id
					);
			}
			catch(any e)
			{
				writeoutput('<br/>#i#____İşyeriNo:#isyeri_no#_______TerminalNo:#terminal_no#_______ValorTarihi:#valor_date#____Satır Yazılamadı');	
			}
		}
	}
	else if(GET_IMPORT.SOURCE_SYSTEM eq 12)//HSBC
	{
		dosya = ListToArray(dosya,CRLF);
			ArrayDeleteAt(dosya,1);//header satırlarını silmek için
		line_count = ArrayLen(dosya);
		for(i=1; i lte line_count; i=i+1)
		{
			satir = dosya[i];
			isyeri_no = ListGetAt(satir,5,",");//İşyeri No
			terminal_no = ListGetAt(satir,6,",");//POS No
			valor_date = ListGetAt(satir,3,",");//Hesaba Geçiş Tarihi
			process_date = ListGetAt(satir,2,",");//İşlem Tarihi
			pos_process_type = ListGetAt(satir,4,",");//İşlem Tipi
			taksit_sayisi = ListGetAt(satir,17,",");//Taksit Sayısı
			komisyon = val(ListGetAt(satir,8,","));//Komisyon
			award = val(ListGetAt(satir,9,","));//Ödül
			gross_total = val(ListGetAt(satir,7,","));//Brüt Tutarı=İşlem Tutarı
			cari_tutar = val(ListGetAt(satir,10,","));//işlem_tutarı-komisyon
			net_total = val(ListGetAt(satir,10,","));//net tutar
			/*sonra eklenebilir
			odul = ListGetAt(satir,9,",");//Ödül
			detail = ListGetAt(satir,18,",");//Açıklama*/
			try{
				f_add_bank_pos_file_rows(
					seller_code : isyeri_no,
					terminal_no : terminal_no,
					valor_date : valor_date,
					process_date : process_date,
					pos_process_type : pos_process_type,
					number_of_instalment : taksit_sayisi,
					commission : komisyon,
					award : award,
					gross_total : gross_total,
					cari_tutar : cari_tutar,
					net_total : net_total,
					is_cancel : 0,
					bank_type : GET_IMPORT.SOURCE_SYSTEM,
					file_import_id : attributes.i_id
					);
			}
			catch(any e)
			{
				writeoutput('<br/>#i#____İşyeriNo:#isyeri_no#_______TerminalNo:#terminal_no#_______ValorTarihi:#valor_date#____Satır Yazılamadı');	
			}
		}
	}
	else if(GET_IMPORT.SOURCE_SYSTEM eq 13)//Garanti
	{
		dosya = ListToArray(dosya,CRLF);
		for(i=1; i lte 5; i=i+1)
			ArrayDeleteAt(dosya,1);//header satırlarını silmek için
		line_count = ArrayLen(dosya);
		for(i=1; i lte line_count; i=i+1)//dosya sonundaki paragraf alınmıyck - şimdilik 27 satır dedim
		{
			satir = dosya[i];
			if(Left(trim(satir),5) eq "-----")break;
			isyeri_no = oku(satir,32,7);//İşyeri No
			terminal_no = oku(satir,220,8);//POS No
			valor_date = oku(satir,13,10);//Hesaba Geçiş Tarihi
			process_date = oku(satir,2,10);//İşlem Tarihi
			pos_process_type = oku(satir,24,5);//İşlem Tipi
			taksit_sayisi = oku(satir,345,2);//Taksit Sayısı
			komisyon = val((oku(satir,80,18) + oku(satir,167,12)));//Komisyon
			award = val(oku(satir,100,18));//ödül
			gross_total = val(oku(satir,180,18));//Brüt Tutarı = işlem_tutarı
			cari_tutar = gross_total - komisyon;//işlem_tutarı-komisyon
			net_total = cari_tutar - award;//işlem_tutarı-ödül = net tutar
			/*sonra eklenebilir
			branch = oku(satir,42,3);//Şube
			odul = oku(satir,100,18);//Ödül
			detail = oku(satir,309,25);//Açıklama*/
			try{
				f_add_bank_pos_file_rows(
					seller_code : isyeri_no,
					terminal_no : terminal_no,
					valor_date : valor_date,
					process_date : process_date,
					pos_process_type : pos_process_type,
					number_of_instalment : taksit_sayisi,
					commission : komisyon,
					award : award,
					gross_total : gross_total,
					cari_tutar : cari_tutar,
					net_total : net_total,
					is_cancel : 0,
					bank_type : GET_IMPORT.SOURCE_SYSTEM,
					file_import_id : attributes.i_id
					);
			}
			catch(any e)
			{
				writeoutput('<br/>#i#____İşyeriNo:#isyeri_no#_______TerminalNo:#terminal_no#_______ValorTarihi:#valor_date#____Satır Yazılamadı');	
			}
		}
	}
	else if(GET_IMPORT.SOURCE_SYSTEM eq 14)//YKB
	{
		xml_part = XmlParse(dosya);
		xml_dizi = xml_part.YKBPOS_TRANSACTIONS.XmlChildren;
		d_boyut = ArrayLen(xml_dizi);
		for(i=1; i lte d_boyut; i=i+1)
		{
			isyeri_no = xml_part.YKBPOS_TRANSACTIONS.YKBPOSTXN[i].UYEISY.XmlText;//İşyeri No
			terminal_no = xml_part.YKBPOS_TRANSACTIONS.YKBPOSTXN[i].TRMNO.XmlText;//POS No
			valor_date = xml_part.YKBPOS_TRANSACTIONS.YKBPOSTXN[i].BLOKCOZTAR.XmlText;//Hesaba Geçiş Tarihi
			process_date = xml_part.YKBPOS_TRANSACTIONS.YKBPOSTXN[i].ISLTAR.XmlText;//İşlem Tarihi
			pos_process_type = xml_part.YKBPOS_TRANSACTIONS.YKBPOSTXN[i].ISLTIP.XmlText;//İşlem Tipi
			taksit_sayisi = xml_part.YKBPOS_TRANSACTIONS.YKBPOSTXN[i].TKSTADEDI.XmlText;//Taksit Sayısı
			komisyon = abs(Replace(xml_part.YKBPOS_TRANSACTIONS.YKBPOSTXN[i].KMSYN.XmlText,",","."));//Komisyon
			katki_payi = abs(Replace(xml_part.YKBPOS_TRANSACTIONS.YKBPOSTXN[i].KPAY.XmlText,",","."));//Katkı Payı
			erken_odeme_tut = abs(Replace(xml_part.YKBPOS_TRANSACTIONS.YKBPOSTXN[i].ERKODMTUT.XmlText,",","."));//Erken Ödeme Tutarı
			award = 0;
			gross_total = abs(Replace(xml_part.YKBPOS_TRANSACTIONS.YKBPOSTXN[i].ORJTUT.XmlText,",","."));//Brüt Tutar = işlem tutarı
			cari_tutar = gross_total - erken_odeme_tut - komisyon;//işlem_tutarı - erken_odeme_tut - komisyon
			// version1  cari_tutar = gross_total - komisyon;//işlem_tutarı - komisyon
			net_total = cari_tutar - katki_payi;//net tutar
			if(left(xml_part.YKBPOS_TRANSACTIONS.YKBPOSTXN[i].ORJTUT.XmlText,1) eq "-")//iptal satırı kontrolu
				is_cancel = 1;
			else
				is_cancel = 0;
			try{
				f_add_bank_pos_file_rows(
					seller_code : isyeri_no,
					terminal_no : terminal_no,
					valor_date : valor_date,
					process_date : process_date,
					pos_process_type : pos_process_type,
					number_of_instalment : taksit_sayisi,
					commission : komisyon,
					award : award,
					gross_total : gross_total,
					cari_tutar : cari_tutar,
					net_total : net_total,
					is_cancel : is_cancel,
					bank_type : GET_IMPORT.SOURCE_SYSTEM,
					file_import_id : attributes.i_id
					);
			}
			catch(any e)
			{
				writeoutput('<br/>#i#____İşyeriNo:#isyeri_no#_______TerminalNo:#terminal_no#_______ValorTarihi:#valor_date#____Satır Yazılamadı');	
			}
		}
	}
	else if(GET_IMPORT.SOURCE_SYSTEM eq 15)//Finansbank
	{
		dosya = ListToArray(dosya,CRLF);
			ArrayDeleteAt(dosya,1);//header satırlarını silmek için
		line_count = ArrayLen(dosya);
		for(i=1; i lte line_count; i=i+1)
		{
			satir = dosya[i];
			isyeri_no = ListGetAt(satir,1,";");//İşyeri No
			terminal_no = ListGetAt(satir,14,";");//POS No
			valor_date = ListGetAt(satir,10,";");//Hesaba Geçiş Tarihi
			process_date = ListGetAt(satir,13,";");//İşlem Tarihi
			pos_process_type = ListGetAt(satir,12,";");//İşlem Tipi
			taksit_sayisi = ListGetAt(satir,15,";");//Taksit Sayısı
			komisyon = val(ListGetAt(satir,6,";"));//Komisyon
			award = val(ListGetAt(satir,18,";"));//Ödül-puan
			gross_total = val(ListGetAt(satir,17,";"));//Brüt Tutarı=İşlem Tutarı
			cari_tutar = gross_total - komisyon - award;//İşlem Tutarı-komisyon-ödül
			net_total = gross_total - komisyon - award;//İşlem Tutarı-komisyon-ödül
			try{
				if (isyeri_no neq "087600000009509" and session.ep.company_id neq 8)//mersa için sadece çalışacak
				{
					f_add_bank_pos_file_rows(
						seller_code : isyeri_no,
						terminal_no : terminal_no,
						valor_date : valor_date,
						process_date : process_date,
						pos_process_type : pos_process_type,
						number_of_instalment : taksit_sayisi,
						commission : komisyon,
						award : award,
						gross_total : gross_total,
						cari_tutar : cari_tutar,
						net_total : net_total,
						is_cancel : 0,
						bank_type : GET_IMPORT.SOURCE_SYSTEM,
						file_import_id : attributes.i_id
						);
				}
			}
			catch(any e)
			{
				writeoutput('<br/>#i#____İşyeriNo:#isyeri_no#_______TerminalNo:#terminal_no#_______ValorTarihi:#valor_date#____Satır Yazılamadı');	
			}
		}
	}
</cfscript>
	<br/>Import Işlemi Tamamlandı...
	<script type="text/javascript">
		wrk_opener_reload();
	</script>
<cfelse>
	<script type="text/javascript">
		alert("<cf_get_lang no ='390.Bu Belge İçin Import Yapılmıştır'>!");
		wrk_opener_reload();
		window.close();
	</script>
	<cfabort>
</cfif>

<cffunction name="f_add_bank_pos_file_rows">
	<cfargument name="seller_code" required="yes">
	<cfargument name="terminal_no" required="yes">
	<cfargument name="valor_date" required="yes">
	<cfargument name="process_date" required="yes">
	<cfargument name="pos_process_type" required="yes">
	<cfargument name="number_of_instalment" required="yes">
	<cfargument name="commission" required="yes">
	<cfargument name="award" required="yes">
	<cfargument name="gross_total" required="yes">
	<cfargument name="cari_tutar" required="yes">
	<cfargument name="net_total" required="yes">
	<cfargument name="bank_type" required="yes">
	<cfargument name="file_import_id" required="yes">
	<cfargument name="is_cancel" required="yes">
	<cf_date tarih='arguments.process_date'>
	<cf_date tarih='arguments.valor_date'>
		<cfquery name="ADD_FILE_IMPORT_BANK_POS_ROWS" datasource="#dsn2#">
			INSERT INTO
				FILE_IMPORT_BANK_POS_ROWS
				(
					SELLER_CODE,
					TERMINAL_NO,
					VALOR_DATE,
					PROCESS_DATE,
					POS_PROCESS_TYPE,
					COMMISSION,
					AWARD,
					NUMBER_OF_INSTALMENT,
					GROSS_TOTAL,
					CARI_TUTAR,
					NET_TOTAL,
					BANK_TYPE,
					FILE_IMPORT_ID,
					MONEY2_MULTIPLIER,
					IS_CANCEL
				)
				VALUES
				(
					'#arguments.seller_code#',
					'#arguments.terminal_no#',
					#CreateODBCDateTime(arguments.valor_date)#,
					#CreateODBCDateTime(arguments.process_date)#,
					'#arguments.pos_process_type#',
					#arguments.commission#,
					#arguments.award#,
					<cfif len(arguments.number_of_instalment)>#arguments.number_of_instalment#,<cfelse>NULL,</cfif>
					#arguments.gross_total#,
					#arguments.cari_tutar#,
					#arguments.net_total#,
					#arguments.bank_type#,
					#arguments.file_import_id#,
					#currency_multiplier#,
					#arguments.is_cancel#
				)
		</cfquery>
</cffunction>

