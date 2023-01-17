<!---
    İlker Altındal
    Create : 160621
    Desc : Datagate.cfc üzerinden servis başvuru işlemleri için adreslenen fonksiyonlar yer alır
--->

<cfcomponent extends="WMO.functions">
    <cfset dsn = dsn_alias = application.systemParam.systemParam().dsn />
    <cfset dsn1 = dsn_product = dsn1_alias = '#dsn#_product' />
    <cfset dsn2 = dsn2_alias = '#dsn#_#session.ep.period_year#_#session.ep.company_id#' />
	<cfset dsn3 = dsn3_alias = '#dsn#_#session.ep.company_id#' />
    <cfset request.self = application.systemParam.systemParam().request.self />
    <cfset fusebox.process_tree_control = application.systemParam.systemParam().fusebox.process_tree_control>
    <cfset index_folder = application.systemParam.systemParam().index_folder >
    <cfset dir_seperator = application.systemParam.systemParam().dir_seperator>
    <cfset database_type = application.systemParam.systemParam().database_type />
    
    <cffunction name="upd_service" access="public" returntype="any" hint="Servis Başvuruları Güncelleme">
        <cfset attributes = arguments>
        <cfset responseStruct = structNew()>
        <cfset list="',""">
        <cfset list2=" , ">
        <cf_get_lang_set module_name="sales">
        <cfset arguments.service_head = replacelist(arguments.service_head,list,list2)>
        <cfif arguments.active_company neq session.ep.company_id>
            <cfset responseStruct.message = getLang('main','İşlemin Şirketi İle Aktif Şirketiniz Farklı Çalıştığınız Şirketi Kontrol Ediniz',38700)>
            <cfset responseStruct.status = false>
            <cfset responseStruct.error = {}>
            <cfabort>
        </cfif>
        <cfif isdefined("arguments.service_product") and not len(arguments.service_product) and len(arguments.service_product_serial)>
            <cfquery name="get_seri_product" datasource="#dsn3#" maxrows="1">
                SELECT SGN.STOCK_ID,S.PRODUCT_NAME,S.PRODUCT_ID FROM SERVICE_GUARANTY_NEW SGN,STOCKS S WHERE SGN.STOCK_ID = S.STOCK_ID AND SGN.SERIAL_NO = <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#arguments.service_product_serial#"> 
            </cfquery>
            <cfif get_seri_product.recordcount>
                <cfset seri_stock_id = get_seri_product.stock_id>
                <cfset seri_product_id = get_seri_product.product_id>
                <cfset seri_product_name = get_seri_product.product_name>
            </cfif>
        </cfif>
        
        <cfif isdefined("arguments.apply_date") and isdate(arguments.apply_date) and isdefined("arguments.finish_date1") and isdate(arguments.finish_date1)>
            <cfset FARK=datediff("n",arguments.apply_date,finish_date1)>
        </cfif>
        <cfif isdefined("arguments.apply_date") and len(arguments.apply_date)>
            <cf_date tarih="arguments.apply_date">
            <cfset arguments.apply_date=date_add("H", arguments.apply_hour - session.ep.time_zone, arguments.apply_date)>
            <cfset arguments.apply_date=date_add("N", arguments.apply_minute,arguments.apply_date)>
        </cfif>
        <cfif isdefined("arguments.start_date1") and len(arguments.start_date1)>
            <cf_date tarih="arguments.start_date1">
            <cfset arguments.start_date1=date_add("H", arguments.start_hour - session.ep.time_zone,arguments.start_date1)>
            <cfset arguments.start_date1=date_add("N", arguments.start_minute,arguments.start_date1)>
        </cfif>
        <cfif isdefined("arguments.intervention_date") and len(arguments.intervention_date)>
            <cf_date tarih="arguments.intervention_date">
            <cfset arguments.intervention_date=date_add("H", arguments.intervention_start_hour - session.ep.time_zone,arguments.intervention_date)>
            <cfset arguments.intervention_date=date_add("N", arguments.intervention_start_minute,arguments.intervention_date)>
        </cfif>
        <cfif isdefined("arguments.finish_date1") and len(arguments.finish_date1)>
            <cf_date tarih="arguments.finish_date1">
            <cfset arguments.finish_date1=date_add("H", arguments.finish_hour - session.ep.time_zone, arguments.finish_date1)>
            <cfset arguments.finish_date1=date_add("N",arguments.finish_minute,arguments.finish_date1)>
        </cfif>
        <cfif isdefined("arguments.guaranty_start_date") and len(arguments.guaranty_start_date)>
            <cf_date tarih="arguments.guaranty_start_date">
        </cfif>
        <cfif isdefined("arguments.subscription_id") and len(arguments.subscription_id)>
            <cfquery name="get_system" datasource="#dsn3#">
                SELECT TOP 1 SC.* FROM SUBSCRIPTION_CONTRACT SC WHERE SC.SUBSCRIPTION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.subscription_id#">
            </cfquery>
            <cfif get_system.recordcount and get_system.valid_days gte 1><!--- sistem var mi --->
                <cfset count_type_ = get_system.valid_days>
                <cfset deger_tarih_ilk_ = arguments.start_date1><!--- now() --->
                <cfset deger_tarih_ = date_add("h",session.ep.time_zone,deger_tarih_ilk_)>
                <cfset deger_saat_ = timeformat(deger_tarih_,'HH')>
                <cfset deger_dakika_ = timeformat(deger_tarih_,'MM')>
                <cfset deger_gercek_ = (deger_saat_ * 60) + deger_dakika_>
                <cfset gun_ = dayofweek(deger_tarih_)>
                <cfif count_type_ eq 1><!--- hafta ici --->
                    <cfset control_baslangic_saat_ = get_system.start_clock_1>			
                    <cfset control_baslangic_dakika_ = get_system.start_minute_1>
                    <cfset deger_baslangic_ = (control_baslangic_saat_ * 60) + control_baslangic_dakika_>
                    
                    <cfset control_bitis_saat_ = get_system.finish_clock_1>			
                    <cfset control_bitis_dakika_ = get_system.finish_minute_1>
                    <cfset deger_bitis_ = (control_bitis_saat_ * 60) + control_bitis_dakika_>
                    
                    <cfset h_ici_total_mesai_ = deger_bitis_ - deger_baslangic_>
                    <cfset cmt_total_mesai_ = 0>
                    <cfset pzr_total_mesai_ = 0>
                    
                    <cfif gun_ eq 1><!--- gun pazar --->
                        <cfset add_day_ = 1>
                        <cfset kabul_ = date_add("d",add_day_,deger_tarih_ilk_)>
                        <cfset kabul_ = createdate(year(kabul_),month(kabul_),day(kabul_))>
                        <cfset kabul_ = date_add("h",control_baslangic_saat_,kabul_)>
                        <cfset kabul_ = date_add('n',control_baslangic_dakika_,kabul_)>
                        <cfset kabul_ = date_add("h",-session.ep.time_zone,kabul_)>
                    <cfelseif gun_ eq 7><!--- gun cmt --->
                        <cfset add_day_ = 2>
                        <cfset kabul_ = date_add("d",add_day_,deger_tarih_ilk_)>
                        <cfset kabul_ = createdate(year(kabul_),month(kabul_),day(kabul_))>
                        <cfset kabul_ = date_add("h",control_baslangic_saat_,kabul_)>
                        <cfset kabul_ = date_add('n',control_baslangic_dakika_,kabul_)>
                        <cfset kabul_ = date_add("h",-session.ep.time_zone,kabul_)>
                    <cfelse><!--- gun hafta ici --->
                            <cfif deger_gercek_ gte deger_baslangic_ and deger_gercek_ lte deger_bitis_>
                                <cfset kabul_ = deger_tarih_ilk_>
                            <cfelseif deger_gercek_ lt deger_baslangic_>
                                <cfset kabul_ = deger_tarih_ilk_>
                                <cfset kabul_ = createdate(year(kabul_),month(kabul_),day(kabul_))>
                                <cfset kabul_ = date_add("h",control_baslangic_saat_,kabul_)>
                                <cfset kabul_ = date_add('n',control_baslangic_dakika_,kabul_)>
                                <cfset kabul_ = date_add("h",-session.ep.time_zone,kabul_)>
                            <cfelseif deger_gercek_ gt deger_bitis_>
                                <cfif gun_ eq 6>
                                    <cfset add_day_ = 2>
                                <cfelse>
                                    <cfset add_day_ = 1>
                                </cfif>					
                                <cfset kabul_ = date_add("d",add_day_,deger_tarih_ilk_)>
                                <cfset kabul_ = createdate(year(kabul_),month(kabul_),day(kabul_))>
                                <cfset kabul_ = date_add("h",control_baslangic_saat_,kabul_)>
                                <cfset kabul_ = date_add('n',control_baslangic_dakika_,kabul_)>
                                <cfset kabul_ = date_add("h",-session.ep.time_zone,kabul_)>
                            </cfif>
                    </cfif>
                <cfelseif count_type_ eq 2><!--- hafta ici + cumartesi --->
                    <cfset control_baslangic_saat_ = get_system.start_clock_1>			
                    <cfset control_baslangic_dakika_ = get_system.start_minute_1>
                    <cfset deger_baslangic_ = (control_baslangic_saat_ * 60) + control_baslangic_dakika_>
                    
                    <cfset control_bitis_saat_ = get_system.finish_clock_1>			
                    <cfset control_bitis_dakika_ = get_system.finish_minute_1>
                    <cfset deger_bitis_ = (control_bitis_saat_ * 60) + control_bitis_dakika_>
                    
                    <cfset control_cmt_baslangic_saat_ = get_system.start_clock_2>			
                    <cfset control_cmt_baslangic_dakika_ = get_system.start_minute_2>
                    <cfset deger_cmt_baslangic_ = (control_cmt_baslangic_saat_ * 60) + control_cmt_baslangic_dakika_>
                    
                    <cfset control_cmt_bitis_saat_ = get_system.finish_clock_2>			
                    <cfset control_cmt_bitis_dakika_ = get_system.finish_minute_2>
                    <cfset deger_cmt_bitis_ = (control_cmt_bitis_saat_ * 60) + control_cmt_bitis_dakika_>
                    
                    
                    <cfset h_ici_total_mesai_ = deger_bitis_ - deger_baslangic_>
                    <cfset cmt_total_mesai_ = deger_cmt_bitis_ - deger_cmt_baslangic_>
                    <cfset pzr_total_mesai_ = 0>
                    
                        <cfif gun_ eq 1><!--- gun pazar --->
                            <cfset add_day_ = 1>
                            <cfset kabul_ = date_add("d",add_day_,deger_tarih_ilk_)>
                            <cfset kabul_ = createdate(year(kabul_),month(kabul_),day(kabul_))>
                            <cfset kabul_ = date_add("h",control_baslangic_saat_,kabul_)>
                            <cfset kabul_ = date_add('n',control_baslangic_dakika_,kabul_)>
                            <cfset kabul_ = date_add("h",-session.ep.time_zone,kabul_)>
                        <cfelseif gun_ eq 7><!--- gun cmt --->
                                <cfif deger_gercek_ gte deger_cmt_baslangic_ and deger_gercek_ lte deger_cmt_bitis_>
                                    <cfset kabul_ = deger_tarih_ilk_>
                                <cfelseif deger_gercek_ lt deger_cmt_baslangic_>
                                    <cfset kabul_ = deger_tarih_ilk_>
                                    <cfset kabul_ = createdate(year(kabul_),month(kabul_),day(kabul_))>
                                    <cfset kabul_ = date_add("h",control_cmt_baslangic_saat_,kabul_)>
                                    <cfset kabul_ = date_add('n',control_cmt_baslangic_dakika_,kabul_)>
                                    <cfset kabul_ = date_add("h",-session.ep.time_zone,kabul_)>
                                <cfelseif deger_gercek_ gt deger_cmt_bitis_>
                                    <cfset add_day_ = 2>
                                    <cfset kabul_ = date_add("d",add_day_,deger_tarih_ilk_)>
                                    <cfset kabul_ = createdate(year(kabul_),month(kabul_),day(kabul_))>
                                    <cfset kabul_ = date_add("h",control_baslangic_saat_,kabul_)>
                                    <cfset kabul_ = date_add('n',control_baslangic_dakika_,kabul_)>
                                    <cfset kabul_ = date_add("h",-session.ep.time_zone,kabul_)>
                                </cfif>
                        <cfelse><!--- gun hafta ici --->
                                <cfif deger_gercek_ gte deger_baslangic_ and deger_gercek_ lte deger_bitis_>
                                    <cfset kabul_ = deger_tarih_ilk_>
                                <cfelseif deger_gercek_ lt deger_baslangic_>
                                    <cfset kabul_ = deger_tarih_ilk_>
                                    <cfset kabul_ = createdate(year(kabul_),month(kabul_),day(kabul_))>
                                    <cfset kabul_ = date_add("h",control_baslangic_saat_,kabul_)>
                                    <cfset kabul_ = date_add('n',control_baslangic_dakika_,kabul_)>
                                    <cfset kabul_ = date_add("h",-session.ep.time_zone,kabul_)>
                                <cfelseif deger_gercek_ gt deger_bitis_>
                                    <cfif gun_ eq 6>
                                        <cfset add_day_ = 1>
                                        <cfset kabul_ = date_add("d",add_day_,deger_tarih_ilk_)>
                                        <cfset kabul_ = createdate(year(kabul_),month(kabul_),day(kabul_))>
                                        <cfset kabul_ = date_add("h",control_cmt_baslangic_saat_,kabul_)>
                                        <cfset kabul_ = date_add('n',control_cmt_baslangic_dakika_,kabul_)>
                                        <cfset kabul_ = date_add("h",-session.ep.time_zone,kabul_)>
                                    <cfelse>
                                        <cfset add_day_ = 1>
                                        <cfset kabul_ = date_add("d",add_day_,deger_tarih_ilk_)>
                                        <cfset kabul_ = createdate(year(kabul_),month(kabul_),day(kabul_))>
                                        <cfset kabul_ = date_add("h",control_baslangic_saat_,kabul_)>
                                        <cfset kabul_ = date_add('n',control_baslangic_dakika_,kabul_)>
                                        <cfset kabul_ = date_add("h",-session.ep.time_zone,kabul_)>
                                    </cfif>					
                                </cfif>
                        </cfif>	
                <cfelseif count_type_ eq 3><!--- pazar --->
                    <cfset control_baslangic_saat_ = get_system.start_clock_1>			
                    <cfset control_baslangic_dakika_ = get_system.start_minute_1>
                    <cfset deger_baslangic_ = (control_baslangic_saat_ * 60) + control_baslangic_dakika_>
                    
                    <cfset control_bitis_saat_ = get_system.finish_clock_1>			
                    <cfset control_bitis_dakika_ = get_system.finish_minute_1>
                    <cfset deger_bitis_ = (control_bitis_saat_ * 60) + control_bitis_dakika_>
                    
                    <cfset control_cmt_baslangic_saat_ = get_system.start_clock_2>			
                    <cfset control_cmt_baslangic_dakika_ = get_system.start_minute_2>
                    <cfset deger_cmt_baslangic_ = (control_cmt_baslangic_saat_ * 60) + control_cmt_baslangic_dakika_>
                    
                    <cfset control_cmt_bitis_saat_ = get_system.finish_clock_2>			
                    <cfset control_cmt_bitis_dakika_ = get_system.finish_minute_2>
                    <cfset deger_cmt_bitis_ = (control_cmt_bitis_saat_ * 60) + control_cmt_bitis_dakika_>
                    
                    <cfset control_pzr_baslangic_saat_ = get_system.start_clock_3>			
                    <cfset control_pzr_baslangic_dakika_ = get_system.start_minute_3>
                    <cfset deger_pzr_baslangic_ = (control_pzr_baslangic_saat_ * 60) + control_pzr_baslangic_dakika_>
                    
                    <cfset control_pzr_bitis_saat_ = get_system.finish_clock_3>			
                    <cfset control_pzr_bitis_dakika_ = get_system.finish_minute_3>
                    <cfset deger_pzr_bitis_ = (control_pzr_bitis_saat_ * 60) + control_pzr_bitis_dakika_>
                    
                    <cfset h_ici_total_mesai_ = deger_bitis_ - deger_baslangic_>
                    <cfset cmt_total_mesai_ = deger_cmt_bitis_ - deger_cmt_baslangic_>
                    <cfset pzr_total_mesai_ = deger_pzr_bitis_ - deger_pzr_baslangic_>
                    
                            <cfif gun_ eq 1><!--- gun pazar --->
                                <cfif deger_gercek_ gte deger_pzr_baslangic_ and deger_gercek_ lte deger_pzr_bitis_>
                                    <cfset kabul_ = deger_tarih_ilk_>
                                <cfelseif deger_gercek_ lt deger_pzr_baslangic_>
                                    <cfset kabul_ = deger_tarih_ilk_>
                                    <cfset kabul_ = createdate(year(kabul_),month(kabul_),day(kabul_))>
                                    <cfset kabul_ = date_add("h",control_pzr_baslangic_saat_,kabul_)>
                                    <cfset kabul_ = date_add('n',control_pzr_baslangic_dakika_,kabul_)>
                                    <cfset kabul_ = date_add("h",-session.ep.time_zone,kabul_)>
                                <cfelseif deger_gercek_ gt deger_pzr_baslangic_>
                                    <cfset add_day_ = 1>
                                    <cfset kabul_ = date_add("d",add_day_,deger_tarih_ilk_)>
                                    <cfset kabul_ = createdate(year(kabul_),month(kabul_),day(kabul_))>
                                    <cfset kabul_ = date_add("h",control_baslangic_saat_,kabul_)>
                                    <cfset kabul_ = date_add('n',control_baslangic_dahika_,kabul_)>
                                    <cfset kabul_ = date_add("h",-session.ep.time_zone,kabul_)>
                                </cfif>
                            <cfelseif gun_ eq 7><!--- gun cmt --->
                                <cfif deger_gercek_ gte deger_cmt_baslangic_ and deger_gercek_ lte deger_cmt_bitis_>
                                    <cfset kabul_ = deger_tarih_ilk_>
                                <cfelseif deger_gercek_ lt deger_cmt_baslangic_>
                                    <cfset kabul_ = deger_tarih_ilk_>
                                    <cfset kabul_ = createdate(year(kabul_),month(kabul_),day(kabul_))>
                                    <cfset kabul_ = date_add("h",control_cmt_baslangic_saat_,kabul_)>
                                    <cfset kabul_ = date_add('n',control_cmt_baslangic_dakika_,kabul_)>
                                    <cfset kabul_ = date_add("h",-session.ep.time_zone,kabul_)>
                                <cfelseif deger_gercek_ gt deger_cmt_bitis_>
                                    <cfset add_day_ = 1>
                                    <cfset kabul_ = date_add("d",add_day_,deger_tarih_ilk_)>
                                    <cfset kabul_ = createdate(year(kabul_),month(kabul_),day(kabul_))>
                                    <cfset kabul_ = date_add("h",control_pzr_baslangic_saat_,kabul_)>
                                    <cfset kabul_ = date_add('n',control_pzr_baslangic_dakika_,kabul_)>
                                    <cfset kabul_ = date_add("h",-session.ep.time_zone,kabul_)>
                                </cfif>
                            <cfelse><!--- gun hafta ici --->
                                <cfif deger_gercek_ gte deger_baslangic_ and deger_gercek_ lte deger_bitis_>
                                    <cfset kabul_ = deger_tarih_ilk_>
                                <cfelseif deger_gercek_ lt deger_baslangic_>
                                    <cfset kabul_ = deger_tarih_ilk_>
                                    <cfset kabul_ = createdate(year(kabul_),month(kabul_),day(kabul_))>
                                    <cfset kabul_ = date_add("h",control_baslangic_saat_,kabul_)>
                                    <cfset kabul_ = date_add('n',control_baslangic_dakika_,kabul_)>
                                    <cfset kabul_ = date_add("h",-session.ep.time_zone,kabul_)>
                                <cfelseif deger_gercek_ gt deger_bitis_>
                                    <cfif gun_ eq 6>
                                        <cfset add_day_ = 1>
                                        <cfset kabul_ = date_add("d",add_day_,deger_tarih_ilk_)>
                                        <cfset kabul_ = createdate(year(kabul_),month(kabul_),day(kabul_))>
                                        <cfset kabul_ = date_add("h",control_cmt_baslangic_saat_,kabul_)>
                                        <cfset kabul_ = date_add('n',control_cmt_baslangic_dakika_,kabul_)>
                                        <cfset kabul_ = date_add("h",-session.ep.time_zone,kabul_)>
                                    <cfelse>
                                        <cfset add_day_ = 1>
                                        <cfset kabul_ = date_add("d",add_day_,deger_tarih_ilk_)>
                                        <cfset kabul_ = createdate(year(kabul_),month(kabul_),day(kabul_))>
                                        <cfset kabul_ = date_add("h",control_baslangic_saat_,kabul_)>
                                        <cfset kabul_ = date_add('n',control_baslangic_dakika_,kabul_)>
                                        <cfset kabul_ = date_add("h",-session.ep.time_zone,kabul_)>
                                    </cfif>					
                                </cfif>
                            </cfif>	
                </cfif>
            </cfif><!--- sistem var mi --->
        </cfif>
        <cfif isdefined("kabul_")>
            <cfif len(get_system.hour1) and len(get_system.minute1)>
                <cfset cozum_suresi_ = (get_system.hour1 * 60) + get_system.minute1>
            <cfelseif len(get_system.hour1)>
                <cfset cozum_suresi_ = (get_system.hour1 * 60)>
            <cfelseif len(get_system.minute1)>
                <cfset cozum_suresi_ = get_system.minute1>
            <cfelse>
                <cfset cozum_suresi_ = 60>
            </cfif>
            <cfif len(get_system.response_hour1) and len(get_system.response_minute1)>
                <cfset mudahale_suresi_ = (get_system.response_hour1 * 60) + get_system.response_minute1>
            <cfelseif len(get_system.response_hour1)>
                <cfset mudahale_suresi_ = (get_system.response_hour1 * 60)>
            <cfelseif len(get_system.response_minute1)>
                <cfset mudahale_suresi_ = get_system.response_minute1>
            <cfelse>
                <cfset mudahale_suresi_ = 60>
            </cfif>
            <cfset gun_ = dayofweek(kabul_)>
            <cfif gun_ eq 7><!--- cumartesi --->
                <cfset today_finish_ = deger_cmt_bitis_>
            <cfelseif gun_ eq 1><!--- pazar --->
                <cfif isdefined("deger_pzr_bitis_")>
                    <cfset today_finish_ = deger_pzr_bitis_>
                <cfelse>
                    <cfset today_finish_ = 0>
                </cfif>
            <cfelse>
                <cfset today_finish_ = deger_bitis_>
            </cfif>
            <cfset deger_saat_ = timeformat(kabul_,'HH')>
            <cfset deger_dakika_ = timeformat(kabul_,'MM')>
            <cfset deger_gercek_ = (deger_saat_ * 60) + deger_dakika_>
            <cfif today_finish_ gt (cozum_suresi_ + deger_gercek_)>
                <cfset arguments.cozum_suresi_ = date_add("n",cozum_suresi_,kabul_)>
            <cfelse>
                <cfset kalan_sure = cozum_suresi_ - (today_finish_ - deger_gercek_)>
                <cfset flag = 1>
                <cfset day_add_ = 0>
                <cfscript>
                    while(flag)
                        {
                        day_add_ = day_add_ + 1;
                        new_date_gun_ = date_add("d",day_add_,kabul_);
                        get_day_ = dayofweek(new_date_gun_);
                        if(get_day_ eq 7)
                            {
                                if(cmt_total_mesai_ gt kalan_sure)
                                    {
                                    arguments.cozum_suresi_ = createodbcdatetime(createdate(year(new_date_gun_),month(new_date_gun_),day(new_date_gun_)));
                                    arguments.cozum_suresi_ = date_add("n",(deger_cmt_baslangic_+kalan_sure),arguments.cozum_suresi_);
                                    flag = 0;
                                    }
                                else
                                    {
                                    kalan_sure = kalan_sure - cmt_total_mesai_;
                                    }
                            }
                        else if(get_day_ eq 1)
                            {
                                if(pzr_total_mesai_ gt kalan_sure)
                                    {
                                    arguments.cozum_suresi_ = createodbcdatetime(createdate(year(new_date_gun_),month(new_date_gun_),day(new_date_gun_)));
                                    arguments.cozum_suresi_ = date_add("n",(deger_pzr_baslangic_+kalan_sure),arguments.cozum_suresi_);
                                    flag = 0;
                                    }
                                else
                                    {
                                    kalan_sure = kalan_sure - pzr_total_mesai_;
                                    }
                            }
                        else
                            {
                                if(h_ici_total_mesai_ gt kalan_sure)
                                    {
                                    arguments.cozum_suresi_ = createodbcdatetime(createdate(year(new_date_gun_),month(new_date_gun_),day(new_date_gun_)));
                                    arguments.cozum_suresi_ = date_add("n",(deger_baslangic_+kalan_sure),arguments.cozum_suresi_);
                                    flag = 0;
                                    }
                                else
                                    {
                                    kalan_sure = kalan_sure - h_ici_total_mesai_;
                                    }
                            }
                        }
                </cfscript>	
            </cfif>
            
            <cfif today_finish_ gt (mudahale_suresi_ + deger_gercek_)>
                <cfset arguments.mudahale_suresi_ = date_add("n",mudahale_suresi_,kabul_)>
            <cfelse>
                <cfset kalan_sure = mudahale_suresi_ - (today_finish_ - deger_gercek_)>
                <cfset flag2 = 1>
                <cfset day_add2_ = 0>
                <cfscript>
                    while(flag2)
                        {
                        day_add2_ = day_add2_ + 1;
                        new_date_gun2_ = date_add("d",day_add2_,kabul_);
                        get_day2_ = dayofweek(new_date_gun2_);
                        if(get_day2_ eq 7)
                            {
                                if(cmt_total_mesai_ gt kalan_sure)
                                    {
                                    arguments.mudahale_suresi_ = createodbcdatetime(createdate(year(new_date_gun2_),month(new_date_gun2_),day(new_date_gun2_)));
                                    arguments.mudahale_suresi_ = date_add("n",(deger_cmt_baslangic_+kalan_sure),arguments.mudahale_suresi_);
                                    flag2 = 0;
                                    }
                                else
                                    {
                                    kalan_sure = kalan_sure - cmt_total_mesai_;
                                    }
                            }
                        else if(get_day2_ eq 1)
                            {
                                if(pzr_total_mesai_ gt kalan_sure)
                                    {
                                    arguments.mudahale_suresi_ = createodbcdatetime(createdate(year(new_date_gun2_),month(new_date_gun2_),day(new_date_gun2_)));
                                    arguments.mudahale_suresi_ = date_add("n",(deger_pzr_baslangic_+kalan_sure),arguments.mudahale_suresi_);
                                    flag2 = 0;
                                    }
                                else
                                    {
                                    kalan_sure = kalan_sure - pzr_total_mesai_;
                                    }
                            }
                        else
                            {
                                if(h_ici_total_mesai_ gt kalan_sure)
                                    {
                                    arguments.mudahale_suresi_ = createodbcdatetime(createdate(year(new_date_gun2_),month(new_date_gun2_),day(new_date_gun2_)));
                                    arguments.mudahale_suresi_ = date_add("n",(deger_baslangic_+kalan_sure),arguments.mudahale_suresi_);
                                    flag2 = 0;
                                    }
                                else
                                    {
                                    kalan_sure = kalan_sure - h_ici_total_mesai_;
                                    }
                            }
                        }
                </cfscript>
            </cfif>
        </cfif>
        <cfquery name="GET_DATE_CONTROL" datasource="#DSN3#">
            SELECT SERVICE_STATUS_ID FROM SERVICE WHERE SERVICE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.SERVICE_ID#">
        </cfquery>
        <cfset is_change = 0>
        <cfif GET_DATE_CONTROL.SERVICE_STATUS_ID neq arguments.process_stage>
            <cfset is_change = 1>
        </cfif>
            <cftry>
                <cfquery name="UPD_SERVICE" datasource="#DSN3#">
                    UPDATE
                        SERVICE
                    SET
                        SERVICE_ACTIVE = <cfif isDefined("arguments.status")>1<cfelse>0</cfif>,
                        SERVICECAT_ID = #arguments.appcat_id#,
                        SERVICE_STATUS_ID = #arguments.process_stage#,		
                        SERVICE_SUBSTATUS_ID = <cfif isDefined('arguments.service_substatus_id') and len(arguments.service_substatus_id)>#arguments.service_substatus_id#<cfelse>NULL</cfif>,
                        PRO_SERIAL_NO = <cfif isDefined("arguments.service_product_serial") and len(arguments.service_product_serial)>'#arguments.service_product_serial#'<cfelse>NULL</cfif>,
                        <cfif isDefined("arguments.MAIN_SERIAL_NO")>MAIN_SERIAL_NO = '#arguments.MAIN_SERIAL_NO#',</cfif>
                        GUARANTY_INSIDE = <cfif isdefined("arguments.guaranty_inside")>1<cfelse>0</cfif>,
                        INSIDE_DETAIL = <cfif isdefined("arguments.inside_detail") and len(arguments.inside_detail)>'#arguments.inside_detail#'<cfelse>NULL</cfif>,
                        STOCK_ID = <cfif isDefined("arguments.stock_id") and len(arguments.stock_id) and len(arguments.service_product)>#arguments.stock_id#<cfelseif isdefined("seri_stock_id")>'#seri_stock_id#'<cfelse>NULL</cfif>,
                        PRODUCT_NAME = <cfif isdefined("arguments.service_product") and len(arguments.service_product) and len(arguments.service_product_id)>'#arguments.service_product#',<cfelseif isdefined("seri_product_name")>'#seri_product_name#',<cfelse>NULL,</cfif>
                        SERVICE_PRODUCT_ID = <cfif isDefined("arguments.service_product_id") and len(arguments.service_product_id) and len(arguments.service_product)>#arguments.service_product_id#,<cfelseif isdefined("seri_product_id")>#seri_product_id#,<cfelse>NULL,</cfif>
                        SPEC_MAIN_ID = <cfif isDefined("arguments.spec_main_id") and len(arguments.spec_main_id) and len(arguments.spect_name)>#arguments.spec_main_id#,<cfelse>NULL,</cfif>
                        <cfif isDefined("G_ID")>GUARANTY_ID = #G_ID#,</cfif>
                        <cfif len(arguments.priority_id)>PRIORITY_ID = #arguments.priority_id#,</cfif>
                        <cfif len(arguments.commethod_id)>COMMETHOD_ID = #arguments.commethod_id#,</cfif>
                        RELATED_COMPANY_ID = <cfif len(arguments.RELATED_COMPANY_ID) and len(arguments.RELATED_COMPANY)>#arguments.RELATED_COMPANY_ID#<cfelse>NULL</cfif>,
                        SERVICE_HEAD = <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#arguments.service_head#">,
                        SERVICE_DETAIL = <cfif len(arguments.service_detail)>'#arguments.service_detail#'<cfelse>NULL</cfif>,
                        SERVICE_ADDRESS = <cfif isdefined("arguments.service_address") and len(arguments.service_address)>'#arguments.service_address#'<cfelse>NULL</cfif>,
                        SERVICE_COUNTY_ID = <cfif isdefined("arguments.service_county_id") and len(arguments.service_county_id) and len(arguments.service_county_name)>#arguments.service_county_id#<cfelse>NULL</cfif>,
                        SERVICE_CITY_ID = <cfif isdefined("arguments.service_city_id") and len(arguments.service_city_id)>#arguments.service_city_id#<cfelse>NULL</cfif>,
                        SERVICE_COUNTY = <cfif isdefined("arguments.service_county") and len(arguments.service_county)>'#arguments.service_county#'<cfelse>NULL</cfif>,
                        SERVICE_CITY =  <cfif isdefined("arguments.service_city") and len(arguments.service_city)>'#arguments.service_city#'<cfelse>NULL</cfif>,
                        <cfif arguments.member_type is 'partner'>
                            SERVICE_CONSUMER_ID = NULL,
                            SERVICE_PARTNER_ID = #arguments.member_id#,
                            SERVICE_COMPANY_ID = #arguments.company_id#,					
                        <cfelseif arguments.member_type is 'consumer'>
                            SERVICE_CONSUMER_ID = #arguments.member_id#,
                            SERVICE_PARTNER_ID = NULL,
                            SERVICE_COMPANY_ID = NULL,
                        <cfelse>
                            SERVICE_CONSUMER_ID = NULL,
                            SERVICE_PARTNER_ID = NULL,
                            SERVICE_COMPANY_ID = NULL,
                        </cfif>
                        BRING_NAME = <cfif isdefined("arguments.bring_name") and len(arguments.bring_name)>'#arguments.bring_name#'<cfelse>NULL</cfif>,
                        BRING_EMAIL = <cfif isdefined("arguments.bring_email") and len(arguments.bring_email)>'#arguments.bring_email#'<cfelse>NULL</cfif>,
                        DOC_NO = <cfif isdefined("arguments.doc_no") and len(arguments.doc_no)>'#arguments.doc_no#'<cfelse>NULL</cfif>,
                        BRING_TEL_NO = <cfif isdefined("arguments.bring_tel_no") and len(arguments.bring_tel_no)>'#arguments.bring_tel_no#'<cfelse>NULL</cfif>,
                
                        BRING_MOBILE_NO = <cfif isdefined("arguments.bring_mobile_no") and len(arguments.bring_mobile_no)>'#arguments.bring_mobile_no#'<cfelse>NULL</cfif>,
                        BRING_DETAIL = <cfif isdefined("arguments.bring_detail") and len(arguments.bring_detail)>'#arguments.bring_detail#'<cfelse>NULL</cfif>,
                        GUARANTY_START_DATE = <cfif isDefined("arguments.GUARANTY_START_DATE") and len(arguments.GUARANTY_START_DATE)>#arguments.GUARANTY_START_DATE#<cfelse>NULL</cfif>,
                        DEAD_LINE = <cfif isdefined("arguments.cozum_suresi_")>#arguments.cozum_suresi_#<cfelse>NULL</cfif>,
                        DEAD_LINE_RESPONSE = <cfif isdefined("arguments.mudahale_suresi_")>#arguments.mudahale_suresi_#<cfelse>NULL</cfif>,
                        APPLY_DATE = <cfif len(arguments.apply_date)>#arguments.apply_date#<cfelse>NULL</cfif>,
                        START_DATE = <cfif len(arguments.start_date1)>#arguments.start_date1#<cfelse>NULL</cfif>,
                        INTERVENTION_DATE = <cfif isdefined('arguments.intervention_date') and len(arguments.intervention_date)>#arguments.intervention_date#<cfelse>NULL</cfif>,
                        FINISH_DATE = <cfif len(arguments.finish_date1)>#arguments.finish_date1#<cfelse>NULL</cfif>,
                        PAID_REPAIR = <cfif isdefined("arguments.paid_repair")>1<cfelse>0</cfif>,
                        ACCESSORY = <cfif isdefined("arguments.accessory") and arguments.accessory eq 1>1<cfelse>0</cfif>,
                        ACCESSORY_DETAIL = <cfif isdefined("arguments.accessory_detail") and len(arguments.accessory_detail) and isdefined("arguments.accessory") and arguments.accessory eq 1>'#accessory_detail#'<cfelse>NULL</cfif>,
                        SERVICE_BRANCH_ID = <cfif isDefined("arguments.service_branch_id") and len(arguments.service_branch_id)>#arguments.service_branch_id#<cfelse>NULL</cfif>,
                        DEPARTMENT_ID = <cfif len(arguments.department_id) and len(arguments.department)>#arguments.department_id#<cfelse>NULL</cfif>,
                        LOCATION_ID = <cfif len(arguments.location_id) and len(arguments.department)>#arguments.location_id#<cfelse>NULL</cfif>,
                        SERVICE_DEFECT_CODE = <cfif isdefined("arguments.service_defect_code") and len(arguments.service_defect_code)>'#arguments.service_defect_code#'<cfelse>NULL</cfif>,
                        APPLICATOR_NAME = '#arguments.member_name#',
                        PROJECT_ID = <cfif len(arguments.project_id) and len(arguments.project_head)>#arguments.project_id#,<cfelse>NULL,</cfif>
                        SUBSCRIPTION_ID = <cfif isdefined("arguments.subscription_id") and len(arguments.subscription_id) and isdefined("arguments.subscription_no") and len(arguments.subscription_no)>#arguments.subscription_id#<cfelse>NULL</cfif>,
                        <!--- <cfif isdefined("arguments.subscription_id") and len(arguments.subscription_id)>SUBSCRIPTION_ID = #arguments.subscription_id#,</cfif> --->
                        <cfif isdefined("arguments.sales_add_option")> SALE_ADD_OPTION_ID = <cfif len(arguments.sales_add_option)>#arguments.sales_add_option#<cfelse>NULL</cfif>,</cfif>
                        APPLICATOR_COMP_NAME = <cfif isDefined("arguments.applicator_comp_name") and len(arguments.applicator_comp_name)>'#arguments.applicator_comp_name#'<cfelse>NULL</cfif>,
                        IS_SALARIED = <cfif isdefined("arguments.is_salaried")>1<cfelse>0</cfif>,
                        SHIP_METHOD = <cfif isdefined("arguments.ship_method") and len(arguments.ship_method) and len(arguments.ship_method_name)>#arguments.ship_method#<cfelse>NULL</cfif>,
                        OTHER_COMPANY_ID = <cfif isdefined("arguments.other_company_id") and len(arguments.other_company_id) and len(arguments.other_company_name)>#arguments.other_company_id#<cfelse>NULL</cfif>,
                        OTHER_COMPANY_BRANCH_ID = <cfif isdefined("arguments.other_company_branch_id") and len(arguments.other_company_branch_id) and len(arguments.other_company_branch_name)>#arguments.other_company_branch_id#<cfelse>NULL</cfif>,
                        INSIDE_DETAIL_SELECT = <cfif isdefined("arguments.inside_detail_select") and len(arguments.inside_detail_select) and isdefined("arguments.guaranty_inside")>'#arguments.inside_detail_select#'<cfelse>NULL</cfif>,
                        ACCESSORY_DETAIL_SELECT = <cfif isdefined("arguments.accessory_detail_select") and len(arguments.accessory_detail_select)>'#arguments.accessory_detail_select#'<cfelse>NULL</cfif>,
                        SERVICECAT_SUB_ID = <cfif isdefined("arguments.appcat_sub_id") and len(arguments.appcat_sub_id)>'#arguments.appcat_sub_id#'<cfelse>NULL</cfif>,
                        SERVICECAT_SUB_STATUS_ID = <cfif isdefined("arguments.appcat_sub_status_id") and len(arguments.appcat_sub_status_id)>'#arguments.appcat_sub_status_id#'<cfelse>NULL</cfif>,
                        SZ_ID=<cfif isdefined("arguments.sales_zone_id") and len(arguments.sales_zone_id)>#arguments.sales_zone_id#<cfelse>NULL</cfif>,
                        BRING_SHIP_METHOD_ID = <cfif isdefined("arguments.bring_ship_method_name") and len(arguments.bring_ship_method_name) and len(arguments.bring_ship_method_id)>#arguments.bring_ship_method_id#<cfelse>NULL</cfif>,
                        UPDATE_DATE = #now()#,
                        UPDATE_MEMBER = #session.ep.userid#	,
                        SERVICE_EMPLOYEE_ID = <cfif len(arguments.task_person_name) and len(arguments.task_emp_id)>#arguments.task_emp_id#<cfelse>NULL</cfif>,
                        TIME_CLOCK_HOUR = <cfif isdefined("arguments.time_clock_hour") and len(arguments.time_clock_hour)>#arguments.time_clock_hour#<cfelse>NULL</cfif>,
                        TIME_CLOCK_MINUTE = <cfif isdefined("arguments.time_clock_minute") and len(arguments.time_clock_minute)>#arguments.time_clock_minute#<cfelse>NULL</cfif>
                    WHERE
                        SERVICE_ID = #arguments.id#
                </cfquery>
                
                <cfquery name="GET_SERVICE1" datasource="#DSN3#">
                    SELECT * FROM SERVICE WHERE SERVICE_ID = #arguments.id#
                </cfquery>
                <cfif len(get_service1.record_date)><cfset arguments.record_date = createodbcdatetime(get_service1.record_date)></cfif>
                <cfif len(get_service1.apply_date)><cfset arguments.apply_date = createodbcdatetime(get_service1.apply_date)></cfif>
                <cfif len(get_service1.start_date)><cfset arguments.start_date = createodbcdatetime(get_service1.start_date)></cfif>
                <cfif len(get_service1.finish_date)><cfset arguments.finish_date = createodbcdatetime(get_service1.finish_date)></cfif>
                <cfif len(get_service1.update_date)><cfset arguments.update_date = createodbcdatetime(get_service1.update_date)></cfif>
                <cfif len(get_service1.INTERVENTION_DATE)><cfset arguments.INTERVENTION_DATE = createodbcdatetime(get_service1.INTERVENTION_DATE)></cfif>
                <cfquery name="ADD_HISTORY" datasource="#DSN3#">
                    INSERT INTO
                        SERVICE_HISTORY
                    (
                        RELATED_COMPANY_ID,
                        SERVICE_ACTIVE,
                        SERVICECAT_ID,
                        PRO_SERIAL_NO,
                        STOCK_ID,
                        PRODUCT_NAME,
                        SERVICE_SUBSTATUS_ID,
                        SERVICE_STATUS_ID,
                        GUARANTY_ID,
                        GUARANTY_PAGE_NO,
                        PRIORITY_ID,
                        COMMETHOD_ID,				
                        SERVICE_HEAD,
                        SERVICE_DETAIL,
                        SERVICE_ADDRESS,
                        SERVICE_COUNTY,
                        SERVICE_CITY,
                        SERVICE_CONSUMER_ID,
                        NOTES,
                        APPLY_DATE,
                        FINISH_DATE,
                        START_DATE,
                        SERVICE_PRODUCT_ID,
                        SPEC_MAIN_ID,
                        SERVICE_DEFECT_CODE,
                        APPLICATOR_NAME,
                        PROJECT_ID,
                        RECORD_DATE,
                        RECORD_MEMBER,
                        UPDATE_DATE,
                        UPDATE_MEMBER,
                        RECORD_PAR,
                        UPDATE_PAR,
                        SHIP_METHOD,
                        OTHER_COMPANY_ID,
                        SERVICE_COUNTY_ID,
                        SERVICE_CITY_ID,
                        SERVICE_ID,
                        SERVICECAT_SUB_ID,
                        SERVICECAT_SUB_STATUS_ID,
                        WORKGROUP_ID,
                        CALL_SERVICE_ID,
                        INTERVENTION_DATE,
                        GUARANTY_INSIDE,
                        SERVICE_BRANCH_ID
                    )
                    VALUES
                    (
                        <cfif len(get_service1.RELATED_COMPANY_ID)>#get_service1.RELATED_COMPANY_ID#<cfelse>NULL</cfif>,
                        #get_service1.service_active#,
                        <cfif len(get_service1.servicecat_id)>#get_service1.servicecat_id#<cfelse>NULL</cfif>,
                        <cfif len(get_service1.pro_serial_no)>'#get_service1.pro_serial_no#'<cfelse>NULL</cfif>,
                        <cfif len(get_service1.stock_id)>#get_service1.stock_id#<cfelse>NULL</cfif>,
                        <cfif len(get_service1.product_name)>'#get_service1.product_name#'<cfelse>NULL</cfif>,
                        <cfif len(get_service1.service_substatus_id)>#get_service1.service_substatus_id#<cfelse>NULL</cfif>,
                        <cfif len(get_service1.service_status_id)>#get_service1.service_status_id#<cfelse>NULL</cfif>,
                        <cfif len(get_service1.guaranty_id)>#get_service1.guaranty_id#<cfelse>NULL</cfif>,
                        <cfif len(get_service1.guaranty_page_no)>#get_service1.guaranty_page_no#<cfelse>NULL</cfif>,
                        <cfif len(get_service1.priority_id)>#get_service1.priority_id#<cfelse>NULL</cfif>,
                        <cfif len(get_service1.commethod_id)>#get_service1.commethod_id#<cfelse>NULL</cfif>,
                        <cfif len(get_service1.service_head)>'#wrk_eval("get_service1.service_head")#'<cfelse>NULL</cfif>,
                        <cfif len(get_service1.service_detail)>'#get_service1.service_detail#'<cfelse>NULL</cfif>,
                        <cfif len(get_service1.service_address)>'#get_service1.service_address#'<cfelse>NULL</cfif>,
                        <cfif len(get_service1.service_county)>'#get_service1.service_county#'<cfelse>NULL</cfif>,
                        <cfif len(get_service1.service_city)>'#get_service1.service_city#'<cfelse>NULL</cfif>,
                        <cfif len(get_service1.service_consumer_id)>#get_service1.service_consumer_id#<cfelse>NULL</cfif>,
                        <cfif len(get_service1.notes)>'#get_service1.notes#'<cfelse>NULL</cfif>,
                        <cfif len(get_service1.apply_date)>#createodbcdatetime(get_service1.apply_date)#<cfelse>NULL</cfif>,
                        <cfif len(get_service1.finish_date)>#createodbcdatetime(get_service1.finish_date)#<cfelse>NULL</cfif>,
                        <cfif len(get_service1.start_date)>#createodbcdatetime(get_service1.start_date)#<cfelse>NULL</cfif>,
                        <cfif len(get_service1.service_product_id)>#get_service1.service_product_id#<cfelse>NULL</cfif>,
                        <cfif len(get_service1.SPEC_MAIN_ID)>#get_service1.SPEC_MAIN_ID#<cfelse>NULL</cfif>,
                        <cfif len(get_service1.service_defect_code)>'#get_service1.service_defect_code#'<cfelse>NULL</cfif>,
                        <cfif len(get_service1.applicator_name) and isdefined('get_service1.applicator_name')>'#get_service1.applicator_name#'<cfelse>NULL</cfif>,
                        <cfif len(get_service1.PROJECT_ID)>#get_service1.PROJECT_ID#<cfelse>NULL</cfif>,
                        <cfif len(get_service1.record_date)>#createodbcdatetime(get_service1.record_date)#<cfelse>NULL</cfif>,
                        <cfif len(get_service1.record_member)>#get_service1.record_member#<cfelse>NULL</cfif>,
                        <cfif len(get_service1.update_date)>#createodbcdatetime(get_service1.update_date)#<cfelse>NULL</cfif>,
                        <cfif len(get_service1.update_member)>#get_service1.update_member#<cfelse>NULL</cfif>,
                        <cfif len(get_service1.record_par)>#get_service1.record_par#<cfelse>NULL</cfif>,
                        <cfif len(get_service1.update_par)>#get_service1.update_par#<cfelse>NULL</cfif>,
                        <cfif len(get_service1.ship_method)>#get_service1.ship_method#<cfelse>NULL</cfif>,
                        <cfif len(get_service1.other_company_id)>#get_service1.OTHER_COMPANY_ID#<cfelse>NULL</cfif>,
                        <cfif len(get_service1.service_county_id)>#get_service1.service_county_id#<cfelse>NULL</cfif>,
                        <cfif len(get_service1.service_city_id)>#get_service1.service_city_id#<cfelse>NULL</cfif>,							
                        #get_service1.service_id#,
                        <cfif len(get_service1.servicecat_sub_id)>#get_service1.SERVICECAT_SUB_ID#<cfelse>NULL</cfif>,
                        <cfif len(get_service1.servicecat_sub_status_id)>#get_service1.SERVICECAT_SUB_STATUS_ID#<cfelse>NULL</cfif>,
                        <cfif len(get_service1.workgroup_id)>#get_service1.WORKGROUP_ID#<cfelse>NULL</cfif>,
                        <cfif len(get_service1.call_service_id)>#get_service1.CALL_SERVICE_ID#<cfelse>NULL</cfif>,
                        <cfif len(get_service1.INTERVENTION_DATE)>#createodbcdatetime(get_service1.INTERVENTION_DATE)#<cfelse>NULL</cfif>,
                        #get_service1.GUARANTY_INSIDE#,
                        <cfif len(get_service1.SERVICE_BRANCH_ID)>#get_service1.SERVICE_BRANCH_ID#<cfelse>NULL</cfif>
                    )
                </cfquery>
                <cfquery name="del_defected_code" datasource="#dsn3#">
                    DELETE FROM SERVICE_CODE_ROWS WHERE SERVICE_ID=#arguments.id#
                </cfquery>
                
                <cfif isdefined("arguments.failure_code") and listlen(arguments.failure_code)>
                    <cfloop list="#arguments.failure_code#" index="m">
                            <cfquery name="ADD_SERVICE_CODE_ROWS" datasource="#dsn3#">
                                INSERT INTO
                                    SERVICE_CODE_ROWS
                                (
                                    SERVICE_CODE_ID,
                                    SERVICE_ID
                                )				
                                VALUES
                                (
                                    #m#,
                                    #arguments.id#
                                )
                            </cfquery>
                    </cfloop>
                </cfif>
                <!--- Custom Tag' a Gidecek Parametreler --->
                <!---Ek Bilgiler--->
                <cfset arguments.info_id =  arguments.ID>
                <cfset arguments.is_upd = 1>
                <cfset arguments.info_type_id = -15>
                <cfinclude template="../../objects/query/add_info_plus2.cfm">
                <!---Ek Bilgiler--->
                <cf_workcube_process 
                    is_upd='1' 
                    old_process_line='#arguments.old_process_line#'
                    process_stage='#arguments.process_stage#' 
                    record_member='#session.ep.userid#'
                    record_date='#now()#' 
                    action_table='SERVICE'
                    action_column='SERVICE_ID'
                    action_id='#arguments.id#' 
                    action_page='#request.self#?fuseaction=service.list_service&event=upd&service_id=#arguments.id#' 
                    warning_description='Servis No : #get_service1.service_no#'>
                <cfset responseStruct.message = "İşlem Başarılı">
                <cfset responseStruct.status = true>
                <cfset responseStruct.error = {}>
                <cfset responseStruct.identity = ''>
                <cfcatch>
                    <cftransaction action="rollback">
                    <cfset responseStruct.message = "İşlem Hatalı">
                    <cfset responseStruct.status = false>
                    <cfset responseStruct.error = cfcatch>
                </cfcatch>
            </cftry>
        <cfreturn responseStruct>
    </cffunction>

    <cffunction name="add_service" access="public" returntype="any" hint="Servis Başvuruları Ekleme">
        <cfset attributes = arguments>
        <cfset responseStruct = structNew()>

        <cf_xml_page_edit fuseact="service.add_service">
            <cfset list="',""">
            <cfset list2=" , ">
            <cfset arguments.service_head = replacelist(arguments.service_head,list,list2)>
            
            <cfif arguments.active_company neq session.ep.company_id>
                <cfset responseStruct.message = getLang('main','İşlemin Şirketi İle Aktif Şirketiniz Farklı Çalıştığınız Şirketi Kontrol Ediniz',38700)>
                <cfset responseStruct.status = false>
                <cfset responseStruct.error = {}>
                <cfabort>
            </cfif>
             
            <!--- gorevli atamada kullaniliyor yerini dahi degistirmeyiniz yo13082008--->
            <cfif len(arguments.task_person_name) and len(arguments.task_emp_id)>
                <cfset arguments.work_status = 1>
                <cfset temp_apply_date = arguments.apply_date>
                <cfset arguments.startdate_plan = temp_apply_date>
                <cf_date tarih='temp_apply_date'>
                <cfset arguments.finishdate_plan = dateformat(date_add('d',1,temp_apply_date),dateformat_style)>
                <cfset arguments.finish_hour_plan = arguments.apply_hour>
                <cfset arguments.finish_hour = arguments.apply_hour>
                <cfset arguments.start_hour = arguments.apply_hour>
                <cfset arguments.work_fuse = 'service.add_service'>
                <cfset arguments.work_detail = arguments.service_detail>
                <cfset arguments.project_emp_id = arguments.task_emp_id>
                <cfif arguments.member_type is 'partner'>
                    <cfset arguments.company_id = arguments.company_id>
                    <cfset arguments.company_partner_id = arguments.member_id>
                <cfelseif arguments.member_type is 'consumer'>
                    <cfset arguments.company_id = "">
                    <cfset arguments.company_partner_id = arguments.member_id>
                </cfif>
                <cfset arguments.task_partner_id = ''>
                <cfquery name="GET_WORK_CAT" datasource="#DSN#" maxrows="1">
                    SELECT WORK_CAT_ID, WORK_CAT FROM PRO_WORK_CAT ORDER BY WORK_CAT
                </cfquery>
                <cfset arguments.PRO_WORK_CAT = GET_WORK_CAT.WORK_CAT_ID>
            
                <cfquery name="GET_CATS" datasource="#DSN#" maxrows="1">
                    SELECT PRIORITY_ID, PRIORITY FROM SETUP_PRIORITY ORDER BY PRIORITY
                </cfquery>
                <cfset arguments.PRIORITY_CAT = GET_CATS.PRIORITY_ID>
                
                <cfquery name="GET_WORK_PROCESS" datasource="#DSN#" maxrows="1">
                    SELECT TOP 1
                        PTR.STAGE,
                        PTR.PROCESS_ROW_ID 
                    FROM
                        PROCESS_TYPE_ROWS PTR,
                        PROCESS_TYPE_OUR_COMPANY PTO,
                        PROCESS_TYPE PT
                    WHERE
                        PT.IS_ACTIVE = 1 AND
                        PT.PROCESS_ID = PTR.PROCESS_ID AND
                        PT.PROCESS_ID = PTO.PROCESS_ID AND
                        PTO.OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#"> AND
                        PT.FACTION LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%project.addwork,%">
                    ORDER BY
                        PTR.LINE_NUMBER
                </cfquery>
                <cfset arguments.work_process_stage = get_work_process.process_row_id>
            </cfif>
            <cfif len(arguments.apply_date)>
                <cf_date tarih="arguments.apply_date">
                <cfset arguments.apply_date=date_add("H", arguments.apply_hour - session.ep.time_zone,arguments.apply_date)>
                <cfset arguments.apply_date=date_add("N", arguments.apply_minute,arguments.apply_date)>
            </cfif>
            <cfif len(arguments.start_date1)>
                <cf_date tarih="arguments.start_date1">
                <cfset arguments.start_date1=date_add("H", arguments.start_hour - session.ep.time_zone,arguments.start_date1)>
                <cfset arguments.start_date1=date_add("N", arguments.start_minute,arguments.start_date1)>
            </cfif>
            <cfif isdefined("arguments.guaranty_start_date") and len(arguments.guaranty_start_date)>
                <cf_date tarih="arguments.guaranty_start_date">
            </cfif>
            <cfif isdefined("arguments.intervention_date") and len(arguments.intervention_date)>
                <cf_date tarih="arguments.intervention_date">
                <cfset arguments.intervention_date=date_add("H", arguments.intervention_start_hour - session.ep.time_zone,arguments.intervention_date)>
                <cfset arguments.intervention_date=date_add("N", arguments.intervention_start_minute,arguments.intervention_date)>
            </cfif>
            <cfif isdefined("arguments.finish_date1") and len(arguments.finish_date1)>
                <cf_date tarih="arguments.finish_date1">
                <cfset arguments.finish_date1=date_add("H", arguments.finish_hour1 - session.ep.time_zone,arguments.finish_date1)>
                <cfset arguments.finish_date1=date_add("N", arguments.finish_minute1,arguments.finish_date1)>
            </cfif>
            <cfif isdefined("arguments.service_product") and not len(arguments.service_product) and len(arguments.service_product_serial)>
                <cfquery name="GET_SERI_PRODUCT" datasource="#DSN3#" maxrows="1">
                    SELECT SGN.STOCK_ID,S.PRODUCT_NAME,S.PRODUCT_ID FROM SERVICE_GUARANTY_NEW SGN,STOCKS S WHERE SGN.STOCK_ID = S.STOCK_ID AND SGN.SERIAL_NO = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.service_product_serial#"> 
                </cfquery>
                <cfif get_seri_product.recordcount>
                    <cfset seri_stock_id = get_seri_product.stock_id>
                    <cfset seri_product_id = get_seri_product.product_id>
                    <cfset seri_product_name = get_seri_product.product_name>
                </cfif>
            </cfif>
            
            
            <cfif isdefined("arguments.subscription_id") and len(arguments.subscription_id)>
                <cfquery name="GET_SYSTEM" datasource="#DSN3#">
                    SELECT TOP 1 * FROM SUBSCRIPTION_CONTRACT WHERE SUBSCRIPTION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.subscription_id#">
                </cfquery>
                <cfif get_system.recordcount and get_system.valid_days gte 1><!--- sistem var mi --->
                    <cfset count_type_ = get_system.valid_days>
                    <cfset deger_tarih_ilk_ = now()>
                    <cfset deger_tarih_ = date_add("h",session.ep.time_zone,deger_tarih_ilk_)>
                    <cfset deger_saat_ = timeformat(deger_tarih_,'HH')>
                    <cfset deger_dakika_ = timeformat(deger_tarih_,'MM')>
                    <cfset deger_gercek_ = (deger_saat_ * 60) + deger_dakika_>
                    <cfset gun_ = dayofweek(deger_tarih_)>
                    <cfif count_type_ eq 1><!--- hafta ici --->
                        <cfset control_baslangic_saat_ = get_system.start_clock_1>			
                        <cfset control_baslangic_dakika_ = get_system.start_minute_1>
                        <cfset deger_baslangic_ = (control_baslangic_saat_ * 60) + control_baslangic_dakika_>
                        
                        <cfset control_bitis_saat_ = get_system.finish_clock_1>			
                        <cfset control_bitis_dakika_ = get_system.finish_minute_1>
                        <cfset deger_bitis_ = (control_bitis_saat_ * 60) + control_bitis_dakika_>
                        
                        <cfset h_ici_total_mesai_ = deger_bitis_ - deger_baslangic_>
                        <cfset cmt_total_mesai_ = 0>
                        <cfset pzr_total_mesai_ = 0>
                        
                        <cfif gun_ eq 1><!--- gun pazar --->
                            <cfset add_day_ = 1>
                            <cfset kabul_ = date_add("d",add_day_,deger_tarih_ilk_)>
                            <cfset kabul_ = createdate(year(kabul_),month(kabul_),day(kabul_))>
                            <cfset kabul_ = date_add("h",control_baslangic_saat_,kabul_)>
                            <cfset kabul_ = date_add('n',control_baslangic_dakika_,kabul_)>
                            <cfset kabul_ = date_add("h",-session.ep.time_zone,kabul_)>
                        <cfelseif gun_ eq 7><!--- gun cmt --->
                            <cfset add_day_ = 2>
                            <cfset kabul_ = date_add("d",add_day_,deger_tarih_ilk_)>
                            <cfset kabul_ = createdate(year(kabul_),month(kabul_),day(kabul_))>
                            <cfset kabul_ = date_add("h",control_baslangic_saat_,kabul_)>
                            <cfset kabul_ = date_add('n',control_baslangic_dakika_,kabul_)>
                            <cfset kabul_ = date_add("h",-session.ep.time_zone,kabul_)>
                        <cfelse><!--- gun hafta ici --->
                                <cfif deger_gercek_ gte deger_baslangic_ and deger_gercek_ lte deger_bitis_>
                                    <cfset kabul_ = deger_tarih_ilk_>
                                <cfelseif deger_gercek_ lt deger_baslangic_>
                                    <cfset kabul_ = deger_tarih_ilk_>
                                    <cfset kabul_ = createdate(year(kabul_),month(kabul_),day(kabul_))>
                                    <cfset kabul_ = date_add("h",control_baslangic_saat_,kabul_)>
                                    <cfset kabul_ = date_add('n',control_baslangic_dakika_,kabul_)>
                                    <cfset kabul_ = date_add("h",-session.ep.time_zone,kabul_)>
                                <cfelseif deger_gercek_ gt deger_bitis_>
                                    <cfif gun_ eq 6>
                                        <cfset add_day_ = 2>
                                    <cfelse>
                                        <cfset add_day_ = 1>
                                    </cfif>					
                                    <cfset kabul_ = date_add("d",add_day_,deger_tarih_ilk_)>
                                    <cfset kabul_ = createdate(year(kabul_),month(kabul_),day(kabul_))>
                                    <cfset kabul_ = date_add("h",control_baslangic_saat_,kabul_)>
                                    <cfset kabul_ = date_add('n',control_baslangic_dakika_,kabul_)>
                                    <cfset kabul_ = date_add("h",-session.ep.time_zone,kabul_)>
                                </cfif>
                        </cfif>
                    <cfelseif count_type_ eq 2><!--- hafta ici + cumartesi --->
                        <cfset control_baslangic_saat_ = get_system.start_clock_1>			
                        <cfset control_baslangic_dakika_ = get_system.start_minute_1>
                        <cfset deger_baslangic_ = (control_baslangic_saat_ * 60) + control_baslangic_dakika_>
                        
                        <cfset control_bitis_saat_ = get_system.finish_clock_1>			
                        <cfset control_bitis_dakika_ = get_system.finish_minute_1>
                        <cfset deger_bitis_ = (control_bitis_saat_ * 60) + control_bitis_dakika_>
                        
                        <cfset control_cmt_baslangic_saat_ = get_system.start_clock_2>			
                        <cfset control_cmt_baslangic_dakika_ = get_system.start_minute_2>
                        <cfset deger_cmt_baslangic_ = (control_cmt_baslangic_saat_ * 60) + control_cmt_baslangic_dakika_>
                        
                        <cfset control_cmt_bitis_saat_ = get_system.finish_clock_2>			
                        <cfset control_cmt_bitis_dakika_ = get_system.finish_minute_2>
                        <cfset deger_cmt_bitis_ = (control_cmt_bitis_saat_ * 60) + control_cmt_bitis_dakika_>
                        
                        <cfset h_ici_total_mesai_ = deger_bitis_ - deger_baslangic_>
                        <cfset cmt_total_mesai_ = deger_cmt_bitis_ - deger_cmt_baslangic_>
                        <cfset pzr_total_mesai_ = 0>
                        
                            <cfif gun_ eq 1><!--- gun pazar --->
                                <cfset add_day_ = 1>
                                <cfset kabul_ = date_add("d",add_day_,deger_tarih_ilk_)>
                                <cfset kabul_ = createdate(year(kabul_),month(kabul_),day(kabul_))>
                                <cfset kabul_ = date_add("h",control_baslangic_saat_,kabul_)>
                                <cfset kabul_ = date_add('n',control_baslangic_dakika_,kabul_)>
                                <cfset kabul_ = date_add("h",-session.ep.time_zone,kabul_)>
                            <cfelseif gun_ eq 7><!--- gun cmt --->
                                    <cfif deger_gercek_ gte deger_cmt_baslangic_ and deger_gercek_ lte deger_cmt_bitis_>
                                        <cfset kabul_ = deger_tarih_ilk_>
                                    <cfelseif deger_gercek_ lt deger_cmt_baslangic_>
                                        <cfset kabul_ = deger_tarih_ilk_>
                                        <cfset kabul_ = createdate(year(kabul_),month(kabul_),day(kabul_))>
                                        <cfset kabul_ = date_add("h",control_cmt_baslangic_saat_,kabul_)>
                                        <cfset kabul_ = date_add('n',control_cmt_baslangic_dakika_,kabul_)>
                                        <cfset kabul_ = date_add("h",-session.ep.time_zone,kabul_)>
                                    <cfelseif deger_gercek_ gt deger_cmt_bitis_>
                                        <cfset add_day_ = 2>
                                        <cfset kabul_ = date_add("d",add_day_,deger_tarih_ilk_)>
                                        <cfset kabul_ = createdate(year(kabul_),month(kabul_),day(kabul_))>
                                        <cfset kabul_ = date_add("h",control_baslangic_saat_,kabul_)>
                                        <cfset kabul_ = date_add('n',control_baslangic_dakika_,kabul_)>
                                        <cfset kabul_ = date_add("h",-session.ep.time_zone,kabul_)>
                                    </cfif>
                            <cfelse><!--- gun hafta ici --->
                                    <cfif deger_gercek_ gte deger_baslangic_ and deger_gercek_ lte deger_bitis_>
                                        <cfset kabul_ = deger_tarih_ilk_>
                                    <cfelseif deger_gercek_ lt deger_baslangic_>
                                        <cfset kabul_ = deger_tarih_ilk_>
                                        <cfset kabul_ = createdate(year(kabul_),month(kabul_),day(kabul_))>
                                        <cfset kabul_ = date_add("h",control_baslangic_saat_,kabul_)>
                                        <cfset kabul_ = date_add('n',control_baslangic_dakika_,kabul_)>
                                        <cfset kabul_ = date_add("h",-session.ep.time_zone,kabul_)>
                                    <cfelseif deger_gercek_ gt deger_bitis_>
                                        <cfif gun_ eq 6>
                                            <cfset add_day_ = 1>
                                            <cfset kabul_ = date_add("d",add_day_,deger_tarih_ilk_)>
                                            <cfset kabul_ = createdate(year(kabul_),month(kabul_),day(kabul_))>
                                            <cfset kabul_ = date_add("h",control_cmt_baslangic_saat_,kabul_)>
                                            <cfset kabul_ = date_add('n',control_cmt_baslangic_dakika_,kabul_)>
                                            <cfset kabul_ = date_add("h",-session.ep.time_zone,kabul_)>
                                        <cfelse>
                                            <cfset add_day_ = 1>
                                            <cfset kabul_ = date_add("d",add_day_,deger_tarih_ilk_)>
                                            <cfset kabul_ = createdate(year(kabul_),month(kabul_),day(kabul_))>
                                            <cfset kabul_ = date_add("h",control_baslangic_saat_,kabul_)>
                                            <cfset kabul_ = date_add('n',control_baslangic_dakika_,kabul_)>
                                            <cfset kabul_ = date_add("h",-session.ep.time_zone,kabul_)>
                                        </cfif>					
                                    </cfif>
                            </cfif>	
                    <cfelseif count_type_ eq 3><!--- pazar --->
                        <cfset control_baslangic_saat_ = get_system.start_clock_1>			
                        <cfset control_baslangic_dakika_ = get_system.start_minute_1>
                        <cfset deger_baslangic_ = (control_baslangic_saat_ * 60) + control_baslangic_dakika_>
                        
                        <cfset control_bitis_saat_ = get_system.finish_clock_1>			
                        <cfset control_bitis_dakika_ = get_system.finish_minute_1>
                        <cfset deger_bitis_ = (control_bitis_saat_ * 60) + control_bitis_dakika_>
                        
                        <cfset control_cmt_baslangic_saat_ = get_system.start_clock_2>			
                        <cfset control_cmt_baslangic_dakika_ = get_system.start_minute_2>
                        <cfset deger_cmt_baslangic_ = (control_cmt_baslangic_saat_ * 60) + control_cmt_baslangic_dakika_>
                        
                        <cfset control_cmt_bitis_saat_ = get_system.finish_clock_2>			
                        <cfset control_cmt_bitis_dakika_ = get_system.finish_minute_2>
                        <cfset deger_cmt_bitis_ = (control_cmt_bitis_saat_ * 60) + control_cmt_bitis_dakika_>
                        
                        <cfset control_pzr_baslangic_saat_ = get_system.start_clock_3>			
                        <cfset control_pzr_baslangic_dakika_ = get_system.start_minute_3>
                        <cfset deger_pzr_baslangic_ = (control_pzr_baslangic_saat_ * 60) + control_pzr_baslangic_dakika_>
                        
                        <cfset control_pzr_bitis_saat_ = get_system.finish_clock_3>			
                        <cfset control_pzr_bitis_dakika_ = get_system.finish_minute_3>
                        <cfset deger_pzr_bitis_ = (control_pzr_bitis_saat_ * 60) + control_pzr_bitis_dakika_>
                        
                        
                        <cfset h_ici_total_mesai_ = deger_bitis_ - deger_baslangic_>
                        <cfset cmt_total_mesai_ = deger_cmt_bitis_ - deger_cmt_baslangic_>
                        <cfset pzr_total_mesai_ = deger_pzr_bitis_ - deger_pzr_baslangic_>
                        
                        <cfif gun_ eq 1><!--- gun pazar --->
                            <cfif deger_gercek_ gte deger_pzr_baslangic_ and deger_gercek_ lte deger_pzr_bitis_>
                                <cfset kabul_ = deger_tarih_ilk_>
                            <cfelseif deger_gercek_ lt deger_pzr_baslangic_>
                                <cfset kabul_ = deger_tarih_ilk_>
                                <cfset kabul_ = createdate(year(kabul_),month(kabul_),day(kabul_))>
                                <cfset kabul_ = date_add("h",control_pzr_baslangic_saat_,kabul_)>
                                <cfset kabul_ = date_add('n',control_pzr_baslangic_dakika_,kabul_)>
                                <cfset kabul_ = date_add("h",-session.ep.time_zone,kabul_)>
                            <cfelseif deger_gercek_ gt deger_pzr_baslangic_>
                                <cfset add_day_ = 1>
                                <cfset kabul_ = date_add("d",add_day_,deger_tarih_ilk_)>
                                <cfset kabul_ = createdate(year(kabul_),month(kabul_),day(kabul_))>
                                <cfset kabul_ = date_add("h",control_baslangic_saat_,kabul_)>
                                <cfset kabul_ = date_add('n',control_baslangic_dahika_,kabul_)>
                                <cfset kabul_ = date_add("h",-session.ep.time_zone,kabul_)>
                            </cfif>
                        <cfelseif gun_ eq 7><!--- gun cmt --->
                            <cfif deger_gercek_ gte deger_cmt_baslangic_ and deger_gercek_ lte deger_cmt_bitis_>
                                <cfset kabul_ = deger_tarih_ilk_>
                            <cfelseif deger_gercek_ lt deger_cmt_baslangic_>
                                <cfset kabul_ = deger_tarih_ilk_>
                                <cfset kabul_ = createdate(year(kabul_),month(kabul_),day(kabul_))>
                                <cfset kabul_ = date_add("h",control_cmt_baslangic_saat_,kabul_)>
                                <cfset kabul_ = date_add('n',control_cmt_baslangic_dakika_,kabul_)>
                                <cfset kabul_ = date_add("h",-session.ep.time_zone,kabul_)>
                            <cfelseif deger_gercek_ gt deger_cmt_bitis_>
                                <cfset add_day_ = 1>
                                <cfset kabul_ = date_add("d",add_day_,deger_tarih_ilk_)>
                                <cfset kabul_ = createdate(year(kabul_),month(kabul_),day(kabul_))>
                                <cfset kabul_ = date_add("h",control_pzr_baslangic_saat_,kabul_)>
                                <cfset kabul_ = date_add('n',control_pzr_baslangic_dakika_,kabul_)>
                                <cfset kabul_ = date_add("h",-session.ep.time_zone,kabul_)>
                            </cfif>
                        <cfelse><!--- gun hafta ici --->
                            <cfif deger_gercek_ gte deger_baslangic_ and deger_gercek_ lte deger_bitis_>
                                <cfset kabul_ = deger_tarih_ilk_>
                            <cfelseif deger_gercek_ lt deger_baslangic_>
                                <cfset kabul_ = deger_tarih_ilk_>
                                <cfset kabul_ = createdate(year(kabul_),month(kabul_),day(kabul_))>
                                <cfset kabul_ = date_add("h",control_baslangic_saat_,kabul_)>
                                <cfset kabul_ = date_add('n',control_baslangic_dakika_,kabul_)>
                                <cfset kabul_ = date_add("h",-session.ep.time_zone,kabul_)>
                            <cfelseif deger_gercek_ gt deger_bitis_>
                                <cfif gun_ eq 6>
                                    <cfset add_day_ = 1>
                                    <cfset kabul_ = date_add("d",add_day_,deger_tarih_ilk_)>
                                    <cfset kabul_ = createdate(year(kabul_),month(kabul_),day(kabul_))>
                                    <cfset kabul_ = date_add("h",control_cmt_baslangic_saat_,kabul_)>
                                    <cfset kabul_ = date_add('n',control_cmt_baslangic_dakika_,kabul_)>
                                    <cfset kabul_ = date_add("h",-session.ep.time_zone,kabul_)>
                                <cfelse>
                                    <cfset add_day_ = 1>
                                    <cfset kabul_ = date_add("d",add_day_,deger_tarih_ilk_)>
                                    <cfset kabul_ = createdate(year(kabul_),month(kabul_),day(kabul_))>
                                    <cfset kabul_ = date_add("h",control_baslangic_saat_,kabul_)>
                                    <cfset kabul_ = date_add('n',control_baslangic_dakika_,kabul_)>
                                    <cfset kabul_ = date_add("h",-session.ep.time_zone,kabul_)>
                                </cfif>					
                            </cfif>
                        </cfif>	
                    </cfif>
                </cfif><!--- sistem var mi --->
            </cfif>
            <cfif isdefined("kabul_")>
                <cfset deger_pzr_bitis_ = 0>
                <cfset arguments.start_date1 = kabul_>
                <cfif len(get_system.hour1) and len(get_system.minute1)>
                    <cfset cozum_suresi_ = (get_system.hour1 * 60) + get_system.minute1>
                <cfelseif len(get_system.hour1)>
                    <cfset cozum_suresi_ = (get_system.hour1 * 60)>
                <cfelseif len(get_system.minute1)>
                    <cfset cozum_suresi_ = get_system.minute1>
                <cfelse>
                    <cfset cozum_suresi_ = 60>
                </cfif>
                <cfif len(get_system.response_hour1) and len(get_system.response_minute1)>
                    <cfset mudahale_suresi_ = (get_system.response_hour1 * 60) + get_system.response_minute1>
                <cfelseif len(get_system.response_hour1)>
                    <cfset mudahale_suresi_ = (get_system.response_hour1 * 60)>
                <cfelseif len(get_system.response_minute1)>
                    <cfset mudahale_suresi_ = get_system.response_minute1>
                <cfelse>
                    <cfset mudahale_suresi_ = 60>
                </cfif>
                <cfset gun_ = dayofweek(kabul_)>
                <cfif gun_ eq 7><!--- cumartesi --->
                    <cfset today_finish_ = deger_cmt_bitis_>
                <cfelseif gun_ eq 1><!--- pazar --->
                    <cfset today_finish_ = deger_pzr_bitis_>
                <cfelse>
                    <cfset today_finish_ = deger_bitis_>
                </cfif>
                <cfset deger_saat_ = timeformat(kabul_,'HH')>
                <cfset deger_dakika_ = timeformat(kabul_,'MM')>
                <cfset deger_gercek_ = (deger_saat_ * 60) + deger_dakika_>
                
                <cfif today_finish_ gt (cozum_suresi_ + deger_gercek_)>
                    <cfset arguments.cozum_suresi_ = date_add("n",cozum_suresi_,kabul_)>
                <cfelse>
                    <cfset kalan_sure = cozum_suresi_ - (today_finish_ - deger_gercek_)>
                    <cfset flag = 1>
                    <cfset day_add_ = 0>
                    <cfscript>
                        while(flag)
                            {
                            day_add_ = day_add_ + 1;
                            new_date_gun_ = date_add("d",day_add_,kabul_);
                            get_day_ = dayofweek(new_date_gun_);
                            if(get_day_ eq 7)
                                {
                                    if(cmt_total_mesai_ gt kalan_sure)
                                        {
                                        arguments.cozum_suresi_ = createodbcdatetime(createdate(year(new_date_gun_),month(new_date_gun_),day(new_date_gun_)));
                                        arguments.cozum_suresi_ = date_add("n",(deger_cmt_baslangic_+kalan_sure),arguments.cozum_suresi_);
                                        flag = 0;
                                        }
                                    else
                                        {
                                        kalan_sure = kalan_sure - cmt_total_mesai_;
                                        }
                                }
                            else if(get_day_ eq 1)
                                {
                                    if(pzr_total_mesai_ gt kalan_sure)
                                        {
                                        arguments.cozum_suresi_ = createodbcdatetime(createdate(year(new_date_gun_),month(new_date_gun_),day(new_date_gun_)));
                                        arguments.cozum_suresi_ = date_add("n",(deger_pzr_baslangic_+kalan_sure),arguments.cozum_suresi_);
                                        flag = 0;
                                        }
                                    else
                                        {
                                        kalan_sure = kalan_sure - pzr_total_mesai_;
                                        }
                                }
                            else
                                {
                                    if(h_ici_total_mesai_ gt kalan_sure)
                                        {
                                        arguments.cozum_suresi_ = createodbcdatetime(createdate(year(new_date_gun_),month(new_date_gun_),day(new_date_gun_)));
                                        arguments.cozum_suresi_ = date_add("n",(deger_baslangic_+kalan_sure),arguments.cozum_suresi_);
                                        flag = 0;
                                        }
                                    else
                                        {
                                        kalan_sure = kalan_sure - h_ici_total_mesai_;
                                        }
                                }
                            }
                    </cfscript>	
                </cfif>
                <cfif today_finish_ gt (mudahale_suresi_ + deger_gercek_)>
                    <cfset arguments.mudahale_suresi_ = date_add("n",mudahale_suresi_,kabul_)>
                <cfelse>
                    <cfset kalan_sure = mudahale_suresi_ - (today_finish_ - deger_gercek_)>
                    <cfset flag = 1>
                    <cfset day_add_ = 0>
                    <cfscript>
                        while(flag)
                            {
                            day_add_ = day_add_ + 1;
                            new_date_gun_ = date_add("d",day_add_,kabul_);
                            get_day_ = dayofweek(new_date_gun_);
                            if(get_day_ eq 7)
                                {
                                    if(cmt_total_mesai_ gt kalan_sure)
                                        {
                                        arguments.mudahale_suresi_ = createodbcdatetime(createdate(year(new_date_gun_),month(new_date_gun_),day(new_date_gun_)));
                                        arguments.mudahale_suresi_ = date_add("n",(deger_cmt_baslangic_+kalan_sure),arguments.mudahale_suresi_);
                                        flag = 0;
                                        }
                                    else
                                        {
                                        kalan_sure = kalan_sure - cmt_total_mesai_;
                                        }
                                }
                            else if(get_day_ eq 1)
                                {
                                    if(pzr_total_mesai_ gt kalan_sure)
                                        {
                                        arguments.mudahale_suresi_ = createodbcdatetime(createdate(year(new_date_gun_),month(new_date_gun_),day(new_date_gun_)));
                                        arguments.mudahale_suresi_ = date_add("n",(deger_pzr_baslangic_+kalan_sure),arguments.mudahale_suresi_);
                                        flag = 0;
                                        }
                                    else
                                        {
                                        kalan_sure = kalan_sure - pzr_total_mesai_;
                                        }
                                }
                            else
                                {
                                    if(h_ici_total_mesai_ gt kalan_sure)
                                        {
                                        arguments.mudahale_suresi_ = createodbcdatetime(createdate(year(new_date_gun_),month(new_date_gun_),day(new_date_gun_)));
                                        arguments.mudahale_suresi_ = date_add("n",(deger_baslangic_+kalan_sure),arguments.mudahale_suresi_);
                                        flag = 0;
                                        }
                                    else
                                        {
                                        kalan_sure = kalan_sure - h_ici_total_mesai_;
                                        }
                                }
                            }
                    </cfscript>	
                </cfif>
            </cfif>
        <cftry>  
            <cflock name="#CREATEUUID()#" timeout="20">
                <cftransaction>
                <cf_papers paper_type="SERVICE_APP">
                <cfset system_paper_no=paper_code & '-' & paper_number>
                <cfset system_paper_no_add=paper_number>
                <cfquery name="UPD_GEN_PAP" datasource="#DSN3#">
                    UPDATE
                        GENERAL_PAPERS
                    SET
                        SERVICE_APP_NUMBER = <cfqueryparam cfsqltype="cf_sql_integer" value="#system_paper_no_add#">
                    WHERE
                        SERVICE_APP_NUMBER IS NOT NULL
                </cfquery>
                <cfif len(arguments.task_person_name) and len(arguments.task_emp_id)>
                    <cfif len(arguments.service_head)>
                        <cfset arguments.work_head = left(arguments.service_head,100)>
                    <cfelse>
                        <cfset arguments.work_head = left(system_paper_no,100)>
                    </cfif>
                </cfif>
                <cfquery name="ADD_SERVICE" datasource="#DSN3#" result="my_result">
                    INSERT INTO
                        SERVICE
                        (
                            SERVICE_ACTIVE,
                            ISREAD,
                            SERVICECAT_ID,
                            SERVICE_STATUS_ID,
                            SERVICE_SUBSTATUS_ID,
                            STOCK_ID,	
                            <cfif isDefined("arguments.G_ID")>GUARANTY_ID,</cfif>
                            PRIORITY_ID,
                            COMMETHOD_ID,
                            SERVICE_HEAD,
                            SERVICE_DETAIL,
                            SERVICE_COUNTY_ID,
                            SERVICE_CITY_ID,
                            SERVICE_ADDRESS,
                            SERVICE_COUNTY,
                            SERVICE_CITY,
                            DEAD_LINE,
                            DEAD_LINE_RESPONSE,
                            APPLY_DATE,
                            START_DATE,
                            <cfif arguments.member_type is 'partner'>
                                SERVICE_PARTNER_ID,
                                SERVICE_COMPANY_ID,					
                            <cfelseif arguments.member_type is 'consumer'>
                                SERVICE_CONSUMER_ID,
                            </cfif>
                            SERVICE_PRODUCT_ID,				
                            SERVICE_BRANCH_ID,
                            DEPARTMENT_ID,
                            LOCATION_ID,
                            SERVICE_DEFECT_CODE,				
                            APPLICATOR_NAME,
                            APPLICATOR_COMP_NAME,
                            PRODUCT_NAME,
                            <cfif isdefined("arguments.service_product_serial") and len(arguments.service_product_serial)>
                                PRO_SERIAL_NO,
                                MAIN_SERIAL_NO,
                            </cfif>	
                            GUARANTY_START_DATE,
                            GUARANTY_INSIDE,
                            INSIDE_DETAIL,
                            SERVICE_NO,
                            BRING_NAME,
                            BRING_EMAIL,
                            DOC_NO,
                            BRING_TEL_NO,
                            BRING_MOBILE_NO,
                            BRING_DETAIL,
                            ACCESSORY,
                            ACCESSORY_DETAIL,
                            SUBSCRIPTION_ID,
                            RELATED_COMPANY_ID,
                            SALE_ADD_OPTION_ID,
                            PROJECT_ID,
                            IS_SALARIED,
                            SHIP_METHOD,
                            BRING_SHIP_METHOD_ID,
                            CUS_HELP_ID,
                            OTHER_COMPANY_ID,
                            OTHER_COMPANY_BRANCH_ID,
                            INSIDE_DETAIL_SELECT,
                            ACCESSORY_DETAIL_SELECT,
                            SERVICECAT_SUB_ID,
                            SERVICECAT_SUB_STATUS_ID,
                            WORKGROUP_ID,
                            CALL_SERVICE_ID,
                            SZ_ID,
                            RECORD_DATE,
                            RECORD_MEMBER,
                            SERVICE_EMPLOYEE_ID,
                            INTERVENTION_DATE,
                            FINISH_DATE,
                            SPEC_MAIN_ID,
                            TIME_CLOCK_HOUR,
                            TIME_CLOCK_MINUTE
                        )
                        VALUES
                        (
                            1,
                            0,
                            #arguments.appcat_id#,
                            #arguments.process_stage#,
                            <cfif len(arguments.service_substatus_id)>#arguments.service_substatus_id#<cfelse>NULL</cfif>,
                            <cfif isdefined("arguments.stock_id") and len(arguments.stock_id)>#arguments.stock_id#<cfelseif isdefined("seri_stock_id")>#seri_stock_id#<cfelse>NULL</cfif>,
                            <cfif isDefined("G_ID")>#G_ID#,</cfif>
                            <cfif len(arguments.priority_id)>#arguments.priority_id#<cfelse>NULL</cfif>,
                            <cfif len(arguments.commethod_id)>#arguments.commethod_id#<cfelse>NULL</cfif>,
                            <cfif len(arguments.service_head)><cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.service_head#"><cfelse>'#system_paper_no#'</cfif>,				
                            '#arguments.service_detail#',
                            <cfif isdefined("arguments.service_county_id") and len(arguments.service_county_id) and len(arguments.service_county_name)>#arguments.service_county_id#<cfelse>NULL</cfif>,
                            <cfif isdefined("arguments.service_city_id") and len(arguments.service_city_id)>#arguments.service_city_id#<cfelse>NULL</cfif>,
                            <cfif isdefined("arguments.service_address") and len(arguments.service_address)>'#arguments.service_address#'<cfelse>NULL</cfif>,
                            <cfif isdefined("arguments.service_county") and len(arguments.service_county)>'#arguments.service_county#'<cfelse>NULL</cfif>,
                            <cfif isdefined("arguments.service_city") and len(arguments.service_city)>'#arguments.service_city#'<cfelse>NULL</cfif>,
                            <cfif isdefined("arguments.cozum_suresi_")>#arguments.cozum_suresi_#<cfelse>NULL</cfif>,
                            <cfif isdefined("arguments.mudahale_suresi_")>#arguments.mudahale_suresi_#<cfelse>NULL</cfif>,
                            <cfif len(arguments.apply_date)>#arguments.apply_date#<cfelse>NULL</cfif>,
                            <cfif len(arguments.start_date1)>#arguments.start_date1#<cfelse>NULL</cfif>,
                            <cfif arguments.member_type is 'partner'>
                                #arguments.member_id#,
                                #arguments.company_id#,					
                            <cfelseif arguments.member_type is 'consumer'>
                                #arguments.member_id#,
                            </cfif>				
                            <cfif isDefined("arguments.service_product_id") and len(arguments.service_product_id) and len(arguments.service_product)>#arguments.service_product_id#<cfelseif isdefined("seri_product_id")>#seri_product_id#<cfelse>NULL</cfif>,
                            <cfif isDefined("arguments.service_branch_id") and len(arguments.service_branch_id)>#arguments.service_branch_id#<cfelse>NULL</cfif>,
                            <cfif len(arguments.department_id) and len(arguments.department)>#arguments.department_id#<cfelse>NULL</cfif>,
                            <cfif len(arguments.location_id) and len(arguments.department)>#arguments.location_id#<cfelse>NULL</cfif>,
                            <cfif isdefined("arguments.service_defect_code")>'#arguments.service_defect_code#'<cfelse>NULL</cfif>,
                            '#left(arguments.member_name,200)#',
                            <cfif isDefined("arguments.applicator_comp_name") and len(arguments.applicator_comp_name)>'#arguments.applicator_comp_name#'<cfelseif isDefined("arguments.company_name") and len(arguments.company_name)>'#arguments.company_name#'<cfelse>NULL</cfif>,
                            <cfif isdefined("arguments.service_product") and len(arguments.service_product)>'#arguments.service_product#'<cfelseif isdefined("seri_product_name")>'#seri_product_name#'<cfelse>NULL</cfif>,
                            <cfif isdefined("arguments.service_product_serial") and len(arguments.service_product_serial)>
                                '#arguments.service_product_serial#',
                                '#arguments.main_serial_no#',
                            </cfif>
                            <cfif isdefined('arguments.GUARANTY_START_DATE') and len(arguments.GUARANTY_START_DATE)>#arguments.GUARANTY_START_DATE#,<cfelse>NULL,</cfif>
                            <cfif isdefined("arguments.guaranty_inside")>1<cfelse>0</cfif>,
                            <cfif isdefined("arguments.inside_detail") and len(arguments.inside_detail)>'#arguments.inside_detail#',<cfelse>NULL,</cfif>
                            '#system_paper_no#',
                            <cfif isdefined("arguments.bring_name")>'#arguments.bring_name#'<cfelse>NULL</cfif>,
                            <cfif isdefined("arguments.bring_email")>'#arguments.bring_email#'<cfelse>NULL</cfif>,
                            <cfif isdefined("arguments.doc_no")>'#arguments.doc_no#'<cfelse>NULL</cfif>,
                            <cfif isdefined("arguments.bring_tel_no")>'#arguments.bring_tel_no#'<cfelse>NULL</cfif>,
                            <cfif isdefined("arguments.bring_mobile_no")>'#arguments.bring_mobile_no#'<cfelse>NULL</cfif>,
                            <cfif isdefined("arguments.bring_detail")>'#arguments.bring_detail#'<cfelse>NULL</cfif>,
                            <cfif isdefined("arguments.accessory") and len(arguments.accessory)>1<cfelse>0</cfif>,
                            <cfif isdefined("arguments.accessory_detail") and isdefined("arguments.accessory") and len(arguments.accessory)>'#arguments.accessory_detail#'<cfelse>NULL</cfif>,
                            <cfif isdefined("arguments.subscription_id") and len(arguments.subscription_id) and isdefined('arguments.subscription_no') and len(arguments.subscription_no)>#arguments.subscription_id#<cfelse>NULL</cfif>,
                            <cfif len(arguments.related_company_id) and len(arguments.related_company)>#arguments.related_company_id#<cfelse>NULL</cfif>,
                            <cfif isdefined("arguments.sales_add_option") and len(arguments.sales_add_option)>#arguments.sales_add_option#<cfelse>NULL</cfif>,
                            <cfif isdefined("arguments.project_id") and len(arguments.project_id) and isdefined("arguments.project_head") and len(arguments.project_head)>#arguments.project_id#,<cfelse>NULL,</cfif>
                            <cfif isdefined("arguments.is_salaried")>1<cfelse>0</cfif>,
                            <cfif isdefined("arguments.ship_method") and len(arguments.ship_method) and len(arguments.ship_method_name)>#arguments.ship_method#<cfelse>NULL</cfif>,
                            <cfif isdefined("arguments.bring_ship_method_name") and len(arguments.bring_ship_method_name) and len(arguments.bring_ship_method_id)>#arguments.bring_ship_method_id#<cfelse>NULL</cfif>,
                            <cfif isdefined("arguments.cus_help_id") and len(arguments.cus_help_id)>#arguments.cus_help_id#<cfelse>NULL</cfif>,
                            <cfif isdefined("arguments.other_company_id") and len(arguments.other_company_id) and len(arguments.other_company_name)>#arguments.other_company_id#<cfelse>NULL</cfif>,
                            <cfif isdefined("arguments.other_company_branch_id") and len(arguments.other_company_branch_id) and len(arguments.other_company_branch_name)>#arguments.other_company_branch_id#<cfelse>NULL</cfif>,
                            <cfif isdefined("arguments.inside_detail_select") and len(arguments.inside_detail_select) and isdefined("arguments.guaranty_inside")>'#arguments.inside_detail_select#'<cfelse>NULL</cfif>,
                            <cfif isdefined("arguments.accessory_detail_select") and len(arguments.accessory_detail_select)>'#arguments.accessory_detail_select#'<cfelse>NULL</cfif>,
                            <cfif isdefined("arguments.appcat_sub_id") and len(arguments.appcat_sub_id)>#arguments.appcat_sub_id#<cfelse>NULL</cfif>,
                            <cfif isdefined("arguments.appcat_sub_status_id") and len(arguments.appcat_sub_status_id)>#arguments.appcat_sub_status_id#<cfelse>NULL</cfif>,
                            <cfif isdefined("arguments.service_work_groups") and len(arguments.service_work_groups)>#arguments.service_work_groups#<cfelse>NULL</cfif>,
                            <cfif isdefined("arguments.call_service_id") and len(arguments.call_service_id)>#arguments.call_service_id#<cfelse>NULL</cfif>,
                            <cfif isdefined("arguments.sales_zone_id") and len(arguments.sales_zone_id)>#arguments.sales_zone_id#<cfelse>NULL</cfif>,
                            #now()#,
                            #session.ep.userid#,
                            <cfif len(arguments.task_person_name) and len(arguments.task_emp_id)>#arguments.task_emp_id#<cfelse>NULL</cfif>,
                            <cfif isdefined('arguments.intervention_date') and len(arguments.intervention_date)>#arguments.intervention_date#<cfelse>NULL</cfif>,
                            <cfif isdefined('arguments.finish_date1') and len(arguments.finish_date1)>#arguments.finish_date1#<cfelse>NULL</cfif>,
                            <cfif isDefined("arguments.spec_main_id") and len(arguments.spec_main_id) and len(arguments.spect_name)>#arguments.spec_main_id#<cfelse>NULL</cfif>,
                            <cfif isDefined("arguments.time_clock_hour") and len(arguments.time_clock_hour)>#arguments.time_clock_hour#<cfelse>NULL</cfif>,
                            <cfif isDefined("arguments.time_clock_minute") and len(arguments.time_clock_minute)>#arguments.time_clock_minute#<cfelse>NULL</cfif>
                        )
                 </cfquery>
                <cfquery name="GET_SERVICE1" datasource="#DSN3#" maxrows="1">
                    SELECT  
                        RELATED_COMPANY_ID,
                        SERVICE_ACTIVE,
                        SERVICE_NO,
                        SERVICECAT_ID,
                        PRO_SERIAL_NO,
                        STOCK_ID,
                        PRODUCT_NAME,
                        SERVICE_SUBSTATUS_ID,
                        SERVICE_STATUS_ID,
                        GUARANTY_ID,
                        GUARANTY_PAGE_NO,
                        PRIORITY_ID,
                        COMMETHOD_ID,
                        SERVICE_HEAD,
                        SERVICE_DETAIL,
                        SERVICE_ADDRESS,
                        SERVICE_COUNTY_ID,
                        SERVICE_CITY_ID,
                        SERVICE_COUNTY,
                        SERVICE_CITY,
                        SERVICE_CONSUMER_ID,
                        NOTES,
                        APPLY_DATE,
                        START_DATE,
                        SERVICE_PRODUCT_ID,
                        SERVICE_DEFECT_CODE,
                        APPLICATOR_NAME,
                        PROJECT_ID,
                        RECORD_DATE,
                        RECORD_MEMBER,
                        UPDATE_DATE,
                        UPDATE_MEMBER,
                        RECORD_PAR,
                        UPDATE_PAR,
                        OTHER_COMPANY_ID,
                        SHIP_METHOD,
                        SERVICE_ID,
                        SERVICECAT_SUB_ID,
                        SERVICECAT_SUB_STATUS_ID,
                        WORKGROUP_ID,
                        CALL_SERVICE_ID,
                        INTERVENTION_DATE,
                        FINISH_DATE,
                        GUARANTY_INSIDE
                    FROM 
                        SERVICE 
                    WHERE 
                        RECORD_MEMBER = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#"> AND 
                        SERVICE_NO = <cfqueryparam cfsqltype="cf_sql_varchar" value="#system_paper_no#"> 
                    ORDER BY 
                        SERVICE_ID DESC
                </cfquery>
                </cftransaction>
            </cflock>
            <cfquery name="ADD_HISTORY" datasource="#DSN3#">
                INSERT INTO
                    SERVICE_HISTORY
                    (
                        RELATED_COMPANY_ID,
                        SERVICE_ACTIVE,
                        SERVICECAT_ID,
                        PRO_SERIAL_NO,
                        STOCK_ID,
                        PRODUCT_NAME,
                        SERVICE_SUBSTATUS_ID,
                        SERVICE_STATUS_ID,
                        GUARANTY_ID,
                        GUARANTY_PAGE_NO,
                        PRIORITY_ID,
                        COMMETHOD_ID,				
                        SERVICE_HEAD,
                        SERVICE_DETAIL,
                        SERVICE_ADDRESS,
                        SERVICE_COUNTY_ID,
                        SERVICE_CITY_ID,
                        SERVICE_COUNTY,
                        SERVICE_CITY,
                        SERVICE_CONSUMER_ID,
                        NOTES,
                        APPLY_DATE,
                        FINISH_DATE,
                        START_DATE,
                        SERVICE_PRODUCT_ID,
                        SERVICE_DEFECT_CODE,
                        APPLICATOR_NAME,
                        PROJECT_ID,
                        RECORD_DATE,
                        RECORD_MEMBER,
                        UPDATE_DATE,
                        UPDATE_MEMBER,
                        RECORD_PAR,
                        UPDATE_PAR,
                        OTHER_COMPANY_ID,
                        SHIP_METHOD,
                        SERVICE_ID,
                        SERVICECAT_SUB_ID,
                        SERVICECAT_SUB_STATUS_ID,
                        WORKGROUP_ID,
                        CALL_SERVICE_ID,
                        INTERVENTION_DATE,
                        GUARANTY_INSIDE
                    )
                    VALUES
                    (
                        <cfif len(get_service1.RELATED_COMPANY_ID)>#get_service1.RELATED_COMPANY_ID#<cfelse>NULL</cfif>,
                        #get_service1.service_active#,
                        <cfif len(get_service1.servicecat_id)>#get_service1.servicecat_id#<cfelse>NULL</cfif>,
                        <cfif len(get_service1.pro_serial_no)>'#get_service1.pro_serial_no#'<cfelse>NULL</cfif>,
                        <cfif len(get_service1.stock_id)>#get_service1.stock_id#<cfelse>NULL</cfif>,
                        <cfif len(get_service1.product_name)>'#get_service1.product_name#'<cfelse>NULL</cfif>,
                        <cfif len(get_service1.service_substatus_id)>#get_service1.service_substatus_id#<cfelse>NULL</cfif>,
                        <cfif len(get_service1.service_status_id)>#get_service1.service_status_id#<cfelse>NULL</cfif>,
                        <cfif len(get_service1.guaranty_id)>#get_service1.guaranty_id#<cfelse>NULL</cfif>,
                        <cfif len(get_service1.guaranty_page_no)>#get_service1.guaranty_page_no#<cfelse>NULL</cfif>,
                        <cfif len(get_service1.priority_id)>#get_service1.priority_id#<cfelse>NULL</cfif>,
                        <cfif len(get_service1.commethod_id)>#get_service1.commethod_id#<cfelse>NULL</cfif>,
                        <cfif len(get_service1.service_head)>'#get_service1.service_head#'<cfelse>NULL</cfif>,
                        <cfif len(get_service1.service_detail)>'#get_service1.service_detail#'<cfelse>NULL</cfif>,
                        <cfif len(get_service1.service_address)>'#get_service1.service_address#'<cfelse>NULL</cfif>,
                        <cfif len(get_service1.service_county_id)>#get_service1.service_county_id#<cfelse>NULL</cfif>,
                        <cfif len(get_service1.service_city_id)>#get_service1.service_city_id#<cfelse>NULL</cfif>,
                        <cfif len(get_service1.service_county)>'#get_service1.service_county#'<cfelse>NULL</cfif>,
                        <cfif len(get_service1.service_city)>'#get_service1.service_city#'<cfelse>NULL</cfif>,
                        <cfif len(get_service1.service_consumer_id)>#get_service1.service_consumer_id#<cfelse>NULL</cfif>,
                        <cfif len(get_service1.notes)>'#get_service1.notes#'<cfelse>NULL</cfif>,
                        <cfif len(get_service1.apply_date)>#createodbcdatetime(get_service1.apply_date)#<cfelse>NULL</cfif>,
                        <cfif len(get_service1.finish_date)>#createodbcdatetime(get_service1.finish_date)#<cfelse>NULL</cfif>,
                        <cfif len(get_service1.start_date)>#createodbcdatetime(get_service1.start_date)#<cfelse>NULL</cfif>,
                        <cfif len(get_service1.service_product_id)>#get_service1.service_product_id#<cfelse>NULL</cfif>,
                        <cfif len(get_service1.service_defect_code)>'#get_service1.service_defect_code#'<cfelse>NULL</cfif>,
                        <cfif len(get_service1.applicator_name) and isdefined('get_service1.applicator_name')>'#get_service1.applicator_name#'<cfelse>NULL</cfif>,
                        <cfif len(get_service1.project_id)>#get_service1.project_id#<cfelse>NULL</cfif>,
                        <cfif len(get_service1.record_date)>#createodbcdatetime(get_service1.record_date)#<cfelse>NULL</cfif>,
                        <cfif len(get_service1.record_member)>#get_service1.record_member#<cfelse>NULL</cfif>,
                        <cfif len(get_service1.update_date)>#createodbcdatetime(get_service1.update_date)#<cfelse>NULL</cfif>,
                        <cfif len(get_service1.update_member)>#get_service1.update_member#<cfelse>NULL</cfif>,
                        <cfif len(get_service1.record_par)>#get_service1.record_par#<cfelse>NULL</cfif>,
                        <cfif len(get_service1.update_par)>#get_service1.update_par#<cfelse>NULL</cfif>,
                        <cfif len(get_service1.other_company_id)>#get_service1.other_company_id#<cfelse>NULL</cfif>,
                        <cfif len(get_service1.ship_method)>#get_service1.ship_method#<cfelse>NULL</cfif>,						
                        #get_service1.service_id#,
                        <cfif len(get_service1.servicecat_sub_id)>#get_service1.servicecat_sub_id#<cfelse>NULL</cfif>,
                        <cfif len(get_service1.servicecat_sub_status_id)>#get_service1.servicecat_sub_status_id#<cfelse>NULL</cfif>,
                        <cfif len(get_service1.workgroup_id)>#get_service1.workgroup_id#<cfelse>NULL</cfif>,
                        <cfif len(get_service1.call_service_id)>#get_service1.call_service_id#<cfelse>NULL</cfif>,
                        <cfif len(get_service1.INTERVENTION_DATE)>#createodbcdatetime(get_service1.INTERVENTION_DATE)#<cfelse>NULL</cfif>,
                        #get_service1.GUARANTY_INSIDE#
                    )
            </cfquery>
            <cfif x_activity_time eq 1>
                <!--- MT:başvuru kaydedildiğinde zaman harcamasına kayıt atılıyor.--->
                    <cfquery name="GET_SERVICE_CONTROL" datasource="#dsn3#">
                        SELECT 
                            TIME_CLOCK_HOUR,
                            TIME_CLOCK_MINUTE,
                            APPLY_DATE, <!---Başvuru tarihi--->
                            <cfif len(arguments.company_id)>
                                SERVICE_COMPANY_ID,<!---Müşteri--->
                            <cfelse>
                                SERVICE_CONSUMER_ID,<!---Müşteri--->
                            </cfif>
                            SUBSCRIPTION_ID,<!---Abone No--->
                            PROJECT_ID,<!--- Proje --->
                            SERVICE_HEAD,<!---Servis Konusu--->
                            SERVICE_NO,	<!---Kaydedilen Servis--->
                            SERVICE_ID
                        FROM 
                            SERVICE
                        WHERE 
                            SERVICE_ID = #my_result.identitycol#        
                    </cfquery>
                    <cfquery name="get_process_stage" datasource="#dsn#" maxrows="1">
                        SELECT
                            PTR.PROCESS_ROW_ID 
                        FROM
                            PROCESS_TYPE_ROWS PTR,
                            PROCESS_TYPE_OUR_COMPANY PTO,
                            PROCESS_TYPE PT
                        WHERE
                            PT.IS_ACTIVE = 1 AND
                            PT.PROCESS_ID = PTR.PROCESS_ID AND
                            PT.PROCESS_ID = PTO.PROCESS_ID AND
                            PTO.OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#"> AND
                            PT.FACTION LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%myhome.time_cost%">
                        ORDER BY
                            PTR.LINE_NUMBER
                    </cfquery>
                    <!---<cfset minute_ = LSNumberFormat(GET_SERVICE_CONTROL.TIME_CLOCK_MINUTE)>
                    <cfset hour_ = LSNumberFormat(GET_SERVICE_CONTROL.TIME_CLOCK_HOUR)>--->
                    <cfset minute_ = GET_SERVICE_CONTROL.TIME_CLOCK_MINUTE>
                    <cfset hour_ = GET_SERVICE_CONTROL.TIME_CLOCK_HOUR>
                    <cfset totalminute = hour_*60+minute_>
                    <cfset totalhour = totalminute/60>
                    <cfquery name="GET_TIME_COST" datasource="#dsn#">
                        SELECT
                            EXPENSED_MINUTE,
                            TOTAL_TIME
                        FROM
                            TIME_COST
                        WHERE
                            SERVICE_ID = #GET_SERVICE_CONTROL.SERVICE_ID#
                    </cfquery>
                    <cfif arguments.time_clock_hour neq 0 or arguments.time_clock_minute neq 0>
                        <cfquery name="ADD_TIME_COST" datasource="#dsn#">
                            INSERT INTO TIME_COST
                            (
                                ACTIVITY_ID,
                                EVENT_DATE,
                                <cfif len(arguments.company_id)>
                                    COMPANY_ID,
                                <cfelse>
                                    CONSUMER_ID,
                                </cfif>
                                SUBSCRIPTION_ID,
                                PROJECT_ID,
                                EMPLOYEE_ID,
                                EXPENSED_MINUTE,
                                TOTAL_TIME,
                                SERVICE_ID,
                                COMMENT,
                                TIME_COST_STAGE
                            )
                            VALUES
                            (
                                <cfif len(arguments.ACTIVITY_ID)>#arguments.ACTIVITY_ID#<cfelse>NULL</cfif>,
                                <cfif len(GET_SERVICE_CONTROL.APPLY_DATE)>'#GET_SERVICE_CONTROL.APPLY_DATE#'<cfelse>NULL</cfif>,
                                <cfif len(arguments.company_id)>
                                    #GET_SERVICE_CONTROL.SERVICE_COMPANY_ID#,
                                <cfelse>
                                    #GET_SERVICE_CONTROL.SERVICE_CONSUMER_ID#,
                                </cfif>
                                <cfif len(GET_SERVICE_CONTROL.SUBSCRIPTION_ID)>#GET_SERVICE_CONTROL.SUBSCRIPTION_ID#<cfelse>NULL</cfif>,
                                <cfif len(GET_SERVICE_CONTROL.PROJECT_ID)>#GET_SERVICE_CONTROL.PROJECT_ID#<cfelse>NULL</cfif>,
                                #session.ep.userid#,
                                <cfif len(totalminute)>#totalminute#<cfelse>NULL</cfif>,
                                <cfif len(totalhour)>#totalhour#<cfelse>NULL</cfif>,
                                <cfif len(GET_SERVICE_CONTROL.SERVICE_ID)>#GET_SERVICE_CONTROL.SERVICE_ID#<cfelse>NULL</cfif>,
                                <cfif len(GET_SERVICE_CONTROL.SERVICE_HEAD)>'#GET_SERVICE_CONTROL.SERVICE_HEAD#'<cfelse>NULL</cfif>,
                                <cfif isdefined('get_process_stage.process_row_id') and len(get_process_stage.process_row_id)><cfqueryparam cfsqltype="cf_sql_integer" value="#get_process_stage.process_row_id#"><cfelse>NULL</cfif>
                            )
                        </cfquery>
                    </cfif>            
                <!--- MT:başvuru kaydedildiğinde zaman harcamasına kayıt atılıyor.--->
            </cfif>    
            <cfif isdefined("arguments.service_work_groups") and len(arguments.service_work_groups)>
                <cfquery name="GET_WRK_EMPS" datasource="#DSN#">
                    SELECT EMPLOYEE_ID FROM WORKGROUP_EMP_PAR WHERE WORKGROUP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_service1.workgroup_id#"> ORDER BY HIERARCHY
                </cfquery>
                <cfloop query="get_wrk_emps">
                    <cfquery name="ADD_WRKGROUPS" datasource="#DSN3#">
                        INSERT INTO 
                            SERVICE_EMPLOYEES 
                            (
                                EMPLOYEE_ID,
                                SERVICE_ID,
                                RECORD_DATE,
                                RECORD_EMP,
                                RECORD_IP)
                            VALUES
                            (
                                #employee_id#,
                                #get_service1.service_id#,
                                #now()#,
                                #session.ep.userid#,
                                '#cgi.REMOTE_ADDR#'
                            )
                    </cfquery>
                </cfloop>
            </cfif>	
            <cfif isdefined("arguments.failure_code") and len(arguments.failure_code)>
                <cfloop list="#arguments.failure_code#" index="m">
                    <cfquery name="ADD_SERVICE_CODE_ROWS" datasource="#DSN3#">
                        INSERT INTO
                            SERVICE_CODE_ROWS
                        (
                            SERVICE_CODE_ID,
                            SERVICE_ID
                        )				
                        VALUES
                        (
                            #m#,
                            #get_service1.service_id#
                        )
                    </cfquery>
                </cfloop>
            </cfif>
            <cfif isdefined("arguments.event_id") and len(arguments.event_id)>
                <cfquery name="ADD_EVENT" datasource="#DSN#">
                    INSERT INTO
                        EVENTS_RELATED
                    (
                        EVENT_ID,
                        ACTION_ID,
                        ACTION_SECTION,
                        COMPANY_ID,
                        EVENT_TYPE
                    )				
                    VALUES
                    (
                        #arguments.event_id#,
                        #get_service1.service_id#,
                        'SERVICE_ID',
                        #session.ep.company_id#,
                        1
                    )
                </cfquery>
            </cfif>	
            <cfif len(arguments.task_person_name) and len(arguments.task_emp_id) and isdefined("x_is_emp_workadd") and x_is_emp_workadd eq 1>
                <cfset arguments.service_id = get_service1.service_id>
                <cfset arguments.our_company_id = session.ep.company_id>
                <cfset arguments.is_mail = 1>
                <cfinclude template="../../project/query/add_work.cfm">
            </cfif>
            <!---Ek Bilgiler--->
            <cfset arguments.info_id = my_result.IDENTITYCOL>
            <cfset arguments.is_upd = 0>
            <cfset arguments.info_type_id = -15>
            <cfinclude template="../../objects/query/add_info_plus2.cfm">
            <!---Ek Bilgiler--->
            <cf_workcube_process is_upd='1' 
                    old_process_line='0'
                    process_stage='#arguments.process_stage#' 
                    record_member='#session.ep.userid#' 
                    record_date='#now()#' 
                    action_table='SERVICE'
                    action_column='SERVICE_ID'
                    action_id='#get_service1.service_id#'
                    action_page='#request.self#?fuseaction=service.list_service&event=upd&service_id=#get_service1.service_id#' 
                    warning_description='Servis No : #system_paper_no#'>
            
            <cfset responseStruct.message = "İşlem Başarılı">
            <cfset responseStruct.status = true>
            <cfset responseStruct.error = {}>
            <cfset responseStruct.identity = get_service1.service_id>
            <cfcatch>
                <cfset responseStruct.message = "İşlem Hatalı">
                <cfset responseStruct.status = false>
                <cfset responseStruct.error = cfcatch>
            </cfcatch>
        </cftry>
        <cfreturn responseStruct>
    </cffunction>

    <cffunction name="del_service" access="public" returntype="any" hint="Servis Başvuru Silme">
        <cfset attributes = arguments>
        <cfset responseStruct = structNew()>

        <cfset this_year = session.ep.period_year>
        <cfset last_year = session.ep.period_year-1>
        <cfset next_year = session.ep.period_year+1>
        <cfscript>
            if (database_type is 'MSSQL') 
                {
                last_year_dsn2 = '#dsn#_#this_year-1#_#session.ep.company_id#';
                next_year_dsn2 = '#dsn#_#this_year+1#_#session.ep.company_id#';
                }
            else if (database_type is 'DB2') 
                {
                last_year_dsn2 = '#dsn#_#session.ep.company_id#_#this_year-1#';
                next_year_dsn2 = '#dsn#_#session.ep.company_id#_#this_year+1#';
                }	
        </cfscript>
        <cfquery name="get_periods" datasource="#dsn#">
            SELECT PERIOD_YEAR FROM SETUP_PERIOD WHERE OUR_COMPANY_ID = #session.ep.company_id#
        </cfquery>
        <cfquery name="control_last_year" dbtype="query" maxrows="1">
            SELECT PERIOD_YEAR FROM get_periods WHERE PERIOD_YEAR = #last_year#
        </cfquery>
        <cfif control_last_year.recordcount>
            <cfquery name="get_last_year_ship" datasource="#last_year_dsn2#" maxrows="1">
                SELECT DISTINCT
                    S.SHIP_ID,
                    S.SHIP_TYPE,
                    S.SHIP_NUMBER,
                    S.COMPANY_ID,
                    S.CONSUMER_ID,
                    S.SHIP_DATE
                FROM 
                    SHIP S,
                    SHIP_ROW SR
                WHERE 
                    S.SHIP_ID = SR.SHIP_ID AND
                    SR.SERVICE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.service_id#">
            </cfquery>
            <cfif get_last_year_ship.recordcount>
                <cfsavecontent variable="msg"><cf_get_lang no ='335.Servis ile ilişkili irsaliye bulunduğu için servisi silemezsiniz'>! <cf_get_lang_main no ='1060.Dönem'> : <cfoutput>#last_year#</cfoutput> - <cf_get_lang_main no='726.İrsaliye No'>:<cfoutput>#get_last_year_ship.SHIP_NUMBER#</cfoutput></cfsavecontent>
                <cfset responseStruct.message = msg>
                <cfset responseStruct.status = false>
                <cfset responseStruct.error = {}>
                <cfreturn responseStruct>
                <cfabort>
            </cfif>
        </cfif>
        <cfquery name="get_new_ship" datasource="#dsn2#" maxrows="1">
            SELECT DISTINCT
                S.SHIP_ID,
                S.SHIP_TYPE,
                S.SHIP_NUMBER,
                S.COMPANY_ID,
                S.CONSUMER_ID,
                S.SHIP_DATE
            FROM 
                SHIP S,
                SHIP_ROW SR
            WHERE 
                S.SHIP_ID = SR.SHIP_ID AND
                SR.SERVICE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.service_id#">
        </cfquery>
        <cfif get_new_ship.recordcount>
            <cfsavecontent variable="msg"><cf_get_lang no ='335.Servis ile ilişkili irsaliye bulunduğu için servisi silemezsiniz'>! <cf_get_lang_main no ='1060.Dönem'> : <cfoutput>#last_year#</cfoutput> - <cf_get_lang_main no='726.İrsaliye No'>:<cfoutput>#get_last_year_ship.SHIP_NUMBER#</cfoutput></cfsavecontent>
            <cfset responseStruct.message = msg>
            <cfset responseStruct.status = false>
            <cfset responseStruct.error = {}>
            <cfreturn responseStruct>
            <cfabort>
        </cfif>
        <cfquery name="control_next_year" dbtype="query">
            SELECT PERIOD_YEAR FROM get_periods WHERE PERIOD_YEAR = #next_year#
        </cfquery>
        <cfif control_next_year.recordcount>
            <cfquery name="get_next_year_ship" datasource="#next_year_dsn2#" maxrows="1">
                SELECT DISTINCT
                    S.SHIP_ID,
                    S.SHIP_TYPE,
                    S.SHIP_NUMBER,
                    S.COMPANY_ID,
                    S.CONSUMER_ID,
                    S.SHIP_DATE 
                FROM 
                    SHIP S,
                    SHIP_ROW SR
                WHERE 
                    S.SHIP_ID = SR.SHIP_ID AND
                    SR.SERVICE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.service_id#">
            </cfquery>
                <cfif get_next_year_ship.recordcount>
                    <cfsavecontent variable="msg"><cf_get_lang no ='335.Servis ile ilişkili irsaliye bulunduğu için servisi silemezsiniz'>! <cf_get_lang_main no ='1060.Dönem'> : <cfoutput>#last_year#</cfoutput> - <cf_get_lang_main no='726.İrsaliye No'>:<cfoutput>#get_last_year_ship.SHIP_NUMBER#</cfoutput></cfsavecontent>
                    <cfset responseStruct.message = msg>
                    <cfset responseStruct.status = false>
                    <cfset responseStruct.error = {}>
                    <cfreturn responseStruct>
                </cfif>
        </cfif>
        <cftransaction>
            <cftry>
                <cfquery name="get_stage" datasource="#dsn3#">
                    SELECT SERVICE_NO,SERVICE_STATUS_ID FROM SERVICE WHERE SERVICE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.service_id#">
                </cfquery>
                <cfquery name="DEL_" datasource="#DSN3#">
                    DELETE FROM SERVICE_HISTORY WHERE SERVICE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.service_id#">
                </cfquery>
                <cfquery name="DEL_" datasource="#DSN3#">
                    DELETE FROM SERVICE_OPERATION WHERE SERVICE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.service_id#">
                </cfquery>
                <cfquery name="DEL_" datasource="#DSN3#">
                    DELETE FROM SERVICE_PLUS WHERE SERVICE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.service_id#">
                </cfquery>
                <cfquery name="DEL_" datasource="#DSN3#">
                    DELETE FROM SERVICE_REPLY WHERE SERVICE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.service_id#">
                </cfquery>
                <cfquery name="DEL_" datasource="#DSN3#">
                    DELETE FROM SERVICE WHERE SERVICE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.service_id#">
                </cfquery>
                <cfquery name="DEL_" datasource="#dsn3#">
                    DELETE FROM SERVICE_CODE_ROWS WHERE SERVICE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.service_id#">
                </cfquery>
                <cf_add_log employee_id="#session.ep.userid#" log_type="-1" action_id="#arguments.service_id#" paper_no="#get_stage.service_no#" process_stage="#get_stage.SERVICE_STATUS_ID#" action_name="#arguments.service_head# " period_id="#session.ep.period_id#" data_source="#dsn3#">
                    <cfset responseStruct.message = "İşlem Başarılı">
                    <cfset responseStruct.status = true>
                    <cfset responseStruct.error = {}>
                    <cfset responseStruct.identity = ''>
                <cfcatch type="database">
                    <cftransaction action="rollback">
                    <cfset responseStruct.message = "İşlem Hatalı">
                    <cfset responseStruct.status = false>
                    <cfset responseStruct.error = cfcatch>
                </cfcatch>
            </cftry>
        </cftransaction>
        <cfreturn responseStruct>
    </cffunction>

    <cffunction name="list_service" access="public" returntype="any" hint="Servis Listesi">
        <cfargument name="brand_id" required="false" hint="Brand Id">
        <cfargument name="brand_name" required="false" hint="Brand Adı">
        <cfargument name="product_cat_id" required="false" hint="Product Category Id">
        <cfargument name="product_cat" required="false" hint="Product Category">
        <cfargument name="keyword" required="false" hint="Keyword">
        <cfargument name="branch_list" required="false" hint="Branch list">
        <cfargument name="service_branch_id" required="false" hint="Service Branch Id">
        <cfargument name="x_related_company_team" required="false" type="boolean" hint="Related Company Team">
        <cfargument name="service_product_id" required="false" hint="Service Product Id">
        <cfargument name="servicecat_id" required="false" hint="Service Category Id">
        <cfargument name="start_date" required="false" hint="Start Date">
        <cfargument name="finish_date" required="false" hint="Finish Date">
        <cfargument name="start_date1" required="false" hint="Start Date1">
        <cfargument name="finish_date1" required="false" hint="Finish Date1">
        <cfargument name="start_date2" required="false" hint="Start Date2">
        <cfargument name="finish_date2" required="false" hint="Finish Date2">
        <cfargument name="task_employee_id" required="false" hint="Task Employee Id">
        <cfargument name="task_person_name" required="false" hint="Task Person Name">
        <cfargument name="service_code" required="false" hint="Service Code">
        <cfargument name="service_code_id" required="false" hint="Service Code Id">
        <cfargument name="keyword_detail" required="false" hint="Keyword Detail">
        <cfargument name="keyword_no" required="false" hint="Keyword No">
        <cfargument name="serial_no" required="false" hint="Serial No">
        <cfargument name="doc_number" required="false" hint="Doc Number">
        <cfargument name="product" required="false" hint="Product">
        <cfargument name="product_id" required="false" hint="Product Id">
        <cfargument name="made_application" required="false" hint="Applicant">
        <cfargument name="partner_id_" required="false" hint="Partner Id">
        <cfargument name="consumer_id_" required="false" hint="Consumer Id">
        <cfargument name="service_status" required="false" hint="Service Status">
        <cfargument name="process_stage" required="false" hint="Process Stage">
        <cfargument name="priority" required="false" hint="Priority">
        <cfargument name="adress_keyword" required="false" hint="Adress Keyword">
        <cfargument name="ismyhome" required="false" hint="is Myhome">
        <cfargument name="company_id" required="false" hint="Company Id">
        <cfargument name="consumer_id" required="false" hint="Consumer Id">
        <cfargument name="other_service_app" required="false" hint="Other Service App">
        <cfargument name="partner_id" required="false" hint="Partner Id">
        <cfargument name="service_id" required="false" hint="Service Id">
        <cfargument name="employee_id" required="false" hint="Employee Id">
        <cfargument name="subscription_id" required="false" hint="Subscription Id">
        <cfargument name="subscription_no" required="false" hint="Subscription No">
        <cfargument name="service_add_option" required="false" hint="Service Add Option">
        <cfargument name="related_company_id" required="false" hint="Related Company Id">
        <cfargument name="related_company" required="false" hint="Related Company Name">
        <cfargument name="other_company_id" required="false" hint="Other Company Id">
        <cfargument name="other_company_name" required="false" hint="Other Company Name">
        <cfargument name="member_name" required="false" hint="Member Name">
        <cfargument name="service_substatus_id" required="false" hint="Service Substatus Id">
        <cfargument name="product_code" required="false" hint="Product Code">
        <cfargument name="service_county_id" required="false" hint="Service County Id">
        <cfargument name="service_county_name" required="false" hint="Service County Name">
        <cfargument name="service_city_id" required="false" hint="Service City Id">
        <cfargument name="project_id" required="false" hint="Project Id">
        <cfargument name="project_head" required="false" hint="Project Head">
        <cfargument name="record_emp_id" required="false" hint="Record Emp Id">
        <cfargument name="record_emp_name" required="false" hint="Record Emp Name">
        <cfargument name="accessory" required="false" hint="Accessory">
        <cfargument name="accessory_select" required="false" hint="Accessory Select">
        <cfargument name="physical" required="false" hint="Physical">
        <cfargument name="physical_select" required="false" hint="Finish Physical Select">
        <cfargument name="x_control_ims" required="false" hint="X Control Ims">
        <cfargument name="startrow" required="false" hint="Start Row">
        <cfargument name="maxrows" required="false" hint="Max Row">

        <cfquery name="GET_SERVICE" datasource="#DSN3#">
            WITH CTE1 AS (
            SELECT
                SERVICE.SERVICE_ID,
                SERVICE.SERVICE_COMPANY_ID,
                SERVICE.SERVICE_PARTNER_ID,
                SERVICE.SERVICE_CONSUMER_ID,
                SERVICE.SERVICE_EMPLOYEE_ID,
                SERVICE.SERVICE_NO,
                SERVICE.DOC_NO,
                SERVICE.APPLY_DATE,
                SERVICE.SERVICE_HEAD,
                SERVICE.APPLICATOR_NAME,
                SERVICE.APPLICATOR_COMP_NAME,
                SERVICE.SERVICE_PRODUCT_ID,
                SERVICE.PRODUCT_NAME,
                SERVICE.PRO_SERIAL_NO,
                SERVICE.RECORD_MEMBER,
                SERVICE.RECORD_PAR,
                SERVICE.SERVICE_BRANCH_ID,
                SERVICE.SUBSCRIPTION_ID,
                SERVICE.SERVICE_SUBSTATUS_ID,
                SERVICE.SERVICE_CITY_ID,
                SERVICE.SERVICE_COUNTY_ID,
                SERVICE_APPCAT.SERVICECAT,
                SERVICE.INTERVENTION_DATE,
                SP.PRIORITY,
                SP.COLOR,
                PROCESS_TYPE_ROWS.STAGE,
                SERVICE.PROJECT_ID,
                SERVICE.START_DATE,
                SERVICE.FINISH_DATE
                ,BRANCH.BRANCH_NAME
                ,EMPLOYEES.EMPLOYEE_NAME
                ,EMPLOYEES.EMPLOYEE_SURNAME
                ,COMPANY_PARTNER.COMPANY_PARTNER_NAME
                ,COMPANY_PARTNER.COMPANY_PARTNER_SURNAME
                ,SERVICE_SUBSTATUS.SERVICE_SUBSTATUS
                ,PRO_PROJECTS.PROJECT_HEAD
                ,SETUP_CITY.CITY_NAME
                ,SETUP_COUNTY.COUNTY_NAME
                ,SUBSCRIPTION_CONTRACT.SUBSCRIPTION_NO
                ,SERVICE.RECORD_DATE
            FROM
                <cfif (isdefined("arguments.brand_id") and len(arguments.brand_id) and len(arguments.brand_name)) or (isdefined("arguments.product_cat_id") and len(arguments.product_cat_id) and len(arguments.product_cat))>
                    PRODUCT WITH (NOLOCK),
                </cfif>
                SERVICE WITH (NOLOCK)
            LEFT JOIN #DSN_ALIAS#.BRANCH ON BRANCH.BRANCH_ID  =SERVICE.SERVICE_BRANCH_ID      
            LEFT JOIN #DSN_ALIAS#.EMPLOYEES ON EMPLOYEES.EMPLOYEE_ID = SERVICE.RECORD_MEMBER
            LEFT JOIN #DSN_ALIAS#.COMPANY_PARTNER ON COMPANY_PARTNER.PARTNER_ID = SERVICE.RECORD_PAR   
            LEFT JOIN #DSN3_ALIAS#.SERVICE_SUBSTATUS ON SERVICE_SUBSTATUS.SERVICE_SUBSTATUS_ID = SERVICE.SERVICE_SUBSTATUS_ID        
            LEFT JOIN #DSN_ALIAS#.PRO_PROJECTS ON PRO_PROJECTS.PROJECT_ID = SERVICE.PROJECT_ID
            LEFT JOIN #DSN_ALIAS#.SETUP_CITY ON SETUP_CITY.CITY_ID  =  SERVICE.SERVICE_CITY_ID
            LEFT JOIN #DSN_ALIAS#.SETUP_COUNTY ON SETUP_COUNTY.COUNTY_ID = SERVICE.SERVICE_COUNTY_ID         	                   
            LEFT JOIN SUBSCRIPTION_CONTRACT ON SUBSCRIPTION_CONTRACT.SUBSCRIPTION_ID = SERVICE.SUBSCRIPTION_ID  
            <cfif isDefined("arguments.keyword") and len(arguments.keyword)>
                AND SUBSCRIPTION_NO LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#arguments.keyword#%"> COLLATE SQL_Latin1_General_CP1_CI_AI
            </cfif> 
                ,SERVICE_APPCAT WITH (NOLOCK),
                #dsn_alias#.SETUP_PRIORITY AS SP WITH (NOLOCK),
                #dsn_alias#.PROCESS_TYPE_ROWS AS PROCESS_TYPE_ROWS WITH (NOLOCK)
            WHERE 		
                SERVICE.SERVICECAT_ID = SERVICE_APPCAT.SERVICECAT_ID
                AND SP.PRIORITY_ID = SERVICE.PRIORITY_ID
                AND SERVICE.SERVICE_STATUS_ID = PROCESS_TYPE_ROWS.PROCESS_ROW_ID
                    AND
                    (	SERVICE_BRANCH_ID IS NULL
                        <cfif len(arguments.branch_list)>
                            OR SERVICE_BRANCH_ID IN (<cfqueryparam cfsqltype="cf_sql_integer" list="yes" value="#arguments.branch_list#">)
                        </cfif>
                    )
                <cfif isdefined("arguments.service_branch_id") and len(arguments.service_branch_id)>
                    AND SERVICE_BRANCH_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.service_branch_id#">
                </cfif>
                <cfif isdefined('x_related_company_team') and x_related_company_team eq 1>
                    AND SERVICE.RELATED_COMPANY_ID IN (SELECT COMPANY_ID FROM #dsn_alias#.WORKGROUP_EMP_PAR WHERE POSITION_CODE = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.position_code#"> AND COMPANY_ID IS NOT NULL)
                </cfif>				
                <cfif len(arguments.task_employee_id) and len(arguments.task_person_name)>
                    AND SERVICE.SERVICE_ID IN (	SELECT
                                                    PW.SERVICE_ID
                                                FROM
                                                    #dsn_alias#.PRO_WORKS PW
                                                WHERE
                                                    PW.PROJECT_EMP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.task_employee_id#"> AND
                                                    PW.OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#">
                                             )
                </cfif>
                <cfif isdefined("arguments.service_product_id") and len(arguments.service_product_id)>
                    AND SERVICE.SERVICE_PRODUCT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.service_product_id#">
                </cfif>
                <cfif isDefined("arguments.servicecat_id") and len(arguments.servicecat_id)>
                    AND SERVICE.SERVICECAT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.servicecat_id#">
                </cfif>
                <cfif isdefined("arguments.start_date") and len(arguments.start_date)>
                    AND SERVICE.APPLY_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#DATEDIFF("d",1,arguments.start_date)#">
                </cfif>
                <cfif isdefined("arguments.finish_date") and len(arguments.finish_date)>
                    AND SERVICE.APPLY_DATE < <cfqueryparam cfsqltype="cf_sql_timestamp" value="#DATEADD("d",1,arguments.finish_date)#">
                </cfif>
                <cfif isdefined("arguments.start_date1") and len(arguments.start_date1)>
                    AND SERVICE.START_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#arguments.start_date1#">
                </cfif>
                <cfif isdefined("arguments.finish_date1") and len(arguments.finish_date1)>
                    AND SERVICE.START_DATE < <cfqueryparam cfsqltype="cf_sql_timestamp" value="#DATEADD("d",1,arguments.finish_date1)#">
                </cfif>
                <cfif isdefined("arguments.start_date2") and len(arguments.start_date2)>
                    AND SERVICE.FINISH_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#arguments.start_date2#">
                </cfif>
                <cfif isdefined("arguments.finish_date2") and len(arguments.finish_date2)>
                    AND SERVICE.FINISH_DATE < <cfqueryparam cfsqltype="cf_sql_timestamp" value="#DATEADD("d",1,arguments.finish_date2)#">
                </cfif>
                <cfif isdefined("arguments.service_code") and len(arguments.service_code) and isdefined("arguments.service_code_id") and len(arguments.service_code_id)>
                    AND SERVICE.SERVICE_ID IN (SELECT SERVICE_ID FROM SERVICE_CODE_ROWS WHERE SERVICE_CODE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.service_code_id#">)
                </cfif>
                
                <cfif isdefined("arguments.keyword_detail") and len(arguments.keyword_detail)>
                    AND  SERVICE.SERVICE_DETAIL LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#arguments.keyword_detail#%"> COLLATE SQL_Latin1_General_CP1_CI_AI 
                </cfif>
                <cfif isdefined("arguments.keyword") and len(arguments.keyword)>
                     AND SERVICE.SERVICE_HEAD LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#arguments.keyword#%"> COLLATE SQL_Latin1_General_CP1_CI_AI 
                </cfif>
                <cfif isdefined("arguments.keyword_no") and len(arguments.keyword_no)>
                     AND   SERVICE.SERVICE_NO LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#arguments.keyword_no#%"> 
                </cfif> 
                
                <cfif isdefined("arguments.serial_no") and len(arguments.serial_no)>
                    AND SERVICE.PRO_SERIAL_NO LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#arguments.serial_no#%">
                </cfif>
                <cfif isdefined("arguments.doc_number") and len(arguments.doc_number)>
                    AND SERVICE.DOC_NO LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#arguments.doc_number#%">
                </cfif>
                <cfif isdefined("arguments.product") and len(arguments.product) and isDefined("arguments.product_id") and len(arguments.product_id)>
                    AND SERVICE.SERVICE_PRODUCT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.product_id#">
                </cfif>
                <cfif isdefined("arguments.made_application") and len(arguments.made_application)>
                    AND (
                            <cfif isdefined("arguments.partner_id_") and len(arguments.partner_id_)>
                                SERVICE.SERVICE_PARTNER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.partner_id_#">
                            <cfelseif isdefined("arguments.consumer_id_") and len(arguments.consumer_id_)>
                                SERVICE.SERVICE_CONSUMER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.consumer_id_#">
                            <cfelse>
                                (APPLICATOR_NAME LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#arguments.made_application#%">
                                OR APPLICATOR_COMP_NAME LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#arguments.made_application#%">)
                            </cfif>
                        )
                </cfif>	
                <cfif isdefined("arguments.service_status") and ListFind("0,1",arguments.service_status)>
                    AND SERVICE.SERVICE_ACTIVE = <cfqueryparam cfsqltype="cf_sql_smallint" value="#arguments.service_status#">
                </cfif>
                <cfif isdefined("arguments.process_stage") and len(arguments.process_stage)>
                    AND SERVICE.SERVICE_STATUS_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.process_stage#">
                </cfif>
                <cfif isdefined("arguments.priority") and len(arguments.priority)>
                    AND SERVICE.PRIORITY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.priority#">
                </cfif>
                <cfif isdefined("arguments.adress_keyword") and len(arguments.adress_keyword)>
                    AND SERVICE_ADDRESS LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#arguments.adress_keyword#%"> COLLATE SQL_Latin1_General_CP1_CI_AI
                </cfif>
                <!--- BU BOLUM MYHOME DAN VE UYEDEN DIREK ULASIM ICIN KONULMUSTUR --->
                <cfif isDefined("arguments.ismyhome") and isdefined("arguments.company_id") and len(arguments.company_id)>
                    AND SERVICE_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.company_id#">
                </cfif>
                <cfif isDefined("arguments.ismyhome") and isdefined("arguments.consumer_id") and len(arguments.consumer_id)>
                    AND SERVICE_CONSUMER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.consumer_id#">
                </cfif>
                <!--- //BU BOLUM MYHOME DAN VE UYEDEN DIREK ULASIM ICIN KONULMUSTUR --->		
                    
                <!--- Bu bölüm service update sayfasindan basvuru yapanin diger servis basvurularina direk erisim için konulmustur--->
                <cfif isdefined('other_service_app') and isdefined('arguments.partner_id') and len(arguments.partner_id)>
                    AND SERVICE_PARTNER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.partner_id#">
                    AND SERVICE_ID <> <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.service_id#">
                </cfif>
                <cfif isdefined("arguments.service_id") and len(arguments.service_id)>
                    AND SERVICE_ID IN(<cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.service_id#" list="yes">)
                </cfif>
                <cfif isdefined('other_service_app') and isdefined('arguments.employee_id') and len(arguments.employee_id)>
                    AND SERVICE_EMPLOYEE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.employee_id#">
                    AND SERVICE_ID <> <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.service_id#">
                </cfif>
                <cfif isdefined('other_service_app') and isdefined('arguments.consumer_id') and len(arguments.consumer_id)>
                    AND SERVICE_CONSUMER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.consumer_id#">
                    AND SERVICE_ID <> <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.service_id#">
                </cfif>
                <cfif isdefined("arguments.subscription_id") and len(arguments.subscription_id) and isDefined("arguments.subscription_no") and len(arguments.subscription_no)>
                    AND SERVICE.SUBSCRIPTION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.subscription_id#">
                </cfif>
                <cfif isdefined("arguments.service_add_option") and len(arguments.service_add_option)> 
                    AND SERVICE.SALE_ADD_OPTION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.service_add_option#">
                </cfif>
                <cfif isdefined("arguments.related_company_id") and len(arguments.related_company_id) and isDefined("arguments.related_company") and len(arguments.related_company)> 
                    AND SERVICE.RELATED_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.related_company_id#">
                </cfif>
                <cfif isdefined("arguments.other_company_id") and Len(arguments.other_company_id) and isDefined("arguments.other_company_name") and len(arguments.other_company_name)> 
                    AND SERVICE.OTHER_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.other_company_id#">
                </cfif>
                <!--- //Bu bölüm service update sayfasindan basvuru yapanin diger servis basvurularina direk erisim için konulmustur--->
                
                <cfif isdefined("arguments.company_id") and len(arguments.company_id) and isdefined("arguments.member_name") and len(arguments.member_name)> 
                    AND SERVICE.SERVICE_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.company_id#">
                </cfif>
                <cfif isdefined("arguments.consumer_id") and len(arguments.consumer_id) and isdefined("arguments.member_name") and len(arguments.member_name)> 
                    AND SERVICE.SERVICE_CONSUMER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.consumer_id#">
                </cfif>
                <cfif isdefined("arguments.service_substatus_id") and len(arguments.service_substatus_id)> 
                    AND SERVICE.SERVICE_SUBSTATUS_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.service_substatus_id#">
                </cfif>
                <cfif isdefined("arguments.brand_id") and len(arguments.brand_id) and isDefined("arguments.brand_name") and len(arguments.brand_name)> 
                    AND SERVICE.SERVICE_PRODUCT_ID = PRODUCT.PRODUCT_ID 
                    AND PRODUCT.BRAND_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.brand_id#">
                </cfif>
                <cfif isdefined("arguments.product_cat_id") and len(arguments.product_cat_id) and isDefined("arguments.product_cat") and len(arguments.product_cat)> 
                    AND SERVICE.SERVICE_PRODUCT_ID = PRODUCT.PRODUCT_ID 
                    AND PRODUCT.PRODUCT_CODE LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#arguments.product_code#%">
                <!---	AND PRODUCT.PRODUCT_CATID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.product_cat_id#"> --->
                </cfif>
                <cfif isdefined("arguments.service_county_id") and len(arguments.service_county_id) and isDefined("arguments.service_county_name") and len(arguments.service_county_name)>
                    AND SERVICE.SERVICE_COUNTY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.service_county_id#">
                </cfif>
                <cfif isdefined("arguments.service_city_id") and len(arguments.service_city_id)>
                    AND SERVICE.SERVICE_CITY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.service_city_id#">
                </cfif>
                <cfif isdefined("arguments.project_id") and len(arguments.project_id) and isdefined("arguments.project_head") and len(arguments.project_head)>
                    AND SERVICE.PROJECT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.project_id#">
                </cfif>  
                <cfif isdefined("arguments.record_emp_id") and len(arguments.record_emp_id) and len(arguments.record_emp_name)>
                    AND SERVICE.RECORD_MEMBER = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.record_emp_id#">
                </cfif>
                <cfif isdefined("arguments.accessory") and len(arguments.accessory)>
                    AND SERVICE.ACCESSORY_DETAIL LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#arguments.accessory#%">
                </cfif>
                <cfif isdefined("arguments.accessory_select") and len(arguments.accessory_select)>
                    AND SERVICE.ACCESSORY_DETAIL_SELECT IN (<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.accessory_select#" list="yes">)
                </cfif>        
                <cfif isdefined("arguments.physical") and len(arguments.physical)>
                    AND SERVICE.INSIDE_DETAIL LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#arguments.physical#%">
                </cfif> 
                <cfif isdefined("arguments.physical_select") and len(arguments.physical_select)>
                    AND SERVICE.INSIDE_DETAIL_SELECT IN (<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.physical_select#" list="yes">)
                </cfif>
                <cfif isdefined("x_control_ims") and x_control_ims eq 1 and session.ep.our_company_info.sales_zone_followup eq 1>
                    AND
                        (
                            ( SERVICE.SERVICE_CONSUMER_ID IS NULL AND SERVICE.SERVICE_COMPANY_ID IS NULL ) OR
                            ( SERVICE.SERVICE_COMPANY_ID IN (#PreserveSingleQuotes(my_ims_comp_list)#) ) OR
                            ( SERVICE.SERVICE_CONSUMER_ID IN (#PreserveSingleQuotes(my_ims_cons_list)#) )
                        )
                </cfif>
               ),
               
               CTE2 AS (
                        SELECT
                            CTE1.*,
                            ROW_NUMBER() OVER (	ORDER BY RECORD_DATE DESC) AS RowNum,(SELECT COUNT(*) FROM CTE1) AS QUERY_COUNT
                        FROM
                            CTE1
                    )
                    SELECT
                        CTE2.*
                    FROM
                        CTE2
                    WHERE
                        RowNum BETWEEN #arguments.startrow# and #arguments.startrow#+(#arguments.maxrows#-1) 
                
            
        </cfquery>
        <cfreturn GET_SERVICE>
    </cffunction>
    <cffunction name="list_service_search" access="public" returntype="any" hint="Servis Listesi">
        <cfargument name="partner_id" required="false" hint="Partner Id">
        <cfargument name="consumer_id" required="false" hint="Consumer Id">
        <cfargument name="service_id" required="false" hint="Service Id">
        <cfquery name="GET_SERVICE" datasource="#DSN3#">
            SELECT SERVICE.SERVICE_ID
                ,SERVICE.SERVICE_COMPANY_ID
                ,SERVICE.SERVICE_PARTNER_ID
                ,SERVICE.SERVICE_CONSUMER_ID
                ,SERVICE.SERVICE_EMPLOYEE_ID
                ,SERVICE.SERVICE_NO
                ,SERVICE.DOC_NO
                ,SERVICE.APPLY_DATE
                ,SERVICE.SERVICE_HEAD
                ,SERVICE.APPLICATOR_NAME
                ,SERVICE.APPLICATOR_COMP_NAME
                ,SERVICE.SERVICE_PRODUCT_ID
                ,SERVICE.PRODUCT_NAME
                ,SERVICE.PRO_SERIAL_NO
                ,SERVICE.RECORD_MEMBER
                ,SERVICE.RECORD_PAR
                ,SERVICE.SERVICE_BRANCH_ID
                ,SERVICE.SUBSCRIPTION_ID
                ,SERVICE.SERVICE_SUBSTATUS_ID
                ,SERVICE.SERVICE_CITY_ID
                ,SERVICE.SERVICE_COUNTY_ID
                ,SERVICE_APPCAT.SERVICECAT
                ,SERVICE.INTERVENTION_DATE
                ,SP.PRIORITY
                ,SP.COLOR
                ,PROCESS_TYPE_ROWS.STAGE
                ,SERVICE.PROJECT_ID
                ,SERVICE.START_DATE
                ,SERVICE.FINISH_DATE
                ,BRANCH.BRANCH_NAME
                ,EMPLOYEES.EMPLOYEE_NAME
                ,EMPLOYEES.EMPLOYEE_SURNAME
                ,COMPANY_PARTNER.COMPANY_PARTNER_NAME
                ,COMPANY_PARTNER.COMPANY_PARTNER_SURNAME
                ,SERVICE_SUBSTATUS.SERVICE_SUBSTATUS
                ,PRO_PROJECTS.PROJECT_HEAD
                ,SETUP_CITY.CITY_NAME
                ,SETUP_COUNTY.COUNTY_NAME
                ,SUBSCRIPTION_CONTRACT.SUBSCRIPTION_NO
                ,SERVICE.RECORD_DATE
            FROM SERVICE WITH (NOLOCK)
            LEFT JOIN #dsn#.BRANCH ON BRANCH.BRANCH_ID = SERVICE.SERVICE_BRANCH_ID
            LEFT JOIN #dsn#.EMPLOYEES ON EMPLOYEES.EMPLOYEE_ID = SERVICE.RECORD_MEMBER
            LEFT JOIN #dsn#.COMPANY_PARTNER ON COMPANY_PARTNER.PARTNER_ID = SERVICE.RECORD_PAR
            LEFT JOIN SERVICE_SUBSTATUS ON SERVICE_SUBSTATUS.SERVICE_SUBSTATUS_ID = SERVICE.SERVICE_SUBSTATUS_ID
            LEFT JOIN #dsn#.PRO_PROJECTS ON PRO_PROJECTS.PROJECT_ID = SERVICE.PROJECT_ID
            LEFT JOIN #dsn#.SETUP_CITY ON SETUP_CITY.CITY_ID = SERVICE.SERVICE_CITY_ID
            LEFT JOIN #dsn#.SETUP_COUNTY ON SETUP_COUNTY.COUNTY_ID = SERVICE.SERVICE_COUNTY_ID
            LEFT JOIN SUBSCRIPTION_CONTRACT ON SUBSCRIPTION_CONTRACT.SUBSCRIPTION_ID = SERVICE.SUBSCRIPTION_ID
                ,SERVICE_APPCAT
            WITH (NOLOCK)
                ,#dsn#.SETUP_PRIORITY AS SP
            WITH (NOLOCK)
                ,#dsn#.PROCESS_TYPE_ROWS AS PROCESS_TYPE_ROWS
            WITH (NOLOCK)
            WHERE SERVICE.SERVICECAT_ID = SERVICE_APPCAT.SERVICECAT_ID
                AND SP.PRIORITY_ID = SERVICE.PRIORITY_ID
                AND SERVICE.SERVICE_STATUS_ID = PROCESS_TYPE_ROWS.PROCESS_ROW_ID
                AND SERVICE.SERVICE_ACTIVE = <cfqueryparam cfsqltype="cf_sql_bit" value="true">     
                <cfif isdefined("arguments.consumer_id") and len(arguments.consumer_id)>
                    AND
                    SERVICE.SERVICE_CONSUMER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.consumer_id#"> 
                </cfif>
                <cfif isdefined("arguments.partner_id") and len(arguments.partner_id)>
                    AND
                    SERVICE.SERVICE_PARTNER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.partner_id#">
                </cfif>
                AND SERVICE.SERVICE_ID <> <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.service_id#">
        </cfquery>
        <cfreturn GET_SERVICE>
    </cffunction>
</cfcomponent>