<!--- Tezcan için PDKS Import SG: 20121017 --->
<cffunction name="get_in_out_" access="public" returntype="query">
	<cfargument name="pdks_no" default="">
    <cfargument name="start_date" default="">
	<cfquery name="get_in_out" dbtype="query" maxrows="1">
		SELECT EMPLOYEE_ID,IN_OUT_ID,BRANCH_ID FROM get_in_outs WHERE (PDKS_NUMBER = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.pdks_no#"> OR EMPLOYEE_NO = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.pdks_no#"> ) AND START_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#arguments.start_date#"> ORDER BY START_DATE DESC
	</cfquery>
	<cfreturn get_in_out>
</cffunction>
<cfscript>
	bulunamayan_listesi = '';

	// EMPLOYEE_DAILY_IN_OUT Tablosundaki IS_WEEK_REST_DAY alanına yazılacak değerler.
	normal_mesai_tipi = "";
	htatili_mesai_tipi = 0;
	gtatil_mesai_tipi = 1;

	// OFFTIME Tablosundaki OFFTIMECAT_ID alanına yazılacak değerler.
	devamsizlik_saati_kat_id = 4;
	ucretli_izin_saati_kat_id = 6;
	ucretsiz_izin_saati_kat_id = 9;
	vizite_izin_saati_kat_id = 3;
	rapor_izin_saati_kat_id = 2;
	yillik_izin_saati_kat_id = 1;
	evlenme_izin_saati_kat_id = 7;
	olum_izin_saati_kat_id = 8;
	dogum_izin_saati_kat_id = 5;
	mazeret_izin_saati_kat_id = 10 ;

	// EMPLOYEES_EXT_WORKTIMES Tablosundaki DAY_TYPE alanına yazılacak değerler.
	genel_tatil_fazla_mesai_tipi = 2;
	normal_fazla_mesai_tipi = 0;
	htatili_fazla_mesai_tipi = 1;
	gece_calismasi_fazla_mesai_tipi = 3;

	offtime_stage_value = 245;
	
	for (i=2; i lte line_count; i++)
	{
		kont=1;
		try
		{
			dosyam = Replace(dosya1[i],';;',';0;','all');
			dosyam = Replace(dosyam,';;',';0;','all');
			pdks_no = trim(listgetat(dosyam,1,';'));
			baslama_tarih_1 = trim(listgetat(dosyam,4,';'));
			gun = listgetat(baslama_tarih_1,1,'.');
			ay = listgetat(baslama_tarih_1,2,'.');
			yil = listgetat(baslama_tarih_1,3,'.');
			baslama_tarih_ = createodbcdatetime(createdatetime(yil,ay,gun,6,0,0));
			normal_mesai_saati = trim(listgetat(dosyam,6,';'));
			hafta_tatili_mesai_saati = trim(listgetat(dosyam,8,';'));
			genel_tatil_mesai_saati = trim(listgetat(dosyam,23,';'));
			normal_fazla_mesai_saati = trim(listgetat(dosyam,10,';'));
			hafta_tatili_fazla_mesai_saati = trim(listgetat(dosyam,13,';'));
			genel_tatil_fazla_mesai_saati = trim(listgetat(dosyam,12,';'));
			gece_calismasi_fazla_mesai_saati = trim(listgetat(dosyam,11,';'));
			devamsizlik_saati = trim(listgetat(dosyam,7,';')); // KatID = 9
			ucretli_izin_saati = trim(listgetat(dosyam,14,';')); //KatID = 1
			ucretsiz_izin_saati = trim(listgetat(dosyam,15,';')); //KatID = 0
			vizite_izin_saati = trim(listgetat(dosyam,16,';')); //KatID = 18
			rapor_izin_saati = trim(listgetat(dosyam,17,';')); //KatID = 3
			yillik_izin_saati = trim(listgetat(dosyam,18,';')); //KatID = -1
			evlenme_izin_saati = trim(listgetat(dosyam,19,';')); //KatID = 14
			olum_izin_saati = trim(listgetat(dosyam,20,';')); //KatID = 15
			dogum_izin_saati = trim(listgetat(dosyam,21,';')); //KatID = 16
			mazeret_izin_saati = trim(listgetat(dosyam,22,';')); //KatID = 17
			gors =  trim(listgetat(dosyam,24,';'));
			fmks =  trim(listgetat(dosyam,25,';'));
			get_in_out = get_in_out_(pdks_no,baslama_tarih_);
			daily_in_out_action = createObject("component", "V16.hr.cfc.daily_in_out");
			daily_in_out_action.dsn = dsn;
			worktime_action = createObject("component", "V16.hr.cfc.employees_ext_worktimes");
			worktime_action.dsn = dsn;
			offtime_action = createObject("component", "V16.hr.cfc.offtime");
			offtime_action.dsn = dsn;
			if (kont eq 1)
			{
				if (get_in_out.recordcount)
				{
					// MESAİ SAATLERİ
					
					// NORMAL GÜN MESAİ SAATİ
					if (normal_mesai_saati is not "0")
					{
						bitis_tarihi_ = date_add('h',listfirst(normal_mesai_saati),baslama_tarih_);
						if (listlen(normal_mesai_saati) eq 2)
							bitis_tarihi_ = date_add('n',6*listlast(normal_mesai_saati),bitis_tarihi_);
						if (len(gors) and gors is not "0")
						{
							bitis_tarihi_ = date_add('h',listfirst(gors),bitis_tarihi_);
							if (listlen(gors) eq 2)
								bitis_tarihi_ = date_add('n',6*listlast(gors),bitis_tarihi_);
						}
						add_daily_in_out = daily_in_out_action.add_daily_in_out(
							file_id: attributes.i_id,
							employee_id: get_in_out.employee_id,
							in_out_id: get_in_out.in_out_id,
							branch_id: get_in_out.branch_id,
							start_date: baslama_tarih_,
							finish_date: bitis_tarihi_,
							is_week_rest_day: '#iif(len(normal_mesai_tipi),"normal_mesai_tipi",DE(""))#');
						writeoutput('Normal Mesai Saati: #normal_mesai_saati#<br />');
					}
					if (normal_mesai_saati eq "00:00" and listlen(normal_mesai_saati,':') eq 2) // 00:00 olan bir satır girildiginde kayıt atilir
					{
						bitis_tarihi_ = date_add('h',listfirst(normal_mesai_saati),baslama_tarih_);
						if (len(gors) and gors is not "0")
						{
							bitis_tarihi_ = date_add('h',listfirst(gors),bitis_tarihi_);
							if (listlen(gors) eq 2)
								bitis_tarihi_ = date_add('n',6*listlast(gors),bitis_tarihi_);
						}
						add_daily_in_out = daily_in_out_action.add_daily_in_out(
							file_id: attributes.i_id,
							employee_id: get_in_out.employee_id,
							in_out_id: get_in_out.in_out_id,
							branch_id: get_in_out.branch_id,
							start_date: baslama_tarih_,
							finish_date: bitis_tarihi_,
							is_week_rest_day: '#iif(len(normal_mesai_tipi),"normal_mesai_tipi",DE(""))#');
						writeoutput('Normal Mesai Saati: #normal_mesai_saati#<br />');
					}
					
					// HAFTA TATİLİ MESAİ SAATİ
					if (hafta_tatili_mesai_saati is not "0")
					{
						bitis_tarihi_ = date_add('h',listfirst(hafta_tatili_mesai_saati),baslama_tarih_);
						if (listlen(hafta_tatili_mesai_saati) eq 2)
							bitis_tarihi_ = date_add('n',6*listlast(hafta_tatili_mesai_saati),bitis_tarihi_);
						add_daily_in_out = daily_in_out_action.add_daily_in_out(
							file_id: attributes.i_id,
							employee_id: get_in_out.employee_id,
							in_out_id: get_in_out.in_out_id,
							branch_id: get_in_out.branch_id,
							start_date: baslama_tarih_,
							finish_date: bitis_tarihi_,
							is_week_rest_day: htatili_mesai_tipi);
						writeoutput('Hafta Tatili Mesai saati: #hafta_tatili_mesai_saati#<br />');
					}
					if (hafta_tatili_mesai_saati eq "00:00" and listlen(hafta_tatili_mesai_saati,":") eq 2)
					{
						bitis_tarihi_ = date_add('h',listfirst(hafta_tatili_mesai_saati),baslama_tarih_);
						if (listlen(hafta_tatili_mesai_saati) eq 2)
							bitis_tarihi_ = date_add('n',6*listlast(hafta_tatili_mesai_saati),bitis_tarihi_);
						add_daily_in_out = daily_in_out_action.add_daily_in_out(
							file_id: attributes.i_id,
							employee_id: get_in_out.employee_id,
							in_out_id: get_in_out.in_out_id,
							branch_id: get_in_out.branch_id,
							start_date: baslama_tarih_,
							finish_date: bitis_tarihi_,
							is_week_rest_day: htatili_mesai_tipi);
						writeoutput('Hafta Tatili Mesai saati: #hafta_tatili_mesai_saati#<br />');
					}
					
					// GENEL TATİL MESAİ SAATİ
					if (genel_tatil_mesai_saati is not "0")
					{
						bitis_tarihi_ = date_add('h',listfirst(genel_tatil_mesai_saati),baslama_tarih_);
						if (listlen(genel_tatil_mesai_saati) eq 2)
							bitis_tarihi_ = date_add('n',6*listlast(genel_tatil_mesai_saati),bitis_tarihi_);
						add_daily_in_out = daily_in_out_action.add_daily_in_out(
							file_id: attributes.i_id,
							employee_id: get_in_out.employee_id,
							in_out_id: get_in_out.in_out_id,
							branch_id: get_in_out.branch_id,
							start_date: baslama_tarih_,
							finish_date: bitis_tarihi_,
							is_week_rest_day: gtatil_mesai_tipi);
						writeoutput('Genel Tatil Mesai Saati: #genel_tatil_mesai_saati#<br />');
					}
					// FAZLA MESAİ SAATLERİ
					
					//FAZLA MESAİ (GENEL TATİL)
					if (genel_tatil_fazla_mesai_saati is not "0")
					{
						baslama_tarih_ = createodbcdatetime(createdatetime(yil,ay,gun,6,0,0));
						bitis_tarihi_ = date_add('h',listfirst(genel_tatil_fazla_mesai_saati),baslama_tarih_);
						if (listlen(genel_tatil_fazla_mesai_saati) eq 2)
							bitis_tarihi_ = date_add('n',6*listlast(genel_tatil_fazla_mesai_saati),bitis_tarihi_);
						add_worktime = worktime_action.add_worktime(
							is_puantaj_off: 0,
							is_from_pdks: 1,
							pdks_file_id: attributes.i_id,
							employee_id: get_in_out.employee_id,
							start_time: baslama_tarih_,
							end_time: bitis_tarihi_,
							day_type: genel_tatil_fazla_mesai_tipi,
							in_out_id: get_in_out.in_out_id,
							valid: 1,
							validdate: now(),
							valid_employee_id: session.ep.userid);
						writeoutput('<br />FMesai, Genel Tatil: #genel_tatil_fazla_mesai_saati#');
					}
					
					// FAZLA MESAİ (NORMAL GÜN)
					if (normal_fazla_mesai_saati is not "0")
					{
						baslama_tarih_ = createodbcdatetime(createdatetime(yil,ay,gun,24 - listfirst(normal_fazla_mesai_saati) - 1,0,0));
						bitis_tarihi_ = date_add('h',listfirst(normal_fazla_mesai_saati),baslama_tarih_);
						if (listlen(normal_fazla_mesai_saati) eq 2)
							bitis_tarihi_ = date_add('n',6*listlast(normal_fazla_mesai_saati),bitis_tarihi_);
						add_worktime = worktime_action.add_worktime(
							is_puantaj_off: 0,
							is_from_pdks: 1,
							pdks_file_id: attributes.i_id,
							employee_id: get_in_out.employee_id,
							start_time: baslama_tarih_,
							end_time: bitis_tarihi_,
							day_type: normal_fazla_mesai_tipi,
							in_out_id: get_in_out.in_out_id,
							valid: 1,
							validdate: now(),
							valid_employee_id: session.ep.userid);
						writeoutput('FMesai, Normal: #normal_fazla_mesai_saati#');
					}
					
					// FAZLA MESAİ (HAFTA TATİLİ)
					if (hafta_tatili_fazla_mesai_saati is not "0")
					{
						baslama_tarih_ = createodbcdatetime(createdatetime(yil,ay,gun,6,0,0));
						bitis_tarihi_ = date_add('h',listfirst(hafta_tatili_fazla_mesai_saati),baslama_tarih_);
						if (listlen(hafta_tatili_fazla_mesai_saati) eq 2)
							bitis_tarihi_ = date_add('n',6*listlast(hafta_tatili_fazla_mesai_saati),bitis_tarihi_);
						add_worktime = worktime_action.add_worktime(
							is_puantaj_off: 0,
							is_from_pdks: 1,
							pdks_file_id: attributes.i_id,
							employee_id: get_in_out.employee_id,
							start_time: baslama_tarih_,
							end_time: bitis_tarihi_,
							day_type: htatili_fazla_mesai_tipi,
							in_out_id: get_in_out.in_out_id,
							valid: 1,
							validdate: now(),
							valid_employee_id: session.ep.userid);
						writeoutput('FMesai, Hafta Tatili: #hafta_tatili_fazla_mesai_saati#');
					}
					
					// FAZLA MESAİ (GECE ÇALIŞMASI)
					if (gece_calismasi_fazla_mesai_saati is not "0")
					{
						baslama_tarih_ = createodbcdatetime(createdatetime(yil,ay,gun,0,0,0));
						bitis_tarihi_ = date_add('h',listfirst(gece_calismasi_fazla_mesai_saati),baslama_tarih_);
						if (listlen(gece_calismasi_fazla_mesai_saati) eq 2)
							bitis_tarihi_ = date_add('n',6*listlast(gece_calismasi_fazla_mesai_saati),bitis_tarihi_);
						add_worktime = worktime_action.add_worktime(
							is_puantaj_off: 0,
							is_from_pdks: 1,
							pdks_file_id: attributes.i_id,
							employee_id: get_in_out.employee_id,
							start_time: baslama_tarih_,
							end_time: bitis_tarihi_,
							day_type: gece_calismasi_fazla_mesai_tipi,
							in_out_id: get_in_out.in_out_id,
							valid: 1,
							validdate: now(),
							valid_employee_id: session.ep.userid);
						writeoutput('FMesai, Gece Çalışması: #gece_calismasi_fazla_mesai_saati#');
					}
					// İZİNLER
					
					// İZİNLER (DEVAMSIZLIK)
					if (devamsizlik_saati is not "0")
					{
						baslama_tarih_ = createodbcdatetime(createdatetime(yil,ay,gun,6,0,0));
						bitis_tarihi_ = date_add('h',listfirst(devamsizlik_saati),baslama_tarih_);
						if (listlen(devamsizlik_saati) eq 2)
							bitis_tarihi_ = date_add('n',6*listlast(devamsizlik_saati),bitis_tarihi_);
						add_offtime = offtime_action.add_offtime(
							is_puantaj_off: 0,
							is_from_pdks: 1,
							pdks_file_id: attributes.i_id,
							employee_id: get_in_out.employee_id,
							offtimecat_id: devamsizlik_saati_kat_id,
							startdate: baslama_tarih_,
							finishdate: bitis_tarihi_,
							work_startdate: bitis_tarihi_,
							total_hours: 0,
							validator_position_code: session.ep.position_code,
							valid: 1,
							valid_employee_id: session.ep.userid,
							validdate: now(),
							offtime_stage: offtime_stage_value);
						writeoutput('<br /><br />İzin, Devamsızlık: #devamsizlik_saati#');
					}
					
					// İZİNLER (ÜCRETLİ İZİN)
					if (ucretli_izin_saati is not "0" or fmks is not "0")
					{
						baslama_tarih_ = createodbcdatetime(createdatetime(yil,ay,gun,6,0,0));
						bitis_tarihi_ = date_add('h',listfirst(ucretli_izin_saati),baslama_tarih_);
						if (listlen(ucretli_izin_saati) eq 2)
							bitis_tarihi_ = date_add('n',6*listlast(ucretli_izin_saati),bitis_tarihi_);
						if (len(fmks) and fmks is not "0")
						{
							bitis_tarihi_ = date_add('h',listfirst(fmks),bitis_tarihi_);
							if (listlen(fmks) eq 2)
								bitis_tarihi_ = date_add('n',6*listlast(fmks),bitis_tarihi_);
						}
						add_offtime = offtime_action.add_offtime(
							is_puantaj_off: 0,
							is_from_pdks: 1,
							pdks_file_id: attributes.i_id,
							employee_id: get_in_out.employee_id,
							offtimecat_id: ucretli_izin_saati_kat_id,
							startdate: baslama_tarih_,
							finishdate: bitis_tarihi_,
							work_startdate: bitis_tarihi_,
							total_hours: 0,
							validator_position_code: session.ep.position_code,
							valid: 1,
							valid_employee_id: session.ep.userid,
							validdate: now(),
							offtime_stage: offtime_stage_value);
						writeoutput('İzin, Ücretli: #ucretli_izin_saati#');
					}
					
					// İZİNLER (ÜCRETSİZ İZİN)
					if (ucretsiz_izin_saati is not "0")
					{
						baslama_tarih_ = createodbcdatetime(createdatetime(yil,ay,gun,6,0,0));
						bitis_tarihi_ = date_add('h',listfirst(ucretsiz_izin_saati),baslama_tarih_);
						if (listlen(ucretsiz_izin_saati) eq 2)
							bitis_tarihi_ = date_add('n',6*listlast(ucretsiz_izin_saati),bitis_tarihi_);
						add_offtime = offtime_action.add_offtime(
							is_puantaj_off: 0,
							is_from_pdks: 1,
							pdks_file_id: attributes.i_id,
							employee_id: get_in_out.employee_id,
							offtimecat_id: ucretsiz_izin_saati_kat_id,
							startdate: baslama_tarih_,
							finishdate: bitis_tarihi_,
							work_startdate: bitis_tarihi_,
							total_hours: 0,
							validator_position_code: session.ep.position_code,
							valid: 1,
							valid_employee_id: session.ep.userid,
							validdate: now(),
							offtime_stage: offtime_stage_value);
						writeoutput('İzin, Ücretsiz: #ucretsiz_izin_saati#');
					}
					
					// İZİNLER (VİZİTE İZNİ)
					if (vizite_izin_saati is not "0")
					{
						baslama_tarih_ = createodbcdatetime(createdatetime(yil,ay,gun,6,0,0));
						bitis_tarihi_ = date_add('h',listfirst(vizite_izin_saati),baslama_tarih_);
						if (listlen(vizite_izin_saati) eq 2)
							bitis_tarihi_ = date_add('n',6*listlast(vizite_izin_saati),bitis_tarihi_);
						add_offtime = offtime_action.add_offtime(
							is_puantaj_off: 0,
							is_from_pdks: 1,
							pdks_file_id: attributes.i_id,
							employee_id: get_in_out.employee_id,
							offtimecat_id: vizite_izin_saati_kat_id,
							startdate: baslama_tarih_,
							finishdate: bitis_tarihi_,
							work_startdate: bitis_tarihi_,
							total_hours: 0,
							validator_position_code: session.ep.position_code,
							valid: 1,
							valid_employee_id: session.ep.userid,
							validdate: now(),
							offtime_stage: offtime_stage_value);
						writeoutput('İzin, Vizite: #vizite_izin_saati#');
					}
					
					// İZİNLER (RAPOR İZNİ)
					if (rapor_izin_saati is not "0")
					{
						baslama_tarih_ = createodbcdatetime(createdatetime(yil,ay,gun,6,0,0));
						bitis_tarihi_ = date_add('h',listfirst(rapor_izin_saati),baslama_tarih_);
						if (listlen(rapor_izin_saati) eq 2)
							bitis_tarihi_ = date_add('n',6*listlast(rapor_izin_saati),bitis_tarihi_);
						add_offtime = offtime_action.add_offtime(
							is_puantaj_off: 0,
							is_from_pdks: 1,
							pdks_file_id: attributes.i_id,
							employee_id: get_in_out.employee_id,
							offtimecat_id: rapor_izin_saati_kat_id,
							startdate: baslama_tarih_,
							finishdate: bitis_tarihi_,
							work_startdate: bitis_tarihi_,
							total_hours: 0,
							validator_position_code: session.ep.position_code,
							valid: 1,
							valid_employee_id: session.ep.userid,
							validdate: now(),
							offtime_stage: offtime_stage_value);
						writeoutput('; İzin, Rapor: #rapor_izin_saati#');
					}
					
					// İZİNLER (YILLIK İZİN)
					if (yillik_izin_saati is not "0")
					{
						baslama_tarih_ = createodbcdatetime(createdatetime(yil,ay,gun,6,0,0));
						bitis_tarihi_ = date_add('h',listfirst(yillik_izin_saati),baslama_tarih_);
						if (listlen(yillik_izin_saati) eq 2)
							bitis_tarihi_ = date_add('n',6*listlast(yillik_izin_saati),bitis_tarihi_);
						add_offtime = offtime_action.add_offtime(
							is_puantaj_off: 0,
							is_from_pdks: 1,
							pdks_file_id: attributes.i_id,
							employee_id: get_in_out.employee_id,
							offtimecat_id: yillik_izin_saati_kat_id,
							startdate: baslama_tarih_,
							finishdate: bitis_tarihi_,
							work_startdate: bitis_tarihi_,
							total_hours: 0,
							validator_position_code: session.ep.position_code,
							valid: 1,
							valid_employee_id: session.ep.userid,
							validdate: now(),
							offtime_stage: offtime_stage_value);
						writeoutput('; İzin, Yıllık: #yillik_izin_saati#');
					}
					
					// İZİNLER (EVLENME İZNİ)
					if (evlenme_izin_saati is not "0")
					{
						baslama_tarih_ = createodbcdatetime(createdatetime(yil,ay,gun,6,0,0));
						bitis_tarihi_ = date_add('h',listfirst(evlenme_izin_saati),baslama_tarih_);
						if (listlen(evlenme_izin_saati) eq 2)
							bitis_tarihi_ = date_add('n',6*listlast(evlenme_izin_saati),bitis_tarihi_);
						add_offtime = offtime_action.add_offtime(
							is_puantaj_off: 0,
							is_from_pdks: 1,
							pdks_file_id: attributes.i_id,
							employee_id: get_in_out.employee_id,
							offtimecat_id: evlenme_izin_saati_kat_id,
							startdate: baslama_tarih_,
							finishdate: bitis_tarihi_,
							work_startdate: bitis_tarihi_,
							total_hours: 0,
							validator_position_code: session.ep.position_code,
							valid: 1,
							valid_employee_id: session.ep.userid,
							validdate: now(),
							offtime_stage: offtime_stage_value);
						writeoutput('; İzin, Evlilik: #evlenme_izin_saati#');
					}
					
					// İZİNLER (ÖLÜM İZNİ)
					if (olum_izin_saati is not "0")
					{
						baslama_tarih_ = createodbcdatetime(createdatetime(yil,ay,gun,6,0,0));
						bitis_tarihi_ = date_add('h',listfirst(olum_izin_saati),baslama_tarih_);
						if (listlen(olum_izin_saati) eq 2)
							bitis_tarihi_ = date_add('n',6*listlast(olum_izin_saati),bitis_tarihi_);
						add_offtime = offtime_action.add_offtime(
							is_puantaj_off: 0,
							is_from_pdks: 1,
							pdks_file_id: attributes.i_id,
							employee_id: get_in_out.employee_id,
							offtimecat_id: olum_izin_saati_kat_id,
							startdate: baslama_tarih_,
							finishdate: bitis_tarihi_,
							work_startdate: bitis_tarihi_,
							total_hours: 0,
							validator_position_code: session.ep.position_code,
							valid: 1,
							valid_employee_id: session.ep.userid,
							validdate: now(),
							offtime_stage: offtime_stage_value);
						writeoutput('; İzin, Ölüm: #olum_izin_saati#');
					}
					
					// İZİNLER (DOĞUM İZNİ)
					if (dogum_izin_saati is not "0")
					{
						baslama_tarih_ = createodbcdatetime(createdatetime(yil,ay,gun,6,0,0));
						bitis_tarihi_ = date_add('h',listfirst(dogum_izin_saati),baslama_tarih_);
						if (listlen(dogum_izin_saati) eq 2)
							bitis_tarihi_ = date_add('n',6*listlast(dogum_izin_saati),bitis_tarihi_);
						add_offtime = offtime_action.add_offtime(
							is_puantaj_off: 0,
							is_from_pdks: 1,
							pdks_file_id: attributes.i_id,
							employee_id: get_in_out.employee_id,
							offtimecat_id: dogum_izin_saati_kat_id,
							startdate: baslama_tarih_,
							finishdate: bitis_tarihi_,
							work_startdate: bitis_tarihi_,
							total_hours: 0,
							validator_position_code: session.ep.position_code,
							valid: 1,
							valid_employee_id: session.ep.userid,
							validdate: now(),
							offtime_stage: offtime_stage_value);
						writeoutput('; İzin, Doğum: #dogum_izin_saati#');
					}
					
					// İZİNLER (MAZERET İZNİ)
					if (mazeret_izin_saati is not "0")
					{
						baslama_tarih_ = createodbcdatetime(createdatetime(yil,ay,gun,6,0,0));
						bitis_tarihi_ = date_add('h',listfirst(mazeret_izin_saati),baslama_tarih_);
						if (listlen(mazeret_izin_saati) eq 2)
							bitis_tarihi_ = date_add('n',6*listlast(mazeret_izin_saati),bitis_tarihi_);
						add_offtime = offtime_action.add_offtime(
							is_puantaj_off: 0,
							is_from_pdks: 1,
							pdks_file_id: attributes.i_id,
							employee_id: get_in_out.employee_id,
							offtimecat_id: mazeret_izin_saati_kat_id,
							startdate: baslama_tarih_,
							finishdate: bitis_tarihi_,
							work_startdate: bitis_tarihi_,
							total_hours: 0,
							validator_position_code: session.ep.position_code,
							valid: 1,
							valid_employee_id: session.ep.userid,
							validdate: now(),
							offtime_stage: offtime_stage_value);
						writeoutput('; İzin, Mazeret: #mazeret_izin_saati#');
					}
					writeoutput('#i#.satır kişi (#pdks_no#) kayıt yapıldı!<br/><br />');
				}
				else
				{
					writeoutput('#i#.satır kişi (#pdks_no#)bulunamadı!<br/><br />');
					bulunamayan_listesi = listappend(bulunamayan_listesi,'#pdks_no#');
				}
			}
		}
		catch (any e)
		{
			kont=0;
			writeoutput('#i#.satır okuma esnasında hata verdi. : #dosya1[i]# - #listlen(dosya1[i],";")# <br />');
		}
	}
	writeoutput('Bulunamayanlar Listesi : #listdeleteduplicates(bulunamayan_listesi)#<br /><br />İşlem Tamamlandı!<br />');
</cfscript>

