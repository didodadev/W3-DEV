<!---
    File: offtime_calc.cfm
    Author: Esma R. UYSAL<esmauysal@workcube.com>
    Date: 13/04/2020
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
    izin_startdate_ = dateadd("h", session.ep.time_zone, startdate); 
    izin_finishdate_ = dateadd("h", session.ep.time_zone, finishdate);
    fark = 0;
    fark2 = 0;
    fark_ogleden_once = 0;
    fark_ogleden_sonra = 0;
    temporary_halfday_mid = 0;
    eklenecek_sabah_izni = 0;
    cikarılacak_sabah_izni = 0;
    izin_saati_oglenden_once = 0;
    izin_saati_oglenden_sonra = 0;
    eklenecek_aksam_izni = 0;
    ogle_arasi_dk = 0;

    if(not isdefined("total_min_emp"))
        total_min_emp = 0;
    if(not isdefined("use_hour"))
        use_hour = 0;

    sabah_bitis = timeformat('#finish_am_hour#:#finish_am_min#',timeformat_style);// sabah mesaisi bitiş 
    oglen_baslangic = timeformat('#start_pm_hour#:#start_pm_min#',timeformat_style);// Öğle mesaisi Başlangıç 
    
    // Listeleme de saat cinsinden gösterilsin seçildiğinde 20200106ERU
    if(x_min_control eq 1 or use_hour eq 1){
        
        baslangic_saat_dk = timeformat('#get_hours.start_hour#:#get_hours.start_min#',timeformat_style);// mesai başlangıç 
        bitis_saat_dk = timeformat('#get_hours.end_hour#:#get_hours.end_min#',timeformat_style);// mesai bitiş 

        //Eğer vardiya varsa ve vardiya bitiş günü bir sonraki günse yani vardiya başlangıç saati bitiş saatinden sonra ise örn : 23:00 başlangıç 06.15 bitiş
        
        mesai_saati_dk = datediff("n",baslangic_saat_dk,bitis_saat_dk);// Günlük mesai dk 
        ogle_arasi_dk = datediff("n",sabah_bitis,oglen_baslangic);// öğle arası dk 
        gunluk_calisma_dk = mesai_saati_dk - ogle_arasi_dk;//günlük çalışma dk sı
        
    }
    
    if(timeformat(izin_startdate_,timeformat_style) lt timeformat('#start_hour#:#start_min#',timeformat_style))//İzin başlama saati xml'den seçilen işe başlama saatinden küçük ise
    {
        izin_start_hour_ = timeformat('#start_hour#:#start_min#',timeformat_style);//izin başlama saati xml'deki değeri alıyor.
        //Sabah girilen izin için hesaplama ERU
        if(x_min_control eq 1 or use_hour eq 1){
            izin_start_hour_time_format = timeformat(izin_startdate_,timeformat_style);
            eklenecek_sabah_izni = datediff("n",izin_start_hour_time_format,baslangic_saat_dk);
        }
    }
    else
    {
        izin_start_hour_ = 	timeformat(izin_startdate_,timeformat_style);
        
        //Eğer izin başlangıç saati öğle arasına denk geliyorsa
        if(izin_start_hour_ gte sabah_bitis  and izin_start_hour_ lte oglen_baslangic and (x_min_control eq 1  or use_hour eq 1)){
            izin_start_hour_ = 	oglen_baslangic;
            izin_start_hour_time_format = timeformat(oglen_baslangic,timeformat_style);
            cikarılacak_sabah_izni = datediff("n",baslangic_saat_dk,izin_start_hour_time_format);
        }else if(x_min_control eq 1 or use_hour eq 1){
            izin_start_hour_time_format = timeformat(izin_startdate_,timeformat_style);
            cikarılacak_sabah_izni = datediff("n",baslangic_saat_dk,izin_start_hour_time_format);
        }
    }
    if(timeformat(izin_finishdate_,timeformat_style) gt timeformat('#finish_hour#:#finish_min#',timeformat_style) )// İzin bitiş saati xml'deki iş çıkışı saatinden büyük ise
    {
        izin_finish_hour_ = timeformat('#finish_hour#:#finish_min#',timeformat_style);//izin bitiş saati xml'deki değeri alıyor.
        if(x_min_control eq 1 or use_hour eq 1){
            izin_finish_hour_time_format = timeformat(izin_finishdate_,timeformat_style);
            eklenecek_aksam_izni = datediff("n",bitis_saat_dk,izin_finish_hour_time_format);
            izin_finish_hour_parameters = bitis_saat_dk;//izin bitiş saati xml'deki değeri alıyor.
        }
    }
    else
    {
        izin_finish_hour_ = timeformat(izin_finishdate_,timeformat_style);
        //Eğer izin bitiş saati öğle arasına denk geliyorsa
        if(izin_finish_hour_ gte sabah_bitis  and izin_finish_hour_ lte oglen_baslangic and (x_min_control eq 1 or use_hour eq 1)){
            izin_finish_hour_ = sabah_bitis;	
            izin_finish_hour_parameters = izin_finish_hour_;
        }else{
            if(x_min_control eq 1 or use_hour eq 1){
                izin_finish_hour_parameters = timeformat(izin_finishdate_,timeformat_style);
            }
        }
    }			
    if(isdefined("finish_am_hour") and izin_start_hour_ lte timeformat('#finish_am_hour#:#finish_am_min#',timeformat_style) and izin_finish_hour_ lte timeformat('#finish_am_hour#:#finish_am_min#',timeformat_style))//izin başlangıç saati ve bitiş saati 13 ten küçükse
    {
        fark_ogleden_once = fark_ogleden_once + datediff("n",izin_start_hour_,izin_finish_hour_);
        fark_ogleden_once = fark_ogleden_once / 60;
        izin_saati_oglenden_once = 1;
    }
    else if(isdefined("start_pm_hour") and izin_start_hour_ gte timeformat('#start_pm_hour#:#start_pm_min#',timeformat_style))
    {
        fark_ogleden_sonra = fark_ogleden_sonra +datediff("n",izin_start_hour_,izin_finish_hour_);
        fark_ogleden_sonra = fark_ogleden_sonra / 60;
        izin_saati_oglenden_sonra = 1;
    }
    if(fark_ogleden_once gt 0 and fark_ogleden_once lt day_control)
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
    
    for (mck_=0; mck_ lt total_izin_; mck_=mck_+1)
    {
        temp_izin_gunu_ = dateadd("d",mck_,izin_startdate_);
        daycode_ = '#dateformat(temp_izin_gunu_,dateformat_style)#';

        if (dayofweek(temp_izin_gunu_) eq this_week_rest_day_)
        {
            temporary_sunday_total_ = temporary_sunday_total_ + 1;
        }
           
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
    if((get_offtimes.is_paid neq 1 and get_offtimes.ebildirge_type_id neq 21) or (isdefined('x_total_offdays_type') and x_total_offdays_type eq 1) or (get_offtimes.CALC_CALENDAR_DAY))  
    {
        izin_gun = total_izin_ - (0.5 * temporary_halfday_total);
    }
    else
    {
        izin_gun = total_izin_ - temporary_sunday_total_ - temporary_offday_total_ - (0.5 * temporary_halfday_total) + (0.5 * temporary_halfofftime) + add_sunday_total;
    }
    //Ucretli isaretli degilse ve bildirge karşılığı diger ücretsiz izinden farklı ise genel tatil ve hafta tatili dusulmez ya da izin kategorilerinden Takvim günü hesapla seçiliyse
    if((get_offtimes.is_paid neq 1 and get_offtimes.ebildirge_type_id neq 21) or (isdefined('x_total_offdays_type') and x_total_offdays_type eq 1) or (get_offtimes.CALC_CALENDAR_DAY))
    {
        temp_total_izin_ = total_izin_;
    }else{
        temp_total_izin_ = total_izin_ -  temporary_sunday_total_ - temporary_offday_total_ + (0.5 * temporary_halfofftime) + add_sunday_total;
       
    }
    //İzin günü dk cinsinden hesaplama 20200107ERU
    if(x_min_control eq 1 or use_hour eq 1){
        temp_total_izin_ = round(temp_total_izin_);
        afternoon_sum = 0;
        if((temporary_halfday_total neq 0 or temp_off_min neq 0) and izin_finish_hour_ gte sabah_bitis  and izin_finish_hour_ lte oglen_baslangic)
        {
            afternoon_sum = 0;
        }
        else if((temporary_halfday_total neq 0 or temp_off_min neq 0) and izin_start_hour_ eq baslangic_saat_dk and (izin_finish_hour_ gte sabah_bitis))
        {
            afternoon_sum = 1;
            izin_finish_hour_parameters =  sabah_bitis;  
        }
        total_dk = gunluk_calisma_dk * temp_total_izin_; // toplam izin dk
            
        bitis = datediff("n",izin_finish_hour_parameters,bitis_saat_dk);//Mesai bitis - izin bitiş
        total_dk = (total_dk - bitis);//toplam dk'dan bitiş çıkarılıyor1
        if(izin_saati_oglenden_once neq 0 or afternoon_sum eq 1){//Öğleden Önce ise çıkaılan öğle arası geri ekleniyor
            total_dk = total_dk + ogle_arasi_dk;
        }

        if(cikarılacak_sabah_izni neq 0){//izin mesai saatinden sonra başlıyorsa
            total_dk = total_dk - cikarılacak_sabah_izni;
            if(izin_saati_oglenden_sonra){
                total_dk = total_dk + ogle_arasi_dk;
            }
        }
        if(eklenecek_aksam_izni neq 0){
            total_dk = total_dk + eklenecek_aksam_izni;
        }
        total_dk = abs(total_dk);
        //İzini Gün Saat Dk cinsinden hesaplar
        days = int(total_dk / gunluk_calisma_dk) ;
        minutesRemaining = total_dk - (days * gunluk_calisma_dk);
        hours = int(minutesRemaining / 60);
        minutes = minutesRemaining mod 60;
        total_day_calc = total_dk / gunluk_calisma_dk;
        genel_dk_toplam = genel_dk_toplam + total_day_calc;
        total_min_emp = total_min_emp + total_dk;
    }
    if(isdefined("IS_YEARLY") and IS_YEARLY eq 1)
        genel_izin_toplam = genel_izin_toplam + izin_gun;
    kisi_izin_toplam = kisi_izin_toplam + genel_izin_toplam;
    kisi_izin_sayilmayan = kisi_izin_sayilmayan + temporary_sunday_total_;
</cfscript>