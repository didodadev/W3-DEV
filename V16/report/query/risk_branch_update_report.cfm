<!--- 
	CRM_Risk_Branch_Update_Report isimli raporun query sayfasi
	Risk Yonetimi Onay Sureci - Risk Limiti Merkez Onay Asamasi Process_id = 408
 --->

 <cfquery name="get_branch" datasource="#dsn#">
	SELECT
		BRANCH.BRANCH_NAME,
		BRANCH.BRANCH_ID,
		COMPANY_BOYUT_DEPO_KOD.BOYUT_KODU
	FROM 
		BRANCH,
		COMPANY_BOYUT_DEPO_KOD
	WHERE
		COMPANY_BOYUT_DEPO_KOD.W_KODU = BRANCH.BRANCH_ID AND
		COMPANY_BOYUT_DEPO_KOD.DEPO_KOD_ID NOT IN (26,27,28,29,30,31,0)
	ORDER BY 
		BRANCH_ID
</cfquery>
<cfloop from="1" to="#attributes.musteridurum_recordcount#" index="i">
        <cfset risc_related_id_ = evaluate('attributes.risc_related_id_#i#')>
        <cfset risc_branch_id_ = evaluate('attributes.risc_branch_id_#i#')>
        <cfset risc_company_id_ = evaluate('attributes.risc_company_id_#i#')>
        <cfset risc_limit_value_ = evaluate('attributes.risc_limit_value_#i#')>
        <cfscript>
            risc_limit_value_ = filterNum(risc_limit_value_);
        </cfscript>
        
        <cfif len(risc_limit_value_) and risc_limit_value_ gt 0>
            <cfquery name="upd_risk_limiti" datasource="#dsn#">
                UPDATE
                    COMPANY_CREDIT
                SET
                    TOTAL_RISK_LIMIT = #risc_limit_value_#,
                    MONEY = '#session.ep.money#'
                WHERE
                    BRANCH_ID = #risc_related_id_#
            </cfquery>
            <cfquery name="add_risk_request" datasource="#dsn#">
                INSERT INTO
                    COMPANY_RISK_REQUEST
                (
                    COMPANY_ID,
                    BRANCH_ID,
                    PROCESS_CAT,
                    RISK_TOTAL,
                    RISK_MONEY_CURRENCY,
                    DETAIL,
                    VALID_DATE,
                    IS_ACTIVE,
                    IS_SUBMIT,
                    IS_RUN,
                    IS_MULTI,
                    RECORD_DATE,
                    RECORD_EMP,
                    RECORD_IP
                )
                VALUES
                (
                    #risc_company_id_#,
                    #risc_branch_id_#,
                    408,
                    #risc_limit_value_#,
                    '#session.ep.money#',
                    'Toplu Risk Ekleme',
                    NULL,
                    1,
                    1,
                    NULL,
                    1,
                    #now()#,
                    #session.ep.userid#,
                    '#cgi.remote_addr#'
                )
            </cfquery>
            <cfquery name="get_max_risk" datasource="#dsn#">
                SELECT MAX(REQUEST_ID) AS MAX_ID FROM COMPANY_RISK_REQUEST
            </cfquery>
            <cfquery name="ADD_NOTE" datasource="#dsn#">
                INSERT INTO 
                    NOTES
                (
                    ACTION_SECTION,
                    ACTION_ID,
                    NOTE_HEAD,
                    NOTE_BODY,
                    IS_SPECIAL,
                    IS_WARNING,
                    COMPANY_ID,
                    RECORD_EMP,
                    RECORD_DATE,
                    RECORD_IP
                )
                VALUES
                (
                    'REQUEST_ID',
                     #get_max_risk.max_id#,
                    'Toplu Risk Ekleme',
                    'Toplu Risk Ekleme',
                     0,
                     0,
                     #session.ep.company_id#,
                     #session.ep.userid#,
                     #now()#,
                    '#cgi.remote_addr#'
                )
            </cfquery>
            <cfquery name="UPD_RELATED" datasource="#dsn#">
                UPDATE COMPANY_BRANCH_RELATED SET IS_MERKEZ = 1 WHERE RELATED_ID = #risc_related_id_#
            </cfquery>
            <cfquery name="GET_MUSTERI_DURUM" datasource="hedef_crm">
                SELECT
                    1 TYPE,
                    HMD.KARSILIKSIZ_CEK_TUTAR, 
                    HMD.KARSILIKSIZ_CEK_ORTGUN, 
                    HMD.KARSILIKSIZ_SENET_TUTAR, 
                    HMD.KARSILIKSIZ_SENET_ORTGUN, 
                    HMD.KARSILIKSIZ_POS_TUTAR, 
                    HMD.KARSILIKSIZ_POS_ORTGUN, 
                    HMD.KARSILIKSIZ_KK_TUTAR, 
                    HMD.KARSILIKSIZ_KK_ORTGUN, 
                    HMD.KARSILIKSIZ_ACIKHESAP_TUTAR,
                    HMD.KARSILIKSIZ_ACIKHESAP_ORTGUN, 
                    HMD.RISK_LIMIT, 
                    HMD.RISK_TOPLAM, 
                    ((HMD.KARSILIKSIZ_CEK_TUTAR*HMD.KARSILIKSIZ_CEK_ORTGUN) + (HMD.KARSILIKSIZ_SENET_TUTAR*HMD.KARSILIKSIZ_SENET_ORTGUN) + (HMD.KARSILIKSIZ_POS_TUTAR*HMD.KARSILIKSIZ_POS_ORTGUN)+ (HMD.KARSILIKSIZ_KK_TUTAR*HMD.KARSILIKSIZ_KK_ORTGUN)+ (HMD.KARSILIKSIZ_ACIKHESAP_TUTAR*HMD.KARSILIKSIZ_ACIKHESAP_ORTGUN))/(HMD.KARSILIKSIZ_CEK_TUTAR+HMD.KARSILIKSIZ_SENET_TUTAR+HMD.KARSILIKSIZ_POS_TUTAR+HMD.KARSILIKSIZ_KK_TUTAR+HMD.KARSILIKSIZ_ACIKHESAP_TUTAR+1) TOTAL_ORT_GUN,
                    (HMD.KARSILIKSIZ_CEK_TUTAR+HMD.KARSILIKSIZ_SENET_TUTAR+HMD.KARSILIKSIZ_POS_TUTAR+HMD.KARSILIKSIZ_KK_TUTAR+HMD.KARSILIKSIZ_ACIKHESAP_TUTAR+1) TOTAL_TUTAR,
                    HMD.DEPO_KODU,
                    HMD.HEDEFKODU
                FROM 
                    (SELECT MAX(AKTARIM_TARIH) TARIH, HEDEFKODU, DEPO_KODU FROM HEDEF.HEDEF_MUSTERI_DURUM WHERE DEPO_KODU IS NOT NULL GROUP BY HEDEFKODU, DEPO_KODU ) Q1,
                    HEDEF.HEDEF_MUSTERI_DURUM HMD
                WHERE
                    HMD.DEPO_KODU = '#get_branch.boyut_kodu#' AND
                    HMD.HEDEFKODU = #risc_company_id_# AND
                    HMD.AKTARIM_TARIH = Q1.TARIH AND
                    HMD.HEDEFKODU = Q1.HEDEFKODU AND
                    HMD.DEPO_KODU = Q1.DEPO_KODU AND
                    HMD.HEDEFKODU > 0			
            </cfquery>
            
            <!--- Eski log dosyalarindaki kayitların son eklenenin guncel olmasi icin eklendi --->
            <cfquery name="UPD_COMPANY_RISK_LOG" datasource="#dsn#">
                UPDATE
                    COMPANY_RISK_REQUEST_LOG
                SET
                    IS_STATUS = 0
                WHERE
                    RISK_LOG_TYPE = 1 AND
                    COMPANY_ID = #risc_company_id_# AND
                    BRANCH_ID = #risc_branch_id_# AND
                    RELATED_ID = #risc_related_id_#
            </cfquery>
            
            <!--- RISK_LOG_TYPE burdan atilan degerlerde 1 set edilecek --->
            <cfquery name="ADD_COMPANY_RISK_REQUEST_LOG" datasource="#dsn#">
                INSERT INTO
                    COMPANY_RISK_REQUEST_LOG
                (
                    RELATED_ID,
                    COMPANY_ID,
                    BRANCH_ID,
                    CHECK_TOTAL,
                    CHECK_TERM,
                    VOUCHER_TOTAL,
                    VOUCHER_TERM,
                    OPEN_ACCOUNT_TOTAL,
                    OPEN_ACCOUNT_TERM,
                    RISK_TOTAL,
                    RISK_LOG_TYPE,
                    IS_STATUS,
                    RECORD_DATE,
                    RECORD_EMP,
                    RECORD_IP
                )
                VALUES
                (
                    #risc_related_id_#,
                    #risc_company_id_#,
                    #risc_branch_id_#,
                  <cfif get_musteri_durum.recordcount>
                    #get_musteri_durum.karsiliksiz_cek_tutar#,
                    #get_musteri_durum.karsiliksiz_cek_ortgun#,
                    #get_musteri_durum.karsiliksiz_senet_tutar#,
                    #get_musteri_durum.karsiliksiz_senet_ortgun#,
                    #get_musteri_durum.karsiliksiz_acikhesap_tutar#,
                    #get_musteri_durum.karsiliksiz_acikhesap_ortgun#,
                    #get_musteri_durum.risk_toplam#,
                <cfelse>
                    0,
                    0,
                    0,
                    0,
                    0,
                    0,
                    0,
                </cfif>			
                    1,
                    1,
                    #now()#,
                    #session.ep.userid#,
                    '#cgi.remote_addr#'
                )
            </cfquery>
            <cfscript>
                attributes.kayittipi = 2;
                attributes.is_boyut_insert = false ;
                function tr_to_iso(attributes_list)
                {
                    var return_value = '';
                    return_value = replacelist(attributes_list,'ü,ğ,ı,ş,ç,ö,Ü,Ğ,İ,Ş,Ç,Ö,|','U,G,I,S,C,O,U,G,I,S,C,O, ');
                    return return_value;
                }
                branch_list = '#valuelist(get_branch.branch_id)#';
            </cfscript>
            <cfquery name="GET_COMPANY" datasource="#dsn#">
                SELECT 
                    COMPANY.GLNCODE,
                    COMPANY.COMPANY_ID,
                    COMPANY.FULLNAME,
                    COMPANY.DISTRICT,
                    COMPANY.STREET,
                    COMPANY.MAIN_STREET,
                    COMPANY.DUKKAN_NO,
                    COMPANY.SEMT,
                    COMPANY.COMPANY_TELCODE,
                    COMPANY.COMPANY_TEL1,
                    COMPANY.COMPANY_FAX,
                    COMPANY.COMPANY_FAX_CODE,
                    COMPANY.COMPANY_POSTCODE,
                    COMPANY.TAXNO,
                    COMPANY.TAXOFFICE,
                    COMPANY.OLD_COMPANY_ID,
                    COMPANY.COMPANY_EMAIL,
                    COMPANY.COMPANY_ADDRESS,
                    COMPANY.COMPANYCAT_ID,
                    COMPANY.GRUP_RISK_LIMIT,
                    COMPANY_PARTNER.COMPANY_PARTNER_NAME,
                    COMPANY_PARTNER.COMPANY_PARTNER_SURNAME,
                    COMPANY_PARTNER.TC_IDENTITY,
                    COMPANY_BOYUT_DEPO_KOD.BOYUT_KODU,
                    COMPANY_BRANCH_RELATED.MUHASEBEKOD,
                    COMPANY_BRANCH_RELATED.CARIHESAPKOD,
                    COMPANY_BRANCH_RELATED.MUSTERIDURUM,
                    COMPANY_BRANCH_RELATED.BOYUT_BSM,
                    COMPANY_BRANCH_RELATED.SALES_DIRECTOR,
                    COMPANY_BRANCH_RELATED.RELATED_ID,
                    COMPANY_BRANCH_RELATED.BOYUT_ITRIYAT,
                    COMPANY_BRANCH_RELATED.ITRIYAT_GOREVLI,
                    COMPANY_BRANCH_RELATED.BOYUT_PLASIYER,
                    COMPANY_BRANCH_RELATED.PLASIYER_ID,
                    COMPANY_BRANCH_RELATED.BOYUT_TAHSILAT,
                    COMPANY_BRANCH_RELATED.TAHSILATCI,
                    COMPANY_BRANCH_RELATED.BOYUT_TELEFON,
                    COMPANY_BRANCH_RELATED.TEL_SALE_PREID,
                    COMPANY_BRANCH_RELATED.OPEN_DATE,
                    COMPANY_BRANCH_RELATED.CEP_SIRA,
                    COMPANY_BRANCH_RELATED.BOLGE_KODU,
                    COMPANY_BRANCH_RELATED.ALTBOLGE_KODU,
                    COMPANY_BRANCH_RELATED.DEPOT_KM,
                    COMPANY_BRANCH_RELATED.CALISMA_SEKLI,
                    COMPANY_BRANCH_RELATED.PUAN,
                    COMPANY_BRANCH_RELATED.LOGO_MUSTERI_TIP,
                    SETUP_COUNTY.COUNTY_NAME,
                    SETUP_COUNTY.COUNTY_ID,
                    SETUP_CITY.CITY_NAME,
                    SETUP_CITY.PLATE_CODE,
                    SETUP_IMS_CODE.IMS_CODE,
                    SETUP_IMS_CODE.IMS_CODE_501
                FROM
                    COMPANY,
                    COMPANY_BRANCH_RELATED,
                    COMPANY_BOYUT_DEPO_KOD,
                    COMPANY_PARTNER, 
                    SETUP_COUNTY,
                    BRANCH,
                    SETUP_CITY,
                    SETUP_IMS_CODE
                WHERE
                    COMPANY_BRANCH_RELATED.RELATED_ID = #risc_related_id_# AND
                    COMPANY.COMPANY_STATUS = 1 AND
                    COMPANY_BRANCH_RELATED.BRANCH_ID IN (#branch_list#) AND
                    COMPANY_BRANCH_RELATED.COMPANY_ID = COMPANY.COMPANY_ID AND 
                    COMPANY_BRANCH_RELATED.BRANCH_ID = COMPANY_BOYUT_DEPO_KOD.W_KODU AND
                    COMPANY_PARTNER.PARTNER_ID = COMPANY.MANAGER_PARTNER_ID AND
                    COMPANY_PARTNER.COMPANY_ID = COMPANY.COMPANY_ID AND
                    COMPANY.COUNTY = SETUP_COUNTY.COUNTY_ID AND
                    COMPANY_BOYUT_DEPO_KOD.W_KODU = BRANCH.BRANCH_ID AND
                    COMPANY_BRANCH_RELATED.BRANCH_ID = BRANCH.BRANCH_ID AND
                    COMPANY.CITY = SETUP_CITY.CITY_ID AND
                    SETUP_IMS_CODE.IMS_CODE_ID = COMPANY.IMS_CODE_ID
            </cfquery>
            <cfif get_company.recordcount>
                <cfscript>
                    tarih_open = dateformat(get_company.open_date,'dd/mm/yyyy');
                    if(len(get_company.muhasebekod))
                    {
                        muhasebekod1 = mid(get_company.muhasebekod,1,3);
                        muhasebekod2 = mid(get_company.muhasebekod,4,2);
                        muhasebekod3 = mid(get_company.muhasebekod,6,(len(get_company.muhasebekod)-5));
                    }
                    else
                    {
                        muhasebekod1 = '';
                        muhasebekod2 = '';
                        muhasebekod3 = '';
                    }
                </cfscript>
                <cfquery name="GET_COMPANY_BOYUT" datasource="mushizgun">
                    SELECT ETICARETKOD, ETICARETIP FROM DEPOLAR WHERE DEPOKODU = '#get_company.boyut_kodu#'
                </cfquery>
                <cfquery name="GET_CREDIT" datasource="#dsn#">
                    SELECT TOTAL_RISK_LIMIT, MONEY FROM COMPANY_CREDIT WHERE COMPANY_ID = #risc_company_id_# AND BRANCH_ID = #get_company.related_id#
                </cfquery>
                <cftry>
                    <!--- Muhasebe kodu ve cari hesap karakteri 10 ve ilk 3 karekteri 120 ise CRMTOBOYUT a kayit at--->
                    <cfif (len(get_company.muhasebekod) eq 10) and (len(get_company.carihesapkod) eq 10) and (left(get_company.muhasebekod,3) eq 120) and (left(get_company.carihesapkod,3) eq 120)>
                        <cflock name="AddCrmBoyut" timeout="60">
                            <cftransaction>
                                <cfquery name="ADD_COMPANY" datasource="mushizgun">
                                    INSERT INTO
                                        CRMTOBOYUT 
                                    (
                                        HEDEFKODU,
                                        GLNCODE,
                                        DEPOKOD,
                                        HESAPKODU,
                                        ISYERIADI,
                                        ADI,
                                        SOYADI,
                                        MDURUM,
                                        MAHALLE,
                                        CADDE,
                                        SOKAK,
                                        NUMARA,
                                        SEMT,
                                        ILCE,
                                        IL,
                                        ILCEKODU,
                                        TELEFON,
                                        FAX,
                                        POSTAKODU,
                                        VERGIDAIRE,
                                        VERGINO,
                                        BSM,
                                        TELEFONCU,
                                        TAHSILDAR,
                                        PLASIYER,
                                        PLASIYER2,
                                        MUHKOD,
                                        IMSKOD501,
                                        IMSKOD101,
                                        ACTAR,
                                        CARITIP,
                                        CEPSIRA,
                                        BOLGEKODU,
                                        ALTBOLGEKD,
                                        UZAKLIK,
                                        PLAKA,
                                        CALISSEKLI,
                                        PUAN,
                                        KAYITTIPI,
                                        EKLENMETAR,
                                        EKLEMETALEP,
                                        EKLEMEIP,
                                        KAYITDURUM,
                                        RISKTOP,
                                        GRUPRISKTOP,
                                        MTIP,
                                        INKABSM,
                                        INKATELEFONCU,
                                        INKATAHSILDAR,
                                        INKAPLASIYER,
                                        INKAPLASIYER2,
                                        EMAIL,
                                        ADRES,
                                        TCKIMLIKNO,
                                        RELATED_ID,
                                        TYPE_ID,
                                        LOGO_MUSTERI_TIP					
                                    )
                                    VALUES
                                    (
                                        #get_company.company_id#,
                                        '#get_company.glncode#',
                                        '#get_company.boyut_kodu#',
                                        <cfif len(get_company.carihesapkod)>'#get_company.carihesapkod#'<cfelse>'0'</cfif>,
                                        '#tr_to_iso(get_company.fullname)#',
                                        '#tr_to_iso(get_company.company_partner_name)#',
                                        '#tr_to_iso(get_company.company_partner_surname)#',
                                        <cfif len(get_company.musteridurum)>#get_company.musteridurum#<cfelse>0</cfif>,
                                        '#tr_to_iso(get_company.district)#',
                                        '#tr_to_iso(get_company.main_street)#',
                                        '#tr_to_iso(get_company.street)#',
                                        '#tr_to_iso(get_company.dukkan_no)#',
                                        '#tr_to_iso(get_company.semt)#',
                                        '#tr_to_iso(get_company.county_name)#',
                                        '#tr_to_iso(get_company.city_name)#',
                                        #get_company.county_id#,
                                        '#get_company.company_telcode# #get_company.company_tel1#',
                                        <cfif len(get_company.company_fax)>'#get_company.company_fax_code# #get_company.company_fax#'<cfelse>'0'</cfif>,
                                        <cfif len(get_company.company_postcode)>'#get_company.company_postcode#'<cfelse>'0'</cfif>,
                                        '#tr_to_iso(get_company.taxoffice)#',
                                        '#get_company.taxno#',
                                        <cfif len(get_company.boyut_bsm)>'#get_company.boyut_bsm#'<cfelse>'0'</cfif>,
                                        <cfif len(get_company.boyut_telefon)>'#get_company.boyut_telefon#'<cfelse>'0'</cfif>,
                                        <cfif len(get_company.boyut_tahsilat)>'#get_company.boyut_tahsilat#'<cfelse>'0'</cfif>,
                                        <cfif len(get_company.boyut_plasiyer)>'#get_company.boyut_plasiyer#'<cfelse>'0'</cfif>,
                                        <cfif len(get_company.boyut_itriyat)>'#get_company.boyut_itriyat#'<cfelse>'0'</cfif>,
                                        '#muhasebekod1# #muhasebekod2# #muhasebekod3#',
                                        '#tr_to_iso(get_company.ims_code_501)#',
                                        '#tr_to_iso(get_company.ims_code)#',
                                        '#tarih_open#',
                                        'E',
                                        <cfif len(get_company.cep_sira)>'#tr_to_iso(get_company.cep_sira)#'<cfelse>'0'</cfif>,
                                        <cfif len(get_company.bolge_kodu)>'#tr_to_iso(get_company.bolge_kodu)#'<cfelse>'0'</cfif>,
                                        <cfif len(get_company.altbolge_kodu)>'#tr_to_iso(get_company.altbolge_kodu)#'<cfelse>'0'</cfif>,
                                        <cfif len(get_company.depot_km)>#get_company.depot_km#<cfelse>'0'</cfif>,
                                        #get_company.plate_code#,
                                        <cfif len(get_company.calisma_sekli)>'#get_company.calisma_sekli#'<cfelse>'0'</cfif>,
                                        <cfif len(get_company.puan)>'#tr_to_iso(get_company.puan)#'<cfelse>'0'</cfif>,
                                        #attributes.kayittipi#,
                                        #now()#,
                                        #session.ep.userid#,
                                        '#cgi.remote_addr#',
                                        0,
                                        <cfif len(risc_limit_value_)>#risc_limit_value_#<cfelse>0</cfif>,
                                        <cfif len(get_company.grup_risk_limit)>#get_company.grup_risk_limit#<cfelse>0</cfif>,
                                        <cfif len(get_company.companycat_id)>#get_company.companycat_id#<cfelse>0</cfif>,
                                        <cfif len(get_company.sales_director)>#get_company.sales_director#<cfelse>0</cfif>,
                                        <cfif len(get_company.tel_sale_preid)>#get_company.tel_sale_preid#<cfelse>0</cfif>,
                                        <cfif len(get_company.tahsilatci)>#get_company.tahsilatci#<cfelse>0</cfif>,
                                        <cfif len(get_company.plasiyer_id)>#get_company.plasiyer_id#<cfelse>0</cfif>,
                                        <cfif len(get_company.itriyat_gorevli)>#get_company.itriyat_gorevli#<cfelse>0</cfif>,
                                        <cfif len(get_company.company_email)>'#tr_to_iso(get_company.company_email)#'<cfelse>'-'</cfif>,
                                        <cfif len(get_company.company_address)>'#tr_to_iso(get_company.company_address)#'<cfelse>'-'</cfif>,
                                        <cfif len(get_company.tc_identity)>'#get_company.tc_identity#'<cfelse>' '</cfif>,
                                        #risc_related_id_#,
                                        8,
                                        <cfif len(get_company.logo_musteri_tip)>'#get_company.logo_musteri_tip#'<cfelse>'0'</cfif>
                                    )
                                </cfquery>
                            </cftransaction>
                        </cflock>
                        <cfset attributes.is_boyut_insert = true>
                    <cfelse>
                        <cfset attributes.is_boyut_insert = false>	
                    </cfif>
                    <cfcatch>
                        <cfset attributes.is_boyut_insert = false>
                    </cfcatch>
                </cftry>
                <cfif attributes.is_boyut_insert>
                    <!--- Mail icin eklenmistir FS --->
                    <cfquery name="get_depo" datasource="#dsn#">
                        SELECT
                            CBDK.DEPO_ISMI,
                            CBDK.SUBE_POS_CODE,
                            CBDK.OPERASYON_POS_CODE,
                            CBDK.FINANS_POS_CODE,
                            C.COMPANY_ID,
                            C.FULLNAME
                        FROM
                            COMPANY_RISK_REQUEST CRR,
                            COMPANY_BOYUT_DEPO_KOD CBDK,
                            COMPANY C
                        WHERE
                            CRR.BRANCH_ID = CBDK.W_KODU AND
                            CRR.COMPANY_ID = C.COMPANY_ID AND
                            CRR.REQUEST_ID = #get_max_risk.max_id#
                    </cfquery>
                    <cfif get_depo.recordcount>
                        <cfquery name="get_mail_info" datasource="#dsn#">
                            SELECT
                                EMPLOYEE_NAME,
                                EMPLOYEE_SURNAME,
                                EMPLOYEE_EMAIL
                            FROM
                                EMPLOYEE_POSITIONS
                            WHERE
                                IS_MASTER = 1 AND
                                (
                                    <cfif len(get_depo.sube_pos_code)>POSITION_CODE = #get_depo.sube_pos_code# OR</cfif>
                                    <cfif len(get_depo.operasyon_pos_code)>POSITION_CODE = #get_depo.operasyon_pos_code# OR</cfif>
                                    <cfif len(get_depo.finans_pos_code)>POSITION_CODE = #get_depo.finans_pos_code# OR</cfif>
                                    1 = 0 <!--- OR ifadelerinin acikta kalmamasi icin --->
                                 )
                        </cfquery>
                        <cfif get_mail_info.recordcount>
                        <cfoutput query="get_mail_info">
                            <cfsavecontent variable="insert_message">
                                <html>
                                    <meta name="Language" content="Turkish">
                                    <meta http-equiv="Content-Type" content="text/html; charset=utf-8">
                                    <style>
                                        .form-title {
                                            font-family: Verdana, Arial, Helvetica, sans-serif;
                                            font-size: 9px; }
                                        .form-title1 {
                                            font-family: Verdana, Arial, Helvetica, sans-serif;
                                            font-size: 10px;
                                            font-weight: bold; }
                                        .form-title2 {
                                            font-family: Verdana, Arial, Helvetica, sans-serif;
                                            font-size: 14px;
                                            font-weight: bold; }
                                        .form-title3 {
                                            font-family: Verdana, Arial, Helvetica, sans-serif;
                                            font-size: 12px;  }
                                    </style>
                                    <body>
                                    <table cellspacing="1" cellpadding="2" border="0" width="98%" align="center" class="color-border">
                                        <tr>
                                            <td colspan="19" class="form-title3">
                                                <p>Sayın #employee_name# #employee_surname#,</p>
                                                <a href="http://crm.hedefim.com/index.cfm?fuseaction=crm.detail_company&cpid=#get_depo.company_id#&is_search=1">#get_depo.fullname#</a>
                                                - #get_depo.depo_ismi# Şubesi için yapılan Çoklu Risk Raporundan Yapılan Risk Limiti Aktif Hale Getirilmiştir.
                                                <br><br><br><br>
                                            </td>
                                        </tr>
                                    </table>
                                    </body>
                                </html>
                            </cfsavecontent>
                            <cfif len(employee_email)>
                                <cfmail 
                                    to ="#employee_email#"
                                    from="Risk Komitesi<riskkomitesi@hedefalliance.com.tr>"
                                    subject="Çoklu Risk Raporundan Yapılan Risk Limiti Hk." 
                                    charset="utf-8" 
                                    type="html">						
                                    <br>#insert_message#
                                </cfmail>
                            </cfif>
                        </cfoutput>
                        </cfif>
                    </cfif>						
                <cfelse>
                    <cfsavecontent variable="insert_error_message">
                    <table cellspacing="0" cellpadding="0" width="500" border="0" align="center">
                        <cfoutput>
                          <tr>
                            <td style="font-size:11px;font-family: Geneva,  tahoma, arial,Helvetica, sans-serif;">Çoklu Risk Raporundan Yapılan Risk Limiti Eklemede Hata Meydana Geldi.</td>
                          </tr>
                          <tr>
                            <td style="font-size:11px;font-family: Geneva,  tahoma, arial,Helvetica, sans-serif;">Müşteri Workcube ID : #risc_company_id_#</td>
                          </tr>
                          <tr>
                            <td style="font-size:11px;font-family: Geneva,  tahoma, arial,Helvetica, sans-serif;">İşlem Tip : #attributes.kayittipi#</td>
                          </tr>
                        </cfoutput>
                    </table>
                    </cfsavecontent>
                    <cfmail from="Risk Komitesi<riskkomitesi@hedefalliance.com.tr>" 
                            to="barbaroskuz@workcube.com" 
                            subject="Çoklu Risk Raporundan Yapılan Risk Limiti Ekleme Hatası" 
                            type="html">
                        <cfoutput>#insert_error_message#</cfoutput>
                    </cfmail>
                    <cffile action="write" file="#upload_folder#member#dir_seperator#mushiz_hata#risc_company_id_#.txt" output="#toString(insert_error_message)#" charset="UTF-8">
                </cfif>
            </cfif>
        </cfif>
    </cfloop>
<cflocation url="#request.self#?fuseaction=report.detail_report&event=det&report_id=#url.report_id#" addtoken="No">