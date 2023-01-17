<cfsetting showdebugoutput="no">
<cfif isDefined('attributes.file_format') and len(attributes.file_format) and attributes.file_format eq 'data_import'>
	<cfif isDefined('attributes.import_id') and len(attributes.import_id) and isDefined('attributes.import_dsn') and len(attributes.import_dsn)>
		<cfset get_import_file = createObject("component","WDO.development.cfc.data_import_library").getData(data_import_id : attributes.import_id) />
		<cfset get_data_source = createObject("component","V16.settings.cfc.data_source").getDataSource(data_source_id : attributes.import_dsn) />
		<cfif get_import_file.recordcount and get_data_source.recordcount>
			<cffile action="read" file="#download_folder##get_import_file.FILE_PATH#" variable="dosya">
			<cfquery name="get_data" datasource="#get_data_source.DATA_SOURCE_NAME#">
				#dosya#
			</cfquery>
		</cfif>
	</cfif>
<cfelse>
	<cfif not DirectoryExists("#upload_folder#temp#dir_seperator#")>
		<cfdirectory action="create" directory="#upload_folder#temp#dir_seperator#">
	</cfif>
	<cfset upload_folder = "#upload_folder#temp#dir_seperator#">
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
				alert("<cf_get_lang_main no='43.Dosyanız Upload Edilemedi ! Dosyanızı Kontrol Ediniz '>!");
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
			alert("Dosya Okunamadı! Karakter Seti Yanlış Seçilmiş Olabilir.");
			history.back();
		</script>
		<cfabort>
	</cfcatch>
	</cftry>
</cfif>

<cfscript>
	CRLF = Chr(13) & Chr(10);// satır atlama karakteri
	dosya = Replace(dosya,';;','; ;','all');
	dosya = Replace(dosya,';;','; ;','all');
	dosya = ListToArray(dosya,CRLF);
	line_count = isDefined('get_data') ? get_data.recordCount : ArrayLen(dosya);
	satir_baslangic = isDefined('get_data') ? 1 : 2;
	satir_no =0;
</cfscript>
<cfloop from="#satir_baslangic#" to="#line_count#" index="i">
	<cfset j= 1>
	<cfset error_flag = 0>
	<cfset error_flag2 = 0>
	<cftry> 
		<cfif isDefined('get_data')>
			<cf_papers paper_type="EMPLOYEE"> 
			<cfscript>
				calisan_no = get_data.CODE[i];
				real_number = 0;
				if(not len(calisan_no)){
					calisan_no = '#paper_code#-' & '#paper_number#';
					real_number = 1;
				}
				isim = get_data.NAME[i];
				soyisim = get_data.SURNAME[i];
				user_name = get_data.KULLANICILADI[i];
				e_mail = get_data.EPOSTA[i];
				e_mail_kisisel = get_data.EMAILKISISEL[i];
				grup_tarih = get_data.GURUMGIRISTARIHI[i];
				kidem_tarih = get_data.KIDEMTARIHI[i];
				izin_tarih = get_data.IZINTARIHI[i];
				tc_kimlik = get_data.IDTCNO[i];
				ssk_no = get_data.SSKNO[i];
				medeni_hal = get_data.MEDENIDURUM[i];
				cinsiyet = get_data.CINSIYET[i];
				din = get_data.RELIGION[i];
				nufus_seri = get_data.SERIALNO[i];
				nufus_no = get_data.NO_[i];
				father = get_data.DADDY[i];
				mother = get_data.MUMMY[i];
				dogum_tarihi = get_data.DOGUMTARIHI[i];
				dogum_yeri = get_data.BIRTHPLACE[i];
				last_surname = get_data.EXSURNAME[i];
				birth_city = get_data.BIRTHPLACE[i];
				nufus_il = get_data.CITY[i];
				nufus_ilce = get_data.TOWN[i];
				ward = get_data.MAHALLE[i];
				village = get_data.KOY[i];
				nufus_cilt_no = get_data.BOOK[i];
				nufus_aile_no = get_data.PAGE[i];
				nufus_sira_no = get_data.ROW_[i];
				given_place = get_data.GIVENPLACE[i];
				given_reason = get_data.GIVENREASON[i];
				record_number = get_data.REGNO[i];
				given_date = get_data.GIVENDATE[i];
				home_adres = get_data.ADRES[i];
				homepostcode = get_data.POSTAKODU[i];
				home_area = get_data.ILCE[i];
				home_city = get_data.SEHIR[i];
				home_country = get_data.ULKE[i];
				home_phone_code = get_data.EVTELALANKODU[i];
				home_phone = get_data.TELEFON[i];
				extension = get_data.DAHILI[i];
				mobiletel_code = get_data.MOBILALANKODU[i];
				mobiletel = get_data.MOBILTEL[i];
				mobiletelspc_code = get_data.MOBILALANKODUKISISEL[i];
				mobiletelspc = get_data.MOBILTELKISISEL[i];
				blood_type = get_data.KANGRUBU[i];
				military_status = get_data.ASKERLIK[i];
				last_school = get_data.OGRENINDURUMU[i];
				hierarchy = get_data.SPECIALCODE[i];

				//alanlar bitti
				//Ad soyad büyük harf yapılıyor
				list="',""";
				list2=" , ";
				e_name=replacelist(trim(isim),list,list2);
				e_surname=replacelist(trim(soyisim),list,list2);
				if(len(grup_tarih) and (grup_tarih neq 0) and isdate(grup_tarih)) grup_tarih=dateformat(grup_tarih,dateformat_style);
				if(len(kidem_tarih) and (kidem_tarih neq 0) and isdate(kidem_tarih)) kidem_tarih=dateformat(kidem_tarih,dateformat_style);
				if(len(izin_tarih) and (izin_tarih neq 0) and isdate(izin_tarih)) izin_tarih=dateformat(izin_tarih,dateformat_style);
			</cfscript>
		<cfelse>
			<cf_papers paper_type="EMPLOYEE"> 
			<cfset calisan_no = paper_number>
			<cfscript>
			//Employees tablosuna yazılacaklar
				//calisan_no = Listgetat(dosya[i],j,";");
				//calisan_no = trim(calisan_no);
				//member_code = 'E' & '#paper_number#';
				//j=j+1;
				
				if(left(dosya[i],1) is ';')
					{
					dosya[i] = '__' & dosya[i];
					calisan_no = '#paper_code#-' & '#paper_number#';
					real_number = 1;
					}
				else
					{
					calisan_no = Listgetat(dosya[i],j,";");
					calisan_no = trim(calisan_no);
					real_number = 0;
					}
				j=j+1;		
				isim = Listgetat(dosya[i],j,";");
				isim = trim(isim);
				j=j+1;

				soyisim = Listgetat(dosya[i],j,";");
				soyisim = trim(soyisim);
				j=j+1;
				
				user_name = Listgetat(dosya[i],j,";");
				user_name = trim(user_name);
				j=j+1;
				
				e_mail	= Listgetat(dosya[i],j,";");
				e_mail = trim(e_mail);
				j=j+1;
				
				e_mail_kisisel	= Listgetat(dosya[i],j,";");
				e_mail_kisisel = trim(e_mail_kisisel);
				j=j+1;
				
				grup_tarih = Listgetat(dosya[i],j,";");
				grup_tarih = trim(grup_tarih);
				j=j+1;

				kidem_tarih = Listgetat(dosya[i],j,";");
				kidem_tarih = trim(kidem_tarih);
				j=j+1;

				izin_tarih = Listgetat(dosya[i],j,";");
				izin_tarih = trim(izin_tarih);
				j=j+1;
			//Employees Identy Tablosuna yazılacaklar	
				tc_kimlik = Listgetat(dosya[i],j,";");
				tc_kimlik = trim(tc_kimlik);
				j=j+1;
				
				ssk_no = Listgetat(dosya[i],j,";");
				ssk_no = trim(ssk_no);
				j=j+1;

				medeni_hal = Listgetat(dosya[i],j,";");
				medeni_hal = trim(medeni_hal);
				j=j+1;

				cinsiyet = Listgetat(dosya[i],j,";");
				cinsiyet = trim(cinsiyet);
				j=j+1;
				
				din = Listgetat(dosya[i],j,";");
				din = trim(din);
				j=j+1;

				nufus_seri= Listgetat(dosya[i],j,";");
				nufus_seri = trim(nufus_seri);
				j=j+1;

				nufus_no= Listgetat(dosya[i],j,";");
				nufus_no = trim(nufus_no);
				j=j+1;

				father = Listgetat(dosya[i],j,";");
				father = trim(father);
				j=j+1;

				mother = Listgetat(dosya[i],j,";");
				mother = trim(mother);
				j=j+1;

				dogum_tarihi = Listgetat(dosya[i],j,";");
				dogum_tarihi = trim(dogum_tarihi);
				j=j+1;

				dogum_yeri = Listgetat(dosya[i],j,";");
				dogum_yeri = trim(dogum_yeri);
				j=j+1;
				
				last_surname = Listgetat(dosya[i],j,";");
				last_surname = trim(last_surname);
				j=j+1;
				
				birth_city = Listgetat(dosya[i],j,";");
				birth_city = trim(birth_city);
				j=j+1;
				

				nufus_il = Listgetat(dosya[i],j,";");
				nufus_il = trim(nufus_il);
				j=j+1;

				nufus_ilce = Listgetat(dosya[i],j,";");
				nufus_ilce = trim(nufus_ilce);
				j=j+1;
				
				ward = Listgetat(dosya[i],j,";");
				ward = trim(ward);
				j=j+1;
				
				village = Listgetat(dosya[i],j,";");
				village = trim(village);
				j=j+1;

				nufus_cilt_no = Listgetat(dosya[i],j,";");
				nufus_cilt_no = trim(nufus_cilt_no);
				j=j+1;

				nufus_aile_no = Listgetat(dosya[i],j,";");
				nufus_aile_no = trim(nufus_aile_no);
				j=j+1;

				nufus_sira_no = Listgetat(dosya[i],j,";");
				nufus_sira_no = trim(nufus_sira_no);
				j=j+1;
				
				given_place = Listgetat(dosya[i],j,";");
				given_place = trim(given_place);
				j=j+1;
				
				given_reason = Listgetat(dosya[i],j,";");
				given_reason = trim(given_reason);
				j=j+1;
				
				record_number = Listgetat(dosya[i],j,";");
				record_number = trim(record_number);
				j=j+1;
				
				given_date = Listgetat(dosya[i],j,";");
				given_date = trim(given_date);
				j=j+1;
				
			//Employees Detail Tablosuna yazılacaklar
				home_adres = Listgetat(dosya[i],j,";");
				home_adres = trim(home_adres);
				j=j+1;
				
				homepostcode = Listgetat(dosya[i],j,";");
				homepostcode = trim(homepostcode);
				j=j+1;
				

				home_area = Listgetat(dosya[i],j,";");
				home_area = trim(home_area);
				j=j+1;

				home_city = Listgetat(dosya[i],j,";");
				home_city = trim(home_city);
				j=j+1;
				
				home_country = Listgetat(dosya[i],j,";");
				home_country = trim(home_country);
				j=j+1;

				home_phone_code = Listgetat(dosya[i],j,";");
				home_phone_code = trim(home_phone_code);
				j=j+1;
				
				home_phone = Listgetat(dosya[i],j,";");
				home_phone = trim(home_phone);
				j=j+1;
				
				extension = Listgetat(dosya[i],j,";");
				extension = trim(extension);
				j=j+1;
				
				mobiletel_code = Listgetat(dosya[i],j,";");
				mobiletel_code = trim(mobiletel_code);
				j=j+1;
				
				mobiletel = Listgetat(dosya[i],j,";");
				mobiletel = trim(mobiletel);
				j=j+1;
				
				mobiletelspc_code = Listgetat(dosya[i],j,";");
				mobiletelspc_code = trim(mobiletelspc_code);
				j=j+1;
				
				mobiletelspc = Listgetat(dosya[i],j,";");
				mobiletelspc = trim(mobiletelspc);
				j=j+1;
				
				blood_type = Listgetat(dosya[i],j,";");
				blood_type = trim(blood_type);
				j=j+1;

				military_status = trim(Listgetat(dosya[i],j,";"));
				j=j+1;
				
				last_school = Listgetat(dosya[i],j,";");
				last_school = trim(last_school);
				j=j+1;
				if(listlen(dosya[i],';') gte j)
				{
					hierarchy = Listgetat(dosya[i],j,";");
					hierarchy = trim(hierarchy);
				}
				else hierarchy = '';
				
				//alanlar bitti
				//Ad soyad büyük harf yapılıyor
				list="',""";
				list2=" , ";
				e_name=replacelist(trim(isim),list,list2);
				e_surname=replacelist(trim(soyisim),list,list2);
				if(len(grup_tarih) and (grup_tarih neq 0) and isdate(grup_tarih)) grup_tarih=dateformat(grup_tarih,dateformat_style);
				if(len(kidem_tarih) and (kidem_tarih neq 0) and isdate(kidem_tarih)) kidem_tarih=dateformat(kidem_tarih,dateformat_style);
				if(len(izin_tarih) and (izin_tarih neq 0) and isdate(izin_tarih)) izin_tarih=dateformat(izin_tarih,dateformat_style);
			</cfscript>
		</cfif>
		<cfcatch type="Any"> 
			<cfoutput>#i#</cfoutput>. satır 1. adımda sorun oluştu.<br/>
			<cfset error_flag = 1>
		</cfcatch> 
	</cftry>
	<cfif error_flag neq 1>
		<!---<cftry> --->
		<cfquery name="get_tc_identity_no" datasource="#dsn#">
			SELECT TC_IDENTY_NO FROM EMPLOYEES_IDENTY WHERE TC_IDENTY_NO = '#tc_kimlik#' AND (TC_IDENTY_NO <> '' OR TC_IDENTY_NO IS NOT NULL)
		</cfquery>
		<cfif get_tc_identity_no.recordcount>
			<cfset error_flag2 = 1>
		</cfif>
		<cfset tc_kimlik_ = tc_kimlik>
		<cfif error_flag2 neq 1>
			<cfquery name="add_1" datasource="#dsn#" result="MAX_ID">
				INSERT INTO 
				EMPLOYEES
					(
						EMPLOYEE_STATUS,
						<!---MEMBER_CODE,--->
						EMPLOYEE_NO,
						EMPLOYEE_NAME,
						EMPLOYEE_SURNAME,
						EMPLOYEE_USERNAME,
						EMPLOYEE_EMAIL,
						GROUP_STARTDATE,
						KIDEM_DATE,
						IZIN_DATE,
						EMPLOYEE_STAGE,
						MOBILCODE,
						MOBILTEL,
						EXTENSION,
						HIERARCHY,
						RECORD_DATE,
						RECORD_EMP,
						RECORD_IP
					)
				VALUES
					(
						1,
						<!---'#member_code#',--->
						'#calisan_no#',
						'#e_name#',
						'#e_surname#',
						'#user_name#',
						'#e_mail#',
						<cfif len(grup_tarih) and (grup_tarih neq 0) and isdate(grup_tarih)>#CreateODBCDateTime(grup_tarih)#<cfelse>NULL</cfif>,
						<cfif len(kidem_tarih) and (kidem_tarih neq 0) and isdate(kidem_tarih)>#CreateODBCDateTime(kidem_tarih)#<cfelse>NULL</cfif>,
						<cfif len(izin_tarih) and (izin_tarih neq 0) and isdate(izin_tarih)>#CreateODBCDateTime(izin_tarih)#<cfelse>NULL</cfif>,
						<cfif isdefined('attributes.process_stage')>#attributes.process_stage#<cfelse>NULL</cfif>,
						<cfif len(mobiletel_code) and mobiletel_code is not '*****'>'#mobiletel_code#'<cfelse>NULL</cfif>,
						<cfif len(mobiletel) and mobiletel is not '*****'>'#mobiletel#'<cfelse>NULL</cfif>,
						<cfif len(extension)>'#extension#'<cfelse>NULL</cfif>,
						<cfif len(hierarchy)>'#hierarchy#'<cfelse>NULL</cfif>,
						#now()#,
						#SESSION.EP.USERID#,
						'#CGI.REMOTE_ADDR#'
					)		
			</cfquery>
			<cfset get_max_emp_.MAX_ID = MAX_ID.IDENTITYCOL>

			<cfif len(dogum_tarihi) and (dogum_tarihi neq 0) and isdate(dogum_tarihi)><cf_date tarih='dogum_tarihi'></cfif>
			<cfif len(given_date) and (given_date neq 0) and isdate(given_date)><cf_date tarih='given_date'></cfif>
			<cfif len(birth_city)>
				<cfquery name="get_id_from_city" datasource="#dsn#">
					SELECT CITY_ID FROM SETUP_CITY WHERE CITY_NAME = '#birth_city#'
				</cfquery>
			</cfif>
			<cfquery name="add_2" datasource="#dsn#">
				INSERT INTO 
				EMPLOYEES_IDENTY
					(
						EMPLOYEE_ID,
						TC_IDENTY_NO,
						SOCIALSECURITY_NO,
						<cfif len(medeni_hal)>MARRIED,</cfif>
						SERIES,
						NUMBER,
						FATHER,
						MOTHER,
						BIRTH_DATE,
						BIRTH_PLACE,
						CITY,
						COUNTY,
						BINDING,
						FAMILY,
						CUE,
						BLOOD_TYPE,
						RELIGION,
						LAST_SURNAME,
						BIRTH_CITY,
						WARD,
						VILLAGE,
						GIVEN_PLACE,
						GIVEN_REASON,
						RECORD_NUMBER,
						GIVEN_DATE,
						RECORD_DATE,
						RECORD_EMP,
						RECORD_IP
					)
				VALUES
					(
						#get_max_emp_.max_id#,
						<cfif len(tc_kimlik)>'#tc_kimlik_#'<cfelse>NULL</cfif>,
						<cfif len(ssk_no)>'#ssk_no#'<cfelse>NULL</cfif>,
						<cfif len(medeni_hal)>#medeni_hal#,</cfif>
						<cfif len(nufus_seri)>'#nufus_seri#'<cfelse>NULL</cfif>,
						<cfif len(nufus_no)>'#nufus_no#'<cfelse>NULL</cfif>,
						<cfif len(father)>'#father#'<cfelse>NULL</cfif>,
						<cfif len(mother)>'#mother#'<cfelse>NULL</cfif>,
						<cfif len(dogum_tarihi) and (dogum_tarihi neq 0) and isdate(dogum_tarihi)>#dogum_tarihi#<cfelse>NULL</cfif>,
						<cfif len(dogum_yeri)>'#dogum_yeri#'<cfelse>NULL</cfif>,
						<cfif len(nufus_il)>'#nufus_il#'<cfelse>NULL</cfif>,
						<cfif len(nufus_ilce)>'#nufus_ilce#'<cfelse>NULL</cfif>,
						<cfif len(nufus_cilt_no)>'#nufus_cilt_no#'<cfelse>NULL</cfif>,
						<cfif len(nufus_aile_no)>'#nufus_aile_no#'<cfelse>NULL</cfif>,
						<cfif len(nufus_sira_no)>'#nufus_sira_no#'<cfelse>NULL</cfif>,
						<cfif len(blood_type) and blood_type is not '*****'>#blood_type#<cfelse>NULL</cfif>,
						<cfif len(din)>'#din#'<cfelse>NULL</cfif>,
						<cfif len(last_surname)>'#last_surname#'<cfelse>NULL</cfif>,
						<cfif isdefined('get_id_from_city.city_id') and len(get_id_from_city.city_id)>#get_id_from_city.city_id#<cfelse>NULL</cfif>,
						<!---<cfif len(birth_city)>#birth_city#<cfelse>NULL</cfif>,--->
						<cfif len(ward)>'#ward#'<cfelse>NULL</cfif>,
						<cfif len(village)>'#village#'<cfelse>NULL</cfif>,
						<cfif len(given_place)>'#given_place#'<cfelse>NULL</cfif>,
						<cfif len(given_reason)>'#given_reason#'<cfelse>NULL</cfif>,
						<cfif len(record_number)>'#record_number#'<cfelse>NULL</cfif>,
						<cfif len(given_date) and (given_date neq 0) and isdate(given_date)>#given_date#<cfelse>NULL</cfif>,
						#now()#,
						#SESSION.EP.USERID#,
						'#CGI.REMOTE_ADDR#'
					)		
			</cfquery>
			<cfif len(home_country)>
				<cfquery name="get_id_from_setupcountry" datasource="#dsn#">
					SELECT COUNTRY_ID FROM SETUP_COUNTRY WHERE COUNTRY_NAME = '#home_country#'
				</cfquery>
			</cfif>
			<cfif len(home_city)>
				<cfquery name="get_id_from_setupcity" datasource="#dsn#">
					SELECT CITY_ID FROM SETUP_CITY WHERE CITY_NAME = '#home_city#'
				</cfquery>
			</cfif>
			<cfif len(home_area)>
				<cfquery name="get_id_from_setupcounty" datasource="#dsn#">
					SELECT COUNTY_ID FROM SETUP_COUNTY WHERE COUNTY_NAME = '#home_area#'
				</cfquery>
			</cfif>
			<cfquery name="add_3" datasource="#dsn#">
				INSERT INTO 
				EMPLOYEES_DETAIL
					(
						EMPLOYEE_ID,
						SEX,
						HOMEADDRESS,
						HOMEPOSTCODE,
						HOMECOUNTY,
						HOMECITY,
						HOMECOUNTRY,
						HOMETEL_CODE,
						HOMETEL,
						MILITARY_STATUS,
						EMAIL_SPC,
						MOBILCODE_SPC,
						MOBILTEL_SPC,
						LAST_SCHOOL
						<!--- HOMECOUNTRY --->
					)
				VALUES
					(
						#get_max_emp_.max_id#,
						<cfif len(cinsiyet)>#cinsiyet#<cfelse>1</cfif>,
						<cfif len(home_adres)>'#home_adres#'<cfelse>NULL</cfif>,
						<cfif len(homepostcode)>'#homepostcode#'<cfelse>NULL</cfif>,
						<cfif isdefined("get_id_from_setupcounty.COUNTY_ID") and len(get_id_from_setupcounty.COUNTY_ID)>#get_id_from_setupcounty.COUNTY_ID#<cfelse>NULL</cfif>,
						<cfif isdefined("get_id_from_setupcity.CITY_ID") and len(get_id_from_setupcity.CITY_ID)>#get_id_from_setupcity.CITY_ID#<cfelse>NULL</cfif>,
						<cfif isdefined("get_id_from_setupcountry.COUNTRY_ID") and len(get_id_from_setupcountry.COUNTRY_ID)>#get_id_from_setupcountry.COUNTRY_ID#<cfelse>NULL</cfif>,
						'#home_phone_code#',
						'#home_phone#',
						<cfif len(military_status) and military_status is not '*****'>#military_status#<cfelse>NULL</cfif>,
						<cfif len(e_mail_kisisel)>'#e_mail_kisisel#'<cfelse>NULL</cfif>,
						<cfif len(mobiletelspc_code)>'#mobiletelspc_code#'<cfelse>NULL</cfif>,
						<cfif len(mobiletelspc)>'#mobiletelspc#'<cfelse>NULL</cfif>,
						<cfif len(last_school)>#last_school#<cfelse>NULL</cfif>
						<!--- 1 --->
					)
			</cfquery>
			<cfquery name="add_4" datasource="#DSN#">
				INSERT INTO
					MY_SETTINGS
					(
						EMPLOYEE_ID,
						DAY_AGENDA,
						MAIN_NEWS,
						TIME_ZONE,
						LANGUAGE_ID,
						INTERFACE_ID,
						INTERFACE_COLOR,
						AGENDA,
						POLL_NOW,
						MYWORKS,
						MY_VALIDS,
						MY_BUYERS,
						MY_SELLERS,
						MAXROWS,
						TIMEOUT_LIMIT
					)
				VALUES
					(
						#get_max_emp_.max_id#,
						1,
						1,
						2,
						'tr',
						3,
						1,
						1,
						1,
						1,
						1,
						1,
						1,
						20,
						30
					)
			</cfquery>
			<cfset attributes.ini_employee_id = get_max_emp_.max_id>
			<cfinclude template="../../../myhome/query/initialize_menu_positions.cfm">
			<cfquery name="get_max_emp_" datasource="#dsn#">
				SELECT MAX(EMPLOYEE_ID) MAX_ID FROM EMPLOYEES
			</cfquery>
			<cfquery name="UPD_MEMBER_CODE" datasource="#dsn#">
				UPDATE EMPLOYEES SET MEMBER_CODE = <cfqueryparam cfsqltype="cf_sql_varchar" value="E#get_max_emp_.MAX_ID#"> WHERE EMPLOYEE_ID = #get_max_emp_.MAX_ID#
			</cfquery>        
			<cfif real_number eq 1>
				<cfquery name="get_max_no" datasource="#dsn#">
					SELECT EMPLOYEE_NO FROM EMPLOYEES WHERE EMPLOYEE_ID = #get_max_emp_.MAX_ID#
				</cfquery>
				<cfset employee_no_last = listgetat(get_max_no.employee_no,2,'-')>
				<cfquery name="UPD_GEN_PAP" datasource="#DSN#">
					UPDATE 
						GENERAL_PAPERS_MAIN
					SET
						EMPLOYEE_NUMBER = #employee_no_last#
					WHERE
						EMPLOYEE_NUMBER IS NOT NULL
				</cfquery>
			</cfif>
			<!--- Adres Defteri--->
				<cf_addressbook
				design		= "1"
				type		= "1"
				type_id		= "#get_max_emp_.max_id#"
				name		= "#e_name#"
				surname		= "#e_surname#"
				email		= "#e_mail#"
				mobilcode	= "#mobiletel_code#"
				mobilno		= "#mobiletel#">
		</cfif>
		<cfif error_flag2 neq 1>
			<cfset satir_no = satir_no + 1> 
		<cfelse><BR /><BR />
			<cfoutput>#tc_kimlik_#</cfoutput> Tc Kimlik Nolu Kişi Sistemde Mevcut Olduğundan <cfoutput>#i#</cfoutput>. Satır Çalışan Olarak Eklenmemiştir.<br/>
		</cfif> 
			<!---<cfcatch type="Any"> 
				<cfoutput>#i#</cfoutput>. satır 2. adımda sorun oluştu.<br/>
				<cfif error_flag2 eq 1>
					Aynı Tc Kimlik Nolu Kişi Çalışan Olarak Eklenmiştir.<br/>
				</cfif>
				<cfset error_flag = 1>
			</cfcatch>
		</cftry> --->
	</cfif>
	<!--- Adres Defteri
	<cf_addressbook
		design		= "1"
		type		= "1"
		type_id		= "#get_max_emp_.max_id#"
		name		= "#e_name#"
		surname		= "#e_surname#"
		email		= "#e_mail#"
		mobilcode	= "#mobiletel_code#"
		mobilno		= "#mobiletel#"> --->
</cfloop> 
<cfoutput><BR /><BR />#satir_no# ** Çalışan İmport Edildi !!!</cfoutput><cfabort>
