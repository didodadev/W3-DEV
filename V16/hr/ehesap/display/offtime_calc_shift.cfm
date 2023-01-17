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
    total_shift_min = 0;
    ogle_arasi_dk_shift = 0;
    ogle_arasi_dk_shift_ = 0;
    extra_half = 0;
  

    shift_cmp = createobject("component","V16.hr.cfc.get_employee_shift");
    get_shift_info = shift_cmp.GET_SHIF_EMPLOYEES_IN_OUT(employee_id : employee_id,start_date : startdate, finish_date : finishdate_);

    if(len(get_shift.shift_id))
    {
        shift_len = get_shift.recordcount;
        shift_start = timeformat('#get_shift.start_hour[1]#:#get_shift.start_min[1]#',timeformat_style);
        shift_end = timeformat('#get_shift.end_hour[shift_len]#:#get_shift.end_min[shift_len]#',timeformat_style);
    }
    sabah_bitis = timeformat('#finish_am_hour#:#finish_am_min#',timeformat_style);// sabah mesaisi bitiş 
    oglen_baslangic = timeformat('#start_pm_hour#:#start_pm_min#',timeformat_style);// Öğle mesaisi Başlangıç 

    // Listeleme de saat cinsinden gösterilsin seçildiğinde 20200106ERU
        
    baslangic_saat_dk = timeformat('#get_hours.start_hour#:#get_hours.start_min#',timeformat_style);// mesai başlangıç 
    bitis_saat_dk = timeformat('#get_hours.end_hour#:#get_hours.end_min#',timeformat_style);// mesai bitiş 
    mesai_saati_dk = datediff("n",baslangic_saat_dk,bitis_saat_dk);// Günlük mesai dk 
    ogle_arasi_dk = datediff("n",sabah_bitis,oglen_baslangic);// öğle arası dk 
    gunluk_calisma_dk = ((datediff("n",timeformat('#get_hours.start_hour#:#get_hours.start_min#',timeformat_style),timeformat('#get_hours.end_hour#:#get_hours.end_min#',timeformat_style))) - ogle_arasi_dk) ;

    if(timeformat(izin_startdate_,timeformat_style) lt shift_start)//İzin başlama saati xml'den seçilen işe başlama saatinden küçük ise
    {
        izin_start_hour_ = shift_start;//izin başlama saati xml'deki değeri alıyor.
    }
    else
    {
        izin_start_hour_ = 	timeformat(izin_startdate_,timeformat_style);
    }
    if(timeformat(izin_finishdate_,timeformat_style) gt shift_end)// İzin bitiş saati xml'deki iş çıkışı saatinden büyük ise
    {
        izin_finish_hour_ = shift_end;//izin bitiş saati xml'deki değeri alıyor.
    }
    else
    {
        izin_finish_hour_ = timeformat(izin_finishdate_,timeformat_style);
        
    }	
    
    if(len(get_shift.shift_id))
    {
        baslangic_saat_dk =	shift_start;// mesai başlangıç 
        bitis_saat_dk = shift_end;// mesai bitiş
        for (i=1; i <= get_shift.recordcount;i=i+1) 
        {
            shift_start_row = CreateDateTime(year(get_shift.start_date[i]),month(get_shift.start_date[i]),day(get_shift.start_date[i]),get_shift.start_hour[i],get_shift.start_min[i],0);
            shift_end_row = CreateDateTime(year(get_shift.finish_date[i]),month(get_shift.finish_date[i]),day(get_shift.finish_date[i]),get_shift.end_hour[i],get_shift.end_min[i],0);
            //Resmi tatil
            daycode_ = '#dateformat(shift_start_row,dateformat_style)#';

            total_izin_ = fix(shift_end_row-shift_start_row)+1;
            
            for (mck_=0; mck_ lt total_izin_; mck_=mck_+1)
            {
                temp_izin_gunu_ = dateadd("d",mck_,shift_start_row);
                daycode_ = '#dateformat(temp_izin_gunu_,dateformat_style)#';
                if(listlen(offday_list_) and listfindnocase(offday_list_,'#daycode_#') and public_holiday_on eq 0){
                    if((listfind(halfofftime_list2,'#daycode_#') and listfind(halfofftime_list3,'#daycode_#')) or (listlen(halfofftime_list) and listfind(halfofftime_list,'#daycode_#')))          
                    {
                        if(timeformat(shift_start_row,timeformat_style) gt  timeformat('13:00',timeformat_style)){
                            shift_start_row = dateadd("d",1,shift_start_row);
                            shift_start_row = CreateDateTime(year(shift_start_row),month(shift_start_row),day(shift_start_row),0,0,0);
                        }
                        else if(timeformat(shift_start_row,timeformat_style) lt timeformat('13:00',timeformat_style) and datediff("d",shift_start_row,shift_end_row) eq 0){
                            shift_end_row = CreateDateTime(year(shift_start_row),month(shift_start_row),day(shift_start_row),13,0,0);
                        }
                        else if(timeformat(shift_start_row,timeformat_style) lt timeformat('13:00',timeformat_style) and datediff("d",shift_start_row,shift_end_row) gt 0){
                            extra_half = extra_half + datediff("n",CreateDateTime(year(shift_start_row),month(shift_start_row),day(shift_start_row),13,0,0),datediff("n",shift_start_row,CreateDateTime(year(shift_start_row),month(shift_start_row),day(dateadd("d",1,shift_start_row)),0,0,0)));
                        }
                        else{
                            shift_start_row = dateadd("d",1,shift_start_row);
                            shift_start_row = CreateDateTime(year(shift_start_row),month(shift_start_row),day(shift_start_row),0,0,0);
                        }
                    }
                    else{
                        shift_start_row = dateadd("d",1,shift_start_row);
                        shift_start_row = CreateDateTime(year(shift_start_row),month(shift_start_row),day(shift_start_row),0,0,0);
                    }
                        
                }
                else if(listlen(halfofftime_list) and listfind(halfofftime_list,'#daycode_#') and public_holiday_on eq 0) //yarım günlük genel tatiller
                { 
                    if(timeformat(shift_start_row,timeformat_style) gt  timeformat('13:00',timeformat_style)){
                        shift_start_row = dateadd("d",1,shift_start_row);
                        shift_start_row = CreateDateTime(year(shift_start_row),month(shift_start_row),day(shift_start_row),0,0,0);
                    }
                    else if(timeformat(shift_start_row,timeformat_style) lt timeformat('13:00',timeformat_style) and datediff("d",shift_start_row,shift_end_row) eq 0){
                        shift_end_row = CreateDateTime(year(shift_start_row),month(shift_start_row),day(shift_start_row),13,0,0);
                    }
                    else if(timeformat(shift_start_row,timeformat_style) lt timeformat('13:00',timeformat_style) and datediff("d",shift_start_row,shift_end_row) gt 0){
                        extra_half = extra_half + datediff("n",CreateDateTime(year(shift_start_row),month(shift_start_row),day(shift_start_row),13,0,0),datediff("n",shift_start_row,CreateDateTime(year(shift_start_row),month(shift_start_row),day(dateadd("d",1,shift_start_row)),0,0,0)));
                    }
                    else{
                        shift_start_row = dateadd("d",1,shift_start_row);
                        shift_start_row = CreateDateTime(year(shift_start_row),month(shift_start_row),day(shift_start_row),0,0,0);
                    }
                }
            }
                
            if(izin_startdate_ gt shift_start_row)
                shift_start_row =  izin_startdate_;
            if(i eq get_shift.recordcount and izin_finishdate_ lt shift_end_row)
                shift_end_row =  izin_finishdate_;
            if(shift_start_row lt shift_end_row)
            {
                total_shift_min = total_shift_min + datediff("n",shift_start_row,shift_end_row);
                for(k = 1;k <= 4;k++)
                {
                    sabah_bitis = timeformat('#evaluate("get_shift.FREE_TIME_START_HOUR_#k#[#i#]")#:#evaluate("get_shift.FREE_TIME_START_MIN_#k#[#i#]")#',timeformat_style);// sabah mesaisi bitiş 
                    oglen_baslangic = timeformat('#evaluate("get_shift.FREE_TIME_END_HOUR_#k#[#i#]")#:#evaluate("get_shift.FREE_TIME_END_MIN_#k#[#i#]")#',timeformat_style);// öğle mesaisi başlangıç                
                    if(timeformat(shift_start_row,timeformat_style) lt oglen_baslangic and not(datediff("d",shift_start_row,shift_end_row) eq 0 and timeformat(shift_start_row,timeformat_style) lt oglen_baslangic and timeformat(shift_end_row,timeformat_style) lt oglen_baslangic)){
                        ogle_arasi_dk_shift = ogle_arasi_dk_shift + datediff("n",sabah_bitis,oglen_baslangic);// öğle arası dk 
                    }
                }
                
            }         
        }
        total_shift_min = total_shift_min - ogle_arasi_dk_shift - extra_half;
    }
    
    total_offday_min = 0;
    total_offday_min = total_offday_min /* + gunluk_calisma_dk * (temporary_halfofftime  + temporary_offday_total_)  */;
    total_dk = total_shift_min - total_offday_min; // toplam izin dk   

    days = int(total_dk / gunluk_calisma_dk) ;
    minutesRemaining = total_dk - (days * gunluk_calisma_dk);
    hours = int(minutesRemaining / 60);
    minutes = minutesRemaining mod 60;
    total_day_calc = total_dk / gunluk_calisma_dk;
    genel_dk_toplam = genel_dk_toplam + total_day_calc;
    
    if(isdefined("IS_YEARLY") and IS_YEARLY eq 1)
        genel_izin_toplam = genel_izin_toplam + izin_gun;
    kisi_izin_toplam = kisi_izin_toplam + genel_izin_toplam;
    kisi_izin_sayilmayan = kisi_izin_sayilmayan + temporary_sunday_total_;
</cfscript>