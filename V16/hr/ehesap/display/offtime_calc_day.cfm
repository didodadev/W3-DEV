<!---
    File: offtime_calc_day.cfm
    Author: Esma R. UYSAL<esmauysal@workcube.com>
    Date: 09/10/2020
    Description:
        izin hesaplamalarını içerir.İzin listeleme ve izin raporunda ve izin şablonunda kullanılıyor.
--->
<cfscript>
    add_sunday_total = 0;
    temporary_sunday_total_ = 0;
    temporary_offday_total_ = 0;
    temp_off_min = 0;
    temporary_halfday_total = 0;
    temporary_halfofftime = 0;
    izin_start_hour_ = "";
    izin_finish_hour_ = "";
    temp_finishdate = CreateDateTime(year(finishdate),month(finishdate),day(finishdate),0,0,0);
    temp_startdate = CreateDateTime(year(startdate),month(startdate),day(startdate),0,0,0);
    total_izin_ = fix(temp_finishdate-temp_startdate)+1;
    temp_total_izin_ = total_izin_;
    izin_startdate_ = date_add("h", session.ep.time_zone, startdate); 
    izin_finishdate_ = date_add("h", session.ep.time_zone, finishdate);
    fark = 0;
    fark2 = 0;
    fark_ogleden_once = 0;
    fark_ogleden_sonra = 0;
    fark_ogle_arası = 0;

    //vardiyalı çalışan
    if(len(get_shift.shift_id))
    {
        shift_start = timeformat('#get_shift.start_hour#:#get_shift.start_min#',timeformat_style);
        shift_end = timeformat('#get_shift.end_hour#:#get_shift.end_min#',timeformat_style);
    }
    sabah_bitis = timeformat('#finish_am_hour#:#finish_am_min#',timeformat_style);// sabah mesaisi bitiş 
    oglen_baslangic = timeformat('#start_pm_hour#:#start_pm_min#',timeformat_style);// Öğle mesaisi Başlangıç 
    
    if(timeformat(izin_startdate_,timeformat_style) lt timeformat('#start_hour#:#start_min#',timeformat_style) and not len(get_shift.shift_id))//İzin başlama saati xml'den seçilen işe başlama saatinden küçük ise
    {
        izin_start_hour_ = timeformat('#start_hour#:#start_min#',timeformat_style);//izin başlama saati xml'deki değeri alıyor.
    }
    else
    {
        izin_start_hour_ = 	timeformat(izin_startdate_,timeformat_style);
        //Başlangıç öğlen arasıns denk geliyorsa 
        if(izin_start_hour_ gte sabah_bitis  and izin_start_hour_ lte oglen_baslangic)
        {
            izin_start_hour_ = 	oglen_baslangic;
        }
    }

    if(timeformat(izin_finishdate_,timeformat_style) gt timeformat('#finish_hour#:#finish_min#',timeformat_style)  and not len(get_shift.shift_id))// İzin bitiş saati xml'deki iş çıkışı saatinden büyük ise
    {
        izin_finish_hour_ = timeformat('#finish_hour#:#finish_min#',timeformat_style);//izin bitiş saati xml'deki değeri alıyor.
    }
    else
    {
        //Eğer izin bitiş saati öğle arasına denk geliyorsa
        izin_finish_hour_ = timeformat(izin_finishdate_,timeformat_style);
        if(izin_finish_hour_ gte sabah_bitis  and izin_finish_hour_ lte oglen_baslangic){
            izin_finish_hour_ = sabah_bitis;	
        }
    }
    //Başlangıç ve bitiş öğle arasına den geliyosa
    if(timeformat(izin_finishdate_,timeformat_style) gte sabah_bitis  and timeformat(izin_finishdate_,timeformat_style) lte oglen_baslangic and timeformat(izin_startdate_,timeformat_style) gte sabah_bitis  and timeformat(izin_startdate_,timeformat_style) lte oglen_baslangic)	
    {
        fark_ogle_arası = fark_ogle_arası +datediff("n",timeformat(izin_startdate_,timeformat_style),timeformat(izin_finishdate_,timeformat_style));
        fark_ogle_arası = fark_ogle_arası / 60;
    }		

    if(isdefined("finish_am_hour") and izin_start_hour_ lte timeformat('#finish_am_hour#:#finish_am_min#',timeformat_style) and izin_finish_hour_ lte timeformat('#finish_am_hour#:#finish_am_min#',timeformat_style) and not len(get_shift.shift_id))//izin başlangıç saati ve bitiş saati 13 ten küçükse
    {
        fark_ogleden_once = fark_ogleden_once + datediff("n",izin_start_hour_,izin_finish_hour_);
        fark_ogleden_once = fark_ogleden_once / 60;
    }
    else if(isdefined("start_pm_hour") and izin_start_hour_ gte timeformat('#start_pm_hour#:#start_pm_min#',timeformat_style) and not len(get_shift.shift_id))
    {
        fark_ogleden_sonra = fark_ogleden_sonra +datediff("n",izin_start_hour_,izin_finish_hour_);
        fark_ogleden_sonra = fark_ogleden_sonra / 60;
    }    

    if(fark_ogleden_once gt 0 and fark_ogleden_once lt day_control_)
    {
        if((not listfind(halfofftime_list,'#dateformat(startdate,dateformat_style)#') or (listfind(halfofftime_list,'#dateformat(startdate,dateformat_style)#') and public_holiday_on eq 1)) or (not listfind(halfofftime_list,'#dateformat(finishdate,dateformat_style)#') or (listfind(halfofftime_list,'#dateformat(finishdate,dateformat_style)#') and public_holiday_on eq 1))) //saatten oluşan yarım günlük izine yarım günlük genel tatil gunune denk gelmiyorsa girece
            temporary_halfday_total = temporary_halfday_total + 1;
        //İzin başlangıç günü aynı gün değilse ve bu günlerden yarım günlük genel tatile denk gelme şartı için
        halfofftime_list2 = listappend(halfofftime_list2,'#dateformat(startdate,dateformat_style)#');
        halfofftime_list3 = listappend(halfofftime_list3,'#dateformat(finishdate,dateformat_style)#');
    }
    if(fark_ogleden_sonra gt 0 and fark_ogleden_sonra lte day_control_afternoon)
    {											
        if((not listfind(halfofftime_list,'#dateformat(startdate,dateformat_style)#') or (listfind(halfofftime_list,'#dateformat(startdate,dateformat_style)#') and public_holiday_on eq 1)) or (not listfind(halfofftime_list,'#dateformat(finishdate,dateformat_style)#') or (listfind(halfofftime_list,'#dateformat(finishdate,dateformat_style)#') and public_holiday_on eq 1))) //saatten oluşan yarım günlük izine yarım günlük genel tatil gunune denk gelmiyorsa girecek
            temporary_halfday_total = temporary_halfday_total + 1;
        //İzin başlangıç günü aynı gün değilse ve bu günlerden yarım günlük genel tatile denk gelme şartı için
        halfofftime_list2 = listappend(halfofftime_list2,'#dateformat(startdate,dateformat_style)#');
        halfofftime_list3 = listappend(halfofftime_list3,'#dateformat(finishdate,dateformat_style)#');
    }
    if(fark_ogle_arası gt 0 and fark_ogleden_sonra lte day_control_afternoon)
    {											
        if((not listfind(halfofftime_list,'#dateformat(startdate,dateformat_style)#') or (listfind(halfofftime_list,'#dateformat(startdate,dateformat_style)#') and public_holiday_on eq 1)) or (not listfind(halfofftime_list,'#dateformat(finishdate,dateformat_style)#') or (listfind(halfofftime_list,'#dateformat(finishdate,dateformat_style)#') and public_holiday_on eq 1))) //saatten oluşan yarım günlük izine yarım günlük genel tatil gunune denk gelmiyorsa girecek
            temporary_halfday_total = temporary_halfday_total + 1;
        //İzin başlangıç günü aynı gün değilse ve bu günlerden yarım günlük genel tatile denk gelme şartı için
        halfofftime_list2 = listappend(halfofftime_list2,'#dateformat(startdate,dateformat_style)#');
        halfofftime_list3 = listappend(halfofftime_list3,'#dateformat(finishdate,dateformat_style)#');
    }
    
    for (mck_=0; mck_ lt total_izin_; mck_=mck_+1)
    {
        temp_izin_gunu_ = date_add("d",mck_,izin_startdate_);
        daycode_ = '#dateformat(temp_izin_gunu_,dateformat_style)#';
        
        if (dayofweek(temp_izin_gunu_) eq this_week_rest_day_)
        temporary_sunday_total_ = temporary_sunday_total_ + 1;
        else if (dayofweek(temp_izin_gunu_) eq 7 and saturday_on eq 0)
        temporary_sunday_total_ = temporary_sunday_total_ + 1;
        else if(listlen(offday_list_) and listfindnocase(offday_list_,'#daycode_#') and public_holiday_on eq 0)
            if((listfind(halfofftime_list2,'#daycode_#') and listfind(halfofftime_list3,'#daycode_#')) or (listlen(halfofftime_list) and listfind(halfofftime_list,'#daycode_#')))          
            {
                temporary_offday_total_ = temporary_offday_total_ + 0.5;
                temp_off_min ++;
            }
            else 
                temporary_offday_total_ = temporary_offday_total_ +1;
        else if(listlen(halfofftime_list) and listfind(halfofftime_list,'#daycode_#') and public_holiday_on eq 0) //yarım günlük genel tatiller
            temporary_halfofftime = temporary_halfofftime + 1; 
        if (dayofweek(temp_izin_gunu_) eq 1 and sunday_on eq 1)//pazar gunu ise ve pazar gunleri dahil edilsin secili ise
        {
            add_sunday_total = add_sunday_total+1;	
        }
    }
    //Ucretli isaretli degilse ve bildirge karşılığı diger ücretsiz izinden farklı ise genel tatil ve hafta tatili dusulmez ya da izin kategorilerinden Takvim günü hesapla seçiliyse
    if((is_paid neq 1 and ebildirge_type_id neq 21) or (isdefined('x_total_offdays_type') and x_total_offdays_type eq 1) or (CALC_CALENDAR_DAY))  
    {
        izin_gun = total_izin_ - (0.5 * temporary_halfday_total);
    }
    else
    {
        izin_gun = total_izin_ - temporary_sunday_total_ - temporary_offday_total_ - (0.5 * temporary_halfday_total) + (0.5 * temporary_halfofftime) + add_sunday_total;
    }
    //Ucretli isaretli degilse ve bildirge karşılığı diger ücretsiz izinden farklı ise genel tatil ve hafta tatili dusulmez ya da izin kategorilerinden Takvim günü hesapla seçiliyse
    if((is_paid neq 1 and ebildirge_type_id neq 21) or (isdefined('x_total_offdays_type') and x_total_offdays_type eq 1) or (CALC_CALENDAR_DAY))
    {
        temp_total_izin_ = total_izin_;
    }else{
        temp_total_izin_ = total_izin_ -  temporary_sunday_total_ - temporary_offday_total_ + (0.5 * temporary_halfofftime) + add_sunday_total;
    }
	if(isdefined("IS_YEARLY") and IS_YEARLY eq 1)
		genel_izin_toplam = genel_izin_toplam + izin_gun;
    kisi_izin_toplam = kisi_izin_toplam + genel_izin_toplam;
    kisi_izin_sayilmayan = kisi_izin_sayilmayan + temporary_sunday_total_;
</cfscript>