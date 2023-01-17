<!--- Detayli Sistem Analizi Raporu

Created 20060707 Aysenur

	attributes.report_type eq 1 Sistem Bazinda(Bu tip seildiginde alttaki kolonlar ikar istenen kolonlar getirilir,diger type larda sistem sayilarini gruplar)

	attributes.report_dsp_type,1 ye Kategorisi

	attributes.report_dsp_type,2) ye Sirket Byklg

	attributes.report_dsp_type,3)> Iliski Tipi 

	attributes.report_dsp_type,4)> ye Kodu

	attributes.report_dsp_type,5) ye Adi 

	attributes.report_dsp_type,6) Satis Ortagi 

	attributes.report_dsp_type,7) Satis Takimi 

	attributes.report_dsp_type,8) Satis Temsilcisi

	attributes.report_dsp_type,9) Sistem Kategorisi 

	attributes.report_dsp_type,10) Sistem Asamasi 

	attributes.report_dsp_type,11) Sistem Durumu 

	attributes.report_dsp_type,12) Sistem Numarasi 

	attributes.report_dsp_type,13) Sistem Tanimi 

	attributes.report_dsp_type,14)> Özel Kod

	attributes.report_dsp_type,15)> Referans Msteri Kodu 

	attributes.report_dsp_type,16)> Referans Msteri Adi 

	attributes.report_dsp_type,17)> deme Yntemi 

	attributes.report_dsp_type,18)> Szlesme Numarasi 

	attributes.report_dsp_type,19)> Szlesme Tarihi 

	attributes.report_dsp_type,20)> Montaj Tarihi 

	attributes.report_dsp_type,21)> deme Plani Baslangi Tarihi 

	attributes.report_dsp_type,33)> deme Plani Bitis Tarihi 

	attributes.report_dsp_type,22) Prim Tarihi 

	attributes.report_dsp_type,23)> Iptal Tarihi 

	attributes.report_dsp_type,24)> Iptal Nedeni 

	attributes.report_dsp_type,25)> Aiklama

	attributes.report_dsp_type,26)> Sistem Kullanim Sresi

	attributes.report_dsp_type,27)> Satis ortagi komisyonu

  attributes.report_dsp_type,28-29-30-31-32-39-40-41-42-43)> ek bilgiler
  
  attributes.report_dsp_type,44)> Abone Özel Tanım

  attributes.report_dsp_type,45)> Üye Özel Kod

	attributes.report_type eq 2 Satis Takimi Bazinda

	attributes.report_type eq 3 Satis Temsilcisi Bazinda

	attributes.report_type eq 4 Sistem Kategorisi Bazinda

	attributes.report_type eq 5 Sistem Asamasi Bazinda

	attributes.report_type eq 6 K.ye Kategorisi Bazinda

	attributes.report_type eq 7 B.ye Kategorisi Bazinda

	attributes.report_type eq 8 deme Tipi

	attributes.report_type eq 9 K.Iliski Tipi Bazinda

	attributes.report_type eq 10 B.Iliski Tipi Bazinda

	attributes.report_type eq 11 Iptal Nedeni Bazinda

	attributes.report_type eq 12 Iptal Tarihi Bazinda

	attributes.report_type eq 13 Szlesme Tarihi Bazinda

	attributes.report_type eq 14 deme Plani Tarihi Bazinda

	attributes.report_type eq 15 Montaj Tarihi Bazinda

	attributes.report_type eq 16 rn Bazinda

 --->
 <cfparam name="attributes.module_id_control" default="11">
 <cfsetting showdebugoutput="yes">
 <cfinclude template="report_authority_control.cfm">
 <cf_xml_page_edit fuseact="report.system_analyse_report">
 <cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
 <cfparam name="attributes.pos_code" default="">
 <cfparam name="attributes.pos_code_text" default="">
 <cfparam name="attributes.date1" default="">
 <cfparam name="attributes.date2" default="">
 <cfparam name="attributes.date1_m" default="">
 <cfparam name="attributes.date2_m" default="">
 <cfparam name="attributes.date1_o" default="">
 <cfparam name="attributes.date2_o" default="">
 <cfparam name="attributes.date3_o" default="">
 <cfparam name="attributes.date4_o" default="">
 <cfparam name="attributes.date1_p" default="">
 <cfparam name="attributes.date2_p" default="">
 <cfparam name="attributes.date1_i" default="">
 <cfparam name="attributes.date2_i" default="">
 <cfparam name="attributes.ch_date_1" default="">
 <cfparam name="attributes.ch_date_2" default="">
 <cfparam name="attributes.report_type" default="1">
 <cfparam name="attributes.resource_id" default="">
 <cfparam name="attributes.report_dsp_type" default="">
 <cfparam name="attributes.comp_cat" default="">
 <cfparam name="attributes.cons_cat" default="">
 <cfparam name="attributes.size_id" default="">
 <cfparam name="attributes.company" default="">
 <cfparam name="attributes.company_id" default="">
 <cfparam name="attributes.consumer_id" default="">
 <cfparam name="attributes.i_company" default="">
 <cfparam name="attributes.i_company_id" default="">
 <cfparam name="attributes.i_consumer_id" default="">
 <cfparam name="attributes.subscription_type" default="">
 <cfparam name="attributes.process_stage_type" default="">
 <cfparam name="attributes.status" default="">
 <cfparam name="attributes.status_p" default="">
 <cfparam name="attributes.keyword_no" default="">
 <cfparam name="attributes.payment_type" default="">
 <cfparam name="attributes.sozlesme_no" default="">
 <cfparam name="attributes.detail" default="">
 <cfparam name="attributes.cancel_type" default="">
 <cfparam name="attributes.report_sort_type" default="">
 <cfparam name="attributes.sale_add_option" default="">
 <cfparam name="attributes.subs_add_option" default="">
 <cfparam name="attributes.sales_partner" default="">
 <cfparam name="attributes.sales_zones" default="">
 <cfparam name="attributes.is_excel" default="">
 <cfparam name="attributes.graph_type" default="">
 <cfparam name="attributes.use_efatura" default="">
 <!--- 20190927 abone kategorsine göre yetkilendirme için include edildiği sayfada çekilmiş olabilir bu nedenle kontrol ekledik Author: Tolga Sütlü, Ahmet Yolcu--->
 <cfset gsa = createObject("component","V16.objects.cfc.subscriptionNauthority")/>
 <cfset GET_SUBSCRIPTION_AUTHORITY= gsa.SelectAuthority()/>
 <cfset GET_SUBSCRIPTION_TYPE= gsa.SelectSubscription()/>
 
 <cfquery name="GET_MONEY" datasource="#dsn2#">
 SELECT 
   MONEY,
   RATE1,RATE2 
 FROM 
   SETUP_MONEY 
 WHERE 
   MONEY_STATUS = 1
 <cfif session.ep.period_year gt 2008>
 UNION ALL
   SELECT TOP 1
     'YTL',1,1
   FROM
     SETUP_MONEY
   <cfelse>
 UNION ALL
   SELECT TOP 1
     'TL',1,1
  FROM
    SETUP_MONEY
 </cfif>
 </cfquery>
 <cfoutput query="GET_MONEY">
   <cfset 'rafe_info_#MONEY#'=(RATE2/RATE1)>
 </cfoutput>
 <cfif len(session.ep.money2)>
   <cfquery name="GET_MONEY2" dbtype="query">
 SELECT * FROM get_money WHERE MONEY = '#session.ep.money2#'
   </cfquery>
 </cfif>
 <cfset report_type_text = "">
 <cfset sistem_toplam_sayisi = 0>
 <cfset colspan_info = 0>
 <cfif isdefined("attributes.form_submitted")>
   <cfif isdate(attributes.date1)>
     <cf_date tarih = "attributes.date1">
   </cfif>
   <cfif isdate(attributes.date2)>
     <cf_date tarih = "attributes.date2">
   </cfif>
   <cfif isdate(attributes.date1_m)>
     <cf_date tarih = "attributes.date1_m">
   </cfif>
   <cfif isdate(attributes.date2_m)>
     <cf_date tarih = "attributes.date2_m">
   </cfif>
   <cfif isdate(attributes.date1_o)>
     <cf_date tarih = "attributes.date1_o">
   </cfif>
   <cfif isdate(attributes.date2_o)>
     <cf_date tarih = "attributes.date2_o">
   </cfif>
   <cfif isdate(attributes.date3_o)>
     <cf_date tarih = "attributes.date3_o">
   </cfif>
   <cfif isdate(attributes.date4_o)>
     <cf_date tarih = "attributes.date4_o">
   </cfif>
   <cfif isdate(attributes.date1_p)>
     <cf_date tarih = "attributes.date1_p">
   </cfif>
   <cfif isdate(attributes.date2_p)>
     <cf_date tarih = "attributes.date2_p">
   </cfif>
   <cfif isdate(attributes.date1_i)>
     <cf_date tarih = "attributes.date1_i">
   </cfif>
   <cfif isdate(attributes.date2_i)>
     <cf_date tarih = "attributes.date2_i">
   </cfif>
   <cfif isdate(attributes.ch_date_1)>
     <cf_date tarih = "attributes.ch_date_1">
   </cfif>
   <cfif isdate(attributes.ch_date_2)>
     <cf_date tarih = "attributes.ch_date_2">
   </cfif>
   <cfif len(attributes.report_type)>
     <cfquery name="get_total_purchase" datasource="#dsn3#" cachedwithin="#fusebox.general_cached_time#">
         SELECT
             <cfif attributes.report_type eq 1>
             SC.*,
              SETUP_SUBSCRIPTION_ADD_OPTIONS.SUBSCRIPTION_ADD_OPTION_NAME
               <!--- simdlk yazdm degistircem --->
                 <cfif listfind(attributes.report_dsp_type,36)>
                 ,(
                     SELECT
                         SUM(N_TOTAL)
                     FROM
                     (
                     SELECT 
                         DISTINCT I.INVOICE_ID,
                         I.NETTOTAL AS N_TOTAL
                         FROM 
                         SUBSCRIPTION_PAYMENT_PLAN_ROW SPPR,
                         #dsn2_alias#.INVOICE I
                     WHERE
                         SPPR.SUBSCRIPTION_ID = SC.SUBSCRIPTION_ID AND
                         I.INVOICE_ID = SPPR.INVOICE_ID AND 
                         SPPR.IS_BILLED = 1 AND IS_PAID = 0
                         <cfif len(attributes.ch_date_1) and len(attributes.ch_date_2)>
                             AND SPPR.PAYMENT_DATE BETWEEN #attributes.ch_date_1# AND #attributes.ch_date_2#
                         <cfelseif len(attributes.ch_date_1)>
                           AND SPPR.PAYMENT_DATE >= #attributes.ch_date_1#
                         <cfelseif len(attributes.ch_date_2)>
                           AND SPPR.PAYMENT_DATE <= #attributes.ch_date_2#
                         </cfif>
                 ) T1
                 ) INVOICE_TOTAL
                 </cfif>
               <cfif listfind(attributes.report_dsp_type,37)>
         ,(
               SELECT 
                  COUNT(DISTINCT SPPR.INVOICE_ID) 
               FROM 
                 SUBSCRIPTION_PAYMENT_PLAN_ROW SPPR 
               WHERE
                 SPPR.SUBSCRIPTION_ID = SC.SUBSCRIPTION_ID 
               AND SPPR.IS_BILLED = 1 AND IS_PAID = 0
                 <cfif len(attributes.ch_date_1) and len(attributes.ch_date_2)>
                      AND SPPR.PAYMENT_DATE BETWEEN #attributes.ch_date_1# AND #attributes.ch_date_2#
                 <cfelseif len(attributes.ch_date_1)>
                      AND SPPR.PAYMENT_DATE >= #attributes.ch_date_1#
                 <cfelseif len(attributes.ch_date_2)>
                     AND SPPR.PAYMENT_DATE <= #attributes.ch_date_2#
                 </cfif>
                 ) INVOICE_COUNT
               </cfif>
               <cfelseif attributes.report_type eq 2>
               <!--- satis takimi bazinda --->
                   COUNT(SC.SALES_EMP_ID) SYSTEM_SAYISI,
                   STP.TEAM_NAME REPORT_GROUP_TYPE
               <cfelseif attributes.report_type eq 3>
               <!--- satis temsilcisi bazinda --->
                   COUNT(SC.SALES_EMP_ID) SYSTEM_SAYISI,
                   STP.EMPLOYEE_NAME + ' ' + STP.EMPLOYEE_SURNAME REPORT_GROUP_TYPE
               <cfelseif attributes.report_type eq 4>
               <!--- sistem kategorisi --->
                   COUNT(SC.SUBSCRIPTION_TYPE_ID) SYSTEM_SAYISI,
                   STP.SUBSCRIPTION_TYPE REPORT_GROUP_TYPE
               <cfelseif attributes.report_type eq 5>
               <!--- sistem asamasi --->
                   COUNT(SC.SUBSCRIPTION_STAGE) SYSTEM_SAYISI,
                   STP.STAGE REPORT_GROUP_TYPE
               <cfelseif attributes.report_type eq 6>
                   <!--- kurumsal ye kategorisi --->
                   COUNT(SC.COMPANY_ID) SYSTEM_SAYISI,
                   STP.COMPANYCAT REPORT_GROUP_TYPE
               <cfelseif attributes.report_type eq 7>
               <!--- bireysel ye kategorisi --->
                   COUNT(SC.CONSUMER_ID) SYSTEM_SAYISI,
                   STP.CONSCAT REPORT_GROUP_TYPE
               <cfelseif attributes.report_type eq 8>
               <!--- deme tipi --->
                   COUNT(SC.PAYMENT_TYPE_ID) SYSTEM_SAYISI,
                   STP.PAYMETHOD REPORT_GROUP_TYPE
               <cfelseif attributes.report_type eq 9>
               <!--- kurumsal iliski tipi --->
                   COUNT(SC.COMPANY_ID) SYSTEM_SAYISI,
                   STP.RESOURCE REPORT_GROUP_TYPE
               <cfelseif attributes.report_type eq 10>
               <!--- bireysel iliski tipi --->
                   COUNT(SC.CONSUMER_ID) SYSTEM_SAYISI,
                   STP.RESOURCE REPORT_GROUP_TYPE
               <cfelseif attributes.report_type eq 11>
               <!--- iptal nedeni tipi --->
                   COUNT(SC.CANCEL_TYPE_ID) SYSTEM_SAYISI,
                   STP.SUBSCRIPTION_CANCEL_TYPE REPORT_GROUP_TYPE
               <cfelseif attributes.report_type eq 12>
               <!--- iptal nedeni tipi --->
                   COUNT(SC.CANCEL_DATE) SYSTEM_SAYISI,
                   SC.CANCEL_DATE REPORT_GROUP_TYPE
               <cfelseif attributes.report_type eq 13>
               <!--- szlesme tarihi --->
                   COUNT(SC.START_DATE) SYSTEM_SAYISI,
                   SC.START_DATE REPORT_GROUP_TYPE
               <cfelseif attributes.report_type eq 14>
               <!--- demeplani baslangic tarihi --->
                   COUNT(STP.PAY_DATE_TYPE) SYSTEM_SAYISI,
                   STP.PAY_DATE_TYPE REPORT_GROUP_TYPE
               <cfelseif attributes.report_type eq 15>
               <!--- montaj tarihi --->
                   COUNT(SC.MONTAGE_DATE) SYSTEM_SAYISI,
                   SC.MONTAGE_DATE REPORT_GROUP_TYPE
               <cfelseif attributes.report_type eq 16>
               <!--- ürün --->
                  STP.*,      
                   SC.*,
                  (SM.RATE2*STP.PRICE_OTHER) ACTIVE_VALUE
             </cfif>
             <cfif attributes.report_type eq 14>
                 FROM     
                     (    
                     SELECT     
                     MIN(SUBS_P.PAYMENT_DATE) PAY_DATE_TYPE,        
                     SUBS_P.SUBSCRIPTION_ID    
                     FROM    
                     SUBSCRIPTION_PAYMENT_PLAN_ROW SUBS_P   
                     GROUP BY    
                     SUBS_P.SUBSCRIPTION_ID    
                     ) STP,    
                     SUBSCRIPTION_CONTRACT SC
               <cfelse>
                   FROM
                      SUBSCRIPTION_CONTRACT SC
             </cfif>
             LEFT JOIN SETUP_SUBSCRIPTION_ADD_OPTIONS
             ON SC.SUBSCRIPTION_ADD_OPTION_ID = SETUP_SUBSCRIPTION_ADD_OPTIONS.SUBSCRIPTION_ADD_OPTION_ID
             <cfif attributes.report_type eq 2>
             ,#dsn_alias#.EMPLOYEE_POSITIONS EMP
             ,#dsn_alias#.SALES_ZONES_TEAM STP
             ,#dsn_alias#.SALES_ZONES_TEAM_ROLES STPR
               <cfelseif attributes.report_type eq 3>
               ,#dsn_alias#.EMPLOYEES STP
               <cfelseif attributes.report_type eq 4>
               ,SETUP_SUBSCRIPTION_TYPE STP
               <cfelseif attributes.report_type eq 5>
               ,#dsn_alias#.PROCESS_TYPE_ROWS STP
               <cfelseif attributes.report_type eq 6>
               ,#dsn_alias#.COMPANY_CAT STP
               
               ,#dsn_alias#.COMPANY C
               <cfelseif attributes.report_type eq 7>
               ,#dsn_alias#.CONSUMER_CAT STP
               
               ,#dsn_alias#.CONSUMER C
               <cfelseif attributes.report_type eq 8>
               ,#dsn_alias#.SETUP_PAYMETHOD STP
               <cfelseif attributes.report_type eq 9>
               ,#dsn_alias#.COMPANY_PARTNER_RESOURCE STP
               
               ,#dsn_alias#.COMPANY C
               <cfelseif attributes.report_type eq 10>
               ,#dsn_alias#.COMPANY_PARTNER_RESOURCE STP
               
               ,#dsn_alias#.CONSUMER C
               <cfelseif attributes.report_type eq 11>
               ,SETUP_SUBSCRIPTION_CANCEL_TYPE STP
               <cfelseif attributes.report_type eq 12>
               ,SETUP_SUBSCRIPTION_CANCEL_TYPE STP
               <cfelseif attributes.report_type eq 16>
               ,SUBSCRIPTION_CONTRACT_ROW STP
               
               ,#dsn2_alias#.SETUP_MONEY SM
             </cfif>
             WHERE
             SC.SUBSCRIPTION_ID IS NOT NULL
             <cfif attributes.report_type eq 2>
                 AND STP.TEAM_ID = STPR.TEAM_ID
                 AND STPR.POSITION_CODE = EMP.POSITION_CODE
                 AND SC.SALES_EMP_ID = EMP.EMPLOYEE_ID
             <cfelseif attributes.report_type eq 3>
               AND SC.SALES_EMP_ID = STP.EMPLOYEE_ID
             <cfelseif attributes.report_type eq 4>
               AND SC.SUBSCRIPTION_TYPE_ID = STP.SUBSCRIPTION_TYPE_ID
             <cfelseif attributes.report_type eq 5>
               AND SC.SUBSCRIPTION_STAGE = STP.PROCESS_ROW_ID
             <cfelseif attributes.report_type eq 6>
               AND C.COMPANYCAT_ID = STP.COMPANYCAT_ID
               
               AND SC.COMPANY_ID = C.COMPANY_ID
               <cfelseif attributes.report_type eq 7>
               AND C.CONSUMER_CAT_ID = STP.CONSCAT_ID
               
               AND SC.CONSUMER_ID = C.CONSUMER_ID
               <cfelseif attributes.report_type eq 8>
               AND SC.PAYMENT_TYPE_ID = STP.PAYMETHOD_ID
               <cfelseif attributes.report_type eq 9>
               AND C.RESOURCE_ID = STP.RESOURCE_ID
               
               AND SC.COMPANY_ID = C.COMPANY_ID
               <cfelseif attributes.report_type eq 10>
               AND C.RESOURCE_ID = STP.RESOURCE_ID
               
               AND SC.CONSUMER_ID = C.CONSUMER_ID
               <cfelseif attributes.report_type eq 11>
               AND SC.CANCEL_TYPE_ID = STP.SUBSCRIPTION_CANCEL_TYPE_ID
               <cfelseif attributes.report_type eq 12>
               AND SC.CANCEL_TYPE_ID = STP.SUBSCRIPTION_CANCEL_TYPE_ID
               <cfelseif attributes.report_type eq 14>
               AND SC.SUBSCRIPTION_ID = STP.SUBSCRIPTION_ID
               <cfelseif attributes.report_type eq 16>
               AND SC.SUBSCRIPTION_ID = STP.SUBSCRIPTION_ID
               <cfif session.ep.period_year lt 2009>
         AND ((STP.OTHER_MONEY = 'TL' AND SM.MONEY = 'YTL') OR SM.MONEY = STP.OTHER_MONEY)
                 <cfelse>
                 AND ((STP.OTHER_MONEY = 'YTL' AND SM.MONEY = 'TL') OR SM.MONEY = STP.OTHER_MONEY)
               </cfif>
             </cfif>
             <cfif isDefined("attributes.comp_cat") and len(attributes.comp_cat)>
         AND SC.COMPANY_ID IN (SELECT COMPANY_ID FROM #dsn_alias#.COMPANY WHERE COMPANYCAT_ID IN (#attributes.comp_cat#))
             </cfif>
             <cfif isDefined("attributes.cons_cat") and len(attributes.cons_cat)>
         AND SC.CONSUMER_ID IN (SELECT CONSUMER_ID FROM #dsn_alias#.CONSUMER WHERE CONSUMER_CAT_ID IN (#attributes.cons_cat#))
             </cfif>
             <cfif isDefined("attributes.size_id") and len(attributes.size_id)>
         AND   
             (
             SC.COMPANY_ID IN (SELECT COMPANY_ID FROM #dsn_alias#.COMPANY WHERE COMPANY_SIZE_CAT_ID IN (#attributes.size_id#)) OR   
             SC.CONSUMER_ID IN (SELECT CONSUMER_ID FROM #dsn_alias#.CONSUMER WHERE COMPANY_SIZE_CAT_ID IN (#attributes.size_id#))    
             )
             </cfif>
             <cfif len(attributes.company) and len(attributes.company_id)>
         AND SC.COMPANY_ID=	#attributes.company_id#
             </cfif>
             <cfif len(attributes.company) and len(attributes.consumer_id)>
         AND SC.CONSUMER_ID = #attributes.consumer_id#
             </cfif>
             <cfif len(attributes.use_efatura)>
                 AND (SC.INVOICE_COMPANY_ID IN (SELECT COMPANY_ID FROM #dsn_alias#.COMPANY WHERE USE_EFATURA = #attributes.use_efatura#)
                 OR SC.INVOICE_CONSUMER_ID IN (SELECT CONSUMER_ID FROM #dsn_alias#.CONSUMER WHERE USE_EFATURA = #attributes.use_efatura#)) 
             </cfif>
             <cfif len(attributes.i_company) and len(attributes.i_company_id)>
         AND SC.INVOICE_COMPANY_ID =	#attributes.i_company_id#
             </cfif>
             <cfif len(attributes.i_company) and len(attributes.i_consumer_id)>
         AND SC.INVOICE_CONSUMER_ID = #attributes.i_consumer_id#
             </cfif>
             <cfif isDefined("attributes.resource_id") and len(attributes.resource_id)>
         AND    
             (    
             SC.COMPANY_ID IN (SELECT COMPANY_ID FROM #dsn_alias#.COMPANY WHERE RESOURCE_ID IN (#attributes.resource_id#)) OR    
             SC.CONSUMER_ID IN (SELECT CONSUMER_ID FROM #dsn_alias#.CONSUMER WHERE RESOURCE_ID IN (#attributes.resource_id#))    
             )
             </cfif>
             <cfif len(attributes.pos_code) and len(attributes.pos_code_text)>
         AND SC.SALES_EMP_ID = #attributes.pos_code#
             </cfif>
             <cfif isDefined("attributes.subscription_type") and len(attributes.subscription_type)>
         AND SC.SUBSCRIPTION_TYPE_ID IN (#attributes.subscription_type#)
             </cfif>
             <cfif isDefined("attributes.sales_partner") and len(attributes.sales_partner) and len(attributes.sales_partner_id)>
         AND SC.SALES_PARTNER_ID = #attributes.sales_partner_id#
             </cfif>
             <cfif len(attributes.process_stage_type) and len(attributes.process_stage_type)>
         AND SC.SUBSCRIPTION_STAGE IN (#attributes.process_stage_type#)
             </cfif>
             <cfif isdefined("attributes.status") and len(attributes.status)>
         AND SC.IS_ACTIVE = #attributes.status#
             </cfif>
             <cfif isdefined("attributes.status_p") and attributes.status_p eq 1>
         AND SC.CANCEL_TYPE_ID IS NOT NULL
             </cfif>
             <cfif isdefined("attributes.status_p") and attributes.status_p eq 0>
         AND SC.CANCEL_TYPE_ID IS NULL
             </cfif>
             <cfif isdefined("attributes.status_p") and attributes.status_p eq 2>
         AND    
             (   
             SC.CANCEL_TYPE_ID IS NULL OR   
             SC.CANCEL_TYPE_ID IS NOT NULL    
             )
             </cfif>
             <cfif isdefined("attributes.keyword_no") and len(attributes.keyword_no)>
         AND    
             (   
             SC.SUBSCRIPTION_NO = '#attributes.keyword_no#' OR    
             SC.SPECIAL_CODE = '#attributes.keyword_no#'    
             )
             </cfif>
             <cfif isdefined("attributes.payment_type") and len(attributes.payment_type)>
         AND SC.PAYMENT_TYPE_ID IN (#attributes.payment_type#)
             </cfif>
             <cfif isdefined("attributes.sozlesme_no") and len(attributes.sozlesme_no)>
         AND SC.CONTRACT_NO = '#attributes.sozlesme_no#'
             </cfif>
             <cfif len(attributes.date1) and len(attributes.date2)>
         AND SC.START_DATE BETWEEN #attributes.date1# AND #attributes.date2#
               <cfelseif len(attributes.date1)>
               AND SC.START_DATE >= #attributes.date1#
               <cfelseif len(attributes.date2)>
               AND SC.START_DATE <= #attributes.date2#
             </cfif>
             <cfif len(attributes.date1_m) and len(attributes.date2_m)>
         AND SC.MONTAGE_DATE BETWEEN #attributes.date1_m# AND #attributes.date2_m#
               <cfelseif len(attributes.date1_m)>
               AND SC.MONTAGE_DATE >= #attributes.date1_m#
               <cfelseif len(attributes.date2_m)>
               AND SC.MONTAGE_DATE <= #attributes.date2_m#
             </cfif>
             <cfif len(attributes.date1_o) and len(attributes.date2_o)>
         AND SC.SUBSCRIPTION_ID IN (SELECT SUBSCRIPTION_ID FROM SUBSCRIPTION_PAYMENT_PLAN_ROW GROUP BY SUBSCRIPTION_ID HAVING MIN(PAYMENT_DATE) BETWEEN #attributes.date1_o# AND #attributes.date2_o#)
               <cfelseif len(attributes.date1_o)>
               AND SC.SUBSCRIPTION_ID IN (SELECT SUBSCRIPTION_ID FROM SUBSCRIPTION_PAYMENT_PLAN_ROW GROUP BY SUBSCRIPTION_ID HAVING MIN(PAYMENT_DATE) >= #attributes.date1_o#)
               <cfelseif len(attributes.date2_o)>
               AND SC.SUBSCRIPTION_ID IN (SELECT SUBSCRIPTION_ID FROM SUBSCRIPTION_PAYMENT_PLAN_ROW GROUP BY SUBSCRIPTION_ID HAVING MIN(PAYMENT_DATE) <= #attributes.date2_o#)
             </cfif>
             <cfif len(attributes.date3_o) and len(attributes.date4_o)>
         AND SC.SUBSCRIPTION_ID IN (SELECT SUBSCRIPTION_ID FROM SUBSCRIPTION_PAYMENT_PLAN_ROW GROUP BY SUBSCRIPTION_ID HAVING MAX(PAYMENT_DATE) BETWEEN #attributes.date3_o# AND #attributes.date4_o#)
               <cfelseif len(attributes.date3_o)>
               AND SC.SUBSCRIPTION_ID IN (SELECT SUBSCRIPTION_ID FROM SUBSCRIPTION_PAYMENT_PLAN_ROW GROUP BY SUBSCRIPTION_ID HAVING MAX(PAYMENT_DATE) >= #attributes.date3_o#)
               <cfelseif len(attributes.date4_o)>
               AND SC.SUBSCRIPTION_ID IN (SELECT SUBSCRIPTION_ID FROM SUBSCRIPTION_PAYMENT_PLAN_ROW GROUP BY SUBSCRIPTION_ID HAVING MAX(PAYMENT_DATE) <= #attributes.date4_o#)
             </cfif>
             <cfif len(attributes.date1_p) and len(attributes.date2_p)>
         AND SC.PREMIUM_DATE BETWEEN #attributes.date1_p# AND #attributes.date2_p#
               <cfelseif len(attributes.date1_p)>
               AND SC.PREMIUM_DATE >= #attributes.date1_p#
               <cfelseif len(attributes.date2_p)>
               AND SC.PREMIUM_DATE <= #attributes.date2_p#
             </cfif>
             <cfif len(attributes.date1_i) and len(attributes.date2_i)>
         AND SC.CANCEL_DATE BETWEEN #attributes.date1_i# AND #attributes.date2_i#
               <cfelseif len(attributes.date1_i)>
               AND SC.CANCEL_DATE >= #attributes.date1_i#
               <cfelseif len(attributes.date2_i)>
               AND SC.CANCEL_DATE <= #attributes.date2_i#
             </cfif>
             <cfif isdefined("attributes.cancel_type") and len(attributes.cancel_type)>
         AND SC.CANCEL_TYPE_ID IN (#attributes.cancel_type#)
             </cfif>
             <cfif isdefined("attributes.detail") and len(attributes.detail)>
         AND SC.SUBSCRIPTION_DETAIL LIKE '%#attributes.detail#%'
             </cfif>
             <cfif isdefined("attributes.sale_add_option") and len(attributes.sale_add_option)>
         AND    
             (    
             SC.SALES_ADD_OPTION_ID IN (#attributes.sale_add_option#)
               <cfif listfind(attributes.sale_add_option,"0",',')>
         OR SC.SALES_ADD_OPTION_ID IS NULL
               </cfif>
               )
             </cfif>
             <cfif isdefined("attributes.subs_add_option") and len(attributes.subs_add_option)>
         AND    
             (    
             SC.SUBSCRIPTION_ADD_OPTION_ID IN (#attributes.subs_add_option#)
               <cfif listfind(attributes.subs_add_option,"0",',')>
         OR SC.SUBSCRIPTION_ADD_OPTION_ID IS NULL
               </cfif>
               )
             </cfif>
             <cfif isdefined("attributes.sales_zones") and len(attributes.sales_zones)>
         AND SC.SALES_EMP_ID IN    
             (SELECT   
             EMP.EMPLOYEE_ID    
             FROM    
             #dsn_alias#.SALES_ZONES_TEAM_ROLES SZT,    
             #dsn_alias#.EMPLOYEE_POSITIONS EMP    
             WHERE    
             SZT.POSITION_CODE = EMP.POSITION_CODE AND    
             SZT.TEAM_ID IN (#attributes.sales_zones#)    
             )
             </cfif>
             <cfif isdefined("attributes.ref_member_type") AND len(attributes.ref_member_type) and attributes.ref_member_type is 'Partner' and isdefined("attributes.ref_member_name") and len(attributes.ref_member_name) and isdefined("attributes.ref_company_id") and len(attributes.ref_company_id)>
              AND SC.REF_COMPANY_ID = #attributes.ref_company_id#
            <cfelseif isdefined("attributes.ref_member_type") AND len(attributes.ref_member_type) and attributes.ref_member_type is 'Consumer' and isdefined("attributes.ref_member_name") and len(attributes.ref_member_name) and isdefined("attributes.ref_consumer_id") and len(attributes.ref_consumer_id)>
              AND SC.REF_CONSUMER_ID = #attributes.ref_consumer_id#
            </cfif>
             <cfif get_subscription_authority.IS_SUBSCRIPTION_AUTHORITY eq 1>
               AND EXISTS 
                 (
                   SELECT
                   SPC.SUBSCRIPTION_TYPE_ID
                   FROM        
                   #dsn#.EMPLOYEE_POSITIONS AS EP,
                   SUBSCRIPTION_GROUP_PERM SPC
                   WHERE
                   EP.POSITION_CODE = #session.ep.position_code# AND
                   (
                     SPC.POSITION_CODE = EP.POSITION_CODE OR
                     SPC.POSITION_CAT = EP.POSITION_CAT_ID
                   )
                     AND SC.SUBSCRIPTION_TYPE_ID = spc.SUBSCRIPTION_TYPE_ID
                 )
             </cfif>
             <cfif not listfind("1,16",attributes.report_type)>
         GROUP BY
               <cfif attributes.report_type eq 2>
         STP.TEAM_NAME
                 <cfelseif attributes.report_type eq 3>
                 STP.EMPLOYEE_NAME + ' ' + STP.EMPLOYEE_SURNAME
                 <cfelseif attributes.report_type eq 4>
                 STP.SUBSCRIPTION_TYPE
                 <cfelseif attributes.report_type eq 5>
                 STP.STAGE
                 <cfelseif attributes.report_type eq 6>
                 STP.COMPANYCAT
                 <cfelseif attributes.report_type eq 7>
                 STP.CONSCAT
                 <cfelseif attributes.report_type eq 8>
                 STP.PAYMETHOD
                 <cfelseif attributes.report_type eq 9>
                 STP.RESOURCE
                 <cfelseif attributes.report_type eq 10>
                 STP.RESOURCE
                 <cfelseif attributes.report_type eq 11>
                 STP.SUBSCRIPTION_CANCEL_TYPE
                 <cfelseif attributes.report_type eq 12>
                 SC.CANCEL_DATE
                 <cfelseif attributes.report_type eq 13>
                 SC.START_DATE
                 <cfelseif attributes.report_type eq 14>
                 STP.PAY_DATE_TYPE
                 <cfelseif attributes.report_type eq 15>
                 SC.MONTAGE_DATE
               </cfif>
             </cfif>
       <cfif listfind("1,16",attributes.report_type) and attributes.report_sort_type eq 1>
                 ORDER BY SC.START_DATE
             <cfelseif listfind("1,16",attributes.report_type) and attributes.report_sort_type eq 2>
                 ORDER BY SC.SUBSCRIPTION_NO
             <cfelseif attributes.report_type eq 6 and attributes.report_sort_type eq 3>
                 ORDER BY STP.COMPANYCAT
             <cfelse>
         <!--- ORDER BY SC.SUBSCRIPTION_ID --->
             </cfif>
     </cfquery>
   </cfif>
   <cfelse>
   <cfset get_total_purchase.recordcount=0>
 </cfif>
 <cfif isdate(attributes.date1)>
   <cfset attributes.date1 = dateformat(attributes.date1, dateformat_style)>
 </cfif>
 <cfif isdate(attributes.date2)>
   <cfset attributes.date2 = dateformat(attributes.date2, dateformat_style)>
 </cfif>
 <cfif isdate(attributes.date1_m)>
   <cfset attributes.date1_m = dateformat(attributes.date1_m, dateformat_style)>
 </cfif>
 <cfif isdate(attributes.date2_m)>
   <cfset attributes.date2_m = dateformat(attributes.date2_m, dateformat_style)>
 </cfif>
 <cfif isdate(attributes.date1_o)>
   <cfset attributes.date1_o = dateformat(attributes.date1_o, dateformat_style)>
 </cfif>
 <cfif isdate(attributes.date2_o)>
   <cfset attributes.date2_o = dateformat(attributes.date2_o, dateformat_style)>
 </cfif>
 <cfif isdate(attributes.date3_o)>
   <cfset attributes.date3_o = dateformat(attributes.date3_o, dateformat_style)>
 </cfif>
 <cfif isdate(attributes.date4_o)>
   <cfset attributes.date4_o = dateformat(attributes.date4_o, dateformat_style)>
 </cfif>
 <cfif isdate(attributes.date1_p)>
   <cfset attributes.date1_p = dateformat(attributes.date1_p, dateformat_style)>
 </cfif>
 <cfif isdate(attributes.date2_p)>
   <cfset attributes.date2_p = dateformat(attributes.date2_p, dateformat_style)>
 </cfif>
 <cfif isdate(attributes.date1_i)>
   <cfset attributes.date1_i = dateformat(attributes.date1_i, dateformat_style)>
 </cfif>
 <cfif isdate(attributes.date2_i)>
   <cfset attributes.date2_i = dateformat(attributes.date2_i, dateformat_style)>
 </cfif>
 
 
 <cfquery name="GET_SERVICE_STAGE" datasource="#DSN#">
     SELECT
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
         PTO.OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#">
         AND PT.FACTION LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%sales.list_subscription_contract%">
   ORDER BY
     PTR.LINE_NUMBER
 </cfquery>
 <cfform name="rapor" action="#request.self#?fuseaction=report.system_analyse_report" method="post">
 <cf_report_list_search title="#getLang('report',850)#">
 <cf_report_list_search_area>
   <div class="row">
     <div class="col col-12 col-xs-12">
       <div class="row formContent">
         <div class="row" type="row">
           <div class="col col-3 col-md-4 col-sm-6 col-xs-12">
             <div class="form-group">
                 <label class="col col-12 col-xs-12"><cf_get_lang_main no='1413.Iptal Nedeni'></label>
               <div class="col col-12 col-xs-12">
                     <cfquery name="get_cancel_type" datasource="#dsn3#">
                         SELECT SUBSCRIPTION_CANCEL_TYPE,SUBSCRIPTION_CANCEL_TYPE_ID FROM SETUP_SUBSCRIPTION_CANCEL_TYPE ORDER BY SUBSCRIPTION_CANCEL_TYPE
                     </cfquery>
                     <select name="cancel_type" id="cancel_type" multiple>
                       <cfoutput query="get_cancel_type">
                         <option value="#SUBSCRIPTION_CANCEL_TYPE_ID#" <cfif listfind(attributes.cancel_type,SUBSCRIPTION_CANCEL_TYPE_ID,',')>selected</cfif>>#SUBSCRIPTION_CANCEL_TYPE#</option>
                       </cfoutput>
                     </select>
               </div>
             </div>
             <div class="form-group">
               <label class="col col-12 col-xs-12 "><cf_get_lang_main no='246.Üye'></label>
                   <div class="col col-12 col-xs-12">
                       <div class="input-group">
                           <input type="hidden" name="consumer_id" id="consumer_id" <cfif len(attributes.company)> value="<cfoutput>#attributes.consumer_id#</cfoutput>"</cfif>>
                           <input type="hidden" name="company_id" id="company_id" <cfif len(attributes.company)> value="<cfoutput>#attributes.company_id#</cfoutput>"</cfif>>
                           <input type="text" name="company" id="company" value="<cfif len(attributes.company) ><cfoutput>#attributes.company#</cfoutput></cfif>" onfocus="AutoComplete_Create('company','MEMBER_NAME,MEMBER_PARTNER_NAME','MEMBER_NAME,MEMBER_PARTNER_NAME','get_member_autocomplete','\'1\',0,0','COMPANY_ID','company_id','','3','150');">
                           <span class="input-group-addon btnPointer icon-ellipsis" onclick="windowopen('<cfoutput>#request.self#?fuseaction=objects.popup_list_pars&select_list=2,3&field_comp_name=rapor.company&field_comp_id=rapor.company_id&field_consumer=rapor.consumer_id&field_member_name=rapor.company</cfoutput>','list')"></span>
                       </div>
                   </div>
             </div>
             <div class="form-group">
               <label class="col col-12 col-xs-12 "><cf_get_lang no='439.Fatura Sirketi'></label>
                   <div class="col col-12 col-xs-12">
                       <div class="input-group">
                           <input type="hidden" name="i_consumer_id" id="i_consumer_id" <cfif len(attributes.i_company)> value="<cfoutput>#attributes.i_consumer_id#</cfoutput>"</cfif>>
                           <input type="hidden" name="i_company_id" id="i_company_id" <cfif len(attributes.i_company)> value="<cfoutput>#attributes.i_company_id#</cfoutput>"</cfif>>
                           <input type="text" name="i_company" id="i_company" value="<cfif len(attributes.i_company) ><cfoutput>#attributes.i_company#</cfoutput></cfif>" onfocus="AutoComplete_Create('i_company','MEMBER_NAME,MEMBER_PARTNER_NAME','MEMBER_NAME,MEMBER_PARTNER_NAME','get_member_autocomplete','\'1\',0,0','COMPANY_ID','i_company_id','','3','150');">
                           <span class="input-group-addon btnPointer icon-ellipsis" onclick="windowopen('<cfoutput>#request.self#?fuseaction=objects.popup_list_pars&select_list=2,3&field_comp_name=rapor.i_company&field_comp_id=rapor.i_company_id&field_consumer=rapor.i_consumer_id&field_member_name=rapor.i_company</cfoutput>','list')"></span>
                       </div>
                   </div>
             </div>
             <div class="form-group">
               <label class="col col-12 col-xs-12 "><cf_get_lang no='502.Satis Ortagi'></label>
                   <div class="col col-12 col-xs-12">
                       <div class="input-group">
                         <input type="hidden" name="sales_partner_id" id="sales_partner_id" value="<cfif isdefined("attributes.sales_partner_id")><cfoutput>#attributes.sales_partner_id#</cfoutput></cfif>">
                         <input type="text" name="sales_partner" id="sales_partner" value="<cfif isdefined("attributes.sales_partner") and len(attributes.sales_partner)><cfoutput>#attributes.sales_partner#</cfoutput></cfif>" onFocus="AutoComplete_Create('sales_partner','MEMBER_NAME,MEMBER_PARTNER_NAME','MEMBER_PARTNER_NAME,MEMBER_NAME','get_member_autocomplete','\'1,2\',0,0,0','PARTNER_ID','sales_partner_id','','3','250');">
                         <span class="input-group-addon btnPointer icon-ellipsis" onclick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_pars&field_id=rapor.sales_partner_id&field_name=rapor.sales_partner&select_list=2,3','list');"></span>
                       </div>
                   </div>
             </div>
             <div class="form-group">
               <label class="col col-12 col-xs-12 "><cf_get_lang no='482.Satis Temsilcisi'></label>
                   <div class="col col-12 col-xs-12">
                       <div class="input-group">
                         <input type="hidden" name="pos_code" id="pos_code" value="<cfif len(attributes.pos_code_text) and len(attributes.pos_code)><cfoutput>#attributes.pos_code#</cfoutput></cfif>">
                         <input type="Text" name="pos_code_text" id="pos_code_text" value="<cfif len(attributes.pos_code_text) and len(attributes.pos_code)><cfoutput>#get_emp_info(attributes.pos_code,0,0)#</cfoutput></cfif>" onfocus="AutoComplete_Create('pos_code_text','FULLNAME','FULLNAME','get_emp_pos','','POSITION_CODE','pos_code','','3','130');">
                         <span class="input-group-addon btnPointer icon-ellipsis" onclick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_positions&field_emp_id=rapor.pos_code&field_name=rapor.pos_code_text&select_list=1','list')"></span>
                       </div>
                   </div>
             </div>
             <div class="form-group">
               <label class="col col-12 col-xs-12 "><cf_get_lang_main no='377.Ozel Kod'></label>
                   <div class="col col-12 col-xs-12">
                     <cfinput type="text" name="keyword_no" value="#attributes.keyword_no#" maxlength="255">
                   </div>
             </div>
             <div class="form-group">
               <label class="col col-12 col-xs-12 "><cf_get_lang_main no='2247.Szlesme No'></label>
                   <div class="col col-12 col-xs-12">
                     <cfinput type="text" name="sozlesme_no" value="#attributes.sozlesme_no#" maxlength="255">
                   </div>
             </div>
             <div class="form-group">
               <label class="col col-12 col-xs-12"><cf_get_lang no='1403.abone Durumu'></label>
                 <div class="col col-12 col-xs-12">
                   <select name="status" id="status">
                         <option value="1"<cfif isdefined('attributes.status') and (attributes.status eq 1)> selected</cfif>>
                         <cf_get_lang_main no='81.Aktif'>
                         </option>
                         <option value="0"<cfif isdefined('attributes.status') and (attributes.status eq 0)> selected</cfif>>
                         <cf_get_lang_main no='82.Pasif'>
                         </option>
                         <option value="" <cfif isdefined('attributes.status') and (attributes.status neq 0) and (attributes.status neq 1)> selected</cfif>>
                         <cf_get_lang_main no='296.Tm'>
                         </option>
                   </select>
                 </div>
             </div>
             <div class="form-group">
               <label class="col col-12 col-xs-12 "><cf_get_lang_main no='1094. İptal'><cf_get_lang_main no='2314. Durumu'></label>
                 <div class="col col-12 col-xs-12">
                   <select name="status_p" id="status_p">
                     <option value="2" <cfif isdefined('attributes.status_p') and (attributes.status_p eq 2)> selected</cfif>>
                     <cf_get_lang_main no='296.Tm'>
                     </option>
                     <option value="1"<cfif isdefined('attributes.status_p') and (attributes.status_p eq 1)> selected</cfif>>
                     <cf_get_lang_main no='1094.Iptal'>
                     </option>
                     <option value="0"<cfif isdefined('attributes.status_p') and (attributes.status_p eq 0)> selected</cfif>>
                     <cf_get_lang no='518.Iptal Degil'>
                     </option>
                   </select>
                 </div>
             </div>
             <div class="form-group">
               <label class="col col-12 col-xs-12 "><cf_get_lang_main no='1512.Siralama'></label>
                 <div class="col col-12 col-xs-12">
                     <select name="report_sort_type" id="report_sort_type">
                       <option value="">
                       <cf_get_lang_main no='322.Seiniz'>
                       </option>
                       <option value="1"<cfif isdefined('attributes.report_sort_type') and (attributes.report_sort_type eq 1)> selected</cfif>>
                       <cf_get_lang no='519.Szlesme Tarihine Gre'>
                       </option>
                       <option value="2"<cfif isdefined('attributes.report_sort_type') and (attributes.report_sort_type eq 2)> selected</cfif>>
                       <cf_get_lang no='1422.Abone Numarasina Göre'>
                       </option>
                       <option value="3"<cfif isdefined('attributes.report_sort_type') and (attributes.report_sort_type eq 3)> selected</cfif>>
                       <cf_get_lang no='523.ye Kategorisine Gre'>
                       </option>
                     </select>
                 </div>
             </div>
           </div>         
           <div class="col col-3 col-md-4 col-sm-6 col-xs-12">
             <div class="form-group">
               <label class="col col-12 col-xs-12"><cf_get_lang_main no='173.Kurumsal Üye'><cf_get_lang no='370.Kategorisi'></label>
               <div class="col col-12 col-xs-12">
                 <cfquery name="GET_COMPANYCAT" datasource="#DSN#">
                     <!--- SELECT COMPANYCAT_ID,COMPANYCAT FROM COMPANY_CAT ORDER BY COMPANYCAT --->
                     SELECT DISTINCT	
                         COMPANYCAT_ID,
                         COMPANYCAT
                     FROM
                         GET_MY_COMPANYCAT
                     WHERE
                         EMPLOYEE_ID = #session.ep.userid# AND
                         OUR_COMPANY_ID = #session.ep.company_id#
                   ORDER BY
                         COMPANYCAT
                 </cfquery>
                 <select name="comp_cat" id="comp_cat" multiple>
                   <cfoutput query="get_companycat">
                     <option value="#COMPANYCAT_ID#" <cfif listfind(attributes.comp_cat,COMPANYCAT_ID,',')>selected</cfif>>#companycat#</option>
                   </cfoutput>
                 </select>
               </div>
             </div>
             <div class="form-group">
               <label class="col col-12 col-xs-12"><cf_get_lang_main no='174.B ye'><cf_get_lang no='370.Kategorisi'></label>
               <div class="col col-12 col-xs-12">
                 <cfquery name="GET_CONSUMERCAT" datasource="#DSN#">
                   <!--- SELECT CONSCAT_ID,CONSCAT FROM CONSUMER_CAT ORDER BY HIERARCHY --->
                   SELECT DISTINCT	
                       CONSCAT_ID,
                       CONSCAT,
                       HIERARCHY
                   FROM
                       GET_MY_CONSUMERCAT
                   WHERE
                       EMPLOYEE_ID = #session.ep.userid# AND
                       OUR_COMPANY_ID = #session.ep.company_id#
                   ORDER BY
                       HIERARCHY
                 </cfquery>
                   <select name="cons_cat" id="cons_cat" multiple>
                     <cfoutput query="GET_CONSUMERCAT">
                       <option value="#CONSCAT_ID#" <cfif listfind(attributes.cons_cat,CONSCAT_ID,',')>selected</cfif>>#CONSCAT#</option>
                     </cfoutput>
                   </select>
               </div>
             </div>
             <div class="form-group">
               <label class="col col-12 col-xs-12"><cf_get_lang no='503.Iliski Tipi'></label>
               <div class="col col-12 col-xs-12">
                 <cf_wrk_combo name="resource_id" query_name="GET_PARTNER_RESOURCE" option_name="resource" option_value="resource_id" multiple="1" value="#attributes.resource_id#" width="170" height="100">
               </div>
             </div>
             <div class="form-group">
               <label class="col col-12 col-xs-12"><cf_get_lang_main no='162.Sirket'><cf_get_lang no='520.Byklg'></label>
               <div class="col col-12 col-xs-12">
                 <cfquery name="get_sizes" datasource="#dsn#">
                   SELECT COMPANY_SIZE_CAT,COMPANY_SIZE_CAT_ID FROM SETUP_COMPANY_SIZE_CATS ORDER BY COMPANY_SIZE_CAT
                 </cfquery>
                 <select name="size_id" id="size_id" multiple>
                   <cfoutput query="get_sizes">
                     <option value="#COMPANY_SIZE_CAT_ID#" <cfif listfind(attributes.size_id,COMPANY_SIZE_CAT_ID,',')>selected</cfif>>#COMPANY_SIZE_CAT#</option>
                   </cfoutput>
                 </select>
               </div>
             </div>
             <div class="form-group">
               <label class="col col-12 col-xs-12 "><cf_get_lang no='1363.Abone Özel Tanımı'></label>
               <div class="col col-12 col-xs-12">
                 <cfquery name="GET_SUBS_ADD_OPTION" datasource="#DSN3#">
                   SELECT SUBSCRIPTION_ADD_OPTION_ID,SUBSCRIPTION_ADD_OPTION_NAME FROM SETUP_SUBSCRIPTION_ADD_OPTIONS
                 </cfquery>
                 <select name="subs_add_option" id="subs_add_option" style="height:85px;" multiple>
                   <option value="0" <cfif listfind(attributes.subs_add_option,"0",',')>selected</cfif>>
                   <cf_get_lang no='559.Sistem zel Tanimsiz'>
                   </option>
                   <cfoutput query="get_subs_add_option">
                     <option value="#subscription_add_option_id#" <cfif listfind(attributes.subs_add_option,subscription_add_option_id,',')>selected</cfif>>#subscription_add_option_name#</option>
                   </cfoutput>
                 </select>
               </div>
             </div>            
           </div>          
           <div class="col col-3 col-md-4 col-sm-6 col-xs-12">
             <div class="form-group">
               <label class="col col-12 col-xs-12 "><cf_get_lang no='1364.Abone Kategorisi'></label>
               <div class="col col-12 col-xs-12">
                 <select name="subscription_type" id="subscription_type" multiple>
                   <cfoutput query="get_subscription_type">
                     <option value="#subscription_type_id#" <cfif listfind(attributes.subscription_type,subscription_type_id,',')>selected</cfif>>#subscription_type#</option>
                   </cfoutput>
                 </select>
               </div>
             </div>
             <div class="form-group">
               <label class="col col-12 col-xs-12 "><cf_get_lang_main no='1104.Odeme Yontemi'></label>
               <div class="col col-12 col-xs-12">
                 <cfquery name="get_payment_type" datasource="#DSN#">
                   SELECT 
                     SP.PAYMETHOD_ID,
                     SP.PAYMETHOD
                   FROM 
                     SETUP_PAYMETHOD SP,
                     SETUP_PAYMETHOD_OUR_COMPANY SPOC
                   WHERE 
                     SP.PAYMETHOD_ID = SPOC.PAYMETHOD_ID 
                     AND SPOC.OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#">
                 </cfquery>
                 <select name="payment_type" id="payment_type" multiple>
                   <cfoutput query="get_payment_type">
                     <option value="#PAYMETHOD_ID#" <cfif listfind(attributes.payment_type,PAYMETHOD_ID,',')>selected</cfif>>#PAYMETHOD#</option>
                   </cfoutput>
                 </select>
               </div>
             </div>
             <div class="form-group">
                 <label class="col col-12 col-xs-12 "><cf_get_lang no='561.Satis özel Tanimi'></label>
               <div class="col col-12 col-xs-12">
                 <cfquery name="GET_SALE_ADD_OPTION" datasource="#DSN3#">
                   SELECT SALES_ADD_OPTION_ID,SALES_ADD_OPTION_NAME FROM SETUP_SALES_ADD_OPTIONS
                 </cfquery>
                 <select name="sale_add_option" id="sale_add_option" style="height:100px;" multiple>
                   <option value="0" <cfif listfind(attributes.sale_add_option,"0",',')>selected</cfif>>
                   <cf_get_lang no='562.Satis zel Tanimsiz'>
                   </option>
                   <cfoutput query="get_sale_add_option">
                     <option value="#sales_add_option_id#" <cfif listfind(attributes.sale_add_option,sales_add_option_id,',')>selected</cfif>>#sales_add_option_name#</option>
                   </cfoutput>
                 </select>
               </div>
             </div>
             <div class="form-group">
                 <label class="col col-12 col-xs-12"><cf_get_lang no='564.Satis Takimi'></label>
               <div class="col col-12 col-xs-12">
                 <cfquery name="GET_SALES_ZONES" datasource="#DSN#">
                   SELECT TEAM_ID,TEAM_NAME FROM SALES_ZONES_TEAM
                   </cfquery>
                   <select name="sales_zones" id="sales_zones" multiple>
                     <cfoutput query="get_sales_zones">
                       <option value="#TEAM_ID#" <cfif listfind(attributes.sales_zones,TEAM_ID,',')>selected</cfif>>#TEAM_NAME#</option>
                     </cfoutput>
                   </select>
               </div>
             </div>
             <div class="form-group">
                 <label class="col col-12 col-xs-12"><cf_get_lang no='1404.Abone Aşaması'></label>
               <div class="col col-12 col-xs-12">
                   <select name="process_stage_type" id="process_stage_type" style="height:85px;" multiple>
                     <cfoutput query="get_service_stage">
                       <option value="#process_row_id#" <cfif listfind(attributes.process_stage_type,process_row_id,',')>selected</cfif>>#stage#</option>
                     </cfoutput>
                   </select>
               </div>
             </div>            
           </div>
           <div class="col col-3 col-md-4 col-sm-6 col-xs-12">
             <div class="form-group">
               <div class="col col-12 col-xs-12" id="report_dsp1" <cfif not listfind("1,16",attributes.report_type)>style="display:none;"</cfif>><cf_get_lang no='1094.Liste Kategorisi'></div>
                 <div class="col col-12 col-xs-12" id="report_dsp" <cfif not listfind("1,16",attributes.report_type)>style="display:none;"</cfif>>
                     <select name="report_dsp_type" id="report_dsp_type" style="height:60px;" multiple>
                           <option value="1" <cfif listfind(attributes.report_dsp_type,1)>selected</cfif>>
                           <cf_get_lang_main no='1197.ye Kategorisi'>
                           </option>
                           <option value="2" <cfif listfind(attributes.report_dsp_type,2)>selected</cfif>>
                           <cf_get_lang no='568.ye Sirket Byklg'>
                           </option>
                           <option value="3" <cfif listfind(attributes.report_dsp_type,3)>selected</cfif>>
                           <cf_get_lang no='503.Iliski Tipi'>
                           </option>
                           <option value="4" <cfif listfind(attributes.report_dsp_type,4)>selected</cfif>>
                           <cf_get_lang no='569.ye Kodu'>
                           </option>
                           <option value="5" <cfif listfind(attributes.report_dsp_type,5)>selected</cfif>>
                           <cf_get_lang no='571.ye Adi'>
                           </option>
                           <option value="6" <cfif listfind(attributes.report_dsp_type,6)>selected</cfif>>
                           <cf_get_lang no='502.Satis Ortagi'>
                           </option>
                           <option value="27" <cfif listfind(attributes.report_dsp_type,27)>selected</cfif>>
                           <cf_get_lang no='1823.Satis Ort Komisyonu'>
                           </option>
                           <option value="7" <cfif listfind(attributes.report_dsp_type,7)>selected</cfif>>
                           <cf_get_lang no='564.Satis Takimi'>
                           </option>
                           <option value="8" <cfif listfind(attributes.report_dsp_type,8)>selected</cfif>>
                           <cf_get_lang no='482.Satis Temsilcisi'>
                           </option>
                           <option value="9" <cfif listfind(attributes.report_dsp_type,9)>selected</cfif>>
                           <cf_get_lang no='1364.Abone Kategorisi'>
                           </option>
                           <option value="10" <cfif listfind(attributes.report_dsp_type,10)>selected</cfif>>
                           <cf_get_lang no='1404.Abone Aşaması'>
                           </option>
                           <option value="11" <cfif listfind(attributes.report_dsp_type,11)>selected</cfif>><cf_get_lang no='1403.Abone Durumu'></option>
                           <option value="12" <cfif listfind(attributes.report_dsp_type,12)>selected</cfif>><cf_get_lang_main no='1420.Abone'>ID</option>
                           <option value="13" <cfif listfind(attributes.report_dsp_type,13)>selected</cfif>><cf_get_lang_main no='1420.Abone'><cf_get_lang_main no='821.Tanimi'></option>
                           <option value="14" <cfif listfind(attributes.report_dsp_type,14)>selected</cfif>><cf_get_lang_main no='377.Ozel Kod'></option>
                           <option value="15" <cfif listfind(attributes.report_dsp_type,15)>selected</cfif>><cf_get_lang no='573.Referans Msteri Kodu'></option>
                           <option value="16" <cfif listfind(attributes.report_dsp_type,16)>selected</cfif>><cf_get_lang no='576.Referans Msteri Adi'></option>
                           <option value="17" <cfif listfind(attributes.report_dsp_type,17)>selected</cfif>><cf_get_lang_main no='1104.Odeme Yontemi'></option>
                           <option value="18" <cfif listfind(attributes.report_dsp_type,18)>selected</cfif>><cf_get_lang_main no='2247.Szlesme Numarasi'></option>
                           <option value="19" <cfif listfind(attributes.report_dsp_type,19)>selected</cfif>><cf_get_lang_main no='335.Szlesme Tarihi'></option>
                           <option value="20" <cfif listfind(attributes.report_dsp_type,20)>selected</cfif>><cf_get_lang dictionary_id='60559.Kurulum Tarihi'></option>
                           <option value="21" <cfif listfind(attributes.report_dsp_type,21)>selected</cfif>><cf_get_lang no='532.deme Plani Baslangi Tarihi'></option>
                           <option value="33" <cfif listfind(attributes.report_dsp_type,33)>selected</cfif>>deme Plani Bitis Tarihi</option>
                           <option value="22" <cfif listfind(attributes.report_dsp_type,22)>selected</cfif>><cf_get_lang no='469.Prim Tarihi'></option>
                           <option value="23" <cfif listfind(attributes.report_dsp_type,23)>selected</cfif>><cf_get_lang_main no='336.Iptal Tarihi'></option>
                           <option value="24" <cfif listfind(attributes.report_dsp_type,24)>selected</cfif>><cf_get_lang_main no='1413.Iptal Nedeni'></option>
                           <option value="25" <cfif listfind(attributes.report_dsp_type,25)>selected</cfif>><cf_get_lang_main no='217.Aiklama'></option>
                           <option value="26" <cfif listfind(attributes.report_dsp_type,26)>selected</cfif>><cf_get_lang no='583.Sistem Kullanim Sresi'></option>
                           <option value="28" <cfif listfind(attributes.report_dsp_type,28)>selected</cfif>><cf_get_lang_main no='398.Ek Bilgi'>1</option>
                           <option value="29" <cfif listfind(attributes.report_dsp_type,29)>selected</cfif>><cf_get_lang_main no='398.Ek Bilgi'>2</option>
                           <option value="30" <cfif listfind(attributes.report_dsp_type,30)>selected</cfif>><cf_get_lang_main no='398.Ek Bilgi'>3</option>
                           <option value="31" <cfif listfind(attributes.report_dsp_type,31)>selected</cfif>><cf_get_lang_main no='398.Ek Bilgi'>4</option>
                           <option value="32" <cfif listfind(attributes.report_dsp_type,32)>selected</cfif>><cf_get_lang_main no='398.Ek Bilgi'>5</option>
                           <option value="39" <cfif listfind(attributes.report_dsp_type,39)>selected</cfif>><cf_get_lang_main no='398.Ek Bilgi'>6</option>
                           <option value="40" <cfif listfind(attributes.report_dsp_type,40)>selected</cfif>><cf_get_lang_main no='398.Ek Bilgi'>7</option>
                           <option value="41" <cfif listfind(attributes.report_dsp_type,41)>selected</cfif>><cf_get_lang_main no='398.Ek Bilgi'>8</option>
                           <option value="42" <cfif listfind(attributes.report_dsp_type,42)>selected</cfif>><cf_get_lang_main no='398.Ek Bilgi'>9</option>
                           <option value="43" <cfif listfind(attributes.report_dsp_type,43)>selected</cfif>><cf_get_lang_main no='398.Ek Bilgi'>10</option>
                           <option value="33" <cfif listfind(attributes.report_dsp_type,33)>selected</cfif>><cf_get_lang_main no='175.Borç'></option>
                           <option value="34" <cfif listfind(attributes.report_dsp_type,34)>selected</cfif>><cf_get_lang_main no='176.Alacak'></option>
                           <option value="35" <cfif listfind(attributes.report_dsp_type,35)>selected</cfif>><cf_get_lang_main no='177.Bakiye'></option>
                           <cfif x_show_bill_info eq 1>
                             <option value="36" <cfif listfind(attributes.report_dsp_type,36)>selected</cfif>>Ödenmemiş Fatura Tutarı</option>
                             <option value="37" <cfif listfind(attributes.report_dsp_type,37)>selected</cfif>>Ödenmemiş Fatura Sayısı</option>
                           </cfif>
                           <option value="38" <cfif listfind(attributes.report_dsp_type,38)>selected</cfif>><cf_get_lang_main no='1311.Adres'></option>
                           <option value="44" <cfif listfind(attributes.report_dsp_type,44)>selected</cfif>><cf_get_lang no='1363.Abone Özel Tanımı'></option>
                           <option value="45" <cfif listfind(attributes.report_dsp_type,45)>selected</cfif>>Üye Özel Kodu</option> 
                        </select>
                 </div>
             </div>
             <div class="form-group">
               <label class="col col-12 col-xs-12 "><cf_get_lang_main no='336.Iptal Tarihi'></label>
                   <div class="col col-6">
                       <div class="input-group">
                       <cfsavecontent variable="message"><cf_get_lang_main no='370.Tarih Degerini Kontrol Ediniz'></cfsavecontent>
                         <cfinput value="#attributes.date1_i#" type="text" name="date1_i" maxlength="10" message="#message#" validate="#validate_style#">
                         <span class="input-group-addon"><cf_wrk_date_image date_field="date1_i"></span>
                       </div>
                     </div>
                     <div class="col col-6">
                       <div class="input-group">
                         <cfinput value="#attributes.date2_i#"  type="text" name="date2_i" maxlength="10" message="#message#" validate="#validate_style#">
                         <span class="input-group-addon"><cf_wrk_date_image date_field="date2_i"></span>
                      </div>
                   </div>
             </div>
             <div class="form-group">
               <label class="col col-12 col-xs-12 "><cf_get_lang no='469.Prim Tarihi'></label>
                   <div class="col col-6">
                       <div class="input-group">
                         <cfinput value="#attributes.date1_p#" type="text" name="date1_p"  maxlength="10" validate="#validate_style#" message="#message#">
                         <span class="input-group-addon"><cf_wrk_date_image date_field="date1_p"></span>
                       </div>
                     </div>
                     <div class="col col-6">
                       <div class="input-group">
                         <cfinput value="#attributes.date2_p#"  type="text" name="date2_p" maxlength="10" validate="#validate_style#" message="#message#">
                         <span class="input-group-addon"><cf_wrk_date_image date_field="date2_p"></span>
                       </div>
                   </div>
             </div>
             <div class="form-group">
               <label class="col col-12 col-xs-12 "><cf_get_lang no='532.Ödeme Planı Başlangıç Tarihi'></label>
                   <div class="col col-6">
                       <div class="input-group">
                         <cfinput value="#attributes.date1_o#" type="text" name="date1_o" maxlength="10" validate="#validate_style#" message="#message#">
                         <span class="input-group-addon"><cf_wrk_date_image date_field="date1_o"></span>
                       </div>
                     </div>
                     <div class="col col-6">
                       <div class="input-group">
                         <cfinput value="#attributes.date2_o#"  type="text" name="date2_o" maxlength="10" validate="#validate_style#" message="#message#">
                         <span class="input-group-addon"><cf_wrk_date_image date_field="date2_o"></span>
                       </div>
                   </div>
             </div>
             <div class="form-group">
               <label class="col col-12 col-xs-12 "><cf_get_lang dictionary_id='56907.Ödeme Planı'> <cf_get_lang_main no="288.Bitis Tarihi"></label>
                   <div class="col col-6">
                       <div class="input-group">
                           <cfinput value="#attributes.date3_o#" type="text" name="date3_o" maxlength="10" validate="#validate_style#" message="#message#">
                           <span class="input-group-addon"><cf_wrk_date_image date_field="date3_o"></span>
                         </div>
                       </div>
                     <div class="col col-6">
                       <div class="input-group">
                           <cfinput value="#attributes.date4_o#" type="text" name="date4_o" maxlength="10" validate="#validate_style#" message="#message#">
                           <span class="input-group-addon"><cf_wrk_date_image date_field="date4_o"></span>
                       </div>
                   </div>
             </div>
             <div class="form-group">
               <label class="col col-12 col-xs-12 "><cf_get_lang_main no='335.Szlesme Tarihi'></label>
                   <div class="col col-6">
                       <div class="input-group">
                             <cfinput value="#attributes.date1#" type="text" name="date1" maxlength="10" validate="#validate_style#" message="#message#">
                             <span class="input-group-addon"><cf_wrk_date_image date_field="date1"></span>
                       </div>
                   </div>
                   <div class="col col-6">
                       <div class="input-group">
                             <cfinput value="#attributes.date2#" type="text" name="date2" maxlength="10" validate="#validate_style#" message="#message#">
                             <span class="input-group-addon"><cf_wrk_date_image date_field="date2"></span>
                       </div>
                   </div>
             </div>
             <div class="form-group">
               <label class="col col-12 col-xs-12 "><cf_get_lang dictionary_id='60559.Kurulum Tarihi'></label>
                   <div class="col col-6">
                       <div class="input-group">
                             <cfinput value="#attributes.date1_m#" type="text" name="date1_m" maxlength="10" validate="#validate_style#" message="#message#">
                             <span class="input-group-addon"><cf_wrk_date_image date_field="date1_m"></span>
                       </div>
                   </div>
                   <div class="col col-6">
                       <div class="input-group">
                             <cfinput value="#attributes.date2_m#"  type="text" name="date2_m" maxlength="10" validate="#validate_style#" message="#message#">
                             <span class="input-group-addon"><cf_wrk_date_image date_field="date2_m"></span>
                       </div>
                   </div>
             </div>
             <div class="form-group">
              <label class="col col-12 col-xs-12"><cf_get_lang dictionary_id='34779.Referans Müşteri'></label>
              <div class="col col-12 col-xs-12">
                <div class="input-group">
                  <input type="hidden" name="ref_company_id" id="ref_company_id" value="<cfif isdefined("attributes.ref_company_id")><cfoutput>#attributes.ref_company_id#</cfoutput></cfif>">
                  <input type="hidden" name="ref_consumer_id" id="ref_consumer_id" value="<cfif isdefined("attributes.ref_consumer_id")><cfoutput>#attributes.ref_consumer_id#</cfoutput></cfif>">
                  <input type="hidden" name="ref_partner_id" id="ref_partner_id" value="<cfif isdefined("attributes.ref_partner_id")><cfoutput>#attributes.ref_partner_id#</cfoutput></cfif>">
                  <input type="hidden" name="ref_member_type" id="ref_member_type" value="<cfif isdefined("attributes.ref_member_type")><cfoutput>#attributes.ref_member_type#</cfoutput></cfif>">
                  <input name="ref_member_name"  type="text" id="ref_member_name" onfocus="AutoComplete_Create('ref_member_name','MEMBER_NAME,MEMBER_CODE','MEMBER_NAME,MEMBER_CODE,MEMBER_PARTNER_NAME','get_member_autocomplete','\'1,2,3\',\'<cfif session.ep.isBranchAuthorization>1<cfelse>0</cfif>\',\'0\',\'0\',\'2\',\'0\',\'0\',\'1\'','COMPANY_ID,CONSUMER_ID,MEMBER_TYPE','ref_company_id,ref_consumer_id,ref_member_type','rapor','3','250');" value="<cfif isdefined("attributes.ref_member_name") and len(attributes.ref_member_name)><cfoutput>#attributes.ref_member_name#</cfoutput></cfif>" autocomplete="off">
                  <cfset str_linke_ait1="field_comp_id=rapor.ref_company_id&field_partner=rapor.ref_partner_id&field_consumer=rapor.ref_consumer_id&field_comp_name=rapor.ref_member_name&field_type=rapor.ref_member_type">
                  <span class="input-group-addon btnPointer icon-ellipsis" onclick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_all_pars&<cfoutput>#str_linke_ait1#</cfoutput>&select_list=2,3','list','popup_list_all_pars');"></span>
                </div>
              </div>
            </div>         
             <div class="form-group">
               <label class="col col-12 col-xs-12 "><cf_get_lang_main no='217.Aiklama'></label>
                   <div class="col col-12 col-xs-12">
                     <cfinput type="text" name="detail" value="#attributes.detail#" maxlength="255">
                   </div>
             </div>
             <div class="form-group">
               <label class="col col-12 col-xs-12 "><cf_get_lang_main no="2075.E-Fatura"></label>
                 <div class="col col-12 col-xs-12">
                   <select name="use_efatura" id="use_efatura">
                     <option value=""><cf_get_lang_main no="2075.E-Fatura"></option>
                     <option value="1" <cfif attributes.use_efatura eq 1>selected="selected"</cfif>><cf_get_lang_main no='1695.Kullanıyor'></option>
                     <option value="0" <cfif attributes.use_efatura eq 0>selected="selected"</cfif>><cf_get_lang_main no='1696.Kullanmıyor'></option>
                   </select>
                 </div>
             </div>
             <div class="form-group">
               <label class="col col-12 col-xs-12 "><cf_get_lang_main no='1548.Rapor Tipi'></label>
                 <div class="col col-12 col-xs-12">                 
                     <select name="report_type" id="report_type" onchange="ayarla_gizle_goster(this.value);">
                           <option value="1" <cfif attributes.report_type eq 1><cfset report_type_text="Sistem">selected</cfif>>
                           <cf_get_lang_main no="1420.Abone"><cf_get_lang_main no='1189.Bazinda'>
                           </option>
                           <option value="2" <cfif attributes.report_type eq 2><cfset report_type_text="Satış Takımı">selected</cfif>>
                           <cf_get_lang no='530.Satis Takimi Bazinda'>
                           </option>
                           <option value="3" <cfif attributes.report_type eq 3><cfset report_type_text="Satış Temsilcisi">selected</cfif>>
                           <cf_get_lang no='534.Satis Temsilcisi Bazinda'>
                           </option>
                           <option value="4" <cfif attributes.report_type eq 4><cfset report_type_text="Abone Kategorisi">selected</cfif>>
                           <cf_get_lang no="1364.Abone Kategorisi"><cf_get_lang_main no='1189.Bazinda'>
                           </option>
                           <option value="5" <cfif attributes.report_type eq 5><cfset report_type_text="Abone Aşaması">selected</cfif>>
                           <cf_get_lang no="1404.Abone Aşaması"><cf_get_lang_main no='1189.Bazinda'>
                           </option>
                           <option value="6" <cfif attributes.report_type eq 6><cfset report_type_text="Kurumsal Üye Kategorisi Bazında">selected</cfif>>
                           <cf_get_lang no='543.K ye Kategorisi Bazinda'>
                           </option>
                           <option value="7" <cfif attributes.report_type eq 7><cfset report_type_text="Bireysel Üye Kategorisi Bazında">selected</cfif>>
                           <cf_get_lang no='544.B ye Kategorisi Bazinda'>
                           </option>
                           <option value="8" <cfif attributes.report_type eq 8><cfset report_type_text="Ödeme Tipi">selected</cfif>>
                           <cf_get_lang_main no='1516.Odeme Tipi'>
                           </option>
                           <option value="9" <cfif attributes.report_type eq 9><cfset report_type_text="Kurumsal Üye İlişki Tipi">selected</cfif>>
                           <cf_get_lang no='549.K Iliski Tipi Bazinda'>
                           </option>
                           <option value="10" <cfif attributes.report_type eq 10><cfset report_type_text="Bireysel Üye İlişki Tipi">selected</cfif>>
                           <cf_get_lang no='550.B Iliski Tipi Bazinda'>
                           </option>
                           <option value="11" <cfif attributes.report_type eq 11><cfset report_type_text="İptal Nedeni">selected</cfif>>
                           <cf_get_lang no='551. Iptal Nedeni Bazinda'>
                           </option>
                           <option value="12" <cfif attributes.report_type eq 12><cfset report_type_text="İptal Tarihi">selected</cfif>>
                           <cf_get_lang no='552.Iptal Tarihi Bazinda'>
                           </option>
                           <option value="13" <cfif attributes.report_type eq 13><cfset report_type_text="Sözleşme Tarihi">selected</cfif>>
                           <cf_get_lang no='553.Szlesme Tarihi Bazinda'>
                           </option>
                           <option value="14" <cfif attributes.report_type eq 14><cfset report_type_text="Ödeme Planı">selected</cfif>>
                           <cf_get_lang no='554.deme Plani Tarihi Bazinda'>
                           </option>
                           <option value="15" <cfif attributes.report_type eq 15><cfset report_type_text="Kurulum Tarihi">selected</cfif>>
                           <cf_get_lang dictionary_id='60561.Kurulum Tarihi Bazinda'>
                           </option>
                           <option value="16" <cfif attributes.report_type eq 16><cfset report_type_text="rn Bazında">selected</cfif>>
                           <cf_get_lang no='332.rn Bazinda'>
                           </option>
                     </select>
                 </div>
             </div>
             <div class="form-group">
                   <div class="col col-12 col-xs-12 " <cfif listfind("1,16",attributes.report_type)>style="display:none;" </cfif> id="graphic"><cf_get_lang no ='1020.Grafik'></div>
                 <div class="col col-12 col-xs-12" <cfif listfind("1,16",attributes.report_type)>style="display:none;"</cfif> id="graphic2">
                     <select name="graph_type" id="graph_type">
                         <option value="" selected><cf_get_lang_main no='538.Grafik Format'></option>
                         <option value="line" <cfif attributes.graph_type eq 'Line'> selected</cfif>>Line</option>
                         <option value="pie"<cfif attributes.graph_type eq 'pie'> selected</cfif>><cf_get_lang_main no='1316.Pasta'></option>
                         <option value="bar"<cfif attributes.graph_type eq 'bar'> selected</cfif>><cf_get_lang_main no='251.Bar'></option>
                         <option value="radar"<cfif attributes.graph_type eq 'radar'> selected</cfif>>Radar</option>
                     </select>
                 </div>
             </div>
             <div class="form-group">
                   <cfif x_ch_date eq 1>
                <label class="col col-12 col-xs-12 ">Finansal İşlem Tarihi</label>
                <div class="col col-12 col-xs-12">
                 <div class="input-group">
                    <cfinput value="#dateformat(attributes.ch_date_1, dateformat_style)#" type="text" name="ch_date_1" maxlength="10" validate="#validate_style#" message="#message#">
                    <span class="input-group-addon"><cf_wrk_date_image date_field="ch_date_1"></span>
                   <span class="input-group-addon no-bg"></span>
                   <cfinput value="#dateformat(attributes.ch_date_2, dateformat_style)#"  type="text" name="ch_date_2" maxlength="10" validate="#validate_style#" message="#message#">
                   <span class="input-group-addon"><cf_wrk_date_image date_field="ch_date_2"></span>
                 </div>
                 </div>
               </cfif>
             </div> 
           </div>          
         </div>
       </div>
       <div class="row ReportContentBorder">
             <div class="ReportContentFooter">
               <label><cf_get_lang_main no='446.Excel Getir'><input type="checkbox" name="is_excel" id="is_excel" value="1" <cfif attributes.is_excel eq 1>checked</cfif>></label>             
               <cfsavecontent variable="message"><cf_get_lang_main no='125.Sayi_Hatasi_Mesaj'></cfsavecontent>
               <cfif session.ep.our_company_info.is_maxrows_control_off eq 1>
                 <cfinput type="text" name="maxrows" value="#attributes.maxrows#" required="yes" onKeyUp="isNumber(this)" validate="integer" message="#message#" maxlength="3" style="width:25px;">
               <cfelse>
                 <cfinput type="text" name="maxrows" value="#attributes.maxrows#" required="yes" onKeyUp="isNumber(this)" validate="integer" range="1,999" message="#message#" maxlength="3" style="width:25px;">
               </cfif>
               <cfsavecontent variable="message"><cf_get_lang_main no ='499.Çalistir'></cfsavecontent>
               <input type="hidden" name="form_submitted" id="form_submitted" value="">
               <cf_wrk_report_search_button search_function='control()' insert_info='#message#' button_type='1' is_excel="1">
             </div>
       </div>
     </div>
   </div>
 </cf_report_list_search_area>
 </cf_report_list_search>
 </cfform>   
 <cfparam name="attributes.page" default=1>
 <cfparam name="attributes.totalrecords" default="#get_total_purchase.recordcount#">
 <cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
 <cfif isdefined('attributes.is_excel') and attributes.is_excel eq 1>
     <cfset filename="system_analyse_report#dateformat(now(),'ddmmyyyy')#_#timeformat(now(),'HHMMl')#_#session.ep.userid#">
     <cfheader name="Expires" value="#Now()#">
     <cfcontent type="application/vnd.msexcel; charset=utf-16">
     <cfheader name="Content-Disposition" value="attachment; filename=#filename#.xls">
     <meta http-equiv="Content-Type" content="text/html; charset=utf-16">
   <cfset type_ = 1>
     <cfset attributes.startrow=1>
     <cfset attributes.maxrows=get_total_purchase.recordcount>	
   <cfelse>
     <cfset type_ = 0>
     <cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
     <cfset attributes.maxrows=attributes.maxrows>
 </cfif>
 <cfif isdefined("attributes.form_submitted")>
 <cf_report_list>
  
     <cfif get_total_purchase.recordcount and listfind("1,16",attributes.report_type)>
       <cfset company_id_list=''>
       <cfset consumer_id_list=''>
       <cfset sales_comp_id_list=''>
       <cfset sales_cons_id_list=''>
       <cfset sales_emp_id_list=''>
       <cfset s_cat_id_list=''>
       <cfset s_stage_id_list=''>
       <cfset ref_comp_id_list=''>
       <cfset ref_cons_id_list=''>
       <cfset ref_emp_id_list=''>
       <cfset pay_type_id_list=''>
       <cfset subs_id_list=''>
       <cfset subs_cancel_list=''>
       <cfset subs_extra_list=''>
       <cfoutput query="get_total_purchase" maxrows="#attributes.maxrows#" startrow="#attributes.startrow#">
         <cfif len(COMPANY_ID) and not listfind(company_id_list,COMPANY_ID)>
           <cfset company_id_list=listappend(company_id_list,COMPANY_ID)>
         </cfif>
         <cfif len(CONSUMER_ID) and not listfind(consumer_id_list,CONSUMER_ID)>
           <cfset consumer_id_list=listappend(consumer_id_list,CONSUMER_ID)>
         </cfif>
         <cfif listfind(attributes.report_dsp_type,6)>
           <cfif len(SALES_COMPANY_ID) and not listfind(sales_comp_id_list,SALES_COMPANY_ID)>
             <cfset sales_comp_id_list=listappend(sales_comp_id_list,SALES_COMPANY_ID)>
           </cfif>
           <cfif len(SALES_CONSUMER_ID) and not listfind(sales_cons_id_list,SALES_CONSUMER_ID)>
             <cfset sales_cons_id_list=listappend(sales_cons_id_list,SALES_CONSUMER_ID)>
           </cfif>
         </cfif>
         <cfif listfind(attributes.report_dsp_type,7) or listfind(attributes.report_dsp_type,8)>
           <cfif len(SALES_EMP_ID) and not listfind(sales_emp_id_list,SALES_EMP_ID)>
             <cfset sales_emp_id_list=listappend(sales_emp_id_list,SALES_EMP_ID)>
           </cfif>
         </cfif>
         <cfif listfind(attributes.report_dsp_type,9)>
           <cfif len(SUBSCRIPTION_TYPE_ID) and not listfind(s_cat_id_list,SUBSCRIPTION_TYPE_ID)>
             <cfset s_cat_id_list=listappend(s_cat_id_list,SUBSCRIPTION_TYPE_ID)>
           </cfif>
         </cfif>
         <cfif listfind(attributes.report_dsp_type,10)>
           <cfif len(SUBSCRIPTION_STAGE) and not listfind(s_stage_id_list,SUBSCRIPTION_STAGE)>
             <cfset s_stage_id_list=listappend(s_stage_id_list,SUBSCRIPTION_STAGE)>
           </cfif>
         </cfif>
         <cfif listfind(attributes.report_dsp_type,15) or listfind(attributes.report_dsp_type,16)>
           <cfif len(REF_COMPANY_ID) and not listfind(ref_comp_id_list,REF_COMPANY_ID)>
             <cfset ref_comp_id_list=listappend(ref_comp_id_list,REF_COMPANY_ID)>
           </cfif>
           <cfif len(REF_CONSUMER_ID) and not listfind(ref_cons_id_list,REF_CONSUMER_ID)>
             <cfset ref_cons_id_list=listappend(ref_cons_id_list,REF_CONSUMER_ID)>
           </cfif>
           <cfif len(REF_EMPLOYEE_ID) and not listfind(ref_emp_id_list,REF_EMPLOYEE_ID)>
             <cfset ref_emp_id_list=listappend(ref_emp_id_list,REF_EMPLOYEE_ID)>
           </cfif>
         </cfif>
         <cfif listfind(attributes.report_dsp_type,17)>
           <cfif len(PAYMENT_TYPE_ID) and not listfind(pay_type_id_list,PAYMENT_TYPE_ID)>
             <cfset pay_type_id_list=listappend(pay_type_id_list,PAYMENT_TYPE_ID)>
           </cfif>
         </cfif>
         <cfif listfind(attributes.report_dsp_type,21) or listfind(attributes.report_dsp_type,33)>
           <cfif len(SUBSCRIPTION_ID) and not listfind(subs_id_list,SUBSCRIPTION_ID)>
             <cfset subs_id_list=listappend(subs_id_list,SUBSCRIPTION_ID)>
           </cfif>
         </cfif>
         <cfif listfind(attributes.report_dsp_type,24)>
           <cfif len(CANCEL_TYPE_ID) and not listfind(subs_cancel_list,CANCEL_TYPE_ID)>
             <cfset subs_cancel_list=listappend(subs_cancel_list,CANCEL_TYPE_ID)>
           </cfif>
         </cfif>
         <cfif listfind("1,16",attributes.report_type)>
           <cfif len(SUBSCRIPTION_ID) and not listfind(subs_extra_list,SUBSCRIPTION_ID)>
             <cfset subs_extra_list=listappend(subs_extra_list,SUBSCRIPTION_ID)>
           </cfif>
         </cfif>
       </cfoutput>
       <cfif listfind(attributes.report_dsp_type,6)>
         <cfif len(sales_comp_id_list)>
           <cfset sales_comp_id_list=listsort(sales_comp_id_list,"numeric","ASC",",")>
           <cfquery name="get_comp_sales" datasource="#dsn#">
           SELECT FULLNAME,COMPANY_ID FROM COMPANY WHERE COMPANY_ID IN (#sales_comp_id_list#) ORDER BY COMPANY_ID
           </cfquery>
           <cfset sales_comp_id_list_2 = valuelist(get_comp_sales.COMPANY_ID)>
         </cfif>
         <cfif len(sales_cons_id_list)>
           <cfset sales_cons_id_list=listsort(sales_cons_id_list,"numeric","ASC",",")>
           <cfquery name="get_cons_sales" datasource="#dsn#">
           SELECT CONSUMER_NAME,CONSUMER_SURNAME,CONSUMER_ID FROM CONSUMER WHERE CONSUMER_ID IN (#sales_cons_id_list#) ORDER BY CONSUMER_ID
           </cfquery>
           <cfset sales_cons_id_list_2 = valuelist(get_cons_sales.CONSUMER_ID)>
         </cfif>
       </cfif>
       <cfif listfind(attributes.report_dsp_type,8)>
         <cfif len(sales_emp_id_list)>
           <cfset sales_emp_id_list=listsort(sales_emp_id_list,"numeric","ASC",",")>
           <cfquery name="get_emp_sales" datasource="#dsn#">
           SELECT EMPLOYEE_NAME,EMPLOYEE_SURNAME FROM EMPLOYEES WHERE EMPLOYEE_ID IN (#sales_emp_id_list#) ORDER BY EMPLOYEE_ID
           </cfquery>
         </cfif>
       </cfif>
       <cfif listfind(attributes.report_dsp_type,7)>
         <cfif len(sales_emp_id_list)>
           <cfset sales_emp_id_list=listsort(sales_emp_id_list,"numeric","ASC",",")>
           <cfquery name="get_sales_team" datasource="#dsn#">
               SELECT
                   SZ.TEAM_NAME,
                   EMP.EMPLOYEE_ID
               FROM
                   SALES_ZONES_TEAM_ROLES SZT,
                   SALES_ZONES_TEAM SZ,
                   EMPLOYEE_POSITIONS EMP
             WHERE
                   SZ.TEAM_ID = SZT.TEAM_ID AND
                   SZT.POSITION_CODE = EMP.POSITION_CODE AND
                   EMP.EMPLOYEE_ID IN (#sales_emp_id_list#)
             ORDER BY
                   EMP.EMPLOYEE_ID
           </cfquery>
           <cfset sales_emp_id_list_2 = valuelist(get_sales_team.EMPLOYEE_ID)>
         </cfif>
       </cfif>
       <cfif listfind(attributes.report_dsp_type,9)>
         <cfif len(s_cat_id_list)>
           <cfset s_cat_id_list=listsort(s_cat_id_list,"numeric","ASC",",")>
           <cfquery name="get_cat_types" datasource="#dsn3#">
           SELECT SUBSCRIPTION_TYPE FROM SETUP_SUBSCRIPTION_TYPE WHERE SUBSCRIPTION_TYPE_ID IN (#s_cat_id_list#) ORDER BY SUBSCRIPTION_TYPE_ID
           </cfquery>
         </cfif>
       </cfif>
       <cfif listfind(attributes.report_dsp_type,10)>
         <cfif len(s_stage_id_list)>
           <cfset s_stage_id_list=listsort(s_stage_id_list,"numeric","ASC",",")>
           <cfquery name="get_stage_types" datasource="#dsn#">
           SELECT STAGE FROM PROCESS_TYPE_ROWS WHERE PROCESS_ROW_ID IN (#s_stage_id_list#) ORDER BY PROCESS_ROW_ID
           </cfquery>
         </cfif>
       </cfif>
       <cfif listfind(attributes.report_dsp_type,15) or listfind(attributes.report_dsp_type,16)>
         <cfif len(ref_comp_id_list)>
           <cfset ref_comp_id_list=listsort(ref_comp_id_list,"numeric","ASC",",")>
           <cfquery name="get_refs_comp" datasource="#dsn#">
           SELECT FULLNAME,MEMBER_CODE FROM COMPANY WHERE COMPANY_ID IN (#ref_comp_id_list#) ORDER BY COMPANY_ID
           </cfquery>
         </cfif>
         <cfif len(ref_cons_id_list)>
           <cfset ref_cons_id_list=listsort(ref_cons_id_list,"numeric","ASC",",")>
           <cfquery name="get_refs_cons" datasource="#dsn#">
           SELECT CONSUMER_NAME,CONSUMER_SURNAME,MEMBER_CODE FROM CONSUMER WHERE CONSUMER_ID IN (#ref_cons_id_list#) ORDER BY CONSUMER_ID
           </cfquery>
         </cfif>
         <cfif len(ref_emp_id_list)>
           <cfset ref_emp_id_list=listsort(ref_emp_id_list,"numeric","ASC",",")>
           <cfquery name="get_refs_emp" datasource="#dsn#">
           SELECT EMPLOYEE_NAME,EMPLOYEE_SURNAME,MEMBER_CODE FROM EMPLOYEES WHERE EMPLOYEE_ID IN (#ref_emp_id_list#) ORDER BY EMPLOYEE_ID
           </cfquery>
         </cfif>
       </cfif>
       <cfif listfind(attributes.report_dsp_type,17)>
         <cfif len(pay_type_id_list)>
           <cfset pay_type_id_list=listsort(pay_type_id_list,"numeric","ASC",",")>
           <cfquery name="get_pay_types" datasource="#dsn#">
           SELECT PAYMETHOD FROM SETUP_PAYMETHOD WHERE PAYMETHOD_ID IN (#pay_type_id_list#) ORDER BY PAYMETHOD_ID
           </cfquery>
         </cfif>
       </cfif>
       <cfif listfind(attributes.report_dsp_type,21) or listfind(attributes.report_dsp_type,33)>
         <cfif len(subs_id_list)>
           <cfset subs_id_list=listsort(subs_id_list,"numeric","ASC",",")>
           <cfquery name="get_subs_pay" datasource="#dsn3#">
           SELECT MIN(PAYMENT_DATE) PAYMENT_DATE,MAX(PAYMENT_DATE) PAYMENT_DATE_2,SUBSCRIPTION_ID FROM SUBSCRIPTION_PAYMENT_PLAN_ROW WHERE SUBSCRIPTION_ID IN (#subs_id_list#) GROUP BY SUBSCRIPTION_ID ORDER BY SUBSCRIPTION_ID
           </cfquery>
           <cfset subs_id_list_2 = valuelist(get_subs_pay.SUBSCRIPTION_ID)>
         </cfif>
       </cfif>
       <cfif listfind(attributes.report_dsp_type,24)>
         <cfif len(subs_cancel_list)>
           <cfset subs_cancel_list=listsort(subs_cancel_list,"numeric","ASC",",")>
           <cfquery name="get_subs_cancel" datasource="#dsn3#">
           SELECT SUBSCRIPTION_CANCEL_TYPE FROM SETUP_SUBSCRIPTION_CANCEL_TYPE WHERE SUBSCRIPTION_CANCEL_TYPE_ID IN (#subs_cancel_list#) ORDER BY SUBSCRIPTION_CANCEL_TYPE_ID
           </cfquery>
         </cfif>
       </cfif>
       <cfif listfind("1,16",attributes.report_type)>
         <cfif len(subs_extra_list)>
           <cfset subs_extra_list=listsort(subs_extra_list,"numeric","ASC",",")>
           <cfquery name="get_subs_extra" datasource="#dsn3#">
           SELECT SUBSCRIPTION_ID,PROPERTY1,PROPERTY2,PROPERTY3,PROPERTY4,PROPERTY5,PROPERTY6,PROPERTY7,PROPERTY8,PROPERTY9,PROPERTY10 FROM SUBSCRIPTION_INFO_PLUS WHERE SUBSCRIPTION_ID IN (#subs_extra_list#) ORDER BY SUBSCRIPTION_ID
           </cfquery>
         </cfif>
         <cfset subs_extra_list = valuelist(get_subs_extra.SUBSCRIPTION_ID)>
       </cfif>
       <cfif len(company_id_list)>
         <cfset company_id_list=listsort(company_id_list,"numeric","ASC",",")>
         <cfquery name="get_comp_detail" datasource="#dsn#">
         SELECT
         COMPANY.FULLNAME,
           COMPANY.MEMBER_CODE,
           COMPANY_CAT.COMPANYCAT,
           COMPANY.OZEL_KOD,
           COMPANY.OZEL_KOD_1,
           COMPANY.OZEL_KOD_2
         FROM
           COMPANY,
           COMPANY_CAT
         WHERE
           COMPANY.COMPANYCAT_ID = COMPANY_CAT.COMPANYCAT_ID AND
           COMPANY.COMPANY_ID IN (#company_id_list#)
         ORDER BY
           COMPANY.COMPANY_ID
         </cfquery>
         <cfif listfind(attributes.report_dsp_type,2)>
           <cfquery name="get_comp_size" datasource="#dsn#">
           SELECT
             SETUP_COMPANY_SIZE_CATS.COMPANY_SIZE_CAT
           FROM
             COMPANY,
             SETUP_COMPANY_SIZE_CATS
           WHERE
             COMPANY.COMPANY_SIZE_CAT_ID = SETUP_COMPANY_SIZE_CATS.COMPANY_SIZE_CAT_ID AND
             COMPANY.COMPANY_ID IN (#company_id_list#)
         ORDER BY
             COMPANY.COMPANY_ID
           </cfquery>
         </cfif>
         <cfif listfind(attributes.report_dsp_type,3)>
           <cfquery name="get_comp_resource" datasource="#dsn#">
           SELECT
             COMPANY_PARTNER_RESOURCE.RESOURCE
           FROM
             COMPANY,
             COMPANY_PARTNER_RESOURCE
           WHERE
             COMPANY.RESOURCE_ID = COMPANY_PARTNER_RESOURCE.RESOURCE_ID AND
             COMPANY.COMPANY_ID IN (#company_id_list#)
         ORDER BY
             COMPANY.COMPANY_ID
           </cfquery>
         </cfif>
         <cfif listfind(attributes.report_dsp_type,33) or listfind(attributes.report_dsp_type,34) or listfind(attributes.report_dsp_type,35)>
           <cfquery name="get_comp_remainder" datasource="#dsn2#">
           SELECT
             SUM(BORC-ALACAK) BAKIYE,
             SUM(BORC) BORC,
             SUM(ALACAK) ALACAK,
             COMPANY_ID
           FROM
         (
           SELECT
             SUM(C.ACTION_VALUE) AS BORC,
             0 AS ALACAK,
             C.TO_CMP_ID AS COMPANY_ID
           FROM
             CARI_ROWS C
           WHERE
             C.TO_CMP_ID IS NOT NULL AND
             C.TO_CMP_ID IN (#company_id_list#)
         <cfif len(attributes.ch_date_1) and len(attributes.ch_date_2)>
                 AND C.ACTION_DATE BETWEEN #attributes.ch_date_1# AND #attributes.ch_date_2#
                 <cfelseif len(attributes.ch_date_1)>
                 AND C.ACTION_DATE >= #attributes.ch_date_1#
                 <cfelseif len(attributes.ch_date_2)>
                 AND C.ACTION_DATE <= #attributes.ch_date_2#
               </cfif>
           GROUP BY
             C.TO_CMP_ID
           UNION ALL
           SELECT
             0 AS BORC,
             SUM(C.ACTION_VALUE) AS ALACAK,
             C.FROM_CMP_ID AS COMPANY_ID
           FROM
             CARI_ROWS C
           WHERE
             C.FROM_CMP_ID IS NOT NULL AND
             C.FROM_CMP_ID IN (#company_id_list#)
           <cfif len(attributes.ch_date_1) and len(attributes.ch_date_2)>
             AND C.ACTION_DATE BETWEEN #attributes.ch_date_1# AND #attributes.ch_date_2#
             <cfelseif len(attributes.ch_date_1)>
             AND C.ACTION_DATE >= #attributes.ch_date_1#
             <cfelseif len(attributes.ch_date_2)>
             AND C.ACTION_DATE <= #attributes.ch_date_2#
           </cfif>
           GROUP BY
             C.FROM_CMP_ID
           )T1
         GROUP BY
           COMPANY_ID
         ORDER BY
           COMPANY_ID
           </cfquery>
           <cfset comp_new_list = valuelist(get_comp_remainder.COMPANY_ID)>
         </cfif>
       </cfif>
       <cfif len(consumer_id_list)>
         <cfset consumer_id_list=listsort(consumer_id_list,"numeric","ASC",",")>
         <cfquery name="get_cons_detail" datasource="#dsn#">
           SELECT
               CONSUMER.CONSUMER_NAME,
               CONSUMER.CONSUMER_SURNAME,
               CONSUMER.MEMBER_CODE,
               CONSUMER_CAT.CONSCAT,
               CONSUMER.OZEL_KOD
           FROM
               CONSUMER,
               CONSUMER_CAT
           WHERE
               CONSUMER.CONSUMER_CAT_ID = CONSUMER_CAT.CONSCAT_ID AND
               CONSUMER.CONSUMER_ID IN (#consumer_id_list#)
           ORDER BY
             CONSUMER.CONSUMER_ID
         </cfquery>
         <cfif listfind(attributes.report_dsp_type,2)>
           <cfquery name="get_cons_size" datasource="#dsn#">
           SELECT
             CONSUMER.COMPANY_SIZE_CAT_ID,
             SETUP_COMPANY_SIZE_CATS.COMPANY_SIZE_CAT
           FROM
             CONSUMER,
             SETUP_COMPANY_SIZE_CATS
           WHERE
             CONSUMER.COMPANY_SIZE_CAT_ID = SETUP_COMPANY_SIZE_CATS.COMPANY_SIZE_CAT_ID AND
             CONSUMER.CONSUMER_ID IN (#consumer_id_list#)
           ORDER BY
             CONSUMER.CONSUMER_ID
           </cfquery>
         </cfif>
         <cfif listfind(attributes.report_dsp_type,3)>
           <cfquery name="get_cons_resource" datasource="#dsn#">
           SELECT
             COMPANY_PARTNER_RESOURCE.RESOURCE
           FROM
             CONSUMER,
             COMPANY_PARTNER_RESOURCE
           WHERE
             CONSUMER.RESOURCE_ID = COMPANY_PARTNER_RESOURCE.RESOURCE_ID AND
             CONSUMER.CONSUMER_ID IN (#consumer_id_list#)
         ORDER BY
             CONSUMER.CONSUMER_ID
           </cfquery>
         </cfif>
         <cfif listfind(attributes.report_dsp_type,33) or listfind(attributes.report_dsp_type,34) or listfind(attributes.report_dsp_type,35)>
           <cfquery name="get_cons_remainder" datasource="#dsn2#">
           SELECT
             SUM(BORC-ALACAK) BAKIYE,
             SUM(BORC) BORC,
             SUM(ALACAK) ALACAK,
             CONSUMER_ID
           FROM
           (
             SELECT
             SUM(C.ACTION_VALUE) AS BORC,
             0 AS ALACAK,
             C.TO_CONSUMER_ID AS CONSUMER_ID
             FROM
               CARI_ROWS C
             WHERE
               C.TO_CONSUMER_ID IS NOT NULL AND
               C.TO_CONSUMER_ID IN (#consumer_id_list#)
           <cfif len(attributes.ch_date_1) and len(attributes.ch_date_2)>
                     AND C.ACTION_DATE BETWEEN #attributes.ch_date_1# AND #attributes.ch_date_2#
                     <cfelseif len(attributes.ch_date_1)>
                     AND C.ACTION_DATE >= #attributes.ch_date_1#
                     <cfelseif len(attributes.ch_date_2)>
                     AND C.ACTION_DATE <= #attributes.ch_date_2#
                   </cfif>
           GROUP BY
             C.TO_CONSUMER_ID
     UNION ALL
       SELECT
         0 AS BORC,
         SUM(C.ACTION_VALUE) AS ALACAK,
         C.FROM_CONSUMER_ID AS CONSUMER_ID
         FROM
           CARI_ROWS C
         WHERE
           C.FROM_CONSUMER_ID IS NOT NULL AND
           C.FROM_CONSUMER_ID IN (#consumer_id_list#)
           <cfif len(attributes.ch_date_1) and len(attributes.ch_date_2)>
             AND C.ACTION_DATE BETWEEN #attributes.ch_date_1# AND #attributes.ch_date_2#
             <cfelseif len(attributes.ch_date_1)>
             AND C.ACTION_DATE >= #attributes.ch_date_1#
             <cfelseif len(attributes.ch_date_2)>
             AND C.ACTION_DATE <= #attributes.ch_date_2#
           </cfif>
           GROUP BY
           C.FROM_CONSUMER_ID
           )T1
         GROUP BY
           CONSUMER_ID
         ORDER BY
           CONSUMER_ID
           </cfquery>
           <cfset cons_new_list = valuelist(get_cons_remainder.CONSUMER_ID)>
         </cfif>
       </cfif>
     </cfif>
       <thead>
         <tr>
           <th><cf_get_lang_main no='75.No'></th>
           <th><cf_get_lang_main no="1420.Abone"><cf_get_lang_main no='75.No'></th>
           <cfif attributes.report_type eq 16>
             <th><cf_get_lang_main no='809.Urun Adi'></th>
             <th><cf_get_lang_main no='223.Miktar'></th>
             <th><cf_get_lang_main no='224.Birim'></th>
             <th><cf_get_lang_main no='672.Fiyat'></th>
             <th><cf_get_lang_main no='261.Tutar'></th>
             <th><cf_get_lang_main no='77.Para Birimi'></th>
             <th><cf_get_lang_main no='265.Dviz'><cf_get_lang_main no='672.Fiyat'></th>
             <th><cf_get_lang_main no='265.Dviz'><cf_get_lang_main no='261.Tutar'></th>
             <th><cf_get_lang_main no='77.Para Birimi'></th>
             <cfif len(session.ep.money2)>
               <th><cfoutput>#session.ep.money2#</cfoutput><cf_get_lang_main no='261.Tutar'></th>
               <th><cf_get_lang_main no='77.Para Birimi'></th>
             </cfif>
             <th><cfoutput>#session.ep.money#</cfoutput><cf_get_lang_main no='261.Tutar'></th>
             <th><cf_get_lang no='1302.Ek Maliyet'></th>
             <cfif len(session.ep.money2)>
               <th><cfoutput>#session.ep.money2#</cfoutput><cf_get_lang no='1302.Ek Maliyet'></th>
             </cfif>
           </cfif>
           <cfif listfind(attributes.report_dsp_type,1)>
             <th><cf_get_lang_main no='1197.ye Kategorisi'></th>
             <cfset colspan_info = colspan_info + 1>
           </cfif>
           <cfif listfind(attributes.report_dsp_type,2)>
             <th><cf_get_lang no='568.ye Sirket Byklg'><cfset colspan_info = colspan_info + 1></th>
           </cfif>
           <cfif listfind(attributes.report_dsp_type,3)>
             <th><cf_get_lang no='503.Iliski Tipi'></th>
             <cfset colspan_info = colspan_info + 1>
           </cfif>
           <cfif listfind(attributes.report_dsp_type,4)>
             <th><cf_get_lang no='569.ye Kodu'></th>
             <cfset colspan_info = colspan_info + 1>
           </cfif>
           <cfif listfind(attributes.report_dsp_type,5)>
             <th><cf_get_lang no='571.ye Adi'></th>
             <cfset colspan_info = colspan_info + 1>
           </cfif>
           <cfif listfind(attributes.report_dsp_type,45)>
            <th>Üye Özel Kod</th>
            <th>Üye Özel Kod 2</th>
            <th>Üye Özel Kod 3</th>
            <cfset colspan_info = colspan_info + 3>
          </cfif>
           <cfif listfind(attributes.report_dsp_type,6)>
             <th><cf_get_lang no='502.Satis Ortagi'>
           <cfset colspan_info = colspan_info + 1>
             </th>
           </cfif>
           <cfif listfind(attributes.report_dsp_type,27)>
             <th><cf_get_lang no='1823.Satis Ort Komisyonu'></th>
             <th><cf_get_lang_main no='77.Para Birimi'></th>
             <cfif len(session.ep.money2)>
               <th><cfoutput>#session.ep.money2#</cfoutput><cf_get_lang no='1823.Satis Ort Komisyonu'></th>
             </cfif>
           </cfif>
           <cfif listfind(attributes.report_dsp_type,7)>
             <th><cf_get_lang no='564.Satis Takimi'></th>
           </cfif>
           <cfif listfind(attributes.report_dsp_type,8)>
             <th><cf_get_lang no='482.Satis Temsilcisi'></th>
           </cfif>
           <cfif listfind(attributes.report_dsp_type,44) and attributes.report_type eq 1>
               <th><cf_get_lang no='1363.Abone Özel Tanımı'></th>
             </cfif>
           <cfif listfind(attributes.report_dsp_type,9)>
             <th><cf_get_lang no='1364.abone Kategorisi'></th>
           </cfif>
           <cfif listfind(attributes.report_dsp_type,10)>
             <th><cf_get_lang no='1404.Abone Aşaması'></th>
           </cfif>
           <cfif listfind(attributes.report_dsp_type,11)>
             <th><cf_get_lang no='1403.Abone Durumu'></th>
           </cfif>
           <cfif listfind(attributes.report_dsp_type,12)>
             <th><cf_get_lang_main no='1420.Abone'>ID</th>
           </cfif>
           <cfif listfind(attributes.report_dsp_type,13)>
             <th><cf_get_lang_main no='1420.Abone'><cf_get_lang_main no='821.Tanimi'></th>
           </cfif>
           <cfif listfind(attributes.report_dsp_type,14)>
             <th><cf_get_lang_main no='377.Ozel Kod'></th>
           </cfif>
           <cfif listfind(attributes.report_dsp_type,15)>
             <th><cf_get_lang no='573.Referans Msteri Kodu'></th>
           </cfif>
           <cfif listfind(attributes.report_dsp_type,16)>
             <th><cf_get_lang no='576.Referans Msteri Adi'></th>
           </cfif>
           <cfif listfind(attributes.report_dsp_type,17)>
             <th><cf_get_lang_main no='1104.Odeme Yontemi'></th>
           </cfif>
           <cfif listfind(attributes.report_dsp_type,18)>
             <th><cf_get_lang_main no='2247.Szlesme Numarasi'></th>
           </cfif>
           <cfif listfind(attributes.report_dsp_type,19)>
             <th><cf_get_lang_main no='335.Szlesme Tarihi'></th>
           </cfif>
           <cfif listfind(attributes.report_dsp_type,20)>
             <th><cf_get_lang dictionary_id='60559.Kurulum Tarihi'></th>
           </cfif>
           <cfif listfind(attributes.report_dsp_type,21)>
             <th><cf_get_lang no='532.deme Plani Baslangi Tarihi'></th>
           </cfif>
           <cfif listfind(attributes.report_dsp_type,33)>
             <th>Ödeme Plani Bitis Tarihi</th>
           </cfif>
           <cfif listfind(attributes.report_dsp_type,22)>
             <th><cf_get_lang no='469.Prim Tarihi'></th>
           </cfif>
           <cfif listfind(attributes.report_dsp_type,23)>
             <th><cf_get_lang_main no='336.Iptal Tarihi'></th>
           </cfif>
           <cfif listfind(attributes.report_dsp_type,24)>
             <th><cf_get_lang_main no='1413.Iptal Nedeni'></th>
           </cfif>
           <cfif listfind(attributes.report_dsp_type,25)>
             <th><cf_get_lang_main no='217.Aiklama'></th>
           </cfif>
           <cfif listfind(attributes.report_dsp_type,26)>
             <th><cf_get_lang no='1405.Abone Kullanım Süresi'></th>
           </cfif>
           <cfif listfind(attributes.report_dsp_type,28)>
             <th><cf_get_lang_main no='398.Ek Bilgi'>1</th>
           </cfif>
           <cfif listfind(attributes.report_dsp_type,29)>
             <th><cf_get_lang_main no='398.Ek Bilgi'>2</th>
           </cfif>
           <cfif listfind(attributes.report_dsp_type,30)>
             <th><cf_get_lang_main no='398.Ek Bilgi'>3</th>
           </cfif>
           <cfif listfind(attributes.report_dsp_type,31)>
             <th><cf_get_lang_main no='398.Ek Bilgi'>4</th>
           </cfif>
           <cfif listfind(attributes.report_dsp_type,32)>
             <th><cf_get_lang_main no='398.Ek Bilgi'>5</th>
           </cfif>
           <cfif listfind(attributes.report_dsp_type,39)>
             <th><cf_get_lang_main no='398.Ek Bilgi'>6</th>
           </cfif>
           <cfif listfind(attributes.report_dsp_type,40)>
             <th><cf_get_lang_main no='398.Ek Bilgi'>7</th>
           </cfif>
           <cfif listfind(attributes.report_dsp_type,41)>
             <th><cf_get_lang_main no='398.Ek Bilgi'>8</th>
           </cfif>
           <cfif listfind(attributes.report_dsp_type,42)>
             <th><cf_get_lang_main no='398.Ek Bilgi'>9</th>
           </cfif>
           <cfif listfind(attributes.report_dsp_type,43)>
             <th><cf_get_lang_main no='398.Ek Bilgi'>10</th>
           </cfif>
           <cfif listfind(attributes.report_dsp_type,33)>
             <th><cf_get_lang_main no='175.Bor'>
             <cfoutput>#session.ep.money#</cfoutput></th>
           </cfif>
           <cfif listfind(attributes.report_dsp_type,34)>
             <th><cf_get_lang_main no='176.Alacak'>
             <cfoutput>#session.ep.money#</cfoutput></th>
           </cfif>
           <cfif listfind(attributes.report_dsp_type,35)>
             <th><cf_get_lang_main no='177.Bakiye'>
             <cfoutput>#session.ep.money#</cfoutput></th>
             <th></th>
           </cfif>
           <cfif listfind(attributes.report_dsp_type,36)>
             <th><cf_get_lang dictionary_id='60564.Ödenmemiş Fatura Tutarı'></th>
           </cfif>
           <cfif listfind(attributes.report_dsp_type,37)>
             <th><cf_get_lang dictionary_id='60565.Ödenmemiş Fatura Sayısı'></th>
           </cfif>
           <cfif listfind(attributes.report_dsp_type,38)>
             <th><cf_get_lang dictionary_id='60563.Kurulum Adresi'></th>
           <th><cf_get_lang no='10.Fatura Adresi'></th>
             <th><cf_get_lang no='39.İrtibat Adresi'></th>
           </cfif>
         </tr>
       </thead>
 <cfif get_total_purchase.recordcount and listfind("1,16",attributes.report_type)>
       <cfif isdefined("attributes.form_submitted") and get_total_purchase.recordcount>
       <cfset alt_toplam = 0>
       <cfset alt_toplam_2 = 0>
       <cfset cost_toplam = 0>
       <cfset cost_toplam_2 = 0>
       <cfset comm_toplam = 0>
       <cfset comm_toplam_2 = 0>
       <cfset system_total = 0>
       <tbody>
         <cfoutput query="get_total_purchase" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
           <tr>
             <td>#currentrow#</td>
             <td>
             <cfif isdefined('attributes.is_excel') and attributes.is_excel eq 1>
               #SUBSCRIPTION_NO#
               <cfelse>
               <a href="#request.self#?fuseaction=sales.list_subscription_contract&event=upd&subscription_id=#subscription_id#" target="_blank">#SUBSCRIPTION_NO#</a>
             </cfif>
             </td>
             <cfif attributes.report_type eq 16>
               <td>#PRODUCT_NAME#</td>
               <td style="text-align:center">#AMOUNT#</td>
               <td style="text-align:center">#UNIT#</td>
               <td style="text-align:right;" format="numeric">#TLFormat(PRICE)#</td>
               <td style="text-align:right;" format="numeric">#TLFormat(PRICE*AMOUNT)#</td>
               <cfset alt_toplam = alt_toplam + (PRICE*AMOUNT)>
               <td style="text-align:center">#session.ep.money#</td>
               <td style="text-align:right;" format="numeric">#TLFormat(PRICE_OTHER)#</td>
               <td style="text-align:right;" format="numeric">#TLFormat(PRICE_OTHER*AMOUNT)#</td>
               <td style="text-align:center">#OTHER_MONEY#</td>
               <cfif len(session.ep.money2)>
                 <td style="text-align:right;" format="numeric">#TLFormat((ACTIVE_VALUE*AMOUNT)/GET_MONEY2.RATE2)#</td>
                 <td style="text-align:center">#session.ep.money2#</td>
                 <cfset alt_toplam_2 = alt_toplam_2 + ((ACTIVE_VALUE*AMOUNT)/GET_MONEY2.RATE2)>
               </cfif>
               <td style="text-align:right;" format="numeric">#TLFormat(ACTIVE_VALUE*AMOUNT)#
               <cfset system_total = system_total + (ACTIVE_VALUE*AMOUNT)>
               </td>
               <td style="text-align:right;" format="numeric">
               <cfif len(EXTRA_COST)>#TLFormat(EXTRA_COST)#<cfset cost_toplam = cost_toplam + EXTRA_COST></cfif>
               </td>
               <cfif len(session.ep.money2)>
                 <td style="text-align:right;" format="numeric">
                 <cfif len(EXTRA_COST)>#TLFormat(EXTRA_COST/GET_MONEY2.RATE2)#<cfset cost_toplam_2 = cost_toplam_2 + (EXTRA_COST/GET_MONEY2.RATE2)></cfif>
                 </td>
               </cfif>
             </cfif>
             <cfif listfind(attributes.report_dsp_type,1)>
               <td>
               <cfif len(company_id_list) and len(COMPANY_ID)>
                 #get_comp_detail.COMPANYCAT[listfind(company_id_list,COMPANY_ID,',')]#
                 <cfelseif len(consumer_id_list) and len(CONSUMER_ID)>
                 #get_cons_detail.CONSCAT[listfind(consumer_id_list,CONSUMER_ID,',')]#
               </cfif>
               </td>
             </cfif>
             <cfif listfind(attributes.report_dsp_type,2)>
               <td>
               <cfif len(company_id_list) and len(COMPANY_ID)>
                 #get_comp_size.COMPANY_SIZE_CAT[listfind(company_id_list,COMPANY_ID,',')]#
                 <cfelseif len(consumer_id_list) and len(CONSUMER_ID)>
                 #get_cons_size.COMPANY_SIZE_CAT[listfind(consumer_id_list,CONSUMER_ID,',')]#
               </cfif>
               </td>
             </cfif>
             <cfif listfind(attributes.report_dsp_type,3)>
               <td>
               <cfif len(company_id_list) and len(COMPANY_ID)>
                 #get_comp_resource.RESOURCE[listfind(company_id_list,COMPANY_ID,',')]#
                 <cfelseif len(consumer_id_list) and len(CONSUMER_ID)>
                 #get_cons_resource.RESOURCE[listfind(consumer_id_list,CONSUMER_ID,',')]#
               </cfif>
               </td>
             </cfif>
             <cfif listfind(attributes.report_dsp_type,4)>
               <td>
               <cfif len(company_id_list) and len(COMPANY_ID)>
                 #get_comp_detail.MEMBER_CODE[listfind(company_id_list,COMPANY_ID,',')]#
                 <cfelseif len(consumer_id_list) and len(CONSUMER_ID)>
                 #get_cons_detail.MEMBER_CODE[listfind(consumer_id_list,CONSUMER_ID,',')]#
               </cfif>
               </td>
             </cfif>
             <cfif listfind(attributes.report_dsp_type,5)>
               <td>
               <cfif len(company_id_list) and len(COMPANY_ID)>
                 <cfif isdefined('attributes.is_excel') and attributes.is_excel eq 1>
                   #get_comp_detail.FULLNAME[listfind(company_id_list,COMPANY_ID,',')]#
                   <cfelse>
                   <a href="javascript://" onclick="windowopen('#request.self#?fuseaction=objects.popup_com_det&company_id=#COMPANY_ID#','medium');"> #get_comp_detail.FULLNAME[listfind(company_id_list,COMPANY_ID,',')]#</a>
                 </cfif>
                 <cfelseif len(consumer_id_list) and len(CONSUMER_ID)>
                 <cfif isdefined('attributes.is_excel') and attributes.is_excel eq 1>
                   #get_cons_detail.CONSUMER_NAME[listfind(consumer_id_list,CONSUMER_ID,',')]# #get_cons_detail.CONSUMER_SURNAME[listfind(consumer_id_list,CONSUMER_ID,',')]#
                   <cfelse>
                   <a href="javascript://" onclick="windowopen('#request.self#?fuseaction=objects.popup_con_det&con_id=#CONSUMER_ID#','medium');"> #get_cons_detail.CONSUMER_NAME[listfind(consumer_id_list,CONSUMER_ID,',')]# #get_cons_detail.CONSUMER_SURNAME[listfind(consumer_id_list,CONSUMER_ID,',')]# </a>
                 </cfif>
               </cfif>
               </td>
             </cfif>
             <cfif listfind(attributes.report_dsp_type,45)>
              <td>
              <cfif len(company_id_list) and len(COMPANY_ID)>
                #get_comp_detail.OZEL_KOD[listfind(company_id_list,COMPANY_ID,',')]#
                <cfelseif len(consumer_id_list) and len(CONSUMER_ID)>
                #get_cons_detail.OZEL_KOD[listfind(consumer_id_list,CONSUMER_ID,',')]#
              </cfif>
              </td>
              <td>
                <cfif len(company_id_list) and len(COMPANY_ID)>
                  #get_comp_detail.OZEL_KOD_1[listfind(company_id_list,COMPANY_ID,',')]#
                </cfif>
              </td>
              <td>
                <cfif len(company_id_list) and len(COMPANY_ID)>
                  #get_comp_detail.OZEL_KOD_2[listfind(company_id_list,COMPANY_ID,',')]#
                </cfif>
              </td>
            </cfif>
             <cfif listfind(attributes.report_dsp_type,6)>
             <td>
                 <cfif len(sales_comp_id_list) and len(SALES_COMPANY_ID)>
                   <cfif isdefined('attributes.is_excel') and attributes.is_excel eq 1>
                   #get_comp_sales.FULLNAME[listfind(sales_comp_id_list_2,SALES_COMPANY_ID,',')]#
                   <cfelse>
                   <a href="javascript://" onclick="windowopen('#request.self#?fuseaction=objects.popup_com_det&company_id=#SALES_COMPANY_ID#','medium');"> #get_comp_sales.FULLNAME[listfind(sales_comp_id_list_2,SALES_COMPANY_ID,',')]#</a>
                   </cfif>
                 <cfelseif len(sales_cons_id_list) and len(SALES_CONSUMER_ID)>
                   <cfif isdefined('attributes.is_excel') and attributes.is_excel eq 1>
                   #get_cons_sales.CONSUMER_NAME[listfind(sales_cons_id_list_2,SALES_CONSUMER_ID,',')]# #get_cons_sales.CONSUMER_SURNAME[listfind(sales_cons_id_list_2,SALES_CONSUMER_ID,',')]#
                   <cfelse>
                   <a href="javascript://" onclick="windowopen('#request.self#?fuseaction=objects.popup_cons_det&consumer_id=#SALES_CONSUMER_ID#','medium');"> #get_cons_sales.CONSUMER_NAME[listfind(sales_cons_id_list_2,SALES_CONSUMER_ID,',')]# #get_cons_sales.CONSUMER_SURNAME[listfind(sales_cons_id_list_2,SALES_CONSUMER_ID,',')]# </a>
                   </cfif>
                 </cfif>
             </td>
             </cfif>
               <cfif listfind(attributes.report_dsp_type,27)>
                 <td style="text-align:right;" format="numeric">
               <cfif len(SALES_MEMBER_COMM_VALUE) and SUBSCRIPTION_ID[currentrow-1] neq SUBSCRIPTION_ID>
                 #TLFormat(SALES_MEMBER_COMM_VALUE)#
                 <cfset comm_toplam = comm_toplam + SALES_MEMBER_COMM_VALUE>
               </cfif>
                 </td>
                 <td>
               <cfif len(SALES_MEMBER_COMM_VALUE) and SUBSCRIPTION_ID[currentrow-1] neq SUBSCRIPTION_ID>
                 #SALES_MEMBER_COMM_MONEY#
               </cfif>
               </td>
               <cfif len(session.ep.money2)>
                 <td style="text-align:right;" format="numeric">
               <cfif len(SALES_MEMBER_COMM_VALUE) and SUBSCRIPTION_ID[currentrow-1] neq SUBSCRIPTION_ID>
               #TLFormat((SALES_MEMBER_COMM_VALUE*evaluate('rafe_info_#SALES_MEMBER_COMM_MONEY#'))/GET_MONEY2.RATE2)#
               <cfset comm_toplam_2 = comm_toplam_2 + ((SALES_MEMBER_COMM_VALUE*evaluate('rafe_info_#SALES_MEMBER_COMM_MONEY#'))/GET_MONEY2.RATE2)>
               </cfif>
                 </td>
               </cfif>
             </cfif>
             <cfif listfind(attributes.report_dsp_type,7)>
               <td>
               <cfif len(sales_emp_id_list) and len(SALES_EMP_ID)>
                 #get_sales_team.TEAM_NAME[listfind(sales_emp_id_list_2,SALES_EMP_ID,',')]#
               </cfif>
               </td>
             </cfif>
             <cfif listfind(attributes.report_dsp_type,8)>
               <td>
             <cfif len(sales_emp_id_list) and len(SALES_EMP_ID)>
               #get_emp_sales.EMPLOYEE_NAME[listfind(sales_emp_id_list,SALES_EMP_ID,',')]# #get_emp_sales.EMPLOYEE_SURNAME[listfind(sales_emp_id_list,SALES_EMP_ID,',')]#
             </cfif>
               </td>
             </cfif>
             <cfif listfind(attributes.report_dsp_type,44) and attributes.report_type eq 1>
               <td>#SUBSCRIPTION_ADD_OPTION_NAME#</td>
             </cfif>
             <cfif listfind(attributes.report_dsp_type,9)>
               <td>#get_cat_types.SUBSCRIPTION_TYPE[listfind(s_cat_id_list,SUBSCRIPTION_TYPE_ID,',')]#</td>
             </cfif>
             <cfif listfind(attributes.report_dsp_type,10)>
               <td>
               <cfif len(s_stage_id_list)>
               </cfif>
               #get_stage_types.STAGE[listfind(s_stage_id_list,SUBSCRIPTION_STAGE,',')]#</td>
             </cfif>
             <cfif listfind(attributes.report_dsp_type,11)>
               <td>
             <cfif IS_ACTIVE eq 1>
               <cf_get_lang_main no='81.Aktif'>
               <cfelse>
               <cf_get_lang_main no='82.Pasif'>
             </cfif>
               </td>
             </cfif>
             <cfif listfind(attributes.report_dsp_type,12)>
               <td>#SUBSCRIPTION_ID#</td>
             </cfif>
             <cfif listfind(attributes.report_dsp_type,13)>
               <td>#SUBSCRIPTION_HEAD#</td>
             </cfif>
             <cfif listfind(attributes.report_dsp_type,14)>
               <td>#SPECIAL_CODE#</td>
             </cfif>
             <cfif listfind(attributes.report_dsp_type,15)>
               <td>
               <cfif len(ref_comp_id_list) and len(REF_COMPANY_ID)>
                 #get_refs_comp.MEMBER_CODE[listfind(ref_comp_id_list,REF_COMPANY_ID,',')]#
                 <cfelseif len(ref_cons_id_list) and len(REF_CONSUMER_ID)>
                 #get_refs_cons.CONSUMER_NAME[listfind(ref_cons_id_list,REF_CONSUMER_ID,',')]#
                 <cfelseif len(ref_emp_id_list) and len(REF_EMPLOYEE_ID)>
                 #get_refs_emp.EMPLOYEE_NAME[listfind(ref_emp_id_list,REF_EMPLOYEE_ID,',')]#
               </cfif>
               </td>
             </cfif>
             <cfif listfind(attributes.report_dsp_type,16)>
               <td>
               <cfif len(ref_comp_id_list) and len(REF_COMPANY_ID)>
                 #get_refs_comp.FULLNAME[listfind(ref_comp_id_list,REF_COMPANY_ID,',')]#
                 <cfelseif len(ref_cons_id_list) and len(REF_CONSUMER_ID)>
                 #get_refs_cons.CONSUMER_NAME[listfind(ref_cons_id_list,REF_CONSUMER_ID,',')]# #get_refs_cons.CONSUMER_SURNAME[listfind(ref_cons_id_list,REF_CONSUMER_ID,',')]#
                 <cfelseif len(ref_emp_id_list) and len(REF_EMPLOYEE_ID)>
                 #get_refs_emp.EMPLOYEE_NAME[listfind(ref_emp_id_list,REF_EMPLOYEE_ID,',')]# #get_refs_emp.EMPLOYEE_SURNAME[listfind(ref_emp_id_list,REF_EMPLOYEE_ID,',')]#
               </cfif>
               </td>
             </cfif>
             <cfif listfind(attributes.report_dsp_type,17)>
               <td>
               <cfif len(pay_type_id_list)>
                 #get_pay_types.PAYMETHOD[listfind(pay_type_id_list,PAYMENT_TYPE_ID,',')]#
               </cfif>
               </td>
             </cfif>
             <cfif listfind(attributes.report_dsp_type,18)>
               <td>#CONTRACT_NO#</td>
             </cfif>
             <cfif listfind(attributes.report_dsp_type,19)>
               <td>#dateformat(START_DATE,dateformat_style)#</td>
             </cfif>
             <cfif listfind(attributes.report_dsp_type,20)>
               <td>#dateformat(MONTAGE_DATE,dateformat_style)#</td>
             </cfif>
             <cfif listfind(attributes.report_dsp_type,21)>
               <td>
               <cfif len(subs_id_list)>
                 #dateformat(get_subs_pay.PAYMENT_DATE[listfind(subs_id_list_2,SUBSCRIPTION_ID,',')],dateformat_style)#
               </cfif>
               </td>
             </cfif>
             <cfif listfind(attributes.report_dsp_type,33)>
               <td>
               <cfif len(subs_id_list)>
                 #dateformat(get_subs_pay.PAYMENT_DATE_2[listfind(subs_id_list_2,SUBSCRIPTION_ID,',')],dateformat_style)#
               </cfif>
               </td>
             </cfif>
             <cfif listfind(attributes.report_dsp_type,22)>
               <td>#dateformat(PREMIUM_DATE,dateformat_style)#</td>
             </cfif>
             <cfif listfind(attributes.report_dsp_type,23)>
               <td>#dateformat(CANCEL_DATE,dateformat_style)#</td>
             </cfif>
             <cfif listfind(attributes.report_dsp_type,24)>
               <td>
               <cfif len(subs_cancel_list)>
                 #get_subs_cancel.SUBSCRIPTION_CANCEL_TYPE[listfind(subs_cancel_list,CANCEL_TYPE_ID,',')]#
               </cfif>
               </td>
             </cfif>
             <cfif listfind(attributes.report_dsp_type,25)>
               <td>#SUBSCRIPTION_DETAIL#</td>
             </cfif>
             <cfif listfind(attributes.report_dsp_type,26)>
               <td>
               <cfif len(START_DATE) and len(CANCEL_DATE)>
                 #datediff('d',START_DATE,CANCEL_DATE)#
                 <cf_get_lang_main no='78.Gn'>
               </cfif>
               </td>
             </cfif>
             <cfif listfind(attributes.report_dsp_type,28)>
               <td>
               <cfif len(subs_extra_list)>
                 #get_subs_extra.PROPERTY1[listfind(subs_extra_list,SUBSCRIPTION_ID,',')]#
               </cfif>
               </td>
             </cfif>
             <cfif listfind(attributes.report_dsp_type,29)>
               <td>
               <cfif len(subs_extra_list)>
                 #get_subs_extra.PROPERTY2[listfind(subs_extra_list,SUBSCRIPTION_ID,',')]#
               </cfif>
               </td>
             </cfif>
             <cfif listfind(attributes.report_dsp_type,30)>
               <td>
               <cfif len(subs_extra_list)>
                 #get_subs_extra.PROPERTY3[listfind(subs_extra_list,SUBSCRIPTION_ID,',')]#
               </cfif>
               </td>
             </cfif>
             <cfif listfind(attributes.report_dsp_type,31)>
               <td>
               <cfif len(subs_extra_list)>
                 #get_subs_extra.PROPERTY4[listfind(subs_extra_list,SUBSCRIPTION_ID,',')]#
               </cfif>
               </td>
             </cfif>
             <cfif listfind(attributes.report_dsp_type,32)>
               <td>
               <cfif len(subs_extra_list)>
                 #get_subs_extra.PROPERTY5[listfind(subs_extra_list,SUBSCRIPTION_ID,',')]#
               </cfif>
               </td>
             </cfif>
             <cfif listfind(attributes.report_dsp_type,39)>
               <td>
               <cfif len(subs_extra_list)>
                 #get_subs_extra.PROPERTY6[listfind(subs_extra_list,SUBSCRIPTION_ID,',')]#
               </cfif>
               </td>
             </cfif>
             <cfif listfind(attributes.report_dsp_type,40)>
               <td>
               <cfif len(subs_extra_list)>
                 #get_subs_extra.PROPERTY7[listfind(subs_extra_list,SUBSCRIPTION_ID,',')]#
               </cfif>
               </td>
             </cfif>
             <cfif listfind(attributes.report_dsp_type,41)>
               <td>
               <cfif len(subs_extra_list)>
                 #get_subs_extra.PROPERTY8[listfind(subs_extra_list,SUBSCRIPTION_ID,',')]#
               </cfif>
               </td>
             </cfif>
             <cfif listfind(attributes.report_dsp_type,42)>
               <td>
               <cfif len(subs_extra_list)>
                 #get_subs_extra.PROPERTY9[listfind(subs_extra_list,SUBSCRIPTION_ID,',')]#
               </cfif>
               </td>
             </cfif>
             <cfif listfind(attributes.report_dsp_type,43)>
               <td>
               <cfif len(subs_extra_list)>
                 #get_subs_extra.PROPERTY10[listfind(subs_extra_list,SUBSCRIPTION_ID,',')]#
               </cfif>
               </td>
             </cfif>
             <cfif listfind(attributes.report_dsp_type,33)>
               <td style="text-align:right" format="numeric">
               <cfif len(company_id_list) and len(COMPANY_ID)>
                 #tlformat(get_comp_remainder.borc[listfind(comp_new_list,COMPANY_ID,',')])#
                 <cfelseif len(consumer_id_list) and len(CONSUMER_ID)>
                 #tlformat(get_cons_remainder.borc[listfind(cons_new_list,CONSUMER_ID,',')])#
               </cfif>
               </td>
             </cfif>
             <cfif listfind(attributes.report_dsp_type,34)>
               <td style="text-align:right" format="numeric">
               <cfif len(company_id_list) and len(COMPANY_ID)>
                 #tlformat(get_comp_remainder.alacak[listfind(comp_new_list,COMPANY_ID,',')])#
                 <cfelseif len(consumer_id_list) and len(CONSUMER_ID)>
                 #tlformat(get_cons_remainder.alacak[listfind(cons_new_list,CONSUMER_ID,',')])#
               </cfif>
               </td>
             </cfif>
             <cfif listfind(attributes.report_dsp_type,35)>
               <td style="text-align:right" format="numeric">
               <cfset bakiye_ = 0>
               <cfif len(company_id_list) and len(COMPANY_ID) and len(get_comp_remainder.bakiye[listfind(comp_new_list,COMPANY_ID,',')])>
                 <cfset bakiye_ = get_comp_remainder.bakiye[listfind(comp_new_list,COMPANY_ID,',')]>
                 #tlformat(abs(get_comp_remainder.bakiye[listfind(comp_new_list,COMPANY_ID,',')]))#
                 <cfelseif len(consumer_id_list) and len(CONSUMER_ID) and len(get_cons_remainder.bakiye[listfind(cons_new_list,CONSUMER_ID,',')])>
                 <cfset bakiye_ = get_cons_remainder.bakiye[listfind(cons_new_list,CONSUMER_ID,',')]>
                 #tlformat(abs(get_cons_remainder.bakiye[listfind(cons_new_list,CONSUMER_ID,',')]))#
               </cfif>
               </td>
               <td align="center">
               <cfif bakiye_ gte 0>(B)<cfelse>(A)</cfif>
               </td>
             </cfif>
             <cfif listfind(attributes.report_dsp_type,36)>
               <td style="text-align:right" format="numeric"> #tlformat(invoice_total)# </td>
             </cfif>
             <cfif listfind(attributes.report_dsp_type,37)>
               <td style="text-align:right"> #invoice_count# </td>
             </cfif>
             <cfif listfind(attributes.report_dsp_type,38)>
             <td style="text-align:right"> #ship_address# </td>
               <td style="text-align:right"> #invoice_address# </td>
               <td style="text-align:right"> #contact_address# </td>
             </cfif>
           </tr>
         </cfoutput>
       </tbody>
       <cfif attributes.report_type eq 16>
       <tfoot>
         <cfoutput>
             <tr>
                 <td colspan="6" class="txtbold" style="text-align:right;"><cf_get_lang_main no='80.Toplam '>:</td>
                 <td nowrap class="txtbold" style="text-align:right;" format="numeric">#TLFormat(alt_toplam)#</td>
                 <td class="txtbold" style="text-align:center;">#session.ep.money#</td>
                 <cfif len(session.ep.money2)>
                   <td colspan="3"></td>
                   <td nowrap class="txtbold" style="text-align:right;" format="numeric">#TLFormat(alt_toplam_2)#</td>
                   <td class="txtbold" style="text-align:center;">#session.ep.money2#</td>
                 </cfif>
                 <td nowrap class="txtbold" style="text-align:right;" format="numeric">#TLFormat(system_total)#</td>
                 <td nowrap class="txtbold" style="text-align:right;" format="numeric">#TLFormat(cost_toplam)# #session.ep.money#</td>
                 <cfif len(session.ep.money2)>
                   <td nowrap class="txtbold" style="text-align:right;" format="numeric">#TLFormat(cost_toplam_2)# #session.ep.money2#</td>
                 </cfif>
                 <cfif listfind(attributes.report_dsp_type,27)>
                   <cfif colspan_info gt 0>
                     <td colspan="#colspan_info+1#"></td>
                   </cfif>
                   <cfif len(session.ep.money2)>
                     <td></td>
                     <td nowrap class="txtbold" style="text-align:right;" format="numeric">#TLFormat(comm_toplam_2)# #session.ep.money2#</td>
                   </cfif>
                 </cfif>
                 <cfif len(attributes.report_dsp_type)>
                   <td colspan="30"></td>
                 </cfif>
             </tr>
         </cfoutput>
       </tfoot>
       </cfif>
       <cfelseif get_total_purchase.recordcount and not listfind("1,16",attributes.report_type)>
       <!--- 1 harici rapor tipleri ayni --->
       <thead>
         <tr>
           <th><cf_get_lang_main no='75.No'></th>
           <th><cfoutput>#report_type_text#</cfoutput></th>
           <th><cf_get_lang_main no='1420.Abone'></th>
         </tr>
       </thead>
       <tbody>
       <cfoutput query="get_total_purchase" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
         <tr>
           <td>#currentrow#</td>
           <td>
           <cfif listfind('12,13,14,15',attributes.report_type)>
           #dateformat(REPORT_GROUP_TYPE,dateformat_style)#
           <cfelse>
           #REPORT_GROUP_TYPE#
           </cfif>
           </td>
           <td style="text-align:center">#SYSTEM_SAYISI#</td>
           <cfset sistem_toplam_sayisi = sistem_toplam_sayisi + SYSTEM_SAYISI>
         </tr>
       </cfoutput>
       </tbody>
       <tfoot>
         <tr>
           <td></td>
           <td class="txtbold" style="text-align:right"><cf_get_lang_main no='80.Toplam '>:</td>
           <td class="txtbold" style="text-align:center"><cfoutput>#sistem_toplam_sayisi#</cfoutput></td>
         </tr>
       </tfoot>
     </cfif>
 <cfelse>
       <td colspan="20"><cf_get_lang_main no='72.Kayıt Yok'>!</td>
 </cfif>
 </cf_report_list>
 </cfif>
 <cfset adres = "">
 <cfif isdefined("attributes.form_submitted") and attributes.totalrecords gt attributes.maxrows>
   <cfset adres = "report.system_analyse_report&form_submitted=1">
   <cfif len(attributes.pos_code)>
     <cfset adres = "#adres#&pos_code=#attributes.pos_code#&pos_code_text=#attributes.pos_code_text#">
   </cfif>
   <cfif len(attributes.date1)>
     <cfset adres = "#adres#&date1=#attributes.date1#">
   </cfif>
   <cfif len(attributes.date2)>
     <cfset adres = "#adres#&date2=#attributes.date2#">
   </cfif>
   <cfif len(attributes.date1_m)>
     <cfset adres = "#adres#&date1_m=#attributes.date1_m#">
   </cfif>
   <cfif len(attributes.date2_m)>
     <cfset adres = "#adres#&date2_m=#attributes.date2_m#">
   </cfif>
   <cfif len(attributes.date1_o)>
     <cfset adres = "#adres#&date1_o=#attributes.date1_o#">
   </cfif>
   <cfif len(attributes.date2_o)>
     <cfset adres = "#adres#&date2_o=#attributes.date2_o#">
   </cfif>
   <cfif len(attributes.date3_o)>
     <cfset adres = "#adres#&date3_o=#attributes.date3_o#">
   </cfif>
   <cfif len(attributes.date4_o)>
     <cfset adres = "#adres#&date4_o=#attributes.date4_o#">
   </cfif>
   <cfif len(attributes.date1_p)>
     <cfset adres = "#adres#&date1_p=#attributes.date1_p#">
   </cfif>
   <cfif len(attributes.date2_p)>
     <cfset adres = "#adres#&date2_p=#attributes.date2_p#">
   </cfif>
   <cfif len(attributes.date1_i)>
     <cfset adres = "#adres#&date1_i=#attributes.date1_i#">
   </cfif>
   <cfif len(attributes.date2_i)>
     <cfset adres = "#adres#&date2_i=#attributes.date2_i#">
   </cfif>
   <cfif len(attributes.ch_date_2)>
     <cfset adres = "#adres#&ch_date_2=#attributes.ch_date_2#">
   </cfif>
   <cfif len(attributes.ch_date_1)>
     <cfset adres = "#adres#&ch_date_1=#attributes.ch_date_1#">
   </cfif>
   <cfif len(attributes.report_type)>
     <cfset adres = "#adres#&report_type=#attributes.report_type#">
   </cfif>
   <cfif len(attributes.resource_id)>
     <cfset adres = "#adres#&resource_id=#attributes.resource_id#">
   </cfif>
   <cfif isDefined("attributes.comp_cat") and len(attributes.comp_cat)>
     <cfset adres = "#adres#&comp_cat=#attributes.comp_cat#">
   </cfif>
   <cfif isDefined("attributes.cons_cat") and len(attributes.cons_cat)>
     <cfset adres = "#adres#&cons_cat=#attributes.cons_cat#">
   </cfif>
   <cfif isDefined("attributes.size_id") and len(attributes.size_id)>
     <cfset adres = "#adres#&size_id=#attributes.size_id#">
   </cfif>
   <cfif len(attributes.company_id)>
     <cfset adres = "#adres#&company_id=#attributes.company_id#&company=#attributes.company#">
   </cfif>
   <cfif len(attributes.consumer_id)>
     <cfset adres = "#adres#&consumer_id=#attributes.consumer_id#&company=#attributes.company#">
   </cfif>
   <cfif len(attributes.i_company_id)>
     <cfset adres = "#adres#&i_company_id=#attributes.i_company_id#&i_company=#attributes.i_company#">
   </cfif>
   <cfif len(attributes.i_consumer_id)>
     <cfset adres = "#adres#&i_consumer_id=#attributes.i_consumer_id#&i_company=#attributes.i_company#">
   </cfif>
   <cfif isDefined("attributes.sales_partner_id") and len(attributes.sales_partner_id)>
     <cfset adres = "#adres#&sales_partner_id=#attributes.sales_partner_id#&sales_partner=#attributes.sales_partner#">
   </cfif>
   <cfif len(attributes.subscription_type)>
     <cfset adres = "#adres#&subscription_type=#attributes.subscription_type#" >
   </cfif>
   <cfif len(attributes.process_stage_type)>
     <cfset adres = "#adres#&process_stage_type=#attributes.process_stage_type#" >
   </cfif>
   <cfif len(attributes.status)>
     <cfset adres = "#adres#&status=#attributes.status#">
   </cfif>
   <cfif len(attributes.status_p)>
     <cfset adres = "#adres#&status_p=#attributes.status_p#">
   </cfif>
   <cfif len(attributes.keyword_no)>
     <cfset adres = "#adres#&keyword_no=#attributes.keyword_no#" >
   </cfif>
   <cfif len(attributes.payment_type)>
     <cfset adres = "#adres#&payment_type=#attributes.payment_type#" >
   </cfif>
   <cfif len(attributes.sozlesme_no)>
     <cfset adres = "#adres#&sozlesme_no=#attributes.sozlesme_no#" >
   </cfif>
   <cfif len(attributes.detail)>
     <cfset adres = "#adres#&detail=#attributes.detail#" >
   </cfif>
   <cfif len(attributes.cancel_type)>
     <cfset adres = "#adres#&cancel_type=#attributes.cancel_type#" >
   </cfif>
   <cfif len(attributes.report_sort_type)>
     <cfset adres = "#adres#&report_sort_type=#attributes.report_sort_type#" >
   </cfif>
   <cfif len(attributes.report_dsp_type)>
     <cfset adres = "#adres#&report_dsp_type=#attributes.report_dsp_type#" >
   </cfif>
   <cfif len(attributes.sale_add_option)>
     <cfset adres = "#adres#&sale_add_option=#attributes.sale_add_option#" >
   </cfif>
   <cfif len(attributes.subs_add_option)>
     <cfset adres = "#adres#&subs_add_option=#attributes.subs_add_option#" >
   </cfif>
   <cfif len(attributes.graph_type)>
     <cfset adres = "#adres#&graph_type=#attributes.graph_type#">
   </cfif>
   <cfif len(attributes.sales_zones)>
     <cfset adres = "#adres#&sales_zones=#attributes.sales_zones#" >
   </cfif>
   <cfif isdefined("attributes.ref_consumer_id") and len(attributes.ref_consumer_id) >
		<cfset adres = "#adres#&ref_consumer_id=#attributes.ref_consumer_id#">
	</cfif>
    <cfif isdefined("attributes.ref_partner_id") and len(attributes.ref_partner_id) >
		<cfset adres = "#adres#&ref_partner_id=#attributes.ref_partner_id#">
	</cfif>
     <cfif isdefined("attributes.ref_company_id") and len(attributes.ref_company_id) >
		<cfset adres = "#adres#&ref_company_id=#attributes.ref_company_id#">
	</cfif>
    <cfif isdefined("attributes.ref_member_type") and len(attributes.ref_member_type) >
		<cfset adres = "#adres#&ref_member_type=#attributes.ref_member_type#">
	</cfif>
     <cfif isdefined("attributes.ref_member_name") and len(attributes.ref_member_name) >
		<cfset adres = "#adres#&ref_member_name=#attributes.ref_member_name#">
	</cfif>
       <cf_paging
       page="#attributes.page#" 
       maxrows="#attributes.maxrows#"
       totalrecords="#attributes.totalrecords#"
       startrow="#attributes.startrow#"
       adres="#adres#">
     
 </cfif>
 <br/>
 <cfif isdefined("attributes.form_submitted") and len(attributes.graph_type) and attributes.report_type neq 1 and attributes.report_type neq 16>
     <tr class="color-row">
       <td align="center">  
         <cfoutput query="get_total_purchase" maxrows="#attributes.maxrows#" startrow="#attributes.startrow#">
           <cfset item_value = ''>
           <cfif listfind('12,13,14,15',attributes.report_type)>
             <cfset item_value = '#dateformat(REPORT_GROUP_TYPE,dateformat_style)#'>
             <cfelse>
             <cfset item_value = '#REPORT_GROUP_TYPE#'>
           </cfif>
           <cfset item = "#item_value#">
           <cfset value = "#SYSTEM_SAYISI#">
         </cfoutput>
 
         <script src="JS/Chart.min.js"></script>
          <canvas id="myChart" <cfif #graph_type# eq 'bar'>style="max-width:1000px;max-height:1000px;margin-top:0;"<cfelse>style="max-width:500px;max-height:500px;margin-top:0;"</cfif> ></canvas>
          <script>
           var ctx = document.getElementById('myChart').getContext('2d');
           var myChart = new Chart(ctx, {
           type: '<cfoutput>#graph_type#</cfoutput>',
           data: {
               labels: [<cfloop from="1" to="#get_total_purchase.recordcount#" index="jj">
                 <cfoutput>"#get_total_purchase.REPORT_GROUP_TYPE[jj]#"</cfoutput>,</cfloop>],
               datasets: [{
               label: ['<cf_get_lang no='850.Abone Analiz raporu'>'],
               data: [<cfloop from="1" to="#get_total_purchase.recordcount#" index="jj"><cfoutput>#get_total_purchase.SYSTEM_SAYISI[jj]#</cfoutput>,</cfloop>],
               backgroundColor: [<cfloop from="1" to="#get_total_purchase.recordcount#" index="jj">'rgba('+Math.floor((Math.random()*255) + 1) + ',' +Math.floor((Math.random()*255) + 1) + ','+ Math.floor((Math.random()*255) + 1)+',0.60)',</cfloop>],
               borderWidth: 1
               }]
               },
               options: {
                scales: {
                yAxes: [{
                 ticks: {
                  beginAtZero:true
                     }
                       }]
                         }
                 }
             });
            </script>          
       </td>
     </tr>
 </cfif>
 
 <script>
 function set_the_report()
 {
   rapor.report_type.checked = false;
 }
 function ayarla_gizle_goster(id)
 {
   if(id==1 || id==16)
   {
     document.getElementById('report_dsp').style.display='';
     document.getElementById('report_dsp1').style.display='';
     document.getElementById('graphic').style.display='none';
     document.getElementById('graphic2').style.display='none';	
   }	
   else
   {
     document.getElementById('report_dsp').style.display='none';
     document.getElementById('report_dsp1').style.display='none';
     document.getElementById('graphic').style.display='';
     document.getElementById('graphic2').style.display='';
   }
 }
 function control()
   {
     if ((document.rapor.date1_i.value != '') && (document.rapor.date2_i.value != '') &&
       !date_check(rapor.date1_i,rapor.date2_i," <cf_get_lang_main no='336.Iptal Tarihi'>'nin <cf_get_lang no ='1093.Başlangıç Tarihi Bitiş Tarihinden Küçük Olmalıdır'>!"))
            return false;
     if ((document.rapor.date1_p.value != '') && (document.rapor.date2_p.value != '') &&
       !date_check(rapor.date1_p,rapor.date2_p,"<cf_get_lang no='469.Prim Tarihi'>'nin <cf_get_lang no ='1093.Başlangıç Tarihi Bitiş Tarihinden Küçük Olmalıdır'>!"))
            return false;
     if ((document.rapor.date1_o.value != '') && (document.rapor.date2_o.value != '') &&
       !date_check(rapor.date1_o,rapor.date2_o," <cf_get_lang no='532.Ödeme Planı Başlangıç Tarihi'>'nin <cf_get_lang no ='1093.Başlangıç Tarihi Bitiş Tarihinden Küçük Olmalıdır'>!"))
            return false;
     if ((document.rapor.date3_o.value != '') && (document.rapor.date4_o.value != '') &&
       !date_check(rapor.date3_o,rapor.date4_o," <cf_get_lang dictionary_id='56907.Ödeme Planı'> <cf_get_lang_main no='288.Bitis Tarihi'>'nin <cf_get_lang no ='1093.Başlangıç Tarihi Bitiş Tarihinden Küçük Olmalıdır'>!"))
            return false;
     if ((document.rapor.date1.value != '') && (document.rapor.date2.value != '') &&
       !date_check(rapor.date1,rapor.date2," <cf_get_lang_main no='335.Szlesme Tarihi'>'nin <cf_get_lang no ='1093.Başlangıç Tarihi Bitiş Tarihinden Küçük Olmalıdır'>!"))
            return false;
     if ((document.rapor.date1_m.value != '') && (document.rapor.date2_m.value != '') &&
       !date_check(rapor.date1_m,rapor.date2_m," <cf_get_lang dictionary_id='60559.Kurulum Tarihi'>'nin <cf_get_lang no ='1093.Başlangıç Tarihi Bitiş Tarihinden Küçük Olmalıdır'>!"))
            return false;
     if(document.rapor.is_excel.checked==false)
       {
         document.rapor.action="<cfoutput>#request.self#</cfoutput>?fuseaction=report.system_analyse_report"
         return true;
       }
       else
         document.rapor.action="<cfoutput>#request.self#?fuseaction=report.emptypopup_system_analyse_report</cfoutput>"
   }
 </script>
 