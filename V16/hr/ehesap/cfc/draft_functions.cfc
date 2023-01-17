<!---
    File: muhasebeci_hr.cfc
    Author: Esma R. Uysal <esmauysal@workcube.com>
    Date: 2020-11-13
    Description: Step Step Payroll 
        Taslak Muhasebe Fişi Oluşturulup JSON olarak PAYROLL_JOB tablosuna yazdırılır.
    History:
        
    To Do:

--->
 
<cfcomponent displayname="PAYROLL_JOB_FILE" extends="WMO.functions">
    <cfset dsn = application.systemParam.systemParam().dsn>
    <cfset dsn1 = "#dsn#_product" />
    <cfset dsn2 = "#dsn#_#session.ep.period_year#_#session.ep.company_id#">
    <cfset dsn3 = '#dsn#_#session.ep.company_id#'>
    <cfset dsn_alias = application.systemParam.systemParam().dsn>
    <cfset dsn2_alias = "#dsn#_#session.ep.period_year#_#session.ep.company_id#">
    <cfset dsn3_alias = '#dsn#_#session.ep.company_id#'>
    <cfset dir_seperator = application.systemParam.systemParam().dir_seperator>
    <cfset fusebox.use_period = application.systemParam.systemParam().fusebox.use_period>
    <cfset fusebox.dynamic_hierarchy = application.systemParam.systemParam().fusebox.dynamic_hierarchy>
    <cfset dateformat_style = session.ep.dateformat_style>
    <cfset response = "">
    <cfset data = "">
    <cfset serializedStr = "">
    <cfset serializedStrBudget = "">
    <cfset account_response = "">
    <!--- muhasebeci fonksiyonundan uyarlanmıştır ERU--->
    <cffunction name="muhasebeci_hr" returntype="any" output="false">
        <!---
        by : Admin
        notes : Muhasebe fişi keser...(Tahsil-Tediye-Mahsup)
                !!! TRANSACTION icinde kullanılmalıdır !!!Fonksiyon sorunsuz çalistiginda muhasebe fişi ID sini (true) döndürür.
        usage :
        muhasebeci (
            action_id:attributes.id,
            workcube_process_type:90,
            workcube_process_cat:,
            account_card_type:13, tahsil-tediye veya mahsup card_type_no buna göre alinir ve arttirilir.
            islem_tarihi:'#attributes.PAYROLL_REVENUE_DATE#',
            borc_hesaplar:'100,',
            borc_tutarlar:'123000,',
            other_amount_borc : '120,100' , borc tutarların doviz karsılıklarını tutar
            alacak_hesaplar:'#GET_COMPANY_PERIOD(COMPANY_ID)#,',
            alacak_tutarlar:'#toplam#,',
            other_amount_alacak : '100,120', alacak tutarların doviz karsılıklarını tutar
            other_currency_borc : '#diger_doviz#', other_amount_borc tutarlarının doviz birimini gosterir
            other_currency_alacak : '#diger_doviz2#', other_amount_alacak tutarlarının doviz birimini gosterir
            fis_detay:'#detail#',
            fis_satir_detay: fis satır acıklamalarını gosteriyor, arguman a string veya 2 boyutlu bir array gonderilebilir. 
                        string olarak gonderilisi: '12/12/2005 VADELİ ÇEK GİRİŞ İŞLEMİ',
                        array tipinde veri gonderildiginde; array[1][xxx] borc satırı açıklamalarını, array[2][xxx]  alacak satırı acıklamalarını tutar.
            belge_no : form.belge_no,
            is_account_group : is_account_group , islem kategorisinden gelir
            action_currency_2 : 'USD', ikinci para birimini tutar
            currency_multiplier : '#kur_bilgisi#', sistem ikinci para birimi icin kur bilgisini tutar
            is_other_currency : 0 , eger 1 ise muh fisinin dovizli olarak gosterilecegini (islem dovizlerini), 0 ise gosterilmeyecegini (kaydedilseler bile) set eder
            wrk_id : '' ilgili islem icin kullanilan unique deger varsa o da verilebilir
            muhasebe_db : muhasebeci fonksiyonunu transaction içinde kullanılabilmesini saglar. transaction için dsn2'den farklı kullanılan datasource bu argumana gonderilmelidir.
            muhasebe_db_alias : muhasebe_db_alias argumanına deger gonderilmemelidir, muhasebe_db argumanı DSN2'den farklıysa muhasebe_db_alias set ediliyor...
            company_id : 4 ,  Muhasebe hareketi yazılan işlemin kurumsal uye id si tutulur
            consumer_id : 15,  Muhasebe hareketi yazılan işlemin bireysel uye id si tutulur
            employee_id :  Muhasebe hareketi yazılan işlemin calisan id si tutulur
            alacak_miktarlar :'1,20,5' , satıs faturalarından yapılan muhasebe hareketleri için fatura satırlarındaki urun miktarlarını gosterir
            borc_miktarlar : '1,20,5',  alış faturalarından yapılan muhasebe hareketleri için fatura satırlarındaki urun miktarlarını gosterir
            alacak_birim_tutar : '15,25,45', satıs faturalarından yapılan muhasebe hareketleri için fatura satırlarındaki urun fiyatını gosterir
            borc_birim_tutar : '15,25,45' alış faturalarından yapılan muhasebe hareketleri için fatura satırlarındaki urun fiyatını gosterir
            is_abort : işlem kesilsinmi yoksa devam etsinmi
            );		
        revisions :20040227, 20051020, OZDEN20051101, OZDEN20051221 ,OZDEN20051230, 20060101, 20060125, OZDEN20060406, OZDEN20060421, OZDEN20060628, OZDEN20060907, OZDEN20060926, OZDEN20070411, OZDEN20070624
        UFRS_CODE eklendi OZDEN20071212
        is_abort  eklendi TolgaS 20080221
        yuvarlama bölümü eklendi OZDEN20080304
        --->
        <cfargument name="action_id" required="yes" type="numeric">
        <cfargument name="action_currency" required="yes" default="#session.ep.money#">
        <cfargument name="action_currency_2" type="string" default="#session.ep.money2#">
        <cfargument name="currency_multiplier" type="string" default="">
        <cfargument name="workcube_process_type" required="yes" type="numeric">
        <cfargument name="account_card_type" required="yes" type="numeric">
        <cfargument name="account_card_catid" required="yes" type="numeric" default="0"> <!--- muhasebe fiş türünün process_cat_id si--->
        <cfargument name="islem_tarihi" required="yes" type="date">
        <cfargument name="borc_hesaplar" required="yes" type="string">
        <cfargument name="borc_tutarlar" required="yes" type="string">
        <cfargument name="alacak_hesaplar" required="yes" type="string">
        <cfargument name="alacak_tutarlar" required="yes" type="string">
        <cfargument name="other_amount_borc" type="string" default="">	
        <cfargument name="other_amount_alacak" type="string" default="">	
        <cfargument name="other_currency_borc" type="string" default="">
        <cfargument name="other_currency_alacak" type="string" default="">
        <cfargument name="belge_no" type="string" default="">
        <cfargument name="belge_no_satir" type="string" default="">
        <cfargument name="fis_detay" type="string">
        <cfargument name="fis_satir_detay" default="">
        <cfargument name="wrk_id" type="string" default="">
        <cfargument name="muhasebe_db" type="string" default="#dsn2#">
        <cfargument name="muhasebe_db_alias" type="string" default="">
        <cfargument name="company_id" default="">
        <cfargument name="consumer_id" default="">
        <cfargument name="employee_id" default="">
        <cfargument name="alacak_miktarlar" default="">
        <cfargument name="borc_miktarlar" default="">
        <cfargument name="alacak_birim_tutar" default="">
        <cfargument name="borc_birim_tutar" default="">
        <cfargument name="is_account_group" type="numeric" default="0">
        <cfargument name="is_other_currency" type="numeric" default="0"><!--- 0: muhasebe fisi dovizli goruntulenMEsin, 1: goruntulensin --->
        <cfargument name="base_period_year_start" default="">
        <cfargument name="base_period_year_finish" default="">
        <cfargument name="action_table" type="string"> <!--- payrollda cek bazlı muhasebe islemi yapılabilmesi icin eklendi --->
        <cfargument name="from_branch_id">
        <cfargument name="to_branch_id">
        <cfargument name="acc_department_id">
        <cfargument name="acc_project_id">
        <cfargument name="acc_project_list_alacak" type="string" default="">
        <cfargument name="acc_project_list_borc" type="string" default="">
        <cfargument name="acc_branch_list_alacak" type="string" default="">
        <cfargument name="acc_branch_list_borc" type="string" default="">
        <cfargument name="is_abort" type="numeric" default="1">
        <cfargument name="dept_round_account" default=""> <!---muhasebe fisi borc-alacak toplamları arasındaki BORC FARKI icin kullanılacak yuvarlama hesabı --->
        <cfargument name="claim_round_account" default=""> <!---muhasebe fisi borc-alacak toplamları arasındaki ALACAK FARKI icin kullanılacak yuvarlama hesabı --->
        <cfargument name="max_round_amount" default="0"> <!---borc-alacak toplamları arasında yuvarlama yapılabilecek max. fark --->
        <cfargument name="round_row_detail" default=""><!--- yuvarlama satırı acıklama bilgisi, gönderilmezse yuvarlama satırına fis_detay bilgisi yazılır --->
        <cfargument name="workcube_process_cat" default=""> <!--- islem kategorisi process_cat_id --->
        <cfargument name="action_row_id" default="">
        <cfargument name="due_date" default="">
        <cfargument name="is_cancel">
        <cfargument name="document_type" default="">
        <cfargument name="payment_method" default="">
        <cfargument name="is_acc_type" default="0">
        <cfargument name="payroll_id_list" default="0">
        <cfset account_data = structnew()>
        <cfset  return_error = structNew()>
        <cftry>
        <cfif isDefined('session.ep.userid')>
            <cfif not len(arguments.base_period_year_start)>
                <cfset arguments.base_period_year_start = year(session.ep.period_start_date)>
            </cfif>
            <cfif not len(arguments.base_period_year_finish)>
                <cfset arguments.base_period_year_finish = year(session.ep.period_finish_date)>
            </cfif>   
        </cfif>
        <cfscript>
            if(arguments.muhasebe_db_alias == '' and arguments.muhasebe_db is not '#dsn2#')
            {
                if(arguments.muhasebe_db is '#dsn#' or arguments.muhasebe_db is '#dsn1#' or arguments.muhasebe_db is '#dsn3#')		
                    arguments.muhasebe_db_alias = '#dsn2_alias#.';
                else 
                    arguments.muhasebe_db_alias = '#muhasebe_db#.';
            }
            else
            {
                arguments.muhasebe_db_alias = '#arguments.muhasebe_db_alias#.';
            }
        </cfscript>
        <cfif len(arguments.workcube_process_cat) and arguments.workcube_process_cat neq 0 and arguments.is_acc_type eq 0>
		
            <cfquery name="getProcessCat" datasource="#arguments.muhasebe_db#"> <!---fiş türüne ait default olarak tanımlanmış işlem kategorisi bulunuyor --->
                SELECT
                    ACCOUNT_TYPE_ID
                FROM
                    #dsn3#.SETUP_PROCESS_CAT
                WHERE
                    PROCESS_CAT_ID = #arguments.workcube_process_cat#
            </cfquery>
			
            <cfif len(getProcessCat.account_type_id) and (len(arguments.company_id) or len(arguments.consumer_id))>
			
                <!--- üyenin muhasebe kodu tespit edilmeye çalışılıyor --->
                <cfif len(arguments.company_id)>
                    <cfset member_account_code = get_company_period(company_id : arguments.company_id, basket_money_db : arguments.muhasebe_db)>
                    <cfquery name = "getAccCode" datasource = "#arguments.muhasebe_db#">
                        SELECT * FROM #dsn_alias#.COMPANY_PERIOD WHERE COMPANY_ID = #arguments.company_id# AND PERIOD_ID = #session.ep.period_id#
                    </cfquery>
                <cfelseif len(arguments.consumer_id)>
                    <cfset member_account_code = get_consumer_period(consumer_id : arguments.consumer_id, basket_money_db : arguments.muhasebe_db)>
                    <cfquery name = "getAccCode" datasource = "#arguments.muhasebe_db#">
                        SELECT * FROM #dsn_alias#.CONSUMER_PERIOD WHERE PERIOD_ID = #arguments.consumer_id# AND PERIOD_ID = #session.ep.period_id#
                    </cfquery>
                </cfif>
                <cfswitch expression = "#getProcessCat.account_type_id#">
                    <cfcase value = "-1">
                        <cfset new_account_code = getAccCode.account_code>
                    </cfcase>
                    <cfcase value = "-2">
                        <cfset new_account_code = getAccCode.sales_account>
                    </cfcase>
                    <cfcase value = "-3">
                        <cfset new_account_code = getAccCode.purchase_account>
                    </cfcase>
                    <cfcase value = "-4">
                        <cfset new_account_code = getAccCode.received_advance_account>
                    </cfcase>
                    <cfcase value = "-5">
                        <cfset new_account_code = getAccCode.advance_payment_code>
                    </cfcase>
                    <cfcase value = "-6">
                        <cfset new_account_code = getAccCode.received_guarantee_account>
                    </cfcase>
                    <cfcase value = "-7">
                        <cfset new_account_code = getAccCode.given_guarantee_account>
                    </cfcase>
                    <cfcase value = "-8">
                        <cfset new_account_code = getAccCode.konsinye_code>
                    </cfcase>
                    <cfcase value = "-9">
                        <cfset new_account_code = getAccCode.EXPORT_REGISTERED_SALES_ACCOUNT>
                    </cfcase>
                    <cfcase value = "-10">
                        <cfset new_account_code = getAccCode.EXPORT_REGISTERED_BUY_ACCOUNT>
                    </cfcase>
                    <cfdefaultcase><cfset new_account_code = ""></cfdefaultcase>
                </cfswitch>
                <cfscript>
                    if(len(new_account_code)) {
                        // alacak hesaplarda carinin muhasebe kodu var mı?
                        alacakIndex = listFind(arguments.alacak_hesaplar,member_account_code);

                        // borc hesaplarda carinin muhasebe kodu var mı?
                        borcIndex = listFind(arguments.borc_hesaplar,member_account_code);

                        if(alacakIndex gt 0) {
                            arguments.alacak_hesaplar = listSetAt(arguments.alacak_hesaplar,alacakIndex,new_account_code);
                        }
                        if(borcIndex gt 0) {
                            arguments.borc_hesaplar = listSetAt(arguments.borc_hesaplar,borcIndex,new_account_code);
                        }
                    }
                </cfscript>
            </cfif>
        </cfif>
        <cfif isdefined("session.pp")>
            <cfset session_base = evaluate('session.pp')>
        <cfelseif isdefined("session.ep")>
            <cfset session_base = evaluate('session.ep')>
        <cfelseif isdefined('session.ww')>
            <cfset session_base = evaluate('session.ww')>
        </cfif>
        <cfif ((isDefined('arguments.base_period_year_start') and year(arguments.islem_tarihi) lt arguments.base_period_year_start) or (isDefined('arguments.base_period_year_finish') and len(arguments.base_period_year_finish) and year(arguments.islem_tarihi) gt arguments.base_period_year_finish)) and workcube_process_type neq 130 and workcube_process_type neq 161>
            <cfset return_error.error_message = 'Muhasebeci : İşlem Tarihi Döneme Uygun Değil.'><cfreturn return_error>
        </cfif>
        <cfif len(arguments.other_amount_borc) and listlen(arguments.other_amount_borc,',') neq listlen(arguments.borc_tutarlar,',')>
            <cfset return_error.error_message = 'Muhasebeci : Dövizli Borç Listesi Eksik.'><cfreturn return_error>
        </cfif>
        <cfif len(arguments.other_amount_alacak) and listlen(arguments.other_amount_alacak,',') neq listlen(arguments.alacak_tutarlar,',')>
            <cfset return_error.error_message = 'Muhasebeci : Dövizli Alacak Listesi Eksik.'><cfreturn return_error>
        </cfif>
        <cfif len(arguments.action_currency_2) and (not len(arguments.currency_multiplier))>
			<cfscript>
                get_currency_rate = cfquery(datasource:"#arguments.muhasebe_db#", sqlstring:"SELECT (RATE2/RATE1) RATE FROM #arguments.muhasebe_db_alias#SETUP_MONEY WHERE MONEY ='#arguments.action_currency_2#'");
                if(get_currency_rate.recordcount) arguments.currency_multiplier = get_currency_rate.RATE;
			</cfscript>
        </cfif>
        <cfscript>
            muh_query = QueryNew("BA,ACCOUNT_CODE,AMOUNT,OTHER_AMOUNT,OTHER_CURRENCY,DETAIL,QUANTITY,PRICE,ACC_PROJECT_ID,ACC_BRANCH_ID","Bit,VarChar,Double,Double,Varchar,Varchar,Double,Double,Double,Double");
            muh_query_row = 0;
            borc_hesaplar_total = 0;
            alacak_hesaplar_total = 0;
            other_borc_hesaplar_total = 0;
            other_alacak_hesaplar_total = 0;
            for(i_index=1;i_index lte listlen(arguments.borc_hesaplar,',');i_index=i_index+1){
                if((wrk_round(listgetat(arguments.borc_tutarlar,i_index,','),4) gt 0 and len(listgetat(arguments.borc_hesaplar,i_index,',')) gt 0) or (listlen(arguments.other_amount_borc) and wrk_round(listgetat(arguments.other_amount_borc,i_index,','),4) gt 0 and len(listgetat(arguments.borc_hesaplar,i_index,',')) gt 0))
                    {
                    muh_query_row = muh_query_row + 1;
                    QueryAddRow(muh_query,1);
                    QuerySetCell(muh_query,"BA",0,muh_query_row);
                    QuerySetCell(muh_query,"ACCOUNT_CODE",listgetat(arguments.borc_hesaplar,i_index,','),muh_query_row);
                    {
                        QuerySetCell(muh_query,"AMOUNT",listgetat(arguments.borc_tutarlar,i_index,','),muh_query_row);
                        if(len(arguments.other_amount_borc)){
                            QuerySetCell(muh_query,"OTHER_AMOUNT",listgetat(arguments.other_amount_borc,i_index,','),muh_query_row);
                            QuerySetCell(muh_query,"OTHER_CURRENCY",listgetat(arguments.other_currency_borc,i_index,','),muh_query_row);
                            }
                    }
                    if(IsArray(arguments.fis_satir_detay) and Arraylen(arguments.fis_satir_detay[1]) gte i_index)
                    {
                         
                        if(isdefined("arguments.belge_no_satir") and len(arguments.belge_no_satir))
                            arguments.fis_satir_detay[1][i_index] = replace(arguments.fis_satir_detay[1][i_index],listgetat(arguments.belge_no_satir,i_index,','),'','all');
                        else if (len(arguments.belge_no))
                            arguments.fis_satir_detay[1][i_index] = replace(arguments.fis_satir_detay[1][i_index],arguments.belge_no,'','all');
                        if(isdefined("arguments.belge_no_satir") and len(arguments.belge_no_satir)){
                            if(len(listgetat(arguments.belge_no_satir,i_index,',')) and not findnocase(listgetat(arguments.belge_no_satir,i_index,','),arguments.fis_satir_detay[1][i_index]))
                            {
                                arguments.fis_satir_detay[1][i_index] =  listgetat(arguments.belge_no_satir,i_index,',')&"-"&arguments.fis_satir_detay[1][i_index] ;
                                arguments.fis_satir_detay[1][i_index] = replace(arguments.fis_satir_detay[1][i_index],'- -','-');
                                arguments.fis_satir_detay[1][i_index] = replace(arguments.fis_satir_detay[1][i_index],'--','-');
                            }
                        }
                        else if(len(arguments.belge_no) and not findnocase(arguments.belge_no,arguments.fis_satir_detay[1][i_index]))
                        {
                            arguments.fis_satir_detay[1][i_index] =  arguments.belge_no&"-"&arguments.fis_satir_detay[1][i_index] ;
                            arguments.fis_satir_detay[1][i_index] = replace(arguments.fis_satir_detay[1][i_index],'- -','-');
                            arguments.fis_satir_detay[1][i_index] = replace(arguments.fis_satir_detay[1][i_index],'--','-');
                        }
                        QuerySetCell(muh_query,"DETAIL",arguments.fis_satir_detay[1][i_index],muh_query_row);
                    }
                    else if (not IsArray(arguments.fis_satir_detay))
                    {
                        if(isdefined("arguments.belge_no_satir") and len(arguments.belge_no_satir))
                            arguments.fis_satir_detay = replace(arguments.fis_satir_detay,"#arguments.belge_no_satir# - ",'','all');
                        else if(len(arguments.belge_no))
                            arguments.fis_satir_detay = replace(arguments.fis_satir_detay,"#arguments.belge_no# - ",'','all');

                        if(isdefined("arguments.belge_no_satir") and len(arguments.belge_no_satir)){
                            if(len(arguments.belge_no_satir) and not findnocase(arguments.belge_no_satir,arguments.fis_satir_detay))
                            {
                                arguments.fis_satir_detay =  arguments.belge_no_satir&"-"&arguments.fis_satir_detay;
                                arguments.fis_satir_detay = replace(arguments.fis_satir_detay,'- -','-');
                                arguments.fis_satir_detay = replace(arguments.fis_satir_detay,'--','-');
                            }
                         }
                        else if(len(arguments.belge_no) and not findnocase(arguments.belge_no,arguments.fis_satir_detay))
                        {
                            arguments.fis_satir_detay =  arguments.belge_no&"-"&arguments.fis_satir_detay;
                            arguments.fis_satir_detay = replace(arguments.fis_satir_detay,'- -','-');
                            arguments.fis_satir_detay = replace(arguments.fis_satir_detay,'--','-');
                        }
                        QuerySetCell(muh_query,"DETAIL",arguments.fis_satir_detay,muh_query_row);
                    }
                    if(IsArray(arguments.borc_miktarlar) and Arraylen(arguments.borc_miktarlar) gte i_index)
                        QuerySetCell(muh_query,"QUANTITY",arguments.borc_miktarlar[i_index],muh_query_row);
                    else if (not IsArray(arguments.borc_miktarlar))
                        QuerySetCell(muh_query,"QUANTITY",arguments.borc_miktarlar,muh_query_row);
                    if(IsArray(arguments.borc_birim_tutar) and Arraylen(arguments.borc_birim_tutar) gte i_index)
                        QuerySetCell(muh_query,"PRICE",arguments.borc_birim_tutar[i_index],muh_query_row);
                    else if (not IsArray(arguments.borc_birim_tutar))
                        QuerySetCell(muh_query,"PRICE",arguments.borc_birim_tutar,muh_query_row);
                    if(listlen(arguments.acc_project_list_borc))
                        QuerySetCell(muh_query,"ACC_PROJECT_ID",listgetat(arguments.acc_project_list_borc,i_index,','),muh_query_row);
                    else if (not listlen(arguments.acc_project_list_borc))
                        QuerySetCell(muh_query,"ACC_PROJECT_ID",0,muh_query_row);
                    if(len(arguments.acc_branch_list_borc))
                        QuerySetCell(muh_query,"ACC_BRANCH_ID",listgetat(arguments.acc_branch_list_borc,i_index,','),muh_query_row);
                    else
                        QuerySetCell(muh_query,"ACC_BRANCH_ID",0,muh_query_row);
                    }
            }
            for(i_index=1;i_index lte listlen(arguments.alacak_hesaplar,',');i_index=i_index+1){
                if((wrk_round(listgetat(arguments.alacak_tutarlar,i_index,','),4) gt 0 and len(listgetat(arguments.alacak_hesaplar,i_index,',')) gt 0) or (listlen(arguments.other_amount_alacak) and wrk_round(listgetat(arguments.other_amount_alacak,i_index,','),4) gt 0 and len(listgetat(arguments.alacak_hesaplar,i_index,',')) gt 0))
                    {
                    muh_query_row = muh_query_row + 1;
                    QueryAddRow(muh_query,1);
                    QuerySetCell(muh_query,"BA",1,muh_query_row);
                    QuerySetCell(muh_query,"ACCOUNT_CODE",listgetat(arguments.alacak_hesaplar,i_index,','),muh_query_row);
                    {
                        QuerySetCell(muh_query,"AMOUNT",listgetat(arguments.alacak_tutarlar,i_index,','),muh_query_row);
                        if(len(arguments.other_amount_alacak)){
                            QuerySetCell(muh_query,"OTHER_AMOUNT",listgetat(arguments.other_amount_alacak,i_index,','),muh_query_row);
                            QuerySetCell(muh_query,"OTHER_CURRENCY",listgetat(arguments.other_currency_alacak,i_index,','),muh_query_row);
                            }	
                    }
                    if(IsArray(arguments.fis_satir_detay) and Arraylen(arguments.fis_satir_detay[2]) gte i_index)
                    {
                        if(isdefined("arguments.belge_no_satir") and len(arguments.belge_no_satir)){
                            if(len(listgetat(arguments.belge_no_satir,i_index,',')) and not findnocase(listgetat(arguments.belge_no_satir,i_index,','),arguments.fis_satir_detay[2][i_index]))
                            {
                                arguments.fis_satir_detay[2][i_index] =  listgetat(arguments.belge_no_satir,i_index,',')&"-"&arguments.fis_satir_detay[2][i_index] ;
                                arguments.fis_satir_detay[2][i_index] = replace(arguments.fis_satir_detay[2][i_index],'- -','-');
                            }
                         }
                        else if(len(arguments.belge_no) and not findnocase(arguments.belge_no,arguments.fis_satir_detay[2][i_index]))
                        {
                            arguments.fis_satir_detay[2][i_index] =  arguments.belge_no&"-"&arguments.fis_satir_detay[2][i_index] ;
                            arguments.fis_satir_detay[2][i_index] = replace(arguments.fis_satir_detay[2][i_index],'- -','-');
                        }
                        QuerySetCell(muh_query,"DETAIL",arguments.fis_satir_detay[2][i_index],muh_query_row);
                    }
                    else if (not IsArray(arguments.fis_satir_detay))
                    {
                        if(isdefined("arguments.belge_no_satir") and len(arguments.belge_no_satir)){
                            if(len(listgetat(arguments.belge_no_satir,i_index,',')) and not findnocase(listgetat(arguments.belge_no_satir,i_index,','),arguments.fis_satir_detay))
                            {
                                arguments.fis_satir_detay =  listgetat(arguments.belge_no_satir,i_index,',')&"-"&arguments.fis_satir_detay ;
                                arguments.fis_satir_detay = replace(arguments.fis_satir_detay,'- -','-');
                            }
                        }
                        else if(len(arguments.belge_no) and not findnocase(arguments.belge_no,arguments.fis_satir_detay))
                        {
                            arguments.fis_satir_detay =  arguments.belge_no&"-"&arguments.fis_satir_detay ;
                            arguments.fis_satir_detay = replace(arguments.fis_satir_detay,'- -','-');
                        }
                        QuerySetCell(muh_query,"DETAIL",arguments.fis_satir_detay,muh_query_row);
                    }
                    if(IsArray(arguments.alacak_miktarlar) and Arraylen(arguments.alacak_miktarlar) gte i_index)
                        QuerySetCell(muh_query,"QUANTITY",arguments.alacak_miktarlar[i_index],muh_query_row);
                    else if (not IsArray(arguments.alacak_miktarlar))
                        QuerySetCell(muh_query,"QUANTITY",arguments.alacak_miktarlar,muh_query_row);
                    if(IsArray(arguments.alacak_birim_tutar) and Arraylen(arguments.alacak_birim_tutar) gte i_index)
                        QuerySetCell(muh_query,"PRICE",arguments.alacak_birim_tutar[i_index],muh_query_row);
                    else if (not IsArray(arguments.alacak_birim_tutar))
                        QuerySetCell(muh_query,"PRICE",arguments.alacak_birim_tutar,muh_query_row);
                    if(listlen(arguments.acc_project_list_alacak))
                        QuerySetCell(muh_query,"ACC_PROJECT_ID",listgetat(arguments.acc_project_list_alacak,i_index,','),muh_query_row);
                    else if (not listlen(arguments.acc_project_list_alacak))
                        QuerySetCell(muh_query,"ACC_PROJECT_ID",0,muh_query_row);
                    if(len(arguments.acc_branch_list_alacak))
                        QuerySetCell(muh_query,"ACC_BRANCH_ID",listgetat(arguments.acc_branch_list_alacak,i_index,','),muh_query_row);
                    else
                        QuerySetCell(muh_query,"ACC_BRANCH_ID",0,muh_query_row);
                    }
            }
            /*20040112 alttaki iki satirda fatura para biriminin kuruş durumuna göre round işlemi yapılmalı yoksa kuruş kaçar*/
            //alacak_hesaplar_total = wrk_round(alacak_hesaplar_total,2);
            //borc_hesaplar_total = wrk_round(borc_hesaplar_total,2);
            if( arguments.is_account_group )
            {
                if(not len(session.ep.our_company_info.is_project_group) or session.ep.our_company_info.is_project_group eq 1)//şirket akış parametrelerinde proje bazında grupla seçili ise
                    muh_query = cfquery(dbtype:'query',datasource:"",sqlstring:"SELECT SUM(OTHER_AMOUNT) OTHER_AMOUNT,SUM(AMOUNT) AMOUNT,ACC_PROJECT_ID, BA, ACCOUNT_CODE, OTHER_CURRENCY,DETAIL,SUM(QUANTITY) QUANTITY, SUM(PRICE) PRICE FROM muh_query GROUP BY ACC_PROJECT_ID,BA, ACCOUNT_CODE, OTHER_CURRENCY,DETAIL ORDER BY BA");
                else
                    muh_query = cfquery(dbtype:'query',datasource:"",sqlstring:"SELECT SUM(OTHER_AMOUNT) OTHER_AMOUNT,SUM(AMOUNT) AMOUNT,0 ACC_PROJECT_ID, BA, ACCOUNT_CODE, OTHER_CURRENCY,DETAIL,SUM(QUANTITY) QUANTITY, SUM(PRICE) PRICE FROM muh_query GROUP BY BA, ACCOUNT_CODE, OTHER_CURRENCY,DETAIL ORDER BY BA");
            }
            if(len(arguments.belge_no) and not findnocase(arguments.belge_no,arguments.fis_detay))
                arguments.fis_detay =  arguments.belge_no&" No'lu "&arguments.fis_detay ;
            for(cnt_i=1;cnt_i lte muh_query.recordcount;cnt_i=cnt_i+1) //borc alacak toplamı bulunup, fiste fark var mı bakılır
            {
                if(muh_query.BA[cnt_i] eq 1)
                {
                    alacak_hesaplar_total = alacak_hesaplar_total + wrk_round(muh_query.AMOUNT[cnt_i]);
                    if(len(muh_query.OTHER_AMOUNT[cnt_i]))
                        other_alacak_hesaplar_total = other_alacak_hesaplar_total + wrk_round(muh_query.OTHER_AMOUNT[cnt_i]);
                }
                else if (muh_query.BA[cnt_i] eq 0)
                {
                    borc_hesaplar_total = borc_hesaplar_total + wrk_round(muh_query.AMOUNT[cnt_i]);
                    if(len(muh_query.OTHER_AMOUNT[cnt_i]))
                        other_borc_hesaplar_total = other_borc_hesaplar_total + wrk_round(muh_query.OTHER_AMOUNT[cnt_i]);
                }
            }
            
            if(wrk_round(alacak_hesaplar_total) is not wrk_round(borc_hesaplar_total) or wrk_round((alacak_hesaplar_total-borc_hesaplar_total),2) neq 0) // borc-alacak tutmayan fisler icin yuvarlama yapılıyor
            {
                temp_fark = round((alacak_hesaplar_total-borc_hesaplar_total)*100);
                
                if(temp_fark gte (arguments.max_round_amount*-100) and temp_fark lt 0 and len(arguments.claim_round_account))
                {// fark alacaklilara eklenmeli, borc bakiye gelmis,muhasebeci querysine fark satırı ekleniyor
                    muh_query_row = muh_query.recordcount + 1;
                    QueryAddRow(muh_query,1);
                    QuerySetCell(muh_query,"BA",1,muh_query_row);
                    QuerySetCell(muh_query,"ACCOUNT_CODE",claim_round_account,muh_query_row);
                    QuerySetCell(muh_query,"AMOUNT",abs(temp_fark/100),muh_query_row);
                    QuerySetCell(muh_query,"OTHER_AMOUNT",abs(temp_fark/100),muh_query_row);
                    QuerySetCell(muh_query,"OTHER_CURRENCY",session_base.money,muh_query_row);
                    QuerySetCell(muh_query,"DETAIL",arguments.fis_detay,muh_query_row);
                    QuerySetCell(muh_query,"ACC_PROJECT_ID",0,muh_query_row);
                }
                else if(temp_fark lte (arguments.max_round_amount*100) and temp_fark gt 0 and len(arguments.dept_round_account))
                {//fark borclulara eklenmeli, alacak bakiye gelmis,muhasebeci querysine fark satırı ekleniyor 
                    muh_query_row = muh_query.recordcount + 1;
                    QueryAddRow(muh_query,1);
                    QuerySetCell(muh_query,"BA",0,muh_query_row);
                    QuerySetCell(muh_query,"ACCOUNT_CODE",dept_round_account,muh_query_row);
                    QuerySetCell(muh_query,"AMOUNT",abs(temp_fark/100),muh_query_row);
                    QuerySetCell(muh_query,"OTHER_AMOUNT",abs(temp_fark/100),muh_query_row);
                    QuerySetCell(muh_query,"OTHER_CURRENCY",session_base.money,muh_query_row);
                    QuerySetCell(muh_query,"DETAIL",arguments.fis_detay,muh_query_row);
                    QuerySetCell(muh_query,"ACC_PROJECT_ID",0,muh_query_row);
                }
                //yuvarlama satırı da eklenlendikten sonra fark olup olmadıgı yeniden kontrol ediliyor
                alacak_hesaplar_total =0;
                borc_hesaplar_total = 0;
                other_alacak_hesaplar_total =0;
                other_borc_hesaplar_total = 0;
                for(cnt_k=1;cnt_k lte muh_query.recordcount;cnt_k=cnt_k+1)
                {
                    if(muh_query.BA[cnt_k] eq 1)
                    {
                        alacak_hesaplar_total = alacak_hesaplar_total + wrk_round(muh_query.AMOUNT[cnt_k]);
                        if(len(muh_query.OTHER_AMOUNT[cnt_k]))
                            other_alacak_hesaplar_total = other_alacak_hesaplar_total + wrk_round(muh_query.OTHER_AMOUNT[cnt_k]);
                    }
                    else if (muh_query.BA[cnt_k] eq 0)
                    {
                        borc_hesaplar_total = borc_hesaplar_total + wrk_round(muh_query.AMOUNT[cnt_k]);
                        if(len(muh_query.OTHER_AMOUNT[cnt_k]))
                        other_borc_hesaplar_total = other_borc_hesaplar_total + wrk_round(muh_query.OTHER_AMOUNT[cnt_k]);
                    }
                }
            }
        </cfscript>
        <cfif wrk_round((alacak_hesaplar_total-borc_hesaplar_total),2) neq 0 or (arguments.workcube_process_type eq 111 and (listlen(arguments.alacak_tutarlar) neq listlen(arguments.alacak_hesaplar) or listlen(arguments.borc_tutarlar) neq listlen(arguments.borc_hesaplar)))>
            <cfset alert_str = "<table class='ajax_list'><thead><tr><th colspan='4'>#getLang('','Muhasebe Fişi Borç-Alacak Bakiyesi Eşit Değil','59057')#!</th></tr></thead>">
            <cfset alert_str = alert_str & '<tbody><tr><td>borc_hesaplar</td></tr>'>
            <cfset alert_str = alert_str & '<tr><td>'>
            <cfloop from="1" to="#listlen(arguments.borc_hesaplar,',')#" index="i">
                <cfset alert_str = alert_str & '#listgetat(arguments.borc_hesaplar,i,',')#=#TLFormat(listgetat(arguments.borc_tutarlar,i,','))#<br>'>
            </cfloop>
             
           <cfset alert_str = alert_str & '</tr></td><tr><td>borc_hesaplar_total = #TLFormat(borc_hesaplar_total)#</tr></td>'>
      
           <cfset alert_str = alert_str & '<tr><td>alacak_hesaplar:</td></tr>'>
           <cfset alert_str = alert_str & '<tr><td>'>
            <cfloop from="1" to="#listlen(arguments.alacak_hesaplar,',')#" index="i">
                <cfset alert_str = alert_str & '#listgetat(arguments.alacak_hesaplar,i,',')#=#TLFormat(listgetat(arguments.alacak_tutarlar,i,','))# <br>'>
            </cfloop>
            <cfset alert_str = alert_str & '</tr></td><tr><td>alacak_hesaplar_total = #TLFormat(alacak_hesaplar_total)#</tr></td>'>
            <cfset alert_str = alert_str & '<tr><td>Fark = #TLFormat(borc_hesaplar_total-alacak_hesaplar_total)# '>
            <cfif borc_hesaplar_total gt alacak_hesaplar_total><cfset alert_str = alert_str & "(B)</tr></td><tbody>"><cfelse><cfset alert_str = alert_str & "(A)</tr></td><tbody></table>"></cfif>
            <cfset return_error.error_message = alert_str>
            <cfreturn return_error>
        <cfelse>
            <cfset index = 0>
            <cfloop query="muh_query">
                <cfif ListFind("48,49,45,46",arguments.workcube_process_type)><!--- kur farkı faturalarında döviz bakiyeleri sıfırlamak için.. Ayşenur20080111 --->
                    <cfif isDefined('muh_query.OTHER_AMOUNT') and len(muh_query.OTHER_AMOUNT) and muh_query.OTHER_AMOUNT neq "session_base.money">
                        <cfset muh_query.OTHER_AMOUNT = 0>
                        <cfset action_value2 = 0>
                    </cfif>
                <cfelseif len(arguments.currency_multiplier)>
                    <cfset action_value2 = (wrk_round(muh_query.AMOUNT)/arguments.currency_multiplier)>
                </cfif>
                <cfif wrk_round(muh_query.AMOUNT,2) neq 0 or wrk_round(muh_query.OTHER_AMOUNT,2) neq 0>
                    <cfset account_data.muhasebe_kodu[index] = muh_query.ACCOUNT_CODE>
                    <cfset account_data.detay[index] = '#left(muh_query.DETAIL,500)#'>
                    <cfset account_data.borc_alacak[index] = muh_query.BA>
                    <cfset account_data.miktar[index] = wrk_round(muh_query.AMOUNT,2)>
                    <cfset account_data.para_birimi[index] = arguments.action_currency>
                    <cfset account_data.amount_2[index] = len(arguments.currency_multiplier) ? wrk_round(action_value2,2) : ''>
                    <cfset account_data.amount_2_currency[index] =  len(arguments.currency_multiplier) ? '#arguments.action_currency_2#' : ''>
                    <cfset account_data.fiyat[index] = len(muh_query.PRICE) ? muh_query.PRICE :'' >
                    <cfset account_data.other_currency[index] = len(muh_query.OTHER_CURRENCY) and len(muh_query.OTHER_AMOUNT) ? muh_query.OTHER_CURRENCY : arguments.action_currency>
                    <cfset account_data.other_amount[index] = len(muh_query.OTHER_CURRENCY) and len(muh_query.OTHER_AMOUNT) ? wrk_round(muh_query.OTHER_AMOUNT,2) : wrk_round(muh_query.OTHER_AMOUNT,2)>
                    <cfset account_data.quantity[index] = len(muh_query.QUANTITY) ? muh_query.QUANTITY : ''>
                    <cfset account_data.departman_id[index] = isdefined('arguments.acc_department_id') and len(arguments.acc_department_id) ? arguments.acc_department_id : ''>
                    <cfif isdefined("muh_query.ACC_BRANCH_ID") and len(muh_query.ACC_BRANCH_ID) and muh_query.ACC_BRANCH_ID gt 0>
                        <cfset branch_id = muh_query.ACC_BRANCH_ID>
                    <cfelse>
                        <cfif isdefined('arguments.from_branch_id') and len(arguments.from_branch_id) and not (isdefined('arguments.to_branch_id') and len(arguments.to_branch_id))>
                        <!--- sadece from_branch_id gönderildiyse --->
                            <cfset branch_id = arguments.from_branch_id>
                        <cfelseif isdefined('arguments.to_branch_id') and len(arguments.to_branch_id) and not (isdefined('arguments.from_branch_id') and len(arguments.from_branch_id))>
                        <!--- sadece to_branch_id gönderildiyse --->
                            <cfset branch_id = arguments.to_branch_id>
                        <cfelse>
                            <cfif muh_query.BA eq 1>
                                <cfif isdefined('arguments.from_branch_id') and len(arguments.from_branch_id)>
                                    <cfset branch_id = arguments.from_branch_id>
                                <cfelse>
                                    <cfset branch_id = ''>
                                </cfif>
                            <cfelse>
                                <cfif isdefined('arguments.to_branch_id') and len(arguments.to_branch_id)>
                                    <cfset branch_id = arguments.to_branch_id>
                                <cfelse>
                                    <cfset branch_id = ''>
                                </cfif>
                            </cfif>
                        </cfif>
                    </cfif>
                    <cfset account_data.sube_id[index] = branch_id>
                    <cfset account_data.proje_id[index] = isdefined('arguments.acc_project_id') and len(arguments.acc_project_id) and arguments.acc_project_id neq 0 ? arguments.acc_project_id : ''>
                    <cfset serializedStr = Replace(SerializeJSON(account_data),'//','')>
                    <cfset index = index+1>
                </cfif>
            </cfloop>
            <cfif len(serializedStr)>
                <cfquery name="upd_payrol_job" datasource="#arguments.muhasebe_db#">
                    UPDATE
                        #dsn_alias#.PAYROLL_JOB   
                    SET
                        ACCOUNT_COMPLETED  = <cfqueryparam CFSQLType = "cf_sql_bit" value = "1">,
                        ACCOUNT_DRAFT = <cfqueryparam CFSQLType = "cf_sql_varchar" value = "#serializedStr#">
                    WHERE 
                        EMPLOYEE_PAYROLL_ID = <cfqueryparam CFSQLType = "cf_sql_integer" value = "#arguments.PAYROLL_ID_LIST#">
                </cfquery>
            </cfif>
            <cfreturn 1>
        </cfif>
        <cfcatch type="exception">
            <cfset return_error.message = cfcatch.Message>
            <cfset return_error.line = cfcatch.TagContext[1].LINE>
            <cfset return_error.raw_trace = cfcatch.TagContext[1].RAW_TRACE>
            <cfreturn return_error>
        </cfcatch>
        </cftry>
        
    </cffunction>
    <!--- butceci fonksiyonundan uyarlanmıştır ERU--->
    <cffunction name="butceci_hr" returntype="boolean" output="false">
        <!---
        notes : Butçe fişi keser...
                !!! TRANSACTION icinde kullanilmalidir !!!, ancak bu durumda transaction icindeki diger queryler de
                bu fonksiyon gibi dsn2 den calismalidir. Fonksiyon dagilim yaptigi taktirde (true) degilse false dondurur.
                ****dongu icinde hersatirda sil calismamasi icin butceci icinde sil yok ayrı olarak cagrilmali 
        usage :
        butceci (
                action_id: invoice_id,
                muhasebe_db:dsn2,
                muhasebe_db_alias : muhasebe_db_alias argumanına deger gonderilmemelidir, muhasebe_db argumanı DSN2'den farklıysa muhasebe_db_alias set ediliyor...
                stock_id: stock_id,
                product_tax:attributes.tax,
                product_otv:attributes.otv,
                invoice_row_id: invoice_row_id,
                is_income_expense: 'false', <!---true:gelir , false:gider--->
                process_type:INVOICE_CAT, 
                nettotal: row_nettotal,
                other_money_gross_total:other_money_value, 
                action_currency:other_money,  islem para cinsi
                expense_date:attributes.INVOICE_DATE
                expense_member_type: , harcama veya satışı yapan tipi employee,partner,consumer
                expense_member_id :  harcama veya satışı yapanın idsi
                expense_date: islem tarihi,
                departmen_id: faturadaki department_id,
                project_id: projeye gore dagilim yapacaksa yollanmali
            );		
        --->
        <cfargument name="muhasebe_db" type="string" default="#dsn2#">
        <cfargument name="muhasebe_db_alias" type="string" default="">
        <cfargument name="action_id" required="yes" type="numeric"><!---işlem idsi--->
        <cfargument name="branch_id">
        <cfargument name="product_id" type="numeric">
        <cfargument name="product_tax" type="numeric" default="0"><!--- kdv orani --->
        <cfargument name="product_otv" type="numeric" default="0"><!--- ötv orani --->
        <cfargument name="product_bsmv" type="numeric" default="0"><!--- bsmv orani --->
        <cfargument name="product_oiv" type="numeric" default="0"><!--- oiv orani --->
        <cfargument name="tevkifat_rate" type="numeric" default="0"><!---  tevkifat orani --->
        <cfargument name="is_income_expense" required="yes" type="boolean" default="false"><!---true:gelir , false:gider --->
        <cfargument name="process_type" required="yes" type="numeric"><!---INVOICE_CAT--->
        <cfargument name="process_cat" type="numeric"><!---işlem kategorisi py--->
        <cfargument name="nettotal" required="yes" type="numeric" default="0"><!--- kdvsiz tutar --->
        <cfargument name="discounttotal" type="numeric" default="0.0"><!--- indirim tutarı --->
        <cfargument name="other_money_value" type="numeric" default="0"><!--- kdvsiz satır dövizli toplam --->
        <cfargument name="discount_other_money_value" type="numeric" default="0.0"><!--- indirim tutarı dövizli toplam --->
        <cfargument name="action_currency" type="string" default=""><!--- işlme para birimi--->
        <cfargument name="action_currency_2" type="string" default="#session.ep.money2#"><!--- sistem 2. dövizi --->
        <cfargument name="expense_member_type" type="string" default=""><!--- harcama yapam --->
        <cfargument name="expense_member_id" type="numeric">
        <cfargument name="company_id" type="string" default="">
        <cfargument name="consumer_id" type="string" default="">
        <cfargument name="employee_id" type="string" default=""><!---20070219 TolgaS bu parametrelerin isini yapması için expense_member_id ve expense_member_type var ken niye eklenmis --->
        <cfargument name="expense_date" type="date" default="#now()#"><!--- işlem tarihi --->
        <cfargument name="department_id" type="numeric" default="0">
        <cfargument name="project_id" type="string" default="">
        <cfargument name="insert_type" type="string" default=""><!---banka vs den gelen işlemler için ayraç --->
        <cfargument name="expense_center_id" type="numeric"><!--- masraf/gelir merkezi --->
        <cfargument name="expense_item_id" type="numeric"><!--- bütçe kalemi --->
        <cfargument name="expense_account_code" type="string"><!--- muhasebe kodu --->
        <cfargument name="detail" type="string" default=""><!--- açıklama --->
        <cfargument name="currency_multiplier" type="string" default=""><!--- sistem 2.döviz kuru --->
        <cfargument name="paper_no" type="string" default="">
        <cfargument name="activity_type" type="string" default=""><!--- aktivite tipi --->
        <cfset budget_data = structnew()>
        <cftry>
            <cfif isdefined("session.pp")>
                <cfset session_base = evaluate('session.pp')>
            <cfelseif isdefined("session.ep")>
                <cfset session_base = evaluate('session.ep')>
            <cfelse>
                <cfset session_base = evaluate('session.ww')>
            </cfif>
            <cfscript>//sistem 2.dövizine göre hesaplama yapılır
                if(not len(arguments.currency_multiplier))
                {
                    get_currency_rate = cfquery(datasource : "#arguments.muhasebe_db#", sqlstring : "SELECT (RATE2/RATE1) RATE FROM #arguments.muhasebe_db_alias#SETUP_MONEY WHERE MONEY ='#session_base.money2#'");
                    if(get_currency_rate.recordcount) arguments.currency_multiplier = get_currency_rate.RATE;
                }
            </cfscript>
            
            <cfset kdv_toplam = (arguments.nettotal*arguments.product_tax)/100>
            <cfset tevkifat_toplam = kdv_toplam*arguments.tevkifat_rate>
            <cfset otv_toplam = (arguments.nettotal*arguments.product_otv)/100>
            <cfset bsmv_toplam = (arguments.nettotal*arguments.product_bsmv)/100>
            <cfset oiv_toplam = (arguments.nettotal*arguments.product_oiv)/100>
            <cfset kdvli_toplam = wrk_round(arguments.nettotal + (kdv_toplam - tevkifat_toplam) + otv_toplam + bsmv_toplam + oiv_toplam)>
            <cfset other_money_kdv = (arguments.other_money_value*arguments.product_tax)/100>
            <cfset other_money_kdv_tevkifat = other_money_kdv*arguments.tevkifat_rate>
            <cfset other_kdvli_toplam = wrk_round(arguments.other_money_value + ( other_money_kdv - other_money_kdv_tevkifat ) + ((arguments.other_money_value*arguments.product_otv)/100) + ((arguments.other_money_value*arguments.product_bsmv)/100) + ((arguments.other_money_value*arguments.product_oiv)/100)) >
            <cfif arguments.is_income_expense><cfset is_income_expense = 1><cfelse><cfset is_income_expense = 0></cfif>
            <cfif isDefined("arguments.currency_multiplier") and len(arguments.currency_multiplier)><cfset other_money_value_2 = wrk_round(arguments.nettotal/arguments.currency_multiplier)><cfelse><cfset other_money_value_2 = ''></cfif>
            <cfif isDefined("arguments.expense_account_code") and Len(arguments.expense_account_code)><cfset expense_account_code = arguments.expense_account_code><cfelse><cfset expense_account_code = ''></cfif>

            <cfset budget_data.expense_date = arguments.expense_date>
            <cfset budget_data.masraf_merkezi_id = arguments.expense_center_id>
            <cfset budget_data.gider_kalemi_id = arguments.expense_item_id>
            <cfset budget_data.expense_account_code = expense_account_code>
            <cfset budget_data.process_type = arguments.process_type>
            <cfset budget_data.detay = arguments.detail>
            <cfset budget_data.is_income_expense = is_income_expense>
            <cfset budget_data.action_id = arguments.action_id>
            <cfset budget_data.toplam = kdvli_toplam>
            <cfset budget_data.para_birimi = arguments.action_currency>
            <cfset budget_data.other_money_value = arguments.other_money_value>
            <cfset budget_data.other_kdvli_toplam = other_kdvli_toplam>
            <cfset budget_data.ikinci_döviz = other_money_value_2>
            <cfset budget_data.ikinci_para_birimi =  session_base.money2>
            <cfset budget_data.paper_no = arguments.paper_no>
            <cfset budget_data.employee_id = arguments.employee_id>
            <cfset budget_data.net_toplam = arguments.nettotal>
            <cfset serializedStrBudget = Replace(SerializeJSON(budget_data),'//','')>
            <cfquery name="upd_payrol_job" datasource="#arguments.muhasebe_db#">
                UPDATE
                    #dsn_alias#.PAYROLL_JOB   
                SET
                    BUDGET_COMPLETED  = <cfqueryparam CFSQLType = "cf_sql_bit" value = "1">,
                    BUDGET_DRAFT = <cfqueryparam CFSQLType = "cf_sql_varchar" value = "#serializedStrBudget#">
                WHERE 
                    EMPLOYEE_PAYROLL_ID = <cfqueryparam CFSQLType = "cf_sql_integer" value = "#arguments.PAYROLL_ID_LIST#">
            </cfquery>
            <cfset return_error = 1>
        <cfcatch type="exception">
            <cfset error_message = structnew()>
            <cfset error_message.message = cfcatch.Message>
            <cfset error_message.line = cfcatch.TagContext[1].LINE>
            <cfset error_message.raw_trace = cfcatch.TagContext[1].RAW_TRACE>
        </cfcatch>
        </cftry>
        <cfreturn return_error>
    </cffunction>


      <!--- Bu fonksiyon yuvarlama işlemi yapar. --->
    <cffunction name="wrk_round" returntype="string" output="false">
        <cfargument name="number" required="true">
        <cfargument name="decimal_count" required="no" default="2">
        <cfargument name="kontrol_float" required="no" default="0"><!--- ürün ağacında çok ufak değerler girildiğinde E- formatında yazılanlar bozulmasın diye eklendi SM20101007 --->
        <cfscript>
            if (not len(arguments.number)) return '';
            if(arguments.kontrol_float eq 0)
            {
                if (arguments.number contains 'E') arguments.number = ReplaceNoCase(NumberFormat(arguments.number), ',', '', 'all');
            }
            else
            {
                if (arguments.number contains 'E') 
                {
                    first_value = listgetat(arguments.number,1,'E-');
                    first_value = ReplaceNoCase(first_value,',','.');
                    last_value = ReplaceNoCase(listgetat(arguments.number,2,'E-'),'0','','all');
                    //if(last_value gt 5) last_value = 5;
                    for(kk_float=1;kk_float lte last_value;kk_float=kk_float+1)
                    {
                        zero_info = ReplaceNoCase(first_value,'.','');
                        first_value = '0.#zero_info#';
                    }
                    arguments.number = first_value;
                            first_value = listgetat(arguments.number,1,'.');
                arguments.number = "#first_value#.#Left(listgetat(arguments.number,2,'.'),8)#";
                    if(arguments.number lt 0.00000001) arguments.number = 0;
                    return arguments.number;
                }
            }
            if (arguments.number contains '-'){
                negativeFlag = 1;
                arguments.number = ReplaceNoCase(arguments.number, '-', '', 'all');}
            else negativeFlag = 0;
            if(not isnumeric(arguments.decimal_count)) arguments.decimal_count= 2;	
            if(Find('.', arguments.number))
            {
                tam = listfirst(arguments.number,'.');
                onda =listlast(arguments.number,'.');
                if(onda neq 0 and arguments.decimal_count eq 0) //yuvarlama sayısı sıfırsa noktadan sonraki ilk rakama gore tam kısımda yuvarlama yapılır
                {
                    if(Mid(onda, 1,1) gte 5) // yuvarlama 
                        tam= tam+1;	
                }
                else if(onda neq 0 and len(onda) gt arguments.decimal_count)
                {
                    if(Mid(onda,arguments.decimal_count+1,1) gte 5) // yuvarlama
                    {
                        onda = Mid(onda,1,arguments.decimal_count);
                        textFormat_new = "0.#onda#";
                        textFormat_new = textFormat_new+1/(10^arguments.decimal_count);
                        
                        decimal_place_holder = '_.';
                        for(decimal_index=1;decimal_index<=arguments.decimal_count;++decimal_index)
                            decimal_place_holder = '#decimal_place_holder#_';
                        textFormat_new = LSNumberFormat(textFormat_new,decimal_place_holder);
                            
                        if(listlen(textFormat_new,'.') eq 2)
                        {
                            tam = tam + listfirst(textFormat_new,'.');
                            onda =listlast(textFormat_new,'.');
                        }
                        else
                        {
                            tam = tam + listfirst(textFormat_new,'.');
                            onda = '';
                        }
                    }
                    else
                        onda= Mid(onda,1,arguments.decimal_count);
                }
            }
            else
            {
                tam = arguments.number;
                onda = '';
            }
            textFormat='';
            if(len(onda) and onda neq 0 and arguments.decimal_count neq 0)
                textFormat = "#tam#.#onda#";
            else
                textFormat = "#tam#";
            if (negativeFlag) textFormat =  "-#textFormat#";
            return textFormat;
        </cfscript>
    </cffunction>
    <cffunction name="TLFormat" returntype="string" output="false">
        <cfargument name="money">
        <cfargument name="no_of_decimal" required="no" default="2">
        <cfargument name="is_round" type="boolean" required="no" default="true">
        <cfscript>
        /*
        notes :
            negatif sayıları algılar, para birimi degerleri icin istenen degeri istenen kadar virgulle geri dondurur,
            ondalikli kisim default olarak yuvarlanir, ancak istenirse is_round false edilerek ondalik kadar kisimdan 
            yuvarlama olmasizin kesilebilir.
        parameters :
            1) money:formatlı yazdırılacak sayı (int veya float)
            2) no_of_decimal:ondalikli hane sayisi (int)
            3) is_round:yuvarlama yapilsin mi (boolean)
        usage : 
            <cfinput type="text" name="total" value="#TLFormat(x)#" validate="float">
            veya
            <cfinput type="text" name="total" value="#TLFormat(-123123.89)#" validate="float">
        revisions :
            20031105 - Temizlendi, uç nokta kontrolleri eklendi
            20031107 - 9 Katrilyon üstü desteği eklendi
            20031209 - 3 haneden küçük sayılar için negatif sayı desteği eklendi
            20041201 - Kurus (decimal) duzeltmeleri yapildi.
            20041201 - Genel duzenleme, kurus duzeltmelerine uygun yuvarlama .
            OZDEN 20070316 - round sorunlarının duzeltilmesi 
        */
        /*if (not len(arguments.money)) return 0;*/
        if (not len(arguments.money)) return '';
        arguments.money = trim(arguments.money);
        if (arguments.money contains 'E') arguments.money = ReplaceNoCase(NumberFormat(arguments.money),',','','all');
        if (arguments.money contains '-'){
            negativeFlag = 1;
            arguments.money = ReplaceNoCase(arguments.money,'-','','all');}
        else negativeFlag = 0;
        if(not isnumeric(arguments.no_of_decimal)) arguments.no_of_decimal= 2;	
        nokta = Find('.', arguments.money);
        if (nokta)
            {
            if(arguments.is_round) /* 20050823 and arguments.no_of_decimal */ 
            {
                rounded_value = CreateObject("java", "java.math.BigDecimal");
                rounded_value.init(arguments.money);
                rounded_value = rounded_value.setScale(arguments.no_of_decimal, rounded_value.ROUND_HALF_UP);
                rounded_value = rounded_value.toString();
                if(rounded_value contains '.') /*10.00 degeri yerine 10 dondurmek icin*/
                {
                    if(listlast(rounded_value,'.') eq 0)
                        rounded_value = listfirst(rounded_value,'.');
                }
                arguments.money = rounded_value;
                if (arguments.money contains 'E') 
                {
                    first_value = listgetat(arguments.money,1,'E-');
                    first_value = ReplaceNoCase(first_value,',','.');
                    last_value = ReplaceNoCase(listgetat(arguments.money,2,'E-'),'0','','all');
                    for(kk_float=1;kk_float lte last_value;kk_float=kk_float+1)
                    {
                        zero_info = ReplaceNoCase(first_value,'.','');
                        first_value = '0.#zero_info#';
                    }
                    arguments.money = first_value;
                    first_value = listgetat(arguments.money,1,'.');
                    arguments.money = "#first_value#.#Left(listgetat(arguments.money,2,'.'),8)#";
                    if(arguments.money lt 0.00000001) arguments.money = 0;
                    if(Find('.', arguments.money))
                    {
                        arguments.money = "#first_value#,#Left(listgetat(arguments.money,2,'.'),8)#";
                        return arguments.money;
                    }
                }
            }
            if(arguments.money neq 0) nokta = Find('.', arguments.money);
            if(ceiling(arguments.money) neq arguments.money){
                tam = ceiling(arguments.money)-1;
                onda = Mid(arguments.money, nokta+1,arguments.no_of_decimal);
                if(len(onda) lt arguments.no_of_decimal)
                    onda = onda & RepeatString(0,arguments.no_of_decimal-len(onda));
                }
            else{
                tam = arguments.money;
                onda = RepeatString(0,arguments.no_of_decimal);}
            }
        else{
            tam = arguments.money;
            onda = RepeatString(0,arguments.no_of_decimal);
            }
        textFormat='';
        t=0;
        if (len(tam) gt 3) 
            {
            for (k=len(tam); k; k=k-1)
                {
                t = t+1;
                if (not (t mod 3)) textFormat = '.' & mid(tam, k, 1) & textFormat; 
                else textFormat = mid(tam, k, 1) & textFormat;
                } 
            if (mid(textFormat, 1, 1) is '.') textFormat =  "#right(textFormat,len(textFormat)-1)#,#onda#";
            else textFormat =  "#textFormat#,#onda#";
            }
        else
            textFormat = "#tam#,#onda#";
            
        if (negativeFlag) textFormat =  "-#textFormat#";
        
        if (not arguments.no_of_decimal) 
            textFormat = ListFirst(textFormat,',');
        
        if(isdefined("moneyformat_style") and moneyformat_style eq 1)
            {
                textFormat = replace(textFormat,'.','*','all');
                textFormat = replace(textFormat,',','.','all');
                textFormat = replace(textFormat,'*',',','all');
            }
        return textFormat;
        </cfscript>
    </cffunction>
    <cffunction name="upd_payrol_job" returntype="boolean" output="false">
        <cfargument  name="employee_payroll_id"><cfargument  name="new_dsn2">
        <cfquery name="upd_payrol_job" datasource="#new_dsn2#">
            UPDATE
                #dsn#.PAYROLL_JOB   
            SET
                ACCOUNT_COMPLETED  = <cfqueryparam CFSQLType = "cf_sql_bit" value = "0">,
                ACCOUNT_DRAFT = NULL
            WHERE 
                EMPLOYEE_PAYROLL_ID = <cfqueryparam CFSQLType = "cf_sql_integer" value = "#arguments.employee_payroll_id#">
        </cfquery> 
        <cfreturn 1>
    </cffunction>
</cfcomponent>