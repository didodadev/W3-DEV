<!--- Adnan Akat için PDKS Import SM: 20130508 --->
<cffunction name="get_in_out_id" access="public" returntype="query">
	<cfargument name="pdks_no" default="">
    <cfargument name="start_date" default="">
	<cfquery name="get_in_out" dbtype="query" maxrows="1">
		SELECT TOP 1 EMPLOYEE_ID,IN_OUT_ID,BRANCH_ID,START_DATE FROM get_in_outs WHERE PDKS_NUMBER = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.pdks_no#"> AND START_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#arguments.start_date#"> ORDER BY START_DATE DESC
	</cfquery>
	<cfreturn get_in_out>
</cffunction>
<cffunction name="get_in_out_" access="public" returntype="query">
	<cfargument name="pdks_no" default="">
    <cfargument name="start_date" default="">
	<cfquery name="get_in_out" dbtype="query" maxrows="1">
		SELECT TOP 1 EMPLOYEE_ID,IN_OUT_ID,BRANCH_ID,START_DATE FROM get_in_outs WHERE PDKS_NUMBER = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.pdks_no#"> AND START_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#arguments.start_date#"> ORDER BY START_DATE ASC
	</cfquery>
	<cfreturn get_in_out>
</cffunction>
<cfscript>
	bulunamayan_listesi = '';
	ucretli_izin_saati_kat_id = 3;
	ucretsiz_izin_saati_kat_id = 4;
	ucretsiz_izin_saati_kat_id2 = 6; //01 istirahat bildirge karşılıklı izin kategorisi için eklendi 20140710 SG
	yıllık_izin_saati_kat_id = 1;
	devamsızlık_izin_saati_kat_id = 5;
	offtime_stage_value = 13;
	emp_count = (line_count - 2) / 10;
	line_count = int(emp_count);
	dosyam = Replace(dosya1[3],';;',';0;','all');
	dosyam = Replace(dosyam,';;',';0;','all');
	month_info = listfirst(dosyam,'/');
	year_info = listlast(dosyam,'/');
	bu_ay_basi =  createdate(year_info,month_info,1);
	bu_ay_sonu = date_add('s',-1,date_add('m',1,bu_ay_basi));
	time = 7.5;
	
	for (i=1; i lte emp_count; i++)
	{
		try
		{
			kont=1;
			row_count = 4 + (i-1)*10;
			satir_main = Replace(Replace(dosya1[row_count],';;',';0;','all'),';;',';0;','all');
			pdks_no = oku(satir_main,19,5);
			satir_1 = Replace(Replace(dosya1[row_count+1],';;',';0;','all'),';;',';0;','all');
			normal_calisma_saati = oku(satir_1,33,6);
			satir_2 = Replace(Replace(dosya1[row_count+2],';;',';0;','all'),';;',';0;','all');
			hafta_ici_fazla_mesai = oku(satir_2,33,6);
			satir_3 = Replace(Replace(dosya1[row_count+3],';;',';0;','all'),';;',';0;','all');
			hafta_sonu_fazla_mesai = oku(satir_3,33,6);
			satir_4 = Replace(Replace(dosya1[row_count+4],';;',';0;','all'),';;',';0;','all');
			ucretli_izin_saati = oku(satir_4,33,6);
			satir_5 = Replace(Replace(dosya1[row_count+5],';;',';0;','all'),';;',';0;','all');
			hafta_tatili_saati = oku(satir_5,33,6);
			satir_6 = Replace(Replace(dosya1[row_count+6],';;',';0;','all'),';;',';0;','all');
			yillik_izin_saati = oku(satir_6,33,6);
			satir_7 = Replace(Replace(dosya1[row_count+7],';;',';0;','all'),';;',';0;','all');
			devamsizlik_saati = oku(satir_7,33,6);
			satir_8 = Replace(Replace(dosya1[row_count+8],';;',';0;','all'),';;',';0;','all');
			ucretsiz_izin_saati = oku(satir_8,33,6);
			satir_9 = Replace(Replace(dosya1[row_count+9],';;',';0;','all'),';;',';0;','all');
			ucretsiz_izin_saati2 = oku(satir_9,33,6);
			normal_calisma_saati = normal_calisma_saati + devamsizlik_saati;// devamsızlık normal çalışma saatne ekleniyor
			devamsizlik_saati = devamsizlik_saati * 1.34;
			hafta_ici_fazla_mesai = hafta_ici_fazla_mesai - devamsizlik_saati;//devamsızlık fazla mesaiden düşülüyor
			kalan_devamsizlik = 0;
			if(hafta_ici_fazla_mesai lte 0)
				hafta_ici_fazla_mesai = 0;
			if(devamsizlik_saati gt 0)
				kalan_devamsizlik = devamsizlik_saati - hafta_ici_fazla_mesai;
			if(hafta_sonu_fazla_mesai gt 0 and kalan_devamsizlik gt 0)
				hafta_sonu_fazla_mesai = hafta_sonu_fazla_mesai - kalan_devamsizlik;//devamsızlık fazla mesaiden düşülüyor
			if(hafta_sonu_fazla_mesai lte 0)
				hafta_sonu_fazla_mesai = 0;
		}
		catch (any e)
		{
			kont=0;
			writeoutput('#i#.satır okuma esnasında hata verdi. <br />');
		}
		
		if (kont eq 1)
		{
			daily_in_out_action = createObject("component", "V16.hr.cfc.daily_in_out");
			daily_in_out_action.dsn = dsn;
			offtime_action = createObject("component", "V16.hr.cfc.offtime");
			offtime_action.dsn = dsn;
			worktime_action = createObject("component", "V16.hr.cfc.employees_ext_worktimes");
			worktime_action.dsn = dsn;
			get_in_out = get_in_out_id(pdks_no,bu_ay_basi);
			if (not get_in_out.recordcount)
				get_in_out = get_in_out_(pdks_no,bu_ay_sonu);
			if (get_in_out.recordcount)
			{
				fark_ = datediff("d",bu_ay_basi,get_in_out.start_date);
				
				// Normal Çalışma
				gun_sayisi_ = (normal_calisma_saati \ time);
				if (normal_calisma_saati gt (gun_sayisi_ * time))
					gun_sayisi_ = gun_sayisi_ + 1;
				if (fark_ gt 0)
					baslangic_ = fark_;
				else
					baslangic_ = 0;
				last_day = 1;
				
				for (mmd=1; mmd lte gun_sayisi_; mmd++)
				{
					kontrol_date = 0;
					last_day = last_day+1;
					if (mmd neq gun_sayisi_)
						yazilacak_ = time;
					else
						yazilacak_ = normal_calisma_saati - (time * (mmd-1));
					
					try
					{
						new_tarih_ = createodbcdatetime(createdate(year_info,month_info,(baslangic_+mmd)));
					}
					catch
					{
						kontrol_date = 1;
					}
					startdate_ = date_add('h',8,new_tarih_);
					finishdate_ = date_add('h',yazilacak_,startdate_);
					if (startdate_ neq finishdate_ and kontrol_date eq 0)
					{
						get_in_out = get_in_out_id(pdks_no,new_tarih_);
						add_daily_in_out = daily_in_out_action.add_daily_in_out(
							file_id: attributes.i_id,
							employee_id: get_in_out.employee_id,
							in_out_id: get_in_out.in_out_id,
							branch_id: get_in_out.branch_id,
							start_date: startdate_,
							finish_date: finishdate_);	
					}
				}
				
				//hafta_tatili_saati
				gun_sayisi_ = (hafta_tatili_saati \ time);
				if (hafta_tatili_saati gt (gun_sayisi_ * time))
					gun_sayisi_ = gun_sayisi_ + 1;
				if (fark_ gt 0)
					baslangic_ = fark_;
				else
					baslangic_ = 0;
				
				for (mmd=last_day; mmd lte (gun_sayisi_+last_day-1); mmd++)
				{
					if (mmd neq gun_sayisi_)
						yazilacak_ = time;
					else
						yazilacak_ = hafta_tatili_saati - (time * (mmd-1));
					
					startdate_ = date_add('h',8,new_tarih_);
					finishdate_ = date_add('h',yazilacak_,startdate_);
					add_daily_in_out = daily_in_out_action.add_daily_in_out(
							file_id: attributes.i_id,
							employee_id: get_in_out.employee_id,
							in_out_id: get_in_out.in_out_id,
							branch_id: get_in_out.branch_id,
							start_date: startdate_,
							finish_date: finishdate_,
							is_week_rest_day: 0);	
				}
				
				// yillik_izin_saati
				gun_sayisi_ = (yillik_izin_saati \ time);
				if (yillik_izin_saati gt (gun_sayisi_ * time))
					gun_sayisi_ = gun_sayisi_ + 1;
				if (fark_ gt 0)
					baslangic_ = fark_;
				else
					baslangic_ = 0;
					
				for (mmd=1; mmd lte gun_sayisi_; mmd++)
				{
					if (mmd neq gun_sayisi_)
						yazilacak_ = time;
					else
						yazilacak_ = yillik_izin_saati - (time * (mmd-1));
						
					new_tarih_ = createodbcdatetime(createdate(year_info,month_info,(baslangic_+mmd)));
					startdate_ = date_add('h',8,new_tarih_);
					finishdate_ = date_add('h',yazilacak_,startdate_);
					if (startdate_ neq finishdate_)
					{
						get_in_out = get_in_out_id(pdks_no,new_tarih_);
						add_offtime = offtime_action.add_offtime(
							is_puantaj_off: 0,
							is_from_pdks: 1,
							pdks_file_id: attributes.i_id,
							employee_id: get_in_out.employee_id,
							offtimecat_id: yıllık_izin_saati_kat_id,
							startdate: startdate_,
							finishdate: finishdate_,
							work_startdate: finishdate_,
							total_hours: 0,
							validator_position_code: session.ep.position_code,
							valid: 1,
							valid_employee_id: session.ep.userid,
							validdate: now(),
							offtime_stage: offtime_stage_value);
					}
				}
				
				// hafta_ici_fazla_mesai
				gun_sayisi_ = (hafta_ici_fazla_mesai \ time);
				if (hafta_ici_fazla_mesai gt (gun_sayisi_ * time))
					gun_sayisi_ = gun_sayisi_ + 1;
				if (fark_ gt 0)
					baslangic_ = fark_;
				else
					baslangic_ = 0;
					
				for (mmd=1; mmd lte gun_sayisi_; mmd++)
				{
					if (mmd neq gun_sayisi_)
						yazilacak_ = time;
					else
						yazilacak_ = hafta_ici_fazla_mesai - (time * (mmd-1));
						
					new_tarih_ = createodbcdatetime(createdate(year_info,month_info,(baslangic_+mmd)));
					startdate_ = date_add('h',8,new_tarih_);
					finishdate_ = date_add('h',yazilacak_,startdate_);
					get_in_out = get_in_out_id(pdks_no,new_tarih_);
					add_worktime = worktime_action.add_worktime(
							is_puantaj_off: 0,
							is_from_pdks: 1,
							pdks_file_id: attributes.i_id,
							employee_id: get_in_out.employee_id,
							start_time: startdate_,
							end_time: finishdate_,
							day_type: 0,
							in_out_id: get_in_out.in_out_id,
							valid: 1,
							validdate: now(),
							valid_employee_id: session.ep.userid);
				}
				
				//hafta_sonu_fazla_mesai
				gun_sayisi_ = (hafta_sonu_fazla_mesai \ time);
				if (hafta_sonu_fazla_mesai gt (gun_sayisi_ * time))
					gun_sayisi_ = gun_sayisi_ + 1;
				if (fark_ gt 0)
					baslangic_ = fark_;
				else
					baslangic_ = 0;
					
				for (mmd=1; mmd lte gun_sayisi_; mmd++)
				{
					if (mmd neq gun_sayisi_)
						yazilacak_ = time;
					else
						yazilacak_ = hafta_sonu_fazla_mesai - (time * (mmd-1));
						
					new_tarih_ = createodbcdatetime(createdate(year_info,month_info,(baslangic_+mmd)));
					startdate_ = date_add('h',8,new_tarih_);
					finishdate_ = date_add('h',yazilacak_,startdate_);
					get_in_out = get_in_out_id(pdks_no,new_tarih_);
					add_worktime = worktime_action.add_worktime(
							is_puantaj_off: 0,
							is_from_pdks: 1,
							pdks_file_id: attributes.i_id,
							employee_id: get_in_out.employee_id,
							start_time: startdate_,
							end_time: finishdate_,
							day_type: 1,
							in_out_id: get_in_out.in_out_id,
							valid: 1,
							validdate: now(),
							valid_employee_id: session.ep.userid);
				}
				
				// ucretli_izin_saati
				gun_sayisi_ = (ucretli_izin_saati \ time);
				if (ucretli_izin_saati gt (gun_sayisi_ * time))
					gun_sayisi_ = gun_sayisi_ + 1;
				if (fark_ gt 0)
					baslangic_ = fark_;
				else
					baslangic_ = 0;
					
				for (mmd=1; mmd lte gun_sayisi_; mmd++)
				{
					if (mmd neq gun_sayisi_)
						yazilacak_ = time;
					else
						yazilacak_ = ucretli_izin_saati - (time * (mmd-1));
						
					new_tarih_ = createodbcdatetime(createdate(year_info,month_info,(baslangic_+mmd)));
					startdate_ = date_add('h',8,new_tarih_);
					finishdate_ = date_add('h',yazilacak_,startdate_);
					if (startdate_ neq finishdate_)
					{
						get_in_out = get_in_out_id(pdks_no,new_tarih_);
						add_offtime = offtime_action.add_offtime(
							is_puantaj_off: 0,
							is_from_pdks: 1,
							pdks_file_id: attributes.i_id,
							employee_id: get_in_out.employee_id,
							offtimecat_id: ucretli_izin_saati_kat_id,
							startdate: startdate_,
							finishdate: finishdate_,
							work_startdate: finishdate_,
							total_hours: 0,
							validator_position_code: session.ep.position_code,
							valid: 1,
							valid_employee_id: session.ep.userid,
							validdate: now(),
							offtime_stage: offtime_stage_value);
					}
				}
				
				//ucretsiz_izin_saati
				gun_sayisi_ = (ucretsiz_izin_saati \ time);
				if (ucretsiz_izin_saati gt (gun_sayisi_ * time))
					gun_sayisi_ = gun_sayisi_ + 1;
				if (fark_ gt 0)
					baslangic_ = fark_;
				else
					baslangic_ = 0;
					
				for (mmd=1; mmd lte gun_sayisi_; mmd++)
				{
					kontrol_date = 0;
					if (mmd neq gun_sayisi_)
						yazilacak_ = time;
					else
						yazilacak_ = ucretsiz_izin_saati - (time * (mmd-1));
						
					try
					{
						new_tarih_ = createodbcdatetime(createdate(year_info,month_info,(baslangic_+mmd)));
					}
					catch
					{
						kontrol_date = 1;
					}
					if (kontrol_date eq 0)
					{
						startdate_ = date_add('h',8,new_tarih_);
						finishdate_ = date_add('h',yazilacak_,startdate_);
						get_in_out = get_in_out_id(pdks_no,new_tarih_);
						add_offtime = offtime_action.add_offtime(
							is_puantaj_off: 0,
							is_from_pdks: 1,
							pdks_file_id: attributes.i_id,
							employee_id: get_in_out.employee_id,
							offtimecat_id: ucretsiz_izin_saati_kat_id,
							startdate: startdate_,
							finishdate: finishdate_,
							work_startdate: finishdate_,
							total_hours: 0,
							validator_position_code: session.ep.position_code,
							valid: 1,
							valid_employee_id: session.ep.userid,
							validdate: now(),
							offtime_stage: offtime_stage_value);
					}
				}
				
				//ucretsiz_izin_saati (istirahat tipi için)
				gun_sayisi_ = (ucretsiz_izin_saati2 \ time);
				if (ucretsiz_izin_saati2 gt (gun_sayisi_ * time))
					gun_sayisi_ = gun_sayisi_ + 1;
				if (fark_ gt 0)
					baslangic_ = fark_;
				else
					baslangic_ = 0;
					
				for (mmd=1; mmd lte gun_sayisi_; mmd++)
				{
					kontrol_date = 0;
					if (mmd neq gun_sayisi_)
						yazilacak_ = time;
					else
						yazilacak_ = ucretsiz_izin_saati2 - (time * (mmd-1));
					
					try
					{
						new_tarih_ = createodbcdatetime(createdate(year_info,month_info,(baslangic_+mmd)));
					}
					catch
					{
						kontrol_date = 1;
					}
					
					if (kontrol_date eq 0)
					{
						startdate_ = date_add('h',8,new_tarih_);
						finishdate_ = date_add('h',yazilacak_,startdate_);
						get_in_out = get_in_out_id(pdks_no,new_tarih_);
						add_offtime = offtime_action.add_offtime(
							is_puantaj_off: 0,
							is_from_pdks: 1,
							pdks_file_id: attributes.i_id,
							employee_id: get_in_out.employee_id,
							offtimecat_id: ucretsiz_izin_saati_kat_id2,
							startdate: startdate_,
							finishdate: finishdate_,
							work_startdate: finishdate_,
							total_hours: 0,
							validator_position_code: session.ep.position_code,
							valid: 1,
							valid_employee_id: session.ep.userid,
							validdate: now(),
							offtime_stage: offtime_stage_value);
					}
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
	writeoutput('Bulunamayanlar Listesi : #listdeleteduplicates(bulunamayan_listesi)#<br /><br />İşlem Tamamlandı!<br />');
</cfscript>

