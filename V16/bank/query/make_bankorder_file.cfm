<!---
    File: make_bankorder_file.cfm
    Folder: V16\bank\query\
	Controller: 
    Author:
    Date:
    Description:
        Banka talimatlarndan havale oluşturulammşlar için dosya oluşturur ve bankaya iletilir,sonrasnda bankanın vereceği dosya ile sisteme bunlar havale olark kaydedilir.
		Şuan ilkolarak dore için yapıldı,diğer firmalar içinde add_optionsda pos dosyaları gibi çoğaltılacak..
		Banka otomatik ödeme işlemlerine kayıt atar..
		Ayşenur20080126
    History:
        
    To Do:

--->

<cfsetting showdebugoutput="no" />
<cf_date tarih='attributes.paym_date'>
<cfif isDefined("attributes.checked_value") and len(attributes.checked_value)>
	<cfquery name="get_comp" datasource="#dsn#">
		SELECT 
			COMPANY_NAME,
			TAX_NO
		FROM 
			OUR_COMPANY
		WHERE 
			COMP_ID = #session.ep.company_id#
	</cfquery>

	<cfset this_bank_id_ = listgetat(attributes.bank_type_id,1,';') />
	<cfset this_bank_name_ = listgetat(attributes.bank_type_id,2,';') />
	<cfset this_export_type_ = listgetat(attributes.bank_type_id,3,';') />

	<cfquery name="GET_BANK_ORDERS" datasource="#dsn2#">
		SELECT
			COMPANY_ID,
			EMPLOYEE_ID,
			CONSUMER_ID,
			ACTION_DETAIL,
			SUM(ACTION_VALUE) ACTION_VALUE
		FROM
			BANK_ORDERS
		WHERE
			BANK_ORDER_ID IN (#attributes.checked_value#)
		GROUP BY
			COMPANY_ID,
			EMPLOYEE_ID,
			CONSUMER_ID,
			ACTION_DETAIL
	</cfquery>

	<cfset companyIdList	= listsort(listdeleteduplicates(valuelist(GET_BANK_ORDERS.COMPANY_ID)),'numeric','ASC',',') />
	<cfset consumerIdList	= listsort(listdeleteduplicates(valuelist(GET_BANK_ORDERS.CONSUMER_ID)),'numeric','ASC',',') />
	<cfset employeeIdList	= listsort(listdeleteduplicates(valuelist(GET_BANK_ORDERS.EMPLOYEE_ID)),'numeric','ASC',',') />

	<cfif len(companyIdList) Or Len(consumerIdList) Or Len(employeeIdList)>
		<cfquery name="get_member_" datasource="#dsn#">
			<cfif len(companyIdList)>
				SELECT
					C.COMPANY_ID MEMBER_ID,
					C.NICKNAME NICKNAME,
					C.FULLNAME FULLNAME,
					C.MEMBER_CODE,
					C.COMPANY_ADDRESS ADDRESS,
					C.COMPANY_POSTCODE POSTCODE,
					SCY.COUNTY_NAME COUNTY,
					SC.CITY_NAME CITY,
					SCT.COUNTRY_NAME COUNTRY,
					C.SEMT SEMT,
					C.COMPANY_TELCODE TELCODE,
					C.company_tel1 TEL,
					CP.COMPANY_PARTNER_NAME AS NAME,
					CP.COMPANY_PARTNER_SURNAME AS SURNAME,
					CB.COMPANY_ACCOUNT_NO AS BANK_ACCOUNT_NO,
					CB.COMPANY_BANK_CODE AS BANK_CODE,
					CB.COMPANY_BANK_BRANCH_CODE AS BANK_BRANCH_CODE,
					CB.COMPANY_IBAN_CODE AS IBAN_CODE,
					CC.BANK_ORDER_ID REF_NO,
					CC.ACTION_VALUE TOTAL_AMOUNT,
					CC.OTHER_MONEY,
					CC.ACTION_DATE,
					CC.ACTION_DETAIL
				FROM
					COMPANY C,
					COMPANY_PARTNER CP,
					COMPANY_BANK CB,
					#dsn2_alias#.BANK_ORDERS CC,
					SETUP_CITY SC,
					SETUP_COUNTRY SCT,
					SETUP_COUNTY SCY
				WHERE
					C.COMPANY_ID IN (#companyIdList#) AND
					CC.BANK_ORDER_ID IN (#attributes.checked_value#) AND
					C.MANAGER_PARTNER_ID = CP.PARTNER_ID AND
					C.COMPANY_ID = CB.COMPANY_ID AND
					CC.COMPANY_ID = C.COMPANY_ID AND
					CB.COMPANY_ACCOUNT_DEFAULT = 1 AND
					SC.CITY_ID = C.CITY AND
					SCT.COUNTRY_ID = C.COUNTRY AND
					SCY.COUNTY_ID = C.COUNTY
			</cfif>
			<cfif len(companyIdList) and len(consumerIdList)>UNION</cfif>
			<cfif len(consumerIdList)>
				SELECT 
					C.CONSUMER_ID MEMBER_ID,
					'' AS NICKNAME,
					C.CONSUMER_NAME+' '+C.CONSUMER_SURNAME AS FULLNAME,
					C.MEMBER_CODE,
					C.HOMEADDRESS ADDRESS,
					C.HOMEPOSTCODE POSTCODE,
					C.HOME_COUNTY_ID COUNTY,
					C.HOME_CITY_ID CITY,
					C.HOME_COUNTRY_ID COUNTRY,
					C.HOMESEMT SEMT,
					C.CONSUMER_HOMETELCODE TELCODE,
					C.CONSUMER_HOMETEL TEL,
					C.CONSUMER_NAME AS NAME,
					C.CONSUMER_SURNAME AS SURNAME,
					CB.CONSUMER_ACCOUNT_NO AS BANK_ACCOUNT_NO,
					CB.CONSUMER_BANK_CODE AS BANK_CODE,
					CB.CONSUMER_BANK_BRANCH_CODE AS BANK_BRANCH_CODE,
					CB.CONSUMER_IBAN_CODE AS IBAN_CODE,
					CC.BANK_ORDER_ID REF_NO,
					CC.ACTION_VALUE TOTAL_AMOUNT,
					CC.OTHER_MONEY,
					CC.ACTION_DATE,
					CC.ACTION_DETAIL
				FROM 
					CONSUMER C,
					CONSUMER_BANK CB,
					#dsn2_alias#.BANK_ORDERS CC,
					SETUP_CITY SC,
					SETUP_COUNTRY SCT,
					SETUP_COUNTY SCY
				WHERE
					C.CONSUMER_ID IN (#consumerIdList#) AND
					CC.BANK_ORDER_ID IN (#attributes.checked_value#) AND
					C.CONSUMER_ID = CB.CONSUMER_ID AND
					CC.CONSUMER_ID = C.CONSUMER_ID AND
					CB.CONSUMER_ACCOUNT_DEFAULT = 1 AND
					SC.CITY_ID = C.HOME_CITY_ID AND
					SCT.COUNTRY_ID = C.HOME_COUNTRY_ID AND
					SCY.COUNTY_ID = C.HOME_COUNTY_ID
			</cfif>
			<cfif (Len(companyIdList) Or Len(consumerIdList)) And Len(employeeIdList)>UNION</cfif>
			<cfif len(employeeIdList)>
				SELECT
					E.EMPLOYEE_ID  MEMBER_ID,
					''                   NICKNAME,
					E.EMPLOYEE_NAME + ' ' + E.EMPLOYEE_SURNAME AS FULLNAME,
					E.MEMBER_CODE,
					''                     ADDRESS,
					''                     POSTCODE,
					''                     COUNTY,
					''                     CITY,
					''                     COUNTRY,
					''                     SEMT,
					''                     TELCODE,
					''                     TEL,
					E.EMPLOYEE_NAME      NAME,
					E.EMPLOYEE_SURNAME   SURNAME,
					EB.BANK_ACCOUNT_NO,
					SBT.BANK_CODE        BANK_CODE,
					EB.BANK_BRANCH_CODE,
					EB.IBAN_NO           IBAN_CODE,
					BO.BANK_ORDER_ID       REF_NO,
					BO.ACTION_VALUE        TOTAL_AMOUNT,
					BO.OTHER_MONEY,
					BO.ACTION_DATE,
					BO.ACTION_DETAIL
				FROM
					#dsn2_alias#.BANK_ORDERS BO
					LEFT JOIN EMPLOYEES E
							ON  E.EMPLOYEE_ID = BO.EMPLOYEE_ID
					LEFT JOIN EMPLOYEES_BANK_ACCOUNTS EB
							ON  EB.EMPLOYEE_ID = E.EMPLOYEE_ID
					LEFT JOIN SETUP_BANK_TYPES sbt
							ON  sbt.BANK_ID = EB.BANK_ID
					LEFT JOIN EMPLOYEES_DETAIL ED
							ON  ED.EMPLOYEE_ID = E.EMPLOYEE_ID
				WHERE
					E.EMPLOYEE_ID IN (#employeeIdList#)
					AND BO.BANK_ORDER_ID IN (#attributes.checked_value#)
					AND EB.DEFAULT_ACCOUNT = 1
			</cfif>
		</cfquery>
	</cfif>

	<cfquery name="get_ftp_info" datasource="#dsn#">
		SELECT
			FTP_SERVER_NAME,
			FTP_FILE_PATH,
			FTP_USERNAME,
			FTP_PASSWORD
		FROM
			SETUP_BANK_TYPES
		WHERE
			BANK_ID = #this_bank_id_#
	</cfquery>

	<cfif this_export_type_ Eq 3><!--- İşbankası Gramoni-Mahmut 08.01.2020 --->
		<cfscript>
			BankOrderFile	= spreadsheetNew(true);

			Baslik					= structNew();
			Baslik.bold				= "true";
			Baslik.fontsize			= 10;
			Baslik.alignment		= "center";
			Baslik.verticalalignment= "vertical_center";
			Baslik.textwrap			= "true";

			BaslikDecimal					= structNew();
			BaslikDecimal.bold				= "true";
			BaslikDecimal.fontsize			= 10;
			BaslikDecimal.alignment			= "right";
			BaslikDecimal.verticalalignment	= "vertical_center";
			BaslikDecimal.dataFormat		= "##,####0.00";

			Satir					= structNew();
			Satir.fontsize			= 10;
			Satir.alignment			= "left";
			Satir.verticalalignment	= "vertical_center";

			SatirDecimal					= structNew();
			SatirDecimal.fontsize			= 10;
			SatirDecimal.alignment			= "right";
			SatirDecimal.verticalalignment	= "vertical_center";
			SatirDecimal.dataFormat			= "##,####0.00";

			//Başlık satırı genişlik ayarı
			spreadsheetSetColumnWidth(BankOrderFile,1,20);
			spreadsheetSetColumnWidth(BankOrderFile,2,20);
			spreadsheetSetColumnWidth(BankOrderFile,3,20);

			//Başlık satırı yükseklik ayarı
			spreadSheetSetRowHeight(BankOrderFile,1,30);
			spreadSheetSetRowHeight(BankOrderFile,2,30);

			//Başlık satırları format
			spreadsheetFormatCell(BankOrderFile, Baslik, 1, 1);
			spreadsheetFormatCell(BankOrderFile, Baslik, 1, 2);
			spreadsheetFormatCell(BankOrderFile, Baslik, 1, 3);
			spreadsheetFormatCell(BankOrderFile, Satir, 2, 1);
			spreadsheetFormatCell(BankOrderFile, Satir, 2, 2);
			spreadsheetFormatCell(BankOrderFile, Satir, 2, 3);

			//Başlık satırı değerler
			spreadsheetSetCellValue(BankOrderFile, 'GÖNDEREN AD SOYAD', 1, 1, 'String');
			spreadsheetSetCellValue(BankOrderFile, get_comp.COMPANY_NAME, 2, 1, "String");
			spreadsheetSetCellValue(BankOrderFile, 'DOSYA TARİHİ', 1, 2, 'String');
			spreadsheetSetCellValue(BankOrderFile, dateFormat(Now(),'dd.mm.YYYY'), 2, 2, 'String');
			spreadsheetSetCellValue(BankOrderFile, 'GÖNDEREN VERGİ NO', 1, 3, 'String');
			spreadsheetSetCellValue(BankOrderFile, get_comp.TAX_NO, 2, 3, 'String');

			//Başlıklar
			spreadsheetSetCellValue(BankOrderFile, 'SIRA NO', 3, 1, "String");
				spreadsheetSetColumnWidth(BankOrderFile,4,20);
				spreadsheetFormatCell(BankOrderFile, Baslik, 3, 1);
			spreadsheetSetCellValue(BankOrderFile, 'İŞLEM TARİHİ', 3, 2, "String");
				spreadsheetSetColumnWidth(BankOrderFile,5,20);
				spreadsheetFormatCell(BankOrderFile, Baslik, 3, 2);
			spreadsheetSetCellValue(BankOrderFile, 'GÖNDEREN ŞUBE KODU', 3, 3, "String");
				spreadsheetSetColumnWidth(BankOrderFile,6,20);
				spreadsheetFormatCell(BankOrderFile, Baslik, 3, 3);
			spreadsheetSetCellValue(BankOrderFile, 'GÖNDEREN HESAP NO', 3, 4, "String");
				spreadsheetSetColumnWidth(BankOrderFile,7,20);
				spreadsheetFormatCell(BankOrderFile, Baslik, 3, 4);
			spreadsheetSetCellValue(BankOrderFile, 'GÖNDEREN IBAN', 3, 5, "String");
				spreadsheetSetColumnWidth(BankOrderFile,8,20);
				spreadsheetFormatCell(BankOrderFile, Baslik, 3, 5);
			spreadsheetSetCellValue(BankOrderFile, 'ALICI ADI', 3, 6, "String");
				spreadsheetSetColumnWidth(BankOrderFile,9,20);
				spreadsheetFormatCell(BankOrderFile, Baslik, 3, 6);
			spreadsheetSetCellValue(BankOrderFile, 'TUTAR', 3, 7, "String");
				spreadsheetSetColumnWidth(BankOrderFile,10,20);
				spreadsheetFormatCell(BankOrderFile, Baslik, 3, 7);
			spreadsheetSetCellValue(BankOrderFile, 'PARA BİRİMİ', 3, 8, "String");
				spreadsheetSetColumnWidth(BankOrderFile,11,20);
				spreadsheetFormatCell(BankOrderFile, Baslik, 3, 8);
			spreadsheetSetCellValue(BankOrderFile, 'ALICI BANKA KODU', 3, 9, "String");
				spreadsheetSetColumnWidth(BankOrderFile,12,20);
				spreadsheetFormatCell(BankOrderFile, Baslik, 3, 9);
			spreadsheetSetCellValue(BankOrderFile, 'ALICI BANKA ADI', 3, 10, "String");
				spreadsheetSetColumnWidth(BankOrderFile,13,20);
				spreadsheetFormatCell(BankOrderFile, Baslik, 3, 10);
			spreadsheetSetCellValue(BankOrderFile, 'ALICI ŞUBE KODU', 3, 11, "String");
				spreadsheetSetColumnWidth(BankOrderFile,14,20);
				spreadsheetFormatCell(BankOrderFile, Baslik, 3, 11);
			spreadsheetSetCellValue(BankOrderFile, 'ALICI SUBE ADI', 3, 12, "String");
				spreadsheetSetColumnWidth(BankOrderFile,15,20);
				spreadsheetFormatCell(BankOrderFile, Baslik, 3, 12);
			spreadsheetSetCellValue(BankOrderFile, 'ALICI HESAP NO', 3, 13, "String");
				spreadsheetSetColumnWidth(BankOrderFile,16,20);
				spreadsheetFormatCell(BankOrderFile, Baslik, 3, 13);
			spreadsheetSetCellValue(BankOrderFile, 'ALICI IBAN', 3, 14, "String");
				spreadsheetSetColumnWidth(BankOrderFile,17,20);
				spreadsheetFormatCell(BankOrderFile, Baslik, 3, 14);
			spreadsheetSetCellValue(BankOrderFile, 'ALICI ADRES', 3, 15, "String");
				spreadsheetSetColumnWidth(BankOrderFile,18,20);
				spreadsheetFormatCell(BankOrderFile, Baslik, 3, 15);
			spreadsheetSetCellValue(BankOrderFile, 'ALICI ŞEHİR', 3, 16, "String");
				spreadsheetSetColumnWidth(BankOrderFile,19,20);
				spreadsheetFormatCell(BankOrderFile, Baslik, 3, 16);
			spreadsheetSetCellValue(BankOrderFile, 'AÇIKLAMA', 3, 17, "String");
				spreadsheetSetColumnWidth(BankOrderFile,20,20);
				spreadsheetFormatCell(BankOrderFile, Baslik, 3, 17);
			spreadsheetSetCellValue(BankOrderFile, 'GÖNDEREN REFERANS', 3, 18, "String");
				spreadsheetSetColumnWidth(BankOrderFile,21,20);
				spreadsheetFormatCell(BankOrderFile, Baslik, 3, 18);
			spreadsheetSetCellValue(BankOrderFile, 'ALICI REFERANS', 3, 19, "String");
				spreadsheetSetColumnWidth(BankOrderFile,22,20);
				spreadsheetFormatCell(BankOrderFile, Baslik, 3, 19);
			spreadsheetSetCellValue(BankOrderFile, 'ALICI VERGİ DAİRESİ', 3, 20, "String");
				spreadsheetSetColumnWidth(BankOrderFile,23,20);
				spreadsheetFormatCell(BankOrderFile, Baslik, 3, 20);
			spreadsheetSetCellValue(BankOrderFile, 'ALICI VERGİ NO', 3, 21, "String");
				spreadsheetSetColumnWidth(BankOrderFile,24,20);
				spreadsheetFormatCell(BankOrderFile, Baslik, 3, 21);
			spreadsheetSetCellValue(BankOrderFile, 'İŞLEM TİPİ', 3, 22, "String");
				spreadsheetSetColumnWidth(BankOrderFile,25,20);
				spreadsheetFormatCell(BankOrderFile, Baslik, 3, 22);

			//Satırlar
			e=3
			toplam_tutar	= 0;
			for(i=1; i<=get_member_.recordCount; i++){
				_adres_[i] =  '#get_member_.address[i]# #get_member_.postcode[i]# #get_member_.semt[i]#';
				if (len(get_member_.county[i])) {
					_adres_[i] = '#_adres_[i]# #get_member_.county[i]# /';
				}
				if (len(get_member_.city[i])) {
					_adres_[i] = '#_adres_[i]# #get_member_.city[i]#';
				}
				if (len(get_member_.country[i])) {
					_adres_[i] = '#_adres_[i]# #get_member_.country[i]#';
				}
		
				sube_no[i] = '#listgetat(attributes.bank_type_id,5,';')#';
				if(len(sube_no[i]) lt 5)
					sube_no[i] = repeatString("0", 5 - len(sube_no[i])) & sube_no[i];
				if(len(sube_no[i]) gt 5)
					sube_no[i] = Left(sube_no[i], 5);
		
				hesap_no[i] = '#listgetat(attributes.bank_type_id,6,';')#';
				
				karsi_hesap_no[i]	= get_member_.IBAN_CODE[i];
				kisi_kodu_[i]		= get_member_.MEMBER_CODE[i];
				alici_adi_[i]		= get_member_.FULLNAME[i];
				aciklama_[i]		= get_member_.action_detail[i];
				ref_[i]				= get_member_.REF_NO[i];
					
				if (get_member_.other_money[i] eq "TL")
					money_type = "TRY";
				else if (get_member_.other_money[i] eq "EURO")
					money_type = "EUR";
				else if (get_member_.other_money[i] eq "YEN")
					money_type = "JTY";
				else if (get_member_.other_money[i] eq "EURO")
					money_type = "EUR";
				else
					money_type = get_member_.other_money[i];

				//SIRA NO
				spreadsheetAddColumn(BankOrderFile, i, e+1, 1, false, 'Numeric');
				spreadsheetFormatCell(BankOrderFile, Satir, e+1, 1);
				//İŞLEM TARİHİ
				spreadsheetAddColumn(BankOrderFile, dateformat(attributes.paym_date,'dd.mm.YYYY'), e+1, 2, false, 'String');
				spreadsheetFormatCell(BankOrderFile, Satir, e+1, 2);
				//GÖNDEREN ŞUBE KODU
				spreadsheetAddColumn(BankOrderFile, sube_no[i], e+1, 3, false, 'String');
				spreadsheetFormatCell(BankOrderFile, Satir, e+1, 3);
				//GÖNDEREN HESAP NO
				spreadsheetAddColumn(BankOrderFile, hesap_no[i], e+1, 4, false, 'String');
				spreadsheetFormatCell(BankOrderFile, Satir, e+1, 4);
				//ALICI ADI
				spreadsheetAddColumn(BankOrderFile, alici_adi_[i], e+1, 6, false, 'String');
				spreadsheetFormatCell(BankOrderFile, Satir, e+1, 6);
				//TUTAR
				spreadsheetAddColumn(BankOrderFile, get_member_.TOTAL_AMOUNT[i], e+1, 7, false, 'Numeric');
				spreadsheetFormatCell(BankOrderFile, SatirDecimal, e+1, 7);
				//PARA BİRİMİ
				spreadsheetAddColumn(BankOrderFile, money_type, e+1, 8, false, 'String');
				spreadsheetFormatCell(BankOrderFile, Satir, e+1, 8);
				//ALICI IBAN
				spreadsheetAddColumn(BankOrderFile, karsi_hesap_no[i], e+1, 14, false, 'String');
				spreadsheetFormatCell(BankOrderFile, Satir, e+1, 14);
				//ALICI ADRES
				spreadsheetAddColumn(BankOrderFile, _adres_[i], e+1, 15, false, 'String');
				spreadsheetFormatCell(BankOrderFile, Satir, e+1, 15);
				//ALICI ŞEHİR
				spreadsheetAddColumn(BankOrderFile, get_member_.CITY[i], e+1, 16, false, 'String');
				spreadsheetFormatCell(BankOrderFile, Satir, e+1, 16);
				//AÇIKLAMA
				spreadsheetAddColumn(BankOrderFile, aciklama_[i], e+1, 17, false, 'String');
				spreadsheetFormatCell(BankOrderFile, Satir, e+1, 17);
				//GÖNDEREN REFERANS
				spreadsheetAddColumn(BankOrderFile, ref_[i], e+1, 18, false, 'String');
				spreadsheetFormatCell(BankOrderFile, Satir, e+1, 18);
				//ALICI REFERANS
				spreadsheetAddColumn(BankOrderFile, kisi_kodu_[i], e+1, 19, false, 'String');
				spreadsheetFormatCell(BankOrderFile, Satir, e+1, 19);
				//İŞLEM TİPİ
				spreadsheetAddColumn(BankOrderFile, 'D', e+1, 22, false, 'String');
				spreadsheetFormatCell(BankOrderFile, Satir, e+1, 22);
				e=e+1;
				toplam_tutar	= toplam_tutar + get_member_.TOTAL_AMOUNT[i];
			}

			//Alt toplam
			spreadsheetSetCellValue(BankOrderFile, 'TOPLAM', e+1, 1, 'String');
			spreadsheetFormatCell(BankOrderFile, Baslik, e+1, 1);
			spreadsheetSetCellValue(BankOrderFile, toplam_tutar, e+1, 7, 'Numeric');
			spreadsheetFormatCell(BankOrderFile, BaslikDecimal, e+1, 7);
			spreadsheetSetCellValue(BankOrderFile, money_type, e+1, 8, 'String');
			spreadsheetFormatCell(BankOrderFile, Baslik, e+1, 8);

			file_name = "#this_bank_name_#_#dateformat(now(),'yyyymmdd')#_#timeformat(now(),'HHmmss')#";
		</cfscript>
		<cfheader name="Content-Disposition" value="attachment; filename=#file_name#.xlsx" />
		<cfcontent type="application/vnd.ms-excel" variable="#SpreadsheetReadBinary(BankOrderFile)#" />
	<cfelseif this_export_type_ eq 6><!--- HSBC FORMATI --->
		<cfscript>
			CRLF = Chr(13) & Chr(10);
			dosya = ArrayNew(1);
			
			firma_kodu = "#get_comp.TAX_NO#";
			
			if(len(firma_kodu) lt 15)
				firma_kodu = repeatString("0",15-len(firma_kodu)) & "#firma_kodu#";
			if(len(firma_kodu) gt 15)
				firma_kodu = "#left(firma_kodu,15)#";
				
			belge_tarihi = "#dateformat(attributes.paym_date,'DDMMYYYY')#";
		</cfscript>
		<cfset hareket_sayisi = get_member_.recordcount>
		<cfscript>
			satir1 = 'B#firma_kodu##belge_tarihi#';
			ArrayAppend(dosya,satir1);
		</cfscript>
		<cfoutput query="get_member_">
			<cfset _adres_ =  '#address# #postcode# #semt#'>
			<cfif len(county)>
				<cfset _adres_ = '#_adres_# #county# /'>
			</cfif>
			<cfif len(city)>
				<cfset _adres_ = '#_adres_# #city#'>
			</cfif> 
			<cfif len(country)>
				<cfset _adres_ = '#_adres_# #country#'>
			</cfif>
			<cfscript>
				bank_code_ = '#listgetat(attributes.bank_type_id,4,';')#';
				if(len(bank_code_) lt 4)
					bank_code_ = repeatString("0", 4 - len(bank_code_)) & bank_code_;
				if(len(bank_code_) gt 4)
					bank_code_ = Left(bank_code_, 4);
		
				sube_no = '#listgetat(attributes.bank_type_id,5,';')#';
				if(len(sube_no) lt 5)
					sube_no = repeatString("0", 5 - len(sube_no)) & sube_no;
				if(len(sube_no) gt 5)
					sube_no = Left(sube_no, 5);
		
				hesap_no = '#listgetat(attributes.bank_type_id,6,';')#';
				if(len(hesap_no) lt 26)
					hesap_no = hesap_no & repeatString(" ", 26 - len(hesap_no));
				if(len(hesap_no) gt 26)
					hesap_no = Left(hesap_no, 26);
		
				sube_no_ = RepeatString(" ", 5);
		
				fark_hesap_no = RepeatString(" ", 18);
		
				karsi_bank_code_ = '#BANK_CODE#';
				if(len(karsi_bank_code_) lt 4)
					karsi_bank_code_ = repeatString("0", 4 - len(karsi_bank_code_)) & karsi_bank_code_;
				if(len(karsi_bank_code_) gt 4)
					karsi_bank_code_ = Left(karsi_bank_code_, 4);
					
				karsi_sube_no = '#BANK_BRANCH_CODE#';
				if(len(karsi_sube_no) lt 5)
					karsi_sube_no = repeatString("0", 5 - len(karsi_sube_no)) & karsi_sube_no;
				if(len(karsi_sube_no) gt 5)
					karsi_sube_no = Left(karsi_sube_no, 5);
				
				if(len(IBAN_CODE))
					karsi_hesap_no = '#IBAN_CODE#';
				else
					karsi_hesap_no = '#BANK_ACCOUNT_NO#';
		
				if(len(karsi_hesap_no) lt 26)
					karsi_hesap_no = repeatString("0", 26 - len(karsi_hesap_no)) & karsi_hesap_no;
				if(len(karsi_hesap_no) gt 26)
					karsi_hesap_no = Left(karsi_hesap_no, 26);
		
				kisi_kodu_ = "#MEMBER_CODE#";
				if(len(kisi_kodu_) lt 10)
					kisi_kodu_ = repeatString("0", 10 - len(kisi_kodu_)) & kisi_kodu_;
				if(len(kisi_kodu_) gt 10)
					kisi_kodu_ = Left(kisi_kodu_, 10);
		
				alici_adi_ = "#FULLNAME#";
				
				if(len(alici_adi_) lt 40)
					alici_adi_ = alici_adi_ & repeatString(" ", 40 - len(alici_adi_));
				if(len(alici_adi_) gt 40)
					alici_adi_ = Left(alici_adi_, 40);
		
				_adres_ = Left(Replace(_adres_, Chr(13) & Chr(10), "", "All"), 40);
				if(len(_adres_) lt 40)
					_adres_ = _adres_ & repeatString(" ", 40 - len(_adres_));
				if(len(_adres_) gt 40)
					_adres_ = Left(_adres_, 40);
		
				if(len(tel))
				{
					telefon_ = "#telcode# #tel#";
					if(len(telefon_) lt 20)
						telefon_ = telefon_ & repeatString(" ", 20 - len(telefon_));
					if(len(telefon_) gt 20)
						telefon_ = Left(telefon_, 20);
				}
				else
					telefon_ = RepeatString(" ", 20);
		
				baba_adi_ = RepeatString(" ", 30);
		
				aciklama_ = Left(Replace(action_detail, Chr(13) & Chr(10), "", "All"), 40);
				if(len(aciklama_) lt 40)
					aciklama_ = aciklama_ & repeatString(" ", 40 - len(aciklama_));
		
				ref_ = Left(REF_NO, 16);
				if(len(ref_) lt 16)
					ref_ = ref_ & repeatString(" ", 16 - len(ref_));
		
				parametre_ = RepeatString(" ", 40);
		
				if(len(TOTAL_AMOUNT))
				{
					amount_ = wrk_round(TOTAL_AMOUNT,2);
					member_amount = listgetat(amount_,1,'.');
		
					if(listlen(amount_,'.') eq 2)	
						member_kurus = listgetat(amount_,2,'.');
					else
						member_kurus = '00';
		
					member_amount = Replace(member_amount, "-", "");
					member_amount = Left(member_amount, 15);
					if(len(member_amount) lt 15)
						member_amount = repeatString("0", 15 - len(member_amount)) & member_amount;
			
					if(len(member_kurus) lt 2)
						member_kurus = member_kurus & repeatString("0", 2 - len(member_kurus));
				}
				else
				{
					member_amount = "                ";
					member_kurus = "  ";
				}	
					
				if (other_money eq "TL")
					money_type = "TRY";
				else if (other_money eq "EURO")
					money_type = "EUR";
				else if (other_money eq "YEN")
					money_type = "JTY";
				else if (other_money eq "EURO")
					money_type = "EUR";
				else
					money_type = other_money;
	
				money_type = money_type & RepeatString(" ", 5 - len(money_type));
	
				odeme_zamani = "#dateformat(ACTION_DATE,'DDMMYYYY')#";
				satir1 = 'D#bank_code_##sube_no##hesap_no##sube_no_##fark_hesap_no##karsi_bank_code_##karsi_sube_no##karsi_hesap_no##kisi_kodu_##alici_adi_##_adres_##telefon_##baba_adi_##aciklama_##ref_##parametre_##member_amount#,#member_kurus##money_type##odeme_zamani#0000';
				ArrayAppend(dosya,satir1);
			</cfscript>
		</cfoutput>
		<cfscript>
			if(len(hareket_sayisi) lt 5)
				hareket_sayisi = repeatString("0",5-len(hareket_sayisi)) & "#hareket_sayisi#";
			satir1 = 'T#hareket_sayisi#';
			ArrayAppend(dosya,satir1);
		</cfscript>
		<cftry>
			<cfset file_name = "#this_bank_name_#_#dateformat(now(),'yyyymmdd')#_#timeformat(now(),'HHmmss')#.txt">
			<cflock name="#CreateUUID()#" timeout="60">
				<cftransaction>
					<cfquery datasource="#dsn2#" result="MAX_ID">
						INSERT INTO
							FILE_EXPORTS
							(
								PROCESS_TYPE,
								FILE_NAME,
								FILE_CONTENT,
								TARGET_SYSTEM,
								FILE_EXPORT_TYPE,
								RECORD_DATE,
								RECORD_IP,
								RECORD_EMP,
								ACTION_DATE
							)
							VALUES
							(
								-11,
								'#file_name#',
								<cfif attributes.is_encrypt_file eq 1>'#Encrypt(ArraytoList(dosya,CRLF),attributes.key_type,"CFMX_COMPAT","Hex")#',<cfelse>'#ArraytoList(dosya,CRLF)#',</cfif>
								#this_bank_id_#,
								#this_export_type_#,
								#now()#,
								'#cgi.remote_addr#',
								#session.ep.userid#,
								#attributes.paym_date#
							)
					</cfquery>
					<cfquery name="upd_order" datasource="#dsn2#">
						UPDATE
							BANK_ORDERS
						SET
							FILE_EXPORT_ID = #MAX_ID.IDENTITYCOL#
						WHERE
							BANK_ORDER_ID IN (#attributes.checked_value#)
					</cfquery>
				</cftransaction>
			</cflock>
			<cf_get_lang dictionary_id='59897.Belge Oluşturma İşlemi Tamamlandı'>
			<cfcatch>
				<cf_get_lang dictionary_id='59898.Belge Oluşturma İşlemi Tamamlanamadı'>!<cfabort>
			</cfcatch>
		</cftry>
		<cfif get_ftp_info.recordcount and len(get_ftp_info.ftp_server_name) and len(get_ftp_info.ftp_username) and len(get_ftp_info.ftp_password)>
			<!--- <cftry> --->
				<cfset folder_name = "#upload_folder#finance#dir_seperator#bank">
				<cfif Not directoryExists(folder_name)>
					<cfdirectory action="create" directory="#folder_name#" />
				</cfif>
				<cffile action="append" output="#ArraytoList(dosya,CRLF)#" file="#folder_name##dir_seperator##file_name#" charset="utf-8">
				<cfftp
					action="putFile"
					server="#get_ftp_info.ftp_server_name#"
					username="#get_ftp_info.ftp_username#"
					password="#Decrypt(get_ftp_info.ftp_password,this_export_type_,"CFMX_COMPAT","Hex")#"
					localfile="#upload_folder#\finance\bank\#file_name#"
					secure="yes"
					remotefile="#get_ftp_info.ftp_file_path#/#file_name#">
				<br/><cf_get_lang dictionary_id='59900.Belge FTPye Gönderildi'>
				<!--- <cfcatch>
					<br/><cf_get_lang dictionary_id='59901.Belge FTPye Gönderilemedi'>
				</cfcatch>
			</cftry> --->
		</cfif>
	<cfelseif this_export_type_ eq 10><!--- HSBC DOVIZ FORMATI 20130717 EsraNur--->
		<!--- header --->
		<cfscript>
			CRLF = Chr(13) & Chr(10);
			dosya = ArrayNew(1);
			//firmanin banka nezdindeki musteri kodu
			firma_kodu = "00000";
			belge_tarihi = "#dateformat(attributes.paym_date,'YYYYMMDD')#";
			//dosya_sira_no: gün içerisinde birden fazla dosya gönderilmesi durumunda karışıklığı önlemek amacıyla gonderilecek 
			dosya_sira_no = "000001";
		</cfscript>
		<cfset hareket_sayisi = get_member_.recordcount>
		<cfscript>
			satir1 = 'H#firma_kodu##belge_tarihi##dosya_sira_no#';
			ArrayAppend(dosya,satir1);
		</cfscript>
		<cfoutput query="get_member_">
			<cfscript>
				// 1. nostro banka swift
				nostro_banka_swift = repeatString(" ",11);
				// 2. tutar ve kurus
				if(len(TOTAL_AMOUNT))
				{
					amount_ = wrk_round(TOTAL_AMOUNT,2);
					member_amount = listgetat(amount_,1,'.');
		
					if(listlen(amount_,'.') eq 2)	
						member_kurus = listgetat(amount_,2,'.');
					else
						member_kurus = '00';
		
					member_amount = Replace(member_amount, "-", "");
					member_amount = Left(member_amount, 13);
					if(len(member_amount) lt 13)
						member_amount = repeatString("0", 13 - len(member_amount)) & member_amount;
			
					if(len(member_kurus) lt 2)
						member_kurus = member_kurus & repeatString("0", 2 - len(member_kurus));
				}
				else
				{
					member_amount = "             ";
					member_kurus = "  ";
				}
				// 3.firma referansi
				ref_ = Left(REF_NO, 16);
				if(len(ref_) lt 16)
					ref_ = ref_ & repeatString(" ", 16 - len(ref_));
				// 4.banka referansi
				bank_ref = repeatString(" ", 16);
				// 5.talimat tarihi
				islem_tarihi = "#dateformat(ACTION_DATE,'YYYYMMDD')#";
				// 6.talimat odeme tarihi
				odeme_tarihi = "#dateformat(PAYMENT_DATE,'YYYYMMDD')#";
				// 7.valor
				valor = "0";
				
				// 8.borclu hesap
				sube_no = '#listgetat(attributes.bank_type_id,5,';')#';
				if(len(sube_no) lt 3)
					sube_no = repeatString("0", 3 - len(sube_no)) & sube_no;
				if(len(sube_no) gt 3)
					sube_no = Left(sube_no, 3);
				
				hesap_no = '#listgetat(attributes.bank_type_id,6,';')#';
				if(len(hesap_no) lt 7)
					hesap_no = hesap_no & repeatString(" ", 7 - len(hesap_no));
				if(len(hesap_no) gt 7)
					hesap_no = Left(hesap_no, 7);
				
				ek_no = repeatString(" ", 3);
				doviz_cinsi = repeatString(" ", 2);
				borclu_hesap = '#sube_no##hesap_no##ek_no##doviz_cinsi#';
				
				// 9.Alacaklı Banka Swift Kodu
				swift_code = '#SWIFT_CODE#';
				if(len(swift_code) lt 8)
					swift_code = repeatString("0", 8 - len(swift_code)) & swift_code;
				if(len(swift_code) gt 8)
					swift_code = Left(swift_code, 8);
				
				karsi_sube_no = '#BANK_BRANCH_CODE#';
				if(len(karsi_sube_no) lt 3)
					karsi_sube_no = repeatString("X", 3 - len(karsi_sube_no)) & karsi_sube_no;
				if(len(karsi_sube_no) gt 3)
					karsi_sube_no = Left(karsi_sube_no, 3);
				
				alacakli_banka_swift_code = '#swift_code##karsi_sube_no#';
				
				// 10.Alacakli Banka adi
				bank_name_ = '#BANK_NAME#';
				if(len(bank_name_) lt 35)
					bank_name_ = repeatString(" ", 35 - len(bank_name_)) & bank_name_;
				if(len(bank_name_) gt 35)
					bank_name_ = Left(bank_name_, 35);
					
				// 11.banka adresi
				bank_adres = repeatString(" ", 105);
				// 12.alici hesap numarasi
				alici_hesap_no = repeatString(" ", 34);
				// 13.alici ismi
				alici_adi_ = "#FULLNAME#";
				if(len(alici_adi_) lt 35)
					alici_adi_ = alici_adi_ & repeatString(" ", 35 - len(alici_adi_));
				if(len(alici_adi_) gt 35)
					alici_adi_ = Left(alici_adi_, 35);
					
				// 14.alici adresi
				alici_adres = repeatString(" ", 105);
				
				// 15.doviz kodu
				if (other_money eq "TL")
					money_type = "TRY";
				else if (other_money eq "EURO")
					money_type = "EUR";
				else if (other_money eq "YEN")
					money_type = "JTY";
				else if (other_money eq "EURO")
					money_type = "EUR";
				else
					money_type = other_money;
	
				money_type = money_type & RepeatString(" ", 3 - len(money_type));
				
				// 16.ekstre aciklama
				extre_detail = repeatString(" ", 40);
				// 17.swift aciklama
				swift_detail = repeatString(" ", 210);
				// 18.islem turu
				process_type = "G";
				// 19.islem detayi
				process_detail = "60";
				// 20.masraf (İşleme ait masrafın hangi tarafa ait olduğu datası.  BEN / OUR / SHA kodları girilir/ islem kategorisine bagli olarak)
				if(BANK_ORDER_TYPE_ID eq 154)
					masraf_ = "BEN";
				else if(BANK_ORDER_TYPE_ID eq 155)
					masraf_ = "OUR";
				else if(BANK_ORDER_TYPE_ID eq 153)
					masraf_ = "SHA";
				// 21.islem kodu
				islem_kodu = "00";
				// 22.IBAN kodu
				karsi_hesap_no = '#IBAN_CODE#';
				if(len(karsi_hesap_no) lt 34)
					karsi_hesap_no = repeatString("0", 34 - len(karsi_hesap_no)) & karsi_hesap_no;
				if(len(karsi_hesap_no) gt 34)
					karsi_hesap_no = Left(karsi_hesap_no, 34);
				// 23.islem tipi kodu
				islem_tipi_kodu = "112";
				// 24.islem tipi aciklama - 34'e kadar
				islem_tipi_aciklama = repeatString(" ", 2355); 
				// 35,37,39
				tl_hesap = repeatString("0", 15);
				// 36,38,40,44
				tl_tutar = "             ,  ";
				// 41.Teşvik
				tesvik = repeatString(" ", 1);
				// 42.Teşvik No
				tesvik_no = repeatString(" ", 20);
				// 43.Teşvik Tarih
				tesvik_tarih = repeatString("0", 8);
				
				satir1 = '#nostro_banka_swift##member_amount#,#member_kurus##ref_##bank_ref##islem_tarihi##odeme_tarihi##valor##borclu_hesap##alacakli_banka_swift_code##bank_name_##bank_adres##alici_hesap_no##alici_adi_##alici_adres##money_type##extre_detail##swift_detail##process_type##process_detail##masraf_##islem_kodu##karsi_hesap_no##islem_tipi_kodu##islem_tipi_aciklama##tl_hesap##tl_tutar##tl_hesap##tl_tutar##tl_hesap##tl_tutar##tesvik##tesvik_no##tesvik_tarih##tl_tutar#';
				ArrayAppend(dosya,satir1);
			</cfscript>
		</cfoutput>
		<!--- tail --->
		<cfscript>
			if(len(hareket_sayisi) lt 7)
				hareket_sayisi = repeatString("0",7-len(hareket_sayisi)) & "#hareket_sayisi#";
			satir1 = 'T#hareket_sayisi#';
			ArrayAppend(dosya,satir1);
		</cfscript>
		<cftry>
			<!--- XXXXX: Çalışılacak firmanın HSBC Bankdaki firma kodudur. --->
			<cfset file_name = "FXXXXX_#dateformat(now(),'MMDD')#.txt">
			<cflock name="#CreateUUID()#" timeout="60">
				<cftransaction>
					<cfquery datasource="#dsn2#" result="MAX_ID">
						INSERT INTO
							FILE_EXPORTS
							(
								PROCESS_TYPE,
								FILE_NAME,
								FILE_CONTENT,
								TARGET_SYSTEM,
								FILE_EXPORT_TYPE,
								RECORD_DATE,
								RECORD_IP,
								RECORD_EMP,
								ACTION_DATE
							)
							VALUES
							(
								-11,
								'#file_name#',
								<cfif attributes.is_encrypt_file eq 1>'#Encrypt(ArraytoList(dosya,CRLF),attributes.key_type,"CFMX_COMPAT","Hex")#',<cfelse>'#ArraytoList(dosya,CRLF)#',</cfif>
								#this_bank_id_#,
								#this_export_type_#,
								#now()#,
								'#cgi.remote_addr#',
								#session.ep.userid#,
								#attributes.paym_date#
							)
					</cfquery>
					<cfquery name="upd_order" datasource="#dsn2#">
						UPDATE
							BANK_ORDERS
						SET
							FILE_EXPORT_ID = #MAX_ID.IDENTITYCOL#
						WHERE
							BANK_ORDER_ID IN (#attributes.checked_value#)
					</cfquery>
				</cftransaction>
			</cflock>
			<cf_get_lang dictionary_id='59897.Belge Oluşturma İşlemi Tamamlandı'>
			<cfcatch>
				<cf_get_lang dictionary_id='59898.Belge Oluşturma İşlemi Tamamlanamadı'>!<cfabort>
			</cfcatch>
		</cftry>
		<cfif get_ftp_info.recordcount and len(get_ftp_info.ftp_server_name) and len(get_ftp_info.ftp_username) and len(get_ftp_info.ftp_password)>
			<cftry>
				<cfset folder_name = "#upload_folder#finance#dir_seperator#bank">
				<cfif Not directoryExists(folder_name)>
					<cfdirectory action="create" directory="#folder_name#" />
				</cfif>
				<cffile action="append" output="#ArraytoList(dosya,CRLF)#" file="#folder_name##dir_seperator##file_name#" charset="utf-8">
				<cfftp
					action="putFile"
					server="#get_ftp_info.ftp_server_name#"
					username="#get_ftp_info.ftp_username#"
					password="#Decrypt(get_ftp_info.ftp_password,this_export_type_,"CFMX_COMPAT","Hex")#"
					localfile="#upload_folder#\finance\bank\#file_name#"
					secure="yes"
					remotefile="#get_ftp_info.ftp_file_path#/#file_name#">
				<br/><cf_get_lang dictionary_id='59900.Belge FTPye Gönderildi'>
				<cfcatch>
					<br/><cf_get_lang dictionary_id='59901.Belge FTPye Gönderilemedi'>
				</cfcatch>
			</cftry>
		</cfif>
	<cfelse>
		<cf_get_lang dictionary_id='59902.Banka Export Tanımları Yapılmamış'>!
	</cfif>
<cfelse>
	<cf_get_lang dictionary_id='59903.Banka Talimatı Bulunamadı'>!
</cfif>