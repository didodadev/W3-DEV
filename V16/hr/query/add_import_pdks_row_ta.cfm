<!--- Teknik Alüminyum PDKS Import MG: 20110510 --->

<cfscript>
	bulunamayan_listesi = '';

	// EMPLOYEE_DAILY_IN_OUT Tablosundaki IS_WEEK_REST_DAY alanına yazılacak değerler.
	normal_mesai_tipi = "";
	htatili_mesai_tipi = 0;
	gtatil_mesai_tipi = 1;

	// OFFTIME Tablosundaki OFFTIMECAT_ID alanına yazılacak değerler.
	devamsizlik_saati_kat_id = 9;
	ucretli_izin_saati_kat_id = 1;
	ucretsiz_izin_saati_kat_id = 0;
	vizite_izin_saati_kat_id = 18;
	rapor_izin_saati_kat_id = 3;
	yillik_izin_saati_kat_id = -1;
	evlenme_izin_saati_kat_id = 14;
	olum_izin_saati_kat_id = 15;
	dogum_izin_saati_kat_id = 16;
	mazeret_izin_saati_kat_id = 17;

	// EMPLOYEES_EXT_WORKTIMES Tablosundaki DAY_TYPE alanına yazılacak değerler.
	genel_tatil_fazla_mesai_tipi = 2;
	normal_fazla_mesai_tipi = 0;
	htatili_fazla_mesai_tipi = 1;
	gece_calismasi_fazla_mesai_tipi = 3;

	offtime_stage_value = 99;
</cfscript>
<cfloop from="2" to="#line_count#" index="i">
	<cfset kont=1>
	<cftry>
		<cfset dosyam = Replace(dosya1[i],';;',';0;','all')>
		<cfset dosyam = Replace(dosyam,';;',';0;','all')>
		<cfset pdks_no = trim(listgetat(dosyam,1,';'))>
		<cfset baslama_tarih_1 = trim(listgetat(dosyam,4,';'))>
		<cfset gun = listgetat(baslama_tarih_1,1,'.')>
		<cfset ay = listgetat(baslama_tarih_1,2,'.')>
		<cfset yil = listgetat(baslama_tarih_1,3,'.')>
		<cfset baslama_tarih_ = createodbcdatetime(createdatetime(yil,ay,gun,6,0,0))>

		<cfset normal_mesai_saati = trim(listgetat(dosyam,6,';'))>
		<cfset hafta_tatili_mesai_saati = trim(listgetat(dosyam,8,';'))>
		<cfset genel_tatil_mesai_saati = trim(listgetat(dosyam,23,';'))>

		<cfset normal_fazla_mesai_saati = trim(listgetat(dosyam,10,';'))>
		<cfset hafta_tatili_fazla_mesai_saati = trim(listgetat(dosyam,13,';'))>
		<cfset genel_tatil_fazla_mesai_saati = trim(listgetat(dosyam,12,';'))>
		<cfset gece_calismasi_fazla_mesai_saati = trim(listgetat(dosyam,11,';'))>

		<cfset devamsizlik_saati = trim(listgetat(dosyam,7,';'))> <!--- KatID = 9 --->
		<cfset ucretli_izin_saati = trim(listgetat(dosyam,14,';'))> <!--- KatID = 1 --->
		<cfset ucretsiz_izin_saati = trim(listgetat(dosyam,15,';'))> <!--- KatID = 0 --->
		<cfset vizite_izin_saati = trim(listgetat(dosyam,16,';'))> <!--- KatID = 18 --->
		<cfset rapor_izin_saati = trim(listgetat(dosyam,17,';'))> <!--- KatID = 3 --->
		<cfset yillik_izin_saati = trim(listgetat(dosyam,18,';'))> <!--- KatID = -1 --->
		<cfset evlenme_izin_saati = trim(listgetat(dosyam,19,';'))> <!--- KatID = 14 --->
		<cfset olum_izin_saati = trim(listgetat(dosyam,20,';'))> <!--- KatID = 15 --->
		<cfset dogum_izin_saati = trim(listgetat(dosyam,21,';'))> <!--- KatID = 16 --->
		<cfset mazeret_izin_saati = trim(listgetat(dosyam,22,';'))> <!--- KatID = 17 --->
		<cfset offtime_stage_value = trim(listgetat(dosyam,25,';'))> <!--- Süreç ID --->
		<cfset cat_id = trim(listgetat(dosyam,26,';'))> <!--- Kategori ID --->
		<cfset devamsizlik_saati_kat_id = cat_id>
		<cfset ucretli_izin_saati_kat_id = cat_id>
		<cfset ucretsiz_izin_saati_kat_id = cat_id>
		<cfset vizite_izin_saati_kat_id = cat_id>
		<cfset rapor_izin_saati_kat_id = cat_id>
		<cfset yillik_izin_saati_kat_id = cat_id>
		<cfset evlenme_izin_saati_kat_id = cat_id>
		<cfset olum_izin_saati_kat_id = cat_id>
		<cfset dogum_izin_saati_kat_id = cat_id>
		<cfset mazeret_izin_saati_kat_id = cat_id>
		<cfcatch type="Any">
			<cfset kont=0>
			<cfoutput>#i#.satır okuma esnasında hata verdi. : #dosya1[i]# - #listlen(dosya1[i],';')#</cfoutput> <br />
		</cfcatch>
	</cftry>
	<cfif kont eq 1>
			<cfquery name="get_in_out" dbtype="query" maxrows="1">
				SELECT EMPLOYEE_ID,IN_OUT_ID,BRANCH_ID FROM get_in_outs WHERE PDKS_NUMBER = '#pdks_no#' OR EMPLOYEE_NO = '#pdks_no#' ORDER BY FINISH_DATE DESC
			</cfquery>
			<cfif get_in_out.recordcount>

				<!--- *** MESAİ SAATLERİ *** --->

					<!--- NORMAL GÜN MESAİ SAATİ --->
				<cfif normal_mesai_saati is not "0">
					<cfif listlen(normal_mesai_saati,':') eq 2>
						<cfset saat_ = listfirst(normal_mesai_saati,':')>
						<cfset dakika_ = listlast(normal_mesai_saati,':')>
					<cfelse>
						<cfset saat_ = normal_mesai_saati>
						<cfset dakika_ = 0>
					</cfif>
					<cfset bitis_tarihi_ = dateadd('h',saat_,baslama_tarih_)>
					<cfset bitis_tarihi_ = dateadd('n',dakika_,bitis_tarihi_)>
					<cfquery name="add_row" datasource="#dsn#">
						INSERT INTO 
							EMPLOYEE_DAILY_IN_OUT
							(
								FILE_ID,
								EMPLOYEE_ID,
								IN_OUT_ID,
								BRANCH_ID,
								START_DATE,
								FINISH_DATE,
								IS_WEEK_REST_DAY,
								RECORD_DATE,
								RECORD_EMP,
								RECORD_IP
							)
							VALUES
							(
								<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.i_id#">,
								#get_in_out.employee_id#,
								#get_in_out.in_out_id#,
								#get_in_out.branch_id#,
								#baslama_tarih_#,
								#bitis_tarihi_#,
								<cfif Len(normal_mesai_tipi) gt 0>#normal_mesai_tipi#<cfelse>NULL</cfif>,
								#now()#,
								#session.ep.userid#,
								'#cgi.REMOTE_ADDR#'
							)
					</cfquery>
					<cfoutput>Normal Mesai Saati: #normal_mesai_saati#<br /></cfoutput>
				</cfif>

				<!--- HAFTA TATİLİ MESAİ SAATİ --->
                
				<cfif hafta_tatili_mesai_saati is not "0">
					<cfif listlen(hafta_tatili_mesai_saati,':') eq 2>
						<cfset saat_ = listfirst(hafta_tatili_mesai_saati,':')>
						<cfset dakika_ = listlast(hafta_tatili_mesai_saati,':')>
					<cfelse>
						<cfset saat_ = hafta_tatili_mesai_saati>
						<cfset dakika_ = 0>
					</cfif>
					<cfset bitis_tarihi_ = dateadd('h',saat_,baslama_tarih_)>
					<cfset bitis_tarihi_ = dateadd('n',dakika_,bitis_tarihi_)>
					<cfquery name="add_row" datasource="#dsn#">
						INSERT INTO 
							EMPLOYEE_DAILY_IN_OUT
							(
								FILE_ID,
								EMPLOYEE_ID,
								IN_OUT_ID,
								BRANCH_ID,
								START_DATE,
								FINISH_DATE,
								IS_WEEK_REST_DAY,
								RECORD_DATE,
								RECORD_EMP,
								RECORD_IP
							)
							VALUES
							(
								<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.i_id#">,
								#get_in_out.employee_id#,
								#get_in_out.in_out_id#,
								#get_in_out.branch_id#,
								#baslama_tarih_#,
								#bitis_tarihi_#,
								#htatili_mesai_tipi#,
								#now()#,
								#session.ep.userid#,
								'#cgi.REMOTE_ADDR#'
							)
					</cfquery>
					<cfoutput>Hafta Tatili Mesai saati: #hafta_tatili_mesai_saati#<br /></cfoutput>
				</cfif>

				<!--- GENEL TATİL MESAİ SAATİ --->
                
				<cfif genel_tatil_mesai_saati is not "0">
					<cfif listlen(genel_tatil_mesai_saati,':') eq 2>
						<cfset saat_ = listfirst(genel_tatil_mesai_saati,':')>
						<cfset dakika_ = listlast(genel_tatil_mesai_saati,':')>
					<cfelse>
						<cfset saat_ = genel_tatil_mesai_saati>
						<cfset dakika_ = 0>
					</cfif>
					<cfset bitis_tarihi_ = dateadd('h',saat_,baslama_tarih_)>
					<cfset bitis_tarihi_ = dateadd('n',dakika_,bitis_tarihi_)>
					<cfquery name="add_row" datasource="#dsn#">
						INSERT INTO 
							EMPLOYEE_DAILY_IN_OUT
							(
								FILE_ID,
								EMPLOYEE_ID,
								IN_OUT_ID,
								BRANCH_ID,
								START_DATE,
								FINISH_DATE,
								IS_WEEK_REST_DAY,
								RECORD_DATE,
								RECORD_EMP,
								RECORD_IP
							)
							VALUES
							(
								<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.i_id#">,
								#get_in_out.employee_id#,
								#get_in_out.in_out_id#,
								#get_in_out.branch_id#,
								#baslama_tarih_#,
								#bitis_tarihi_#,
								#gtatil_mesai_tipi#,
								#now()#,
								#session.ep.userid#,
								'#cgi.REMOTE_ADDR#'
							)
					</cfquery>
					<cfoutput>Genel Tatil Mesai Saati: #genel_tatil_mesai_saati#<br /></cfoutput>
				</cfif>

				<!--- *** FAZLA MESAİ SAATLERİ *** --->

					<!--- FAZLA MESAİ (GENEL TATİL) --->

				<cfif genel_tatil_fazla_mesai_saati is not "0">
					<cfif listlen(genel_tatil_fazla_mesai_saati,':') eq 2>
						<cfset saat_ = listfirst(genel_tatil_fazla_mesai_saati,':')>
						<cfset dakika_ = listlast(genel_tatil_fazla_mesai_saati,':')>
					<cfelse>
						<cfset saat_ = genel_tatil_fazla_mesai_saati>
						<cfset dakika_ = 0>
					</cfif>
					<cfset baslama_tarih_ = createodbcdatetime(createdatetime(yil,ay,gun,6,0,0))>
					<cfset bitis_tarihi_ = dateadd('h',saat_,baslama_tarih_)>
					<cfset bitis_tarihi_ = dateadd('n',dakika_,bitis_tarihi_)>

					<cfquery name="add_worktime" datasource="#dsn#">
						INSERT INTO
							EMPLOYEES_EXT_WORKTIMES
							(
								IS_PUANTAJ_OFF,
								IS_FROM_PDKS,
								PDKS_FILE_ID,
								EMPLOYEE_ID,
								START_TIME,
								END_TIME,
								DAY_TYPE,
								RECORD_DATE,
								RECORD_EMP,
								RECORD_IP,
								IN_OUT_ID,
								VALID,
								VALIDDATE,
								VALID_EMPLOYEE_ID
							)
						VALUES
							(
								0,
								1,
								<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.i_id#">,
								#get_in_out.employee_id#,
								#baslama_tarih_#,
								#bitis_tarihi_#,
								#genel_tatil_fazla_mesai_tipi#,
								#now()#,
								#session.ep.userid#,
								'#cgi.REMOTE_ADDR#',
								#get_in_out.in_out_id#,
								1,
								#now()#,
								#session.ep.userid#
							)
					</cfquery>
					<cfoutput><br />FMesai, Genel Tatil: #genel_tatil_fazla_mesai_saati#</cfoutput>
				</cfif>

				<!--- FAZLA MESAİ (NORMAL GÜN) --->

				<cfif normal_fazla_mesai_saati is not "0">
					<cfif listlen(normal_fazla_mesai_saati,':') eq 2>
						<cfset saat_ = listfirst(normal_fazla_mesai_saati,':')>
						<cfset dakika_ = listlast(normal_fazla_mesai_saati,':')>
					<cfelse>
						<cfset saat_ = normal_fazla_mesai_saati>
						<cfset dakika_ = 0>
					</cfif>

					<!---
						Diğer güne sarkmaması için, başlama tarihini fazla gelen saat kadar geri çek
						Ör: 28 Ocak 2011 16:00:00'da başlayıp, 8 saat süren bir mesai 29 Ocak 2011 00:00:00'a
						kaymaması için 24 - 8 - 1 = 15 hesabına göre 28 Ocak 2011 15:00:00 e çekiliyor.
					--->
					<cfset baslama_tarih_ = createodbcdatetime(createdatetime(yil,ay,gun,24 - saat_ - 1,0,0))>
					<cfset bitis_tarihi_ = dateadd('h',saat_,baslama_tarih_)>
					<cfset bitis_tarihi_ = dateadd('n',dakika_,bitis_tarihi_)>

					<cfquery name="add_worktime" datasource="#dsn#">
						INSERT INTO
							EMPLOYEES_EXT_WORKTIMES
							(
								IS_PUANTAJ_OFF,
								IS_FROM_PDKS,
								PDKS_FILE_ID,
								EMPLOYEE_ID,
								START_TIME,
								END_TIME,
								DAY_TYPE,
								RECORD_DATE,
								RECORD_EMP,
								RECORD_IP,
								IN_OUT_ID,
								VALID,
								VALIDDATE,
								VALID_EMPLOYEE_ID
							)
						VALUES
							(
								0,
								1,
								<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.i_id#">,
								#get_in_out.employee_id#,
								#baslama_tarih_#,
								#bitis_tarihi_#,
								#normal_fazla_mesai_tipi#,
								#now()#,
								#session.ep.userid#,
								'#cgi.REMOTE_ADDR#',
								#get_in_out.in_out_id#,
								1,
								#now()#,
								#session.ep.userid#
							)
					</cfquery>
					<cfoutput> FMesai, Normal: #normal_fazla_mesai_saati#</cfoutput>
				</cfif>

				<!--- FAZLA MESAİ (HAFTA TATİLİ) --->

				<cfif hafta_tatili_fazla_mesai_saati is not "0">
					<cfif listlen(hafta_tatili_fazla_mesai_saati,':') eq 2>
						<cfset saat_ = listfirst(hafta_tatili_fazla_mesai_saati,':')>
						<cfset dakika_ = listlast(hafta_tatili_fazla_mesai_saati,':')>
					<cfelse>
						<cfset saat_ = hafta_tatili_fazla_mesai_saati>
						<cfset dakika_ = 0>
					</cfif>
					<cfset baslama_tarih_ = createodbcdatetime(createdatetime(yil,ay,gun,6,0,0))>
					<cfset bitis_tarihi_ = dateadd('h',saat_,baslama_tarih_)>
					<cfset bitis_tarihi_ = dateadd('n',dakika_,bitis_tarihi_)>
					<cfquery name="add_worktime" datasource="#dsn#">
						INSERT INTO
							EMPLOYEES_EXT_WORKTIMES
							(
								IS_PUANTAJ_OFF,
								IS_FROM_PDKS,
								PDKS_FILE_ID,
								EMPLOYEE_ID,
								START_TIME,
								END_TIME,
								DAY_TYPE,
								RECORD_DATE,
								RECORD_EMP,
								RECORD_IP,
								IN_OUT_ID,
								VALID,
								VALIDDATE,
								VALID_EMPLOYEE_ID
							)
						VALUES
							(
								0,
								1,
								<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.i_id#">,
								#get_in_out.employee_id#,
								#baslama_tarih_#,
								#bitis_tarihi_#,
								#htatili_fazla_mesai_tipi#,
								#now()#,
								#session.ep.userid#,
								'#cgi.REMOTE_ADDR#',
								#get_in_out.in_out_id#,
								1,
								#now()#,
								#session.ep.userid#
							)
					</cfquery>
					<cfoutput> FMesai, Hafta Tatili: #hafta_tatili_fazla_mesai_saati#</cfoutput>
				</cfif>

				<!--- FAZLA MESAİ (GECE ÇALIŞMASI) --->

				<cfif gece_calismasi_fazla_mesai_saati is not "0">
					<cfif listlen(gece_calismasi_fazla_mesai_saati,':') eq 2>
						<cfset saat_ = listfirst(gece_calismasi_fazla_mesai_saati,':')>
						<cfset dakika_ = listlast(gece_calismasi_fazla_mesai_saati,':')>
					<cfelse>
						<cfset saat_ = gece_calismasi_fazla_mesai_saati>
						<cfset dakika_ = 0>
					</cfif>
					<cfset baslama_tarih_ = createodbcdatetime(createdatetime(yil,ay,gun,0,0,0))>
					<cfset bitis_tarihi_ = dateadd('h',saat_,baslama_tarih_)>
					<cfset bitis_tarihi_ = dateadd('n',dakika_,bitis_tarihi_)>
					<cfquery name="add_worktime" datasource="#dsn#">
						INSERT INTO
							EMPLOYEES_EXT_WORKTIMES
							(
								IS_PUANTAJ_OFF,
								IS_FROM_PDKS,
								PDKS_FILE_ID,
								EMPLOYEE_ID,
								START_TIME,
								END_TIME,
								DAY_TYPE,
								RECORD_DATE,
								RECORD_EMP,
								RECORD_IP,
								IN_OUT_ID,
								VALID,
								VALIDDATE,
								VALID_EMPLOYEE_ID
							)
						VALUES
							(
								0,
								1,
								<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.i_id#">,
								#get_in_out.employee_id#,
								#baslama_tarih_#,
								#bitis_tarihi_#,
								#gece_calismasi_fazla_mesai_tipi#,
								#now()#,
								#session.ep.userid#,
								'#cgi.REMOTE_ADDR#',
								#get_in_out.in_out_id#,
								1,
								#now()#,
								#session.ep.userid#
							)
					</cfquery>
					<cfoutput> FMesai, Gece Çalışması: #gece_calismasi_fazla_mesai_saati#</cfoutput>
				</cfif>

				<!--- *** İZİNLER *** --->

					<!--- İZİNLER (DEVAMSIZLIK) --->

				<cfif devamsizlik_saati is not "0">
					<cfif listlen(devamsizlik_saati,':') eq 2>
						<cfset saat_ = listfirst(devamsizlik_saati,':')>
						<cfset dakika_ = listlast(devamsizlik_saati,':')>
					<cfelse>
						<cfset saat_ = devamsizlik_saati>
						<cfset dakika_ = 0>
					</cfif>
					<cfset baslama_tarih_ = createodbcdatetime(createdatetime(yil,ay,gun,6,0,0))>
					<cfset bitis_tarihi_ = dateadd('h',saat_,baslama_tarih_)>
					<cfset bitis_tarihi_ = dateadd('n',dakika_,bitis_tarihi_)>
					<cfquery name="add_row" datasource="#dsn#">
						INSERT INTO
							OFFTIME
							(
								RECORD_IP,
								RECORD_EMP,
								RECORD_DATE,
								IN_OUT_ID,
								IS_PUANTAJ_OFF,
								IS_FROM_PDKS,
								PDKS_FILE_ID,
								EMPLOYEE_ID,
								OFFTIMECAT_ID,
								STARTDATE,
								FINISHDATE,
								WORK_STARTDATE,
								TOTAL_HOURS,
								VALIDATOR_POSITION_CODE,
								VALID,
								VALID_EMPLOYEE_ID,
								VALIDDATE,
								OFFTIME_STAGE,
								SUB_OFFTIMECAT_ID
							)
							VALUES
							(
								'#CGI.REMOTE_ADDR#',
								#SESSION.EP.USERID#,
								#NOW()#,
								#get_in_out.in_out_id#,
								0,
								1,
								<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.i_id#">,
								#get_in_out.employee_id#,
								#devamsizlik_saati_kat_id#,
								#baslama_tarih_#,
								#bitis_tarihi_#,
								#bitis_tarihi_#,
								0,
								#session.ep.position_code#,
								1,
								#SESSION.EP.USERID#,
								#NOW()#,
								#offtime_stage_value#,
								0
							)
					</cfquery>
					<cfoutput><br /><br />İzin, Devamsızlık: #devamsizlik_saati#</cfoutput>
				</cfif>

				<!--- İZİNLER (ÜCRETLİ İZİN) --->

				<cfif ucretli_izin_saati is not "0">
					<cfif listlen(ucretli_izin_saati,':') eq 2>
						<cfset saat_ = listfirst(ucretli_izin_saati,':')>
						<cfset dakika_ = listlast(ucretli_izin_saati,':')>
					<cfelse>
						<cfset saat_ = ucretli_izin_saati>
						<cfset dakika_ = 0>
					</cfif>
					<cfset baslama_tarih_ = createodbcdatetime(createdatetime(yil,ay,gun,6,0,0))>
					<cfset bitis_tarihi_ = dateadd('h',saat_,baslama_tarih_)>
					<cfset bitis_tarihi_ = dateadd('n',dakika_,bitis_tarihi_)>
					<cfquery name="add_row" datasource="#dsn#">
						INSERT INTO
							OFFTIME
							(
								RECORD_IP,
								RECORD_EMP,
								RECORD_DATE,
								IN_OUT_ID,
								IS_PUANTAJ_OFF,
								IS_FROM_PDKS,
								PDKS_FILE_ID,
								EMPLOYEE_ID,
								OFFTIMECAT_ID,
								STARTDATE,
								FINISHDATE,
								WORK_STARTDATE,
								TOTAL_HOURS,
								VALIDATOR_POSITION_CODE,
								VALID,
								VALID_EMPLOYEE_ID,
								VALIDDATE,
								OFFTIME_STAGE,
								SUB_OFFTIMECAT_ID
							)
							VALUES
							(
								'#CGI.REMOTE_ADDR#',
								#SESSION.EP.USERID#,
								#NOW()#,
								#get_in_out.in_out_id#,
								0,
								1,
								<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.i_id#">,
								#get_in_out.employee_id#,
								#ucretli_izin_saati_kat_id#,
								#baslama_tarih_#,
								#bitis_tarihi_#,
								#bitis_tarihi_#,
								0,
								#session.ep.position_code#,
								1,
								#SESSION.EP.USERID#,
								#NOW()#,
								#offtime_stage_value#,
								0
							)
					</cfquery>
					<cfoutput> İzin, Ücretli: #ucretli_izin_saati#</cfoutput>
				</cfif>

				<!--- İZİNLER (ÜCRETSİZ İZİN) --->

				<cfif ucretsiz_izin_saati is not "0">
					<cfif listlen(ucretsiz_izin_saati,':') eq 2>
						<cfset saat_ = listfirst(ucretsiz_izin_saati,':')>
						<cfset dakika_ = listlast(ucretsiz_izin_saati,':')>
					<cfelse>
						<cfset saat_ = ucretsiz_izin_saati>
						<cfset dakika_ = 0>
					</cfif>
					<cfset baslama_tarih_ = createodbcdatetime(createdatetime(yil,ay,gun,6,0,0))>
					<cfset bitis_tarihi_ = dateadd('h',saat_,baslama_tarih_)>
					<cfset bitis_tarihi_ = dateadd('n',dakika_,bitis_tarihi_)>
					<cfquery name="add_row" datasource="#dsn#">
						INSERT INTO
							OFFTIME
							(
								RECORD_IP,
								RECORD_EMP,
								RECORD_DATE,
								IN_OUT_ID,
								IS_PUANTAJ_OFF,
								IS_FROM_PDKS,
								PDKS_FILE_ID,
								EMPLOYEE_ID,
								OFFTIMECAT_ID,
								STARTDATE,
								FINISHDATE,
								WORK_STARTDATE,
								TOTAL_HOURS,
								VALIDATOR_POSITION_CODE,
								VALID,
								VALID_EMPLOYEE_ID,
								VALIDDATE,
								OFFTIME_STAGE,
								SUB_OFFTIMECAT_ID
							)
							VALUES
							(
								'#CGI.REMOTE_ADDR#',
								#SESSION.EP.USERID#,
								#NOW()#,
								#get_in_out.in_out_id#,
								0,
								1,
								<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.i_id#">,
								#get_in_out.employee_id#,
								#ucretsiz_izin_saati_kat_id#,
								#baslama_tarih_#,
								#bitis_tarihi_#,
								#bitis_tarihi_#,
								0,
								#session.ep.position_code#,
								1,
								#SESSION.EP.USERID#,
								#NOW()#,
								#offtime_stage_value#,
								0
							)
					</cfquery>
					<cfoutput> İzin, Ücretsiz: #ucretsiz_izin_saati#</cfoutput>
				</cfif>

				<!--- İZİNLER (VİZİTE İZNİ) --->

				<cfif vizite_izin_saati is not "0">
					<cfif listlen(vizite_izin_saati,':') eq 2>
						<cfset saat_ = listfirst(vizite_izin_saati,':')>
						<cfset dakika_ = listlast(vizite_izin_saati,':')>
					<cfelse>
						<cfset saat_ = vizite_izin_saati>
						<cfset dakika_ = 0>
					</cfif>
					<cfset baslama_tarih_ = createodbcdatetime(createdatetime(yil,ay,gun,6,0,0))>
					<cfset bitis_tarihi_ = dateadd('h',saat_,baslama_tarih_)>
					<cfset bitis_tarihi_ = dateadd('n',dakika_,bitis_tarihi_)>
					<cfquery name="add_row" datasource="#dsn#">
						INSERT INTO
							OFFTIME
							(
								RECORD_IP,
								RECORD_EMP,
								RECORD_DATE,
								IN_OUT_ID,
								IS_PUANTAJ_OFF,
								IS_FROM_PDKS,
								PDKS_FILE_ID,
								EMPLOYEE_ID,
								OFFTIMECAT_ID,
								STARTDATE,
								FINISHDATE,
								WORK_STARTDATE,
								TOTAL_HOURS,
								VALIDATOR_POSITION_CODE,
								VALID,
								VALID_EMPLOYEE_ID,
								VALIDDATE,
								OFFTIME_STAGE,
								SUB_OFFTIMECAT_ID
							)
							VALUES
							(
								'#CGI.REMOTE_ADDR#',
								#SESSION.EP.USERID#,
								#NOW()#,
								#get_in_out.in_out_id#,
								0,
								1,
								<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.i_id#">,
								#get_in_out.employee_id#,
								#vizite_izin_saati_kat_id#,
								#baslama_tarih_#,
								#bitis_tarihi_#,
								#bitis_tarihi_#,
								0,
								#session.ep.position_code#,
								1,
								#SESSION.EP.USERID#,
								#NOW()#,
								#offtime_stage_value#,
								0
							)
					</cfquery>
					<cfoutput> İzin, Vizite: #vizite_izin_saati#</cfoutput>
				</cfif>

				<!--- İZİNLER (RAPOR İZNİ) --->

				<cfif rapor_izin_saati is not "0">
					<cfif listlen(rapor_izin_saati,':') eq 2>
						<cfset saat_ = listfirst(rapor_izin_saati,':')>
						<cfset dakika_ = listlast(rapor_izin_saati,':')>
					<cfelse>
						<cfset saat_ = rapor_izin_saati>
						<cfset dakika_ = 0>
					</cfif>
					<cfset baslama_tarih_ = createodbcdatetime(createdatetime(yil,ay,gun,6,0,0))>
					<cfset bitis_tarihi_ = dateadd('h',saat_,baslama_tarih_)>
					<cfset bitis_tarihi_ = dateadd('n',dakika_,bitis_tarihi_)>
					<cfquery name="add_row" datasource="#dsn#">
						INSERT INTO
							OFFTIME
							(
								RECORD_IP,
								RECORD_EMP,
								RECORD_DATE,
								IN_OUT_ID,
								IS_PUANTAJ_OFF,
								IS_FROM_PDKS,
								PDKS_FILE_ID,
								EMPLOYEE_ID,
								OFFTIMECAT_ID,
								STARTDATE,
								FINISHDATE,
								WORK_STARTDATE,
								TOTAL_HOURS,
								VALIDATOR_POSITION_CODE,
								VALID,
								VALID_EMPLOYEE_ID,
								VALIDDATE,
								OFFTIME_STAGE,
								SUB_OFFTIMECAT_ID
							)
							VALUES
							(
								'#CGI.REMOTE_ADDR#',
								#SESSION.EP.USERID#,
								#NOW()#,
								#get_in_out.in_out_id#,
								0,
								1,
								<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.i_id#">,
								#get_in_out.employee_id#,
								#rapor_izin_saati_kat_id#,
								#baslama_tarih_#,
								#bitis_tarihi_#,
								#bitis_tarihi_#,
								0,
								#session.ep.position_code#,
								1,
								#SESSION.EP.USERID#,
								#NOW()#,
								#offtime_stage_value#,
								0
							)
					</cfquery>
					<cfoutput>; İzin, Rapor: #rapor_izin_saati#</cfoutput>
				</cfif>

				<!--- İZİNLER (YILLIK İZİN) --->

				<cfif yillik_izin_saati is not "0">
					<cfif listlen(yillik_izin_saati,':') eq 2>
						<cfset saat_ = listfirst(yillik_izin_saati,':')>
						<cfset dakika_ = listlast(yillik_izin_saati,':')>
					<cfelse>
						<cfset saat_ = yillik_izin_saati>
						<cfset dakika_ = 0>
					</cfif>
					<cfset baslama_tarih_ = createodbcdatetime(createdatetime(yil,ay,gun,6,0,0))>
					<cfset bitis_tarihi_ = dateadd('h',saat_,baslama_tarih_)>
					<cfset bitis_tarihi_ = dateadd('n',dakika_,bitis_tarihi_)>
					<cfquery name="add_row" datasource="#dsn#">
						INSERT INTO
							OFFTIME
							(
								RECORD_IP,
								RECORD_EMP,
								RECORD_DATE,
								IN_OUT_ID,
								IS_PUANTAJ_OFF,
								IS_FROM_PDKS,
								PDKS_FILE_ID,
								EMPLOYEE_ID,
								OFFTIMECAT_ID,
								STARTDATE,
								FINISHDATE,
								WORK_STARTDATE,
								TOTAL_HOURS,
								VALIDATOR_POSITION_CODE,
								VALID,
								VALID_EMPLOYEE_ID,
								VALIDDATE,
								OFFTIME_STAGE,
								SUB_OFFTIMECAT_ID
							)
							VALUES
							(
								'#CGI.REMOTE_ADDR#',
								#SESSION.EP.USERID#,
								#NOW()#,
								#get_in_out.in_out_id#,
								0,
								1,
								<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.i_id#">,
								#get_in_out.employee_id#,
								#yillik_izin_saati_kat_id#,
								#baslama_tarih_#,
								#bitis_tarihi_#,
								#bitis_tarihi_#,
								0,
								#session.ep.position_code#,
								1,
								#SESSION.EP.USERID#,
								#NOW()#,
								#offtime_stage_value#,
								0
							)
					</cfquery>
					<cfoutput>; İzin, Yıllık: #yillik_izin_saati# -#yillik_izin_saati_kat_id#-</cfoutput>
				</cfif>

				<!--- İZİNLER (EVLENME İZNİ) --->

				<cfif evlenme_izin_saati is not "0">
					<cfif listlen(evlenme_izin_saati,':') eq 2>
						<cfset saat_ = listfirst(evlenme_izin_saati,':')>
						<cfset dakika_ = listlast(evlenme_izin_saati,':')>
					<cfelse>
						<cfset saat_ = evlenme_izin_saati>
						<cfset dakika_ = 0>
					</cfif>
					<cfset baslama_tarih_ = createodbcdatetime(createdatetime(yil,ay,gun,6,0,0))>
					<cfset bitis_tarihi_ = dateadd('h',saat_,baslama_tarih_)>
					<cfset bitis_tarihi_ = dateadd('n',dakika_,bitis_tarihi_)>
					<cfquery name="add_row" datasource="#dsn#">
						INSERT INTO
							OFFTIME
							(
								RECORD_IP,
								RECORD_EMP,
								RECORD_DATE,
								IN_OUT_ID,
								IS_PUANTAJ_OFF,
								IS_FROM_PDKS,
								PDKS_FILE_ID,
								EMPLOYEE_ID,
								OFFTIMECAT_ID,
								STARTDATE,
								FINISHDATE,
								WORK_STARTDATE,
								TOTAL_HOURS,
								VALIDATOR_POSITION_CODE,
								VALID,
								VALID_EMPLOYEE_ID,
								VALIDDATE,
								OFFTIME_STAGE,
								SUB_OFFTIMECAT_ID
							)
							VALUES
							(
								'#CGI.REMOTE_ADDR#',
								#SESSION.EP.USERID#,
								#NOW()#,
								#get_in_out.in_out_id#,
								0,
								1,
								<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.i_id#">,
								#get_in_out.employee_id#,
								#evlenme_izin_saati_kat_id#,
								#baslama_tarih_#,
								#bitis_tarihi_#,
								#bitis_tarihi_#,
								0,
								#session.ep.position_code#,
								1,
								#SESSION.EP.USERID#,
								#NOW()#,
								#offtime_stage_value#,
								0
							)
					</cfquery>
					<cfoutput>; İzin, Evlilik: #evlenme_izin_saati#</cfoutput>
				</cfif>

				<!--- İZİNLER (ÖLÜM İZNİ) --->

				<cfif olum_izin_saati is not "0">
					<cfif listlen(olum_izin_saati,':') eq 2>
						<cfset saat_ = listfirst(olum_izin_saati,':')>
						<cfset dakika_ = listlast(olum_izin_saati,':')>
					<cfelse>
						<cfset saat_ = olum_izin_saati>
						<cfset dakika_ = 0>
					</cfif>
					<cfset baslama_tarih_ = createodbcdatetime(createdatetime(yil,ay,gun,6,0,0))>
					<cfset bitis_tarihi_ = dateadd('h',saat_,baslama_tarih_)>
					<cfset bitis_tarihi_ = dateadd('n',dakika_,bitis_tarihi_)>
					<cfquery name="add_row" datasource="#dsn#">
						INSERT INTO
							OFFTIME
							(
								RECORD_IP,
								RECORD_EMP,
								RECORD_DATE,
								IN_OUT_ID,
								IS_PUANTAJ_OFF,
								IS_FROM_PDKS,
								PDKS_FILE_ID,
								EMPLOYEE_ID,
								OFFTIMECAT_ID,
								STARTDATE,
								FINISHDATE,
								WORK_STARTDATE,
								TOTAL_HOURS,
								VALIDATOR_POSITION_CODE,
								VALID,
								VALID_EMPLOYEE_ID,
								VALIDDATE,
								OFFTIME_STAGE,
								SUB_OFFTIMECAT_ID
							)
							VALUES
							(
								'#CGI.REMOTE_ADDR#',
								#SESSION.EP.USERID#,
								#NOW()#,
								#get_in_out.in_out_id#,
								0,
								1,
								<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.i_id#">,
								#get_in_out.employee_id#,
								#olum_izin_saati_kat_id#,
								#baslama_tarih_#,
								#bitis_tarihi_#,
								#bitis_tarihi_#,
								0,
								#session.ep.position_code#,
								1,
								#SESSION.EP.USERID#,
								#NOW()#,
								#offtime_stage_value#,
								0
							)
					</cfquery>
					<cfoutput>; İzin, Ölüm: #olum_izin_saati#</cfoutput>
				</cfif>

				<!--- İZİNLER (DOĞUM İZNİ) --->

				<cfif dogum_izin_saati is not "0">
					<cfif listlen(dogum_izin_saati,':') eq 2>
						<cfset saat_ = listfirst(dogum_izin_saati,':')>
						<cfset dakika_ = listlast(dogum_izin_saati,':')>
					<cfelse>
						<cfset saat_ = dogum_izin_saati>
						<cfset dakika_ = 0>
					</cfif>
					<cfset baslama_tarih_ = createodbcdatetime(createdatetime(yil,ay,gun,6,0,0))>
					<cfset bitis_tarihi_ = dateadd('h',saat_,baslama_tarih_)>
					<cfset bitis_tarihi_ = dateadd('n',dakika_,bitis_tarihi_)>
					<cfquery name="add_row" datasource="#dsn#">
						INSERT INTO
							OFFTIME
							(
								RECORD_IP,
								RECORD_EMP,
								RECORD_DATE,
								IN_OUT_ID,
								IS_PUANTAJ_OFF,
								IS_FROM_PDKS,
								PDKS_FILE_ID,
								EMPLOYEE_ID,
								OFFTIMECAT_ID,
								STARTDATE,
								FINISHDATE,
								WORK_STARTDATE,
								TOTAL_HOURS,
								VALIDATOR_POSITION_CODE,
								VALID,
								VALID_EMPLOYEE_ID,
								VALIDDATE,
								OFFTIME_STAGE,
								SUB_OFFTIMECAT_ID
							)
							VALUES
							(
								'#CGI.REMOTE_ADDR#',
								#SESSION.EP.USERID#,
								#NOW()#,
								#get_in_out.in_out_id#,
								0,
								1,
								<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.i_id#">,
								#get_in_out.employee_id#,
								#dogum_izin_saati_kat_id#,
								#baslama_tarih_#,
								#bitis_tarihi_#,
								#bitis_tarihi_#,
								0,
								#session.ep.position_code#,
								1,
								#SESSION.EP.USERID#,
								#NOW()#,
								#offtime_stage_value#,
								0
							)
					</cfquery>
					<cfoutput>; İzin, Doğum: #dogum_izin_saati#</cfoutput>
				</cfif>

				<!--- İZİNLER (MAZERET İZNİ) --->

				<cfif mazeret_izin_saati is not "0">
					<cfif listlen(mazeret_izin_saati,':') eq 2>
						<cfset saat_ = listfirst(mazeret_izin_saati,':')>
						<cfset dakika_ = listlast(mazeret_izin_saati,':')>
					<cfelse>
						<cfset saat_ = mazeret_izin_saati>
						<cfset dakika_ = 0>
					</cfif>
					<cfset baslama_tarih_ = createodbcdatetime(createdatetime(yil,ay,gun,6,0,0))>
					<cfset bitis_tarihi_ = dateadd('h',saat_,baslama_tarih_)>
					<cfset bitis_tarihi_ = dateadd('n',dakika_,bitis_tarihi_)>
					<cfquery name="add_row" datasource="#dsn#">
						INSERT INTO
							OFFTIME
							(
								RECORD_IP,
								RECORD_EMP,
								RECORD_DATE,
								IN_OUT_ID,
								IS_PUANTAJ_OFF,
								IS_FROM_PDKS,
								PDKS_FILE_ID,
								EMPLOYEE_ID,
								OFFTIMECAT_ID,
								STARTDATE,
								FINISHDATE,
								WORK_STARTDATE,
								TOTAL_HOURS,
								VALIDATOR_POSITION_CODE,
								VALID,
								VALID_EMPLOYEE_ID,
								VALIDDATE,
								OFFTIME_STAGE,
								SUB_OFFTIMECAT_ID
							)
							VALUES
							(
								'#CGI.REMOTE_ADDR#',
								#SESSION.EP.USERID#,
								#NOW()#,
								#get_in_out.in_out_id#,
								0,
								1,
								<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.i_id#">,
								#get_in_out.employee_id#,
								#mazeret_izin_saati_kat_id#,
								#baslama_tarih_#,
								#bitis_tarihi_#,
								#bitis_tarihi_#,
								0,
								#session.ep.position_code#,
								1,
								#SESSION.EP.USERID#,
								#NOW()#,
								#offtime_stage_value#,
								0
							)
					</cfquery>
					<cfoutput>; İzin, Mazeret: #mazeret_izin_saati#</cfoutput>
				</cfif>
				<cfoutput>#i#.satır kişi (#pdks_no#) kayıt yapıldı!</cfoutput><br/><br />
			<cfelse>
				<cfoutput>#i#.satır kişi (#pdks_no#)bulunamadı!</cfoutput><br /><br />
				<cfset bulunamayan_listesi = listappend(bulunamayan_listesi,'#pdks_no#')>
			</cfif>
	</cfif>
</cfloop>
<cfoutput>Bulunamayanlar Listesi : #listdeleteduplicates(bulunamayan_listesi)#</cfoutput>
<br /><br />İşlem Tamamlandı!<br />