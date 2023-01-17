<!---
    File: V16\hr\ehesap\display\view_detail_information.cfm
    Author: Alper Çitmen <alpercitmen@workcube.com>
    Date: 2022-02-12
    Description: Kesenek Detay Bilgileri 5510
    History:
    To Do:

--->

<cf_get_lang_set module_name="ehesap">
<cfparam name="attributes.is_virtual_puantaj" default="0">
<cfset main_puantaj_table = "EMPLOYEES_PUANTAJ">
<cfset row_puantaj_table = "EMPLOYEES_PUANTAJ_ROWS">
<cfset add_puantaj_table = "EMPLOYEES_PUANTAJ_ROWS_ADD">
<cfset maas_puantaj_table = "EMPLOYEES_SALARY">
<cfparam name="icmal_border" default="0">

<cfif not evaluate("#query_name#.recordcount")>
	<script type="text/javascript">
		alert("Kayıt bulunamadı!");
		history.back();
	</script>
	<cfexit method="exittemplate">
</cfif>
<cfif icmal_type is 'genel' and (not isdefined("attributes.func_id") or (isdefined("attributes.func_id") and not len(attributes.func_id)))>
	<!--- önceki aydan devreden kümülatif matrah calisanların bir onceki aydaki en son puantajındaki kumulatif degerlere bakmalı.sube --->
	<cfquery name="get_old_puantaj_rows" datasource="#dsn#">
		SELECT
			SUM(EPR.KUMULATIF_GELIR_MATRAH) AS KUM_TOPLAM,
			SUM(EPR.GELIR_VERGISI) AS GELIR_TOPLAM
		FROM
			EMPLOYEES_PUANTAJ_ROWS EPR INNER JOIN
			(SELECT 
				EPR.EMPLOYEE_ID,
				MAX(EPR.EMPLOYEE_PUANTAJ_ID) AS EMPLOYEE_PUANTAJ_ID
			FROM 
				EMPLOYEES_PUANTAJ_ROWS EPR INNER JOIN EMPLOYEES_PUANTAJ EP
				ON EPR.PUANTAJ_ID = EP.PUANTAJ_ID
			WHERE 
				EP.SAL_YEAR = <cfif isdefined("attributes.sal_year") and isnumeric(attributes.sal_year)><cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.sal_year#"><cfelse><cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.period_year#"></cfif> AND
				EP.SAL_MON = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.SAL_MON-1#"> AND
				EPR.EMPLOYEE_ID IN (#evaluate('valueList(#query_name#.EMPLOYEE_ID)')#) 
			GROUP BY
				EPR.EMPLOYEE_ID
				) AS ROW_TABLE ON EPR.EMPLOYEE_PUANTAJ_ID = ROW_TABLE.EMPLOYEE_PUANTAJ_ID	
	</cfquery>
	<cfif get_old_puantaj_rows.recordcount and len(get_old_puantaj_rows.kum_toplam)>
		<cfset onceki_donem_kum_gelir_vergisi_matrahi = get_old_puantaj_rows.kum_toplam>
		<cfset onceki_donem_kum_gelir_vergisi = get_old_puantaj_rows.gelir_toplam>
	</cfif>
</cfif>
<cfset bu_ay_basi = createdate(attributes.sal_year,attributes.sal_mon, 1)>
<cfif isdefined('attributes.sal_year_end') and len(attributes.sal_year_end) and isdefined('attributes.sal_mon_end') and len(attributes.sal_year_end)>
	<cfset temp_ay_basi = createdate(attributes.sal_year_end,attributes.sal_mon_end, 1)>
	<cfset bu_ay_sonu = date_add('s',-1,date_add('m',1,temp_ay_basi))>
<cfelse>
	<cfset bu_ay_sonu = date_add('s',-1,date_add('m',1,bu_ay_basi))>
</cfif>
<cfquery name="get_izins" datasource="#dsn#">
	SELECT
		OFFTIME.EMPLOYEE_ID,
		OFFTIME.STARTDATE,
		OFFTIME.FINISHDATE,
		SETUP_OFFTIME.EBILDIRGE_TYPE_ID,
		SETUP_OFFTIME.IS_YEARLY,
		SETUP_OFFTIME.SIRKET_GUN,
		SETUP_OFFTIME.IS_PAID
	FROM
		OFFTIME,SETUP_OFFTIME
	WHERE
		SETUP_OFFTIME.OFFTIMECAT_ID = OFFTIME.OFFTIMECAT_ID AND
		OFFTIME.VALID = 1 AND
		OFFTIME.STARTDATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#bu_ay_sonu#"> AND
		OFFTIME.FINISHDATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#bu_ay_basi#"> AND 
		OFFTIME.IS_PUANTAJ_OFF = 0
	ORDER BY
		OFFTIME.EMPLOYEE_ID
</cfquery>

<cfquery name="get_personal" dbtype="query">
	SELECT * FROM get_puantaj_personal WHERE STATUE_TYPE = 8 or STATUE_TYPE = 1
</cfquery>

<cfif icmal_type is 'personal'>
<!-- sil -->
</cfif>

<cfif isdefined("url.fuseaction") and url.fuseaction eq 'ehesap.popupflush_view_puantaj_print_pdf'>
	<cfset uidrop_value="0">
	<cfset title="">
<cfelse>
	<cfset uidrop_value="1">
	<cfset title="Bordro">
</cfif>
<cfquery name="GET_PROTESTS" datasource="#DSN#" maxrows="1">
	SELECT * FROM EMPLOYEES_PUANTAJ_PROTESTS WHERE SAL_MON=<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.sal_mon#"> AND SAL_YEAR=<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.sal_year#"> AND EMPLOYEE_ID=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#"> ORDER BY PROTEST_ID DESC
</cfquery>

<cfset puantaj_action = createObject("component", "V16.hr.ehesap.cfc.create_puantaj")>
<cfset puantaj_action.dsn = dsn />

<cfquery name="get_apply_status" datasource="#dsn#">
    SELECT 
        APPLY_DATE,
        ROW_ID
    FROM 
        EMPLOYEES_PUANTAJ_MAILS 
    WHERE 
        EMPLOYEE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_puantaj_personal.employee_id#"> AND
        BRANCH_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_puantaj_personal.branch_id#"> AND 
        SAL_MON = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_puantaj_personal.sal_mon#"> AND 
        SAL_YEAR = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_puantaj_personal.sal_year#">
</cfquery>

<cfquery name="get_kesintis_brut" datasource="#dsn#">
    SELECT * FROM EMPLOYEES_PUANTAJ_ROWS_EXT WHERE FROM_SALARY = 1 AND EMPLOYEE_PUANTAJ_ID IN (#VALUELIST(GET_PUANTAJ_ROWS.EMPLOYEE_PUANTAJ_ID)#) AND EXT_TYPE IN(1,3) ORDER BY COMMENT_PAY
</cfquery>

<cfif get_personal.recordCount eq 0>
    <cf_box title="Bordro"><cf_get_lang dictionary_id="57484.Kayıt Yok">!</cf_box>
    <cfabort>
<cfelse>
    <cfset title="#Ucase(getLang('','Kesenek Detay Bilgileri',64922))#">
</cfif>

<cfset page_max_row = 10>
<cfset all_total = 0>
<cfset total_page = (round(get_personal.recordCount/page_max_row) LT 1)?1:round(get_personal.recordCount/page_max_row)>

<cf_box title="#title#" closable="0" uidrop="1"> 
    <div class="printThis">
        <style>
            .printableArea{
                display: block;
                position: relative;
                page-break-after: always;              
                padding:10mm 5px 5px 5px;
            }    
        
            .printableArea * {
                font-family: Arial,Helvetica Neue,Helvetica,sans-serif; 
                -webkit-box-sizing: border-box;
                -moz-box-sizing: border-box;
                box-sizing: border-box;
                font-size: 12px;
            }
            .printableArea *:before,
            .printableArea *:after {
                -webkit-box-sizing: border-box;
                -moz-box-sizing: border-box;
                box-sizing: border-box;
            }
        
            <!--- SADECE DEVELOPER DA AÇ --->
                /* .printableArea div{border:1px solid red;}
                .printableArea{border: 1px solid #2196F3; } */
            <!--- SADECE DEVELOPER DA AÇ --->   
        
            .bold{font-weight: bold;}
            .underline{text-decoration:underline;}
            .left{text-align:left;}
            .center{text-align:center;}
            .right{text-align:right;}
            .no-border{border:0px;}
        
            table#tablo_ust_baslik {
                width: 100%;
                padding: 10px 200px;
                box-sizing: border-box;
                border-collapse: collapse;
                border: 0px;
            }
        
            table#tablo_ust_baslik th {
                border: 1px solid black;
            }
        
            table#tablo_alt_baslik th {
                border: 1px solid black;
            }

            table#tablo_alt_baslik {
                width: 100%;
                padding: 10px 200px;
                box-sizing: border-box;
                border-collapse: collapse;
                border: 0px;
                margin-top:3mm;
            }
        
            table#tablo_alt_baslik td {
                border: 1px solid black;
                padding: 3mm;
            }
        
            #bordrologo{
                width: 100px  !important;
                height: 50px  !important;
                display: block;
                margin-left: auto;
                margin-right: auto;
                width: 50%;
                -webkit-filter: grayscale(100%); /* Safari 6.0 - 9.0 */
                filter: grayscale(100%);
            }
            #paper_title{
                text-align: center;
                vertical-align: middle;
                line-height: 90px;
                font-size: 16pt;
            }
        
            table#tablo_ust_ekbilgi {
                min-width: 110mm;
                margin: 2mm 0mm;
            }
        
            @media print      {
                .printableArea{
                    page-break-after:always;
                    transform: rotate(90deg);
                    width: 208mm;
                    height: 295mm;
                    margin: 0 180px auto;

                }
            }
        
        </style>
        <cfloop index="i" from="1" to="#total_page#">
            <cfset page_total = 0>
            <div class="printableArea" id="printBordro">
                <div id="logo">
                    <img src="https://ms.hmb.gov.tr/uploads/2018/12/logo.png" id="bordrologo"/>
                </div>
                <div id = "paper_title">
                    <cfoutput>#title#</cfoutput>
                </div>
                <div class="col col-12 col-md-12 col-sm-12 col-xs-12">
                    <cfoutput>
                        <table>
                            <tr><th class="text-left"><cf_get_lang dictionary_id='53806.İşyeri'>: #get_personal.related_company#</th></tr>
                            <tr><th class="text-left"><cf_get_lang dictionary_id='58608.İl'>/<cf_get_lang dictionary_id='58638.İlçe'>: #get_personal.BRANCH_CITY# / #get_personal.BRANCH_COUNTY#</th></tr>
                            <tr><th class="text-left"><cf_get_lang dictionary_id='46695.İşyeri Numarası'>: ?</th></tr>
                            <tr><th class="text-left"><cf_get_lang dictionary_id='64462.Saymanlık Numarası'>: ?</th></tr>
                            <tr><th class="text-left"><cf_get_lang dictionary_id='65177.Bildirge No'>: ?</th></tr>
                            <tr><th class="text-left"><cf_get_lang dictionary_id='58472.Dönem'>: #attributes.sal_year# - #attributes.sal_mon#</th></tr>
                            <tr><th class="text-left"><cf_get_lang dictionary_id='65178.İşlem Zamanı'>: #dateFormat(now(), 'YYYY-MM-DD HH:DD')#</th></tr>
                        </table>
                    </cfoutput>
                    
                    <table id="tablo_alt_baslik">
                        <tr>
                            <th colspan="4"></th>
                            <th colspan="2"><cf_get_lang dictionary_id='65174.Göreve Başlama'></th>
                            <th colspan="2"><cf_get_lang dictionary_id='65175.Görevden Ayrılış'></th>
                            <th colspan="5"></th>
                            <th colspan="3"><cf_get_lang dictionary_id='64227.Hakedilen'><cf_get_lang dictionary_id='40302.Toplamlar'></th>
                            <th colspan="4"><cf_get_lang dictionary_id='64105.Sigorta'></th>
                        </tr>
                        <tr>
                            <th><cf_get_lang dictionary_id='65057.TCKN'></th>
                            <th><cf_get_lang dictionary_id='63673.Emekli Sicil No'></th>
                            <th><cf_get_lang dictionary_id='57570.Ad Soyad'></th>
                            <th title="<cf_get_lang dictionary_id='57756.Durum'><cf_get_lang dictionary_id='142.Kodu'>">D. / K.</th>
                            <th><cf_get_lang dictionary_id='30631.Tarih'></th>
                            <th><cf_get_lang dictionary_id='65173.Sebep'></th>
                            <th><cf_get_lang dictionary_id='30631.Tarih'></th>
                            <th><cf_get_lang dictionary_id='65173.Sebep'></th>
                            <th><cf_get_lang dictionary_id='54179.Derece'></th>
                            <th><cf_get_lang dictionary_id='58710.Kademe'></th>
                            <th><cf_get_lang dictionary_id='63743.Ek Göstergesi'></th>
                            <th><cf_get_lang dictionary_id='65134.Kıdem Hizmeti'></th>
                            <th><cf_get_lang dictionary_id='53856.Prim Ödeme Gün Sayısı'></th>
                            <th><cf_get_lang dictionary_id='46115.Tazminat'><cf_get_lang dictionary_id='57989.ve'><cf_get_lang dictionary_id='31283.Ek Ödemeler'></th>
                            <th><cf_get_lang dictionary_id='58932.Aylık'></th>
                            <th title="<cf_get_lang dictionary_id='53880.Prime Esas Kazanç'><cf_get_lang dictionary_id='29954.Genel'>">PEK <cf_get_lang dictionary_id='29954.Genel'></th>
                            <th>%9 MYO</th>
                            <th title="<cf_get_lang dictionary_id='53191.Genel Sağlık Sigortası'>">%5 GSS</th>
                            <th>%11 MYO</th>
                            <th title="<cf_get_lang dictionary_id='53191.Genel Sağlık Sigortası'>">%7,5 GSS</th>
                        </tr>
                        
                        <cfoutput query="get_personal">
                            <cfscript>
                                //Gün Toplamları
                                t_paid_izin = 0;
                                t_paid_izin_hours = 0;
                                t_haftalik_tatil = 0;
                                t_haftalik_tatil_hours = 0;
                                t_normal_gun = 0;
                                t_normal_hours = 0;
                                t_paid_izinli_sundays = 0;
                                t_paid_izinli_sundays_hours = 0;
                                t_izin = 0;
                                t_izin_hours = 0;
                                t_total_days = 0;
                                t_total_hours = 0;
                                t_offdays = 0;
                                t_offdays_hours = 0;
                                t_ext_work_hours_0 = 0;
                                t_ext_work_hours_1 = 0;
                                t_ext_work_hours_2 = 0;
                                t_ext_work_hours_5 = 0;
                                t_salary = 0;
                                t_base_salary = 0;
                                t_retirement_allowance = 0;
                                t_retirement_allowance_personal = 0;
                                t_retirement_allowance_personal_interruption = 0;
                                t_general_health_insurance = 0;
                                t_sgk_base = 0;
                                t_additional_indicator_compensation = 0;
                                t_extra_pay = 0;
                                t_additional_score = 0;
                                t_normal_additional_score = 0;
                                t_audit_compensation_amount = 0;
                                t_retired_academic = 0;

                                //tutar toplamları
                                t_normal_amount = 0;
                                t_haftalik_tatil_amount = 0;
                                t_offdays_amount = 0;
                                t_izin_amount = 0;
                                t_izin_paid_amount = 0;
                                t_izin_paid_amount_ht = 0;
                                t_kidem_amount = 0;
                                t_ihbar_amount = 0;
                                t_yillik_izin_amount = 0;
                                t_ext_salary_0 = 0;
                                t_ext_salary_1 = 0;
                                t_ext_salary_2 = 0;
                                t_ext_salary_5 = 0;
                                t_collective_agreement_bonus = 0;
                                t_high_education_compensation = 0;
                                t_land_compensation_amount = 0;
                                t_tazminatlar = 0;
                                
                                t_reel_ssk_days = 0;
                                t_ssdf_ssk_days = 0;
                                t_ssk_matrahi = 0;
                                t_sgdp_devir = 0; 
                                t_devreden = 0;
                                t_devirden_gelen = 0;
                                t_toplam_kazanc = 0;
                                t_vergi_iadesi = 0;
                                t_vergi_iadesi_alan = 0;
                                t_vergi_indirimi_5084 = 0;
                                t_vergi_indirimi_5746_days = 0;
                                t_vergi_indirimi_5746 = 0;
                                t_vergi_indirimi_5746_all = 0;
                                t_vergi_indirimi_4691 = 0;
                                t_vergi_indirimi_4691_all = 0;
                                t_kum_gelir_vergisi_matrahi = 0;
                                t_gelir_vergisi_matrahi = 0;
                                t_gelir_vergisi = 0;
                                t_damga_vergisi = 0;
                                t_damga_vergisi_matrahi = 0;
                                t_kesinti = 0;
                                t_net_ucret = 0;
                                t_ssk_primi_isci = 0;
                                t_bes_primi_isci = 0;
                                t_ssk_primi_isci_devirsiz = 0;
                                t_ssk_primi_isveren_hesaplanan = 0;
                                t_ssk_primi_isveren = 0;
                                t_ssk_primi_isveren_gov = 0;
                                t_ssk_primi_isveren_5510 = 0;
                                t_ssk_primi_isveren_5084 = 0;
                                t_ssk_primi_isveren_5921 = 0;
                                t_ssk_primi_isveren_5746 = 0;
                                t_ssk_days_5746 = 0;
                                
                                t_damga_vergisi_indirimi_5746 = 0;
                                t_damga_vergisi_indirimi_5746_all = 0;
                                t_stampduty_5746 = 0;

                                t_ssk_primi_isveren_4691 = 0;
                                t_ssk_primi_isveren_6111 = 0;
                                t_ssk_primi_isveren_6486 = 0;
                                t_ssk_primi_isveren_6322 = 0;
                                t_ssk_primi_isci_6322 = 0;
                                t_ssk_primi_isveren_25510 = 0;
                                t_ssk_primi_isveren_14857 = 0;
                                t_ssk_primi_isveren_6645 = 0;
                                t_ssk_primi_isveren_46486 = 0;
                                t_ssk_primi_isveren_56486 = 0;
                                t_ssk_primi_isveren_66486 = 0;
                                
                                t_ssk_primi_687 = 0;
                                t_isveren_primi_687 = 0;
                                t_issizlik_primi_687 = 0;
                                t_issizlik_isveren_hissesi_687 = 0;
                                t_issizlik_isci_hissesi_687 = 0;
                                t_gelir_vergisi_primi_687 = 0;
                                t_damga_vergisi_primi_687 = 0;
                                toplam_indirim_687 = 0;
                                
                                t_ssk_primi_7103 = 0;
                                t_isveren_primi_7103 = 0;
                                t_issizlik_primi_7103 = 0;
                                t_gelir_vergisi_primi_7103 = 0;
                                t_damga_vergisi_primi_7103 = 0;
                                toplam_indirim_7103 = 0;
                                ssk_isveren_hissesi_7103 = 0;
                                t_ssk_isveren_hissesi_7103 = 0;
                                t_ssk_isci_hissesi_7103 = 0;
                                t_issizlik_isci_hissesi_7103 = 0;
                                t_issizlik_isveren_hissesi_7103 = 0; 
                                
                                //7252 KÇÖ indirim kanunu Esma R. Uysal
                                t_ssk_isveren_hissesi_7252 = 0;
                                t_ssk_isci_hissesi_7252 = 0;
                                t_issizlik_isci_hissesi_7252 = 0;
                                t_issizlik_isveren_hissesi_7252 = 0;
                                t_ssk_days_7252 = 0;
                                t_toplam_indirim_7252 = 0;
                                t_ssk_primi_7252 = 0;
                                t_istisna = 0;
                                
                                
                                //7256 İstihdama Dönüş Kanunu Esma R. Uysal 
                                t_ssk_isveren_hissesi_7256 = 0;
                                t_ssk_isci_hissesi_7256 = 0;
                                t_issizlik_isci_hissesi_7256 = 0;
                                t_issizlik_isveren_hissesi_7256 = 0;
                                t_toplam_indirim_7256 = 0;
                                t_ssk_primi_7256 = 0;
                                t_base_amount_7256 = 0;

                                t_issizlik_isci_hissesi = 0;
                                t_issizlik_isci_hissesi_devirsiz = 0;
                                t_issizlik_isveren_hissesi = 0;
                                t_ozel_kesinti = 0;
                                t_ozel_kesinti_2 = 0;
                                t_ozel_kesinti_2_net = 0;
                                t_ozel_kesinti_2_net_fark = 0;
                                ssk_count = 0;
                                t_ssdf_days = 0;
                                t_ssdf_matrah = 0;
                                t_ssdf_isci_hissesi = 0;
                                t_ssdf_isveren_hissesi = 0;
                                t_sakatlik = 0;
                                t_gocmen_indirimi = 0;
                                t_ext_salary = 0;
                                t_ext_salary_net = 0;
                                t_ssk_matrah_muafiyet = 0;
                                t_vergi_matrah_muafiyet = 0;
                                t_avans = 0;
                                ssdf_say = 0;
                                ssk_say = 0;
                                sakat_say = 0;
                                t_short_working_calc = 0;//kısa çalışma ödeneği
                                t_isci_primi_indirimli = 0;
                                t_issizlik_isci_primi_indirimli = 0;
                                t_issizlik_isveren_primi_indirimli = 0;
                                t_plus_retired = 0;//Artış %100
                                t_plus_retired_person = 0;//Kişi Devlet %100
                                t_penance_deduction = 0;//Kefaret kesintisi

                                if (isnumeric(get_kumulatif_gelir_vergisi.toplam))
                                    t_kum_gelir_vergisi = get_kumulatif_gelir_vergisi.toplam;
                                else
                                    t_kum_gelir_vergisi = 0;

                                if (isdefined("get_kumulatif_gelir_vergisi.toplam_matrah") and isnumeric(get_kumulatif_gelir_vergisi.toplam_matrah))
                                    t_kum_gelir_vergisi_matrahi = get_kumulatif_gelir_vergisi.toplam_matrah;
                                else
                                    t_kum_gelir_vergisi_matrahi = 0;
                                    
                                t_total_pay_ssk_tax = 0;
                                t_total_pay_ssk = 0;
                                t_total_pay_tax = 0;
                                t_total_pay = 0;
                                t_vergi_istisna_yaz = 0;
                                t_vergi_istisna_net_yaz = 0;
                                t_vergi_istisna_tutar = 0;
                                fmesai_sayac_1 = 0;
                                fmesai_sayac_2 = 0;
                                fmesai_sayac_3 = 0;
                                fmesai_sayac_4 = 0;	
                                T_VERGI_ISTISNA_DAMGA = 0;
                                T_VERGI_ISTISNA_VERGI = 0;
                                fazla_mesai_toplam = 0;

                                additional_indicators = 0; //ek gösterge puanı
                                t_additional_indicators = 0; //ek gösterge puanı
                                t_university_allowance = 0;//üniversite ödeneği
                                t_private_service_compensation = 0;//Özel Hizmet tazminatı
                                t_family_assistance = 0;//Eş YArdımı
                                t_child_assistance = 0;//Çocuk yardımı;
                                t_severance_pension = 0;//Kıdem Aylığı
                                t_language_allowance = 0;//dil tazminatı
                                t_academic_incentive_allowance_amount = 0;//akademik teşvik ödeneği
                                t_executive_indicator_compensation = 0;//Makam tazminatı
                                t_administrative_duty_allowance = 0;//idari görev tazminatı
                                t_education_allowance = 0;//eğitim öğretim ödeneği
                                t_administrative_compensation = 0;//Görev tazminatı
                                
                                t_retirement_allowance_5510 = 0;
                                t_retirement_allowance_personal_5510 = 0;
                                t_health_insurance_premium_5510 = 0;
                                t_health_insurance_premium_personal_5510 = 0;
                                //Gün toplamları
                                //normal gün
                                t_normal_gun = t_normal_gun + weekly_day;
                                t_normal_hours = t_normal_hours + weekly_hour;
                                if(len(RETIRED_ACADEMIC) and RETIRED_ACADEMIC gt 0)
                                    t_retired_academic = t_retired_academic + retired_academic;
                                
                                if(len(ADDITIONAL_SCORE))
                                    t_additional_score =  t_additional_score + ADDITIONAL_SCORE;
                                if(len(NORMAL_ADDITIONAL_SCORE))
                                    t_normal_additional_score =  t_normal_additional_score + NORMAL_ADDITIONAL_SCORE;
                                if(len(audit_compensation_amount))
                                    t_audit_compensation_amount = t_audit_compensation_amount + audit_compensation_amount;
                                

                                //haftalık tatil
                                t_haftalik_tatil = t_haftalik_tatil + weekend_day;
                                t_haftalik_tatil_hours = t_haftalik_tatil_hours + weekend_hour;
                                
                                //ucretsiz izin gün ve saat
                                t_izin = t_izin + izin;
                                t_izin_hours = t_izin_hours + izin_count;
                            
                                //ucretli izin gün ve saat
                                t_paid_izin = t_paid_izin + (izin_paid-paid_izinli_sunday_count);
                                t_paid_izin_hours = t_paid_izin_hours + (izin_paid_count-paid_izinli_sunday_count_hour);
                                
                                //genel tatil izin ve saat
                                t_offdays = t_offdays + OFFDAYS_COUNT;
                                t_offdays_hours = t_offdays_hours + OFFDAYS_COUNT_HOUR;
                                
                                //ücretli hafta sonu
                                t_paid_izinli_sundays = t_paid_izinli_sundays + PAID_IZINLI_SUNDAY_COUNT;
                                t_paid_izinli_sundays_hours = t_paid_izinli_sundays_hours + PAID_IZINLI_SUNDAY_COUNT_HOUR;

                                
                                //Ücret Toplamları
                                //normal gün
                                t_normal_amount = t_normal_amount + weekly_amount;
                                
                                //haftalık tatil
                                t_haftalik_tatil_amount = t_haftalik_tatil_amount + weekend_amount;
                                
                                //genel tatil
                                t_offdays_amount = t_offdays_amount + offdays_amount;
                                
                                //ücretsiz izin
                                t_izin_amount = t_izin_amount + izin_amount;
                                
                                //ücretli izin
                                t_izin_paid_amount = t_izin_paid_amount + izin_paid_amount - izin_sunday_paid_amount;
                                
                                //ücretli izin hafta sonu
                                t_izin_paid_amount_ht = t_izin_paid_amount_ht + izin_sunday_paid_amount;

                                if(len(collective_agreement_bonus))
                                    t_collective_agreement_bonus = t_collective_agreement_bonus + collective_agreement_bonus;
                                if(len(high_education_compensation_payroll))
                                    t_high_education_compensation = t_high_education_compensation + high_education_compensation_payroll;
                                if(len(land_compensation_amount))
                                    t_land_compensation_amount = t_land_compensation_amount + land_compensation_amount;
                                //Aylık tutar
                                t_salary = t_salary + salary;
                                //Taban aylık
                                if(len(base_salary))
                                    t_base_salary = t_base_salary + base_salary;
                                if(len(retirement_allowance))
                                    t_retirement_allowance = t_retirement_allowance + retirement_allowance;
                                if(len(retirement_allowance_personal))
                                    t_retirement_allowance_personal = t_retirement_allowance_personal + retirement_allowance_personal;
                                if(len(retirement_allowance_personal_interruption))
                                    t_retirement_allowance_personal_interruption = t_retirement_allowance_personal_interruption + retirement_allowance_personal_interruption;
                                if(len(general_health_insurance))
                                    t_general_health_insurance = t_general_health_insurance + general_health_insurance;
                                if(len(sgk_base))
                                    t_sgk_base = t_sgk_base + sgk_base;
                                if(len(plus_retired))
                                    t_plus_retired = t_plus_retired + plus_retired;//Artış %100
                                if(len(plus_retired_personal))
                                    t_plus_retired_person = t_plus_retired_person + plus_retired_personal;//Kişi Devlet %100
                                if(len(additional_indicator_compensation))
                                    t_additional_indicator_compensation = t_additional_indicator_compensation + additional_indicator_compensation;
                                if(len(retirement_allowance_5510))
                                    t_retirement_allowance_5510 = t_retirement_allowance_5510 + retirement_allowance_5510;
                                if(len(retirement_allowance_personal_5510))
                                    t_retirement_allowance_personal_5510 = t_retirement_allowance_personal_5510 + retirement_allowance_personal_5510;
                                if(len(health_insurance_premium_5510))
                                    t_health_insurance_premium_5510 = t_health_insurance_premium_5510 + health_insurance_premium_5510;
                                if(len(health_insurance_premium_personal_5510))
                                    t_health_insurance_premium_personal_5510 = t_health_insurance_premium_personal_5510 + health_insurance_premium_personal_5510;
                                if(len(extra_pay))
                                    t_extra_pay = t_extra_pay + extra_pay; 
                            
                                if(len(additional_indicators))
                                    t_additional_indicators = t_additional_indicators + additional_indicators; //ek gösterge puanı
                                if(len(university_allowance))
                                    t_university_allowance = t_university_allowance + university_allowance;//üniversite ödeneği
                                if(len(private_service_compensation))
                                    t_private_service_compensation = t_private_service_compensation + private_service_compensation;//Özel hizmet tazminatı
                                if(len(family_assistance))
                                    t_family_assistance = t_family_assistance +family_assistance;//Eş YArdımı
                                if(len(child_assistance))
                                    t_child_assistance = t_child_assistance + child_assistance;//Çocuk yardımı;
                                if(len(severance_pension))
                                    t_severance_pension = t_severance_pension + severance_pension;//Kıdem aylığı
                                if(len(language_allowance))
                                    t_language_allowance = language_allowance + t_language_allowance;//Dil tazminatı
                                if(len(academic_incentive_allowance_amount))
                                    t_academic_incentive_allowance_amount = t_academic_incentive_allowance_amount + academic_incentive_allowance_amount;//Akademik teşvik ödeneği
                                if(len(administrative_duty_allowance))
                                    t_administrative_duty_allowance = t_administrative_duty_allowance + administrative_duty_allowance;//idari görev tazminatı
                                if(len(education_allowance))
                                    t_education_allowance = t_education_allowance + education_allowance;//eğitim öğretim ödeneği
                                t_executive_indicator_compensation = t_executive_indicator_compensation + executive_indicator_compensation;//Makam tazminatı
                                t_administrative_compensation = t_administrative_compensation + administrative_compensation;//Görev tazminatı

                                t_tazminatlar = t_executive_indicator_compensation + t_executive_indicator_compensation;
                                
                                //kıdem ihbar izin tutarları
                                t_kidem_amount = t_kidem_amount + KIDEM_AMOUNT;
                                t_ihbar_amount = t_ihbar_amount + IHBAR_AMOUNT;
                                t_yillik_izin_amount = t_yillik_izin_amount + YILLIK_IZIN_AMOUNT;
                                
                                //mesai gün toplamları
                                t_ext_work_hours_0 = t_ext_work_hours_0 + EXT_TOTAL_HOURS_0;
                                t_ext_work_hours_1 = t_ext_work_hours_1 + EXT_TOTAL_HOURS_1;
                                t_ext_work_hours_2 = t_ext_work_hours_2 + EXT_TOTAL_HOURS_2;
                                t_ext_work_hours_5 = t_ext_work_hours_5 + EXT_TOTAL_HOURS_5;
                                
                                //mesai tutar toplamları			
                                t_ext_salary_0 = t_ext_salary_0 + EXT_TOTAL_HOURS_0_AMOUNT;
                                t_ext_salary_1 = t_ext_salary_1 + EXT_TOTAL_HOURS_1_AMOUNT;
                                t_ext_salary_2 = t_ext_salary_2 + EXT_TOTAL_HOURS_2_AMOUNT;
                                t_ext_salary_5 = t_ext_salary_5 + EXT_TOTAL_HOURS_5_AMOUNT;
                                t_ext_Salary = t_ext_salary_0 + t_ext_salary_1 + t_ext_salary_2 + t_ext_salary_5;

                                if(EXT_TOTAL_HOURS_0 gt 0)fmesai_sayac_1 = fmesai_sayac_1 + 1;
                                if(EXT_TOTAL_HOURS_1 gt 0)fmesai_sayac_2 = fmesai_sayac_2 + 1;
                                if(EXT_TOTAL_HOURS_2 gt 0)fmesai_sayac_3 = fmesai_sayac_3 + 1;
                                if(EXT_TOTAL_HOURS_5 gt 0)fmesai_sayac_4 = fmesai_sayac_4 + 1;
                                if(len(ext_salary_net))t_ext_Salary_net = t_ext_Salary_net + ext_salary_net;
                                
                                T_VERGI_ISTISNA_DAMGA = T_VERGI_ISTISNA_DAMGA +VERGI_ISTISNA_DAMGA;
                                T_VERGI_ISTISNA_VERGI= T_VERGI_ISTISNA_VERGI +VERGI_ISTISNA_VERGI;
                                    
                                if(len(SSK_MATRAH_EXEMPTION))
                                    SSK_MATRAH_EXEMPTION_ = SSK_MATRAH_EXEMPTION;
                                else
                                    SSK_MATRAH_EXEMPTION_ = 0;
                                
                                if(len(TAX_MATRAH_EXEMPTION))
                                    TAX_MATRAH_EXEMPTION_ = TAX_MATRAH_EXEMPTION;
                                else
                                    TAX_MATRAH_EXEMPTION_ = 0;	
                                    
                                t_ssk_matrah_muafiyet = t_ssk_matrah_muafiyet + SSK_MATRAH_EXEMPTION_ + TOTAL_PAY + TOTAL_PAY_TAX;
                                t_vergi_matrah_muafiyet = t_vergi_matrah_muafiyet + TAX_MATRAH_EXEMPTION_;
                                
                                if(len(VERGI_ISTISNA_TOTAL))
                                t_vergi_istisna_net_yaz = t_vergi_istisna_net_yaz + VERGI_ISTISNA_TOTAL;
                                
                                t_vergi_istisna_tutar = t_vergi_istisna_tutar + VERGI_ISTISNA_DAMGA_NET;
                                t_vergi_istisna_yaz = t_vergi_istisna_yaz + VERGI_ISTISNA_SSK + VERGI_ISTISNA_VERGI + VERGI_ISTISNA_DAMGA;
                                t_toplam_kazanc = t_toplam_kazanc + TOTAL_SALARY;
                                
                                t_vergi_indirimi_5084 = t_vergi_indirimi_5084 + vergi_indirimi_5084;
                                if(is_5746_control eq 0) //arge indiriminin gelir vergisinden düşülmemesi ile ilgili toplam icmal icin eklendi //SG 20140306
                                {
                                    if(len(gelir_vergisi_indirimi_5746) and gelir_vergisi_indirimi_5746 gt 0)
                                    {
                                        t_vergi_indirimi_5746_all = t_vergi_indirimi_5746_all + gelir_vergisi_indirimi_5746;
                                    }
                                    if(len(damga_vergisi_indirimi_5746) and damga_vergisi_indirimi_5746 gt 0)
                                    {
                                        t_damga_vergisi_indirimi_5746_all = t_damga_vergisi_indirimi_5746_all + damga_vergisi_indirimi_5746;
                                    }
                                    if(len(stampduty_5746))
                                        t_stampduty_5746 = t_stampduty_5746 + stampduty_5746;
                                }
                                if(len(gelir_vergisi_indirimi_5746) and gelir_vergisi_indirimi_5746 gt 0)
                                {
                                    t_vergi_indirimi_5746 = t_vergi_indirimi_5746 + gelir_vergisi_indirimi_5746;
                                }
                                if(len(damga_vergisi_indirimi_5746) and damga_vergisi_indirimi_5746 gt 0)
                                {
                                    t_damga_vergisi_indirimi_5746 = t_damga_vergisi_indirimi_5746 + damga_vergisi_indirimi_5746;
                                }
                                
                                
                                if(len(tax_days_5746))
                                    t_vergi_indirimi_5746_days = t_vergi_indirimi_5746_days + tax_days_5746;
                                    
                                if(len(ssk_days_5746))
                                    t_ssk_days_5746 = t_ssk_days_5746 + ssk_days_5746;
                                
                                
                                if(is_4691_control eq 0)
                                {
                                    t_vergi_indirimi_4691_all = t_vergi_indirimi_4691_all + gelir_vergisi_indirimi_4691;
                                    t_vergi_indirimi_4691 = t_vergi_indirimi_4691 + gelir_vergisi_indirimi_4691;
                                }
                                

                                //t_kum_gelir_vergisi_matrahi = t_kum_gelir_vergisi_matrahi + KUMULATIF_GELIR_MATRAH - gelir_vergisi_matrah;
                                //Ücret kartından Dönem Başı Kümüle Vergi Tutarı geliyorsa
                                // todo : kapatılan alanlar test için kapatldı. Geri açılacak.
                                if(IS_START_CUMULATIVE_TAX eq 1 and isnumeric(START_CUMULATIVE_TAX) /* and sal_year eq year(START_DATE) */)
                                    t_kum_gelir_vergisi = t_kum_gelir_vergisi + START_CUMULATIVE_TAX;
                                //Ücret kartından Dönem Başı Kümüle Vergi Matrahı geliyorsa e bordroya yansıtılıyorsa
                                if(len(CUMULATIVE_TAX_TOTAL) and  isnumeric(START_CUMULATIVE_TAX) /* and sal_year eq year(START_DATE) */)
                                    t_kum_gelir_vergisi_matrahi = t_kum_gelir_vergisi_matrahi + CUMULATIVE_TAX_TOTAL;
                                t_gelir_vergisi_matrahi = t_gelir_vergisi_matrahi + gelir_vergisi_matrah;
                                t_gelir_vergisi = t_gelir_vergisi + gelir_vergisi;
                                t_damga_vergisi = t_damga_vergisi + damga_vergisi;
                                
                                t_kesinti = t_kesinti + ssk_isci_hissesi + ssdf_isci_hissesi + issizlik_isci_hissesi + damga_vergisi;
                                t_net_ucret = t_net_ucret + net_ucret;
                                t_vergi_iadesi = t_vergi_iadesi + vergi_iadesi;
                                if(len(vergi_iadesi))
                                    t_vergi_iadesi_alan = t_vergi_iadesi_alan + 1;

                                t_ozel_kesinti = t_ozel_kesinti + ozel_kesinti;
                                t_ozel_kesinti_2 = t_ozel_kesinti_2 + ozel_kesinti_2;

                                if(len(ozel_kesinti_2_net))
                                    t_ozel_kesinti_2_net = t_ozel_kesinti_2_net + ozel_kesinti_2_net;
                                if(len(OZEL_KESINTI_2_NET_FARK))
                                    t_ozel_kesinti_2_net_fark = t_ozel_kesinti_2_net_fark + OZEL_KESINTI_2_NET_FARK;
                                if(len(penance_deduction))
                                    t_penance_deduction = t_penance_deduction + penance_deduction;

                                if (SAKATLIK_INDIRIMI gt 0)
                                {
                                    t_sakatlik = t_sakatlik + SAKATLIK_INDIRIMI;
                                    sakat_say = sakat_say + 1;
                                }
                                if (GOCMEN_INDIRIMI gt 0)
                                {
                                    t_gocmen_indirimi = t_gocmen_indirimi + GOCMEN_INDIRIMI;
                                }
                                t_damga_vergisi_matrahi = t_damga_vergisi_matrahi + DAMGA_VERGISI_MATRAH ;

                                t_avans = t_avans + AVANS;
                                ssk_devir_toplam = 0;
                                if(len(ssk_devir))
                                {
                                    ssk_devir_toplam = ssk_devir_toplam + ssk_devir;
                                    t_devirden_gelen = t_devirden_gelen + ssk_devir;
                                }
                                if(len(ssk_devir_last))
                                {
                                    ssk_devir_toplam = ssk_devir_toplam + ssk_devir_last;
                                    t_devirden_gelen = t_devirden_gelen + ssk_devir_last;
                                }
                                if(ssk_statute eq 2 || ssk_statute eq 18)
                                {
                                    ssdf_say = ssdf_say + 1;
                                }
                                else
                                {
                                    ssk_say = ssk_say + 1;
                                }
                                if (ssdf_isveren_hissesi gt 0)
                                {
                                    t_ssdf_ssk_days = t_ssdf_ssk_days + total_days;
                                    t_ssdf_days = t_ssdf_days + total_days - sunday_count;
                                    t_ssdf_matrah = t_ssdf_matrah + SSK_MATRAH;
                                    t_ssdf_isci_hissesi = t_ssdf_isci_hissesi + ssdf_isci_hissesi;
                                    t_ssdf_isveren_hissesi = t_ssdf_isveren_hissesi + ssdf_isveren_hissesi;
                                    if(len(SSK_ISCI_HISSESI_DUSULECEK))
                                        t_sgdp_devir = t_sgdp_devir + SSK_ISCI_HISSESI_DUSULECEK;
                                }
                                else
                                {
                                    t_reel_ssk_days = t_reel_ssk_days + ssk_days;				
                                    /* if (use_ssk eq 1)
                                    {
                                        
                                    } */
                                    t_ssk_matrahi = t_ssk_matrahi + SSK_MATRAH;
                                    if(len(short_working_calc))t_short_working_calc = t_short_working_calc + short_working_calc;
                                    t_ssk_primi_isci = t_ssk_primi_isci + ssk_isci_hissesi;
                                    t_ssk_primi_isveren = t_ssk_primi_isveren + ssk_isveren_hissesi;
                                    isveren_hesaplanan = ssk_isveren_hissesi + ssk_isveren_hissesi_5510 + ssk_isveren_hissesi_5084;
                                    t_ssk_primi_isveren_hesaplanan = t_ssk_primi_isveren_hesaplanan + isveren_hesaplanan;
                                    t_ssk_primi_isveren_5510 = wrk_round(t_ssk_primi_isveren_5510,2) + ssk_isveren_hissesi_5510;
                                    t_ssk_primi_isveren_5084 = t_ssk_primi_isveren_5084 + ssk_isveren_hissesi_5084;
                                    t_ssk_primi_isveren_5921 = t_ssk_primi_isveren_5921 + ssk_isveren_hissesi_5921;
                                    t_ssk_primi_isveren_5746 = t_ssk_primi_isveren_5746 + ssk_isveren_hissesi_5746;
                                    if(len(ssk_isveren_hissesi_4691))
                                        t_ssk_primi_isveren_4691 = t_ssk_primi_isveren_4691 + ssk_isveren_hissesi_4691;
                                    if(len(ssk_isveren_hissesi_6111))
                                        t_ssk_primi_isveren_6111 = t_ssk_primi_isveren_6111 + ssk_isveren_hissesi_6111;
                                    if(len(ssk_isveren_hissesi_6486))
                                        t_ssk_primi_isveren_6486 = t_ssk_primi_isveren_6486 + ssk_isveren_hissesi_6486;
                                    if(len(ssk_isveren_hissesi_6322))
                                        t_ssk_primi_isveren_6322 = t_ssk_primi_isveren_6322 + ssk_isveren_hissesi_6322;
                                    if(len(ssk_isci_hissesi_6322))
                                        t_ssk_primi_isci_6322 = t_ssk_primi_isci_6322 + ssk_isci_hissesi_6322;
                                    if(len(ssk_isveren_hissesi_25510))
                                        t_ssk_primi_isveren_25510 = t_ssk_primi_isveren_25510 + ssk_isveren_hissesi_25510;
                                    if(len(ssk_isveren_hissesi_14857))
                                        t_ssk_primi_isveren_14857 = t_ssk_primi_isveren_14857 + ssk_isveren_hissesi_14857;
                                    if(len(ssk_isveren_hissesi_6645))
                                        t_ssk_primi_isveren_6645 = t_ssk_primi_isveren_6645 + ssk_isveren_hissesi_6645;
                                    if(len(ssk_isveren_hissesi_46486))
                                        t_ssk_primi_isveren_46486 = t_ssk_primi_isveren_46486 + ssk_isveren_hissesi_46486;
                                    if(len(ssk_isveren_hissesi_56486))
                                        t_ssk_primi_isveren_56486 = t_ssk_primi_isveren_56486 + ssk_isveren_hissesi_56486;
                                    if(len(ssk_isveren_hissesi_66486))
                                        t_ssk_primi_isveren_66486 = t_ssk_primi_isveren_66486 + ssk_isveren_hissesi_66486;
                                    if(len(ssk_isveren_hissesi_gov))
                                        t_ssk_primi_isveren_gov = t_ssk_primi_isveren_gov + ssk_isveren_hissesi_gov;
                                    else
                                        t_ssk_primi_isveren_gov = t_ssk_primi_isveren_gov + 0;
                                    t_issizlik_isci_hissesi = t_issizlik_isci_hissesi + issizlik_isci_hissesi;
                                    if(issizlik_isci_hissesi gt 0 and ssk_devir_toplam gt 0)
                                        t_issizlik_isci_hissesi_devirsiz = t_issizlik_isci_hissesi_devirsiz + wrk_round((SSK_MATRAH - ssk_devir_toplam) * 1 / 100);
                                    else
                                        t_issizlik_isci_hissesi_devirsiz = t_issizlik_isci_hissesi_devirsiz + issizlik_isci_hissesi;
                                    if(ssk_isci_hissesi gt 0 and ssk_devir_toplam gt 0)
                                        t_ssk_primi_isci_devirsiz = t_ssk_primi_isci_devirsiz + wrk_round((SSK_MATRAH - ssk_devir_toplam) * 14 / 100);
                                    else
                                        t_ssk_primi_isci_devirsiz = t_ssk_primi_isci_devirsiz + ssk_isci_hissesi;
                                    t_issizlik_isveren_hissesi = t_issizlik_isveren_hissesi + issizlik_isveren_hissesi;
                                    
                                    if(len(ssk_isveren_hissesi_687))
                                        t_isveren_primi_687 = t_isveren_primi_687 + ssk_isveren_hissesi_687;
                                    
                                    if(len(ssk_isci_hissesi_687) or len(ssk_isveren_hissesi_687))
                                        t_ssk_primi_687 = t_ssk_primi_687 + ssk_isveren_hissesi_687 + ssk_isci_hissesi_687;
                                        
                                    if(len(issizlik_isci_hissesi_687) or len(issizlik_isveren_hissesi_687))
                                    {
                                        t_issizlik_primi_687 = t_issizlik_primi_687 + issizlik_isci_hissesi_687 + issizlik_isveren_hissesi_687;
                                        t_issizlik_isci_hissesi_687 = t_issizlik_isci_hissesi_687 + issizlik_isci_hissesi_687;
                                        t_issizlik_isveren_hissesi_687 = t_issizlik_isveren_hissesi_687 + issizlik_isveren_hissesi_687;
                                    }
                                        
                                    
                                    if(len(gelir_vergisi_indirimi_687))
                                        t_gelir_vergisi_primi_687 = t_gelir_vergisi_primi_687 + gelir_vergisi_indirimi_687;
                                        
                                    if(len(damga_vergisi_indirimi_687))
                                        t_damga_vergisi_primi_687 = t_damga_vergisi_primi_687 + damga_vergisi_indirimi_687;
                                    if(len(ssk_isveren_hissesi_687))
                                        toplam_indirim_687 =  toplam_indirim_687 + ssk_isveren_hissesi_687 + ssk_isci_hissesi_687 + issizlik_isveren_hissesi_687 + issizlik_isci_hissesi_687 + gelir_vergisi_indirimi_687 + damga_vergisi_indirimi_687;
                                    
                                    if(len(ssk_isveren_hissesi_7103))
                                    {
                                        t_isveren_primi_7103 = t_isveren_primi_7103 + ssk_isveren_hissesi_7103;
                                        t_ssk_primi_7103 = t_ssk_primi_7103 + ssk_isci_hissesi_7103 + ssk_isveren_hissesi_7103;
                                        t_ssk_isveren_hissesi_7103 = t_ssk_isveren_hissesi_7103 + ssk_isveren_hissesi_7103;
                                        t_issizlik_primi_7103 = t_issizlik_primi_7103 + issizlik_isci_hissesi_7103 + issizlik_isveren_hissesi_7103;
                                        if(len(gelir_vergisi_indirimi_7103))
                                        {
                                            t_gelir_vergisi_primi_7103 = t_gelir_vergisi_primi_7103 + gelir_vergisi_indirimi_7103;
                                            toplam_indirim_7103 = toplam_indirim_7103 +gelir_vergisi_indirimi_7103;
                                        }
                                        if(len(damga_vergisi_indirimi_7103))
                                        {
                                            t_damga_vergisi_primi_7103 = t_damga_vergisi_primi_7103 + damga_vergisi_indirimi_7103;
                                            toplam_indirim_7103 = toplam_indirim_7103 + damga_vergisi_indirimi_7103;
                                        }
                                        toplam_indirim_7103 =  toplam_indirim_7103 + ssk_isveren_hissesi_7103 + ssk_isci_hissesi_7103 + issizlik_isveren_hissesi_7103 + issizlik_isci_hissesi_7103 ;
                                        t_ssk_isci_hissesi_7103 = t_ssk_isci_hissesi_7103 + ssk_isci_hissesi_7103;
                                        t_issizlik_isci_hissesi_7103 = t_issizlik_isci_hissesi_7103 + issizlik_isci_hissesi_7103;
                                        t_issizlik_isveren_hissesi_7103 = t_issizlik_isveren_hissesi_7103 + issizlik_isveren_hissesi_7103;
                                    }
                                    
                                    if(len(SSK_ISVEREN_HISSESI_7252))
                                        t_ssk_isveren_hissesi_7252 = t_ssk_isveren_hissesi_7252 + SSK_ISVEREN_HISSESI_7252;
                                    if(len(ssk_isci_hissesi_7252))
                                        t_ssk_isci_hissesi_7252 = t_ssk_isci_hissesi_7252 + ssk_isci_hissesi_7252;
                                    if(len(issizlik_isci_hissesi_7252))
                                        t_issizlik_isci_hissesi_7252 = t_issizlik_isci_hissesi_7252 + issizlik_isci_hissesi_7252;
                                    if(len(issizlik_isci_hissesi_7252))
                                        t_issizlik_isveren_hissesi_7252 = t_issizlik_isveren_hissesi_7252 + issizlik_isveren_hissesi_7252;
                                    if(len(SSK_DAYS_7252))
                                    {
                                        t_ssk_days_7252 = t_ssk_days_7252 + ssk_days_7252;
                                        t_toplam_indirim_7252 = t_toplam_indirim_7252  + ssk_isci_hissesi_7252 + issizlik_isveren_hissesi_7252 + issizlik_isci_hissesi_7252 + ssk_isveren_hissesi_7252;
                                        t_ssk_primi_7252 = t_ssk_primi_7252 + ssk_isveren_hissesi_7252 + ssk_isci_hissesi_7252;
                                    }

                                    if(len(SSK_ISVEREN_HISSESI_7256))
                                    {
                                        t_ssk_isveren_hissesi_7256 = t_ssk_isveren_hissesi_7256 + SSK_ISVEREN_HISSESI_7256;
                                        t_toplam_indirim_7256 = t_toplam_indirim_7256 + SSK_ISVEREN_HISSESI_7256;
                                        t_ssk_primi_7256 = t_ssk_primi_7256 + ssk_isveren_hissesi_7256 + ssk_isci_hissesi_7252;
                                        if(len(base_amount_7256))
                                            t_base_amount_7256 = t_base_amount_7256 + base_amount_7256;
                                    }

                                    if(len(ssk_isci_hissesi_7256))
                                    {
                                        t_ssk_isci_hissesi_7256 = t_ssk_isci_hissesi_7256 + ssk_isci_hissesi_7256;
                                        t_toplam_indirim_7256 = t_toplam_indirim_7256 + ssk_isci_hissesi_7256;
                                        t_ssk_primi_7256 = t_ssk_primi_7256 + ssk_isci_hissesi_7256;
                                    }
                                    if(len(issizlik_isci_hissesi_7256))
                                    {
                                        t_issizlik_isci_hissesi_7256 = t_issizlik_isci_hissesi_7256 + issizlik_isci_hissesi_7256;
                                        t_toplam_indirim_7256 = t_toplam_indirim_7256 + issizlik_isci_hissesi_7256;
                                    }
                                    if(len(issizlik_isveren_hissesi_7256))
                                    {
                                        t_issizlik_isveren_hissesi_7256 = t_issizlik_isveren_hissesi_7256 + issizlik_isveren_hissesi_7256;
                                        t_toplam_indirim_7256 = t_toplam_indirim_7256 + issizlik_isveren_hissesi_7256;
                                    }
                                }
                                t_bes_primi_isci = t_bes_primi_isci + bes_isci_hissesi;
                                
                                t_total_pay_ssk_tax = t_total_pay_ssk_tax + total_pay_ssk_tax;
                                t_total_pay_ssk = t_total_pay_ssk + total_pay_ssk;
                                t_total_pay_tax = t_total_pay_tax + total_pay_tax;
                                t_total_pay = t_total_pay + total_pay;

                                //ssk işçi primi indirimli
                                t_isci_primi_indirimli = t_ssk_primi_isci - (t_ssk_primi_isci_6322 + t_ssk_isci_hissesi_7252 + t_ssk_isci_hissesi_7256 + t_ssk_isci_hissesi_7103);
                                //ssk işsizlik işçi pirimi indirimli
                                t_issizlik_isci_primi_indirimli = t_issizlik_isci_hissesi - (t_issizlik_isci_hissesi_7252 + t_issizlik_isci_hissesi_7256 + t_issizlik_isci_hissesi_687 + t_issizlik_isci_hissesi_7103 );
                                //ssk işsizlik işveren primi indirimli
                                t_issizlik_isveren_primi_indirimli = t_issizlik_isveren_hissesi - (t_issizlik_isveren_hissesi_687 + t_issizlik_isveren_hissesi_7103 + t_issizlik_isveren_hissesi_7252 + t_issizlik_isveren_hissesi_7256);

                            </cfscript>
                            <cfquery name="get_devreden" datasource="#dsn#">
                                SELECT 
                                    AMOUNT 
                                FROM 
                                    #add_puantaj_table# 
                                WHERE 
                                    EMPLOYEE_PUANTAJ_ID = #EMPLOYEE_PUANTAJ_ID# AND 
                                    <cfif isdefined('attributes.sal_year_end') and len(attributes.sal_year_end) and isdefined('attributes.sal_mon_end') and len(attributes.sal_mon_end)>
                                        (
                                            (SAL_YEAR > <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.sal_year#"> AND SAL_YEAR < <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.sal_year_end#">)
                                            OR
                                            (
                                                SAL_YEAR = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.sal_year#"> AND 
                                                SAL_MON >= <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.sal_mon#"> AND
                                                (
                                                    SAL_YEAR < <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.sal_year_end#">
                                                    OR
                                                    (SAL_MON <= <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.sal_mon_end#"> AND SAL_YEAR = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.sal_year_end#">)
                                                )
                                            )
                                            OR
                                            (
                                                SAL_YEAR > <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.sal_year#"> AND 
                                                (
                                                    SAL_YEAR < <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.sal_year_end#">
                                                    OR
                                                    (SAL_MON <= <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.sal_mon_end#"> AND SAL_YEAR = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.sal_year_end#">)
                                                )
                                            )
                                            OR
                                            (
                                                SAL_YEAR = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.sal_year_end#"> AND
                                                SAL_MON >= <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.sal_mon#"> AND
                                                SAL_MON <= <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.sal_mon_end#">
                                            )
                                        )
                                    <cfelse>
                                        SAL_YEAR = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.sal_year#"> AND
                                        SAL_MON = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.sal_mon#">
                                    </cfif>
                            </cfquery>
                            <cfif get_devreden.recordcount>
                                <cfset t_devreden = t_devreden + get_devreden.amount>
                            </cfif>
                            <cfset in_out_cmp = createObject("component","V16.hr.ehesap.cfc.employees_in_out") />
                            <cfset get_emp_ssk = in_out_cmp.get_emp_ssk(in_out_id : in_out_id)>
                            <cfif get_personal.SSK_STATUTE neq 33>
                                <tr style="border:1px solid ##000;">
                                    <td>#TC_IDENTY_NO#</td>
                                    <td>#RETIRED_REGISTRY_NO#</td> <!--- Emekli Sicil No --->
                                    <td>#EMPLOYEE_NAME# #EMPLOYEE_SURNAME#</td>
                                    <td>
                                        <cfif get_emp_ssk.is_suspension eq 1>
                                            <cfif dateCompare(attributes.sal_mon, suspension_startdate) eq 0> <!--- açığa alınma tarihi ile puantaj tarihi aynı ise --->
                                                A
                                            </cfif>
                                        <cfelse>
                                            0
                                        </cfif>
                                    </td> <!--- durum kodu --->
                                    <td>#dateformat(start_date, 'DD.MM.YYYY')#</td> <!--- göreve Başalama tarihi --->
                                    <td>
                                        <cfquery name="get_emp1" datasource="#dsn#">
                                            select * from EMPLOYEES_IN_OUT where EMPLOYEE_ID = #EMPLOYEE_ID#
                                        </cfquery>
                                        <cfloop list="#reason_order_list()#" index="ccc">
                                            <cfset value_name_ = listgetat(reason_list(),ccc,';')>
                                            <cfset value_id_ = ccc>
                                            <cfif value_id_ eq get_emp1.explanation_id>#value_name_#</cfif>
                                            <cfbreak>
                                        </cfloop>
                                    </td> <!--- göreve Başalama sebebi --->
                                    <td><cfif len(finish_date)>#finish_date#<cfelse>0000</cfif></td> <!--- görevden ayrılma tarihi --->
                                    <td>
                                        <cfloop list="#reason_order_list()#" index="ccc">
                                            <cfset value_name_ = listgetat(reason_list(),ccc,';')>
                                            <cfset value_id_ = ccc>
                                            <cfif value_id_ eq get_emp1.explanation_id>#value_name_#</cfif>
                                            <cfbreak>
                                        </cfloop>
                                    </td> <!--- görevden ayrılma sebebi --->
                                    <td>#NORMAL_GRADE#</td> <!--- ödemeye esas derece --->
                                    <td>#NORMAL_STEP#</td> <!--- ödemeye esas kademe --->
                                    <td>#NORMAL_ADDITIONAL_SCORE#</td> <!--- ödemeye esas ek gösterge --->
                                    <td> <!--- Kıdem Hizmet / Kıdem Aylığı --->
                                        <cfset dtFrom = ParseDateTime(GROUP_STARTDATE) />
                                        <cfset dtTo = Now() />
                                        <cfset dtDiff = (dtTo - dtFrom)>
                                        #DateFormat( dtDiff, "yy" )##DateFormat( dtDiff, "mm" )##DateFormat( dtDiff, "dd" )#
                                    </td> <!--- Kıdem Hizmet / Kıdem Aylığı --->
                                    <td>#SSK_DAYS#</td> <!--- Prim ödeme gün sayısı --->
                                    <td>#tlformat(t_tazminatlar)#</td> <!--- tazminat ve ek ödemeler --->
                                    <td>#tlformat(SGK_BASE-t_tazminatlar)#</td> <!--- aylık toplamı --->
                                    <td>#tlformat(SGK_BASE)#</td> <!--- prime esas kazanç genel --->
                                    <td>#tlformat((SGK_BASE * 9)/100)#</td> <!--- %9 myo --->
                                    <td>#tlformat((SGK_BASE * 5)/100)#</td> <!--- %5 gss --->
                                    <td>#tlformat((SGK_BASE * 11)/100)#</td> <!--- %11 myo --->
                                    <td>#tlformat((SGK_BASE * 7.5)/100)#</td> <!--- %7,5 gss --->
                                </tr>
                            </cfif>
                        </cfoutput>
                    </table>
                </div>
                <div style="position: absolute;bottom: 8mm;right: 8mm;"><cfoutput>#i#/#total_page#</cfoutput></div>
            </div>
        </cfloop>
    </div>
</cf_box>
<cfif icmal_type is 'personal' and listFirst(attributes.fuseaction,".") is 'myhome'>
    <div class="col col-2">
        <ul class="ui-list padding-top-20">
            <li class="bold mb-0">
                <cf_get_lang dictionary_id ='31779.Puantaj Hazırlandı'>
            </li>
            <li class="bold mb-0">
                <cf_get_lang dictionary_id ='31780.Bordro Okundu'><cfoutput>#dateformat(now(),dateformat_style)#</cfoutput>
            </li>	
            <cfif get_apply_status.recordcount>
                <li class="bold mb-0">
                    <p id="bordro_onay_td">
                        <cfif len(get_apply_status.apply_date)>
                            Bordro Onaylandı <cfoutput>#dateformat(now(),dateformat_style)#</cfoutput>
                        <cfelse>
                            <span class="btnPointer" class="btnPointer" onclick="bordro_onayla('<cfoutput>#get_apply_status.ROW_ID#</cfoutput>');">Bordro Onayla</span>
                        </cfif>
                    </p>
                </li>
            </cfif>
            <cfoutput>
                <cfif get_protests.recordcount>
                    <li class="bold mb-0">
                        <span class="btnPointer" onclick="windowopen('#request.self#?fuseaction=myhome.popup_list_bordro_protests&sal_mon=#attributes.sal_mon#&sal_year=#attributes.sal_year#&emp_puantaj_id=#GET_PUANTAJ_PERSONAL.EMPLOYEE_PUANTAJ_ID#&puantaj_id=#GET_PUANTAJ_PERSONAL.PUANTAJ_ID#','list');"><cf_get_lang dictionary_id ='31784.İtirazlarım'></span>
                    </li>
                </cfif>
                <cfif get_protests.recordcount and len(get_protests.answer_date)>
                    <li class="bold mb-0">
                        <span class="btnPointer" onclick="windowopen('#request.self#?fuseaction=myhome.popup_list_bordro_protests&sal_mon=#attributes.sal_mon#&sal_year=#attributes.sal_year#&emp_puantaj_id=#GET_PUANTAJ_PERSONAL.EMPLOYEE_PUANTAJ_ID#&puantaj_id=#GET_PUANTAJ_PERSONAL.PUANTAJ_ID#','list');"><cf_get_lang dictionary_id ='31785.İtirazlara Cevaplar'></span>
                    </li>
                </cfif>
                <cfif not get_protests.recordcount>
                    <li class="bold mb-0">
                        <span class="btnPointer" onclick="windowopen('#request.self#?fuseaction=myhome.popup_add_puantaj_protest&sal_mon=#attributes.sal_mon#&sal_year=#attributes.sal_year#&emp_puantaj_id=#GET_PUANTAJ_PERSONAL.EMPLOYEE_PUANTAJ_ID#&puantaj_id=#GET_PUANTAJ_PERSONAL.PUANTAJ_ID#&branch_id=#GET_PUANTAJ_PERSONAL.branch_id#','small');"><cf_get_lang dictionary_id ='31715.İtiraz Et'></span>
                    </li>
                </cfif>
            </cfoutput>
        </ul>
    </div>
</cfif>

<cf_get_lang_set module_name="#fusebox.circuit#">
<script type="text/javascript">
    function bordro_onayla(row_id)
    {
        $.ajax({                
            url: '<cfoutput>#request.self#?fuseaction=myhome.emptypopup_apply_puantaj&row_id=</cfoutput>'+row_id,
            type: "GET",
            success: function (returnData) {
                document.getElementById('bordro_onay_td').innerHTML = 'Bordro Onaylandı <cfoutput>#dateformat(now(),dateformat_style)#</cfoutput>';
            }
        });
    }
</script>